# collatz/visualize.py
"""Visualization tools for Collatz exploration."""

import matplotlib.pyplot as plt
import numpy as np

from collatz.core import collatz, v_sequence
from collatz.stats import batch_stopping_times


def plot_trajectory(n: int, log_scale: bool = False, ax=None):
    """Plot the Collatz trajectory of n."""
    traj = collatz(n)
    if ax is None:
        fig, ax = plt.subplots(figsize=(12, 4))
    ax.plot(traj, linewidth=0.5)
    if log_scale:
        ax.set_yscale("log")
    ax.set_xlabel("Step")
    ax.set_ylabel("Value")
    ax.set_title(f"Collatz trajectory of {n} ({len(traj) - 1} steps, peak {max(traj)})")
    return ax


def plot_stopping_times(start: int, end: int, ax=None):
    """Scatter plot of stopping times for a range of integers."""
    times = batch_stopping_times(start, end)
    if ax is None:
        fig, ax = plt.subplots(figsize=(12, 6))
    ax.scatter(range(start, end + 1), times, s=0.3, alpha=0.5)
    ax.set_xlabel("n")
    ax.set_ylabel("Stopping time")
    ax.set_title(f"Collatz stopping times for n = {start}..{end}")
    return ax


def plot_v_sequence_histogram(start: int, end: int, ax=None):
    """Histogram of v-values across all odd numbers in range."""
    all_vs = []
    for n in range(start, end + 1):
        if n % 2 == 1:
            all_vs.extend(v_sequence(n))
    if ax is None:
        fig, ax = plt.subplots(figsize=(10, 5))
    max_v = max(all_vs) if all_vs else 1
    ax.hist(all_vs, bins=range(1, max_v + 2), density=True, edgecolor="black", alpha=0.7)
    ks = np.arange(1, max_v + 1)
    ax.plot(ks + 0.5, 1.0 / 2**ks, "r-o", label="Geometric(1/2)", markersize=4)
    ax.set_xlabel("v (2-adic valuation)")
    ax.set_ylabel("Frequency")
    ax.set_title(f"Distribution of v-values for odd n in [{start}, {end}]")
    ax.legend()
    return ax
