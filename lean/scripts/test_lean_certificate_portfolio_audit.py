#!/usr/bin/env python3
"""Tests for the portfolio sweep's non-Lean payload and build-residue rules.

Both rules are path arithmetic against a Lake build tree, and both have a silent
failure mode: a wrong prefix reports a correctly built package as entirely stale, and
a loose reference match resolves a generator to an unrelated file of the same name.
"""

from __future__ import annotations

import importlib.util
import tempfile
import unittest
from pathlib import Path


SCRIPT = Path(__file__).with_name("lean-certificate-portfolio-audit.py")
_spec = importlib.util.spec_from_file_location("portfolio_audit", SCRIPT)
audit = importlib.util.module_from_spec(_spec)
assert _spec.loader is not None
_spec.loader.exec_module(audit)


class BuildResidueTests(unittest.TestCase):
    def build_artifact(self, root: Path, module: str, size: int = 16) -> None:
        for area, suffix in (("lib/lean", ".olean"), ("ir", ".c")):
            path = root / ".lake/build" / area / f"{module}{suffix}"
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_bytes(b"x" * size)

    def test_source_at_the_package_root_is_not_stale(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source = root / "Example/Leaf.lean"
            source.parent.mkdir(parents=True)
            source.write_text("def leaf := True\n", encoding="utf-8")
            self.build_artifact(root, "Example/Leaf")
            self.assertEqual(audit.stale_build_artifacts(root), {})

    def test_source_under_a_lakefile_source_directory_is_not_stale(self) -> None:
        """The layout every certificate package uses: modules under `lean/`."""
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source = root / "lean/Example/Leaf.lean"
            source.parent.mkdir(parents=True)
            source.write_text("def leaf := True\n", encoding="utf-8")
            self.build_artifact(root, "Example/Leaf")
            self.assertEqual(audit.stale_build_artifacts(root), {})

    def test_deleted_source_leaves_reported_residue(self) -> None:
        """What an extraction leaves behind: outputs of a module that is gone."""
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "Example").mkdir(parents=True)
            (root / "Example/Kept.lean").write_text("def kept := True\n", encoding="utf-8")
            self.build_artifact(root, "Example/Kept")
            self.build_artifact(root, "Example/Extracted")
            stale = audit.stale_build_artifacts(root)
            self.assertEqual(list(stale), [f"{root.name}/Example/Extracted"])
            self.assertEqual(stale[f"{root.name}/Example/Extracted"][0], 2)

    def test_a_build_one_level_below_the_root_is_swept(self) -> None:
        """The monorepo keeps its Lean package in `lean/`, not at the root."""
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            package = root / "lean"
            package.mkdir()
            self.build_artifact(package, "Example/Extracted")
            self.assertEqual(list(audit.stale_build_artifacts(root)), ["lean/Example/Extracted"])


class GeneratorReferenceTests(unittest.TestCase):
    def test_repository_relative_reference_resolves(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "notes").mkdir()
            (root / "notes/make.py").write_text("print('rows')\n", encoding="utf-8")
            self.assertEqual(
                audit.resolution(root, "notes/make.py"), "resident: notes/make.py"
            )

    def test_bare_basename_resolves_to_the_generator_beside_the_family(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "papers/certs").mkdir(parents=True)
            (root / "papers/certs/make.py").write_text("print('rows')\n", encoding="utf-8")
            self.assertEqual(
                audit.resolution(root, "make.py"), "resident: papers/certs/make.py"
            )

    def test_a_directory_qualified_reference_does_not_match_an_unrelated_file(self) -> None:
        """`verification/gluing/generate.py` is not any `generate.py` in the tree."""
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            vendored = root / "papers/site-packages/sympy/ntheory"
            vendored.mkdir(parents=True)
            (vendored / "generate.py").write_text("primes = []\n", encoding="utf-8")
            self.assertEqual(
                audit.resolution(root, "verification/gluing/generate.py"),
                "not in this root",
            )


if __name__ == "__main__":
    unittest.main()
