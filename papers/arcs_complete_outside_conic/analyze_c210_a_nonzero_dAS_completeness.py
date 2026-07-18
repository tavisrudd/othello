#!/usr/bin/env python3
"""C210: odd-degree arithmetic completeness of the a!=0 D_AS branches.

Let ``c_i=h0*A_i+B_i`` be the three stripped ``G2a`` residue conditions.
Their h0-cross-determinants have the certified forms

    E01=e*(e+delta)*N*delta^4*p^7*R01^2,
    E12=e*(e+delta)*N*delta^4*p^7*R12^2,
    E02=e*(e+delta)*delta^2*p^6*P02,

where ``N=a^2+a+1`` and the residuals are homogeneous in ``(delta,p)``.
This checker proves that, over every finite field of odd degree, the only
solutions off ``delta*p*N=0`` are the three known branches, with their stated
forced h0 values.

The key exact certificates use the lossless ``p=1`` chart, ``d=delta/p``.  If
``I=(R01,R12,P02)``, Singular verifies

    (N*theta*(d+1))^6, (N*theta*w*(w+1))^6 in I,

where ``theta=w^2+w+1``.  Neither N nor theta has a zero in an odd-degree
extension of GF(2), so an off-branch-1/2 solution has ``d=1`` and
``w in {0,1}``, hence lies on branch 3.

The checker also closes the h0-free loophole.  On branches 1 and 2 the three
coefficients A_i specialize to the same vector, and in the p=1 chart its ideal
contains ``(d*N*theta)^7``.  Thus at least one A_i is nonzero.  On branch 3,
``A_0=p^14*N^5`` for both w=0 and w=1.  Direct sparse-polynomial substitution
then verifies every stated branch height in all three c_i.
"""

from __future__ import annotations

import json
import shutil
import subprocess

from analyze_c210_a_nonzero_dAS_census import (
    A,
    DELTA,
    E,
    H0,
    P,
    W,
    residual_pairs,
    residue_conditions,
)
from analyze_c210_a_zero_artin_schreier_divisor import h0_split
from analyze_c210_a_zero_factorization_strata import TVARS


RESIDUAL_TERMS = {"R01": 52, "R12": 24, "P02": 202}
RESIDUAL_WEIGHTS = {"R01": 8, "R12": 7, "P02": 18}
HEIGHT_WEIGHTS = (14, 13, 12)


def substitute(ring, poly, replacements):
    """Simultaneously substitute sparse GF(2) polynomials for variables."""
    variables = [ring.v[name] for name in TVARS]
    out = ring.zero
    for monomial in poly:
        term = ring.one
        for index, exponent in enumerate(monomial):
            if exponent:
                term = ring.mul(
                    term, ring.power(replacements.get(index, variables[index]), exponent)
                )
        out = ring.add(out, term)
    return out


def p_one_chart(poly, weight: int):
    """Set p=1 after checking (delta,p)-homogeneity of the given weight."""
    assert {monomial[DELTA] + monomial[P] for monomial in poly} == {weight}
    out = set()
    for monomial in poly:
        reduced = list(monomial)
        reduced[P] = 0
        reduced = tuple(reduced)
        out ^= {reduced}
    return out


def sform(poly, allowed):
    """Format a sparse polynomial in a declared subset of TVARS."""
    allowed_indices = {index for index, _ in allowed}
    terms = []
    for monomial in sorted(poly, reverse=True):
        assert all(
            exponent == 0
            for index, exponent in enumerate(monomial)
            if index not in allowed_indices
        )
        factors = []
        for index, name in allowed:
            exponent = monomial[index]
            if exponent:
                factors.append(name if exponent == 1 else f"{name}^{exponent}")
        terms.append("*".join(factors) or "1")
    return "+".join(terms) or "0"


def singular_certificate(residuals, height_coefficients) -> dict[str, int]:
    allowed = ((A, "a"), (DELTA, "d"), (W, "w"))
    lines = [
        "ring r=2,(a,d,w),dp;",
        "poly N=a^2+a+1;",
        "poly theta=w^2+w+1;",
        f"poly R01={sform(residuals['R01'], allowed)};",
        f"poly R12={sform(residuals['R12'], allowed)};",
        f"poly P02={sform(residuals['P02'], allowed)};",
        "ideal IR=std(ideal(R01,R12,P02));",
        "if(reduce((N*theta*(d+1))^6,IR)!=0){exit(1);}",
        "if(reduce((N*theta*w*(w+1))^6,IR)!=0){exit(2);}",
        f"poly A0={sform(height_coefficients[0], allowed)};",
        f"poly A1={sform(height_coefficients[1], allowed)};",
        f"poly A2={sform(height_coefficients[2], allowed)};",
        "ideal IA=std(ideal(A0,A1,A2));",
        "if(reduce((d*N*theta)^7,IA)!=0){exit(3);}",
        'print("a-nonzero dAS arithmetic-completeness certificate passes");',
        "size(IR);",
        "size(IA);",
    ]
    singular = shutil.which("Singular")
    command = (
        [singular, "-q"]
        if singular
        else ["nix", "shell", "nixpkgs#singular", "--command", "Singular", "-q"]
    )
    completed = subprocess.run(
        command, input="\n".join(lines), text=True, capture_output=True, check=True
    )
    assert completed.stderr == "", completed.stderr
    output = completed.stdout.strip().splitlines()
    assert output == [
        "a-nonzero dAS arithmetic-completeness certificate passes",
        "22",
        "40",
    ], output
    return {"residual_ideal_groebner_size": 22, "height_ideal_groebner_size": 40}


def main() -> None:
    ring, conditions = residue_conditions()
    splits = [h0_split(ring, condition) for condition in conditions]
    coefficients = [alpha for alpha, _ in splits]
    residuals = residual_pairs(ring, conditions)

    assert {name: len(poly) for name, poly in residuals.items()} == RESIDUAL_TERMS
    residual_charts = {
        name: p_one_chart(poly, RESIDUAL_WEIGHTS[name])
        for name, poly in residuals.items()
    }

    zero = ring.zero
    one = ring.one
    v = ring.v
    theta = ring.add(ring.power(v["w"], 2), v["w"], one)
    norm = ring.add(ring.power(v["a"], 2), v["a"], one)
    h2 = ring.add(
        ring.mul(ring.power(v["p"], 2), theta),
        ring.power(v["delta"], 2),
        ring.mul(v["delta"], v["b"]),
        ring.product((v["delta"], v["a"], v["p"])),
    )
    h3 = ring.add(
        ring.product((ring.power(v["e"], 2), ring.power(v["a"], 2))),
        ring.product((v["e"], ring.power(v["a"], 2), v["p"])),
        ring.product((v["e"], v["a"], v["p"])),
        ring.power(v["e"], 2),
        ring.mul(v["e"], v["b"]),
        ring.mul(v["e"], v["p"]),
    )

    # Direct membership of all three stated branch heights.
    for condition in conditions:
        assert substitute(ring, condition, {E: zero, H0: zero}) == zero
        assert substitute(
            ring, condition, {E: v["delta"], H0: h2}
        ) == zero
        for w_value in (zero, one):
            assert substitute(
                ring, condition, {DELTA: v["p"], W: w_value, H0: h3}
            ) == zero

    # Branches 1 and 2 have the same h0-coefficient vector.  Its normalized
    # ideal contains (d*N*theta)^7, so it is not the all-A-zero vector on an
    # odd-degree field off delta*p*N=0.
    coefficients_e0 = [substitute(ring, alpha, {E: zero}) for alpha in coefficients]
    coefficients_ed = [substitute(ring, alpha, {E: v["delta"]}) for alpha in coefficients]
    assert coefficients_e0 == coefficients_ed
    height_charts = [
        p_one_chart(poly, weight)
        for poly, weight in zip(coefficients_e0, HEIGHT_WEIGHTS, strict=True)
    ]

    # On branch 3 A0 itself is nonzero: exactly p^14*N^5 for w=0 and w=1.
    branch3_coefficient = ring.mul(ring.power(v["p"], 14), ring.power(norm, 5))
    for w_value in (zero, one):
        assert substitute(
            ring, coefficients[0], {DELTA: v["p"], W: w_value}
        ) == branch3_coefficient

    sizes = singular_certificate(residual_charts, height_charts)

    print(json.dumps({
        "context": {
            "task": "C210 odd-degree arithmetic completeness of the a!=0 D_AS branches",
            "scope": "finite fields GF(2^n), n odd; a*delta*N*b*p != 0",
            "source": "three stripped h0-linear G2a residue conditions rebuilt from the universal resultant",
        },
        "projection_certificate": {
            "p_one_chart": "d=delta/p; lossless because p!=0 and all residuals are (delta,p)-homogeneous",
            "residual_terms": RESIDUAL_TERMS,
            "residual_weights": RESIDUAL_WEIGHTS,
            "ideal_memberships": [
                "(N*theta*(d+1))^6 in (R01,R12,P02)",
                "(N*theta*w*(w+1))^6 in (R01,R12,P02)",
            ],
            **sizes,
        },
        "height_certificate": {
            "branches_1_2": "same (A0,A1,A2); (d*N*theta)^7 lies in their p=1 coefficient ideal",
            "branch_3": "A0=p^14*N^5 for both w=0 and w=1",
            "direct_branch_substitutions": 3 * 4,
            "forced_h0": {
                "branch_1": "0",
                "branch_2": "p^2*theta+e^2+e*b+e*a*p (with e=delta)",
                "branch_3": "e^2*a^2+e*a^2*p+e*a*p+e^2+e*b+e*p",
            },
        },
        "field_argument": "N=a^2+a+1 and theta=w^2+w+1 have roots only over even-degree extensions; in odd degree they are nonzero, so the projection memberships force d=1 and w in GF(2)",
        "conclusion": "off delta*p*N=0, the full residue system over every odd-degree finite field is exactly the union of branches 1-3 with the displayed forced h0; h1 remains free",
        "independent_cross_check": "the committed exhaustive GF(8) and lossless GF(512) censuses found exactly the same three-branch union and no all-A base",
        "trusted_boundary": "pure-Python sparse GF(2) reconstruction/substitution and Singular std/reduce ideal-membership checks over GF(2)[a,d,w]",
        "does_not_prove": [
            "collision-freeness (the separate second-layer and genuineness packets prove the opposite on every known branch)",
            "the global off-divisor H=J=0 obstruction or the final bounded-mechanism theorem",
        ],
    }, sort_keys=True))


if __name__ == "__main__":
    main()
