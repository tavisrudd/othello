#!/usr/bin/env python3
"""Verify the public release surface without rebuilding the Q25 certificates."""

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
SOURCE = "equivariant-robust-completion.tex"
PDF = PAPER / "equivariant-robust-completion.pdf"
DOI = "10.5281/zenodo.22051736"
CERTIFICATE_REPOSITORY = "https://github.com/tavisrudd/finitegeom-q25-certificates"
DETERMINISTIC_EPOCH = "1767225600"
HEX40 = re.compile(r"[0-9a-f]{40}")
HEX64 = re.compile(r"[0-9a-f]{64}")
WARNING_RE = re.compile(
    r"LaTeX Warning|Package .* Warning|Overfull|Underfull|"
    r"undefined references|undefined citations",
    re.IGNORECASE,
)
FORBIDDEN_PUBLIC = (
    (re.compile(r"\bC\d{3,}\b"), "internal task identifier"),
    (
        re.compile(
            r"(?i)\b(?:task "
            + "card|task "
            + "queue|lane "
            + "handoff|"
            + "work"
            + "flow|auth"
            + "ority|mono"
            + "repo|mir"
            + r"ror)\b"
        ),
        "internal process term",
    ),
    (re.compile(r"(?i)(?:^|[\\/])notes[\\/]"), "private notes path"),
    (re.compile("(?i)" + "oth" + "ello"), "private repository name"),
    (
        re.compile(r"(?:/" + "home/|~/" + r"src/|/" + "Users/)"),
        "private filesystem path",
    ),
)
TEXT_SUFFIXES = {"", ".bib", ".json", ".lock", ".md", ".nix", ".py", ".tex"}


def fail(message: str) -> None:
    raise SystemExit(f"equivariant-robust-completion release: FAIL [{message}]")


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
    files: list[Path] = []
    for path in PAPER.rglob("*"):
        if not path.is_file() or path == PDF or path.name.endswith(".log"):
            continue
        if ".git" in path.parts:
            continue
        if path.suffix in TEXT_SUFFIXES or path.name in {"LICENSE", "Makefile"}:
            files.append(path)
    return sorted(files)


def check_public_surface() -> None:
    required = [
        PAPER / SOURCE,
        PDF,
        PAPER / "README.md",
        PAPER / ".zenodo.json",
        PAPER / "verification" / "README.md",
        PAPER / "verification" / "q25-certificate-pin.json",
    ]
    for path in required:
        require(path.is_file(), f"missing public file {path.relative_to(PAPER)}")

    for path in PAPER.rglob("*"):
        if not path.is_file() or ".git" in path.parts:
            continue
        relative = str(path.relative_to(PAPER))
        for pattern, label in FORBIDDEN_PUBLIC:
            require(pattern.search(relative) is None, f"{relative} has {label}")

    for path in public_text_files():
        text = path.read_text(encoding="utf-8")
        for pattern, label in FORBIDDEN_PUBLIC:
            require(
                pattern.search(text) is None,
                f"{path.relative_to(PAPER)} contains {label}",
            )

    readme = (PAPER / "README.md").read_text(encoding="utf-8")
    require(
        f"https://doi.org/{DOI}" in readme
        and "10.5281%2Fzenodo.22051736" in readme,
        "README DOI badge/link is missing or stale",
    )
    for term in (
        "mir" + "ror",
        "auth" + "ority",
        "synchron" + "ization",
        "publication " + "gate",
    ):
        require(
            term not in readme.lower(),
            f"README contains repository-process language: {term}",
        )

    manuscript = (PAPER / SOURCE).read_text(encoding="utf-8")
    for section in range(1, 9):
        require(
            f"\\input{{sections/{section:02d}-" in manuscript,
            f"missing section {section:02d} input",
        )
    require(
        "\\section*{AI assistance disclosure}" in manuscript
        and "assumes responsibility for all content" in manuscript,
        "AI assistance disclosure is missing or incomplete",
    )


def check_metadata() -> dict[str, object]:
    metadata = json.loads((PAPER / ".zenodo.json").read_text(encoding="utf-8"))
    require(
        metadata.get("title")
        == "Frobenius-equivariant pair extension and robust repair of eight-arcs",
        "Zenodo title does not match the paper",
    )
    require(metadata.get("license") == "cc-by-4.0", "Zenodo license mismatch")
    require(metadata.get("upload_type") == "publication", "Zenodo upload type mismatch")
    require(
        metadata.get("publication_type") == "preprint",
        "Zenodo publication type mismatch",
    )

    pin = json.loads(
        (PAPER / "verification" / "q25-certificate-pin.json").read_text(
            encoding="utf-8"
        )
    )
    require(pin.get("repository") == CERTIFICATE_REPOSITORY, "certificate repository drift")
    require(HEX40.fullmatch(str(pin.get("commit", ""))) is not None, "malformed certificate commit")
    require(HEX64.fullmatch(str(pin.get("manifest_sha256", ""))) is not None, "malformed manifest digest")
    require(pin.get("verify_command") == "nix run .#verify", "certificate command drift")
    require("structural_source" not in pin, "private structural-source locator is present")
    return pin


def check_certificate_root(root: Path, pin: dict[str, object]) -> None:
    root = root.resolve()
    require(root.is_dir(), f"certificate root does not exist: {root}")
    manifest = root / "MANIFEST.json"
    require(manifest.is_file(), "certificate MANIFEST.json is missing")
    revision = run(["git", "rev-parse", "HEAD"], root)
    require(revision.returncode == 0, "certificate root is not a Git checkout")
    require(revision.stdout.strip() == pin["commit"], "certificate checkout commit mismatch")
    require(sha256(manifest) == pin["manifest_sha256"], "certificate manifest digest mismatch")


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
        ["tectonic", SOURCE, "--keep-logs"],
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
    return (build_root / Path(SOURCE).with_suffix(".pdf")).read_bytes()


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--update-pdf",
        action="store_true",
        help="replace the tracked PDF with the deterministic clean build",
    )
    parser.add_argument(
        "--certificate-root",
        type=Path,
        help="source-only identity check of the pinned public certificate checkout",
    )
    args = parser.parse_args()

    check_public_surface()
    pin = check_metadata()
    if args.certificate_root is not None:
        check_certificate_root(args.certificate_root, pin)

    with tempfile.TemporaryDirectory(prefix="equivariant-paper-build-") as scratch:
        rebuilt = build_pdf(Path(scratch))
    if args.update_pdf:
        PDF.write_bytes(rebuilt)
    else:
        require(PDF.read_bytes() == rebuilt, "tracked PDF is stale; run make update-pdf")

    mode = "paper plus certificate identity" if args.certificate_root else "paper surface"
    print(f"equivariant-robust-completion release: PASS [{mode}, warning-free]")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
