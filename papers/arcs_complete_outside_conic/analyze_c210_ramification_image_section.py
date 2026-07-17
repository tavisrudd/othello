#!/usr/bin/env python3
"""Certify that the universal C210 ramification family has no self-collision.

On the family from ``analyze_c210_universal_ramification_family.py`` put

    W=s*omega*D,  Y=lambda*D,  D=(d,e).

The branch target is

    y=t+lambda*D,
    h=z+lambda^2*D^2+lambda*s*omega*D.

After using the first source equation for ``d^2``, its four coordinates are
triangular: ``y1`` recovers ``lambda``, ``h0`` recovers ``s``, ``h1``
recovers ``d``, and ``y0`` recovers ``r`` (hence ``t``).  This script verifies
the exact cross-multiplied inverse identities in the polynomial ring.

Thus two distinct points of the universal reduced ramification family cannot
map to the same target.  The remaining collision gate must compare this
section with a ramification source outside it.
"""

from __future__ import annotations

import json

from analyze_c210_coverage_branch_discriminants import Ring


def main() -> None:
    ring = Ring()
    add = ring.add
    mul = ring.mul
    square = ring.square
    one = ring.one
    variables = ring.variables

    # Harmless aliases for the eight independent symbols in this identity.
    e, k, s, lam, d, r, z0, z1 = (
        variables[name]
        for name in ("e", "a", "b", "k", "y0", "y1", "h0", "h1")
    )

    lam2 = square(lam)
    e2 = square(e)
    # On W=s*omega*D, d^2=s*e+e^2+k+1+z0.
    d2 = add(mul(s, e), e2, k, one, z0)
    t = add(d, one, r)

    y0 = add(t, mul(lam, d))
    y1 = mul(lam, e)
    h0 = add(
        z0,
        mul(lam2, add(d2, e2)),
        mul(mul(lam, s), e),
    )
    h1 = add(
        z1,
        mul(lam2, e2),
        mul(mul(lam, s), add(d, e)),
    )

    # Cross-multiplied inverse formulas.  No division is performed by the
    # checker; the required denominators are listed explicitly below.
    recover_lambda = add(y1, mul(lam, e))
    assert not recover_lambda

    # e*lambda*(lambda+1)*s =
    # h0+z0+lambda^2*(k+1+z0), after substituting the forward map.
    recover_s = add(
        h0,
        z0,
        mul(lam2, add(k, one, z0)),
        mul(mul(mul(e, lam), add(lam, one)), s),
    )
    assert not recover_s

    # lambda*s*d = h1+z1+lambda^2*e^2+lambda*s*e.
    recover_d = add(
        mul(mul(lam, s), d),
        h1,
        z1,
        mul(lam2, e2),
        mul(mul(lam, s), e),
    )
    assert not recover_d

    # r=y0+1+(lambda+1)*d and t=d+1+r.
    recover_r = add(r, y0, one, mul(add(lam, one), d))
    recover_t = add(t, d, one, r)
    assert not recover_r
    assert not recover_t

    print(json.dumps({
        "universal_family": ["W=s*omega*D", "Y=lambda*D", "D=(d,e)"],
        "forward_target": {
            "y": "t+lambda*D",
            "h": "z+lambda^2*D^2+lambda*s*omega*D",
        },
        "triangular_coordinates": {
            "y1": "lambda*e",
            "h0":
                "z0+lambda^2*(k+1+z0)+s*e*(lambda^2+lambda)",
            "h1": "z1+lambda^2*e^2+lambda*s*(d+e)",
            "y0": "1+r+(lambda+1)*d",
        },
        "inverse_order": ["lambda from y1", "s from h0", "d from h1", "r from y0", "t=d+1+r"],
        "nonzero_denominators": ["e", "lambda", "lambda+1", "s"],
        "consequence":
            "the universal reduced ramification family is injective onto its "
            "image on the selected open set",
        "remaining_gate":
            "exclude collision with a ramification source outside W=s*omega*D and Y=lambda*D",
        "status":
            "internal branch collision excluded; external ramification collision remains",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
