# C681 — paper-facts area for the trust spine

**Lane:** `build-sys`

**Date:** 2026-07-26

**Status:** QUEUED

## Global intent

The portfolio is now about ten manuscripts, a large Lean development, a live queue, per-lane
handoffs, and two standing summary documents, all of which restate facts about each other. Nothing
mechanically links them. Every consistency property that matters — this paper's title, this claim's
label, this theorem's count, this Lean terminal's existence — is currently maintained by a human
reading two files and noticing they disagree. That does not scale with the number of papers, and it
has already failed: four distinct drift defects were found by hand on one day in July 2026, none of
which any paper's own verifier could have caught.

The intent is to make the portfolio's cross-artifact claims **derived rather than restated**, using
the mechanism C326 already established for Lean: a reviewer declares, a checker extracts facts from
tracked bytes, and divergence is an error rather than a discovery. The end state has three
properties.

1. **A fact appears in exactly one place.** A paper's title lives in its `\title{}`. Everything else
   that names it either derives that name or is reported as drift.
2. **Portfolio-level questions are answerable by a command.** "How many theorems per paper", "which
   papers cite a Lean terminal that does not exist", "which paper directories are unregistered"
   should be a query against a facts artifact, not a session of ad-hoc greps whose answer is stale
   before it is written down.
3. **The publication release gate is checkable.** Every paper must print an adequacy appendix giving
   the Lean statements of its headline theorems verbatim. That is currently hand-transcription, which
   is precisely the operation the spine's `render` exists to replace.

This is a programme, not one task. C681 is its first step and is scoped so that it either proves the
approach on real defects or fails cheaply.

## Goal of this task

Extend the C326 trust spine with a `paper` area type whose facts are extracted from manuscript
sources rather than from Lean, and whose first job is exactly one class of defect: **drift between
what a paper is and what the repository says it is.**

The scope is deliberately one step. C681 closes when the extractor and checker catch title,
self-citation, and label drift on the current tree, and stops there.

## Why this is worth a task

Four defect classes were found by hand on 2026-07-26, each of which the spine's existing
declared-versus-facts machinery would have caught mechanically:

1. `papers/ame_lu/` had a compiled manuscript and no row in `papers/papers-index.md`.
2. The arcs paper's superseded title survived in five tracked files after the manuscript was
   retitled.
3. Six self-citations across three manuscript bibliographies name companion papers by dead titles;
   two `beyond4_prs` `.bbl` files carry those dead titles into the built PDF.
4. `notes/handoffs/2026-07-13-clebsch-paper.md` opened with a title its own later paragraphs
   contradicted.

None of these is a mathematical error and none was caught by a paper's own verifier, because each
verifier checks its paper against itself. The drift is *between* artifacts, which is the level the
spine already operates at.

## Why it is not blocked

`lean-trust-extract.py` needs a quiet Lean worktree, and all five declared gates currently report
`facts-missing`. Paper facts need none of that: they come from parsing tracked TeX, BibTeX, and
verification JSON. C681 runs no Lake command, starts no build, and does not touch the build-owner
lock. It is therefore independent of the C326 extraction window and of C287.

## Facts to extract

Per paper directory, from tracked bytes only:

- the `\title{}` argument of the manuscript's main source, normalized for line breaks and `\\`;
- the set of statement environments with their labels and per-environment counts;
- BibTeX entries whose author is the repository author, with their keys and titles;
- whether each generated `.bbl` is consistent with its `.bib`;
- the verification manifest's claim/label rows where one exists;
- the compiled PDF's page count and hash where one exists.

## Declarations to add

One registry row per paper: directory, expected title, owning lane, adopted statement labels, and
the Lean terminals the paper cites. As everywhere else in the spine, **a declaration is not
evidence**; the row exists to be contradicted by the facts.

## Findings to implement

| finding | meaning |
| --- | --- |
| `paper-unregistered` | a directory has a manuscript title and no registry row |
| `title-drift` | a tracked file states a title that is not the manuscript's `\title{}` |
| `citation-title-drift` | a self-citation's title is not the cited paper's actual title |
| `stale-bbl` | a generated bibliography disagrees with its source |
| `label-unmapped` | a manifest claim row has no manuscript label, or the reverse |
| `terminal-unknown` | a paper cites a Lean terminal the export does not have |

`terminal-unknown` must report `facts-missing`, not pass, while Lean facts are absent. A green
paper-layer audit must never read as evidence about the Lean layer.

## Scope boundary

- `build-sys` owns the schema, extractor, and checker.
- Each paper's registry row is written by that paper's lane, not by this task.
- No generated regions are inserted into another lane's files. `papers/papers-index.md` and
  `papers/papers-planning.md` stay hand-written under C681; marking them up is a later step needing
  the registry writer's agreement, exactly as `lean/trust/portfolio.toml` already records for the
  per-area manifests.
- No manuscript source, bibliography, or PDF is edited by this task. C681 reports drift; the owning
  lane repairs it.

## What to queue after step 1

Four further steps are foreseen. None is allocated: allocate each through the reserve script when
its gate is met, and never write a concrete unallocated ID into a plan. They are ordered by what
unblocks what, not by value.

**Step 2 — generated regions in the two summary documents.** Wrap the publication table in
`notes/2026-07-09-work-summary.md` and the status summary in the current results snapshot in
`trust-spine:begin/end` markers so they are rendered from facts, and let `check` fail when they
drift. These two files have no other owning lane, which is why they come first.

- *Gate:* C681 closed, and its checker has caught at least one drift defect that was not one of the
  four it was built against. A checker that only reproduces its own fixtures has not yet earned a
  writing role.
- *Lane:* `build-sys` for the renderer; the summary documents are not another lane's files.
- *Risk to watch:* generating prose. Only the tabular facts may be inside the markers. If a region
  starts wanting a sentence of judgement, the region boundary is in the wrong place.

**Step 3 — extracted statement counts replace hand-written ones.** Make per-paper theorem, lemma,
proposition, and corollary counts a rendered table, so the repository's no-stale-counts rule is
enforced by construction rather than by discipline.

- *Gate:* step 2 shipped, and the count extractor agrees with a hand count on at least two papers.
- *Note:* this is the step that answers "how many theorems have we proved" without a session of
  greps. It is cheap once step 2's rendering path exists.

**Step 4 — registry rows for `papers-index.md` and `papers-planning.md`.** Extend generated regions
into the two shared registries so their per-paper title and status rows derive from facts.

- *Gate:* steps 2–3 shipped **and** the registry writer agrees. `lean/trust/portfolio.toml` already
  records that inserting regions into a file another lane owns is a separate phase needing that
  lane's owner; the same rule applies here and is not waived by these files being shared rather than
  lane-owned.
- *Risk to watch:* these registries carry rulings and gate distances as well as facts. Only the
  factual rows are candidates.

**Step 5 — adequacy-appendix rendering.** Emit each paper's adequacy appendix — the verbatim Lean
statements of its headline theorems and the definitions they bottom out in — as a `render` view.

- *Gate:* project extraction has actually run, so Lean facts exist. Today all five declared gates
  report `facts-missing`, which is C326's remaining work and needs a quiet Lean worktree.
- *Value:* highest of the five, because it converts a publication release-gate requirement from
  hand-transcription into a derived artifact. It is last only because it is the one step that
  genuinely depends on the Lean half.

## What is deliberately never automated

Judgement stays hand-written: what blocks a release, whether a result is worth publishing, how a
claim is scoped, what a negative result means, and every vibe or priority assessment. The spine
renders facts. A document whose *argument* is generated is worse than one that drifts, because
drift is visible and generated argument is not.

## Boundary against adjacent tasks

- **Per-paper verifiers** (`verify_release.py` and friends) check a paper against itself: its own
  labels, its own certificates, its own checksums. C681 checks *between* artifacts. Neither
  subsumes the other, and C681 must not absorb per-paper verification.
- **C328** operationalizes the trust graph's evidence overlay for *novelty and literature*
  assessment — status vocabulary, assessment records, search metadata, renderer badges. C681 covers
  *artifact facts* — titles, labels, citations, counts. The two share the graph and must share node
  identity, but neither owns the other's vocabulary. If they collide it will be over node IDs; settle
  that in C328's schema, which is where node identity is already being stabilized.
- **C287** exports Lean sources to public repositories. C681 neither exports nor publishes anything.

## Findings to hand to other lanes now

Reported, not fixed, following the C326 Phase A precedent:

- **`ame-lu`:** the audit returns 67 `module-unreached-by-units` findings covering every
  `RelativeConicArcs/AMELU/` module — the same 67 files C602 froze as that paper's Lean set. They
  are owned by the `relconic` area but reached by no declared extraction unit, so no gate would see
  their declarations. The paper's trust section states that its marginal-to-rigidity chain is in the
  formal aggregate; that claim and this finding need to be reconciled by the owning lane.
- **`relconic` or whoever owns `RepairPorts`:** `lakefile.toml` declares the `RepairPorts` library
  and the portfolio registry does not list it (`lakefile-drift`).
- **`build-sys` itself:** `scripts/trust-spine-export.lean` reports `module-outside-libraries` — no
  lake target builds it, so nothing kernel-checks it.

## Acceptance

C681 closes when:

- the paper-facts extractor runs read-only over the tracked tree and produces a facts artifact;
- `audit` reports the six finding kinds above against declared paper rows;
- the four 2026-07-26 defects are reproduced as findings from a synthetic fixture, so the checker is
  shown to be discriminating rather than vacuously green;
- the three cross-lane findings above are recorded in this report and surfaced to their lanes; and
- no Lake command was run and no foreign file was edited.
