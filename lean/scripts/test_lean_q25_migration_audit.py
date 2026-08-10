#!/usr/bin/env python3
"""Tests for the read-only Q25 migration inventory audit."""

from __future__ import annotations

import shutil
import subprocess
import sys
import tempfile
import tomllib
import unittest
from pathlib import Path


SCRIPT = Path(__file__).with_name("lean-q25-migration-audit.py")
CONFIG = Path(__file__).parents[1] / "trust/certificate-migrations/q25.toml"


class Q25MigrationAuditTests(unittest.TestCase):
    def fixture(self, directory: str) -> tuple[Path, Path]:
        root = Path(directory)
        config = root / "q25.toml"
        shutil.copyfile(CONFIG, config)
        with config.open("rb") as handle:
            document = tomllib.load(handle)
        for entry in document["legacy_import"]:
            importer = root / entry["importer"]
            importer.parent.mkdir(parents=True, exist_ok=True)
            with importer.open("a", encoding="utf-8") as handle:
                handle.write(f'import {entry["module"]}\n')
        for generator in document["generators"]:
            path = root / generator
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text("# tracked generator\n", encoding="utf-8")
        subprocess.run(["git", "init", "-q", str(root)], check=True)
        subprocess.run(
            ["git", "-C", str(root), "add", "--", *document["generators"]],
            check=True,
        )
        return root, config

    def run_audit(self, root: Path, config: Path) -> subprocess.CompletedProcess[str]:
        return subprocess.run(
            [sys.executable, str(SCRIPT), "--root", str(root), "--config", str(config)],
            text=True,
            capture_output=True,
            check=False,
        )

    def test_pending_inventory_reports_facts_and_passes(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root, config = self.fixture(directory)
            result = self.run_audit(root, config)
            self.assertEqual(result.returncode, 0, result.stdout)
            self.assertIn("FACT status=pending modules=9531", result.stdout)
            self.assertIn("legacy_imports=10 nucleus_used=false", result.stdout)

    def test_family_total_drift_fails(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root, config = self.fixture(directory)
            text = config.read_text(encoding="utf-8")
            config.write_text(text.replace("count = 1942", "count = 1941", 1), encoding="utf-8")
            result = self.run_audit(root, config)
            self.assertEqual(result.returncode, 1)
            self.assertIn("family counts total 9530", result.stdout)

    def test_missing_legacy_import_fails(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root, config = self.fixture(directory)
            importer = root / "lean/RelativeConicArcs/QuadraticLineCounting.lean"
            importer.write_text("import Mathlib\n", encoding="utf-8")
            result = self.run_audit(root, config)
            self.assertEqual(result.returncode, 1)
            self.assertIn("legacy import is missing: import RelativeConicArcs.Nucleus", result.stdout)

    def test_untracked_generator_fails(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root, config = self.fixture(directory)
            generator = "notes/2026-07-15-c151-mask-generator.py"
            subprocess.run(["git", "-C", str(root), "rm", "--cached", "-q", generator], check=True)
            result = self.run_audit(root, config)
            self.assertEqual(result.returncode, 1)
            self.assertIn(f"generator is not tracked: {generator}", result.stdout)

    def test_target_namespace_collision_fails(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root, config = self.fixture(directory)
            collision = root / "lean/Unexpected.lean"
            collision.write_text(
                "namespace TavisRuddFiniteGeom.Certificates.Q25\nend TavisRuddFiniteGeom.Certificates.Q25\n",
                encoding="utf-8",
            )
            result = self.run_audit(root, config)
            self.assertEqual(result.returncode, 1)
            self.assertIn("target namespace collision: lean/Unexpected.lean", result.stdout)


if __name__ == "__main__":
    unittest.main()
