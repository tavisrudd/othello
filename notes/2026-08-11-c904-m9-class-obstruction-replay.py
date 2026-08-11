#!/usr/bin/env python3
"""Exact replay for the C904 M9/Bridgeland class obstruction.

This uses the Chow basis (1,h,l,p) of a cubic threefold with
h^2=3l, h*l=p, and products above codimension three equal to zero.
"""

from fractions import Fraction


def add(left, right):
    return tuple(a + b for a, b in zip(left, right))


def scale(scalar, value):
    return tuple(scalar * item for item in value)


def mul(left, right):
    r1, h1, l1, p1 = left
    r2, h2, l2, p2 = right
    return (
        r1 * r2,
        r1 * h2 + h1 * r2,
        r1 * l2 + l1 * r2 + 3 * h1 * h2,
        r1 * p2 + p1 * r2 + h1 * l2 + l1 * h2,
    )


def twist(value, exponent):
    exp_h = (
        Fraction(1),
        Fraction(exponent),
        Fraction(3 * exponent**2, 2),
        Fraction(exponent**3, 2),
    )
    return mul(value, exp_h)


ch_o_c = (0, 0, 6, -6)
ch_i_c = add((1, 0, 0, 0), scale(-1, ch_o_c))
ch_i_c_2 = twist(ch_i_c, 2)
ch_a = add((1, 0, 0, 0), ch_i_c_2)
ch_e = twist(ch_a, -1)
td_x = (1, 1, 2, 1)
chi_e = mul(ch_e, td_x)[3]

assert ch_i_c_2 == (1, 2, 0, -2)
assert ch_a == (2, 2, 0, -2)
assert ch_e == (2, 0, -3, 0)
assert chi_e == -1

norm_residues = {
    (n * n + n * m + m * m) % 3 for n in range(3) for m in range(3)
}
assert norm_residues == {0, 1}
assert not any(
    n * n + n * m + m * m == 8
    for n in range(-8, 9)
    for m in range(-8, 9)
)

# In c1(det Rp_* End(E)), q=-12l+h*a+delta+... .
# The q^2/12 cross-term and 2l*q term have coefficients -2 and +2.
grr_cross = Fraction(2 * -12, 12)
grr_todd = Fraction(2)
assert grr_cross + grr_todd == 0

print(f"ch(I_C(2h))={ch_i_c_2}")
print(f"ch(A)={ch_a}")
print(f"ch(E=A(-h))={ch_e}; chi(E)={chi_e}")
print(f"Eisenstein norm residues mod 3={sorted(norm_residues)}; norm 8 impossible")
print(f"GRR horizontal cancellation={grr_cross}+{grr_todd}=0")
