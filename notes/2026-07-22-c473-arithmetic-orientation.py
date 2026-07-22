#!/usr/bin/env python3
"""Generate the exact C473 arithmetic-orientation certificate."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from collections import deque
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
NOTES = ROOT / "notes"
OUT = NOTES / "2026-07-22-c473-arithmetic-orientation.json"
INPUT_HASHES = {
    "notes/2026-07-20-c406-matching-orbit-scout.json":
        "fec533bb91f864100ebf5875952244d9d9e03ed69a0abda767360907a55bb246",
    "notes/2026-07-21-c450-weil-cross-sheet.json":
        "a6fc2d854732011c82b6b5c1440b407b64041bd31f4bac59adec15c1f127353f",
    "notes/2026-07-21-c465-mod3-weil-golay.json":
        "62dc3855782f570699d534907a91028523d393863a8b45189782a13a44614958",
    "notes/2026-07-22-c471-hadamard-degeneration-complex.json":
        "3676e3b8b1c7c92f9c74b80c90b572d3322c73a2509cd96b5718e769fb0e5a15",
    "notes/2026-07-22-c472-signed-weil-lift.json":
        "9865949a2a8b93c0f6c674b2d16a826bd9ff706b4798b67033575d7cbc8b9cf2",
}


def verify_inputs():
    result = {}
    for name, expected in INPUT_HASHES.items():
        data = (ROOT / name).read_bytes()
        actual = hashlib.sha256(data).hexdigest()
        if actual != expected:
            raise RuntimeError(f"input hash drift for {name}")
        result[name] = {"bytes": len(data), "sha256": actual}
    return result


def normalize_matrix(values, q):
    values = tuple(x % q for x in values)
    inverse = pow(next(x for x in values if x), -1, q)
    return tuple(x * inverse % q for x in values)


def determinant(g, q):
    return (g[0] * g[3] - g[1] * g[2]) % q


def point_permutation(g, q):
    a, b, c, d = g
    answer = []
    for x in range(q + 1):
        if x == q:
            answer.append(q if c == 0 else a * pow(c, -1, q) % q)
        else:
            denominator = (c * x + d) % q
            answer.append(q if denominator == 0 else
                          (a * x + b) * pow(denominator, -1, q) % q)
    return tuple(answer)


def canon_matching(pairs):
    return tuple(sorted(tuple(sorted((int(a), int(b)))) for a, b in pairs))


def act_matching(permutation, matching):
    return canon_matching((permutation[a], permutation[b]) for a, b in matching)


def orbit(base, permutations):
    return sorted({act_matching(permutation, base) for permutation in permutations})


def induced_permutation(permutation, objects):
    index = {obj: i for i, obj in enumerate(objects)}
    return tuple(index[act_matching(permutation, obj)] for obj in objects)


def compose(left, right):
    return tuple(left[right[i]] for i in range(len(right)))


def permutation_power(permutation, exponent):
    result = tuple(range(len(permutation)))
    for _ in range(exponent):
        result = compose(permutation, result)
    return result


def generated_permutation_group(generators):
    identity = tuple(range(len(generators[0])))
    group = {identity}
    queue = deque(group)
    while queue:
        current = queue.popleft()
        for generator in generators:
            target = compose(generator, current)
            if target not in group:
                group.add(target)
                queue.append(target)
    return group


def rref(rows, p):
    if not rows:
        return []
    a = [[x % p for x in row] for row in rows if any(x % p for x in row)]
    rank = 0
    for column in range(len(rows[0])):
        pivot = next((i for i in range(rank, len(a)) if a[i][column]), None)
        if pivot is None:
            continue
        a[rank], a[pivot] = a[pivot], a[rank]
        scale = pow(a[rank][column], -1, p)
        a[rank] = [scale * x % p for x in a[rank]]
        for i in range(len(a)):
            if i != rank and a[i][column]:
                scale = a[i][column]
                a[i] = [(x - scale * y) % p for x, y in zip(a[i], a[rank])]
        rank += 1
    return a[:rank]


def all_vectors(basis, p):
    for coefficients in itertools.product(range(p), repeat=len(basis)):
        yield tuple(sum(coefficients[i] * basis[i][j] for i in range(len(basis))) % p
                    for j in range(len(basis[0])))


def act_vector(vector, permutation):
    answer = [0] * len(vector)
    for old, value in enumerate(vector):
        answer[permutation[old]] = value
    return tuple(answer)


def linear_coordinates(vector, basis, p):
    for coefficients in itertools.product(range(p), repeat=len(basis)):
        if tuple(sum(coefficients[i] * basis[i][j] for i in range(len(basis))) % p
                 for j in range(len(vector))) == tuple(vector):
            return list(coefficients)
    raise AssertionError("vector outside basis span")


def cyclic_data(core_basis, permutation, p):
    dimension = len(core_basis)
    for vector in all_vectors(core_basis, p):
        if not any(vector):
            continue
        sequence = []
        current = vector
        while len(rref([*sequence, current], p)) > len(sequence):
            sequence.append(current)
            current = act_vector(current, permutation)
        if len(sequence) == dimension:
            break
    else:
        raise AssertionError("no cyclic vector")
    coefficients = linear_coordinates(current, sequence, p)
    polynomial = [(-value) % p for value in coefficients] + [1]
    action = [linear_coordinates(act_vector(row, permutation), sequence, p)
              for row in sequence]
    return {
        "canonical_cyclic_vector": list(vector),
        "cyclic_basis_rows": [list(row) for row in sequence],
        "minimal_polynomial_constant_first": polynomial,
        "action_matrix": action,
    }


def trim(polynomial):
    while len(polynomial) > 1 and polynomial[-1] == 0:
        polynomial.pop()
    return polynomial


def polynomial_divmod(dividend, divisor, p):
    remainder = [value % p for value in dividend]
    quotient = [0] * max(1, len(remainder) - len(divisor) + 1)
    inverse = pow(divisor[-1], -1, p)
    while len(remainder) >= len(divisor) and any(remainder):
        shift = len(remainder) - len(divisor)
        coefficient = remainder[-1] * inverse % p
        quotient[shift] = coefficient
        for i, value in enumerate(divisor):
            remainder[i + shift] = (remainder[i + shift] - coefficient * value) % p
        trim(remainder)
    return trim(quotient), trim(remainder)


def period_factors(q, p):
    dimension = (q - 1) // 2
    cyclotomic = [1] * q
    factors = []
    for coefficients in itertools.product(range(p), repeat=dimension):
        candidate = list(coefficients) + [1]
        quotient, remainder = polynomial_divmod(cyclotomic, candidate, p)
        if remainder == [0] and len(quotient) == dimension + 1:
            factors.append(candidate)
    factors = sorted({tuple(factor) for factor in factors})
    assert len(factors) == 2
    return [{"residue_root": (-factor[-2]) % p,
             "polynomial_constant_first": list(factor)} for factor in factors]


def matrix_multiply(left, right, p):
    return tuple(tuple(sum(left[i][k] * right[k][j] for k in range(len(right))) % p
                       for j in range(len(right[0]))) for i in range(len(left)))


def generated_matrix_group(generators, p):
    dimension = len(generators[0])
    identity = tuple(tuple(int(i == j) for j in range(dimension))
                     for i in range(dimension))
    generators = [tuple(tuple(row) for row in matrix) for matrix in generators]
    group = {identity}
    queue = deque(group)
    while queue:
        current = queue.popleft()
        for generator in generators:
            target = matrix_multiply(generator, current, p)
            if target not in group:
                group.add(target)
                queue.append(target)
    return group


def build_case(q, p, type_name, frozen, c465_case):
    base = canon_matching(frozen["coxeter_invariant_matching"])
    matrices = sorted({normalize_matrix(values, q)
                       for values in itertools.product(range(q), repeat=4)
                       if determinant(values, q)})
    pgl_permutations = [point_permutation(matrix, q) for matrix in matrices]
    squares = {x * x % q for x in range(1, q)}
    psl_permutations = [point_permutation(matrix, q) for matrix in matrices
                        if determinant(matrix, q) in squares]
    all_matchings = orbit(base, pgl_permutations)
    sheet0 = orbit(base, psl_permutations)
    sheet0_set = set(sheet0)
    sheet1 = [matching for matching in all_matchings if matching not in sheet0_set]
    point_generators = [point_permutation((1, 1, 0, 1), q),
                        point_permutation((0, q - 1, 1, 0), q)]
    t0_permutation, s0_permutation = [induced_permutation(g, sheet0) for g in point_generators]
    t_permutation, s_permutation = [induced_permutation(g, sheet1) for g in point_generators]
    assert len(generated_permutation_group([t_permutation, s_permutation])) == q * (q * q - 1) // 2

    core = c465_case["spaces"]["shared_edge_row_span"]["basis"]
    assert rref([act_vector(row, t_permutation) for row in core], p) == core
    assert rref([act_vector(row, s_permutation) for row in core], p) == core
    t_data = cyclic_data(core, t_permutation, p)
    cyclic_basis = [tuple(row) for row in t_data["cyclic_basis_rows"]]
    s_action = [linear_coordinates(act_vector(row, s_permutation), cyclic_basis, p)
                for row in cyclic_basis]
    change_to_c465 = [linear_coordinates(row, [tuple(x) for x in core], p)
                      for row in cyclic_basis]
    assert len(rref(change_to_c465, p)) == len(core)
    assert len(generated_matrix_group([t_data["action_matrix"], s_action], p)) == \
        q * (q * q - 1) // 2

    factors = period_factors(q, p)
    factor_by_polynomial = {tuple(record["polynomial_constant_first"]): record
                            for record in factors}
    selected = factor_by_polynomial[tuple(t_data["minimal_polynomial_constant_first"])]
    selected_root = selected["residue_root"]
    other_root = (-1 - selected_root) % p
    shared_incidence = [[int(len(set(left) & set(right)) == 1) for right in sheet1]
                        for left in sheet0]
    opposite_core = rref([list(row) for row in zip(*shared_incidence)], p)
    assert len(opposite_core) == len(core)
    assert rref([act_vector(row, t0_permutation) for row in opposite_core], p) == opposite_core
    assert rref([act_vector(row, s0_permutation) for row in opposite_core], p) == opposite_core
    opposite_data = cyclic_data(opposite_core, t0_permutation, p)
    opposite_factor = factor_by_polynomial[
        tuple(opposite_data["minimal_polynomial_constant_first"])]
    assert opposite_factor["residue_root"] == other_root
    exponent_table = []
    for exponent in range(1, q):
        powered = permutation_power(t_permutation, exponent)
        data = cyclic_data(core, powered, p)
        factor = factor_by_polynomial[tuple(data["minimal_polynomial_constant_first"])]
        legendre = 1 if exponent in squares else -1
        expected = selected_root if legendre == 1 else other_root
        assert factor["residue_root"] == expected
        exponent_table.append({
            "exponent": exponent,
            "legendre_symbol": legendre,
            "residue_root": factor["residue_root"],
            "minimal_polynomial_constant_first": data["minimal_polynomial_constant_first"],
        })

    m = (q + 1) // 4
    assert p == m
    return {
        "q": q,
        "characteristic": p,
        "type": type_name,
        "quadratic_field": f"Q(sqrt(-{q}))",
        "field_discriminant": -q,
        "period_generator": f"alpha=(-1+sqrt(-{q}))/2",
        "period_polynomial_constant_first": [m, 1, 1],
        "ring_of_integers": f"Z[alpha], alpha^2+alpha+{m}=0",
        "split_primes": [
            {"name": "p_0", "ideal": f"({p},alpha)", "residue_map": f"a+b*alpha -> a mod {p}",
             "alpha_residue": 0},
            {"name": "p_-1", "ideal": f"({p},alpha+1)",
             "residue_map": f"a+b*alpha -> a-b mod {p}", "alpha_residue": p - 1},
        ],
        "cyclotomic_period_factors": factors,
        "frozen_generators": {
            "T_permutation_old_to_new": list(t_permutation),
            "S_permutation_old_to_new": list(s_permutation),
        },
        "selected_prime": "p_0" if selected_root == 0 else "p_-1",
        "selected_alpha_residue": selected_root,
        "selected_factor_constant_first": selected["polynomial_constant_first"],
        "other_alpha_residue": other_root,
        "opposite_sheet": {
            "core_basis_rref": opposite_core,
            "selected_alpha_residue": opposite_factor["residue_root"],
            "selected_factor_constant_first": opposite_factor[
                "polynomial_constant_first"],
            "is_conjugate_prime": True,
            "literal_check": "the transpose shared-edge core on the opposite frozen sheet has the other T minimal polynomial",
        },
        "frozen_core_basis_rref": core,
        "intertwiner": {
            "source": "the selected period-factor module in canonical cyclic basis 1,T,...,T^(d-1)",
            "target": "C465 frozen simple core in its literal sheet-coordinate basis",
            "matrix_rows_into_frozen_coordinates": t_data["cyclic_basis_rows"],
            "change_of_basis_rows_into_C465_RREF_basis": change_to_c465,
            "T_source_matrix": t_data["action_matrix"],
            "S_source_matrix": s_action,
            "T_target_permutation": list(t_permutation),
            "S_target_permutation": list(s_permutation),
            "commutes_for_T_and_S": True,
            "source_generator_image_order": q * (q * q - 1) // 2,
        },
        "normalization_exponent_table": exponent_table,
        "orientation_rule": "T -> T^a preserves the selected prime exactly for square a and swaps it for nonsquare a",
    }


def build():
    inputs = verify_inputs()
    c406 = json.loads((NOTES / "2026-07-20-c406-matching-orbit-scout.json").read_text())
    c450 = json.loads((NOTES / "2026-07-21-c450-weil-cross-sheet.json").read_text())
    c465 = json.loads((NOTES / "2026-07-21-c465-mod3-weil-golay.json").read_text())
    c471 = json.loads((NOTES / "2026-07-22-c471-hadamard-degeneration-complex.json").read_text())
    c472 = json.loads((NOTES / "2026-07-22-c472-signed-weil-lift.json").read_text())
    frozen = {case["type"]: case for case in c406["types"]}
    cases465 = {case["q"]: case for case in c465["cases"]}
    cases = [build_case(7, 2, "B3", frozen["B3"], cases465[7]),
             build_case(11, 3, "H3", frozen["H3"], cases465[11])]
    assert cases[0]["selected_prime"] == "p_-1"
    assert cases[1]["selected_prime"] == "p_0"
    assert c450["quadratic_character_field"]["minimal_polynomial"] == "x^2+x+3"
    assert c471["scope"]["q7_model_claimed"] is False
    assert c472["extension_decision"]["type"] == "split direct product C2 x PSL_2(11)"

    return {
        "schema": "c473-arithmetic-orientation-v1",
        "task": "C473",
        "verdict": "qualified green: the marked frozen sheet and unipotent square-class orient a unique residue prime and lower constituent; forgetting the sheet or allowing an outer nonsquare gauge restores the two-point Galois torsor",
        "inputs": inputs,
        "cases": cases,
        "uniform_statement": {
            "period_polynomial": "x^2+x+m with m=(q+1)/4 equal to the reduction characteristic",
            "prime_pair": "p_0=(m,alpha) and p_-1=(m,alpha+1)",
            "orientation_mechanism": "the minimal polynomial of frozen T on the simple core is the cyclotomic factor whose root orbit has period sum alpha mod p",
            "sheet_preserving_invariance": "PSL conjugacy and square powers of T preserve the factor and selected prime",
            "outer_exchange": "a nonsquare power, PGL sheet swap, inversion T->T^-1, Galois alpha->-1-alpha, or Hadamard row/column outer duality exchanges both factors and both primes",
            "absolute_canonical_orientation": False,
            "relative_to_marked_sheet_and_period_generator": True,
            "unmarked_orientation_space": "a free C2 torsor identified simultaneously with the two sheets, two order-q unipotent classes, two period factors, and two split primes",
        },
        "normalization_change_table": [
            {"change": "T -> T^a with a square mod q", "sheet_preserved": True,
             "prime_changed": False, "certificate": "all square exponents in both exact tables"},
            {"change": "T -> T^a with a nonsquare mod q", "sheet_preserved": False,
             "prime_changed": True, "certificate": "all nonsquare exponents in both exact tables"},
            {"change": "T -> T^-1", "sheet_preserved": False, "prime_changed": True,
             "reason": "-1 is nonsquare for q=7,11"},
            {"change": "global code scalar or Hadamard row sign", "sheet_preserved": True,
             "prime_changed": False, "reason": "the core subspace and T minimal polynomial are unchanged"},
            {"change": "minority-symbol 1/2 relabeling", "sheet_preserved": True,
             "prime_changed": False, "reason": "projective scaling changes representatives, not supports, core, or T action"},
            {"change": "C472 central signed lift", "sheet_preserved": True,
             "prime_changed": False, "reason": "the central scalar is uniform and the unique complement is pure"},
            {"change": "Galois alpha -> -1-alpha", "sheet_preserved": False,
             "prime_changed": True, "reason": "p_0 and p_-1 are exchanged by definition"},
            {"change": "C470 Hadamard row/column outer duality", "sheet_preserved": False,
             "prime_changed": True, "reason": "the outer action exchanges the two frozen unipotent/character classes"},
        ],
        "sharp_boundary": {
            "Hadamard_signs_alone_orient": False,
            "minority_symbol_alone_orients": False,
            "signed_lift_alone_orients": False,
            "marked_sheet_plus_T_square_class_orients": True,
            "claim": "the frozen data select a prime only as an oriented-sheet object; no gauge-free preferred prime exists after quotienting by the allowed outer/Galois swap",
        },
        "scope": {
            "integral_Weil_lattice_claimed": False,
            "literature_priority_claimed": False,
            "q7_signed_Hadamard_model_inferred": False,
            "Ext_group_claimed": False,
        },
    }


def canonical_bytes(payload):
    return (json.dumps(payload, indent=2, sort_keys=True) + "\n").encode()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    data = canonical_bytes(build())
    if args.check:
        if not OUT.exists() or OUT.read_bytes() != data:
            raise SystemExit("C473 certificate is stale; regenerate without --check")
        print("C473 certificate check: PASS")
    else:
        OUT.write_bytes(data)
        print(f"wrote {OUT.relative_to(ROOT)} ({len(data)} bytes)")


if __name__ == "__main__":
    main()
