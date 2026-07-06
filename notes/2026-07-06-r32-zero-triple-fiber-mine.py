#!/usr/bin/env python3
"""Mine fiber-parametrized reply covers for Lemma-B zero-triple children.

For Lemma B, set
  s=(0,0,1), t=(0,1,1), r=-s-t=(0,2,-2).

The off-line legal children of {s,t,r} fall into one stabilizer orbit per
Z_p fiber k, represented by a_k=(1,0,k).  For each P-position
{s,t,r,a_k}, this script asks the Go oracle for P-replies after each legal
opponent move and reports a greedy cover by small linear forms in
  x, s, t, r, a_k.

This is a data-shaping helper: it does not prove the formulas, but it makes the
remaining adaptive certificate visibly depend on the fiber coordinate k.
"""

from __future__ import annotations

import argparse
import collections
import itertools
import subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent
GRUNDY = HERE / "sumfree-go" / "grundy"


def coordstr(x):
    return ",".join(str(v) for v in x)


def parse_coord(s):
    return tuple(int(x) for x in s.split(","))  # type: ignore[return-value]


def add(a, b, mods):
    return tuple((a[i] + b[i]) % mods[i] for i in range(3))


def scale(c, a, mods):
    return tuple((c * a[i]) % mods[i] for i in range(3))


def lincomb(coeffs, vecs, mods):
    out = (0, 0, 0)
    for c, v in zip(coeffs, vecs):
        out = add(out, scale(c, v, mods), mods)
    return out


def sumfree(board, mods):
    s = set(board)
    return all(add(x, y, mods) not in s for x in s for y in s)


def legal_moves(board, mods):
    elems = [e for e in itertools.product(*[range(m) for m in mods]) if any(e)]
    s = set(board)
    return [x for x in elems if x not in s and sumfree(list(s) + [x], mods)]


def kind(x):
    soc = x[:2] != (0, 0)
    cop = x[2] != 0
    if soc and cop:
        return "mixed"
    if soc:
        return "socle"
    if cop:
        return "coprime"
    return "zero"


def preplies(board, mods):
    start = ";".join(coordstr(e) for e in board)
    r = subprocess.run(
        [
            str(GRUNDY),
            ",".join(str(m) for m in mods),
            "--start",
            start,
            "--children",
            "--preply",
        ],
        capture_output=True,
        text=True,
        check=True,
    )
    out = set()
    for line in r.stdout.splitlines():
        line = line.strip()
        if line.startswith("PREPLY ") and not line.startswith("PREPLY-COUNT"):
            out.add(parse_coord(line.split(None, 1)[1]))
    return out


def grundy_line(board, mods):
    start = ";".join(coordstr(e) for e in board)
    r = subprocess.run(
        [str(GRUNDY), ",".join(str(m) for m in mods), "--start", start],
        capture_output=True,
        text=True,
        check=True,
    )
    for line in r.stdout.splitlines():
        if "GRUNDY=" in line:
            return line.strip()
    return "?"


def formula_specs():
    vals = [-2, -1, 0, 1, 2]
    for coeffs in itertools.product(vals, repeat=5):
        if not any(coeffs):
            continue
        name = f"{coeffs[0]}x{coeffs[1]:+d}s{coeffs[2]:+d}t{coeffs[3]:+d}r{coeffs[4]:+d}a"
        yield name, coeffs


def greedy_cover(moves, replies, board, mods):
    formulas = []
    for name, coeffs in formula_specs():
        hits = {
            x
            for x in moves
            if lincomb(coeffs, [x] + board, mods) in replies[x]
        }
        if hits:
            formulas.append((len(hits), name, coeffs, hits))
    formulas.sort(reverse=True)

    uncovered = set(moves)
    cover = []
    while uncovered:
        best_name = None
        best_hits = set()
        best_coeffs = None
        for _, name, coeffs, _ in formulas:
            hits = {
                x
                for x in uncovered
                if lincomb(coeffs, [x] + board, mods) in replies[x]
            }
            if len(hits) > len(best_hits):
                best_name = name
                best_hits = hits
                best_coeffs = coeffs
        if not best_hits:
            break
        cover.append((best_name, best_coeffs, best_hits))
        uncovered -= best_hits
    return formulas, cover, uncovered


def mine(p, max_rows):
    mods = (3, 3, p)
    s = (0, 0, 1)
    t = (0, 1, 1)
    r = (0, 2, (-2) % p)
    print(f"p={p} s={s} t={t} r={r}")

    summaries = []
    first_piece_by_k = {}
    for k in range(p):
        a = (1, 0, k)
        board = [s, t, r, a]
        if not sumfree(board, mods):
            summaries.append((k, "not-sumfree", 0, 0, []))
            continue
        gline = grundy_line(board, mods)
        moves = legal_moves(board, mods)
        replies = {x: preplies(board + [x], mods) for x in moves}
        formulas, cover, uncovered = greedy_cover(moves, replies, board, mods)
        first_piece_by_k[k] = cover[0][0] if cover else "NONE"
        summaries.append((k, gline, len(moves), len(uncovered), cover))

    print("summary by fiber k:")
    for k, gline, nmove, nuncovered, cover in summaries:
        if gline == "not-sumfree":
            print(f"  k={k:2d}: not sum-free")
            continue
        sizes = [len(row[2]) for row in cover]
        pieces = " ".join(str(x) for x in sizes[:max_rows])
        first = cover[0][0] if cover else "NONE"
        print(f"  k={k:2d}: {gline:26s} moves={nmove:2d} uncovered={nuncovered:2d} pieces={pieces} first={first}")

    print("first-piece formula classes:")
    for name, ks in collections.defaultdict(list, {}).items():
        pass
    by_first = collections.defaultdict(list)
    for k, name in first_piece_by_k.items():
        by_first[name].append(k)
    for name, ks in sorted(by_first.items(), key=lambda kv: (-len(kv[1]), kv[0])):
        print(f"  {name:24s}: {ks}")

    print("detailed covers:")
    for k, _, _, _, cover in summaries:
        if not cover:
            continue
        print(f"  k={k}:")
        for name, _, hits in cover[:max_rows]:
            kinds = collections.Counter(kind(x) for x in hits)
            ks = " ".join(f"{j}:{v}" for j, v in sorted(kinds.items()))
            print(f"    {name:24s} {len(hits):2d} {ks}")


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--p", type=int, default=7)
    ap.add_argument("--max-rows", type=int, default=8)
    args = ap.parse_args()
    mine(args.p, args.max_rows)


if __name__ == "__main__":
    main()
