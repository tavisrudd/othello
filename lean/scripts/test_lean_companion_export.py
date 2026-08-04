#!/usr/bin/env python3
"""Tests for the guarded companion exporter."""

from __future__ import annotations

import importlib.util
import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path


SCRIPT = Path(__file__).with_name("lean-companion-export.py")


def load_exporter():
    spec = importlib.util.spec_from_file_location("lean_companion_export_tested", SCRIPT)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


EXPORTER = load_exporter()

TOOLCHAIN = "leanprover/lean4:v4.32.0-rc1\n"
MATHLIB_REV = "571b8a8e54219b4d393f75f4b8653fac08197fcc"
GATE = "Example.Gates.TriangleIdentities"
LEAF = "Example.TriangleIdentities"
TERMINALS = (f"{LEAF}.triangle_square", f"{LEAF}.triangle_trace")

CONFIG = """
schema_version = 1
area = "triangle_identities"
gate = "Example.Gates.TriangleIdentities"
trust_statement = "trust/TRIANGLE_IDENTITIES.md"
axiom_audit = "trust/TriangleIdentitiesAxiomAudit.lean"
statement_title = "Triangle identities: symbolic companion"
overview = "This boundary records symbolic triangle identities."
correspondence = "The closure proves two ring identities and nothing else."
boundary = "Both terminals are symbolic kernel proofs over a commutative ring."
axiom_audit_title = "Axiom audit for the triangle identities"
axiom_audit_description = "This audit prints the axioms of both identities."
readme_anchor = "- boundary bullet anchor"
readme_bullet = "- `trust/manifests/triangle_identities.json` records the triangle boundary."
"""


def git(repo: Path, *args: str) -> None:
    subprocess.run(
        ["git", "-C", str(repo), "-c", "user.name=Test", "-c", "user.email=test@example.invalid",
         "-c", "commit.gpgsign=false", *args],
        check=True,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.PIPE,
    )


def write(path: Path, text: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text)


def make_source_repo(root: Path, *, terminals: tuple[str, ...] = TERMINALS) -> None:
    lean = root / "lean"
    write(lean / "lean-toolchain", TOOLCHAIN)
    write(
        lean / "Example" / "TriangleIdentities.lean",
        "import Mathlib.Tactic.Ring\n\n/-! # Triangle identities -/\n",
    )
    write(
        lean / "Example" / "Gates" / "TriangleIdentities.lean",
        f"import {LEAF}\n\n/-! # Import-only gate -/\n",
    )
    registry = ['schema_version = 1', 'area = "example"', "", "[[gate]]",
                f'module = "{GATE}"', "terminals = ["]
    registry += [f'  "{terminal}",' for terminal in terminals]
    registry += ["]", 'coverage_rule = "closure"', ""]
    write(lean / "trust" / "areas" / "example.toml", "\n".join(registry))
    fact = {
        "closure": [GATE, LEAF],
        "declaration_module": {},
        "lean_toolchain": TOOLCHAIN.strip(),
        "mathlib_rev": MATHLIB_REV,
        "opaque": [],
        "project_axioms": [],
        "project_declarations": list(TERMINALS),
        "schema_version": 1,
        "terminal_axioms": {terminal: ["propext"] for terminal in TERMINALS},
        "unit": GATE,
        "uses": {},
        "uses_included": True,
    }
    write(lean / "trust" / "facts" / f"{GATE}.json", json.dumps(fact, indent=2, sort_keys=True) + "\n")
    git(root, "init", "--quiet")
    git(root, "add", "-A")
    git(root, "commit", "--quiet", "-m", "source")


def make_base_repo(root: Path) -> None:
    write(root / "lean-toolchain", TOOLCHAIN)
    write(root / "lake-manifest.json", json.dumps({"packages": [{"name": "mathlib", "rev": MATHLIB_REV}]}))
    write(
        root / "lakefile.toml",
        'name = "example"\n\n[[lean_lib]]\nname = "Example"\nroots = [\n'
        '  "Example.Base",\n  "Example.Zeta",\n]\n',
    )
    write(root / "Example" / "Base.lean", "/-! # Base -/\n")
    data = (root / "Example" / "Base.lean").read_bytes()
    manifest = {
        "external_imports": ["Mathlib.Tactic.Ring"],
        "module_count": 1,
        "roots": ["Example.Base"],
        "schema_version": 1,
        "sources": [
            {
                "bytes": len(data),
                "module": "Example.Base",
                "path": "Example/Base.lean",
                "sha256": EXPORTER.sha256_bytes(data),
            }
        ],
    }
    write(root / "TARGET_MANIFEST.json", json.dumps(manifest, indent=2, sort_keys=True) + "\n")
    write(
        root / "README.md",
        "# Base library\n\n- `TARGET_MANIFEST.json` content-addresses the complete 1-module reviewed\n"
        "  library state.\n- boundary bullet anchor\n- trailing bullet\n",
    )
    write(root / "PROVENANCE.md", "# Provenance\n\nIt records the 1-module library state.\n")
    git(root, "init", "--quiet")
    git(root, "add", "-A")
    git(root, "commit", "--quiet", "-m", "base")


class CompanionExportTests(unittest.TestCase):
    def setUp(self) -> None:
        # The exporter refuses memory-backed destinations, so the fixtures need
        # a disk-backed scratch root rather than the default temporary space.
        scratch = Path.home() / ".cache" / "othello-lean-companion-export" / "tests"
        scratch.mkdir(parents=True, exist_ok=True)
        if EXPORTER.filesystem_type(scratch) in EXPORTER.MEMORY_BACKED_FILESYSTEMS:
            self.skipTest("no disk-backed scratch directory available")
        self._tmp = tempfile.TemporaryDirectory(dir=scratch)
        root = Path(self._tmp.name)
        self.source = root / "source"
        self.base = root / "finitegeom"
        self.work = root / "work"
        self.source.mkdir()
        self.base.mkdir()
        make_source_repo(self.source)
        make_base_repo(self.base)
        self.config = root / "triangle_identities.toml"
        self.config.write_text(CONFIG)

    def tearDown(self) -> None:
        self._tmp.cleanup()

    def build(self, **kwargs):
        return EXPORTER.build_plan(
            kwargs.get("source", self.source),
            "HEAD",
            kwargs.get("base", self.base),
            "HEAD",
            kwargs.get("config", self.config),
            kwargs.get("accept_drift", False),
        )

    def test_plan_derives_closure_terminals_and_manifest_growth(self) -> None:
        plan = self.build()
        summary = plan.summary()
        self.assertEqual(summary["closure_modules"], [GATE, LEAF])
        self.assertEqual(summary["terminals"], sorted(TERMINALS))
        self.assertEqual(summary["permitted_axioms"], ["propext"])
        self.assertEqual(summary["base_module_count"], 1)
        self.assertEqual(summary["candidate_module_count"], 3)
        self.assertEqual(summary["external_imports"], ["Mathlib.Tactic.Ring"])

    def test_materialization_is_deterministic_and_verifies(self) -> None:
        plan = self.build()
        first = self.work / "candidate"
        second = self.work / "repeat"
        EXPORTER.materialize(plan, first)
        EXPORTER.materialize(plan, second)
        self.assertEqual(EXPORTER.tree_fingerprint(first), EXPORTER.tree_fingerprint(second))
        report = EXPORTER.verify(plan, first)
        self.assertEqual(report["module_count"], 3)
        delta = EXPORTER.forward_delta(plan, first)
        self.assertEqual(delta["file_count"], len(plan.files))
        self.assertIn("Example/Gates/TriangleIdentities.lean", delta["added"])
        self.assertIn("TARGET_MANIFEST.json", delta["modified"])
        self.assertEqual(EXPORTER.git_text(first, "remote").strip(), "")
        self.assertEqual(EXPORTER.resolve_commit(first, "HEAD"), plan.base.commit)

    def test_planned_file_the_base_already_carries_is_reported_unchanged(self) -> None:
        plan = self.build()
        candidate = self.work / "candidate"
        EXPORTER.materialize(plan, candidate)
        EXPORTER.git_text(candidate, "checkout", "--", "TARGET_MANIFEST.json")
        delta = EXPORTER.forward_delta(plan, candidate, verbose=True)
        self.assertNotIn("TARGET_MANIFEST.json", delta["modified"])
        self.assertEqual(delta["planned_unchanged"], ["TARGET_MANIFEST.json"])
        self.assertEqual(delta["planned_unchanged_count"], 1)
        self.assertEqual(delta["file_count"], len(plan.files) - 1)
        self.assertNotIn("planned_unchanged", EXPORTER.forward_delta(plan, candidate))

    def test_readme_bullet_insertion_is_idempotent(self) -> None:
        # A base that already adopted this area's bullet must still re-export:
        # the bullet is left as it stands and the rest of the README retargets.
        readme = self.base / "README.md"
        bullet = "- `trust/manifests/triangle_identities.json` records the triangle boundary."
        readme.write_text(readme.read_text().replace(
            "- boundary bullet anchor\n", f"- boundary bullet anchor\n{bullet}\n"
        ))
        git(self.base, "add", "-A")
        git(self.base, "commit", "--quiet", "-m", "adopted")
        plan = self.build()
        candidate_readme = plan.files["README.md"].decode("utf-8")
        self.assertEqual(candidate_readme.count(bullet), 1)
        self.assertIn("3-module reviewed", candidate_readme)

    def test_readme_needing_no_change_leaves_the_delta(self) -> None:
        readme = self.base / "README.md"
        bullet = "- `trust/manifests/triangle_identities.json` records the triangle boundary."
        readme.write_text(f"# Base library\n\n- boundary bullet anchor\n{bullet}\n")
        git(self.base, "add", "-A")
        git(self.base, "commit", "--quiet", "-m", "adopted")
        self.assertNotIn("README.md", self.build().files)

    def test_unplanned_change_is_refused(self) -> None:
        plan = self.build()
        candidate = self.work / "candidate"
        EXPORTER.materialize(plan, candidate)
        (candidate / "UNPLANNED.md").write_text("stray\n")
        with self.assertRaises(EXPORTER.Refused) as caught:
            EXPORTER.forward_delta(plan, candidate)
        self.assertIn("UNPLANNED.md", str(caught.exception))

    def test_candidate_registry_and_audit_record_the_exact_terminals(self) -> None:
        plan = self.build()
        candidate = self.work / "candidate"
        EXPORTER.materialize(plan, candidate)
        registry = (candidate / "trust/areas/triangle_identities.toml").read_text()
        audit = (candidate / "trust/TriangleIdentitiesAxiomAudit.lean").read_text()
        for terminal in TERMINALS:
            self.assertIn(f'"{terminal}"', registry)
            self.assertIn(f"#print axioms {terminal}", audit)
        self.assertIn(f"import {GATE}", audit)

    def test_verify_rejects_a_tampered_candidate_module(self) -> None:
        plan = self.build()
        candidate = self.work / "candidate"
        EXPORTER.materialize(plan, candidate)
        (candidate / "Example" / "TriangleIdentities.lean").write_text("import Mathlib.Tactic.Ring\n")
        with self.assertRaises(EXPORTER.Refused):
            EXPORTER.verify(plan, candidate)

    def test_dirty_base_is_refused(self) -> None:
        (self.base / "README.md").write_text("edited\n")
        with self.assertRaises(EXPORTER.Refused):
            self.build()

    def test_registry_and_fact_terminal_disagreement_is_refused(self) -> None:
        registry = self.source / "lean" / "trust" / "areas" / "example.toml"
        registry.write_text(registry.read_text().replace("triangle_trace", "triangle_missing"))
        git(self.source, "add", "-A")
        git(self.source, "commit", "--quiet", "-m", "drift")
        with self.assertRaises(EXPORTER.Refused):
            self.build()

    def test_base_prose_drift_requires_an_explicit_acceptance(self) -> None:
        provenance = self.base / "PROVENANCE.md"
        provenance.write_text("# Provenance\n\nIt records the 9-module library state.\n")
        git(self.base, "add", "-A")
        git(self.base, "commit", "--quiet", "-m", "drift")
        with self.assertRaises(EXPORTER.Refused):
            self.build()
        plan = self.build(accept_drift=True)
        self.assertEqual(len(plan.prose_drift), 1)
        self.assertNotIn("PROVENANCE.md", plan.files)

    def test_suffixed_candidate_clone_is_refused_as_base_or_destination(self) -> None:
        clone = self.base.parent / "finitegeom-golden-quantum-statistics"
        with self.assertRaises(EXPORTER.Refused):
            EXPORTER.guard_paths(clone, None)
        with self.assertRaises(EXPORTER.Refused):
            EXPORTER.guard_paths(self.base, clone)

    def test_candidate_inside_the_base_repository_is_refused(self) -> None:
        with self.assertRaises(EXPORTER.Refused):
            EXPORTER.guard_paths(self.base, self.base / "candidate")

    def test_memory_backed_destination_is_refused(self) -> None:
        if EXPORTER.filesystem_type(Path("/dev/shm")) not in EXPORTER.MEMORY_BACKED_FILESYSTEMS:
            self.skipTest("no memory-backed filesystem available")
        with self.assertRaises(EXPORTER.Refused):
            EXPORTER.guard_paths(self.base, Path("/dev/shm/companion-candidate"))

    def test_configuration_prose_with_a_private_reference_is_refused(self) -> None:
        self.config.write_text(CONFIG.replace(
            'overview = "This boundary records symbolic triangle identities."',
            'overview = "This boundary records the C853 triangle identities."',
        ))
        with self.assertRaises(EXPORTER.Refused):
            self.build()

    def test_missing_generated_fact_is_refused(self) -> None:
        fact = self.source / "lean" / "trust" / "facts" / f"{GATE}.json"
        fact.unlink()
        git(self.source, "add", "-A")
        git(self.source, "commit", "--quiet", "-m", "remove fact")
        with self.assertRaises(EXPORTER.Refused):
            self.build()

    def test_toolchain_mismatch_is_refused(self) -> None:
        (self.base / "lean-toolchain").write_text("leanprover/lean4:v4.31.0\n")
        git(self.base, "add", "-A")
        git(self.base, "commit", "--quiet", "-m", "toolchain")
        with self.assertRaises(EXPORTER.Refused):
            self.build()


if __name__ == "__main__":
    unittest.main()
