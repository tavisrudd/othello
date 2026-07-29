#!/usr/bin/env python3
"""C80: audit the claimed Type-I causal-charge mechanism at q=23."""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import os
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / "rust/scripts/c80_q23_replacement_lineage.py"
SOURCE_CERT = ROOT / "notes/2026-07-26-c80-q23-replacement-lineage.json"
OUT = ROOT / "notes/2026-07-28-c80-two-mechanism-falsifier.json"


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


LINEAGE = load_module(SOURCE, "c80_q23_two_mechanism_falsifier_base")


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def write_json(path: Path, value: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_name(f".{path.name}.{os.getpid()}.tmp")
    temporary.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")
    temporary.replace(path)


def selected_secant_blockers(
    state: frozenset[tuple[int, int]],
    causal_move: tuple[int, int],
    candidate: tuple[int, int],
) -> list[tuple[int, int]]:
    return sorted(
        point
        for point in state
        if LINEAGE.affine_collinear(point, causal_move, candidate)
    )


def build_certificate(path: Path) -> dict:
    deletion = LINEAGE.BASE.DeletionCensus()
    game = deletion.game
    index = lambda cell: LINEAGE.LIVE.cell_index(game, cell)

    state = frozenset(LINEAGE.T_CELLS)
    causal = LINEAGE.OPPONENT
    new_defect = LINEAGE.REPLACEMENT
    certificate_reply = LINEAGE.OLD_BOUNDARY_REPLY
    retained_endpoint = LINEAGE.RETAINED
    killed_endpoint = LINEAGE.KILLED_BOUNDARY_MATE

    reference = LINEAGE.ReferenceGame()
    before_certificate = state | {new_defect}
    boundary_state = before_certificate | {certificate_reply}
    after_causal = state | {causal}
    after_causal_defect = after_causal | {new_defect}

    old_boundary_rows = reference.boundary_replies(state, new_defect)
    assert old_boundary_rows == [
        {
            "reply": list(certificate_reply),
            "kind": "two_nonconflicting_moves",
            "remaining_legal": [
                list(retained_endpoint), list(killed_endpoint)
            ],
        }
    ]

    assert reference.legal_after(state, causal)
    assert reference.legal_after(after_causal, new_defect)
    assert reference.legal_after(before_certificate, certificate_reply)
    assert not reference.legal_after(after_causal_defect, certificate_reply)
    assert not reference.legal_after(boundary_state, causal)

    compatibility = {}
    for name, candidate in (
        ("certificate_reply", certificate_reply),
        ("retained_endpoint", retained_endpoint),
        ("killed_endpoint", killed_endpoint),
    ):
        blockers = selected_secant_blockers(state | {new_defect}, causal, candidate)
        compatible = reference.legal_after(
            state | {new_defect, candidate}, causal
        )
        compatibility[name] = {
            "point": list(candidate),
            "compatible_with_causal_move": compatible,
            "selected_secant_blockers": [list(point) for point in blockers],
        }

    assert compatibility["certificate_reply"] == {
        "point": list(certificate_reply),
        "compatible_with_causal_move": False,
        "selected_secant_blockers": [[8, 4]],
    }
    assert compatibility["retained_endpoint"] == {
        "point": list(retained_endpoint),
        "compatible_with_causal_move": True,
        "selected_secant_blockers": [],
    }
    assert compatibility["killed_endpoint"] == {
        "point": list(killed_endpoint),
        "compatible_with_causal_move": False,
        "selected_secant_blockers": [[4, 6]],
    }

    mask = deletion.mask(LINEAGE.T_CELLS)
    causal_mask = mask | (1 << index(causal))
    causal_defect_mask = causal_mask | (1 << index(new_defect))
    primary_legal = {
        game.cell_tuple(point)
        for point in LINEAGE.GEOMETRY.bits(game.legal_mask(causal_defect_mask))
    }
    reference_legal = set(reference.legal(after_causal_defect))
    assert primary_legal == reference_legal
    assert certificate_reply not in primary_legal
    assert killed_endpoint not in primary_legal
    assert retained_endpoint in primary_legal

    old_defects = {
        game.cell_tuple(point) for point in deletion.defects(mask)
    }
    half_defects = {
        game.cell_tuple(point) for point in deletion.defects(causal_mask)
    }
    assert causal in old_defects
    assert half_defects - old_defects == {new_defect}

    certificate = {
        "schema": "c80-q23-two-mechanism-falsifier-v1",
        "source": str(Path(__file__).resolve().relative_to(ROOT)),
        "input_sha256": {
            str(SOURCE.relative_to(ROOT)): sha256(SOURCE),
            str(SOURCE_CERT.relative_to(ROOT)): sha256(SOURCE_CERT),
        },
        "domain": {
            "q": LINEAGE.Q,
            "marked_type": "reported Type I / endpoint degradation",
            "state": [list(point) for point in LINEAGE.T_CELLS],
            "causal_opponent": list(causal),
            "new_defect": list(new_defect),
        },
        "former_unique_B_small_certificate": old_boundary_rows[0],
        "causal_compatibility": compatibility,
        "independent_replay": {
            "primary_and_reference_legal_loci_agree": True,
            "certificate_reply_legal_before_causal_move": True,
            "certificate_reply_legal_after_causal_move": False,
            "killed_endpoint_legal_after_causal_move": False,
            "retained_endpoint_legal_after_causal_move": True,
            "causal_move_is_old_defect": True,
            "new_defects_created_by_causal_move": [list(new_defect)],
        },
        "verdict": {
            "reported_endpoint_only_mechanism": False,
            "reported_certificate_reply_only_mechanism": False,
            "observed_failure_pattern": (
                "simultaneous certificate-reply and boundary-endpoint deletion"
            ),
            "injective_ancestral_charge_on_this_edge": True,
            "uniform_two-mechanism_update": False,
        },
    }
    write_json(path, certificate)
    return certificate


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()

    if args.check:
        if not OUT.exists():
            raise SystemExit(f"missing certificate: {OUT}")
        with tempfile.TemporaryDirectory() as directory:
            candidate = Path(directory) / OUT.name
            build_certificate(candidate)
            if candidate.read_bytes() != OUT.read_bytes():
                raise SystemExit(f"certificate mismatch: {OUT}")
        print("PASS")
        return

    certificate = build_certificate(OUT)
    print(
        json.dumps(
            {
                "status": "PASS",
                "q": certificate["domain"]["q"],
                "observed_failure_pattern": certificate["verdict"][
                    "observed_failure_pattern"
                ],
            },
            sort_keys=True,
        )
    )


if __name__ == "__main__":
    main()
