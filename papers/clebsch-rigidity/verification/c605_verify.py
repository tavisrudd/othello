#!/usr/bin/env python3
"""Regenerate and independently replay the C605 exclusion certificates."""

from __future__ import annotations

import argparse
import json
import subprocess
import sys
import tempfile
from pathlib import Path


PAPER_ROOT = Path(__file__).resolve().parents[1]
VERIFICATION_ROOT = PAPER_ROOT / "verification"
SOURCE = VERIFICATION_ROOT / "c605_search.cpp"
REPLAY = VERIFICATION_ROOT / "c605_replay.py"
FIELDS = (13, 17, 19)


def run(command: list[str], *, stdout: Path | None = None) -> None:
    if stdout is None:
        subprocess.run(
            command,
            cwd=PAPER_ROOT,
            check=True,
            stdout=subprocess.DEVNULL,
            stderr=None,
        )
        return
    with stdout.open("wb") as destination:
        subprocess.run(
            command,
            cwd=PAPER_ROOT,
            check=True,
            stdout=destination,
            stderr=None,
        )


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.parse_args()

    with tempfile.TemporaryDirectory(prefix="c605-") as directory:
        temporary = Path(directory)
        executable = temporary / "c605-search"
        run(
            [
                "g++",
                "-O3",
                "-std=c++17",
                "-Wall",
                "-Wextra",
                "-pedantic",
                str(SOURCE),
                "-o",
                str(executable),
            ]
        )
        generated: list[Path] = []
        for q in FIELDS:
            output = temporary / f"c605_q{q}.json"
            run([str(executable), str(q)], stdout=output)
            tracked = VERIFICATION_ROOT / output.name
            if output.read_bytes() != tracked.read_bytes():
                raise SystemExit(f"certificate drift: {tracked}")
            generated.append(output)

        independent = temporary / "c605_independent.json"
        run([sys.executable, str(REPLAY), *map(str, generated)], stdout=independent)
        tracked_independent = VERIFICATION_ROOT / independent.name
        if independent.read_bytes() != tracked_independent.read_bytes():
            raise SystemExit(f"certificate drift: {tracked_independent}")

    fields = json.loads(tracked_independent.read_text())["fields"]
    summary = {
        "fields": [
            {
                "q": field["q"],
                "maximum_passant_arc_size": field["maximum_passant_arc_size"],
                "filling_eight_arc_orbits": field["filling_eight_arc_orbits"],
            }
            for field in fields
        ],
        "status": "ok",
    }
    print(json.dumps(summary, sort_keys=True, separators=(",", ":")))


if __name__ == "__main__":
    main()
