#!/usr/bin/env python3
"""Tests for separated formal-companion dependency records."""

from __future__ import annotations

import importlib.util
import json
import tempfile
import unittest
from pathlib import Path


SCRIPT = Path(__file__).with_name("formal_companion.py")
SPEC = importlib.util.spec_from_file_location("formal_companion", SCRIPT)
assert SPEC and SPEC.loader
MODULE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(MODULE)


class FormalCompanionV3Tests(unittest.TestCase):
    def test_exported_validators_match_shared_source(self) -> None:
        repository = SCRIPT.parents[2]
        expected = SCRIPT.read_bytes()
        for relative in (
            "papers/clebsch-rigidity/verification/formal_companion.py",
            "papers/clebsch-passages/verification/formal_companion.py",
        ):
            self.assertEqual((repository / relative).read_bytes(), expected)

    def pin(self) -> dict:
        commit = "a" * 40
        return {
            "schema": "formal-companion-v3",
            "concept_doi": "10.5281/zenodo.1",
            "relationship": "A checked bridge identifies the two statement models.",
            "artifacts": [
                {
                    "role": "shared",
                    "kind": "shared-library",
                    "repository": "https://example.invalid/shared",
                    "commit": commit,
                },
                {
                    "role": "cert",
                    "kind": "certificate",
                    "repository": "https://example.invalid/cert",
                    "commit": commit,
                },
                {
                    "role": "paper-bridge",
                    "kind": "bridge",
                    "repository": "https://example.invalid/bridge",
                    "commit": commit,
                    "depends_on": ["shared", "cert"],
                },
            ],
        }

    def load(self, pin: dict) -> dict:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "FORMAL_COMPANION.json").write_text(
                json.dumps(pin), encoding="utf-8"
            )
            return MODULE.load(root)

    def test_separated_bridge_passes(self) -> None:
        self.assertEqual(self.load(self.pin())["schema"], "formal-companion-v3")

    def test_certificate_reverse_dependency_fails(self) -> None:
        pin = self.pin()
        pin["artifacts"][1]["depends_on"] = ["shared"]
        with self.assertRaisesRegex(MODULE.CompanionError, "certificate.*dependency-free"):
            self.load(pin)

    def test_bridge_requires_both_upstream_kinds(self) -> None:
        pin = self.pin()
        pin["artifacts"][2]["depends_on"] = ["cert"]
        with self.assertRaisesRegex(MODULE.CompanionError, "must depend on one"):
            self.load(pin)


if __name__ == "__main__":
    unittest.main()
