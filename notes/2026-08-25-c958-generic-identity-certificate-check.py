#!/usr/bin/env python3
"""Independent stdlib audit of the C958 generic identity proof transcript."""

import argparse
import hashlib
import itertools
import json
import math
from pathlib import Path
import sys

if sys.flags.optimize:
    raise RuntimeError("verification must run with Python assertions enabled")


def sha256(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def is_prime_u64(value):
    if value < 2:
        return False
    for prime in (2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37):
        if value % prime == 0:
            return value == prime
    odd_part = value - 1
    power = 0
    while odd_part % 2 == 0:
        odd_part //= 2
        power += 1
    for base in (2, 325, 9375, 28178, 450775, 9780504, 1795265022):
        residue = pow(base % value, odd_part, value)
        if residue in (1, value - 1):
            continue
        for _ in range(power - 1):
            residue = residue * residue % value
            if residue == value - 1:
                break
        else:
            return False
    return True


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("forward", type=Path)
    parser.add_argument("inverse", type=Path)
    parser.add_argument("rho_summary", type=Path)
    parser.add_argument("bound", type=Path)
    parser.add_argument("replay", type=Path)
    arguments = parser.parse_args()
    inverse = json.loads(arguments.inverse.read_text())
    rho = json.loads(arguments.rho_summary.read_text())
    bound = json.loads(arguments.bound.read_text())
    replay = json.loads(arguments.replay.read_text())
    assert rho["schema"] == "c958-generic-rho-summary-v1"
    assert bound["schema"] == "c958-generic-identity-bound-v1"
    assert replay["schema"] == "c958-generic-identity-replay-v1"
    for path in (arguments.forward, arguments.inverse, arguments.rho_summary):
        assert bound["input_sha256"][str(path)] == sha256(path)
    for path in (arguments.forward, arguments.inverse, arguments.bound):
        assert replay["input_sha256"][str(path)] == sha256(path)
    grid_checker = Path(__file__).with_name(
        "2026-08-25-c958-generic-identity-grid-check.py"
    )
    root = Path(__file__).resolve().parents[1]
    grid_key = str(grid_checker.resolve().relative_to(root))
    assert replay["input_sha256"][grid_key] == sha256(grid_checker)

    primes = [int(value) for value in bound["primes"]]
    assert len(primes) == len(set(primes))
    assert all(value < 2**64 and is_prime_u64(value) for value in primes)
    assert math.prod(primes) == int(bound["prime_product"])
    norm_bounds = [int(value) for value in bound["residual_l1_norm_bounds"]]
    assert math.prod(primes) > 2 * max(norm_bounds)

    exponent_order = [entries for entries in itertools.product(range(6), repeat=4)
                      if sum(entries) <= 5]
    rho_norms = [int(value) for value in rho["rho_l1_norms"]]
    independently_computed = []
    for vector in inverse["vectors"]:
        total = 0
        for item in vector:
            affine = exponent_order[item["inverse_vector_index"] % 126]
            exponents = (5 - sum(affine), *affine)
            coefficient_norm = sum(
                abs(int(term["coefficient"]))
                for term in item["coefficient_polynomial"]
            )
            total += coefficient_norm * math.prod(
                value**exponent for value, exponent in zip(rho_norms, exponents)
            )
        independently_computed.append(total)
    assert independently_computed == norm_bounds

    degrees = [tuple(value) for value in bound["residual_parameter_degree_bounds"]]
    base = int(bound["kronecker_base"])
    assert all(degree[1] < base for degree in degrees)
    stop = max(degree[0] * base + degree[1] for degree in degrees) + 1
    assert replay["kronecker_base"] == base
    assert replay["evaluation_range"] == [0, stop]
    results = replay["prime_results"]
    assert sorted(item["prime"] for item in results) == sorted(primes)
    for item in results:
        assert item["result"] == (
            f"prime={item['prime']} zero_grid=[0,{stop}) kronecker_base={base}"
        )
    print(
        f"certified_primes={len(primes)} grid_size={stop} "
        f"coefficient_bound_digits={len(str(max(norm_bounds)))}"
    )
    print("conclusion=exact_generic_identity_over_Z")


if __name__ == "__main__":
    main()
