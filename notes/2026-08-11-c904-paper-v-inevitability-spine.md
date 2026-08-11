# C904 Paper V structural inevitability spine

**Lane:** `clebsch`

**Date:** 2026-08-11

**Status:** corrected after the hostile scalar-inertia, descent, and
circular-axiom audits.

**Purpose:** compress Paper V to structural proofs without enlarging its
geometric scope.

## Central theorem

Fix the neutral quadratic augmentation

\[
\Omega_0=\operatorname{Syl}_5(A_5),\qquad
A_0=\operatorname{Aug}(\mathbf F_{11}^{\Omega_0}),\qquad
Q_0(x)=\sum_{\omega\in\Omega_0}x_\omega^2.
\]

The minimal variable input is a nonzero actual chordal generator
\(h\in\operatorname{Sym}^3(A_0^*)^{A_5}\). The source normalization is imposed
only after the unique conference pair has been constructed.

The output is forced through

\[
h
\Longrightarrow R_h
\Longrightarrow Z_5\longrightarrow\Omega_0
\Longrightarrow q_\Pi
\Longrightarrow\{[B],[-B]\}
\Longrightarrow\Pi^-\longleftarrow(q_\Pi-1)h
\Longrightarrow D_6^\vee
\Longrightarrow H_{\mathbf F_4}.
\]

The fixed quadratic form is essential. Over an extension containing \(\mu_3\), an
actual cubic is fixed by nontrivial scalar cube roots. An isometry preserving
both \(Q_0\) and \(h\) has scalar satisfying \(\lambda^2=\lambda^3=1\), hence
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

For the Paper-II projection, multiplicity one for the relevant
\(A_5\)-equivariant source map reduces placement to one image line; this is
not a claim that the invariant pencil \(\Pi\) is one-dimensional.
Prove that its saturated singular scheme is the same quartic; uniqueness of
the cubic singular along that quartic selects the chordal line. One coefficient
then fixes the projected generator and the pivot \(3\).

The same already normalized bridge transports Paper II's invariant
self-duality. One Gram coefficient identifies it with \(Q_0\); the
intertwiner is not rescaled afterward. Papers I and III already carry that
form on their six axes.

Character theory does not select this line and does not produce the scalars
\(3\) or \(8\). This normal-form lemma is the one irreducible bridge
calculation in the paper.

## II. The special orbit derives the outer companion

Define

\[
Z_5=\coprod_{P\in\operatorname{Syl}_5(A_5)}R_h^P.
\]

Each Sylow-five subgroup is split on \(R_h\simeq\mathbf P^1\) and has two
eigenlines. The twelve fixed points are pairwise disjoint and reduced, and
each has as stabilizer its unique Sylow \(C_5\), so \(Z_5\) is a
transitive \(A_5\)-scheme of type \(A_5/C_5\). There is no canonical
identification with a chosen coset model: its equivariant automorphism group
is \(N(C_5)/C_5\simeq C_2\). What is canonical is the stabilizer map

\[
Z_5\longrightarrow\Omega_0=\operatorname{Syl}_5(A_5)\simeq A_5/D_5.
\]

This is the exact replacement for the twelve-point census. It is a constant
finite étale selector after scalar extension, not the whole set \(R_h(K)\).

Choose an involutive literal outer permutation
\(s\in N_{S(\Omega_0)}(A_5)\setminus A_5\). Its action \(q_\Pi\) on the
invariant pencil is independent of the representative because \(A_5\) acts
trivially on invariants.

Independently construct the unique unordered pair
\(\{[B],[-B]\}\) of \(A_5\)-invariant order-six conference switching classes
on \(\Omega_0\). Their orientations give a canonical pair of actual
coefficient-normalized cubics \(\{\pm c_B\}\subset\Pi^-\). Prove that the
outer normalizer exchanges the two orientations. Since the chordal
lines are exchanged,

\[
(q_\Pi-1)h=\alpha c_B
\]

for a nonzero scalar \(\alpha\) and either normalized conference generator
\(c_B\). Define the normalized source locus by the single equation

\[
\alpha^2=8^2.
\]

On each selected chordal line it leaves exactly the two sheet signs (four
normalized generators across both lines) and selects the orientation for
which \(c=8^{-1}(q_\Pi-1)h=c_B\). Paper I's established conference-cubic theorem
then gives the six ordinary nodes, their identification with \(\Omega_0\),
and every triangle identity. This is shorter than a second nodal calculation.

The bridge is an isomorphism only after a chordal line is selected. Globally

\[
(q_\Pi-1)(-q_\Pi h)=(q_\Pi-1)h,
\]

so \(uq:h\mapsto-q_\Pi h\) is the residual deck involution and the bare
conference category is the quotient of the chordal category by
\(\langle uq\rangle\). This double cover is part of the marking theorem, not
an error term.

## III. Simplicial conference corollary

For the imported conference cubic, the triangle coefficients satisfy

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

This is a structural explanation and an optional independent reconstruction
of the unique conference pair, not a separate load-bearing engine. Pfaffian
and determinant-norm formulas are likewise optional invariant-line
corollaries.

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
c\Rightarrow\operatorname{Sing}(c)=\Omega_0.
\]

It is not a Boolean lattice. Before scalar normalization, forgetting a
generator while retaining its line has fibre \(K^\times\); after
\(\alpha^2=8^2\) the fibre is the two sheet signs on each selected chordal
line (four normalized generators across both lines).

With \(Q_0\) fixed, sheet reversal is \(u=-I\). It commutes with the literal
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

These formulas give a Klein four action only at the vertex where the selected
line, sheet sign, conference orientation, and any moved outer label are all
forgotten; prove it free and transitive there. The map \(u\) is an
automorphism only after the sign is forgotten, and \(q\) is a morphism only
when coordinated outer relabeling is allowed. After a line is fixed,
\(8^{-1}(q_\Pi-1)\) identifies sheet sign with conference orientation, so
those two torsors are dependent.

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

## The four proof engines

The published proof has exactly four load-bearing lemmas:

1. metric chordal normal form;
2. special orbit, unique conference pair, and outer companion;
3. strict rigidity and marking fibres;
4. root--weight normalization and residual heart.

V.A--V.H may remain as theorem labels, but they are corollaries or
specializations of these engines.

## Exact hand checks

Only the following numerical normalizations remain:

- one character inner product;
- one geometric discriminator for the Paper-II line;
- one Gram normalization for the Paper-II quadratic form;
- pivot \(3\);
- outer-difference scalar \(8\);
- one split \(C_5\) fixed-point calculation;
- uniqueness of the order-six conference pair up to switching and relabeling;
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

> A normalized chordal cubic on the standard quadratic augmentation
> determines its special \(C_5\)-orbit, its canonical stabilizer six-set, and by outer
> difference its unique oriented golden conference companion. The exact
> residual involution becomes Frobenius on the exotic \(\mathbf F_4\)-heart
> after canonical root--weight normalization.

This formulation makes the correspondence inevitable without pretending that
its one special geometric placement calculation is formal.
