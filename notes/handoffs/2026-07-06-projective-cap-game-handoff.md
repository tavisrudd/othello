# Handoff: Projective Cap Achievement Game

**Lane**: `cap` — see CLAUDE.md § Lane routing.

Date created: 2026-07-06.  Current-state synthesis refreshed: 2026-07-17.

The previous long handoff, including the full chronological session log and superseded planning
notes, was moved intact to
[`done/2026-07-08-projective-cap-game-handoff-archive.md`](done/2026-07-08-projective-cap-game-handoff-archive.md).
Use this file as the canonical current map.

## Current Takeaway

The projective cap/Nofil program is now sharply split.

Closed or structurally understood:

- `AG(n,q)` is P for all finite affine spaces.
- `PG(n,2)` is P for every projective dimension `n >= 1`.
- `PG(2m-1,q)` is P for every odd `q`, by a fixed-point-free elliptic projective involution.
- `PG(2,q)` is P for all even `q`.
- `PG(4,3)` is computed P, the first direct outcome in the still-open higher-even-dimensional,
  odd-field family; the exact C43 orbit-canon solve and independent cross-checks used 25,258 memo
  states.
- Odd projective planes are proved in Lean for `q = 5, 7, 11, 13`; `q = 3, 9, 17, 19` are
  computed P but not all Lean-closed.  `q = 23` now has a bucket-first on-conic computation:
  all 22 full-`PGL(2,23)` on-conic buckets are P.  By the full-PGL conic-projectivity bridge
  (Lemma I of the intrusion-calculus note; **now a verified Lean theorem** —
  `ProjectiveCap.Sym2Bridge.onconic_value_bridge`, C53 parts 1–2, see
  [C53 report](../2026-07-09-codex-full-pgl-bridge.md)), this establishes the computed q=23
  on-conic/escape result without the former orbit caveat.  C54 has now independently checked the
  early-break proof DAG for all `241,627,613` raw records across the 22 buckets, with exact
  reachability and zero game-equation failures.  Trust tier: q=23 is **computed and
  rules-certified at the S4 bucket layer, not Lean-unconditional**; a Lean certificate consumer
  and fixed-q assembly are still needed for `Projective.InitialPStatement`.
  `q = 25` has a first GF(25) S4-rooted sizing probe: the normalized representative
  `{1,2,3,4}` is P, using about 26.3M private memo entries with early break.  This is not a full
  q=25 bucket census.

Main remaining mathematical problem:

> Prove the odd projective-plane kernel: for every odd `q`, `PG(2,q)` is P.

The present evidence says this is **not** a search for another static mirror.  The viable route is:

```text
frame reduction
→ residual q x q grid game
→ conic-localized size-4 escape
→ intrusion / Node-Kayles / defect repair
→ second-intrusion or zone-steering strategy lemma
```

Mirrors remain useful proof infrastructure and diagnostics, but C27/C28 show they are not the
uniform odd-plane mechanism at the size-4 escape layer.

C29 also killed the clean residue-class explanation for mixed on-conic columns: `q = 23` is
all-P at the bucket layer even though `23 == 2 mod 3`.  Treat arithmetic/order features as
diagnostics, not as the main classifier.  C31 and its follow-up point to a sharper uniform-proof
pressure point: one-pair descent from large raw intruder zones back to the small `Z <= 2`
steering family.

## Status Table — PG(2,q)

| q | Value | Evidence / proof state | Remaining gap |
|---|---|---|---|
| even q | **P** | Lean theorem: `PlaneOutcome.initialPStatement_of_even_card_finrank` / char-2 residual translation mirror | none |
| 3 | P | exhaustive solve | no Lean theorem queued |
| 5 | **P** | Lean mechanism theorem: `initialPStatement_of_card_eq_five_finrank` | none |
| 7 | **P** | Lean mechanism theorem: `initialPStatement_of_card_eq_seven_finrank` | none |
| 9 | P | exhaustive solve; q=9 intrusion terminal-reply kernel isolated | Lean kernel/certificate still open |
| 11 | **P** | Lean certificate assembly: `CertData.Q11.initialPStatement_finrank` | none |
| 13 | **P** | Lean certificate assembly: `CertData.Q13.initialPStatement_finrank` | none |
| 17 | P | `esc` campaign; mixed on-conic buckets; C30 anchored cert book emitted and rules-checked PASS (`210/210`, all on-conic, no caps); canonical q17 cert book emitted and rules-checked PASS (`21/21`, `100,526` nodes); generated canonical transport assembly stub-checks; v5 split removes the `ClassNBase` node-check barrier | full q17 canonical Lean build not yet run/committed; no uniform proof |
| 19 | P | `esc` campaign; C30 anchored cert book emitted and rules-checked PASS (`272/272`, all on-conic, no caps) | full q19 Lean data/assembly not committed; no uniform proof |
| 23 | P | C29: all 22 full-`PGL(2,23)` on-conic buckets P; C54: all 22 early-break proof DAGs rules-checked (`241,627,613/241,627,613` records, zero failures); C53 full-PGL bridge is Lean-verified | computed and rules-certified at the S4 bucket layer; Lean certificate consumer/fixed-q assembly still open |
| 25 | (ON)-route evidence only | C68/C44 (2026-07-10): all 28 full-`PGL(2,25)` on-conic S4 buckets P (0 N, 0 aborted; `s4arena` census, ~6.67h/8GB) — `D(25)=0`, min-witness=q−4=21 (full), `ν(25)=0`, not arc-depleted | S4-rooted on-conic escape layer only, not a full-plane solve; no `PG(2,25)` root value claimed; no bucket-DAG rules-check yet (no C54-style pass) |
| all odd q | conjectural P | no counterexample through `q=19`; q=23/q=25 have all-P on-conic bucket evidence | strategy-level proof: defect/zone-steering/second-intrusion, not snapshot invariant |

## Closed Higher-Dimensional Families

### Binary Projective Spaces

For `q = 2`, projective points are nonzero vectors and lines are `{x,y,x+y}`.  The game is exactly
Nofil on the projective binary Steiner triple systems.

Lean file: [`../../lean/ProjectiveCap/Binary.lean`](../../lean/ProjectiveCap/Binary.lean).

Key theorem names:

- `Projective.initialPStatement_binary_of_finrank_ge_two`
- `Projective.initialPStatement_binary_of_projectiveDim_ge_one`
- bridge: `binaryPointEquivNonzero`, `binary_nonzeroValid_iff_cap`
- sum-free input: `Sumfree.Game.nonzero_initial_isP_zmod2_of_finrank_ge_two`

Status: **closed** for every `PG(n,2)`, `n >= 1`.

### Odd Projective Dimension Over Odd Fields

For odd `q`, every `PG(2m-1,q)` is P by a whole-board mirror from a nonsplit/elliptic projective
involution.  Choose a nonsquare `d`; on each 2-dimensional block define `T(a,b) = (d b, a)`, so
`T^2 = dI`.  Projectively this is a fixed-point-free involution.

Lean files:

- [`../../lean/CapGame/Mirror.lean`](../../lean/CapGame/Mirror.lean)
- [`../../lean/ProjectiveCap/Mirror.lean`](../../lean/ProjectiveCap/Mirror.lean)
- [`../../lean/ProjectiveCap/EllipticMirror.lean`](../../lean/ProjectiveCap/EllipticMirror.lean)

Key theorem names:

- `Projective.initialPStatement_of_fixedPointFree_collinearity_preserving_involution`
- `Projective.initialPStatement_of_linearEquiv_sq_scalar_nonsquare`
- `Projective.initialPStatement_of_odd_card_finrank_eq_two_mul`

Status: **closed** for odd projective dimension over odd finite fields.

### Even Projective Dimension Over Odd Fields

These are not closed in general.  The plane case `PG(2,q)` is the main open kernel.  Higher even
dimensions `PG(2m,q)`, `m >= 2`, odd `q`, remain open.  C32 refuted the primary point-reflection
composite-mirror idea in the plane and found an immediate fixed-`rho` seed obstruction in PG(4,3);
future even-dimensional work needs a new non-primary design.

**First direct evidence:** C43 exactly solved `PG(4,3) = P`, the first even-dimensional odd-`q`
board outcome.  The compiled orbit-canon solver used 25,258 memo states and 3.7 seconds; forward
and reverse move orders plus an independent canonicalization all agree on P.  This removes the
former evidence vacuum and supports the broader all-P conjecture, but it does not close the family:
`PG(4,5)`, `PG(6,3)`, and every uniform strategy theorem remain open.  The immediate structural
follow-up is to extract the `PG(4,3)` second-player strategy and test it for a recognizable
non-primary mechanism.  Report:
[`../2026-07-09-codex-pg43-sizing.md`](../2026-07-09-codex-pg43-sizing.md).

### Classical Varieties (C48 mirror harvest)

The generic fpf-involution mirror lemma is not tied to full projective space; it applies to any
classical variety whose cap game runs on ambient lines.  C48 harvested it (report
[`../2026-07-09-codex-mirror-harvest.md`](../2026-07-09-codex-mirror-harvest.md); generator
`rust/scripts/projcap_mirror_harvest.py`; each board built directly from its defining form, so
intersection patterns and point counts are verified, not trusted).

- **New family — hyperbolic quadric `Q⁺(2m−1,q)` is P for every odd `q`, every `m ≥ 2`.**  The
  C25 elliptic block map `(aᵢ,bᵢ) ↦ (d·bᵢ, aᵢ)`, `d` nonsquare, is a factor-`d` similarity of
  the hyperbolic form `Σ aᵢbᵢ`, so it preserves the quadric while staying fpf and
  collinearity-preserving (already Lean-proven in `EllipticMirror.lean`).  Machine-verified:
  Q⁺(3,3/5/7) (full C27 pair-extension over every σ-invariant cap + exhaustive solve), Q⁺(5,3)
  (involution + sampled).  `Q⁺(3,q)` is exactly the `(q+1)×(q+1)` capacity-2 rook grid (E1
  vocabulary) and has a second proof by translation mirror `(i,j) ↦ (i+h, j+h)`.
- **Boundary program (strict trust tiers):** the hyperbolic positive family is Lean-proved.
  Both linear parabolic routes and the full modeled square-scalar Baer-semilinear board-stabilizer
  route are Lean-proved; the latter uses a local coordinate-free null-cone rigidity theorem, with
  no imported classification axiom. Both linear Hermitian routes and the full square-scalar
  Baer-semilinear representative branch are Lean-proved.
  The former elliptic `Q⁻(2m−1,q)` exclusion conjecture is false: a Chevalley–Warning coefficient
  lemma makes the nonsplit block map preserve a standard elliptic form in every even vector
  dimension, proving its cap game P. The strict theorem is coordinate-exact and transports through
  any supplied projective linear equivalence.
  `H(2,9)`/`H(3,4)` compute P regardless, so these are method boundaries, not outcome flips;
  `Q(4,q)` parabolic is the first open outcome here.
- **Trivial rows flagged:** ovoids `Q⁻(3,q)` are free placement (P by `q²+1`-even parity);
  `H(2,4) = AG(2,3)` (P by the affine theorem, odd point count, not a mirror family).
- **Lean landed:** [`../../lean/ProjectiveCap/HyperbolicQuadricMirror.lean`](../../lean/ProjectiveCap/HyperbolicQuadricMirror.lean)
  and [`../../lean/ProjectiveCap/MirrorBoundary.lean`](../../lean/ProjectiveCap/MirrorBoundary.lean)
  (imported from `ProjectiveCap.lean`; builds clean; axiom profile `[propext, Classical.choice,
  Quot.sound]`).  The general proposition is `initialSubCapP_of_fpf_collinearity_preserving`
  (an fpf collinearity-preserving involution preserving a sub-board `Q ⇒ IsP (SubCap Q) ∅` —
  the cap step reuses `mirrorStepGood_of_collinearity_preserving` verbatim, only `Q x → Q (σ x)`
  is new).  The harvested family is `initialSubCapP_blockQuadric_of_odd_card` (`Q⁺(2m−1,q) = P`,
  odd q), via `blockForm_ellipticBlock` (the factor-`δ` similarity) + `onBlockQuadric_map`.
  `FiniteQuadraticIsotropy` proves dimension-at-least-three isotropy from Chevalley–Warning;
  `FiniteHermitian` proves quadratic norm surjectivity/square reflection, Hermitian isotropy, and
  the nonsplit multiplier obstruction;
  `MirrorBoundary` proves the scalar-square eigenspace-to-board obstruction and the odd-dimensional
  determinant exclusion, completing both linear parabolic and Hermitian routes;
  `BaerSemilinear` proves coordinate Frobenius, constructive general semilinear conjugacy, its fixed
  base subgeometry, and the full Hermitian intersection. `BaerQuadraticUntwist` and
  `QuadraticNullCone` prove the local zero-locus-stabilizer bridge, and
  `BaerQuadraticStabilizer` derives the full modeled parabolic conclusion from projective board
  preservation. `EllipticQuadricMirror` overturns the proposed elliptic exclusion and proves the
  standard `Q⁻` P family using an anisotropic-tail construction. C87–C88 are closed in the dedicated
  [`2026-07-12 mirror-boundary handoff`](done/2026-07-12-mirror-boundary-formalization.md); the detailed
  theorem specification remains
  [`../2026-07-09-mirror-method-boundary.md`](../2026-07-09-mirror-method-boundary.md).
  Disjoint from the C41/C50 files.

## Odd-Plane Kernel

For the falsification-mode taxonomy and the proof-by-elimination scaffold over this kernel (the
"conjecture false ⟺ a trapped size-3 exists" framing, the intruder-regime elimination table, and
which failure modes are eliminable vs the irreducible open core), see
[`../2026-07-09-odd-plane-falsification-map.md`](../2026-07-09-odd-plane-falsification-map.md).

### Frame Reduction

For rank-3 projective spaces, the game reduces to one frame position.

Lean theorem:

- `Projective.initialPStatement_iff_isP_frame_of_finrank`

Informal chain:

```text
empty P
⇔ point child N
⇔ pair child P
⇔ triangle child N
⇔ frame child P
```

This uses PGL transitivity on points, pairs, triangles, and frames plus extendability up to size 3.

### Residual Grid Game

After the opening pair, delete the opening line.  The remaining points form an affine chart, but
the residual game is **not** plain `AG(2,q)`.

Residual legal positions are:

```text
affine caps
+ at most one point in each row
+ at most one point in each column
```

Rows and columns are the two burned parallel classes coming from the opening pair.

This distinction is load-bearing.  The affine theorem does not directly transfer.

### Size-3 Escape Crux

Every legal size-3 residual grid position has exactly

```text
q^2 - 9q + 21
```

legal size-4 extensions.

Lean theorem:

- `ProjectiveCap.Stable.SizeThreeExtensionCountStatement`

Odd plane root P is equivalent to the escape condition:

```text
every legal size-3 residual grid position has at least one P-valued size-4 child.
```

Formal target:

- `ProjectiveCap.Almost.OddEscapeGameStatement`

**Lean status:** the equivalence is now proved bidirectionally by
`GridGame.TrapConverse.initialPStatement_iff_oddEscapeStatement_finrank` (C41, 2026-07-09).  The
converse uses a trapped residual P-position, the frame-grid bridge, four-frame transitivity, and
value transport to produce a P-valued child of the standard frame.  The remaining caveat is the
usual Lean/spec-match issue, not the frame-transport link.

### Conic Localization

Each residual size-3 position plus the two burned directions gives a projective 5-arc, hence a
unique conic.  In grid coordinates the conic is a Möbius/hyperbola graph.

Key facts:

- the `q-4` remaining on-conic cells are all legal extensions;
- all computed escapes through `q=19` have an on-conic P witness;
- C29's q=23 bucket-first census found all 22 full-`PGL(2,23)` on-conic buckets P, which by the
  full-PGL bridge gives the computed q=23 on-conic escape result;
- the q=17 min-escape classes have exactly one on-conic P witness.

Current sharper target:

```text
(ON) every size-3 residual position has a P-valued on-conic size-4 extension.
```

This is the active mathematical kernel.  It turns the problem into a one-dimensional conic
parameter-line game with intrusions.

The Clebsch formalization review's
[`Transfer to C294 and the cap lane's odd-q all-P kernel`](../2026-07-20-clebsch-lean-formalization-plan-fable-review.md#transfer-to-c294-and-the-cap-lanes-odd-q-all-p-kernel)
indexes three reusable inputs for this kernel: `deepTransform` is already the exact plane move
operator; C379/C398/C399/C403 supply orbit-canonical endgame and terminal-parity data for a future
exact odd-q solver; and `PGL_3(q)` has no fixed-point-free even-order projectivity (while Baer
involutions fix a subplane), so a plane proof cannot come from the mirror route.  The same review
also gives C294-specific marks, matching-switch, and normalizer-involution falsifiers.  These are
method transfers only: they do not prove `(ON)`, all-P, or resume C294.

#### Relative-complete sealing bridge — C100 review

The `RelativeConicArcs` spinoff now has a proved game-domain bridge: if `A` is complete outside a
hole set `H`, every projective cap continuation `S ⊇ A` is contained in `A∪H`, and every legal move
from every such continuation lies in `H`. For `H=𝒞`, sealing into the conic residual therefore
persists throughout later play; this is stronger than a one-step localization observation but does
not assert that the seed is reachable or P.

C100 is reported. The q=9 witness is Lean-proved ordinary-complete and terminal P; the q=11
witness is Lean-proved P as an actual seeded projective-cap position, not merely as an abstract
residual graph. The exact recursive parametrized-hole bridge supplies the value transport. Tested
two-ply descent closure into either six-point orbit was absent, and the proved identification of
off-hole legal moves with the uncovered locus did not sharpen C80's minimax drain. Guardrail: the `rhoC` lower
bound shows that an intruder-only complete conic seal needs order `sqrt(q)` points, so this cannot
replace the bounded-size forcing or exchange lemma needed for (ON). Current map:
[`C100 relative-conic game bridge`](../2026-07-12-c100-relative-conic-game-bridge.md).

C101 adds a potentially reusable static rejection primitive: ordinarily uncovered points impose
linear conditions on quadratic forms, and full rank certifies that no conic seal exists (the
rank-five case can force the conic to hit the position). This can prune proposed conic-sealed
terminal regions in an odd-q certificate search, but it supplies no move, descent measure, or
minimax response by itself; review it only where C80/C84 already produces a candidate sealed
state.

C187 classifies equality `U(A)=C(F_q)` for `4 <= |A| <= 7`: its only cases are the projective frame
in `PG(2,5)` and the Clebsch hexagon in `PG(2,11)`. For `q>=13` it excludes only that exact equality,
not a proper conic-contained extension locus, another conic-localized seed, or a more general
sealing argument. It does not touch `(ON)`, which needs only one P-valued on-conic child. C189 is
the queued game-side consumer: certify that the six `q=5` frame continuations have octahedral
conflict graph `K6` minus a perfect matching, derive the antipodal copycat P-position, and pair it
with the existing q=11 icosahedral seed. See the
[`C189 bridge`](../2026-07-15-c189-q5-octahedral-frame.md).

C110's consumer review adds three proved tools worth testing only at matching pressure points:

- `EvaluationDichotomy.feature_evaluation_avoidance_iff` decides when one degree-`d` form can
  contain an uncovered set while simultaneously avoiding at most `q` selected points. This
  strengthens C101's static pruning from one forced selected hit to exact multi-point avoidance,
  but remains a rejection test rather than a response strategy.
- `SyndromeGeometry.arc_union_iff_extension_hypergraph` gives the exact simultaneous-extension
  object: pair conflicts with the old position plus triple conflicts among new points. When the
  legal locus is confined to a conic, the triple part vanishes and continuations maximal inside
  that conic are exactly maximal independent sets of the pair-conflict graph. Ordinary
  completeness requires the conic to be the full one-point extension locus; the generic theorem
  `completeOutside_empty_of_maximalExtensionIn_full` states that extra gate, and q11 verifies it.
  This is directly reusable for
  certifying sealed residual classifications and guards against incorrectly treating an arbitrary
  legal locus as a graph.
- The q11 Clebsch seed is now classified beyond its P-value: its conic extension complex is the
  icosahedron independence complex `1+12t+36t²+20t³`, with six complete eight-arc and twenty
  complete nine-arc continuations; its six witness-coloured five-edge matchings partition the
  conflict graph and miss antipodal pairs. Review this as a finite base-case/template source for
  A5-anchor or small-residual certificates, not as evidence for a uniform odd-q descent law.
- The same q11 conflict graph is being used in three ways across the portfolio: extension-set
  enumeration here, continuation/reconstruction invariants, and Node--Kayles/pairing play. Review
  the 12-point nonregular `A₅` action as a certified instance of the deferred polyhedral-template
  program, and audit the common off-conic-point/conic-involution object before duplicating claims.
- Completion distance, repair tolerance, and arc-insertion resilience share the obstruction-family
  transversal invariant `δ=τ`. Before promoting a twisted-cubic "transversal spectrum" claim,
  compare the completion and coding lanes so the same invariant is not independently headlined.

The coding restatement of the defect theorem is conceptually useful but introduces no stronger
dynamic inequality: leader counts are the same secant indices already tracked by C80/C84.

## What Is Dead

Do not restart these as proof routes unless new evidence changes the premise.

- **Single fixed involution for odd planes:** closed by exhaustive mirror-family tests.
- **Play-closed symmetric strategy family:** `resym` killed this at `q = 11,13,17`.
- **Naive parity:** works through `q <= 9`, breaks from `q = 11`.
- **Area/arc bound `bad = o(q^2)`:** refuted by q=17, where `bad = 152` of `total = 157`.
- **Static 6-subset feature dictionary:** C18 null result; shallow cross-ratio/character/order
  features do not explain P/N buckets.
- **Weak fixed-locus mirror principle:** false without the pair-extension condition.
- **Size-4 mirror certificate compression:** C28/`mir` found zero `MirrorStepGood` hits among:
  q=11 all P escape children, q=13 all P escape children, and q=17 min-escape children.
- **Mixed-column mod-3 law:** C29 refuted it at q=23.  The prediction was mixed because
  `23 == 2 mod 3`; the bucket-first full-PGL on-conic census found all 22 q=23 buckets P.
- **Primary composite mirror for odd-q even dimensions / planes:** C32 refuted the simple
  point-reflection + double-pencil-burn candidate.  In planes, q=9/11/13 have no stuck-free
  affine seed even with adaptive infinity replies and exception cells.  In PG(4,3), fixed
  elliptic `rho` fails immediately at the seed obligation for every affine seed.  Reflection
  towers or non-fixed-H variants would be new designs, not continuations of this primary route.

## Mirrors: Correct Role

C27 corrected the mirror lemma.

For a mirror reply `tau(x)` to prove anything, it is not enough that:

```text
x legal ⇒ tau(x) legal
```

The actual condition is:

```text
S ∪ {x, tau(x)} is valid for every legal x.
```

The missing obstruction is the mirror chord `x tau(x)` hitting selected/problem structure.

Definitions:

- `MirrorStepGood(S,tau)`: one-position pair-extension mirror condition.
- `MirrorClosed(S,tau)`: the condition persists through every mirror-pair follower.
- `Obs_tau(S)`: legal moves whose mirror reply fails by fixed point, selected image, row/column
  chord, or ordinary collinearity chord.

Use mirrors for:

- closed whole-board families such as elliptic involutions;
- q-even residual translation mirrors;
- deep certificate leaves if future diagnostics find hits;
- obstruction histograms and endgame design.

Do not use mirrors as the main odd-plane proof plan.

## Intrusion / Defect Program

The active route is the conic residual.

Current structural picture:

- An off-conic intruder induces an involution on the conic parameter line.
- Conic-restricted play after intrusions is Node-Kayles on a union of involution matchings.
- Two-intruder components are even cycles plus small defect skeletons.
- Even cycles are Grundy-0, so the large bulk cancels.
- The value lives in Dawson-path-like defect skeletons and in the live off-conic zone.
- C29 says the next law is unlikely to be a residue class of `q` alone: q=11 and q=17 are mixed,
  q=13, q=19, and q=23 are all-P at the on-conic bucket layer.  Use order/spectrum features to
  describe intruder dynamics, but prioritize recursive steering/repair statements.
- C31 supports the recursive steering route: among C20 P reply-states, the raw off-conic zone
  reaches 10 at q=13 and 38 at q=17, but the optimal recursive steering ceiling is only 2 at q=13
  and 9 at q=17.
- The C31 follow-up sharpens this further.  For every tested C20 P reply-state and every legal
  opponent move, a score-optimal winning reply lands in a grandchild with `Z <= 2`.  At q=17 the
  remaining cost is immediate zone, at most 9, rather than persistent recursive complexity.
- q=19 extends the same dynamic picture at larger scale: all 13 on-conic buckets are P, every legal
  first intrusion from the bucket representatives is N-valued, and recursive steering over 63,479
  unique P reply states has `max Z = 16` despite raw zones up to 57.  The bound is growing, but
  the steering route remains alive.
- Repair-move mining of the same data shows the expensive q=17 descents are mostly
  intruder-for-intruder repairs.  All score-9 repairs empty the conic residual and leave
  `defxor = 0` with zone Grundy 0, so the proof target should be a repair-intruder existence
  lemma plus a small-Z / empty-conic base law.
- Geometry mining sharpens the worst case: every score-9 repair has one live conic parameter
  before the reply, and the selected reply is the unique legal internal intruder that both kills
  that last live parameter and leaves a clean P-valued empty-conic state.  The same repair intruder
  answers both score-9 opponent moves from a state and is already legal/internal before those moves.
  Product order/line type alone does not characterize it.
- Follow-up checks: the internal conic-emptying rule is perfect for the q=17 score-9 stratum but
  fails as a global score<=8 repair rule; the natural polarity identities are false; the 14 score-9
  states collapse to two `PGL(2,17)` orbits even after adding the guard and worst moves.

Useful references:

- [`../2026-07-07-conic-localization-onconic-escape.md`](../2026-07-07-conic-localization-onconic-escape.md)
- [`../2026-07-07-onconic-intrusion-calculus.md`](../2026-07-07-onconic-intrusion-calculus.md)
- [`../2026-07-08-nk-involution-residual.md`](../2026-07-08-nk-involution-residual.md)
- [`../2026-07-08-codex-mirrorgood-census.md`](../2026-07-08-codex-mirrorgood-census.md)

Likely proof shape:

```text
on-conic move
or controlled first intrusion
or second-intrusion repair
or zone steering to a small-zone endgame
```

Current proof target after C31 and the one-pair descent check:

```text
small-zone base law for Z <= 2
+ one-pair descent / repair lemma from the C20 P reply-state regime
=> on-conic escape theorem
```

## Current Lean Map

Primary files:

- `CapGame/BuildGame.lean`: finite build-game kernel.
- `CapGame/Mirror.lean`: generic mirror strategy lemmas.
- `CapGame/Embedding.lean`: live embedded-subboard transport.
- `CapGame/Affine.lean`: affine cap theorem.
- `ProjectiveCap/Projective.lean`: projective cap definitions and frame wrapper.
- `ProjectiveCap/PlaneTransitivity.lean`: rank-3 geometry, frame reduction.
- `ProjectiveCap/GridGame.lean`: residual grid game.
- `ProjectiveCap/ExtensionCount.lean`: total lemma.
- `ProjectiveCap/EscapeParity.lean`: parity route.
- `ProjectiveCap/IntrusionCalculus.lean`: conic-only/free-endgame theorems and q=5/q=7/q=9
  reduction machinery.
- `ProjectiveCap/Mirror.lean`: projective mirror wrappers.
- `ProjectiveCap/EllipticMirror.lean`: odd-dimensional odd-q theorem.
- `ProjectiveCap/Binary.lean`: `PG(n,2)` theorem.
- `ProjectiveCap/Certificate.lean` and `ProjectiveCap/CertCheck.lean`: certificate route.
- `ProjectiveCap/CertData/Q11Assembly.lean`, `Q13Assembly.lean`: closed q=11/q=13 planes.

Before running broad Lean builds, check whether large generated cert jobs are active.  Prefer
targeted commands:

```text
nix develop --command lake build ProjectiveCap.Binary
nix develop --command lake build ProjectiveCap.EllipticMirror
nix develop --command lake build ProjectiveCap.CertData.Q11Assembly
nix develop --command lake build ProjectiveCap.CertData.Q13Assembly
```

## Solver Map

Main solver:

- [`../2026-07-06-grid-cap-solver.rs`](../2026-07-06-grid-cap-solver.rs)
- Manual for the S4 memo dump / compact archive / runtime query tooling:
  [`../2026-07-08-s4-memo-dump-query-manual.md`](../2026-07-08-s4-memo-dump-query-manual.md)

Build from `rust/`:

```text
rustc -O -C target-cpu=native ../notes/2026-07-06-grid-cap-solver.rs -o target/gridcap
```

Important modes:

- `escape q`: size-3 escape histogram using shared memo.
- `esc q [--cap N] [class...]`: private-memo per-class escape solve.  Historical q=23
  size-3-rooted sizing hit the cap; prefer bucket-first S4-rooted probes for q >= 23.
- `feat q`: conic/on-off/internal feature dump.
- `cert q [--anchored]`: emit certificate books.
- `certcheck q file`: independent rules-only certificate check.
- `mir q`: C28 `MirrorStepGood` / `MirrorClosed` diagnostic.
- `resym`: symmetric-family closure test; route closed but mode is useful for regression.
- `boundary`: old odd-maximal-cap embedding test; route closed from q=11.
- `par`, `outcome`, `defect`: broader exact solver modes.
- `s4dump`, `s4pncheck`, `s4freeze`, `s4query`, `s4mine`: exact raw mmap memo dumps, independent
  rules-only early-break proof-DAG checking, compact BuRR-style archives, runtime line-protocol
  queries, and non-interactive root-child/reply/ply-summary rows
  for S4-rooted pattern mining.  See the manual above before using compact archives for anything
  beyond exploratory mining.
- `rust/scripts/s4_ml_mine.py`: uv-backed parser/ML-style summarizer for `s4mine` logs.  It emits
  feature TSVs, PCA/tree reports, joint geometry summaries, and the current conic-depletion bound
  report under `rust/s4-dumps/<date>/ml/`.

Regenerate cert files on demand; `notes/certs/` is intentionally ignored.

## C84 in the odd-q proof program

C84 has stopped at its certificate-density conceptual gate. Its umbrella owns the essential odd-q
relationship, Schreier abundance state, closed attacks, ledger boundary, and final bounded negative:

> [C84 abundance-first conic Schreier handoff](c84/README.md)

Do not restart C84 from this general cap handoff. Re-entry must satisfy the umbrella's theorem-level
condition rather than preload its dated evidence reports or run another census.
The immediate broader crown is [C294](../2026-07-17-c294-full-conic-continuation-crown.md): it
crosses the full-`PGL2` boundary with an explicit P-family but does not provide C84 density.

## Near-Term Queue

Use [`../2026-07-07-codex-task-queue.md`](../2026-07-07-codex-task-queue.md) as the operational
task list.  Current high-value items:

- **C189 [QUEUED] — q=5 octahedral frame bridge.** Import C187's exact six-point conic extension
  locus, certify the expected `K6`-minus-a-perfect-matching conflict graph and antipodal-copycat
  P-position, then place it beside the q=11 icosahedral seeded P-position. This is a finite
  polyhedral base-case comparison, not progress on `(ON)` or a uniform odd-q law.
  [Proof obligations](../2026-07-15-c189-q5-octahedral-frame.md).

- **C198 [QUEUED] — bounded q=7 complete-exterior residual scout.** Reconstruct BSW's q=7
  exterior four-arc, compute its twenty-point continuation locus and residual graph, and stop unless
  a clean symmetry, involution, or certified P-position appears. This is a scout beside C189, not a
  reformulation of `(ON)`. [Scout](../2026-07-15-c198-q7-exterior-residual-scout.md).

- **C199–C200 [QUEUED] — dihedral-paper expert upgrades.** Extract direct pairing/winning-move
  strategies from every published Schreier-template value, then identify the bounded template
  graphs through automorphism, spectrum, orbital, and coherent-configuration data. These strengthen
  the standalone dihedral paper and do not change C84's abundance-first game frontier. See the
  [expert-question portfolio](../2026-07-15-expert-questions-upgrade-portfolio.md).

- **C100 [REPORTED] — relative-conic sealing review.** Exact game localization, q=9 terminal P,
  and the actual q=11 icosahedral seeded P position are Lean-proved. The tested descent and
  defect-to-C80 levers were negative; static existence was not promoted into an (ON) or root-value
  claim. [Final map](../2026-07-12-c100-relative-conic-game-bridge.md).

- **C80/C81/C82 (game-side follow-ups to C79's bulk-gap spec):** **C80** — game-side probe; part
  (c), the drain resource, is proven+verified (`|live conic|` drops by `1+deg` per conic move,
  [report](../2026-07-12-c80-bulk-exhaustion-probe.md)); the C447/C460 q=11 five-point cloud packet
  has exact branch law `12 killed + 5 live/bad + 5 live/good`, with good/bad whole `C5` orbits;
  the intrinsic edge quotient `u=XZ/Y²` separates them by Legendre class, and the full 22-move
  winning-response graph has exactly two perfect matchings.  Its square `C5` fixes both while the
  nonsquare `D10` coset swaps endpoint and matching, realizing the C448 calibration torsor at the
  strategy-certificate level.  More sharply, the unforced graph is two `C5` edge orbitals whose
  union is `C10`; each orbital is a perfect matching, reducing the generic target to a nonempty
  P-pure equal-orbit response relation (regular-bipartite Hall).  For game value, even matching is
  overkill: the six opponent orbits have a unique three-type response cover, so one winning reply
  per opponent-orbit representative suffices by transport.  C474 sharpens the torsor diagnostic:
  the cap calibration is the reflection class `D10/C5`, which vanishes after marking an endpoint;
  its characteristic-three q=11 Ext carrier is distinct and restricts trivially to `D10`.
  The pointed-cubic audit separates the apparent Terwilliger signals: `tr(B^3)` is a three-word
  trace on the conic permutation sort, while `Q3` is positivity of a third factorial quotient-energy
  count on the reply-pencil sort.  Neither determines the other on all 112 q17 score-9 primitive
  candidates.  `(tr(B^2),tr(B^3))` is value-pure there, with clean pairs `(74,60)` and `(80,50)`,
  but remains a finite base classifier; a uniform proof needs a two-sorted incidence/flag lift plus
  descent, not one ordinary Terwilliger table.  Expanding the third trace now extracts a genuine
  bounded generic fibre: intersect the primitive opponent/reply orbital with the three nonsquare
  discriminants of the reply-containing triple involution products.  This fibre is the unique
  clean/P reply on 24/28 q17 score-9 transitions, empty on the four exceptional fibres, and never
  impure.  The `24+4` split is exactly prior-triple nonsplit versus split (zero versus two conic
  fixed points).  Dropping primitivity gives five replies and loses P-purity.  The full q13/q17
  three-intruder census now closes the unchanged packet as a uniform route: q13 survivors are all
  clean/P but cover only 533/2,225 transitions, while q17 has 7,976 all-N and 1,515 impure
  nonempty fibres.  Raw `Y_0` is therefore a terminal score-9 base relation, not a packet for C82
  to count globally.  C80 must add a state/descent guard or prove bulk descent into that base.
  A uniform quotient/response theorem,
  (a) abundance, and (b) descent remain open. **C81** —
  characteristic-5/7 Frobenius/subfield gate (run early). **C82** — odd-q orbital/Hollmann–Xiang
  counting, gated on C80's packet. **C83** — the coarsest-bisimulation measurement is done (29 at
  q=11 → 65 at q=13, growing; q=17 deferred, canon-bound): a bounded raw-state automaton is
  unsupported on two points, not excluded. Deprioritized (not
  superseded) behind C84's structural route,
  [report](../2026-07-12-c83-bisimulation-quotient.md). Full specs in the
  [codex task queue](../2026-07-07-codex-task-queue.md).
  The C447/C448 and Weil-roof intake reframes the open target as orbit purity or an equivariant
  opponent-marked response packet, with a bounded q=11 two-match causality gate:
  [`2026-07-22 cap orbit-packet memo`](../2026-07-22-cap-orbit-packet-response-frontier.md).
- **C30 follow-up:** anchored route-C books for q=17/q=19 are emitted and `certcheck` PASS.  The
  generated-checker refactor now compiles the q17/Class0 split sample (`Base`, `Class0Base`, 15
  step-group leaves, and `Class0`). The full v5 tree has 326 node leaves + 326 step leaves;
  representative real timings project above 21.5 h sequential, tripping C30's explicit ~10 h
  user-launch gate. Next is an explicit launch decision or another build-shape reduction, then
  q19 sizing only after q17 is clean.
- **Maintenance follow-up:** from q=23 zero-xor followers, test/prove preservability of
  live-conic xor zero after one further coupled off-conic move, then identify the termination
  invariant.
- **Small-zone follow-up:** turn the repair-mining data into a geometric repair-intruder lemma
  and a small-zone `Z <= 2` / empty-conic base-law certificate schema.
- **Task-amendment / queue-bookkeeping trail (C41–C74, Fable "Nth pass" additions) — settled, archived.**
  The accumulated queue amendments, priority re-orderings, and "queued / reported / gated" bookkeeping
  from 2026-07-09/10 have been moved verbatim to the
  [archive](done/2026-07-08-projective-cap-game-handoff-archive.md).  The operational task IDs remain
  in the [codex task queue](../2026-07-07-codex-task-queue.md); the genuinely-open items are the
  follow-up bullets above and the frontier levers below.

Recently reported:

- **A5 anchor (2026-07-10, Claude) — the most-symmetric on-conic completion is P; a value-blind
  (ON) witness that survives the q=11 exception L1 failed on.**  On-conic child values are
  Stab(frame)-invariant (full-PGL bridge), so the `q−4` children split into Stab-orbits.
  **Measured (all classes, q=11/13/17/19): the smallest Stab(frame)-orbit is P — 8/8, 12/12, 21/21,
  27/27; no frame-fixed on-conic point is ever N (0 N-singletons).**  At depleted orders the smallest
  orbit is always unique: q=17 knife-edge (onP=1) → the P child IS the frame-fixed singleton `Px1`
  (`Nx4·Nx4·Nx4·Px1`); q=11 knife-edge (onP=2, `|Stab|=D10`) → P = the size-2 orbit, N = the size-5
  orbit — **exactly where C73's L1 picks an N conic point and fails, this anchor does not.**  So
  A5's (ON) target gets a single uniform value-blind existence witness with **no separate exception
  layer** at the selector level (min-witness ≥ |smallest orbit| ≥ 1).  Sharpens C68b's "P =
  rare/special" into "special = smallest orbit = largest point-stabilizer = most symmetric completion."
  **Dominates C73's L1:** L1's on-conic pick lies in the smallest orbit wherever L1 works (q=17 21/21,
  q=13 12/12, q=5/7), and their ONLY genuine disagreements are exactly q=11 cls 4/7 (L1's failures) —
  the anchor is L1's fix, a strict generalization.  **But the obvious proof mechanism is REFUTED:**
  "P ⟺ point-stabilizer has a mirror involution" is *inverted* across the depleted orders — at q=17
  the P singleton's point-stab (order 4) has an involution; at q=11 the P orbit's point-stab is order
  5 (odd, none) and the N children carry the involution.  So P-ness is NOT static-symmetric (same
  flip/control failure that killed C64/C69, here on the mechanism); the anchor is a value-blind
  *selector* that tells the Cluster-2 reply-strategy machinery WHICH on-conic child to certify, not a
  symmetry *proof* of P.  **Reshaped A5:** feed the smallest-orbit child to the C61-successor
  existential-selector / amortized-potential lane; a proof must not lean on a point-stab involution;
  q=29 (gated) is the only remaining predictive test.  **Caveats:** measured not proved (only {11,17}
  discriminate); NOT the round-1-refuted bucket-level "specialness ⇒ P" (different object — the q=11
  8/8 confirms it).  **(a′) cert-structure probe (`a5_cert_structure.py` on the C12 reply-book
  certs):** the emitted P-certificate is **adaptive, never a pairing** — pure-fn / fpf-involution /
  node-0-matching all False at EVERY class both orders (sink replies absorb many moves), corroborating
  the mechanism refutation from the winning strategy itself (steers the proof to the amortized route,
  not a mirror).  **Knife-edge signature:** the smallest-orbit/extremal child's book is ~2× more
  concentrated (node-0 distinct replies 21–25 vs 39–54 generic, fan-in 13–14 vs 5–11) — the forced P
  child has the tightest reply structure, a handle for the C61 forced-reply-automaton lane at the
  extremal classes.  Report:
  [`../2026-07-10-a5-symmetric-completion-anchor.md`](../2026-07-10-a5-symmetric-completion-anchor.md);
  scripts `rust/scripts/a5_exception_orbits.py`, `rust/scripts/a5_cert_structure.py`.
- **q=29 census SIZING (2026-07-10, Claude) — the next-depleted-order hunt is a real, gated
  campaign; no cheap shortcut exists.**  With q=25 non-depleted, the observed depleted set is still
  just `{11,17}` and the depletion reports confirm **no residue predicts it** (mod 3 killed by C29;
  mod 6 fails — 5,23,25 ≡ 5 mod 6 are non-depleted, 11,17 ≡ 5 mod 6 deplete), and the arc-census
  gives arc *size* spectra, not a game-depletion predictor.  So extending the depleted subsequence
  past q=17 requires either the A5 arithmetic proof (non-gated research) or a direct q=29 census.
  Sizing (`gridcap-arena s4bucketlist 29`, pure group theory, seconds): **42 on-conic buckets**
  (vs 28 at q=25); fiber histogram `35¹ 70¹ 140³ 210⁵ 420¹⁹ 840¹³` — the **13 fiber-840 buckets are
  the generic (small-Stab) big-tree cases**, like q=25's size-720 generics.  Total on-conic states
  `C(28,4)=20,475` (1.93× q=25's `C(24,4)=10,626`).  Extrapolating the largest bucket's distinct
  positions from q=25's 257.2M as q⁴–q⁵: **~460–540M** ⇒ **~16 GB RAM (`--log2 30`) for the biggest
  generics — over the current ~8 GB working budget** (needs a 16 GB arena or `s4xormine` per-bucket
  splitting).  Projected **total wall ~15–25 h single-core** (vs q=25's 6.67 h), dominated by the 13
  fiber-840 generics.  Verdict: exceeds both the 8 GB RAM and the 8 h wall that C44 used for q=25 —
  an **explicit user gate is required**; the run is decision-informative either way (depleted extends
  the subsequence past {11,17}; non-depleted keeps {11,17} the entire corpus and pushes weight onto
  the A5 arithmetic proof).  Bucket list: `notes/data/c44-q29-onconic-buckets-sizing.txt` (42 rows).
- **q=25 on-conic census COMPLETE (2026-07-10, Claude) — all 28 buckets P; not arc-depleted.**
  Supersedes the mid-census entry below with the final result: the `s4arena --all --log2 29` run
  finished all 26 remaining buckets (2–27), **28/28 P, 0 N, 0 aborted**, ~6.67 h summed bucket wall
  time (largest bucket 257.2M positions, idx 3 `[1,2,5,11]`).  `D(25)=0`, `min-witness(25)=q−4=21`
  (full, not just `≥4`), `ν(25)=0`.  The R7 row is fully resolved: `f_10=f_14=f_16=f_17=P`
  (`R7=21`, all-P) — cross-validates the C74 dichotomy analysis below independently.  q=25 joins the
  non-depleted set `{5,7,9,13,19,23,25}`; the C68 `2 → 1 → ?` slide across `{11,17}` rebounds fully
  rather than continuing toward 0.  Per C74 §6, with the census complete and all-P, "non-depleted ∧
  L-fails" is confirmed logically impossible — the concurrence-point ESC test (C73 §7 step 0) is
  left un-run as moot (would need new coordinate-translation tooling for zero decision value at this
  order); L's stress test now waits for the next genuinely depleted order past q=17.  Reports:
  [`../2026-07-09-codex-q25-baer-census.md`](../2026-07-09-codex-q25-baer-census.md),
  [`../2026-07-09-codex-depletion-fraction.md`](../2026-07-09-codex-depletion-fraction.md) (q=25
  row added), [`../2026-07-10-codex-a5-nbucket-density.md`](../2026-07-10-codex-a5-nbucket-density.md)
  (`ν(25)=0` added).  Data: `notes/data/c68b-onconic-buckets-q25.txt` (28 rows).

The remaining 2026-07-09/10 "Recently reported" bullets and the interleaved Codex/Claude session
handoff notes (the C29/C31/C32/C33/C35–C39/C41/C42/C50/C54/C58/C59/C62/C63/C65/C68–C74 iteration
logs, the q=17/q=19/q=23/q=25 mining passes, and the certificate-book emission logs) are settled
session history and have been moved verbatim to the
[archive](done/2026-07-08-projective-cap-game-handoff-archive.md).  Load-bearing residue that still
shapes the frontier:

- **Configuration-mechanism dichotomy — CLOSED, no static config→value dictionary found.**  C55
  (group-side d-lattice), C64 (extremal-side completion poset), and C69 (algebraic-geometry-side
  Segre envelope) all returned NEGATIVE on the tested families, as did the Ψ dynamic flip/control
  probe; recorded as "no *static* config→value dictionary **found**" (not proven nonexistent),
  mechanism search de-prioritized in favor of A5, with the re-entry condition and full detail in the
  archive.  Reports: [C55](../2026-07-09-codex-d-lattice-side-switch.md),
  [C64](../2026-07-09-codex-completion-poset.md), [C69](../2026-07-10-codex-envelope-invariants.md),
  [Ψ dynamic probe](../2026-07-10-psi-dynamic-flip-probe.md).
- **Scalar / value-blind selector families — uniform-negative, now explained by C75 (2026-07-11).**
  The C61 reply-automaton, C62 selector-library scoring, and C63 amortized-potential LP/dual (the
  integer ledger `Ψ = reservoir_slack + 6·defect_components − 4·selected_intruders − 2·[conic_xor=0]`),
  together with the C70/C71 collision/transition charge work, each found every pointwise selector
  family uniform-negative; C75's feature-completeness result (Handoff Notes, 2026-07-11) is the
  structural reason.  Ψ remains the Cluster-2 amortized/ledger lever (c).  Reports:
  [C62](../2026-07-09-codex-selector-library-scoring.md),
  [C63](../2026-07-09-codex-potential-lp-dual.md), [C61](../2026-07-09-codex-reply-automaton.md),
  [C70](../2026-07-10-codex-c70-collision-charge.md), [C71](../2026-07-10-codex-c71-third-intruder.md).
- **q=25 round-2 / C73–C74 capacity family — resolved by the completed q=25 census (28/28 P, above).**
  The L(A) secant algebra (2026-07-10 C74 capacity family), the C73 value-blind secant packet, the
  round-2 kill-set / (L_forall) umbrella, and the q=25 R7-decider mid-census entry are all closed by
  the completed census; full detail archived.  Reports:
  [C74 capacity](../2026-07-10-codex-c74-capacity-family.md),
  [C73 packet](../2026-07-10-codex-c73-secant-packet.md),
  [round-2](../2026-07-10-codex-odd-plane-round2-report.md).

Good Lean side targets:

- q=9 terminal-reply kernel or certificate assembly.
- q=17/q=19 certificate route after C30 generation.
- S4 two-ply conic-depletion incidence lemma in the normalized grid model.
- Incidence/load reservoir lemma in the normalized grid model: a legal `k`-cell position leaves
  at least `q - k - binom(k,2) - 1` legal off-conic cells in each unused row/column.  Use the
  six-cell `q - 22` instance as base-layer move availability for q>=23 re-steering, not as a
  Hall/matching or recursive-zone certificate.
- Capacity-mirror obstruction lemma for line-capacity games: a mirror reply can fail only on
  slack-1 mirror-pair lines; use this to state exactly why affine/projective mirrors diverge.
- Residual-capacity decomposition: saturated lines kill points, slack-1 lines create graph
  conflicts, slack-2 lines are the remaining genuine cap/Nofil constraints.
- formal one-pair descent / second-intrusion lemmas using the C31 steering data.

## Literature / Framing

The game is Nofil / impartial hypergraph avoidance in the sense of Huggan--Huntemann--Stevens when
the geometry gives a Steiner triple system (`AG(n,3)`, `PG(n,2)`).  For `q > 2`, projective lines
have more than three points, so our projective game is Nofil on the **collinearity-triple
hypergraph**, not on the projective line design.

A useful broader superclass for importing ideas from non-attacking queens is **line-capacity
avoidance**: points plus distinguished line families plus capacities `|S ∩ L| <= c(L)`.  Queens is
the capacity-1, four-direction affine-grid case; affine/projective cap is the capacity-2,
all-line finite-geometry case.  This justifies transferring reservoir, symmetry, and conflict-graph
heuristics while keeping the key distinction clear: queens is pairwise graph independence, while
cap/Nofil is triple-avoidance whose legal moves depend on pairs already selected.

Position this conservatively in CGT: line-capacity games are not a new ambient game class.  Given
lines `L` and capacities `c(L)`, replace each line by the forbidden hyperedges
`T subset L` with `|T| = c(L)+1`; this is Sieben-style impartial hypergraph
building-avoidance.  The capacity-1 case is Node-Kayles on the conflict graph, and the legal
positions are also a simplicial complex / strong-placement-game legal complex.  Our contribution is
the structured incidence-geometric subtheory: residual slacks, mirror obstructions, fixed-locus
blocking, local capacity collapse to conflict graphs, and the resulting affine/projective/queen
mechanisms.

Adopted proof vocabulary from this framing:

- **Capacity-mirror obstruction:** if `S` is mirror-invariant and a legal move `x` has mirror
  partner `sigma x`, then the mirror reply fails exactly on lines containing both `x` and
  `sigma x` whose residual capacity is already `1`.  For cap games this means a mirror-pair line
  already contains one old selected point.  This is the invariant version of the C27 mirror-chord
  obstruction.
- **Fixed-locus caution:** fixed points must be illegal, but that alone is not enough.  The way a
  fixed locus is blocked must not leave slack-1 mirror-pair lines everywhere.  In projective planes,
  selecting a center can ruin homology-style mirrors because many `x, sigma x` chords pass through
  it.
- **Residual-capacity decomposition:** after a partial cap, old secants are capacity-0 blockers,
  lines through one old point are capacity-1 graph conflicts among future moves, and lines through
  no old point are the remaining capacity-2/triple constraints.  Any collapse into a
  capacity-1/Node-Kayles conflict graph must be local to a residual subboard such as the live conic;
  a whole-board collapse is impossible in odd affine planes.  To block every affine line requires a
  blocking set of size at least `2q - 1`, while an odd-q cap has size at most `q + 1`, so genuine
  capacity-2 lines permanently survive.
- **Line-load/slack counting:** use the incidence matrix viewpoint to prove reservoir lemmas and
  finite-field existence statements.  The normalized row/column bound
  `q - k - binom(k,2) - 1` is the first clean example; its six-cell `q - 22` instance is a
  base-layer move-availability fact for q>=23.

Do not prioritize a full capacity-`c` research branch or a broad Lean `LineCapacityGame`
abstraction yet.  The 2026-07-09 vet
([`../2026-07-09-line-capacity-framing-vet-extensions.md`](../2026-07-09-line-capacity-framing-vet-extensions.md))
sharpens what is real: the theorem-level content is **two** capacity-general facts, not four tools.
The **capacity-mirror obstruction** is a genuine capacity-independent, load-bearing lemma (its value
is entirely at `c >= 2`; the `c = 1` instance is folklore the queens mirror proofs already use
unnamed).  The **residual-capacity decomposition** is real but capacity-specific — load-bearing
precisely as conic-localization's frame.  **Fixed-locus caution** and **line-load/slack counting**
are guidance / standard incidence counting, not named tools — keep them as prose, drop them as
lemmas.  The transfer is **one-directional (queens -> cap)**, and not all heuristics carry: the
reservoir -> Hall/matching transfer is dead at the cap frontier (`q < 38`).  The highest-value
extension is **E1, the *structured* capacity-degradation proposition** — the cap residual becomes a
mixed-capacity game whose live conic collapses to Möbius-involution matchings (degree `<= 2` ->
Dawson's chess) and can never complete globally (blocking-set bound); the bare collapse
`Nofil = Node-Kayles` is HHS-published, so only the *structured* form is claimable, as D3's formal
preamble.

Novelty guard:

- Do not claim a new general class of impartial games.  Claim a structured finite-incidence
  subfamily of known hypergraph building-avoidance / legal-complex frameworks.
- Nofil, Node-Kayles, pairing strategies, and projective involutions are prior art.
- The apparently new contribution is the projective-family outcome theorem in this shared
  impartial game, plus the line-capacity mirror/slack analysis tying the projective cap and queens
  mechanisms together.
- Colored finite-geometry tic-tac-toe / avoidance is adjacent but not the same game.
- Abstract wording: say "structured *subfamily*," not "framework"; qualify the `c = 1` case with the
  grid's geometric line families — bare capacity-1 is coextensive with all of Node-Kayles.
- The bare hypergraph-collapse-to-graph fact (`Nofil = Node-Kayles` on a saturated residual) is HHS
  prior art; only the *structured* collapse is a claimable contribution.
- Additional adjacent prior art to cite (verify each): Sieben's impartial-hypergraph-game taxonomy;
  the general-position achievement game on graphs; impartial avoidance on convex geometries;
  Arc-Kayles generalizations.

References:

- [`../2026-07-07-nofil-connection.md`](../2026-07-07-nofil-connection.md)
- [`../2026-07-08-codex-projective-nofil-novelty-audit.md`](../2026-07-08-codex-projective-nofil-novelty-audit.md)
- [`../2026-07-09-line-capacity-framing-vet-extensions.md`](../2026-07-09-line-capacity-framing-vet-extensions.md)

## Handoff Notes

Dated session/finding notes live in the companion archive (append-only), **not here** — this live doc
is the current-state map only; load-bearing residue is condensed in the Near-Term Queue digest above
and in the [codex task queue](../2026-07-07-codex-task-queue.md). Recent notes, newest first, in
[`done/2026-07-08-projective-cap-game-handoff-archive.md`](done/2026-07-08-projective-cap-game-handoff-archive.md):

- C77 — amortized-bank "debt growth" is a reservoir bookkeeping artifact; the conic ledger
  `6·defect − 4·intruders − 2·[xor]` is now proved root-peak-bounded at all depths for every odd q.
  Its `q−5` is not A5's `maxonN≤q−5`: the former is value-blind live-vertex cardinality, the latter
  is exactly the game-value escape claim. The game-semantic continuation merges with C74: maximum
  pencils satisfy computed `Ncenters≤q−8` through q=19 (tight q=17), and the q=11 knife-edge P
  centers have four exact perfect-matching reply-graph types. A value-blind two-stage packet now
  isolates the signal: choose the maximum (`min d`) line, then all centers through the fourth-lowest
  off-conic support; every packet has ≥3 P centers, while q17 non-maximum controls fail 1332/1344.
  The support has the exact five-spoke formula `zone_v=q²−15q+34+Σδ_e−t`, so `Low4` is a bounded
  product-collision packet. Identical collision types can be P or N; proving this packet contains P
  is the remaining uniform game-semantic theorem. A sharper subtype `(d,5,5,6,6)` is P in all 760
  exact q11/13/17/19 occurrences and exists on every tested prime-field maximum pencil for q11–31,
  but extension fields expose two subfield branches. In the exact `d=4` normal form
  `A={0,±1,±x}`, the four rational balanced candidates fail at characteristic-5 `x=±2` and
  characteristic-7 `x∈{±2,±3}` (confirmed again in GF125/GF343). The refined route is the finite
  rational equality case split, balanced-center P-purity, and separate small-subfield game lemmas.
  The d4 equality split is now proved: the displayed characteristic-5/7 families are exactly the
  empty-selector cases over every odd field.
  The d=5 geometry is now a twelve-certificate ledger: four exact label-pairing identities prove
  `n1≤4`; a three-orbit pole argument proves `T≥10`; three factored merge identities prove legal
  degree `≤2`. The seven target orbits and five singleton-pair orbits are now fully factored,
  including the genuine characteristic-3 weight-two singleton family. This proves `F≤3`, hence at
  least two balanced centers on every maximum d5 pencil. Generic balanced-center existence is now
  closed for d4 and d5; only the characteristic-5/7 exceptional game branches and P-purity remain.
  Simple affine mirroring is closed-negative at q11: none of 32 balanced roots has even a root-safe
  affine involution. Full-grid orbit/residual audits also close finite-template and component
  decomposition: balanced-orbit counts grow and every conflict graph is connected with surviving
  triple constraints. The q11 base compresses to two winning-reply types and one universal 33-edge
  losing-pair graph. At q17 five of six coarse balanced types have degree-one moves and the forced
  replies already span 24 S6 grid-orbits, so general P-purity needs a genuinely adaptive algebraic
  reply law, not density or a small template library. Exact marked conic-involution coordinates
  separate every forced q11/q17 reply from the full controls (`24/24`, `192/192`), but the
  q-independent multiplicity quotient and every simple extremal reduction fail; this supplies a
  coordinate system, not a selector, and closes further static-signature mining.
  A user-requested mixed-feature reopening found a sharper contextual target: the five new reply
  directions `D_y` plus residual conflict-edge change `ΔE` separate every forced q11/q17 reply;
  at fixed S5 even `ΔE mod 3` suffices. The identity `ΔE=-R_y+A_y` now yields an exact
  field-label-free form: reply-pencil load residues plus old-secant incidence miss one q17 twin,
  and the Boolean triple-quotient collision `Q3(y)` separates it. With the implicit S5
  parallel/quotient spectrum this is locally unique and globally P-pure `192/192` (q11 `24/24`).
  It is still contextual (182 forced types), so the proof-shaped residue is an algebraic incidence
  case split rather than a static selector table.
  A descendant-only exact solver closes the scope through q19: all q13 balanced orbits have minimum
  winning degree 2 and all 85 q19 orbits have minimum 43–55, so leaves occur only at depleted
  q11/q17. For any P root minimum degree is automatically at least one; forced replies are exactly
  equality cases in that bound.
  C79 broadens the proof search to number-theoretic forcing. Global common-torus closure is refuted
  by noncommuting q11/q17 repair triples, and character/Jacobi pencil classifiers still hit the
  fingerprint wall. The live arithmetic target is instead a counted algebraic packet with a
  structural P certificate: at q17 score 9, every transition has four primitive split/nonsplit
  candidates and the unique maximum-edge zone is clean/P. That zone is one 9-vertex graph whose
  Grundy-zero value is now Lean-checked. In 24/28 rows it is also the unique reply in primitive
  order-`q+1` orbital relation to all three prior intruders; four rows form an explicit exceptional
  orbital fiber. Use conic-stabilizer cross-ratio intersection numbers to count a new generic reply
  packet, then prove descent separately. Distinct old intruder involutions have disjoint live-conic
  edge sets (their possible common chord is killed by the two selected centers) and cannot literally
  be retired while the conic is large; the structural gate is a bulk
  quotient absorbing many active matchings while the reply packet sees only bounded guards. The rule fails below score 9; use Frobenius/subfield descent for
  characteristic 5/7. The exact odd-q orbital coordinate is
  `D_x(y)=(2-rv-cu)^2-4(rc-1)(uv-1)`; its square class is simultaneously the line-conic type and
  split/nonsplit product-involution type. Pairwise orbital/Rédei counts are exactly the second
  spectral moment of `B=sum P_sigma`; this explains their redundancy. On the 24 generic score-9
  rows minimum `tr(B^2)` ties the clean repair with one decoy and `tr(B^3)` breaks the tie; no
  moment rule through `tr(B^4)` covers the four exceptional rows, so moments stay audit language
  and the bulk mechanism moves to the game-side probes (C80–C82).
  `Low4` remains the uniform fallback.
- C75 — value-blind reply selector impossibility (feature-completeness wall; re-weights toward the
  amortized/ledger potential).
- arc-depletion arithmetic probe — no arc invariant fits `{11,17}`; only a twin-lower-prime rule fits
  (flagged suspect, falsifiable at q=47/53).
- 2026-07-10 Codex/Claude notes (C30 build-sizing, C44 bucket cross-check, C55/C64/C69
  config-mechanism closes, C61/C62/C63 selector iteration, Fable steering corrections, PG(4,3) doc sync).

## Archive

Historical play-by-play and superseded planning are archived here:

- [`done/2026-07-08-projective-cap-game-handoff-archive.md`](done/2026-07-08-projective-cap-game-handoff-archive.md)

That archive includes:

- early solver plan and first deliverables;
- initial proof attacks;
- the full 2026-07-05 through 2026-07-08 session chronology;
- dead routes and how they died;
- detailed notes on q=5/q=7/q=9/q=11/q=13 certificate progress.

Read the archive when reconstructing how a conclusion was reached.  For current work, start here.
