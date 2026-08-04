#!/usr/bin/env python3
"""Tests for sealing and pinning external certificate-package trust facts.

The artifact under test is the only bridge by which a closure this repository never builds can
make a trust claim here.  Every test below asks whether the tool can be made to publish a claim
the recorded evidence does not support.
"""

from __future__ import annotations

import hashlib
import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path


SCRIPT = Path(__file__).with_name("lean-external-fact.py")
GATE = "Alpha.Gates.CertificateTrust"
PACKAGE = "alpha-certificates"

GATE_LOG = """\
$ nix develop --command bash -lc exec lake build --no-build 'Alpha.Gates.CertificateTrust'
info: Base/Shared.lean:12:0: 'Base.shared_bound' depends on axioms: [propext, Quot.sound]
info: lean/Alpha/Profile.lean:36:0: 'Alpha.Certificates.rejection_profile' depends on axioms:
  [propext, Quot.sound]
info: lean/Alpha/Result.lean:9:0: 'Alpha.Certificates.exact_value' depends on axioms: [propext,
  Classical.choice, Quot.sound]
"""


class ExternalFactTest(unittest.TestCase):
    def setUp(self) -> None:
        self._tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self._tmp.cleanup)
        self.root = Path(self._tmp.name)
        self.package = self.root / "package"
        self.run_dir = self.root / "run"
        self.trust = self.root / "trust"
        self.external = self.trust / "external"
        self.config = self.trust / "certificate-packages.toml"
        self.make_package()
        self.make_run()
        self.write_config()

    # -- fixtures ---------------------------------------------------------------------------

    def make_package(self) -> None:
        (self.package / "lean/Alpha").mkdir(parents=True)
        (self.package / "evidence").mkdir()
        for module, rel in (
            ("Alpha.Profile", "lean/Alpha/Profile.lean"),
            ("Alpha.Result", "lean/Alpha/Result.lean"),
        ):
            (self.package / rel).write_text(f"-- {module}\n", encoding="utf-8")
        sources = [
            {"module": "Alpha.Profile", "path": "lean/Alpha/Profile.lean", "sha256": "0" * 64},
            {"module": "Alpha.Result", "path": "lean/Alpha/Result.lean", "sha256": "0" * 64},
        ]
        (self.package / "MANIFEST.json").write_text(
            json.dumps(
                {
                    "schema_version": 1,
                    "source_commit": "0" * 40,
                    "dependency": {"repository": "https://example.invalid/base", "commit": "2" * 40},
                    "sources": sources,
                },
                indent=2,
                sort_keys=True,
            )
            + "\n",
            encoding="utf-8",
        )
        (self.package / "evidence/gate-axioms.log").write_text(GATE_LOG, encoding="utf-8")
        self.git("init", "-q")
        self.git("add", "-A")
        self.git(
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
        )
        self.head = subprocess.run(
            ["git", "rev-parse", "HEAD"],
            cwd=self.package,
            check=True,
            text=True,
            capture_output=True,
        ).stdout.strip()

    def git(self, *args: str) -> None:
        subprocess.run(["git", *args], cwd=self.package, check=True, capture_output=True)

    def make_run(self, **overrides) -> None:
        (self.run_dir / "logs").mkdir(parents=True, exist_ok=True)
        log = self.run_dir / "logs/gate.nobuild.log"
        log.write_text(GATE_LOG, encoding="utf-8")
        source = {
            "git_dirty": False,
            "git_head": getattr(self, "head", "0" * 40),
            "lean_toolchain": "leanprover/lean4:v4.32.0-rc1",
        }
        source.update(overrides.pop("source", {}))
        manifest = {"lean_root": str(self.package), "source": source}
        manifest.update(overrides.pop("manifest", {}))
        status = {
            "state": "success",
            "results": [{"target": GATE, "outcome": "skipped-current", "log": str(log)}],
        }
        status.update(overrides.pop("status", {}))
        (self.run_dir / "manifest.json").write_text(json.dumps(manifest), encoding="utf-8")
        (self.run_dir / "status.json").write_text(json.dumps(status), encoding="utf-8")

    def write_config(self, **overrides) -> None:
        self.trust.mkdir(parents=True, exist_ok=True)
        fields = {
            "commit": self.head,
            "manifest_sha256": self.sha256(self.package / "MANIFEST.json"),
            "gate": GATE,
            "terminal": "Alpha.Certificates.exact_value",
            "trust_fact": f"external/{PACKAGE}.json",
            "trust_fact_sha256": overrides.pop("trust_fact_sha256", "unset"),
        }
        fields.update(overrides)
        body = "\n".join(f'{key} = "{value}"' for key, value in fields.items())
        self.config.write_text(
            f'schema_version = 1\n\n[[package]]\nname = "{PACKAGE}"\n'
            f'repository = "https://example.invalid/{PACKAGE}"\n{body}\n'
            "owned_module_prefixes = []\nforbidden_artifact_basenames = []\n",
            encoding="utf-8",
        )

    @staticmethod
    def sha256(path: Path) -> str:
        return hashlib.sha256(path.read_bytes()).hexdigest()

    def run_tool(self, *args: str) -> subprocess.CompletedProcess:
        return subprocess.run(
            [
                sys.executable,
                str(SCRIPT),
                "--config",
                str(self.config),
                "--external-dir",
                str(self.external),
                *args,
            ],
            capture_output=True,
            text=True,
        )

    def seal(self, *extra: str) -> subprocess.CompletedProcess:
        return self.run_tool(
            "seal",
            "--package-root",
            str(self.package),
            "--run-dir",
            str(self.run_dir),
            "--package",
            PACKAGE,
            *extra,
        )

    def pin(self, *extra: str) -> subprocess.CompletedProcess:
        return self.run_tool("pin", "--package-root", str(self.package), "--package", PACKAGE, *extra)

    def sealed(self) -> dict:
        return json.loads((self.package / "TRUST_FACT.json").read_text(encoding="utf-8"))

    # -- sealing ----------------------------------------------------------------------------

    def test_seal_records_every_printed_declaration_with_its_origin(self):
        self.assertEqual(self.seal("--write").returncode, 0)
        declarations = self.sealed()["declarations"]
        self.assertEqual(
            declarations["Alpha.Certificates.rejection_profile"],
            {"axioms": ["Quot.sound", "propext"], "module": "Alpha.Profile", "origin": "package"},
        )
        self.assertEqual(declarations["Base.shared_bound"]["origin"], "dependency")

    def test_seal_folds_wrapped_axiom_lists(self):
        self.seal("--write")
        self.assertEqual(
            self.sealed()["declarations"]["Alpha.Certificates.exact_value"]["axioms"],
            ["Classical.choice", "Quot.sound", "propext"],
        )

    def test_seal_is_deterministic_and_verifiable_without_write(self):
        self.seal("--write")
        self.assertEqual(self.seal().returncode, 0)

    def test_hand_edited_fact_does_not_verify(self):
        self.seal("--write")
        target = self.package / "TRUST_FACT.json"
        fact = json.loads(target.read_text(encoding="utf-8"))
        fact["declarations"]["Alpha.Certificates.invented"] = {
            "axioms": [],
            "module": "Alpha.Profile",
            "origin": "package",
        }
        target.write_text(json.dumps(fact, indent=2, sort_keys=True) + "\n", encoding="utf-8")
        self.assertEqual(self.seal().returncode, 1)

    def test_dirty_package_tree_is_refused(self):
        self.make_run(source={"git_dirty": True})
        self.assertEqual(self.seal("--write").returncode, 2)

    def test_run_against_another_root_is_refused(self):
        self.make_run(manifest={"lean_root": str(self.root / "elsewhere")})
        self.assertEqual(self.seal("--write").returncode, 2)

    def test_run_at_a_superseded_commit_is_refused(self):
        self.make_run(source={"git_head": "9" * 40})
        self.assertEqual(self.seal("--write").returncode, 2)

    def test_failed_run_is_refused(self):
        self.make_run(status={"state": "failure", "results": []})
        self.assertEqual(self.seal("--write").returncode, 2)

    def test_gate_that_did_not_finish_is_refused(self):
        self.make_run(
            status={
                "state": "success",
                "results": [{"target": GATE, "outcome": "interrupted", "log": "x"}],
            }
        )
        self.assertEqual(self.seal("--write").returncode, 2)

    def test_evidence_differing_from_the_recorded_log_is_refused(self):
        (self.package / "evidence/gate-axioms.log").write_text(
            GATE_LOG.replace("Quot.sound", "sorryAx"), encoding="utf-8"
        )
        self.assertEqual(self.seal("--write").returncode, 2)

    def test_missing_evidence_is_refused(self):
        (self.package / "evidence/gate-axioms.log").unlink()
        self.assertEqual(self.seal("--write").returncode, 2)

    def test_terminal_without_an_axiom_fact_is_refused(self):
        self.write_config(terminal="Alpha.Certificates.absent")
        self.assertEqual(self.seal("--write").returncode, 2)

    # -- pinning and checking ---------------------------------------------------------------

    def test_pin_copies_the_package_artifact_byte_for_byte(self):
        self.seal("--write")
        self.assertEqual(self.pin("--write").returncode, 0)
        published = (self.package / "TRUST_FACT.json").read_bytes()
        self.assertEqual((self.external / f"{PACKAGE}.json").read_bytes(), published)

    def test_check_accepts_a_matching_pin(self):
        self.seal("--write")
        self.pin("--write")
        self.write_config(
            trust_fact_sha256=self.sha256(self.external / f"{PACKAGE}.json")
        )
        self.assertEqual(self.run_tool("check").returncode, 0)

    def test_check_rejects_an_edited_pinned_copy(self):
        self.seal("--write")
        self.pin("--write")
        self.write_config(
            trust_fact_sha256=self.sha256(self.external / f"{PACKAGE}.json")
        )
        pinned = self.external / f"{PACKAGE}.json"
        pinned.write_text(
            pinned.read_text(encoding="utf-8").replace("Quot.sound", "propext"), encoding="utf-8"
        )
        self.assertEqual(self.run_tool("check").returncode, 1)

    def test_check_rejects_a_fact_that_disagrees_with_its_pin(self):
        self.seal("--write")
        self.pin("--write")
        self.write_config(
            gate="Alpha.Gates.SomethingElse",
            trust_fact_sha256=self.sha256(self.external / f"{PACKAGE}.json"),
        )
        self.assertEqual(self.run_tool("check").returncode, 1)

    def test_check_rejects_a_package_with_no_pinned_fact(self):
        self.config.write_text(
            self.config.read_text(encoding="utf-8").replace(
                f'trust_fact = "external/{PACKAGE}.json"', ""
            ),
            encoding="utf-8",
        )
        self.assertEqual(self.run_tool("check").returncode, 1)


if __name__ == "__main__":
    unittest.main(verbosity=2)
