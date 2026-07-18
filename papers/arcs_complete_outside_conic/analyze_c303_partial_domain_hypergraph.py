#!/usr/bin/env python3
"""C303: exact partial-domain test on the four GF(8) terminal geometries.

The selected configuration has the two eight-point seed layers and two
eight-point repair layers in PG(2,64).  For each terminal branch and each
anchoring seed color, this checker:

* rebuilds every collinear-triple constraint;
* verifies the predicted seven-edge terminal star;
* removes the exact selected conic point required by admissibility;
* proves the minimum admissible collision transversal;
* checks projective coverage outside XZ=Y^2, including deleted vertices; and
* exhausts every deletion branch compatible with retained coverage.

The primary construction uses line keys and closed-form line masks.  An
independent replay uses determinant collinearity and direct target scanning.
There are no random choices.
"""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from collections import Counter, defaultdict
from dataclasses import dataclass
from pathlib import Path

from probe_c210_two_layer_parabolas import QuadraticField


ROOT = Path(__file__).resolve().parent
OUTPUT = ROOT / "analyze_c303_partial_domain_hypergraph_output.json"
SUMS = ROOT / "analyze_c303_SHA256SUMS"
PROBE_OUTPUT = ROOT / "probe_c210_quadratic_coset_repairs_output.txt"


Point = tuple[int, int]  # parabola coordinates (x,h) for [1:x:x^2+h]


@dataclass(frozen=True)
class Context:
    field: QuadraticField
    base: tuple[int, ...]
    alpha: int
    beta: int
    tau: int
    omega: int

    def coordinates(self, value: int) -> tuple[int, int]:
        for second in self.base:
            first = self.field.add(value, self.field.mul(second, self.omega))
            if self.field.in_subfield(first):
                return first, second
        raise AssertionError(value)

    def assemble(self, first: int, second: int) -> int:
        return self.field.add(first, self.field.mul(second, self.omega))


def build_context() -> Context:
    field = QuadraticField.for_subfield_order(8)
    base = tuple(x for x in range(field.q) if field.in_subfield(x))
    source = json.loads(PROBE_OUTPUT.read_text().splitlines()[-1])
    alpha, beta = source["seed_offsets"]
    tau = field.add(beta, field.power(beta, 8))
    omega = field.div(field.add(beta, 1), tau)
    context = Context(field, base, alpha, beta, tau, omega)
    assert len(base) == 8
    assert all(context.assemble(*context.coordinates(x)) == x for x in range(64))
    return context


def repair_points(
    context: Context, e: int, b: int, c0: int, c1: int
) -> tuple[Point, ...]:
    field = context.field
    eta = context.assemble(0, e)
    return tuple(
        (
            field.add(eta, r),
            context.assemble(c0, field.add(field.mul(b, r), c1)),
        )
        for r in context.base
    )


def z_coordinate(context: Context, point: Point) -> int:
    x, height = point
    return context.field.add(context.field.mul(x, x), height)


def line_key(context: Context, left: Point, right: Point) -> tuple[str, int, int]:
    field = context.field
    x, _ = left
    y, _ = right
    if x == y:
        return ("V", x, 0)
    zx = z_coordinate(context, left)
    zy = z_coordinate(context, right)
    slope = field.div(field.add(zy, zx), field.add(y, x))
    intercept = field.add(zx, field.mul(slope, x))
    return ("N", slope, intercept)


def collinear_direct(context: Context, a: Point, b: Point, c: Point) -> bool:
    """Direct affine determinant, independent of line-key grouping."""
    field = context.field
    ax, bx, cx = a[0], b[0], c[0]
    az, bz, cz = (z_coordinate(context, p) for p in (a, b, c))
    left = field.mul(field.add(bx, ax), field.add(cz, az))
    right = field.mul(field.add(cx, ax), field.add(bz, az))
    return left == right


def formula_pair_mask(context: Context, left: Point, right: Point) -> int:
    """Affine line mask plus its required point at infinity, when nonvertical."""
    field = context.field
    key = line_key(context, left, right)
    mask = 0
    if key[0] == "V":
        x = key[1]
        for height in range(64):
            mask |= 1 << (64 * x + height)
        return mask  # the vertical infinity point is the conic point [0:0:1]
    slope, intercept = key[1], key[2]
    for x in range(64):
        height = field.add(
            field.add(field.mul(x, x), field.mul(slope, x)), intercept
        )
        mask |= 1 << (64 * x + height)
    return mask | (1 << (4096 + slope))


def direct_pair_mask(context: Context, left: Point, right: Point) -> int:
    """Independent determinant scan of all affine targets and the line direction."""
    mask = 0
    for x, height in itertools.product(range(64), repeat=2):
        if collinear_direct(context, left, right, (x, height)):
            mask |= 1 << (64 * x + height)
    key = line_key(context, left, right)
    if key[0] == "N":
        mask |= 1 << (4096 + key[1])
    return mask


def terminal_geometry(
    context: Context, e: int, h0: int, anchor: str
) -> tuple[tuple[str, ...], tuple[Point, ...], int, tuple[Point, ...], tuple[Point, ...]]:
    field = context.field
    anchor_height = context.alpha if anchor == "alpha" else context.beta
    g0, g1 = context.coordinates(anchor_height)

    # At delta=b=p=1 and w=h1=0, both constant shifts k0,k1 equal one.
    c0, c1 = field.add(h0, g0), g1
    d0, d1 = field.add(c0, 1), field.add(c1, 1)
    other_e = field.add(e, 1)

    raw_labels: list[str] = []
    raw_points: list[Point] = []
    for index, parameter in enumerate(context.base):
        raw_labels.extend((f"A{index}", f"B{index}"))
        raw_points.extend(((parameter, context.alpha), (parameter, context.beta)))
    left = repair_points(context, e, 1, c0, c1)
    right = repair_points(context, other_e, 1, d0, d1)
    raw_labels.extend(f"L{i}" for i in range(8))
    raw_labels.extend(f"R{i}" for i in range(8))
    raw_points.extend(left)
    raw_points.extend(right)

    # The terminal intersections have two exact seed/repair coincidences.  Arc
    # and coverage questions live on the geometric quotient, while joined
    # labels retain the layer provenance required to interpret C298.
    label_groups: dict[Point, list[str]] = {}
    for label, point in zip(raw_labels, raw_points):
        label_groups.setdefault(point, []).append(label)
    points = tuple(label_groups)
    labels = tuple("/".join(label_groups[point]) for point in points)

    center_parameter = 0 if e == 0 else 1
    center_index = context.base.index(center_parameter)
    center_point = left[center_index] if e == 0 else right[center_index]
    terminal_center = points.index(center_point)
    assert len(points) == 30
    assert sorted(len(group) for group in label_groups.values()).count(2) == 2
    assert sum(height == 0 for _, height in points) == 1
    return labels, points, terminal_center, left, right


def line_constraints(
    context: Context, points: tuple[Point, ...]
) -> tuple[tuple[tuple[int, ...], ...], tuple[int, ...]]:
    lines: dict[tuple[str, int, int], set[int]] = defaultdict(set)
    for i, j in itertools.combinations(range(len(points)), 2):
        lines[line_key(context, points[i], points[j])].update((i, j))
    bad_lines = tuple(sorted(tuple(sorted(v)) for v in lines.values() if len(v) >= 3))
    triples = tuple(
        sorted(
            sum((list(itertools.combinations(line, 3)) for line in bad_lines), [])
        )
    )
    return bad_lines, tuple(sum(1 << i for i in edge) for edge in triples)


def direct_triples(
    context: Context, points: tuple[Point, ...]
) -> tuple[int, ...]:
    return tuple(
        sum(1 << i for i in edge)
        for edge in itertools.combinations(range(len(points)), 3)
        if collinear_direct(context, *(points[i] for i in edge))
    )


def pair_masks(
    context: Context, points: tuple[Point, ...], direct: bool = False
) -> dict[tuple[int, int], int]:
    builder = direct_pair_mask if direct else formula_pair_mask
    return {
        (i, j): builder(context, points[i], points[j])
        for i, j in itertools.combinations(range(len(points)), 2)
    }


def coverage(pair_data: dict[tuple[int, int], int], deleted: int, n: int) -> int:
    kept = ((1 << n) - 1) ^ deleted
    out = 0
    for (i, j), mask in pair_data.items():
        if (kept >> i) & 1 and (kept >> j) & 1:
            out |= mask
    return out


def requirements(points: tuple[Point, ...]) -> tuple[int, tuple[int, ...]]:
    # Affine off-conic points have h!=0.  The 64 nonvertical directions are
    # the off-conic points at infinity; the vertical direction is conic infinity.
    required = sum(
        1 << (64 * x + height)
        for x in range(64)
        for height in range(1, 64)
    )
    required |= sum(1 << (4096 + slope) for slope in range(64))
    point_bits = tuple(1 << (64 * x + height) for x, height in points)
    for bit, (_, height) in zip(point_bits, points):
        if height != 0:
            required &= ~bit
    assert required.bit_count() == 4096 - sum(height != 0 for _, height in points)
    return required, point_bits


def missing_counts(missing: int, deleted: int, point_bits: tuple[int, ...]) -> dict[str, int]:
    return {
        "old_affine": (missing & ((1 << 4096) - 1)).bit_count(),
        "old_infinity": (missing >> 4096).bit_count(),
        "deleted_vertices": sum(
            bool(missing & point_bits[i])
            for i in range(len(point_bits))
            if (deleted >> i) & 1
        ),
    }


def missing_labels(missing: int) -> list[str]:
    labels: list[str] = []
    affine = missing & ((1 << 4096) - 1)
    while affine:
        low = affine & -affine
        index = low.bit_length() - 1
        labels.append(f"affine:{index // 64}:{index % 64}")
        affine ^= low
    infinity = missing >> 4096
    while infinity:
        low = infinity & -infinity
        labels.append(f"infinity:{low.bit_length() - 1}")
        infinity ^= low
    return labels


def greedy_disjoint_lower_bound(unhit: tuple[int, ...]) -> int:
    used = 0
    count = 0
    for edge in unhit:
        if not edge & used:
            used |= edge
            count += 1
    return count


def choose_edge(unhit: tuple[int, ...], n: int, reverse: bool = False) -> tuple[int, tuple[int, ...]]:
    degrees = Counter(i for edge in unhit for i in range(n) if (edge >> i) & 1)
    edge = max(
        unhit,
        key=lambda item: (sum(degrees[i] for i in range(n) if (item >> i) & 1), item),
    )
    vertices = tuple(i for i in range(n) if (edge >> i) & 1)
    ordered = tuple(sorted(vertices, key=lambda i: ((1 if reverse else -1) * degrees[i], -i if reverse else i)))
    return edge, ordered


def minimum_transversal(
    edges: tuple[int, ...], n: int, initial_deleted: int = 0
) -> tuple[int, int, int, int]:
    total_nodes = 0

    def search(deleted: int, budget: int) -> int | None:
        nonlocal total_nodes
        total_nodes += 1
        unhit = tuple(edge for edge in edges if not edge & deleted)
        if not unhit:
            return deleted
        if budget == 0 or greedy_disjoint_lower_bound(unhit) > budget:
            return None
        _, vertices = choose_edge(unhit, n)
        for vertex in vertices:
            result = search(deleted | (1 << vertex), budget - 1)
            if result is not None:
                return result
        return None

    for budget in range(n + 1):
        before = total_nodes
        result = search(initial_deleted, budget)
        if result is not None:
            return result.bit_count(), result, total_nodes, total_nodes - before
    raise AssertionError("finite hypergraph has no transversal")


def complete_arc_search(
    edges: tuple[int, ...],
    pair_data: dict[tuple[int, int], int],
    old_required: int,
    point_bits: tuple[int, ...],
    initial_deleted: int = 0,
    reverse: bool = False,
) -> dict[str, int | bool]:
    """Exhaust every collision-transversal branch while coverage survives."""
    n = len(point_bits)
    memo: set[int] = set()
    nodes = 0
    coverage_prunes = 0

    def search(deleted: int) -> int | None:
        nonlocal nodes, coverage_prunes
        nodes += 1
        if deleted in memo:
            return None
        covered = coverage(pair_data, deleted, n)
        required = old_required
        for i, bit in enumerate(point_bits):
            height = (bit.bit_length() - 1) % 64
            if (deleted >> i) & 1 and height != 0:
                required |= bit
        if required & ~covered:
            coverage_prunes += 1
            memo.add(deleted)
            return None
        unhit = tuple(edge for edge in edges if not edge & deleted)
        if not unhit:
            return deleted
        _, vertices = choose_edge(unhit, n, reverse=reverse)
        for vertex in vertices:
            result = search(deleted | (1 << vertex))
            if result is not None:
                return result
        memo.add(deleted)
        return None

    result = search(initial_deleted)
    return {
        "solution_exists": result is not None,
        "nodes": nodes,
        "coverage_prunes": coverage_prunes,
        "memo_states": len(memo),
    }


def terminal_star(
    context: Context,
    left: tuple[Point, ...],
    right: tuple[Point, ...],
    e: int,
    anchor: str,
    center_point: Point,
) -> tuple[tuple[int, int, int], ...]:
    field = context.field
    anchor_height = context.alpha if anchor == "alpha" else context.beta
    edges: set[tuple[int, int, int]] = set()
    for u, t, r in itertools.product(context.base, repeat=3):
        if u == 0:
            continue
        s = field.add(r, u)
        ri = context.base.index(r)
        si = context.base.index(s)
        seed = (t, anchor_height)
        if collinear_direct(context, left[ri], right[si], seed):
            if len({left[ri], right[si], seed}) == 3:
                edges.add((context.base.index(t), ri, si))
    coordinate = 1 if e == 0 else 2
    expected = context.base.index(0 if e == 0 else 1)
    assert len(edges) == 7
    assert {edge[coordinate] for edge in edges} == {expected}
    assert (left if e == 0 else right)[expected] == center_point
    return tuple(sorted(edges))


def analyze_case(context: Context, e: int, h0: int, anchor: str) -> dict[str, object]:
    labels, points, center, left, right = terminal_geometry(context, e, h0, anchor)
    bad_lines, edges = line_constraints(context, points)
    replay_edges = direct_triples(context, points)
    assert set(edges) == set(replay_edges)
    formula_masks = pair_masks(context, points)
    direct_masks = pair_masks(context, points, direct=True)
    assert formula_masks == direct_masks
    old_required, point_bits = requirements(points)
    conic_deleted = sum(1 << i for i, (_, height) in enumerate(points) if height == 0)
    assert conic_deleted.bit_count() == 1
    conic_coverage = coverage(formula_masks, conic_deleted, len(points))
    conic_missing = old_required & ~conic_coverage
    assert conic_missing

    star = terminal_star(context, left, right, e, anchor, points[center])
    center_deleted = conic_deleted | (1 << center)
    center_coverage = coverage(formula_masks, center_deleted, len(points))
    center_required = old_required | point_bits[center]
    center_missing = center_required & ~center_coverage
    remaining_edges = sum(not edge & center_deleted for edge in edges)

    minimum, optimum, minimum_total_nodes, minimum_optimum_nodes = minimum_transversal(
        edges, len(points), conic_deleted
    )
    initial_unhit = tuple(edge for edge in edges if not edge & conic_deleted)
    disjoint_lower_bound = greedy_disjoint_lower_bound(initial_unhit)
    optimum_coverage = coverage(formula_masks, optimum, len(points))
    optimum_required = old_required
    for i, bit in enumerate(point_bits):
        if (optimum >> i) & 1 and points[i][1] != 0:
            optimum_required |= bit
    optimum_missing = optimum_required & ~optimum_coverage

    primary = complete_arc_search(
        edges,
        formula_masks,
        old_required,
        point_bits,
        initial_deleted=conic_deleted,
        reverse=False,
    )
    replay = complete_arc_search(
        replay_edges,
        direct_masks,
        old_required,
        point_bits,
        initial_deleted=conic_deleted,
        reverse=True,
    )
    assert primary["solution_exists"] is False
    assert replay["solution_exists"] is False

    incidence_payload = json.dumps(
        {
            "bad_lines": bad_lines,
            "edges": edges,
            "pair_masks": sorted((i, j, mask) for (i, j), mask in formula_masks.items()),
        },
        separators=(",", ":"),
    ).encode()

    return {
        "case": f"e{e}_{anchor}",
        "layer_vertices": 32,
        "geometric_points": len(points),
        "coincidence_groups": [label for label in labels if "/" in label],
        "mandatory_conic_deletion": [
            labels[i] for i in range(len(points)) if (conic_deleted >> i) & 1
        ],
        "after_mandatory_conic_deletion_missing": missing_counts(
            conic_missing, conic_deleted, point_bits
        ),
        "after_mandatory_conic_deletion_missing_points": missing_labels(conic_missing),
        "bad_lines": len(bad_lines),
        "bad_line_size_histogram": {
            str(size): count for size, count in sorted(Counter(map(len, bad_lines)).items())
        },
        "collision_triples": len(edges),
        "terminal_star": {
            "center": labels[center],
            "edges": len(star),
            "after_center_deletion_collision_triples": remaining_edges,
            "coverage_missing": missing_counts(center_missing, center_deleted, point_bits),
        },
        "maximum_arc": {
            "size": len(points) - minimum,
            "minimum_deletions": minimum,
            "initial_mandatory_plus_disjoint_edge_lower_bound": (
                conic_deleted.bit_count() + disjoint_lower_bound
            ),
            "proof_search_nodes_total": minimum_total_nodes,
            "proof_search_nodes_at_optimum_budget": minimum_optimum_nodes,
            "witness_deleted": [labels[i] for i in range(len(points)) if (optimum >> i) & 1],
            "witness_missing": missing_counts(optimum_missing, optimum, point_bits),
        },
        "complete_arc_restriction": {
            "exists": False,
            "primary_search": primary,
            "independent_direct_replay": replay,
        },
        "incidence_sha256": hashlib.sha256(incidence_payload).hexdigest(),
    }


def generate() -> dict[str, object]:
    context = build_context()
    cases = [
        analyze_case(context, 0, 0, anchor)
        for anchor in ("alpha", "beta")
    ] + [
        analyze_case(context, 1, 1, anchor)
        for anchor in ("alpha", "beta")
    ]
    return {
        "schema": "c303-partial-domain-v1",
        "field": "PG(2,64) with GF(8) layer parameters",
        "required_locus": "all projective points outside XZ=Y^2, including deleted vertices",
        "cases": cases,
        "conclusion": (
            "In each terminal geometry, admissibility forces deletion of one selected conic "
            "point, and that deletion already loses required coverage; no further restriction "
            "can restore it."
        ),
    }


def canonical_bytes(result: dict[str, object]) -> bytes:
    return (json.dumps(result, indent=2, sort_keys=True) + "\n").encode()


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def check() -> None:
    expected = OUTPUT.read_bytes()
    actual = canonical_bytes(generate())
    assert actual == expected, "generated certificate differs from tracked output"
    for line in SUMS.read_text().splitlines():
        digest, name = line.split("  ", 1)
        path = ROOT / name
        assert sha256(path) == digest, f"checksum mismatch: {name}"
    print("C303 certificate and checksums pass")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.check:
        check()
    else:
        print(canonical_bytes(generate()).decode(), end="")


if __name__ == "__main__":
    main()
