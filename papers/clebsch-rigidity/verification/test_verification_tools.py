#!/usr/bin/env python3
"""Unit tests for the Clebsch rigidity release-verification tools."""

from __future__ import annotations

import importlib.util
import sys
import tempfile
import unittest
from pathlib import Path


VERIFICATION = Path(__file__).resolve().parent
PAPER_ROOT = VERIFICATION.parent


def load(name: str, filename: str):
    spec = importlib.util.spec_from_file_location(name, VERIFICATION / filename)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {filename}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


extractor = load("rigidity_statement_extractor", "extract_statement_identity.py")
release = load("rigidity_release_runner", "verify_release.py")
capture = load("rigidity_checker_output_capture", "capture_checker_outputs.py")
manuscript = load("rigidity_manuscript_build", "check_manuscript_build.py")


class StatementIdentityTests(unittest.TestCase):
    def test_exact_nineteen_rows(self) -> None:
        payload = extractor.build_payload(PAPER_ROOT / "clebsch_rigidity.tex")
        self.assertEqual(payload["claim_count"], 19)
        self.assertEqual(
            [claim["row"] for claim in payload["claims"]],
            [2, *range(11, 27), 29, 58],
        )

    def test_all_statement_hashes_are_sha256(self) -> None:
        payload = extractor.build_payload(PAPER_ROOT / "clebsch_rigidity.tex")
        for claim in payload["claims"]:
            self.assertRegex(claim["sha256"], r"^[0-9a-f]{64}$")

    def test_duplicate_headline_is_rejected(self) -> None:
        source = (PAPER_ROOT / "clebsch_rigidity.tex").read_text(encoding="utf-8")
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "duplicate.tex"
            path.write_text(source + "\n" + extractor.HEADLINE + "\n", encoding="utf-8")
            with self.assertRaisesRegex(ValueError, "headline snippet"):
                extractor.build_payload(path)


class ReleaseRunnerTests(unittest.TestCase):
    def test_shell_commands_are_rejected(self) -> None:
        with self.assertRaisesRegex(ValueError, "may not invoke a shell"):
            release.command_argv(["bash", "-lc", "true"], "test")

    def test_argv_commands_are_admitted(self) -> None:
        self.assertEqual(
            release.command_argv(["python3", "checker.py"], "test"),
            ["python3", "checker.py"],
        )

    def test_parent_cwd_is_rejected(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            roots = {"paper": Path(directory)}
            with self.assertRaisesRegex(ValueError, "repository-relative"):
                release.safe_cwd(roots, "paper", "../outside", "test")

    def test_exact_checker_set_is_unique(self) -> None:
        self.assertEqual(len(capture.CHECKERS), 10)
        self.assertEqual(len(set(capture.CHECKERS)), 10)

    def test_manuscript_log_patterns(self) -> None:
        self.assertIsNone(manuscript.WARNING_RE.search("Package hyperref Info"))
        self.assertIsNotNone(manuscript.WARNING_RE.search("LaTeX Warning"))
        match = manuscript.PAGES_RE.search(
            "Output written on clebsch_rigidity.xdv (19 pages, 1 byte)."
        )
        self.assertIsNotNone(match)
        self.assertEqual(match.group(1), "19")


if __name__ == "__main__":
    unittest.main()
