#!/usr/bin/env python3
"""Tests for the generated external trust-spine projections."""

from __future__ import annotations

import importlib.util
import json
import subprocess
import sys
import tempfile
import tomllib
import unittest
from pathlib import Path


SCRIPT = Path(__file__).with_name("external-trust-exports.py")
LEAN_ROOT = SCRIPT.parents[1]


def load_exporter():
    spec = importlib.util.spec_from_file_location("external_trust_exports_tested", SCRIPT)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


EXPORTER = load_exporter()


class ExternalTrustExportsTests(unittest.TestCase):
    def run_cli(self, out: Path, command: str) -> subprocess.CompletedProcess[str]:
        return subprocess.run(
            [sys.executable, str(SCRIPT), "--lean-root", str(LEAN_ROOT), "--out", str(out), command],
            text=True,
            capture_output=True,
            check=False,
        )

    def test_yaml_renderer_is_deterministic_and_uses_yaml_structure(self) -> None:
        value = {"version": "v0.3", "items": [{"name": "α", "axioms": ["propext"]}]}
        expected = (
            'version: "v0.3"\n'
            "items:\n"
            '  - name: "α"\n'
            "    axioms:\n"
            '      - "propext"\n'
        )
        self.assertEqual(EXPORTER.yaml_text(value), expected)
        self.assertEqual(EXPORTER.yaml_text(value), EXPORTER.yaml_text(value))

    def test_theorem_list_is_exactly_the_declared_terminal_set(self) -> None:
        model = EXPORTER.build_model(LEAN_ROOT)
        with (LEAN_ROOT / "trust" / "portfolio.toml").open("rb") as handle:
            portfolio = tomllib.load(handle)
        declared: set[tuple[str, str]] = set()
        for entry in portfolio["area"]:
            with (LEAN_ROOT / "trust" / entry["spine"]).open("rb") as handle:
                area = tomllib.load(handle)
            declared.update(
                (entry["name"], terminal["declaration"])
                for terminal in area.get("terminal", [])
            )
        exported = {
            (row["trust_area"], row["declaration"])
            for row in model.theorems["theorems"]
        }
        self.assertEqual(exported, declared)
        self.assertEqual(len(exported), len(model.theorems["theorems"]))
        for row in model.theorems["theorems"]:
            self.assertEqual(
                row["id"],
                f"trust-spine:{row['trust_area']}:terminal:{row['declaration']}",
            )
            self.assertIn(row["axiom_status"], {"declared-unextracted", "extracted-and-matched"})

    def test_generate_is_byte_identical_and_check_rejects_an_edit(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            out = Path(directory)
            first = self.run_cli(out, "generate")
            self.assertEqual(first.returncode, 0, first.stderr)
            snapshot = {name: (out / name).read_bytes() for name in EXPORTER.OUTPUTS}
            second = self.run_cli(out, "generate")
            self.assertEqual(second.returncode, 0, second.stderr)
            self.assertIn("no external trust export changed", second.stdout)
            self.assertEqual(snapshot, {name: (out / name).read_bytes() for name in EXPORTER.OUTPUTS})
            current = self.run_cli(out, "check")
            self.assertEqual(current.returncode, 0, current.stdout + current.stderr)

            theorem_path = out / "headline-theorems.json"
            document = json.loads(theorem_path.read_text(encoding="utf-8"))
            document["theorems"][0]["expected_axioms"] = []
            theorem_path.write_text(json.dumps(document), encoding="utf-8")
            stale = self.run_cli(out, "check")
            self.assertEqual(stale.returncode, EXPORTER.EXIT_STALE)
            self.assertIn("stale-or-edited", stale.stdout)


if __name__ == "__main__":
    unittest.main()
