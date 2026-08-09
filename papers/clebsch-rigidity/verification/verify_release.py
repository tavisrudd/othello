#!/usr/bin/env python3
"""Run the complete clean-source release verification for the rigidity paper."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import subprocess
import sys
from pathlib import Path
import re


SHELLS = {"bash", "dash", "fish", "powershell", "pwsh", "sh", "zsh"}
ROOT_GATE = "RelativeConicArcs.Gates.ClebschRigidityWithOrderElevenCertificates"
PROJECT_PREFIXES = ("RelativeConicArcs.", "ProjectiveCap.", "CapGame.")
AXIOM_AUDIT = "verification/clebsch_rigidity_trust/axiom-audit.txt"
FORBIDDEN_LEAN_CODE = re.compile(
    r"\b(?:sorry|admit|axiom|unsafe|native_decide)\b|\bdebug\.skipKernelTC\b"
)
QUIET_STDOUT_POINTER = re.compile(r"^stdout: \d+ lines -> (.+)$", re.MULTILINE)


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


def module_path(module: str) -> Path:
    return Path(*module.split(".")).with_suffix(".lean")


def project_import_closure(
    package_root: Path,
    finitegeom_root: Path,
    root_module: str = ROOT_GATE,
) -> tuple[tuple[str, ...], tuple[str, ...]]:
    """Resolve the exact project-owned import closure across both Lean roots."""
    pending = [root_module]
    seen: set[str] = set()
    package_paths: set[str] = set()
    finitegeom_paths: set[str] = set()
    while pending:
        module = pending.pop()
        if module in seen:
            continue
        seen.add(module)
        relative = module_path(module)
        package_path = package_root / relative
        finitegeom_path = finitegeom_root / relative
        if package_path.is_file():
            source = package_path
            package_paths.add(str(relative))
        elif finitegeom_path.is_file():
            source = finitegeom_path
            finitegeom_paths.add(str(relative))
        elif module.startswith(PROJECT_PREFIXES):
            raise RuntimeError(f"project import is absent from both Lean roots: {module}")
        else:
            continue
        source_text = lean_code_without_comments_or_strings(
            source.read_text(encoding="utf-8")
        )
        for line in source_text.splitlines():
            match = re.match(r"^\s*(?:public\s+)?import\s+(.+?)\s*$", line)
            if match is not None:
                pending.extend(match.group(1).split())
    return tuple(sorted(package_paths)), tuple(sorted(finitegeom_paths))


def lean_code_without_comments_or_strings(text: str) -> str:
    """Erase nested comments, line comments, and strings while preserving code."""
    result: list[str] = []
    index = 0
    block_depth = 0
    in_string = False
    while index < len(text):
        pair = text[index : index + 2]
        character = text[index]
        if block_depth:
            if pair == "/-":
                block_depth += 1
                index += 2
            elif pair == "-/":
                block_depth -= 1
                index += 2
            else:
                result.append("\n" if character == "\n" else " ")
                index += 1
        elif in_string:
            if character == "\\" and index + 1 < len(text):
                result.extend("  ")
                index += 2
            elif character == '"':
                in_string = False
                result.append(" ")
                index += 1
            else:
                result.append("\n" if character == "\n" else " ")
                index += 1
        elif pair == "/-":
            block_depth = 1
            result.extend("  ")
            index += 2
        elif pair == "--":
            newline = text.find("\n", index + 2)
            if newline < 0:
                result.extend(" " * (len(text) - index))
                break
            result.extend(" " * (newline - index))
            index = newline
        elif character == '"':
            in_string = True
            result.append(" ")
            index += 1
        else:
            result.append(character)
            index += 1
    if block_depth or in_string:
        raise ValueError("Lean source has an unterminated comment or string")
    return "".join(result)


def validate_source_policy(root: Path, paths: tuple[str, ...], owner: str) -> None:
    """Reject trust-expanding declarations and proof escapes in the exact closure."""
    for relative in paths:
        path = root / relative
        code = lean_code_without_comments_or_strings(path.read_text(encoding="utf-8"))
        match = FORBIDDEN_LEAN_CODE.search(code)
        if match is not None:
            line = code.count("\n", 0, match.start()) + 1
            raise ValueError(
                f"forbidden Lean source policy token {match.group(0)!r} in "
                f"{owner}:{relative}:{line}"
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


def parse_axiom_output(text: str) -> dict[str, list[str]]:
    pattern = re.compile(
        r"'([^']+)' (does not depend on any axioms|depends on axioms: \[(.*?)\])",
        re.DOTALL,
    )
    result: dict[str, list[str]] = {}
    for match in pattern.finditer(text):
        body = match.group(3)
        result[match.group(1)] = (
            []
            if body is None
            else [item.strip() for item in body.replace("\n", " ").split(",")]
        )
    return result


def matches_axiom_audit(
    expected: dict[str, list[str]], actual: dict[str, list[str]]
) -> bool:
    """Compare the audited terminals, ignoring imported-module replay noise."""
    return all(actual.get(terminal) == axioms for terminal, axioms in expected.items())


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


def guarded_lean_result(
    run_dir: Path,
    lean_root: Path,
    pinned_commit: str,
) -> subprocess.CompletedProcess[str]:
    """Validate a canonical guarded-run receipt and return its gate transcript."""
    resolved_run = run_dir.resolve()
    manifest_path = resolved_run / "manifest.json"
    status_path = resolved_run / "status.json"
    if not manifest_path.is_file() or not status_path.is_file():
        raise RuntimeError("guarded Lean run lacks manifest.json or status.json")
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    status = json.loads(status_path.read_text(encoding="utf-8"))
    if status.get("state") != "success" or status.get("exit_code") != 0:
        raise RuntimeError("guarded Lean run did not finish successfully")
    if Path(str(manifest.get("lean_root", ""))).resolve() != lean_root.resolve():
        raise RuntimeError("guarded Lean run used a different Lean root")
    aggregate = manifest.get("aggregate")
    if not isinstance(aggregate, list) or ROOT_GATE not in aggregate:
        raise RuntimeError("guarded Lean run did not validate the Paper I aggregate")
    source = manifest.get("source")
    if not isinstance(source, dict):
        raise RuntimeError("guarded Lean run has no source identity")
    if source.get("git_head") != pinned_commit or source.get("git_dirty") is not False:
        raise RuntimeError("guarded Lean run was not made from the clean pinned package")
    results = status.get("results")
    if not isinstance(results, list) or not any(
        isinstance(item, dict) and item.get("outcome") == "gate-passed"
        for item in results
    ):
        raise RuntimeError("guarded Lean run has no successful aggregate result")
    logs = manifest.get("logs")
    if not isinstance(logs, dict) or ROOT_GATE not in logs:
        raise RuntimeError("guarded Lean run does not identify the gate transcript")
    log_path = Path(str(logs[ROOT_GATE])).resolve()
    if not log_path.is_relative_to(resolved_run) or not log_path.is_file():
        raise RuntimeError("guarded Lean gate transcript is absent or outside its run")
    transcript = log_path.read_text(encoding="utf-8")
    pointer = QUIET_STDOUT_POINTER.search(transcript)
    if pointer is not None:
        transcript_path = Path(pointer.group(1))
        if not transcript_path.is_absolute():
            transcript_path = resolved_run / transcript_path
        transcript_path = transcript_path.resolve()
        if (
            not transcript_path.is_relative_to(resolved_run)
            or not transcript_path.is_file()
        ):
            raise RuntimeError(
                "guarded Lean stdout transcript is absent or outside its run"
            )
        transcript = transcript_path.read_text(encoding="utf-8")
    return subprocess.CompletedProcess(
        args=["guarded-lean-run", str(resolved_run)],
        returncode=0,
        stdout=transcript,
        stderr="",
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
        "--finitegeom-root",
        type=Path,
        required=True,
        help=(
            "checkout of the pinned finitegeom dependency; required to verify the exact "
            "dependency-owned transitive closure"
        ),
    )
    parser.add_argument(
        "--update-output",
        action="store_true",
        help="replace the deterministic release-output certificate after all checks pass",
    )
    parser.add_argument(
        "--guarded-lean-run",
        type=Path,
        help=(
            "canonical successful guarded-run directory for the clean pinned package; "
            "maintainers use this instead of starting a bare Lean build"
        ),
    )
    args = parser.parse_args()
    repositories = {
        "paper": paper_root.resolve(),
        "lean": args.lean_root.resolve(),
    }
    shared = args.finitegeom_root.resolve()
    os.environ["CLEBSCH_LEAN_ROOT"] = str(repositories["lean"])

    # FORMAL_COMPANION.json is the single place this paper names an external formal
    # artifact. The guard rejects a commit restated beside a pinned repository
    # anywhere else, so the manifest's own copies cannot drift away from it. The
    # certificate package is resolved against the Lean root already supplied and
    # required to be that package's newest export; finitegeom is checked the same
    # way when its checkout is given.
    companion = [
        sys.executable,
        str(paper_root / "verification" / "verify_formal_companion.py"),
        "--no-loose-commits",
        f"--resolve=certificate={repositories['lean']}",
        f"--require-current=certificate={repositories['lean']}",
    ]
    companion += [
        f"--resolve=shared-library={shared}",
        f"--require-current=shared-library={shared}",
    ]
    completed = subprocess.run(companion, cwd=paper_root, text=True, capture_output=True)
    if completed.returncode:
        raise ValueError((completed.stdout + completed.stderr).strip())
    print(completed.stdout.strip())
    manifest_path = args.manifest.resolve()
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    if not isinstance(manifest, dict):
        raise ValueError("manifest root must be an object")

    package_closure, finitegeom_closure = project_import_closure(
        repositories["lean"], shared
    )
    print(
        "Paper I project closure: "
        f"{len(package_closure)} package modules, "
        f"{len(finitegeom_closure)} shared modules"
    )
    validate_source_policy(repositories["lean"], package_closure, "lean")
    validate_source_policy(shared, finitegeom_closure, "finitegeom")
    snapshot_paths = {
        "paper": (".",),
        "lean": (*package_closure, AXIOM_AUDIT),
        "finitegeom": finitegeom_closure,
    }
    snapshot_roots = {**repositories, "finitegeom": shared}
    initial = {
        name: git_snapshot(root, snapshot_paths[name])
        for name, root in snapshot_roots.items()
    }
    clean_initial = dict(initial)
    if args.update_output:
        release_output_path = "verification/verify-release-output.json"
        clean_initial["paper"] = "\n".join(
            line
            for line in initial["paper"].splitlines()
            if not line[3:].endswith(release_output_path)
        )
    require_clean(clean_initial)

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
        ["git", "diff", "--quiet", pinned, "--", *package_closure, AXIOM_AUDIT],
        repositories["lean"],
    )
    if lean_identity.returncode != 0:
        raise RuntimeError(
            "the Paper I Lean source paths differ from the pinned commit"
        )
    pinned_dependency = next(
        (
            entry.get("commit")
            for entry in json.loads(
                (paper_root / "FORMAL_COMPANION.json").read_text(encoding="utf-8")
            )["artifacts"]
            if entry.get("role") == "shared-library"
        ),
        None,
    )
    if not pinned_dependency:
        raise RuntimeError("FORMAL_COMPANION.json pins no shared-library commit")
    dependency_identity = run(
        [
            "git",
            "diff",
            "--quiet",
            pinned_dependency,
            "--",
            *finitegeom_closure,
        ],
        shared,
    )
    if dependency_identity.returncode != 0:
        raise RuntimeError(
            "the dependency-owned Paper I closure differs from the pinned commit"
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
        if check_id == "lean-rigidity-trust-gate" and args.guarded_lean_run:
            result = guarded_lean_result(
                args.guarded_lean_run,
                repositories["lean"],
                pinned,
            )
        else:
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
        axiom_audit = check.get("axiom_audit")
        if axiom_audit is not None:
            if not isinstance(axiom_audit, dict):
                raise ValueError(f"{where}.axiom_audit must be an object")
            audit_repository = axiom_audit.get("repository")
            audit_path_value = axiom_audit.get("path")
            if (
                not isinstance(audit_repository, str)
                or audit_repository not in repositories
                or not isinstance(audit_path_value, str)
            ):
                raise ValueError(f"{where}.axiom_audit is invalid")
            audit_path = repositories[audit_repository] / audit_path_value
            expected_axioms = parse_axiom_output(
                audit_path.read_text(encoding="utf-8")
            )
            actual_axioms = parse_axiom_output(result.stdout + "\n" + result.stderr)
            if not expected_axioms or not matches_axiom_audit(
                expected_axioms, actual_axioms
            ):
                raise RuntimeError(
                    f"verification check {check_id!r} axiom output differs "
                    "from its tracked audit"
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
        for name, root in snapshot_roots.items()
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
            "companion_manuscript_sha256": manifest["computational_companion"][
                "manuscript"
            ]["sha256"],
            "companion_pdf_sha256": manifest["computational_companion"]["pdf"][
                "sha256"
            ],
            "companion_trust_sha256": manifest["computational_companion"][
                "trust_ledger"
            ]["sha256"],
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
