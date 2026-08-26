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
    "paper-ii-structural",
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
    [
        "lean/scripts/guarded-lean",
        "RelativeConicArcs/Gates/ClebschPaperIIStructural.lean",
    ],
]
LEAN_GATE_TERMINALS = 54
EXPECTED_LEAN_TERMINAL_IDENTITY_SHA256 = (
    "52cceb4acebec14579edbe39639e732106ea2a97a91b0a8c83f527f6465e45aa"
)
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
    "paper-ii-structural": {
        "checksum_manifest":
            "verification/paper_ii_structural.sha256",
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
    "lem:projective-trade-reduction": (
        {"conceptual", "lean"},
        {"paper-ii-structural"},
    ),
    "lem:targeted-linear-detectors": (
        {"conceptual", "classical-input"},
        set(),
    ),
    "lem:opposite-parity-quadratic": (
        {"conceptual", "classical-input"},
        set(),
    ),
    "lem:affine-class-contraction": (
        {"conceptual"},
        set(),
    ),
    "lem:uniform-sheet-exclusion": (
        {"conceptual", "classical-input", "certificate", "lean"},
        {"generic-first-wall", "small-field-trade", "paper-ii-structural"},
    ),
    "thm:balanced-orbit-completeness": (
        {"conceptual", "classical-input", "certificate", "lean"},
        {"generic-first-wall", "small-field-trade", "paper-ii-structural"},
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
    "thm:fixed-line-chow-rigidity": (
        {"conceptual", "classical-input", "lean"},
        {"paper-ii-structural"},
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
    matches = re.findall(
        r"'([^']+)' (does not depend on any axioms|depends on axioms: \[(.*?)\])",
        wrapper_output,
        re.DOTALL,
    )
    declarations = [declaration for declaration, _, _ in matches]
    if len(declarations) != LEAN_GATE_TERMINALS:
        raise ValueError("Lean axiom audit terminal count changed")
    if len(set(declarations)) != len(declarations):
        raise ValueError("Lean axiom audit contains duplicate terminals")
    identity = sha256_bytes(
        "".join(f"{name}\n" for name in sorted(declarations)).encode("utf-8")
    )
    if identity != EXPECTED_LEAN_TERMINAL_IDENTITY_SHA256:
        raise ValueError("Lean axiom audit terminal identity changed")
    found_axioms = {
        name
        for _, status, block in matches
        if status.startswith("depends on axioms:")
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


def displayed_fingerprint_sha256(path: Path) -> str:
    text = path.read_text(encoding="utf-8")
    pattern = re.compile(
        r"Its SHA-256 digest is\s*\\begin\{center\}\s*"
        r"\\small\\texttt\{([0-9a-f]{38})\}\\\\\[-2pt\]\s*"
        r"\\texttt\{([0-9a-f]{26})\}"
    )
    matches = pattern.findall(text)
    if len(matches) != 1:
        raise ValueError("expected one displayed evidence-fingerprint digest")
    return "".join(matches[0])


def check_displayed_fingerprint_sha256(paper_root: Path) -> None:
    expected = sha256(paper_root / FINGERPRINT)
    actual = displayed_fingerprint_sha256(
        paper_root / "clebsch_factorization.tex"
    )
    if actual != expected:
        raise ValueError("displayed evidence-fingerprint digest is stale")
    print("displayed evidence-fingerprint digest: CHECK OK")


def update_displayed_fingerprint_sha256(paper_root: Path) -> None:
    source = paper_root / "clebsch_factorization.tex"
    digest = sha256(paper_root / FINGERPRINT)
    pattern = re.compile(
        r"(Its SHA-256 digest is\s*\\begin\{center\}\s*"
        r"\\small\\texttt\{)[0-9a-f]{38}"
        r"(\}\\\\\[-2pt\]\s*\\texttt\{)[0-9a-f]{26}(\})"
    )
    updated, replacements = pattern.subn(
        lambda match: (
            match.group(1) + digest[:38] + match.group(2)
            + digest[38:] + match.group(3)
        ),
        source.read_text(encoding="utf-8"),
    )
    if replacements != 1:
        raise ValueError("expected one displayed evidence-fingerprint digest")
    source.write_text(updated, encoding="utf-8")


def lean_import_closure(repo_root: Path, entry: Path) -> dict[str, str]:
    lean_root = repo_root / "lean"
    pending = [entry]
    seen: set[Path] = set()
    while pending:
        path = pending.pop()
        if path in seen:
            continue
        seen.add(path)
        source = lean_code_without_comments_or_strings(
            path.read_text(encoding="utf-8")
        )
        for line in source.splitlines():
            match = re.fullmatch(r"\s*import\s+(\S+)\s*", line)
            if match is None:
                if re.match(r"\s*import\b", line):
                    raise ValueError(
                        f"unsupported Lean import syntax in {path}: {line.strip()}"
                    )
                continue
            module = match.group(1)
            imported = lean_root / (module.replace(".", "/") + ".lean")
            if imported.is_file():
                pending.append(imported)
            elif module != "Mathlib" and not module.startswith("Mathlib."):
                raise ValueError(f"external Lean import is not pinned: {module}")
    return {
        str(path.relative_to(repo_root)): sha256(path)
        for path in sorted(seen)
    }


def lean_code_without_comments_or_strings(text: str) -> str:
    result: list[str] = []
    index = 0
    block_depth = 0
    in_string = False
    while index < len(text):
        if block_depth:
            if text.startswith("/-", index):
                block_depth += 1
                index += 2
            elif text.startswith("-/", index):
                block_depth -= 1
                index += 2
            else:
                result.append("\n" if text[index] == "\n" else " ")
                index += 1
            continue
        if in_string:
            if text[index] == "\\" and index + 1 < len(text):
                result.extend("  ")
                index += 2
            else:
                if text[index] == '"':
                    in_string = False
                result.append("\n" if text[index] == "\n" else " ")
                index += 1
            continue
        if text.startswith("--", index):
            newline = text.find("\n", index)
            if newline == -1:
                result.extend(" " * (len(text) - index))
                break
            result.extend(" " * (newline - index))
            index = newline
        elif text.startswith("/-", index):
            block_depth = 1
            result.extend("  ")
            index += 2
        elif text[index] == '"':
            in_string = True
            result.append(" ")
            index += 1
        else:
            result.append(text[index])
            index += 1
    if block_depth or in_string:
        raise ValueError("unterminated Lean comment or string in audited closure")
    return "".join(result)


def check_lean_source_policy(closure: dict[str, str], repo_root: Path) -> None:
    modifiers = (
        r"(?:@\[[^\]]*\]\s*|"
        r"(?:private|protected|noncomputable|nonrec|scoped|local)\s+)*"
    )
    forbidden_declaration = re.compile(
        rf"^\s*{modifiers}(?:axiom|opaque|partial|unsafe)\b", re.MULTILINE
    )
    bypass = re.compile(
        r"\bnative_decide\b"
        r"|\brun_tac\b"
        r"|\bdecide\b[^\n]*\+\s*native"
        r"|\bnative\s*:=\s*true"
        r"|(?:@\[|attribute\s*\[)[^\]]*(?:implemented_by|extern)"
        r"|\bofReduceBool\b"
        r"|\bset_option\s+(?:debug\.skipKernelTC|allowUnsafeReducibility"
        r"|debug\.byAsSorry|debug\.proofAsSorry"
        r"|debug\.terminalTacticsAsSorry)",
        re.MULTILINE,
    )
    for relative in closure:
        text = lean_code_without_comments_or_strings(
            (repo_root / relative).read_text(encoding="utf-8")
        )
        if (
            re.search(r"\b(?:sorry|admit)\b", text)
            or forbidden_declaration.search(text)
        ):
            raise ValueError(f"Lean source policy rejected {relative}")
        if bypass.search(text):
            raise ValueError(f"Lean kernel-bypass policy rejected {relative}")


def metadata_success_line(statement_count: int, evidence_count: int) -> str:
    """Render the metadata success line from the counts the runner actually observes."""
    return (
        f"metadata: {statement_count} statements, "
        f"{evidence_count} evidence bundles: CHECK OK"
    )


def build_fingerprint(
    repo_root: Path,
    paper_root: Path,
    manifest: dict[str, object],
    identity: dict[str, object],
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
    gate_paths = (
        repo_root / "lean" / "RelativeConicArcs" / "Gates"
        / "ClebschArithmeticGluing.lean",
        repo_root / "lean" / "RelativeConicArcs" / "Gates"
        / "ClebschHilbertSymmetry.lean",
        repo_root / "lean" / "RelativeConicArcs" / "Gates"
        / "ClebschHyperplaneSquare.lean",
        repo_root / "lean" / "RelativeConicArcs" / "Gates"
        / "ClebschPaperIIStructural.lean",
    )
    gate_closures = {
        path.name: lean_import_closure(repo_root, path) for path in gate_paths
    }
    combined_closure = {
        relative: digest
        for closure in gate_closures.values()
        for relative, digest in closure.items()
    }
    check_lean_source_policy(combined_closure, repo_root)
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
            "release_boundary_checker": sha256(
                paper_root / "verification" / "check_release_boundary.py"
            ),
            "manuscript_checker": sha256(
                paper_root / "verification" / "check_manuscript_build.py"
            ),
            "paper_flake_nix": sha256(paper_root / "flake.nix"),
            "paper_flake_lock": sha256(paper_root / "flake.lock"),
            "paper_readme": sha256(paper_root / "README.md"),
            "verification_readme": sha256(
                paper_root / "verification" / "README.md"
            ),
            "evidence_manifest_tool": sha256(
                paper_root / "verification" / "evidence" / "manifest.py"
            ),
            "lean_gates": {
                path.name: sha256(path) for path in gate_paths
            },
            "guarded_lean": sha256(repo_root / "lean" / "scripts" / "guarded-lean"),
        },
        "project_lean_import_closure_sha256": gate_closures,
        "lean_gates": [
            {"command": command, "cwd": "."}
            for command in LEAN_GATE_COMMANDS
        ],
        "evidence": bundle_fingerprints,
        "expected_success": {
            "metadata": metadata_success_line(
                len({statement["label"] for statement in identity["statements"]}),
                len(manifest["evidence"]),
            ),
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
        "release_boundary_checker": sha256(
            paper_root / "verification" / "check_release_boundary.py"
        ),
        "manuscript_checker": sha256(
            paper_root / "verification" / "check_manuscript_build.py"
        ),
        "paper_flake_nix": sha256(paper_root / "flake.nix"),
        "paper_flake_lock": sha256(paper_root / "flake.lock"),
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
    run(
        [
            "python3",
            "verification/generate_sparse_shadow_export.py",
            "--check",
            "verification/evidence/sparse_shadow_export.json",
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
        fingerprint = build_fingerprint(repo_root, paper_root, manifest, identity)
        fingerprint_rendered = json.dumps(fingerprint, indent=2) + "\n"
        if args.update_fingerprint:
            fingerprint_path.write_text(fingerprint_rendered, encoding="utf-8")
            print(f"wrote {fingerprint_path}")
            update_displayed_fingerprint_sha256(paper_root)
            run(
                [
                    "python3",
                    str(
                        paper_root / "verification"
                        / "extract_statement_identity.py"
                    ),
                ],
                paper_root,
            )
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
    check_displayed_fingerprint_sha256(paper_root)
    if formal_available:
        run(
            [
                "python3",
                str(
                    paper_root / "verification"
                    / "check_release_boundary.py"
                ),
                "--repo-root",
                str(repo_root),
                "--paper-root",
                str(paper_root),
            ],
            paper_root,
        )
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
            EXTERNAL_FORMAL_EVIDENCE & set(claim["evidence"])
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
    metadata_line = metadata_success_line(len(statement_labels), len(evidence))
    expected_success = fingerprint.get("expected_success", {})
    if not isinstance(expected_success, dict):
        raise ValueError("evidence fingerprint has no expected-success block")
    if expected_success.get("metadata") != metadata_line:
        raise ValueError(
            "evidence fingerprint pins a stale expected metadata line: "
            f"{expected_success.get('metadata')!r} does not match {metadata_line!r}"
        )
    print(metadata_line)

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
    # Deterministic rebuild in a scratch directory, compared byte for byte against the
    # tracked PDF.  The previous in-place build refreshed that PDF as a side effect, so a
    # manuscript edit committed without rebuilding it could never be detected here.  The
    # checker rejects TeX warnings and the page count itself.
    run(
        [
            "nix",
            "develop",
            ".#manuscript-cas-full",
            "--command",
            "python3",
            "verification/check_manuscript_build.py",
        ],
        paper_root,
    )
    print("clebsch factorization release: CHECK OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
