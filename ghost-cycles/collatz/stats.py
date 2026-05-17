"""Batch statistical analysis of Collatz trajectories."""

import numpy as np

from collatz.core import collatz, stopping_time, v_sequence


def batch_stopping_times(start: int, end: int) -> np.ndarray:
    """Compute stopping times for all integers in [start, end] inclusive."""
    return np.array([stopping_time(n) for n in range(start, end + 1)])


def batch_v_sequences(start: int, end: int) -> dict[int, list[int]]:
    """Compute v-sequences for odd integers in [start, end] inclusive."""
    return {n: v_sequence(n) for n in range(start, end + 1) if n % 2 == 1}


def trajectory_max(start: int, end: int) -> np.ndarray:
    """Compute peak trajectory value for all integers in [start, end] inclusive."""
    return np.array([max(collatz(n)) for n in range(start, end + 1)])
