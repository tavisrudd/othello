#!/usr/bin/env python3
"""Reject project-owned dependencies from self-contained certificate packages."""

from __future__ import annotations

import argparse
import json
import tomllib
from pathlib import Path


LEAN_ROOT = Path(__file__).resolve().parents[1]
CONFIG = LEAN_ROOT / "trust" / "certificate-dependency-firewall.toml"
PROJECT_URL_PREFIX = "https://github.com/tavisrudd/"


def normalized_url(value: str) -> str:
    return value.removesuffix(".git")


def direct_manifest_packages(document: dict) -> dict[str, dict]:
    return {
        package["name"]: package
        for package in document.get("packages", [])
        if not package.get("inherited", False)
    }


def certificate_violations(root: Path, policy: dict) -> list[str]:
    name = policy["name"]
    allowed = set(policy["allowed_direct_dependencies"])
    problems: list[str] = []
    lakefile = root / "lakefile.toml"
    manifest = root / "lake-manifest.json"
    if not root.is_dir():
        return [f"{name}: checkout is missing at {root}"]
    if not lakefile.is_file():
        return [f"{name}: lakefile.toml is missing"]
    if not manifest.is_file():
        return [f"{name}: lake-manifest.json is missing"]

    with lakefile.open("rb") as handle:
        lake = tomllib.load(handle)
    if lake.get("name") != name:
        problems.append(f"{name}: lakefile declares package {lake.get('name')!r}")
    requirements = {entry["name"]: entry for entry in lake.get("require", [])}
    unexpected = sorted(set(requirements) - allowed)
    missing = sorted(allowed - set(requirements))
    for dependency in unexpected:
        problems.append(f"{name}: forbidden direct dependency {dependency}")
    for dependency in missing:
        problems.append(f"{name}: required direct dependency {dependency} is missing")
    for dependency, entry in sorted(requirements.items()):
        url = normalized_url(str(entry.get("git", "")))
        if url.startswith(PROJECT_URL_PREFIX):
            problems.append(
                f"{name}: project-owned dependency {dependency} at {url} is forbidden"
            )

    resolved = direct_manifest_packages(json.loads(manifest.read_text(encoding="utf-8")))
    unexpected_resolved = sorted(set(resolved) - allowed)
    missing_resolved = sorted(allowed - set(resolved))
    for dependency in unexpected_resolved:
        problems.append(f"{name}: manifest resolves forbidden direct dependency {dependency}")
    for dependency in missing_resolved:
        problems.append(f"{name}: manifest omits direct dependency {dependency}")
    for dependency in sorted(allowed & set(requirements) & set(resolved)):
        requested = requirements[dependency]
        actual = resolved[dependency]
        requested_url = normalized_url(str(requested.get("git", "")))
        actual_url = normalized_url(str(actual.get("url", "")))
        requested_rev = requested.get("rev")
        if requested_url != actual_url or {
            actual.get("rev"), actual.get("inputRev")
        } != {requested_rev}:
            problems.append(
                f"{name}: {dependency} lakefile pin does not match its resolved manifest entry"
            )
    return problems


def violations(config: Path, libraries_root: Path, selected: set[str]) -> list[str]:
    with config.open("rb") as handle:
        document = tomllib.load(handle)
    if document.get("schema_version") != 1:
        return [f"{config}: unsupported schema_version"]
    policies = document.get("certificate", [])
    known = {policy["name"] for policy in policies}
    unknown = sorted(selected - known)
    problems = [f"unknown certificate policy {name}" for name in unknown]
    for policy in policies:
        if selected and policy["name"] not in selected:
            continue
        root = libraries_root / policy["checkout"]
        problems.extend(certificate_violations(root, policy))
    return sorted(set(problems))


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--config", type=Path, default=CONFIG)
    parser.add_argument("--libraries-root", type=Path, default=Path.home() / "src/lean")
    parser.add_argument("--package", action="append", default=[])
    args = parser.parse_args()
    problems = violations(
        args.config.expanduser().resolve(),
        args.libraries_root.expanduser().resolve(),
        set(args.package),
    )
    if problems:
        print("certificate dependency firewall violations:")
        for problem in problems:
            print(f"- {problem}")
        return 1
    print("certificate dependency firewall ok")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
