#!/usr/bin/env python3
"""C63 correction-2 held-out replay: freeze the q13+q17-fitted integer Psi and
replay it against the exact q=19 [1,2,3,4] root's fixed-selector transitions.

Psi = 1*reservoir_slack_total + 6*defect_components
      - 4*interface_intruders - 2*conic_xor_zero

This is the EXACT C63 protocol (fixed C31 selector via s4potential), not C62's
weaker "some P reply decreases Psi" existence quantifier.  q=19 was NOT in the
fit, so a clean pass here is the overfit test Fable asked for before geometrizing.

Usage: python3 scripts/c63-q19-replay.py <transitions.tsv>
"""
import csv
import sys

# feature -> integer weight (the promoted primitive Psi)
W = {
    "reservoir_slack_total": 1,
    "defect_components": 6,
    "interface_intruders": -4,
    "conic_xor_zero": -2,
}


def main() -> None:
    path = sys.argv[1]
    rows = 0
    strict_decreases = 0
    failures = 0  # delta Psi >= 0
    min_delta = None
    max_delta = None
    worst = None
    with open(path, newline="") as f:
        for row in csv.DictReader(f, delimiter="\t"):
            d = sum(
                w * (int(row[f"child_{name}"]) - int(row[f"parent_{name}"]))
                for name, w in W.items()
            )
            rows += 1
            if d < 0:
                strict_decreases += 1
            else:
                failures += 1
                if worst is None or d > worst[0]:
                    worst = (
                        d,
                        row["parent_key"],
                        row["parent_ply"],
                        row["opponent"],
                        row["reply"],
                    )
            min_delta = d if min_delta is None else min(min_delta, d)
            max_delta = d if max_delta is None else max(max_delta, d)

    print(f"C63-Q19-REPLAY rows={rows} strict_decreases={strict_decreases} "
          f"failures={failures} delta_range=[{min_delta},{max_delta}]")
    if failures:
        d, pk, pp, opp, rep = worst
        print(f"  worst failure: dPsi={d} parent_key={pk} parent_ply={pp} "
              f"opponent={opp} reply={rep}")
    else:
        print("  PASS: every fixed-selector transition strictly decreases Psi "
              "(held-out q=19, matches the C63 q13/q17 result).")


if __name__ == "__main__":
    main()
