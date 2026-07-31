#!/usr/bin/env python3
"""Capture canonical stdout identities for the twenty exact Paper I checks."""

from __future__ import annotations

import argparse
import hashlib
import json
import subprocess
import sys
from pathlib import Path


BASE_CHECKERS = (
    "check_rigidity_degenerate_conic.py",
    "check_decoding.py",
    "check_chirality.py",
    "check_code_automorphisms.py",
    "check_global_conic_gap.py",
    "check_perturbation_gap.py",
    "check_low_degree_loci.py",
    "check_small_q_uniqueness.py",
    "check_q19_nonexample.py",
    "check_small_k_conic_filling.py",
    "check_q13_tangent_code.py",
    "check_orientation_two_graph.py",
    "verification/conic_filling_verify.py",
)

EXTRA_CHECKERS = (
    (
        "finite-census-direct",
        (sys.executable, "verification/build_finite_census_certificates.py"),
    ),
    (
        "finite-census-audit",
        (sys.executable, "verification/build_finite_census_certificates.py", "--audit"),
    ),
    (
        "q13-weight-ten-certificate",
        (sys.executable, "verification/c723_q13_weight10_profiles.py", "--check"),
    ),
    (
        "q13-weight-ten-independent",
        (sys.executable, "verification/c723_q13_weight10_independent.py"),
    ),
    (
        "terminal-orbit-dag-direct",
        (sys.executable, "verification/c725_terminal_orbit_dag.py"),
    ),
    (
        "terminal-orbit-dag-regeneration",
        (sys.executable, "verification/c725_terminal_orbit_dag.py", "--check"),
    ),
    (
        "terminal-orbit-dag-independent",
        (sys.executable, "verification/c725_terminal_orbit_dag_replay.py", "--check"),
    ),
)

CHECKERS = tuple(
    (script, (sys.executable, script)) for script in BASE_CHECKERS
) + EXTRA_CHECKERS


def capture_one(paper_root: Path, checker: str, argv: tuple[str, ...]) -> dict[str, object]:
    completed = subprocess.run(
        argv,
        cwd=paper_root,
        check=False,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    if completed.returncode != 0:
        detail = completed.stderr.decode("utf-8", errors="replace").splitlines()
        raise RuntimeError(
            f"{checker} failed with exit {completed.returncode}: "
            + "\n".join(detail[-10:])
        )
    stdout = completed.stdout
    return {
        "bytes": len(stdout),
        "lines": len(stdout.splitlines()),
        "sha256": hashlib.sha256(stdout).hexdigest(),
    }


def capture(paper_root: Path) -> dict[str, object]:
    results = {
        checker: capture_one(paper_root, checker, argv)
        for checker, argv in CHECKERS
    }
    return {
        "schema": "clebsch-rigidity-checker-output-v2",
        "checks": results,
    }


def main() -> int:
    paper_root = Path(__file__).resolve().parents[1]
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--check",
        type=Path,
        help="compare the fresh canonical identities with this tracked JSON file",
    )
    parser.add_argument(
        "--output",
        type=Path,
        help="write the fresh canonical identities to this JSON file",
    )
    parser.add_argument(
        "--only",
        choices=[checker for checker, _ in CHECKERS],
        help="capture one named check and print its canonical record",
    )
    args = parser.parse_args()
    if args.check is not None and args.output is not None:
        parser.error("--check and --output are mutually exclusive")
    if args.only is not None:
        if args.check is not None or args.output is not None:
            parser.error("--only cannot be combined with --check or --output")
        argv = dict(CHECKERS)[args.only]
        print(json.dumps(capture_one(paper_root, args.only, argv), sort_keys=True))
        return 0
    rendered = json.dumps(capture(paper_root), indent=2, sort_keys=True) + "\n"
    if args.check is not None:
        if args.check.read_text(encoding="utf-8") != rendered:
            raise RuntimeError(f"stale checker-output certificate: {args.check}")
    elif args.output is not None:
        args.output.write_text(rendered, encoding="utf-8")
    else:
        print(rendered, end="")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (OSError, UnicodeError, RuntimeError) as error:
        print(f"checker-output capture failed: {error}", file=sys.stderr)
        raise SystemExit(1)
