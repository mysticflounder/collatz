"""Extended cycle search for the modular Collatz map.

Pushes exhaustive cycle enumeration beyond k=30 using two regimes:
  Regime A (k <= 32): Precomputed numpy arrays (~13 GB at k=32)
  Regime B (k = 33..36): On-the-fly computation with optional Numba JIT (~4 GB at k=36)

Searches all odd residues mod 2^k for cycles of the Syracuse successor map
S(j) = (3j+1)/2^v mod 2^k, where v = v_2(3j+1).
"""

import json
import sys
import time

import numpy as np

try:
    from numba import njit

    HAS_NUMBA = True
except ImportError:
    HAS_NUMBA = False

# Known exceptional set E ∩ [3,30] for verification
KNOWN_EXCEPTIONAL = {10, 11, 12, 20}
# Known cycle counts per k (k -> number of cycles), k=3..24
# Non-exceptional k have exactly 1 cycle (the fixed point {1}).
# Exceptional k have additional cycles.
KNOWN_CYCLE_COUNTS = {}
for _k in range(3, 25):
    if _k == 10 or _k == 11:
        KNOWN_CYCLE_COUNTS[_k] = 2
    elif _k == 12:
        KNOWN_CYCLE_COUNTS[_k] = 3
    elif _k == 20:
        KNOWN_CYCLE_COUNTS[_k] = 2
    else:
        KNOWN_CYCLE_COUNTS[_k] = 1


def syracuse_successor_scalar(j, mod):
    """Compute Syracuse successor and 2-adic valuation for a single odd residue.

    Returns (successor mod `mod`, valuation v).
    """
    val = 3 * j + 1
    v = 0
    while val % 2 == 0:
        val //= 2
        v += 1
    return val % mod, v


def build_successor_array(k):
    """Build successor and valuation arrays for all odd residues mod 2^k.

    Uses chunked vectorized computation to control intermediate memory.
    Returns (succ, v_arr) where indices map as: odd residue j = 2*i + 1.
    """
    mod = 1 << k
    n = mod >> 1  # number of odd residues

    succ = np.empty(n, dtype=np.uint32)
    v_arr = np.empty(n, dtype=np.uint8)

    chunk_size = 1 << 24  # 16M entries per chunk
    for i_start in range(0, n, chunk_size):
        i_end = min(i_start + chunk_size, n)
        indices = np.arange(i_start, i_end, dtype=np.uint64)
        j = 2 * indices + 1

        val = 3 * j + 1

        # Compute v = v_2(val) via bit tricks
        lowest_bit = val & (-val)  # isolate lowest set bit
        v = np.log2(lowest_bit.astype(np.float64)).astype(np.uint8)

        odd_part = val >> v.astype(np.uint64)
        succ_res = odd_part % mod
        succ_idx = ((succ_res - 1) // 2).astype(np.uint32)

        succ[i_start:i_end] = succ_idx
        v_arr[i_start:i_end] = v

    return succ, v_arr


def find_cycles_stored(k):
    """Regime A: Find all cycles using precomputed successor arrays.

    Suitable for k <= 32 (~13 GB at k=32).
    """
    mod = 1 << k
    n = mod >> 1

    print(f"    Building successor array (n={n:,d})...", flush=True)
    t0 = time.time()
    succ, v_arr = build_successor_array(k)
    t_build = time.time() - t0
    mem_gb = (succ.nbytes + v_arr.nbytes + n) / (1 << 30)
    print(
        f"    Built in {t_build:.1f}s, arrays ~{succ.nbytes / (1 << 30):.1f} + "
        f"{v_arr.nbytes / (1 << 30):.1f} GB",
        flush=True,
    )

    visited = np.zeros(n, dtype=np.bool_)
    cycles = []

    print("    Searching for cycles...", flush=True)
    t0 = time.time()
    report_interval = max(n // 20, 1)

    for start_idx in range(n):
        if visited[start_idx]:
            continue

        # Follow the path from start_idx
        path = []
        path_set = set()
        cur = int(start_idx)

        while not visited[cur] and cur not in path_set:
            path.append(cur)
            path_set.add(cur)
            cur = int(succ[cur])

        if cur in path_set:
            cycle_start = path.index(cur)
            cycle_indices = path[cycle_start:]
            # Compute mean v for this cycle
            mean_v = sum(int(v_arr[i]) for i in cycle_indices) / len(cycle_indices)
            cycle_residues = [2 * i + 1 for i in cycle_indices]
            cycles.append(
                {
                    "residues": cycle_residues,
                    "length": len(cycle_indices),
                    "mean_v": mean_v,
                    "rho": 2.0 ** (-mean_v),
                }
            )

        for i in path:
            visited[i] = True

        if start_idx % report_interval == 0 and start_idx > 0:
            pct = 100.0 * start_idx / n
            elapsed = time.time() - t0
            print(
                f"      {pct:.0f}% ({start_idx:,d}/{n:,d}), "
                f"elapsed {elapsed:.0f}s, {len(cycles)} cycle(s)",
                flush=True,
            )

    t_search = time.time() - t0
    return cycles, t_build, t_search, mem_gb


# --- Regime B: On-the-fly with optional Numba ---

if HAS_NUMBA:

    @njit(cache=True)
    def _follow_path_numba(start_idx, visited_bits, mod):
        """Follow a path from start_idx, computing successors on the fly.

        visited_bits is a uint8 array used as a bitarray.
        Returns (path_array, path_len, cycle_start_pos).
        cycle_start_pos = -1 means no cycle found from this start.
        """
        # Max path length; empirically paths are short
        max_path = 16384
        path = np.empty(max_path, dtype=np.int64)
        path_len = 0

        cur = start_idx
        while path_len < max_path:
            # Check visited
            byte_idx = cur >> 3
            bit_mask = np.uint8(1 << (cur & 7))
            if visited_bits[byte_idx] & bit_mask:
                break

            # Check if cur is already in path (cycle detection)
            found_in_path = False
            for p in range(path_len):
                if path[p] == cur:
                    found_in_path = True
                    break
            if found_in_path:
                # Found a cycle
                cycle_start_pos = -1
                for p in range(path_len):
                    if path[p] == cur:
                        cycle_start_pos = p
                        break
                return path, path_len, cycle_start_pos

            path[path_len] = cur
            path_len += 1

            # Compute successor on the fly
            j = np.uint64(2) * np.uint64(cur) + np.uint64(1)
            val = np.uint64(3) * j + np.uint64(1)
            v = 0
            while val & np.uint64(1) == np.uint64(0):
                val >>= np.uint64(1)
                v += 1
            succ_j = val % np.uint64(mod)
            cur = np.int64((succ_j - np.uint64(1)) >> np.uint64(1))

        return path, path_len, np.int64(-1)

    @njit(cache=True)
    def _compute_v_scalar(idx, mod):
        """Compute v_2(3*(2*idx+1)+1)."""
        j = np.uint64(2) * np.uint64(idx) + np.uint64(1)
        val = np.uint64(3) * j + np.uint64(1)
        v = 0
        while val & np.uint64(1) == np.uint64(0):
            val >>= np.uint64(1)
            v += 1
        return v

    @njit(cache=True)
    def _compute_succ_scalar(idx, mod):
        """Compute successor index on the fly."""
        j = np.uint64(2) * np.uint64(idx) + np.uint64(1)
        val = np.uint64(3) * j + np.uint64(1)
        while val & np.uint64(1) == np.uint64(0):
            val >>= np.uint64(1)
        succ_j = val % np.uint64(mod)
        return np.int64((succ_j - np.uint64(1)) >> np.uint64(1))


def _follow_path_python(start_idx, visited_bits, mod):
    """Pure Python fallback for _follow_path_numba."""
    path = []
    path_set = set()
    cur = start_idx

    while True:
        # Check visited
        byte_idx = cur >> 3
        bit_mask = 1 << (cur & 7)
        if visited_bits[byte_idx] & bit_mask:
            break

        if cur in path_set:
            cycle_start_pos = path.index(cur)
            return path, len(path), cycle_start_pos

        path.append(cur)
        path_set.add(cur)

        # Compute successor on the fly
        j = 2 * cur + 1
        val = 3 * j + 1
        while val % 2 == 0:
            val //= 2
        succ_j = val % mod
        cur = (succ_j - 1) // 2

    return path, len(path), -1


def find_cycles_onthefly(k):
    """Regime B: Find all cycles computing successors on the fly.

    Uses packed bitarray for visited set. Optionally uses Numba for the inner loop.
    Suitable for k = 33..36 (~4 GB at k=36).
    """
    mod = 1 << k
    n = mod >> 1

    # Packed bitarray: 1 bit per residue
    n_bytes = (n + 7) // 8
    visited_bits = np.zeros(n_bytes, dtype=np.uint8)
    mem_gb = n_bytes / (1 << 30)
    print(f"    Visited bitarray: {mem_gb:.2f} GB", flush=True)

    use_numba = HAS_NUMBA
    if use_numba:
        print("    Using Numba JIT (warming up)...", flush=True)
        # Warm up JIT with a trivial call
        _dummy_bits = np.zeros(1, dtype=np.uint8)
        _follow_path_numba(np.int64(0), _dummy_bits, np.uint64(8))
        _compute_v_scalar(np.int64(0), np.uint64(8))
        print("    Numba ready.", flush=True)
    else:
        print("    Numba not available, using pure Python (will be slow).", flush=True)

    follow_fn = _follow_path_numba if use_numba else _follow_path_python

    cycles = []
    t0 = time.time()
    report_interval = max(n // 20, 1)

    print(f"    Searching {n:,d} residues...", flush=True)

    for start_idx in range(n):
        # Check visited
        byte_idx = start_idx >> 3
        bit_mask = 1 << (start_idx & 7)
        if visited_bits[byte_idx] & bit_mask:
            continue

        if use_numba:
            path_arr, path_len, cycle_start_pos = follow_fn(
                np.int64(start_idx), visited_bits, np.uint64(mod)
            )
            path = [int(path_arr[i]) for i in range(path_len)]
        else:
            path, path_len, cycle_start_pos = follow_fn(start_idx, visited_bits, mod)

        if cycle_start_pos >= 0:
            cycle_indices = path[cycle_start_pos:]
            if use_numba:
                mean_v = sum(
                    _compute_v_scalar(np.int64(i), np.uint64(mod)) for i in cycle_indices
                ) / len(cycle_indices)
            else:
                mean_v = 0.0
                for i in cycle_indices:
                    j = 2 * i + 1
                    val = 3 * j + 1
                    v = 0
                    while val % 2 == 0:
                        val //= 2
                        v += 1
                    mean_v += v
                mean_v /= len(cycle_indices)

            cycle_residues = [2 * i + 1 for i in cycle_indices]
            cycles.append(
                {
                    "residues": cycle_residues,
                    "length": len(cycle_indices),
                    "mean_v": mean_v,
                    "rho": 2.0 ** (-mean_v),
                }
            )

        # Mark all path elements as visited
        for i in path:
            byte_idx = i >> 3
            bit_mask = np.uint8(1 << (i & 7))
            visited_bits[byte_idx] |= bit_mask

        if start_idx % report_interval == 0 and start_idx > 0:
            pct = 100.0 * start_idx / n
            elapsed = time.time() - t0
            print(
                f"      {pct:.0f}% ({start_idx:,d}/{n:,d}), "
                f"elapsed {elapsed:.0f}s, {len(cycles)} cycle(s)",
                flush=True,
            )

    t_search = time.time() - t0
    return cycles, 0.0, t_search, mem_gb


def verify_known_results():
    """Verify cycle search against known results for k=3..24."""
    print("Verification: checking k=3..24 against known results")
    print("=" * 60)
    all_pass = True

    for k in range(3, 25):
        mod = 1 << k
        n = mod >> 1

        # Use stored regime for verification (small k)
        succ, v_arr = build_successor_array(k)
        visited = np.zeros(n, dtype=np.bool_)
        cycles = []

        for start_idx in range(n):
            if visited[start_idx]:
                continue
            path = []
            path_set = set()
            cur = int(start_idx)
            while not visited[cur] and cur not in path_set:
                path.append(cur)
                path_set.add(cur)
                cur = int(succ[cur])
            if cur in path_set:
                cycle_start = path.index(cur)
                cycles.append(path[cycle_start:])
            for i in path:
                visited[i] = True

        expected = KNOWN_CYCLE_COUNTS[k]
        is_exceptional = len(cycles) > 1
        expected_exceptional = k in KNOWN_EXCEPTIONAL
        ok = len(cycles) == expected and is_exceptional == expected_exceptional

        status = "PASS" if ok else "FAIL"
        if not ok:
            all_pass = False
        exc_mark = " *E*" if is_exceptional else ""
        print(f"  k={k:2d}: {len(cycles)} cycle(s), expected {expected}  [{status}]{exc_mark}")

    print()
    if all_pass:
        print("All verifications PASSED.")
    else:
        print("SOME VERIFICATIONS FAILED!")
    print()
    return all_pass


def run_search(k_min, k_max):
    """Run cycle search for k=k_min..k_max and write results to JSON."""
    results = []
    regime_a_limit = 32

    print(f"Extended cycle search: k={k_min}..{k_max}")
    print(f"Numba available: {HAS_NUMBA}")
    print("=" * 60)
    print()

    for k in range(k_min, k_max + 1):
        mod = 1 << k
        n = mod >> 1
        regime = "A (stored)" if k <= regime_a_limit else "B (on-the-fly)"
        print(f"  k={k}: regime {regime}, n={n:,d} odd residues")

        t_total_start = time.time()

        if k <= regime_a_limit:
            cycles, t_build, t_search, mem_gb = find_cycles_stored(k)
        else:
            cycles, t_build, t_search, mem_gb = find_cycles_onthefly(k)

        t_total = time.time() - t_total_start

        rho_k = max((c["rho"] for c in cycles), default=0.0)
        is_exceptional = len(cycles) > 1

        cycle_summary = []
        for c in cycles:
            cycle_summary.append(f"L={c['length']},mv={c['mean_v']:.3f},rho={c['rho']:.6f}")

        print(
            f"    {len(cycles)} cycle(s), rho={rho_k:.6f}, "
            f"time={t_total:.1f}s, mem~{mem_gb:.1f}GB"
            f"{'  **EXCEPTIONAL**' if is_exceptional else ''}"
        )
        for s in cycle_summary:
            print(f"      {s}")
        print()

        result = {
            "k": k,
            "mod": mod,
            "n_residues": n,
            "regime": regime,
            "n_cycles": len(cycles),
            "rho": rho_k,
            "is_exceptional": is_exceptional,
            "time_build_s": round(t_build, 2),
            "time_search_s": round(t_search, 2),
            "time_total_s": round(t_total, 2),
            "mem_gb": round(mem_gb, 2),
            "cycles": [
                {
                    "length": c["length"],
                    "mean_v": c["mean_v"],
                    "rho": c["rho"],
                    "min_residue": min(c["residues"]),
                }
                for c in cycles
            ],
        }
        results.append(result)

    # Write results
    output_path = "analysis/cycle_search_results.json"
    with open(output_path, "w", encoding="utf-8") as f:
        json.dump(
            {
                "description": "Extended cycle search for modular Collatz map S(j)=(3j+1)/2^v mod 2^k",
                "numba": HAS_NUMBA,
                "k_range": [k_min, k_max],
                "exceptional_set": sorted(r["k"] for r in results if r["is_exceptional"]),
                "results": results,
            },
            f,
            indent=2,
        )
    print(f"Results written to {output_path}")

    # Summary
    print()
    print("Summary")
    print("=" * 60)
    exc_found = [r["k"] for r in results if r["is_exceptional"]]
    print(f"  Exceptional k in [{k_min},{k_max}]: {exc_found if exc_found else 'none'}")
    print(f"  E ∩ [3,{k_max}] = {sorted(KNOWN_EXCEPTIONAL | set(exc_found))}")

    return results


if __name__ == "__main__":
    import matplotlib

    matplotlib.use("Agg")

    # Step 1: Verify against known results
    if not verify_known_results():
        print("Verification failed! Aborting extended search.", file=sys.stderr)
        sys.exit(1)

    # Step 2: Run extended search
    # Default: k=25..36 (can be overridden via command line)
    k_min = int(sys.argv[1]) if len(sys.argv) > 1 else 25
    k_max = int(sys.argv[2]) if len(sys.argv) > 2 else 36

    run_search(k_min, k_max)
