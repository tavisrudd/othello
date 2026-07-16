#!/usr/bin/env python3
"""C201's arithmetic and frame-normalized PG(2,64) census sizing gate."""

from __future__ import annotations

import math


def l2_admissible(q: int, k: int) -> bool:
    m = k // 2
    return m * (q * q - k) + 6 * math.comb(k, 4) <= m * math.comb(k, 2) * (q - 1)


def legal_lower_bound(q: int, n: int) -> int:
    """Union bound after the secants of an n-arc are forbidden."""
    return max(0, q * q + q + 1 - n - math.comb(n, 2) * (q - 1))


def main() -> None:
    q = 64
    candidate = next(k for k in range(3, q + 2) if l2_admissible(q, k))
    print(f"q {q} corrected_lower_bound_candidate {candidate}")
    for k in range(candidate - 2, candidate + 2):
        m = k // 2
        slack = (
            m * math.comb(k, 2) * (q - 1)
            - m * (q * q - k)
            - 6 * math.comb(k, 4)
        )
        print(f"k {k} admissible {l2_admissible(q, k)} integral_slack {slack}")

    choices = [(n, legal_lower_bound(q, n)) for n in range(4, 12)]
    ordered = math.prod(count for _, count in choices)
    # Each twelve-arc containing the fixed frame has 8! insertion orders.
    # Its frame-stabilizer orbit has at most 24 elements.  A projective class
    # has at most C(12,4) normalizations whose chosen frame becomes fixed.
    normalized_orbits = ordered // (math.factorial(8) * math.factorial(4))
    projective_classes = normalized_orbits // math.comb(12, 4)
    print("legal_choice_lower_bounds " + " ".join(f"n{n}:{count}" for n, count in choices))
    print(f"ordered_frame_extensions_to_12_lower_bound {ordered}")
    print(f"frame_stabilizer_orbits_to_12_lower_bound {normalized_orbits}")
    print(f"projective_12_arc_classes_lower_bound {projective_classes}")
    print("full_q64_census REJECTED")


if __name__ == "__main__":
    main()
