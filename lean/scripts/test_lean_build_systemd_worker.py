#!/usr/bin/env python3
"""Hermetic tests for C225 managed-worker adoption and status ordering."""

from __future__ import annotations

import fcntl
import hashlib
import importlib.util
import json
import os
import shutil
import subprocess
import sys
import tempfile
import time
import unittest
import uuid
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path


SCRIPT_DIR = Path(__file__).resolve().parent
ADAPTER_PATH = SCRIPT_DIR / "lean-build-systemd.py"
WORKER_PATH = SCRIPT_DIR / "lean-build-systemd-worker.py"
LEGACY_TEST_PATH = SCRIPT_DIR / "test_lean_build_queue.py"
TEST_ROOT = Path.home() / ".cache" / "othello-lean-build-systemd-worker-tests"


def load(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


ADAPTER = load("lean_build_systemd_test_adapter", ADAPTER_PATH)
WORKER = load("lean_build_systemd_test_worker", WORKER_PATH)
LEGACY_TEST = load("lean_build_queue_fixture_source", LEGACY_TEST_PATH)


class ManagedWorkerTests(unittest.TestCase):
    def setUp(self) -> None:
        TEST_ROOT.mkdir(mode=0o700, parents=True, exist_ok=True)
        self.tmp = Path(tempfile.mkdtemp(dir=TEST_ROOT))
        self.tmp.chmod(0o700)
        self.state_root = self.tmp / "managed"
        self.lean_root = self.tmp / "lean"
        self.lean_root.mkdir()
        self.lock_path = self.tmp / "fixture.lock"
        self.identity = uuid.uuid4()
        self.run_dir = self.state_root / f"run-{self.identity.hex}"
        self.argv = [
            os.path.abspath(sys.executable),
            str(WORKER_PATH.absolute()),
            "fixture",
            "--run-dir",
            str(self.run_dir),
            "--fixture-lock",
            str(self.lock_path),
            "--lock-timeout",
            "5",
        ]
        self.origin = ADAPTER.resolve_origin(
            harness="manual",
            session_id="worker-test",
            work_lane=None,
            task_id=None,
            environ={},
        )
        self.generation = {
            "boot_id": "12345678-1234-1234-1234-123456789abc",
            "dbus_owner": ":1.42",
            "manager_pid": 4321,
            "manager_start_ticks": 98765,
        }
        self.run_dir, self.submission, self.digest = ADAPTER.prepare_submission(
            state_root=self.state_root,
            lean_root=self.lean_root,
            worker_argv=self.argv,
            origin=self.origin,
            generation=self.generation,
            run_uuid=self.identity,
        )
        self.environment = os.environ.copy()
        self.environment["OTHELLO_LEAN_RUN_ID"] = str(self.submission["run_id"])
        self.environment["OTHELLO_LEAN_SUBMISSION_SHA256"] = self.digest

    def tearDown(self) -> None:
        shutil.rmtree(self.tmp)

    def rewrite_submission(self, changes: dict[str, object]) -> None:
        self.submission.update(changes)
        encoded = ADAPTER.canonical_json(self.submission)
        (self.run_dir / "submission.json").write_bytes(encoded)
        (self.run_dir / "submission.json").chmod(0o600)
        self.environment["OTHELLO_LEAN_SUBMISSION_SHA256"] = hashlib.sha256(encoded).hexdigest()

    def launch(self) -> subprocess.Popen[str]:
        return subprocess.Popen(
            self.argv,
            env=self.environment,
            cwd=self.lean_root,
            stdin=subprocess.DEVNULL,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
        )

    def wait_for_phase(self, phase: str, timeout: float = 5) -> dict[str, object]:
        deadline = time.monotonic() + timeout
        status_path = self.run_dir / "status.json"
        while time.monotonic() < deadline:
            try:
                status = json.loads(status_path.read_text())
            except (OSError, json.JSONDecodeError):
                time.sleep(0.02)
                continue
            if status.get("phase") == phase:
                return status
            time.sleep(0.02)
        self.fail(f"timed out waiting for status phase {phase}")

    def test_valid_adoption_matches_every_immutable_binding(self) -> None:
        submission, digest = WORKER.adopt_managed_run(
            self.run_dir,
            environ=self.environment,
            expected_argv=self.argv,
            expected_cwd=self.lean_root,
        )
        self.assertEqual(submission, self.submission)
        self.assertEqual(digest, self.digest)
        self.assertFalse((self.run_dir / "status.json").exists())

    def test_every_adoption_mismatch_precedes_status(self) -> None:
        cases = (
            ("run nonce", lambda: self.environment.__setitem__("OTHELLO_LEAN_RUN_ID", "wrong")),
            ("digest nonce", lambda: self.environment.__setitem__("OTHELLO_LEAN_SUBMISSION_SHA256", "0" * 64)),
            ("run path", lambda: self.rewrite_submission({"run_dir": str(self.tmp / "other")})),
            ("unit", lambda: self.rewrite_submission({"unit": "foreign.service"})),
            ("account", lambda: self.rewrite_submission({"origin": {**self.origin, "user": "foreign"}})),
            ("argv", lambda: self.rewrite_submission({"worker_argv": [sys.executable, "/wrong"]})),
        )
        for index, (label, mutate) in enumerate(cases):
            with self.subTest(label=label):
                if index:
                    self.tearDown()
                    self.setUp()
                mutate()
                with self.assertRaises(WORKER.AdoptionError):
                    WORKER.adopt_managed_run(
                        self.run_dir,
                        environ=self.environment,
                        expected_argv=self.argv,
                        expected_cwd=self.lean_root,
                    )
                self.assertFalse((self.run_dir / "status.json").exists())

    def test_missing_symlink_and_mode_mismatches_precede_status(self) -> None:
        record = self.run_dir / "submission.json"
        record.unlink()
        with self.assertRaisesRegex(WORKER.AdoptionError, "cannot inspect submission"):
            WORKER.adopt_managed_run(
                self.run_dir,
                environ=self.environment,
                expected_argv=self.argv,
                expected_cwd=self.lean_root,
            )
        self.assertFalse((self.run_dir / "status.json").exists())

        self.tearDown()
        self.setUp()
        record = self.run_dir / "submission.json"
        real_record = self.run_dir / "real-submission.json"
        record.rename(real_record)
        record.symlink_to(real_record.name)
        with self.assertRaisesRegex(WORKER.AdoptionError, "regular non-symlink"):
            WORKER.adopt_managed_run(
                self.run_dir,
                environ=self.environment,
                expected_argv=self.argv,
                expected_cwd=self.lean_root,
            )
        self.assertFalse((self.run_dir / "status.json").exists())

        record.unlink()
        real_record.rename(record)
        record.chmod(0o644)
        with self.assertRaisesRegex(WORKER.AdoptionError, "unsafe owner or mode"):
            WORKER.adopt_managed_run(
                self.run_dir,
                environ=self.environment,
                expected_argv=self.argv,
                expected_cwd=self.lean_root,
            )
        self.assertFalse((self.run_dir / "status.json").exists())

        record.chmod(0o600)
        self.run_dir.chmod(0o755)
        with self.assertRaisesRegex(WORKER.AdoptionError, "mode must be 0700"):
            WORKER.adopt_managed_run(
                self.run_dir,
                environ=self.environment,
                expected_argv=self.argv,
                expected_cwd=self.lean_root,
            )
        self.assertFalse((self.run_dir / "status.json").exists())

    def test_wrong_effective_owner_and_working_directory_precede_status(self) -> None:
        with self.assertRaisesRegex(WORKER.AdoptionError, "not owned by effective UID"):
            WORKER.adopt_managed_run(
                self.run_dir,
                environ=self.environment,
                expected_argv=self.argv,
                expected_cwd=self.lean_root,
                effective_uid=os.geteuid() + 1,
            )
        self.assertFalse((self.run_dir / "status.json").exists())
        with self.assertRaisesRegex(WORKER.AdoptionError, "working directory"):
            WORKER.adopt_managed_run(
                self.run_dir,
                environ=self.environment,
                expected_argv=self.argv,
                expected_cwd=self.tmp,
            )
        self.assertFalse((self.run_dir / "status.json").exists())

    def test_symlinked_state_or_run_directory_precedes_status(self) -> None:
        real_root = self.tmp / "real-managed"
        self.state_root.rename(real_root)
        self.state_root.symlink_to(real_root.name, target_is_directory=True)
        with self.assertRaisesRegex(WORKER.AdoptionError, "state root must be a non-symlink"):
            WORKER.adopt_managed_run(
                self.run_dir,
                environ=self.environment,
                expected_argv=self.argv,
                expected_cwd=self.lean_root,
            )
        self.assertFalse((real_root / self.run_dir.name / "status.json").exists())

        self.tearDown()
        self.setUp()
        real_run = self.state_root / "real-run"
        self.run_dir.rename(real_run)
        self.run_dir.symlink_to(real_run.name, target_is_directory=True)
        with self.assertRaisesRegex(WORKER.AdoptionError, "run directory must be a non-symlink"):
            WORKER.adopt_managed_run(
                self.run_dir,
                environ=self.environment,
                expected_argv=self.argv,
                expected_cwd=self.lean_root,
            )
        self.assertFalse((real_run / "status.json").exists())

    def test_preexisting_status_is_not_overwritten(self) -> None:
        status_path = self.run_dir / "status.json"
        status_path.write_text("foreign\n")
        status_path.chmod(0o600)
        with self.assertRaisesRegex(WORKER.AdoptionError, "already exists"):
            WORKER.adopt_managed_run(
                self.run_dir,
                environ=self.environment,
                expected_argv=self.argv,
                expected_cwd=self.lean_root,
            )
        self.assertEqual(status_path.read_text(), "foreign\n")

    def test_status_waits_queued_before_held_lock_then_finishes_after_unlock(self) -> None:
        with self.lock_path.open("a+") as holder:
            fcntl.flock(holder.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
            process = self.launch()
            queued = self.wait_for_phase("waiting-for-lock")
            self.assertEqual(queued["format"], 2)
            self.assertEqual(queued["state"], "queued")
            self.assertIsNone(queued["queue_exit_code"])
            self.assertIsNone(process.poll())
            fcntl.flock(holder.fileno(), fcntl.LOCK_UN)
        stdout, stderr = process.communicate(timeout=5)
        self.assertEqual(process.returncode, 0, f"{stdout}\n{stderr}")
        terminal = json.loads((self.run_dir / "status.json").read_text())
        self.assertEqual(terminal["state"], "success")
        self.assertEqual(terminal["phase"], "finished")
        self.assertEqual(terminal["queue_exit_code"], 0)
        self.assertIsNotNone(terminal["finished_utc"])

    def test_lock_timeout_records_refusal(self) -> None:
        self.argv[-1] = "0.1"
        self.rewrite_submission(
            {
                "worker_argv": self.argv,
                "worker_argv_sha256": hashlib.sha256(
                    ADAPTER.canonical_json({"argv": self.argv})
                ).hexdigest(),
            }
        )
        with self.lock_path.open("a+") as holder:
            fcntl.flock(holder.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
            result = subprocess.run(
                self.argv,
                env=self.environment,
                cwd=self.lean_root,
                stdin=subprocess.DEVNULL,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True,
                timeout=5,
                check=False,
            )
        self.assertEqual(result.returncode, 2, result.stderr)
        terminal = json.loads((self.run_dir / "status.json").read_text())
        self.assertEqual(terminal["state"], "refused")
        self.assertEqual(terminal["queue_exit_code"], 2)
        self.assertEqual(terminal["phase"], "finished")


class ManagedQueueExecutionTests(unittest.TestCase):
    def setUp(self) -> None:
        TEST_ROOT.mkdir(mode=0o700, parents=True, exist_ok=True)
        self.tmp = Path(tempfile.mkdtemp(dir=TEST_ROOT))
        self.tmp.chmod(0o700)
        self.bin = self.tmp / "bin"
        self.bin.mkdir()
        for name, body in LEGACY_TEST.STUBS.items():
            path = self.bin / name
            path.write_text(body.replace("__BIN__", str(self.bin)))
            path.chmod(0o755)
        self.fake = self.tmp / "fake"
        (self.fake / "plans").mkdir(parents=True)
        (self.fake / "built").mkdir()
        self.lean_root = self.tmp / "lean"
        self.lean_root.mkdir()
        (self.lean_root / "lakefile.lean").write_text("-- fixture\n")
        (self.lean_root / "lean-toolchain").write_text("fixture\n")
        self.profile = self.tmp / "profiles.json"
        self.profile.write_text(
            json.dumps(
                {
                    "profiles": {
                        "fixture": {
                            "reserve_mib": 1024,
                            "verified_max_threads": 4,
                            "worker_peak_mib": 512,
                        }
                    }
                }
            )
        )
        self.meminfo = self.tmp / "meminfo"
        self.meminfo.write_text("MemTotal: 33554432 kB\nMemAvailable: 25165824 kB\n")
        self.mountinfo = self.tmp / "mountinfo"
        self.mountinfo.write_text(f"1 0 0:1 / {self.tmp} rw - ext4 fixture rw\n")
        self.lock = self.tmp / "owner.lock"

    def tearDown(self) -> None:
        shutil.rmtree(self.tmp)

    def execute(
        self,
        targets: list[str],
        *,
        extra: list[str] | None = None,
    ) -> tuple[subprocess.CompletedProcess[str], Path]:
        identity = uuid.uuid4()
        run_dir = self.tmp / "managed" / f"run-{identity.hex}"
        argv = [
            os.path.abspath(sys.executable),
            str(WORKER_PATH.absolute()),
            "run",
            *targets,
            "--run-dir",
            str(run_dir),
            "--lock-file",
            str(self.lock),
            "--profile",
            "fixture",
            "--profile-file",
            str(self.profile),
            "--threads",
            "2",
            "--meminfo",
            str(self.meminfo),
            "--mountinfo",
            str(self.mountinfo),
            "--tmp-path",
            str(self.tmp),
            "--tmp-used-mib",
            "0",
            "--nix-binary",
            str(self.bin / "nix"),
            "--time-binary",
            str(self.bin / "time"),
            "--taskset-binary",
            str(self.bin / "taskset"),
            "--choom-binary",
            str(self.bin / "choom"),
            "--pgrep-binary",
            str(self.bin / "pgrep"),
            "--run-quiet-binary",
            str(self.bin / "run-quiet"),
            "--cores",
            "20-21",
            *(extra or []),
        ]
        origin = ADAPTER.resolve_origin(
            harness="manual",
            session_id="managed-queue-test",
            work_lane=None,
            task_id=None,
            environ={},
        )
        run_dir, submission, digest = ADAPTER.prepare_submission(
            state_root=self.tmp / "managed",
            lean_root=self.lean_root,
            worker_argv=argv,
            origin=origin,
            generation={"boot_id": "fixture"},
            run_uuid=identity,
        )
        environment = os.environ.copy()
        environment["FAKE_LAKE_STATE"] = str(self.fake)
        environment["OTHELLO_LEAN_RUN_ID"] = str(submission["run_id"])
        environment["OTHELLO_LEAN_SUBMISSION_SHA256"] = digest
        result = subprocess.run(
            argv,
            cwd=self.lean_root,
            env=environment,
            stdin=subprocess.DEVNULL,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            timeout=10,
            check=False,
        )
        return result, run_dir

    def test_build_skip_aggregate_and_resource_controls(self) -> None:
        (self.fake / "built" / "Fix.Beta").touch()
        result, run_dir = self.execute(
            ["Fix.Beta"], extra=["--serial-first", "Fix.Alpha"]
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        status = json.loads((run_dir / "status.json").read_text())
        outcomes = {entry["target"]: entry["outcome"] for entry in status["results"]}
        self.assertEqual(outcomes["Fix.Alpha"], "built")
        self.assertEqual(outcomes["Fix.Beta"], "skipped-current")
        self.assertEqual(outcomes["<aggregate>"], "gate-passed")
        self.assertEqual(status["state"], "success")
        calls = (self.fake / "lake-calls.log").read_text()
        self.assertIn("threads=1 nobuild=0 targets=Fix.Alpha", calls)
        self.assertIn("threads=1 nobuild=1 targets=Fix.Alpha Fix.Beta", calls)

    def test_build_failure_is_terminal_after_unlock(self) -> None:
        (self.fake / "plans" / "Fix.Alpha").write_text("fail")
        result, run_dir = self.execute(["Fix.Alpha"])
        self.assertEqual(result.returncode, 1)
        status = json.loads((run_dir / "status.json").read_text())
        self.assertEqual(status["state"], "failed")
        self.assertEqual(status["failed_target"], "Fix.Alpha")
        with self.lock.open("a+") as holder:
            fcntl.flock(holder.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)

    def test_aggregate_failure_is_distinct(self) -> None:
        result, run_dir = self.execute(
            ["Fix.Alpha"], extra=["--aggregate", "Fix.Umbrella"]
        )
        self.assertEqual(result.returncode, 1)
        status = json.loads((run_dir / "status.json").read_text())
        self.assertEqual(status["failed_target"], "<aggregate>")

    def test_foreign_busy_process_refuses_without_lake(self) -> None:
        (self.fake / "busy").write_text("lean\n")
        result, run_dir = self.execute(["Fix.Alpha"])
        self.assertEqual(result.returncode, 2)
        status = json.loads((run_dir / "status.json").read_text())
        self.assertEqual(status["state"], "refused")
        self.assertFalse((self.fake / "lake-calls.log").exists())


@unittest.skipUnless(
    os.environ.get("OTHELLO_SYSTEMD_WORKER_LIVE_TEST") == "1",
    "set OTHELLO_SYSTEMD_WORKER_LIVE_TEST=1 for the harmless managed-worker fixture",
)
class LiveManagedWorkerTest(unittest.TestCase):
    def setUp(self) -> None:
        TEST_ROOT.mkdir(mode=0o700, parents=True, exist_ok=True)
        self.tmp = Path(tempfile.mkdtemp(dir=TEST_ROOT))
        self.tmp.chmod(0o700)
        self.lock_path = self.tmp / "fixture.lock"
        identity = uuid.uuid4()
        self.run_dir = self.tmp / "managed" / f"run-{identity.hex}"
        self.argv = [
            os.path.abspath(sys.executable),
            str(WORKER_PATH.absolute()),
            "fixture",
            "--run-dir",
            str(self.run_dir),
            "--fixture-lock",
            str(self.lock_path),
            "--lock-timeout",
            "5",
        ]
        origin = ADAPTER.resolve_origin(
            harness="manual",
            session_id="worker-live-test",
            work_lane=None,
            task_id=None,
            environ={},
        )
        self.run_dir, self.submission, self.digest = ADAPTER.prepare_submission(
            state_root=self.tmp / "managed",
            lean_root=self.tmp,
            worker_argv=self.argv,
            origin=origin,
            generation=ADAPTER.manager_generation(),
            run_uuid=identity,
        )
        self.unit = str(self.submission["unit"])

    def tearDown(self) -> None:
        for action in ("stop", "reset-failed"):
            subprocess.run(
                [str(ADAPTER.SYSTEMCTL_DEFAULT), "--user", action, self.unit],
                stdin=subprocess.DEVNULL,
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
                check=False,
            )
        shutil.rmtree(self.tmp)

    def test_real_bridge_is_queued_before_lock_release(self) -> None:
        with self.lock_path.open("a+") as holder, ThreadPoolExecutor(max_workers=1) as executor:
            fcntl.flock(holder.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
            future = executor.submit(
                ADAPTER.launch_accept_and_wait,
                run_dir=self.run_dir,
                submission=self.submission,
                submission_digest=self.digest,
                completion_timeout=10,
            )
            deadline = time.monotonic() + 5
            status = None
            while time.monotonic() < deadline:
                try:
                    candidate = json.loads((self.run_dir / "status.json").read_text())
                except (OSError, json.JSONDecodeError):
                    time.sleep(0.02)
                    continue
                if candidate.get("phase") == "waiting-for-lock":
                    status = candidate
                    break
                time.sleep(0.02)
            self.assertIsNotNone(status)
            self.assertEqual(status["state"], "queued")
            self.assertFalse(future.done())
            fcntl.flock(holder.fileno(), fcntl.LOCK_UN)
            accepted, returncode, stderr = future.result(timeout=10)
        self.assertEqual(returncode, 0, stderr)
        self.assertEqual(accepted["unit"], self.unit)
        terminal = json.loads((self.run_dir / "status.json").read_text())
        self.assertEqual(terminal["state"], "success")
        self.assertEqual(terminal["queue_exit_code"], 0)
        self.assertIsNotNone(terminal["finished_utc"])


if __name__ == "__main__":
    unittest.main(verbosity=2)
