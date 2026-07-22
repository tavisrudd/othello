#!/usr/bin/env python3
"""Exact deletion-conic decorations on the four C398 deep-hole classes."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import tempfile
from collections import Counter
from itertools import combinations, permutations
from pathlib import Path


STEM = "2026-07-22-c474-reed-solomon-decorated-deep-holes"
SCHEMA = "c474-reed-solomon-decorated-deep-holes-v1"
UPSTREAM = "2026-07-20-c398-conic-deep-hole-classification"


def load_upstream_module(root: Path):
    path = root / "notes" / f"{UPSTREAM}.py"
    spec = importlib.util.spec_from_file_location("c398_deep_holes", path)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def field_sum(field, values):
    answer = 0
    for value in values:
        answer = field.add(answer, value)
    return answer


def matrix_mul(field, left, right):
    return tuple(
        field_sum(field, (field.mul(left[3 * i + k], right[3 * k + j]) for k in range(3)))
        for i in range(3) for j in range(3)
    )


def matrix_inverse(module, field, matrix):
    columns = tuple(tuple(matrix[3 * i + j] for i in range(3)) for j in range(3))
    return module.inverse3(field, columns)


def frame_matrix(module, field, frame):
    """Projectivity taking the standard frame to the displayed ordered frame."""
    inverse = module.inverse3(field, frame[:3])
    coefficients = module.mat_vec(field, inverse, frame[3])
    assert all(coefficients)
    return tuple(field.mul(frame[j][i], coefficients[j]) for i in range(3) for j in range(3))


def normalize_matrix(field, matrix):
    scale = field.inverse(next(value for value in matrix if value))
    return tuple(field.mul(scale, value) for value in matrix)


def twist_point(field, point, power):
    return tuple(field.frobenius(value, power) for value in point)


def apply_semilinear(module, field, transformation, point):
    power, matrix = transformation
    twisted = twist_point(field, point, power)
    return module.normalize(field, module.mat_vec(field, matrix, twisted))


def locus_stabilizer(module, field, locus):
    """Enumerate the full PGammaL stabilizer, using frame rigidity for exhaustion."""
    assert module.is_arc(field, locus)
    base_frame = tuple(locus[:4])
    transformations = {}
    for power in range(field.degree):
        twisted_frame = tuple(twist_point(field, point, power) for point in base_frame)
        source_inverse = matrix_inverse(module, field, frame_matrix(module, field, twisted_frame))
        for target_frame in permutations(locus, 4):
            if not module.is_arc(field, target_frame):
                continue
            matrix = normalize_matrix(
                field,
                matrix_mul(field, frame_matrix(module, field, target_frame), source_inverse),
            )
            transformation = (power, matrix)
            image = tuple(sorted(apply_semilinear(module, field, transformation, point) for point in locus))
            if image == locus:
                transformations[(power, matrix)] = transformation
    answer = tuple(transformations[key] for key in sorted(transformations))
    assert len(answer) == len(transformations)
    return answer


def deletion_form(module, field, parent, omitted):
    five = tuple(point for point in parent if point != omitted)
    assert len(five) == 5 and module.is_arc(field, five)
    basis = module.nullspace(field, [module.quadratic_row(field, point) for point in five])
    assert len(basis) == 1
    return basis[0]


def deletion_signature(module, field, parent, locus):
    """Unlabelled multiset of traces of the six deletion conics on the deep-hole locus."""
    blocks = []
    for omitted in parent:
        form = deletion_form(module, field, parent, omitted)
        block = tuple(index for index, point in enumerate(locus) if not module.evaluate_form(field, form, point))
        blocks.append(block)
    return tuple(sorted(blocks))


def rank_mod_prime(rows, prime):
    matrix = [[value % prime for value in row] for row in rows]
    rank = 0
    width = len(matrix[0]) if matrix else 0
    for column in range(width):
        pivot = next((i for i in range(rank, len(matrix)) if matrix[i][column]), None)
        if pivot is None:
            continue
        matrix[rank], matrix[pivot] = matrix[pivot], matrix[rank]
        inverse = pow(matrix[rank][column], -1, prime)
        matrix[rank] = [(inverse * value) % prime for value in matrix[rank]]
        for i in range(len(matrix)):
            if i == rank or not matrix[i][column]:
                continue
            factor = matrix[i][column]
            matrix[i] = [(x - factor * y) % prime for x, y in zip(matrix[i], matrix[rank])]
        rank += 1
    return rank


def signature_incidence(signatures):
    blocks = tuple(sorted({block for signature in signatures for block in signature if block}))
    rows = []
    for signature in signatures:
        counts = Counter(signature)
        rows.append(tuple(counts[block] for block in blocks))
    return blocks, tuple(rows)


def bipartite_relation(signatures, blocks, coefficient_prime):
    block_counts = Counter(block for signature in signatures for block in signature if block)
    if not blocks or set(block_counts.values()) != {2}:
        return None
    adjacency = {index: set() for index in range(len(signatures))}
    for block in blocks:
        endpoints = [index for index, signature in enumerate(signatures) if block in signature]
        assert len(endpoints) == 2
        left, right = endpoints
        adjacency[left].add(right)
        adjacency[right].add(left)
    colors = {0: 0}
    queue = [0]
    while queue:
        vertex = queue.pop(0)
        for neighbor in adjacency[vertex]:
            if neighbor not in colors:
                colors[neighbor] = 1 - colors[vertex]
                queue.append(neighbor)
            else:
                assert colors[neighbor] != colors[vertex]
    if len(colors) != len(signatures):
        return None
    parts = tuple(tuple(index for index in range(len(signatures)) if colors[index] == color) for color in (0, 1))
    assert len(parts[0]) == len(parts[1])
    shared = tuple(tuple(len(adjacency[left] & {right}) for right in parts[1]) for left in parts[0])
    zero_share = tuple(tuple(1 - value for value in row) for row in shared)
    shared_gram = tuple(
        tuple(sum(x * y for x, y in zip(left, right)) for right in shared) for left in shared
    )
    zero_gram = tuple(
        tuple(sum(x * y for x, y in zip(left, right)) for right in zero_share) for left in zero_share
    )
    for part in parts:
        assert Counter(block for index in part for block in signatures[index] if block) == Counter({block: 1 for block in blocks})
    degrees = Counter(len(neighbors) for neighbors in adjacency.values())
    locus_size = 1 + max(index for block in blocks for index in block)
    assert all(len(block) == 2 for block in blocks)
    for signature in signatures:
        nonempty = tuple(block for block in signature if block)
        assert Counter(index for block in nonempty for index in block) == Counter(range(locus_size))
    all_pairs = set(combinations(range(locus_size), 2))
    missing_pairs = tuple(sorted(all_pairs - set(blocks)))
    trace_degrees = Counter(index for block in blocks for index in block)
    missing_degrees = Counter(index for block in missing_pairs for index in block)
    return {
        "parts": [list(part) for part in parts],
        "degree_histogram": {str(degree): count for degree, count in sorted(degrees.items())},
        "edge_count": sum(map(len, adjacency.values())) // 2,
        "each_part_partitions_trace_blocks": True,
        "each_signature_is_perfect_matching": True,
        "trace_block_graph_degree_histogram": {
            str(degree): count for degree, count in sorted(Counter(trace_degrees.values()).items())
        },
        "missing_pair_count": len(missing_pairs),
        "missing_pair_degree_histogram": {
            str(degree): count for degree, count in sorted(Counter(missing_degrees.values()).items())
        },
        "shared_cross_matrix": [list(row) for row in shared],
        "zero_share_cross_matrix": [list(row) for row in zero_share],
        "coefficient_prime": coefficient_prime,
        "shared_rank": rank_mod_prime(shared, coefficient_prime),
        "zero_share_rank": rank_mod_prime(zero_share, coefficient_prime),
        "shared_gram_rank": rank_mod_prime(shared_gram, coefficient_prime),
        "zero_share_gram_rank": rank_mod_prime(zero_gram, coefficient_prime),
    }


def permutation_cycles(permutation):
    seen = set()
    cycles = []
    for start in range(len(permutation)):
        if start in seen:
            continue
        cycle = []
        value = start
        while value not in seen:
            seen.add(value)
            cycle.append(value)
            value = permutation[value]
        cycles.append(tuple(cycle))
    return tuple(sorted(map(len, cycles)))


def orbit_sizes(points, permutations_on_points):
    unseen = set(range(len(points)))
    sizes = []
    while unseen:
        seed = min(unseen)
        orbit = {permutation[seed] for permutation in permutations_on_points}
        unseen -= orbit
        sizes.append(len(orbit))
    return tuple(sorted(sizes))


def analyze_case(module, record, survivor_index):
    q = record["q"]
    field = module.FiniteField(q)
    survivor = record["survivors"][survivor_index]
    parent = tuple(tuple(point) for point in survivor["arc"])
    locus = tuple(tuple(point) for point in survivor["locus"])
    all_points = module.projective_points(field)
    assert module.is_arc(field, parent) and module.is_arc(field, locus)
    assert module.uncovered_locus(field, parent, all_points) == locus

    stabilizer = locus_stabilizer(module, field, locus)
    locus_actions = {
        tuple(apply_semilinear(module, field, transformation, point) for point in locus)
        for transformation in stabilizer
    }
    assert len(stabilizer) % len(locus_actions) == 0
    parents = tuple(sorted({
        tuple(sorted(apply_semilinear(module, field, transformation, point) for point in parent))
        for transformation in stabilizer
    }))
    assert all(module.uncovered_locus(field, candidate, all_points) == locus for candidate in parents)

    signatures_by_parent = {candidate: deletion_signature(module, field, candidate, locus) for candidate in parents}
    signature_fibres = Counter(signatures_by_parent.values())
    signatures = tuple(sorted(signature_fibres))
    block_profiles = Counter(tuple(sorted(map(len, signature))) for signature in signatures)

    overlaps = Counter()
    for left, right in combinations(signatures, 2):
        left_nonempty = Counter(block for block in left if block)
        right_nonempty = Counter(block for block in right if block)
        shared = sum((left_nonempty & right_nonempty).values())
        overlaps[shared] += 1

    blocks, incidence = signature_incidence(signatures)
    primes = (2, 3, 5, 7, 11)
    ranks = {str(prime): rank_mod_prime(incidence, prime) for prime in primes}

    coefficient_prime = field.p if q == 9 else (3 if q == 11 else field.p)
    relation = bipartite_relation(signatures, blocks, coefficient_prime)
    induced_action = None
    if len(signatures) == len(parents):
        signature_index = {signature: index for index, signature in enumerate(signatures)}
        parent_for_signature = {signature: candidate for candidate, signature in signatures_by_parent.items()}
        permutations_on_signatures = set()
        for transformation in stabilizer:
            permutation = []
            for signature in signatures:
                candidate = parent_for_signature[signature]
                image_parent = tuple(sorted(
                    apply_semilinear(module, field, transformation, point) for point in candidate
                ))
                permutation.append(signature_index[signatures_by_parent[image_parent]])
            permutations_on_signatures.add(tuple(permutation))
        cycle_profiles = Counter(permutation_cycles(permutation) for permutation in permutations_on_signatures)
        induced_action = {
            "order": len(permutations_on_signatures),
            "cycle_profile_histogram": {str(profile): count for profile, count in sorted(cycle_profiles.items())},
        }
        if relation is not None:
            first_part = set(relation["parts"][0])
            preserving = tuple(
                permutation for permutation in permutations_on_signatures
                if {permutation[index] for index in first_part} == first_part
            )
            induced_on_part = {
                tuple(permutation[index] for index in sorted(first_part)) for permutation in preserving
            }
            relation["part_preserving_action_order"] = len(preserving)
            relation["induced_action_on_one_part_order"] = len(induced_on_part)
            relation["part_preserving_cycle_profile_histogram"] = {
                str(profile): count for profile, count in sorted(Counter(
                    permutation_cycles(tuple(sorted(first_part).index(permutation[index]) for index in sorted(first_part)))
                    for permutation in preserving
                ).items())
            }

    parent_stabilizer_orders = Counter()
    signature_stabilizer_orders = Counter()
    representative_parent_stabilizer = []
    for candidate, signature in signatures_by_parent.items():
        fixing_parent = tuple(
            transformation for transformation in stabilizer
            if tuple(sorted(apply_semilinear(module, field, transformation, point) for point in candidate)) == candidate
        )
        parent_stabilizer_orders[len(fixing_parent)] += 1
        if candidate == parent:
            representative_parent_stabilizer = list(fixing_parent)
        signature_stabilizer_orders[sum(
            deletion_signature(
                module,
                field,
                tuple(sorted(apply_semilinear(module, field, transformation, point) for point in candidate)),
                locus,
            ) == signature
            for transformation in stabilizer
        )] += 1

    assert representative_parent_stabilizer
    locus_index = {point: index for index, point in enumerate(locus)}
    parent_automorphism_permutations = {
        tuple(locus_index[apply_semilinear(module, field, transformation, point)] for point in locus)
        for transformation in representative_parent_stabilizer
    }
    deep_hole_orbits = orbit_sizes(locus, parent_automorphism_permutations)

    return {
        "q": q,
        "survivor_index": survivor_index,
        "locus_size": len(locus),
        "locus": [list(point) for point in locus],
        "representative_parent": [list(point) for point in parent],
        "semilinear_locus_stabilizer_order": len(stabilizer),
        "induced_locus_permutation_group_order": len(locus_actions),
        "pointwise_locus_kernel_order": len(stabilizer) // len(locus_actions),
        "fixed_locus_parent_fibre_size": len(parents),
        "distinct_deletion_trace_signatures": len(signatures),
        "decoration_is_injective": len(signatures) == len(parents),
        "signature_fibre_size_histogram": {str(size): count for size, count in sorted(Counter(signature_fibres.values()).items())},
        "block_profile_histogram": {str(profile): count for profile, count in sorted(block_profiles.items())},
        "pair_shared_nonempty_block_histogram": {str(shared): count for shared, count in sorted(overlaps.items())},
        "nonempty_trace_blocks": [[list(locus[index]) for index in block] for block in blocks],
        "signature_incidence_ranks": ranks,
        "signature_overlap_relation": relation,
        "induced_action_on_signatures": induced_action,
        "parent_stabilizer_order_histogram": {str(order): count for order, count in sorted(parent_stabilizer_orders.items())},
        "signature_stabilizer_order_histogram": {str(order): count for order, count in sorted(signature_stabilizer_orders.items())},
        "representative_parent_semilinear_automorphism_order": len(representative_parent_stabilizer),
        "induced_parent_automorphism_action_on_locus_order": len(parent_automorphism_permutations),
        "projective_deep_hole_orbit_sizes": list(deep_hole_orbits),
        "signatures": [[list(block) for block in signature] for signature in signatures],
    }


def build_certificate(root: Path):
    module = load_upstream_module(root)
    upstream_json = root / "notes" / f"{UPSTREAM}.json"
    upstream_bytes = upstream_json.read_bytes()
    data = json.loads(upstream_bytes)
    cases = []
    for record in data["fields"]:
        if record["q"] not in (8, 9, 11):
            continue
        for survivor_index in range(len(record["survivors"])):
            cases.append(analyze_case(module, record, survivor_index))
    cases.sort(key=lambda case: (case["q"], case["locus_size"], case["survivor_index"]))
    assert [(case["q"], case["locus_size"]) for case in cases] == [(8, 4), (9, 6), (9, 7), (11, 12)]
    assert [case["semilinear_locus_stabilizer_order"] for case in cases] == [72, 48, 12, 1320]
    assert [case["fixed_locus_parent_fibre_size"] for case in cases] == [6, 8, 2, 22]
    assert [case["distinct_deletion_trace_signatures"] for case in cases] == [1, 8, 1, 22]
    assert [case["decoration_is_injective"] for case in cases] == [False, True, False, True]
    return {
        "schema": SCHEMA,
        "upstream": {
            "artifact": f"notes/{UPSTREAM}.json",
            "bytes": len(upstream_bytes),
            "sha256": hashlib.sha256(upstream_bytes).hexdigest(),
        },
        "definition": "multiset over omitted parent points x of C(parent-minus-x) intersect U(parent)",
        "cases": cases,
        "verdict": {
            "recovering_rows": [[9, 6], [11, 12]],
            "nonrecovering_rows": [[8, 4], [9, 7]],
            "sharp_statement": "deletion-conic trace decoration recovers exactly two of the four C398 fixed-locus parent fibres",
        },
    }


def canonical_bytes(value):
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[1]
    output = root / "notes" / f"{STEM}.json"
    generated = canonical_bytes(build_certificate(root))
    if args.check:
        assert output.read_bytes() == generated
        print(f"checked {output.relative_to(root)} ({len(generated)} bytes)")
        return
    with tempfile.NamedTemporaryFile(dir=output.parent, delete=False) as handle:
        handle.write(generated)
        temporary = Path(handle.name)
    temporary.replace(output)
    print(f"wrote {output.relative_to(root)} ({len(generated)} bytes)")


if __name__ == "__main__":
    main()
