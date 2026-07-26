#!/usr/bin/env python3
"""C80: test the central-involution rank datum on the q17/q19 repairs."""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import sys
import tempfile
from itertools import combinations, permutations
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / "rust/scripts/c80_equivariant_live_secant_correspondence.py"
OUT = ROOT / "notes/2026-07-25-c80-central-involution-rank-datum.json"

Matrix = tuple[int, int, int, int]
Point = tuple[int, int, int]


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


LIVE = load_module(SOURCE, "c80_central_live")
COMPARE = LIVE.COMPARE
SPOILER = LIVE.SPOILER
GEOMETRY = LIVE.GEOMETRY
INPUTS = (SOURCE, *LIVE.INPUTS)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def matrix_mul(q: int, left: Matrix, right: Matrix) -> Matrix:
    a, b, c, d = left
    e, f, g, h = right
    return (
        (a * e + b * g) % q,
        (a * f + b * h) % q,
        (c * e + d * g) % q,
        (c * f + d * h) % q,
    )


def matrix_pow(q: int, matrix: Matrix, exponent: int) -> Matrix:
    result = (1, 0, 0, 1)
    while exponent:
        if exponent & 1:
            result = matrix_mul(q, result, matrix)
        matrix = matrix_mul(q, matrix, matrix)
        exponent //= 2
    return result


def matrix_normalize(q: int, matrix: Matrix) -> Matrix:
    pivot = next(value for value in matrix if value % q)
    inverse = pow(pivot, -1, q)
    return tuple((inverse * value) % q for value in matrix)  # type: ignore[return-value]


def matrix_inverse(q: int, matrix: Matrix) -> Matrix:
    a, b, c, d = matrix
    determinant_inverse = pow((a * d - b * c) % q, -1, q)
    return (
        d * determinant_inverse % q,
        -b * determinant_inverse % q,
        -c * determinant_inverse % q,
        a * determinant_inverse % q,
    )


def intruder_involution(q: int, point: Point) -> Matrix:
    """Projection involution t |-> (z t - x)/(y t - z)."""
    x, y, z = point
    return matrix_normalize(q, (z, -x, y, -z))


def central_involution(game, opponent: int, reply: int) -> tuple[int, Matrix]:
    order = GEOMETRY.prod_order(game, opponent, reply)
    if order % 2:
        raise ValueError("product order is odd")
    left = intruder_involution(
        game.q, SPOILER.projective_point(game, opponent)
    )
    right = intruder_involution(
        game.q, SPOILER.projective_point(game, reply)
    )
    product = matrix_mul(game.q, left, right)
    central = matrix_normalize(
        game.q, matrix_pow(game.q, product, order // 2)
    )
    assert matrix_normalize(
        game.q, matrix_mul(game.q, central, central)
    ) == (1, 0, 0, 1)
    assert central != (1, 0, 0, 1)
    return order, central


def determinant(q: int, first: Point, second: Point, third: Point) -> int:
    a, b, c = first
    d, e, f = second
    g, h, i = third
    return (
        a * (e * i - f * h)
        - b * (d * i - f * g)
        + c * (d * h - e * g)
    ) % q


def direct_cap(q: int, points) -> bool:
    return all(
        determinant(q, first, second, third)
        for first, second, third in combinations(points, 3)
    )


def full_selected_points(game, mask: int) -> tuple[Point, ...]:
    points = [(1, 0, 0), (0, 1, 0)]
    points.extend(
        SPOILER.projective_point(game, cell)
        for cell in GEOMETRY.bits(mask)
    )
    return tuple(sorted(points))


def response_rows(
    kernel, target: int, central: Matrix, *, evaluate_values: bool = False
) -> list[dict]:
    game = kernel.game
    lookup = LIVE.point_to_cell(game)
    selected = full_selected_points(game, target)
    old_omega = kernel.omega(target)
    rows = []
    for opponent in GEOMETRY.bits(game.legal_mask(target)):
        opponent_point = SPOILER.projective_point(game, opponent)
        reply_point = SPOILER.sym2(game.q, central, opponent_point)
        reply = lookup.get(reply_point)
        direct_valid = direct_cap(
            game.q, (*selected, opponent_point, reply_point)
        )
        if reply is None:
            reason = "image_on_opening_line"
            assert not direct_valid
        elif reply == opponent:
            reason = "fixed_legal_move"
            assert not direct_valid
        else:
            engine_valid = bool(
                game.legal_mask(target | (1 << opponent)) & (1 << reply)
            )
            assert engine_valid == direct_valid
            if not engine_valid:
                reason = "illegal_reply"
            elif kernel.omega(
                target | (1 << opponent) | (1 << reply)
            ) >= old_omega:
                reason = "nonstrict_reply"
            else:
                reason = "usable_strict_reply"
        row = {
            "opponent": list(game.cell_tuple(opponent)),
            "central_image": (
                list(game.cell_tuple(reply)) if reply is not None else None
            ),
            "classification": reason,
        }
        if evaluate_values and reason == "usable_strict_reply":
            next_target = target | (1 << opponent) | (1 << reply)
            row["target_exact_grid_value"] = (
                "P" if not game.value(next_target) else "N"
            )
        rows.append(row)
    return sorted(rows, key=lambda row: row["opponent"])


def case_data(
    q: int,
    t4: tuple[int, ...],
    opponent_cell: tuple[int, int],
    repair_cell: tuple[int, int],
) -> dict:
    kernel = SPOILER.SHELL.PositivePairingKernel(q)
    game = kernel.game
    state = game.base_mask(t4)
    opponent = LIVE.cell_index(game, opponent_cell)
    repair = LIVE.cell_index(game, repair_cell)
    target = state | (1 << opponent) | (1 << repair)
    order, central = central_involution(game, opponent, repair)
    selected = set(full_selected_points(game, target))
    moved = {SPOILER.sym2(q, central, point) for point in selected}
    rows = response_rows(kernel, target, central, evaluate_values=True)
    histogram = {
        name: sum(row["classification"] == name for row in rows)
        for name in (
            "usable_strict_reply",
            "illegal_reply",
            "image_on_opening_line",
            "fixed_legal_move",
            "nonstrict_reply",
        )
    }
    usable_value_histogram = {
        value: sum(row.get("target_exact_grid_value") == value for row in rows)
        for value in ("P", "N")
    }
    return {
        "q": q,
        "root_t4": list(t4),
        "repair_edge": {
            "opponent": list(opponent_cell),
            "reply": list(repair_cell),
        },
        "product_order": order,
        "central_involution_matrix": list(central),
        "selected_points": len(selected),
        "selected_overlap_with_image": len(selected & moved),
        "obligation_rank_half_symmetric_difference": (
            len(selected ^ moved) // 2
        ),
        "fixed_selected_points": sum(
            SPOILER.sym2(q, central, point) == point for point in selected
        ),
        "legal_opponents": len(rows),
        "response_histogram": histogram,
        "usable_target_value_histogram": usable_value_histogram,
        "responses": rows,
    }


def transport_check(case: dict) -> dict:
    q = case["q"]
    t4 = tuple(case["root_t4"])
    opponent_cell = tuple(case["repair_edge"]["opponent"])
    repair_cell = tuple(case["repair_edge"]["reply"])
    kernel = SPOILER.SHELL.PositivePairingKernel(q)
    game = kernel.game
    state = game.base_mask(t4)
    opponent = LIVE.cell_index(game, opponent_cell)
    repair = LIVE.cell_index(game, repair_cell)
    target = state | (1 << opponent) | (1 << repair)
    _order, central = central_involution(game, opponent, repair)
    lookup = LIVE.point_to_cell(game)
    matrices = LIVE.stabilizer_matrices(game, state)
    response_classes = {
        tuple(row["opponent"]): (
            row["classification"] == "usable_strict_reply"
        )
        for row in response_rows(kernel, target, central)
    }
    conjugacy_checks = 0
    response_checks = 0
    for transporter in matrices:
        transformed_opponent = lookup[
            SPOILER.sym2(
                q, transporter, SPOILER.projective_point(game, opponent)
            )
        ]
        transformed_repair = lookup[
            SPOILER.sym2(
                q, transporter, SPOILER.projective_point(game, repair)
            )
        ]
        transformed_target = (
            state | (1 << transformed_opponent) | (1 << transformed_repair)
        )
        _transformed_order, transformed_central = central_involution(
            game, transformed_opponent, transformed_repair
        )
        conjugate = matrix_normalize(
            q,
            matrix_mul(
                q,
                matrix_mul(q, transporter, central),
                matrix_inverse(q, transporter),
            ),
        )
        assert conjugate == transformed_central
        conjugacy_checks += 1
        transformed_classes = {
            tuple(row["opponent"]): (
                row["classification"] == "usable_strict_reply"
            )
            for row in response_rows(
                kernel, transformed_target, transformed_central
            )
        }
        for cell, usable in response_classes.items():
            move = LIVE.cell_index(game, cell)
            transformed_move = lookup[
                SPOILER.sym2(
                    q, transporter, SPOILER.projective_point(game, move)
                )
            ]
            assert (
                transformed_classes[game.cell_tuple(transformed_move)]
                == usable
            )
            response_checks += 1
    return {
        "stabilizer_order": len(matrices),
        "central_involution_conjugacy_checks": conjugacy_checks,
        "transported_response_class_checks": response_checks,
        "all_checks_pass": True,
    }


def q19_usable_orbits() -> list[dict]:
    q, t4, opponent_cell, repair_cell = COMPARE.REPAIRS[-1]
    kernel = SPOILER.SHELL.PositivePairingKernel(q)
    game = kernel.game
    state = game.base_mask(t4)
    opponent = LIVE.cell_index(game, opponent_cell)
    repair = LIVE.cell_index(game, repair_cell)
    target = state | (1 << opponent) | (1 << repair)
    _order, central = central_involution(game, opponent, repair)
    seen = set()
    result = []
    for row in response_rows(
        kernel, target, central, evaluate_values=True
    ):
        if row["classification"] != "usable_strict_reply":
            continue
        first = LIVE.cell_index(game, tuple(row["opponent"]))
        second = LIVE.cell_index(game, tuple(row["central_image"]))
        pair = tuple(sorted((first, second)))
        if pair in seen:
            continue
        seen.add(pair)
        next_target = target | (1 << first) | (1 << second)
        features = COMPARE.public_features(
            COMPARE.edge_features(kernel, target, first, second)
        )
        pair_order, rewritten_central = central_involution(
            game, first, second
        )
        rewritten_rows = response_rows(
            kernel, next_target, rewritten_central
        )
        result.append(
            {
                "exchange": [
                    list(game.cell_tuple(cell)) for cell in pair
                ],
                "oriented_edges": 2,
                "target_exact_grid_value": (
                    "P" if not game.value(next_target) else "N"
                ),
                "target_omega": kernel.omega(next_target),
                "exchange_product_order": pair_order,
                "exchange_line_type": features[
                    "opponent_reply_line_type"
                ],
                "target_legal_points": features["target_legal_points"],
                "target_live_conic": features["target_live_conic"],
                "target_minimum_mate_degree": features[
                    "target_minimum_mate_degree"
                ],
                "rewritten_central_usable_replies": sum(
                    response["classification"] == "usable_strict_reply"
                    for response in rewritten_rows
                ),
                "rewritten_target_legal_opponents": len(rewritten_rows),
            }
        )
    return sorted(result, key=lambda row: row["exchange"])


def graph_components(adjacency: list[set[int]]) -> list[list[int]]:
    unseen = set(range(len(adjacency)))
    result = []
    while unseen:
        start = min(unseen)
        unseen.remove(start)
        todo = [start]
        component = []
        while todo:
            vertex = todo.pop()
            component.append(vertex)
            new = adjacency[vertex] & unseen
            unseen -= new
            todo.extend(sorted(new, reverse=True))
        result.append(sorted(component))
    return sorted(result, key=lambda component: (len(component), component))


def graph_automorphism_order(adjacency: list[set[int]]) -> int:
    order = len(adjacency)
    degrees = [len(neighbours) for neighbours in adjacency]
    count = 0
    for permutation in permutations(range(order)):
        if any(degrees[vertex] != degrees[permutation[vertex]] for vertex in range(order)):
            continue
        if all(
            ((right in adjacency[left]) == (
                permutation[right] in adjacency[permutation[left]]
            ))
            for left in range(order)
            for right in range(left + 1, order)
        ):
            count += 1
    return count


def q19_terminal_shells() -> list[dict]:
    q, t4, opponent_cell, repair_cell = COMPARE.REPAIRS[-1]
    kernel = SPOILER.SHELL.PositivePairingKernel(q)
    game = kernel.game
    state = game.base_mask(t4)
    opponent = LIVE.cell_index(game, opponent_cell)
    repair = LIVE.cell_index(game, repair_cell)
    repair_target = state | (1 << opponent) | (1 << repair)
    exchanges = (
        ((3, 3), (14, 12)),
        ((5, 12), (7, 13)),
    )
    result = []
    for exchange in exchanges:
        target = repair_target
        for cell in exchange:
            target |= 1 << LIVE.cell_index(game, cell)
        cells = list(GEOMETRY.bits(game.legal_mask(target)))
        terminal_moves = [
            move
            for move in cells
            if game.legal_mask(target | (1 << move)) == 0
        ]
        adjacency = [set() for _ in cells]
        terminal_edges = []
        for left, first in enumerate(cells):
            child = target | (1 << first)
            for right in range(left + 1, len(cells)):
                second = cells[right]
                if not (game.legal_mask(child) & (1 << second)):
                    continue
                if game.legal_mask(child | (1 << second)) != 0:
                    continue
                adjacency[left].add(right)
                adjacency[right].add(left)
                terminal_edges.append(
                    [
                        list(game.cell_tuple(first)),
                        list(game.cell_tuple(second)),
                    ]
                )
        components = graph_components(adjacency)
        result.append(
            {
                "exchange": [list(cell) for cell in exchange],
                "target_exact_grid_value": (
                    "P" if not game.value(target) else "N"
                ),
                "legal_moves": [
                    list(game.cell_tuple(move)) for move in cells
                ],
                "terminal_moves": [
                    list(game.cell_tuple(move)) for move in terminal_moves
                ],
                "terminal_reply_edges": terminal_edges,
                "terminal_reply_degree_sequence": sorted(
                    len(neighbours) for neighbours in adjacency
                ),
                "terminal_reply_component_orders": sorted(
                    len(component) for component in components
                ),
                "terminal_reply_component_edge_counts": sorted(
                    sum(
                        len(adjacency[vertex] & set(component))
                        for vertex in component
                    )
                    // 2
                    for component in components
                ),
                "terminal_reply_graph_automorphism_order": (
                    graph_automorphism_order(adjacency)
                ),
                "selected_target_conic_projective_stabilizer_order": len(
                    LIVE.stabilizer_matrices(game, target)
                ),
                "every_move_has_terminal_reply": all(adjacency),
            }
        )
    return result


def q17_terminal_edge_controls() -> list[dict]:
    result = []
    for q, t4, opponent_cell, repair_cell in COMPARE.REPAIRS[:4]:
        kernel = SPOILER.SHELL.PositivePairingKernel(q)
        game = kernel.game
        target = game.base_mask(t4)
        target |= 1 << LIVE.cell_index(game, opponent_cell)
        target |= 1 << LIVE.cell_index(game, repair_cell)
        cells = list(GEOMETRY.bits(game.legal_mask(target)))
        adjacency = [set() for _ in cells]
        terminal_moves = 0
        terminal_edges = 0
        covered = set()
        for left, first in enumerate(cells):
            child = target | (1 << first)
            if game.legal_mask(child) == 0:
                terminal_moves += 1
            for second in cells[left + 1 :]:
                if not (game.legal_mask(child) & (1 << second)):
                    continue
                if game.legal_mask(child | (1 << second)) != 0:
                    continue
                terminal_edges += 1
                covered.update((first, second))
                right = cells.index(second)
                adjacency[left].add(right)
                adjacency[right].add(left)
        components = graph_components(adjacency)
        nontrivial = []
        for component in components:
            component_set = set(component)
            edge_count = sum(
                len(adjacency[vertex] & component_set)
                for vertex in component
            ) // 2
            if edge_count:
                nontrivial.append(
                    {
                        "vertices": len(component),
                        "edges": edge_count,
                        "degree_sequence": sorted(
                            len(adjacency[vertex] & component_set)
                            for vertex in component
                        ),
                    }
                )
        result.append(
            {
                "repair_edge": {
                    "opponent": list(opponent_cell),
                    "reply": list(repair_cell),
                },
                "legal_moves": len(cells),
                "terminal_moves": terminal_moves,
                "terminal_reply_edges": terminal_edges,
                "moves_covered_by_terminal_reply_edges": len(covered),
                "terminal_reply_degree_histogram": [
                    [degree, sum(len(neighbours) == degree for neighbours in adjacency)]
                    for degree in sorted({len(neighbours) for neighbours in adjacency})
                ],
                "nontrivial_component_profiles": nontrivial,
                "opponent_complete_terminal_shell": len(covered) == len(cells),
            }
        )
    return result


def build_certificate() -> dict:
    cases = [
        case_data(q, t4, opponent, repair)
        for q, t4, opponent, repair in COMPARE.REPAIRS
    ]
    assert all(
        case["response_histogram"]["usable_strict_reply"] == 0
        for case in cases[:4]
    )
    assert cases[-1]["response_histogram"]["usable_strict_reply"] == 4
    assert cases[-1]["usable_target_value_histogram"] == {"P": 2, "N": 2}
    transports = {
        "q17_representative": transport_check(cases[0]),
        "q19_control": transport_check(cases[-1]),
    }
    q19_orbits = q19_usable_orbits()
    assert [
        (
            row["target_exact_grid_value"],
            row["target_omega"],
            row["exchange_product_order"],
            row["target_live_conic"],
        )
        for row in q19_orbits
    ] == [("N", 0, 2, 0), ("P", 1, 10, 3)]
    assert all(
        row["rewritten_central_usable_replies"] == 0
        for row in q19_orbits
    )
    q19_shells = q19_terminal_shells()
    assert len(q19_shells[0]["terminal_moves"]) == 2
    assert not q19_shells[0]["every_move_has_terminal_reply"]
    assert q19_shells[1]["terminal_moves"] == []
    assert q19_shells[1]["every_move_has_terminal_reply"]
    assert q19_shells[1]["terminal_reply_degree_sequence"] == [
        1,
        1,
        1,
        2,
        2,
        2,
        3,
    ]
    assert q19_shells[1]["terminal_reply_component_orders"] == [2, 5]
    assert q19_shells[1]["terminal_reply_component_edge_counts"] == [1, 5]
    assert q19_shells[1]["terminal_reply_graph_automorphism_order"] == 4
    assert q19_shells[1]["selected_target_conic_projective_stabilizer_order"] == 1
    q17_terminal_controls = q17_terminal_edge_controls()
    assert all(
        (
            row["legal_moves"],
            row["terminal_moves"],
            row["terminal_reply_edges"],
            row["moves_covered_by_terminal_reply_edges"],
        )
        == (32, 0, 8, 10)
        for row in q17_terminal_controls
    )
    assert all(
        row["terminal_reply_degree_histogram"]
        == [[0, 22], [1, 7], [2, 1], [3, 1], [4, 1]]
        and row["nontrivial_component_profiles"]
        == [
            {"vertices": 2, "edges": 1, "degree_sequence": [1, 1]},
            {
                "vertices": 8,
                "edges": 7,
                "degree_sequence": [1, 1, 1, 1, 1, 2, 3, 4],
            },
        ]
        for row in q17_terminal_controls
    )
    return {
        "schema": "c80-central-involution-rank-datum-v1",
        "source": str(Path(__file__).resolve().relative_to(ROOT)),
        "input_sha256": {
            str(path.relative_to(ROOT)): sha256(path)
            for path in sorted(set(INPUTS))
        },
        "candidate": {
            "datum": (
                "the central involution J=(iota_o iota_p)^(ord/2) "
                "of the even opponent-reply product"
            ),
            "rank": (
                "lexicographic overload plus half the selected-set "
                "symmetric difference under J"
            ),
            "proposed_update": (
                "answer a future opponent x by J(x), retaining J while "
                "strictly lowering overload"
            ),
        },
        "cases": cases,
        "q19_usable_exchange_orbits": q19_orbits,
        "q19_terminal_shells": q19_shells,
        "q17_terminal_edge_controls": q17_terminal_controls,
        "transport": transports,
        "cross_checks": {
            "central_matrix_squares_projectively_to_identity": True,
            "engine_reply_legality_equals_direct_determinant_cap_test": True,
            "datum_commutes_with_stabilizer_transport": True,
            "response_classification_commutes_with_transport": True,
        },
        "verdict": {
            "contains_all_five_repairs": True,
            "transport_naturality": "PASS",
            "opponent_complete_rank_update": "FAIL",
            "q17_usable_replies": "0/32 in each marked target",
            "q19_usable_replies": "4/51",
            "q19_usable_target_values": "2 P + 2 N",
            "q19_unoriented_exchange_targets": "one P + one N",
            "central_datum_rewrite_on_q19_P_target": "0/7 usable",
            "q19_P_target_direct_certificate": (
                "no terminal move; every move has a terminal reply"
            ),
            "q17_terminal_shell_uniform_lift": (
                "FAIL: 8 edges cover only 10/32 moves per repair target"
            ),
            "q19_shell_symmetry_source": (
                "abstract graph Aut order 4; projective target stabilizer order 1"
            ),
            "uniform_c80_candidate": False,
        },
    }


def write_certificate(path: Path) -> None:
    path.write_text(
        json.dumps(build_certificate(), indent=2, sort_keys=True) + "\n"
    )


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.check:
        with tempfile.TemporaryDirectory() as directory:
            candidate = Path(directory) / OUT.name
            write_certificate(candidate)
            if candidate.read_bytes() != OUT.read_bytes():
                raise SystemExit(f"certificate mismatch: {OUT}")
        print(f"PASS {OUT.relative_to(ROOT)}")
        return
    write_certificate(OUT)
    print(f"WROTE {OUT.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
