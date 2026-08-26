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

The canonical inverse duplex was then pushed through an explicit valid
three-cell deletion.  It realizes all three `1^3 2^(q-4)` projection
profiles and has a raw near-perfect matching, although that matching violates
the selector colour cap.  A direct character calculation is decisive: for
every ternary `q>=27`, simultaneous splitting of the two inverse quadratics
leaves four retained generic lines through a point together with one forced
boundary line.  This strengthens the prior `q>=81` coverage no-go to a
fivefold-concurrency obstruction for the standard inverse family.

The live routing card now also records the earlier carry-free complexity
theorem from `(SR24d)--(SR24j)`: every extendable target duplex has at least
`q/3-2` nonzero critical Prony moments, hence linear multiplicative-Fourier
support and near-maximal interpolation degree in all three charts.  This
closes every bounded-degree/two-monomial formula, while honestly leaving a
genuinely nonlinear non-inverse duplex open.

The SR23 projection condition then yielded a new saturation ledger.  Across
all ordinary directions the `Theta(q^2)` collision mass is within only
`O(q)` of the cap-four packing maximum, and each directional Redei remainder
factors through a residual of degree at most five.  This does not contradict
the full-core profiles, but it changes the remaining construction theorem
into a precise cross-slope propagation problem for bounded residuals.

Adding the six affine boundary labels makes the residual state finite: away
from 15 collision directions, every missing polynomial is one of 64 labelled
subproducts of a fixed degree-six boundary form.  Each label occurs linearly
often, but its defining direction polynomial has degree `2q-5`; simple
interpolation or pigeonhole cannot couple the labels.  Pairwise intersections
of the six tangent-direction sets are the next exact data to control.

Global division then supplied a sharper pre-specialization certificate.
The q-4 regular fibers force every noncube term of the affine quotient
derivative into `X P_reg(M)p(M)`; the two vertex fibers fix two values of the
cubic `p`, leaving at most two scalar freedoms.  The hostile boundary is
important: the two cube channels and division remainder remain q-scale, and
no tangent reflag currently identifies `p` with `(E,U)` or fourth Witt.

The two parameters were then localized exactly.  At each finite bad
boundary slope, the global quotient is the Euclidean quotient of the square
of the triple-root polynomial by the missing-root polynomial; its `X^2`
coefficient gives the corresponding value of `p`.  Those two values plus
the two vertex values determine the cubic.  A chart-compatible value at the
omitted vertical boundary direction would be a fifth, genuinely
overdetermining condition, but the needed homogeneous reciprocal transition
is still absent.

The final homogeneous calculation supplied that condition without a tangent
reflag.  In the raw reciprocal direction coordinates the transformed
remainder keeps degree below `q`, while the vertical product
`(Y-s)C(Y)^3` has no `Y^(q+2)` term.  This kills the cubic coefficient of
`p`.  Hence the two vertex values and two finite-boundary quotient values
must satisfy one explicit quadratic-interpolation determinant.  This is a
real overdetermining quotient gate; its identification with fourth Witt,
the reciprocal norm, or C962's mapping coordinates remains open.

The final `ej`+`tt` closeout extracted two free forms of the gate.  After
subtracting the linear vertex interpolant, the two boundary quotients must
produce one common scalar.  At the top-product level the same condition is
the normalized elementary-symmetric identity `e_(q-1)(a)=0`, hence the
constant-time q=27 filter `e_26(a)=0`.  Red-team confirmed the algebra and
also the scope: the filter is flag-dependent, so it cannot be inserted into
C962's 714 tasks until the explicit carrier-to-Redei gauge map is fixed.

A last coordinate sanity check compared this zero with `(TR20)`: the
analogous coefficient in the original balanced-shear top form is `1`.
Independent red teams confirmed that the flags differ and the full
projective reflag mixes lower Chow layers and completion factors.  The
apparent `1 -> 0` change is therefore an exact compiler unit test, not a
contradiction and not a gate on raw carrier coordinates.

The cyclic closeout repeats the boundary calculation in all three bad
directions.  The three `e_(q-1)=0` conditions assemble into divisibility of
one degree-`q-1` binary elementary-symmetric form by the boundary-direction
cubic.  For q=27 this gives three exact `e_26` post-reconstruction
prefilters.  No independence or raw-carrier formulation is claimed.

The final compiler audit removed the remaining coordinate ambiguity.  For
the affine-core Chow product `C_B(U,V,W)`, the binary form is exactly
`[W^(q+2)]C_B`; the three roots are the normal covectors to the boundary
directions, so the divisor is the dual boundary cubic.  At q=27 this is the
degree-26 coefficient `[W^29]C_B`.  The carrier-to-Chow construction already
builds this product after a terminal's mapping and boundary frame are
resolved.  If starting from `Chow_D`, its three known infinity factors must
first be removed.  Thus the gate is now an exact post-terminal compiler
filter, while its independence and rejection power remain open.

The final TT pass also removed the need to materialize the full Chow form.
At a boundary normal covector, the two carrier roots over each nonzero row
give a quadratic generating factor with coefficients expressed directly in
`A(u^3),C(u^3),w,u`; the three affine-axis points give three linears.  A
truncated coefficient recurrence through degree 26 therefore computes each
q=27 `e_26` value from a completed carrier and resolved mapping, without
splitting the carrier quadratics.  Its redundancy or extra rejection power
relative to the existing terminal gates remains an explicit computational
question.

The final hostile compiler review caught a variable-name trap.  The abstract
affine Chow convention uses the constant-coordinate variable `W_aff`, but in
the existing homogeneous carrier form an affine factor is `Z+Mu-tW`; hence
`(U,V,W_aff)=(M,-W,Z)`.  The specialized q=27 coefficient is therefore
`[Z^29]`, not `[W^29]`, after removing the three infinity factors.  The
three-scalar recurrence is unchanged and is the safer implementation.

The last TT/EJ pass supplied two exact upgrades.  First, joint Frobenius
transport cubes the three projection scalars and permutes their boundary
labels, so the all-zero filter is constant on C962's 714 joint work orbits.
Second, the entire directional elementary-symmetric form is
`psi=-1-P_reg p` with `deg p<=2`: its values are `-1` on all regular
directions, `1` at the two vertex directions, and zero at the three boundary
directions.  This yields a stronger quadratic-quotient compiler check, but
also proves a sharp no-go: this coefficient cannot distinguish the 64
labelled degree-five residual patterns.  Cross-slope propagation must use a
lower projection coefficient.

The final hostile probe computed that next coefficient explicitly.  It is
`e_(q-2)(b-Ma)=-[X^3]Q`, equal on a regular fibre to
`d_m([X]G_m)^3` and zero at both vertex directions.  This is the first
coefficient that is not spectrum-blind, but it lies in the unrestricted
q-scale cube-sector annihilated by the derivative used for the bounded
quadratic gate.  The labelled missing-root subset does not determine it.
Thus the next real theorem must connect `A_m` to `G_m` or control that cube
sector globally; simply descending the Chow coefficients is not enough.  A
last free interpolation step gives two exact q-scale checksums: the sum and
slope-weighted sum of the regular `d_m([X]G_m)^3` values are fixed by the two
finite-boundary and one vertical quotient values.  These are useful compiler
consistency checks, not bounded label compression.

The terminal-interface audit narrowed the last compiler ambiguity.  Rust's
constructor stores `columns=t` and `ratios=t/u`, so the natural restored
directions are `[row:column:0]` and their normals are `(column,-row)`.  The
remaining task is to certify that these code directions are exactly the
paper's `R_infinity` frame and add a replay fixture; no extra shear belongs
in the normal.  Until then the gate remains a post-terminal diagnostic.  The
closeout also blocks one last false inference: cubing is bijective in the
ternary field, so TR46's cube values provide no common-root gluing.

The final source check then closed the adapter mathematically.
`(SR24t)--(SR24u)` define the Frobenius `(u,t)` frame and explicitly call the
singleton `t/u` values the infinity-boundary directions;
`(SR24u''''')` has `e_i=r_i u_i`, exactly Rust's
`columns=ratios*rows`.  Therefore the restored points are
`[row:column:0]` and their normals are `(column,-row)`.  No lookup table or
extra shear is needed.  The only remaining implementation work is a small
field-encoding/replay fixture and rejection-distribution measurement.
The derivation uses the resolved mapping's ratio pairing; the unordered
row/column triples alone do not determine the infinity points, and no such
claim is made for a nonextendable carrier without boundary-direction input.

The final AA pass recovered the first exact local marked bridge.  At a
regular slope, H is missing a boundary intercept `b` exactly when its
six-boundary multiplicity equals
`1+ord_b((X-d_m)G_m^3)`.  With distinct boundary intercepts and
`B_6=A_mD_m`, this is
`gcd(B_6,(X-d_m)G_m^3)=D_m`.  Thus the missing label separates roots outside
the double/quadruple support from complementary boundary roots forced into
it.  The result is collision-safe in valuation form, but the remaining
cofactor of `G_m` is q-scale; no global cube gluing follows.
