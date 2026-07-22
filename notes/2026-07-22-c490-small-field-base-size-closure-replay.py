#!/usr/bin/env python3
"""Independent arithmetic replay of the C490 finite certificate."""

from __future__ import annotations

import hashlib
import itertools
import json
from collections import Counter
from pathlib import Path


HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "2026-07-22-c490-small-field-base-size-closure.json"
PERMUTATIONS = tuple(itertools.permutations(range(6)))


class Field:
    DATA = {
        2: (2, 1, None),
        3: (3, 1, None),
        4: (2, 2, (1, 1, 1)),
        5: (5, 1, None),
        7: (7, 1, None),
        8: (2, 3, (1, 1, 0, 1)),
        9: (3, 2, (1, 0, 1)),
        11: (11, 1, None),
        13: (13, 1, None),
    }

    def __init__(self, q):
        self.q = q
        self.p, self.degree, self.modulus = self.DATA[q]
        self.multiplication = [[self.raw_mul(x, y) for y in range(q)] for x in range(q)]
        self.inverses = [0] + [
            next(y for y in range(1, q) if self.multiplication[x][y] == 1)
            for x in range(1, q)
        ]

    def digits(self, value):
        answer = []
        for _ in range(self.degree):
            answer.append(value % self.p)
            value //= self.p
        return answer

    def encode(self, digits):
        value = 0
        for coefficient in reversed(tuple(digits)):
            value = value * self.p + coefficient % self.p
        return value

    def add(self, x, y):
        if self.degree == 1:
            return (x + y) % self.p
        return self.encode((a + b) % self.p for a, b in zip(self.digits(x), self.digits(y)))

    def sub(self, x, y):
        return self.add(x, self.encode(-a for a in self.digits(y)))

    def raw_mul(self, x, y):
        if self.degree == 1:
            return x * y % self.p
        left, right = self.digits(x), self.digits(y)
        product = [0] * (2 * self.degree - 1)
        for i, a in enumerate(left):
            for j, b in enumerate(right):
                product[i + j] = (product[i + j] + a * b) % self.p
        for degree in range(len(product) - 1, self.degree - 1, -1):
            coefficient = product[degree]
            if not coefficient:
                continue
            for j in range(self.degree):
                product[degree - self.degree + j] = (
                    product[degree - self.degree + j] - coefficient * self.modulus[j]
                ) % self.p
        return self.encode(product[: self.degree])

    def mul(self, x, y):
        return self.multiplication[x][y]

    def inverse(self, x):
        assert x
        return self.inverses[x]


def normalize(field, vector):
    scale = field.inverse(next(x for x in vector if x))
    return tuple(field.mul(scale, x) for x in vector)


def points(field):
    return tuple(sorted({
        normalize(field, vector)
        for vector in itertools.product(range(field.q), repeat=3)
        if any(vector)
    }))


def det3(field, a, b, c):
    positive = field.add(
        field.add(field.mul(a[0], field.mul(b[1], c[2])), field.mul(a[1], field.mul(b[2], c[0]))),
        field.mul(a[2], field.mul(b[0], c[1])),
    )
    negative = field.add(
        field.add(field.mul(a[2], field.mul(b[1], c[0])), field.mul(a[1], field.mul(b[0], c[2]))),
        field.mul(a[0], field.mul(b[2], c[1])),
    )
    return field.sub(positive, negative)


def is_arc(field, arc):
    return len(set(arc)) == 6 and all(det3(field, *triple) for triple in itertools.combinations(arc, 3))


def uncovered(field, arc, plane):
    return tuple(
        point for point in plane
        if all(det3(field, point, left, right) for left, right in itertools.combinations(arc, 2))
    )


def dot(field, left, right):
    value = 0
    for x, y in zip(left, right):
        value = field.add(value, field.mul(x, y))
    return value


def atlas(field, parent, centre, permutation):
    support = tuple(parent[index] for index in permutation)
    edges = {
        (i, j): det3(field, centre, support[i], support[j])
        for i, j in itertools.combinations(range(6), 2)
    }
    assert all(edges.values())
    answer = []
    for i, j, k, ell in itertools.combinations(range(6), 4):
        numerator = field.mul(edges[i, j], edges[k, ell])
        answer.extend((
            field.mul(numerator, field.inverse(field.mul(edges[i, k], edges[j, ell]))),
            field.mul(numerator, field.inverse(field.mul(edges[i, ell], edges[j, k]))),
        ))
    return tuple(answer)


def collision_masks(field, child, parents):
    if len(parents) == 1:
        return Counter()
    cache = [tuple(
        tuple(atlas(field, parent, centre, permutation) for centre in child)
        for permutation in PERMUTATIONS
    ) for parent in parents]
    answer = Counter()
    for left, right in itertools.combinations(range(len(parents)), 2):
        for right_values in cache[right]:
            mask = sum(
                1 << index
                for index, (a, b) in enumerate(zip(cache[left][0], right_values))
                if a != b
            )
            answer[mask] += 1
    return answer


def subset_levels(child_size, masks):
    if not masks:
        return [{"size": 0, "total": 1, "hitting": 1, "first": []}]
    levels = []
    for size in range(child_size + 1):
        subsets = tuple(itertools.combinations(range(child_size), size))
        hitting = [
            subset for subset in subsets
            if 0 not in masks and all(sum(1 << i for i in subset) & mask for mask in masks)
        ]
        levels.append({
            "size": size,
            "total": len(subsets),
            "hitting": len(hitting),
            "first": list(hitting[0]) if hitting else None,
        })
        if hitting:
            break
    return levels


def main():
    data = json.loads(CERTIFICATE.read_text())
    assert data["schema"] == "c490-small-field-base-size-closure-v1"
    for q_text, record in data["vacuous_fields"].items():
        field = Field(int(q_text))
        plane = points(field)
        candidates = tuple(itertools.combinations(plane, 6))
        assert len(plane) == record["projective_points"]
        assert len(candidates) == record["six_subsets_checked"]
        assert sum(is_arc(field, candidate) for candidate in candidates) == record["six_arc_count"] == 0
    checked_parents = 0
    checked_collision_instances = 0
    for field_row in data["fields"]:
        field = Field(field_row["q"])
        plane = points(field)
        assert len(plane) == field_row["projective_points"]
        for fibre in field_row["fibres"]:
            if fibre["kind"] == "empty-child":
                assert fibre["literal_parent_count"] > 1
                assert fibre["minimum_base_size"] is None
                continue
            child = tuple(tuple(point) for point in fibre["child"])
            parents = tuple(tuple(tuple(point) for point in parent) for parent in fibre["parents"])
            assert len(parents) == fibre["literal_parent_count"]
            assert len(set(parents)) == len(parents)
            assert all(is_arc(field, parent) and uncovered(field, parent, plane) == child for parent in parents)
            assert sum(all(dot(field, line, centre) for centre in child) for line in plane) == fibre["candidate_lines"]
            masks = collision_masks(field, child, parents)
            expected_masks = Counter({int(mask): count for mask, count in fibre["disagreement_mask_multiplicities"].items()})
            assert masks == expected_masks
            assert subset_levels(len(child), masks) == fibre["subset_levels"]
            minimum = next((row["size"] for row in fibre["subset_levels"] if row["hitting"]), None)
            assert minimum == fibre["minimum_base_size"]
            checked_parents += len(parents)
            checked_collision_instances += sum(masks.values())
    digest = hashlib.sha256(CERTIFICATE.read_bytes()).hexdigest()
    print(f"ok {checked_parents} parents {checked_collision_instances} transporter comparisons {digest}")


if __name__ == "__main__":
    main()
