# C681 — paper-facts area and its drift-detection fixture

**Lane:** `build-sys`

**Date:** 2026-07-26

**Status:** REPORTED — extractor, checker, registry, and hermetic fixture landed; the checker is red
on the live tree with thirteen real cross-artifact defects

Brief and global intent: `2026-07-26-c681-trust-spine-paper-facts.md`.

## What landed

| Artifact | Role |
|---|---|
| `lean/scripts/paper-facts.py`      | extractor and checker: `extract`, `audit`, `check` |
| `lean/trust/papers.toml`           | declared paper registry |
| `lean/trust/paper-facts/*.json`    | one tracked facts artifact per registered manuscript |
| `lean/scripts/test_paper_facts.py` | hermetic fixture suite |

No Lake command was run, no LaTeX or BibTeX was run, and no manuscript, bibliography, PDF, or
verification manifest was edited. Every fact comes from bytes already on disk.

## The design decision that shaped the schema

The brief's registry row was to carry the paper's expected title. It does not. A title stored in
`papers.toml` would be one more restatement to keep in sync — the exact defect class the paper layer
exists to remove — so the registry declares only pointers and adoption, and every title comparison
resolves against the manuscript's own `\title{}`.

That change is what makes the self-citation check work without per-paper declarations. The rule is
stated once over the facts: **a bibliography entry naming a repository author must quote a
registered manuscript's current title, or be declared an external publication.** No row says which
BibTeX key refers to which paper, because that mapping would itself drift.

The remaining declarations are `superseded_titles` (a dead title has no other home, since the
manuscript no longer contains it), `adopted_labels`, `manifest` + `manifest_labels`, and
`lean_terminals`. All are empty today; each is the owning lane's to add, and each turns on a further
check.

## Findings implemented

| finding | fires when |
|---|---|
| `paper-unregistered`     | a tracked top-level source states a title and no row names it |
| `title-drift`            | a tracked file under a scan root states a declared superseded title, or a declared superseded title is the current one |
| `citation-title-drift`   | a self-authored bibliography entry quotes no registered manuscript's current title |
| `stale-bbl`              | a generated bibliography carries such an entry into the PDF, or disagrees with the `.bib` it was built from |
| `label-unmapped`         | an adopted or manifest claim label has no counterpart on the other side |
| `terminal-unknown`       | a cited Lean declaration appears in no extraction unit |
| `facts-missing`          | Lean terminals are cited but no Lean facts artifact exists |
| `paper-source-missing`, `paper-manifest-missing`, `bibliography-untracked`, `paper-facts-missing`, `paper-facts-stale`, `paper-facts-undeclared` | registry and artifact integrity |

`terminal-unknown` never fires while the Lean layer has no facts; `facts-missing` fires instead, so
a green paper audit cannot be read as evidence about the Lean layer. All five Lean gates still
report `facts-missing`, unchanged by this task.

`paper-facts-stale` is `warn`, not `error`. Every check that decides anything runs against a fresh
extraction, so a stale artifact never weakens a verdict — it means a lane edited its manuscript,
which is the normal state of a live paper. As an error it would put this lane's gate at the mercy of
every other lane's edits and train everyone to ignore it.

## Live-tree result: thirteen errors, all real

`lean/scripts/paper-facts.py audit` reports 13 errors and 5 warnings against the current tree. Every
error was checked by hand against the cited bytes.

**Eight self-citations name a companion paper by a title it no longer has**, across four
bibliographies — two more than the hand pass on 2026-07-26 found, and in one more bibliography.

| citing artifact | key | title quoted | actual paper |
|---|---|---|---|
| `papers/beyond4_prs/refs.bib`                    | `RuddPrescribedHoles2026`  | Arcs Complete Outside a Prescribed Conic: An Exact Defect Identity and \(\rho_{\mathcal C}(16)=9\) | `arcs_complete_outside_conic` |
| `papers/beyond4_prs/refs.bib`                    | `RuddRigidity2026`         | Deep-Hole Rigidity of the Clebsch Hexagon Code | `clebsch_hexagon_code` |
| `papers/beyond4_prs/refs.bib`                    | `RuddFactorization2026`    | Factorization Memory in a Conic Ideal: The \(A_3\), \(B_3\), and \(H_3\) Configurations | `clebsch_factorization` |
| `papers/beyond4_prs/refs.bib`                    | `RuddAMELU2026`            | Local-Unitary Rigidity and Transversal Clifford Groups for MDS--CSS AME States | `ame_lu` |
| `papers/complete-repair-ports/refs.bib`          | `RuddClebschRigidity2026`  | Deep-hole rigidity of the Clebsch hexagon code | `clebsch_hexagon_code` |
| `papers/equivariant-robust-completion/refs.bib`  | `RuddClebschRigidity2026`  | Deep-hole rigidity of the Clebsch hexagon code | `clebsch_hexagon_code` |
| `papers/clebsch-factorization/clebsch_factorization.tex` | `RuddRigidity2026` | A conic deep-hole syndrome locus characterizes the Clebsch code | `clebsch_hexagon_code` |
| `papers/clebsch-hexagon-code/clebsch_hexagon_code.tex`   | `ArcsCompleteOutsideConic` | Arcs complete outside a prescribed conic: An exact defect identity and \(\rho_{\mathcal C}(16)=9\) | `arcs_complete_outside_conic` |

The last two are inline `\bibitem` lists rather than BibTeX, and neither was in the hand pass.

**Five generated-bibliography findings** carry four of those dead titles into compiled PDFs
(`prs-beyond-redundancy-four.bbl` for all four keys,
`prs-beyond-redundancy-four-tit-submission.bbl` for `RuddPrescribedHoles2026`), one of which is also
a straight disagreement between the `.bbl` and the `refs.bib` it was built from.

**Five warnings** record `.bbl` files read as build output: they reach the compiled PDF but are
absent from every reproducibility claim made from tracked bytes.

No `paper-unregistered` finding remains: all thirteen manuscripts under `papers/` are registered,
including the two directories that hold two manuscripts each.

## Registration versus adoption

The brief scopes registry rows to each paper's own lane. The rows written here are registration
only — `id`, `dir`, `main`, `lane` — which are mechanical pointers rather than claims about anyone's
paper, and are what makes the checker non-vacuous today. Every judgement field is empty and marked
in `papers.toml` as the owning lane's to fill. Registering a manuscript asserts nothing about it;
adopting labels, manifests, superseded titles, and Lean terminals does, and that stays with the lane
that can answer for it.

The one debatable call is `lane`, taken from the routing table in `CLAUDE.md` and each lane's own
handoff. It is a pointer for routing findings, not a claim of ownership, and any lane may correct
its own row.

## The fixture

`python3 lean/scripts/test_paper_facts.py` — 39 tests, green, hermetic: throwaway git repositories
with a few tiny manuscripts, no TeX run, no Lean, no network.

The four defects found by hand on 2026-07-26 are each rebuilt in miniature and asserted to be
caught:

| 2026-07-26 defect | test |
|---|---|
| a compiled manuscript with no index row | `test_unregistered_paper_directory_is_reported` |
| a superseded title surviving in tracked files | `test_superseded_title_surviving_elsewhere_is_reported`, `test_superseded_title_is_found_across_a_line_break_and_a_tex_newline` |
| self-citations by dead title, in `.bib` and in the built `.bbl` | `test_self_citation_with_a_dead_title_is_reported`, `test_a_bibtex_self_citation_with_a_dead_title_is_reported`, `test_generated_bibliography_carrying_a_dead_title_is_reported` |
| a note whose opening title contradicts its own text | `test_drift_scan_stays_inside_the_declared_roots`, which asserts the drift is found in a `notes/` file and not outside the declared roots |

The suite is at least as concerned with the other direction. `test_green_fixture_reports_nothing`,
`test_a_correct_self_citation_is_accepted_through_tex_presentation`,
`test_a_foreign_authors_entry_is_not_a_self_citation`,
`test_a_generated_bibliography_agreeing_with_everything_is_accepted`, and
`test_a_section_file_is_not_mistaken_for_a_manuscript` pin down what must stay silent — a checker
that cannot be made green is as useless as one that cannot be made red.

## Two false positives found and closed during construction

Both were artifacts of the comparison rather than drift, and both would have taught a reader to
ignore the tool:

1. **Asymmetric normalization.** Titles had TeX control words stripped; the documents they were
   looked for in did not. `Finite \(p\)-Irregular Subgroups of \(\operatorname{PGL}_2(k)\)` in
   `papers/ame_lu/refs.bib` therefore did not match its own `.bbl` rendering. Both sides now go
   through one function.
2. **Duplicate findings.** A directory holding a preprint and a journal variant shares one
   bibliography, which was examined once per manuscript. Findings about a shared artifact now
   collapse.

A third, in the PDF page count, produced no false finding but would have produced a false fact: the
first implementation counted `/Type /Page` in the raw bytes, which is zero for every PDF in the tree
because the page tree lives in compressed object streams. Deflate streams are now inflated and
searched, a file yielding no page object is reported as unknown rather than zero, and the counts
were corroborated against each document's root `/Count`.

## Cross-lane findings

The brief listed three Lean-layer findings to hand on. Re-running `lean-trust-spine.py audit`
confirms two and retires one.

- **`relconic` or whoever owns `RepairPorts`:** `lakefile.toml` declares the `RepairPorts` library
  and the portfolio registry does not list it (`lakefile-drift`). Still open.
- **`build-sys` itself:** `scripts/trust-spine-export.lean` reports `module-outside-libraries` — no
  lake target builds it, so nothing kernel-checks it. Still open, and owned here.
- **`ame-lu`:** retired. The brief reported 67 `module-unreached-by-units` findings covering
  `RelativeConicArcs/AMELU/`. The relconic area now declares twelve AME--LU gates and inventory
  units that reach those modules, so the finding no longer fires; what remains for them is
  `facts-missing`, which is the shared extraction window rather than an area-declaration gap.

The paper layer adds two more, both reported and not repaired:

- **`reed-solomon`, `clebsch`, `ame-lu`, `relconic`, `complete-ports`, `paper-frob-eq`:** the eight
  self-citation drifts and five generated-bibliography findings tabulated above. Each is repaired by
  the lane owning the *citing* artifact, using the cited paper's current `\title{}` as the source.
- **`reed-solomon`:** four `.bbl` files under `papers/beyond4_prs/` are untracked build output that
  reaches the submitted PDFs.

## Mystery ledger

- **Why the hand pass found six self-citations and the checker finds eight.** Settled: the two extra
  are inline `\bibitem` lists inside `.tex` sources rather than BibTeX files, and a hand pass looking
  at `refs.bib` would not have reached them. Nothing unexplained remains.
- **Why `papers/clebsch-passages/` and the two `clebsch-rigidity` manuscripts produce no findings at
  all.** Settled: they have no self-citations by dead title, no `.bbl` on disk, and no adopted
  declarations yet. Their silence is the absence of an adopted declaration, not a pass — the
  registry rows for them are registration only, so no check currently has anything to compare.
- **`environment` on a section-level label reads `document`.** Settled as correct rather than
  surprising: it records the innermost enclosing environment, and a `\label` after `\section` has
  none nearer than `document`. It is a fact about the source, and the count table separates statement
  environments from it.
- **Open: whether tracking per-source SHA-256 in the facts artifacts is worth its churn.** Every
  manuscript edit by any lane makes thirteen tracked artifacts stale. This is contained today because
  the staleness finding is `warn` and no verdict depends on the artifact, but if the artifacts become
  an input to step 2's rendering, the churn becomes a diff-noise problem the spine already solved
  once with a compact manifest. Gate: the first generated region that reads these artifacts.
- **Open: `superseded_titles` is the one declaration that restates a string.** It has to, since the
  manuscript no longer contains the dead title, but it means a retitle that nobody declares is
  invisible to `title-drift`. Deriving the previous title from git history instead would close that,
  at the cost of making a fact depend on history rather than tracked bytes. No gate yet; it needs a
  real retitle to judge against.

## Acceptance

- The extractor runs read-only over the tracked tree and produces a facts artifact per registered
  manuscript. ✔
- `audit` reports the six declared finding kinds. ✔ (four fire on the live tree; `label-unmapped`
  and `terminal-unknown` are exercised by the fixture and wait on lane adoption)
- The four 2026-07-26 defects are reproduced as findings from synthetic fixtures. ✔
- The cross-lane findings are recorded and surfaced. ✔
- No Lake command was run and no foreign file was edited. ✔

## Replay

```sh
python3 lean/scripts/test_paper_facts.py          # 39 tests, hermetic
lean/scripts/paper-facts.py audit                 # 13 errors, 5 warnings on the current tree
lean/scripts/paper-facts.py check                 # audit plus facts-artifact staleness
lean/scripts/paper-facts.py extract               # rewrite lean/trust/paper-facts/*.json
```
