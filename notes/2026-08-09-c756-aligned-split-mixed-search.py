#!/usr/bin/env python3
"""Search the q=53 aligned split-covariance branch of C756.

The distinguished polar line is secant.  Scaling the split conic and its
coordinates reduces both apparent offset square classes to the single model
UV=2, where 2 is a nonsquare.  Every one of the 26 internal directions has a
normalized line

    u U + u^{-1} V + s = 0.

Lines may be secants or passants; tangent states are excluded.  Edges require
their intersection to be internal, and triples are forbidden from being
concurrent.  At size eleven the star centroid determines the affine shift,
after which the rank-two moment equations are checked exactly.
"""

from __future__ import annotations

import argparse
from dataclasses import dataclass
import json
import multiprocessing
from pathlib import Path
import random


Q = 53
NONSQUARE = 2
TARGET_SIZE = 11


def chi(x: int) -> int:
    x %= Q
    if x == 0:
        return 0
    return 1 if pow(x, (Q - 1) // 2, Q) == 1 else -1


assert chi(NONSQUARE) == -1


def canonical_sign(x: int) -> tuple[int, int]:
    """Return the representative of {x,-x} and the applied sign."""
    x %= Q
    negative = -x % Q
    return (x, 1) if x < negative else (negative, -1)


DIRECTIONS = sorted({canonical_sign(x)[0] for x in range(1, Q)})
DIRECTION_INDEX = {u: i for i, u in enumerate(DIRECTIONS)}


@dataclass(frozen=True, order=True)
class Vertex:
    direction: int
    s: int


def coefficients(vertex: Vertex) -> tuple[int, int]:
    u = DIRECTIONS[vertex.direction]
    return u, pow(u, -1, Q)


def vertices(d: int) -> list[Vertex]:
    result = []
    for direction in range(len(DIRECTIONS)):
        for s in range(Q):
            if (s * s - 4 * d) % Q != 0:
                result.append(Vertex(direction, s))
    return result


def line_character(vertex: Vertex, d: int) -> int:
    """+1 for a secant and -1 for a passant."""
    return chi(vertex.s * vertex.s - 4 * d)


def node_q(left: Vertex, right: Vertex, d: int) -> int:
    ai, bi = coefficients(left)
    aj, bj = coefficients(right)
    determinant = (ai * bj - aj * bi) % Q
    assert determinant != 0
    u = (bi * right.s - bj * left.s) * pow(determinant, -1, Q) % Q
    v = (aj * left.s - ai * right.s) * pow(determinant, -1, Q) % Q
    return (u * v - d) % Q


def graph(d: int) -> tuple[list[Vertex], list[int]]:
    verts = vertices(d)
    adjacency = [0] * len(verts)
    for i, left in enumerate(verts):
        for j in range(i):
            right = verts[j]
            if left.direction == right.direction:
                continue
            node_value = node_q(left, right, d)
            ai, bi = coefficients(left)
            aj, bj = coefficients(right)
            determinant = (ai * bj - aj * bi) % Q
            trace = (ai * bj + aj * bi) % Q
            numerator = node_value * determinant * determinant % Q
            factor_product = (
                (2 * left.s - trace * right.s) ** 2
                - determinant * determinant * (right.s * right.s - 4 * d)
            ) % Q
            assert (-4 * numerator) % Q == factor_product
            if chi(node_value) == 1:
                adjacency[i] |= 1 << j
                adjacency[j] |= 1 << i
    return verts, adjacency


def concurrency_forbidden_masks(verts: list[Vertex]):
    index = {(vertex.direction, vertex.s): i for i, vertex in enumerate(verts)}
    cache: dict[tuple[int, int], int] = {}

    def forbidden(i: int, j: int) -> int:
        key = (min(i, j), max(i, j))
        if key in cache:
            return cache[key]
        left, right = verts[i], verts[j]
        ai, bi = coefficients(left)
        aj, bj = coefficients(right)
        determinant = (ai * bj - aj * bi) % Q
        assert determinant != 0
        mask = 0
        for direction in range(len(DIRECTIONS)):
            if direction in (left.direction, right.direction):
                continue
            ak, bk = coefficients(Vertex(direction, 0))
            value = -(
                left.s * (aj * bk - ak * bj)
                - right.s * (ai * bk - ak * bi)
            ) * pow(determinant, -1, Q) % Q
            vertex = index.get((direction, value))
            if vertex is not None:
                mask |= 1 << vertex
        cache[key] = mask
        return mask

    return forbidden


def color_sort(candidates: int, adjacency: list[int]) -> tuple[list[int], list[int]]:
    order = []
    bounds = []
    remaining = candidates
    color = 0
    while remaining:
        color += 1
        available = remaining
        while available:
            bit = available & -available
            vertex = bit.bit_length() - 1
            order.append(vertex)
            bounds.append(color)
            remaining ^= bit
            available ^= bit
            available &= ~adjacency[vertex]
    return order, bounds


def exact_target_search(d: int) -> dict[str, object]:
    """Find a normalized size-eleven star or exhaust the exact domain."""
    verts, adjacency = graph(d)
    forbidden = concurrency_forbidden_masks(verts)
    full = (1 << len(verts)) - 1
    search_nodes = 0

    def search(chosen: list[int], candidates: int) -> list[int] | None:
        nonlocal search_nodes
        search_nodes += 1
        if len(chosen) == TARGET_SIZE:
            return chosen.copy()
        order, bounds = color_sort(candidates, adjacency)
        for position in range(len(order) - 1, -1, -1):
            if len(chosen) + bounds[position] < TARGET_SIZE:
                return None
            vertex = order[position]
            bit = 1 << vertex
            if not candidates & bit:
                continue
            next_candidates = candidates & adjacency[vertex]
            for prior in chosen:
                next_candidates &= ~forbidden(prior, vertex)
            chosen.append(vertex)
            answer = search(chosen, next_candidates)
            chosen.pop()
            if answer is not None:
                return answer
            candidates ^= bit
        return None

    answer = None
    for seed, vertex in enumerate(verts):
        if vertex.direction != 0:
            continue
        answer = search([seed], full & adjacency[seed])
        if answer is not None:
            break
    selected = None if answer is None else sorted(verts[index] for index in answer)
    gradient = None
    hessian_open = None
    if selected is not None:
        gradient, hessian = critical_data(selected)
        hessian_open = all(hessian[i][j] != 0 for i in range(11) for j in range(i))
    return {
        "d": d,
        "chi_d": chi(d),
        "vertex_count": len(verts),
        "search_nodes": search_nodes,
        "exhausted_without_size_11": selected is None,
        "witness": None if selected is None else [[v.direction, v.s] for v in selected],
        "witness_gradient": gradient,
        "witness_hessian_open": hessian_open,
    }


def centered_offsets(chosen: list[Vertex]) -> list[int]:
    sum_u = 0
    sum_v = 0
    for i, left in enumerate(chosen):
        ai, bi = coefficients(left)
        for right in chosen[:i]:
            aj, bj = coefficients(right)
            determinant = (ai * bj - aj * bi) % Q
            inverse = pow(determinant, -1, Q)
            sum_u += (bi * right.s - bj * left.s) * inverse
            sum_v += (aj * left.s - ai * right.s) * inverse
    inverse_count = pow(55, -1, Q)
    center_u = sum_u * inverse_count % Q
    center_v = sum_v * inverse_count % Q
    return [
        (vertex.s + coefficients(vertex)[0] * center_u
         + coefficients(vertex)[1] * center_v) % Q
        for vertex in chosen
    ]


def matching_sums(mask: int, c: list[int], gram: list[list[int]], memo):
    if mask in memo:
        return memo[mask]
    first_bit = mask & -mask
    i = first_bit.bit_length() - 1
    rest = mask ^ first_bit
    monomer = matching_sums(rest, c, gram, memo)
    result = [c[i] * value % Q for value in monomer]
    scan = rest
    while scan:
        bit = scan & -scan
        j = bit.bit_length() - 1
        paired = matching_sums(rest ^ bit, c, gram, memo)
        if len(result) < len(paired) + 1:
            result.extend([0] * (len(paired) + 1 - len(result)))
        for degree, value in enumerate(paired):
            result[degree + 1] += gram[i][j] * value
            result[degree + 1] %= Q
        scan ^= bit
    memo[mask] = result
    return result


def weighted_value(values: list[int]) -> int:
    total = 0
    for r, value in enumerate(values):
        coefficient = 2
        for integer in range(r + 1, 2 * r + 1):
            coefficient = coefficient * pow(integer, -1, Q) % Q
        total += coefficient * value
    return total % Q


def critical_data(
    chosen: list[Vertex], *, include_hessian: bool = True,
    stop_on_nonzero: bool = False,
) -> tuple[list[int], list[list[int]] | None]:
    chosen = sorted(chosen)
    c = centered_offsets(chosen)
    size = len(chosen)
    gram = [[0] * size for _ in range(size)]
    for i, left in enumerate(chosen):
        ai, bi = coefficients(left)
        for j, right in enumerate(chosen[:i]):
            aj, bj = coefficients(right)
            gram[i][j] = gram[j][i] = (ai * bj + aj * bi) % Q
    full = (1 << size) - 1
    memo = {0: [1]}
    gradient = []
    for i in range(size):
        gradient.append(weighted_value(matching_sums(full ^ (1 << i), c, gram, memo)))
        if stop_on_nonzero and gradient[-1] != 0:
            return gradient, None
    if not include_hessian:
        return gradient, None
    hessian = [[0] * size for _ in range(size)]
    for i in range(size):
        for j in range(i):
            value = weighted_value(
                matching_sums(full ^ (1 << i) ^ (1 << j), c, gram, memo)
            )
            hessian[i][j] = hessian[j][i] = value
    return gradient, hessian


def direct_partition(chosen: list[Vertex], excluded: set[int]) -> int:
    """Independent balanced-coefficient evaluation of the moment functional."""
    chosen = sorted(chosen)
    c = centered_offsets(chosen)
    polynomial = {(0, 0): 1}
    for i, vertex in enumerate(chosen):
        if i in excluded:
            continue
        a, b = coefficients(vertex)
        updated: dict[tuple[int, int], int] = {}
        for (u_degree, v_degree), coefficient in polynomial.items():
            for degree, multiplier in (
                ((u_degree, v_degree), c[i]),
                ((u_degree + 1, v_degree), a),
                ((u_degree, v_degree + 1), b),
            ):
                updated[degree] = (updated.get(degree, 0) + coefficient * multiplier) % Q
        polynomial = updated
    answer = 0
    for r in range(6):
        central_binomial = 1
        for integer in range(1, r + 1):
            central_binomial = central_binomial * (r + integer) * pow(integer, -1, Q) % Q
        answer += 2 * pow(central_binomial, -1, Q) * polynomial.get((r, r), 0)
    return answer % Q


def check_candidate(chosen: list[Vertex], d: int) -> None:
    """Cross-check geometry and the two partition-function implementations."""
    chosen = sorted(chosen)
    for i, left in enumerate(chosen):
        assert (left.s * left.s - 4 * d) % Q != 0
        for j, right in enumerate(chosen[:i]):
            assert chi(node_q(left, right, d)) == 1
            ai, bi = coefficients(left)
            aj, bj = coefficients(right)
            for third in chosen[:j]:
                ak, bk = coefficients(third)
                determinant = (
                    left.s * (aj * bk - ak * bj)
                    - right.s * (ai * bk - ak * bi)
                    + third.s * (ai * bj - aj * bi)
                ) % Q
                assert determinant != 0
    gradient, hessian = critical_data(chosen)
    assert hessian is not None
    assert gradient == [direct_partition(chosen, {i}) for i in range(11)]
    assert all(
        hessian[i][j] == direct_partition(chosen, {i, j})
        for i in range(11) for j in range(i)
    )


def enumerate_candidates(d: int, seed_values: tuple[int, ...] | None = None) -> dict[str, object]:
    """Exhaust all normalized geometric stars and retain compact statistics."""
    verts, adjacency = graph(d)
    forbidden = concurrency_forbidden_masks(verts)
    full = (1 << len(verts)) - 1
    search_nodes = 0
    leaves = 0
    critical_open = 0
    critical_total = 0
    maximum_zero_prefix = -1
    best_witness = None
    critical_prefix_counts: dict[int, int] = {}
    first_derivative_counts: dict[int, int] = {}
    type_profiles: dict[tuple[int, int], int] = {}

    def search(chosen: list[int], candidates: int) -> None:
        nonlocal search_nodes, leaves, critical_open, critical_total
        nonlocal maximum_zero_prefix, best_witness
        search_nodes += 1
        if len(chosen) == TARGET_SIZE:
            leaves += 1
            selected = sorted(verts[index] for index in chosen)
            gradient, _ = critical_data(
                selected, include_hessian=False, stop_on_nonzero=True
            )
            zero_prefix = len(gradient) if gradient[-1] == 0 else len(gradient) - 1
            first_derivative_counts[gradient[0]] = (
                first_derivative_counts.get(gradient[0], 0) + 1
            )
            critical_prefix_counts[zero_prefix] = (
                critical_prefix_counts.get(zero_prefix, 0) + 1
            )
            is_open = False
            if zero_prefix == 11:
                critical_total += 1
                _, hessian = critical_data(selected)
                assert hessian is not None
                is_open = all(
                    hessian[i][j] != 0 for i in range(11) for j in range(i)
                )
                critical_open += int(is_open)
            profile = (
                sum(line_character(vertex, d) == 1 for vertex in selected),
                sum(line_character(vertex, d) == -1 for vertex in selected),
            )
            type_profiles[profile] = type_profiles.get(profile, 0) + 1
            if zero_prefix > maximum_zero_prefix:
                maximum_zero_prefix = zero_prefix
                best_witness = [[vertex.direction, vertex.s] for vertex in selected]
                check_candidate(selected, d)
            return
        order, bounds = color_sort(candidates, adjacency)
        for position in range(len(order) - 1, -1, -1):
            if len(chosen) + bounds[position] < TARGET_SIZE:
                return
            vertex = order[position]
            bit = 1 << vertex
            if not candidates & bit:
                continue
            next_candidates = candidates & adjacency[vertex]
            for prior in chosen:
                next_candidates &= ~forbidden(prior, vertex)
            chosen.append(vertex)
            search(chosen, next_candidates)
            chosen.pop()
            candidates ^= bit

    for seed, vertex in enumerate(verts):
        allowed_seed = (
            vertex.s <= (Q - 1) // 2 if seed_values is None
            else vertex.s in seed_values
        )
        if vertex.direction == 0 and allowed_seed:
            search([seed], full & adjacency[seed])
    return {
        "d": d,
        "chi_d": chi(d),
        "vertex_count": len(verts),
        "search_nodes": search_nodes,
        "normalized_candidates": leaves,
        "critical_total": critical_total,
        "critical_open": critical_open,
        "maximum_zero_prefix": maximum_zero_prefix,
        "best_witness": best_witness,
        "critical_prefix_counts": [
            {"zero_prefix": key, "count": value}
            for key, value in sorted(critical_prefix_counts.items())
        ],
        "first_derivative_histogram": [
            {"value": key, "count": value}
            for key, value in sorted(first_derivative_counts.items())
        ],
        "type_profiles": [
            {"secants": key[0], "passants": key[1], "count": value}
            for key, value in sorted(type_profiles.items())
        ],
    }


def enumerate_one_seed(arguments: tuple[int, int]) -> dict[str, object]:
    d, seed = arguments
    return enumerate_candidates(d, (seed,))


def enumerate_parallel(d: int, workers: int) -> dict[str, object]:
    seeds = tuple(range((Q + 1) // 2))
    with multiprocessing.get_context("fork").Pool(processes=workers) as pool:
        pieces = pool.map(enumerate_one_seed, [(d, seed) for seed in seeds], chunksize=1)
    best_piece = max(pieces, key=lambda piece: int(piece["maximum_zero_prefix"]))
    profiles: dict[tuple[int, int], int] = {}
    prefix_counts: dict[int, int] = {}
    first_derivative_counts: dict[int, int] = {}
    for piece in pieces:
        for row in piece["type_profiles"]:
            key = (int(row["secants"]), int(row["passants"]))
            profiles[key] = profiles.get(key, 0) + int(row["count"])
        for row in piece["critical_prefix_counts"]:
            key = int(row["zero_prefix"])
            prefix_counts[key] = prefix_counts.get(key, 0) + int(row["count"])
        for row in piece["first_derivative_histogram"]:
            key = int(row["value"])
            first_derivative_counts[key] = (
                first_derivative_counts.get(key, 0) + int(row["count"])
            )
    return {
        "d": d,
        "chi_d": chi(d),
        "vertex_count": int(pieces[0]["vertex_count"]),
        "workers": workers,
        "seed_orbits": list(seeds),
        "search_nodes": sum(int(piece["search_nodes"]) for piece in pieces),
        "normalized_candidates": sum(int(piece["normalized_candidates"]) for piece in pieces),
        "critical_total": sum(int(piece["critical_total"]) for piece in pieces),
        "critical_open": sum(int(piece["critical_open"]) for piece in pieces),
        "maximum_zero_prefix": int(best_piece["maximum_zero_prefix"]),
        "best_witness": best_piece["best_witness"],
        "critical_prefix_counts": [
            {"zero_prefix": key, "count": value}
            for key, value in sorted(prefix_counts.items())
        ],
        "first_derivative_histogram": [
            {"value": key, "count": value}
            for key, value in sorted(first_derivative_counts.items())
        ],
        "type_profiles": [
            {"secants": key[0], "passants": key[1], "count": value}
            for key, value in sorted(profiles.items())
        ],
    }


def random_candidates(d: int, trials: int) -> dict[str, object]:
    verts, adjacency = graph(d)
    forbidden = concurrency_forbidden_masks(verts)
    generator = random.Random(756053 + d)
    roots = [i for i, vertex in enumerate(verts) if vertex.direction == 0]
    full = (1 << len(verts)) - 1
    completed = 0
    critical = 0
    best_zero_gradient = -1
    best = None
    type_profiles: dict[tuple[int, int], int] = {}
    for _ in range(trials):
        chosen = [generator.choice(roots)]
        candidates = full & adjacency[chosen[0]]
        while candidates and len(chosen) < TARGET_SIZE:
            pool = []
            scan = candidates
            while scan:
                bit = scan & -scan
                pool.append(bit.bit_length() - 1)
                scan ^= bit
            generator.shuffle(pool)
            scored = []
            for vertex in pool[:32]:
                next_candidates = candidates & adjacency[vertex]
                for prior in chosen:
                    next_candidates &= ~forbidden(prior, vertex)
                scored.append((next_candidates.bit_count(), vertex, next_candidates))
            _, vertex, candidates = max(scored)
            chosen.append(vertex)
        if len(chosen) != TARGET_SIZE:
            continue
        completed += 1
        selected = sorted(verts[index] for index in chosen)
        profile = (
            sum(line_character(vertex, d) == 1 for vertex in selected),
            sum(line_character(vertex, d) == -1 for vertex in selected),
        )
        type_profiles[profile] = type_profiles.get(profile, 0) + 1
        gradient, hessian = critical_data(selected)
        zero_count = sum(value == 0 for value in gradient)
        is_open = all(hessian[i][j] != 0 for i in range(11) for j in range(i))
        critical += int(zero_count == 11 and is_open)
        if zero_count > best_zero_gradient:
            best_zero_gradient = zero_count
            best = [[vertex.direction, vertex.s] for vertex in selected]
    return {
        "d": d,
        "chi_d": chi(d),
        "vertex_count": len(verts),
        "trials": trials,
        "completed": completed,
        "critical_open": critical,
        "best_zero_gradient": best_zero_gradient,
        "best": best,
        "type_profiles": [
            {"secants": key[0], "passants": key[1], "hits": value}
            for key, value in sorted(type_profiles.items())
        ],
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--sample", type=int, default=0)
    parser.add_argument("--exact", action="store_true")
    parser.add_argument("--enumerate", action="store_true")
    parser.add_argument("--output", type=Path)
    parser.add_argument("--check", type=Path)
    parser.add_argument("--workers", type=int, default=1)
    parser.add_argument("--seed-s", type=int)
    args = parser.parse_args()
    selected_modes = sum((bool(args.sample), args.exact, args.enumerate, args.check is not None))
    if selected_modes != 1:
        parser.error("select exactly one of --sample N, --exact, --enumerate, or --check FILE")
    if args.check is not None:
        args.enumerate = True
    if args.seed_s is not None and (not args.enumerate or args.workers != 1):
        parser.error("--seed-s requires --enumerate --workers 1")
    mode = "enumerate" if args.enumerate else "exact" if args.exact else "sample"
    output = {
        "schema": "c756-aligned-split-mixed-v1",
        "q": Q,
        "direction_count": len(DIRECTIONS),
        "mode": mode,
        "normal_form": "UV=2 with internal point character chi(UV-2)=+1",
        "cases": [
            (enumerate_parallel(NONSQUARE, args.workers)
             if args.enumerate and args.workers > 1 else
             enumerate_candidates(
                 NONSQUARE,
                 None if args.seed_s is None else (args.seed_s,),
             ) if args.enumerate else
             exact_target_search(NONSQUARE) if args.exact else
             random_candidates(NONSQUARE, args.sample))
        ],
    }
    serialized = json.dumps(output, indent=2, sort_keys=True) + "\n"
    if args.check is not None:
        tracked = args.check.read_text()
        if serialized != tracked:
            raise SystemExit(f"certificate mismatch: {args.check}")
        print(f"certificate ok: {args.check}")
    elif args.output is not None:
        args.output.write_text(serialized)
        print(f"wrote {args.output}")
    else:
        print(serialized, end="")


if __name__ == "__main__":
    main()
