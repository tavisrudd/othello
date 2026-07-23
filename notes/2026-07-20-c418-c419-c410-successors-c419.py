#!/usr/bin/env python3
"""C419 fixed-incidence realization-stratum gate over F_7."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from collections import Counter, defaultdict
from itertools import combinations
from pathlib import Path

Q = 7
Vector = tuple[int, int, int]
HERE = Path(__file__).resolve().parent
CORE_PATH = HERE / "2026-07-20-c418-c419-c410-successors.py"
OUT = Path(__file__).with_suffix(".json")


def load_core():
    spec = importlib.util.spec_from_file_location("c418_core", CORE_PATH)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {CORE_PATH}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


core = load_core()


def canonical(value: object) -> str:
    return json.dumps(value, sort_keys=True, separators=(",", ":"))


def digest(value: object) -> str:
    return hashlib.sha256(canonical(value).encode()).hexdigest()


def circuits(points: tuple[Vector, ...]) -> tuple[tuple[int, int, int], ...]:
    return tuple(
        triple
        for triple in combinations(range(len(points)), 3)
        if core.determinant(*(points[i] for i in triple)) == 0
    )


def arrangement_lines(
    mask: int, lines: tuple[Vector, ...], line_masks: tuple[int, ...]
) -> tuple[Vector, ...]:
    return tuple(line for line, line_mask in zip(lines, line_masks) if not line_mask & mask)


def universal_incidence_ledger(lines: tuple[Vector, ...]) -> dict[str, object]:
    """The exact incidence aggregates consumed by weighted_depth."""
    singular = core.intersection_blocks(lines)
    adjoint = tuple(singular)
    weights = tuple(len(singular[point]) - 1 for point in adjoint)
    adjoint_blocks = core.intersection_blocks(adjoint)
    degrees = [0] * len(adjoint)
    depths = Counter()
    for indices in adjoint_blocks.values():
        depths[sum(weights[i] for i in indices)] += 1
        for i in indices:
            degrees[i] += 1
    return {
        "arrangement_intersection_weight_histogram": [
            list(item) for item in sorted(Counter(weights).items())
        ],
        "adjoint_line_weight_degree_histogram": [
            [[weight, degree], count]
            for (weight, degree), count in sorted(
                Counter(zip(weights, degrees)).items()
            )
        ],
        "adjoint_intersection_depth_histogram": [
            list(item) for item in sorted(depths.items())
        ],
    }


def point_record(
    added: Vector,
    base: tuple[Vector, ...],
    point_index: dict[Vector, int],
    base_mask: int,
    points: tuple[Vector, ...],
    lines: tuple[Vector, ...],
    line_masks: tuple[int, ...],
    point_lines: tuple[tuple[int, ...], ...],
) -> dict[str, object]:
    mask = base_mask | (1 << point_index[added])
    record = core.arrangement_record(mask, points, lines, line_masks, point_lines)
    ledger = universal_incidence_ledger(arrangement_lines(mask, lines, line_masks))
    configuration = base + (added,)
    configuration_circuits = circuits(configuration)
    marked_syndrome = Counter()
    if configuration_circuits == ((0, 1, 2), (0, 3, 4)):
        triple_lines = (core.cross(base[0], base[1]), core.cross(base[0], base[3]))
        for point in points:
            if point in configuration:
                continue
            incident = point_lines[point_index[point]]
            section_sizes = [
                sum(core.dot(lines[line], selected) == 0 for selected in configuration)
                for line in incident
            ]
            external_multiplicity = sum(size == 0 for size in section_sizes)
            triple_line_mark = sum(core.dot(line, point) == 0 for line in triple_lines)
            syndrome = sum(size * (size - 1) // 2 for size in section_sizes)
            if syndrome != external_multiplicity - 1 + triple_line_mark:
                raise AssertionError("secant/external-line identity failed")
            marked_syndrome[
                (external_multiplicity - 1, triple_line_mark, syndrome)
            ] += 1
    return {
        "added_point": list(added),
        "circuits": [list(block) for block in configuration_circuits],
        "U": record["U"],
        "U_digest": record["U_digest"],
        "universal_incidence_ledger": ledger,
        "ledger_digest": digest(ledger),
        "P": record["P"],
        "P_digest": record["P_digest"],
        "marked_weight_syndrome_histogram": [
            [list(key), count] for key, count in sorted(marked_syndrome.items())
        ],
        "checks": record["checks"],
    }


def generic_secant_lines(base: tuple[Vector, ...]) -> tuple[Vector, ...]:
    return tuple(sorted({core.cross(base[i], base[j]) for i, j in combinations(range(6), 2)}))


def c430_generic_pretest() -> dict[str, object]:
    fixed_blocks = ((0, 1, 2), (0, 3, 4))
    return core.pretest((fixed_blocks, fixed_blocks), 7)


def calibration_pretest(
    base: tuple[Vector, ...], left: Vector, right: Vector
) -> dict[str, object]:
    parts = (circuits(base + (left,)), circuits(base + (right,)))
    return core.pretest(parts, 7)


def fibre_summary(records: list[dict[str, object]]) -> list[dict[str, object]]:
    groups: dict[str, list[dict[str, object]]] = defaultdict(list)
    for record in records:
        groups[str(record["U_digest"])].append(record)
    answer = []
    for u_digest, fibre in sorted(groups.items()):
        p_digests = sorted({str(record["P_digest"]) for record in fibre})
        answer.append(
            {
                "U_digest": u_digest,
                "points": sorted(record["added_point"] for record in fibre),
                "P_digests": p_digests,
                "P_constant": len(p_digests) == 1,
                "ledger_digests": sorted(
                    {str(record["ledger_digest"]) for record in fibre}
                ),
                "representative_U": fibre[0]["U"],
                "representative_P": fibre[0]["P"],
                "representative_universal_incidence_ledger": fibre[0][
                    "universal_incidence_ledger"
                ],
                "marked_weight_syndrome_histograms": sorted(
                    {
                        canonical(record["marked_weight_syndrome_histogram"])
                        for record in fibre
                    }
                ),
            }
        )
    return answer


def build_certificate() -> dict[str, object]:
    points, lines, line_masks, point_lines = core.plane()
    point_index = {point: i for i, point in enumerate(points)}
    base = (
        (1, 0, 0),
        (1, 1, 0),
        (1, 2, 0),
        (1, 0, 1),
        (1, 0, 2),
        (1, 1, 2),
    )
    base_mask = sum(1 << point_index[point] for point in base)
    expected_generic_circuits = ((0, 1, 2), (0, 3, 4))
    records = [
        point_record(
            point,
            base,
            point_index,
            base_mask,
            points,
            lines,
            line_masks,
            point_lines,
        )
        for point in points
        if not base_mask & (1 << point_index[point])
    ]
    generic = [
        record
        for record in records
        if tuple(tuple(block) for block in record["circuits"])
        == expected_generic_circuits
    ]
    secants = generic_secant_lines(base)
    determinant_solutions = tuple(
        point
        for point in points
        if all(core.dot(line, point) for line in secants)
    )
    generic_points = tuple(tuple(record["added_point"]) for record in generic)
    if tuple(sorted(generic_points)) != tuple(sorted(determinant_solutions)):
        raise AssertionError("determinant stratum and circuit stratum disagree")
    expected_generic_points = (
        (0, 1, 4),
        (1, 2, 1),
        (1, 3, 1),
        (1, 5, 5),
        (1, 6, 1),
    )
    if tuple(sorted(generic_points)) != expected_generic_points:
        raise AssertionError("unexpected generic-stratum rational points")
    fibres = fibre_summary(generic)
    if len(fibres) != 2 or sorted(len(fibre["points"]) for fibre in fibres) != [1, 4]:
        raise AssertionError("unexpected fixed-U fibre sizes")
    if not all(fibre["P_constant"] for fibre in fibres):
        raise AssertionError("pointed data varies inside a fixed-U fibre")
    affine = next(fibre for fibre in fibres if len(fibre["points"]) == 4)
    infinity = next(fibre for fibre in fibres if len(fibre["points"]) == 1)
    if not all(point[0] == 1 for point in affine["points"]):
        raise AssertionError("four-point U fibre is not the affine chart")
    if infinity["points"] != [[0, 1, 4]]:
        raise AssertionError("singleton U fibre is not the infinity chart")

    calibration_points = ((1, 3, 5), (1, 3, 6))
    calibration = [
        next(record for record in records if tuple(record["added_point"]) == point)
        for point in calibration_points
    ]
    if calibration[0]["U_digest"] != calibration[1]["U_digest"]:
        raise AssertionError("logged calibration pair lost its U collision")
    if calibration[0]["P_digest"] == calibration[1]["P_digest"]:
        raise AssertionError("logged calibration pair lost its P split")
    if calibration[0]["circuits"] == calibration[1]["circuits"]:
        raise AssertionError("logged calibration pair unexpectedly has fixed incidence")

    incidence_u_groups: dict[tuple[str, str], list[dict[str, object]]] = defaultdict(list)
    for record in records:
        incidence_u_groups[
            (canonical(record["circuits"]), str(record["U_digest"]))
        ].append(record)
    if not all(
        len({str(record["P_digest"]) for record in fibre}) == 1
        for fibre in incidence_u_groups.values()
    ):
        raise AssertionError("fixed-incidence/U collision separates P in the bounded family")

    c430 = c430_generic_pretest()
    if (
        c430["restriction_ranks"] != [1, 1]
        or c430["second_moment_radical_dimension"] != 0
    ):
        raise AssertionError("unexpected generic C430 pattern")
    calibration_c430 = calibration_pretest(base, *calibration_points)
    if (
        calibration_c430["restriction_ranks"] != [3, 3]
        or calibration_c430["second_moment_radical_dimension"] != 0
    ):
        raise AssertionError("unexpected calibration C430 pattern")

    return {
        "schema": "c419-fixed-incidence-moduli-v1",
        "field": "F_7",
        "normalization": {
            "base_points": [list(point) for point in base],
            "base_circuits": [list(block) for block in circuits(base)],
            "variable_point": "[x:y:z] in PG(2,7)",
            "projective_representative": "first nonzero coordinate equals 1",
        },
        "determinant_stratum": {
            "description": (
                "V(x_i^7 x_j-x_i x_j^7) in P^2, saturated by the product "
                "of the distinct base-secant determinants"
            ),
            "field_rationality_equations": [
                "x^7*y-x*y^7=0",
                "x^7*z-x*z^7=0",
                "y^7*z-y*z^7=0",
            ],
            "saturation_factors": [list(line) for line in secants],
            "saturation_factor_meaning": "line dot [x:y:z] != 0",
            "fixed_original_circuits": [
                list(block) for block in expected_generic_circuits
            ],
            "rational_points": [list(point) for point in determinant_solutions],
            "rational_point_count": len(determinant_solutions),
        },
        "fixed_U_strata": {
            "split_equation": "x=0 versus x!=0 in the normalized coordinates",
            "fibres": fibres,
            "conclusion": (
                "the complete universal weighted-adjoint package splits the five-point "
                "fixed-matroid stratum into the infinity singleton and the four affine points; "
                "P is constant on both fixed-U strata"
            ),
        },
        "C430_pattern": {
            "generic_fixed_incidence_stratum": c430,
            "calibration_pair_across_two_incidence_types": calibration_c430,
            "conclusion": (
                "the generic stratum has constant restriction ranks [1,1] and radical "
                "dimension zero; there is no rank/radical jump eligible for a pointed split"
            ),
        },
        "logged_calibration_pair": {
            "points": [list(point) for point in calibration_points],
            "records": calibration,
            "first_gate": "FAIL",
            "reason": "the two circuit ledgers differ",
        },
        "bounded_extension_safeguard": {
            "domain": (
                "all 51 seventh points outside the frozen six-point C408 shared base in PG(2,7)"
            ),
            "record_count": len(records),
            "fixed_incidence_cell_count": len(
                {canonical(record["circuits"]) for record in records}
            ),
            "fixed_incidence_U_fibre_count": len(incidence_u_groups),
            "P_constant_on_every_fixed_incidence_U_fibre": True,
            "claim_boundary": (
                "this is not a census of seven-point configurations, other base realizations, "
                "or larger fields"
            ),
        },
        "ej_closeout": {
            "syndrome_identity": (
                "for Q outside B, mu(Q)=w_A(Q)+epsilon(Q), where "
                "w_A(Q)=#external lines through Q-1 and epsilon marks the two "
                "fixed three-point lines"
            ),
            "proof": (
                "writing n_s for the number of lines through Q meeting B in s points, "
                "sum n_s=8 and sum s*n_s=7 give n_0-1=n_2+2*n_3, while "
                "mu=n_2+3*n_3 and epsilon=n_3"
            ),
            "fixed_U_fibre_consequence": (
                "the stored marked weight histograms are singleton-valued on both "
                "fixed-U fibres, so they reconstruct the complete syndrome histogram"
            ),
            "settled": (
                "why the pointed constancy check can be read directly at the "
                "external-arrangement/marked-triple-line interface"
            ),
            "open_mystery": (
                "the frozen six-point base has trivial projective stabilizer, so no "
                "base symmetry currently explains why all four affine realizations "
                "share the complete U and marked-weight ledgers"
            ),
        },
        "result": {
            "status": "BOUNDED_NEGATIVE",
            "stop_condition": "forced pointed constancy on every fixed-U cell of the selected stratum",
            "answer": (
                "no cross-ratio-like pointed change occurs on the normalized generic extension "
                "stratum over F_7"
            ),
        },
    }


def payload(value: dict[str, object]) -> bytes:
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--write", action="store_true")
    group.add_argument("--check", action="store_true")
    args = parser.parse_args()
    data = payload(build_certificate())
    if args.write:
        OUT.write_bytes(data)
    elif not OUT.exists() or OUT.read_bytes() != data:
        raise SystemExit(f"stale or missing certificate: {OUT}")
    print(
        canonical(
            {
                "status": "ok",
                "certificate": str(OUT),
                "sha256": hashlib.sha256(data).hexdigest(),
            }
        )
    )


if __name__ == "__main__":
    main()
