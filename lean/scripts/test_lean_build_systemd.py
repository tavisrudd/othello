#!/usr/bin/env python3
"""Hermetic tests for the side-by-side C225 systemd adapter."""

from __future__ import annotations

import importlib.util
import os
import subprocess
import sys
import unittest
from pathlib import Path


ADAPTER = Path(__file__).resolve().with_name("lean-build-systemd.py")
SPEC = importlib.util.spec_from_file_location("lean_build_systemd", ADAPTER)
assert SPEC is not None and SPEC.loader is not None
MODULE = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = MODULE
SPEC.loader.exec_module(MODULE)


class OriginResolutionTests(unittest.TestCase):
    def resolve(self, environ: dict[str, str] | None = None, **overrides: str | None) -> dict[str, object]:
        arguments = {
            "harness": None,
            "session_id": None,
            "work_lane": None,
            "task_id": None,
            "environ": {} if environ is None else environ,
        }
        arguments.update(overrides)
        return MODULE.resolve_origin(**arguments)

    def test_cli_wins_and_records_every_conflicting_lower_source(self) -> None:
        origin = self.resolve(
            environ={
                "OTHELLO_HARNESS": "claude",
                "OTHELLO_SESSION_ID": "env-session",
                "OTHELLO_LANE": "cap",
                "OTHELLO_TASK_ID": "C100",
                "CODEX_THREAD_ID": "native-session",
            },
            harness="codex",
            session_id="cli-session",
            work_lane="build-sys",
            task_id="C225",
        )
        self.assertEqual(
            [origin[key] for key in ("harness", "session_id", "work_lane", "task_id")],
            ["codex", "cli-session", "build-sys", "C225"],
        )
        fields = [item["field"] for item in origin["resolution"]["conflicts"]]
        self.assertEqual(fields.count("harness"), 1)
        self.assertEqual(fields.count("session_id"), 2)
        self.assertIn("work_lane", fields)
        self.assertIn("task_id", fields)

    def test_codex_native_session_identifies_harness_and_fills_session(self) -> None:
        origin = self.resolve(
            environ={
                "CODEX_THREAD_ID": "019f6c8b-d2a1-7f60-965a-0b68b1237d7e",
                "OTHELLO_LANE": "build-sys",
                "OTHELLO_TASK_ID": "C225",
            }
        )
        self.assertEqual(origin["harness"], "codex")
        self.assertEqual(origin["session_id"], "019f6c8b-d2a1-7f60-965a-0b68b1237d7e")
        self.assertEqual(origin["resolution"]["sources"]["session_id"], "native:CODEX_THREAD_ID")

    def test_cli_lane_and_task_override_session_defaults(self) -> None:
        origin = self.resolve(
            environ={
                "OTHELLO_HARNESS": "codex",
                "OTHELLO_SESSION_ID": "same-session",
                "OTHELLO_LANE": "cap",
                "OTHELLO_TASK_ID": "C200",
            },
            work_lane="build-sys",
            task_id="C225",
        )
        self.assertEqual(origin["work_lane"], "build-sys")
        self.assertEqual(origin["task_id"], "C225")

    def test_empty_environment_values_are_absent(self) -> None:
        origin = self.resolve(
            environ={
                "OTHELLO_HARNESS": " ",
                "OTHELLO_SESSION_ID": "",
                "OTHELLO_LANE": "\t",
                "OTHELLO_TASK_ID": "",
            },
            harness="manual",
            session_id="manual-probe-1",
        )
        self.assertEqual(origin["attestation"], "manual-non-task")
        self.assertIsNone(origin["work_lane"])
        self.assertIsNone(origin["task_id"])

    def test_explicit_empty_cli_value_is_invalid(self) -> None:
        with self.assertRaisesRegex(MODULE.OriginError, "must not be empty"):
            self.resolve(harness="manual", session_id=" ")

    def test_invalid_selected_values_are_rejected(self) -> None:
        cases = (
            ({"harness": "robot"}, "invalid harness"),
            ({"harness": "codex", "session_id": "bad space", "work_lane": "build-sys", "task_id": "C225"}, "invalid session ID"),
            ({"harness": "codex", "session_id": "session", "work_lane": "BuildSys", "task_id": "C225"}, "invalid work lane"),
            ({"harness": "codex", "session_id": "session", "work_lane": "build-sys", "task_id": "225"}, "invalid task ID"),
        )
        for arguments, message in cases:
            with self.subTest(arguments=arguments), self.assertRaisesRegex(MODULE.OriginError, message):
                self.resolve(**arguments)

    def test_invalid_value_diagnostic_is_bounded(self) -> None:
        with self.assertRaises(MODULE.OriginError) as captured:
            self.resolve(harness="x" * 10000)
        self.assertLess(len(str(captured.exception)), 250)
        self.assertIn("<truncated>", str(captured.exception))

    def test_agent_scope_is_required(self) -> None:
        cases = (
            ({"harness": "codex", "work_lane": "build-sys", "task_id": "C225"}, "session ID"),
            ({"harness": "codex", "session_id": "session", "task_id": "C225"}, "work lane"),
            ({"harness": "codex", "session_id": "session", "work_lane": "build-sys"}, "C-task"),
        )
        for arguments, message in cases:
            with self.subTest(arguments=arguments), self.assertRaisesRegex(MODULE.OriginError, message):
                self.resolve(**arguments)

    def test_claude_does_not_adopt_codex_native_session(self) -> None:
        with self.assertRaisesRegex(MODULE.OriginError, "session ID"):
            self.resolve(
                environ={"CODEX_THREAD_ID": "codex-session"},
                harness="claude",
                work_lane="build-sys",
                task_id="C225",
            )

    def test_manual_probe_rejects_lane_or_task_claims(self) -> None:
        for field, value in (("work_lane", "build-sys"), ("task_id", "C225")):
            with self.subTest(field=field), self.assertRaisesRegex(MODULE.OriginError, "manual probes"):
                self.resolve(harness="manual", session_id="manual-probe", **{field: value})


class OriginCliTests(unittest.TestCase):
    def test_cli_emits_one_json_object(self) -> None:
        environment = os.environ.copy()
        for name in (
            "OTHELLO_HARNESS",
            "OTHELLO_SESSION_ID",
            "OTHELLO_LANE",
            "OTHELLO_TASK_ID",
            "CODEX_THREAD_ID",
        ):
            environment.pop(name, None)
        result = subprocess.run(
            [sys.executable, str(ADAPTER), "resolve-origin", "--harness", "manual", "--session-id", "probe-1"],
            env=environment,
            stdin=subprocess.DEVNULL,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            check=False,
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(result.stdout.count("\n"), 1)
        self.assertIn('"harness":"manual"', result.stdout)

    def test_cli_invalid_origin_uses_reserved_code(self) -> None:
        environment = os.environ.copy()
        for name in (
            "OTHELLO_HARNESS",
            "OTHELLO_SESSION_ID",
            "OTHELLO_LANE",
            "OTHELLO_TASK_ID",
            "CODEX_THREAD_ID",
        ):
            environment.pop(name, None)
        result = subprocess.run(
            [sys.executable, str(ADAPTER), "resolve-origin", "--harness", "codex"],
            env=environment,
            stdin=subprocess.DEVNULL,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            check=False,
        )
        self.assertEqual(result.returncode, MODULE.EXIT_INVALID)
        self.assertEqual(result.stdout, "")
        self.assertIn("session ID is required", result.stderr)


if __name__ == "__main__":
    unittest.main(verbosity=2)
