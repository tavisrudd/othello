#!/usr/bin/env python3
"""Tests for paper-facts.py.

Fully hermetic: every fixture is a throwaway git repository holding a few tiny manuscripts, so the
suite never reads the real papers, never compiles TeX, and never builds anything.  Run:

    python3 lean/scripts/test_paper_facts.py

Four of these tests are named after the drift defects that were found by hand on 2026-07-26 and
that motivated the paper layer.  Each rebuilds the defect in miniature and asserts that the checker
reports it.  The rest are the other direction: a checker that cannot be made to go green is as
useless as one that cannot be made to go red, so the green fixture is asserted to be genuinely
clean, and each adversarial case breaks exactly one thing.
"""

from __future__ import annotations

import importlib.util
import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

SCRIPT = Path(__file__).resolve().parent / "paper-facts.py"
SPINE = Path(__file__).resolve().parent / "lean-trust-spine.py"


def _load_module():
    spec = importlib.util.spec_from_file_location("paper_facts", SCRIPT)
    module = importlib.util.module_from_spec(spec)
    # dataclasses resolves annotations through sys.modules; a bare exec_module leaves it unset.
    sys.modules["paper_facts"] = module
    spec.loader.exec_module(module)
    return module


pf = _load_module()


REGISTRY = """\
schema_version = 1

[repository]
self_authors = ["Rudd"]
paper_roots = ["papers"]
drift_scan_roots = ["papers", "notes"]

[[paper]]
id = "alpha"
dir = "papers/alpha"
main = "alpha.tex"
lane = "alpha-lane"

[[paper]]
id = "beta"
dir = "papers/beta"
main = "beta.tex"
lane = "beta-lane"
"""

ALPHA = """\
\\documentclass{article}
\\title{Arcs complete outside a conic:\\\\
a prescribed-hole defect identity}
\\author{Tavis Rudd}
\\begin{document}
\\maketitle
\\begin{theorem}\\label{thm:defect}
The defect identity holds.
\\end{theorem}
\\begin{lemma}\\label{lem:helper}
A helper.
\\end{lemma}
\\end{document}
"""

BETA = """\
\\documentclass{article}
\\title{Deep-hole rigidity and factorization memory}
\\author{Tavis Rudd}
\\begin{document}
\\maketitle
\\begin{theorem}\\label{thm:rigidity}
Rigidity holds.
\\end{theorem}
\\begin{thebibliography}{9}
\\bibitem{Foreign2020}
A.~Other,
\\newblock \\emph{Something else entirely},
\\newblock Journal, 2020.
\\bibitem{RuddAlpha2026}
T.~Rudd,
\\newblock \\emph{Arcs complete outside a conic: a prescribed-hole defect identity},
\\newblock working paper, 2026.
\\end{thebibliography}
\\end{document}
"""


REGION_DOC = """\
# Summary

Judgement that stays hand-written.

<!-- trust-spine:begin area=papers section=manuscripts version=1 -->
BODY
<!-- trust-spine:end area=papers section=manuscripts -->

More judgement.
"""


class Fixture:
    """A throwaway repository with `lean/` beside `papers/`, exactly like the real layout."""

    def __init__(self, root: Path) -> None:
        self.root = root
        self.lean_root = root / "lean"
        (self.lean_root / "scripts").mkdir(parents=True)
        (self.lean_root / "trust").mkdir(parents=True)
        # The paper layer imports the spine for its finding type and Lean facts loader.
        (self.lean_root / "scripts" / "lean-trust-spine.py").write_bytes(SPINE.read_bytes())
        self.write("lean/trust/papers.toml", REGISTRY)
        self.write("papers/alpha/alpha.tex", ALPHA)
        self.write("papers/beta/beta.tex", BETA)
        self.git("init", "-q")
        self.git("config", "user.email", "fixture@example.invalid")
        self.git("config", "user.name", "Fixture")
        self.git("config", "commit.gpgsign", "false")
        self.commit()

    def write(self, rel: str, text: str) -> None:
        path = self.root / rel
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(text, encoding="utf-8")

    def write_bytes(self, rel: str, data: bytes) -> None:
        path = self.root / rel
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_bytes(data)

    def git(self, *args: str) -> None:
        subprocess.run(["git", *args], cwd=self.root, check=True, capture_output=True)

    def commit(self) -> None:
        self.git("add", "-A")
        self.git("-c", "commit.gpgsign=false", "commit", "-qm", "fixture")

    def track(self, rel: str, text: str) -> None:
        self.write(rel, text)
        self.commit()

    def run(self, *args: str) -> tuple[int, dict]:
        proc = subprocess.run(
            [sys.executable, str(SCRIPT), "--lean-root", str(self.lean_root), *args, "--json"],
            capture_output=True,
            text=True,
        )
        if proc.returncode == pf.EXIT_REFUSED:
            return proc.returncode, {"refused": proc.stderr.strip()}
        return proc.returncode, json.loads(proc.stdout)

    def audit(self) -> list[dict]:
        code, doc = self.run("audit")
        self.assertless = code
        return doc["findings"]

    def codes(self) -> set[str]:
        return {finding["code"] for finding in self.audit()}

    def findings_for(self, code: str) -> list[dict]:
        return [f for f in self.audit() if f["code"] == code]


class PaperFactsTest(unittest.TestCase):
    def setUp(self) -> None:
        self._tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self._tmp.cleanup)
        self.fx = Fixture(Path(self._tmp.name))

    # -- the green baseline ------------------------------------------------------------------

    def test_green_fixture_reports_nothing(self):
        self.assertEqual(self.fx.audit(), [])

    def test_facts_record_the_title_from_the_manuscript_alone(self):
        registry = pf.load_registry(self.fx.lean_root / "trust" / "papers.toml")
        tree = pf.load_tree(self.fx.root)
        facts = pf.extract_paper(tree, registry.by_id()["alpha"], registry)
        self.assertIn("prescribed-hole defect identity", facts.title_normalized)
        self.assertEqual(dict(facts.environment_counts), {"theorem": 1, "lemma": 1})
        self.assertEqual({label for label, _ in facts.labels}, {"thm:defect", "lem:helper"})

    # -- 2026-07-26 defect 1: a compiled manuscript with no registry row ----------------------

    def test_unregistered_paper_directory_is_reported(self):
        self.fx.track(
            "papers/gamma/gamma.tex",
            "\\title{An unregistered manuscript}\n\\begin{document}\\end{document}\n",
        )
        self.assertIn("paper-unregistered", self.fx.codes())

    def test_a_section_file_is_not_mistaken_for_a_manuscript(self):
        self.fx.track("papers/alpha/sections/01-intro.tex", "\\section{Intro}\n")
        self.assertNotIn("paper-unregistered", self.fx.codes())

    # -- 2026-07-26 defect 2: a superseded title surviving in tracked files -------------------

    def test_superseded_title_surviving_elsewhere_is_reported(self):
        self.fx.write(
            "lean/trust/papers.toml",
            REGISTRY.replace(
                'main = "alpha.tex"\nlane = "alpha-lane"',
                'main = "alpha.tex"\nlane = "alpha-lane"\n'
                'superseded_titles = ["Exact prescribed-hole defect and matching-design rigidity"]',
            ),
        )
        self.fx.track(
            "papers/alpha/README.md",
            "# Exact prescribed-hole defect\nand matching-design rigidity\n",
        )
        subjects = {f["subject"] for f in self.fx.findings_for("title-drift")}
        self.assertIn("papers/alpha/README.md", subjects)

    def test_superseded_title_is_found_across_a_line_break_and_a_tex_newline(self):
        self.fx.write(
            "lean/trust/papers.toml",
            REGISTRY.replace(
                'main = "alpha.tex"\nlane = "alpha-lane"',
                'main = "alpha.tex"\nlane = "alpha-lane"\n'
                'superseded_titles = ["Exact prescribed-hole defect and matching-design rigidity"]',
            ),
        )
        self.fx.track(
            "papers/beta/note.tex",
            "See \\emph{Exact prescribed-hole defect\\\\\n  and matching-design\n  rigidity}.\n",
        )
        subjects = {f["subject"] for f in self.fx.findings_for("title-drift")}
        self.assertIn("papers/beta/note.tex", subjects)

    def test_a_superseded_title_equal_to_the_current_one_is_itself_reported(self):
        self.fx.track(
            "lean/trust/papers.toml",
            REGISTRY.replace(
                'main = "beta.tex"\nlane = "beta-lane"',
                'main = "beta.tex"\nlane = "beta-lane"\n'
                'superseded_titles = ["Deep-hole rigidity and factorization memory"]',
            ),
        )
        details = " ".join(f["detail"] for f in self.fx.findings_for("title-drift"))
        self.assertIn("current title", details)

    def test_drift_scan_stays_inside_the_declared_roots(self):
        self.fx.write(
            "lean/trust/papers.toml",
            REGISTRY.replace('drift_scan_roots = ["papers", "notes"]', 'drift_scan_roots = ["notes"]')
            .replace(
                'main = "alpha.tex"\nlane = "alpha-lane"',
                'main = "alpha.tex"\nlane = "alpha-lane"\nsuperseded_titles = ["A dead title"]',
            ),
        )
        self.fx.track("papers/alpha/README.md", "A dead title\n")
        self.assertNotIn("title-drift", self.fx.codes())
        self.fx.track("notes/somewhere.md", "A dead title\n")
        self.assertIn("title-drift", self.fx.codes())

    def test_a_readme_claiming_a_stale_title_is_reported_without_any_declaration(self):
        self.fx.track(
            "papers/alpha/README.md",
            "# Alpha\n\n**Title:** *Exact prescribed-hole defect and matching-design rigidity*\n",
        )
        subjects = {f["subject"] for f in self.fx.findings_for("title-drift")}
        self.assertIn("papers/alpha/README.md", subjects)

    def test_a_readme_that_never_claims_a_title_is_not_drifting(self):
        self.fx.track("papers/alpha/README.md", "# Alpha\n\nReproducibility sources live here.\n")
        self.assertNotIn("title-drift", self.fx.codes())

    def test_a_readme_giving_the_current_title_is_accepted(self):
        self.fx.track(
            "papers/alpha/README.md",
            "# Alpha\n\nThe manuscript is titled *Arcs complete outside a conic:\n"
            "a prescribed-hole defect identity*.\n",
        )
        self.assertNotIn("title-drift", self.fx.codes())

    def test_a_shared_readme_may_name_any_manuscript_of_its_directory(self):
        self.fx.write(
            "papers/alpha/companion.tex",
            "\\title{A computational companion}\n\\begin{document}\\end{document}\n",
        )
        self.fx.write(
            "papers/alpha/README.md",
            "**Title:** *A computational companion*\n",
        )
        self.fx.track(
            "lean/trust/papers.toml",
            REGISTRY
            + '\n[[paper]]\nid = "alpha_companion"\ndir = "papers/alpha"\n'
            'main = "companion.tex"\nlane = "alpha-lane"\n',
        )
        self.assertNotIn("title-drift", self.fx.codes())

    # -- 2026-07-26 defect 3: self-citations naming companion papers by dead titles -----------

    def test_self_citation_with_a_dead_title_is_reported(self):
        self.fx.track(
            "papers/beta/beta.tex",
            BETA.replace(
                "Arcs complete outside a conic: a prescribed-hole defect identity",
                "Arcs complete outside a prescribed conic: an exact defect identity",
            ),
        )
        subjects = {f["subject"] for f in self.fx.findings_for("citation-title-drift")}
        self.assertIn("papers/beta/beta.tex:RuddAlpha2026", subjects)

    def test_a_bibtex_self_citation_with_a_dead_title_is_reported(self):
        self.fx.track(
            "papers/beta/refs.bib",
            "@article{RuddAlphaBib2026,\n"
            "  author = {Rudd, Tavis},\n"
            "  title = {Arcs Complete Outside a Prescribed Conic},\n"
            "  year = {2026}\n}\n",
        )
        subjects = {f["subject"] for f in self.fx.findings_for("citation-title-drift")}
        self.assertIn("papers/beta/refs.bib:RuddAlphaBib2026", subjects)

    def test_a_correct_self_citation_is_accepted_through_tex_presentation(self):
        self.fx.track(
            "papers/beta/refs.bib",
            "@article{RuddAlphaBib2026,\n"
            "  author = {Rudd, Tavis},\n"
            "  title = {{Arcs} complete outside a conic: a prescribed-hole\n"
            "           defect identity},\n"
            "  year = {2026}\n}\n",
        )
        self.assertNotIn("citation-title-drift", self.fx.codes())

    def test_a_foreign_authors_entry_is_not_a_self_citation(self):
        self.fx.track(
            "papers/beta/refs.bib",
            "@article{Other2020,\n  author = {Other, A.},\n"
            "  title = {Any title at all},\n  year = {2020}\n}\n",
        )
        self.assertNotIn("citation-title-drift", self.fx.codes())

    def test_a_declared_external_publication_suppresses_the_check(self):
        self.fx.write(
            "papers/beta/refs.bib",
            "@article{RuddElsewhere2019,\n  author = {Rudd, Tavis},\n"
            "  title = {A paper that is not in this repository},\n  year = {2019}\n}\n",
        )
        self.fx.track(
            "lean/trust/papers.toml",
            REGISTRY
            + '\n[[external_citation]]\nkey = "RuddElsewhere2019"\nreason = "published elsewhere"\n',
        )
        self.assertNotIn("citation-title-drift", self.fx.codes())

    # -- 2026-07-26 defect 3, second half: dead titles reaching the compiled PDF --------------

    def test_generated_bibliography_carrying_a_dead_title_is_reported(self):
        self.fx.write(
            "papers/beta/beta.bbl",
            "\\begin{thebibliography}{9}\n"
            "\\bibitem[Rud26]{RuddAlpha2026}\nTavis Rudd.\n"
            "\\newblock Arcs complete outside a prescribed conic.\n"
            "\\end{thebibliography}\n",
        )
        codes = self.fx.codes()
        self.assertIn("stale-bbl", codes)
        self.assertIn("bibliography-untracked", codes)

    def test_generated_bibliography_disagreeing_with_its_source_is_reported(self):
        self.fx.track(
            "papers/beta/refs.bib",
            "@article{RuddAlphaBib2026,\n  author = {Rudd, Tavis},\n"
            "  title = {Arcs complete outside a conic: a prescribed-hole defect identity},\n"
            "  year = {2026}\n}\n",
        )
        self.fx.write(
            "papers/beta/beta.bbl",
            "\\begin{thebibliography}{9}\n"
            "\\bibitem[Rud26]{RuddAlphaBib2026}\nTavis Rudd.\n"
            "\\newblock Arcs complete outside a prescribed conic.\n"
            "\\end{thebibliography}\n",
        )
        details = " ".join(f["detail"] for f in self.fx.findings_for("stale-bbl"))
        self.assertIn("papers/beta/refs.bib", details)

    def test_a_generated_bibliography_agreeing_with_everything_is_accepted(self):
        self.fx.track(
            "papers/beta/beta.bbl",
            "\\begin{thebibliography}{9}\n"
            "\\bibitem[Rud26]{RuddAlpha2026}\nTavis Rudd.\n"
            "\\newblock Arcs complete outside a conic: a prescribed-hole defect identity.\n"
            "\\end{thebibliography}\n",
        )
        self.assertNotIn("stale-bbl", self.fx.codes())

    # -- label mapping -----------------------------------------------------------------------

    def test_adopted_label_absent_from_the_manuscript_is_reported(self):
        self.fx.track(
            "lean/trust/papers.toml",
            REGISTRY.replace(
                'main = "alpha.tex"\nlane = "alpha-lane"',
                'main = "alpha.tex"\nlane = "alpha-lane"\nadopted_labels = ["thm:missing"]',
            ),
        )
        self.assertIn("label-unmapped", self.fx.codes())

    def test_manifest_claim_without_a_manuscript_label_is_reported(self):
        self.fx.write(
            "papers/alpha/verification/claims.json",
            json.dumps({"claims": [{"label": "thm:defect"}, {"label": "thm:not-in-paper"}]}),
        )
        self.fx.track(
            "lean/trust/papers.toml",
            REGISTRY.replace(
                'main = "alpha.tex"\nlane = "alpha-lane"',
                'main = "alpha.tex"\nlane = "alpha-lane"\n'
                'manifest = "verification/claims.json"\nmanifest_labels = "claims[].label"',
            ),
        )
        subjects = {f["subject"] for f in self.fx.findings_for("label-unmapped")}
        self.assertEqual(subjects, {"alpha:thm:not-in-paper"})

    def test_adopted_label_missing_from_the_manifest_is_reported(self):
        self.fx.write(
            "papers/alpha/verification/claims.json",
            json.dumps({"claims": [{"label": "thm:defect"}]}),
        )
        self.fx.track(
            "lean/trust/papers.toml",
            REGISTRY.replace(
                'main = "alpha.tex"\nlane = "alpha-lane"',
                'main = "alpha.tex"\nlane = "alpha-lane"\n'
                'adopted_labels = ["lem:helper"]\n'
                'manifest = "verification/claims.json"\nmanifest_labels = "claims[].label"',
            ),
        )
        details = " ".join(f["detail"] for f in self.fx.findings_for("label-unmapped"))
        self.assertIn("no claim row", details)

    def test_a_manifest_that_is_not_tracked_is_reported(self):
        self.fx.track(
            "lean/trust/papers.toml",
            REGISTRY.replace(
                'main = "alpha.tex"\nlane = "alpha-lane"',
                'main = "alpha.tex"\nlane = "alpha-lane"\n'
                'manifest = "verification/absent.json"\nmanifest_labels = "claims[].label"',
            ),
        )
        self.assertIn("paper-manifest-missing", self.fx.codes())

    def test_a_manifest_without_a_selector_is_refused(self):
        self.fx.track(
            "lean/trust/papers.toml",
            REGISTRY.replace(
                'main = "alpha.tex"\nlane = "alpha-lane"',
                'main = "alpha.tex"\nlane = "alpha-lane"\nmanifest = "verification/claims.json"',
            ),
        )
        code, doc = self.fx.run("audit")
        self.assertEqual(code, pf.EXIT_REFUSED)
        self.assertIn("manifest_labels", doc["refused"])

    # -- the Lean boundary -------------------------------------------------------------------

    def test_cited_lean_terminal_is_unverified_while_lean_facts_are_absent(self):
        self.fx.track(
            "lean/trust/papers.toml",
            REGISTRY.replace(
                'main = "alpha.tex"\nlane = "alpha-lane"',
                'main = "alpha.tex"\nlane = "alpha-lane"\n'
                'lean_terminals = ["Alpha.Gates.defect_identity"]',
            ),
        )
        codes = self.fx.codes()
        self.assertIn("facts-missing", codes)
        self.assertNotIn("terminal-unknown", codes)

    def test_cited_lean_terminal_absent_from_extracted_facts_is_reported(self):
        self.fx.write(
            "lean/trust/facts/Alpha.Gates.json",
            json.dumps(
                {
                    "schema_version": 1,
                    "unit": "Alpha.Gates",
                    "project_declarations": ["Alpha.Gates.something_else"],
                }
            ),
        )
        self.fx.track(
            "lean/trust/papers.toml",
            REGISTRY.replace(
                'main = "alpha.tex"\nlane = "alpha-lane"',
                'main = "alpha.tex"\nlane = "alpha-lane"\n'
                'lean_terminals = ["Alpha.Gates.defect_identity"]',
            ),
        )
        self.assertIn("terminal-unknown", self.fx.codes())

    def test_a_cited_terminal_the_facts_confirm_is_accepted(self):
        self.fx.write(
            "lean/trust/facts/Alpha.Gates.json",
            json.dumps(
                {
                    "schema_version": 1,
                    "unit": "Alpha.Gates",
                    "project_declarations": ["Alpha.Gates.defect_identity"],
                }
            ),
        )
        self.fx.track(
            "lean/trust/papers.toml",
            REGISTRY.replace(
                'main = "alpha.tex"\nlane = "alpha-lane"',
                'main = "alpha.tex"\nlane = "alpha-lane"\n'
                'lean_terminals = ["Alpha.Gates.defect_identity"]',
            ),
        )
        codes = self.fx.codes()
        self.assertNotIn("terminal-unknown", codes)
        self.assertNotIn("facts-missing", codes)

    # -- registry integrity ------------------------------------------------------------------

    def test_a_registered_directory_with_no_manuscript_is_reported(self):
        self.fx.track(
            "lean/trust/papers.toml",
            REGISTRY
            + '\n[[paper]]\nid = "ghost"\ndir = "papers/ghost"\nmain = "ghost.tex"\n'
            'lane = "nobody"\n',
        )
        code, doc = self.fx.run("audit")
        self.assertEqual(code, pf.EXIT_REFUSED)
        self.assertIn("not tracked", doc["refused"])

    def test_duplicate_paper_ids_are_refused(self):
        self.fx.track(
            "lean/trust/papers.toml",
            REGISTRY
            + '\n[[paper]]\nid = "alpha"\ndir = "papers/alpha"\nmain = "alpha.tex"\n'
            'lane = "alpha-lane"\n',
        )
        code, doc = self.fx.run("audit")
        self.assertEqual(code, pf.EXIT_REFUSED)
        self.assertIn("duplicate", doc["refused"])

    def test_registry_schema_version_mismatch_is_refused(self):
        self.fx.track("lean/trust/papers.toml", REGISTRY.replace("schema_version = 1", "schema_version = 2"))
        code, doc = self.fx.run("audit")
        self.assertEqual(code, pf.EXIT_REFUSED)
        self.assertIn("schema_version", doc["refused"])

    # -- facts artifacts ---------------------------------------------------------------------

    def test_check_reports_a_missing_facts_artifact(self):
        code, doc = self.fx.run("check")
        self.assertIn("paper-facts-missing", {f["code"] for f in doc["findings"]})

    def test_extract_then_check_is_clean_and_a_later_edit_shows_as_stale(self):
        subprocess.run(
            [sys.executable, str(SCRIPT), "--lean-root", str(self.fx.lean_root), "extract"],
            check=True,
            capture_output=True,
        )
        code, doc = self.fx.run("check")
        self.assertEqual(doc["findings"], [])
        self.fx.track("papers/alpha/alpha.tex", ALPHA.replace("A helper.", "A better helper."))
        code, doc = self.fx.run("check")
        stale = [f for f in doc["findings"] if f["code"] == "paper-facts-stale"]
        self.assertEqual([f["severity"] for f in stale], ["warn"])

    def test_two_extract_runs_are_byte_identical(self):
        facts = self.fx.lean_root / "trust" / "paper-facts" / "alpha.json"
        for _ in range(2):
            subprocess.run(
                [sys.executable, str(SCRIPT), "--lean-root", str(self.fx.lean_root), "extract"],
                check=True,
                capture_output=True,
            )
            first = facts.read_bytes()
        self.assertEqual(first, facts.read_bytes())

    def test_a_facts_artifact_for_an_unregistered_paper_is_reported(self):
        subprocess.run(
            [sys.executable, str(SCRIPT), "--lean-root", str(self.fx.lean_root), "extract"],
            check=True,
            capture_output=True,
        )
        (self.fx.lean_root / "trust" / "paper-facts" / "ghost.json").write_text("{}\n")
        code, doc = self.fx.run("check")
        self.assertIn("paper-facts-undeclared", {f["code"] for f in doc["findings"]})

    def test_audit_never_writes(self):
        before = {
            path: path.read_bytes()
            for path in sorted(self.fx.root.rglob("*"))
            if path.is_file() and ".git/" not in str(path)
        }
        self.fx.run("audit")
        after = {
            path: path.read_bytes()
            for path in sorted(self.fx.root.rglob("*"))
            if path.is_file() and ".git/" not in str(path)
        }
        self.assertEqual(before, after)

    # -- documents that restate titles ---------------------------------------------------------

    def test_a_document_that_stops_naming_a_paper_by_its_current_title_is_reported(self):
        self.fx.write("notes/summary.md", "# Summary\n\nWe have a paper about arcs.\n")
        self.fx.track(
            "lean/trust/papers.toml",
            REGISTRY + '\n[[title_restating_doc]]\npath = "notes/summary.md"\n',
        )
        subjects = {f["subject"] for f in self.fx.findings_for("title-drift")}
        self.assertEqual(subjects, {"notes/summary.md:alpha", "notes/summary.md:beta"})

    def test_a_document_naming_every_current_title_is_accepted(self):
        self.fx.write(
            "notes/summary.md",
            "# Summary\n\n1. *Arcs complete outside a conic: a prescribed-hole defect\n"
            "   identity*.\n2. *Deep-hole rigidity and factorization memory*.\n",
        )
        self.fx.track(
            "lean/trust/papers.toml",
            REGISTRY + '\n[[title_restating_doc]]\npath = "notes/summary.md"\n',
        )
        self.assertNotIn("title-drift", self.fx.codes())

    def test_a_declared_coverage_subset_is_respected(self):
        self.fx.write("notes/summary.md", "*Deep-hole rigidity and factorization memory*\n")
        self.fx.track(
            "lean/trust/papers.toml",
            REGISTRY
            + '\n[[title_restating_doc]]\npath = "notes/summary.md"\npapers = ["beta"]\n',
        )
        self.assertNotIn("title-drift", self.fx.codes())

    def test_a_coverage_list_naming_an_unregistered_paper_is_refused(self):
        self.fx.write("notes/summary.md", "x\n")
        self.fx.track(
            "lean/trust/papers.toml",
            REGISTRY
            + '\n[[title_restating_doc]]\npath = "notes/summary.md"\npapers = ["ghost"]\n',
        )
        code, doc = self.fx.run("audit")
        self.assertEqual(code, pf.EXIT_REFUSED)
        self.assertIn("ghost", doc["refused"])

    def test_an_untracked_restating_document_is_reported(self):
        self.fx.track(
            "lean/trust/papers.toml",
            REGISTRY + '\n[[title_restating_doc]]\npath = "notes/absent.md"\n',
        )
        self.assertIn("restating-doc-missing", self.fx.codes())

    # -- generated regions ---------------------------------------------------------------------

    def _with_region(self, body: str = "") -> None:
        self.fx.write("notes/summary.md", REGION_DOC.replace("BODY", body))
        self.fx.track(
            "lean/trust/papers.toml",
            REGISTRY
            + '\n[[generated_doc]]\npath = "notes/summary.md"\nsection = "manuscripts"\n',
        )

    def _generate(self) -> None:
        subprocess.run(
            [sys.executable, str(SCRIPT), "--lean-root", str(self.fx.lean_root), "generate"],
            check=True,
            capture_output=True,
        )

    def test_an_empty_region_is_stale_until_generated(self):
        self._with_region()
        code, doc = self.fx.run("check")
        self.assertIn("generated-region-stale", {f["code"] for f in doc["findings"]})
        self._generate()
        code, doc = self.fx.run("check")
        self.assertNotIn("generated-region-stale", {f["code"] for f in doc["findings"]})

    def test_the_generated_table_carries_the_manuscripts_own_title(self):
        self._with_region()
        self._generate()
        rendered = (self.fx.root / "notes/summary.md").read_text()
        self.assertIn(
            "Arcs complete outside a conic: a prescribed-hole defect identity", rendered
        )
        self.assertIn("`alpha-lane`", rendered)

    def test_a_hand_edit_inside_a_region_is_reported(self):
        self._with_region()
        self._generate()
        path = self.fx.root / "notes/summary.md"
        path.write_text(path.read_text().replace("`alpha-lane`", "`someone-elses-lane`"))
        self.fx.commit()
        code, doc = self.fx.run("check")
        self.assertIn("generated-region-stale", {f["code"] for f in doc["findings"]})

    def test_prose_outside_the_region_survives_generation(self):
        self._with_region()
        self._generate()
        rendered = (self.fx.root / "notes/summary.md").read_text()
        self.assertIn("Judgement that stays hand-written.", rendered)

    def test_two_generate_runs_are_byte_identical(self):
        self._with_region()
        self._generate()
        first = (self.fx.root / "notes/summary.md").read_bytes()
        self._generate()
        self.assertEqual(first, (self.fx.root / "notes/summary.md").read_bytes())

    def test_a_declared_region_that_is_absent_is_reported(self):
        self.fx.write("notes/summary.md", "# Summary\n\nNo markers here.\n")
        self.fx.track(
            "lean/trust/papers.toml",
            REGISTRY
            + '\n[[generated_doc]]\npath = "notes/summary.md"\nsection = "manuscripts"\n',
        )
        code, doc = self.fx.run("check")
        self.assertIn("region-missing", {f["code"] for f in doc["findings"]})

    def test_an_unknown_section_is_refused(self):
        self.fx.track(
            "lean/trust/papers.toml",
            REGISTRY
            + '\n[[generated_doc]]\npath = "notes/summary.md"\nsection = "opinions"\n',
        )
        code, doc = self.fx.run("audit")
        self.assertEqual(code, pf.EXIT_REFUSED)
        self.assertIn("opinions", doc["refused"])

    def test_a_font_switch_is_dropped_from_a_rendered_title_but_not_a_word(self):
        self.assertEqual(
            pf.display_title("Complete Bounded Repair Ports:\\\\\n\\large Transfer and Structure"),
            "Complete Bounded Repair Ports: Transfer and Structure",
        )
        self.assertEqual(pf.display_title("The $\\rho$ invariant"), "The $\\rho$ invariant")

    # -- parsing units -----------------------------------------------------------------------

    def test_title_survives_a_short_title_option_and_a_nested_group(self):
        self.assertEqual(
            pf.extract_title("\\title[Short]{A {nested} title}\n"), "A {nested} title"
        )

    def test_a_commented_out_title_is_not_the_title(self):
        self.assertEqual(pf.extract_title("% \\title{Dead}\n\\title{Live}\n"), "Live")

    def test_an_escaped_percent_does_not_start_a_comment(self):
        self.assertEqual(pf.extract_title("\\title{Ninety \\% pure}\n"), "Ninety \\% pure")

    def test_normalization_removes_presentation_but_not_words(self):
        self.assertEqual(
            pf.normalize_title("A {\\em conic}--based\\\\\n  result"), "a conic-based result"
        )
        self.assertNotEqual(pf.normalize_title("A conic result"), pf.normalize_title("A cubic result"))

    def test_inputs_are_followed_into_the_facts(self):
        self.fx.track("papers/alpha/sections/one.tex", "\\begin{lemma}\\label{lem:in-input}\\end{lemma}\n")
        self.fx.track(
            "papers/alpha/alpha.tex", ALPHA.replace("\\maketitle", "\\maketitle\n\\input{sections/one}")
        )
        registry = pf.load_registry(self.fx.lean_root / "trust" / "papers.toml")
        facts = pf.extract_paper(pf.load_tree(self.fx.root), registry.by_id()["alpha"], registry)
        self.assertIn("lem:in-input", {label for label, _ in facts.labels})

    def test_page_count_reads_a_compressed_page_tree(self):
        import zlib

        body = zlib.compress(b"<</Type /Page /Parent 1 0 R>> <</Type /Page /Parent 1 0 R>>")
        self.fx.write_bytes(
            "papers/alpha/alpha.pdf",
            b"%PDF-1.5\n1 0 obj\n<</Filter/FlateDecode>>\nstream\n" + body + b"\nendstream\n",
        )
        self.fx.commit()
        registry = pf.load_registry(self.fx.lean_root / "trust" / "papers.toml")
        facts = pf.extract_paper(pf.load_tree(self.fx.root), registry.by_id()["alpha"], registry)
        self.assertEqual([pages for _, _, _, pages in facts.pdfs], [2])

    def test_an_unreadable_page_tree_is_unknown_rather_than_zero(self):
        self.fx.write_bytes("papers/alpha/alpha.pdf", b"%PDF-1.5\nnot really a pdf\n")
        self.fx.commit()
        registry = pf.load_registry(self.fx.lean_root / "trust" / "papers.toml")
        facts = pf.extract_paper(pf.load_tree(self.fx.root), registry.by_id()["alpha"], registry)
        self.assertEqual([pages for _, _, _, pages in facts.pdfs], [None])


if __name__ == "__main__":
    unittest.main(verbosity=2)
