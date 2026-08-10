#!/usr/bin/env python3
"""Audit the declared pending Q25 certificate migration without running Lean."""

from __future__ import annotations

import argparse
import subprocess
import tomllib
from pathlib import Path


REPOSITORY_ROOT = Path(__file__).resolve().parents[2]
DEFAULT_CONFIG = REPOSITORY_ROOT / "lean/trust/certificate-migrations/q25.toml"
FINAL_NAMESPACE = "TavisRuddFiniteGeom.Certificates.Q25"
MODULE_COUNT = 9531
FAMILY_COUNTS = {
    "root_modules": 39,
    "Gates": 2,
    "Q25CarrierLineData": 33,
    "Q25ExactMinimumRows": 6,
    "Q25ExhaustionConclusionData": 1071,
    "Q25ExhaustionDispatchData": 304,
    "Q25LineMaskData": 67,
    "Q25PairData": 1,
    "Q25PairRows": 1942,
    "Q25ResidualClassLinkData": 1036,
    "Q25ResidualConclusionData": 1071,
    "Q25ResidualConclusionDispatchData": 304,
    "Q25ResidualCoverData": 1072,
    "Q25ResidualDispatchData": 1071,
    "Q25ResidualTransportData": 1036,
    "Q25RowCompositionData": 238,
    "Q25RowCompositionStrictData": 238,
}
LEGACY_IMPORTS = {
    "RelativeConicArcs.Certificate",
    "RelativeConicArcs.FiniteFields",
    "RelativeConicArcs.Moments",
    "RelativeConicArcs.Nucleus",
    "RelativeConicArcs.ProjectiveBridge",
    "ProjectiveCap.PlaneTransitivity",
    "FiniteGeom.BaerCompletion.BaerPlane",
    "FiniteGeom.BaerCompletion.CollisionProfile",
    "FiniteGeom.BaerCompletion.OrbitCounting",
    "FiniteGeom.BaerCompletion.PairExtension",
}


def tracked_paths(root: Path, paths: list[str]) -> set[str]:
    result = subprocess.run(
        ["git", "-C", str(root), "ls-files", "--", *paths],
        text=True,
        capture_output=True,
        check=False,
    )
    if result.returncode != 0:
        return set()
    return set(result.stdout.splitlines())


def collision_paths(root: Path, namespace: str) -> list[str]:
    collisions: list[str] = []
    lean_root = root / "lean"
    for path in sorted(lean_root.rglob("*.lean")):
        if namespace in path.read_text(encoding="utf-8"):
            collisions.append(str(path.relative_to(root)))
    namespace_path = lean_root / Path(*namespace.split("."))
    if namespace_path.exists():
        collisions.append(str(namespace_path.relative_to(root)))
    return sorted(set(collisions))


def audit(root: Path, config: Path) -> tuple[list[str], list[str]]:
    with config.open("rb") as handle:
        document = tomllib.load(handle)
    problems: list[str] = []
    facts: list[str] = []

    if document.get("schema_version") != 1:
        problems.append("unsupported schema_version")
    if document.get("migration") != "q25":
        problems.append("migration must be q25")
    if document.get("status") != "pending":
        problems.append("migration status must be pending")
    if document.get("final_namespace") != FINAL_NAMESPACE:
        problems.append(f"final_namespace must be {FINAL_NAMESPACE}")
    if document.get("module_count") != MODULE_COUNT:
        problems.append(f"module_count must be {MODULE_COUNT}")

    families = document.get("family", [])
    family_names = [entry.get("name") for entry in families]
    if len(family_names) != len(set(family_names)):
        problems.append("family names must be unique")
    declared_families = {entry.get("name"): entry.get("count") for entry in families}
    if declared_families != FAMILY_COUNTS:
        problems.append("family entries do not match the frozen 9,531-module inventory")
    family_total = sum(entry.get("count", 0) for entry in families)
    if family_total != MODULE_COUNT:
        problems.append(f"family counts total {family_total}, expected {MODULE_COUNT}")

    imports = document.get("legacy_import", [])
    declared_imports = {entry.get("module") for entry in imports}
    if declared_imports != LEGACY_IMPORTS or len(imports) != len(LEGACY_IMPORTS):
        problems.append("legacy_import entries do not match the ten-import Q25 seam")
    nucleus = [entry for entry in imports if entry.get("module") == "RelativeConicArcs.Nucleus"]
    if len(nucleus) != 1 or nucleus[0].get("used") is not False or nucleus[0].get("declarations"):
        problems.append("RelativeConicArcs.Nucleus must be marked unused with no declarations")
    for entry in imports:
        importer = root / str(entry.get("importer", ""))
        import_line = f"import {entry.get('module')}"
        if not importer.is_file():
            problems.append(f"legacy importer is missing: {entry.get('importer')}")
        elif import_line not in importer.read_text(encoding="utf-8").splitlines():
            problems.append(f"legacy import is missing: {import_line} in {entry.get('importer')}")

    local_groups = document.get("local_group", [])
    if len(local_groups) != 5 or len({entry.get("name") for entry in local_groups}) != 5:
        problems.append("exactly five uniquely named local model/checker groups are required")
    downstream = document.get("downstream_family", [])
    if not downstream or any(not entry.get("theorems") for entry in downstream):
        problems.append("downstream theorem families must be nonempty")

    generators = document.get("generators", [])
    if len(generators) != 15 or len(set(generators)) != 15:
        problems.append("exactly fifteen unique tracked generators are required")
    tracked = tracked_paths(root, generators)
    for generator in generators:
        if not (root / generator).is_file():
            problems.append(f"generator is missing: {generator}")
        elif generator not in tracked:
            problems.append(f"generator is not tracked: {generator}")

    collisions = collision_paths(root, FINAL_NAMESPACE)
    for collision in collisions:
        problems.append(f"target namespace collision: {collision}")

    facts.append(f"status=pending modules={family_total} families={len(families)}")
    facts.append(f"legacy_imports={len(imports)} nucleus_used=false")
    facts.append(f"local_groups={len(local_groups)} downstream_families={len(downstream)}")
    facts.append(f"tracked_generators={len(generators)} target_collisions={len(collisions)}")
    return problems, facts


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=REPOSITORY_ROOT)
    parser.add_argument("--config", type=Path, default=DEFAULT_CONFIG)
    args = parser.parse_args()
    problems, facts = audit(args.root.resolve(), args.config.resolve())
    for fact in facts:
        print(f"FACT {fact}")
    for problem in problems:
        print(f"ERROR {problem}")
    return 1 if problems else 0


if __name__ == "__main__":
    raise SystemExit(main())
