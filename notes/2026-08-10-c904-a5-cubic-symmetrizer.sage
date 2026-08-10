#!/usr/bin/env sage
"""Generic Sebastiani--Thom exclusion for the irreducible A5 cubic pencil."""


def axis_action(permutation):
    columns = []
    for source in range(5):
        target = permutation[source]
        if target == 5:
            columns.append(vector(ZZ, [-1] * 5))
        else:
            columns.append(vector(ZZ, [1 if i == target else 0 for i in range(5)]))
    return matrix(ZZ, 5, 5, columns).transpose()


translation = axis_action([1, 2, 3, 4, 0, 5])
inversion = axis_action([5, 4, 2, 3, 1, 0])

ring = PolynomialRing(QQ, names=[f"x{i}" for i in range(5)])
x = ring.gens()
monomials = sorted(ring.monomials_of_degree(3), key=str)
monomial_index = {monomial: index for index, monomial in enumerate(monomials)}


def cubic_action(linear_action):
    # Using x |-> Mx rather than M^{-1}x does not change the common fixed space.
    linear_forms = list(linear_action.change_ring(ring) * vector(ring, x))
    columns = []
    for monomial in monomials:
        image = monomial.subs({x[i]: linear_forms[i] for i in range(5)})
        columns.append(vector(QQ, [image.monomial_coefficient(item) for item in monomials]))
    return matrix(QQ, columns).transpose()


relations = block_matrix(QQ, [
    [cubic_action(translation) - identity_matrix(QQ, len(monomials))],
    [cubic_action(inversion) - identity_matrix(QQ, len(monomials))],
])
invariants = relations.right_kernel().basis()
assert len(invariants) == 2
forms = [sum(coefficient * monomial for coefficient, monomial in zip(row, monomials))
         for row in invariants]

parameter_ring = PolynomialRing(QQ, "t")
t = parameter_ring.gen()
field = parameter_ring.fraction_field()
tensor = [[[field(
    QQ(forms[0].derivative(x[i]).derivative(x[j]).derivative(x[k]))
    + t * QQ(forms[1].derivative(x[i]).derivative(x[j]).derivative(x[k]))
) for k in range(5)] for j in range(5)] for i in range(5)]

rows = []
for i in range(5):
    for j in range(5):
        for k in range(5):
            row = [field.zero()] * 25
            for a in range(5):
                row[5 * a + i] += tensor[a][j][k]
                row[5 * a + j] -= tensor[i][a][k]
            rows.append(row)
symmetrizer = matrix(field, rows).right_kernel()
assert symmetrizer.dimension() == 1
identity = identity_matrix(field, 5)
symmetrizer_matrix = matrix(field, 5, 5, list(symmetrizer.basis()[0]))
assert symmetrizer_matrix == symmetrizer_matrix[0, 0] * identity

print("C904 generic irreducible-A5 cubic symmetrizer")
print(f"  cubic monomials={len(monomials)} invariant-pencil dimension={len(invariants)}")
print(f"  generic symmetrizer dimension={symmetrizer.dimension()}")
print("  symmetrizer=scalar line; generic cubic is not Sebastiani--Thom")
print("PASS")
