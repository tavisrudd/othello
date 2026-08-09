#!/usr/bin/env python3
"""Exact checks for the C756 signed-resultant/monodromy pivot.

The script reuses the independently checked split-fibre enumerator and verifies
the row-resultant identity on every split pair for q=5,7.  It also certifies the
explicit q=7 split fibre used in the full-S5 monodromy argument.
"""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
CENSUS_PATH = HERE / "2026-08-02-c756-split-fiber-census.py"
CERT_PATH = HERE / "2026-08-08-c756-signed-resultant-monodromy-pivot.json"


def load_census():
    spec = importlib.util.spec_from_file_location("c756_split_census", CENSUS_PATH)
    if spec is None or spec.loader is None:
        raise RuntimeError("cannot load split-fibre census module")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def verify_row_identity(module, q: int) -> dict:
    field = module.F2(q)
    nn = (q + 3) // 2
    pairs = module.enumerate_pairs(field, nn)
    n2 = field.n2

    def add(u: int, v: int) -> int:
        return field.add[u * n2 + v]

    def mul(u: int, v: int) -> int:
        return field.mul[u * n2 + v]

    def sub(u: int, v: int) -> int:
        return add(u, field.neg[v])

    def norm(u: int) -> int:
        value = mul(u, field.conj[u])
        assert value < q
        return value

    def derivative_value(coeffs: tuple[int, ...], z: int) -> int:
        value = 0
        power = 1
        for degree in range(1, len(coeffs)):
            value = add(value, mul((degree * coeffs[degree]) % q, power))
            power = mul(power, z)
        return value

    checked = 0
    failures = []
    for roots, coeffs, gamma in pairs:
        gamma_gap_norm = norm(sub(gamma, field.conj[gamma]))
        for i, zi in enumerate(roots):
            row_product = 1
            for j, zj in enumerate(roots):
                if i == j:
                    continue
                fj_at_zi = mul(sub(zi, zj), sub(zi, field.conj[zj]))
                row_product = (row_product * norm(fj_at_zi)) % q

            diagonal_norm = norm(sub(zi, field.conj[zi]))
            derivative_norm = norm(derivative_value(coeffs, zi))
            left = (row_product * diagonal_norm) % q
            right = (derivative_norm * gamma_gap_norm) % q
            checked += 1
            if left != right:
                failures.append(
                    {"q": q, "gamma": gamma, "root": zi, "left": left, "right": right}
                )

    return {
        "q": q,
        "split_pairs": len(pairs),
        "row_checks": checked,
        "failures": failures,
    }


def eval_prime_poly(coeffs: tuple[int, ...], x: int, q: int) -> int:
    value = 0
    for coeff in reversed(coeffs):
        value = (value * x + coeff) % q
    return value


def verify_s5_example(module) -> dict:
    q = 7
    field = module.F2(q)
    nn = 5
    target_r = (0, 2, 6, 0, 4, 1)
    target_gamma = 5 + 4 * q
    target_roots = (7, 9, 11, 19, 20)

    matches = []
    for roots, coeffs, gamma in module.enumerate_pairs(field, nn):
        r_coeffs = (0,) + coeffs[1:]
        if r_coeffs == target_r and gamma == target_gamma:
            matches.append(tuple(roots))
    if matches != [target_roots]:
        raise AssertionError(f"unexpected target fibre: {matches}")

    n2 = field.n2

    def mul(u: int, v: int) -> int:
        return field.mul[u * n2 + v]

    def add(u: int, v: int) -> int:
        return field.add[u * n2 + v]

    def eval_extension(coeffs: tuple[int, ...], x: int) -> int:
        value = 0
        for coeff in reversed(coeffs):
            value = add(mul(value, x), coeff)
        return value

    fibre_values = [eval_extension(target_r, z) for z in target_roots]
    if fibre_values != [target_gamma] * nn:
        raise AssertionError(f"target roots do not form the stated fibre: {fibre_values}")
    if any(field.rational(z) for z in target_roots):
        raise AssertionError("target fibre contains a rational root")
    if any(field.conj[z] in target_roots for z in target_roots):
        raise AssertionError("target fibre contains a conjugate pair")

    derivative = tuple((degree * target_r[degree]) % q for degree in range(1, nn + 1))
    critical_points = tuple(x for x in range(q) if eval_prime_poly(derivative, x, q) == 0)
    critical_values = tuple(eval_prime_poly(target_r, x, q) for x in critical_points)
    if critical_points != (1, 3, 5, 6):
        raise AssertionError(f"unexpected critical points: {critical_points}")
    if len(set(critical_values)) != nn - 1:
        raise AssertionError(f"critical values are not distinct: {critical_values}")

    return {
        "q": q,
        "epsilon": field.eps,
        "R_coefficients_ascending": list(target_r),
        "gamma": field.fmt(target_gamma),
        "roots": [field.fmt(z) for z in target_roots],
        "derivative_coefficients_ascending": list(derivative),
        "critical_points": list(critical_points),
        "critical_values": list(critical_values),
        "verified_conclusions": [
            "the quadratic fibre is totally split, simple, irrational, and conjugation-free",
            "R has four simple finite critical points with pairwise distinct critical values",
            "the standard tame branch-cycle argument gives geometric monodromy S5",
        ],
    }


def build_certificate() -> dict:
    module = load_census()
    return {
        "schema": "c756-signed-resultant-monodromy-pivot-v1",
        "input": {
            "split_fibre_census_script": CENSUS_PATH.name,
            "sha256": sha256(CENSUS_PATH),
        },
        "row_resultant_crosscheck": [verify_row_identity(module, q) for q in (5, 7)],
        "full_symmetric_monodromy_example": verify_s5_example(module),
    }


def canonical_bytes(value: dict) -> bytes:
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true", help="write the canonical certificate")
    parser.add_argument("--check", action="store_true", help="compare against the tracked certificate")
    args = parser.parse_args()
    if args.write == args.check:
        parser.error("choose exactly one of --write or --check")

    data = canonical_bytes(build_certificate())
    if args.write:
        CERT_PATH.write_bytes(data)
        print(f"WROTE {CERT_PATH.name}")
        return

    tracked = CERT_PATH.read_bytes()
    if tracked != data:
        raise SystemExit("CHECK: MISMATCH")
    print("CHECK: AGREE")


if __name__ == "__main__":
    main()
