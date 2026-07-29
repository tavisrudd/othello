#!/usr/bin/env python3
"""Independent finite-group replay for the C682 row-swap theorem."""

from __future__ import annotations

import itertools
import json


Perm = tuple[int, ...]
ID = tuple(range(5))


def mul(a: Perm, b: Perm) -> Perm:
    return tuple(a[b[i]] for i in range(5))


def inv(a: Perm) -> Perm:
    return tuple(a.index(i) for i in range(5))


def even(a: Perm) -> bool:
    return sum(a[i] > a[j] for i in range(5) for j in range(i + 1, 5)) % 2 == 0


def pow_perm(a: Perm, n: int) -> Perm:
    out = ID
    for _ in range(n):
        out = mul(a, out)
    return out


def is_five_cycle(a: Perm) -> bool:
    return a != ID and pow_perm(a, 5) == ID and all(pow_perm(a, n) != ID for n in range(1, 5))


def main() -> None:
    group = [p for p in itertools.permutations(range(5)) if even(p)]
    cycles = [p for p in group if is_five_cycle(p)]
    seed = cycles[0]
    class_a = {mul(mul(x, seed), inv(x)) for x in group}
    class_b = set(cycles) - class_a
    sylow = {
        frozenset(pow_perm(g, n) for n in range(5))
        for g in cycles
    }
    edges = set(itertools.combinations(range(5), 2))

    relations = []
    for conjugacy_class in (class_a, class_b):
        relation = set()
        for h in sylow:
            g = next(iter(set(h) & conjugacy_class))
            cycle_edges = {tuple(sorted((i, g[i]))) for i in range(5)}
            relation.update((h, e) for e in cycle_edges)
        relations.append(relation)

    assert len(group) == 60
    assert len(class_a) == len(class_b) == 12
    assert len(sylow) == 6 and len(edges) == 10
    assert len(relations[0]) == len(relations[1]) == 30
    assert relations[0].isdisjoint(relations[1])
    assert relations[0] | relations[1] == {(h, e) for h in sylow for e in edges}
    assert {sum((h, e) in relations[0] for e in edges) for h in sylow} == {5}
    assert {sum((h, e) in relations[0] for h in sylow) for e in edges} == {3}

    odd = next(p for p in itertools.permutations(range(5)) if not even(p))
    assert {mul(mul(odd, g), inv(odd)) for g in class_a} == class_b

    print(json.dumps({
        "A5_order": 60,
        "D5_rows": 6,
        "S3_edges": 10,
        "relation_sizes": [30, 30],
        "row_degrees": [5, 5],
        "column_degrees": [3, 3],
        "row_swap": "five-cycle class exchange sends sides to complementary diagonals",
        "result": "pass",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
