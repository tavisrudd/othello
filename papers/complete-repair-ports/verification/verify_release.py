#!/usr/bin/env python3
"""Verify the standalone release surface for the recovery paper."""

from __future__ import annotations

import argparse
import json
import os
import re
import shutil
import subprocess
import tempfile
from pathlib import Path


PAPER = Path(__file__).resolve().parents[1]
EXPORTER_METADATA = {".gitignore", "PROVENANCE.md", "export-manifest.json"}
SOURCE = "complete_repair_ports.tex"
PDF = PAPER / "complete_repair_ports.pdf"
TITLE = "Exact Transfer of Bounded Linear Recovery and Relative Weight Hierarchies"
DOI = "10.5281/zenodo.22051903"
DETERMINISTIC_EPOCH = "1767225600"
EXPECTED_PAGES = 18
EXPECTED_TOOLCHAIN = "leanprover/lean4:v4.32.0-rc1"
EXPECTED_MATHLIB = "571b8a8e54219b4d393f75f4b8653fac08197fcc"
EXPECTED_AXIOMS = {"Classical.choice", "Quot.sound", "propext"}
DISTRIBUTION = PAPER / "verification" / "distribution-files.txt"
WARNING_RE = re.compile(
    r"LaTeX Warning|Package .* Warning|Overfull|Underfull|"
    r"undefined references|undefined citations",
    re.IGNORECASE,
)
PAGES_RE = re.compile(r"Output written on .+ \((\d+) pages?,")
FORBIDDEN_PUBLIC = (
    (re.compile(r"\bC\d{3}\b"), "internal task identifier"),
    (
        re.compile("(?i)\\b(?:" + "task " + "card|" + "lane " + "handoff)\\b"),
        "internal workflow term",
    ),
    (re.compile(r"(?i)(?:^|[\\/])notes[\\/]"), "private notes path"),
    (re.compile("(?i)" + "oth" + "ello"), "private repository name"),
    (
        re.compile("(?:/" + "home/|~/" + "src/|/" + "Users/)"),
        "private filesystem path",
    ),
)


def fail(message: str) -> None:
    raise SystemExit(f"complete-repair-ports release: FAIL [{message}]")


def require(condition: bool, message: str) -> None:
    if not condition:
        fail(message)


def run(argv: list[str], cwd: Path) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        argv,
        cwd=cwd,
        check=False,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )


def distribution_paths() -> list[str]:
    require(DISTRIBUTION.is_file(), "distribution manifest is missing")
    paths = [line.strip() for line in DISTRIBUTION.read_text().splitlines() if line.strip()]
    require(paths == sorted(paths), "distribution manifest is not sorted")
    require(len(paths) == len(set(paths)), "distribution manifest contains duplicates")
    for relative in paths:
        path = Path(relative)
        require(
            not path.is_absolute() and ".." not in path.parts,
            f"unsafe distribution path {relative}",
        )
    return paths


def public_text_files() -> list[Path]:
    return [
        PAPER / relative
        for relative in distribution_paths()
        if relative != "complete_repair_ports.pdf"
    ]


def check_public_surface() -> None:
    paths = distribution_paths()
    for relative in paths:
        require((PAPER / relative).is_file(), f"missing distributed file {relative}")
    repository = run(["git", "rev-parse", "--show-toplevel"], PAPER)
    if repository.returncode == 0 and Path(repository.stdout.strip()).resolve() == PAPER:
        tracked = run(["git", "ls-files"], PAPER)
        require(tracked.returncode == 0, "cannot enumerate standalone tracked files")
        tracked_paths = {line for line in tracked.stdout.splitlines() if line}
        distributed = set(paths)
        require(
            distributed <= tracked_paths <= distributed | EXPORTER_METADATA,
            "standalone tracked files disagree with distribution manifest; "
            f"unexpected={sorted(tracked_paths - distributed - EXPORTER_METADATA)}, "
            f"missing={sorted(distributed - tracked_paths)}",
        )
    files = public_text_files() + [
        PAPER / relative
        for relative in sorted(EXPORTER_METADATA)
        if (PAPER / relative).is_file()
    ]
    for path in files:
        require(path.is_file(), f"missing public file {path.relative_to(PAPER)}")
        text = path.read_text(encoding="utf-8")
        for pattern, label in FORBIDDEN_PUBLIC:
            if pattern.search(text):
                fail(f"{path.relative_to(PAPER)} contains {label}")

    readme = (PAPER / "README.md").read_text(encoding="utf-8")
    require(TITLE in readme, "README title is stale")
    require(
        f"https://doi.org/{DOI}" in readme
        and "10.5281%2Fzenodo.22051903" in readme,
        "README DOI badge/link is missing or stale",
    )
    require(
        re.search(r"new\s+record version must be deposited", readme, re.IGNORECASE)
        is not None,
        "README must distinguish the existing DOI record from this rewrite",
    )

    manuscript = (PAPER / SOURCE).read_text(encoding="utf-8")
    required_inputs = [
        "formal-annotations",
        "sections/01-complete-ports",
        "sections/02-confinement-transfer",
        "sections/03-positive-density",
        "sections/04-reliability-exit",
        "sections/05-pointed-tutte",
        "sections/06-geometric-flagships",
        "sections/07-verification-provenance",
        "sections/08-conclusion",
    ]
    for item in required_inputs:
        require(f"\\input{{{item}}}" in manuscript, f"missing input {item}")
    require(
        "\\section*{AI assistance disclosure}" in manuscript
        and "assumes responsibility for all content" in manuscript,
        "AI assistance disclosure is missing or incomplete",
    )
    abstract = re.search(
        r"\\begin\{abstract\}(.*?)\\end\{abstract\}", manuscript, re.DOTALL
    )
    require(abstract is not None, "abstract is missing")
    abstract_words = re.findall(
        r"[A-Za-z0-9]+(?:[-'][A-Za-z0-9]+)*", abstract.group(1)
    )
    require(
        140 <= len(abstract_words) <= 220,
        f"abstract length {len(abstract_words)} is outside 140--220 words",
    )


def load_json(relative: str) -> dict:
    try:
        return json.loads((PAPER / relative).read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as error:
        fail(f"invalid JSON in {relative}: {error}")


def expected_axiom_map() -> dict[str, set[str]]:
    result: dict[str, set[str]] = {}
    path = PAPER / "lean" / "verification" / "expected_axioms.txt"
    for raw in path.read_text(encoding="utf-8").splitlines():
        if not raw.strip():
            continue
        name, values = raw.split(":", 1)
        result[name.strip()] = {
            item.strip() for item in values.split(",") if item.strip()
        }
    return result


def check_metadata_and_formal_boundary() -> None:
    metadata = load_json(".zenodo.json")
    require(metadata.get("title") == TITLE, "Zenodo title does not match the paper")
    require(metadata.get("license") == "mit", "Zenodo license must match LICENSE")
    require(metadata.get("upload_type") == "publication", "Zenodo upload type is wrong")
    require(metadata.get("publication_type") == "preprint", "publication type is wrong")
    creators = metadata.get("creators")
    require(isinstance(creators, list) and len(creators) == 1, "creator is missing")

    boundary = load_json("verification/formal-boundary.json")
    require(boundary.get("schema_version") == 2, "formal-boundary schema is stale")
    require(boundary.get("paper") == TITLE, "formal-boundary paper title is stale")
    require(boundary.get("formal_package") == "lean", "formal package path is stale")
    require(
        boundary.get("lean_toolchain") == EXPECTED_TOOLCHAIN,
        "formal-boundary Lean toolchain is stale",
    )
    require(
        (PAPER / "lean" / "lean-toolchain").read_text(encoding="utf-8").strip()
        == EXPECTED_TOOLCHAIN,
        "paper-local Lean toolchain is stale",
    )
    manifest = load_json("lean/lake-manifest.json")
    mathlib = [row for row in manifest.get("packages", []) if row.get("name") == "mathlib"]
    require(
        len(mathlib) == 1 and mathlib[0].get("rev") == EXPECTED_MATHLIB,
        "paper-local Mathlib revision is stale",
    )
    require(boundary.get("mathlib_rev") == EXPECTED_MATHLIB, "boundary Mathlib drift")

    claims = load_json("lean/verification/claims.json").get("claims", [])
    complete = [row for row in claims if row.get("status") == "complete"]
    terminals = [name for row in claims for name in row.get("terminals", [])]
    require(len(claims) == boundary.get("claim_count") == 18, "claim count drift")
    require(
        len(complete) == boundary.get("complete_claim_count") == 1,
        "complete-claim count drift",
    )
    require(
        len(terminals) == len(set(terminals)) == boundary.get("terminal_count") == 4,
        "reviewer-terminal count drift",
    )
    axiom_map = expected_axiom_map()
    require(set(axiom_map) == set(terminals), "expected-axiom terminal set drift")
    require(
        set().union(*axiom_map.values()) == EXPECTED_AXIOMS
        and set(boundary.get("permitted_axioms", [])) == EXPECTED_AXIOMS,
        "permitted-axiom set drift",
    )

    checked = run(
        ["python3", "lean/verification/check_formal_artifact.py", "--source-only"],
        PAPER,
    )
    require(
        checked.returncode == 0,
        "formal annotation check failed:\n" + (checked.stderr or checked.stdout),
    )


def deterministic_environment() -> dict[str, str]:
    environment = dict(os.environ)
    environment["SOURCE_DATE_EPOCH"] = DETERMINISTIC_EPOCH
    environment["FORCE_SOURCE_DATE"] = "1"
    return environment


def build_pdf(build_root: Path) -> bytes:
    for name in (SOURCE, "formal-annotations.tex", "refs.bib"):
        shutil.copy2(PAPER / name, build_root / name)
    shutil.copytree(PAPER / "sections", build_root / "sections")
    if (PAPER / "figures").is_dir():
        shutil.copytree(PAPER / "figures", build_root / "figures")
    completed = subprocess.run(
        [
            "latexmk",
            "-xelatex",
            "-interaction=nonstopmode",
            "-halt-on-error",
            SOURCE,
        ],
        cwd=build_root,
        check=False,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        env=deterministic_environment(),
    )
    if completed.returncode != 0:
        detail = (completed.stdout + "\n" + completed.stderr).splitlines()
        fail("manuscript build failed:\n" + "\n".join(detail[-30:]))
    log = (build_root / Path(SOURCE).with_suffix(".log")).read_text(
        encoding="utf-8", errors="replace"
    )
    warnings = sorted({match.group(0) for match in WARNING_RE.finditer(log)})
    require(not warnings, f"TeX warnings {warnings}")
    pages = PAGES_RE.search(log)
    require(pages is not None, "TeX log has no page count")
    require(
        int(pages.group(1)) == EXPECTED_PAGES,
        f"page count {pages.group(1)}, expected {EXPECTED_PAGES}",
    )
    return (build_root / Path(SOURCE).with_suffix(".pdf")).read_bytes()


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--update-pdf",
        action="store_true",
        help="replace the tracked PDF with the deterministic clean build",
    )
    args = parser.parse_args()

    check_public_surface()
    check_metadata_and_formal_boundary()
    with tempfile.TemporaryDirectory(prefix="complete-repair-ports-build-") as scratch:
        rebuilt = build_pdf(Path(scratch))
    if args.update_pdf:
        PDF.write_bytes(rebuilt)
    else:
        require(PDF.is_file(), "tracked PDF is missing; rerun with --update-pdf")
        require(
            PDF.read_bytes() == rebuilt,
            "tracked PDF is stale; rerun with --update-pdf",
        )
    print(
        f"complete-repair-ports release: PASS "
        f"[{EXPECTED_PAGES} pages, warning-free, 18 claims, 4 Lean terminals]"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
