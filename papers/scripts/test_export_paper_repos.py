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
        (candidate / "extra.txt").write_text("extra\n")
        with self.assertRaisesRegex(exporter.Refused, "candidate tree mismatch"):
            exporter.verify_materialized_tree(candidate)


if __name__ == "__main__":
    unittest.main()
