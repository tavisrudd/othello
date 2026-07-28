#!/usr/bin/env python3
"""Hermetic adversarial tests for export-paper-repos.py."""

from __future__ import annotations

import importlib.util
import hashlib
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path
from typing import Any

SCRIPT = Path(__file__).with_name("export-paper-repos.py")
SPEC = importlib.util.spec_from_file_location("export_paper_repos", SCRIPT)
assert SPEC is not None and SPEC.loader is not None
exporter = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = exporter
SPEC.loader.exec_module(exporter)


def run(root: Path, *args: str) -> None:
    subprocess.run(args, cwd=root, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)


class Fixture:
    def __init__(self) -> None:
        self.tmp = tempfile.TemporaryDirectory()
        self.root = Path(self.tmp.name)
        run(self.root, "git", "init", "-q")
        run(self.root, "git", "config", "user.name", "C684 Test")
        run(self.root, "git", "config", "user.email", "c684@example.invalid")
        run(self.root, "git", "config", "commit.gpgsign", "false")
        (self.root / "lean/trust").mkdir(parents=True)
        (self.root / "papers/demo").mkdir(parents=True)
        (self.root / "papers/scripts").mkdir(parents=True)
        (self.root / "lean/trust/papers.toml").write_text(
            """\
schema_version = 1
[[paper]]
id = "demo"
dir = "papers/demo"
main = "main.tex"
lane = "build-sys"
""",
            encoding="utf-8",
        )
        (self.root / "papers/repositories.toml").write_text(
            """\
schema_version = 1
[destinations]
local_root = "~/src/math-papers"
github_owner = "tavisrudd"
[[repository]]
name = "demo-paper"
source = "papers/demo"
paper_ids = ["demo"]
disposition = "active"
""",
            encoding="utf-8",
        )
        (self.root / "papers/demo/main.tex").write_text(
            "\\\\documentclass{article}\n\\\\begin{document}Demo\\\\end{document}\n",
            encoding="utf-8",
        )
        (self.root / "papers/scripts/export-paper-repos.py").write_bytes(SCRIPT.read_bytes())
        run(self.root, "git", "add", "lean/trust/papers.toml", "papers")
        run(self.root, "git", "commit", "-qm", "fixture")
        self.commit = self.output("git", "rev-parse", "HEAD").strip()

    def output(self, *args: str) -> str:
        return subprocess.run(
            args,
            cwd=self.root,
            check=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
        ).stdout

    def close(self) -> None:
        self.tmp.cleanup()


class ExportPlannerTests(unittest.TestCase):
    def setUp(self) -> None:
        self.fx = Fixture()
        self.old_root = exporter.REPO_ROOT
        exporter.REPO_ROOT = self.fx.root

    def tearDown(self) -> None:
        exporter.REPO_ROOT = self.old_root
        self.fx.close()

    def mapping(self) -> tuple[dict[str, Any], dict[str, dict[str, Any]]]:
        mapping = exporter.load_toml(self.fx.commit, exporter.REPOSITORY_MAP)
        papers = exporter.registry_index(
            exporter.load_toml(self.fx.commit, exporter.PAPER_REGISTRY)
        )
        return mapping, papers

    def test_plan_uses_immutable_commit_not_dirty_worktree(self) -> None:
        first = exporter.build_plan(self.fx.commit)
        (self.fx.root / "papers/demo/main.tex").write_text("../../notes/private.md\n")
        second = exporter.build_plan(self.fx.commit)
        self.assertEqual(first, second)
        self.assertEqual(first["repositories"][0]["reference_findings"], [])

    def test_plan_is_deterministic_and_supports_selection(self) -> None:
        first = exporter.build_plan(self.fx.commit, "demo-paper")
        second = exporter.build_plan(self.fx.commit, "demo-paper")
        self.assertEqual(first, second)
        self.assertEqual(first["repositories"][0]["main_sources"], ["main.tex"])
        with self.assertRaisesRegex(exporter.Refused, "no mapped repository"):
            exporter.build_plan(self.fx.commit, "absent")

    def test_rejects_unmapped_registry_row(self) -> None:
        mapping, papers = self.mapping()
        papers["other"] = {
            "id": "other",
            "dir": "papers/other",
            "main": "main.tex",
            "lane": "build-sys",
        }
        with self.assertRaisesRegex(exporter.Refused, "no repository mapping"):
            exporter.validate_map(mapping, papers)

    def test_rejects_casefold_destination_collision(self) -> None:
        mapping, papers = self.mapping()
        duplicate = dict(mapping["repository"][0])
        duplicate["name"] = "demo-paper"
        duplicate["source"] = "papers/other"
        duplicate["paper_ids"] = ["other"]
        papers["other"] = {
            "id": "other",
            "dir": "papers/other",
            "main": "main.tex",
            "lane": "build-sys",
        }
        mapping["repository"].append(duplicate)
        with self.assertRaisesRegex(exporter.Refused, "collide"):
            exporter.validate_map(mapping, papers)

    def test_rejects_unsafe_source_path(self) -> None:
        mapping, papers = self.mapping()
        mapping["repository"][0]["source"] = "../papers/demo"
        with self.assertRaisesRegex(exporter.Refused, "normalized relative path"):
            exporter.validate_map(mapping, papers)

    def test_rejects_undeclared_symlink_and_stale_disposition(self) -> None:
        target = self.fx.root / "notes/private.md"
        target.parent.mkdir()
        target.write_text("private\n")
        (self.fx.root / "papers/demo/private.md").symlink_to("../../notes/private.md")
        run(self.fx.root, "git", "add", "notes/private.md", "papers/demo/private.md")
        run(self.fx.root, "git", "commit", "-qm", "symlink")
        commit = self.fx.output("git", "rev-parse", "HEAD").strip()
        papers = exporter.registry_index(exporter.load_toml(commit, exporter.PAPER_REGISTRY))
        row = exporter.load_toml(commit, exporter.REPOSITORY_MAP)["repository"][0]
        with self.assertRaisesRegex(exporter.Refused, "no disposition"):
            exporter.plan_repository(commit, row, papers)
        row["exclude_symlink"] = [
            {"path": "private.md", "reason": "fixture"},
            {"path": "missing.md", "reason": "fixture"},
        ]
        with self.assertRaisesRegex(exporter.Refused, "not symlinks"):
            exporter.plan_repository(commit, row, papers)

    def test_detects_private_reference_from_committed_blob(self) -> None:
        (self.fx.root / "papers/demo/main.tex").write_text("../../notes/private.md\n")
        run(self.fx.root, "git", "add", "papers/demo/main.tex")
        run(self.fx.root, "git", "commit", "-qm", "private reference")
        commit = self.fx.output("git", "rev-parse", "HEAD").strip()
        findings = exporter.build_plan(commit)["repositories"][0]["reference_findings"]
        self.assertEqual(findings, [{"code": "private-notes", "path": "main.tex", "line": 1}])

    def test_detects_monorepo_paper_root_command(self) -> None:
        (self.fx.root / "papers/demo/main.tex").write_text(
            "python3 papers/demo/verification/check.py\n"
        )
        run(self.fx.root, "git", "add", "papers/demo/main.tex")
        run(self.fx.root, "git", "commit", "-qm", "monorepo-root command")
        commit = self.fx.output("git", "rev-parse", "HEAD").strip()
        findings = exporter.build_plan(commit)["repositories"][0]["reference_findings"]
        self.assertEqual(findings, [{"code": "paper-root", "path": "main.tex", "line": 1}])

    def test_detects_task_ids_but_preserves_mathematical_class_labels(self) -> None:
        (self.fx.root / "papers/demo/main.tex").write_text(
            "Classes C01 and C15 remain public; lanes C684 and c685 do not.\n"
            "A SHA-256 value beginning c216d8ba is not a task identifier.\n"
        )
        run(self.fx.root, "git", "add", "papers/demo/main.tex")
        run(self.fx.root, "git", "commit", "-qm", "task identifier")
        commit = self.fx.output("git", "rev-parse", "HEAD").strip()
        findings = exporter.build_plan(commit)["repositories"][0]["reference_findings"]
        self.assertEqual(
            findings,
            [
                {"code": "task-lane-id", "path": "main.tex", "line": 1},
            ],
        )

    def test_detects_task_id_in_path(self) -> None:
        (self.fx.root / "papers/demo/c684-check.py").write_text("print('public')\n")
        run(self.fx.root, "git", "add", "papers/demo/c684-check.py")
        run(self.fx.root, "git", "commit", "-qm", "task path")
        commit = self.fx.output("git", "rev-parse", "HEAD").strip()
        findings = exporter.build_plan(commit)["repositories"][0]["reference_findings"]
        self.assertEqual(
            findings,
            [{"code": "task-lane-path", "path": "c684-check.py", "line": 0}],
        )

    def test_detects_internal_process_file_by_path(self) -> None:
        (self.fx.root / "papers/demo/FINAL-READER-SIGNOFF.md").write_text("private\n")
        run(self.fx.root, "git", "add", "papers/demo/FINAL-READER-SIGNOFF.md")
        run(self.fx.root, "git", "commit", "-qm", "process file")
        commit = self.fx.output("git", "rev-parse", "HEAD").strip()
        findings = exporter.build_plan(commit)["repositories"][0]["reference_findings"]
        self.assertEqual(
            findings,
            [
                {
                    "code": "internal-process-file",
                    "path": "FINAL-READER-SIGNOFF.md",
                    "line": 0,
                }
            ],
        )

    def test_explicit_regular_file_exclusion_is_recorded_and_validated(self) -> None:
        (self.fx.root / "papers/demo/private-review.md").write_text("lane C684\n")
        mapping = (self.fx.root / "papers/repositories.toml").read_text()
        mapping += """\
[[repository.exclude_path]]
path = "private-review.md"
reason = "private review record"
"""
        (self.fx.root / "papers/repositories.toml").write_text(mapping)
        run(
            self.fx.root,
            "git",
            "add",
            "papers/demo/private-review.md",
            "papers/repositories.toml",
        )
        run(self.fx.root, "git", "commit", "-qm", "regular exclusion")
        commit = self.fx.output("git", "rev-parse", "HEAD").strip()
        plan = exporter.build_plan(commit)["repositories"][0]
        self.assertEqual(plan["excluded_paths"], 1)
        self.assertEqual(plan["reference_findings"], [])
        manifest = exporter.materialize_repository(
            commit, "demo-paper", self.fx.root / "excluded"
        )
        self.assertFalse((self.fx.root / "excluded/private-review.md").exists())
        self.assertEqual(manifest["excluded_path_count"], 1)
        self.assertNotIn("excluded_paths", manifest)

    def test_regular_file_exclusion_refuses_main_or_missing_path(self) -> None:
        mapping, papers = self.mapping()
        row = mapping["repository"][0]
        row["exclude_path"] = [{"path": "main.tex", "reason": "fixture"}]
        with self.assertRaisesRegex(exporter.Refused, "cannot exclude main"):
            exporter.plan_repository(self.fx.commit, row, papers)
        row["exclude_path"] = [{"path": "missing.md", "reason": "fixture"}]
        with self.assertRaisesRegex(exporter.Refused, "absent or not regular"):
            exporter.plan_repository(self.fx.commit, row, papers)

    def test_glob_exclusion_is_explicit_and_refuses_stale_patterns(self) -> None:
        for name in ("analyze_one.py", "analyze_two.txt"):
            (self.fx.root / f"papers/demo/{name}").write_text("lane C684\n")
        mapping = (self.fx.root / "papers/repositories.toml").read_text()
        mapping += """\
[[repository.exclude_glob]]
pattern = "analyze_*"
reason = "private analysis workspace"
"""
        (self.fx.root / "papers/repositories.toml").write_text(mapping)
        run(self.fx.root, "git", "add", "papers/demo", "papers/repositories.toml")
        run(self.fx.root, "git", "commit", "-qm", "glob exclusion")
        commit = self.fx.output("git", "rev-parse", "HEAD").strip()
        plan = exporter.build_plan(commit)["repositories"][0]
        self.assertEqual(plan["excluded_paths"], 2)
        self.assertEqual(plan["excluded_globs"], 1)
        self.assertEqual(plan["reference_findings"], [])
        mapping, papers = self.mapping()
        row = mapping["repository"][0]
        row["exclude_glob"] = [{"pattern": "missing_*", "reason": "fixture"}]
        with self.assertRaisesRegex(exporter.Refused, "matches no paths"):
            exporter.plan_repository(self.fx.commit, row, papers)

    def test_exact_rewrite_clears_reference_and_refuses_drift(self) -> None:
        data = b"python3 papers/demo/check.py\n"
        rules = {
            "README.md": [
                {
                    "old": "papers/demo/",
                    "new": "",
                    "expected_count": 1,
                    "reason": "fixture",
                }
            ]
        }
        transformed, applied = exporter.apply_rewrites(
            "demo-paper", "README.md", data, rules
        )
        self.assertEqual(transformed, b"python3 check.py\n")
        self.assertEqual(len(applied), 1)
        rules["README.md"][0]["expected_count"] = 2
        with self.assertRaisesRegex(exporter.Refused, "rewrite drift"):
            exporter.apply_rewrites("demo-paper", "README.md", data, rules)

    def test_materialization_is_deterministic_and_refuses_overwrite(self) -> None:
        first = self.fx.root / "first"
        second = self.fx.root / "second"
        exporter.materialize_repository(self.fx.commit, "demo-paper", first)
        exporter.materialize_repository(self.fx.commit, "demo-paper", second)

        def snapshot(root: Path) -> list[tuple[str, str]]:
            return [
                (
                    str(path.relative_to(root)),
                    hashlib.sha256(path.read_bytes()).hexdigest(),
                )
                for path in sorted(root.rglob("*"))
                if path.is_file()
            ]

        self.assertEqual(snapshot(first), snapshot(second))
        self.assertTrue((first / "export-manifest.json").is_file())
        self.assertTrue((first / "PROVENANCE.md").is_file())
        with self.assertRaisesRegex(exporter.Refused, "already exists"):
            exporter.materialize_repository(self.fx.commit, "demo-paper", first)

    def test_materialization_refuses_private_reference(self) -> None:
        (self.fx.root / "papers/demo/main.tex").write_text("../../notes/private.md\n")
        run(self.fx.root, "git", "add", "papers/demo/main.tex")
        run(self.fx.root, "git", "commit", "-qm", "private reference")
        commit = self.fx.output("git", "rev-parse", "HEAD").strip()
        with self.assertRaisesRegex(exporter.Refused, "private-reference"):
            exporter.materialize_repository(commit, "demo-paper", self.fx.root / "blocked")

    def test_verify_detects_tamper_and_extra_file(self) -> None:
        candidate = self.fx.root / "candidate"
        exporter.materialize_repository(self.fx.commit, "demo-paper", candidate)
        exporter.verify_materialized_tree(candidate)
        (candidate / "main.tex").write_text("tampered\n")
        with self.assertRaisesRegex(exporter.Refused, "hash/size mismatch"):
            exporter.verify_materialized_tree(candidate)

        candidate = self.fx.root / "second-candidate"
        exporter.materialize_repository(self.fx.commit, "demo-paper", candidate)
        (candidate / "main.aux").write_text("generated\n")
        (candidate / "nested/__pycache__").mkdir(parents=True)
        (candidate / "nested/__pycache__/module.cpython-313.pyc").write_bytes(b"generated")
        exporter.verify_materialized_tree(candidate)
        (candidate / "extra.txt").write_text("extra\n")
        with self.assertRaisesRegex(exporter.Refused, "candidate tree mismatch"):
            exporter.verify_materialized_tree(candidate)


if __name__ == "__main__":
    unittest.main()
