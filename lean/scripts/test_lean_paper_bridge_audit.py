#!/usr/bin/env python3
"""Tests for the cheap paper-bridge boundary audit."""

from __future__ import annotations

import hashlib
import importlib.util
import json
import shutil
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
                        "roots": ["Paper.Compatibility"],
                        "sources": [{"path": "Paper/Compatibility.lean"}],
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
            "module": "Paper.Compatibility",
            "finitegeom_commit": finitegeom_commit,
            "finitegeom_import": "Human.Model",
            "certificate_package": "certs",
            "certificate_commit": certificate_commit,
            "certificate_import": "Cert.Certificate",
            "cache_archive": "certs.tgz",
            "cache_sha256": hashlib.sha256(archive.read_bytes()).hexdigest(),
            "certificate_olean_sha256": "a" * 64,
            "certificate_trace_sha256": "b" * 64,
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

    def test_pending_export_checks_boundary_without_requiring_checkout(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            bridge, source, libraries, cache = self.fixture(directory)
            bridge["status"] = "authority-pending-export"
            bridge.pop("bridge_commit")
            bridge.pop("export_source_commit")
            bridge_root = libraries / bridge["repository"]
            shutil.rmtree(bridge_root)
            self.assertEqual(MODULE.audit_bridge(bridge, source, libraries, cache), [])

    def test_pending_export_cannot_claim_unpublished_commits(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            bridge, source, libraries, cache = self.fixture(directory)
            bridge["status"] = "authority-pending-export"
            problems = MODULE.audit_bridge(bridge, source, libraries, cache)
            self.assertTrue(any("must not claim" in problem for problem in problems))

    def test_unknown_bridge_status_fails(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            bridge, source, libraries, cache = self.fixture(directory)
            bridge["status"] = "invented"
            problems = MODULE.audit_bridge(bridge, source, libraries, cache)
            self.assertTrue(any("unsupported bridge status" in problem for problem in problems))

    def test_transport_before_compatibility_fails(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            bridge, source, libraries, cache = self.fixture(directory)
            bridge["compatibility_declarations"] = ["model_compatibility"]
            path = source / bridge["source"]
            path.write_text(
                "import Human.Model\nimport Cert.Certificate\n"
                "namespace Paper.Compatibility\n"
                "structure TransportWitness where\n  witness : Unit\n"
                "theorem model_compatibility : True := by trivial\n"
                "end Paper.Compatibility\n",
                encoding="utf-8",
            )
            problems = MODULE.audit_bridge(bridge, source, libraries, cache)
            self.assertTrue(any("not before transport" in problem for problem in problems))

    def test_forbidden_legacy_source_token_fails(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            bridge, source, libraries, cache = self.fixture(directory)
            bridge["forbidden_source_tokens"] = ["Legacy.Namespace"]
            path = source / bridge["source"]
            path.write_text(path.read_text() + "\n-- Legacy.Namespace\n", encoding="utf-8")
            problems = MODULE.audit_bridge(bridge, source, libraries, cache)
            self.assertTrue(any("forbidden source token" in problem for problem in problems))


if __name__ == "__main__":
    unittest.main()
