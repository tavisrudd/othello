#!/usr/bin/env python3
"""Verify the public release surface for Complete Bounded Repair Ports.

Run inside the pinned manuscript shell.  The update-pdf option is the only
supported way to refresh the tracked PDF.  The lean-root option upgrades the
paper-only check to the full release check against an exported finitegeom
checkout.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import shutil
import subprocess
import tempfile
from pathlib import Path


PAPER = Path(__file__).resolve().parents[1]
SOURCE = "complete_repair_ports.tex"
PDF = PAPER / "complete_repair_ports.pdf"
DETERMINISTIC_EPOCH = "1767225600"
EXPECTED_PAGES = 23
DOI = "10.5281/zenodo.22051904"
FINITEGEOM_REPOSITORY = "https://github.com/tavisrudd/finitegeom"
GATE = "RepairPorts.Gates.CompletePorts"
FACT_RELATIVE = Path("lean/trust/facts/RepairPorts.Gates.CompletePorts.json")
PUBLIC_FORMAL_MANIFEST = Path("trust/manifests/complete_ports.json")
EXPECTED_AXIOMS = {"Classical.choice", "Quot.sound", "propext"}
EXPECTED_CERTIFICATE_SHA256 = (
    "8096230e66f634c820ae7ec4bacd9b2493006782ff02b8be3a8c7e1caf80de07"
)
EXPECTED_MATCHED_CERTIFICATE_SHA256 = (
    "16a378edc882a6dda7f5642c7d21bfa49913b45ef5409398de117897b19dd2b8"
)
HEX40 = re.compile(r"[0-9a-f]{40}")
WARNING_RE = re.compile(
    r"LaTeX Warning|Package .* Warning|Overfull|Underfull|"
    r"undefined references|undefined citations",
    re.IGNORECASE,
)
PAGES_RE = re.compile(r"Output written on .+ \((\d+) pages?,")
FORBIDDEN_PUBLIC = (
    (re.compile(r"\bC\d{3}\b"), "internal task identifier"),
    (
        re.compile(r"(?i)\b(?:" + "task " + r"card|lane " + r"handoff)\b"),
        "internal workflow term",
    ),
    (re.compile(r"(?i)(?:^|[\\/])notes[\\/]"), "private notes path"),
    (re.compile("(?i)" + "oth" + "ello"), "private repository name"),
    (
        re.compile(r"(?:/" + "home/|~/" + r"src/|/" + "Users/)"),
        "private filesystem path",
    ),
)


def fail(message: str) -> None:
    raise SystemExit(f"complete-repair-ports release: FAIL [{message}]")


def require(condition: bool, message: str) -> None:
    if not condition:
        fail(message)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def run(argv: list[str], cwd: Path) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        argv,
        cwd=cwd,
        check=False,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )


def public_text_files() -> list[Path]:
    files = [
        PAPER / SOURCE,
        PAPER / "refs.bib",
        PAPER / "README.md",
        PAPER / "LICENSE",
        PAPER / "Makefile",
        PAPER / "flake.nix",
        PAPER / "flake.lock",
        PAPER / ".zenodo.json",
        PAPER / "verification" / "README.md",
        PAPER / "verification" / "formal-boundary.json",
        PAPER / "verification" / "f7-seed.py",
        PAPER / "verification" / "f7-seed.json",
        PAPER / "verification" / "matched-seed.py",
        PAPER / "verification" / "matched-seed.json",
        PAPER / "verification" / "verify_release.py",
        *sorted((PAPER / "sections").glob("*.tex")),
        PAPER / "sections" / "README.md",
        *sorted((PAPER / "figures").glob("*.tex")),
    ]
    unique: list[Path] = []
    seen: set[Path] = set()
    for path in files:
        if path not in seen:
            unique.append(path)
            seen.add(path)
    return unique


def check_public_surface() -> None:
    files = public_text_files()
    for path in files:
        require(path.is_file(), f"missing public file {path.relative_to(PAPER)}")
        text = path.read_text(encoding="utf-8")
        for pattern, label in FORBIDDEN_PUBLIC:
            if pattern.search(text):
                fail(f"{path.relative_to(PAPER)} contains {label}")

    readme = (PAPER / "README.md").read_text(encoding="utf-8")
    require(
        f"https://doi.org/{DOI}" in readme
        and "10.5281%2Fzenodo.22051904" in readme,
        "README DOI badge/link is missing or stale",
    )
    require(
        FINITEGEOM_REPOSITORY in readme,
        "README must identify the public finitegeom formal companion",
    )
    for term in ("mirror", "authority", "synchronization", "publication gate"):
        require(
            term not in readme.lower(),
            f"README contains internal repository-role language: {term}",
        )

    manuscript = (PAPER / SOURCE).read_text(encoding="utf-8")
    required_inputs = [
        "sections/01-complete-ports",
        "sections/02-confinement-transfer",
        "sections/03-positive-density",
        "sections/04-reliability-exit",
        "sections/05-pointed-tutte",
        "sections/06-geometric-flagships",
        "sections/08-conclusion",
        "sections/07-verification-provenance",
    ]
    for item in required_inputs:
        require(f"\\input{{{item}}}" in manuscript, f"missing section input {item}")
    require(
        "\\section*{AI assistance disclosure}" in manuscript
        and "assumes responsibility for all content" in manuscript,
        "AI assistance disclosure is missing or incomplete",
    )
    abstract = re.search(
        r"\\begin\{abstract\}(.*?)\\end\{abstract\}",
        manuscript,
        re.DOTALL,
    )
    require(abstract is not None, "abstract is missing")
    abstract_words = re.findall(
        r"[A-Za-z0-9]+(?:[-'][A-Za-z0-9]+)*", abstract.group(1)
    )
    require(
        140 <= len(abstract_words) <= 220,
        f"abstract length {len(abstract_words)} is outside 140--220 words",
    )


def check_metadata() -> dict[str, object]:
    metadata = json.loads((PAPER / ".zenodo.json").read_text(encoding="utf-8"))
    require(
        metadata.get("title")
        == "Complete Bounded Repair Ports: Transfer, Reliability, and Geometric Structure",
        "Zenodo title does not match the paper",
    )
    require(metadata.get("license") == "mit", "Zenodo license must match LICENSE")
    require(metadata.get("upload_type") == "publication", "Zenodo upload type is wrong")
    require(
        metadata.get("publication_type") == "preprint",
        "Zenodo publication type is wrong",
    )
    creators = metadata.get("creators")
    require(
        isinstance(creators, list) and len(creators) == 1,
        "Zenodo creator is missing",
    )

    boundary = json.loads(
        (PAPER / "verification" / "formal-boundary.json").read_text(
            encoding="utf-8"
        )
    )
    provenance_tex = (PAPER / "sections" / "07-verification-provenance.tex").read_text(
        encoding="utf-8"
    )
    require(boundary.get("gate") == GATE, "formal gate name is stale")
    require(
        boundary.get("finitegeom_repository") == FINITEGEOM_REPOSITORY,
        "formal metadata must reference only the public finitegeom repository",
    )
    for field in (
        "source_commit",
        "finitegeom_base_commit",
        "finitegeom_release_commit",
        "mathlib_rev",
    ):
        value = boundary.get(field)
        require(
            isinstance(value, str) and HEX40.fullmatch(value) is not None,
            f"formal metadata field {field} is not a 40-hex revision",
        )
    for field in (
        "source_commit",
        "finitegeom_base_commit",
        "finitegeom_release_commit",
    ):
        require(
            f"\\path{{{boundary[field]}}}" in provenance_tex,
            f"manuscript provenance is stale for {field}",
        )
    require(
        boundary.get("closure_module_count") == 36,
        "closure module count drift",
    )
    require(boundary.get("terminal_count") == 61, "terminal count drift")
    modules = boundary.get("closure_modules")
    require(
        isinstance(modules, list)
        and len(modules) == 36
        and len(set(modules)) == 36
        and modules == sorted(modules),
        "formal closure list is incomplete, duplicated, or unsorted",
    )
    require(
        set(boundary.get("permitted_axioms", [])) == EXPECTED_AXIOMS,
        "formal permitted-axiom set drift",
    )
    fact_hash = boundary.get("gate_fact_sha256")
    require(
        isinstance(fact_hash, str) and re.fullmatch(r"[0-9a-f]{64}", fact_hash),
        "gate-fact hash is malformed",
    )
    return boundary


def check_authority_fact_if_present(boundary: dict[str, object]) -> None:
    repository = PAPER.parents[1]
    fact = repository / FACT_RELATIVE
    if not fact.is_file():
        return
    require(sha256(fact) == boundary["gate_fact_sha256"], "gate fact hash drift")
    payload = json.loads(fact.read_text(encoding="utf-8"))
    require(
        payload.get("closure") == boundary["closure_modules"],
        "gate closure drift",
    )


def check_seed_replay() -> None:
    completed = run(
        [
            "python3",
            "verification/f7-seed.py",
            "--check",
            "verification/f7-seed.json",
        ],
        PAPER,
    )
    if completed.returncode != 0:
        fail("field-seven replay failed:\n" + (completed.stderr or completed.stdout))
    require(
        sha256(PAPER / "verification" / "f7-seed.json")
        == EXPECTED_CERTIFICATE_SHA256,
        "field-seven certificate hash drift",
    )
    completed = run(
        [
            "python3",
            "verification/matched-seed.py",
            "--check",
            "verification/matched-seed.json",
        ],
        PAPER,
    )
    if completed.returncode != 0:
        fail("matched-seed replay failed:\n" + (completed.stderr or completed.stdout))
    require(
        sha256(PAPER / "verification" / "matched-seed.json")
        == EXPECTED_MATCHED_CERTIFICATE_SHA256,
        "matched-seed certificate hash drift",
    )


def check_public_formal_root(root: Path, boundary: dict[str, object]) -> None:
    root = root.resolve()
    require(root.is_dir(), f"finitegeom root does not exist: {root}")
    release_commit = boundary.get("finitegeom_release_commit")
    require(
        isinstance(release_commit, str)
        and HEX40.fullmatch(release_commit) is not None,
        "formal metadata lacks the adopted finitegeom release commit",
    )
    head = run(["git", "rev-parse", "HEAD"], root)
    require(head.returncode == 0, "finitegeom checkout is not a Git repository")
    require(
        head.stdout.strip() == release_commit,
        "finitegeom checkout is not at the paper's release commit",
    )
    status = run(["git", "status", "--porcelain=v1", "--untracked-files=all"], root)
    require(status.returncode == 0 and not status.stdout, "finitegeom checkout is dirty")
    remote = run(["git", "remote", "get-url", "origin"], root)
    require(remote.returncode == 0, "finitegeom checkout has no origin")
    remote_url = remote.stdout.strip()
    require(
        remote_url
        in {
            FINITEGEOM_REPOSITORY,
            FINITEGEOM_REPOSITORY + ".git",
            "git@github.com:tavisrudd/finitegeom.git",
        },
        "finitegeom checkout does not identify the public repository",
    )
    manifest_path = root / PUBLIC_FORMAL_MANIFEST
    require(
        manifest_path.is_file(),
        f"public finitegeom area manifest is missing: {PUBLIC_FORMAL_MANIFEST}",
    )
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    require(manifest.get("roots") == [GATE], "public finitegeom gate mismatch")
    require(
        manifest.get("module_count") == boundary["closure_module_count"],
        "public finitegeom module count drift",
    )
    sources = manifest.get("sources")
    require(
        isinstance(sources, list),
        "public finitegeom manifest has no source inventory",
    )
    closure = [entry.get("module") for entry in sources]
    require(
        closure == boundary["closure_modules"],
        "public finitegeom closure drift",
    )
    for entry in sources:
        relative = entry.get("path")
        require(
            isinstance(relative, str) and (root / relative).is_file(),
            "public finitegeom manifest names a missing source",
        )
        require(
            (root / relative).stat().st_size == entry.get("bytes")
            and sha256(root / relative) == entry.get("sha256"),
            f"public finitegeom source bytes drift: {relative}",
        )
    source_manifest = root / "trust" / "source-manifests" / "complete_ports.json"
    require(source_manifest.is_file(), "public finitegeom source manifest is missing")
    require(
        source_manifest.read_bytes() == manifest_path.read_bytes(),
        "public finitegeom source/candidate manifests disagree",
    )
    statement = root / "trust" / "COMPLETE_PORTS.md"
    require(statement.is_file(), "public finitegeom trust statement is missing")
    statement_text = statement.read_text(encoding="utf-8")
    terminal_section = statement_text.partition("## Terminals")[2]
    terminals = re.findall(r"^- \x60([^\x60]+)\x60$", terminal_section, re.MULTILINE)
    require(
        len(terminals) == boundary["terminal_count"]
        and len(set(terminals)) == boundary["terminal_count"],
        "public finitegeom terminal inventory drift",
    )
    require(
        all(axiom in statement_text for axiom in EXPECTED_AXIOMS),
        "public finitegeom trust statement omits the permitted axiom set",
    )


def deterministic_environment() -> dict[str, str]:
    environment = dict(os.environ)
    environment["SOURCE_DATE_EPOCH"] = DETERMINISTIC_EPOCH
    environment["FORCE_SOURCE_DATE"] = "1"
    return environment


def build_pdf(build_root: Path) -> bytes:
    for name in (SOURCE, "refs.bib"):
        shutil.copy2(PAPER / name, build_root / name)
    shutil.copytree(PAPER / "sections", build_root / "sections")
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
    parser.add_argument(
        "--lean-root",
        type=Path,
        help="exported public finitegeom checkout; required for the full release gate",
    )
    parser.add_argument(
        "--require-public-formal",
        action="store_true",
        help="fail unless --lean-root supplies the exported public formal artifact",
    )
    args = parser.parse_args()

    check_public_surface()
    boundary = check_metadata()
    check_authority_fact_if_present(boundary)
    check_seed_replay()
    if args.require_public_formal and args.lean_root is None:
        fail("full release requires --lean-root /path/to/finitegeom")
    if args.lean_root is not None:
        check_public_formal_root(args.lean_root, boundary)

    with tempfile.TemporaryDirectory(
        prefix="complete-repair-ports-build-"
    ) as scratch:
        rebuilt = build_pdf(Path(scratch))
    if args.update_pdf:
        PDF.write_bytes(rebuilt)
    else:
        require(PDF.is_file(), "tracked PDF is missing; rerun with --update-pdf")
        require(
            PDF.read_bytes() == rebuilt,
            "tracked PDF is stale; rerun with --update-pdf",
        )

    mode = "full release" if args.lean_root is not None else "paper surface"
    print(
        f"complete-repair-ports release: PASS "
        f"[{mode}, {EXPECTED_PAGES} pages, warning-free]"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
