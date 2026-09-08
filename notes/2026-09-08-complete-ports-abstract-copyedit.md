# Complete-ports: abstract and obvious copy edits

**Lane**: `complete-ports`
**Date**: 2026-09-08
**Status**: edits implemented; final validation pending.

The user asked for obvious copy edits, whether the abstract was ideal, and
explicitly instructed against bloating it with secondary results or machinery.
The abstract was accurate in broad scope but read like a contents list. Replaced
it with a focused account of labelled exact composition, equation escape versus
minimal-support confinement, and the direct reliability/allocation consequence.
Removed relative weights, nested-pair machinery, antichains, examples, software,
and verification prose from the abstract. Those topics retain their proper
locations in the manuscript.

The bounded copy-edit scan also removed a duplicated verification roadmap,
replaced “equation-nonconfinement cost” with “equation escape cost,” and replaced
vague first-new-alternative phrasing with the new external repair threshold.
No adjacent repeated-word typo was found in the driver and included section
sources. This is a bounded copy edit, not a claim of exhaustive proofreading.
All theorem and proof environments remain byte-identical. Formal annotations,
claim digests, and coverage are unchanged. No new Lean, implementation, or
literature claim.

The first compressed candidate had 103 words under the release checker and
was rejected by its existing 140--200-word editorial range. The revision meets
that unchanged range by explaining the primary mechanism and guarantees; no
secondary result or machinery was restored. The user additionally requested
resuming the same cold reader with the diff, then updating the portfolio summary.
Those follow-up steps are pending.

## Returning referee and portfolio summary

The same independent referee resumed with the complete source diff from its
reviewed baseline to `e4c29b92f`; this was a revision follow-up, not another cold
read. Its report is `notes/2026-09-08-complete-ports-referee-followup.md`, retained
unchanged. It recommends keeping the focused abstract and finds no introduced
theorem defect. Its sole requested qualification is applied: increasing outer
dual distance eventually supplies only the outer bound; the displayed inner
inequality is still required for equation confinement.

After receiving that report, refreshed only the complete-ports material and
obsolete bundled-engine links in `papers/summary/README.md`. The abstract is
transcribed verbatim with inline math converted to Markdown. The highlighted
result, exact-result row, paper table, and non-specialist guide now foreground
labelled composition and minimal-support transfer, with formal coverage stated
accurately. Software benchmark assertions were not revised or newly audited.
Their links now use the separate canonical repository rather than the removed
bundled directory. Public accessibility is not newly certified.

Canonical result wording lives first in CP-S01--04 of
`notes/2026-09-07-complete-ports-claim-proof-novelty-ledger.md`; the summary quotes
it. This introduces no novelty or priority verdict. A direct consistency check
confirms all four quotations, exact abstract agreement after math rendering,
and removal of the obsolete engine-subdirectory links. The summary mirror's
baseline README agreed byte-for-byte with the authority before this edit.

## Acceptance and ej + tt closeout

The focused title page was visually inspected and remains legible. The full
release gate passed before the returning referee's one-sentence qualification;
the deterministic rebuild after that qualification also passes at 44 pages.
The explicit ej + tt pass checked summary drift and witness semantics: canonical
wording now says that retained minimizing lifts reconstruct witnesses. A table
structure check also caught pre-existing unescaped cardinality bars in this
paper's MDS row; escaping them preserves the formula and restores three cells.
Abstract equality, canonical quotations, and isolation from unrelated paper
entries were checked directly. No broad novelty or implementation audit is
claimed.

### Mystery ledger

No genuine mathematical mystery remains in this bounded copy-edit/abstract
response. Divergence of outer dual distance supplies its outer bound only; the
inner escape obstruction remains. The returning referee found no theorem defect
and requested no further abstract revision. C325 and aggregate C953 verification,
including public artifact accessibility, remain separate open gates. These were
task-owned editorial findings; no incidental discovery entry is warranted.
