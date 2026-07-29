#!/usr/bin/env sage
"""Independent scalar replay of the q=121 top-contraction detector."""

import importlib.machinery
import importlib.util
import json
from pathlib import Path

from sage.all import matrix


HERE = Path(__file__).resolve().parent
SUPPORT_PATH = HERE / "2026-07-28-c665-q121-pullback-support.sage"
CERTIFICATE = HERE / "2026-07-28-c665-q121-contraction-detector.json"


def load_support():
    loader = importlib.machinery.SourceFileLoader(
        "c665_q121_replay_support", str(SUPPORT_PATH)
    )
    spec = importlib.util.spec_from_loader(loader.name, loader)
    if spec is None:
        raise RuntimeError(f"cannot load {SUPPORT_PATH}")
    module = importlib.util.module_from_spec(spec)
    loader.exec_module(module)
    return module


support = load_support()
base = support.base
FIELD = support.FIELD
A = support.A
HALF = FIELD(2)**-1


def scalar_pairing(left, right):
    right_coefficients = {
        tuple(exponent): coefficient
        for exponent, coefficient in right.dict().items()
    }
    return sum(
        (
            coefficient
            * right_coefficients.get(
                (int(exponent[2]), int(exponent[1]), int(exponent[0])),
                FIELD.zero(),
            )
            * (-HALF) ** int(exponent[1])
            for exponent, coefficient in left.dict().items()
        ),
        FIELD.zero(),
    )


def calculate():
    group_elements = (
        (1, 1, 0, 1),
        (1, A, 0, 1),
        (0, -1, 1, 0),
    )
    generator_data = [
        support.action_data(element) for element in group_elements
    ]
    primitive = FIELD.multiplicative_generator()
    torus_data = support.action_data(
        (primitive, 0, 0, primitive**-1)
    )
    _, _, cocycles = support.split_torus_fixed_lift(
        generator_data, torus_data
    )
    _, embedding, simple_actions = support.embedding_polynomials()
    zero_weight_column = base.SIMPLE_WEIGHTS.index(0)
    rows = []
    nonzero_defects = 0
    for cocycle, action in zip(cocycles, simple_actions):
        for source_column in range(base.SIMPLE_DEGREE + 1):
            embedded_image = sum(
                (
                    action[source_row, source_column]
                    * embedding[source_row]
                    for source_row in range(base.SIMPLE_DEGREE + 1)
                    if action[source_row, source_column]
                ),
                support.R.zero(),
            )
            defect = scalar_pairing(cocycle, embedded_image)
            nonzero_defects += bool(defect)
            coefficient = (
                FIELD.one()
                if source_column == zero_weight_column
                else FIELD.zero()
            ) - action[zero_weight_column, source_column]
            if coefficient or defect:
                rows.append([coefficient, defect])
    augmented = matrix(FIELD, rows)
    coefficient_rank = augmented[:, :1].rank()
    augmented_rank = augmented.rank()
    assert (
        len(rows),
        nonzero_defects,
        coefficient_rank,
        augmented_rank,
    ) == (15, 14, 1, 2)
    certificate = json.loads(CERTIFICATE.read_text())
    certified = certificate["channels"][0]
    assert certified["contraction_order"] == 59
    assert certified["equations"] == len(rows)
    assert certified["nonzero_defect_columns"] == nonzero_defects
    assert certified["coefficient_rank"] == coefficient_rank
    assert certified["augmented_rank"] == augmented_rank
    assert not certified["solvable"]
    return {
        "rows": len(rows),
        "nonzero_defects": nonzero_defects,
        "coefficient_rank": coefficient_rank,
        "augmented_rank": augmented_rank,
    }


if __name__ == "__main__":
    result = calculate()
    print(
        "replayed q=121 scalar detector: "
        f"{result['coefficient_rank']}->{result['augmented_rank']}"
    )
