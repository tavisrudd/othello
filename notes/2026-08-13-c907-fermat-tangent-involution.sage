#!/usr/bin/env sage
"""Exact replay for the Fermat cubic tangent-cover involution.

The output is canonical JSON.  ``--check`` regenerates in memory and compares
against the tracked certificate without modifying it.
"""

import argparse
import json
from pathlib import Path


def certificate():
    ring = PolynomialRing(QQ, names=("r", "y", "z", "t"))
    r, y, z, t = ring.gens()

    a = t * y
    b = 2 * r + t * z
    c = -t * r**2 * y
    d = ring(2)
    e = t
    four_fermat = a**3 + 3 * a * b**2 + c**3 + 3 * c * d**2 + 4 * e**3
    A = 4 + (1 - r**6) * y**3
    D = A + 3 * y * z**2
    expected_polar = t**2 * (12 * r * y * z + t * D)
    assert four_fermat == expected_polar

    # Check involutivity and equality of the residual-point formulas in the
    # fraction field.  The five coordinates are in the original x-basis.
    frac = ring.fraction_field()
    rr, yy, zz, tt = map(frac, (r, y, z, t))
    AA = 4 + (1 - rr**6) * yy**3
    DD = AA + 3 * yy * zz**2
    zi = -AA / (3 * yy * zz)
    Ai = 4 + (1 - (-rr)**6) * yy**3
    zii = -Ai / (3 * yy * zi)
    assert zii == zz

    lam = -12 * rr * yy * zz / DD
    Di = Ai + 3 * yy * zi**2
    lami = -12 * (-rr) * yy * zi / Di
    assert lami == lam

    def image_coords(base_r, dir_y, dir_z, scalar):
        return (
            base_r + scalar * (dir_y + dir_z) / 2,
            -base_r + scalar * (dir_y - dir_z) / 2,
            1 - scalar * base_r**2 * dir_y / 2,
            -1 - scalar * base_r**2 * dir_y / 2,
            scalar,
        )

    image = image_coords(rr, yy, zz, lam)
    image_i = image_coords(-rr, yy, zi, lami)
    assert image_i == image

    rho = rr**2
    u = zz - AA / (3 * yy * zz)
    v = rr * (zz + AA / (3 * yy * zz))
    fixed_relation = v**2 - rho * (u**2 + 4 * AA / (3 * yy))
    assert fixed_relation == 0

    # Fixed curve at r=0 and its exact linear Fermat transformation.
    curve_ring = PolynomialRing(QQ, names=("Y", "Z", "W"))
    Y, Z, W = curve_ring.gens()
    fixed_cubic = Y**3 + 3 * Y * Z**2 + 4 * W**3
    fermat_pullback = (Y + Z)**3 + (Y - Z)**3 + (2 * W)**3
    assert fermat_pullback == 2 * fixed_cubic
    jacobian_ideal = curve_ring.ideal(
        fixed_cubic,
        fixed_cubic.derivative(Y),
        fixed_cubic.derivative(Z),
        fixed_cubic.derivative(W),
    )
    assert jacobian_ideal.dimension() == 0
    # The affine cone has only the origin as a common zero: saturation by the
    # irrelevant ideal is the unit ideal.
    irrelevant = curve_ring.ideal(Y, Z, W)
    assert jacobian_ideal.saturation(irrelevant)[0] == curve_ring.ideal(1)

    return {
        "schema": "c907-fermat-tangent-involution-v1",
        "field": "QQ (identities valid in characteristic not 2 or 3)",
        "polar_identity": "4F(p+t*v)=t^2*(12*r*y*z+t*(4+(1-r^6)*y^3+3*y*z^2))",
        "involution": {
            "r": "-r",
            "y": "y",
            "z": "-(4+(1-r^6)*y^3)/(3*y*z)",
        },
        "fixed_field": {
            "rho": "r^2",
            "u": "z-(4+(1-r^6)*y^3)/(3*y*z)",
            "v": "r*(z+(4+(1-r^6)*y^3)/(3*y*z))",
            "relation": "v^2=rho*(u^2+4*(4+(1-rho^3)*y^3)/(3*y))",
        },
        "fixed_curves": {
            "base_points": ["r=0", "r=infinity"],
            "plane_model": "Y^3+3*Y*Z^2+4*W^3=0",
            "fermat_change": "(X0,X1,X2)=(Y+Z,Y-Z,2W)",
            "j_invariant": int(0),
            "normal_characters": ["sign", "sign"],
            "ordinary_burnside_symbol": "(C2,k(E),(chi,chi))=0 by B1",
        },
        "checks": {
            "polar_factorization": True,
            "involution_squared": True,
            "residual_map_invariant": True,
            "fixed_field_relation": True,
            "fixed_cubic_smooth": True,
            "fixed_cubic_fermat": True,
        },
    }


def encoded(data):
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    parser.add_argument("--check", type=Path)
    args = parser.parse_args()
    if bool(args.output) == bool(args.check):
        parser.error("provide exactly one of --output or --check")
    payload = encoded(certificate())
    if args.output:
        args.output.write_bytes(payload)
        print(f"wrote {args.output} ({len(payload)} bytes)")
    else:
        tracked = args.check.read_bytes()
        if tracked != payload:
            raise SystemExit("certificate mismatch")
        print(f"verified {args.check} ({len(payload)} bytes)")


if __name__ == "__main__":
    main()
