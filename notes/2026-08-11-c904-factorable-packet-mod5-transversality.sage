#!/usr/bin/env sage
"""Independent F_5 transversality check for the degree-15 packet.

The matrix is twice the symmetric matrix in the independent Macaulay2
replay.  Scaling by two does not change the rank locus in characteristic 5.
"""

from itertools import product

k = GF(5)
R = PolynomialRing(k, names=("p01", "p02", "p03", "p12", "p13", "p23"))
p01, p02, p03, p12, p13, p23 = R.gens()
ps = list(R.gens())

A = matrix(R, [
    [-2*p01, -p03+p12, 0, 0, p01-2*p02-p12-2*p13],
    [-p03+p12, -2*p23, 0, 0, 2*p02-p03+p12+p13-p23],
    [0, 0, -2*p02, -p03-p12,
     -2*p01+2*p02-2*p03-p12+p13+p23],
    [0, 0, -p03-p12, -2*p13, 2*p02-2*p03+2*p23],
    [p01-2*p02-p12-2*p13,
     2*p02-p03+p12+p13-p23,
     -2*p01+2*p02-2*p03-p12+p13+p23,
     2*p02-2*p03+2*p23,
     -4*p01-2*p03-4*p12-4*p13-2*p23],
])
pluecker = p01*p23-p02*p13+p03*p12
minors3 = A.minors(3)
generators = [pluecker] + minors3
irrelevant_p = R.ideal(ps)
packet_ideal = R.ideal(generators).saturation(irrelevant_p)[0]
packet_hp = packet_ideal.hilbert_polynomial()
assert packet_ideal.dimension() == 1 and packet_hp == 15


def projective_points(field, dimension):
    """Normalized representatives in P^(dimension-1)(field)."""
    for lead in range(dimension):
        for tail in product(field, repeat=dimension-lead-1):
            yield vector(field, [0]*lead + [1] + list(tail))


points = []
for point in projective_points(k, 6):
    values = dict(zip(ps, point))
    if pluecker.subs(values) != 0:
        continue
    evaluated = matrix(k, 5, 5, [entry.subs(values) for entry in A.list()])
    if evaluated.rank() <= 2:
        points.append((point, evaluated))

assert len(points) == 1
point, evaluated = points[0]
assert evaluated.rank() == 2

jacobian = matrix(R, [[f.derivative(p) for p in ps] for f in generators])
values = dict(zip(ps, point))
jacobian_at_point = matrix(k, jacobian.nrows(), jacobian.ncols(),
                           [entry.subs(values) for entry in jacobian.list()])
# Rank five means affine-cone tangent dimension one, hence projective tangent
# dimension zero.  This is the exact relative-fibre transversality needed by
# the simple-root form of Hensel's lemma.
assert jacobian_at_point.rank() == 5

S = PolynomialRing(k, names=("x0", "x1", "x2", "x3", "z"))
xs = vector(S, S.gens())
quadric = (xs * evaluated.change_ring(S) * xs)
factorization = quadric.factor()
assert len(factorization) == 2
assert sorted(f.degree() for f, exponent in factorization) == [1, 1]
assert all(exponent == 1 for _, exponent in factorization)

# Reconstruct the decomposable two-plane from p01 != 0 and independently
# check the component Hilbert polynomials of a section in its pencil.
x0, x1, x2, x3, z = S.gens()
q = {
    (0, 1): -x0^2+x0*z-2*x2*z-2*z^2,
    (0, 2): -x2^2-2*x0*z+2*x1*z+2*x2*z+2*x3*z,
    (0, 3): -x0*x1-x2*x3-x1*z-2*x2*z-2*x3*z-z^2,
    (1, 2): x0*x1-x2*x3-x0*z+x1*z-x2*z-2*z^2,
    (1, 3): -x3^2-2*x0*z+x1*z+x2*z-2*z^2,
    (2, 3): -x1^2-x1*z+x2*z+2*x3*z-z^2,
}
pair_order = [(0, 1), (0, 2), (0, 3), (1, 2), (1, 3), (2, 3)]
packet_quadric = sum(point[i]*q[pair] for i, pair in enumerate(pair_order))
assert quadric == 2*packet_quadric
linear_factors = [factor for factor, exponent in factorization]

s = vector(k, [1, 0, -point[3]/point[0], -point[4]/point[0]])
t = vector(k, [0, point[0], point[1], point[2]])
assert vector(k, [s[i]*t[j]-s[j]*t[i]
                  for i, j in pair_order]) == point


def wedge_quadric(left, right):
    return sum((left[i]*right[j]-left[j]*right[i])*q[(i, j)]
               for i in range(4) for j in range(i+1, 4))


def complement(section):
    rows = [section]
    result = []
    for i in range(4):
        candidate = vector(k, [j == i for j in range(4)])
        if matrix(k, rows+[candidate]).rank() > len(rows):
            rows.append(candidate)
            result.append(candidate)
        if len(rows) == 4:
            break
    assert len(result) == 3
    return result


pfaffian = q[(0, 1)]*q[(2, 3)]-q[(0, 2)]*q[(1, 3)] \
    + q[(0, 3)]*q[(1, 2)]
F, remainder = pfaffian.quo_rem(z)
assert remainder == 0
irrelevant_x = S.ideal(S.gens())
component_data = None
component_candidates = []
for lam in k:
    section = s+lam*t
    section_quadrics = [wedge_quadric(section, other)
                        for other in complement(section)]
    curve = S.ideal(section_quadrics).saturation(S.ideal(z))[0]
    if F not in curve:
        continue
    first = ((curve+S.ideal(linear_factors[0]))
             .saturation(S.ideal(linear_factors[1]))[0]
             .saturation(irrelevant_x)[0])
    second = ((curve+S.ideal(linear_factors[1]))
              .saturation(S.ideal(linear_factors[0]))[0]
              .saturation(irrelevant_x)[0])
    hps = (first.hilbert_polynomial(), second.hilbert_polynomial())
    intersection_ideal = (first+second).saturation(irrelevant_x)[0]
    intersection = intersection_ideal.hilbert_polynomial()
    intersection_reduced = intersection_ideal.radical() == intersection_ideal
    variable = hps[0].parent().gen()
    if hps == (3*variable+1, 3*variable+1):
        datum = (lam, curve.hilbert_polynomial(), hps, intersection,
                 intersection_reduced,
                 first.is_prime(), second.is_prime())
        component_candidates.append(datum)
        if datum[-3] and datum[-2] and datum[-1] and intersection == 2:
            component_data = datum

if component_data is None and component_candidates:
    component_data = component_candidates[0]

assert component_data is not None
lam, curve_hp, component_hps, intersection_hp, intersection_reduced, \
    first_prime, second_prime = component_data
assert first_prime and second_prime and intersection_hp == 2 \
    and intersection_reduced

# Independent exact Chow-ring normalization of the conceptual count on
# P_{P1xP1}(O(-2,0) + O(0,-2)).
Chow = PolynomialRing(QQ, names=("h1", "h2", "xi"))
h1, h2, xi = Chow.gens()
ChowY = Chow.quotient(Chow.ideal([h1^2, h2^2,
                                 xi^2-2*(h1+h2)*xi+4*h1*h2]))
h1q, h2q, xiq = ChowY(h1), ChowY(h2), ChowY(xi)
packet_class = ((xiq+h1q)*(xiq+h2q)
                *(3*xiq-2*h1q-2*h2q))
assert packet_class == 15*xiq*h1q*h2q

print("PASS F5 packet transversality")
print("rational projective packet points =", len(points))
print("packet point =", point)
print("quadric rank =", evaluated.rank())
print("packet Jacobian rank =", jacobian_at_point.rank())
print("projective tangent dimension =", 6-jacobian_at_point.rank()-1)
print("F5 packet Hilbert polynomial =", packet_hp)
print("split factor degrees =", sorted(f.degree() for f, exponent in factorization))
print("split factor multiplicities =", [exponent for _, exponent in factorization])
print("split factorization =", factorization)
print("section-pencil parameter =", lam)
print("section curve Hilbert polynomial =", curve_hp)
print("component Hilbert polynomials =", component_hps)
print("component ideals prime =", first_prime, second_prime)
print("component intersection length =", intersection_hp)
print("component intersection reduced =", intersection_reduced)
print("all F5 component candidates =", component_candidates)
print("normalized-join Chow packet degree =", 15)
