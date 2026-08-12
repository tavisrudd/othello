#!/usr/bin/env python3
"""Tests for deterministic paper-bridge package materialization."""

from __future__ import annotations

import importlib.util
import subprocess
import tempfile
import tomllib
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
            "finitegeom_import": "Human.Model",
            "cache_sha256": "c" * 64,
            "cache_archive": "sample.lake-pack.tar.gz",
            "certificate_olean_sha256": "d" * 64,
            "certificate_trace_sha256": "e" * 64,
        }

    def test_lakefile_has_only_two_project_dependencies(self) -> None:
        text = MODULE.lakefile(self.bridge())
        self.assertIn('name = "finitegeom"', text)
        self.assertIn('name = "finitegeom-sample-certificates"', text)
        self.assertEqual(text.count("[[require]]"), 2)
        self.assertIn(
            'roots = ["TavisRuddFiniteGeom.Papers.Sample.CertificateCompatibility"]',
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
        self.assertIn(
            'git -C "$finitegeom_source" rev-parse --is-inside-work-tree', text
        )
        self.assertIn(
            'git -C "$certificate_source" rev-parse --is-inside-work-tree', text
        )
        self.assertNotIn('test -d "$certificate_source/.git"', text)
        self.assertIn('ln -s "$finitegeom_source" "$finitegeom_root"', text)
        self.assertIn('ln -s "$certificate_source" "$certificate_root"', text)
        self.assertIn('(cd "$certificate_root" && lake unpack "$certificate_pack")', text)
        self.assertIn(
            'if test "$local_sources" -eq 0 || ! test -f lake-manifest.json; then',
            text,
        )
        self.assertIn(
            '(cd "$finitegeom_root" && lake build --no-build Human.Model)', text
        )

    def test_verifier_never_builds_a_certificate_target(self) -> None:
        text = MODULE.flake(self.bridge())
        self.assertIn('(cd "$certificate_root" && lake unpack "$certificate_pack")', text)
        self.assertEqual(text.count('(cd "$certificate_root" && lake unpack "$certificate_pack")'), 1)
        self.assertEqual(text.count("sha256sum --check --status"), 3)
        self.assertIn('(cd "$finitegeom_root" && lake build Human.Model)', text)
        self.assertIn(
            "lake env lean TavisRuddFiniteGeom/Papers/Sample/CertificateCompatibility.lean",
            text,
        )
        self.assertNotIn(
            "lake build --no-build TavisRuddFiniteGeom.Certificates.Sample", text
        )
        certificate_block = text[
            text.index('certificate_root="'):text.index(
                'if test "$local_sources" -eq 1; then\n'
                '                (cd "$finitegeom_root"'
            )
        ]
        self.assertNotIn("lake build", certificate_block)
        self.assertIn("export LEAN_NUM_THREADS=1", text)

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
        self.assertIn(
            b'"module": "TavisRuddFiniteGeom.Papers.Sample.CertificateCompatibility"',
            files["MANIFEST.json"],
        )
        self.assertEqual(files[".gitignore"], b"/.lake/\n/lake-manifest.json\n")

    def test_unknown_bridge_cannot_receive_generic_reviewer_prose(self) -> None:
        bridge = self.bridge()
        bridge["name"] = "unknown"
        with self.assertRaisesRegex(ValueError, "no reviewer-facing scope"):
            MODULE.readme(bridge)

    def test_projective_q11_export_uses_only_the_sealed_pack(self) -> None:
        with (MODULE.REPO / MODULE.CONFIG_PATH).open("rb") as handle:
            bridge = MODULE.select_bridge(tomllib.load(handle), "projective-cap-q11")
        text = MODULE.flake(bridge)
        self.assertIn("nix run .#verify", MODULE.readme(bridge))
        self.assertIn(bridge["cache_sha256"], text)
        self.assertIn('(cd "$certificate_root" && lake unpack "$certificate_pack")', text)
        self.assertNotIn(f'lake build {bridge["certificate_gate"]}', text)
        self.assertNotIn("materialize", text.lower())
        self.assertNotIn("generate", text.lower())

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

    def test_sync_requires_explicit_permission_to_delete_tracked_files(self) -> None:
        commit = str(MODULE.git("rev-parse", "HEAD")).strip()
        bridge = self.bridge()
        with tempfile.TemporaryDirectory(dir=Path.home()) as directory:
            root = Path(directory)
            destination, initial = MODULE.adopt(
                commit, bridge, {"README.md": b"first\n"}, root
            )
            bridge["bridge_commit"] = initial
            obsolete = destination / "AxiomAudit.lean"
            obsolete.write_bytes(b"#print axioms x\n")
            subprocess.run(
                ["git", "-C", str(destination), "add", "--", "AxiomAudit.lean"],
                check=True,
            )
            subprocess.run(
                [
                    "git", "-C", str(destination), "-c", "commit.gpgsign=false",
                    "commit", "-m", "Add obsolete audit",
                ],
                check=True,
                capture_output=True,
            )
            initial = subprocess.run(
                ["git", "-C", str(destination), "rev-parse", "HEAD"],
                check=True,
                capture_output=True,
                text=True,
            ).stdout.strip()
            bridge["bridge_commit"] = initial
            with self.assertRaisesRegex(ValueError, "would delete tracked paths"):
                MODULE.sync(commit, bridge, {"README.md": b"second\n"}, root)
            synced_destination, updated = MODULE.sync(
                commit,
                bridge,
                {"README.md": b"second\n"},
                root,
                allow_delete=True,
            )
            self.assertEqual(synced_destination, destination)
            self.assertNotEqual(updated, initial)
            self.assertEqual((destination / "README.md").read_bytes(), b"second\n")
            self.assertFalse(obsolete.exists())
            self.assertEqual(
                subprocess.run(
                    ["git", "-C", str(destination), "status", "--short"],
                    check=True,
                    capture_output=True,
                    text=True,
                ).stdout,
                "",
            )

    def test_pending_sync_accepts_only_exact_prior_export(self) -> None:
        commit = str(MODULE.git("rev-parse", "HEAD")).strip()
        with (MODULE.REPO / MODULE.CONFIG_PATH).open("rb") as handle:
            bridge = MODULE.select_bridge(
                tomllib.load(handle), "projective-cap-q11"
            )
        bridge["status"] = "authority-pending-export"
        bridge.pop("bridge_commit", None)
        bridge.pop("export_source_commit", None)
        files = MODULE.materialized_files(commit, bridge)
        with tempfile.TemporaryDirectory(dir=Path.home()) as directory:
            root = Path(directory)
            destination, initial = MODULE.adopt(commit, bridge, files, root)
            synced_destination, updated = MODULE.sync(commit, bridge, files, root)
            self.assertEqual((synced_destination, updated), (destination, initial))
            (destination / "README.md").write_text("not an export\n", encoding="utf-8")
            subprocess.run(
                ["git", "-C", str(destination), "add", "--", "README.md"], check=True
            )
            subprocess.run(
                [
                    "git", "-C", str(destination), "-c", "commit.gpgsign=false",
                    "commit", "-m", "Tamper with export",
                ],
                check=True,
                capture_output=True,
            )
            with self.assertRaisesRegex(ValueError, "exact prior exporter output"):
                MODULE.sync(commit, bridge, files, root)


if __name__ == "__main__":
    unittest.main()
