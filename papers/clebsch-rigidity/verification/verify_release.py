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
FINITEGEOM_GATE = "RelativeConicArcs.Gates.ClebschRigidityTrust"
CERTIFICATE_GATE = "TavisRuddFiniteGeom.Certificates.Q11"
BRIDGE_GATE = (
    "TavisRuddFiniteGeom.Papers.ClebschRigidity.CertificateCompatibility"
)
PROJECT_PREFIXES = ("RelativeConicArcs.", "ProjectiveCap.", "CapGame.")
FINITEGEOM_AUDIT = "trust/ClebschRigidityAxiomAudit.lean"
CERTIFICATE_MANIFEST = "MANIFEST.json"
CERTIFICATE_TRUST_FACT = "TRUST_FACT.json"
CERTIFICATE_AXIOM_AUDIT = "verification/axiom-audit.txt"
BRIDGE_MANIFEST = "MANIFEST.json"
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
    roots: dict[str, Path],
    root_module: str,
) -> dict[str, tuple[str, ...]]:
    """Resolve a project-owned import closure across the three formal roots."""
    pending = [root_module]
    seen: set[str] = set()
    paths: dict[str, set[str]] = {name: set() for name in roots}
    while pending:
        module = pending.pop()
        if module in seen:
            continue
        seen.add(module)
        relative = module_path(module)
        matches = [
            (name, root / relative)
            for name, root in roots.items()
            if (root / relative).is_file()
        ]
        if len(matches) > 1:
            owners = ", ".join(name for name, _ in matches)
            raise RuntimeError(f"project import has multiple owners ({owners}): {module}")
        if not matches:
            if module.startswith((*PROJECT_PREFIXES, "TavisRuddFiniteGeom.")):
                raise RuntimeError(f"project import is absent from all formal roots: {module}")
            continue
        owner, source = matches[0]
        paths[owner].add(str(relative))
        source_text = lean_code_without_comments_or_strings(
            source.read_text(encoding="utf-8")
        )
        for line in source_text.splitlines():
            match = re.match(r"^\s*(?:public\s+)?import\s+(.+?)\s*$", line)
            if match is not None:
                pending.extend(match.group(1).split())
    return {name: tuple(sorted(owned)) for name, owned in paths.items()}


def merge_closures(
    roots: dict[str, Path], root_modules: tuple[str, ...]
) -> dict[str, tuple[str, ...]]:
    merged: dict[str, set[str]] = {name: set() for name in roots}
    for module in root_modules:
        closure = project_import_closure(roots, module)
        for name, paths in closure.items():
            merged[name].update(paths)
    return {name: tuple(sorted(paths)) for name, paths in merged.items()}


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


def guarded_finitegeom_result(
    run_dir: Path,
    finitegeom_root: Path,
    pinned_commit: str,
) -> tuple[subprocess.CompletedProcess[str], Path]:
    """Validate the human-gate receipt and return its transcript and path."""
    resolved_run = run_dir.resolve()
    manifest_path = resolved_run / "manifest.json"
    status_path = resolved_run / "status.json"
    if not manifest_path.is_file() or not status_path.is_file():
        raise RuntimeError("guarded Lean run lacks manifest.json or status.json")
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    status = json.loads(status_path.read_text(encoding="utf-8"))
    if status.get("state") != "success" or status.get("exit_code") != 0:
        raise RuntimeError("guarded Lean run did not finish successfully")
    if Path(str(manifest.get("lean_root", ""))).resolve() != finitegeom_root.resolve():
        raise RuntimeError("guarded finitegeom run used a different root")
    aggregate = manifest.get("aggregate")
    if not isinstance(aggregate, list) or FINITEGEOM_GATE not in aggregate:
        raise RuntimeError("guarded run did not validate the Paper I human gate")
    source = manifest.get("source")
    if not isinstance(source, dict):
        raise RuntimeError("guarded finitegeom run has no source identity")
    if source.get("git_head") != pinned_commit or source.get("git_dirty") is not False:
        raise RuntimeError("guarded run was not made from the clean pinned finitegeom revision")
    results = status.get("results")
    if not isinstance(results, list) or not any(
        isinstance(item, dict) and item.get("outcome") == "gate-passed"
        for item in results
    ):
        raise RuntimeError("guarded finitegeom run has no successful gate result")
    logs = manifest.get("logs")
    if not isinstance(logs, dict) or FINITEGEOM_GATE not in logs:
        raise RuntimeError("guarded finitegeom run does not identify the gate transcript")
    log_path = Path(str(logs[FINITEGEOM_GATE])).resolve()
    if not log_path.is_file():
        target_result = next(
            (
                item
                for item in results
                if isinstance(item, dict)
                and item.get("target") == FINITEGEOM_GATE
                and item.get("outcome") in {"skipped-current", "built"}
                and isinstance(item.get("log"), str)
            ),
            None,
        )
        if target_result is not None:
            log_path = Path(str(target_result["log"])).resolve()
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
    ), transcript_path if pointer is not None else log_path


def formal_artifacts(paper_root: Path) -> dict[str, dict[str, object]]:
    payload = json.loads(
        (paper_root / "FORMAL_COMPANION.json").read_text(encoding="utf-8")
    )
    artifacts = payload.get("artifacts")
    if not isinstance(artifacts, list):
        raise ValueError("FORMAL_COMPANION.json has no artifacts array")
    result = {
        entry.get("role"): entry
        for entry in artifacts
        if isinstance(entry, dict) and isinstance(entry.get("role"), str)
    }
    expected = {"certificate", "shared-library", "paper-bridge"}
    if set(result) != expected:
        raise ValueError("FORMAL_COMPANION.json does not name the three formal roles")
    return result


def require_pinned_checkout(
    root: Path, commit: object, paths: tuple[str, ...], label: str
) -> None:
    if not isinstance(commit, str) or re.fullmatch(r"[0-9a-f]{40}", commit) is None:
        raise ValueError(f"{label} pin is not a full Git commit")
    head = run(["git", "rev-parse", "HEAD"], root)
    if head.returncode != 0 or head.stdout.strip() != commit:
        raise RuntimeError(f"{label} checkout is not at its pinned commit")
    identity = run(["git", "diff", "--quiet", commit, "--", *paths], root)
    if identity.returncode != 0:
        raise RuntimeError(f"{label} release paths differ from the pinned commit")


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def validate_sealed_certificate_contract(
    certificate_root: Path,
    finitegeom_root: Path,
    bridge_root: Path,
    certificate_pack: Path,
    artifacts: dict[str, dict[str, object]],
) -> None:
    certificate_manifest_path = certificate_root / CERTIFICATE_MANIFEST
    trust_fact_path = certificate_root / CERTIFICATE_TRUST_FACT
    bridge_manifest_path = bridge_root / BRIDGE_MANIFEST
    certificate_manifest = json.loads(certificate_manifest_path.read_text(encoding="utf-8"))
    trust_fact = json.loads(trust_fact_path.read_text(encoding="utf-8"))
    bridge_manifest = json.loads(bridge_manifest_path.read_text(encoding="utf-8"))
    if certificate_manifest.get("roots") != [CERTIFICATE_GATE]:
        raise ValueError("certificate manifest has the wrong aggregate root")
    if trust_fact.get("gate") != CERTIFICATE_GATE:
        raise ValueError("certificate trust fact has the wrong gate")
    if trust_fact.get("manifest_sha256") != sha256(certificate_manifest_path):
        raise ValueError("certificate trust fact does not seal the certificate manifest")
    evidence = trust_fact.get("evidence")
    if not isinstance(evidence, dict):
        raise ValueError("certificate trust fact has no evidence object")
    axiom_log = evidence.get("axiom_log")
    if not isinstance(axiom_log, str):
        raise ValueError("certificate trust fact has no axiom-log path")
    axiom_path = certificate_root / axiom_log
    if not axiom_path.is_file() or evidence.get("axiom_log_sha256") != sha256(axiom_path):
        raise ValueError("certificate trust fact axiom evidence is absent or stale")
    if bridge_manifest.get("roots") != [BRIDGE_GATE]:
        raise ValueError("paper bridge manifest has the wrong root")
    dependencies = bridge_manifest.get("dependencies")
    expected_dependencies = {
        "finitegeom": artifacts["shared-library"].get("commit"),
        "finitegeom-clebsch-q11-certificates": artifacts["certificate"].get("commit"),
    }
    if dependencies != expected_dependencies:
        raise ValueError("paper bridge dependencies differ from FORMAL_COMPANION.json")
    if not certificate_pack.is_file():
        raise ValueError("certificate pack is absent")
    if bridge_manifest.get("certificate_cache_sha256") != sha256(certificate_pack):
        raise ValueError("certificate pack differs from the bridge's sealed cache digest")
    flake = (bridge_root / "flake.nix").read_text(encoding="utf-8")
    required_fragments = (
        ".lake/build/lib/lean/TavisRuddFiniteGeom/Certificates/Q11.olean",
        ".lake/build/lib/lean/TavisRuddFiniteGeom/Certificates/Q11.trace",
        'cd "$certificate_root" && lake unpack',
        "sha256sum --check --status",
        "lake env lean TavisRuddFiniteGeom/Papers/ClebschRigidity/CertificateCompatibility.lean",
    )
    if any(fragment not in flake for fragment in required_fragments):
        raise ValueError("paper bridge verifier omits a sealed compatibility check")
    for line in flake.splitlines():
        if "lake build" in line and (
            "certificate_root" in line
            or "TavisRuddFiniteGeom.Certificates" in line
        ):
            raise ValueError("paper bridge verifier can schedule a certificate build")


def manifest_axioms(
    manifest: dict[str, object], repository: str
) -> dict[str, list[str]]:
    """Collect the axiom map claimed by one formal repository."""
    claims = manifest.get("claims")
    if not isinstance(claims, list):
        raise ValueError("manifest claims must be an array")
    result: dict[str, list[str]] = {}
    for claim in claims:
        if not isinstance(claim, dict):
            continue
        components = [claim, *claim.get("components", [])]
        for component in components:
            if not isinstance(component, dict):
                continue
            lean = component.get("lean")
            if not isinstance(lean, dict) or lean.get("repository") != repository:
                continue
            axioms = lean.get("axioms")
            if not isinstance(axioms, dict):
                raise ValueError(f"{repository} Lean component has no axiom map")
            for terminal, values in axioms.items():
                if not isinstance(terminal, str) or not isinstance(values, list):
                    raise ValueError(f"{repository} Lean component has an invalid axiom map")
                if terminal in result and result[terminal] != values:
                    raise ValueError(f"conflicting axiom claims for {terminal}")
                result[terminal] = values
    return result


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    paper_root = Path(__file__).resolve().parents[1]
    parser.add_argument(
        "manifest",
        nargs="?",
        type=Path,
        default=paper_root / "verification" / "trust_manifest.json",
    )
    parser.add_argument("--certificate-root", type=Path, required=True)
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
        "--bridge-root",
        type=Path,
        required=True,
        help="checkout of the pinned paper compatibility bridge",
    )
    parser.add_argument(
        "--certificate-pack",
        type=Path,
        required=True,
        help="sealed Q11 Lake pack required by the paper bridge verifier",
    )
    parser.add_argument(
        "--update-output",
        action="store_true",
        help="replace the deterministic release-output certificate after all checks pass",
    )
    parser.add_argument(
        "--guarded-finitegeom-run",
        type=Path,
        required=True,
        help="successful guarded receipt for the pinned finitegeom human gate",
    )
    args = parser.parse_args()
    repositories = {
        "paper": paper_root.resolve(),
        "certificate": args.certificate_root.resolve(),
        "finitegeom": args.finitegeom_root.resolve(),
        "bridge": args.bridge_root.resolve(),
    }
    certificate_pack = args.certificate_pack.resolve()

    # FORMAL_COMPANION.json is the single place this paper names an external formal
    # artifact. Resolve every role independently so no combined repository can
    # silently replace the sealed certificate, human library, or compatibility
    # theorem.
    companion = [
        sys.executable,
        str(paper_root / "verification" / "verify_formal_companion.py"),
        "--no-loose-commits",
    ]
    for role, repository in (
        ("certificate", "certificate"),
        ("shared-library", "finitegeom"),
        ("paper-bridge", "bridge"),
    ):
        companion.extend(
            (
                f"--resolve={role}={repositories[repository]}",
                f"--require-current={role}={repositories[repository]}",
            )
        )
    completed = subprocess.run(companion, cwd=paper_root, text=True, capture_output=True)
    if completed.returncode:
        raise ValueError((completed.stdout + completed.stderr).strip())
    print(completed.stdout.strip())
    manifest_path = args.manifest.resolve()
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    if not isinstance(manifest, dict):
        raise ValueError("manifest root must be an object")

    artifacts = formal_artifacts(paper_root)
    formal_roots = {
        name: repositories[name]
        for name in ("certificate", "finitegeom", "bridge")
    }
    closures = merge_closures(
        formal_roots, (CERTIFICATE_GATE, FINITEGEOM_GATE, BRIDGE_GATE)
    )
    print(
        "Paper I project closure: "
        + ", ".join(f"{len(closures[name])} {name} modules" for name in formal_roots)
    )
    for name in formal_roots:
        validate_source_policy(repositories[name], closures[name], name)
    snapshot_paths = {
        "paper": (".",),
        "certificate": (
            *closures["certificate"],
            CERTIFICATE_MANIFEST,
            CERTIFICATE_TRUST_FACT,
            CERTIFICATE_AXIOM_AUDIT,
            "evidence/gate-axioms.log",
        ),
        "finitegeom": (
            *closures["finitegeom"],
            FINITEGEOM_AUDIT,
            "trust/manifests/clebsch_rigidity.json",
        ),
        "bridge": (*closures["bridge"], BRIDGE_MANIFEST, "flake.nix"),
    }
    snapshot_roots = repositories
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

    for role, repository in (
        ("certificate", "certificate"),
        ("shared-library", "finitegeom"),
        ("paper-bridge", "bridge"),
    ):
        require_pinned_checkout(
            repositories[repository],
            artifacts[role].get("commit"),
            snapshot_paths[repository],
            repository,
        )
    validate_sealed_certificate_contract(
        repositories["certificate"],
        repositories["finitegeom"],
        repositories["bridge"],
        certificate_pack,
        artifacts,
    )
    guarded_finitegeom, finitegeom_transcript = guarded_finitegeom_result(
        args.guarded_finitegeom_run,
        repositories["finitegeom"],
        str(artifacts["shared-library"]["commit"]),
    )
    os.environ["CLEBSCH_CERTIFICATE_ROOT"] = str(repositories["certificate"])
    os.environ["CLEBSCH_FINITEGEOM_ROOT"] = str(repositories["finitegeom"])
    os.environ["CLEBSCH_BRIDGE_ROOT"] = str(repositories["bridge"])
    os.environ["CLEBSCH_FINITEGEOM_AXIOM_AUDIT"] = str(finitegeom_transcript)

    validator_command = [
        sys.executable,
        str(paper_root / "verification" / "verify_trust_manifest.py"),
        str(manifest_path),
        "--manuscript",
        str(paper_root / "clebsch_rigidity.tex"),
        "--certificate-root",
        str(repositories["certificate"]),
        "--finitegeom-root",
        str(repositories["finitegeom"]),
        "--bridge-root",
        str(repositories["bridge"]),
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
        if check_id == "lean-finitegeom-trust-gate":
            result = guarded_finitegeom
        elif check_id == "lean-certificate-compatibility":
            try:
                result = run(
                    [
                        "nix",
                        "run",
                        ".#verify",
                        "--",
                        str(certificate_pack),
                        str(repositories["finitegeom"]),
                        str(repositories["certificate"]),
                    ],
                    repositories["bridge"],
                    timeout=timeout,
                )
            except subprocess.TimeoutExpired as error:
                detail = bounded(
                    error.stderr if isinstance(error.stderr, str) else ""
                )
                raise RuntimeError(
                    f"verification check {check_id!r} timed out after "
                    f"{timeout} seconds:\n{detail}"
                ) from error
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
            if check_id != "lean-finitegeom-trust-gate":
                raise RuntimeError(f"verification check {check_id!r} has an axiom audit")
            expected_axioms = manifest_axioms(manifest, "finitegeom")
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
            "formal_companion_sha256": manifest["formal_companion"]["sha256"],
            "manuscript_pdf_sha256": manifest["manuscript_pdf"]["sha256"],
            "manuscript_sha256": manifest["manuscript_sha256"],
            "release_surface_sha256": release_surface_sha256(manifest),
            "statement_identity_sha256": manifest["statement_identity"]["sha256"],
        },
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
