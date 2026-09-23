"""Regression checks for false-green matrix receipts; no Ergodis build runs."""

import contextlib
import importlib.util
import io
import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest.mock import patch


spec = importlib.util.spec_from_file_location(
    "validation_matrix", Path(__file__).with_name("ergodis-validation-matrix.py"))
matrix = importlib.util.module_from_spec(spec)
spec.loader.exec_module(matrix)


class ReceiptTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        for name in ("ergodis", "ergodis-private"):
            repo = self.root / name
            repo.mkdir()
            subprocess.run(["git", "init", "--quiet", str(repo)], check=True)
            subprocess.run([
                "git", "-c", "user.name=Matrix test", "-c", "user.email=matrix@example.invalid",
                "-c", "core.hooksPath=/dev/null", "-c", "commit.gpgSign=false",
                "commit", "--quiet", "--allow-empty", "-m", "fixture",
            ], cwd=repo, check=True)
        members = [f"packages/{family}-provider" for family in matrix.FAMILIES]
        (self.root / "ergodis-private/Cargo.toml").write_text(
            "[workspace]\nmembers = " + json.dumps(members) + "\n")

    def test_existing_untracked_source_content_change_changes_snapshot(self):
        file = self.root / "ergodis" / "new source\nfile.rs"
        file.write_text("pub fn value() -> u32 { 1 }\n")
        before = matrix.source_state(file.parent)
        file.write_text("pub fn value() -> u32 { 2 }\n")
        after = matrix.source_state(file.parent)
        self.assertEqual(before["status"], after["status"])
        self.assertEqual(before["tracked_diff_sha256"], after["tracked_diff_sha256"])
        self.assertNotEqual(before["untracked_sha256"], after["untracked_sha256"])

    def invoke(self, gate, execute, output_name="result", env=None):
        output = self.root / output_name
        argv = ["matrix", "--repos-root", str(self.root), "--run", gate, "--output", str(output)]
        original_capture = matrix.capture
        original_run = subprocess.run

        def capture(command, cwd):
            if command[0] == "nix":
                return "test compiler (no build executed)"
            return original_capture(command, cwd)

        def dispatch(command, **kwargs):
            if command[0] == "nix":
                return execute(command, **kwargs)
            return original_run(command, **kwargs)

        test_env = dict(PATH=os.environ["PATH"], **(env or {}))
        with patch.dict(os.environ, test_env, clear=True), patch("sys.argv", argv), \
                patch.object(matrix, "capture", side_effect=capture), \
                patch.object(matrix.subprocess, "run", side_effect=dispatch), \
                contextlib.redirect_stdout(io.StringIO()):
            code = matrix.main()
        return code, json.loads((output / "receipt.json").read_text())

    def test_failed_fresh_build_cannot_run_smoke_of_old_artifact(self):
        calls = []

        def execute(command, **kwargs):
            calls.append(command)
            return subprocess.CompletedProcess(command, 17 if command == ["nix", "run", ".#wasm-build"] else 0)

        code, receipt = self.invoke("browser", execute)
        self.assertEqual(code, 1)
        self.assertFalse(receipt["accepted"])
        self.assertEqual(len(calls), 2)
        row = next(row for row in receipt["rows"] if row["id"] == "browser")
        self.assertEqual(row["status"], "failed")
        self.assertNotIn("artifact_sha256", row)
        self.assertTrue(all(row["status"] == "skipped:not-selected"
                            for row in receipt["rows"] if row["id"] != "browser"))

    def test_changed_source_cannot_produce_accepted_receipt(self):
        file = self.root / "ergodis/new.rs"
        file.write_text("before\n")

        def execute(command, **kwargs):
            file.write_text("after\n")
            return subprocess.CompletedProcess(command, 0)

        code, receipt = self.invoke("core-default", execute)
        self.assertEqual(code, 1)
        self.assertFalse(receipt["accepted"])
        self.assertFalse(receipt["source_state_unchanged"])

    def test_target_override_is_rejected_before_execution(self):
        with contextlib.redirect_stderr(io.StringIO()), self.assertRaises(SystemExit) as raised:
            self.invoke("core-default", lambda *_args, **_kwargs: self.fail("must not execute"),
                        env={"CARGO_TARGET_DIR": str(self.root / "extra-target")})
        self.assertEqual(raised.exception.code, 2)
        self.assertFalse((self.root / "result").exists())


if __name__ == "__main__":
    unittest.main()
