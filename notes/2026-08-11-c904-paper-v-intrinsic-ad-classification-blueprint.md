# C904 Paper V intrinsic V.A/V.D classification blueprint

**Lane:** \`clebsch\`

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

A **metric chordal shadow** is a triple

\[
(A,Q,h)
\]

with the following data.

1. \(A\) is the five-dimensional absolutely irreducible
   \(\mathbf F_{11}A_5\)-module.
2. \(Q\) is an actual normalized nondegenerate \(A_5\)-invariant quadratic
   form. It is not merely its line or a similitude class.
3. \(h\in\operatorname{Sym}^3(A^*)^{A_5}\) is an actual chordal generator
   whose saturated Jacobian scheme is a rational normal quartic \(R_h\).
4. The scalar of \(h\) is fixed by the intrinsic companion normalization:
   after the construction below, the triangle coefficients of
   \(8^{-1}(q_\Pi-1)h\) have square one. The two resulting choices are the
   sheet signs.

Morphisms are \(A_5\)-equivariant isometries preserving the actual \(h\),
together with exactly the coordinated relabelings declared in the source
categories. This choice is load-bearing. If \(K\) contains \(\mu_3\), then a
scalar \(\zeta I\) with \(\zeta^3=1\) preserves a cubic; requiring preservation
of \(Q\) also gives \(\zeta^2=1\), and therefore \(\zeta=1\).

Equivalently, after the six-set has been recovered, one may use the literal
quadratic augmentation module

\[
A_\Omega=\operatorname{Aug}(\mathbf F_{11}^{\Omega}),
\qquad
Q_\Omega(x)=\sum_{\omega\in\Omega}x_\omega^2.
\]

The abstract and literal formulations are equivalent through an isometry
unique after the actual generator is fixed.

## 3. What must be derived from the minimal object

Starting from \((A,Q,h)\), perform the following functorial construction.

1. Let \(R_h\) be the saturated Jacobian scheme of \(h\).
2. Define the special fixed-point divisor

   \[
   Z_5=\coprod_{P\in\operatorname{Syl}_5(A_5)}R_h^P.
   \]

   Prove that it is reduced, split, and canonically \(A_5/C_5\).
3. Take the normalizer quotient

   \[
   Z_5=A_5/C_5\longrightarrow
   \Omega=A_5/N_{A_5}(C_5)=A_5/D_5.
   \]
4. Identify \(A\) isometrically with the quadratic augmentation of \(\Omega\).
   Let \(s\) be any literal permutation in the nontrivial coset of
   \(N_{S(\Omega)}(A_5)/A_5\), and transport its action to the invariant
   pencil

   \[
   \Pi=\operatorname{Sym}^3(A^*)^{A_5}.
   \]

   The resulting \(q_\Pi\) is canonical: changing the intertwiner by a scalar
   cancels in conjugation, while changing \(s\) by \(A_5\) acts trivially on
   \(\Pi\).
5. Put

   \[
   c=8^{-1}(q_\Pi-1)h.
   \]

6. Prove that \(c\) has six reduced ordinary nodes in projective-frame
   position and that its nodal \(A_5\)-set is the same \(\Omega\).
7. Extract its normalized triangle coefficients \(c_{ijk}\). Prove the sign,
   tetrahedral, and balance identities:

   \[
   c_{ijk}^2=1,
   \]

   \[
   c_{ijk}c_{ij\ell}c_{ik\ell}c_{jk\ell}=1,
   \]

   \[
   \sum_{k\notin\{i,j\}}c_{ijk}=0.
   \]

8. Reconstruct the unique edge signing modulo switching and hence the
   oriented conference matrix \(B\).

Thus the actual causal chain is

\[
(A,Q,h)\to R_h\to Z_5\to\Omega\to q_\Pi\to c
\to(c_{ijk})\to[B].
\]

The expanded tuple
\((A,Q,\Pi,R_h,Z_5,\Omega,q_\Pi,L,h,c,[B])\) is an output and a convenient
bookkeeping carrier. It is not the recognition hypothesis.

## 4. The assertions that must not be axioms

The following are theorems:

- the chordal locus in the invariant pencil consists of two reduced members;
- the literal outer permutation exchanges them;
- the special \(C_5\)-orbit quotient equals the nodal six-set;
- outer difference produces the conference companion;
- the triangle coefficients satisfy the tetrahedral and balance identities;
- the reconstructed conference package returns the original chordal shadow.

Using these statements in the carrier definition would make essential
surjectivity circular. The only permitted normalization condition involving
the triangle coefficients is their common square-one scalar condition; it
selects the two actual generators on a previously recognized chordal line but
does not assert cocycle or balance.

## 5. Exact statement of V.A

Define independently:

- \(\mathscr C_{\mathrm{conf}}\): oriented golden conference packages modulo
  switching and coordinated relabeling;
- \(\mathscr C_{\mathrm{ch}}\): metric chordal shadows with actual normalized
  generator;
- \(\mathscr G_{\mathrm{met}}\): the expanded metric carriers derived in
  Section 3;
- \(\mathscr C_{\mathrm{III}}^{\mathrm{ret}}\): Paper III's declared retained
  output, with its bridge decoration carried rather than reconstructed.

Then V.A asserts equivalences over \(\mathbf F_{11}\)

\[
\mathscr C_{\mathrm{conf}}
\simeq
\mathscr G_{\mathrm{met}}
\simeq
\mathscr C_{\mathrm{ch}},
\]

and an equivalence between the appropriately decorated carrier and
\(\mathscr C_{\mathrm{III}}^{\mathrm{ret}}\).

For every \(K/\mathbf F_{11}\), the same functors give equivalences between
the neutral scalar extensions of these groupoids. Paper V does not enlarge
this to all \(K\)-forms.

### Fully faithful

An isometric carrier morphism is determined by its permutation of the
recovered projective frame and its action on the actual generator. The
quadratic form removes \(\mu_3\) inertia. Preservation of the frame,
\(q_\Pi\), and \(h\) forces preservation of \(c\), the triangle class, and
the recovered switching class. Conversely each allowed coordinated
relabeling induces the unique such isometry.

This is a theorem about ambient isometries. Morphisms must not be defined as
“the induced maps from six-axis bijections,” since that would build full
faithfulness into the category.

### Essentially surjective

Starting from a metric chordal shadow:

1. recover \(Z_5\) and \(\Omega\);
2. derive \(q_\Pi\) from the literal permutation normalizer;
3. construct \(c\) by outer difference;
4. prove its nodal-frame and triangle identities;
5. reconstruct \(B\) by simplicial acyclicity and balance;
6. apply the one printed Paper-II inverse formula, including pivot \(3\);
7. return only Paper III's declared retained output.

None of these steps may begin with an image restriction.

## 6. Exact statement of V.D

The marking structure is the closure of a dependency relation, not the
Boolean lattice on a list of names. Its basic implications include

\[
h\Rightarrow L=Kh,
\qquad
(q_\Pi,h)\Rightarrow c,
\qquad
c\Rightarrow\operatorname{Sing}(c)=\Omega.
\]

The table must distinguish:

- the projective chordal line \(L\);
- a scalar trivialization of \(L\);
- the two normalized actual generators \(\{\pm h\}\);
- the conference orientations \(\{\pm c\}\);
- the two chordal lines;
- outer/Petersen labels and the six-set embedding.

Before scalar normalization, forgetting a generator while retaining its line
has fibre \(K^\times\). After the square-one normalization, the fibre is the
two sheet signs.

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

Thus the fully unmarked sheet/line fibre carries a Klein four action. After a
line is fixed, however, the map \(8^{-1}(q_\Pi-1)\) identifies sheet sign with
conference orientation, so those two \(C_2\)-torsors are not independent.

For every forgetful edge print:

| datum | required theorem |
|---|---|
| stabilizer | automorphism group before and after forgetting |
| fibre | the transitive action groupoid, not its cardinality |
| dependencies | closure under the implications above |
| sharpness | an actual isometry moving the forgotten datum |
| compatibility | action on every retained marking |

A count of possible values is not a torsor theorem.

## 7. Five proof engines

V.A--V.D and the arithmetic close require only five load-bearing lemmas.

1. **Metric chordal normal form.** Character-theoretic pencil dimension,
   determinantal singular scheme, and structural placement of the Paper-II
   projection, with pivot \(3\) printed once.
2. **Special orbit and outer companion.** The \(C_5\)-fixed divisor,
   \(D_5\)-normalizer quotient, canonical \(q_\Pi\), six-node compatibility,
   and scalar \(8\).
3. **Simplicial conference recognition.** Triangle signs, cocycle, balance,
   switching reconstruction, and \(B^2=5I\).
4. **Strict rigidity and return.** Full faithfulness, one inverse formula,
   source returns, marking dependencies, and sharpness actions.
5. **Root--weight normalization and residue.** The general \(D_n^\vee\)
   saturation theorem, the split/inert mod-eight dichotomy, the order-six
   \(\mathbf F_4\)-heart, Ext line, and Frobenius torsor.

Units, counits, categorical triangle identities, base change of the fixed
package, and Pfaffian/norm identities are corollaries after these lemmas.

## 8. Hand calculations that remain

The structural proof still prints:

- the character inner product giving \(\dim\Pi=2\);
- one geometric discriminator locating the Paper-II chordal line;
- the pivot \(3\);
- the outer-difference scalar \(8\);
- one split Sylow-five fixed-point calculation;
- one representative node/axis identification;
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
5. cocycle or balance is placed in the minimal recognition definition;
6. morphisms are defined by the conclusion of full faithfulness;
7. an unnormalized generator is assigned a two-point fibre;
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
