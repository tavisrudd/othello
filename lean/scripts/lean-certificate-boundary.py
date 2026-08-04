#!/usr/bin/env python3
"""Reject certificate-package sources or replay artifacts in the monorepo."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import subprocess
import tomllib
from pathlib import Path


LEAN_ROOT = Path(__file__).resolve().parents[1]
REPO_ROOT = LEAN_ROOT.parent
CONFIG = LEAN_ROOT / "trust" / "certificate-packages.toml"
IMPORT_RE = re.compile(r"^import\s+([A-Za-z0-9_'.]+)\s*$", re.MULTILINE)


def tracked_paths(repo_root: Path) -> list[Path]:
    result = subprocess.run(
        ["git", "ls-files", "--cached", "--others", "--exclude-standard", "--", "lean", "papers"],
        cwd=repo_root,
        check=True,
        text=True,
        capture_output=True,
    )
    return [repo_root / line for line in result.stdout.splitlines()]


def module_name(lean_root: Path, path: Path) -> str | None:
    try:
        relative = path.relative_to(lean_root)
    except ValueError:
        return None
    if path.suffix != ".lean":
        return None
    return ".".join(relative.with_suffix("").parts)


def violations(repo_root: Path, lean_root: Path, config: Path) -> list[str]:
    with config.open("rb") as handle:
        document = tomllib.load(handle)
    problems: list[str] = []
    paths = tracked_paths(repo_root)
    for package in document.get("package", []):
        prefixes = tuple(package["owned_module_prefixes"])
        forbidden_names = set(package["forbidden_artifact_basenames"])
        for path in paths:
            relative = path.relative_to(repo_root)
            if path.name in forbidden_names:
                problems.append(f"{relative}: certificate artifact belongs to {package['name']}")
            module = module_name(lean_root, path)
            if module is not None and module.startswith(prefixes):
                problems.append(f"{relative}: module belongs to {package['name']}")
            if path.suffix == ".lean" and path.is_file():
                for imported in IMPORT_RE.findall(path.read_text(encoding="utf-8")):
                    if imported.startswith(prefixes):
                        problems.append(
                            f"{relative}: imports {imported}, owned by {package['name']}"
                        )
    return sorted(set(problems))


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def official_library_violations(config: Path, libraries_root: Path) -> list[str]:
    with config.open("rb") as handle:
        document = tomllib.load(handle)
    problems: list[str] = []
    for package in document.get("package", []):
        root = libraries_root / package["name"]
        if not root.is_dir():
            problems.append(f"{root}: official library checkout is missing")
            continue
        head = subprocess.run(
            ["git", "rev-parse", "HEAD"], cwd=root, check=True, text=True, capture_output=True
        ).stdout.strip()
        if head != package["commit"]:
            problems.append(f"{root}: HEAD {head} does not match pin {package['commit']}")
        manifest_path = root / "MANIFEST.json"
        if not manifest_path.is_file():
            problems.append(f"{manifest_path}: missing")
            continue
        if sha256(manifest_path) != package["manifest_sha256"]:
            problems.append(f"{manifest_path}: hash does not match the monorepo pin")
            continue
        manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
        for source in manifest.get("sources", []):
            path = root / source["path"]
            if not path.is_file() or sha256(path) != source["sha256"]:
                problems.append(f"{path}: missing or differs from the sealed source")
    return sorted(set(problems))


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--repo-root", type=Path, default=REPO_ROOT)
    parser.add_argument("--lean-root", type=Path)
    parser.add_argument("--config", type=Path)
    parser.add_argument("--libraries-root", type=Path, default=Path.home() / "src/lean")
    parser.add_argument("--verify-official-libraries", action="store_true")
    args = parser.parse_args()
    repo_root = args.repo_root.resolve()
    lean_root = (args.lean_root or repo_root / "lean").resolve()
    config = (args.config or lean_root / "trust/certificate-packages.toml").resolve()
    problems = violations(repo_root, lean_root, config)
    if args.verify_official_libraries:
        problems.extend(official_library_violations(config, args.libraries_root.resolve()))
    if problems:
        print("certificate boundary violations:")
        for problem in problems:
            print(f"- {problem}")
        return 1
    print("certificate boundary ok")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
