#!/usr/bin/env python3
"""Audit cheap paper bridges and their frozen dependency boundary."""

from __future__ import annotations

import argparse
import hashlib
import subprocess
import tomllib
from pathlib import Path


LEAN_ROOT = Path(__file__).resolve().parents[1]
CONFIG = LEAN_ROOT / "trust" / "paper-bridges.toml"


def git_output(root: Path, *args: str) -> str:
    return subprocess.run(
        ["git", "-C", str(root), *args],
        check=True,
        text=True,
        capture_output=True,
    ).stdout.strip()


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def imports(path: Path) -> list[str]:
    result: list[str] = []
    for line in path.read_text(encoding="utf-8").splitlines():
        stripped = line.strip()
        if stripped.startswith("import "):
            result.extend(stripped.removeprefix("import ").split())
    return result


def direct_dependencies(root: Path) -> set[str]:
    with (root / "lakefile.toml").open("rb") as handle:
        document = tomllib.load(handle)
    return {entry["name"] for entry in document.get("require", [])}


def audit_bridge(
    bridge: dict, source_root: Path, libraries_root: Path, cache_root: Path
) -> list[str]:
    name = bridge["name"]
    problems: list[str] = []
    source = source_root / bridge["source"]
    finitegeom = libraries_root / "finitegeom"
    certificate = libraries_root / bridge["certificate_package"]
    if not source.is_file():
        return [f"{name}: bridge source is missing at {bridge['source']}"]
    expected_imports = [bridge["finitegeom_import"], bridge["certificate_import"]]
    actual_imports = imports(source)
    if actual_imports != expected_imports:
        problems.append(
            f"{name}: imports are {actual_imports}, expected {expected_imports}"
        )
    namespace_line = f"namespace {bridge['module']}"
    if namespace_line not in source.read_text(encoding="utf-8").splitlines():
        problems.append(f"{name}: missing exact namespace {bridge['module']}")
    for label, root, expected in (
        ("finitegeom", finitegeom, bridge["finitegeom_commit"]),
        ("certificate", certificate, bridge["certificate_commit"]),
    ):
        if not root.is_dir():
            problems.append(f"{name}: {label} checkout is missing at {root}")
            continue
        try:
            actual = git_output(root, "rev-parse", "HEAD")
            dirty = git_output(root, "status", "--short", "--untracked-files=no")
        except subprocess.CalledProcessError:
            problems.append(f"{name}: cannot read {label} Git state at {root}")
            continue
        if actual != expected:
            problems.append(f"{name}: {label} HEAD is {actual}, expected {expected}")
        if dirty:
            problems.append(f"{name}: {label} checkout has tracked modifications")
    if finitegeom.is_dir():
        forbidden = {bridge["certificate_package"]}
        found = direct_dependencies(finitegeom) & forbidden
        if found:
            problems.append(
                f"{name}: finitegeom directly depends on certificate package {sorted(found)}"
            )
    if not bridge.get("forbid_source_fallback", False):
        problems.append(f"{name}: certificate source fallback is not forbidden")
    archive = cache_root / bridge["cache_archive"]
    if not archive.is_file():
        problems.append(f"{name}: cache archive is missing at {archive}")
    elif sha256(archive) != bridge["cache_sha256"]:
        problems.append(f"{name}: cache archive SHA-256 mismatch")
    return problems


def violations(
    config: Path,
    source_root: Path,
    libraries_root: Path,
    cache_root: Path,
    selected: set[str],
) -> list[str]:
    with config.open("rb") as handle:
        document = tomllib.load(handle)
    if document.get("schema_version") != 1:
        return [f"{config}: unsupported schema_version"]
    bridges = document.get("bridge", [])
    known = {bridge["name"] for bridge in bridges}
    problems = [f"unknown paper bridge {name}" for name in sorted(selected - known)]
    for bridge in bridges:
        if selected and bridge["name"] not in selected:
            continue
        problems.extend(
            audit_bridge(bridge, source_root, libraries_root, cache_root)
        )
    return sorted(set(problems))


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--config", type=Path, default=CONFIG)
    parser.add_argument("--source-root", type=Path, default=LEAN_ROOT)
    parser.add_argument("--libraries-root", type=Path, default=Path.home() / "src/lean")
    parser.add_argument(
        "--cache-root",
        type=Path,
        default=Path.home() / ".cache/othello-lean-build/packs",
    )
    parser.add_argument("--bridge", action="append", default=[])
    args = parser.parse_args()
    problems = violations(
        args.config.expanduser().resolve(),
        args.source_root.expanduser().resolve(),
        args.libraries_root.expanduser().resolve(),
        args.cache_root.expanduser().resolve(),
        set(args.bridge),
    )
    if problems:
        print("paper bridge audit violations:")
        for problem in problems:
            print(f"- {problem}")
        return 1
    print("paper bridge audit ok")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
