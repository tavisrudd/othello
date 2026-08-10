#!/usr/bin/env python3
"""Tests for deterministic paper-bridge package materialization."""

from __future__ import annotations

import importlib.util
import tempfile
import unittest
from pathlib import Path


SCRIPT = Path(__file__).with_name("lean-paper-bridge-export.py")
SPEC = importlib.util.spec_from_file_location("lean_paper_bridge_export", SCRIPT)
assert SPEC and SPEC.loader
MODULE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(MODULE)


class PaperBridgeExportTests(unittest.TestCase):
    def bridge(self) -> dict:
        return {
            "name": "sample-paper",
            "repository": "finitegeom-sample-paper-bridge",
            "lean_library": "SamplePaperBridge",
            "source": "paper-bridges/sample/CertificateCompatibility.lean",
            "module": "TavisRuddFiniteGeom.Papers.Sample.CertificateCompatibility",
            "license_source": "papers/sample/LICENSE",
            "finitegeom_commit": "a" * 40,
            "certificate_package": "finitegeom-sample-certificates",
            "certificate_commit": "b" * 40,
            "certificate_gate": "TavisRuddFiniteGeom.Certificates.Sample",
            "cache_sha256": "c" * 64,
            "cache_archive": "sample.lake-pack.tar.gz",
        }

    def test_lakefile_has_only_two_project_dependencies(self) -> None:
        text = MODULE.lakefile(self.bridge())
        self.assertIn('name = "finitegeom"', text)
        self.assertIn('name = "finitegeom-sample-certificates"', text)
        self.assertEqual(text.count("[[require]]"), 2)

    def test_reviewer_readme_has_one_safe_command(self) -> None:
        text = MODULE.readme(self.bridge())
        self.assertIn("nix run .#verify -- /path/to/sample.lake-pack.tar.gz", text)
        self.assertNotIn("authority", text.lower())
        self.assertNotIn("mirror", text.lower())
        self.assertIn("See `LICENSE`", text)

    def test_materialization_carries_immutable_license(self) -> None:
        original_blob = MODULE.blob
        try:
            MODULE.blob = lambda commit, path: b"license\n" if path.endswith("LICENSE") else b"source\n"
            files = MODULE.materialized_files("d" * 40, self.bridge())
        finally:
            MODULE.blob = original_blob
        self.assertEqual(files["LICENSE"], b"license\n")
        self.assertEqual(files["flake.lock"], b"source\n")
        self.assertIn(b'"path": "LICENSE"', files["MANIFEST.json"])

    def test_tmpfs_and_existing_destinations_are_rejected(self) -> None:
        with self.assertRaisesRegex(ValueError, "disk-backed"):
            MODULE.destination_safe(Path("/tmp/paper-bridge"))
        with tempfile.TemporaryDirectory(dir=Path.home()) as directory:
            with self.assertRaisesRegex(ValueError, "already exists"):
                MODULE.destination_safe(Path(directory))


if __name__ == "__main__":
    unittest.main()
