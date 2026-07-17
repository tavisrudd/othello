#!/usr/bin/env python3
"""Certify the translation quotient of the C210 quadratic coefficient space.

The seed stabilizer translates the parabola parameter by ``d``.  After
renormalizing the repair parameter, this fixes ``eta1, a1, b1, c0`` and sends

    c1 -> c1 + a1*d^2 + b1*d.

Over an algebraic closure, ``a1 != 0`` makes this action transitive on c1.
Over a finite field, b1 != 0 leaves exactly the Artin--Schreier trace bit
``Tr(a1*c1/b1^2)``.  This checker verifies the point-set conjugacy and the
finite-field quotient on all three frozen GF(8) representatives.
"""

from __future__ import annotations

import json

from analyze_c210_exceptional_quadratic_locus import (
    canonical_known_rows,
    repair_points,
    tau_exponent,
)
from analyze_c210_residue_hypergraph import build_context


def absolute_trace(context, value: int) -> int:
    field = context.ambient
    out = 0
    for exponent in (1, 2, 4):
        out = field.add(out, field.power(value, exponent))
    assert out in (0, 1)
    return out


def twist_bit(context, a: int, b: int, c: int) -> int:
    field = context.ambient
    assert a != 0 and b != 0
    return absolute_trace(
        context,
        field.div(field.mul(a, c), field.mul(b, b)),
    )


def translated_repair_set(context, points, d: int):
    field = context.ambient
    return {
        (field.add(first, d), second)
        for first, second in points
    }


def orbit_row(context, row: tuple[int, int, int, int, int], orbit: int):
    field = context.ambient
    eta1, a1, b1, c0, c1 = row
    assert a1 != 0 and b1 != 0
    original = repair_points(context, eta1, a1, b1, c0, c1)

    image = set()
    for d in context.base_values:
        shift = field.add(
            field.mul(a1, field.mul(d, d)), field.mul(b1, d)
        )
        translated_c1 = field.add(c1, shift)
        image.add(translated_c1)
        translated = translated_repair_set(context, original, d)
        reparametrized = set(repair_points(
            context, eta1, a1, b1, c0, translated_c1
        ))
        assert translated == reparametrized

    kernel = {
        d for d in context.base_values
        if field.add(
            field.mul(a1, field.mul(d, d)), field.mul(b1, d)
        ) == 0
    }
    assert kernel == {0, field.div(b1, a1)}
    assert len(image) == 4

    bit = twist_bit(context, a1, b1, c1)
    same_twist = {
        candidate for candidate in context.base_values
        if twist_bit(context, a1, b1, candidate) == bit
    }
    assert image == same_twist

    return {
        "orbit": orbit,
        "fixed_coefficients_tau_exponents": [
            tau_exponent(context, value) for value in row[:4]
        ],
        "frozen_c1_tau_exponent": tau_exponent(context, c1),
        "translation_kernel_tau_exponents": sorted(
            (tau_exponent(context, value) for value in kernel),
            key=lambda value: -1 if value is None else value,
        ),
        "translation_orbit_tau_exponents": sorted(
            (tau_exponent(context, value) for value in image),
            key=lambda value: -1 if value is None else value,
        ),
        "translation_orbit_size": len(image),
        "arithmetic_twist_bit": bit,
        "opposite_twist_size": len(context.base_values) - len(image),
        "point_set_conjugacy_checked_for_all_d": True,
    }


def main() -> None:
    context = build_context(1)
    rows = canonical_known_rows(context)
    orbit_rows = [
        orbit_row(context, row, orbit)
        for orbit, row in enumerate(rows, start=1)
    ]
    print(json.dumps({
        "field": "GF(8)",
        "action": "c1 -> c1+a1*d^2+b1*d",
        "geometric_quotient":
            "c1 is eliminable over the algebraic closure when a1!=0",
        "finite_field_quotient": {
            "b1_zero": "the Frobenius map is bijective; one c1 orbit",
            "b1_nonzero":
                "two c1 orbits distinguished by Tr(a1*c1/b1^2)",
        },
        "representatives": orbit_rows,
        "drop_divisor_reduction":
            "geometric drop conditions depend only on eta1,a1,b1,c0; "
            "c1 contributes at most one arithmetic twist bit",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
