# Complete-ports: improvement and literature-audit closeout

Date: 2026-09-07. User scope: improve the manuscript, consult the paper style
guide, resume Astra feedback, and perform the literature audit under the named
conventions. The subsequent question about removable material is answered as
an editorial recommendation; those deletions have not been applied.

## Completed changes

- Made the reliability construction's properness argument explicit with
  rational line/point seeds, finite exclusions, generic heights and common-prime
  reduction. Removed the duplicate incidence table.
- Stated the fixed-query DP invariant, distinguished affine compatibility from
  actual local-table realization, and separated pair counts from arithmetic
  work. Removed repeated repricing explanations.
- Rewrote the related-work comparisons around what established results already
  provide and what exact reverse confinement adds. Corrected the coset-weight
  contrast and the implication that prior recovery methods lack coefficients.
  Added the minimal-support service-region predecessor and the current online
  batch-model reference. Eight exact arXiv-version links now render in the PDF.
- Retained the primary coding-theory route and its binary example for adjacent
  optimization readers. Ergodis remains explained through compatible choices,
  workloads, failures and executable witnesses; no new feature inventory was added.

The literature record is `2026-09-07-complete-ports-literature-audit.md`, with
the owning claim–proof–novelty ledger and two search-record JSON files alongside
it. Its eleven sources were read at specified passages, not in full; no
publication-priority or exhaustive citation-graph verdict is claimed.

## Referee disposition

`2026-09-07-complete-ports-proof-clarity-followup.md` records the initial bounded
proof suggestions. `2026-09-07-complete-ports-audit-astra-followup.md` records
the resumed journal-style assessment of the revised proofs, positioning and
rendered passages. Astra had no remaining major comment in that scope. Its
minor equation-versus-minimal-support terminology correction was applied and
rebuilt. Neither report is a new full cold read or the aggregate C953 verdict.
No numerical assessments were saved.

## Validation and export

- Authority commits: `de215e5c0` (proofs, audit and references), `d42414dc6`
  (final referee clarification and report).
- `make update-pdf check` passes in the authority; `make check` passes in the
  standalone repository. The unchanged checker requires byte-identical
  deterministic regeneration. Its page-count identity was refreshed from 44
  to the observed 45; the warning, claim-map and formal-scope checks were retained.
- Result: **45 pages, warning-free, 32 registered claims, four unchanged Lean
  terminals**. No Lean execution or new benchmark measurements.
- Visually reviewed pages 1–2, 22–25, 29–30 and 43–45, with the final terminology
  page and changed bibliography rerendered after their last edits. Astra also
  inspected pages 22–25 and 29–30. No claim of a fresh full-PDF cold review.
- Eleven cited cache PDF hashes match the manifest; all four retained search
  batch counts match their JSON entry counts (77 entries including duplicates).
- Guarded export audit: zero findings. Export verification: 46 tracked files,
  corresponding to 43 distributed files and three exporter metadata files.
- Final mirror commit: `c3a63ed`, following ordinary forward commit `85e29e3`.
  No push or deposit. Authority and mirror PDFs are byte-identical.
- PDF SHA-256:
  `f3d417fc2d27de7f955c6ace41c29e3cf018af2346bd8de24e5855aa8363c2f4`.
- Canonical export content SHA-256:
  `7217ed48e76406d23846eb61849b320ff45826acb1a2172976608042fc0bbbe6`.

## What can be removed without weakening the theorem contribution?

The strongest low-risk reduction is roughly four to five pages, subject to
typesetting, while retaining all stated mathematical results:

1. Move the detailed measurements on pages 39–41 to the Ergodis benchmark
   documentation. Keep a compact worked mathematical application and one
   pointer to versioned evidence. This removes protocol descriptions, six-task
   speedup tables and the benchmark graphic from this manuscript.
2. Reduce formal-verification packaging to a short exact coverage statement:
   the associated-pair exact sequence is checked; the other results have human
   proofs. Declaration names, toolchain hash and detailed replay metadata can
   remain in the companion verification documentation.
3. Delete the standalone programme-perspective coda. The running example,
   information hierarchy and conclusion already express its paper-specific
   point.
4. Move the bandwidth and adversity-catalog outlook out of the conclusion,
   retaining at most a brief future-work pointer. These are sequel material,
   not steps in the paper's proof chain.
5. Compress the conclusion's repeated account of labels, supports and
   observations to the exact transfer distinction and its operational consequence.

The contextual separator machinery could move to an appendix with its theorem
and interpretation retained in the main text. That is a main-text organization
change, not a reduction in total mathematical content. Deleting that theorem or
the bilinear worked extension would sacrifice a contribution or an application;
neither is being called a free cut. Keep the exact confinement formula, minimal
support theorem, coefficient/support separation examples, binary running example
and substantive Ergodis explanation.

## Mystery ledger and next route

The explicit `ej`/`tt` closeout is in the literature audit. It settled the
expository properness and DP-realization gaps and sharpened the one-way versus
reverse-transfer comparison. No additional mathematical mystery was identified.
Broader novelty coverage remains an evidence task, not an unproved assertion.
C325 and C953 remain open, followed by C955. The user's possible pruning pass
is not silently treated as accepted or performed.
