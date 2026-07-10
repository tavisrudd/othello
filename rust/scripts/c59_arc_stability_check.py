#!/usr/bin/env python3
"""C59: check exact A0 arc-to-conic bounds and sampled terminal profiles.

This deliberately distinguishes three evidence types:

* theorem bounds transcribed from the primary Ball--Lavrauw paper/survey;
* complete-arc spectra actually listed in notes/2026-07-07-arc-census-o1.md;
* terminal profiles mined from existing solved S4 DAGs by ``s4pncheck``.

In particular, an existence result for a non-conic arc is not silently promoted
to an exact value of the second-largest *complete* arc.
"""

import math
from dataclasses import dataclass


@dataclass(frozen=True)
class Order:
    q: int
    p: int
    h: int

    @property
    def kind(self) -> str:
        if self.h == 1:
            return "prime"
        if self.h % 2 == 0:
            return "odd-square"
        return "odd-nonsquare"


ORDERS = [
    Order(11, 11, 1),
    Order(13, 13, 1),
    Order(17, 17, 1),
    Order(19, 19, 1),
    Order(23, 23, 1),
    Order(25, 5, 2),
    Order(27, 3, 3),
    Order(29, 29, 1),
    Order(31, 31, 1),
]

# Only spectra explicitly listed by the in-repo census are included.
SPECTRA = {
    23: {10, 12, 13, 14, 15, 16, 17, 24},
    27: {12, 13, 14, 15, 16, 17, 18, 19, 22, 28},
    29: {13, 14, 15, 16, 17, 18, 19, 20, 21, 24, 30},
}

# Projective terminal-size profiles from existing solved on-conic S4 DAGs.
# ``c`` means contained in the completed root conic, ``o`` means off-conic.
# q=11,13,17 use the stored 1,2,3,4 root; q=19 aggregates all 13 stored
# full-PGL buckets in s4-dumps/2026-07-08.  Counts are canonical DAG nodes,
# not numbers of labelled arcs and not a complete-arc classification.
OBSERVED_PROFILES = {
    11: {(8, "o"): 4, (9, "o"): 8, (12, "c"): 1},
    13: {(8, "o"): 1, (9, "o"): 55, (10, "o"): 90,
         (12, "o"): 1, (14, "c"): 1},
    17: {(10, "o"): 621, (11, "o"): 9693, (12, "o"): 4851,
         (13, "o"): 98, (14, "o"): 8, (18, "c"): 1},
    19: {(10, "o"): 12, (11, "o"): 30265, (12, "o"): 316586,
         (13, "o"): 78336, (14, "o"): 3193},
}


def thresholds(o: Order):
    """Return (name, threshold, inclusive) theorem rows.

    inclusive=True means size >= threshold implies conic; otherwise size >
    threshold implies conic.
    """
    q, p, sq = o.q, o.p, math.sqrt(o.q)
    if o.kind == "prime":
        return [
            ("Ball--Lavrauw Thm 3", q - sq + 3.5, True),
            ("Voloch / survey Thm 52", (44 / 45) * q + 8 / 9, False),
        ]
    if o.kind == "odd-square":
        return [("Ball--Lavrauw Thm 2", q - sq + 3 + sq / p, True)]
    return [(
        "Voloch / survey Thm 53",
        q - 0.25 * math.sqrt(p * q) + (29 / 16) * p - 1,
        False,
    )]


def integer_nonconic_max(threshold: float, inclusive: bool) -> int:
    """Largest integer size not excluded by one real-valued threshold."""
    return math.ceil(threshold) - 1 if inclusive else math.floor(threshold)


def effective_nonconic_max(o: Order) -> int:
    # Segre always supplies non-conic size <= q.  Take the strongest imported row.
    bounds = [o.q]
    bounds.extend(integer_nonconic_max(t, inc) for _, t, inc in thresholds(o))
    return min(bounds)


def main() -> int:
    failures = 0
    print("C59 exact arc-stability and solved-terminal cross-check")
    print("=" * 76)
    for o in ORDERS:
        bound = effective_nonconic_max(o)
        print(f"q={o.q:<2} {o.kind:<13} non-conic complete terminal <= {bound}")
        for name, threshold, inclusive in thresholds(o):
            relation = ">=" if inclusive else ">"
            print(f"    {name}: size {relation} {threshold:.3f} => conic")

        spectrum = SPECTRA.get(o.q)
        if spectrum:
            oval = o.q + 1
            m2 = max(size for size in spectrum if size != oval)
            ok = oval in spectrum and all(size <= bound for size in spectrum if size != oval)
            print(f"    sourced spectrum: m'={m2}, gap ({m2},{oval}) empty: "
                  f"{'ok' if ok else 'FAIL'}")
            failures += not ok

        if o.kind == "odd-square":
            construction = int(o.q - math.isqrt(o.q) + 1)
            ok = construction <= bound
            print(f"    Kestenband non-conic arc exists at size {construction}; "
                  f"a non-conic complete extension lies in [{construction},{bound}]: "
                  f"{'ok' if ok else 'FAIL'}")
            failures += not ok

        profile = OBSERVED_PROFILES.get(o.q)
        if profile:
            profile_ok = True
            for (size, geometry), _count in profile.items():
                if geometry == "c":
                    profile_ok &= size == o.q + 1
                else:
                    profile_ok &= size <= bound
            total = sum(profile.values())
            off_max = max(size for (size, geometry) in profile if geometry == "o")
            conic_sizes = sorted(size for (size, geometry) in profile if geometry == "c")
            print(f"    observed solved-DAG terminals: nodes={total}, off-max={off_max}, "
                  f"conic-sizes={conic_sizes or '-'}: {'ok' if profile_ok else 'FAIL'}")
            failures += not profile_ok

    print("=" * 76)
    print(f"C59_ARC_STABILITY_CHECK orders={len(ORDERS)} failures={failures}")
    return 1 if failures else 0


if __name__ == "__main__":
    raise SystemExit(main())
