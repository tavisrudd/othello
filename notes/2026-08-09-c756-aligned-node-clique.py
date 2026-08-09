#!/usr/bin/env python3
"""Exact q=53 clique gate for the C756 aligned node characters.

Vertices are normalized passant lines (u,s), with N(u)=1 and
(u,s) identified with (-u,-s).  Edges mean that the two lines have a
nonconic intersection of the requested point character.  The computation
tests both square classes of d and both possible point-character conventions.
"""

from __future__ import annotations

from dataclasses import dataclass
import argparse
import json
import random


Q = 53


def chi(x: int) -> int:
    x %= Q
    if x == 0:
        return 0
    return 1 if pow(x, (Q - 1) // 2, Q) == 1 else -1


NONSQUARE = next(x for x in range(2, Q) if chi(x) == -1)


@dataclass(frozen=True, order=True)
class Fq2:
    a: int
    b: int

    def __neg__(self) -> "Fq2":
        return Fq2(-self.a % Q, -self.b % Q)

    def __add__(self, other: "Fq2") -> "Fq2":
        return Fq2((self.a + other.a) % Q, (self.b + other.b) % Q)

    def __sub__(self, other: "Fq2") -> "Fq2":
        return Fq2((self.a - other.a) % Q, (self.b - other.b) % Q)

    def __mul__(self, other: "Fq2") -> "Fq2":
        return Fq2(
            (self.a * other.a + NONSQUARE * self.b * other.b) % Q,
            (self.a * other.b + self.b * other.a) % Q,
        )

    def conj(self) -> "Fq2":
        return Fq2(self.a, -self.b % Q)

    def norm(self) -> int:
        return (self.a * self.a - NONSQUARE * self.b * self.b) % Q


def canonical_sign(u: Fq2) -> Fq2:
    return min(u, -u)


TORUS = sorted(
    {canonical_sign(Fq2(a, b)) for a in range(Q) for b in range(Q)
     if Fq2(a, b).norm() == 1}
)
ALPHA0 = next(
    Fq2(a, b) for a in range(Q) for b in range(Q)
    if Fq2(a, b).norm() == NONSQUARE
)


@dataclass(frozen=True)
class Vertex:
    direction: int
    s: int


def vertices(d: int, nu: int) -> list[Vertex]:
    discriminant_scale = 4 * d * nu % Q
    return [
        Vertex(i, s)
        for i in range(len(TORUS))
        for s in range(Q)
        if chi(s * s - discriminant_scale) == 1
    ]


def node_q(left: Vertex, right: Vertex, d: int, nu: int) -> int:
    ui = TORUS[left.direction]
    uj = TORUS[right.direction]
    z = ui * uj.conj()
    trace_z = 2 * z.a % Q
    tij = nu * trace_z % Q
    dij2 = (tij * tij - 4 * nu * nu) % Q
    assert dij2 != 0
    numerator = (
        -nu * (left.s * left.s + right.s * right.s)
        + left.s * right.s * tij
        - d * dij2
    ) % Q
    return numerator * pow(dij2, -1, Q) % Q


def graph(d: int, nu: int, target: int) -> tuple[list[Vertex], list[int]]:
    verts = vertices(d, nu)
    adjacency = [0] * len(verts)
    for i, vi in enumerate(verts):
        for j in range(i):
            vj = verts[j]
            if vi.direction == vj.direction:
                continue
            if chi(node_q(vi, vj, d, nu)) == target:
                adjacency[i] |= 1 << j
                adjacency[j] |= 1 << i
    return verts, adjacency


def centered_offsets(chosen: list[Vertex]) -> list[int]:
    """Translate the star-node centroid to zero and return its line offsets."""
    normals = [ALPHA0 * TORUS[vertex.direction] for vertex in chosen]
    sum_x = 0
    sum_y = 0
    for i, left in enumerate(chosen):
        ai = 2 * normals[i].a % Q
        bi = 2 * NONSQUARE * normals[i].b % Q
        for j in range(i):
            right = chosen[j]
            aj = 2 * normals[j].a % Q
            bj = 2 * NONSQUARE * normals[j].b % Q
            determinant = (ai * bj - aj * bi) % Q
            x = (-left.s * bj + right.s * bi) * pow(determinant, -1, Q) % Q
            y = (-ai * right.s + aj * left.s) * pow(determinant, -1, Q) % Q
            sum_x = (sum_x + x) % Q
            sum_y = (sum_y + y) % Q
    inverse_node_count = pow(55 % Q, -1, Q)
    center_x = sum_x * inverse_node_count % Q
    center_y = sum_y * inverse_node_count % Q
    return [
        (vertex.s + 2 * (normal.a * center_x
                         + NONSQUARE * normal.b * center_y)) % Q
        for vertex, normal in zip(chosen, normals)
    ]


def critical_and_hessian(
    chosen: list[Vertex],
) -> tuple[bool, bool, list[int], list[tuple[int, int]]]:
    """Evaluate the aligned weighted matching critical system exactly."""
    c = centered_offsets(chosen)
    size = len(chosen)
    gram = [[0] * size for _ in range(size)]
    for i in range(size):
        for j in range(i):
            z = TORUS[chosen[i].direction] * TORUS[chosen[j].direction].conj()
            # EJ2's matching expansion uses a_i^T M a_j, which is twice
            # the K=M/2 Gram entry denoted B_ij in the aligned report.
            gram[i][j] = gram[j][i] = 2 * NONSQUARE * z.a % Q
    memo: dict[int, list[int]] = {0: [1]}

    def matching_sums(mask: int) -> list[int]:
        if mask in memo:
            return memo[mask]
        first_bit = mask & -mask
        i = first_bit.bit_length() - 1
        rest = mask ^ first_bit
        monomer = matching_sums(rest)
        result = [c[i] * value % Q for value in monomer]
        scan = rest
        while scan:
            bit = scan & -scan
            j = bit.bit_length() - 1
            paired = matching_sums(rest ^ bit)
            if len(result) < len(paired) + 1:
                result.extend([0] * (len(paired) + 1 - len(result)))
            for degree, value in enumerate(paired):
                result[degree + 1] = (
                    result[degree + 1] + gram[i][j] * value
                ) % Q
            scan ^= bit
        memo[mask] = result
        return result

    weights = [
        2 * __import__("math").factorial(r)
        * pow(__import__("math").factorial(2 * r), -1, Q) % Q
        for r in range(6)
    ]

    def partition(mask: int) -> int:
        return sum(
            weights[r] * value for r, value in enumerate(matching_sums(mask))
        ) % Q

    full = (1 << size) - 1
    gradient = [partition(full ^ (1 << i)) for i in range(size)]
    critical = all(value == 0 for value in gradient)
    hessian_zeros = [
        (i, j) for i in range(size) for j in range(i)
        if partition(full ^ (1 << i) ^ (1 << j)) == 0
    ]
    return critical, not hessian_zeros, gradient, hessian_zeros


def direct_partition(chosen: list[Vertex], excluded: set[int]) -> int:
    """Independent balanced-coefficient evaluation of EJ2 equation (7)."""
    c = centered_offsets(chosen)
    polynomial: dict[tuple[int, int], Fq2] = {(0, 0): Fq2(1, 0)}
    for i, vertex in enumerate(chosen):
        if i in excluded:
            continue
        alpha = ALPHA0 * TORUS[vertex.direction]
        updated: dict[tuple[int, int], Fq2] = {}
        for (u_degree, v_degree), coefficient in polynomial.items():
            terms = (
                ((u_degree, v_degree), Fq2(c[i], 0)),
                ((u_degree + 1, v_degree), alpha),
                ((u_degree, v_degree + 1), alpha.conj()),
            )
            for degree, multiplier in terms:
                updated[degree] = updated.get(degree, Fq2(0, 0)) + coefficient * multiplier
        polynomial = updated
    answer = Fq2(0, 0)
    for r in range(6):
        coefficient = polynomial.get((r, r), Fq2(0, 0))
        weight = 2 * pow(__import__("math").comb(2 * r, r), -1, Q) % Q
        answer += Fq2(weight, 0) * coefficient
    assert answer.b == 0
    return answer.a


def direct_invariant_check(certificate: dict[str, object]) -> None:
    """Cross-check geometry and matching weights by independent formulas."""
    for case in certificate["cases"]:
        d = int(case["d"])
        target = int(case["node_character"])
        verts, _ = graph(d, NONSQUARE, target)
        for i, left in enumerate(verts):
            alpha_i = ALPHA0 * TORUS[left.direction]
            ai, bi = 2 * alpha_i.a % Q, 2 * NONSQUARE * alpha_i.b % Q
            for right in verts[:i]:
                if left.direction == right.direction:
                    continue
                alpha_j = ALPHA0 * TORUS[right.direction]
                aj, bj = 2 * alpha_j.a % Q, 2 * NONSQUARE * alpha_j.b % Q
                determinant = (ai * bj - aj * bi) % Q
                x = (-left.s * bj + right.s * bi) * pow(determinant, -1, Q) % Q
                y = (-ai * right.s + aj * left.s) * pow(determinant, -1, Q) % Q
                direct_q = (x * x - NONSQUARE * y * y - d) % Q
                assert direct_q == node_q(left, right, d, NONSQUARE)
        for record in case["normalized_direction_zero_candidates"]:
            chosen = [Vertex(*pair) for pair in record["vertices"]]
            gradient = [direct_partition(chosen, {i}) for i in range(11)]
            assert gradient == record["gradient"], (
                case["name"], record["vertices"], gradient, record["gradient"]
            )
            zeros = [
                [i, j] for i in range(11) for j in range(i)
                if direct_partition(chosen, {i, j}) == 0
            ]
            assert zeros == record["hessian_zeros"]


def color_sort(candidates: int, adjacency: list[int]) -> tuple[list[int], list[int]]:
    order: list[int] = []
    bounds: list[int] = []
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


def maximum_clique(adjacency: list[int]) -> list[int]:
    best: list[int] = []

    def expand(chosen: list[int], candidates: int) -> None:
        nonlocal best
        order, bounds = color_sort(candidates, adjacency)
        for pos in range(len(order) - 1, -1, -1):
            if len(chosen) + bounds[pos] <= len(best):
                return
            vertex = order[pos]
            bit = 1 << vertex
            if not candidates & bit:
                continue
            chosen.append(vertex)
            if len(chosen) > len(best):
                best = chosen.copy()
            expand(chosen, candidates & adjacency[vertex])
            chosen.pop()
            candidates ^= bit

    expand([], (1 << len(adjacency)) - 1)
    return best


def concurrent(a: Vertex, b: Vertex, c: Vertex) -> bool:
    ua = TORUS[a.direction]
    ub = TORUS[b.direction]
    uc = TORUS[c.direction]
    determinant = (
        Fq2(a.s, 0) * (ub * uc.conj() - uc * ub.conj())
        - Fq2(b.s, 0) * (ua * uc.conj() - uc * ua.conj())
        + Fq2(c.s, 0) * (ua * ub.conj() - ub * ua.conj())
    )
    return determinant == Fq2(0, 0)


def concurrency_forbidden_masks(verts: list[Vertex]):
    """Return a cached mask of third vertices concurrent with each pair."""
    index = {(vertex.direction, vertex.s): i for i, vertex in enumerate(verts)}
    cache: dict[tuple[int, int], int] = {}

    def forbidden(i: int, j: int) -> int:
        key = (min(i, j), max(i, j))
        if key in cache:
            return cache[key]
        vi, vj = verts[i], verts[j]
        ui, uj = TORUS[vi.direction], TORUS[vj.direction]
        ai, bi = ui.a, NONSQUARE * ui.b % Q
        aj, bj = uj.a, NONSQUARE * uj.b % Q
        dij = (ai * bj - aj * bi) % Q
        assert dij != 0
        mask = 0
        for direction, uk in enumerate(TORUS):
            if direction in (vi.direction, vj.direction):
                continue
            ak, bk = uk.a, NONSQUARE * uk.b % Q
            value = -(
                vi.s * (aj * bk - ak * bj)
                - vj.s * (ai * bk - ak * bi)
            ) * pow(dij, -1, Q) % Q
            vertex = index.get((direction, value))
            if vertex is not None:
                mask |= 1 << vertex
        cache[key] = mask
        return mask

    return forbidden


def maximum_arc_clique(verts: list[Vertex], adjacency: list[int]) -> list[int]:
    """Maximum graph clique subject also to no concurrent triple."""
    best: list[int] = []
    forbidden = concurrency_forbidden_masks(verts)

    def expand(chosen: list[int], candidates: int) -> None:
        nonlocal best
        order, bounds = color_sort(candidates, adjacency)
        for pos in range(len(order) - 1, -1, -1):
            if len(chosen) + bounds[pos] <= len(best):
                return
            vertex = order[pos]
            bit = 1 << vertex
            if not candidates & bit:
                continue
            next_candidates = candidates & adjacency[vertex]
            for prior in chosen:
                next_candidates &= ~forbidden(prior, vertex)
            chosen.append(vertex)
            if len(chosen) > len(best):
                best = chosen.copy()
            expand(chosen, next_candidates)
            chosen.pop()
            candidates ^= bit

    expand([], (1 << len(adjacency)) - 1)
    return best


def find_arc_clique(
    verts: list[Vertex], adjacency: list[int], target_size: int,
    seed_direction: int | None = None,
) -> list[int] | None:
    """Find one target-size arc clique, without proving optimality."""
    full = (1 << len(adjacency)) - 1
    forbidden = concurrency_forbidden_masks(verts)

    def search(chosen: list[int], candidates: int) -> list[int] | None:
        if len(chosen) == target_size:
            return chosen.copy()
        if len(chosen) + candidates.bit_count() < target_size:
            return None
        order, bounds = color_sort(candidates, adjacency)
        for pos in range(len(order) - 1, -1, -1):
            if len(chosen) + bounds[pos] < target_size:
                return None
            vertex = order[pos]
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

    if seed_direction is None:
        return search([], full)
    for seed, vertex in enumerate(verts):
        if vertex.direction != seed_direction:
            continue
        answer = search([seed], full & adjacency[seed])
        if answer is not None:
            return answer
    return None


def random_arc_clique(
    verts: list[Vertex], adjacency: list[int], target_size: int, trials: int
) -> list[int] | None:
    generator = random.Random(756)
    seeds = [i for i, vertex in enumerate(verts) if vertex.direction == 0]
    full = (1 << len(adjacency)) - 1
    forbidden = concurrency_forbidden_masks(verts)
    for _ in range(trials):
        chosen = [generator.choice(seeds)]
        candidates = full & adjacency[chosen[0]]
        while candidates and len(chosen) < target_size:
            sample: list[int] = []
            scan = candidates
            while scan:
                bit = scan & -scan
                sample.append(bit.bit_length() - 1)
                scan ^= bit
            generator.shuffle(sample)
            sample = sample[: min(32, len(sample))]
            scored: list[tuple[int, int, int]] = []
            for vertex in sample:
                next_candidates = candidates & adjacency[vertex]
                for prior in chosen:
                    next_candidates &= ~forbidden(prior, vertex)
                scored.append((next_candidates.bit_count(), vertex, next_candidates))
            _, vertex, candidates = max(scored)
            chosen.append(vertex)
        if len(chosen) == target_size:
            return chosen
    return None


def scan_trace_zero(
    verts: list[Vertex], adjacency: list[int], trials: int
) -> tuple[int, int, int, int, list[Vertex] | None]:
    """Sample trace-zero arc cliques and score the critical/Hessian gates."""
    generator = random.Random(756756)
    seeds = [i for i, vertex in enumerate(verts) if vertex.direction == 0]
    full = (1 << len(adjacency)) - 1
    forbidden = concurrency_forbidden_masks(verts)
    completed = 0
    hessian_open = 0
    critical = 0
    best_zero_gradient = -1
    best: list[Vertex] | None = None
    for _ in range(trials):
        chosen = [generator.choice(seeds)]
        candidates = full & adjacency[chosen[0]]
        while candidates and len(chosen) < 11:
            sample: list[int] = []
            scan = candidates
            while scan:
                bit = scan & -scan
                sample.append(bit.bit_length() - 1)
                scan ^= bit
            generator.shuffle(sample)
            sample = sample[: min(16, len(sample))]
            scored: list[tuple[int, int, int]] = []
            for vertex in sample:
                next_candidates = candidates & adjacency[vertex]
                for prior in chosen:
                    next_candidates &= ~forbidden(prior, vertex)
                scored.append((next_candidates.bit_count(), vertex, next_candidates))
            _, vertex, candidates = max(scored)
            chosen.append(vertex)
        if len(chosen) != 11:
            continue
        completed += 1
        selected = [verts[i] for i in chosen]
        is_critical, is_open, gradient, _ = critical_and_hessian(selected)
        hessian_open += int(is_open)
        critical += int(is_critical and is_open)
        zero_gradient = sum(value == 0 for value in gradient)
        if zero_gradient > best_zero_gradient:
            best_zero_gradient = zero_gradient
            best = selected
    return completed, hessian_open, critical, best_zero_gradient, best


def find_open_arc_clique(
    verts: list[Vertex], adjacency: list[int], leaf_limit: int
) -> tuple[list[Vertex] | None, int, bool]:
    """Exact symmetry-reduced search for an 11-clique with open Hessian."""
    full = (1 << len(adjacency)) - 1
    forbidden = concurrency_forbidden_masks(verts)
    leaves = 0
    exhausted = True

    def search(chosen: list[int], candidates: int) -> list[Vertex] | None:
        nonlocal leaves, exhausted
        if len(chosen) == 11:
            leaves += 1
            selected = sorted(
                [verts[i] for i in chosen],
                key=lambda vertex: (vertex.direction, vertex.s),
            )
            _, is_open, _, _ = critical_and_hessian(selected)
            if is_open:
                return selected
            if leaves >= leaf_limit:
                exhausted = False
            return None
        if not exhausted:
            return None
        order, bounds = color_sort(candidates, adjacency)
        for pos in range(len(order) - 1, -1, -1):
            if len(chosen) + bounds[pos] < 11:
                return None
            vertex = order[pos]
            bit = 1 << vertex
            if not candidates & bit:
                continue
            next_candidates = candidates & adjacency[vertex]
            for prior in chosen:
                next_candidates &= ~forbidden(prior, vertex)
            chosen.append(vertex)
            answer = search(chosen, next_candidates)
            chosen.pop()
            if answer is not None or not exhausted:
                return answer
            candidates ^= bit
        return None

    for seed, vertex in enumerate(verts):
        if vertex.direction != 0:
            continue
        answer = search([seed], full & adjacency[seed])
        if answer is not None or not exhausted:
            return answer, leaves, exhausted
    return None, leaves, exhausted


def enumerate_arc_cliques(
    verts: list[Vertex], adjacency: list[int]
) -> tuple[list[dict[str, object]], int]:
    """Enumerate all size-11 candidates containing normalized direction 0."""
    full = (1 << len(adjacency)) - 1
    forbidden = concurrency_forbidden_masks(verts)
    records: list[dict[str, object]] = []
    search_nodes = 0

    def search(chosen: list[int], candidates: int) -> None:
        nonlocal search_nodes
        search_nodes += 1
        if len(chosen) == 11:
            selected = sorted(
                [verts[i] for i in chosen],
                key=lambda vertex: (vertex.direction, vertex.s),
            )
            is_critical, is_open, gradient, hessian_zeros = critical_and_hessian(
                selected
            )
            records.append(
                {
                    "vertices": sorted(
                        [[vertex.direction, vertex.s] for vertex in selected]
                    ),
                    "gradient": gradient,
                    "critical": is_critical,
                    "hessian_open": is_open,
                    "hessian_zeros": [list(pair) for pair in hessian_zeros],
                }
            )
            return
        order, bounds = color_sort(candidates, adjacency)
        for pos in range(len(order) - 1, -1, -1):
            if len(chosen) + bounds[pos] < 11:
                return
            vertex = order[pos]
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
        if vertex.direction == 0:
            search([seed], full & adjacency[seed])
    records.sort(key=lambda record: record["vertices"])
    return records, search_nodes


def canonical_dihedral_configuration(
    vertices: list[list[int]],
) -> tuple[tuple[int, int], ...]:
    index = {u: i for i, u in enumerate(TORUS)}
    configuration = [(int(i), int(s)) for i, s in vertices]
    images: list[tuple[tuple[int, int], ...]] = []
    for multiplier in TORUS:
        for invert in (False, True):
            image: list[tuple[int, int]] = []
            for direction, s in configuration:
                raw = (TORUS[direction].conj() if invert else TORUS[direction]) * multiplier
                normalized = canonical_sign(raw)
                sign = 1 if raw == normalized else -1
                image.append((index[normalized], sign * s % Q))
            images.append(tuple(sorted(image)))
    return min(images)


def exact_certificate() -> dict[str, object]:
    nu = NONSQUARE
    cases: list[dict[str, object]] = []
    for d, target, name in (
        (1, 1, "trace_zero_offset"),
        (NONSQUARE, -1, "split_offset"),
    ):
        verts, adjacency = graph(d, nu, target)
        records, search_nodes = enumerate_arc_cliques(verts, adjacency)
        orbit_counts: dict[tuple[tuple[int, int], ...], int] = {}
        for record in records:
            representative = canonical_dihedral_configuration(record["vertices"])
            orbit_counts[representative] = orbit_counts.get(representative, 0) + 1
        gradient_products = [
            __import__("functools").reduce(
                lambda left, right: left * int(right) % Q,
                record["gradient"],
                1,
            )
            for record in records
        ]
        cases.append(
            {
                "name": name,
                "d": d,
                "chi_d": chi(d),
                "node_character": target,
                "vertex_count": len(verts),
                "search_nodes": search_nodes,
                "normalized_direction_zero_candidates": records,
                "candidate_count": len(records),
                "critical_count": sum(bool(r["critical"]) for r in records),
                "open_hessian_count": sum(
                    bool(r["hessian_open"]) for r in records
                ),
                "dihedral_orbit_count": len(orbit_counts),
                "dihedral_orbits": [
                    {
                        "representative": [list(pair) for pair in representative],
                        "normalized_direction_zero_hits": count,
                    }
                    for representative, count in sorted(orbit_counts.items())
                ],
                "gradient_products": sorted(set(gradient_products)),
            }
        )
    return {
        "schema": "c756-aligned-critical-v1",
        "q": Q,
        "quadratic_extension_nonsquare": NONSQUARE,
        "alpha0": [ALPHA0.a, ALPHA0.b],
        "torus_direction_count": len(TORUS),
        "cases": cases,
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--exact", action="store_true")
    parser.add_argument("--output")
    parser.add_argument("--check")
    args = parser.parse_args()
    if args.exact or args.check:
        certificate = exact_certificate()
        rendered = json.dumps(certificate, indent=2, sort_keys=True) + "\n"
        direct_invariant_check(certificate)
        if args.check:
            with open(args.check, encoding="utf-8") as handle:
                assert handle.read() == rendered
            print("certificate and independent invariant checks: OK")
            return
        if args.output:
            with open(args.output, "w", encoding="utf-8") as handle:
                handle.write(rendered)
        else:
            print(rendered, end="")
        return
    assert len(TORUS) == 27
    nu = NONSQUARE
    print(f"q={Q} nonsquare={NONSQUARE} torus_directions={len(TORUS)}")
    for d in (1, NONSQUARE):
        for target in (-1, 1):
            verts, adjacency = graph(d, nu, target)
            arc_clique = random_arc_clique(verts, adjacency, 11, 2000)
            arc_status = "random_lower_bound"
            if arc_clique is None:
                arc_clique = []
                arc_status = "random_not_found"
            witness = [(verts[i].direction, verts[i].s) for i in arc_clique]
            critical = hessian = False
            gradient: list[int] = []
            if arc_clique:
                critical, hessian, gradient, hessian_zeros = critical_and_hessian(
                    [verts[i] for i in arc_clique]
                )
            else:
                hessian_zeros = []
            print(
                f"d={d} chi(d)={chi(d):+d} target={target:+d} "
                f"arc_{arc_status}={len(arc_clique)} "
                f"critical={critical} hessian_nonzero={hessian} "
                f"gradient={gradient} hessian_zeros={hessian_zeros} "
                f"arc_witness={witness}",
                flush=True,
            )
    verts, adjacency = graph(1, nu, 1)
    completed, open_count, critical_count, best_zero, best = scan_trace_zero(
        verts, adjacency, 10000
    )
    print(
        "trace_zero_scan "
        f"trials=10000 completed={completed} hessian_open={open_count} "
        f"critical_open={critical_count} best_zero_gradient={best_zero} "
        f"best={[(v.direction, v.s) for v in best] if best else []}",
        flush=True,
    )


if __name__ == "__main__":
    main()
