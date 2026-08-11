# C904 Paper V non-diluting upgrade: hostile audit and revised plan

**Lane:** `clebsch`

**Date:** 2026-08-11

**Scope:** theorem architecture for Paper V only. No manuscript, Lean,
rank-ten symplectic, cubic, Chow, or quantum changes are authorized here.

**Forward correction:** the subsequent hostile audit found \(\mu_3\) scalar
inertia and circular expanded axioms in V.A--V.D. The repaired plan is
`2026-08-11-c904-paper-v-intrinsic-ad-classification-blueprint.md`: fix the
standard quadratic augmentation \((A_0,Q_0)\), classify normalized cubics
\(h\) on its neutral base changes, recover the canonical stabilizer six-set,
derive the outer action from its literal permutation normalizer, and use the
unique unordered pair of \(A_5\)-invariant conference switching classes plus
\(\alpha^2=8^2\) for orientation. The
marking object is a dependency lattice. The V.E--V.H conclusions below
remain valid.

## Verdict

Paper V can be strengthened without becoming a holding pen for the geometric
epilogue. The safe upgrade is not to add more Clebsch objects. It is to make
the reconstruction output and its residual ambiguity intrinsic, then expose
the exact integral lattice tower carried by the recovered six-set.

The strongest revised spine is:

1. exact marked-groupoid equivalence and sharp reconstruction fibres;
2. a coordinate-free six-set lattice tower separating rank five from rank
   six;
3. a precise residual-field/Frobenius rigidification lemma;
4. a general symmetric-conference root--weight saturation theorem;
5. the order-six \(A_5\) Ext specialization and Cartesian golden/exotic
   torsor square.

This broadens the paper toward reconstruction theory, modular representation
theory, conference lattices, and descent while keeping every theorem causal
for the existing series.

## Hostile audit of the tempting upgrades

### 1. A generic shadow-functor theorem can be vacuous

It is formal that a functor of groupoids has homotopy fibres and that a free
group action gives a torsor. No venue-strength theorem results from stating
this abstractly.

**Repair.** Compute the declared Clebsch fibres intrinsically. For every
source functor print:

- equations characterizing its essential image;
- the full automorphism stabilizer;
- the exact residual fibre;
- the least rigidification making the functor an equivalence;
- an explicit sharpness witness after that rigidification is forgotten.

The general language is useful only as compression around these exact
calculations.

The complete intrinsic axiom scheme, inverse proof, and forgetful-fibre table
specification are recorded in
`2026-08-11-c904-paper-v-intrinsic-ad-classification-blueprint.md`.

### 2. The current interface conflated two lattices

The rank-five augmentation lattice

\[
A_{\mathrm{aug}}(\Omega)=\ker(\mathbf Z^\Omega\to\mathbf Z)
\]

feeds the later rank-ten symplectic envelope. The golden normalization instead
uses the rank-six \(D\)-type lattice

\[
D(\Omega)=\{x\in\mathbf Z^\Omega:\sum x_\omega\equiv0\pmod2\}
\]

and its dual for the standard permutation pairing

\[
D(\Omega)^\vee=\mathbf Z^\Omega+
\mathbf Z\frac{\mathbf1_\Omega}{2}.
\]

Calling either one merely the "augmentation/root lattice" hides the actual
handoff and risks a rank error.

**Repair.** Make the full lattice tower Theorem V.E and identify its common
four-dimensional six-point heart

\[
\operatorname{Aug}(\mathbf F_2^\Omega)/
\langle\mathbf1_\Omega\rangle.
\]

This is a genuine mathematical upgrade: it explains how the rank-five
epilogue input and rank-six normalization theorem meet without identifying
them.

### 3. The general conference theorem must not overclaim maximality

For normalized symmetric conference \(B\) of order
\(n\equiv2\pmod4\), the elementary and useful uniform statement is

\[
D_n^\vee\text{ is minimally stable under }(I+B)/2,
\qquad
\varphi_B^2-\varphi_B=\frac{n-2}{4}I.
\]

Modulo two the coefficient algebra is \(\mathbf F_4\) for
\(n\equiv6\pmod8\) and split for \(n\equiv2\pmod8\). The associated
quadratic order need not be maximal for arbitrary \(n\).

**Repair.** State the uniform root--weight/residue theorem as V.G and reserve
"maximal golden order" for \(n=6\). Treat V.G as a supporting general theorem,
not the paper's principal novelty.

### 4. The torsor square is relative, not absolutely canonical

The outer action on the recovered six-set induces a nontrivial map

\[
\operatorname{Out}(A_5)\to
\operatorname{Gal}(\mathbf F_4/\mathbf F_2),
\]

hence an isomorphism. But an abstract identification of two unnamed groups of
order two is not the claim. The map is canonical relative to the recovered
six-set action and the normalization lattice.

**Repair.** Print the Cartesian square of principal \(C_2\)-torsors and state
its naturality under switching and relabelling. This gives later
deck-equivariance for free while avoiding false absolute canonicity.

### 5. Ext classes and middle modules are different moduli problems

The Ext line has three nonzero vectors. They remain distinct when the
submodule and quotient are rigidified. Scalar automorphisms make their middle
modules isomorphic.

**Repair.** State both assertions:

\[
\operatorname{Ext}^1_{\mathbf F_4A_5}(\mathbf F_4,H)\simeq\mathbf F_4,
\]

and \(D_6^\vee/2D_6^\vee\) is the unique nonsplit middle module up to
isomorphism. Do not call it "the unique nonzero Ext class."

### 6. Paper IV supplies an instance, not a second carrier

The \(C_3\)-orbit in Paper IV and the \(C_2\)-orientation torsor in Paper V
have different groups, modules, bases, and geometries.

**Repair.** Put them under one conditional Frobenius-orbit commutant lemma: a
simple \(\mathbf F_qG\)-module whose scalar extension is a multiplicity-free orbit
of \(r\) absolutely simple constituents has commutant \(\mathbf F_{q^r}\).
Choosing one constituent is a \(C_r\)-rigidification. Verify the hypotheses in
each paper separately and assert no map between the carriers.

### 7. Base change and recognition algorithms are not core upgrades

A theorem over all good characteristics requires precise integral models,
essential-image equations, and bad-prime control. An algorithmic recognition
section risks returning to certificate-led exposition.

**Repair.** Include scalar-extension functoriality only where it is formal
from the printed equations. Put an effective recognition corollary in a final
remark or omit it. Do not open a general arithmetic family theorem in V.

## Revised theorem packet

- **V.A:** equivalence of the three exact marked companion groupoids, with
  intrinsic essential images.
- **V.B:** involution-difference bridge.
- **V.C:** natural round trips and triangle identities.
- **V.D:** exact marking boundary and sharp residual fibres.
- **V.E:** coordinate-free six-set lattice tower and common heart.
- **V.F:** residual rigidification and the conditional Frobenius-orbit
  commutant mechanism; Paper IV appears only as the degree-three parallel
  instance.
- **V.G:** general symmetric-conference root--weight saturation and mod-eight
  residue dichotomy.
- **V.H:** golden order-six specialization, one-dimensional Ext line, unique
  nonsplit middle module, and Cartesian golden/exotic torsor square.

The paper's main headline remains the marked companion correspondence. V.E--H
make its output reusable; they do not replace the correspondence with a
conference-matrix side paper.

## Structural proof budget

The whole paper should use only:

1. one groupoid fibre/stabilizer lemma;
2. multiplicity one;
3. the involution-difference lemma;
4. carrier rigidity;
5. the coordinate-free lattice tower;
6. the Frobenius-orbit commutant lemma;
7. the common-column proof of conference saturation;
8. the \((2,3,5)\)-presentation Ext calculation.

No exhaustive matrix table, computer-dependent lemma, rank-ten gluing, or
geometric application belongs in the proof.

Expected length: **22--28 pages**. If the paper grows beyond this, first
compress repeated functor definitions and relegate recognition algorithms;
do not delete the lattice-tower distinction or the order-six torsor square.

## Reach and venue effect

The revised paper speaks to four audiences:

- reconstruction and invariant theory: exact fibres and minimal markings;
- algebraic combinatorics: symmetric conference matrices and switching;
- integral representation theory: root--weight saturation and the modular
  heart;
- descent/moduli: residual Frobenius torsors and naturality.

The bounded source audit finds Robin Chapman's skew/imaginary
conference-lattice construction as the closest general predecessor and
Haemers--Parsaei Majd for the symmetric spectral setting. Bleher's block
description preempts uniqueness of the relevant uniserial \(A_5\)-module over
an algebraic closure. Thus the safe novelty is the exact reconstruction,
lattice-tower, and torsor synthesis, not any ingredient separately.

Opening full-text count inherited from the focused bridge audit: two
(Chapman; Haemers--Parsaei Majd). Bleher was read at the relevant Section 3.3
and Lemma 3.5; the small-weight cohomology comparison was partial and excludes
the defining-characteristic-two case used here. The additional exact web
queries found no symmetric real/root--weight statement, but MathSciNet,
Scopus, and an external specialist check remain outside the bounded audit.

Strength after the upgrade: **A-minus structural paper**. Advances or JCTA is
the natural band; Compositio becomes credible if V.A and V.D are genuinely
intrinsic classification theorems rather than category language around known
maps. JEMS remains a stretch unless the reconstruction-profile theorem is
shown useful beyond the Clebsch examples. This is not an Annals paper and
should not be inflated into one.

## Kill criteria

Remove or demote an upgrade if any of the following occurs:

1. an essential image is defined as the image of the reconstruction functor;
2. a claimed residual group is inferred only from a count, not a torsor
   action and stabilizer calculation;
3. \(A_{\mathrm{aug}}(\Omega)\) and \(D(\Omega)\) are conflated;
4. V.G requires a case census rather than the common-column argument;
5. V.H calls all nonzero Ext vectors one extension class;
6. the Paper IV comparison asserts a common carrier or geometric arrow;
7. base-change language introduces unanalysed bad characteristics;
8. any load-bearing proof cites a replay certificate instead of a structural
   lemma.

## Final recommendation

Adopt V.E--V.H exactly in this bounded form. The coordinate-free lattice tower
is the most important correction; the Cartesian torsor square is the most
important conceptual upgrade; the general conference theorem is the cheapest
broadening; and the reconstruction-profile sharpness theorem remains the
largest determinant of venue.
