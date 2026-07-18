#!/usr/bin/env python3
"""Compare the declared trust boundary with the facts the Lean tree actually exhibits.

The tool keeps two kinds of statement strictly apart.  A *declaration* is written by a reviewer in
`lean/trust/`: which areas exist, which gates a paper leans on, which axioms a terminal is allowed
to collect, which trees are generated data.  A *fact* is extracted from Lean or from tracked bytes:
the resolved module closure, the axioms a declaration really collects, the files that really exist.
Every check in this file is a comparison between the two.  Nothing here promotes a declaration into
evidence, and nothing rewrites a declaration to match what was observed.

That separation is why `audit`, `graph`, and `check` never modify the worktree, why a missing facts
artifact is a failure rather than a silent pass, and why the generated Markdown regions display the
declared and observed columns side by side instead of collapsing them.

    lean/scripts/lean-trust-spine.py audit
    lean/scripts/lean-trust-spine.py graph --out /home/<dir>/graph.json
    lean/scripts/lean-trust-spine.py render --format mermaid --view gate-closure
    lean/scripts/lean-trust-spine.py check

Lean extraction is a separate explicit command and runs only through the repository's guarded build
discipline; no mode here starts an uncoordinated Lake build.
"""

from __future__ import annotations

import argparse
import fnmatch
import hashlib
import json
import re
import subprocess
import sys
import tomllib
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Iterable

LEAN_ROOT_DEFAULT = Path(__file__).resolve().parents[1]
TRUST_DIR_NAME = "trust"
PORTFOLIO_FILE = "portfolio.toml"

REGISTRY_SCHEMA_VERSION = 1
FACTS_SCHEMA_VERSION = 1
GRAPH_SCHEMA_VERSION = 1

EXIT_OK = 0
EXIT_FINDINGS = 1
EXIT_REFUSED = 2

# Lean allows imports only in the header, so the scanner stops at the first line that is not blank,
# a comment, or an import.  A regex over the whole file would also match the word inside a string
# literal or a docstring, and the data trees contain plenty of both.
IMPORT_RE = re.compile(r"^import\s+([A-Za-z0-9_.]+)")
HEADER_SKIP_RE = re.compile(r"^\s*(--.*)?$")
# A corroborating signal only.  The Lean exporter is the authority on what is an axiom; this catches
# the case where an axiom exists in source but no facts artifact accounts for it, which is exactly
# the state a stale or missing extraction leaves behind.
AXIOM_SOURCE_RE = re.compile(r"^(?:private\s+|protected\s+)?axiom\s+([A-Za-z0-9_'À-￿.]+)")
# A namespace is not the module path: `RelativeConicArcs/Q11DyeAxioms.lean` declares into
# `RelativeConicArcs.ClebschDye`.  Deriving a qualified name from the filename would invent a
# declaration that does not exist, so the scanner follows the namespace stack instead.
NAMESPACE_RE = re.compile(r"^namespace\s+([A-Za-z0-9_'.]+)")
END_RE = re.compile(r"^end\s+([A-Za-z0-9_'.]+)")

MARKER_BEGIN_RE = re.compile(
    r"^<!--\s*trust-spine:begin\s+area=(\S+)\s+section=(\S+)\s+version=(\d+)\s*-->\s*$"
)
MARKER_END_RE = re.compile(r"^<!--\s*trust-spine:end\s+area=(\S+)\s+section=(\S+)\s*-->\s*$")

SEVERITY_RANK = {"error": 0, "warn": 1, "info": 2}

MEMBER_ROLES = ("leaf", "aggregate", "index", "schema", "handwritten")
PROVENANCE_STATES = ("legacy-unverified", "strict")
ENTRY_MODES = ("hypothesis", "axiom", "consistency-check")


# --------------------------------------------------------------------------------------------
# findings


@dataclass(frozen=True)
class Finding:
    """One divergence between what is declared and what is observed."""

    code: str
    subject: str
    detail: str
    severity: str = "error"

    @property
    def sort_key(self) -> tuple[int, str, str]:
        return (SEVERITY_RANK[self.severity], self.code, self.subject)

    def as_json(self) -> dict[str, str]:
        return {
            "code": self.code,
            "detail": self.detail,
            "severity": self.severity,
            "subject": self.subject,
        }


class Refused(Exception):
    """The tool cannot run at all: bad registry, unreadable tree, malformed schema."""


# --------------------------------------------------------------------------------------------
# registry (declared intent)


@dataclass(frozen=True)
class MemberRule:
    glob: str
    role: str


@dataclass(frozen=True)
class DataTree:
    path: str
    rules: tuple[MemberRule, ...]
    provenance: str
    reason: str
    generator: str | None = None
    generator_sha256: str | None = None
    inputs: tuple[tuple[str, str], ...] = ()
    payload: str = "whole-file"
    expected_terminals: tuple[str, ...] = ()

    def role_for(self, filename: str) -> str | None:
        for rule in self.rules:
            if fnmatch.fnmatchcase(filename, rule.glob):
                return rule.role
        return None


@dataclass(frozen=True)
class Terminal:
    name: str
    gates: tuple[str, ...]
    expected_axioms: tuple[str, ...]


@dataclass(frozen=True)
class Gate:
    module: str
    terminals: tuple[str, ...]
    covers: tuple[str, ...]
    coverage_rule: str


@dataclass(frozen=True)
class ExternalInput:
    name: str
    entry_mode: str
    entry_declarations: tuple[str, ...]
    anchor: str


@dataclass(frozen=True)
class Area:
    name: str
    spine_path: str
    manifest: str
    owns: tuple[str, ...]
    gates: tuple[Gate, ...]
    terminals: tuple[Terminal, ...]
    data_trees: tuple[DataTree, ...]
    permitted_axioms: tuple[str, ...]
    external_inputs: tuple[ExternalInput, ...]
    inventory_units: tuple[Gate, ...]
    unreached: tuple[tuple[tuple[str, ...], str], ...]  # (module patterns, reason)

    @property
    def extraction_units(self) -> tuple[Gate, ...]:
        """Gates plus inventory units.

        The portfolio inventory has to see modules that no gate imports, and the only honest way to
        learn a module's axioms is to elaborate it.  Rather than inventing a second mechanism, an
        area declares extra import-only modules that cover its non-gate residual; they extract
        exactly like gates but export no terminals.
        """
        return self.gates + self.inventory_units


@dataclass(frozen=True)
class UnauditedLibrary:
    library: str
    reason: str


@dataclass(frozen=True)
class OutsideGates:
    modules: tuple[str, ...]
    reason: str


@dataclass(frozen=True)
class Registry:
    libraries: tuple[str, ...]
    non_source_dirs: tuple[str, ...]
    areas: tuple[Area, ...]
    unaudited_libraries: tuple[UnauditedLibrary, ...]
    outside_gates: tuple[OutsideGates, ...]
    shared: dict[str, tuple[str, ...]]
    generated_docs: tuple[tuple[str, str, str], ...]  # (path, area, section)


def _require(table: dict[str, Any], key: str, where: str) -> Any:
    if key not in table:
        raise Refused(f"{where}: missing required key {key!r}")
    return table[key]


def _str_tuple(value: Any, where: str) -> tuple[str, ...]:
    if not isinstance(value, list) or any(not isinstance(v, str) for v in value):
        raise Refused(f"{where}: expected a list of strings")
    return tuple(value)


def load_registry(trust_dir: Path) -> Registry:
    portfolio_path = trust_dir / PORTFOLIO_FILE
    if not portfolio_path.is_file():
        raise Refused(f"no portfolio registry at {portfolio_path}")
    with portfolio_path.open("rb") as handle:
        doc = tomllib.load(handle)

    version = _require(doc, "schema_version", PORTFOLIO_FILE)
    if version != REGISTRY_SCHEMA_VERSION:
        raise Refused(
            f"{PORTFOLIO_FILE}: schema_version {version} but this tool implements "
            f"{REGISTRY_SCHEMA_VERSION}"
        )

    portfolio = _require(doc, "portfolio", PORTFOLIO_FILE)
    libraries = _str_tuple(_require(portfolio, "libraries", "[portfolio]"), "[portfolio].libraries")
    non_source = _str_tuple(
        portfolio.get("non_source_dirs", []), "[portfolio].non_source_dirs"
    )

    areas = tuple(
        load_area(trust_dir, entry) for entry in doc.get("area", [])
    )
    unaudited = tuple(
        UnauditedLibrary(
            library=_require(entry, "library", "[[unaudited_library]]"),
            reason=_require(entry, "reason", "[[unaudited_library]]"),
        )
        for entry in doc.get("unaudited_library", [])
    )
    outside = tuple(
        OutsideGates(
            modules=_str_tuple(
                _require(entry, "modules", "[[outside_gates]]"), "[[outside_gates]].modules"
            ),
            reason=_require(entry, "reason", "[[outside_gates]]"),
        )
        for entry in doc.get("outside_gates", [])
    )
    shared = {
        _require(entry, "module", "[[shared]]"): _str_tuple(
            _require(entry, "areas", "[[shared]]"), "[[shared]].areas"
        )
        for entry in doc.get("shared", [])
    }
    docs = tuple(
        (
            _require(entry, "path", "[[generated_doc]]"),
            _require(entry, "area", "[[generated_doc]]"),
            _require(entry, "section", "[[generated_doc]]"),
        )
        for entry in doc.get("generated_doc", [])
    )

    names = [area.name for area in areas]
    if len(set(names)) != len(names):
        raise Refused(f"{PORTFOLIO_FILE}: duplicate area name")
    return Registry(
        libraries=libraries,
        non_source_dirs=non_source,
        areas=areas,
        unaudited_libraries=unaudited,
        outside_gates=outside,
        shared=shared,
        generated_docs=docs,
    )


def load_area(trust_dir: Path, entry: dict[str, Any]) -> Area:
    name = _require(entry, "name", "[[area]]")
    spine_rel = _require(entry, "spine", "[[area]]")
    spine_path = trust_dir / spine_rel
    if not spine_path.is_file():
        raise Refused(f"area {name!r}: no spine at {spine_path}")
    with spine_path.open("rb") as handle:
        doc = tomllib.load(handle)

    where = spine_rel
    version = _require(doc, "schema_version", where)
    if version != REGISTRY_SCHEMA_VERSION:
        raise Refused(f"{where}: schema_version {version} != {REGISTRY_SCHEMA_VERSION}")
    if doc.get("area") != name:
        raise Refused(f"{where}: area is {doc.get('area')!r} but registry says {name!r}")

    gates = tuple(_load_gate(entry_, where) for entry_ in doc.get("gate", []))
    units = tuple(_load_gate(entry_, where) for entry_ in doc.get("inventory_unit", []))
    terminals = tuple(_load_terminal(entry_, where) for entry_ in doc.get("terminal", []))
    trees = tuple(_load_data_tree(entry_, where) for entry_ in doc.get("data_tree", []))
    inputs = tuple(_load_external_input(entry_, where) for entry_ in doc.get("external_input", []))

    gate_modules = {gate.module for gate in gates}
    for terminal in terminals:
        unknown = sorted(set(terminal.gates) - gate_modules)
        if unknown:
            raise Refused(f"{where}: terminal {terminal.name} names unknown gate(s) {unknown}")

    return Area(
        name=name,
        spine_path=spine_rel,
        manifest=_require(doc, "manifest", where),
        owns=_str_tuple(_require(doc, "owns", where), f"{where}.owns"),
        gates=gates,
        terminals=terminals,
        data_trees=trees,
        permitted_axioms=_str_tuple(doc.get("permitted_axioms", []), f"{where}.permitted_axioms"),
        external_inputs=inputs,
        inventory_units=units,
        unreached=tuple(
            (
                _str_tuple(_require(entry_, "modules", f"{where} [[unreached]]"), "modules"),
                _require(entry_, "reason", f"{where} [[unreached]]"),
                _unreached_severity(entry_, where),
            )
            for entry_ in doc.get("unreached", [])
        ),
    )


def _unreached_severity(entry: dict[str, Any], where: str) -> str:
    """A declared gap is not automatically a benign one.

    `info` says the gap is expected and harmless.  `warn` says it is known, accounted for, and
    still a defect someone owns — a manifest claiming coverage a gate does not provide, say.
    Collapsing both into silence is how a trust document drifts away from the tree.
    """
    severity = entry.get("severity", "info")
    if severity not in ("info", "warn"):
        raise Refused(f"{where} [[unreached]]: severity must be 'info' or 'warn'")
    return severity


def _load_gate(entry: dict[str, Any], where: str) -> Gate:
    rule = entry.get("coverage_rule", "declared")
    if rule not in ("declared", "closure"):
        raise Refused(f"{where}: gate coverage_rule must be 'declared' or 'closure'")
    return Gate(
        module=_require(entry, "module", f"{where} [[gate]]"),
        terminals=_str_tuple(entry.get("terminals", []), f"{where} [[gate]].terminals"),
        covers=_str_tuple(entry.get("covers", []), f"{where} [[gate]].covers"),
        coverage_rule=rule,
    )


def _load_terminal(entry: dict[str, Any], where: str) -> Terminal:
    return Terminal(
        name=_require(entry, "declaration", f"{where} [[terminal]]"),
        gates=_str_tuple(_require(entry, "gates", f"{where} [[terminal]]"), "gates"),
        expected_axioms=tuple(
            sorted(_str_tuple(_require(entry, "expected_axioms", f"{where} [[terminal]]"), "axioms"))
        ),
    )


def _load_data_tree(entry: dict[str, Any], where: str) -> DataTree:
    rules = []
    for rule in _require(entry, "members", f"{where} [[data_tree]]"):
        role = _require(rule, "role", f"{where} [[data_tree.members]]")
        if role not in MEMBER_ROLES:
            raise Refused(f"{where}: member role {role!r} not one of {MEMBER_ROLES}")
        rules.append(MemberRule(glob=_require(rule, "glob", f"{where} members"), role=role))

    provenance = _require(entry, "provenance", f"{where} [[data_tree]]")
    if provenance not in PROVENANCE_STATES:
        raise Refused(f"{where}: provenance {provenance!r} not one of {PROVENANCE_STATES}")
    if provenance == "strict" and not entry.get("generator_sha256"):
        raise Refused(f"{where}: strict provenance requires generator_sha256")

    inputs = tuple(
        (str(item["path"]), str(item["sha256"])) for item in entry.get("inputs", [])
    )
    return DataTree(
        path=_require(entry, "path", f"{where} [[data_tree]]"),
        rules=tuple(rules),
        provenance=provenance,
        reason=entry.get("reason", ""),
        generator=entry.get("generator"),
        generator_sha256=entry.get("generator_sha256"),
        inputs=tuple(sorted(inputs)),
        payload=entry.get("payload", "whole-file"),
        expected_terminals=tuple(sorted(entry.get("expected_terminals", []))),
    )


def _load_external_input(entry: dict[str, Any], where: str) -> ExternalInput:
    mode = _require(entry, "entry_mode", f"{where} [[external_input]]")
    if mode not in ENTRY_MODES:
        raise Refused(f"{where}: entry_mode {mode!r} not one of {ENTRY_MODES}")
    return ExternalInput(
        name=_require(entry, "name", f"{where} [[external_input]]"),
        entry_mode=mode,
        entry_declarations=_str_tuple(
            entry.get("entry_declarations", []), f"{where} entry_declarations"
        ),
        anchor=entry.get("anchor", ""),
    )


# --------------------------------------------------------------------------------------------
# source inventory (observed bytes)


@dataclass(frozen=True)
class SourceFile:
    relpath: str
    module: str
    sha256: str
    size: int
    imports: tuple[str, ...]
    source_axioms: tuple[str, ...]


@dataclass(frozen=True)
class SourceInventory:
    files: tuple[SourceFile, ...]
    untracked_lean: tuple[str, ...]
    lakefile_libraries: tuple[str, ...]

    def by_module(self) -> dict[str, SourceFile]:
        return {f.module: f for f in self.files}


def module_name(relpath: str) -> str:
    return relpath[: -len(".lean")].replace("/", ".")


def _git_tracked_lean(lean_root: Path) -> list[str]:
    proc = subprocess.run(
        ["git", "ls-files", "-z", "--", "*.lean"],
        cwd=lean_root,
        capture_output=True,
        text=True,
        check=False,
    )
    if proc.returncode != 0:
        raise Refused(f"git ls-files failed in {lean_root}: {proc.stderr.strip()[:200]}")
    return sorted(part for part in proc.stdout.split("\0") if part)


def _parse_header(text: str) -> tuple[tuple[str, ...], tuple[str, ...]]:
    """Return the import list and the namespace-qualified axioms this source declares.

    The namespace stack is followed literally: `namespace A.B` pushes, a matching `end A.B` pops, an
    anonymous `end` (closing a `section`) is ignored.  That is a heuristic, and it is only ever used
    as a corroborating signal — the Lean exporter remains the authority on what an axiom is.
    """
    imports: list[str] = []
    axioms: list[str] = []
    namespaces: list[str] = []
    in_header = True
    for line in text.splitlines():
        if in_header:
            match = IMPORT_RE.match(line)
            if match:
                imports.append(match.group(1))
                continue
            if HEADER_SKIP_RE.match(line):
                continue
            in_header = False
        opened = NAMESPACE_RE.match(line)
        if opened:
            namespaces.append(opened.group(1))
            continue
        closed = END_RE.match(line)
        if closed:
            if namespaces and namespaces[-1] == closed.group(1):
                namespaces.pop()
            continue
        axiom = AXIOM_SOURCE_RE.match(line)
        if axiom:
            prefix = ".".join(namespaces)
            axioms.append(f"{prefix}.{axiom.group(1)}" if prefix else axiom.group(1))
    return tuple(imports), tuple(sorted(set(axioms)))


def scan_sources(lean_root: Path, registry: Registry) -> SourceInventory:
    tracked = _git_tracked_lean(lean_root)
    tracked_set = set(tracked)
    files = []
    for relpath in tracked:
        path = lean_root / relpath
        try:
            data = path.read_bytes()
        except OSError as exc:
            raise Refused(f"cannot read tracked source {relpath}: {exc}") from exc
        imports, axioms = _parse_header(data.decode("utf-8", errors="replace"))
        files.append(
            SourceFile(
                relpath=relpath,
                module=module_name(relpath),
                sha256=hashlib.sha256(data).hexdigest(),
                size=len(data),
                imports=imports,
                source_axioms=axioms,
            )
        )

    skip = set(registry.non_source_dirs) | {".git", ".lake"}
    untracked = []
    for path in sorted(lean_root.rglob("*.lean")):
        rel = path.relative_to(lean_root)
        if rel.parts[0] in skip:
            continue
        if str(rel) not in tracked_set:
            untracked.append(str(rel))

    return SourceInventory(
        files=tuple(files),
        untracked_lean=tuple(untracked),
        lakefile_libraries=_lakefile_libraries(lean_root),
    )


def _lakefile_libraries(lean_root: Path) -> tuple[str, ...]:
    path = lean_root / "lakefile.toml"
    if not path.is_file():
        raise Refused(f"no lakefile.toml at {path}")
    with path.open("rb") as handle:
        doc = tomllib.load(handle)
    names = [entry.get("name") for entry in doc.get("lean_lib", [])]
    if any(not isinstance(name, str) for name in names):
        raise Refused("lakefile.toml: a lean_lib entry has no string name")
    return tuple(sorted(names))


# --------------------------------------------------------------------------------------------
# classification


@dataclass(frozen=True)
class Classification:
    module: str
    relpath: str
    kind: str  # area-owned | shared | generated-data | outside-gates | unaudited-library
    #            | outside-libraries | unclassified
    areas: tuple[str, ...] = ()
    data_tree: str | None = None
    member_role: str | None = None
    reason: str = ""


def _matches(module: str, pattern: str) -> bool:
    """Match a module against one classification pattern.

    Three forms, and deliberately no general glob — the pattern set *is* the classification
    boundary, so a reviewer has to be able to read it and know exactly what it captures:

        Foo         exactly the module Foo
        Foo.**      Foo and every module under it
        Foo**       every module whose name starts with Foo, for naming families like
                    `Q11A5PointOrbitsRowsG07` that share a stem but no namespace
    """
    if pattern.endswith(".**"):
        stem = pattern[:-3]
        return module == stem or module.startswith(stem + ".")
    if pattern.endswith("**"):
        return module.startswith(pattern[:-2])
    return module == pattern


def classify(inventory: SourceInventory, registry: Registry) -> dict[str, Classification]:
    tree_index: list[tuple[str, str, DataTree]] = []
    for area in registry.areas:
        for tree in area.data_trees:
            tree_index.append((area.name, tree.path, tree))

    unaudited = {entry.library: entry.reason for entry in registry.unaudited_libraries}
    result: dict[str, Classification] = {}

    for source in inventory.files:
        library = source.relpath.split("/")[0]
        library = library[: -len(".lean")] if library.endswith(".lean") else library

        # Two different defects wear the same disguise here, and they need different fixes.  A
        # library the lakefile builds but the registry never classified is unclassified source
        # inside the build.  A directory neither one knows about is not built by any target at
        # all, so no gate could ever reach it however the registry changes.
        if library not in registry.libraries:
            built = library in inventory.lakefile_libraries
            result[source.module] = Classification(
                module=source.module,
                relpath=source.relpath,
                kind="unclassified" if built else "outside-libraries",
                reason=(
                    f"lakefile.toml builds library {library!r} but the portfolio registry does "
                    "not classify it"
                    if built
                    else f"{library!r} is not a declared library root"
                ),
            )
            continue

        tree_hit = next(
            (
                (area_name, tree)
                for area_name, prefix, tree in tree_index
                if source.relpath.startswith(prefix + "/")
            ),
            None,
        )
        if tree_hit is not None:
            area_name, tree = tree_hit
            filename = source.relpath.rsplit("/", 1)[-1]
            result[source.module] = Classification(
                module=source.module,
                relpath=source.relpath,
                kind="generated-data",
                areas=(area_name,),
                data_tree=tree.path,
                member_role=tree.role_for(filename),
            )
            continue

        owners = tuple(
            sorted(
                area.name
                for area in registry.areas
                if any(_matches(source.module, pattern) for pattern in area.owns)
            )
        )
        if len(owners) > 1:
            declared = registry.shared.get(source.module)
            kind = "shared" if declared and tuple(sorted(declared)) == owners else "unclassified"
            reason = "" if kind == "shared" else f"claimed by {list(owners)} without a shared entry"
            result[source.module] = Classification(
                module=source.module,
                relpath=source.relpath,
                kind=kind,
                areas=owners,
                reason=reason,
            )
            continue
        if owners:
            result[source.module] = Classification(
                module=source.module,
                relpath=source.relpath,
                kind="area-owned",
                areas=owners,
            )
            continue

        outside = next(
            (
                entry
                for entry in registry.outside_gates
                if any(_matches(source.module, pattern) for pattern in entry.modules)
            ),
            None,
        )
        if outside is not None:
            result[source.module] = Classification(
                module=source.module,
                relpath=source.relpath,
                kind="outside-gates",
                reason=outside.reason,
            )
            continue

        if library in unaudited:
            result[source.module] = Classification(
                module=source.module,
                relpath=source.relpath,
                kind="unaudited-library",
                reason=unaudited[library],
            )
            continue

        result[source.module] = Classification(
            module=source.module,
            relpath=source.relpath,
            kind="unclassified",
            reason="no area owns this module and it has no declared exclusion",
        )
    return result


# --------------------------------------------------------------------------------------------
# extracted Lean facts (observed environment)


@dataclass(frozen=True)
class UnitFacts:
    unit: str
    closure: tuple[str, ...]
    project_declarations: tuple[str, ...]
    project_axioms: tuple[str, ...]
    terminal_axioms: dict[str, tuple[str, ...]]
    declaration_module: dict[str, str]
    uses: dict[str, tuple[str, ...]]
    opaque: tuple[str, ...]
    lean_version: str
    mathlib_rev: str
    exporter_sha256: str


def load_facts(facts_dir: Path) -> dict[str, UnitFacts]:
    """Read every tracked facts artifact.

    A unit with no artifact is simply absent here; the caller turns that into a finding.  Silently
    treating an absent extraction as a pass is the failure mode this whole tool exists to prevent.
    """
    if not facts_dir.is_dir():
        return {}
    facts: dict[str, UnitFacts] = {}
    for path in sorted(facts_dir.glob("*.json")):
        with path.open("rb") as handle:
            doc = json.load(handle)
        version = doc.get("schema_version")
        if version != FACTS_SCHEMA_VERSION:
            raise Refused(
                f"{path.name}: facts schema_version {version} != {FACTS_SCHEMA_VERSION}"
            )
        unit = doc["unit"]
        facts[unit] = UnitFacts(
            unit=unit,
            closure=tuple(doc.get("closure", [])),
            project_declarations=tuple(doc.get("project_declarations", [])),
            project_axioms=tuple(doc.get("project_axioms", [])),
            terminal_axioms={k: tuple(v) for k, v in doc.get("terminal_axioms", {}).items()},
            declaration_module=dict(doc.get("declaration_module", {})),
            uses={k: tuple(v) for k, v in doc.get("uses", {}).items()},
            opaque=tuple(doc.get("opaque", [])),
            lean_version=doc.get("lean_version", ""),
            mathlib_rev=doc.get("mathlib_rev", ""),
            exporter_sha256=doc.get("exporter_sha256", ""),
        )
    return facts


# --------------------------------------------------------------------------------------------
# checks


def check_all(
    lean_root: Path,
    registry: Registry,
    inventory: SourceInventory,
    classes: dict[str, Classification],
    facts: dict[str, UnitFacts],
) -> list[Finding]:
    findings: list[Finding] = []
    findings += check_libraries(registry, inventory)
    findings += check_classification(classes)
    findings += check_data_trees(lean_root, registry, inventory, classes)
    findings += check_extraction_units(registry, facts)
    findings += check_unit_reachability(registry, inventory, classes)
    findings += check_terminals(registry, facts)
    findings += check_project_axioms(registry, inventory, classes, facts)
    findings += check_external_inputs(registry, facts)
    findings += check_generated_docs(lean_root, registry)
    return sorted(findings, key=lambda f: f.sort_key)


def check_libraries(registry: Registry, inventory: SourceInventory) -> list[Finding]:
    declared = set(registry.libraries)
    actual = set(inventory.lakefile_libraries)
    findings = []
    for name in sorted(actual - declared):
        findings.append(
            Finding(
                "lakefile-drift",
                name,
                "lakefile.toml declares this lean_lib but the portfolio registry does not list it",
            )
        )
    for name in sorted(declared - actual):
        findings.append(
            Finding(
                "lakefile-drift",
                name,
                "portfolio registry lists this library but lakefile.toml has no such lean_lib",
            )
        )
    return findings


def check_classification(classes: dict[str, Classification]) -> list[Finding]:
    findings = []
    for entry in sorted(classes.values(), key=lambda c: c.module):
        if entry.kind == "unclassified":
            findings.append(
                Finding("unclassified-module", entry.module, entry.reason or "unclassified")
            )
        elif entry.kind == "outside-libraries":
            findings.append(
                Finding(
                    "module-outside-libraries",
                    entry.module,
                    f"{entry.relpath}: {entry.reason}; no lake target builds it, so no gate can "
                    "ever cover it",
                )
            )
        elif entry.kind == "generated-data" and entry.member_role is None:
            findings.append(
                Finding(
                    "data-tree-member-unmatched",
                    entry.module,
                    f"{entry.relpath} is inside data tree {entry.data_tree} but matches no "
                    "declared member rule",
                )
            )
    return findings


def check_data_trees(
    lean_root: Path,
    registry: Registry,
    inventory: SourceInventory,
    classes: dict[str, Classification],
) -> list[Finding]:
    findings = []
    tracked_dirs = {source.relpath.rsplit("/", 1)[0] for source in inventory.files}
    for area in registry.areas:
        for tree in area.data_trees:
            if tree.path not in tracked_dirs:
                findings.append(
                    Finding(
                        "data-tree-missing",
                        tree.path,
                        f"area {area.name} declares this data tree but no tracked file lives there",
                    )
                )
                continue
            for rel in inventory.untracked_lean:
                if rel.startswith(tree.path + "/"):
                    findings.append(
                        Finding(
                            "data-tree-untracked-leaf",
                            rel,
                            f"untracked file inside declared data tree {tree.path}; a release "
                            "check counts only tracked bytes",
                        )
                    )
            if tree.provenance == "legacy-unverified":
                findings.append(
                    Finding(
                        "data-tree-legacy-unverified",
                        tree.path,
                        tree.reason
                        or "no provenance header; identity hashes are not a regeneration claim",
                        severity="info",
                    )
                )
            if tree.generator:
                gen = lean_root.parent / tree.generator
                if not gen.is_file():
                    findings.append(
                        Finding(
                            "data-tree-generator-missing",
                            tree.path,
                            f"declared generator {tree.generator} is not a file",
                        )
                    )
                elif tree.generator_sha256:
                    actual = hashlib.sha256(gen.read_bytes()).hexdigest()
                    if actual != tree.generator_sha256:
                        findings.append(
                            Finding(
                                "data-tree-generator-digest",
                                tree.path,
                                f"{tree.generator}: declared {tree.generator_sha256[:16]}… but "
                                f"observed {actual[:16]}…",
                            )
                        )
    return findings


def check_extraction_units(registry: Registry, facts: dict[str, UnitFacts]) -> list[Finding]:
    findings = []
    for area in registry.areas:
        for unit in area.extraction_units:
            if unit.module not in facts:
                findings.append(
                    Finding(
                        "facts-missing",
                        unit.module,
                        f"area {area.name} declares this extraction unit but no facts artifact "
                        "exists; every axiom and terminal claim below it is unverified",
                    )
                )
    for unit in sorted(set(facts) - {u.module for a in registry.areas for u in a.extraction_units}):
        findings.append(
            Finding(
                "facts-undeclared",
                unit,
                "a facts artifact exists for a unit no area declares",
            )
        )
    return findings


def source_closure(inventory: SourceInventory, roots: Iterable[str]) -> set[str]:
    """Transitive import closure over the *source* graph.

    This is not the trust-authoritative closure — Lean's resolved closure is, and it comes from the
    exporter.  It is used for one thing: deciding which modules no declared extraction unit would
    ever reach, so the residual can be given its own unit before anything is claimed about it.
    """
    graph = {source.module: source.imports for source in inventory.files}
    seen: set[str] = set()
    stack = [root for root in roots if root in graph]
    while stack:
        module = stack.pop()
        if module in seen:
            continue
        seen.add(module)
        stack.extend(imported for imported in graph.get(module, ()) if imported not in seen)
    return seen


def check_unit_reachability(
    registry: Registry,
    inventory: SourceInventory,
    classes: dict[str, Classification],
) -> list[Finding]:
    """Report owned modules no extraction unit would reach, grouped by the tree they live in.

    Grouping is not cosmetic.  An in-flight proof effort routinely leaves thousands of generated
    rows that no gate imports yet, and emitting one finding per module buries every other result.
    A declared exclusion downgrades the group to `info` so it stays visible in the unaudited table
    without masking a genuinely new orphan.
    """
    findings = []
    for area in registry.areas:
        roots = [unit.module for unit in area.extraction_units]
        reached = source_closure(inventory, roots)
        undeclared: dict[str, list[str]] = {}
        declared: dict[int, list[str]] = {}
        for entry in sorted(classes.values(), key=lambda c: c.module):
            if area.name not in entry.areas:
                continue
            if entry.kind not in ("area-owned", "generated-data", "shared"):
                continue
            if entry.module in reached:
                continue
            rule_index = next(
                (
                    index
                    for index, rule in enumerate(area.unreached)
                    if any(_matches(entry.module, pattern) for pattern in rule[0])
                ),
                None,
            )
            if rule_index is None:
                undeclared.setdefault(entry.data_tree or entry.module, []).append(entry.module)
            else:
                declared.setdefault(rule_index, []).append(entry.module)

        for index, modules in sorted(declared.items()):
            patterns, reason, severity = area.unreached[index]
            findings.append(
                Finding(
                    "module-unreached-declared",
                    f"{area.name}: {patterns[0]}",
                    f"{len(modules)} module(s): {reason}",
                    severity=severity,
                )
            )
        for group, modules in sorted(undeclared.items()):
            where = f"{len(modules)} module(s)" if len(modules) > 1 else modules[0]
            findings.append(
                Finding(
                    "module-unreached-by-units",
                    group,
                    f"area {area.name} owns {where} that no declared extraction unit imports, so "
                    "no gate and no inventory pass would ever see the declarations",
                )
            )
    return findings


def check_terminals(registry: Registry, facts: dict[str, UnitFacts]) -> list[Finding]:
    findings = []
    for area in registry.areas:
        gate_terminals = {t for gate in area.gates for t in gate.terminals}
        for terminal in area.terminals:
            if not terminal.gates:
                findings.append(
                    Finding(
                        "terminal-without-gate",
                        terminal.name,
                        f"area {area.name} declares this terminal but no gate exports it",
                    )
                )
            for gate_module in terminal.gates:
                gate = next((g for g in area.gates if g.module == gate_module), None)
                if gate is not None and terminal.name not in gate.terminals:
                    findings.append(
                        Finding(
                            "gate-terminal-mismatch",
                            terminal.name,
                            f"terminal claims membership in {gate_module} but that gate does not "
                            "list it",
                        )
                    )
                unit_facts = facts.get(gate_module)
                if unit_facts is None:
                    continue
                observed = unit_facts.terminal_axioms.get(terminal.name)
                if observed is None:
                    findings.append(
                        Finding(
                            "terminal-absent-from-gate",
                            terminal.name,
                            f"{gate_module} facts contain no axiom set for this declaration",
                        )
                    )
                    continue
                if tuple(sorted(observed)) != terminal.expected_axioms:
                    findings.append(
                        Finding(
                            "terminal-axiom-mismatch",
                            terminal.name,
                            f"{gate_module}: declared {list(terminal.expected_axioms)} but Lean "
                            f"reports {sorted(observed)}",
                        )
                    )
        for name in sorted(gate_terminals - {t.name for t in area.terminals}):
            findings.append(
                Finding(
                    "gate-terminal-undeclared",
                    name,
                    f"area {area.name} lists this terminal on a gate but declares no expected "
                    "axiom set for it",
                )
            )
    return findings


def check_project_axioms(
    registry: Registry,
    inventory: SourceInventory,
    classes: dict[str, Classification],
    facts: dict[str, UnitFacts],
) -> list[Finding]:
    """Every project-local axiom must be declared, wherever it lives.

    The source signal and the Lean facts are both consulted on purpose.  Lean is the authority on
    what a declaration *is*, but it only sees modules some extraction unit imports; the source scan
    is what notices an axiom sitting in a module no unit reaches.
    """
    findings = []
    permitted = {
        name: area.name for area in registry.areas for name in area.permitted_axioms
    }
    observed_by_lean: set[str] = set()
    for unit_facts in facts.values():
        observed_by_lean.update(unit_facts.project_axioms)

    for source in inventory.files:
        entry = classes[source.module]
        for axiom in source.source_axioms:
            if axiom not in permitted:
                findings.append(
                    Finding(
                        "project-axiom-undeclared",
                        axiom,
                        f"{source.relpath} declares an axiom that no area's permitted_axioms lists",
                    )
                )
            if entry.kind in ("outside-gates", "outside-libraries", "unaudited-library"):
                findings.append(
                    Finding(
                        "axiom-outside-gates",
                        axiom,
                        f"{source.relpath} is classified {entry.kind} and declares an axiom, so no "
                        "gate build kernel-checks anything that depends on it",
                        severity="warn",
                    )
                )

    for axiom in sorted(observed_by_lean):
        if axiom not in permitted:
            findings.append(
                Finding(
                    "project-axiom-undeclared",
                    axiom,
                    "Lean reports this project-local axiom inside an extraction unit but no area "
                    "declares it",
                )
            )
    return findings


def check_external_inputs(registry: Registry, facts: dict[str, UnitFacts]) -> list[Finding]:
    findings = []
    known: set[str] = set()
    for unit_facts in facts.values():
        known.update(unit_facts.project_declarations)
    for area in registry.areas:
        for entry in area.external_inputs:
            if not entry.entry_declarations:
                findings.append(
                    Finding(
                        "external-input-unanchored",
                        entry.name,
                        f"area {area.name} names this input but points at no declaration",
                    )
                )
            if not facts:
                continue
            for decl in entry.entry_declarations:
                if decl not in known:
                    findings.append(
                        Finding(
                            "external-input-entry-missing",
                            entry.name,
                            f"declared entry point {decl} appears in no extraction unit",
                        )
                    )
    return findings


# --------------------------------------------------------------------------------------------
# generated Markdown regions


@dataclass(frozen=True)
class Region:
    area: str
    section: str
    version: int
    start: int  # index of the begin marker line
    end: int  # index of the end marker line


def find_regions(text: str) -> tuple[list[Region], list[Finding]]:
    lines = text.splitlines()
    regions: list[Region] = []
    findings: list[Finding] = []
    open_marker: tuple[str, str, int, int] | None = None
    for index, line in enumerate(lines):
        begin = MARKER_BEGIN_RE.match(line)
        end = MARKER_END_RE.match(line)
        if begin:
            if open_marker is not None:
                findings.append(
                    Finding(
                        "region-nested",
                        f"{begin.group(1)}/{begin.group(2)}",
                        f"line {index + 1}: a region opens while {open_marker[0]}/{open_marker[1]} "
                        "is still open",
                    )
                )
                continue
            open_marker = (begin.group(1), begin.group(2), int(begin.group(3)), index)
        elif end:
            if open_marker is None:
                findings.append(
                    Finding(
                        "region-unopened",
                        f"{end.group(1)}/{end.group(2)}",
                        f"line {index + 1}: end marker with no matching begin",
                    )
                )
                continue
            area, section, version, start = open_marker
            if (area, section) != (end.group(1), end.group(2)):
                findings.append(
                    Finding(
                        "region-mismatched",
                        f"{area}/{section}",
                        f"line {index + 1}: closed by {end.group(1)}/{end.group(2)}",
                    )
                )
            regions.append(Region(area, section, version, start, index))
            open_marker = None
    if open_marker is not None:
        findings.append(
            Finding(
                "region-unclosed",
                f"{open_marker[0]}/{open_marker[1]}",
                f"line {open_marker[3] + 1}: region never closed",
            )
        )
    seen: set[tuple[str, str]] = set()
    for region in regions:
        key = (region.area, region.section)
        if key in seen:
            findings.append(
                Finding("region-duplicated", f"{key[0]}/{key[1]}", "declared more than once")
            )
        seen.add(key)
    return regions, findings


def check_generated_docs(lean_root: Path, registry: Registry) -> list[Finding]:
    findings: list[Finding] = []
    by_path: dict[str, set[tuple[str, str]]] = {}
    for path, area, section in registry.generated_docs:
        by_path.setdefault(path, set()).add((area, section))
    for path, declared in sorted(by_path.items()):
        target = lean_root / path
        if not target.is_file():
            findings.append(Finding("region-file-missing", path, "declared generated doc not found"))
            continue
        regions, region_findings = find_regions(target.read_text(encoding="utf-8"))
        findings += [
            Finding(f.code, f"{path}:{f.subject}", f.detail, f.severity) for f in region_findings
        ]
        present = {(r.area, r.section) for r in regions}
        for area, section in sorted(declared - present):
            findings.append(
                Finding("region-missing", f"{path}:{area}/{section}", "declared but not present")
            )
        for area, section in sorted(present - declared):
            findings.append(
                Finding("region-undeclared", f"{path}:{area}/{section}", "present but not declared")
            )
    return findings


def render_region(
    section: str,
    area: Area,
    registry: Registry,
    inventory: SourceInventory,
    classes: dict[str, Classification],
    facts: dict[str, UnitFacts],
) -> str:
    if section == "gates":
        rows = [("Gate", "Terminals declared", "Facts")]
        for gate in area.gates:
            state = "extracted" if gate.module in facts else "**not extracted**"
            rows.append((f"`{gate.module}`", str(len(gate.terminals)), state))
        return markdown_table(rows)
    if section == "terminal-axioms":
        rows = [("Terminal", "Declared axioms", "Observed")]
        for terminal in area.terminals:
            observed = "—"
            for gate in terminal.gates:
                unit = facts.get(gate)
                if unit and terminal.name in unit.terminal_axioms:
                    observed = ", ".join(f"`{a}`" for a in sorted(unit.terminal_axioms[terminal.name]))
                    break
            rows.append(
                (
                    f"`{terminal.name}`",
                    ", ".join(f"`{a}`" for a in terminal.expected_axioms) or "none",
                    observed,
                )
            )
        return markdown_table(rows)
    if section == "data-trees":
        rows = [("Tree", "Members", "Provenance", "Generator")]
        for tree in area.data_trees:
            members = sum(
                1 for c in classes.values() if c.data_tree == tree.path
            )
            rows.append(
                (
                    f"`{tree.path}`",
                    str(members),
                    tree.provenance,
                    f"`{tree.generator}`" if tree.generator else "—",
                )
            )
        return markdown_table(rows)
    if section == "portfolio-axioms":
        rows = [("Axiom", "Module", "Classification")]
        for source in inventory.files:
            for axiom in source.source_axioms:
                entry = classes[source.module]
                rows.append((f"`{axiom}`", f"`{source.module}`", entry.kind))
        return markdown_table(rows)
    if section == "unaudited-modules":
        rows = [("Scope", "Modules", "State", "Reason")]
        for entry in sorted(classes.values(), key=lambda c: c.module):
            if entry.kind in ("outside-gates", "outside-libraries", "unclassified"):
                rows.append((f"`{entry.module}`", "1", entry.kind, entry.reason))

        # Owned modules no extraction unit reaches.  These are the rows that matter most: a module
        # can be perfectly well classified and still sit outside every gate that would check it.
        reached = source_closure(inventory, [u.module for u in area.extraction_units])
        unreached = sorted(
            entry.module
            for entry in classes.values()
            if area.name in entry.areas
            and entry.kind in ("area-owned", "generated-data", "shared")
            and entry.module not in reached
        )
        grouped: dict[int | None, list[str]] = {}
        for module in unreached:
            index = next(
                (
                    i
                    for i, rule in enumerate(area.unreached)
                    if any(_matches(module, pattern) for pattern in rule[0])
                ),
                None,
            )
            grouped.setdefault(index, []).append(module)
        for index, modules in sorted(grouped.items(), key=lambda kv: (kv[0] is None, kv[0] or 0)):
            if index is None:
                for module in modules:
                    rows.append(
                        (f"`{module}`", "1", "unreached, undeclared", "no declared exclusion")
                    )
            else:
                patterns, reason, severity = area.unreached[index]
                rows.append(
                    (
                        f"`{patterns[0]}`",
                        str(len(modules)),
                        f"unreached, declared ({severity})",
                        reason.replace("\n", " ").strip(),
                    )
                )
        return markdown_table(rows)
    raise Refused(f"unknown generated section {section!r}")


def markdown_table(rows: list[tuple[str, ...]]) -> str:
    if len(rows) == 1:
        return f"_No rows._\n"
    widths = [max(len(row[i]) for row in rows) for i in range(len(rows[0]))]
    out = ["| " + " | ".join(cell.ljust(widths[i]) for i, cell in enumerate(rows[0])) + " |"]
    out.append("|" + "|".join("-" * (w + 2) for w in widths) + "|")
    for row in rows[1:]:
        out.append("| " + " | ".join(cell.ljust(widths[i]) for i, cell in enumerate(row)) + " |")
    return "\n".join(out) + "\n"


def rewrite_regions(text: str, rendered: dict[tuple[str, str], str]) -> str:
    lines = text.splitlines()
    regions, findings = find_regions(text)
    if findings:
        raise Refused(
            "refusing to rewrite a file with malformed regions: "
            + "; ".join(f"{f.code} {f.subject}" for f in findings)
        )
    out = list(lines)
    for region in sorted(regions, key=lambda r: r.start, reverse=True):
        body = rendered.get((region.area, region.section))
        if body is None:
            continue
        out[region.start + 1 : region.end] = body.rstrip("\n").splitlines()
    return "\n".join(out) + "\n"


# --------------------------------------------------------------------------------------------
# canonical graph


def build_graph(
    registry: Registry,
    inventory: SourceInventory,
    classes: dict[str, Classification],
    facts: dict[str, UnitFacts],
) -> dict[str, Any]:
    nodes: list[dict[str, Any]] = []
    edges: list[dict[str, Any]] = []

    for area in registry.areas:
        nodes.append({"id": f"area:{area.name}", "kind": "area", "label": area.name})
        for gate in area.gates:
            nodes.append({"id": f"gate:{gate.module}", "kind": "gate", "label": gate.module})
            edges.append(
                {"from": f"area:{area.name}", "kind": "has_gate", "to": f"gate:{gate.module}"}
            )
            for terminal in gate.terminals:
                edges.append(
                    {"from": f"gate:{gate.module}", "kind": "exports", "to": f"decl:{terminal}"}
                )
        for tree in area.data_trees:
            nodes.append({"id": f"tree:{tree.path}", "kind": "data_tree", "label": tree.path,
                          "provenance": tree.provenance})
            edges.append(
                {"from": f"area:{area.name}", "kind": "has_data_tree", "to": f"tree:{tree.path}"}
            )
        for entry in area.external_inputs:
            nodes.append(
                {
                    "id": f"external:{entry.name}",
                    "kind": "external_input",
                    "label": entry.name,
                    "entry_mode": entry.entry_mode,
                }
            )
            for decl in entry.entry_declarations:
                edges.append(
                    {"from": f"external:{entry.name}", "kind": "enters_at", "to": f"decl:{decl}"}
                )

    known_modules = {source.module for source in inventory.files}
    for source in inventory.files:
        entry = classes[source.module]
        # Topology only.  Per-file digests deliberately do not live here: they would make the graph
        # digest change on every edit anywhere in the tree, so a foreign lane touching one proof
        # would turn this lane's `check` red without any dependency actually moving.  Content
        # digests belong to the data-tree provenance layer, which can attribute a change to the
        # tree that owns it.
        node: dict[str, Any] = {
            "id": f"module:{source.module}",
            "kind": "module",
            "label": source.module,
            "classification": entry.kind,
        }
        if entry.data_tree:
            node["data_tree"] = entry.data_tree
            node["member_role"] = entry.member_role
            edges.append(
                {
                    "from": f"tree:{entry.data_tree}",
                    "kind": "has_member",
                    "to": f"module:{source.module}",
                }
            )
        nodes.append(node)
        for imported in source.imports:
            if imported in known_modules:
                edges.append(
                    {
                        "from": f"module:{source.module}",
                        "kind": "imports",
                        "to": f"module:{imported}",
                    }
                )

    for unit_facts in sorted(facts.values(), key=lambda f: f.unit):
        for decl, module in sorted(unit_facts.declaration_module.items()):
            nodes.append({"id": f"decl:{decl}", "kind": "declaration", "label": decl})
            edges.append(
                {"from": f"module:{module}", "kind": "declares", "to": f"decl:{decl}"}
            )
        for decl, used in sorted(unit_facts.uses.items()):
            for target in sorted(used):
                edges.append({"from": f"decl:{decl}", "kind": "uses", "to": f"decl:{target}"})
        for terminal, axioms in sorted(unit_facts.terminal_axioms.items()):
            for axiom in sorted(axioms):
                edges.append(
                    {
                        "from": f"decl:{terminal}",
                        "kind": "depends_on_axiom",
                        "to": f"axiom:{axiom}",
                    }
                )
        for boundary in sorted(unit_facts.opaque):
            nodes.append(
                {"id": f"opaque:{boundary}", "kind": "opaque_boundary", "label": boundary}
            )

    unique_nodes = {node["id"]: node for node in nodes}
    unique_edges = {
        (edge["from"], edge["kind"], edge["to"]): edge for edge in edges
    }
    return {
        "schema_version": GRAPH_SCHEMA_VERSION,
        "lean_facts": "present" if facts else "absent",
        "nodes": [unique_nodes[key] for key in sorted(unique_nodes)],
        "edges": [unique_edges[key] for key in sorted(unique_edges)],
    }


def canonical_json(obj: Any) -> str:
    return json.dumps(obj, indent=2, sort_keys=True, ensure_ascii=False) + "\n"


def graph_manifest(graph: dict[str, Any]) -> dict[str, Any]:
    """Compact tracked stand-in for the canonical graph.

    The full portfolio graph is ~12 MB and rewrites whenever any of the tree's `.lean` files
    changes, so tracking it would put a large churning blob in every diff for no reviewing benefit.
    The manifest pins exactly what a staleness check needs — the canonical bytes' digest plus the
    shape of what they contain — and the graph itself regenerates in seconds from a fixed command.
    A digest mismatch is caught identically either way.
    """
    text = canonical_json(graph)
    node_kinds: dict[str, int] = {}
    for node in graph["nodes"]:
        node_kinds[node["kind"]] = node_kinds.get(node["kind"], 0) + 1
    edge_kinds: dict[str, int] = {}
    for edge in graph["edges"]:
        edge_kinds[edge["kind"]] = edge_kinds.get(edge["kind"], 0) + 1
    return {
        "schema_version": GRAPH_SCHEMA_VERSION,
        "lean_facts": graph["lean_facts"],
        "canonical_bytes": len(text.encode("utf-8")),
        "canonical_sha256": hashlib.sha256(text.encode("utf-8")).hexdigest(),
        "node_kinds": node_kinds,
        "edge_kinds": edge_kinds,
        "replay": "lean/scripts/lean-trust-spine.py graph --out <path>",
    }


# --------------------------------------------------------------------------------------------
# renderers


VIEW_KINDS = {
    "gate-closure": {"gate", "module", "declaration", "axiom"},
    "proof-spine": {"declaration", "axiom", "gate", "opaque_boundary"},
    "data-provenance": {"data_tree", "module", "gate", "area"},
    "portfolio-axioms": {"axiom", "module", "area"},
}


def filter_graph(
    graph: dict[str, Any],
    view: str,
    area: str | None,
    collapse_trees: bool,
    max_nodes: int,
) -> dict[str, Any]:
    kinds = VIEW_KINDS.get(view)
    if kinds is None:
        raise Refused(f"unknown view {view!r}; choose from {sorted(VIEW_KINDS)}")
    nodes = [node for node in graph["nodes"] if node["kind"] in kinds]

    if collapse_trees:
        member_of = {
            node["id"]: f"tree:{node['data_tree']}"
            for node in graph["nodes"]
            if node.get("data_tree")
        }
        nodes = [node for node in nodes if node["id"] not in member_of]
        nodes += [node for node in graph["nodes"] if node["kind"] == "data_tree"]
    else:
        member_of = {}

    if area:
        keep = {node["id"] for node in nodes if area.lower() in node["label"].lower()}
        nodes = [node for node in nodes if node["id"] in keep]

    ids = {node["id"] for node in nodes}
    edges = []
    for edge in graph["edges"]:
        source = member_of.get(edge["from"], edge["from"])
        target = member_of.get(edge["to"], edge["to"])
        if source == target:
            continue
        if source in ids and target in ids:
            edges.append({"from": source, "kind": edge["kind"], "to": target})

    truncated = len(nodes) > max_nodes
    if truncated:
        nodes = sorted(nodes, key=lambda n: n["id"])[:max_nodes]
        ids = {node["id"] for node in nodes}
        edges = [e for e in edges if e["from"] in ids and e["to"] in ids]

    unique = {(e["from"], e["kind"], e["to"]): e for e in edges}
    return {
        "schema_version": graph["schema_version"],
        "lean_facts": graph["lean_facts"],
        "view": view,
        "collapsed_data_trees": collapse_trees,
        "truncated": truncated,
        "nodes": sorted(nodes, key=lambda n: n["id"]),
        "edges": [unique[key] for key in sorted(unique)],
    }


def _safe_id(node_id: str) -> str:
    return re.sub(r"[^A-Za-z0-9_]", "_", node_id)


def render_mermaid(view: dict[str, Any]) -> str:
    out = [f"%% trust-spine view={view['view']} lean_facts={view['lean_facts']}", "graph LR"]
    for node in view["nodes"]:
        label = node["label"].replace('"', "'")
        out.append(f'  {_safe_id(node["id"])}["{label}"]')
    for edge in view["edges"]:
        out.append(
            f'  {_safe_id(edge["from"])} -->|{edge["kind"]}| {_safe_id(edge["to"])}'
        )
    if view["truncated"]:
        out.append("  %% truncated: node budget reached; narrow the filters")
    return "\n".join(out) + "\n"


def render_dot(view: dict[str, Any]) -> str:
    out = [
        f"// trust-spine view={view['view']} lean_facts={view['lean_facts']}",
        "digraph trust {",
        "  rankdir=LR;",
    ]
    for node in view["nodes"]:
        label = node["label"].replace('"', "'")
        out.append(f'  {_safe_id(node["id"])} [label="{label}", shape=box];')
    for edge in view["edges"]:
        out.append(
            f'  {_safe_id(edge["from"])} -> {_safe_id(edge["to"])} [label="{edge["kind"]}"];'
        )
    if view["truncated"]:
        out.append("  // truncated: node budget reached; narrow the filters")
    out.append("}")
    return "\n".join(out) + "\n"


# --------------------------------------------------------------------------------------------
# CLI


@dataclass
class Context:
    lean_root: Path
    trust_dir: Path
    registry: Registry
    inventory: SourceInventory
    classes: dict[str, Classification]
    facts: dict[str, UnitFacts]


def build_context(lean_root: Path) -> Context:
    trust_dir = lean_root / TRUST_DIR_NAME
    registry = load_registry(trust_dir)
    inventory = scan_sources(lean_root, registry)
    classes = classify(inventory, registry)
    facts = load_facts(trust_dir / "facts")
    return Context(lean_root, trust_dir, registry, inventory, classes, facts)


def report(findings: Iterable[Finding], as_json: bool) -> int:
    findings = list(findings)
    if as_json:
        print(canonical_json({"findings": [f.as_json() for f in findings]}), end="")
    else:
        counts: dict[str, int] = {}
        for finding in findings:
            counts[finding.severity] = counts.get(finding.severity, 0) + 1
        for finding in findings:
            print(f"{finding.severity:5s} {finding.code:32s} {finding.subject}")
            print(f"      {finding.detail}")
        summary = ", ".join(f"{counts.get(sev, 0)} {sev}" for sev in ("error", "warn", "info"))
        print(f"\n{summary}")
    return EXIT_FINDINGS if any(f.severity == "error" for f in findings) else EXIT_OK


def cmd_audit(args: argparse.Namespace) -> int:
    ctx = build_context(args.lean_root)
    findings = check_all(ctx.lean_root, ctx.registry, ctx.inventory, ctx.classes, ctx.facts)
    if args.area:
        findings = [f for f in findings if args.area in f.subject or args.area in f.detail]
    return report(findings, args.json)


def cmd_graph(args: argparse.Namespace) -> int:
    ctx = build_context(args.lean_root)
    graph = build_graph(ctx.registry, ctx.inventory, ctx.classes, ctx.facts)
    text = canonical_json(graph)
    if args.out:
        Path(args.out).write_text(text, encoding="utf-8")
    else:
        sys.stdout.write(text)
    return EXIT_OK


def cmd_render(args: argparse.Namespace) -> int:
    if args.graph:
        graph = json.loads(Path(args.graph).read_text(encoding="utf-8"))
    else:
        ctx = build_context(args.lean_root)
        graph = build_graph(ctx.registry, ctx.inventory, ctx.classes, ctx.facts)
    view = filter_graph(graph, args.view, args.area, not args.expand_data_trees, args.max_nodes)
    text = render_mermaid(view) if args.format == "mermaid" else render_dot(view)
    if args.out:
        Path(args.out).write_text(text, encoding="utf-8")
    else:
        sys.stdout.write(text)
    return EXIT_OK


def _render_all_regions(ctx: Context) -> dict[str, dict[tuple[str, str], str]]:
    by_file: dict[str, dict[tuple[str, str], str]] = {}
    for path, area_name, section in ctx.registry.generated_docs:
        area = next((a for a in ctx.registry.areas if a.name == area_name), None)
        if area is None:
            raise Refused(f"generated doc {path} names unknown area {area_name!r}")
        body = render_region(section, area, ctx.registry, ctx.inventory, ctx.classes, ctx.facts)
        by_file.setdefault(path, {})[(area_name, section)] = body
    return by_file


def cmd_generate(args: argparse.Namespace) -> int:
    ctx = build_context(args.lean_root)
    rendered = _render_all_regions(ctx)
    changed = []
    for path, regions in sorted(rendered.items()):
        target = ctx.lean_root / path
        original = target.read_text(encoding="utf-8")
        updated = rewrite_regions(original, regions)
        if updated != original:
            target.write_text(updated, encoding="utf-8")
            changed.append(path)
    facts_dir = ctx.trust_dir / "facts"
    manifest_path = ctx.trust_dir / "graph-manifest.json"
    manifest_text = canonical_json(
        graph_manifest(build_graph(ctx.registry, ctx.inventory, ctx.classes, ctx.facts))
    )
    if not manifest_path.is_file() or manifest_path.read_text(encoding="utf-8") != manifest_text:
        manifest_path.write_text(manifest_text, encoding="utf-8")
        changed.append(str(manifest_path.relative_to(ctx.lean_root)))
    for path in changed:
        print(f"rewrote {path}")
    if not changed:
        print("no generated output changed")
    if not facts_dir.is_dir():
        print("note: no Lean facts artifacts; generated tables show declarations only")
    return EXIT_OK


def cmd_check(args: argparse.Namespace) -> int:
    """Read-only: regenerate everything in memory and compare canonical bytes with the tree."""
    ctx = build_context(args.lean_root)
    findings = check_all(ctx.lean_root, ctx.registry, ctx.inventory, ctx.classes, ctx.facts)

    rendered = _render_all_regions(ctx)
    for path, regions in sorted(rendered.items()):
        target = ctx.lean_root / path
        if not target.is_file():
            continue
        original = target.read_text(encoding="utf-8")
        try:
            updated = rewrite_regions(original, regions)
        except Refused as exc:
            findings.append(Finding("region-malformed", path, str(exc)))
            continue
        if updated != original:
            findings.append(
                Finding(
                    "generated-region-stale",
                    path,
                    "tracked bytes differ from a fresh regeneration; run generate",
                )
            )

    manifest_path = ctx.trust_dir / "graph-manifest.json"
    manifest_text = canonical_json(
        graph_manifest(build_graph(ctx.registry, ctx.inventory, ctx.classes, ctx.facts))
    )
    if not manifest_path.is_file():
        findings.append(
            Finding("graph-missing", manifest_path.name, "no tracked graph manifest")
        )
    elif manifest_path.read_text(encoding="utf-8") != manifest_text:
        findings.append(
            Finding(
                "graph-stale",
                manifest_path.name,
                "the graph rebuilt from source does not match the tracked manifest digest; the "
                "docs matching proves nothing on its own",
            )
        )
    return report(sorted(findings, key=lambda f: f.sort_key), args.json)


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--lean-root", type=Path, default=LEAN_ROOT_DEFAULT, dest="lean_root")
    sub = parser.add_subparsers(dest="mode", required=True)

    audit = sub.add_parser("audit", help="read-only comparison of declarations with facts")
    audit.add_argument("--area")
    audit.add_argument("--json", action="store_true")
    audit.set_defaults(func=cmd_audit)

    generate = sub.add_parser("generate", help="rewrite generated JSON and Markdown regions")
    generate.add_argument("--area")
    generate.set_defaults(func=cmd_generate)

    graph = sub.add_parser("graph", help="emit canonical dependency-graph JSON")
    graph.add_argument("--out")
    graph.set_defaults(func=cmd_graph)

    render = sub.add_parser("render", help="render one filtered view from graph JSON")
    render.add_argument("--format", choices=("mermaid", "dot"), default="mermaid")
    render.add_argument("--view", choices=sorted(VIEW_KINDS), default="gate-closure")
    render.add_argument("--graph", help="read this graph JSON instead of rebuilding")
    render.add_argument("--area")
    render.add_argument("--expand-data-trees", action="store_true")
    render.add_argument("--max-nodes", type=int, default=200)
    render.add_argument("--out")
    render.set_defaults(func=cmd_render)

    check = sub.add_parser("check", help="read-only full regeneration and byte comparison")
    check.add_argument("--area")
    check.add_argument("--json", action="store_true")
    check.set_defaults(func=cmd_check)

    args = parser.parse_args(argv)
    try:
        return args.func(args)
    except Refused as exc:
        print(f"refused: {exc}", file=sys.stderr)
        return EXIT_REFUSED


if __name__ == "__main__":
    sys.exit(main())
