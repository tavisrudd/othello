#!/usr/bin/env python3
"""Tests for the package source audit's reverse direction and payload seal.

The forward direction iterates what a package has, so it cannot see what a package
lacks; these tests cover the two passes that can — the authority files inside an
owned family that the package does not seal, and the payload files the manifest does
not seal.  Both depend on mapping a module prefix into an authority path, which
differs per package layout and fails silently when it is wrong: an unanchored prefix
matches nothing and reports a complete package.
"""

from __future__ import annotations

import hashlib
import importlib.util
import json
import subprocess
import tempfile
import unittest
from pathlib import Path


SCRIPT = Path(__file__).with_name("lean-package-source-audit.py")
_spec = importlib.util.spec_from_file_location("package_source_audit", SCRIPT)
sourceaudit = importlib.util.module_from_spec(_spec)
assert _spec.loader is not None
_spec.loader.exec_module(sourceaudit)


CONFIG = """schema_version = 1
[[package]]
name = "certs"
repository = "https://example.invalid/certs"
commit = "0000000000000000000000000000000000000000"
manifest_sha256 = "0000000000000000000000000000000000000000000000000000000000000000"
gate = "Example.Gate"
terminal = "Example.result"
owned_module_prefixes = ["Example.Generated"]
forbidden_artifact_basenames = []
"""


class SupportSealTests(unittest.TestCase):
    def package(self, directory: str, manifest: dict, files: dict[str, str]) -> Path:
        root = Path(directory)
        for relative, text in files.items():
            path = root / relative
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(text, encoding="utf-8")
        (root / "MANIFEST.json").write_text(json.dumps(manifest), encoding="utf-8")
        return root

    @staticmethod
    def entry(path: str, text: str) -> dict:
        return {
            "path": path,
            "bytes": len(text),
            "sha256": hashlib.sha256(text.encode()).hexdigest(),
        }

    def test_legacy_and_current_seal_shapes_are_read_alike(self) -> None:
        """`generator`, `verification_artifacts` and `support_files` are one list."""
        manifest = {
            "generator": self.entry("scripts/make.py", "a"),
            "verification_artifacts": [self.entry("evidence/gate.log", "b")],
            "support_files": [self.entry("artifacts/data.csv", "c")],
        }
        self.assertEqual(
            sorted(sourceaudit.support_entries(manifest)),
            ["artifacts/data.csv", "evidence/gate.log", "scripts/make.py"],
        )

    def test_unsealed_payload_is_reported(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            manifest = {"support_files": [self.entry("scripts/make.py", "a")]}
            root = self.package(
                directory,
                manifest,
                {"scripts/make.py": "a", "evidence/gate.log": "unsealed", "README.md": "not payload"},
            )
            unsealed, drifted = sourceaudit.payload_audit(root, manifest)
            self.assertEqual(unsealed, ["evidence/gate.log"])
            self.assertEqual(drifted, [])

    def test_the_sealing_program_is_not_payload(self) -> None:
        """It writes the seal; requiring the seal to cover it is circular bookkeeping."""
        with tempfile.TemporaryDirectory() as directory:
            manifest = {"support_files": [self.entry("scripts/make.py", "a")]}
            root = self.package(
                directory,
                manifest,
                {"scripts/make.py": "a", "scripts/seal_manifest.py": "seals"},
            )
            unsealed, drifted = sourceaudit.payload_audit(root, manifest)
            self.assertEqual(unsealed, [])
            self.assertEqual(drifted, [])

    def test_edited_payload_is_reported_as_drift(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            manifest = {"support_files": [self.entry("scripts/make.py", "a")]}
            root = self.package(directory, manifest, {"scripts/make.py": "edited"})
            unsealed, drifted = sourceaudit.payload_audit(root, manifest)
            self.assertEqual(unsealed, [])
            self.assertEqual(len(drifted), 1)
            self.assertIn("differ from the seal", drifted[0])

    def test_sealed_payload_absent_from_the_package_is_reported(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            manifest = {"support_files": [self.entry("scripts/make.py", "a")]}
            root = self.package(directory, manifest, {})
            _, drifted = sourceaudit.payload_audit(root, manifest)
            self.assertEqual(len(drifted), 1)
            self.assertIn("absent from the package", drifted[0])


class ReverseDirectionTests(unittest.TestCase):
    def authority(self, directory: str, files: dict[str, str]) -> tuple[Path, str]:
        root = Path(directory)
        subprocess.run(["git", "init", "-q"], cwd=root, check=True)
        for relative, text in files.items():
            path = root / relative
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(text, encoding="utf-8")
        subprocess.run(["git", "add", "-A"], cwd=root, check=True, capture_output=True)
        subprocess.run(
            [
                "git", "-c", "user.email=fixture@example.invalid", "-c", "user.name=fixture",
                "-c", "commit.gpgsign=false", "commit", "--no-gpg-sign", "-qm", "fixture",
            ],
            cwd=root,
            check=True,
            capture_output=True,
        )
        head = subprocess.run(
            ["git", "rev-parse", "HEAD"], cwd=root, check=True, text=True, capture_output=True
        ).stdout.strip()
        return root, head

    def test_authority_file_the_package_lacks_is_reported(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root, head = self.authority(
                directory,
                {
                    "lean/Example/Generated/Row0.lean": "a",
                    "lean/Example/Generated/Row1.lean": "b",
                    "lean/Example/Semantic.lean": "not in the family",
                },
            )
            missing = sourceaudit.missing_from_package(
                root, head, ["lean/Example/Generated"], {"lean/Example/Generated/Row0.lean"}
            )
            self.assertEqual(missing, ["lean/Example/Generated/Row1.lean"])

    def test_a_complete_family_reports_nothing(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root, head = self.authority(directory, {"lean/Example/Generated/Row0.lean": "a"})
            self.assertEqual(
                sourceaudit.missing_from_package(
                    root, head, ["lean/Example/Generated"], {"lean/Example/Generated/Row0.lean"}
                ),
                [],
            )


class FamilyAnchoringTests(unittest.TestCase):
    def config(self, directory: str) -> Path:
        path = Path(directory) / "certificate-packages.toml"
        path.write_text(CONFIG, encoding="utf-8")
        return path

    def test_prefix_anchors_against_a_package_rooted_layout(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            self.assertEqual(
                sourceaudit.declared_family_prefixes(
                    "certs", self.config(directory), "lean/", ["Example/Generated/Row0.lean"]
                ),
                ["lean/Example/Generated"],
            )

    def test_prefix_anchors_against_a_source_directory_layout(self) -> None:
        """The package keeps modules under `lean/`, so the authority path is not doubled."""
        with tempfile.TemporaryDirectory() as directory:
            self.assertEqual(
                sourceaudit.declared_family_prefixes(
                    "certs", self.config(directory), "", ["lean/Example/Generated/Row0.lean"]
                ),
                ["lean/Example/Generated"],
            )

    def test_a_family_with_no_sealed_source_is_flagged_not_silently_skipped(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            self.assertEqual(
                sourceaudit.declared_family_prefixes(
                    "certs", self.config(directory), "lean/", ["Example/Other/Row0.lean"]
                ),
                ["UNANCHORED:Example/Generated"],
            )


if __name__ == "__main__":
    unittest.main()
