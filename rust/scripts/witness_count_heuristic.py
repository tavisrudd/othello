#!/usr/bin/env python3
"""witness-count heuristic for the odd-q planar cap conjecture (A3 test).

Reads the feat-mode per-size-3 dumps (full census: on/int/ext P/N counts per
canonical size-3 class) and the escape-mode full logs, and computes, per q, the
two-layer witness-count distributions the Tao-style first-moment heuristic needs:

  TOTAL P-children per size-3 (on OR off conic)  -> margin for the MAIN conjecture
  ON-conic P-children per size-3 (pos==on)       -> margin for the (ON)/D3 route

The heuristic: model each class's P-child count as ~Poisson(mu(q)); with N_canon
classes the expected number of trapped (zero-count) classes is N_canon*exp(-mu).
The min-over-classes stays >=1 as long as mu(q) > ln(N_canon(q)) (roughly). Safe
"for a reason" iff mu outgrows ln(N_canon); danger iff mu is O(ln q)/flat with the
observed min trending to 0.

Data sources (repo root = two levels up from this script):
  feat CLS lines (per class):  escape=<total-P> onP onN extP extN intP intN
    q=5,7,9   notes/data/codex-feat{q}.out          (regenerated small-q anchors)
    q=11      notes/data/codex-feat11-c15.out
    q=13      notes/data/codex-feat13-c15.out
    q=17      notes/data/codex-feat17.out
    q=19      notes/data/codex-feat19-c15.out
  escape full logs (per class escape=, for the q=17,19 cross-check):
    notes/2026-07-07-escape-q17-full.log
    notes/2026-07-07-escape-q19-full.log

Regeneration of the small-q anchors (single-core, seconds), run from rust/:
    rustc -O -C target-cpu=native ../notes/2026-07-06-grid-cap-solver.rs -o target/gridcap
    ./target/gridcap feat 5 7 9 > /dev/null   # writes CLS lines to stdout; saved per-q

Usage:  python3 scripts/witness_count_heuristic.py
"""
import math
import re
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]  # rust/scripts -> rust -> othello

FEAT_FILES = {
    5:  "notes/data/codex-feat5.out",
    7:  "notes/data/codex-feat7.out",
    9:  "notes/data/codex-feat9.out",
    11: "notes/data/codex-feat11-c15.out",
    13: "notes/data/codex-feat13-c15.out",
    17: "notes/data/codex-feat17.out",
    19: "notes/data/codex-feat19-c15.out",
}
ESCAPE_LOGS = {
    17: "notes/2026-07-07-escape-q17-full.log",
    19: "notes/2026-07-07-escape-q19-full.log",
}

CLS_RE = re.compile(
    r"^CLS q=(\d+) cls=(\d+) S3=(\[[^\]]*\]) escape=(\d+) bad=(\d+) "
    r"onP=(\d+) onN=(\d+) extP=(\d+) extN=(\d+) intP=(\d+) intN=(\d+)"
)
X_RE = re.compile(r"^X q=(\d+) cls=(\d+) x=\S+ val=([PN]) pos=(\w+)")
ESC_RE = re.compile(r"^CLS q=(\d+) cls=(\d+) S3=(\[[^\]]*\]) escape=(\d+)")


def parse_feat(path):
    """Return (classes, xcounts) for a feat file.

    classes: list of dicts keyed by field (in file order).
    xcounts: {cls: number of X lines with val==P} for the internal consistency check.
    """
    classes = []
    xcount = {}
    with open(path) as fh:
        for line in fh:
            m = CLS_RE.match(line)
            if m:
                (_q, cls, s3, esc, bad, onp, onn, extp, extn, intp, intn) = m.groups()
                classes.append(dict(
                    cls=int(cls), s3=s3, escape=int(esc), bad=int(bad),
                    onP=int(onp), onN=int(onn), extP=int(extp), extN=int(extn),
                    intP=int(intp), intN=int(intn),
                ))
                continue
            mx = X_RE.match(line)
            if mx:
                _q, cls, val, _pos = mx.groups()
                cls = int(cls)
                if val == "P":
                    xcount[cls] = xcount.get(cls, 0) + 1
                else:
                    xcount.setdefault(cls, 0)
    return classes, xcount


def parse_escape_log(path):
    """Return {s3_string: escape_total_P} from an escape full log."""
    out = {}
    with open(path) as fh:
        for line in fh:
            m = ESC_RE.match(line)
            if m:
                _q, _cls, s3, esc = m.groups()
                out[s3] = int(esc)
    return out


def stats(vals):
    n = len(vals)
    mu = sum(vals) / n
    return dict(n=n, mu=mu, mn=min(vals), mx=max(vals))


def main():
    qs = sorted(FEAT_FILES)
    rows = {}
    internal_ok = True
    for q in qs:
        path = REPO / FEAT_FILES[q]
        if not path.exists():
            print(f"MISSING feat file for q={q}: {path}", file=sys.stderr)
            continue
        classes, xcount = parse_feat(path)
        # internal consistency: CLS escape == count of val==P X lines per class
        for c in classes:
            xp = xcount.get(c["cls"])
            if xp is not None and xp != c["escape"]:
                print(f"  !! INTERNAL MISMATCH q={q} cls={c['cls']}: "
                      f"CLS escape={c['escape']} but X val=P count={xp}")
                internal_ok = False
        total = [c["escape"] for c in classes]                 # total P (on+int+ext)
        on = [c["onP"] for c in classes]                       # on-conic P
        intr = [c["intP"] for c in classes]                    # internal off-conic P
        ext = [c["extP"] for c in classes]                     # external off-conic P
        rows[q] = dict(
            classes=classes,
            N=len(classes),
            total=stats(total), on=stats(on), intr=stats(intr), ext=stats(ext),
            on_capacity=q - 4,  # legal on-conic children per class
        )

    # ---- cross-check: feat escape == escape-log escape, matched by S3 ----
    print("=" * 78)
    print("CROSS-CHECK  feat escape (val==P over all pos)  vs  escape-log escape=")
    print("=" * 78)
    xcheck_ok = True
    for q, logpath in ESCAPE_LOGS.items():
        log = parse_escape_log(REPO / logpath)
        classes = rows[q]["classes"]
        mism = []
        matched = 0
        for c in classes:
            if c["s3"] in log:
                matched += 1
                if log[c["s3"]] != c["escape"]:
                    mism.append((c["cls"], c["s3"], c["escape"], log[c["s3"]]))
            else:
                mism.append((c["cls"], c["s3"], c["escape"], "NO-S3-IN-LOG"))
        status = "PASS" if not mism else "FAIL"
        if mism:
            xcheck_ok = False
        print(f"  q={q}: matched {matched}/{len(classes)} classes by S3  -> {status}")
        for cls, s3, fe, le in mism:
            print(f"    MISMATCH cls={cls} S3={s3} feat={fe} log={le}")
    print(f"  internal X-line vs CLS-escape consistency: "
          f"{'PASS' if internal_ok else 'FAIL'}")
    print(f"  CROSS-CHECK RESULT: {'PASS' if (xcheck_ok and internal_ok) else 'FAIL'}")

    # ---- per-q distribution tables ----
    def hist(vals):
        h = {}
        for v in vals:
            h[v] = h.get(v, 0) + 1
        return " ".join(f"{k}:{h[k]}" for k in sorted(h))

    print("\n" + "=" * 78)
    print("PER-Q WITNESS DISTRIBUTIONS")
    print("=" * 78)
    for q in qs:
        r = rows[q]
        cls = r["classes"]
        print(f"\nq={q}  N_canon={r['N']}  total-extensions(q^2-9q+21)={q*q-9*q+21}  "
              f"on-conic-capacity(q-4)={r['on_capacity']}")
        print(f"  TOTAL P : mu={r['total']['mu']:.3f} min={r['total']['mn']} "
              f"max={r['total']['mx']}  hist(P:classes)= {hist([c['escape'] for c in cls])}")
        print(f"  ON    P : mu={r['on']['mu']:.3f} min={r['on']['mn']} "
              f"max={r['on']['mx']}  hist= {hist([c['onP'] for c in cls])}")
        print(f"  INT   P : mu={r['intr']['mu']:.3f} min={r['intr']['mn']} "
              f"max={r['intr']['mx']}  hist= {hist([c['intP'] for c in cls])}")
        print(f"  EXT   P : mu={r['ext']['mu']:.3f} min={r['ext']['mn']} "
              f"max={r['ext']['mx']}  hist= {hist([c['extP'] for c in cls])}")

    # ---- heuristic table ----
    print("\n" + "=" * 78)
    print("HEURISTIC TABLE  (safety condition: mu > ln N_canon)")
    print("=" * 78)
    hdr = ("q", "N_can", "lnN", "2lnq", "mu_tot", "m_tot", "mu_on", "m_on",
           "tot-lnN", "on-lnN", "E0_tot", "E0_on")
    print("  " + " ".join(f"{h:>8}" for h in hdr))
    for q in qs:
        r = rows[q]
        N = r["N"]
        lnN = math.log(N) if N > 0 else 0.0
        two_lnq = 2 * math.log(q)
        mu_t = r["total"]["mu"]
        m_t = r["total"]["mn"]
        mu_o = r["on"]["mu"]
        m_o = r["on"]["mn"]
        e0_t = N * math.exp(-mu_t)   # Poisson-null expected zero-count classes, total
        e0_o = N * math.exp(-mu_o)   # ... on-conic layer
        vals = (q, N, f"{lnN:.3f}", f"{two_lnq:.3f}", f"{mu_t:.3f}", m_t,
                f"{mu_o:.3f}", m_o, f"{mu_t-lnN:+.3f}", f"{mu_o-lnN:+.3f}",
                f"{e0_t:.3e}", f"{e0_o:.3f}")
        print("  " + " ".join(f"{str(v):>8}" for v in vals))

    print("\nLegend: E0_x = N_canon*exp(-mu_x) = Poisson-null expected # of trapped "
          "(zero-witness) classes.")
    print("  Safety flag: mu_on > ln N_canon means the on-conic first-moment margin is "
          "positive.")


if __name__ == "__main__":
    main()
