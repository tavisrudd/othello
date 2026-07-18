#!/usr/bin/env python3
"""Run the Lean fact exporter for each declared extraction unit and write its facts artifact.

`lean-trust-spine.py` compares declarations against facts and never builds.  This is the other
half: the only component that puts Lean itself in the loop.  It is separate on purpose, so that
`audit` and `check` remain read-only commands that cannot be tempted into starting a build to fill
in a missing artifact.

The Lean side of the exporter is `trust-spine-export.lean`.  This driver reads it, wraps it with one
`import` of the extraction unit and one `#eval`, elaborates the wrapper through `guarded-lean`, then
canonicalizes what Lean reported into `lean/trust/facts/<unit>.json`.  Canonicalization lives here
rather than in Lean so that the metaprogram stays small enough to audit by reading it, and so two
runs of the same environment produce byte-identical artifacts regardless of constant-map ordering.

    lean/scripts/lean-trust-extract.py plan
    lean/scripts/lean-trust-extract.py wrapper RelativeConicArcs.Gates.Baer --out /home/<dir>/w.lean
    lean/scripts/lean-trust-extract.py run --area relconic
    lean/scripts/lean-trust-extract.py canonicalize <raw.json> --unit <U> --out <facts.json>

`plan`, `wrapper`, and `canonicalize` never run Lean.  Only `run` does, and it refuses to start
while the Lean worktree carries work this lane does not own — an extraction taken across another
lane's in-flight edits would describe a tree that never existed at any commit.
"""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import os
import re
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Any

LEAN_ROOT_DEFAULT = Path(__file__).resolve().parents[1]
EXPORTER_NAME = "trust-spine-export.lean"
FACTS_SCHEMA_VERSION = 1

EXIT_OK = 0
EXIT_FAILED = 1
EXIT_REFUSED = 2

# Build state never goes under /tmp: it is tmpfs on this host and counts against RAM.
SCRATCH_DEFAULT = Path.home() / ".cache" / "othello-lean-build" / "trust-extract"

# Paths the build-sys lane owns.  Anything else modified under lean/ means another lane is mid-flight
# and the tree does not correspond to a commit, so an extraction from it would be unattributable.
OWNED_PREFIXES = ("lean/scripts/", "lean/trust/")

NAME_RE = re.compile(r"^[^\s\"\\]+$")
IMPORT_LINE_RE = re.compile(r"^\s*import\s+")


class Refused(Exception):
    """A precondition failed.  Nothing was written and no Lean process was started."""


# --------------------------------------------------------------------------------------------
# registry access


def load_spine_module(lean_root: Path) -> Any:
    """Import `lean-trust-spine.py` for its registry loader.

    The hyphenated filename is not importable by name, and duplicating the TOML schema here would
    let the two halves of the spine drift apart silently.
    """
    path = lean_root / "scripts" / "lean-trust-spine.py"
    if not path.is_file():
        raise Refused(f"{path} is missing; the extractor reads its registry loader")
    spec = importlib.util.spec_from_file_location("lean_trust_spine", path)
    if spec is None or spec.loader is None:
        raise Refused(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules["lean_trust_spine"] = module
    spec.loader.exec_module(module)
    return module


@dataclass(frozen=True)
class Unit:
    area: str
    module: str
    terminals: tuple[str, ...]


def declared_units(registry: Any, area_filter: str | None) -> list[Unit]:
    units: list[Unit] = []
    for area in registry.areas:
        if area_filter is not None and area.name != area_filter:
            continue
        for unit in area.extraction_units:
            units.append(
                Unit(area=area.name, module=unit.module, terminals=tuple(unit.terminals))
            )
    if area_filter is not None and not units:
        known = ", ".join(sorted(a.name for a in registry.areas))
        raise Refused(f"no area named {area_filter!r}; declared areas: {known}")
    return sorted(units, key=lambda u: (u.area, u.module))


# --------------------------------------------------------------------------------------------
# environment facts the driver contributes


def sha256_file(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def read_toolchain(lean_root: Path) -> str:
    path = lean_root / "lean-toolchain"
    if not path.is_file():
        raise Refused(f"{path} is missing; the facts artifact records the pinned toolchain")
    return path.read_text(encoding="utf-8").strip()


def read_mathlib_rev(lean_root: Path) -> str:
    """The pinned Mathlib revision, from the lake manifest rather than a working checkout.

    A revision read from `.lake/packages/mathlib` would report whatever happens to be on disk; the
    manifest is what the build actually resolves against.
    """
    path = lean_root / "lake-manifest.json"
    if not path.is_file():
        raise Refused(f"{path} is missing; the facts artifact records the pinned Mathlib revision")
    doc = json.loads(path.read_text(encoding="utf-8"))
    for package in doc.get("packages", []):
        if package.get("name") == "mathlib":
            rev = package.get("rev")
            if not rev:
                raise Refused("lake-manifest.json has a mathlib entry with no rev")
            return str(rev)
    raise Refused("lake-manifest.json declares no mathlib package")


# --------------------------------------------------------------------------------------------
# wrapper generation


def exporter_body(lean_root: Path) -> str:
    """The exporter source with its own imports removed.

    Lean accepts imports only in the header, so the wrapper emits one import block covering both
    `Lean` and the extraction unit, and the body follows it.
    """
    path = lean_root / "scripts" / EXPORTER_NAME
    if not path.is_file():
        raise Refused(f"{path} is missing")
    kept = [line for line in path.read_text(encoding="utf-8").splitlines() if not IMPORT_LINE_RE.match(line)]
    return "\n".join(kept).strip("\n")


def lean_name_literal(name: str) -> str:
    if not NAME_RE.match(name):
        raise Refused(f"refusing to emit a Lean name literal for {name!r}")
    return "`" + name


def lean_string_literal(value: str) -> str:
    if '"' in value or "\\" in value or "\n" in value:
        raise Refused(f"refusing to emit a Lean string literal for {value!r}")
    return '"' + value + '"'


def render_wrapper(
    lean_root: Path,
    unit: Unit,
    roots: tuple[str, ...],
    out_path: Path,
    include_uses: bool,
    import_unit: bool = True,
) -> str:
    """Build the file that is actually elaborated.

    Everything variable is a literal in this file rather than an environment variable, so the exact
    bytes that produced an artifact can be kept next to it and re-elaborated unchanged.

    `import_unit := False` is the self-test shape: the same exporter, the same `#eval`, but no
    project import, so the whole path can be exercised against core `Lean` while another lane holds
    the tree.
    """
    body = exporter_body(lean_root)
    roots_literal = ", ".join(lean_name_literal(root) for root in roots)
    terminals_literal = ", ".join(lean_name_literal(t) for t in unit.terminals)
    header = "\n".join(
        [
            "-- Generated by lean/scripts/lean-trust-extract.py.  Do not edit and do not track.",
            f"-- Extraction unit: {unit.module}",
            "import Lean",
            *([f"import {unit.module}"] if import_unit else ["-- self-test: no project import"]),
            "",
        ]
    )
    call = "\n".join(
        [
            "",
            "#eval TrustSpine.run",
            f"  (unit := {lean_name_literal(unit.module)})",
            f"  (roots := #[{roots_literal}])",
            f"  (terminals := #[{terminals_literal}])",
            f"  (leanToolchain := {lean_string_literal(read_toolchain(lean_root))})",
            f"  (mathlibRev := {lean_string_literal(read_mathlib_rev(lean_root))})",
            f"  (exporterSha256 := {lean_string_literal(sha256_file(lean_root / 'scripts' / EXPORTER_NAME))})",
            f"  (outPath := {lean_string_literal(str(out_path))})",
            f"  (includeUses := {'true' if include_uses else 'false'})",
            "",
        ]
    )
    return header + body + "\n" + call


# --------------------------------------------------------------------------------------------
# ownership guard


def worktree_intrusions(repo_root: Path) -> list[str]:
    """Modified paths under `lean/` that this lane does not own.

    Returns paths, not a verdict, so the caller can name them in its refusal.  A foreign edit is not
    a reason to fix anything; it is a reason to wait for a quiet window.
    """
    result = subprocess.run(
        ["git", "status", "--porcelain", "--", "lean/"],
        cwd=repo_root,
        capture_output=True,
        text=True,
        check=False,
    )
    if result.returncode != 0:
        raise Refused(f"git status failed under {repo_root}")
    intrusions = []
    for line in result.stdout.splitlines():
        if not line.strip():
            continue
        path = line[3:].strip()
        if " -> " in path:  # a rename reports both sides
            path = path.split(" -> ", 1)[1]
        path = path.strip('"')
        if not any(path.startswith(prefix) for prefix in OWNED_PREFIXES):
            intrusions.append(path)
    return sorted(intrusions)


def assert_quiet_window(repo_root: Path) -> None:
    intrusions = worktree_intrusions(repo_root)
    if intrusions:
        shown = "\n  ".join(intrusions[:8])
        more = f"\n  ... and {len(intrusions) - 8} more" if len(intrusions) > 8 else ""
        raise Refused(
            "the Lean worktree carries changes this lane does not own, so an extraction taken now "
            "would describe a tree that exists at no commit:\n  " + shown + more
        )


# --------------------------------------------------------------------------------------------
# canonicalization


def _names(value: Any, where: str) -> list[str]:
    if not isinstance(value, list):
        raise Refused(f"{where}: expected a list of names")
    out = []
    for item in value:
        if not isinstance(item, str) or not item or not NAME_RE.match(item):
            raise Refused(f"{where}: {item!r} is not a usable declaration name")
        out.append(item)
    return out


def canonicalize(raw: dict[str, Any], unit: str) -> dict[str, Any]:
    """Turn what Lean reported into the tracked artifact.

    Sorting and deduplication happen here.  `uses` is additionally restricted to targets that appear
    in `project_declarations`: the exporter filters names by defining module, but a type can still
    mention a project constant that the same filter dropped as compiler-internal, and an edge to a
    node the artifact does not list would make the graph unreadable rather than more complete.
    """
    version = raw.get("schema_version")
    if version != FACTS_SCHEMA_VERSION:
        raise Refused(f"exporter emitted schema_version {version!r} != {FACTS_SCHEMA_VERSION}")
    reported_unit = raw.get("unit")
    if reported_unit != unit:
        raise Refused(f"exporter emitted facts for {reported_unit!r}, expected {unit!r}")

    declarations = sorted(set(_names(raw.get("project_declarations", []), "project_declarations")))
    declared = set(declarations)

    axioms = sorted(set(_names(raw.get("project_axioms", []), "project_axioms")))
    unknown_axioms = sorted(set(axioms) - declared)
    if unknown_axioms:
        raise Refused(
            f"project_axioms names {unknown_axioms[0]} which is absent from project_declarations"
        )

    declaration_module_raw = raw.get("declaration_module", {})
    if not isinstance(declaration_module_raw, dict):
        raise Refused("declaration_module: expected an object")
    declaration_module = {}
    for name, module in sorted(declaration_module_raw.items()):
        if name not in declared:
            continue
        if not isinstance(module, str) or not NAME_RE.match(module):
            raise Refused(f"declaration_module[{name}]: {module!r} is not a module name")
        declaration_module[name] = module
    missing_modules = sorted(declared - set(declaration_module))
    if missing_modules:
        raise Refused(f"{missing_modules[0]} has no defining module in declaration_module")

    terminal_axioms_raw = raw.get("terminal_axioms", {})
    if not isinstance(terminal_axioms_raw, dict):
        raise Refused("terminal_axioms: expected an object")
    terminal_axioms = {
        name: sorted(set(_names(value, f"terminal_axioms[{name}]")))
        for name, value in sorted(terminal_axioms_raw.items())
    }

    uses_raw = raw.get("uses", {})
    if not isinstance(uses_raw, dict):
        raise Refused("uses: expected an object")
    uses = {}
    for name, targets in sorted(uses_raw.items()):
        if name not in declared:
            continue
        kept = sorted({t for t in _names(targets, f"uses[{name}]") if t in declared and t != name})
        if kept:
            uses[name] = kept

    return {
        "schema_version": FACTS_SCHEMA_VERSION,
        "unit": unit,
        "lean_version": str(raw.get("lean_version", "")),
        "lean_toolchain": str(raw.get("lean_toolchain", "")),
        "mathlib_rev": str(raw.get("mathlib_rev", "")),
        "exporter_sha256": str(raw.get("exporter_sha256", "")),
        "uses_included": bool(raw.get("uses_included", False)),
        "closure": sorted(set(_names(raw.get("closure", []), "closure"))),
        "project_declarations": declarations,
        "project_axioms": axioms,
        "terminal_axioms": terminal_axioms,
        "declaration_module": declaration_module,
        "uses": uses,
        "opaque": sorted(set(_names(raw.get("opaque", []), "opaque"))),
    }


def verify_environment(facts: dict[str, Any], lean_root: Path) -> None:
    """Refuse an artifact that does not describe this checkout.

    A facts file whose toolchain, Mathlib pin, or exporter digest disagrees with the tree is not a
    weaker fact; it is a fact about something else.
    """
    expected_toolchain = read_toolchain(lean_root)
    if facts["lean_toolchain"] != expected_toolchain:
        raise Refused(
            f"facts record toolchain {facts['lean_toolchain']!r}, tree pins {expected_toolchain!r}"
        )
    expected_rev = read_mathlib_rev(lean_root)
    if facts["mathlib_rev"] != expected_rev:
        raise Refused(f"facts record Mathlib {facts['mathlib_rev']!r}, manifest pins {expected_rev!r}")
    expected_sha = sha256_file(lean_root / "scripts" / EXPORTER_NAME)
    if facts["exporter_sha256"] != expected_sha:
        raise Refused("facts record a different exporter digest than the tracked exporter")


def write_facts(facts: dict[str, Any], out_path: Path) -> None:
    out_path.parent.mkdir(parents=True, exist_ok=True)
    out_path.write_text(json.dumps(facts, indent=2, sort_keys=True) + "\n", encoding="utf-8")


# --------------------------------------------------------------------------------------------
# Lean invocation


def run_guarded_lean(lean_root: Path, wrapper: Path) -> None:
    """Elaborate one wrapper through the documented single-file entry point.

    `guarded-lean` owns the resource profile, CPU set, and output bounding.  Composing a taskset or
    lake command here would bypass the preflight that keeps a build from taking the host down.
    """
    script = lean_root / "scripts" / "guarded-lean"
    if not script.is_file():
        raise Refused(f"{script} is missing")
    result = subprocess.run(
        [str(script), str(wrapper)],
        cwd=lean_root,
        capture_output=True,
        text=True,
        check=False,
    )
    if result.returncode != 0:
        tail = "\n".join(result.stdout.strip().splitlines()[-12:])
        raise Refused(f"guarded-lean failed for {wrapper.name} (exit {result.returncode}):\n{tail}")


def extract_unit(
    lean_root: Path,
    repo_root: Path,
    unit: Unit,
    roots: tuple[str, ...],
    scratch: Path,
    include_uses: bool,
) -> Path:
    unit_scratch = scratch / unit.module
    unit_scratch.mkdir(parents=True, exist_ok=True)
    raw_path = unit_scratch / "raw.json"
    wrapper_path = unit_scratch / "wrapper.lean"
    if raw_path.exists():
        raw_path.unlink()
    wrapper_path.write_text(
        render_wrapper(lean_root, unit, roots, raw_path, include_uses), encoding="utf-8"
    )
    run_guarded_lean(lean_root, wrapper_path)
    if not raw_path.is_file():
        raise Refused(
            f"{unit.module}: guarded-lean reported success but wrote no artifact at {raw_path}; "
            "the #eval did not run"
        )
    raw = json.loads(raw_path.read_text(encoding="utf-8"))
    facts = canonicalize(raw, unit.module)
    verify_environment(facts, lean_root)
    out_path = lean_root / "trust" / "facts" / f"{unit.module}.json"
    write_facts(facts, out_path)
    return out_path


# --------------------------------------------------------------------------------------------
# commands


def cmd_plan(args: argparse.Namespace) -> int:
    lean_root = Path(args.lean_root).resolve()
    spine = load_spine_module(lean_root)
    registry = spine.load_registry(lean_root / "trust")
    units = declared_units(registry, args.area)
    print(f"project roots: {', '.join(sorted(registry.libraries))}")
    print(f"toolchain: {read_toolchain(lean_root)}")
    print(f"mathlib: {read_mathlib_rev(lean_root)}")
    for unit in units:
        state = "extracted" if (lean_root / "trust" / "facts" / f"{unit.module}.json").is_file() else "missing"
        terminals = f"{len(unit.terminals)} terminal(s)" if unit.terminals else "no terminals"
        print(f"  [{state:9}] {unit.area}: {unit.module} ({terminals})")
    intrusions = worktree_intrusions(Path(args.repo_root).resolve())
    print(f"quiet window: {'no — ' + str(len(intrusions)) + ' foreign path(s)' if intrusions else 'yes'}")
    return EXIT_OK


def cmd_wrapper(args: argparse.Namespace) -> int:
    lean_root = Path(args.lean_root).resolve()
    spine = load_spine_module(lean_root)
    registry = spine.load_registry(lean_root / "trust")
    units = {unit.module: unit for unit in declared_units(registry, None)}
    if args.unit not in units:
        raise Refused(f"{args.unit} is not a declared extraction unit")
    text = render_wrapper(
        lean_root,
        units[args.unit],
        tuple(sorted(registry.libraries)),
        Path(args.raw_out).resolve(),
        not args.no_uses,
    )
    Path(args.out).write_text(text, encoding="utf-8")
    print(f"wrote {args.out}")
    return EXIT_OK


def cmd_canonicalize(args: argparse.Namespace) -> int:
    lean_root = Path(args.lean_root).resolve()
    raw = json.loads(Path(args.raw).read_text(encoding="utf-8"))
    facts = canonicalize(raw, args.unit)
    if not args.skip_environment_check:
        verify_environment(facts, lean_root)
    write_facts(facts, Path(args.out))
    print(f"wrote {args.out}")
    return EXIT_OK


# The self-test asks core Lean a question whose answer is fixed and independently checkable with
# `#print axioms Classical.em`: excluded middle rests on all three of Lean's standard axioms.  If the
# exporter reported an empty axiom set the artifact would still be schema-valid, so the assertion has
# to name a specific, known, non-empty result rather than merely require well-formed output.
SELFTEST_UNIT = "TrustSpine.SelfTest"
SELFTEST_ROOT = "Init.Classical"
SELFTEST_TERMINAL = "Classical.em"
SELFTEST_EXPECTED_AXIOMS = ("Classical.choice", "Quot.sound", "propext")
# `Classical.byContradiction : ¬¬a → a` names no `Classical` constant in its type, so an edge to
# `Classical.propDecidable` can only have come from its proof term.  This is the guard for the
# question the plan flags for review: whether proof bodies are available, or whether the dependency
# graph is merely type-level and therefore partial.
SELFTEST_PROOF_EDGE = ("Classical.byContradiction", "Classical.propDecidable")
# Core `Init.Classical` declares nothing `opaque`.  A non-zero count here means the boundary rule has
# regressed to classifying theorems as unavailable, which reports a complete graph as partial.
SELFTEST_EXPECTED_OPAQUE = 0


def cmd_selftest(args: argparse.Namespace) -> int:
    """Exercise the full extraction path against core Lean, importing no project module.

    This is what makes a scarce build window cheap to spend: by the time the tree is quiet, the
    wrapper shape, the `#eval`, `collectAxioms`, the JSON write, and every validation below have
    already been shown to work.  The only untested variable left is the project closure itself.
    """
    lean_root = Path(args.lean_root).resolve()
    scratch = Path(args.scratch).resolve()
    if str(scratch) == "/tmp" or str(scratch).startswith("/tmp/"):
        raise Refused("/tmp is tmpfs on this host; use a disk-backed scratch directory")

    unit_scratch = scratch / SELFTEST_UNIT
    unit_scratch.mkdir(parents=True, exist_ok=True)
    raw_path = unit_scratch / "raw.json"
    wrapper_path = unit_scratch / "wrapper.lean"
    if raw_path.exists():
        raw_path.unlink()

    unit = Unit(area="selftest", module=SELFTEST_UNIT, terminals=(SELFTEST_TERMINAL,))
    wrapper_path.write_text(
        render_wrapper(lean_root, unit, (SELFTEST_ROOT,), raw_path, True, import_unit=False),
        encoding="utf-8",
    )
    run_guarded_lean(lean_root, wrapper_path)
    if not raw_path.is_file():
        raise Refused(f"guarded-lean succeeded but wrote no artifact at {raw_path}")

    facts = canonicalize(json.loads(raw_path.read_text(encoding="utf-8")), SELFTEST_UNIT)
    verify_environment(facts, lean_root)

    observed = tuple(facts["terminal_axioms"].get(SELFTEST_TERMINAL, ()))
    if observed != SELFTEST_EXPECTED_AXIOMS:
        raise Refused(
            f"collectAxioms reported {list(observed)} for {SELFTEST_TERMINAL}, expected "
            f"{list(SELFTEST_EXPECTED_AXIOMS)}"
        )
    if not facts["project_declarations"]:
        raise Refused(f"no declarations were collected under {SELFTEST_ROOT}; the filter matched nothing")

    source, target = SELFTEST_PROOF_EDGE
    if target not in facts["uses"].get(source, []):
        raise Refused(
            f"{source} has no recorded edge to {target}; that edge exists only in the proof term, so "
            "the dependency graph has become type-level only and every `uses` claim is partial"
        )
    if len(facts["opaque"]) != SELFTEST_EXPECTED_OPAQUE:
        raise Refused(
            f"{len(facts['opaque'])} opaque boundaries under {SELFTEST_ROOT}, expected "
            f"{SELFTEST_EXPECTED_OPAQUE}; theorems are being misreported as bodyless"
        )

    print(f"selftest ok: lean {facts['lean_version']}")
    print(f"  {len(facts['project_declarations'])} declaration(s) under {SELFTEST_ROOT}")
    print(f"  {SELFTEST_TERMINAL} -> {', '.join(observed)}")
    print(f"  uses edges: {len(facts['uses'])}, opaque boundaries: {len(facts['opaque'])}")
    return EXIT_OK


def cmd_run(args: argparse.Namespace) -> int:
    lean_root = Path(args.lean_root).resolve()
    repo_root = Path(args.repo_root).resolve()
    scratch = Path(args.scratch).resolve()
    if str(scratch) == "/tmp" or str(scratch).startswith("/tmp/"):
        raise Refused("/tmp is tmpfs on this host; use a disk-backed scratch directory")

    spine = load_spine_module(lean_root)
    registry = spine.load_registry(lean_root / "trust")
    units = declared_units(registry, args.area)
    if args.unit:
        units = [unit for unit in units if unit.module in set(args.unit)]
        missing = set(args.unit) - {unit.module for unit in units}
        if missing:
            raise Refused(f"{sorted(missing)[0]} is not a declared extraction unit")
    if not units:
        raise Refused("no extraction units selected")

    assert_quiet_window(repo_root)

    roots = tuple(sorted(registry.libraries))
    written = []
    for unit in units:
        written.append(extract_unit(lean_root, repo_root, unit, roots, scratch, not args.no_uses))
        print(f"extracted {unit.module}")
    for path in written:
        print(f"  {path.relative_to(lean_root.parent)}")
    return EXIT_OK


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--lean-root", default=str(LEAN_ROOT_DEFAULT))
    parser.add_argument("--repo-root", default=str(LEAN_ROOT_DEFAULT.parent))
    sub = parser.add_subparsers(dest="command", required=True)

    plan = sub.add_parser("plan", help="list declared extraction units; runs no Lean")
    plan.add_argument("--area")
    plan.set_defaults(func=cmd_plan)

    wrapper = sub.add_parser("wrapper", help="write the generated wrapper only; runs no Lean")
    wrapper.add_argument("unit")
    wrapper.add_argument("--out", required=True)
    wrapper.add_argument("--raw-out", default="/home/unset/raw.json")
    wrapper.add_argument("--no-uses", action="store_true")
    wrapper.set_defaults(func=cmd_wrapper)

    canon = sub.add_parser("canonicalize", help="turn raw exporter output into a facts artifact")
    canon.add_argument("raw")
    canon.add_argument("--unit", required=True)
    canon.add_argument("--out", required=True)
    canon.add_argument("--skip-environment-check", action="store_true")
    canon.set_defaults(func=cmd_canonicalize)

    selftest = sub.add_parser(
        "selftest", help="exercise the extraction path against core Lean; imports no project module"
    )
    selftest.add_argument("--scratch", default=str(SCRATCH_DEFAULT))
    selftest.set_defaults(func=cmd_selftest)

    run = sub.add_parser("run", help="elaborate each unit through guarded-lean and write facts")
    run.add_argument("--area")
    run.add_argument("--unit", action="append")
    run.add_argument("--scratch", default=str(SCRATCH_DEFAULT))
    run.add_argument("--no-uses", action="store_true")
    run.set_defaults(func=cmd_run)

    return parser


def main(argv: list[str] | None = None) -> int:
    args = build_parser().parse_args(argv)
    try:
        return int(args.func(args))
    except Refused as exc:
        print(f"refused: {exc}", file=sys.stderr)
        return EXIT_REFUSED


if __name__ == "__main__":
    sys.exit(main())
