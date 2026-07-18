#!/usr/bin/env python3
"""C210 Packet 2: close the ``b=0,a!=0`` inseparable boundary.

The checker pulls the two universal collision quadratics, their resultant, and
the reconstruction polynomials ``H,J`` through the committed trace-one
parametrization.  It certifies the Frobenius-pulled cover, the uniform identity

    H = delta*(a^2+a+1)*G1,

and the exact non-coincidence factors on the two seed-coset branches.  The
companion report supplies the finite-field/Artin--Schreier point-count argument.
"""

from __future__ import annotations

import json
import shutil
import subprocess

from analyze_c210_a_nonzero_artin_schreier_form import build, u_leading
from analyze_c210_a_nonzero_dAS_census import add as gf8_add
from analyze_c210_a_nonzero_dAS_census import mul as gf8_mul
from analyze_c210_a_nonzero_dAS_census import square as gf8_square
from analyze_c210_a_nonzero_dAS_census import theta as gf8_theta
from analyze_c210_a_zero_factorization_strata import (
    TVARS,
    TargetRing,
    restrict_zero,
    t_coefficient,
    trace_one_pullback,
)
from analyze_c210_seed_cross_repair_curve import (
    BinaryRing,
    NAMES,
    expected_quadratics,
    resultant,
)


def trace_one_images(ring: TargetRing):
    v = ring.v
    theta = ring.add(ring.power(v["w"], 2), v["w"], ring.one)
    N = ring.add(ring.power(v["a"], 2), v["a"], ring.one)
    L = ring.add(ring.mul(v["delta"], v["b"]), ring.power(v["delta"], 2))
    T0 = ring.add(
        ring.mul(ring.power(v["p"], 2), theta),
        ring.product((v["a"], v["delta"], v["p"])),
    )
    k0 = ring.add(T0, L)
    k1 = ring.add(
        ring.product((v["delta"], N, v["p"])),
        ring.mul(v["a"], T0),
        L,
    )
    return {
        "r": ring.zero,
        "s": ring.zero,
        "u": v["u"],
        "t": v["t"],
        "e": v["e"],
        "delta": v["delta"],
        "a": v["a"],
        "b": v["b"],
        "k0": k0,
        "k1": k1,
        "c0": v["h0"],
        "c1": v["h1"],
        "g0": ring.zero,
        "g1": ring.zero,
    }


def pullback(poly, ring: TargetRing, images):
    out = ring.zero
    for monomial in poly:
        factors = [
            ring.power(images[name], exponent)
            for name, exponent in zip(NAMES, monomial)
            if exponent
        ]
        out = ring.add(out, ring.product(factors))
    return out


def pulled_quadratics():
    source = BinaryRing()
    target = TargetRing()
    images = trace_one_images(target)
    coefficients = tuple(
        pullback(poly, target, images) for poly in expected_quadratics(source)
    )
    return target, coefficients


def sform(poly) -> str:
    terms = []
    for monomial in poly:
        factors = []
        for i, name in enumerate(TVARS):
            exponent = monomial[i]
            if exponent:
                factors.append(name if exponent == 1 else f"{name}^{exponent}")
        terms.append("*".join(factors) or "1")
    return "+".join(terms) or "0"


def singular_certificate(cover_str: str, H_str: str, J_str: str) -> None:
    lines = [
        "ring r=2,(t,u,e,delta,a,b,p,w,h0,h1),(lp(2),dp);",
        "poly theta=w^2+w+1; poly N=a^2+a+1;",
        "poly Q=u^2+u*delta+delta^2;",
        "poly G1=u^2+u*p+p^2*theta;",
        "poly G2a=u^3+u^2*delta+u*p^2*theta+delta*p^2*theta"
        "+delta^2*p+delta*a*G1;",
        f"poly R={cover_str}; poly H={H_str}; poly J={J_str};",
        "if(H-delta*N*G1!=0){exit(1);}",
        "poly Rb=subst(R,b,0); poly Jb=subst(J,b,0);",
        "poly T1=a*t^2+h1;",
        "poly U1=Q^2*T1+delta*N*G1*G2a;",
        "poly branch1=subst(subst(Rb,e,0),h0,0);",
        "if(branch1-T1*U1!=0){exit(2);}",
        "poly rec1=subst(subst(Jb+t*H,e,0),h0,0);",
        "if(reduce(rec1,std(ideal(T1)))!=0){exit(3);}",
        "if(reduce(U1,std(ideal(T1)))-delta*N*G1*G2a!=0){exit(4);}",
        "poly h2=p^2*theta+delta^2+delta*a*p;",
        "poly L2=a*p^2*theta+delta*a*p+delta^2+delta*p+h1;",
        "poly T2=a*t^2+L2;",
        "poly U2=Q^2*T2+delta*N*G1*G2a;",
        "poly branch2=subst(subst(Rb,e,delta),h0,h2);",
        "if(branch2-T2*U2!=0){exit(5);}",
        "poly rec2=subst(subst(Jb+(t+u)*H,e,delta),h0,h2);",
        "if(reduce(rec2,std(ideal(T2)))!=0){exit(6);}",
        "if(reduce(U2,std(ideal(T2)))-delta*N*G1*G2a!=0){exit(7);}",
        'print("a-nonzero b-zero certificate passes");',
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
    assert completed.stdout.strip() == "a-nonzero b-zero certificate passes", (
        completed.stdout
    )


def gf8_root_checks() -> dict[str, int]:
    N_zeros = 0
    Q_zeros = 0
    G1_zeros = 0
    for a in range(8):
        N_zeros += gf8_add(gf8_square(a), a, 1) == 0
    for delta in range(1, 8):
        for u in range(8):
            Q_zeros += gf8_add(
                gf8_square(u), gf8_mul(u, delta), gf8_square(delta)
            ) == 0
    for p in range(1, 8):
        for w in range(8):
            for u in range(8):
                G1_zeros += gf8_add(
                    gf8_square(u),
                    gf8_mul(u, p),
                    gf8_mul(gf8_square(p), gf8_theta(w)),
                ) == 0
    assert N_zeros == Q_zeros == G1_zeros == 0
    return {
        "N_values_checked": 8,
        "Q_values_checked": 7 * 8,
        "G1_values_checked": 7 * 8 * 8,
        "zeros": 0,
    }


def main() -> None:
    ring, coefficients = pulled_quadratics()
    A, B, C, D, E, F = coefficients
    H = ring.add(ring.mul(D, B), ring.mul(A, E))
    J = ring.add(ring.mul(D, C), ring.mul(A, F))
    source = BinaryRing()
    universal_cover = resultant(source, expected_quadratics(source))
    cover = pullback(universal_cover, ring, trace_one_images(ring))
    _, committed_cover = trace_one_pullback()
    assert cover == committed_cover

    parts = build(ring)
    v = ring.v
    expected_H = ring.product((v["delta"], parts["N"], parts["G1"]))
    assert H == expected_H

    cover_b0 = restrict_zero(cover, "b")
    t_index = TVARS.index("t")
    assert all(monomial[t_index] % 2 == 0 for monomial in cover_b0)
    B4 = t_coefficient(cover_b0, 4)
    B2 = t_coefficient(cover_b0, 2)
    B0 = t_coefficient(cover_b0, 0)
    assert B4 == ring.product((ring.power(v["a"], 2), ring.power(parts["Q"], 2)))
    assert B2 == parts["sigma"]
    degree, leading = u_leading(B0)
    infinity_leading = ring.product(
        (
            v["e"],
            ring.add(v["e"], v["delta"]),
            ring.power(parts["N"], 2),
        )
    )
    assert degree == 6 and leading == infinity_leading

    singular_certificate(sform(cover), sform(H), sform(J))
    root_checks = gf8_root_checks()

    print(
        json.dumps(
            {
                "scope": "b=0, a*delta*N*p!=0 over GF(8^m), m odd",
                "cover": {
                    "form": "R=a^2*Q^2*t^4+sigma*t^2+B0",
                    "frobenius_coordinate": "y=(a*Q*t)^2",
                    "AS_curve": "z^2+z=phi, phi=Q^2*B0/(delta^2*N^2*G1^2*G2a^2)",
                    "infinity_value": "(e/delta)^2+e/delta",
                    "genus_bound": 4,
                    "deleted_point_bound": 7,
                    "point_threshold": "q+1-8*sqrt(q)>7; hence every odd-tower q>=512",
                },
                "reconstruction": {
                    "H": "delta*N*G1",
                    "odd_tower_verdict": "H never vanishes at a rational u",
                },
                "coincidence_branches": [
                    {
                        "branch": "e=0,h0=0",
                        "coincidence_factor": "T1=a*t^2+h1",
                        "genuine_factor": "Q^2*T1+delta*N*G1*G2a",
                    },
                    {
                        "branch": "e=delta,h0=p^2*theta+delta^2+delta*a*p",
                        "coincidence_factor": "T2=a*t^2+a*p^2*theta+delta*a*p+delta^2+delta*p+h1",
                        "genuine_factor": "Q^2*T2+delta*N*G1*G2a",
                    },
                ],
                "gf8_root_checks": root_checks,
                "conclusion": "the b=0,a!=0 boundary is collision-forcing for every odd-tower q>=512",
                "does_not_prove": [
                    "the q=8 boundary",
                    "second-layer classification for b!=0",
                    "arithmetic completeness of the three b!=0 residue branches",
                ],
                "trusted_boundary": "universal-resultant generator, exact GF(2) arithmetic, Singular substitution/reduction, and the report's Artin-Schreier/Hasse-Weil argument",
            },
            sort_keys=True,
        )
    )


if __name__ == "__main__":
    main()
