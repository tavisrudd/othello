#!/usr/bin/env python3
"""Generate a verified native CSS-distance problem for a bivariate bicycle code."""

from __future__ import annotations

import argparse
import json
from pathlib import Path


def row_basis(rows: list[int]) -> list[int]:
    pivots: dict[int, int] = {}
    for original in rows:
        value = original
        while value:
            pivot = value.bit_length() - 1
            prior = pivots.get(pivot)
            if prior is None:
                pivots[pivot] = value
                break
            value ^= prior
    return [pivots[pivot] for pivot in sorted(pivots, reverse=True)]


def nullspace(rows: list[int], columns: int) -> list[int]:
    basis = row_basis(rows)
    pivots = {row.bit_length() - 1: row for row in basis}
    result: list[int] = []
    for free in range(columns):
        if free in pivots:
            continue
        value = 1 << free
        for pivot in sorted(pivots):
            if (pivots[pivot] & value).bit_count() & 1:
                value |= 1 << pivot
        result.append(value)
    assert all(not ((row & value).bit_count() & 1) for row in rows for value in result)
    return result


def quotient_basis(space: list[int], subspace: list[int]) -> list[int]:
    basis = row_basis(subspace)
    rank = len(basis)
    quotient: list[int] = []
    for row in space:
        extended = row_basis(basis + [row])
        if len(extended) != rank:
            quotient.append(row)
            basis = extended
            rank += 1
    return quotient


def sparse(rows: list[int]) -> list[list[int]]:
    result: list[list[int]] = []
    for row in rows:
        support: list[int] = []
        while row:
            bit = row & -row
            support.append(bit.bit_length() - 1)
            row ^= bit
        result.append(support)
    return result


def parse_terms(value: str) -> list[tuple[int, int]]:
    terms: list[tuple[int, int]] = []
    for term in value.split(","):
        x, y = term.split(":")
        terms.append((int(x), int(y)))
    if not terms:
        raise ValueError("a polynomial must contain at least one monomial")
    return terms


def block_rows(
    ell: int, m: int, left: list[tuple[int, int]], right: list[tuple[int, int]]
) -> list[int]:
    block = ell * m
    rows: list[int] = []
    for x in range(ell):
        for y in range(m):
            row = 0
            for dx, dy in left:
                row ^= 1 << (((x + dx) % ell) * m + (y + dy) % m)
            for dx, dy in right:
                row ^= 1 << (block + ((x + dx) % ell) * m + (y + dy) % m)
            rows.append(row)
    return rows


def transpose(terms: list[tuple[int, int]], ell: int, m: int) -> list[tuple[int, int]]:
    return [((-x) % ell, (-y) % m) for x, y in terms]


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--ell", type=int, required=True)
    parser.add_argument("--m", type=int, required=True)
    parser.add_argument("--a", required=True, help="comma-separated x:y monomial exponents")
    parser.add_argument("--b", required=True, help="comma-separated x:y monomial exponents")
    parser.add_argument("--direction", choices=("x", "z"), default="x")
    parser.add_argument("--label", required=True)
    parser.add_argument("--maximum-weight", type=int, required=True)
    parser.add_argument("--incumbent", default="", help="comma-separated support coordinates")
    parser.add_argument("--out", type=Path, required=True)
    args = parser.parse_args()
    if args.ell <= 0 or args.m <= 0:
        raise RuntimeError("torus dimensions must be positive")
    a = parse_terms(args.a)
    b = parse_terms(args.b)
    hx = block_rows(args.ell, args.m, a, b)
    hz = block_rows(
        args.ell,
        args.m,
        transpose(b, args.ell, args.m),
        transpose(a, args.ell, args.m),
    )
    if any((left & right).bit_count() & 1 for left in hx for right in hz):
        raise RuntimeError("generated CSS checks do not commute")
    physical, stabilizers = (hx, hz) if args.direction == "x" else (hz, hx)
    columns = 2 * args.ell * args.m
    physical_basis = row_basis(physical)
    stabilizer_basis = row_basis(stabilizers)
    logical = quotient_basis(nullspace(stabilizer_basis, columns), physical_basis)
    dimension = columns - len(physical_basis) - len(stabilizer_basis)
    if len(logical) != dimension:
        raise RuntimeError("logical quotient basis has the wrong dimension")
    incumbent = [int(value) for value in args.incumbent.split(",") if value]
    output = {
        "label": args.label,
        "coordinate_count": columns,
        "physical_checks": sparse(physical),
        "logical_observations": sparse(logical),
        "anchors": [0, args.ell * args.m],
        "maximum_weight": args.maximum_weight,
        "incumbent_support": incumbent,
        "metadata": {
            "source_schema": "Bravyi-et-al-bivariate-bicycle-v1",
            "ell": args.ell,
            "m": args.m,
            "a_terms": a,
            "b_terms": b,
            "direction": args.direction,
            "physical_rank": len(physical_basis),
            "stabilizer_rank": len(stabilizer_basis),
            "logical_observation_rank": len(logical),
            "translation_orbits": 2,
        },
    }
    args.out.parent.mkdir(parents=True, exist_ok=True)
    with args.out.open("x", encoding="utf-8") as stream:
        json.dump(output, stream, separators=(",", ":"), sort_keys=True)
        stream.write("\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
