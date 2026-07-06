#!/usr/bin/env python3
"""Mine oracle P-replies from an arbitrary small position in Z3^2 x Z_p.

The intended use is after a candidate P-position has been found, e.g. a child
{s,t,r,a} of the Lemma-B zero-sum triple.  For every legal opponent move x, the
script asks the Go oracle for P-replies y and tests small linear forms

  y = c_x x + c_0 b_0 + ... + c_m b_m

in the current board elements.
"""

from __future__ import annotations

import argparse
import collections
import itertools
import os
import subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent
GRUNDY = HERE / "sumfree-go" / "grundy"


def parse_coord(s):
    return tuple(int(x) for x in s.split(","))  # type: ignore[return-value]


def coordstr(x):
    return ",".join(str(v) for v in x)


def add(a, b, mods):
    return tuple((a[i] + b[i]) % mods[i] for i in range(3))


def scale(k, a, mods):
    return tuple((k * a[i]) % mods[i] for i in range(3))


def lincomb(coeffs, vecs, mods):
    out = (0, 0, 0)
    for k, v in zip(coeffs, vecs):
        out = add(out, scale(k, v, mods), mods)
    return out


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


def sumfree(board, mods):
    s = set(board)
    return all(add(x, y, mods) not in s for x in s for y in s)


def legal_moves(board, mods):
    elems = [e for e in itertools.product(*[range(m) for m in mods]) if any(e)]
    s = set(board)
    return [x for x in elems if x not in s and sumfree(list(s) + [x], mods)]


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
    out = []
    for line in r.stdout.splitlines():
        line = line.strip()
        if line.startswith("PREPLY ") and not line.startswith("PREPLY-COUNT"):
            out.append(parse_coord(line.split(None, 1)[1]))
    return set(out)


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


def formula_specs(board_len):
    coeff_vals = [-2, -1, 0, 1, 2]
    for coeffs in itertools.product(coeff_vals, repeat=board_len + 1):
        if not any(coeffs):
            continue
        parts = [f"{coeffs[0]}x"]
        for i, c in enumerate(coeffs[1:]):
            parts.append(f"{c:+d}b{i}")
        yield "".join(parts), coeffs


def mine(p, board, max_rows):
    mods = (3, 3, p)
    print(f"p={p} board={' '.join(coordstr(x) for x in board)}  {grundy_line(board, mods)}")
    moves = legal_moves(board, mods)
    print(f"legal opponent moves: {len(moves)}")
    reply = {x: preplies(board + [x], mods) for x in moves}
    sizes = collections.Counter(len(reply[x]) for x in moves)
    print("reply-set size histogram:", dict(sorted(sizes.items())))
    type_counts = collections.Counter((kind(x), kind(y)) for x, ys in reply.items() for y in ys)
    print("reply type counts:")
    for (kx, ky), n in type_counts.most_common():
        print(f"  {kx:7s}->{ky:7s} {n}")

    formulas = []
    vec_prefix = list(board)
    for name, coeffs in formula_specs(len(board)):
        hits = []
        for x in moves:
            y = lincomb(coeffs, [x] + vec_prefix, mods)
            if y in reply[x]:
                hits.append(x)
        if hits:
            formulas.append((len(hits), name, coeffs, hits))
    formulas.sort(reverse=True)
    print("best formulas:")
    for n, name, _, _ in formulas[:max_rows]:
        print(f"  {name:28s} {n:2d}/{len(moves)}")

    uncovered = set(moves)
    cover = []
    while uncovered:
        best = None
        best_hits = set()
        for _, name, coeffs, _ in formulas:
            hits = {x for x in uncovered if lincomb(coeffs, [x] + vec_prefix, mods) in reply[x]}
            if len(hits) > len(best_hits):
                best = name
                best_hits = hits
        if not best_hits:
            break
        cover.append((best, len(best_hits), collections.Counter(kind(x) for x in best_hits)))
        uncovered -= best_hits
    print("greedy formula cover:")
    for name, n, kinds in cover[:max_rows]:
        ks = " ".join(f"{k}:{v}" for k, v in sorted(kinds.items()))
        print(f"  {name:28s} {n:2d}  {ks}")
    if uncovered:
        print("uncovered:", " ".join(coordstr(x) for x in sorted(uncovered)[:max_rows]))


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("p", type=int)
    ap.add_argument("board", help="semicolon-separated coordinates")
    ap.add_argument("--max-rows", type=int, default=16)
    args = ap.parse_args()
    board = [parse_coord(x) for x in args.board.split(";") if x]
    mine(args.p, board, args.max_rows)


if __name__ == "__main__":
    main()
