# C949 session archive — sharp asymptotics for complete higher arcs

This append-only companion records chronological C949 sessions and routes to
their detailed snapshots.  The live task state is always
`notes/2026-08-24-c949-sharp-higher-arc-asymptotics.md`.

## 2026-08-24 to 2026-08-25 — inverse reduction and branch structure

The exact `5/3` endpoint was excluded for sufficiently large ternary fields.
Sublinear repair was reduced to nine SR11 signatures: seven concurrent rows
and two triangular signatures.  The concurrent rows compressed to three
ghost types; the balanced triangular branch acquired its Redei, Witt,
reciprocal-norm, packing, and arrangement formulations.  The `(5,-1)` branch
was separated as a linear-trade problem.

Detailed authority through all subsequent refinements:
`notes/2026-08-26-c949-structural-proof-snapshot.md`.

## 2026-08-25 — C962 finite application interface

The q=27 balanced branch was expressed as 714 fixed-mapping tasks.  Each high
cell is an affine equation in the 18 coefficients of `(A,C)`.  Rollback rank,
two-fiber reconstruction, terminal-nullity, and Möbius-defect handling were
implemented in the owning C962 work.  This supplied an exact finite route but
not a field-uniform C949 theorem.

Focused sources:

- `notes/2026-08-25-c962-application-opportunities-memo.md`
- `notes/2026-08-25-c962-recovery-algorithms-and-bounds.md`

## 2026-08-26 — carrier red team and global method boundaries

Independent audits closed several attractive but invalid shortcuts:

- all finite local torus jets are Koszul-formal;
- cubing erases conductor compatibility at quadruple nodes;
- Saito/freeness is universal for the covering arrangement;
- scalar pencil cocycles contain no offset information;
- a degree-`2q/3` root carrier is an overdetermined gluing condition, not an
  automatic consequence of the cubed restrictions.

The resulting valid target became a global offset/Hasse-Redei/conductor
identity.  See the snapshot labels `(SR24a-arrangement-*)`,
`(SR24a-torus-*)`, and `(SR24a-carrier-lemma)`.

## 2026-08-26 — Mason separation upgraded to quadratic scale

The deficient-block incidence inequality and exact second moment for
converted lines yielded

```text
liminf e/q^2 >= c_*=0.0171413259... > 1/60.
```

This rules out every subquadratic Mason switch but remains relative to a
chosen Mason root.  The absent bridge is the mixed correlation between an
arbitrary near-sharp blocker and some Mason root.

Commit: `f674edf98` (`prove quadratic Mason separation for C949`).

## 2026-08-26 — Redei rank-one certificate

Tangent-pencil averaging first produced a clean/dirty dichotomy and a
field-uniform rank-one certificate with one possible quadratic top term and a
cubic defect.

Commit: `2dd65b5f4` (`derive field-uniform Redei defect for C949`).

## 2026-08-26 — norm saturation and exact bounded cubic

A weighted bisecant/trisecant second moment was saturated exactly by the
three zero-triangle vertices.  This eliminated the dirty branch.  Incidence
inversion then identified the weighted low-line family with the sum of the
three full pencils.  Global monic division gave

```text
Q=B_0 C_0(X^3,M)+(M^q-M)E,
deg_X E<3, deg E<=3.
```

The entire balanced field-uniform defect is therefore nine coefficients.

Commit: `31d65d166` (`compress C949 Redei defect to bounded cubic`).

## 2026-08-26 — reciprocal audit and exact no-go boundary

The reciprocal transform has standard `(N^q-N)` remainder form exactly when
the three homogeneous-cubic coefficients of `E` vanish.  It is a transform
of the same cubic, not a second independent nine-dimensional object; the
apparent numerical match with C962's 18 carrier coordinates was retracted.

Adding `(M^q-M)E'` preserves every finite directional fiber.  Thus the live
target is a pre-specialization identity computing transverse derivatives
along the three moving pencil roots.

Commit: `ae2ca690b` (`isolate reciprocal obstruction in C949 cubic`).

## 2026-08-26 — exact transverse quotient core

Restricting the globally split point product to each forced low-pencil root
gave an exact `G^2` product with the two connector slopes as its extra roots.
Applying the same restriction to both canonical Redei quotients, then
dividing the companion quotient by the moving low cubic, produced a
degree-six 18-coefficient remainder.  Its three connector fibers are fixed by
three evaluations of `E`; removing their canonical interpolation leaves a
second nine-coefficient cubic `U`:

```text
Q=B_0C_0+GE,
H=B_0D+P_good I_E+GU.
```

This is the first genuine bounded `9+9` quotient state.  It remains a
compression, not a contradiction or an identification with C962's carrier.
Focused proof: `notes/2026-08-26-c949-redei-transverse-core.md`.

The subsequent TT/red-team pass compared two tangent charts under the
coordinate transposition `[A:B:C] -> [C:B:A]`.  Accounting for the two
omitted tangent endpoints gives

```text
X R_D(M,X)=lambda M R_(tau D)(X,M).
```

The two canonical quotient pairs differ by one bounded quartic Koszul term
`L`.  This is exact, but not yet a relation on `(E,U)`: the high quotients
absorb the bounded terms, and `tau` is a coordinate change rather than a
symmetry of `D`.  The next genuine gate is to constrain `L` using the
reciprocal norm or a Witt identity.

The balanced shear then supplied the missing full product map.  In
simultaneous Frobenius coordinates, the two carrier points above `u` have
line-factor product

```text
Z_u^2-A(u^3)Z_u+C(u^3),  Z_u=Zeta+(m+w)u.
```

Multiplication over `u!=0`, followed by the three affine-axis and three
infinity factors, is exactly the homogeneous Chow product of `D^Frob`.
Projective substitution and deletion of a tangent factor therefore compute
the tangent Redei pair and its bounded cores from `(A,C)`.  This works without
a transversal completion.  The live gap is now coefficient extraction: the
q-scale product has not yet been compressed enough for the fourth-Witt gate
to control `E,U`, or `L`.

## 2026-08-26 — task-card reorganization

The former 6,800-line C949 card was frozen as
`notes/2026-08-26-c949-structural-proof-snapshot.md`.  The original path is
now the short live router.  Future detailed proof batches should land in
focused dated snapshots and be linked here; this archive records sessions,
not full derivations.

## 2026-08-26 — leading Chow extraction and blocker variance

Two audited frontiers landed in focused snapshots.

First, `(TR17)--(TR19)` in
`notes/2026-08-26-c949-redei-transverse-core.md` extract the homogeneous
quartic `L_4` and the three reciprocal-obstruction coefficients of `E`
directly from the leading tangent-direction Chow form.  The original
balanced-shear leading affine product is universal, so this layer cannot see
the fourth-Witt carrier scalar.  The exact first lower layer `(TR21)` then
locates every coefficient of `A` lacunarily and linearly; in particular the
four fourth-Witt inputs are already present there and `C` begins only at the
next layer.  The live algebraic task is now the actual tangent reflagging.

Second, `notes/2026-08-26-c949-minimal-blocker-variance.md` re-centers the
degree ledger underlying the minimal-blocker bound as C949's defect norm.
Across every
fixed SR11 signature the tight lines partition the blocking complement and
cover the arc fourfold outside an exact `O(q)` weighted degree defect.  This
is a global approximate-design normal form, but the equality theorem remains
inapplicable and no Mason attraction is claimed.

The final audit sharpened both boundaries.  The fourth-Witt coefficients form
a marked tail catalecticant of the binary cube root in `(TR23)`, but every
actual tangent restriction mixes all Chow-normal layers.  Globally, the
embedded tight-pencil sum `(MV4)--(MV5)` is exact, but a local relabeling
switch preserves the tight-line/residue ledger; any degree cap must use
non-tight-line slack or carrier/mapping data.

The non-tight variance then produced a capacity-safe augmentation.  Outside
`O(1)` bad tight lines, a degree-four arc point can exchange with four
degree-one blocker donors while preserving completeness and growing the arc
by three.  The final red-team caught the direction issue: C949's `t_n(2,q)`
minimizes complete-arc size, so this upward replacement neither supplies the
missing construction upper bound nor strengthens the lower bound on `t_n`.
It is retained only as a structural normalization/no-go boundary.

The exact reverse move was then audited.  It needs a blocker-labeled
degree-four center, four arc-labeled degree-one donors, and non-tight slack.
The balanced `(4,-3)` branch is automatically reverse-free at `eta=1,2`;
at `eta=1` its exact blocker degree split has `b_4=0`.  This also exposed a
new carrier boundary: the current Chow/`(E,U)` state is unweighted and cannot
recover the selector labels required by a downward construction.

The marked selector was then routed back through the frozen `(SR16)--(SR17b)`
normal form.  At `eta=1` it is exactly a generic vertex `v_0`, its selected
tangent, and a perfect matching of the other `2q-6` generic vertices in the
three-coloured bisecant graph.  The side colours leave three generic defects
each, so no colour itself supplies the matching; exact feasibility is a
Tutte odd-cut condition not controlled by the current secant moments.  This
is now the first finite preprocessing gate before C962's carrier/mapping
checks, not an asserted identification with its 714 tasks.

The construction audit also separated Mason from the viable mechanism.
Quadratic Mason separation implies every near-base target is
`(2c_*-o(1))q^2` symmetric-difference away from the canonical Mason
complement, up to the removed side.  Hence no greedy completion or `O(q)`
switch chain can work.  The remaining exact conditional construction is
non-Mason: realize the marked `2q+4` blocking four-arc and its matching, then
prove the global off-core concurrency cap.  Selecting its tangent, matching
bisecants, three trisecants, and all four-secants has the desired
`q^2/3+5q/3+1` count, but existence and the off-core cap remain open.

An alternating-colour pass improved the selector frontier further.  Each
side colour is already a perfect matching after deleting the three generic
vertices which it pairs to exceptional lines.  Choosing the tangent marker
at one of those three vertices therefore leaves exactly two exposed
monomers.  Thus the q-scale selector search has matching deficiency at most
two; what remains is one projective augmenting-path lemma through the other
colours.  An abstract coloured countermodel with three isolated generic
vertices shows that degree/colour data alone cannot prove the path.

The pairwise unions sharpen this to a finite defect-wiring dichotomy.  A
same-colour alternating path immediately supplies the missing matching;
otherwise each colour pair induces a bijection between its nonoverlapping
three-point defect sets, with common defects isolated.  Hostile review kept
the scope narrow: third-colour chords still run through q-scale path and
cycle interiors, so only direct two-colour failure is bounded.

The natural marked rational Chow divisor was also compressed exactly.  Up
to the fixed product of all open side pencils and the three vertex factors,
it is the cube of the degree-`q-2` tangent-plus-matching product.  This
recovers the selector but does not bound it; in characteristic three its
ordinary logarithmic derivative vanishes.  Hence the desired bridge must be
a genuinely mixed marked norm identity rather than an unweighted polar.
