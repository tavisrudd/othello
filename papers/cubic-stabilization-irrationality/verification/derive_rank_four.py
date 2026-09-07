#!/usr/bin/env python3
"""Exact exhaustion for rank-four subtori in the full type-I3 Cox model."""
import argparse
import ast
from collections import Counter
from hashlib import sha256
from itertools import combinations, product
import json
from pathlib import Path
import sys

import sympy as sp

if sys.flags.optimize:
    raise RuntimeError("assertions must be enabled")

HERE = Path(__file__).resolve().parent
INPUT_HASH = "89eee9a9d04cb555e45c8b4f461bbf20ccb6b1d38cfabdad2b8ce67c1ff42373"


def rows(matrix):
    return [[int(x) for x in row] for row in matrix.tolist()]


def derive():
    assert sha256((HERE / "derive_slice_cover.py").read_bytes()).hexdigest() == INPUT_HASH
    source = ast.parse((HERE / "derive_slice_cover.py").read_text())
    literals = {}
    for node in source.body:
        if isinstance(node, ast.Assign) and isinstance(node.targets[0], ast.Name):
            if node.targets[0].id == "CHARACTER_GENERATORS":
                literals["generators"] = [ast.literal_eval(call.args[0]) for call in node.value.elts]
            if node.targets[0].id == "ROOT_BASIS":
                literals["roots"] = [ast.literal_eval(call.args[0]) for call in node.value.args]
    CHARACTER_GENERATORS = tuple(sp.Matrix(a) for a in literals["generators"])
    ROOT_BASIS = sp.Matrix.hstack(*(sp.Matrix(a) for a in literals["roots"]))
    systems = []
    for signs in product((-1, 1), repeat=2):
        system = sp.Matrix.vstack(*(a - s * sp.eye(5)
                                    for a, s in zip(CHARACTER_GENERATORS, signs)))
        systems.append({"signs": list(signs), "rank": system.rank()})
    m = sp.Matrix([-1, -1, -3, -3, 3])
    assert [s["rank"] for s in systems] == [5, 4, 5, 5]
    assert CHARACTER_GENERATORS[0] * m == -m
    assert CHARACTER_GENERATORS[1] * m == m
    # The first coefficient is -1: the remaining standard basis classes
    # form an integral basis of Z^5 / Zm.
    quotient = sp.Matrix([[-1, 1, 0, 0, 0], [-3, 0, 1, 0, 0],
                          [-3, 0, 0, 1, 0], [3, 0, 0, 0, 1]])
    assert quotient * m == sp.zeros(4, 1)
    assert quotient[:, 1:] == sp.eye(4)
    names, divisors = [], []
    for i in range(5):
        names.append(f"E{i+1}")
        divisors.append(sp.eye(6).col(i+1))
    for i, j in combinations(range(5), 2):
        names.append(f"L{i+1}{j+1}")
        divisors.append(sp.eye(6).col(0) - sp.eye(6).col(i+1) - sp.eye(6).col(j+1))
    names.append("Q")
    divisors.append(sp.Matrix([2, -1, -1, -1, -1, -1]))
    # Lift all five dual cocharacters with final Picard coordinate zero.
    lift = sp.zeros(5, 6)
    for i in range(4):
        lift[i, i+1] = 1
    lift[4, 0] = 1
    assert lift * ROOT_BASIS == sp.eye(5)
    weights = [lift * d for d in divisors]
    restricted = [quotient * w for w in weights]
    assert len({tuple(w) for w in restricted}) == 16
    actions = []
    for a in CHARACTER_GENERATORS:
        linear = quotient * a[:, 1:]
        assert linear * quotient == quotient * a
        candidates = []
        for target in restricted:
            shift = target - linear * restricted[0]
            images = [linear * w + shift for w in restricted]
            if {tuple(w) for w in images} == {tuple(w) for w in restricted}:
                candidates.append((shift, [restricted.index(w) for w in images]))
        assert len(candidates) == 1
        shift, permutation = candidates[0]
        actions.append({"linear": rows(linear), "translation": list(map(int, shift)),
                        "permutation": permutation})
    unseen = set(range(16))
    orbits = []
    while unseen:
        orbit = {min(unseen)}
        while True:
            expanded = orbit | {a["permutation"][i] for a in actions for i in orbit}
            if expanded == orbit:
                break
            orbit = expanded
        unseen -= orbit
        orbits.append(sorted(orbit))
    histogram = Counter()
    for subset in combinations(range(16), 5):
        base = restricted[subset[0]]
        matrix = sp.Matrix.hstack(*(restricted[i] - base for i in subset[1:]))
        histogram[abs(int(matrix.det()))] += 1
    blocks = {}
    for name, weight in zip(names, weights):
        blocks.setdefault(tuple(map(int, weight[2:])), []).append(name)
    return {
        "schema": "cox-rank-four-v1", "input_sha256": INPUT_HASH,
        "character_generators": [rows(a) for a in CHARACTER_GENERATORS],
        "sign_systems": systems, "primitive_character": list(map(int, m)),
        "quotient_matrix": rows(quotient), "names": names,
        "full_weights": [list(map(int, w)) for w in weights],
        "restricted_weights": [list(map(int, w)) for w in restricted],
        "affine_actions": actions, "orbits": orbits,
        "five_subset_count": sum(histogram.values()),
        "absolute_determinant_histogram": {str(k): histogram[k] for k in sorted(histogram)},
        "rank_three_blocks": [{"weight": list(w), "names": blocks[w]} for w in sorted(blocks)],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true", help="replace the derived certificate")
    args = parser.parse_args()
    result = derive()
    data = json.dumps(result, indent=2, sort_keys=True) + "\n"
    vector = ",".join(map(str, result["primitive_character"]))
    ranks = ",".join(str(s["rank"]) for s in result["sign_systems"])
    tex = "% Generated by derive_rank_four.py; do not edit.\n"
    tex += rf"\newcommand{{\RankFourCharacter}}{{({vector})}}" + "\n"
    tex += rf"\newcommand{{\RankFourSystemRanks}}{{({ranks})}}" + "\n"
    tex += rf"\newcommand{{\RankFourSubsetCount}}{{{result['five_subset_count']:,}}}".replace(",", "{,}") + "\n"
    tex += rf"\newcommand{{\RankFourUnimodularCount}}{{{result['absolute_determinant_histogram']['1']:,}}}".replace(",", "{,}") + "\n"
    for name, content in (("rank-four-certificate.json", data), ("rank-four-values.tex", tex)):
        target = HERE / name
        if args.write:
            target.write_text(content)
        else:
            assert target.read_text() == content, f"stale {name}"
    print("rank-four reconstruction: 4 sign systems, 16 weights, "
          f"{result['five_subset_count']} five-subsets; "
          f"{result['absolute_determinant_histogram'].get('1', 0)} unimodular")


if __name__ == "__main__":
    main()
