#!/usr/bin/env python3
"""Build or verify the paper-local computational evidence bundle.

``--build`` copies an explicit allowlist from the development repository into
stable public paths and writes canonical machine-readable and Markdown
manifests.  ``--check`` needs only the paper directory: it hashes every bundled
artifact and verifies its byte count against the committed manifest.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import shutil
from pathlib import Path


BUNDLES = (
    (
        "Certificate R5",
        "r5",
        (
            ("generator", "2026-07-22-c491-prs-deep-hole-census.py", "2026-07-22-c491-prs-deep-hole-census.py", "rederive"),
            ("certificate", "2026-07-22-c491-prs-deep-hole-census.json", "2026-07-22-c491-prs-deep-hole-census.json", "compare"),
            ("replay", "2026-07-22-c491-prs-deep-hole-replay.py", "2026-07-22-c491-prs-deep-hole-replay.py", "rederive"),
            ("checksum", "2026-07-22-c491-prs-redundancy-five.sha256", "2026-07-22-c491-prs-redundancy-five.sha256", "compare"),
        ),
    ),
    (
        "Certificate R6",
        "r6",
        (
            ("generator", "2026-07-22-c498-prs-deep-hole-census.rs", "2026-07-22-c498-prs-deep-hole-census.rs", "rederive"),
            ("certificate", "2026-07-22-c498-prs-deep-hole-census.json", "2026-07-22-c498-prs-deep-hole-census.json", "compare"),
            ("replay", "2026-07-22-c498-prs-deep-hole-replay.py", "2026-07-22-c498-prs-deep-hole-replay.py", "reconstruct"),
            ("checksum", "2026-07-22-c498-prs-redundancy-six.sha256", "2026-07-22-c498-prs-redundancy-six.sha256", "compare"),
        ),
    ),
    (
        "Certificate R6-NF",
        "r6-normal-forms",
        (
            ("generator-checker", "2026-07-23-c498-small-exceptional-normal-forms.py", "2026-07-23-c498-small-exceptional-normal-forms.py", "rederive"),
            ("certificate", "2026-07-23-c498-small-exceptional-normal-forms.json", "2026-07-23-c498-small-exceptional-normal-forms.json", "compare"),
            ("checksum", "2026-07-23-c498-small-exceptional-normal-forms.sha256", "2026-07-23-c498-small-exceptional-normal-forms.sha256", "compare"),
        ),
    ),
    (
        "Certificate R7",
        "r7",
        (
            ("generator", "2026-07-23-c509-prs-deep-hole-calibration.py", "2026-07-23-c509-prs-deep-hole-calibration.py", "rederive"),
            ("certificate", "2026-07-23-c509-prs-deep-hole-calibration.json", "2026-07-23-c509-prs-deep-hole-calibration.json", "compare"),
            ("replay", "2026-07-23-c509-prs-deep-hole-calibration-replay.py", "2026-07-23-c509-prs-deep-hole-calibration-replay.py", "rederive"),
            ("checksum", "2026-07-23-c509-prs-redundancy-seven.sha256", "2026-07-23-c509-prs-redundancy-seven.sha256", "compare"),
        ),
    ),
    (
        "Certificate R8",
        "r8",
        (
            ("generator", "2026-07-23-c513-prs-redundancy-eight.py", "2026-07-23-c513-prs-redundancy-eight.py", "rederive"),
            ("certificate", "2026-07-23-c513-prs-redundancy-eight.json", "2026-07-23-c513-prs-redundancy-eight.json", "compare"),
            ("replay", "2026-07-23-c513-prs-redundancy-eight-replay.py", "2026-07-23-c513-prs-redundancy-eight-replay.py", "rederive"),
            ("checksum", "2026-07-23-c513-prs-redundancy-eight.sha256", "2026-07-23-c513-prs-redundancy-eight.sha256", "compare"),
        ),
    ),
    (
        "Certificate R9",
        "r9",
        (
            ("generator", "2026-07-23-c516-prs-redundancy-nine.py", "2026-07-23-c516-prs-redundancy-nine.py", "rederive"),
            ("certificate", "2026-07-23-c516-prs-redundancy-nine.json", "2026-07-23-c516-prs-redundancy-nine.json", "compare"),
            ("replay", "2026-07-23-c516-prs-redundancy-nine-replay.py", "2026-07-23-c516-prs-redundancy-nine-replay.py", "rederive"),
            ("checksum", "2026-07-23-c516-prs-redundancy-nine.sha256", "2026-07-23-c516-prs-redundancy-nine.sha256", "compare"),
        ),
    ),
    (
        "Certificate R9-49",
        "r9-q49",
        (
            ("generator", "2026-07-23-c516-prs-redundancy-nine-q49.rs", "2026-07-23-c516-prs-redundancy-nine-q49.rs", "rederive"),
            ("certificate", "2026-07-23-c516-prs-redundancy-nine-q49.txt", "2026-07-23-c516-prs-redundancy-nine-q49.txt", "compare"),
        ),
    ),
    (
        "Certificate Hessian",
        "hessian",
        (
            ("generator", "2026-07-23-c525-ordered-hessian-arf-pullback.py", "2026-07-23-c525-ordered-hessian-arf-pullback.py", "rederive"),
            ("certificate", "2026-07-23-c525-ordered-hessian-arf-pullback.json", "2026-07-23-c525-ordered-hessian-arf-pullback.json", "compare"),
            ("replay", "2026-07-23-c525-ordered-hessian-arf-pullback-replay.py", "2026-07-23-c525-ordered-hessian-arf-pullback-replay.py", "rederive"),
            ("checksum", "2026-07-23-c525-ordered-hessian-arf-pullback.sha256", "2026-07-23-c525-ordered-hessian-arf-pullback.sha256", "compare"),
        ),
    ),
    (
        "Certificate Lucas",
        "lucas",
        (
            ("generator", "2026-07-23-c529-characteristic-two-lucas-carrier-arithmetic.py", "2026-07-23-c529-characteristic-two-lucas-carrier-arithmetic.py", "rederive"),
            ("certificate", "2026-07-23-c529-characteristic-two-lucas-carrier-arithmetic.json", "2026-07-23-c529-characteristic-two-lucas-carrier-arithmetic.json", "compare"),
            ("replay", "2026-07-23-c529-characteristic-two-lucas-carrier-arithmetic-replay.py", "2026-07-23-c529-characteristic-two-lucas-carrier-arithmetic-replay.py", "rederive"),
            ("checksum", "2026-07-23-c529-characteristic-two-lucas-carrier-arithmetic.sha256", "2026-07-23-c529-characteristic-two-lucas-carrier-arithmetic.sha256", "compare"),
        ),
    ),
    (
        "Certificate e7",
        "e7",
        (
            ("generator", "2026-07-23-c530-degree-nine-lucas-e7-quotient-cover.py", "2026-07-23-c530-degree-nine-lucas-e7-quotient-cover.py", "rederive"),
            ("certificate", "2026-07-23-c530-degree-nine-lucas-e7-quotient-cover.json", "2026-07-23-c530-degree-nine-lucas-e7-quotient-cover.json", "compare"),
            ("replay", "2026-07-23-c530-degree-nine-lucas-e7-quotient-cover-replay.py", "2026-07-23-c530-degree-nine-lucas-e7-quotient-cover-replay.py", "rederive"),
            ("checksum", "2026-07-23-c530-degree-nine-lucas-e7-quotient-cover.sha256", "2026-07-23-c530-degree-nine-lucas-e7-quotient-cover.sha256", "compare"),
        ),
    ),
)

TOOLCHAIN_LOCKS = (
    ("Lean toolchain", "papers/beyond4_prs/lean-toolchain", "toolchain/lean-toolchain"),
    ("Lake dependency lock", "lean/lake-manifest.json", "toolchain/lake-manifest.json"),
    ("Nix dependency lock", "papers/beyond4_prs/flake.lock", "toolchain/export-flake.lock"),
    ("Nix environment", "papers/beyond4_prs/flake.nix", "toolchain/export-flake.nix"),
    ("Rust dependency lock", "rust/Cargo.lock", "toolchain/Cargo.lock"),
)

PUBLIC_SUPPLEMENT_FILES = (
    ("Bundle verifier", "package_evidence_bundle.py"),
    ("Top-level verifier", "verify.py"),
    ("Classification-record builder", "build_classification_records.py"),
    ("Classification records", "CLASSIFICATION-RECORDS.json"),
    ("Classification-record guide", "CLASSIFICATION-RECORDS.md"),
    ("Classification-record checksums", "CLASSIFICATION-RECORDS.sha256"),
    ("Certificate schema", "CERTIFICATE-SCHEMA.md"),
    ("Reproduction guide", "REPRODUCING.md"),
    ("Residual-slice data", "R9-SLICE-DATA.md"),
    ("Lean statement-adequacy source", "LEAN-STATEMENTS.md"),
)

AUXILIARY_COPIES = (
    (
        "Certificate R6-NF",
        "dependency-replay",
        "notes/2026-07-22-c498-prs-deep-hole-replay.py",
        "evidence/r6-normal-forms/2026-07-22-c498-prs-deep-hole-replay.py",
        "reconstruct",
    ),
    (
        "Certificate R6-NF",
        "dependency-certificate",
        "notes/2026-07-22-c498-prs-deep-hole-census.json",
        "evidence/r6-normal-forms/2026-07-22-c498-prs-deep-hole-census.json",
        "compare",
    ),
    (
        "Certificate R7",
        "dependency-replay",
        "notes/2026-07-22-c498-prs-deep-hole-replay.py",
        "evidence/r7/2026-07-22-c498-prs-deep-hole-replay.py",
        "reconstruct",
    ),
    (
        "Certificate R9",
        "slice-data mirror",
        "papers/beyond4_prs/supplement/R9-SLICE-DATA.md",
        "evidence/papers/beyond4_prs/supplement/R9-SLICE-DATA.md",
        "compare",
    ),
)


def digest(path: Path) -> tuple[str, int]:
    data = path.read_bytes()
    return hashlib.sha256(data).hexdigest(), len(data)


def expected_entries(supplement: Path) -> list[dict[str, object]]:
    entries: list[dict[str, object]] = []
    for label, slug, files in BUNDLES:
        for role, _source, public_name, replay_class in files:
            relative = Path("evidence") / slug / public_name
            sha256, size = digest(supplement / relative)
            entries.append(
                {
                    "public_label": label,
                    "role": role,
                    "path": relative.as_posix(),
                    "sha256": sha256,
                    "bytes": size,
                    "replay_class": replay_class,
                }
            )
    for role, _source, public_path in TOOLCHAIN_LOCKS:
        relative = Path(public_path)
        sha256, size = digest(supplement / relative)
        entries.append(
            {
                "public_label": "Toolchain",
                "role": role,
                "path": relative.as_posix(),
                "sha256": sha256,
                "bytes": size,
                "replay_class": "compare",
            }
        )
    for role, public_path in PUBLIC_SUPPLEMENT_FILES:
        relative = Path(public_path)
        sha256, size = digest(supplement / relative)
        entries.append(
            {
                "public_label": "Supplement",
                "role": role,
                "path": relative.as_posix(),
                "sha256": sha256,
                "bytes": size,
                "replay_class": "compare",
            }
        )
    for label, role, _source, public_path, replay_class in AUXILIARY_COPIES:
        relative = Path(public_path)
        sha256, size = digest(supplement / relative)
        entries.append(
            {
                "public_label": label,
                "role": role,
                "path": relative.as_posix(),
                "sha256": sha256,
                "bytes": size,
                "replay_class": replay_class,
            }
        )
    entries.sort(key=lambda row: (str(row["public_label"]), str(row["path"])))
    return entries


def manifest_text(entries: list[dict[str, object]]) -> str:
    payload = {
        "schema": "beyond-four-prs-evidence-manifest-v1",
        "hash": "sha256",
        "path_base": "supplement",
        "entries": entries,
    }
    return json.dumps(payload, indent=2, sort_keys=True) + "\n"


def rows_text(entries: list[dict[str, object]]) -> str:
    lines = [
        "# Evidence artifact rows",
        "",
        "Generated by `package_evidence_bundle.py --build`; verified by",
        "`package_evidence_bundle.py --check`.",
        "",
        "| Public label | Role | Stable archive path | SHA-256 | Bytes | Replay class |",
        "|---|---|---|---|---:|---|",
    ]
    for row in entries:
        lines.append(
            f"| {row['public_label']} | {row['role']} | "
            f"`supplement/{row['path']}` | `{row['sha256']}` | "
            f"{row['bytes']} | {row['replay_class']} |"
        )
    return "\n".join(lines) + "\n"


def write_manifests(supplement: Path, entries: list[dict[str, object]]) -> None:
    (supplement / "EVIDENCE-MANIFEST.json").write_text(
        manifest_text(entries), encoding="utf-8"
    )
    (supplement / "EVIDENCE-ROWS.md").write_text(
        rows_text(entries), encoding="utf-8"
    )


def build(development_root: Path, supplement: Path) -> None:
    source_dir = development_root / "notes"
    evidence_root = supplement / "evidence"
    if evidence_root.exists():
        shutil.rmtree(evidence_root)
    toolchain_root = supplement / "toolchain"
    if toolchain_root.exists():
        shutil.rmtree(toolchain_root)
    for _label, slug, files in BUNDLES:
        target_dir = supplement / "evidence" / slug
        target_dir.mkdir(parents=True, exist_ok=True)
        for _role, source_name, public_name, _replay_class in files:
            shutil.copyfile(source_dir / source_name, target_dir / public_name)
    for _role, source_name, public_path in TOOLCHAIN_LOCKS:
        target = supplement / public_path
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(development_root / source_name, target)
    for _label, _role, source_name, public_path, _replay_class in AUXILIARY_COPIES:
        target = supplement / public_path
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(development_root / source_name, target)
    write_manifests(supplement, expected_entries(supplement))


def check(supplement: Path) -> None:
    manifest_path = supplement / "EVIDENCE-MANIFEST.json"
    recorded_text = manifest_path.read_text(encoding="utf-8")
    recorded = json.loads(recorded_text)
    if recorded.get("schema") != "beyond-four-prs-evidence-manifest-v1":
        raise SystemExit("unsupported evidence-manifest schema")
    actual = expected_entries(supplement)
    if actual != recorded.get("entries"):
        raise SystemExit("bundled evidence differs from EVIDENCE-MANIFEST.json")
    if recorded_text != manifest_text(actual):
        raise SystemExit("EVIDENCE-MANIFEST.json is not canonical")
    expected_rows = rows_text(actual)
    if (supplement / "EVIDENCE-ROWS.md").read_text(encoding="utf-8") != expected_rows:
        raise SystemExit("EVIDENCE-ROWS.md is not canonical")
    print(f"verified {len(actual)} bundled evidence artifacts")


def main() -> None:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--build", action="store_true")
    mode.add_argument("--check", action="store_true")
    parser.add_argument(
        "--development-root",
        type=Path,
        default=Path(__file__).resolve().parents[3],
        help="development repository root used only by --build",
    )
    args = parser.parse_args()
    supplement = Path(__file__).resolve().parent
    if args.build:
        build(args.development_root.resolve(), supplement)
    else:
        check(supplement)


if __name__ == "__main__":
    main()
