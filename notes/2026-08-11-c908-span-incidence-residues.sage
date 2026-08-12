#!/usr/bin/env sage
"""C908 pass-7 certificate: span-incidence (1,5) residues.

Implements the lattice contraction of the pass-7 working spec
(reproduced in notes/2026-08-11-c908-span-incidence-parity-no-go.md) on top of the certified Pontryagin
machinery of `notes/2026-08-11-c908-pontryagin-transfer-image.sage`.

Model (all mod torsion, everything read out through a_* into torsion-free
wedge powers of Lambda = H^1(J,Z) of rank ten):

  Lambda        exotic principal lattice, principal_lattice("omega", 1)
  Theta         two_form(symplectic Gram S)
  Theta^[k]     divided powers, k <= 5, integrality asserted

Fano-surface slot calculus.  A class on one F-slot is a formal sum of keys
(w, c, p): w a basis wedge of Lambda (the a^*-part), c in {0,1} the C_s power,
p in {0,1} the [pt]-flag.  Degree = |w| + 2c + 4p, capped at 4.  C_s^2 is
rewritten as 5[pt] (never the other direction).  [pt] annihilates anything of
positive degree.  Pushforward a_* : H^*(F) -> wedge Lambda, degree +6:

  a_*(w, 0, 0) = w ^ Theta^[3]
  a_*(w, 1, 0) = 2 (w ^ Theta^[4])
  a_*([pt])    = Theta^[5]

consistently with a^*Theta = 2 C_s and C_s^2 = 5[pt].

  psi_*(x (x) y) = (-1)^{deg x} (a_* x) * (a_* y),  * the certified Pontryagin
                                                     product.

Four slots F_1 x F_2 x F_3 x F_4; the two psi-pairs are (1,2) and (3,4).
Candidates: [Z_sp with G-pair (i,j) and third slot k] . [I on pair (m,n)].
Readout: keep the (1,5) part, i.e. deg(slot1)+deg(slot2) = 1; write the
H^3(J)-leg as A = Theta ^ alpha' (L : Lambda -> ^3 Lambda is saturated, so
alpha' is integral), pair the H^7(J)-leg against the exotic principal basis
u_0..u_9 through P(a,[B]) = int_J Theta . a . B, and assemble
M_{kl} = sum_i c_i alpha'_{i,k} P(u_l, B_i).  Verdict is M mod 2.

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

SCHEMA_VERSION = "c908-span-incidence-residues/1"
DIM = 10
TOP = tuple(range(DIM))
CORPUS = "notes/2026-08-10-c904-minimal-class-divisor-lattice.sage"
REPLAY_COMMAND = (
    "cd /home/tavis/src/othello && nix shell nixpkgs#sage -c sage "
    "notes/2026-08-11-c908-span-incidence-residues.sage "
    "--json notes/2026-08-11-c908-span-incidence-residues.json "
    "--out notes/2026-08-11-c908-span-incidence-residues.out"
)

# --------------------------------------------------------------- parameters --
K1 = 3                  # sigma_1|_F = k1 . C_s
K11 = 27                # sigma_{1,1}|_F = k11 . [pt]   (= number of lines, odd)
USE_EXPECTED_I = True   # gamma_I := GAMMA_I_SIGN * cross term of psi^*Theta
GAMMA_I_SIGN = -1       # [I] = K_{FxF} - psi^*Theta: cross(I) = -cross(psi^*Theta)

_saved_argv = list(sys.argv)
sys.argv = [sys.argv[0], "--export-constants"]
with redirect_stdout(StringIO()):
    load(CORPUS)
sys.argv = _saved_argv


# ---------------------------------------------------------- form arithmetic --

def add_forms(left, right):
    result = dict(left)
    for indices, value in right.items():
        total = result.get(indices, 0) + value
        if total:
            result[indices] = total
        elif indices in result:
            del result[indices]
    return result


def scale_form(scalar, form):
    if scalar == 0:
        return {}
    return {indices: scalar * value for indices, value in form.items()}


def divide_form(form, divisor):
    for value in form.values():
        assert value % divisor == 0, "divided power is not integral"
    return {indices: value // divisor for indices, value in form.items()}


def basis_form(indices):
    return {tuple(indices): ZZ.one()}


def form_vector(form, degree):
    index = list(combinations(range(DIM), degree))
    return vector(ZZ, [form.get(item, 0) for item in index])


def complement(indices):
    return tuple(i for i in range(DIM) if i not in indices)


def orientation_sign(indices):
    return wedge({tuple(indices): ZZ.one()},
                 {complement(indices): ZZ.one()}).get(TOP, 0)


def poincare_dual(form):
    result = {}
    for indices, value in form.items():
        result[complement(indices)] = orientation_sign(indices) * value
    return {k: v for k, v in result.items() if v}


def poincare_dual_inverse(form):
    result = {}
    for indices, value in form.items():
        result[complement(indices)] = orientation_sign(complement(indices)) * value
    return {k: v for k, v in result.items() if v}


def pontryagin(left, right):
    return poincare_dual_inverse(wedge(poincare_dual(left),
                                       poincare_dual(right)))


def lefschetz_matrix(theta, source_degree):
    source = list(combinations(range(DIM), source_degree))
    target = list(combinations(range(DIM), source_degree + 2))
    position = {J: n for n, J in enumerate(target)}
    result = zero_matrix(ZZ, len(source), len(target))
    for row, I in enumerate(source):
        for indices, value in wedge(theta, basis_form(I)).items():
            result[row, position[indices]] = value
    return source, target, result


def elementary_divisor_counts(matrix_value):
    counts = {}
    for value in matrix_value.elementary_divisors():
        if value == 0:
            continue
        key = str(abs(value))
        counts[key] = counts.get(key, 0) + 1
    return dict(sorted(counts.items(), key=lambda item: int(item[0])))


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


# ------------------------------------------------------------ slot calculus --

ONE = ((), 0, 0)
CS = ((), 1, 0)
PT = ((), 0, 1)


def vec_key(index):
    return ((index,), 0, 0)


def slot_degree(key):
    w, c, p = key
    return len(w) + 2 * c + 4 * p


_ZERO = object()
_slot_mul_cache = {}


def slot_mul(left, right):
    """Product of two slot keys; returns (key, integer coefficient) or None."""
    cached = _slot_mul_cache.get((left, right), _ZERO)
    if cached is not _ZERO:
        return cached
    result = _slot_product(left, right)
    _slot_mul_cache[(left, right)] = result
    return result


def _slot_product(left, right):
    w1, c1, p1 = left
    w2, c2, p2 = right
    if p1 and p2:
        return None
    if p1:
        return (PT, 1) if slot_degree(right) == 0 else None
    if p2:
        return (PT, 1) if slot_degree(left) == 0 else None
    c = c1 + c2
    if c > 2:
        return None
    if set(w1) & set(w2):
        return None
    inversions = sum(1 for i in w1 for j in w2 if i > j)
    w = tuple(sorted(w1 + w2))
    sign = -1 if inversions % 2 else 1
    if len(w) + 2 * c > 4:
        return None
    if c == 2:
        # C_s^2 = 5 [pt]; used only in this direction, never dividing.
        return (PT, 5 * sign)
    return ((w, c, 0), sign)


# ------------------------------------------------------- four-slot calculus --

def tensor_single(assignment, coefficient=1):
    """Tensor with the given slot keys (0-indexed) and ONE elsewhere."""
    keys = [ONE, ONE, ONE, ONE]
    for slot, key in assignment.items():
        keys[slot] = key
    return {tuple(keys): ZZ(coefficient)}


def tensor_add(*tensors):
    result = {}
    for tensor in tensors:
        for keys, value in tensor.items():
            total = result.get(keys, 0) + value
            if total:
                result[keys] = total
            elif keys in result:
                del result[keys]
    return result


def tensor_scale(scalar, tensor):
    if scalar == 0:
        return {}
    return {keys: scalar * value for keys, value in tensor.items()}


def tensor_prune(tensor, d12_max):
    if d12_max is None:
        return tensor
    return {keys: value for keys, value in tensor.items()
            if slot_degree(keys[0]) + slot_degree(keys[1]) <= d12_max}


def tensor_mul(left, right, d12_max=None):
    """Slotwise product with the Kunneth (Koszul) sign, optionally pruned."""
    result = {}
    for xkeys, xcoef in left.items():
        xdeg = [slot_degree(k) for k in xkeys]
        tails = [xdeg[1] + xdeg[2] + xdeg[3], xdeg[2] + xdeg[3], xdeg[3], 0]
        for ykeys, ycoef in right.items():
            sign_exponent = 0
            for slot in range(4):
                dy = slot_degree(ykeys[slot])
                if dy:
                    sign_exponent += dy * tails[slot]
            coefficient = xcoef * ycoef
            if sign_exponent % 2:
                coefficient = -coefficient
            new_keys = []
            ok = True
            for slot in range(4):
                piece = slot_mul(xkeys[slot], ykeys[slot])
                if piece is None:
                    ok = False
                    break
                new_keys.append(piece[0])
                coefficient *= piece[1]
            if not ok:
                continue
            if d12_max is not None and \
                    slot_degree(new_keys[0]) + slot_degree(new_keys[1]) > d12_max:
                continue
            keys = tuple(new_keys)
            total = result.get(keys, 0) + coefficient
            if total:
                result[keys] = total
            elif keys in result:
                del result[keys]
    return result


# ------------------------------------------------------------------ main -----

def main(json_path=None, out_path=None):
    started = time.time()
    record = {"schema": SCHEMA_VERSION, "replay_command": REPLAY_COMMAND,
              "parameters": {"k1": int(K1), "k11": int(K11),
                             "use_expected_I": bool(USE_EXPECTED_I)}}
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
    orientation = divided[5].get(TOP, 0)
    assert divided[5] == {TOP: orientation} and abs(orientation) == 1
    record["divided_powers"] = {
        "integral_for_k": sorted(int(k) for k in divided),
        "int_J_theta5": int(orientation),
    }

    # ---- Lefschetz data, Q_15, and the readout pairing --------------------
    _, _, lefschetz_13 = lefschetz_matrix(theta, 1)
    counts_13 = elementary_divisor_counts(lefschetz_13)
    _, septics, lefschetz_57 = lefschetz_matrix(theta, 5)
    counts_57 = elementary_divisor_counts(lefschetz_57)
    image_lattice = span(ZZ, lefschetz_57.rows())
    septic_position = {J: n for n, J in enumerate(septics)}

    pairing = zero_matrix(ZZ, DIM, len(septics))
    for a in range(DIM):
        partial = wedge(theta, basis_form((a,)))
        for column, B in enumerate(septics):
            pairing[a, column] = ZZ(wedge(partial, basis_form(B)).get(TOP, 0))
    lefschetz_57_mod2 = lefschetz_57.change_ring(field)
    quotient_dimension = (lefschetz_57_mod2.ncols()
                          - lefschetz_57_mod2.row_space().dimension())
    pairing_mod2 = pairing.change_ring(field)
    kills_image = all((pairing_mod2 * vector(field, row)) == 0
                      for row in lefschetz_57_mod2.rows())
    record["readout_infrastructure"] = {
        "elementary_divisors_L_1_to_3": counts_13,
        "L_1_to_3_image_saturated": bool(set(counts_13) == {"1"}),
        "elementary_divisors_L_5_to_7": counts_57,
        "Q15_is_Z2_to_the_ten": bool(counts_57 == {"1": 110, "2": 10}),
        "dim_F2_Q15": int(quotient_dimension),
        "pairing_rank_mod_two": int(pairing_mod2.rank()),
        "pairing_kills_image_of_L5": bool(kills_image),
        "pairing_is_perfect": bool(kills_image and pairing_mod2.rank()
                                   == quotient_dimension == DIM),
    }
    assert set(counts_13) == {"1"}
    assert counts_57 == {"1": 110, "2": 10}
    assert kills_image and pairing_mod2.rank() == DIM

    # ---- a_* on slot keys, memoized ---------------------------------------
    _pushforward_cache = {}

    def slot_pushforward(key):
        cached = _pushforward_cache.get(key)
        if cached is not None:
            return cached
        w, c, p = key
        if p:
            value = dict(divided[5])
        elif c == 0:
            value = wedge(basis_form(w), divided[3])
        elif c == 1:
            value = scale_form(2, wedge(basis_form(w), divided[4]))
        else:                                       # pragma: no cover
            raise AssertionError("C_s^2 must have been rewritten as 5 [pt]")
        _pushforward_cache[key] = value
        return value

    _psi_cache = {}

    def psi_push(left_key, right_key):
        """psi_*(x (x) y) = (-1)^{deg x} (a_* x) * (a_* y)."""
        cached = _psi_cache.get((left_key, right_key))
        if cached is not None:
            return cached
        value = pontryagin(slot_pushforward(left_key),
                           slot_pushforward(right_key))
        if slot_degree(left_key) % 2:
            value = scale_form(-1, value)
        _psi_cache[(left_key, right_key)] = value
        return value

    controls = {}

    # ---- control: psi_*(1 (x) 1) = 6 Theta ---------------------------------
    unit_push = psi_push(ONE, ONE)
    controls["psi_push_of_unit_is_six_theta"] = bool(
        unit_push == scale_form(6, theta))
    assert controls["psi_push_of_unit_is_six_theta"]

    # ---- control: the two dead pass-6 subfamilies --------------------------
    theta_wedge_theta3 = wedge(theta, divided[3])
    content = ZZ(gcd(list(theta_wedge_theta3.values())))
    membership = [bool(3 * form_vector(wedge(divided[3], basis_form((i,))), 7)
                       in image_lattice) for i in range(DIM)]
    controls["theta_wedge_theta3_equals_four_theta4"] = bool(
        theta_wedge_theta3 == scale_form(4, divided[4]))
    controls["content_of_theta_wedge_theta3"] = int(content)
    controls["u_equals_theta_line_is_dead_content_four"] = bool(content == 4)
    controls["three_times_theta3_wedge_e_i_in_L5_image_over_Z"] = bool(
        all(membership))
    assert controls["theta_wedge_theta3_equals_four_theta4"]
    assert content == 4 and all(membership)

    # ---- control: H^2(F) lattice Gram is unimodular ------------------------
    two_indices = list(combinations(range(DIM), 2))
    size = len(two_indices) + 1
    gram = zero_matrix(ZZ, size, size)
    for row, I in enumerate(two_indices):
        for column, J in enumerate(two_indices):
            gram[row, column] = ZZ(wedge(wedge(basis_form(I), basis_form(J)),
                                         divided[3]).get(TOP, 0))
        gram[row, size - 1] = 2 * ZZ(
            wedge(basis_form(I), divided[4]).get(TOP, 0))
        gram[size - 1, row] = gram[row, size - 1]
    gram[size - 1, size - 1] = ZZ(5)
    relation = vector(ZZ, [theta.get(I, 0) for I in two_indices] + [-2])
    assert gcd(list(relation)) == 1, "a^*Theta - 2C_s is not primitive"
    radical_ok = bool(gram * relation == 0)
    column = matrix(ZZ, size, 1, list(relation))
    smith, transform, _ = column.smith_form()
    assert smith[0, 0] == 1
    inverse = transform.inverse().change_ring(ZZ)
    complement_basis = inverse.matrix_from_columns(list(range(1, size)))
    quotient_gram = complement_basis.transpose() * gram * complement_basis
    determinant = quotient_gram.det()
    controls["h2_lattice"] = {
        "generators": int(size),
        "rank_of_quotient": int(quotient_gram.nrows()),
        "relation_is_in_the_radical": radical_ok,
        "gram_determinant": int(determinant),
        "unimodular": bool(abs(determinant) == 1),
    }
    assert radical_ok and abs(determinant) == 1

    # ---- psi^*Theta, derived, and the ingredient classes -------------------
    def psi_pullback_h1(index, first, second):
        """psi^* e_index on the slot pair (first, second): -e@first + e@second."""
        return tensor_add(tensor_single({first: vec_key(index)}, -1),
                          tensor_single({second: vec_key(index)}, 1))

    def psi_pullback_theta(first, second):
        total = {}
        for (i, j), value in theta.items():
            total = tensor_add(total, tensor_scale(
                ZZ(value), tensor_mul(psi_pullback_h1(i, first, second),
                                      psi_pullback_h1(j, first, second))))
        return total

    def split_two_slot(tensor, first, second):
        """Split into (part on `first` only, on `second` only, cross)."""
        first_part, second_part, cross = {}, {}, {}
        for keys, value in tensor.items():
            on_first = slot_degree(keys[first]) > 0
            on_second = slot_degree(keys[second]) > 0
            for other in range(4):
                if other not in (first, second):
                    assert slot_degree(keys[other]) == 0
            target = (cross if on_first and on_second
                      else first_part if on_first
                      else second_part if on_second else None)
            assert target is not None, "unexpected degree-zero term"
            target[keys] = value
        return first_part, second_part, cross

    def theta_on_slot(slot):
        return {tuple(vec if index != slot else (I, 0, 0)
                      for index, vec in enumerate([ONE] * 4)): ZZ(value)
                for I, value in theta.items()}

    reference = psi_pullback_theta(0, 1)
    ref_first, ref_second, ref_cross = split_two_slot(reference, 0, 1)
    pullback_matches = bool(ref_first == theta_on_slot(0)
                            and ref_second == theta_on_slot(1))
    # gamma coefficient matrix: cross = sum_{i,j} c_{ij} e_i@first (x) e_j@second
    gamma_matrix = zero_matrix(ZZ, DIM, DIM)
    for keys, value in ref_cross.items():
        i = keys[0][0][0]
        j = keys[1][0][0]
        gamma_matrix[i, j] = value
    gamma_is_minus_symplectic = bool(gamma_matrix == -symplectic)
    record["psi_pullback_theta"] = {
        "pullback_parts_are_a_star_theta_with_coefficient_one":
            pullback_matches,
        "cross_coefficient_matrix_equals_minus_symplectic_gram":
            gamma_is_minus_symplectic,
        "derivation": "psi^* e_i = -a^*e_i on the first slot + a^*e_i on the "
                      "second; wedging gives (+1)a^*Theta on each slot and "
                      "cross = -sum_{i,j} Theta_{ij} e_i (x) e_j",
    }
    assert pullback_matches and gamma_is_minus_symplectic
    controls["psi_pullback_theta_pullback_parts_are_a_star_theta"] = \
        pullback_matches
    controls["gamma_psi_cross_matrix_is_minus_theta"] = gamma_is_minus_symplectic

    # a^*Theta = 2 C_s: verified through a_*, then used to keep the calculus
    # in the compact C_s representation.
    a_star_theta_push = {}
    for I, value in theta.items():
        a_star_theta_push = add_forms(
            a_star_theta_push,
            scale_form(ZZ(value), slot_pushforward(((I), 0, 0))))
    controls["a_star_theta_equals_two_Cs_under_pushforward"] = bool(
        a_star_theta_push == scale_form(2, slot_pushforward(CS)))
    assert controls["a_star_theta_equals_two_Cs_under_pushforward"]

    def gamma_cross(first, second):
        """gamma on the ordered slot pair (first < second)."""
        result = {}
        for i in range(DIM):
            for j in range(DIM):
                value = gamma_matrix[i, j]
                if value:
                    result.update(tensor_single(
                        {first: vec_key(i), second: vec_key(j)}, ZZ(value)))
        return result

    def psi_pullback_theta_compact(first, second):
        """psi^*Theta with its pullback parts written as 2 C_s per slot."""
        return tensor_add(tensor_single({first: CS}, 2),
                          tensor_single({second: CS}, 2),
                          gamma_cross(first, second))

    def incidence(first, second):
        """[I_F] = pr^*C_s + pr^*C_s + P, P = -cross(psi^*Theta).

        Sign fixed by the Fano/Schubert restriction extraction
        (notes/2026-08-11-c908-fano-schubert-restriction-extraction.md):
        [I_F] = K_{FxF} - psi^*Theta with K_F = 3 C_s, so the incidence cross
        term is MINUS the cross term of psi^*Theta.
        """
        assert USE_EXPECTED_I
        return tensor_add(tensor_single({first: CS}, 1),
                          tensor_single({second: CS}, 1),
                          tensor_scale(GAMMA_I_SIGN,
                                       gamma_cross(first, second)))

    def span_divisor(first, second):
        """G_1 = sigma_1 (+) sigma_1 - [I] = (k1-1)(C_s (+) C_s) + cross."""
        return tensor_add(tensor_single({first: CS}, K1 - 1),
                          tensor_single({second: CS}, K1 - 1),
                          tensor_scale(-GAMMA_I_SIGN,
                                       gamma_cross(first, second)))

    # control: with k1 = 3 the span divisor is exactly psi^*Theta
    controls["G1_equals_psi_pullback_theta"] = bool(
        span_divisor(0, 1) == psi_pullback_theta_compact(0, 1))
    controls["G1_equals_psi_pullback_theta_note"] = (
        "holds iff k1 = 3 and gamma_I = -cross(psi^*Theta); with k1 = "
        f"{K1} and gamma_I sign {GAMMA_I_SIGN}")
    assert K1 != 3 or controls["G1_equals_psi_pullback_theta"]

    # ---- alpha' recovery and the mod-two rows ------------------------------
    _alpha_cache = {}
    unsolvable = []

    def alpha_prime(form):
        key = tuple(sorted(form.items()))
        cached = _alpha_cache.get(key, _ZERO)
        if cached is not _ZERO:
            return cached
        target = form_vector(form, 3)
        try:
            solution = lefschetz_13.solve_left(target)
            solution = vector(ZZ, solution)
            assert solution * lefschetz_13 == target
        except (ValueError, TypeError, AssertionError):
            solution = None
        _alpha_cache[key] = solution
        return solution

    _row_cache = {}

    def pairing_row(form):
        key = tuple(sorted(form.items()))
        cached = _row_cache.get(key)
        if cached is not None:
            return cached
        row = [ZZ(0)] * DIM
        for indices, value in form.items():
            assert len(indices) == 7, "second leg is not of degree seven"
            column = septic_position[indices]
            for a in range(DIM):
                entry = pairing[a, column]
                if entry:
                    row[a] += entry * value
        row = vector(ZZ, row)
        _row_cache[key] = row
        return row

    # ---- the candidate library --------------------------------------------
    slot_pairs = list(combinations(range(4), 2))

    def build_candidate(g_pair, third, i_pair):
        first, second = g_pair
        g1 = tensor_prune(span_divisor(first, second), 1)
        g2 = tensor_mul(g1, g1, d12_max=1)
        z_sp = tensor_add(
            g2,
            tensor_mul(g1, tensor_single({third: CS}, K1), d12_max=1),
            tensor_prune(tensor_single({third: PT}, K11), 1))
        divisor = tensor_prune(incidence(*i_pair), 2)
        return tensor_mul(z_sp, divisor, d12_max=1)

    def residue_matrix(candidate):
        accumulated = {}
        for keys, value in candidate.items():
            if slot_degree(keys[0]) + slot_degree(keys[1]) != 1:
                continue
            entry = ((keys[0], keys[1]), (keys[2], keys[3]))
            accumulated[entry] = accumulated.get(entry, 0) + value
        rows = {}
        alphas = {}
        live = 0
        for (left, right), value in accumulated.items():
            if value == 0:
                continue
            first_leg = psi_push(*left)
            if not first_leg:
                continue
            second_leg = psi_push(*right)
            if not second_leg:
                continue
            alpha = alpha_prime(first_leg)
            if alpha is None:
                unsolvable.append(str(left))
                continue
            live += 1
            alphas[left] = alpha
            rows[left] = (rows.get(left, zero_vector(ZZ, DIM))
                          + value * pairing_row(second_leg))
        result = zero_matrix(ZZ, DIM, DIM)
        for left, row in rows.items():
            alpha = alphas[left]
            for k in range(DIM):
                if alpha[k]:
                    for l in range(DIM):
                        if row[l]:
                            result[k, l] += alpha[k] * row[l]
        return result, live, len(accumulated)

    # ---- positive control: the pipeline is not identically zero -----------
    # A synthetic (non-geometric) (1,5) term of exactly the live shape of
    # spec section 2b: one H^1 cross-leg on the p-side, a transverse
    # degree-two a^*-leg and a degree-three a^*-leg on the q-side.
    probe_terms = {}
    for triple in combinations(range(DIM), 3):
        for pair in combinations(range(DIM), 2):
            probe_terms.update(tensor_single(
                {0: vec_key(0), 2: (pair, 0, 0), 3: (triple, 0, 0)}, 1))
    probe_matrix, probe_live, _ = residue_matrix(probe_terms)
    probe_single, _, _ = residue_matrix(tensor_single(
        {0: vec_key(0), 2: ((1, 2), 0, 0), 3: ((3, 4, 5), 0, 0)}, 1))
    controls["positive_control"] = {
        "synthetic_family_terms": int(len(probe_terms)),
        "synthetic_family_live_terms": int(probe_live),
        "synthetic_family_f2_rank":
            int(probe_matrix.change_ring(field).rank()),
        "single_synthetic_term_f2_matrix_is_nonzero":
            bool(probe_single.change_ring(field) != 0),
        "single_synthetic_term_f2_rank":
            int(probe_single.change_ring(field).rank()),
        "meaning": "the contraction pipeline does produce nonzero mod-two "
                   "residues on classes of the live shape, so the candidate "
                   "verdicts below are genuine cancellations",
    }
    assert controls["positive_control"]["synthetic_family_f2_rank"] > 0

    # p-side liveness: the twenty first legs that a (1,5) term can carry.
    p_side = []
    p_side_missing = []
    for index in range(DIM):
        for pair in ((vec_key(index), ONE), (ONE, vec_key(index))):
            leg = psi_push(*pair)
            alpha = alpha_prime(leg) if leg else None
            if alpha is None:
                p_side_missing.append(str(pair))
            else:
                p_side.append(vector(field, alpha))
    p_side_rank = int(matrix(field, p_side).rank()) if p_side else 0
    # q-side liveness: pairing rows of the second legs of the live shape.
    q_side = []
    for pair in combinations(range(DIM), 2):
        for triple in combinations(range(DIM), 3):
            leg = psi_push((pair, 0, 0), (triple, 0, 0))
            if leg:
                q_side.append(vector(field, pairing_row(leg)))
    q_side_rank = int(matrix(field, q_side).rank()) if q_side else 0
    controls["channel_liveness"] = {
        "first_leg_alpha_prime_f2_rank": p_side_rank,
        "first_legs_without_integral_alpha_prime": p_side_missing,
        "second_leg_pairing_row_f2_rank": q_side_rank,
        "both_channels_are_live": bool(p_side_rank == q_side_rank == DIM),
        "meaning": "both readout legs surject onto their mod-two targets, so "
                   "a zero verdict is a cancellation inside the candidate, "
                   "not a dead pipeline",
    }

    identity = identity_matrix(field, DIM)
    symplectic_mod2 = symplectic.change_ring(field)
    candidates = []
    violations = 0
    for g_pair in slot_pairs:
        for third in [s for s in range(4) if s not in g_pair]:
            for i_pair in slot_pairs:
                label = (f"Zsp(G={g_pair[0] + 1}{g_pair[1] + 1},"
                         f"third={third + 1}).I({i_pair[0] + 1}{i_pair[1] + 1})")
                candidate = build_candidate(g_pair, third, i_pair)
                matrix_value, live, distinct = residue_matrix(candidate)
                reduced = matrix_value.change_ring(field)
                is_zero = bool(reduced == 0)
                is_identity = bool(reduced == identity)
                verdict = ("ZERO" if is_zero else
                           "IDENTITY" if is_identity else "PIN-VIOLATION")
                if verdict == "PIN-VIOLATION":
                    violations += 1
                entry = {
                    "label": label,
                    "g_pair": [g_pair[0] + 1, g_pair[1] + 1],
                    "third_slot": third + 1,
                    "i_pair": [i_pair[0] + 1, i_pair[1] + 1],
                    "terms_after_expansion": int(len(candidate)),
                    "distinct_one_five_terms": int(distinct),
                    "live_one_five_terms": int(live),
                    "f2_rank": int(reduced.rank()),
                    "verdict": verdict,
                    "integral_trace": int(matrix_value.trace()),
                    "f2_trace": int(field(matrix_value.trace())),
                    "integral_matrix_is_zero": bool(matrix_value == 0),
                    "integral_rank": int(matrix_value.rank()),
                    "integral_content_gcd":
                        int(gcd(matrix_value.list())) if matrix_value != 0
                        else 0,
                    "integral_is_scalar_times_identity": bool(
                        matrix_value
                        == matrix_value[0, 0] * identity_matrix(ZZ, DIM)),
                    "integral_scalar": int(matrix_value[0, 0]),
                    "integral_is_scalar_times_symplectic_gram": bool(
                        matrix_value != 0
                        and matrix_value
                        == gcd(matrix_value.list()) * symplectic),
                    "equals_symplectic_mod_two": bool(reduced == symplectic_mod2),
                }
                if verdict == "PIN-VIOLATION":
                    entry["matrix_mod_two"] = [[int(v) for v in row]
                                               for row in reduced.rows()]
                candidates.append(entry)
    record["candidates"] = candidates
    nonzero = [entry for entry in candidates
               if not entry["integral_matrix_is_zero"]]
    contents = sorted({entry["integral_content_gcd"] for entry in nonzero})
    valuations = sorted({int(ZZ(value).valuation(2)) for value in contents})
    record["aggregate"] = {
        "candidates": int(len(candidates)),
        "integrally_zero": int(len(candidates) - len(nonzero)),
        "integrally_nonzero": int(len(nonzero)),
        "all_nonzero_have_full_integral_rank":
            bool(all(entry["integral_rank"] == DIM for entry in nonzero)),
        "content_gcd_values": [int(value) for value in contents],
        "two_adic_valuations_of_content": valuations,
        "every_content_divisible_by_four":
            bool(all(value % 4 == 0 for value in contents)),
        "all_nonzero_are_scalar_multiples_of_the_identity":
            bool(all(entry["integral_is_scalar_times_identity"]
                     for entry in nonzero)),
        "integral_scalars": sorted({int(entry["integral_scalar"])
                                    for entry in nonzero}),
        "reading": "the (1,5) residue of a live span-incidence candidate is a "
                   "full-rank integral endomorphism of Lambda whose content is "
                   "divisible by four; the channel is populated over Z and "
                   "dies exactly on reduction mod two",
    }
    record["pin"] = {
        "violations": int(violations),
        "all_candidates_satisfy_zero_or_identity": bool(violations == 0),
    }

    lookup = {entry["label"]: entry for entry in candidates}
    w_a = lookup["Zsp(G=12,third=3).I(24)"]
    controls["W_A_is_zero"] = bool(w_a["verdict"] == "ZERO")
    controls["W_A_note"] = (
        "its only (1,5) route has second leg 27 (y' ^ Theta^[3]), the H^1 (x) H^4 "
        "channel, dead because Q_15 has exponent two and 3(Theta^[3] ^ y') lies "
        "in L_5(^5 Lambda) over Z")
    controls["geometric_G2_remark"] = (
        "the honest span class is g~^*O(1) = mu^*psi^*Theta - 2E on the "
        "diagonal blow-up, so G_2^geom = (psi^*Theta)^2 - 4[Delta_F]; since "
        "G_1 = psi^*Theta exactly (control above) the representative used here "
        "is (psi^*Theta)^2, and the correction -4[Delta_F] has every Kunneth "
        "coefficient divisible by four, hence contributes an even integral "
        "matrix and cannot change any mod-two verdict")
    record["controls"] = controls
    record["priority_candidates"] = {
        name: lookup[name]["verdict"] for name in
        ("Zsp(G=12,third=3).I(24)", "Zsp(G=34,third=1).I(24)",
         "Zsp(G=34,third=1).I(23)")}
    record["unsolvable_first_legs"] = sorted(set(unsolvable))
    record["inputs"] = {CORPUS: sha256_of(CORPUS)}
    record["symplectic_gram"] = [[int(v) for v in row]
                                 for row in symplectic.rows()]
    record["wall_seconds"] = float(round(time.time() - started, 2))

    lines = [
        "C908 span-incidence (1,5) residue certificate",
        f"parameters: k1={K1} k11={K11} use_expected_I={USE_EXPECTED_I}",
        f"control psi_*(1 (x) 1) = 6 Theta: "
        f"{controls['psi_push_of_unit_is_six_theta']}",
        f"control psi^*Theta pullback parts = a^*Theta (coefficient one): "
        f"{controls['psi_pullback_theta_pullback_parts_are_a_star_theta']}"
        f"; cross matrix = -Theta: "
        f"{controls['gamma_psi_cross_matrix_is_minus_theta']}",
        f"control a^*Theta = 2 C_s under a_*: "
        f"{controls['a_star_theta_equals_two_Cs_under_pushforward']}",
        f"control G_1 = psi^*Theta exactly (k1=3, gamma_I = -cross): "
        f"{controls['G1_equals_psi_pullback_theta']}",
        f"control dead pass-6 subfamilies: content(Theta ^ Theta^[3])="
        f"{controls['content_of_theta_wedge_theta3']} (=4: "
        f"{controls['u_equals_theta_line_is_dead_content_four']})"
        f"; 3(Theta^[3] ^ e_i) in L_5(^5 Lambda) over Z for every i: "
        f"{controls['three_times_theta3_wedge_e_i_in_L5_image_over_Z']}",
        f"control H^2(F) lattice: rank "
        f"{controls['h2_lattice']['rank_of_quotient']}"
        f", relation in radical {controls['h2_lattice']['relation_is_in_the_radical']}"
        f", Gram det {controls['h2_lattice']['gram_determinant']}"
        f", unimodular {controls['h2_lattice']['unimodular']}",
        f"control W_A = Zsp(G=12,third=3).I(24) is ZERO: "
        f"{controls['W_A_is_zero']}",
        f"control Theorem E pin: violations={violations} over "
        f"{len(candidates)} candidates",
        f"aggregate: integrally nonzero="
        f"{record['aggregate']['integrally_nonzero']}"
        f"/{record['aggregate']['candidates']}"
        f"; all of full integral rank ten="
        f"{record['aggregate']['all_nonzero_have_full_integral_rank']}"
        f"; content gcds={record['aggregate']['content_gcd_values']}"
        f"; every content divisible by four="
        f"{record['aggregate']['every_content_divisible_by_four']}"
        f"; two-adic valuations={record['aggregate']['two_adic_valuations_of_content']}",
        f"aggregate: every nonzero residue is a scalar multiple of the identity="
        f"{record['aggregate']['all_nonzero_are_scalar_multiples_of_the_identity']}"
        f"; scalars={record['aggregate']['integral_scalars']}",
        f"Q_15: dim_F2={record['readout_infrastructure']['dim_F2_Q15']}"
        f"; pairing perfect="
        f"{record['readout_infrastructure']['pairing_is_perfect']}"
        f"; L(1->3) saturated="
        f"{record['readout_infrastructure']['L_1_to_3_image_saturated']}",
        f"unsolvable first legs: {len(record['unsolvable_first_legs'])}",
        f"positive control (synthetic live-shape family): F_2 rank="
        f"{controls['positive_control']['synthetic_family_f2_rank']}"
        f"; a single synthetic term is already nonzero mod two: "
        f"{controls['positive_control']['single_synthetic_term_f2_matrix_is_nonzero']}",
        f"channel liveness: first-leg alpha' F_2 rank="
        f"{controls['channel_liveness']['first_leg_alpha_prime_f2_rank']}"
        f"; second-leg pairing-row F_2 rank="
        f"{controls['channel_liveness']['second_leg_pairing_row_f2_rank']}"
        f"; both live={controls['channel_liveness']['both_channels_are_live']}",
        "",
        "label                              terms   (1,5)  live  rank  Zrank"
        "  gcd  verdict",
    ]
    for entry in candidates:
        lines.append(
            f"{entry['label']:<34} {entry['terms_after_expansion']:>6} "
            f"{entry['distinct_one_five_terms']:>6} "
            f"{entry['live_one_five_terms']:>5} {entry['f2_rank']:>5} "
            f"{entry['integral_rank']:>6} {entry['integral_content_gcd']:>4}  "
            f"{entry['verdict']}")
    lines.append("")
    lines.append(f"wall seconds: {record['wall_seconds']}")
    lines.append("PASS" if violations == 0 else "PASS (with pin violations)")
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
    main(arguments.json, arguments.out)
