#!/usr/bin/env python3
"""Run the complete clean-source release verification for the rigidity paper."""

from __future__ import annotations

import argparse
import hashlib
import json
import subprocess
import sys
from pathlib import Path


SHELLS = {"bash", "dash", "fish", "powershell", "pwsh", "sh", "zsh"}
LEAN_SCHOLARLY_PATHS = (
    "RelativeConicArcs/Gates/ClebschRigidityTrust.lean",
    "RelativeConicArcs/Q11A5PointOrbits.lean",
    "RelativeConicArcs/Q11Coding.lean",
    "RelativeConicArcs/Q11DecodingSynthesis.lean",
    "RelativeConicArcs/Q11DyeAxioms.lean",
    "RelativeConicArcs/SixArcDefectBridge.lean",
    "RelativeConicArcs/Q11DyeConsequences.lean",
    "RelativeConicArcs/ClebschChordDefect.lean",
    "RelativeConicArcs/Q9Sylvester.lean",
    "RelativeConicArcs/SmallKChordMoments.lean",
    "RelativeConicArcs/SmallKGeometricBridge.lean",
    "verification/clebsch_rigidity_trust/axiom-audit.txt",
)


def release_surface_sha256(manifest: dict[str, object]) -> str:
    """Hash every manifest field except the hash-pinned release output itself."""
    projection = json.loads(json.dumps(manifest))
    projection["verify_all"].pop("output")
    encoded = json.dumps(
        projection, separators=(",", ":"), sort_keys=True
    ).encode("utf-8")
    return hashlib.sha256(encoded).hexdigest()


def run(
    argv: list[str],
    cwd: Path,
    *,
    timeout: int | None = None,
) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        argv,
        cwd=cwd,
        check=False,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        timeout=timeout,
    )


def git_snapshot(root: Path, pathspecs: tuple[str, ...]) -> str:
    result = run(
        [
            "git",
            "status",
            "--porcelain=v1",
            "--untracked-files=all",
            "--",
            *pathspecs,
        ],
        root,
    )
    if result.returncode != 0:
        raise RuntimeError(f"git status failed at {root}: {result.stderr.strip()}")
    return result.stdout


def safe_cwd(
    repositories: dict[str, Path],
    repository: object,
    value: object,
    where: str,
) -> Path:
    if not isinstance(repository, str) or repository not in repositories:
        raise ValueError(f"{where}.repository is invalid")
    if not isinstance(value, str) or not value:
        raise ValueError(f"{where}.cwd must be a nonempty string")
    relative = Path(value)
    if relative.is_absolute() or ".." in relative.parts:
        raise ValueError(f"{where}.cwd must be repository-relative")
    root = repositories[repository].resolve()
    resolved = (root / relative).resolve()
    if not resolved.is_relative_to(root) or not resolved.is_dir():
        raise ValueError(f"{where}.cwd does not name a repository directory")
    return resolved


def command_argv(value: object, where: str) -> list[str]:
    if (
        not isinstance(value, list)
        or not value
        or any(not isinstance(item, str) or not item for item in value)
    ):
        raise ValueError(f"{where} must contain nonempty strings")
    if Path(value[0]).name in SHELLS:
        raise ValueError(f"{where} may not invoke a shell")
    return value


def bounded(text: str, line_limit: int = 20) -> str:
    return "\n".join(text.splitlines()[-line_limit:])


def require_clean(snapshots: dict[str, str]) -> None:
    for name, snapshot in snapshots.items():
        if not snapshot:
            continue
        changed = snapshot.splitlines()
        raise RuntimeError(
            f"release verification requires a clean {name} root; "
            f"found {len(changed)} changed paths:\n"
            + "\n".join(changed[:10])
        )


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    paper_root = Path(__file__).resolve().parents[1]
    parser.add_argument(
        "manifest",
        nargs="?",
        type=Path,
        default=paper_root / "verification" / "trust_manifest.json",
    )
    parser.add_argument("--lean-root", type=Path, required=True)
    parser.add_argument(
        "--update-output",
        action="store_true",
        help="replace the deterministic release-output certificate after all checks pass",
    )
    args = parser.parse_args()
    repositories = {
        "paper": paper_root.resolve(),
        "lean": args.lean_root.resolve(),
    }
    manifest_path = args.manifest.resolve()
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    if not isinstance(manifest, dict):
        raise ValueError("manifest root must be an object")

    snapshot_paths = {
        "paper": (".",),
        "lean": LEAN_SCHOLARLY_PATHS,
    }
    initial = {
        name: git_snapshot(root, snapshot_paths[name])
        for name, root in repositories.items()
    }
    require_clean(initial)

    lean_repository = manifest.get("lean_repository")
    if not isinstance(lean_repository, dict):
        raise ValueError("manifest.lean_repository must be an object")
    pinned = lean_repository.get("commit")
    if not isinstance(pinned, str) or not pinned:
        raise ValueError("manifest.lean_repository.commit must be nonempty")
    paper_git = run(["git", "rev-parse", "--show-toplevel"], paper_root)
    lean_git = run(["git", "rev-parse", "--show-toplevel"], repositories["lean"])
    if paper_git.returncode != 0 or lean_git.returncode != 0:
        raise RuntimeError("paper and Lean roots must belong to Git repositories")
    if paper_git.stdout.strip() == lean_git.stdout.strip():
        ancestry = run(
            ["git", "merge-base", "--is-ancestor", pinned, "HEAD"],
            repositories["lean"],
        )
        if ancestry.returncode != 0:
            raise RuntimeError("the pinned Lean commit is not an ancestor of HEAD")
    else:
        lean_head = run(["git", "rev-parse", "HEAD"], repositories["lean"])
        if lean_head.returncode != 0 or lean_head.stdout.strip() != pinned:
            raise RuntimeError("the separate Lean repository is not at the pinned commit")
    lean_identity = run(
        ["git", "diff", "--quiet", pinned, "--", *LEAN_SCHOLARLY_PATHS],
        repositories["lean"],
    )
    if lean_identity.returncode != 0:
        raise RuntimeError(
            "the Paper I Lean source paths differ from the pinned commit"
        )

    validator_command = [
        sys.executable,
        str(paper_root / "verification" / "verify_trust_manifest.py"),
        str(manifest_path),
        "--manuscript",
        str(paper_root / "clebsch_rigidity.tex"),
        "--lean-root",
        str(repositories["lean"]),
    ]
    if args.update_output:
        validator_command.append("--allow-stale-release-output")
    validator = run(validator_command, paper_root)
    if validator.returncode != 0:
        raise RuntimeError(
            "trust-manifest validation failed:\n"
            + bounded(validator.stderr or validator.stdout)
        )

    verify_all = manifest.get("verify_all")
    if not isinstance(verify_all, dict):
        raise ValueError("manifest.verify_all must be an object")
    checks = verify_all.get("checks")
    if not isinstance(checks, list) or not checks:
        raise ValueError("manifest.verify_all.checks must be nonempty")

    summaries: list[dict[str, str]] = []
    seen: set[str] = set()
    for index, check in enumerate(checks):
        where = f"manifest.verify_all.checks[{index}]"
        if not isinstance(check, dict):
            raise ValueError(f"{where} must be an object")
        check_id = check.get("id")
        if not isinstance(check_id, str) or not check_id:
            raise ValueError(f"{where}.id must be nonempty")
        if check_id in seen:
            raise ValueError(f"duplicate check ID {check_id}")
        seen.add(check_id)
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
            or not 1 <= timeout <= 3600
        ):
            raise ValueError(f"{where}.timeout_seconds is invalid")
        try:
            result = run(argv, cwd, timeout=timeout)
        except subprocess.TimeoutExpired as error:
            detail = bounded(
                error.stderr if isinstance(error.stderr, str) else ""
            )
            raise RuntimeError(
                f"verification check {check_id!r} timed out after "
                f"{timeout} seconds:\n{detail}"
            ) from error
        if result.returncode != 0:
            raise RuntimeError(
                f"verification check {check_id!r} failed with "
                f"exit {result.returncode}:\n"
                + bounded(result.stderr or result.stdout)
            )
        expected_stdout = check.get("stdout_sha256")
        if expected_stdout is not None:
            actual_bytes = result.stdout.encode("utf-8")
            actual_sha256 = hashlib.sha256(actual_bytes).hexdigest()
            actual_lines = len(result.stdout.splitlines())
            if (
                actual_sha256 != expected_stdout
                or len(actual_bytes) != check.get("stdout_bytes")
                or actual_lines != check.get("stdout_lines")
            ):
                raise RuntimeError(
                    f"verification check {check_id!r} produced stale stdout: "
                    f"sha256={actual_sha256}, bytes={len(actual_bytes)}, "
                    f"lines={actual_lines}"
                )
        summaries.append({"id": check_id, "status": "passed"})

    final = {
        name: git_snapshot(root, snapshot_paths[name])
        for name, root in repositories.items()
    }
    for name, snapshot in final.items():
        if snapshot != initial[name]:
            changed = snapshot.splitlines()
            raise RuntimeError(
                f"verification changed {len(changed)} {name} paths:\n"
                + "\n".join(changed[:10])
            )

    payload = {
        "check_count": len(summaries),
        "checks": summaries,
        "inputs": {
            "checker_outputs_sha256": manifest["verify_all"][
                "checker_output_certificate"
            ]["output"]["sha256"],
            "manuscript_pdf_sha256": manifest["manuscript_pdf"]["sha256"],
            "manuscript_sha256": manifest["manuscript_sha256"],
            "release_surface_sha256": release_surface_sha256(manifest),
            "statement_identity_sha256": manifest["statement_identity"]["sha256"],
        },
        "lean_commit": pinned,
        "status": "passed",
    }
    rendered = json.dumps(payload, indent=2, sort_keys=True) + "\n"
    expected_output = paper_root / "verification" / "verify-release-output.json"
    if args.update_output:
        expected_output.write_text(rendered, encoding="utf-8")
    elif expected_output.read_text(encoding="utf-8") != rendered:
        raise RuntimeError(f"stale deterministic release output: {expected_output}")
    print(rendered, end="")
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
