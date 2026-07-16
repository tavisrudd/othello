#!/usr/bin/env python3
"""Aggregate multiplicity LP scout for C150.

This intentionally gives the moment route its strongest separately observed global inputs.  It
tests whether those uncoupled constraints can imply the census minimum 32.
"""


def feasible(require_observed_r_bound: bool):
    out = []
    for b in range(18, 27):
        visible = 204 - b
        for n4 in range(43):
            for n3 in range(57):
                for n2 in range(171):
                    # Visible mass determines n1; total support determines n0.
                    n1 = visible - 4 * n4 - 3 * n3 - 2 * n2
                    if n1 < 0:
                        continue
                    n0 = 170 - n1 - n2 - n3 - n4
                    if n0 < 0:
                        continue
                    r = n2 + 2 * n3 + 3 * n4
                    t = n2 + 3 * n3 + 6 * n4
                    assert n0 == b + r - 34
                    # The independently observed minimum empty endpoint moment is 96, so T >= 48.
                    # Adding this datum only strengthens the attempted moment proof.
                    if t < 48:
                        continue
                    if require_observed_r_bound and r < 42:
                        continue
                    out.append((n0, b, r, t, (n0, n1, n2, n3, n4)))
    return out


def main() -> None:
    moment_only = min(feasible(False))
    separate_extrema = min(feasible(True))
    assert moment_only == (8, 18, 24, 48, (8, 154, 0, 0, 8))
    assert separate_extrema[0] == 26
    assert separate_extrema[1:3] == (18, 42)
    print("moment-only minimum:", moment_only)
    print("with separate observed B>=18 and R>=42:", separate_extrema)
    print("Neither uncoupled LP reaches 32; a B/R coupling or residual classification is required.")


if __name__ == "__main__":
    main()
