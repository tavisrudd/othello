#!/usr/bin/env python3
"""Tests for lean-blast-radius.py.

Fully hermetic: graph fixtures are built in memory and telemetry fixtures are throwaway directories,
so the suite never reads the real Lean tree, never stats the real build output, and never builds.
Run:

    python3 lean/scripts/test_lean_blast_radius.py

The reverse closure is the load-bearing computation — every claim the tool makes about what a change
invalidates rests on it — so it is checked against hand-computed answers on graphs whose shape is
chosen to break a wrong implementation: a diamond that double-counts under naive summation, a chain
that a one-hop implementation truncates, and a disconnected component that must not leak in.
"""

from __future__ import annotations

import importlib.util
import json
import sys
import tempfile
import unittest
from pathlib import Path

SCRIPT = Path(__file__).resolve().parent / "lean-blast-radius.py"


def _load_module():
    spec = importlib.util.spec_from_file_location("lean_blast_radius", SCRIPT)
    module = importlib.util.module_from_spec(spec)
    sys.modules["lean_blast_radius"] = module
    spec.loader.exec_module(module)
    return module


br = _load_module()


class StubSource:
    def __init__(self, module, imports, relpath):
        self.module = module
        self.imports = imports
        self.relpath = relpath


class StubInventory:
    def __init__(self, files):
        self.files = files


class StubSpine:
    """Stands in for lean-trust-spine.py so graph tests need no registry or Lean tree."""

    def __init__(self, graph_spec):
        self.graph_spec = graph_spec

    def load_registry(self, _trust_dir):
        return object()

    def scan_sources(self, _lean_root, _registry):
        return StubInventory(
            [
                StubSource(module, list(imports), f"Fixture/{module.replace('.', '/')}.lean")
                for module, imports in self.graph_spec.items()
            ]
        )


def make_graph(spec):
    return br.build_graph(Path("/nonexistent"), StubSpine(spec))


# A diamond: D imports B and C, both import A.  A naive sum over paths counts D twice.
DIAMOND = {"A": [], "B": ["A"], "C": ["A"], "D": ["B", "C"]}
# A chain plus an unrelated component that must never appear in the first component's closure.
CHAIN = {"L0": [], "L1": ["L0"], "L2": ["L1"], "L3": ["L2"], "Sep": []}


class GraphTests(unittest.TestCase):
    def test_topological_order_places_imports_first(self):
        graph = make_graph(DIAMOND)
        position = {module: i for i, module in enumerate(graph.order)}
        for module, imports in graph.imports.items():
            for dependency in imports:
                self.assertLess(position[dependency], position[module])

    def test_importers_are_the_reverse_of_imports(self):
        graph = make_graph(DIAMOND)
        self.assertEqual(graph.importers["A"], ("B", "C"))
        self.assertEqual(graph.importers["D"], ())

    def test_external_imports_are_dropped(self):
        graph = make_graph({"A": ["Mathlib.Data.Nat", "Init.Core"], "B": ["A"]})
        self.assertEqual(graph.imports["A"], ())
        self.assertEqual(graph.imports["B"], ("A",))
        self.assertEqual(graph.external_imports["A"], ("Init.Core", "Mathlib.Data.Nat"))
        self.assertEqual(graph.external_imports["B"], ())

    def test_cycle_is_refused(self):
        with self.assertRaises(br.Refused) as caught:
            make_graph({"A": ["B"], "B": ["A"]})
        self.assertIn("cyclic", str(caught.exception))


class ClosureTests(unittest.TestCase):
    def _dependents(self, spec, module):
        graph = make_graph(spec)
        closures = br.reverse_closures(graph)
        return sorted(br.bits_to_modules(graph, closures[module]))

    def test_diamond_counts_each_dependent_once(self):
        self.assertEqual(self._dependents(DIAMOND, "A"), ["B", "C", "D"])

    def test_leaf_has_no_dependents(self):
        self.assertEqual(self._dependents(DIAMOND, "D"), [])

    def test_chain_is_fully_transitive(self):
        self.assertEqual(self._dependents(CHAIN, "L0"), ["L1", "L2", "L3"])
        self.assertEqual(self._dependents(CHAIN, "L2"), ["L3"])

    def test_separate_component_does_not_leak(self):
        self.assertEqual(self._dependents(CHAIN, "Sep"), [])
        self.assertNotIn("Sep", self._dependents(CHAIN, "L0"))

    def test_bits_round_trip_every_module(self):
        graph = make_graph(DIAMOND)
        everything = (1 << len(graph.modules)) - 1
        self.assertEqual(sorted(br.bits_to_modules(graph, everything)), list(graph.modules))


class SourceClosureTests(unittest.TestCase):
    def test_diamond_includes_each_import_once(self):
        graph = make_graph(DIAMOND)
        self.assertEqual(br.source_closure(graph, ["D"]), ["A", "B", "C", "D"])

    def test_union_of_roots_is_reverse_complete(self):
        graph = make_graph(CHAIN)
        self.assertEqual(br.source_closure(graph, ["L2", "Sep"]), ["L0", "Sep", "L1", "L2"])

    def test_root_without_project_imports_is_included(self):
        graph = make_graph(CHAIN)
        self.assertEqual(br.source_closure(graph, ["Sep"]), ["Sep"])

    def test_unknown_root_is_refused(self):
        graph = make_graph(CHAIN)
        with self.assertRaisesRegex(br.Refused, "Missing is not a project-local module"):
            br.source_closure(graph, ["Missing"])

    def test_inventory_hashes_regular_sources_and_classifies_external_imports(self):
        graph = make_graph({"A": ["Mathlib.Data.Nat"], "B": ["A"]})
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            for module in graph.modules:
                path = root / graph.relpath[module]
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_text(f"-- {module}\n", encoding="utf-8")
            inventory = br.source_inventory(root, graph, ["B"])
        self.assertEqual(inventory["module_count"], 2)
        self.assertEqual(inventory["external_imports"], ["Mathlib.Data.Nat"])
        self.assertEqual([source["path"] for source in inventory["sources"]], [
            "Fixture/A.lean",
            "Fixture/B.lean",
        ])
        self.assertTrue(all(len(source["sha256"]) == 64 for source in inventory["sources"]))

    def test_inventory_refuses_symlinked_source(self):
        graph = make_graph({"A": []})
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            path = root / graph.relpath["A"]
            path.parent.mkdir(parents=True)
            target = root / "target.lean"
            target.write_text("-- target\n", encoding="utf-8")
            path.symlink_to(target)
            with self.assertRaisesRegex(br.Refused, "non-symlink"):
                br.source_inventory(root, graph, ["A"])

    def test_inventory_refuses_source_changed_after_graph_scan(self):
        graph = make_graph({"A": []})
        graph.source_sha256["A"] = "0" * 64
        graph.source_bytes["A"] = 0
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            path = root / graph.relpath["A"]
            path.parent.mkdir(parents=True)
            path.write_text("-- changed\n", encoding="utf-8")
            with self.assertRaisesRegex(br.Refused, "changed while"):
                br.source_inventory(root, graph, ["A"])

    def test_atomic_json_writer_refuses_implicit_overwrite(self):
        with tempfile.TemporaryDirectory() as tmp:
            destination = Path(tmp) / "manifest.json"
            br.write_json_atomic(destination, {"version": 1}, replace=False)
            with self.assertRaisesRegex(br.Refused, "pass --replace"):
                br.write_json_atomic(destination, {"version": 2}, replace=False)
            br.write_json_atomic(destination, {"version": 2}, replace=True)
            self.assertEqual(json.loads(destination.read_text()), {"version": 2})


class CostTests(unittest.TestCase):
    def setUp(self):
        self.graph = make_graph(DIAMOND)
        self.closures = br.reverse_closures(self.graph)

    def _model(self, costs, provenance="olean"):
        return br.CostModel(
            kind=provenance,
            unit="bytes",
            cost=costs,
            provenance={m: provenance for m in self.graph.modules},
        )

    def test_rebuild_cost_includes_self_and_closure(self):
        model = self._model({"A": 1.0, "B": 10.0, "C": 100.0, "D": 1000.0})
        self.assertEqual(br.rebuild_cost(self.graph, self.closures, model, "A"), 1111.0)
        self.assertEqual(br.rebuild_cost(self.graph, self.closures, model, "D"), 1000.0)

    def test_diamond_does_not_double_count_shared_dependent(self):
        model = self._model({"A": 0.0, "B": 0.0, "C": 0.0, "D": 7.0})
        # D is reachable from A through both B and C; it must contribute once.
        self.assertEqual(br.rebuild_cost(self.graph, self.closures, model, "A"), 7.0)

    def test_unknown_proxy_is_refused(self):
        with self.assertRaises(br.Refused):
            br.build_cost_model(Path("/nonexistent"), self.graph, "vibes", Path("/nonexistent"))

    def test_absent_costs_are_labelled_not_guessed(self):
        model = br.build_cost_model(Path("/nonexistent"), self.graph, "olean", Path("/nonexistent"))
        self.assertEqual(model.coverage(), {"absent": 4})
        self.assertEqual(set(model.cost.values()), {0.0})


class WallClockTests(unittest.TestCase):
    def test_parses_minutes_and_seconds(self):
        self.assertAlmostEqual(br.parse_wall_clock("0:22.37"), 22.37)
        self.assertAlmostEqual(br.parse_wall_clock("4:30.00"), 270.0)

    def test_parses_hours(self):
        self.assertAlmostEqual(br.parse_wall_clock("2:04:30.5"), 7470.5)

    def test_rejects_junk(self):
        for value in ["", "later", "22", "1:2:3:4", "-1:00"]:
            self.assertIsNone(br.parse_wall_clock(value), value)


class TelemetryTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.root = Path(self.tmp.name)
        self.addCleanup(self.tmp.cleanup)

    def _run(self, name, results):
        directory = self.root / f"run-{name}"
        directory.mkdir()
        (directory / "status.json").write_text(json.dumps({"results": results}), encoding="utf-8")

    def test_takes_median_across_runs(self):
        self._run("a", [{"target": "X", "outcome": "built", "wall_clock": "0:10.00"}])
        self._run("b", [{"target": "X", "outcome": "built", "wall_clock": "0:20.00"}])
        self._run("c", [{"target": "X", "outcome": "built", "wall_clock": "0:60.00"}])
        self.assertAlmostEqual(br.load_target_builds(self.root)["X"], 20.0)

    def test_ignores_targets_that_were_not_built(self):
        self._run("a", [{"target": "X", "outcome": "skipped-current", "wall_clock": "0:10.00"}])
        self.assertEqual(br.load_target_builds(self.root), {})

    def test_survives_a_truncated_run_record(self):
        self._run("a", [{"target": "X", "outcome": "built", "wall_clock": "0:10.00"}])
        bad = self.root / "run-bad"
        bad.mkdir()
        (bad / "status.json").write_text("{not json", encoding="utf-8")
        self.assertEqual(sorted(br.load_target_builds(self.root)), ["X"])

    def test_missing_telemetry_root_is_empty_not_an_error(self):
        self.assertEqual(br.load_target_builds(self.root / "absent"), {})

    def test_unparseable_wall_clock_is_dropped(self):
        self._run("a", [{"target": "X", "outcome": "built", "wall_clock": "ages"}])
        self.assertEqual(br.load_target_builds(self.root), {})


class ReportTests(unittest.TestCase):
    def test_cost_model_report_states_validation_is_impossible(self):
        graph = make_graph(DIAMOND)
        with tempfile.TemporaryDirectory() as tmp:
            report = br.cost_model_report(Path("/nonexistent"), graph, Path(tmp))
        # The tool must never claim a validated cost model while telemetry is closure-level.
        self.assertFalse(report["validation_possible"])
        self.assertEqual(report["per_module_measurements"], 0)


if __name__ == "__main__":
    unittest.main(verbosity=1)
