#!/usr/bin/env python3
"""Certify a universal reduced C210 coverage-ramification family.

For either seed colour put

    D=x+t,  W=D^2+q,  E=omega*D,  Y=y+t.

The two differential columns of the seed--repair chord map are

    Y*(W+bE),                 (D+Y)*W.

Over the algebraic closure choose source parameters satisfying

    W=sE,                     Y=lambda*D+mu*E.

At ``mu=0`` the coordinate Jacobian vanishes.  Its derivative transverse to
that locus is

    s*(s+b)*Norm(D)^2.

For ``e != 0``, only two values of ``d/e`` make ``Norm(D)=0`` after geometric
base change.  Choosing ``s != 0,b`` away from the corresponding at most two
additional values therefore gives a reduced ramification source.  The two
equations ``W=sE`` are a quadratic in
``d=1+r+t`` followed by a quadratic in ``r`` with leading coefficient ``a``;
they therefore have a solution for every repair-stratum coefficient point
``e*a != 0`` over the algebraic closure.  Taking ``lambda != 0,1`` keeps the
target away from both chord endpoints.

This rules out coefficient strata on which the coverage ramification source
disappears or becomes everywhere nonreduced.  It does not yet rule out the
remaining image-level possibility that all such simple source points collide
with another ramification point over the same target.
"""

from __future__ import annotations

import json

from analyze_c210_coverage_branch_discriminants import NAMES, Ring, derivative


Pair = tuple[dict, dict]


def main() -> None:
    ring = Ring()
    add = ring.add
    mul = ring.mul
    square = ring.square

    def pair_add(left: Pair, right: Pair) -> Pair:
        return add(left[0], right[0]), add(left[1], right[1])

    def pair_mul(left: Pair, right: Pair) -> Pair:
        # omega^2=omega+1
        cross = mul(left[1], right[1])
        return (
            add(mul(left[0], right[0]), cross),
            add(mul(left[0], right[1]), mul(left[1], right[0]), cross),
        )

    def pair_scale(scalar, value: Pair) -> Pair:
        return mul(scalar, value[0]), mul(scalar, value[1])

    def determinant(left: Pair, right: Pair):
        return add(mul(left[0], right[1]), mul(left[1], right[0]))

    def norm(value: Pair):
        return add(
            square(value[0]), mul(value[0], value[1]), square(value[1])
        )

    # First verify the structural decomposition with seven independent
    # variables.  The variable names are harmless aliases inside this exact
    # polynomial identity.
    variables = ring.variables
    d, e, b, q0, q1, y0, y1 = (
        variables[name] for name in ("e", "a", "b", "k", "y0", "h0", "h1")
    )
    D = (d, e)
    E = (e, add(d, e))  # omega*D
    q = (q0, q1)
    W = pair_add(pair_mul(D, D), q)
    Y = (y0, y1)
    R = pair_add(W, pair_scale(b, E))
    T = pair_mul(pair_add(D, Y), W)
    jacobian = determinant(pair_mul(Y, R), T)
    decomposed = add(
        mul(norm(W), determinant(Y, D)),
        mul(b, determinant(pair_mul(Y, E), T)),
    )
    assert jacobian == decomposed

    # Now impose W=sE and resolve Y into the D,E basis.  Reuse six aliases;
    # all identities remain in the exact GF(8)-coefficient polynomial ring.
    d, e, s, b, lam, mu = (
        variables[name] for name in ("e", "a", "b", "k", "y0", "y1")
    )
    D = (d, e)
    E = (e, add(d, e))
    W = pair_scale(s, E)
    R = pair_add(W, pair_scale(b, E))
    Y = pair_add(pair_scale(lam, D), pair_scale(mu, E))
    T = pair_mul(pair_add(D, Y), W)
    constrained_jacobian = determinant(pair_mul(Y, R), T)

    mu_index = NAMES.index("y1")
    at_mu_zero = {
        monomial: coefficient
        for monomial, coefficient in constrained_jacobian.items()
        if monomial[mu_index] == 0
    }
    assert not at_mu_zero

    transverse = derivative(ring, constrained_jacobian, "y1")
    transverse_at_zero = {
        monomial: coefficient
        for monomial, coefficient in transverse.items()
        if monomial[mu_index] == 0
    }
    norm_D = norm(D)
    expected_transverse = mul(mul(s, add(s, b)), square(norm_D))
    assert transverse_at_zero == expected_transverse

    # Record the two scalar equations W=sE in the original variables.  With
    # d=1+r+t they are
    #   d^2+e^2+k+1+z0 = s*e,
    #   e^2+a*r^2+b*r+z1 = s*(d+e).
    # The first is monic quadratic in d; the second has nonzero quadratic
    # coefficient a on the repair stratum.
    print(json.dumps({
        "quadratic_algebra": "omega^2=omega+1",
        "abbreviations": {
            "D": "x+t=(d,e), d=1+r+t",
            "E": "omega*D=(e,d+e)",
            "W": "D^2+q",
            "Y": "y+t",
        },
        "exact_jacobian_decomposition":
            "J=Norm(W)*det(Y,D)+b*det(Y*E,(D+Y)*W)",
        "universal_family": ["W=s*E", "Y=lambda*D+mu*E"],
        "ramification_identity": "J|_(mu=0)=0",
        "transverse_derivative":
            "dJ/dmu|_(mu=0)=s*(s+b)*Norm(D)^2",
        "source_equations": [
            "d^2+e^2+k+1+z0=s*e",
            "e^2+a*r^2+b*r+z1=s*(d+e)",
            "t=d+1+r",
        ],
        "solvability":
            "for e*a!=0, first solve the monic quadratic for d and then the "
            "a-leading quadratic for r; choose s away from 0, b, and the at "
            "most two values making Norm(D)=0",
        "reduced_nonendpoint_conditions": [
            "s!=0", "s!=b", "Norm(D)!=0", "lambda!=0", "lambda!=1",
        ],
        "consequence":
            "every repair-stratum coefficient specialization and both seed "
            "colours have a non-endpoint reduced ramification source over "
            "the algebraic closure",
        "remaining_gate":
            "classify image-level collision of distinct ramification sources",
        "status":
            "source degeneration excluded universally; branch-image collision remains",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
