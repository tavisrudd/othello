from sage.all import *
from itertools import product
import numpy as np
import os
import sys

# Exploratory exact search over F_5 for an ordinary null-correlation
# presentation of a projective transform of the Fermat cubic.  A successful
# point is subsequently subjected to a full Jacobian and packet audit.
k = GF(5)
R = PolynomialRing(k, names=("x0", "x1", "x2", "x3", "z"))
x0, x1, x2, x3, z = R.gens()
xx = [x0, x1, x2, x3]
vv = [x0, x1, x2, x3, z]
pairs = [(0, 1), (0, 2), (0, 3), (1, 2), (1, 3), (2, 3)]

qH = [
    -x0**2,
    -x2**2,
    -x0*x1 - x2*x3,
    x0*x1 - x2*x3,
    -x3**2,
    -x1**2,
]
assert R.ideal(qH).saturation(R.ideal(xx))[0] == R.ideal(1)

mons3 = list(PolynomialRing(k, names=("u0", "u1", "u2", "u3")).monomials_of_degree(3))
mons2 = list(PolynomialRing(k, names=("u0", "u1", "u2", "u3")).monomials_of_degree(2))
# Recreate the monomial lists in R so coefficient extraction is immediate.
mons3 = [R(str(m).replace("u", "x")) for m in mons3]
mons2 = [R(str(m).replace("u", "x")) for m in mons2]


def coeff_vector(f, mons):
    return vector(k, [f.monomial_coefficient(m) for m in mons])


def pf_six(q):
    return q[0]*q[5] - q[1]*q[4] + q[2]*q[3]


def cross_six(q, r):
    return (q[0]*r[5] + r[0]*q[5]
            - q[1]*r[4] - r[1]*q[4]
            + q[2]*r[3] + r[2]*q[3])


# The constant layer F|_{z=0} is linear in the 24 coefficients of the six
# transverse linear forms a_i(x0,...,x3).
M0cols = []
for i in range(6):
    for j in range(4):
        aa = [R.zero()] * 6
        aa[i] = xx[j]
        M0cols.append(coeff_vector(cross_six(qH, aa), mons3))
M0 = matrix(k, 20, 24, lambda i, j: M0cols[j][i])
assert M0.rank() == 20
K0 = M0.right_kernel().basis_matrix().transpose()
assert K0.ncols() == 4

# The z-linear constant terms c_i enter through the six-dimensional span
# cross(qH,c).  Use its left kernel as the four cheap compatibility tests.
Ccols = []
for i in range(6):
    cc = [k.zero()] * 6
    cc[i] = k.one()
    Ccols.append(coeff_vector(cross_six(qH, cc), mons2))
C0 = matrix(k, 10, 6, lambda i, j: Ccols[j][i])
assert C0.rank() == 6
LC = C0.left_kernel().basis_matrix()
assert LC.nrows() == 4

# Integral-array forms of the linear solvers.  They keep the bounded search
# fast while every matrix used to derive them is checked exactly above.
M_piv = list(M0.pivots())
assert len(M_piv) == 20
M_right = matrix(k, 24, 20, 0)
M_subinv = M0.matrix_from_columns(M_piv).inverse()
for i, row in enumerate(M_piv):
    for j in range(20):
        M_right[row, j] = M_subinv[i, j]
assert M0*M_right == identity_matrix(k, 20)
C_piv = list(C0.transpose().pivots())
assert len(C_piv) == 6
C_inv = C0.matrix_from_rows(C_piv).inverse()

def npmod(M):
    return np.array([[int(a) for a in row] for row in M], dtype=np.int64)

M_right_np = npmod(M_right)
K0_np = npmod(K0)
LC_np = npmod(LC)
C_inv_np = npmod(C_inv)
T_np = np.array(list(product(range(5), repeat=4)), dtype=np.int64)

# Coefficient order for products of linear forms, matching mons2.
linprod = np.empty((4, 4), dtype=np.int64)
for i in range(4):
    for j in range(4):
        linprod[i, j] = coeff_vector(xx[i]*xx[j], mons2).nonzero_positions()[0]


def split_z(F):
    layers = []
    for e in range(4):
        layer = R.zero()
        for mon, coeff in F.dict().items():
            if mon[4] == e:
                layer += coeff * prod(vv[i]**mon[i] for i in range(4))
        layers.append(layer)
    return layers


def linear_forms_from_vector(u):
    return [sum(u[4*i+j]*xx[j] for j in range(4)) for i in range(6)]


set_random_seed(90415)
fermat = sum(v**3 for v in vv)
# Roulleau's integral two-dimensional A5-invariant pencil.  The chosen
# member A+2B is used for the family-specific certificate; B is the explicit
# transverse pencil direction.
a5A = (x3**3 + x3*(x0**2-x1**2+x2**2)
       + x2*(-x1**2+3*x3**2+z**2) + 2*x2**2*z
       + 2*x0*x1*(x2+x3+z) + 2*x2*x3*z)
a5B = (-x2**3 + x2*(x0**2-x1**2-x3**2)
       + x3*(x0**2-3*x2**2-z**2) - 2*x3**2*z
       + 2*x0*x1*(x2+x3+z) - 2*x2*x3*z)
base_cubic = a5A + 2*a5B
base_derivatives = [base_cubic.derivative(v) for v in vv]
solution = None
tested_t = 0
for attempt in range(1, 10001):
    while True:
        G = random_matrix(k, 5, 5)
        if G.is_invertible():
            break
    linear_coordinates = list(G * vector(R, vv))
    target = base_cubic(*linear_coordinates)
    F0, F1, F2, F3 = split_z(target)
    f0_np = np.array([int(v) for v in coeff_vector(F0, mons3)], dtype=np.int64)
    u0_np = M_right_np.dot(f0_np) % 5
    UU = (u0_np[None, :] + T_np.dot(K0_np.transpose())) % 5
    AA = UU.reshape((len(T_np), 6, 4))
    PF = np.zeros((len(T_np), 10), dtype=np.int64)
    for i, j, sgn in ((0, 5, 1), (1, 4, -1), (2, 3, 1)):
        for r in range(4):
            for s in range(4):
                PF[:, linprod[r, s]] += sgn*AA[:, i, r]*AA[:, j, s]
    PF %= 5
    f1_np = np.array([int(v) for v in coeff_vector(F1, mons2)], dtype=np.int64)
    RHS = (f1_np[None, :] - PF) % 5
    compatible = np.all((RHS.dot(LC_np.transpose()) % 5) == 0, axis=1)
    tested_t += len(T_np)
    for idx in np.flatnonzero(compatible):
        cc_np = C_inv_np.dot(RHS[idx, C_piv]) % 5
        A = AA[idx]
        f2_calc = (cc_np[0]*A[5] + cc_np[5]*A[0]
                   - cc_np[1]*A[4] - cc_np[4]*A[1]
                   + cc_np[2]*A[3] + cc_np[3]*A[2]) % 5
        f2_np = np.array([int(F2.monomial_coefficient(v)) for v in xx], dtype=np.int64)
        if np.any(f2_calc != f2_np):
            continue
        f3_calc = (cc_np[0]*cc_np[5] - cc_np[1]*cc_np[4]
                   + cc_np[2]*cc_np[3]) % 5
        if f3_calc != int(F3):
            continue
        aa = linear_forms_from_vector(vector(k, list(UU[idx])))
        cc = [k(int(v)) for v in cc_np]
        solution = (attempt, G, aa, cc, target)
        break
    if solution is not None:
        break

print("M0 rank/kernel =", M0.rank(), K0.ncols())
print("C0 rank/left-kernel =", C0.rank(), LC.nrows())
print("projective transforms tested =", attempt)
print("kernel candidates tested =", tested_t)
assert solution is not None
attempt, G, aa, cc, target = solution
q = [qH[i] + z*(aa[i] + cc[i]*z) for i in range(6)]
assert pf_six(q) == z*target
print("PASS A5-family finite-field presentation")
print("G =")
print(G)
print("a =", aa)
print("c =", cc)
print("target =", target)

# Smoothness of the full incidence of presentations over Z at this mod-5
# point.  The 35 equations are cubic coefficients of Pf(q)/z-Fermat(Gx).
mons3_5 = R.monomials_of_degree(3)
Jcols = []
partner = [5, 4, 3, 2, 1, 0]
sign = [1, -1, 1, 1, -1, 1]
for i in range(6):
    for j in range(5):
        Jcols.append(coeff_vector(sign[i]*q[partner[i]]*vv[j], mons3_5))
for i in range(5):
    for j in range(5):
        transformed_derivative = base_derivatives[i](*linear_coordinates)
        Jcols.append(coeff_vector(-transformed_derivative*vv[j], mons3_5))
Jpres = matrix(k, 35, 55, lambda i, j: Jcols[j][i])
print("presentation Jacobian rank =", Jpres.rank())
assert Jpres.rank() == 35


def projectively_empty(I, coordinates):
    return I.saturation(R.ideal(coordinates))[0] == R.ideal(1)


jac_target = R.ideal([target] + [target.derivative(v) for v in vv])
assert projectively_empty(jac_target, vv)
assert projectively_empty(R.ideal(q + [target]), vv)
print("target smooth / wedge system basepoint-free = True / True")
sys.stdout.flush()
if os.environ.get("C904_A5_SKIP_PACKET") == "1":
    raise SystemExit(0)

# Exact raw packet audit for the special A5 point.
def symmetric_matrix_of_quadric(f):
    A = matrix(k, 5, 5, 0)
    for i in range(5):
        A[i, i] = f.monomial_coefficient(vv[i]**2)
        for j in range(i + 1, 5):
            c = f.monomial_coefficient(vv[i]*vv[j]) / 2
            A[i, j] = c
            A[j, i] = c
    assert vector(R, vv)*A*vector(R, vv) == f
    return A


Rp = PolynomialRing(k, names=("p01", "p02", "p03", "p12", "p13", "p23"))
pp = list(Rp.gens())
Avec = [symmetric_matrix_of_quadric(f) for f in q]
Auniv = sum((pp[i]*matrix(Rp, Avec[i]) for i in range(6)),
            matrix(Rp, 5, 5, 0))
pluecker = pp[0]*pp[5] - pp[1]*pp[4] + pp[2]*pp[3]
minors3 = [Auniv.matrix_from_rows_and_columns(rows, cols).det()
           for rows in Subsets(range(5), 3)
           for cols in Subsets(range(5), 3)]
Ipacket = Rp.ideal([pluecker] + minors3).saturation(Rp.ideal(pp))[0]
minors2 = [Auniv.matrix_from_rows_and_columns(rows, cols).det()
           for rows in Subsets(range(5), 2)
           for cols in Subsets(range(5), 2)]
Irank1 = Rp.ideal([pluecker] + minors2).saturation(Rp.ideal(pp))[0]
print("packet dimension =", Ipacket.dimension())
print("packet Hilbert polynomial =", Ipacket.hilbert_polynomial())
assert Ipacket.dimension() == 1 and Ipacket.hilbert_polynomial().is_constant()
assert Ipacket.hilbert_polynomial()(0) == 15
sys.stdout.flush()
print("rank-one packet empty =", Irank1 == Rp.ideal(1))
assert Irank1 == Rp.ideal(1)
Irad = Ipacket.radical()
print("packet radical / etale =", Irad == Ipacket)
assert Irad == Ipacket
parts = Ipacket.primary_decomposition()
print("packet finite-field component degrees =",
      sorted(ZZ(P.hilbert_polynomial()(0)) for P in parts))
if os.environ.get("C904_A5_SHOW_COMPONENTS") == "1":
    for P in parts:
        degree = ZZ(P.hilbert_polynomial()(0))
        if degree == 1:
            continue
        for chart in range(6):
            if (P + Rp.ideal(pp[chart])).saturation(Rp.ideal(pp))[0] == Rp.ideal(1):
                break
        names_aff = [str(pp[i]) for i in range(6) if i != chart]
        Sa = PolynomialRing(k, names=names_aff, order="lex")
        aff_vars = list(Sa.gens())
        images = []
        pos = 0
        for i in range(6):
            if i == chart:
                images.append(Sa.one())
            else:
                images.append(aff_vars[pos])
                pos += 1
        Ia = Sa.ideal([Sa(f(*images)) for f in P.gens()])
        print("component affine lex GB degree/chart =", degree, chart,
              list(Ia.groebner_basis()))
sys.stdout.flush()


def closed_point_from_prime(P):
    degree = ZZ(P.hilbert_polynomial()(0))
    for chart in range(6):
        if (P + Rp.ideal(pp[chart])).saturation(Rp.ideal(pp))[0] == Rp.ideal(1):
            break
    names_aff = [str(pp[i]) for i in range(6) if i != chart]
    Sa = PolynomialRing(k, names=names_aff, order="lex")
    av = list(Sa.gens())
    images = []
    pos = 0
    for i in range(6):
        if i == chart:
            images.append(Sa.one())
        else:
            images.append(av[pos])
            pos += 1
    Ia = Sa.ideal([Sa(f(*images)) for f in P.gens()])
    gb = list(Ia.groebner_basis())
    tvar = av[-1]
    h = next(f for f in gb if f.degree(tvar) == degree
             and all(f.degree(v) == 0 for v in av[:-1]))
    if degree == 1:
        roots = [a for a in k if h(*([k.zero()]*(len(av)-1) + [a])) == 0]
        assert len(roots) == 1
        K = k
        theta = roots[0]
    else:
        U = PolynomialRing(k, name="T")
        T = U.gen()
        hU = sum(h.monomial_coefficient(tvar**i)*T**i
                 for i in range(degree + 1))
        assert hU.is_irreducible()
        K = GF(5**degree, name="theta%s" % degree, modulus=hU)
        theta = K.gen()
    vals = [K.zero()] * len(av)
    vals[-1] = theta
    for i, v in enumerate(av[:-1]):
        rel = next(f for f in gb if f.monomial_coefficient(v) != 0
                   and f.degree(v) == 1)
        coeff = K(rel.monomial_coefficient(v))
        vals[i] = -K(rel(*([K.zero() if j != len(av)-1 else theta
                            for j in range(len(av))]))) / coeff
    pv = []
    pos = 0
    for i in range(6):
        if i == chart:
            pv.append(K.one())
        else:
            pv.append(vals[pos])
            pos += 1
    assert all(K(f(*pv)) == 0 for f in Ipacket.gens())
    return degree, K, pv


def type33_at_closed_point(degree, K, pv):
    Pskew = matrix(K, 4, 4, 0)
    for value, (i, j) in zip(pv, pairs):
        Pskew[i, j] = value
        Pskew[j, i] = -value
    U = Pskew.row_space().basis()
    assert len(U) == 2
    SK = PolynomialRing(K, names=("x0", "x1", "x2", "x3", "z"))
    qK = [SK(f) for f in q]
    FK = SK(target)

    def wedge_here(s, t, forms):
        return sum((s[i]*t[j] - s[j]*t[i])*forms[n]
                   for n, (i, j) in enumerate(pairs))

    qU = wedge_here(U[0], U[1], qK)
    fac = list(qU.factor())
    if not (len(fac) == 2 and all(e == 1 and f.degree() == 1 for f, e in fac)):
        L = K.extension(2, name="sqrtq")
        SL = PolynomialRing(L, names=("x0", "x1", "x2", "x3", "z"))
        qL = [SL(f) for f in qK]
        FL = SL(FK)
        UL = [vector(L, list(u)) for u in U]
        qU = wedge_here(UL[0], UL[1], qL)
        fac = list(qU.factor())
        assert len(fac) == 2 and all(e == 1 and f.degree() == 1 for f, e in fac)
        workK, workS, workq, workF, workU = L, SL, qL, FL, UL
    else:
        workK, workS, workq, workF, workU = K, SK, qK, FK, U
    l1, l2 = fac[0][0], fac[1][0]
    ebasis = [vector(workK, [1 if i == j else 0 for i in range(4)])
              for j in range(4)]
    candidates = [workK(a) for a in range(5)] + [workK.gen()**i for i in range(1, 9)] + [None]
    seen = set()
    for alpha in candidates:
        if alpha is None:
            s = workU[1]
            alpha_label = "infinity"
        else:
            s = workU[0] + alpha*workU[1]
            alpha_label = str(alpha)
        if alpha in seen:
            continue
        seen.add(alpha)
        Ici = workS.ideal([wedge_here(s, e, workq) for e in ebasis])
        IC = Ici.saturation(workS.ideal(workS.gen(4)))[0]
        if IC == workS.ideal(1) or workF not in IC:
            continue
        JA = (IC + workS.ideal(l1)).saturation(workS.ideal(l2))[0]
        JB = (IC + workS.ideal(l2)).saturation(workS.ideal(l1))[0]
        hp, hpa, hpb = (IC.hilbert_polynomial(), JA.hilbert_polynomial(),
                        JB.hilbert_polynomial())
        def smooth_curve(J):
            gb = list(J.groebner_basis())
            sing = J + workS.ideal(jacobian(gb, list(workS.gens())).minors(3))
            return sing.saturation(workS.ideal(workS.gens()))[0] == workS.ideal(1)
        if (str(hp) == "6*t" and str(hpa) == "3*t + 1"
                and str(hpb) == "3*t + 1"
                and smooth_curve(JA) and smooth_curve(JB)):
            return True, alpha_label
    return False, "none"


if os.environ.get("C904_A5_TYPE_AUDIT") == "1":
    type_records = []
    for P in parts:
        closed = closed_point_from_prime(P)
        good, section_alpha = type33_at_closed_point(*closed)
        type_records.append((closed[0], good, section_alpha))
        print("type-(3,3) component =", type_records[-1])
        sys.stdout.flush()
    print("type-(3,3) closed-component records =", sorted(type_records))
    assert all(good for _, good, _ in type_records)
