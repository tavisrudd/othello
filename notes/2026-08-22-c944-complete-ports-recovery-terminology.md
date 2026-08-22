# C944 — Complete-ports recovery terminology revision

**Lane**: `complete-ports`

**Status**: COMPLETE; MANUSCRIPT AND STANDALONE RELEASE GATES PASS

## Intent

Retire “port” as a technical noun in the complete-ports manuscript and recast
the exposition in coding-theory language centered on recovery sets, recovery
structures, and normalized dual recovery equations.  Preserve every theorem,
hypothesis, formula, example, reliability law, and formal-coverage boundary.

## Semantic guardrails

- Distinguish exact helper supports of normalized dual words from the standard
  upward-closed family of recovery sets.
- Use “repair” for the operational process, events, radii, and reliability.
- Treat the normalized dual words as recovery equations rather than assigning
  them another branded noun.
- State `z_x(I)` as the persistent or eventual confinement threshold: for a
  fixed concatenation the nonzero-functional weighted cost remains part of the
  exact gate.
- Present locality, overlap statistics, recovery-set data, and coefficient data
  as successively richer information, not as a literal inclusion of unlike
  mathematical objects.
- Preserve exact Lean declaration and module identifiers as code identifiers;
  a formal API rename is outside this manuscript task.

## Acceptance gates

1. Every whole-word manuscript use of “port” is classified and removed from
   mathematical prose, except an exact formal identifier if unavoidable.
2. The title, abstract, introduction, main theorem, MDS theorem, section
   headings, figure, and conclusion expose the standard terminology and the
   support/coefficient distinction accurately.
3. Claim-map prose, annotations, statement digests, verification ledgers,
   README, and metadata agree with the revised manuscript.
4. The deterministic manuscript and public-formal release gates pass with no
   mathematical or provenance drift.
5. The standalone paper export is synchronized and independently verified; no
   push or deposit is made.

## Result

The revised title is *Bounded Recovery Structures of Linear Codes: Transfer,
Reliability, and Geometry*.  The manuscript no longer uses “port” as a visible
technical noun.  Invisible stable labels and filenames and exact Lean module or
declaration identifiers retain their established spellings; changing the Lean
API is outside this manuscript task.

The revision makes three levels explicit:

- normalized dual words through the target are the bounded recovery equations;
- their support projection records exact helper supports; and
- the bounded upward closure of those supports is the standard recovery-set
  family.

The abstract now leads with the sharp eventual confinement theorem, retaining
the outer-family hypothesis needed for the criterion `r+1 < z_x(I)`.  The
finite-length theorem still includes the nonzero-functional weighted minimum.
The MDS theorem is titled “MDS reconstruction from minimum-weight recovery
equations,” the positive-density and geometric results use recovery-structure
language sparingly, and the conclusion presents locality and overlap
statistics as lossy summaries rather than ill-typed set inclusions.

The public README, Zenodo metadata, transfer diagram, verification script, and
current theorem/formal/evidence maps agree with the new terminology.  The
repository identity and formal identifiers remain stable.

## Source check

No source was read at full-text depth for this bounded terminology check; two
primary sources were read partially.

- Márquez-Corbella, Martínez-Moro, and Munuera, *Computing Sharp Recovery
  Structures for Locally Recoverable Codes*, arXiv:1907.05316v1: partial read
  of the abstract, introduction, Section 2 definitions, Proposition 1, and the
  dual-word recovery discussion.  Cache key `arXiv:1907.05316`, SHA-256
  `a9060ca8f7901885f1e077076c73dd7d03f8ae995a2232e891ce74c39e4ea927`.
- Pàmies-Juarez, Hollmann, and Oggier, *Locally Repairable Codes with Multiple
  Repair Alternatives*, arXiv:1302.5518: partial read of the abstract and
  introduction to confirm ordinary operational “repair” usage.  Cache key
  `arXiv:1302.5518`, SHA-256
  `278af00d94c8b7dcd6eec66732fc4e49df8f901f9cf601b2056a187c4430d18d`.

No novelty or priority verdict changed.

## Validation

- deterministic `make check`: PASS, 23 pages, warning-free;
- full `make release` against public `finitegeom` commit
  `36c83268ddaeec9ee22824cad44d6222a9e67081`: PASS;
- rendered PDF checks: title/abstract and opening theorem pages, transfer
  diagram, and bibliography inspected at full resolution;
- rendered terminology scan: no repair-port, coefficient-port, support-port,
  full-port, represented-port, or prescribed-port phrase remains;
- independent cold read: PASS WITH MINOR EDITS.  It found one genuine layer
  description defect and four low-severity edit defects: the conclusion had
  conflated exact support projection with its upward closure, the main theorem
  left the eventual scope of exact copying momentarily ambiguous, one sentence
  equated a radius with a family, one minimum-recovery phrase was imprecise,
  and one proof contained a stray “restricted.”  All five were repaired; the
  same independent reader's narrow reread closed every finding with no new
  defect.  Its separate `make check` passed at 23 pages, warning-free;
- PDF SHA-256:
  `5479bc2ba9f2b124c03ccd0074b642de9a693f33ccdad239ccfa3bcee9bba697`.
- immutable export source:
  `d73ee8fde74b105c73f0dd2c62ee029e4906cc7f`;
- standalone mirror commit: `3899bc4`; exporter verification and the clean-tree
  full release gate both pass, with no push, tag, deposit, or submission.

## `ej` + `tt` closeout and mystery ledger

The closeout settled two cheap issues exposed by the terminology change.  The
standard recovery-set family is now distinguished from the exact supports of
dual words, avoiding a silent change of definition.  The paper also states
that `z_x(I)` is the persistent/eventual confinement threshold while the
finite-length gate retains the nonzero-functional term.

No genuine mathematical mystery remains.  One deliberate naming boundary is
open: the public Lean API and stable repository/file identifiers still contain
`Port`.  A zero-occurrence migration there would require a separately owned
formal API rename, renewed gate/axiom extraction, deterministic finitegeom
export, and paper re-pin; it is not a defect in the manuscript revision.
