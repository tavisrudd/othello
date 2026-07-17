#!/usr/bin/env python3
"""Classify the normalized q=64 exceptional quadratic coverage locus.

The two seed layers are fixed over F=GF(8) inside E=GF(64).  A quadratic
repair graph is written, after translating its F-parameter, as

    x = omega*e,
    g(x+r) = c0 + omega*(a*r^2 + b*r + c),   r in F,

with e != 0.  Translation of the parameter removes eta's base-field
coordinate, so this is an exact five-parameter quotient rather than a sample.

Every partial repair domain has a subset of the secants of its full graph.
Consequently affine off-conic completeness of the full graph is a necessary
condition for every quadratic partial-domain construction.  This checker
enumerates that coefficient-space prerequisite and records the stronger
affine-complete sublocus.  It does not enumerate projective arcs or optimize a
plane search.
"""

from __future__ import annotations

import itertools
import json
import hashlib
from collections import Counter

from analyze_c210_generic_coverage_monodromy import exact_double_root_witness
from analyze_c210_residue_hypergraph import build_context


def assemble(context, first: int, second: int) -> int:
    field = context.ambient
    omega = field.div(field.add(context.beta, 1), context.tau)
    return field.add(first, field.mul(second, omega))


def tau_exponent(context, value: int) -> int | None:
    if value == 0:
        return None
    return next(
        exponent for exponent in range(7)
        if context.ambient.power(context.tau, exponent) == value
    )


def line_catalog(context) -> tuple[dict[tuple[int, int], int], tuple[int, ...]]:
    """Precompute the 4096 nonvertical and 64 vertical affine lines."""

    field = context.ambient
    nonvertical = {}
    for slope, intercept in itertools.product(range(64), repeat=2):
        mask = 0
        for y in range(64):
            height = field.add(
                field.add(field.mul(y, y), field.mul(slope, y)), intercept
            )
            mask |= 1 << (64 * y + height)
        nonvertical[slope, intercept] = mask
    vertical = tuple(((1 << 64) - 1) << (64 * x) for x in range(64))
    return nonvertical, vertical


def chord_mask(
    context,
    catalog: tuple[dict[tuple[int, int], int], tuple[int, ...]],
    left: tuple[int, int],
    right: tuple[int, int],
) -> int:
    """Return the 4096-bit mask of affine points on one chord.

    Points use parabola coordinates ``(x,h)`` for the projective point
    ``(1,x,x^2+h)``.  Bit ``64*y+h`` represents the affine target ``(y,h)``.
    """

    field = context.ambient
    x, height = left
    other_x, other_height = right
    if x == other_x:
        return catalog[1][x]
    z = field.add(field.mul(x, x), height)
    other_z = field.add(field.mul(other_x, other_x), other_height)
    slope = field.div(field.add(other_z, z), field.add(other_x, x))
    intercept = field.add(z, field.mul(slope, x))
    return catalog[0][slope, intercept]


def line_key(
    context, left: tuple[int, int], right: tuple[int, int]
) -> tuple[str, int, int]:
    field = context.ambient
    x, height = left
    other_x, other_height = right
    if x == other_x:
        return ("V", x, 0)
    z = field.add(field.mul(x, x), height)
    other_z = field.add(field.mul(other_x, other_x), other_height)
    slope = field.div(field.add(other_z, z), field.add(other_x, x))
    intercept = field.add(z, field.mul(slope, x))
    return ("N", slope, intercept)


def seed_data(
    context, catalog: tuple[dict[tuple[int, int], int], tuple[int, ...]]
) -> tuple[tuple[tuple[int, int], ...], int]:
    seeds = tuple(
        (parameter, height)
        for parameter in context.base_values
        for height in (context.alpha, context.beta)
    )
    mask = 0
    for left, right in itertools.combinations(seeds, 2):
        mask |= chord_mask(context, catalog, left, right)
    return seeds, mask


def repair_points(
    context, e: int, a: int, b: int, c0: int, c: int
) -> tuple[tuple[int, int], ...]:
    field = context.ambient
    eta = assemble(context, 0, e)
    out = []
    for r in context.base_values:
        graph_second = field.add(
            field.add(field.mul(a, field.mul(r, r)), field.mul(b, r)), c
        )
        out.append((field.add(eta, r), assemble(context, c0, graph_second)))
    return tuple(out)


def coverage_mask(
    context,
    catalog: tuple[dict[tuple[int, int], int], tuple[int, ...]],
    seeds: tuple[tuple[int, int], ...],
    seed_mask: int,
    repairs: tuple[tuple[int, int], ...],
) -> int:
    mask = seed_mask
    for repair in repairs:
        for seed in seeds:
            mask |= chord_mask(context, catalog, seed, repair)
    for left, right in itertools.combinations(repairs, 2):
        mask |= chord_mask(context, catalog, left, right)
    return mask


def canonical_known_rows(context) -> list[tuple[int, int, int, int, int]]:
    """Translate the three frozen orbit representatives to eta0=0."""

    field = context.ambient
    rows = []
    for orbit in (1, 2, 3):
        frozen = build_context(orbit)
        translated_c = field.add(
            frozen.c1,
            field.add(
                field.mul(frozen.a1, field.mul(frozen.eta0, frozen.eta0)),
                field.mul(frozen.b1, frozen.eta0),
            ),
        )
        rows.append((
            frozen.eta1, frozen.a1, frozen.b1, frozen.c0, translated_c
        ))
    return rows


def full_arc_legal(
    context,
    seeds: tuple[tuple[int, int], ...],
    repairs: tuple[tuple[int, int], ...],
) -> bool:
    """Check conic avoidance and no-three-collinear for all 24 points."""

    if any(height == 0 for _, height in repairs):
        return False
    points = seeds + repairs
    keys = {
        line_key(context, left, right)
        for left, right in itertools.combinations(points, 2)
    }
    return len(keys) == len(points) * (len(points) - 1) // 2


def row_digest(rows: list[tuple[int, ...]]) -> str:
    payload = json.dumps(sorted(rows), separators=(",", ":")).encode()
    return hashlib.sha256(payload).hexdigest()


def translation_blocks(
    context,
    rows: list[tuple[int, int, int, int, int]],
    known: list[tuple[int, int, int, int, int]],
) -> list[dict[str, object]]:
    """Identify every legal exceptional block with a frozen translation orbit."""

    field = context.ambient
    grouped: dict[tuple[int, int, int, int], set[int]] = {}
    for e, a, b, c0, c in rows:
        grouped.setdefault((e, a, b, c0), set()).add(c)
    assert len(grouped) == 3

    out = []
    for key, c_values in sorted(grouped.items()):
        representative = next(row for row in known if row[:4] == key)
        _, a, b, _, frozen_c = representative
        translated = {
            field.add(
                frozen_c,
                field.add(
                    field.mul(a, field.mul(d, d)), field.mul(b, d)
                ),
            )
            for d in context.base_values
        }
        assert c_values == translated
        out.append({
            "fixed_coefficients_tau_exponents": [
                tau_exponent(context, value) for value in key
            ],
            "frozen_c1_tau_exponent": tau_exponent(context, frozen_c),
            "c1_translation_orbit_tau_exponents": sorted(
                (tau_exponent(context, value) for value in c_values),
                key=lambda value: -1 if value is None else value,
            ),
            "translation_law": "c1 -> c1+a1*d^2+b1*d",
            "translation_parameter_count": len(context.base_values),
            "distinct_c1_count": len(c_values),
        })
    return out


def frozen_s7_witnesses() -> list[dict[str, object]]:
    """Show that no q=64 orbit lies on the degree-seven drop locus."""

    specifications = (
        (1, (None, 0, None, 5), None),
        (2, (None, 0, None, 0), 6),
        (3, (None, 0, None, 0), 2),
    )
    out = []
    for orbit, target_exponents, root_exponent in specifications:
        context = build_context(orbit)
        field = context.ambient

        def decode(exponent: int | None) -> int:
            return 0 if exponent is None else field.power(context.tau, exponent)

        target = tuple(decode(exponent) for exponent in target_exponents)
        root = decode(root_exponent)
        witness = exact_double_root_witness(
            context, context.alpha, target, root
        )
        assert witness["resultant_degree"] == 7
        out.append({
            "orbit": orbit,
            "seed_color": "A",
            "branch_witness": witness,
            "incidence_source": "rational and geometrically connected",
            "geometric_monodromy": "S7",
            "arithmetic_monodromy": "S7",
        })
    return out


def main() -> None:
    context = build_context(1)
    field = context.ambient
    catalog = line_catalog(context)
    seeds, seed_mask = seed_data(context, catalog)

    full_mask = (1 << (64 * 64)) - 1
    conic_mask = sum(1 << (64 * y) for y in range(64))
    required_mask = full_mask ^ conic_mask

    relative_rows: list[tuple[int, int, int, int, int]] = []
    affine_rows: list[tuple[int, int, int, int, int]] = []
    legal_relative_rows: list[tuple[int, int, int, int, int]] = []
    legal_affine_rows: list[tuple[int, int, int, int, int]] = []
    missing_histogram: Counter[int] = Counter()
    nonzero = context.base_values[1:]
    tested = 0
    for e, a, b, c0, c in itertools.product(
        nonzero,
        context.base_values,
        context.base_values,
        context.base_values,
        context.base_values,
    ):
        tested += 1
        repairs = repair_points(context, e, a, b, c0, c)
        mask = coverage_mask(context, catalog, seeds, seed_mask, repairs)
        missing_required = (required_mask & ~mask).bit_count()
        missing_histogram[missing_required] += 1
        if missing_required == 0:
            row = (e, a, b, c0, c)
            relative_rows.append(row)
            affine_complete = (full_mask & ~mask) == 0
            if affine_complete:
                affine_rows.append(row)
            if full_arc_legal(context, seeds, repairs):
                legal_relative_rows.append(row)
                if affine_complete:
                    legal_affine_rows.append(row)

    known = canonical_known_rows(context)
    assert all(row in legal_affine_rows for row in known)
    assert legal_relative_rows == legal_affine_rows
    assert len(legal_affine_rows) == 12

    def encode(row: tuple[int, ...]) -> list[int | None]:
        return [tau_exponent(context, value) for value in row]

    print(json.dumps({
        "field": "GF(8)",
        "normalization": "eta0=0",
        "parameter_order": ["eta1", "a1", "b1", "c0", "c1"],
        "tested": tested,
        "relative_affine_complete_count": len(relative_rows),
        "affine_complete_count": len(affine_rows),
        "legal_relative_affine_complete_count": len(legal_relative_rows),
        "legal_affine_complete_count": len(legal_affine_rows),
        "known_orbit_rows_tau_exponents": [encode(row) for row in known],
        "known_rows_are_affine_complete": True,
        "legal_affine_rows_tau_exponents": [
            encode(row) for row in legal_affine_rows
        ],
        "legal_exceptional_translation_blocks": translation_blocks(
            context, legal_affine_rows, known
        ),
        "frozen_degree_7_monodromy": frozen_s7_witnesses(),
        "q64_layers_lie_on_degree_7_monodromy_drop_locus": False,
        "relative_rows_sha256": row_digest(relative_rows),
        "affine_rows_sha256": row_digest(affine_rows),
        "missing_required_histogram": dict(sorted(missing_histogram.items())),
    }, sort_keys=True))


if __name__ == "__main__":
    main()
