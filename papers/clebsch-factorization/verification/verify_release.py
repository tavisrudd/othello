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
LEAN_GATE_COMMAND = [
    "lean/scripts/guarded-lean",
    "RelativeConicArcs/Gates/ClebschArithmeticGluing.lean",
]
EXPECTED_EVIDENCE = {
    "matching-module": {
        "checksum_manifest": "notes/2026-07-20-c406-matching-module.sha256",
        "commands": [
            ["python3", "notes/2026-07-20-c406-matching-module.py", "--check"],
            ["python3", "notes/2026-07-20-c406-matching-module-replay.py"],
        ],
    },
    "h3-equivariant-rank": {
        "checksum_manifest":
            "notes/2026-07-25-c616-h3-equivariant-rank.sha256",
        "commands": [
            [
                "python3",
                "notes/2026-07-25-c616-h3-equivariant-rank.py",
                "--check",
            ],
            [
                "python3",
                "notes/2026-07-25-c616-h3-equivariant-rank-replay.py",
            ],
        ],
    },
    "balanced-sheet": {
        "checksum_manifest":
            "notes/2026-07-20-c430-conceptual-balanced-half-rigidity.sha256",
        "commands": [
            [
                "python3",
                "notes/2026-07-20-c430-conceptual-balanced-half-rigidity.py",
                "--check",
            ],
            [
                "python3",
                "notes/2026-07-20-c430-conceptual-balanced-half-rigidity-replay.py",
                "--check",
            ],
        ],
    },
    "gorenstein-gate": {
        "checksum_manifest": "notes/2026-07-25-c621-gorenstein-gate.sha256",
        "commands": [
            [
                "python3",
                "notes/2026-07-25-c621-gorenstein-gate.py",
                "--check",
            ],
            ["python3", "notes/2026-07-25-c621-gorenstein-gate-replay.py"],
        ],
    },
    "profile-incidence": {
        "checksum_manifest": "notes/2026-07-20-c411-double-coset-hecke.sha256",
        "commands": [
            ["python3", "notes/2026-07-20-c411-double-coset-hecke.py", "--check"],
            ["python3", "notes/2026-07-20-c411-double-coset-hecke-replay.py"],
        ],
    },
    "decorated-parent": {
        "checksum_manifest":
            "notes/2026-07-19-c379-clebsch-deep-hole-extension.sha256",
        "commands": [
            [
                "python3",
                "notes/2026-07-19-c379-clebsch-deep-hole-extension.py",
                "--check",
            ],
            ["python3", "notes/2026-07-19-c379-clebsch-deep-hole-extension-replay.py"],
        ],
    },
    "relative-cubic-depth": {
        "checksum_manifest":
            "notes/2026-07-20-c412-relative-cubic-depth-plane.sha256",
        "commands": [
            [
                "python3",
                "notes/2026-07-20-c412-relative-cubic-depth-plane.py",
                "--check",
            ],
            ["python3", "notes/2026-07-20-c412-relative-cubic-depth-plane-replay.py"],
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
}
EXPECTED_CLAIMS = {
    "thm:factorization-recovery": (
        {"conceptual", "classical-input", "certificate"},
        {"matching-module", "h3-equivariant-rank", "balanced-sheet",
         "gorenstein-gate", "profile-incidence", "decorated-parent"},
    ),
    "prop:matching-secant-quotient": ({"conceptual"}, set()),
    "thm:rank-three-quotients": (
        {"conceptual", "classical-input", "certificate"},
        {"matching-module", "h3-equivariant-rank"},
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
    "thm:balanced-cubic": (
        {"conceptual", "certificate"},
        {"matching-module", "balanced-sheet"},
    ),
    "cor:graded-evaluation": (
        {"conceptual", "certificate"},
        {"matching-module", "balanced-sheet"},
    ),
    "cor:self-associated-gorenstein": (
        {"conceptual", "classical-input", "certificate"},
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
        {"certificate"},
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
    repo_root: Path, relative: str, checksum_root: str = "."
) -> None:
    relative_path = PurePosixPath(relative)
    if relative_path.is_absolute() or ".." in relative_path.parts:
        raise ValueError(f"unsafe checksum-manifest path: {relative}")
    root_path = PurePosixPath(checksum_root)
    if root_path.is_absolute() or ".." in root_path.parts:
        raise ValueError(f"unsafe checksum root: {checksum_root}")
    manifest = repo_root / relative
    artifact_root = repo_root / root_path
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


def run(command: list[str], cwd: Path) -> None:
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


def build_fingerprint(
    repo_root: Path, paper_root: Path, manifest: dict[str, object]
) -> dict[str, object]:
    bundle_fingerprints = {}
    for name, item in manifest["evidence"].items():
        checksum_manifest = repo_root / item["checksum_manifest"]
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
            "paper_makefile": sha256(paper_root.parent / "Makefile"),
            "verification_readme": sha256(
                paper_root / "verification" / "README.md"
            ),
            "lean_gate": sha256(
                repo_root / "lean" / "RelativeConicArcs" / "Gates"
                / "ClebschArithmeticGluing.lean"
            ),
        },
        "lean_gate": {
            "command": LEAN_GATE_COMMAND,
            "cwd": ".",
        },
        "evidence": bundle_fingerprints,
        "expected_success": {
            "metadata": "metadata: 20 statements, 8 evidence bundles: CHECK OK",
            "release": "clebsch factorization release: CHECK OK",
        },
    }


def main() -> int:
    paper_root = Path(__file__).resolve().parents[1]
    repo_root = paper_root.parents[1]
    parser = argparse.ArgumentParser()
    parser.add_argument("--metadata-only", action="store_true")
    parser.add_argument("--update-fingerprint", action="store_true")
    args = parser.parse_args()

    run(
        [
            "python3",
            str(paper_root / "verification" / "extract_statement_identity.py"),
            "--check",
        ],
        repo_root,
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
        if "lean" in modes and "arithmetic-gluing" not in claim["evidence"]:
            raise ValueError(f"{claim['label']}: Lean mode has no Lean evidence")
        expected_modes, expected_bundles = EXPECTED_CLAIMS[claim["label"]]
        if modes != expected_modes or set(claim["evidence"]) != expected_bundles:
            raise ValueError(f"{claim['label']}: proof-mode/evidence coverage changed")
    for item in evidence.values():
        check_checksum_manifest(
            repo_root, item["checksum_manifest"], item.get("checksum_root", ".")
        )
    print(
        f"metadata: {len(statement_labels)} statements, "
        f"{len(evidence)} evidence bundles: CHECK OK"
    )

    if args.metadata_only:
        return 0
    for item in evidence.values():
        for command in item["commands"]:
            run(command, repo_root)
    run(LEAN_GATE_COMMAND, repo_root)
    run(["make", "-B", "clebsch-factorization"], repo_root / "papers")
    print("clebsch factorization release: CHECK OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
