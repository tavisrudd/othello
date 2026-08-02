# C792 — Paper III exchange-rigidity integration

**Lane:** `clebsch`

**Status:** manuscript, trust, and formal-source integration complete; the
aggregate Lean gate and genuinely independent cold read remain open

## Result

The forward Paper III now makes the order-six Golden carrier exceptional for
a structural reason.  For every symmetric conference matrix of order (2d),
the balanced exchange operator has spectrum

\[
 \operatorname{Spec}(H_Y)
 =\operatorname{Spec}(RR^{\mathsf T}/(2d-1))
 =\{1-\alpha_i^2/(2d-1):1\le i\le d\}.
\]

Its spectrum is independent of the balanced half exactly for (d\le3).
Thus order six is the unique nontrivial realized case, with spectrum
({1/5,4/5,4/5}).  The first exchange moment is universal in every order;
the second is an affine count of aligned four-sets.  Greaves--Suda's classical
determinant-((-3)) design and Johnson inclusion calculus give the exact mean
and variance of that count, including the structural (36|90) order-ten
split.

The theorem sits after the general conference carrier is defined and before
the marked cubic shadows.  A transition immediately after it states the
essential boundary: exchange spectrum sees (A^2), whereas determinant-line
orientation and the later cubic shadows retain sign.

## Architecture decision

The baseline A PDF was frozen under the descriptive alias
`frozen-current-forward-paper.pdf`; B-plus was rendered as
`exchange-rigidity-with-design-consequences.pdf`.  The files are local review
aliases outside the release surface.  A has 20 pages and B-plus has 22.

B-plus wins the force-rank.  It adds one theorem and one credited consequence
paragraph without displacing the arithmetic source, operator cubics, or
harmonic return.  The two-page cost buys the missing explanation for why the
six-axis operator is exceptional and turns the higher-order design from an
application branch into the exact statistical residue of failed rigidity.
B and B-lite were not rendered because B-plus passed the warning-free visual
gate and did not lose pace.

This comparison was a role-separated authorial review, not a genuinely blind
independent read.  The task card's independent force-rank and final fresh
referee read remain acceptance gates.

## Proof and red-team corrections

The proof has four causal steps:

1. the commutator identifies exchange with the cross-block Gram spectrum;
2. a closed-four-walk expansion makes the second moment an aligned-four-set
   count;
3. characteristic-zero inclusion rank forces a constant local indicator if
   that moment is cut-independent; and
4. the two possible local values contradict conference orthogonality or the
   equality (R(3,3)=6).

The mathematical red team checked the commutator convention, complementary
cut symmetry, the inclusion-rank range, both Ramsey branches, the (d=1,2,3)
endpoints, the design density, the Johnson variance, and the order-ten moment
conversion.  It caught a sign error in the displayed commutator block; the
correct matrix for ([D_Y,Q]) is

\[
 \frac2{\sqrt q}\begin{pmatrix}0&R\\-R^{\mathsf T}&0\end{pmatrix}.
\]

It also strengthened the (d=3) endpoint by displaying
(det(tI-A)=t^3-3t-2\tau), which makes the squared spectrum
({4,1,1}) immediate.

The editorial pass retained the classification as a theorem, moved design
statistics to an unnumbered consequence paragraph, and added one explicit
sentence separating squared spectrum from determinant orientation.  No
quantum protocol or Golden application inventory entered the manuscript.
C794's reverse two-graph reconstruction theorem remains outside this task.

## Literature boundary

The manuscript credits Haemers--Parsaei Majd for complementary conference
blocks, Magsino--Mixon--Parshall for conference-frame closed-walk moments,
Jolliffe for inclusion rank, Attas--Boussaïri--Souktani and
Boussaïri--Souktani--Zouagui for spectral monomorphy, Greaves--Suda for the
determinant-((-3)) (3)-design, Gillespie for regular-two-graph four-set
parameters, and Ghareghani--Ghorbani--Mohammad-Noori for Johnson inclusion
calculus.  The novelty sentence remains qualified: the bounded C788 audit did
not locate the balanced singular-spectral classification, and the paper makes
no `first` claim.

## Formal and trust surface

`RelativeConicArcs.ConferenceCutSpectrum.signedTriangle_sq` proves over every
commutative ring that a three-vertex zero-diagonal symmetric sign matrix
satisfies

\[
 A^2=2I+(abc)A.
\]

The Golden-return gate imports and audits this declaration.  Lean covers the
algebraic core of the order-six converse; the unrestricted cross-block,
closed-walk, inclusion-rank, and Ramsey argument remains human proof.  The
paper now has seven frozen theorem-like statements and eight trust rows, with
the new row `OPER-3`.  The formal source map, axiom report, artifact guide,
verification guide, README, abstract, introduction, conclusion, references,
and claim/novelty ledger agree with that boundary.

The new module passes guarded single-file elaboration, and its exact axiom
output is `[propext, Classical.choice, Quot.sound]`.  The pinned formal
source-only replay passes.  The aggregate Golden-return gate is waiting for a
foreign Lean build owner to release the shared build window; no foreign
process or artifact was touched.

## Manuscript validation

A clean archive overlay preserves the pre-existing modified monorepo PDF.
The authoritative overlay aggregate ends `ALL CHECKS PASS`, including all
three exact evidence bundles, statement/trust identity, release allowlist,
manuscript build, and warning-free PDF.  Pages 12--15 were inspected at
publication scale; the new theorem and proof are legible, and the original
operator-shadows theorem remains visible immediately afterward.

Standalone synchronization waits for the aggregate formal gate and the
authoritative forward commit.

## Extra-juice and Tao-style closeout

The cheap upgrade was the explicit squared-spectrum versus determinant-sign
transition: without it, the new theorem could look like a competing operator
invariant rather than the reason the subsequent cubic needs orientation.  The
Tao-style pass also replaced an implicit (d=3) eigenvalue assertion by the
factorized characteristic polynomial and checked that only the second moment,
not full spectral classification, is needed for the higher-order exclusion.

## Mystery ledger

- **Settled:** order six is exceptional because inclusion descent turns
  cut-independent second moment into a forbidden constant four-vertex
  holonomy.
- **Settled:** the higher-order uniform residue is statistical, not spectral;
  the classical aligned design fixes mean and variance but not each cut.
- **Settled:** the order-ten (36|90) split follows from the design moments
  without enumerating cuts.
- **Open, C794:** whether the labelled aligned design reconstructs every
  two-graph on at least seven vertices up to complement.  It is not needed for
  C792 and was not imported.
- **Open, optional successor:** classify complete higher-order exchange spectra
  within arithmetic cut orbits.  No successor is allocated.

No unexplained feature remains in the Paper-III theorem itself.  The remaining
C792 gates are review and shared-build validation, not mathematical gaps.

Vibe check: the theorem earns its two pages.  Paper III now explains the
six-axis operator's exceptional status without diluting the Golden descent or
claiming the classical design machinery.
