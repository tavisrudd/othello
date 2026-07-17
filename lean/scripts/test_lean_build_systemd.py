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


class AcceptanceHandshakeTests(unittest.TestCase):
    def setUp(self) -> None:
        self.submission = {
            "run_id": "run-aaaaaaaabbbbccccddddeeeeeeeeeeee",
            "unit": "othello-lean-aaaaaaaabbbbccccddddeeeeeeeeeeee.service",
            "lean_root": "/fixture/lean",
            "worker_argv": ["/fixture/python", "/fixture/worker.py", "run"],
            "origin": {
                "harness": "codex",
                "session_id": "session-123456789",
                "work_lane": "build-sys",
                "task_id": "C225",
            },
            "manager_generation": {
                "boot_id": "12345678-1234-1234-1234-123456789abc",
                "dbus_owner": ":1.42",
                "manager_pid": 4321,
                "manager_start_ticks": 98765,
            },
        }
        self.digest = "a" * 64
        self.snapshot = {
            "Id": self.submission["unit"],
            "Transient": "yes",
            "InvocationID": "b" * 32,
            "WorkingDirectory": self.submission["lean_root"],
            "ExecStartArgv": self.submission["worker_argv"],
            "EnvironmentEntries": [
                f"OTHELLO_LEAN_RUN_ID={self.submission['run_id']}",
                f"OTHELLO_LEAN_SUBMISSION_SHA256={self.digest}",
            ],
        }

    def test_systemd_object_path_uses_bus_escaping(self) -> None:
        self.assertEqual(
            MODULE.systemd_object_path("othello-lean_a.service"),
            "/org/freedesktop/systemd1/unit/othello_2dlean_5fa_2eservice",
        )

    def test_transient_command_binds_identity_and_shutdown_contract(self) -> None:
        command = MODULE.transient_command(
            self.submission, self.digest, systemd_run=Path("/fixture/systemd-run")
        )
        self.assertEqual(command[0], "/fixture/systemd-run")
        self.assertIn("--wait", command)
        self.assertIn("--service-type=exec", command)
        self.assertIn(f"--unit={str(self.submission['unit']).removesuffix('.service')}", command)
        self.assertIn(f"--setenv=OTHELLO_LEAN_RUN_ID={self.submission['run_id']}", command)
        self.assertIn(f"--setenv=OTHELLO_LEAN_SUBMISSION_SHA256={self.digest}", command)
        self.assertIn("--property=KillMode=mixed", command)
        self.assertIn("--property=TimeoutStopSec=120s", command)
        self.assertEqual(command[-3:], self.submission["worker_argv"])

    def test_matching_snapshot_produces_stable_acceptance(self) -> None:
        accepted = MODULE.validate_acceptance_snapshot(
            self.submission,
            self.digest,
            self.snapshot,
            self.submission["manager_generation"],
        )
        self.assertEqual(accepted["invocation_id"], "b" * 32)
        self.assertEqual(accepted["submission_sha256"], self.digest)
        self.assertNotIn("accepted_utc", accepted)

    def test_each_identity_mismatch_is_rejected(self) -> None:
        cases = {
            "generation": (self.snapshot, {**self.submission["manager_generation"], "manager_pid": 9}),
            "unit": ({**self.snapshot, "Id": "foreign.service"}, self.submission["manager_generation"]),
            "transient": ({**self.snapshot, "Transient": "no"}, self.submission["manager_generation"]),
            "invocation": ({**self.snapshot, "InvocationID": ""}, self.submission["manager_generation"]),
            "working directory": ({**self.snapshot, "WorkingDirectory": "/wrong"}, self.submission["manager_generation"]),
            "argv": ({**self.snapshot, "ExecStartArgv": ["/wrong"]}, self.submission["manager_generation"]),
            "nonce": ({**self.snapshot, "EnvironmentEntries": []}, self.submission["manager_generation"]),
        }
        for label, (snapshot, generation) in cases.items():
            with self.subTest(label=label), self.assertRaises(MODULE.StateError):
                MODULE.validate_acceptance_snapshot(
                    self.submission, self.digest, snapshot, generation
                )

    def test_completion_reconciles_terminal_status_and_stable_event(self) -> None:
        status = {
            "format": 2,
            "run_id": self.submission["run_id"],
            "state": "success",
            "phase": "finished",
            "queue_exit_code": 0,
            "reason": None,
        }
        accepted = {"invocation_id": "b" * 32}
        service = {
            "Result": "success",
            "ExecMainStatus": "0",
            "InvocationID": "b" * 32,
        }
        completion = MODULE.completion_envelope(
            submission=self.submission,
            accepted=accepted,
            status=status,
            service=service,
            client_returncode=0,
        )
        self.assertEqual(completion["effective_state"], "success")
        self.assertEqual(completion["adapter_exit_code"], 0)
        self.assertEqual(
            completion["event_id"],
            f"lean-queue:{self.submission['run_id']}:terminal:1",
        )

    def test_completion_derives_failed_before_status_and_abandoned(self) -> None:
        accepted = {"invocation_id": "b" * 32}
        failed_before = MODULE.completion_envelope(
            submission=self.submission,
            accepted=accepted,
            status=None,
            service={"Result": "exit-code", "ExecMainStatus": "1", "InvocationID": "b" * 32},
            client_returncode=1,
        )
        self.assertEqual(failed_before["effective_state"], "failed-before-status")
        self.assertIsNone(failed_before["queue_exit_code"])
        nonterminal = MODULE.completion_envelope(
            submission=self.submission,
            accepted=accepted,
            status={
                "format": 2,
                "run_id": self.submission["run_id"],
                "state": "running",
                "phase": "building",
                "queue_exit_code": None,
            },
            service={"Result": "signal", "ExecMainStatus": "9", "InvocationID": "b" * 32},
            client_returncode=255,
        )
        self.assertEqual(nonterminal["effective_state"], "abandoned")
        self.assertEqual(nonterminal["adapter_exit_code"], 126)

    def test_completion_rejects_conflicting_terminal_exit(self) -> None:
        with self.assertRaisesRegex(MODULE.StateError, "conflict"):
            MODULE.completion_envelope(
                submission=self.submission,
                accepted={"invocation_id": "b" * 32},
                status={
                    "format": 2,
                    "run_id": self.submission["run_id"],
                    "state": "success",
                    "phase": "finished",
                    "queue_exit_code": 0,
                },
                service={"Result": "exit-code", "ExecMainStatus": "1", "InvocationID": "b" * 32},
                client_returncode=1,
            )


@unittest.skipUnless(
    os.environ.get("OTHELLO_SYSTEMD_LIVE_TEST") == "1",
    "set OTHELLO_SYSTEMD_LIVE_TEST=1 for the harmless real user-manager fixture",
)
class LiveAcceptanceHandshakeTest(unittest.TestCase):
    def setUp(self) -> None:
        TEST_ROOT.mkdir(mode=0o700, parents=True, exist_ok=True)
        self.tmp = Path(tempfile.mkdtemp(dir=TEST_ROOT))
        self.tmp.chmod(0o700)
        self.state_root = self.tmp / "managed"
        self.unit: str | None = None

    def tearDown(self) -> None:
        if self.unit is not None:
            for action in ("stop", "reset-failed"):
                subprocess.run(
                    [str(MODULE.SYSTEMCTL_DEFAULT), "--user", action, self.unit],
                    stdin=subprocess.DEVNULL,
                    stdout=subprocess.DEVNULL,
                    stderr=subprocess.DEVNULL,
                    check=False,
                )
        shutil.rmtree(self.tmp)

    def test_live_subscribe_reference_snapshot_and_wait(self) -> None:
        generation = MODULE.manager_generation()
        origin = MODULE.resolve_origin(
            harness="manual",
            session_id="c225-live-acceptance",
            work_lane=None,
            task_id=None,
            environ={},
        )
        run_dir, submission, digest = MODULE.prepare_submission(
            state_root=self.state_root,
            lean_root=self.tmp,
            worker_argv=["/run/current-system/sw/bin/sleep", "1"],
            origin=origin,
            generation=generation,
        )
        self.unit = str(submission["unit"])
        accepted, completion, stderr = MODULE.launch_accept_and_wait(
            run_dir=run_dir,
            submission=submission,
            submission_digest=digest,
            completion_timeout=10,
        )
        self.assertEqual(completion["adapter_exit_code"], MODULE.EXIT_INVALID, stderr)
        self.assertEqual(accepted["unit"], self.unit)
        self.assertEqual(json.loads((run_dir / "accepted.json").read_text()), accepted)
        self.assertEqual(json.loads((run_dir / "completion.json").read_text()), completion)


if __name__ == "__main__":
    unittest.main(verbosity=2)
