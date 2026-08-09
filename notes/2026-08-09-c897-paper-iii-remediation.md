# C897 Paper III human-proof remediation

Date: 2026-08-09

## Outcome

The authoritative Paper III tree now contains a paper-local proof that the
rational degree-two incidence field is branched exactly along the reduced
multiplicity-one sextic `J_0=0`.  This repairs the load-bearing first-batch
finding without narrowing Theorem 1.1.  The same argument legitimizes the
finite-etale comparison at `xyz`, so Hitchin's two conjugate configurations
form the complete reduced fibre with residue algebra `Q(sqrt(5))`.

The exact sextic scale is now internal: `J_0` is the rational equation of
Hitchin's irreducible sextic normalized by
`iota_t^* J_0 = 16 sigma_3^2`.  The manuscript no longer claims that
Hitchin's opening analytic moment scale literally matches the rescaled
operator used in his appendix.

## Git-history forensics

The missing proof was not compressed during later manuscript edits.

- `52693f5a` first promoted the arithmetic theorem and passed directly from
  Hitchin's real sextic boundary to the rational branch divisor.
- `96e1918a` added the rational Grassmannian model and a finite-neighbourhood
  argument at `xyz`, but still took the branch assertion from the citation.
- `8037abfb` added the descended pinching model and the canonical chart
  sections, while expressly saying that this model did not replace the
  incidence comparison.
- `2859b64c`, `1975ed42`, and the later structural edits strengthened the
  square-class lemma and exposition but never inserted a differential,
  discriminant, or ramification-cycle calculation.

The related C652, C653, C668, C670, C744, and C862 notes show the same proof
spine.  C670 even isolated scheme-theoretic normalization as a follow-up;
C744 later recorded that no paper-local scheme proof carried the branch
claim.  Thus the first sealed MAJOR found an original omission, not lost
prose recoverable from history.

## Reduced branch calculation

Let `U` be the universal rank-three bundle on `Gr(3,7)`.  The
Mukai--Umemura threefold is the smooth zero locus of
`wedge^2 U^* tensor W`, a rank-nine bundle with determinant `O(6)`.  Since
`K_Gr = O(-7)`, adjunction gives `K_X=O_X(-1)`.

For `F = ker(H tensor O_X -> U^*)`, one has `rank(F)=4` and
`det(F)=O_X(-1)`.  The incidence variety is `I=P_X(F)`, and the tautological
class is the pullback of the hyperplane class on `P(H)`.  The
projective-bundle formula gives `K_I = O_I(-4)`.

Consequently the determinant of the differential of the generically
degree-two map `pi:I->P(H)` is a section of `O_I(3)`.  If `R` is its
ramification divisor, projection gives `pi_* R = 6h`.

At a general real point of Hitchin's irreducible sextic boundary, his
classification gives one incidence configuration.  Properness makes the map
finite locally there; smooth source, regular target, and equal dimensions
give finite flatness by miracle flatness.  A degree-two flat fibre with one
geometric support point is ramified.  Those real smooth points are Zariski
dense in the sextic, so the sextic is a branch component.  Its degree already
equals the complete branch-cycle degree six.  Tame quadratic ramification has
index two, residue degree one, and different exponent one, hence the branch
is reduced and has multiplicity one, with no additional divisorial component.

At `xyz`, the normalized sextic is nonzero.  Hitchin's exact classification
there gives two conjugate points and no others.  The preceding branch result
makes the finite local map etale, so the fibre is automatically complete and
reduced; the explicit golden coordinates identify its residue algebra as
`Q[t]/(t^2-t-1)`.

## Local repairs

- Corrected the six erroneous signs in row `r=2` of Table (5.1); its word is
  now `+-+-+---++--+++-+-+-`.
- Expanded the complementary-minor/triangle bridge using the two exact
  triangle orbits, their displayed complementary blocks, determinants, and
  Hodge signs.
- Fixed the cross-golden determinant-line convention by normalizing the sign
  at `T_0` and transporting the orientations through the coherent outer
  marking.
- Qualified Holtz--Sturmfels by its strict nondegeneracy hypothesis and used
  the unconditional order-three-minor argument for Seidel matrices.
- Translated `aligned` into the coherent/incoherent terminology and replaced
  the adaptive-decoder handwave by a seven-point distinguishing-query
  argument.  This also corrected “five known points” to six.
- Reconciled the manuscript, literature ledger, artifact description, README,
  trust role, and verification prose with the paper-local branch proof and
  exact internal `J_0` normalization.

## Rejecting evidence and paper-only validation

The arithmetic certificate now checks the canonical and branch-cycle degree
bookkeeping `(-7,6,-1,-4,3,6)`.  The orientation-source primary checker parses
all six coefficient words directly from the manuscript, recomputes them from
the displayed conference matrix and outer permutations, and rejects any
disagreement.  Its independent replay pins the corrected `r=2` word and the
column-balance identities.

The paper-local aggregate passes every non-Lean check: release allowlist,
public vocabulary, statement identity, trust manifest, companion pin,
primary/independent/checksum evidence bundles, spacing lint, and a
warning-free deterministic 32-page manuscript build.  Per author direction,
any further Lean work is outside C897's present paper-only pass and will be
queued separately.

The first standalone replay caught one export-local packaging defect: the
spacing lint still pointed to a monorepo sibling script.  The paper now carries
that rejecting lint under `verification/`, and both the Makefile and release
aggregate invoke the paper-local copy.

## Extra-juice and Tao-style closeout

The cheap structural strengthening was to compute the whole ramification
cycle, rather than merely show that the sextic lies in the set-theoretic
branch locus.  The canonical bundle cancellation
`K_X tensor det(F)^{-1}=O_X` makes the calculation one line once the correct
incidence bundle is exposed, and the pushforward degree six simultaneously
rules out hidden complex branch components and proves multiplicity one.

The proof also separates three objects that had been conflated: Hitchin's
real sign boundary, the reduced branch divisor of the rational normal cover,
and an exact rational scale for its equation.  The cited source owns the
first; the paper now proves the second and defines the third.

## Mystery ledger

- **Settled:** whether the MAJOR came from a compressed earlier proof.  It did
  not; the citation jump entered with the first promoted theorem.
- **Settled:** reduced order-one branch exactly on `J_0=0`, by the canonical
  ramification cycle and the dense real boundary.
- **Settled:** complete reduced fibre at `xyz`, by local finite flatness and
  etaleness off the repaired branch divisor.
- **Settled:** exact rational `J_0` scale, by the internally normalized chart
  pullback rather than an asserted equality of Hitchin's two printed scales.
- **Settled:** Table (5.1), complementary-minor bridge, determinant-line sign,
  Holtz--Sturmfels scope, aligned terminology, and adaptive-query exposition.
- **Settled:** fresh sealed Hitchin, Greaves, Snowden, and Si Kaddour regrades
  all returned `PASS` on standalone commit
  `9fe1f912d0fb48d61a1b2587387d1a2516c3afb8`, with no unresolved
  `MAJOR` or `MINOR`.

Vibe check: the repair is focused but genuinely load-bearing.  Two additional
pages now carry the missing geometry explicitly, while the operator half is
more auditable and the public trust prose no longer asks Hitchin's citation to
prove a rational finite-cover theorem it does not state.
