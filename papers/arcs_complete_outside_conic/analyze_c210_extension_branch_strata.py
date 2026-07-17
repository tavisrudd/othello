#!/usr/bin/env python3
"""Test the unresolved C210 coverage branches on the first geometric strata.

The reduced mixed-cover Hasse divisor

    k^2 + C*k + C^2,       C=e^2+sqrt(tau)*e,

splits only after adjoining ``omega``.  Consequently the preceding exhaustive
GF(8) branch-image audit did not test a generic point of either component, or
their conjugate intersections with ``e^2+k=0``.  This checker supplies exact
GF(64) closed-point witnesses on both components, with and without ``b=0``,
and at both conjugate critical/triple intersections.

It also restores the finite-field translation twist omitted by the quotient
audit.  For every GF(8) quotient point with ``e*a*b != 0``, it chooses the
unique nonzero translation class

    Tr(a*c1/b^2)=1

and certifies a simple branch-image point for both seed colours.  These are
targeted coefficient-space checks, not an ambient-plane census.  They rule out
the known mixed-cover components and the arithmetic twist as sources of a
simultaneous coverage-branch drop; unknown coverage image divisors remain.
"""

from __future__ import annotations

import hashlib
import itertools
import json

from analyze_c210_coverage_branch_images import normalized
from analyze_c210_persistent_singletons import (
    coverage_equations,
    poly_divmod,
    poly_value,
    sylvester_resultant,
    t_gcd_modulus,
)
from analyze_c210_residue_hypergraph import build_context
from analyze_c210_symbolic_coverage_resultant import poly_derivative, poly_gcd


def row_digest(rows: list[tuple[int, ...]]) -> str:
    payload = json.dumps(rows, separators=(",", ":")).encode()
    return hashlib.sha256(payload).hexdigest()


def absolute_trace(field, value: int, degree: int) -> int:
    out = 0
    power = value
    for _ in range(degree):
        out = field.add(out, power)
        power = field.mul(power, power)
    return out


def simple_branch_witness(context, coefficients, seed_height, targets):
    """Return an exact one-double-root witness, or ``None``.

    ``coefficients`` is ``(e,a,b,k,c1)`` on the normalization ``eta0=1`` and
    ``c0=k+1``.  Target coordinates may lie in GF(8) or in its GF(64)
    algebraic closure used by the symbolic coefficient calculation.
    """

    field = context.ambient
    e, a, b, k, c1 = coefficients
    for target in targets:
        if target[1] == 0:
            continue
        equations = coverage_equations(
            field,
            context.coordinates,
            1,
            e,
            a,
            b,
            field.add(k, 1),
            c1,
            seed_height,
            *target,
        )
        resultant = sylvester_resultant(field, *equations)
        if len(resultant) != 8:
            continue
        gcd = normalized(
            field, poly_gcd(field, resultant, poly_derivative(resultant))
        )
        if len(gcd) != 3 or gcd[1] != 0:
            continue
        root = field.power(gcd[0], field.q // 2)
        if gcd != (field.mul(root, root), 0, 1):
            continue
        quotient, remainder = poly_divmod(field, resultant, gcd)
        if remainder or poly_value(field, quotient, root) == 0:
            continue
        if len(poly_gcd(field, quotient, poly_derivative(quotient))) != 1:
            continue
        t_gcd = t_gcd_modulus(
            field, (root, 1), equations[:3], equations[3:]
        )
        if len(t_gcd) != 2 or t_gcd[1] != (1,):
            continue
        seed_parameter = 0 if not t_gcd[0] else t_gcd[0][0]
        return (*target, root, seed_parameter)
    return None


def main() -> None:
    context = build_context(1)
    field = context.ambient
    base = context.base_values
    omega = field.div(field.add(context.beta, 1), context.tau)
    omega2 = field.mul(omega, omega)
    assert field.add(field.add(omega2, omega), 1) == 0
    sqrt_tau = field.power(context.tau, 4)
    assert field.mul(sqrt_tau, sqrt_tau) == context.tau

    square = lambda value: field.mul(value, value)
    add = field.add
    mul = field.mul

    # The missing arithmetic class in the translation quotient.  A c1 with
    # trace one exists for every e,a,b,k with e*a*b nonzero.  The target pool
    # stays in GF(8), so this is strictly a coefficient/twist audit.
    rational_targets = tuple(itertools.product(base, repeat=4))
    twist_rows: dict[str, list[tuple[int, ...]]] = {"A": [], "B": []}
    twist_points = 0
    for e in base:
        if e == 0:
            continue
        for a in base:
            if a == 0:
                continue
            for b in base:
                if b == 0:
                    continue
                scale = field.div(a, square(b))
                c1 = next(
                    value for value in base
                    if absolute_trace(field, mul(scale, value), 3) == 1
                )
                assert absolute_trace(field, mul(scale, c1), 3) == 1
                for k in base:
                    twist_points += 1
                    coefficients = (e, a, b, k, c1)
                    for seed, seed_height in (
                        ("A", context.alpha), ("B", context.beta)
                    ):
                        witness = simple_branch_witness(
                            context, coefficients, seed_height, rational_targets
                        )
                        assert witness is not None, (seed, coefficients)
                        twist_rows[seed].append((*coefficients, *witness))

    assert twist_points == 7 * 7 * 7 * 8

    # Closed points on the two conjugate Hasse components.  The first pair is
    # generic on each component; the second is its conjugate intersection
    # with e^2+k=0.  Testing b=1 and b=0 also tests the b-divisor intersections
    # and the two conjugate triple points.
    # One fixed nonzero target-abscissa coordinate suffices; enumerate only
    # the two height coordinates over the algebraic test field.
    extension_targets = tuple(
        (0, 1, h0, h1) for h0 in range(field.q) for h1 in range(field.q)
    )
    extension_rows = []
    for component, label in ((omega, "omega"), (omega2, "omega^2")):
        generic_e = 1
        generic_C = add(square(generic_e), mul(sqrt_tau, generic_e))
        generic_k = mul(component, generic_C)
        # The critical intersection on k+component*C=0 uses the conjugate
        # scalar in e; Frobenius swaps the two labels.
        other = omega2 if component == omega else omega
        critical_e = mul(sqrt_tau, other)
        critical_k = square(critical_e)
        for locus, e, k in (
            ("generic_component", generic_e, generic_k),
            ("critical_intersection", critical_e, critical_k),
        ):
            C = add(square(e), mul(sqrt_tau, e))
            assert add(k, mul(component, C)) == 0
            if locus == "generic_component":
                assert add(k, mul(other, C)) != 0
                assert add(square(e), k) != 0
            else:
                assert add(square(e), k) == 0
            for b in (0, 1):
                coefficients = (e, 1, b, k, 0)
                for seed, seed_height in (
                    ("A", context.alpha), ("B", context.beta)
                ):
                    witness = simple_branch_witness(
                        context, coefficients, seed_height, extension_targets
                    )
                    assert witness is not None, (label, locus, b, seed)
                    extension_rows.append({
                        "component": label,
                        "locus": locus,
                        "b1": b,
                        "seed": seed,
                        "coefficients": coefficients,
                        "witness": witness,
                    })

    print(json.dumps({
        "field_of_definition": "GF(8)",
        "geometric_test_field": "GF(64)",
        "normalization": "eta0=1, c0=k+1",
        "arithmetic_twist": {
            "class": "Tr(a1*c1/b1^2)=1",
            "quotient_points_tested": twist_points,
            "seed_A_witness_rows_sha256": row_digest(twist_rows["A"]),
            "seed_B_witness_rows_sha256": row_digest(twist_rows["B"]),
            "conclusion":
                "the nontrivial translation twist retains a simple branch "
                "image point for both seed covers at every GF(8) quotient point",
        },
        "geometric_mixed_strata": {
            "rows": extension_rows,
            "conclusion":
                "both conjugate non-simple-inertia components, their b1=0 "
                "intersections, and both conjugate critical/triple intersections "
                "retain simple branch image points for both seed covers",
        },
        "scope":
            "known lower-factor components and the arithmetic twist are excluded; "
            "classification of unknown coverage image divisors remains",
        "status":
            "extension closed points and the omitted arithmetic twist certified",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
