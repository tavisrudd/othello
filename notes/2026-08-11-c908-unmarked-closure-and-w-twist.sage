#!/usr/bin/env sage
"""C908: certified inputs for the unmarked-base (1,5) closure and w-twist scoping.

The closure theorem of the accompanying note is a human proof.  This certificate
covers only its finite inputs, plus the load-bearing scoping fact for the
w-twist route.

Certified:

 1. ROBUST VANISHING.  For phi in M_5(F_4) whose F_4-coefficient trace is fixed by
    Frobenius, the F_2-linear trace of phi on Lambda_2 = F_4^5 = F_2^10 vanishes.
    Checked on canonical samples of both shapes the deck can take: F_2-rational
    matrices (plain semilinear deck) and Frobenius-Hermitian matrices with
    conj(A) = A^t (semilinear-composed-with-transpose deck).  This is what makes
    the closure theorem independent of which convention the exotic deck follows.
    A control confirms the test is sharp: scalar w times the identity has
    coefficient trace w outside F_2 and F_2-linear trace 1.

 2. THE W-TWIST NO-GO INPUT.  Every element of the actual integral endomorphism
    order End(J) of the exotic principal lattice has EVEN trace on
    Lambda = H^1(J,Z) of rank ten.  Certified on the 25 lattice generators and on
    all their pairwise products and sums, which span the order additively.  The
    conceptual reason is that End(J) (x) Q is the five-dimensional coefficient
    endomorphism algebra, so tr_Z = 2 tr_coeff; the certificate checks the actual
    integral order rather than relying on that description.
    Consequence, drawn in the note: no algebraic self-correspondence acting on
    H^1 through End(J) can have odd F_2-trace, so it cannot realize the
    w-twist rho.

 3. The F_2-dimension of the image of End(J) (x) F_2 in End(Lambda_2).

No randomness; canonical enumeration throughout.
"""

from contextlib import redirect_stdout
from io import StringIO
from itertools import combinations
import argparse
import hashlib
import json
import sys


SCHEMA_VERSION = "c908-unmarked-closure-and-w-twist/1"
DIM = 10
GENUS = 5

INPUT_SCRIPTS = ("notes/2026-08-10-c904-minimal-class-divisor-lattice.sage",)

REPLAY_COMMAND = (
    "nix shell nixpkgs#sage -c sage "
    "notes/2026-08-11-c908-unmarked-closure-and-w-twist.sage "
    "--json notes/2026-08-11-c908-unmarked-closure-and-w-twist.json "
    "--out notes/2026-08-11-c908-unmarked-closure-and-w-twist.out"
)


_saved_argv = list(sys.argv)
sys.argv = [sys.argv[0], "--export-constants"]
with redirect_stdout(StringIO()):
    load("notes/2026-08-10-c904-minimal-class-divisor-lattice.sage")
sys.argv = _saved_argv


def integral_endomorphism_lattice(basis):
    """Integral points in the 25-dimensional coefficient-endomorphism space.

    Reproduced verbatim from notes/2026-08-11-c904-full-ns-cube-p15-lattice.sage.
    """
    rational_rows = []
    for i in range(GENUS):
        for j in range(GENUS):
            coefficient = zero_matrix(QQ, GENUS)
            coefficient[i, j] = 1
            ambient = block_diagonal_matrix(coefficient, coefficient)
            principal = basis * ambient.transpose() * basis.inverse()
            rational_rows.append(vector(QQ, principal.list()))
    denominator = lcm(entry.denominator()
                      for row in rational_rows for entry in row)
    seed = span(ZZ, [vector(ZZ, denominator * row) for row in rational_rows])
    endomorphisms = seed.saturation()
    assert endomorphisms.rank() == 25
    matrices = [matrix(ZZ, DIM, DIM, row)
                for row in endomorphisms.basis_matrix().rows()]
    return endomorphisms, matrices


def f2_matrix_of(phi, field, basis_f4):
    """F_2-linear matrix of an F_4-linear phi on F_4^5 = F_2^10."""
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
    field = GF(2)
    quartic = GF(4, "w")
    omega = quartic.gen()
    basis_f4 = [quartic.one(), omega]

    # ---- 1. robust vanishing of the F_2-linear trace ---------------------
    samples = []

    def add_sample(label, phi):
        big = f2_matrix_of(phi, field, basis_f4)
        f4_trace = phi.trace()
        frobenius_fixed = bool(f4_trace == f4_trace ** 2)
        samples.append({
            "family": label,
            "f4_coefficient_trace": str(f4_trace),
            "coefficient_trace_is_frobenius_fixed": frobenius_fixed,
            "f2_linear_trace": int(big.trace()),
        })

    # (i) F_2-rational matrices: the elementary matrices span M_5(F_2).
    for a in range(GENUS):
        for b in range(GENUS):
            phi = zero_matrix(quartic, GENUS, GENUS)
            phi[a, b] = quartic.one()
            add_sample("F2_rational_elementary", phi)
    add_sample("F2_rational_identity", identity_matrix(quartic, GENUS))
    # (ii) Frobenius-Hermitian matrices: conj(A) = A^t.  Diagonal entries lie in
    # F_2; off-diagonal pairs are (c, conj(c)).
    for a in range(GENUS):
        phi = zero_matrix(quartic, GENUS, GENUS)
        phi[a, a] = quartic.one()
        add_sample("hermitian_diagonal", phi)
    for a in range(GENUS):
        for b in range(a + 1, GENUS):
            for scalar in (quartic.one(), omega, omega ** 2):
                phi = zero_matrix(quartic, GENUS, GENUS)
                phi[a, b] = scalar
                phi[b, a] = scalar ** 2
                add_sample("hermitian_off_diagonal", phi)
    frobenius_fixed_samples = [s for s in samples
                               if s["coefficient_trace_is_frobenius_fixed"]]
    vanishing = all(s["f2_linear_trace"] == 0 for s in frobenius_fixed_samples)

    # control: coefficient trace outside F_2 gives odd F_2-linear trace
    controls = []
    for phi, label in (
            (diagonal_matrix(quartic, [omega] * GENUS), "omega_times_identity"),
            (diagonal_matrix(quartic,
                             [omega] + [quartic.zero()] * (GENUS - 1)),
             "single_omega_entry")):
        big = f2_matrix_of(phi, field, basis_f4)
        controls.append({
            "family": label,
            "f4_coefficient_trace": str(phi.trace()),
            "coefficient_trace_is_frobenius_fixed":
                bool(phi.trace() == phi.trace() ** 2),
            "f2_linear_trace": int(big.trace()),
        })
    control_sharp = all(entry["f2_linear_trace"] == 1 for entry in controls)

    record["robust_vanishing"] = {
        "sample_count": int(len(samples)),
        "frobenius_fixed_sample_count": int(len(frobenius_fixed_samples)),
        "all_frobenius_fixed_samples_have_zero_f2_trace": bool(vanishing),
        "controls": controls,
        "control_is_sharp": bool(control_sharp),
        "statement":
            "if the F_4-coefficient trace of phi is Frobenius-fixed (in "
            "particular for every S_3-equivariant phi, whether the deck is plain "
            "semilinear or semilinear-composed-with-transpose) then the "
            "F_2-linear trace vanishes",
        "distinct_f2_traces_among_frobenius_fixed":
            sorted({s["f2_linear_trace"] for s in frobenius_fixed_samples}),
    }

    # ---- 2. the w-twist no-go input: End(J) has even trace ---------------
    _, _, basis, symplectic = principal_lattice("omega", 1)
    end_lattice, endomorphisms = integral_endomorphism_lattice(basis)
    generator_traces = [int(entry.trace()) for entry in endomorphisms]
    all_generators_even = all(value % 2 == 0 for value in generator_traces)
    product_traces = set()
    for left in endomorphisms:
        for right in endomorphisms:
            product_traces.add(int((left * right).trace()))
    products_even = all(value % 2 == 0 for value in product_traces)
    identity_trace = int(identity_matrix(ZZ, DIM).trace())
    record["end_j_trace_parity"] = {
        "generator_count": int(len(endomorphisms)),
        "generator_traces": sorted(generator_traces),
        "all_generator_traces_even": bool(all_generators_even),
        "all_pairwise_product_traces_even": bool(products_even),
        "distinct_product_trace_parities":
            sorted({value % 2 for value in product_traces}),
        "trace_of_the_identity_on_rank_ten_lattice": identity_trace,
        "identity_trace_is_even": bool(identity_trace % 2 == 0),
        "conceptual_reason":
            "End(J) (x) Q is the five-dimensional coefficient endomorphism "
            "algebra acting on Lambda = coefficient lattice (x) rank two, so "
            "tr_Z = 2 tr_coeff; the certificate checks the actual integral order",
        "consequence":
            "no Z-linear combination of endomorphisms, hence no algebraic "
            "self-correspondence acting on H^1 through End(J), has odd F_2-trace; "
            "in particular none reduces to the F_4-scalar w on Lambda_2, whose "
            "F_2-trace is 1",
    }

    # ---- 3. dimension of the mod-two image ------------------------------
    reduced = [vector(field, [field(value) for value in entry.list()])
               for entry in endomorphisms]
    image_dimension = matrix(field, reduced).rank()
    record["mod_two_image"] = {
        "f2_dimension_of_image_of_End_J": int(image_dimension),
        "f2_dimension_of_M5_F4": int(50),
        "f2_dimension_of_M5_F2": int(25),
        "image_too_small_for_M5_F4": bool(image_dimension < 50),
    }

    assert vanishing, "robust vanishing failed"
    assert control_sharp, "control failed to detect an odd coefficient trace"
    assert all_generators_even and products_even, "End(J) trace parity failed"

    record["inputs"] = {path: sha256_of(path) for path in INPUT_SCRIPTS}

    lines = [
        "C908 unmarked-base closure inputs and w-twist scoping",
        f"robust vanishing: {len(frobenius_fixed_samples)} of "
        f"{len(samples)} samples are Frobenius-fixed; all have zero F_2-trace: "
        f"{vanishing}; distinct F_2-traces="
        f"{record['robust_vanishing']['distinct_f2_traces_among_frobenius_fixed']}",
        "control (coefficient trace w, outside F_2): F_2-traces="
        f"{[entry['f2_linear_trace'] for entry in controls]}; sharp={control_sharp}",
        f"End(J) generators={len(endomorphisms)}; all traces even="
        f"{all_generators_even}; all pairwise product traces even={products_even}"
        f"; identity trace={identity_trace}",
        f"F_2-dimension of image of End(J) in End(Lambda_2)={int(image_dimension)}"
        f" (M_5(F_4) needs 50, M_5(F_2) has 25)",
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
