# C683 — generated regions and title-drift gates for the summary documents

**Lane:** `build-sys`

**Date:** 2026-07-26

**Status:** REPORTED — the two summary documents and the shared paper index are now under a
title-drift gate, and the work summary carries a generated manuscript inventory

Predecessor: `2026-07-26-c681-paper-facts-area.md`. Programme intent and the remaining steps:
`2026-07-26-c681-trust-spine-paper-facts.md`.

## Why this step ran now

Step 2's gate was that the checker catch a drift defect it was not built against. It caught four:
two inline-`\bibitem` self-citations no hand pass had reached, and two paper READMEs claiming titles
their manuscripts no longer have. Every other open item in this lane needs a quiet Lean worktree,
and `lean-trust-extract.py plan` reports 16 foreign paths, so this was the only unblocked step.

## What the brief asked for, and what was built instead

The brief said to wrap the publication table in `notes/2026-07-09-work-summary.md` and the status
summary in the results snapshot in `trust-spine` markers. Its own risk note said only tabular facts
may be inside a region, and that a region wanting a sentence of judgement has its boundary in the
wrong place.

Both of those tables are judgement. The publication table's `Lead` and `State` columns are editorial
readings of where each paper stands; the results snapshot is a self-contained argument whose section
headings happen to be titles. Generating either would generate prose, which the brief rules out and
which is worse than drift because drift is visible.

So the step splits in two, and both halves ship:

**A read-only title gate**, which is where the drift risk actually lives. A `[[title_restating_doc]]`
row declares that a document names manuscripts by title, and optionally *which* manuscripts it
undertakes to name. Every listed paper's current `\title{}` must appear in it. The declaration is a
coverage fact, not a copy of a title, so it cannot itself drift into disagreeing with a manuscript.

**A generated region carrying only facts.** The work summary's §8 now opens with a generated
manuscript inventory — id, title from `\title{}`, lane, page count from the compiled PDF, and
theorem, lemma, proposition, corollary and label counts from the TeX. The hand-written ship-order
table follows it, untouched, and keeps the judgement.

## Gates now live

| document | gate | state |
|---|---|---|
| `notes/2026-07-09-work-summary.md`         | all thirteen manuscripts named by current title | green |
| `papers/papers-index.md`                   | all thirteen manuscripts named by current title | green |
| `notes/2026-07-26-results-summary-snapshot.md` | the eleven manuscripts it covers named by current title | green |
| `notes/2026-07-09-work-summary.md` §8      | generated inventory matches a fresh rendering | green |

`papers/papers-index.md` is a shared registry, and the programme defers *generated regions* in it to
a later step needing the registry writer's agreement. A read-only check that it states current
titles edits nothing and needs no such agreement, so it is switched on now — it is green today,
which means it will catch the next retitle rather than reporting a backlog.

The results snapshot covers a subset by design: the integrated Clebsch manuscript is preserved only
as a fallback and the Node Kayles paper is outside its scope, so neither is named there. Its row
declares that coverage explicitly rather than weakening the check for everyone.

## Step 3's gate is met, so its substance shipped here

Step 3 was to replace hand-written statement counts with extracted ones, gated on the extractor
agreeing with a hand count on at least two papers. It agrees exactly on three, each counted
independently with `grep -c 'begin{<env>}'` over the manuscript and every file it `\input`s:

| paper | theorem | lemma | proposition | corollary |
|---|---|---|---|---|
| `arcs_complete_outside_conic` | 8 | 4 | 5 | 21 |
| `ame_lu`                      | 7 | 4 | 7 |  6 |
| `clebsch_passages`            | 2 | 0 | 2 |  0 |

`clebsch_passages` is the useful case: its main source contains no statement environment at all, so
the agreement is evidence that `\input` resolution works rather than that a single file was read
twice. The counts are in the generated inventory, and the repository's no-stale-counts rule is now
enforced by construction for them.

## What the live tree says

`lean/scripts/paper-facts.py check` reports 15 errors and 5 warnings, unchanged in composition from
C681: eight self-citation title drifts, five generated-bibliography findings, two README title
claims. No `title-drift` against a summary document, no `generated-region-stale`, no
`region-missing`. The new gates are green because those documents are currently correct — which is
the state worth locking in, not evidence that the gates are weak: `test_a_hand_edit_inside_a_region_is_reported`
and `test_a_document_that_stops_naming_a_paper_by_its_current_title_is_reported` make both go red on
demand.

## The fixture

`python3 lean/scripts/test_paper_facts.py` — 59 tests, green, hermetic. The sixteen added here
cover the title gate (drift reported, correct document accepted, declared coverage subset respected,
unregistered paper in a coverage list refused, untracked document reported) and the region machinery
(empty region stale until generated, generation idempotent, hand edit inside a region reported,
prose outside a region preserved, declared-but-absent region reported, unknown section refused, the
rendered title carrying the manuscript's own string, and font switches dropped from a rendered title
without dropping a word), plus per-lane routing: a finding goes to the lane owning the file, an
unknown lane selects nothing rather than everything, and the longest matching directory wins.

## Addendum — per-lane routing, and what the gate saw during the repairs

While the owning lanes repaired the C681 findings, the audit was rerun. Errors fell from fifteen to
eight, and the remaining ones are informative rather than leftover:

- **The checker caught repair-induced staleness.** `papers/beyond4_prs/refs.bib` was repaired for
  `RuddRigidity2026` and `RuddFactorization2026`, and
  `prs-beyond-redundancy-four-tit-submission.bbl` immediately reported `stale-bbl` for both keys —
  the generated bibliography now disagrees with the source it was built from. That is the second
  sense of `stale-bbl`, and it had never fired before: the repair created it, and the gate saw it
  the same day.
- **A README outlived its bibliography fix.** `papers/complete-repair-ports/refs.bib` was repaired
  while `papers/complete-repair-ports/README.md` still claims the old title.

`audit` and `check` now take `--lane`, which selects only findings in artifacts that lane owns.
Attribution follows the artifact, not the paper the drift is about: a bibliography in one lane's
manuscript quoting another lane's dead title is repaired by the lane whose file it is, using the
other lane's manuscript as the source. Routing it to the cited paper's owner would send it to
someone with nothing to edit.

This is the programme's stated intent applied to its own output — a lane asks a command what it owns
instead of reading a portfolio-wide list and filtering by hand.

```sh
lean/scripts/paper-facts.py audit --lane clebsch
```

## Mystery ledger

- **Why the work summary was already clean while two READMEs had drifted.** Settled: the summary is
  edited whenever the portfolio is discussed, so its titles get refreshed as a side effect; a paper
  README is written once at directory creation and rarely reopened. The gate is therefore most
  valuable exactly where it currently finds nothing, and the drift it will catch is the next
  retitle rather than a present backlog.
- **Settled by this step: what `superseded_titles` is still for.** With the README check and the
  restating-document gate both live, the remaining uncovered case is prose that names a paper by an
  old title without claiming to give a title and without being a declared restating document. That
  is what `superseded_titles` covers, and it is now a narrow residual rather than the main
  mechanism.
- **Open: the two `beyond4_prs` rows differ only in title casing.** The preprint and the journal
  variant share sources, bibliography, statement counts and page count, so the inventory shows two
  near-identical rows. Whether they are one manuscript with two front matters or two manuscripts is
  the `reed-solomon` lane's call; the registry can express either. Gate: that lane's next pass over
  its submission variant.
- **Open: a region's `version=1` is declared but nothing enforces a version bump.** The marker
  grammar comes from the Lean spine and carries a version the renderer ignores. It matters only when
  a section's column set changes under a reader who has the old table; no gate yet.

## Scope

Files this task edited: `lean/scripts/paper-facts.py`, `lean/scripts/test_paper_facts.py`,
`lean/trust/papers.toml`, and the generated region inside `notes/2026-07-09-work-summary.md`. No
manuscript, bibliography, PDF, verification manifest, or other lane's document was edited, and no
Lake, LaTeX, or BibTeX command was run. `lean/trust/PORTFOLIO.md` and `lean/trust/graph-manifest.json`
are dirty in the worktree from another session's spine regeneration and were deliberately left
uncommitted.

## Replay

```sh
python3 lean/scripts/test_paper_facts.py     # 59 tests, hermetic
lean/scripts/paper-facts.py generate         # rewrite the work summary's manuscript inventory
lean/scripts/paper-facts.py check            # audit plus region and facts-artifact staleness
lean/scripts/paper-facts.py audit --lane <alias>  # only what that lane owns
```
