#!/usr/bin/env python3
"""Mine the initial two-defect layer for the {p,e}+*1 strategy.

For every legal Alice move y from {p,e}, this script studies the child
{p,e,y}.  The open theorem says these bare two-defect children are never *1.
Equivalently, in the token game, a responder can either take the token when
{p,e,y} is P or make a board move z to a token-present *1 board.

The output is normalized in the colored-fiber model: after multiplying by the
unique unit u with u == 1 mod 3 and u*e == 1 mod p, the initial defect is
(1, e mod 3), and Alice/reply moves are reported as (r mod p, c mod 3).
"""

from __future__ import annotations

import argparse
import collections
from importlib.machinery import SourceFileLoader
from pathlib import Path

HERE = Path(__file__).resolve().parent
nim = SourceFileLoader("sumfree_nim_solver", str(HERE / "2026-07-06-sumfree-nim-solver.py")).load_module()


def inv_mod(a: int, m: int) -> int:
    return pow(a % m, -1, m)


def normalizer(p: int, e: int) -> int:
    """Return u mod 3p with u == 1 mod 3 and u*e == 1 mod p."""
    n = 3 * p
    target = inv_mod(e, p)
    for u in range(1, n):
        if u % 3 == 1 and u % p == target:
            return u
    raise RuntimeError((p, e))


def coord(x: int, p: int, u: int) -> tuple[int, int]:
    y = (u * x) % (3 * p)
    return (y % p, y % 3)


def is_order3(x: int, p: int) -> bool:
    n = 3 * p
    return x % n in (p % n, (2 * p) % n)


def defects(board: frozenset[int], p: int) -> tuple[int, ...]:
    n = 3 * p
    return tuple(sorted(x for x in board if not is_order3(x, p) and (-x) % n not in board))


def pair_count(board: frozenset[int], p: int) -> int:
    n = 3 * p
    seen: set[int] = set()
    out = 0
    for x in board:
        if is_order3(x, p) or x in seen:
            continue
        y = (-x) % n
        if y in board and y not in seen:
            out += 1
            seen.add(x)
            seen.add(y)
    return out


def inv2(n: int) -> int:
    return (n + 1) // 2


def block_values(d: int, p: int) -> dict[str, int]:
    n = 3 * p
    h = inv2(n)
    return {
        "2d": (2 * d) % n,
        "d+p": (d + p) % n,
        "d/2": (d * h) % n,
    }


def classify_reply(base: frozenset[int], alice: int, reply: int, p: int) -> str:
    n = 3 * p
    if reply == (-alice) % n:
        return "mirror-new"
    ds = defects(base, p)
    if reply in {(-d) % n for d in ds}:
        return "close-defect"
    for d in ds:
        if reply in {(-w) % n for w in block_values(d, p).values()}:
            return "old-defect-block"
    if reply in {(-w) % n for w in block_values(alice, p).values()}:
        return "new-defect-block"
    return "adaptive-other"


def relation_features(p: int, e: int, y: int, z: int, u: int) -> tuple[str, ...]:
    """Small algebraic labels in normalized F_p x F_3 coordinates."""
    ry, cy = coord(y, p, u)
    rz, cz = coord(z, p, u)
    labels: list[str] = []
    if rz == (-ry) % p and cz == (-cy) % 3:
        labels.append("z=-y")
    if rz == p - 1 and cz == (-e) % 3:
        labels.append("z=-e")
    for name, val in [
        ("2y", 2 * ry),
        ("y/2", ry * inv_mod(2, p)),
        ("y+1", ry + 1),
        ("y-1", ry - 1),
        ("1-y", 1 - ry),
        ("-2y", -2 * ry),
        ("-y/2", -ry * inv_mod(2, p)),
        ("-(y+1)", -(ry + 1)),
        ("-(y-1)", -(ry - 1)),
        ("-(1-y)", -(1 - ry)),
    ]:
        if rz == val % p:
            labels.append(f"r={name}")
    for name, val in [
        ("cy", cy),
        ("-cy", -cy),
        ("cy+ce", cy + e),
        ("cy-ce", cy - e),
        ("ce-cy", e - cy),
    ]:
        if cz == val % 3:
            labels.append(f"c={name}")
    return tuple(labels) or ("unlabeled",)


def candidate_reply_specs(p: int, ce: int) -> list[tuple[str, int, int, int, int]]:
    """Return small affine reply specs.

    A spec is (name, a, b, alpha, gamma), meaning
      r_z = a*r_y + b,  c_z = alpha*c_y + gamma.
    Coefficients are reduced modulo p or 3 when evaluated.
    """
    specs: list[tuple[str, int, int, int, int]] = []
    r_forms = {
        "-y": (-1, 0),
        "-e": (0, -1),
        "2y": (2, 0),
        "-2y": (-2, 0),
        "y/2": (inv_mod(2, p), 0),
        "-y/2": (-inv_mod(2, p), 0),
        "y+1": (1, 1),
        "y-1": (1, -1),
        "1-y": (-1, 1),
        "-y-1": (-1, -1),
        "2y+1": (2, 1),
        "2y-1": (2, -1),
        "-2y+1": (-2, 1),
        "-2y-1": (-2, -1),
    }
    c_forms = {
        "cy": (1, 0),
        "-cy": (-1, 0),
        "ce": (0, ce),
        "-ce": (0, -ce),
        "cy+ce": (1, ce),
        "cy-ce": (1, -ce),
        "ce-cy": (-1, ce),
        "-cy-ce": (-1, -ce),
        "0": (0, 0),
        "1": (0, 1),
        "2": (0, 2),
    }
    for rn, (a, b) in r_forms.items():
        for cn, (alpha, gamma) in c_forms.items():
            specs.append((f"{rn};{cn}", a, b, alpha, gamma))
    return specs


def eval_spec(spec: tuple[str, int, int, int, int], p: int, ce: int, ycoord: tuple[int, int]) -> tuple[int, int]:
    _, a, b, alpha, gamma = spec
    ry, cy = ycoord
    return ((a * ry + b) % p, (alpha * cy + gamma) % 3)


def greedy_cover(universe: dict[tuple[int, int], set[tuple[int, int]]], p: int, ce: int) -> list[tuple[str, int]]:
    uncovered = set(universe)
    out: list[tuple[str, int]] = []
    specs = candidate_reply_specs(p, ce)
    while uncovered:
        best_spec = None
        best_hits: set[tuple[int, int]] = set()
        for spec in specs:
            hits = {y for y in uncovered if eval_spec(spec, p, ce, y) in universe[y]}
            if len(hits) > len(best_hits):
                best_spec = spec
                best_hits = hits
        if not best_spec or not best_hits:
            break
        out.append((best_spec[0], len(best_hits)))
        uncovered -= best_hits
    if uncovered:
        out.append((f"UNCOVERED {sorted(uncovered)}", len(uncovered)))
    return out


def summarize_case(p: int, e: int):
    n = 3 * p
    solver = nim.Solver(n)
    base = frozenset({p % n, e % n})
    u = normalizer(p, e)

    child_rows = []
    class_counts = collections.Counter()
    relation_counts = collections.Counter()
    hit_counts = collections.Counter()
    no_simple = []
    p_children = []
    nonp_universe: dict[tuple[int, int], set[tuple[int, int]]] = {}
    adaptive_universe: dict[tuple[int, int], set[tuple[int, int]]] = {}

    for y, gy in sorted(solver.child_nimbers(base).items()):
        if is_order3(y, p):
            continue
        if gy == 1:
            child_rows.append((y, coord(y, p, u), gy, "BAD-*1-child", []))
            continue
        after_y = base | {y}
        if gy == 0:
            child_rows.append((y, coord(y, p, u), gy, "token", []))
            hit_counts["token"] += 1
            p_children.append((y, coord(y, p, u)))
            continue
        replies = []
        for z, gz in sorted(solver.child_nimbers(after_y).items()):
            if gz != 1:
                continue
            typ = classify_reply(base, y, z, p)
            rel = relation_features(p, e, y, z, u)
            replies.append((z, coord(z, p, u), typ, rel))
            class_counts[typ] += 1
            relation_counts[rel] += 1
        types = {row[2] for row in replies}
        if "mirror-new" in types:
            hit_counts["has-mirror"] += 1
        elif "close-defect" in types:
            hit_counts["has-close"] += 1
        elif any(t.endswith("block") for t in types):
            hit_counts["has-block"] += 1
        elif replies:
            hit_counts["adaptive-only"] += 1
            no_simple.append((y, coord(y, p, u), gy, replies))
        else:
            hit_counts["NO-*1-reply"] += 1
            no_simple.append((y, coord(y, p, u), gy, replies))
        if replies:
            ycoord = coord(y, p, u)
            nonp_universe[ycoord] = {row[1] for row in replies}
            if not ({"mirror-new", "close-defect"} & types) and not any(t.endswith("block") for t in types):
                adaptive_universe[ycoord] = {row[1] for row in replies}
        child_rows.append((y, coord(y, p, u), gy, "board", replies))

    return {
        "p": p,
        "e": e,
        "n": n,
        "u": u,
        "base_g": solver.grundy(base),
        "child_rows": child_rows,
        "class_counts": class_counts,
        "relation_counts": relation_counts,
        "hit_counts": hit_counts,
        "adaptive_only": no_simple,
        "p_children": p_children,
        "nonp_cover": greedy_cover(nonp_universe, p, e % 3),
        "adaptive_cover": greedy_cover(adaptive_universe, p, e % 3),
        "memo": len(solver.memo),
    }


def print_report(report, max_rows: int):
    print(f"=== p={report['p']} e={report['e']} Z{report['n']}  u={report['u']} ===")
    print(f"base G=*{report['base_g']}  memo={report['memo']}")
    print("child coverage:")
    for k, v in report["hit_counts"].most_common():
        print(f"  {k:16s} {v}")
    print("P-child coordinates:")
    print("  " + " ".join(f"{coord}" for _, coord in report["p_children"]))
    print("greedy small-affine cover of non-P children:")
    for name, hits in report["nonp_cover"]:
        print(f"  {name:18s} {hits}")
    print("greedy small-affine cover of adaptive-only children:")
    for name, hits in report["adaptive_cover"]:
        print(f"  {name:18s} {hits}")
    print("all *1 reply classes:")
    for k, v in report["class_counts"].most_common():
        print(f"  {k:18s} {v}")
    print("common reply relation labels:")
    for rel, v in report["relation_counts"].most_common(12):
        print(f"  {','.join(rel):42s} {v}")
    if report["adaptive_only"]:
        print("adaptive-only children:")
        for y, cy, gy, replies in report["adaptive_only"][:max_rows]:
            print(f"  Alice y={y:2d} coord={cy} child=*{gy}  replies={len(replies)}")
            for z, cz, typ, rel in replies[:6]:
                print(f"     z={z:2d} coord={cz} {typ:16s} {','.join(rel)}")
    print("sample child rows:")
    rows = [row for row in report["child_rows"] if row[3] == "board"][:max_rows]
    for y, cy, gy, _, replies in rows:
        top = replies[:4]
        print(f"  y={y:2d} coord={cy} child=*{gy} *1-replies={len(replies)}")
        for z, cz, typ, rel in top:
            print(f"     z={z:2d} coord={cz} {typ:16s} {','.join(rel)}")
    print()


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--primes", default="7,11,13,17", help="comma-separated primes p")
    ap.add_argument("--branches", default="1,3", help="comma-separated e representatives")
    ap.add_argument("--max-rows", type=int, default=10)
    args = ap.parse_args()

    for p in [int(x) for x in args.primes.split(",") if x]:
        for e in [int(x) for x in args.branches.split(",") if x]:
            print_report(summarize_case(p, e), args.max_rows)


if __name__ == "__main__":
    main()
