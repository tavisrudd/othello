#!/usr/bin/env python3
"""Verify the pinned Lean sources and axiom audit for cubic-shadow recognition."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
from pathlib import Path


HERE = Path(__file__).resolve().parent
MANIFEST = HERE / "four_shadow_formal.json"
AXIOM_REPORT = HERE / "four_shadow_axioms.txt"
CLOSURE_INVENTORY = HERE / "four_shadow_source_closure.json"


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def parse_axioms(text: str) -> dict[str, list[str]]:
    pattern = re.compile(
        r"'([^']+)' (does not depend on any axioms|depends on axioms: \[(.*?)\])",
        re.DOTALL,
    )
    result: dict[str, list[str]] = {}
    for match in pattern.finditer(text):
        declaration = match.group(1)
        if declaration in result:
            raise SystemExit(
                "four-shadow formal replay: FAIL "
                f"[duplicate axiom output for {declaration}]"
            )
        body = match.group(3)
        result[declaration] = (
            []
            if body is None
            else [part.strip() for part in body.replace("\n", " ").split(",")]
        )
    return result


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--lean-root", type=Path, required=True)
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument(
        "--source-only",
        action="store_true",
        help="check the pinned transitive source closure without a live gate",
    )
    mode.add_argument(
        "--axiom-log",
        type=Path,
        help="stdout from elaborating the focused import-only gate",
    )
    args = parser.parse_args()

    manifest = json.loads(MANIFEST.read_text(encoding="utf-8"))
    lean_root = args.lean_root.resolve()
    toolchain = (lean_root / "lean-toolchain").read_text(encoding="utf-8").strip()
    if toolchain != manifest["lean_toolchain"]:
        raise SystemExit(f"four-shadow formal replay: FAIL [toolchain {toolchain!r}]")
    if sha256(AXIOM_REPORT) != manifest["axiom_report_sha256"]:
        raise SystemExit("four-shadow formal replay: FAIL [axiom report hash]")
    if sha256(Path(__file__).resolve()) != manifest["verifier_sha256"]:
        raise SystemExit("four-shadow formal replay: FAIL [verifier hash]")
    if sha256(CLOSURE_INVENTORY) != manifest["source_closure_sha256"]:
        raise SystemExit("four-shadow formal replay: FAIL [source closure hash]")

    provenance = manifest.get("axiom_report_provenance")
    if provenance is not None:
        # The tracked gate stdout is what makes the axiom report replayable by
        # someone other than its author, so its bytes are pinned like any other
        # input rather than merely referenced.
        log = HERE.parent / provenance["gate_stdout"]
        if not log.is_file():
            raise SystemExit(
                "four-shadow formal replay: FAIL [missing gate stdout "
                f"{provenance['gate_stdout']}]"
            )
        if sha256(log) != provenance["gate_stdout_sha256"]:
            raise SystemExit("four-shadow formal replay: FAIL [gate stdout hash]")

    inventory = json.loads(CLOSURE_INVENTORY.read_text(encoding="utf-8"))
    if inventory.get("roots") != [manifest["gate_module"]]:
        raise SystemExit("four-shadow formal replay: FAIL [source closure root]")
    observed_sources = {
        item["path"]: item["sha256"] for item in inventory.get("sources", [])
    }
    if observed_sources != manifest["source_sha256"]:
        raise SystemExit("four-shadow formal replay: FAIL [source closure inventory]")

    # A declaration keyword may be preceded by attributes and by any number of
    # modifiers, so anchoring on the bare keyword at line start is not a check:
    # `private axiom` walks straight past it.
    modifiers = (
        r"(?:@\[[^\]]*\]\s*|(?:private|protected|noncomputable|nonrec|scoped|local)\s+)*"
    )
    # The closure walk follows only project-local imports, so an import into
    # another package would leave a proof this replay never sees.  Confine the
    # externals to Mathlib, which the toolchain pin already fixes.
    for external in inventory.get("external_imports", []):
        if external != "Mathlib" and not external.startswith("Mathlib."):
            raise SystemExit(
                "four-shadow formal replay: FAIL [external import outside Mathlib: "
                f"{external}]"
            )

    forbidden = re.compile(
        rf"^\s*{modifiers}(?:axiom|opaque|partial|unsafe)\b", re.MULTILINE
    )
    # Mechanisms that would move a proof outside the kernel without introducing
    # an axiom the gate's `#print axioms` lines would show.  `set_option` is
    # covered because `debug.skipKernelTC` disables kernel typechecking outright
    # and leaves no trace in `#print axioms`.
    mechanisms = re.compile(
        r"\bnative_decide\b"
        r"|\bdecide\b[^\n]*\+\s*native"
        r"|\bnative\s*:=\s*true"
        r"|"
        r"(?:@\[|attribute\s*\[)[^\]]*(?:implemented_by|extern)"
        r"|\bofReduceBool\b"
        r"|\bset_option\s+(?:debug\.skipKernelTC|allowUnsafeReducibility"
        r"|debug\.byAsSorry|debug\.proofAsSorry"
        r"|debug\.terminalTacticsAsSorry)",
        re.MULTILINE,
    )
    workflow_id = re.compile(r"\bC[0-9]{3,}\b")
    # Workflow debris, not ordinary English: `pending`, `temporary` and
    # `fallback` are all plausible words in a mathematical docstring and were
    # refusing sources for no reason.
    workflow_prose = re.compile(
        r"\b(?:TODO|FIXME|XXX|HACK)\b",
    )
    for relative, expected in manifest["source_sha256"].items():
        source = lean_root / relative
        if not source.is_file():
            raise SystemExit(f"four-shadow formal replay: FAIL [missing {relative}]")
        if sha256(source) != expected:
            raise SystemExit(f"four-shadow formal replay: FAIL [hash {relative}]")
        text = source.read_text(encoding="utf-8")
        if (
            "sorry" in text
            or forbidden.search(text)
            or mechanisms.search(text)
            or workflow_id.search(text)
            or workflow_prose.search(text)
        ):
            raise SystemExit(f"four-shadow formal replay: FAIL [source policy {relative}]")

    expected = parse_axioms(AXIOM_REPORT.read_text(encoding="utf-8"))
    declarations = set(manifest["audited_declarations"])
    if set(expected) != declarations:
        raise SystemExit(
            "four-shadow formal replay: FAIL [manifest/report declaration mismatch]"
        )
    if args.axiom_log is not None:
        observed = parse_axioms(args.axiom_log.read_text(encoding="utf-8"))
        if observed != expected:
            raise SystemExit("four-shadow formal replay: FAIL [axiom report mismatch]")
        print("four-shadow formal replay: PASS [pinned sources and axiom audit]")
    else:
        print("four-shadow formal replay: PASS [pinned sources and toolchain]")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
