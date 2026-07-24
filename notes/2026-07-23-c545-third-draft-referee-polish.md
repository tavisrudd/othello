# C545 third-draft referee polish

Date: 2026-07-23

## Result

The final local referee-polish pass is complete.  The manuscript now
builds as a clean 41-page paper and addresses every manuscript-local
item in the second cold review.  No external upload, repository
publication, DOI request, or metadata registration was attempted.

## Changes

- Replaced every manual equation tag with automatic `equation`,
  `label`, `eqref` numbering.  The former duplicate (33)--(35) block is
  gone.
- Printed the six redundancy-nine test sections, all discriminant
  coefficient vectors, all B\'ezout vectors, and all four boundary
  normal forms in Appendix A.  Proposition 7.12 now cites the appendix,
  not a working-directory path.
- Added the R9 atlas-cover diagram and the Lucas Kummer/additive
  monodromy diagram.
- Added the final Proposition 7.3 table recording each stratum,
  defining equation, degree, contained case, and transverse conclusion.
- Expanded Proposition 4.3's graph-point count, Proposition 5.7's
  injective/noninjective boundary, Theorem 8.1's characteristic-two
  projectivity classification and denormalization, and Proposition
  9.2's geometric base field, two extension degrees, translation
  subgroup, connectedness, full semidirect product, and constant field.
- Clarified Theorem 1.3(b) as an all-field classification rather than a
  persistence claim for the exceptional small-field list.
- Removed the release-checklist paragraph from the introduction.
  Replaced the numbered provenance section by an unnumbered
  data/code/disclosure statement using assistance-and-responsibility
  language.
- Renamed the final mathematical section `Scope and open problems` and
  stated explicitly that arbitrary redundancy, bounded R8/R9 fields,
  the remaining Lucas strata, and the general deep-hole conjecture
  remain open.
- Moved verbatim Lean source to
  `supplement/LEAN-STATEMENTS.md`; the printed statement-adequacy
  appendix retains the exact formal interface and trust boundary.
- Added `supplement/verify.py` as the single quick-check and full-replay
  entry point and regenerated the 56-row evidence manifest.

## Validation

From `papers/beyond4_prs/`:

```text
~/.claude/bin/run-quiet "make check"
exit=0

~/.claude/bin/run-quiet "python3 supplement/verify.py"
verified 56 bundled evidence artifacts
classification records: PASS
verified classification-record hashes
```

The rendered review checked the new table, both diagrams, disclosure
page, and Appendix A.  The canonical PDF has 41 pages, 294534 bytes,
and SHA-256
`8c7e8ec1c355918ae3554a4f7474a0f427dac62274ded1641174220e8276054b`.
The full `verify.py --replay` suite was also launched through the
durable quiet runner; its completion is not claimed in this report
until that runner records a terminal result.

## Release decision

**NO EXTERNAL RELEASE YET.**  The remaining gates are C541--C544
aggregate formalization and manuscript reconciliation, an independent
final reader, a clean paper-only public checkout whose pinned external
revisions resolve, immutable repository/archive identifiers, and
author/account confirmation.  These are release gates, not reasons to
weaken the mathematical manuscript.

## Post-DOI queue recommendation

1. **C531, then C532:** classify the remaining intrinsic degree-nine
   Lucas-carrier strata and synthesize redundancy ten.  This is the
   strongest direct continuation of the paper.
2. **C535, then C536:** use Hessian--Arf functoriality to attack the
   coherent polar-flag Fano boundary and seek a uniform replacement for
   the level-by-level contained-component calculation.
3. **C533 in parallel when capacity permits:** sharpen the
   ordered-Hessian threshold without changing the classification
   architecture.
4. **C537:** compare the multi-view Gale reconstruction with Flatland
   only after the higher-redundancy line is moving again.
5. Treat bounded-field completion for redundancies eight and nine, and
   the `q=7,8,9` redundancy-seven radius premise, as separate
   completion tasks after a claim-specific feasibility gate.  They are
   valuable but have lower conceptual expected value than C531--C536.

No new task ID is needed for the first four moves: each is already
allocated.

## Extra-juice and Tao closeout

The explicit closeout asked which cheap changes would make the hardest
steps independently auditable.  It produced the R9 appendix, the
stratum table, the two diagrams, the one-command verifier, and the
slower monodromy proof.  These are all task-owned and now validated.

### Mystery ledger

- **Uniform contained components:** still open.  The paper proves
  level-specific `CC(n,j)` statements; C536 owns the first plausible
  uniform Fano-boundary theorem.
- **Other degree-nine Lucas strata:** still open.  The distinguished
  `e_7` orbit is shallow, but no classification of the complementary
  intrinsic strata is claimed; C531 owns the exact evidence gap.
- **Redundancy-ten synthesis:** blocked exactly on C531, then owned by
  C532.
- **Threshold sharpness:** the safe ordered-Hessian union polynomial
  and deletion budgets may be loose; C533 owns the sharpening gate.
- **Bounded R8/R9 fields and small R7 radii:** genuinely unclassified
  or unpromoted in the stated ranges.  They require separate
  allocation after the DOI and must not be folded into a field census
  under C531.
- **R9 six-section redundancy:** the printed B\'ezout identity uses
  only sections 1, 2, and 6; sections 3--5 are retained as independent
  regression controls.  This is settled and is not a geometric gap.

## Vibe check

Strong.  The paper now has the shape of a refereeable research article;
the remaining risk is release engineering and independent verification,
not a concealed manuscript proof gap.
