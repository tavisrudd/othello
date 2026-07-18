#!/usr/bin/env python3
"""C210 Packet 3: classify both second-layer Artin--Schreier components.

On every known ``a != 0, b != 0`` exact-split branch, put

    x = tau/(b*Q),
    chi0 = A/(b*Q)^2,
    chi1 = (A+sigma)/(b*Q)^2.

Branches 1 and 2 have constant ``chi0`` and share the rational summand

    r = C*G1*G2a/Q^2,       C = a*delta*N/b^2.

The checker certifies its polynomial part, the exact finite-pole residue
criterion, and the branch-3 cancellation ``G1=Q``,
``G2a=(u+a*p)*Q``.  A complete GF(8) census independently checks that the
nonconstant component on branches 1 and 2 has an affine rational point for
every allowed geometry and every constant class.  The companion report gives
the Artin--Schreier reduction, genus, and Hasse--Weil argument.
"""

from __future__ import annotations

import collections
import json
import shutil
import subprocess

from analyze_c210_a_nonzero_dAS_census import (
    GF8_INV,
    add,
    mul,
    square,
    theta as gf8_theta,
)


def singular_certificate() -> None:
    lines = [
        "ring r=2,(u,e,delta,a,b,p,w,h1),(lp(1),dp);",
        "poly theta=w^2+w+1; poly N=a^2+a+1;",
        "poly Q=u^2+u*delta+delta^2;",
        "poly G1=u^2+u*p+p^2*theta;",
        "poly G2a=u^3+u^2*delta+u*p^2*theta+delta*p^2*theta"
        "+delta^2*p+delta*a*G1;",
        "poly P=G1*G2a; poly qinf=u+delta*a+delta+p;",
        "intvec uweight=1,0,0,0,0,0,0,0;",
        # Exact polynomial part of P/Q^2.
        "poly proper=P+Q^2*qinf;",
        "if(deg(proper,uweight)>3){exit(1);}",
        "if(P+Q^2*qinf+proper!=0){exit(2);}",
        # For C=a*delta*N/b^2, the reduced simple residue at Q vanishes
        # exactly when Q divides this denominator-cleared local criterion.
        "poly poleW=a*delta*N*diff(P,u)^2+b^2*delta^2*P;",
        "poly poleRem=reduce(poleW,std(Q));",
        "if(deg(poleRem,uweight)>1){exit(3);}",
        "poly pole0=subst(poleRem,u,0);",
        "poly pole1=subst(poleRem,u,1)+pole0;",
        "if(poleRem-(pole1*u+pole0)!=0){exit(4);}",
        # A compact exact projection check for the cancellation stratum in
        # the lossless delta=1 chart.  The last two factors are K1,K2.
        "poly v0=subst(pole0,delta,1); poly v1=subst(pole1,delta,1);",
        "poly R0=p^4*w^4+p^4*w^2+p^4+a*p^2+p^2+a+1;",
        "poly K1=p^2*w^2+p^2*w+p^2+p*w+1; poly K2=K1+p;",
        "poly rb=resultant(v1,v0,b);",
        "if(rb-a^2*N^2*R0^2*K1^4*K2^4!=0){exit(5);}",
        # On branch 3 both apparent Q poles cancel before AS reduction.
        "poly G10=subst(subst(G1,delta,p),w,0);",
        "poly G11=subst(subst(G1,delta,p),w,1);",
        "poly G20=subst(subst(G2a,delta,p),w,0);",
        "poly G21=subst(subst(G2a,delta,p),w,1);",
        "poly Q3=subst(Q,delta,p);",
        "if(G10-Q3!=0 || G11-Q3!=0){exit(6);}",
        "if(G20-(u+a*p)*Q3!=0 || G21-(u+a*p)*Q3!=0){exit(7);}",
        "if(subst(subst(poleRem,delta,p),w,0)!=0){exit(8);}",
        "if(subst(subst(poleRem,delta,p),w,1)!=0){exit(9);}",
        # Denominator-cleared affine-linear normal forms on branch 3.
        "poly n30=a*(h1+e*b+e*N*(u+p+(a+1)*e));",
        "poly c30=a*(h1+e*b+e*N*(p+(a+1)*e));",
        "poly l0=a*e*N; poly C3=a*p*N;",
        "poly n31=n30+C3*(u+a*p);",
        "poly c31=c30+a^2*p^2*N; poly l1=a*N*(e+p);",
        "if(n30-(l0*u+c30)!=0){exit(10);}",
        "if(n31-(l1*u+c31)!=0){exit(11);}",
        # The constant first components and their infinity constants on
        # branches 1 and 2, all recorded before division by b^2.
        "poly L2=a*p^2*theta+delta*a*p+delta^2+delta*b+delta*p+h1;",
        "poly c10=a*h1; poly c20=a*L2; poly Cnum=a*delta*N;",
        "poly k11=c10+Cnum*(delta*a+delta+p);",
        "poly k21=c20+Cnum*(delta*a+delta+p);",
        "if(k11-(c10+Cnum*subst(qinf,u,0))!=0){exit(12);}",
        "if(k21-(c20+Cnum*subst(qinf,u,0))!=0){exit(13);}",
        'print("a-nonzero second-layer certificate passes");',
    ]
    singular = shutil.which("Singular")
    command = (
        [singular, "-q"]
        if singular
        else ["nix", "shell", "nixpkgs#singular", "--command", "Singular", "-q"]
    )
    completed = subprocess.run(
        command,
        input="\n".join(lines),
        text=True,
        capture_output=True,
        check=True,
        timeout=300,
    )
    assert completed.stderr == "", completed.stderr
    assert completed.stdout.strip() == "a-nonzero second-layer certificate passes", (
        completed.stdout
    )


def gf8_trace(value: int) -> int:
    return add(value, square(value), square(square(value)))


def gf8_field_law_checks() -> dict[str, object]:
    trace_histogram = collections.Counter(gf8_trace(value) for value in range(8))
    assert trace_histogram == {0: 4, 1: 4}
    root_histogram: collections.Counter[tuple[int, int]] = collections.Counter()
    for rhs in range(8):
        roots = sum(add(square(x), x, rhs) == 0 for x in range(8))
        root_histogram[(gf8_trace(rhs), roots)] += 1
    assert root_histogram == {(0, 2): 4, (1, 0): 4}

    q_zeros = 0
    n_zeros = 0
    for delta in range(1, 8):
        for u in range(8):
            q_zeros += add(square(u), mul(u, delta), square(delta)) == 0
    for a in range(1, 8):
        n_zeros += add(square(a), a, 1) == 0
    assert q_zeros == n_zeros == 0
    return {
        "AS_root_law": {"trace_0_rhs": 4, "roots_each": 2, "trace_1_rhs": 4},
        "N_nonzero_values_checked": 7,
        "Q_nonzero_pairs_checked": 7 * 8,
        "zeros": 0,
    }


def pair_add(left: tuple[int, int], right: tuple[int, int]) -> tuple[int, int]:
    return add(left[0], right[0]), add(left[1], right[1])


def pair_scale(scalar: int, value: tuple[int, int]) -> tuple[int, int]:
    return mul(scalar, value[0]), mul(scalar, value[1])


def pair_mul(
    left: tuple[int, int], right: tuple[int, int], delta: int
) -> tuple[int, int]:
    """Multiply in GF(8)[u]/(u^2+delta*u+delta^2)."""
    l0, l1 = left
    r0, r1 = right
    return (
        add(mul(l0, r0), mul(l1, r1, square(delta))),
        add(mul(l0, r1), mul(l1, r0), mul(l1, r1, delta)),
    )


def gf8_geometry_data(delta: int, a: int, b: int, p: int, w: int):
    th = gf8_theta(w)
    N = add(square(a), a, 1)
    C = mul(a, delta, N, square(GF8_INV[b]))
    trace_zero_u = 0
    for u in range(8):
        Q = add(square(u), mul(u, delta), square(delta))
        G1 = add(square(u), mul(u, p), mul(square(p), th))
        G2a = add(
            mul(square(u), u),
            mul(square(u), delta),
            mul(u, square(p), th),
            mul(delta, square(p), th),
            mul(square(delta), p),
            mul(delta, a, G1),
        )
        value = mul(C, G1, G2a, GF8_INV[square(Q)])
        trace_zero_u += gf8_trace(value) == 0

    # Independent quotient-ring evaluation of poleW mod Q.
    U = (0, 1)
    U2 = (square(delta), delta)
    U3 = pair_mul(U, U2, delta)
    G1q = (add(square(delta), mul(square(p), th)), add(delta, p))
    G2q = pair_add(U3, pair_scale(delta, U2))
    G2q = pair_add(G2q, pair_scale(mul(square(p), th), U))
    G2q = pair_add(
        G2q,
        (add(mul(delta, square(p), th), mul(square(delta), p)), 0),
    )
    G2q = pair_add(G2q, pair_scale(mul(delta, a), G1q))
    Pq = pair_mul(G1q, G2q, delta)
    G2primeq = pair_add(
        U2, (add(mul(square(p), th), mul(delta, a, p)), 0)
    )
    Pprimeq = pair_add(
        pair_scale(p, G2q), pair_mul(G1q, G2primeq, delta)
    )
    poleWq = pair_add(
        pair_scale(mul(a, delta, N), pair_mul(Pprimeq, Pprimeq, delta)),
        pair_scale(mul(square(b), square(delta)), Pq),
    )
    return trace_zero_u, poleWq == (0, 0)


def gf8_census() -> dict[str, object]:
    zero_trace_histogram: collections.Counter[int] = collections.Counter()
    finite_pole_cancellations = 0
    for delta in range(1, 8):
        for a in range(1, 8):
            for b in range(1, 8):
                for p in range(1, 8):
                    for w in range(8):
                        trace_zero_u, cancellation = gf8_geometry_data(
                            delta, a, b, p, w
                        )
                        assert 1 <= trace_zero_u <= 7
                        zero_trace_histogram[trace_zero_u] += 1
                        finite_pole_cancellations += cancellation

    assert zero_trace_histogram == {
        1: 336,
        2: 1806,
        3: 4830,
        4: 5936,
        5: 3696,
        6: 2058,
        7: 546,
    }
    assert finite_pole_cancellations == 1022

    constant_class_histogram: collections.Counter[int] = collections.Counter()
    for zero_count, geometries in zero_trace_histogram.items():
        constant_class_histogram[zero_count] += 4 * geometries
        constant_class_histogram[8 - zero_count] += 4 * geometries
    assert sum(constant_class_histogram.values()) == 7**4 * 8 * 8
    assert min(constant_class_histogram) == 1

    return {
        "geometry_count": 7**4 * 8,
        "finite_Q_pole_cancellations": finite_pole_cancellations,
        "zero_trace_u_histogram": dict(sorted(zero_trace_histogram.items())),
        "geometry_constant_class_count": 7**4 * 8 * 8,
        "rational_u_histogram_by_constant_class": dict(
            sorted(constant_class_histogram.items())
        ),
        "minimum_affine_x_u_points": 2,
        "verdict": "chi=c+C*G1*G2a/Q^2 has a GF(8) point for every allowed geometry and c",
    }


def main() -> None:
    singular_certificate()
    field_checks = gf8_field_law_checks()
    census = gf8_census()
    print(
        json.dumps(
            {
                "scope": "a*delta*N*b*p!=0 over k=GF(8^m), m odd",
                "shared_term": {
                    "r": "C*G1*G2a/Q^2, C=a*delta*N/b^2",
                    "polynomial_part": "C*(u+delta*a+delta+p)",
                    "finite_pole_test": "Q divides poleW, poleW=a*delta*N*(d(G1*G2a)/du)^2+b^2*delta^2*G1*G2a",
                    "pole_divisor": {
                        "Q_divides_poleW": "infinity only; genus 0",
                        "otherwise": "infinity plus the degree-2 Q-place; geometric genus 2",
                    },
                    "absolute_irreducibility": "always, because C!=0 gives a reduced simple pole at infinity",
                },
                "branches": [
                    {
                        "branch": 1,
                        "chi0": "c10=a*h1/b^2 (constant)",
                        "chi1": "c10+r",
                        "chi1_constant_class": "[a*h1/b^2+C*(delta*a+delta+p)] in k/AS(k)",
                    },
                    {
                        "branch": 2,
                        "L2": "a*p^2*theta+delta*a*p+delta^2+delta*b+delta*p+h1",
                        "chi0": "c20=a*L2/b^2 (constant)",
                        "chi1": "c20+r",
                        "chi1_constant_class": "[a*L2/b^2+C*(delta*a+delta+p)] in k/AS(k)",
                    },
                    {
                        "branch": 3,
                        "identities": "delta=p, theta=1: G1=Q, G2a=(u+a*p)*Q",
                        "chi0": "(a*e*N/b^2)*u+c30",
                        "c30": "a*(h1+e*b+e*N*(p+(a+1)*e))/b^2",
                        "chi1": "(a*N*(e+p)/b^2)*u+c31",
                        "c31": "c30+a^2*p^2*N/b^2",
                        "classification": "each nonconstant class is genus-0 rational with exactly q affine points; chi0 is constant only at e=0 and chi1 only at e=p",
                    },
                ],
                "constant_component_rule": "x^2+x=c has 2q affine points iff Tr_k(c)=0, and none iff Tr_k(c)=1",
                "point_forcing": "branch 3 for every odd-tower q; branches 1-2 at q=8 by census and q>=512 by genus<=2 Hasse-Weil after deleting the unique infinity point",
                "gf8_field_checks": field_checks,
                "gf8_census": census,
                "does_not_prove": [
                    "reconstruction beyond the already certified H=delta*N*G1 identity",
                    "projective distinctness or genuineness",
                    "arithmetic completeness of the three residue branches",
                ],
                "trusted_boundary": "exact GF(2) Singular identities, direct GF(8) arithmetic, classical Artin-Schreier reduction and Hasse-Weil as detailed in the report",
            },
            sort_keys=True,
        )
    )


if __name__ == "__main__":
    main()
