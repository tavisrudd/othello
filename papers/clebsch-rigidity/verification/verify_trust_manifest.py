#!/usr/bin/env python3
"""Validate the Clebsch rigidity trust manifest and every pinned artifact."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
from pathlib import Path
from typing import NoReturn


SCHEMA = "clebsch-rigidity-trust-manifest-v2"
FORMAL_ROLES = {"certificate", "shared-library", "paper-bridge"}
ALLOWED_AXIOMS = {"Classical.choice", "Quot.sound", "propext"}
EXPECTED_ARTIFACTS = {
    "certificate": (
        "https://github.com/tavisrudd/finitegeom-clebsch-q11-certificates",
        "TavisRuddFiniteGeom.Certificates.Q11",
        "MANIFEST.json",
    ),
    "shared-library": (
        "https://github.com/tavisrudd/finitegeom",
        "RelativeConicArcs.Gates.ClebschRigidityTrust",
        "trust/manifests/clebsch_rigidity.json",
    ),
    "paper-bridge": (
        "https://github.com/tavisrudd/finitegeom-clebsch-rigidity-bridge",
        "TavisRuddFiniteGeom.Papers.ClebschRigidity.CertificateCompatibility",
        "MANIFEST.json",
    ),
}
REQUIRED_CITATION_FRAGMENTS = {
    17: ("Dye 1991",),
    25: ("Dye 1991", "Brouwer--Cohen--Neumaier", "Abiad--Jabal Ameli--Reijnders"),
    26: ("discussion preceding Theorem 6",),
    29: ("Dye 1991", "Brouwer--Cohen--Neumaier", "Abiad--Jabal Ameli--Reijnders"),
}
ROWS = [2, *range(11, 27), 29, 58]
ROUTES = {
    "conceptual-cited-inputs",
    "exact-replay",
    "finite-certificate",
    "kernel-checked-lean",
    "mixed",
}
SHELLS = {"bash", "dash", "fish", "powershell", "pwsh", "sh", "zsh"}
FORBIDDEN_SCOPE = {
    "factorization",
    "mathieu",
    "passage",
    "reflection",
    "torsor",
}
def fail(message: str) -> NoReturn:
    raise ValueError(message)


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def release_surface_sha256(manifest: dict[str, object]) -> str:
    projection = json.loads(json.dumps(manifest))
    projection["verify_all"].pop("output")
    encoded = json.dumps(
        projection, separators=(",", ":"), sort_keys=True
    ).encode("utf-8")
    return hashlib.sha256(encoded).hexdigest()


def validate_displayed_digest(
    manuscript_text: str,
    artifact: Path,
    artifact_label: str,
) -> None:
    # A long artifact path has to be set as a display to typeset without an overfull box, so the
    # label may be wrapped in a centred group and a size command.  What the check is about is that
    # the manuscript names this artifact and shows exactly one digest for it.
    pattern = re.compile(
        r"The SHA-256 digest of\s*(?:\\begin\{center\}\s*)?(?:\\small\s*)?"
        rf"\\path\{{{re.escape(artifact_label)}\}}\s*(?:\\end\{{center\}}\s*)?is"
        rf".*?\\path\{{([0-9a-f]{{64}})\}}",
        re.DOTALL,
    )
    matches = pattern.findall(manuscript_text)
    if len(matches) != 1:
        fail(f"manuscript must display exactly one digest for {artifact_label}")
    if matches[0] != digest(artifact):
        fail(f"manuscript displays a stale digest for {artifact_label}")


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


def parse_gate_terminals(path: Path) -> set[str]:
    """Return the exact declarations audited by the aggregate gate."""
    terminals = re.findall(
        r"^\s*#print\s+axioms\s+(\S+)\s*$",
        path.read_text(encoding="utf-8"),
        re.MULTILINE,
    )
    if not terminals:
        fail("aggregate gate contains no #print axioms terminals")
    if len(terminals) != len(set(terminals)):
        fail("aggregate gate repeats a #print axioms terminal")
    return set(terminals)


def claim_lean_components(claim: dict[str, object]) -> list[dict[str, object]]:
    """Collect every Lean evidence component attached to one claim row."""
    result: list[dict[str, object]] = []
    lean = claim.get("lean")
    if isinstance(lean, dict):
        result.append(lean)
    components = claim.get("components")
    if isinstance(components, list):
        for component in components:
            if isinstance(component, dict):
                lean = component.get("lean")
                if isinstance(lean, dict):
                    result.append(lean)
    return result


def require_exact_terminal_coverage(
    manifest_terminals: set[str],
    gate_terminals: set[str],
    audit_terminals: set[str],
) -> None:
    """Reject any omission or addition across manifest, gate, and audit."""
    if manifest_terminals != gate_terminals:
        missing = sorted(gate_terminals - manifest_terminals)
        extra = sorted(manifest_terminals - gate_terminals)
        fail(
            "manifest Lean terminals do not equal aggregate-gate terminals: "
            f"missing={missing}, extra={extra}"
        )
    if audit_terminals != gate_terminals:
        missing = sorted(gate_terminals - audit_terminals)
        extra = sorted(audit_terminals - gate_terminals)
        fail(
            "axiom-audit terminals do not equal aggregate-gate terminals: "
            f"missing={missing}, extra={extra}"
        )


def validate_lean(
    value: object,
    repositories: dict[str, Path],
    audit_cache: dict[Path, dict[str, list[str]]],
    where: str,
) -> None:
    if not isinstance(value, dict):
        fail(f"{where} must be an object")
    repository = require_string(value.get("repository"), f"{where}.repository")
    if repository not in {"certificate", "finitegeom"}:
        fail(f"{where}.repository is not a formal proof owner")
    gate = validate_file(value.get("gate"), repositories, f"{where}.gate")
    audit_path = validate_file(value.get("audit"), repositories, f"{where}.audit")
    expected_gate = (
        "Q11.lean" if repository == "certificate" else "ClebschRigidityTrust.lean"
    )
    if gate.name != expected_gate:
        fail(f"{where}.gate is not the {repository} Paper I gate")
    if repository == "certificate":
        trust_fact = json.loads(audit_path.read_text(encoding="utf-8"))
        declarations = trust_fact.get("declarations")
        if not isinstance(declarations, dict):
            fail(f"{where}.audit has no sealed declarations")
        audit = {
            terminal: declaration.get("axioms")
            for terminal, declaration in declarations.items()
            if isinstance(declaration, dict)
            and isinstance(declaration.get("axioms"), list)
        }
    else:
        audit = {}
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
        values = axioms[terminal]
        if (
            not isinstance(values, list)
            or any(not isinstance(item, str) for item in values)
            or not set(values) <= ALLOWED_AXIOMS
        ):
            fail(f"{where} has a nonstandard axiom for {terminal}")
        if repository == "certificate":
            if terminal not in audit:
                fail(f"{where} terminal absent from sealed trust fact: {terminal}")
            if values != audit[terminal]:
                fail(f"{where} axiom mismatch for {terminal}")
    conditional_interfaces = value.get("conditional_interfaces", [])
    if not isinstance(conditional_interfaces, list) or any(
        not isinstance(item, str) or not item
        for item in conditional_interfaces
    ):
        fail(f"{where}.conditional_interfaces must be a list of nonempty strings")
    if conditional_interfaces:
        fail(f"{where} declares a conditional interface")
    validation = value.get("validation")
    if not isinstance(validation, dict):
        fail(f"{where}.validation must be an object")
    method = require_string(validation.get("method"), f"{where}.validation.method")
    if repository == "certificate":
        if method != "sealed-certificate-through-paper-bridge":
            fail(f"{where}.validation does not use the paper bridge")
        command = require_string(validation.get("command"), f"{where}.validation.command")
        if not command.startswith("nix run .#verify -- "):
            fail(f"{where}.validation does not use the bridge verifier app")
        if validation.get("certificate_build") is not False:
            fail(f"{where}.validation permits a certificate build")
    elif (
        method != "guarded-finitegeom-receipt"
        or validation.get("gate") != "RelativeConicArcs.Gates.ClebschRigidityTrust"
    ):
        fail(f"{where}.validation does not require the finitegeom receipt")


def validate_computation(
    value: object,
    repositories: dict[str, Path],
    where: str,
) -> None:
    if not isinstance(value, dict):
        fail(f"{where} must be an object")
    for field in (
        "coverage",
        "soundness_bridge",
        "independent_replay",
        "residual_trust",
    ):
        require_string(value.get(field), f"{where}.{field}")
    coverage = require_string(value.get("coverage"), f"{where}.coverage")
    if coverage.startswith("The script exhausts the finite field"):
        fail(f"{where}.coverage must state the exact finite domain")
    artifacts = value.get("artifacts")
    if not isinstance(artifacts, list) or not artifacts:
        fail(f"{where}.artifacts must be nonempty")
    artifact_paths: list[str] = []
    for index, artifact in enumerate(artifacts):
        path = validate_file(
            artifact, repositories, f"{where}.artifacts[{index}]"
        )
        if path.suffix != ".py":
            fail(f"{where}.artifacts[{index}] must be an exact Python checker")
        artifact_paths.append(require_string(artifact.get("path"), f"{where}.artifacts[{index}].path"))
    supporting = value.get("supporting_artifacts", [])
    if not isinstance(supporting, list):
        fail(f"{where}.supporting_artifacts must be a list")
    for index, artifact in enumerate(supporting):
        validate_file(
            artifact, repositories, f"{where}.supporting_artifacts[{index}]"
        )
    commands = value.get("checker_commands")
    if not isinstance(commands, list) or not commands:
        fail(f"{where}.checker_commands must be a nonempty list")
    command_paths: list[str] = []
    for index, command in enumerate(commands):
        if not isinstance(command, dict):
            fail(f"{where}.checker_commands[{index}] must be an object")
        argv = command.get("argv")
        if (
            not isinstance(argv, list)
            or len(argv) < 2
            or argv[0] != "python3"
            or any(not isinstance(item, str) or not item for item in argv)
        ):
            fail(
                f"{where}.checker_commands[{index}].argv must be a direct "
                "Python command"
            )
        command_paths.append(argv[1])
    if set(command_paths) != set(artifact_paths):
        fail(f"{where}.checker_commands must use exactly the checker artifacts")


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
    elif route in {"exact-replay", "finite-certificate"}:
        validate_computation(
            value.get("computation"), repositories, f"{where}.computation"
        )
        if route == "finite-certificate" and not value["computation"].get(
            "supporting_artifacts"
        ):
            fail(f"{where}.computation must pin a finite proof object")
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


def claim_computations(claim: dict[str, object]) -> list[dict[str, object]]:
    values: list[dict[str, object]] = []
    computation = claim.get("computation")
    if isinstance(computation, dict):
        values.append(computation)
    components = claim.get("components")
    if isinstance(components, list):
        for component in components:
            if isinstance(component, dict):
                computation = component.get("computation")
                if isinstance(computation, dict):
                    values.append(computation)
    return values


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
        if "axiom_audit" in check:
            validate_file(
                check.get("axiom_audit"),
                repositories,
                f"{item}.axiom_audit",
            )
    if len(value) != 27:
        fail(f"{where} must contain exactly twenty-seven admitted checks")


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
    parser.add_argument("--certificate-root", type=Path, required=True)
    parser.add_argument("--finitegeom-root", type=Path, required=True)
    parser.add_argument("--bridge-root", type=Path, required=True)
    parser.add_argument(
        "--allow-stale-release-output",
        action="store_true",
        help="validate all release inputs while permitting certificate regeneration",
    )
    args = parser.parse_args()
    repositories = {
        "paper": paper_root.resolve(),
        "certificate": args.certificate_root.resolve(),
        "finitegeom": args.finitegeom_root.resolve(),
        "bridge": args.bridge_root.resolve(),
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
    manuscript_text = manuscript.read_text(encoding="utf-8")
    validate_displayed_digest(
        manuscript_text,
        paper_root / "verification" / "checker_outputs.json",
        "verification/checker_outputs.json",
    )
    validate_displayed_digest(
        manuscript_text,
        repositories["bridge"]
        / "TavisRuddFiniteGeom"
        / "Papers"
        / "ClebschRigidity"
        / "CertificateCompatibility.lean",
        "TavisRuddFiniteGeom/Papers/ClebschRigidity/CertificateCompatibility.lean",
    )
    validate_file(
        manifest.get("manuscript_pdf"),
        repositories,
        "manifest.manuscript_pdf",
    )
    companion_surface = manifest.get("computational_companion")
    if not isinstance(companion_surface, dict):
        fail("manifest.computational_companion must be an object")
    for key in ("manuscript", "pdf", "trust_ledger", "finite_boundary_manifest"):
        validate_file(
            companion_surface.get(key),
            repositories,
            f"manifest.computational_companion.{key}",
        )
    companion_evidence = companion_surface.get("evidence")
    if not isinstance(companion_evidence, list) or len(companion_evidence) != 11:
        fail("manifest.computational_companion.evidence must contain eleven files")
    for index, evidence in enumerate(companion_evidence):
        validate_file(
            evidence,
            repositories,
            f"manifest.computational_companion.evidence[{index}]",
        )
    public_documents = manifest.get("public_documents")
    if not isinstance(public_documents, list) or len(public_documents) != 2:
        fail("manifest.public_documents must contain both public README files")
    for index, document in enumerate(public_documents):
        validate_file(
            document,
            repositories,
            f"manifest.public_documents[{index}]",
        )
    identity_path = validate_file(
        manifest.get("statement_identity"),
        repositories,
        "manifest.statement_identity",
    )
    companion_pin_path = validate_file(
        manifest.get("formal_companion"),
        repositories,
        "manifest.formal_companion",
    )
    companion_pin = json.loads(companion_pin_path.read_text(encoding="utf-8"))
    artifacts = companion_pin.get("artifacts")
    if (
        not isinstance(artifacts, list)
        or {entry.get("role") for entry in artifacts if isinstance(entry, dict)}
        != FORMAL_ROLES
    ):
        fail("manifest formal companion does not pin the three formal roles")
    for artifact in artifacts:
        if not isinstance(artifact, dict):
            fail("manifest formal companion contains a malformed artifact")
        role = artifact["role"]
        if (
            artifact.get("repository"),
            artifact.get("gate"),
            artifact.get("manifest"),
        ) != EXPECTED_ARTIFACTS[role]:
            fail(f"manifest formal companion has the wrong {role} contract")
        if role == "paper-bridge" and artifact.get("depends_on") != [
            "shared-library",
            "certificate",
        ]:
            fail("manifest paper bridge has the wrong dependency boundary")
    formal_verification = manifest.get("formal_verification")
    expected_formal = {
        "certificate_manifest": ("certificate", "MANIFEST.json"),
        "certificate_trust_fact": ("certificate", "TRUST_FACT.json"),
        "finitegeom_gate": (
            "finitegeom",
            "RelativeConicArcs/Gates/ClebschRigidityTrust.lean",
        ),
        "finitegeom_audit": ("finitegeom", "trust/ClebschRigidityAxiomAudit.lean"),
        "bridge_manifest": ("bridge", "MANIFEST.json"),
        "bridge_gate": (
            "bridge",
            "TavisRuddFiniteGeom/Papers/ClebschRigidity/CertificateCompatibility.lean",
        ),
    }
    if not isinstance(formal_verification, dict) or set(formal_verification) != set(
        expected_formal
    ):
        fail("manifest.formal_verification has the wrong artifact set")
    for name, evidence in formal_verification.items():
        if not isinstance(evidence, dict) or (
            evidence.get("repository"), evidence.get("path")
        ) != expected_formal[name]:
            fail(f"manifest.formal_verification.{name} has the wrong location")
        validate_file(evidence, repositories, f"manifest.formal_verification.{name}")
    identity_payload = json.loads(identity_path.read_text(encoding="utf-8"))
    if identity_payload.get("source_sha256") != digest(manuscript):
        fail("statement identity source hash mismatch")
    companion = paper_root / "clebsch_rigidity_computational_companion.tex"
    if identity_payload.get("companion_source_sha256") != digest(companion):
        fail("statement identity companion source hash mismatch")
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
        row = claim_value["row"]
        claim_text = json.dumps(claim_value, sort_keys=True)
        for fragment in REQUIRED_CITATION_FRAGMENTS.get(row, ()):
            if fragment not in claim_text:
                fail(f"manifest claim row {row} omits required cited input: {fragment}")
    lean_components = [
        lean
        for claim in claims
        for lean in claim_lean_components(claim)
    ]
    if not lean_components:
        fail("manifest contains no Lean evidence components")
    finitegeom_components = [
        lean for lean in lean_components if lean.get("repository") == "finitegeom"
    ]
    certificate_components = [
        lean for lean in lean_components if lean.get("repository") == "certificate"
    ]
    if not finitegeom_components or not certificate_components:
        fail("manifest must use both finitegeom and the sealed Q11 certificate")
    manifest_terminals = {
        terminal for lean in finitegeom_components for terminal in lean["terminals"]
    }
    gate_terminals = parse_gate_terminals(
        repositories["finitegeom"] / "RelativeConicArcs/Gates/ClebschRigidityTrust.lean"
    )
    audit_terminals = parse_gate_terminals(
        repositories["finitegeom"] / "trust/ClebschRigidityAxiomAudit.lean"
    )
    require_exact_terminal_coverage(
        manifest_terminals,
        gate_terminals,
        audit_terminals,
    )
    certificate_fact = json.loads(
        (repositories["certificate"] / "TRUST_FACT.json").read_text(encoding="utf-8")
    )
    certificate_declarations = certificate_fact.get("declarations")
    if not isinstance(certificate_declarations, dict):
        fail("certificate trust fact has no declarations")
    certificate_terminals = {
        terminal for lean in certificate_components for terminal in lean["terminals"]
    }
    if not certificate_terminals or not certificate_terminals <= set(certificate_declarations):
        fail("manifest certificate terminals are not sealed by the Q11 trust fact")
    environment = manifest.get("reproducibility_environment")
    if not isinstance(environment, dict):
        fail("manifest.reproducibility_environment must be an object")
    validate_file(environment.get("flake"), repositories, "manifest.environment.flake")
    validate_file(environment.get("lock"), repositories, "manifest.environment.lock")
    verify_all = manifest.get("verify_all")
    if not isinstance(verify_all, dict):
        fail("manifest.verify_all must be an object")
    command = require_string(verify_all.get("command"), "manifest.verify_all.command")
    if "nix run .#verify --" not in command or "--certificate-root" not in command:
        fail("manifest.verify_all.command is not the clean release entry point")
    validate_file(verify_all.get("entry_point"), repositories, "manifest.verify_all.entry_point")
    release_output_path = validate_file(
        verify_all.get("output"), repositories, "manifest.verify_all.output"
    )
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
    release_output = json.loads(release_output_path.read_text(encoding="utf-8"))
    expected_inputs = {
        "checker_outputs_sha256": certificate["output"]["sha256"],
        "companion_manuscript_sha256": companion_surface["manuscript"]["sha256"],
        "companion_pdf_sha256": companion_surface["pdf"]["sha256"],
        "companion_trust_sha256": companion_surface["trust_ledger"]["sha256"],
        "formal_companion_sha256": manifest["formal_companion"]["sha256"],
        "manuscript_pdf_sha256": manifest["manuscript_pdf"]["sha256"],
        "manuscript_sha256": manifest["manuscript_sha256"],
        "release_surface_sha256": release_surface_sha256(manifest),
        "statement_identity_sha256": manifest["statement_identity"]["sha256"],
    }
    if (
        not args.allow_stale_release_output
        and release_output.get("inputs") != expected_inputs
    ):
        fail("release output does not attest the exact release inputs")
    tools = verify_all.get("verification_tools")
    if not isinstance(tools, list) or len(tools) != 6:
        fail("manifest.verify_all.verification_tools must contain six files")
    for index, tool in enumerate(tools):
        validate_file(
            tool,
            repositories,
            f"manifest.verify_all.verification_tools[{index}]",
        )
    checks = verify_all.get("checks")
    validate_checks(checks, repositories, "manifest.verify_all.checks")
    admitted_checker_commands = {
        tuple(check["argv"])
        for check in checks
        if isinstance(check, dict) and str(check.get("id", "")).startswith("check-")
    }
    for claim in claims:
        for computation in claim_computations(claim):
            for command_spec in computation["checker_commands"]:
                command = tuple(command_spec["argv"])
                if command not in admitted_checker_commands:
                    fail(
                        f"manifest claim row {claim['row']} checker command is "
                        f"absent from verify_all.checks: {command}"
                    )
    if "lean_repository" in manifest:
        fail("manifest must not duplicate FORMAL_COMPANION repository pins")
    print("Clebsch rigidity trust manifest: valid (19 claims, 27 checks)")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (OSError, UnicodeError, json.JSONDecodeError, ValueError) as error:
        print(f"trust-manifest validation failed: {error}")
        raise SystemExit(1)
