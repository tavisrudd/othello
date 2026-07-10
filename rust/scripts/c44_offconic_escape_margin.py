#!/usr/bin/env python3
"""C44 item-7 fallback-quantification rider — per-size-3-class OFF-conic escape margin.

For each canonical legal size-3 residual class:
  total P-children      = escape         (the CLS `escape=` field)
  on-conic  P-children  = onP
  off-conic P-children  = escape - onP   = extP + intP   (int = 0 tangents, ext = 2)

The (ON) route needs an on-conic P escape (min-witness >= 1). If some larger depleted
order leaves a size-3 class with ZERO on-conic P escapes, the proof pivots to the
OFF-conic escape layer (C44 item-7 (ii)). This rider records that fallback layer's
worst-class margin at the arc-depleted orders q in {11, 17} (with q in {13, 19} controls).

Reuses the c68_depletion_fraction parse (same feat CLS dumps under notes/data/).
Pure parse + arithmetic; the feat solves are the exact P/N oracle.
"""

import re
from collections import Counter
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

# The arc-depleted orders (targets) and the non-depleted controls, per C68.
DEPLETED = {11, 17}
CONTROLS = {13, 19}

CLS_RE = re.compile(
    r"^CLS q=(?P<q>\d+) cls=(?P<cls>\d+) S3=(?P<s3>\[.*?\]) "
    r"escape=(?P<escape>\d+) bad=(?P<bad>\d+) "
    r"onP=(?P<onP>\d+) onN=(?P<onN>\d+) "
    r"extP=(?P<extP>\d+) extN=(?P<extN>\d+) "
    r"intP=(?P<intP>\d+) intN=(?P<intN>\d+)"
)


def parse_feat(path):
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


def analyse(q, root, classes):
    rows = []
    for c in classes:
        off = c["escape"] - c["onP"]           # off-conic P escapes
        assert off == c["extP"] + c["intP"], (
            f"q={q} cls={c['cls']}: escape-onP={off} != extP+intP={c['extP']+c['intP']}")
        rows.append({
            "cls": c["cls"], "s3": c["s3"],
            "escape": c["escape"], "onP": c["onP"], "onN": c["onN"],
            "off": off, "extP": c["extP"], "intP": c["intP"],
        })
    off_vals = [r["off"] for r in rows]
    onP_vals = [r["onP"] for r in rows]
    min_onP = min(onP_vals)
    # worst class = fewest off-conic escapes (the thinnest fallback margin)
    worst = min(rows, key=lambda r: r["off"])
    # knife-edge classes = classes attaining the minimum on-conic P count
    knife = [r for r in rows if r["onP"] == min_onP]
    return {
        "q": q, "root": root, "n": len(rows),
        "off_min": min(off_vals), "off_max": max(off_vals),
        "off_hist": Counter(off_vals),
        "worst": worst,
        "min_onP": min_onP,
        "knife": knife,
        "rows": rows,
    }


def main():
    results = {}
    for q, fname in FEAT_FILES.items():
        root, classes = parse_feat(DATA / fname)
        results[q] = analyse(q, root, classes)

    print("=" * 92)
    print("C44 item-7 rider  —  per-size-3-class OFF-conic P-escape counts (off = escape - onP)")
    print("=" * 92)
    print()
    # Summary table over all available q, flagging depleted vs control.
    hdr = (f"{'q':>3} {'kind':>9} {'root':>4} {'#cls':>5} "
           f"{'off min':>8} {'off max':>8} {'off distribution (off:count)':>34} "
           f"{'min onP':>8}")
    print(hdr)
    print("-" * len(hdr))
    for q in sorted(results):
        s = results[q]
        kind = "DEPLETED" if q in DEPLETED else ("control" if q in CONTROLS else "anchor")
        dist = " ".join(f"{k}:{s['off_hist'][k]}" for k in sorted(s["off_hist"]))
        print(f"{q:>3} {kind:>9} {s['root']:>4} {s['n']:>5} "
              f"{s['off_min']:>8} {s['off_max']:>8} {dist:>34} {s['min_onP']:>8}")
    print()

    # Focused detail on the four q of interest (depleted + controls).
    for q in (11, 13, 17, 19):
        s = results[q]
        kind = "arc-DEPLETED" if q in DEPLETED else "control (non-depleted)"
        print("-" * 78)
        print(f"q={q}  [{kind}]  #size-3 classes = {s['n']}  (on-conic capacity q-4 = {q-4})")
        w = s["worst"]
        print(f"  OFF-conic escape:  min = {s['off_min']}   max = {s['off_max']}   "
              f"distribution = " +
              " ".join(f"{k}:{s['off_hist'][k]}" for k in sorted(s["off_hist"])))
        print(f"  WORST class (fewest off-conic escapes): cls={w['cls']} "
              f"off={w['off']} (escape={w['escape']} onP={w['onP']} onN={w['onN']} "
              f"extP={w['extP']} intP={w['intP']})  S3={w['s3']}")
        print(f"  knife-edge classes (min onP = {s['min_onP']}):")
        for r in s["knife"]:
            print(f"      cls={r['cls']:>2}  onP={r['onP']:>2} onN={r['onN']:>2}  "
                  f"escape(total P)={r['escape']:>3}  OFF-conic P={r['off']:>3} "
                  f"(extP={r['extP']} intP={r['intP']})  S3={r['s3']}")
        # headline for depleted orders
        knife_off = [r["off"] for r in s["knife"]]
        print(f"  -> headline: worst-class off-conic escapes = {s['off_min']}; "
              f"off-conic at knife-edge class(es) = {sorted(set(knife_off))}")
    print()
    print("Machine-readable (q, worst-class off-conic escapes, min off at knife-edge classes):")
    for q in (11, 13, 17, 19):
        s = results[q]
        knife_off = min(r["off"] for r in s["knife"])
        tag = "DEPLETED" if q in DEPLETED else "control"
        print(f"  q={q:>2}  worst_off={s['off_min']:>3}  knife_off={knife_off:>3}  ({tag})")


if __name__ == "__main__":
    main()
