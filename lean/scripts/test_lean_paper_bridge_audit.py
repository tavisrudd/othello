#!/usr/bin/env python3
"""Tests for the cheap paper-bridge boundary audit."""

from __future__ import annotations

import hashlib
import importlib.util
import json
import subprocess
import tempfile
import unittest
from pathlib import Path


SCRIPT = Path(__file__).with_name("lean-paper-bridge-audit.py")
SPEC = importlib.util.spec_from_file_location("lean_paper_bridge_audit", SCRIPT)
assert SPEC and SPEC.loader
MODULE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(MODULE)


class PaperBridgeAuditTests(unittest.TestCase):
    def git_repo(self, root: Path, files: dict[str, str]) -> str:
        root.mkdir(parents=True)
        subprocess.run(["git", "init", "-q", str(root)], check=True)
        for relative, content in files.items():
            path = root / relative
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(content, encoding="utf-8")
        subprocess.run(["git", "-C", str(root), "add", "."], check=True)
        subprocess.run(
            [
                "git", "-C", str(root), "-c", "user.name=Test",
                "-c", "user.email=test@example.invalid", "-c", "commit.gpgsign=false",
                "commit", "-qm", "fixture",
            ],
            check=True,
        )
        return subprocess.run(
            ["git", "-C", str(root), "rev-parse", "HEAD"],
            check=True,
            text=True,
            capture_output=True,
        ).stdout.strip()

    def fixture(self, directory: str) -> tuple[dict, Path, Path, Path]:
        root = Path(directory)
        source_root = root / "source"
        libraries = root / "libraries"
        cache = root / "cache"
        source = source_root / "bridge/Compatibility.lean"
        source.parent.mkdir(parents=True)
        source.write_text(
            "import Human.Model\nimport Cert.Certificate\n"
            "namespace Paper.Compatibility\nend Paper.Compatibility\n",
            encoding="utf-8",
        )
        audit_source = source_root / "bridge/Verification/AxiomAudit.lean"
        audit_source.parent.mkdir(parents=True)
        audit_source.write_text(
            "import Human.Gate\nimport Cert.AxiomAudit\n"
            "import Paper.Compatibility\n",
            encoding="utf-8",
        )
        finitegeom_commit = self.git_repo(
            libraries / "finitegeom",
            {"lakefile.toml": 'name = "finitegeom"\n'},
        )
        certificate_commit = self.git_repo(
            libraries / "certs",
            {"lakefile.toml": 'name = "certs"\n'},
        )
        cache.mkdir()
        archive = cache / "certs.tgz"
        archive.write_bytes(b"compiled certificate")
        export_source_commit = "e" * 40
        bridge_commit = self.git_repo(
            libraries / "paper-bridge",
            {
                "lakefile.toml": (
                    'name = "paper-bridge"\n'
                    '[[require]]\nname = "finitegeom"\npath = "../finitegeom"\n'
                    '[[require]]\nname = "certs"\npath = "../certs"\n'
                ),
                "MANIFEST.json": json.dumps(
                    {
                        "source_commit": export_source_commit,
                        "roots": ["Paper.Verification.AxiomAudit"],
                        "sources": [
                            {"path": "Paper/Compatibility.lean"},
                            {"path": "Paper/Verification/AxiomAudit.lean"},
                        ],
                    }
                ),
                "README.md": "# Reviewer package\n",
            },
        )
        bridge = {
            "name": "paper",
            "repository": "paper-bridge",
            "bridge_commit": bridge_commit,
            "export_source_commit": export_source_commit,
            "source": "bridge/Compatibility.lean",
            "audit_source": "bridge/Verification/AxiomAudit.lean",
            "audit_module": "Paper.Verification.AxiomAudit",
            "module": "Paper.Compatibility",
            "finitegeom_commit": finitegeom_commit,
            "finitegeom_import": "Human.Model",
            "finitegeom_gate": "Human.Gate",
            "certificate_package": "certs",
            "certificate_commit": certificate_commit,
            "certificate_import": "Cert.Certificate",
            "certificate_audit_module": "Cert.AxiomAudit",
            "cache_archive": "certs.tgz",
            "cache_sha256": hashlib.sha256(archive.read_bytes()).hexdigest(),
            "forbid_source_fallback": True,
        }
        return bridge, source_root, libraries, cache

    def test_exact_bridge_passes(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            bridge, source, libraries, cache = self.fixture(directory)
            self.assertEqual(MODULE.audit_bridge(bridge, source, libraries, cache), [])

    def test_reverse_dependency_fails(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            bridge, source, libraries, cache = self.fixture(directory)
            lakefile = libraries / "finitegeom/lakefile.toml"
            lakefile.write_text(
                'name = "finitegeom"\n[[require]]\nname = "certs"\npath = "../certs"\n',
                encoding="utf-8",
            )
            problems = MODULE.audit_bridge(bridge, source, libraries, cache)
            self.assertTrue(any("finitegeom directly depends" in p for p in problems))

    def test_import_drift_fails(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            bridge, source, libraries, cache = self.fixture(directory)
            path = source / bridge["source"]
            path.write_text("import Cert.Certificate\n", encoding="utf-8")
            problems = MODULE.audit_bridge(bridge, source, libraries, cache)
            self.assertTrue(any("imports are" in p for p in problems))


if __name__ == "__main__":
    unittest.main()
