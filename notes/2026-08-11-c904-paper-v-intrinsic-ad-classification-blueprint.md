# C904 Paper V intrinsic V.A/V.D classification blueprint

**Lane:** `clebsch`

**Date:** 2026-08-11

**Status:** corrected proof architecture after the hostile \(\mu_3\), descent,
and circular-axiom audits. The existing exact marked round trip supplies the
maps. This note specifies the stronger intrinsic theorem that Paper V may
honestly promise.

## 1. Scope before objects

The main classification is over \(\mathbf F_{11}\). For every extension
\(K/\mathbf F_{11}\), Paper V also proves functorial scalar extension of this
fixed neutral package and all of its equations.

This is not, without a separate descent theorem, a classification of every
twisted \(K\)-form satisfying the same geometric equations. Accordingly:

- \(\mathscr G(K)\) denotes the neutral quadratically framed scalar extensions
  of the fixed carrier;
- split nodes, split special orbits, and the actual quadratic normalization
  remain part of that neutral framing;
- arbitrary forms and their \(H^1\)-classification are outside Paper V.

This is exactly the scope required by the other papers in the series.

## 2. The minimal intrinsic object

Fix the group-theoretic six-set and its quadratic augmentation:

\[
\Omega_0=\operatorname{Syl}_5(A_5)\simeq A_5/D_5,
\qquad
A_0=\operatorname{Aug}(\mathbf F_{11}^{\Omega_0}),
\qquad
Q_0(x)=\sum_{\omega\in\Omega_0}x_\omega^2.
\]

In the basis \(e_i-e_6\), \(Q_0\) has Gram matrix \(I+J\) and determinant
\(6\). This fixes the augmentation isometry class; an arbitrary scalar
multiple of the invariant form is not admitted.

A **metric chordal shadow** is a nonzero actual generator

\[
h\in\operatorname{Sym}^3(A_0^*)^{A_5}
\]

whose saturated Jacobian scheme is a rational normal quartic \(R_h\).
Initially every nonzero scalar multiple of \(h\) is allowed. The normalized
source subcategory is cut out later by one scalar equation on the
outer-difference coefficient; no triangle identity is assumed.

Morphisms are \(A_5\)-equivariant \(Q_0\)-isometries preserving the actual
\(h\),
together with exactly the coordinated relabelings declared in the source
categories. This choice is load-bearing. If \(K\) contains \(\mu_3\), then a
scalar \(\zeta I\) with \(\zeta^3=1\) preserves a cubic; requiring preservation
of \(Q_0\) also gives \(\zeta^2=1\), and therefore \(\zeta=1\).

Each source functor must supply this normalization. Papers I and III use the
standard permutation form on their six-axis augmentation. Paper II uses its
invariant self-duality; under the multiplicity-one bridge, one printed Gram
coefficient, evaluated with the same intertwiner already fixed by the cubic
pivot, identifies it with \(Q_0\). The intertwiner may not be rescaled
afterward.

## 3. What must be derived from the minimal object

Starting from \(h\), perform the following functorial construction.

1. Let \(R_h\) be the saturated Jacobian scheme of \(h\).
2. Define the special fixed-point divisor

   \[
   Z_5=\coprod_{P\in\operatorname{Syl}_5(A_5)}R_h^P.
   \]

   Prove scheme-theoretically that its twelve fixed points are reduced and
   pairwise disjoint and that each point has as stabilizer its unique Sylow
   \(C_5\). Hence it is split and a transitive \(A_5\)-scheme of type
   \(A_5/C_5\). It is not canonically identified with a chosen coset model:
   its equivariant automorphism group is \(N(C_5)/C_5\simeq C_2\).
3. Use the stabilizer map to form the canonical quotient

   \[
   Z_5\longrightarrow
   \operatorname{Syl}_5(A_5)=\Omega_0.
   \]
   This is the intrinsic geometric recovery of the fixed group-theoretic
   six-set.
4. Choose an involutive literal permutation in the nontrivial coset of
   \(N_{S(\Omega_0)}(A_5)/A_5\), and let it act on the invariant
   pencil

   \[
   \Pi=\operatorname{Sym}^3(A_0^*)^{A_5}.
   \]

   The resulting \(q_\Pi\) is canonical. Changing the representative by
   \(A_5\) acts trivially on \(\Pi\).
5. Independently construct on \(\Omega_0\) the unique unordered pair
   \(\{[B],[-B]\}\) of \(A_5\)-invariant order-six conference switching
   classes. Each orientation supplies an actual coefficient-normalized
   triangle cubic, giving a canonical pair \(\{\pm c_B\}\subset\Pi^-\).
   Prove that the
   outer normalizer exchanges its two orientations and that its triangle
   cubic spans the anti-invariant line \(\Pi^-\).
6. Since the two chordal lines are exchanged by \(q_\Pi\),
   \((q_\Pi-1)h\) is nonzero and lies in \(\Pi^-\). For either normalized
   conference generator \(c_B\), write

   \[
   (q_\Pi-1)h=\alpha c_B.
   \]

   The normalized source locus is the single intrinsic scalar condition

   \[
   \alpha^2=8^2.
   \]

   On each selected chordal line it leaves exactly the two sheet signs (four
   normalized generators across the two lines) and selects the orientation
   for which \(c=8^{-1}(q_\Pi-1)h=c_B\).
7. Import Paper I's established conference-cubic theorem to obtain the six
   ordinary nodes, their identification with \(\Omega_0\), and the triangle
   sign, cocycle, and balance identities. Simplicial acyclicity reconstructs
   the same switching class as a formal corollary.

Thus the actual causal chain is

\[
h\to R_h\to Z_5\to\Omega_0\to\{[B],[-B]\}
\to\Pi^-\leftarrow(q_\Pi-1)h.
\]

The expanded tuple
\((A_0,Q_0,\Pi,R_h,Z_5,\Omega_0,q_\Pi,L,h,c,[B])\) is an output and a convenient
bookkeeping carrier. It is not the recognition hypothesis.

## 4. The assertions that must not be axioms

The following are theorems:

- the chordal locus in the invariant pencil consists of two reduced members;
- the literal outer permutation exchanges them;
- the special \(C_5\)-orbit quotient equals the nodal six-set;
- the unique conference pair spans the anti-invariant pencil line;
- outer difference produces the conference companion;
- the triangle coefficients satisfy the tetrahedral and balance identities;
- the reconstructed conference package returns the original chordal shadow.

Using these statements in the carrier definition would make essential
surjectivity circular. The scalar equation \(\alpha^2=8^2\) is imposed only
after the conference pair and anti-invariant line have been constructed
independently; it assumes no triangle identity.

## 5. Exact statement of V.A

Define independently:

- \(\mathscr C_{\mathrm{conf}}^L\): oriented golden conference packages with
  a selected compatible chordal line, modulo switching and coordinated
  relabeling;
- \(\mathscr C_{\mathrm{ch}}^\times\): metric chordal shadows with any
  nonzero actual generator;
- \(\mathscr C_{\mathrm{ch}}\subset\mathscr C_{\mathrm{ch}}^\times\): the
  normalized subcategory cut out by \(\alpha^2=8^2\);
- \(\mathscr G_{\mathrm{met}}^\times\): the expanded metric carriers derived
  from arbitrary nonzero \(h\);
- \(\mathscr G_{\mathrm{met}}\subset\mathscr G_{\mathrm{met}}^\times\): the
  normalized subcategory \(\alpha^2=8^2\);
- \(\mathscr C_{\mathrm{III}}^{\mathrm{ret}}\): Paper III's declared retained
  output, with its bridge decoration carried rather than reconstructed.

Then V.A asserts equivalences over \(\mathbf F_{11}\)

\[
\mathscr C_{\mathrm{conf}}^L
\simeq
\mathscr G_{\mathrm{met}}
\simeq
\mathscr C_{\mathrm{ch}},
\]

and an equivalence between the appropriately decorated carrier and
\(\mathscr C_{\mathrm{III}}^{\mathrm{ret}}\).

The bare conference category is the quotient of
\(\mathscr C_{\mathrm{conf}}^L\) by the residual selected-line \(C_2\); under
the equivalence it is

\[
\mathscr C_{\mathrm{conf}}
\simeq
\mathscr C_{\mathrm{ch}}/\langle uq\rangle,
\qquad (q_\Pi-1)(-q_\Pi h)=(q_\Pi-1)h.
\]

Thus it is not equivalent to the selected-line chordal category. This
residual double cover is part of the headline marking theorem.

Before restriction to the normalized subcategories, \(q_\Pi-1\) gives a
\(K^\times\)-equivariant isomorphism on each selected punctured chordal line.
Globally the two chordal lines have the residual deck involution \(uq\). The
normalized selected-line equivalence is the two-sign restriction.

For every \(K/\mathbf F_{11}\), the same functors give equivalences between
the neutral scalar extensions of these groupoids. Paper V does not enlarge
this to all \(K\)-forms.

### Fully faithful

An isometric carrier morphism is determined by its permutation of the
recovered projective frame and its action on the actual generator. The
quadratic form removes \(\mu_3\) inertia. Preservation of the frame,
\(q_\Pi\), and \(h\) forces preservation of the conference pair, \(c\), and
the recovered switching class. Conversely each allowed coordinated
relabeling induces the unique such isometry.

This is a theorem about ambient isometries. Morphisms must not be defined as
“the induced maps from six-axis bijections,” since that would build full
faithfulness into the category.

### Essentially surjective

Starting from a metric chordal shadow:

1. recover \(Z_5\to\Omega_0\);
2. construct the unique conference pair on \(\Omega_0\);
3. derive \(q_\Pi\) from the literal permutation normalizer;
4. identify the conference cubic with \(\Pi^-\);
5. use one coefficient to obtain \((q_\Pi-1)h=\alpha c_B\);
6. restrict to \(\alpha^2=8^2\) for the normalized source categories;
7. invoke Paper I for nodes and triangle identities;
8. apply the one printed Paper-II inverse formula, including pivot \(3\);
9. return only Paper III's declared retained output.

None of these steps may begin with an image restriction.

## 6. Exact statement of V.D

The marking structure is the closure of a dependency relation, not the
Boolean lattice on a list of names. Its basic implications include

\[
h\Rightarrow L=Kh,
\qquad
(q_\Pi,h)\Rightarrow c,
\qquad
c\Rightarrow\operatorname{Sing}(c)=\Omega_0.
\]

The table must distinguish:

- the projective chordal line \(L\);
- a scalar trivialization of \(L\);
- the two normalized actual generators \(\{\pm h\}\);
- the conference orientations \(\{\pm c\}\);
- the two chordal lines;
- outer/Petersen labels and the six-set embedding.

Before scalar normalization, forgetting a generator while retaining its line
has fibre \(K^\times\). After \(\alpha^2=8^2\), the fibre is the two sheet
signs. The outer-difference map is \(K^\times\)-equivariant on the
unnormalized punctured lines and restricts to the two normalized signs.

With \(Q\) fixed, sheet reversal is the actual isometry \(u=-I\). The outer
permutation \(q\) commutes with \(u\), and

\[
u:(L,h,c)\longmapsto(L,-h,-c),
\]

\[
q:(L,h,c)\longmapsto(qL,qh,-c),
\]

\[
uq:(L,h,c)\longmapsto(qL,-qh,c).
\]

These formulas define a Klein four action only at the forgetful vertex where
the selected line, sheet sign, conference orientation, and any outer label
moved by \(q\) have all been forgotten. At that vertex prove that the action
is free and transitive. It is not the fibre action at every vertex of the
dependency lattice. After a line is fixed, the map
\(8^{-1}(q_\Pi-1)\) identifies sheet sign with conference orientation, so
those two \(C_2\)-torsors are not independent.

Here \(u\) is an automorphism only after the actual sign of \(h\) is
forgotten. Likewise \(q\) is a morphism only in a category allowing the
coordinated outer relabeling. Choose an involutive outer permutation, or state
the action modulo coordinated \(A_5\)-relabeling.

For every forgetful edge print:

| datum | required theorem |
|---|---|
| stabilizer | automorphism group before and after forgetting |
| fibre | the transitive action groupoid, not its cardinality |
| dependencies | closure under the implications above |
| sharpness | an actual isometry moving the forgotten datum |
| compatibility | action on every retained marking |

A count of possible values is not a torsor theorem.

## 7. Four proof engines

V.A--V.D and the arithmetic close require only four load-bearing lemmas.

1. **Metric chordal normal form.** Character-theoretic pencil dimension,
   determinantal singular scheme, and structural placement of the Paper-II
   projection, with pivot \(3\) printed once.
2. **Special orbit and unique conference pair.** The \(C_5\)-fixed divisor,
   canonical stabilizer quotient, and the unique \(A_5\)-fixed order-six
   conference pair via the normalized five-vertex \(2\)-regular core
   \(=C_5\); then outer exchange, actual anti-invariant cubic pair, and scalar
   \(8\). Paper I supplies nodes and triangle identities.
3. **Strict rigidity and return.** Full faithfulness, one inverse formula,
   source returns, marking dependencies, and sharpness actions.
4. **Root--weight normalization and residue.** The general \(D_n^\vee\)
   saturation theorem, the split/inert mod-eight dichotomy, the order-six
   \(\mathbf F_4\)-heart, Ext line, and Frobenius torsor.

Units, counits, categorical triangle identities, base change of the fixed
package, simplicial reconstruction, and Pfaffian/norm identities are
corollaries after these lemmas.

## 8. Hand calculations that remain

The structural proof still prints:

- the character inner product giving \(\dim\Pi=2\);
- one geometric discriminator locating the Paper-II chordal line;
- one Gram coefficient identifying the Paper-II self-duality with
  \(Q_0\) using the same normalized intertwiner;
- the pivot \(3\);
- the outer-difference scalar \(8\);
- one split Sylow-five fixed-point calculation;
- uniqueness of the order-six conference pair and its outer exchange;
- the actual sheet/outer action;
- the relation-norm ranks \((1,0,0)\) for the Ext line.

The script may replay these numbers, but no theorem depends on an exhaustive
matrix or coefficient census.

## 9. Acceptance tests

The corrected V.A/V.D package fails if:

1. \(\mu_3\) inertia reappears in the scalar-extension groupoid;
2. \(Q\) is weakened to a similitude line without another coprime-degree
   rigidification;
3. arbitrary \(K\)-forms are conflated with base change of the neutral object;
4. the exact-\(C_5\)-to-node identification is assumed;
5. a triangle ratio, cocycle, or balance identity is placed in the minimal
   recognition definition;
6. morphisms are defined by the conclusion of full faithfulness;
7. an unnormalized generator is assigned a two-point fibre, or the
   \(V_4\)-action is assigned to the wrong forgetful vertex;
8. Paper III is claimed to reconstruct a chart or cover carried as input;
9. two binary markings are called independent despite the \(q-1\) map;
10. a certificate replaces the geometric placement or nodal-frame proof.

## 10. Payoff

The repaired theorem says:

> A normalized metric chordal shadow recovers its special \(C_5\)-orbit, the
> canonical six-axis normalizer quotient, and by outer difference its unique
> oriented conference companion. The exact marking loss is the same
> involution that becomes Frobenius after root--weight normalization.

This is an intrinsic classification theorem rather than an image-restricted
round trip, while remaining within the neutral marked geometry actually used
by the series.
