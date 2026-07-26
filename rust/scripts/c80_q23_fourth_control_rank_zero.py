#!/usr/bin/env python3
"""C80: test R0/F_d equality on the fourth canonical q23 P control."""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / "rust/scripts/c80_q23_next_control_depth_two.py"
OUT = ROOT / "notes/2026-07-25-c80-q23-fourth-control-rank-zero.json"


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


BASE = load_module(SOURCE, "c80_q23_fourth_control_base")
PREVIOUS_REPLY = (5, 10)
HISTORY_REPLY = (5, 13)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def build_certificate() -> dict:
    canonical_p_replies = BASE.canonical_p_replies
    full_rows = canonical_p_replies()
    assert full_rows[2]["reply"] == PREVIOUS_REPLY
    assert full_rows[3]["reply"] == HISTORY_REPLY

    BASE.PREVIOUS_REPLY = PREVIOUS_REPLY
    BASE.HISTORY_REPLY = HISTORY_REPLY
    BASE.canonical_p_replies = lambda: canonical_p_replies()[2:]
    certificate = BASE.build_certificate()

    certificate["schema"] = "c80-q23-fourth-control-rank-zero-v1"
    certificate["source"] = str(
        Path(__file__).resolve().relative_to(ROOT)
    )
    certificate["input_sha256"][
        str(SOURCE.relative_to(ROOT))
    ] = sha256(SOURCE)
    certificate["control"]["canonical_choice"] = (
        "fourth P reply in C54 s4query canonical output order, "
        "immediately after the third control"
    )
    oracle = certificate["control"]["oracle"]
    oracle["canonical_p_reply_index_zero_based"] = 3
    oracle["canonical_p_replies"] = len(full_rows)

    verdict = certificate["verdict"]
    verdict["R0_opponent_complete_on_fourth_control"] = verdict.pop(
        "R0_opponent_complete_on_immediate_next_control"
    )
    return certificate


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
