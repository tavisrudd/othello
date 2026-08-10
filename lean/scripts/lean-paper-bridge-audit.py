#!/usr/bin/env python3
"""Audit cheap paper bridges and their frozen dependency boundary."""

from __future__ import annotations

import argparse
import hashlib
import json
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
    status = bridge.get("status", "active")
    if status not in {"active", "authority-pending-export"}:
        problems.append(f"{name}: unsupported bridge status {status!r}")
    pending_export = status == "authority-pending-export"
    if pending_export and any(
        field in bridge for field in ("bridge_commit", "export_source_commit")
    ):
        problems.append(
            f"{name}: pending export must not claim bridge or export commits"
        )
    source = source_root / bridge["source"]
    finitegeom = libraries_root / "finitegeom"
    certificate = libraries_root / bridge["certificate_package"]
    if not source.is_file():
        return [f"{name}: bridge source is missing at {bridge['source']}"]
    source_text = source.read_text(encoding="utf-8")
    expected_imports = [bridge["finitegeom_import"], bridge["certificate_import"]]
    actual_imports = imports(source)
    if actual_imports != expected_imports:
        problems.append(
            f"{name}: imports are {actual_imports}, expected {expected_imports}"
        )
    namespace_line = f"namespace {bridge['module']}"
    if namespace_line not in source_text.splitlines():
        problems.append(f"{name}: missing exact namespace {bridge['module']}")
    compatibility = bridge.get("compatibility_declarations", [])
    transport_at = source_text.find("structure TransportWitness")
    for declaration in compatibility:
        declaration_at = source_text.find(f"theorem {declaration}")
        if declaration_at < 0:
            problems.append(f"{name}: missing compatibility theorem {declaration}")
        elif transport_at < 0 or declaration_at > transport_at:
            problems.append(
                f"{name}: compatibility theorem {declaration} is not before transport"
            )
    for declaration in bridge.get("published_declarations", []):
        if f"theorem {declaration}" not in source_text:
            problems.append(f"{name}: missing published theorem {declaration}")
    for token in bridge.get("forbidden_source_tokens", []):
        if token in source_text:
            problems.append(f"{name}: forbidden source token {token!r}")
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
    bridge_root = libraries_root / bridge["repository"]
    if not pending_export and not bridge_root.is_dir():
        problems.append(f"{name}: bridge checkout is missing at {bridge_root}")
    elif not pending_export:
        try:
            actual = git_output(bridge_root, "rev-parse", "HEAD")
            dirty = git_output(bridge_root, "status", "--short")
        except subprocess.CalledProcessError:
            problems.append(f"{name}: cannot read bridge Git state at {bridge_root}")
        else:
            if actual != bridge["bridge_commit"]:
                problems.append(
                    f"{name}: bridge HEAD is {actual}, expected {bridge['bridge_commit']}"
                )
            if dirty:
                problems.append(f"{name}: bridge checkout is dirty")
        manifest_path = bridge_root / "MANIFEST.json"
        try:
            manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError):
            problems.append(f"{name}: bridge MANIFEST.json is missing or invalid")
        else:
            if manifest.get("source_commit") != bridge["export_source_commit"]:
                problems.append(
                    f"{name}: bridge manifest source commit is "
                    f"{manifest.get('source_commit')}, expected {bridge['export_source_commit']}"
                )
            if manifest.get("roots") != [bridge["module"]]:
                problems.append(f"{name}: bridge manifest has the wrong library root")
            expected_sources = {bridge["module"].replace(".", "/") + ".lean"}
            actual_sources = {
                row.get("path")
                for row in manifest.get("sources", [])
                if isinstance(row, dict)
            }
            if actual_sources != expected_sources:
                problems.append(f"{name}: bridge manifest source set is incomplete")
        try:
            dependencies = direct_dependencies(bridge_root)
        except (OSError, tomllib.TOMLDecodeError, KeyError):
            problems.append(f"{name}: bridge lakefile.toml is missing or invalid")
        else:
            expected = {"finitegeom", bridge["certificate_package"]}
            if dependencies != expected:
                problems.append(
                    f"{name}: bridge dependencies are {sorted(dependencies)}, "
                    f"expected {sorted(expected)}"
                )
        try:
            readme = (bridge_root / "README.md").read_text(encoding="utf-8").lower()
        except OSError:
            problems.append(f"{name}: bridge README.md is missing")
        else:
            forbidden = [word for word in ("authority", "mirror") if word in readme]
            if forbidden:
                problems.append(
                    f"{name}: bridge README contains forbidden workflow words {forbidden}"
                )
    if not bridge.get("forbid_source_fallback", False):
        problems.append(f"{name}: certificate source fallback is not forbidden")
    for field in ("certificate_olean_sha256", "certificate_trace_sha256"):
        digest = bridge.get(field, "")
        if len(digest) != 64 or any(character not in "0123456789abcdef" for character in digest):
            problems.append(f"{name}: {field} is not a lowercase SHA-256 digest")
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
