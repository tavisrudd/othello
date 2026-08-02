#!/usr/bin/env python3
"""C756 driver: run the conic-filling searcher over a q-list and emit the canonical
certificate `notes/2026-08-01-c756-all-k-conic-filling.json`.

Usage (from the repository root):
    python3 notes/2026-08-01-c756-all-k-conic-filling.py --out notes/2026-08-01-c756-all-k-conic-filling.json
    python3 notes/2026-08-01-c756-all-k-conic-filling.py --check

`--check` regenerates into a temporary directory and compares byte-for-byte with the
tracked certificate; it never touches the worktree.

Each q is run in `classify` mode: the searcher enumerates every conic-external arc of
size >= kmin(q) and tests the covering condition on each, so the result is a statement
about *every* k at once for that q.  `m_q` is the largest conic-external arc seen; it is
exact whenever it is >= kmin(q) (the search prunes only branches that cannot reach
kmin), and is a lower bound otherwise -- in the latter case m_q < kmin(q) already
excludes q, which is what the field records.
"""
import argparse
import hashlib
import json
import os
import shutil
import subprocess
import sys
import tempfile
from math import comb

HERE = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.join(HERE, "2026-08-01-c756-all-k-conic-filling.rs")
DEFAULT_OUT = os.path.join(HERE, "2026-08-01-c756-all-k-conic-filling.json")

# Odd prime powers settled by exhaustive search, smallest first.
Q_LIST = [3, 5, 7, 9, 11, 13, 17, 19, 23, 25, 27, 29, 31, 37, 41, 43]


def max_covered(k, q):
    b = comb(k, 2)
    s1 = b * (q + 1) - k * (k - 1)
    s2 = 3 * comb(k, 4)
    d = k // 2
    return k + max(0, s1 - (2 * s2 + d - 1) // d)


def kmin_lp(q):
    k = 4
    while max_covered(k, q) < q * q:
        k += 1
    return k


def kmin_line(q):
    k = 3
    while comb(k - 1, 2) < q:
        k += 1
    return min(k, (q + 1) // 2)


def build(tmpdir):
    exe = os.path.join(tmpdir, "c756")
    subprocess.run(["rustc", "-O", "-o", exe, SRC], check=True)
    return exe


def run(qs, out_path):
    with tempfile.TemporaryDirectory() as td:
        exe = build(td)
        rows = []
        for q in qs:
            raw = subprocess.run([exe, "classify", str(q)], check=True, capture_output=True, text=True)
            d = json.loads(raw.stdout)
            assert d["kmin"] == max(kmin_lp(q), kmin_line(q)), q
            # `classify` prunes at kmin, so its m_q is exact only when it reaches kmin.
            # Otherwise re-run in `max` mode to record the exact largest conic-external
            # arc; the classification itself never depends on that number.
            m = d["m_q"]
            if m < d["kmin"]:
                raw2 = subprocess.run([exe, "max", str(q)], check=True, capture_output=True, text=True)
                m = json.loads(raw2.stdout)["m_q"]
                assert m < d["kmin"], q
            rows.append(
                {
                    "q": q,
                    "kmin_lp": kmin_lp(q),
                    "kmin_line": kmin_line(q),
                    "kmin": d["kmin"],
                    "m_q": m,
                    "excluded_by_counting": m < d["kmin"],
                    "conic_filling": sorted(
                        (json.dumps(a, sort_keys=True) for a in d["conic_filling"])
                    ),
                    "n_conic_filling": len(d["conic_filling"]),
                }
            )
    cert = {
        "task": "C756",
        "schema": 1,
        "conic": "y^2 - x z",
        "claim": "for each listed q, every k-arc of PG(2,q) whose uncovered locus is a "
        "nonsingular conic is listed in conic_filling",
        "rows": rows,
    }
    text = json.dumps(cert, indent=1, sort_keys=True) + "\n"
    with open(out_path, "w") as fh:
        fh.write(text)
    return text


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default=DEFAULT_OUT)
    ap.add_argument("--check", action="store_true")
    ap.add_argument("--q", type=int, nargs="*", default=None)
    a = ap.parse_args()
    qs = a.q if a.q else Q_LIST
    if a.check:
        with tempfile.TemporaryDirectory() as td:
            tmp = os.path.join(td, "cert.json")
            text = run(qs, tmp)
            have = open(DEFAULT_OUT).read()
            ok = have == text
            print(
                "MATCH" if ok else "MISMATCH",
                hashlib.sha256(text.encode()).hexdigest(),
            )
            sys.exit(0 if ok else 1)
    run(qs, a.out)
    print("wrote", a.out)


if __name__ == "__main__":
    main()
