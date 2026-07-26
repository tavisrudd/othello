#!/usr/bin/env python3
"""Exact Gorenstein/self-association falsifier for the B3/H3 quotients."""

from __future__ import annotations

import argparse
import importlib.util
import itertools
import json
import math
import re
import subprocess
from pathlib import Path


HERE = Path(__file__).resolve().parent
OUTPUT = Path(__file__).with_suffix(".json")
MATCHING_PATH = HERE / "matching_module.py"
SCOUT_PATH = HERE / "matching_orbit_scout.json"
SCHEMA = "gorenstein-gorenstein-gate-v1"
SINGULAR_VERSION = "4.4.1"
MACAULAY2_VERSION = "1.26.05"


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


MATCHING = load_module("matching_for_gorenstein", MATCHING_PATH)


def inv(value: int, prime: int) -> int:
    return pow(value % prime, prime - 2, prime)


def rref(matrix: list[list[int]], prime: int) -> tuple[list[list[int]], list[int]]:
    reduced = [[value % prime for value in row] for row in matrix]
    if not reduced:
        return reduced, []
    rows = len(reduced)
    columns = len(reduced[0])
    pivot_row = 0
    pivots: list[int] = []
    for column in range(columns):
        pivot = next(
            (row for row in range(pivot_row, rows) if reduced[row][column] % prime),
            None,
        )
        if pivot is None:
            continue
        reduced[pivot_row], reduced[pivot] = reduced[pivot], reduced[pivot_row]
        scale = inv(reduced[pivot_row][column], prime)
        reduced[pivot_row] = [(scale * value) % prime for value in reduced[pivot_row]]
        for row in range(rows):
            if row == pivot_row:
                continue
            factor = reduced[row][column] % prime
            if factor:
                reduced[row] = [
                    (left - factor * right) % prime
                    for left, right in zip(reduced[row], reduced[pivot_row])
                ]
        pivots.append(column)
        pivot_row += 1
        if pivot_row == rows:
            break
    return reduced, pivots


def rank(matrix: list[list[int]], prime: int) -> int:
    return len(rref(matrix, prime)[1])


def nullspace(matrix: list[list[int]], prime: int) -> list[list[int]]:
    reduced, pivots = rref(matrix, prime)
    columns = len(matrix[0])
    free = [column for column in range(columns) if column not in pivots]
    result = []
    for free_column in free:
        vector = [0] * columns
        vector[free_column] = 1
        for row, pivot in enumerate(pivots):
            vector[pivot] = -reduced[row][free_column] % prime
        result.append(vector)
    return result


def transpose(matrix: list[list[int]]) -> list[list[int]]:
    return [list(column) for column in zip(*matrix)] if matrix else []


def monomials(variables: int, degree: int) -> list[tuple[int, ...]]:
    if variables == 0:
        return [()] if degree == 0 else []
    result = []
    for cuts in itertools.combinations_with_replacement(range(variables), degree):
        exponent = [0] * variables
        for index in cuts:
            exponent[index] += 1
        result.append(tuple(exponent))
    return result


def evaluate_monomial(point: list[int], exponent: tuple[int, ...], prime: int) -> int:
    value = 1
    for coordinate, power in zip(point, exponent):
        value = value * pow(coordinate, power, prime) % prime
    return value


def evaluation_matrix(
    points: list[list[int]], degree: int, prime: int
) -> list[list[int]]:
    basis = monomials(len(points[0]), degree)
    return [
        [evaluate_monomial(point, exponent, prime) for exponent in basis]
        for point in points
    ]


def row_basis(matrix: list[list[int]], prime: int) -> list[list[int]]:
    reduced, _pivots = rref(matrix, prime)
    return [row for row in reduced if any(row)]


def quotient_complement(
    larger: list[list[int]], smaller: list[list[int]], prime: int
) -> list[list[int]]:
    basis = row_basis(smaller, prime)
    result: list[list[int]] = []
    current_rank = len(basis)
    for vector in row_basis(larger, prime):
        candidate_rank = rank(basis + [vector], prime)
        if candidate_rank > current_rank:
            basis.append(vector)
            result.append(vector)
            current_rank = candidate_rank
    return result


def frozen_configuration(record: dict) -> tuple[list[list[int]], list[int]]:
    name = record["type"]
    prime = record["field_order"]
    conic, parameters = MATCHING.COXETER.conic_parameterization(prime)
    endpoints = tuple(parameters)
    full_group, psl_group = MATCHING.full_pgl(prime, parameters)
    base = tuple(tuple(pair) for pair in record["coxeter_invariant_matching"])
    orbit = sorted(
        {MATCHING.matching_image(element, base) for element in full_group}
    )
    assert len(orbit) == record["target_orbit_size"]
    base_product = MATCHING.matching_product(base, endpoints, prime)
    degree = (prime + 1) // 2
    vectors = []
    for matching in orbit:
        product = MATCHING.matching_product(matching, endpoints, prime)
        difference = {
            exponent: (
                product.get(exponent, 0) - base_product.get(exponent, 0)
            )
            % prime
            for exponent in set(product) | set(base_product)
        }
        vectors.append(MATCHING.quotient_by_conic(difference, degree - 2, prime))
    image_matrix = transpose(vectors)
    _reduced, coordinate_pivots = rref(transpose(image_matrix), prime)
    assert len(coordinate_pivots) == prime - 1
    affine_points = [
        [vector[index] for index in coordinate_pivots] for vector in vectors
    ]

    unseen = set(orbit)
    sheets = []
    while unseen:
        representative = min(unseen)
        sheet = {
            MATCHING.matching_image(element, representative) for element in psl_group
        }
        unseen -= sheet
        sheets.append(sheet)
    assert len(sheets) == 2 and all(len(sheet) == prime for sheet in sheets)
    signs = [1 if matching in sheets[0] else prime - 1 for matching in orbit]
    assert name in ("B3", "H3")
    return affine_points, signs


def singular_monomial(exponent: tuple[int, ...], variables: list[str]) -> str:
    factors = []
    for variable, power in zip(variables, exponent):
        if power == 1:
            factors.append(variable)
        elif power > 1:
            factors.append(f"{variable}^{power}")
    return "*".join(factors) or "1"


def algebra_data(
    points: list[list[int]], quadratic_kernel: list[list[int]]
) -> tuple[list[str], list[str], list[tuple[int, ...]]]:
    variables = ["z"] + [f"x{index}" for index in range(1, len(points[0]) + 1)]
    quadratic_basis = monomials(len(variables), 2)
    quadrics = []
    for vector in quadratic_kernel:
        terms = [
            f"{coefficient}*{singular_monomial(exponent, variables)}"
            for coefficient, exponent in zip(vector, quadratic_basis)
            if coefficient
        ]
        quadrics.append("+".join(terms))
    return variables, quadrics, quadratic_basis


def singular_code(
    points: list[list[int]], prime: int, quadratic_kernel: list[list[int]]
) -> str:
    variables, quadrics, _quadratic_basis = algebra_data(points, quadratic_kernel)
    point_ideals = []
    for point in points:
        generators = [
            f"x{index}-{value}*z"
            for index, value in enumerate(point, start=1)
        ]
        point_ideals.append("ideal P" + str(len(point_ideals)) + "=" + ",".join(generators) + ";")
    intersections = ["ideal IP=P0;"]
    intersections.extend(
        f"IP=intersect(IP,P{index});" for index in range(1, len(points))
    )
    membership = (
        "int leftok=1; int rightok=1; int pointleft=1; int pointright=1; int i; "
        "ideal G=std(I); ideal S=sat(I,m); ideal GS=std(S); "
        "for(i=1;i<=size(G);i++){if(reduce(G[i],GS)!=0){leftok=0;}} "
        "for(i=1;i<=size(GS);i++){if(reduce(GS[i],G)!=0){rightok=0;}} "
        "ideal GP=std(IP); "
        "for(i=1;i<=size(G);i++){if(reduce(G[i],GP)!=0){pointleft=0;}} "
        "for(i=1;i<=size(GP);i++){if(reduce(GP[i],G)!=0){pointright=0;}}"
    )
    return " ".join(
        [
            'LIB "elim.lib";',
            f"ring r={prime},({','.join(variables)}),dp;",
            *point_ideals,
            *intersections,
            f"ideal I={','.join(quadrics)};",
            f"ideal m={','.join(variables)};",
            membership,
            'print("SATURATED="+string(leftok*rightok));',
            'print("EQUALS_POINT_IDEAL="+string(pointleft*pointright));',
            "ideal J=I,z;",
            "ideal GJ=std(J);",
            "ideal K=quotient(J,m);",
            'print("ARTIN_LENGTH="+string(vdim(GJ)));',
            'print("SOCLE_DIMENSION="+string(vdim(GJ)-vdim(std(K))));',
            "quit;",
        ]
    )


def parse_singular(output: str) -> dict:
    lines = [line.rstrip() for line in output.splitlines() if line.strip()]
    scalars = {}
    for key in ("SATURATED", "EQUALS_POINT_IDEAL", "ARTIN_LENGTH", "SOCLE_DIMENSION"):
        line = next(item for item in lines if item.startswith(key + "="))
        scalars[key.lower()] = int(line.split("=", 1)[1])
    return scalars


def macaulay2_code(
    points: list[list[int]], prime: int, quadratic_kernel: list[list[int]]
) -> str:
    variables, _projective_quadrics, quadratic_basis = algebra_data(
        points, quadratic_kernel
    )
    affine_variables = variables[1:]
    quadrics = []
    for vector in quadratic_kernel:
        terms = [
            f"{coefficient}*{singular_monomial(exponent[1:], affine_variables)}"
            for coefficient, exponent in zip(vector, quadratic_basis)
            if coefficient and exponent[0] == 0
        ]
        quadrics.append("+".join(terms))
    half_length = len(points[0]) // 2
    return " ".join(
        [
            f"R=GF({prime})[{','.join(affine_variables)},MonomialOrder=>GRevLex];",
            f"I=ideal({','.join(quadrics)});",
            f"print minimalBetti(I,DegreeLimit=>1,LengthLimit=>{half_length});",
            "exit 0",
        ]
    )


def parse_macaulay2(output: str, projective_dimension: int) -> dict:
    lines = [line.rstrip() for line in output.splitlines() if line.strip()]
    total_line = next(line for line in lines if line.strip().startswith("total:"))
    partial_totals = [
        int(value) for value in total_line.split(":", 1)[1].split()
    ]
    rows: dict[int, list[int]] = {}
    for line in lines:
        match = re.match(r"\s*(\d+):\s+(.*)", line)
        if match is None:
            continue
        rows[int(match.group(1))] = [
            0 if value == "." else int(value)
            for value in match.group(2).split()
        ]
    width = projective_dimension + 1
    table = [[0] * width for _ in range(4)]
    for row, values in rows.items():
        for homological, value in enumerate(values):
            table[row][homological] = value
            degree = row + homological
            mirror_homological = projective_dimension - homological
            mirror_degree = projective_dimension + 3 - degree
            mirror_row = mirror_degree - mirror_homological
            table[mirror_row][mirror_homological] = value
    totals = [sum(row[column] for row in table) for column in range(width)]
    assert all(
        totals[index] >= value for index, value in enumerate(partial_totals)
    )
    return {
        "version": MACAULAY2_VERSION,
        "completion": "DegreeLimit=1 half-resolution plus Gorenstein self-duality",
        "resolution_length": len(totals) - 1,
        "betti_table": table,
        "betti_totals": totals,
        "cohen_macaulay_type": totals[-1],
    }


def run_singular(
    points: list[list[int]], prime: int, quadratic_kernel: list[list[int]]
) -> dict:
    version = subprocess.run(
        ["nix", "shell", "nixpkgs#singular", "--command", "Singular", "--version"],
        check=True,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    if f"version {SINGULAR_VERSION}" not in version.stdout:
        raise RuntimeError("unexpected Singular version")
    completed = subprocess.run(
        [
            "nix",
            "shell",
            "nixpkgs#singular",
            "--command",
            "Singular",
            "-q",
            "-c",
            singular_code(points, prime, quadratic_kernel),
        ],
        check=True,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    if completed.stderr.strip():
        raise RuntimeError(completed.stderr)
    return parse_singular(completed.stdout)


def run_macaulay2(
    points: list[list[int]], prime: int, quadratic_kernel: list[list[int]]
) -> dict:
    version = subprocess.run(
        ["nix", "shell", "nixpkgs#macaulay2", "--command", "M2", "--version"],
        check=True,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    if version.stdout.strip() != MACAULAY2_VERSION:
        raise RuntimeError("unexpected Macaulay2 version")
    completed = subprocess.run(
        [
            "nix",
            "shell",
            "nixpkgs#macaulay2",
            "--command",
            "M2",
            "--no-readline",
            "--silent",
            "-e",
            macaulay2_code(points, prime, quadratic_kernel),
        ],
        check=True,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    if completed.stderr.strip():
        raise RuntimeError(completed.stderr)
    return parse_macaulay2(completed.stdout, len(points[0]))


def moment_pairing_ranks(
    points: list[list[int]], signs: list[int], prime: int
) -> list[int]:
    spaces = []
    for degree in range(4):
        evaluations = transpose(evaluation_matrix(points, degree, prime))
        spaces.append(row_basis(evaluations, prime))
    quotients = [
        spaces[0],
        *[
            quotient_complement(spaces[degree], spaces[degree - 1], prime)
            for degree in range(1, 4)
        ],
    ]
    ranks = []
    for degree in range(4):
        left = quotients[degree]
        right = quotients[3 - degree]
        pairing = [
            [
                sum(
                    signs[index] * first[index] * second[index]
                    for index in range(len(points))
                )
                % prime
                for second in right
            ]
            for first in left
        ]
        ranks.append(rank(pairing, prime))
    return ranks


def type_certificate(record: dict) -> dict:
    name = record["type"]
    prime = record["field_order"]
    affine_points, signs = frozen_configuration(record)
    projective_points = [[1] + point for point in affine_points]
    point_count = len(projective_points)
    projective_dimension = len(projective_points[0]) - 1
    hilbert = [
        rank(evaluation_matrix(projective_points, degree, prime), prime)
        for degree in range(5)
    ]
    deletion_ranks = [
        rank(
            evaluation_matrix(
                projective_points[:index] + projective_points[index + 1 :],
                2,
                prime,
            ),
            prime,
        )
        for index in range(point_count)
    ]
    quadratic_kernel = nullspace(
        evaluation_matrix(projective_points, 2, prime), prime
    )

    point_matrix = transpose(projective_points)
    signed_gale = [
        [value * signs[column] % prime for column, value in enumerate(row)]
        for row in point_matrix
    ]
    gale_product = [
        [
            sum(
                point_matrix[row][index] * signed_gale[column][index]
                for index in range(point_count)
            )
            % prime
            for column in range(projective_dimension + 1)
        ]
        for row in range(projective_dimension + 1)
    ]
    assert not any(any(row) for row in gale_product)
    assert rank(signed_gale, prime) == projective_dimension + 1

    catalecticants = []
    for degree in range(4):
        left = monomials(projective_dimension, degree)
        right = monomials(projective_dimension, 3 - degree)
        matrix = [
            [
                sum(
                    signs[index]
                    * evaluate_monomial(
                        affine_points[index],
                        tuple(a + b for a, b in zip(alpha, beta)),
                        prime,
                    )
                    for index in range(point_count)
                )
                % prime
                for beta in right
            ]
            for alpha in left
        ]
        catalecticants.append(rank(matrix, prime))

    cubic = {}
    factorial_three = math.factorial(3)
    for exponent in monomials(projective_dimension, 3):
        moment = sum(
            signs[index]
            * evaluate_monomial(affine_points[index], exponent, prime)
            for index in range(point_count)
        ) % prime
        multinomial = factorial_three
        for power in exponent:
            multinomial //= math.factorial(power)
        coefficient = multinomial * moment % prime
        if coefficient:
            cubic[",".join(map(str, exponent))] = coefficient

    singular = run_singular(affine_points, prime, quadratic_kernel)
    macaulay2 = run_macaulay2(affine_points, prime, quadratic_kernel)
    expected_h = [1, prime, 2 * prime - 1, 2 * prime, 2 * prime]
    assert hilbert == expected_h
    assert set(deletion_ranks) == {2 * prime - 1}
    assert catalecticants == [1, projective_dimension, projective_dimension, 1]
    assert moment_pairing_ranks(projective_points, signs, prime) == [
        1,
        projective_dimension,
        projective_dimension,
        1,
    ]
    assert singular["saturated"] == 1
    assert singular["equals_point_ideal"] == 1
    assert singular["artin_length"] == point_count
    assert singular["socle_dimension"] == 1
    assert macaulay2["resolution_length"] == projective_dimension
    assert macaulay2["cohen_macaulay_type"] == 1

    return {
        "type": name,
        "field_order": prime,
        "projective_dimension": projective_dimension,
        "point_count": point_count,
        "affine_points": affine_points,
        "sheet_sign": signs,
        "hilbert_function_degrees_0_through_4": hilbert,
        "h_vector": [
            hilbert[0],
            *[hilbert[index] - hilbert[index - 1] for index in range(1, 4)],
        ],
        "quadratic_deletion_ranks": deletion_ranks,
        "cayley_bacharach_degree_2": True,
        "signed_gale_transform_equals_original": True,
        "catalecticant_ranks_degrees_0_through_3": catalecticants,
        "artinian_pairing_ranks_degrees_0_through_3": moment_pairing_ranks(
            projective_points, signs, prime
        ),
        "inverse_system_cubic": cubic,
        "singular": singular,
        "macaulay2": macaulay2,
        "arithmetically_gorenstein": True,
        "self_associated": True,
    }


def build_certificate() -> dict:
    scout = json.loads(SCOUT_PATH.read_text())
    records = [
        type_certificate(record)
        for record in scout["types"]
        if record["type"] in ("B3", "H3")
    ]
    return {
        "schema": SCHEMA,
        "verdict": "B3_H3_BOTH_ARITHMETICALLY_GORENSTEIN_AND_SELF_ASSOCIATED",
        "singular_version": SINGULAR_VERSION,
        "macaulay2_version": MACAULAY2_VERSION,
        "types": records,
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    certificate = build_certificate()
    rendered = json.dumps(certificate, indent=2, sort_keys=True) + "\n"
    if args.write:
        OUTPUT.write_text(rendered)
        print(f"wrote {OUTPUT}")
        return 0
    if not OUTPUT.exists() or OUTPUT.read_text() != rendered:
        raise SystemExit(f"{OUTPUT} is stale; run with --write")
    print("Gorenstein/self-association primary certificate: CHECK OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
