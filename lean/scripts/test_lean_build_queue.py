#!/usr/bin/env python3
"""Tests for lean-build-queue.py.

Fully hermetic: every external tool (nix, lake, taskset, choom, GNU time, pgrep) is a stub, so the
suite never builds Lean, never inspects the host's real process table, and never touches another
lane's build.  Run:

    python3 lean/scripts/test_lean_build_queue.py
"""

from __future__ import annotations

import fcntl
import importlib.util
import json
import os
import shutil
import signal
import subprocess
import sys
import tempfile
import time
import unittest
from pathlib import Path

RUNNER = Path(__file__).resolve().parent / "lean-build-queue.py"
TEST_ROOT = Path.home() / ".cache" / "othello-lean-build-tests"
RUNNER_SPEC = importlib.util.spec_from_file_location("lean_build_queue", RUNNER)
assert RUNNER_SPEC is not None and RUNNER_SPEC.loader is not None
RUNNER_MODULE = importlib.util.module_from_spec(RUNNER_SPEC)
RUNNER_SPEC.loader.exec_module(RUNNER_MODULE)

STUBS = {
    # `nix develop --command bash -lc SCRIPT` -> run SCRIPT with the stub bin dir ahead of PATH, so
    # the `lake` inside the build shell resolves to our stub.  Asserts the real argv shape.
    "nix": """#!/usr/bin/env bash
set -uo pipefail
[ "${1:-}" = develop ] || { echo "unexpected nix argv: $*" >&2; exit 90; }
[ "${2:-}" = --command ] || { echo "unexpected nix argv: $*" >&2; exit 90; }
if [ "${3:-}" = lake ] && [ "${4:-}" = pack ]; then
  mkdir -p "$(dirname "$5")"
  printf 'fixture lake pack\\n' > "$5"
  exit 0
fi
if [ "${3:-}" = lake ] && [ "${4:-}" = update ]; then
  printf '%s\n' "${5:-}" > "$FAKE_LAKE_STATE/updated-package"
  exit 0
fi
if [ "${3:-}" = lake ] && [ "${4:-}" = unpack ]; then
  printf '%s\n' "${5:-}" > "$FAKE_LAKE_STATE/restored-archive"
  exit 0
fi
[ "${3:-}" = bash ] || { echo "unexpected nix argv: $*" >&2; exit 90; }
[ "${4:-}" = -lc ] || { echo "unexpected nix argv: $*" >&2; exit 90; }
exec bash -lc "export PATH=__BIN__:\\$PATH; ${5:-}"
""",
    "lake": """#!/usr/bin/env bash
set -uo pipefail
state="$FAKE_LAKE_STATE"
[ "${1:-}" = exe ] && [ "${2:-}" = cache ] && [ "${3:-}" = get ] && {
  echo "pwd=$PWD threads=${LEAN_NUM_THREADS:-unset} cache-get" >> "$state/lake-calls.log"
  [ -f "$state/cache-fail" ] && { echo "fixture cache failure" >&2; exit 42; }
  if [ -f "$state/cache-restores" ]; then
    while read -r target; do [ -n "$target" ] && touch "$state/built/$target"; done < "$state/cache-restores"
  fi
  exit 0
}
[ "${1:-}" = build ] || { echo "unexpected lake argv: $*" >&2; exit 91; }
shift
nobuild=0
if [ "${1:-}" = --no-build ]; then nobuild=1; shift; fi
echo "pwd=$PWD threads=${LEAN_NUM_THREADS:-unset} nobuild=$nobuild targets=$*" >> "$state/lake-calls.log"
rc=0
mkdir -p "$state/built"
for target in "$@"; do
  plan=ok
  [ -f "$state/plans/$target" ] && plan=$(cat "$state/plans/$target")
  if [ "$nobuild" = 1 ]; then
    if [ -f "$state/built/$target" ]; then
      echo "$target is up to date"
    else
      echo "error: $target is not up to date"
      rc=1
    fi
    continue
  fi
  case "$plan" in
    ok) echo "Built $target"; touch "$state/built/$target" ;;
    fail) echo "error: elaboration failed in $target"; echo "DELIBERATE FIXTURE FAILURE"; rc=1 ;;
    hang) echo "hanging in $target"; sleep 30 ;;
  esac
done
exit $rc
""",
    "taskset": """#!/usr/bin/env bash
set -uo pipefail
[ "${1:-}" = -c ] || { echo "unexpected taskset argv: $*" >&2; exit 92; }
echo "$2" >> "$FAKE_LAKE_STATE/cores.log"
shift 2
exec "$@"
""",
    "choom": """#!/usr/bin/env bash
set -uo pipefail
[ "${1:-}" = -n ] || { echo "unexpected choom argv: $*" >&2; exit 93; }
echo "$2" >> "$FAKE_LAKE_STATE/choom.log"
shift 2
[ "${1:-}" = -- ] && shift
exec "$@"
""",
    # Emits GNU time's real label format, colons inside the label included.
    "time": """#!/usr/bin/env bash
set -uo pipefail
[ "${1:-}" = -v ] || { echo "unexpected time argv: $*" >&2; exit 94; }
shift
"$@"
rc=$?
{
  echo "	Command being timed: \\"$*\\""
  echo "	Elapsed (wall clock) time (h:mm:ss or m:ss): 0:01.23"
  echo "	Maximum resident set size (kbytes): 1310720"
  echo "	Exit status: $rc"
} >&2
exit $rc
""",
    "pgrep": """#!/usr/bin/env bash
set -uo pipefail
[ "${1:-}" = -x ] || { echo "unexpected pgrep argv: $*" >&2; exit 95; }
if [ -f "$FAKE_LAKE_STATE/busy" ] && grep -qx "${2:-}" "$FAKE_LAKE_STATE/busy"; then
  exit 0
fi
exit 1
""",
    "run-quiet": """#!/usr/bin/env bash
set -uo pipefail
root=${RUN_QUIET_LOGDIR:?}
mkdir -p "$root/result"
echo "$1" >> "$FAKE_LAKE_STATE/run-quiet-calls.log"
bash -c "$1" > "$root/result/stdout.log" 2> "$root/result/stderr.log"
rc=$?
printf 'exit=%s dir=%s\\n' "$rc" "$root/result"
exit "$rc"
""",
}


class QueueTest(unittest.TestCase):
    def setUp(self) -> None:
        TEST_ROOT.mkdir(parents=True, exist_ok=True)
        self.tmp = Path(tempfile.mkdtemp(dir=TEST_ROOT))
        self.bin = self.tmp / "bin"
        self.bin.mkdir()
        for name, body in STUBS.items():
            path = self.bin / name
            path.write_text(body.replace("__BIN__", str(self.bin)))
            path.chmod(0o755)

        self.state = self.tmp / "state"
        (self.state / "plans").mkdir(parents=True)
        (self.state / "built").mkdir(parents=True)

        self.lean_root = self.tmp / "lean"
        self.lean_root.mkdir()
        (self.lean_root / "lakefile.lean").write_text("-- fixture\n")
        (self.lean_root / "lean-toolchain").write_text("leanprover/lean4:v4.99.0\n")

        self.profile_file = self.tmp / "profiles.json"
        self.profile_file.write_text(
            json.dumps(
                {
                    "profiles": {
                        "fixture": {
                            "description": "hermetic test profile",
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

        self.lock_file = self.tmp / "owner.lock"

    def tearDown(self) -> None:
        shutil.rmtree(self.tmp, ignore_errors=True)

    # helpers ---------------------------------------------------------------

    def plan(self, target: str, behavior: str) -> None:
        (self.state / "plans" / target).write_text(behavior)

    def mark_built(self, target: str) -> None:
        (self.state / "built" / target).touch()

    def env(self) -> dict[str, str]:
        env = os.environ.copy()
        env["FAKE_LAKE_STATE"] = str(self.state)
        return env

    def run_argv(self, targets: list[str], run_dir: Path, extra: list[str] | None = None) -> list[str]:
        return [
            sys.executable,
            str(RUNNER),
            "run",
            *targets,
            "--lean-root",
            str(self.lean_root),
            "--run-dir",
            str(run_dir),
            "--lock-file",
            str(self.lock_file),
            "--cores",
            "0-1",
            "--threads",
            "2",
            "--profile",
            "fixture",
            "--profile-file",
            str(self.profile_file),
            "--meminfo",
            str(self.meminfo),
            "--mountinfo",
            str(self.mountinfo),
            "--tmp-path",
            str(self.tmp),
            "--tmp-used-mib",
            "64",
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
            "--heartbeat-seconds",
            "1",
            *(extra or []),
        ]

    def launch(self, targets: list[str], run_dir: Path, extra: list[str] | None = None):
        return subprocess.Popen(
            self.run_argv(targets, run_dir, extra),
            env=self.env(),
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
        )

    def run_queue(self, targets: list[str], run_dir: Path, extra: list[str] | None = None):
        return subprocess.run(
            self.run_argv(targets, run_dir, extra),
            env=self.env(),
            capture_output=True,
            text=True,
            timeout=120,
        )

    def status(self, run_dir: Path):
        return subprocess.run(
            [sys.executable, str(RUNNER), "status", str(run_dir), "--json"],
            env=self.env(),
            capture_output=True,
            text=True,
            timeout=30,
        )

    def pack(self, destination: Path, extra: list[str] | None = None):
        return subprocess.run(
            [
                sys.executable,
                str(RUNNER),
                "pack",
                str(destination),
                "--lean-root",
                str(self.lean_root),
                "--lock-file",
                str(self.lock_file),
                "--mountinfo",
                str(self.mountinfo),
                "--nix-binary",
                str(self.bin / "nix"),
                "--pgrep-binary",
                str(self.bin / "pgrep"),
                "--run-quiet-binary",
                str(self.bin / "run-quiet"),
                *(extra or []),
            ],
            env=self.env(),
            capture_output=True,
            text=True,
            timeout=30,
        )

    def read_status(self, run_dir: Path) -> dict:
        return json.loads((run_dir / "status.json").read_text())

    def update_lock(self, package: str):
        return subprocess.run(
            [
                sys.executable,
                str(RUNNER),
                "update-lock",
                package,
                "--lean-root",
                str(self.lean_root),
                "--lock-file",
                str(self.lock_file),
                "--nix-binary",
                str(self.bin / "nix"),
                "--pgrep-binary",
                str(self.bin / "pgrep"),
                "--run-quiet-binary",
                str(self.bin / "run-quiet"),
            ],
            env=self.env(),
            capture_output=True,
            text=True,
            timeout=30,
        )

    def restore(self, archive: Path):
        return subprocess.run(
            [
                sys.executable,
                str(RUNNER),
                "restore",
                str(archive),
                "--lean-root",
                str(self.lean_root),
                "--lock-file",
                str(self.lock_file),
                "--mountinfo",
                str(self.mountinfo),
                "--nix-binary",
                str(self.bin / "nix"),
                "--pgrep-binary",
                str(self.bin / "pgrep"),
                "--run-quiet-binary",
                str(self.bin / "run-quiet"),
            ],
            env=self.env(),
            capture_output=True,
            text=True,
            timeout=30,
        )

    def wait_until_current(self, run_dir: Path, target: str, timeout: float = 30.0) -> None:
        deadline = time.monotonic() + timeout
        while time.monotonic() < deadline:
            try:
                if self.read_status(run_dir).get("current_target") == target:
                    return
            except (OSError, json.JSONDecodeError):
                pass
            time.sleep(0.1)
        self.fail(f"{target} never became the current target")

    # gate 1: success, including already-current skipping --------------------

    def test_success_skips_current_targets_and_gates(self) -> None:
        run_dir = self.tmp / "run1"
        self.mark_built("Fix.Alpha")  # already trace-current
        result = self.run_queue(["Fix.Alpha", "Fix.Beta"], run_dir)
        self.assertEqual(result.returncode, 0, result.stderr)

        status = self.read_status(run_dir)
        self.assertEqual(status["state"], "success")
        outcomes = {entry["target"]: entry["outcome"] for entry in status["results"]}
        self.assertEqual(outcomes["Fix.Alpha"], "skipped-current")
        self.assertEqual(outcomes["Fix.Beta"], "built")
        self.assertEqual(outcomes["<aggregate>"], "gate-passed")

        beta = next(e for e in status["results"] if e["target"] == "Fix.Beta")
        self.assertEqual(beta["max_rss_kbytes"], "1310720")
        self.assertEqual(beta["wall_clock"], "0:01.23")

        # Alpha was skipped, so it must never have been handed to a real build.
        calls = (self.state / "lake-calls.log").read_text()
        self.assertNotIn("threads=2 nobuild=0 targets=Fix.Alpha", calls)
        self.assertIn("threads=2 nobuild=0 targets=Fix.Beta", calls)

        # Resource controls actually reached the tools.
        self.assertEqual((self.state / "cores.log").read_text().split(), ["0-1", "0-1"])
        self.assertEqual((self.state / "choom.log").read_text().split(), ["1000", "1000"])

        manifest = json.loads((run_dir / "manifest.json").read_text())
        self.assertEqual(manifest["resources"]["cores"], "0-1")
        self.assertEqual(manifest["resources"]["lean_num_threads"], 2)
        self.assertEqual(manifest["resources"]["choom_adjust"], 1000)
        self.assertEqual(manifest["resources"]["cache_mode"], "auto")
        plan = manifest["resources"]["plan"]
        self.assertEqual(plan["profile"], "fixture")
        self.assertEqual(plan["tmp_ram_mib"], 0)
        self.assertEqual(plan["workload_peak_mib"], 1024)
        self.assertEqual(manifest["source"]["lean_toolchain"], "leanprover/lean4:v4.99.0")
        self.assertEqual(len((self.state / "run-quiet-calls.log").read_text().splitlines()), 2)

    def test_cache_get_can_make_a_stale_target_current_without_source_build(self) -> None:
        run_dir = self.tmp / "cache-restored"
        (self.state / "cache-restores").write_text("Fix.Alpha\n")
        result = self.run_queue(["Fix.Alpha"], run_dir)
        self.assertEqual(result.returncode, 0, result.stderr)

        outcomes = {entry["target"]: entry["outcome"] for entry in self.read_status(run_dir)["results"]}
        self.assertEqual(outcomes["<mathlib cache get>"], "cache-restored")
        self.assertEqual(outcomes["Fix.Alpha"], "cache-restored-current")
        calls = (self.state / "lake-calls.log").read_text()
        self.assertIn("cache-get", calls)
        self.assertNotIn("nobuild=0 targets=Fix.Alpha", calls)

    def test_auto_cache_failure_falls_back_to_guarded_source_build(self) -> None:
        run_dir = self.tmp / "cache-fallback"
        (self.state / "cache-fail").touch()
        result = self.run_queue(["Fix.Alpha"], run_dir)
        self.assertEqual(result.returncode, 0, result.stderr)
        outcomes = {entry["target"]: entry["outcome"] for entry in self.read_status(run_dir)["results"]}
        self.assertEqual(outcomes["<mathlib cache get>"], "cache-failed-continuing")
        self.assertEqual(outcomes["Fix.Alpha"], "built")

    def test_required_cache_failure_stops_before_source_build(self) -> None:
        run_dir = self.tmp / "cache-required"
        (self.state / "cache-fail").touch()
        result = self.run_queue(["Fix.Alpha"], run_dir, extra=["--cache-mode", "require"])
        self.assertEqual(result.returncode, 1)
        self.assertEqual(self.read_status(run_dir)["failed_target"], "<mathlib cache get>")
        self.assertNotIn("nobuild=0 targets=Fix.Alpha", (self.state / "lake-calls.log").read_text())

    def test_run_from_foreign_cwd_forces_lean_root_pwd(self) -> None:
        run_dir = self.tmp / "foreign-cwd"
        foreign = self.tmp / "foreign"
        foreign.mkdir()
        env = self.env()
        env["PWD"] = str(foreign)
        result = subprocess.run(
            self.run_argv(["Fix.Alpha"], run_dir),
            cwd=foreign,
            env=env,
            capture_output=True,
            text=True,
            timeout=120,
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        manifest = json.loads((run_dir / "manifest.json").read_text())
        self.assertEqual(manifest["lean_root"], str(self.lean_root))
        calls = (self.state / "lake-calls.log").read_text().splitlines()
        self.assertTrue(all(f"pwd={self.lean_root} " in call for call in calls), calls)

    def test_detach_returns_immediately_and_runner_records_terminal_status(self) -> None:
        run_dir = self.tmp / "detached"
        argv = self.run_argv(["Fix.Alpha"], run_dir, extra=["--detach"])
        result = subprocess.run(
            argv, env=self.env(), capture_output=True, text=True, timeout=30
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("detached pid:", result.stdout)
        launch = json.loads((run_dir / "detached.json").read_text())
        self.assertGreater(launch["launcher_pid"], 0)

        deadline = time.monotonic() + 30
        while time.monotonic() < deadline:
            try:
                if self.read_status(run_dir).get("state") != "running":
                    break
            except (OSError, json.JSONDecodeError):
                pass
            time.sleep(0.05)
        self.assertEqual(self.read_status(run_dir)["state"], "success")

    def test_resource_profile_and_tmpfs_are_enforced_before_build(self) -> None:
        fake_tmp = self.tmp / "fake-tmp"
        fake_tmp.mkdir()
        tmpfs_mountinfo = self.tmp / "mountinfo-tmpfs"
        tmpfs_mountinfo.write_text(
            f"1 0 0:1 / {self.tmp} rw - ext4 fixture rw\n"
            f"2 1 0:2 / {fake_tmp} rw - tmpfs fixture rw\n"
        )
        result = self.run_queue(
            ["Fix.Alpha"],
            self.tmp / "unsafe-run",
            extra=[
                "--mountinfo",
                str(tmpfs_mountinfo),
                "--tmp-path",
                str(fake_tmp),
                "--tmp-used-mib",
                "32000",
            ],
        )
        self.assertEqual(result.returncode, 2)
        self.assertIn("unsafe", result.stderr)
        self.assertFalse((self.state / "lake-calls.log").exists())

    def test_serial_first_uses_one_thread_then_profile_threads(self) -> None:
        run_dir = self.tmp / "serial"
        result = self.run_queue(
            ["Fix.Leaf"], run_dir, extra=["--serial-first", "Fix.Checker"]
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        calls = (self.state / "lake-calls.log").read_text()
        self.assertIn("threads=1 nobuild=0 targets=Fix.Checker", calls)
        self.assertIn("threads=2 nobuild=0 targets=Fix.Leaf", calls)
        manifest = json.loads((run_dir / "manifest.json").read_text())
        self.assertEqual(manifest["serial_first"], ["Fix.Checker"])

    def test_pack_is_quiet_disk_backed_and_non_overwriting(self) -> None:
        destination = self.tmp / "packs" / "fixture.tgz"
        result = self.pack(destination)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(destination.read_text(), "fixture lake pack\n")
        self.assertIn("artifact archive:", result.stdout)
        refused = self.pack(destination)
        self.assertEqual(refused.returncode, 2)
        self.assertIn("refusing to overwrite", refused.stderr)

    def test_update_lock_uses_the_guarded_quiet_envelope(self) -> None:
        result = self.update_lock("finitegeom")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual((self.state / "updated-package").read_text(), "finitegeom\n")

    def test_restore_is_quiet_and_disk_backed(self) -> None:
        archive = self.tmp / "packs/fixture.tgz"
        archive.parent.mkdir()
        archive.write_text("fixture", encoding="utf-8")
        result = self.restore(archive)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(
            (self.state / "restored-archive").read_text(), f"{archive.resolve()}\n"
        )

    # gate 2: fail-fast with a diagnostic tail -------------------------------

    def test_failure_stops_the_queue_and_captures_a_tail(self) -> None:
        run_dir = self.tmp / "run2"
        self.plan("Fix.Beta", "fail")
        result = self.run_queue(["Fix.Alpha", "Fix.Beta", "Fix.Gamma"], run_dir)
        self.assertEqual(result.returncode, 1)
        self.assertIn("DELIBERATE FIXTURE FAILURE", result.stderr)

        status = self.read_status(run_dir)
        self.assertEqual(status["state"], "failed")
        self.assertEqual(status["failed_target"], "Fix.Beta")
        attempted = [entry["target"] for entry in status["results"]]
        self.assertEqual(attempted, ["<mathlib cache get>", "Fix.Alpha", "Fix.Beta"])
        self.assertNotIn("Fix.Gamma", attempted)
        self.assertNotIn("Fix.Gamma", (self.state / "lake-calls.log").read_text())

    # gate 3: refusal when another owner holds the lock ----------------------

    def test_refuses_when_another_owner_holds_the_lock(self) -> None:
        run_dir = self.tmp / "run3"
        with self.lock_file.open("a+") as holder:
            fcntl.flock(holder.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
            holder.write(json.dumps({"run_id": "foreign-run", "pid": 4242}))
            holder.flush()
            result = self.run_queue(["Fix.Alpha"], run_dir)
        self.assertEqual(result.returncode, 2)
        self.assertIn("another build owner holds", result.stderr)
        self.assertIn("foreign-run", result.stderr)
        self.assertFalse((run_dir / "status.json").exists())
        self.assertFalse((self.state / "lake-calls.log").exists(), "must not build behind another owner")

    def test_detached_run_waits_for_owner_lock_then_builds(self) -> None:
        run_dir = self.tmp / "run3-wait"
        with self.lock_file.open("a+") as holder:
            fcntl.flock(holder.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
            holder.write(json.dumps({"run_id": "foreign-run", "pid": 4242}))
            holder.flush()
            launched = subprocess.run(
                self.run_argv(
                    ["Fix.Alpha"],
                    run_dir,
                    extra=["--detach", "--wait-quiet-seconds", "10", "--poll-seconds", "1"],
                ),
                env=self.env(),
                capture_output=True,
                text=True,
                timeout=30,
            )
            self.assertEqual(launched.returncode, 0, launched.stderr)
            time.sleep(1.5)
            self.assertFalse((run_dir / "status.json").exists())
            self.assertIn("waiting for build owner", (run_dir / "launcher.log").read_text())

        deadline = time.monotonic() + 30
        while time.monotonic() < deadline:
            try:
                if self.read_status(run_dir).get("state") == "success":
                    break
            except (OSError, json.JSONDecodeError):
                pass
            time.sleep(0.05)
        self.assertEqual(self.read_status(run_dir)["state"], "success")

    def test_refuses_while_a_foreign_lean_build_is_live(self) -> None:
        run_dir = self.tmp / "run3b"
        (self.state / "busy").write_text("lake.orig\n")
        result = self.run_queue(["Fix.Alpha"], run_dir)
        self.assertEqual(result.returncode, 2)
        self.assertIn("foreign Lean build is live", result.stderr)
        self.assertFalse((self.state / "lake-calls.log").exists(), "must not build behind a foreign run")
        status = self.read_status(run_dir)
        self.assertEqual(status["state"], "refused")
        self.assertEqual(status["exit_code"], 2)

        # The refusal released the lock, so the tree is usable once the foreign build clears.
        (self.state / "busy").unlink()
        self.assertEqual(self.run_queue(["Fix.Alpha"], self.tmp / "run3c").returncode, 0)

    def test_same_basename_targets_keep_distinct_logs(self) -> None:
        run_dir = self.tmp / "run3d"
        result = self.run_queue(["One.All", "Two.All"], run_dir)
        self.assertEqual(result.returncode, 0, result.stderr)

        built = [entry for entry in self.read_status(run_dir)["results"] if entry["outcome"] == "built"]
        logs = {entry["target"]: Path(entry["quiet_dir"]) / "stdout.log" for entry in built}
        self.assertEqual(set(logs), {"One.All", "Two.All"})
        self.assertNotEqual(logs["One.All"], logs["Two.All"])
        self.assertIn("Built One.All", logs["One.All"].read_text())
        self.assertIn("Built Two.All", logs["Two.All"].read_text())

    def test_invalid_numeric_controls_are_rejected(self) -> None:
        cases = (
            ["--threads", "0"],
            ["--poll-seconds", "0"],
            ["--wait-quiet-seconds", "-1"],
            ["--tail-lines", "-1"],
            ["--choom-adjust", "1001"],
        )
        for index, extra in enumerate(cases):
            with self.subTest(extra=extra):
                run_dir = self.tmp / f"invalid-{index}"
                result = self.run_queue(["Fix.Alpha"], run_dir, extra=extra)
                self.assertEqual(result.returncode, 2)
                self.assertFalse(run_dir.exists())

    # gate 4: interruption, then restart-safe resumption ----------------------

    def test_interrupted_run_is_distinguishable_and_resumable(self) -> None:
        run_dir = self.tmp / "run4"
        self.plan("Fix.Beta", "hang")
        process = self.launch(["Fix.Alpha", "Fix.Beta"], run_dir)
        try:
            self.wait_until_current(run_dir, "Fix.Beta")
            self.assertEqual(self.read_status(run_dir)["state"], "running")
            process.terminate()  # our own child, by PID -- never a pkill
            process.communicate(timeout=60)
        finally:
            if process.poll() is None:
                process.kill()
                process.communicate(timeout=30)
        self.assertEqual(process.returncode, 130)

        status = self.read_status(run_dir)
        self.assertEqual(status["state"], "interrupted")
        self.assertNotEqual(status["state"], "failed", "an interrupt is not a build failure")
        self.assertIsNone(status["failed_target"])

        # Resume: Alpha landed before the interrupt, so it is skipped rather than rebuilt.
        self.plan("Fix.Beta", "ok")
        resumed = self.run_queue(["Fix.Alpha", "Fix.Beta"], self.tmp / "run4b")
        self.assertEqual(resumed.returncode, 0, resumed.stderr)
        outcomes = {e["target"]: e["outcome"] for e in self.read_status(self.tmp / "run4b")["results"]}
        self.assertEqual(outcomes["Fix.Alpha"], "skipped-current")
        self.assertEqual(outcomes["Fix.Beta"], "built")

    def test_running_child_refreshes_heartbeat_and_status_reports_activity(self) -> None:
        run_dir = self.tmp / "heartbeat"
        self.plan("Fix.Alpha", "hang")
        process = self.launch(["Fix.Alpha"], run_dir)
        try:
            deadline = time.monotonic() + 10
            initial = None
            refreshed = None
            while time.monotonic() < deadline:
                try:
                    current = self.read_status(run_dir)
                    if current.get("current_target") == "Fix.Alpha":
                        if initial is None:
                            initial = current.get("heartbeat_utc")
                        elif current.get("heartbeat_utc") != initial and current.get("active_child_pid"):
                            refreshed = current
                            break
                except (OSError, json.JSONDecodeError):
                    pass
                time.sleep(0.1)
            self.assertIsNotNone(refreshed, "heartbeat did not advance while the child was live")
            reported = json.loads(self.status(run_dir).stdout)
            self.assertIn("active_process", reported)
        finally:
            process.terminate()
            process.communicate(timeout=60)

    def test_activity_walk_finds_child_spawned_by_nonleader_thread(self) -> None:
        proc = self.tmp / "proc"
        lean_root = self.tmp / "lean-activity"
        source = lean_root / "Mathlib" / "Fixture.lean"

        def process(pid: int, command: str, argv: list[str], tasks: dict[int, str], oom: int) -> None:
            root = proc / str(pid)
            root.mkdir(parents=True)
            (root / "comm").write_text(command + "\n")
            (root / "cmdline").write_bytes(b"\0".join(x.encode() for x in argv) + b"\0")
            (root / "oom_score_adj").write_text(str(oom) + "\n")
            for tid, children in tasks.items():
                task = root / "task" / str(tid)
                task.mkdir(parents=True)
                (task / "children").write_text(children)

        process(100, "python3", ["queue"], {100: "200\n"}, 0)
        process(200, "lake.orig", ["lake", "build"], {200: "", 201: "300\n"}, 1000)
        process(300, "lean", ["lean", str(source), "-o", "Fixture.olean"], {300: ""}, 1000)
        activity = RUNNER_MODULE.exact_descendant_activity(100, lean_root, proc)
        self.assertIsNotNone(activity)
        assert activity is not None
        self.assertEqual(activity["pid"], 300)
        self.assertEqual(activity["module_path"], "Mathlib/Fixture.lean")
        self.assertEqual(activity["oom_score_adj"], 1000)

    # gate 5: atomic state, no false success ---------------------------------

    def test_status_reports_abandoned_when_no_owner_holds_the_lock(self) -> None:
        run_dir = self.tmp / "run5"
        run_dir.mkdir()
        (run_dir / "manifest.json").write_text(json.dumps({"lock_file": str(self.lock_file)}))
        (run_dir / "status.json").write_text(
            json.dumps({"run_id": "dead-run", "state": "running", "results": [], "targets": []})
        )
        result = self.status(run_dir)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(json.loads(result.stdout)["state"], "abandoned")

    def test_status_reports_running_while_the_owner_holds_the_lock(self) -> None:
        run_dir = self.tmp / "run5b"
        run_dir.mkdir()
        (run_dir / "manifest.json").write_text(json.dumps({"lock_file": str(self.lock_file)}))
        (run_dir / "status.json").write_text(
            json.dumps({"run_id": "live-run", "state": "running", "results": [], "targets": []})
        )
        with self.lock_file.open("a+") as holder:
            fcntl.flock(holder.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
            holder.write(json.dumps({"run_id": "live-run", "pid": os.getpid()}))
            holder.flush()
            result = self.status(run_dir)
        self.assertEqual(json.loads(result.stdout)["state"], "running")

    def test_run_state_is_refused_outside_home(self) -> None:
        result = self.run_queue(["Fix.Alpha"], Path("/tmp/lean-build-queue-should-refuse"))
        self.assertEqual(result.returncode, 2)
        self.assertIn("disk-backed", result.stderr)
        self.assertFalse(Path("/tmp/lean-build-queue-should-refuse").exists())

    # gate 6: the final aggregate gate can fail on its own -------------------

    def test_aggregate_gate_fails_when_leaves_are_insufficient(self) -> None:
        run_dir = self.tmp / "run6"
        result = self.run_queue(
            ["Fix.Alpha"], run_dir, extra=["--aggregate", "Fix.Umbrella"]
        )
        self.assertEqual(result.returncode, 1)
        self.assertIn("aggregate gate", result.stderr)

        status = self.read_status(run_dir)
        self.assertEqual(status["state"], "failed")
        self.assertEqual(status["failed_target"], "<aggregate>")
        outcomes = {e["target"]: e["outcome"] for e in status["results"]}
        self.assertEqual(outcomes["Fix.Alpha"], "built")
        self.assertEqual(outcomes["<aggregate>"], "failed")
        # The gate is trace-only: it must never try to build the umbrella.
        self.assertNotIn("nobuild=0 targets=Fix.Umbrella", (self.state / "lake-calls.log").read_text())


if __name__ == "__main__":
    unittest.main(verbosity=2)
