#!/usr/bin/env python3
"""Rank Lean modules by what a change to them forces to rebuild.

Two different questions get confused when a build is slow. "How many modules import this?" is a
counting question about the import graph. "How long does touching this cost?" is a resource question.
This tool answers the first exactly and is explicit that it cannot yet answer the second.

The blast radius is exact: the transitive reverse closure over the project-local import DAG, computed
from tracked source headers. If a module is in `radius M`, editing `M` invalidates it.

The cost side is deliberately unfinished, and the reason is recorded rather than papered over. The
build queue's telemetry measures a *target closure* — `wall_clock` for `X.All` covers building every
not-yet-current module beneath it — while a per-module unit cost is what a blast-radius sum needs.
Treating one as the other would multiply-count the same elaboration across thousands of dependents.
So the cost columns here are unvalidated size proxies, labelled as such, and `cost-model` reports
exactly why no validation is currently possible. See the C162 report for what instrumentation would
close the gap.

    lean/scripts/lean-blast-radius.py hubs --top 15
    lean/scripts/lean-blast-radius.py radius RelativeConicArcs.Plane
    lean/scripts/lean-blast-radius.py closure FiniteGeom ProjectiveCap.Mirror
    lean/scripts/lean-blast-radius.py targets
    lean/scripts/lean-blast-radius.py cost-model

Every mode is read-only: it parses tracked source headers, stats build outputs, and reads the build
queue's telemetry cache. It never invokes Lake, Lean, or the build queue.
"""

from __future__ import annotations

import argparse
import glob
import hashlib
import importlib.util
import json
import os
import re
import statistics
import sys
import tempfile
from collections import deque
from dataclasses import dataclass
from pathlib import Path
from typing import Any

LEAN_ROOT_DEFAULT = Path(__file__).resolve().parents[1]
OLEAN_SUBDIR = Path(".lake") / "build" / "lib" / "lean"
TELEMETRY_DEFAULT = Path.home() / ".cache" / "othello-lean-build"

EXIT_OK = 0
EXIT_REFUSED = 2

# GNU time's elapsed field, as the build queue records it: [H:]M:SS[.ss].
WALL_CLOCK_RE = re.compile(r"^(?:(\d+):)?(\d+):(\d+(?:\.\d+)?)$")

# Both are proxies for per-module elaboration cost and neither is validated; see `cost-model`.
PROXY_UNITS = {"olean": "bytes", "source": "bytes"}


class Refused(Exception):
    """A precondition failed; nothing was computed."""


def load_spine_module(lean_root: Path) -> Any:
    """Reuse the trust spine's source scanner rather than re-parsing Lean imports.

    Two import parsers in one repository would drift, and this one is already adversarially tested
    against docstrings and string literals that mention the word `import`.
    """
    path = lean_root / "scripts" / "lean-trust-spine.py"
    if not path.is_file():
        raise Refused(f"{path} is missing; this tool reads its source scanner")
    spec = importlib.util.spec_from_file_location("lean_trust_spine", path)
    if spec is None or spec.loader is None:
        raise Refused(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules["lean_trust_spine"] = module
    spec.loader.exec_module(module)
    return module


# --------------------------------------------------------------------------------------------
# graph


@dataclass
class Graph:
    modules: tuple[str, ...]
    index: dict[str, int]
    imports: dict[str, tuple[str, ...]]  # project-local only
    external_imports: dict[str, tuple[str, ...]]
    importers: dict[str, tuple[str, ...]]
    order: tuple[str, ...]  # topological: a module follows everything it imports
    relpath: dict[str, str]
    source_sha256: dict[str, str | None]
    source_bytes: dict[str, int | None]


def build_graph(lean_root: Path, spine: Any) -> Graph:
    registry = spine.load_registry(lean_root / "trust")
    inventory = spine.scan_sources(lean_root, registry)
    modules = tuple(sorted(source.module for source in inventory.files))
    project = set(modules)
    relpath = {source.module: source.relpath for source in inventory.files}
    imports = {
        source.module: tuple(sorted({i for i in source.imports if i in project}))
        for source in inventory.files
    }
    external_imports = {
        source.module: tuple(sorted({i for i in source.imports if i not in project}))
        for source in inventory.files
    }
    importers: dict[str, list[str]] = {module: [] for module in modules}
    for module, deps in imports.items():
        for dep in deps:
            importers[dep].append(module)

    indegree = {module: len(imports.get(module, ())) for module in modules}
    queue = deque(sorted(m for m in modules if indegree[m] == 0))
    order: list[str] = []
    while queue:
        module = queue.popleft()
        order.append(module)
        for importer in sorted(importers[module]):
            indegree[importer] -= 1
            if indegree[importer] == 0:
                queue.append(importer)
    if len(order) != len(modules):
        # Lean rejects import cycles, so this means the scan disagrees with what Lake would accept.
        stuck = sorted(set(modules) - set(order))
        raise Refused(
            f"the project-local import graph is cyclic across {len(stuck)} module(s), starting at "
            f"{stuck[0]}; Lean would reject this, so the scan and the tree disagree"
        )
    return Graph(
        modules=modules,
        index={module: i for i, module in enumerate(modules)},
        imports=imports,
        external_imports=external_imports,
        importers={k: tuple(sorted(v)) for k, v in importers.items()},
        order=tuple(order),
        relpath=relpath,
        source_sha256={source.module: getattr(source, "sha256", None) for source in inventory.files},
        source_bytes={source.module: getattr(source, "size", None) for source in inventory.files},
    )


def reverse_closures(graph: Graph) -> dict[str, int]:
    """Transitive dependents of every module, as a bitset per module.

    Processing in reverse topological order means every importer of a module is already solved when
    that module is reached, so each edge is relaxed once.  Bitsets make the union exact and cheap;
    an explicit set per module would allocate the same information hundreds of times over.
    """
    closures: dict[str, int] = {}
    for module in reversed(graph.order):
        bits = 0
        for importer in graph.importers[module]:
            bits |= closures[importer] | (1 << graph.index[importer])
        closures[module] = bits
    return closures


def bits_to_modules(graph: Graph, bits: int) -> list[str]:
    out = []
    while bits:
        low = bits & -bits
        out.append(graph.modules[low.bit_length() - 1])
        bits ^= low
    return out


def source_closure(graph: Graph, roots: list[str]) -> list[str]:
    """Return roots and every project-local module they transitively import."""
    unknown = sorted(set(roots) - set(graph.index))
    if unknown:
        raise Refused(f"{unknown[0]} is not a project-local module")
    seen: set[str] = set()
    pending = list(reversed(roots))
    while pending:
        module = pending.pop()
        if module in seen:
            continue
        seen.add(module)
        pending.extend(reversed(graph.imports[module]))
    return [module for module in graph.order if module in seen]


def source_inventory(lean_root: Path, graph: Graph, roots: list[str]) -> dict[str, Any]:
    """Build a content-addressed, repository-relative inventory for a source closure."""
    modules = source_closure(graph, roots)
    sources = []
    for module in modules:
        relpath = graph.relpath[module]
        path = lean_root / relpath
        if path.is_symlink() or not path.is_file():
            raise Refused(f"{relpath} is not a regular non-symlink source file")
        resolved = path.resolve()
        if not resolved.is_relative_to(lean_root):
            raise Refused(f"{relpath} escapes the Lean source root")
        payload = path.read_bytes()
        digest = hashlib.sha256(payload).hexdigest()
        if graph.source_sha256[module] is not None and (
            digest != graph.source_sha256[module] or len(payload) != graph.source_bytes[module]
        ):
            raise Refused(f"{relpath} changed while its import closure was being inventoried")
        sources.append(
            {
                "module": module,
                "path": relpath,
                "bytes": len(payload),
                "sha256": digest,
            }
        )
    external_imports = sorted(
        {dependency for module in modules for dependency in graph.external_imports[module]}
    )
    return {
        "schema_version": 1,
        "roots": roots,
        "module_count": len(modules),
        "sources": sorted(sources, key=lambda source: source["path"]),
        "external_imports": external_imports,
    }


def write_json_atomic(destination: Path, payload: dict[str, Any], replace: bool) -> None:
    """Write deterministic JSON without exposing a partial manifest."""
    if destination.exists() and not replace:
        raise Refused(f"{destination} already exists; pass --replace to update it")
    if destination.is_symlink():
        raise Refused(f"{destination} is a symlink")
    if not destination.parent.is_dir():
        raise Refused(f"{destination.parent} is not an existing directory")
    rendered = json.dumps(payload, indent=2, sort_keys=True) + "\n"
    temporary: Path | None = None
    try:
        with tempfile.NamedTemporaryFile(
            mode="w",
            encoding="utf-8",
            dir=destination.parent,
            prefix=f".{destination.name}.",
            delete=False,
        ) as handle:
            handle.write(rendered)
            temporary = Path(handle.name)
        os.replace(temporary, destination)
    finally:
        if temporary is not None and temporary.exists():
            temporary.unlink()


# --------------------------------------------------------------------------------------------
# cost proxies and the telemetry that does not substitute for them


def parse_wall_clock(value: str) -> float | None:
    match = WALL_CLOCK_RE.match(value.strip())
    if not match:
        return None
    hours, minutes, seconds = match.groups()
    return (int(hours or 0) * 3600) + (int(minutes) * 60) + float(seconds)


def load_target_builds(telemetry_root: Path) -> dict[str, float]:
    """Median measured wall-clock seconds per *target*, from the build queue's run cache.

    This is closure-level, not per-module: building `X.All` builds everything beneath it that was not
    already trace-current, so the number depends on both the closure and the cache state at the time.
    It is reported by `targets` and is deliberately not used as a per-module unit cost.

    The cache is host-local and prunable, so anything citing it must say so rather than presenting it
    as a tracked artifact.
    """
    samples: dict[str, list[float]] = {}
    if not telemetry_root.is_dir():
        return {}
    for path in sorted(glob.glob(str(telemetry_root / "run-*" / "status.json"))):
        try:
            with open(path, "rb") as handle:
                doc = json.load(handle)
        except (OSError, json.JSONDecodeError):
            continue  # a partial or truncated run record is not evidence of anything
        for result in doc.get("results") or []:
            if not isinstance(result, dict) or result.get("outcome") != "built":
                continue
            target, wall = result.get("target"), result.get("wall_clock")
            if not isinstance(target, str) or not isinstance(wall, str):
                continue
            seconds = parse_wall_clock(wall)
            if seconds is not None:
                samples.setdefault(target, []).append(seconds)
    return {target: statistics.median(values) for target, values in sorted(samples.items())}


def olean_bytes(lean_root: Path, module: str) -> int | None:
    path = lean_root / OLEAN_SUBDIR / Path(*module.split(".")).with_suffix(".olean")
    try:
        return path.stat().st_size
    except OSError:
        return None


def source_bytes(lean_root: Path, graph: Graph, module: str) -> int | None:
    try:
        return (lean_root / graph.relpath[module]).stat().st_size
    except (OSError, KeyError):
        return None


@dataclass
class CostModel:
    kind: str
    unit: str
    cost: dict[str, float]
    provenance: dict[str, str]

    def coverage(self) -> dict[str, int]:
        counts: dict[str, int] = {}
        for kind in self.provenance.values():
            counts[kind] = counts.get(kind, 0) + 1
        return dict(sorted(counts.items()))


def build_cost_model(lean_root: Path, graph: Graph, kind: str, _telemetry: Path) -> CostModel:
    """Per-module proxy cost, with the provenance of every value retained.

    A module with no available value gets zero rather than an invented estimate, and is labelled
    `absent` so a caller can report how much of a ranking rests on nothing.
    """
    if kind not in PROXY_UNITS:
        raise Refused(f"unknown cost proxy {kind!r}; choose from {', '.join(sorted(PROXY_UNITS))}")
    cost: dict[str, float] = {}
    provenance: dict[str, str] = {}
    for module in graph.modules:
        raw = olean_bytes(lean_root, module) if kind == "olean" else source_bytes(lean_root, graph, module)
        cost[module] = float(raw) if raw is not None else 0.0
        provenance[module] = kind if raw is not None else "absent"
    return CostModel(kind=kind, unit=PROXY_UNITS[kind], cost=cost, provenance=provenance)


def rebuild_cost(graph: Graph, closures: dict[str, int], model: CostModel, module: str) -> float:
    """Proxy cost of the module itself plus everything that transitively imports it."""
    total = model.cost.get(module, 0.0)
    for dependent in bits_to_modules(graph, closures[module]):
        total += model.cost.get(dependent, 0.0)
    return total


def cost_model_report(lean_root: Path, graph: Graph, telemetry_root: Path) -> dict[str, Any]:
    """Why the proxies are unvalidated, with the evidence that shows the mismatch.

    The natural validation — correlate a proxy against measured build times — cannot be run, because
    the two quantities are not commensurable. The clearest evidence is the set of targets whose
    measured time is enormous while their own olean is tiny: those are aggregators whose time belongs
    to a closure of thousands of generated leaves, not to their own elaboration.
    """
    measured = load_target_builds(telemetry_root)
    rows = []
    for target, seconds in measured.items():
        size = olean_bytes(lean_root, target)
        rows.append(
            {
                "target": target,
                "seconds": seconds,
                "own_olean_bytes": size,
                "in_graph": target in graph.index,
                "dependents_of_target": None,
            }
        )
    aggregators = [
        row
        for row in rows
        if row["own_olean_bytes"] is not None
        and row["seconds"] >= 600
        and row["own_olean_bytes"] <= 64 * 1024
    ]
    return {
        "measured_targets": len(measured),
        "per_module_measurements": 0,
        "validation_possible": False,
        "reason": (
            "telemetry records target-closure build time, not per-module elaboration time; a "
            "blast-radius sum needs the latter"
        ),
        "closure_confound_examples": sorted(
            aggregators, key=lambda r: -r["seconds"]
        )[:5],
    }


# --------------------------------------------------------------------------------------------
# commands


def _context(args: argparse.Namespace) -> tuple[Path, Graph, dict[str, int], CostModel]:
    lean_root = Path(args.lean_root).resolve()
    spine = load_spine_module(lean_root)
    graph = build_graph(lean_root, spine)
    closures = reverse_closures(graph)
    model = build_cost_model(lean_root, graph, args.cost, Path(args.telemetry).resolve())
    return lean_root, graph, closures, model


def cmd_hubs(args: argparse.Namespace) -> int:
    _, graph, closures, model = _context(args)
    rows = []
    for module in graph.modules:
        dependents = closures[module].bit_count()
        if dependents < args.min_dependents:
            continue
        rows.append(
            {
                "module": module,
                "dependents": dependents,
                "direct_importers": len(graph.importers[module]),
                "proxy_rebuild_cost": rebuild_cost(graph, closures, model, module),
                "cost_provenance": model.provenance[module],
            }
        )
    by_count = sorted(rows, key=lambda r: (-r["dependents"], r["module"]))[: args.top]
    by_cost = sorted(rows, key=lambda r: (-r["proxy_rebuild_cost"], r["module"]))[: args.top]

    if args.json and args.graph_only:
        # Only graph-derived fields, so the output reproduces from tracked sources alone.  The cost
        # proxies read local build outputs, which no clean checkout would reproduce.
        print(
            json.dumps(
                {
                    "schema": "blast-radius-graph/1",
                    "modules": len(graph.modules),
                    "project_local_edges": sum(len(v) for v in graph.imports.values()),
                    "ranked_by_dependents": [
                        {
                            "module": row["module"],
                            "dependents": row["dependents"],
                            "direct_importers": row["direct_importers"],
                        }
                        for row in by_count
                    ],
                },
                indent=2,
                sort_keys=True,
            )
        )
        return EXIT_OK

    if args.json:
        print(
            json.dumps(
                {
                    "modules": len(graph.modules),
                    "cost_proxy": model.kind,
                    "cost_unit": model.unit,
                    "cost_is_validated": False,
                    "ranked_by_dependents": by_count,
                    "ranked_by_proxy_cost": by_cost,
                    "cost_coverage": model.coverage(),
                },
                indent=2,
                sort_keys=True,
            )
        )
        return EXIT_OK

    total = len(graph.modules)
    print(f"{total} project modules; blast radius is exact, cost column is an unvalidated proxy")
    print(f"cost proxy: {model.kind} ({model.unit}); coverage {model.coverage()}")
    print(f"\ntop {len(by_count)} by transitive dependents:")
    print(f"  {'dependents':>10}  {'%of tree':>8}  {'direct':>7}  module")
    for row in by_count:
        share = 100.0 * row["dependents"] / total
        print(f"  {row['dependents']:>10}  {share:>7.1f}%  {row['direct_importers']:>7}  {row['module']}")

    count_set = {row["module"] for row in by_count}
    divergent = [row for row in by_cost if row["module"] not in count_set]
    print(f"\nranked high by the {model.kind} proxy but not by dependent count ({len(divergent)}):")
    for row in divergent[: args.top]:
        print(f"  {row['dependents']:>10}  {'':>8}  {row['proxy_rebuild_cost']:>14,.0f}  {row['module']}")
    if not divergent:
        print("  none — the two orderings select the same modules at this depth")
    return EXIT_OK


def cmd_radius(args: argparse.Namespace) -> int:
    _, graph, closures, model = _context(args)
    if args.module not in graph.index:
        raise Refused(f"{args.module} is not a project-local module")
    dependents = bits_to_modules(graph, closures[args.module])
    cost = rebuild_cost(graph, closures, model, args.module)
    if args.json:
        print(
            json.dumps(
                {
                    "module": args.module,
                    "direct_importers": list(graph.importers[args.module]),
                    "dependents": sorted(dependents),
                    "dependent_count": len(dependents),
                    "proxy_rebuild_cost": cost,
                    "cost_proxy": model.kind,
                    "cost_unit": model.unit,
                    "cost_is_validated": False,
                },
                indent=2,
                sort_keys=True,
            )
        )
        return EXIT_OK
    total = len(graph.modules)
    print(f"{args.module}")
    print(f"  direct importers: {len(graph.importers[args.module])}")
    print(f"  transitive dependents: {len(dependents)} of {total} ({100.0*len(dependents)/total:.1f}%)")
    print(f"  proxy rebuild cost: {cost:,.0f} {model.unit} ({model.kind}; unvalidated)")
    shown = sorted(dependents)[: args.top]
    if shown:
        print(f"  first {len(shown)} dependents:")
        for module in shown:
            print(f"    {module}")
        if len(dependents) > len(shown):
            print(f"    ... and {len(dependents) - len(shown)} more")
    return EXIT_OK


def cmd_closure(args: argparse.Namespace) -> int:
    lean_root = Path(args.lean_root).resolve()
    graph = build_graph(lean_root, load_spine_module(lean_root))
    inventory = source_inventory(lean_root, graph, args.modules)
    sources = inventory["sources"]
    paths = [source["path"] for source in sources]
    external_imports = inventory["external_imports"]
    if args.replace and args.output is None:
        raise Refused("--replace requires --output")
    if args.output is not None:
        destination = Path(args.output).resolve()
        write_json_atomic(destination, inventory, args.replace)
        print(f"wrote {inventory['module_count']} source(s) to {destination}")
        return EXIT_OK
    if args.json:
        print(json.dumps(inventory, indent=2, sort_keys=True))
        return EXIT_OK
    print(f"roots: {', '.join(args.modules)}")
    print(f"project-local source closure: {inventory['module_count']} module(s)")
    print(f"external imports: {len(external_imports)}")
    shown = sources[: args.top]
    for source in shown:
        print(f"  {source['module']}: {source['path']}")
    if len(sources) > len(shown):
        print(f"  ... and {len(sources) - len(shown)} more")
    return EXIT_OK


def cmd_targets(args: argparse.Namespace) -> int:
    """Measured build times for whole targets — closure-level, which is what they actually are."""
    lean_root = Path(args.lean_root).resolve()
    spine = load_spine_module(lean_root)
    graph = build_graph(lean_root, spine)
    measured = load_target_builds(Path(args.telemetry).resolve())
    inventory = spine.scan_sources(lean_root, spine.load_registry(lean_root / "trust"))
    rows = [
        {
            "target": target,
            "seconds": seconds,
            "own_olean_bytes": olean_bytes(lean_root, target),
            "forward_closure": (
                len(spine.source_closure(inventory, [target])) if target in graph.index else None
            ),
        }
        for target, seconds in measured.items()
    ]
    rows.sort(key=lambda r: -r["seconds"])
    if args.json:
        print(json.dumps({"targets": rows, "note": "closure-level, host-local cache"}, indent=2, sort_keys=True))
        return EXIT_OK
    print(f"{len(rows)} measured targets (median wall-clock; host-local cache, closure-level)")
    print(f"  {'seconds':>9}  {'own olean':>10}  {'closure':>8}  target")
    for row in rows[: args.top]:
        size = f"{row['own_olean_bytes']:,}" if row["own_olean_bytes"] is not None else "-"
        closure = row["forward_closure"] if row["forward_closure"] is not None else "-"
        print(f"  {row['seconds']:>9,.1f}  {size:>10}  {closure:>8}  {row['target']}")
    if len(rows) > args.top:
        print(f"  ... and {len(rows) - args.top} more")
    return EXIT_OK


def cmd_cost_model(args: argparse.Namespace) -> int:
    lean_root = Path(args.lean_root).resolve()
    spine = load_spine_module(lean_root)
    graph = build_graph(lean_root, spine)
    telemetry = Path(args.telemetry).resolve()
    report = cost_model_report(lean_root, graph, telemetry)
    coverage = {
        kind: build_cost_model(lean_root, graph, kind, telemetry).coverage()
        for kind in sorted(PROXY_UNITS)
    }
    if args.json:
        print(json.dumps({"report": report, "coverage": coverage}, indent=2, sort_keys=True))
        return EXIT_OK
    print(f"modules: {len(graph.modules)}")
    for kind in sorted(coverage):
        print(f"  {kind:7} proxy coverage: {coverage[kind]}")
    print(f"\nper-module cost measurements available: {report['per_module_measurements']}")
    print(f"measured targets in telemetry: {report['measured_targets']} (closure-level)")
    print(f"proxy validation possible: {report['validation_possible']}")
    print(f"  reason: {report['reason']}")
    if report["closure_confound_examples"]:
        print("\n  aggregators whose measured time belongs to their closure, not themselves:")
        for row in report["closure_confound_examples"]:
            print(f"    {row['seconds']:>9,.1f}s  own olean {row['own_olean_bytes']:>8,}B  {row['target']}")
    return EXIT_OK


def build_parser() -> argparse.ArgumentParser:
    # Shared options live on a parent parser so they may be written after the subcommand, which is
    # where anyone would naturally put them.
    common = argparse.ArgumentParser(add_help=False)
    common.add_argument("--lean-root", default=str(LEAN_ROOT_DEFAULT))
    common.add_argument("--telemetry", default=str(TELEMETRY_DEFAULT))
    common.add_argument("--cost", default="olean", choices=sorted(PROXY_UNITS))
    common.add_argument("--json", action="store_true")

    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0], parents=[common])
    sub = parser.add_subparsers(dest="command", required=True)

    hubs = sub.add_parser("hubs", parents=[common], help="rank modules by rebuild blast radius")
    hubs.add_argument("--top", type=int, default=15)
    hubs.add_argument("--min-dependents", type=int, default=1)
    hubs.add_argument(
        "--graph-only",
        action="store_true",
        help="with --json, emit only graph-derived fields, which reproduce from tracked sources",
    )
    hubs.set_defaults(func=cmd_hubs)

    radius = sub.add_parser("radius", parents=[common], help="what a change to one module forces to rebuild")
    radius.add_argument("module")
    radius.add_argument("--top", type=int, default=15)
    radius.set_defaults(func=cmd_radius)

    closure = sub.add_parser(
        "closure",
        parents=[common],
        help="exact project-local source closure imported by one or more modules",
    )
    closure.add_argument("modules", nargs="+")
    closure.add_argument("--top", type=int, default=15)
    closure.add_argument("--output", help="atomically write the JSON source inventory")
    closure.add_argument("--replace", action="store_true", help="replace an existing --output file")
    closure.set_defaults(func=cmd_closure)

    targets = sub.add_parser("targets", parents=[common], help="measured closure-level build times per target")
    targets.add_argument("--top", type=int, default=15)
    targets.set_defaults(func=cmd_targets)

    cost = sub.add_parser("cost-model", parents=[common], help="proxy coverage and why validation is unavailable")
    cost.set_defaults(func=cmd_cost_model)

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
