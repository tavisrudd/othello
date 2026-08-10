#!/usr/bin/env python3
"""Tests for deterministic paper-bridge package materialization."""

from __future__ import annotations

import importlib.util
import subprocess
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
            "audit_source": "paper-bridges/sample/Verification/AxiomAudit.lean",
            "audit_module": "TavisRuddFiniteGeom.Papers.Sample.Verification.AxiomAudit",
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
        self.assertIn(
            'roots = ["TavisRuddFiniteGeom.Papers.Sample.Verification.AxiomAudit"]',
            text,
        )

    def test_reviewer_readme_has_one_safe_command(self) -> None:
        text = MODULE.readme(self.bridge())
        self.assertIn("nix run .#verify -- /path/to/sample.lake-pack.tar.gz", text)
        self.assertNotIn("authority", text.lower())
        self.assertNotIn("mirror", text.lower())
        self.assertIn("See `LICENSE`", text)

    def test_verifier_supports_explicit_unpublished_sources(self) -> None:
        text = MODULE.flake(self.bridge())
        self.assertIn("GIT_CONFIG_COUNT=2", text)
        self.assertIn("finitegeom_source", text)
        self.assertIn("certificate_source", text)

    def test_verifier_builds_only_mathlib_before_certificate_no_build(self) -> None:
        text = MODULE.flake(self.bridge())
        dependency = text.index("lake build Mathlib")
        certificate = text.index(
            "lake build --no-build TavisRuddFiniteGeom.Certificates.Sample"
        )
        self.assertLess(dependency, certificate)

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

    def test_write_files_materializes_exact_bytes(self) -> None:
        with tempfile.TemporaryDirectory(dir=Path.home()) as directory:
            root = Path(directory)
            MODULE.write_files(root, {"nested/file": b"exact\n"})
            self.assertEqual((root / "nested/file").read_bytes(), b"exact\n")
            with self.assertRaisesRegex(ValueError, "unsafe materialized path"):
                MODULE.write_files(root, {"../escape": b"bad\n"})

    def test_adoption_rejects_repository_path_escape(self) -> None:
        bridge = self.bridge()
        bridge["repository"] = "../escape"
        with tempfile.TemporaryDirectory(dir=Path.home()) as directory:
            with self.assertRaisesRegex(ValueError, "unsafe repository name"):
                MODULE.adopt("HEAD", bridge, {}, Path(directory))

    def test_adoption_creates_reproducible_clean_commits(self) -> None:
        commit = str(MODULE.git("rev-parse", "HEAD")).strip()
        bridge = self.bridge()
        files = {"README.md": b"reviewer package\n"}
        hashes = []
        for _ in range(2):
            with tempfile.TemporaryDirectory(dir=Path.home()) as directory:
                destination, adopted_commit = MODULE.adopt(
                    commit, bridge, files, Path(directory)
                )
                hashes.append(adopted_commit)
                status = subprocess.run(
                    ["git", "-C", str(destination), "status", "--short"],
                    check=True,
                    capture_output=True,
                    text=True,
                ).stdout
                self.assertEqual(status, "")
        self.assertEqual(hashes[0], hashes[1])

    def test_sync_adds_files_as_a_forward_commit(self) -> None:
        commit = str(MODULE.git("rev-parse", "HEAD")).strip()
        bridge = self.bridge()
        with tempfile.TemporaryDirectory(dir=Path.home()) as directory:
            root = Path(directory)
            destination, initial = MODULE.adopt(
                commit, bridge, {"README.md": b"first\n"}, root
            )
            bridge["bridge_commit"] = initial
            synced_destination, updated = MODULE.sync(
                commit,
                bridge,
                {"README.md": b"second\n", "AxiomAudit.lean": b"#print axioms x\n"},
                root,
            )
            self.assertEqual(synced_destination, destination)
            self.assertNotEqual(updated, initial)
            self.assertEqual((destination / "README.md").read_bytes(), b"second\n")
            self.assertEqual(
                subprocess.run(
                    ["git", "-C", str(destination), "status", "--short"],
                    check=True,
                    capture_output=True,
                    text=True,
                ).stdout,
                "",
            )


if __name__ == "__main__":
    unittest.main()
