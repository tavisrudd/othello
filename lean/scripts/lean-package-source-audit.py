#!/usr/bin/env python3
"""Compare an external certificate package's sealed Lean sources against the
authoritative monorepo revision they were extracted from, against the current
monorepo tree, and against the pinned base library.

An external certificate package owns generated leaves that the monorepo has
deleted or is about to delete.  Nothing rebuilds the deleted sources, so a
divergence between the package's copy and the monorepo authority is invisible to
every gate on both sides.  This audit makes that divergence explicit before any
further deletion, and classifies each sealed source as:

  identical-to-authority        the package copy matches the named authority revision
  DIFFERS-from-authority        the package copy is not the authority's bytes
  absent-from-authority         the authority revision has no such file
  still-in-monorepo-identical   the monorepo still carries a byte-identical copy
  still-in-monorepo-DRIFTED     the monorepo copy has since changed
  BASE-OVERLAP-*                the pinned base library also supplies this module

A module supplied by both the package and the pinned base is a duplicate module
name in one import closure and is always a defect.  A module the monorepo still
carries is a duplicate source: admissible only while its extraction is pending,
and only while the two copies agree.

The audit reads committed Git objects and the package worktree.  It runs no Lean
and takes no build lock.
"""

from __future__ import annotations

import argparse
import collections
import hashlib
import json
import subprocess
import sys
from pathlib import Path


def blob_digest(repo: Path, rev: str, path: str) -> str | None:
    """SHA-256 of a committed blob, or None when the revision has no such path."""
    proc = subprocess.run(
        ["git", "-C", str(repo), "cat-file", "-p", f"{rev}:{path}"],
        capture_output=True,
    )
    if proc.returncode != 0:
        return None
    return hashlib.sha256(proc.stdout).hexdigest()


def resolve(repo: Path, rev: str) -> str | None:
    proc = subprocess.run(
        ["git", "-C", str(repo), "rev-parse", "--verify", f"{rev}^{{commit}}"],
        capture_output=True,
        text=True,
    )
    return proc.stdout.strip() if proc.returncode == 0 else None


def audit(package: Path, monorepo: Path, base: Path, authority: str,
          source_prefix: str) -> tuple[dict[str, list[str]], dict[str, str]]:
    manifest = json.loads((package / "MANIFEST.json").read_text())
    base_commit = manifest["dependency"]["commit"]

    detail: dict[str, list[str]] = collections.defaultdict(list)
    for entry in manifest["sources"]:
        path = entry["path"]
        sealed = entry["sha256"]
        on_disk = hashlib.sha256((package / path).read_bytes()).hexdigest()
        in_authority = blob_digest(monorepo, authority, f"{source_prefix}{path}")
        in_head = blob_digest(monorepo, "HEAD", f"{source_prefix}{path}")
        in_base = blob_digest(base, base_commit, path)

        tags = ["manifest-ok" if on_disk == sealed else "WORKTREE-DRIFT"]
        if in_authority is None:
            tags.append("absent-from-authority")
        elif in_authority == sealed:
            tags.append("identical-to-authority")
        else:
            tags.append("DIFFERS-from-authority")
        if in_head is not None:
            tags.append(
                "still-in-monorepo-identical" if in_head == sealed
                else "still-in-monorepo-DRIFTED"
            )
        if in_base is not None:
            tags.append(
                "BASE-OVERLAP-identical" if in_base == sealed
                else "BASE-OVERLAP-drifted"
            )
        detail[" | ".join(tags)].append(path)

    header = {
        "module_count": str(manifest["module_count"]),
        "sealed_package_revision": manifest["source_commit"],
        "pinned_base_commit": base_commit,
    }
    return detail, header


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("package", type=Path, help="external certificate package root")
    parser.add_argument(
        "--authority",
        required=True,
        help="monorepo revision holding the authoritative pre-extraction sources",
    )
    parser.add_argument("--monorepo", type=Path, default=Path.home() / "src/othello")
    parser.add_argument("--base", type=Path, default=Path.home() / "src/lean/finitegeom")
    parser.add_argument(
        "--source-prefix",
        default="lean/",
        help="path prefix mapping a package module path into the monorepo tree",
    )
    parser.add_argument(
        "--list",
        action="append",
        default=[],
        metavar="SUBSTRING",
        help="also list the paths of every class whose label contains SUBSTRING",
    )
    args = parser.parse_args()

    if not (args.package / "MANIFEST.json").is_file():
        print(f"no MANIFEST.json under {args.package}", file=sys.stderr)
        return 2
    resolved = resolve(args.monorepo, args.authority)
    if resolved is None:
        print(
            f"authority revision {args.authority} does not resolve in {args.monorepo}."
            "  A package's own MANIFEST.json source_commit names the package"
            " revision, not the monorepo revision the sources came from.",
            file=sys.stderr,
        )
        return 2

    detail, header = audit(
        args.package, args.monorepo, args.base, resolved, args.source_prefix
    )

    print(f"package {args.package.name}: {header['module_count']} sealed sources")
    print(f"  sealed package revision {header['sealed_package_revision'][:8]}")
    print(f"  monorepo authority      {resolved[:8]} ({args.authority})")
    print(f"  pinned base commit      {header['pinned_base_commit'][:8]}")
    for label, paths in sorted(detail.items(), key=lambda kv: -len(kv[1])):
        print(f"{len(paths):5d}  {label}")
    for pattern in args.list:
        for label, paths in sorted(detail.items()):
            if pattern in label:
                print(f"\n== {label}")
                for path in paths:
                    print(f"  {path}")

    defective = any(
        "WORKTREE-DRIFT" in label or "BASE-OVERLAP" in label
        or "DIFFERS-from-authority" in label or "still-in-monorepo-DRIFTED" in label
        for label in detail
    )
    return 1 if defective else 0


if __name__ == "__main__":
    raise SystemExit(main())
