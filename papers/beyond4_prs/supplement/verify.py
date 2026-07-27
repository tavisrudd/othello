#!/usr/bin/env python3
"""Verify the paper-local supplement from one entry point."""

from __future__ import annotations

import argparse
import hashlib
import re
import subprocess
import sys
from pathlib import Path


SUPPLEMENT = Path(__file__).resolve().parent
PAPER = SUPPLEMENT.parent
REPOSITORY = PAPER.parents[1]
LOCAL_MANIFEST_ARTIFACTS = (
    "EVIDENCE-MANIFEST.json",
    "EVIDENCE-ROWS.md",
    "package_evidence_bundle.py",
    "verify.py",
    "build_r6_paper_table.py",
)
AGGREGATE = (
    REPOSITORY
    / "lean/RelativeConicArcs/Gates/PRSBeyondRedundancyFour.lean"
)
AXIOM_AUDIT = (
    REPOSITORY
    / "lean/RelativeConicArcs/Gates/PRSBeyondRedundancyFourAxiomAudit.lean"
)
EXPECTED_AGGREGATE_IMPORTS = (
    "RelativeConicArcs.Gates.PRSFoundation",
    "RelativeConicArcs.Gates.PRSRedundancyFive",
    "RelativeConicArcs.Gates.PRSPolarInductionRedundancySixSeven",
    "RelativeConicArcs.Gates.PRSStableComponents",
    "RelativeConicArcs.PRSUniformCoveringRadius",
)
EXPECTED_PROJECT_CLOSURE = (
    "RelativeConicArcs.Gates.PRSBeyondRedundancyFour",
    "RelativeConicArcs.Gates.PRSBeyondRedundancyFourAxiomAudit",
    "RelativeConicArcs.Gates.PRSFoundation",
    "RelativeConicArcs.Gates.PRSPolarInductionRedundancySixSeven",
    "RelativeConicArcs.Gates.PRSRedundancyFive",
    "RelativeConicArcs.Gates.PRSStableComponents",
    "RelativeConicArcs.PRSContraction",
    "RelativeConicArcs.PRSFoundation",
    "RelativeConicArcs.PRSPolarInduction",
    "RelativeConicArcs.PRSRedundancyFive",
    "RelativeConicArcs.PRSRedundancyFiveCertificate",
    "RelativeConicArcs.PRSRedundancyFiveCertified",
    "RelativeConicArcs.PRSRedundancySixSeven",
    "RelativeConicArcs.PRSRedundancySixSevenCertificate",
    "RelativeConicArcs.PRSSquarefreeMarkerDensity",
    "RelativeConicArcs.PRSStableComponents",
    "RelativeConicArcs.PRSUniformCoveringRadius",
)
EXPECTED_AXIOM_TARGET_COUNT = 74
EXPECTED_AXIOM_TARGET_SHA256 = (
    "8411874478983746739dc8111dec9b3252d5c45ae456a0d7e9944b8323a65683"
)


def digest(path: Path) -> tuple[str, int]:
    data = path.read_bytes()
    return hashlib.sha256(data).hexdigest(), len(data)


def run(command: list[str], cwd: Path = PAPER) -> None:
    print(f"+ {' '.join(command)}", flush=True)
    subprocess.run(command, cwd=cwd, check=True)


def check_classification_hashes() -> None:
    checksum_file = SUPPLEMENT / "CLASSIFICATION-RECORDS.sha256"
    for line in checksum_file.read_text(encoding="utf-8").splitlines():
        expected, relative = line.split(maxsplit=1)
        path = SUPPLEMENT / relative
        actual = hashlib.sha256(path.read_bytes()).hexdigest()
        if actual != expected:
            raise SystemExit(f"SHA-256 mismatch: {path}")
    print("verified classification-record hashes")


def check_release_manifest() -> None:
    manifest = (SUPPLEMENT / "RELEASE-MANIFEST.md").read_text(encoding="utf-8")

    def field(label: str) -> str:
        match = re.search(
            rf"^\| {re.escape(label)} \| `([^`]+)` \|$",
            manifest,
            flags=re.MULTILINE,
        )
        if match is None:
            raise SystemExit(f"missing release-manifest field: {label}")
        return match.group(1)

    pdf_name = field("PDF artifact")
    pdf = PAPER / pdf_name
    pdf_hash, pdf_bytes = digest(pdf)
    if field("Local built PDF SHA-256") != pdf_hash:
        raise SystemExit("release manifest has stale local PDF SHA-256")
    if int(field("Local built PDF bytes")) != pdf_bytes:
        raise SystemExit("release manifest has stale local PDF byte count")

    for relative in LOCAL_MANIFEST_ARTIFACTS:
        match = re.search(
            rf"^\| `{re.escape(relative)}` \| `([0-9a-f]{{64}})` \| ([0-9]+) \|$",
            manifest,
            flags=re.MULTILINE,
        )
        if match is None:
            raise SystemExit(f"missing release-manifest artifact row: {relative}")
        actual_hash, actual_bytes = digest(SUPPLEMENT / relative)
        if match.group(1) != actual_hash or int(match.group(2)) != actual_bytes:
            raise SystemExit(f"stale release-manifest artifact row: {relative}")
    print("verified release-manifest local artifact rows")


def write_local_release_manifest() -> None:
    path = SUPPLEMENT / "RELEASE-MANIFEST.md"
    text = path.read_text(encoding="utf-8")
    pdf_match = re.search(r"^\| PDF artifact \| `([^`]+)` \|$", text, re.MULTILINE)
    if pdf_match is None:
        raise SystemExit("missing release-manifest PDF artifact")
    pdf_hash, pdf_bytes = digest(PAPER / pdf_match.group(1))
    text = re.sub(
        r"^\| Local built PDF SHA-256 \| `[^`]+` \|$",
        f"| Local built PDF SHA-256 | `{pdf_hash}` |",
        text,
        flags=re.MULTILINE,
    )
    text = re.sub(
        r"^\| Local built PDF bytes \| `[0-9]+` \|$",
        f"| Local built PDF bytes | `{pdf_bytes}` |",
        text,
        flags=re.MULTILINE,
    )
    for relative in LOCAL_MANIFEST_ARTIFACTS:
        actual_hash, actual_bytes = digest(SUPPLEMENT / relative)
        pattern = (
            rf"^\| `{re.escape(relative)}` \| `[0-9a-f]{{64}}` \| [0-9]+ \|$"
        )
        replacement = f"| `{relative}` | `{actual_hash}` | {actual_bytes} |"
        text, count = re.subn(pattern, replacement, text, flags=re.MULTILINE)
        if count != 1:
            raise SystemExit(f"cannot update release-manifest artifact row: {relative}")
    path.write_text(text, encoding="utf-8")
    print(f"updated {path.relative_to(PAPER)}")


def active_tex(text: str, source: Path) -> str:
    """Return text outside exact-line ``\\iffalse`` blocks."""
    depth = 0
    active: list[str] = []
    for line in text.splitlines(keepends=True):
        marker = line.strip()
        if marker == r"\iffalse":
            depth += 1
            continue
        if marker == r"\fi" and depth:
            depth -= 1
            continue
        if depth == 0:
            active.append(line)
    if depth:
        raise SystemExit(f"unclosed \\\\iffalse block in {source}")
    return "".join(active)


def tex_include_closure(path: Path, seen: set[Path]) -> list[Path]:
    path = path.resolve()
    if path in seen:
        return []
    seen.add(path)
    text = active_tex(path.read_text(encoding="utf-8"), path)
    closure = [path]
    for relative in re.findall(r"\\input\{([^}]+)\}", text):
        included = PAPER / relative
        if included.suffix == "":
            included = included.with_suffix(".tex")
        closure.extend(tex_include_closure(included, seen))
    return closure


def project_import_closure(module: str, seen: set[str]) -> None:
    if module in seen:
        return
    source = REPOSITORY / "lean" / Path(*module.split(".")).with_suffix(".lean")
    if not source.exists():
        return
    seen.add(module)
    for imported in re.findall(
        r"^import (RelativeConicArcs\S*)$",
        source.read_text(encoding="utf-8"),
        flags=re.MULTILINE,
    ):
        project_import_closure(imported, seen)


def check_formal_scope() -> None:
    labels: set[str] = set()
    for source in tex_include_closure(PAPER / "main.tex", set()):
        text = active_tex(source.read_text(encoding="utf-8"), source)
        labels.update(
            re.findall(
                r"\\label\{((?:lem|prop|thm|cor):[^}]+)\}",
                text,
            )
        )
    statement_map = (SUPPLEMENT / "LEAN-STATEMENTS.md").read_text(encoding="utf-8")
    mapped = set(
        re.findall(
            r"^\| `((?:lem|prop|thm|cor):[^`]+)` \|",
            statement_map,
            flags=re.MULTILINE,
        )
    )
    if labels != mapped:
        missing = ", ".join(sorted(labels - mapped)) or "none"
        obsolete = ", ".join(sorted(mapped - labels)) or "none"
        raise SystemExit(
            "Lean statement map differs from the manuscript labels: "
            f"missing [{missing}]; obsolete [{obsolete}]"
        )
    if len(labels) != 37:
        raise SystemExit(f"expected 37 adopted manuscript labels, found {len(labels)}")

    formal_sources = (AGGREGATE.is_file(), AXIOM_AUDIT.is_file())
    if formal_sources == (False, False):
        print(
            "verified manuscript labels against the frozen Lean statement map; "
            "external Lean sources are not bundled"
        )
        return
    if formal_sources != (True, True):
        raise SystemExit("external Lean verification sources are incomplete")

    aggregate_text = AGGREGATE.read_text(encoding="utf-8")
    imports = tuple(
        re.findall(r"^import (\S+)$", aggregate_text, flags=re.MULTILINE)
    )
    if imports != EXPECTED_AGGREGATE_IMPORTS:
        raise SystemExit("paper-facing aggregate import set or order has changed")
    closure: set[str] = set()
    project_import_closure(
        "RelativeConicArcs.Gates.PRSBeyondRedundancyFourAxiomAudit",
        closure,
    )
    if tuple(sorted(closure)) != EXPECTED_PROJECT_CLOSURE:
        raise SystemExit("paper-facing transitive project import closure has changed")

    audit_text = AXIOM_AUDIT.read_text(encoding="utf-8")
    targets = re.findall(
        r"^#print axioms (\S+)$",
        audit_text,
        flags=re.MULTILINE,
    )
    target_bytes = ("".join(f"{target}\n" for target in targets)).encode()
    if len(targets) != EXPECTED_AXIOM_TARGET_COUNT:
        raise SystemExit(
            "paper-facing axiom target count has changed: "
            f"expected {EXPECTED_AXIOM_TARGET_COUNT}, found {len(targets)}"
        )
    if hashlib.sha256(target_bytes).hexdigest() != EXPECTED_AXIOM_TARGET_SHA256:
        raise SystemExit("paper-facing axiom target set or order has changed")
    print("verified R5--R7 manuscript labels and exact Lean target sets")


def check_public_release_gate() -> None:
    manifest = (SUPPLEMENT / "RELEASE-MANIFEST.md").read_text(encoding="utf-8")
    signoff = (SUPPLEMENT / "FINAL-READER-SIGNOFF.md").read_text(encoding="utf-8")
    main = (PAPER / "main.tex").read_text(encoding="utf-8")

    def field(label: str) -> str:
        match = re.search(
            rf"^\| {re.escape(label)} \| (.+) \|$",
            manifest,
            flags=re.MULTILINE,
        )
        if match is None:
            raise SystemExit(f"missing release-manifest field: {label}")
        return match.group(1).strip().strip("`")

    def signoff_field(label: str) -> str:
        match = re.search(
            rf"^\| {re.escape(label)} \| (.+) \|$",
            signoff,
            flags=re.MULTILINE,
        )
        if match is None:
            raise SystemExit(f"missing final-reader candidate field: {label}")
        return match.group(1).strip().strip("`")

    required_patterns = {
        "Paper-export repository URL": r"https://.+",
        "Release tag": r"\S+",
        "Release commit": r"[0-9a-f]{40}",
        "Public Lean revision": r"[0-9a-f]{40}",
        "Archive identifier": r"\S+",
        "DOI": r"10\.\d{4,9}/\S+",
        "Source archive SHA-256": r"[0-9a-f]{64}",
        "Source archive bytes": r"[1-9]\d*",
        "PDF SHA-256": r"[0-9a-f]{64}",
        "PDF bytes": r"[1-9]\d*",
    }
    for label, pattern in required_patterns.items():
        if re.fullmatch(pattern, field(label)) is None:
            raise SystemExit(f"public release gate is unresolved: {label}")

    if field("PDF SHA-256") != field("Local built PDF SHA-256"):
        raise SystemExit("public PDF hash differs from the reviewed local candidate")
    if field("PDF bytes") != field("Local built PDF bytes"):
        raise SystemExit("public PDF byte count differs from the reviewed local candidate")
    lean_revision = field("Public Lean revision")
    flake = (PAPER / "flake.nix").read_text(encoding="utf-8")
    lock = (PAPER / "flake.lock").read_text(encoding="utf-8")
    if "finitegeom" not in flake or lean_revision not in lock:
        raise SystemExit("release flake does not resolve the public Lean revision")
    if "pending" in signoff.lower() or signoff.lower().count("verdict: green.") != 2:
        raise SystemExit("independent final-reader signoff is incomplete")
    if signoff_field("Paper-export commit") != field("Release commit"):
        raise SystemExit("final-reader signoff names a different paper-export commit")
    if signoff_field("Canonical preprint PDF SHA-256") != field("PDF SHA-256"):
        raise SystemExit("final-reader signoff names a different canonical PDF")
    if "Unrefereed preprint" not in main:
        raise SystemExit("the manuscript is not visibly labelled as an unrefereed preprint")
    print("verified public release metadata and final-reader gate")


def check_bundle() -> None:
    check_formal_scope()
    run([sys.executable, "supplement/package_evidence_bundle.py", "--check"])
    run([sys.executable, "supplement/build_classification_records.py", "--check"])
    run([sys.executable, "supplement/build_r6_paper_table.py", "--check"])
    check_classification_hashes()
    check_release_manifest()


def replay() -> None:
    python_jobs = (
        (
            "r5",
            [
                "2026-07-22-redundancy-five-deep-hole-replay.py",
                "--json",
                "2026-07-22-prs-deep-hole-census.json",
            ],
        ),
        (
            "r6",
            [
                "2026-07-22-redundancy-six-deep-hole-replay.py",
                "--json",
                "2026-07-22-prs-deep-hole-census.json",
            ],
        ),
        (
            "r6-normal-forms",
            ["2026-07-23-small-exceptional-normal-forms.py", "--summary"],
        ),
        ("r7", ["2026-07-23-prs-deep-hole-calibration-replay.py"]),
        ("r7", ["2026-07-26-r7-independent-arithmetic-replay.py"]),
        (
            "r7",
            [
                "2026-07-26-r7-direct-locus-replay.py",
                "--check",
                "2026-07-26-r7-direct-locus-replay.json",
            ],
        ),
        (
            "stable-components",
            ["2026-07-24-r10-integral-bad-scheme-sc11.py", "--check"],
        ),
        (
            "stable-components",
            ["2026-07-24-stable-component-fano-elimination.py", "--check"],
        ),
    )
    for directory, arguments in python_jobs:
        run(
            [sys.executable, *arguments],
            SUPPLEMENT / "evidence" / directory,
        )



def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--replay",
        action="store_true",
        help="also run every paper-local Python replay",
    )
    parser.add_argument(
        "--release",
        action="store_true",
        help="require immutable public metadata and two independent reader signoffs",
    )
    parser.add_argument(
        "--write-local-manifest",
        action="store_true",
        help="refresh local PDF and supplement artifact hashes",
    )
    args = parser.parse_args()
    if args.write_local_manifest:
        write_local_release_manifest()
    check_bundle()
    if args.replay:
        replay()
    if args.release:
        check_public_release_gate()


if __name__ == "__main__":
    main()
