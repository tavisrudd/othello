#!/usr/bin/env python3
"""Run the complete Clebsch release-verification manifest.

The runner accepts only argv-form commands from the tracked trust manifest;
it never invokes a shell.  It requires a clean Git worktree, verifies that
the pinned shared-Lean commit matches the separately supplied flattened Lean
repository, runs the manifest validator, executes every declared check in
order, and confirms that no tracked or untracked paper or Lean path changed
during verification.
Its success JSON omits timing and machine-local paths so the same manifest
and successful check set produce byte-identical scholarly output.

Build caches and other ignored files are outside the Git cleanliness check.
Every scholarly output consumed by the trust ledger is instead a tracked,
hash-pinned artifact validated by ``verify_trust_manifest.py``.
"""

from __future__ import annotations

import argparse
import json
import subprocess
import sys
from pathlib import Path


SHELL_EXECUTABLES = {
    "bash",
    "dash",
    "fish",
    "powershell",
    "pwsh",
    "sh",
    "zsh",
}


def run(
    argv: list[str],
    cwd: Path,
    *,
    capture: bool = True,
) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        argv,
        cwd=cwd,
        check=False,
        text=True,
        stdout=subprocess.PIPE if capture else None,
        stderr=subprocess.PIPE if capture else None,
    )


def git_snapshot(repository_root: Path) -> str:
    result = run(
        ["git", "status", "--porcelain=v1", "--untracked-files=all", "--", "."],
        repository_root,
    )
    if result.returncode != 0:
        raise RuntimeError(f"git status failed: {result.stderr.strip()}")
    return result.stdout


def safe_cwd(
    repositories: dict[str, Path],
    repository: object,
    value: object,
    where: str,
) -> Path:
    if not isinstance(repository, str) or repository not in repositories:
        raise ValueError(
            f"{where}.repository must be one of {sorted(repositories)}"
        )
    repository_root = repositories[repository].resolve()
    if not isinstance(value, str) or not value:
        raise ValueError(f"{where}.cwd must be a nonempty repository-relative path")
    relative = Path(value)
    if relative.is_absolute() or ".." in relative.parts:
        raise ValueError(f"{where}.cwd must be a safe repository-relative path")
    resolved = (repository_root / relative).resolve()
    if not resolved.is_relative_to(repository_root.resolve()) or not resolved.is_dir():
        raise ValueError(f"{where}.cwd does not name a repository directory")
    return resolved


def command_argv(value: object, where: str) -> list[str]:
    if (
        not isinstance(value, list)
        or not value
        or any(not isinstance(item, str) or not item for item in value)
    ):
        raise ValueError(f"{where} must be a nonempty array of nonempty strings")
    if Path(value[0]).name in SHELL_EXECUTABLES:
        raise ValueError(f"{where} may not invoke a shell")
    return value


def bounded_failure_output(text: str, line_limit: int = 20) -> str:
    lines = text.splitlines()
    return "\n".join(lines[-line_limit:])


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Run the complete Clebsch release verification."
    )
    paper_root = Path(__file__).resolve().parents[1]
    parser.add_argument(
        "manifest",
        nargs="?",
        type=Path,
        default=paper_root / "verification" / "trust_manifest.json",
    )
    parser.add_argument(
        "--lean-root",
        type=Path,
        required=True,
        help="root of the separately checked-out, flattened shared Lean repository",
    )
    args = parser.parse_args()

    manifest_path = args.manifest.resolve()
    repositories = {
        "paper": paper_root.resolve(),
        "lean": args.lean_root.resolve(),
    }
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    if not isinstance(manifest, dict):
        raise ValueError("manifest root must be an object")

    initial_snapshots = {
        name: git_snapshot(root) for name, root in repositories.items()
    }
    for name, snapshot in initial_snapshots.items():
        if snapshot:
            changed = snapshot.splitlines()
            preview = "\n".join(changed[:10])
            raise RuntimeError(
                f"release verification requires a clean {name} worktree; "
                f"found {len(changed)} changed paths:\n{preview}"
            )

    lean_repository = manifest.get("lean_repository")
    if not isinstance(lean_repository, dict):
        raise ValueError("manifest.lean_repository must be an object")
    pinned_commit = lean_repository.get("commit")
    if not isinstance(pinned_commit, str) or not pinned_commit:
        raise ValueError("manifest.lean_repository.commit must be a nonempty string")
    paper_git_root = run(
        ["git", "rev-parse", "--show-toplevel"], paper_root
    )
    lean_git_root = run(
        ["git", "rev-parse", "--show-toplevel"], repositories["lean"]
    )
    if paper_git_root.returncode != 0 or lean_git_root.returncode != 0:
        raise RuntimeError("paper and Lean roots must both belong to Git repositories")
    if paper_git_root.stdout.strip() == lean_git_root.stdout.strip():
        ancestry = run(
            ["git", "merge-base", "--is-ancestor", pinned_commit, "HEAD"],
            repositories["lean"],
        )
        if ancestry.returncode != 0:
            raise RuntimeError(
                "the pinned shared-Lean commit is not an ancestor of HEAD"
            )
    else:
        lean_head = run(["git", "rev-parse", "HEAD"], repositories["lean"])
        if lean_head.returncode != 0 or lean_head.stdout.strip() != pinned_commit:
            raise RuntimeError(
                "the separate shared-Lean repository is not at the pinned commit"
            )

    manifest_check = run(
        [
            sys.executable,
            str(paper_root / "verification" / "verify_trust_manifest.py"),
            str(manifest_path),
            "--manuscript",
            str(paper_root / "clebsch_hexagon_code.tex"),
            "--lean-root",
            str(repositories["lean"]),
        ],
        paper_root,
    )
    if manifest_check.returncode != 0:
        detail = bounded_failure_output(
            manifest_check.stderr or manifest_check.stdout
        )
        raise RuntimeError(f"trust-manifest validation failed:\n{detail}")

    verify_all = manifest.get("verify_all")
    if not isinstance(verify_all, dict):
        raise ValueError("manifest.verify_all must be an object")
    checks = verify_all.get("checks")
    if not isinstance(checks, list) or not checks:
        raise ValueError("manifest.verify_all.checks must be a nonempty list")

    summaries: list[dict[str, object]] = []
    seen_ids: set[str] = set()
    for index, check in enumerate(checks):
        where = f"manifest.verify_all.checks[{index}]"
        if not isinstance(check, dict):
            raise ValueError(f"{where} must be an object")
        check_id = check.get("id")
        if not isinstance(check_id, str) or not check_id:
            raise ValueError(f"{where}.id must be a nonempty string")
        if check_id in seen_ids:
            raise ValueError(f"duplicate verification check ID {check_id!r}")
        seen_ids.add(check_id)
        cwd = safe_cwd(
            repositories,
            check.get("repository"),
            check.get("cwd"),
            where,
        )
        argv = command_argv(check.get("argv"), f"{where}.argv")
        timeout = check.get("timeout_seconds")
        if (
            not isinstance(timeout, int)
            or isinstance(timeout, bool)
            or not 1 <= timeout <= 86400
        ):
            raise ValueError(
                f"{where}.timeout_seconds must be an integer from 1 to 86400"
            )

        try:
            result = subprocess.run(
                argv,
                cwd=cwd,
                check=False,
                text=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                timeout=timeout,
            )
        except subprocess.TimeoutExpired as error:
            detail = bounded_failure_output(
                (error.stderr or "") if isinstance(error.stderr, str) else ""
            )
            raise RuntimeError(
                f"verification check {check_id!r} timed out after "
                f"{timeout} seconds:\n{detail}"
            ) from error
        if result.returncode != 0:
            detail = bounded_failure_output(result.stderr or result.stdout)
            raise RuntimeError(
                f"verification check {check_id!r} failed with "
                f"exit {result.returncode}:\n{detail}"
            )
        summaries.append({"id": check_id, "status": "passed"})

    final_snapshots = {
        name: git_snapshot(root) for name, root in repositories.items()
    }
    for name, final_snapshot in final_snapshots.items():
        if final_snapshot != initial_snapshots[name]:
            changed = final_snapshot.splitlines()
            preview = "\n".join(changed[:10])
            raise RuntimeError(
                f"verification changed {len(changed)} {name} paths:\n{preview}"
            )

    print(
        json.dumps(
            {
                "check_count": len(summaries),
                "checks": summaries,
                "lean_commit": pinned_commit,
                "status": "passed",
            },
            indent=2,
            sort_keys=True,
        )
    )
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (
        OSError,
        UnicodeError,
        json.JSONDecodeError,
        RuntimeError,
        ValueError,
    ) as error:
        print(f"release verification failed: {error}", file=sys.stderr)
        raise SystemExit(1)
