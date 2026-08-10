#!/usr/bin/env python3
"""Unit tests for the Clebsch rigidity release-verification tools."""

from __future__ import annotations

import importlib.util
import hashlib
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
builder = load("rigidity_trust_manifest_builder", "build_trust_manifest.py")
capture = load("rigidity_checker_output_capture", "capture_checker_outputs.py")
manuscript = load("rigidity_manuscript_build", "check_manuscript_build.py")
trust = load("rigidity_trust_manifest", "verify_trust_manifest.py")


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

    def test_project_import_closure_spans_three_roots(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            bridge = root / "bridge"
            certificate = root / "certificate"
            finitegeom = root / "finitegeom"
            gate = (
                bridge
                / "TavisRuddFiniteGeom"
                / "Papers"
                / "ClebschRigidity"
                / "CertificateCompatibility.lean"
            )
            dependency = finitegeom / "RelativeConicArcs" / "Shared.lean"
            certificate_leaf = (
                certificate
                / "TavisRuddFiniteGeom"
                / "Certificates"
                / "Q11"
                / "PointOrbits.lean"
            )
            gate.parent.mkdir(parents=True)
            dependency.parent.mkdir(parents=True)
            certificate_leaf.parent.mkdir(parents=True)
            gate.write_text(
                "import RelativeConicArcs.Shared\n"
                "import TavisRuddFiniteGeom.Certificates.Q11.PointOrbits\n",
                encoding="utf-8",
            )
            dependency.write_text("import Mathlib.Data.Fin.Basic\n", encoding="utf-8")
            certificate_leaf.write_text("", encoding="utf-8")
            paths = release.project_import_closure(
                {
                    "bridge": bridge,
                    "certificate": certificate,
                    "finitegeom": finitegeom,
                },
                release.BRIDGE_GATE,
            )
            self.assertEqual(
                paths["bridge"],
                ("TavisRuddFiniteGeom/Papers/ClebschRigidity/CertificateCompatibility.lean",),
            )
            self.assertEqual(
                paths["finitegeom"],
                ("RelativeConicArcs/Shared.lean",),
            )
            self.assertEqual(
                paths["certificate"],
                ("TavisRuddFiniteGeom/Certificates/Q11/PointOrbits.lean",),
            )

    def test_source_policy_ignores_prose_but_rejects_code(self) -> None:
        prose = "/- no `sorry` or `native_decide` is used -/\n-- unsafe is forbidden\n"
        self.assertEqual(release.lean_code_without_comments_or_strings(prose).strip(), "")
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            path = root / "Example.lean"
            path.write_text(prose + "theorem bad : True := by sorry\n", encoding="utf-8")
            with self.assertRaisesRegex(ValueError, "forbidden Lean source policy"):
                release.validate_source_policy(root, ("Example.lean",), "test")

    def test_sealed_bridge_contract_rejects_certificate_builds(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            certificate = root / "certificate"
            finitegeom = root / "finitegeom"
            bridge = root / "bridge"
            for path in (certificate, finitegeom, bridge):
                path.mkdir()
            manifest = {"roots": [release.CERTIFICATE_GATE]}
            manifest_path = certificate / release.CERTIFICATE_MANIFEST
            manifest_path.write_text(json.dumps(manifest), encoding="utf-8")
            evidence = certificate / "evidence" / "gate-axioms.log"
            evidence.parent.mkdir()
            evidence.write_text("sealed axioms\n", encoding="utf-8")
            (certificate / release.CERTIFICATE_TRUST_FACT).write_text(
                json.dumps(
                    {
                        "gate": release.CERTIFICATE_GATE,
                        "manifest_sha256": hashlib.sha256(
                            manifest_path.read_bytes()
                        ).hexdigest(),
                        "evidence": {
                            "axiom_log": "evidence/gate-axioms.log",
                            "axiom_log_sha256": hashlib.sha256(
                                evidence.read_bytes()
                            ).hexdigest(),
                        },
                    }
                ),
                encoding="utf-8",
            )
            pack = root / "q11.lake-pack.tar.gz"
            pack.write_bytes(b"sealed pack")
            artifacts = {
                "certificate": {"commit": "c" * 40},
                "shared-library": {"commit": "f" * 40},
                "paper-bridge": {"commit": "b" * 40},
            }
            (bridge / release.BRIDGE_MANIFEST).write_text(
                json.dumps(
                    {
                        "roots": [release.BRIDGE_GATE],
                        "dependencies": {
                            "finitegeom": "f" * 40,
                            "finitegeom-clebsch-q11-certificates": "c" * 40,
                        },
                        "certificate_cache_sha256": hashlib.sha256(
                            pack.read_bytes()
                        ).hexdigest(),
                    }
                ),
                encoding="utf-8",
            )
            safe_flake = "\n".join(
                (
                    ".lake/build/lib/lean/TavisRuddFiniteGeom/Certificates/Q11.olean",
                    ".lake/build/lib/lean/TavisRuddFiniteGeom/Certificates/Q11.trace",
                    '(cd "$certificate_root" && lake unpack "$certificate_pack")',
                    "sha256sum --check --status",
                    "lake env lean TavisRuddFiniteGeom/Papers/ClebschRigidity/CertificateCompatibility.lean",
                )
            )
            (bridge / "flake.nix").write_text(safe_flake, encoding="utf-8")
            release.validate_sealed_certificate_contract(
                certificate, finitegeom, bridge, pack, artifacts
            )
            (bridge / "flake.nix").write_text(
                safe_flake + '\n(cd "$certificate_root" && lake build Bad)\n',
                encoding="utf-8",
            )
            with self.assertRaisesRegex(ValueError, "certificate build"):
                release.validate_sealed_certificate_contract(
                    certificate, finitegeom, bridge, pack, artifacts
                )

    def test_guarded_receipt_requires_clean_pinned_source(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            run_dir = Path(directory)
            log = run_dir / "logs" / "gate.log"
            log.parent.mkdir()
            log.write_text("'Gate.theorem' depends on axioms: [propext]\n")
            (run_dir / "manifest.json").write_text(
                json.dumps(
                    {
                        "aggregate": [release.FINITEGEOM_GATE],
                        "lean_root": str(PAPER_ROOT),
                        "logs": {release.FINITEGEOM_GATE: str(log)},
                        "source": {"git_dirty": False, "git_head": "abc123"},
                    }
                ),
                encoding="utf-8",
            )
            (run_dir / "status.json").write_text(
                json.dumps(
                    {
                        "exit_code": 0,
                        "results": [{"outcome": "gate-passed"}],
                        "state": "success",
                    }
                ),
                encoding="utf-8",
            )
            result, transcript = release.guarded_finitegeom_result(
                run_dir, PAPER_ROOT, "abc123"
            )
            self.assertIn("Gate.theorem", result.stdout)
            self.assertEqual(transcript, log)
            manifest = json.loads(
                (run_dir / "manifest.json").read_text(encoding="utf-8")
            )
            manifest["source"]["git_dirty"] = True
            (run_dir / "manifest.json").write_text(
                json.dumps(manifest), encoding="utf-8"
            )
            with self.assertRaisesRegex(RuntimeError, "clean pinned finitegeom"):
                release.guarded_finitegeom_result(run_dir, PAPER_ROOT, "abc123")

    def test_guarded_receipt_follows_quiet_stdout_inside_run(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            run_dir = Path(directory)
            log = run_dir / "logs" / "gate.log"
            stdout = run_dir / "logs" / "quiet" / "stdout.log"
            stdout.parent.mkdir(parents=True)
            stdout.write_text("'Gate.full' depends on axioms: [propext]\n")
            log.write_text(f"stdout: 1002 lines -> {stdout}\n")
            (run_dir / "manifest.json").write_text(
                json.dumps(
                    {
                        "aggregate": [release.FINITEGEOM_GATE],
                        "lean_root": str(PAPER_ROOT),
                        "logs": {release.FINITEGEOM_GATE: str(log)},
                        "source": {"git_dirty": False, "git_head": "abc123"},
                    }
                )
            )
            (run_dir / "status.json").write_text(
                json.dumps(
                    {
                        "exit_code": 0,
                        "results": [{"outcome": "gate-passed"}],
                        "state": "success",
                    }
                )
            )
            result, transcript = release.guarded_finitegeom_result(
                run_dir, PAPER_ROOT, "abc123"
            )
            self.assertIn("Gate.full", result.stdout)
            self.assertNotIn("1002 lines", result.stdout)
            self.assertEqual(transcript, stdout)

    def test_guarded_receipt_rejects_quiet_stdout_outside_run(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            run_dir = root / "run"
            run_dir.mkdir()
            log = run_dir / "gate.log"
            outside = root / "outside.log"
            outside.write_text("untrusted\n")
            log.write_text(f"stdout: 1 lines -> {outside}\n")
            (run_dir / "manifest.json").write_text(
                json.dumps(
                    {
                        "aggregate": [release.FINITEGEOM_GATE],
                        "lean_root": str(PAPER_ROOT),
                        "logs": {release.FINITEGEOM_GATE: str(log)},
                        "source": {"git_dirty": False, "git_head": "abc123"},
                    }
                )
            )
            (run_dir / "status.json").write_text(
                json.dumps(
                    {
                        "exit_code": 0,
                        "results": [{"outcome": "gate-passed"}],
                        "state": "success",
                    }
                )
            )
            with self.assertRaisesRegex(RuntimeError, "outside its run"):
                release.guarded_finitegeom_result(run_dir, PAPER_ROOT, "abc123")

    def test_exact_checker_set_is_unique(self) -> None:
        self.assertEqual(len(capture.CHECKERS), 20)
        self.assertEqual(len({name for name, _ in capture.CHECKERS}), 20)

    def test_formal_checks_separate_human_gate_from_certificate_bridge(self) -> None:
        checks = {check["id"]: check for check in builder.checks()}
        self.assertEqual(len(checks), 27)
        self.assertEqual(
            checks["lean-finitegeom-trust-gate"]["argv"],
            ["guarded-finitegeom-run", release.FINITEGEOM_GATE],
        )
        bridge_argv = checks["lean-certificate-compatibility"]["argv"]
        self.assertEqual(bridge_argv[:4], ["nix", "run", ".#verify", "--"])
        self.assertNotIn("lake", bridge_argv)

    def test_builder_combines_human_and_sealed_certificate_axioms(self) -> None:
        axioms = builder.parse_axioms()
        expected = {
            terminal
            for terminals in builder.TERMINALS.values()
            for terminal in terminals
        }
        self.assertEqual(set(axioms), expected)
        self.assertIn(
            "TavisRuddFiniteGeom.Certificates.Q11.PointOrbits.twoGenerator_pointOrbit_partition",
            axioms,
        )

    def test_builder_terminal_partition_matches_separate_gates(self) -> None:
        certificate_terminals = set(builder.TERMINALS["orbits"])
        human_terminals = {
            terminal
            for group, terminals in builder.TERMINALS.items()
            if group != "orbits"
            for terminal in terminals
        }
        self.assertEqual(
            human_terminals,
            trust.parse_gate_terminals(
                builder.FINITEGEOM_ROOT / builder.FINITEGEOM_GATE_PATH
            ),
        )
        self.assertEqual(
            human_terminals,
            trust.parse_gate_terminals(
                builder.FINITEGEOM_ROOT / builder.FINITEGEOM_AUDIT_PATH
            ),
        )
        fact = json.loads(
            (
                builder.CERTIFICATE_ROOT / builder.CERTIFICATE_TRUST_FACT_PATH
            ).read_text(encoding="utf-8")
        )
        self.assertLessEqual(certificate_terminals, set(fact["declarations"]))

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
                "clebsch_rigidity.tex": 29,
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

    def test_exact_terminal_coverage_accepts_equal_sets(self) -> None:
        terminals = {"Gate.first", "Gate.second"}
        trust.require_exact_terminal_coverage(terminals, terminals, terminals)

    def test_exact_terminal_coverage_rejects_manifest_omission(self) -> None:
        with self.assertRaisesRegex(ValueError, "missing=.*Gate.second"):
            trust.require_exact_terminal_coverage(
                {"Gate.first"},
                {"Gate.first", "Gate.second"},
                {"Gate.first", "Gate.second"},
            )

    def test_gate_terminal_parser_rejects_duplicates(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            gate = Path(directory) / "Gate.lean"
            gate.write_text(
                "#print axioms Gate.first\n#print axioms Gate.first\n",
                encoding="utf-8",
            )
            with self.assertRaisesRegex(ValueError, "repeats"):
                trust.parse_gate_terminals(gate)


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
