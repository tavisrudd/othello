# C577 revised standard-questions cold read

**Revision reviewed:** `b1232cd505e3c052ccbcc3d1ea67a45bd7fac6d5`

**Primary artifact:** `papers/clebsch-factorization/clebsch_factorization.pdf`

**PDF SHA-256:** `dc9886a6fff0f64f1a26c3fbdfb03ecdbe91ae911693d5ccc63d043711cd47b3`

## Verdict

The paper is mathematically coherent and locally publishable after one important
wording correction.  The new homogeneous projective-cover bridge is correct:
the map
\[
 \Theta\left(\sum_{M\in X_+}a_M[M]\right)
 =
 \left(\sum_Ma_M\pi_8(x_M),\sum_Ma_M\right)
\]
is \(G^+\)-equivariant, kills the constant socle, restricts on the
augmentation radical to the nine-space isomorphism, and induces the identity
on the trivial head.  It therefore identifies
\[
 P(\mathbf1)/\operatorname{soc}P(\mathbf1)
 \simeq E_{c_8}\!\downarrow_{G^+}.
\]

The wording in the abstract, the final sentence of Corollary 6.3, and the
conclusion should nevertheless say **top-harmonic homogeneous extension**.
The full affine quotient has translation space
\(W_{H_3}=M_8\oplus M_0\), so its full homogenization has dimension \(11\);
\(P(\mathbf1)/\operatorname{soc}P(\mathbf1)\) and \(E_{c_8}\) have dimension
\(10\).  On restriction to \(G^+\), the full homogeneous module is instead
\[
 \widetilde E\!\downarrow_{G^+}
 \simeq
 P(\mathbf1)/\operatorname{soc}P(\mathbf1)\oplus\mathbf1,
\]
with the extra trivial line supplied by \(M_0\).  The theorem proved is right;
three summaries currently overstate its scope.

The immutable public artifact locator remains a release prerequisite, as the
paper itself states.

## The real headlines

The paper has three genuine headlines, in descending order.

1. **Factorization erased on the conic survives in the conic-ideal quotient.**
   The universal matching-product divisibility and four-endpoint Plücker
   switch create an affine quotient configuration.  For the three selected
   Coxeter orbits its difference ranks are \(3,6,10\), with the \(H_3\)
   image characterized intrinsically by
   \[
   W_{H_3}=\{f:\Delta_Qf\in\mathbf F_{11}Q\}.
   \]

2. **Quadratic data recover the unordered sheets and a cubic is the first
   signed orientation tensor.**  This yields the exact evaluation-algebra
   Hilbert function, self-association, the arithmetically Gorenstein property,
   and the signed cubic as Macaulay inverse system.

3. **The \(H_3\) affine noncanonicity is a modular extension, not a coordinate
   accident.**  The base-choice cocycle generates
   \(H^1(\operatorname{PGL}_2(11),M_8)\), has no equivariant origin, and after
   restriction its top-harmonic homogeneous extension is the canonical
   quotient \(P(\mathbf1)/\operatorname{soc}P(\mathbf1)\).

The six decorated profiles, modular depth plane, marker splitting, and
relative-cubic Tate plane are valuable refinements, but they are not equal
headline claims.

The revised title, *Factorization memory in conic quotients: the \(A_3\),
\(B_3\), and \(H_3\) secant configurations*, is accurate and better ordered
than a title led by the list of configurations.  The abstract leads with the
right geometric and cubic story and now includes the cohomological headline.
It is still overfull: the final profile and marker-algebra sentences make the
abstract read like an inventory.  A sharper abstract would keep the first
three headlines and leave decorated profiles and arithmetic splitting to the
introduction.

## Ranked next questions

The labels below distinguish consequences already forced by the paper,
nearby conjectural inferences, and broader speculative connections.

| Rank | Question or next result | Status | Expected value | Tractability |
|---|---|---|---|---|
| 1 | State the full restricted homogeneous module as \(P(\mathbf1)/\operatorname{soc}P(\mathbf1)\oplus\mathbf1\). | Proved implication | Very high | Immediate |
| 2 | Prove that the radial \(M_0\)-coordinate has exactly the two sheets as its two fibres, and reconcile this ambient linear classifier with intrinsic Hadamard recovery. | Proved implication | Very high | Immediate |
| 3 | Compute \(H^1(G^+,M_8)\) and prove the restriction of \([c_8]\) is its unique nonzero class. | Strong inference | High | Short |
| 4 | Recover the eleven-point sheet intrinsically as the orbit of a head lift in \(P(\mathbf1)/\operatorname{soc}P(\mathbf1)\). | Conjectural inference | High | Moderate |
| 5 | Extend the projective-cover description from one sheet to the full \(22\)-point \(G\)-permutation module. | Conjectural inference | Very high | Moderate |
| 6 | Replace the \(A_3/B_3\) row reductions by the same covariant/cohomological mechanism. | Open problem stated by paper | High | Moderate |
| 7 | Describe the full perfect-matching quotient map by Plücker, Specht-module, or binary-covariant theory. | Conjectural generalization | Very high | Hard |
| 8 | Classify the inverse-system cubics: stabilizers, singular loci, tensor ranks, and minimal resolutions. | Conjectural program | Medium-high | Moderate |
| 9 | Derive the six profiles from the \(K\backslash G/H\) Hecke algebra rather than representative counts. | Conjectural program | Medium | Moderate |
| 10 | Construct integral models and classify every exceptional characteristic. | Open problem stated by paper | Very high | Hard |

### 1. The full homogeneous extension

**Proved implication.**  Section 3 shows that the affine translation space is
\(M_8\oplus M_0\), that \(M_0=\chi\), and that the \(M_0\)-cocycle vanishes
on \(G^+\).  Corollary 6.3 identifies the \(M_8\)-by-trivial homogeneous
extension with \(P(\mathbf1)/\operatorname{soc}P(\mathbf1)\).  Therefore the
full restricted homogenization is the direct sum of that nonsplit extension
and the trivial radial module.  This should be stated now; it both fixes the
dimension ambiguity and strengthens the bridge.

### 2. Radial-level recovery of the sheets

**Proved implication.**  On the base sheet the \(M_0\)-component of every
quotient is zero.  The cocycle law makes the \(M_0\)-component constant on the
outer \(G^+\)-coset, and the radial witness (3.11) proves that constant is
nonzero.  Thus the two \(H_3\) sheets are the two fibres of the canonical
radial projection.

This does not invalidate Theorem 4.2.  It distinguishes two notions that the
paper should name:

- recovery using the ambient conic and Fischer operator;
- recovery intrinsic to the abstract affine point configuration through
  \(L^{\circ2}\).

The distinction is conceptually useful.  It explains why quadratic recovery
is still the intrinsic theorem even though \(H_3\) has a cheaper classifier
after the conic structure is retained.

### 3. The restricted cohomology group

**Strong inference to check.**  The Loewy structure
\(1\mid9\mid1\) of the projective cover and the nonsplit quotient strongly
suggest
\[
 \dim H^1(G^+,M_8)=1,
\]
with the restriction of \([c_8]\) as generator.  This would make Corollary
6.3 a cohomological classification over both \(G\) and \(G^+\), not merely an
isomorphism of one explicit extension.

### 4. Reconstruction from the projective cover alone

**Conjectural inference.**  The vector \((0,1)\in E_{c_8}\) is fixed by the
\(A_5\) stabilizer because \(c_8\) vanishes there, and its \(G^+\)-orbit has
eleven points.  Since \(M_8^{A_5}=0\), an \(A_5\)-fixed lift of the head should
have little or no residual freedom.  One should test whether the
\(G^+\)-module \(P(\mathbf1)/\operatorname{soc}P(\mathbf1)\), together with
its head, reconstructs the matching sheet uniquely up to module
automorphism.  A positive result would reverse the paper's construction:
the modular extension would recover the secant-factorization orbit.

### 5. The full \(22\)-point permutation module

**Conjectural inference.**  Restricting the full matching permutation module
to \(G^+\) gives the two sheet modules.  The outer coset interchanges them,
while \(E_{c_8}\) already carries a \(G\)-action.  The natural problem is to
identify the \(G\)-module structure of \(k[X]\), its projective summands, and a
canonical quotient onto the full homogeneous affine module.  This would
unify:

- the \(11+11\) sheet split;
- the determinant character;
- the nonsplit top-harmonic extension;
- the extra radial line.

### 6. A uniform rank-three proof

**Open problem already acknowledged.**  The \(H_3\) proof now has a clear
mechanism: affine cocycle, Sylow-normalizer weight, stabilizer fixed spaces,
irreducible top summand, and one radial scalar.  The highest-value bounded
generalization is to run the same representation-theoretic analysis for
\(A_3/\mathbf F_5\) and \(B_3/\mathbf F_7\), replacing the last two orbit row
reductions.

### 7. The full matching quotient

**Speculative but structurally motivated.**  The four-endpoint switch is a
Plücker relation, and arbitrary perfect matchings are connected by such
switches.  This asks for a representation-theoretic description of the map
from the full perfect-matching permutation module to
\(\operatorname{Sym}^{m-2}(\operatorname{Sym}^2V)\), including its kernel,
image, and filtration.  Specht modules, the matching complex, binary
covariants, or a Temperley--Lieb/Plücker quotient are natural candidates.
Such a theorem could explain both the Coxeter ranks and their exceptional
modular losses.

## Underdeveloped conceptual connections

### Projective covers and affine geometry

This is now the strongest connection in the paper, and it remains
under-promoted.  The affine failure of an equivariant origin is exactly the
upper nonsplit layer of a projective cover.  In concrete terms, the
factorization quotient realizes a standard modular representation-theoretic
object geometrically.  Corollary 6.3 should be mentioned immediately after
Theorem 1.1, not only in the abstract and conclusion.

### Plücker relations, matching modules, and classical covariants

Proposition 2.1 is more general than the rest of the paper and should be
presented as a universal matching-module construction.  The switch identity
is the visible trace of the Grassmann--Plücker algebra.  The paper currently
uses it locally but does not exploit the resulting module or syzygy
structure.

### Self-dual codes, Schur squares, and design trades

The identity \(ADA^{\mathsf T}=0\), the equality of dimensions, and the
codimension-one Schur square show that the evaluation code is self-dual for
the signed diagonal pairing and has a unique full-support strength-two
trade.  The paper cites the modern Gorenstein-defect criterion but could say
more about duadic or quadratic-residue phenomena, Delsarte trades, harmonic
weight enumerators, and automorphism groups.

### Apolar cubics

The signed cubic is simultaneously:

- the first nonzero orientation moment;
- a relative invariant;
- the Macaulay inverse system;
- a cubic surviving the profile compression.

The paper does not classify its orbit as a cubic form.  Its singular locus,
Hessian, Waring/tensor rank, stabilizer, and resolution should be computed
and compared between \(B_3\) and \(H_3\).

### Double-coset/Hecke structure

The profile theorem is already organized by \(K\backslash G/H\), marks, and
permutation modules.  A Hecke-algebra or spherical-function description
could explain the six labels, the rank-two image, and the \(1,4,6\) weights
without treating the displayed profile rows as isolated data.

### Actual Tate cohomology

Appendix C contains invariants, coinvariants, norm, transfer, and an integral
operator satisfying \(B^2=11B\), but it does not formulate the corresponding
Tate groups or Bockstein/extension class.  “Tate plane” will feel fully
earned once the two-plane obstruction is placed in an exact cohomological
sequence.

## What to cut, compress, or move

1. **Compress the abstract.**  Retain quotient memory, quadratic/cubic sheet
   recovery, Gorenstein duality, and the \(H_3\) cohomology/projective-cover
   result.  Move the six profiles and marker-algebra split/fused inventory to
   the introduction.

2. **Split Theorem 1.1 by conceptual scale.**  Clauses (i)--(iv) form the
   intrinsic factorization-memory theorem.  Clause (v) is decorated,
   \(H_3\)-specific, and finite-incidence in character.  It would read better
   as a separately advertised theorem.

3. **Compress the prescribed-hole detour at the start of Section 3.**  It is
   relevant provenance but delays the selected-orbit definition and does no
   work later in this paper.

4. **Move or shorten the quantum comparison after Corollary 5.2.**  It
   interrupts the profile argument and depends entirely on companion work.

5. **Consider moving Section 7 to an appendix or companion note.**  The
   split/fused marker datum is partly defined by the specialization map
   itself.  It is exact and useful, but less intrinsic than the quotient,
   cubic, and projective-cover results.

6. **Keep Appendix C only with a stronger bridge paragraph.**  Its negative
   result is mathematically real, but the reader needs to know earlier why a
   map from the relative cubic plane to the depth plane was expected.

7. **Move most fingerprint mechanics to the artifact README.**  The paper
   should retain the proof-mode table, exact public locator, toolchain, and
   replay command.  The normalization details and allowlist explanation can
   live with the verification package.

## Small fixes and defects

1. **Full versus top-harmonic homogeneous extension.**  This is the only
   mathematical wording defect.  Fix it in the abstract, the last sentence of
   Corollary 6.3, and the conclusion.  Optionally state the full direct-sum
   formula.

2. **Notation mismatch.**  Equation (3.11b) names the module \(E_c\), while
   Corollary 6.3 calls \(E_{c_8}\) “the \(G\)-module defined in (3.11b).”
   Use one notation.

3. **Loewy-order ambiguity.**  The last proof sentence says
   \(P(\mathbf1)/\operatorname{soc}P(\mathbf1)\) has layers \(9\mid1\),
   whereas Proposition 6.1 displays \(1\mid9\mid1\) without declaring whether
   layers are listed head-to-socle or socle-to-head.  Replace the appeal to
   notation by the explicit nonsplit exact sequence.

4. **Promote Corollary 6.3 in the introduction.**  It appears in the abstract
   and conclusion but not in the main theorem or the paragraph immediately
   following it.

5. **Clarify “linear quotient does not recover the sheets.”**  This is true
   for the signed relation/intrinsic abstract configuration in the sense used
   by Section 4, but the retained Fischer structure gives the \(H_3\) radial
   two-level classifier.  Name the distinction.

6. **Public deposit.**  Appendix B correctly states that an immutable locator
   is still required.

## Bottom line

The new projective-cover corollary is not merely a repair; it reveals the
paper's most structural \(H_3\) statement.  The quotient geometry realizes
the unique nonsplit modular extension geometrically, and its radical is the
top harmonic nine-space.  The immediate editorial task is to distinguish
that top-harmonic extension from the full \(10\)-dimensional affine quotient.
The immediate mathematical task is to promote the resulting direct-sum
description and then determine whether the full \(22\)-point
\(\operatorname{PGL}_2(11)\)-permutation module canonically generates the
entire homogeneous affine object.
