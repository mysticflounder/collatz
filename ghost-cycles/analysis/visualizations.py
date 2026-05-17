"""Visualization tools for Collatz transfer matrix dynamics.

Generates animated and static visualizations of the Syracuse map's
functional graph, showing ghost cycles appearing at exceptional levels.

Usage:
    /home/adam/pythonprojects/.venv/bin/python3 analysis/visualizations.py
"""

import matplotlib
import numpy as np

matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation, PillowWriter
from matplotlib.collections import LineCollection
from matplotlib.patches import Circle


def compute_successor(k):
    """Compute Syracuse successor for all odd residues mod 2^k.

    Returns (succ, vals) where succ[i] is the successor index
    and vals[i] is v_2(3*(2i+1) + 1).
    """
    mod = 2**k
    n = 2 ** (k - 1)
    succ = np.zeros(n, dtype=np.int64)
    vals = np.zeros(n, dtype=np.int64)
    for i in range(n):
        j = 2 * i + 1
        val_j = 3 * j + 1
        v = 0
        tmp = val_j
        while tmp % 2 == 0:
            tmp //= 2
            v += 1
        t = tmp % mod
        succ[i] = (t - 1) // 2
        vals[i] = v
    return succ, vals


def find_cycles(succ):
    """Find all cycles in the successor graph."""
    n = len(succ)
    visited = np.zeros(n, dtype=bool)
    cycles = []
    for start in range(n):
        if visited[start]:
            continue
        path = []
        seen = set()
        cur = start
        while not visited[cur] and cur not in seen:
            path.append(cur)
            seen.add(cur)
            cur = succ[cur]
        if cur in seen:
            ci = path.index(cur)
            cycles.append(path[ci:])
        for node in path:
            visited[node] = True
    return cycles


def bezier_arc(p0, p2, curvature=0.4, n_points=40):
    """Quadratic Bezier arc between two points, bowing toward origin."""
    mid = (p0 + p2) / 2
    p1 = mid * (1 - curvature)
    t = np.linspace(0, 1, n_points).reshape(-1, 1)
    return (1 - t) ** 2 * p0 + 2 * (1 - t) * t * p1 + t**2 * p2


def draw_chord_frame(ax, k, show_tree_edges=True):
    """Draw a chord diagram of the Syracuse map at resolution k.

    Odd residues are placed around a circle; successor relationships
    are drawn as chords. Ghost cycles are highlighted in bright colors.
    """
    succ, vals = compute_successor(k)
    cycles = find_cycles(succ)
    n = len(succ)

    ax.clear()
    ax.set_xlim(-1.55, 1.55)
    ax.set_ylim(-1.75, 1.55)
    ax.set_aspect("equal")
    ax.set_facecolor("#080810")
    ax.axis("off")

    # Node positions on a circle
    angles = np.linspace(0, 2 * np.pi, n, endpoint=False) - np.pi / 2
    node_x = np.cos(angles)
    node_y = np.sin(angles)

    # Identify cycles and trivial fixed point
    cycle_membership = {}
    trivial_idx = None
    for ci, cycle in enumerate(cycles):
        for node in cycle:
            cycle_membership[node] = ci
        if 0 in cycle:
            trivial_idx = ci

    ghost_palette = ["#00e5ff", "#ff5722", "#e040fb", "#76ff03"]

    # Tree edges (straight chords from non-cycle nodes to successors)
    if show_tree_edges:
        segs = []
        for i in range(n):
            j = succ[i]
            if i not in cycle_membership:
                segs.append([(node_x[i], node_y[i]), (node_x[j], node_y[j])])
        if segs:
            scale = 256 / max(n, 1)
            lw = max(0.15, 0.5 * scale)
            alpha = max(0.15, 0.35 * scale)
            lc = LineCollection(segs, colors="#5577aa", linewidths=lw, alpha=alpha)
            ax.add_collection(lc)

    # Node dots — brighter for large n so the ring is visible
    dot_size = max(0.5, 60.0 / n)
    dot_alpha = min(0.6, max(0.35, 0.15 + 0.05 * (n / 256)))
    ax.scatter(node_x, node_y, s=dot_size, c="#4466aa", alpha=dot_alpha, zorder=1)

    # Cycle edges (bright Bezier arcs)
    for ci, cycle in enumerate(cycles):
        if ci == trivial_idx:
            color = "#ffd700"
        else:
            gi = sum(1 for x_ci in range(ci) if x_ci != trivial_idx)
            color = ghost_palette[gi % len(ghost_palette)]

        cycle_len = len(cycle)

        if cycle_len == 1:
            # Fixed point: draw a small loop
            node = cycle[0]
            dx = node_x[node] * 0.08
            dy = node_y[node] * 0.08
            circ = Circle(
                (node_x[node] + dx, node_y[node] + dy),
                0.06,
                fill=False,
                edgecolor=color,
                linewidth=2.5,
                zorder=4,
            )
            ax.add_patch(circ)
            ax.scatter(
                [node_x[node]],
                [node_y[node]],
                s=40,
                c=color,
                zorder=5,
                edgecolors="white",
                linewidths=0.5,
            )
        else:
            # Multi-node cycle: Bezier arcs
            segs = []
            for i_c in range(cycle_len):
                n1 = cycle[i_c]
                n2 = cycle[(i_c + 1) % cycle_len]
                p0 = np.array([node_x[n1], node_y[n1]])
                p2 = np.array([node_x[n2], node_y[n2]])
                arc = bezier_arc(p0, p2, curvature=0.4)
                segs.append(arc.tolist())

            lw = 2.5 if ci != trivial_idx else 2.0
            lc = LineCollection(segs, colors=color, linewidths=lw, alpha=0.9, zorder=3)
            ax.add_collection(lc)

            # Cycle node highlights
            cx = [node_x[nd] for nd in cycle]
            cy = [node_y[nd] for nd in cycle]
            ms = max(3, 10 - k // 2)
            ax.scatter(cx, cy, s=ms**2, c=color, zorder=5, edgecolors="white", linewidths=0.3)

    # Info box
    rho_max = 0
    cycle_details = []
    for ci, cycle in enumerate(cycles):
        cycle_len = len(cycle)
        total_v = sum(int(vals[nd]) for nd in cycle)
        rho = 2 ** (-total_v / cycle_len)
        rho_max = max(rho_max, rho)
        if ci != trivial_idx:
            cycle_details.append(f"  Ghost: L={cycle_len}, V={total_v}, \u03c1={rho:.4f}")

    num_ghost = len(cycles) - (1 if trivial_idx is not None else 0)
    lines = [f"k = {k}", f"{n} odd residues mod 2\u1d4f"]
    if num_ghost > 0:
        ghost_word = "ghost cycle" + ("s" if num_ghost > 1 else "")
        lines.append(f"{num_ghost} {ghost_word}")
        lines.extend(cycle_details)
    lines.append(f"\u03c1\u2096 = {rho_max:.4f}")

    ax.text(
        -1.48,
        -1.68,
        "\n".join(lines),
        color="white",
        fontsize=9,
        verticalalignment="bottom",
        fontfamily="monospace",
        bbox={
            "boxstyle": "round,pad=0.4",
            "facecolor": "#12122a",
            "edgecolor": "#333366",
            "alpha": 0.85,
        },
    )

    # Title
    if num_ghost > 0:
        ax.set_title(
            "GHOST CYCLE DETECTED", color="#00e5ff", fontsize=16, fontweight="bold", pad=12
        )
    else:
        ax.set_title("Syracuse Map \u2014 Functional Graph", color="#888899", fontsize=14, pad=12)


def animate_functional_graph(k_min=3, k_max=13, output="analysis/functional_graph.gif"):
    """Generate animated chord diagram GIF.

    Each frame shows the Syracuse successor map at resolution k.
    Ghost cycles (extra modular cycles beyond the fixed point {1})
    are highlighted in cyan. Frames with ghost cycles are held longer.
    """
    print(f"Generating functional graph animation k={k_min}..{k_max}")

    fig, ax = plt.subplots(figsize=(10, 10))
    fig.set_facecolor("#080810")

    k_values = list(range(k_min, k_max + 1))

    # Build frame sequence: repeat ghost frames for emphasis
    frames = []
    for k in k_values:
        succ, _ = compute_successor(k)
        cycles = find_cycles(succ)
        has_ghost = len(cycles) > 1
        repeats = 3 if has_ghost else 1
        frames.extend([k] * repeats)

    def update(frame_idx):
        k = frames[frame_idx]
        draw_chord_frame(ax, k, show_tree_edges=(k <= 8))

    anim = FuncAnimation(fig, update, frames=len(frames), interval=1500)

    try:
        writer = PillowWriter(fps=1)
        anim.save(output, writer=writer, dpi=120)
        print(f"  Saved {output}")
    except Exception as e:
        print(f"  GIF save failed ({e}), saving PNG frames instead")
        for k in k_values:
            draw_chord_frame(ax, k, show_tree_edges=(k <= 8))
            fig.savefig(f"analysis/chord_k{k:02d}.png", dpi=120, facecolor=fig.get_facecolor())
            print(f"  Saved analysis/chord_k{k:02d}.png")
    plt.close(fig)


def plot_digit_stabilization(output="analysis/figures/digit_stabilization.png"):
    """Show 2-adic digit stabilization for the D=-601 ghost.

    Plots the binary digits of n_1 = R * D^{-1} mod 2^k as a heatmap
    across k values, showing how digits stabilize from the LSB up.
    The ghost materializes at k=12 when the orbit closes.
    """
    print("Generating 2-adic digit stabilization figure")

    d_val = -601  # D = 2^7 - 3^6
    abs_d = abs(d_val)
    # v-pattern (1,1,1,1,1,2) for L=6, V=7
    v_pattern = [1, 1, 1, 1, 1, 2]
    total_l = 6

    # Compute R = sum_{i=0}^{L-1} 3^{L-1-i} * 2^{S_i}
    partial_sums = [0]
    for v in v_pattern[:-1]:
        partial_sums.append(partial_sums[-1] + v)
    r_val = sum(3 ** (total_l - 1 - i) * (2 ** partial_sums[i]) for i in range(total_l))

    k_range = range(3, 26)
    max_bits = 25

    # Compute n_1 mod 2^k for each k
    grid = np.zeros((max_bits, len(list(k_range))))

    for ki, k in enumerate(k_range):
        mod = 2**k
        d_inv = pow(abs_d, -1, mod)
        # n_1 = R * D^{-1} mod 2^k, but D is negative
        # D = -|D|, so D^{-1} = -(|D|^{-1}) mod 2^k
        n1 = (r_val * (mod - d_inv)) % mod
        for bit in range(min(k, max_bits)):
            grid[bit, ki] = (n1 >> bit) & 1

    fig, ax = plt.subplots(figsize=(14, 6))
    fig.set_facecolor("#080810")
    ax.set_facecolor("#080810")

    # Custom colormap: 0 = dark, 1 = bright cyan
    from matplotlib.colors import ListedColormap

    cmap = ListedColormap(["#0a0a20", "#00e5ff"])

    ax.imshow(
        grid,
        aspect="auto",
        origin="lower",
        cmap=cmap,
        extent=[min(k_range) - 0.5, max(k_range) - 0.5, -0.5, max_bits - 0.5],
    )

    # Mark k=12 (first materialization)
    ax.axvline(x=12, color="#ffd700", linestyle="--", linewidth=1.5, alpha=0.7)
    ax.text(12.3, max_bits - 1.5, "k=12\n(ghost\nappears)", color="#ffd700", fontsize=9, va="top")

    # Mark the "stabilization boundary"
    for _ki, k in enumerate(k_range):
        ax.plot([k - 0.5, k + 0.5], [k - 0.5, k - 0.5], color="#ff5722", linewidth=1, alpha=0.5)

    ax.set_xlabel("Resolution k", color="white", fontsize=12)
    ax.set_ylabel("Bit position", color="white", fontsize=12)
    ax.set_title("2-Adic Digit Stabilization: D = -601 Ghost", color="white", fontsize=14, pad=10)
    ax.tick_params(colors="white")

    for spine in ax.spines.values():
        spine.set_color("#333366")

    fig.tight_layout()
    fig.savefig(output, dpi=150, facecolor=fig.get_facecolor(), bbox_inches="tight")
    plt.close(fig)
    print(f"  Saved {output}")


def plot_cycle_gallery(k_min=3, k_max=13, output="analysis/cycle_gallery.png"):
    """Static gallery: one chord diagram per k value.

    Shows the progression from k=3 (4 nodes) through k=13 (4096 nodes),
    with ghost cycles highlighted at k=10, 11, 12.
    """
    print(f"Generating cycle gallery k={k_min}..{k_max}")

    k_range = list(range(k_min, k_max + 1))
    n_k = len(k_range)
    n_cols = min(n_k, 4)
    n_rows = (n_k + n_cols - 1) // n_cols

    fig, axes = plt.subplots(n_rows, n_cols, figsize=(5 * n_cols, 5 * n_rows))
    fig.set_facecolor("#080810")

    if n_rows == 1:
        axes = axes.reshape(1, -1)

    for idx, k in enumerate(k_range):
        row = idx // n_cols
        col = idx % n_cols
        ax = axes[row, col]
        draw_chord_frame(ax, k, show_tree_edges=(k <= 8))

    # Hide unused axes
    for idx in range(n_k, n_rows * n_cols):
        row = idx // n_cols
        col = idx % n_cols
        axes[row, col].set_visible(False)

    fig.suptitle("Syracuse Functional Graph by Resolution", color="white", fontsize=18, y=1.01)
    fig.tight_layout()
    fig.savefig(output, dpi=120, facecolor=fig.get_facecolor(), bbox_inches="tight")
    plt.close(fig)
    print(f"  Saved {output}")


def plot_ghost_contrast(output="analysis/figures/ghost_contrast.png"):
    """Paper-ready 4-panel figure: normal vs ghost chord diagrams.

    Shows k=9 (normal), k=10 (26-node ghost), k=12 (two ghosts),
    k=13 (normal again). Designed for PDF inclusion.
    """
    print("Generating ghost contrast figure")

    key_k = [9, 10, 12, 13]
    fig, axes = plt.subplots(1, 4, figsize=(20, 5))
    fig.set_facecolor("#080810")

    for ax, k in zip(axes, key_k, strict=False):
        draw_chord_frame(ax, k, show_tree_edges=True)

    fig.tight_layout(w_pad=1.0)
    fig.savefig(output, dpi=150, facecolor=fig.get_facecolor(), bbox_inches="tight")
    plt.close(fig)
    print(f"  Saved {output}")


if __name__ == "__main__":
    animate_functional_graph()
    plot_digit_stabilization()
    plot_cycle_gallery()
    plot_ghost_contrast()
    print("All visualizations complete.")
