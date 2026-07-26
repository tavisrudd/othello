#!/usr/bin/env python3
"""Create deterministic fresh-history paper and Lean release candidates."""

from __future__ import annotations

import argparse
import json
import os
import subprocess
import tarfile
from pathlib import Path


PAPER_PATH = Path("papers/beyond4_prs")
PAPER_PATHS = (
    PAPER_PATH / "README.md",
    PAPER_PATH / "Makefile",
    PAPER_PATH / "main.tex",
    PAPER_PATH / "main-tit.tex",
    PAPER_PATH / "refs.bib",
    PAPER_PATH / "flake.nix",
    PAPER_PATH / "flake.lock",
    PAPER_PATH / "lean-toolchain",
    PAPER_PATH / "prs-beyond-redundancy-four.pdf",
    PAPER_PATH / "prs-beyond-redundancy-four-tit-submission.pdf",
    PAPER_PATH / "theorem-map.md",
    PAPER_PATH / "claim-proof-novelty-ledger.md",
    PAPER_PATH / "formalization-ledger.md",
    PAPER_PATH / "literature-audit.md",
    PAPER_PATH / "verification-map.md",
    PAPER_PATH / "frontmatter",
    PAPER_PATH / "sections/README.md",
    PAPER_PATH / "sections/01-introduction.tex",
    PAPER_PATH / "sections/02-overview.tex",
    PAPER_PATH / "sections/03-dictionary.tex",
    PAPER_PATH / "sections/04-redundancy-five.tex",
    PAPER_PATH / "sections/05-polar-induction.tex",
    PAPER_PATH / "sections/06-redundancies-six-seven.tex",
    PAPER_PATH / "sections/10-verification.tex",
    PAPER_PATH / "sections/11-provenance-boundary.tex",
    PAPER_PATH / "submission",
    PAPER_PATH / "supplement",
)
LEAN_PATHS = (
    Path("lean/lakefile.toml"),
    Path("lean/lake-manifest.json"),
    Path("lean/lean-toolchain"),
    Path("lean/RelativeConicArcs/Gates/PRSFoundation.lean"),
    Path("lean/RelativeConicArcs/Gates/PRSRedundancyFive.lean"),
    Path("lean/RelativeConicArcs/Gates/PRSPolarInductionRedundancySixSeven.lean"),
    Path("lean/RelativeConicArcs/Gates/PRSStableComponents.lean"),
    Path("lean/RelativeConicArcs/Gates/PRSBeyondRedundancyFour.lean"),
    Path("lean/RelativeConicArcs/Gates/PRSBeyondRedundancyFourAxiomAudit.lean"),
    Path("lean/RelativeConicArcs/PRSContraction.lean"),
    Path("lean/RelativeConicArcs/PRSFoundation.lean"),
    Path("lean/RelativeConicArcs/PRSRedundancyFive.lean"),
    Path("lean/RelativeConicArcs/PRSRedundancyFiveCertificate.lean"),
    Path("lean/RelativeConicArcs/PRSRedundancyFiveCertified.lean"),
    Path("lean/RelativeConicArcs/PRSPolarInduction.lean"),
    Path("lean/RelativeConicArcs/PRSRedundancySixSeven.lean"),
    Path("lean/RelativeConicArcs/PRSRedundancySixSevenCertificate.lean"),
    Path("lean/RelativeConicArcs/PRSSquarefreeMarkerDensity.lean"),
    Path("lean/RelativeConicArcs/PRSStableComponents.lean"),
    Path("lean/RelativeConicArcs/PRSUniformCoveringRadius.lean"),
)


def run(
    arguments: list[str],
    *,
    cwd: Path,
    env: dict[str, str] | None = None,
    capture: bool = False,
) -> str:
    completed = subprocess.run(
        arguments,
        cwd=cwd,
        env=env,
        check=True,
        text=True,
        stdout=subprocess.PIPE if capture else None,
    )
    return completed.stdout.strip() if capture else ""


def extract_archive(source: Path, revision: str, paths: tuple[Path, ...], output: Path) -> None:
    command = [
        "git",
        "archive",
        "--format=tar",
        revision,
        *(path.as_posix() for path in paths),
    ]
    producer = subprocess.Popen(command, cwd=source, stdout=subprocess.PIPE)
    if producer.stdout is None:
        raise SystemExit("git archive did not provide an output stream")
    with tarfile.open(fileobj=producer.stdout, mode="r|") as archive:
        archive.extractall(output, filter="data")
    if producer.wait() != 0:
        raise subprocess.CalledProcessError(producer.returncode, command)


def commit(repository: Path, message: str, timestamp: str, paths: list[str]) -> str:
    run(["git", "init", "-q"], cwd=repository)
    run(["git", "add", "--", *paths], cwd=repository)
    environment = os.environ.copy()
    environment.update(
        {
            "GIT_AUTHOR_NAME": "Tavis Rudd",
            "GIT_AUTHOR_EMAIL": "tavis@damnsimple.com",
            "GIT_AUTHOR_DATE": timestamp,
            "GIT_COMMITTER_NAME": "Tavis Rudd",
            "GIT_COMMITTER_EMAIL": "tavis@damnsimple.com",
            "GIT_COMMITTER_DATE": timestamp,
        }
    )
    run(
        [
            "git",
            "-c",
            "commit.gpgsign=false",
            "commit",
            "-q",
            "-m",
            message,
        ],
        cwd=repository,
        env=environment,
    )
    return run(["git", "rev-parse", "HEAD"], cwd=repository, capture=True)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("output", type=Path)
    parser.add_argument(
        "--source-root",
        type=Path,
        default=Path(__file__).resolve().parents[3],
    )
    parser.add_argument("--revision", default="HEAD")
    args = parser.parse_args()

    source = args.source_root.resolve()
    output = args.output.resolve()
    if output.exists():
        raise SystemExit(f"refusing existing output path: {output}")

    revision = run(
        ["git", "rev-parse", "--verify", f"{args.revision}^{{commit}}"],
        cwd=source,
        capture=True,
    )
    owned_paths = (*PAPER_PATHS, *LEAN_PATHS)
    dirty = run(
        [
            "git",
            "status",
            "--porcelain=v1",
            "--untracked-files=all",
            "--",
            *(path.as_posix() for path in owned_paths),
        ],
        cwd=source,
        capture=True,
    )
    if dirty:
        raise SystemExit("release-owned source paths are not clean")

    paper_timestamp = run(
        [
            "git",
            "log",
            "-1",
            "--format=%aI",
            revision,
            "--",
            *(path.as_posix() for path in PAPER_PATHS),
        ],
        cwd=source,
        capture=True,
    )
    lean_timestamp = run(
        [
            "git",
            "log",
            "-1",
            "--format=%aI",
            revision,
            "--",
            *(path.as_posix() for path in LEAN_PATHS),
        ],
        cwd=source,
        capture=True,
    )
    output.mkdir(parents=True)
    extract_archive(source, revision, PAPER_PATHS, output)
    extract_archive(source, revision, LEAN_PATHS, output)

    paper_commit = commit(
        output,
        "Release projective Reed-Solomon syndromes R5-R7 candidate",
        paper_timestamp,
        [PAPER_PATH.as_posix()],
    )
    (output / ".git/info/exclude").write_text(
        "\n".join(
            (
                "/lean/",
                "*.aux",
                "*.bbl",
                "*.blg",
                "*.fdb_latexmk",
                "*.fls",
                "*.log",
                "*.out",
                "*.xdv",
                "",
            )
        ),
        encoding="utf-8",
    )
    lean_root = output / "lean"
    lean_commit = commit(
        lean_root,
        "Publish R5-R7 Lean verification closure",
        lean_timestamp,
        [
            "lakefile.toml",
            "lake-manifest.json",
            "lean-toolchain",
            "RelativeConicArcs",
        ],
    )
    print(
        json.dumps(
            {
                "source_commit": revision,
                "paper_commit": paper_commit,
                "lean_commit": lean_commit,
                "output": str(output),
            },
            sort_keys=True,
        )
    )


if __name__ == "__main__":
    main()
