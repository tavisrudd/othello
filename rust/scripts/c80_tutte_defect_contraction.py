#!/usr/bin/env python3
"""C80: expose the marked q=17 positive-overload Tutte defect.

This is initially a diagnostic over the exact five-state defect thread from
``c80_positive_pairing_shell.py``.  It records the Gallai--Edmonds
decomposition of each strict-reply graph and intrinsic conic/secant data for
the four exceptional exchanges.
"""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / "rust/scripts/c80_positive_pairing_shell.py"
ORBIT_SOURCE = ROOT / "rust/scripts/c80_marked_head_orbits.py"
OUT = ROOT / "notes/2026-07-25-c80-tutte-defect-contraction.json"
INPUTS = (
    SOURCE,
    ORBIT_SOURCE,
    ROOT / "rust/scripts/c80_adaptive_copycat_survivor.py",
    ROOT / "rust/scripts/c80_strict_overload_kernel.py",
    ROOT / "rust/scripts/c80_response_fibre_census.py",
    ROOT / "notes/2026-07-08-zone-repair-geometry.py",
    ROOT / "notes/2026-07-08-zone-steering-census.py",
    ROOT / "notes/2026-07-08-intrusion-census.py",
)


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


SHELL = load_module(SOURCE, "c80_tutte_shell")
ORBITS = load_module(ORBIT_SOURCE, "c80_tutte_orbits")
BASE = SHELL.BASE
GEOMETRY = BASE.BASE.GEOMETRY


def reply_graph(kernel, mask: int) -> tuple[tuple[int, ...], tuple[int, ...]]:
    cells = tuple(GEOMETRY.bits(kernel.game.legal_mask(mask)))
    adjacency = [0] * len(cells)
    old_omega = kernel.omega(mask)
    for left, opponent in enumerate(cells):
        child = mask | (1 << opponent)
        legal_replies = kernel.game.legal_mask(child)
        for right in range(left + 1, len(cells)):
            reply = cells[right]
            if not (legal_replies & (1 << reply)):
                continue
            target = child | (1 << reply)
            if kernel.omega(target) < old_omega and kernel.contains(target):
                adjacency[left] |= 1 << right
                adjacency[right] |= 1 << left
    return cells, tuple(adjacency)


def components(vertices: int, adjacency: tuple[int, ...]) -> list[list[int]]:
    result = []
    while vertices:
        seed = vertices & -vertices
        todo = seed
        component = 0
        while todo:
            bit = todo & -todo
            todo ^= bit
            vertex = bit.bit_length() - 1
            component |= bit
            todo |= adjacency[vertex] & vertices & ~component
        vertices &= ~component
        result.append(list(GEOMETRY.bits(component)))
    return result


def gallai_edmonds_parts(adjacency: tuple[int, ...]):
    match = SHELL.maximum_matching(adjacency)
    size = SHELL.matching_size(match)
    exposed = 0
    all_vertices = (1 << len(adjacency)) - 1
    for vertex in range(len(adjacency)):
        reduced = SHELL.induced_without(adjacency, vertex)
        if SHELL.matching_size(SHELL.maximum_matching(reduced)) == size:
            exposed |= 1 << vertex
    neighbours = 0
    for vertex in GEOMETRY.bits(exposed):
        neighbours |= adjacency[vertex]
    attachment = neighbours & ~exposed
    core = all_vertices & ~(exposed | attachment)
    return match, exposed, attachment, core


def gallai_edmonds(adjacency: tuple[int, ...]) -> dict:
    match, exposed, attachment, core = gallai_edmonds_parts(adjacency)
    size = SHELL.matching_size(match)
    return {
        "order": len(adjacency),
        "edges": sum(row.bit_count() for row in adjacency) // 2,
        "matching_size": size,
        "deficiency": len(adjacency) - 2 * size,
        "D_size": exposed.bit_count(),
        "A_size": attachment.bit_count(),
        "C_size": core.bit_count(),
        "D_component_sizes": sorted(
            len(component) for component in components(exposed, adjacency)
        ),
        "C_component_sizes": sorted(
            len(component) for component in components(core, adjacency)
        ),
        "isolated_vertices": [
            vertex for vertex, row in enumerate(adjacency) if row == 0
        ],
    }


def labelled_vertex(game, cell: int) -> dict:
    row = {"cell": list(game.cell_tuple(cell))}
    if game.is_conic_cell(cell):
        row["conic_parameter"] = game.cell_param[cell]
    else:
        row["kind"] = "intruder"
    return row


def labelled_decomposition(game, cells, adjacency: tuple[int, ...]) -> dict:
    _match, exposed, attachment, core = gallai_edmonds_parts(adjacency)
    return {
        "D_components": [
            [labelled_vertex(game, cells[vertex]) for vertex in component]
            for component in components(exposed, adjacency)
        ],
        "A": [
            labelled_vertex(game, cells[vertex])
            for vertex in GEOMETRY.bits(attachment)
        ],
        "C_components": [
            [labelled_vertex(game, cells[vertex]) for vertex in component]
            for component in components(core, adjacency)
        ],
    }


def contracted_tutte(adjacency: tuple[int, ...]) -> dict:
    _match, exposed, attachment, _core = gallai_edmonds_parts(adjacency)
    d_components = [
        sum(1 << vertex for vertex in component)
        for component in components(exposed, adjacency)
    ]
    a_vertices = list(GEOMETRY.bits(attachment))
    incidence = []
    for a_position, vertex in enumerate(a_vertices):
        for d_position, component in enumerate(d_components):
            if adjacency[vertex] & component:
                incidence.append((a_position, d_position))
    a_degrees = [
        sum(left == position for left, _right in incidence)
        for position in range(len(a_vertices))
    ]
    d_degrees = [
        sum(right == position for _left, right in incidence)
        for position in range(len(d_components))
    ]
    return {
        "A_order": len(a_vertices),
        "D_component_order": len(d_components),
        "incidence_edges": len(incidence),
        "A_degree_sequence": sorted(a_degrees),
        "D_degree_sequence": sorted(d_degrees),
        "internal_D_edges": sum(
            sum(
                (adjacency[vertex] & component).bit_count()
                for vertex in GEOMETRY.bits(component)
            )
            // 2
            for component in d_components
        ),
    }


def verify_tutte_berge(adjacency: tuple[int, ...]) -> bool:
    match, _exposed, attachment, _core = gallai_edmonds_parts(adjacency)
    seen = set()
    for vertex, mate in enumerate(match):
        if mate < 0:
            continue
        assert match[mate] == vertex
        assert adjacency[vertex] & (1 << mate)
        seen.add(tuple(sorted((vertex, mate))))
    matching_size = len(seen)
    remaining = ((1 << len(adjacency)) - 1) & ~attachment
    odd_components = sum(
        len(component) % 2 for component in components(remaining, adjacency)
    )
    tutte_deficiency = odd_components - attachment.bit_count()
    assert len(adjacency) - 2 * matching_size == tutte_deficiency
    return True


def conic_parameter(value) -> str | int:
    return value if isinstance(value, int) else str(value)


def exchange_geometry(game, state: int, opponent: int, reply: int) -> dict:
    played = GEOMETRY.played_params(game, state)
    intruders = GEOMETRY.intruders(game, state)
    row = {
        "opponent": list(game.cell_tuple(opponent)),
        "reply": list(game.cell_tuple(reply)),
        "line_type": GEOMETRY.line_type(game, opponent, reply),
        "conic_intersections": [
            conic_parameter(value)
            for value in GEOMETRY.conic_intersections(game, opponent, reply)
        ],
        "product_order": GEOMETRY.prod_order(game, opponent, reply),
        "opponent_tau_played": GEOMETRY.tau_played(game, opponent, played),
        "reply_tau_played": GEOMETRY.tau_played(game, reply, played),
        "prior_intruder_product_orders": [
            GEOMETRY.prod_order(game, prior, opponent) for prior in intruders
        ],
    }
    return row


def projective_point(game, cell: int):
    return ORBITS.normalize(game.points[cell + 2])


def root_stabilizer_orbits(game, root: int, exchanges: list[tuple[int, int]]):
    selected = tuple(
        sorted(
            [ORBITS.conic_point("inf"), ORBITS.conic_point(0)]
            + [projective_point(game, cell) for cell in GEOMETRY.bits(root)]
        )
    )
    stabilizer = tuple(
        matrix
        for matrix in ORBITS.pgl2()
        if tuple(sorted(ORBITS.sym2(matrix, point) for point in selected))
        == selected
    )
    keys = [
        (selected, projective_point(game, opponent), projective_point(game, reply))
        for opponent, reply in exchanges
    ]
    remaining = set(range(len(keys)))
    partition = []
    while remaining:
        seed = min(remaining)
        orbit = {
            index
            for index, key in enumerate(keys)
            if any(ORBITS.transform_key(matrix, keys[seed]) == key for matrix in stabilizer)
        }
        partition.append(sorted(orbit))
        remaining -= orbit
    return {
        "stabilizer_order": len(stabilizer),
        "matrices": [list(matrix) for matrix in stabilizer],
        "ordered_exchange_orbits": partition,
    }


def normalize_matrix(q: int, matrix: tuple[int, int, int, int]):
    pivot = next(value for value in matrix if value % q)
    scale = pow(pivot, -1, q)
    return tuple((scale * value) % q for value in matrix)


def mobius_image(q: int, matrix, parameter: int | str):
    a, b, c, d = matrix
    if parameter == "inf":
        numerator, denominator = a, c
    else:
        numerator = (a * int(parameter) + b) % q
        denominator = (c * int(parameter) + d) % q
    if denominator == 0:
        return "inf"
    return numerator * pow(denominator, -1, q) % q


def six_parameter_stabilizer_order(q: int) -> int:
    parameters = {"inf", 0, q - 1, q - 2, q - 3, q - 4}
    matrices = set()
    for a in range(q):
        for b in range(q):
            for c in range(q):
                for d in range(q):
                    if (a * d - b * c) % q:
                        matrices.add(normalize_matrix(q, (a, b, c, d)))
    return sum(
        {mobius_image(q, matrix, parameter) for parameter in parameters}
        == parameters
        for matrix in matrices
    )


RATIONAL_EXCHANGE_ORBIT = (
    (((4, 1), (0, 1)), ((7, 1), (1, 1))),
    (((-12, 1), (0, 1)), ((-31, 5), (-1, 5))),
    (((-12, 7), (-4, 7)), ((-5, 3), (-5, 8))),
    (((-20, 9), (-4, 9)), ((-22, 9), (-5, 12))),
)


def reduce_rational_cell(q: int, cell) -> tuple[int, int]:
    return tuple(
        numerator * pow(denominator, -1, q) % q
        for numerator, denominator in cell
    )


def rational_packet_geometry(q: int) -> dict:
    kernel = BASE.CopycatKernel(q)
    root_t4 = tuple(range(q - 4, q))
    root = kernel.game.base_mask(root_t4)
    root_omega = kernel.omega(root)
    rows = []
    for opponent_rational, reply_rational in RATIONAL_EXCHANGE_ORBIT:
        opponent_cell = reduce_rational_cell(q, opponent_rational)
        reply_cell = reduce_rational_cell(q, reply_rational)
        opponent = opponent_cell[0] * q + opponent_cell[1]
        reply = reply_cell[0] * q + reply_cell[1]
        opponent_legal = bool(kernel.game.legal_mask(root) & (1 << opponent))
        child = root | (1 << opponent)
        reply_legal = opponent_legal and bool(
            kernel.game.legal_mask(child) & (1 << reply)
        )
        target = child | (1 << reply)
        rows.append(
            {
                "opponent": list(opponent_cell),
                "reply": list(reply_cell),
                "opponent_legal": opponent_legal,
                "reply_legal": reply_legal,
                "target_omega": kernel.omega(target) if reply_legal else None,
                "strict_omega": reply_legal and kernel.omega(target) < root_omega,
                "line_type": GEOMETRY.line_type(
                    kernel.game, opponent, reply
                ),
                "product_order": GEOMETRY.prod_order(
                    kernel.game, opponent, reply
                ),
            }
        )
    representative = rows[0]
    representative_opponent = (
        representative["opponent"][0] * q + representative["opponent"][1]
    )
    representative_reply = (
        representative["reply"][0] * q + representative["reply"][1]
    )
    representative_child = root | (1 << representative_opponent)
    representative_target = representative_child | (
        1 << representative_reply
    )
    packet_target_survivor = (
        kernel.contains(representative_target)
        if representative["reply_legal"]
        else None
    )
    first_survivor_reply = None
    first_survivor_target = None
    for reply in GEOMETRY.bits(kernel.game.legal_mask(representative_child)):
        target = representative_child | (1 << reply)
        if kernel.omega(target) < root_omega and kernel.contains(target):
            first_survivor_target = target
            first_survivor_reply = {
                "reply": list(kernel.game.cell_tuple(reply)),
                "target_omega": kernel.omega(target),
                "line_type": GEOMETRY.line_type(
                    kernel.game, representative_opponent, reply
                ),
                "product_order": GEOMETRY.prod_order(
                    kernel.game, representative_opponent, reply
                ),
            }
            break
    if first_survivor_target is not None:
        pairing_kernel = SHELL.PositivePairingKernel(q)
        first_survivor_reply["positive_pairing_survivor"] = (
            pairing_kernel.contains(first_survivor_target)
        )
    return {
        "q": q,
        "root_t4": list(root_t4),
        "root_omega": root_omega,
        "line_discriminant_28_square_class": (
            "zero"
            if 28 % q == 0
            else (
                "square"
                if pow(28 % q, (q - 1) // 2, q) == 1
                else "nonsquare"
            )
        ),
        "distinct_ordered_exchanges": len(
            {
                (tuple(row["opponent"]), tuple(row["reply"]))
                for row in rows
            }
        ),
        "representative_packet_target_copycat_survivor": (
            packet_target_survivor
        ),
        "representative_first_strict_copycat_survivor_reply": (
            first_survivor_reply
        ),
        "rows": rows,
    }


def run() -> dict:
    q = 17
    kernel = SHELL.PositivePairingKernel(q)
    old_kernel = BASE.CopycatKernel(q)
    root = kernel.game.base_mask((13, 14, 15, 16))
    assert old_kernel.contains(root)
    root_cells, root_graph = reply_graph(kernel, root)
    assert verify_tutte_berge(root_graph)
    isolated = [
        vertex for vertex, neighbours in enumerate(root_graph) if not neighbours
    ]
    exchanges = []
    exchange_cells = []
    for vertex in isolated:
        opponent = root_cells[vertex]
        child = root | (1 << opponent)
        replies = []
        for reply in GEOMETRY.bits(old_kernel.game.legal_mask(child)):
            target = child | (1 << reply)
            if (
                old_kernel.omega(target) < old_kernel.omega(root)
                and old_kernel.contains(target)
            ):
                replies.append((reply, target))
        assert len(replies) == 1
        reply, target = replies[0]
        exchange_cells.append((opponent, reply))
        target_cells, target_graph = reply_graph(kernel, target)
        assert verify_tutte_berge(target_graph)
        exchanges.append(
            {
                **exchange_geometry(kernel.game, root, opponent, reply),
                "target_selected": [
                    list(kernel.game.cell_tuple(cell))
                    for cell in GEOMETRY.bits(target)
                ],
                "target_omega": kernel.omega(target),
                "target_reply_graph": gallai_edmonds(target_graph),
                "target_tutte_contraction": contracted_tutte(target_graph),
                "target_tutte_decomposition": labelled_decomposition(
                    kernel.game, target_cells, target_graph
                ),
                "target_reply_graph_cells": [
                    list(kernel.game.cell_tuple(cell)) for cell in target_cells
                ],
            }
        )
    target_types = {
        json.dumps(
            {
                "reply_graph": row["target_reply_graph"],
                "contraction": row["target_tutte_contraction"],
            },
            sort_keys=True,
        )
        for row in exchanges
    }
    assert len(target_types) == 1
    comparison_kernel = SHELL.PositivePairingKernel(13)
    comparison_root = comparison_kernel.game.base_mask((9, 10, 11, 12))
    comparison_accepted = comparison_kernel.contains(comparison_root)
    comparison_graph = reply_graph(comparison_kernel, comparison_root)[1]
    assert comparison_accepted
    assert verify_tutte_berge(comparison_graph)
    return {
        "schema": "c80-tutte-defect-contraction-v1",
        "source": "rust/scripts/c80_tutte_defect_contraction.py",
        "input_sha256": {
            str(path.relative_to(ROOT)): sha256(path) for path in INPUTS
        },
        "claim_scope": {
            "field": 17,
            "root_t4": [13, 14, 15, 16],
            "states": 5,
            "exceptional_exchanges": 4,
            "uniform_odd_q_claim": False,
        },
        "tutte_berge_certificates_verified": True,
        "q": q,
        "root_t4": [13, 14, 15, 16],
        "root_omega": kernel.omega(root),
        "root_reply_graph": gallai_edmonds(root_graph),
        "root_reply_graph_cells": [
            list(kernel.game.cell_tuple(cell)) for cell in root_cells
        ],
        "root_stabilizer": root_stabilizer_orbits(
            kernel.game, root, exchange_cells
        ),
        "same_parameter_pattern_stabilizer_orders": {
            str(order): six_parameter_stabilizer_order(order)
            for order in (11, 13, 17, 19)
        },
        "rational_exchange_orbit": [
            {
                "opponent": [
                    [numerator, denominator]
                    for numerator, denominator in opponent
                ],
                "reply": [
                    [numerator, denominator]
                    for numerator, denominator in reply
                ],
            }
            for opponent, reply in RATIONAL_EXCHANGE_ORBIT
        ],
        "rational_packet_geometry": [
            rational_packet_geometry(order) for order in (13, 17, 19)
        ],
        "same_parameter_pattern_q13_control": {
            "root_t4": [9, 10, 11, 12],
            "positive_pairing_survivor": comparison_accepted,
            "reply_graph": gallai_edmonds(comparison_graph),
        },
        "exceptional_exchanges": exchanges,
    }


def write_output(path: Path) -> None:
    path.write_text(json.dumps(run(), indent=2, sort_keys=True) + "\n")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.check:
        with tempfile.TemporaryDirectory() as directory:
            candidate = Path(directory) / OUT.name
            write_output(candidate)
            if not OUT.exists() or candidate.read_bytes() != OUT.read_bytes():
                raise SystemExit("certificate drift")
        print("PASS")
        return 0
    write_output(OUT)
    print(OUT)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
