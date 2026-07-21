#!/usr/bin/env python3
"""Generate and check the exact q=11 rank-eight Fourier/fusion certificate.

The certificate reconstructs the reduced projective icosahedral orbits on ``F_11^3``,
their Fourier and hyperplane-count tables, the complete intersection and Krein tensors,
the additive-subgroup test for all relation unions, and the Bannai--Muzychuk test for all
877 partitions of the seven nonidentity relations. Its geometric interpretation is an
exact external computation; this checker does not turn those semantics into Lean
theorems.
"""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import itertools
import json
import sys
from fractions import Fraction
from pathlib import Path

ROOT = Path(__file__).resolve().parent
OUTPUT = ROOT / "scheme_certificate.json"
ORBIT_PATH = ROOT / "orbit_construction.py"
ORBIT_SHA256 = "1ea02f4a27c59a24c780d6bc6ed3eb249de829fa9f55759ddb4cf73e32d51e32"


def load_orbit_construction():
    assert hashlib.sha256(ORBIT_PATH.read_bytes()).hexdigest() == ORBIT_SHA256
    spec = importlib.util.spec_from_file_location("clebsch_orbit_construction", ORBIT_PATH)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


def inverse(matrix: list[list[int]]) -> list[list[Fraction]]:
    n = len(matrix)
    work = [list(map(Fraction, row)) + [Fraction(i == j) for j in range(n)] for i, row in enumerate(matrix)]
    for column in range(n):
        pivot = next(row for row in range(column, n) if work[row][column])
        work[column], work[pivot] = work[pivot], work[column]
        scale = work[column][column]
        work[column] = [value / scale for value in work[column]]
        for row in range(n):
            if row != column:
                scale = work[row][column]
                work[row] = [a - scale * b for a, b in zip(work[row], work[column])]
    return [row[n:] for row in work]


def set_partitions(items: tuple[int, ...]):
    """Canonical set partitions, with blocks and entries increasingly ordered."""
    if not items:
        yield []
        return
    first, rest = items[0], items[1:]
    for partition in set_partitions(rest):
        yield [[first]] + [block[:] for block in partition]
        for index in range(len(partition)):
            yield [
                ([first] + block if position == index else block[:])
                for position, block in enumerate(partition)
            ]


def fusion_schemes(p_matrix: list[list[int]]) -> list[dict[str, object]]:
    answer = []
    partitions = list(set_partitions(tuple(range(1, 8))))
    assert len(partitions) == 877
    for nontrivial in partitions:
        relation_blocks = [[0]] + nontrivial
        signatures = [tuple(sum(p_matrix[row][column] for column in block) for block in relation_blocks)
                      for row in range(8)]
        signature_blocks: dict[tuple[int, ...], list[int]] = {}
        for row, signature in enumerate(signatures):
            signature_blocks.setdefault(signature, []).append(row)
        if len(signature_blocks) != len(relation_blocks):
            continue
        idempotent_blocks = sorted(signature_blocks.values(), key=lambda block: (0 not in block, block))
        assert idempotent_blocks[0] == [0]
        answer.append({
            "rank": len(relation_blocks),
            "relation_blocks": relation_blocks,
            "idempotent_blocks": idempotent_blocks,
        })
    return sorted(answer, key=lambda item: (item["rank"], item["relation_blocks"]))


def certificate() -> dict[str, object]:
    construction = load_orbit_construction()
    q, tau = 11, 8
    roots = construction.h3_roots(q, tau)
    columns = construction.six_points(q, tau)
    group = construction.reflection_group(q, roots)
    labelled = construction.label_orbits(
        construction.vector_orbits(group, q), roots, columns, q
    )
    labels = [label for label, _ in labelled]
    classes = [orbit for _, orbit in labelled]
    class_of = {vector: index for index, orbit in enumerate(classes) for vector in orbit}

    # The reflection matrices are orthogonal for the reduced H3 dot product.
    identity = ((1, 0, 0), (0, 1, 0), (0, 0, 1))
    gram_matrices = [construction.mat_mul(tuple(zip(*matrix)), matrix, q) for matrix in group]
    assert all(
        all(gram[i][j] == (gram[0][0] if i == j else 0) for i in range(3) for j in range(3))
        for gram in gram_matrices
    )

    # The dot product identifies V with V*: contragredient action sends scalar*g
    # to scalar^{-1}*g, so the dual and primal orbit partitions coincide exactly.
    representatives = [min(orbit) for orbit in classes]
    quadratic_types = []
    squares = {value * value % q for value in range(1, q)}
    for representative in representatives:
        norm = construction.dot(representative, representative, q)
        quadratic_types.append("zero_vector" if representative == (0, 0, 0)
                               else "isotropic" if norm == 0
                               else "square" if norm in squares else "nonsquare")
    fourier = []
    hyperplane_line_counts = []
    for character in representatives:
        fourier_row = []
        count_row = []
        for relation in classes:
            if relation == {(0, 0, 0)}:
                fourier_row.append(1)
                count_row.append(1)
                continue
            projective_lines = {construction.normalize(vector, q) for vector in relation}
            zero_lines = sum(
                construction.dot(character, line, q) == 0 for line in projective_lines
            )
            # Sum_{a != 0} zeta^(a t) is q-1 for t=0 and -1 otherwise.
            fourier_row.append(q * zero_lines - len(projective_lines))
            count_row.append(zero_lines)
        fourier.append(fourier_row)
        hyperplane_line_counts.append(count_row)

    n = q ** 3
    q_matrix_fraction = [[n * value for value in row] for row in inverse(fourier)]
    assert all(value.denominator == 1 for row in q_matrix_fraction for value in row)
    q_matrix = [[int(value) for value in row] for row in q_matrix_fraction]
    valencies = [len(orbit) for orbit in classes]
    multiplicities = q_matrix[0]
    assert multiplicities == valencies
    assert q_matrix == fourier
    assert all(sum(fourier[i][k] * q_matrix[k][j] for k in range(8)) == n * (i == j)
               for i in range(8) for j in range(8))

    primal_tensor = construction.intersection_tensor(classes, q)
    construction.check_tensor(primal_tensor, valencies)
    # Independent Bose--Mesner replay: the Fourier rows simultaneously diagonalize
    # every multiplication matrix recovered from the exhaustive intersection tensor.
    assert all(
        sum(primal_tensor[k][i][j] * fourier[row][k] for k in range(8))
        == fourier[row][i] * fourier[row][j]
        for row, i, j in itertools.product(range(8), repeat=3)
    )
    # Recover Krein parameters independently from P and Q, rather than assuming
    # that translation self-duality makes them equal to the intersection numbers.
    dual_tensor = []
    for k in range(8):
        matrix = []
        for i in range(8):
            row = []
            for j in range(8):
                value = Fraction(sum(fourier[k][a] * q_matrix[a][i] * q_matrix[a][j]
                                     for a in range(8)), n)
                assert value.denominator == 1 and value >= 0
                row.append(int(value))
            matrix.append(row)
        dual_tensor.append(matrix)
    assert dual_tensor == primal_tensor

    imprimitivity_subsets = []
    zero = (0, 0, 0)
    for mask in range(1 << 7):
        chosen = {0} | {index + 1 for index in range(7) if mask >> index & 1}
        union = set().union(*(classes[index] for index in chosen))
        if all(tuple((x[d] + y[d]) % q for d in range(3)) in union for x in union for y in union):
            imprimitivity_subsets.append(sorted(chosen))
    assert imprimitivity_subsets == [[0], list(range(8))]

    fusions = fusion_schemes(fourier)
    assert any(item["rank"] == 2 for item in fusions)
    assert any(item["rank"] == 8 for item in fusions)

    return {
        "schema": "clebsch-scheme-fourier-certificate-v1",
        "field": 11,
        "order": n,
        "bilinear_form_matrix": [list(row) for row in identity],
        "relation_labels": labels,
        "valencies": valencies,
        "dual_orbit_labels_under_dot_product": labels,
        "quadratic_type_by_relation": quadratic_types,
        "hyperplane_projective_line_counts": hyperplane_line_counts,
        "first_eigenmatrix_P": fourier,
        "second_eigenmatrix_Q": q_matrix,
        "multiplicities": multiplicities,
        "formal_self_dual_same_ordering": True,
        "fourier_self_dual_same_orbit_partition": True,
        "krein_matrices_by_target_idempotent": dual_tensor,
        "krein_equals_intersection_tensor_same_ordering": True,
        "imprimitivity_relation_unions": imprimitivity_subsets,
        "primitive": True,
        "set_partitions_tested": 877,
        "admissible_fusion_count_including_rank_2_and_rank_8": len(fusions),
        "admissible_fusions": fusions,
        "trusted_input": {
            "orbit_construction": ORBIT_PATH.name,
            "orbit_construction_sha256": ORBIT_SHA256,
        },
    }


def canonical_bytes(data: dict[str, object]) -> bytes:
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    data = canonical_bytes(certificate())
    if args.write:
        OUTPUT.write_bytes(data)
    if args.check:
        assert OUTPUT.read_bytes() == data
    if not args.write and not args.check:
        print(data.decode(), end="")
    print(f"sha256={hashlib.sha256(data).hexdigest()} bytes={len(data)}")


if __name__ == "__main__":
    main()
