#!/usr/bin/env python3
"""Regenerate the Q25 normalized row leaves with two explicit legal witnesses.

The existing C99 enumerator remains the geometric source.  This script compiles two deterministic
variants of its ``--lean-row`` mode: one scans orbit codes in ascending order and one in descending
order.  For every normalized arc row the proposed witnesses are therefore distinct (the census has
at least 32, but only distinctness is trusted downstream).  Lean independently checks both
``LegalPair`` propositions and their inequality.

Run without ``--rewrite`` to enumerate and validate the proposal map.  ``--rewrite`` performs the
mechanical replacement in the generated leaf sources.
"""

from __future__ import annotations

import argparse
import hashlib
import re
import subprocess
import tempfile
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "notes/2026-07-13-c99-f2-enumerator.cpp"
ROWS = ROOT / "lean/RelativeConicArcs/Q25PairRows"

DECLARATION = (
    "const int coverNumbers[16]={59,39,85,168,147,219,237,183,116,249,167,60,196,231,114,157};"
)
ASCENDING = (
    "std::vector<int> coverNumbers; "
    "for (int qn=0; qn<310; ++qn) coverNumbers.push_back(qn);"
)
DESCENDING = (
    "std::vector<int> coverNumbers; "
    "for (int qn=309; qn>=0; --qn) coverNumbers.push_back(qn);"
)

THEOREM_RE = re.compile(r"^theorem row_(\d+)_(\d+)\b")
OLD_LEGAL_RE = re.compile(
    r"^(\s*)exact Or\.inr ⟨orbitCodeOfNumber ⟨(\d+), by decide⟩, by decide⟩$"
)


def compile_variant(source: str, replacement: str, output: Path) -> None:
    if source.count(DECLARATION) != 1:
        raise RuntimeError("the C99 cover declaration changed; inspect before regenerating")
    variant = source.replace(DECLARATION, replacement)
    subprocess.run(
        [
            "g++", "-O3", "-std=c++20", "-Wall", "-Wextra", "-pedantic",
            "-x", "c++", "-", "-o", str(output),
        ],
        input=variant,
        text=True,
        check=True,
    )


def emit_row(executable: Path, b: int) -> dict[int, tuple[str, tuple[int, ...]]]:
    result = subprocess.run(
        [str(executable), "--lean-row", str(b)],
        check=True,
        text=True,
        capture_output=True,
    )
    parsed: dict[int, tuple[str, tuple[int, ...]]] = {}
    for line in result.stdout.splitlines():
        fields = line.split()
        c, kind = int(fields[0]), fields[1]
        parsed[c] = (kind, tuple(map(int, fields[2:])))
    if set(parsed) != set(range(310)):
        raise RuntimeError(f"row {b}: emitter did not return all 310 column codes")
    return parsed


def proposal_map(ascending: Path, descending: Path) -> dict[tuple[int, int], tuple[int, int]]:
    proposals: dict[tuple[int, int], tuple[int, int]] = {}
    for b in range(6, 309):
        asc = emit_row(ascending, b)
        desc = emit_row(descending, b)
        for c in range(b + 1, 310):
            ak, av = asc[c]
            dk, dv = desc[c]
            if ak != dk:
                raise RuntimeError(f"row ({b},{c}): ascending/descending classification differs")
            if ak == "B":
                if av != dv:
                    raise RuntimeError(f"row ({b},{c}): bad-witness triples differ")
            elif ak == "L":
                if len(av) != 1 or len(dv) != 1 or av[0] == dv[0]:
                    raise RuntimeError(f"row ({b},{c}): two distinct legal proposals not found")
                proposals[b, c] = av[0], dv[0]
            else:
                raise RuntimeError(f"row ({b},{c}): unexpected emitter kind {ak!r}")
        if b % 25 == 0:
            print(f"enumerated through b={b}: {len(proposals)} valid rows", flush=True)
    return proposals


def rewrite_rows(proposals: dict[tuple[int, int], tuple[int, int]]) -> tuple[int, int]:
    replacements = 0
    changed_files = 0
    seen: set[tuple[int, int]] = set()
    for path in sorted(ROWS.glob("*.lean")):
        source = path.read_text()
        current: tuple[int, int] | None = None
        output: list[str] = []
        changed = False
        for line in source.splitlines():
            theorem = THEOREM_RE.match(line)
            if theorem:
                current = int(theorem.group(1)), int(theorem.group(2))
            legal = OLD_LEGAL_RE.match(line)
            if legal:
                if current is None or current not in proposals:
                    raise RuntimeError(f"{path}: legal proof has no generated proposal")
                q, r = proposals[current]
                indent = legal.group(1)
                output.append(
                    f"{indent}exact Or.inr ⟨orbitCodeOfNumber ⟨{q}, by decide⟩,"
                )
                output.append(
                    f"{indent}  orbitCodeOfNumber ⟨{r}, by decide⟩, by decide⟩"
                )
                replacements += 1
                seen.add(current)
                changed = True
            else:
                output.append(line)
        if changed:
            path.write_text("\n".join(output) + "\n")
            changed_files += 1
    if seen != set(proposals):
        missing = sorted(set(proposals) - seen)[:10]
        extra = sorted(seen - set(proposals))[:10]
        raise RuntimeError(f"row-source coverage mismatch; missing={missing}, extra={extra}")
    return replacements, changed_files


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--rewrite", action="store_true")
    args = parser.parse_args()

    source = SOURCE.read_text()
    digest = hashlib.sha256(source.encode()).hexdigest()
    print(f"source={SOURCE.relative_to(ROOT)} sha256={digest}")
    with tempfile.TemporaryDirectory(prefix="c143-two-witness-") as directory:
        directory = Path(directory)
        ascending = directory / "ascending"
        descending = directory / "descending"
        compile_variant(source, ASCENDING, ascending)
        compile_variant(source, DESCENDING, descending)
        proposals = proposal_map(ascending, descending)
    print(f"two-witness proposals={len(proposals)}")
    if len(proposals) != 7044:
        raise RuntimeError(f"expected 7044 valid rows, found {len(proposals)}")
    if args.rewrite:
        replacements, changed_files = rewrite_rows(proposals)
        print(f"rewritten legal proofs={replacements} files={changed_files}")


if __name__ == "__main__":
    main()
