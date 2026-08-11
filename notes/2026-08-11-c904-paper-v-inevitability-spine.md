# C904 Paper V structural inevitability spine

**Lane:** \`clebsch\`

**Date:** 2026-08-11

**Status:** corrected after the hostile scalar-inertia, descent, and
circular-axiom audits.

**Purpose:** compress Paper V to structural proofs without enlarging its
geometric scope.

## Central theorem

The minimal neutral input is a normalized **metric chordal shadow**

\[
(A,Q,h),
\]

not a bare cubic on an abstract module. Here \(A\) is the relevant
five-dimensional \(A_5\)-module, \(Q\) is an actual normalized invariant
quadratic form, and \(h\) is one normalized actual chordal generator.

The output is forced through

\[
(A,Q,h)
\Longrightarrow R_h
\Longrightarrow Z_5=A_5/C_5
\Longrightarrow \Omega=A_5/D_5
\Longrightarrow q_\Pi
\Longrightarrow c=8^{-1}(q_\Pi-1)h
\Longrightarrow(c_{ijk})
\Longrightarrow[B]
\Longrightarrow D_6^\vee
\Longrightarrow H_{\mathbf F_4}.
\]

The quadratic form is essential. Over an extension containing \(\mu_3\), an
actual cubic is fixed by nontrivial scalar cube roots. An isometry preserving
both \(Q\) and \(h\) has scalar satisfying \(\lambda^2=\lambda^3=1\), hence
no scalar inertia.

The main equivalence is proved over \(\mathbf F_{11}\). Its fixed neutral
package and all formulas commute with scalar extension. Paper V does not
classify arbitrary twisted forms over every extension field.

## I. Metric chordal normal form

The character calculation

\[
\chi_5=(5,1,-1,0,0),
\qquad
\chi_{\operatorname{Sym}^3}=(35,3,2,0,0)
\]

gives

\[
\dim\operatorname{Sym}^3(A^*)^{A_5}
=\frac{35+15\cdot3+20\cdot2}{60}=2.
\]

This replaces a pencil census.

Write the chordal member as the determinant of the \(3\)-by-\(3\) Hankel
matrix. Prove scheme-theoretically that the saturation of its Jacobian ideal
is the rank-one Hankel ideal, hence the rational normal quartic \(R_h\).

For the Paper-II projection, multiplicity one reduces placement to one line.
Prove that its saturated singular scheme is the same quartic; uniqueness of
the cubic singular along that quartic selects the chordal line. One coefficient
then fixes the projected generator and the pivot \(3\).

Character theory does not select this line and does not produce the scalars
\(3\) or \(8\). This normal-form lemma is the one irreducible bridge
calculation in the paper.

## II. The special orbit derives the outer companion

Define

\[
Z_5=\coprod_{P\in\operatorname{Syl}_5(A_5)}R_h^P.
\]

Each Sylow-five subgroup is split on \(R_h\simeq\mathbf P^1\) and has two
eigenlines. The fixed subschemes are disjoint and reduced, giving

\[
Z_5\simeq A_5/C_5.
\]

The normalizer identity \(N_{A_5}(C_5)=D_5\) gives the canonical quotient

\[
Z_5=A_5/C_5\longrightarrow\Omega=A_5/D_5.
\]

This is the exact replacement for the twelve-point census. It is a constant
finite étale selector after scalar extension, not the whole set \(R_h(K)\).

Now use the literal augmentation module

\[
A_\Omega=\operatorname{Aug}(\mathbf F_{11}^\Omega).
\]

Choose an \(A_5\)-intertwiner \(T:A\to A_\Omega\) and a literal outer
permutation \(s\in N_{S(\Omega)}(A_5)\setminus A_5\). On the invariant pencil,
the operator transported from \(T^{-1}sT\) is independent of both choices:
intertwiner scalars cancel, and changing \(s\) by \(A_5\) acts trivially on
invariants. Thus \(q_\Pi\) is derived; it is not extra minimal data.

Put

\[
c=8^{-1}(q_\Pi-1)h.
\]

Prove that \(c\) has six reduced ordinary nodes in projective-frame position,
that their \(A_5\)-set is \(\Omega\), and that the printed normalization gives
the scalar \(8\). This is the geometric heart of Paper V.

## III. Simplicial conference recognition

From the normalized nodal frame extract triangle coefficients. Prove

\[
c_{ijk}^2=1,
\]

\[
c_{ijk}c_{ij\ell}c_{ik\ell}c_{jk\ell}=1,
\]

and

\[
\sum_{k\notin\{i,j\}}c_{ijk}=0.
\]

The tetrahedral identity says that the triangle signing is a multiplicative
two-cocycle on the full simplex. Its positive-degree cohomology vanishes, so
there are edge signs \(b_{ij}\), unique modulo vertex switching, with

\[
c_{ijk}=b_{ij}b_{ik}b_{jk}.
\]

For the zero-diagonal matrix \(B=(b_{ij})\),

\[
(B^2)_{ij}
=b_{ij}\sum_{k\notin\{i,j\}}c_{ijk},
\qquad
(B^2)_{ii}=5.
\]

Thus balance is exactly \(B^2=5I\).

The cocycle and balance identities are conclusions of the geometric companion
lemma, not axioms of the minimal carrier. Once proved, reconstruction is
formal. Pfaffian and determinant-norm formulas are optional invariant-line
corollaries, not recognition hypotheses.

## IV. Strict rigidity and the marking dependency lattice

Morphisms are ambient \(A_5\)-equivariant isometries preserving the actual
generator, together with the coordinated relabelings allowed by the source
papers. They are not defined to be maps induced by axis bijections.

The recovered projective frame determines the projective map. The quadratic
form and actual cubic remove its scalar ambiguity. Therefore a carrier
morphism is uniquely determined by its six-set action, proving full
faithfulness rather than assuming it.

Print the Paper-II inverse once, including pivot \(3\). Paper III returns only
its declared retained output; chart lifts and global covers carried as bridge
data are not reconstructed.

The marking object is the closure of dependencies such as

\[
h\Rightarrow L=Kh,
\qquad
(q_\Pi,h)\Rightarrow c,
\qquad
c\Rightarrow\operatorname{Sing}(c)=\Omega.
\]

It is not a Boolean lattice. Before scalar normalization, forgetting a
generator while retaining its line has fibre \(K^\times\); after normalization
the fibre is the two sheet signs.

With \(Q\) fixed, sheet reversal is \(u=-I\). It commutes with the literal
outer action \(q\), and

\[
u:(L,h,c)\mapsto(L,-h,-c),
\]

\[
q:(L,h,c)\mapsto(qL,qh,-c),
\]

\[
uq:(L,h,c)\mapsto(qL,-qh,c).
\]

The fully unmarked line/sign fibre therefore has a Klein four action. After a
line is fixed, \(8^{-1}(q_\Pi-1)\) identifies sheet sign with conference
orientation, so those two torsors are dependent.

Once these stabilizers and actions are printed, units, counits, naturality,
and categorical triangle identities follow from rigidity. They are not
separate coefficient checks.

## V. Root--weight normalization and residue

Keep the rank-five augmentation lattice distinct from the rank-six
conference lattice. For a normalized symmetric conference matrix of order
\(n\equiv2\pmod4\), put

\[
\varphi_B=\frac{I+B}{2}.
\]

The common-column argument gives the minimal stable over-lattice

\[
D_n^\vee=\mathbf Z^n+
\mathbf Z\frac{\mathbf1}{2},
\]

and

\[
\varphi_B^2-\varphi_B=\frac{n-2}{4}I.
\]

Modulo two the coefficient algebra is \(\mathbf F_4\) when
\(n\equiv6\pmod8\) and \(\mathbf F_2\times\mathbf F_2\) when
\(n\equiv2\pmod8\). In the split case print one line showing that
\(\bar\varphi_B\) is neither \(0\) nor \(1\), so the algebra acts faithfully.

At \(n=6\), identify the canonical nonsplit sequence

\[
0\longrightarrow H
\longrightarrow D_6^\vee/2D_6^\vee
\longrightarrow\mathbf F_4
\longrightarrow0.
\]

The \((2,3,5)\)-presentation relation norms have ranks \((1,0,0)\), giving

\[
\operatorname{Ext}^1_{\mathbf F_4A_5}(\mathbf F_4,H)
\simeq\mathbf F_4.
\]

Golden reversal \(B\mapsto-B\) sends
\(\varphi\mapsto1-\varphi\), which becomes Frobenius on the primitive
\(\mathbf F_4\)-scalars. This proves the Cartesian golden/exotic torsor square.

## The five proof engines

The published proof has exactly five load-bearing lemmas:

1. metric chordal normal form;
2. special orbit and outer companion;
3. simplicial conference recognition;
4. strict rigidity and marking fibres;
5. root--weight normalization and residual heart.

V.A--V.H may remain as theorem labels, but they are corollaries or
specializations of these engines.

## Exact hand checks

Only the following numerical normalizations remain:

- one character inner product;
- one geometric discriminator for the Paper-II line;
- pivot \(3\);
- outer-difference scalar \(8\);
- one split \(C_5\) fixed-point calculation;
- one node/axis identification;
- the sheet/outer action;
- relation-norm ranks \((1,0,0)\).

Each is printed as a human calculation. Scripts replay them but support no
load-bearing statement.

## What is no longer promised

- classification of arbitrary twisted \(K\)-forms;
- a carrier defined by the conference conclusions it must reconstruct;
- full faithfulness obtained by excluding scalar maps by fiat;
- a Boolean marking poset;
- character-theoretic determination of the Paper-II scalar placement;
- a computer-dependent theorem;
- reconstruction of Paper-III inputs outside its retained output;
- a common geometric carrier with Paper IV.

## Publication headline

> A normalized metric chordal shadow determines its special
> \(C_5\)-orbit, its canonical six-axis normalizer quotient, and by outer
> difference its unique oriented golden conference companion. The exact
> residual involution becomes Frobenius on the exotic \(\mathbf F_4\)-heart
> after canonical root--weight normalization.

This formulation makes the correspondence inevitable without pretending that
its one special geometric placement calculation is formal.
