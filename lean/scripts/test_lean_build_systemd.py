#!/usr/bin/env python3
"""Hermetic tests for the side-by-side C225 systemd adapter."""

from __future__ import annotations

import importlib.util
import hashlib
import json
import os
import shutil
import stat
import subprocess
import sys
import tempfile
import threading
import unittest
import uuid
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path


ADAPTER = Path(__file__).resolve().with_name("lean-build-systemd.py")
SPEC = importlib.util.spec_from_file_location("lean_build_systemd", ADAPTER)
assert SPEC is not None and SPEC.loader is not None
MODULE = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = MODULE
SPEC.loader.exec_module(MODULE)
TEST_ROOT = Path.home() / ".cache" / "othello-lean-build-systemd-tests"


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


class ManagerGenerationTests(unittest.TestCase):
    def setUp(self) -> None:
        TEST_ROOT.mkdir(mode=0o700, parents=True, exist_ok=True)
        self.tmp = Path(tempfile.mkdtemp(dir=TEST_ROOT))
        self.boot_id = self.tmp / "boot_id"
        self.boot_id.write_text("12345678-1234-1234-1234-123456789abc\n")
        self.proc_root = self.tmp / "proc"
        (self.proc_root / "4321").mkdir(parents=True)
        fields = ["S"] + ["0"] * 18 + ["98765"]
        (self.proc_root / "4321" / "stat").write_text(f"4321 (systemd user) {' '.join(fields)}\n")

    def tearDown(self) -> None:
        shutil.rmtree(self.tmp)

    def runner(self, owners: list[str]):
        owner_values = iter(owners)

        def run(command: list[str]) -> subprocess.CompletedProcess[str]:
            if command[6] == "GetNameOwner":
                output = f's "{next(owner_values)}"\n'
            else:
                self.assertEqual(command[6], "GetConnectionUnixProcessID")
                output = "u 4321\n"
            return subprocess.CompletedProcess(command, 0, output, "")

        return run

    def test_stable_owner_pid_start_tuple(self) -> None:
        generation = MODULE.manager_generation(
            busctl=Path("/fixture/busctl"),
            boot_id_path=self.boot_id,
            proc_root=self.proc_root,
            run_command=self.runner([":1.42", ":1.42"]),
        )
        self.assertEqual(
            generation,
            {
                "boot_id": "12345678-1234-1234-1234-123456789abc",
                "dbus_owner": ":1.42",
                "manager_pid": 4321,
                "manager_start_ticks": 98765,
            },
        )

    def test_manager_owner_race_is_rejected(self) -> None:
        with self.assertRaisesRegex(MODULE.StateError, "changed during generation"):
            MODULE.manager_generation(
                busctl=Path("/fixture/busctl"),
                boot_id_path=self.boot_id,
                proc_root=self.proc_root,
                run_command=self.runner([":1.42", ":1.43"]),
            )

    def test_malformed_bus_output_is_rejected(self) -> None:
        def malformed(command: list[str]) -> subprocess.CompletedProcess[str]:
            return subprocess.CompletedProcess(command, 0, "not-a-scalar\n", "")

        with self.assertRaisesRegex(MODULE.StateError, "unexpected busctl scalar"):
            MODULE.manager_generation(
                busctl=Path("/fixture/busctl"),
                boot_id_path=self.boot_id,
                proc_root=self.proc_root,
                run_command=malformed,
            )


class SubmissionIdentityTests(unittest.TestCase):
    def setUp(self) -> None:
        TEST_ROOT.mkdir(mode=0o700, parents=True, exist_ok=True)
        self.tmp = Path(tempfile.mkdtemp(dir=TEST_ROOT))
        self.tmp.chmod(0o700)
        self.lean_root = self.tmp / "lean"
        self.lean_root.mkdir()
        self.state_root = self.tmp / "managed"
        self.origin = {
            "user": "fixture",
            "harness": "manual",
            "session_id": "fixture-session",
            "work_lane": None,
            "task_id": None,
        }
        self.generation = {
            "boot_id": "12345678-1234-1234-1234-123456789abc",
            "dbus_owner": ":1.42",
            "manager_pid": 4321,
            "manager_start_ticks": 98765,
        }

    def tearDown(self) -> None:
        shutil.rmtree(self.tmp)

    def test_prepare_creates_restrictive_bound_submission(self) -> None:
        run_identity = uuid.UUID("aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee")
        run_dir, submission, digest = MODULE.prepare_submission(
            state_root=self.state_root,
            lean_root=self.lean_root,
            worker_argv=[sys.executable, "/fixture/worker.py", "run"],
            origin=self.origin,
            generation=self.generation,
            run_uuid=run_identity,
        )
        record = run_dir / "submission.json"
        encoded = record.read_bytes()
        self.assertEqual(stat.S_IMODE(self.state_root.stat().st_mode), 0o700)
        self.assertEqual(stat.S_IMODE(run_dir.stat().st_mode), 0o700)
        self.assertEqual(stat.S_IMODE(record.stat().st_mode), 0o600)
        self.assertEqual(hashlib.sha256(encoded).hexdigest(), digest)
        self.assertEqual(json.loads(encoded), submission)
        self.assertEqual(submission["run_id"], "run-aaaaaaaabbbbccccddddeeeeeeeeeeee")
        self.assertEqual(submission["unit"], "othello-lean-aaaaaaaabbbbccccddddeeeeeeeeeeee.service")
        self.assertEqual(submission["run_dir"], str(run_dir))
        self.assertEqual(submission["terminal_revision"], 1)

    def test_prepare_refuses_run_identity_reuse(self) -> None:
        identity = uuid.UUID("aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee")
        arguments = {
            "state_root": self.state_root,
            "lean_root": self.lean_root,
            "worker_argv": [sys.executable, "/fixture/worker.py"],
            "origin": self.origin,
            "generation": self.generation,
            "run_uuid": identity,
        }
        run_dir, _, _ = MODULE.prepare_submission(**arguments)
        with self.assertRaisesRegex(MODULE.StateError, "cannot create managed run directory"):
            MODULE.prepare_submission(**arguments)
        self.assertTrue((run_dir / "submission.json").is_file())

    def test_state_root_rejects_symlink_and_wrong_mode(self) -> None:
        real = self.tmp / "real"
        real.mkdir(mode=0o700)
        symlink = self.tmp / "link"
        symlink.symlink_to(real, target_is_directory=True)
        with self.assertRaisesRegex(MODULE.StateError, "non-symlink directory"):
            MODULE.ensure_state_root(symlink, os.geteuid())
        real.chmod(0o755)
        with self.assertRaisesRegex(MODULE.StateError, "mode must be 0700"):
            MODULE.ensure_state_root(real, os.geteuid())

    def test_worker_argv_requires_absolute_bounded_executable(self) -> None:
        with self.assertRaisesRegex(MODULE.StateError, "must be absolute"):
            MODULE.validate_worker_argv(["python3", "worker.py"])
        with self.assertRaisesRegex(MODULE.StateError, "argument exceeds"):
            MODULE.validate_worker_argv([sys.executable, "x" * (MODULE.MAX_ARG_BYTES + 1)])

    def test_set_once_is_idempotent_under_concurrent_publishers(self) -> None:
        self.state_root.mkdir(mode=0o700)
        path = self.state_root / "submission.json"
        barrier = threading.Barrier(8)

        def publish() -> str:
            barrier.wait()
            return MODULE.publish_set_once(path, {"format": 1, "run_id": "same"}, os.geteuid())

        with ThreadPoolExecutor(max_workers=8) as executor:
            digests = list(executor.map(lambda _: publish(), range(8)))
        self.assertEqual(len(set(digests)), 1)
        self.assertEqual(json.loads(path.read_text())["run_id"], "same")
        with self.assertRaisesRegex(MODULE.StateError, "conflicting set-once record"):
            MODULE.publish_set_once(path, {"format": 1, "run_id": "different"}, os.geteuid())


if __name__ == "__main__":
    unittest.main(verbosity=2)
