#!/usr/bin/env python3
"""Exact local-Clifford test for the Clebsch AME(6,11) stabilizer state."""

from __future__ import annotations

import argparse
import collections
import hashlib
import itertools
import json
from pathlib import Path
from typing import Iterable, Sequence


Q = 11
N = 6
HERE = Path(__file__).resolve().parent
OUTPUT = HERE / "2026-07-19-clebsch-ame-equivalence.json"

Vector = tuple[int, ...]
Matrix = tuple[Vector, ...]
Matrix2 = tuple[tuple[int, int], tuple[int, int]]


def inv(a: int) -> int:
    if a % Q == 0:
        raise ZeroDivisionError("zero has no inverse")
    return pow(a % Q, Q - 2, Q)


def rref(rows: Iterable[Sequence[int]]) -> tuple[Matrix, tuple[int, ...]]:
    a = [[x % Q for x in row] for row in rows]
    if not a:
        return (), ()
    width = len(a[0])
    pivot_row = 0
    pivots: list[int] = []
    for col in range(width):
        pivot = next((i for i in range(pivot_row, len(a)) if a[i][col]), None)
        if pivot is None:
            continue
        a[pivot_row], a[pivot] = a[pivot], a[pivot_row]
        scale = inv(a[pivot_row][col])
        a[pivot_row] = [(scale * x) % Q for x in a[pivot_row]]
        for i in range(len(a)):
            if i == pivot_row or a[i][col] == 0:
                continue
            scale = a[i][col]
            a[i] = [(x - scale * y) % Q for x, y in zip(a[i], a[pivot_row])]
        pivots.append(col)
        pivot_row += 1
        if pivot_row == len(a):
            break
    nonzero = [tuple(row) for row in a if any(row)]
    return tuple(nonzero), tuple(pivots)


def nullspace(rows: Iterable[Sequence[int]], width: int | None = None) -> Matrix:
    raw = tuple(tuple(row) for row in rows)
    if raw:
        width = len(raw[0])
    if width is None:
        raise ValueError("width is required for an empty matrix")
    reduced, pivots = rref(raw)
    free = [j for j in range(width) if j not in pivots]
    basis: list[Vector] = []
    for free_col in free:
        v = [0] * width
        v[free_col] = 1
        for i, pivot_col in enumerate(pivots):
            v[pivot_col] = (-reduced[i][free_col]) % Q
        basis.append(tuple(v))
    return tuple(basis)


def rowspace(rows: Iterable[Sequence[int]]) -> Matrix:
    return rref(rows)[0]


def matmul_row(v: Sequence[int], rows: Matrix) -> Vector:
    return tuple(sum(v[i] * rows[i][j] for i in range(len(rows))) % Q for j in range(len(rows[0])))


def canonical_projective(v: Sequence[int]) -> Vector:
    first = next(x for x in v if x % Q)
    scale = inv(first)
    return tuple(scale * x % Q for x in v)


def dual(code: Matrix) -> Matrix:
    return nullspace(code)


def clebsch_code() -> Matrix:
    tau = 8
    columns = (
        (0, 1, 1 - tau),
        (0, 1, tau - 1),
        (1, 1 - tau, 0),
        (1, tau - 1, 0),
        (1, 0, -tau),
        (1, 0, tau),
    )
    parity_check = tuple(tuple(columns[j][i] % Q for j in range(N)) for i in range(3))
    return nullspace(parity_check)


def standard_extended_rs_code() -> Matrix:
    """The [6,3,4]_11 extended GRS code at 0,1,2,3,4,infinity."""
    points = (0, 1, 2, 3, 4)
    columns = tuple((1, x, x * x % Q) for x in points) + ((0, 0, 1),)
    return tuple(tuple(columns[j][i] for j in range(N)) for i in range(3))


def grs_code(evaluation_set: tuple[int, ...]) -> Matrix:
    """Unweighted dimension-three GRS code; Q denotes the point at infinity."""
    columns = tuple((0, 0, 1) if x == Q else (1, x, x * x % Q) for x in evaluation_set)
    return tuple(tuple(columns[j][i] for j in range(N)) for i in range(3))


def mobius_image(matrix: tuple[int, int, int, int], x: int) -> int:
    a, b, c, d = matrix
    if x == Q:
        return Q if c == 0 else a * inv(c) % Q
    denominator = (c * x + d) % Q
    return Q if denominator == 0 else (a * x + b) * inv(denominator) % Q


def pgl2_permutations() -> tuple[tuple[int, ...], ...]:
    normalized: set[tuple[int, int, int, int]] = set()
    for matrix in itertools.product(range(Q), repeat=4):
        a, b, c, d = matrix
        if (a * d - b * c) % Q == 0:
            continue
        first = next(x for x in matrix if x)
        scale = inv(first)
        normalized.add(tuple(scale * x % Q for x in matrix))  # type: ignore[arg-type]
    permutations = {tuple(mobius_image(matrix, x) for x in range(Q + 1)) for matrix in normalized}
    if len(permutations) != Q * (Q * Q - 1):
        raise AssertionError("incorrect PGL(2,11) order")
    return tuple(sorted(permutations))


def grs_evaluation_orbits() -> tuple[tuple[tuple[int, ...], int], ...]:
    permutations = pgl2_permutations()
    remaining = set(itertools.combinations(range(Q + 1), N))
    result: list[tuple[tuple[int, ...], int]] = []
    while remaining:
        representative = min(remaining)
        orbit = {tuple(sorted(permutation[x] for x in representative)) for permutation in permutations}
        remaining -= orbit
        result.append((representative, len(orbit)))
    if sum(size for _, size in result) != 924:
        raise AssertionError("PGL(2,11) evaluation-set orbits do not cover all 6-subsets")
    return tuple(result)


def minimum_distance(code: Matrix) -> int:
    best = N + 1
    for coeff in itertools.product(range(Q), repeat=len(code)):
        if not any(coeff):
            continue
        word = matmul_row(coeff, code)
        best = min(best, sum(x != 0 for x in word))
    return best


def shortened_word(code: Matrix, omitted: tuple[int, int]) -> Vector:
    equations = tuple(tuple(code[r][i] for r in range(len(code))) for i in omitted)
    coeffs = nullspace(equations)
    if len(coeffs) != 1:
        raise AssertionError(f"shortening at {omitted} has dimension {len(coeffs)}, expected 1")
    word = canonical_projective(matmul_row(coeffs[0], code))
    support = tuple(i for i, x in enumerate(word) if x)
    expected = tuple(i for i in range(N) if i not in omitted)
    if support != expected:
        raise AssertionError(f"shortened word has support {support}, expected {expected}")
    return word


def minimal_support_data(code: Matrix) -> dict[tuple[int, ...], tuple[Vector, Vector]]:
    code_dual = dual(code)
    result: dict[tuple[int, ...], tuple[Vector, Vector]] = {}
    for omitted in itertools.combinations(range(N), 2):
        support = tuple(i for i in range(N) if i not in omitted)
        result[support] = (shortened_word(code, omitted), shortened_word(code_dual, omitted))
    return result


def m2_mul(a: Matrix2, b: Matrix2) -> Matrix2:
    return (
        ((a[0][0] * b[0][0] + a[0][1] * b[1][0]) % Q,
         (a[0][0] * b[0][1] + a[0][1] * b[1][1]) % Q),
        ((a[1][0] * b[0][0] + a[1][1] * b[1][0]) % Q,
         (a[1][0] * b[0][1] + a[1][1] * b[1][1]) % Q),
    )


def m2_det(a: Matrix2) -> int:
    return (a[0][0] * a[1][1] - a[0][1] * a[1][0]) % Q


def m2_inv(a: Matrix2) -> Matrix2:
    scale = inv(m2_det(a))
    return (
        ((scale * a[1][1]) % Q, (-scale * a[0][1]) % Q),
        ((-scale * a[1][0]) % Q, (scale * a[0][0]) % Q),
    )


def relation(data: dict[tuple[int, ...], tuple[Vector, Vector]], support: tuple[int, ...], a: int, b: int) -> Matrix2:
    xword, zword = data[support]
    return ((xword[b] * inv(xword[a]) % Q, 0), (0, zword[b] * inv(zword[a]) % Q))


def minimal_support_cycle_signature(code: Matrix) -> tuple[tuple[tuple[int, int], int], ...]:
    """Trace/determinant multiset of length-two support holonomies.

    A four-party minimal stabilizer projects isomorphically onto each supported
    party's two-dimensional Pauli-label space.  Moving from party a to b through
    one support and back through another gives an endomorphism at a.  Local
    symplectic changes conjugate it, so trace and determinant are LC invariants.
    """
    data = minimal_support_data(code)
    signature: list[tuple[int, int]] = []
    for a, b in itertools.combinations(range(N), 2):
        supports = [support for support in sorted(data) if a in support and b in support]
        if len(supports) != 6:
            raise AssertionError("unexpected number of four-party supports through a party pair")
        for first, second in itertools.combinations(supports, 2):
            holonomy = m2_mul(relation(data, second, b, a), relation(data, first, a, b))
            reverse = m2_inv(holonomy)
            signature.append(((holonomy[0][0] + holonomy[1][1]) % Q, m2_det(holonomy)))
            signature.append(((reverse[0][0] + reverse[1][1]) % Q, m2_det(reverse)))
    if len(signature) != 450:
        raise AssertionError("unexpected cycle-signature length")
    return tuple(sorted(collections.Counter(signature).items()))


def signature_json(signature: tuple[tuple[tuple[int, int], int], ...]) -> list[dict[str, int]]:
    return [
        {"trace": trace, "determinant": determinant, "multiplicity": multiplicity}
        for (trace, determinant), multiplicity in signature
    ]


def minimal_support_cycle_signature_from_lagrangian(code: Matrix) -> tuple[tuple[tuple[int, int], int], ...]:
    """Independent replay using only the six-dimensional stabilizer row space."""
    stabilizer = stabilizer_space(code)
    support_projections: dict[tuple[int, ...], dict[int, Matrix2]] = {}
    for omitted in itertools.combinations(range(N), 2):
        support = tuple(i for i in range(N) if i not in omitted)
        equations = tuple(
            tuple(stabilizer[r][coordinate] for r in range(N))
            for party in omitted
            for coordinate in (party, N + party)
        )
        coefficients = nullspace(equations)
        if len(coefficients) != 2:
            raise AssertionError("four-party Lagrangian shortening is not two-dimensional")
        shortened = tuple(matmul_row(coefficient, stabilizer) for coefficient in coefficients)
        projections: dict[int, Matrix2] = {}
        for party in support:
            projection = (
                (shortened[0][party], shortened[1][party]),
                (shortened[0][N + party], shortened[1][N + party]),
            )
            if m2_det(projection) == 0:
                raise AssertionError("minimal stabilizer projection is singular")
            projections[party] = projection
        support_projections[support] = projections

    signature: list[tuple[int, int]] = []
    for a, b in itertools.combinations(range(N), 2):
        supports = [support for support in sorted(support_projections) if a in support and b in support]
        for first, second in itertools.combinations(supports, 2):
            first_map = m2_mul(support_projections[first][b], m2_inv(support_projections[first][a]))
            second_map = m2_mul(support_projections[second][a], m2_inv(support_projections[second][b]))
            holonomy = m2_mul(second_map, first_map)
            reverse = m2_inv(holonomy)
            signature.append(((holonomy[0][0] + holonomy[1][1]) % Q, m2_det(holonomy)))
            signature.append(((reverse[0][0] + reverse[1][1]) % Q, m2_det(reverse)))
    return tuple(sorted(collections.Counter(signature).items()))


def marginal_triple_moment_distribution(code: Matrix) -> tuple[tuple[int, int], ...]:
    """Ranks controlling Tr(rho_T rho_U rho_V) for four-party marginals.

    Here each reduced density matrix is embedded back into all six parties by
    tensoring with identity.  If K_T is the stabilizer-label subspace supported
    in T, then the moment for three four-subsets is Q^(-rank(K_T+K_U+K_V)).
    """
    stabilizer = stabilizer_space(code)
    shortenings: list[Matrix] = []
    for omitted in itertools.combinations(range(N), 2):
        equations = tuple(
            tuple(stabilizer[r][coordinate] for r in range(N))
            for party in omitted
            for coordinate in (party, N + party)
        )
        coefficients = nullspace(equations)
        if len(coefficients) != 2:
            raise AssertionError("four-party stabilizer shortening is not two-dimensional")
        shortenings.append(coefficients)
    ranks = collections.Counter(
        len(rowspace(row for index in triple for row in shortenings[index]))
        for triple in itertools.combinations(range(len(shortenings)), 3)
    )
    if sum(ranks.values()) != 455:
        raise AssertionError("unexpected number of four-party marginal triples")
    return tuple(sorted(ranks.items()))


def moment_json(distribution: tuple[tuple[int, int], ...]) -> list[dict[str, int | str]]:
    return [
        {"sum_rank": rank, "moment": f"11^-{rank}", "triple_count": count}
        for rank, count in distribution
    ]


def sl2() -> tuple[Matrix2, ...]:
    return tuple(
        ((a, b), (c, d))
        for a, b, c, d in itertools.product(range(Q), repeat=4)
        if (a * d - b * c) % Q == 1
    )


def stabilizer_space(code: Matrix) -> Matrix:
    zcode = dual(code)
    rows = [tuple(row) + (0,) * N for row in code]
    rows += [(0,) * N + tuple(row) for row in zcode]
    return rowspace(rows)


def transform_stabilizer(space: Matrix, permutation: tuple[int, ...], local: tuple[Matrix2, ...]) -> Matrix:
    transformed: list[Vector] = []
    for row in space:
        out_x = [0] * N
        out_z = [0] * N
        for source in range(N):
            target = permutation[source]
            block = local[source]
            x, z = row[source], row[N + source]
            out_x[target] = (block[0][0] * x + block[0][1] * z) % Q
            out_z[target] = (block[1][0] * x + block[1][1] * z) % Q
        transformed.append(tuple(out_x + out_z))
    return rowspace(transformed)


def local_clifford_map(source: Matrix, target: Matrix) -> tuple[dict[str, object] | None, dict[str, int]]:
    source_data = minimal_support_data(source)
    target_data = minimal_support_data(target)
    source_space = stabilizer_space(source)
    target_space = stabilizer_space(target)
    all_sl2 = sl2()
    permutations_checked = 0
    anchor_blocks_checked = 0
    relation_consistent = 0

    supports_by_pair: dict[tuple[int, int], tuple[int, ...]] = {}
    for a in range(N):
        for b in range(a + 1, N):
            supports_by_pair[(a, b)] = next(s for s in sorted(source_data) if a in s and b in s)

    for permutation in itertools.permutations(range(N)):
        permutations_checked += 1
        for anchor_block in all_sl2:
            anchor_blocks_checked += 1
            local: list[Matrix2] = [((1, 0), (0, 1)) for _ in range(N)]
            local[0] = anchor_block
            valid = True
            for b in range(1, N):
                support = supports_by_pair[(0, b)]
                target_support = tuple(sorted(permutation[i] for i in support))
                source_rel = relation(source_data, support, 0, b)
                target_rel = relation(target_data, target_support, permutation[0], permutation[b])
                local[b] = m2_mul(m2_mul(target_rel, anchor_block), m2_inv(source_rel))
                if m2_det(local[b]) != 1:
                    valid = False
                    break
            if not valid:
                continue
            for support in sorted(source_data):
                a = support[0]
                target_support = tuple(sorted(permutation[i] for i in support))
                for b in support[1:]:
                    lhs = m2_mul(local[b], relation(source_data, support, a, b))
                    rhs = m2_mul(relation(target_data, target_support, permutation[a], permutation[b]), local[a])
                    if lhs != rhs:
                        valid = False
                        break
                if not valid:
                    break
            if not valid:
                continue
            relation_consistent += 1
            local_tuple = tuple(local)
            if transform_stabilizer(source_space, permutation, local_tuple) != target_space:
                raise AssertionError("minimal-support relations passed but full stabilizer spaces differ")
            return (
                {
                    "party_permutation_source_to_target": list(permutation),
                    "local_symplectic_blocks_source_to_target": [[list(row) for row in block] for block in local_tuple],
                },
                {
                    "permutations_checked": permutations_checked,
                    "anchor_sl2_blocks_checked": anchor_blocks_checked,
                    "relation_consistent_candidates": relation_consistent,
                    "sl2_order": len(all_sl2),
                },
            )
    return (
        None,
        {
            "permutations_checked": permutations_checked,
            "anchor_sl2_blocks_checked": anchor_blocks_checked,
            "relation_consistent_candidates": relation_consistent,
            "sl2_order": len(all_sl2),
        },
    )


def matrix_json(matrix: Matrix) -> list[list[int]]:
    return [list(row) for row in matrix]


def build_certificate() -> dict[str, object]:
    clebsch = rowspace(clebsch_code())
    rs = rowspace(standard_extended_rs_code())
    result, counts = local_clifford_map(clebsch, rs)
    clebsch_signature = minimal_support_cycle_signature(clebsch)
    grs_orbits = grs_evaluation_orbits()
    grs_results: list[dict[str, object]] = []
    for representative, orbit_size in grs_orbits:
        code = rowspace(grs_code(representative))
        signature = minimal_support_cycle_signature(code)
        grs_results.append(
            {
                "evaluation_set": ["infinity" if x == Q else x for x in representative],
                "pgl2_orbit_size": orbit_size,
                "cycle_signature": signature_json(signature),
                "matches_clebsch_cycle_signature": signature == clebsch_signature,
            }
        )
    independent_clebsch_signature = minimal_support_cycle_signature_from_lagrangian(clebsch)
    if independent_clebsch_signature != clebsch_signature:
        raise AssertionError("independent Clebsch cycle signature disagrees")
    direct_grs_signatures: set[tuple[tuple[tuple[int, int], int], ...]] = set()
    direct_matches = 0
    for evaluation_set in itertools.combinations(range(Q + 1), N):
        signature = minimal_support_cycle_signature_from_lagrangian(rowspace(grs_code(evaluation_set)))
        direct_grs_signatures.add(signature)
        direct_matches += signature == independent_clebsch_signature
    clebsch_moments = marginal_triple_moment_distribution(clebsch)
    grs_moment_results: list[dict[str, object]] = []
    for representative, orbit_size in grs_orbits:
        distribution = marginal_triple_moment_distribution(rowspace(grs_code(representative)))
        grs_moment_results.append(
            {
                "evaluation_set": ["infinity" if x == Q else x for x in representative],
                "pgl2_orbit_size": orbit_size,
                "moment_distribution": moment_json(distribution),
                "matches_clebsch": distribution == clebsch_moments,
            }
        )
    direct_moment_census: collections.Counter[tuple[tuple[int, int], ...]] = collections.Counter()
    for evaluation_set in itertools.combinations(range(Q + 1), N):
        distribution = marginal_triple_moment_distribution(rowspace(grs_code(evaluation_set)))
        direct_moment_census[distribution] += 1
    return {
        "schema": "clebsch_ame-clebsch-ame-equivalence-v1",
        "field": "F_11",
        "pauli_convention": "X(a)|x>=|x+a>; Z(b)|x>=omega^(b*x)|x>",
        "state_convention": "|Psi_C>=11^(-3/2) sum_{c in C}|c>; labels ordered (x_0,...,x_5|z_0,...,z_5)",
        "clebsch": {
            "tau": 8,
            "code_rref": matrix_json(clebsch),
            "dual_rref": matrix_json(dual(clebsch)),
            "minimum_distance": minimum_distance(clebsch),
            "dual_minimum_distance": minimum_distance(dual(clebsch)),
            "stabilizer_rref": matrix_json(stabilizer_space(clebsch)),
        },
        "standard_extended_rs": {
            "evaluation_points": [0, 1, 2, 3, 4, "infinity"],
            "code_rref": matrix_json(rs),
            "dual_rref": matrix_json(dual(rs)),
            "minimum_distance": minimum_distance(rs),
            "dual_minimum_distance": minimum_distance(dual(rs)),
            "stabilizer_rref": matrix_json(stabilizer_space(rs)),
        },
        "local_clifford_test": {
            "allows_party_permutation": True,
            "complete_reason": "Each four-party support has a two-dimensional stabilizer projection invertible at every supported party; a permutation and one local SL(2,11) block force the other five, after which all support relations and the full row space are checked.",
            "equivalent": result is not None,
            "map": result,
            "counts": counts,
        },
        "all_grs_obstruction": {
            "pgl2_order": len(pgl2_permutations()),
            "evaluation_sets_checked_via_orbits": 924,
            "evaluation_set_orbits": len(grs_results),
            "clebsch_cycle_signature": signature_json(clebsch_signature),
            "grs_orbit_results": grs_results,
            "all_signatures_differ": all(not item["matches_clebsch_cycle_signature"] for item in grs_results),
            "multiplier_boundary": "Nonzero GRS column multipliers are local computational-basis scalings and hence local Clifford; no multiplier enumeration is needed.",
            "invariant_reason": "Four-party minimal stabilizer projections define party-to-party maps. A two-support cycle is conjugated at its base party by LC; recording trace/determinant for both orientations H and H^(-1) makes the multiset invariant under LC and party permutation.",
            "independent_lagrangian_replay": {
                "construction": "Recompute every four-party shortening directly inside the 6-dimensional Lagrangian stabilizer row space, project its 2-dimensional kernel to each party, and form the same holonomies without using the CSS code/dual decomposition.",
                "grs_evaluation_sets_checked_individually": 924,
                "distinct_grs_cycle_signatures": len(direct_grs_signatures),
                "clebsch_signature_matches": direct_matches,
                "agrees_with_css_signature": independent_clebsch_signature == clebsch_signature,
            },
        },
        "general_local_unitary_obstruction": {
            "invariant": "Multiset of Tr((rho_T tensor I)(rho_U tensor I)(rho_V tensor I)) over the 455 unordered triples of four-party subsets.",
            "invariant_reason": "Party-local unitaries conjugate every identity-extended marginal by the same global product unitary, and party permutations only permute the 15 marginals. For a stabilizer state the moment is 11^(-rank(K_T+K_U+K_V)), where K_T is the stabilizer-label subspace supported in T.",
            "clebsch_moment_distribution": moment_json(clebsch_moments),
            "grs_orbit_results": grs_moment_results,
            "all_grs_orbits_differ": all(not item["matches_clebsch"] for item in grs_moment_results),
            "independent_all_evaluation_set_sweep": {
                "grs_evaluation_sets_checked_individually": sum(direct_moment_census.values()),
                "distinct_moment_distributions": len(direct_moment_census),
                "clebsch_distribution_matches": direct_moment_census.get(clebsch_moments, 0),
                "distribution_multiplicities": [
                    {"moment_distribution": moment_json(distribution), "evaluation_set_count": count}
                    for distribution, count in sorted(direct_moment_census.items())
                ],
            },
            "scope": "Separates the Clebsch stabilizer state from every six-point generalized Reed--Solomon minimal-support AME state over F_11, allowing party permutation. It is not a classification against arbitrary non-GRS AME states.",
        },
    }


def canonical_bytes(certificate: dict[str, object]) -> bytes:
    return (json.dumps(certificate, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true", help="regenerate in memory and compare with the tracked certificate")
    args = parser.parse_args()
    certificate = build_certificate()
    payload = canonical_bytes(certificate)
    if args.check:
        expected = OUTPUT.read_bytes()
        if payload != expected:
            raise SystemExit(f"certificate mismatch: generated sha256={hashlib.sha256(payload).hexdigest()}")
        print(f"ok: {OUTPUT.name} ({len(payload)} bytes, sha256 {hashlib.sha256(payload).hexdigest()})")
    else:
        OUTPUT.write_bytes(payload)
        print(f"wrote {OUTPUT.name} ({len(payload)} bytes, sha256 {hashlib.sha256(payload).hexdigest()})")


if __name__ == "__main__":
    main()
