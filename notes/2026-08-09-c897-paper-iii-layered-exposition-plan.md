# C897 Paper III layered-exposition revision plan

**Lane:** `clebsch`

**Date:** 2026-08-09

**Status:** implementation accepted; paper-only and blind gates green;
official standalone synchronization pending

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
   descriptions give the Joubert--Segre--Igusa--Clebsch chain; the Petersen map
   gives the degree-six Gaunt realization and computes its exact normalized
   restriction.  Say separately that its sign comparison is relative to the
   marked bridge datum.
3. Give one final sentence for the two independent structural consequences:
   order-six exchange rigidity and sharp aligned-four-set reconstruction.

Retain the sharp order-seven boundary because it distinguishes the
reconstruction theorem.  Remove the detailed decoder query count from the
abstract; it remains prominent in `thm:aligned-faithfulness` and its proof.

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
global twist.  Call back to it where `thm:arithmetic-main` actually determines
the twist, at “Square class from one fibre” or “The local comparison at
`xyz`” in `sec:cover`; the later arithmetic-specialization section explains
the exchanger and spinor consequence rather than first determining the square
class.

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
The abstract and conclusion must nevertheless retain the exact scope: only
after fixing the marked bridge datum does the sheet select the marked source
or its opposite; the sheet does not supply the ordering, chart lift, outer
labels, or Petersen labels.  Near the harmonic return, state once that
`Z_{\mathfrak m}` and `\sigma_3` live on different spaces and that no ambient
`SO_3`-equivariant map is asserted.

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

One definition now lives too late for that move.  Relocate the exact
four-point two-graph parity equation and a one-clause switching/complement
gloss from the reconstruction subsection into the outer-family setup.  Leave
aligned sets, `\mathcal A(\tau)`, reconstruction tables, and query models in
the independent branch.  Also define `\operatorname{center}_T` explicitly
before its first use in `thm:operator-shadows`.

Replace the current Section 5 opening by a two-track orientation paragraph:

> The main route of this section identifies four exact descriptions of the
> marked cubic and then passes to the harmonic return.  The later exchange and
> reconstruction subsections prove independent structural consequences of the
> same conference carrier.

After the four-shadow proof, add a single transition that explicitly releases
the first-pass reader:

> For the main source--shadow--return route, continue with
> Section~`\ref{sec:harmonic}`.  The next two subsections use the same
> conference carrier but supply no hypothesis for `thm:harmonic-main`.

Distinguish the elementary switching recovery inside `thm:operator-shadows`
from the later global aligned-design reconstruction, since similar vocabulary
must not suggest a false dependency.  Do not repeat the full
source--shadow--return summary in this transition.

Mechanical consequences of the move must be audited:

- preservation of every semantic theorem ID and resolution of every
  `\ref`/`\label`;
- “above,” “below,” “next,” and “preceding” references;
- the statement-identity snapshot;
- PDF figure placement and page breaks; and
- references from the introduction, conclusion, README, and artifact prose to
  numbered theorems or subsections.

Inventory all literal rendered theorem and proposition numbers across the
manuscript, README, artifact prose, and verification material, not merely new
ones.  Replace internal literals by semantic-label references.  Separately
audit the stable labels for sections, equations, figures, and tables affected
by the move; theorem IDs do not protect those navigation targets.  Assign
stable labels `tab:outer-coefficient-words`, `eq:two-graph-parity`, and
`eq:aligned-pair-criterion` to the displays tagged (5.1), (5.2), and (5.3),
replace their internal hard-coded references by label references, and preserve
the existing `fig:source-shadow-return` and `fig:four-cubic-shadows` labels.
Do not rewrite bibliographic locators such as “Table 1” in a cited source.

### Conclusion

Begin with the completed mathematical bridge rather than the integral-model
boundary.  Use this order:

1. rational descent and the golden fibre determine the exact cover;
2. the marked source has four operator descriptions and returns through the
   Petersen four-space to an exact multiple of `sigma_3`, with the relative
   sign fixed only after the marked bridge datum is supplied;
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
  clean authority and mirror status.
- Save page locations for `fig:source-shadow-return`, the display that will
  receive `tab:outer-coefficient-words`, `fig:four-cubic-shadows`, the
  statements with IDs `thm:operator-shadows`,
  `thm:balanced-exchange-rigidity`, `thm:aligned-faithfulness`, and the
  conclusion.
- Run the existing paper-only aggregate once to establish the baseline.  Do
  not run Lean.

### Checkpoint 1 — mechanical source move

- Move the complete `thm:operator-shadows` subsection before the two
  independent subsections without copy editing its mathematical content.
- Update only directional transitions and the ordered stable-ID list in the
  statement extractor.
- Run a scratch TeX build, unresolved-reference check, stable-ID uniqueness and
  expected-set check, spacing lint, and `git diff --check`.
- Put every scratch build and non-mutating statement extraction in an isolated
  temporary output directory.  Assert afterward that no tracked PDF, auxiliary
  file, snapshot, manifest, or checksum changed.
- Confirm by source dependency scan that the moved proof cites neither
  `thm:balanced-exchange-rigidity` nor `thm:aligned-faithfulness`.
- Compare the whole moved subsection against its baseline hash after
  normalizing only the expected directional transitions.
- Do not update the tracked PDF, statement snapshot, authority commit, or
  standalone mirror yet.

### Checkpoint 2 — layered copy edit

- Edit the Section 5 opening and release-to-harmonic transition.
- Reshape the abstract, consolidate the introduction's roadmaps, mark `[xyz]`
  as the model case, and rebalance the conclusion.
- After each source file is finished, run the fast checks: scratch build,
  unresolved references, forbidden literal theorem-number scan, spacing lint,
  and `git diff --check`.
- Run the statement extractor with a temporary `--output` path; its tracked
  `--check` mode is expected to fail while the snapshot is intentionally stale.
- Compare the baseline and candidate maps `stable label -> statement SHA-256`
  byte-for-byte.  Apart from location and any explicitly approved theorem
  prose edit, statement bodies must be unchanged.  Treat expected JSON changes
  to order, source lines, and section hashes as movement metadata rather than
  theorem drift.
- Still do not touch the mirror or refresh generated artifacts.

### Checkpoint 3 — authority candidate freeze

- Review the whole source diff for accidental changes to hypotheses,
  quantifiers, citations, equations, labels, and trust language.
- Regenerate `verification/statement_identity.json` once, rebuild the tracked
  PDF once, and update any page-count expectation once.
- Run the complete paper-only release aggregate without `--lean-root` and
  inspect all changed PDF pages, floats, tables, diagrams, headings, and page
  breaks against the baseline.
- After every generator, compare changed paths against an explicit allowlist;
  reject any auxiliary, unrelated-paper, or unexpected manifest change before
  staging.
- Freeze the candidate PDF hash and source diff for blind review, but do not
  commit authority yet.  This keeps rejected copy edits and their generated
  artifacts out of permanent history.

If a copy edit is required after this freeze, make it in authority and repeat
Checkpoint 3.  Do not patch the generated identity, PDF, export manifest, or
mirror independently.

### Checkpoint 4 — blind layered-exposition validation

- Freeze the authority candidate PDF and hash before dispatch.  If reviewers
  require standalone layout, create a disposable exporter-derived review
  checkout and do not commit it.
- Give a primary-audience specialist and an adjacent-field reader the old and
  new PDFs without the revision rationale.  Counterbalance old/new reading
  order, conceal version identity where practical, and give both readers the
  same task sheet.
- Record navigation errors and comprehension errors as well as time.  Require
  the adjacent reader to identify the exact safe skips and every language
  transition.  Ask the primary reader whether moving the independent theorems
  later reduced their perceived importance or specialist confidence.
- If either reader finds a hidden dependency, reduced specialist confidence,
  or a failed safe skip, return to authority and restart at Checkpoint 2 or 3.
  Do not create an official mirror commit.

### Checkpoint 5 — one-way standalone synchronization

- After the blind gate passes, rerun the authority changed-path allowlist,
  release aggregate, and rendered-page check.  Stage only declared Paper III
  authority and C897 memo paths, run `git diff --cached --check`, and commit one
  coherent authority revision.
- Run exporter `plan` and the repository-specific coupling `audit` from the
  immutable authority commit.
- Require the standalone worktree to be clean, then run the normal one-way
  `sync` exactly once for that authority commit.
- Commit the standalone refresh, run exporter `verify`, run the standalone
  paper-only release aggregate without `--lean-root`, and confirm that
  authority and mirror PDFs have identical hashes and page counts.
- No push, publication, deposit, or submission belongs to this plan.

If the mirror exposes a defect, repair authority first and restart at
Checkpoint 3.  Never repair export drift in the mirror.

## Implementation sequence

1. Execute Checkpoints 0--1 to establish the baseline and perform the
   dependency-preserving mechanical move.
2. Execute Checkpoint 2 in the order Section 5, abstract, introduction, then
   conclusion; keep the mirror untouched.
3. Freeze the uncommitted authority candidate at Checkpoint 3, refreshing
   generated artifacts only after the copy is stable.
4. Run the two-reader blind comparison at Checkpoint 4 before creating the
   official standalone refresh.  Any adopted change restarts from authority.
5. Commit the accepted authority candidate and export that immutable commit
   once through Checkpoint 5.

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

## Independent plan-review disposition

Two independent readers reviewed the frozen first draft of this memo against
the full style guide and the 32-page standalone paper.  The Hitchin-style
arithmetic/harmonic reader and Snowden-style invariant-theory/editorial reader
both returned `APPROVE WITH CHANGES`.  Neither found a dependency from
`thm:operator-shadows` to `thm:balanced-exchange-rigidity` or
`thm:aligned-faithfulness`, and both judged layering sufficient without a
split.

The revised memo adopts their substantive amendments:

- preserve the exact normalized harmonic restriction and the named
  Joubert--Segre--Igusa--Clebsch chain in the abstract;
- call back to `[xyz]` inside the proof of `thm:arithmetic-main`, where it
  determines the twist;
- preserve the full marked-relative and different-domain boundaries;
- move the four-point two-graph equation into the shared setup and define
  `\operatorname{center}_T` before `thm:operator-shadows`;
- make the safe skip point directly to `sec:harmonic` and state that the two
  later theorems supply no hypothesis to `thm:harmonic-main`;
- compare stable-label statement hashes and isolate all scratch generation;
- move blind validation before both the authority commit and the one official
  standalone synchronization; and
- counterbalance the blind comparison and record navigation errors, perceived
  theorem importance, specialist confidence, and adjacent-reader comprehension
  separately.

## Implementation and blind disposition

The accepted authority candidate implements the planned order and prose
layers.  The operator theorem now immediately follows the shared outer-family
setup, while the exchange-spectrum and reconstruction theorems follow an
explicit safe-skip transition.  The exact two-graph parity equation lives in
that shared setup, `\operatorname{center}_T` is defined before first use, and
the abstract, introduction, `[xyz]` proof callback, and conclusion preserve
the exact harmonic coefficient, marking boundary, different-domain warning,
and named Joubert--Segre--Igusa--Clebsch chain.

The frozen candidate retained all eight theorem-statement SHA-256 values when
compared by stable semantic label.  Its warning-free deterministic PDF has 32
pages and SHA-256
`0ee06115a2817e8bdd4c1ff1618e4f5b935f9a21e5d045b481d424e2254b3fb8`.
The complete paper-only release aggregate passed; by author direction the Lean
gates remained explicitly unchecked.

The final `ej`+`tt` durability pass made the stable-reference policy
executable: the manuscript source-hygiene lint now rejects literal internal
theorem, proposition, lemma, or corollary numbers while allowing numeric
locators inside citations.  A rejecting sentinel and the full release
aggregate both passed.

Two sealed readers received anonymous A/B packets in opposite orders and the
same task sheet.  Both independently selected the layered candidate, found a
complete first-pass route with no hidden dependency, and judged the later
independent theorems to retain their mathematical importance.  Both requested
one identical navigation refinement: mark finite-field specialization as
optional on the central route.  Stable subsection labels and that explicit
skip were added, after which the statement-identity and paper-only release
gates passed again.  Numerical grades remain chat-only under the C897 dossier
boundary.

## History audit

The first-batch MAJOR was a load-bearing human-proof gap, not a demonstrated
false theorem and not an exposition-only finding.  Targeted file history shows
that no earlier committed version contained the complete reduced-branch-cycle
or internal rational `J_0` normalization proofs: both first appear in the C897
repair commit `da25f481`.  The complete-fibre argument had been strengthened
during the 2026-07-26 arithmetic repairs, but it still depended on the then
unproved exact branch assertion.  Thus ordinary manuscript edits did not
compress a previously complete proof into the MAJOR gap.

One separate MINOR did arise from compression during manuscript consolidation:
commit `5f144ed6` abbreviated the complementary-minor/triangle-holonomy bridge
to “two dihedral representatives and complementation.”  The C897 repair
restored the orbit reduction, representative calculations, and sign check.

## Mystery ledger

- **Was the MAJOR created by manuscript compression?** Settled negatively by
  the targeted history audit above.  The exact proofs were missing rather than
  shortened from an earlier complete committed form.
- **Does layering hide a dependency or demote the independent theorems?**
  Settled negatively by statement-hash/dependency checks and both sealed
  readers.
- **Residual dense bridge.** The coherent-outer-marking to signed Joubert-frame
  passage remains the point of highest specialist density.  Its exact table,
  normalization, marking boundary, and classical citations are present, and
  neither blind reader found a hidden logical step.  No task-owned evidence gap
  remains; any further expansion would be optional pedagogy rather than C897
  remediation.

No genuine unresolved C897 mystery remains.
