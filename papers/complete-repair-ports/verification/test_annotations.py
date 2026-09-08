#!/usr/bin/env python3
"""Mutation tests for the annotation gate, using disposable source-only fixtures."""
from __future__ import annotations

import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest

PAPER = Path(__file__).resolve().parents[1]


class AnnotationGate(unittest.TestCase):
    def setUp(self):
        self.scratch = tempfile.TemporaryDirectory(prefix="recovery-annotation-test-")
        self.addCleanup(self.scratch.cleanup)
        self.root = Path(self.scratch.name)
        for name in (PAPER / "verification/distribution-files.txt").read_text().splitlines():
            if name.endswith(".pdf"):
                continue
            target = self.root / name
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(PAPER / name, target)

    def edit(self, name, old, new):
        path = self.root / name
        text = path.read_text()
        self.assertIn(old, text)
        path.write_text(text.replace(old, new, 1))

    def gate(self, expected=None):
        result = subprocess.run(
            [sys.executable, str(self.root / "lean/verification/check_formal_artifact.py"), "--source-only"],
            capture_output=True, text=True, env={**os.environ, "PYTHONDONTWRITEBYTECODE": "1"},
        )
        if expected is None:
            self.assertEqual(result.returncode, 0, result.stderr)
        else:
            self.assertNotEqual(result.returncode, 0)
            self.assertIn(expected, result.stdout + result.stderr)

    def test_baseline(self):
        self.gate()

    def test_unknown_import(self):
        self.edit("sections/02-confinement-transfer.tex", "Luo:relative-profile", "Unknown:result")
        self.gate("unknown imports identifier")

    def test_unknown_evidence(self):
        self.edit("sections/02-confinement-transfer.tex", r"\coverage{complete}",
                  r"\coverage{complete}\evidence{Unknown:bundle}")
        self.gate("unknown evidence identifier")

    def test_coverage_mismatch(self):
        self.edit("sections/02-confinement-transfer.tex", r"\coverage{complete}", r"\coverage{absent}")
        self.gate("annotates coverage")

    def test_lean_terminal_mismatch(self):
        self.edit("sections/02-confinement-transfer.tex", r"\lean{helper_ker_le_helperCodeForTargetSpace",
                  r"\lean{missing_terminal")
        self.gate("Lean annotation mismatch")

    def test_unknown_dependency(self):
        self.edit("compositional_recovery.tex", r"\uses{thm:ungated-ranked-confinement}",
                  r"\uses{thm:unknown}")
        self.gate("unknown manuscript dependency")

    def test_unknown_proof_target(self):
        self.edit("sections/02-confinement-transfer.tex", r"\proves{prop:associated-pair}",
                  r"\proves{prop:unknown}")
        self.gate("detached proof names unknown")

    def test_proof_annotation_placement(self):
        name = "sections/02-confinement-transfer.tex"
        self.edit(name, r"\proves{prop:associated-pair}", "")
        self.edit(name, r"\begin{proof}", r"\begin{proof}\proves{prop:associated-pair}")
        self.gate("proof annotations must be together at the end")

    def test_statement_digest(self):
        self.edit("sections/02-confinement-transfer.tex", r"0\longrightarrow K_P", r"1\longrightarrow K_P")
        self.gate("statement digest mismatch")

    def test_terminal_digest(self):
        self.edit("lean/TavisRuddFiniteGeom/Papers/RecoveryStructures/AssociatedNestedCodePair.lean",
                  "LinearMap.ker helper ≤ helperCodeForTargetSpace", "LinearMap.ker helper = helperCodeForTargetSpace")
        self.gate("terminal digest mismatch")

    def test_registry_convention(self):
        p = self.root / "verification/imported-sources.json"
        data = json.loads(p.read_text())
        del next(iter(data["sources"].values()))["conventions"][0]["matched"]
        p.write_text(json.dumps(data))
        self.gate("incomplete convention")

    def test_stale_graph(self):
        p = self.root / "verification/dependency-graph.dot"
        p.write_text(p.read_text() + "// stale\n")
        self.gate("stale dependency graph")

    def test_corrupt_example_certificate(self):
        path = self.root / "verification/explicit-examples.json"
        path.write_text(path.read_text() + " ")
        self.gate("evidence checksum mismatch")

    def test_nonempty_macro(self):
        self.edit("formal-annotations.tex", r"\newcommand{\coverage}[1]{}",
                  r"\newcommand{\coverage}[1]{#1}")
        self.gate("six empty one-argument definitions")

    def test_unreferenced_section(self):
        self.edit("compositional_recovery.tex", r"\input{sections/09-contextual-refinement}", "")
        self.gate("manuscript claim partition mismatch")


if __name__ == "__main__":
    unittest.main()
