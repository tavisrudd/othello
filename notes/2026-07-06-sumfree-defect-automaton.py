#!/usr/bin/env python3
"""Mine the adaptive {p,e}+*1 strategy in defect/pair coordinates.

This is a proof-search helper, not a solver replacement. It imports the small
independent cyclic nimber solver from this note series and explores token-present
*1 boards reachable under an oracle responder policy:

  * if Alice's board move lands on a P child, Rita takes the token;
  * otherwise Rita replies with a board move to a *1 child, preferring mirror,
    then closing an existing defect, then the smallest (defects,-pairs,size) child.

The output is intended to expose the finite transition grammar needed for the
adaptive proof of the *1-absent half.
"""

from __future__ import annotations

import argparse
import collections
from importlib.machinery import SourceFileLoader
from pathlib import Path

TOKEN = -1

HERE = Path(__file__).resolve().parent
nim = SourceFileLoader("sumfree_nim_solver", str(HERE / "2026-07-06-sumfree-nim-solver.py")).load_module()


def is_order3(x: int, p: int, n: int) -> bool:
    return x % n in (p % n, (2 * p) % n)


def defects(board: frozenset[int], p: int, n: int) -> tuple[int, ...]:
    return tuple(sorted(x for x in board if not is_order3(x, p, n) and (-x) % n not in board))


def pair_count(board: frozenset[int], p: int, n: int) -> int:
    seen: set[int] = set()
    out = 0
    for x in board:
        if is_order3(x, p, n) or x in seen:
            continue
        y = (-x) % n
        if y in board and y not in seen:
            out += 1
            seen.add(x)
            seen.add(y)
    return out


def shape(board: frozenset[int], p: int, n: int) -> tuple[int, int, int]:
    return (len(board), len(defects(board, p, n)), pair_count(board, p, n))


def inv2(n: int) -> int:
    return (n + 1) // 2


def defect_blocks(d: int, p: int, n: int) -> dict[str, int]:
    h = inv2(n)
    return {
        "2d": (2 * d) % n,
        "d+p": (d + p) % n,
        "d/2": (d * h) % n,
    }


def classify_reply(board: frozenset[int], p: int, m: int, z: int | None) -> str:
    n = 3 * p
    if z is None:
        return "take-token"
    if z == (-m) % n:
        return "mirror-new"
    ds = defects(board, p, n)
    if z in {(-d) % n for d in ds}:
        return "close-defect"
    for d in ds:
        if z in {(-w) % n for w in defect_blocks(d, p, n).values()}:
            return "old-defect-block"
    if z in {(-w) % n for w in defect_blocks(m, p, n).values()}:
        return "new-defect-block"
    return "adaptive-other"


def choose_reply(solver, p: int, board: frozenset[int], token: bool, alice_move: int):
    n = 3 * p
    if alice_move == TOKEN:
        p_children = [z for z, g in solver.child_nimbers(board).items() if g == 0]
        for d in defects(board, p, n):
            close = (-d) % n
            if close in p_children:
                return ("board", close)
        return ("board", p_children[0]) if p_children else None

    after_alice = board | {alice_move}
    if token and solver.grundy(after_alice) == 0:
        return ("token", None)

    target = 1 if token else 0
    candidates = [z for z, g in solver.child_nimbers(after_alice).items() if g == target]
    if not candidates:
        return None

    mirror = (-alice_move) % n
    if mirror in candidates:
        return ("board", mirror)

    for d in defects(board, p, n):
        close = (-d) % n
        if close in candidates:
            return ("board", close)

    def key(z: int) -> tuple[int, int, int, int]:
        after_reply = after_alice | {z}
        return (len(defects(after_reply, p, n)), -pair_count(after_reply, p, n), len(after_reply), z)

    return ("board", min(candidates, key=key))


def explore(p: int, e: int, max_states: int):
    n = 3 * p
    solver = nim.Solver(n)
    initial = frozenset({p % n, e % n})
    g_initial = solver.grundy(initial)
    if g_initial != 1:
        raise RuntimeError(f"expected {{{p},{e}}} to be *1 in Z{n}, got *{g_initial}")

    queue = [initial]
    seen = {initial}
    shape_counts = collections.Counter()
    edge_counts = collections.Counter()
    transition_counts = collections.Counter()
    adaptive_examples = []
    failures = []

    while queue and len(seen) < max_states:
        board = queue.pop()
        before_shape = shape(board, p, n)
        shape_counts[before_shape] += 1

        for alice_move in [TOKEN] + solver.legal(board):
            reply = choose_reply(solver, p, board, True, alice_move)
            if reply is None:
                failures.append((sorted(board), alice_move))
                continue
            kind, z = reply
            if alice_move == TOKEN:
                edge_counts["alice-token/rita-board-P"] += 1
                continue
            after_alice = board | {alice_move}
            if kind == "token":
                edge_counts["rita-token-after-P-child"] += 1
                transition_counts[(before_shape, "take-token", "terminal-P")] += 1
                continue
            after_reply = after_alice | {z}
            g_after = solver.grundy(after_reply)
            if g_after != 1:
                failures.append((sorted(board), alice_move, z, g_after))
                continue
            typ = classify_reply(board, p, alice_move, z)
            after_shape = shape(after_reply, p, n)
            edge_counts[typ] += 1
            transition_counts[(before_shape, typ, after_shape)] += 1
            if typ.startswith("adaptive") or typ.endswith("block"):
                if len(adaptive_examples) < 16:
                    adaptive_examples.append(
                        (sorted(board), before_shape, alice_move, z, typ, sorted(after_reply), after_shape)
                    )
            if after_reply not in seen:
                seen.add(after_reply)
                queue.append(after_reply)

    return {
        "p": p,
        "e": e,
        "n": n,
        "seen": len(seen),
        "memo": len(solver.memo),
        "failures": failures,
        "shape_counts": shape_counts,
        "edge_counts": edge_counts,
        "transition_counts": transition_counts,
        "adaptive_examples": adaptive_examples,
    }


def print_report(report, max_rows: int):
    print(f"=== p={report['p']} e={report['e']} Z{report['n']} ===")
    print(f"token-present *1 boards reached: {report['seen']}   memo={report['memo']}   failures={len(report['failures'])}")
    print("reply counts:")
    for k, v in report["edge_counts"].most_common():
        print(f"  {k:28s} {v}")
    print("shape counts (size, defects, pairs):")
    for k, v in report["shape_counts"].most_common(max_rows):
        print(f"  {k}: {v}")
    print("transition counts:")
    for (src, typ, dst), v in report["transition_counts"].most_common(max_rows):
        print(f"  {src} --{typ}--> {dst}: {v}")
    if report["adaptive_examples"]:
        print("adaptive/block examples:")
        for board, src, m, z, typ, after, dst in report["adaptive_examples"]:
            print(f"  {src} board={board}  Alice {m} -> Rita {z} [{typ}] -> {dst} {after}")
    if report["failures"]:
        print("FAILURES:")
        for row in report["failures"][:max_rows]:
            print(f"  {row}")
    print()


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--primes", default="7,11,13", help="comma-separated primes p")
    ap.add_argument("--branches", default="1,3", help="comma-separated e representatives")
    ap.add_argument("--max-states", type=int, default=200000)
    ap.add_argument("--max-rows", type=int, default=20)
    args = ap.parse_args()

    for p in [int(x) for x in args.primes.split(",") if x]:
        for e in [int(x) for x in args.branches.split(",") if x]:
            print_report(explore(p, e, args.max_states), args.max_rows)


if __name__ == "__main__":
    main()
