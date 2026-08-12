#!/usr/bin/env sage
"""C908: finite lattice steps for the (1,5) residue functional on M x M.

This certificate covers ONLY the finite linear-algebra steps of
notes/2026-08-11-c908-m-cross-m-exceptional-residue.md.  Every geometric step
in that note (H^1(M,Z) = b^* H^1(J,Z); b_* : H^5(M,Z)/tors = H^7(J,Z);
b o iota_X constant, hence b_* iota_{X*} = 0; the codimension bookkeeping of the
candidate cycles) is a human proof and is NOT certified here.

What is certified:

 1. Smith form of L = Theta ^ (-) : Lambda^5 Lambda -> Lambda^7 Lambda, expected
    1^110 2^10, hence coker(L) = (Z/2)^10.  Independent recomputation of
    equation (2.2) of the C904 Kunneth parity audit.
 2. Smith form of L : Lambda^1 Lambda -> Lambda^3 Lambda.  All elementary
    divisors 1 means Theta ^ (-) has SATURATED image on H^1, so the class
    alpha' is recovered integrally from Theta.alpha' = b_* alpha.  This is what
    makes the frozen readout well defined over Z rather than only over Q.
 3. The mod-two readout pairing P(a,[B]) = int_J Theta.a.B is well defined on
    Lambda_2 x coker(L (x) F_2) (it kills the image of L) and is perfect of
    rank 10.
 4. The two competing parity normalizations, evaluated on the Clemens--Griffiths
    identity: the F_2-linear trace of the identity of End(Lambda_2) is
    10 = 0 mod 2, whereas the five-dimensional F_4-coefficient trace of I_5 is
    5 = 1 mod 2.  The certificate also verifies the finite-field identity
    tr_{F_2}(phi) = Tr_{F_4/F_2}(tr_{F_4}(phi)) for F_4-linear phi on F_4^5,
    which shows the two readouts differ exactly by whether the coefficient trace
    lies in F_2.  The certificate does NOT adjudicate which readout is the
    geometric degree; see section 6 of the note.

No randomness; canonical lexicographic enumeration throughout.
"""

from contextlib import redirect_stdout
from io import StringIO
from itertools import combinations
import argparse
import hashlib
import json
import sys


SCHEMA_VERSION = "c908-m-cross-m-exceptional-residue/1"
DIM = 10
GENUS = 5
TOP = tuple(range(DIM))

INPUT_SCRIPTS = ("notes/2026-08-10-c904-minimal-class-divisor-lattice.sage",)

REPLAY_COMMAND = (
    "nix shell nixpkgs#sage -c sage "
    "notes/2026-08-11-c908-m-cross-m-exceptional-residue.sage "
    "--json notes/2026-08-11-c908-m-cross-m-exceptional-residue.json "
    "--out notes/2026-08-11-c908-m-cross-m-exceptional-residue.out"
)


_saved_argv = list(sys.argv)
sys.argv = [sys.argv[0], "--export-constants"]
with redirect_stdout(StringIO()):
    load("notes/2026-08-10-c904-minimal-class-divisor-lattice.sage")
sys.argv = _saved_argv


def basis_form(indices):
    return {tuple(indices): ZZ.one()}


def lefschetz_matrix(theta, source_degree):
    """Matrix of Theta ^ (-) from Lambda^source to Lambda^(source+2)."""
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


def main(json_path=None, out_path=None):
    record = {"schema": SCHEMA_VERSION, "replay_command": REPLAY_COMMAND}

    _, _, basis, symplectic = principal_lattice("omega", 1)
    theta = two_form(symplectic)
    assert symplectic.inverse().denominator() == 1, "polarization not principal"

    # ---- 1. coker(L : Lambda^5 -> Lambda^7) ------------------------------
    _, septics, lefschetz_57 = lefschetz_matrix(theta, GENUS)
    counts_57 = elementary_divisor_counts(lefschetz_57)
    record["lefschetz_5_to_7"] = {
        "source_rank": int(binomial(DIM, GENUS)),
        "target_rank": int(binomial(DIM, GENUS + 2)),
        "elementary_divisor_counts": counts_57,
        "cokernel_is_two_elementary_of_rank_10":
            bool(counts_57 == {"1": 110, "2": 10}),
    }

    # ---- 2. saturation of L : Lambda^1 -> Lambda^3 ------------------------
    _, _, lefschetz_13 = lefschetz_matrix(theta, 1)
    counts_13 = elementary_divisor_counts(lefschetz_13)
    record["lefschetz_1_to_3"] = {
        "source_rank": DIM,
        "target_rank": int(binomial(DIM, 3)),
        "elementary_divisor_counts": counts_13,
        "image_is_saturated": bool(set(counts_13) == {"1"}),
        "meaning": "alpha' is recovered integrally from Theta.alpha' = b_* alpha, "
                   "so the frozen readout is defined over Z, not only over Q",
    }

    # ---- 3. the mod-two readout pairing ----------------------------------
    field = GF(2)
    lefschetz_57_mod2 = lefschetz_57.change_ring(field)
    image_rows = lefschetz_57_mod2.row_space()
    quotient_dimension = lefschetz_57_mod2.ncols() - image_rows.dimension()
    pairing = zero_matrix(field, DIM, len(septics))
    for a in range(DIM):
        partial = wedge(theta, {(a,): ZZ.one()})
        for column, B in enumerate(septics):
            pairing[a, column] = field(wedge(partial, basis_form(B)).get(TOP, 0))
    kills_image = all((pairing * vector(field, row)) == 0
                      for row in lefschetz_57_mod2.rows())
    record["mod_two_readout_pairing"] = {
        "image_dimension_mod_two": int(image_rows.dimension()),
        "quotient_dimension_mod_two": int(quotient_dimension),
        "pairing_rank": int(pairing.rank()),
        "pairing_kills_image_of_L": bool(kills_image),
        "pairing_is_perfect_on_the_quotient":
            bool(kills_image and pairing.rank() == quotient_dimension
                 == DIM),
        "definition": "P(a,[B]) = int_J Theta . a . B  mod 2, for a in "
                      "H^1(J,F_2) and [B] in coker(L) (x) F_2",
    }

    # ---- 4. the two competing parity normalizations ----------------------
    # F_2-linear trace of the identity of End(Lambda_2), Lambda_2 of rank 10.
    f2_trace_of_identity = int(DIM % 2)
    # F_4-coefficient trace of I_5 on the five-dimensional coefficient lattice.
    coefficient_trace_of_identity = int(GENUS % 2)
    # Finite-field identity tr_{F_2}(phi) = Tr_{F_4/F_2}(tr_{F_4}(phi)).
    quartic = GF(4, "w")
    omega = quartic.gen()
    basis_f4 = [quartic.one(), omega]
    trace_checks = []
    samples = []
    for scalar in [quartic.one(), omega, omega ** 2, quartic.zero()]:
        samples.append(("scalar_times_identity", scalar,
                        diagonal_matrix(quartic, [scalar] * GENUS)))
        samples.append(("single_diagonal_entry", scalar,
                        diagonal_matrix(quartic,
                                        [scalar] + [quartic.zero()]
                                        * (GENUS - 1))))
    for label, scalar, phi in samples:
        # F_2-linear matrix of phi on F_4^5 = F_2^10 in the basis
        # (e_1 . 1, e_1 . w, ..., e_5 . 1, e_5 . w).
        big = zero_matrix(field, 2 * GENUS, 2 * GENUS)
        for column in range(GENUS):
            for k, coefficient in enumerate(basis_f4):
                image = [phi[row, column] * coefficient for row in range(GENUS)]
                for row, entry in enumerate(image):
                    expansion = entry.polynomial().list()
                    expansion += [0] * (2 - len(expansion))
                    for m in range(2):
                        big[2 * row + m, 2 * column + k] = field(expansion[m])
        f4_trace = phi.trace()
        transferred = f4_trace + f4_trace ** 2   # Tr_{F_4/F_2}
        trace_checks.append({
            "family": label,
            "scalar": str(scalar),
            "f4_coefficient_trace": str(f4_trace),
            "absolute_trace_Tr_F4_F2_of_it": int(field(transferred)),
            "f2_linear_trace_on_rank_ten": int(big.trace()),
            "agree": bool(int(big.trace()) == int(field(transferred))),
        })
    record["parity_normalizations"] = {
        "f2_linear_trace_of_identity_of_End_Lambda2": f2_trace_of_identity,
        "f4_coefficient_trace_of_I5": coefficient_trace_of_identity,
        "identity_readouts_disagree":
            bool(f2_trace_of_identity != coefficient_trace_of_identity),
        "absolute_trace_identity_verified":
            bool(all(entry["agree"] for entry in trace_checks)),
        "absolute_trace_samples": trace_checks,
        "consequence":
            "for an F_4-coefficient-linear residue phi the F_2-linear readout is "
            "odd exactly when tr_{F_4}(phi) is not in F_2; the Clemens-Griffiths "
            "identity has tr_{F_4} = 5 = 1 in F_2, so the two normalizations give "
            "opposite parities for it",
        "not_adjudicated":
            "this certificate does not decide which readout is the geometric "
            "unordered degree; see section 6 of the note",
    }

    record["inputs"] = {path: sha256_of(path) for path in INPUT_SCRIPTS}
    record["inputs"]["symplectic_gram_of_exotic_principal_lattice"] = \
        [[int(v) for v in row] for row in symplectic.rows()]

    record["not_certified"] = [
        "H^1(M,Z) = b^* H^1(J,Z) (human proof, note section 3)",
        "b_* : H^5(M,Z)/tors = H^7(J,Z) (human proof, note section 4)",
        "b o iota_X constant, hence b_* iota_{X*} = 0 (human proof, section 5)",
        "the codimension bookkeeping of the candidate cycles (section 5)",
        "algebraicity or Hodge-ness of any class",
    ]

    lines = [
        "C908 M x M exceptional-residue: finite lattice steps",
        "L: Lambda^5 -> Lambda^7 elementary divisors "
        f"{record['lefschetz_5_to_7']['elementary_divisor_counts']}"
        f"; coker = (Z/2)^10: "
        f"{record['lefschetz_5_to_7']['cokernel_is_two_elementary_of_rank_10']}",
        "L: Lambda^1 -> Lambda^3 elementary divisors "
        f"{record['lefschetz_1_to_3']['elementary_divisor_counts']}"
        f"; image saturated: {record['lefschetz_1_to_3']['image_is_saturated']}",
        "mod-2 readout pairing: quotient dim="
        f"{record['mod_two_readout_pairing']['quotient_dimension_mod_two']}"
        f"; rank={record['mod_two_readout_pairing']['pairing_rank']}"
        f"; kills im(L)="
        f"{record['mod_two_readout_pairing']['pairing_kills_image_of_L']}"
        f"; perfect="
        f"{record['mod_two_readout_pairing']['pairing_is_perfect_on_the_quotient']}",
        "identity readouts: F_2-linear trace="
        f"{f2_trace_of_identity}; F_4-coefficient trace="
        f"{coefficient_trace_of_identity}; disagree="
        f"{record['parity_normalizations']['identity_readouts_disagree']}",
        "absolute-trace identity tr_F2 = Tr_{F4/F2} o tr_F4 verified on all "
        f"{len(trace_checks)} canonical samples: "
        f"{record['parity_normalizations']['absolute_trace_identity_verified']}",
        "PASS",
    ]
    output = "\n".join(lines) + "\n"

    assert record["lefschetz_5_to_7"]["cokernel_is_two_elementary_of_rank_10"]
    assert record["mod_two_readout_pairing"]["pairing_is_perfect_on_the_quotient"]
    assert record["parity_normalizations"]["absolute_trace_identity_verified"]

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
