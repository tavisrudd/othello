#!/usr/bin/env python3
"""Remove tracked files from a standalone paper mirror that the exporter no longer produces.

`export-paper-repos.py sync` refuses to delete tracked destination paths, because a
silent deletion inside a content refresh is indistinguishable from an export bug.  When
a paper is split or renamed, the mirror keeps the old files and every later sync fails.
This script makes that removal an explicit, separately reviewable forward commit in the
mirror, which is what the refusal asks for.

The deletion set is derived, never hard-coded: a fresh export is materialized from an
immutable commit of the authority, and the mirror's tracked files that the fresh export
does not contain are the candidates.  Nothing else is touched.

Run it with no flags for a dry run; add --apply to perform the removal and commit.  It
never pushes, never rewrites history, and never edits the authority.
"""

from __future__ import annotations

import argparse
import hashlib
import os
import shutil
import subprocess
import sys
import tomllib
from pathlib import Path

# A file whose job is to name a paper's formal companion, pinned release, or archived
# deposit belongs in the authority so the exporter carries it forward.  Deleting one
# downstream loses the pointer instead of updating it, so these need an explicit flag.
PIN_LIKE_NAMES = {
    "FORMAL_COMPANION.json",
    "RELEASE.json",
    "DEPOSIT.json",
}

# The exporter writes these itself; they must appear in every fresh materialization.
GENERATED_NAMES = {".gitignore", "PROVENANCE.md", "export-manifest.json"}

# A deletion set larger than this fraction of the mirror means the wrong repository,
# the wrong source ref, or a broken materialization — not a split to reconcile.  A split
# that moves most of a paper's material elsewhere is legitimately large, so this is a
# backstop against a mismatched invocation, not a review substitute: the printed list is.
MAX_DELETION_FRACTION = 0.75


class Refused(RuntimeError):
    pass


def run(cmd: list[str], cwd: Path | None = None) -> str:
    result = subprocess.run(cmd, cwd=cwd, capture_output=True, text=True)
    if result.returncode != 0:
        raise Refused(f"{' '.join(cmd)} failed: {result.stderr.strip() or result.stdout.strip()}")
    return result.stdout


def tracked_files(root: Path) -> set[str]:
    out = run(["git", "-C", str(root), "ls-files", "-z"])
    return {name for name in out.split("\0") if name}


def materialized_files(root: Path) -> set[str]:
    found: set[str] = set()
    for dirpath, dirnames, filenames in os.walk(root):
        dirnames[:] = [d for d in dirnames if d != ".git"]
        for name in filenames:
            found.add(str(Path(dirpath, name).relative_to(root)))
    return found


def registered_repository(monorepo: Path, name: str) -> dict:
    registry = monorepo / "papers" / "repositories.toml"
    if not registry.is_file():
        raise Refused(f"no repository registry at {registry}")
    doc = tomllib.loads(registry.read_text(encoding="utf-8"))
    for entry in doc.get("repository", []):
        if entry.get("name") == name:
            return entry
    known = ", ".join(sorted(e.get("name", "?") for e in doc.get("repository", [])))
    raise Refused(f"repository {name!r} is not registered; known repositories: {known}")


def assert_mirror_is_quiet(root: Path) -> None:
    if not (root / ".git").exists():
        raise Refused(f"{root} is not a Git working tree")
    status = run(["git", "-C", str(root), "status", "--porcelain"]).strip()
    if status:
        raise Refused(
            "the mirror has uncommitted changes, so a derived deletion set would not "
            "describe its committed state:\n  " + status.replace("\n", "\n  ")
        )


def assert_source_is_committed(monorepo: Path, source_ref: str, paper_dir: str) -> str:
    commit = run(["git", "-C", str(monorepo), "rev-parse", source_ref]).strip()
    dirty = run(
        ["git", "-C", str(monorepo), "status", "--porcelain", "--", paper_dir]
    ).strip()
    if dirty:
        raise Refused(
            f"the authority tree {paper_dir} has uncommitted changes; the export reads "
            "a commit, so those edits would silently not be reflected:\n  "
            + dirty.replace("\n", "\n  ")
        )
    return commit


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def classify(mirror: Path, path: str, companion_roots: list[Path]) -> str:
    """Say whether this file's bytes survive elsewhere, comparing content, not names.

    Papers share file names — `supplement/verify.py` exists in several — so a
    same-path match means nothing on its own and would read as false reassurance.
    """
    try:
        here = digest(mirror / path)
    except OSError:
        return "unreadable in this mirror"
    same_name: list[str] = []
    for root in companion_roots:
        candidate = root / path
        if not candidate.is_file():
            continue
        if digest(candidate) == here:
            return f"identical copy in {root.name}"
        same_name.append(root.name)
    if same_name:
        return "same path but different content in " + ", ".join(same_name)
    return "NO COPY in a sibling mirror"


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--root", type=Path, default=Path.cwd(),
                        help="the standalone mirror to reconcile (default: current directory)")
    parser.add_argument("--repository", help="registry name (default: the mirror directory name)")
    parser.add_argument("--monorepo", type=Path, default=None,
                        help="authority checkout (default: inferred from this script's location)")
    parser.add_argument("--source-ref", default="HEAD", help="authority commit to export from")
    parser.add_argument("--apply", action="store_true", help="perform the removal and commit it")
    parser.add_argument("--drop-pins", action="store_true",
                        help="also remove files that pin a formal companion or deposit")
    parser.add_argument("--message", default=None, help="commit message subject")
    args = parser.parse_args()

    mirror = args.root.expanduser().resolve()
    name = args.repository or mirror.name
    monorepo = (args.monorepo.expanduser().resolve() if args.monorepo
                else Path(__file__).resolve().parents[2])
    exporter = monorepo / "papers" / "scripts" / "export-paper-repos.py"
    if not exporter.is_file():
        raise Refused(f"no exporter at {exporter}; pass --monorepo")

    entry = registered_repository(monorepo, name)
    declared = entry.get("local_path")
    if declared:
        declared_path = Path(declared).expanduser().resolve()
        if declared_path != mirror:
            raise Refused(
                f"registry maps {name!r} to {declared_path}, but --root is {mirror}"
            )
    paper_dir = entry["source"]

    assert_mirror_is_quiet(mirror)
    commit = assert_source_is_committed(monorepo, args.source_ref, paper_dir)

    workdir = Path.home() / ".cache" / "othello-paper-export" / f"reconcile-{name}-{os.getpid()}"
    if workdir.exists():
        shutil.rmtree(workdir)
    workdir.parent.mkdir(parents=True, exist_ok=True)
    try:
        run([sys.executable, str(exporter), "materialize", "--source-ref", commit,
             "--repository", name, "--out", str(workdir)], cwd=monorepo)
        fresh = materialized_files(workdir)
    finally:
        keep = workdir if os.environ.get("KEEP_CANDIDATE") else None
        if keep is None and workdir.exists():
            shutil.rmtree(workdir)

    if len(fresh) < 5:
        raise Refused(f"the fresh export has only {len(fresh)} files; refusing to diff against it")
    for generated in GENERATED_NAMES:
        if generated not in fresh:
            raise Refused(
                f"the fresh export lacks {generated}, so it is not a complete materialization"
            )

    tracked = tracked_files(mirror)
    deletions = sorted(tracked - fresh)
    additions = sorted(fresh - tracked)

    if not deletions:
        print(f"{name}: nothing to reconcile; {len(tracked)} tracked files all appear in the export")
        return 0
    for path in deletions:
        if path.startswith("/") or ".." in Path(path).parts:
            raise Refused(f"refusing to act on suspicious path {path!r}")
        if Path(path).name in GENERATED_NAMES:
            raise Refused(f"refusing to delete generated file {path!r}")
    if len(deletions) > MAX_DELETION_FRACTION * len(tracked):
        raise Refused(
            f"{len(deletions)} of {len(tracked)} tracked files would be removed; that is "
            "not a split to reconcile. Check --repository and --source-ref."
        )

    pins = [p for p in deletions if Path(p).name in PIN_LIKE_NAMES]
    if pins and not args.drop_pins:
        deletions = [p for p in deletions if p not in pins]

    companions = sorted(
        p for p in mirror.parent.iterdir() if p.is_dir() and p != mirror and (p / ".git").exists()
    )

    print(f"repository:   {name}")
    print(f"mirror:       {mirror}")
    print(f"authority:    {monorepo} at {commit[:12]} ({args.source_ref})")
    print(f"tracked:      {len(tracked)} files")
    print(f"fresh export: {len(fresh)} files")
    print()
    print(f"{len(deletions)} tracked path(s) the export no longer produces:")
    for path in deletions:
        print(f"  - {path}    [{classify(mirror, path, companions)}]")
    if pins:
        print()
        state = "included by --drop-pins" if args.drop_pins else "HELD BACK"
        print(f"{len(pins)} path(s) pin a formal companion or deposit — {state}:")
        for path in pins:
            print(f"  ! {path}    [{classify(mirror, path, companions)}]")
        if not args.drop_pins:
            print("  A pin belongs in the authority so the exporter carries it forward.")
            print("  Add a refreshed copy under the authority's paper directory, or rerun")
            print("  with --drop-pins to remove it from the mirror.")
    if additions:
        print()
        print(f"{len(additions)} path(s) the next sync will add (not this script's job):")
        for path in additions:
            print(f"  + {path}")

    if not args.apply:
        print()
        print("dry run; nothing was changed. Rerun with --apply to remove and commit.")
        return 0
    if not deletions:
        print()
        print("nothing to remove without --drop-pins.")
        return 0

    run(["git", "-C", str(mirror), "rm", "-q", "--"] + deletions)
    subject = args.message or "Remove files that moved out of this paper"
    body = (
        "These paths are no longer produced by the authority's export. They are removed "
        "here as an explicit forward commit so the deletion is reviewable on its own, "
        "rather than folded into a content refresh."
    )
    run(["git", "-C", str(mirror), "-c", "commit.gpgsign=false", "commit", "-q",
         "-m", subject, "-m", body])
    head = run(["git", "-C", str(mirror), "log", "--oneline", "-1"]).strip()

    remaining = sorted(tracked_files(mirror) - fresh)
    unresolved = [p for p in remaining if p not in pins]
    if unresolved:
        raise Refused(f"paths still absent from the export after the commit: {unresolved}")

    print()
    print(f"committed: {head}")
    print("nothing was pushed. Next:")
    print(f"  cd {monorepo}")
    print(f"  python3 papers/scripts/export-paper-repos.py sync --source-ref {args.source_ref} \\")
    print(f"    --repository {name} --root {mirror}")
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except Refused as refusal:
        print(f"REFUSED: {refusal}", file=sys.stderr)
        sys.exit(2)
