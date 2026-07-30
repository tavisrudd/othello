#!/usr/bin/env python3

import os
from pathlib import Path
import subprocess
import tempfile
import unittest


SCRIPT = Path(__file__).with_name("guarded-lean")


class GuardedLeanSessionTests(unittest.TestCase):
    def run_guard(self, *args: str, env: dict[str, str]) -> subprocess.CompletedProcess[str]:
        return subprocess.run(
            [str(SCRIPT), *args],
            env=env,
            text=True,
            capture_output=True,
            check=False,
        )

    def test_set_merges_show_and_clear(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "session.env"
            env = os.environ | {"LEAN_GUARD_SESSION_ENV": str(path)}
            first = self.run_guard(
                "--session-set",
                "LEAN_GUARD_CPUSET=20-21",
                "LEAN_GUARD_THREADS=2",
                env=env,
            )
            self.assertEqual(first.returncode, 0, first.stderr)
            second = self.run_guard(
                "--session-set", "LEAN_GUARD_PROFILE=q25-two-witness", env=env
            )
            self.assertEqual(second.returncode, 0, second.stderr)
            shown = self.run_guard("--session-show", env=env)
            self.assertEqual(shown.returncode, 0, shown.stderr)
            self.assertIn("LEAN_GUARD_CPUSET=20-21", shown.stdout)
            self.assertIn("LEAN_GUARD_THREADS=2", shown.stdout)
            self.assertIn("LEAN_GUARD_PROFILE=q25-two-witness", shown.stdout)
            cleared = self.run_guard("--session-clear", env=env)
            self.assertEqual(cleared.returncode, 0, cleared.stderr)
            self.assertFalse(path.exists())

    def test_invalid_key_is_rejected_without_file(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "session.env"
            env = os.environ | {"LEAN_GUARD_SESSION_ENV": str(path)}
            result = self.run_guard("--session-set", "PATH=/tmp", env=env)
            self.assertEqual(result.returncode, 2)
            self.assertIn("unsupported or invalid", result.stderr)
            self.assertFalse(path.exists())

    def test_codex_thread_ids_get_distinct_default_files(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            base = os.environ.copy()
            base.pop("LEAN_GUARD_SESSION_ENV", None)
            first_env = base | {"HOME": directory, "CODEX_THREAD_ID": "thread-one"}
            second_env = base | {"HOME": directory, "CODEX_THREAD_ID": "thread-two"}
            first = self.run_guard(
                "--session-set", "LEAN_GUARD_THREADS=2", env=first_env
            )
            self.assertEqual(first.returncode, 0, first.stderr)
            second = self.run_guard("--session-show", env=second_env)
            self.assertEqual(second.returncode, 0, second.stderr)
            self.assertIn("thread-two.env (unset)", second.stdout)
            expected = (
                Path(directory)
                / ".cache/othello-lean-build/guarded-lean-sessions/thread-one.env"
            )
            self.assertTrue(expected.exists())

    def test_root_must_be_absolute(self) -> None:
        result = self.run_guard("--root", "relative", "Example.lean", env=os.environ.copy())
        self.assertEqual(result.returncode, 2)
        self.assertIn("--root must be absolute", result.stderr)

    def test_root_must_be_a_lean_package(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            result = self.run_guard(
                "--root", directory, "Example.lean", env=os.environ.copy()
            )
            self.assertEqual(result.returncode, 2)
            self.assertIn("must contain lakefile", result.stderr)


if __name__ == "__main__":
    unittest.main()
