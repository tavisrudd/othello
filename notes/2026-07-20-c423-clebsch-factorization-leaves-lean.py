#!/usr/bin/env python3
"""Generate the exact quotient-coordinate data checked by the Clebsch Lean leaves."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import itertools
import json
from pathlib import Path


SCHEMA = "clebsch-factorization-leaves-v1"
HERE = Path(__file__).resolve().parent
OUTPUT = Path(__file__).with_suffix(".json")
SCOUT = HERE / "2026-07-20-c406-matching-orbit-scout.json"
SOURCE = HERE / "2026-07-20-c406-matching-module.py"


def load_module(path: Path):
    spec = importlib.util.spec_from_file_location("clebsch_factorization_source", path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def mat_vec(matrix, vector, prime):
    return [sum(a * b for a, b in zip(row, vector)) % prime for row in matrix]


def symmetric_power(vector, degree, prime):
    return [
        prod_mod((vector[index] for index in indices), prime)
        for indices in itertools.combinations_with_replacement(range(len(vector)), degree)
    ]


def prod_mod(values, prime):
    result = 1
    for value in values:
        result = result * value % prime
    return result


def independent_rank(rows, prime):
    """A separate row-reduction implementation used only as an invariant check."""
    work = [list(row) for row in rows]
    rank = 0
    columns = len(work[0]) if work else 0
    for column in range(columns):
        pivot = next((i for i in range(rank, len(work)) if work[i][column] % prime), None)
        if pivot is None:
            continue
        work[rank], work[pivot] = work[pivot], work[rank]
        inverse = pow(work[rank][column], -1, prime)
        work[rank] = [(entry * inverse) % prime for entry in work[rank]]
        for i in range(len(work)):
            if i == rank:
                continue
            multiple = work[i][column] % prime
            if multiple:
                work[i] = [
                    (left - multiple * right) % prime
                    for left, right in zip(work[i], work[rank])
                ]
        rank += 1
        if rank == len(work):
            break
    return rank


def build_type(source, record):
    name = record["type"]
    prime = record["field_order"]
    conic, parameters = source.C399.conic_parameterization(prime)
    full_group, psl_group = source.full_pgl(prime, parameters)
    base = tuple(tuple(pair) for pair in record["coxeter_invariant_matching"])
    orbit = sorted({source.matching_image(element, base) for element in full_group})
    assert len(orbit) == record["target_orbit_size"]

    base_product = source.matching_product(base, parameters, prime)
    quotient_degree = (prime + 1) // 2 - 2
    raw_vectors = []
    for matching in orbit:
        product = source.matching_product(matching, parameters, prime)
        difference = {
            exponent: (product.get(exponent, 0) - base_product.get(exponent, 0)) % prime
            for exponent in set(product) | set(base_product)
        }
        raw_vectors.append(source.quotient_by_conic(difference, quotient_degree, prime))

    raw_rank = source.rank(source.transpose(raw_vectors), prime)
    _reduced, coordinate_pivots = source.rref(raw_vectors, prime)
    assert len(coordinate_pivots) == raw_rank
    reduced = [[vector[index] for index in coordinate_pivots] for vector in raw_vectors]
    _reduced_points, basis_columns = source.rref(source.transpose(reduced), prime)
    assert len(basis_columns) == raw_rank
    basis_matrix = source.transpose([reduced[index] for index in basis_columns])
    inverse = source.matrix_inverse(basis_matrix, prime)
    vectors = [mat_vec(inverse, vector, prime) for vector in reduced]

    standard_basis = [
        [1 if row == column else 0 for row in range(raw_rank)]
        for column in range(raw_rank)
    ]
    assert [vectors[index] for index in basis_columns] == standard_basis
    assert independent_rank(vectors, prime) == raw_rank

    result = {
        "type": name,
        "field_order": prime,
        "quotient_degree": quotient_degree,
        "matching_count": len(orbit),
        "coordinate_dimension": raw_rank,
        "source_monomial_coordinates": coordinate_pivots,
        "basis_columns": basis_columns,
        "vectors": vectors,
    }

    if name in ("B3", "H3"):
        unseen = set(orbit)
        sheets = []
        while unseen:
            representative = min(unseen)
            sheet = {source.matching_image(element, representative) for element in psl_group}
            unseen -= sheet
            sheets.append(sheet)
        assert len(sheets) == 2 and all(len(sheet) == prime for sheet in sheets)
        signs = [1 if matching in sheets[0] else prime - 1 for matching in orbit]
        moments = {}
        for degree in (1, 2, 3):
            powers = [symmetric_power(vector, degree, prime) for vector in vectors]
            moment = [
                sum(sign * power[index] for sign, power in zip(signs, powers)) % prime
                for index in range(len(powers[0]))
            ]
            moments[str(degree)] = moment
        assert not any(moments["1"])
        assert not any(moments["2"])
        cubic_index = next(index for index, value in enumerate(moments["3"]) if value)
        cubic_coordinate = list(
            itertools.combinations_with_replacement(range(raw_rank), 3)
        )[cubic_index]
        direct_cubic = sum(
            sign
            * vector[cubic_coordinate[0]]
            * vector[cubic_coordinate[1]]
            * vector[cubic_coordinate[2]]
            for sign, vector in zip(signs, vectors)
        ) % prime
        assert direct_cubic == moments["3"][cubic_index] != 0
        result.update(
            {
                "sheet_signs": signs,
                "signed_first_moment": moments["1"],
                "signed_second_moment": moments["2"],
                "cubic_functional_coordinates": cubic_coordinate,
                "cubic_functional_value": direct_cubic,
                "signed_cubic_support": sum(value != 0 for value in moments["3"]),
                "signed_cubic_sha256": hashlib.sha256(bytes(moments["3"])).hexdigest(),
            }
        )
    return result


def build_certificate():
    source = load_module(SOURCE)
    scout = json.loads(SCOUT.read_text())
    records = [build_type(source, record) for record in scout["types"]]
    assert [(record["type"], record["coordinate_dimension"]) for record in records] == [
        ("A3", 3),
        ("B3", 6),
        ("H3", 10),
    ]
    return {
        "schema": SCHEMA,
        "semantics": (
            "Rows are factorization-difference quotient vectors in audited monomial coordinates, "
            "then transported so the listed basis columns are the standard coordinate basis. "
            "Sheet signs are +1 and -1 on the two PSL_2 orbits."
        ),
        "types": records,
        "invariant_check": {
            "method": "independent modular row reduction plus direct signed power sums",
            "all_basis_columns_are_standard": True,
            "all_reported_ranks_recomputed": True,
            "lower_signed_moments_recomputed": True,
            "named_cubic_functionals_recomputed": True,
        },
        "inputs": {
            path.name: {
                "bytes": path.stat().st_size,
                "sha256": hashlib.sha256(path.read_bytes()).hexdigest(),
            }
            for path in (SCOUT, SOURCE)
        },
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--check", action="store_true")
    mode.add_argument("--write", action="store_true")
    args = parser.parse_args()
    rendered = json.dumps(build_certificate(), indent=2, sort_keys=True) + "\n"
    if args.write:
        OUTPUT.write_text(rendered)
        print(f"wrote {OUTPUT.name}")
    elif not OUTPUT.exists() or OUTPUT.read_text() != rendered:
        raise SystemExit(f"stale certificate: run {Path(__file__).name} --write")
    else:
        print("Clebsch factorization leaf certificate OK")


if __name__ == "__main__":
    main()
