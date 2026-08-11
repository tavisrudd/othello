#!/usr/bin/env python3
"""Exact component-group parity at the four C904 marked cusps.

This deliberately computes only what follows from the log one-motive data.
It also gives a finite counterexample showing that the component group alone
does not determine the parity of the unordered theta-pair support.
"""

from itertools import product


def elements(moduli):
    return list(product(*(range(n) for n in moduli)))


def add(x, y, moduli):
    return tuple((a+b) % n for a, b, n in zip(x, y, moduli))


def neg(x, moduli):
    return tuple((-a) % n for a, n in zip(x, moduli))


def double(x, moduli):
    return add(x, x, moduli)


def audit_group(label, moduli):
    group = elements(moduli)
    doubles = {double(x, moduli) for x in group}
    two_torsion = [x for x in group
                   if double(x, moduli) == tuple(0 for _ in moduli)]
    assert len(group)//len(doubles) == 2
    assert len(two_torsion) == 2

    divided = []
    nondivided = []
    for alpha in group:
        fixed = sum(double(x, moduli) == alpha for x in group)
        assert fixed in (0, 2)
        free_orbits = (len(group)-fixed)//2
        total_orbits = free_orbits+fixed
        row = (alpha, fixed, free_orbits, total_orbits)
        (divided if alpha in doubles else nondivided).append(row)

    assert all(row[1] == 2 for row in divided)
    assert all(row[1] == 0 for row in nondivided)
    assert all(row[2] % 2 == 1 for row in nondivided)
    print(f"{label}: order={len(group)} coker(2)={len(group)//len(doubles)} "
          f"kernel(2)={len(two_torsion)}")
    print(f"{label}: nondivisible alpha count={len(nondivided)} "
          f"free unordered full-support pairs={nondivided[0][2]} odd")


audit_group("marked width 2", (3, 3, 3, 6))
audit_group("marked width 6", (6,))

# Sharp insufficiency on Phi=Z/6.  Both supports are inversion-stable and
# generate Phi, but their quotient-pair parities over alpha=1 differ.
moduli = (6,)
alpha = (1,)
supports = [
    {(0,), (1,), (5,)},
    {(0,), (1,), (2,), (4,), (5,)},
]
parities = []
for support in supports:
    assert {neg(x, moduli) for x in support} == support
    ordered = sum(add(x, y, moduli) == alpha
                  for x in support for y in support)
    assert ordered % 2 == 0
    parities.append((ordered//2) % 2)
    print("Z/6 symmetric generating support", sorted(x[0] for x in support),
          "unordered alpha=1 pairs=", ordered//2,
          "parity=", (ordered//2) % 2)
assert parities == [1, 0]
print("PASS: log component group alone does not determine theta-pair parity")
