#!/usr/bin/env python3
"""Reject certificate-package sources or replay artifacts in the monorepo."""

from __future__ import annotations

import argparse
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


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--repo-root", type=Path, default=REPO_ROOT)
    parser.add_argument("--lean-root", type=Path)
    parser.add_argument("--config", type=Path)
    args = parser.parse_args()
    repo_root = args.repo_root.resolve()
    lean_root = (args.lean_root or repo_root / "lean").resolve()
    config = (args.config or lean_root / "trust/certificate-packages.toml").resolve()
    problems = violations(repo_root, lean_root, config)
    if problems:
        print("certificate boundary violations:")
        for problem in problems:
            print(f"- {problem}")
        return 1
    print("certificate boundary ok")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
