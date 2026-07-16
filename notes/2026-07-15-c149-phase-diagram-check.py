#!/usr/bin/env python3
"""Independent integer check for the C149 parameterized repair phase diagram."""

from math import comb


def profiles(k: int):
    for f in range(k + 1):
        if (k - f) % 2 == 0:
            yield f, (k - f) // 2


def candidates(s: int) -> int:
    return s * (s - 1) // 2


def forbidden(k: int, f: int, e: int) -> int:
    assert k == f + 2 * e
    return f * e + e * (e - 1)


def worst_forbidden(k: int) -> int:
    assert k >= 1
    return (k - 1) ** 2 // 4


def empty_carriers(s: int, f: int, e: int) -> int:
    occupied = f * (s + 1) - comb(f, 2) + e
    return s * s + s + 1 - occupied


def max_k_for_repairs(s: int, repairs: int) -> int:
    n = candidates(s)
    return max(k for k in range(1, 2 * s + 2)
               if worst_forbidden(k) + repairs + 1 <= n)


def main() -> None:
    # The profile obstruction is e(k-e-1), and its exact maximum is floor((k-1)^2/4).
    for k in range(1, 2001):
        values = []
        for f, e in profiles(k):
            m = forbidden(k, f, e)
            assert m == e * (k - e - 1)
            values.append(m)
        assert max(values) == worst_forbidden(k)

    # The exact multiplicity condition implies the carrier-friendly range k <= 2s+1.  Every
    # profile in that range has an empty fixed carrier when s >= 3.
    for s in range(3, 1001):
        n = candidates(s)
        for k in range(1, 4 * s + 1):
            if worst_forbidden(k) + 2 <= n:
                assert k <= 2 * s + 1
                assert all(empty_carriers(s, f, e) >= 1 for f, e in profiles(k))

        # The simpler rectangular family k <= s+1 enters the useful region at s=4.  The sole
        # lower-order exception is sharp: (s,k)=(3,4) misses by one candidate.
        if s == 3:
            assert worst_forbidden(4) + 2 == n + 1
        else:
            for k in range(1, s + 2):
                assert worst_forbidden(k) + 2 <= n

    print("s  N  max-k(one alternate)  guaranteed alternatives at max-k")
    for s in range(5, 26):
        n = candidates(s)
        k = max_k_for_repairs(s, 1)
        repairs = n - worst_forbidden(k) - 1
        print(f"{s:2d} {n:3d} {k:3d} {repairs:3d}")


if __name__ == "__main__":
    main()
