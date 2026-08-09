# C897 Paper III layered-exposition revision plan

**Lane:** `clebsch`

**Date:** 2026-08-09

**Status:** plan only; manuscript implementation not started

**Reference artifact:** standalone commit
`9fe1f912d0fb48d61a1b2587387d1a2516c3afb8`, 32 pages, PDF SHA-256
`a9e270277638e0a345d5385d73f6186df47dd68074a70675af3e31deca83090d`

## Editorial decision

Preserve the full theorem package.  Address the remaining density and unity
concerns through the repository style guide's layered, two-track architecture:
make the arithmetic source--operator shadow--harmonic return the uninterrupted
first-pass route, and place the exchange-spectrum and reconstruction theorems
after the operator bridge as visibly independent specialist consequences.

This is a hierarchy revision, not a proposal to dilute proofs, remove exact
data, or split the article.  A split can be reconsidered only if blind readers
still cannot follow the central route after the layering pass.

## Audiences and routes

The primary audience is algebraic geometers and invariant theorists interested
in the Clebsch cubic, Hitchin's incidence geometry, and exact arithmetic
descent.  Adjacent audiences are algebraic combinatorialists working with
conference matrices and two-graphs, and harmonic analysts interested in the
degree-six Gaunt realization.

The intended first-pass route is:

1. the introduction and source--shadow--return diagram;
2. the rational incidence cover;
3. the marked orientation source;
4. arithmetic specialization;
5. the outer-family setup and four cubic shadows; and
6. the degree-six harmonic return.

The exchange-spectrum classification and aligned-design reconstruction remain
complete main-body theorems, but are marked as independent consequences that a
reader may skip without losing the source--shadow--return proof.  The marking
and verification appendices remain audit layers rather than first-pass prose.

## Current hierarchy problem

The paper already has the right conceptual diagram and repeatedly states that
the numerical harmonic theorem and reconstruction theorem are logically
independent.  Its physical order does not yet honor that hierarchy.  In
Section 5, a first-pass reader reaches the general exchange-spectrum theorem
and the long seven-point reconstruction/query development before the four
cubic shadows that form the central operator bridge.  The section opening also
presents all three results at equal rhetorical weight.

The abstract has the same flattening effect: the arithmetic cover, four-shadow
identity, exchange classification, sharp reconstruction theorem, query count,
classical cubic outputs, and harmonic return all receive near-equal space.
Several later introduction paragraphs then repeat the dependency structure in
slightly different forms.  The result is accurate but makes optional breadth
feel like a prerequisite.

## Proposed manuscript architecture

### Stable theorem identities

The revision refers to theorem-like statements only by their existing stable
semantic labels:

- `thm:arithmetic-main`;
- `thm:orientation-source`;
- `prop:golden-fibre`;
- `prop:spinor-specialization`;
- `thm:operator-shadows`;
- `thm:balanced-exchange-rigidity`;
- `thm:aligned-faithfulness`; and
- `thm:harmonic-main`.

TeX prose must continue to use `Theorem~\ref{...}` or
`Proposition~\ref{...}` rather than a literal rendered number.  Notes, trust
rows, release metadata, and verification scripts use the backticked semantic
label.  Reordering changes rendered numbers but does not rename an identifier
or change its evidence ownership.

The statement extractor currently records an ordered `EXPECTED_LABELS` tuple.
The mechanical Section 5 move must change only that tuple's document order so
that `thm:operator-shadows` precedes `thm:balanced-exchange-rigidity` and
`thm:aligned-faithfulness`.  The stable labels, statement text, and trust-row
links remain unchanged.  A source scan must reject any new literal
“Theorem N.N” or “Proposition N.N” reference before the authority freeze.

### Abstract

Use three rhetorical layers rather than a compressed table of contents.

1. State the rational cover and exact normalization:
   `Q(P(H))(sqrt(5 J_0))`, the complete golden fibre, and
   `iota_t^* J_0 = 16 sigma_3^2`.
2. State the governing marked mechanism: the selected sheet supplies the
   relative orientation of the conference source; its four exact operator
   descriptions give the classical cubic shadows; the Petersen map returns
   the sign to the degree-six Gaunt cubic.
3. Give one final sentence for the two independent structural consequences:
   order-six exchange rigidity and sharp aligned-four-set reconstruction.

Retain the sharp order-seven boundary because it distinguishes the
reconstruction theorem.  Remove the detailed decoder query count and the full
list of downstream classical models from the abstract; both remain prominent
in their theorem statements and the body.

### Introduction

Keep Figure 1 as the sole conceptual diagram.  It already shows the
multi-stage correspondence more efficiently than another table or figure
would.

Immediately after the figure, add a short first-pass reading map:

> The main route runs through the incidence cover, its marked pullback, the
> four operator shadows, and the harmonic return.  In Section 5 the exchange
> and reconstruction subsections are independent consequences of the same
> conference carrier and may be skipped on a first reading.

Use the rational fibre over `[xyz]` as the model case explicitly.  The current
paragraph explaining that its unordered fibre is rational while either sheet
requires `Q(sqrt(5))` already contains the mechanism in miniature.  Add one
sentence identifying it as the specialization that later determines the
global twist, and call back to it at the start of the specialization proof.

Consolidate the existing roadmap material after the relative-orientation
proposition.  Give each navigational device one job:

- Figure 1 explains the objects and arrows.
- One proof-strategy paragraph explains why the arithmetic twist, marked
  operator source, and harmonic return work.
- The reading map identifies the independent branches and safe skips.
- The literature paragraphs assign ownership and novelty.

Delete or merge repeated statements that the harmonic theorem is independent,
that the cubics live on different spaces, and that the bridge is relative to a
marking.  Each boundary must remain at its first load-bearing use and in the
marking appendix, but it need not be restated in every overview paragraph.

### Section 5

Retain the outer-family setup and exact coefficient table at the beginning.
Then reorder the three subsections as follows:

1. **Four cubic shadows** (`thm:operator-shadows`).  Move the present core subsection directly after
   the outer-family setup.  Include its orientation/Hodge convention,
   mechanisms diagram, theorem, complementary-minor proof, and determinant-line
   explanation.
2. **Exchange spectra of symmetric conference matrices**
   (`thm:balanced-exchange-rigidity`).  Present this as the first independent
   structural consequence of the carrier.
3. **Reconstructing the signing** (`thm:aligned-faithfulness`).  Present aligned-design faithfulness, its
   sharpness, query models, and literature comparison as the second independent
   consequence.

The four-shadow proof does not use the balanced-exchange or aligned-design
theorems.  Its inputs are the outer-family setup, the conference tight-frame
identity from the marked-orientation section, the Hodge convention, and direct
conference-class calculations.  The proposed move therefore creates a safe
skip rather than hiding a dependency.

Replace the current Section 5 opening by a two-track orientation paragraph:

> The main route of this section identifies four exact descriptions of the
> marked cubic and then passes to the harmonic return.  The later exchange and
> reconstruction subsections prove independent structural consequences of the
> same conference carrier.

After the four-shadow proof, add a single transition that explicitly releases
the first-pass reader to the harmonic section.  Do not repeat the full
source--shadow--return summary there.

Mechanical consequences of the move must be audited:

- preservation of every semantic theorem ID and resolution of every
  `\ref`/`\label`;
- “above,” “below,” “next,” and “preceding” references;
- the statement-identity snapshot;
- PDF figure placement and page breaks; and
- references from the introduction, conclusion, README, and artifact prose to
  numbered theorems or subsections.

### Conclusion

Begin with the completed mathematical bridge rather than the integral-model
boundary.  Use this order:

1. rational descent and the golden fibre determine the exact cover;
2. the marked source has four operator descriptions and returns through the
   Petersen four-space to `sigma_3`;
3. exchange rigidity and aligned reconstruction are independent consequences
   of the carrier; and
4. the exact integral exceptional-prime problem remains open.

Compress the two independent consequences to one paragraph.  Keep the final
sentence mathematical: the marked golden source has four operator
descriptions, its outer coordinates recover the classical models, and its
Petersen image returns to the same invariant cubic.

## Material to preserve

The layering pass must not weaken the features that the cold reads found
successful:

- the reduced branch-cycle proof and complete reduced golden fibre;
- the exact internal rational normalization of `J_0`;
- the operational gloss “a synthematic total, that is, a one-factorization of
  `K_6`” and other one-time translations at disciplinary interfaces;
- the separation of switching, relabelling, Galois conjugation, chart scaling,
  determinant-line orientation, and deck exchange;
- the full complementary-minor calculation and the corrected sign table;
- the exact seven-point reconstruction proof, sharp six-point witness, and
  distinction between fixed and adaptive query models; and
- the human/formal/computational trust boundaries.

Do not add a second overview diagram, results table, tutorial background, or
new repeated marking disclaimer.  The revision should pay for its reading map
by deleting duplicated orientation prose.

## Change-control, sync, and test checkpoints

All manuscript edits occur in the authoritative
`papers/clebsch-passages/` tree.  The standalone mirror is never hand-edited.
To prevent a small copy edit from causing repeated PDF, identity, manifest,
and mirror churn, generated artifacts and the mirror are refreshed only at
the explicit freeze points below.

### Checkpoint 0 — immutable baseline

- Record the authority commit, standalone commit, PDF hash, page count, and a
  clean mirror status.
- Save page locations for Figure 1, Table (5.1), Figure 2, the statements with
  IDs `thm:operator-shadows`, `thm:balanced-exchange-rigidity`,
  `thm:aligned-faithfulness`, and the conclusion.
- Run the existing paper-only aggregate once to establish the baseline.  Do
  not run Lean.

### Checkpoint 1 — mechanical source move

- Move the complete `thm:operator-shadows` subsection before the two
  independent subsections without copy editing its mathematical content.
- Update only directional transitions and the ordered stable-ID list in the
  statement extractor.
- Run a scratch TeX build, unresolved-reference check, stable-ID uniqueness and
  expected-set check, spacing lint, and `git diff --check`.
- Confirm by source dependency scan that the moved proof cites neither
  `thm:balanced-exchange-rigidity` nor `thm:aligned-faithfulness`.
- Do not update the tracked PDF, statement snapshot, authority commit, or
  standalone mirror yet.

### Checkpoint 2 — layered copy edit

- Edit the Section 5 opening and release-to-harmonic transition.
- Reshape the abstract, consolidate the introduction's roadmaps, mark `[xyz]`
  as the model case, and rebalance the conclusion.
- After each source file is finished, run the fast checks: scratch build,
  unresolved references, forbidden literal theorem-number scan, spacing lint,
  and `git diff --check`.
- Compare theorem environments byte-for-byte, keyed by stable ID, against the
  baseline.  Apart from their location and any explicitly approved theorem
  prose edit, statement bodies must be unchanged.
- Still do not touch the mirror or refresh generated artifacts.

### Checkpoint 3 — authority freeze

- Review the whole source diff for accidental changes to hypotheses,
  quantifiers, citations, equations, labels, and trust language.
- Regenerate `verification/statement_identity.json` once, rebuild the tracked
  PDF once, and update any page-count expectation once.
- Run the complete paper-only release aggregate and inspect all changed PDF
  pages, floats, tables, diagrams, headings, and page breaks against the
  baseline.
- Stage only Paper III authority and C897 memo paths, run `git diff --cached
  --check`, and commit one coherent authority revision.

If a copy edit is required after this freeze, make it in authority and repeat
Checkpoint 3.  Do not patch the generated identity, PDF, export manifest, or
mirror independently.

### Checkpoint 4 — one-way standalone synchronization

- Run exporter `plan` and the repository-specific coupling `audit` from the
  immutable authority commit.
- Require the standalone worktree to be clean, then run the normal one-way
  `sync` exactly once for that authority commit.
- Commit the standalone refresh, run exporter `verify`, run the standalone
  paper-only release aggregate, and confirm that authority and mirror PDFs
  have identical hashes and page counts.
- No push, publication, deposit, or submission belongs to this plan.

If the mirror exposes a defect, repair authority first and restart at
Checkpoint 3.  Never repair export drift in the mirror.

### Checkpoint 5 — blind layered-exposition validation

- Freeze the new standalone commit and PDF hash before dispatch.
- Give a primary-audience specialist and an adjacent-field reader the old and
  new PDFs without the revision rationale.  Ask for a blind preference and
  separately record specialist confidence, first-pass route comprehension,
  safe-skip accuracy, and trust-boundary visibility.
- If either reader finds a hidden dependency or reduced specialist confidence,
  return to authority and restart at Checkpoint 2 or 3 as appropriate.  Do not
  iterate by copy editing the mirror.

## Implementation sequence

1. Execute Checkpoints 0--1 to establish the baseline and perform the
   dependency-preserving mechanical move.
2. Execute Checkpoint 2 in the order Section 5, abstract, introduction, then
   conclusion; keep the mirror untouched.
3. Freeze and commit authority at Checkpoint 3, refreshing generated artifacts
   only once after the copy is stable.
4. Export the immutable authority commit through Checkpoint 4.
5. Run the two-reader blind comparison in Checkpoint 5.  Any adopted change
   restarts from authority rather than creating mirror-only churn.

Per author direction, this plan includes no Lean work.  Any later Lean replay
or follow-up is separately queued.

## Acceptance tests

The revision is successful only if all of the following hold.

- A reader following the stated first-pass route reaches the four-shadow and
  harmonic theorems without traversing either independent Section 5 branch.
- Skipping those branches hides no hypothesis, definition, completeness step,
  exceptional case, or change of mathematical language needed by the main
  route.
- The abstract makes the arithmetic cover and marked source--shadow--return
  mechanism dominant while still naming both independent contributions.
- Figure 1, the proof-strategy paragraph, and the reading map perform distinct
  jobs and do not repeat one another.
- The first use of each cross-disciplinary term retains its operational gloss,
  and every marking/projectivization convention remains visible where needed.
- The theorem statements and proofs are mathematically unchanged apart from
  rendered numbering and local transition language; every stable semantic ID
  and trust/evidence mapping is preserved.
- The revised PDF has no warning, stale snapshot, bad float, orphaned heading,
  or unreadable exact table.
- A blind primary reader reports unchanged specialist confidence, while an
  adjacent-field reader can identify the main theorem, every language change,
  the safe skips, and the trust boundary more quickly than in the frozen PDF.

## Reviewer questions

The plan should be reviewed independently from two perspectives.

1. Does moving the four-shadow theorem before the two independent conference
   consequences create any hidden logical dependency or distort the paper's
   strongest contribution?
2. Is the proposed first-pass route complete, and are the safe skips honest?
3. Does the abstract plan preserve enough prominence for the exchange and
   reconstruction theorems?
4. Which repeated introduction or conclusion passages can be removed without
   losing a load-bearing convention or trust boundary?
5. Would this layering answer the density/unity concern without requiring a
   paper split?
