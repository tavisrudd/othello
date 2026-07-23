#!/usr/bin/env python3
"""Generate/check the compact C439 synthesis certificate."""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path

P = 11
NOTES = Path(__file__).resolve().parent
OUT = NOTES / "2026-07-20-c439-radical-hadamard-application-sweep.json"

INPUTS = [
    "2026-07-20-c430-conceptual-balanced-half-rigidity.md",
    "2026-07-20-c430-conceptual-balanced-half-rigidity.json",
    "2026-07-20-c418-c419-c410-successors.md",
    "2026-07-20-c418-c419-c410-successors-c419.json",
    "2026-07-22-c429-attack-vector-scan.md",
    "2026-07-22-c429-attack-vector-scan.json",
    "2026-07-23-c433-modular-depth-fourier-exact-sequence.md",
    "2026-07-23-c433-modular-depth-fourier-exact-sequence.json",
    "2026-07-23-c526-tate-pairing-rigid-target-bridge.md",
    "2026-07-23-c526-tate-pairing-rigid-target-bridge.json",
    "2026-07-22-c434-double-coset-information-lattice.md",
    "2026-07-22-c434-double-coset-information-lattice.json",
    "2026-07-22-c492-c434-conceptual-refoundation.md",
    "2026-07-22-c492-c434-conceptual-refoundation.json",
    "2026-07-20-c414-tautological-fourier-preflight.md",
    "2026-07-20-c414-tautological-fourier-preflight.json",
]

F = [
    [10, 0, 4, 9],
    [0, 10, 2, 4],
    [2, 1, 1, 0],
    [10, 2, 0, 1],
]
H = [
    [3, 5, 5, 9],
    [8, 10, 2, 9],
    [0, 3, 8, 8],
    [8, 7, 5, 1],
]
D = [
    [5, 10, 7],
    [0, 1, 10],
    [1, 0, 10],
    [10, 1, 0],
]
G = [[1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 2, 0], [0, 0, 0, 2]]
G_DEPTH = [[3, 7], [7, 10]]


def mm(a: list[list[int]], b: list[list[int]]) -> list[list[int]]:
    return [
        [sum(a[i][k] * b[k][j] for k in range(len(b))) % P for j in range(len(b[0]))]
        for i in range(len(a))
    ]


def add(a: list[list[int]], b: list[list[int]]) -> list[list[int]]:
    return [[(x + y) % P for x, y in zip(ar, br)] for ar, br in zip(a, b)]


def tr(a: list[list[int]]) -> list[list[int]]:
    return [list(row) for row in zip(*a)]


def rank(a: list[list[int]]) -> int:
    m = [row[:] for row in a]
    r = 0
    for c in range(len(m[0]) if m else 0):
        pivot = next((i for i in range(r, len(m)) if m[i][c] % P), None)
        if pivot is None:
            continue
        m[r], m[pivot] = m[pivot], m[r]
        inv = pow(m[r][c], -1, P)
        m[r] = [(x * inv) % P for x in m[r]]
        for i in range(len(m)):
            if i != r and m[i][c] % P:
                q = m[i][c]
                m[i] = [(x - q * y) % P for x, y in zip(m[i], m[r])]
        r += 1
    return r


def eye(n: int) -> list[list[int]]:
    return [[int(i == j) for j in range(n)] for i in range(n)]


def qpair(v: list[int], form: list[list[int]], w: list[int]) -> int:
    return sum(v[i] * form[i][j] * w[j] for i in range(len(v)) for j in range(len(w))) % P


def inverse2(a: list[list[int]]) -> list[list[int]]:
    det = (a[0][0] * a[1][1] - a[0][1] * a[1][0]) % P
    s = pow(det, -1, P)
    return [[a[1][1] * s % P, -a[0][1] * s % P],
            [-a[1][0] * s % P, a[0][0] * s % P]]


def file_record(name: str) -> dict[str, object]:
    data = (NOTES / name).read_bytes()
    return {"bytes": len(data), "sha256": hashlib.sha256(data).hexdigest()}


def build() -> dict[str, object]:
    zero4 = [[0] * 4 for _ in range(4)]
    assert mm(F, F) == zero4
    assert mm(H, H) == zero4
    assert add(mm(F, H), mm(H, F)) == eye(4)
    assert mm(tr(F), G) == mm(G, F)
    assert rank(F) == rank(H) == rank(D) == 2
    assert rank([row_f + row_d for row_f, row_d in zip(tr(F)[:2], D)]) >= 2

    # im(D) is transverse to ker(F)=im(F): concatenating columns has rank four.
    im_f_basis = [[F[i][0], F[i][1]] for i in range(4)]
    im_d_basis = [[D[i][0], D[i][1], D[i][2]] for i in range(4)]
    assert rank([im_f_basis[i] + im_d_basis[i] for i in range(4)]) == 4

    doubled, residual = [1, 10], [1, 9]
    target_cross = qpair(doubled, G_DEPTH, residual)
    target_dual_cross = qpair(doubled, inverse2(G_DEPTH), residual)
    assert (target_cross, target_dual_cross) == (2, 5)

    delta_matrix = [[-1, 2], [2, 1]]
    trace_matrix = [[2, 1], [1, 3]]
    assert abs(delta_matrix[0][0] * delta_matrix[1][1] - 4) == 5
    assert trace_matrix[0][0] * trace_matrix[1][1] - 1 == 5
    assert 4 * 4 % 11 == 5

    return {
        "schema": "c439-radical-hadamard-application-sweep-v1",
        "arithmetic_seam": {
            "integral_odd_line": "Z*(2tau-1)",
            "smith_invariants": [1, 5],
            "q11_square_class": "<5>=<1>",
            "canonical_landing": "ker(D)=outer-odd sheet socle line",
            "normalization_obstruction": {
                "arithmetic_carrier_dimension": 1,
                "fourier_radical_dimension": 2,
                "arithmetic_form_rank": 1,
                "fourier_radical_form_rank": 0,
                "verdict": "no isometry or scalar normalization to L_F",
            },
        },
        "c418_c419_pretest": [
            {"target": "C418 Pasch/common-core", "restriction_ranks": [3, 3],
             "radical_dimension": 0, "verdict": "fails separating-radical gate"},
            {"target": "C418 four-endpoint/incidence-2", "restriction_ranks": [1, 1],
             "radical_dimension": 0, "verdict": "fails separating-radical gate"},
            {"target": "C419 frozen generic stratum", "restriction_ranks": [1, 1],
             "radical_dimension": 0, "verdict": "uniform failure; no jump"},
        ],
        "modular_target": {
            "field": 11,
            "rank_F": rank(F),
            "rank_h": rank(H),
            "rank_D": rank(D),
            "F_squared_zero": True,
            "h_squared_zero": True,
            "Fh_plus_hF_identity": True,
            "F_self_adjoint": True,
            "depth_fourier_transverse": True,
            "target_flag_cross_pairings": {"vector": target_cross, "dual": target_dual_cross},
            "source_flag_cross_pairing": 0,
            "bridge_verdict": "obstructed: 0 versus 2 (dually 5)",
        },
        "mackey_interface": [
            {"type": "B3", "degrees": [3, 4], "bad_primes": [2, 3],
             "native_prime": 7, "native_semisimple": True},
            {"type": "H3", "degrees": [5, 6], "bad_primes": [2, 3, 5],
             "native_prime": 11, "native_semisimple": True},
        ],
        "b3_fourier_gate": {
            "canonical_cyclotomic_odd_core": True,
            "odd_dimension": 4,
            "integral_defining_characteristic_block": False,
            "canonical_contraction": False,
            "verdict": "negative stop; no B3 modular analogue run",
        },
        "naturality_theorem": {
            "required_transport": ["F", "depth_plane", "valency_pairing", "ordered_flag"],
            "forced_transport": ["fourier_radical", "h", "matrix_units", "grading"],
            "reason": "h is uniquely zero on the depth plane and inverse to F on im(F)",
            "base_category": "based-golden-pair groupoid",
        },
        "inputs": {name: file_record(name) for name in INPUTS},
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    payload = (json.dumps(build(), indent=2, sort_keys=True) + "\n").encode()
    if args.write:
        OUT.write_bytes(payload)
    else:
        if not OUT.exists() or OUT.read_bytes() != payload:
            raise SystemExit(f"certificate drift: regenerate with {Path(__file__).name} --write")
        print("C439 certificate OK")


if __name__ == "__main__":
    main()
