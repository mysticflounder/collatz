"""Residue class compression for the Collatz map.

For a residue r mod 2^k, the first k Collatz steps are fully determined.
After k steps, the result has the form (multiplier * n + offset) / 2^divisions
for any n ≡ r (mod 2^k).
"""


def compress_steps(residue: int, k: int) -> dict:
    """Compute the compressed Collatz map for a single residue class mod 2^k.

    Simulates k Collatz steps on the residue, tracking the affine transformation
    applied to the original value n. After k steps:
        result = (multiplier * n + offset) / 2^divisions

    Returns dict with keys: multiplier, offset, divisions.
    """
    mod = 2**k
    multiplier = 1
    offset = 0
    divisions = 0
    r = residue

    for _ in range(k):
        if r % 2 == 0:
            divisions += 1
            r = r // 2
        else:
            multiplier = multiplier * 3
            offset = offset * 3 + 2**divisions
            r = (3 * r + 1) % mod

    return {"multiplier": multiplier, "offset": offset, "divisions": divisions}


def compressed_map(k: int) -> list[dict]:
    """Build the full compressed Collatz map for all residues mod 2^k.

    Returns a list of dicts, one per residue class, each with keys:
    multiplier, offset, divisions, shrinks (bool).
    """
    results = []
    for r in range(2**k):
        entry = compress_steps(r, k)
        entry["residue"] = r
        entry["shrinks"] = entry["multiplier"] < 2 ** entry["divisions"]
        results.append(entry)
    return results


def shrink_fraction(k: int) -> float:
    """Fraction of residue classes mod 2^k that shrink after k compressed steps."""
    cmap = compressed_map(k)
    shrinking = sum(1 for entry in cmap if entry["shrinks"])
    return shrinking / len(cmap)
