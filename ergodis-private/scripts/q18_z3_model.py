#!/usr/bin/env python3
"""Emit the unrestricted q18 compressed GS equations as bounded QF_NIA.

Z3 is an untrusted discovery oracle here.  Any model must pass the independent
Rust q18 presentation verifier before it has even positive evidentiary status.
"""

import argparse
import json

BLOCKS = 4
ORDER = 18
TARGETS = [1976] + [-116] * 9
ROW_SUMS = [2, 0, 0, 0]

parser = argparse.ArgumentParser()
parser.add_argument("--seed-json")
parser.add_argument("--radius", type=int, default=2)
args = parser.parse_args()
seed = None
if args.seed_json:
    with open(args.seed_json, "rb") as source:
        seed = json.load(source)["best_coefficients"]


def variable(block: int, point: int) -> str:
    return f"r_{block}_{point}"


def signed(block: int, point: int) -> str:
    return f"(- (* 2 {variable(block, point)}) 29)"


print("(set-logic QF_NIA)")
print("(set-option :produce-models true)")
for block in range(BLOCKS):
    for point in range(ORDER):
        name = variable(block, point)
        print(f"(declare-fun {name} () Int)")
        print(f"(assert (and (<= 0 {name}) (<= {name} 29)))")
        if seed is not None:
            center = (seed[block][point] + 29) // 2
            lower = max(0, center - args.radius)
            upper = min(29, center + args.radius)
            print(f"(assert (and (<= {lower} {name}) (<= {name} {upper})))")
for block, target in enumerate(ROW_SUMS):
    terms = " ".join(signed(block, point) for point in range(ORDER))
    print(f"(assert (= (+ {terms}) {target}))")
if seed is None:
    # Exact symmetry representatives: one common cyclic shift/reversal,
    # independent negation of the zero-sum blocks, and their S3 permutation.
    for point in range(1, ORDER):
        print(f"(assert (>= {variable(0, 0)} {variable(0, point)}))")
    print(f"(assert (>= {variable(0, 1)} {variable(0, ORDER - 1)}))")
    for block in range(1, BLOCKS):
        print(f"(assert (>= {variable(block, 0)} 15))")
    energies = [
        f"(+ {' '.join(f'(* {signed(block, point)} {signed(block, point)})' for point in range(ORDER))})"
        for block in range(BLOCKS)
    ]
    print(f"(assert (>= {energies[1]} {energies[2]}))")
    print(f"(assert (>= {energies[2]} {energies[3]}))")
for shift, target in enumerate(TARGETS):
    products = []
    for block in range(BLOCKS):
        for point in range(ORDER):
            products.append(
                f"(* {signed(block, point)} {signed(block, (point + shift) % ORDER)})"
            )
    print(f"(assert (= (+ {' '.join(products)}) {target}))")
print("(check-sat)")
print("(get-model)")
