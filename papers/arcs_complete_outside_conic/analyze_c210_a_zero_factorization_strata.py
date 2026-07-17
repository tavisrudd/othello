#!/usr/bin/env python3
"""Reduce the ``a=0,b!=0`` factorization stratum of the C210 trace-one cover.

The committed seed--cross-repair collision resultant ``R`` (in
``analyze_c210_seed_cross_repair_curve``) pulled back to the two-repair
trace-one parametrization

    N = a^2+a+1,  L = delta*b+delta^2,  T0 = p^2*(w^2+w+1)+a*delta*p,
    k0 = T0+L,    k1 = delta*N*p+a*T0+L,   c0 = h0,  c1 = h1

is a plane curve in ``(u,t)`` over ``GF(2)[e,delta,a,b,p,w,h0,h1]``.  On ``a=0``
it is a conic in ``t``:

    R0 = A2*t^2 + A1*t + A0.

This checker builds ``R0`` from the committed resultant (no re-transcription of
the quadratic coefficients) and certifies, with Singular for the
irreducibility/coprimality claims, that

    A2 = b^2 * Q^2,             Q  = u^2 + u*delta + delta^2      (a perfect square)
    A1 = delta * b * G1 * G2,   G1 = u^2 + u*p + p^2*theta,       theta = w^2+w+1
                                G2 = u^3 + u^2*delta + u*p^2*theta
                                     + delta*p^2*theta + delta^2*p
    A0 irreducible of u-degree 6
    gcd(A2,A1) = b,   gcd(A2,A0) = gcd(A1,A0) = 1

with ``G1,G2`` irreducible over ``GF(2)(params)``.

A conic-in-``t`` plane curve is reducible over ``GF(2)-bar(params)`` exactly when
(i) ``A2,A1,A0`` share a factor in ``u``, (ii) ``A1 == 0``, or (iii) the
Artin--Schreier class ``phi = A0*A2/A1^2`` is trivial in
``GF(2)-bar(params)(u)/{g^2+g}``.  The factorization above eliminates (i) and
(ii) on the generic ``a=0,b!=0,delta!=0`` stratum: ``A1 == 0`` forces
``delta*b = 0`` because ``G1,G2`` are monic in ``u`` (``delta=e'+e!=0`` and
``b!=0`` excluded, ``b=0`` being the already-closed ``a=b=0`` stratum), and the
gcds show no common ``u``-factor.  Hence the whole stratum reduces to the single
Artin--Schreier divisor (iii), ``D3``.

What this does NOT prove: the explicit equations of ``D3``, its intersection
with the reconstruction-split locus ``H=J=0``, or whether any component of
``D3`` is collision-free (arc-legal) rather than collision-forcing.  Two
boundary items are flagged for that next stage: the generic ``gcd=1`` does not
specialize, so a codimension->=1 sublocus where a root of ``Q`` meets ``G1*G2``
and ``A0`` can reintroduce a common ``u``-factor; and the pole analysis of
``phi`` runs over the ``GF(4)``-splitting of ``Q`` and ``G1`` and the absolutely
irreducible cubic ``G2``.
"""

from __future__ import annotations

import json
import shutil
import subprocess
from collections.abc import Iterable

from analyze_c210_seed_cross_repair_curve import (
    BinaryRing,
    NAMES,
    expected_quadratics,
    resultant,
)

TVARS = ("u", "t", "e", "delta", "a", "b", "p", "w", "h0", "h1")


class TargetRing:
    """Sparse GF(2) polynomial ring in the trace-one cover variables."""

    def __init__(self) -> None:
        self.zero: set[tuple[int, ...]] = set()
        self.one = {(0,) * len(TVARS)}
        self.v = {
            name: {tuple(int(i == j) for i in range(len(TVARS)))}
            for j, name in enumerate(TVARS)
        }

    @staticmethod
    def add(*values: set[tuple[int, ...]]) -> set[tuple[int, ...]]:
        out: set[tuple[int, ...]] = set()
        for value in values:
            out ^= value
        return out

    @staticmethod
    def mul(left, right):
        out: set[tuple[int, ...]] = set()
        for x in left:
            for y in right:
                out ^= {tuple(i + j for i, j in zip(x, y))}
        return out

    def product(self, values: Iterable) -> set[tuple[int, ...]]:
        out = self.one
        for value in values:
            out = self.mul(out, value)
        return out

    def power(self, value, exponent: int):
        out = self.one
        while exponent:
            if exponent & 1:
                out = self.mul(out, value)
            value = self.mul(value, value)
            exponent >>= 1
        return out


def trace_one_pullback() -> tuple[TargetRing, set[tuple[int, ...]]]:
    """Pull the committed universal resultant back to the trace-one cover."""
    ring0 = BinaryRing()
    universal = resultant(ring0, expected_quadratics(ring0))

    ring = TargetRing()
    v = ring.v
    theta = ring.add(ring.power(v["w"], 2), v["w"], ring.one)
    parametrized_N = ring.add(ring.power(v["a"], 2), v["a"], ring.one)
    parametrized_L = ring.add(ring.mul(v["delta"], v["b"]), ring.power(v["delta"], 2))
    parametrized_T0 = ring.add(
        ring.mul(ring.power(v["p"], 2), theta),
        ring.product((v["a"], v["delta"], v["p"])),
    )
    k0 = ring.add(parametrized_T0, parametrized_L)
    k1 = ring.add(
        ring.product((v["delta"], parametrized_N, v["p"])),
        ring.mul(v["a"], parametrized_T0),
        parametrized_L,
    )
    images = {
        "r": ring.zero, "s": ring.zero, "u": v["u"], "t": v["t"],
        "e": v["e"], "delta": v["delta"], "a": v["a"], "b": v["b"],
        "k0": k0, "k1": k1, "c0": v["h0"], "c1": v["h1"],
        "g0": ring.zero, "g1": ring.zero,
    }
    out = ring.zero
    for monomial in universal:
        factors = [
            ring.power(images[name], exponent)
            for name, exponent in zip(NAMES, monomial)
            if exponent
        ]
        out = ring.add(out, ring.product(factors))
    return ring, out


def t_coefficient(polynomial, degree: int):
    index = TVARS.index("t")
    out = set()
    for monomial in polynomial:
        if monomial[index] == degree:
            reduced = list(monomial)
            reduced[index] = 0
            out.add(tuple(reduced))
    return out


def restrict_zero(polynomial, name: str):
    index = TVARS.index(name)
    return {monomial for monomial in polynomial if monomial[index] == 0}


def singular_term(monomial) -> str:
    factors = []
    for index, name in enumerate(TVARS):
        if name == "t":
            continue
        if monomial[index]:
            factors.append(name if monomial[index] == 1 else f"{name}^{monomial[index]}")
    return "*".join(factors) or "1"


def singular_poly(polynomial) -> str:
    return "+".join(singular_term(m) for m in polynomial) or "0"


def singular_certificate(a2, a1, a0) -> None:
    """Assert the irreducibility and coprimality claims via Singular."""
    used = "u,e,delta,b,p,w,h0,h1"
    lines = [
        f"ring r=2,({used}),dp;",
        f"poly A2={singular_poly(a2)};",
        f"poly A1={singular_poly(a1)};",
        f"poly A0={singular_poly(a0)};",
        "poly Q=u^2+u*delta+delta^2;",
        "poly theta=w^2+w+1;",
        "poly G1=u^2+u*p+p^2*theta;",
        "poly G2=u^3+u^2*delta+u*p^2*theta+delta*p^2*theta+delta^2*p;",
        # perfect square and full factorization identities.
        "if(A2-b^2*Q^2!=0){exit(1);}",
        "if(A1-delta*b*G1*G2!=0){exit(2);}",
        # G1,G2,A0 irreducible over GF(2)(params): factorize returns unit+one.
        "list fG1=factorize(G1); if(size(fG1[1])!=2||fG1[2][2]!=1){exit(3);}",
        "list fG2=factorize(G2); if(size(fG2[1])!=2||fG2[2][2]!=1){exit(4);}",
        "list fA0=factorize(A0); if(size(fA0[1])!=2||fA0[2][2]!=1){exit(5);}",
        # coprimality across A2,A1,A0 (no common u-factor).
        "if(gcd(A2,A1)!=b){exit(6);}",
        "if(gcd(A2,A0)!=1){exit(7);}",
        "if(gcd(A1,A0)!=1){exit(8);}",
        # A1==0 forces delta*b==0 because G1,G2 are monic in u (leading coeff 1).
        "if(leadcoef(G1)!=1||leadcoef(G2)!=1){exit(9);}",
        'print("a-zero certificate passes");',
    ]
    singular = shutil.which("Singular")
    command = ([singular, "-q"] if singular else [
        "nix", "shell", "nixpkgs#singular", "--command", "Singular", "-q"
    ])
    completed = subprocess.run(
        command, input="\n".join(lines), text=True, capture_output=True, check=True
    )
    assert completed.stderr == "", completed.stderr
    assert completed.stdout.strip() == "a-zero certificate passes", completed.stdout


def main() -> None:
    ring, cover = trace_one_pullback()
    u_index, t_index, a_index, b_index = (TVARS.index(n) for n in ("u", "t", "a", "b"))

    # Generic cover shape (matches analyze_c210_collision_curve_degree_drop).
    assert max(m[t_index] for m in cover) == 4
    v = ring.v
    q_square = ring.power(ring.add(ring.power(v["u"], 2), ring.mul(v["u"], v["delta"]),
                                   ring.power(v["delta"], 2)), 2)
    assert t_coefficient(cover, 4) == ring.mul(ring.power(v["a"], 2), q_square)
    assert t_coefficient(cover, 3) == set()

    # a=0 conic in t.
    cover0 = restrict_zero(cover, "a")
    assert max(m[t_index] for m in cover0) == 2
    a2 = t_coefficient(cover0, 2)
    a1 = t_coefficient(cover0, 1)
    a0 = t_coefficient(cover0, 0)

    # Cheap exact identities in the Python ring (no Singular needed).
    assert a2 == ring.mul(ring.power(v["b"], 2), q_square)
    assert max(m[u_index] for m in a0) == 6
    assert max(m[b_index] for m in a2) == 2

    # Irreducibility + coprimality via Singular.
    singular_certificate(a2, a1, a0)

    print(json.dumps({
        "cover": {
            "variables": "(u,t) over GF(2)[e,delta,a,b,p,w,h0,h1]",
            "source": "trace-one pullback of the committed seed--cross-repair resultant",
            "generic_t_degree": 4,
            "generic_leading_t4_coefficient": "a^2*Q^2",
            "t3_coefficient": 0,
        },
        "a_zero_conic": {
            "t_degree": 2,
            "A2": "b^2*Q^2   (perfect square; Q=u^2+u*delta+delta^2)",
            "A1": "delta*b*G1*G2",
            "G1": "u^2+u*p+p^2*theta   (theta=w^2+w+1)",
            "G2": "u^3+u^2*delta+u*p^2*theta+delta*p^2*theta+delta^2*p",
            "A0": "irreducible over GF(2)(params), u-degree 6",
            "gcd_A2_A1": "b",
            "gcd_A2_A0": 1,
            "gcd_A1_A0": 1,
        },
        "reduction": {
            "mechanisms": [
                "common u-factor content", "A1==0", "Artin-Schreier phi=A0*A2/A1^2 in image",
            ],
            "common_u_factor": "absent generically (gcds above)",
            "A1_identically_zero": "forces delta*b=0 (G1,G2 monic in u); delta!=0 and b!=0 excluded",
            "conclusion": "a=0,b!=0 factorization reduces to the single Artin-Schreier divisor D3: phi in the Artin-Schreier image",
        },
        "does_not_prove": [
            "explicit equations of D3",
            "intersection of D3 with the reconstruction-split locus H=J=0",
            "whether any D3 component is collision-free rather than collision-forcing",
            "the codimension->=1 common-factor sublocus where a root of Q meets G1*G2 and A0 (gcd=1 does not specialize)",
        ],
        "field_conventions": "GF(2) symbolic; F(omega) with omega^2=omega+1; GF(4)-splitting of Q,G1; G2 absolutely irreducible",
        "certificate_boundary": "Singular factorize/gcd over GF(2)(params); trusted as the CAS",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
