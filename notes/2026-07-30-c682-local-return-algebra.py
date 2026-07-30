#!/usr/bin/env python3
"""Finite corroboration for the C682 local-return algebra theorem."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from functools import lru_cache
from pathlib import Path


HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "2026-07-30-c682-local-return-algebra.json"
GLOBAL_REPLAY = HERE / "2026-07-29-c682-global-phase-propagation-replay.py"
MONOTONE_REPLAY = (
    HERE / "2026-07-29-c682-monotone-entrance-propagation-replay.py"
)
LINEAR_ALGEBRA = HERE / "2026-07-28-c682-klein-e8-first-failure-replay.py"
GLOBAL_OPERATORS = HERE / "2026-07-29-c682-global-weyl-operators.json"
TRIVIAL_OPERATORS = (
    HERE / "2026-07-29-c682-global-phase-trivial-operators.json"
)
MONOTONE_OPERATORS = (
    HERE / "2026-07-29-c682-monotone-weyl-operators.json"
)
PRIME = 1_000_000_007
MAXIMUM_DEGREE = 180
GLOBAL_LABELS = ("1", "2", "3", "3p")
MONOTONE_LABELS = ("2p", "4", "4s", "5", "6")


def load(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def compose(left, right, prime: int):
    """Compose column-form matrices, including zero-dimensional middles."""
    assert right[1] == left[0]
    columns = [
        [
            sum(
                vector[middle] * left[2][middle][row]
                for middle in range(left[0])
            )
            % prime
            for row in range(left[1])
        ]
        for vector in right[2]
    ]
    return right[0], left[1], columns


def rows(matrix):
    return [
        [matrix[2][column][row] for column in range(matrix[0])]
        for row in range(matrix[1])
    ]


def common_commutant_dimension(generators, row_basis, prime: int) -> int:
    size = len(generators[0])
    basis = row_basis(prime)
    for generator in generators:
        for row in range(size):
            for column in range(size):
                equation = [0] * (size * size)
                for middle in range(size):
                    equation[row * size + middle] = (
                        equation[row * size + middle]
                        + generator[middle][column]
                    ) % prime
                    equation[middle * size + column] = (
                        equation[middle * size + column]
                        - generator[row][middle]
                    ) % prime
                basis.add(equation)
    return size * size - len(basis)


def audit_family(
    evaluator,
    operators,
    labels,
    row_basis,
    prime: int,
    maximum_degree: int,
):
    out = {}
    for label in labels:

        @lru_cache(maxsize=None)
        def operator(degree: int, order: int):
            source, target, columns = evaluator.operator_matrix(
                label, degree, order, operators, prime
            )
            return len(source), len(target), columns

        tested = 0
        failures = []
        for degree in range(maximum_degree + 1):
            multiplicity = len(evaluator.descriptors(label, degree))
            if multiplicity <= 1:
                continue
            upward = operator(degree, 3)
            upper_gram = compose(operator(degree + 6, 9), upward, prime)
            if degree >= 6:
                lower_gram = compose(
                    operator(degree - 6, 3),
                    operator(degree, 9),
                    prime,
                )
            else:
                lower_gram = (
                    multiplicity,
                    multiplicity,
                    [[0] * multiplicity for _ in range(multiplicity)],
                )
            commutant_dimension = common_commutant_dimension(
                [rows(lower_gram), rows(upper_gram)],
                row_basis,
                prime,
            )
            tested += 1
            if commutant_dimension != 1:
                failures.append(
                    {
                        "degree": degree,
                        "multiplicity": multiplicity,
                        "common_commutant_dimension": commutant_dimension,
                    }
                )
        out[label] = {
            "tested_multiplicity_gt_one_degrees": tested,
            "failures": failures,
        }
    return out


def classify(prime: int = PRIME, maximum_degree: int = MAXIMUM_DEGREE):
    global_replay = load(GLOBAL_REPLAY, "local_return_global_replay")
    monotone_replay = load(MONOTONE_REPLAY, "local_return_monotone_replay")
    linear_algebra = load(LINEAR_ALGEBRA, "local_return_linear_algebra")

    global_operators = json.loads(
        GLOBAL_OPERATORS.read_text(encoding="utf-8")
    )["operators"]
    global_operators.update(
        json.loads(TRIVIAL_OPERATORS.read_text(encoding="utf-8"))
    )
    monotone_operators = json.loads(
        MONOTONE_OPERATORS.read_text(encoding="utf-8")
    )

    global_rows = audit_family(
        global_replay,
        global_operators,
        GLOBAL_LABELS,
        linear_algebra.RowBasis,
        prime,
        maximum_degree,
    )
    monotone_rows = audit_family(
        monotone_replay.PHASE_REPLAY,
        monotone_operators,
        MONOTONE_LABELS,
        linear_algebra.RowBasis,
        prime,
        maximum_degree,
    )
    blocks = {**global_rows, **monotone_rows}
    failures = [
        (label, failure)
        for label, row in blocks.items()
        for failure in row["failures"]
    ]
    assert failures == [
        (
            "3",
            {
                "degree": 22,
                "multiplicity": 2,
                "common_commutant_dimension": 2,
            },
        )
    ]

    return {
        "schema": "c682-local-return-algebra-v1",
        "field": f"F_{prime}",
        "degree_domain": f"0..{maximum_degree}",
        "operators": {
            "lower": "D_(n-6) D_(n-6)^dagger",
            "upper": "D_n^dagger D_n",
        },
        "criterion": (
            "The common commutant of the two self-adjoint Gram returns "
            "is scalar on each multiplicity block."
        ),
        "blocks": blocks,
        "classification": {
            "unique_failure": {
                "module": "3",
                "degree": 22,
                "multiplicity": 2,
                "common_commutant_dimension": 2,
            },
            "all_other_tested_blocks": "scalar common commutant",
            "claim_boundary": (
                "Finite corroboration only. The all-weight theorem uses "
                "the block-Jacobi/Wronskian proof in the report."
            ),
        },
        "inputs": {
            path.name: {
                "bytes": path.stat().st_size,
                "sha256": sha256(path),
            }
            for path in (
                GLOBAL_OPERATORS,
                TRIVIAL_OPERATORS,
                MONOTONE_OPERATORS,
            )
        },
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    arguments = parser.parse_args()
    rendered = json.dumps(classify(), indent=2, sort_keys=True) + "\n"
    if arguments.check:
        assert CERTIFICATE.read_text(encoding="utf-8") == rendered
        print("PASS: C682 local-return block audit")
    else:
        CERTIFICATE.write_text(rendered, encoding="utf-8")
        print(f"WROTE: {CERTIFICATE}")


if __name__ == "__main__":
    main()
