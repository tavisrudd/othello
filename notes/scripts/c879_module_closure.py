#!/usr/bin/env python3
"""Read-only closure/mapping cross-check for the C879 module-name mapping.

Computes each declared gate's project-owned import closure from the Lean sources
in this repository (no Lake, no elaboration) and compares it against the group
assignments in notes/2026-08-06-c879-module-name-mapping.json.

Replay:
    python3 notes/scripts/c879_module_closure.py            # AME--LU and MDS--CSS
    python3 notes/scripts/c879_module_closure.py <Gate.Module> ...
"""

from __future__ import annotations

import json
import os
import re
import sys

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
LEAN = os.path.join(REPO, "lean")
MAPPING = os.path.join(REPO, "notes", "2026-08-06-c879-module-name-mapping.json")
IMPORT = re.compile(r"^import\s+([A-Za-z0-9_.]+)", re.M)

DEFAULT_GATES = [
    "RelativeConicArcs.Gates.AMELUAggregate",
    "RelativeConicArcs.Gates.MDSCSSTransversalGeometry",
    "RelativeConicArcs.Gates.AMELUTwoUniformRigidity",
    "RelativeConicArcs.Gates.PRSBalancedQuantumExtension",
]


def source_path(module: str) -> str | None:
    path = os.path.join(LEAN, module.replace(".", "/") + ".lean")
    return path if os.path.exists(path) else None


def closure(root: str) -> set[str]:
    """Project-owned transitive import closure; foreign imports are dropped."""
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
        with open(path) as handle:
            stack.extend(IMPORT.findall(handle.read()))
    return {module for module in seen if source_path(module)}


def main(argv: list[str]) -> int:
    with open(MAPPING) as handle:
        mapping = json.load(handle)
    groups = {g["id"]: set(g["legacy_modules"]) for g in mapping["shared_groups"]}
    assigned = set().union(*groups.values())
    for group in mapping["paper_groups"]:
        assigned |= set(group.get("paper_private_modules", []))
        assigned |= set(group.get("paper_facing_legacy_modules", []))

    for gate in argv[1:] or DEFAULT_GATES:
        modules = closure(gate)
        print(f"{gate}: {len(modules)} project-owned modules")
        for gid, members in sorted(groups.items()):
            hit = modules & members
            if hit:
                print(f"  shared/{gid}: {len(hit)}")
        residual = sorted(m for m in modules - assigned if ".Gates." not in m)
        print(f"  unassigned non-gate modules: {len(residual)}")
        for module in residual:
            print(f"    {module}")
        gates = sorted(m for m in modules if ".Gates." in m and m != gate)
        print(f"  imported gate modules: {len(gates)}")
        for module in gates:
            print(f"    {module}")

    on_disk = {
        "RelativeConicArcs.AMELU." + name[:-5]
        for name in os.listdir(os.path.join(LEAN, "RelativeConicArcs", "AMELU"))
        if name.endswith(".lean")
    }
    mapped = groups["amelu_api"]
    print(f"AMELU modules on disk: {len(on_disk)}; mapped to Shared.AMELU: {len(mapped)}")
    for module in sorted(on_disk - mapped):
        print(f"  unmapped: {module}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
