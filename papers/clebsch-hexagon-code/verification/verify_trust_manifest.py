#!/usr/bin/env python3
"""Validate the claim-by-claim trust manifest against the manuscript.

The manifest has one final route for each claim.  The verifier checks that
theorem-like statements agree with the deterministic adequacy extraction,
that separately stated prose/table claims occur verbatim in the manuscript,
and that each route supplies the evidence fields needed for that route.
Artifacts are resolved against either the flattened paper repository or a
separately supplied flattened shared Lean repository.

This validator checks completeness and internal consistency of the ledger.
It does not itself elaborate Lean modules or replay finite certificates; the
release verification entry point performs those checks after this validation.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import sys
from pathlib import Path
from typing import NoReturn

from extract_statement_adequacy import extract


SCHEMA = "clebsch-trust-manifest-v1"
ROUTES = {
    "full-trust-lean",
    "exact-replay-certificate",
    "conceptual-cited-inputs",
    "mixed",
}
COMPONENT_ROUTES = ROUTES - {"mixed"}
HEX_64 = re.compile(r"^[0-9a-f]{64}$")
HEX_40 = re.compile(r"^[0-9a-f]{40}$")
SHELL_EXECUTABLES = {
    "bash",
    "dash",
    "fish",
    "powershell",
    "pwsh",
    "sh",
    "zsh",
}


def fail(message: str) -> NoReturn:
    raise ValueError(message)


def require_nonempty_string(value: object, where: str) -> str:
    if not isinstance(value, str) or not value.strip():
        fail(f"{where} must be a nonempty string")
    return value


def require_string_list(value: object, where: str) -> list[str]:
    if not isinstance(value, list) or not value:
        fail(f"{where} must be a nonempty list")
    result: list[str] = []
    for index, item in enumerate(value):
        result.append(require_nonempty_string(item, f"{where}[{index}]"))
    if len(result) != len(set(result)):
        fail(f"{where} contains duplicates")
    return result


def require_sha256(value: object, where: str) -> str:
    digest = require_nonempty_string(value, where)
    if HEX_64.fullmatch(digest) is None:
        fail(f"{where} must be a lowercase SHA-256 digest")
    return digest


def validate_file(
    evidence: object, where: str, repositories: dict[str, Path]
) -> tuple[Path, str]:
    if not isinstance(evidence, dict):
        fail(f"{where} must be an object")
    repository = require_nonempty_string(
        evidence.get("repository"), f"{where}.repository"
    )
    if repository not in repositories:
        fail(f"{where}.repository must be one of {sorted(repositories)}")
    repository_root = repositories[repository].resolve()
    path_text = require_nonempty_string(evidence.get("path"), f"{where}.path")
    relative_path = Path(path_text)
    if relative_path.is_absolute() or ".." in relative_path.parts:
        fail(f"{where}.path must be a safe repository-relative path")
    path = (repository_root / relative_path).resolve()
    if not path.is_relative_to(repository_root.resolve()) or not path.is_file():
        fail(f"{where}.path does not name a repository file")
    expected_digest = require_sha256(evidence.get("sha256"), f"{where}.sha256")
    actual_digest = hashlib.sha256(path.read_bytes()).hexdigest()
    if expected_digest != actual_digest:
        fail(f"{where}.sha256 does not match {path_text}")
    return path, path_text


def validate_checks(
    checks: object, where: str, repositories: dict[str, Path]
) -> None:
    if not isinstance(checks, list) or not checks:
        fail(f"{where} must be a nonempty list")
    seen_ids: set[str] = set()
    for index, check in enumerate(checks):
        check_where = f"{where}[{index}]"
        if not isinstance(check, dict):
            fail(f"{check_where} must be an object")
        check_id = require_nonempty_string(check.get("id"), f"{check_where}.id")
        if check_id in seen_ids:
            fail(f"{where} contains duplicate ID {check_id!r}")
        seen_ids.add(check_id)
        repository = require_nonempty_string(
            check.get("repository"), f"{check_where}.repository"
        )
        if repository not in repositories:
            fail(
                f"{check_where}.repository must be one of "
                f"{sorted(repositories)}"
            )
        repository_root = repositories[repository].resolve()
        cwd_text = require_nonempty_string(check.get("cwd"), f"{check_where}.cwd")
        cwd_relative = Path(cwd_text)
        if cwd_relative.is_absolute() or ".." in cwd_relative.parts:
            fail(f"{check_where}.cwd must be a safe repository-relative path")
        cwd = (repository_root / cwd_relative).resolve()
        if not cwd.is_relative_to(repository_root.resolve()) or not cwd.is_dir():
            fail(f"{check_where}.cwd does not name a repository directory")
        argv = check.get("argv")
        if (
            not isinstance(argv, list)
            or not argv
            or any(not isinstance(item, str) or not item for item in argv)
        ):
            fail(
                f"{check_where}.argv must be a nonempty array of nonempty strings"
            )
        if Path(argv[0]).name in SHELL_EXECUTABLES:
            fail(f"{check_where}.argv may not invoke a shell")
        timeout = check.get("timeout_seconds")
        if (
            not isinstance(timeout, int)
            or isinstance(timeout, bool)
            or not 1 <= timeout <= 86400
        ):
            fail(f"{check_where}.timeout_seconds must be an integer from 1 to 86400")


def validate_lean(
    evidence: object, where: str, repositories: dict[str, Path]
) -> None:
    if not isinstance(evidence, dict):
        fail(f"{where} must be an object")
    validate_file(evidence.get("gate"), f"{where}.gate", repositories)
    audit_path, _ = validate_file(
        evidence.get("audit"), f"{where}.audit", repositories
    )
    require_string_list(evidence.get("terminals"), f"{where}.terminals")
    axioms = evidence.get("axioms")
    if not isinstance(axioms, dict) or not axioms:
        fail(f"{where}.axioms must map every terminal to its exact axiom list")
    terminals = evidence["terminals"]
    if set(axioms) != set(terminals):
        fail(f"{where}.axioms keys must equal {where}.terminals")
    for terminal, terminal_axioms in axioms.items():
        if not isinstance(terminal_axioms, list) or any(
            not isinstance(axiom, str) or not axiom for axiom in terminal_axioms
        ):
            fail(f"{where}.axioms[{terminal!r}] must be a list of axiom names")
    audit_text = audit_path.read_text(encoding="utf-8")
    for terminal in terminals:
        command = f"#print axioms {terminal}"
        if command not in audit_text:
            fail(f"{where}.audit does not contain {command!r}")
    validation = evidence.get("validation")
    if not isinstance(validation, dict):
        fail(f"{where}.validation must be an object")
    require_nonempty_string(
        validation.get("command"), f"{where}.validation.command"
    )
    validate_file(
        validation.get("output"), f"{where}.validation.output", repositories
    )


def validate_computation(
    evidence: object, where: str, repositories: dict[str, Path]
) -> None:
    if not isinstance(evidence, dict):
        fail(f"{where} must be an object")
    require_nonempty_string(evidence.get("checker"), f"{where}.checker")
    require_nonempty_string(
        evidence.get("soundness_bridge"), f"{where}.soundness_bridge"
    )
    require_nonempty_string(evidence.get("coverage"), f"{where}.coverage")
    require_nonempty_string(
        evidence.get("independent_replay"), f"{where}.independent_replay"
    )
    require_nonempty_string(
        evidence.get("residual_trust"), f"{where}.residual_trust"
    )
    artifacts = evidence.get("artifacts")
    if not isinstance(artifacts, list) or not artifacts:
        fail(f"{where}.artifacts must be a nonempty list")
    for index, artifact in enumerate(artifacts):
        artifact_where = f"{where}.artifacts[{index}]"
        validate_file(artifact, artifact_where, repositories)


def validate_citations(evidence: object, where: str) -> None:
    citations = require_string_list(evidence, where)
    for index, citation in enumerate(citations):
        if len(citation.split()) < 4:
            fail(
                f"{where}[{index}] must identify a stable, pinpointed "
                "mathematical input"
            )


def validate_component(
    component: object, where: str, repositories: dict[str, Path]
) -> None:
    if not isinstance(component, dict):
        fail(f"{where} must be an object")
    route = require_nonempty_string(component.get("route"), f"{where}.route")
    if route not in COMPONENT_ROUTES:
        fail(f"{where}.route must be one of {sorted(COMPONENT_ROUTES)}")
    require_nonempty_string(component.get("subclaim"), f"{where}.subclaim")
    validate_route_evidence(route, component, where, repositories)


def validate_route_evidence(
    route: str, row: dict[str, object], where: str, repositories: dict[str, Path]
) -> None:
    if route == "full-trust-lean":
        validate_lean(row.get("lean"), f"{where}.lean", repositories)
    elif route == "exact-replay-certificate":
        validate_computation(
            row.get("computation"), f"{where}.computation", repositories
        )
    elif route == "conceptual-cited-inputs":
        validate_citations(row.get("cited_inputs"), f"{where}.cited_inputs")
        require_nonempty_string(
            row.get("unconditional_remainder"), f"{where}.unconditional_remainder"
        )


def validate_claim(
    claim: object,
    index: int,
    extracted: dict[str, dict[str, object]],
    manuscript_text: str,
    repositories: dict[str, Path],
) -> str:
    where = f"claims[{index}]"
    if not isinstance(claim, dict):
        fail(f"{where} must be an object")
    claim_id = require_nonempty_string(claim.get("id"), f"{where}.id")
    require_nonempty_string(claim.get("paper_location"), f"{where}.paper_location")
    require_nonempty_string(claim.get("trust_boundary"), f"{where}.trust_boundary")

    source = claim.get("source")
    if not isinstance(source, dict):
        fail(f"{where}.source must be an object")
    source_kind = source.get("kind")
    if source_kind == "theorem-environment":
        key = require_nonempty_string(source.get("claim_key"), f"{where}.source.claim_key")
        digest = require_sha256(source.get("sha256"), f"{where}.source.sha256")
        if key not in extracted:
            fail(f"{where}.source.claim_key {key!r} is not in the manuscript extraction")
        if extracted[key]["sha256"] != digest:
            fail(f"{where}.source.sha256 does not match manuscript statement {key!r}")
    elif source_kind == "verbatim":
        tex = require_nonempty_string(source.get("tex"), f"{where}.source.tex")
        digest = require_sha256(source.get("sha256"), f"{where}.source.sha256")
        actual_digest = hashlib.sha256(tex.encode("utf-8")).hexdigest()
        if digest != actual_digest:
            fail(f"{where}.source.sha256 does not hash {where}.source.tex")
        occurrences = manuscript_text.count(tex)
        if occurrences != 1:
            fail(f"{where}.source.tex must occur exactly once; found {occurrences}")
    else:
        fail(
            f"{where}.source.kind must be 'theorem-environment' or 'verbatim'"
        )

    route = require_nonempty_string(claim.get("route"), f"{where}.route")
    if route not in ROUTES:
        fail(f"{where}.route must be one of {sorted(ROUTES)}")
    if route == "mixed":
        components = claim.get("components")
        if not isinstance(components, list) or len(components) < 2:
            fail(f"{where}.components must contain at least two route components")
        for component_index, component in enumerate(components):
            validate_component(
                component,
                f"{where}.components[{component_index}]",
                repositories,
            )
    else:
        validate_route_evidence(route, claim, where, repositories)
    return claim_id


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Validate the Clebsch claim trust manifest."
    )
    paper_root = Path(__file__).resolve().parents[1]
    parser.add_argument(
        "manifest",
        nargs="?",
        type=Path,
        default=paper_root / "verification" / "trust_manifest.json",
    )
    parser.add_argument(
        "--manuscript",
        type=Path,
        default=paper_root / "clebsch_hexagon_code.tex",
    )
    parser.add_argument(
        "--lean-root",
        type=Path,
        required=True,
        help="root of the separately checked-out, flattened shared Lean repository",
    )
    args = parser.parse_args()

    manifest_path = args.manifest.resolve()
    manuscript_path = args.manuscript.resolve()
    repositories = {
        "paper": paper_root.resolve(),
        "lean": args.lean_root.resolve(),
    }
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    if not isinstance(manifest, dict):
        fail("manifest root must be an object")
    if manifest.get("schema") != SCHEMA:
        fail(f"manifest.schema must equal {SCHEMA!r}")
    lean_repository = manifest.get("lean_repository")
    if not isinstance(lean_repository, dict):
        fail("manifest.lean_repository must be an object")
    require_nonempty_string(
        lean_repository.get("url"), "manifest.lean_repository.url"
    )
    pinned_commit = require_nonempty_string(
        lean_repository.get("commit"), "manifest.lean_repository.commit"
    )
    if HEX_40.fullmatch(pinned_commit) is None:
        fail("manifest.lean_repository.commit must be a full lowercase Git commit")
    verify_all = manifest.get("verify_all")
    if not isinstance(verify_all, dict):
        fail("manifest.verify_all must be an object")
    require_nonempty_string(verify_all.get("command"), "manifest.verify_all.command")
    validate_file(
        verify_all.get("entry_point"),
        "manifest.verify_all.entry_point",
        repositories,
    )
    validate_file(
        verify_all.get("output"), "manifest.verify_all.output", repositories
    )
    validate_checks(
        verify_all.get("checks"), "manifest.verify_all.checks", repositories
    )

    manuscript_bytes = manuscript_path.read_bytes()
    manuscript_text = manuscript_bytes.decode("utf-8")
    expected_manuscript_hash = require_sha256(
        manifest.get("manuscript_sha256"), "manifest.manuscript_sha256"
    )
    actual_manuscript_hash = hashlib.sha256(manuscript_bytes).hexdigest()
    if expected_manuscript_hash != actual_manuscript_hash:
        fail("manifest.manuscript_sha256 does not match the manuscript")

    extracted_rows = [statement.as_json() for statement in extract(manuscript_path)]
    extracted = {str(row["claim_key"]): row for row in extracted_rows}
    claims = manifest.get("claims")
    if not isinstance(claims, list) or not claims:
        fail("manifest.claims must be a nonempty list")
    claim_ids = [
        validate_claim(
            claim, index, extracted, manuscript_text, repositories
        )
        for index, claim in enumerate(claims)
    ]
    if len(claim_ids) != len(set(claim_ids)):
        fail("manifest claim IDs must be unique")

    covered_theorem_keys = {
        claim["source"]["claim_key"]
        for claim in claims
        if isinstance(claim, dict)
        and isinstance(claim.get("source"), dict)
        and claim["source"].get("kind") == "theorem-environment"
    }
    missing = sorted(set(extracted) - covered_theorem_keys)
    if missing:
        fail(
            "manifest omits theorem-like manuscript statements: "
            + ", ".join(missing)
        )

    print(
        json.dumps(
            {
                "claim_count": len(claims),
                "manuscript_sha256": actual_manuscript_hash,
                "schema": SCHEMA,
                "statement_claim_count": len(extracted),
            },
            sort_keys=True,
        )
    )
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (OSError, UnicodeError, json.JSONDecodeError, ValueError) as error:
        print(f"trust-manifest verification failed: {error}", file=sys.stderr)
        raise SystemExit(1)
