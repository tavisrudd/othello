#!/usr/bin/env python3
"""C210 step-2(b), part 1: the a!=0 ``D_AS`` Artin--Schreier residue conditions.

The step-1 reduction made the whole ``a!=0`` factorization locus the single
divisor ``D_AS = { R1/sigma^2 in the AS image of K }`` and the step-2(a) preflight
([`2026-07-17-c210-a-nonzero-preflight-resultants`]) certified that the poles of

    phi = R1/sigma^2 = Q^2*B0 / (delta^2*N^2*G1^2*G2a^2)      (N=a^2+a+1)

are exactly order two at the simple roots of ``G1*G2a`` off the merged-pole locus
``K1*K2=0``, with the infinity place Artin--Schreier trivial.  This checker
derives the branch conditions, exactly mirroring the a=0 ``W``-residue method
(trusted; see the a=0 report).

**Reduced-residue polynomial.**  Write ``phi = f/D^2`` with ``f = B0*Q^2`` and
``D = delta*N*G1*G2a`` (so ``D^2`` is the full denominator).  At a simple root
``rho`` of ``D`` the char-2 AS class of the order-two pole reduces to a simple
pole whose (Frobenius-reduced) residue vanishes iff ``W(rho)=0``, where -- using
``(Q^2)'=0`` and that ``delta,N`` are ``u``-constant --

    W = f'^2 + f*(D')^2 = (B0')^2*Q^4 + B0*Q^2*(D')^2,   D = delta*N*G1*G2a.

``D_AS`` is thus the locus where ``W`` vanishes at every root of ``G1`` and of
``G2a``.

**What this checker certifies (exact, over GF(2)(e,delta,a,b,p,w,h0,h1)):**

1.  ``W == 0 mod G1`` **identically** -- both ``G1``-residues vanish on the whole
    ``a!=0`` stratum.  The a=0 accident (``W==0 mod G1`` there) *recurs*; the
    G1 place contributes no branch condition, contrary to the "expect new
    ``G1`` conditions" worry.
2.  ``W mod G2a`` has ``u``-degree two, so ``D_AS`` is cut by exactly the three
    ``u``-coefficients ``C0,C1,C2`` (of ``u^0,u^1,u^2``) -- three conditions, the
    same count as a=0's ``P0,P1,P2``, not the feared five.
3.  Every ``C_i`` is **``h1``-free** and **linear in ``h0``** (``deg_{h1}=0``,
    ``deg_{h0}=1``), and quadratic in ``e`` -- the a=0 structural pattern.  So the
    system is again solvable for ``h0`` on each branch by the cross-determinant
    method.
4.  The three conditions share the common content ``gcd(C0,C1,C2) = (delta*N)^6``
    (``a^12+a^10+a^6+a^2+1 = N^6``); stripping it leaves ``c_i = C_i/(delta*N)^6``
    of the recorded sizes, still ``h0``-linear and ``h1``-free.

This does **not** yet decompose ``D_AS`` into explicit branches with their forced
``h0`` (the a=0 analogue of ``{e=0,h0=0}``, ``{e=delta,...}``, ``{delta=p,...}``),
nor decide any branch collision-forcing vs arc-legal, nor treat ``H=J=0`` or the
``b=0,a!=0`` degenerate stratum.  Those are the next step-2(b)/2(c) parts.
"""

from __future__ import annotations

import json
import shutil
import subprocess

from analyze_c210_a_zero_factorization_strata import TVARS, t_coefficient, trace_one_pullback


def sform(poly) -> str:
    terms = []
    for m in poly:
        fac = []
        for i, n in enumerate(TVARS):
            if n == "t":
                continue
            if m[i]:
                fac.append(n if m[i] == 1 else f"{n}^{m[i]}")
        terms.append("*".join(fac) or "1")
    return "+".join(terms) or "0"


# Certified structural facts (each is asserted by the Singular block below;
# regeneration fails loudly on drift via the numbered exit gates).
WG2A_COEFF_SIZES = (1389, 643, 677)      # sizes of C0,C1,C2 (u^0,u^1,u^2)
STRIPPED_SIZES = (453, 221, 185)         # sizes of C_i / (delta*N)^6
CONTENT_GCD = "delta^6*N^6   (N=a^2+a+1; a^12+a^10+a^6+a^2+1 = N^6)"


def singular_certificate(B0_str: str) -> None:
    lines = [
        "ring r=2,(u,e,delta,a,b,p,w,h0,h1),(lp(1),dp);",
        "poly theta=w^2+w+1;",
        "poly N=a^2+a+1;",
        "poly Q=u^2+u*delta+delta^2;",
        "poly G1=u^2+u*p+p^2*theta;",
        "poly G2=u^3+u^2*delta+u*p^2*theta+delta*p^2*theta+delta^2*p;",
        "poly G2a=G2+delta*a*G1;",
        f"poly B0={B0_str};",
        "poly D=delta*N*G1*G2a;",
        "poly W=diff(B0,u)^2*Q^4 + B0*Q^2*diff(D,u)^2;",
        # (1) G1-residues vanish identically.
        "if(reduce(W,std(ideal(G1)))!=0){exit(1);}",
        # (2) W mod G2a has u-degree two.
        "poly WG2a=reduce(W,std(ideal(G2a)));",
        "if(deg(WG2a,intvec(1,0,0,0,0,0,0,0,0))!=2){exit(2);}",
        "matrix C=coeffs(WG2a,u);",
        "if(nrows(C)!=3){exit(3);}",
        "poly C0=C[1,1]; poly C1=C[2,1]; poly C2=C[3,1];",
        # (3) h1-free and h0-linear.
        "if(deg(WG2a,intvec(0,0,0,0,0,0,0,0,1))!=0){exit(4);}",
        "if(deg(C0,intvec(0,0,0,0,0,0,0,1,0))!=1){exit(5);}",
        "if(deg(C1,intvec(0,0,0,0,0,0,0,1,0))!=1){exit(6);}",
        "if(deg(C2,intvec(0,0,0,0,0,0,0,1,0))!=1){exit(7);}",
        # each is quadratic in e.
        "if(deg(C0,intvec(0,1,0,0,0,0,0,0,0))!=2){exit(8);}",
        "if(deg(C1,intvec(0,1,0,0,0,0,0,0,0))!=2){exit(9);}",
        "if(deg(C2,intvec(0,1,0,0,0,0,0,0,0))!=2){exit(10);}",
        # sizes of the raw conditions.
        f"if(size(C0)!={WG2A_COEFF_SIZES[0]}){{exit(11);}}",
        f"if(size(C1)!={WG2A_COEFF_SIZES[1]}){{exit(12);}}",
        f"if(size(C2)!={WG2A_COEFF_SIZES[2]}){{exit(13);}}",
        # (4) common content (delta*N)^6, and stripped sizes.
        "poly g=gcd(gcd(C0,C1),C2);",
        "if(g-delta^6*N^6!=0){exit(14);}",
        f"if(size(C0/g)!={STRIPPED_SIZES[0]}){{exit(15);}}",
        f"if(size(C1/g)!={STRIPPED_SIZES[1]}){{exit(16);}}",
        f"if(size(C2/g)!={STRIPPED_SIZES[2]}){{exit(17);}}",
        # stripped conditions remain h0-linear, h1-free.
        "if(deg(C0/g,intvec(0,0,0,0,0,0,0,1,0))!=1){exit(18);}",
        "if(deg(C0/g,intvec(0,0,0,0,0,0,0,0,1))!=0){exit(19);}",
        'print("a-nonzero residue-conditions certificate passes");',
    ]
    singular = shutil.which("Singular")
    command = ([singular, "-q"] if singular else
               ["nix", "shell", "nixpkgs#singular", "--command", "Singular", "-q"])
    completed = subprocess.run(
        command, input="\n".join(lines), text=True, capture_output=True, check=True
    )
    assert completed.stderr == "", completed.stderr
    assert completed.stdout.strip() == "a-nonzero residue-conditions certificate passes", completed.stdout


def main() -> None:
    ring, cover = trace_one_pullback()
    B0 = t_coefficient(cover, 0)
    singular_certificate(sform(B0))

    print(json.dumps({
        "context": {
            "task": "C210 step-2(b) part 1: a!=0 D_AS Artin-Schreier residue conditions",
            "phi": "R1/sigma^2 = Q^2*B0/(delta^2*N^2*G1^2*G2a^2)   (N=a^2+a+1)",
            "reduced_residue_polynomial": "W = (B0')^2*Q^4 + B0*Q^2*(D')^2,  D = delta*N*G1*G2a",
            "method": "char-2 double-pole AS reduction, mirroring the trusted a=0 W-residue derivation",
            "source": "B0 rebuilt from the committed universal resultant (no re-transcription)",
        },
        "G1_residues": {
            "W_mod_G1": 0,
            "identically_zero": True,
            "consequence": "both G1-residues vanish on the whole a!=0 stratum; the a=0 accident recurs, G1 adds no condition",
        },
        "G2a_residues": {
            "W_mod_G2a_u_degree": 2,
            "num_conditions": 3,
            "conditions": "C0,C1,C2 = u^0,u^1,u^2 coefficients of W mod G2a",
            "h1_free": True,
            "h0_linear": True,
            "e_degree": 2,
            "raw_sizes_C0_C1_C2": list(WG2A_COEFF_SIZES),
        },
        "content": {
            "gcd_C0_C1_C2": CONTENT_GCD,
            "stripped_sizes_c0_c1_c2": list(STRIPPED_SIZES),
            "stripped_still_h0_linear_h1_free": True,
        },
        "conclusion":
            "D_AS is cut by three h1-free, h0-linear conditions (G2a-residues); the G1 place is "
            "automatically trivial. The residue system has the same shape as the closed a=0 divisor, "
            "so the a=0 cross-determinant branch method transfers.",
        "does_not_prove": [
            "the explicit branches of D_AS with forced h0 (cross-determinant decomposition)",
            "whether any branch is collision-free (arc-legal) via the second-layer Tr(A/(bQ)^2)=0 test",
            "the reconstruction-split locus H=J=0 on a!=0",
            "the b=0,a!=0 degenerate stratum (psi=tau^2 inseparable)",
            "the classical AS-reduction and Lang-Weil theory (trusted)",
        ],
        "certificate_boundary":
            "Singular reduce/std/coeffs/gcd/diff over GF(2)(e,delta,a,b,p,w,h0,h1); "
            "block order (lp on u, dp on the rest) so leadterm(G1)=u^2, leadterm(G2a)=u^3",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
