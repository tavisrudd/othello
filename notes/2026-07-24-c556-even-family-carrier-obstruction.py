#!/usr/bin/env python3
"""Exact bounded gates for the C556 orthogonal-resolution attack."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from collections import Counter, defaultdict
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
INPUT = ROOT / "notes/2026-07-24-c574-match10-rank-three-realizability.json"
OUTPUT = ROOT / "notes/2026-07-24-c556-even-family-carrier-obstruction.json"
EDGES = tuple(itertools.combinations(range(10), 2))
EDGE_INDEX = {edge: index for index, edge in enumerate(EDGES)}
FULL_MASK = (1 << len(EDGES)) - 1


def canonical_matching(raw: list[list[int]]) -> tuple[tuple[int, int], ...]:
    return tuple(sorted(tuple(sorted(edge)) for edge in raw))


def matching_mask(matching: tuple[tuple[int, int], ...]) -> int:
    return sum(1 << EDGE_INDEX[edge] for edge in matching)


def load_designs() -> dict[str, tuple[tuple[tuple[int, int], ...], ...]]:
    payload = json.loads(INPUT.read_text())
    return {
        item["name"]: tuple(
            canonical_matching(matching) for matching in item["matching_design"]
        )
        for item in payload["classes"]
    }


def validate_design(design: tuple[tuple[tuple[int, int], ...], ...]) -> None:
    assert len(design) == 63
    assert len(set(design)) == 63
    edge_counts = Counter(edge for matching in design for edge in matching)
    assert set(edge_counts) == set(EDGES)
    assert set(edge_counts.values()) == {7}
    pair_counts = Counter(
        tuple(sorted((left, right)))
        for matching in design
        for left, right in itertools.combinations(matching, 2)
    )
    assert len(pair_counts) == 630
    assert set(pair_counts.values()) == {1}


def binary_rank(rows: list[int]) -> int:
    pivots: dict[int, int] = {}
    for row in rows:
        value = row
        while value:
            pivot = value.bit_length() - 1
            if pivot in pivots:
                value ^= pivots[pivot]
            else:
                pivots[pivot] = value
                break
    return len(pivots)


def subset_mask(indices: tuple[int, ...]) -> int:
    return sum(1 << index for index in indices)


def signature_weight(
    selected: tuple[int, ...], resolutions: tuple[tuple[int, ...], ...]
) -> int:
    mask = subset_mask(selected)
    return sum((mask & subset_mask(resolution)).bit_count() % 2 for resolution in resolutions)


def enumerate_resolutions(
    design: tuple[tuple[tuple[int, int], ...], ...],
) -> tuple[tuple[int, ...], ...]:
    masks = tuple(matching_mask(matching) for matching in design)
    by_edge = {
        edge_index: tuple(
            index for index, mask in enumerate(masks) if mask & (1 << edge_index)
        )
        for edge_index in range(len(EDGES))
    }
    resolutions: set[tuple[int, ...]] = set()

    def search(covered: int, chosen: tuple[int, ...]) -> None:
        if covered == FULL_MASK:
            assert len(chosen) == 9
            resolutions.add(tuple(sorted(chosen)))
            return
        uncovered = FULL_MASK ^ covered
        edge_index = (uncovered & -uncovered).bit_length() - 1
        for block_index in by_edge[edge_index]:
            mask = masks[block_index]
            if mask & covered:
                continue
            search(covered | mask, chosen + (block_index,))

    search(0, ())
    return tuple(sorted(resolutions))


def matching_residue_witnesses(
    design: tuple[tuple[tuple[int, int], ...], ...],
) -> tuple[tuple[int, tuple[int, ...]], ...]:
    """Find 9 blocks with edge multiplicities 0,1,2 and odd residue one block."""

    masks = tuple(matching_mask(matching) for matching in design)
    witnesses: set[tuple[int, tuple[int, ...]]] = set()
    for target_index, target_mask in enumerate(masks):
        target_edges = tuple(
            edge_index
            for edge_index in range(len(EDGES))
            if target_mask & (1 << edge_index)
        )
        groups = tuple(
            tuple(
                index
                for index, mask in enumerate(masks)
                if index != target_index and mask & (1 << edge_index)
            )
            for edge_index in target_edges
        )
        assert all(len(group) == 6 for group in groups)
        disjoint = tuple(
            index for index, mask in enumerate(masks) if not (mask & target_mask)
        )
        assert len(disjoint) == 32

        four_by_xor: dict[int, list[tuple[int, ...]]] = defaultdict(list)
        for choice in itertools.combinations(disjoint, 4):
            xor_mask = 0
            for index in choice:
                xor_mask ^= masks[index]
            four_by_xor[xor_mask].append(choice)

        for first_five in itertools.product(*groups):
            assert len(set(first_five)) == 5
            counts = [0] * len(EDGES)
            xor_mask = 0
            for index in first_five:
                xor_mask ^= masks[index]
                for edge in design[index]:
                    counts[EDGE_INDEX[edge]] += 1
            if any(value > 2 for value in counts):
                continue
            desired = xor_mask ^ target_mask
            for last_four in four_by_xor.get(desired, ()):
                final_counts = counts.copy()
                for index in last_four:
                    for edge in design[index]:
                        final_counts[EDGE_INDEX[edge]] += 1
                if all(
                    value == (1 if edge_index in target_edges else 0)
                    or (edge_index not in target_edges and value == 2)
                    for edge_index, value in enumerate(final_counts)
                ):
                    selected = tuple(sorted(first_five + last_four))
                    witnesses.add((target_index, selected))
    return tuple(sorted(witnesses))


def star_residue_witnesses(
    design: tuple[tuple[tuple[int, int], ...], ...],
) -> tuple[tuple[int, tuple[int, ...]], ...]:
    """Find 9 blocks with multiplicities 0,1,2 and odd residue one vertex-star."""

    masks = tuple(matching_mask(matching) for matching in design)
    witnesses: set[tuple[int, tuple[int, ...]]] = set()
    for vertex in range(10):
        star_edges = tuple(
            edge_index
            for edge_index, edge in enumerate(EDGES)
            if vertex in edge
        )
        star_mask = sum(1 << edge_index for edge_index in star_edges)
        groups = tuple(
            tuple(
                index
                for index, mask in enumerate(masks)
                if mask & (1 << edge_index)
            )
            for edge_index in star_edges
        )
        assert all(len(group) == 7 for group in groups)

        left_by_xor: dict[int, list[tuple[int, ...]]] = defaultdict(list)
        for choice in itertools.product(*groups[:4]):
            xor_mask = 0
            for index in choice:
                xor_mask ^= masks[index] & ~star_mask
            left_by_xor[xor_mask].append(choice)

        for right in itertools.product(*groups[4:]):
            xor_mask = 0
            for index in right:
                xor_mask ^= masks[index] & ~star_mask
            for left in left_by_xor.get(xor_mask, ()):
                selected = left + right
                counts = Counter(
                    edge for index in selected for edge in design[index]
                )
                if all(
                    counts.get(edge, 0) == (1 if vertex in edge else 0)
                    or (vertex not in edge and counts.get(edge, 0) == 2)
                    for edge in EDGES
                ):
                    witnesses.add((vertex, tuple(sorted(selected))))
    return tuple(sorted(witnesses))


def gf8_multiply(left: int, right: int) -> int:
    result = 0
    value = left
    multiplier = right
    while multiplier:
        if multiplier & 1:
            result ^= value
        multiplier >>= 1
        value <<= 1
        if value & 8:
            value ^= 0b1011
    return result


def gf8_inverse(value: int) -> int:
    assert value
    return next(
        candidate
        for candidate in range(1, 8)
        if gf8_multiply(value, candidate) == 1
    )


def canonical_point(point: tuple[int, int, int]) -> tuple[int, int, int]:
    first = next(value for value in point if value)
    inverse = gf8_inverse(first)
    return tuple(gf8_multiply(inverse, value) for value in point)


def cross(
    left: tuple[int, int, int], right: tuple[int, int, int]
) -> tuple[int, int, int]:
    return (
        gf8_multiply(left[1], right[2]) ^ gf8_multiply(left[2], right[1]),
        gf8_multiply(left[2], right[0]) ^ gf8_multiply(left[0], right[2]),
        gf8_multiply(left[0], right[1]) ^ gf8_multiply(left[1], right[0]),
    )


def incident(
    line: tuple[int, int, int], point: tuple[int, int, int]
) -> bool:
    value = 0
    for coefficient, coordinate in zip(line, point):
        value ^= gf8_multiply(coefficient, coordinate)
    return value == 0


def classical_conic_residue() -> dict[str, object]:
    square = lambda value: gf8_multiply(value, value)
    arc = tuple(
        canonical_point(point)
        for point in (
            [(square(value), value, 1) for value in range(8)]
            + [(1, 0, 0), (0, 1, 0)]
        )
    )
    arc_set = set(arc)
    points = tuple(
        sorted(
            {
                canonical_point(point)
                for point in itertools.product(range(8), repeat=3)
                if point != (0, 0, 0)
            }
        )
    )
    centre_to_matching: dict[
        tuple[int, int, int], tuple[tuple[int, int], ...]
    ] = {}
    for centre in points:
        if centre in arc_set:
            continue
        matching = tuple(
            edge
            for edge in EDGES
            if incident(cross(arc[edge[0]], arc[edge[1]]), centre)
        )
        if len(matching) == 5:
            centre_to_matching[centre] = matching
    assert len(centre_to_matching) == 63

    coefficient = 3  # 1 + alpha in F_2[alpha]/(alpha^3+alpha+1)

    def on_conic(point: tuple[int, int, int]) -> bool:
        x, y, z = point
        return (
            square(x)
            ^ square(y)
            ^ square(z)
            ^ gf8_multiply(coefficient, gf8_multiply(y, z))
        ) == 0

    conic = tuple(point for point in points if on_conic(point))
    assert len(conic) == 9
    assert not (set(conic) & arc_set)
    selected = tuple(centre_to_matching[point] for point in conic)
    design = tuple(sorted(centre_to_matching.values()))
    design_index = {matching: index for index, matching in enumerate(design)}
    selected_indices = tuple(sorted(design_index[matching] for matching in selected))
    resolutions = enumerate_resolutions(design)
    intersection_histogram = Counter(
        len(set(resolution) & set(selected_indices)) for resolution in resolutions
    )
    counts = Counter(edge for matching in selected for edge in matching)
    odd_edges = tuple(sorted(edge for edge in EDGES if counts[edge] % 2))
    nucleus = (1, 0, 0)
    assert nucleus in arc_set
    nucleus_index = arc.index(nucleus)
    expected_star = tuple(
        edge for edge in EDGES if nucleus_index in edge
    )
    assert odd_edges == expected_star
    assert set(counts.values()) <= {1, 2}
    histogram = Counter(counts.get(edge, 0) for edge in EDGES)
    return {
        "conic_points": [list(point) for point in conic],
        "nucleus_arc_index": nucleus_index,
        "edge_multiplicity_histogram": {
            str(key): histogram[key] for key in sorted(histogram)
        },
        "odd_residue_edges": [list(edge) for edge in odd_edges],
        "selected_block_indices": list(selected_indices),
        "resolution_intersection_histogram": {
            str(key): intersection_histogram[key]
            for key in sorted(intersection_histogram)
        },
        "minimum_block_replacements_to_resolution": (
            9 - max(intersection_histogram)
        ),
        "resolution_signature_weight": signature_weight(
            selected_indices, resolutions
        ),
    }


def build_payload() -> dict[str, object]:
    designs = load_designs()
    classes: dict[str, object] = {}
    for name, design in designs.items():
        validate_design(design)
        resolutions = enumerate_resolutions(design)
        residue_witnesses = matching_residue_witnesses(design)
        star_witnesses = star_residue_witnesses(design)
        target_counts = Counter(target for target, _ in residue_witnesses)
        star_counts = Counter(target for target, _ in star_witnesses)
        matching_signature_weights = Counter(
            signature_weight(selected, resolutions)
            for _, selected in residue_witnesses
        )
        star_signature_weights = Counter(
            signature_weight(selected, resolutions)
            for _, selected in star_witnesses
        )
        classes[name] = {
            "resolution_count": len(resolutions),
            "resolution_samples": [list(item) for item in resolutions[:3]],
            "resolution_binary_rank": binary_rank(
                [subset_mask(resolution) for resolution in resolutions]
            ),
            "matching_residue_witness_count": len(residue_witnesses),
            "matching_residue_target_count": len(target_counts),
            "matching_residue_target_histogram": {
                str(count): sum(1 for value in target_counts.values() if value == count)
                for count in sorted(set(target_counts.values()))
            },
            "matching_residue_sample": (
                {
                    "target": residue_witnesses[0][0],
                    "selected_blocks": list(residue_witnesses[0][1]),
                }
                if residue_witnesses
                else None
            ),
            "matching_residue_resolution_signature_weight_histogram": {
                str(weight): count
                for weight, count in sorted(matching_signature_weights.items())
            },
            "star_residue_witness_count": len(star_witnesses),
            "star_residue_vertex_histogram": {
                str(count): sum(1 for value in star_counts.values() if value == count)
                for count in sorted(set(star_counts.values()))
            },
            "star_residue_sample": (
                {
                    "vertex": star_witnesses[0][0],
                    "selected_blocks": list(star_witnesses[0][1]),
                }
                if star_witnesses
                else None
            ),
            "star_residue_resolution_signature_weight_histogram": {
                str(weight): count
                for weight, count in sorted(star_signature_weights.items())
            },
        }
    return {
        "schema": "c556-orthogonal-resolution-gate-v1",
        "input": {
            "path": str(INPUT.relative_to(ROOT)),
            "sha256": hashlib.sha256(INPUT.read_bytes()).hexdigest(),
        },
        "classes": classes,
        "classical_conic_residue": classical_conic_residue(),
    }


def canonical_bytes(payload: dict[str, object]) -> bytes:
    return (json.dumps(payload, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    generated = canonical_bytes(build_payload())
    if args.write:
        OUTPUT.write_bytes(generated)
        print(f"wrote {OUTPUT}")
    else:
        expected = OUTPUT.read_bytes()
        if generated != expected:
            raise SystemExit("generated output differs from committed certificate")
        print("C556 certificate check: PASS")


if __name__ == "__main__":
    main()
