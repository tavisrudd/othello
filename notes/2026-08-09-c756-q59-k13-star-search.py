#!/usr/bin/env python3
"""Exact restartable q=59/61, k=13 star search for C756.

Each invocation exhausts one normalized distinguished-line offset.  Keeping
the shards separate makes the long search restartable and bounds the
pair-concurrency cache.  The mixed model is the external-deletion branch;
the anisotropic all-passant model is the all-internal branch.
"""

from __future__ import annotations

import argparse
from collections import Counter
from dataclasses import dataclass
from functools import lru_cache
import hashlib
import importlib.util
import json
from pathlib import Path
import sys
import types


HERE = Path(__file__).resolve().parent
MIXED_BASE_PATH = HERE / "2026-08-09-c756-aligned-split-mixed-search.py"
MIXED_BASE_SHA256 = "f1c11decc6df8c5e9bc0a57a5e98dfd35c9fdd2c4ce8fabaa3db5b115ab9249f"
PASSANT_BASE_PATH = HERE / "2026-08-09-c756-aligned-node-clique.py"
PASSANT_BASE_SHA256 = "bf3c2fe00f9b09e2889532da697f9ef09d9ecffdfac2785d232541f164b79bbb"
def requested_q() -> int:
    if "--q" not in sys.argv:
        return 59
    position = sys.argv.index("--q")
    if position + 1 == len(sys.argv):
        raise SystemExit("--q requires a value")
    return int(sys.argv[position + 1])


Q = requested_q()
if Q not in (59, 61):
    raise SystemExit("this search supports exactly q=59 and q=61")
NONSQUARE = next(
    value
    for value in range(2, Q)
    if pow(value, (Q - 1) // 2, Q) == Q - 1
)
TARGET_SIZE = 12
INTERNAL_NODE_CHARACTER = -1 if Q % 4 == 3 else 1
FORCED_MIN_DEGREE = 8 if Q == 59 else 6
MIXED_FORCED_MAX_DEGREE = 16 if Q == 59 else 17
PASSANT_FORCED_MAX_DEGREE = 17 if Q == 59 else 18
CACHE_SIZE = 200_000


def load_rewritten(path: Path, expected_hash: str, name: str):
    actual_hash = hashlib.sha256(path.read_bytes()).hexdigest()
    if actual_hash != expected_hash:
        raise SystemExit(f"base script hash mismatch for {path.name}: {actual_hash}")
    source = path.read_text()
    marker = "\nQ = 53\n"
    if source.count(marker) != 1:
        raise SystemExit(f"q marker mismatch in {path.name}")
    source = source.replace(marker, f"\nQ = {Q}\n")
    nonsquare_marker = "\nNONSQUARE = 2\n"
    if path == MIXED_BASE_PATH:
        if source.count(nonsquare_marker) != 1:
            raise SystemExit(f"nonsquare marker mismatch in {path.name}")
        source = source.replace(nonsquare_marker, f"\nNONSQUARE = {NONSQUARE}\n")
    module = types.ModuleType(name)
    module.__file__ = str(path)
    sys.modules[name] = module
    exec(compile(source, str(path), "exec"), module.__dict__)
    if module.Q != Q:
        raise AssertionError(module.Q)
    return module


MIXED = load_rewritten(
    MIXED_BASE_PATH, MIXED_BASE_SHA256, "c756_q59_mixed_geometry"
)
PASSANT = load_rewritten(
    PASSANT_BASE_PATH, PASSANT_BASE_SHA256, "c756_q59_passant_geometry"
)

if MIXED.chi(NONSQUARE) != -1 or MIXED.chi(-1) != INTERNAL_NODE_CHARACTER:
    raise AssertionError(f"q={Q} character convention mismatch")


@dataclass(frozen=True)
class Model:
    name: str
    vertices: list[object]
    adjacency: list[int]
    coefficients: object
    forced_max_degree: int


def mixed_model() -> Model:
    vertices = MIXED.vertices(NONSQUARE)
    adjacency = [0] * len(vertices)
    for i, left in enumerate(vertices):
        for j, right in enumerate(vertices[:i]):
            if left.direction == right.direction:
                continue
            if MIXED.chi(MIXED.node_q(left, right, NONSQUARE)) == INTERNAL_NODE_CHARACTER:
                adjacency[i] |= 1 << j
                adjacency[j] |= 1 << i
    return Model(
        "mixed-external-deletion",
        vertices,
        adjacency,
        MIXED.coefficients,
        MIXED_FORCED_MAX_DEGREE,
    )


def passant_coefficients(vertex):
    normal = PASSANT.ALPHA0 * PASSANT.TORUS[vertex.direction]
    return 2 * normal.a % Q, 2 * PASSANT.NONSQUARE * normal.b % Q


def passant_model() -> Model:
    vertices, adjacency = PASSANT.graph(
        1, PASSANT.NONSQUARE, INTERNAL_NODE_CHARACTER
    )
    return Model(
        "all-passant-internal-deletion",
        vertices,
        adjacency,
        passant_coefficients,
        PASSANT_FORCED_MAX_DEGREE,
    )


def concurrency_forbidden_masks(model: Model):
    index = {
        (vertex.direction, vertex.s): i
        for i, vertex in enumerate(model.vertices)
    }
    direction_count = max(vertex.direction for vertex in model.vertices) + 1

    @lru_cache(maxsize=CACHE_SIZE)
    def forbidden(i: int, j: int) -> int:
        if i > j:
            i, j = j, i
        left, right = model.vertices[i], model.vertices[j]
        ai, bi = model.coefficients(left)
        aj, bj = model.coefficients(right)
        determinant = (ai * bj - aj * bi) % Q
        if determinant == 0:
            raise AssertionError((left, right))
        inverse = pow(determinant, -1, Q)
        mask = 0
        for direction in range(direction_count):
            if direction in (left.direction, right.direction):
                continue
            prototype = type(left)(direction, 0)
            ak, bk = model.coefficients(prototype)
            offset = -(
                left.s * (aj * bk - ak * bj)
                - right.s * (ai * bk - ak * bi)
            ) * inverse % Q
            vertex_index = index.get((direction, offset))
            if vertex_index is not None:
                mask |= 1 << vertex_index
        return mask

    return forbidden


def affine_nodes(model: Model, selected: list[object]):
    nodes = []
    for i, left in enumerate(selected):
        ai, bi = model.coefficients(left)
        for right in selected[:i]:
            aj, bj = model.coefficients(right)
            determinant = (ai * bj - aj * bi) % Q
            inverse = pow(determinant, -1, Q)
            nodes.append(
                (
                    (bi * right.s - bj * left.s) * inverse % Q,
                    (aj * left.s - ai * right.s) * inverse % Q,
                )
            )
    expected_nodes = len(selected) * (len(selected) - 1) // 2
    if len(nodes) != expected_nodes or len(set(nodes)) != expected_nodes:
        raise AssertionError(
            f"the selected lines do not have {expected_nodes} distinct nodes"
        )
    inverse_count = pow(len(nodes), -1, Q)
    center_x = sum(point[0] for point in nodes) * inverse_count % Q
    center_y = sum(point[1] for point in nodes) * inverse_count % Q
    centered = [
        ((x - center_x) % Q, (y - center_y) % Q)
        for x, y in nodes
    ]
    if any(sum(point[axis] for point in centered) % Q for axis in range(2)):
        raise AssertionError("centering failed")
    return centered


def elementary_forms(nodes, maximum_degree: int):
    forms = [[1]] + [[0] * (degree + 1) for degree in range(1, maximum_degree + 1)]
    factors = 0
    for x, y in nodes:
        factors += 1
        for degree in range(min(factors, maximum_degree), 0, -1):
            previous = forms[degree - 1]
            current = forms[degree]
            for x_degree, coefficient in enumerate(previous):
                current[x_degree] = (current[x_degree] + y * coefficient) % Q
                current[x_degree + 1] = (
                    current[x_degree + 1] + x * coefficient
                ) % Q
    return forms


def projection_spans(model: Model, nodes, selected):
    used = {vertex.direction for vertex in selected}
    direction_count = max(vertex.direction for vertex in model.vertices) + 1
    spans = []
    for direction in range(direction_count):
        if direction in used:
            continue
        a, b = model.coefficients(type(selected[0])(direction, 0))
        spans.append(len({(a * x + b * y) % Q for x, y in nodes}))
    return spans


def analyze_leaf(model: Model, selected):
    nodes = affine_nodes(model, selected)
    forms = elementary_forms(nodes, model.forced_max_degree)
    first_nonzero = next(
        (
            degree
            for degree in range(FORCED_MIN_DEGREE, model.forced_max_degree + 1)
            if any(forms[degree])
        ),
        None,
    )
    spans = projection_spans(model, nodes, selected)
    result = {
        "first_nonzero_forced_degree": first_nonzero,
        "forced_window": first_nonzero is None,
        "complete_centers": sum(span == Q for span in spans),
        "required_centers": len(spans),
        "minimum_span": min(spans),
        "maximum_span": max(spans),
    }
    if model.name == "mixed-external-deletion":
        result["secants"] = sum(
            MIXED.line_character(vertex, NONSQUARE) == 1 for vertex in selected
        )
        result["passants"] = TARGET_SIZE - result["secants"]
    return result


def enumerate_seed(model: Model, seed_s: int, *, extend_one: bool = False):
    matching_seeds = [
        i
        for i, vertex in enumerate(model.vertices)
        if vertex.direction == 0 and vertex.s == seed_s
    ]
    if len(matching_seeds) > 1:
        raise AssertionError(matching_seeds)
    if not matching_seeds:
        return {
            "seed_s": seed_s,
            "seed_present": False,
            "search_nodes": 0,
            "geometric_stars": 0,
        }

    forbidden = concurrency_forbidden_masks(model)
    full = (1 << len(model.vertices)) - 1
    search_nodes = 0
    leaves = 0
    forced_window = 0
    any_complete_center = 0
    all_complete_centers = 0
    first_nonzero_counts = Counter()
    type_profiles = Counter()
    best_score = None
    best_witness = None
    extensions = {}

    def search(chosen, candidates):
        nonlocal search_nodes, leaves, forced_window
        nonlocal any_complete_center, all_complete_centers
        nonlocal best_score, best_witness
        search_nodes += 1
        if len(chosen) == TARGET_SIZE:
            leaves += 1
            selected = sorted(model.vertices[index] for index in chosen)
            analysis = analyze_leaf(model, selected)
            first_nonzero_counts[analysis["first_nonzero_forced_degree"]] += 1
            forced_window += int(analysis["forced_window"])
            any_complete_center += int(analysis["complete_centers"] > 0)
            all_complete_centers += int(
                analysis["complete_centers"] == analysis["required_centers"]
            )
            if model.name == "mixed-external-deletion":
                type_profiles[(analysis["secants"], analysis["passants"])] += 1
            prefix = (
                model.forced_max_degree + 1
                if analysis["first_nonzero_forced_degree"] is None
                else analysis["first_nonzero_forced_degree"]
            )
            score = (prefix, analysis["complete_centers"], analysis["maximum_span"])
            if best_score is None or score > best_score:
                best_score = score
                best_witness = [[vertex.direction, vertex.s] for vertex in selected]
            if extend_one:
                extension_candidates = full
                for prior in chosen:
                    extension_candidates &= model.adjacency[prior]
                for i, left in enumerate(chosen):
                    for right in chosen[:i]:
                        extension_candidates &= ~forbidden(left, right)
                while extension_candidates:
                    bit = extension_candidates & -extension_candidates
                    extension_vertex = bit.bit_length() - 1
                    extended = sorted(
                        selected + [model.vertices[extension_vertex]]
                    )
                    extended_nodes = affine_nodes(model, extended)
                    spans = projection_spans(model, extended_nodes, extended)
                    key = tuple(
                        (vertex.direction, vertex.s) for vertex in extended
                    )
                    extensions[key] = {
                        "vertices": [list(pair) for pair in key],
                        "complete_centers": sum(span == Q for span in spans),
                        "required_centers": len(spans),
                        "minimum_span": min(spans),
                        "maximum_span": max(spans),
                        "secants": sum(
                            MIXED.line_character(vertex, NONSQUARE) == 1
                            for vertex in extended
                        ),
                        "passants": sum(
                            MIXED.line_character(vertex, NONSQUARE) == -1
                            for vertex in extended
                        ),
                    }
                    extension_candidates ^= bit
            return
        order, bounds = MIXED.color_sort(candidates, model.adjacency)
        for position in range(len(order) - 1, -1, -1):
            if len(chosen) + bounds[position] < TARGET_SIZE:
                return
            vertex = order[position]
            bit = 1 << vertex
            if not candidates & bit:
                continue
            next_candidates = candidates & model.adjacency[vertex]
            for prior in chosen:
                next_candidates &= ~forbidden(prior, vertex)
            chosen.append(vertex)
            search(chosen, next_candidates)
            chosen.pop()
            candidates ^= bit

    seed = matching_seeds[0]
    search([seed], full & model.adjacency[seed])
    cache_info = forbidden.cache_info()
    result = {
        "seed_s": seed_s,
        "seed_present": True,
        "search_nodes": search_nodes,
        "geometric_stars": leaves,
        "forced_window_stars": forced_window,
        "stars_with_any_complete_center": any_complete_center,
        "stars_with_all_complete_centers": all_complete_centers,
        "first_nonzero_forced_degree": [
            {"degree": degree, "count": count}
            for degree, count in sorted(
                first_nonzero_counts.items(),
                key=lambda item: model.forced_max_degree + 1 if item[0] is None else item[0],
            )
        ],
        "type_profiles": [
            {"secants": key[0], "passants": key[1], "count": count}
            for key, count in sorted(type_profiles.items())
        ],
        "best_witness": best_witness,
        "cache": {
            "hits": cache_info.hits,
            "misses": cache_info.misses,
            "maxsize": cache_info.maxsize,
            "currsize": cache_info.currsize,
        },
    }
    if extend_one:
        result["one_line_extensions"] = [
            extensions[key] for key in sorted(extensions)
        ]
        result["one_line_extension_count"] = len(extensions)
    return result


def exact_output(mode: str, seed_s: int, *, extend_one: bool = False):
    model = mixed_model() if mode == "mixed" else passant_model()
    return {
        "schema": f"c756-q{Q}-k13-star-shard-v1",
        "q": Q,
        "k": 13,
        "mode": model.name,
        "target_size": TARGET_SIZE,
        "internal_node_character": INTERNAL_NODE_CHARACTER,
        "forced_degrees": [FORCED_MIN_DEGREE, model.forced_max_degree],
        "direction_count": max(vertex.direction for vertex in model.vertices) + 1,
        "vertex_count": len(model.vertices),
        "shard": enumerate_seed(model, seed_s, extend_one=extend_one),
        "pinned_files": {
            MIXED_BASE_PATH.name: MIXED_BASE_SHA256,
            PASSANT_BASE_PATH.name: PASSANT_BASE_SHA256,
        },
    }


def aggregate_output(mode: str, shard_directory: Path):
    model_name = (
        "mixed-external-deletion"
        if mode == "mixed"
        else "all-passant-internal-deletion"
    )
    prefix = "mixed" if mode == "mixed" else "passant"
    rows = []
    for seed_s in range((Q + 1) // 2):
        path = shard_directory / f"c756-q{Q}-{prefix}-seed-{seed_s}.json"
        payload = json.loads(path.read_text())
        if (
            payload.get("schema") != f"c756-q{Q}-k13-star-shard-v1"
            or payload.get("mode") != model_name
            or payload.get("shard", {}).get("seed_s") != seed_s
        ):
            raise SystemExit(f"invalid shard: {path}")
        rows.append(payload["shard"])

    degree_counts = Counter()
    profile_counts = Counter()
    for row in rows:
        for item in row.get("first_nonzero_forced_degree", []):
            degree_counts[item["degree"]] += item["count"]
        for item in row.get("type_profiles", []):
            profile_counts[(item["secants"], item["passants"])] += item["count"]
    extensions = {}
    for row in rows:
        for extension in row.get("one_line_extensions", []):
            key = tuple(tuple(pair) for pair in extension["vertices"])
            if key in extensions and extensions[key] != extension:
                raise SystemExit("inconsistent duplicate extension record")
            extensions[key] = extension
    result = {
        "schema": f"c756-q{Q}-k13-star-aggregate-v1",
        "q": Q,
        "k": 13,
        "mode": model_name,
        "normalization": (
            "central inversion sends seed offset s to -s; representatives "
            f"0..{(Q - 1) // 2}"
        ),
        "seed_representatives": list(range((Q + 1) // 2)),
        "present_seed_representatives": sum(row["seed_present"] for row in rows),
        "search_nodes": sum(row["search_nodes"] for row in rows),
        "geometric_stars": sum(row["geometric_stars"] for row in rows),
        "forced_window_stars": sum(
            row.get("forced_window_stars", 0) for row in rows
        ),
        "stars_with_any_complete_center": sum(
            row.get("stars_with_any_complete_center", 0) for row in rows
        ),
        "stars_with_all_complete_centers": sum(
            row.get("stars_with_all_complete_centers", 0) for row in rows
        ),
        "first_nonzero_forced_degree": [
            {"degree": degree, "count": count}
            for degree, count in sorted(
                degree_counts.items(),
                key=lambda item: 100 if item[0] is None else item[0],
            )
        ],
        "type_profiles": [
            {"secants": key[0], "passants": key[1], "count": count}
            for key, count in sorted(profile_counts.items())
        ],
        "shards": rows,
        "pinned_files": {
            MIXED_BASE_PATH.name: MIXED_BASE_SHA256,
            PASSANT_BASE_PATH.name: PASSANT_BASE_SHA256,
        },
    }
    if any("one_line_extensions" in row for row in rows):
        result["extension_target_size"] = TARGET_SIZE + 1
        result["one_line_extensions"] = [
            extensions[key] for key in sorted(extensions)
        ]
        result["one_line_extension_count"] = len(extensions)
        result["extensions_with_any_complete_center"] = sum(
            extension["complete_centers"] > 0
            for extension in extensions.values()
        )
        result["extensions_with_all_complete_centers"] = sum(
            extension["complete_centers"] == extension["required_centers"]
            for extension in extensions.values()
        )
    return result


def aggregate_extension_output(root_certificate: Path, shard_directory: Path):
    root_bytes = root_certificate.read_bytes()
    root = json.loads(root_bytes)
    if (
        Q != 61
        or root.get("schema") != "c756-q61-k13-star-aggregate-v1"
        or root.get("mode") != "mixed-external-deletion"
        or root.get("geometric_stars") != 96
    ):
        raise SystemExit("invalid q=61 k=13 root certificate")
    source_rows = [
        row for row in root["shards"] if row["geometric_stars"] > 0
    ]
    extension_rows = []
    extensions = {}
    for source in source_rows:
        seed_s = source["seed_s"]
        path = shard_directory / f"c756-q61-mixed-seed-{seed_s}.json"
        payload = json.loads(path.read_text())
        row = payload.get("shard", {})
        if (
            payload.get("schema") != "c756-q61-k13-star-shard-v1"
            or payload.get("mode") != "mixed-external-deletion"
            or row.get("seed_s") != seed_s
            or row.get("geometric_stars") != source["geometric_stars"]
            or "one_line_extensions" not in row
        ):
            raise SystemExit(f"invalid extension shard: {path}")
        extension_rows.append(row)
        for extension in row["one_line_extensions"]:
            key = tuple(tuple(pair) for pair in extension["vertices"])
            if key in extensions and extensions[key] != extension:
                raise SystemExit("inconsistent duplicate extension record")
            extensions[key] = extension
    return {
        "schema": "c756-q61-k14-one-line-extension-v1",
        "q": 61,
        "k": 14,
        "source_k": 13,
        "source_geometric_stars": sum(
            row["geometric_stars"] for row in extension_rows
        ),
        "source_seed_representatives": [
            row["seed_s"] for row in extension_rows
        ],
        "source_search_nodes_replayed": sum(
            row["search_nodes"] for row in extension_rows
        ),
        "root_certificate": {
            "filename": root_certificate.name,
            "sha256": hashlib.sha256(root_bytes).hexdigest(),
        },
        "one_line_extension_count": len(extensions),
        "extensions_with_any_complete_center": sum(
            extension["complete_centers"] > 0
            for extension in extensions.values()
        ),
        "extensions_with_all_complete_centers": sum(
            extension["complete_centers"] == extension["required_centers"]
            for extension in extensions.values()
        ),
        "one_line_extensions": [
            extensions[key] for key in sorted(extensions)
        ],
        "pinned_files": {
            MIXED_BASE_PATH.name: MIXED_BASE_SHA256,
            PASSANT_BASE_PATH.name: PASSANT_BASE_SHA256,
        },
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--q", type=int, choices=(59, 61), default=Q)
    parser.add_argument("--mode", choices=("mixed", "all-passant"))
    parser.add_argument("--seed-s", type=int)
    parser.add_argument("--extend-one", action="store_true")
    parser.add_argument(
        "--aggregate-mode", choices=("mixed", "all-passant")
    )
    parser.add_argument("--aggregate-extensions-from", type=Path)
    parser.add_argument("--shard-directory", type=Path)
    parser.add_argument("--output", type=Path)
    parser.add_argument("--check", type=Path)
    arguments = parser.parse_args()
    if arguments.q != Q:
        parser.error("internal --q preparse mismatch")
    shard_mode = arguments.mode is not None or arguments.seed_s is not None
    aggregate_mode = arguments.aggregate_mode is not None
    extension_aggregate_mode = arguments.aggregate_extensions_from is not None
    if sum((shard_mode, aggregate_mode, extension_aggregate_mode)) != 1:
        parser.error("select exactly one shard or aggregate mode")
    if shard_mode:
        if arguments.mode is None or arguments.seed_s is None:
            parser.error("shard mode requires --mode and --seed-s")
        if not 0 <= arguments.seed_s < Q:
            parser.error("--seed-s must lie in [0,58]")
        if arguments.extend_one and (Q != 61 or arguments.mode != "mixed"):
            parser.error("--extend-one is implemented for q=61 mixed shards")
        output = exact_output(
            arguments.mode,
            arguments.seed_s,
            extend_one=arguments.extend_one,
        )
    elif aggregate_mode:
        if arguments.extend_one:
            parser.error("--extend-one belongs to shard mode")
        if arguments.aggregate_mode is None or arguments.shard_directory is None:
            parser.error(
                "aggregate mode requires --aggregate-mode and --shard-directory"
            )
        output = aggregate_output(
            arguments.aggregate_mode, arguments.shard_directory
        )
    else:
        if arguments.extend_one:
            parser.error("--extend-one belongs to shard mode")
        if arguments.shard_directory is None:
            parser.error("extension aggregation requires --shard-directory")
        output = aggregate_extension_output(
            arguments.aggregate_extensions_from,
            arguments.shard_directory,
        )
    rendered = json.dumps(
        output, indent=2, sort_keys=True
    ) + "\n"
    if arguments.output is not None and arguments.check is not None:
        parser.error("select at most one of --output and --check")
    if arguments.check is not None:
        if rendered != arguments.check.read_text():
            raise SystemExit(f"certificate mismatch: {arguments.check}")
        print(f"certificate ok: {arguments.check}")
    elif arguments.output is None:
        print(rendered, end="")
    else:
        arguments.output.write_text(rendered)
        print(f"wrote {arguments.output}")


if __name__ == "__main__":
    main()
