#!/usr/bin/env python3
"""Materialize an immutable Lean trust unit onto an immutable canonical base.

The exporter takes an exact source commit of this repository, an exact commit
of the canonical `finitegeom` repository, and a tracked area configuration.  It
derives the unit's project-local module closure and exact terminal list from
the committed trust registry and generated fact, materializes a disposable
candidate repository on top of the canonical base tree and history, generates
every release surface mechanically, verifies byte identity and manifest
completeness, and prints a read-only forward delta.  The delta must lie inside the
planned file set: an unplanned changed path is refused, while a planned file the base
already carries byte for byte is reported as unchanged rather than treated as missing.

The exporter never commits, tags, pushes, fast-forwards, or edits either the
source repository or the canonical base.  A candidate is always a fresh
disposable directory; the caller decides separately whether its delta is
adopted.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import shutil
import subprocess
import sys
import tomllib
from dataclasses import dataclass
from pathlib import Path
from typing import Any

REPO_ROOT = Path(__file__).resolve().parents[2]
LEAN_ROOT = REPO_ROOT / "lean"
CANONICAL_BASE_DEFAULT = Path.home() / "src" / "lean" / "finitegeom"
SUFFIXED_CLONE_RE = re.compile(r"^finitegeom-.+$")
MEMORY_BACKED_FILESYSTEMS = {"tmpfs", "ramfs"}
EXIT_OK = 0
EXIT_REFUSED = 2

IMPORT_RE = re.compile(r"^import\s+([A-Za-z0-9_.']+)", re.MULTILINE)
TASK_ID_RE = re.compile(
    r"(?<![A-Za-z0-9])(?:C(?:[89]\d|[1-9]\d{2,})(?!\d)|c(?:[89]\d|[1-9]\d{2,})(?![0-9a-fA-F]))"
)
PRIVATE_PATTERNS: tuple[tuple[str, re.Pattern[str]], ...] = (
    ("task-identifier", TASK_ID_RE),
    ("local-path", re.compile(r"/home/[A-Za-z0-9_.-]+(?:/|\b)")),
    ("file-uri", re.compile(r"file://")),
    ("private-notes", re.compile(r"(?:^|[(`/\"'])(?:\.\./)*notes/")),
    ("workflow-vocabulary", re.compile(r"\b(?:handoff|lane|subagent|agent session)\b", re.IGNORECASE)),
    (
        "status-prose",
        re.compile(
            r"\b(?:TODO|FIXME|future work|for now|work in progress|next step|"
            r"remaining seam|known issue|placeholder|prototype)\b",
            re.IGNORECASE,
        ),
    ),
    (
        "novelty-claim",
        re.compile(
            r"\b(?:to our knowledge|previously unknown|first formalization|novel)\b",
            re.IGNORECASE,
        ),
    ),
)

REQUIRED_CONFIG_KEYS = (
    "schema_version",
    "area",
    "gate",
    "trust_statement",
    "axiom_audit",
    "statement_title",
    "overview",
    "correspondence",
    "boundary",
    "axiom_audit_title",
    "axiom_audit_description",
    "readme_bullet",
    "readme_anchor",
)
AREA_NAME_RE = re.compile(r"^[a-z0-9]+(?:_[a-z0-9]+)*$")
MODULE_NAME_RE = re.compile(r"^[A-Za-z0-9_']+(?:\.[A-Za-z0-9_']+)*$")


class Refused(RuntimeError):
    """An input or intermediate state cannot support a trustworthy export."""


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def canonical_json(value: Any) -> str:
    return json.dumps(value, ensure_ascii=False, indent=2, sort_keys=True) + "\n"


def git_bytes(repo: Path, *args: str) -> bytes:
    proc = subprocess.run(
        ["git", "-C", str(repo), *args],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        check=False,
    )
    if proc.returncode:
        detail = proc.stderr.decode("utf-8", "replace").strip().splitlines()
        head = detail[0] if detail else f"exit {proc.returncode}"
        raise Refused(f"git {' '.join(args)} in {repo} failed: {head}")
    return proc.stdout


def git_text(repo: Path, *args: str) -> str:
    return git_bytes(repo, *args).decode("utf-8")


def resolve_commit(repo: Path, rev: str) -> str:
    return git_text(repo, "rev-parse", "--verify", f"{rev}^{{commit}}").strip()


def read_blob(repo: Path, commit: str, path: str) -> bytes:
    return git_bytes(repo, "cat-file", "blob", f"{commit}:{path}")


def blob_exists(repo: Path, commit: str, path: str) -> bool:
    proc = subprocess.run(
        ["git", "-C", str(repo), "cat-file", "-e", f"{commit}:{path}"],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
        check=False,
    )
    return proc.returncode == 0


def list_tree(repo: Path, commit: str, prefix: str) -> list[str]:
    out = git_text(repo, "ls-tree", "-r", "--name-only", commit, "--", prefix)
    return [line for line in out.splitlines() if line]


def worktree_is_clean(repo: Path) -> bool:
    return git_text(repo, "status", "--porcelain").strip() == ""


def filesystem_type(path: Path) -> str:
    target = path
    while not target.exists():
        parent = target.parent
        if parent == target:
            break
        target = parent
    resolved = str(target.resolve())
    best_mount = ""
    best_type = "unknown"
    try:
        mounts = Path("/proc/mounts").read_text().splitlines()
    except OSError:
        return "unknown"
    for line in mounts:
        fields = line.split()
        if len(fields) < 3:
            continue
        mount_point, fs_type = fields[1], fields[2]
        if resolved == mount_point or resolved.startswith(mount_point.rstrip("/") + "/"):
            if len(mount_point) >= len(best_mount):
                best_mount, best_type = mount_point, fs_type
    return best_type


def audit_text(label: str, text: str) -> list[str]:
    findings = []
    for name, pattern in PRIVATE_PATTERNS:
        match = pattern.search(text)
        if match:
            findings.append(f"{label}: {name}: {match.group(0)!r}")
    return findings


@dataclass(frozen=True)
class ModuleSource:
    module: str
    path: str
    data: bytes

    @property
    def sha256(self) -> str:
        return sha256_bytes(self.data)

    @property
    def bytes_len(self) -> int:
        return len(self.data)

    def manifest_entry(self) -> dict[str, Any]:
        return {
            "bytes": self.bytes_len,
            "module": self.module,
            "path": self.path,
            "sha256": self.sha256,
        }


@dataclass(frozen=True)
class SourceUnit:
    commit: str
    area: str
    gate: str
    terminals: tuple[str, ...]
    terminal_axioms: dict[str, tuple[str, ...]]
    modules: tuple[ModuleSource, ...]
    external_imports: tuple[str, ...]
    toolchain: str
    mathlib_rev: str

    @property
    def permitted_axioms(self) -> tuple[str, ...]:
        axioms: set[str] = set()
        for values in self.terminal_axioms.values():
            axioms.update(values)
        return tuple(sorted(axioms))


def load_config(path: Path) -> dict[str, Any]:
    try:
        config = tomllib.loads(path.read_text())
    except (OSError, tomllib.TOMLDecodeError) as error:
        raise Refused(f"unreadable area configuration {path}: {error}") from error
    missing = [key for key in REQUIRED_CONFIG_KEYS if key not in config]
    if missing:
        raise Refused(f"{path} is missing required keys: {', '.join(missing)}")
    if config["schema_version"] != 1:
        raise Refused(f"{path} declares unsupported schema_version {config['schema_version']!r}")
    if not AREA_NAME_RE.match(str(config["area"])):
        raise Refused(f"{path} declares a non-canonical area name {config['area']!r}")
    if not MODULE_NAME_RE.match(str(config["gate"])):
        raise Refused(f"{path} declares a malformed gate module {config['gate']!r}")
    findings: list[str] = []
    for key in (
        "statement_title",
        "overview",
        "correspondence",
        "boundary",
        "axiom_audit_title",
        "axiom_audit_description",
        "readme_bullet",
    ):
        findings.extend(audit_text(f"{path.name}:{key}", str(config[key])))
    if findings:
        raise Refused("area configuration prose carries private references:\n  " + "\n  ".join(findings))
    return config


def module_source_path(module: str) -> str:
    return module.replace(".", "/") + ".lean"


def derive_source_unit(source_repo: Path, commit: str, config: dict[str, Any]) -> SourceUnit:
    gate = str(config["gate"])
    fact_path = f"lean/trust/facts/{gate}.json"
    if not blob_exists(source_repo, commit, fact_path):
        raise Refused(f"source commit {commit[:8]} has no generated fact {fact_path}")
    fact = json.loads(read_blob(source_repo, commit, fact_path).decode("utf-8"))
    if fact.get("schema_version") != 1:
        raise Refused(f"{fact_path} declares unsupported schema_version {fact.get('schema_version')!r}")
    if fact.get("unit") != gate:
        raise Refused(f"{fact_path} records unit {fact.get('unit')!r} rather than {gate!r}")

    declared = declared_terminals(source_repo, commit, gate)
    fact_terminals = tuple(sorted(fact.get("terminal_axioms", {})))
    if declared != fact_terminals:
        raise Refused(
            "registered terminals and generated fact disagree: "
            f"registry {list(declared)} versus fact {list(fact_terminals)}"
        )

    closure = tuple(sorted(fact.get("closure", ())))
    if gate not in closure:
        raise Refused(f"{fact_path} closure does not contain its own gate module")

    modules: list[ModuleSource] = []
    for module in closure:
        path = module_source_path(module)
        source_path = f"lean/{path}"
        if not blob_exists(source_repo, commit, source_path):
            raise Refused(f"closure module {module} has no source file {source_path}")
        modules.append(ModuleSource(module=module, path=path, data=read_blob(source_repo, commit, source_path)))

    parsed_closure, external = walk_imports(source_repo, commit, gate)
    if parsed_closure != set(closure):
        missing = sorted(parsed_closure - set(closure))
        extra = sorted(set(closure) - parsed_closure)
        raise Refused(
            "generated closure and import closure disagree: "
            f"import-only {missing}, fact-only {extra}"
        )

    toolchain = read_blob(source_repo, commit, "lean/lean-toolchain").decode("utf-8").strip()
    mathlib_rev = str(fact.get("mathlib_rev", ""))
    if not mathlib_rev:
        raise Refused(f"{fact_path} records no Mathlib revision")

    terminal_axioms = {
        name: tuple(sorted(values)) for name, values in sorted(fact["terminal_axioms"].items())
    }
    return SourceUnit(
        commit=commit,
        area=str(config["area"]),
        gate=gate,
        terminals=declared,
        terminal_axioms=terminal_axioms,
        modules=tuple(modules),
        external_imports=tuple(sorted(external)),
        toolchain=toolchain,
        mathlib_rev=mathlib_rev,
    )


def declared_terminals(source_repo: Path, commit: str, gate: str) -> tuple[str, ...]:
    """Read the exact terminal list registered for `gate` in the trust registry."""
    found: list[tuple[str, tuple[str, ...]]] = []
    for path in list_tree(source_repo, commit, "lean/trust/areas"):
        if not path.endswith(".toml"):
            continue
        registry = tomllib.loads(read_blob(source_repo, commit, path).decode("utf-8"))
        for entry in registry.get("gate", ()):
            if entry.get("module") == gate:
                found.append((path, tuple(sorted(entry.get("terminals", ())))))
    if not found:
        raise Refused(f"no trust registry at commit {commit[:8]} declares gate {gate}")
    if len({terminals for _, terminals in found}) != 1:
        raise Refused(f"trust registries disagree on the terminals of {gate}")
    terminals = found[0][1]
    if not terminals:
        raise Refused(f"gate {gate} declares an empty terminal list")
    return terminals


def walk_imports(source_repo: Path, commit: str, gate: str) -> tuple[set[str], set[str]]:
    """Return the project-local import closure of `gate` and its external imports."""
    closure: set[str] = set()
    external: set[str] = set()
    pending = [gate]
    while pending:
        module = pending.pop()
        if module in closure:
            continue
        closure.add(module)
        text = read_blob(source_repo, commit, f"lean/{module_source_path(module)}").decode("utf-8")
        for imported in IMPORT_RE.findall(text):
            if blob_exists(source_repo, commit, f"lean/{module_source_path(imported)}"):
                pending.append(imported)
            else:
                external.add(imported)
    return closure, external


@dataclass(frozen=True)
class BaseState:
    repo: Path
    commit: str
    head: str
    manifest: dict[str, Any]
    lakefile: str
    readme: str
    provenance: str

    def module_paths(self) -> dict[str, str]:
        return {entry["module"]: entry["path"] for entry in self.manifest["sources"]}


def load_base_state(base_repo: Path, commit: str) -> BaseState:
    manifest = json.loads(read_blob(base_repo, commit, "TARGET_MANIFEST.json").decode("utf-8"))
    if manifest.get("schema_version") != 1:
        raise Refused("base TARGET_MANIFEST.json declares an unsupported schema version")
    if manifest.get("module_count") != len(manifest.get("sources", ())):
        raise Refused("base TARGET_MANIFEST.json module count disagrees with its source list")
    return BaseState(
        repo=base_repo,
        commit=commit,
        head=resolve_commit(base_repo, "HEAD"),
        manifest=manifest,
        lakefile=read_blob(base_repo, commit, "lakefile.toml").decode("utf-8"),
        readme=read_blob(base_repo, commit, "README.md").decode("utf-8"),
        provenance=read_blob(base_repo, commit, "PROVENANCE.md").decode("utf-8"),
    )


def check_base_manifest_completeness(base: BaseState) -> None:
    for entry in base.manifest["sources"]:
        path = entry["path"]
        if not blob_exists(base.repo, base.commit, path):
            raise Refused(f"base manifest lists missing file {path}")
        data = read_blob(base.repo, base.commit, path)
        if len(data) != entry["bytes"] or sha256_bytes(data) != entry["sha256"]:
            raise Refused(f"base manifest entry for {path} does not match the base tree")


def check_toolchain_agreement(source: SourceUnit, base: BaseState) -> None:
    base_toolchain = read_blob(base.repo, base.commit, "lean-toolchain").decode("utf-8").strip()
    if base_toolchain != source.toolchain:
        raise Refused(
            f"toolchain mismatch: source {source.toolchain!r} versus base {base_toolchain!r}"
        )
    lake_manifest = json.loads(read_blob(base.repo, base.commit, "lake-manifest.json").decode("utf-8"))
    revisions = {
        package.get("name"): package.get("rev") for package in lake_manifest.get("packages", ())
    }
    base_rev = revisions.get("mathlib")
    if base_rev != source.mathlib_rev:
        raise Refused(
            f"Mathlib revision mismatch: source {source.mathlib_rev} versus base {base_rev}"
        )


def guard_paths(base_repo: Path, out: Path | None) -> None:
    if SUFFIXED_CLONE_RE.match(base_repo.name):
        raise Refused(f"{base_repo} is a suffixed candidate clone, not a canonical base")
    if out is None:
        return
    if SUFFIXED_CLONE_RE.match(out.name):
        raise Refused(f"{out} reuses a suffixed candidate clone name")
    resolved_base = base_repo.resolve()
    resolved_out = out.resolve()
    if resolved_out == resolved_base or resolved_base in resolved_out.parents:
        raise Refused("the candidate directory must lie outside the canonical base repository")
    fs_type = filesystem_type(out)
    if fs_type in MEMORY_BACKED_FILESYSTEMS:
        raise Refused(f"{out} is on a memory-backed {fs_type} filesystem")


def updated_target_manifest(source: SourceUnit, base: BaseState) -> dict[str, Any]:
    entries = {entry["module"]: dict(entry) for entry in base.manifest["sources"]}
    base_paths = {entry["path"]: entry["module"] for entry in base.manifest["sources"]}
    for module in source.modules:
        clashing = base_paths.get(module.path)
        if clashing is not None and clashing != module.module:
            raise Refused(f"{module.path} is already claimed by base module {clashing}")
        entries[module.module] = module.manifest_entry()
    roots = set(base.manifest["roots"]) | {source.gate}
    externals = set(base.manifest["external_imports"]) | set(source.external_imports)
    sources = sorted(entries.values(), key=lambda entry: entry["module"])
    return {
        "external_imports": sorted(externals),
        "module_count": len(sources),
        "roots": sorted(roots),
        "schema_version": 1,
        "sources": sources,
    }


def insert_lakefile_roots(lakefile: str, modules: tuple[str, ...]) -> str:
    text = lakefile
    for module in sorted(modules):
        library = module.split(".", 1)[0]
        quoted = f'"{module}"'
        if re.search(rf"^\s*{re.escape(quoted)},?\s*$", text, re.MULTILINE):
            continue
        pattern = re.compile(
            rf'(name = "{re.escape(library)}"\n(?:.*\n)*?roots = \[\n)((?:\s*"[^"]+",\n)+)',
        )
        match = pattern.search(text)
        if match is None:
            raise Refused(f"lakefile declares no roots list for library {library}")
        block = match.group(2)
        lines = block.splitlines(keepends=True)
        indent = re.match(r"\s*", lines[0]).group(0)
        position = len(lines)
        for index, line in enumerate(lines):
            existing = line.strip().strip(",").strip('"')
            if existing > module:
                position = index
                break
        lines.insert(position, f'{indent}{quoted},\n')
        text = text[: match.start(2)] + "".join(lines) + text[match.end(2) :]
    return text


def retarget_module_counts(text: str, label: str, old_count: int, new_count: int,
                           accept_drift: bool) -> tuple[str, list[str]]:
    """Update declared library-state module counts, refusing silent prose drift."""
    drift: list[str] = []
    pattern = re.compile(r"(\d+)-module (reviewed\n?\s*library state|library state)")

    def replace(match: re.Match[str]) -> str:
        declared = int(match.group(1))
        if declared != old_count:
            drift.append(f"{label}: declares {declared}-module library state, base records {old_count}")
            return match.group(0)
        return f"{new_count}-module {match.group(2)}"

    updated = pattern.sub(replace, text)
    if drift and not accept_drift:
        raise Refused(
            "base prose disagrees with the base manifest; rerun with --accept-base-prose-drift "
            "to leave the drifted statement untouched:\n  " + "\n  ".join(drift)
        )
    return updated, drift


def insert_readme_bullet(readme: str, anchor: str, bullet: str) -> str:
    if bullet.strip() in readme:
        raise Refused("the README already carries the configured companion bullet")
    lines = readme.splitlines(keepends=True)
    for index, line in enumerate(lines):
        if line.rstrip("\n") == anchor:
            block = bullet if bullet.endswith("\n") else bullet + "\n"
            lines.insert(index + 1, block)
            return "".join(lines)
    raise Refused(f"the README has no line matching the configured anchor {anchor!r}")


def render_area_registry(source: SourceUnit, config: dict[str, Any]) -> str:
    axioms = ", ".join(f'"{axiom}"' for axiom in source.permitted_axioms)
    lines = [
        f"# Trust boundary for {config['statement_title'].rstrip('.').lower()}.",
        "",
        "schema_version = 1",
        f'area = "{source.area}"',
        f'manifest = "{config["trust_statement"]}"',
        "",
        "owns = [",
    ]
    for module in source.modules:
        lines.append(f'  "{module.module}",')
    lines += [
        "]",
        "",
        f"permitted_axioms = [{axioms}]",
        "",
        "[[gate]]",
        f'module = "{source.gate}"',
        "terminals = [",
    ]
    for terminal in source.terminals:
        lines.append(f'  "{terminal}",')
    lines += [
        "]",
        'coverage_rule = "closure"',
    ]
    for terminal in source.terminals:
        observed = ", ".join(f'"{axiom}"' for axiom in source.terminal_axioms[terminal])
        lines += [
            "",
            "[[terminal]]",
            f'declaration = "{terminal}"',
            f'gates = ["{source.gate}"]',
            f"expected_axioms = [{observed}]",
        ]
    return "\n".join(lines) + "\n"


def render_trust_statement(source: SourceUnit, config: dict[str, Any]) -> str:
    module_list = "\n".join(f"- `{module.module}`" for module in source.modules)
    axioms = ", ".join(f"`{axiom}`" for axiom in source.permitted_axioms)
    return (
        f"# {config['statement_title']}\n"
        "\n"
        f"{config['overview'].strip()}\n"
        "\n"
        "The exact project-local closure is rooted at\n"
        f"`{source.gate}`\n"
        "and consists of:\n"
        "\n"
        f"{module_list}\n"
        "\n"
        "## Formal correspondence\n"
        "\n"
        f"{config['correspondence'].strip()}\n"
        "\n"
        "## Trust boundary\n"
        "\n"
        f"{config['boundary'].strip()}\n"
        "\n"
        f"The observed axiom set of every terminal below is contained in {axioms}.\n"
        f"Source and candidate bytes are recorded in\n"
        f"`trust/source-manifests/{source.area}.json` and\n"
        f"`trust/manifests/{source.area}.json`.\n"
        "\n"
        "## Terminals\n"
        "\n"
        + "".join(f"- `{terminal}`\n" for terminal in source.terminals)
    )


def render_axiom_audit(source: SourceUnit, config: dict[str, Any]) -> str:
    prints = "".join(f"#print axioms {terminal}\n" for terminal in source.terminals)
    return (
        f"import {source.gate}\n"
        "\n"
        "/-!\n"
        f"# {config['axiom_audit_title']}\n"
        "\n"
        f"{config['axiom_audit_description'].strip()}\n"
        "-/\n"
        "\n"
        f"{prints}"
    )


def area_manifest(source: SourceUnit) -> dict[str, Any]:
    return {
        "external_imports": list(source.external_imports),
        "module_count": len(source.modules),
        "roots": [source.gate],
        "schema_version": 1,
        "sources": [module.manifest_entry() for module in source.modules],
    }


@dataclass(frozen=True)
class Plan:
    source: SourceUnit
    base: BaseState
    config: dict[str, Any]
    files: dict[str, bytes]
    prose_drift: tuple[str, ...]

    def summary(self) -> dict[str, Any]:
        return {
            "area": self.source.area,
            "gate": self.source.gate,
            "source_commit": self.source.commit,
            "base_commit": self.base.commit,
            "toolchain": self.source.toolchain,
            "mathlib_rev": self.source.mathlib_rev,
            "closure_modules": [module.module for module in self.source.modules],
            "closure_bytes": sum(module.bytes_len for module in self.source.modules),
            "terminals": list(self.source.terminals),
            "permitted_axioms": list(self.source.permitted_axioms),
            "external_imports": list(self.source.external_imports),
            "base_module_count": self.base.manifest["module_count"],
            "candidate_module_count": json.loads(
                self.files["TARGET_MANIFEST.json"].decode("utf-8")
            )["module_count"],
            "written_files": sorted(self.files),
            "prose_drift": list(self.prose_drift),
        }


def build_plan(
    source_repo: Path,
    source_rev: str,
    base_repo: Path,
    base_rev: str,
    config_path: Path,
    accept_drift: bool,
) -> Plan:
    config = load_config(config_path)
    if not worktree_is_clean(base_repo):
        raise Refused(f"the canonical base repository {base_repo} has uncommitted changes")
    source_commit = resolve_commit(source_repo, source_rev)
    base_commit = resolve_commit(base_repo, base_rev)
    source = derive_source_unit(source_repo, source_commit, config)
    base = load_base_state(base_repo, base_commit)
    check_base_manifest_completeness(base)
    check_toolchain_agreement(source, base)

    files: dict[str, bytes] = {}
    for module in source.modules:
        files[module.path] = module.data
    manifest = updated_target_manifest(source, base)
    files["TARGET_MANIFEST.json"] = canonical_json(manifest).encode("utf-8")
    files["lakefile.toml"] = insert_lakefile_roots(
        base.lakefile, tuple(module.module for module in source.modules)
    ).encode("utf-8")
    files[str(config["trust_statement"])] = render_trust_statement(source, config).encode("utf-8")
    files[str(config["axiom_audit"])] = render_axiom_audit(source, config).encode("utf-8")
    files[f"trust/areas/{source.area}.toml"] = render_area_registry(source, config).encode("utf-8")
    area = canonical_json(area_manifest(source)).encode("utf-8")
    files[f"trust/manifests/{source.area}.json"] = area
    files[f"trust/source-manifests/{source.area}.json"] = area

    old_count = int(base.manifest["module_count"])
    new_count = int(manifest["module_count"])
    readme, readme_drift = retarget_module_counts(
        base.readme, "README.md", old_count, new_count, accept_drift
    )
    readme = insert_readme_bullet(readme, str(config["readme_anchor"]), str(config["readme_bullet"]))
    provenance, provenance_drift = retarget_module_counts(
        base.provenance, "PROVENANCE.md", old_count, new_count, accept_drift
    )
    files["README.md"] = readme.encode("utf-8")
    files["PROVENANCE.md"] = provenance.encode("utf-8")

    # A statement left untouched by an accepted drift produces no forward delta.
    for path, original in (("README.md", base.readme), ("PROVENANCE.md", base.provenance)):
        if files[path] == original.encode("utf-8"):
            del files[path]

    findings: list[str] = []
    for path, data in files.items():
        if path.endswith((".json",)):
            continue
        findings.extend(audit_text(path, data.decode("utf-8", "replace")))
    if findings:
        raise Refused("candidate content carries private references:\n  " + "\n  ".join(findings))

    return Plan(
        source=source,
        base=base,
        config=config,
        files=files,
        prose_drift=tuple(readme_drift + provenance_drift),
    )


def materialize(plan: Plan, out: Path) -> None:
    guard_paths(plan.base.repo, out)
    if out.exists() and any(out.iterdir()):
        raise Refused(f"{out} already exists and is not empty")
    out.parent.mkdir(parents=True, exist_ok=True)
    subprocess.run(
        ["git", "clone", "--quiet", "--no-checkout", "--no-hardlinks",
         str(plan.base.repo), str(out)],
        check=True,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.PIPE,
    )
    git_text(out, "checkout", "--quiet", "--detach", plan.base.commit)
    git_text(out, "remote", "remove", "origin")
    for path in sorted(plan.files):
        destination = out / path
        destination.parent.mkdir(parents=True, exist_ok=True)
        destination.write_bytes(plan.files[path])


def verify(plan: Plan, out: Path) -> dict[str, Any]:
    if resolve_commit(out, "HEAD") != plan.base.commit:
        raise Refused("the candidate is not checked out at the exact canonical base commit")
    if git_text(out, "remote").strip():
        raise Refused("the candidate repository still declares a remote")
    if git_text(out, "rev-list", "--count", "HEAD").strip() != git_text(
        plan.base.repo, "rev-list", "--count", plan.base.commit
    ).strip():
        raise Refused("the candidate history differs from the canonical base history")

    for module in plan.source.modules:
        data = (out / module.path).read_bytes()
        if data != module.data:
            raise Refused(f"{module.path} does not match its immutable source bytes")

    manifest = json.loads((out / "TARGET_MANIFEST.json").read_text())
    if manifest["module_count"] != len(manifest["sources"]):
        raise Refused("the candidate manifest module count disagrees with its source list")
    for entry in manifest["sources"]:
        path = out / entry["path"]
        if not path.is_file():
            raise Refused(f"the candidate manifest lists missing file {entry['path']}")
        data = path.read_bytes()
        if len(data) != entry["bytes"] or sha256_bytes(data) != entry["sha256"]:
            raise Refused(f"the candidate manifest entry for {entry['path']} does not match its bytes")
    if plan.source.gate not in manifest["roots"]:
        raise Refused("the candidate manifest does not record the exported gate as a root")

    area = json.loads((out / f"trust/manifests/{plan.source.area}.json").read_text())
    if area != json.loads((out / f"trust/source-manifests/{plan.source.area}.json").read_text()):
        raise Refused("the candidate source and target area manifests differ")
    if {entry["module"] for entry in area["sources"]} != {m.module for m in plan.source.modules}:
        raise Refused("the area manifest does not record the exact project-local closure")

    registry = tomllib.loads((out / f"trust/areas/{plan.source.area}.toml").read_text())
    declared = tuple(sorted(registry["gate"][0]["terminals"]))
    if declared != plan.source.terminals:
        raise Refused("the candidate registry does not record the exact terminal list")

    audit = (out / str(plan.config["axiom_audit"])).read_text()
    for terminal in plan.source.terminals:
        if f"#print axioms {terminal}" not in audit:
            raise Refused(f"the axiom audit does not print the axioms of {terminal}")

    if not worktree_is_clean(plan.base.repo):
        raise Refused("the canonical base repository changed during export")
    if resolve_commit(plan.base.repo, "HEAD") != plan.base.head:
        raise Refused("the canonical base repository moved during export")

    return {
        "candidate": str(out),
        "base_commit": plan.base.commit,
        "source_commit": plan.source.commit,
        "module_count": manifest["module_count"],
        "closure_modules": [module.module for module in plan.source.modules],
        "terminals": list(plan.source.terminals),
    }


def tree_fingerprint(root: Path) -> dict[str, str]:
    fingerprint: dict[str, str] = {}
    for path in sorted(root.rglob("*")):
        if path.is_dir() or ".git" in path.parts:
            continue
        fingerprint[str(path.relative_to(root))] = sha256_bytes(path.read_bytes())
    return fingerprint


def forward_delta(plan: Plan, out: Path, verbose: bool = False) -> dict[str, Any]:
    """Describe the candidate's delta against the base, requiring it to lie inside the plan.

    Every changed path must be one the plan intended to write; an unplanned path is a hard
    refusal.  A planned file may be absent from the delta: the exporter rewrites the whole
    closure, so a module the base already carries byte for byte produces no change.  Those
    files are counted, and listed when `verbose`, so a refresh that silently rewrites nothing
    cannot be mistaken for one that carried its modules across.
    """
    status = git_text(out, "status", "--porcelain", "--untracked-files=all").splitlines()
    added = sorted(line[3:] for line in status if line.startswith("??"))
    modified = sorted(line[3:] for line in status if line.startswith(" M"))
    unexpected = sorted(line for line in status if not line.startswith(("??", " M")))
    if unexpected:
        raise Refused("the candidate tree has deletions or index state:\n  " + "\n  ".join(unexpected))
    expected = set(plan.files)
    actual = set(added) | set(modified)
    unplanned = sorted(actual - expected)
    if unplanned:
        raise Refused(
            "the candidate delta leaves the planned file set: "
            f"unplanned {unplanned}"
        )
    unchanged = sorted(expected - actual)
    delta: dict[str, Any] = {
        "added": added,
        "modified": modified,
        "file_count": len(actual),
        "planned_unchanged_count": len(unchanged),
    }
    if verbose:
        delta["planned_unchanged"] = unchanged
    return delta


def command_plan(args: argparse.Namespace) -> int:
    plan = build_plan(
        REPO_ROOT, args.source_commit, args.base_repo, args.base_commit,
        args.config, args.accept_base_prose_drift,
    )
    guard_paths(args.base_repo, None)
    print(canonical_json(plan.summary()), end="")
    return EXIT_OK


def command_run(args: argparse.Namespace) -> int:
    plan = build_plan(
        REPO_ROOT, args.source_commit, args.base_repo, args.base_commit,
        args.config, args.accept_base_prose_drift,
    )
    workdir = args.workdir
    first = workdir / "candidate"
    second = workdir / "repeat"
    for path in (first, second):
        if path.exists():
            if not args.replace:
                raise Refused(f"{path} already exists; pass --replace to discard a stale candidate")
            shutil.rmtree(path)
    materialize(plan, first)
    materialize(plan, second)
    if tree_fingerprint(first) != tree_fingerprint(second):
        raise Refused("repeat materialization is not byte-identical")
    result = verify(plan, first)
    result["deterministic_repeat"] = True
    result["forward_delta"] = forward_delta(plan, first, args.verbose)
    result["prose_drift"] = list(plan.prose_drift)
    shutil.rmtree(second)
    print(canonical_json(result), end="")
    return EXIT_OK


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--config", type=Path, required=True,
                        help="tracked area configuration under lean/trust/export")
    parser.add_argument("--source-commit", default="HEAD",
                        help="exact commit of this repository supplying the trust unit")
    parser.add_argument("--base-repo", type=Path, default=CANONICAL_BASE_DEFAULT,
                        help="canonical base repository")
    parser.add_argument("--base-commit", default="HEAD",
                        help="exact commit of the canonical base repository")
    parser.add_argument("--accept-base-prose-drift", action="store_true",
                        help="leave base statements that already disagree with the base manifest")
    subparsers = parser.add_subparsers(dest="command", required=True)
    subparsers.add_parser("plan", help="derive and print the export plan without writing anything")
    run = subparsers.add_parser(
        "run", help="materialize twice, verify, and print the read-only forward delta"
    )
    run.add_argument("--workdir", type=Path, required=True,
                     help="disk-backed directory receiving the disposable candidate")
    run.add_argument("--replace", action="store_true", help="discard an existing candidate directory")
    run.add_argument("--verbose", action="store_true",
                     help="list the planned files whose bytes the base already carries")
    args = parser.parse_args(argv)
    try:
        if args.command == "plan":
            return command_plan(args)
        return command_run(args)
    except Refused as error:
        print(f"refused: {error}", file=sys.stderr)
        return EXIT_REFUSED


if __name__ == "__main__":
    sys.exit(main())
