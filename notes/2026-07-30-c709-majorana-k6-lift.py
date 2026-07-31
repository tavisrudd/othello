#!/usr/bin/env python3
"""Generate the exact C709 six-Majorana/conference certificate."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
INPUT = ROOT / "notes" / "2026-07-29-c690-rigidity-fingerprints.json"
OUTPUT = ROOT / "notes" / "2026-07-30-c709-majorana-k6-lift.json"


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def dot2(left: int, right: int) -> int:
    return (left & right).bit_count() % 2


ODD_CHARACTERISTICS = tuple(
    (a, b) for a in range(4) for b in range(4) if dot2(a, b)
)


def duad_vector(left: int, right: int) -> int:
    a_left, b_left = ODD_CHARACTERISTICS[left]
    a_right, b_right = ODD_CHARACTERISTICS[right]
    return (b_left ^ b_right) | ((a_left ^ a_right) << 2)


def symplectic(left: int, right: int) -> int:
    x, z = left & 3, left >> 2
    y, t = right & 3, right >> 2
    return dot2(x, t) ^ dot2(z, y)


def pauli_exponent(left: int, right: int) -> int:
    """P(left)P(right)=i^c P(left+right), P(x,z)=i^(x.z)X^x Z^z."""
    x, z = left & 3, left >> 2
    y, t = right & 3, right >> 2
    return (
        (x & z).bit_count()
        + (y & t).bit_count()
        - ((x ^ y) & (z ^ t)).bit_count()
        + 2 * (z & y).bit_count()
    ) % 4


def permutation_sign(sequence: tuple[int, ...]) -> int:
    inversions = sum(
        sequence[i] > sequence[j]
        for i in range(len(sequence))
        for j in range(i + 1, len(sequence))
    )
    return -1 if inversions % 2 else 1


def determinant(matrix: list[list[int]]) -> int:
    if not matrix:
        return 1
    return sum(
        (-1) ** column
        * matrix[0][column]
        * determinant(
            [row[:column] + row[column + 1 :] for row in matrix[1:]]
        )
        for column in range(len(matrix))
    )


def matrix_product(
    left: list[list[int]], right: list[list[int]]
) -> list[list[int]]:
    return [
        [
            sum(left[i][k] * right[k][j] for k in range(len(right)))
            for j in range(len(right[0]))
        ]
        for i in range(len(left))
    ]


def pfaffian(matrix: list[list[int]], indices: tuple[int, ...]) -> int:
    if not indices:
        return 1
    first = indices[0]
    return sum(
        (-1) ** (position + 1)
        * matrix[first][other]
        * pfaffian(
            matrix, indices[1:position] + indices[position + 1 :]
        )
        for position, other in enumerate(indices[1:], 1)
    )


def matchings(vertices: tuple[int, ...]):
    if not vertices:
        yield ()
        return
    first = vertices[0]
    for other in vertices[1:]:
        remainder = tuple(v for v in vertices[1:] if v != other)
        for matching in matchings(remainder):
            yield ((first, other),) + matching


def polynomial_add(left: dict, right: dict) -> dict:
    result = dict(left)
    for monomial, coefficient in right.items():
        result[monomial] = result.get(monomial, 0) + coefficient
        if result[monomial] == 0:
            del result[monomial]
    return result


def polynomial_multiply(left: dict, right: dict) -> dict:
    result = {}
    for a, ca in left.items():
        for b, cb in right.items():
            monomial = tuple(x + y for x, y in zip(a, b))
            result[monomial] = result.get(monomial, 0) + ca * cb
    return {m: c for m, c in result.items() if c}


def polynomial_scale(poly: dict, scalar: int) -> dict:
    return {m: scalar * c for m, c in poly.items() if scalar * c}


def variable(index: int, coefficient: int = 1) -> dict:
    exponent = [0] * 6
    exponent[index] = 1
    return {tuple(exponent): coefficient}


def polynomial_pfaffian(matrix: list[list[dict]], indices: tuple[int, ...]):
    if not indices:
        return {(0,) * 6: 1}
    first = indices[0]
    result = {}
    for position, other in enumerate(indices[1:], 1):
        term = polynomial_multiply(
            matrix[first][other],
            polynomial_pfaffian(
                matrix, indices[1:position] + indices[position + 1 :]
            ),
        )
        result = polynomial_add(
            result, polynomial_scale(term, (-1) ** (position + 1))
        )
    return result


def serialize_polynomial(poly: dict) -> list[dict[str, object]]:
    return [
        {"exponents": list(monomial), "coefficient": coefficient}
        for monomial, coefficient in sorted(poly.items())
    ]


def skew_from_symmetric(matrix: list[list[int]]) -> list[list[int]]:
    return [
        [
            0
            if i == j
            else (matrix[i][j] if i < j else -matrix[i][j])
            for j in range(6)
        ]
        for i in range(6)
    ]


def skew_characteristic_data(matrix: list[list[int]]) -> tuple[int, int, int]:
    q2 = sum(matrix[i][j] ** 2 for i in range(6) for j in range(i + 1, 6))
    q4 = sum(
        pfaffian(matrix, subset) ** 2
        for subset in itertools.combinations(range(6), 4)
    )
    pf = pfaffian(matrix, tuple(range(6)))
    return q2, q4, pf


def build() -> dict[str, object]:
    source = json.loads(INPUT.read_text())
    comparison = source["twelve_point_kill_test"]["paper_I"][
        "direct_c682_axis_lattice_comparison"
    ]
    conference = comparison["c682_conference_matrix"]
    assert matrix_product(conference, conference) == [
        [5 * int(i == j) for j in range(6)] for i in range(6)
    ]

    duads = tuple(itertools.combinations(range(6), 2))
    vector_to_duad = {duad_vector(*duad): duad for duad in duads}
    assert set(vector_to_duad) == set(range(1, 16))
    assert all(
        symplectic(duad_vector(*left), duad_vector(*right))
        == int(len(set(left) & set(right)) == 1)
        for left in duads
        for right in duads
        if left != right
    )

    # Work in the +1 eigenspace of Pi=i gamma_0...gamma_5.  Fix
    # M_0i=i gamma_0 gamma_i -> P(v_0i); triangle multiplication then
    # uniquely determines every remaining sign.
    majorana_pauli_sign = {(0, i): 1 for i in range(1, 6)}
    for i in range(1, 6):
        for j in range(i + 1, 6):
            exponent = pauli_exponent(duad_vector(0, i), duad_vector(0, j))
            majorana_pauli_sign[(i, j)] = 1 if (exponent + 1) % 4 == 0 else -1

    def oriented_sign(i: int, j: int) -> int:
        edge = (min(i, j), max(i, j))
        return majorana_pauli_sign[edge] if i < j else -majorana_pauli_sign[edge]

    triangle_checks = 0
    for a, b, c in itertools.permutations(range(6), 3):
        left = duad_vector(min(a, b), max(a, b))
        right = duad_vector(min(b, c), max(b, c))
        scalar_exponent = pauli_exponent(left, right)
        # M_ab M_bc = i M_ac.
        lhs_over_rhs = (
            oriented_sign(a, b)
            * oriented_sign(b, c)
            * (1j**scalar_exponent)
            / (1j * oriented_sign(a, c))
        )
        assert lhs_over_rhs == 1
        triangle_checks += 1

    matching_checks = []
    for matching in matchings(tuple(range(6))):
        vector = 0
        phase = 1 + 0j
        sequence = ()
        for edge in matching:
            next_vector = duad_vector(*edge)
            phase *= majorana_pauli_sign[edge] * (
                1j ** pauli_exponent(vector, next_vector)
            )
            vector ^= next_vector
            sequence += edge
        assert vector == 0 and phase.imag == 0
        matching_sign = permutation_sign(sequence)
        # Product M_ab over the matching is -sgn(sequence) Pi.
        parity_eigenvalue = int(round((-phase / matching_sign).real))
        assert parity_eigenvalue == 1
        matching_checks.append(
            {
                "matching": [list(edge) for edge in matching],
                "pauli_product": int(round(phase.real)),
                "matching_permutation_sign": matching_sign,
            }
        )

    conference_bit = [0] * 16
    for vector in range(1, 16):
        i, j = vector_to_duad[vector]
        conference_bit[vector] = int(conference[i][j] < 0)
    quadratic_distances = []
    for shift in range(16):
        refinement = [
            dot2(vector & 3, vector >> 2) ^ symplectic(shift, vector)
            for vector in range(16)
        ]
        assert all(
            refinement[u ^ v] ^ refinement[u] ^ refinement[v]
            == symplectic(u, v)
            for u in range(16)
            for v in range(16)
        )
        quadratic_distances.append(
            sum(a != b for a, b in zip(conference_bit, refinement))
        )
    assert sorted(quadratic_distances) == [5] * 6 + [9] * 10

    triples = tuple(itertools.combinations(range(6), 3))
    triangle_sign = {
        triple: conference[triple[0]][triple[1]]
        * conference[triple[1]][triple[2]]
        * conference[triple[2]][triple[0]]
        for triple in triples
    }
    assert sum(sign == 1 for sign in triangle_sign.values()) == 10
    vertex_edge_gauges = {
        tuple(signs[i] * signs[j] for i, j in duads)
        for signs in itertools.product((-1, 1), repeat=6)
    }
    assert len(vertex_edge_gauges) == 32
    all_triangle_fluxes = {
        tuple(
            edge_signs[duads.index((triple[0], triple[1]))]
            * edge_signs[duads.index((triple[0], triple[2]))]
            * edge_signs[duads.index((triple[1], triple[2]))]
            for triple in triples
        )
        for edge_signs in itertools.product((-1, 1), repeat=15)
    }
    assert len(all_triangle_fluxes) == 1024

    # Exact middle-exterior operator K=* Lambda^3 C.
    compound = [
        [
            determinant([[conference[i][j] for j in right] for i in left])
            for right in triples
        ]
        for left in triples
    ]
    triple_index = {triple: index for index, triple in enumerate(triples)}
    middle_operator = [[0] * 20 for _ in range(20)]
    for row_source, triple in enumerate(triples):
        complement = tuple(i for i in range(6) if i not in triple)
        star_sign = permutation_sign(triple + complement)
        row_target = triple_index[complement]
        for column in range(20):
            middle_operator[row_target][column] = (
                star_sign * compound[row_source][column]
            )
    assert matrix_product(middle_operator, middle_operator) == [
        [125 * int(i == j) for j in range(20)] for i in range(20)
    ]
    assert all(
        middle_operator[index][index] == 4 * triangle_sign[triple]
        for index, triple in enumerate(triples)
    )

    # The canonical free-fermion family A(x)=[D_x,C].
    zero = {}
    polynomial_skew = [[zero for _ in range(6)] for _ in range(6)]
    for i in range(6):
        for j in range(6):
            if i != j:
                polynomial_skew[i][j] = polynomial_scale(
                    polynomial_add(variable(i), variable(j, -1)),
                    conference[i][j],
                )
    pfaffian_polynomial = polynomial_pfaffian(
        polynomial_skew, tuple(range(6))
    )
    joubert = {}
    for triple, sign in triangle_sign.items():
        exponent = tuple(int(i in triple) for i in range(6))
        joubert[exponent] = sign
    assert pfaffian_polynomial == polynomial_scale(joubert, 4)

    # The six nodes p_a=1-6e_a are rank-two cross-frame dimers.  Since
    # C/sqrt(5) is orthogonal, \tilde gamma_a=(1/sqrt(5)) sum_j C_aj gamma_j
    # is a second Majorana frame orthogonal to gamma_a at the matching index.
    node_hamiltonians = []
    for axis in range(6):
        x = [1 - 6 * int(i == axis) for i in range(6)]
        skew = [
            [(x[i] - x[j]) * conference[i][j] for j in range(6)]
            for i in range(6)
        ]
        q2, q4, pf = skew_characteristic_data(skew)
        assert (q2, q4, pf) == (180, 0, 0)
        assert all(
            pfaffian(skew, subset) == 0
            for subset in itertools.combinations(range(6), 4)
        )
        node_hamiltonians.append(
            {
                "axis": axis,
                "projective_point": x,
                "rank": 2,
                "characteristic_polynomial": "lambda^4(lambda^2+180)",
                "nonzero_singular_value_squared": 180,
                "dimer": (
                    "H=-3 i sqrt(5) gamma_a tilde_gamma_a; "
                    "tilde_gamma_a=(1/sqrt(5)) sum_j C_aj gamma_j"
                ),
                "zero_majoranas": 4,
            }
        )

    # C A(x)+A(x) C=0 coefficientwise follows from C^2=5I; verify it
    # on each coordinate basis vector to avoid symbolic matrix machinery.
    anticommutator_checks = 0
    for coordinate in range(6):
        x = [int(i == coordinate) for i in range(6)]
        skew = [
            [
                (x[i] - x[j]) * conference[i][j]
                for j in range(6)
            ]
            for i in range(6)
        ]
        ca = matrix_product(conference, skew)
        ac = matrix_product(skew, conference)
        assert all(ca[i][j] + ac[i][j] == 0 for i in range(6) for j in range(6))
        anticommutator_checks += 1

    # A total-order antisymmetrization is not intrinsic: its characteristic
    # polynomial lambda^6+q2 lambda^4+q4 lambda^2+pf^2 has three outcomes.
    ordered_spectrum_classes: dict[tuple[int, int, int], int] = {}
    for permutation in itertools.permutations(range(6)):
        permuted = [
            [conference[permutation[i]][permutation[j]] for j in range(6)]
            for i in range(6)
        ]
        skew = skew_from_symmetric(permuted)
        q2, q4, pf = skew_characteristic_data(skew)
        key = (q2, q4, pf * pf)
        ordered_spectrum_classes[key] = ordered_spectrum_classes.get(key, 0) + 1
    assert ordered_spectrum_classes == {
        (15, 63, 81): 120,
        (15, 63, 49): 240,
        (15, 47, 1): 360,
    }
    base_skew = skew_from_symmetric(conference)
    conference_pfaffian_terms = []
    for matching in matchings(tuple(range(6))):
        sequence = tuple(vertex for edge in matching for vertex in edge)
        term = permutation_sign(sequence)
        for i, j in matching:
            term *= conference[i][j]
        conference_pfaffian_terms.append(
            {"matching": [list(edge) for edge in matching], "sign": term}
        )
    assert sum(record["sign"] for record in conference_pfaffian_terms) == -9
    assert pfaffian(base_skew, tuple(range(6))) == -9

    line_stabilizer = []
    for permutation in itertools.permutations(range(6)):
        ratios = {
            triangle_sign[tuple(sorted(permutation[i] for i in triple))]
            * sign
            for triple, sign in triangle_sign.items()
        }
        if len(ratios) == 1:
            line_stabilizer.append((permutation, next(iter(ratios))))
    assert len(line_stabilizer) == 120
    assert sum(character == 1 for _, character in line_stabilizer) == 60

    return {
        "schema": "c709-majorana-k6-lift-v1",
        "input": {
            "path": str(INPUT.relative_to(ROOT)),
            "sha256": sha256(INPUT),
            "bytes": INPUT.stat().st_size,
        },
        "conventions": {
            "majoranas": "{gamma_i,gamma_j}=2 delta_ij",
            "oriented_bilinear": "M_ij=i gamma_i gamma_j; M_ji=-M_ij",
            "fermion_parity": "Pi=i gamma_0 gamma_1 gamma_2 gamma_3 gamma_4 gamma_5",
            "parity_sector": 1,
            "pauli": "P(x,z)=i^(x dot z) X^x Z^z",
            "quadratic_hamiltonian": "H(A)=(i/4) sum_ij A_ij gamma_i gamma_j",
        },
        "pauli_majorana_dictionary": [
            {
                "duad": list(duad),
                "vector": duad_vector(*duad),
                "binary_xz": format(duad_vector(*duad), "04b"),
                "sign": majorana_pauli_sign[duad],
            }
            for duad in duads
        ],
        "dictionary_checks": {
            "directed_triangle_products": triangle_checks,
            "perfect_matchings": matching_checks,
            "commutation_pairs": len(duads) * (len(duads) - 1),
        },
        "conference": conference,
        "triangle_two_graph": [
            {"triple": list(triple), "sign": triangle_sign[triple]}
            for triple in triples
        ],
        "fermionic_gauge": {
            "edge_signings": 32768,
            "majorana_vertex_gauges": len(vertex_edge_gauges),
            "cycle_flux_classes": len(all_triangle_fluxes),
            "conference_triangle_sign_counts": {"minus": 10, "plus": 10},
            "conference_pfaffian_terms": conference_pfaffian_terms,
        },
        "quadratic_refinement_test": {
            "refinements_tested": 16,
            "hamming_distances": sorted(quadratic_distances),
            "matches": 0,
        },
        "middle_exterior_operator": {
            "dimension": 20,
            "square_scalar": 125,
            "diagonal_over_4": [middle_operator[i][i] // 4 for i in range(20)],
        },
        "commutator_hamiltonian": {
            "couplings": "A_ij(x)=(x_i-x_j)C_ij",
            "golden_anticommutator_zero_basis_checks": anticommutator_checks,
            "pfaffian": serialize_polynomial(pfaffian_polynomial),
            "joubert_cubic": serialize_polynomial(joubert),
            "characteristic_polynomial": (
                "lambda^6+Q2(x)lambda^4+Q4(x)lambda^2+16 Z_C(x)^2; "
                "Q2=sum_{i<j}(x_i-x_j)^2; "
                "Q4=sum_{|S|=4}Pf(A(x)_S)^2"
            ),
            "node_rank_stratification": node_hamiltonians,
        },
        "ordered_constant_hamiltonian_negative": {
            "orders_tested": 720,
            "characteristic_classes": [
                {
                    "multiplicity": multiplicity,
                    "q2": key[0],
                    "q4": key[1],
                    "pfaffian_squared": key[2],
                }
                for key, multiplicity in sorted(ordered_spectrum_classes.items())
            ],
        },
        "symmetry": {
            "signed_two_graph_line_stabilizer_order": len(line_stabilizer),
            "orientation_preserving_A5_order": sum(
                character == 1 for _, character in line_stabilizer
            ),
            "orientation_reversing_coset_size": sum(
                character == -1 for _, character in line_stabilizer
            ),
        },
    }


def canonical_bytes(data: dict[str, object]) -> bytes:
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    rendered = canonical_bytes(build())
    if args.check:
        with tempfile.TemporaryDirectory() as directory:
            candidate = Path(directory) / OUTPUT.name
            candidate.write_bytes(rendered)
            assert candidate.read_bytes() == OUTPUT.read_bytes()
        print(f"ok: {OUTPUT.name} is canonical")
    else:
        OUTPUT.write_bytes(rendered)
        print(f"wrote {OUTPUT}")


if __name__ == "__main__":
    main()
