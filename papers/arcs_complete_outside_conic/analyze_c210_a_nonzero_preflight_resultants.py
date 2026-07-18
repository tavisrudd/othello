#!/usr/bin/env python3
"""C210 step-2(a) preflight for the ``a!=0`` Artin--Schreier divisor ``D_AS``.

Before deriving the branch equations of

    D_AS = { R1/sigma^2 in the Artin--Schreier image of K=GF(2)-bar(params)(u) },
    R1 = a^2*Q^2*B0,   sigma = a*delta*N*G1*G2a,

so that ``R1/sigma^2 = Q^2*B0/(delta^2*N^2*G1^2*G2a^2)`` (``N=a^2+a+1`` is
``u``-constant, ``b`` cancels), the residue derivation needs three facts that the
a=0 case got cheaply but which are a-deformed here.  This checker computes all
three exactly, from the same cover build used by the step-1 reduction (no
re-transcription), and pins the two inherited/unchanged resultants as well.

1.  **Simple-root (discriminant) locus of ``G2a``.**  The reduced AS-residue
    formula at a root ``rho`` of ``G2a`` assumes ``rho`` is simple.  Here

        Res_u(G2a, G2a') = delta^4 * p^2 * N^2,      N = a^2+a+1,

    the clean a-deformation of the a=0 value ``Res_u(G2,G2') = delta^4*p^2``
    (``N=1`` at ``a=0``).  The only new ``a``-factor is ``N^2``, and ``N=0`` has
    no points over ``GF(8^m)``, odd ``m`` (``a`` in ``GF(4)``).  So ``G2a`` is
    separable off ``delta*p=0`` on the whole arithmetic stratum -- no genuinely
    new degeneracy locus is introduced by the deformation.

2.  **Shared-``Q``-root pole cancellation.**  A common root of ``Q`` and ``G2a``
    would cancel an order-two pole of ``R1/sigma^2`` (``Q^2`` up, ``G2a^2``
    down).  Exactly

        Res_u(Q, G2a) = delta^2 * N * K1 * K2,
        K1 = p^2*w^2 + delta*p*w + p^2*w + delta^2 + p^2,
        K2 = K1 + delta*p,

    with ``K1,K2`` the two ``GF(4)``-conjugate quadratics that are *also* the
    merged-pole factors below.  So a shared ``Q``/``G2a`` root occurs only on the
    merged-pole locus ``K1*K2=0`` (and ``delta=0``); off it the poles at the
    roots of ``G2a`` are genuine order two.

3.  **Merged-pole locus is inherited free.**  ``G2a = G2 + delta*a*G1`` agrees
    with ``G2`` at the roots of ``G1``, so

        Res_u(G1, G2a) = Res_u(G1, G2) = p^2 * K1 * K2      (identically),

    the same ``p^2*K1*K2`` as the a=0 conic.  ``Res_u(G1,G1') = p^2`` is
    unchanged (``G1`` carries no ``a``).  On ``K1*K2=0`` a root of ``G1`` meets a
    root of ``G2a``; as on a=0 this only *shrinks* ``D_AS`` (the two order-two
    poles merge), it does not add branches.

4.  **Infinity place is Artin--Schreier trivial.**  ``deg_u(Q^2*B0) = 10 =
    deg_u(G1^2*G2a^2)``, so ``R1/sigma^2`` is regular at ``u=infinity`` with value

        lead_u(B0)/(delta^2*N^2) = e*(e+delta)/delta^2 = (e/delta)^2 + (e/delta)

    (using ``lead_u(B0) = e*(e+delta)*N^2``).  That constant is ``℘(e/delta)``,
    already in the AS image, so the infinity place contributes nothing to
    ``D_AS``: the divisor is determined entirely by the finite residues at the
    roots of ``G1`` and ``G2a``.  This is the a!=0 analogue of the a=0
    "at most a constant polynomial part" fact, sharpened to exact triviality.

Together (1)-(4) certify that on the generic stratum
``delta*p*N*K1*K2 != 0`` the poles of ``R1/sigma^2`` are exactly order two at the
simple roots of ``G1*G2a`` and nothing at infinity -- the setup the step-2(b)
residue derivation (AS-residues of ``R1/sigma^2``) will consume.

What this does NOT do: derive the branch equations themselves (the ``G1`` and
``G2a`` residue conditions, where ``e,h0,h1`` become load-bearing); decide any
branch collision-forcing vs arc-legal; or touch ``H=J=0`` or the ``b=0,a!=0``
degenerate stratum.  See the report for the ownership of those.
"""

from __future__ import annotations

import json
import shutil
import subprocess

from analyze_c210_a_zero_factorization_strata import TVARS, t_coefficient, trace_one_pullback
from analyze_c210_a_nonzero_artin_schreier_form import build

UI = TVARS.index("u")

# The two GF(4)-conjugate merged-pole quadratics (K2 = K1 + delta*p).
K1_STR = "p^2*w^2+delta*p*w+p^2*w+delta^2+p^2"
K2_STR = "p^2*w^2+delta*p*w+p^2*w+delta^2+delta*p+p^2"


def sform(poly) -> str:
    """Serialize a TVARS polynomial (t-free) to a Singular expression."""
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


def udeg(poly) -> int:
    return max((m[UI] for m in poly), default=-1)


def u_lead(poly):
    """The u-leading coefficient of a TVARS polynomial as a t-free monomial set."""
    d = udeg(poly)
    out: set = set()
    for m in poly:
        if m[UI] == d:
            mm = list(m)
            mm[UI] = 0
            t = tuple(mm)
            out ^= {t}
    return frozenset(out)


def singular_certificate(parts) -> None:
    """Certify the five resultant identities and the two G2a relations."""
    G1, G2, G2a, Q = (sform(parts[k]) for k in ("G1", "G2", "G2a", "Q"))
    lines = [
        "ring r=2,(u,delta,a,p,w),dp;",
        f"poly Q={Q};",
        f"poly G1={G1};",
        f"poly G2={G2};",
        f"poly G2a={G2a};",
        "poly N=a^2+a+1;",
        f"poly K1={K1_STR};",
        f"poly K2={K2_STR};",
        # deformation relations.
        "if(G2a-(G2+delta*a*G1)!=0){exit(1);}",
        "if(reduce(G2a-G2,std(ideal(G1)))!=0){exit(2);}",  # G2a == G2 mod G1
        "if(K2-(K1+delta*p)!=0){exit(3);}",
        # (1) discriminant / simple-root locus of G2a.
        "if(resultant(G2a,diff(G2a,u),u)-delta^4*p^2*N^2!=0){exit(4);}",
        # (2) shared-Q-root pole cancellation.
        "if(resultant(Q,G2a,u)-delta^2*N*K1*K2!=0){exit(5);}",
        # (3) merged-pole locus inherited free, and equal to the a=0 value.
        "if(resultant(G1,G2a,u)-p^2*K1*K2!=0){exit(6);}",
        "if(resultant(G1,G2,u)-p^2*K1*K2!=0){exit(7);}",
        "if(resultant(G1,G2a,u)-resultant(G1,G2,u)!=0){exit(8);}",
        # unchanged G1 self-resultant.
        "if(resultant(G1,diff(G1,u),u)-p^2!=0){exit(9);}",
        # monic in u (leading coeff 1): residue formula is chart-safe at finite roots.
        "if(leadcoef(G1)!=1||leadcoef(G2a)!=1||leadcoef(Q)!=1){exit(10);}",
        'print("a-nonzero preflight certificate passes");',
    ]
    singular = shutil.which("Singular")
    command = ([singular, "-q"] if singular else
               ["nix", "shell", "nixpkgs#singular", "--command", "Singular", "-q"])
    completed = subprocess.run(
        command, input="\n".join(lines), text=True, capture_output=True, check=True
    )
    assert completed.stderr == "", completed.stderr
    assert completed.stdout.strip() == "a-nonzero preflight certificate passes", completed.stdout


def main() -> None:
    ring, cover = trace_one_pullback()
    v = ring.v
    parts = build(ring)
    Q, N, G1, G2a = (parts[k] for k in ("Q", "N", "G1", "G2a"))
    B0 = t_coefficient(cover, 0)

    def A(*x):
        return ring.add(*x)

    def Mu(*x):
        return ring.product(x)

    def Pw(x, n):
        return ring.power(x, n)

    # (4a) infinity-place degree balance: numerator vs denominator u-degree.
    num_deg = udeg(Pw(Q, 2)) + udeg(B0)          # deg_u(Q^2*B0)
    den_deg = udeg(Pw(G1, 2)) + udeg(Pw(G2a, 2))  # deg_u(G1^2*G2a^2)
    assert (num_deg, den_deg) == (10, 10), (num_deg, den_deg)

    # (4b) lead_u(B0) = e*(e+delta)*N^2, so the value at infinity is
    #      lead_u(B0)/(delta^2*N^2) = e*(e+delta)/delta^2 = (e/delta)^2+(e/delta),
    #      an exact Artin--Schreier image element (infinity AS-trivial).
    lead_B0 = u_lead(B0)
    assert lead_B0 == frozenset(Mu(v["e"], A(v["e"], v["delta"]), Pw(N, 2)))
    # Cross-multiplied AS-triviality of the infinity value with g = e/delta:
    #   lead_u(numerator) * delta^2 == lead_u(denominator) * (e^2 + e*delta),
    # where numerator = Q^2*B0 (lead_u = lead_u(B0), Q monic) and
    # denominator = delta^2*N^2*G1^2*G2a^2 (lead_u = delta^2*N^2, G1,G2a monic).
    lead_den = u_lead(Mu(Pw(v["delta"], 2), Pw(N, 2), Pw(G1, 2), Pw(G2a, 2)))
    assert lead_den == frozenset(Mu(Pw(v["delta"], 2), Pw(N, 2)))
    lhs = Mu(lead_B0, Pw(v["delta"], 2))
    rhs = Mu(lead_den, A(Pw(v["e"], 2), Mu(v["e"], v["delta"])))
    assert lhs == rhs, "infinity value is not (e/delta)^2+(e/delta)"

    # (1)-(3) resultant identities in Singular (exact, over GF(2)(delta,a,p,w)).
    singular_certificate(parts)

    print(json.dumps({
        "context": {
            "task": "C210 step-2(a) preflight for the a!=0 Artin-Schreier divisor D_AS",
            "AS_class": "R1/sigma^2 = Q^2*B0/(delta^2*N^2*G1^2*G2a^2)  (N=a^2+a+1, b cancels)",
            "source": "same cover build as the step-1 reduction (no re-transcription)",
        },
        "G2a_discriminant": {
            "Res_u_G2a_G2a_prime": "delta^4*p^2*N^2",
            "a_zero_specialization": "delta^4*p^2   (N=1 at a=0)",
            "new_degeneracy": "none beyond delta*p; the a-factor is N^2, and N=0 has no GF(8^m) points (odd m)",
            "consequence": "G2a is separable off delta*p=0 on the whole odd-tower stratum",
        },
        "shared_Q_root": {
            "Res_u_Q_G2a": "delta^2*N*K1*K2",
            "K1": K1_STR,
            "K2": "K1 + delta*p",
            "consequence": "Q shares a root with G2a only on the merged-pole locus K1*K2=0 (or delta=0)",
        },
        "merged_pole_inherited": {
            "Res_u_G1_G2a": "p^2*K1*K2",
            "equals_Res_u_G1_G2": True,
            "reason": "G2a=G2+delta*a*G1 agrees with G2 at the roots of G1 (G2a==G2 mod G1)",
            "Res_u_G1_G1_prime": "p^2   (unchanged; G1 carries no a)",
            "consequence": "merged-pole locus is the same p^2*K1*K2 as a=0; there it only shrinks D_AS",
        },
        "infinity_place": {
            "num_u_degree": num_deg,
            "den_u_degree": den_deg,
            "value_at_infinity": "e*(e+delta)/delta^2 = (e/delta)^2+(e/delta)",
            "lead_u_B0": "e*(e+delta)*N^2",
            "artin_schreier_trivial": True,
            "consequence": "infinity contributes nothing to D_AS; only the finite G1,G2a residues remain",
        },
        "conclusion":
            "on the generic stratum delta*p*N*K1*K2 != 0 the poles of R1/sigma^2 are exactly "
            "order two at the simple roots of G1*G2a and nothing at infinity -- the setup the "
            "step-2(b) residue derivation consumes",
        "does_not_prove": [
            "the branch equations of D_AS (G1 and G2a AS-residue conditions; e,h0,h1 load-bearing)",
            "whether any D_AS branch is collision-free (arc-legal) rather than collision-forcing",
            "the reconstruction-split locus H=J=0 on a!=0",
            "the b=0,a!=0 degenerate stratum (psi=tau^2 inseparable)",
        ],
        "certificate_boundary":
            "exact GF(2) set arithmetic in Python (degree/leading-coefficient identities); "
            "Singular resultant/reduce/std over GF(2)(delta,a,p,w) for the five resultant identities",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
