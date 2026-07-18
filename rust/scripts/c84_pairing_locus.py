#!/usr/bin/env python3
"""Enumerate PGL2-induced pairing certificates for S4-rooted C84 escapes.

This is deliberately independent of NetworkX.  A witness is an involution coming
from an off-conic centre whose permutation of the conic is a fixed-point-free,
nonadjacent automorphism of the fixed-point-deleted Schreier graph.
"""

from __future__ import annotations

import argparse
import itertools
import json
import math
import random
from collections import Counter, deque
from pathlib import Path

from three_centre_probe import (
    centres,
    compose,
    conic_point,
    dead_vertices,
    determinant,
    projective_line,
    residual_graph,
    sigma,
)


PATTERNS = {(3, 3, 3): "A", (3, 4, 4): "B", (2, 3, 3): "C", (2, 3, 4): "D"}
S4_PROFILE = Counter({1: 1, 2: 9, 3: 8, 4: 6})


def perm_order(perm: tuple[int, ...]) -> int:
    seen: set[int] = set()
    order = 1
    for start in range(len(perm)):
        if start in seen:
            continue
        length = 0
        point = start
        while point not in seen:
            seen.add(point)
            point = perm[point]
            length += 1
        order = math.lcm(order, length)
    return order


def pair_orders(gens: tuple[tuple[int, ...], ...]) -> tuple[int, ...]:
    return tuple(sorted(perm_order(compose(a, b)) for a, b in itertools.combinations(gens, 2)))


def generated_group_cap(
    generators: tuple[tuple[int, ...], ...], cap: int
) -> tuple[tuple[int, ...], ...] | None:
    identity = tuple(range(len(generators[0])))
    seen = {identity}
    todo = deque([identity])
    while todo:
        element = todo.popleft()
        for generator in generators:
            product = compose(generator, element)
            if product in seen:
                continue
            seen.add(product)
            if len(seen) > cap:
                return None
            todo.append(product)
    return tuple(seen)


def s4_representatives(
    q: int,
    points: tuple[tuple[int, int, int], ...],
    perms: dict[tuple[int, int, int], tuple[int, ...]],
) -> tuple[dict[str, tuple[tuple[int, int, int], ...]], set[tuple[int, int, int]]]:
    group = None
    rng = random.Random(20260717 + q)
    sampled = (tuple(rng.sample(points, 3)) for _ in range(100_000))
    for triple in itertools.chain(sampled, itertools.combinations(points, 3)):
        gens = tuple(perms[point] for point in triple)
        if pair_orders(gens) not in PATTERNS:
            continue
        candidate = generated_group_cap(gens, 24)
        if candidate is not None and Counter(map(perm_order, candidate)) == S4_PROFILE:
            group = candidate
            break
    if group is None:
        raise AssertionError(f"no S4 found at q={q}")

    identity = tuple(range(q + 1))
    perm_to_point = {perm: point for point, perm in perms.items()}
    involutions = tuple(
        element
        for element in group
        if element != identity and compose(element, element) == identity
    )
    subgroup_points = {perm_to_point[element] for element in involutions}
    reps: dict[str, tuple[tuple[int, int, int], ...]] = {}
    for triple in itertools.combinations(involutions, 3):
        candidate = generated_group_cap(triple, 24)
        if candidate is not None and len(candidate) == 24:
            reps.setdefault(PATTERNS[pair_orders(triple)], tuple(perm_to_point[x] for x in triple))
    if set(reps) != set("ABCD"):
        raise AssertionError((q, reps.keys()))
    return reps, subgroup_points


def pairing_witnesses(
    selected: tuple[tuple[int, int, int], ...],
    tau_points: tuple[tuple[int, int, int], ...],
    perms: dict[tuple[int, int, int], tuple[int, ...]],
    parameters: tuple[int | None, ...],
    conic: tuple[tuple[int, int, int], ...],
    q: int,
) -> tuple[tuple[int, int, int], ...]:
    dead, adjacency, _ = residual_graph(selected, parameters, conic, q)
    live = tuple(i for i in range(q + 1) if i not in dead)
    live_index = {old: new for new, old in enumerate(live)}
    witnesses = []
    for tau_point in tau_points:
        tau = perms[tau_point]
        image = tuple(tau[old] for old in live)
        if any(old not in live_index for old in image):
            continue
        induced = tuple(live_index[old] for old in image)
        if any(induced[i] == i or induced[induced[i]] != i for i in range(len(live))):
            continue
        if any((adjacency[i] >> induced[i]) & 1 for i in range(len(live))):
            continue
        if any(
            {induced[j] for j in range(len(live)) if (adjacency[i] >> j) & 1}
            != {j for j in range(len(live)) if (adjacency[induced[i]] >> j) & 1}
            for i in range(len(live))
        ):
            continue
        witnesses.append(tau_point)
    return tuple(witnesses)


def encode_point(point: tuple[int, int, int]) -> list[int]:
    return list(point)


def stable_vertex_colours(adjacency: tuple[int, ...]) -> tuple[int, ...]:
    colours = tuple(mask.bit_count() for mask in adjacency)
    while True:
        signatures = []
        for vertex, mask in enumerate(adjacency):
            neighbour_colours = sorted(
                colours[other] for other in range(len(adjacency)) if (mask >> other) & 1
            )
            signatures.append((colours[vertex], tuple(neighbour_colours)))
        palette = {signature: i for i, signature in enumerate(sorted(set(signatures)))}
        refined = tuple(palette[signature] for signature in signatures)
        if refined == colours:
            return colours
        colours = refined


def has_abstract_pairing(adjacency: tuple[int, ...]) -> bool:
    """Exact backtracking test for a nonadjacent fpf involutory automorphism."""
    n = len(adjacency)
    if n % 2:
        return False
    colours = stable_vertex_colours(adjacency)
    tau = [-1] * n

    def compatible(v: int, w: int) -> bool:
        if v == w or colours[v] != colours[w] or (adjacency[v] >> w) & 1:
            return False
        for a, b in enumerate(tau):
            if b < 0:
                continue
            if ((adjacency[v] >> a) & 1) != ((adjacency[w] >> b) & 1):
                return False
            if ((adjacency[w] >> a) & 1) != ((adjacency[v] >> b) & 1):
                return False
        return True

    def search() -> bool:
        unpaired = [v for v in range(n) if tau[v] < 0]
        if not unpaired:
            return True
        choices = []
        for v in unpaired:
            partners = [w for w in unpaired if compatible(v, w)]
            choices.append((len(partners), v, partners))
        _, v, partners = min(choices)
        for w in partners:
            tau[v] = w
            tau[w] = v
            if search():
                return True
            tau[v] = -1
            tau[w] = -1
        return False

    return search()


def probe(
    q: int,
    summary: bool = False,
    counts_only: bool = False,
    abstract_class: str | None = None,
) -> dict[str, object]:
    parameters = projective_line(q)
    conic = tuple(conic_point(t, q) for t in parameters)
    points = centres(q)
    parameter_index = {parameter: i for i, parameter in enumerate(parameters)}
    perms = {
        point: tuple(parameter_index[sigma(point, t, q)] for t in parameters)
        for point in points
    }
    # Split involutions are allowed when both fixed conic points lie in the
    # deleted set; fixed-point-freeness is checked on each actual residual.
    tau_points = points
    reps, subgroup_points = s4_representatives(q, points, perms)
    classes = {}
    for label in "ABCD":
        selected = reps[label]
        witnesses = []
        tau_histogram: Counter[tuple[int, int, int]] = Counter()
        escaping = 0
        large = 0
        s4_tau_children = 0
        abstract_pairing_children = 0
        for candidate in points:
            if candidate in selected:
                continue
            if any(
                determinant((a, b, candidate), q) == 0
                for a, b in itertools.combinations(selected, 2)
            ):
                continue
            if candidate in subgroup_points:
                continue
            escaping += 1
            child = (*selected, candidate)
            child_witnesses = pairing_witnesses(child, tau_points, perms, parameters, conic, q)
            if abstract_class in (label, "ALL"):
                _, adjacency, _ = residual_graph(child, parameters, conic, q)
                if has_abstract_pairing(adjacency):
                    abstract_pairing_children += 1
            if not child_witnesses:
                continue
            tau_histogram.update(child_witnesses)
            if any(tau in subgroup_points for tau in child_witnesses):
                s4_tau_children += 1
            child_group = generated_group_cap(tuple(perms[x] for x in child), 60)
            if child_group is None:
                large += 1
                group_order = ">60"
            else:
                group_order = str(len(child_group))
            witnesses.append(
                {
                    "candidate": encode_point(candidate),
                    "generated_group_order": group_order,
                    "tau_centres": [encode_point(x) for x in child_witnesses],
                }
            )
        row: dict[str, object] = {
            "escaping_children": escaping,
            "large_group_witnesses": large,
            "pairing_witness_count": len(witnesses),
            "s4_tau_pairing_children": s4_tau_children,
            "s4_tau_witness_pair_count": sum(
                count for tau, count in tau_histogram.items() if tau in subgroup_points
            ),
            "witness_pair_count": sum(tau_histogram.values()),
        }
        if abstract_class in (label, "ALL"):
            row["abstract_pairing_children"] = abstract_pairing_children
        if not counts_only:
            row["selected"] = [encode_point(x) for x in selected]
            row["tau_histogram"] = [
                    {
                        "children": count,
                        "in_s4": tau in subgroup_points,
                        "tau_centre": encode_point(tau),
                    }
                    for tau, count in sorted(tau_histogram.items())
                ]
        if not summary:
            row["pairing_witnesses"] = witnesses
        classes[label] = row
    return {"classes": classes, "q": q}


def report_summary(cases: list[dict[str, object]]) -> dict[str, object]:
    rows = []
    for case in cases:
        classes = case["classes"]
        assert all(
            classes[label]["large_group_witnesses"]
            == classes[label]["pairing_witness_count"]
            for label in "ABCD"
        )
        rows.append({
            "abstract_pairing_children_ABCD": [
                classes[label]["abstract_pairing_children"] for label in "ABCD"
            ],
            "escaping_children_ABCD": [
                classes[label]["escaping_children"] for label in "ABCD"
            ],
            "pgl2_pairing_children_ABCD": [
                classes[label]["pairing_witness_count"] for label in "ABCD"
            ],
            "q": case["q"],
        })
    return {
        "cases": rows,
        "class_order": "ABCD",
        "schema": "c84-pairing-obstruction-v1",
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("q", nargs="+", type=int)
    parser.add_argument("--summary", action="store_true")
    parser.add_argument("--counts-only", action="store_true")
    parser.add_argument("--abstract-class", choices=(*tuple("ABCD"), "ALL"))
    parser.add_argument("--report-summary", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    cases = [probe(q, args.summary, args.counts_only, args.abstract_class) for q in args.q]
    result: dict[str, object] = {"cases": cases}
    if args.report_summary:
        if args.abstract_class != "ALL":
            parser.error("--report-summary requires --abstract-class ALL")
        result = report_summary(cases)
    if args.check:
        tracked_path = Path(__file__).resolve().parents[2] / "notes" / (
            "2026-07-17-c84-pairing-obstruction.json"
        )
        if json.loads(tracked_path.read_text()) != result:
            raise SystemExit("tracked report summary differs from regeneration")
        print(f"OK: {len(cases)} fields; tracked pairing-obstruction JSON matches")
    else:
        print(json.dumps(result, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
