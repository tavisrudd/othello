#!/usr/bin/env python3
"""Reduce the ``a!=0`` (t-degree-four) stratum of the C210 trace-one cover to a
single Artin--Schreier form.

The trace-one pullback of the committed seed--cross-repair resultant is, on the
generic ``a!=0`` stratum, a plane curve of ``t``-degree four with a perfect-square
leading coefficient and no cubic term:

    R = a^2*Q^2 * t^4 + B2 * t^2 + B1 * t + B0,   Q = u^2 + u*delta + delta^2.

Depressing by ``t = tau/(a*Q)`` (i.e. multiplying by ``a^2*Q^2``) makes it monic:

    F(tau) = tau^4 + P*tau^2 + Q1*tau + R1,
             P  = B2,   Q1 = a*Q*B1,   R1 = a^2*Q^2*B0.

Because ``F(a*Q*t) = a^2*Q^2*R`` and ``a*Q != 0`` on the stratum, ``R`` is
reducible over ``K = GF(2)-bar(params)(u)`` iff ``F`` is.  This checker proves,
in exact GF(2) arithmetic rebuilt from the committed universal resultant (no
re-transcription of coefficients), the following structure.

1.  **Skeleton factorization.** With ``theta = w^2+w+1``, ``N = a^2+a+1``,
    ``G1 = u^2+u*p+p^2*theta`` (the same ``G1`` as the a=0 conic),
    ``G2 = u^3+u^2*delta+u*p^2*theta+delta*p^2*theta+delta^2*p`` and its
    a-deformation ``G2a = G2 + delta*a*G1``,

        B1 = delta * N * b * G1 * G2a,      B2 = b^2*Q^2 + a*delta*N*G1*G2a.

    The second identity is the vanishing of ``E = b^2*Q^2 + B2 + a*delta*N*G1*G2a``.

2.  **Resolvent always splits off ``bQ``.** The char-2 (2,2)-resolvent of ``F``
    is ``X^3 + P*X + Q1``.  Identity 1 gives, exactly and for all parameters,

        X^3 + P*X + Q1 = (X + b*Q) * (X^2 + b*Q*X + sigma),
        sigma := a*delta*N*G1*G2a = B2 + b^2*Q^2.

    So the resolvent has the rational root ``X = b*Q`` on the whole stratum
    (``N=a^2+a+1=0`` needs ``a`` in ``GF(4)``: no points over ``GF(8^m)``, odd
    ``m``, so the forcing ``phi=b*Q`` is arithmetically valid there).

3.  **Artin--Schreier form.** Feeding the shared slope ``b*Q`` back collapses the
    quartic to a quadratic in ``psi = tau^2 + b*Q*tau``:

        F(tau) = psi^2 + sigma*psi + R1.

    This is verified here by direct expansion in a ``tau``-ring, not only by the
    coefficient identities ``b^2*Q^2+sigma = B2`` and ``sigma*b*Q = Q1``.

4.  **One factorization divisor** (on ``a*delta*N*b != 0``). As a quadratic in
    ``psi``, ``F`` factors over ``K`` via slope ``bQ`` iff the Artin--Schreier
    class ``R1/sigma^2`` is trivial in ``K/{g^2+g}``.  The two other factorization
    modes both collapse into this one divisor: a linear factor ``tau+phi`` forces
    its slope-partner ``tau+phi+bQ`` (same resolvent slope ``bQ``), so
    ``beta = phi^2+bQ*phi`` lies in ``K`` and the split is the ``bQ`` one; and the
    alternate slope ``s'`` (root of ``X^2+bQ*X+sigma``) is excluded from ``K``
    because ``sigma/(bQ)^2`` has polynomial part of degree
    ``deg(sigma)-deg(bQ)^2 = 5-4 = 1`` (odd), while every ``g^2+g`` has a constant
    or even-degree polynomial part -- so ``s' in K`` would need
    ``a*delta*N*b = 0``.  Hence the a!=0 factorization locus is the single
    Artin--Schreier divisor ``D_AS = { R1/sigma^2 in AS-image }``,
    ``sigma = a*delta*N*G1*G2a``, ``R1 = a^2*Q^2*B0``.

Off ``D_AS`` the cover is absolutely irreducible, so Lang--Weil forces collisions
once the a!=0 reconstruction-split locus ``H=J=0`` is shown empty (a step-2
deliverable, proven only on a=0 so far).  This mirrors the closed a=0 conic
(there in ``t``; here in ``psi = tau^2+bQ*tau``).

What this does NOT prove (next: step 2): the explicit branch equations of
``D_AS`` from the AS-residues of ``R1/sigma^2`` at the roots of ``G1`` and
``G2a`` (where the height parameters ``e,h0,h1`` enter through ``R1``); whether
any branch is collision-free (arc-legal) rather than collision-forcing; the
reconstruction-split locus ``H=J=0`` on a!=0 (needed for the off-``D_AS``
collisions); the ``b=0,a!=0`` degenerate stratum (``psi=tau^2`` inseparable,
``Q1=0``), which the a=b=0 gate does not own; and the classical AS-reduction /
Lang--Weil theory (trusted).
"""

from __future__ import annotations

import json
import shutil
import subprocess

from analyze_c210_a_zero_factorization_strata import (
    TVARS,
    t_coefficient,
    trace_one_pullback,
)


def u_leading(poly):
    """(u-degree, leading u-coefficient set) of a TVARS polynomial."""
    ui = TVARS.index("u")
    deg = max((m[ui] for m in poly), default=-1)
    lead = set()
    for m in poly:
        if m[ui] == deg:
            mm = list(m)
            mm[ui] = 0
            t = tuple(mm)
            if t in lead:
                lead.discard(t)
            else:
                lead.add(t)
    return deg, frozenset(lead)


def build(ring):
    """Common subexpressions in the trace-one target ring."""
    v = ring.v

    def A(*x):
        return ring.add(*x)

    def M(*x):
        return ring.product(x)

    def P(x, n):
        return ring.power(x, n)

    theta = A(P(v["w"], 2), v["w"], ring.one)
    Q = A(P(v["u"], 2), M(v["u"], v["delta"]), P(v["delta"], 2))
    N = A(P(v["a"], 2), v["a"], ring.one)
    G1 = A(P(v["u"], 2), M(v["u"], v["p"]), M(P(v["p"], 2), theta))
    G2 = A(
        P(v["u"], 3),
        M(P(v["u"], 2), v["delta"]),
        M(v["u"], P(v["p"], 2), theta),
        M(v["delta"], P(v["p"], 2), theta),
        M(P(v["delta"], 2), v["p"]),
    )
    G2a = A(G2, M(v["delta"], v["a"], G1))
    sigma = M(v["a"], v["delta"], N, G1, G2a)
    return {"theta": theta, "Q": Q, "N": N, "G1": G1, "G2": G2, "G2a": G2a,
            "sigma": sigma}


# --- a small exact GF(2) ring carrying an extra tau variable ---------------

TAU_VARS = ("tau", "u", "e", "delta", "a", "b", "p", "w", "h0", "h1")
_TI = {n: i for i, n in enumerate(TAU_VARS)}


def _tvar(name):
    e = [0] * len(TAU_VARS)
    e[_TI[name]] = 1
    return frozenset({tuple(e)})


_TONE = frozenset({tuple([0] * len(TAU_VARS))})


def _tadd(*ps):
    out: set = set()
    for p in ps:
        out ^= set(p)
    return frozenset(out)


def _tmul(x, y):
    out: set = set()
    for a in x:
        for b in y:
            t = tuple(i + j for i, j in zip(a, b))
            if t in out:
                out.discard(t)
            else:
                out.add(t)
    return frozenset(out)


def _tpow(x, n):
    o = _TONE
    while n:
        if n & 1:
            o = _tmul(o, x)
        x = _tmul(x, x)
        n >>= 1
    return o


def _embed(poly):
    """Embed a TVARS polynomial (no t) into the tau-ring (t-slot dropped)."""
    out: set = set()
    for m in poly:
        e = [0] * len(TAU_VARS)
        for i, name in enumerate(TVARS):
            if m[i]:
                if name == "t":
                    raise ValueError("unexpected t")
                e[_TI[name]] += m[i]
        t = tuple(e)
        if t in out:
            out.discard(t)
        else:
            out.add(t)
    return frozenset(out)


def verify_psi_form(B2, B1, B0, parts) -> None:
    """Directly expand F and psi^2+sigma*psi+R1 in the tau-ring; assert equal."""
    Q = _embed(parts["Q"])
    sigma = _embed(parts["sigma"])
    b2 = _embed(B2)
    b1 = _embed(B1)
    b0 = _embed(B0)
    a = _tvar("a")
    b = _tvar("b")
    tau = _tvar("tau")

    Q1 = _tmul(_tmul(a, Q), b1)          # a*Q*B1
    R1 = _tmul(_tmul(_tpow(a, 2), _tpow(Q, 2)), b0)  # a^2*Q^2*B0
    F = _tadd(_tpow(tau, 4), _tmul(b2, _tpow(tau, 2)), _tmul(Q1, tau), R1)

    psi = _tadd(_tpow(tau, 2), _tmul(_tmul(b, Q), tau))  # tau^2 + b*Q*tau
    rhs = _tadd(_tpow(psi, 2), _tmul(sigma, psi), R1)
    assert F == rhs, "psi-form identity F = psi^2 + sigma*psi + R1 failed"


def singular_g2a_irreducible(parts, ring) -> bool | None:
    """Small, single-polynomial check that G2a is irreducible over GF(2)(params).

    Returns True/False, or None when Singular is unavailable.  Kept to one light
    factorize call (no Groebner / elimination)."""
    def sform(poly):
        terms = []
        names = ("u", "delta", "a", "p", "w")  # G2a support
        idx = {n: TVARS.index(n) for n in names}
        for m in poly:
            fac = []
            for n in names:
                e = m[idx[n]]
                if e:
                    fac.append(n if e == 1 else f"{n}^{e}")
            terms.append("*".join(fac) or "1")
        return "+".join(terms) or "0"

    singular = shutil.which("Singular")
    if singular is None and shutil.which("nix") is None:
        return None
    command = ([singular, "-q"] if singular else
               ["nix", "shell", "nixpkgs#singular", "--command", "Singular", "-q"])
    src = "\n".join((
        "ring r=2,(u,delta,a,p,w),dp;",
        f"poly G2a={sform(parts['G2a'])};",
        "list f=factorize(G2a);",
        "print(size(f[1]));",
        "print(f[2][2]);",
    ))
    try:
        done = subprocess.run(command, input=src, text=True,
                              capture_output=True, check=True, timeout=300)
    except (subprocess.SubprocessError, OSError):
        return None
    if done.stderr.strip():
        return None
    try:
        size, exponent = map(int, done.stdout.split())
    except ValueError:
        return None
    return size == 2 and exponent == 1  # unit + single factor, multiplicity 1


def main() -> None:
    ring, cover = trace_one_pullback()
    v = ring.v
    t_index = TVARS.index("t")
    assert max(m[t_index] for m in cover) == 4
    assert t_coefficient(cover, 3) == set()

    parts = build(ring)
    Q, N, G1, G2a, sigma = (parts[k] for k in ("Q", "N", "G1", "G2a", "sigma"))

    B4 = t_coefficient(cover, 4)
    B2 = t_coefficient(cover, 2)
    B1 = t_coefficient(cover, 1)
    B0 = t_coefficient(cover, 0)

    def A(*x):
        return ring.add(*x)

    def Mu(*x):
        return ring.product(x)

    def Pw(x, n):
        return ring.power(x, n)

    # 0. leading square.
    assert B4 == Mu(Pw(v["a"], 2), Pw(Q, 2))

    # 1. skeleton factorization.
    assert B1 == Mu(v["delta"], N, v["b"], G1, G2a)
    E = A(Mu(Pw(v["b"], 2), Pw(Q, 2)), B2, sigma)
    assert E == set(), "E = b^2*Q^2 + B2 + a*delta*N*G1*G2a is not identically 0"
    assert B2 == A(Mu(Pw(v["b"], 2), Pw(Q, 2)), sigma)

    # 2. resolvent factors off b*Q; equivalently sigma = B2 + b^2*Q^2 (above)
    #    and the tau^1 coefficient identity Q1 = sigma*b*Q.
    Q1 = Mu(v["a"], Q, B1)
    assert Q1 == Mu(sigma, v["b"], Q)

    # 2b. Alternate-slope exclusion (completes the "one divisor" uniqueness claim).
    #     The other two resolvent roots solve X^2+bQ*X+sigma=0, i.e. the alternate
    #     (2,2)-slope s' is in K iff sigma/(bQ)^2 is in the AS image ℘(K)={g^2+g}.
    #     Any ℘(K) element has polynomial part g_poly^2+g_poly of even degree (or a
    #     constant); the polynomial part of sigma/(bQ)^2 has degree deg(sigma)-deg(bQ)^2.
    #     deg_u sigma = 5 (leading a*delta*N), deg_u (bQ)^2 = 4 (leading b^2): the
    #     polynomial part is degree 1 (odd, leading a*delta*N/b^2), so s' is never in
    #     K when a*delta*N*b != 0.  Hence only the bQ-slope (2,2)-split is over K, and
    #     the factorization locus is the single divisor D_AS.  (b=0 excluded: there
    #     psi=tau^2 is inseparable -- a separate degenerate stratum, see docstring.)
    sigma_deg, sigma_lead = u_leading(sigma)
    bq2_deg, bq2_lead = u_leading(Mu(Pw(v["b"], 2), Pw(Q, 2)))
    assert sigma_deg == 5 and bq2_deg == 4
    assert (sigma_deg - bq2_deg) % 2 == 1                      # odd polynomial part
    assert sigma_lead == Mu(v["a"], v["delta"], N)            # leading a*delta*N
    assert bq2_lead == Pw(v["b"], 2)

    # 3. full psi-form identity by direct tau-expansion.
    verify_psi_form(B2, B1, B0, parts)

    # 4. supporting pole-count fact: G2a irreducible (single light Singular call).
    g2a_irr = singular_g2a_irreducible(parts, ring)

    print(json.dumps({
        "cover": {
            "variables": "(u,t) over GF(2)[e,delta,a,b,p,w,h0,h1]",
            "source": "trace-one pullback of the committed seed--cross-repair resultant",
            "t_degree": 4,
            "leading_t4_coefficient": "a^2*Q^2   (Q=u^2+u*delta+delta^2)",
            "t3_coefficient": 0,
            "depressed_monic": "F(tau)=tau^4+B2*tau^2+a*Q*B1*tau+a^2*Q^2*B0, tau=a*Q*t",
        },
        "skeleton": {
            "B1": "delta*N*b*G1*G2a   (N=a^2+a+1)",
            "G1": "u^2+u*p+p^2*theta   (theta=w^2+w+1; same as a=0)",
            "G2": "u^3+u^2*delta+u*p^2*theta+delta*p^2*theta+delta^2*p",
            "G2a": "G2+delta*a*G1",
            "G2a_irreducible_over_GF2_params":
                g2a_irr if g2a_irr is not None else "unchecked (Singular unavailable)",
            "B2": "b^2*Q^2 + sigma",
            "sigma": "a*delta*N*G1*G2a",
            "E_identity": "b^2*Q^2 + B2 + a*delta*N*G1*G2a == 0",
        },
        "resolvent": {
            "cubic": "X^3 + B2*X + a*Q*B1",
            "factorization": "(X + b*Q)*(X^2 + b*Q*X + sigma)",
            "rational_root": "X = b*Q on the whole a!=0 stratum",
            "N_zero_locus": "a^2+a+1=0 needs a in GF(4): no points over GF(8^m), odd m",
        },
        "artin_schreier_form": {
            "identity": "F(tau) = psi^2 + sigma*psi + R1",
            "psi": "tau^2 + b*Q*tau",
            "sigma": "a*delta*N*G1*G2a",
            "R1": "a^2*Q^2*B0",
            "verified_by": "direct expansion in a tau-ring (not only coefficient matching)",
        },
        "factorization_divisor": {
            "D_AS": "{ R1/sigma^2 in the Artin-Schreier image of K=GF(2)-bar(params)(u) }",
            "uniqueness":
                "complete on a*delta*N*b!=0: (i) a linear factor tau+phi forces slope-partner "
                "tau+phi+bQ, so beta=phi^2+bQ*phi in K and the (2,2) split is the bQ one; "
                "(ii) the alternate slope s' (root of X^2+bQ*X+sigma) is excluded because "
                "sigma/(bQ)^2 has odd (degree-1) polynomial part, never in ℘(K). So the only "
                "(2,2)-over-K is the bQ-slope, governed by R1/sigma^2 = D_AS",
            "off_divisor":
                "F absolutely irreducible; collisions then follow by Lang-Weil ONCE the a!=0 "
                "reconstruction-split locus H=J=0 is shown empty (step-2 deliverable, not yet proven)",
            "b_zero_caveat":
                "b=0,a!=0 is a separate degenerate stratum (psi=tau^2 inseparable, Q1=0); "
                "not covered here and unowned by the a=b=0 gate -- see does_not_prove",
        },
        "does_not_prove": [
            "explicit branch equations of D_AS (AS-residues of R1/sigma^2 at G1,G2a roots)",
            "whether any D_AS branch is collision-free (arc-legal) rather than collision-forcing",
            "the reconstruction-split locus H=J=0 on a!=0 (needed for the off-D_AS collisions)",
            "the b=0,a!=0 degenerate stratum (psi=tau^2 inseparable)",
            "the classical Artin-Schreier reduction and Lang-Weil theory (trusted)",
        ],
        "field_conventions": "GF(2) symbolic; theta,N irreducible; GF(4)-splitting of Q,G1",
        "certificate_boundary":
            "exact GF(2) set arithmetic in Python (identities, tau-expansion); "
            "one light Singular factorize for G2a irreducibility",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
