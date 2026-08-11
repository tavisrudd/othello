from sage.all import *
import os

# Exploratory exact construction.  The first four variables are coordinates
# on the distinguished hyperplane; z is its transverse coordinate.
R = PolynomialRing(QQ, names=(
    "x0", "x1", "x2", "x3", "z",
))
x0, x1, x2, x3, z = R.gens()
x = vector(R, [x0, x1, x2, x3])


def skew(i, j):
    M = matrix(R, 4, 4, 0)
    M[i, j] = 1
    M[j, i] = -1
    return M


Omega = skew(0, 1) + skew(2, 3)
As = [skew(0, 2), skew(0, 3), skew(1, 2), skew(1, 3)]


def null_correlation_wedge(A, B):
    cols = [Omega * x, A * x, B * x]
    M = matrix(R, 4, 3, lambda i, j: cols[j][i])
    cross = vector(R, [(-1) ** i * M.matrix_from_rows(
        [j for j in range(4) if j != i]
    ).det() for i in range(4)])
    quotients = []
    for i, xi in enumerate(x):
        q, rem = cross[i].quo_rem(xi)
        assert rem == 0
        quotients.append(q)
    assert len(set(quotients)) == 1
    return quotients[0]


pairs = [(0, 1), (0, 2), (0, 3), (1, 2), (1, 3), (2, 3)]
qH = {ij: null_correlation_wedge(As[ij[0]], As[ij[1]]) for ij in pairs}

# The four chosen sections must generate N(1): equivalently their six wedge
# quadrics have no common projective zero on the hyperplane.
IH = R.ideal(list(qH.values()))
assert IH.saturation(R.ideal([x0, x1, x2, x3]))[0] == R.ideal(1)

# Deterministic small lifts off the hyperplane.  The seed is advanced until
# the residual cubic is smooth and the six quadrics have no projective base
# point on it.
seed = int(os.environ.get("C904_PACKET_SEED", "904"))
set_random_seed(seed)
vars5 = [x0, x1, x2, x3, z]


def random_linear(bound=2):
    return sum(ZZ.random_element(-bound, bound + 1) * v for v in vars5)


def symmetric_matrix_of_quadric(q):
    A = matrix(R, 5, 5, 0)
    for i in range(5):
        A[i, i] = q.monomial_coefficient(vars5[i] ** 2)
        for j in range(i + 1, 5):
            c = q.monomial_coefficient(vars5[i] * vars5[j])
            A[i, j] = c / 2
            A[j, i] = c / 2
    assert vector(R, vars5) * A * vector(R, vars5) == q
    return A


def projectively_empty(ideal, coordinates):
    irrelevant = R.ideal(coordinates)
    return ideal.saturation(irrelevant)[0] == R.ideal(1)


chosen = None
for attempt in range(1, 101):
    q = {ij: qH[ij] + z * random_linear() for ij in pairs}
    pf = q[(0, 1)] * q[(2, 3)] - q[(0, 2)] * q[(1, 3)] \
        + q[(0, 3)] * q[(1, 2)]
    F, rem = pf.quo_rem(z)
    assert rem == 0 and F.total_degree() == 3
    jac = R.ideal([F] + [F.derivative(v) for v in vars5])
    if not projectively_empty(jac, vars5):
        continue
    base = R.ideal(list(q.values()) + [F])
    if not projectively_empty(base, vars5):
        continue
    chosen = (attempt, q, F)
    break

assert chosen is not None
attempt, q, F = chosen

def wedge_quadric(s, t):
    return sum((s[i] * t[j] - s[j] * t[i]) * q[(i, j)]
               for i in range(4) for j in range(i + 1, 4))


# A regular section gives the residual sextic to the general pair of skew
# lines on z=0 in the complete intersection of its three wedge quadrics.
# Search a fixed short
# list so the certificate does not assume that a chosen basis section is
# transverse.
section_candidates = [
    vector(QQ, [1, 1, 1, 1]),
    vector(QQ, [1, 2, 3, 4]),
    vector(QQ, [1, -1, 2, -2]),
]
section_data = None


def hilbert_value(I, degree):
    leading = [g.lm() for g in I.groebner_basis()]
    return sum(1 for m in R.monomials_of_degree(degree)
               if not any(lm.divides(m) for lm in leading))


for s in section_candidates:
    complements = [vector(QQ, [0, 1, 0, 0]),
                   vector(QQ, [0, 0, 1, 0]),
                   vector(QQ, [0, 0, 0, 1])]
    if matrix(QQ, [s] + complements).det() == 0:
        continue
    qs = [wedge_quadric(s, t) for t in complements]
    Ici = R.ideal(qs)
    IC = Ici.saturation(R.ideal(z))[0]
    hpC = IC.hilbert_polynomial()
    if hpC != 6 * hpC.parent().gen() or F not in IC:
        continue
    if hilbert_value(IC, 1) != 5 or hilbert_value(IC, 2) != 12:
        continue
    cgens = list(IC.groebner_basis())
    JC = jacobian(cgens, vars5)
    singC = IC + R.ideal(JC.minors(3))
    if projectively_empty(singC, vars5):
        if not IC.is_prime():
            continue
        section_data = (s, hpC)
        break
assert section_data is not None
section, hpC = section_data

Avec = {ij: symmetric_matrix_of_quadric(q[ij]) for ij in pairs}

# The packet lives in its own Pluecker P^5.  Rank at most two is imposed by
# the 3x3 minors of the symmetric matrix of the universal wedge quadric.
Rp = PolynomialRing(QQ, names=("p01", "p02", "p03", "p12", "p13", "p23"))
pp = list(Rp.gens())
Avecp = {ij: matrix(Rp, 5, 5, lambda a, b: QQ(Avec[ij][a, b]))
         for ij in pairs}
Auniv = sum((p * Avecp[ij] for p, ij in zip(pp, pairs)), matrix(Rp, 5, 5, 0))
pluecker = pp[0] * pp[5] - pp[1] * pp[4] + pp[2] * pp[3]
Btop = Auniv.matrix_from_rows_and_columns(range(4), range(4))
dquad = Btop.matrix_from_rows_and_columns([0, 1], [0, 1]).det()
ID = Rp.ideal([pluecker, dquad])
JD = jacobian([pluecker, dquad], pp)
IsingD = (ID + Rp.ideal(JD.minors(2))).saturation(Rp.ideal(pp))[0]
IrankB1 = (Rp.ideal([pluecker] + Btop.minors(2))
           .saturation(Rp.ideal(pp))[0])
minors3 = [Auniv.matrix_from_rows_and_columns(rows, cols).det()
           for rows in Subsets(range(5), 3)
           for cols in Subsets(range(5), 3)]
Ipacket = Rp.ideal([pluecker] + minors3)
Ipacket = Ipacket.saturation(Rp.ideal(pp))[0]
IpacketB1 = (Ipacket + IrankB1).saturation(Rp.ideal(pp))[0]
minors2 = [Auniv.matrix_from_rows_and_columns(rows, cols).det()
           for rows in Subsets(range(5), 2)
           for cols in Subsets(range(5), 2)]
Irank1 = Rp.ideal([pluecker] + minors2).saturation(Rp.ideal(pp))[0]


def projective_degree(I):
    hp = I.hilbert_polynomial()
    return ZZ(hp.leading_coefficient() * factorial(hp.degree()))

print("PASS null-correlation wedge quadrics")
print("seed =", seed)
print("lift attempt =", attempt)
print("regular section =", section)
print("residual section curve Hilbert polynomial =", hpC)
print("residual section curve Hilbert values H(1),H(2) =",
      hilbert_value(IC, 1), hilbert_value(IC, 2))
print("residual section curve smooth = True")
print("residual section curve prime = True")
print("packet ideal generators =", len(Ipacket.gens()))
print("rank-two hyperplane discriminant degree =", projective_degree(ID))
IDparts = ID.primary_decomposition()
print("rank-two hyperplane discriminant components =", len(IDparts))
print("rank-two hyperplane component degrees =",
      [projective_degree(J) for J in IDparts])
print("discriminant singular scheme dimension =", IsingD.dimension())
if IsingD.dimension() == 1:
    print("discriminant singular scheme degree =", projective_degree(IsingD))
print("top-block rank-one locus dimension =", IrankB1.dimension())
if IrankB1.dimension() == 1:
    print("top-block rank-one locus degree =", projective_degree(IrankB1))
print("packet on top-block rank-one locus dimension =", IpacketB1.dimension())
if IpacketB1.dimension() == 1:
    print("packet on top-block rank-one locus degree =", projective_degree(IpacketB1))
print("rank-one packet empty =", Irank1 == Rp.ideal(1))
assert Irank1 == Rp.ideal(1)
print("computing packet dimension")
print("packet dimension =", Ipacket.dimension())
if Ipacket.dimension() == 1:
    hp = Ipacket.hilbert_polynomial()
    print("packet Hilbert polynomial =", hp)
    print("packet projective degree =", hp(0))
    print("computing packet radical")
    Irad = Ipacket.radical()
    print("packet is radical =", Irad == Ipacket)
    print("radical Hilbert polynomial =", Irad.hilbert_polynomial())
