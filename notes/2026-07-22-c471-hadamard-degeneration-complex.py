#!/usr/bin/env python3
"""Generate the exact C471 Hadamard degeneration certificate."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
NOTES = ROOT / "notes"
OUT = NOTES / "2026-07-22-c471-hadamard-degeneration-complex.json"
P = 3
INPUT_HASHES = {
    "notes/2026-07-21-c465-mod3-weil-golay.json":
        "62dc3855782f570699d534907a91028523d393863a8b45189782a13a44614958",
    "notes/2026-07-21-c469-witt-golay-equivariance.json":
        "af259fbcb927b07d90a6f62f5fbd6a392511d1fd91090be6fab06faf3fc94582",
    "notes/2026-07-21-c455-fourier-weil.json":
        "7fa8d433190b8bcac53127ce4d36fde0620f4048bbcdf74a7096217d018a46f9",
    "notes/2026-07-22-c470-golay-hadamard-automorphisms.json":
        "694ddb709dce8b4b513b33fa899d23fe538528d76a0d82ec6b8779305e6f9a07",
    "notes/2026-07-20-c406-matching-orbit-scout.json":
        "fec533bb91f864100ebf5875952244d9d9e03ed69a0abda767360907a55bb246",
    "notes/2026-07-21-c452-qr-barker.json":
        "6f5829b2de929bfa40f5c6c657896e58fd26f9c2157bde89b7387757b4f887c2",
}


def digest(path: Path) -> dict[str, object]:
    data = path.read_bytes()
    return {"bytes": len(data), "sha256": hashlib.sha256(data).hexdigest()}


def verify_inputs() -> dict[str, dict[str, object]]:
    result = {}
    for name, expected in INPUT_HASHES.items():
        info = digest(ROOT / name)
        if info["sha256"] != expected:
            raise RuntimeError(f"input hash drift for {name}")
        result[name] = info
    return result


def transpose(a):
    return [list(row) for row in zip(*a)]


def matmul(a, b, modulus=None):
    answer = [[sum(a[i][k] * b[k][j] for k in range(len(b)))
               for j in range(len(b[0]))] for i in range(len(a))]
    if modulus is not None:
        answer = [[x % modulus for x in row] for row in answer]
    return answer


def identity(n: int):
    return [[int(i == j) for j in range(n)] for i in range(n)]


def rref(rows, p=P):
    if not rows:
        return []
    a = [[x % p for x in row] for row in rows if any(x % p for x in row)]
    rank = 0
    for column in range(len(rows[0])):
        pivot = next((i for i in range(rank, len(a)) if a[i][column]), None)
        if pivot is None:
            continue
        a[rank], a[pivot] = a[pivot], a[rank]
        inverse = pow(a[rank][column], -1, p)
        a[rank] = [inverse * x % p for x in a[rank]]
        for i in range(len(a)):
            if i != rank and a[i][column]:
                scale = a[i][column]
                a[i] = [(x - scale * y) % p for x, y in zip(a[i], a[rank])]
        rank += 1
    return a[:rank]


def nullspace(rows, p=P):
    rr = rref(rows, p)
    width = len(rows[0])
    pivots = [next(i for i, x in enumerate(row) if x) for row in rr]
    free = [i for i in range(width) if i not in pivots]
    basis = []
    for column in free:
        vector = [0] * width
        vector[column] = 1
        for row, pivot in zip(rr, pivots):
            vector[pivot] = -row[column] % p
        basis.append(vector)
    return rref(basis, p)


def all_vectors(basis, p=P):
    width = len(basis[0]) if basis else 0
    for coefficients in itertools.product(range(p), repeat=len(basis)):
        yield tuple(sum(coefficients[i] * basis[i][j]
                        for i in range(len(basis))) % p for j in range(width))


def coordinates(vector, basis, p=P):
    pivots = [next(i for i, x in enumerate(row) if x) for row in basis]
    coeffs = [vector[i] % p for i in pivots]
    rebuilt = [sum(coeffs[k] * basis[k][j] for k in range(len(basis))) % p
               for j in range(len(vector))]
    if rebuilt != [x % p for x in vector]:
        raise AssertionError("vector is not in the asserted space")
    return coeffs


def act_vector(vector, permutation):
    answer = [0] * len(vector)
    for old, value in enumerate(vector):
        answer[permutation[old]] = value
    return answer


def restricted_action(basis, permutation):
    return [coordinates(act_vector(row, permutation), basis) for row in basis]


def permutation_matrix(permutation):
    answer = [[0] * len(permutation) for _ in permutation]
    for old, new in enumerate(permutation):
        answer[new][old] = 1
    return answer


def signed_permutation_matrix(permutation, signs):
    answer = [[0] * len(permutation) for _ in permutation]
    for old, new in enumerate(permutation):
        answer[new][old] = signs[old]
    return answer


def normalize_projective_matrix(values, q=11):
    values = tuple(x % q for x in values)
    first = next(x for x in values if x)
    inverse = pow(first, -1, q)
    return tuple(x * inverse % q for x in values)


def determinant_2x2(g, q=11):
    a, b, c, d = g
    return (a * d - b * c) % q


def point_permutation(g, q=11):
    a, b, c, d = g
    answer = []
    for x in range(q + 1):
        if x == q:
            answer.append(q if c == 0 else a * pow(c, -1, q) % q)
            continue
        denominator = (c * x + d) % q
        answer.append(q if denominator == 0 else
                      (a * x + b) * pow(denominator, -1, q) % q)
    return tuple(answer)


def canon_matching(pairs):
    return tuple(sorted(tuple(sorted((int(a), int(b)))) for a, b in pairs))


def act_matching(permutation, matching):
    return canon_matching((permutation[a], permutation[b]) for a, b in matching)


def matching_orbit(base, permutations):
    return sorted({act_matching(permutation, base) for permutation in permutations})


def induced_matching_permutation(permutation, objects):
    index = {obj: i for i, obj in enumerate(objects)}
    return tuple(index[act_matching(permutation, obj)] for obj in objects)


def equivariant_retraction_test(ambient_basis, sub_basis, permutations):
    ambient_actions = [restricted_action(ambient_basis, g) for g in permutations]
    sub_actions = [restricted_action(sub_basis, g) for g in permutations]
    inclusion = [coordinates(v, ambient_basis) for v in sub_basis]
    n, d = len(ambient_basis), len(sub_basis)
    equations, rhs = [], []
    for a_matrix, s_matrix in zip(ambient_actions, sub_actions):
        for i in range(n):
            for j in range(d):
                row = [0] * (n * d)
                for k in range(n):
                    row[k * d + j] = (row[k * d + j] + a_matrix[i][k]) % P
                for ell in range(d):
                    row[i * d + ell] = (row[i * d + ell] - s_matrix[ell][j]) % P
                equations.append(row)
                rhs.append(0)
    for a in range(d):
        for j in range(d):
            row = [0] * (n * d)
            for i in range(n):
                row[i * d + j] = inclusion[a][i]
            equations.append(row)
            rhs.append(int(a == j))
    rank = len(rref(equations))
    augmented_rank = len(rref([row + [value] for row, value in zip(equations, rhs)]))
    return {
        "unknowns": n * d,
        "equations": len(equations),
        "coefficient_rank": rank,
        "augmented_rank": augmented_rank,
        "retraction_exists": rank == augmented_rank,
    }


def bareiss_determinant(matrix):
    a = [row[:] for row in matrix]
    sign, previous = 1, 1
    for k in range(len(a) - 1):
        pivot = next((i for i in range(k, len(a)) if a[i][k]), None)
        if pivot is None:
            return 0
        if pivot != k:
            a[k], a[pivot] = a[pivot], a[k]
            sign *= -1
        value = a[k][k]
        for i in range(k + 1, len(a)):
            for j in range(k + 1, len(a)):
                a[i][j] = (a[i][j] * value - a[i][k] * a[k][j]) // previous
        previous = value
    return sign * a[-1][-1]


def build():
    inputs = verify_inputs()
    c465 = json.loads((NOTES / "2026-07-21-c465-mod3-weil-golay.json").read_text())
    c469 = json.loads((NOTES / "2026-07-21-c469-witt-golay-equivariance.json").read_text())
    c455 = json.loads((NOTES / "2026-07-21-c455-fourier-weil.json").read_text())
    c470 = json.loads((NOTES / "2026-07-22-c470-golay-hadamard-automorphisms.json").read_text())
    c406 = json.loads((NOTES / "2026-07-20-c406-matching-orbit-scout.json").read_text())
    c452 = json.loads((NOTES / "2026-07-21-c452-qr-barker.json").read_text())
    case = next(item for item in c465["cases"] if item["q"] == 11)

    hadamard = c469["third_order_unpunctured_hadamard_model"]["hadamard_matrix"]
    hadamard_t = transpose(hadamard)
    gram = [[12 * int(i == j) for j in range(12)] for i in range(12)]
    assert matmul(hadamard, hadamard_t) == gram
    assert matmul(hadamard_t, hadamard) == gram
    determinant = bareiss_determinant(hadamard)
    assert abs(determinant) == 12 ** 6

    h3 = [[x % P for x in row] for row in hadamard]
    h3_t = transpose(h3)
    zero = [[0] * 12 for _ in range(12)]
    assert matmul(h3, h3_t, P) == zero
    assert matmul(h3_t, h3, P) == zero
    row_space, column_space = rref(h3), rref(h3_t)
    kernel, transpose_kernel = nullspace(h3), nullspace(h3_t)
    assert len(row_space) == len(column_space) == 6
    assert kernel == row_space
    assert transpose_kernel == column_space
    carrier_intersection = rref(sorted(set(all_vectors(row_space)) &
                                       set(all_vectors(column_space))))
    carrier_sum = rref([*row_space, *column_space])
    assert len(carrier_intersection) == 1 and len(carrier_sum) == 11

    incidence = [[int(column in set(support)) for column in range(11)]
                 for support in c469["object_orders"]["selected_supports"]]
    block_hadamard = [[1] * 12] + [
        [1 - 2 * value for value in row] + [-1] for row in incidence
    ]
    assert block_hadamard == hadamard
    extended_incidence_rows = [row + [(-sum(row)) % P] for row in incidence]
    row_differences = [[(h3[i + 1][j] - h3[0][j]) % P for j in range(12)]
                       for i in range(11)]
    assert row_differences == extended_incidence_rows

    def divided_preimages(operator, vectors):
        answer = []
        for vector in vectors:
            integral_image = [sum(operator[i][j] * vector[j] for j in range(12))
                              for i in range(12)]
            assert all(value % 3 == 0 for value in integral_image)
            answer.append([value // 3 % 3 for value in integral_image])
        return answer

    kernel_preimages_under_ht = divided_preimages(hadamard, kernel)
    transpose_kernel_preimages_under_h = divided_preimages(hadamard_t, transpose_kernel)
    assert matmul(h3_t, transpose(kernel_preimages_under_ht), P) == transpose(kernel)
    assert matmul(h3, transpose(transpose_kernel_preimages_under_h), P) == \
        transpose(transpose_kernel)

    signed_adjoint_intertwiners = []
    for record in c470["second_order_signed_bipartite_geometry"][
            "generator_signing_equivariance"]:
        coordinate_signs = [1 if value == 1 else -1 for value in record["coordinate_signs"]]
        coordinate_action = signed_permutation_matrix(
            record["coordinate_permutation"], coordinate_signs)
        row_action = [[0] * 12 for _ in range(12)]
        actual_row_scalars = []
        for old, new in enumerate(record["Hadamard_row_permutation"]):
            transformed = [sum(coordinate_action[i][j] * hadamard[old][j]
                               for j in range(12)) for i in range(12)]
            if transformed == hadamard[new]:
                scalar = 1
            elif transformed == [-x for x in hadamard[new]]:
                scalar = -1
            else:
                raise AssertionError("C470 signed generator does not transport a Hadamard row")
            actual_row_scalars.append(scalar)
            row_action[new][old] = scalar
        assert matmul(coordinate_action, hadamard_t) == matmul(hadamard_t, row_action)
        assert matmul(hadamard, transpose(coordinate_action)) == \
            matmul(transpose(row_action), hadamard)
        assert matmul(row_action, matmul(hadamard, transpose(coordinate_action))) == hadamard
        signed_adjoint_intertwiners.append({
            "coordinate_signed_monomial_matrix_R": coordinate_action,
            "Hadamard_row_signed_monomial_matrix_M": row_action,
            "Hadamard_row_scalars_in_raw_H_gauge": actual_row_scalars,
            "R_Ht_equals_Ht_M": True,
            "H_Rt_equals_Mt_H": True,
            "M_H_Rt_equals_H": True,
            "identities_remain_true_mod_3": True,
        })

    perfect_c465 = case["spaces"]["disjoint_row_span"]["basis"]
    core_c465 = case["spaces"]["shared_edge_row_span"]["basis"]

    # C465 canonically sorted its reconstructed matching orbit; C469 retained
    # C452's frozen sheet order.  Recover and certify the literal relabelling.
    frozen_h3 = next(item for item in c406["types"] if item["type"] == "H3")
    base = canon_matching(frozen_h3["coxeter_invariant_matching"])
    matrices = sorted({normalize_projective_matrix(g)
                       for g in itertools.product(range(11), repeat=4)
                       if determinant_2x2(g)})
    pgl_permutations = [point_permutation(g) for g in matrices]
    squares = {x * x % 11 for x in range(1, 11)}
    psl_permutations = [point_permutation(g) for g in matrices
                        if determinant_2x2(g) in squares]
    all_matchings = matching_orbit(base, pgl_permutations)
    sheet0_c465 = matching_orbit(base, psl_permutations)
    sheet0_set = set(sheet0_c465)
    sheet1_c465 = [matching for matching in all_matchings if matching not in sheet0_set]
    c452_case = next(item for item in c452["cases"] if item["q"] == 11)
    sheet1_c469 = [canon_matching(matching) for matching in c452_case["sheets"][1]]
    c465_index = {matching: i for i, matching in enumerate(sheet1_c465)}
    relabel_469_to_465 = [c465_index[matching] for matching in sheet1_c469]
    assert sorted(relabel_469_to_465) == list(range(11))

    extension = [identity(11)[i] for i in range(11)] + [[P - 1] * 11]
    projection = [identity(12)[i] for i in range(11)]
    extended_perfect = rref(c470["extended_code"]["generator_matrix"])
    assert extended_perfect == row_space
    assert matmul(projection, extension, P) == identity(11)
    assert all([*vector[:11], (-sum(vector[:11])) % P] == list(vector)
               for vector in all_vectors(row_space))

    punctured = rref([row[:11] for row in row_space])
    shortened_words = [list(word[:11]) for word in all_vectors(row_space) if word[11] == 0]
    shortened = rref(shortened_words)
    punctured_in_c465_order = rref([act_vector(row, relabel_469_to_465) for row in punctured])
    shortened_in_c465_order = rref([act_vector(row, relabel_469_to_465) for row in shortened])
    assert punctured_in_c465_order == rref(perfect_c465)
    assert shortened_in_c465_order == rref(core_c465)
    ones = [1] * 11
    assert rref([*shortened, ones]) == punctured
    assert all(sum(vector) % P == 0 for vector in shortened)
    assert nullspace(punctured) == shortened

    augmentation = rref([[int(i == j) - int(j == 10) for j in range(11)]
                         for i in range(10)])
    assert len(augmentation) == 10
    assert all(len(rref([*augmentation, row])) == 10 for row in shortened)

    actions = c469["group"]["generator_actions"]
    generator_records = {}
    generator_permutations = []
    for name in ("translation_T", "inversion_S"):
        permutation = actions[name]["on_code_coordinates"]
        extended_permutation = permutation + [11]
        generator_permutations.append(permutation)
        r11 = permutation_matrix(permutation)
        r12 = permutation_matrix(extended_permutation)
        assert matmul(r12, extension, P) == matmul(extension, r11, P)
        assert matmul(projection, r12, P) == matmul(r11, projection, P)
        assert rref([act_vector(row, permutation) for row in punctured]) == punctured
        assert rref([act_vector(row, permutation) for row in shortened]) == shortened
        assert rref([act_vector(row, extended_permutation) for row in row_space]) == row_space
        generator_records[name] = {
            "length_11_permutation_old_to_new": permutation,
            "length_12_permutation_old_to_new": extended_permutation,
            "length_11_permutation_matrix": r11,
            "length_12_permutation_matrix": r12,
            "action_on_punctured_basis": restricted_action(punctured, permutation),
            "action_on_shortened_basis": restricted_action(shortened, permutation),
            "action_on_extended_basis": restricted_action(row_space, extended_permutation),
            "extension_square_commutes": True,
            "projection_square_commutes": True,
        }

    retraction = equivariant_retraction_test(augmentation, shortened, generator_permutations)
    assert retraction == case["module_structure"]["ambient_sheet"][
        "equivariant_retraction_test"]
    assert not retraction["retraction_exists"]

    return {
        "schema": "c471-hadamard-degeneration-complex-v1",
        "task": "C471",
        "verdict": "green: exact rank-half complex and literal puncture/shorten carrier; nonsplitting still uses the equivariant-retraction obstruction",
        "inputs": inputs,
        "integral_matrix_factorization": {
            "hadamard_matrix_H": hadamard,
            "transpose_Ht": hadamard_t,
            "H_Ht": gram,
            "Ht_H": gram,
            "identity": "H H^T = H^T H = 12 I_12",
            "determinant": determinant,
            "absolute_determinant": abs(determinant),
            "inverse_over_Q": "H^{-1}=H^T/12",
            "normalization": "12^(-1/2) H is an isometry between the two labelled 12-spaces",
            "incidence_matrix_A": incidence,
            "block_formula": "H=[[1^T,1],[J-2A,-1]] in the frozen C469 row/coordinate orders",
            "mod_3_lower_row_minus_top_row": extended_incidence_rows,
            "bridge_formula": "modulo 3, each lower Hadamard row minus the top row is the parity extension of the corresponding C469 incidence row",
        },
        "mod_3_exact_complex": {
            "H_mod_3": h3,
            "Ht_mod_3": h3_t,
            "rank_H": len(row_space),
            "rank_Ht": len(column_space),
            "H_Ht_is_zero": True,
            "Ht_H_is_zero": True,
            "kernel_H_basis_rref": kernel,
            "image_Ht_basis_rref": row_space,
            "kernel_Ht_basis_rref": transpose_kernel,
            "image_H_basis_rref": column_space,
            "literal_equalities": ["ker(H)=im(H^T)", "ker(H^T)=im(H)"],
            "two_periodic_complex": "... -> F_3^12 --H^T--> F_3^12 --H--> F_3^12 --H^T--> F_3^12 -> ... is exact",
            "structural_proof": "if Hx=0 mod 3, then y=Hx/3 is integral and H^T y=4x=x mod 3; transpose the argument for H^T",
            "determinant_cross_check": "im(H^T) is isotropic so rank(H)<=6, while v_3(det H)=v_3(12^6)=6 forces nullity(H)<=6",
            "divided_Bockstein": {
                "kernel_H_basis_preimages_under_Ht": kernel_preimages_under_ht,
                "kernel_Ht_basis_preimages_under_H": transpose_kernel_preimages_under_h,
                "formula": "beta_H(x)=[Hx/3] in F_3^12/im(H); H^T beta_H(x)=4x=x, and similarly with H,H^T exchanged",
                "meaning": "the divided integral operator is a canonical inverse to the induced differential, not merely a rank witness",
            },
        },
        "c469_carrier_identification": {
            "extended_code_basis_rref": extended_perfect,
            "equals_kernel_H": True,
            "equals_image_Ht": True,
            "self_dual_for_coordinate_dot_product": nullspace(extended_perfect) == extended_perfect,
            "transpose_companion_basis_rref": column_space,
            "transpose_companion_equals_c469_code": column_space == extended_perfect,
            "transpose_companion_self_dual": nullspace(column_space) == column_space,
            "displayed_coordinate_identification_diagnostic": {
                "intersection_dimension": len(carrier_intersection),
                "intersection_basis_rref": carrier_intersection,
                "sum_dimension": len(carrier_sum),
                "canonical_between_C470_carriers": False,
            },
            "orientation_warning": "the C469 code is ker(H)=im(H^T); ker(H^T)=im(H) is the distinct transpose companion in the frozen coordinates",
        },
        "puncture_shorten_bridge": {
            "distinguished_coordinate_zero_based": 11,
            "puncture_matrix_P": projection,
            "parity_extension_matrix_E": extension,
            "extension_formula": "E(x_0,...,x_10)=(x_0,...,x_10,-sum_i x_i)",
            "P_E": identity(11),
            "E_P_is_identity_on_c469_code": True,
            "punctured_basis_rref": punctured,
            "c465_coordinate_relabeling_old_c469_to_new_c465": relabel_469_to_465,
            "punctured_basis_in_c465_order_rref": punctured_in_c465_order,
            "c465_perfect_code_basis_rref": rref(perfect_c465),
            "puncture_equals_c465_perfect_code": True,
            "shortened_basis_rref": shortened,
            "shortened_basis_in_c465_order_rref": shortened_in_c465_order,
            "c465_simple_core_basis_rref": rref(core_c465),
            "shorten_equals_c465_simple_core": True,
            "shortening_condition": "last coordinate zero, equivalently sum of punctured coordinates zero",
            "perfect_code_split": "D_11=S_11 direct-sum <1>",
            "orthogonal_identity": "S_11=D_11^perp inside F_3^11",
            "generator_intertwiners": generator_records,
        },
        "flag_from_operator": {
            "derived_without_retraction": [
                "S_11 < D_11=S_11 direct-sum <1> < F_3^11",
                "S_11=D_11^perp",
                "S_11 is a five-dimensional Lagrangian in the ten-dimensional augmentation 1^perp",
                "the coordinate form identifies augmentation/S_11 with S_11^*",
            ],
            "imported_c465_simple_core_check": "C465 exhaustive submodule lattice proves S_11 simple",
            "still_requires_retraction_computation": "the operator identities alone do not exclude an invariant complementary copy of S_11^* in the augmentation",
            "equivariant_retraction_system": retraction,
            "consequence_with_c465_simplicity": {
                "augmentation_extension": "0 -> S_11 -> 1^perp -> S_11^* -> 0 is nonsplit",
                "augmentation_socle_and_radical": "S_11",
                "full_sheet_socle": "D_11=<1> direct-sum S_11",
                "full_sheet_radical": "S_11",
            },
        },
        "c455_operator_comparison": {
            "common_exact_pattern": "an unnormalized integral/cyclotomic transform becomes an isometry only after division by the square root of its orthogonality scalar",
            "C471_identity": "H H^T=H^T H=12I; reduction at 3 gives the exact alternating H/H^T complex",
            "C455_identity": "hat-hat=1331 R and F=11^(-3/2)hat; on the certified even restrictions F^2=I",
            "C455_genuine_linearization": c455["genuine_linearization"],
            "C455_central_action": c455["central_action"],
            "projective_only_in_C455": c455["projective_weil_identification"],
            "literal_Weil_module_identification": False,
            "discriminator": "H supplies no SL_2(11) action or central scalar; rank six and Fourier-style normalization cannot override C455/C465's central-character obstruction",
        },
        "c470_carrier_geometry": {
            "imported_fact": "C470 identifies the coordinate and Hadamard-row carriers as the two outer-related degree-12 M12 actions, with frozen PSL_2(11) as the base-cell stabilizer",
            "exact_complex_interpretation": "H and H^T alternate between C470's two labelled 12-spaces; the distinct transpose carrier is expected in frozen coordinates and is exchanged by row/column duality",
            "C470_base_cell_stabilizer_order": c470["second_order_signed_bipartite_geometry"]["base_cell_stabilizer_order"],
            "signed_adjoint_intertwiners_for_C470_standard_generators": signed_adjoint_intertwiners,
            "equivariance_statement": "C470's signed coordinate and Hadamard-row lifts preserve the integral pairing H; equivalently R H^T=H^T M and H R^T=M^T H for each recorded standard generator",
            "new_automorphism_or_signed_cover_claim": False,
        },
        "scope": {
            "automorphism_group_census": False,
            "signed_double_cover_conclusion": False,
            "q7_model_claimed": False,
            "larger_Weil_module_claimed": False,
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
            raise SystemExit("C471 certificate is stale; regenerate without --check")
        print("C471 certificate check: PASS")
    else:
        OUT.write_bytes(data)
        print(f"wrote {OUT.relative_to(ROOT)} ({len(data)} bytes)")


if __name__ == "__main__":
    main()
