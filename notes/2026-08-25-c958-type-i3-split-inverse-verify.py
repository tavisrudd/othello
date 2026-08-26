#!/usr/bin/env sage-python
"""Verify prederived type-I3 inverse formulas without redoing interpolation."""

import argparse
import hashlib
import importlib.util
import json
from pathlib import Path
import sys

from sage.all import PolynomialRing
from sage.misc.sage_eval import sage_eval

if sys.flags.optimize:
    raise RuntimeError("verification must run with Python assertions enabled")


ROOT = Path(__file__).resolve().parents[1]
BLOWDOWN_INPUT = ROOT / "notes/2026-08-25-c958-type-i3-split-blowdown.json"
SECTIONS_INPUT = ROOT / "notes/2026-08-25-c958-type-i3-exceptional-sections.json"
BLOWDOWN_SOURCE = ROOT / "notes/2026-08-25-c958-type-i3-split-blowdown.py"
INVERSE_SOURCE = ROOT / "notes/2026-08-25-c958-type-i3-split-inverse.py"


def progress(message):
    print(f"c958 type-I3 inverse verification: {message}", file=sys.stderr, flush=True)


def load_inverse_source():
    specification = importlib.util.spec_from_file_location("c958_i3_inverse", INVERSE_SOURCE)
    module = importlib.util.module_from_spec(specification)
    specification.loader.exec_module(module)
    return module


def build(formulas_input):
    formulas_bytes = formulas_input.read_bytes()
    blowdown_bytes = BLOWDOWN_INPUT.read_bytes()
    sections_bytes = SECTIONS_INPUT.read_bytes()
    formulas = json.loads(formulas_bytes)
    blowdown = json.loads(blowdown_bytes)
    assert formulas["schema"] == "c958-type-i3-normalized-split-inverse-formulas-v1"
    assert blowdown["schema"] == "c958-type-i3-split-blowdown-v1"
    expected_inputs = {
        "blowdown": hashlib.sha256(blowdown_bytes).hexdigest(),
        "sections": hashlib.sha256(sections_bytes).hexdigest(),
        "blowdown_source": hashlib.sha256(BLOWDOWN_SOURCE.read_bytes()).hexdigest(),
    }
    assert formulas["input_sha256"] == expected_inputs
    assert formulas["exceptional_line_alignment_rank"] == 15
    field, beta, r, d, g, delta = load_inverse_source().build_normalized_field()
    a = field.one()

    def parse(value):
        return field(sage_eval(
            value,
            locals={"a": a, "beta": beta, "r": r, "d": d, "g": g,
                    "delta": delta},
        ))

    ambient = PolynomialRing(field, names=("Y1", "Y2", "Y3", "Y4"))
    y1, y2, y3, y4 = ambient.gens()
    plane = PolynomialRing(field, names=("Z1", "Z2", "Z3"))
    z1, z2, z3 = plane.gens()
    quadric_monomials = [
        y1**2, y1 * y2, y1 * y3, y1 * y4, y2**2,
        y2 * y3, y2 * y4, y3**2, y3 * y4, y4**2,
    ]
    plane_cubic_monomials = [
        z1**3, z1**2 * z2, z1**2 * z3, z1 * z2**2, z1 * z2 * z3,
        z1 * z3**2, z2**3, z2**2 * z3, z2 * z3**2, z3**3,
    ]
    assert formulas["plane_cubic_monomial_order"] == [
        str(value) for value in plane_cubic_monomials
    ]
    quadrics = {
        coordinate: sum((parse(value) * monomial for value, monomial in zip(
            blowdown["quadric_coefficients"][coordinate], quadric_monomials,
        )), ambient.zero())
        for coordinate in ("Z1", "Z2", "Z3")
    }
    inverse_forms = [sum(
        (parse(value) * monomial for value, monomial in zip(vector, plane_cubic_monomials)),
        plane.zero(),
    ) for vector in formulas["inverse_cubic_coefficients"]]
    assert len(inverse_forms) == 4
    assert all(form.degree() == 3 for form in inverse_forms)
    progress("loaded the prederived exact coefficient formulas")

    cubic = (
        y3 * (a * y1**2 + 2 * a * y1 * y2 + (a**3 + beta) * y3**2)
        + y4 * (y1**2 + y1 * y2 + y2**2 - a**2 * y3**2 + y4**2)
    )
    inverse_hom = ambient.hom(inverse_forms, plane)
    landing = inverse_hom(cubic)
    assert landing.is_zero()
    progress("checked the cubic-surface landing identity")

    forward_after_inverse = [inverse_hom(quadrics[name]) for name in ("Z1", "Z2", "Z3")]
    assert all(value for value in forward_after_inverse)
    forward_residuals = [
        forward_after_inverse[0] * z2 - forward_after_inverse[1] * z1,
        forward_after_inverse[0] * z3 - forward_after_inverse[2] * z1,
    ]
    assert all(value.is_zero() for value in forward_residuals)
    progress("checked blowdown after inverse")

    forward_hom = plane.hom([quadrics[name] for name in ("Z1", "Z2", "Z3")], ambient)
    inverse_after_forward = [forward_hom(form) for form in inverse_forms]
    assert all(value for value in inverse_after_forward)
    coefficient_ring = PolynomialRing(field, names=("X1", "X2", "X3"))
    x1, x2, x3 = coefficient_ring.gens()
    univariate_ring = PolynomialRing(coefficient_ring, "X4")
    x4 = univariate_ring.gen()
    as_univariate = ambient.hom([x1, x2, x3, x4], univariate_ring)
    univariate_cubic = as_univariate(cubic)
    assert univariate_cubic.is_monic()
    reverse_residuals = []
    for index, coordinate in enumerate((y2, y3, y4), start=1):
        residual = inverse_after_forward[0] * coordinate - inverse_after_forward[index] * y1
        remainder = as_univariate(residual).quo_rem(univariate_cubic)[1]
        assert remainder.is_zero()
        reverse_residuals.append(remainder)
    progress("checked inverse after blowdown in the localized surface ring")

    output = dict(formulas)
    output["schema"] = "c958-type-i3-normalized-split-inverse-v1"
    output["formula_checkpoint_sha256"] = hashlib.sha256(formulas_bytes).hexdigest()
    output["verification"] = {
        "landing_residual_is_zero": landing.is_zero(),
        "forward_projective_residual_count": len(forward_residuals),
        "reverse_projective_residual_count": len(reverse_residuals),
        "surface_reduction_variable": "Y4",
        "surface_equation_is_monic_in_reduction_variable": univariate_cubic.is_monic(),
    }
    output["certified"] = formulas["certified"] + [
        "the inverse cubic forms satisfy the original cubic equation",
        "the split blowdown after the inverse is projectively the plane identity",
        "the inverse after the split blowdown is projectively the surface identity modulo the cubic equation",
    ]
    return output


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("formulas", type=Path)
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", type=Path)
    mode.add_argument("--check", type=Path)
    arguments = parser.parse_args()
    payload = json.dumps(build(arguments.formulas), indent=2, sort_keys=True) + "\n"
    if arguments.write:
        arguments.write.write_text(payload)
    else:
        assert arguments.check.read_text() == payload


if __name__ == "__main__":
    main()
