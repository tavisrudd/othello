#!/usr/bin/env python3
"""Emit an exact finite-bit-vector q18 discovery model for Z3."""

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


def var(block: int, point: int) -> str:
    return f"r_{block}_{point}"


def bv(value: int, width: int) -> str:
    return f"(_ bv{value % (1 << width)} {width})"


def signed6(block: int, point: int) -> str:
    doubled = f"(bvshl ((_ zero_extend 1) {var(block, point)}) {bv(1, 6)})"
    return f"(bvsub {doubled} {bv(29, 6)})"


def extend(expression: str, source_width: int, target_width: int) -> str:
    return f"((_ sign_extend {target_width - source_width}) {expression})"


def bvsum(terms: list[str]) -> str:
    total = terms[0]
    for term in terms[1:]:
        total = f"(bvadd {total} {term})"
    return total


print("(set-logic QF_BV)")
print("(set-option :produce-models true)")
for block in range(BLOCKS):
    for point in range(ORDER):
        name = var(block, point)
        print(f"(declare-fun {name} () (_ BitVec 5))")
        print(f"(assert (bvule {name} {bv(29, 5)}))")
        if seed is not None:
            center = (seed[block][point] + 29) // 2
            lower = max(0, center - args.radius)
            upper = min(29, center + args.radius)
            print(f"(assert (bvule {bv(lower, 5)} {name}))")
            print(f"(assert (bvule {name} {bv(upper, 5)}))")
for block, target in enumerate(ROW_SUMS):
    terms = [extend(signed6(block, point), 6, 12) for point in range(ORDER)]
    print(f"(assert (= {bvsum(terms)} {bv(target, 12)}))")
if seed is None:
    for point in range(1, ORDER):
        print(f"(assert (bvuge {var(0, 0)} {var(0, point)}))")
    print(f"(assert (bvuge {var(0, 1)} {var(0, ORDER - 1)}))")
    for block in range(1, BLOCKS):
        print(f"(assert (bvuge {var(block, 0)} {bv(15, 5)}))")
for shift, target in enumerate(TARGETS):
    products = []
    for block in range(BLOCKS):
        for point in range(ORDER):
            left = extend(signed6(block, point), 6, 12)
            right = extend(signed6(block, (point + shift) % ORDER), 6, 12)
            products.append(extend(f"(bvmul {left} {right})", 12, 18))
    print(f"(assert (= {bvsum(products)} {bv(target, 18)}))")
print("(check-sat)")
print("(get-model)")
