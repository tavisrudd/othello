#!/usr/bin/env python3
"""Generate the bounded finite data for the balanced-sheet Lean leaves."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import re
from pathlib import Path


SCHEMA = "clebsch-balanced-sheets-v1"
HERE = Path(__file__).resolve().parent
OUTPUT = Path(__file__).with_suffix(".json")
CHECKSUM = Path(__file__).with_suffix(".sha256")
SOURCE = HERE / "2026-07-20-c406-matching-module.py"
FACTOR_SCRIPT = HERE / "2026-07-20-c423-clebsch-factorization-leaves-lean.py"
SCOUT = HERE / "2026-07-20-c406-matching-orbit-scout.json"
C399_SOURCE = HERE / "2026-07-20-c399-coxeter-number-conic-phase.py"
C378_SOURCE = HERE / "2026-07-19-c378-clebsch-common-duality.py"
C378_CERTIFICATE = HERE / "2026-07-19-c378-clebsch-common-duality.json"
B3_LEAN = HERE.parent / "lean/RelativeConicArcs/ClebschBalancedSheetsB3.lean"
H3_LEAN = HERE.parent / "lean/RelativeConicArcs/ClebschBalancedSheetsH3.lean"
ABSTRACT_LEAN = HERE.parent / "lean/RelativeConicArcs/ClebschBalancedSheets.lean"
GATE_LEAN = HERE.parent / "lean/RelativeConicArcs/Gates/ClebschBalancedSheets.lean"


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def file_record(path: Path) -> dict[str, int | str]:
    payload = path.read_bytes()
    return {
        "bytes": len(payload),
        "sha256": hashlib.sha256(payload).hexdigest(),
    }


def matrix_vector(matrix, vector, prime):
    return [sum(a * b for a, b in zip(row, vector)) % prime for row in matrix]


def independent_rank(rows, prime):
    """Independent row-rank replay, separate from the imported research generator."""
    work = [[entry % prime for entry in row] for row in rows]
    rank = 0
    width = len(work[0]) if work else 0
    for column in range(width):
        pivot = next((row for row in range(rank, len(work)) if work[row][column]), None)
        if pivot is None:
            continue
        work[rank], work[pivot] = work[pivot], work[rank]
        scale = pow(work[rank][column], -1, prime)
        work[rank] = [(scale * value) % prime for value in work[rank]]
        for row in range(len(work)):
            if row == rank:
                continue
            coefficient = work[row][column]
            work[row] = [
                (left - coefficient * right) % prime
                for left, right in zip(work[row], work[rank])
            ]
        rank += 1
    return rank


def moment_matrix(vectors, prime):
    dimension = len(vectors[0])
    return [
        [sum(vector[i] * vector[j] for vector in vectors) % prime for j in range(dimension)]
        for i in range(dimension)
    ]


def case_record(source, factor_record, scout_record):
    name = factor_record["type"]
    prime = factor_record["field_order"]
    vectors = factor_record["vectors"]
    signs = factor_record["sheet_signs"]
    dimension = factor_record["coordinate_dimension"]
    sheets = [
        [index for index, sign in enumerate(signs) if sign == target]
        for target in (1, prime - 1)
    ]
    assert [len(sheet) for sheet in sheets] == [prime, prime]
    sheet_vectors = [[vectors[index] for index in sheet] for sheet in sheets]

    decoders = []
    restriction_rank_replay = []
    for points in sheet_vectors:
        affine_points = [[1] + point for point in points]
        replay_rank = independent_rank(affine_points, prime)
        assert replay_rank == dimension
        restriction_rank_replay.append(replay_rank)
        _reduced, basis_indices = source.rref(source.transpose(affine_points), prime)
        assert len(basis_indices) == dimension
        basis_rows = [affine_points[index] for index in basis_indices]
        _row_reduced, coordinate_indices = source.rref(basis_rows, prime)
        assert len(coordinate_indices) == dimension
        basis_minor = [
            [row[index] for index in coordinate_indices] for row in basis_rows
        ]
        inverse = source.matrix_inverse(basis_minor, prime)
        assert source.matrix_product(basis_minor, inverse, prime) == [
            [1 if i == j else 0 for j in range(dimension)] for i in range(dimension)
        ]
        decoders.append(
            {
                "basis_indices": basis_indices,
                "coordinate_indices": coordinate_indices,
                "inverse": inverse,
            }
        )

    second_moment = moment_matrix(vectors, prime)
    radical = source.nullspace(second_moment, prime)
    assert len(radical) == 1
    radical_vector = radical[0]
    pivot = next(index for index, value in enumerate(radical_vector) if value)
    scale = pow(radical_vector[pivot], -1, prime)
    radical_vector = [(scale * value) % prime for value in radical_vector]
    radical_values = [sum(a * b for a, b in zip(radical_vector, vector)) % prime for vector in vectors]
    sheet_levels = [sorted({radical_values[index] for index in sheet}) for sheet in sheets]
    assert all(len(level) == 1 for level in sheet_levels) and sheet_levels[0] != sheet_levels[1]
    rank_primary = source.rank(second_moment, prime)
    rank_replay = independent_rank(second_moment, prime)
    assert rank_primary == rank_replay == dimension - 1
    witness = next(
        (i, j, second_moment[i][j])
        for i in range(dimension)
        for j in range(dimension)
        if second_moment[i][j]
    )
    complement_indices = [index for index in range(dimension) if index != pivot]
    complement_images = [
        [second_moment[row][column] for column in complement_indices]
        for row in range(dimension)
    ]
    _image_reduced, recovery_rows = source.rref(source.transpose(complement_images), prime)
    assert len(recovery_rows) == dimension - 1
    recovery_minor = [complement_images[row] for row in recovery_rows]
    recovery_inverse = source.matrix_inverse(recovery_minor, prime)
    assert source.matrix_product(recovery_inverse, recovery_minor, prime) == [
        [1 if i == j else 0 for j in range(dimension - 1)]
        for i in range(dimension - 1)
    ]

    conic, parameters = source.C399.conic_parameterization(prime)
    full_group, psl_group = source.full_pgl(prime, parameters)
    base = tuple(tuple(pair) for pair in scout_record["coxeter_invariant_matching"])
    orbit = sorted({source.matching_image(element, base) for element in full_group})
    orbit_index = {matching: index for index, matching in enumerate(orbit)}
    assert len(orbit) == 2 * prime
    assert len(vectors) == len(orbit)
    zero_index = next(index for index, vector in enumerate(vectors) if not any(vector))
    basis_columns = factor_record["basis_columns"]

    generators = []
    elements = [("special", element) for element in source.permutation_generators(psl_group)]
    elements.append(("outer", min(full_group - psl_group)))
    for kind, element in elements:
        permutation = source.action_permutation(element, orbit, orbit_index)
        translation = vectors[permutation[zero_index]]
        columns = [
            [
                (vectors[permutation[index]][coordinate] - translation[coordinate]) % prime
                for coordinate in range(dimension)
            ]
            for index in basis_columns
        ]
        linear_matrix = source.transpose(columns)
        for index, vector in enumerate(vectors):
            expected = [
                (value + shift) % prime
                for value, shift in zip(matrix_vector(linear_matrix, vector, prime), translation)
            ]
            assert expected == vectors[permutation[index]]
            expected_sign = signs[index] if kind == "special" else (-signs[index]) % prime
            assert signs[permutation[index]] == expected_sign
        generators.append(
            {
                "kind": kind,
                "permutation": permutation,
                "linear_matrix": linear_matrix,
                "translation": translation,
            }
        )

    return {
        "type": name,
        "field_order": prime,
        "point_count": 2 * prime,
        "coordinate_dimension": dimension,
        "sheet_indices": sheets,
        "sheet_vectors": sheet_vectors,
        "restriction_decoders": decoders,
        "second_moment_matrix": second_moment,
        "second_moment_rank": rank_primary,
        "second_moment_radical_dimension": len(radical),
        "radical_vector": radical_vector,
        "radical_kernel_certificate": {
            "pivot_coordinate": pivot,
            "complement_coordinates": complement_indices,
            "recovery_output_coordinates": recovery_rows,
            "recovery_inverse": recovery_inverse,
        },
        "radical_sheet_levels": sheet_levels,
        "nonzero_second_moment_entry": list(witness),
        "action_generators": generators,
        "checks": {
            "restriction_rank": [dimension, dimension],
            "restriction_rank_independent_replay": restriction_rank_replay,
            "second_moment_rank_independent_replay": rank_replay,
            "radical_annihilates_second_moment": not any(matrix_vector(second_moment, radical_vector, prime)),
            "radical_levels_separate_sheets": True,
            "affine_action_checked_on_every_point": True,
            "sheet_parity_checked_on_every_point": True,
            "half_subset_enumeration_used": False,
        },
    }


def check_lean_literals(factor, cases):
    paths = {"B3": B3_LEAN, "H3": H3_LEAN}
    checked = []
    for record in cases:
        name = record["type"]
        lower = name.lower()
        source = paths[name].read_text()
        declarations = {
            "left_index": f"{lower}LeftIndex",
            "right_index": f"{lower}RightIndex",
            "radical": f"{lower}RadicalCovector",
            "complement": f"{lower}MomentComplement",
            "recover": f"{lower}MomentRecover",
            "actions": f"{lower}ActionPermutation",
            "action_linear": f"{lower}ActionLinear",
            "action_translation": f"{lower}ActionTranslation",
        }
        parsed = {
            key: factor.lean_vector_literal(source, declaration)
            for key, declaration in declarations.items()
        }
        certificate = record["radical_kernel_certificate"]
        dimension = record["coordinate_dimension"]
        complement_dimension = dimension - 1
        expected_complement = [
            [1 if coordinate == source_coordinate else 0 for coordinate in certificate["complement_coordinates"]]
            for source_coordinate in range(dimension)
        ]
        expected_recover = []
        for inverse_row in certificate["recovery_inverse"]:
            row = [0] * dimension
            for coordinate, value in zip(certificate["recovery_output_coordinates"], inverse_row):
                row[coordinate] = value
            expected_recover.append(row)
        assert len(expected_complement[0]) == complement_dimension
        assert parsed["left_index"] == record["sheet_indices"][0]
        assert parsed["right_index"] == record["sheet_indices"][1]
        assert parsed["radical"] == record["radical_vector"]
        assert parsed["complement"] == expected_complement
        assert parsed["recover"] == expected_recover
        expected_actions = [list(item["permutation"]) for item in record["action_generators"]]
        assert parsed["actions"] == expected_actions, (
            name,
            parsed["actions"],
            expected_actions,
        )
        assert parsed["action_linear"] == [item["linear_matrix"] for item in record["action_generators"]]
        assert parsed["action_translation"] == [item["translation"] for item in record["action_generators"]]
        checked.append(
            {
                "type": name,
                "path": str(paths[name].relative_to(HERE.parent)),
                "file": file_record(paths[name]),
                "declarations": declarations,
            }
        )
    return checked


def declaration_header(source: str, name: str) -> str:
    match = re.search(rf"\btheorem\s+{re.escape(name)}\b", source)
    if match is None:
        raise AssertionError(f"missing theorem declaration: {name}")
    end = source.find(":=", match.end())
    if end == -1:
        raise AssertionError(f"missing theorem body delimiter: {name}")
    return source[match.start() : end].strip()


def statement_adequacy():
    selected = {
        ABSTRACT_LEAN: [
            "hadamardSquare_eq_equalSheetSum",
            "annihilates_equalSheetSum_iff_eq_sheetSignLine",
            "balancedHalf_unique_of_annihilates",
            "matrix_kernel_eq_line_of_recovery",
            "signedOrbitSum_isRelativeInvariant",
            "stabilizer_eq_ker_of_relative_invariant",
            "signedFunctionalAction_eq_character_smul",
            "signedFunctional_stabilizer_eq_characterKernel",
            "signedSymmetryCharacter_eq_one_or_neg_one",
            "signedSubgroupAction_eq_character_smul",
            "signedSubgroup_stabilizer_eq_characterKernel",
            "signed_sum_affine_expansion_one",
            "signed_sum_affine_expansion_two",
            "signed_sum_affine_expansion_three",
        ],
        B3_LEAN: [
            "b3_restrictsOntoZeroSum",
            "b3_secondMoment_kernel_eq_radicalLine",
            "b3_actionPermutation_bijective",
            "b3_actionGenerators_areAffine",
            "b3_specialGenerators_preserve_sheetSign",
            "b3_outerGenerator_negates_sheetSign",
            "b3_radical_separates_sheets",
            "b3_productsHaveEqualSheetSums",
            "b3_hasNonzeroSheetProduct",
            "b3_hadamardSquare_eq_equalSheetSum",
            "b3_trade_eq_sheetSignLine",
            "b3_balancedHalf_unique",
            "b3_signedCubicTensor_ne_zero",
            "b3_signedGenerator_mem_generated",
            "b3_signedEvaluation_cubicWitness",
            "b3_signedCubic_isRelativeInvariant",
            "b3_signedCubic_stabilizer_eq_characterKernel",
        ],
        H3_LEAN: [
            "h3_restrictsOntoZeroSum",
            "h3_secondMoment_kernel_eq_radicalLine",
            "h3_actionPermutation_bijective",
            "h3_actionGenerators_areAffine",
            "h3_specialGenerators_preserve_sheetSign",
            "h3_outerGenerator_negates_sheetSign",
            "h3_radical_separates_sheets",
            "h3_productsHaveEqualSheetSums",
            "h3_hasNonzeroSheetProduct",
            "h3_hadamardSquare_eq_equalSheetSum",
            "h3_trade_eq_sheetSignLine",
            "h3_balancedHalf_unique",
            "h3_signedCubicTensor_ne_zero",
            "h3_signedGenerator_mem_generated",
            "h3_signedEvaluation_cubicWitness",
            "h3_signedCubic_isRelativeInvariant",
            "h3_signedCubic_stabilizer_eq_characterKernel",
            "h3_affinePairingRadical_eq_sheetConstantPlane",
            "h3_outerOddSheetConstantLine_eq_sheetSign",
        ],
    }
    result = []
    for path, names in selected.items():
        source = path.read_text()
        result.append(
            {
                "path": str(path.relative_to(HERE.parent)),
                "file": file_record(path),
                "theorems": {name: declaration_header(source, name) for name in names},
            }
        )
    return result


def build_certificate():
    source = load_module("c424_source", SOURCE)
    factor = load_module("c424_factor", FACTOR_SCRIPT)
    factor_certificate = factor.build_certificate()
    scout = json.loads(SCOUT.read_text())
    factor_by_name = {record["type"]: record for record in factor_certificate["types"]}
    scout_by_name = {record["type"]: record for record in scout["types"]}
    cases = [
        case_record(source, factor_by_name[name], scout_by_name[name])
        for name in ("B3", "H3")
    ]
    lean_binding = check_lean_literals(factor, cases)
    return {
        "schema": SCHEMA,
        "semantics": (
            "The two sheets are the PSL_2 orbits in the frozen factorization-difference coordinates. "
            "Restriction decoders certify the zero-sum hyperplane images; the displayed second-moment "
            "matrices, radical vectors, separating levels, and affine generator actions are the only "
            "finite inputs intended for the Lean leaves."
        ),
        "cases": cases,
        "inputs": {
            path.name: file_record(path)
            for path in (
                SOURCE,
                FACTOR_SCRIPT,
                SCOUT,
                C399_SOURCE,
                C378_SOURCE,
                C378_CERTIFICATE,
            )
        },
        "independent_replay": {
            "method": "standalone modular row reduction plus direct pointwise action checks",
            "all_second_moment_ranks_agree": True,
            "all_restriction_ranks_agree": True,
            "all_affine_actions_replayed_pointwise": True,
            "all_sheet_parities_replayed_pointwise": True,
        },
        "lean_binding": lean_binding,
        "statement_adequacy": statement_adequacy(),
        "gate": {
            "path": str(GATE_LEAN.relative_to(HERE.parent)),
            "file": file_record(GATE_LEAN),
        },
    }


def checksum_manifest():
    paths = [Path(__file__), OUTPUT, ABSTRACT_LEAN, B3_LEAN, H3_LEAN, GATE_LEAN]
    return "".join(
        f"{hashlib.sha256(path.read_bytes()).hexdigest()}  {path.relative_to(HERE.parent)}\n"
        for path in paths
    )


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    arguments = parser.parse_args()
    rendered = json.dumps(build_certificate(), indent=2, sort_keys=True) + "\n"
    if arguments.write:
        OUTPUT.write_text(rendered)
        CHECKSUM.write_text(checksum_manifest())
        return
    if not OUTPUT.exists() or OUTPUT.read_text() != rendered:
        raise SystemExit(f"stale generated certificate: {OUTPUT}")
    expected_checksum = checksum_manifest()
    if not CHECKSUM.exists() or CHECKSUM.read_text() != expected_checksum:
        raise SystemExit(f"stale checksum manifest: {CHECKSUM}")
    print(f"ok {OUTPUT.name} {len(rendered.encode())} bytes")


if __name__ == "__main__":
    main()
