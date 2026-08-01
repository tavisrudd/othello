# MDS conjecture versus the PRS results

**External ID:** `BIG-413`
**Verdict:** same mathematical ecosystem; no current progress on the MDS
conjecture.

## Exact target and exact local theorem

The linear MDS conjecture asks for the maximum length of a nontrivial linear
MDS code over `F_q`, with the familiar even-field exceptional dimensions.  In
projective language it asks for the maximum size of an arc in projective
space.  A one-symbol MDS extension of a Reed--Solomon code is therefore an arc
extension of a rational normal curve.

The repository instead proves covering-radius and complete deep-hole
classifications for selected projective Reed--Solomon redundancies, including
5, 6 and 7, plus a high-field polar-containment theorem at arbitrary
redundancy.  Its novel output is the orbit/stratum classification of words at
maximum distance, not a longer MDS code.

## Where the apparent implication breaks

Let `r=n-k` be the redundancy.  Kaipa's MDS-extension dictionary is clean when
the PRS covering radius is `r`: a deep hole then gives a one-digit MDS
extension of the dual Reed--Solomon code.  Kaipa explicitly notes that this
equivalence breaks when the covering radius is `r-1`.

The repository classifications live in that `r-1` regime.  Moreover, the
scalar covering-radius values in the main high-rate ranges were already
implied by Seroussi--Roth-type results; the repository audits identify the
deep-hole orbit classification as the new part.  Consequently:

```text
new PRS deep-hole strata
        does not imply
new MDS length / new complete-arc obstruction
```

This is stronger than a vocabulary fence: it identifies the exact failed
hypothesis in the tempting reduction.

## What the results may genuinely enable

- A sharper PRS deep-hole conjecture across fixed redundancy, with exceptional
  strata predicted by the pointed Hankel/polar geometry.
- A uniform proof of deep-hole classification beyond redundancy 7.
- A study of when a deep-hole stratum degenerates into an actual arc
  extension after puncturing, shortening or changing the evaluation set.

The third item is the only route back toward MDS.  It becomes meaningful only
if it produces a new arc-size bound or resolves an unsettled MDS parameter.

## Independent attack routes

1. **Finite-field polynomial/determinant methods.**  Attack completeness of
   rational normal curves directly through tangent functions, Rédei-type
   polynomials or Ball-style determinant identities.  This is independent of
   the local deep-hole classification and is the most mathematically direct
   route to a new MDS case.
2. **Exact small-parameter arc classification.**  Enumerate projective arcs up
   to `PGL`/semilinear equivalence with canonical augmentation and emit
   checkable certificates.  This can settle bounded `(q,k)` cases but will not
   by itself address the universal conjecture.
3. **Algebraic-curve and function-field constructions.**  Search for a
   hypothetical overlong MDS code through the geometry of its associated
   point set.  Failure must be converted into a theorem, not just a search.

## Promotion gate

Promote this to “partial MDS progress” only after proving at least one of:

- a previously unknown maximum-length MDS case;
- a new infinite parameter range of arc nonexistence;
- a valid reduction from the classified `r-1` deep holes to one of those
  statements.

## Sources and local audit trail

- Krishna Kaipa, *Deep holes and MDS extensions of Reed--Solomon codes*,
  arXiv `1612.05447`, especially the radius-`r` equivalence and its failure at
  radius `r-1`; `partial`, cached SHA-256
  `1fe8de83c0b8cd3938e1a450fd49f376de795d7a317f099a730c63ab968178a4`.
- Jun Zhang and Daqing Wan, *On Deep Holes of Projective Reed--Solomon Codes*,
  arXiv `1605.02423`; `partial`, cached SHA-256
  `52ae5e2b988f8845d39339eb95a8c853378b7d3e427b9c4e72eb35802def38c2`.
- `notes/2026-07-22-c491-prs-redundancy-five-literature-audit.md`.
- `notes/2026-07-22-c498-audit-axisA-coding-forward-citation.md`.
- `notes/2026-07-23-c509-prs-redundancy-seven-literature-audit.md`.
