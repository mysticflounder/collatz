"""Core Collatz and Syracuse iteration functions."""


def collatz(n: int) -> list[int]:
    """Return full Collatz trajectory from n to 1."""
    trajectory = [n]
    while n != 1:
        n = n // 2 if n % 2 == 0 else 3 * n + 1
        trajectory.append(n)
    return trajectory


def syracuse(n: int) -> list[int]:
    """Return Syracuse trajectory (odd steps only) from n to 1.

    The Syracuse function T(n) = (3n+1) / 2^v2(3n+1) maps odd -> odd,
    skipping all even intermediate values.
    """
    trajectory = [n]
    while n != 1:
        n = 3 * n + 1
        while n % 2 == 0:
            n = n // 2
        trajectory.append(n)
    return trajectory


def v_sequence(n: int) -> list[int]:
    """Return the sequence of 2-adic valuations at each Syracuse step.

    For starting odd number n, each entry is the number of times we
    divide by 2 after computing 3n+1 at each odd step.
    """
    vs = []
    while n != 1:
        n = 3 * n + 1
        v = 0
        while n % 2 == 0:
            n = n // 2
            v += 1
        vs.append(v)
    return vs


def stopping_time(n: int) -> int:
    """Return the number of Collatz steps to reach 1."""
    steps = 0
    while n != 1:
        n = n // 2 if n % 2 == 0 else 3 * n + 1
        steps += 1
    return steps
