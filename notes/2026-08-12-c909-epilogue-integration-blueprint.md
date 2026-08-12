# C909 — integration blueprint for the cubic-stabilization epilogue

Date: 2026-08-12

Status: pre-manuscript planning authority.  No manuscript, PDF, mirror, Lean,
or export edit is authorized by this document.  Implementation begins only
after this plan is committed and hostile-audited.

## 0. Full-paper reread baseline

This blueprint was revised only after a linear reread of the complete current
paper: the root file, all five included sections, the claim/proof/novelty
ledger, and the paper-local README.  The current build is sixteen pages.  The
integration below is therefore designed as proof compression and theorem
replacement, not as a sequence of appendices added to an earlier thirteen-page
snapshot.

The reread fixes two architectural constraints.

* Section 3 already contains a substantial local-cofactor ladder.  The new
  all-degree theorem must subsume and shorten that ladder; it must not sit
  beside it as a second local theory.
* Section 4 is the paper's densest source interface.  The birational
  abstraction and the \(V_{14}\) application may occupy one short terminal
  subsection, but they may not displace the formal-monodromy descent or the
  weak-factorization calculation.

## 1. Editorial objective

Preserve the paper's present title and its clean separation theorem:

> a non-isotrivial family of universally \(CH_0\)-trivial cubic threefolds
> remains irrational after one \(\mathbf P^1\)-stabilization, and every
> smooth cubic threefold remains irrational after that stabilization.

The new mathematics must make the two proof mechanisms more reusable without
turning the paper into a survey of C907/C909 discoveries.  The cycle branch
receives one classification/sharpness upgrade.  The quantum branch receives
one birational abstraction and one noncubic application.  Neither branch is
allowed to absorb its broader research programme.

Target length after integration: 18--20 pages, up from the current sixteen.
Absolute ceiling: 21 pages including references.  If the draft crosses that
ceiling, move the indecomposable-tower construction or ancillary local Smith
tables to a separate successor; do not compress the quantum trust boundary.

## 2. Headline theorem hierarchy after integration

The paper should expose four theorem surfaces, in this order.

### A. Cubic separation theorem — unchanged headline

For every smooth member \(X_b\) of the nonstandard \(A_5\)-pencil,
\[
 X_b\text{ is universally }CH_0\text{-trivial},\qquad
 X_b\times\mathbf P^1\text{ is irrational}.
\]
The family is non-isotrivial.

### B. One-step irrationality for all cubics — unchanged headline

For every smooth cubic threefold \(X\),
\(X\times\mathbf P^1\) is irrational.

### C. Integral cycle-side classification — new structural theorem

State a compact two-part theorem.

1. **Finite-etale PD saturation.**  For a marked polarized elliptic-power
   graph presentation with its elliptic ruling and self-dual kernel retained,
   assume an orthogonal depth decomposition, block-respecting
   \(B\)-self-adjoint slopes, and a finite-etale slope algebra on every
   positive-depth block.  Then the divided-power envelope of its prescribed
   graph Neron--Severi lattice equals the ordinary divisor-product image in
   every degree.  Consequently every divided power \(\Theta^{[k]}\) of the
   descended principal polarization is an ordinary divisor product.
2. **Dimension-five ambient sharpness.**  For non-CM rank-five packets:
   * the actual six-axis packet has
     \(\operatorname{Hdg}^{2k}=P^k\) in every degree;
   * the equal-depth, five-distinct-root tower has
     \[
       \operatorname{Hdg}^{4}/P^2\cong
       \operatorname{Hdg}^{6}/P^3\cong(\mathbf Z/p^a)^5,
     \]
     with zero quotient in the other degrees, and multiplication by theta is
     the canonical complement isomorphism between the two nonzero quotients.

This theorem supplies a genuine classification/sharpness pair.  It must not
say that the illustrative distinct-root tower is the cubic packet.  It must
also distinguish the prescribed graph NS lattice from the enlarged full NS
lattice at CM fibres.

### D. Low-dimensional birational invariance and \(V_{14}\) — new quantum corollary

State in a short subsection after the cubic quantum proof:

1. \(\nu_6\) is birationally invariant for smooth projective varieties of
   dimension at most four.
2. Therefore it is invariant under one \(\mathbf P^1\)-stabilization of
   smooth projective threefolds; equivalently, if
   \(Y\times\mathbf P^1\dashrightarrow Z\times\mathbf P^1\), then
   \(\nu_6(Y)=\nu_6(Z)\).
3. With the exact Kuznetsov theorem locus and the cubic atom normalization,
   \[
      \nu_6(V_{14})=2,\qquad
      V_{14}\times\mathbf P^1\text{ is irrational}
   \]
   for every smooth genus-eight prime Fano threefold \(V_{14}\).

This is the only noncubic quantum application added.  It shows that the
method is stable-birational rather than a cubic-specific operator trick.
Kuznetsov's comparison is geometric: honest rank-two projective bundles over
the \(V_{14}\) and its associated smooth Pfaffian cubic are related by a
flop.  No transport of quantum atoms through a derived equivalence is used.

## 3. Exact manuscript surgery

### Abstract

Keep three paragraphs.

1. Retain the two cubic headlines exactly.
2. Replace the current cofactor paragraph by no more than three sentences:
   * a general marked finite-etale graph theorem makes every divided
     polarization power an ordinary divisor product;
   * the actual six-axis packet is fully integral-Hodge saturated on the
     non-CM locus;
   * neighboring rank-five packets have exact middle defect
     \((\mathbf Z/p^a)^5\), showing that this saturation is special rather
     than formal.
3. Retain the cubic monodromy paragraph.  Add only one terminal sentence:
   the same atom count is birationally invariant through dimension four and,
   after the exact comparison theorem, gives one-step irrationality for every
   smooth genus-eight \(V_{14}\).

The abstract should grow by at most roughly fifty words.  If the exact value
\(\nu_6(V_{14})=2\) needs an auxiliary classification not otherwise used in
the paper, state only the irrationality consequence in the abstract and keep
the normalization in the body.

Do not mention conformal blocks, Dyck paths, WCI classifications, toric
pilots, \(V_5\), \(V_{22}\), or \(X\times\mathbf P^2\) in the abstract.

### Introduction

Retain the first two headline theorems.  Do not insert a third theorem box
before them.  After their explanation, add one compact ``Cycle-side
structure'' theorem containing C above, followed by one paragraph explaining
repeated-root saturation versus distinct-root defect.  This keeps the cubic
separation theorem as the first editorial surface while making the general
cycle result independently visible.

Replace the present single paragraph beginning ``Local cofactor saturation''
by a proof-map paragraph:

* projective finite-etale spectral packets split the graph divisor lattice
  into rank-one square-zero pieces;
* dimension five reduces the ambient quotient to four-slot Pluecker
  supports;
* repeated roots annihilate those supports in the six-axis packet;
* distinct roots give exactly five middle \(p^a\)-defects.

Add one sentence near Theorem B announcing the dimension-four birational
invariance and \(V_{14}\) corollary, but defer proof and details.

Keep the stable-rationality boundary exactly conservative: no claim for
\(X\times\mathbf P^2\), and no suggestion that full stable irrationality is
near.  The reason printed remains that fivefold weak factorizations admit
threefold centers carrying cubic packets.

### Section 2 — six-axis envelope

Do not enlarge it.  Make two surgical repairs only.

1. Add at most one forward-reference sentence after the local packet
   proposition saying that repeated residual roots will be the reason the
   full dimension-five Hodge/product quotient vanishes.
2. Delete the unused \(\Gamma_0(3)\) monodromy/Borel clause from the current
   packet proposition unless a pinpoint source is actually used downstream.
   Scalarity of the three-primary block is the needed input; an unused
   arithmetic refinement should not remain as a referee seam.

### Section 3 — primitive minimal class

Rename the section, provisionally:

> Integral divisor products and the primitive minimal class.

Reorganize into four subsections.

#### 3.1 Local graph lattices and rank-one generation

Retain the current graph descent congruence and primitive mixed-coefficient
lemma.  Replace, rather than supplement, the present cofactor/slope ladder by
the exact matrix-of-ideals statement after unramified spectral splitting.
Prove the rank-one generation criterion in the form actually needed:
\[
 e_{ij}\ge\left\lceil\frac{a_i+a_j}{2}\right\rceil.
\]
For finite-etale graph packets the exact cross-depth formula implies this
inequality.  Express every symmetric generator as an integral signed sum of
rank-one forms without dividing by two, including at \(p=2\).

#### 3.2 All divided powers

State and prove finite-etale PD saturation.  If
\(\Theta=\sum_iD_i\) with each \(D_i^2=0\), then
\[
 \Theta^{[k]}=\sum_{|I|=k}\prod_{i\in I}D_i.
\]
Use finite unramified faithful-flat descent on the quotient lattice, never a
trace or averaging map.  The present local cofactor theorem and its
semisimple/squarefree corollaries become the \(k=g-1\) shadow of this theorem;
retain only the shortest corollary needed to make contact with the existing
minimal-class proof.  Do not describe scalar blocks as a second mechanism:
they are squarefree one-point spectral blocks.

#### 3.3 Complete dimension-five ambient quotient

Give the certificate-free four-slot proof.

* Decompose by multidegrees \((2^{k-\ell},1^{2\ell})\).
* In dimension five, \(\ell\le2\); only four distinct slots can contribute.
* Prove the two-matching weighted Pluecker lemma.
* Derive the actual repeated-root six-axis vanishing at \(p=2,3\).
* Derive the five-distinct-root quotient \((\mathbf Z/p^a)^5\) in degrees
  four and six.
* Prove the theta complement isomorphism directly, not by invoking Poincare
  duality alone.

The illustrative tower construction is optional.  Include only one sentence
that arbitrarily deep polarized-indecomposable examples exist, unless the
construction can be stated and proved in at most one page.  No finite
certificate appears in this section.

#### 3.4 Cubic consequence

Strengthen the existing theorem:

* generic non-CM six-axis fibres have full integral Hodge/product saturation;
* every smooth fibre has the primitive minimal class as an ordinary divisor
  product, including CM/special fibres where extra NS classes may occur;
* Voisin yields universal \(CH_0\)-triviality fibrewise.

Do not claim a horizontal cycle or a relative decomposition of the diagonal.

### Section 4 — one-step irrationality

Leave the formal-monodromy and weak-factorization proof intact except for
cross-reference cleanup.  Add a final subsection:

> Further birational consequences.

Its proof should occupy about one page.

1. Weak factorization in dimension at most four uses centers of dimension at
   most two; low-dimensional vanishing makes every blowup step preserve
   \(\nu_6\).
2. Rank-two projective bundles satisfy
   \(\nu_6(\mathbf P_Y(E))=2\nu_6(Y)\).  Birational projectivizations thus
   give equality after cancellation in \(\mathbf Z\).  Since a projective
   bundle is birational to \(Y\times\mathbf P^1\), this is one-step stable-
   birational invariance.
3. Quote Kuznetsov at the exact verified theorem locus and deduce the
   \(V_{14}\) statement.  Do not state it until the source audit confirms
   ``every smooth \(V_{14}\)'', the smooth cubic target, and honest rank-two
   projective bundles connected by a birational map/flop.  Derived-category
   equivalence alone is not enough.
4. Audit the numerical equality separately.  The current cubic proposition
   proves \(\nu_6(X)\ge2\), not by itself \(\nu_6(X)=2\).  Printing
   \(\nu_6(V_{14})=2\) requires the following additional printed lemma.  The
   odd \(H^3\)-summand of a cubic is killed by small quantum multiplication by
   \(H\) for degree reasons and has grading residue zero, hence monodromy one;
   Cai's remaining two one-dimensional even blocks also have integral
   residue.  Together with his rank-two block this gives exactly two sixth
   roots.  The parity-equivariant formal-isomonodromy bridge already used in
   the section must then be invoked to preserve this exact count on the
   connected reduced unramified atom component.  No weighted-complete-
   intersection classification is needed.

### Section 5 — synthesis

Keep the first proof paragraph.  Replace the next discussion by a short
four-corner summary:

| cycle mechanism | quantum mechanism |
|---|---|
| finite-etale rank-one splitting | low-dimensional carrier exclusion |
| six-axis repeated-root saturation | all-cubic \(\nu_6\ne0\) |
| distinct-root towers show sharpness | \(V_{14}\) shows noncubic reach |

Use prose if the table costs too much visual space.

The final boundary paragraph must say only:

* \(m=2\) is open because threefold centers enter;
* no stable irrationality theorem is claimed;
* no relative universal cycle is constructed;
* the full higher-rank integral Smith formula is not used.

## 4. Proof dependency graph

\[
\begin{array}{c}
\text{six-axis norms/Prym bridge}\to
\text{actual }6I-J\text{ packet}\to
\text{repeated-root four-slot saturation}\to
\text{full generic Hodge/product equality}\\
\hspace{4.7cm}\searrow
\Theta^{[4]}\text{ product-generated}\to
\text{Voisin}\to CH_0
\end{array}
\]

\[
\text{finite-etale graph packet}\to
\text{rank-one NS generation}\to
\text{all divided powers}\to
\text{minimal-class corollary}.
\]

\[
\text{framed formal monodromy}+\text{blowup formula}+
\text{low-dimensional vanishing}
\to\nu_6\text{ birational for }\dim\le4
\to
\begin{cases}
X\times\mathbf P^1\text{ irrational},\\
V_{14}\times\mathbf P^1\text{ irrational}.
\end{cases}
\]

No arrow is asserted between the cycle and quantum diagrams.

## 5. Source and trust gates

Before implementation, require:

1. two independent audits of the actual six-axis four-slot calculation
   — passed;
2. the bounded priority audit separating Milne's rational Lefschetz theorem
   from the new integral weighted quotient — passed;
3. exact theorem/page verification of Kuznetsov's \(V_{14}\)--cubic
   projectivization correspondence — passed: Theorems 2.17--2.18 give the
   flop of honest rank-two projective bundles for every smooth \(V_{14}\);
4. an independent exact justification of \(\nu_6(X)=2\), rather than the
   currently printed lower bound \(\nu_6(X)\ge2\) — passed at the small
   point by the odd-\(H^3\) grading calculation, with the existing formal-
   isomonodromy bridge to be cited explicitly for atomwise continuation;
5. a cold reread of the revised Section 3 by an abelian-variety specialist;
6. a cold reread of the new Section 4 subsection by a quantum/birational
   specialist;
7. full PDF-first editorial reread after the build.

Discovery scripts and finite checks remain outside the proof surface.  The
six-axis and dimension-five proofs must be printed as exterior-algebra and
local-lattice arguments.

## 6. Explicit exclusions

Do **not** integrate:

* \(X\times\mathbf P^2\), stable irrationality, Rees/Stokes/Gamma moonshots;
* weighted-complete-intersection classifications;
* \(V_5\), \(V_{10}\), \(V_{22}\), or prime-Fano tables;
* toric pilots or Gröbner/Fitting fan calculations;
* the all-rank Dyck-height Smith conjecture;
* moving conformal blocks, except possibly one outlook sentence in a future
  successor paper—not this epilogue;
* CM full-Hodge equality, horizontal Chow cycles, or a relative diagonal;
* a common Eisenstein cycle--quantum invariant.

These exclusions preserve the paper's thesis and keep every added theorem
either structurally explanatory or immediately geometric.

## 7. Claim-ledger additions

Add four rows to the paper-local claim/proof/novelty ledger:

1. all-degree finite-etale PD saturation;
2. actual six-axis full integral Hodge/product saturation at non-CM fibres;
3. exact rank-five distinct-root middle defect and theta complement;
4. low-dimensional birational invariance of \(\nu_6\);
5. the \(V_{14}\) projective-bundle comparison and atom normalization.

For cycle claims, credit Milne for rational divisor generation, Yu for the
tropical PSD midpoint skeleton, and the existing integral-Fourier sources for
their actual ranges.  The claimed contribution is the signed integral DVR
lift, exact graph lattice, faithful-flat descent, and weighted Smith
classification.

## 8. Acceptance test for the integrated draft

The integration passes only if a cold reader can answer, from the abstract
and first two pages:

1. What is the main geometric separation theorem?
2. What general cycle theorem makes the family inevitable?
3. Why is the six-axis packet stronger than a generic etale packet?
4. What does the distinct-root tower prove sharp?
5. Why does the quantum invariant apply beyond cubics?
6. Where does the proof stop, and why does it not prove stable irrationality?

If any answer requires the series backstory, the integration has failed.

## 9. Implementation sequence

1. Freeze the Kuznetsov source and exact-\(\nu_6\) normalization audits.
2. Edit Section 3 first and compile in isolation.
3. Add the Section 4 birational-consequences subsection.
4. Rewrite abstract and introduction against the landed theorem statements,
   not against this plan.
5. Rewrite synthesis and scope boundary.
6. Update bibliography, claim ledger, README, and page map.
7. Build, run TeX/log/diff checks, then conduct three independent cold reads.
8. Revise once, rebuild, and export only after all theorem surfaces agree.

## 10. Hostile-audit disposition

The committed blueprint received independent cycle and quantum audits after
the complete-paper reread.

### Cycle audit: GO with seven mandatory repairs

The audit independently recomputed the two- and three-primary four-slot
quotients and found no hidden Pluecker cancellation.  It confirmed full
\(\operatorname{Hdg}^{2k}=P^k\) for the actual non-CM six-axis packet and
the exact \((\mathbf Z/p^a)^5\) comparison quotient.  Implementation must:

1. state the general theorem on the marked graph presentation, not a bare
   ppav;
2. use the \(B\)-self-adjoint convention and exact cross-ideal formula;
3. keep divided-power saturation distinct from ambient Hodge saturation;
4. print the weighted two-matching/four-support table;
5. print the literal-power integral invariant-generation lemma;
6. call the three-primary scalar block a one-point etale block, not a Jordan
   mechanism; and
7. retain the non-CM, fibrewise, and nonrelative boundaries.

### Quantum audit: GO after source and normalization closure

The dimension-four birational-invariance argument and \(\mathbf P^1\)
stabilization passed.  Cancellation occurs in \(\mathbf Z\), not in the atom
group.  Kuznetsov's exact geometric theorem applies to every smooth
\(V_{14}\) and supplies the required flop of honest projective bundles.  The
initial audit correctly rejected deriving the result from categorical
equivalence; the primary-source audit removes that concern.

The audit also identified the missing upper bound in the current manuscript.
It closes internally: \(H*H^3=0\), the odd grading residue is zero, and Cai's
full even calculation leaves exactly one primitive-sixth pair.  The revised
proof must state the parity-equivariant formal-isomonodromy continuation.
Until that sentence and lemma are printed, retain \(\nu_6\ge2\) in the old
manuscript; after the repair, \(\nu_6=2\) and the \(V_{14}\) corollary are
licensed.

### Final planning verdict

**GO for implementation, subject to the listed printed proof obligations.**
The red teams rejected no proposed theorem after the scope repairs.  They did
reject three tempting shortcuts: an unmarked-ppav formulation, an inference
from PD saturation to full Hodge saturation, and transport of quantum data by
derived equivalence alone.

## 11. Expected mathematical and editorial effect

The integrated paper ceases to be merely a striking conjunction.  It becomes
a paper with two reusable structural mechanisms and two sharp external
calibrations:

* cycle side: repeated-root saturation versus distinct-root defect;
* quantum side: cubic family versus \(V_{14}\) stable-birational transport.

That raises the mathematical coherence and top-journal plausibility without
changing the title or sacrificing the clean separation narrative.  The
appropriate stretch remains JAMS/Inventiones, with JEMS/Duke/Compositio as
realistic strong venues after specialist validation.  Annals is plausible
only if the printed structural theorems feel inevitable and the recent
quantum source interfaces survive hostile review; no venue claim belongs in
the manuscript itself.
