#!/usr/bin/env python3
"""Checkpoint and audit Lean artifacts across a graceful Lake restart.

This script never performs a real build.  ``checkpoint`` and ``verify`` call only
``lake build --no-build`` for explicit sentinel modules.  Choose sentinels from modules that the
running build most recently printed as ``Built``; an arbitrary existing olean may be stale.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import shutil
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path
from typing import NoReturn


LEAN_ROOT = Path(__file__).resolve().parents[1]
BUILD_LIB = LEAN_ROOT / ".lake" / "build" / "lib" / "lean"
MODULE_RE = re.compile(r"[A-Za-z0-9_]+(?:\.[A-Za-z0-9_]+)*\Z")
REQUIRED_SUFFIXES = (".olean", ".olean.hash", ".ilean.hash", ".trace")
CHECKPOINT_FILE = "restart-checkpoint.json"


def fail(message: str) -> NoReturn:
    print(f"lean-restart-guard: {message}", file=sys.stderr)
    raise SystemExit(2)


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def module_base(module: str) -> Path:
    if not MODULE_RE.fullmatch(module):
        fail(f"invalid module name: {module!r}")
    return BUILD_LIB.joinpath(*module.split("."))


def artifact_paths(module: str) -> list[Path]:
    base = module_base(module)
    paths = [Path(f"{base}{suffix}") for suffix in REQUIRED_SUFFIXES]
    missing = [str(path) for path in paths if not path.is_file()]
    if missing:
        fail(f"sentinel {module} is missing artifacts: {', '.join(missing)}")
    return paths


def assert_no_lake() -> None:
    """Refuse a checkpoint while a host-visible Lake process is active.

    Agent sandboxes may have a private PID namespace, so this is a second line of defense rather
    than authorization to skip the required external process/ancestry check.
    """
    pgrep = shutil.which("pgrep")
    if pgrep is None:
        fail("pgrep is unavailable; cannot check for a live lake.orig")
    result = subprocess.run(
        [pgrep, "-x", "lake.orig"],
        cwd=LEAN_ROOT,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
        check=False,
    )
    if result.returncode == 0:
        fail("lake.orig is running; stop it gracefully and confirm its children exited first")
    if result.returncode != 1:
        fail(f"pgrep failed with exit code {result.returncode}")


def lake_no_build(modules: list[str]) -> None:
    lake = shutil.which("lake")
    if lake is None:
        fail("lake is unavailable; enter the Lean development environment first")
    env = os.environ.copy()
    env["LEAN_NUM_THREADS"] = "1"
    result = subprocess.run(
        [lake, "build", "--no-build", *modules],
        cwd=LEAN_ROOT,
        env=env,
        check=False,
    )
    if result.returncode != 0:
        fail("a sentinel is not current according to `lake build --no-build`")


def checkpoint_path(directory: Path) -> Path:
    return directory / CHECKPOINT_FILE


def load_checkpoint(directory: Path) -> dict[str, object]:
    path = checkpoint_path(directory)
    if not path.is_file():
        fail(f"checkpoint file does not exist: {path}")
    try:
        data = json.loads(path.read_text())
    except (OSError, json.JSONDecodeError) as error:
        fail(f"cannot read checkpoint {path}: {error}")
    if data.get("lean_root") != str(LEAN_ROOT):
        fail(f"checkpoint belongs to a different Lean root: {data.get('lean_root')!r}")
    return data


def command_checkpoint(args: argparse.Namespace) -> None:
    assert_no_lake()
    destination = args.directory.expanduser().resolve()
    home = Path.home().resolve()
    if not destination.is_relative_to(home):
        fail(f"checkpoint must be disk-backed under {home}, not {destination}")
    if destination.exists():
        fail(f"checkpoint destination already exists: {destination}")
    modules = list(dict.fromkeys(args.modules))
    if not modules:
        fail("provide at least one recently completed sentinel module")
    for module in modules:
        module_base(module)
    lake_no_build(modules)

    sentinels: list[dict[str, object]] = []
    for module in modules:
        artifacts = artifact_paths(module)
        sentinels.append(
            {
                "module": module,
                "artifacts": {
                    str(path.relative_to(LEAN_ROOT)): sha256(path) for path in artifacts
                },
            }
        )

    destination.mkdir(parents=True)
    data = {
        "format": 1,
        "created_utc": datetime.now(timezone.utc).isoformat(),
        "lean_root": str(LEAN_ROOT),
        "sentinels": sentinels,
    }
    checkpoint_path(destination).write_text(json.dumps(data, indent=2, sort_keys=True) + "\n")
    print(f"checkpointed {len(modules)} sentinels in {destination}")
    print("For a recovery archive, also run `lake pack /home/.../build.tgz` while Lake is stopped.")


def verify_data(data: dict[str, object]) -> list[str]:
    raw_sentinels = data.get("sentinels")
    if not isinstance(raw_sentinels, list) or not raw_sentinels:
        fail("checkpoint has no sentinels")
    modules: list[str] = []
    expected: list[tuple[Path, str]] = []
    for raw in raw_sentinels:
        if not isinstance(raw, dict) or not isinstance(raw.get("module"), str):
            fail("checkpoint contains a malformed sentinel")
        module = raw["module"]
        modules.append(module)
        artifacts = raw.get("artifacts")
        if not isinstance(artifacts, dict):
            fail(f"checkpoint sentinel {module} has no artifact map")
        for relative, digest in artifacts.items():
            if not isinstance(relative, str) or not isinstance(digest, str):
                fail(f"checkpoint sentinel {module} has a malformed artifact entry")
            path = (LEAN_ROOT / relative).resolve()
            if not path.is_relative_to(BUILD_LIB.resolve()):
                fail(f"checkpoint artifact escapes the build library: {path}")
            expected.append((path, digest))

    lake_no_build(modules)
    mismatches: list[str] = []
    for path, digest in expected:
        if not path.is_file():
            mismatches.append(f"missing {path}")
        else:
            actual = sha256(path)
            if actual != digest:
                mismatches.append(f"changed {path}: {digest} -> {actual}")
    if mismatches:
        fail("sentinel artifact mismatch:\n  " + "\n  ".join(mismatches))
    return modules


def command_verify(args: argparse.Namespace) -> None:
    assert_no_lake()
    data = load_checkpoint(args.directory.expanduser().resolve())
    modules = verify_data(data)
    print(f"verified {len(modules)} current, byte-identical sentinels")


def command_audit_log(args: argparse.Namespace) -> None:
    data = load_checkpoint(args.directory.expanduser().resolve())
    raw_sentinels = data.get("sentinels")
    assert isinstance(raw_sentinels, list)
    modules = [item["module"] for item in raw_sentinels if isinstance(item, dict)]
    try:
        lines = args.log.expanduser().read_text(errors="replace").splitlines()
    except OSError as error:
        fail(f"cannot read build log {args.log}: {error}")
    rebuilt = [
        module
        for module in modules
        if any(re.search(rf"\bBuilt {re.escape(module)}(?:\s|$)", line) for line in lines)
    ]
    if rebuilt:
        fail("validated sentinels were rebuilt: " + ", ".join(rebuilt))
    print(f"build log does not rebuild any of {len(modules)} validated sentinels")


def parser() -> argparse.ArgumentParser:
    result = argparse.ArgumentParser(description=__doc__)
    subparsers = result.add_subparsers(dest="command", required=True)

    checkpoint = subparsers.add_parser(
        "checkpoint", help="validate and hash recently completed sentinel modules"
    )
    checkpoint.add_argument("directory", type=Path)
    checkpoint.add_argument("modules", nargs="+")
    checkpoint.set_defaults(function=command_checkpoint)

    verify = subparsers.add_parser(
        "verify", help="re-run no-build probes and compare sentinel artifact hashes"
    )
    verify.add_argument("directory", type=Path)
    verify.set_defaults(function=command_verify)

    audit_log = subparsers.add_parser(
        "audit-log", help="fail if a resumed build log rebuilt a validated sentinel"
    )
    audit_log.add_argument("directory", type=Path)
    audit_log.add_argument("log", type=Path)
    audit_log.set_defaults(function=command_audit_log)
    return result


def main() -> None:
    args = parser().parse_args()
    args.function(args)


if __name__ == "__main__":
    main()
