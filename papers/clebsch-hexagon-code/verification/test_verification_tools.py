#!/usr/bin/env python3
"""Focused tests for the Clebsch release-verification tools."""

from __future__ import annotations

import hashlib
import sys
import unittest
from pathlib import Path


VERIFICATION_ROOT = Path(__file__).resolve().parent
PAPER_ROOT = VERIFICATION_ROOT.parent
REPOSITORY_ROOT = PAPER_ROOT.parents[1]
sys.path.insert(0, str(VERIFICATION_ROOT))

from extract_gate_audits import extract_gate  # noqa: E402
from extract_statement_adequacy import extract  # noqa: E402
from verify_release import command_argv  # noqa: E402
from verify_trust_manifest import (  # noqa: E402
    validate_checks,
    validate_file,
    validate_lean,
)


class StatementExtractionTests(unittest.TestCase):
    def test_manuscript_statements_have_unique_content_keys(self) -> None:
        statements = extract(PAPER_ROOT / "clebsch_hexagon_code.tex")
        self.assertTrue(statements)
        rows = [statement.as_json() for statement in statements]
        keys = [row["claim_key"] for row in rows]
        self.assertEqual(len(keys), len(set(keys)))
        self.assertTrue(all(len(str(row["sha256"])) == 64 for row in rows))


class GateExtractionTests(unittest.TestCase):
    def test_arithmetic_gluing_gate_has_complete_embedded_surface(self) -> None:
        path = Path(
            "lean/RelativeConicArcs/Gates/ClebschArithmeticGluing.lean"
        )
        gate = extract_gate(REPOSITORY_ROOT / path)
        self.assertTrue(gate["audit_embedded"])
        self.assertEqual(gate["terminal_count"], 23)
        self.assertEqual(len(gate["terminals"]), len(set(gate["terminals"])))


class CommandValidationTests(unittest.TestCase):
    def test_shell_command_is_rejected(self) -> None:
        with self.assertRaisesRegex(ValueError, "may not invoke a shell"):
            command_argv(["bash", "-c", "true"], "check.argv")

    def test_argv_check_accepts_a_bounded_direct_command(self) -> None:
        checks = [
            {
                "id": "statement-extraction",
                "cwd": "papers/clebsch-hexagon-code",
                "argv": [
                    "python3",
                    "verification/extract_statement_adequacy.py",
                ],
                "timeout_seconds": 60,
            }
        ]
        validate_checks(checks, "checks", REPOSITORY_ROOT)


class EvidenceBindingTests(unittest.TestCase):
    gate_path = Path(
        "lean/RelativeConicArcs/Gates/ClebschArithmeticGluing.lean"
    )

    def file_evidence(self, path: Path) -> dict[str, str]:
        return {
            "path": path.as_posix(),
            "sha256": hashlib.sha256(
                (REPOSITORY_ROOT / path).read_bytes()
            ).hexdigest(),
        }

    def test_tracked_gate_can_serve_as_its_embedded_audit(self) -> None:
        gate = extract_gate(REPOSITORY_ROOT / self.gate_path)
        terminal = str(gate["terminals"][0])
        evidence = {
            "gate": self.file_evidence(self.gate_path),
            "audit": self.file_evidence(self.gate_path),
            "terminals": [terminal],
            "axioms": {terminal: []},
            "validation": {
                "command": "exact-target gate validation",
                "output": self.file_evidence(self.gate_path),
            },
        }
        validate_lean(evidence, "lean", REPOSITORY_ROOT)

    def test_hash_mismatch_is_rejected(self) -> None:
        evidence = self.file_evidence(self.gate_path)
        evidence["sha256"] = "0" * 64
        with self.assertRaisesRegex(ValueError, "does not match"):
            validate_file(evidence, "gate", REPOSITORY_ROOT)


if __name__ == "__main__":
    unittest.main()
