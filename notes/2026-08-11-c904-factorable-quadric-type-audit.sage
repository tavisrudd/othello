from sage.all import *

# Independent finite-field audit of the missing implication
#
#     rank(w_E(wedge^2 U)) <= 2  ==>  generic section in U has type (3,3).
#
# It reuses the deterministic characteristic-zero model built by the packet
# script, then reduces it modulo a small good prime.  This is a diagnostic,
# not a proof about the generic characteristic-zero packet.
packet_source = open(
    "notes/2026-08-11-c904-factorable-quadric-packet.sage"
).read().splitlines()
section_check = next(i for i, line in enumerate(packet_source)
                     if line.startswith("# A regular section"))
matrix_setup = next(i for i, line in enumerate(packet_source)
                    if line.startswith("Avec ="))
degree_helper = next(i for i, line in enumerate(packet_source)
                     if line.startswith("def projective_degree"))
packet_setup = packet_source[:section_check] + packet_source[matrix_setup:degree_helper]
exec(preparse("\n".join(packet_setup)))

test_section = vector(QQ, [1, 1, 1, 1])
test_equations = [wedge_quadric(test_section, vector(
    QQ, [1 if i == j else 0 for i in range(4)]
)) for j in range(4)]
test_ci = R.ideal(test_equations)
test_residual = test_ci.saturation(R.ideal(z))[0]
test_on_cubic = (test_ci + R.ideal(F)).saturation(R.ideal(vars5))[0]
print("section zero scheme on X equals residual sextic =",
      test_on_cubic == test_residual)
test_boundary = R.ideal([
    sum((test_section[i] * (1 if j == basis else 0)
         - test_section[j] * (1 if i == basis else 0)) * qH[(i, j)]
        for i in range(4) for j in range(i + 1, 4))
    for basis in range(4)
] + [z]).saturation(R.ideal(vars5))[0]
boundary_parts = test_boundary.primary_decomposition()
print("hyperplane residual Hilbert polynomial =",
      test_boundary.hilbert_polynomial())
print("hyperplane residual components =", len(boundary_parts))
print("hyperplane component Hilbert polynomials =",
      [J.hilbert_polynomial() for J in boundary_parts])


def audit_prime(prime):
    k = GF(prime)
    S = PolynomialRing(k, names=("x0", "x1", "x2", "x3", "z"))
    y = list(S.gens())

    def reduce_scalar(c):
        c = QQ(c)
        return k(c.numerator()) / k(c.denominator())

    def reduce_poly(f):
        return S({mon: reduce_scalar(c) for mon, c in f.dict().items()})

    qk = {ij: reduce_poly(q[ij]) for ij in pairs}
    Fk = reduce_poly(F)

    def wedge_k(s, t):
        return sum((s[i] * t[j] - s[j] * t[i]) * qk[(i, j)]
                   for i in range(4) for j in range(i + 1, 4))

    Ak = {ij: matrix(k, 5, 5,
                     lambda a, b: reduce_scalar(Avec[ij][a, b]))
          for ij in pairs}

    T = PolynomialRing(
        k, names=("p01", "p02", "p03", "p12", "p13", "p23")
    )

    def reduce_packet_poly(f):
        return T({mon: reduce_scalar(c) for mon, c in f.dict().items()})

    packet_generators = [reduce_packet_poly(f) for f in Ipacket.gens()]
    packet_ideal = T.ideal(packet_generators).saturation(T.ideal(T.gens()))[0]
    packet_jacobian = jacobian(packet_generators, list(T.gens()))

    packet = []
    for P in ProjectiveSpace(k, 5):
        pv = list(P)
        if pv[0] * pv[5] - pv[1] * pv[4] + pv[2] * pv[3] != 0:
            continue
        Ap = sum((pv[n] * Ak[ij] for n, ij in enumerate(pairs)),
                 matrix(k, 5, 5, 0))
        if Ap.rank() == 2:
            packet.append((pv, Ap))

    records = []
    for pv, Ap in packet:
        Pskew = matrix(k, 4, 4, 0)
        for value, (i, j) in zip(pv, pairs):
            Pskew[i, j] = value
            Pskew[j, i] = -value
        U = Pskew.row_space().basis()
        assert len(U) == 2
        qU = wedge_k(U[0], U[1])
        fac = list(qU.factor())
        split = len(fac) == 2 and all(exp == 1 and f.degree() == 1
                                      for f, exp in fac)
        split_degree = 1
        work_k, work_S, work_q, work_F, work_U = k, S, qk, Fk, U
        if not split:
            work_k = GF(prime ** 2, name="a")
            work_S = PolynomialRing(
                work_k, names=("x0", "x1", "x2", "x3", "z")
            )
            work_q = {ij: work_S(qk[ij]) for ij in pairs}
            work_F = work_S(Fk)
            work_U = [vector(work_k, list(u)) for u in U]

            def wedge_extension(s, t):
                return sum(
                    (s[i] * t[j] - s[j] * t[i]) * work_q[(i, j)]
                    for i in range(4) for j in range(i + 1, 4)
                )

            qU = wedge_extension(work_U[0], work_U[1])
            fac = list(qU.factor())
            split = len(fac) == 2 and all(
                exp == 1 and f.degree() == 1 for f, exp in fac
            )
            split_degree = 2
        types = []
        if split:
            l1, l2 = fac[0][0], fac[1][0]
            e = [vector(work_k, [1 if i == j else 0 for i in range(4)])
                 for j in range(4)]

            def wedge_work(s, t):
                return sum(
                    (s[i] * t[j] - s[j] * t[i]) * work_q[(i, j)]
                    for i in range(4) for j in range(i + 1, 4)
                )

            for a in work_k:
                s = work_U[0] + a * work_U[1]
                Ici = work_S.ideal([wedge_work(s, ei) for ei in e])
                IC = Ici.saturation(work_S.ideal(work_S.gen(4)))[0]
                if IC == work_S.ideal(1) or work_F not in IC:
                    continue
                JA = (IC + work_S.ideal(l1)).saturation(
                    work_S.ideal(l2)
                )[0]
                JB = (IC + work_S.ideal(l2)).saturation(
                    work_S.ideal(l1)
                )[0]
                def linear_rank(J):
                    linear = [g for g in J.groebner_basis()
                              if g.total_degree() == 1]
                    return matrix(
                        work_k,
                        [[g.monomial_coefficient(v) for v in work_S.gens()]
                         for g in linear]
                    ).rank() if linear else 0

                types.append((str(IC.hilbert_polynomial()),
                              str(JA.hilbert_polynomial()),
                              JA.is_prime(), linear_rank(JA),
                              str(JB.hilbert_polynomial()),
                              JB.is_prime(), linear_rank(JB)))
        records.append((pv, split_degree if split else 0,
                        sorted(set(types))))

    print("TYPE AUDIT prime =", prime)
    print("total packet Hilbert polynomial =",
          packet_ideal.hilbert_polynomial())
    print("rational rank-two packet points =", len(packet))
    print("geometrically split packet points =",
          sum(1 for _, split_degree, _ in records if split_degree))
    for record in records:
        pv = record[0]
        tangent_rank = matrix(
            k, packet_jacobian.nrows(), packet_jacobian.ncols(),
            lambda i, j: packet_jacobian[i, j](*pv)
        ).rank()
        print(record, "projective Jacobian rank =", tangent_rank)


for audit_p in (5, 7, 11):
    audit_prime(audit_p)
