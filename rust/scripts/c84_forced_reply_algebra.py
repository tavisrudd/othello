#!/usr/bin/env python3
"""Extract and classify unique winning replies in C84 class-D residuals."""

from __future__ import annotations

import argparse
import gc
import itertools
import json
from collections import Counter, deque
from functools import cache
from pathlib import Path

from c84_adaptive_core import solve as reference_solve
from c84_pairing_locus import s4_representatives
from three_centre_probe import (
    INF,
    centres,
    conic_point,
    determinant,
    projective_line,
    residual_graph,
    sigma,
)


def parameter_json(parameter: int | object) -> int | str:
    return "inf" if parameter is INF else parameter


def optional_distance_histogram(values: list[int | None]) -> dict[str, int]:
    counts = Counter("disconnected" if value is None else str(value) for value in values)
    return dict(sorted(counts.items()))


def graph_distance(adjacency: tuple[int, ...], source: int, target: int) -> int | None:
    frontier = 1 << source
    seen = frontier
    distance = 0
    while frontier:
        if frontier & (1 << target):
            return distance
        neighbours = 0
        bits = frontier
        while bits:
            bit = bits & -bits
            neighbours |= adjacency[bit.bit_length() - 1]
            bits ^= bit
        frontier = neighbours & ~seen
        seen |= frontier
        distance += 1
    return None


def word_relation(
    permutations: tuple[tuple[int, ...], ...], source: int, target: int
) -> tuple[int, list[int], int]:
    """Return distance, lexicographically first word, and number of shortest words."""
    distance = {source: 0}
    count = {source: 1}
    first_word: dict[int, tuple[int, ...]] = {source: ()}
    queue = deque([source])
    while queue:
        vertex = queue.popleft()
        next_distance = distance[vertex] + 1
        if target in distance and next_distance > distance[target]:
            break
        for colour, permutation in enumerate(permutations):
            follower = permutation[vertex]
            word = first_word[vertex] + (colour,)
            if follower not in distance:
                distance[follower] = next_distance
                count[follower] = count[vertex]
                first_word[follower] = word
                queue.append(follower)
            elif distance[follower] == next_distance:
                count[follower] += count[vertex]
                first_word[follower] = min(first_word[follower], word)
    if target not in distance:
        raise AssertionError((source, target, "different generator orbits"))
    return distance[target], list(first_word[target]), count[target]


def solve_forcing_pairs(
    adjacency: tuple[int, ...],
    live_parameters: tuple[int, ...],
    full_parameter_index: dict[int | object, int],
    permutations: tuple[tuple[int, ...], ...],
) -> dict[str, object]:
    n = len(adjacency)
    closed = tuple(mask | (1 << vertex) for vertex, mask in enumerate(adjacency))

    def components(mask: int) -> list[int]:
        out = []
        unseen = mask
        while unseen:
            frontier = unseen & -unseen
            component = 0
            while frontier:
                component |= frontier
                unseen &= ~frontier
                neighbours = 0
                bits = frontier
                while bits:
                    bit = bits & -bits
                    neighbours |= adjacency[bit.bit_length() - 1]
                    bits ^= bit
                frontier = neighbours & unseen
            out.append(component)
        return out

    @cache
    def grundy(mask: int) -> int:
        pieces = components(mask)
        if not pieces:
            return 0
        if len(pieces) > 1:
            value = 0
            for piece in pieces:
                value ^= grundy(piece)
            return value
        options = set()
        bits = mask
        while bits:
            bit = bits & -bits
            vertex = bit.bit_length() - 1
            options.add(grundy(mask & ~closed[vertex]))
            bits ^= bit
        value = 0
        while value in options:
            value += 1
        return value

    full = (1 << n) - 1
    value = grundy(full)
    pairs = []
    control_word_distances: Counter[int] = Counter()
    control_words: Counter[tuple[int, ...]] = Counter()
    winning_word_distances: Counter[int] = Counter()
    winning_words: Counter[tuple[int, ...]] = Counter()
    if value == 0:
        for first in range(n):
            follower = full & ~closed[first]
            replies = []
            response_features = {}
            bits = follower
            while bits:
                bit = bits & -bits
                reply = bit.bit_length() - 1
                source = full_parameter_index[live_parameters[first]]
                target = full_parameter_index[live_parameters[reply]]
                relation = word_relation(permutations, source, target)
                response_features[reply] = relation
                control_word_distances[relation[0]] += 1
                control_words[tuple(relation[1])] += 1
                if grundy(follower & ~closed[reply]) == 0:
                    replies.append(reply)
                    winning_word_distances[relation[0]] += 1
                    winning_words[tuple(relation[1])] += 1
                bits ^= bit
            if len(replies) != 1:
                continue
            reply = replies[0]
            source = full_parameter_index[live_parameters[first]]
            target = full_parameter_index[live_parameters[reply]]
            word_distance, word, word_count = response_features[reply]
            common = (adjacency[first] & adjacency[reply]).bit_count()
            pairs.append({
                "common_neighbours": common,
                "degree_first": adjacency[first].bit_count(),
                "degree_reply": adjacency[reply].bit_count(),
                "first": parameter_json(live_parameters[first]),
                "graph_distance": graph_distance(adjacency, first, reply),
                "reply": parameter_json(live_parameters[reply]),
                "shortest_word": word,
                "shortest_word_count": word_count,
                "word_distance": word_distance,
            })
    return {
        "control_word_distances": dict(sorted(control_word_distances.items())),
        "control_words": dict(sorted(control_words.items())),
        "forcing_pairs": pairs,
        "grundy": value,
        "memo_states": grundy.cache_info().currsize,
        "winning_word_distances": dict(sorted(winning_word_distances.items())),
        "winning_words": dict(sorted(winning_words.items())),
    }


def probe(q: int, label: str) -> dict[str, object]:
    parameters = projective_line(q)
    parameter_index = {parameter: i for i, parameter in enumerate(parameters)}
    conic = tuple(conic_point(t, q) for t in parameters)
    points = centres(q)
    all_permutations = {
        point: tuple(parameter_index[sigma(point, t, q)] for t in parameters)
        for point in points
    }
    representatives, subgroup_points = s4_representatives(
        q, points, all_permutations
    )
    selected = representatives[label]
    rows = []
    control_word_distances: Counter[int] = Counter()
    control_words: Counter[tuple[int, ...]] = Counter()
    winning_word_distances: Counter[int] = Counter()
    winning_words: Counter[tuple[int, ...]] = Counter()
    for candidate in points:
        if candidate in selected or candidate in subgroup_points:
            continue
        if any(
            determinant((a, b, candidate), q) == 0
            for a, b in itertools.combinations(selected, 2)
        ):
            continue
        centres4 = (*selected, candidate)
        dead, adjacency, _ = residual_graph(centres4, parameters, conic, q)
        live = tuple(
            parameter for i, parameter in enumerate(parameters) if i not in dead
        )
        row = solve_forcing_pairs(
            adjacency,
            live,
            parameter_index,
            tuple(all_permutations[point] for point in centres4),
        )
        reference = reference_solve(adjacency)
        assert row["grundy"] == reference["grundy"]
        control_word_distances.update(row.pop("control_word_distances"))
        control_words.update(row.pop("control_words"))
        winning_word_distances.update(row.pop("winning_word_distances"))
        winning_words.update(row.pop("winning_words"))
        if row["forcing_pairs"]:
            row["candidate"] = list(candidate)
            rows.append(row)
        gc.collect()

    pairs = [pair for row in rows for pair in row["forcing_pairs"]]
    word_histogram = Counter(tuple(pair["shortest_word"]) for pair in pairs)
    all_words = sorted(set(control_words) | set(winning_words) | set(word_histogram))
    return {
        "class": label,
        "forcing_pairs": len(pairs),
        "q": q,
        "roots_with_forcing_pairs": len(rows),
        "rows": rows,
        "selected": [list(point) for point in selected],
        "summary": {
            "common_neighbour_histogram": dict(sorted(Counter(
                pair["common_neighbours"] for pair in pairs
            ).items())),
            "graph_distance_histogram": optional_distance_histogram([
                pair["graph_distance"] for pair in pairs
            ]),
            "shortest_word_histogram": {
                "".join(map(str, word)): count
                for word, count in sorted(word_histogram.items())
            },
            "all_legal_response_word_distance_histogram": dict(sorted(
                control_word_distances.items()
            )),
            "winning_response_word_distance_histogram": dict(sorted(
                winning_word_distances.items()
            )),
            "word_outcome_histogram": {
                "".join(map(str, word)): {
                    "all_legal": control_words[word],
                    "forcing": word_histogram[word],
                    "winning": winning_words[word],
                }
                for word in all_words
            },
            "word_distance_histogram": dict(sorted(Counter(
                pair["word_distance"] for pair in pairs
            ).items())),
        },
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("q", nargs="+", type=int)
    parser.add_argument("--class", dest="label", choices=tuple("ABCD"), default="D")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    result = {
        "cases": [probe(q, args.label) for q in args.q],
        "schema": "c84-forced-reply-algebra-v1",
    }
    if args.check:
        tracked = Path(__file__).resolve().parents[2] / "notes" / (
            "2026-07-17-c84-forced-reply-algebra.json"
        )
        normalized = json.loads(json.dumps(result, sort_keys=True))
        if json.loads(tracked.read_text()) != normalized:
            raise SystemExit("tracked forced-reply JSON differs from regeneration")
        print(f"OK: {len(result['cases'])} fields; forced-reply JSON matches")
    else:
        print(json.dumps(result, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
