#!/usr/bin/env python3
"""C80: test the central-involution rank datum on the q17/q19 repairs."""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import sys
import tempfile
from itertools import combinations
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
