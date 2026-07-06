#!/usr/bin/env python3
"""Mine the alpha-reflection handle for Lemma B.

Lemma B position:
  s=(0,0,1), t=(0,1,1) in Z3^2 x Z_p.

The involution alpha(a,b,k)=(-a,b,k) fixes the axis F={a=0}.  This script
checks first-layer off-axis Alice moves: when alpha(a) is legal, what is the
Grundy value of {s,t,a,alpha(a)}, and how does it depend on the deposited axis
sum d=a+alpha(a)?
"""

from __future__ import annotations

import argparse
import collections
import itertools
import re
import subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent
GRUNDY = HERE / "sumfree-go" / "grundy"


def add(x, y, mods):
    return tuple((x[i] + y[i]) % mods[i] for i in range(3))


def alpha(x):
    return ((-x[0]) % 3, x[1], x[2])


def coordstr(x):
    return ",".join(str(v) for v in x)


def sumfree(board, mods):
    s = set(board)
    return all(add(x, y, mods) not in s for x in s for y in s)


def legal_moves(board, mods):
    elems = [e for e in itertools.product(*[range(m) for m in mods]) if any(e)]
    s = set(board)
    return [x for x in elems if x not in s and sumfree(list(s) + [x], mods)]


def grundy(mods, board):
    start = ";".join(coordstr(x) for x in board)
    r = subprocess.run(
        [str(GRUNDY), ",".join(str(m) for m in mods), "--start", start],
        capture_output=True,
        text=True,
        check=True,
    )
    m = re.search(r"GRUNDY=(\d+)", r.stdout)
    if not m:
        raise RuntimeError(r.stdout)
    return int(m.group(1))


def crt_coord(p, color, fiber):
    for x in range(3 * p):
        if x % 3 == color % 3 and x % p == fiber % p:
            return x
    raise RuntimeError((p, color, fiber))


def cyclic_axis_value(p, d):
    s = crt_coord(p, 0, 1)
    t = crt_coord(p, 1, 1)
    z = crt_coord(p, d[1], d[2])
    r = subprocess.run(
        [str(GRUNDY), str(3 * p), "--start", f"{s};{t};{z}"],
        capture_output=True,
        text=True,
        check=True,
    )
    m = re.search(r"GRUNDY=(\d+)", r.stdout)
    if not m:
        raise RuntimeError(r.stdout)
    return int(m.group(1))


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--p", type=int, default=7)
    args = ap.parse_args()
    p = args.p
    mods = (3, 3, p)
    s = (0, 0, 1)
    t = (0, 1, 1)
    base = [s, t]

    counts = collections.Counter()
    by_deposit = {}
    illegal = []
    for a in legal_moves(base, mods):
        if a[0] == 0:
            counts["axis"] += 1
            continue
        aa = alpha(a)
        d = add(a, aa, mods)
        if aa not in legal_moves(base + [a], mods):
            counts["alpha-illegal"] += 1
            illegal.append((a, aa, d))
            continue
        g = grundy(mods, base + [a, aa])
        counts["alpha-legal"] += 1
        counts[f"alpha-g{g}"] += 1
        by_deposit[d] = (g, cyclic_axis_value(p, d))

    print(f"p={p} base={base}")
    print("counts:", dict(counts))
    print("illegal alpha replies:")
    for a, aa, d in illegal:
        print(f"  a={coordstr(a):8s} alpha={coordstr(aa):8s} deposit={coordstr(d)}")
    print("deposit table: d -> full alpha-pair value, standalone axis value")
    for d, (g, axis) in sorted(by_deposit.items()):
        print(f"  {coordstr(d):8s} full=*{g:<2d} axis=*{axis}")


if __name__ == "__main__":
    main()
