#!/usr/bin/env python3
"""Tests for the external certificate-package boundary."""

from __future__ import annotations

import hashlib
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path


SCRIPT = Path(__file__).with_name("lean-certificate-boundary.py")


class CertificateBoundaryTests(unittest.TestCase):
    def make_repo(self, directory: str) -> Path:
        root = Path(directory)
        subprocess.run(["git", "init", "-q"], cwd=root, check=True)
        (root / "lean/trust").mkdir(parents=True)
        (root / "papers").mkdir()
        (root / "lean/trust/certificate-packages.toml").write_text(
            '''schema_version = 1
[[package]]
name = "certs"
repository = "https://example.invalid/certs"
commit = "0000000000000000000000000000000000000000"
manifest_sha256 = "0000000000000000000000000000000000000000000000000000000000000000"
gate = "Example.Gate"
terminal = "Example.result"
owned_module_prefixes = ["Example.Generated"]
forbidden_artifact_basenames = ["generator.cpp"]
''',
            encoding="utf-8",
        )
        return root

    def run_check(self, root: Path) -> subprocess.CompletedProcess[str]:
        return subprocess.run(
            [sys.executable, str(SCRIPT), "--repo-root", str(root)],
            text=True,
            capture_output=True,
            check=False,
        )

    def test_clean_semantic_api_passes(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = self.make_repo(directory)
            source = root / "lean/Example/API.lean"
            source.parent.mkdir(parents=True)
            source.write_text("def semanticAPI := True\n", encoding="utf-8")
            self.assertEqual(self.run_check(root).returncode, 0)

    def test_owned_module_import_and_generator_fail(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = self.make_repo(directory)
            source = root / "lean/Example/API.lean"
            source.parent.mkdir(parents=True)
            source.write_text("import Example.Generated.Leaf\n", encoding="utf-8")
            (root / "papers/generator.cpp").write_text("int main() {}\n", encoding="utf-8")
            result = self.run_check(root)
            self.assertEqual(result.returncode, 1)
            self.assertIn("imports Example.Generated.Leaf", result.stdout)
            self.assertIn("generator.cpp", result.stdout)

    def make_library(self, root: Path, libraries: Path, *, fact: str = "{}\n") -> Path:
        """An official checkout whose published trust fact the monorepo pins."""
        package = libraries / "certs"
        package.mkdir(parents=True)
        subprocess.run(["git", "init", "-q"], cwd=package, check=True)
        (package / "MANIFEST.json").write_text('{"sources": []}\n', encoding="utf-8")
        (package / "TRUST_FACT.json").write_text(fact, encoding="utf-8")
        subprocess.run(["git", "add", "-A"], cwd=package, check=True, capture_output=True)
        subprocess.run(
            [
                "git",
                "-c",
                "user.email=fixture@example.invalid",
                "-c",
                "user.name=fixture",
                "-c",
                "commit.gpgsign=false",
                "commit",
                "--no-gpg-sign",
                "-qm",
                "fixture",
            ],
            cwd=package,
            check=True,
            capture_output=True,
        )
        head = subprocess.run(
            ["git", "rev-parse", "HEAD"], cwd=package, check=True, text=True, capture_output=True
        ).stdout.strip()
        manifest_hash = hashlib.sha256((package / "MANIFEST.json").read_bytes()).hexdigest()
        config = root / "lean/trust/certificate-packages.toml"
        config.write_text(
            config.read_text(encoding="utf-8")
            .replace("0" * 64, manifest_hash)
            .replace("0" * 40, head)
            .replace(
                "owned_module_prefixes",
                'trust_fact = "external/certs.json"\nowned_module_prefixes',
            ),
            encoding="utf-8",
        )
        return package

    def run_library_check(self, root: Path, libraries: Path) -> subprocess.CompletedProcess[str]:
        return subprocess.run(
            [
                sys.executable,
                str(SCRIPT),
                "--repo-root",
                str(root),
                "--libraries-root",
                str(libraries),
                "--verify-official-libraries",
            ],
            text=True,
            capture_output=True,
            check=False,
        )

    def test_matching_pinned_trust_fact_passes(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = self.make_repo(directory)
            libraries = Path(directory) / "libraries"
            self.make_library(root, libraries, fact='{"package": "certs"}\n')
            pinned = root / "lean/trust/external/certs.json"
            pinned.parent.mkdir(parents=True)
            pinned.write_text('{"package": "certs"}\n', encoding="utf-8")
            self.assertEqual(self.run_library_check(root, libraries).returncode, 0)

    def test_pinned_trust_fact_diverging_from_the_package_fails(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = self.make_repo(directory)
            libraries = Path(directory) / "libraries"
            self.make_library(root, libraries, fact='{"package": "certs"}\n')
            pinned = root / "lean/trust/external/certs.json"
            pinned.parent.mkdir(parents=True)
            pinned.write_text('{"package": "certs", "gate": "edited"}\n', encoding="utf-8")
            result = self.run_library_check(root, libraries)
            self.assertEqual(result.returncode, 1)
            self.assertIn("differs from the package's published trust fact", result.stdout)

    def test_missing_pinned_copy_fails(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = self.make_repo(directory)
            libraries = Path(directory) / "libraries"
            self.make_library(root, libraries, fact='{"package": "certs"}\n')
            result = self.run_library_check(root, libraries)
            self.assertEqual(result.returncode, 1)
            self.assertIn("the pinned copy is missing", result.stdout)

    def test_package_publishing_no_trust_fact_fails(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = self.make_repo(directory)
            libraries = Path(directory) / "libraries"
            package = self.make_library(root, libraries, fact='{"package": "certs"}\n')
            (package / "TRUST_FACT.json").unlink()
            result = self.run_library_check(root, libraries)
            self.assertEqual(result.returncode, 1)
            self.assertIn("publishes no trust fact", result.stdout)


if __name__ == "__main__":
    unittest.main()
