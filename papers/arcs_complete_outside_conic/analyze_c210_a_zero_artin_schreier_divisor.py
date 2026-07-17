#!/usr/bin/env python3
"""Close the ``a=0,b!=0`` stratum: the Artin--Schreier divisor ``D3`` is explicit,
complete, and collision-forcing.

The predecessor (``analyze_c210_a_zero_factorization_strata``) reduced every
factorization mechanism of the a=0 trace-one cover ``R0=A2*t^2+A1*t+A0`` to one
Artin--Schreier divisor ``D3``: reducibility over ``GF(2)-bar(params)(u)`` iff
``phi=A0*A2/A1^2`` lies in the Artin--Schreier image.  This checker derives
``D3`` explicitly by reduced AS-residues and closes the stratum:

1.  ``phi = A0*Q^2/(delta^2*G1^2*G2^2)`` has order-two poles exactly at the
    roots of ``G1*G2`` (both squarefree and coprime to each other off
    ``delta*p=0``, certified by resultants).  With ``M=A0*Q^2``,
    ``M'=A0'*Q^2`` and ``D=delta*G1*G2``, the reduced residue at a simple
    root ``rho`` vanishes iff ``W(rho)=0`` for
    ``W=(A0')^2*Q^4 + A0*Q^2*(D')^2``; a shared ``Q``-root cancels the pole
    and ``W`` vanishes there automatically, so the criterion is uniform.
2.  ``W == 0 mod G1`` identically: the residues at both ``G1`` roots vanish on
    the whole stratum.  ``W mod G2`` has u-degree two; stripping monomial
    ``delta``/``p`` content from its coefficients gives three polynomials
    ``P0,P1,P2`` (h1-free, linear in h0) whose common zeros form ``D3``.
3.  Decomposition (certified by exact division, two-chart resultant
    elimination, and a GF(4) gcd): off ``delta*b*p=0``,
    ``D3 = {e=0, h0=0} u {e=delta, h0=p^2*theta+e^2+e*b}
          u {delta=p, theta=1, h0=e*(e+b+p)}``
    with ``h1`` free (``theta=w^2+w+1``).  The only other candidate locus
    needs ``theta=0``, which forces ``delta=0`` (residual system) and has no
    rational ``w`` over any ``GF(8^m)`` with odd ``m`` anyway.
4.  On the merged-pole locus ``Res(G1,G2)=p^2*K1*K2=0`` the shared root has
    ``D'(rho)=0``, so ``W == (A0'*Q^2)^2 mod (G1,G2)`` and AS-triviality still
    forces ``G2 | W``: that locus can only shrink ``D3``, never extend it.
5.  Each branch splits into explicitly rational components (exact polynomial
    identities, e.g. ``N_B = p^12*Q^2*L1*L2`` with
    ``L1 = u*e+e^2+t*b+e*b+e*p+h1``, ``L2 = L1+u*p``), so the split is
    rational at every point of every branch over every field -- there is no
    conjugate-component (collision-free) case.
6.  ``H = D*B+A*E`` pulls back to ``delta*G1`` on a=0.  ``G1/p^2`` is the
    Artin--Schreier polynomial ``v^2+v+theta`` with ``tr(theta)=tr(1)=1`` over
    ``GF(8^m)``, odd ``m``, so ``H`` never vanishes at a rational ``u``: the
    ``H=J=0`` split locus is empty over the whole odd tower and every rational
    curve point reconstructs its repair parameter ``r=J/H``.
7.  Exact GF(8) census: the solutions of ``P0=P1=P2=0`` with
    ``delta,b,p != 0`` are exactly the three branches (6076 = 2744+2744+588
    points).  Exact GF(64) witnesses via the committed projective incidence:
    at a branch-3 point the genuine collision set equals ``L1 u L2`` exactly
    (7+7 per seed color, all triples of three distinct points); the ``e=0``
    and ``e=delta`` branches also carry genuine collisions (their trivial
    repair coset lies in the seed coset, outside the two-nontrivial-coset
    design, and one resultant component there is a coincident-point artifact).

Conclusion: off ``D3`` the cover is irreducible over the closure and
Lang--Weil forces collisions with valid reconstruction; on ``D3`` every branch
splits into rational components carrying genuine collisions at every odd-tower
field.  No collision-free coefficient stratum exists on ``a=0,b!=0``.

What this does NOT prove: the boundaries ``p=0`` (coincident repair pair),
``delta=0`` (equal coset offsets), ``b=0`` (the closed a=b=0 stratum); the
``a!=0`` factorization divisors (next frontier); the classical AS-reduction
and Lang--Weil steps (trusted theory); and the geometric structure of the
h0-free sublocus inside ``theta=0`` (arithmetically empty over the odd tower).
"""

from __future__ import annotations

import itertools
import json
import shutil
import subprocess

from analyze_c210_a_zero_factorization_strata import (
    TVARS,
    TargetRing,
    restrict_zero,
    t_coefficient,
    trace_one_pullback,
)
from analyze_c210_exceptional_quadratic_locus import line_key, repair_points
from analyze_c210_residue_hypergraph import build_context
from analyze_c210_seed_cross_repair_curve import (
    BinaryRing,
    NAMES,
    expected_quadratics,
    resultant,
)

U, T, E, DELTA, A, B, P, W, H0, H1 = (TVARS.index(n) for n in (
    "u", "t", "e", "delta", "a", "b", "p", "w", "h0", "h1"
))


def pullback_a0(ring0: BinaryRing, ring: TargetRing, value) -> set:
    """Trace-one pullback (same images as the committed cover), then a=0."""
    v = ring.v
    theta = ring.add(ring.power(v["w"], 2), v["w"], ring.one)
    n = ring.add(ring.power(v["a"], 2), v["a"], ring.one)
    ell = ring.add(ring.mul(v["delta"], v["b"]), ring.power(v["delta"], 2))
    t0 = ring.add(
        ring.mul(ring.power(v["p"], 2), theta),
        ring.product((v["a"], v["delta"], v["p"])),
    )
    images = {
        "r": ring.zero, "s": ring.zero, "u": v["u"], "t": v["t"],
        "e": v["e"], "delta": v["delta"], "a": v["a"], "b": v["b"],
        "k0": ring.add(t0, ell),
        "k1": ring.add(ring.product((v["delta"], n, v["p"])),
                       ring.mul(v["a"], t0), ell),
        "c0": v["h0"], "c1": v["h1"], "g0": ring.zero, "g1": ring.zero,
    }
    out = ring.zero
    for monomial in value:
        factors = [
            ring.power(images[name], exponent)
            for name, exponent in zip(NAMES, monomial)
            if exponent
        ]
        out = ring.add(out, ring.product(factors))
    return restrict_zero(out, "a")


def u_degree(poly) -> int:
    return max((m[U] for m in poly), default=-1)


def u_derivative(poly) -> set:
    out = set()
    for m in poly:
        if m[U] % 2:
            reduced = list(m)
            reduced[U] -= 1
            out.add(tuple(reduced))
    return out


def u_reduce(ring: TargetRing, poly, divisor) -> set:
    """Remainder of division by a divisor monic in u (exact set arithmetic)."""
    d = u_degree(divisor)
    lead = {m for m in divisor if m[U] == d}
    assert lead == {tuple(d if i == U else 0 for i in range(len(TVARS)))}
    out = set(poly)
    while u_degree(out) >= d:
        top = u_degree(out)
        coefficient = set()
        for m in out:
            if m[U] == top:
                reduced = list(m)
                reduced[U] = top - d
                coefficient.add(tuple(reduced))
        out = ring.add(out, ring.mul(coefficient, divisor))
    return out


def strip_monomial(poly, index: int) -> tuple[set, int]:
    """Divide out the largest power of one variable."""
    power = min(m[index] for m in poly)
    if not power:
        return set(poly), 0
    out = set()
    for m in poly:
        reduced = list(m)
        reduced[index] -= power
        out.add(tuple(reduced))
    return out, power


def variable_free(poly, *indices: int) -> bool:
    return all(all(m[i] == 0 for i in indices) for m in poly)


def h0_split(ring: TargetRing, poly) -> tuple[set, set]:
    """Write an h0-linear polynomial as alpha*h0 + beta."""
    assert max(m[H0] for m in poly) <= 1
    alpha = set()
    beta = set()
    for m in poly:
        if m[H0]:
            reduced = list(m)
            reduced[H0] = 0
            alpha.add(tuple(reduced))
        else:
            beta.add(m)
    return alpha, beta


def substitute_e_shift(ring: TargetRing, poly) -> set:
    """Substitute e -> e + delta (char 2, Lucas binomials)."""
    out = ring.zero
    for m in poly:
        k = m[E]
        base = list(m)
        base[E] = 0
        term = {tuple(base)}
        if k:
            shift = ring.add(ring.v["e"], ring.v["delta"])
            term = ring.mul(term, ring.power(shift, k))
        out = ring.add(out, term)
    return out


def dp_homogeneous(poly) -> bool:
    degrees = {m[DELTA] + m[P] for m in poly}
    return len(degrees) <= 1


def singular_poly(poly) -> str:
    terms = []
    for m in sorted(poly):
        factors = [
            f"{name}^{m[i]}" if m[i] > 1 else name
            for i, name in enumerate(TVARS)
            if m[i] and name != "a"
        ]
        assert m[A] == 0
        terms.append("*".join(factors) or "1")
    return "+".join(terms) or "0"


def run_singular(lines: list[str]) -> None:
    singular = shutil.which("Singular")
    command = ([singular, "-q"] if singular else [
        "nix", "shell", "nixpkgs#singular", "--command", "Singular", "-q"
    ])
    completed = subprocess.run(
        command, input="\n".join(lines), text=True, capture_output=True,
        check=True,
    )
    assert completed.stderr == "", completed.stderr
    assert completed.stdout.strip() == "a-zero AS-divisor certificate passes", (
        completed.stdout
    )


def singular_certificate(a2, a1, a0, h0_pull, p0, p1, p2) -> None:
    used = "u,t,e,delta,b,p,w,h0,h1"
    prelude = [
        f"ring rt=2,({used}),dp;",
        f"poly A2={singular_poly(a2)};",
        f"poly A1={singular_poly(a1)};",
        f"poly A0={singular_poly(a0)};",
        f"poly Hp={singular_poly(h0_pull)};",
        f"poly P0={singular_poly(p0)};",
        f"poly P1={singular_poly(p1)};",
        f"poly P2={singular_poly(p2)};",
        "poly theta=w^2+w+1;",
        "poly Q=u^2+u*delta+delta^2;",
        "poly G1=u^2+u*p+p^2*theta;",
        "poly G2=u^3+u^2*delta+u*p^2*theta+delta*p^2*theta+delta^2*p;",
        "intvec wt=0,1,0,0,0,0,0,0,0;",
        "intvec wu=1,0,0,0,0,0,0,0,0;",
    ]
    identities = [
        # base factorizations and the split-locus identity H = delta*G1.
        "if(A2-b^2*Q^2!=0){exit(1);}",
        "if(A1-delta*b*G1*G2!=0){exit(2);}",
        "if(Hp-delta*G1!=0){exit(3);}",
        # residue polynomial: W == 0 mod G1; W mod G2 reproduces P0,P1,P2.
        "poly A0d=diff(A0,u);",
        "poly Dp=delta*(diff(G1,u)*G2+G1*diff(G2,u));",
        "poly Wr=A0d^2*Q^4+A0*Q^2*Dp^2;",
        "if(reduce(Wr,std(ideal(G1)))!=0){exit(4);}",
        # squarefree/coprimality boundaries and the merged-pole shrink lemma.
        "if(resultant(G1,diff(G1,u),u)-p^2!=0){exit(5);}",
        "if(resultant(G2,diff(G2,u),u)-delta^4*p^2!=0){exit(6);}",
        "poly K1=p^2*theta+delta*p*w+delta^2;",
        "poly K2=K1+delta*p;",
        "if(resultant(G1,G2,u)-p^2*K1*K2!=0){exit(7);}",
        "if(reduce(Wr-(A0d*Q^2)^2,std(ideal(G1,G2)))!=0){exit(8);}",
    ]
    division_check = [
        # independent univariate re-division of W by G2 over the parameters.
        "ring s=(2,e,delta,b,p,w,h0,h1),(u,t),dp;",
        "poly W2=reduce(imap(rt,Wr),std(imap(rt,G2)));",
        "if(deg(W2)!=2){exit(9);}",
        "matrix C2=coeffs(W2,u);",
        "setring rt;",
        "matrix C2=imap(s,C2);",
        "if(C2[1,1]-delta^7*p*P0!=0){exit(10);}",
        "if(C2[2,1]-delta^8*p*P1!=0){exit(11);}",
        "if(C2[3,1]-delta^6*P2!=0){exit(12);}",
    ]
    decomposition = [
        "poly a1=diff(P0,h0); poly b1=P0-a1*h0;",
        "poly a2=diff(P1,h0); poly b2=P1-a2*h0;",
        "poly a3=diff(P2,h0); poly b3=P2-a3*h0;",
        "poly g12=a1*b2+a2*b1;",
        "poly g13=a1*b3+a3*b1;",
        "poly g23=a2*b3+a3*b2;",
        # exact quotients by the linear components.
        "poly e12=g12/(e*delta*(e+delta));",
        "if(e12*(e*delta*(e+delta))-g12!=0){exit(13);}",
        "poly e13=g13/(e*delta*(e+delta));",
        "if(e13*(e*delta*(e+delta))-g13!=0){exit(14);}",
        "poly e23=g23/(e*delta^2*(e+delta));",
        "if(e23*(e*delta^2*(e+delta))-g23!=0){exit(15);}",
        # residuals live in (delta,p,w) only.
        "if(e12-subst(subst(subst(subst(e12,e,0),b,0),h0,0),h1,0)!=0){exit(16);}",
        "if(e13-subst(subst(subst(subst(e13,e,0),b,0),h0,0),h1,0)!=0){exit(17);}",
        "if(e23-subst(subst(subst(subst(e23,e,0),b,0),h0,0),h1,0)!=0){exit(18);}",
        # p=1 chart ((delta,p)-homogeneity is certified on the Python side):
        # any common zero has theta*w*(w+1)=0; w in GF(2) forces delta=p;
        # theta=0 forces delta=0.
        "poly s12=subst(e12,p,1);",
        "poly s13=subst(e13,p,1);",
        "poly s23=subst(e23,p,1);",
        "poly rA=resultant(s12,s13,delta);",
        "poly rB=resultant(s12,s23,delta);",
        "poly rC=resultant(s13,s23,delta);",
        "poly gg=gcd(gcd(rA,rB),rC);",
        "poly Tw=(theta*w*(w+1))^36;",
        "poly qq=Tw/gg; if(qq*gg-Tw!=0){exit(19);}",
        "poly c0=gcd(gcd(subst(s12,w,0),subst(s13,w,0)),subst(s23,w,0));",
        "if(c0-(delta+1)^6!=0){exit(20);}",
        "poly c1=gcd(gcd(subst(s12,w,1),subst(s13,w,1)),subst(s23,w,1));",
        "if(c1-(delta+1)^6!=0){exit(21);}",
        # the h0-free candidate needs all alpha_i=0, which forces theta=0.
        "poly q1=a1/delta; if(q1*delta-a1!=0){exit(22);}",
        "poly q2=a2/(delta^2); if(q2*delta^2-a2!=0){exit(23);}",
        "poly q3=a3/(delta^2); if(q3*delta^2-a3!=0){exit(24);}",
        "poly rw1=resultant(subst(q1,p,1),subst(q2,p,1),delta);",
        "poly rw2=resultant(subst(q1,p,1),subst(q3,p,1),delta);",
        "poly ga=gcd(rw1,rw2);",
        "poly Ta=theta^9;",
        "poly qa=Ta/ga; if(qa*ga-Ta!=0){exit(25);}",
    ]
    theta_zero = [
        # theta=0 case over GF(4): the delta-gcd is a pure delta power.
        "ring r4=(2,z),(dd),dp;",
        "minpoly=z2+z+1;",
        "map mz=rt,0,0,0,dd,0,1,z,0,0;",
        "poly z12=mz(e12); poly z13=mz(e13); poly z23=mz(e23);",
        "poly cz=gcd(gcd(z12,z13),z23);",
        "if(cz-dd^6!=0){exit(26);}",
        "setring rt;",
    ]
    branches = [
        "poly R0=A2*t^2+A1*t+A0;",
        # trivial branch e=0, h0=0: (t*b+h1) times a t-linear cofactor.
        "poly RT=subst(subst(R0,e,0),h0,0);",
        "poly LT=t*b+h1;",
        "poly MT=RT/LT; if(MT*LT-RT!=0){exit(27);}",
        "if(deg(MT,wt)!=1){exit(28);}",
        "if(deg(MT,wu)!=5){exit(29);}",
        # branch e=delta: membership, closed-form h0, rational split.
        "poly aA=diff(subst(P0,delta,e),h0);",
        "poly bA=subst(subst(P0,delta,e),h0,0);",
        "poly PA1=subst(P1,delta,e); poly PA2=subst(P2,delta,e);",
        "if(aA*subst(PA1,h0,0)+diff(PA1,h0)*bA!=0){exit(30);}",
        "if(aA*subst(PA2,h0,0)+diff(PA2,h0)*bA!=0){exit(31);}",
        "if(bA-aA*(p^2*theta+e^2+e*b)!=0){exit(32);}",
        "poly RA=subst(R0,delta,e);",
        "poly NA=aA*subst(RA,h0,0)+bA*diff(RA,h0);",
        "poly LA=e^2+t*b+e*b+e*p+h1;",
        "poly MA=NA/(aA*LA); if(MA*aA*LA-NA!=0){exit(33);}",
        "if(deg(MA,wt)!=1){exit(34);}",
        "if(deg(MA,wu)!=5){exit(35);}",
        # branch delta=p, theta=1 (w=0 and w=1): N_B = p^12*Q^2*L1*L2.
        "poly L1=u*e+e^2+t*b+e*b+e*p+h1;",
        "poly L2=L1+u*p;",
        "poly QB=u^2+u*p+p^2;",
        "int wv;",
        "for(wv=0;wv<=1;wv++){",
        "  poly PB0=subst(subst(P0,delta,p),w,wv);",
        "  poly PB1=subst(subst(P1,delta,p),w,wv);",
        "  poly PB2=subst(subst(P2,delta,p),w,wv);",
        "  poly aB=diff(PB0,h0); poly bB=subst(PB0,h0,0);",
        "  if(aB-p^12!=0){exit(36);}",
        "  if(bB-aB*(e*(e+b+p))!=0){exit(37);}",
        "  if(aB*subst(PB1,h0,0)+diff(PB1,h0)*bB!=0){exit(38);}",
        "  if(aB*subst(PB2,h0,0)+diff(PB2,h0)*bB!=0){exit(39);}",
        "  poly RB=subst(subst(R0,delta,p),w,wv);",
        "  poly NB=aB*subst(RB,h0,0)+bB*diff(RB,h0);",
        "  if(NB-p^12*QB^2*L1*L2!=0){exit(40);}",
        "  kill PB0,PB1,PB2,aB,bB,RB,NB;",
        "}",
        'print("a-zero AS-divisor certificate passes");',
    ]
    run_singular(prelude + identities + division_check + decomposition
                 + theta_zero + branches)


GF8_MOD = 0b1011


def gf8_mul(x: int, y: int) -> int:
    out = 0
    while y:
        if y & 1:
            out ^= x
        y >>= 1
        x <<= 1
        if x & 0b1000:
            x ^= GF8_MOD
    return out


GF8_POW = {
    base: [1] + [0] * 30 for base in range(8)
}
for _base, _row in GF8_POW.items():
    for _i in range(1, 31):
        _row[_i] = gf8_mul(_row[_i - 1], _base)

GF8_INV = {x: next(y for y in range(1, 8) if gf8_mul(x, y) == 1)
           for x in range(1, 8)}


def gf8_evaluate(poly, values: dict[int, int]) -> int:
    out = 0
    for m in poly:
        acc = 1
        for index, exponent in enumerate(m):
            if exponent:
                acc = gf8_mul(acc, GF8_POW[values[index]][exponent])
        out ^= acc
    return out


def census(p0, p1, p2, ring: TargetRing) -> dict[str, int]:
    """Exact GF(8) solutions of P0=P1=P2=0 with delta,b,p!=0 vs the branches."""
    splits = [h0_split(ring, poly) for poly in (p0, p1, p2)]
    solutions = set()
    nonzero = range(1, 8)
    for e, delta, b, p, w in itertools.product(
        range(8), nonzero, nonzero, nonzero, range(8)
    ):
        values = {E: e, DELTA: delta, B: b, P: p, W: w, H0: 0, H1: 0}
        pairs = [
            (gf8_evaluate(alpha, values), gf8_evaluate(beta, values))
            for alpha, beta in splits
        ]
        if all(alpha == 0 for alpha, _ in pairs):
            assert any(beta for _, beta in pairs), (e, delta, b, p, w)
            continue
        alpha, beta = next(pair for pair in pairs if pair[0])
        h0 = gf8_mul(beta, GF8_INV[alpha])
        if all(gf8_mul(al, h0) ^ be == 0 for al, be in pairs):
            solutions.add((e, delta, b, p, w, h0))

    theta = lambda w: gf8_mul(w, w) ^ w ^ 1
    trivial = {
        (0, delta, b, p, w, 0)
        for delta, b, p, w in itertools.product(nonzero, nonzero, nonzero,
                                                range(8))
    }
    branch_a = {
        (e, e, b, p, w,
         gf8_mul(gf8_mul(p, p), theta(w)) ^ gf8_mul(e, e) ^ gf8_mul(e, b))
        for e, b, p, w in itertools.product(nonzero, nonzero, nonzero,
                                            range(8))
    }
    branch_b = {
        (e, p, b, p, w, gf8_mul(e, e ^ b ^ p))
        for e, b, p, w in itertools.product(nonzero, nonzero, nonzero, (0, 1))
        if e != p
    }
    assert solutions == trivial | branch_a | branch_b
    assert trivial.isdisjoint(branch_a) and trivial.isdisjoint(branch_b)
    assert branch_a.isdisjoint(branch_b)

    # H = delta*G1 never vanishes at a rational u: G1 has no GF(8) root.
    for p, w, u in itertools.product(nonzero, range(8), range(8)):
        value = gf8_mul(u, u) ^ gf8_mul(u, p) ^ gf8_mul(
            gf8_mul(p, p), theta(w))
        assert value != 0
    return {
        "solutions": len(solutions),
        "trivial_coset_branch": len(trivial),
        "second_coset_branch": len(branch_a),
        "delta_equals_p_branch": len(branch_b),
        "g1_rational_root_checks": 7 * 8 * 8,
    }


def witnesses() -> dict[str, dict[str, int]]:
    """Exact GF(64) incidence witnesses for the three branches."""
    context = build_context(1)
    field = context.ambient
    base = context.base_values
    add, mul = field.add, field.mul
    generator = next(
        x for x in base if x not in (0, 1)
        and add(add(mul(mul(x, x), x), x), 1) == 0
    )

    def embed(value: int) -> int:
        out = 0
        if value & 4:
            out = add(out, mul(generator, generator))
        if value & 2:
            out = add(out, generator)
        if value & 1:
            out = add(out, 1)
        return out

    def run_point(values: tuple[int, ...], lines) -> dict[str, int]:
        e, delta, b, p, w, h0, h1 = (embed(v) for v in values)
        f = add(e, delta)
        theta = add(add(mul(w, w), w), 1)
        k0 = add(add(mul(mul(p, p), theta), mul(delta, b)),
                 mul(delta, delta))
        k1 = add(add(mul(delta, p), mul(delta, b)), mul(delta, delta))
        out: dict[str, int] = {}
        for seed_name, seed_height in (
            ("alpha", context.alpha), ("beta", context.beta)
        ):
            g0, g1 = context.coordinates(seed_height)
            c0, c1 = add(h0, g0), add(h1, g1)
            d0, d1 = add(c0, k0), add(c1, k1)
            left = dict(zip(base, repair_points(context, e, 0, b, c0, c1)))
            right = dict(zip(base, repair_points(context, f, 0, b, d0, d1)))
            genuine = set()
            coincident = 0
            for u in base:
                if u == 0:
                    continue
                for t in base:
                    seed_point = (t, seed_height)
                    for r in base:
                        s = add(r, u)
                        if line_key(context, left[r], right[s]) != line_key(
                            context, left[r], seed_point
                        ):
                            continue
                        if len({left[r], right[s], seed_point}) == 3:
                            genuine.add((u, t))
                        else:
                            coincident += 1
                        break
            out[f"{seed_name}_genuine"] = len(genuine)
            out[f"{seed_name}_coincident"] = coincident
            if lines:
                constant = add(add(add(mul(e, e), mul(e, b)), mul(e, p)), h1)
                inverse_b = field.div(1, b)
                expected = set()
                for u in base:
                    if u == 0:
                        continue
                    expected.add((u, mul(add(mul(u, e), constant), inverse_b)))
                    expected.add((u, mul(
                        add(mul(u, add(e, p)), constant), inverse_b)))
                assert genuine == expected, (values, seed_name)
                out[f"{seed_name}_equals_L1_union_L2"] = 1
        return out

    return {
        "delta_equals_p_point_1_2_1_2_0_2_3": run_point(
            (1, 2, 1, 2, 0, 2, 3), lines=True),
        "second_coset_point_7_7_2_1_4_5_0": run_point(
            (7, 7, 2, 1, 4, 5, 0), lines=False),
        "trivial_coset_point_0_3_2_5_4_0_1": run_point(
            (0, 3, 2, 5, 4, 0, 1), lines=False),
    }


def main() -> None:
    ring, cover = trace_one_pullback()
    cover0 = restrict_zero(cover, "a")
    a2 = t_coefficient(cover0, 2)
    a1 = t_coefficient(cover0, 1)
    a0 = t_coefficient(cover0, 0)
    assert max(m[H0] for m in cover0) == 1

    # guard the local pullback against the committed one, then pull H back.
    ring0 = BinaryRing()
    quadratics = expected_quadratics(ring0)
    assert pullback_a0(ring0, ring, resultant(ring0, quadratics)) == cover0
    qa, qb, qc, qd, qe, qf = quadratics
    h_pull = pullback_a0(
        ring0, ring, ring0.add(ring0.mul(qd, qb), ring0.mul(qa, qe)))
    assert variable_free(h_pull, T, E, B, H0, H1)

    # residue polynomial in the exact set ring.
    v = ring.v
    theta = ring.add(ring.power(v["w"], 2), v["w"], ring.one)
    g1 = ring.add(ring.power(v["u"], 2), ring.mul(v["u"], v["p"]),
                  ring.mul(ring.power(v["p"], 2), theta))
    g2 = ring.add(
        ring.power(v["u"], 3), ring.mul(ring.power(v["u"], 2), v["delta"]),
        ring.product((v["u"], ring.power(v["p"], 2), theta)),
        ring.product((v["delta"], ring.power(v["p"], 2), theta)),
        ring.mul(ring.power(v["delta"], 2), v["p"]),
    )
    q_poly = ring.add(ring.power(v["u"], 2), ring.mul(v["u"], v["delta"]),
                      ring.power(v["delta"], 2))
    assert h_pull == ring.mul(v["delta"], g1)

    a0d = u_derivative(a0)
    d_full = ring.product((v["delta"], g1, g2))
    dp = u_derivative(d_full)
    w_poly = ring.add(
        ring.mul(ring.power(a0d, 2), ring.power(q_poly, 4)),
        ring.product((a0, ring.power(q_poly, 2), ring.power(dp, 2))),
    )
    assert u_reduce(ring, w_poly, g1) == set()
    w2 = u_reduce(ring, w_poly, g2)
    assert u_degree(w2) == 2

    residues = []
    strip_exponents = []
    for degree in range(3):
        coefficient = set()
        for m in w2:
            if m[U] == degree:
                reduced = list(m)
                reduced[U] = 0
                coefficient.add(tuple(reduced))
        stripped, delta_power = strip_monomial(coefficient, DELTA)
        stripped, p_power = strip_monomial(stripped, P)
        assert variable_free(stripped, H1)
        assert max(m[H0] for m in stripped) == 1
        residues.append(stripped)
        strip_exponents.append((delta_power, p_power))
    p0, p1, p2 = residues
    assert strip_exponents == [(7, 1), (8, 1), (6, 0)]

    # alpha_i are (delta,p,w)-only; beta_i are divisible by e; the stripped
    # cross-determinant residuals are (delta,p)-homogeneous, so the p=1 chart
    # in the Singular certificate covers all of p!=0.
    splits = [h0_split(ring, poly) for poly in residues]
    for alpha, beta in splits:
        assert variable_free(alpha, E, B, H0, H1)
        assert min(m[E] for m in beta) >= 1
    gammas = []
    for (ai, bi), (aj, bj) in itertools.combinations(splits, 2):
        gammas.append(ring.add(ring.mul(ai, bj), ring.mul(aj, bi)))
    for gamma in gammas:
        shifted = substitute_e_shift(ring, gamma)
        shifted, e_shift_power = strip_monomial(shifted, E)
        assert e_shift_power == 1
        residual = restrict_zero(shifted, "e")
        residual, _ = strip_monomial(residual, DELTA)
        residual, _ = strip_monomial(residual, P)
        assert variable_free(residual, B, H0, H1)
        assert dp_homogeneous(residual)

    singular_certificate(a2, a1, a0, h_pull, p0, p1, p2)
    census_counts = census(p0, p1, p2, ring)
    witness_counts = witnesses()

    print(json.dumps({
        "stratum": "a=0, b!=0, delta!=0 (two-coset shared-(a,b) trace-one cover)",
        "phi": "A0*Q^2/(delta^2*G1^2*G2^2); poles order two at roots of G1*G2",
        "residues": {
            "W": "(A0')^2*Q^4 + A0*Q^2*(D')^2 with D=delta*G1*G2",
            "W_mod_G1": 0,
            "W_mod_G2_u_degree": 2,
            "coefficient_content": {
                "u0": "delta^7*p*P0", "u1": "delta^8*p*P1", "u2": "delta^6*P2",
            },
            "P_shape": "h1-free, linear in h0; alpha_i in (delta,p,w) only",
        },
        "divisor_D3": {
            "trivial_coset": "e=0, h0=0",
            "second_coset": "e=delta, h0=p^2*theta+e^2+e*b",
            "delta_equals_p": "delta=p, theta=1 (w in GF(2)), h0=e*(e+b+p)",
            "h1": "free on every branch",
            "completeness": (
                "cross-determinant residuals are (delta,p)-homogeneous and "
                "(delta,p,w)-only; any further zero needs theta*w*(w+1)=0; "
                "w in GF(2) forces delta=p; theta=0 forces delta=0 and has no "
                "rational w over GF(8^m), odd m"
            ),
            "merged_pole_locus": (
                "Res(G1,G2)=p^2*K1*K2; there D'(rho)=0 and W=(A0'*Q^2)^2 mod "
                "(G1,G2), so AS-triviality still forces G2|W: shrink-only"
            ),
        },
        "rational_split": {
            "trivial_coset": "(t*b+h1) * (t-linear, u-degree-5 cofactor)",
            "second_coset": "alphaA*(e^2+t*b+e*b+e*p+h1) * (t-linear, u-degree-5)",
            "delta_equals_p": "p^12*Q^2*L1*L2, L1=u*e+e^2+t*b+e*b+e*p+h1, L2=L1+u*p",
            "conclusion": "every D3 branch splits rationally over every field",
        },
        "split_locus": {
            "H_pullback": "delta*G1",
            "odd_tower": (
                "G1/p^2 = v^2+v+theta with tr(theta)=tr(1)=1 over GF(8^m), "
                "odd m: H=J=0 has no rational point; r=J/H always reconstructs"
            ),
        },
        "census_gf8": census_counts,
        "witnesses_gf64": witness_counts,
        "conclusion": (
            "off D3 the cover is absolutely irreducible and Lang-Weil forces "
            "reconstructible collisions; on D3 every branch splits into "
            "rational components carrying genuine collisions (exactly L1 u L2 "
            "at the delta=p witness). No collision-free coefficient stratum "
            "exists on a=0, b!=0."
        ),
        "does_not_prove": [
            "the boundaries p=0, delta=0, b=0 (owned by earlier gates)",
            "the a!=0 factorization divisors (next frontier)",
            "the classical AS-reduction and Lang-Weil steps (trusted theory)",
            "geometric structure of the h0-free sublocus inside theta=0 "
            "(arithmetically empty over the odd tower)",
        ],
        "field_conventions": (
            "GF(2) symbolic; GF(8) census as GF(2)[x]/(x^3+x+1) bit encoding; "
            "GF(64) witnesses via the committed QuadraticField context"
        ),
        "certificate_boundary": (
            "Singular reduce/resultant/gcd/exact-division over GF(2)[params] "
            "and one GF(4) gcd; Python exact GF(2) set arithmetic; trusted as "
            "the CAS"
        ),
    }, sort_keys=True))


if __name__ == "__main__":
    main()
