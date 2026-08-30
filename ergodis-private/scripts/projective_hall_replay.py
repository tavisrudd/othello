#!/usr/bin/env python3
"""Code-disjoint replay of the bounded C80 projective Hall obstruction."""

from __future__ import annotations

import hashlib
import importlib.util
import json
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / "rust/scripts/c80_causal_nonpacking.py"
CERTIFICATE = ROOT / "notes/2026-08-30-c985-c80-projective-hall-deficit.json"


def load_source():
    spec = importlib.util.spec_from_file_location("c80_hall_replay_source", SOURCE)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {SOURCE}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


def main() -> None:
    certificate = json.loads(CERTIFICATE.read_text())
    assert certificate["source_sha256"] == hashlib.sha256(
        SOURCE.read_bytes()
    ).hexdigest()
    assert certificate["q"] == 11
    issue = certificate["first_issue"]
    source = load_source()
    boundary = source.SmallBoundaryGame(11)
    game = boundary.game
    by_cell = {game.cell_tuple(index): index for index in range(121)}

    def point_mask(points) -> int:
        value = 0
        for point in points:
            value |= 1 << by_cell[tuple(point)]
        return value

    def points(indices) -> list[tuple[int, int]]:
        return sorted(game.cell_tuple(index) for index in indices)

    state = point_mask(issue["state"])
    opponent = point_mask([issue["opponent"]])
    causal = point_mask([issue["causal"]])
    child = state | opponent
    successor = child | causal
    old = boundary.defects(state)
    half = boundary.defects(child)
    new = boundary.defects(successor)
    created = new - half - old
    consumed = old - new
    assert points(old) == [tuple(point) for point in issue["old_defects"]]
    assert points(created) == [tuple(point) for point in issue["created"]]
    assert points(consumed) == [tuple(point) for point in issue["consumed"]]
    assert [
        boundary.kernel.omega(state),
        boundary.kernel.omega(child),
        boundary.kernel.omega(successor),
    ] == issue["omega"]

    causal_point = tuple(issue["causal"])
    labels = points(consumed)

    def collinear(left, middle, right) -> bool:
        return (
            (middle[0] - left[0]) * (right[1] - left[1])
            - (middle[1] - left[1]) * (right[0] - left[0])
        ) % 11 == 0

    neighbourhoods = []
    for defect in points(created):
        before = child | (1 << by_cell[defect])
        after = successor | (1 << by_cell[defect])
        replies = [
            game.cell_tuple(reply)
            for reply in source.KERNEL.GEOMETRY.bits(
                game.legal_mask(before)
            )
            if boundary.is_small_boundary(before | (1 << reply))
        ]
        incident = set()
        for reply in replies:
            deleted = not bool(
                game.legal_mask(after) & (1 << by_cell[reply])
            )
            for index, label in enumerate(labels):
                if label == reply or (
                    reply != causal_point
                    and deleted
                    and collinear(causal_point, reply, label)
                ):
                    incident.add(index)
        neighbourhoods.append(sorted(incident))

    assert neighbourhoods == issue["neighbours"] == [[1], [1]]
    deficient_set = range(len(neighbourhoods))
    neighbour_union = {
        right for left in deficient_set for right in neighbourhoods[left]
    }
    assert len(neighbour_union) == 1 < len(neighbourhoods) == 2
    assert len(consumed) == len(created) == 2
    digest = hashlib.sha256(CERTIFICATE.read_bytes()).hexdigest()
    print(f"PASS {digest}")


if __name__ == "__main__":
    main()
