#!/usr/bin/env python3
"""C210 step-2(b), part 2: three explicit branches of the a!=0 ``D_AS`` divisor.

Building on the residue conditions
([`2026-07-17-c210-a-nonzero-residue-conditions`]) -- ``D_AS`` is cut by the three
``h1``-free, ``h0``-linear ``G2a``-residue conditions ``C0,C1,C2`` (``G1``
automatically trivial), with common content ``(delta*N)^6`` -- this checker
exhibits three explicit branches, each an a-deformation of an a=0 branch, and
certifies that each satisfies all three conditions with an explicit forced
``h0`` (``h1`` free throughout).

Write ``c_i = C_i/(delta*N)^6 = h0*A_i + B_i`` (``A_i = d c_i/d h0``,
``B_i = c_i|_{h0=0}``).  On a branch the linear equation ``c0=0`` forces
``h0 = B_0/A_0``; the branch is genuine when that value also kills ``c1,c2``.

| branch | condition       | forced h0 (h1 free)                       | a=0 limit                 |
|--------|-----------------|-------------------------------------------|---------------------------|
| 1      | ``e=0``         | ``0``                                     | ``0``                     |
| 2      | ``e=delta``     | ``p^2*theta + e^2 + e*b + e*a*p``         | ``p^2*theta+e^2+e*b``     |
| 3      | ``delta=p``,    | ``e^2*a^2 + e*a^2*p + e*a*p               | ``e*(e+b+p)``             |
|        | ``theta=1``     | ``       + e^2 + e*b + e*p``              |                           |

(``theta=1`` means ``w`` in ``GF(2)``; both roots ``w=0,1`` are checked.)  Each
forced ``h0`` reduces to the a=0 value at ``a=0`` -- a cross-check against the
closed a=0 divisor.  On branch 2 the a-deformation is the single term ``e*a*p``;
on branch 3 it is ``a^2*e*(e+p) + a*e*p``.  These are the a!=0 analogues of the
a=0 branches ``{e=0,h0=0}``, ``{e=delta,h0=p^2*theta+e^2+e*b}``,
``{delta=p,theta=1,h0=e*(e+b+p)}``.

The checker *derives* each forced ``h0`` (exact polynomial division of ``B_0`` by
``A_0`` on the branch) rather than only checking a guessed value, then asserts
all three ``c_i`` vanish.

**Not proved here (open):** completeness -- that branches 1-3 are *all* of
``D_AS`` off the excluded locus ``delta*p*N*K1*K2=0``.  The cross-determinant
(``h0``-eliminated) variety strictly contains the three branches, so the extra
locus must be shown either spurious (no consistent ``h0`` lift) or inside the
excluded loci before completeness can be claimed; that is the next sub-task
(the a=0 report needed careful resultant/gcd work here, and warned that
``minAssGTZ`` returned a wrong decomposition).  Also open: collision-forcing vs
arc-legal per branch (the second-layer ``Tr(A/(bQ)^2)=0`` test), ``H=J=0`` on
``a!=0``, and the ``b=0,a!=0`` degenerate stratum.
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


# The three branches: (label, forced-h0 Singular expr, a=0 limit expr).
H0_BR2 = "p^2*(w^2+w+1)+e^2+e*b+e*a*p"
H0_BR3 = "e^2*a^2+e*a^2*p+e*a*p+e^2+e*b+e*p"
H0_BR2_AZERO = "p^2*(w^2+w+1)+e^2+e*b"
H0_BR3_AZERO = "e*(e+b+p)"


def singular_certificate(B0_str: str) -> None:
    lines = [
        "ring r=2,(u,e,delta,a,b,p,w,h0,h1),(lp(1),dp);",
        "poly theta=w^2+w+1;",
        "poly N=a^2+a+1;",
        "poly Q=u^2+u*delta+delta^2;",
        "poly G1=u^2+u*p+p^2*theta;",
        "poly G2a=u^3+u^2*delta+u*p^2*theta+delta*p^2*theta+delta^2*p+delta*a*G1;",
        f"poly B0={B0_str};",
        "poly D=delta*N*G1*G2a;",
        "poly WG2a=reduce(diff(B0,u)^2*Q^4 + B0*Q^2*diff(D,u)^2,std(ideal(G2a)));",
        "matrix C=coeffs(WG2a,u);",
        "poly g=delta^6*N^6;",
        "poly c0=C[1,1]/g; poly c1=C[2,1]/g; poly c2=C[3,1]/g;",
        "poly A0=diff(c0,h0); poly B0f=subst(c0,h0,0);",
        # ---- branch 1: e=0, h0=0 ----
        "if(subst(subst(c0,e,0),h0,0)!=0){exit(1);}",
        "if(subst(subst(c1,e,0),h0,0)!=0){exit(2);}",
        "if(subst(subst(c2,e,0),h0,0)!=0){exit(3);}",
        # ---- branch 2: e=delta; DERIVE forced h0 = B0f/A0 on delta=e ----
        "poly Ae=subst(A0,delta,e); poly Be=subst(B0f,delta,e);",
        "if(Ae==0){exit(4);}",
        "if(reduce(Be,std(ideal(Ae)))!=0){exit(5);}",       # divisible
        "poly h2=division(Be,Ae)[1][1,1];",                  # forced h0
        f"if(h2-({H0_BR2})!=0){{exit(6);}}",                 # matches stated value
        "if(subst(subst(c0,delta,e),h0,h2)!=0){exit(7);}",
        "if(subst(subst(c1,delta,e),h0,h2)!=0){exit(8);}",
        "if(subst(subst(c2,delta,e),h0,h2)!=0){exit(9);}",
        f"if(subst(h2,a,0)-({H0_BR2_AZERO})!=0){{exit(10);}}",   # a=0 recovery
        # ---- branch 3: delta=p, theta=1 (w in GF(2)); DERIVE h0 on w=0 ----
        "poly Ap=subst(subst(A0,delta,p),w,0); poly Bp=subst(subst(B0f,delta,p),w,0);",
        "if(Ap==0){exit(11);}",
        "if(reduce(Bp,std(ideal(Ap)))!=0){exit(12);}",
        "poly h3=division(Bp,Ap)[1][1,1];",
        f"if(h3-({H0_BR3})!=0){{exit(13);}}",
        # both roots w=0 and w=1 of theta=1 satisfy all three conditions.
        f"if(subst(subst(subst(c0,delta,p),w,0),h0,{H0_BR3})!=0){{exit(14);}}",
        f"if(subst(subst(subst(c1,delta,p),w,0),h0,{H0_BR3})!=0){{exit(15);}}",
        f"if(subst(subst(subst(c2,delta,p),w,0),h0,{H0_BR3})!=0){{exit(16);}}",
        f"if(subst(subst(subst(c0,delta,p),w,1),h0,{H0_BR3})!=0){{exit(17);}}",
        f"if(subst(subst(subst(c1,delta,p),w,1),h0,{H0_BR3})!=0){{exit(18);}}",
        f"if(subst(subst(subst(c2,delta,p),w,1),h0,{H0_BR3})!=0){{exit(19);}}",
        f"if(subst(h3,a,0)-({H0_BR3_AZERO})!=0){{exit(20);}}",   # a=0 recovery
        # h1 does not enter the conditions (h1 free on every branch).
        "if(deg(WG2a,intvec(0,0,0,0,0,0,0,0,1))!=0){exit(21);}",
        'print("a-nonzero dAS branches certificate passes");',
    ]
    singular = shutil.which("Singular")
    command = ([singular, "-q"] if singular else
               ["nix", "shell", "nixpkgs#singular", "--command", "Singular", "-q"])
    completed = subprocess.run(
        command, input="\n".join(lines), text=True, capture_output=True, check=True
    )
    assert completed.stderr == "", completed.stderr
    assert completed.stdout.strip() == "a-nonzero dAS branches certificate passes", completed.stdout


def main() -> None:
    ring, cover = trace_one_pullback()
    B0 = t_coefficient(cover, 0)
    singular_certificate(sform(B0))

    print(json.dumps({
        "context": {
            "task": "C210 step-2(b) part 2: explicit branches of the a!=0 D_AS divisor",
            "conditions": "c_i = C_i/(delta*N)^6 = h0*A_i + B_i, h0-linear, from the G2a residues",
            "source": "B0 rebuilt from the committed universal resultant (no re-transcription)",
        },
        "branches": [
            {"branch": 1, "condition": "e=0", "forced_h0": "0", "a_zero_limit": "0"},
            {"branch": 2, "condition": "e=delta",
             "forced_h0": "p^2*theta + e^2 + e*b + e*a*p",
             "a_deformation": "e*a*p", "a_zero_limit": "p^2*theta + e^2 + e*b"},
            {"branch": 3, "condition": "delta=p, theta=1 (w in GF(2))",
             "forced_h0": "e^2*a^2 + e*a^2*p + e*a*p + e^2 + e*b + e*p",
             "a_deformation": "a^2*e*(e+p) + a*e*p", "a_zero_limit": "e*(e+b+p)"},
        ],
        "h1_free_on_every_branch": True,
        "forced_h0_derived": "yes -- exact division B0f/A0 on each branch, not a guessed value",
        "a_zero_recovery": "each forced h0 reduces to the closed a=0 branch value at a=0",
        "conclusion":
            "the a!=0 D_AS has the three a=0 branches, a-deformed: e=0 (h0=0), e=delta, and "
            "delta=p/theta=1, each verified to satisfy all three residue conditions with an "
            "explicit forced h0; h1 is free throughout.",
        "does_not_prove": [
            "completeness: that branches 1-3 are ALL of D_AS off delta*p*N*K1*K2=0 "
            "(the cross-determinant variety strictly contains them; the extra locus must be shown "
            "spurious or excluded -- next sub-task; minAssGTZ is unreliable here per the a=0 report)",
            "whether any branch is collision-free (arc-legal) via the second-layer Tr(A/(bQ)^2)=0 test",
            "the reconstruction-split locus H=J=0 on a!=0",
            "the b=0,a!=0 degenerate stratum (psi=tau^2 inseparable)",
            "the classical AS-reduction and Lang-Weil theory (trusted)",
        ],
        "certificate_boundary":
            "Singular reduce/std/coeffs/diff/subst/division over GF(2)(e,delta,a,b,p,w,h0,h1); "
            "each branch verified by substitution, each forced h0 by exact polynomial division",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
