#!/usr/bin/env python3
"""Plan deterministic standalone paper-repository exports.

The initial C684 surface is deliberately read-only. `plan` reads both registries and every source
blob from an immutable Git tree, validates repository boundaries, and reports export size, symlink
dispositions, and monorepo-coupled text references. It never reads manuscript bytes from the live
working tree and never writes under ~/src/math-papers.
"""

from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
import tomllib
import unicodedata
from dataclasses import dataclass
from pathlib import Path, PurePosixPath
from typing import Any

REPO_ROOT = Path(__file__).resolve().parents[2]
PAPER_REGISTRY = "lean/trust/papers.toml"
REPOSITORY_MAP = "papers/repositories.toml"
NAME_RE = re.compile(r"^[a-z0-9]+(?:-[a-z0-9]+)*$")
TEXT_SUFFIXES = {
    ".bib",
    ".json",
    ".md",
    ".py",
    ".sh",
    ".tex",
    ".toml",
    ".txt",
    ".yaml",
    ".yml",
}
TEXT_NAMES = {"Makefile", "README"}
REFERENCE_PATTERNS = (
    ("private-notes", re.compile(r"(?:^|[(`/\"'])\.\./(?:\.\./)*notes/")),
    ("paper-index", re.compile(r"\.\./papers-(?:index|planning)\.md")),
    ("local-home", re.compile(r"/home/tavis(?:/|$)")),
    ("file-uri", re.compile(r"file://")),
    ("private-handoff", re.compile(r"notes/handoffs/")),
)


class Refused(RuntimeError):
    """The declared export boundary is unsafe or inconsistent."""


@dataclass(frozen=True)
class TreeEntry:
    mode: str
    kind: str
    oid: str
    size: int | None
    path: str


def git(*args: str, input_bytes: bytes | None = None) -> bytes:
    proc = subprocess.run(
        ["git", *args],
        cwd=REPO_ROOT,
        input=input_bytes,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        check=False,
    )
    if proc.returncode:
        detail = proc.stderr.decode("utf-8", "replace").strip()
        raise Refused(f"git {' '.join(args)} failed: {detail}")
    return proc.stdout


def git_text(ref: str, path: str) -> str:
    return git("show", f"{ref}:{path}").decode("utf-8")


def git_blob(oid: str) -> bytes:
    return git("cat-file", "blob", oid)


def load_toml(ref: str, path: str) -> dict[str, Any]:
    try:
        return tomllib.loads(git_text(ref, path))
    except (UnicodeDecodeError, tomllib.TOMLDecodeError) as error:
        raise Refused(f"{path} at {ref} is not valid UTF-8 TOML: {error}") from error


def resolve_commit(ref: str) -> str:
    return git("rev-parse", "--verify", f"{ref}^{{commit}}").decode().strip()


def tree_entries(commit: str, source: str) -> list[TreeEntry]:
    raw = git("ls-tree", "-rz", "-l", "--full-tree", commit, "--", source)
    entries: list[TreeEntry] = []
    for record in raw.split(b"\0"):
        if not record:
            continue
        meta, raw_path = record.split(b"\t", 1)
        mode, kind, oid, raw_size = meta.decode("ascii").split()
        path = raw_path.decode("utf-8")
        size = None if raw_size == "-" else int(raw_size)
        entries.append(TreeEntry(mode, kind, oid, size, path))
    return entries


def normalized_identity(value: str) -> str:
    return unicodedata.normalize("NFC", value).casefold()


def safe_relative(value: str, where: str) -> PurePosixPath:
    path = PurePosixPath(value)
    if path.is_absolute() or not path.parts or any(part in ("", ".", "..") for part in path.parts):
        raise Refused(f"{where} must be a nonempty normalized relative path: {value!r}")
    return path


def relative_to_source(entry: TreeEntry, source: str) -> str:
    prefix = source.rstrip("/") + "/"
    if not entry.path.startswith(prefix):
        raise Refused(f"Git returned {entry.path!r} outside declared source {source!r}")
    return entry.path[len(prefix) :]


def registry_index(registry: dict[str, Any]) -> dict[str, dict[str, Any]]:
    if registry.get("schema_version") != 1:
        raise Refused(f"{PAPER_REGISTRY} has unsupported schema_version")
    result: dict[str, dict[str, Any]] = {}
    for row in registry.get("paper", []):
        paper_id = row.get("id")
        if not isinstance(paper_id, str) or paper_id in result:
            raise Refused(f"{PAPER_REGISTRY} has missing or duplicate paper id {paper_id!r}")
        result[paper_id] = row
    return result


def validate_map(mapping: dict[str, Any], papers: dict[str, dict[str, Any]]) -> list[dict[str, Any]]:
    if mapping.get("schema_version") != 1:
        raise Refused(f"{REPOSITORY_MAP} has unsupported schema_version")
    destinations = mapping.get("destinations", {})
    if destinations.get("local_root") != "~/src/math-papers":
        raise Refused("destination local_root must be exactly '~/src/math-papers'")
    if destinations.get("github_owner") != "tavisrudd":
        raise Refused("destination github_owner must be exactly 'tavisrudd'")

    repositories = mapping.get("repository", [])
    names: dict[str, str] = {}
    sources: dict[str, str] = {}
    claimed_ids: dict[str, str] = {}
    for row in repositories:
        name = row.get("name")
        source = row.get("source")
        if not isinstance(name, str) or not NAME_RE.fullmatch(name):
            raise Refused(f"invalid repository name {name!r}")
        identity = normalized_identity(name)
        if identity in names:
            raise Refused(f"repository names collide: {names[identity]!r} and {name!r}")
        names[identity] = name
        safe_relative(source, f"repository {name} source")
        if not source.startswith("papers/") or source.count("/") != 1:
            raise Refused(f"repository {name} source must be one immediate papers/ child")
        if source in sources:
            raise Refused(f"source {source!r} is mapped by both {sources[source]!r} and {name!r}")
        sources[source] = name
        disposition = row.get("disposition")
        if disposition not in {"active", "archive", "gated"}:
            raise Refused(f"repository {name} has invalid disposition {disposition!r}")
        ids = row.get("paper_ids")
        if not isinstance(ids, list) or not ids:
            raise Refused(f"repository {name} must declare at least one paper_ids entry")
        for paper_id in ids:
            if paper_id not in papers:
                raise Refused(f"repository {name} names unknown paper id {paper_id!r}")
            if paper_id in claimed_ids:
                raise Refused(
                    f"paper id {paper_id!r} is claimed by {claimed_ids[paper_id]!r} and {name!r}"
                )
            if papers[paper_id]["dir"] != source:
                raise Refused(
                    f"repository {name} source {source!r} disagrees with {paper_id!r} registry dir "
                    f"{papers[paper_id]['dir']!r}"
                )
            claimed_ids[paper_id] = name

    missing = sorted(set(papers) - set(claimed_ids))
    if missing:
        raise Refused(f"registered paper ids have no repository mapping: {', '.join(missing)}")
    return repositories


def excluded_symlinks(row: dict[str, Any]) -> dict[str, str]:
    result: dict[str, str] = {}
    for rule in row.get("exclude_symlink", []):
        path = rule.get("path")
        reason = rule.get("reason")
        safe_relative(path, f"repository {row['name']} excluded symlink")
        if path in result:
            raise Refused(f"repository {row['name']} repeats symlink disposition for {path!r}")
        if not isinstance(reason, str) or not reason.strip():
            raise Refused(f"repository {row['name']} symlink {path!r} needs a reason")
        result[path] = reason
    return result


def is_scannable(path: str, size: int) -> bool:
    pure = PurePosixPath(path)
    return size <= 2_000_000 and (pure.suffix.lower() in TEXT_SUFFIXES or pure.name in TEXT_NAMES)


def scan_references(entries: list[TreeEntry], source: str, excluded: set[str]) -> list[dict[str, Any]]:
    findings: list[dict[str, Any]] = []
    for entry in entries:
        rel = relative_to_source(entry, source)
        if rel in excluded or entry.mode == "120000" or entry.kind != "blob":
            continue
        size = entry.size or 0
        if not is_scannable(rel, size):
            continue
        try:
            text = git_blob(entry.oid).decode("utf-8")
        except UnicodeDecodeError:
            continue
        for line_number, line in enumerate(text.splitlines(), 1):
            for code, pattern in REFERENCE_PATTERNS:
                if pattern.search(line):
                    findings.append({"code": code, "path": rel, "line": line_number})
    return findings


def plan_repository(
    commit: str, row: dict[str, Any], papers: dict[str, dict[str, Any]]
) -> dict[str, Any]:
    source = row["source"]
    entries = tree_entries(commit, source)
    if not entries:
        raise Refused(f"repository {row['name']} source tree is empty at {commit}")
    by_relative = {relative_to_source(entry, source): entry for entry in entries}
    main_sources = [papers[paper_id]["main"] for paper_id in row["paper_ids"]]
    for main in main_sources:
        entry = by_relative.get(main)
        if entry is None or entry.kind != "blob" or entry.mode == "120000":
            raise Refused(f"repository {row['name']} main source {main!r} is absent or not regular")

    exclusions = excluded_symlinks(row)
    symlinks = {path: entry for path, entry in by_relative.items() if entry.mode == "120000"}
    undeclared = sorted(set(symlinks) - set(exclusions))
    stale = sorted(set(exclusions) - set(symlinks))
    if undeclared:
        raise Refused(
            f"repository {row['name']} has symlinks with no disposition: {', '.join(undeclared)}"
        )
    if stale:
        raise Refused(
            f"repository {row['name']} declares exclusions that are not symlinks: {', '.join(stale)}"
        )

    regular = [
        entry
        for path, entry in by_relative.items()
        if entry.kind == "blob" and entry.mode != "120000" and path not in exclusions
    ]
    references = scan_references(entries, source, set(exclusions))
    return {
        "name": row["name"],
        "source": source,
        "disposition": row["disposition"],
        "paper_ids": row["paper_ids"],
        "main_sources": main_sources,
        "files": len(regular),
        "bytes": sum(entry.size or 0 for entry in regular),
        "excluded_symlinks": len(exclusions),
        "reference_findings": references,
        "local_path": f"~/src/math-papers/{row['name']}",
        "github": f"tavisrudd/{row['name']}",
    }


def command_plan(args: argparse.Namespace) -> int:
    commit = resolve_commit(args.source_ref)
    papers = registry_index(load_toml(commit, PAPER_REGISTRY))
    repositories = validate_map(load_toml(commit, REPOSITORY_MAP), papers)
    plans = [plan_repository(commit, row, papers) for row in repositories]
    document = {"schema_version": 1, "source_commit": commit, "repositories": plans}
    if args.json:
        print(json.dumps(document, indent=2, sort_keys=True))
    else:
        print(f"source_commit={commit}")
        for item in plans:
            print(
                f"{item['name']}: {item['disposition']} mains={len(item['main_sources'])} "
                f"files={item['files']} bytes={item['bytes']} "
                f"excluded_symlinks={item['excluded_symlinks']} "
                f"reference_findings={len(item['reference_findings'])}"
            )
    return 0


def parser() -> argparse.ArgumentParser:
    result = argparse.ArgumentParser(description=__doc__)
    subparsers = result.add_subparsers(dest="command", required=True)
    plan = subparsers.add_parser("plan", help="read-only inventory from an immutable Git tree")
    plan.add_argument("--source-ref", default="HEAD")
    plan.add_argument("--json", action="store_true")
    plan.set_defaults(function=command_plan)
    return result


def main() -> int:
    args = parser().parse_args()
    try:
        return args.function(args)
    except Refused as error:
        print(f"REFUSED: {error}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
