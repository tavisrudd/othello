# Paper V packet G: independent geometry cold referee

## Verdict

**MAJOR.** The displayed Paper-II shadow, its Hankel singular scheme, and the
stabilizer quotient are convincing without the computational artifact.  The
classification theorem nevertheless ranges over all normalized metric chordal
shadows over every neutral extension, while the text never proves that the
characteristic-eleven invariant pencil has exactly the two geometrically stable
chordal lines used in the proof.  The cited classification establishes the two
members in characteristic zero.  A second, independent definitional ambiguity
in the groupoid morphisms prevents the claimed residual quotient from being
checked as stated.

## Frozen artifact and read depth

- Frozen PDF: `papers/clebsch-round-trip/golden_companion_reconstruction.pdf`,
  all 18 pages read.  SHA-256 verified as
  `c8427d8178e9a2d8534950cff5cd40422ebcb0ddb578e8181bf65137f781d3ba`.
- Primary manuscript focus: Sections 1--3, with the causal chain followed
  through Sections 4--6 for the selected-line bridge and source return.
- Artifact-deletion test: no checker, JSON certificate, orbit output, or
  computational replay was used as a premise.  Proposition 2.1 was treated as
  the printed finite coefficient calculation, and every later implication was
  tested from the prose proof alone.
- Pinardin--Zhang, arXiv:2508.11496v1: pp. 1--3 and pp. 23--27, including the
  opening of Section 6.2, Proposition 6.6, the full displayed invariant pencil
  (6.3), the two chordal members (6.4), and the proof through the displayed part
  of Lemma 6.9.  The paper states that it works over `C`; it does not supply a
  characteristic-eleven or arbitrary-base-change chordal-locus theorem.
- Cheltsov--Marquand--Tschinkel--Zhang, arXiv:2505.03986: pp. 12--15, including
  all of Section 5.  This supports the uniqueness of the unmarked chordal cubic,
  its secant description, and `Aut(X)=PGL_2` in that source's setting.
- Howard--Millson--Snowden--Vakil, *A description of the outer automorphism of
  S_6, and the invariants of six points in projective space*: pp. 1--8, all of
  Sections 1.1--1.6 and 2.1--2.4.  This supports the six-point outer dictionaries
  and their projective invariant-theory role, but not the missing finite-field
  chordal-locus classification.
- No other public source was consulted.

## Controlling findings

### 1. The two-line chordal classification is not proved in the field of the theorem

**Type:** mathematical; controlling MAJOR.

**Earliest failing sentence or implication.** The first unsupported assertion is
on PDF p. 1, Section 1: "Two other points of the pencil are chordal cubics, each
singular along a rational normal quartic."  The attribution on p. 2 points to
Pinardin--Zhang Section 6.2, but that source works over `C`.  In the proof, the
first load-bearing use is the passage from the single Paper-II placement in
Proposition 2.1 (pp. 5--6) to "the two chordal lines" in Proposition 4.1 and
Corollary 4.2 (pp. 8--9).  Definition 5.1 then allows an arbitrary normalized
metric chordal shadow over any `K/F_11`, and Proposition 5.2 silently treats it
as one of those two base-changed lines.

**Smallest counterexample or ambiguity.** It is enough that the special fibre of
the chordal condition in `P(Pi)` acquire a third point, a nonreduced point, or an
extension-defined component not descended from either displayed line.  I am not
asserting that such a member exists; the manuscript and its cited source do not
exclude it.  For such an object, the point-count proof of Proposition 3.2 over
`F_11` cannot be invoked by base change, and the selected-line conference functor
need not be essentially surjective onto `C_ch(K)`.

**Does the theorem survive a local repair?** Yes, if true.  Insert a
scheme-theoretic lemma over `F_11` proving that

`{[h] in P(Pi) : Sat(J_h) is a rational-normal-quartic ideal}`

is exactly two reduced `F_11`-points and remains exactly their base change over
every extension.  A proof may classify the tame `A_5` actions on the singular
quartic or compute the universal pencil Jacobian, but the good-reduction and
geometric-exhaustiveness step must appear in the mathematical proof rather than
only in the Section 11 replay.

**Downstream claims requiring re-read.** Proposition 3.2 as applied to arbitrary
shadows; Proposition 4.1 and Corollary 4.2's phrase "either chordal line";
Theorem 1.2; Definition 5.1(a); Proposition 5.2 essential surjectivity; the
`uq`-fibre calculation; Corollary 6.2; and the universal part of the Section 6
source-return statement.  The one displayed Paper-II object does not depend on
exhaustiveness and survives.

**Novelty boundary.** The attribution remains accurate after such a lemma: the
complex pencil and its two chordal members are credited, while the marked
finite-field compatibility and information-loss theorem remain the paper's
claim.  Without the lemma, the phrases "classification," "equivalence," and
"complete information loss" exceed the proved scope.

### 2. The intrinsic groupoids do not yet have intrinsic morphism sets

**Type:** mathematical definition; controlling MAJOR for the categorical and
deck-quotient formulation.

**Earliest failing sentence or implication.** Definition 1.1 on PDF p. 3 says
that morphisms are `G`-equivariant `Q_0`-isometries together with "exactly the
coordinated relabelings explicitly allowed in the source package."  Definition
5.1 on p. 10 again refers to coordinated relabelings "retained by the object."
Neither phrase defines a group of morphisms.  A literal outer permutation
normalizes `G` but is not `G`-equivariant in the ordinary commuting sense, while
Section 5.1 says that `q` is a morphism when coordinated outer relabeling is
allowed.

**Smallest counterexample or ambiguity.** Under strict `G`-equivariance, the
outer operation `q` is excluded and `uq` is not a deck transformation in the
stated groupoid.  Under automorphism-twisted equivariance, extra morphisms are
allowed and the Hom sets used in Proposition 5.2 must be recomputed.  These two
readings give different categorical statements even though they have the same
object-level formulas.

**Does the theorem survive a local repair?** Probably.  Define morphisms
explicitly, for example as a stated normalizer/automorphism-twisted action with
precise compatibility conditions on `G`, `Q_0`, `[B]`, `L`, `h`, and `c`; also
say exactly how switching enters.  Then prove that `u`, `q`, and `uq` act in the
claimed vertices and nowhere else.

**Downstream claims requiring re-read.** Theorem 1.2(iv), Proposition 5.2 full
faithfulness, the statement that the unselected functor has exactly two-object
fibres, all four rows of the dependency table on p. 11, and the naturality claim
in Corollary 6.1.

**Novelty boundary.** This does not threaten the object-level outer-difference
formula.  It does control the stronger claim that the residual ambiguity is an
exact quotient of groupoids rather than merely a two-to-one correspondence on
marked representatives.

### 3. The printed Jacobian argument proves scheme equality for the Hankel model

**Type:** mathematical; PASS control.

**Earliest tested implication.** Lemma 3.1, PDF pp. 6--7.

**Smallest counterexample or ambiguity.** None found.  The proof does more than
compare supports: four Hankel minors occur among the partials; the remaining two
are recovered after localization on `D(z_2)`, `D(z_0)`, and `D(z_4)`; and the
complement has empty projective Jacobian scheme.  Thus the saturated Jacobian
ideal equals the rational-normal-quartic ideal.  The identities are polynomial
identities in characteristic eleven, so this equality survives scalar extension.

**Does the theorem survive without repair?** Yes for the displayed Hankel member
and every established base change of it.  Finding 1 is the missing reason that
every object of the declared chordal groupoid is such a base change.

**Downstream claims requiring re-read.** None beyond the dependence already
listed under Finding 1.

**Novelty boundary.** Accurate: the chordal model is classical, while the paper
prints the exact scheme-theoretic calculation it uses.

### 4. The stabilizer quotient recovers the marked axes, not only an abstract six-set

**Type:** mathematical and source-return; PASS control.

**Earliest tested implication.** Proposition 3.2, PDF p. 7, through the source
return in Corollary 6.1, pp. 11--12.

**Smallest counterexample or ambiguity.** None found after restricting to an
established base-changed chordal member.  In `PSL_2(11)` a rational point
stabilizer has order dividing five; each split Sylow `C_5` has two distinct
eigenlines; distinct Sylow subgroups cannot share one; and the resulting twelve
points exhaust `P^1(F_11)`.  Mapping a point to its unique Sylow stabilizer gives
the canonical double cover `A_5/C_5 -> A_5/D_10`, with the two points over an
axis left unordered.  For the Paper-II matching six-set, self-normality of the
order-ten subgroup makes the fixed matching pair unique, so the return is to the
original marked axes.  The `D_10` convention is consistently order ten.

**Does the theorem survive without repair?** This portion does.  The fixed
eigenlines are split and reduced because `mu_5` is already in `F_11`, and the
construction commutes with neutral base change.  The unmarked chordal cubic's
larger `PGL_2` automorphism group is respected because the fixed `A_5`-action and
metric carrier are part of the object.  `Q_0` is also present wherever the
`lambda^2=lambda^3=1` scalar-rigidity argument is used.

**Downstream claims requiring re-read.** Only the universal quantifier supplied
by Finding 1 and the morphism-level naturality supplied by Finding 2.

**Novelty boundary.** Accurate as written: the return concerns marked packages
and selected-line decorations, not an unmarked chordal cubic or source-local
charts that were not retained.

## Referee disposition

The paper should be re-read after a field-valid, geometrically exhaustive
two-chordal-line lemma and an explicit definition of the groupoid morphisms are
inserted.  Those repairs appear compatible with the intended theorem and do not
require changing the displayed Paper-II placement, the scheme-theoretic
singular-locus calculation, or the canonical `A_5/C_5 -> A_5/D_10` source
return.
