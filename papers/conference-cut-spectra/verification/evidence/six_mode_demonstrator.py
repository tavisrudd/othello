#!/usr/bin/env python3
"""Generate the exact/numerical six-mode demonstrator design certificate."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
import math
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
OUTPUT = HERE / "six_mode_demonstrator.json"
BOSON_FERMION_CERTIFICATE = HERE / "boson_fermion_complement.json"
N = 6


def mm(left: list[list[float]], right: list[list[float]]) -> list[list[float]]:
    return [[sum(left[i][k] * right[k][j] for k in range(len(right)))
             for j in range(len(right[0]))] for i in range(len(left))]


def transpose(matrix: list[list[float]]) -> list[list[float]]:
    return [list(row) for row in zip(*matrix)]


def identity(n: int) -> list[list[float]]:
    return [[float(i == j) for j in range(n)] for i in range(n)]


def max_error(left: list[list[float]], right: list[list[float]]) -> float:
    return max(abs(left[i][j] - right[i][j])
               for i in range(len(left)) for j in range(len(left[0])))


def expression_value(text: str) -> float:
    return float(eval(text, {"__builtins__": {}}, {"sqrt": math.sqrt}))


def givens_matrix(a: int, b: int, theta: float) -> list[list[float]]:
    result = identity(N)
    c, s = math.cos(theta), math.sin(theta)
    result[a][a] = c
    result[a][b] = s
    result[b][a] = -s
    result[b][b] = c
    return result


def decompose_orthogonal(matrix: list[list[float]]) -> tuple[list[dict[str, object]], list[int], float]:
    work = [row[:] for row in matrix]
    reduction = []
    for column in range(N - 1):
        for row in range(N - 1, column, -1):
            x, y = work[row - 1][column], work[row][column]
            theta = math.atan2(y, x)
            rotation = givens_matrix(row - 1, row, theta)
            work = mm(rotation, work)
            reduction.append({"modes_zero_based": [row - 1, row], "theta_radians": theta})
    signs = [1 if work[i][i] >= 0 else -1 for i in range(N)]
    diagonal = [[float(signs[i] if i == j else 0) for j in range(N)] for i in range(N)]
    reconstruction = diagonal
    netlist = []
    for item in reversed(reduction):
        a, b = item["modes_zero_based"]
        theta = -float(item["theta_radians"])
        reconstruction = mm(givens_matrix(a, b, theta), reconstruction)
        netlist.append({"modes_zero_based": [a, b], "theta_radians": theta})
    return netlist, signs, max_error(matrix, reconstruction)


def conference(bits: tuple[int, ...]) -> tuple[tuple[int, ...], ...]:
    edges = tuple(itertools.combinations(range(1, N), 2))
    matrix = [[0] * N for _ in range(N)]
    for i in range(1, N):
        matrix[0][i] = matrix[i][0] = 1
    for bit, (i, j) in zip(bits, edges):
        matrix[i][j] = matrix[j][i] = -1 if bit else 1
    return tuple(tuple(row) for row in matrix)


def is_conference(matrix: tuple[tuple[int, ...], ...]) -> bool:
    return all(sum(matrix[i][k] * matrix[k][j] for k in range(N)) == 5 * int(i == j)
               for i in range(N) for j in range(N))


def det3(matrix: list[list[int]]) -> int:
    return (matrix[0][0] * (matrix[1][1] * matrix[2][2] - matrix[1][2] * matrix[2][1])
            - matrix[0][1] * (matrix[1][0] * matrix[2][2] - matrix[1][2] * matrix[2][0])
            + matrix[0][2] * (matrix[1][0] * matrix[2][1] - matrix[1][1] * matrix[2][0]))


def sign_word(matrix: tuple[tuple[int, ...], ...]) -> tuple[int, ...]:
    word = []
    for tail in itertools.combinations(range(1, N), 2):
        left = (0,) + tail
        right = tuple(i for i in range(N) if i not in left)
        determinant = det3([[matrix[i][j] for j in right] for i in left])
        assert abs(determinant) == 4
        word.append(determinant // 4)
    return tuple(word)


def simplex_schedule() -> dict[str, object]:
    matrices = [conference(bits) for bits in itertools.product((0, 1), repeat=10)]
    words = sorted({sign_word(matrix) for matrix in matrices if is_conference(matrix)})
    assert len(words) == 6
    cuts = [(0,) + tail for tail in itertools.combinations(range(1, N), 2)]
    classifiers = [positions for positions in itertools.combinations(range(10), 3)
                   if len({tuple(word[p] for p in positions) for word in words}) == 6]
    assert len(classifiers) == 60
    cycle_edges = {(1, 2), (2, 3), (3, 4), (4, 5), (1, 5)}
    edge_index = {edge: i for i, edge in enumerate(itertools.combinations(range(1, N), 2))}
    cycle_positions = tuple(sorted(edge_index[edge] for edge in cycle_edges))
    assert len({tuple(word[p] for p in cycle_positions) for word in words}) == 6
    return {
        "cut_representatives": [list(cut) for cut in cuts],
        "six_words": [list(word) for word in words],
        "example_three_cut_classifier_zero_based": list(classifiers[0]),
        "number_of_three_cut_classifiers": len(classifiers),
        "example_five_cycle_zero_based": list(cycle_positions),
        "matched_filter": "argmax_T <y,r_T>",
        "pairwise_hamming_distance": 6,
        "guaranteed_sign_error_correction_full_ten": 2,
        "orientation_boundary": "the relative word does not distinguish C from -C",
    }


def binomial_trials(probability: Fraction, relative_error: Fraction = Fraction(1, 10),
                    family_size: int = 6, alpha: float = 0.05) -> int:
    z = 2.638257273476751  # NormalDist().inv_cdf(1-alpha/(2*family_size)).
    p = float(probability)
    return math.ceil(z * z * (1 - p) / (float(relative_error) ** 2 * p))


def probability_record(probability: Fraction) -> dict[str, object]:
    trials = binomial_trials(probability)
    return {
        "probability": str(probability),
        "trials_for_10pct_relative_familywise_95pct": trials,
        "hours_at_1_accepted_trial_per_second": trials / 3600,
        "minutes_at_100_accepted_trials_per_second": trials / 6000,
    }


def build() -> dict[str, object]:
    source = json.loads(BOSON_FERMION_CERTIFICATE.read_text())
    q_plus = [[expression_value(value) for value in row] for row in source["port_gauge"]["q_plus"]]
    q_minus = [[expression_value(value) for value in row] for row in source["port_gauge"]["q_minus"]]
    orthogonal = [q_plus[i] + q_minus[i] for i in range(N)]
    assert max_error(mm(transpose(orthogonal), orthogonal), identity(N)) < 2e-15
    netlist, input_signs, reconstruction_error = decompose_orthogonal(orthogonal)
    assert len(netlist) == 15 and reconstruction_error < 2e-14

    kappa = Fraction(72, 455)
    charges = (11, -10, -8, 5, 4, -2)
    chiral_probabilities = [kappa * kappa * q * q / 500 for q in charges]
    balanced_fermion = Fraction(16, 125)
    boson_probabilities = [Fraction(16, 3125), Fraction(36, 3125), Fraction(64, 3125)]
    balanced_amplitude = 4 / (5 * math.sqrt(5))
    chiral_min_amplitude = float(kappa * 2 / 10) / math.sqrt(5)
    fidelity = 0.91

    return {
        "schema": "golden-six-mode-demonstrator-v1",
        "verdict": {
            "full_experiment": "NO-GO on demonstrated 2026 photonic resources",
            "bounded_precursor": "GO for coherent transfer tomography plus ordinary three-boson control",
            "blocking_component": "no demonstrated high-fidelity totally antisymmetric three-photon qutrit source",
        },
        "logical_network": {
            "formula": "U_T(x)=O_T^T diag(x) O_T; K_T is rows 3..5, columns 0..2",
            "base_O_columns": "[Q_+,Q_-] in the frozen Golden pivot gauge",
            "base_O_numeric": orthogonal,
            "base_O_input_phase_signs": input_signs,
            "base_O_input_to_output_givens": netlist,
            "givens_convention": "[[cos(theta),sin(theta)],[-sin(theta),cos(theta)]] on the named adjacent modes",
            "reconstruction_max_entry_error": reconstruction_error,
            "base_O_mzi_count": len(netlist),
            "six_protocol_path_permutations": source["six_protocols"]["lexicographic_representatives"],
            "protocol_transport": "surround the base program by the recorded path permutation; odd representatives exchange the two three-port halves and transpose K",
            "balanced_direct_mesh_count_per_copy": 15,
            "filtered_svd_mesh_count_per_copy": 30,
            "filtered_variable_attenuators_per_copy": 6,
            "photonic_emulation_copies": 3,
            "physical_modes_if_spatially_parallel": 18,
        },
        "controls": {
            "balanced": {
                "path_mask": "any 3+3 sign mask; ten projective masks and their complements",
                "fermion_amplitude_absolute": balanced_amplitude,
                "fermion_probability": probability_record(balanced_fermion),
                "calibrated_boson_collision_free_probabilities": [probability_record(p) for p in boson_probabilities],
                "intrinsic_uniform_boson_average": str(Fraction(313, 1250)),
            },
            "chiral": {
                "path_filter": ["1", "7/13", "1/7", "-1/5", "-1/2", "-1"],
                "charge_vector": list(charges),
                "common_amplitude_scale_kappa": str(kappa),
                "fermion_probabilities": [probability_record(p) for p in chiral_probabilities],
            },
        },
        "coherent_sign_readout": {
            "method": "phase-sensitive coherent-light characterization of each 6x6 transfer, followed by the calibrated real 3x3 determinant",
            "settings": "six single-input intensity settings plus five reference-input phase scans per copy",
            "claim_boundary": "recovers the determinant sign relative to calibrated port phases; it is not a direct many-body phase measurement",
            "balanced_operator_norm_error_for_sign": balanced_amplitude / 3,
            "chiral_smallest_operator_norm_error_for_sign": chiral_min_amplitude / 3,
            "chiral_smallest_operator_norm_error_for_10pct_amplitude": chiral_min_amplitude / 30,
        },
        "state_quality": {
            "benchmark_three_qutrit_fidelity": fidelity,
            "benchmark_fourfold_rate_hz": 1.1,
            "worst_case_probability_bias_from_fidelity": math.sqrt(1 - fidelity),
            "mixture_fidelity_needed_for_10pct_balanced_probability_bias": 1 - 0.1 * float(balanced_fermion),
            "worst_case_fidelity_needed_for_10pct_balanced_probability_bias": 1 - (0.1 * float(balanced_fermion)) ** 2,
            "mixture_fidelity_needed_for_10pct_smallest_chiral_probability_bias": 1 - 0.1 * float(min(chiral_probabilities)),
            "worst_case_fidelity_needed_for_10pct_smallest_chiral_probability_bias": 1 - (0.1 * float(min(chiral_probabilities))) ** 2,
        },
        "robustness": {
            "diagonal_real_loss": "preserves sum Z_T=sum Z_T^3=0 exactly but moves the target projective point",
            "diagonal_coherent_phase": "preserves the two polynomial identities over C; destroys a literal real sign unless phase-referenced",
            "uniform_amplitude_transmission_lambda": "amplitudes scale as lambda^3 and probabilities as lambda^6",
            "mesh_or_copy_mismatch": "breaks the shared Golden carrier; the linear residual sum Z_T is the first falsifiable null",
            "determinant_lipschitz_bound": "for contraction blocks, |det(K+E)-det(K)| <= 3 ||E||_2",
        },
        "simplex_decoder": simplex_schedule(),
        "literature_benchmarks": {
            "fermion_emulation": "Matthews et al. 2013 demonstrated two particles and proposed N-particle/N-copy emulation",
            "antisymmetric_qutrit_resource": "Goyal et al. 2014 give a two-beam-splitter preparation proposal; no experiment located",
            "three_qutrit_entanglement": "Hu et al. 2025 report GHZ fidelity 0.910(6) and about 1.1 Hz fourfold coincidences",
            "processor": "Somhorst et al. 2023 used three photons, a universal 12-mode SiN mesh, 54-60% transmission, and about 90% SNSPD efficiency",
            "transfer_tomography": "Rahimi-Keshari et al. 2013 demonstrated coherent phase characterization of a 6x6 optical network",
        },
        "trust_boundary": {
            "exact": "probabilities, charge scaling, simplex words, distance and decoder schedules",
            "numerical": "pivot-frame Givens angles and normal-approximation planning counts",
            "assumption": "reported GHZ resource metrics are a benchmark, not evidence that the antisymmetric state has been built",
        },
    }


def canonical_bytes(data: dict[str, object]) -> bytes:
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    payload = canonical_bytes(build())
    if args.check:
        assert OUTPUT.read_bytes() == payload
        print(f"ok: {OUTPUT.name} ({len(payload)} bytes, sha256={hashlib.sha256(payload).hexdigest()})")
    else:
        OUTPUT.write_bytes(payload)
        print(f"wrote {OUTPUT}")


if __name__ == "__main__":
    main()
