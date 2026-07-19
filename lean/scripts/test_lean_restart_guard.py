#!/usr/bin/env python3
"""Tests for lean-restart-guard.py.

Fully hermetic: every test redirects the guard's Lean root and build library at a throwaway
directory, and the two subprocess boundaries (``pgrep``, ``lake build --no-build``) are stubbed, so
the suite never reads the real Lean tree, never stats real build output, and never builds.  Run:

    python3 lean/scripts/test_lean_restart_guard.py

The guard's whole promise is that a sentinel it validated before a restart is still *current and
byte-identical* after one, so the failure modes are the specification: a flipped byte, a deleted
artifact, an artifact map that does not cover what was checkpointed, a checkpoint recorded against a
different Lean root, and a resumed build log that rebuilt a sentinel must each be refused with a
diagnostic and exit 2.  A guard that passes when it should refuse is worse than no guard, because
the restart decision is made on its word.
"""

from __future__ import annotations

import argparse
import importlib.util
import io
import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path
from unittest import mock

SCRIPT = Path(__file__).resolve().parent / "lean-restart-guard.py"


def _load_module():
    spec = importlib.util.spec_from_file_location("lean_restart_guard", SCRIPT)
    module = importlib.util.module_from_spec(spec)
    sys.modules["lean_restart_guard"] = module
    spec.loader.exec_module(module)
    return module


rg = _load_module()

# Captured before any test stubs them, so the tests that own a subprocess boundary can restore it.
REAL_ASSERT_NO_LAKE = rg.assert_no_lake
REAL_LAKE_NO_BUILD = rg.lake_no_build


class GuardCase(unittest.TestCase):
    """Base fixture: a fake Lean root, a fake home, and neutralized subprocess boundaries."""

    def setUp(self):
        tmp = tempfile.TemporaryDirectory()
        self.addCleanup(tmp.cleanup)
        self.tmp = Path(tmp.name).resolve()

        self.lean_root = self.tmp / "lean"
        self.build_lib = self.lean_root / ".lake" / "build" / "lib" / "lean"
        self.build_lib.mkdir(parents=True)
        self.home = self.tmp / "home"
        self.home.mkdir()

        # The guard prints operator guidance on success; keep the suite's own output bounded.
        self.enter(mock.patch.object(sys, "stdout", new_callable=io.StringIO))

        self.enter(mock.patch.object(rg, "LEAN_ROOT", self.lean_root))
        self.enter(mock.patch.object(rg, "BUILD_LIB", self.build_lib))
        self.enter(mock.patch.object(rg.Path, "home", lambda: self.home))

        # Both real boundaries are stubbed by default; the tests that own them re-patch locally.
        self.enter(mock.patch.object(rg, "assert_no_lake", lambda: None))
        self.probed: list[list[str]] = []
        self.enter(mock.patch.object(rg, "lake_no_build", self.probed.append))

    def enter(self, patcher):
        value = patcher.start()
        self.addCleanup(patcher.stop)
        return value

    def write_artifacts(self, module: str, seed: str = "v1") -> list[Path]:
        base = self.build_lib.joinpath(*module.split("."))
        base.parent.mkdir(parents=True, exist_ok=True)
        written = []
        for suffix in rg.REQUIRED_SUFFIXES:
            path = Path(f"{base}{suffix}")
            path.write_text(f"{module}{suffix}{seed}\n", encoding="utf-8")
            written.append(path)
        return written

    def checkpoint(self, directory: Path, *modules: str) -> Path:
        rg.command_checkpoint(argparse.Namespace(directory=directory, modules=list(modules)))
        return directory

    def assert_refuses(self, function, *args, contains: str | None = None):
        with self.assertRaises(SystemExit) as caught:
            function(*args)
        self.assertEqual(caught.exception.code, 2)
        if contains is not None:
            self.assertIn(contains, self.stderr.getvalue())

    def setup_stderr(self):
        self.stderr = self.enter(mock.patch.object(sys, "stderr", new_callable=io.StringIO))


class ModuleNameTests(GuardCase):
    def setUp(self):
        super().setUp()
        self.setup_stderr()

    def test_dotted_name_maps_to_nested_path(self):
        self.assertEqual(
            rg.module_base("RelativeConicArcs.Plane"),
            self.build_lib / "RelativeConicArcs" / "Plane",
        )

    def test_traversal_in_a_module_name_is_refused(self):
        # Without this the module name reaches joinpath and can address any file on the host.
        for name in ["../../etc/passwd", "A/../../B", "A.../B"]:
            self.assert_refuses(rg.module_base, name, contains="invalid module name")

    def test_shell_and_whitespace_names_are_refused(self):
        for name in ["A B", "A;rm -rf /", "A$(id)", "", "A.", ".A"]:
            self.assert_refuses(rg.module_base, name, contains="invalid module name")


class ArtifactPathTests(GuardCase):
    def setUp(self):
        super().setUp()
        self.setup_stderr()

    def test_all_required_artifacts_are_returned(self):
        self.write_artifacts("Demo.Mod")
        paths = rg.artifact_paths("Demo.Mod")
        self.assertEqual([p.name for p in paths], [f"Mod{s}" for s in rg.REQUIRED_SUFFIXES])

    def test_a_single_missing_artifact_refuses_the_sentinel(self):
        # A module with an olean but no trace is exactly the stale-looking state the guard exists to
        # reject; mtimes and a present olean are not evidence of freshness.
        for dropped in rg.REQUIRED_SUFFIXES:
            with self.subTest(dropped=dropped):
                self.write_artifacts("Demo.Mod")
                Path(f"{rg.module_base('Demo.Mod')}{dropped}").unlink()
                self.assert_refuses(rg.artifact_paths, "Demo.Mod", contains="missing artifacts")

    def test_a_directory_does_not_count_as_an_artifact(self):
        base = self.build_lib / "Demo" / "Mod"
        base.parent.mkdir(parents=True)
        for suffix in rg.REQUIRED_SUFFIXES:
            Path(f"{base}{suffix}").mkdir()
        self.assert_refuses(rg.artifact_paths, "Demo.Mod", contains="missing artifacts")


class LiveLakeTests(GuardCase):
    """assert_no_lake is a safety interlock: every ambiguous answer must refuse."""

    def setUp(self):
        super().setUp()
        self.setup_stderr()
        self.enter(mock.patch.object(rg, "assert_no_lake", REAL_ASSERT_NO_LAKE))

    def _pgrep(self, returncode):
        def run(*_args, **_kwargs):
            return subprocess.CompletedProcess([], returncode)

        self.enter(mock.patch.object(rg.shutil, "which", lambda _name: "/usr/bin/pgrep"))
        self.enter(mock.patch.object(rg.subprocess, "run", run))

    def test_running_lake_refuses(self):
        self._pgrep(0)
        self.assert_refuses(rg.assert_no_lake, contains="lake.orig is running")

    def test_absent_lake_is_permitted(self):
        self._pgrep(1)
        self.assertIsNone(rg.assert_no_lake())

    def test_pgrep_error_is_refused_not_treated_as_absence(self):
        # exit >=2 means pgrep failed, which is not evidence that Lake is stopped.
        for code in [2, 3, 127]:
            with self.subTest(code=code):
                self._pgrep(code)
                self.assert_refuses(rg.assert_no_lake, contains="pgrep failed")

    def test_missing_pgrep_is_refused(self):
        self.enter(mock.patch.object(rg.shutil, "which", lambda _name: None))
        self.assert_refuses(rg.assert_no_lake, contains="pgrep is unavailable")


class NoBuildProbeTests(GuardCase):
    def setUp(self):
        super().setUp()
        self.setup_stderr()
        self.enter(mock.patch.object(rg, "lake_no_build", REAL_LAKE_NO_BUILD))
        self.calls: list[dict] = []

    def _lake(self, returncode):
        def run(command, **kwargs):
            self.calls.append({"command": command, **kwargs})
            return subprocess.CompletedProcess(command, returncode)

        self.enter(mock.patch.object(rg.shutil, "which", lambda _name: "/usr/bin/lake"))
        self.enter(mock.patch.object(rg.subprocess, "run", run))

    def test_probe_is_no_build_single_threaded_and_rooted(self):
        self._lake(0)
        rg.lake_no_build(["Demo.One", "Demo.Two"])
        call = self.calls[0]
        self.assertEqual(call["command"][1:], ["build", "--no-build", "Demo.One", "Demo.Two"])
        self.assertEqual(call["env"]["LEAN_NUM_THREADS"], "1")
        self.assertEqual(call["cwd"], self.lean_root)

    def test_a_stale_sentinel_refuses(self):
        self._lake(1)
        self.assert_refuses(rg.lake_no_build, ["Demo.One"], contains="not current")

    def test_missing_lake_is_refused(self):
        self.enter(mock.patch.object(rg.shutil, "which", lambda _name: None))
        self.assert_refuses(rg.lake_no_build, ["Demo.One"], contains="lake is unavailable")


class CheckpointTests(GuardCase):
    def setUp(self):
        super().setUp()
        self.setup_stderr()

    def test_checkpoint_records_a_hash_for_every_artifact(self):
        self.write_artifacts("Demo.Mod")
        destination = self.checkpoint(self.home / "cp", "Demo.Mod")
        data = json.loads((destination / rg.CHECKPOINT_FILE).read_text())
        self.assertEqual(data["format"], 1)
        self.assertEqual(data["lean_root"], str(self.lean_root))
        artifacts = data["sentinels"][0]["artifacts"]
        self.assertEqual(len(artifacts), len(rg.REQUIRED_SUFFIXES))
        self.assertTrue(all(len(digest) == 64 for digest in artifacts.values()))

    def test_recorded_hash_is_the_real_digest(self):
        import hashlib

        paths = self.write_artifacts("Demo.Mod")
        destination = self.checkpoint(self.home / "cp", "Demo.Mod")
        artifacts = json.loads((destination / rg.CHECKPOINT_FILE).read_text())["sentinels"][0][
            "artifacts"
        ]
        for path in paths:
            expected = hashlib.sha256(path.read_bytes()).hexdigest()
            self.assertEqual(artifacts[str(path.relative_to(self.lean_root))], expected)

    def test_the_no_build_probe_covers_every_sentinel(self):
        self.write_artifacts("Demo.One")
        self.write_artifacts("Demo.Two")
        self.checkpoint(self.home / "cp", "Demo.One", "Demo.Two")
        self.assertEqual(self.probed, [["Demo.One", "Demo.Two"]])

    def test_duplicate_modules_are_probed_and_recorded_once(self):
        self.write_artifacts("Demo.Mod")
        destination = self.checkpoint(self.home / "cp", "Demo.Mod", "Demo.Mod")
        self.assertEqual(self.probed, [["Demo.Mod"]])
        data = json.loads((destination / rg.CHECKPOINT_FILE).read_text())
        self.assertEqual(len(data["sentinels"]), 1)

    def test_memory_backed_destination_is_refused(self):
        # /tmp is tmpfs on this host, so a checkpoint there is lost on reboot and costs RAM.
        self.write_artifacts("Demo.Mod")
        self.assert_refuses(
            self.checkpoint, self.tmp / "outside", "Demo.Mod", contains="must be disk-backed"
        )

    def test_existing_destination_is_never_overwritten(self):
        self.write_artifacts("Demo.Mod")
        (self.home / "cp").mkdir()
        self.assert_refuses(
            self.checkpoint, self.home / "cp", "Demo.Mod", contains="already exists"
        )

    def test_no_sentinels_is_refused(self):
        self.assert_refuses(
            rg.command_checkpoint,
            argparse.Namespace(directory=self.home / "cp", modules=[]),
            contains="at least one",
        )

    def test_a_stale_sentinel_leaves_no_checkpoint_behind(self):
        # Ordering matters: the probe must run before anything is written, or a refused checkpoint
        # still leaves a directory that a later verify would happily read.
        self.write_artifacts("Demo.Mod")
        self.enter(mock.patch.object(rg, "lake_no_build", lambda _modules: rg.fail("not current")))
        self.assert_refuses(self.checkpoint, self.home / "cp", "Demo.Mod")
        self.assertFalse((self.home / "cp").exists())

    def test_a_running_lake_blocks_before_any_probe_or_write(self):
        self.write_artifacts("Demo.Mod")
        self.enter(mock.patch.object(rg, "assert_no_lake", lambda: rg.fail("lake.orig is running")))
        self.assert_refuses(self.checkpoint, self.home / "cp", "Demo.Mod")
        self.assertEqual(self.probed, [])
        self.assertFalse((self.home / "cp").exists())


class VerifyTests(GuardCase):
    def setUp(self):
        super().setUp()
        self.setup_stderr()
        self.write_artifacts("Demo.Mod")
        self.destination = self.checkpoint(self.home / "cp", "Demo.Mod")

    def _verify(self):
        rg.command_verify(argparse.Namespace(directory=self.destination))

    def _rewrite(self, mutate):
        path = self.destination / rg.CHECKPOINT_FILE
        data = json.loads(path.read_text())
        mutate(data)
        path.write_text(json.dumps(data, indent=2, sort_keys=True) + "\n")

    def test_unchanged_artifacts_verify(self):
        self.assertIsNone(self._verify())

    def test_verify_reprobes_currency(self):
        self.probed.clear()
        self._verify()
        self.assertEqual(self.probed, [["Demo.Mod"]])

    def test_one_flipped_byte_is_caught(self):
        target = Path(f"{rg.module_base('Demo.Mod')}.olean")
        original = target.read_bytes()
        target.write_bytes(original[:-1] + bytes([original[-1] ^ 0x01]))
        self.assert_refuses(self._verify, contains="changed")

    def test_every_artifact_kind_is_actually_hashed(self):
        # A guard that only hashed the olean would pass three of these four.
        for suffix in rg.REQUIRED_SUFFIXES:
            with self.subTest(suffix=suffix):
                path = Path(f"{rg.module_base('Demo.Mod')}{suffix}")
                original = path.read_text()
                path.write_text(original + "tamper\n")
                self.assert_refuses(self._verify, contains="changed")
                path.write_text(original)
        self.assertIsNone(self._verify())

    def test_a_deleted_artifact_is_caught(self):
        Path(f"{rg.module_base('Demo.Mod')}.trace").unlink()
        self.assert_refuses(self._verify, contains="missing")

    def test_checkpoint_from_another_lean_root_is_refused(self):
        self._rewrite(lambda data: data.update(lean_root="/somewhere/else/lean"))
        self.assert_refuses(self._verify, contains="different Lean root")

    def test_missing_checkpoint_file_is_refused(self):
        (self.destination / rg.CHECKPOINT_FILE).unlink()
        self.assert_refuses(self._verify, contains="does not exist")

    def test_corrupt_checkpoint_json_is_refused(self):
        (self.destination / rg.CHECKPOINT_FILE).write_text("{not json")
        self.assert_refuses(self._verify, contains="cannot read checkpoint")

    def test_empty_sentinel_list_is_refused(self):
        self._rewrite(lambda data: data.update(sentinels=[]))
        self.assert_refuses(self._verify, contains="no sentinels")

    def test_malformed_sentinel_is_refused(self):
        for broken in [["string"], [{"artifacts": {}}], [{"module": 7}], [None]]:
            with self.subTest(broken=broken):
                self._rewrite(lambda data, b=broken: data.update(sentinels=b))
                self.assert_refuses(self._verify, contains="malformed sentinel")

    def test_an_emptied_artifact_map_cannot_verify_vacuously(self):
        # Regression: an empty map used to satisfy verify, which then reported byte-identical
        # sentinels while hashing nothing at all.
        self._rewrite(lambda data: data["sentinels"][0].update(artifacts={}))
        self.assert_refuses(self._verify, contains="no artifact map")

    def test_a_dropped_artifact_entry_cannot_verify_vacuously(self):
        # Regression: deleting the .trace entry used to narrow verify silently to what remained.
        def drop_trace(data):
            artifacts = data["sentinels"][0]["artifacts"]
            for relative in list(artifacts):
                if relative.endswith(".trace"):
                    del artifacts[relative]

        self._rewrite(drop_trace)
        self.assert_refuses(self._verify, contains="does not record")

    def test_malformed_artifact_entry_is_refused(self):
        self._rewrite(lambda data: data["sentinels"][0].update(artifacts={"x": 5}))
        self.assert_refuses(self._verify, contains="malformed artifact entry")

    def test_a_path_escaping_the_build_library_is_refused(self):
        self._rewrite(
            lambda data: data["sentinels"][0].update(
                artifacts={"../../../../etc/passwd": "0" * 64}
            )
        )
        self.assert_refuses(self._verify, contains="escapes the build library")

    def test_a_symlink_out_of_the_build_library_is_refused(self):
        # The check resolves before comparing, so a link planted inside the tree cannot smuggle an
        # external file into the verified set.
        outside = self.tmp / "outside.olean"
        outside.write_text("outside\n")
        link = self.build_lib / "Linked.olean"
        link.symlink_to(outside)
        self._rewrite(
            lambda data: data["sentinels"][0].update(
                artifacts={str(link.relative_to(self.lean_root)): "0" * 64}
            )
        )
        self.assert_refuses(self._verify, contains="escapes the build library")


class AuditLogTests(GuardCase):
    def setUp(self):
        super().setUp()
        self.setup_stderr()
        self.write_artifacts("Demo.Mod")
        self.destination = self.checkpoint(self.home / "cp", "Demo.Mod")

    def _audit(self, text, *, encoding="utf-8"):
        log = self.tmp / "restart.log"
        if isinstance(text, bytes):
            log.write_bytes(text)
        else:
            log.write_text(text, encoding=encoding)
        rg.command_audit_log(argparse.Namespace(directory=self.destination, log=log))

    def test_a_log_that_rebuilds_a_sentinel_is_refused(self):
        # The point of the checkpoint: if the resumed build re-elaborated a validated sentinel, the
        # restart was not safe and the evidence is void.
        self.assert_refuses(self._audit, "Built Other.Thing\nBuilt Demo.Mod\n", contains="rebuilt")

    def test_a_clean_log_passes(self):
        self.assertIsNone(self._audit("Built Other.Thing\nBuilt Demo.Modification\n"))

    def test_a_longer_module_name_is_not_a_match(self):
        # `Built Demo.Mod` must not be found inside `Built Demo.Modular`; a substring match here
        # would report a rebuild that never happened and block a valid restart.
        self.assertIsNone(self._audit("Built Demo.Modular\n"))

    def test_trailing_build_annotations_still_match(self):
        self.assert_refuses(self._audit, "Built Demo.Mod (2.7s)\n", contains="rebuilt")

    def test_the_marker_is_anchored_at_a_word_boundary(self):
        self.assertIsNone(self._audit("Prebuilt Demo.Mod\n"))

    def test_undecodable_log_bytes_do_not_crash(self):
        self.assert_refuses(self._audit, b"Built \xff\xfe\nBuilt Demo.Mod\n", contains="rebuilt")

    def test_missing_log_is_refused(self):
        self.assert_refuses(
            rg.command_audit_log,
            argparse.Namespace(directory=self.destination, log=self.tmp / "absent.log"),
            contains="cannot read build log",
        )

    def test_malformed_checkpoint_is_refused_not_crashed(self):
        # Regression: audit-log parsed sentinels without validation, so a sentinel dict with no
        # module key raised KeyError, and a non-list sentinels field relied on a bare assert that
        # vanishes under `python3 -O`.
        path = self.destination / rg.CHECKPOINT_FILE
        for broken in [{"artifacts": {}}, "string", 7]:
            with self.subTest(broken=broken):
                data = json.loads(path.read_text())
                data["sentinels"] = [broken]
                path.write_text(json.dumps(data, indent=2, sort_keys=True) + "\n")
                self.assert_refuses(self._audit, "Built Other.Thing\n")

        data = json.loads(path.read_text())
        data["sentinels"] = {"module": "Demo.Mod"}
        path.write_text(json.dumps(data, indent=2, sort_keys=True) + "\n")
        self.assert_refuses(self._audit, "Built Other.Thing\n", contains="no sentinels")

    def test_audit_log_does_not_require_a_stopped_lake(self):
        # Reading a log mutates nothing, so it must stay usable while a build runs.
        self.enter(mock.patch.object(rg, "assert_no_lake", lambda: rg.fail("lake.orig is running")))
        self.assertIsNone(self._audit("Built Other.Thing\n"))


class ParserTests(GuardCase):
    def test_checkpoint_requires_at_least_one_module(self):
        with mock.patch.object(sys, "stderr", new_callable=io.StringIO):
            with self.assertRaises(SystemExit):
                rg.parser().parse_args(["checkpoint", "/home/cp"])

    def test_a_command_is_required(self):
        with mock.patch.object(sys, "stderr", new_callable=io.StringIO):
            with self.assertRaises(SystemExit):
                rg.parser().parse_args([])


if __name__ == "__main__":
    unittest.main(verbosity=1)
