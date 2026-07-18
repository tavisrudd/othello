#!/usr/bin/env python3
"""C210 Packet 1: exact original-cover splits on the three known D_AS branches.

The checker rebuilds the constant coefficient ``B0`` from the committed
seed--cross-repair resultant, forms

    F = psi^2 + sigma*psi + R1,
    psi = tau^2 + b*Q*tau,
    sigma = a*delta*N*G1*G2a,
    R1 = a^2*Q^2*B0,

and verifies the proposed roots ``A`` of ``X^2+sigma*X+R1`` by direct exact
identity.  It also expands

    F = (psi+A)*(psi+A+sigma)

on every branch.  Branch 3 is checked separately at ``w=0`` and ``w=1``;
neither check divides by the merged-pole resultant ``K1*K2``.

The displayed roots are polynomials over GF(2), not rational functions, so the
denominator audit is empty and no constant-field extension is used.  This
packet certifies factorization only: it does not certify a rational tau-root,
reconstruction, genuineness, or a collision.
"""

from __future__ import annotations

import json
import shutil
import subprocess

from analyze_c210_a_nonzero_dAS_branches import H0_BR2, H0_BR3, sform
from analyze_c210_a_zero_factorization_strata import (
    TVARS,
    t_coefficient,
    trace_one_pullback,
)


A1 = "a*h1*Q^2"
A2 = "a*Q^2*(a*p^2*theta+delta*a*p+delta^2+delta*b+delta*p+h1)"
A3 = "a*Q^2*(h1+e*b+e*N*(u+p+(a+1)*e))"
L1 = "h1"
L2 = "a*p^2*theta+delta*a*p+delta^2+delta*b+delta*p+h1"
L3 = "h1+e*b+e*N*(u+p+(a+1)*e)"


def sform_with_t(poly) -> str:
    terms = []
    for monomial in poly:
        factors = []
        for i, name in enumerate(TVARS):
            exponent = monomial[i]
            if exponent:
                factors.append(name if exponent == 1 else f"{name}^{exponent}")
        terms.append("*".join(factors) or "1")
    return "+".join(terms) or "0"


def singular_certificate(B0_str: str, cover_str: str) -> None:
    lines = [
        "ring r=2,(tau,t,u,e,delta,a,b,p,w,h0,h1),(lp(2),dp);",
        "poly theta=w^2+w+1;",
        "poly N=a^2+a+1;",
        "poly Q=u^2+u*delta+delta^2;",
        "poly G1=u^2+u*p+p^2*theta;",
        "poly G2a=u^3+u^2*delta+u*p^2*theta+delta*p^2*theta"
        "+delta^2*p+delta*a*G1;",
        f"poly B0={B0_str};",
        f"poly R={cover_str};",
        "poly sigma=a*delta*N*G1*G2a;",
        "poly psi=tau^2+b*Q*tau;",
        "poly R1=a^2*Q^2*B0;",
        "poly F=psi^2+sigma*psi+R1;",
        f"poly L1={L1}; poly L2={L2}; poly L3={L3};",
        f"poly A1={A1}; poly A2={A2}; poly A3={A3};",
        "poly root1=A1^2+sigma*A1+R1;",
        "poly split1=F+(psi+A1)*(psi+A1+sigma);",
        "if(subst(subst(root1,e,0),h0,0)!=0){exit(1);}",
        "if(subst(subst(split1,e,0),h0,0)!=0){exit(2);}",
        "poly T1=a*t^2+b*t+L1;",
        "poly cover1=R+T1*(Q^2*T1+delta*N*G1*G2a);",
        "if(subst(subst(cover1,e,0),h0,0)!=0){exit(3);}",
        f"poly h2=subst(({H0_BR2}),e,delta);",
        "poly root2=subst(subst(A2^2+sigma*A2+R1,e,delta),h0,h2);",
        "poly split2=subst(subst(F+(psi+A2)*(psi+A2+sigma),e,delta),h0,h2);",
        "poly T2=a*t^2+b*t+L2;",
        "poly cover2=subst(subst(R+T2*(Q^2*T2+delta*N*G1*G2a),e,delta),h0,h2);",
        "if(root2!=0){exit(4);}",
        "if(split2!=0){exit(5);}",
        "if(cover2!=0){exit(6);}",
        f"poly h3={H0_BR3};",
        "poly root3=A3^2+sigma*A3+R1;",
        "poly split3=F+(psi+A3)*(psi+A3+sigma);",
        "poly root30=subst(subst(subst(root3,delta,p),w,0),h0,h3);",
        "poly split30=subst(subst(subst(split3,delta,p),w,0),h0,h3);",
        "poly root31=subst(subst(subst(root3,delta,p),w,1),h0,h3);",
        "poly split31=subst(subst(subst(split3,delta,p),w,1),h0,h3);",
        "poly T3=a*t^2+b*t+L3;",
        "poly cover3=R+T3*(Q^2*T3+delta*N*G1*G2a);",
        "poly cover30=subst(subst(subst(cover3,delta,p),w,0),h0,h3);",
        "poly cover31=subst(subst(subst(cover3,delta,p),w,1),h0,h3);",
        "if(root30!=0){exit(7);}",
        "if(split30!=0){exit(8);}",
        "if(cover30!=0){exit(9);}",
        "if(root31!=0){exit(10);}",
        "if(split31!=0){exit(11);}",
        "if(cover31!=0){exit(12);}",
        # On branch 3 at e=0, the chosen component agrees with branch 1.
        "if(subst(subst(subst(A3+A1,e,0),delta,p),w,0)!=0){exit(13);}",
        "if(subst(subst(subst(A3+A1,e,0),delta,p),w,1)!=0){exit(14);}",
        # At e=delta=p it agrees with the other branch-2 component (A2+sigma).
        "if(subst(subst(subst(A3+A2+sigma,e,p),delta,p),w,0)!=0){exit(15);}",
        "if(subst(subst(subst(A3+A2+sigma,e,p),delta,p),w,1)!=0){exit(16);}",
        # A_i are honest polynomials in the declared GF(2) ring and tau-free.
        "intvec tauweight=1,0,0,0,0,0,0,0,0,0,0;",
        "if(deg(A1,tauweight)>0){exit(17);}",
        "if(deg(A2,tauweight)>0){exit(18);}",
        "if(deg(A3,tauweight)>0){exit(19);}",
        'print("a-nonzero exact splits certificate passes");',
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
    assert (
        completed.stdout.strip() == "a-nonzero exact splits certificate passes"
    ), completed.stdout


def main() -> None:
    _, cover = trace_one_pullback()
    B0 = t_coefficient(cover, 0)
    singular_certificate(sform(B0), sform_with_t(cover))

    print(
        json.dumps(
            {
                "branches": [
                    {
                        "branch": 1,
                        "coordinate_ring": "GF(2)[delta,a,b,p,w,h1,u] (e=h0=0)",
                        "A": "a*h1*Q^2",
                    },
                    {
                        "branch": 2,
                        "coordinate_ring": "GF(2)[delta,a,b,p,w,h1,u] (e=delta, h0=h0_2)",
                        "A": "a*Q^2*(a*p^2*theta+delta*a*p+delta^2+delta*b+delta*p+h1)",
                    },
                    {
                        "branch": 3,
                        "coordinate_ring": "GF(2)[e,a,b,p,h1,u] (delta=p, w=0 or 1, h0=h0_3)",
                        "A": "a*Q^2*(h1+e*b+e*N*(u+p+(a+1)*e))",
                        "merged_pole_checks": ["w=0 direct identity", "w=1 direct identity"],
                    },
                ],
                "certificate": {
                    "identities": [
                        "A^2+sigma*A+R1=0 in each branch coordinate ring",
                        "F=(psi+A)*(psi+A+sigma) in each branch coordinate ring",
                        "R=T*(Q^2*T+delta*N*G1*G2a), T=a*t^2+b*t+A/(a*Q^2)",
                    ],
                    "source": "B0 rebuilt from the committed universal resultant",
                    "field_of_definition": "GF(2); no constant-field extension",
                    "denominators": "none; every A is polynomial",
                    "branch_3_method": "direct substitution at w=0 and w=1; no K1*K2 division",
                    "intersections": [
                        "branch 3 at e=0: A3=A1",
                        "branch 3 at e=delta=p: A3=A2+sigma (component labels swap)",
                    ],
                    "trusted_boundary": "universal-resultant generator plus Singular exact polynomial arithmetic over GF(2)",
                },
                "conclusion": "all three known residue-system branches are exact original-cover factorization branches on the b!=0 packet scope",
                "does_not_prove": [
                    "a tau-root on either quadratic component",
                    "reconstruction or projective genuineness",
                    "a genuine collision",
                    "arithmetic completeness of the three-branch list",
                    "the separate b=0,a!=0 inseparable stratum",
                ],
            },
            sort_keys=True,
        )
    )


if __name__ == "__main__":
    main()
