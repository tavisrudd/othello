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


class ReattachmentTests(unittest.TestCase):
    def setUp(self) -> None:
        TEST_ROOT.mkdir(mode=0o700, parents=True, exist_ok=True)
        self.tmp = Path(tempfile.mkdtemp(dir=TEST_ROOT))
        self.tmp.chmod(0o700)
        self.generation = {
            "boot_id": "12345678-1234-1234-1234-123456789abc",
            "dbus_owner": ":1.42",
            "manager_pid": 4321,
            "manager_start_ticks": 98765,
        }
        self.run_dir, self.submission, self.digest = MODULE.prepare_submission(
            state_root=self.tmp / "managed",
            lean_root=self.tmp,
            worker_argv=[sys.executable, "/fixture/worker.py"],
            origin={
                "user": "fixture",
                "harness": "codex",
                "session_id": "fixture-session",
                "work_lane": "build-sys",
                "task_id": "C225",
            },
            generation=self.generation,
        )
        self.accepted = {
            "format": 1,
            "run_id": self.submission["run_id"],
            "unit": self.submission["unit"],
            "invocation_id": "b" * 32,
            "manager_generation": self.generation,
            "submission_sha256": self.digest,
        }
        MODULE.publish_set_once(
            self.run_dir / "accepted.json", self.accepted, os.geteuid()
        )

    def tearDown(self) -> None:
        shutil.rmtree(self.tmp)

    def write_status(self, state: str, phase: str, exit_code: int | None) -> None:
        path = self.run_dir / "status.json"
        temporary = path.with_suffix(".tmp")
        temporary.write_text(
            json.dumps(
                {
                    "format": 2,
                    "run_id": self.submission["run_id"],
                    "state": state,
                    "phase": phase,
                    "queue_exit_code": exit_code,
                    "reason": None,
                }
            )
            + "\n"
        )
        temporary.chmod(0o600)
        temporary.replace(path)

    def active(self) -> dict[str, object]:
        return {
            "Id": self.submission["unit"],
            "InvocationID": self.accepted["invocation_id"],
            "ActiveState": "active",
            "SubState": "running",
            "Result": "success",
            "ExecMainStatus": "0",
        }

    def inactive(self, result: str = "success", code: int = 0) -> dict[str, object]:
        return {
            **self.active(),
            "ActiveState": "inactive" if result == "success" else "failed",
            "SubState": "dead" if result == "success" else "failed",
            "Result": result,
            "ExecMainStatus": str(code),
        }

    def fixture_lease(self, on_wait=None):
        class Lease:
            def __init__(inner_self) -> None:
                inner_self.referenced: list[str] = []
                inner_self.waits = 0

            def __enter__(inner_self):
                return inner_self

            def __exit__(inner_self, *_args) -> None:
                pass

            def ref_unit(inner_self, unit: str) -> None:
                inner_self.referenced.append(unit)

            def wait_for_change(inner_self, _timeout: float) -> bool:
                inner_self.waits += 1
                if on_wait is not None:
                    on_wait()
                return True

        lease = Lease()
        return lease, lambda: lease

    def snapshot_sequence(self, snapshots: list[dict[str, object] | None]):
        values = iter(snapshots)
        last = snapshots[-1]

        def read(_unit: str, **_kwargs):
            nonlocal last
            try:
                last = next(values)
            except StopIteration:
                pass
            return last

        return read

    def successful_command(self, command):
        return subprocess.CompletedProcess(command, 0, "", "")

    def test_subscribe_ref_snapshot_wake_reread_and_terminal_capture(self) -> None:
        self.write_status("running", "building", None)
        lease, factory = self.fixture_lease(
            lambda: self.write_status("success", "finished", 0)
        )
        notifications: list[dict[str, object]] = []
        completion, diagnostic = MODULE.reattach_and_wait(
            run_dir=self.run_dir,
            timeout=2,
            lease_factory=factory,
            snapshot_reader=self.snapshot_sequence(
                [self.active(), self.active(), self.inactive()]
            ),
            generation_reader=lambda: self.generation,
            notify_callback=notifications.append,
            run_command=self.successful_command,
        )
        self.assertEqual(completion["effective_state"], "success", diagnostic)
        self.assertEqual(lease.referenced, [self.submission["unit"]])
        self.assertEqual(lease.waits, 1)
        self.assertEqual(notifications, [completion])
        self.assertEqual(json.loads((self.run_dir / "completion.json").read_text()), completion)

    def test_garbage_collected_unit_resolves_from_terminal_disk_status(self) -> None:
        self.write_status("success", "finished", 0)
        lease, factory = self.fixture_lease()
        completion, _ = MODULE.reattach_and_wait(
            run_dir=self.run_dir,
            lease_factory=factory,
            snapshot_reader=self.snapshot_sequence([None]),
            generation_reader=lambda: self.generation,
        )
        self.assertEqual(completion["effective_state"], "success")
        self.assertEqual(lease.referenced, [])
        self.assertEqual(lease.waits, 0)

    def test_unit_removed_wake_with_nonterminal_status_is_unknown(self) -> None:
        self.write_status("running", "building", None)
        lease, factory = self.fixture_lease()
        observation, _ = MODULE.reattach_and_wait(
            run_dir=self.run_dir,
            timeout=2,
            lease_factory=factory,
            snapshot_reader=self.snapshot_sequence([self.active(), self.active(), None]),
            generation_reader=lambda: self.generation,
        )
        self.assertEqual(observation["effective_state"], "unknown")
        self.assertEqual(lease.waits, 1)
        self.assertFalse((self.run_dir / "completion.json").exists())

    def test_timeout_is_non_mutating_and_does_not_wait_when_already_expired(self) -> None:
        self.write_status("queued", "waiting-for-lock", None)
        lease, factory = self.fixture_lease()
        observation, _ = MODULE.reattach_and_wait(
            run_dir=self.run_dir,
            timeout=0,
            lease_factory=factory,
            snapshot_reader=self.snapshot_sequence(
                [self.active(), self.active(), self.active()]
            ),
            generation_reader=lambda: self.generation,
        )
        self.assertEqual(observation["adapter_exit_code"], MODULE.EXIT_TIMEOUT)
        self.assertEqual(lease.waits, 0)
        self.assertFalse((self.run_dir / "completion.json").exists())
        for invalid in (-1, float("nan"), float("inf")):
            with self.subTest(timeout=invalid), self.assertRaisesRegex(
                MODULE.StateError, "finite nonnegative"
            ):
                MODULE.reattach_and_wait(run_dir=self.run_dir, timeout=invalid)

    def test_failed_before_status_uses_bound_service_evidence(self) -> None:
        lease, factory = self.fixture_lease()
        completion, _ = MODULE.reattach_and_wait(
            run_dir=self.run_dir,
            lease_factory=factory,
            snapshot_reader=self.snapshot_sequence(
                [self.inactive("exit-code", 1), self.inactive("exit-code", 1)]
            ),
            generation_reader=lambda: self.generation,
            run_command=self.successful_command,
        )
        self.assertEqual(completion["effective_state"], "failed-before-status")
        self.assertIsNone(completion["canonical_state"])

    def test_manager_restart_and_invocation_mismatch_fail_closed(self) -> None:
        lease, factory = self.fixture_lease()
        observation, _ = MODULE.reattach_and_wait(
            run_dir=self.run_dir,
            lease_factory=factory,
            snapshot_reader=self.snapshot_sequence([self.active()]),
            generation_reader=lambda: {**self.generation, "manager_pid": 9},
        )
        self.assertEqual(observation["effective_state"], "unknown")
        mismatched = {**self.active(), "InvocationID": "c" * 32}
        with self.assertRaisesRegex(MODULE.StateError, "InvocationID mismatch"):
            MODULE.reattach_and_wait(
                run_dir=self.run_dir,
                lease_factory=factory,
                snapshot_reader=self.snapshot_sequence([mismatched, mismatched]),
                generation_reader=lambda: self.generation,
            )

    def test_existing_completion_is_validated_and_redelivered_by_event_id(self) -> None:
        self.write_status("success", "finished", 0)
        completion = MODULE.completion_envelope(
            submission=self.submission,
            accepted=self.accepted,
            status=json.loads((self.run_dir / "status.json").read_text()),
            service=None,
            client_returncode=0,
        )
        MODULE.publish_set_once(
            self.run_dir / "completion.json", completion, os.geteuid()
        )
        notifications: list[dict[str, object]] = []
        returned, diagnostic = MODULE.reattach_and_wait(
            run_dir=self.run_dir,
            notify_callback=notifications.append,
        )
        self.assertEqual(returned, completion, diagnostic)
        self.assertEqual(notifications, [completion])

    def test_malformed_status_identity_is_not_reported_as_unknown(self) -> None:
        self.write_status("running", "building", None)
        status_path = self.run_dir / "status.json"
        status = json.loads(status_path.read_text())
        status["run_id"] = "run-foreign"
        status_path.write_text(json.dumps(status) + "\n")
        status_path.chmod(0o600)
        lease, factory = self.fixture_lease()
        with self.assertRaisesRegex(MODULE.StateError, "status identity"):
            MODULE.reattach_and_wait(
                run_dir=self.run_dir,
                lease_factory=factory,
                snapshot_reader=self.snapshot_sequence([None]),
                generation_reader=lambda: self.generation,
            )


class ManagedListTests(unittest.TestCase):
    def setUp(self) -> None:
        TEST_ROOT.mkdir(mode=0o700, parents=True, exist_ok=True)
        self.tmp = Path(tempfile.mkdtemp(dir=TEST_ROOT))
        self.tmp.chmod(0o700)
        self.state_root = self.tmp / "managed"
        self.lean_root = self.tmp / "lean"
        self.lean_root.mkdir()
        self.generation = {
            "boot_id": "12345678-1234-1234-1234-123456789abc",
            "dbus_owner": ":1.42",
            "manager_pid": 4321,
            "manager_start_ticks": 98765,
        }

    def tearDown(self) -> None:
        shutil.rmtree(self.tmp)

    def make_run(
        self,
        identity: str,
        session: str,
        *,
        harness: str = "codex",
        state: str | None = None,
    ) -> tuple[Path, dict[str, object], dict[str, object] | None]:
        run_dir, submission, digest = MODULE.prepare_submission(
            state_root=self.state_root,
            lean_root=self.lean_root,
            worker_argv=[sys.executable, "/fixture/worker.py"],
            origin={
                "user": "fixture",
                "harness": harness,
                "session_id": session,
                "work_lane": "build-sys",
                "task_id": "C225",
            },
            generation=self.generation,
            run_uuid=uuid.UUID(identity),
        )
        accepted = None
        if state is not None:
            accepted = {
                "format": 1,
                "run_id": submission["run_id"],
                "unit": submission["unit"],
                "invocation_id": identity.replace("-", ""),
                "manager_generation": self.generation,
                "submission_sha256": digest,
            }
            MODULE.publish_set_once(run_dir / "accepted.json", accepted, os.geteuid())
            status = {
                "format": 2,
                "run_id": submission["run_id"],
                "state": state,
                "phase": "finished" if state in {"success", "failed"} else "building",
                "queue_exit_code": 0 if state == "success" else None,
            }
            MODULE.publish_set_once(run_dir / "status.json", status, os.geteuid())
        return run_dir, submission, accepted

    def test_list_combines_active_and_completed_rows_with_full_origin(self) -> None:
        active_dir, active_submission, active_accepted = self.make_run(
            "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee",
            "shared-session-active-123456789",
            state="running",
        )
        complete_dir, complete_submission, complete_accepted = self.make_run(
            "11111111-2222-3333-4444-555555555555",
            "shared-session-complete-987654321",
            harness="claude",
            state="success",
        )
        assert complete_accepted is not None
        completion = MODULE.completion_envelope(
            submission=complete_submission,
            accepted=complete_accepted,
            status=json.loads((complete_dir / "status.json").read_text()),
            service={
                "Result": "success",
                "ExecMainStatus": "0",
                "InvocationID": complete_accepted["invocation_id"],
            },
            client_returncode=0,
        )
        MODULE.publish_set_once(complete_dir / "completion.json", completion, os.geteuid())
        snapshots: list[str] = []

        def snapshot(unit: str) -> dict[str, object]:
            snapshots.append(unit)
            assert active_accepted is not None
            return {
                "InvocationID": active_accepted["invocation_id"],
                "ActiveState": "active",
            }

        payload, diagnostics = MODULE.list_managed_runs(
            state_root=self.state_root,
            generation_reader=lambda: self.generation,
            snapshot_reader=snapshot,
        )
        self.assertEqual(diagnostics, [])
        self.assertEqual(len(payload["rows"]), 2)
        by_id = {row["run_id"]: row for row in payload["rows"]}
        self.assertEqual(by_id[active_submission["run_id"]]["effective_state"], "running")
        self.assertEqual(by_id[complete_submission["run_id"]]["effective_state"], "success")
        self.assertEqual(
            by_id[active_submission["run_id"]]["session"],
            "shared-session-active-123456789",
        )
        self.assertEqual(by_id[complete_submission["run_id"]]["harness"], "claude")
        self.assertEqual(snapshots, [active_submission["unit"]])
        self.assertEqual(active_dir.parent, self.state_root)
        active_only, _ = MODULE.list_managed_runs(
            state_root=self.state_root,
            limit=1,
            generation_reader=lambda: self.generation,
            snapshot_reader=snapshot,
        )
        self.assertEqual(active_only["rows"][0]["run_id"], active_submission["run_id"])

    def test_list_skips_unsafe_entry_and_reports_manager_loss_as_unknown(self) -> None:
        _, submission, _ = self.make_run(
            "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee", "fixture-session", state="running"
        )
        unsafe = self.state_root / "run-11111111222233334444555555555555"
        unsafe.symlink_to(self.lean_root, target_is_directory=True)
        payload, diagnostics = MODULE.list_managed_runs(
            state_root=self.state_root,
            generation_reader=lambda: (_ for _ in ()).throw(MODULE.StateError("unavailable")),
        )
        self.assertEqual(payload["rows"][0]["run_id"], submission["run_id"])
        self.assertEqual(payload["rows"][0]["effective_state"], "unknown")
        self.assertEqual(payload["skipped"], 1)
        self.assertTrue(any("non-symlink" in item for item in diagnostics))
        self.assertTrue(any("user manager" in item for item in diagnostics))

    def test_list_limit_filter_and_missing_root_are_bounded(self) -> None:
        self.make_run("aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee", "session-a")
        _, second, _ = self.make_run("11111111-2222-3333-4444-555555555555", "session-b")
        payload, _ = MODULE.list_managed_runs(state_root=self.state_root, limit=1)
        self.assertEqual(len(payload["rows"]), 1)
        exact, _ = MODULE.list_managed_runs(
            state_root=self.state_root, run_id=second["run_id"]
        )
        self.assertEqual([row["run_id"] for row in exact["rows"]], [second["run_id"]])
        empty, diagnostics = MODULE.list_managed_runs(state_root=self.tmp / "missing")
        self.assertEqual(empty["rows"], [])
        self.assertEqual(diagnostics, [])
        with self.assertRaisesRegex(MODULE.StateError, "invalid managed run ID"):
            MODULE.list_managed_runs(state_root=self.state_root, run_id="../foreign")

    def test_list_skips_malformed_and_oversized_records(self) -> None:
        malformed_dir, _, _ = self.make_run(
            "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee", "malformed-session", state="running"
        )
        malformed_status = malformed_dir / "status.json"
        malformed_status.write_text("{not-json}\n")
        malformed_status.chmod(0o600)
        oversized_dir, _, _ = self.make_run(
            "11111111-2222-3333-4444-555555555555", "oversized-session"
        )
        oversized = oversized_dir / "completion.json"
        oversized.write_bytes(b"x" * (MODULE.MAX_RECORD_BYTES + 1))
        oversized.chmod(0o600)
        payload, diagnostics = MODULE.list_managed_runs(state_root=self.state_root)
        self.assertEqual(payload["rows"], [])
        self.assertEqual(payload["skipped"], 2)
        self.assertTrue(any("status record is malformed" in item for item in diagnostics))
        self.assertTrue(any("exceeds" in item for item in diagnostics))

    def test_completed_failure_needs_no_live_manager_evidence(self) -> None:
        run_dir, submission, accepted = self.make_run(
            "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee", "failed-session", state="failed"
        )
        assert accepted is not None
        status = json.loads((run_dir / "status.json").read_text())
        status["queue_exit_code"] = 1
        (run_dir / "status.json").write_text(json.dumps(status) + "\n")
        (run_dir / "status.json").chmod(0o600)
        completion = MODULE.completion_envelope(
            submission=submission,
            accepted=accepted,
            status=status,
            service={
                "Result": "exit-code",
                "ExecMainStatus": "1",
                "InvocationID": accepted["invocation_id"],
            },
            client_returncode=1,
        )
        MODULE.publish_set_once(run_dir / "completion.json", completion, os.geteuid())
        payload, diagnostics = MODULE.list_managed_runs(
            state_root=self.state_root,
            generation_reader=lambda: self.fail("completed rows must not query the manager"),
            snapshot_reader=lambda _unit: self.fail("completed rows must not query a unit"),
        )
        self.assertEqual(diagnostics, [])
        self.assertEqual(payload["rows"][0]["effective_state"], "failed")

    def test_human_table_abbreviates_sessions_unambiguously(self) -> None:
        payload = {
            "rows": [
                {
                    "run_id": "run-a",
                    "effective_state": "running",
                    "phase": "building",
                    "lane": "build-sys",
                    "task": "C225",
                    "harness": "codex",
                    "session": "common-prefix-alpha-long",
                    "unit": "unit-a",
                },
                {
                    "run_id": "run-b",
                    "effective_state": "queued",
                    "phase": "waiting-for-lock",
                    "lane": "build-sys",
                    "task": "C225",
                    "harness": "claude",
                    "session": "common-prefix-beta-long",
                    "unit": "unit-b",
                },
            ]
        }
        table = MODULE.human_list_table(payload)
        self.assertIn("run_id", table)
        self.assertIn("common-prefix-a…", table)
        self.assertIn("common-prefix-b…", table)
        self.assertNotIn("common-prefix-alpha-long", table)

    def test_list_cli_has_bounded_limit_and_json_mode(self) -> None:
        args = MODULE.parser().parse_args(
            ["list", "--state-root", str(self.state_root), "--limit", "5", "--json"]
        )
        self.assertEqual(args.limit, 5)
        self.assertTrue(args.machine_json)
        with self.assertRaises(SystemExit):
            MODULE.parser().parse_args(["list", "--limit", str(MODULE.MAX_LIST_ROWS + 1)])

        machine = subprocess.run(
            [
                sys.executable,
                str(ADAPTER),
                "list",
                "--state-root",
                str(self.state_root),
                "--json",
            ],
            check=False,
            capture_output=True,
            text=True,
        )
        self.assertEqual(machine.returncode, 0, machine.stderr)
        self.assertEqual(json.loads(machine.stdout)["rows"], [])
        human = subprocess.run(
            [sys.executable, str(ADAPTER), "list", "--state-root", str(self.state_root)],
            check=False,
            capture_output=True,
            text=True,
        )
        self.assertEqual(human.returncode, 0, human.stderr)
        self.assertEqual(human.stdout, "No managed Lean queue runs.\n")


class ManagedCliTests(unittest.TestCase):
    def setUp(self) -> None:
        TEST_ROOT.mkdir(mode=0o700, parents=True, exist_ok=True)
        self.tmp = Path(tempfile.mkdtemp(dir=TEST_ROOT))
        self.tmp.chmod(0o700)
        self.lean_root = self.tmp / "lean"
        self.lean_root.mkdir()
        (self.lean_root / "lakefile.toml").write_text("name = 'fixture'\n")

    def tearDown(self) -> None:
        shutil.rmtree(self.tmp)

    def arguments(self, *extra: str):
        return MODULE.parser().parse_args(
            [
                "run",
                "Target.One",
                "Target.Two",
                "--harness",
                "codex",
                "--session-id",
                "managed-cli-session",
                "--lane",
                "build-sys",
                "--task-id",
                "C225",
                "--state-root",
                str(self.tmp / "state"),
                "--lean-root",
                str(self.lean_root),
                *extra,
            ]
        )

    def test_run_reserves_identity_and_forwards_measured_worker_contract(self) -> None:
        args = self.arguments(
            "--serial-first",
            "Heavy.Shared",
            "--aggregate",
            "Gate.Final",
            "--cores",
            "20-21",
            "--threads",
            "2",
            "--profile",
            "q25-two-witness",
            "--wait-quiet-seconds",
            "30",
        )
        captured: dict[str, object] = {}

        def launch(**kwargs):
            captured.update(kwargs)
            submission = kwargs["submission"]
            completion = {
                "format": 1,
                "run_id": submission["run_id"],
                "unit": submission["unit"],
                "invocation_id": "b" * 32,
                "origin": submission["origin"],
                "adapter_exit_code": 0,
                "event_id": f"lean-queue:{submission['run_id']}:terminal:1",
            }
            return {"format": 1}, completion, "fixture diagnostic"

        completion, diagnostic = MODULE.run_managed_cli(
            args,
            environ={},
            generation_reader=lambda: {
                "boot_id": "12345678-1234-1234-1234-123456789abc",
                "dbus_owner": ":1.42",
                "manager_pid": 4321,
                "manager_start_ticks": 98765,
            },
            launcher=launch,
        )
        run_dir = captured["run_dir"]
        submission = captured["submission"]
        self.assertEqual(completion["adapter_exit_code"], 0)
        self.assertEqual(diagnostic, "fixture diagnostic")
        self.assertEqual(submission["run_dir"], str(run_dir))
        self.assertEqual(json.loads((run_dir / "submission.json").read_text()), submission)
        argv = submission["worker_argv"]
        self.assertEqual(argv[:3], [os.path.abspath(sys.executable), str(MODULE.WORKER_DEFAULT), "run"])
        self.assertEqual(argv[3:5], ["Target.One", "Target.Two"])
        self.assertIn("--serial-first", argv)
        self.assertIn("Heavy.Shared", argv)
        self.assertIn("--aggregate", argv)
        self.assertIn("Gate.Final", argv)
        self.assertIn("--threads", argv)
        self.assertIn("q25-two-witness", argv)
        expected_lock = (
            MODULE.LEGACY_STATE_ROOT_DEFAULT
            / "locks"
            / f"{MODULE.lock_slug(self.lean_root)}.lock"
        )
        self.assertEqual(argv[argv.index("--lock-file") + 1], str(expected_lock))

    def test_run_rejects_invalid_module_before_creating_managed_state(self) -> None:
        args = self.arguments()
        args.targets = ["bad/module"]
        with self.assertRaisesRegex(MODULE.StateError, "invalid Lean module"):
            MODULE.run_managed_cli(
                args,
                environ={},
                generation_reader=lambda: {},
                launcher=lambda **_kwargs: self.fail("launcher must not run"),
            )
        self.assertFalse((self.tmp / "state").exists())


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

    def test_live_bus_wait_wakes_for_exact_referenced_unit(self) -> None:
        self.unit = f"othello-lean-{uuid.uuid4().hex}.service"
        with MODULE.SystemdBusLease() as lease:
            launched = subprocess.run(
                [
                    str(MODULE.SYSTEMD_RUN_DEFAULT),
                    "--user",
                    "--quiet",
                    "--service-type=exec",
                    f"--unit={self.unit.removesuffix('.service')}",
                    "/run/current-system/sw/bin/sleep",
                    "1",
                ],
                stdin=subprocess.DEVNULL,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True,
                check=False,
            )
            self.assertEqual(launched.returncode, 0, launched.stderr)
            lease.ref_unit(self.unit)
            snapshot = MODULE.unit_snapshot(self.unit)
            self.assertIsNotNone(snapshot)
            deadline = MODULE.time.monotonic() + 5
            while snapshot is not None and snapshot.get("ActiveState") not in {
                "inactive",
                "failed",
            }:
                remaining = deadline - MODULE.time.monotonic()
                self.assertGreater(remaining, 0, snapshot)
                self.assertTrue(lease.wait_for_change(remaining))
                snapshot = MODULE.unit_snapshot(self.unit)
            self.assertIsNotNone(snapshot)
            self.assertEqual(snapshot.get("ActiveState"), "inactive")


if __name__ == "__main__":
    unittest.main(verbosity=2)
