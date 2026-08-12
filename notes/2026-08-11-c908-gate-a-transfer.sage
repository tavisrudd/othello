#!/usr/bin/env sage
"""C908 pass-8 certificate: the lambda-bit gate A.

Reuses the committed pass-7 machinery verbatim by loading
`notes/2026-08-11-c908-span-incidence-residues.sage`, which (a) re-runs every
pass-7 control as an assertion suite on the shared functions and (b) supplies
the form arithmetic, Poincare duality, the Pontryagin product, the slot
calculus and the Lefschetz matrices.

Setting.  The lambda-bit route reads the universal-family residue through the
degree-six model q : Y = Bl_Delta(F x F) -> M.  Downstairs the test class is
h . b^*a = b^*(Theta ^ a) in H^3(M), a in Lambda.  For T'' in H^3(F x F),

    b_*(q_* mu^* T'') = psi_* T''  in ^5 Lambda,

and H^3(M) = b^* ^3 Lambda with b_* b^* v = Theta ^ v = L_3(v).  L_3 is
injective with Smith form 1^110 2^10 (corpus a5-commutant certificate), so

    v(T'') := L_3^{-1}(psi_* T'')  in ^3 Lambda

is well defined whenever psi_* T'' lies in im L_3 over Z; integral solvability
is asserted for every generator.

GATE A, both mod two:
  (i)  v(T'') = Theta ^ a       in ^3 Lambda (x) F_2
  (ii) i_Delta^* T'' = 0        in H^3(F) (x) F_2, read through the
       isomorphism a_* : H^3(F)/tors -> ^9 Lambda

Integral generating set for the torsion-free Kunneth H^3(F x F):
  H^3 (x) H^0   beta_m (x) 1,  a_* beta_m = the m-th ^9 Lambda basis vector
  H^0 (x) H^3   1 (x) beta_m
  H^2 (x) H^1   (a^*e_I) (x) (a^*e_k)  and  C_s (x) (a^*e_k)
  H^1 (x) H^2   (a^*e_k) (x) (a^*e_I)  and  (a^*e_k) (x) C_s

psi_*(x (x) y) = (-1)^{deg x}(a_* x) * (a_* y);  i_Delta^*(x (x) y) = x . y in
the one-slot F-calculus.

No randomness; canonical lexicographic enumeration throughout.
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

# Loading the pass-7 script re-runs its full control suite (every control is an
# in-script assertion) and leaves all of its functions in this namespace.
_GATE_ARGV = list(sys.argv)
sys.argv = [sys.argv[0]]
_pass7_stream = StringIO()
with redirect_stdout(_pass7_stream):
    load(PASS7)
    if "PASS" not in _pass7_stream.getvalue():
        main(None, None)                      # noqa: F821  (pass-7 main)
sys.argv = _GATE_ARGV
PASS7_OUTPUT = _pass7_stream.getvalue()
PASS7_CONTROLS_PASS = PASS7_OUTPUT.rstrip().endswith("PASS")
assert PASS7_CONTROLS_PASS, "the shared pass-7 machinery no longer certifies"

SCHEMA_VERSION = "c908-gate-a-transfer/1"
REPLAY_COMMAND = (
    "cd /home/tavis/src/othello && nix shell nixpkgs#sage -c sage "
    "notes/2026-08-11-c908-gate-a-transfer.sage --json notes/2026-08-11-c908-gate-a-transfer.json "
    "--out notes/2026-08-11-c908-gate-a-transfer.out"
)


def gate_a_main(json_path=None, out_path=None):
    record = {"schema": SCHEMA_VERSION, "replay_command": REPLAY_COMMAND}
    field = GF(2)

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

    # ---- Lefschetz maps ----------------------------------------------------
    _, _, lefschetz_13 = lefschetz_matrix(theta, 1)
    counts_13 = elementary_divisor_counts(lefschetz_13)
    cubics, quintics, lefschetz_35 = lefschetz_matrix(theta, 3)
    counts_35 = elementary_divisor_counts(lefschetz_35)
    record["lefschetz"] = {
        "L_1_to_3_shape": [int(lefschetz_13.nrows()), int(lefschetz_13.ncols())],
        "L_1_to_3_divisors": counts_13,
        "L_1_to_3_saturated": bool(set(counts_13) == {"1"}),
        "L_3_to_5_shape": [int(lefschetz_35.nrows()), int(lefschetz_35.ncols())],
        "L_3_to_5_rank": int(lefschetz_35.rank()),
        "L_3_to_5_divisors": counts_35,
        "L_3_to_5_matches_corpus_smith_form":
            bool(counts_35 == {"1": 110, "2": 10}),
    }
    assert set(counts_13) == {"1"}
    assert counts_35 == {"1": 110, "2": 10}
    assert lefschetz_35.rank() == len(cubics) == 120

    nine_sets = list(combinations(range(DIM), 9))
    assert len(nine_sets) == DIM

    # ---- a_* on the legs, memoized ----------------------------------------
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

    # ---- the generating set ------------------------------------------------
    generators = []          # (label, psi_* form in ^5, i_Delta^* form in ^9)

    # H^3 (x) H^0 and H^0 (x) H^3
    for m in range(DIM):
        generators.append((
            f"beta{m}(x)1",
            psi_push(push_h3[m], 3, push_unit),
            dict(push_h3[m])))
    for m in range(DIM):
        generators.append((
            f"1(x)beta{m}",
            psi_push(push_unit, 0, push_h3[m]),
            dict(push_h3[m])))

    # H^2 (x) H^1
    for pair in two_indices:
        restricted = {}
        for index in range(DIM):
            product = wedge(basis_form(pair), basis_form((index,)))
            restricted[index] = wedge(product, divided[3]) if product else {}
        for index in range(DIM):
            generators.append((
                f"a*e{pair[0]}{pair[1]}(x)a*e{index}",
                psi_push(push_h2[pair], 2, push_h1[index]),
                restricted[index]))
    for index in range(DIM):
        generators.append((
            f"Cs(x)a*e{index}",
            psi_push(push_cs, 2, push_h1[index]),
            scale_form(2, wedge(divided[4], basis_form((index,))))))

    # H^1 (x) H^2
    for index in range(DIM):
        for pair in two_indices:
            product = wedge(basis_form((index,)), basis_form(pair))
            generators.append((
                f"a*e{index}(x)a*e{pair[0]}{pair[1]}",
                psi_push(push_h1[index], 1, push_h2[pair]),
                wedge(product, divided[3]) if product else {}))
    for index in range(DIM):
        generators.append((
            f"a*e{index}(x)Cs",
            psi_push(push_h1[index], 1, push_cs),
            scale_form(2, wedge(divided[4], basis_form((index,))))))

    for label, quintic, ninth in generators:
        for indices in quintic:
            assert len(indices) == 5, f"{label}: psi_* is not in ^5 Lambda"
        for indices in ninth:
            assert len(indices) == 9, f"{label}: i_Delta^* is not in ^9 Lambda"

    # ---- v(T'') = L_3^{-1}(psi_* T'') --------------------------------------
    quintic_matrix = matrix(ZZ, [list(form_vector(item[1], 5))
                                 for item in generators])
    rational = lefschetz_35.change_ring(QQ).solve_left(
        quintic_matrix.change_ring(QQ))
    rationally_solvable = bool(rational * lefschetz_35.change_ring(QQ)
                               == quintic_matrix.change_ring(QQ))
    assert rationally_solvable, "psi_* leaves the rational image of L_3"
    denominators = [ZZ(lcm([entry.denominator() for entry in row]))
                    for row in rational.rows()]
    integral_rows = [n for n, den in enumerate(denominators) if den == 1]
    half_rows = [n for n, den in enumerate(denominators) if den == 2]
    assert len(integral_rows) + len(half_rows) == len(generators), \
        "an L_3-preimage denominator other than one or two appeared"

    # w := 2 v, always integral.  v is integral exactly when w is even.
    doubled = (2 * rational).change_ring(ZZ)
    assert bool(doubled * lefschetz_35 == 2 * quintic_matrix)

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

    denominator_profile = {}
    for n, den in enumerate(denominators):
        bucket = denominator_profile.setdefault(block_name(n), {})
        bucket[str(den)] = bucket.get(str(den), 0) + 1

    record["L3_preimage"] = {
        "generators": int(len(generators)),
        "every_psi_pushforward_lies_in_im_L3_over_Q": rationally_solvable,
        "every_psi_pushforward_lies_in_im_L3_over_Z":
            bool(len(half_rows) == 0),
        "generators_with_integral_preimage": int(len(integral_rows)),
        "generators_with_denominator_two": int(len(half_rows)),
        "denominator_profile_by_block": denominator_profile,
        "LOUD_FLAG":
            None if not half_rows else
            "psi_* of the integral generating set of H^3(F x F) lands in the "
            "SATURATION of im L_3 but not in im L_3 itself: 626-of-940 "
            "generators have L_3-preimage with denominator exactly two, and "
            "that set is EXACTLY the set of generators with odd diagonal "
            "restriction (see anomaly_equals_condition_ii). So the blanket "
            "assertion 'v is integral for every generator' is too strong, but "
            "gate A is internally consistent: its condition (ii) is precisely "
            "the well-definedness of v. What remains genuinely open is the "
            "geometry. Since b_* kills torsion and b_* b^* = L_3, an odd-"
            "diagonal T'' with psi_* T'' outside im L_3 contradicts "
            "b^* : H^3(J,Z) -> H^3(M,Z) being SURJECTIVE. The pass-2 Theorem 1 "
            "proof of that surjectivity uses H^k(Theta \\ 0) = H^k(Theta) for "
            "k <= 6, which is the manifold statement; Theta has an ordinary "
            "triple point, so the local cohomology H^3_{0}(Theta) need not "
            "vanish and the step has a gap exactly where a two-torsion "
            "cokernel would sit. The numerology lines up on three sides: "
            "coker(L_3) = (Z/2)^10, the observed escape has exponent two, and "
            "H^3(X,Z) = Z^10 for the exceptional cubic threefold X. Concrete "
            "lead: b_* H^3(M,Z) / L_3(^3 Lambda) is (Z/2)^10 detected by the "
            "diagonal restriction mod two. NOT adjudicated here.",
    }

    # Is the integrality anomaly exactly gate condition (ii)?
    delta_probe = matrix(field, [list(form_vector(item[2], 9))
                                 for item in generators])
    odd_delta = {n for n in range(len(generators))
                 if delta_probe.row(n) != 0}
    half_set = set(half_rows)
    record["anomaly_equals_condition_ii"] = {
        "generators_with_denominator_two": int(len(half_set)),
        "generators_with_odd_i_Delta_restriction": int(len(odd_delta)),
        "the_two_sets_coincide": bool(half_set == odd_delta),
        "meaning": "gate condition (ii) is not an extra constraint layered on "
                   "a well-defined v: on this generating set it is EXACTLY the "
                   "condition that makes v integral. A generator fails the "
                   "L_3-preimage integrality precisely when its diagonal "
                   "restriction is odd.",
    }

    h3_h0_denominators = sorted({int(denominators[m]) for m in range(2 * DIM)})
    record["L3_preimage"]["h3_tensor_h0_denominators"] = h3_h0_denominators

    # ---- the exact mod-two gate, carried out over Z/4 ----------------------
    # v is only half-integral, so condition (i) is not an F_2-linear condition
    # on the coefficient vector c; it is a Z/4 one.  Writing w = 2v, the
    # integral-v sublattice is N = {c : c.W = 0 mod 2} and, for c in N,
    # v(c) mod 2 = ((1/2) c.W) mod 2 depends on c mod 4.  A short computation
    # gives the reachable set exactly:
    #   Vbar = span{ (kappa_i . W)/2 mod 2 } + rowspace(W mod 2)
    # where kappa_i lift a basis of the left kernel of W mod two.  When every
    # v is integral this collapses to the naive rowspace(V mod 2).
    delta_matrix = matrix(ZZ, [list(form_vector(item[2], 9))
                               for item in generators])
    lefschetz_13_mod2 = lefschetz_13.change_ring(field)
    assert lefschetz_13_mod2.rank() == DIM, "L_1 mod two is not injective"

    doubled_mod2 = doubled.change_ring(field)
    ambient_cubics = VectorSpace(field, doubled.ncols())
    base_space = doubled_mod2.row_space()

    def reachable_space(extra_columns):
        """Vbar for the system with the given extra mod-two constraints."""
        if extra_columns is None:
            constrained = doubled_mod2
        else:
            constrained = doubled_mod2.augment(extra_columns.change_ring(field))
        kernel = constrained.left_kernel()
        rows = []
        if kernel.dimension():
            lifts = matrix(ZZ, [[int(x) for x in row]
                                for row in kernel.basis()])
            halved = lifts * doubled
            for entry in halved.list():
                assert entry % 2 == 0, "kernel lift is not even"
            halved = (halved / 2).change_ring(ZZ)
            rows = [vector(field, row) for row in halved.rows()]
        rows.extend(base_space.basis())
        if not rows:
            return ambient_cubics.zero_submodule(), kernel
        return matrix(field, rows).row_space(), kernel

    unconstrained, free_kernel = reachable_space(None)
    constrained, gate_kernel = reachable_space(delta_matrix)
    kernel = gate_kernel

    def reachable_directions(subspace):
        """{a in Lambda_2 : Theta ^ a lies in `subspace`}."""
        basis_rows = list(subspace.basis())
        stacked = matrix(field,
                         list(lefschetz_13_mod2.rows()) + basis_rows)
        projected = [vector(field, list(row)[:DIM])
                     for row in stacked.left_kernel().basis()]
        if not projected:
            return VectorSpace(field, DIM).zero_submodule()
        return matrix(field, projected).row_space()

    reachable_free = reachable_directions(unconstrained)
    reachable_gate = reachable_directions(constrained)

    per_direction = []
    for index in range(DIM):
        target = vector(field, lefschetz_13_mod2.row(index))
        per_direction.append({
            "direction": f"e{index}",
            "theta_wedge_e_in_unconstrained_image": bool(target in unconstrained),
            "theta_wedge_e_in_delta_constrained_image":
                bool(target in constrained),
        })

    record["item_1_dimensions"] = {
        "generators": int(len(generators)),
        "dim_F2_of_V_mod_two": int(unconstrained.dimension()),
        "dim_F2_of_the_joint_kernel": int(gate_kernel.dimension()),
        "dim_F2_of_the_integrality_kernel": int(free_kernel.dimension()),
        "dim_F2_of_delta_constrained_image": int(constrained.dimension()),
        "rank_of_i_Delta_mod_two":
            int(delta_matrix.change_ring(field).rank()),
        "ambient_dim_of_cubics": int(doubled.ncols()),
        "note": "V is the image of the integrality-constrained coefficient "
                "lattice under v = (1/2) c.W mod two; it is NOT the naive "
                "rowspace of v, which does not exist over Z",
    }
    record["item_2_per_basis_direction"] = per_direction
    record["item_3_reachable_a"] = {
        "dim_of_reachable_a_unconstrained": int(reachable_free.dimension()),
        "dim_of_reachable_a_under_gate_A": int(reachable_gate.dimension()),
        "reachable_a_unconstrained_is_all_of_Lambda_2":
            bool(reachable_free.dimension() == DIM),
        "reachable_a_under_gate_A_is_all_of_Lambda_2":
            bool(reachable_gate.dimension() == DIM),
        "basis_of_reachable_a_unconstrained":
            [[int(x) for x in row] for row in reachable_free.basis()],
        "basis_of_reachable_a_under_gate_A":
            [[int(x) for x in row] for row in reachable_gate.basis()],
    }

    # ---- extra structural diagnostics --------------------------------------
    blocks = {
        "H3(x)H0": list(range(0, DIM)),
        "H0(x)H3": list(range(DIM, 2 * DIM)),
        "H2(x)H1": list(range(2 * DIM, 2 * DIM + len(two_indices) * DIM + DIM)),
    }
    start = 2 * DIM + len(two_indices) * DIM + DIM
    blocks["H1(x)H2"] = list(range(start, len(generators)))
    def block_space(rows, with_delta):
        sub_w = matrix(ZZ, [doubled.row(r) for r in rows])
        sub_w2 = sub_w.change_ring(field)
        system = (sub_w2.augment(
            matrix(field, [delta_matrix.row(r) for r in rows]))
            if with_delta else sub_w2)
        sub_kernel = system.left_kernel()
        collected = []
        if sub_kernel.dimension():
            lifts = matrix(ZZ, [[int(x) for x in row]
                                for row in sub_kernel.basis()])
            halved = lifts * sub_w
            for entry in halved.list():
                assert entry % 2 == 0
            collected = [vector(field, row)
                         for row in (halved / 2).change_ring(ZZ).rows()]
        collected.extend(sub_w2.row_space().basis())
        if not collected:
            return ambient_cubics.zero_submodule()
        return matrix(field, collected).row_space()

    block_report = {}
    for name, rows in blocks.items():
        free_space = block_space(rows, False)
        gate_space = block_space(rows, True)
        sub_delta = matrix(field, [delta_matrix.row(r) for r in rows])
        block_report[name] = {
            "generators": int(len(rows)),
            "dim_v_image": int(free_space.dimension()),
            "dim_i_Delta_image": int(sub_delta.row_space().dimension()),
            "dim_v_image_of_delta_kernel": int(gate_space.dimension()),
            "dim_reachable_a": int(reachable_directions(free_space).dimension()),
            "dim_reachable_a_under_gate":
                int(reachable_directions(gate_space).dimension()),
        }
    record["block_profile"] = block_report

    # ---- the "as intended" variant ----------------------------------------
    # The exact answer above is driven by DOUBLED classes: for any generator g
    # with half-integral v, the integral class 2g has v(2g) = w odd, and
    # i_Delta^*(2g) is automatically even, so it clears both gate conditions.
    # That route exists only because of the integrality anomaly.  This variant
    # is what gate A computes if one restricts to the sub-generating set on
    # which v is defined generator-wise, i.e. the computation as specified.
    naive_v = matrix(field, [[int(x) for x in (doubled.row(r) / 2)]
                             for r in integral_rows])
    naive_delta = matrix(field, [delta_matrix.row(r) for r in integral_rows])
    naive_free = naive_v.row_space()
    naive_kernel = naive_delta.left_kernel()
    naive_rows = [row * naive_v for row in naive_kernel.basis()]
    naive_gate = (matrix(field, naive_rows).row_space() if naive_rows
                  else ambient_cubics.zero_submodule())
    naive_reach_free = reachable_directions(naive_free)
    naive_reach_gate = reachable_directions(naive_gate)
    naive_directions = []
    for index in range(DIM):
        target = vector(field, lefschetz_13_mod2.row(index))
        naive_directions.append({
            "direction": f"e{index}",
            "unconstrained": bool(target in naive_free),
            "gate_A": bool(target in naive_gate),
        })
    record["item_5_as_intended_variant"] = {
        "generators_used": int(len(integral_rows)),
        "dim_F2_of_V_mod_two": int(naive_free.dimension()),
        "dim_F2_of_ker_i_Delta": int(naive_kernel.dimension()),
        "dim_F2_of_delta_constrained_image": int(naive_gate.dimension()),
        "dim_of_reachable_a_unconstrained": int(naive_reach_free.dimension()),
        "dim_of_reachable_a_under_gate_A": int(naive_reach_gate.dimension()),
        "per_basis_direction": naive_directions,
        "basis_of_reachable_a_under_gate_A":
            [[int(x) for x in row] for row in naive_reach_gate.basis()],
        "caveat": "this restricts to the 314 generators whose L_3-preimage is "
                  "integral; it is NOT the answer for the full integral "
                  "H^3(F x F), which is item 3",
    }

    pass7_lines = PASS7_OUTPUT.strip().splitlines()
    record["controls"] = {
        "pass7_shared_machinery_certifies": bool(PASS7_CONTROLS_PASS),
        "pass7_output_lines": int(len(pass7_lines)),
        "L_3_solvability_over_Q_for_every_generator":
            bool(rationally_solvable),
        "L_3_solvability_over_Z_for_every_generator":
            bool(len(half_rows) == 0),
        "psi_of_H3_tensor_H0_lands_in_im_L3_over_Z":
            bool(h3_h0_denominators == [1]),
        "h3_tensor_h0_denominators": h3_h0_denominators,
        "L_1_mod_two_injective": bool(lefschetz_13_mod2.rank() == DIM),
        "L_3_smith_form_matches_corpus":
            record["lefschetz"]["L_3_to_5_matches_corpus_smith_form"],
    }
    record["inputs"] = {
        PASS7: sha256_of(PASS7),
        CORPUS: sha256_of(CORPUS),
    }
    record["wall_seconds"] = float(round(time.time() - _STARTED, 2))

    item1 = record["item_1_dimensions"]
    item3 = record["item_3_reachable_a"]
    lines = [
        "C908 pass-8 gate A: the lambda-bit transfer certificate",
        f"shared pass-7 machinery re-certifies: {PASS7_CONTROLS_PASS} "
        f"({len(pass7_lines)} lines of pass-7 output, ending PASS)",
        f"L_1 : Lambda -> ^3 Lambda divisors={record['lefschetz']['L_1_to_3_divisors']}"
        f" saturated={record['lefschetz']['L_1_to_3_saturated']}",
        f"L_3 : ^3 Lambda -> ^5 Lambda rank={record['lefschetz']['L_3_to_5_rank']}"
        f" divisors={record['lefschetz']['L_3_to_5_divisors']}"
        f" matches corpus={record['lefschetz']['L_3_to_5_matches_corpus_smith_form']}",
        f"L_3-preimage rational for all {item1['generators']} generators: "
        f"{rationally_solvable}; INTEGRAL for all: {len(half_rows) == 0} "
        f"({len(integral_rows)} integral, {len(half_rows)} with denominator two)",
        f"denominator profile by block: {denominator_profile}",
        f"H^3(x)H^0 generator denominators: {h3_h0_denominators}",
        f"denominator-two set equals the odd-i_Delta set: "
        f"{record['anomaly_equals_condition_ii']['the_two_sets_coincide']}"
        f" ({record['anomaly_equals_condition_ii']['generators_with_odd_i_Delta_restriction']}"
        f" generators with odd diagonal restriction)",
        ("LOUD FLAG: " + record["L3_preimage"]["LOUD_FLAG"].split(". ")[0] + "."
         if record["L3_preimage"]["LOUD_FLAG"] else
         "no integrality anomaly"),
        "",
        f"(1) dim_F2 V mod two = {item1['dim_F2_of_V_mod_two']} "
        f"inside ^3 Lambda (x) F_2 of dimension {item1['ambient_dim_of_cubics']}",
        f"(1) rank of i_Delta^* mod two = {item1['rank_of_i_Delta_mod_two']}"
        f"; dim of the joint (integrality + Delta) kernel = "
        f"{item1['dim_F2_of_the_joint_kernel']}"
        f"; dim v(joint kernel) = {item1['dim_F2_of_delta_constrained_image']}",
        "",
        "(2) per basis direction: Theta ^ e_i reachable?",
        "     direction  unconstrained  gate-A-constrained",
    ]
    for entry in per_direction:
        lines.append(
            f"     {entry['direction']:<10} "
            f"{str(entry['theta_wedge_e_in_unconstrained_image']):<14} "
            f"{entry['theta_wedge_e_in_delta_constrained_image']}")
    lines += [
        "",
        f"(3) reachable a-directions: unconstrained dim="
        f"{item3['dim_of_reachable_a_unconstrained']}/{DIM}"
        f"; under gate A dim={item3['dim_of_reachable_a_under_gate_A']}/{DIM}",
        f"(3) gate A reaches all of Lambda_2: "
        f"{item3['reachable_a_under_gate_A_is_all_of_Lambda_2']}",
        "",
        "(4) block profile (generators / dim v-image / dim i_Delta-image / "
        "dim v(ker i_Delta) / dim reachable a / dim reachable a under gate):",
    ]
    for name, entry in block_report.items():
        lines.append(
            f"     {name:<10} {entry['generators']:>4} "
            f"{entry['dim_v_image']:>4} {entry['dim_i_Delta_image']:>4} "
            f"{entry['dim_v_image_of_delta_kernel']:>4} "
            f"{entry['dim_reachable_a']:>4} "
            f"{entry['dim_reachable_a_under_gate']:>4}")
    naive = record["item_5_as_intended_variant"]
    lines += [
        "",
        "(5) as-intended variant, restricted to the "
        f"{naive['generators_used']} generators with integral L_3-preimage:",
        f"     dim V mod two={naive['dim_F2_of_V_mod_two']}"
        f"; dim v(ker i_Delta)={naive['dim_F2_of_delta_constrained_image']}"
        f"; reachable a unconstrained={naive['dim_of_reachable_a_unconstrained']}"
        f"/{DIM}; reachable a under gate A="
        f"{naive['dim_of_reachable_a_under_gate_A']}/{DIM}",
        "     direction  unconstrained  gate-A-constrained",
    ]
    for entry in naive_directions:
        lines.append(
            f"     {entry['direction']:<10} {str(entry['unconstrained']):<14} "
            f"{entry['gate_A']}")
    lines += [
        "",
        f"wall seconds: {record['wall_seconds']}",
        "PASS",
    ]
    output = "\n".join(lines) + "\n"

    if json_path:
        with open(json_path, "w", encoding="utf-8") as stream:
            json.dump(canonicalize(record), stream, indent=2, sort_keys=True)
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
    gate_a_main(arguments.json, arguments.out)
