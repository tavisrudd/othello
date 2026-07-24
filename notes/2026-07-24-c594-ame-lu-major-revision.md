# C594 — AME--LU major-revision sweep

**Lane:** `ame-lu`

**Date:** 2026-07-24

**Status:** complete; revised local candidate, external re-review still required

## Outcome

The external B/major-revision report was adopted in full.  The revision closes
both identified proof gaps, fixes both Section 7 replay conventions, promotes
the fixed-party logical phase to the title and abstract, supplies the missing
classical/coding context, and shortens the redundant transport discussion.
No theorem statement or computational result changed.

The previous C572 release candidate is superseded.  No upload, submission,
license choice, or other author-gated external action was made.

## Proof repairs

### Theorem 4.1 at \(z=1\)

The bracket argument now separates two cases.  If \(A^2\ne B^2\), the
multiplicities three and two recover \((B/A)^2\).  If \(A^2=B^2\), the
ten-value multiset is exactly two opposite values of multiplicity five; this
collapsed pattern is invariant under the allowed common scale/sign and is
equivalent to \(z=1\).  The proof therefore includes the H3 specialization
rather than silently assuming it away.

### Theorem 5.1

The unsupported overlap-propagation sentence was removed.  It is replaced by
the following MDS diagonal-multiplier lemma, proved in the manuscript:

> If \(E,F\) are \([6,3,4]\) MDS codes and diagonal \(D\) satisfies
> \(DE\subseteq F\), then \(D=0\), or \(D\) is nonsingular and \(DE=F\).

The proof uses only the distance-four support bound and injectivity of
\(D|_E\).  Applied to the two off-diagonal inclusions, any nondiagonal input
block produces a diagonal code--dual equivalence.  Conversely such an
equivalence and its inverse give the two elementary unipotents; with the
split torus they generate \(\mathrm{SL}_2(q)\).  This supplies the central
implication and the converse group-generation step without a computation.

## Convention and exposition repairs

- Section 7 retains the exact systematization \(Q_p\) from (7.2), defines
  \(\widetilde Q_p=2(t-1)Q_p\), and displays the polynomial matrix only as
  \(\widetilde Q_1\).  The transport operator is correspondingly
  \(\widetilde T_p\); its rank agrees because \(2(t-1)\) is a unit on the
  admitted locus.
- The rank bridge now uses \(p=\pi\), matching the Section 6 convention.
- The double-coset arithmetic and characteristic table were compressed to
  their theorem-relevant consequences, with representatives, stabilizers,
  minors, and complete support sets left in the replayable certificate.
- The title, abstract, and introduction now lead with the fixed-party
  \([[5,1,3]]_q\) logical phase and its operational gate interpretation.

## Literature audit

The search extended C562 across self-associated point sets, finite-projective
arcs, quantum Reed--Solomon/polynomial codes, and transversal gates.  Four
new sources were opened as full text; four additional sources were checked at
official abstract, chapter, or bibliographic-metadata depth.

| Source | Depth | Use |
|---|---|---|
| Dolgachev--Ortland, *Point Sets in Projective Spaces and Theta Functions*, Chapter III | full text | modern association/self-association treatment; explicitly identifies the criterion as essentially due to Coble |
| Ball--Lavrauw, *Arcs in finite projective spaces* | full text | modern finite-projective arc background |
| Aharonov--Ben-Or, *Fault-Tolerant Quantum Computation With Constant Error Rate* | full text | polynomial codes and their systematic fault-tolerant gate procedures |
| Grassl--Geiselmann--Beth, *Quantum Reed--Solomon Codes* | full text | quantum RS construction and encoding/decoding context |
| Coble, *Associated Sets of Points* | official DOI/bibliographic metadata; modern treatment above read in full | classical provenance |
| Segre, *Ovals in a Finite Projective Plane* | official journal metadata | classical finite-plane provenance |
| Hirschfeld, *Projective Geometries over Finite Fields*, 2nd ed. | official OUP book/chapter metadata | standard arcs/ovals reference |
| Eastin--Knill, *Restrictions on Transversal Encoded Quantum Gate Sets* | official APS abstract/metadata | transversal-gate operational context and limitation |

Persistent-cache identities:

```text
arXiv:1908.10772
  00d13c01fa869889c9ab9e4e76928235c5e7b441a815059fd0f3f177365e76a4
arXiv:quant-ph/9906129
  75b88121b25c7e4a8766c4e5ee31218be946d25fccecf7b3717687011df32d1f
arXiv:quant-ph/9910059
  8d7123b601de2d682e7f1be51d026e2152ba3f941172829771aade932974602b
NUMDAM:AST_1988__165__1_0
  626be0941d2b1fb0fa983bffd29d67228fe44d5b367073bed6f59ff7ac25fee0
```

The introduction now states the search scope before making its negative
precedence claim.  The remaining negative claim is limited to the exact
prime-power, equal-phase, linear \([6,3,4]_q\) MDS/CSS theorem.

## Validation

- `make check`: passed; 15 evidence artifacts verified and the 15-page
  XeLaTeX/BibTeX build is warning-free.
- `python3 supplement/verify.py --replay`: passed; all 15 artifacts verified
  and all seven evidence bundles replayed.
- Deterministic PDF: 161,093 bytes,
  SHA-256 `51fc002ba810f78d685be711fbf335676b16c2618794f5bc34cf5928f32104c6`.
- Refreshed 35-artifact public tree:
  `e8aa3d8f5b5969046bfe2e2b1144f2601f440567873acc0a4818c62f848cd2d6`;
  the 12-artifact formal companion remains
  `91c8ba3c885a65e71adb0cf5cf3491086c3f810cec11673435112852983399de`.
- Rendered pages 1, 6--8, and 11--13 were inspected at 110 dpi.  The promoted
  abstract, both repaired proofs, the normalized transport formula, and the
  compressed detector discussion have no visible layout defect.

The revision has not received a second independent external cold read.  That
is the remaining editorial gate before restoring release-candidate status.

## `ej` + `tt` closeout

The high-leverage change was not to add another computation.  It was to expose
the distance-four lemma already latent in (5.2), which turns the paper's most
interesting theorem from a certified pattern into a short conceptual proof.
The same sweep moved the scalar detector back into a supporting role and put
the encoder symmetry phase where a reader encounters it first.

## Mystery ledger

- **Settled:** the \(z=1\) multiplicity collision is a recognizable invariant,
  not an exceptional hole in the classification.
- **Settled:** a nonzero diagonal multiplier between the two MDS summands
  cannot have partial support; this closes the logical-phase dichotomy.
- **Settled:** the Section 7 discrepancy was purely normalization and
  permutation convention; the rank/divisor computations are unchanged.
- **Open, editorial:** an independent reviewer should verify the revised
  Theorems 4.1 and 5.1 before a new release candidate is declared.
- **Open, author-owned:** all publication metadata, license, disclosure, and
  submission gates from C572 remain untouched.
