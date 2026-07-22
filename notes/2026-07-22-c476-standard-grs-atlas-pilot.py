#!/usr/bin/env python3
"""Exact bounded six-point GRS support and determinant-atlas census for C476."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import tempfile
from collections import Counter, defaultdict
from itertools import combinations, product
from math import comb
from pathlib import Path


STEM = "2026-07-22-c476-standard-grs-atlas-pilot"
SCHEMA = "c476-standard-grs-atlas-pilot-v1"
UPSTREAM = "2026-07-20-c398-conic-deep-hole-classification"
FIELDS = (5, 7, 8, 9, 11)


def load_upstream(root: Path):
    path = root / "notes" / f"{UPSTREAM}.py"
    spec = importlib.util.spec_from_file_location("c398_field", path)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def fsum(field, values) -> int:
    answer = 0
    for value in values:
        answer = field.add(answer, value)
    return answer


def normalize(field, vector: tuple[int, ...]) -> tuple[int, ...]:
    scale = field.inverse(next(value for value in vector if value))
    return tuple(field.mul(scale, value) for value in vector)


def p1_vector(q: int, point: int) -> tuple[int, int]:
    return (0, 1) if point == q else (1, point)


def p1_point(field, vector: tuple[int, int]) -> int:
    x, y = vector
    return field.q if x == 0 else field.div(y, x)


def determinant2(field, matrix: tuple[int, int, int, int]) -> int:
    a, b, c, d = matrix
    return field.sub(field.mul(a, d), field.mul(b, c))


def pgl_matrices(field) -> tuple[tuple[int, int, int, int], ...]:
    matrices = {
        normalize(field, matrix)
        for matrix in product(range(field.q), repeat=4)
        if any(matrix) and determinant2(field, matrix)
    }
    expected = field.q * (field.q * field.q - 1)
    assert len(matrices) == expected
    return tuple(sorted(matrices))


def apply_matrix_point(field, matrix: tuple[int, int, int, int], point: int) -> int:
    a, b, c, d = matrix
    x, y = p1_vector(field.q, point)
    return p1_point(
        field,
        (
            field.add(field.mul(a, x), field.mul(b, y)),
            field.add(field.mul(c, x), field.mul(d, y)),
        ),
    )


def frobenius_point(field, point: int, power: int) -> int:
    return point if point == field.q else field.frobenius(point, power)


def semilinear_group(field) -> tuple[dict[str, object], ...]:
    points = tuple(range(field.q + 1))
    answer = []
    for power in range(field.degree):
        for matrix in pgl_matrices(field):
            permutation = tuple(
                apply_matrix_point(field, matrix, frobenius_point(field, point, power))
                for point in points
            )
            assert len(set(permutation)) == field.q + 1
            answer.append({"frobenius": power, "matrix": matrix, "permutation": permutation})
    assert len({entry["permutation"] for entry in answer}) == len(answer)
    return tuple(answer)


def support_image(support: tuple[int, ...], element: dict[str, object]) -> tuple[int, ...]:
    permutation = element["permutation"]
    assert isinstance(permutation, tuple)
    return tuple(sorted(permutation[point] for point in support))


def support_representatives(field, group) -> tuple[tuple[int, ...], ...]:
    representatives = set()
    standard_frame = {0, 1, field.q}
    for support in combinations(range(field.q + 1), 6):
        representatives.add(
            min(
                image
                for element in group
                if standard_frame <= set(image := support_image(support, element))
            )
        )
    return tuple(sorted(representatives))


def projective_plane(field) -> tuple[tuple[int, int, int], ...]:
    return tuple(
        sorted(
            {
                normalize(field, vector)
                for vector in product(range(field.q), repeat=3)
                if any(vector)
            }
        )
    )


def matrix_vector(field, matrix: tuple[tuple[int, ...], ...], vector: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(fsum(field, (field.mul(row[j], vector[j]) for j in range(len(vector)))) for row in matrix)


def sym2_matrix(field, matrix: tuple[int, int, int, int]) -> tuple[tuple[int, int, int], ...]:
    a, b, c, d = matrix
    two = field.add(1, 1)
    return (
        (field.mul(a, a), field.mul(two, field.mul(a, b)), field.mul(b, b)),
        (field.mul(a, c), field.add(field.mul(a, d), field.mul(b, c)), field.mul(b, d)),
        (field.mul(c, c), field.mul(two, field.mul(c, d)), field.mul(d, d)),
    )


def syndrome_image(field, syndrome: tuple[int, int, int], element: dict[str, object]) -> tuple[int, int, int]:
    power = element["frobenius"]
    matrix = element["matrix"]
    assert isinstance(power, int) and isinstance(matrix, tuple)
    twisted = tuple(field.frobenius(value, power) for value in syndrome)
    return normalize(field, matrix_vector(field, sym2_matrix(field, matrix), twisted))  # type: ignore[return-value]


def beta(field, syndrome: tuple[int, int, int], left: int, right: int) -> int:
    u0, u1, u2 = syndrome
    x, y = p1_vector(field.q, left)
    X, Y = p1_vector(field.q, right)
    middle = field.add(field.mul(x, Y), field.mul(X, y))
    return fsum(
        field,
        (
            field.mul(u2, field.mul(x, X)),
            field.neg(field.mul(u1, middle)),
            field.mul(u0, field.mul(y, Y)),
        ),
    )


def is_deep(field, support: tuple[int, ...], syndrome: tuple[int, int, int]) -> bool:
    return all(beta(field, syndrome, support[i], support[j]) for i, j in combinations(range(6), 2))


def atlas(field, support: tuple[int, ...], syndrome: tuple[int, int, int]) -> tuple[int, ...]:
    values = {
        (i, j): beta(field, syndrome, support[i], support[j])
        for i, j in combinations(range(6), 2)
    }
    answer = []
    for i, j, k, ell in combinations(range(6), 4):
        numerator = field.mul(values[i, j], values[k, ell])
        answer.append(field.div(numerator, field.mul(values[i, k], values[j, ell])))
        answer.append(field.div(numerator, field.mul(values[i, ell], values[j, k])))
    return tuple(answer)


def beta_rank(field, syndrome: tuple[int, int, int]) -> int:
    u0, u1, u2 = syndrome
    determinant = field.sub(field.mul(u0, u2), field.mul(u1, u1))
    return 2 if determinant else 1


def delta_class(field, syndrome: tuple[int, int, int]) -> str:
    u0, u1, u2 = syndrome
    determinant = field.sub(field.mul(u0, u2), field.mul(u1, u1))
    if determinant == 0:
        return "zero"
    if field.p == 2:
        return "nonzero-square"
    return "square" if field.pow(determinant, (field.q - 1) // 2) == 1 else "nonsquare"


def radical(field, syndrome: tuple[int, int, int]) -> int:
    assert beta_rank(field, syndrome) == 1
    answer = [point for point in range(field.q + 1) if all(
        beta(field, syndrome, point, other) == 0 for other in (0, field.q)
    )]
    assert len(answer) == 1
    return answer[0]


def syndrome_record(field, support, stabilizer, orbit) -> dict[str, object]:
    representative = min(orbit)
    rank = beta_rank(field, representative)
    atlas_key = min(atlas(field, support, syndrome_image(field, representative, element)) for element in stabilizer)
    record: dict[str, object] = {
        "representative": list(representative),
        "orbit_size": len(orbit),
        "rank": rank,
        "delta_class": delta_class(field, representative),
        "atlas": list(atlas_key),
    }
    if rank == 1:
        point = radical(field, representative)
        record["radical"] = point
        record["radical_orbit_representative"] = min(
            element["permutation"][point] for element in stabilizer  # type: ignore[index]
        )
        assert all(value == 1 for value in atlas_key)
    return record


def permutation_cycle_type(permutation: tuple[int, ...]) -> tuple[int, ...]:
    unseen = set(range(len(permutation)))
    lengths = []
    while unseen:
        start = min(unseen)
        point = start
        length = 0
        while point in unseen:
            unseen.remove(point)
            point = permutation[point]
            length += 1
        assert point == start
        lengths.append(length)
    return tuple(sorted(lengths))


def point_orbits(points: set[int], stabilizer) -> list[list[int]]:
    unseen = set(points)
    answer = []
    while unseen:
        seed = min(unseen)
        orbit = {element["permutation"][seed] for element in stabilizer}  # type: ignore[index]
        assert orbit <= points
        unseen -= orbit
        answer.append(sorted(orbit))
    return answer


def analyze_support(field, support, group) -> dict[str, object]:
    stabilizer = tuple(element for element in group if support_image(support, element) == support)
    deep = tuple(syndrome for syndrome in projective_plane(field) if is_deep(field, support, syndrome))
    unseen = set(deep)
    orbit_records = []
    while unseen:
        seed = min(unseen)
        orbit = {syndrome_image(field, seed, element) for element in stabilizer}
        assert orbit <= set(deep)
        unseen -= orbit
        orbit_records.append(syndrome_record(field, support, stabilizer, orbit))
    orbit_records.sort(key=lambda record: record["representative"])

    fibres: dict[tuple[int, ...], list[list[int]]] = defaultdict(list)
    for record in orbit_records:
        fibres[tuple(record["atlas"])].append(record["representative"])  # type: ignore[arg-type]
    fibre_records = [
        {"atlas": list(key), "syndrome_orbits": sorted(members)}
        for key, members in sorted(fibres.items())
    ]
    collisions = [record for record in fibre_records if len(record["syndrome_orbits"]) > 1]
    rank_histogram = Counter(record["rank"] for record in orbit_records)
    delta_histogram = Counter(record["delta_class"] for record in orbit_records)
    assert all(
        all(beta_rank(field, tuple(member)) == 1 for member in fibre["syndrome_orbits"])
        for fibre in collisions
    )
    assert all(
        len({delta_class(field, tuple(member)) for member in fibre["syndrome_orbits"]}) == 1
        for fibre in collisions
    )
    augmented_keys = {
        (
            tuple(record["atlas"]),
            record.get("radical_orbit_representative") if record["rank"] == 1 else None,
        )
        for record in orbit_records
    }
    assert len(augmented_keys) == len(orbit_records)
    cycle_profile = Counter(
        permutation_cycle_type(element["permutation"]) for element in stabilizer  # type: ignore[arg-type]
    )
    complement_orbits = point_orbits(set(range(field.q + 1)) - set(support), stabilizer)
    assert sum(map(len, complement_orbits)) == field.q - 5
    record: dict[str, object] = {
        "support": list(support),
        "stabilizer_order": len(stabilizer),
        "stabilizer_p1_permutations": sorted(
            [list(element["permutation"]) for element in stabilizer]  # type: ignore[arg-type]
        ),
        "stabilizer_p1_cycle_profile": {
            ",".join(map(str, key)): cycle_profile[key] for key in sorted(cycle_profile)
        },
        "off_support_point_orbits": complement_orbits,
        "deep_syndrome_count": len(deep),
        "syndrome_orbit_count": len(orbit_records),
        "rank_orbit_histogram": {str(rank): rank_histogram[rank] for rank in sorted(rank_histogram)},
        "delta_class_orbit_histogram": {
            key: delta_histogram[key] for key in sorted(delta_histogram)
        },
        "atlas_fibre_count": len(fibre_records),
        "atlas_fibres": fibre_records,
        "collision_fibres": collisions,
        "augmented_atlas_fibre_count": len(augmented_keys),
        "syndrome_orbits": orbit_records,
    }
    if field.p == 2:
        nucleus = (0, 1, 0)
        nucleus_orbit = {syndrome_image(field, nucleus, element) for element in stabilizer}
        assert is_deep(field, support, nucleus) and nucleus_orbit == {nucleus}
        record["nucleus"] = {
            "syndrome": list(nucleus),
            "deep": True,
            "orbit_size": 1,
            "atlas": list(atlas(field, support, nucleus)),
        }
    return record


def build_certificate(root: Path) -> dict[str, object]:
    upstream_path = root / "notes" / f"{UPSTREAM}.py"
    upstream = load_upstream(root)
    field_records = []
    stop = None
    for q in FIELDS:
        field = upstream.FiniteField(q)
        group = semilinear_group(field)
        representatives = support_representatives(field, group)
        processed = []
        for support in representatives:
            record = analyze_support(field, support, group)
            processed.append(record)
            if record["collision_fibres"]:
                stop = {
                    "q": q,
                    "support": list(support),
                    "collision_fibres": record["collision_fibres"],
                }
                break
        field_records.append(
            {
                "q": q,
                "characteristic": field.p,
                "extension_degree": field.degree,
                "p1_size": q + 1,
                "support_subset_count": comb(q + 1, 6),
                "semilinear_group_order": len(group),
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
        "fields": field_records,
        "first_collision": stop,
    }


def canonical_bytes(value: dict[str, object]) -> bytes:
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def check_tracked(root: Path) -> None:
    tracked = root / "notes" / f"{STEM}.json"
    expected = tracked.read_bytes()
    with tempfile.TemporaryDirectory(prefix="c476-check-", dir="/home/tavis") as directory:
        generated = Path(directory) / tracked.name
        generated.write_bytes(canonical_bytes(build_certificate(root)))
        actual = generated.read_bytes()
    if actual != expected:
        raise SystemExit(f"generated certificate differs from {tracked}")
    print(f"checked {tracked.relative_to(root)} ({len(expected)} bytes, sha256 {hashlib.sha256(expected).hexdigest()})")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[1]
    if args.check:
        check_tracked(root)
        return
    output = args.output or root / "notes" / f"{STEM}.json"
    output.write_bytes(canonical_bytes(build_certificate(root)))
    print(output)


if __name__ == "__main__":
    main()
