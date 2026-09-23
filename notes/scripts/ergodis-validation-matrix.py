#!/usr/bin/env python3
"""Opt-in inventory of Ergodis checks; this does not change release policy."""

from __future__ import annotations

import argparse
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import tomllib


FAMILIES = (
    "component", "composition", "css", "fault", "hadamard", "lrc",
    "parameterization", "qec", "scheduling",
)


def matrix(jobs: int) -> list[dict]:
    cargo = ["cargo"]
    test = cargo + ["test", "--locked", "-j", str(jobs)]
    rows = [
        dict(id="core-default", repo="ergodis", level="execute", commands=[test]),
        dict(id="core-all-features", repo="ergodis", level="execute", commands=[
            cargo + ["fmt", "--check"],
            cargo + ["clippy", "--locked", "-j", str(jobs), "--all-targets", "--all-features", "--", "-D", "warnings"],
            test + ["--all-features"],
            ["python3", "python/generate_fixtures.py", "--check"],
            ["python3", "python/generate_evidence.py", "--check"],
        ]),
        dict(id="modules-native", repo="ergodis", level="execute", commands=[
            test + ["-p", "ergodis-modules", "--features", "native"],
        ], limitation="loaded_transcript stays ignored: requires a separately built immutable package and transcript"),
        dict(id="browser", repo="ergodis", level="execute", commands=[
            cargo + ["check", "--locked", "-j", str(jobs), "--manifest-path", "wasm/Cargo.toml", "--target", "wasm32-unknown-unknown"],
            ["nix", "run", ".#wasm-build"],
            ["nix", "run", ".#wasm-test"],
            ["nix", "run", ".#wasm-smoke"],
        ], artifacts=["wasm/www/pkg/ergodis_wasm_bg.wasm", "wasm/www/pkg/ergodis_wasm.js"]),
    ]
    for family in FAMILIES:
        for target in ("native", "wasm32-unknown-unknown"):
            command = cargo + ["check", "--locked", "-j", str(jobs), "--lib", "-p", f"ergodis-{family}-provider"]
            if target != "native":
                command += ["--target", target]
            rows.append(dict(
                id=f"{family}-{target}", repo="ergodis-private", level="compile-only",
                commands=[command],
                limitation="type checking only; no linking, ABI transcript, provider execution or threaded-feature coverage",
            ))
    return rows


def capture(argv: list[str], cwd: Path) -> str:
    return subprocess.check_output(argv, cwd=cwd, text=True).strip()


def source_state(repo: Path) -> dict:
    status = capture(["git", "status", "--porcelain=v1", "--untracked-files=normal"], repo)
    diff = subprocess.check_output(["git", "diff", "HEAD", "--binary"], cwd=repo)
    untracked = subprocess.check_output(
        ["git", "ls-files", "--others", "--exclude-standard", "-z"], cwd=repo)
    hashes = {}
    for raw_name in untracked.split(b"\0"):
        if not raw_name:
            continue
        name = os.fsdecode(raw_name)
        file = repo / name
        if file.is_symlink():
            hashes[name] = "symlink:" + hashlib.sha256(os.fsencode(os.readlink(file))).hexdigest()
        else:
            with file.open("rb") as stream:
                hashes[name] = hashlib.file_digest(stream, "sha256").hexdigest()
    return dict(revision=capture(["git", "rev-parse", "HEAD"], repo),
                status=status.splitlines(), tracked_diff_sha256=hashlib.sha256(diff).hexdigest(),
                untracked_sha256=hashes)


def write_receipt(path: Path, receipt: dict) -> None:
    temporary = path.with_suffix(".tmp")
    temporary.write_text(json.dumps(receipt, indent=2) + "\n")
    temporary.replace(path)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--repos-root", type=Path, default=Path.home() / "src")
    parser.add_argument("--jobs", type=int, default=8, choices=range(1, 13))
    parser.add_argument("--run", nargs="+", choices=[row["id"] for row in matrix(8)])
    parser.add_argument("--output", type=Path, help="new directory for receipt and command logs")
    args = parser.parse_args()
    rows = matrix(args.jobs)
    if args.run is None:
        for row in rows:
            print(f"{row['id']:38} {row['level']:12} {row.get('limitation', '')}")
        return 0
    if args.output is None:
        parser.error("--run requires --output (a new directory)")
    overrides = ("CARGO_TARGET_DIR", "CARGO_BUILD_TARGET_DIR", "CARGO_BUILD_TARGET",
                 "RUSTC", "RUSTC_WRAPPER", "RUSTC_WORKSPACE_WRAPPER", "RUSTDOC",
                 "CARGO_BUILD_RUSTC", "CARGO_BUILD_RUSTC_WRAPPER", "CARGO_BUILD_RUSTDOC")
    present = [name for name in overrides if os.environ.get(name)]
    if present:
        parser.error(f"unset compiler/target overrides for the pinned shared-target matrix: {present}")
    root = args.repos_root.resolve()
    core = root / "ergodis"
    private = root / "ergodis-private"
    members = tomllib.loads((private / "Cargo.toml").read_text())["workspace"]["members"]
    actual = {Path(member).name.removesuffix("-provider") for member in members
              if member.startswith("packages/") and member.endswith("-provider")}
    if actual != set(FAMILIES):
        parser.error(f"provider inventory drift: recorded={sorted(FAMILIES)}, workspace={sorted(actual)}")
    args.output.mkdir(parents=True, exist_ok=False)
    path = args.output / "receipt.json"
    env = dict(os.environ, CARGO_BUILD_JOBS=str(args.jobs))
    receipt = dict(schema=1, started=datetime.now(timezone.utc).isoformat(), repos_root=str(root),
                   runner_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
                   sources={name: source_state(root / name) for name in ("ergodis", "ergodis-private")},
                   environment={key: env.get(key) for key in
                                ("RUSTFLAGS", "CARGO_ENCODED_RUSTFLAGS", "CARGO_TARGET_DIR", "CARGO_BUILD_JOBS")},
                   rows=[dict(row, status="pending" if row["id"] in args.run else "skipped:not-selected") for row in rows])
    write_receipt(path, receipt)
    receipt["rustc"] = capture(["nix", "develop", str(core), "-c", "rustc", "-vV"], core)
    failed = False
    for row in receipt["rows"]:
        if row["status"] != "pending":
            continue
        row["status"] = "running"
        row["results"] = []
        write_receipt(path, receipt)
        for index, command in enumerate(row["commands"]):
            # Each row stops on failure: in particular a failed fresh browser
            # build can never fall through into a smoke of yesterday's package.
            argv = command if command[0] == "nix" else ["nix", "develop", str(core), "-c", *command]
            log = args.output / f"{row['id']}-{index}.log"
            with log.open("wb") as stream:
                try:
                    result = subprocess.run(argv, cwd=root / row["repo"], env=env,
                                            stdout=stream, stderr=subprocess.STDOUT)
                    code = result.returncode
                except OSError as error:
                    stream.write(str(error).encode())
                    code = 127
            row["results"].append(dict(argv=argv, cwd=str(root / row["repo"]), exit_code=code, log=log.name,
                                        log_sha256=hashlib.sha256(log.read_bytes()).hexdigest()))
            write_receipt(path, receipt)
            if code:
                row["status"] = "failed"
                failed = True
                break
        else:
            row["status"] = "passed"
            row["artifact_sha256"] = {
                name: hashlib.sha256((root / row["repo"] / name).read_bytes()).hexdigest()
                for name in row.get("artifacts", [])
            }
        print(f"{row['id']}: {row['status']} ({row['level']})", flush=True)
        write_receipt(path, receipt)
    receipt["sources_after"] = {name: source_state(root / name) for name in receipt["sources"]}
    receipt["source_state_unchanged"] = receipt["sources"] == receipt["sources_after"]
    receipt["finished"] = datetime.now(timezone.utc).isoformat()
    # Concurrent edits invalidate a green source snapshot, even if commands passed.
    failed |= not receipt["source_state_unchanged"]
    receipt["accepted"] = not failed
    write_receipt(path, receipt)
    return int(failed)


if __name__ == "__main__":
    sys.exit(main())
