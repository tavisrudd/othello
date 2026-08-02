#!/usr/bin/env python3
"""Exact small-order census for aligned two-graph certificates.

A two-graph on n labelled vertices is stored by the graph on vertices
0,...,n-2 obtained after choosing n-1 as root.  Its edge ij is the value of
the two-graph on {i,j,n-1}.  The aligned certificate marks a four-set when
its four triple values are all equal.  Complementing every triple leaves the
certificate unchanged.
"""

from __future__ import annotations

import argparse
import itertools
import json
from collections import Counter, deque
from pathlib import Path


SCHEMA = "c810-aligned-certificate-distance-v1"


def subsets(n: int, k: int) -> list[tuple[int, ...]]:
    return list(itertools.combinations(range(n), k))


def edge_data(n: int) -> tuple[list[tuple[int, int]], dict[tuple[int, int], int]]:
    edges = subsets(n - 1, 2)
    return edges, {e: i for i, e in enumerate(edges)}


def tau(mask: int, triple: tuple[int, int, int], n: int,
        edge_index: dict[tuple[int, int], int]) -> int:
    root = n - 1
    other = [v for v in triple if v != root]
    if len(other) == 2:
        return (mask >> edge_index[tuple(sorted(other))]) & 1
    value = 0
    for edge in itertools.combinations(sorted(other), 2):
        value ^= (mask >> edge_index[edge]) & 1
    return value


def certificate(mask: int, n: int, fours: list[tuple[int, ...]],
                edge_index: dict[tuple[int, int], int]) -> int:
    answer = 0
    for bit, four in enumerate(fours):
        values = [tau(mask, t, n, edge_index) for t in itertools.combinations(four, 3)]
        if len(set(values)) == 1:
            answer |= 1 << bit
    return answer


def certificate_by_graph(mask: int, n: int, fours: list[tuple[int, ...]],
                         edge_index: dict[tuple[int, int], int]) -> int:
    """Independent formula: root each four-set at its least vertex."""
    answer = 0
    for bit, four in enumerate(fours):
        root, *vertices = four
        signs = []
        for i, j in itertools.combinations(vertices, 2):
            signs.append(tau(mask, tuple(sorted((root, i, j))), n, edge_index))
        if signs[0] == signs[1] == signs[2]:
            answer |= 1 << bit
    return answer


def adjacent_permutations(n: int) -> list[tuple[int, ...]]:
    result = []
    for i in range(n - 1):
        p = list(range(n))
        p[i], p[i + 1] = p[i + 1], p[i]
        result.append(tuple(p))
    return result


def compose(p: tuple[int, ...], q: tuple[int, ...]) -> tuple[int, ...]:
    """Maps are new-label to old-label; apply q, then p."""
    return tuple(p[q[i]] for i in range(len(p)))


def permute_mask(mask: int, p: tuple[int, ...], n: int,
                 edge_index: dict[tuple[int, int], int]) -> int:
    root = n - 1
    answer = 0
    for edge, bit in edge_index.items():
        triple = tuple(sorted((p[root], p[edge[0]], p[edge[1]])))
        answer |= tau(mask, triple, n, edge_index) << bit
    return answer


def permute_certificate(cert: int, p: tuple[int, ...], fours: list[tuple[int, ...]],
                        four_index: dict[tuple[int, ...], int]) -> int:
    answer = 0
    for new_bit, four in enumerate(fours):
        old_four = tuple(sorted(p[v] for v in four))
        answer |= ((cert >> four_index[old_four]) & 1) << new_bit
    return answer


def object_orbits(n: int) -> tuple[list[int], list[int], list[int]]:
    edges, edge_index = edge_data(n)
    generators = adjacent_permutations(n)
    full = (1 << len(edges)) - 1
    state_count = 1 << len(edges)
    class_of = [-1] * state_count
    representatives = []
    sizes = []
    for start in range(state_count):
        if class_of[start] >= 0:
            continue
        class_id = len(representatives)
        orbit = {start}
        queue = deque([start])
        while queue:
            current = queue.popleft()
            neighbors = [current ^ full]
            neighbors.extend(permute_mask(current, p, n, edge_index) for p in generators)
            for neighbor in neighbors:
                if neighbor not in orbit:
                    orbit.add(neighbor)
                    queue.append(neighbor)
        representative = min(orbit)
        for state in orbit:
            if class_of[state] >= 0:
                raise AssertionError("orbit partition overlap")
            class_of[state] = class_id
        representatives.append(representative)
        sizes.append(len(orbit))
    return representatives, sizes, class_of


def certificate_orbit(cert: int, n: int, fours: list[tuple[int, ...]],
                      four_index: dict[tuple[int, ...], int]) -> dict[int, tuple[int, ...]]:
    identity = tuple(range(n))
    seen = {cert: identity}
    queue = deque([cert])
    generators = adjacent_permutations(n)
    while queue:
        current = queue.popleft()
        current_perm = seen[current]
        for generator in generators:
            neighbor = permute_certificate(current, generator, fours, four_index)
            if neighbor not in seen:
                seen[neighbor] = compose(current_perm, generator)
                queue.append(neighbor)
    return seen


def edge_list(mask: int, edges: list[tuple[int, int]]) -> list[list[int]]:
    return [list(edge) for bit, edge in enumerate(edges) if (mask >> bit) & 1]


def four_list(cert: int, fours: list[tuple[int, ...]]) -> list[list[int]]:
    return [list(four) for bit, four in enumerate(fours) if (cert >> bit) & 1]


def is_conference(mask: int, n: int, edge_index: dict[tuple[int, int], int]) -> bool:
    root = n - 1
    matrix = [[0] * n for _ in range(n)]
    for i in range(n):
        for j in range(i + 1, n):
            sign = 1 if root in (i, j) else (-1) ** tau(mask, (i, j, root), n, edge_index)
            matrix[i][j] = matrix[j][i] = sign
    for i in range(n):
        for j in range(n):
            inner = sum(matrix[i][k] * matrix[j][k] for k in range(n))
            target = n - 1 if i == j else 0
            if inner != target:
                return False
    return True


def neighborhood_minimum(cert_orbits: list[dict[int, tuple[int, ...]]], width: int) -> int | None:
    """Independent distance-0/1 test by hashing all labelled certificates."""
    owner: dict[int, int] = {}
    for class_id, orbit in enumerate(cert_orbits):
        for cert in orbit:
            previous = owner.get(cert)
            if previous is not None and previous != class_id:
                return 0
            owner[cert] = class_id
    for cert, class_id in owner.items():
        for bit in range(width):
            neighbor_owner = owner.get(cert ^ (1 << bit))
            if neighbor_owner is not None and neighbor_owner != class_id:
                return 1
    return None


def census(n: int) -> dict[str, object]:
    edges, edge_index = edge_data(n)
    fours = subsets(n, 4)
    four_index = {four: i for i, four in enumerate(fours)}
    representatives, orbit_sizes, class_of = object_orbits(n)
    certificates = [certificate(mask, n, fours, edge_index) for mask in representatives]

    # Independent certificate formula, checked on the complete labelled space.
    for mask in range(1 << len(edges)):
        left = certificate(mask, n, fours, edge_index)
        right = certificate_by_graph(mask, n, fours, edge_index)
        if left != right:
            raise AssertionError(f"certificate cross-check failed at n={n}, mask={mask}")

    cert_orbits = [certificate_orbit(cert, n, fours, four_index) for cert in certificates]
    neighborhood_result = neighborhood_minimum(cert_orbits, len(fours))
    spectrum: Counter[int] = Counter()
    nearest = None
    for i in range(len(representatives)):
        for j in range(i + 1, len(representatives)):
            cert_i = certificates[i]
            distance, witness_cert, witness_perm = min(
                ((cert_i ^ moved).bit_count(), moved, permutation)
                for moved, permutation in cert_orbits[j].items()
            )
            spectrum[distance] += 1
            candidate = (distance, i, j, witness_cert, witness_perm)
            if nearest is None or candidate < nearest:
                nearest = candidate

    # Fixed-label collisions among distinct complement pairs are another cheap
    # diagnostic; they need not be inequivalent under relabelling.
    full = (1 << len(edges)) - 1
    fixed_label_seen: dict[int, int] = {}
    fixed_collision = None
    for mask in range(1 << len(edges)):
        complement_pair = min(mask, mask ^ full)
        cert = certificate(mask, n, fours, edge_index)
        previous = fixed_label_seen.get(cert)
        if previous is not None and previous != complement_pair:
            fixed_collision = (previous, complement_pair, cert)
            break
        fixed_label_seen[cert] = complement_pair

    result: dict[str, object] = {
        "n": n,
        "rooted_graph_bits": len(edges),
        "labelled_two_graphs": 1 << len(edges),
        "labelled_mod_complement": 1 << (len(edges) - 1),
        "unlabelled_mod_complement": len(representatives),
        "symmetric_conference_classes": sum(
            is_conference(mask, n, edge_index) for mask in representatives
        ),
        "object_orbit_size_histogram": dict(sorted(Counter(orbit_sizes).items())),
        "quotient_pair_distance_spectrum": dict(sorted(spectrum.items())),
        "independent_distance_zero_or_one_search": neighborhood_result,
        "fixed_label_certificate_count": len(fixed_label_seen) if fixed_collision is None else None,
        "fixed_label_collision": None,
        "nearest_inequivalent_pair": None,
    }
    if fixed_collision is not None:
        a, b, cert = fixed_collision
        result["fixed_label_collision"] = {
            "rooted_graph_a": edge_list(a, edges),
            "rooted_graph_b": edge_list(b, edges),
            "aligned_four_sets": four_list(cert, fours),
        }
    if nearest is not None:
        distance, i, j, moved, permutation = nearest
        if distance <= 1 and neighborhood_result != distance:
            raise AssertionError("independent neighborhood search disagrees")
        if distance >= 2 and neighborhood_result is not None:
            raise AssertionError("independent neighborhood search found a closer pair")
        cert_i = certificates[i]
        moved_mask = permute_mask(representatives[j], permutation, n, edge_index)
        result["nearest_inequivalent_pair"] = {
            "distance": distance,
            "class_a": i,
            "class_b": j,
            "rooted_graph_a": edge_list(representatives[i], edges),
            "rooted_graph_b": edge_list(representatives[j], edges),
            "permutation_new_to_old_for_b": list(permutation),
            "rooted_graph_b_after_permutation": edge_list(moved_mask, edges),
            "aligned_four_sets_a": four_list(cert_i, fours),
            "aligned_four_sets_b_after_permutation": four_list(moved, fours),
            "differing_four_sets": four_list(cert_i ^ moved, fours),
        }
    return result


def generate() -> dict[str, object]:
    return {
        "schema": SCHEMA,
        "orders": [census(n) for n in range(4, 8)],
        "conventions": {
            "equivalence": "vertex relabelling and global two-graph complement",
            "distance": "minimum Hamming distance between certificate orbits under relabelling",
            "root": "vertex n-1",
            "four_set_order": "lexicographic combinations of 0,...,n-1",
        },
    }


def serialized(data: dict[str, object]) -> str:
    return json.dumps(data, indent=2, sort_keys=True) + "\n"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    tracked = Path(__file__).with_suffix(".json")
    text = serialized(generate())
    if args.check:
        if tracked.read_text() != text:
            raise SystemExit(f"generated output differs from {tracked}")
        print(f"checked {tracked.name}")
    elif args.output:
        args.output.write_text(text)
    else:
        print(text, end="")


if __name__ == "__main__":
    main()
