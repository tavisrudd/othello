#!/usr/bin/env python3
"""Generate the exact C707 golden-ETF measurement certificate."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
INPUT = ROOT / "notes" / "2026-07-30-c704-segre-igusa-operator-shadow.json"
OUTPUT = ROOT / "notes" / "2026-07-31-c707-golden-etf-quantum-measurements.json"
TRIPLES = tuple(itertools.combinations(range(6), 3))
BASE_C = (
    (0, 1, 1, 1, -1, -1),
    (1, 0, -1, -1, -1, -1),
    (1, -1, 0, 1, 1, -1),
    (1, -1, 1, 0, -1, 1),
    (-1, -1, 1, -1, 0, -1),
    (-1, -1, -1, 1, -1, 0),
)
BASE_TOTAL = (
    ((0, 1), (2, 3), (4, 5)),
    ((0, 2), (1, 4), (3, 5)),
    ((0, 3), (1, 5), (2, 4)),
    ((0, 4), (1, 3), (2, 5)),
    ((0, 5), (1, 2), (3, 4)),
)
WITNESSES = (
    (1, 2, 3, 4, 5, -15),
    (1, 0, 2, -1, 3, -5),
)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def matmul(left: list[list[int]], right: list[list[int]]) -> list[list[int]]:
    return [
        [sum(left[i][k] * right[k][j] for k in range(len(right)))
         for j in range(len(right[0]))]
        for i in range(len(left))
    ]


def rational_rank(matrix: list[list[int | Fraction]]) -> int:
    work = [[Fraction(value) for value in row] for row in matrix]
    row = 0
    for column in range(len(work[0])):
        pivot = next((i for i in range(row, len(work)) if work[i][column]), None)
        if pivot is None:
            continue
        work[row], work[pivot] = work[pivot], work[row]
        pivot_value = work[row][column]
        work[row] = [entry / pivot_value for entry in work[row]]
        for i in range(len(work)):
            if i != row and work[i][column]:
                factor = work[i][column]
                work[i] = [
                    work[i][j] - factor * work[row][j]
                    for j in range(len(work[0]))
                ]
        row += 1
    return row


def parity(permutation: tuple[int, ...]) -> int:
    inversions = sum(
        permutation[i] > permutation[j]
        for i in range(6)
        for j in range(i + 1, 6)
    )
    return -1 if inversions % 2 else 1


def triangle_cubic(matrix: tuple[tuple[int, ...], ...]) -> tuple[int, ...]:
    return tuple(matrix[i][j] * matrix[j][k] * matrix[k][i]
                 for i, j, k in TRIPLES)


def permute_cubic(cubic: tuple[int, ...], p: tuple[int, ...]) -> tuple[int, ...]:
    target = {}
    for coefficient, support in zip(cubic, TRIPLES):
        target[tuple(sorted(p[i] for i in support))] = coefficient
    return tuple(target[support] for support in TRIPLES)


def total_key(total) -> tuple[tuple[tuple[int, int], ...], ...]:
    return tuple(sorted(tuple(sorted(matching)) for matching in total))


def outer_cubics() -> list[tuple[int, ...]]:
    base = triangle_cubic(BASE_C)
    oriented = {}
    for p in itertools.permutations(range(6)):
        key = total_key(
            tuple(
                tuple(sorted(tuple(sorted((p[i], p[j]))) for i, j in matching))
                for matching in BASE_TOTAL
            )
        )
        cubic = tuple(parity(p) * value for value in permute_cubic(base, p))
        if key in oriented:
            assert oriented[key] == cubic
        else:
            oriented[key] = cubic
    assert len(oriented) == 6
    result = [oriented[key] for key in sorted(oriented)]
    assert all(sum(cubic[i] for cubic in result) == 0 for i in range(20))
    return result


def evaluate(cubic: tuple[int, ...], x: tuple[int, ...]) -> int:
    return sum(
        coefficient * x[i] * x[j] * x[k]
        for coefficient, (i, j, k) in zip(cubic, TRIPLES)
    )


def gradient(cubic: tuple[int, ...], x: tuple[int, ...]) -> list[int]:
    result = [0] * 6
    for coefficient, support in zip(cubic, TRIPLES):
        i, j, k = support
        result[i] += coefficient * x[j] * x[k]
        result[j] += coefficient * x[i] * x[k]
        result[k] += coefficient * x[i] * x[j]
    return result


def centered_squares(values: tuple[int, ...]) -> list[int]:
    total = sum(value * value for value in values)
    return [6 * value * value - total for value in values]


def symmetry_counts() -> dict[str, int]:
    counts = {1: 0, -1: 0}
    for p in itertools.permutations(range(6)):
        for epsilon in (1, -1):
            signs = [1] + [
                epsilon * BASE_C[0][j] * BASE_C[p[0]][p[j]]
                for j in range(1, 6)
            ]
            if all(
                signs[i] * signs[j] * BASE_C[p[i]][p[j]]
                == epsilon * BASE_C[i][j]
                for i in range(6)
                for j in range(6)
            ):
                counts[epsilon] += 1
    assert counts == {1: 60, -1: 60}
    return {"preserve_one_measurement": counts[1], "exchange_the_pair": counts[-1]}


def fraction_string(value: Fraction) -> str:
    return str(value.numerator) if value.denominator == 1 else f"{value.numerator}/{value.denominator}"


def build() -> dict[str, object]:
    source = json.loads(INPUT.read_text())
    assert source["base_conference_square"] == "C^2=5I_6"
    assert source["golden_block_determinant"] == (
        "for P_+ and P_- over Q(sqrt(5)), "
        "Z_base(x)^2=500 det(P_- diag(x) P_+)^2"
    )
    c_square = matmul([list(row) for row in BASE_C], [list(row) for row in BASE_C])
    assert c_square == [[5 * int(i == j) for j in range(6)] for i in range(6)]

    # Hilbert--Schmidt Gram matrix of the six unit rank-one projectors.
    effect_gram = [
        [Fraction(1) if i == j else Fraction(1, 5) for j in range(6)]
        for i in range(6)
    ]
    assert rational_rank(effect_gram) == 6
    ones = [Fraction(1)] * 6
    assert [sum(effect_gram[i][j] * ones[j] for j in range(6))
            for i in range(6)] == [Fraction(2)] * 6
    for k in range(1, 6):
        vector = [Fraction(-1)] + [Fraction(int(i == k)) for i in range(1, 6)]
        assert [sum(effect_gram[i][j] * vector[j] for j in range(6))
                for i in range(6)] == [Fraction(4, 5) * value for value in vector]

    cubics = outer_cubics()
    for four_set in itertools.combinations(range(6), 4):
        a, b, c, d = four_set
        cycle_sum = (
            BASE_C[a][b] * BASE_C[b][c] * BASE_C[c][d] * BASE_C[d][a]
            + BASE_C[a][b] * BASE_C[b][d] * BASE_C[d][c] * BASE_C[c][a]
            + BASE_C[a][c] * BASE_C[c][b] * BASE_C[b][d] * BASE_C[d][a]
        )
        assert cycle_sum == -1
    balanced_phase_traces = set()
    for support in itertools.combinations(range(6), 3):
        signs = [-1 if i in support else 1 for i in range(6)]
        assert sum(
            signs[i] * signs[j] * signs[k] * signs[l]
            for i, j, k, l in itertools.combinations(range(6), 4)
        ) == 3
        diagonal = [[signs[i] * int(i == j) for j in range(6)] for i in range(6)]
        cd = matmul([list(row) for row in BASE_C], diagonal)
        cd2 = matmul(cd, cd)
        cd4 = matmul(cd2, cd2)
        traces = (sum(cd2[i][i] for i in range(6)), sum(cd4[i][i] for i in range(6)))
        assert traces == (-6, -42)
        balanced_phase_traces.add(traces)
    assert balanced_phase_traces == {(-6, -42)}
    for cubic in cubics:
        counts = {0: 0, 8: 0}
        for signs in itertools.product((-1, 1), repeat=6):
            absolute_value = abs(evaluate(cubic, signs))
            assert absolute_value in counts
            counts[absolute_value] += 1
        assert counts == {0: 44, 8: 20}
    witness_data = []
    for x in WITNESSES:
        z = tuple(evaluate(cubic, x) for cubic in cubics)
        derivative = [[gradient(cubic, x)[i] for cubic in cubics] for i in range(6)]
        q6 = [6 * value * value - sum(t * t for t in x) for value in x]
        w6 = centered_squares(z)
        assert all(sum(derivative[i][t] for t in range(6)) == 0 for i in range(6))
        assert all(sum(derivative[i][t] for i in range(6)) == 0 for t in range(6))
        assert all(sum(q6[i] * derivative[i][t] for i in range(6)) == 0 for t in range(6))
        assert all(sum(derivative[i][t] * w6[t] for t in range(6)) == 0 for i in range(6))
        assert rational_rank(derivative) == 4

        scale = max(abs(value) for value in x)
        probabilities = [Fraction(value * value, 500 * scale**6) for value in z]
        assert all(Fraction(0) <= value <= Fraction(1) for value in probabilities)
        witness_data.append(
            {
                "path_amplitudes": [fraction_string(Fraction(value, scale)) for value in x],
                "joubert_numerators_at_integer_lift": list(z),
                "three_copy_success_probabilities": [fraction_string(value) for value in probabilities],
                "response_rank_before_augmentation_quotients": 4,
                "source_kernel": ["constant", "center(x^2)"],
                "target_kernel": ["constant", "6Z^2-sum(Z^2)"],
            }
        )

    return {
        "schema": "c707-golden-etf-quantum-measurements-v1",
        "input": {
            "path": str(INPUT.relative_to(ROOT)),
            "sha256": sha256(INPUT),
            "bytes": INPUT.stat().st_size,
        },
        "golden_frames": {
            "normalized_gram_matrices": "G_+=I+C/sqrt(5), G_-=I-C/sqrt(5)",
            "frame_dimension": 3,
            "outcomes": 6,
            "frame_bound": 2,
            "coherence_squared": "1/5",
            "naimark_relation": "G_- = 2I-G_+",
            "povm_effects": "E_i=(1/2)|u_i><u_i|",
            "effect_gram_spectrum": {"2": 1, "4/5": 5},
            "real_tomography": "rho=(5/2)sum_i p_i |u_i><u_i|-(1/2)I",
            "complex_qutrit_informationally_complete": False,
        },
        "symmetry": symmetry_counts(),
        "cross_measurement_protocol": {
            "kraus_operator": "K_T(x)=Q_{T,-}^T diag(x) Q_{T,+}=(1/2)sum_i x_i |u_{T,i}^-><u_{T,i}^+|",
            "physical_domain": "max_i |x_i| <= 1",
            "three_copy_amplitude": "det K_T(x)=+/- Z_T(x)/(10 sqrt(5))",
            "three_copy_success_probability": "det(K_T^T K_T)=Z_T(x)^2/500",
            "sharp_physical_cube_bound": "|Z_T(x)|<=8 and p_T^(3)(x)<=16/125 for max_i|x_i|<=1",
            "sharp_phase_patterns": "equality exactly at the 20 vertices with three +1 and three -1 entries",
            "vertex_absolute_value_counts_per_protocol": {"0": 44, "8": 20},
            "optimal_squared_singular_values": ["4/5", "4/5", "1/5"],
            "optimal_filter_trace_witnesses": {"trace((CD)^2)": -6, "trace((CD)^4)": -42},
            "query_optimality": "three uses are necessary: an r-query acceptance probability has degree at most 2r, while Z_T^2 has degree 6",
            "polar_probability_contrast": "center_T(Z_T^2)=500 center_T(p_T^(3))",
            "c705_polar_scaling": "W_T=6Z_T^2-sum_U Z_U^2=3000 center_T(p_T^(3))",
            "response": "A=dZ is the first variation of oriented three-copy transition amplitude",
            "not_an_ic_locus": "the fixed POVMs are real-IC everywhere; rank drops concern the controlled transfer map",
        },
        "witnesses": witness_data,
    }


def canonical_bytes(data: dict[str, object]) -> bytes:
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.write == args.check:
        parser.error("choose exactly one of --write or --check")
    rendered = canonical_bytes(build())
    if args.write:
        OUTPUT.write_bytes(rendered)
    else:
        assert OUTPUT.read_bytes() == rendered
    print(
        json.dumps(
            {
                "certificate": OUTPUT.name,
                "bytes": len(rendered),
                "sha256": hashlib.sha256(rendered).hexdigest(),
                "status": "written" if args.write else "verified",
            },
            sort_keys=True,
        )
    )


if __name__ == "__main__":
    main()
