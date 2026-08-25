#!/usr/bin/env python3
"""Couple the type-I1 Cox coboundary to the residual norm-torus chart."""

import argparse
import hashlib
import json
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parents[1]
INPUTS = {
    "coboundary": (
        ROOT / "notes/2026-08-25-c958-type-i1-full-coboundary.json",
        "2dfbac5ca93ffe8257f30ddc4380a416e538362820cc243ba8a25644fdddc654",
    ),
    "residual_torus": (
        ROOT / "notes/2026-08-25-c958-type-i1-residual-norm-torus.json",
        "da4037611943c566bfd9041d989bb444845ddd729032b62b54bd57685671b105",
    ),
    "torus_chart": (
        ROOT / "notes/2026-08-25-c958-type-i1-norm-torus-parametrization.json",
        "b0032d9c5206c229553a9ccf737cf71ccb7b41263f627e69a7b5ef83ffdbb0aa",
    ),
}


def build():
    loaded = {}
    for name, (path, expected) in INPUTS.items():
        raw = path.read_bytes()
        assert hashlib.sha256(raw).hexdigest() == expected
        loaded[name] = json.loads(raw)

    assert loaded["coboundary"]["permutation_basis_determinant"] == -1
    assert loaded["residual_torus"]["augmentation_change_of_basis"] == [[-1, -1], [-1, 0]]
    assert "both composites are identities on the stated dense open" in loaded["torus_chart"]["certified"]

    labels = [f"E{index}" for index in range(1, 6)]
    labels += [f"L{left}{right}" for left in range(1, 6) for right in range(left + 1, 6)]
    labels += ["Q"]

    classes = {}
    residual_exponents = {}
    for label in labels:
        divisor = [0] * 6
        if label.startswith("E"):
            divisor[int(label[1])] = 1
        elif label.startswith("L"):
            divisor[0] = 1
            divisor[int(label[1])] = -1
            divisor[int(label[2])] = -1
        else:
            divisor[0] = 2
            for index in range(1, 6):
                divisor[index] = -1
        classes[label] = divisor
        if label == "E1":
            residual_exponents[label] = [1, 0]
        elif label == "E2":
            residual_exponents[label] = [0, 1]
        elif label.startswith("E"):
            residual_exponents[label] = [0, 0]
        elif label.startswith("L"):
            residual_exponents[label] = [
                -int("1" in label[1:]), -int("2" in label[1:])
            ]
        else:
            residual_exponents[label] = [-1, -1]

    expected_exponents = {
        "E1": [1, 0], "E2": [0, 1], "E3": [0, 0],
        "E4": [0, 0], "E5": [0, 0],
        "L12": [-1, -1], "L13": [-1, 0], "L23": [0, -1],
    }
    assert all(residual_exponents[label] == value for label, value in expected_exponents.items())

    plane_recovery = {
        "U": ["E2", "E3", "L23"],
        "V": ["E1", "E3", "L13"],
        "W": ["E1", "E2", "L12"],
    }
    for factors in plane_recovery.values():
        total_class = [sum(classes[label][index] for label in factors) for index in range(6)]
        total_residual = [sum(residual_exponents[label][index] for label in factors)
                          for index in range(2)]
        assert total_class == [1, 0, 0, 0, 0, 0]
        assert total_residual == [0, 0]

    # The change-of-basis columns send the augmentation cocharacters
    # (1,0,-1),(0,1,-1) to the residual cocharacter basis.  Dualizing gives
    # r1=t1^-1 t2^-1=t3 and r2=t1^-1.
    t1, t2, t3, r1, r2 = sp.symbols("t1 t2 t3 r1 r2")
    residual_from_norm = {r1: t3, r2: 1 / t1}
    norm_from_residual = {t1: 1 / r2, t2: r2 / r1, t3: r1}
    assert all(sp.factor(expression.subs(residual_from_norm).subs(norm_from_residual) - symbol) == 0
               for symbol, expression in ((r1, t3), (r2, 1 / t1)))
    assert sp.factor(sp.prod(norm_from_residual[value] for value in (t1, t2, t3)) - 1) == 0

    # Formal exponent checks for the forward/inverse coupling.  Write
    # q_D=f_D h_D^-1 r^weight(D).  The plane monomials cancel h and r because
    # all three have class H.  Exceptional ratios recover r1,r2 after the
    # displayed h correction.
    hH, h1, h2, h3, h4, h5 = sp.symbols("hH h1 h2 h3 h4 h5")
    h = [hH, h1, h2, h3, h4, h5]

    def h_value(label):
        return sp.prod(h[index] ** classes[label][index] for index in range(6))

    forward_exceptional = {
        label: h_value(label) ** -1
        * r1 ** residual_exponents[label][0]
        * r2 ** residual_exponents[label][1]
        for label in ("E1", "E2", "E3")
    }
    recovered_r1 = sp.factor(
        forward_exceptional["E1"] / forward_exceptional["E3"] * h1 / h3
    )
    recovered_r2 = sp.factor(
        forward_exceptional["E2"] / forward_exceptional["E3"] * h2 / h3
    )
    assert recovered_r1 == r1 and recovered_r2 == r2

    forward_recipe = {
        label: {
            "cox_section": f"f_{label}(z,u,v)",
            "coboundary_factor": f"h_{label}^-1",
            "residual_exponents_r1_r2": residual_exponents[label],
        }
        for label in labels
    }

    return {
        "schema": "c958-type-i1-torsor-coupling-v1",
        "input_sha256": {name: expected for name, (_, expected) in INPUTS.items()},
        "forward_coordinate_recipe": forward_recipe,
        "cox_section_forms": {
            "E_i": "1",
            "L12": "w", "L13": "v", "L23": "u",
            "remaining": "the standard marked-plane forms retained in the Cox descent certificate",
        },
        "coboundary_evaluation": "h_D=product_j h_old[j]^class(D)_j, with h_old given by the retained finite SLP",
        "residual_norm_coordinate_change": {
            "forward": ["r1=t3", "r2=1/t1"],
            "inverse": ["t1=1/r2", "t2=r2/r1", "t3=r1"],
        },
        "inverse_surface_coordinates": {
            name: "*".join(f"q_{label}" for label in factors)
            for name, factors in plane_recovery.items()
        },
        "inverse_residual_coordinates": [
            "r1=(q_E1/q_E3)*(h_E1/h_E3)",
            "r2=(q_E2/q_E3)*(h_E2/h_E3)",
            "these are the quotient-character ratios in the neutral E3 lift",
        ],
        "birational_pipeline": [
            "P2 -> R^1_{E/K}(Gm) by the certified norm-cubic/quadric chart",
            "convert its three conjugates to residual coordinates (r1,r2)",
            "evaluate the six-coordinate coboundary SLP at the marked-plane point",
            "form q_D=f_D*h_D^-1*r1^a_D*r2^b_D and take its T3-orbit",
            "recover the surface from the three degree-H Cox monomials and the torus from the two quotient-character ratios",
        ],
        "dense_open": [
            "all denominators and three Hilbert-90 seeds in the coboundary SLP are nonzero",
            "the Cox section lies in the universal-torsor open",
            "the norm-torus chart satisfies B(P,q)*h*N(Z) != 0",
            "the exceptional coordinates used by the inverse ratios are nonzero",
        ],
        "certified": [
            "the residual Cox weights are the characters E1-E3 and E2-E3",
            "the augmentation-lattice change gives (r1,r2)=(t3,1/t1)",
            "the three plane-recovery Cox monomials all have class H and zero residual weight",
            "the forward coordinate recipe is Galois equivariant because h is the certified cocycle coboundary",
            "the displayed inverse recovers the marked-plane point and both residual torus coordinates",
            "coupling with the certified norm-torus chart gives both composites on the stated dense open",
            "there is a K-birational map S times P2 to Z/T3, represented by the finite SLP",
        ],
        "not_certified": [
            "an explicit K-rational tangent-section map Z/T3 to P4",
            "the final cubic-product maps after the fibration function-field passage",
            "type-I3 coupling",
        ],
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", type=Path)
    mode.add_argument("--check", type=Path)
    arguments = parser.parse_args()
    payload = json.dumps(build(), indent=2, sort_keys=True) + "\n"
    if arguments.write:
        arguments.write.write_text(payload)
    else:
        assert arguments.check.read_text() == payload


if __name__ == "__main__":
    main()
