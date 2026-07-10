#!/usr/bin/env python3
"""Emit and independently rules-check small queens Grundy books (C50 prototype).

The certificate is a complete reachable DAG.  Each NODE claims a Grundy value
and lists one move witnessing each lower value in order.  The checker rebuilds
queen attacks, enumerates every legal child, and checks the exact mex contract:
all values below g occur and no child has value g.
"""

from __future__ import annotations

import argparse
from functools import lru_cache
from pathlib import Path
from time import perf_counter


MAGIC = "GRUNDYBOOK 1"


def queen_closed_neighborhoods(n: int) -> list[int]:
    closed = []
    for r in range(n):
        for c in range(n):
            mask = 0
            for rr in range(n):
                for cc in range(n):
                    if rr == r or cc == c or abs(rr - r) == abs(cc - c):
                        mask |= 1 << (rr * n + cc)
            closed.append(mask)
    return closed


def solve(n: int) -> tuple[int, dict[int, int], dict[int, list[int]]]:
    closed = queen_closed_neighborhoods(n)
    children: dict[int, list[int]] = {}

    @lru_cache(None)
    def grundy(mask: int) -> int:
        moves = [i for i in range(n * n) if mask >> i & 1]
        child_masks = [mask & ~closed[i] for i in moves]
        children[mask] = child_masks
        values = {grundy(child) for child in child_masks}
        g = 0
        while g in values:
            g += 1
        return g

    root = (1 << (n * n)) - 1
    root_g = grundy(root)
    values = {mask: grundy(mask) for mask in children}
    return root_g, values, children


def emit(n: int) -> str:
    root_g, values, children = solve(n)
    closed = queen_closed_neighborhoods(n)
    root = (1 << (n * n)) - 1
    lines = [MAGIC, f"GAME queens {n}", f"ROOT {root:x} {root_g}", f"NODES {len(values)}"]
    for mask in sorted(values, key=lambda m: (-m.bit_count(), m)):
        g = values[mask]
        moves = [i for i in range(n * n) if mask >> i & 1]
        witnesses = []
        for wanted in range(g):
            witnesses.append(next(i for i in moves if values[mask & ~closed[i]] == wanted))
        witness_text = " ".join(map(str, witnesses))
        lines.append(f"NODE {mask:x} {g} {len(witnesses)}" + (f" {witness_text}" if witnesses else ""))
    lines.append("END")
    return "\n".join(lines) + "\n"


def emit_lean(n: int) -> str:
    """Emit a literal Lean artifact consumed by NodeKayles.GrundyCertificate."""
    root_g, values, _children = solve(n)
    closed = queen_closed_neighborhoods(n)
    width = n * n
    root = (1 << width) - 1
    namespace = f"Queens.GrundyCert{n}Generated"
    out = [
        "import NodeKayles.GrundyCertificate",
        "import Queens.Basic",
        "",
        f"namespace {namespace}",
        f"abbrev V := Fin {width}",
        "def live (mask : ℕ) : Finset V :=",
        "  Finset.univ.filter fun i => mask.testBit i.val",
        f"def mv (i : ℕ) (h : i < {width} := by omega) : V := ⟨i, h⟩",
        "open NodeKayles NodeKayles.GrundyBookData",
        f"def nodes : List (GrundyBookNode {width}) := [",
    ]
    rows = []
    for mask in sorted(values, key=lambda m: (-m.bit_count(), m)):
        g = values[mask]
        moves = [i for i in range(width) if mask >> i & 1]
        witnesses = [next(i for i in moves if values[mask & ~closed[i]] == wanted) for wanted in range(g)]
        move_list = ", ".join(f"mv {move}" for move in witnesses)
        rows.append(
            f"  {{ position := live 0x{mask:x}, value := {g}, "
            f"lowerMoves := movesOfList [{move_list}] (by decide) }}"
        )
    out.append(",\n".join(rows))
    out.extend(
        [
            "]",
            f"def book : GrundyBookData {width} where",
            f"  root := live 0x{root:x}",
            f"  rootValue := {root_g}",
            "  nodes := nodes",
            "theorem check_book : book.check (queenGraph " + str(n) + ") = true := by decide",
            "theorem root_grundy : grundy (queenGraph " + str(n) + ") (live 0x"
            + f"{root:x}) = {root_g} := root_grundy_eq_of_check check_book",
            "#print axioms root_grundy",
            f"end {namespace}",
            "",
        ]
    )
    return "\n".join(out)


def parse(text: str) -> tuple[int, int, int, dict[int, tuple[int, list[int]]]]:
    lines = [line.strip() for line in text.splitlines() if line.strip()]
    if not lines or lines[0] != MAGIC:
        raise ValueError("bad or missing GRUNDYBOOK header")
    if len(lines) < 5 or lines[1].split()[:2] != ["GAME", "queens"]:
        raise ValueError("expected GAME queens <n>")
    n = int(lines[1].split()[2])
    root_parts = lines[2].split()
    count_parts = lines[3].split()
    if root_parts[0] != "ROOT" or count_parts[0] != "NODES" or lines[-1] != "END":
        raise ValueError("malformed book framing")
    root, root_g = int(root_parts[1], 16), int(root_parts[2])
    expected_count = int(count_parts[1])
    nodes: dict[int, tuple[int, list[int]]] = {}
    for line in lines[4:-1]:
        fields = line.split()
        if len(fields) < 4 or fields[0] != "NODE":
            raise ValueError(f"bad node row: {line}")
        mask, g, nw = int(fields[1], 16), int(fields[2]), int(fields[3])
        witnesses = list(map(int, fields[4:]))
        if len(witnesses) != nw:
            raise ValueError(f"witness count mismatch at {mask:x}")
        if mask in nodes:
            raise ValueError(f"duplicate node {mask:x}")
        nodes[mask] = (g, witnesses)
    if len(nodes) != expected_count:
        raise ValueError(f"node count mismatch: declared {expected_count}, parsed {len(nodes)}")
    return n, root, root_g, nodes


def check(text: str) -> dict[str, int]:
    """Rules-only validation: no recursive Grundy solver is called here."""
    n, root, root_g, nodes = parse(text)
    if root != (1 << (n * n)) - 1:
        raise ValueError("root is not the full queens board")
    if nodes.get(root, (None,))[0] != root_g:
        raise ValueError("root claim missing or inconsistent")
    closed = queen_closed_neighborhoods(n)
    edges = 0
    reachable = {root}
    stack = [root]
    while stack:
        mask = stack.pop()
        g, witnesses = nodes[mask]
        moves = [i for i in range(n * n) if mask >> i & 1]
        child_values: dict[int, int] = {}
        for move in moves:
            child = mask & ~closed[move]
            if child not in nodes:
                raise ValueError(f"node {mask:x}: missing legal child {child:x} via {move}")
            child_values[move] = nodes[child][0]
            edges += 1
            if child not in reachable:
                reachable.add(child)
                stack.append(child)
        if len(witnesses) != g:
            raise ValueError(f"node {mask:x}: expected {g} lower witnesses")
        for wanted, move in enumerate(witnesses):
            if move not in child_values:
                raise ValueError(f"node {mask:x}: illegal lower witness {move}")
            if child_values[move] != wanted:
                raise ValueError(
                    f"node {mask:x}: witness {move} has value {child_values[move]}, wanted {wanted}"
                )
        if g in child_values.values():
            raise ValueError(f"node {mask:x}: legal child has forbidden value {g}")
    if reachable != set(nodes):
        raise ValueError(f"book has {len(set(nodes) - reachable)} unreachable nodes")
    return {"n": n, "root_grundy": root_g, "nodes": len(nodes), "edges": edges}


def selftest() -> None:
    good = emit(3)
    assert check(good)["root_grundy"] == 2
    corruptions = [
        good.replace("ROOT 1ff 2", "ROOT 1ff 1", 1),
        good.replace("NODES 10", "NODES 9", 1),
        good.replace("NODE 1ff 2 2", "NODE 1ff 2 1", 1),
        good.replace("NODES 10", "NODES 9", 1).replace("NODE 5 1 1 0\n", "", 1),
    ]
    for bad in corruptions:
        try:
            check(bad)
        except ValueError:
            pass
        else:
            raise AssertionError("corrupted certificate unexpectedly passed")
    print(f"C50-SELFTEST corruptions={len(corruptions)} verdict=PASS")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--n", type=int, default=3)
    parser.add_argument("--out", type=Path)
    parser.add_argument("--lean-out", type=Path)
    parser.add_argument("--growth", action="store_true")
    args = parser.parse_args()
    selftest()
    if args.growth:
        for n in range(1, 7):
            started = perf_counter()
            text = emit(n)
            stats = check(text)
            print(
                f"C50-GROWTH n={n} grundy={stats['root_grundy']} nodes={stats['nodes']} "
                f"edges={stats['edges']} bytes={len(text.encode())} elapsed={perf_counter()-started:.6f}"
            )
    text = emit(args.n)
    stats = check(text)
    if args.out:
        args.out.write_text(text)
    if args.lean_out:
        args.lean_out.write_text(emit_lean(args.n))
    print("C50-CHECK " + " ".join(f"{key}={value}" for key, value in stats.items()) + " verdict=PASS")


if __name__ == "__main__":
    main()
