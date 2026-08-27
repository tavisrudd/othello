#!/usr/bin/env python3
"""Independent quotient and Hankel replay for C973's pointed GF(32) certificate."""

from __future__ import annotations

import importlib.util
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
BASE_PATH = HERE / "c973-r11-gf16-pointed-quotient-replay.py"
CERTIFICATE = HERE / "c973-r11-gf32-pointed-quotient.json"
Q = 32
MODULUS = 0b100101

SPEC = importlib.util.spec_from_file_location("c973_gf16_replay", BASE_PATH)
assert SPEC is not None and SPEC.loader is not None
BASE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(BASE)
BASE.Q = Q
BASE.MODULUS = MODULUS


def main() -> None:
    data = json.loads(CERTIFICATE.read_text())
    assert data["schema"] == "c973-r11-gf32-pointed-quotient-v1"
    assert data["scope"] == "complete"
    assert data["projective_carrier_points"] == (Q**5 - 1) // (Q - 1)
    expected = BASE.replay_representatives(data["borel_generators"])
    recorded = [tuple(record["representative"]) for record in data["records"]]
    assert recorded == expected
    assert data["orbit_count"] == data["witness_orbits"] == len(recorded)
    assert data["unresolved_orbits"] == 0
    for representative, record in zip(recorded, data["records"]):
        assert record["status"] == "WITNESS"
        roots = record["support"]
        assert len(roots) == 9 and len(set(roots)) == 9
        assert all(0 <= root < Q for root in roots)
        assert BASE.is_locator(representative, roots)
    print(f"C973 independent GF(32) replay: PASS ({len(recorded)} pointed orbits)")


if __name__ == "__main__":
    main()
