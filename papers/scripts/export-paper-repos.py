#!/usr/bin/env python3
"""Plan deterministic standalone paper-repository exports.

The initial C684 surface is deliberately read-only. `plan` reads both registries and every source
blob from an immutable Git tree, validates repository boundaries, and reports export size, symlink
dispositions, and monorepo-coupled text references. It never reads manuscript bytes from the live
working tree and never writes under ~/src/math-papers.
"""

from __future__ import annotations

import argparse
import hashlib
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
    ("paper-root", re.compile(r"(?<![A-Za-z0-9_./-])papers/[A-Za-z0-9_.-]+/")),
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
    if not isinstance(value, str):
        raise Refused(f"{where} must be a string, got {value!r}")
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


def excluded_release_outputs(
    row: dict[str, Any], papers: dict[str, dict[str, Any]]
) -> set[str]:
    include = row.get("include_release_pdfs", False)
    if not isinstance(include, bool):
        raise Refused(f"repository {row['name']} include_release_pdfs must be boolean")
    if include:
        return set()
    return {str(PurePosixPath(papers[paper_id]["main"]).with_suffix(".pdf")) for paper_id in row["paper_ids"]}


def rewrite_rules(row: dict[str, Any]) -> dict[str, list[dict[str, Any]]]:
    result: dict[str, list[dict[str, Any]]] = {}
    for rule in row.get("rewrite", []):
        path = rule.get("path")
        old = rule.get("old")
        new = rule.get("new")
        count = rule.get("expected_count")
        reason = rule.get("reason")
        safe_relative(path, f"repository {row['name']} rewrite path")
        if not isinstance(old, str) or not old or not isinstance(new, str):
            raise Refused(f"repository {row['name']} rewrite {path!r} needs nonempty old/string new")
        if not isinstance(count, int) or count < 1:
            raise Refused(f"repository {row['name']} rewrite {path!r} needs positive expected_count")
        if not isinstance(reason, str) or not reason.strip():
            raise Refused(f"repository {row['name']} rewrite {path!r} needs a reason")
        result.setdefault(path, []).append(rule)
    return result


def apply_rewrites(
    repository: str, path: str, data: bytes, rules: dict[str, list[dict[str, Any]]]
) -> tuple[bytes, list[dict[str, Any]]]:
    applied: list[dict[str, Any]] = []
    if path not in rules:
        return data, applied
    try:
        text = data.decode("utf-8")
    except UnicodeDecodeError as error:
        raise Refused(f"repository {repository} cannot rewrite non-UTF-8 file {path!r}") from error
    for rule in rules[path]:
        observed = text.count(rule["old"])
        if observed != rule["expected_count"]:
            raise Refused(
                f"repository {repository} rewrite drift in {path!r}: expected "
                f"{rule['expected_count']} occurrence(s), observed {observed}"
            )
        text = text.replace(rule["old"], rule["new"])
        applied.append(
            {
                "expected_count": rule["expected_count"],
                "new": rule["new"],
                "old": rule["old"],
                "reason": rule["reason"],
            }
        )
    return text.encode(), applied


def is_scannable(path: str, size: int) -> bool:
    pure = PurePosixPath(path)
    return size <= 2_000_000 and (pure.suffix.lower() in TEXT_SUFFIXES or pure.name in TEXT_NAMES)


def scan_references(
    entries: list[TreeEntry],
    source: str,
    excluded: set[str],
    repository: str,
    rewrites: dict[str, list[dict[str, Any]]],
) -> list[dict[str, Any]]:
    findings: list[dict[str, Any]] = []
    for entry in entries:
        rel = relative_to_source(entry, source)
        if rel in excluded or entry.mode == "120000" or entry.kind != "blob":
            continue
        size = entry.size or 0
        if not is_scannable(rel, size):
            continue
        try:
            data, _ = apply_rewrites(repository, rel, git_blob(entry.oid), rewrites)
            text = data.decode("utf-8")
        except UnicodeDecodeError:
            continue
        for line_number, line in enumerate(text.splitlines(), 1):
            for code, pattern in REFERENCE_PATTERNS:
                if pattern.search(line):
                    findings.append({"code": code, "path": rel, "line": line_number})
    return findings


def content_role(path: str) -> str:
    pure = PurePosixPath(path)
    if pure.suffix.lower() == ".pdf":
        return "release-output"
    if pure.suffix.lower() in {".tex", ".bib", ".sty", ".cls"}:
        return "manuscript-source"
    if pure.suffix.lower() in {".png", ".jpg", ".jpeg", ".pdf", ".svg", ".eps"}:
        return "figure"
    if "verification" in pure.parts or pure.suffix.lower() in {".py", ".sh", ".json", ".sha256"}:
        return "verification"
    return "support"


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


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
    release_outputs = excluded_release_outputs(row, papers)
    rewrites = rewrite_rules(row)
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
        if entry.kind == "blob"
        and entry.mode != "120000"
        and path not in exclusions
        and path not in release_outputs
    ]
    stale_rewrites = sorted(set(rewrites) - set(by_relative))
    if stale_rewrites:
        raise Refused(f"repository {row['name']} rewrites absent paths: {', '.join(stale_rewrites)}")
    references = scan_references(entries, source, set(exclusions), row["name"], rewrites)
    return {
        "name": row["name"],
        "source": source,
        "disposition": row["disposition"],
        "paper_ids": row["paper_ids"],
        "main_sources": main_sources,
        "files": len(regular),
        "bytes": sum(entry.size or 0 for entry in regular),
        "excluded_symlinks": len(exclusions),
        "excluded_release_outputs": sorted(release_outputs & set(by_relative)),
        "reference_findings": references,
        "local_path": f"~/src/math-papers/{row['name']}",
        "github": f"tavisrudd/{row['name']}",
    }


def selected_repository(
    commit: str, repository: str
) -> tuple[dict[str, Any], dict[str, dict[str, Any]]]:
    papers = registry_index(load_toml(commit, PAPER_REGISTRY))
    repositories = validate_map(load_toml(commit, REPOSITORY_MAP), papers)
    matches = [row for row in repositories if row["name"] == repository]
    if not matches:
        raise Refused(f"no mapped repository named {repository!r}")
    return matches[0], papers


def build_plan(source_ref: str, repository: str | None = None) -> dict[str, Any]:
    commit = resolve_commit(source_ref)
    papers = registry_index(load_toml(commit, PAPER_REGISTRY))
    repositories = validate_map(load_toml(commit, REPOSITORY_MAP), papers)
    if repository is not None:
        repositories = [row for row in repositories if row["name"] == repository]
        if not repositories:
            raise Refused(f"no mapped repository named {repository!r}")
    plans = [plan_repository(commit, row, papers) for row in repositories]
    return {"schema_version": 1, "source_commit": commit, "repositories": plans}


def materialize_repository(source_ref: str, repository: str, out: Path) -> dict[str, Any]:
    commit = resolve_commit(source_ref)
    row, papers = selected_repository(commit, repository)
    if row["disposition"] != "active":
        raise Refused(
            f"repository {repository!r} is {row['disposition']!r}, not active; materialization refused"
        )
    plan = plan_repository(commit, row, papers)
    if plan["reference_findings"]:
        raise Refused(
            f"repository {repository!r} has {len(plan['reference_findings'])} unresolved "
            "private-reference finding(s)"
        )
    out = out.expanduser()
    if out.exists():
        raise Refused(f"destination already exists: {out}")
    if not out.parent.is_dir():
        raise Refused(f"destination parent does not exist: {out.parent}")

    source = row["source"]
    exclusions = excluded_symlinks(row)
    release_outputs = excluded_release_outputs(row, papers)
    rewrites = rewrite_rules(row)
    entries = tree_entries(commit, source)
    payloads: list[tuple[str, bytes, str, str]] = []
    manifest_files: list[dict[str, Any]] = []
    for entry in entries:
        rel = relative_to_source(entry, source)
        if rel in exclusions or rel in release_outputs:
            continue
        if entry.kind != "blob" or entry.mode == "120000":
            raise Refused(f"repository {repository!r} contains unsupported tree entry {rel!r}")
        data, applied_rewrites = apply_rewrites(repository, rel, git_blob(entry.oid), rewrites)
        payloads.append((rel, data, entry.mode, entry.oid))
        manifest_files.append(
            {
                "bytes": len(data),
                "mode": entry.mode,
                "path": rel,
                "role": content_role(rel),
                "sha256": sha256(data),
                "source_blob": entry.oid,
                "source_path": entry.path,
                "rewrites": applied_rewrites,
            }
        )

    reserved = {"PROVENANCE.md", "export-manifest.json"}
    collisions = sorted(reserved & {path for path, _, _, _ in payloads})
    if collisions:
        raise Refused(f"repository {repository!r} source collides with generated files: {collisions}")
    provenance = (
        "# Export provenance\n\n"
        f"- Source repository commit: `{commit}`\n"
        f"- Source root: `{source}`\n"
        f"- Repository identity: `tavisrudd/{repository}`\n"
        "- Exporter: `papers/scripts/export-paper-repos.py materialize`\n"
        "- This repository is a deterministic release mirror; the private research monorepo "
        "remains the development source.\n"
    ).encode()
    payloads.append(("PROVENANCE.md", provenance, "100644", "generated"))
    manifest_files.append(
        {
            "bytes": len(provenance),
            "mode": "100644",
            "path": "PROVENANCE.md",
            "role": "provenance",
            "sha256": sha256(provenance),
            "source_blob": None,
            "source_path": None,
        }
    )
    if ".gitignore" not in {path for path, _, _, _ in payloads}:
        ignore = (
            "__pycache__/\n*.py[cod]\n*.aux\n*.bbl\n*.bcf\n*.blg\n*.fdb_latexmk\n"
            "*.fls\n*.log\n*.out\n*.run.xml\n*.synctex.gz\n*.xdv\n"
            + "".join(f"/{path}\n" for path in sorted(release_outputs))
        ).encode()
        payloads.append((".gitignore", ignore, "100644", "generated"))
        manifest_files.append(
            {
                "bytes": len(ignore),
                "mode": "100644",
                "path": ".gitignore",
                "role": "export-support",
                "sha256": sha256(ignore),
                "source_blob": None,
                "source_path": None,
            }
        )

    manifest = {
        "schema_version": 1,
        "exporter_blob": git(
            "rev-parse", f"{commit}:papers/scripts/export-paper-repos.py"
        ).decode().strip(),
        "github": f"tavisrudd/{repository}",
        "main_sources": plan["main_sources"],
        "manifest_self_excluded": True,
        "paper_ids": row["paper_ids"],
        "paper_registry_sha256": sha256(git("show", f"{commit}:{PAPER_REGISTRY}")),
        "repository": repository,
        "repository_map_sha256": sha256(git("show", f"{commit}:{REPOSITORY_MAP}")),
        "source_commit": commit,
        "source_root": source,
        "excluded_symlinks": [
            {"path": path, "reason": reason} for path, reason in sorted(exclusions.items())
        ],
        "excluded_release_outputs": sorted(release_outputs),
        "files": sorted(manifest_files, key=lambda item: item["path"]),
    }
    manifest_bytes = (json.dumps(manifest, indent=2, sort_keys=True) + "\n").encode()
    payloads.append(("export-manifest.json", manifest_bytes, "100644", "generated"))

    out.mkdir()
    for rel, data, mode, _ in sorted(payloads):
        destination = out / rel
        destination.parent.mkdir(parents=True, exist_ok=True)
        destination.write_bytes(data)
        destination.chmod(0o755 if mode == "100755" else 0o644)
    return manifest


def command_plan(args: argparse.Namespace) -> int:
    document = build_plan(args.source_ref, args.repository)
    if args.json:
        print(json.dumps(document, indent=2, sort_keys=True))
    else:
        print(f"source_commit={document['source_commit']}")
        for item in document["repositories"]:
            print(
                f"{item['name']}: {item['disposition']} mains={len(item['main_sources'])} "
                f"files={item['files']} bytes={item['bytes']} "
                f"excluded_symlinks={item['excluded_symlinks']} "
                f"reference_findings={len(item['reference_findings'])}"
            )
    return 0


def command_audit(args: argparse.Namespace) -> int:
    document = build_plan(args.source_ref, args.repository)
    findings = [
        {"repository": item["name"], **finding}
        for item in document["repositories"]
        for finding in item["reference_findings"]
    ]
    if args.json:
        print(
            json.dumps(
                {
                    "schema_version": 1,
                    "source_commit": document["source_commit"],
                    "findings": findings,
                },
                indent=2,
                sort_keys=True,
            )
        )
    else:
        for finding in findings:
            print(
                f"{finding['repository']}: {finding['code']} "
                f"{finding['path']}:{finding['line']}"
            )
        print(f"findings={len(findings)}")
    return 1 if findings else 0


def command_materialize(args: argparse.Namespace) -> int:
    manifest = materialize_repository(args.source_ref, args.repository, args.out)
    print(
        f"materialized={args.out.expanduser()} repository={manifest['repository']} "
        f"source_commit={manifest['source_commit']} files={len(manifest['files']) + 1}"
    )
    return 0


def verify_materialized_tree(root: Path) -> dict[str, Any]:
    root = root.expanduser().resolve()
    manifest_path = root / "export-manifest.json"
    if not manifest_path.is_file():
        raise Refused(f"missing export manifest: {manifest_path}")
    try:
        manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    except (UnicodeDecodeError, json.JSONDecodeError) as error:
        raise Refused(f"invalid export manifest {manifest_path}: {error}") from error
    if manifest.get("schema_version") != 1 or manifest.get("manifest_self_excluded") is not True:
        raise Refused("unsupported or malformed export manifest")

    expected = {"export-manifest.json"}
    for item in manifest.get("files", []):
        rel = item.get("path")
        safe_relative(rel, "manifest file path")
        if rel in expected:
            raise Refused(f"duplicate manifest path {rel!r}")
        expected.add(rel)
        path = root / rel
        if not path.is_file() or path.is_symlink():
            raise Refused(f"manifest file is missing, non-regular, or a symlink: {rel}")
        data = path.read_bytes()
        if len(data) != item.get("bytes") or sha256(data) != item.get("sha256"):
            raise Refused(f"manifest hash/size mismatch: {rel}")
        expected_mode = 0o755 if item.get("mode") == "100755" else 0o644
        if path.stat().st_mode & 0o777 != expected_mode:
            raise Refused(f"manifest mode mismatch: {rel}")

    if (root / ".git").exists():
        proc = subprocess.run(
            ["git", "ls-files", "-z"],
            cwd=root,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            check=False,
        )
        if proc.returncode:
            raise Refused(f"cannot list tracked candidate files: {proc.stderr.decode().strip()}")
        observed = {path.decode("utf-8") for path in proc.stdout.split(b"\0") if path}
    else:
        observed = {
            str(path.relative_to(root))
            for path in root.rglob("*")
            if path.is_file() and ".git" not in path.relative_to(root).parts
        }
    missing = sorted(expected - observed)
    extra = sorted(observed - expected)
    if missing or extra:
        raise Refused(f"candidate tree mismatch: missing={missing}, extra={extra}")
    return manifest


def command_verify(args: argparse.Namespace) -> int:
    manifest = verify_materialized_tree(args.root)
    print(
        f"verified={args.root.expanduser()} repository={manifest['repository']} "
        f"source_commit={manifest['source_commit']} tracked_files={len(manifest['files']) + 1}"
    )
    return 0


def add_common_arguments(command: argparse.ArgumentParser) -> None:
    command.add_argument("--source-ref", default="HEAD")
    command.add_argument("--repository")
    command.add_argument("--json", action="store_true")


def parser() -> argparse.ArgumentParser:
    result = argparse.ArgumentParser(description=__doc__)
    subparsers = result.add_subparsers(dest="command", required=True)
    plan = subparsers.add_parser("plan", help="read-only inventory from an immutable Git tree")
    add_common_arguments(plan)
    plan.set_defaults(function=command_plan)
    audit = subparsers.add_parser(
        "audit", help="fail when selected immutable source blobs contain private-repository coupling"
    )
    add_common_arguments(audit)
    audit.set_defaults(function=command_audit)
    materialize = subparsers.add_parser(
        "materialize", help="write one clean active candidate to a new empty path"
    )
    materialize.add_argument("--source-ref", default="HEAD")
    materialize.add_argument("--repository", required=True)
    materialize.add_argument("--out", required=True, type=Path)
    materialize.set_defaults(function=command_materialize)
    verify = subparsers.add_parser(
        "verify", help="verify one candidate's tracked tree against its canonical export manifest"
    )
    verify.add_argument("--root", required=True, type=Path)
    verify.set_defaults(function=command_verify)
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
