#!/usr/bin/env python3
"""Record or verify the paper-local computational evidence bundle.

``--write`` refreshes the canonical manifests from the present public evidence
tree. ``--check`` hashes every bundled artifact and verifies its byte count
against the committed manifest. Both modes need only the standalone paper
repository.
"""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path


BUNDLES = (
    (
        "Certificate R5",
        "r5",
        (
            ("generator", "2026-07-22-prs-deep-hole-census.py", "2026-07-22-prs-deep-hole-census.py", "rederive"),
            ("certificate", "2026-07-22-prs-deep-hole-census.json", "2026-07-22-prs-deep-hole-census.json", "compare"),
            ("replay", "2026-07-22-redundancy-five-deep-hole-replay.py", "2026-07-22-redundancy-five-deep-hole-replay.py", "rederive"),
            ("checksum", "2026-07-22-prs-redundancy-five.sha256", "2026-07-22-prs-redundancy-five.sha256", "compare"),
        ),
    ),
    (
        "Certificate R6",
        "r6",
        (
            ("generator", "2026-07-22-prs-deep-hole-census.rs", "2026-07-22-prs-deep-hole-census.rs", "rederive"),
            ("certificate", "2026-07-22-prs-deep-hole-census.json", "2026-07-22-prs-deep-hole-census.json", "compare"),
            ("replay", "2026-07-22-redundancy-six-deep-hole-replay.py", "2026-07-22-redundancy-six-deep-hole-replay.py", "reconstruct"),
            ("checksum", "2026-07-22-prs-redundancy-six.sha256", "2026-07-22-prs-redundancy-six.sha256", "compare"),
        ),
    ),
    (
        "Certificate R6-NF",
        "r6-normal-forms",
        (
            ("generator-checker", "2026-07-23-small-exceptional-normal-forms.py", "2026-07-23-small-exceptional-normal-forms.py", "rederive"),
            ("certificate", "2026-07-23-small-exceptional-normal-forms.json", "2026-07-23-small-exceptional-normal-forms.json", "compare"),
            ("checksum", "2026-07-23-small-exceptional-normal-forms.sha256", "2026-07-23-small-exceptional-normal-forms.sha256", "compare"),
        ),
    ),
    (
        "Certificate R7",
        "r7",
        (
            ("generator", "2026-07-23-prs-deep-hole-calibration.py", "2026-07-23-prs-deep-hole-calibration.py", "rederive"),
            ("certificate", "2026-07-23-prs-deep-hole-calibration.json", "2026-07-23-prs-deep-hole-calibration.json", "compare"),
            ("replay", "2026-07-23-prs-deep-hole-calibration-replay.py", "2026-07-23-prs-deep-hole-calibration-replay.py", "rederive"),
            ("independent-arithmetic-replay", "2026-07-26-r7-independent-arithmetic-replay.py", "2026-07-26-r7-independent-arithmetic-replay.py", "reconstruct"),
            ("independent-direct-locus-replay", "2026-07-26-r7-direct-locus-replay.py", "2026-07-26-r7-direct-locus-replay.py", "rederive"),
            ("independent-direct-locus-certificate", "2026-07-26-r7-direct-locus-replay.json", "2026-07-26-r7-direct-locus-replay.json", "compare"),
            ("checksum", "2026-07-23-prs-redundancy-seven.sha256", "2026-07-23-prs-redundancy-seven.sha256", "compare"),
        ),
    ),
    (
        "Companion Certificate SC",
        "stable-components",
        (
            ("generator-checker", "2026-07-24-r10-integral-bad-scheme-sc11.py", "2026-07-24-r10-integral-bad-scheme-sc11.py", "rederive"),
            ("certificate", "2026-07-24-r10-integral-bad-scheme-sc11.json", "2026-07-24-r10-integral-bad-scheme-sc11.json", "compare"),
            ("scheme-checker", "2026-07-24-r10-integral-bad-scheme-sc11.sing", "2026-07-24-r10-integral-bad-scheme-sc11.sing", "rederive"),
            ("checksum", "2026-07-24-r10-integral-bad-scheme-sc11.sha256", "2026-07-24-r10-integral-bad-scheme-sc11.sha256", "compare"),
            ("fano-generator-checker", "2026-07-24-stable-component-fano-elimination.py", "2026-07-24-stable-component-fano-elimination.py", "rederive"),
            ("fano-certificate", "2026-07-24-stable-component-fano-elimination.json", "2026-07-24-stable-component-fano-elimination.json", "compare"),
            ("fano-scheme-checker", "2026-07-24-stable-component-fano-elimination.sing", "2026-07-24-stable-component-fano-elimination.sing", "rederive"),
            ("fano-checksum", "2026-07-24-stable-component-fano-elimination.sha256", "2026-07-24-stable-component-fano-elimination.sha256", "compare"),
        ),
    ),
)

TOOLCHAIN_LOCKS = (
    ("Lean toolchain", "toolchain/lean-toolchain"),
    ("Lake dependency lock", "toolchain/lake-manifest.json"),
    ("Nix dependency lock", "toolchain/export-flake.lock"),
    ("Nix environment", "toolchain/export-flake.nix"),
    ("Rust dependency lock", "toolchain/Cargo.lock"),
)

PUBLIC_SUPPLEMENT_FILES = (
    ("Bundle verifier", "package_evidence_bundle.py"),
    ("Top-level verifier", "verify.py"),
    ("Release-export builder", "prepare_release_export.py"),
    ("Classification-record builder", "build_classification_records.py"),
    ("R6 paper-table builder", "build_r6_paper_table.py"),
    ("Classification records", "CLASSIFICATION-RECORDS.json"),
    ("Classification-record guide", "CLASSIFICATION-RECORDS.md"),
    ("Classification-record checksums", "CLASSIFICATION-RECORDS.sha256"),
    ("Certificate schema", "CERTIFICATE-SCHEMA.md"),
    ("Reproduction guide", "REPRODUCING.md"),
    ("Lean statement-adequacy source", "LEAN-STATEMENTS.md"),
    ("Independent final-reader signoff", "FINAL-READER-SIGNOFF.md"),
)

AUXILIARY_COPIES = (
    (
        "Certificate R6-NF",
        "dependency-replay",
        "evidence/r6-normal-forms/2026-07-22-redundancy-six-deep-hole-replay.py",
        "reconstruct",
    ),
    (
        "Certificate R6-NF",
        "dependency-certificate",
        "evidence/r6-normal-forms/2026-07-22-prs-deep-hole-census.json",
        "compare",
    ),
    (
        "Certificate R7",
        "dependency-replay",
        "evidence/r7/2026-07-22-redundancy-six-deep-hole-replay.py",
        "reconstruct",
    ),
    (
        "Certificate R7",
        "dependency-r5-field-replay",
        "evidence/r7/2026-07-22-redundancy-five-deep-hole-replay.py",
        "reconstruct",
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
    for role, public_path in TOOLCHAIN_LOCKS:
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
    for label, role, public_path, replay_class in AUXILIARY_COPIES:
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
        "Generated by `package_evidence_bundle.py --write`; verified by",
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
    mode.add_argument("--check", action="store_true")
    mode.add_argument(
        "--write",
        action="store_true",
        help="refresh canonical manifests from the current public evidence tree",
    )
    args = parser.parse_args()
    supplement = Path(__file__).resolve().parent
    if args.write:
        write_manifests(supplement, expected_entries(supplement))
    else:
        check(supplement)


if __name__ == "__main__":
    main()
