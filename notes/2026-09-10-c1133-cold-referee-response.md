# C1133 — response to the cold referee and repetition pass

> Correction: the reconstruction criterion and discriminant values recorded
> in this historical report used transposed final coefficients. See
> `2026-09-10-c1133-reconstruction-transcription-repair.md` for the corrected
> source comparison, exact values and certificate. The endpoint matrices
> are unchanged; the former denominator cross-check repeated the same
> transcription error and did not independently validate the source formula.


**Lane:** `cubic-threefolds`. **Date:** 2026-09-10.
**Scope:** author-authorized response to the fresh-context report in
`2026-09-10-c1133-cold-exposition-referee.md`, including the subsequent request
to remove completely redundant repetition. The prior report remains unchanged.

## Main result

The vague period-to-matrix import is replaced by an exact theorem and a
checked applicability condition. No theorem statement, family range, matrix
entry or formal coverage claim is weakened or promoted. The source supplies
uniqueness; the new exact replay verifies the finite inputs to that theorem.
The body gains a cubic/curve model and a safe reading route. Technical
reconstruction detail remains in the finite-data appendix.

## Reconstruction premise

For index-two degrees 1 and 2, use Przyjalkowski's weighted-complete-intersection
Theorem 2.6.6; for the cubic, use the existing Beauville calculation; for genera
6 and 8, use Przyjalkowski's Theorem 6.1.1 in the genera paper.
For genera 2 through 5:

1. CCGK Corollary D.5, Proposition D.9 and Sections 8--11 identify the geometric
   normalized quantum periods. The sextic weights all divide 6; the ordinary
   complete intersections satisfy the ample/nef hypotheses. The special
   genus-three presentation retains its existing smooth-deformation bridge.
2. Przyjalkowski, arXiv:math/0410327v4, Proposition 6.2.2 recovers the five
   counting-matrix coefficients from the normalized period coefficients
   d2,...,d6 on the displayed nonvanishing locus. Definition 2.1.1 specifies
   the basis, unit subdiagonal and zero endpoint diagonal entries.
3. Subtract the scalar shift from the displayed matrix and restore the
   anticanonical q powers. Solve the counting connection coefficientwise,
   using the inverse of nI-N for positive n and nilpotent constant N. Its
   last component agrees through degree eight with the normalized period.
   The regularized coefficient of degree n is divided by n!.
4. Check the reconstruction discriminant is nonzero. Separate checks use the
   low-order identities in Example 5.4 and an integer polynomial obtained by
   clearing factorial denominators. No assumption of genericity in moduli or
   unverified finite-to-infinite uniqueness leap is inserted.

The discriminants for genera 2,3,4,5 are respectively
-1929603065619530925000, -485456258487240, -398939804370 and -3854631880.
Their signs carry no role; nonvanishing is what the source requires.
The checks identify the candidate matrix using the imported reconstruction
statement; they do not prove the GW period formulas or that statement.

The modern reconstruction scripts remain an additional provenance comparison,
not the sole geometric identification. The owning imported-source registry
now records the exact period and reconstruction hypotheses and their matches.
The existing fano-matrices evidence identifier includes the added certificate;
no new theorem, dependency edge or Lean declaration is introduced.

## Printed-source discrepancy

Theorem 2.6.6 in arXiv:math/0507232v3 prints the genus-two off-diagonal entry
119681240. The current manuscript and the modern reconstruction give
119681280. The original printed page 9 was inspected visually, so this is
not merely an extraction artifact. The degree-three identity in Example 5.4
of the genera paper gives a period discrepancy of 40/27 for the older entry.
The replay records this comparison. No manuscript matrix value was changed.
The older theorem is imported only for its index-two degree-one/two matrices;
genus two uses CCGK's geometric period and the checked uniqueness criterion.
The discrepancy is recorded here as part of the requested source check; no
claim about authorial intent or a published erratum is made.

## Referee response and repetition decisions

| Item | Disposition |
|---|---|
| Major 1: reconstruction premise | Exact source, hypotheses, normalization and finite uniqueness check now printed in D.2 |
| Major 2: comparison output | Section 3 opens with faithful fields, original-lattice transport and occurrence separation; it distinguishes the imported graded-module isomorphism from the local deductions and gives a safe first-pass route |
| Major 3: earlier model/route | Section 2 opens with cubic residues versus genus-at-least-two curve residues; elliptic curves are not misleadingly presented as eligible nonzero-nilpotent blocks. Statement-level route and full-even-bulk requirement are explicit |
| Major 4: trust boundary | D.3 and bundle README expose geometric imports, finite execution and formal limits; canonical paper repository link supplied. A published version containing this new replay remains author-controlled; nothing is pushed |
| Minor 1: classical obstruction wording | Narrowed to 'does not directly give the required obstruction' |
| Minor 2: whole factors | Moved the whole-eigenspace/Jordan distinction before spectral splitting and removed its later duplicate |
| Minor 3: universal formula | Added the local skip to the cubic subsection after retaining the universal formula |
| Minor 4: endpoint table | No extra column: existing counts already show the detector, and extra numerical data would add no necessary information |
| Minor 5: index-two theorem styling | Retain the stable theorem environment; relabeling as a corollary adds no substantive clarity and would churn the formal statement identity |
| Minor 6: fixed-base proof | State that algebraic divisor coordinates remain fixed. Retain the proof because its coefficient domain differs from the numerical argument |
| Minor 7: limits | Name the existing limits discussion in the introduction roadmap |
| Minor 8: layout | Keep the matrix-table lead with its table; inspect rebuilt pagination below |

The concrete cuts are the second proof of rank-one odd vanishing in Section 7,
the second whole-factor definition after spectral splitting, a repeated
low-dimensional/projective vanishing summary in the introduction, the
repeated general-product exclusion after Hodge endpoint recovery, and excess
technical wording in the introductory residue summary. The retained exact
rank-one lemma is referenced where needed. Essential fixed-base, all-member,
regular-lattice and rational-versus-integral distinctions remain.

A bounded literal sentence screen of the thirteen included section files
found no remaining exact repeated sentences of at least twelve whitespace
tokens after removing annotation/comment text. This is an editorial
mechanical screen, not evidence that conceptual redundancy is impossible.
The semantic pass above determined which repetitions could actually be cut.

## Source read boundary

**New full-paper reads: zero.** This pass consults original cached sources at
partial depth. Prior full-read counts are unchanged. Exact updated scopes
are recorded in `2026-09-09-c1133-literature-sources.json`.

- Przyjalkowski, arXiv:math/0410327v4: partial; introduction, Definition 2.1.1,
  Example 5.4, Theorem 6.1.1 and its proof, Theorem 6.2.1, Proposition 6.2.2
  and its nonvanishing condition. Printed page 10 visually checked.
  SHA256 `39c13194bcc63073d38f403a739f403028c3a5516ba72934ee03ba99179fbde2`.
- CCGK, arXiv:1303.3288v3: partial; Assumptions D.1, Corollary D.5,
  Proposition D.9, Sections 8--11 and opening of 12, plus the inspected
  D.2 material. SHA256
  `a01ad88951e72c9b6ef16e8be2e08408bc6e6cf20e9133befe009d62782d9686`.
- Przyjalkowski, arXiv:math/0507232v3: partial; conventions, Theorem 1.1,
  reconstruction Theorem 2.3.5, counting conventions, Proposition 2.6.4,
  Theorem 2.6.6 and proof. Printed page 9 visually checked. SHA256
  `62e3e974bbddb580acade0728bf6513076c4548c15c3cf885c809f6eb8052e0c`.
- Boehning--Graf von Bothmer--Su'a, arXiv:2606.17884v2: partial; Proposition
  9.1 and proof, Section 10 opening and relevant bibliography entries.
  SHA256 `d346bb0300a78e766386519b90dec93120f76e0f67c6ac22341c4eaead66762b`.
- Beauville, arXiv:alg-geom/9501008v1: partial; introduction, main theorem,
  Proposition 1 and its hypotheses. Its index bound is not extended to the
  index-one complete intersections in this response. Access and hash remain
  in the existing source register.

No new remote fetch or priority/absence search is claimed. The comparison
part of the response clarifies its existing proof, not a new independent
external verification of every coefficient-completion claim.

## Reproducibility and validation

New bundle members: `verification/fano-matrices/reconstruction_check.py` and
its generated `.json`. Their hashes/byte counts, existing inputs and updated
README are in `manifest.json` and `SHA256SUMS` in that directory. The replay
uses Python 3 standard-library Fractions, deterministic order, no random seed.
From `papers/cubic-stabilization-m1`:

```
python3 verification/fano-matrices/reconstruction_check.py --check
make check
```

Omitting `--check` regenerates the certificate. The Makefile and evidence
registry include the read-only replay. Independent low-order and denominator
checks are built in; no independence claim is made for the source theorems.
The four candidate matrices are unchanged from the previous committed bundle.

## Final validation

Authority `make check` passes, including finite and reconstruction replay,
source-only formal correspondence, checksums and warning rejection.
Final run: `/tmp/claude-run-quiet/20260910-220358-make-C-cubic-stabilization-m1-check`.
All 32 PDF pages were visually inspected. The cubic proof now finishes on
page 14; the matrix-table lead stays with its table. Title and abstract are
unchanged (abstract remains below 200 words). Exact full-body comparisons
against the preceding commit confirm unchanged theorem, lemma, proposition
and corollary environments in all six edited sections.

PDF: 32 pages, 251037 bytes; SHA-256
`4b7c631e4715d200960ce5327ac66eb6ee280ba6c2d2eae5d469634af49ebcfc`.
Authority commit: `705ab66b7`. Export audit reports zero findings.
Standalone forward commit: `69722ad`; its full `make check` passes
(`/tmp/claude-run-quiet/20260910-220526-make-C-cubic-stabilization-m1-check`).
The rebuilt standalone PDF is byte-identical to the authority PDF.
Exporter verification passes with 351 tracked files and content SHA-256
`cfbb93e034c30e1764c005456eaadac6e41913f331266170f5a985f839cbbbbd`.
Nothing was pushed. No new Lean kernel replay or independent referee
acceptance of the revision is claimed.

Process note: an unnecessary full handoff re-read after context recovery
exceeded the output budget and was truncated. No further broad read was
attempted; subsequent state updates use the known current C1133 block.

## EJ + TT closeout / Mystery ledger

The useful extra gain is eliminating the vague reconstruction dependency
rather than just adding a citation to another set of scripts. A short exact
replay exposes the finite uniqueness condition and catches a real printed
source disagreement without altering the correct current matrix.
The curve preview deliberately excludes genus one from the eligible-block
model; the elliptic case stays in the surface proof.
No unexplained mathematical feature was created. The older-entry discrepancy
is settled at the stated coefficient-comparison scope; its publication history
is not investigated. Broader priority coverage and publication review remain
open. No new kernel coverage or blanket correctness certification follows.
