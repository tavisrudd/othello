#!/usr/bin/env python3
"""Certify the C682 normalized-graph/Schlaefli row-swap identification.

The load-bearing computational input is the exact characteristic-zero
cross-Gram certificate.  This checker compares its two 6-by-10 fibres with
the two canonical edge relations attached to the six Sylow-five subgroups
of A5.  Comparison is marking-independent: bipartite incidence matrices are
put in a canonical form under row and column relabelling.
"""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
INPUT = HERE / "2026-07-29-c682-d5-s3-kernel-incidence.json"
MARKING = HERE / "2026-07-29-c682-common-marking-sign.json"
OUTPUT = HERE / "2026-07-29-c682-normalized-graph-row-swap.json"


def compose(p: tuple[int, ...], q: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(p[q[i]] for i in range(5))


def inverse(p: tuple[int, ...]) -> tuple[int, ...]:
    out = [0] * 5
    for i, x in enumerate(p):
        out[x] = i
    return tuple(out)


def parity(p: tuple[int, ...]) -> int:
    return sum(p[i] > p[j] for i in range(5) for j in range(i + 1, 5)) % 2


def order(p: tuple[int, ...]) -> int:
    x = tuple(range(5))
    for n in range(1, 61):
        x = compose(p, x)
        if x == tuple(range(5)):
            return n
    raise AssertionError("permutation order exceeded 60")


def subgroup_generated_by(g: tuple[int, ...]) -> frozenset[tuple[int, ...]]:
    out = {tuple(range(5))}
    x = tuple(range(5))
    for _ in range(4):
        x = compose(g, x)
        out.add(x)
    return frozenset(out)


def edges_of_cycle(g: tuple[int, ...]) -> frozenset[tuple[int, int]]:
    return frozenset(tuple(sorted((i, g[i]))) for i in range(5))


def canonical_bipartite(matrix: list[list[int]]) -> str:
    """Canonical signature under independent row and column permutations."""
    rows = len(matrix)
    cols = len(matrix[0])
    best: str | None = None
    for rp in itertools.permutations(range(rows)):
        column_words = sorted(
            "".join(str(matrix[rp[i]][j]) for i in range(rows))
            for j in range(cols)
        )
        signature = "|".join(column_words)
        if best is None or signature < best:
            best = signature
    assert best is not None
    return best


def a5_relations() -> tuple[list[list[int]], list[list[int]], dict[str, int]]:
    a5 = [p for p in itertools.permutations(range(5)) if parity(p) == 0]
    five_cycles = [p for p in a5 if order(p) == 5]
    sylow = sorted(
        {subgroup_generated_by(g) for g in five_cycles},
        key=lambda h: sorted(h),
    )
    assert len(a5) == 60 and len(five_cycles) == 24 and len(sylow) == 6

    # A5 has two conjugacy classes of five-cycles.  In each Sylow subgroup,
    # one class gives the pentagon edges and the other its five diagonals.
    seed = five_cycles[0]
    class_plus = {
        compose(compose(a, seed), inverse(a))
        for a in a5
    }
    class_minus = set(five_cycles) - class_plus
    assert len(class_plus) == len(class_minus) == 12

    edges = list(itertools.combinations(range(5), 2))
    plus: list[list[int]] = []
    minus: list[list[int]] = []
    for h in sylow:
        hp = sorted(set(h) & class_plus)
        hm = sorted(set(h) & class_minus)
        assert len(hp) == len(hm) == 2
        ep = edges_of_cycle(hp[0])
        em = edges_of_cycle(hm[0])
        assert ep.isdisjoint(em) and ep | em == frozenset(edges)
        plus.append([int(e in ep) for e in edges])
        minus.append([int(e in em) for e in edges])

    odd = next(p for p in itertools.permutations(range(5)) if parity(p) == 1)
    conjugated = {
        compose(compose(odd, g), inverse(odd))
        for g in class_plus
    }
    assert conjugated == class_minus
    return plus, minus, {
        "A5_order": len(a5),
        "five_cycle_count": len(five_cycles),
        "five_cycle_class_size": len(class_plus),
        "D5_row_count": len(sylow),
        "S3_edge_count": len(edges),
    }


def build_certificate() -> dict[str, object]:
    raw = INPUT.read_bytes()
    source = json.loads(raw)
    marking_raw = MARKING.read_bytes()
    marking = json.loads(marking_raw)
    incidence = source["incidence"]
    golden_plus = incidence["lambda_plus_incidence"]
    assert incidence["lambda_minus_is_complement"] is True
    golden_minus = [[1 - x for x in row] for row in golden_plus]
    assert [sum(row) for row in golden_plus] == [5] * 6
    assert [sum(golden_plus[i][j] for i in range(6)) for j in range(10)] == [3] * 10

    sides, diagonals, counts = a5_relations()
    side_signature = canonical_bipartite(sides)
    diagonal_signature = canonical_bipartite(diagonals)
    plus_signature = canonical_bipartite(golden_plus)
    minus_signature = canonical_bipartite(golden_minus)
    assert side_signature == diagonal_signature
    assert plus_signature == side_signature
    assert minus_signature == diagonal_signature
    sign = marking["sign_conclusion"]
    assert sign["stored_matrix_fibre"] == "lambda_plus"
    assert sign["stored_matrix_centered_theta"] == "+sqrt(5)"
    assert marking["stabilizer_matching"]["lambda_minus_equals_stored"] is False

    return {
        "schema": "c682-normalized-graph-row-swap-v1",
        "inputs": [
            {
                "path": INPUT.name,
                "bytes": len(raw),
                "sha256": hashlib.sha256(raw).hexdigest(),
            },
            {
                "path": MARKING.name,
                "bytes": len(marking_raw),
                "sha256": hashlib.sha256(marking_raw).hexdigest(),
            },
        ],
        "counts": counts,
        "golden_fibres": {
            "shape": [6, 10],
            "edge_counts": [sum(map(sum, golden_plus)), sum(map(sum, golden_minus))],
            "row_degrees": [5, 5],
            "column_degrees": [3, 3],
            "complementary": True,
        },
        "schlafli_marking": {
            "first_row": "pentagon sides from one A5 five-cycle class",
            "polar_row": "pentagram diagonals from the other A5 five-cycle class",
            "odd_label_permutation_exchanges_rows": True,
            "relations_are_complementary": True,
        },
        "comparison": {
            "marking_independent_bipartite_signature": side_signature,
            "lambda_plus_is_one_schlafli_row_relation": True,
            "lambda_minus_is_the_polar_row_relation": True,
            "frozen_marking_plus_sign_imported": True,
            "deck_exchange_equals_row_swap": True,
        },
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    certificate = build_certificate()
    rendered = json.dumps(certificate, indent=2, sort_keys=True) + "\n"
    if args.check:
        assert OUTPUT.read_text() == rendered
        print("ok: normalized-graph deck exchange is the Schlaefli row swap")
    else:
        OUTPUT.write_text(rendered)


if __name__ == "__main__":
    main()
