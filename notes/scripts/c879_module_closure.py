#!/usr/bin/env python3
"""Read-only current-tree audit for the C879/C891 paper-extraction map.

The default replay checks every registered paper, standalone repository, tracked
Lean export area, mapped source module, target-name map, and recorded closure
count.  It reads Lean imports but does not invoke Lean or Lake.

Replay:
    python3 notes/scripts/c879_module_closure.py
    python3 notes/scripts/c879_module_closure.py --details
    python3 notes/scripts/c879_module_closure.py --gate <Lean.Module> [...]
"""

from __future__ import annotations

import argparse
import glob
import json
import os
import re
import subprocess
import sys
import tomllib

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
LEAN = os.path.join(REPO, "lean")
MAPPING = os.path.join(REPO, "notes", "2026-08-06-c879-module-name-mapping.json")
PAPERS = os.path.join(LEAN, "trust", "papers.toml")
REPOSITORIES = os.path.join(REPO, "papers", "repositories.toml")
EXPORTS = os.path.join(LEAN, "trust", "export", "*.toml")
IMPORT = re.compile(r"^import\s+([A-Za-z0-9_.]+)", re.M)


def source_path(module: str) -> str | None:
    path = os.path.join(LEAN, module.replace(".", "/") + ".lean")
    return path if os.path.exists(path) else None


def closure(root: str) -> set[str]:
    """Return the project-owned transitive import closure of ``root``."""
    seen: set[str] = set()
    stack = [root]
    while stack:
        module = stack.pop()
        if module in seen:
            continue
        seen.add(module)
        path = source_path(module)
        if path is None:
            continue
        with open(path, encoding="utf-8") as handle:
            stack.extend(IMPORT.findall(handle.read()))
    return {module for module in seen if source_path(module)}


def load_toml(path: str) -> dict:
    with open(path, "rb") as handle:
        return tomllib.load(handle)


def mapped_source_modules(mapping: dict) -> set[str]:
    result: set[str] = set()
    for group in mapping["shared_groups"]:
        result.update(group.get("legacy_modules", []))
    for group in mapping["paper_groups"]:
        result.update(group.get("paper_private_modules", []))
        result.update(group.get("paper_facing_legacy_modules", []))
    return result


def target_maps(mapping: dict):
    for section in ("shared_groups", "paper_groups"):
        for group in mapping[section]:
            for key, value in group.items():
                if key.endswith("_map") and isinstance(value, dict):
                    yield f"{section}/{group['id']}/{key}", value


def current_export_configs() -> dict[str, dict]:
    result = {}
    for path in sorted(glob.glob(EXPORTS)):
        data = load_toml(path)
        result[data["area"]] = {"gate": data["gate"], "path": path}
    return result


def git_lean_drift(source_commit: str) -> list[str]:
    command = [
        "git", "diff", "--name-only", f"{source_commit}..HEAD", "--", "lean"
    ]
    return subprocess.check_output(command, cwd=REPO, text=True).splitlines()


def audit(mapping: dict, details: bool) -> list[str]:
    errors: list[str] = []
    inventory = mapping["inventory"]

    paper_ids = [paper["id"] for paper in load_toml(PAPERS)["paper"]]
    if paper_ids != inventory["registered_paper_ids"]:
        errors.append("paper registry IDs differ from inventory.registered_paper_ids")

    repository_names = [repo["name"] for repo in load_toml(REPOSITORIES)["repository"]]
    if repository_names != inventory["standalone_repository_names"]:
        errors.append("repository names differ from inventory.standalone_repository_names")

    groups = mapping["paper_groups"]
    group_by_id = {group["id"]: group for group in groups}
    active_group_ids = [
        group["id"] for group in groups
        if group.get("registry_status") != "archived_unregistered"
    ]
    if sorted(active_group_ids) != sorted(paper_ids):
        errors.append("active paper_groups do not match the paper registry")

    for group in groups:
        if group.get("formal_surface_of") is None and group.get("registry_status") != "archived_unregistered":
            for key in ("imports_shared", "paper_private_modules", "export_areas"):
                if key not in group:
                    errors.append(f"{group['id']}: missing normalized field {key}")
        for root in group.get("legacy_roots", []):
            if source_path(root) is None:
                errors.append(f"{group['id']}: legacy root does not exist: {root}")
        parent = group.get("formal_surface_of")
        if parent is not None and parent not in group_by_id:
            errors.append(f"{group['id']}: missing formal_surface_of group {parent}")
        trust_area = group.get("trust_area")
        if trust_area is not None:
            trust_path = os.path.join(LEAN, "trust", "areas", trust_area + ".toml")
            if not os.path.exists(trust_path):
                errors.append(f"{group['id']}: trust area does not exist: {trust_area}")
        for dependency in group.get("cross_paper_dependencies", []):
            paper = dependency["paper"]
            if paper not in group_by_id:
                errors.append(f"{group['id']}: unknown paper dependency {paper}")
            for root in dependency.get("legacy_gate_imports", []):
                if source_path(root) is None:
                    errors.append(f"{group['id']}: dependency root does not exist: {root}")

    configured = current_export_configs()
    recorded = {area["area"]: area for area in mapping["current_export_areas"]}
    if sorted(configured) != sorted(recorded):
        errors.append("tracked export areas differ from current_export_areas")

    for entry in recorded.values():
        for paper in entry.get("paper_ids", []):
            if paper not in group_by_id:
                errors.append(f"{entry['area']}: unknown paper binding {paper}")
    for group in groups:
        for area in group.get("export_areas", []):
            if area not in recorded:
                errors.append(f"{group['id']}: unknown export area {area}")

    for area, config in sorted(configured.items()):
        entry = recorded.get(area)
        if entry is None:
            continue
        if entry["gate"] != config["gate"]:
            errors.append(
                f"{area}: recorded gate {entry['gate']} != configured {config['gate']}"
            )
            continue
        actual = len(closure(config["gate"]))
        if actual != entry["closure_modules"]:
            errors.append(
                f"{area}: closure {actual} != recorded {entry['closure_modules']}"
            )
        print(f"export {area}: gate={config['gate']} closure={actual}")

    sources = mapped_source_modules(mapping)
    missing_sources = sorted(module for module in sources if source_path(module) is None)
    for module in missing_sources:
        errors.append(f"mapped source module does not exist: {module}")

    for label, module_map in target_maps(mapping):
        targets = list(module_map.values())
        duplicate_targets = sorted({target for target in targets if targets.count(target) > 1})
        for target in duplicate_targets:
            errors.append(f"{label}: duplicate target {target}")

    dispositions = []
    for group in groups:
        dispositions.extend(group.get("gate_dispositions", []))
    for disposition in dispositions:
        gate = disposition["gate"]
        if source_path(gate) is None:
            errors.append(f"disposed gate does not exist: {gate}")
            continue
        actual = len(closure(gate))
        expected = disposition.get("closure_modules")
        if expected is not None and actual != expected:
            errors.append(f"{gate}: closure {actual} != recorded {expected}")

    amelu_dir = os.path.join(LEAN, "RelativeConicArcs", "AMELU")
    amelu_on_disk = {
        "RelativeConicArcs.AMELU." + name[:-5]
        for name in os.listdir(amelu_dir)
        if name.endswith(".lean")
    }
    amelu_assigned = {module for module in sources if module.startswith("RelativeConicArcs.AMELU.")}
    missing_amelu = sorted(amelu_on_disk - amelu_assigned)
    extra_amelu = sorted(amelu_assigned - amelu_on_disk)
    if missing_amelu:
        errors.append(f"unassigned AMELU modules: {len(missing_amelu)}")
    if extra_amelu:
        errors.append(f"mapped absent AMELU modules: {len(extra_amelu)}")
    print(
        f"inventory papers={len(paper_ids)} repositories={len(repository_names)} "
        f"exports={len(configured)} AMELU={len(amelu_assigned)}/{len(amelu_on_disk)}"
    )

    drift = git_lean_drift(mapping["authority"]["source_commit"])
    if drift:
        errors.append(f"Lean tree drifted from authority.source_commit: {len(drift)} paths")

    if details:
        for module in missing_amelu:
            print(f"unassigned AMELU: {module}")
        for path in drift:
            print(f"Lean drift: {path}")
    return errors


def main(argv: list[str]) -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--details", action="store_true")
    parser.add_argument("--gate", action="append", default=[])
    args = parser.parse_args(argv[1:])

    with open(MAPPING, encoding="utf-8") as handle:
        mapping = json.load(handle)

    errors = audit(mapping, args.details)
    for gate in args.gate:
        modules = closure(gate)
        print(f"gate {gate}: closure={len(modules)}")
        if args.details:
            for module in sorted(modules):
                print(f"  {module}")

    if errors:
        for error in errors:
            print(f"ERROR: {error}", file=sys.stderr)
        return 1
    print("mapping audit: PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
