#!/usr/bin/env python3
"""Tests for lean-trust-extract.py.

Fully hermetic: every fixture is a throwaway directory holding a stub toolchain pin, lake manifest,
and exporter file, so the suite never elaborates Lean, never builds, and never reads the real trust
registry.  Run:

    python3 lean/scripts/test_lean_trust_extract.py

The driver's job is to refuse.  It refuses output that describes a different checkout, output whose
internal references do not resolve, and any extraction attempted while another lane's work is in the
tree.  Most cases below therefore start from something valid, break exactly one thing, and assert
that the specific refusal fires — a driver that cannot be made to refuse would launder whatever the
exporter happened to print.
"""

from __future__ import annotations

import argparse
import importlib.util
import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

SCRIPT = Path(__file__).resolve().parent / "lean-trust-extract.py"
EXPORTER = Path(__file__).resolve().parent / "trust-spine-export.lean"


def _load_module():
    spec = importlib.util.spec_from_file_location("lean_trust_extract", SCRIPT)
    module = importlib.util.module_from_spec(spec)
    sys.modules["lean_trust_extract"] = module
    spec.loader.exec_module(module)
    return module


tx = _load_module()

TOOLCHAIN = "leanprover/lean4:v4.32.0-rc1"
MATHLIB_REV = "571b8a8e54219b4d393f75f4b8653fac08197fcc"

MANIFEST = json.dumps(
    {
        "version": "1.1.0",
        "packages": [
            {"name": "mathlib", "rev": MATHLIB_REV},
            {"name": "plausible", "rev": "f3c7bd5061bd81b4480295c524d4f245c8b7e4e2"},
        ],
    }
)


def make_lean_root(tmp: Path) -> Path:
    """A minimal tree with everything the driver reads and nothing it does not."""
    lean_root = tmp / "lean"
    (lean_root / "scripts").mkdir(parents=True)
    (lean_root / "lean-toolchain").write_text(TOOLCHAIN + "\n", encoding="utf-8")
    (lean_root / "lake-manifest.json").write_text(MANIFEST, encoding="utf-8")
    # The real exporter, so the wrapper tests exercise the bytes that actually ship.
    (lean_root / "scripts" / "trust-spine-export.lean").write_text(
        EXPORTER.read_text(encoding="utf-8"), encoding="utf-8"
    )
    return lean_root


def raw_facts(**overrides):
    doc = {
        "schema_version": 1,
        "unit": "Area.Gates.One",
        "lean_version": "4.32.0-rc1",
        "lean_toolchain": TOOLCHAIN,
        "mathlib_rev": MATHLIB_REV,
        "exporter_sha256": "",
        "uses_included": True,
        "closure": ["Area.Base", "Area.Gates.One", "Area.Base"],
        "project_declarations": ["Area.Base.thm", "Area.Base.ax", "Area.Base.thm"],
        "project_axioms": ["Area.Base.ax"],
        "terminal_axioms": {"Area.Base.thm": ["Classical.choice", "propext", "Classical.choice"]},
        "declaration_module": {"Area.Base.thm": "Area.Base", "Area.Base.ax": "Area.Base"},
        "uses": {"Area.Base.thm": ["Area.Base.ax", "Mathlib.Nat.foo", "Area.Base.thm"]},
        "opaque": [],
    }
    doc.update(overrides)
    return doc


class CanonicalizeTests(unittest.TestCase):
    def test_sorts_and_deduplicates(self):
        facts = tx.canonicalize(raw_facts(), "Area.Gates.One")
        self.assertEqual(facts["closure"], ["Area.Base", "Area.Gates.One"])
        self.assertEqual(facts["project_declarations"], ["Area.Base.ax", "Area.Base.thm"])
        self.assertEqual(
            facts["terminal_axioms"]["Area.Base.thm"], ["Classical.choice", "propext"]
        )

    def test_drops_non_project_and_self_edges(self):
        facts = tx.canonicalize(raw_facts(), "Area.Gates.One")
        # `Mathlib.Nat.foo` is not a project declaration and the self-edge is not a dependency.
        self.assertEqual(facts["uses"], {"Area.Base.thm": ["Area.Base.ax"]})

    def test_drops_empty_uses_entries(self):
        facts = tx.canonicalize(raw_facts(uses={"Area.Base.thm": ["Mathlib.Nat.foo"]}), "Area.Gates.One")
        self.assertEqual(facts["uses"], {})

    def test_ignores_uses_for_unlisted_declaration(self):
        raw = raw_facts(uses={"Area.Other.gone": ["Area.Base.ax"]})
        self.assertEqual(tx.canonicalize(raw, "Area.Gates.One")["uses"], {})

    def test_shuffled_input_canonicalizes_identically(self):
        first = tx.canonicalize(raw_facts(), "Area.Gates.One")
        shuffled = raw_facts(
            closure=["Area.Gates.One", "Area.Base"],
            project_declarations=["Area.Base.thm", "Area.Base.ax"],
            declaration_module={"Area.Base.ax": "Area.Base", "Area.Base.thm": "Area.Base"},
        )
        second = tx.canonicalize(shuffled, "Area.Gates.One")
        self.assertEqual(
            json.dumps(first, indent=2, sort_keys=True), json.dumps(second, indent=2, sort_keys=True)
        )

    def test_rejects_schema_drift(self):
        with self.assertRaises(tx.Refused) as caught:
            tx.canonicalize(raw_facts(schema_version=2), "Area.Gates.One")
        self.assertIn("schema_version", str(caught.exception))

    def test_rejects_facts_for_another_unit(self):
        with self.assertRaises(tx.Refused):
            tx.canonicalize(raw_facts(), "Area.Gates.Two")

    def test_rejects_axiom_absent_from_declarations(self):
        raw = raw_facts(project_axioms=["Area.Base.ghost"])
        with self.assertRaises(tx.Refused) as caught:
            tx.canonicalize(raw, "Area.Gates.One")
        self.assertIn("project_declarations", str(caught.exception))

    def test_rejects_declaration_without_module(self):
        raw = raw_facts(declaration_module={"Area.Base.thm": "Area.Base"})
        with self.assertRaises(tx.Refused) as caught:
            tx.canonicalize(raw, "Area.Gates.One")
        self.assertIn("defining module", str(caught.exception))

    def test_rejects_unusable_name(self):
        raw = raw_facts(project_declarations=["Area.Base.thm", 'Area."odd'])
        with self.assertRaises(tx.Refused):
            tx.canonicalize(raw, "Area.Gates.One")

    def test_rejects_non_object_uses(self):
        with self.assertRaises(tx.Refused):
            tx.canonicalize(raw_facts(uses=["Area.Base.thm"]), "Area.Gates.One")

    def test_records_uses_included_flag(self):
        facts = tx.canonicalize(raw_facts(uses_included=False, uses={}), "Area.Gates.One")
        self.assertFalse(facts["uses_included"])


class EnvironmentTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.lean_root = make_lean_root(Path(self.tmp.name))
        self.addCleanup(self.tmp.cleanup)

    def _facts(self, **overrides):
        raw = raw_facts(
            exporter_sha256=tx.sha256_file(self.lean_root / "scripts" / "trust-spine-export.lean"),
            **overrides,
        )
        return tx.canonicalize(raw, "Area.Gates.One")

    def test_accepts_matching_environment(self):
        tx.verify_environment(self._facts(), self.lean_root)

    def test_rejects_toolchain_mismatch(self):
        with self.assertRaises(tx.Refused) as caught:
            tx.verify_environment(self._facts(lean_toolchain="leanprover/lean4:v4.31.0"), self.lean_root)
        self.assertIn("toolchain", str(caught.exception))

    def test_rejects_mathlib_mismatch(self):
        with self.assertRaises(tx.Refused) as caught:
            tx.verify_environment(self._facts(mathlib_rev="0" * 40), self.lean_root)
        self.assertIn("Mathlib", str(caught.exception))

    def test_rejects_exporter_digest_mismatch(self):
        facts = self._facts()
        facts["exporter_sha256"] = "0" * 64
        with self.assertRaises(tx.Refused) as caught:
            tx.verify_environment(facts, self.lean_root)
        self.assertIn("exporter digest", str(caught.exception))

    def test_edited_exporter_invalidates_prior_facts(self):
        facts = self._facts()
        path = self.lean_root / "scripts" / "trust-spine-export.lean"
        path.write_text(path.read_text(encoding="utf-8") + "\n-- a change\n", encoding="utf-8")
        with self.assertRaises(tx.Refused):
            tx.verify_environment(facts, self.lean_root)

    def test_missing_mathlib_entry_refused(self):
        (self.lean_root / "lake-manifest.json").write_text(json.dumps({"packages": []}), encoding="utf-8")
        with self.assertRaises(tx.Refused):
            tx.read_mathlib_rev(self.lean_root)


class WrapperTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.lean_root = make_lean_root(Path(self.tmp.name))
        self.addCleanup(self.tmp.cleanup)
        self.unit = tx.Unit(
            area="area",
            module="Area.Gates.One",
            terminals=("Area.Base.thm", "Area.Base.other"),
        )

    def _render(self, **kwargs):
        params = dict(
            lean_root=self.lean_root,
            unit=self.unit,
            roots=("Area", "Shared"),
            out_path=Path("/home/scratch/raw.json"),
            include_uses=True,
        )
        params.update(kwargs)
        return tx.render_wrapper(**params)

    def test_imports_come_first_and_cover_the_unit(self):
        lines = [line for line in self._render().splitlines() if line.startswith("import ")]
        self.assertEqual(lines, ["import Lean", "import Area.Gates.One"])

    def test_no_import_appears_after_the_header(self):
        text = self._render()
        body = text.split("import Area.Gates.One", 1)[1]
        self.assertNotIn("\nimport ", body)

    def test_embeds_roots_and_terminals_as_name_literals(self):
        text = self._render()
        self.assertIn("(roots := #[`Area, `Shared])", text)
        self.assertIn("(terminals := #[`Area.Base.thm, `Area.Base.other])", text)

    def test_inventory_unit_renders_empty_terminals(self):
        unit = tx.Unit(area="area", module="Area.Gates.One", terminals=())
        self.assertIn("(terminals := #[])", self._render(unit=unit))

    def test_embeds_pinned_environment(self):
        text = self._render()
        self.assertIn(f'(leanToolchain := "{TOOLCHAIN}")', text)
        self.assertIn(f'(mathlibRev := "{MATHLIB_REV}")', text)
        expected = tx.sha256_file(self.lean_root / "scripts" / "trust-spine-export.lean")
        self.assertIn(f'(exporterSha256 := "{expected}")', text)

    def test_no_uses_renders_false(self):
        self.assertIn("(includeUses := false)", self._render(include_uses=False))
        self.assertIn("(includeUses := true)", self._render())

    def test_generation_is_deterministic(self):
        self.assertEqual(self._render(), self._render())

    def test_refuses_to_quote_a_hostile_name(self):
        unit = tx.Unit(area="area", module='Area.Gates.One"; #eval 1', terminals=())
        with self.assertRaises(tx.Refused):
            self._render(unit=unit)

    def test_refuses_a_path_it_cannot_quote(self):
        with self.assertRaises(tx.Refused):
            self._render(out_path=Path('/home/scratch/"raw".json'))

    def test_wrapper_is_marked_generated(self):
        self.assertIn("Do not edit and do not track", self._render())


class QuietWindowTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.repo = Path(self.tmp.name)
        self.addCleanup(self.tmp.cleanup)
        self._git("init", "-q")
        self._git("config", "user.email", "test@example.invalid")
        self._git("config", "user.name", "test")
        self._git("config", "commit.gpgsign", "false")
        (self.repo / "lean" / "scripts").mkdir(parents=True)
        (self.repo / "lean" / "RelativeConicArcs").mkdir(parents=True)
        (self.repo / "lean" / "scripts" / "tool.py").write_text("x\n", encoding="utf-8")
        (self.repo / "lean" / "RelativeConicArcs" / "Base.lean").write_text("-- base\n", encoding="utf-8")
        self._git("add", "-A")
        self._git("commit", "-qm", "base")

    def _git(self, *args):
        subprocess.run(["git", *args], cwd=self.repo, check=True, capture_output=True)

    def test_clean_tree_has_no_intrusions(self):
        self.assertEqual(tx.worktree_intrusions(self.repo), [])

    def test_owned_edits_are_not_intrusions(self):
        (self.repo / "lean" / "scripts" / "tool.py").write_text("y\n", encoding="utf-8")
        (self.repo / "lean" / "trust").mkdir()
        (self.repo / "lean" / "trust" / "portfolio.toml").write_text("x = 1\n", encoding="utf-8")
        self.assertEqual(tx.worktree_intrusions(self.repo), [])

    def test_foreign_modification_is_an_intrusion(self):
        (self.repo / "lean" / "RelativeConicArcs" / "Base.lean").write_text("-- edited\n", encoding="utf-8")
        self.assertEqual(tx.worktree_intrusions(self.repo), ["lean/RelativeConicArcs/Base.lean"])

    def test_foreign_untracked_file_is_an_intrusion(self):
        (self.repo / "lean" / "RelativeConicArcs" / "New.lean").write_text("-- new\n", encoding="utf-8")
        self.assertIn("lean/RelativeConicArcs/New.lean", tx.worktree_intrusions(self.repo))

    def test_assert_quiet_window_names_the_intruding_path(self):
        (self.repo / "lean" / "RelativeConicArcs" / "Base.lean").write_text("-- edited\n", encoding="utf-8")
        with self.assertRaises(tx.Refused) as caught:
            tx.assert_quiet_window(self.repo)
        self.assertIn("lean/RelativeConicArcs/Base.lean", str(caught.exception))

    def test_assert_quiet_window_passes_when_clean(self):
        tx.assert_quiet_window(self.repo)


class CommandTests(unittest.TestCase):
    def test_tmpfs_scratch_is_refused_before_anything_else(self):
        # Ordering matters: the refusal must not depend on the unit or registry resolving first,
        # or a valid invocation would still be free to put a build tree in RAM.
        with self.assertRaises(tx.Refused) as caught:
            tx.cmd_run(
                argparse.Namespace(
                    lean_root=str(tx.LEAN_ROOT_DEFAULT),
                    repo_root=str(tx.LEAN_ROOT_DEFAULT.parent),
                    scratch="/tmp/whatever",
                    area=None,
                    unit=None,
                    no_uses=False,
                )
            )
        self.assertIn("tmpfs", str(caught.exception))

    def test_unknown_unit_is_refused_by_wrapper(self):
        with tempfile.TemporaryDirectory() as tmp:
            code = tx.main(
                [
                    "wrapper",
                    "Nope.Not.A.Unit",
                    "--out",
                    str(Path(tmp) / "w.lean"),
                ]
            )
            self.assertEqual(code, tx.EXIT_REFUSED)


if __name__ == "__main__":
    unittest.main(verbosity=1)
