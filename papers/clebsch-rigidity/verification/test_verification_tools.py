#!/usr/bin/env python3
"""Unit tests for the Clebsch rigidity release-verification tools."""

from __future__ import annotations

import importlib.util
import json
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
            companion = PAPER_ROOT / "clebsch_rigidity_computational_companion.tex"
            path.with_name(companion.name).write_bytes(companion.read_bytes())
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

    def test_axiom_output_normalization(self) -> None:
        text = "'Example.theorem' depends on axioms: [propext,\n Classical.choice]"
        self.assertEqual(
            release.parse_axiom_output(text),
            {"Example.theorem": ["propext", "Classical.choice"]},
        )

    def test_axiom_audit_ignores_import_replay_noise(self) -> None:
        expected = {"Gate.theorem": ["propext"]}
        actual = {
            "Imported.theorem": ["Classical.choice"],
            "Gate.theorem": ["propext"],
        }
        self.assertTrue(release.matches_axiom_audit(expected, actual))
        self.assertFalse(release.matches_axiom_audit(expected, {}))

    def test_parent_cwd_is_rejected(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            roots = {"paper": Path(directory)}
            with self.assertRaisesRegex(ValueError, "repository-relative"):
                release.safe_cwd(roots, "paper", "../outside", "test")

    def test_exact_checker_set_is_unique(self) -> None:
        self.assertEqual(len(capture.CHECKERS), 20)
        self.assertEqual(len({name for name, _ in capture.CHECKERS}), 20)

    def test_manuscript_log_patterns(self) -> None:
        self.assertIsNone(manuscript.WARNING_RE.search("Package hyperref Info"))
        self.assertIsNotNone(manuscript.WARNING_RE.search("LaTeX Warning"))
        match = manuscript.PAGES_RE.search(
            "Output written on clebsch_rigidity.xdv (18 pages, 1 byte)."
        )
        self.assertIsNotNone(match)
        self.assertEqual(match.group(1), "18")
        self.assertEqual(
            manuscript.EXPECTED_PAGES,
            {
                "clebsch_rigidity.tex": 26,
                "clebsch_rigidity_computational_companion.tex": 13,
            },
        )

    def test_manuscript_build_is_pinned_to_a_fixed_timestamp(self) -> None:
        """The rebuilt PDF can only be compared byte for byte if dates are pinned."""
        environment = manuscript.deterministic_environment()
        self.assertEqual(
            environment["SOURCE_DATE_EPOCH"], manuscript.DETERMINISTIC_EPOCH
        )
        self.assertEqual(environment["FORCE_SOURCE_DATE"], "1")

    def test_manuscript_check_rejects_a_stale_tracked_pdf(self) -> None:
        """A tracked PDF differing from the fresh build must fail, not be accepted.

        The build itself is substituted, so this exercises the staleness
        comparison without repeating the release runner's own manuscript build.
        """
        source_name = "clebsch_rigidity.tex"
        original_build = manuscript.build_pdf
        with tempfile.TemporaryDirectory() as directory:
            paper_root = Path(directory)
            (paper_root / source_name).write_bytes(b"unused source")
            (paper_root / "clebsch_rigidity.pdf").write_bytes(b"tracked bytes")
            manuscript.build_pdf = lambda *_: b"freshly built bytes"
            try:
                with self.assertRaises(RuntimeError) as caught:
                    manuscript.check_source(paper_root, source_name, 26, update=False)
                self.assertIn("is stale", str(caught.exception))
                manuscript.check_source(paper_root, source_name, 26, update=True)
                self.assertEqual(
                    (paper_root / "clebsch_rigidity.pdf").read_bytes(),
                    b"freshly built bytes",
                )
                manuscript.check_source(paper_root, source_name, 26, update=False)
            finally:
                manuscript.build_pdf = original_build


class ManifestSemanticTests(unittest.TestCase):
    def manifest(self) -> dict[str, object]:
        return json.loads(
            (VERIFICATION / "trust_manifest.json").read_text(encoding="utf-8")
        )

    def test_computation_routes_use_structured_admitted_commands(self) -> None:
        payload = self.manifest()
        admitted = {
            tuple(check["argv"])
            for check in payload["verify_all"]["checks"]
            if check["id"].startswith("check-")
        }
        for claim in payload["claims"]:
            for computation in release_claim_computations(claim):
                commands = computation["checker_commands"]
                self.assertTrue(commands)
                self.assertNotIn("checker", computation)
                for command in commands:
                    self.assertIn(tuple(command["argv"]), admitted)

    def test_computation_routes_state_specific_coverage(self) -> None:
        for claim in self.manifest()["claims"]:
            for computation in release_claim_computations(claim):
                self.assertNotIn(
                    "finite field, arc, syndrome, conic, or neighbour",
                    computation["coverage"],
                )

    def test_transitive_citation_boundaries_are_explicit(self) -> None:
        claims = {claim["row"]: claim for claim in self.manifest()["claims"]}
        for row, fragments in {
            17: ("Dye 1991",),
            25: ("Dye 1991", "Abiad--Jabal Ameli--Reijnders"),
            26: ("discussion preceding Theorem 6",),
            29: ("Dye 1991", "Abiad--Jabal Ameli--Reijnders"),
        }.items():
            text = json.dumps(claims[row], sort_keys=True)
            for fragment in fragments:
                self.assertIn(fragment, text)


def release_claim_computations(claim: dict[str, object]) -> list[dict[str, object]]:
    computations = []
    if isinstance(claim.get("computation"), dict):
        computations.append(claim["computation"])
    for component in claim.get("components", []):
        if isinstance(component.get("computation"), dict):
            computations.append(component["computation"])
    return computations


if __name__ == "__main__":
    unittest.main()
