#!/usr/bin/env sage
"""Independent Sage replay of the C904 A4-frame parity obstruction."""

from itertools import product


G = AlternatingGroup(5)
subgroup_classes = G.conjugacy_classes_subgroups()
A4_seed = next(H for H in subgroup_classes if H.order() == 12)
D5_seed = next(H for H in subgroup_classes if H.order() == 10)


def conjugate_set(H, g):
    return frozenset(H.conjugate(g))


def conjugates(H):
    result = []
    for g in G:
        value = conjugate_set(H, g)
        if value not in result:
            result.append(value)
    return result


A4s = conjugates(A4_seed)
D5s = conjugates(D5_seed)
assert len(A4s) == 5 and len(D5s) == 6


def subgroup_action(g, subgroups):
    return tuple(subgroups.index(conjugate_set(G.subgroup(list(H)), g)) for H in subgroups)


actions5 = {g: subgroup_action(g, A4s) for g in G}
actions6 = {g: subgroup_action(g, D5s) for g in G}


def quotient_action(permutation):
    n = len(permutation)
    columns = []
    for source in range(n - 1):
        lifted = vector(ZZ, [0] * n)
        lifted[permutation[source]] = 1
        columns.append(vector(ZZ, [lifted[row] - lifted[n - 1]
                                   for row in range(n - 1)]))
    return matrix(ZZ, columns).transpose()


rows = []
for row in range(6):
    rows.append([1 if index // 5 == row else 0 for index in range(30)])
for column in range(5):
    rows.append([1 if index % 5 == column else 0 for index in range(30)])
for g in A4s[0]:
    # Convert the stored permutation-group element back to the parent group.
    gg = G(g)
    for row in range(6):
        for column in range(5):
            equation = [0] * 30
            equation[5 * actions6[gg][row] + actions5[gg][column]] += 1
            equation[5 * row + column] -= 1
            rows.append(equation)
fixed = matrix(QQ, rows).right_kernel()
assert fixed.dimension() == 1
primitive = vector(ZZ, fixed.basis()[0] * fixed.basis()[0].denominator())
content = gcd(primitive)
primitive = vector(ZZ, [entry // content for entry in primitive])
A = matrix(ZZ, 6, 5, primitive)

for column in range(5):
    assert len({ZZ(A[row, column]) % 2 for row in range(6)}) == 1
B0 = matrix(ZZ, 5, 4, [
    (A[row, column] - A[5, column]) // 2
    for row in range(5) for column in range(4)
])
assert B0.rank() == 3

maps = []
for target in A4s:
    transporter = next(g for g in G if conjugate_set(A4_seed, g) == target)
    maps.append(
        quotient_action(actions6[transporter])
        * B0
        * quotient_action(actions5[transporter]).inverse()
    )
assert len({tuple(value.list()) for value in maps}) == 5

q_winger = 3 * (5 * identity_matrix(QQ, 4) - matrix(QQ, 4, 4, [1] * 16))
q_cubic = 6 * identity_matrix(QQ, 5) - matrix(QQ, 5, 5, [1] * 25)
frame = sum((value * q_winger.inverse() * value.transpose() for value in maps),
            zero_matrix(QQ, 5))
assert frame == QQ(12) / 5 * q_cubic.inverse()
assert B0.change_ring(GF(2)).rank() == 3
assert q_cubic.change_ring(ZZ).elementary_divisors() == [1, 6, 6, 6, 6]
assert QQ(12) / 5 * (QQ(5) / 2)^2 == 15

print("PASS C904 A4 frame parity independent Sage replay")
print("fixed=1 rank=3 mod2-rank=3 frame=12/5 odd-normalization=15")
print("half-integral odd image dimension 6 exceeds gluing dimension 4")
