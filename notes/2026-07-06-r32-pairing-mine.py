#!/usr/bin/env python3
"""Mine first-layer pairing certificates for the r3=2 two-lemma P positions.

This is not a solver. It uses the existing Go `grundy` oracle to get Bob's
P-replies after an Alice move from a proposed P-position {s,t} in Z3^2 x Z_p.
Then it tests whether the reply relation is covered by small formulas in the
Alice move and the two seeds.
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


def parse_coord(s: str) -> tuple[int, int, int]:
    return tuple(int(x) for x in s.split(","))  # type: ignore[return-value]


def coordstr(e: tuple[int, int, int]) -> str:
    return ",".join(str(x) for x in e)


def add(a, b, mods):
    return tuple((a[i] + b[i]) % mods[i] for i in range(3))


def scale(k: int, a, mods):
    return tuple((k * a[i]) % mods[i] for i in range(3))


def lincomb(coeffs, vecs, mods):
    out = (0, 0, 0)
    for k, v in zip(coeffs, vecs):
        out = add(out, scale(k, v, mods), mods)
    return out


def kind(x: tuple[int, int, int]) -> str:
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
    bset = set(board)
    for x in board:
        for y in board:
            if add(x, y, mods) in bset:
                return False
    return True


def legal_moves(board, mods):
    elems = [e for e in itertools.product(*[range(m) for m in mods]) if any(e)]
    bset = set(board)
    return [e for e in elems if e not in bset and sumfree(list(bset) + [e], mods)]


def preplies(board, mods):
    start = ";".join(coordstr(e) for e in board)
    cmd = [
        str(GRUNDY),
        ",".join(str(m) for m in mods),
        "--start",
        start,
        "--children",
        "--preply",
    ]
    r = subprocess.run(cmd, capture_output=True, text=True, check=True)
    out = []
    for line in r.stdout.splitlines():
        line = line.strip()
        if line.startswith("PREPLY ") and not line.startswith("PREPLY-COUNT"):
            out.append(parse_coord(line.split(None, 1)[1]))
    return set(out)


def grundy_line(board, mods) -> str:
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


def formula_specs(p: int):
    # b = ca*a + cs*s + ct*t. Coefficients are coordinate-wise integer scalars
    # reduced modulo 3,3,p by lincomb.
    vals = sorted(set([-2, -1, 0, 1, 2, 3, (p + 1) // 2, -(p + 1) // 2]))
    specs = []
    for ca in vals:
        for cs in [-2, -1, 0, 1, 2]:
            for ct in [-2, -1, 0, 1, 2]:
                if ca == cs == ct == 0:
                    continue
                specs.append((f"{ca}a{cs:+d}s{ct:+d}t", (ca, cs, ct)))
    return specs


def mine(p: int, s, t, max_rows: int):
    mods = (3, 3, p)
    board = [s, t]
    print(f"p={p} s={s} t={t}  {grundy_line(board, mods)}")
    moves = legal_moves(board, mods)
    print(f"legal Alice moves: {len(moves)}")
    reply = {a: preplies(board + [a], mods) for a in moves}

    mutual = {
        a: {b for b in bs if b in reply and a in reply[b]}
        for a, bs in reply.items()
    }
    print(f"moves with mutual partner: {sum(bool(v) for v in mutual.values())}/{len(moves)}")

    type_counts = collections.Counter((kind(a), kind(b)) for a, bs in reply.items() for b in bs)
    mutual_type_counts = collections.Counter((kind(a), kind(b)) for a, bs in mutual.items() for b in bs)
    print("P-reply type counts:")
    for k, v in type_counts.most_common():
        print(f"  {k[0]:7s}->{k[1]:7s} {v}")
    print("mutual-partner type counts:")
    for k, v in mutual_type_counts.most_common():
        print(f"  {k[0]:7s}->{k[1]:7s} {v}")

    formulas = []
    for name, coeffs in formula_specs(p):
        hits = []
        mutual_hits = []
        for a in moves:
            b = lincomb(coeffs, [a, s, t], mods)
            if b in reply[a]:
                hits.append(a)
            if b in mutual[a]:
                mutual_hits.append(a)
        if hits:
            formulas.append((len(hits), len(mutual_hits), name, coeffs, hits))
    formulas.sort(reverse=True)
    print("best formulas (all P-replies / mutual P-replies):")
    for hit, mhit, name, _, _ in formulas[:max_rows]:
        print(f"  {name:16s} {hit:2d}/{len(moves)}  mutual {mhit:2d}/{len(moves)}")

    uncovered = set(moves)
    cover = []
    while uncovered:
        best = None
        best_hits = set()
        for _, _, name, coeffs, _ in formulas:
            hits = {a for a in uncovered if lincomb(coeffs, [a, s, t], mods) in mutual[a]}
            if len(hits) > len(best_hits):
                best = name
                best_hits = hits
        if not best_hits:
            break
        cover.append((best, len(best_hits), collections.Counter(kind(a) for a in best_hits)))
        uncovered -= best_hits
    print("greedy cover by mutual formulas:")
    for name, n, kinds in cover[:max_rows]:
        ks = " ".join(f"{k}:{v}" for k, v in sorted(kinds.items()))
        print(f"  {name:16s} {n:2d}   {ks}")
    if uncovered:
        print(f"  UNCOVERED {len(uncovered)}:", " ".join(coordstr(a) for a in sorted(uncovered)[:max_rows]))


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("p", type=int)
    ap.add_argument("s")
    ap.add_argument("t")
    ap.add_argument("--max-rows", type=int, default=20)
    args = ap.parse_args()
    mine(args.p, parse_coord(args.s), parse_coord(args.t), args.max_rows)


if __name__ == "__main__":
    main()
