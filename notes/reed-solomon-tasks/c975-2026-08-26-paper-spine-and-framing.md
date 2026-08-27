# C975 checkpoint — theorem-driven paper spine and framing

**Lane:** `reed-solomon` · **Date:** 2026-08-26 · **Status:** proposed
architecture; no manuscript files edited

## Editorial decision

The paper should be about one theorem on normal-rational-curve parity-check
systems under point deletion.  Projective deep holes, the top two coset
layers of cofinite-support GRS codes, one-column MDS/NMDS extensions, and the
family-aggregate NMDS enumerators are four readings of that theorem.  They
must not be presented as a PRS paper followed by a GRS application.

The mathematical spine is

\[
\begin{array}{c}
\text{exact terminal R5 pencil count}
\quad+\quad
\text{reduced recursive carrier}
\quad+\quad
\text{degree-six simultaneous selector}
\\[2mm]
\Downarrow
\\[-1mm]
\text{a split locator avoiding every deleted evaluation point}
\\[2mm]
\Downarrow
\\[-1mm]
\text{exact top distance layers of }H_S
\\[2mm]
\Downarrow
\\[-1mm]
\text{deep holes}\quad|\quad
\text{MDS/NMDS appended columns}\quad|\quad
\text{NMDS weight enumerators}.
\end{array}
\]

This is the only roadmap the main text needs.  The existing stage chronology
R5, R6, ..., R10 is not a second spine.

## 1. Headline theorem hierarchy

### Theorem 1 — top distance layers under point deletion

Introduce from the start

\[
 A\subseteq\mathbf P^1(\mathbf F_q),\qquad |A|=s,\qquad
 S=\mathbf P^1(\mathbf F_q)\setminus A,
\]

and let `H_S` be an `r`-row GRS parity-check matrix on `S`, with arbitrary
nonzero column multipliers.  For an admissible support and

\[
 q\ge 6(r+s)-16+
 \left\lfloor2\sqrt{6(r+s)-18}\right\rfloor
\]

(with the sharper binary variant), state one theorem with the following
parts.

1. Outside the persistent/Lucas carrier,
   `d_S(f) <= r-2`; moreover the proof produces many degree-`r-2` split
   squarefree locators avoiding `A`.
2. If `p>r-1` and `s=0`, the covering radius is `r-1` and the top shell is
   exactly the tangent and conjugate-secant families.
3. If `p>r-1` and `s>0`, the covering radius is `r`; the distance-`r` shell
   consists exactly of the omitted curve points, while the distance-`r-1`
   shell consists exactly of tangents, conjugate secants, and interiors of
   split secants incident with `A`.
4. Give the projective shell counts in the statement:

   \[
   N_r=s,
   \qquad
   N_{r-1}=\frac{q(q+1)^2}{2}
      +\frac{(q-1)s(2q+1-s)}2.
   \]

This is the field-facing theorem.  It is stronger and more coherent than a
theorem headed by “split-free containment,” because it states the coding
quantity that the carrier and selector jointly determine.  “Split-free” is
an intermediate geometric condition in its proof.

The full PRS theorem is the specialization `A=empty`; the full affine RS
case is `A={infinity}`.  Thus the Cheng--Murray-facing consequence is visible
without claiming that the paper settles the general RS conjecture.

### Corollary 2 — exact MDS/NMDS one-column extensions

State and prove early in the setup the general identity

\[
 d(\ker[H_S\mid f])=d_S(f)+1.
\]

Then Theorem 1 immediately classifies every large-characteristic appended
column in the top two classes:

* omitted NRC columns give all MDS extensions;
* tangent, conjugate-secant, and `A`-incident split-secant columns give all
  NMDS extensions;
* every other column has Singleton defect at least two.

For `A=empty`, the first class is empty, agreeing with the full-length MDS
nonextension theorem.  This sentence prevents an apparent contradiction
with the existing dictionary discussion.

### Corollary 3 — family-aggregate NMDS weight enumerators

For an NMDS column define

\[
 \mu_S(f)=\#\{T\subseteq S:|T|=r-1,
             f\in\langle\nu_{r-1}(T)\rangle\}.
\]

First state `A_r(\widehat C_f)=(q-1)\mu_S(f)`.  Then give the three exact
double-counting identities

\[
\begin{aligned}
 \sum_{f\in\mathrm{Tan}}\mu_S(f)
   &=(q-r+2)\binom{q+1-s}{r-1},\\
 \sum_{f\in\mathrm{Conj}}\mu_S(f)
   &=\frac{q(q-1)}2\binom{q+1-s}{r-1},\\
 \sum_{f\in\mathrm{Split}_A}\mu_S(f)
   &=\left[\binom s2+s(q-r+2-s)\right]
       \binom{q+1-s}{r-1}.
\end{aligned}
\]

The standard one-parameter NMDS recurrence then gives the complete
family-aggregate and family-average weight enumerators.  Present this as the
enumerative shadow of Theorem 1, not as an independent counting chapter.
Individual-column character transforms belong after the aggregate theorem or
in an appendix; they are sharper arithmetic, not part of the headline.

### The two mechanism theorems

The proof should have exactly two named load-bearing results.

1. **Recursive carrier theorem.**  Every polar family trapped through the
   terminal level lies in `P_r union M^max_(r,p)`.  Follow this immediately
   by the digit-stripping exact sequence, the dimension formula, and the
   empty-carrier criterion.  These are the all-characteristic structural
   content of the carrier, not a separate R11+ story.
2. **Simultaneous-marker locator theorem.**  Off that carrier, one nonzero
   selector of degree at most six in each marker chooses all `r-5` contraction
   roots at once.  The exact R5 count leaves a terminal split cubic avoiding
   those roots and `A`; composite contraction lifts it to the desired
   locator.  Its pointed form handles deletion without a second proof.

The headline theorem is the composition of these two mechanisms with the
rank-two arithmetic and the independent radius gate.  This dependency should
be stated once and then used, rather than retold at every redundancy.

## 2. Proposed main-text order

1. **Introduction and main results.**  Coding question, Theorem 1, the two
   corollaries, one proof-spine paragraph, exact scope.
2. **Syndromes, distance layers, and appended columns.**  Merge the useful
   parts of the current overview and dictionary.  Establish the syndrome/NRC
   span dictionary, the locator criterion, GRS multiplier covariance, and the
   appended-column identity.
3. **The terminal pencil.**  Retain only the R5 result needed by the general
   proof: the exact split-member count, deletion budget, and the geometric
   reason it is uniform.  Move the complete R5 orbit classification and
   finite exceptional detail to its own appendix.
4. **Recursive carriers.**  Terminal reduced decomposition, component
   selection, maximal Lucas carrier, digit stripping, dimension and
   empty-carrier corollaries.
5. **Simultaneous escape.**  Composite contraction, Vandermonde grid lemma,
   degree-six selector, pointed locator theorem, threshold arithmetic, and
   witness abundance.
6. **Top distance layers and code extensions.**  Prove Theorem 1 from
   Sections 4--5; derive the MDS/NMDS classification, shell counts, aggregate
   enumerators, and the affine specialization in that order.
7. **Sharp finite-level and modular refinements.**  A short synthesis of
   what R5--R10 add beyond the uniform theorem: small-field completion,
   exact orbit laws, and the first nonempty Lucas-carrier arithmetic.
8. **Scope and open problems.**  Later Lucas carriers, sharper thresholds,
   individual NMDS enumerators, and constructive complexity.  Do not reopen
   the discarded stagewise programme.

Appendices retain the full R5--R10 arithmetic, finite certificates,
verification boundary, and imported-result ledger.  The main text should be
shorter even after adding the cofinite and NMDS conclusions.

## 3. Opening and framing

The opening should begin with the coding object rather than the proof
technology:

> Let `H` be a parity-check matrix of a generalized Reed--Solomon code.
> The distance of a syndrome from the column spans simultaneously controls
> the outer layers of the code's distance partition and the minimum distance
> obtained by appending that syndrome as a new parity-check column.  We
> determine the top two layers for the projective evaluation set after an
> arbitrary prescribed set of points is deleted, in every fixed redundancy
> over sufficiently large fields.

The next paragraph gives the exact theorem and threshold.  The third explains
the MDS/NMDS consequence.  Only then introduce the geometry: the parity-check
columns form a normal rational curve; catalecticant rank gives the persistent
carrier; simultaneous contraction reduces every other syndrome to one R5
pencil.

Use the following conceptual vocabulary consistently:

* **coding object:** top distance layers / coset-leader weight;
* **coding consequence:** MDS and NMDS appended columns;
* **geometric obstruction:** persistent and Lucas carriers;
* **proof mechanism:** simultaneous-marker locator;
* **terminal engine:** exact R5 pencil count.

Avoid making “polar induction,” “one-step lower packages,” “recursive
carriers,” or the list R5--R10 the first noun phrase of the title, abstract,
or introduction.

## 4. Title recommendation

Recommended:

> **Top distance layers and near-MDS extensions of generalized
> Reed--Solomon codes on the projective line**

Shorter alternative:

> **Distance layers and one-column extensions of generalized
> Reed--Solomon codes**

The recommended title is more precise.  It names both main coding outputs
and the actual class in the theorem: arbitrary nonzero GRS multipliers on
supports
`S=P1(F_q) minus A` in the stated high-rate range.  Full-length PRS is only
the specialization `A=empty`, so it should not delimit the title.

Do not retain “exact classifications through redundancy ten” in the title.
It makes the strongest arbitrary-redundancy theorem look secondary and
dates the paper to a stagewise programme it has now superseded.

Avoid “projective Reed--Solomon codes” as the sole code class in the title:
that narrows a theorem for point-deleted, multiplier-general GRS systems to
its full-support special case.  The qualification “on the projective line”
records the common normal-rational-curve geometry without making PRS the
outer boundary of the result.  The abstract should state the exact support
and threshold regime immediately so that “generalized Reed--Solomon” is not
read as an unsupported all-parameter claim.

## 5. Replacement and deletion map

### Replace

* Replace the current conditional `thm:main` by Theorem 1 and its two coding
  corollaries.
* Replace the “two logical layers” discussion by the carrier/selector/radius
  decomposition.
* Replace the one-step lower-package definition and finite-depth escape
  theorem by composite contraction plus simultaneous-marker escape.
* Replace the current overview tables with one dependency figure and one
  compact result table distinguishing uniform, large-characteristic, and
  fixed-field conclusions.
* Replace “From the carrier theorem to the fixed levels” by “Sharp
  finite-level and modular refinements.”

### Move or compress

* Move most of the complete R5 orbit classification out of the proof path;
  keep the terminal pencil theorem in the main text.
* Keep R6--R10 detailed proofs in appendices.  In the main text they are
  boundary refinements, not induction rungs.
* Compress the repeated reading maps, status prose, and provenance caveats.
  Preserve the actual trust boundary in one dedicated location.
* Keep per-column additive/product character formulas after the aggregate
  enumerator result, preferably in an appendix if the main text becomes
  arithmetically top-heavy.

### Delete

* every remaining headline hypothesis involving intermediate lower packages;
* every stagewise marker-budget derivation superseded by the one selector;
* duplicate explanations of split-free versus deep-hole status;
* repeated claims that R8, R9, and R10 are steps toward arbitrary redundancy.

## 6. Award-paper benchmark

The official IEEE Information Theory Society Paper Award is society-wide,
not restricted to *Transactions on Information Theory*, and tied years list
co-recipients rather than runners-up.  Across the 2021--2025 award years, the
relevant structural patterns are nevertheless unusually consistent:

* the Reed--Muller capacity papers state the field-level coding theorem first
  and isolate symmetry, nesting, or recursive boosting as the mechanism;
* the feedback paper names one new mechanism and then proves the exact regime
  in which it changes second-order performance;
* the Poisson-matching paper gives one lemma and organizes the rest of the
  paper as consequences across many coding problems;
* the two 2024 LTC/qLDPC papers state the conjecture-closing code theorem near
  the front, then explain a single construction and a local-to-global proof
  path.

The useful lesson is not their length or level of exposition.  It is the
hierarchy: one recognizable theorem, one reusable mechanism, consequences
that broaden the audience, and technical casework downstream.

No official annual best-paper/runner-up archive was found for the Springer
journal *Designs, Codes and Cryptography*.  If “DCC” meant the Data
Compression Conference, its official Capocelli archive is a student-paper
prize and lists winners but not runner-ups; it is not a sound proxy for a
modern coding-theory journal benchmark.  The paper architecture above
therefore uses the verified ITSoc sample and the strongest theorem-driven
coding papers in it, rather than inventing a DCC award series.

Sources checked:

* <https://www.itsoc.org/honors/information-theory-paper-award>
* <https://arxiv.org/abs/2110.14631>
* <https://arxiv.org/abs/2304.02509>
* <https://arxiv.org/abs/2111.03654>
* <https://arxiv.org/abs/2111.04808>
* <https://arxiv.org/abs/1812.03616>
* <https://datacompressionconference.org/capocelli-prize/>
* <https://link.springer.com/journal/10623/updates>

## 7. Red-team checks before manuscript edits

1. Verify the admissible length/rank hypotheses in Theorem 1 for arbitrary
   `s`; do not let the threshold obscure `|S|>=r` or full-rank assumptions.
2. Keep the Seroussi--Roth--Dür radius input logically separate from the new
   locator theorem and cite it at the exact inference.
3. Distinguish projective syndrome directions from affine syndrome/coset
   counts whenever factors of `q-1` enter.
4. State that GRS multipliers do not affect projective spans; do not call the
   construction literal puncturing of a fixed-dimension PRS code.
5. Ensure the split-secant family convention neither double-counts omitted-
   omitted secants nor includes endpoints.
6. Present family-aggregate enumerators as aggregates.  Do not imply that
   every member of a geometric family has the same weight enumerator.
7. Keep the witness-abundance result a lower bound and the selector algorithm
   fixed-`r`; do not advertise a uniform polynomial-time decoder.
8. Make the novelty boundary claim-specific: the classical affine deep shell,
   generic appended-column identity, and NMDS recurrence are inputs; the
   promoted contribution is their exact synthesis with the new top-two-shell
   classification and family aggregation.
9. Remove enough R5 and stagewise material that the new coding consequences
   strengthen by replacement rather than page growth.

## 8. Acceptance criterion for the rewrite

A coding theorist should be able to read the abstract, Theorem 1, and its two
corollaries and answer all of the following without learning the internal
history of the project:

* Which GRS codes and parameter range are covered?
* What are the two outer distance layers?
* Which appended columns are MDS or NMDS?
* What enumerator information is exact?
* What single obstruction remains in small characteristic?
* What mechanism proves that no other columns occur?

If any of those answers requires reading the R6--R10 appendices, the paper is
not yet organized around its strongest theorem.
