#!/usr/bin/env python3
"""Aggregate release check for the factorization-memory paper."""

from __future__ import annotations

import argparse
import hashlib
import json
import platform
import re
import subprocess
import sys
from pathlib import Path, PurePosixPath


EXPECTED_SCHEMA = "clebsch-factorization-trust-manifest-v1"
EXPECTED_IDENTITY = "verification/statement_identity.json"
FINGERPRINT = "verification/evidence_fingerprint.json"
ALLOWED_MODES = {"conceptual", "classical-input", "certificate", "lean"}
EXTERNAL_FORMAL_EVIDENCE = {
    "arithmetic-gluing",
    "hilbert-symmetry",
    "hyperplane-square",
}
LEAN_GATE_COMMANDS = [
    [
        "lean/scripts/guarded-lean",
        "RelativeConicArcs/Gates/ClebschArithmeticGluing.lean",
    ],
    [
        "lean/scripts/guarded-lean",
        "RelativeConicArcs/Gates/ClebschHilbertSymmetry.lean",
    ],
    [
        "lean/scripts/guarded-lean",
        "RelativeConicArcs/Gates/ClebschHyperplaneSquare.lean",
    ],
]
LEAN_GATE_TERMINALS = 26
ALLOWED_LEAN_AXIOMS = {"propext", "Classical.choice", "Quot.sound"}
EXPECTED_EVIDENCE = {
    "matching-module": {
        "checksum_manifest": "verification/evidence/source_manifest.sha256",
        "checksum_root": "verification/evidence",
        "commands": [
            ["python3", "verification/evidence/matching_module.py", "--check"],
            ["python3", "verification/evidence/matching_module_replay.py"],
        ],
    },
    "h3-equivariant-rank": {
        "checksum_manifest":
            "verification/evidence/source_manifest.sha256",
        "checksum_root": "verification/evidence",
        "commands": [
            [
                "python3",
                "verification/evidence/equivariant_rank.py",
                "--check",
            ],
            [
                "python3",
                "verification/evidence/equivariant_rank_replay.py",
            ],
        ],
    },
    "balanced-sheet": {
        "checksum_manifest":
            "verification/evidence/source_manifest.sha256",
        "checksum_root": "verification/evidence",
        "commands": [
            [
                "python3",
                "verification/evidence/balanced_sheets.py",
                "--check",
            ],
            [
                "python3",
                "verification/evidence/balanced_sheets_replay.py",
                "--check",
            ],
        ],
    },
    "gorenstein-gate": {
        "checksum_manifest": "verification/evidence/source_manifest.sha256",
        "checksum_root": "verification/evidence",
        "commands": [
            [
                "python3",
                "verification/evidence/gorenstein.py",
                "--check",
            ],
            ["python3", "verification/evidence/gorenstein_replay.py"],
        ],
    },
    "profile-incidence": {
        "checksum_manifest": "verification/evidence/source_manifest.sha256",
        "checksum_root": "verification/evidence",
        "commands": [
            ["python3", "verification/evidence/profile_incidence.py", "--check"],
            ["python3", "verification/evidence/profile_incidence_replay.py"],
        ],
    },
    "decorated-parent": {
        "checksum_manifest":
            "verification/evidence/source_manifest.sha256",
        "checksum_root": "verification/evidence",
        "commands": [
            [
                "python3",
                "verification/evidence/decorated_parent.py",
                "--check",
            ],
            ["python3", "verification/evidence/decorated_parent_replay.py"],
        ],
    },
    "relative-cubic-depth": {
        "checksum_manifest":
            "verification/evidence/source_manifest.sha256",
        "checksum_root": "verification/evidence",
        "commands": [
            [
                "python3",
                "verification/evidence/relative_cubic_depth.py",
                "--check",
            ],
            ["python3", "verification/evidence/relative_cubic_depth_replay.py"],
        ],
    },
    "arithmetic-gluing": {
        "checksum_manifest":
            "lean/verification/clebsch_arithmetic_gluing/manifest.sha256",
        "checksum_root": "lean",
        "commands": [
            [
                "python3",
                "lean/verification/clebsch_arithmetic_gluing/generate.py",
                "--check",
            ],
            [
                "python3",
                "lean/verification/clebsch_arithmetic_gluing/replay.py",
            ],
        ],
    },
    "hilbert-symmetry": {
        "checksum_manifest":
            "verification/hilbert_symmetry.sha256",
        "commands": [],
    },
    "hyperplane-square": {
        "checksum_manifest":
            "verification/hyperplane_square.sha256",
        "commands": [],
    },
    "generic-first-wall": {
        "checksum_manifest":
            "verification/evidence/source_manifest.sha256",
        "checksum_root": "verification/evidence",
        "commands": [
            [
                "python3",
                "verification/evidence/generic_first_wall.py",
                "--check",
            ],
            [
                "python3",
                "verification/evidence/generic_first_wall_replay.py",
                "--check",
            ],
        ],
    },
    "shared-radial": {
        "checksum_manifest":
            "verification/evidence/source_manifest.sha256",
        "checksum_root": "verification/evidence",
        "commands": [
            [
                "python3",
                "verification/evidence/shared_radial.py",
                "--check",
            ],
            [
                "python3",
                "verification/evidence/shared_radial_replay.py",
                "--check",
            ],
        ],
    },
    "small-field-trade": {
        "checksum_manifest":
            "verification/evidence/source_manifest.sha256",
        "checksum_root": "verification/evidence",
        "commands": [
            [
                "python3",
                "verification/evidence/trade_only_small_field.py",
            ],
            [
                "python3",
                "verification/evidence/trade_only_small_field_replay.py",
            ],
        ],
    },
}
EXPECTED_CLAIMS = {
    "thm:factorization-recovery": (
        {"conceptual", "classical-input", "certificate"},
        {"matching-module", "h3-equivariant-rank", "balanced-sheet",
         "gorenstein-gate", "generic-first-wall", "shared-radial",
         "small-field-trade", "profile-incidence", "decorated-parent"},
    ),
    "prop:matching-secant-quotient": ({"conceptual"}, set()),
    "lem:projective-trade-reduction": ({"conceptual"}, set()),
    "lem:lucas-socle-square-parity": (
        {"conceptual", "classical-input", "certificate"},
        {"generic-first-wall"},
    ),
    "lem:uniform-sheet-exclusion": (
        {"conceptual", "classical-input", "certificate"},
        {"generic-first-wall", "small-field-trade"},
    ),
    "thm:balanced-orbit-completeness": (
        {"conceptual", "classical-input", "certificate"},
        {"generic-first-wall", "small-field-trade"},
    ),
    "lem:shared-radial-cycle": (
        {"conceptual", "certificate"},
        {"shared-radial"},
    ),
    "thm:rank-three-quotients": (
        {"conceptual", "classical-input", "certificate"},
        {"matching-module", "h3-equivariant-rank", "shared-radial"},
    ),
    "cor:h3-affine-origin": (
        {"conceptual", "classical-input", "certificate"},
        {"matching-module", "h3-equivariant-rank"},
    ),
    "cor:h3-middle-layer": (
        {"conceptual", "certificate"},
        {"matching-module", "h3-equivariant-rank"},
    ),
    "prop:radical-hadamard": ({"conceptual"}, set()),
    "prop:modular-sheet-mechanism": (
        {"conceptual", "classical-input", "certificate"},
        {"matching-module", "h3-equivariant-rank", "balanced-sheet",
         "shared-radial"},
    ),
    "lem:hyperplane-square": (
        {"conceptual", "lean"},
        {"hyperplane-square"},
    ),
    "thm:balanced-cubic": (
        {"conceptual", "certificate", "lean"},
        {"matching-module", "balanced-sheet", "shared-radial",
         "hyperplane-square"},
    ),
    "cor:graded-evaluation": (
        {"conceptual", "certificate", "lean"},
        {"matching-module", "balanced-sheet", "hyperplane-square"},
    ),
    "cor:self-associated-gorenstein": (
        {"conceptual", "certificate"},
        {"matching-module", "balanced-sheet", "gorenstein-gate"},
    ),
    "cor:secant-product-syzygies": (
        {"conceptual", "certificate"},
        {"matching-module"},
    ),
    "thm:six-profile-reconstruction": (
        {"conceptual", "certificate"},
        {"profile-incidence", "decorated-parent"},
    ),
    "cor:decorated-sheet-classifier": (
        {"conceptual", "certificate"},
        {"profile-incidence", "decorated-parent"},
    ),
    "cor:profile-ray-weights": (
        {"conceptual", "certificate"},
        {"profile-incidence"},
    ),
    "prop:modular-depth-quotient": (
        {"conceptual", "classical-input", "certificate"},
        {"relative-cubic-depth"},
    ),
    "cor:h3-nine-space-bridge": (
        {"conceptual", "classical-input", "certificate"},
        {"matching-module", "h3-equivariant-rank", "balanced-sheet",
         "relative-cubic-depth"},
    ),
    "cor:h3-homogeneous-projective-cover": (
        {"conceptual", "classical-input", "certificate"},
        {"matching-module", "h3-equivariant-rank", "balanced-sheet",
         "relative-cubic-depth"},
    ),
    "lem:split-inert-frames": (
        {"conceptual", "lean"},
        {"arithmetic-gluing"},
    ),
    "thm:rank-three-arithmetic-gluing": (
        {"conceptual", "classical-input", "certificate", "lean"},
        {"profile-incidence", "decorated-parent", "arithmetic-gluing"},
    ),
    "lem:three-ray-cubic": ({"conceptual"}, set()),
    "cor:mass-zero-cubic": ({"conceptual"}, set()),
    "prop:relative-cubic-tate-plane": (
        {"conceptual", "certificate"},
        {"relative-cubic-depth"},
    ),
}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1 << 20), b""):
            digest.update(chunk)
    return digest.hexdigest()


def check_checksum_manifest(
    manifest_root: Path,
    relative: str,
    checksum_root: str = ".",
    *,
    artifact_base: Path | None = None,
) -> None:
    relative_path = PurePosixPath(relative)
    if relative_path.is_absolute() or ".." in relative_path.parts:
        raise ValueError(f"unsafe checksum-manifest path: {relative}")
    root_path = PurePosixPath(checksum_root)
    if root_path.is_absolute() or ".." in root_path.parts:
        raise ValueError(f"unsafe checksum root: {checksum_root}")
    manifest = manifest_root / relative
    artifact_root = (artifact_base or manifest_root) / root_path
    seen: set[str] = set()
    for line_number, line in enumerate(
        manifest.read_text(encoding="utf-8").splitlines(), start=1
    ):
        if not line:
            continue
        expected, path_text = line.split(maxsplit=1)
        if len(expected) != 64 or any(character not in "0123456789abcdef"
                                      for character in expected):
            raise ValueError(f"{manifest}:{line_number}: invalid SHA-256")
        normalized = path_text.strip().lstrip("*")
        artifact_path = PurePosixPath(normalized)
        if artifact_path.is_absolute() or ".." in artifact_path.parts:
            raise ValueError(f"{manifest}:{line_number}: unsafe artifact path")
        if normalized in seen:
            raise ValueError(f"{manifest}:{line_number}: duplicate artifact path")
        seen.add(normalized)
        path = artifact_root / normalized
        if not path.is_file():
            raise ValueError(f"{manifest}:{line_number}: missing {path_text}")
        actual = sha256(path)
        if actual != expected:
            raise ValueError(
                f"{manifest}:{line_number}: checksum mismatch for {path_text}"
            )


def run(command: list[str], cwd: Path) -> str:
    completed = subprocess.run(
        command,
        cwd=cwd,
        check=False,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
    )
    if completed.returncode != 0:
        sys.stdout.write(completed.stdout)
        raise SystemExit(
            f"command failed ({completed.returncode}): {' '.join(command)}"
        )
    summary = completed.stdout.strip().splitlines()
    tail = summary[-1] if summary else "OK"
    print(f"{' '.join(command)}: {tail}")
    if command and command[0] == "lean/scripts/guarded-lean":
        match = re.search(r"^stdout: \d+ lines -> (.+)$", completed.stdout, re.MULTILINE)
        if match is None:
            raise ValueError("guarded Lean output did not identify its raw log")
        raw_log = Path(match.group(1)).resolve()
        if raw_log.name != "stdout.log" or "guarded-lean" not in raw_log.parts:
            raise ValueError("guarded Lean returned an unsafe raw-log path")
        return raw_log.read_text(encoding="utf-8")
    return completed.stdout


def check_latex_warnings(log_path: Path) -> None:
    forbidden = re.compile(
        r"(LaTeX Warning:|Package .* Warning:|undefined references|"
        r"multiply defined|Overfull \\hbox|Underfull \\hbox)"
    )
    findings = [
        line for line in log_path.read_text(encoding="utf-8", errors="replace").splitlines()
        if forbidden.search(line)
    ]
    if findings:
        raise ValueError("manuscript warning scan failed:\n" + "\n".join(findings))
    print("clebsch factorization warnings: CHECK OK")


def check_manuscript_source_lint(source_path: Path) -> None:
    source = source_path.read_text(encoding="utf-8")
    malformed_spacing = re.compile(r",\s*q{1,2}uad\b")
    findings = [
        f"line {source.count(chr(10), 0, match.start()) + 1}: {match.group()!r}"
        for match in malformed_spacing.finditer(source)
    ]
    if findings:
        raise ValueError(
            "manuscript source lint failed: missing TeX command escape:\n"
            + "\n".join(findings)
        )
    print("clebsch factorization source lint: CHECK OK")


def check_lean_axiom_audit(wrapper_output: str) -> None:
    audit = wrapper_output
    dependency_blocks = re.findall(
        r"'[^']+' depends on axioms: \[(.*?)\]", audit, re.DOTALL
    )
    axiom_free = re.findall(r"'[^']+' does not depend on any axioms", audit)
    if len(dependency_blocks) + len(axiom_free) != LEAN_GATE_TERMINALS:
        raise ValueError("Lean axiom audit terminal count changed")
    found_axioms = {
        name
        for block in dependency_blocks
        for name in re.findall(r"[A-Za-z][A-Za-z0-9_.]*", block)
    }
    unexpected = found_axioms - ALLOWED_LEAN_AXIOMS
    if unexpected:
        raise ValueError(f"Lean axiom audit found unexpected axioms: {sorted(unexpected)}")
    print("clebsch Lean-gate axiom allowlist: CHECK OK")


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def normalized_manuscript_sha256(path: Path) -> str:
    text = path.read_text(encoding="utf-8")
    pattern = re.compile(
        r"(Its SHA-256 digest is\s*\\begin\{center\}\s*"
        r"\\small\\texttt\{)[0-9a-f]{38}"
        r"(\}\\\\\[-2pt\]\s*\\texttt\{)[0-9a-f]{26}(\})"
    )
    normalized, replacements = pattern.subn(
        r"\g<1>" + "0" * 38 + r"\g<2>" + "0" * 26 + r"\g<3>",
        text,
    )
    if replacements != 1:
        raise ValueError("expected one displayed evidence-fingerprint digest")
    return sha256_bytes(normalized.encode("utf-8"))


def normalized_identity_sha256(path: Path) -> str:
    identity = json.loads(path.read_text(encoding="utf-8"))
    identity["source_sha256"] = "<normalized-manuscript>"
    return sha256_bytes(
        (json.dumps(identity, sort_keys=True, separators=(",", ":")) + "\n").encode()
    )


def lean_import_closure(repo_root: Path, entry: Path) -> dict[str, str]:
    lean_root = repo_root / "lean"
    pending = [entry]
    seen: set[Path] = set()
    while pending:
        path = pending.pop()
        if path in seen:
            continue
        seen.add(path)
        for line in path.read_text(encoding="utf-8").splitlines():
            if not line.startswith("import RelativeConicArcs."):
                continue
            module = line.removeprefix("import ").strip()
            imported = lean_root / (module.replace(".", "/") + ".lean")
            if not imported.is_file():
                raise ValueError(f"missing project-owned Lean import: {module}")
            pending.append(imported)
    return {
        str(path.relative_to(repo_root)): sha256(path)
        for path in sorted(seen)
    }


def build_fingerprint(
    repo_root: Path, paper_root: Path, manifest: dict[str, object]
) -> dict[str, object]:
    bundle_fingerprints = {}
    for name, item in manifest["evidence"].items():
        artifact_root = (
            repo_root
            if PurePosixPath(item["checksum_manifest"]).parts[0] == "lean"
            else paper_root
        )
        checksum_manifest = artifact_root / item["checksum_manifest"]
        bundle_fingerprints[name] = {
            "checksum_manifest": item["checksum_manifest"],
            "checksum_manifest_sha256": sha256(checksum_manifest),
            "checksum_root": item.get("checksum_root", "."),
            "commands": item["commands"],
        }
    environment_paths = {
        "lean_toolchain": repo_root / "lean" / "lean-toolchain",
        "lake_manifest": repo_root / "lean" / "lake-manifest.json",
        "nix_lock": repo_root / "lean" / "flake.lock",
    }
    return {
        "schema": "clebsch-factorization-evidence-fingerprint-v2",
        "python": platform.python_version(),
        "lean_toolchain": environment_paths["lean_toolchain"]
        .read_text(encoding="utf-8")
        .strip(),
        "mathlib_revision": next(
            package["rev"]
            for package in json.loads(
                environment_paths["lake_manifest"].read_text(encoding="utf-8")
            )["packages"]
            if package["name"] == "mathlib"
        ),
        "environment_sha256": {
            name: sha256(path) for name, path in environment_paths.items()
        },
        "trust_manifest_sha256": sha256(
            paper_root / "verification" / "trust_manifest.json"
        ),
        "runner_sha256": sha256(Path(__file__).resolve()),
        "review_sources_sha256": {
            "normalized_manuscript": normalized_manuscript_sha256(
                paper_root / "clebsch_factorization.tex"
            ),
            "normalized_statement_identity": normalized_identity_sha256(
                paper_root / "verification" / "statement_identity.json"
            ),
            "statement_extractor": sha256(
                paper_root / "verification" / "extract_statement_identity.py"
            ),
            "paper_readme": sha256(paper_root / "README.md"),
            "verification_readme": sha256(
                paper_root / "verification" / "README.md"
            ),
            "evidence_manifest_tool": sha256(
                paper_root / "verification" / "evidence" / "manifest.py"
            ),
            "lean_gates": {
                path.name: sha256(path)
                for path in (
                    repo_root / "lean" / "RelativeConicArcs" / "Gates"
                    / "ClebschArithmeticGluing.lean",
                    repo_root / "lean" / "RelativeConicArcs" / "Gates"
                    / "ClebschHilbertSymmetry.lean",
                    repo_root / "lean" / "RelativeConicArcs" / "Gates"
                    / "ClebschHyperplaneSquare.lean",
                )
            },
            "guarded_lean": sha256(repo_root / "lean" / "scripts" / "guarded-lean"),
        },
        "project_lean_import_closure_sha256": {
            path.name: lean_import_closure(repo_root, path)
            for path in (
                repo_root / "lean" / "RelativeConicArcs" / "Gates"
                / "ClebschArithmeticGluing.lean",
                repo_root / "lean" / "RelativeConicArcs" / "Gates"
                / "ClebschHilbertSymmetry.lean",
                repo_root / "lean" / "RelativeConicArcs" / "Gates"
                / "ClebschHyperplaneSquare.lean",
            )
        },
        "lean_gates": [
            {"command": command, "cwd": "."}
            for command in LEAN_GATE_COMMANDS
        ],
        "evidence": bundle_fingerprints,
        "expected_success": {
            "metadata": "metadata: 24 statements, 10 evidence bundles: CHECK OK",
            "release": "clebsch factorization release: CHECK OK",
        },
    }


def check_standalone_fingerprint(
    fingerprint: dict[str, object],
    paper_root: Path,
    manifest: dict[str, object],
) -> None:
    expected_review_sources = {
        "normalized_manuscript": normalized_manuscript_sha256(
            paper_root / "clebsch_factorization.tex"
        ),
        "normalized_statement_identity": normalized_identity_sha256(
            paper_root / "verification" / "statement_identity.json"
        ),
        "statement_extractor": sha256(
            paper_root / "verification" / "extract_statement_identity.py"
        ),
        "paper_readme": sha256(paper_root / "README.md"),
        "verification_readme": sha256(paper_root / "verification" / "README.md"),
        "evidence_manifest_tool": sha256(
            paper_root / "verification" / "evidence" / "manifest.py"
        ),
    }
    recorded_sources = fingerprint.get("review_sources_sha256", {})
    for name, expected in expected_review_sources.items():
        if recorded_sources.get(name) != expected:
            raise ValueError(f"standalone fingerprint is stale: {name}")
    if fingerprint.get("trust_manifest_sha256") != sha256(
        paper_root / "verification" / "trust_manifest.json"
    ):
        raise ValueError("standalone fingerprint is stale: trust manifest")
    if fingerprint.get("runner_sha256") != sha256(Path(__file__).resolve()):
        raise ValueError("standalone fingerprint is stale: verification runner")
    recorded_evidence = fingerprint.get("evidence", {})
    for name, item in manifest["evidence"].items():
        recorded = recorded_evidence.get(name, {})
        is_external = PurePosixPath(item["checksum_manifest"]).parts[0] == "lean"
        checksum_matches = (
            isinstance(recorded.get("checksum_manifest_sha256"), str)
            and len(recorded["checksum_manifest_sha256"]) == 64
            if is_external
            else recorded.get("checksum_manifest_sha256")
            == sha256(paper_root / item["checksum_manifest"])
        )
        if (
            recorded.get("checksum_manifest") != item["checksum_manifest"]
            or recorded.get("checksum_root") != item.get("checksum_root", ".")
            or recorded.get("commands") != item["commands"]
            or not checksum_matches
        ):
            raise ValueError(f"standalone fingerprint is stale: {name}")
    print("standalone fingerprint: CHECK OK; external Lean environment is not bundled")


def main() -> int:
    if sys.flags.optimize:
        raise RuntimeError("release verification requires Python assertions enabled")
    paper_root = Path(__file__).resolve().parents[1]
    monorepo_root = paper_root.parents[1]
    formal_available = (
        paper_root.parent.name == "papers"
        and (monorepo_root / "lean" / "lakefile.toml").is_file()
    )
    repo_root = monorepo_root if formal_available else paper_root
    parser = argparse.ArgumentParser()
    parser.add_argument("--metadata-only", action="store_true")
    parser.add_argument("--update-fingerprint", action="store_true")
    args = parser.parse_args()

    check_manuscript_source_lint(paper_root / "clebsch_factorization.tex")
    run(
        [
            "python3",
            str(paper_root / "verification" / "extract_statement_identity.py"),
            "--check",
        ],
        paper_root,
    )
    identity = json.loads(
        (paper_root / "verification" / "statement_identity.json").read_text(
            encoding="utf-8"
        )
    )
    manifest = json.loads(
        (paper_root / "verification" / "trust_manifest.json").read_text(
            encoding="utf-8"
        )
    )
    fingerprint_path = paper_root / FINGERPRINT
    if formal_available:
        fingerprint = build_fingerprint(repo_root, paper_root, manifest)
        fingerprint_rendered = json.dumps(fingerprint, indent=2) + "\n"
        if args.update_fingerprint:
            fingerprint_path.write_text(fingerprint_rendered, encoding="utf-8")
            print(f"wrote {fingerprint_path}")
        elif (
            not fingerprint_path.exists()
            or fingerprint_path.read_text(encoding="utf-8") != fingerprint_rendered
        ):
            raise ValueError("evidence fingerprint is stale")
    else:
        if args.update_fingerprint:
            raise ValueError("cannot refresh the formal fingerprint without its Lean companion")
        fingerprint = json.loads(fingerprint_path.read_text(encoding="utf-8"))
        check_standalone_fingerprint(fingerprint, paper_root, manifest)
    if manifest.get("schema") != EXPECTED_SCHEMA:
        raise ValueError("unexpected trust-manifest schema")
    if manifest.get("statement_identity") != EXPECTED_IDENTITY:
        raise ValueError("unexpected statement-identity path")
    statement_labels = {
        statement["label"] for statement in identity["statements"]
    }
    claim_labels = {claim["label"] for claim in manifest["claims"]}
    if statement_labels != claim_labels or len(manifest["claims"]) != len(
        statement_labels
    ):
        raise ValueError("trust manifest does not partition the statement identity")
    if claim_labels != set(EXPECTED_CLAIMS):
        raise ValueError("unexpected claim-label set")
    evidence = manifest["evidence"]
    if set(evidence) != set(EXPECTED_EVIDENCE):
        raise ValueError("evidence-bundle set changed")
    for name, expected in EXPECTED_EVIDENCE.items():
        actual = evidence[name]
        for field in ("checksum_manifest", "commands"):
            if actual.get(field) != expected[field]:
                raise ValueError(f"{name}: unexpected {field}")
        if actual.get("checksum_root", ".") != expected.get("checksum_root", "."):
            raise ValueError(f"{name}: unexpected checksum_root")
        if not isinstance(actual.get("role"), str) or not actual["role"].strip():
            raise ValueError(f"{name}: missing semantic role")
    for claim in manifest["claims"]:
        unknown = set(claim["evidence"]) - set(evidence)
        if unknown:
            raise ValueError(f"{claim['label']}: unknown evidence {sorted(unknown)}")
        modes = set(claim["modes"])
        if not modes or not modes <= ALLOWED_MODES:
            raise ValueError(f"{claim['label']}: invalid proof modes")
        if "certificate" in modes and not claim["evidence"]:
            raise ValueError(f"{claim['label']}: certificate mode has no evidence")
        if "lean" in modes and not (
            {"arithmetic-gluing", "hilbert-symmetry", "hyperplane-square"}
            & set(claim["evidence"])
        ):
            raise ValueError(f"{claim['label']}: Lean mode has no Lean evidence")
        expected_modes, expected_bundles = EXPECTED_CLAIMS[claim["label"]]
        if modes != expected_modes or set(claim["evidence"]) != expected_bundles:
            raise ValueError(f"{claim['label']}: proof-mode/evidence coverage changed")
    for name, item in evidence.items():
        is_external = name in EXTERNAL_FORMAL_EVIDENCE
        if is_external and not formal_available:
            continue
        manifest_root = (
            repo_root
            if PurePosixPath(item["checksum_manifest"]).parts[0] == "lean"
            else paper_root
        )
        check_checksum_manifest(
            manifest_root,
            item["checksum_manifest"],
            item.get("checksum_root", "."),
            artifact_base=repo_root if is_external else paper_root,
        )
    print(
        f"metadata: {len(statement_labels)} statements, "
        f"{len(evidence)} evidence bundles: CHECK OK"
    )

    if args.metadata_only:
        return 0
    for name, item in evidence.items():
        if name in EXTERNAL_FORMAL_EVIDENCE and not formal_available:
            continue
        for command in item["commands"]:
            run(
                command,
                repo_root if name in EXTERNAL_FORMAL_EVIDENCE else paper_root,
            )
    if formal_available:
        lean_output = "\n".join(
            run(command, repo_root) for command in LEAN_GATE_COMMANDS
        )
        check_lean_axiom_audit(lean_output)
        run(["make", "-B", "clebsch-factorization"], repo_root / "papers")
    else:
        run(
            [
                "nix",
                "shell",
                "nixpkgs#texlive.combined.scheme-full",
                "-c",
                "latexmk",
                "-xelatex",
                "-interaction=nonstopmode",
                "-halt-on-error",
                "-jobname=clebsch_factorization",
                "clebsch_factorization.tex",
            ],
            paper_root,
        )
    check_latex_warnings(paper_root / "clebsch_factorization.log")
    print("clebsch factorization release: CHECK OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
