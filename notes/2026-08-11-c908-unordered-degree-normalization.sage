#!/usr/bin/env sage
"""C908: adjudicate the (1,5) unordered-degree normalization.

Frozen target: decide between

  (A) the F_2-linear readout  d_(1,5) = sum_i c_i int_J Theta . alpha_i' . B_i
      (the "raw contraction"; identity residue EVEN), and
  (B) the F_4-coefficient-trace readout (identity residue ODD),

by integral computation rather than by re-arguing the chains.

Sign convention, fixed once and used throughout.  On H^*(M x M, Z) the swap acts
by s^*(x (x) y) = (-1)^{|x||y|} y (x) x.  In bidegree (p,q) with p != q the
relevant module is

    V_{p,q} = (H^p (x) H^q) (+) (H^q (x) H^p),

with s^* interchanging the two summands with the Koszul sign (-1)^{pq}.  The
transfer (norm) sublattice is T_{p,q} = (1 + s^*) V_{p,q}; the invariant lattice
is V_{p,q}^{s}.  The committed C904 Kunneth parity audit
(notes/2026-08-11-c904-symmetric-theta-full-kunneth-parity.md, section 1) states
that the integral transfer generators in bidegree (r, 6-r) are
x (x) y + (-1)^{r(6-r)} y (x) x, and that "pulling every transfer generator to
the anti-graph therefore gives twice an integral class"; both statements are
reproduced below from the convention just fixed.

What is certified here:

 1. THE DECIDING LATTICE FACT.  In bidegree (1,5)+(5,1) the module V is FREE over
    Z[C_2], so invariants = transfers exactly: the inclusion T -> V^s has all
    elementary divisors 1 and the quotient vanishes.  Since s^* q^* = q^* and
    q^* q_* = 1 + s^*, the image of q^* in this bidegree is exactly T.  There is
    therefore no room for a second factor of two.
    A CONTROL is included: in a repeated-even bidegree (p,p) with p even the same
    code detects a nontrivial quotient (Z/2)^{rank}, coming from the fixed
    diagonal basis vectors.  So the test can see a defect when one is present.

 2. THE ANTI-GRAPH FACTOR, per channel.  For each channel the anti-graph pullback
    of a transfer generator is computed symbolically from the fixed conventions
    and shown to be exactly TWICE an integral class -- so the 1/2 in
    lambda(Z) = (1/2)(1,iota)^* Gamma is consumed exactly ONCE, in every channel.

 3. THE INDEPENDENT CALIBRATION.  In the axis channel (0,6) the same machinery
    gives d = int_M h . y = Theta . b_* y.  For the minimal curve class this is
    int_J Theta . Theta^4/4! = 5, computed here directly from the lattice.  Five
    is odd and, in particular, is not twice anything: a second halving would
    return the non-integer 5/2.  This value is stated independently in the
    Kunneth audit's own section 2.1 ("the usual degree-five multisection"), and
    it is derivable from the polarization alone, so it does not depend on either
    disputed normalization.

 4. THE CONSEQUENCE FOR THE MONODROMY SPACES.  Under readout (A) the raw
    contraction IS the degree.  Certified: tr_{F_2} vanishes identically on
    M_5(F_2) (the full-S_3 invariants) but not on M_5(F_4) (the C_3 invariants);
    equivalently tr_{F_2}(phi) = Tr_{F_4/F_2}(tr_{F_4}(phi)), and
    Tr_{F_4/F_2} kills F_2 and is onto from {w, w^2}.

No randomness; canonical enumeration throughout.
"""

from contextlib import redirect_stdout
from io import StringIO
from itertools import combinations
import argparse
import hashlib
import json
import sys


SCHEMA_VERSION = "c908-unordered-degree-normalization/1"
DIM = 10
GENUS = 5
TOP = tuple(range(DIM))

INPUT_SCRIPTS = ("notes/2026-08-10-c904-minimal-class-divisor-lattice.sage",)

REPLAY_COMMAND = (
    "nix shell nixpkgs#sage -c sage "
    "notes/2026-08-11-c908-unordered-degree-normalization.sage "
    "--json notes/2026-08-11-c908-unordered-degree-normalization.json "
    "--out notes/2026-08-11-c908-unordered-degree-normalization.out"
)


_saved_argv = list(sys.argv)
sys.argv = [sys.argv[0], "--export-constants"]
with redirect_stdout(StringIO()):
    load("notes/2026-08-10-c904-minimal-class-divisor-lattice.sage")
sys.argv = _saved_argv


# --------------------------------------------------------------------------
# 1. invariants versus transfers in a swapped Kunneth bidegree
# --------------------------------------------------------------------------

def swap_involution(left_rank, right_rank, koszul_sign):
    """Matrix of s^* on (H^p (x) H^q) (+) (H^q (x) H^p) for p != q.

    Basis order: first all e_{a,b} = u_a (x) v_b, then all f_{b,a} = v_b (x) u_a,
    in lexicographic (a,b).  s^*(e_{a,b}) = koszul_sign * f_{b,a} and
    s^*(f_{b,a}) = koszul_sign * e_{a,b}.
    """
    block = left_rank * right_rank
    size = 2 * block
    result = zero_matrix(ZZ, size, size)
    for a in range(left_rank):
        for b in range(right_rank):
            n = a * right_rank + b
            result[n, block + n] = koszul_sign
            result[block + n, n] = koszul_sign
    return result


def block_certified_swap(left_rank, right_rank, koszul_sign, single_block):
    """Blockwise certification of invariants = transfers at the true ranks.

    s^* interchanges e_{a,b} = u_a (x) v_b with koszul_sign * f_{b,a}, so V is the
    direct sum, over the left_rank * right_rank basis pairs, of the rank-two
    Z[C_2]-module spanned by {e_{a,b}, f_{b,a}}.  That decomposition is s^*-stable
    by construction, so invariants, transfers and the elementary divisors of the
    inclusion are all computed blockwise.  Certified here instead of by a
    rank-2400 Smith form: the involution is verified to be a signed permutation
    of the basis whose orbits are exactly those rank-two blocks, with no fixed
    basis vector, and the single-block answer is supplied by the caller.
    """
    involution = swap_involution(left_rank, right_rank, koszul_sign)
    size = involution.nrows()
    blocks = left_rank * right_rank
    is_signed_permutation = True
    orbit_counts = {}
    fixed_basis_vectors = 0
    for column in range(size):
        support = [row for row in range(size) if involution[row, column] != 0]
        if len(support) != 1 or abs(involution[support[0], column]) != 1:
            is_signed_permutation = False
            break
        image = support[0]
        if image == column:
            fixed_basis_vectors += 1
            orbit = 1
        else:
            back = [row for row in range(size) if involution[row, image] != 0]
            orbit = 2 if back == [column] else 0
        orbit_counts[str(orbit)] = orbit_counts.get(str(orbit), 0) + 1
    per_block = single_block["inclusion_elementary_divisor_counts"]
    scaled = {key: int(value) * blocks for key, value in per_block.items()}
    return {
        "ambient_rank": int(size),
        "invariant_rank": int(blocks * single_block["invariant_rank"]),
        "transfer_rank": int(blocks * single_block["transfer_rank"]),
        "inclusion_elementary_divisor_counts": scaled,
        "invariants_equal_transfers":
            bool(single_block["invariants_equal_transfers"]
                 and is_signed_permutation and fixed_basis_vectors == 0),
        "certification": "blockwise",
        "block_count": int(blocks),
        "involution_is_signed_permutation": bool(is_signed_permutation),
        "basis_orbit_size_counts": orbit_counts,
        "fixed_basis_vectors": int(fixed_basis_vectors),
    }


def diagonal_swap_involution(rank, koszul_sign):
    """Matrix of s^* on H^p (x) H^p (a repeated bidegree), same conventions."""
    pairs = [(a, b) for a in range(rank) for b in range(rank)]
    position = {pair: n for n, pair in enumerate(pairs)}
    result = zero_matrix(ZZ, len(pairs), len(pairs))
    for (a, b), n in position.items():
        result[n, position[(b, a)]] = koszul_sign
    return result


def invariants_versus_transfers(involution):
    size = involution.nrows()
    identity = identity_matrix(ZZ, size)
    invariant = (involution - identity).left_kernel()
    transfer = span(ZZ, (involution + identity).rows())
    rows = []
    for row in transfer.basis_matrix().rows():
        coordinates = invariant.coordinate_vector(row)
        assert all(value.denominator() == 1 for value in coordinates)
        rows.append(vector(ZZ, coordinates))
    inclusion = matrix(ZZ, rows) if rows else matrix(ZZ, 0, invariant.rank())
    divisors = [int(abs(value)) for value in inclusion.elementary_divisors()]
    counts = {}
    for value in divisors:
        counts[str(value)] = counts.get(str(value), 0) + 1
    return {
        "ambient_rank": int(size),
        "invariant_rank": int(invariant.rank()),
        "transfer_rank": int(transfer.rank()),
        "inclusion_elementary_divisor_counts":
            dict(sorted(counts.items(), key=lambda item: int(item[0]))),
        "invariants_equal_transfers": bool(transfer == invariant),
    }


# --------------------------------------------------------------------------
# 2. the anti-graph factor, per channel
# --------------------------------------------------------------------------

def anti_graph_factor(left_degree, right_degree):
    """Coefficient c with (1,iota)^*(transfer generator) = c * (x . y).

    Conventions: the transfer generator is x (x) y + eps y (x) x with
    eps = (-1)^{|x||y|}; iota^* acts by (-1)^k on the inherited H^k; and
    y . x = (-1)^{|x||y|} x . y in H^*(M).
    """
    p, q = left_degree, right_degree
    eps = (-1) ** (p * q)
    # (1,iota)^*(x (x) y) = x . iota^* y = (-1)^q x . y
    first = (-1) ** q
    # (1,iota)^*(y (x) x) = y . iota^* x = (-1)^p y . x = (-1)^p (-1)^{pq} x . y
    second = ((-1) ** p) * ((-1) ** (p * q))
    return int(first + eps * second)


# --------------------------------------------------------------------------
# helpers
# --------------------------------------------------------------------------

def basis_form(indices):
    return {tuple(indices): ZZ.one()}


def canonicalize(value):
    if value is None or isinstance(value, (bool, str)):
        return value
    if isinstance(value, dict):
        return {str(key): canonicalize(entry) for key, entry in value.items()}
    if isinstance(value, (list, tuple)):
        return [canonicalize(entry) for entry in value]
    if isinstance(value, int):
        return int(value)
    try:
        return int(value)
    except (TypeError, ValueError):
        return str(value)


def sha256_of(path):
    with open(path, "rb") as stream:
        return hashlib.sha256(stream.read()).hexdigest()


# --------------------------------------------------------------------------
# main
# --------------------------------------------------------------------------

def main(json_path=None, out_path=None):
    record = {"schema": SCHEMA_VERSION, "replay_command": REPLAY_COMMAND}
    record["swap_convention"] = ("s^*(x (x) y) = (-1)^{|x||y|} y (x) x; "
                                "transfer generator x (x) y + (-1)^{pq} y (x) x; "
                                "iota^* = (-1)^k on the inherited H^k")

    # ---- 1. the deciding lattice fact, plus a control --------------------
    # True ranks: H^1(M,Z) has rank 10, H^5(M,Z) has rank 120.  The module is a
    # direct sum of rank-two Z[C_2] blocks, one per basis pair, and s^* preserves
    # each block, so the elementary divisors are computed blockwise.  We certify
    # (i) a single block exactly, (ii) the full 10 x 120 case, and (iii) a
    # repeated-even control where the answer is known to be nontrivial.
    single_block = invariants_versus_transfers(swap_involution(1, 1, -1))
    moderate_15 = invariants_versus_transfers(swap_involution(DIM, 12, -1))
    full_15 = block_certified_swap(DIM, 120, -1, single_block)
    control_even = invariants_versus_transfers(
        diagonal_swap_involution(6, +1))
    control_odd_diagonal = invariants_versus_transfers(
        diagonal_swap_involution(6, -1))
    record["bidegree_1_5_lattice"] = {
        "koszul_sign": -1,
        "single_block": single_block,
        "moderate_full_lattice_H1_10_times_H5_12": moderate_15,
        "full_H1_rank_10_times_H5_rank_120": full_15,
        "q_star_image_equals_transfers": bool(
            full_15["invariants_equal_transfers"]),
        "reason":
            "s^* q^* = q^* puts the image of q^* inside the invariants, and "
            "q^* q_* = 1 + s^* puts the transfers inside the image; since "
            "invariants = transfers the image is exactly the transfer lattice",
        "no_second_factor_two_available": bool(
            full_15["invariants_equal_transfers"]),
    }
    record["controls"] = {
        "repeated_even_bidegree_p_p_koszul_plus_one": control_even,
        "repeated_odd_bidegree_p_p_koszul_minus_one": control_odd_diagonal,
        "note":
            "the repeated-even control has a nontrivial invariants/transfers "
            "quotient coming from the fixed diagonal basis vectors, so the same "
            "code detects a factor two when one is genuinely present",
    }

    # ---- 2. the anti-graph factor, per channel ---------------------------
    channels = {}
    for left in range(0, 7):
        right = 6 - left
        channels[f"{left}_{right}"] = {
            "transfer_generator_koszul_sign": int((-1) ** (left * right)),
            "anti_graph_factor": anti_graph_factor(left, right),
        }
    all_factors_are_plus_or_minus_two = all(
        abs(entry["anti_graph_factor"]) == 2
        for key, entry in channels.items()
        if key not in ("3_3",))
    record["anti_graph_factors"] = {
        "per_channel": channels,
        "every_non_33_channel_gives_exactly_twice_an_integral_class":
            bool(all_factors_are_plus_or_minus_two),
        "consequence":
            "the 1/2 in lambda(Z) = (1/2)(1,iota)^* Gamma is consumed exactly "
            "once, in every channel; no further halving is available",
    }

    # ---- 3. the independent axis-channel calibration ---------------------
    _, _, basis, symplectic = principal_lattice("omega", 1)
    theta = two_form(symplectic)
    assert symplectic.inverse().denominator() == 1
    powers = [{(): ZZ.one()}]
    current = {(): ZZ.one()}
    for k in range(1, GENUS + 1):
        current = wedge(current, theta)
        divided = {}
        for indices, value in current.items():
            assert value % factorial(k) == 0
            divided[indices] = value // factorial(k)
        powers.append({i: v for i, v in divided.items() if v})
    theta_five_top = powers[GENUS].get(TOP, 0)
    minimal_class = powers[4]
    axis_degree = wedge(theta, minimal_class).get(TOP, 0)
    record["axis_channel_calibration"] = {
        "channel": "(0,6)",
        "anti_graph_factor": anti_graph_factor(0, 6),
        "lambda_equals": "y (the 1/2 cancels the factor two exactly once)",
        "degree_formula": "d = int_M h . y = int_J Theta . b_* y",
        "theta_divided_power_five_top_coefficient": int(theta_five_top),
        "int_J_theta_times_minimal_class": int(axis_degree),
        "matches_the_audit_degree_five": bool(int(axis_degree) == 5),
        "a_second_halving_would_give": "5/2, not an integer",
        "independence":
            "the value 5 = int_J Theta . Theta^4/4! is a property of the "
            "principal polarization alone; it is also stated independently in "
            "section 2.1 of the Kunneth parity audit as 'the usual degree-five "
            "multisection', and it does not use either disputed normalization",
    }

    # ---- 4. the two readouts, and the monodromy consequence -------------
    field = GF(2)
    quartic = GF(4, "w")
    omega = quartic.gen()
    basis_f4 = [quartic.one(), omega]

    def f2_matrix_of(phi):
        big = zero_matrix(field, 2 * GENUS, 2 * GENUS)
        for column in range(GENUS):
            for k, coefficient in enumerate(basis_f4):
                for row in range(GENUS):
                    entry = phi[row, column] * coefficient
                    expansion = entry.polynomial().list()
                    expansion += [0] * (2 - len(expansion))
                    for m in range(2):
                        big[2 * row + m, 2 * column + k] = field(expansion[m])
        return big

    absolute_trace = {str(x): int(field(x + x ** 2)) for x in quartic}
    samples = []
    for scalar in [quartic.zero(), quartic.one(), omega, omega ** 2]:
        for label, phi in (
                ("scalar_times_identity",
                 diagonal_matrix(quartic, [scalar] * GENUS)),
                ("single_diagonal_entry",
                 diagonal_matrix(quartic,
                                 [scalar] + [quartic.zero()] * (GENUS - 1)))):
            big = f2_matrix_of(phi)
            f4_trace = phi.trace()
            samples.append({
                "family": label,
                "scalar": str(scalar),
                "f4_coefficient_trace": str(f4_trace),
                "Tr_F4_F2_of_coefficient_trace": int(field(f4_trace + f4_trace ** 2)),
                "f2_linear_trace": int(big.trace()),
                "agree": bool(int(big.trace())
                              == int(field(f4_trace + f4_trace ** 2))),
            })
    # every F_2-rational matrix has vanishing F_2-linear trace: certified on the
    # canonical spanning set of M_5(F_2), the elementary matrices e_{ab}.
    f2_rational_traces = set()
    for a in range(GENUS):
        for b in range(GENUS):
            phi = zero_matrix(quartic, GENUS, GENUS)
            phi[a, b] = quartic.one()
            f2_rational_traces.add(int(f2_matrix_of(phi).trace()))
    identity_f2_trace = int(f2_matrix_of(
        identity_matrix(quartic, GENUS)).trace())
    record["readout_comparison"] = {
        "absolute_trace_Tr_F4_F2": absolute_trace,
        "absolute_trace_identity_verified":
            bool(all(entry["agree"] for entry in samples)),
        "samples": samples,
        "f2_linear_trace_of_identity": identity_f2_trace,
        "f4_coefficient_trace_of_identity": int(GENUS % 2),
        "identity_readouts_disagree":
            bool(identity_f2_trace != int(GENUS % 2)),
        "f2_linear_trace_on_all_elementary_F2_matrices": sorted(f2_rational_traces),
        "f2_linear_trace_vanishes_on_M5_F2":
            bool(f2_rational_traces == {0}),
        "consequence":
            "under readout (A) the degree vanishes on the full-S_3 invariants "
            "M_5(F_2) -- reproducing equation (2.1) of the exotic-deck note as a "
            "genuine parity statement -- while on the C_3 invariants M_5(F_4) it "
            "is odd exactly when the F_4-coefficient trace lies outside F_2",
    }

    # ---- ruling ---------------------------------------------------------
    lattice_decides = record["bidegree_1_5_lattice"]["no_second_factor_two_available"]
    calibration_ok = record["axis_channel_calibration"]["matches_the_audit_degree_five"]
    record["ruling"] = {
        "winner": "F_2-linear readout (A): the raw contraction is the unordered degree",
        "lattice_verdict":
            "in bidegree (1,5)+(5,1) the image of q^* equals the transfer "
            "lattice, which equals the invariant lattice; index 1, no factor two",
        "calibration_verdict":
            "the (0,6) axis channel returns the independently known odd value 5",
        "both_tests_agree": bool(lattice_decides and calibration_ok),
        "defect_in_the_losing_chain":
            "a second halving, applied when passing from the raw contraction to "
            "the 'coefficient trace'; it contradicts section 1 of the same note, "
            "which uses the 1/2 exactly once to cancel the transfer generator's "
            "factor two",
        "not_claimed": [
            "any channel-closure theorem",
            "that S_3-invariance is forced for classes over the marked base",
            "anything about algebraicity, Hodge-ness, or Chow descent",
        ],
    }

    assert lattice_decides, "the deciding lattice fact failed"
    assert calibration_ok, "the axis-channel calibration failed"
    assert record["readout_comparison"]["absolute_trace_identity_verified"]
    assert record["readout_comparison"]["f2_linear_trace_vanishes_on_M5_F2"]
    assert control_even["invariants_equal_transfers"] is False, \
        "the control must detect a factor two"

    record["inputs"] = {path: sha256_of(path) for path in INPUT_SCRIPTS}

    lines = [
        "C908 unordered-degree normalization adjudication",
        "bidegree (1,5): ambient rank="
        f"{full_15['ambient_rank']}; invariants rank={full_15['invariant_rank']}"
        f"; transfers rank={full_15['transfer_rank']}"
        f"; elementary divisors={full_15['inclusion_elementary_divisor_counts']}"
        f"; invariants = transfers: {full_15['invariants_equal_transfers']}",
        "control, repeated-even bidegree: elementary divisors="
        f"{control_even['inclusion_elementary_divisor_counts']}"
        f"; invariants = transfers: {control_even['invariants_equal_transfers']}",
        "anti-graph factor is +/-2 in every non-(3,3) channel: "
        f"{all_factors_are_plus_or_minus_two}"
        f"; (1,5) factor={channels['1_5']['anti_graph_factor']}"
        f"; (0,6) factor={channels['0_6']['anti_graph_factor']}",
        "axis calibration: int_J Theta . Theta^4/4! = "
        f"{int(axis_degree)} (audit value 5: "
        f"{record['axis_channel_calibration']['matches_the_audit_degree_five']})",
        f"identity readouts: F_2-linear={identity_f2_trace}"
        f"; F_4-coefficient={int(GENUS % 2)}; disagree=True",
        "F_2-linear trace vanishes on all of M_5(F_2): "
        f"{record['readout_comparison']['f2_linear_trace_vanishes_on_M5_F2']}",
        "RULING: F_2-linear readout (A) wins; the losing chain double-counts the "
        "anti-graph halving",
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
    if not out_path:
        print(output, end="")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--json")
    parser.add_argument("--out")
    arguments = parser.parse_args()
    main(arguments.json, arguments.out)
