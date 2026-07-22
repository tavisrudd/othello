#!/usr/bin/env python3
"""Deterministic finite classification for C490's small-field closure."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import tempfile
from collections import Counter
from itertools import combinations, product
from pathlib import Path


HERE = Path(__file__).resolve().parent
STEM = "2026-07-22-c490-small-field-base-size-closure"
SCHEMA = "c490-small-field-base-size-closure-v1"
C398 = HERE / "2026-07-20-c398-conic-deep-hole-classification.py"
C478 = HERE / "2026-07-22-c478-exceptional-family-controls.py"
OUTPUT = HERE / f"{STEM}.json"


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def dot(field, line, point):
    value = 0
    for left, right in zip(line, point):
        value = field.add(value, field.mul(left, right))
    return value


def line_through(module, field, left, right):
    cross = (
        field.sub(field.mul(left[1], right[2]), field.mul(left[2], right[1])),
        field.sub(field.mul(left[2], right[0]), field.mul(left[0], right[2])),
        field.sub(field.mul(left[0], right[1]), field.mul(left[1], right[0])),
    )
    return module.normalize(field, cross)


def parents_for_child(module, field, points, child):
    """Enumerate all literal six-arcs whose uncovered locus is exactly child."""
    child_set = set(child)
    available = tuple(point for point in points if point not in child_set)
    allowed_lines = {
        line for line in points if all(dot(field, line, point) for point in child)
    }
    adjacency = {point: set() for point in available}
    for left, right in combinations(available, 2):
        if line_through(module, field, left, right) in allowed_lines:
            adjacency[left].add(right)
            adjacency[right].add(left)

    answer = []

    def visit(chosen, candidates):
        if len(chosen) == 6:
            arc = tuple(chosen)
            if module.uncovered_locus(field, arc, points) == child:
                answer.append(arc)
            return
        if len(chosen) + len(candidates) < 6:
            return
        for offset, point in enumerate(candidates):
            if len(chosen) >= 2 and any(
                not module.det3(field, left, right, point)
                for left, right in combinations(chosen, 2)
            ):
                continue
            tail = candidates[offset + 1 :]
            next_candidates = tuple(other for other in tail if other in adjacency[point])
            if len(chosen) >= 2:
                next_candidates = tuple(
                    other for other in next_candidates
                    if all(module.det3(field, left, point, other) for left in chosen)
                )
            visit(chosen + (point,), next_candidates)

    visit((), available)
    return tuple(answer)


def candidate_line_count(field, points, child):
    return sum(all(dot(field, line, point) for point in child) for line in points)


def pgl3_order(q):
    return (q**3 - 1) * (q**3 - q) * (q**3 - q**2) // (q - 1)


def vacuous_prime_field(q):
    def norm(vector):
        scale = pow(next(x for x in vector if x), q - 2, q)
        return tuple(scale * x % q for x in vector)

    plane = tuple(sorted({
        norm(vector) for vector in product(range(q), repeat=3) if any(vector)
    }))

    def determinant(a, b, c):
        return (
            a[0] * (b[1] * c[2] - b[2] * c[1])
            - a[1] * (b[0] * c[2] - b[2] * c[0])
            + a[2] * (b[0] * c[1] - b[1] * c[0])
        ) % q

    six_arc_count = sum(
        all(determinant(*triple) for triple in combinations(candidate, 3))
        for candidate in combinations(plane, 6)
    )
    return {
        "projective_points": len(plane),
        "six_subsets_checked": len(tuple(combinations(plane, 6))),
        "six_arc_count": six_arc_count,
    }


def collision_certificate(module, atlas_module, field, child, parents):
    """Return the exact coherent disagreement hypergraph and its transversal."""
    if len(parents) == 1:
        return {
            "disagreement_mask_multiplicities": {},
            "subset_levels": [{"size": 0, "total": 1, "hitting": 1, "first": []}],
            "minimum_base_size": 0,
            "separating_indices": [],
        }
    permutations = atlas_module.SUPPORT_PERMUTATIONS
    atlas_cache = []
    for parent in parents:
        atlas_cache.append(tuple(
            tuple(
                atlas_module.atlas(module, field, parent, point, permutation)
                for point in child
            )
            for permutation in permutations
        ))
    identity = permutations.index(tuple(range(6)))
    masks = Counter()
    mask_representatives = {}
    for left, right in combinations(range(len(parents)), 2):
        left_values = atlas_cache[left][identity]
        for permutation_index, right_values in enumerate(atlas_cache[right]):
            mask = sum(
                (1 << index)
                for index, (a, b) in enumerate(zip(left_values, right_values))
                if a != b
            )
            masks[mask] += 1
            mask_representatives.setdefault(mask, (left, right, permutation_index))
    levels = []
    minimum = None
    separating = None
    if 0 not in masks:
        for size in range(len(child) + 1):
            hitting = []
            for indices in combinations(range(len(child)), size):
                selected = sum(1 << index for index in indices)
                if all(selected & mask for mask in masks):
                    hitting.append(indices)
            levels.append({
                "size": size,
                "total": len(tuple(combinations(range(len(child)), size))),
                "hitting": len(hitting),
                "first": list(hitting[0]) if hitting else None,
            })
            if hitting:
                minimum = size
                separating = list(hitting[0])
                break
    else:
        for size in range(len(child) + 1):
            levels.append({
                "size": size,
                "total": len(tuple(combinations(range(len(child)), size))),
                "hitting": 0,
                "first": None,
            })
    return {
        "disagreement_mask_multiplicities": {
            str(mask): count for mask, count in sorted(masks.items())
        },
        "subset_levels": levels,
        "minimum_base_size": minimum,
        "separating_indices": separating,
        "collision_component_size_representatives": {
            str(size): {
                "disagreement_mask": mask,
                "parent_indices": [left, right],
                "permutation_index": permutation_index,
                **common_component_certificate(
                    field,
                    collision_quartics(
                        field, parents[left], parents[right], permutations[permutation_index]
                    ),
                ),
            }
            for size, (mask, (left, right, permutation_index)) in sorted({
                mask.bit_count(): (mask, representative)
                for mask, representative in reversed(sorted(mask_representatives.items()))
            }.items())
        },
    }


def generate():
    module = load_module("c398", C398)
    atlas_module = load_module("c478", C478)
    fields = []
    for q in module.FIELDS:
        field = module.FiniteField(q)
        points = module.projective_points(field)
        representatives = module.normalized_arcs(field)
        seen = set()
        fibres = []
        empty_indices = tuple(
            index for index, (arc, _) in enumerate(representatives)
            if not module.uncovered_locus(field, arc, points)
        )
        if empty_indices:
            normalized_count = sum(representatives[index][1] for index in empty_indices)
            literal_count = normalized_count * pgl3_order(q) // 360
            fibres.append({
                "kind": "empty-child",
                "child_size": 0,
                "orbit_indices": list(empty_indices),
                "normalized_presentations": normalized_count,
                "literal_parent_count": literal_count,
                "minimum_base_size": None,
                "reason": "no available centre and more than one literal parent",
            })
            seen.update(empty_indices)
        for index, (arc, _) in enumerate(representatives):
            if index in seen:
                continue
            child = module.uncovered_locus(field, arc, points)
            assert child
            parents = parents_for_child(module, field, points, child)
            canonical_members = {module.canonical_arc(field, parent) for parent in parents}
            representative_index = {
                module.canonical_arc(field, other): j
                for j, (other, _) in enumerate(representatives)
            }
            members = tuple(
                j for j, (other, _) in enumerate(representatives)
                if module.canonical_arc(field, other) in canonical_members
            )
            assert index in members and not (set(members) & seen)
            seen.update(members)
            collision = collision_certificate(module, atlas_module, field, child, parents)
            orbit_parent_counts = Counter(
                representative_index[module.canonical_arc(field, parent)] for parent in parents
            )
            fibres.append({
                "kind": "nonempty-child",
                "child": [list(point) for point in child],
                "child_size": len(child),
                "tau": q * q - 14 * q + 55 - len(child),
                "candidate_lines": candidate_line_count(field, points, child),
                "orbit_indices": list(members),
                "orbit_parent_counts": {
                    str(key): value for key, value in sorted(orbit_parent_counts.items())
                },
                "conic_parent_count": sum(
                    module.lies_on_conic(field, parent, points) for parent in parents
                ),
                "literal_parent_count": len(parents),
                "parents": [[list(point) for point in parent] for parent in parents],
                **collision,
            })
        assert len(seen) == len(representatives)
        fibres.sort(key=lambda row: (row["child_size"], row["orbit_indices"]))
        fields.append({
            "q": q,
            "projective_points": len(points),
            "semilinear_arc_orbits": len(representatives),
            "fibres": fibres,
        })
    return {
        "schema": SCHEMA,
        "task": "C490",
        "vacuous_fields": {str(q): vacuous_prime_field(q) for q in (2, 3)},
        "field_model_source": C398.name,
        "atlas_source": C478.name,
        "fields": fields,
    }


def serialized():
    return (json.dumps(generate(), indent=2, sort_keys=True) + "\n").encode()


def poly_product(field, linear_forms):
    result = {(0, 0, 0): 1}
    for linear in linear_forms:
        product = {}
        for exponent, coefficient in result.items():
            for variable, value in enumerate(linear):
                if not value:
                    continue
                target = list(exponent)
                target[variable] += 1
                target = tuple(target)
                product[target] = field.add(
                    product.get(target, 0), field.mul(coefficient, value)
                )
        result = {key: value for key, value in product.items() if value}
    return result


def poly_sub(field, left, right):
    answer = dict(left)
    for exponent, value in right.items():
        answer[exponent] = field.sub(answer.get(exponent, 0), value)
        if not answer[exponent]:
            del answer[exponent]
    return answer


def determinant_linear(field, left, right):
    return (
        field.sub(field.mul(left[1], right[2]), field.mul(left[2], right[1])),
        field.sub(field.mul(left[2], right[0]), field.mul(left[0], right[2])),
        field.sub(field.mul(left[0], right[1]), field.mul(left[1], right[0])),
    )


def collision_quartics(field, left, right, permutation):
    a = tuple(determinant_linear(field, left[i], left[j]) for i in range(6) for j in range(i + 1, 6))
    b_parent = tuple(right[index] for index in permutation)
    b = tuple(determinant_linear(field, b_parent[i], b_parent[j]) for i in range(6) for j in range(i + 1, 6))
    edge_order = tuple(combinations(range(6), 2))
    ai = {edge: value for edge, value in zip(edge_order, a)}
    bi = {edge: value for edge, value in zip(edge_order, b)}
    answer = []
    for i, j, k, ell in combinations(range(6), 4):
        for a_den, b_den in (
            (((i, k), (j, ell)), ((i, k), (j, ell))),
            (((i, ell), (j, k)), ((i, ell), (j, k))),
        ):
            first = poly_product(field, (ai[i, j], ai[k, ell], bi[b_den[0]], bi[b_den[1]]))
            second = poly_product(field, (bi[i, j], bi[k, ell], ai[a_den[0]], ai[a_den[1]]))
            answer.append(poly_sub(field, first, second))
    return tuple(answer)


def specialize_univariate(field, polynomial, variable, values):
    coefficients = [0] * 5
    others = tuple(index for index in range(3) if index != variable)
    for exponent, coefficient in polynomial.items():
        value = coefficient
        value = field.mul(value, field.pow(values[0], exponent[others[0]]))
        value = field.mul(value, field.pow(values[1], exponent[others[1]]))
        coefficients[exponent[variable]] = field.add(coefficients[exponent[variable]], value)
    while coefficients and not coefficients[-1]:
        coefficients.pop()
    return coefficients


def univariate_remainder(field, left, right):
    left = list(left)
    while left and len(left) >= len(right):
        scale = field.div(left[-1], right[-1])
        shift = len(left) - len(right)
        for index, value in enumerate(right):
            left[index + shift] = field.sub(left[index + shift], field.mul(scale, value))
        while left and not left[-1]:
            left.pop()
    return left


def univariate_gcd_degree(field, left, right):
    while right:
        left, right = right, univariate_remainder(field, left, right)
    return len(left) - 1


def univariate_mul(field, left, right):
    answer = [0] * (len(left) + len(right) - 1)
    for i, x in enumerate(left):
        for j, y in enumerate(right):
            answer[i + j] = field.add(answer[i + j], field.mul(x, y))
    return answer


def specialize_line(field, polynomial, direction, offset):
    answer = [0] * 5
    for exponent, coefficient in polynomial.items():
        term = [coefficient]
        for variable, power in enumerate(exponent):
            for _ in range(power):
                term = univariate_mul(field, term, (offset[variable], direction[variable]))
        for degree, value in enumerate(term):
            answer[degree] = field.add(answer[degree], value)
    while answer and not answer[-1]:
        answer.pop()
    return answer


def evaluate_poly(field, polynomial, point):
    answer = 0
    for exponent, coefficient in polynomial.items():
        value = coefficient
        for variable in range(3):
            value = field.mul(value, field.pow(point[variable], exponent[variable]))
        answer = field.add(answer, value)
    return answer


def divide_by_line(field, polynomial, line):
    pivot = next(index for index, value in enumerate(line) if value)
    remainder = dict(polynomial)
    quotient = {}
    while remainder:
        eligible = [exponent for exponent in remainder if exponent[pivot]]
        if not eligible:
            break
        exponent = max(eligible, key=lambda value: (value[pivot], value))
        target = list(exponent)
        target[pivot] -= 1
        target = tuple(target)
        scale = field.div(remainder[exponent], line[pivot])
        quotient[target] = field.add(quotient.get(target, 0), scale)
        for variable, value in enumerate(line):
            if not value:
                continue
            produced = list(target)
            produced[variable] += 1
            produced = tuple(produced)
            remainder[produced] = field.sub(
                remainder.get(produced, 0), field.mul(scale, value)
            )
            if not remainder[produced]:
                del remainder[produced]
    assert not remainder
    return quotient


def coprime_quartic_witness(field, quartics):
    """Exhibit two ideal generators with no common curve component."""
    plane = tuple(sorted({
        tuple(field.mul(field.inverse(next(x for x in vector if x)), x) for x in vector)
        for vector in product(range(field.q), repeat=3) if any(vector)
    }))
    nonzero = [index for index, polynomial in enumerate(quartics) if polynomial]
    trial_directions = plane
    trial_offsets = plane
    for direction in trial_directions:
        degrees = {
            index: max(map(sum, quartics[index])) for index in nonzero
        }
        eligible = [index for index in nonzero if len(
            specialize_line(field, quartics[index], direction, (0, 0, 0))
        ) == degrees[index] + 1]
        for left, right in combinations(eligible, 2):
            for offset in trial_offsets:
                f = specialize_line(field, quartics[left], direction, offset)
                g = specialize_line(field, quartics[right], direction, offset)
                if (len(f) == degrees[left] + 1 and len(g) == degrees[right] + 1
                        and univariate_gcd_degree(field, f, g) == 0):
                    return {
                        "direction": list(direction),
                        "offset": list(offset),
                        "generators": [left, right],
                    }
    return None


def common_component_certificate(field, quartics):
    plane = tuple(sorted({
        tuple(field.mul(field.inverse(next(x for x in vector if x)), x) for x in vector)
        for vector in product(range(field.q), repeat=3) if any(vector)
    }))
    residual = tuple(quartics)
    lines = []
    while True:
        factor = next((
            line for line in plane
            if all(
                all(not evaluate_poly(field, polynomial, point)
                    for point in plane if not dot(field, line, point))
                for polynomial in residual
            )
        ), None)
        if factor is None:
            break
        lines.append(factor)
        residual = tuple(divide_by_line(field, polynomial, factor) for polynomial in residual)
    witness = coprime_quartic_witness(field, residual)
    return {
        "common_rational_lines": [list(line) for line in lines],
        "residual_coprime_witness": witness,
        "all_positive_components_classified": witness is not None,
    }


def summarize():
    module = load_module("c398", C398)
    for q in module.FIELDS:
        field = module.FiniteField(q)
        points = module.projective_points(field)
        representatives = module.normalized_arcs(field)
        seen = set()
        fibres = []
        for index, (arc, _) in enumerate(representatives):
            if index in seen:
                continue
            child = module.uncovered_locus(field, arc, points)
            if not child:
                members = tuple(
                    j for j, (other, _) in enumerate(representatives)
                    if not module.uncovered_locus(field, other, points)
                )
                seen.update(members)
                fibres.append((0, len(members), members, None))
                continue
            parents = parents_for_child(module, field, points, child)
            canonical_members = {module.canonical_arc(field, parent) for parent in parents}
            members = tuple(
                j for j, (other, _) in enumerate(representatives)
                if module.canonical_arc(field, other) in canonical_members
            )
            seen.update(members)
            fibres.append((len(child), len(parents), members, len(canonical_members)))
        print(q, fibres, "seen", len(seen), "of", len(representatives))


def minimum_base(module, atlas_module, field, child, parents):
    if len(parents) == 1:
        return 0, (), (1,)
    atlas_cache = []
    for parent in parents:
        atlas_cache.append(tuple(
            tuple(
                atlas_module.atlas(module, field, parent, point, permutation)
                for point in child
            )
            for permutation in atlas_module.SUPPORT_PERMUTATIONS
        ))
    for size in range(1, min(3, len(child)) + 1):
        best = None
        for indices in combinations(range(len(child)), size):
            signatures = [
                min(
                    tuple(permutation_values[index] for index in indices)
                    for permutation_values in parent_values
                )
                for parent_values in atlas_cache
            ]
            count = len(set(signatures))
            if best is None or count > best[0]:
                best = (count, indices, tuple(sorted(Counter(signatures).values())))
            if count == len(parents):
                return size, indices, tuple(1 for _ in parents)
        assert best is not None
        print("  level", size, "best", best[0], "indices", best[1], "fibres", best[2])
    return None, (), ()


def bases(only_q=None):
    module = load_module("c398", C398)
    atlas_module = load_module("c478", C478)
    for q in module.FIELDS:
        if only_q is not None and q != only_q:
            continue
        field = module.FiniteField(q)
        points = module.projective_points(field)
        representatives = module.normalized_arcs(field)
        seen = set()
        for index, (arc, _) in enumerate(representatives):
            if index in seen:
                continue
            child = module.uncovered_locus(field, arc, points)
            if not child:
                members = tuple(
                    j for j, (other, _) in enumerate(representatives)
                    if not module.uncovered_locus(field, other, points)
                )
                seen.update(members)
                print(q, "empty", "orbit-types", members, "base impossible")
                continue
            parents = parents_for_child(module, field, points, child)
            canonical_members = {module.canonical_arc(field, parent) for parent in parents}
            members = tuple(
                j for j, (other, _) in enumerate(representatives)
                if module.canonical_arc(field, other) in canonical_members
            )
            seen.update(members)
            print(q, "child", len(child), "parents", len(parents), "orbit-types", members)
            result = minimum_base(module, atlas_module, field, child, parents)
            print("  result", result)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--summary", action="store_true")
    parser.add_argument("--bases", action="store_true")
    parser.add_argument("--q", type=int)
    parser.add_argument("--generate", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.generate:
        OUTPUT.write_bytes(serialized())
    if args.check:
        expected = OUTPUT.read_bytes()
        actual = serialized()
        assert actual == expected
        print(f"ok {OUTPUT.name} {len(actual)} bytes {hashlib.sha256(actual).hexdigest()}")
    if args.summary:
        summarize()
    if args.bases:
        bases(args.q)


if __name__ == "__main__":
    main()
