# C904 Paper V inevitability spine: hostile audit and Tao compression

**Lane:** `clebsch`

**Date:** 2026-08-11

**Scope:** theorem architecture for Paper V. This note audits
`2026-08-11-c904-paper-v-inevitability-spine.md` and
`2026-08-11-c904-paper-v-intrinsic-ad-classification-blueprint.md`. It makes
no manuscript or Lean edits.

## Verdict

The inevitability strategy is a genuine upgrade, but the current strongest
formulation has two major defects:

1. the proposed all-extension intrinsic groupoid has hidden scalar
   automorphisms; and
2. the expanded carrier axioms assume most of the reconstruction theorem
   that they are meant to prove.

After repairing those points, the central causal chain is sound:

\[
(A,Q,h)
\longrightarrow R_h
\longrightarrow Z_5=A_5/C_5
\longrightarrow \Omega=A_5/D_5
\longrightarrow q_\Pi
\longrightarrow c=8^{-1}(q_\Pi-1)h
\longrightarrow [B]
\longrightarrow D_6^\vee
\longrightarrow H_{\mathbf F_4}.
\]

Here $Q$ is an actual normalized invariant quadratic form, $R_h$ is the
singular rational normal quartic, and $q_\Pi$ is the operator on the
invariant pencil induced by the literal permutation normalizer of the
recovered six-set. The form $Q$ is not decorative: it is the clean
rigidification that makes the groupoid honest after scalar extension.

The correct publication verdict is **GO after a major statement repair**.
The mathematics needed for the repair is small; the logical correction is
not.

## 1. The first genuine failure: cubic roots of unity

Let $K/\mathbf F_{11}$ contain a primitive cube root of unity. If morphisms
are arbitrary $A_5$-linear isomorphisms preserving an actual cubic $h$,
then

\[
\zeta I_A\quad (\zeta^3=1)
\]

fixes $h$, its singular scheme, the recovered six-set, and the induced
operator on the invariant pencil. Thus an actual cubic does **not** kill all
scalar automorphisms uniformly over $K$. In particular, full faithfulness
cannot be proved by saying that arbitrary scalar intertwiners are excluded;
that exclusion would be built into the definition rather than derived.

There are three honest exits.

1. State the oriented classification over $\mathbf F_{11}$, and retain the
   existing theorem that its fixed marked package commutes with scalar
   extension. This is weaker than classifying every $K$-form.
2. Work with the literal quadratic augmentation module
   \[
   A_\Omega=\operatorname{Aug}(K^\Omega),\qquad
   Q_\Omega(x)=\sum_{\omega\in\Omega}x_\omega^2,
   \]
   and isometric morphisms.
3. Put an actual normalized invariant form $Q$ in the abstract carrier and
   require isometries. Then a scalar automorphism preserving both $Q$ and
   $h$ satisfies $\lambda^2=\lambda^3=1$, hence $\lambda=1$.

The second formulation is cleanest for a six-set theorem. The third is
cleanest if the chordal shadow is to recover the six-set rather than assume
it. A line of invariant quadratic forms or a similitude class is not enough;
an actual normalization is required.

This repair also makes the marking theorem honest. Before $h$ is fixed,
$-I$ is the actual sheet-reversal isometry of the line-marked carrier. Once
an actual $h$ is retained, that automorphism disappears. Thus the sign
fibre has a real sharpness witness rather than only two possible values.

## 2. The outer operator really is derived, but the construction must be
printed

There is no residual sign ambiguity in $q_\Pi$ once the six-set has been
recovered. Let

\[
A_\Omega=\operatorname{Aug}(K^\Omega),
\]

choose an $A_5$-intertwiner $T:A\to A_\Omega$, and choose a literal
permutation $s\in N_{S(\Omega)}(A_5)\setminus A_5$. Define the action on
the pencil through $T^{-1}sT$.

- Replacing $T$ by $\lambda T$ changes nothing.
- Replacing $s$ by $gs$, $g\in A_5$, changes the operator on $A$ by
  $g$, but changes nothing on
  $\Pi=\operatorname{Sym}^3(A^*)^{A_5}$.

Therefore $q_\Pi$ is canonical. The alternative abstract extension
$-T^{-1}sT$ is not induced by the literal permutation normalizer and is not
an ambiguity in this construction.

The logical order is consequently

\[
h\to R_h\to Z_5\to\Omega\to A_\Omega\to q_\Pi\to c,
\]

not $A\to q$ by an unnamed outer lift. This one paragraph must appear in
the proof because it is what makes the proposed minimal carrier theorem true.

## 3. Base change is not classification of all forms

The current paper proves that the **fixed marked package** over
$\mathbf F_{11}$ and its matrix identities commute with every extension
$K/\mathbf F_{11}$. It does not yet classify all intrinsic $K$-objects
or their twisted forms.

The proposed statement

\[
\mathscr C_{\rm conf}(K)\simeq\mathscr G(K)
\simeq\mathscr C_{\rm ch}(K)
\]

is therefore safe only if the three groupoids are explicitly the neutral,
quadratically framed scalar extensions of the fixed carrier. If they contain
all forms satisfying geometric equations, then descent and automorphism
torsors must be classified. Split nodes, an actual normalized $Q$, and the
constant exact-$C_5$ divisor can force the neutral form, but that argument
must be stated; it is not a consequence of flat base change alone.

The best Paper V choice is:

- prove the intrinsic strict classification over $\mathbf F_{11}$;
- prove functorial base change of that classified package;
- leave classification of arbitrary twisted $K$-forms out unless the
  marking-poset theorem is deliberately upgraded to an $H^1$-classification.

This loses no theorem used elsewhere in the series.

## 4. The current intrinsic axioms are circular

The expanded carrier is useful bookkeeping, but it cannot be the recognition
hypothesis if the paper is to prove inevitability from one chordal shadow.

- “Exactly two chordal members exchanged by $q$” is already the chordal
  classification.
- “The exact-$C_5$ pairing is the nodal six-set” is the main geometric
  compatibility theorem.
- “$q-1$ sends $h$ to $z$” is the companion theorem.
- The sign, tetrahedral, and balance equations already reconstruct the
  conference switching class.

These statements may define the **expanded output object**, but essential
surjectivity from that object is then nearly tautological.

The minimal admissibility condition should instead be a metric chordal
shadow:

1. a normalized quadratic $A_5$-module $(A,Q)$ of the required
   five-dimensional type;
2. an actual normalized invariant cubic $h$;
3. the single geometric condition that the saturated Jacobian scheme of
   $h$ is a rational normal quartic carrying the standard faithful
   $A_5$-action.

The theorem, not the definition, should prove the special $C_5$ orbit,
normalizer quotient, outer companion, six ordinary nodes, triangle signs,
and balance. If normalization of $h$ cannot be stated without the recovered
triangle coefficients, declare that scalar trivialization as one marking and
classify its two signs; do not hide it in the adjective “normalized.”

## 5. What character theory can and cannot replace

For

\[
\chi_5=(5,1,-1,0,0)
\]

on the five conjugacy classes of $A_5$, the symmetric-cube character is

\[
\chi_{\operatorname{Sym}^3}=(35,3,2,0,0),
\]

and hence

\[
\dim\operatorname{Sym}^3(A^*)^{A_5}
=\frac{35+15\cdot3+20\cdot2}{60}=2.
\]

This is the correct structural proof of the pencil dimension. Character
theory also explains multiplicity one and reduces equivariant placement to a
line.

It does **not** identify the Paper-II tensor with the chordal line, choose the
outer twist, or produce the normalized scalar $8$. Those require one
geometric discriminator and one coefficient. The right compression is not to
pretend that these disappear; it is to isolate them in a single normal-form
lemma:

> the projected Paper-II cubic has the chordal saturated Jacobian scheme; the
> unique equivariant placement is therefore the chordal member, and one
> printed coefficient fixes the pivot $3$ and outer-difference scalar $8$.

The five-by-five intertwiner may be printed as a coordinate choice or moved
to an appendix, but the proof must explain it by multiplicity one and the
singular-scheme discriminator. A thirty-five-coefficient certificate is then
replay evidence, not a theorem premise.

## 6. The orbit and simplex replacements are valid, with precise scope

The special divisor on $R_h\simeq\mathbf P^1$ is not the whole set
$R_h(K)$. It is the constant reduced finite étale scheme

\[
Z_5=\coprod_{P\in\operatorname{Syl}_5(A_5)}R_h^P
\simeq A_5/C_5.
\]

Its normalizer quotient is

\[
A_5/C_5\longrightarrow A_5/N_{A_5}(C_5)=A_5/D_5.
\]

One fixed-point computation, the fact that every Sylow-five subgroup has two
split eigenlines, and self-normality of $D_5$ replace the twelve-point
census. Merely finding one point with stabilizer $C_5$ would not exclude
extra orbits; the fixed-subscheme argument does.

The simplex argument is exact. If

\[
c_{ijk}c_{ij\ell}c_{ik\ell}c_{jk\ell}=1,
\]

then simplicial acyclicity produces edge signs $b_{ij}$, unique modulo
vertex switching, with

\[
c_{ijk}=b_{ij}b_{ik}b_{jk}.
\]

Moreover

\[
(B^2)_{ij}
=b_{ij}\sum_{k\notin\{i,j\}}c_{ijk},
\qquad
(B^2)_{ii}=5.
\]

Thus pair balance is exactly $B^2=5I$. The only nonformal burden is proving
the triangle sign and balance identities for the geometrically constructed
cubic. Those identities cannot be declared formal consequences of
naturality.

## 7. Tao compression: five load-bearing lemmas

Paper V does not need eight quasi-independent theorem blocks. The entire
structural proof can be organized around five lemmas.

### Lemma I. Metric chordal normal form

Prove the two-dimensional invariant pencil, the determinantal chordal member,
the saturated rational-normal-quartic Jacobian scheme, and the structural
placement of the Paper-II projection. Print only the pivot $3$ and one
coefficient normalization.

### Lemma II. Special orbit and outer companion

Construct $Z_5=A_5/C_5\to\Omega=A_5/D_5$, transport the literal permutation
normalizer to $q_\Pi$, and prove that

\[
c=8^{-1}(q_\Pi-1)h
\]

has six ordinary nodes equal to $\Omega$ in projective-frame position. This
is the irreducible geometric heart; the scalar $8$ is printed once.

### Lemma III. Simplicial conference recognition

Prove the triangle signs, tetrahedral identity, and balance for $c$. Use
simplex cohomology to reconstruct the unique oriented switching class and
derive $B^2=5I$. Pfaffian and determinant-norm identities become optional
corollaries obtained from invariant lines and one scalar.

### Lemma IV. Strict rigidity and marking fibres

Use isometric ambient morphisms, the recovered projective frame, and the
actual generator to prove full faithfulness. Print one inverse formula for
Paper II, return only Paper III's declared retained output, and compute the
actual actions generated by outer exchange and sheet reversal. Units,
counits, naturality, and categorical triangle identities are then formal
corollaries of rigidity; they are not separate calculations.

### Lemma V. Root--weight normalization and residue

Prove the general common-column theorem for $D_n^\vee$, including the
one-line nonscalar check in the split mod-eight case. Specialize to $n=6$,
identify the commutator heart, compute the Ext line, and prove that golden
reversal becomes Frobenius. This contains the lattice tower, the general
conference result, and the golden/exotic torsor square in one causal block.

The paper may label corollaries V.A--V.H for navigation, but the proof should
visibly have only these five engines.

## 8. Exact marking action

The marking object is a dependency lattice, not the Boolean lattice on the
names appearing in the expanded tuple. In particular,

\[
h\Rightarrow L=Kh,
\qquad
(q,h)\Rightarrow c=8^{-1}(q-1)h,
\qquad
c\Rightarrow \operatorname{Sing}(c)=\Omega.
\]

If a chordal generator has not been normalized by an actual polynomial
condition, forgetting it while retaining its line has fibre $K^\times$, not
$C_2$. The fibre becomes the two sheet signs only after the scalar
normalization is printed and proved to cut the line in exactly two points.

With the quadratic carrier, sheet reversal is $-I$. Let $s=-I$ and let
$q$ be the literal outer permutation action. They commute. On a selected
chordal generator and its companion,

\[
s:(L,h,c)\mapsto(L,-h,-c),
\]

while

\[
q:(L,h,c)\mapsto(qL,qh,-c).
\]

Consequently

\[
sq:(L,h,c)\mapsto(qL,-qh,c).
\]

Thus the four transformations form a Klein four action on the fully
unmarked pair of chordal sheets and signs, but the two binary markings are
not independent after a line is fixed: $8^{-1}(q-1)$ identifies sheet sign
with conference orientation. This is the exact content that the V.D table
must record.

If the chosen source category does not admit $-I$ as a morphism, then sheet
reversal is not an automorphism torsor there and the marking theorem must be
rephrased. One cannot simultaneously exclude scalar maps and use $-I$ as
the sharpness witness.

## 9. What is formal, what is classical, and what is new

### Formal after the five lemmas

- minimal-to-expanded carrier equivalence;
- functoriality of singular schemes and fixed-point quotients;
- switching uniqueness after the tetrahedral identity;
- $B^2=5I$ after balance;
- unit, counit, and triangle identities after strict rigidity;
- base change of the fixed neutral package;
- the marking-poset dependence relation after the actual action is known.

### Classical or source-owned

- the $A_5$ character table and the dimension-two invariant pencil;
- chordal cubic/rational-normal-quartic geometry;
- the subgroup identity $N_{A_5}(C_5)=D_5$;
- simplex acyclicity and conference switching;
- root and weight lattices;
- the abstract modular block containing the nonsplit module.

### Paper V's genuine contribution

- the exact placement of the Paper-II signed tensor in the chordal line;
- equality of its stabilizer-pair quotient with the original six-axis
  carrier;
- the normalized outer-difference comparison of the sheet and conference
  orientations;
- the strict marked round trip and exact information-loss action;
- the synthesis from golden root--weight normalization to the exotic
  $\mathbf F_4$-heart and Frobenius torsor.

The paper should sell this simultaneous marked placement and normalization,
not the classical ingredients separately.

## 10. What to delete or demote

1. Do not define arbitrary intrinsic $K$-forms unless their descent is
   classified.
2. Do not use the five expanded consequences as recognition axioms.
3. Do not claim character theory determines the normalized tensor placement.
4. Do not repeat separate unit/counit calculations for Papers I--III.
5. Do not keep Pfaffian or determinant identities as independent recognition
   conditions.
6. Do not give a recognition algorithm or a matrix census in the main proof.
7. Do not call the general conference order maximal outside $n=6$.
8. Do not turn Paper IV's $C_3$-torsor into a second carrier; cite it as the
   separate degree-three instance of the residual-field mechanism.

## Final recommendation

Adopt the five-lemma architecture and replace the bare minimal object
$(A,h)$ by a **metric chordal shadow** $(A,Q,h)$, or else restrict the
oriented classification to the literal augmentation model over
$\mathbf F_{11}$. Keep the existing all-extension result as functorial
base change of the fixed package, not a moduli-of-forms theorem.

The strongest accurate headline is:

> A normalized metric chordal shadow recovers its special $C_5$-orbit, the
> canonical six-axis normalizer quotient, and by outer difference a unique
> oriented conference companion. Its exact loss of marking is the same
> involution that, after root--weight normalization, becomes Frobenius on the
> exotic $\mathbf F_4$-heart.

That is both more structural and shorter than the current expanded plan. It
retains one honest normal-form calculation because that calculation is the
specific theorem; everything surrounding it becomes representation theory,
subgroup geometry, simplex cohomology, rigidity, or lattice arithmetic.
