#!/usr/bin/env sage
"""Independent re-verification of the C908 pass-9 lattice adjudication.

Different code path from `notes/2026-08-12-c908-h3-lattice-adjudication.sage`:
this script loads NEITHER the pass-7 machinery NOR the gate-A certificate.  It
reads only the integer matrices A (262 x 940) and L_3 (252 x 120) recorded in
the main certificate's json and redoes the lattice arithmetic through PARI
(`matsnf`, `mathnf`, `matkerint`, `matdet` via cypari2), never through Sage's
`smith_form` / `hermite_form` / `saturation`.  The F_2 algebra for rho is plain
Python bit arithmetic, not Sage's GF(2) matrices.

Scope of the independence.  It is the LATTICE-LEVEL arithmetic that is checked
by a second backend here: the Smith form of L_3, the saturation and the sum
lattice, the correspondence rho, the corrected lattice H^, the escape group E
and the index of the exceptional image.  It is NOT an independent recomputation
of psi_* itself; that computation already has its own independent path in the
committed `notes/2026-08-11-c908-halfint-independent-check.sage`.

Re-verified here:
  1. Smith(L_3) = 1^110 2^10.
  2. Sat (built as the double integer kernel, i.e. the orthogonal complement of
     the left kernel) has index 2^10 over L_3(^3 Lambda), and
     L_3(^3 Lambda) + Z<columns of psi_*> = Sat exactly.
  3. rho : F_2^10 -> Sat / L_3(^3 Lambda) is well defined on all 940 columns
     and invertible.
  4. E := Z^130 / ImTheta is free of rank ten.
  5. The exceptional classes have index 2^10 in E, with quotient (Z/2)^10.
  6. Bonus: the transfer image col(A) equals H^ (equal PARI Hermite forms).
"""

from itertools import combinations
from operator import xor as bitwise_xor
import argparse
import json
import sys

MAIN_JSON = "notes/2026-08-12-c908-h3-lattice-adjudication.json"
SCHEMA_VERSION = "c908-h3-lattice-adjudication/1"
REPLAY_COMMAND = (
    "cd /home/tavis/src/othello && nix shell nixpkgs#sage -c sage "
    "notes/2026-08-12-c908-h3-lattice-independent-check.sage "
    "--out notes/2026-08-12-c908-h3-lattice-independent-check.out"
)

DIM = 10


# The Hermite normal forms below are canonical, but the naive algorithm blows
# up the intermediate entries; `mathnf(..., 4)` runs the LLL-assisted variant on
# the same canonical output.  A larger PARI stack ceiling is still needed.
pari.allocatemem(1 << 31, 1 << 34, silent=True)
HNF_FLAG = 4


def decode(strings):
    """Decode the json column encoding into a list of integer columns."""
    return [[int(entry) for entry in item.split()] for item in strings]


def pari_from_columns(columns):
    """PARI t_MAT whose columns are the given integer columns."""
    rows = len(columns[0])
    flat = []
    for row in range(rows):
        for column in columns:
            flat.append(int(column[row]))
    return pari.matrix(rows, len(columns), flat)


def columns_of(matrix_value):
    return [[int(entry) for entry in column] for column in matrix_value.Vec()]


def hnf_columns(matrix_value):
    """Columns of the PARI Hermite normal form of the column lattice.

    `mathnf(M, 4)` runs the LLL-assisted variant and returns the pair [H, U];
    the canonical H is the same lattice basis the naive algorithm produces.
    """
    result = matrix_value.mathnf(HNF_FLAG)
    if str(result.type()) == "t_VEC":
        result = result[0]
    return columns_of(result)


def divisor_counts(vector_value):
    counts = {}
    for entry in vector_value:
        value = abs(int(entry))
        if value == 0:
            continue
        counts[value] = counts.get(value, 0) + 1
    return dict(sorted(counts.items()))


def f2_rank_and_inverse(rows, size):
    """Gaussian elimination mod two on `size` bit-packed rows; returns rank."""
    working = list(rows)
    rank = 0
    for column in range(size):
        pivot = None
        for index in range(rank, len(working)):
            if (working[index] >> column) & 1:
                pivot = index
                break
        if pivot is None:
            continue
        working[rank], working[pivot] = working[pivot], working[rank]
        for index in range(len(working)):
            if index != rank and ((working[index] >> column) & 1):
                working[index] = bitwise_xor(working[index], working[rank])
        rank += 1
    return rank


def wedge_sign_nine_one(nine_set, index):
    """Sign of e_{nine_set} ^ e_index in ^10 Lambda; zero if index is repeated."""
    if index in nine_set:
        return 0
    sequence = list(nine_set) + [index]
    sign = 1
    for left in range(len(sequence)):
        for right in range(left + 1, len(sequence)):
            if sequence[left] > sequence[right]:
                sign = -sign
    return sign


def independent_main(out_path=None):
    lines = []
    checks = []

    def note(name, ok, detail=None):
        checks.append((name, bool(ok)))
        lines.append(f"  [{'PASS' if ok else 'FAIL'}] {name}"
                     + (f"  ({detail})" if detail is not None else ""))
        assert ok, f"INDEPENDENT CHECK FAILED: {name}"

    with open(MAIN_JSON, encoding="utf-8") as stream:
        record = json.load(stream)
    lines.append("C908 pass-9 independent lattice check (PARI backend)")
    lines.append(f"source: {MAIN_JSON}")
    note("0 schema of the source record",
         record["schema"] == SCHEMA_VERSION, record["schema"])

    A_columns = decode(record["matrices"]["A_262_by_940"])
    L3_columns = decode(record["matrices"]["L3_252_by_120"])
    note("0b matrix shapes",
         len(A_columns) == 940 and len(A_columns[0]) == 262
         and len(L3_columns) == 120 and len(L3_columns[0]) == 252,
         f"A is 262 x {len(A_columns)}, L_3 is {len(L3_columns[0])} x "
         f"{len(L3_columns)}")

    A1_columns = [column[:252] for column in A_columns]
    A2_columns = [column[252:] for column in A_columns]

    L3p = pari_from_columns(L3_columns)
    A1p = pari_from_columns(A1_columns)
    Ap = pari_from_columns(A_columns)

    # ---- 1. Smith form of L_3 ---------------------------------------------
    l3_divisors = divisor_counts(L3p.matsnf())
    note("1 PARI matsnf(L_3) = 1^110 2^10",
         l3_divisors == {1: 110, 2: 10}, l3_divisors)

    # ---- 2. saturation, index, sum lattice ---------------------------------
    # Sat = the orthogonal complement of the left kernel of L_3, obtained as a
    # double PARI integer kernel; integer kernels are saturated by construction.
    left_kernel = L3p.mattranspose().matkerint()               # 252 x 132
    note("2a the left kernel of L_3 has rank 132",
         len(columns_of(left_kernel)) == 132,
         len(columns_of(left_kernel)))
    Satp = left_kernel.mattranspose().matkerint()              # 252 x 120
    note("2b Sat has rank 120", len(columns_of(Satp)) == 120,
         len(columns_of(Satp)))

    gram_l3 = int((L3p.mattranspose() * L3p).matdet())
    gram_sat = int((Satp.mattranspose() * Satp).matdet())
    note("2c both Gram determinants are nonzero", gram_l3 != 0 and gram_sat != 0)
    index_squared = gram_l3 // gram_sat
    note("2d gram determinants divide exactly", gram_l3 % gram_sat == 0)
    note("2e [Sat : L_3(^3 Lambda)]^2 = (2^10)^2",
         index_squared == (2 ** DIM) ** 2, index_squared)

    sum_hnf = hnf_columns(pari.concat(L3p, A1p))
    sat_hnf = hnf_columns(Satp)
    note("2f L_3(^3 Lambda) + Z<psi_* T> = Sat (equal PARI Hermite forms)",
         sum_hnf == sat_hnf, f"{len(sum_hnf)} basis columns")

    # ---- 3. the correspondence rho ----------------------------------------
    snf = L3p.matsnf(1)
    U, V, D = snf[0], snf[1], snf[2]
    note("3a PARI returns U L_3 V = D", columns_of(U * L3p * V) == columns_of(D))
    # PARI places the elementary divisors one per column, not on the geometric
    # diagonal, so the support is located rather than assumed.
    D_columns = columns_of(D)
    support = {}
    single_entry_columns = True
    for j in range(120):
        nonzero = [i for i in range(252) if D_columns[j][i] != 0]
        if len(nonzero) != 1:
            single_entry_columns = False
            break
        support[j] = (nonzero[0], abs(D_columns[j][nonzero[0]]))
    note("3b each Smith column of D carries exactly one entry",
         single_entry_columns and len(support) == 120)
    elementary = sorted(value for _, value in support.values())
    torsion_positions = [row for row, value in support.values() if value == 2]
    note("3c the elementary divisors of D are 1^110 2^10",
         elementary == [1] * 110 + [2] * 10 and len(torsion_positions) == DIM,
         f"{len(torsion_positions)} torsion positions")
    support_rows = {row for row, _ in support.values()}
    free_rows = [i for i in range(252) if i not in support_rows]

    UA1 = columns_of(U * A1p)                                  # 940 columns
    note("3c-bis psi_* T has vanishing free Smith coordinates, i.e. lies in Sat",
         all(all(column[i] == 0 for i in free_rows) for column in UA1),
         f"{len(free_rows)} free rows")
    classes = [int(sum(int(column[position] % 2) << int(bit)
                       for bit, position in enumerate(torsion_positions)))
               for column in UA1]
    gamma_bits = [int(sum(int(column[k] % 2) << int(k) for k in range(DIM)))
                  for column in A2_columns]
    note("3d the first ten generators carry gamma = the standard basis",
         [gamma_bits[k] for k in range(DIM)] == [int(1) << int(k)
                                                 for k in range(DIM)])

    rho_columns = [int(classes[k]) for k in range(DIM)]        # bit-packed
    note("3e rho is invertible over F_2",
         f2_rank_and_inverse(list(rho_columns), DIM) == DIM)

    def apply_rho(bits):
        value = int(0)
        for k in range(DIM):
            if (bits >> k) & 1:
                value = bitwise_xor(value, rho_columns[k])
        return value

    mismatches = [n for n in range(940)
                  if apply_rho(gamma_bits[n]) != classes[n]]
    note("3f sigma(T) = rho(gamma(T)) mod L_3(^3 Lambda) for all 940 columns",
         not mismatches, f"{len(mismatches)} mismatches")

    # ---- 4/5. H^, the escape group and the exceptional image ---------------
    hat_columns = []
    for column in L3_columns:
        hat_columns.append(list(column) + [0] * DIM)
    for k in range(DIM):
        hat_columns.append(list(A_columns[k]))
    for k in range(DIM):
        hat_columns.append([0] * 252
                           + [2 if j == k else 0 for j in range(DIM)])
    hat_basis = hnf_columns(pari_from_columns(hat_columns))    # 130 columns
    note("4a H^ has rank 130", len(hat_basis) == 130, len(hat_basis))

    five_sets = list(combinations(range(DIM), 5))
    five_position = {item: n for n, item in enumerate(five_sets)}

    def five_sign(indices):
        rest = tuple(i for i in range(DIM) if i not in indices)
        sequence = list(indices) + list(rest)
        sign = 1
        for left in range(len(sequence)):
            for right in range(left + 1, len(sequence)):
                if sequence[left] > sequence[right]:
                    sign = -sign
        return sign

    # f_w[i] = < w ^ sigma(xi_i) >, w = e_S: sign(S) * sigma(xi_i)[complement S]
    escape_columns = []
    for indices in five_sets:
        rest = tuple(i for i in range(DIM) if i not in indices)
        sign = five_sign(indices)
        escape_columns.append([sign * hat_basis[i][five_position[rest]]
                               for i in range(130)])
    ImThetap = pari_from_columns(escape_columns)               # 130 x 252
    theta_divisors = divisor_counts(ImThetap.matsnf())
    note("4b ImTheta has 120 elementary divisors, all one",
         theta_divisors == {1: 120}, theta_divisors)
    note("4c E = Z^130 / ImTheta is free of rank 10",
         sum(theta_divisors.values()) == 120 and set(theta_divisors) == {1})

    nine_sets = list(combinations(range(DIM), 9))
    exceptional_columns = []
    for index in range(DIM):
        entries = []
        for i in range(130):
            total = 0
            for k in range(DIM):
                coefficient = hat_basis[i][252 + k]
                if coefficient:
                    total += coefficient * wedge_sign_nine_one(nine_sets[k],
                                                               index)
            entries.append(total)
        exceptional_columns.append(entries)
    jointp = pari.concat(ImThetap, pari_from_columns(exceptional_columns))
    joint_divisors = divisor_counts(jointp.matsnf())
    note("5a Z^130 / (ImTheta + <g_z>) = (Z/2)^10",
         joint_divisors == {1: 120, 2: 10}, joint_divisors)
    note("5b the exceptional image has index 2^10 in E",
         joint_divisors.get(2, 0) == DIM and sum(joint_divisors.values()) == 130,
         2 ** DIM)

    # ---- 6. bonus: the transfer image fills H^ -----------------------------
    image_hnf = hnf_columns(Ap)
    note("6 the transfer image col(A) equals H^ (equal PARI Hermite forms)",
         image_hnf == hat_basis, f"{len(image_hnf)} basis columns")

    lines.insert(2, "")
    lines.append("")
    lines.append(f"checks: {sum(1 for _, ok in checks if ok)} of {len(checks)}")
    lines.append("PASS" if all(ok for _, ok in checks) else "FAIL")
    output = "\n".join(lines) + "\n"
    if out_path:
        with open(out_path, "w", encoding="utf-8") as stream:
            stream.write(output)
    print(output, end="")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--out")
    arguments = parser.parse_args()
    independent_main(arguments.out)
