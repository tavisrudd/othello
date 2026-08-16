# C909 — literature/priority audit of the quantum additions

Date: 2026-08-12  
Lane: clebsch  
Scope: the three proposed additions only: (A) low-dimensional birational
invariance of \(\nu _6\), (B) one-\(\mathbf P^1\) stable-birational invariance
for threefolds, and (C) the \(V_{14}\) consequence. This is a source/priority
audit, not a manuscript, PDF, mirror, or Lean edit.

## Executive record

Full-text sources opened/read: **one** (Cai, inherited from the prior source
audit and rechecked at the load-bearing loci below). KKPYY and Kuznetsov were
read at the exact theorem loci needed here, not line-by-line as complete
monographs; they are therefore recorded as partial reads. One MathOverflow page
was read as historical context only and is not a theorem source.

The bounded verdict is:

* **(A) GO as a paper-local formal corollary, conditional on the printed
  framed-\(\nu _6\) and low-dimensional-center hypotheses.** KKPYY prove the
  relevant maximal \(F\)-bundle blowup and projective-bundle decompositions, but
  do not state this integer \(\nu _6\) theorem. The result composes their
  formulas with weak factorization and the paper's center-vanishing lemma.
* **(B) GO as a formal corollary, not a source theorem.** The only extra step is
  the rank-two Leray--Hirsch factor and cancellation in \(\mathbf Z\). A general
  \(\mathbf P^1\)-bundle is not globally a product; the safe statement is about
  birational rank-two projectivizations, or directly about a trivial
  \(X\times\mathbf P^1\) stabilization.
* **(C) Geometry GO; quantum equality scope split.** Kuznetsov's theorem
  applies to every smooth \(V_{14}\), and even gives \(V_{14}\dashrightarrow Y\)
  for its smooth Pfaffian cubic \(Y\). Cai's Section 3 calculation gives an
  **exact count \(2\) for the small even cubic connection** (the two scalar
  blocks have only exponential factors and the rank-two zero block has
  exponents \(-1/6,-5/6\)). Therefore (A) gives
  \(\nu _6(V_{14})=2\) and the one-\(\mathbf P^1\) irrationality in the
  manuscript's small-even scope. This is not a theorem about an unqualified
  full KKPYY maximal/super atom: Cai explicitly works with even cohomology,
  while KKPYY's cubic Example 6.21 discusses the odd sector separately. A
  full-atom statement needs an explicit parity/atom comparison lemma.

Thus the additions are a **minor formal extension after scope and hypotheses
are printed**, but an unqualified “KKPYY proves \(\nu _6(V_{14})=2\)” or a
claim that a Kuznetsov component equivalence itself transports quantum
monodromy would be a **major** overclaim.

## Primary-source record

| source | access/version | read depth and exact screen | cache/SHA |
|---|---|---|---|
| Ludmil Katzarkov, Maxim Kontsevich, Tony Pantev, Tony Yue Yu, *Birational Invariants from Hodge Structures and Quantum Multiplication* | arXiv:2508.05105v2, revised 2026-03-05, posted metadata 2026-03-06; HTML https://arxiv.org/html/2508.05105v2 and abstract https://arxiv.org/abs/2508.05105 | **Partial.** Read the abstract/version header; Theorem 4.1; Theorem 4.5 and its blowup proof; Theorem 4.11; Definitions 5.16, 5.20, 5.21; Proposition 5.17; Proposition 5.22; Claim 6.15; Example 6.21. The source says Theorem 4.5 is a canonical maximal-\(F\)-bundle blowup isomorphism over connected nonempty analytic domains (HTML lines 1430–1432), and Theorem 4.11 gives the analogous rank-\(r\) projective-bundle isomorphism to \(r\) copies (1516–1522). The abstract-atom criterion is Prop. 5.17 (1680–1693), while the geometric atom equivalence and its map from abstract atoms are Defs. 5.20–5.21 and Prop. 5.22 (1806–1841). Example 6.21 (2393–2396) is the relevant cubic discussion. | Cache key arXiv:2508.05105; SHA-256 2c5c9f0a2f9eaf230605eaf844c3b7d08e0181e6dbc921153156a071d616ff64. |
| Jiaji Cai, *The cubic threefold is symplectically irrational* | arXiv:2608.01577v1, 2026-08-03; HTML https://arxiv.org/html/2608.01577v1 and abstract https://arxiv.org/abs/2608.01577 | **Full text** in the inherited C904/C907 source audit; current pass rechecked the complete load-bearing calculation. The source explicitly declares the even-cohomology convention (HTML 62–66). Section 3 writes the \(4\times4\) small-even system (109–120), block-diagonalizes it (123–172), obtains the two scalar exponential solutions and the rank-two zero block, and solves \(\rho^2+\rho+5/36=0\) with roots \(-1/6,-5/6\) (164–193). Proposition 6 only advertises existence of the fractional pair for the big connection (218–224); the exact small-even count comes from the preceding full block display, not Prop. 6 alone. | Cache key arXiv:2608.01577; SHA-256 06bfccf9b67ed8cf224f5e7cc6ba2088271577787e2f8e0dd895c0ef3b404a9e. |
| Alexander Kuznetsov, *Derived categories of cubic and \(V_{14}\) threefolds* | arXiv:math/0303037v1, 2003-03-04; HTML https://arxiv.org/html/math/0303037v1 and PDF https://arxiv.org/pdf/math/0303037; published Math. Inst. Steklov 246 (2004), 183–207 | **Partial theorem-locus read.** Section 2 was checked through Theorem 2.2 (regular nets, locally free theta bundle, smoothness equivalence), Props. 2.6, 2.11, 2.15, Theorems 2.17–2.18, and Remark 2.19. HTML loci: Theorem 2.2 at 159–178; Prop. 2.11 at 252–258; Prop. 2.15 at 287–301; flop at 303–312; all-smooth statement at 315–336; direct base birationality at 337–339. No repository cache artifact was found, so no SHA is available in this audit. | SHA unavailable. |
| MathOverflow, “Is the product of a cubic threefold and the projective line irrational?” | https://mathoverflow.net/questions/379287/is-the-product-of-a-cubic-threefold-and-the-projective-line-irrational; accessed in the inherited audit 2026-08-11 | **Full page, context only.** The December 2020 question/answer records that the one-\(\mathbf P^1\) problem was then reported open. It is not used as evidence for a theorem or a present-day negative. | No version or cache SHA. |

The two arXiv sources are primary. The MathOverflow item is retained only to
explain why the one-step statement is a meaningful application rather than a
claim that it was already in the classical cubic irrationality literature.

## Exact source-to-claim audit

### (A) Birational invariance in dimensions at most four

The honest theorem has the following hypotheses. Let \(\nu _6\) be the
integer-valued primitive-sixth-root multiplicity on the framed numerical
small-even connection used in the manuscript. Assume:

1. the KKPYY/Iritani-type blowup comparison, after the numerical Novikov
   specialization used in the manuscript, has endpoint spectrum equal to the
   ambient spectrum plus the Tate-shifted center spectra;
2. integral Tate shifts preserve framed formal monodromy;
3. every smooth center of dimension at most two, including every strictly
   admissible center specialization, has \(\nu _6=0\); and
4. weak factorization applies over \(\mathbf C\) in the usual smooth-projective
   category.

For a birational map of smooth \(d\)-folds with \(d\le4\), every nontrivial
center has codimension at least two and hence dimension at most \(d-2\le2\).
The blowup formula therefore preserves \(\nu _6\) in either orientation. This
is a valid theorem once (1)–(3) are printed; it is not literally KKPYY's
Theorem 4.5 or Proposition 5.17. KKPYY's Theorem 4.5 gives an isomorphism of
maximal \(F\)-bundles on connected analytic domains, and Prop. 5.17 gives a
non-rationality criterion for an atom outside the lower-dimensional atom
filtration. Neither statement defines this \(\nu _6\), performs the numerical
Novikov specialization, or states the dimension-four integer invariant.

The source novelty posture is therefore “formal corollary/application of the
KKPYY operation package plus the paper-local low-dimensional calculation,”
with no independent priority adjective.

### (B) One-step stable-birational invariance

KKPYY Theorem 4.11 gives the projective-bundle decomposition into \(r\) copies
of the base, so the rank-two specialization gives

\[
 \nu _6(\mathbf P_X(E))=2\nu _6(X).
\]

If \(X,Y\) are smooth projective threefolds and
\(\mathbf P_X(E)\dashrightarrow\mathbf P_Y(F)\) is birational, (A) applies to
the smooth fourfolds and gives \(2\nu _6(X)=2\nu _6(Y)\). Cancellation occurs
in the target \(\mathbf Z\), not in the atom group, so \(\nu _6(X)=\nu _6(Y)\).
In particular this applies to \(X\times\mathbf P^1\) and
\(Y\times\mathbf P^1\).

This is a short formal corollary and not a theorem located in KKPYY, Cai, or
Kuznetsov. The wording must not say that every \(\mathbf P^1\)-bundle is
isomorphic to a product. Over an integral base it is only noncanonically
birational to one after choosing a basis over the function field; the proof
needs only the trivial rank-two bundle or the displayed projectivization.

### (C) \(V_{14}\), the exact cubic count, and irrationality

Kuznetsov's source supports the universal geometric quantifier. Theorem 2.2
associates to every regular net a smooth cubic \(Y\) and a locally free rank-two
theta bundle, with smoothness of \(X_f\) equivalent to smoothness of \(Y_f\).
Props. 2.11 and 2.15 give the two honest rank-two projective bundles over
\(X=V_{14}\) and \(Y\); Theorem 2.17 gives their flop; Theorem 2.18 states the
construction for every smooth \(V_{14}\). Remark 2.19 is stronger than the
flop route: a hyperplane section of the common quartic is birational to both
\(X\) and \(Y\), so \(V_{14}\dashrightarrow Y\) directly.

The stable-birational relation is consequently a formal function-field
corollary, not an extra Kuznetsov theorem. The direct base birationality also
means that (A), rather than (B), already gives \(\nu _6(V_{14})=\nu _6(Y)\).
The flop/projective-bundle route is still a clean presentation of (B).

Cai's exact small-even count is also source-supported, but must be described
accurately. In Section 3 the two nonzero exponential blocks are scalar and
have integer-power prefactors; the zero-exponential rank-two block has the
indicial roots \(-1/6\) and \(-5/6\), and the gauge uses integral powers of the
loop variable. Thus the **small even** connection has exactly one primitive
sixth-root pair, i.e. \(\nu _6(Y)=2\). The paper's current proposition records
only the lower bound because it prints only the two fractional roots; the
scalar-block lines above are the missing one-sentence upper-bound check.

This does not automatically identify a full KKPYY maximal/super atom. Cai's
paper says at the start that it uses only even cohomology. KKPYY Example 6.21
describes the cubic's zero atom and notes a separate odd-cohomology behavior in
the comparison with higher-genus curves. Therefore the safe alternatives are:

* for the manuscript's current framed small-even \(\nu _6\): promote the cubic
  count to equality, apply (A) to Kuznetsov's birational \(V_{14}\dashrightarrow
  Y\), and conclude \(\nu _6(V_{14})=2\); or
* for a full KKPYY atom claim: print an additional parity-compatible atom/
  connection comparison before writing the same equality.

Under the first, printed scope, if \(V_{14}\times\mathbf P^1\) were rational,
(A) would compare its \(\nu _6=4\) with \(\nu _6(\mathbf P^4)=0\), a contradiction.
This proves irrationality, not stable irrationality.

## Bounded priority search and coverage

The following query strings were issued verbatim in two bounded web-search
batches:

1. "V14" "cubic threefold" flop Kuznetsov
2. "one-step stable birational" "P^1" quantum
3. "formal monodromy" "cubic threefold" quantum
4. "Hodge atoms" "V14"
5. "Birational invariants from Hodge structures and quantum multiplication" KKPYY
6. "cubic threefold" "P^1" irrational
7. "V14" "P^1" irrational
8. "nu_6" cubic threefold

Screen set provenance: eight ranked web-query result lists (two batches of
four), with visible primary/near-primary hits manually screened by title,
author, date, source type, and whether the result stated the exact conjunction
or only a constituent theorem. The retained discriminators were: (i) smooth
complex cubic or \(V_{14}\), (ii) one-\(\mathbf P^1\) product or rank-two
projectivization, and (iii) formal-monodromy/\(\nu _6\) content rather than
ordinary cubic irrationality. The relevant retained items were Cai, KKPYY,
Kuznetsov, and the 2020 MathOverflow question. Search-engine totals were not
stable bibliographic counts, so no exhaustive citation-negative is inferred
from them.

No OpenAlex, Crossref, or Semantic Scholar forward-citation tree was screened
in this pass; consequently this report makes no database-based “no citations”
claim. MathSciNet was not accessible, and Google Scholar was not used. The
bounded result is therefore a priority posture, not a comprehensive literature
clearance. The old MathOverflow page is historical only and cannot support a
2026 absence claim.

## Owning ledger rows and surfaces

The current owning novelty ledger is
papers/cubic-stabilization-epilogue/claim-proof-novelty-ledger.md. Its
quantum row is “Irrationality of \(X\times\mathbf P^1\) for every smooth
complex cubic threefold.” It does **not** currently contain a \(V_{14}\) row.
The safe future ledger decomposition is:

| proposed row | safe posture |
|---|---|
| \(\nu _6\) birational in fixed dimension \(d\le4\) | formal corollary of the KKPYY operation formulas plus the paper's center lemma; no source-theorem attribution |
| one trivial \(\mathbf P^1\) stabilization preserves \(\nu _6\) for threefolds | rank-two projective-bundle corollary; no independent priority claim |
| every smooth \(V_{14}\) has small-even \(\nu _6=2\) and \(V_{14}\times\mathbf P^1\) is irrational | application of Kuznetsov's all-smooth birational geometry and Cai's exact small-even count; not a KKPYY/Kuznetsov theorem |

Surfaces checked but not edited:

* papers/cubic-stabilization-epilogue/sections/04-one-step.tex currently
  prints the cubic lower bound \(\nu _6\ge2\) and the cubic product proof; it
  does not print the \(V_{14}\) addition.
* notes/2026-08-12-c907-low-dimensional-stable-birational-compression.md,
  §§1–3, carries the proposed A/B/C package but still labels the exact
  \(V_{14}\) conclusion as dependent on the cubic upper-bound/source gate.
* notes/2026-08-12-c909-quantum-short-theorem-wording-audit.md, items 1–3,
  is the concise conditional theorem surface.
* notes/2026-08-12-c909-kuznetsov-v14-stable-birational-audit.md owns the
  theorem-locus geometry, but predates this convention-compliant source table.
* notes/2026-08-12-c909-epilogue-integration-blueprint.md, §§3–4 and its
  trust-gate table, proposes the \(V_{14}\) claim; it should not be treated as
  a printed theorem until the small-even/full-atom scope is chosen.
* notes/2026-08-12-c909-epilogue-integration-blueprint-quantum-audit.md
  already records the conservative MINOR/MAJOR split and is consistent with
  this report.
* notes/2026-07-31-results-summary-snapshot.md records exact small-point
  \(\nu _6=2\) but still says global atom transport is conditional. The
  notes/cubic-threefolds-tasks/c907-quantum-monodromy-stabilization.md summary mentions
  \(V_{14}\) and should be synchronized with the eventual ledger row.

Closing status: A and B are ready as conditional formal corollaries; C is
ready in the manuscript's small-even invariant after printing the scalar-block
upper-bound sentence and the Kuznetsov source paragraph. A full KKPYY atom
version remains a separate proof obligation. No manuscript, ledger, snapshot,
or summary surface was modified in this pass.
