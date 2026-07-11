#!/usr/bin/env python3
"""C68 — the depletion-fraction extremal sequence D(q) (sweep E2).

D(q) = max over size-3 residual classes of the N-fraction among ON-CONIC children,
        i.e. max_class onN / (onP + onN).
min-witness(q) = min over size-3 classes of onP (the number of on-conic P escapes).

Input: feat-mode CLS summary lines, e.g.
  CLS q=9 cls=0 S3=[(0, 0), (1, 1), (2, 3)] escape=13 bad=8 onP=5 onN=0 extP=4 extN=8 intP=4 intN=0

q=5..19 come from feat dumps under notes/data/; q=23 comes from the C54 bucket labels
(all 22 full-PGL on-conic S4 buckets are P, so every on-conic child is P → onN=0).

No external deps. Pure parse + arithmetic; the feat solves themselves are the exact oracle.
"""

import re
import sys
from fractions import Fraction
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
DATA = REPO / "notes" / "data"

FEAT_FILES = {
    5: "codex-feat5.out",
    7: "codex-feat7.out",
    9: "codex-feat9.out",
    11: "codex-feat11-c15.out",
    13: "codex-feat13-c15.out",
    17: "codex-feat17.out",
    19: "codex-feat19-c15.out",
}

CLS_RE = re.compile(
    r"^CLS q=(?P<q>\d+) cls=(?P<cls>\d+) S3=(?P<s3>\[.*?\]) "
    r"escape=(?P<escape>\d+) bad=(?P<bad>\d+) "
    r"onP=(?P<onP>\d+) onN=(?P<onN>\d+) "
    r"extP=(?P<extP>\d+) extN=(?P<extN>\d+) "
    r"intP=(?P<intP>\d+) intN=(?P<intN>\d+)"
)


def parse_feat(path):
    """Return (root, [class-dict...]) for a feat dump."""
    root = None
    classes = []
    for line in path.read_text().splitlines():
        if line.startswith("FEAT-SUMMARY"):
            m = re.search(r"root=([PN])", line)
            if m:
                root = m.group(1)
            continue
        m = CLS_RE.match(line)
        if not m:
            continue
        d = {k: int(m.group(k)) for k in
             ("q", "cls", "escape", "bad", "onP", "onN", "extP", "extN", "intP", "intN")}
        d["s3"] = m.group("s3")
        classes.append(d)
    return root, classes


def summarize(q, root, classes):
    n = len(classes)
    onN_pos = [c for c in classes if c["onN"] > 0]
    # per-class on-conic total and N-fraction
    rows = []
    on_totals = set()
    for c in classes:
        on_total = c["onP"] + c["onN"]
        on_totals.add(on_total)
        frac = Fraction(c["onN"], on_total) if on_total else Fraction(0)
        rows.append((c["cls"], c["onP"], c["onN"], on_total, frac, c["s3"]))
    # D(q): worst N-fraction
    worst = max(rows, key=lambda r: (r[4], r[2]))  # tie-break by onN
    Dq = worst[4]
    # min-witness: min onP
    min_wit_row = min(rows, key=lambda r: r[1])
    min_wit = min_wit_row[1]
    return {
        "q": q,
        "root": root,
        "classes": n,
        "on_total_q_minus_4": q - 4,
        "on_totals_observed": sorted(on_totals),
        "n_classes_with_onN": len(onN_pos),
        "Dq": Dq,
        "worst": worst,
        "min_witness": min_wit,
        "min_wit_row": min_wit_row,
        "rows": rows,
    }


def frac_str(fr):
    return f"{fr.numerator}/{fr.denominator}={float(fr):.4f}"


def main():
    results = []
    for q, fname in FEAT_FILES.items():
        path = DATA / fname
        root, classes = parse_feat(path)
        s = summarize(q, root, classes)
        results.append(s)

    # q=23 from C54 bucket labels: all 22 full-PGL on-conic S4 buckets are P.
    # => every on-conic child of every size-3 class is P => onN=0 for all classes.
    q23 = {
        "q": 23, "root": "P", "classes": None,
        "on_total_q_minus_4": 19, "on_totals_observed": [19],
        "n_classes_with_onN": 0, "Dq": Fraction(0),
        "worst": None, "min_witness": 19, "min_wit_row": None, "rows": None,
        "note": "from C54: all 22 full-PGL on-conic S4 buckets P (bucket layer, not size-3 census)",
    }
    # q=25 from the full s4arena --all census (2026-07-10): all 28 full-PGL(2,25) on-conic S4
    # buckets are P (0 N, 0 aborted; ~6.67h/8GB compute). Same consequence as q=23.
    q25 = {
        "q": 25, "root": "P", "classes": None,
        "on_total_q_minus_4": 21, "on_totals_observed": [21],
        "n_classes_with_onN": 0, "Dq": Fraction(0),
        "worst": None, "min_witness": 21, "min_wit_row": None, "rows": None,
        "note": "from s4arena census: all 28 full-PGL(2,25) on-conic S4 buckets P (bucket layer)",
    }

    print("=" * 78)
    print("C68  D(q) depletion-fraction extremal sequence")
    print("=" * 78)
    print()
    hdr = f"{'q':>3} {'root':>4} {'#cls':>5} {'q-4':>4} {'on_tot':>10} {'#cls onN>0':>11} {'D(q)':>16} {'worst onP/onN':>14} {'min-wit onP':>11}"
    print(hdr)
    print("-" * len(hdr))
    for s in results:
        w = s["worst"]
        print(f"{s['q']:>3} {s['root']:>4} {s['classes']:>5} {s['on_total_q_minus_4']:>4} "
              f"{str(s['on_totals_observed']):>10} {s['n_classes_with_onN']:>11} "
              f"{frac_str(s['Dq']):>16} {str(w[1])+'/'+str(w[2]):>14} {s['min_witness']:>11}")
    # q=23, q=25 lines (bucket-layer results, no size-3-class breakdown available)
    print(f"{23:>3} {'P':>4} {'—':>5} {19:>4} {str([19]):>10} {0:>11} "
          f"{'0/19=0.0000':>16} {'19/0':>14} {19:>11}")
    print(f"{25:>3} {'P':>4} {'—':>5} {21:>4} {str([21]):>10} {0:>11} "
          f"{'0/21=0.0000':>16} {'21/0':>14} {21:>11}")
    print()
    print("(q=23,25: bucket layer — all on-conic S4 P, so onN=0 for every size-3 class.)")
    print()

    for s in results:
        print("-" * 60)
        w = s["worst"]
        print(f"q={s['q']}  root={s['root']}  classes={s['classes']}  "
              f"on-conic total per class (q-4)={s['on_total_q_minus_4']} "
              f"observed={s['on_totals_observed']}")
        print(f"  D(q) = {frac_str(s['Dq'])}  (worst class cls={w[0]} onP={w[1]} onN={w[2]} S3={w[5]})")
        mw = s["min_wit_row"]
        print(f"  min-witness onP = {s['min_witness']}  (class cls={mw[0]} onP={mw[1]} onN={mw[2]})")
        # onP histogram
        from collections import Counter
        onP_hist = Counter(r[1] for r in s["rows"])
        onN_hist = Counter(r[2] for r in s["rows"])
        print(f"  onP histogram (escapes:count): " +
              " ".join(f"{k}:{onP_hist[k]}" for k in sorted(onP_hist)))
        print(f"  onN histogram (n-children:count): " +
              " ".join(f"{k}:{onN_hist[k]}" for k in sorted(onN_hist)))
        # worst-few by N-frac
        tail = sorted(s["rows"], key=lambda r: (-r[4], -r[2]))[:5]
        print(f"  top classes by N-fraction:")
        for r in tail:
            print(f"      cls={r[0]:>2} onP={r[1]:>2} onN={r[2]:>2} on_tot={r[3]:>2} "
                  f"N-frac={frac_str(r[4])}")
    print()
    print("Machine-readable D(q) trajectory (q, D(q) float, min-witness):")
    for s in results:
        print(f"  q={s['q']:>2}  D={float(s['Dq']):.4f}  min_wit={s['min_witness']}")
    print(f"  q=23  D=0.0000  min_wit=19  (bucket layer)")
    print(f"  q=25  D=0.0000  min_wit=21  (bucket layer, full s4arena census)")


if __name__ == "__main__":
    main()
