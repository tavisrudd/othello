#!/usr/bin/env python3
"""Independent replay of the load-bearing C908 p15 Fourier-saturation facts.

This file imports nothing from Sage and reconstructs nothing from the primary
Sage run: it hard-codes the Gram matrix of the exotic principal lattice (printed
by the primary certificate as
`inputs.symplectic_gram_of_exotic_principal_lattice`) and recomputes, with
plain-integer arithmetic and its own exterior algebra, Hermite reduction, and
Bareiss determinant:

  1. theta^2 has all coefficients even, hence theta^2 = 2 theta^[2] integrally;
  2. every theta^k/k! is integral, and theta^[5] is the positive top class, so
     the polarization is principal in this basis;
  3. the pairing A[I, i] = integral(theta^2 . u_I . u_i) is everywhere even and
     its halved matrix has row space exactly Z^10 -- therefore
     rho_15 of the FULL integral (5,1) Kunneth lattice is exactly 2 Z^100;
  4. det(Gram) = +/- 1, which together with F(u_I) = eps(I) * Lambda(phi^*)(u_Ic)
     proves that the cohomological Fourier transform is unimodular in every
     degree without forming any 252x252 determinant;
  5. F(theta^[k]) = +/- theta^[5-k] for k = 0..5.

Facts 1 and 3 are what the negative closure rests on; 4 and 5 validate the
Fourier convention.  The Smith form of L : Lambda^5 -> Lambda^7 is not recomputed
here: its value 1^110 2^10 is independently attested by the committed C904
certificate notes/2026-08-11-c904-symmetric-theta-kunneth-parity.out and is
recomputed by the primary C908 generator.

Replay:

    nix shell nixpkgs#sage -c sage -python \
      notes/2026-08-11-c908-p15-fourier-saturation-replay.py \
      > notes/2026-08-11-c908-p15-fourier-saturation-replay.out

(The `sage -python` wrapper is used only because it is guaranteed present on
this host; the script needs nothing beyond the standard library.)
"""

from itertools import combinations
import sys

DIM = 10
GENUS = 5
TOP = tuple(range(DIM))

# Gram matrix of the exotic A5 principal lattice, in the same basis as
# notes/2026-08-10-c904-minimal-class-divisor-lattice.sage.
GRAM = [
    [0, 2, 3, 0, 0, 0, -1, -1, -1, 4],
    [-2, 0, 0, -3, -3, -1, 0, -1, -1, 4],
    [-3, 0, 0, -2, -3, -1, -1, 0, -1, 4],
    [0, 3, 2, 0, 0, -1, -1, -1, 0, 4],
    [0, 3, 3, 0, 0, -1, -1, -1, -1, 5],
    [0, 1, 1, 1, 1, 0, 0, 0, 0, 0],
    [1, 0, 1, 1, 1, 0, 0, 0, 0, 0],
    [1, 1, 0, 1, 1, 0, 0, 0, 0, 0],
    [1, 1, 1, 0, 1, 0, 0, 0, 0, 0],
    [-4, -4, -4, -4, -5, 0, 0, 0, 0, 0],
]


def wedge(left, right):
    result = {}
    for left_indices, left_value in left.items():
        left_set = set(left_indices)
        for right_indices, right_value in right.items():
            if left_set.intersection(right_indices):
                continue
            inversions = sum(1 for i in left_indices for j in right_indices
                             if i > j)
            indices = tuple(sorted(left_indices + right_indices))
            sign = -1 if inversions % 2 else 1
            result[indices] = result.get(indices, 0) + sign * left_value * right_value
    return {indices: value for indices, value in result.items() if value}


def factorial(n):
    result = 1
    for k in range(2, n + 1):
        result *= k
    return result


def bareiss_determinant(matrix_rows):
    """Fraction-free Bareiss determinant of a square integer matrix."""
    rows = [list(row) for row in matrix_rows]
    size = len(rows)
    sign = 1
    previous = 1
    for k in range(size - 1):
        if rows[k][k] == 0:
            swap = next((i for i in range(k + 1, size) if rows[i][k] != 0), None)
            if swap is None:
                return 0
            rows[k], rows[swap] = rows[swap], rows[k]
            sign = -sign
        for i in range(k + 1, size):
            for j in range(k + 1, size):
                numerator = rows[i][j] * rows[k][k] - rows[i][k] * rows[k][j]
                assert numerator % previous == 0, "Bareiss division failed"
                rows[i][j] = numerator // previous
        previous = rows[k][k]
    return sign * rows[size - 1][size - 1]


def echelon_pivots(rows, columns):
    """Pivot entries of an integer row-echelon form of `rows`."""
    work = [list(row) for row in rows]
    pivots = []
    top = 0
    for column in range(columns):
        while True:
            nonzero = [i for i in range(top, len(work)) if work[i][column]]
            if len(nonzero) <= 1:
                break
            nonzero.sort(key=lambda i: abs(work[i][column]))
            head = nonzero[0]
            for other in nonzero[1:]:
                factor = work[other][column] // work[head][column]
                work[other] = [a - factor * b
                               for a, b in zip(work[other], work[head])]
        nonzero = [i for i in range(top, len(work)) if work[i][column]]
        if nonzero:
            index = nonzero[0]
            work[top], work[index] = work[index], work[top]
            pivots.append(abs(work[top][column]))
            top += 1
    return pivots


def main():
    theta = {(i, j): GRAM[i][j]
             for i in range(DIM) for j in range(i + 1, DIM) if GRAM[i][j]}

    # (1) theta^2 is divisible by two.
    theta2 = wedge(theta, theta)
    theta2_even = all(value % 2 == 0 for value in theta2.values())

    # (2) divided powers of theta, and principality.
    powers = [{(): 1}]
    current = {(): 1}
    divided_integral = True
    for k in range(1, GENUS + 1):
        current = wedge(current, theta)
        divided = {}
        for indices, value in current.items():
            if value % factorial(k):
                divided_integral = False
            divided[indices] = value // factorial(k)
        powers.append({i: v for i, v in divided.items() if v})
    principal = powers[GENUS] == {TOP: 1}

    # (3) the rho_15 readout pairing and its halved row space.
    quintics = list(combinations(range(DIM), GENUS))
    pairing = []
    for I in quintics:
        partial = wedge(theta2, {I: 1})
        pairing.append([wedge(partial, {(i,): 1}).get(TOP, 0)
                        for i in range(DIM)])
    pairing_even = all(value % 2 == 0 for row in pairing for value in row)
    halved = [[value // 2 for value in row] for row in pairing]
    halved_pivots = echelon_pivots(halved, DIM)
    halved_spans_full = (len(halved_pivots) == DIM
                         and all(value == 1 for value in halved_pivots))

    # (4) unimodularity of the Fourier transform, structurally.
    gram_determinant = bareiss_determinant(GRAM)

    # (5) F(theta^[k]) = +/- theta^[5-k].
    duals = [{(m,): GRAM[j][m] for m in range(DIM) if GRAM[j][m]}
             for j in range(DIM)]

    def fourier_monomial(indices):
        complement = tuple(sorted(set(range(DIM)) - set(indices)))
        sign = wedge({tuple(indices): 1}, {complement: 1}).get(TOP, 0)
        assert sign in (1, -1)
        image = {(): 1}
        for index in complement:
            image = wedge(image, duals[index])
        return {key: sign * value for key, value in image.items()}

    def fourier_form(form):
        result = {}
        for indices, value in form.items():
            for key, other in fourier_monomial(indices).items():
                result[key] = result.get(key, 0) + value * other
        return {key: value for key, value in result.items() if value}

    theta_pairs = []
    for k in range(GENUS + 1):
        image = fourier_form(powers[k])
        expected = powers[GENUS - k]
        negated = {i: -v for i, v in expected.items()}
        theta_pairs.append(image == expected or image == negated)

    checks = [
        ("theta^2 all coefficients even", theta2_even),
        ("theta^k/k! integral for k<=5", divided_integral),
        ("theta^[5] equals the positive top class (principal)", principal),
        ("readout pairing A[I,i] everywhere even", pairing_even),
        ("halved pairing row space is all of Z^10", halved_spans_full),
        ("det(Gram) = +/- 1", abs(gram_determinant) == 1),
        ("F(theta^[k]) = +/- theta^[5-k] for all k", all(theta_pairs)),
    ]

    lines = ["C908 p15 Fourier saturation: independent replay"]
    for label, value in checks:
        lines.append(f"{label}: {value}")
    lines.append(f"quintic index count={len(quintics)}"
                 f"; halved pivots={tuple(halved_pivots)}"
                 f"; det(Gram)={gram_determinant}")
    lines.append("consequence: rho_15(full integral (5,1) Kunneth lattice)"
                 " = 2 Z^100, hence its intersection with the saturated"
                 " rank-25 End(J) is exactly 2 End(J)")
    passed = all(value for _, value in checks)
    lines.append("PASS" if passed else "FAIL")
    print("\n".join(lines))
    return 0 if passed else 1


if __name__ == "__main__":
    sys.exit(main())
