#!/usr/bin/env python3
"""C80: audit the intrinsic certificate-carrier nonpacking condition."""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import os
import sys
import tempfile
from functools import lru_cache
from itertools import combinations
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
LINEAGE_SOURCE = ROOT / "rust/scripts/c80_q23_replacement_lineage.py"
KERNEL_SOURCE = ROOT / "rust/scripts/c80_strict_overload_kernel.py"
TYPE_II_CERT = (
    ROOT / "notes/2026-07-26-c80-q23-first-new-replacement-orbit.json"
)
TYPE_III_CERT = (
    ROOT / "notes/2026-07-26-c80-q23-next-marked-replacement-orbit.json"
)
EXHAUSTION_CERT = (
    ROOT / "notes/2026-07-28-c80-q23-after-three-replacement-orbits.json"
)
OUT = ROOT / "notes/2026-07-29-c80-causal-nonpacking.json"


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


LINEAGE = load_module(LINEAGE_SOURCE, "c80_causal_nonpacking_lineage")
KERNEL = load_module(KERNEL_SOURCE, "c80_causal_nonpacking_kernel")


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def write_json(path: Path, value: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_name(f".{path.name}.{os.getpid()}.tmp")
    temporary.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")
    temporary.replace(path)


def load_representatives() -> list[dict]:
    type_ii = json.loads(TYPE_II_CERT.read_text())["first_new_orbit"]
    type_iii = json.loads(TYPE_III_CERT.read_text())["next_new_orbit"]
    return [
        {
            "name": "type_i",
            "state": [list(cell) for cell in LINEAGE.T_CELLS],
            "causal_half_move": list(LINEAGE.OPPONENT),
            "expected_new_defects": [list(LINEAGE.REPLACEMENT)],
        },
        {
            "name": "type_ii",
            "state": type_ii["target_cells"] + [type_ii["opponent"]],
            "causal_half_move": type_ii["reply"],
            "expected_new_defects": type_ii["created_by_reply"],
        },
        {
            "name": "type_iii",
            "state": type_iii["target_cells"] + [type_iii["opponent"]],
            "causal_half_move": type_iii["reply"],
            "expected_new_defects": type_iii["created_by_reply"],
        },
    ]


def certificate_attack(
    game,
    state: frozenset[tuple[int, int]],
    causal: tuple[int, int],
    defect: tuple[int, int],
    certificate: dict,
) -> dict:
    reply = tuple(certificate["reply"])
    post = state | {causal, defect}
    if reply not in game.legal(post):
        affine_pivots = sorted(
            point
            for point in state | {defect}
            if LINEAGE.affine_collinear(point, causal, reply)
        )
        direction_pivots = []
        if causal[0] == reply[0]:
            direction_pivots.append("row_infinity")
        if causal[1] == reply[1]:
            direction_pivots.append("column_infinity")
        assert affine_pivots or direction_pivots
        return {
            "reply": list(reply),
            "mode": "certificate_reply_secant_deletion",
            "affine_pivots": [list(point) for point in affine_pivots],
            "direction_pivots": direction_pivots,
        }

    assert causal in {
        tuple(point) for point in certificate["remaining_legal"]
    }
    assert game.small_boundary(post | {reply}) is None
    return {
        "reply": list(reply),
        "mode": "literal_boundary_endpoint_consumption",
        "affine_pivots": [],
        "direction_pivots": [],
    }


def audit_representative(game, representative: dict) -> dict:
    state = frozenset(tuple(cell) for cell in representative["state"])
    causal = tuple(representative["causal_half_move"])
    after = state | {causal}
    before_defects = set(game.defects(state))
    after_defects = set(game.defects(after))
    actual_new = sorted(after_defects - before_defects)
    expected_new = sorted(
        tuple(cell) for cell in representative["expected_new_defects"]
    )
    assert actual_new == expected_new
    assert causal in game.legal(state)

    fully_attacked = []
    for candidate in game.legal(after):
        if candidate in before_defects:
            continue
        certificates = game.boundary_replies(state, candidate)
        assert certificates
        surviving = []
        attacks = []
        for certificate in certificates:
            reply = tuple(certificate["reply"])
            target = after | {candidate, reply}
            if reply in game.legal(after | {candidate}):
                kind = game.small_boundary(target)
                if kind is not None:
                    surviving.append(
                        {"reply": list(reply), "kind": kind}
                    )
                    continue
            attacks.append(
                certificate_attack(
                    game, state, causal, candidate, certificate
                )
            )
        if not surviving:
            replacement_certificates = game.boundary_replies(
                after, candidate
            )
            fully_attacked.append(
                {
                    "candidate": list(candidate),
                    "old_certificate_count": len(certificates),
                    "attacks": attacks,
                    "replacement_certificates": replacement_certificates,
                    "is_new_defect": candidate in actual_new,
                }
            )

    fully_attacked_points = {
        tuple(row["candidate"]) for row in fully_attacked
    }
    assert set(actual_new) <= fully_attacked_points
    return {
        "name": representative["name"],
        "state": [list(point) for point in sorted(state)],
        "causal_half_move": list(causal),
        "old_defect_rank": len(before_defects),
        "after_half_move_defect_rank": len(after_defects),
        "new_defects": [list(point) for point in actual_new],
        "fully_attacked_certificate_fibres": fully_attacked,
        "full_carrier_packing_number": len(fully_attacked),
        "false_positive_carriers": sum(
            not row["is_new_defect"] for row in fully_attacked
        ),
        "uncompensated_carrier_count": sum(
            not row["replacement_certificates"]
            for row in fully_attacked
        ),
        "certificate_exchange_nonpacked": sum(
            not row["replacement_certificates"]
            for row in fully_attacked
        )
        <= 1,
        "nonpacked": len(fully_attacked) <= 1,
    }


class SmallBoundaryGame:
    def __init__(self, q: int):
        self.q = q
        self.kernel = KERNEL.StrictKernel(q)
        self.game = self.kernel.game

    @lru_cache(maxsize=None)
    def is_small_boundary(self, mask: int) -> bool:
        if self.kernel.omega(mask) != 0:
            return False
        legal = self.game.legal_mask(mask)
        if legal == 0:
            return True
        if legal.bit_count() != 2:
            return False
        left = legal & -legal
        right = legal ^ left
        return bool(
            self.game.legal_mask(mask | left) & right
        )

    @lru_cache(maxsize=None)
    def defects(self, mask: int) -> frozenset[int]:
        rows = set()
        for opponent in KERNEL.GEOMETRY.bits(
            self.game.legal_mask(mask)
        ):
            child = mask | (1 << opponent)
            if not any(
                self.is_small_boundary(child | (1 << reply))
                for reply in KERNEL.GEOMETRY.bits(
                    self.game.legal_mask(child)
                )
            ):
                rows.add(opponent)
        return frozenset(rows)

    def cells(self, mask: int) -> list[list[int]]:
        return [
            list(self.game.cell_tuple(point))
            for point in KERNEL.GEOMETRY.bits(mask)
        ]


def first_raw_branching(q: int, minimum_selected: int) -> dict:
    boundary = SmallBoundaryGame(q)
    game = boundary.game
    seen: set[int] = set()
    stack = [0]
    while stack:
        mask = stack.pop()
        if mask in seen:
            continue
        seen.add(mask)
        stack.extend(
            mask | (1 << point)
            for point in KERNEL.GEOMETRY.bits(game.legal_mask(mask))
        )

    stats = {
        "reachable_states": len(seen),
        "eligible_states": 0,
        "old_label_opponent_half_moves": 0,
        "old_label_reply_half_moves": 0,
    }
    for mask in sorted(seen, key=lambda value: (value.bit_count(), value)):
        if mask.bit_count() < minimum_selected:
            continue
        stats["eligible_states"] += 1
        old_defects = boundary.defects(mask)
        legal = list(KERNEL.GEOMETRY.bits(game.legal_mask(mask)))
        for opponent in legal:
            if opponent not in old_defects:
                continue
            stats["old_label_opponent_half_moves"] += 1
            child = mask | (1 << opponent)
            half_defects = boundary.defects(child)
            created = half_defects - old_defects
            if len(created) > 1:
                return {
                    "status": "FOUND_ONE_TO_MANY",
                    "search_counts": stats,
                    "q": q,
                    "kind": "opponent_half_move",
                    "state": boundary.cells(mask),
                    "causal_half_move": list(game.cell_tuple(opponent)),
                    "old_defect_rank": len(old_defects),
                    "next_defect_rank": len(half_defects),
                    "new_defects": boundary.cells(
                        sum(1 << point for point in created)
                    ),
                }
            for reply in KERNEL.GEOMETRY.bits(game.legal_mask(child)):
                if reply not in old_defects:
                    continue
                stats["old_label_reply_half_moves"] += 1
                successor = child | (1 << reply)
                next_defects = boundary.defects(successor)
                created = next_defects - half_defects - old_defects
                if len(created) > 1:
                    return {
                        "status": "FOUND_ONE_TO_MANY",
                        "search_counts": stats,
                        "q": q,
                        "kind": "reply_half_move",
                        "state": boundary.cells(mask),
                        "opponent": list(game.cell_tuple(opponent)),
                        "causal_half_move": list(game.cell_tuple(reply)),
                        "old_defect_rank": len(old_defects),
                        "half_defect_rank": len(half_defects),
                        "next_defect_rank": len(next_defects),
                        "new_defects": boundary.cells(
                            sum(1 << point for point in created)
                        ),
                    }
    return {
        "status": "EXHAUSTED_NO_ONE_TO_MANY",
        "search_counts": stats,
        "q": q,
        "witness": None,
    }


class DirectSmallBoundaryGame:
    """Independent affine-determinant implementation for small orders."""

    def __init__(self, q: int):
        self.q = q
        self.board = tuple(
            (x, y) for x in range(q) for y in range(q)
        )

    def collinear(
        self,
        left: tuple[int, int],
        middle: tuple[int, int],
        right: tuple[int, int],
    ) -> bool:
        return (
            (middle[0] - left[0]) * (right[1] - left[1])
            - (middle[1] - left[1]) * (right[0] - left[0])
        ) % self.q == 0

    def legal_after(
        self,
        state: frozenset[tuple[int, int]],
        point: tuple[int, int],
    ) -> bool:
        if point in state:
            return False
        if any(
            point[0] == selected[0] or point[1] == selected[1]
            for selected in state
        ):
            return False
        return not any(
            self.collinear(left, right, point)
            for left, right in combinations(state, 2)
        )

    @lru_cache(maxsize=None)
    def legal(
        self, state: frozenset[tuple[int, int]]
    ) -> tuple[tuple[int, int], ...]:
        return tuple(
            point for point in self.board
            if self.legal_after(state, point)
        )

    @lru_cache(maxsize=None)
    def omega(self, state: frozenset[tuple[int, int]]) -> int:
        legal = self.legal(state)
        total = 0
        for slope in range(1, self.q):
            selected_intercepts = {
                (y - slope * x) % self.q for x, y in state
            }
            legal_counts = [0] * self.q
            for x, y in legal:
                legal_counts[(y - slope * x) % self.q] += 1
            total += sum(
                max(0, count - 2)
                for intercept, count in enumerate(legal_counts)
                if intercept not in selected_intercepts
            )
        return total

    @lru_cache(maxsize=None)
    def is_small_boundary(
        self, state: frozenset[tuple[int, int]]
    ) -> bool:
        if self.omega(state) != 0:
            return False
        legal = self.legal(state)
        return not legal or (
            len(legal) == 2
            and self.legal_after(state | {legal[0]}, legal[1])
        )

    @lru_cache(maxsize=None)
    def defects(
        self, state: frozenset[tuple[int, int]]
    ) -> frozenset[tuple[int, int]]:
        rows = set()
        for opponent in self.legal(state):
            child = state | {opponent}
            if not any(
                self.is_small_boundary(child | {reply})
                for reply in self.legal(child)
            ):
                rows.add(opponent)
        return frozenset(rows)


def first_direct_branching(q: int, minimum_selected: int) -> dict:
    game = DirectSmallBoundaryGame(q)
    seen: set[frozenset[tuple[int, int]]] = set()
    stack = [frozenset()]
    while stack:
        state = stack.pop()
        if state in seen:
            continue
        seen.add(state)
        stack.extend(state | {point} for point in game.legal(state))

    stats = {
        "reachable_states": len(seen),
        "eligible_states": 0,
        "old_label_opponent_half_moves": 0,
        "old_label_reply_half_moves": 0,
    }
    for state in sorted(seen, key=lambda value: (len(value), sorted(value))):
        if len(state) < minimum_selected:
            continue
        stats["eligible_states"] += 1
        old_defects = game.defects(state)
        for opponent in game.legal(state):
            if opponent not in old_defects:
                continue
            stats["old_label_opponent_half_moves"] += 1
            child = state | {opponent}
            half_defects = game.defects(child)
            created = half_defects - old_defects
            if len(created) > 1:
                return {
                    "status": "FOUND_ONE_TO_MANY",
                    "search_counts": stats,
                    "q": q,
                    "kind": "opponent_half_move",
                    "state": [list(point) for point in sorted(state)],
                    "causal_half_move": list(opponent),
                    "old_defect_rank": len(old_defects),
                    "next_defect_rank": len(half_defects),
                    "new_defects": [
                        list(point) for point in sorted(created)
                    ],
                }
            for reply in game.legal(child):
                if reply not in old_defects:
                    continue
                stats["old_label_reply_half_moves"] += 1
                successor = child | {reply}
                next_defects = game.defects(successor)
                created = next_defects - half_defects - old_defects
                if len(created) > 1:
                    return {
                        "status": "FOUND_ONE_TO_MANY",
                        "search_counts": stats,
                        "q": q,
                        "kind": "reply_half_move",
                        "state": [
                            list(point) for point in sorted(state)
                        ],
                        "opponent": list(opponent),
                        "causal_half_move": list(reply),
                        "old_defect_rank": len(old_defects),
                        "half_defect_rank": len(half_defects),
                        "next_defect_rank": len(next_defects),
                        "new_defects": [
                            list(point) for point in sorted(created)
                        ],
                    }
    return {
        "status": "EXHAUSTED_NO_ONE_TO_MANY",
        "search_counts": stats,
        "q": q,
        "witness": None,
    }


def build_certificate(path: Path) -> dict:
    game = LINEAGE.ReferenceGame()
    representatives = [
        audit_representative(game, representative)
        for representative in load_representatives()
    ]
    type_ii_iii_same_local_update = (
        representatives[1]["state"] == representatives[2]["state"]
        and representatives[1]["causal_half_move"]
        == representatives[2]["causal_half_move"]
    )
    assert type_ii_iii_same_local_update
    all_nonpacked = all(row["nonpacked"] for row in representatives)
    exhaustion = json.loads(EXHAUSTION_CERT.read_text())
    assert exhaustion["status"] == "EXHAUSTED_NO_NEW_ORBIT"
    assert exhaustion["domain"]["known_marked_orbit_sizes"]["union"] == 36_432
    raw_branching = [
        {
            "q": q,
            "minimum_selected": minimum_selected,
            "primary_search": first_raw_branching(q, minimum_selected),
            "independent_direct_search": first_direct_branching(
                q, minimum_selected
            ),
        }
        for q in (3, 5, 7)
        for minimum_selected in (0, 4)
    ]
    assert all(
        row["primary_search"] == row["independent_direct_search"]
        for row in raw_branching
    )
    certificate = {
        "schema": "c80-causal-nonpacking-v1",
        "source": str(Path(__file__).resolve().relative_to(ROOT)),
        "input_sha256": {
            str(LINEAGE_SOURCE.relative_to(ROOT)): sha256(LINEAGE_SOURCE),
            str(KERNEL_SOURCE.relative_to(ROOT)): sha256(KERNEL_SOURCE),
            str(TYPE_II_CERT.relative_to(ROOT)): sha256(TYPE_II_CERT),
            str(TYPE_III_CERT.relative_to(ROOT)): sha256(TYPE_III_CERT),
            str(EXHAUSTION_CERT.relative_to(ROOT)): sha256(EXHAUSTION_CERT),
        },
        "definition": {
            "full_certificate_attack": (
                "a causal half-move destroys every old B_small "
                "certificate of a compatible old nondefect"
            ),
            "nonpacked": (
                "at most one compatible old nondefect has its full "
                "certificate fibre attacked"
            ),
            "certificate_exchange_nonpacked": (
                "after allowing newly emergent B_small certificates, "
                "at most one fully attacked old fibre remains "
                "uncompensated"
            ),
        },
        "domain": {
            "q": 23,
            "representatives": [
                "one representative of each of the three complete "
                "marked replacement PGL2 orbits"
            ],
            "orbit_union_size": 36_432,
            "exhaustion_scope": (
                "necessary F_d replacement witnesses in the complete "
                "canonical q23 P-control corpus"
            ),
        },
        "representatives": representatives,
        "raw_exchange_probe": {
            "domain": (
                "every reachable q3, q5, and q7 residual state after "
                "the fixed opening pair; lexicographic old-defect "
                "half-moves, both unrestricted and from residual "
                "selected size at least four"
            ),
            "orders": raw_branching,
            "primary_and_direct_searches_agree": True,
        },
        "conclusion": {
            "all_three_representatives_nonpacked": all_nonpacked,
            "all_three_representatives_certificate_exchange_nonpacked": all(
                row["certificate_exchange_nonpacked"]
                for row in representatives
            ),
            "type_ii_and_type_iii_same_sequential_local_update": (
                type_ii_iii_same_local_update
            ),
            "no_one_to_many_replacement_in_certified_q23_corpus": True,
            "uniform_odd_q_nonpacking": False,
        },
    }
    write_json(path, certificate)
    return certificate


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.check:
        if not OUT.is_file():
            raise SystemExit(f"missing certificate: {OUT}")
        with tempfile.TemporaryDirectory() as directory:
            candidate = Path(directory) / OUT.name
            build_certificate(candidate)
            if candidate.read_bytes() != OUT.read_bytes():
                raise SystemExit(f"certificate mismatch: {OUT}")
        print(f"PASS {OUT.relative_to(ROOT)}")
        return 0

    certificate = build_certificate(OUT)
    print(
        json.dumps(
            {
                "output": str(OUT.relative_to(ROOT)),
                "sha256": sha256(OUT),
                "packing_numbers": {
                    row["name"]: row["full_carrier_packing_number"]
                    for row in certificate["representatives"]
                },
            },
            sort_keys=True,
        )
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
