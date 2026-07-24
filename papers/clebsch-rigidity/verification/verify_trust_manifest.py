#!/usr/bin/env python3
"""Validate the Clebsch rigidity trust manifest and every pinned artifact."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
from pathlib import Path
from typing import NoReturn


SCHEMA = "clebsch-rigidity-trust-manifest-v1"
ROWS = [2, *range(11, 27), 29, 58]
ROUTES = {
    "conceptual-cited-inputs",
    "exact-replay",
    "kernel-checked-lean",
    "mixed",
}
SHELLS = {"bash", "dash", "fish", "powershell", "pwsh", "sh", "zsh"}
FORBIDDEN_SCOPE = {
    "factorization",
    "holonomy",
    "mathieu",
    "passage",
    "reflection",
    "singular",
    "torsor",
}


def fail(message: str) -> NoReturn:
    raise ValueError(message)


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def require_string(value: object, where: str) -> str:
    if not isinstance(value, str) or not value:
        fail(f"{where} must be a nonempty string")
    return value


def require_sha256(value: object, where: str) -> str:
    text = require_string(value, where)
    if re.fullmatch(r"[0-9a-f]{64}", text) is None:
        fail(f"{where} must be a lowercase SHA-256 digest")
    return text


def validate_file(
    value: object,
    repositories: dict[str, Path],
    where: str,
) -> Path:
    if not isinstance(value, dict):
        fail(f"{where} must be an object")
    repository = require_string(value.get("repository"), f"{where}.repository")
    if repository not in repositories:
        fail(f"{where}.repository must be one of {sorted(repositories)}")
    relative = Path(require_string(value.get("path"), f"{where}.path"))
    if relative.is_absolute() or ".." in relative.parts:
        fail(f"{where}.path must be repository-relative")
    path = repositories[repository] / relative
    expected = require_sha256(value.get("sha256"), f"{where}.sha256")
    if not path.is_file():
        fail(f"{where} is missing: {path}")
    if digest(path) != expected:
        fail(f"{where} hash mismatch: {path}")
    return path


def parse_audit(path: Path) -> dict[str, list[str]]:
    text = path.read_text(encoding="utf-8")
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


def validate_lean(
    value: object,
    repositories: dict[str, Path],
    audit_cache: dict[Path, dict[str, list[str]]],
    where: str,
) -> None:
    if not isinstance(value, dict):
        fail(f"{where} must be an object")
    gate = validate_file(value.get("gate"), repositories, f"{where}.gate")
    audit_path = validate_file(value.get("audit"), repositories, f"{where}.audit")
    if gate.name != "ClebschRigidityTrust.lean":
        fail(f"{where}.gate is not the Paper I aggregate gate")
    audit = audit_cache.setdefault(audit_path, parse_audit(audit_path))
    terminals = value.get("terminals")
    if (
        not isinstance(terminals, list)
        or not terminals
        or any(not isinstance(item, str) or not item for item in terminals)
        or len(terminals) != len(set(terminals))
    ):
        fail(f"{where}.terminals must be unique nonempty strings")
    axioms = value.get("axioms")
    if not isinstance(axioms, dict) or set(axioms) != set(terminals):
        fail(f"{where}.axioms keys must equal its terminals")
    for terminal in terminals:
        if terminal not in audit:
            fail(f"{where} terminal absent from axiom audit: {terminal}")
        if axioms[terminal] != audit[terminal]:
            fail(f"{where} axiom mismatch for {terminal}")
    validation = value.get("validation")
    if not isinstance(validation, dict):
        fail(f"{where}.validation must be an object")
    command = require_string(validation.get("command"), f"{where}.validation.command")
    if "guarded-lean" not in command or "ClebschRigidityTrust.lean" not in command:
        fail(f"{where}.validation.command does not run the Paper I gate")


def validate_computation(
    value: object,
    repositories: dict[str, Path],
    where: str,
) -> None:
    if not isinstance(value, dict):
        fail(f"{where} must be an object")
    for field in (
        "checker",
        "coverage",
        "soundness_bridge",
        "independent_replay",
        "residual_trust",
    ):
        require_string(value.get(field), f"{where}.{field}")
    artifacts = value.get("artifacts")
    if not isinstance(artifacts, list) or not artifacts:
        fail(f"{where}.artifacts must be nonempty")
    for index, artifact in enumerate(artifacts):
        path = validate_file(
            artifact, repositories, f"{where}.artifacts[{index}]"
        )
        if path.suffix != ".py":
            fail(f"{where}.artifacts[{index}] must be an exact Python checker")


def validate_component(
    value: object,
    repositories: dict[str, Path],
    audit_cache: dict[Path, dict[str, list[str]]],
    where: str,
) -> None:
    if not isinstance(value, dict):
        fail(f"{where} must be an object")
    route = value.get("route")
    if route not in ROUTES - {"mixed"}:
        fail(f"{where}.route is invalid")
    if route == "kernel-checked-lean":
        validate_lean(value.get("lean"), repositories, audit_cache, f"{where}.lean")
    elif route == "exact-replay":
        validate_computation(
            value.get("computation"), repositories, f"{where}.computation"
        )
    else:
        cited = value.get("cited_inputs")
        if (
            not isinstance(cited, list)
            or not cited
            or any(not isinstance(item, str) or not item for item in cited)
        ):
            fail(f"{where}.cited_inputs must be nonempty strings")
        require_string(
            value.get("unconditional_remainder"),
            f"{where}.unconditional_remainder",
        )


def validate_claim(
    value: object,
    identity: dict[int, dict[str, object]],
    repositories: dict[str, Path],
    audit_cache: dict[Path, dict[str, list[str]]],
    where: str,
) -> None:
    if not isinstance(value, dict):
        fail(f"{where} must be an object")
    row = value.get("row")
    if not isinstance(row, int) or isinstance(row, bool) or row not in identity:
        fail(f"{where}.row is invalid")
    require_string(value.get("id"), f"{where}.id")
    require_string(value.get("paper_location"), f"{where}.paper_location")
    require_string(value.get("trust_boundary"), f"{where}.trust_boundary")
    source = value.get("source")
    if not isinstance(source, dict):
        fail(f"{where}.source must be an object")
    expected = identity[row]
    if source.get("kind") != expected.get("kind"):
        fail(f"{where}.source.kind disagrees with statement identity")
    if source.get("id") != expected.get("id"):
        fail(f"{where}.source.id disagrees with statement identity")
    if source.get("sha256") != expected.get("sha256"):
        fail(f"{where}.source.sha256 disagrees with statement identity")
    route = value.get("route")
    if route not in ROUTES:
        fail(f"{where}.route is invalid")
    if route == "mixed":
        components = value.get("components")
        if not isinstance(components, list) or len(components) < 2:
            fail(f"{where}.components must contain at least two routes")
        for index, component in enumerate(components):
            validate_component(
                component,
                repositories,
                audit_cache,
                f"{where}.components[{index}]",
            )
    else:
        validate_component(value, repositories, audit_cache, where)


def validate_checks(
    value: object,
    repositories: dict[str, Path],
    where: str,
) -> None:
    if not isinstance(value, list) or not value:
        fail(f"{where} must be a nonempty array")
    seen: set[str] = set()
    for index, check in enumerate(value):
        item = f"{where}[{index}]"
        if not isinstance(check, dict):
            fail(f"{item} must be an object")
        check_id = require_string(check.get("id"), f"{item}.id")
        if check_id in seen:
            fail(f"duplicate check ID {check_id}")
        seen.add(check_id)
        repository = require_string(check.get("repository"), f"{item}.repository")
        if repository not in repositories:
            fail(f"{item}.repository is invalid")
        cwd = Path(require_string(check.get("cwd"), f"{item}.cwd"))
        if cwd.is_absolute() or ".." in cwd.parts:
            fail(f"{item}.cwd must be repository-relative")
        if not (repositories[repository] / cwd).is_dir():
            fail(f"{item}.cwd does not exist")
        argv = check.get("argv")
        if (
            not isinstance(argv, list)
            or not argv
            or any(not isinstance(arg, str) or not arg for arg in argv)
        ):
            fail(f"{item}.argv must contain nonempty strings")
        if Path(argv[0]).name in SHELLS:
            fail(f"{item}.argv may not invoke a shell")
        timeout = check.get("timeout_seconds")
        if (
            not isinstance(timeout, int)
            or isinstance(timeout, bool)
            or not 1 <= timeout <= 3600
        ):
            fail(f"{item}.timeout_seconds is invalid")
        if check_id.startswith("check-"):
            require_sha256(check.get("stdout_sha256"), f"{item}.stdout_sha256")
            for field in ("stdout_bytes", "stdout_lines"):
                field_value = check.get(field)
                if (
                    not isinstance(field_value, int)
                    or isinstance(field_value, bool)
                    or field_value < 1
                ):
                    fail(f"{item}.{field} must be a positive integer")
    if len(value) != 15:
        fail(f"{where} must contain exactly fifteen admitted checks")


def main() -> int:
    paper_root = Path(__file__).resolve().parents[1]
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "manifest",
        nargs="?",
        type=Path,
        default=paper_root / "verification" / "trust_manifest.json",
    )
    parser.add_argument(
        "--manuscript",
        type=Path,
        default=paper_root / "clebsch_rigidity.tex",
    )
    parser.add_argument("--lean-root", type=Path, required=True)
    args = parser.parse_args()
    repositories = {
        "paper": paper_root.resolve(),
        "lean": args.lean_root.resolve(),
    }
    manifest = json.loads(args.manifest.read_text(encoding="utf-8"))
    if not isinstance(manifest, dict) or manifest.get("schema") != SCHEMA:
        fail("manifest schema is invalid")
    rendered = json.dumps(manifest, sort_keys=True).lower()
    for word in FORBIDDEN_SCOPE:
        if re.search(rf"\b{re.escape(word)}\b", rendered):
            fail(f"manifest admits out-of-scope route: {word}")
    manuscript = args.manuscript.resolve()
    if manifest.get("manuscript_sha256") != digest(manuscript):
        fail("manuscript hash mismatch")
    identity_path = validate_file(
        manifest.get("statement_identity"),
        repositories,
        "manifest.statement_identity",
    )
    identity_payload = json.loads(identity_path.read_text(encoding="utf-8"))
    if identity_payload.get("source_sha256") != digest(manuscript):
        fail("statement identity source hash mismatch")
    identity_claims = identity_payload.get("claims")
    if not isinstance(identity_claims, list):
        fail("statement identity claims must be an array")
    identity = {claim["row"]: claim for claim in identity_claims}
    if list(identity) != ROWS:
        fail("statement identity rows are not the exact nineteen-row map")
    claims = manifest.get("claims")
    if not isinstance(claims, list) or [claim.get("row") for claim in claims] != ROWS:
        fail("manifest claims are not the exact nineteen-row map")
    audit_cache: dict[Path, dict[str, list[str]]] = {}
    for index, claim_value in enumerate(claims):
        validate_claim(
            claim_value,
            identity,
            repositories,
            audit_cache,
            f"manifest.claims[{index}]",
        )
    environment = manifest.get("reproducibility_environment")
    if not isinstance(environment, dict):
        fail("manifest.reproducibility_environment must be an object")
    validate_file(environment.get("flake"), repositories, "manifest.environment.flake")
    validate_file(environment.get("lock"), repositories, "manifest.environment.lock")
    verify_all = manifest.get("verify_all")
    if not isinstance(verify_all, dict):
        fail("manifest.verify_all must be an object")
    command = require_string(verify_all.get("command"), "manifest.verify_all.command")
    if "verification/verify_release.py" not in command or "nix develop" not in command:
        fail("manifest.verify_all.command is not the clean release entry point")
    validate_file(verify_all.get("entry_point"), repositories, "manifest.verify_all.entry_point")
    validate_file(verify_all.get("output"), repositories, "manifest.verify_all.output")
    certificate = verify_all.get("checker_output_certificate")
    if not isinstance(certificate, dict):
        fail("manifest.verify_all.checker_output_certificate must be an object")
    validate_file(
        certificate.get("generator"),
        repositories,
        "manifest.verify_all.checker_output_certificate.generator",
    )
    validate_file(
        certificate.get("output"),
        repositories,
        "manifest.verify_all.checker_output_certificate.output",
    )
    tools = verify_all.get("verification_tools")
    if not isinstance(tools, list) or len(tools) != 5:
        fail("manifest.verify_all.verification_tools must contain five files")
    for index, tool in enumerate(tools):
        validate_file(
            tool,
            repositories,
            f"manifest.verify_all.verification_tools[{index}]",
        )
    validate_checks(verify_all.get("checks"), repositories, "manifest.verify_all.checks")
    lean_repository = manifest.get("lean_repository")
    if not isinstance(lean_repository, dict):
        fail("manifest.lean_repository must be an object")
    require_string(lean_repository.get("url"), "manifest.lean_repository.url")
    require_string(lean_repository.get("commit"), "manifest.lean_repository.commit")
    print("Clebsch rigidity trust manifest: valid (19 claims, 15 checks)")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (OSError, UnicodeError, json.JSONDecodeError, ValueError) as error:
        print(f"trust-manifest validation failed: {error}")
        raise SystemExit(1)
