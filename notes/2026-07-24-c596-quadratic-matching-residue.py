#!/usr/bin/env python3
"""Exact mod-4 quadratic signatures of the C556 ten-point residue witnesses."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import itertools
import json
from collections import Counter, defaultdict
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
C556_SCRIPT = ROOT / "notes/2026-07-24-c556-even-family-carrier-obstruction.py"
C556_OUTPUT = ROOT / "notes/2026-07-24-c556-even-family-carrier-obstruction.json"
OUTPUT = ROOT / "notes/2026-07-24-c596-quadratic-matching-residue.json"


def load_c556():
    spec = importlib.util.spec_from_file_location("c556_certificate", C556_SCRIPT)
    if spec is None or spec.loader is None:
        raise RuntimeError("cannot load C556 certificate generator")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def binary_basis(vectors: tuple[int, ...]) -> tuple[int, ...]:
    pivots: dict[int, int] = {}
    for vector in vectors:
        value = vector
        while value:
            pivot = value.bit_length() - 1
            if pivot in pivots:
                value ^= pivots[pivot]
            else:
                pivots[pivot] = value
                break
    return tuple(pivots[pivot] for pivot in sorted(pivots, reverse=True))


def span(basis: tuple[int, ...]) -> tuple[int, ...]:
    words = [0]
    for vector in basis:
        words += [word ^ vector for word in words]
    return tuple(sorted(words))


def quadratic_signature(
    masks: tuple[int, ...], selected: tuple[int, ...]
) -> tuple[int, int, str, tuple[int, int, int, int]]:
    """Return intrinsic data for q(v)=wt(v) mod 4 on the selected binary span."""

    basis = binary_basis(tuple(masks[index] for index in selected))
    words = span(basis)
    radical = tuple(
        word
        for word in words
        if all((word & vector).bit_count() % 2 == 0 for vector in basis)
    )
    q_radical = {word.bit_count() % 4 for word in radical}
    if q_radical == {0}:
        radical_type = "q_zero"
    elif q_radical <= {0, 2}:
        radical_type = "q_two"
    else:
        radical_type = "q_odd"
    q_histogram = tuple(
        sum(1 for word in words if word.bit_count() % 4 == residue)
        for residue in range(4)
    )
    return (
        len(basis),
        len(radical).bit_length() - 1,
        radical_type,
        q_histogram,
    )


def signature_key(
    signature: tuple[int, int, str, tuple[int, int, int, int]]
) -> str:
    dimension, radical_dimension, radical_type, histogram = signature
    return (
        f"dim={dimension};rad={radical_dimension};{radical_type};"
        f"q={','.join(str(value) for value in histogram)}"
    )


def centered_signature(
    masks: tuple[int, ...], selected: tuple[int, ...], residue_mask: int
) -> tuple[int, int, str, tuple[int, int], str]:
    """Quadratic signature after centering every odd block at the odd residue."""

    basis = binary_basis(
        tuple(masks[index] ^ residue_mask for index in selected)
    )
    words = span(basis)
    assert all(word.bit_count() % 2 == 0 for word in words)
    radical = tuple(
        word
        for word in words
        if all((word & vector).bit_count() % 2 == 0 for vector in basis)
    )
    radical_values = {(word.bit_count() // 2) % 2 for word in radical}
    radical_type = "q_zero" if radical_values == {0} else "q_one"
    histogram = tuple(
        sum(1 for word in words if (word.bit_count() // 2) % 2 == value)
        for value in range(2)
    )
    gauss_sum = histogram[0] - histogram[1]
    if radical_type == "q_one":
        arf = "undefined_radical"
        assert gauss_sum == 0
    else:
        arf = "0" if gauss_sum > 0 else "1"
        expected = 1 << ((len(basis) + len(radical).bit_length() - 1) // 2)
        assert abs(gauss_sum) == expected
    return (
        len(basis),
        len(radical).bit_length() - 1,
        radical_type,
        histogram,
        arf,
    )


def centered_key(
    signature: tuple[int, int, str, tuple[int, int], str]
) -> str:
    dimension, radical_dimension, radical_type, histogram, arf = signature
    return (
        f"dim={dimension};rad={radical_dimension};{radical_type};"
        f"q={histogram[0]},{histogram[1]};arf={arf}"
    )


def summarize(
    masks: tuple[int, ...],
    witnesses: tuple[tuple[int, tuple[int, ...]], ...],
    residue_masks: dict[int, int],
) -> tuple[dict[str, int], dict[str, int], dict[str, dict[str, int]]]:
    total = Counter()
    centered_total = Counter()
    by_target: dict[int, Counter[str]] = defaultdict(Counter)
    for target, selected in witnesses:
        key = signature_key(quadratic_signature(masks, selected))
        total[key] += 1
        by_target[target][key] += 1
        centered_total[
            centered_key(
                centered_signature(masks, selected, residue_masks[target])
            )
        ] += 1
    return (
        dict(sorted(total.items())),
        dict(sorted(centered_total.items())),
        {
            str(target): dict(sorted(histogram.items()))
            for target, histogram in sorted(by_target.items())
        },
    )


def classical_conic_instance(c556):
    square = lambda value: c556.gf8_multiply(value, value)
    arc = tuple(
        c556.canonical_point(point)
        for point in (
            [(square(value), value, 1) for value in range(8)]
            + [(1, 0, 0), (0, 1, 0)]
        )
    )
    arc_set = set(arc)
    points = tuple(
        sorted(
            {
                c556.canonical_point(point)
                for point in itertools.product(range(8), repeat=3)
                if point != (0, 0, 0)
            }
        )
    )
    centre_to_matching = {}
    for centre in points:
        if centre in arc_set:
            continue
        matching = tuple(
            edge
            for edge in c556.EDGES
            if c556.incident(
                c556.cross(arc[edge[0]], arc[edge[1]]), centre
            )
        )
        if len(matching) == 5:
            centre_to_matching[centre] = matching
    coefficient = 3
    conic = tuple(
        point
        for point in points
        if (
            square(point[0])
            ^ square(point[1])
            ^ square(point[2])
            ^ c556.gf8_multiply(
                coefficient, c556.gf8_multiply(point[1], point[2])
            )
        )
        == 0
    )
    design = tuple(sorted(centre_to_matching.values()))
    design_index = {matching: index for index, matching in enumerate(design)}
    selected = tuple(
        sorted(design_index[centre_to_matching[point]] for point in conic)
    )
    return design, selected, arc.index((1, 0, 0))


def all_disjoint_conic_signatures(c556) -> dict[str, object]:
    square = lambda value: c556.gf8_multiply(value, value)
    arc = tuple(
        c556.canonical_point(point)
        for point in (
            [(square(value), value, 1) for value in range(8)]
            + [(1, 0, 0), (0, 1, 0)]
        )
    )
    arc_set = set(arc)
    points = tuple(
        sorted(
            {
                c556.canonical_point(point)
                for point in itertools.product(range(8), repeat=3)
                if point != (0, 0, 0)
            }
        )
    )
    centre_to_matching = {}
    for centre in points:
        if centre in arc_set:
            continue
        matching = tuple(
            edge
            for edge in c556.EDGES
            if c556.incident(
                c556.cross(arc[edge[0]], arc[edge[1]]), centre
            )
        )
        if len(matching) == 5:
            centre_to_matching[centre] = matching
    design = tuple(sorted(centre_to_matching.values()))
    design_index = {matching: index for index, matching in enumerate(design)}
    masks = tuple(c556.matching_mask(matching) for matching in design)

    def evaluate(coefficients, point):
        x, y, z = point
        monomials = (
            square(x),
            square(y),
            square(z),
            c556.gf8_multiply(x, y),
            c556.gf8_multiply(x, z),
            c556.gf8_multiply(y, z),
        )
        value = 0
        for coefficient, monomial in zip(coefficients, monomials):
            value ^= c556.gf8_multiply(coefficient, monomial)
        return value

    signature_histogram = Counter()
    signature_by_residue_type: dict[str, Counter[str]] = defaultdict(Counter)
    residue_type_histogram = Counter()
    nucleus_histogram = Counter()
    conic_count = 0
    for first_nonzero in range(6):
        for tail in itertools.product(range(8), repeat=5 - first_nonzero):
            coefficients = (
                (0,) * first_nonzero + (1,) + tuple(tail)
            )
            conic = tuple(
                point for point in points if evaluate(coefficients, point) == 0
            )
            if len(conic) != 9 or set(conic) & arc_set:
                continue
            if any(
                c556.incident(c556.cross(left, middle), right)
                for left, middle, right in itertools.combinations(conic, 3)
            ):
                continue
            selected = tuple(
                sorted(
                    design_index[centre_to_matching[point]] for point in conic
                )
            )
            residue = 0
            for index in selected:
                residue ^= masks[index]
            nuclei = tuple(
                vertex
                for vertex in range(10)
                if residue
                == sum(
                    1 << edge_index
                    for edge_index, edge in enumerate(c556.EDGES)
                    if vertex in edge
                )
            )
            matching_targets = tuple(
                index for index, mask in enumerate(masks) if residue == mask
            )
            assert (len(nuclei), len(matching_targets)) in {(1, 0), (0, 1)}
            if nuclei:
                residue_type = "star"
                nucleus_histogram[nuclei[0]] += 1
            else:
                residue_type = "matching"
            key = centered_key(
                centered_signature(masks, selected, residue)
            )
            signature_histogram[key] += 1
            signature_by_residue_type[residue_type][key] += 1
            residue_type_histogram[residue_type] += 1
            conic_count += 1
    return {
        "projective_quadratic_forms_checked": (8**6 - 1) // 7,
        "disjoint_nondegenerate_conic_count": conic_count,
        "centered_arf_signature_histogram": dict(
            sorted(signature_histogram.items())
        ),
        "centered_arf_signatures_by_residue_type": {
            residue_type: dict(sorted(histogram.items()))
            for residue_type, histogram in sorted(
                signature_by_residue_type.items()
            )
        },
        "residue_type_histogram": dict(sorted(residue_type_histogram.items())),
        "nucleus_vertex_histogram": {
            str(vertex): count
            for vertex, count in sorted(nucleus_histogram.items())
        },
    }


def build_payload() -> dict[str, object]:
    c556 = load_c556()
    designs = c556.load_designs()
    classes: dict[str, object] = {}
    cached_c556 = json.loads(C556_OUTPUT.read_text())
    for name, design in designs.items():
        c556.validate_design(design)
        masks = tuple(c556.matching_mask(matching) for matching in design)
        matching = c556.matching_residue_witnesses(design)
        star = c556.star_residue_witnesses(design)
        matching_residues = {index: mask for index, mask in enumerate(masks)}
        star_residues = {
            vertex: sum(
                1 << edge_index
                for edge_index, edge in enumerate(c556.EDGES)
                if vertex in edge
            )
            for vertex in range(10)
        }
        (
            matching_total,
            matching_centered,
            matching_by_target,
        ) = summarize(masks, matching, matching_residues)
        star_total, star_centered, star_by_vertex = summarize(
            masks, star, star_residues
        )
        classes[name] = {
            "matching_witness_count": len(matching),
            "matching_signature_histogram": matching_total,
            "matching_centered_arf_histogram": matching_centered,
            "matching_signatures_by_target": matching_by_target,
            "star_witness_count": len(star),
            "star_signature_histogram": star_total,
            "star_centered_arf_histogram": star_centered,
            "star_signatures_by_vertex": star_by_vertex,
        }

    conic_design, conic_indices, conic_vertex = classical_conic_instance(c556)
    assert list(conic_indices) == cached_c556[
        "classical_conic_residue"
    ]["selected_block_indices"]
    classical_masks = tuple(
        c556.matching_mask(matching)
        for matching in conic_design
    )
    conic_signature = signature_key(
        quadratic_signature(classical_masks, conic_indices)
    )
    assert conic_vertex == cached_c556[
        "classical_conic_residue"
    ]["nucleus_arc_index"]
    conic_star_mask = sum(
        1 << edge_index
        for edge_index, edge in enumerate(c556.EDGES)
        if conic_vertex in edge
    )
    conic_centered_signature = centered_key(
        centered_signature(classical_masks, conic_indices, conic_star_mask)
    )

    classical_matching = set(
        classes["classical-hyperoval"]["matching_signature_histogram"]
    )
    mathon_matching = set(
        classes["mathon-nonhyperoval"]["matching_signature_histogram"]
    )
    classical_star = set(
        classes["classical-hyperoval"]["star_signature_histogram"]
    )
    mathon_star = set(
        classes["mathon-nonhyperoval"]["star_signature_histogram"]
    )
    classical_matching_centered = set(
        classes["classical-hyperoval"]["matching_centered_arf_histogram"]
    )
    mathon_matching_centered = set(
        classes["mathon-nonhyperoval"]["matching_centered_arf_histogram"]
    )
    classical_star_centered = set(
        classes["classical-hyperoval"]["star_centered_arf_histogram"]
    )
    mathon_star_centered = set(
        classes["mathon-nonhyperoval"]["star_centered_arf_histogram"]
    )
    all_conics = all_disjoint_conic_signatures(c556)
    conic_matching_centered = set(
        all_conics["centered_arf_signatures_by_residue_type"]["matching"]
    )
    conic_star_centered = set(
        all_conics["centered_arf_signatures_by_residue_type"]["star"]
    )

    return {
        "schema": "c596-quadratic-matching-residue-v1",
        "inputs": {
            "c556_script": {
                "path": str(C556_SCRIPT.relative_to(ROOT)),
                "sha256": hashlib.sha256(C556_SCRIPT.read_bytes()).hexdigest(),
            },
            "c556_output": {
                "path": str(C556_OUTPUT.relative_to(ROOT)),
                "sha256": hashlib.sha256(C556_OUTPUT.read_bytes()).hexdigest(),
            },
        },
        "quadratic_form": {
            "ambient_space": "binary edge space of K_10",
            "definition": "q(v) = HammingWeight(v) mod 4",
            "polar_form": "b(u,v) = support-intersection parity",
            "signature_fields": [
                "binary span dimension",
                "polar radical dimension",
                "q restricted to the radical",
                "counts of q-values 0,1,2,3",
            ],
        },
        "classes": classes,
        "classical_all_disjoint_conics": all_conics,
        "comparison": {
            "matching_signature_intersection": sorted(
                classical_matching & mathon_matching
            ),
            "matching_signature_only_classical": sorted(
                classical_matching - mathon_matching
            ),
            "matching_signature_only_mathon": sorted(
                mathon_matching - classical_matching
            ),
            "star_signature_intersection": sorted(classical_star & mathon_star),
            "star_signature_only_classical": sorted(
                classical_star - mathon_star
            ),
            "star_signature_only_mathon": sorted(mathon_star - classical_star),
            "classical_conic_star_signature": conic_signature,
            "classical_conic_signature_occurs_in_mathon_star": (
                conic_signature in mathon_star
            ),
            "matching_centered_arf_intersection": sorted(
                classical_matching_centered & mathon_matching_centered
            ),
            "matching_centered_arf_only_classical": sorted(
                classical_matching_centered - mathon_matching_centered
            ),
            "matching_centered_arf_only_mathon": sorted(
                mathon_matching_centered - classical_matching_centered
            ),
            "star_centered_arf_intersection": sorted(
                classical_star_centered & mathon_star_centered
            ),
            "star_centered_arf_only_classical": sorted(
                classical_star_centered - mathon_star_centered
            ),
            "star_centered_arf_only_mathon": sorted(
                mathon_star_centered - classical_star_centered
            ),
            "classical_conic_centered_arf_signature": (
                conic_centered_signature
            ),
            "classical_conic_centered_arf_occurs_in_mathon_star": (
                conic_centered_signature in mathon_star_centered
            ),
            "geometric_matching_centered_arf_intersection_with_mathon": sorted(
                conic_matching_centered & mathon_matching_centered
            ),
            "geometric_star_centered_arf_intersection_with_mathon": sorted(
                conic_star_centered & mathon_star_centered
            ),
        },
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
        if generated != OUTPUT.read_bytes():
            raise SystemExit("generated output differs from committed certificate")
        print("C596 certificate check: PASS")


if __name__ == "__main__":
    main()
