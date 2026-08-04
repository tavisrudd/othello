#!/usr/bin/env python3
"""Seal and pin the trust facts an external certificate package exhibits.

An external certificate package owns a closure this repository deliberately does not build.  Its
gate, terminals, and axiom dependencies are therefore not observable here, and the local Lean
exporter must never be asked to elaborate them.  This tool turns one recorded gate verification in
the owning package into a compact, content-addressed fact artifact that the monorepo trust tooling
can consume offline:

    seal   read a completed guarded-queue run over the package's import-only gate, together with
           the package's sealed source manifest, and write the package's `TRUST_FACT.json`
    pin    copy that artifact into `lean/trust/external/<package>.json`
    check  compare every pinned copy with `lean/trust/certificate-packages.toml`

`seal` runs no Lean and starts no build.  It refuses any run whose recorded tree was dirty, whose
root was not the package, or whose gate target did not end trace-current or successfully built.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import subprocess
import tomllib
from pathlib import Path
from typing import Any


LEAN_ROOT = Path(__file__).resolve().parents[1]
PACKAGES_CONFIG = LEAN_ROOT / "trust" / "certificate-packages.toml"
EXTERNAL_DIR = LEAN_ROOT / "trust" / "external"
FACT_SCHEMA_VERSION = 1
FACT_BASENAME = "TRUST_FACT.json"

# Lake prints one `depends on axioms` info per `#print axioms`, wrapping long axiom lists onto
# continuation lines.  Continuations are folded before matching, so the axiom list is read whole.
AXIOM_RE = re.compile(
    r"info: (?P<path>[^\s:]+):\d+:\d+: '(?P<decl>[^']+)' depends on axioms: \[(?P<axioms>[^\]]*)\]"
)
ACCEPTED_OUTCOMES = frozenset({"built", "success", "skipped-current"})


class Refused(Exception):
    """The inputs do not establish what the artifact would claim."""


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def git_head(root: Path) -> str:
    return subprocess.run(
        ["git", "rev-parse", "HEAD"], cwd=root, check=True, text=True, capture_output=True
    ).stdout.strip()


def read_json(path: Path) -> Any:
    if not path.is_file():
        raise Refused(f"{path}: missing")
    with path.open("rb") as handle:
        return json.load(handle)


def axiom_facts(log_text: str) -> dict[str, tuple[str, tuple[str, ...]]]:
    """Map each printed declaration to its source path and axiom list."""
    folded = re.sub(r"\n\s+", " ", log_text)
    facts: dict[str, tuple[str, tuple[str, ...]]] = {}
    for match in AXIOM_RE.finditer(folded):
        axioms = tuple(
            sorted(part.strip() for part in match["axioms"].split(",") if part.strip())
        )
        decl = match["decl"]
        path = match["path"]
        previous = facts.get(decl)
        if previous is not None and previous[1] != axioms:
            raise Refused(
                f"{decl}: the log prints two different axiom lists, {list(previous[1])} and "
                f"{list(axioms)}"
            )
        # A gate re-prints the terminals it imports.  Keep the defining module, which is the
        # first occurrence, rather than the gate that re-exports it.
        if previous is None:
            facts[decl] = (path, axioms)
    if not facts:
        raise Refused("the recorded log prints no axiom dependencies")
    return facts


def gate_run(run_dir: Path, package_root: Path, gate: str) -> tuple[Path, dict[str, Any]]:
    """Return the gate's log path and the run manifest, refusing anything short of clean evidence."""
    status = read_json(run_dir / "status.json")
    manifest = read_json(run_dir / "manifest.json")
    if status.get("state") != "success":
        raise Refused(f"{run_dir}: run state is {status.get('state')!r}, not success")
    recorded_root = Path(manifest.get("lean_root", ""))
    if recorded_root.resolve() != package_root.resolve():
        raise Refused(f"{run_dir}: ran against {recorded_root}, not the package root")
    source = manifest.get("source", {})
    if source.get("git_dirty") is not False:
        raise Refused(f"{run_dir}: the package tree was dirty during the run")
    head = git_head(package_root)
    if source.get("git_head") != head:
        raise Refused(
            f"{run_dir}: ran at {source.get('git_head')} but the package Lean source is now at "
            f"{head}; re-verify the gate before sealing"
        )
    for result in status.get("results", []):
        if result.get("target") != gate:
            continue
        if result.get("outcome") not in ACCEPTED_OUTCOMES:
            raise Refused(f"{run_dir}: gate outcome is {result.get('outcome')!r}")
        return Path(result["log"]), manifest
    raise Refused(f"{run_dir}: no result for gate {gate}")


def package_entry(config: Path, name: str) -> dict[str, Any]:
    with config.open("rb") as handle:
        document = tomllib.load(handle)
    for package in document.get("package", []):
        if package["name"] == name:
            return package
    raise Refused(f"{config}: no package named {name}")


def render_fact(
    package_root: Path,
    entry: dict[str, Any],
    run_dir: Path,
    evidence_rel: str,
) -> dict[str, Any]:
    gate = entry["gate"]
    log_path, run_manifest = gate_run(run_dir, package_root, gate)
    package_manifest_path = package_root / "MANIFEST.json"
    package_manifest = read_json(package_manifest_path)
    owned_module = {
        source["path"]: source["module"] for source in package_manifest.get("sources", [])
    }

    evidence_path = package_root / evidence_rel
    if not evidence_path.is_file():
        raise Refused(f"{evidence_path}: the gate log has not been preserved in the package")
    if evidence_path.read_bytes() != log_path.read_bytes():
        raise Refused(f"{evidence_path}: differs from the recorded run log {log_path}")

    declarations = {}
    for decl, (path, axioms) in sorted(axiom_facts(evidence_path.read_text(encoding="utf-8")).items()):
        module = owned_module.get(path)
        declarations[decl] = {
            "axioms": list(axioms),
            "module": module if module is not None else path,
            "origin": "package" if module is not None else "dependency",
        }

    terminal = entry["terminal"]
    if terminal not in declarations:
        raise Refused(f"{terminal}: the gate log records no axiom fact for the pinned terminal")

    return {
        "schema_version": FACT_SCHEMA_VERSION,
        "package": entry["name"],
        "repository": entry["repository"],
        "gate": gate,
        "terminal": terminal,
        "source_commit": run_manifest["source"]["git_head"],
        "manifest_sha256": sha256(package_manifest_path),
        "lean_toolchain": run_manifest["source"]["lean_toolchain"],
        "dependency": package_manifest["dependency"],
        "declarations": declarations,
        "evidence": {
            "axiom_log": evidence_rel,
            "axiom_log_sha256": sha256(evidence_path),
            "replay": f"lake build --no-build {gate}",
        },
    }


def encode(fact: dict[str, Any]) -> str:
    return json.dumps(fact, indent=2, sort_keys=True) + "\n"


def cmd_seal(args: argparse.Namespace) -> int:
    package_root = args.package_root.resolve()
    entry = package_entry(args.config, args.package or package_root.name)
    fact = render_fact(package_root, entry, args.run_dir.resolve(), args.evidence)
    encoded = encode(fact)
    target = package_root / FACT_BASENAME
    if args.write:
        target.write_text(encoded, encoding="utf-8")
        print(f"wrote {target} ({len(fact['declarations'])} declarations)")
        return 0
    if not target.is_file() or target.read_text(encoding="utf-8") != encoded:
        print(f"{target} is missing or stale")
        return 1
    print(f"{target} ok ({len(fact['declarations'])} declarations)")
    return 0


def cmd_pin(args: argparse.Namespace) -> int:
    package_root = args.package_root.resolve()
    name = args.package or package_root.name
    source = package_root / FACT_BASENAME
    if not source.is_file():
        raise Refused(f"{source}: seal the package fact before pinning it")
    fact = json.loads(source.read_text(encoding="utf-8"))
    if fact.get("package") != name:
        raise Refused(f"{source}: names package {fact.get('package')!r}, not {name!r}")
    target = args.external_dir / f"{name}.json"
    payload = source.read_bytes()
    if args.write:
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_bytes(payload)
        print(f"wrote {target}")
        print(f"trust_fact_sha256 = {hashlib.sha256(payload).hexdigest()}")
        return 0
    if not target.is_file() or target.read_bytes() != payload:
        print(f"{target} is missing or differs from the package artifact")
        return 1
    print(f"{target} ok")
    return 0


def pinned_facts(config: Path, external_dir: Path) -> tuple[dict[str, Any], list[str]]:
    """Load every pinned external fact, returning it with the problems found."""
    with config.open("rb") as handle:
        document = tomllib.load(handle)
    facts: dict[str, Any] = {}
    problems: list[str] = []
    for package in document.get("package", []):
        name = package["name"]
        relative = package.get("trust_fact")
        if relative is None:
            problems.append(f"{name}: pins no trust fact")
            continue
        path = external_dir.parent / relative
        if not path.is_file():
            problems.append(f"{name}: pinned trust fact {relative} is missing")
            continue
        payload = path.read_bytes()
        if hashlib.sha256(payload).hexdigest() != package.get("trust_fact_sha256"):
            problems.append(f"{name}: {relative} does not match the pinned hash")
            continue
        fact = json.loads(payload.decode("utf-8"))
        if fact.get("schema_version") != FACT_SCHEMA_VERSION:
            problems.append(f"{name}: {relative} schema_version is not {FACT_SCHEMA_VERSION}")
            continue
        for key, pinned in (
            ("package", name),
            ("gate", package.get("gate")),
            ("terminal", package.get("terminal")),
            ("manifest_sha256", package.get("manifest_sha256")),
        ):
            if fact.get(key) != pinned:
                problems.append(
                    f"{name}: {relative} records {key} {fact.get(key)!r}, pinned {pinned!r}"
                )
        facts[name] = fact
    return facts, problems


def cmd_check(args: argparse.Namespace) -> int:
    _, problems = pinned_facts(args.config, args.external_dir)
    if problems:
        print("external trust fact problems:")
        for problem in problems:
            print(f"- {problem}")
        return 1
    print("external trust facts ok")
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--config", type=Path, default=PACKAGES_CONFIG)
    parser.add_argument("--external-dir", type=Path, default=EXTERNAL_DIR)
    sub = parser.add_subparsers(dest="command", required=True)

    seal = sub.add_parser("seal", help="write the package's own trust fact from a recorded gate run")
    seal.add_argument("--package-root", type=Path, required=True)
    seal.add_argument("--run-dir", type=Path, required=True)
    seal.add_argument("--package")
    seal.add_argument(
        "--evidence",
        default="evidence/gate-axioms.log",
        help="package-relative path of the preserved gate log",
    )
    seal.add_argument("--write", action="store_true")
    seal.set_defaults(func=cmd_seal)

    pin = sub.add_parser("pin", help="copy a sealed package fact into the monorepo trust registry")
    pin.add_argument("--package-root", type=Path, required=True)
    pin.add_argument("--package")
    pin.add_argument("--write", action="store_true")
    pin.set_defaults(func=cmd_pin)

    check = sub.add_parser("check", help="compare pinned copies with the package registry")
    check.set_defaults(func=cmd_check)

    args = parser.parse_args()
    args.config = args.config.resolve()
    args.external_dir = args.external_dir.resolve()
    try:
        return args.func(args)
    except Refused as error:
        print(f"refused: {error}")
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
