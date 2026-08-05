#!/usr/bin/env python3
"""Exact one-frame and arithmetic lifts of the Paper-IV transition code."""

from __future__ import annotations

import argparse
import importlib.util
import json
from collections import Counter
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
ORBIT_TOOL = ROOT / "notes/2026-08-04-c682-paper-iv-orbit-correspondence.py"
ORBIT_CERT = ROOT / "notes/2026-08-04-c682-paper-iv-orbit-correspondence.json"
FRAME_CERT = ROOT / "notes/2026-08-04-c682-paper-iv-frame-metacode.json"
TRACKED = ROOT / "notes/2026-08-04-c682-paper-iv-project-up.json"
N = 91


def load(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def transpose(rows: list[int], columns: int) -> list[int]:
    result = [0] * columns
    for row_index, row in enumerate(rows):
        while row:
            bit = row & -row
            result[bit.bit_length() - 1] |= 1 << row_index
            row ^= bit
    return result


def kernel_basis(rows: list[int], columns: int) -> list[int]:
    work = rows[:]
    pivots: list[tuple[int, int]] = []
    rank = 0
    for column in range(columns):
        pivot = next((row for row in range(rank, len(work)) if work[row] >> column & 1), None)
        if pivot is None:
            continue
        work[rank], work[pivot] = work[pivot], work[rank]
        for row in range(len(work)):
            if row != rank and work[row] >> column & 1:
                work[row] ^= work[rank]
        pivots.append((rank, column))
        rank += 1
    pivot_columns = {column for _, column in pivots}
    basis = []
    for free in range(columns):
        if free in pivot_columns:
            continue
        vector = 1 << free
        for row, pivot in pivots:
            if work[row] >> free & 1:
                vector |= 1 << pivot
        basis.append(vector)
    assert all(all((row & vector).bit_count() % 2 == 0 for row in rows) for vector in basis)
    return basis


def enumerate_code(basis: list[int]) -> tuple[Counter[int], set[int]]:
    word = 0
    words = {0}
    weights = Counter({0: 1})
    for index in range(1, 1 << len(basis)):
        word ^= basis[(index & -index).bit_length() - 1]
        words.add(word)
        weights[word.bit_count()] += 1
    assert len(words) == 1 << len(basis)
    return weights, words


def weight_enumerator(counter: Counter[int]) -> list[dict[str, int]]:
    return [
        {"weight": weight, "count": counter[weight]}
        for weight in sorted(counter)
        if counter[weight]
    ]


def rank_mod_prime(matrix: list[list[int]], prime: int) -> int:
    work = [[value % prime for value in row] for row in matrix]
    rank = 0
    for column in range(len(work[0])):
        pivot = next((row for row in range(rank, len(work)) if work[row][column]), None)
        if pivot is None:
            continue
        work[rank], work[pivot] = work[pivot], work[rank]
        inverse = pow(work[rank][column], -1, prime)
        work[rank] = [(value * inverse) % prime for value in work[rank]]
        for row in range(rank + 1, len(work)):
            scale = work[row][column]
            if scale:
                work[row] = [
                    (left - scale * right) % prime
                    for left, right in zip(work[row], work[rank])
                ]
        rank += 1
    return rank


def bareiss_determinant(matrix: list[list[int]]) -> int:
    work = [row[:] for row in matrix]
    sign = 1
    denominator = 1
    for column in range(len(work) - 1):
        pivot = next((row for row in range(column, len(work)) if work[row][column]), None)
        if pivot is None:
            return 0
        if pivot != column:
            work[column], work[pivot] = work[pivot], work[column]
            sign = -sign
        pivot_value = work[column][column]
        for row in range(column + 1, len(work)):
            for target in range(column + 1, len(work)):
                work[row][target] = (
                    work[row][target] * pivot_value
                    - work[row][column] * work[column][target]
                ) // denominator
            work[row][column] = 0
        denominator = pivot_value
    return sign * work[-1][-1]


def permute_word(word: int, permutation: tuple[int, ...]) -> int:
    result = 0
    while word:
        bit = word & -word
        result |= 1 << permutation[bit.bit_length() - 1]
        word ^= bit
    return result


def matrix_vector(rows: list[int], vector: int) -> int:
    return sum(((row & vector).bit_count() % 2) << index for index, row in enumerate(rows))


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    parser.add_argument("--check", type=Path)
    args = parser.parse_args()

    cert = json.loads(ORBIT_CERT.read_text())
    rows = [sum(1 << index for index in neighbors) for neighbors in cert["correspondence"]["left_neighbor_indices"]]
    columns = transpose(rows, N)
    all_ones = (1 << N) - 1

    toric_basis = kernel_basis(rows, N)
    octahedral_basis = kernel_basis(columns, N)
    parity_complement_basis = kernel_basis([row ^ all_ones for row in rows], N)
    assert len(toric_basis) == len(octahedral_basis) == 14
    assert len(parity_complement_basis) == 15

    toric_weights, toric_words = enumerate_code(toric_basis)
    octahedral_weights, _ = enumerate_code(octahedral_basis)
    parity_weights, parity_words = enumerate_code(parity_complement_basis)
    assert min(weight for weight in toric_weights if weight) == 28
    assert all(weight % 4 == 0 for weight in toric_weights)
    assert min(weight for weight in octahedral_weights if weight) == 26
    assert min(weight for weight in parity_weights if weight) == 28
    assert parity_words == toric_words | {all_ones ^ word for word in toric_words}
    toric_minimum_words = [word for word in toric_words if word.bit_count() == 28]
    assert N - len(kernel_basis(toric_minimum_words, N)) == 14
    toric_generator_columns = {
        sum(((vector >> coordinate) & 1) << row for row, vector in enumerate(toric_basis))
        for coordinate in range(N)
    }
    assert len(toric_generator_columns) == N and 0 not in toric_generator_columns

    orbit_tool = load(ORBIT_TOOL, "c682_orbit_correspondence")
    source = orbit_tool.load_source()
    group = tuple(source.projective_group())
    right = orbit_tool.transformed_orbit(source, group, source.REPRESENTATIVES[1])
    right_index = {support: index for index, support in enumerate(right)}
    permutations = [
        tuple(
            right_index[tuple(sorted(source.act_quadratic(element, point) for point in support))]
            for support in right
        )
        for element in group
    ]
    minimum_words = {word for word in parity_words if word.bit_count() == 28}
    seed = min(minimum_words)
    minimum_orbit = {permute_word(seed, permutation) for permutation in permutations}
    stabilizer = [
        element
        for element, permutation in zip(group, permutations)
        if permute_word(seed, permutation) == seed
    ]
    assert minimum_orbit == minimum_words and len(minimum_words) == 78
    assert len(stabilizer) == 28

    integer_rows = [[1 if row >> column & 1 else 0 for column in range(N)] for row in rows]
    gram_minus_identity = [
        [
            sum(integer_rows[row][first] * integer_rows[row][second] for row in range(N))
            - (1 if first == second else 0)
            for second in range(N)
        ]
        for first in range(N)
    ]
    nullities = {
        str(prime): N - rank_mod_prime(gram_minus_identity, prime)
        for prime in (2, 5, 13)
    }
    assert nullities == {"2": 37, "5": 13, "13": 0}
    determinant = abs(bareiss_determinant(gram_minus_identity))
    assert determinant == 671088640000000000000
    assert determinant == 2**39 * 5**13

    complement_rows = [row ^ all_ones for row in rows]
    complement_columns = transpose(complement_rows, N)
    two_step_rows = [
        (1 << index)
        ^ matrix_vector(
            complement_columns, matrix_vector(complement_rows, 1 << index)
        )
        for index in range(N)
    ]
    second_level_basis = kernel_basis(two_step_rows, N)
    assert len(second_level_basis) == 36
    second_level_words = [
        matrix_vector(complement_rows, vector) | (vector << N)
        for vector in second_level_basis
    ]
    frame_cert = json.loads(FRAME_CERT.read_text())
    minimum_shell = [
        sum(int(lane, 16) << (64 * index) for index, lane in enumerate(record["words_le"]))
        for record in frame_cert["low_shell_words"]
        if record["weight"] == 28
    ]
    assert len(minimum_shell) == 78
    assert len(kernel_basis(second_level_words + minimum_shell, 182)) == 146
    assert len(kernel_basis(second_level_words, 182)) == 146

    residual_seed = seed
    residual_counter = Counter()
    shortened_counter = Counter()
    punctured_coordinate_counter = Counter()
    shortened_coordinate_counter = Counter()
    for word in parity_words:
        residual_counter[(word & ~residual_seed).bit_count()] += 1
        if word & residual_seed == 0:
            shortened_counter[word.bit_count()] += 1
        punctured_coordinate_counter[word.bit_count() - (word & 1)] += 1
        if word & 1 == 0:
            shortened_coordinate_counter[word.bit_count()] += 1
    assert residual_counter[0] == 2
    residual_counter = Counter({weight: count // 2 for weight, count in residual_counter.items()})
    assert min(weight for weight in punctured_coordinate_counter if weight) == 27
    assert sum(shortened_coordinate_counter.values()) == 1 << 14
    assert min(weight for weight in shortened_coordinate_counter if weight) == 28

    result = {
        "schema": "c682-paper-iv-project-up-v1",
        "transition_matrix": {"rows": N, "columns": N, "row_weight": 3, "column_weight": 3},
        "toric_kernel": {
            "definition": "ker(C)",
            "parameters": [91, 14, 28],
            "weight_enumerator": weight_enumerator(toric_weights),
        },
        "octahedral_kernel": {
            "definition": "ker(C^T)",
            "parameters": [91, 14, 26],
            "weight_enumerator": weight_enumerator(octahedral_weights),
        },
        "parity_complement_kernel": {
            "definition": "ker(C+J)=ker(C)+<all-ones>",
            "parameters": [91, 15, 28],
            "weight_enumerator": weight_enumerator(parity_weights),
            "minimum_shell_size": len(minimum_words),
            "minimum_shell_orbit_count": 1,
            "minimum_shell_homogeneous_space": "PGL(2,13)/D28",
            "minimum_shell_stabilizer_order": len(stabilizer),
        },
        "descendants": {
            "punctured_parameters": [90, 15, 27],
            "shortened_parameters": [90, 14, 28],
            "minimum_word_residual_parameters": [63, 14, 16],
            "minimum_word_residual_weight_enumerator": weight_enumerator(residual_counter),
            "minimum_word_shortened_word_count": sum(shortened_counter.values()),
        },
        "arithmetic_fibers": {
            "nullity_of_CtC_minus_I": nullities,
            "F169_nullity": 0,
            "explanation": "scalar extension from F13 preserves nullity",
            "absolute_determinant_of_CtC_minus_I": determinant,
            "determinant_factorization": "2^39 * 5^13",
        },
        "iteration_closure": {
            "double_parity_complement_returns_C": True,
            "block_metacode_of_C_plus_J_dimension": 36,
            "block_metacode_equals_minimum_shell_span": True,
            "block_metacode_parameters": [182, 36, 28],
            "conclusion": "same-level iteration closes after removing the constant line",
        },
        "quantum_css": {
            "reason": "ker(C) is doubly even and its dual has distance 3",
            "parameters": [91, 63, 3],
            "stabilizer_generator_weight": 28,
            "dual_weight_three_witness": "a cubic row of C",
        },
        "unrestricted_code_table_context": {
            "parameters": [91, 15],
            "best_known_lower_bound": 36,
            "best_known_upper_bound": 38,
            "url": "https://www.codetables.de/BKLC/BKLC.php?q=2&n=91&k=15",
        },
        "trusted_inputs": [
            "notes/2026-08-04-c682-paper-iv-orbit-correspondence.py",
            "notes/2026-08-04-c682-paper-iv-orbit-correspondence.json",
            "notes/2026-08-04-c682-paper-iv-frame-metacode.json",
            "papers/q13-passant-code/verification/verify_minimum_geometry.py",
        ],
    }
    encoded = json.dumps(result, indent=2, sort_keys=True) + "\n"
    print(encoded, end="")
    if args.output:
        args.output.write_text(encoded)
    if args.check:
        assert args.check.read_text() == encoded


if __name__ == "__main__":
    main()
