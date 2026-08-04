#!/usr/bin/env python3
"""Tests for the external certificate-package boundary."""

from __future__ import annotations

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


if __name__ == "__main__":
    unittest.main()
