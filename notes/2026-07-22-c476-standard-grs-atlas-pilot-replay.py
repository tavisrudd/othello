#!/usr/bin/env python3
"""Independent frame-normalization replay of the C476 certificate."""

from __future__ import annotations

import hashlib
import importlib.util
import json
from collections import Counter, defaultdict
from itertools import combinations, permutations, product
from math import comb
from pathlib import Path


STEM = "2026-07-22-c476-standard-grs-atlas-pilot"
SCHEMA = "c476-standard-grs-atlas-pilot-v1"
UPSTREAM = "2026-07-20-c398-conic-deep-hole-classification"
FIELDS = (5, 7, 8, 9, 11)


def import_field_model(root: Path):
    path = root / "notes" / f"{UPSTREAM}.py"
    spec = importlib.util.spec_from_file_location("c398_field_replay", path)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def add_many(field, values) -> int:
    total = 0
    for value in values:
        total = field.add(total, value)
    return total


def projectivize(field, vector: tuple[int, ...]) -> tuple[int, ...]:
    multiplier = field.inverse(next(value for value in vector if value))
    return tuple(field.mul(multiplier, value) for value in vector)


def vector_of(q: int, point: int) -> tuple[int, int]:
    return (0, 1) if point == q else (1, point)


def point_of(field, vector: tuple[int, int]) -> int:
    return field.q if vector[0] == 0 else field.div(vector[1], vector[0])


def bracket(field, left: int, right: int) -> int:
    x, y = vector_of(field.q, left)
    X, Y = vector_of(field.q, right)
    return field.sub(field.mul(x, Y), field.mul(y, X))


def frobenius_point(field, point: int, power: int) -> int:
    return point if point == field.q else field.frobenius(point, power)


def frame_coordinate(field, frame: tuple[int, int, int], point: int) -> int:
    zero, one, infinity = frame
    x_prime = field.mul(bracket(field, zero, one), bracket(field, infinity, point))
    y_prime = field.mul(bracket(field, infinity, one), bracket(field, zero, point))
    assert x_prime or y_prime
    return point_of(field, (x_prime, y_prime))


def canonical_support(field, support: tuple[int, ...]) -> tuple[int, ...]:
    candidates = []
    for power in range(field.degree):
        twisted = tuple(frobenius_point(field, point, power) for point in support)
        for frame in permutations(twisted, 3):
            candidates.append(tuple(sorted(frame_coordinate(field, frame, point) for point in twisted)))
    return min(candidates)


def support_representatives(field) -> tuple[tuple[int, ...], ...]:
    return tuple(
        sorted(
            {
                canonical_support(field, support)
                for support in combinations(range(field.q + 1), 6)
            }
        )
    )


def support_stabilizer(field, support: tuple[int, ...]) -> tuple[dict[str, object], ...]:
    points = tuple(range(field.q + 1))
    source = support[:3]
    elements: dict[tuple[int, ...], dict[str, object]] = {}
    for power in range(field.degree):
        twisted_points = tuple(frobenius_point(field, point, power) for point in points)
        twisted_source = tuple(frobenius_point(field, point, power) for point in source)
        source_coordinates = {
            original: frame_coordinate(field, twisted_source, twisted)
            for original, twisted in zip(points, twisted_points)
        }
        for target in permutations(support, 3):
            target_coordinates = {
                point: frame_coordinate(field, target, point) for point in points
            }
            inverse_target = {coordinate: point for point, coordinate in target_coordinates.items()}
            assert len(inverse_target) == field.q + 1
            point_permutation = tuple(inverse_target[source_coordinates[point]] for point in points)
            if tuple(sorted(point_permutation[point] for point in support)) != support:
                continue
            support_permutation = tuple(support.index(point_permutation[point]) for point in support)
            elements[point_permutation] = {
                "frobenius": power,
                "point_permutation": point_permutation,
                "support_permutation": support_permutation,
            }
    return tuple(elements[key] for key in sorted(elements))


def projective_plane(field) -> tuple[tuple[int, int, int], ...]:
    return tuple(
        sorted(
            {
                projectivize(field, vector)
                for vector in product(range(field.q), repeat=3)
                if any(vector)
            }
        )
    )


def pairing(field, syndrome: tuple[int, int, int], left: int, right: int) -> int:
    u0, u1, u2 = syndrome
    x, y = vector_of(field.q, left)
    X, Y = vector_of(field.q, right)
    return add_many(
        field,
        (
            field.mul(u2, field.mul(x, X)),
            field.neg(field.mul(u1, field.add(field.mul(x, Y), field.mul(X, y)))),
            field.mul(u0, field.mul(y, Y)),
        ),
    )


def deepest(field, support: tuple[int, ...], syndrome: tuple[int, int, int]) -> bool:
    return all(pairing(field, syndrome, support[i], support[j]) for i, j in combinations(range(6), 2))


def ordered_ratios(field, support, syndrome, indices: tuple[int, int, int, int]) -> tuple[int, int]:
    i, j, k, ell = indices
    numerator = field.mul(
        pairing(field, syndrome, support[i], support[j]),
        pairing(field, syndrome, support[k], support[ell]),
    )
    first = field.mul(
        pairing(field, syndrome, support[i], support[k]),
        pairing(field, syndrome, support[j], support[ell]),
    )
    second = field.mul(
        pairing(field, syndrome, support[i], support[ell]),
        pairing(field, syndrome, support[j], support[k]),
    )
    return field.div(numerator, first), field.div(numerator, second)


def transformed_atlas(field, support, syndrome, element) -> tuple[int, ...]:
    permutation = element["support_permutation"]
    power = element["frobenius"]
    assert isinstance(permutation, tuple) and isinstance(power, int)
    inverse = tuple(permutation.index(index) for index in range(6))
    answer = []
    for target in combinations(range(6), 4):
        source = tuple(inverse[index] for index in target)
        answer.extend(field.frobenius(value, power) for value in ordered_ratios(field, support, syndrome, source))
    return tuple(answer)


def rank_of(field, syndrome: tuple[int, int, int]) -> int:
    u0, u1, u2 = syndrome
    return 2 if field.sub(field.mul(u0, u2), field.mul(u1, u1)) else 1


def delta_class(field, syndrome: tuple[int, int, int]) -> str:
    u0, u1, u2 = syndrome
    determinant = field.sub(field.mul(u0, u2), field.mul(u1, u1))
    if determinant == 0:
        return "zero"
    if field.p == 2:
        return "nonzero-square"
    return "square" if field.pow(determinant, (field.q - 1) // 2) == 1 else "nonsquare"


def radical_of(field, syndrome: tuple[int, int, int]) -> int:
    roots = [
        point for point in range(field.q + 1)
        if pairing(field, syndrome, point, 0) == 0
        and pairing(field, syndrome, point, field.q) == 0
    ]
    assert len(roots) == 1
    return roots[0]


def atlas_key(field, support, syndrome, stabilizer) -> tuple[int, ...]:
    return min(transformed_atlas(field, support, syndrome, element) for element in stabilizer)


def radical_key(field, syndrome, stabilizer) -> int:
    point = radical_of(field, syndrome)
    return min(element["point_permutation"][point] for element in stabilizer)  # type: ignore[index]


def cycle_type(permutation: tuple[int, ...]) -> tuple[int, ...]:
    unseen = set(range(len(permutation)))
    lengths = []
    while unseen:
        first = min(unseen)
        point = first
        length = 0
        while point in unseen:
            unseen.remove(point)
            point = permutation[point]
            length += 1
        assert point == first
        lengths.append(length)
    return tuple(sorted(lengths))


def complement_orbits(field, support, stabilizer) -> list[list[int]]:
    available = set(range(field.q + 1)) - set(support)
    unseen = set(available)
    answer = []
    while unseen:
        seed = min(unseen)
        orbit = {element["point_permutation"][seed] for element in stabilizer}  # type: ignore[index]
        assert orbit <= available
        unseen -= orbit
        answer.append(sorted(orbit))
    return answer


def analyze_support(field, support) -> dict[str, object]:
    stabilizer = support_stabilizer(field, support)
    deep = tuple(syndrome for syndrome in projective_plane(field) if deepest(field, support, syndrome))
    classes: dict[tuple[object, ...], list[tuple[int, int, int]]] = defaultdict(list)
    for syndrome in deep:
        rank = rank_of(field, syndrome)
        key: tuple[object, ...]
        if rank == 2:
            key = (2, atlas_key(field, support, syndrome, stabilizer))
        else:
            key = (1, radical_key(field, syndrome, stabilizer))
        classes[key].append(syndrome)

    orbit_records = []
    for key, members in classes.items():
        representative = min(members)
        rank = rank_of(field, representative)
        canonical_atlas = atlas_key(field, support, representative, stabilizer)
        record: dict[str, object] = {
            "representative": list(representative),
            "orbit_size": len(members),
            "rank": rank,
            "delta_class": delta_class(field, representative),
            "atlas": list(canonical_atlas),
        }
        if rank == 1:
            record["radical"] = radical_of(field, representative)
            record["radical_orbit_representative"] = key[1]
            assert all(value == 1 for value in canonical_atlas)
        orbit_records.append(record)
    orbit_records.sort(key=lambda record: record["representative"])

    fibres: dict[tuple[int, ...], list[list[int]]] = defaultdict(list)
    for record in orbit_records:
        fibres[tuple(record["atlas"])].append(record["representative"])  # type: ignore[arg-type]
    fibre_records = [
        {"atlas": list(key), "syndrome_orbits": sorted(members)}
        for key, members in sorted(fibres.items())
    ]
    collisions = [record for record in fibre_records if len(record["syndrome_orbits"]) > 1]
    ranks = Counter(record["rank"] for record in orbit_records)
    deltas = Counter(record["delta_class"] for record in orbit_records)
    cycles = Counter(
        cycle_type(element["point_permutation"]) for element in stabilizer  # type: ignore[arg-type]
    )
    record: dict[str, object] = {
        "support": list(support),
        "stabilizer_order": len(stabilizer),
        "stabilizer_p1_permutations": sorted(
            [list(element["point_permutation"]) for element in stabilizer]  # type: ignore[arg-type]
        ),
        "stabilizer_p1_cycle_profile": {
            ",".join(map(str, key)): cycles[key] for key in sorted(cycles)
        },
        "off_support_point_orbits": complement_orbits(field, support, stabilizer),
        "deep_syndrome_count": len(deep),
        "syndrome_orbit_count": len(orbit_records),
        "rank_orbit_histogram": {str(rank): ranks[rank] for rank in sorted(ranks)},
        "delta_class_orbit_histogram": {key: deltas[key] for key in sorted(deltas)},
        "atlas_fibre_count": len(fibre_records),
        "atlas_fibres": fibre_records,
        "collision_fibres": collisions,
        "augmented_atlas_fibre_count": len(orbit_records),
        "syndrome_orbits": orbit_records,
    }
    if field.p == 2:
        nucleus = (0, 1, 0)
        assert deepest(field, support, nucleus)
        nucleus_atlas = atlas_key(field, support, nucleus, stabilizer)
        assert classes[(2, nucleus_atlas)] == [nucleus]
        record["nucleus"] = {
            "syndrome": list(nucleus),
            "deep": True,
            "orbit_size": 1,
            "atlas": list(nucleus_atlas),
        }
    return record


def replay_certificate(root: Path) -> dict[str, object]:
    upstream_path = root / "notes" / f"{UPSTREAM}.py"
    upstream = import_field_model(root)
    records = []
    stop = None
    for q in FIELDS:
        field = upstream.FiniteField(q)
        representatives = support_representatives(field)
        processed = []
        for support in representatives:
            record = analyze_support(field, support)
            processed.append(record)
            if record["collision_fibres"]:
                stop = {
                    "q": q,
                    "support": list(support),
                    "collision_fibres": record["collision_fibres"],
                }
                break
        records.append(
            {
                "q": q,
                "characteristic": field.p,
                "extension_degree": field.degree,
                "p1_size": q + 1,
                "support_subset_count": comb(q + 1, 6),
                "semilinear_group_order": field.degree * q * (q * q - 1),
                "support_orbit_count": len(representatives),
                "support_representatives": [list(support) for support in representatives],
                "processed_support_count": len(processed),
                "processed_supports": processed,
            }
        )
        if stop is not None:
            break
    assert stop is not None
    return {
        "schema": SCHEMA,
        "task": "C476",
        "field_order": list(FIELDS),
        "support_size": 6,
        "point_encoding": "affine t is integer t; infinity is q; polynomial-basis field elements use C398",
        "stop_rule": "finish the first raw-atlas colliding support, then stop before the next support",
        "upstream": {
            "path": f"notes/{UPSTREAM}.py",
            "sha256": hashlib.sha256(upstream_path.read_bytes()).hexdigest(),
            "byte_count": upstream_path.stat().st_size,
        },
        "fields": records,
        "first_collision": stop,
    }


def main() -> None:
    root = Path(__file__).resolve().parents[1]
    tracked = json.loads((root / "notes" / f"{STEM}.json").read_text())
    replayed = replay_certificate(root)
    if replayed != tracked:
        raise SystemExit("independent frame replay differs from tracked C476 certificate")
    collision = replayed["first_collision"]
    print(
        "independent frame replay agrees: "
        f"first collision q={collision['q']} support={collision['support']}"
    )


if __name__ == "__main__":
    main()
