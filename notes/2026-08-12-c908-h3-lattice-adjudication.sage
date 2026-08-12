#!/usr/bin/env sage
"""C908 pass-9 certificate: adjudicating the corrected degree-three lattice.

Pass-8 (`notes/2026-08-11-c908-gate-a-transfer.sage`) measured that psi_* of the
940 integral Kunneth generators of H^3(F x F, Z) leaves L_3(^3 Lambda): 626 of
them have L_3-preimage with denominator exactly two, and that set is exactly the
set with odd diagonal restriction.  Hence b^* : H^3(J,Z) -> H^3(M,Z) is not
surjective (pass-2 Theorem 1 is false in degree three) and the test lattice used
by the lambda-bit gate must be enlarged.

This certificate adjudicates the enlargement.  Write

    sigma(T)  := psi_* T                in ^5 Lambda = Z^252
    gamma(T)  := a_*(i_Delta^* T)       in ^9 Lambda = Z^10

and let A be the 262 x 940 integer matrix with columns (sigma(T) ; gamma(T)).
Let Sat be the saturation of L_3(^3 Lambda) inside Z^252.  The certificate
establishes, entirely by integer linear algebra:

  * Sat / L_3(^3 Lambda) = (Z/2)^10 and every sigma(T) lies in Sat;
  * a well-defined injective (hence bijective) F_2-linear correspondence
        rho : F_2^10 = (^9 Lambda) (x) F_2  ->  Sat / L_3(^3 Lambda)
    with sigma(T) = rho(gamma(T))  mod L_3(^3 Lambda) for ALL 940 generators;
  * the corrected test lattice
        H^ := {(sigma, g) in Sat + Z^10 : sigma = rho(g) mod L_3(^3 Lambda)}
    of rank 130, of index 2^10 in Sat + Z^10, containing the whole transfer
    image Im = col(A), with the quotient H^/Im and the mod-two reach recorded;
  * the escape group.  Pairing the first block of H^ against ^5 Lambda into the
    top form gives ImTheta subset Z^130 = Hom(H^, Z) with E := Z^130/ImTheta
    free of rank ten, and pairing the second block against Lambda gives ten
    classes generating exactly 2E, so E / (exceptional image) = (Z/2)^10.
    This is the corrected replacement for pass-2 Corollary 2.1.
  * the gate re-issue data: the old ten directions Theta ^ a survive mod two
    inside the L_3-preimage lattice V_0 of the even part of Im, and the ten new
    (second-block) directions are hit integrally.

All machinery -- form arithmetic, Poincare duality, the Pontryagin product, the
slot calculus, the Lefschetz matrices, and the 940-generator construction -- is
the committed pass-7 machinery, loaded (not copied), whose own control suite is
re-run as an assertion suite by the load.

Every check below is an in-script assertion.  No randomness; canonical
lexicographic enumeration throughout.
"""

from contextlib import redirect_stdout
from io import StringIO
from itertools import combinations
import argparse
import hashlib
import json
import sys
import time

_STARTED = time.time()

PASS7 = "notes/2026-08-11-c908-span-incidence-residues.sage"
GATE_A_SAGE = "notes/2026-08-11-c908-gate-a-transfer.sage"
GATE_A_JSON = "notes/2026-08-11-c908-gate-a-transfer.json"

# Loading the pass-7 script re-runs its full control suite (every control is an
# in-script assertion) and leaves all of its functions in this namespace.  This
# is the pass-8 loading pattern, verbatim.
_ADJ_ARGV = list(sys.argv)
sys.argv = [sys.argv[0]]
_pass7_stream = StringIO()
with redirect_stdout(_pass7_stream):
    load(PASS7)
    if "PASS" not in _pass7_stream.getvalue():
        main(None, None)                      # noqa: F821  (pass-7 main)
sys.argv = _ADJ_ARGV
PASS7_OUTPUT = _pass7_stream.getvalue()
PASS7_CONTROLS_PASS = PASS7_OUTPUT.rstrip().endswith("PASS")
assert PASS7_CONTROLS_PASS, "the shared pass-7 machinery no longer certifies"

SCHEMA_VERSION = "c908-h3-lattice-adjudication/1"
REPLAY_COMMAND = (
    "cd /home/tavis/src/othello && nix shell nixpkgs#sage -c sage "
    "notes/2026-08-12-c908-h3-lattice-adjudication.sage "
    "--json notes/2026-08-12-c908-h3-lattice-adjudication.json "
    "--out notes/2026-08-12-c908-h3-lattice-adjudication.out"
)


def _encode_columns(matrix_value):
    """One string per column, entries space separated (keeps the json small)."""
    return [" ".join(str(entry) for entry in column)
            for column in matrix_value.columns()]


def adjudication_main(json_path=None, out_path=None):
    record = {"schema": SCHEMA_VERSION, "replay_command": REPLAY_COMMAND}
    field = GF(2)
    checks = []

    def note(name, ok, detail=None):
        checks.append({"check": name, "pass": bool(ok),
                       "detail": None if detail is None else str(detail)})
        assert ok, f"CHECK FAILED: {name}" + (f" [{detail}]" if detail else "")

    # =====================================================================
    # CHECK 1 -- the shared machinery certifies
    # =====================================================================
    pass7_lines = PASS7_OUTPUT.strip().splitlines()
    note("1 pass-7 shared machinery re-certifies (controls end PASS)",
         PASS7_CONTROLS_PASS, f"{len(pass7_lines)} lines of pass-7 output")
    record["inputs"] = {
        PASS7: sha256_of(PASS7),
        CORPUS: sha256_of(CORPUS),
        GATE_A_SAGE: sha256_of(GATE_A_SAGE),
        GATE_A_JSON: sha256_of(GATE_A_JSON),
    }

    # ---------------------------------------------------------------- setup --
    _, _, _, symplectic = principal_lattice("omega", 1)
    assert abs(symplectic.det()) == 1
    theta = two_form(symplectic)

    powers = {1: theta}
    for degree in range(2, 6):
        powers[degree] = wedge(powers[degree - 1], theta)
    divided = {degree: divide_form(powers[degree], factorial(degree))
               for degree in powers}
    for degree in divided:
        assert scale_form(factorial(degree), divided[degree]) == powers[degree]

    _, _, lefschetz_13 = lefschetz_matrix(theta, 1)          # 10 x 120, rows
    cubics, quintics, lefschetz_35 = lefschetz_matrix(theta, 3)   # 120 x 252
    five_sets = list(combinations(range(DIM), 5))
    nine_sets = list(combinations(range(DIM), 9))
    assert quintics == five_sets and len(cubics) == 120 and len(nine_sets) == DIM

    # Column convention: L3 : Z^120 -> Z^252, x |-> Theta ^ x.
    L3 = lefschetz_35.transpose()
    assert L3.nrows() == 252 and L3.ncols() == 120

    # =====================================================================
    # CHECK 2 -- Smith form of L_3 and the saturation index
    # =====================================================================
    counts_35 = elementary_divisor_counts(L3)
    note("2a Smith form of L_3 is 1^110 2^10",
         counts_35 == {"1": 110, "2": 10}, counts_35)
    note("2b L_3 has full column rank 120", L3.rank() == 120)

    im_L3 = span([vector(ZZ, column) for column in L3.columns()], ZZ)
    Sat = im_L3.saturation()
    SB = Sat.basis_matrix()                      # 120 x 252, HNF rows
    note("2c Sat has rank 120", SB.nrows() == 120 and SB.rank() == 120)

    def sat_coords(target):
        """Coordinates of the columns of `target` in the Sat basis."""
        solution = SB.transpose().change_ring(QQ).solve_right(
            target.change_ring(QQ))
        assert SB.transpose().change_ring(QQ) * solution == target.change_ring(QQ)
        return solution

    coord_L3 = sat_coords(L3)                    # 120 x 120 over QQ
    assert all(entry.denominator() == 1 for entry in coord_L3.list())
    coord_L3 = coord_L3.change_ring(ZZ)
    sat_index = abs(coord_L3.det())
    counts_index = elementary_divisor_counts(coord_L3)
    note("2d [Sat : L_3(^3 Lambda)] = 2^10", sat_index == 2 ** 10, sat_index)
    note("2e Sat / L_3(^3 Lambda) = (Z/2)^10",
         counts_index == {"1": 110, "2": 10}, counts_index)

    # The class map Sat -> Sat/L_3(^3 Lambda) = (Z/2)^10.
    smith_D, smith_U, smith_V = coord_L3.smith_form()
    assert smith_D == smith_U * coord_L3 * smith_V
    torsion_positions = [i for i in range(120) if smith_D[i, i] == 2]
    assert len(torsion_positions) == DIM
    assert all(smith_D[i, i] in (1, 2) for i in range(120))

    def class_map(coordinates):
        """(Z/2)^10 classes from Sat coordinates of a family of Sat elements."""
        assert all(entry.denominator() == 1 for entry in coordinates.list())
        reduced = smith_U * coordinates.change_ring(ZZ)
        return matrix(field, [reduced.row(i) for i in torsion_positions])

    # ------------------------------------------------ the 940 generators ----
    # Construction copied verbatim from the pass-8 gate-A certificate.
    def a_star_degree_two(pair):
        return wedge(basis_form(pair), divided[3])

    def a_star_degree_one(index):
        return wedge(basis_form((index,)), divided[3])

    two_indices = list(combinations(range(DIM), 2))
    push_h2 = {pair: a_star_degree_two(pair) for pair in two_indices}
    push_h1 = {index: a_star_degree_one(index) for index in range(DIM)}
    push_cs = scale_form(2, divided[4])                 # a_*(C_s)
    push_unit = dict(divided[3])                        # a_*(1)
    push_h3 = {m: basis_form(nine_sets[m]) for m in range(DIM)}

    def psi_push(left_push, left_degree, right_push):
        value = pontryagin(left_push, right_push)
        if left_degree % 2:
            value = scale_form(-1, value)
        return value

    generators = []          # (label, psi_* form in ^5, i_Delta^* form in ^9)
    for m in range(DIM):
        generators.append((f"beta{m}(x)1",
                           psi_push(push_h3[m], 3, push_unit),
                           dict(push_h3[m])))
    for m in range(DIM):
        generators.append((f"1(x)beta{m}",
                           psi_push(push_unit, 0, push_h3[m]),
                           dict(push_h3[m])))
    for pair in two_indices:
        restricted = {}
        for index in range(DIM):
            product = wedge(basis_form(pair), basis_form((index,)))
            restricted[index] = wedge(product, divided[3]) if product else {}
        for index in range(DIM):
            generators.append((f"a*e{pair[0]}{pair[1]}(x)a*e{index}",
                               psi_push(push_h2[pair], 2, push_h1[index]),
                               restricted[index]))
    for index in range(DIM):
        generators.append((f"Cs(x)a*e{index}",
                           psi_push(push_cs, 2, push_h1[index]),
                           scale_form(2, wedge(divided[4],
                                               basis_form((index,))))))
    for index in range(DIM):
        for pair in two_indices:
            product = wedge(basis_form((index,)), basis_form(pair))
            generators.append((f"a*e{index}(x)a*e{pair[0]}{pair[1]}",
                               psi_push(push_h1[index], 1, push_h2[pair]),
                               wedge(product, divided[3]) if product else {}))
    for index in range(DIM):
        generators.append((f"a*e{index}(x)Cs",
                           psi_push(push_h1[index], 1, push_cs),
                           scale_form(2, wedge(divided[4],
                                               basis_form((index,))))))
    assert len(generators) == 940
    for label, quintic, ninth in generators:
        for indices in quintic:
            assert len(indices) == 5, f"{label}: psi_* is not in ^5 Lambda"
        for indices in ninth:
            assert len(indices) == 9, f"{label}: i_Delta^* is not in ^9 Lambda"

    labels = [item[0] for item in generators]
    A1 = matrix(ZZ, [list(form_vector(item[1], 5))
                     for item in generators]).transpose()     # 252 x 940
    A2 = matrix(ZZ, [list(form_vector(item[2], 9))
                     for item in generators]).transpose()     # 10 x 940
    A = A1.stack(A2)                                          # 262 x 940
    assert A.nrows() == 262 and A.ncols() == 940
    # The H^3 (x) H^0 generators carry gamma = the standard basis of ^9 Lambda.
    assert A2[:, :DIM] == identity_matrix(ZZ, DIM)

    def block_name(n):
        if n < DIM:
            return "H3(x)H0"
        if n < 2 * DIM:
            return "H0(x)H3"
        if n < 2 * DIM + len(two_indices) * DIM:
            return "H2(x)H1 (a*u (x) a*z)"
        if n < 2 * DIM + len(two_indices) * DIM + DIM:
            return "H2(x)H1 (C_s (x) a*z)"
        if n < 2 * DIM + 2 * len(two_indices) * DIM + DIM:
            return "H1(x)H2 (a*z (x) a*u)"
        return "H1(x)H2 (a*z (x) C_s)"

    # =====================================================================
    # CHECK 3 -- denominators, saturation membership, parity dichotomy
    # =====================================================================
    X = L3.change_ring(QQ).solve_right(A1.change_ring(QQ))    # 120 x 940
    note("3a psi_* T lies in the rational image of L_3 for all 940",
         L3.change_ring(QQ) * X == A1.change_ring(QQ))
    denominators = [ZZ(lcm([entry.denominator() for entry in column]))
                    for column in X.columns()]
    note("3b every L_3-preimage denominator is one or two",
         set(denominators) <= {1, 2}, sorted(set(int(d) for d in denominators)))
    doubled = (2 * X).change_ring(ZZ)                          # 120 x 940
    note("3c 2 psi_* T lies in L_3(^3 Lambda) for all 940",
         L3 * doubled == 2 * A1)
    sat_of_A1 = sat_coords(A1)
    note("3d psi_* T lies in Sat for all 940",
         all(entry.denominator() == 1 for entry in sat_of_A1.list()))

    half_set = {n for n in range(940) if denominators[n] == 2}
    integral_rows = [n for n in range(940) if denominators[n] == 1]
    A2_mod2 = A2.change_ring(field)
    odd_set = {n for n in range(940) if A2_mod2.column(n) != 0}
    note("3e psi_* T escapes L_3(^3 Lambda) exactly when gamma(T) is odd",
         half_set == odd_set,
         f"{len(half_set)} escaping, {len(odd_set)} odd")
    note("3f the escaping/odd count is 626", len(half_set) == 626, len(half_set))

    denominator_profile = {}
    for n, den in enumerate(denominators):
        bucket = denominator_profile.setdefault(block_name(n), {})
        bucket[str(den)] = bucket.get(str(den), 0) + 1
    record["check_3_denominators"] = {
        "generators": 940,
        "denominator_two": int(len(half_set)),
        "denominator_one": int(len(integral_rows)),
        "odd_diagonal_restriction": int(len(odd_set)),
        "escaping_set_equals_odd_set": bool(half_set == odd_set),
        "denominator_profile_by_block": denominator_profile,
    }

    # =====================================================================
    # CHECK 4 -- the sum lattice is exactly Sat
    # =====================================================================
    combined = matrix(ZZ, list(L3.transpose().rows()) +
                          list(A1.transpose().rows()))         # 1060 x 252
    combined_hnf = combined.hermite_form(include_zero_rows=False)
    sat_hnf = SB.hermite_form(include_zero_rows=False)
    note("4 L_3(^3 Lambda) + Z<psi_* T> = Sat exactly (equal HNF)",
         combined_hnf == sat_hnf)

    # =====================================================================
    # CHECK 5 -- the correspondence rho
    # =====================================================================
    classes = class_map(sat_of_A1)                             # 10 x 940 over F2
    # gamma mod two of the first ten generators is the standard basis of F_2^10.
    rho = matrix(field, [list(classes.column(k)) for k in range(DIM)]).transpose()
    note("5a rho is invertible over F_2", rho.is_invertible())
    note("5b sigma(T) = rho(gamma(T)) mod L_3(^3 Lambda) for all 940 generators",
         rho * A2_mod2 == classes)
    note("5c rho is an isomorphism F_2^10 -> Sat / L_3(^3 Lambda)",
         rho.rank() == DIM and len(torsion_positions) == DIM)
    record["check_5_rho"] = {
        "matrix_rows": [[int(entry) for entry in row] for row in rho.rows()],
        "invertible": bool(rho.is_invertible()),
        "verified_on_all_generators": bool(rho * A2_mod2 == classes),
        "source": "F_2^10 = (^9 Lambda) (x) F_2 via gamma",
        "target": "Sat / L_3(^3 Lambda) in the Smith basis of the coordinate "
                  "matrix of L_3(^3 Lambda) inside Sat",
    }
    # Corroboration: integrality of the L_3-preimage of a combination and the
    # parity of its diagonal restriction cut out the same F_2 subspace of Z^940.
    note("5d ker(2 v mod 2) = ker(gamma mod 2) as subspaces of F_2^940",
         doubled.change_ring(field).right_kernel() == A2_mod2.right_kernel(),
         int(A2_mod2.right_kernel().dimension()))

    # =====================================================================
    # CHECK 6 -- the corrected test lattice H^
    # =====================================================================
    zero_252_10 = zero_matrix(ZZ, 252, DIM)
    zero_10_120 = zero_matrix(ZZ, DIM, 120)
    generators_hat = block_matrix(
        ZZ, [[L3, A1[:, :DIM], zero_252_10],
             [zero_10_120, A2[:, :DIM], 2 * identity_matrix(ZZ, DIM)]],
        subdivide=False)                                       # 262 x 140
    hat_basis = generators_hat.transpose().hermite_form(
        include_zero_rows=False)                               # 130 x 262
    note("6a H^ has rank 130", hat_basis.nrows() == 130 and hat_basis.rank() == 130)

    ambient = block_matrix(ZZ, [[SB, zero_matrix(ZZ, 120, DIM)],
                                [zero_matrix(ZZ, DIM, 252),
                                 identity_matrix(ZZ, DIM)]],
                           subdivide=False)                    # 130 x 262
    coord_hat = ambient.transpose().change_ring(QQ).solve_right(
        hat_basis.transpose().change_ring(QQ))                 # 130 x 130
    note("6b H^ is contained in Sat + Z^10",
         all(entry.denominator() == 1 for entry in coord_hat.list()))
    coord_hat = coord_hat.change_ring(ZZ)
    hat_index = abs(coord_hat.det())
    hat_index_divisors = elementary_divisor_counts(coord_hat)
    note("6c [Sat + Z^10 : H^] = 2^10", hat_index == 2 ** DIM, hat_index)
    note("6d (Sat + Z^10) / H^ = (Z/2)^10",
         hat_index_divisors == {"1": 120, "2": 10}, hat_index_divisors)

    first_block = hat_basis[:, :252]                           # 130 x 252
    second_block = hat_basis[:, 252:]                          # 130 x 10
    proj1_hnf = first_block.hermite_form(include_zero_rows=False)
    note("6e projection of H^ to the first block is onto Sat",
         proj1_hnf == sat_hnf)
    proj2_hnf = second_block.hermite_form(include_zero_rows=False)
    note("6f projection of H^ to the second block is onto Z^10",
         proj2_hnf == identity_matrix(ZZ, DIM))
    # Consistency: build H^ a second way, intrinsically, as the kernel of the
    # F_2-linear condition class(sigma) + rho(g) = 0 on Sat + Z^10, and compare
    # with the lattice generated by the three blocks (L_3 ^3 Lambda + 0), the
    # ten mixed columns, and (0 + 2 Z^10).
    condition = matrix(field, [smith_U.change_ring(field).row(i)
                               for i in torsion_positions]).augment(rho)
    note("6g the defining F_2 condition on Sat + Z^10 has rank 10",
         condition.rank() == DIM, int(condition.rank()))
    condition_kernel = condition.right_kernel()
    intrinsic_lifts = matrix(ZZ, [[int(entry) for entry in basis_vector]
                                  for basis_vector in condition_kernel.basis()]
                             ).transpose()                     # 130 x 120
    intrinsic_generators = intrinsic_lifts.augment(
        2 * identity_matrix(ZZ, 130))                          # 130 x 250
    intrinsic_coord = intrinsic_generators.transpose().hermite_form(
        include_zero_rows=False)                               # 130 x 130
    intrinsic_basis = intrinsic_coord * ambient                # 130 x 262
    intrinsic_hnf = intrinsic_basis.hermite_form(include_zero_rows=False)
    blocks_generate_exactly = bool(intrinsic_hnf == hat_basis)
    defect_coord = intrinsic_basis.transpose().change_ring(QQ).solve_right(
        hat_basis.transpose().change_ring(QQ))
    defect_integral = all(entry.denominator() == 1
                          for entry in defect_coord.list())
    if defect_integral:
        defect_divisors = elementary_divisor_counts(defect_coord.change_ring(ZZ))
        defect_index = int(abs(defect_coord.change_ring(ZZ).det()))
    else:
        defect_divisors = None
        defect_index = None
    note("6h the three generating blocks generate H^ exactly, matching the "
         "intrinsic kernel description",
         blocks_generate_exactly,
         f"index of the generated lattice in the intrinsic one: {defect_index}, "
         f"invariant factors {defect_divisors}")
    record["check_6_H_hat"] = {
        "rank": int(hat_basis.nrows()),
        "index_in_Sat_plus_Z10": int(hat_index),
        "index_elementary_divisors": hat_index_divisors,
        "first_block_projection_is_Sat": bool(proj1_hnf == sat_hnf),
        "second_block_projection_is_Z10":
            bool(proj2_hnf == identity_matrix(ZZ, DIM)),
        "three_blocks_generate_H_hat_exactly": blocks_generate_exactly,
        "generated_in_intrinsic_index": defect_index,
        "generated_in_intrinsic_invariant_factors": defect_divisors,
    }

    # =====================================================================
    # CHECK 7 -- the transfer image inside H^
    # =====================================================================
    coord_image = hat_basis.transpose().change_ring(QQ).solve_right(
        A.change_ring(QQ))                                     # 130 x 940
    note("7a the transfer image Im = col(A) is contained in H^",
         all(entry.denominator() == 1 for entry in coord_image.list()))
    coord_image = coord_image.change_ring(ZZ)
    reduced_image = coord_image.transpose().hermite_form(include_zero_rows=False)
    quotient_divisors = elementary_divisor_counts(reduced_image)
    image_rank = int(reduced_image.rank())
    free_rank_of_quotient = 130 - image_rank
    d2 = int(coord_image.change_ring(field).rank())
    note("7b Im has full rank 130 inside H^", image_rank == 130, image_rank)
    note("7c H^ / Im is finite", free_rank_of_quotient == 0,
         free_rank_of_quotient)
    record["check_7_transfer_image"] = {
        "Im_contained_in_H_hat": True,
        "rank_of_Im": image_rank,
        "H_hat_mod_Im_elementary_divisors": quotient_divisors,
        "H_hat_mod_Im_free_rank": int(free_rank_of_quotient),
        "H_hat_mod_Im_order": int(prod([ZZ(k) ** v for k, v
                                        in quotient_divisors.items()]))
                              if free_rank_of_quotient == 0 else None,
        "d2_dim_F2_image_of_Im_in_H_hat_mod_2": d2,
        "d2_is_full_130": bool(d2 == 130),
    }

    # =====================================================================
    # CHECK 8 -- the escape group E = Z^130 / ImTheta
    # =====================================================================
    # f_w[i] = < w ^ sigma(xi_i) > in ^10 Lambda = Z.  For w = e_S this is
    # orientation_sign(S) * sigma(xi_i)[complement(S)], by definition of
    # orientation_sign and linearity; the identity is spot-verified below
    # against the pass-7 `wedge` on canonical samples.
    five_position = {item: n for n, item in enumerate(five_sets)}
    escape_columns = []
    for indices in five_sets:
        sign = orientation_sign(indices)
        escape_columns.append(
            sign * first_block.column(five_position[complement(indices)]))
    ImTheta = matrix(ZZ, escape_columns).transpose()           # 130 x 252

    sampled = 0
    for row_index in [0, 1, 65, 129] + list(range(130)):
        form_here = {five_sets[n]: first_block[row_index, n]
                     for n in range(252) if first_block[row_index, n]}
        sample_sets = (five_sets if row_index in (0, 1, 65, 129)
                       else five_sets[::13])
        for indices in sample_sets:
            direct = wedge(basis_form(indices), form_here).get(TOP, 0)
            assert direct == ImTheta[row_index, five_position[indices]], \
                "top-wedge pairing disagrees with the pass-7 wedge"
            sampled += 1
    note("8a top-wedge pairing agrees with the pass-7 wedge on canonical samples",
         sampled > 0, f"{sampled} pairings verified directly")

    reduced_theta = ImTheta.transpose().hermite_form(include_zero_rows=False)
    theta_divisors = elementary_divisor_counts(reduced_theta)
    note("8b ImTheta has rank 120", reduced_theta.nrows() == 120)
    note("8c every elementary divisor of ImTheta is one",
         theta_divisors == {"1": 120}, theta_divisors)
    note("8d E := Z^130 / ImTheta is free of rank 10",
         set(theta_divisors) == {"1"} and 130 - 120 == DIM)
    record["check_8_escape_group"] = {
        "ImTheta_rank": int(reduced_theta.nrows()),
        "ImTheta_elementary_divisors": theta_divisors,
        "E_free_rank": int(130 - reduced_theta.nrows()),
        "E_is_free_Z10": bool(theta_divisors == {"1": 120}),
    }

    # =====================================================================
    # CHECK 9 -- the exceptional image inside E
    # =====================================================================
    exceptional_columns = []
    for index in range(DIM):
        entries = []
        for row_index in range(130):
            ninth = {nine_sets[n]: second_block[row_index, n]
                     for n in range(DIM) if second_block[row_index, n]}
            entries.append(wedge(ninth, basis_form((index,))).get(TOP, 0))
        exceptional_columns.append(vector(ZZ, entries))
    exceptional = matrix(ZZ, exceptional_columns).transpose()  # 130 x 10

    joint = ImTheta.augment(exceptional)                       # 130 x 262
    reduced_joint = joint.transpose().hermite_form(include_zero_rows=False)
    joint_divisors = elementary_divisor_counts(reduced_joint)
    note("9a ImTheta + <g_z> has full rank 130",
         reduced_joint.nrows() == 130, reduced_joint.nrows())
    note("9b (ImTheta + <g_z>) / ImTheta is free of rank 10",
         reduced_joint.nrows() - reduced_theta.nrows() == DIM)
    note("9c Z^130 / (ImTheta + <g_z>) = (Z/2)^10 exactly",
         joint_divisors == {"1": 120, "2": 10}, joint_divisors)
    note("9d the exceptional classes generate exactly 2E, i.e. "
         "E / (exceptional image) = (Z/2)^10",
         joint_divisors == {"1": 120, "2": 10}
         and theta_divisors == {"1": 120})
    record["check_9_exceptional_image"] = {
        "joint_rank": int(reduced_joint.nrows()),
        "joint_elementary_divisors": joint_divisors,
        "quotient_of_E_by_exceptional_image": "(Z/2)^10"
            if joint_divisors == {"1": 120, "2": 10} else str(joint_divisors),
        "exceptional_image_index_in_E": int(2 ** DIM),
    }

    # =====================================================================
    # CHECK 10 -- gate re-issue data (revision 2)
    # =====================================================================
    # The re-issued valid-test criterion for a direction a in Lambda is
    #     (L_3(Theta ^ a), 0)  in  Im + 2 H^,
    # i.e. its class in H^/2H^ = F_2^130 lies in the F_2-span of the classes of
    # the 940 transfer columns.  Nothing about the outcome is asserted a priori:
    # the verdict vector is measured and recorded.
    image_mod2 = coord_image.change_ring(field)                # 130 x 940
    reach = image_mod2.transpose().row_space()                 # subspace F_2^130
    assert reach.dimension() == d2

    def hat_coordinates(target):
        solution = hat_basis.transpose().change_ring(QQ).solve_right(
            target.change_ring(QQ))
        assert hat_basis.transpose().change_ring(QQ) * solution \
            == target.change_ring(QQ)
        return solution

    # ---- 10a: V_0, both readings -------------------------------------------
    # V_0(exact)  = {x : (L_3 x, 0) in Im}            (second block exactly 0)
    # V_0(even)   = L_3-preimages of the first blocks of the even part of Im
    exact_kernel = A2.right_kernel_matrix().transpose()        # 940 x 930
    even_kernel = A2_mod2.right_kernel()
    even_lifts = (matrix(ZZ, [[int(entry) for entry in basis_vector]
                              for basis_vector in even_kernel.basis()]
                         ).transpose() if even_kernel.dimension()
                  else zero_matrix(ZZ, 940, 0))                # 940 x k
    preimages_exact = X * exact_kernel.change_ring(QQ)
    preimages_even = X * even_lifts.change_ring(QQ)
    note("10a-i the exactly-even part of Im is integrally L_3-solvable",
         all(entry.denominator() == 1 for entry in preimages_exact.list()),
         f"exact gamma-kernel rank {exact_kernel.ncols()}")
    note("10a-ii the mod-two-even part of Im is integrally L_3-solvable",
         all(entry.denominator() == 1 for entry in preimages_even.list()),
         f"mod-two gamma-kernel dimension {even_kernel.dimension()}")
    V0_exact = preimages_exact.change_ring(ZZ)
    V0_even = preimages_even.change_ring(ZZ).augment(doubled)
    v0_exact_space = V0_exact.change_ring(field).transpose().row_space()
    v0_even_space = V0_even.change_ring(field).transpose().row_space()
    theta_wedge_a = [vector(field, lefschetz_13.change_ring(field).row(index))
                     for index in range(DIM)]
    old_in_v0_exact = [bool(target in v0_exact_space)
                       for target in theta_wedge_a]
    old_in_v0_even = [bool(target in v0_even_space) for target in theta_wedge_a]

    # ---- 10b: the re-issued gate on the ten a-directions --------------------
    theta_tests = matrix(ZZ, [list(L3 * vector(ZZ, lefschetz_13.row(index)))
                              + [0] * DIM for index in range(DIM)]).transpose()
    theta_hat = hat_coordinates(theta_tests)
    note("10b-i (L_3(Theta ^ a), 0) lies in H^ for each of the ten directions",
         all(entry.denominator() == 1 for entry in theta_hat.list()))
    theta_hat = theta_hat.change_ring(ZZ)
    reissued_gate = [bool(vector(field, theta_hat.column(index)) in reach)
                     for index in range(DIM)]
    note("10b-ii the re-issued gate verdict for the ten a-directions is "
         "measured and recorded (no value assumed)",
         len(reissued_gate) == DIM, reissued_gate)

    # ---- 10c: the ten new (exceptional / X-block) directions ----------------
    # (0, g_k) itself is in H^ only for g_k even, so the intrinsic first test is
    # the purely-exceptional lattice element (0, 2 e_k).  The coset test asks
    # whether the whole set of xi in H^ with gamma(xi) = e_k mod 2 is covered.
    exceptional_tests = matrix(ZZ, [[0] * 252 + [2 if j == index else 0
                                                 for j in range(DIM)]
                                    for index in range(DIM)]).transpose()
    exceptional_hat = hat_coordinates(exceptional_tests)
    note("10c-i (0, 2 e_k) lies in H^ for each k",
         all(entry.denominator() == 1 for entry in exceptional_hat.list()))
    exceptional_hat = exceptional_hat.change_ring(ZZ)
    new_direction_gate = [
        bool(vector(field, exceptional_hat.column(index)) in reach)
        for index in range(DIM)]
    gamma_mod2 = second_block.transpose().change_ring(field)   # 10 x 130
    reach_gamma = (matrix(field, [gamma_mod2 * basis_vector
                                  for basis_vector in reach.basis()]).row_space()
                   if reach.dimension() else
                   VectorSpace(field, DIM).zero_submodule())
    gamma_kernel_in_reach = all(
        basis_vector in reach for basis_vector in gamma_mod2.right_kernel().basis())
    coset_meets_image = [bool(vector(field, [1 if j == index else 0
                                             for j in range(DIM)]) in reach_gamma)
                         for index in range(DIM)]
    coset_fully_covered = [bool(coset_meets_image[index] and gamma_kernel_in_reach)
                           for index in range(DIM)]
    note("10c-ii the exceptional-direction verdicts are measured and recorded",
         len(new_direction_gate) == DIM, new_direction_gate)
    gamma_projection_hnf = A2.transpose().hermite_form(include_zero_rows=False)
    note("10c-iii the gamma-projection of Im is all of Z^10 (the ten new "
         "directions are hit integrally)",
         gamma_projection_hnf == identity_matrix(ZZ, DIM))

    # ---- 10d: the conservative old-style gate (gamma = 0 mod 4) -------------
    quarter_system = A2.augment(-4 * identity_matrix(ZZ, DIM))   # 10 x 950
    quarter_kernel = quarter_system.right_kernel_matrix()        # rows in Z^950
    quarter_lifts = matrix(ZZ, [list(row)[:940]
                                for row in quarter_kernel.rows()]).transpose()
    quarter_check = A2 * quarter_lifts
    note("10d-i the selected sublattice really has gamma = 0 mod four",
         all(entry % 4 == 0 for entry in quarter_check.list()))
    preimages_quarter = X * quarter_lifts.change_ring(QQ)
    note("10d-ii that sublattice is integrally L_3-solvable in the first block",
         all(entry.denominator() == 1 for entry in preimages_quarter.list()))
    V0_quarter = preimages_quarter.change_ring(ZZ)
    v0_quarter_space = V0_quarter.change_ring(field).transpose().row_space()
    conservative_gate = [bool(target in v0_quarter_space)
                         for target in theta_wedge_a]
    note("10d-iii the conservative old-style gate verdict is measured and "
         "recorded", len(conservative_gate) == DIM, conservative_gate)

    record["check10_revision"] = 2
    record["check_10_gate_reissue"] = {
        "criterion": "(L_3(Theta ^ a), 0) in Im + 2 H^",
        "ambient_dim_of_cubics": 120,
        "dim_F2_of_V0_exact_mod_2": int(v0_exact_space.dimension()),
        "dim_F2_of_V0_even_mod_2": int(v0_even_space.dimension()),
        "theta_wedge_a_in_V0_exact": old_in_v0_exact,
        "theta_wedge_a_in_V0_even": old_in_v0_even,
        "reissued_gate_per_a_direction": reissued_gate,
        "reissued_gate_open_directions": int(sum(1 for v in reissued_gate if v)),
        "exceptional_0_2ek_reachable_per_direction": new_direction_gate,
        "exceptional_coset_meets_image": coset_meets_image,
        "exceptional_coset_fully_covered": coset_fully_covered,
        "gamma_kernel_of_H_hat_mod_2_inside_reach": bool(gamma_kernel_in_reach),
        "gamma_projection_of_Im_is_Z10":
            bool(gamma_projection_hnf == identity_matrix(ZZ, DIM)),
        "conservative_old_style_gate_per_a_direction": conservative_gate,
        "dim_F2_of_V0_quarter_mod_2": int(v0_quarter_space.dimension()),
        "d2_mod_two_reach_in_H_hat": d2,
        "codim_of_reach_in_H_hat_mod_2": int(130 - d2),
    }

    # =====================================================================
    # CHECK 11 -- rank of psi_* on the 940 columns
    # =====================================================================
    psi_rank = int(A1.rank())
    note("11 rank(psi_*) on the 940 generators is recorded",
         psi_rank == 120, psi_rank)
    record["check_11_psi_rank"] = {
        "rank_of_psi_star_first_block": psi_rank,
        "rank_of_A": int(A.rank()),
        "rank_of_gamma_second_block": int(A2.rank()),
    }

    # =====================================================================
    # CHECK 12 -- cross-check against the committed gate-A record
    # =====================================================================
    with open(GATE_A_JSON, encoding="utf-8") as stream:
        gate_a = json.load(stream)
    gate_pre = gate_a["L3_preimage"]
    gate_anom = gate_a["anomaly_equals_condition_ii"]
    note("12a gate-A generator count agrees", gate_pre["generators"] == 940)
    note("12b gate-A denominator-two count is 626 and agrees with CHECK 3",
         gate_pre["generators_with_denominator_two"] == 626 == len(half_set))
    note("12c gate-A integral-preimage count agrees",
         gate_pre["generators_with_integral_preimage"] == len(integral_rows),
         len(integral_rows))
    note("12d gate-A odd-diagonal count agrees",
         gate_anom["generators_with_odd_i_Delta_restriction"] == len(odd_set))
    note("12e gate-A records the two sets coincide, as re-derived here",
         gate_anom["the_two_sets_coincide"] is True and half_set == odd_set)
    note("12f the per-block denominator profile agrees generator by generator",
         gate_pre["denominator_profile_by_block"] == denominator_profile,
         denominator_profile)
    note("12g gate-A L_3 Smith form agrees",
         gate_a["lefschetz"]["L_3_to_5_divisors"] == counts_35)
    record["check_12_cross_check"] = {
        "gate_a_json": GATE_A_JSON,
        "gate_a_sha256": record["inputs"][GATE_A_JSON],
        "denominator_profile_matches": True,
        "counts_match": True,
    }

    # ------------------------------------------------------------ machine ----
    record["matrices"] = {
        "encoding": "one string per column, entries space separated",
        "A_262_by_940": _encode_columns(A),
        "L3_252_by_120": _encode_columns(L3),
        "generator_labels": labels,
        "A_row_blocks": {"psi_star_wedge5": [0, 252],
                         "gamma_wedge9": [252, 262]},
    }
    record["checks"] = checks
    record["all_checks_pass"] = bool(all(item["pass"] for item in checks))
    record["wall_seconds"] = float(round(time.time() - _STARTED, 2))

    lines = [
        "C908 pass-9: adjudication of the corrected H^3(M,Z) test lattice",
        f"pass-7 shared machinery re-certifies: {PASS7_CONTROLS_PASS} "
        f"({len(pass7_lines)} lines, ending PASS)",
        "",
        f"L_3 : ^3 Lambda -> ^5 Lambda   Smith {counts_35}   rank {L3.rank()}",
        f"[Sat : L_3(^3 Lambda)] = {sat_index} = 2^{DIM}; quotient "
        f"{counts_index} = (Z/2)^10",
        f"generators escaping L_3(^3 Lambda) = {len(half_set)} = generators with "
        f"odd gamma = {len(odd_set)}",
        f"L_3(^3 Lambda) + Z<psi_* T> = Sat: {combined_hnf == sat_hnf}",
        f"rho : F_2^10 -> Sat/L_3(^3 Lambda) invertible: {rho.is_invertible()}; "
        f"verified on all 940: {rho * A2_mod2 == classes}",
        "",
        f"H^ rank {hat_basis.nrows()}; [Sat + Z^10 : H^] = {hat_index}; "
        f"divisors {hat_index_divisors}",
        f"Im = col(A) inside H^: True; rank {image_rank}; "
        f"H^/Im divisors {quotient_divisors}; free rank {free_rank_of_quotient}",
        f"d2 = dim_F2 Im in H^/2H^ = {d2} (of 130)",
        "",
        f"ImTheta rank {reduced_theta.nrows()} divisors {theta_divisors} "
        f"-> E = Z^130/ImTheta free of rank {130 - reduced_theta.nrows()}",
        f"ImTheta + <g_z> rank {reduced_joint.nrows()} divisors "
        f"{joint_divisors} -> E/(exceptional image) = (Z/2)^10, index "
        f"{2 ** DIM}",
        "",
        f"V_0 mod two: dim {v0_exact_space.dimension()} (exact) / "
        f"{v0_even_space.dimension()} (even) / "
        f"{v0_quarter_space.dimension()} (gamma = 0 mod 4), of 120",
        f"re-issued gate (L_3(Theta ^ a), 0) in Im + 2H^: {reissued_gate}",
        f"exceptional (0, 2 e_k) in Im + 2H^: {new_direction_gate}",
        f"exceptional coset meets Im + 2H^: {coset_meets_image}; fully covered: "
        f"{coset_fully_covered}",
        f"conservative old-style gate (gamma = 0 mod 4): {conservative_gate}",
        f"Theta ^ a inside V_0 mod two (exact / even): {old_in_v0_exact} / "
        f"{old_in_v0_even}",
        f"gamma-projection of Im is Z^10 (ten new directions): "
        f"{gamma_projection_hnf == identity_matrix(ZZ, DIM)}",
        f"rank psi_* = {psi_rank}; rank A = {A.rank()}; rank gamma = {A2.rank()}",
        "",
        "checks:",
    ]
    for item in checks:
        lines.append(f"  [{'PASS' if item['pass'] else 'FAIL'}] {item['check']}"
                     + (f"  ({item['detail']})" if item["detail"] else ""))
    lines += [
        "",
        f"wall seconds: {record['wall_seconds']}",
        "PASS" if record["all_checks_pass"] else "FAIL",
    ]
    output = "\n".join(lines) + "\n"

    if json_path:
        with open(json_path, "w", encoding="utf-8") as stream:
            json.dump(canonicalize(record), stream, indent=1, sort_keys=True)
            stream.write("\n")
    if out_path:
        with open(out_path, "w", encoding="utf-8") as stream:
            stream.write(output)
    print(output, end="")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--json")
    parser.add_argument("--out")
    arguments = parser.parse_args()
    adjudication_main(arguments.json, arguments.out)
