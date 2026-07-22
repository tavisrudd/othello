#!/usr/bin/env python3
"""Extract the q=8 colour-Frobenius cycles from the frozen C478 controls."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import itertools
import json
import tempfile
from collections import defaultdict
from pathlib import Path


STEM = "2026-07-22-c484-coherent-semilinear-descent"
SCHEMA = "c484-coherent-semilinear-descent-v1"
ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "notes" / f"{STEM}.json"
C398_STEM = "2026-07-20-c398-conic-deep-hole-classification"
C474_STEM = "2026-07-22-c474-reed-solomon-decorated-deep-holes"
C478_STEM = "2026-07-22-c478-exceptional-family-controls"
PERMUTATIONS = tuple(itertools.permutations(range(6)))


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def load_json(stem: str) -> dict[str, object]:
    return json.loads((ROOT / "notes" / f"{stem}.json").read_text())


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def canonical_diagonal_signature(c478, module, field, parent, locus):
    return c478.canonical_galois_equivariant_family(module, field, parent, locus)


def colour_frobenius_signature(c478, module, field, parent, locus, power: int):
    """Apply Frobenius to colours only, holding the ordered literal locus fixed."""
    return min(
        tuple(
            tuple(field.frobenius(x, power) for x in c478.atlas(
                module, field, parent, syndrome, permutation
            ))
            for syndrome in locus
        )
        for permutation in PERMUTATIONS
    )


def cycle_partition(permutation: list[int]) -> list[list[int]]:
    unseen = set(range(len(permutation)))
    cycles = []
    while unseen:
        start = min(unseen)
        cycle = []
        current = start
        while current not in cycle:
            cycle.append(current)
            unseen.remove(current)
            current = permutation[current]
        assert current == start
        cycles.append(cycle)
    return cycles


def compose(left, right):
    return tuple(left[right[index]] for index in range(len(left)))


def generated_group(generators, degree: int):
    identity = tuple(range(degree))
    group = {identity}
    frontier = [identity]
    while frontier:
        current = frontier.pop()
        for generator in generators:
            product = compose(generator, current)
            if product not in group:
                group.add(product)
                frontier.append(product)
    return group


def signature_partition(signatures):
    fibres = defaultdict(list)
    for index, signature in enumerate(signatures):
        fibres[signature].append(index)
    return sorted(sorted(part) for part in fibres.values())


def generate() -> dict[str, object]:
    c398 = load_module("c398_for_c484", ROOT / "notes" / f"{C398_STEM}.py")
    c474 = load_module("c474_for_c484", ROOT / "notes" / f"{C474_STEM}.py")
    c478 = load_module("c478_for_c484", ROOT / "notes" / f"{C478_STEM}.py")
    c398_data = load_json(C398_STEM)
    c478_data = load_json(C478_STEM)

    field_record = next(row for row in c398_data["fields"] if row["q"] == 8)
    survivor = field_record["survivors"][0]
    field = c398.FiniteField(8)
    support = tuple(tuple(point) for point in survivor["arc"])
    locus = tuple(tuple(point) for point in survivor["locus"])
    full_locus_group = c474.locus_stabilizer(c398, field, locus)

    def apply(transformation, point):
        return c474.apply_semilinear(c398, field, transformation, point)

    parents = tuple(sorted({
        tuple(sorted(apply(transformation, point) for point in support))
        for transformation in full_locus_group
    }))
    signatures = [
        canonical_diagonal_signature(c478, c398, field, parent, locus)
        for parent in parents
    ]
    assert len(parents) == len(set(signatures)) == 6
    signature_index = {signature: index for index, signature in enumerate(signatures)}

    colour_permutations = []
    for power in range(field.degree):
        permutation = [
            signature_index[colour_frobenius_signature(
                c478, c398, field, parent, locus, power
            )]
            for parent in parents
        ]
        assert sorted(permutation) == list(range(6))
        colour_permutations.append(permutation)

    identity, generator, square = colour_permutations
    assert identity == list(range(6))
    assert [generator[generator[index]] for index in range(6)] == square
    assert [generator[square[index]] for index in range(6)] == identity
    cycles = cycle_partition(generator)
    assert sorted(map(len, cycles)) == [3, 3]

    restriction_partitions = {
        size: signature_partition([
            canonical_diagonal_signature(c478, c398, field, parent, locus[:size])
            for parent in parents
        ])
        for size in (1, 2, 3)
    }
    assert restriction_partitions[1] == [list(range(6))]
    two_centre_pairs = restriction_partitions[2]
    assert sorted(map(len, two_centre_pairs)) == [2, 2, 2]
    assert restriction_partitions[3] == [[index] for index in range(6)]
    pairing = list(range(6))
    for left, right in two_centre_pairs:
        pairing[left] = right
        pairing[right] = left
    conjugate = [pairing[generator[pairing[index]]] for index in range(6)]
    action_group = generated_group((tuple(generator), tuple(pairing)), 6)
    generated_orbit = {0}
    while True:
        expanded = generated_orbit | {generator[i] for i in generated_orbit} | {
            pairing[i] for i in generated_orbit
        }
        if expanded == generated_orbit:
            break
        generated_orbit = expanded
    assert generated_orbit == set(range(6))
    relation = (
        "inverts" if conjugate == square else
        "commutes" if conjugate == generator else
        "neither"
    )
    assert relation == "commutes"
    assert len(action_group) == 6
    c3_orbit_index = {
        parent: orbit_index
        for orbit_index, orbit in enumerate(cycles)
        for parent in orbit
    }
    c2_orbit_index = {
        parent: orbit_index
        for orbit_index, orbit in enumerate(two_centre_pairs)
        for parent in orbit
    }
    product_coordinates = [
        [c3_orbit_index[parent], c2_orbit_index[parent]]
        for parent in range(6)
    ]
    assert len(set(map(tuple, product_coordinates))) == 6

    q8_record = c478_data["c398_non_grs_controls"][0]
    assert q8_record["q"] == 8
    assert q8_record["galois_equivariant_coherent_parent_signature_fibre_sizes"] == [1] * 6
    assert q8_record["coherently_unlabelled_atlas_parent_signature_fibre_sizes"] == [3, 3]

    input_paths = [
        ROOT / "notes" / f"{C398_STEM}.py",
        ROOT / "notes" / f"{C398_STEM}.json",
        ROOT / "notes" / f"{C474_STEM}.py",
        ROOT / "notes" / f"{C474_STEM}.json",
        ROOT / "notes" / f"{C478_STEM}.py",
        ROOT / "notes" / f"{C478_STEM}.json",
    ]
    return {
        "schema": SCHEMA,
        "task": "C484",
        "frozen_inputs": [
            {
                "path": str(path.relative_to(ROOT)),
                "bytes": path.stat().st_size,
                "sha256": sha256(path),
            }
            for path in input_paths
        ],
        "q8_colour_frobenius": {
            "field_degree": field.degree,
            "literal_child_size": len(locus),
            "fixed_child_parent_count": len(parents),
            "parent_order": [
                [[int(coordinate) for coordinate in point] for point in parent]
                for parent in parents
            ],
            "colour_permutations_by_power": colour_permutations,
            "generator_cycles": cycles,
            "generator_cycle_lengths": sorted(map(len, cycles)),
            "two_centre_residual_pairs": two_centre_pairs,
            "two_centre_pairing_permutation": pairing,
            "pairing_conjugate_of_generator": conjugate,
            "pairing_relation_to_generator": relation,
            "generated_group_order": len(action_group),
            "generated_action_is_transitive": True,
            "generated_action": "regular C6 = C3 x C2 action on the six parents",
            "restriction_partitions_by_centre_count": {
                str(size): partition for size, partition in restriction_partitions.items()
            },
            "c3_by_c2_product_coordinates_by_parent": product_coordinates,
            "information_loss_lattice": {
                "one_centre": "quotient by C6: one fibre of size 6",
                "two_centres": "quotient by residual C2: three fibres of size 2",
                "colour_orbit": "quotient by colour C3: two fibres of size 3",
                "three_centres_equivariant": "quotient by the trivial subgroup: six singletons",
            },
            "equivariant_signature_fibre_sizes": [1] * 6,
            "colour_orbit_quotient_fibre_sizes": sorted(map(len, cycles)),
            "domain_action": "literal syndrome ordering held fixed; Frobenius acts on atlas field colours only",
        },
        "interpretation": (
            "Colour-only Frobenius acts freely as two C3 orbits on the six coherent q=8 parent signatures. "
            "Retaining the equivariant colour object gives six singletons; taking its colour-orbit "
            "coequalizer gives the two frozen fibres of size three.  The frozen two-centre residual "
            "pairing commutes with the C3 generator and together they give a regular C6 = C3 x C2 "
            "action on the six parents.  This residual C2 is the frozen two-centre ambiguity; the "
            "calculation does not identify it with the ambient Gale deck involution."
        ),
    }


def canonical_bytes(value: dict[str, object]) -> bytes:
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    payload = canonical_bytes(generate())
    if args.check:
        assert OUTPUT.read_bytes() == payload
        with tempfile.TemporaryDirectory() as directory:
            temporary = Path(directory) / OUTPUT.name
            temporary.write_bytes(payload)
            assert temporary.read_bytes() == OUTPUT.read_bytes()
        print(f"verified {OUTPUT.relative_to(ROOT)}")
    else:
        OUTPUT.write_bytes(payload)
        print(f"wrote {OUTPUT.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
