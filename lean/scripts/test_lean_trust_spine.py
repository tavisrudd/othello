#!/usr/bin/env python3
"""Tests for lean-trust-spine.py.

Fully hermetic: every fixture is a throwaway git repository holding a handful of tiny `.lean` files,
so the suite never reads the real Lean tree, never elaborates anything, and never builds.  Run:

    python3 lean/scripts/test_lean_trust_spine.py

The point of most of these tests is not that the tool succeeds.  It is that the tool *fails* when a
declaration and the tree disagree — a checker that cannot be made to go red is not evidence of
anything.  Each adversarial case therefore starts from a green fixture, breaks exactly one thing,
and asserts the specific code that fires.
"""

from __future__ import annotations

import hashlib
import importlib.util
import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

SCRIPT = Path(__file__).resolve().parent / "lean-trust-spine.py"


def _load_module():
    spec = importlib.util.spec_from_file_location("lean_trust_spine", SCRIPT)
    module = importlib.util.module_from_spec(spec)
    # dataclasses resolves annotations through sys.modules; a bare exec_module leaves it unset.
    sys.modules["lean_trust_spine"] = module
    spec.loader.exec_module(module)
    return module


ts = _load_module()


LAKEFILE = """\
name = "Fixture"

[[lean_lib]]
name = "Alpha"

[[lean_lib]]
name = "Beta"
"""

PORTFOLIO = """\
schema_version = 1

[portfolio]
libraries = ["Alpha", "Beta"]
non_source_dirs = [".lake", "trust"]

[[area]]
name = "alpha"
spine = "areas/alpha.toml"

[[unaudited_library]]
library = "Beta"
reason = "no spine yet"

[[generated_doc]]
path = "trust/DOC.md"
area = "alpha"
section = "gates"
"""

SPINE = """\
schema_version = 1
area = "alpha"
manifest = "Alpha/TRUST.md"
owns = ["Alpha", "Alpha.**"]
permitted_axioms = ["Alpha.Known.permitted_axiom"]

[[gate]]
module = "Alpha.Gate"
terminals = ["Alpha.Main.terminal"]

[[terminal]]
declaration = "Alpha.Main.terminal"
gates = ["Alpha.Gate"]
expected_axioms = ["Classical.choice", "propext"]

[[unreached]]
modules = ["Alpha.Known"]
reason = "holds the permitted axiom and is deliberately outside the gate"

[[data_tree]]
path = "Alpha/Rows"
provenance = "legacy-unverified"
reason = "fixture tree"
members = [
  { glob = "R_[0-9][0-9].lean", role = "leaf" },
  { glob = "All.lean", role = "aggregate" },
]
"""

DOC = """\
# Fixture

<!-- trust-spine:begin area=alpha section=gates version=1 -->
<!-- trust-spine:end area=alpha section=gates -->
"""


class Fixture:
    """A throwaway Lean tree that starts green."""

    def __init__(self, root: Path) -> None:
        self.root = root
        self.write("lakefile.toml", LAKEFILE)
        self.write("trust/portfolio.toml", PORTFOLIO)
        self.write("trust/areas/alpha.toml", SPINE)
        self.write("trust/DOC.md", DOC)
        self.write("Alpha.lean", "import Alpha.Gate\n")
        self.write("Alpha/Gate.lean", "import Alpha.Main\n")
        self.write("Alpha/Main.lean", "import Alpha.Rows.All\n\nnamespace Alpha.Main\nend Alpha.Main\n")
        self.write("Alpha/Rows/All.lean", "import Alpha.Rows.R_00\nimport Alpha.Rows.R_01\n")
        self.write("Alpha/Rows/R_00.lean", "namespace Alpha.Rows\nend Alpha.Rows\n")
        self.write("Alpha/Rows/R_01.lean", "namespace Alpha.Rows\nend Alpha.Rows\n")
        self.write(
            "Alpha/Known.lean",
            "namespace Alpha.Known\naxiom permitted_axiom : True\nend Alpha.Known\n",
        )
        self.write("Beta.lean", "namespace Beta\nend Beta\n")
        self.git("init", "-q")
        self.git("add", "-A")
        self.commit("fixture")

    def write(self, rel: str, text: str) -> None:
        path = self.root / rel
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(text, encoding="utf-8")

    def git(self, *args: str) -> None:
        subprocess.run(["git", *args], cwd=self.root, check=True, capture_output=True)

    def commit(self, message: str) -> None:
        """Commit with identity and signing pinned off.

        The fixture must not inherit the developer's `commit.gpgsign`; a throwaway repo in a temp
        directory has no business invoking a signing key, and doing so would hang or fail the suite
        depending on the agent's configuration.
        """
        self.git(
            "-c",
            "user.email=fixture@example.invalid",
            "-c",
            "user.name=fixture",
            "-c",
            "commit.gpgsign=false",
            "-c",
            "tag.gpgsign=false",
            "commit",
            "--no-gpg-sign",
            "-qm",
            message,
        )

    def track(self, rel: str, text: str) -> None:
        self.write(rel, text)
        self.git("add", rel)

    def run(self, *args: str) -> tuple[int, dict]:
        proc = subprocess.run(
            [sys.executable, str(SCRIPT), "--lean-root", str(self.root), *args],
            capture_output=True,
            text=True,
        )
        if "--json" in args:
            return proc.returncode, json.loads(proc.stdout)
        return proc.returncode, {"stdout": proc.stdout, "stderr": proc.stderr}

    def audit_codes(self) -> set[str]:
        _, doc = self.run("audit", "--json")
        return {f["code"] for f in doc["findings"]}

    def check_codes(self) -> set[str]:
        _, doc = self.run("check", "--json")
        return {f["code"] for f in doc["findings"]}

    def write_facts(self, **overrides) -> None:
        facts = {
            "schema_version": 1,
            "unit": "Alpha.Gate",
            "closure": ["Alpha.Gate", "Alpha.Main", "Alpha.Rows.All"],
            "project_declarations": ["Alpha.Main.terminal"],
            "project_axioms": [],
            "terminal_axioms": {"Alpha.Main.terminal": ["Classical.choice", "propext"]},
            "declaration_module": {"Alpha.Main.terminal": "Alpha.Main"},
            "uses": {},
            "opaque": [],
            "lean_version": "4.32.0-rc1",
            "mathlib_rev": "571b8a8",
            "exporter_sha256": "0" * 64,
        }
        facts.update(overrides)
        self.track("trust/facts/Alpha.Gate.json", json.dumps(facts, indent=2, sort_keys=True) + "\n")

    def write_package(self, *, pin_hash: bool = True, **overrides) -> None:
        """Pin one external certificate package and its published fact."""
        fact = {
            "schema_version": 1,
            "package": "alpha-certificates",
            "repository": "https://example.invalid/alpha-certificates",
            "gate": "Alpha.Gates.CertificateTrust",
            "terminal": "Alpha.Certificates.exact_value",
            "source_commit": "0" * 40,
            "manifest_sha256": "1" * 64,
            "lean_toolchain": "leanprover/lean4:v4.32.0-rc1",
            "dependency": {"repository": "https://example.invalid/base", "commit": "2" * 40},
            "declarations": {
                "Alpha.Certificates.exact_value": {
                    "axioms": ["Classical.choice", "propext"],
                    "module": "Alpha.Certificates.Result",
                    "origin": "package",
                },
                "Alpha.Certificates.rejection_profile": {
                    "axioms": ["propext"],
                    "module": "Alpha.Certificates.Profile",
                    "origin": "package",
                },
                "Base.shared_bound": {
                    "axioms": ["propext"],
                    "module": "Base/Shared.lean",
                    "origin": "dependency",
                },
            },
            "evidence": {
                "axiom_log": "evidence/gate-axioms.log",
                "axiom_log_sha256": "3" * 64,
                "replay": "lake build --no-build Alpha.Gates.CertificateTrust",
            },
        }
        fact.update(overrides)
        payload = json.dumps(fact, indent=2, sort_keys=True) + "\n"
        self.track("trust/external/alpha-certificates.json", payload)
        digest = hashlib.sha256(payload.encode("utf-8")).hexdigest()
        self.track(
            "trust/certificate-packages.toml",
            f'''schema_version = 1

[[package]]
name = "alpha-certificates"
repository = "https://example.invalid/alpha-certificates"
commit = "{"4" * 40}"
manifest_sha256 = "{"1" * 64}"
gate = "Alpha.Gates.CertificateTrust"
terminal = "Alpha.Certificates.exact_value"
trust_fact = "external/alpha-certificates.json"
trust_fact_sha256 = "{digest if pin_hash else "5" * 64}"
owned_module_prefixes = ["Alpha.Certificates"]
forbidden_artifact_basenames = []
''',
        )

    def write_external_input(self, body: str) -> None:
        self.track("trust/areas/alpha.toml", SPINE + body)


class TrustSpineTest(unittest.TestCase):
    def setUp(self) -> None:
        self._tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self._tmp.cleanup)
        self.fx = Fixture(Path(self._tmp.name))

    # -- baseline -----------------------------------------------------------------------------

    def test_green_fixture_has_no_structural_errors(self):
        codes = self.fx.audit_codes()
        self.assertNotIn("unclassified-module", codes)
        self.assertNotIn("data-tree-member-unmatched", codes)
        self.assertNotIn("lakefile-drift", codes)
        # No facts artifact yet, so the gate must be reported as unverified rather than passing.
        self.assertIn("facts-missing", codes)

    def test_missing_facts_is_a_failure_not_a_pass(self):
        code, _ = self.fx.run("audit")
        self.assertEqual(code, ts.EXIT_FINDINGS)

    def test_facts_present_clears_the_gate(self):
        self.fx.write_facts()
        codes = self.fx.audit_codes()
        self.assertNotIn("facts-missing", codes)
        self.assertNotIn("terminal-axiom-mismatch", codes)

    # -- plan test 1: an axiom in a module outside every gate ---------------------------------

    def test_axiom_outside_every_gate_stays_visible_in_the_inventory(self):
        """The Dye case: an axiom in a module no gate reaches must not vanish from the portfolio.

        `Alpha.Known` is declared unreached, so it raises no error.  What must not happen is the
        axiom disappearing along with the finding — the portfolio inventory is the only place a
        reviewer would ever see it.
        """
        self.fx.track(
            "trust/portfolio.toml",
            PORTFOLIO + '\n[[generated_doc]]\npath = "trust/DOC.md"\narea = "alpha"\n'
            'section = "portfolio-axioms"\n',
        )
        self.fx.track(
            "trust/DOC.md",
            DOC
            + "\n<!-- trust-spine:begin area=alpha section=portfolio-axioms version=1 -->\n"
            + "<!-- trust-spine:end area=alpha section=portfolio-axioms -->\n",
        )
        self.fx.run("generate")
        text = (self.fx.root / "trust/DOC.md").read_text(encoding="utf-8")
        self.assertIn("Alpha.Known.permitted_axiom", text)

    def test_undeclared_axiom_anywhere_is_reported(self):
        self.fx.track(
            "Alpha/Sneaky.lean",
            "namespace Alpha.Sneaky\naxiom sneaky : True\nend Alpha.Sneaky\n",
        )
        _, doc = self.fx.run("audit", "--json")
        subjects = [f["subject"] for f in doc["findings"] if f["code"] == "project-axiom-undeclared"]
        self.assertIn("Alpha.Sneaky.sneaky", subjects)

    def test_axiom_name_uses_the_namespace_not_the_module_path(self):
        """The real tree has `Q11DyeAxioms.lean` declaring into `RelativeConicArcs.ClebschDye`."""
        imports, axioms = ts._parse_header(
            "import X\n\nnamespace Outer.Inner\naxiom a : True\nend Outer.Inner\n"
        )
        self.assertEqual(imports, ("X",))
        self.assertEqual(axioms, ("Outer.Inner.a",))

    def test_axiom_in_unaudited_library_is_flagged_as_outside_gates(self):
        self.fx.track(
            "Beta/Ax.lean", "namespace Beta.Ax\naxiom beta_axiom : True\nend Beta.Ax\n"
        )
        _, doc = self.fx.run("audit", "--json")
        codes = {(f["code"], f["subject"]) for f in doc["findings"]}
        self.assertIn(("axiom-outside-gates", "Beta.Ax.beta_axiom"), codes)

    # -- plan test 2: a terminal acquiring an unexpected axiom --------------------------------

    def test_terminal_axiom_mismatch_is_reported(self):
        self.fx.write_facts(
            terminal_axioms={
                "Alpha.Main.terminal": ["Classical.choice", "propext", "Alpha.Known.permitted_axiom"]
            }
        )
        _, doc = self.fx.run("audit", "--json")
        mismatches = [f for f in doc["findings"] if f["code"] == "terminal-axiom-mismatch"]
        self.assertEqual(len(mismatches), 1)
        self.assertIn("Alpha.Known.permitted_axiom", mismatches[0]["detail"])

    def test_area_permitted_axiom_does_not_excuse_a_terminal(self):
        """The whole point of exact per-terminal sets.

        `Alpha.Known.permitted_axiom` is permitted for the area, so it raises no
        `project-axiom-undeclared`.  It must still break the terminal that collects it.
        """
        self.fx.write_facts(
            project_axioms=["Alpha.Known.permitted_axiom"],
            terminal_axioms={
                "Alpha.Main.terminal": ["Alpha.Known.permitted_axiom", "Classical.choice", "propext"]
            },
        )
        codes = self.fx.audit_codes()
        self.assertNotIn("project-axiom-undeclared", codes)
        self.assertIn("terminal-axiom-mismatch", codes)

    def test_terminal_absent_from_its_gate_is_reported(self):
        self.fx.write_facts(terminal_axioms={})
        codes = self.fx.audit_codes()
        self.assertIn("terminal-absent-from-gate", codes)

    # -- plan test 3: a terminal in no declared gate -------------------------------------------

    def test_terminal_without_any_gate_is_reported(self):
        spine = SPINE.replace('gates = ["Alpha.Gate"]', "gates = []")
        self.fx.track("trust/areas/alpha.toml", spine)
        codes = self.fx.audit_codes()
        self.assertIn("terminal-without-gate", codes)

    def test_multi_gate_terminal_is_accepted(self):
        """Independently compiled gates cannot share an environment, so this must be legal."""
        spine = SPINE.replace(
            '[[gate]]\nmodule = "Alpha.Gate"\nterminals = ["Alpha.Main.terminal"]\n',
            '[[gate]]\nmodule = "Alpha.Gate"\nterminals = ["Alpha.Main.terminal"]\n\n'
            '[[gate]]\nmodule = "Alpha.Gate2"\nterminals = ["Alpha.Main.terminal"]\n',
        ).replace(
            'gates = ["Alpha.Gate"]', 'gates = ["Alpha.Gate", "Alpha.Gate2"]'
        )
        self.fx.track("trust/areas/alpha.toml", spine)
        self.fx.track("Alpha/Gate2.lean", "import Alpha.Main\n")
        codes = self.fx.audit_codes()
        self.assertNotIn("gate-terminal-mismatch", codes)
        self.assertNotIn("terminal-without-gate", codes)

    # -- plan test 4: an unclassified project module -------------------------------------------

    def test_new_unclassified_library_is_reported(self):
        """A whole new top-level area appearing in the lakefile must not slip through."""
        self.fx.track("lakefile.toml", LAKEFILE + '\n[[lean_lib]]\nname = "Gamma"\n')
        self.fx.track("Gamma/New.lean", "namespace Gamma\nend Gamma\n")
        _, doc = self.fx.run("audit", "--json")
        codes = {f["code"] for f in doc["findings"]}
        self.assertIn("lakefile-drift", codes)
        self.assertIn("unclassified-module", codes)

    def test_module_outside_every_library_is_reported(self):
        """The real tree's `RepairPorts/` case: tracked source no lake target builds."""
        self.fx.track("Orphan/Thing.lean", "namespace Orphan\nend Orphan\n")
        _, doc = self.fx.run("audit", "--json")
        subjects = [
            f["subject"] for f in doc["findings"] if f["code"] == "module-outside-libraries"
        ]
        self.assertEqual(subjects, ["Orphan.Thing"])

    def test_module_no_extraction_unit_reaches_is_reported(self):
        self.fx.track("Alpha/Floating.lean", "namespace Alpha.Floating\nend Alpha.Floating\n")
        codes = self.fx.audit_codes()
        self.assertIn("module-unreached-by-units", codes)

    def test_declared_unreached_module_is_downgraded_but_still_listed(self):
        _, doc = self.fx.run("audit", "--json")
        declared = [f for f in doc["findings"] if f["code"] == "module-unreached-declared"]
        self.assertTrue(declared)
        self.assertEqual(declared[0]["severity"], "info")

    # -- plan tests 5-7: data trees -------------------------------------------------------------

    def test_untracked_leaf_in_a_data_tree_is_reported(self):
        self.fx.write("Alpha/Rows/R_99.lean", "namespace Alpha.Rows\nend Alpha.Rows\n")
        _, doc = self.fx.run("audit", "--json")
        subjects = [
            f["subject"] for f in doc["findings"] if f["code"] == "data-tree-untracked-leaf"
        ]
        self.assertEqual(subjects, ["Alpha/Rows/R_99.lean"])

    def test_tracked_leaf_matching_no_member_rule_is_reported(self):
        self.fx.track("Alpha/Rows/Surprise.lean", "namespace Alpha.Rows\nend Alpha.Rows\n")
        codes = self.fx.audit_codes()
        self.assertIn("data-tree-member-unmatched", codes)

    def test_declared_data_tree_with_no_files_is_reported(self):
        spine = SPINE.replace('path = "Alpha/Rows"', 'path = "Alpha/Gone"')
        self.fx.track("trust/areas/alpha.toml", spine)
        codes = self.fx.audit_codes()
        self.assertIn("data-tree-missing", codes)

    def test_missing_generator_is_reported(self):
        spine = SPINE.replace(
            'reason = "fixture tree"', 'reason = "fixture tree"\ngenerator = "nope/absent.py"'
        )
        self.fx.track("trust/areas/alpha.toml", spine)
        codes = self.fx.audit_codes()
        self.assertIn("data-tree-generator-missing", codes)

    def test_generator_digest_mismatch_is_reported(self):
        (self.fx.root.parent / "gen.py").write_text("print(1)\n", encoding="utf-8")
        spine = SPINE.replace(
            'reason = "fixture tree"',
            'reason = "fixture tree"\ngenerator = "gen.py"\ngenerator_sha256 = "' + "a" * 64 + '"',
        )
        self.fx.track("trust/areas/alpha.toml", spine)
        codes = self.fx.audit_codes()
        self.assertIn("data-tree-generator-digest", codes)

    def test_strict_provenance_requires_a_generator_digest(self):
        spine = SPINE.replace('provenance = "legacy-unverified"', 'provenance = "strict"')
        self.fx.track("trust/areas/alpha.toml", spine)
        code, out = self.fx.run("audit")
        self.assertEqual(code, ts.EXIT_REFUSED)
        self.assertIn("strict provenance requires", out["stderr"])

    def test_legacy_tree_is_never_silently_promoted(self):
        _, doc = self.fx.run("audit", "--json")
        legacy = [f for f in doc["findings"] if f["code"] == "data-tree-legacy-unverified"]
        self.assertEqual(len(legacy), 1)
        self.assertEqual(legacy[0]["severity"], "info")

    # -- plan test 8: Markdown markers ----------------------------------------------------------

    def test_missing_region_is_reported(self):
        self.fx.track("trust/DOC.md", "# Fixture\n\nno markers here\n")
        codes = self.fx.audit_codes()
        self.assertIn("region-missing", codes)

    def test_duplicated_region_is_reported(self):
        self.fx.track("trust/DOC.md", DOC + "\n" + DOC.split("\n", 2)[2])
        codes = self.fx.audit_codes()
        self.assertIn("region-duplicated", codes)

    def test_unclosed_region_is_reported(self):
        self.fx.track(
            "trust/DOC.md",
            "# Fixture\n\n<!-- trust-spine:begin area=alpha section=gates version=1 -->\n",
        )
        codes = self.fx.audit_codes()
        self.assertIn("region-unclosed", codes)

    def test_nested_region_is_reported(self):
        self.fx.track(
            "trust/DOC.md",
            "<!-- trust-spine:begin area=alpha section=gates version=1 -->\n"
            "<!-- trust-spine:begin area=alpha section=gates version=1 -->\n"
            "<!-- trust-spine:end area=alpha section=gates -->\n",
        )
        codes = self.fx.audit_codes()
        self.assertIn("region-nested", codes)

    def test_undeclared_region_is_reported(self):
        self.fx.track(
            "trust/DOC.md",
            DOC
            + "\n<!-- trust-spine:begin area=alpha section=data-trees version=1 -->\n"
            + "<!-- trust-spine:end area=alpha section=data-trees -->\n",
        )
        codes = self.fx.audit_codes()
        self.assertIn("region-undeclared", codes)

    def test_hand_edited_region_is_reported_by_check(self):
        self.fx.run("generate")
        self.fx.git("add", "-A")
        doc_path = self.fx.root / "trust/DOC.md"
        text = doc_path.read_text(encoding="utf-8")
        doc_path.write_text(
            text.replace("| Gate", "| Gate (hand edited)", 1), encoding="utf-8"
        )
        codes = self.fx.check_codes()
        self.assertIn("generated-region-stale", codes)

    def test_generate_refuses_to_repair_a_malformed_region(self):
        self.fx.track(
            "trust/DOC.md",
            "<!-- trust-spine:begin area=alpha section=gates version=1 -->\n",
        )
        code, out = self.fx.run("generate")
        self.assertEqual(code, ts.EXIT_REFUSED)
        self.assertIn("malformed regions", out["stderr"])

    # -- plan tests 9-10: graph and renderer ----------------------------------------------------

    def test_stale_graph_is_caught_even_when_docs_match(self):
        self.fx.run("generate")
        manifest_path = self.fx.root / "trust/graph-manifest.json"
        manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
        manifest["canonical_sha256"] = "f" * 64
        manifest_path.write_text(
            json.dumps(manifest, indent=2, sort_keys=True) + "\n", encoding="utf-8"
        )
        codes = self.fx.check_codes()
        self.assertIn("graph-stale", codes)
        self.assertNotIn("generated-region-stale", codes)

    def test_topology_change_invalidates_the_graph_manifest(self):
        """A new module is a topology change and must invalidate the manifest."""
        self.fx.run("generate")
        self.assertNotIn("graph-stale", self.fx.check_codes())
        self.fx.track("Alpha/Rows/R_02.lean", "namespace Alpha.Rows\nend Alpha.Rows\n")
        self.assertIn("graph-stale", self.fx.check_codes())

    def test_body_only_edit_does_not_invalidate_the_graph_manifest(self):
        """Editing a proof body must not turn another lane's check red.

        The graph records dependency topology.  If it also hashed file contents, any lane editing
        any proof would break every other lane's `check` with a finding that names nothing.
        """
        self.fx.run("generate")
        self.fx.track(
            "Alpha/Rows/R_00.lean",
            "namespace Alpha.Rows\ntheorem extra : True := trivial\nend Alpha.Rows\n",
        )
        self.assertNotIn("graph-stale", self.fx.check_codes())

    def test_renderer_output_is_derived_not_authoritative(self):
        """A renderer change must not be able to alter the canonical artifact."""
        self.fx.run("generate")
        before = (self.fx.root / "trust/graph-manifest.json").read_text(encoding="utf-8")
        self.fx.run("render", "--format", "mermaid", "--view", "gate-closure")
        self.fx.run("render", "--format", "dot", "--view", "data-provenance")
        after = (self.fx.root / "trust/graph-manifest.json").read_text(encoding="utf-8")
        self.assertEqual(before, after)

    def test_collapse_preserves_boundary_edges(self):
        self.fx.run("graph", "--out", str(self.fx.root / "g.json"))
        graph = json.loads((self.fx.root / "g.json").read_text(encoding="utf-8"))
        expanded = ts.filter_graph(graph, "data-provenance", None, False, 500)
        collapsed = ts.filter_graph(graph, "data-provenance", None, True, 500)
        # Every module inside the tree disappears, but the tree itself keeps a boundary edge.
        self.assertTrue(any(n["id"] == "tree:Alpha/Rows" for n in collapsed["nodes"]))
        self.assertFalse(any(n["id"] == "module:Alpha.Rows.R_00" for n in collapsed["nodes"]))
        self.assertTrue(any(n["id"] == "module:Alpha.Rows.R_00" for n in expanded["nodes"]))

    def test_render_truncation_is_announced(self):
        code, out = self.fx.run("render", "--format", "mermaid", "--max-nodes", "1")
        self.assertIn("truncated", out["stdout"])

    def test_unknown_view_is_refused(self):
        registry = ts.load_registry(self.fx.root / "trust")
        inventory = ts.scan_sources(self.fx.root, registry)
        graph = ts.build_graph(registry, inventory, ts.classify(inventory, registry), {})
        with self.assertRaises(ts.Refused):
            ts.filter_graph(graph, "not-a-view", None, True, 100)

    # -- invariants -----------------------------------------------------------------------------

    def test_two_generate_runs_are_byte_identical(self):
        self.fx.run("generate")
        first = (self.fx.root / "trust/DOC.md").read_bytes()
        first_manifest = (self.fx.root / "trust/graph-manifest.json").read_bytes()
        self.fx.run("generate")
        self.assertEqual(first, (self.fx.root / "trust/DOC.md").read_bytes())
        self.assertEqual(
            first_manifest, (self.fx.root / "trust/graph-manifest.json").read_bytes()
        )

    def test_check_leaves_the_worktree_unchanged(self):
        self.fx.run("generate")
        self.fx.git("add", "-A")
        self.fx.commit("generated")
        before = subprocess.run(
            ["git", "status", "--porcelain"],
            cwd=self.fx.root,
            capture_output=True,
            text=True,
        ).stdout
        self.fx.run("check")
        after = subprocess.run(
            ["git", "status", "--porcelain"],
            cwd=self.fx.root,
            capture_output=True,
            text=True,
        ).stdout
        self.assertEqual(before, after)
        self.assertEqual(before, "")

    def test_audit_never_writes(self):
        self.fx.git("add", "-A")
        before = sorted(p.name for p in (self.fx.root / "trust").rglob("*"))
        self.fx.run("audit")
        self.assertEqual(before, sorted(p.name for p in (self.fx.root / "trust").rglob("*")))

    def test_facts_schema_version_mismatch_is_refused(self):
        self.fx.write_facts(schema_version=99)
        code, out = self.fx.run("audit")
        self.assertEqual(code, ts.EXIT_REFUSED)
        self.assertIn("schema_version", out["stderr"])

    def test_facts_for_an_undeclared_unit_is_reported(self):
        self.fx.write_facts(unit="Alpha.NotAGate")
        codes = self.fx.audit_codes()
        self.assertIn("facts-undeclared", codes)

    def test_registry_schema_version_mismatch_is_refused(self):
        self.fx.track("trust/portfolio.toml", PORTFOLIO.replace("schema_version = 1", "schema_version = 2"))
        code, out = self.fx.run("audit")
        self.assertEqual(code, ts.EXIT_REFUSED)

    def test_pattern_forms(self):
        self.assertTrue(ts._matches("A.B", "A.B"))
        self.assertFalse(ts._matches("A.BC", "A.B"))
        self.assertTrue(ts._matches("A.B.C", "A.B.**"))
        self.assertTrue(ts._matches("A.B", "A.B.**"))
        self.assertFalse(ts._matches("A.BC", "A.B.**"))
        self.assertTrue(ts._matches("A.BC", "A.B**"))
        self.assertTrue(ts._matches("A.B", "A.B**"))

    # -- external inputs anchored in a certificate package ------------------------------------

    EXTERNAL_PACKAGE_INPUT = """
[[external_input]]
name = "class count"
entry_mode = "consistency-check"
entry_declarations = ["Alpha.Certificates.rejection_profile"]
entry_package = "alpha-certificates"
anchor = "Alpha/TRUST.md#boundary"
"""

    def test_package_anchored_input_resolves_against_the_pinned_fact(self):
        self.fx.write_facts()
        self.fx.write_package()
        self.fx.write_external_input(self.EXTERNAL_PACKAGE_INPUT)
        codes = self.fx.audit_codes()
        self.assertNotIn("external-input-unanchored", codes)
        self.assertNotIn("external-input-entry-missing", codes)
        self.assertNotIn("external-package-fact-stale", codes)

    def test_declaration_absent_from_the_pinned_fact_is_reported(self):
        self.fx.write_facts()
        self.fx.write_package()
        self.fx.write_external_input(
            self.EXTERNAL_PACKAGE_INPUT.replace(
                "Alpha.Certificates.rejection_profile", "Alpha.Certificates.invented"
            )
        )
        self.assertIn("external-input-entry-missing", self.fx.audit_codes())

    def test_anchor_reaching_into_the_package_dependency_is_rejected(self):
        self.fx.write_facts()
        self.fx.write_package()
        self.fx.write_external_input(
            self.EXTERNAL_PACKAGE_INPUT.replace(
                "Alpha.Certificates.rejection_profile", "Base.shared_bound"
            )
        )
        self.assertIn("external-input-entry-not-owned", self.fx.audit_codes())

    def test_anchor_in_an_unpinned_package_is_reported(self):
        self.fx.write_facts()
        self.fx.write_external_input(self.EXTERNAL_PACKAGE_INPUT)
        self.assertIn("external-input-package-unpinned", self.fx.audit_codes())

    def test_edited_pinned_fact_does_not_pass_as_evidence(self):
        self.fx.write_facts()
        self.fx.write_package(pin_hash=False)
        self.fx.write_external_input(self.EXTERNAL_PACKAGE_INPUT)
        codes = self.fx.audit_codes()
        self.assertIn("external-package-fact-stale", codes)
        self.assertIn("external-input-package-unpinned", codes)

    def test_fact_disagreeing_with_its_pin_is_stale(self):
        self.fx.write_facts()
        self.fx.write_package(gate="Alpha.Gates.SomethingElse")
        self.fx.write_external_input(self.EXTERNAL_PACKAGE_INPUT)
        self.assertIn("external-package-fact-stale", self.fx.audit_codes())

    def test_local_anchor_is_unverified_rather_than_missing_without_extraction(self):
        self.fx.write_external_input(
            """
[[external_input]]
name = "local bound"
entry_mode = "hypothesis"
entry_declarations = ["Alpha.Averaging.bound_consumer"]
anchor = "Alpha/TRUST.md#boundary"
"""
        )
        self.fx.write_facts(unit="Alpha.Other")
        self.assertIn("facts-missing", self.fx.audit_codes())
        codes = self.fx.audit_codes()
        self.assertIn("external-input-entry-unverified", codes)
        self.assertNotIn("external-input-entry-missing", codes)

    def test_local_anchor_absent_from_a_complete_extraction_is_missing(self):
        self.fx.write_external_input(
            """
[[external_input]]
name = "local bound"
entry_mode = "hypothesis"
entry_declarations = ["Alpha.Averaging.bound_consumer"]
anchor = "Alpha/TRUST.md#boundary"
"""
        )
        self.fx.write_facts()
        codes = self.fx.audit_codes()
        self.assertNotIn("facts-missing", codes)
        self.assertIn("external-input-entry-missing", codes)

    def test_import_parser_ignores_the_word_import_in_a_body(self):
        imports, _ = ts._parse_header(
            'import Real.One\n\ntheorem t : True := by\n  trivial\n-- import Fake.Two\n'
        )
        self.assertEqual(imports, ("Real.One",))


if __name__ == "__main__":
    unittest.main(verbosity=2)
