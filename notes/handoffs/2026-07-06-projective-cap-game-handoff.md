# Handoff: Projective Cap Achievement Game

**Lane**: `cap` — see CLAUDE.md § Lane routing.

Date created: 2026-07-06.  Current-state synthesis refreshed: 2026-07-17.

The previous long handoff, including the full chronological session log and superseded planning
notes, was moved intact to
[`done/2026-07-08-projective-cap-game-handoff-archive.md`](done/2026-07-08-projective-cap-game-handoff-archive.md).
Use this file as the canonical current map.

Companion discovery log:
[`2026-07-23 cap discovery track`](../2026-07-23-cap-discovery-track.md).

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

**C553 public-source dependency:** A1/B1 remain approved: delete
`ProjectiveCap.Almost.OddEscape` and `ProjectiveCap.StableFacts`, migrate consumers to the
canonical `GridGame`/`ExtensionCount` APIs without compatibility aliases, and complete the
seventeen-module referee prose/docstring pass. The 2026-07-25 round refreshed the C287 extraction
plan only; no Lean source changed. Arcs, PRS R5--R7, and Clebsch Paper I are locally ready for
later closure intake, while AME--LU C612, C613, and C602 remain the final paper gate before the
coordinated fresh-history extraction. See
[`C553 extraction-preparation refresh`](../2026-07-25-c553-extraction-prep-refresh.md).
For a token-constrained fresh session, use the one-pass module review and scoped validation route
in [`C287 token-efficient extraction execution`](../2026-07-25-c287-token-efficient-execution.md);
do not reload the four paper handoffs while executing C553.

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
task list.  This handoff is the ordering authority; the queue's `cap` rows mirror this expected-value
ranking toward the odd-q all-P crown.

**The C496 recursion-stability probe is RUN — NOT recursion-stable (2026-07-23).** The C496
factorization `value = 1_live ⊗ χ(u)` is a **depth-0 base fact**, not a descent law: exhaustive walk
of the complete P-subtree from the frozen q=11 seed shows the live packet and the `{8,9}`
square/nonsquare `χ`-straddle exist only at depth 0 — at every deeper P-node every opponent move
collapses to `u ∈ {1,∞}` (`χ=+1`/none), so the law has no live rows to govern and the phenomenon does
not recur. Two further blockers to "collapse onto C80(c)": the value-carrying winning replies are
off-conic intruders (4/5 packet cells) while the drain measure is on-conic; and the frozen packet is a
4-cap endgame (≤ 3 exchanges, 26/41 depth-1 nodes terminal) — structurally too shallow to host a
recursion at all. C80(b) is untouched; C80(c) drain stays proven and unused for value.
Report+cert+`--check`: [`../2026-07-23-c496-recursion-stability-probe.md`](../2026-07-23-c496-recursion-stability-probe.md).

**The C496 χ does NOT generalize to the escape family (2026-07-23).** Since the χ-scaffold exists
only at the size-4 escape layer, the only place it could recur is across the escape family (recursion
in `q`). Tested on the complete on-conic S4ARENA bucket census `q∈{11,13,17,19}`: no fixed quadratic
character of the natural 6-arc invariants — square-class pattern, `∏t_i`, the `t4`/6-arc
discriminants, or the **full-PGL cross-ratio multiset (C520's tt#1 resolvent-discriminant object)** —
separates P from N buckets at either discriminating order (q=11 and q=17 are both mixed; q=13/19 are
all-P/vacuous). Verdict `NO_CHARACTER_LAW`. This corroborates the A5 anchor (P = smallest
`Stab(frame)`-orbit, group-theoretic) and constrains C520: the resolvent-discriminant square class
alone does not predict escape-bucket value. Report+cert+`--check`:
[`../2026-07-23-c496-escape-family-character-probe.md`](../2026-07-23-c496-escape-family-character-probe.md).

**Reshaped C80(b) frontier — four dynamic/game-structural attacks planned for a cold session.** Both
character routes are closed (depth recursion; escape-family generalization); the escape-layer value
law is group-theoretic (the A5 **smallest-`Stab(frame)`-orbit selector**, mechanism unproved). The
next attacks abandon static classifiers and treat value dynamically. Full cold-start execution guide —
objectives, exact inputs/scripts, cheap-probe-first steps, decision gates, confidence:
[`../2026-07-23-c80-alt-attack-plan.md`](../2026-07-23-c80-alt-attack-plan.md). In brief, run
cheap-first: **R3** descent into the proven `Y_NK0` guard; **R2** solve the reduced 1-D `P¹`
involution game by Sprague-Grundy and check faithfulness vs the grid census; then **R1** amortized
potential `Φ` = C80(c) drain + Grundy/deficiency term (the C61-successor lane); **R4** (gated) q=29
census to test whether depletion is finite and reshape the theorem to generic + finite exceptions.
Remaining routes are **not yet allocated** — reserve a C-ID when starting one. Depth-1 factorization
rationale:
[`../2026-07-23-c496-bihecke-two-sort-coupling.md`](../2026-07-23-c496-bihecke-two-sort-coupling.md).

**Route 3 is RUN (C522, 2026-07-23) — `Y_NK0` is NOT a complete bulk-descent certificate, and the
companion guard must be a single-live-parameter law, not a second empty-conic packet.** Asked at
the **child** level over **all** legal replies (not just the primitive `Y_0` packet the census
measured): over the frozen three-intruder domain, **q17 has 4,697 / 50,517 (9.3%) children with no
`Y_NK0` reply** (q13: 4 / 1,287). Every gap child is a responder win, so a winning reply always
exists — just outside `Y_NK0`. Decisively, **89% of the q17 gap (4,193 / 4,697) cannot reach an
empty conic in one winning reply**; the easiest winning reply is a **single-live-parameter**
(`live1_capOK`) state for 3,593 of them. This is the same "one live conic parameter before the
reply" object the score-9 mining isolated, now shown **generic** across the whole q17 domain. So
C80(b) needs a **single-live-parameter P-guard** companion. Report+cert+`--check`:
[`../2026-07-23-c522-ynk0-descent-completeness.md`](../2026-07-23-c522-ynk0-descent-completeness.md).

**Companion guard BUILT (C523, 2026-07-23) — `Y_NK` lifts descent coverage 90.7% → 99.3%; the
C80(b) obstruction is now a 349-child capOVER core.** The right guard is not a single-live-parameter
patch but a full generalization: when every capacity-2 line carries ≤2 legal points (**`capOK`**),
the cap residual is exactly **static Node-Kayles on the graph of all legal affine cells** (live conic
cells included as vertices), so P ⟺ full-graph Grundy 0. `Y_NK0` is the empty-conic special case.
Certified: **54,930 `capOK` grandchildren (q13+q17), 0 disagreements**, live sizes 0–4. Coverage:
**q13 100% (1,287/1,287), q17 99.3% (50,168/50,517)**. Residual = **349 q17 children** whose every
winning reply is `capOVER` (a capacity-2 line with ≥3 legal points — the genuine triple semantics);
**323/349 sit at minimal overload 3**. This is the irreducible bulk-descent core and the next
successor target (bounded-overload P-law or finite base case; reserve a new `[cap]` C-ID). The
`capOK ⇒ P iff full-graph Grundy 0` theorem has a proof sketch (a new triple needs 3 legal points on
a capacity-2 line, forbidden by `capOK`) but no Lean statement yet. Report+cert+`--check`:
[`../2026-07-23-c523-ynk-full-graph-guard.md`](../2026-07-23-c523-ynk-full-graph-guard.md).

**q17 descent CLOSED (C524, 2026-07-23) — the 349-child capOVER core certifies by depth-2 descent
into `Y_NK`; 0 states left.** A residual child (responder to move) plays its `capOVER` winning reply
into `G`, and **every** opponent move from `G` is answered into a `Y_NK` (=P) state — a self-contained
two-ply, **minimax-free** certificate given `Y_NK ⟹ P`. All **349/349** certify (q13: 0 residual).
So the entire frozen **q17 three-intruder domain (50,517 children) has a certified responder winning
strategy inside the Node-Kayles guard family** — `Y_NK` at depth 0 (99.3%) or the depth-2 bridge
(0.7%), nothing left to minimax. C80(b) is thus **solved at q17 (and q13)** over the frozen domain,
reduced to a structural object: the `Y_NK` guard + a bounded-depth routing lemma. **q19 confirms it
(1,136,630 children, 95.8% `Y_NK` depth-0, 48,084 residual all depth-2 certified, 0 uncertified)** —
so **depth ≤ 2 closes 100% at q=13,17,19** (computational, not proven). The residual `capOVER` fraction
*grows* (0% → 0.7% → 4.2%), which suggests descent closure is a **combinatorial** phenomenon, NOT a
Weil "generic + finite exceptions" one (Weil belongs to the (ON) abundance / {11,17} P-child-depletion
layer, a different quantity). **Proof status (do not overclaim):** the `Y_NK` guard `capOK ⟹ (P ⟺
full-graph Grundy 0)` now has a written proof — persistence + edge-preservation ⟹ static Node-Kayles —
in [`../2026-07-23-c523-ynk-guard-proof.md`](../2026-07-23-c523-ynk-guard-proof.md), **Fable-reviewed
CORRECT** (lemmas + engine conventions verified in code; holds for even `q` too; Lean pending) —
[`../2026-07-23-c80-descent-fable-review.md`](../2026-07-23-c80-descent-fable-review.md). The
**depth-2 routing is a CONJECTURE** verified only at q=13/17/19; no proof of coverage,
depth-boundedness, or uniformity, and three primes cannot exclude a depth-3 tail at larger `q`.

**C528 decisive step RUN (2026-07-23) — the gadget census is BRANCH (b), sharpened: gadget
complexity is unbounded in `q` on both axes.** The overload-profile tabulation over the frozen
q13/q17/q19 residual children (each is itself `capOVER` — a `capOK` responder-win would have a `Y_NK`
reply) shows: q17 has `g∈1..7` gadgets/state (`max k=4`); **q19 has 100% `g≥3`, mean 19.2, max
`g=47`, `max k=7`.** Both the gadget count `g` and the per-gadget overload `k` grow with `q`, so
**the "`g=1` law + depth-2 corollary" plan is dead and no finite bounded-gadget base family exists.**
The plan's "`g=1` covers ~93%" premise conflated the overload magnitude `k` (small, C523's "minimal
overload 3") with the gadget count `g` (not 1). Depth-2 (C524) still closes 100% at q13/17/19 despite
~19 interacting gadgets/state — so depth-2 is **not** a small-gadget-count effect, which reframes the
crown question as *why a bounded-depth responder beats unbounded static gadget complexity*. A pairing
probe partially answers it: the depth-2 win **is a literal copycat involution** on the even-`|O|` q17
residual core (132/132 perfect matchings), but the **q19 scale-test breaks the clean law** (1,104
even-`|O|` witnesses with no single-level first-witness matching) — so the pairing law is itself a
small-`q` phenomenon, like depth-2. The route survives only with a **witness-selection or multi-level
(persistent) copycat** argument plus odd-`|O|` pairing-plus-one; it still makes the gadget count
irrelevant and is cleaner than the gadget Grundy calculus, but is no longer a cheap win.
Report+cert+`--check`: `../2026-07-23-c528-overload-profile.md`.

**Alt-witness de-risking probe RUN (2026-07-23) — witness selection does NOT rescue single-level
copycat; the pairing route is not a cheap win.** Searching *every* legal responder move for each of the
1,104 q19 first-witness failures, under the correct **legal-reply** pairing graph (edge = a move whose
response is a *legal* reply into `Y_NK`), only **380/1,104 (34%)** are restored by an alternative
depth-2 witness; **724 (66%) have no matchable witness at all**. So single-level copycat is genuinely
insufficient at q19 even with free witness choice — the route needs a **multi-level (persistent)
copycat** (track the copycat across the ≥2 plies, not one witness) plus odd-`|O|` handling, no longer
demonstrably cleaner than the multi-gadget Grundy calculus. The run also reproduces the pairing failure
set exactly (48,084 residual / 22,932 matched / 1,104 failures). **Correctness note:** `is_ynk =
capOK∧Grundy0` accepts non-cap masks, so the pairing probe's `H` (is_ynk-only) admits illegal-reply
edges — under that loose `H` the count spuriously reads "1,104 restored"; the legal-reply `H` is the
sound test. This also **corrects the "132/132 literal copycat" q17 claim above**: under the legal-reply
`H` it is **126/132** (`c528_q17_legal_h_audit.py`, `--check` PASS), so the clean copycat law fails at
q17 too — prior *negative* counts are unaffected (loose `H` edge-superset), only the *positive*
matchings were inflated. Report+cert+`--check`:
`../2026-07-23-c528-alt-witness-probe.md`. Remaining C528 steps (ON-alignment check, gadget law, octal
Piece 3, symmetry reduction, q23 out-of-sample) and the reshaped attack are in
`../2026-07-23-c80-gadget-nk-plan.md`.

**C528 Grundy-by-conic-type census RUN (2026-07-23) — the missed invariant is tiny, but conic type
does not explain it.** Exact full residual SG over every frozen capOVER-core child is bounded by
**5** at both nonempty orders: q17 `1^5 2^26 3^263 4^52 5^3`; q19
`1^20142 2^4629 4^11933 5^11380` (no SG 3), despite q19 `g=3..47`, `k≤7`, and 14–37 legal points.
The two `g=47` states have SG 2. This strongly confirms that C528 had measured static complexity
instead of game value. The proposed shortcut is false: deleting all external gadget constraints
changes SG in **31,871/48,074** q19 states containing them and flips N→P in **8,771**; secant/tangent
counts are not bounded either (q19 maxima 22/7 per state). Because overlapping gadgets are not
disjunctive summands, the per-line number is explicitly a contextual XOR-ablation diagnostic, not
an additive “contribution.” The live target is now Piece 3: explain the whole residual's observed
SG≤5 through Dawson/path-cycle defect skeletons; q23 remains the later out-of-sample falsifier.
The report also harvests four proof-grade statements available now: an exact static rank-≤3
residual-hypergraph theorem, isolated `k`-gadget SG 0, the pair budget
`Σ binom(k_l,2)≤binom(|L|,2)` (hence `g,Φ≤binom(|L|,2)/3`), and the generic SG-height bound
`SG(S)≤q-1-|S|` for odd-plane residuals.
Report+cert+`--check`: `../2026-07-23-c528-grundy-conic-census.md`.
**C547 is complete (2026-07-23): the explanatory residual theorem package is Lean-checked.**
`ProjectiveCap.ResidualHypergraph` proves the exact rank-at-most-three decomposition, minimal
pair/triple obstructions, the no-active-triples static `Y_NK` specialization, generic
valid-card/SG-height and follower-signature bounds, and isolated-gadget SG zero.
`ProjectiveCap.ResidualPairBudget` proves the pair budget, gadget-count, large-gadget, and total
overload bounds, including the requested division forms. The clean-leaf test found the exact first
boundary failure: with two labelled boundary vertices and two ambient conflict leaves, a 3-gadget
has SG 1 while the corresponding 4-gadget has SG 0. The corrected minimal signature retains the
labelled boundary plus private multiplicity `0/1/≥2` and gadget occupancy; the original one-boundary
truncation is the `≥2`-private special case. No uniform `SG≤5` claim is made. The remaining
load-bearing crown is a uniform bound on these corrected boundary signatures in the coupled
projective residual core. Report:
[`../2026-07-23-c547-cap-grundy-proof-harvest.md`](../2026-07-23-c547-cap-grundy-proof-harvest.md).

**C549 is complete (2026-07-23): the private-boundary theorem is true, but its strict hypothesis
compresses none of the frozen coupled cores.** `CapGame.PrivateBoundary` Lean-proves by two-sided
move bisimulation that private multiplicity truncates to `0/1/≥2` plus occupancy under arbitrary
ambient boundary constraints. Exact q17/q19 measurement finds **zero private gadget vertices**:
every gadget vertex has an external pair or triple attachment. The exact label-free rooted-game
quotient grows sharply: per-root follower types `max 10→21`, global child types `21→654`, and root
types `8→2,881`. Hence C547's follower-signature theorem combines conditionally but yields no
q-independent bound here; `SG≤5` must come from mex structure across externally coupled defect
signatures, not private leaves or duplicate labels. No q23 computation was run. Report:
[`../2026-07-23-c549-private-boundary-signatures.md`](../2026-07-23-c549-private-boundary-signatures.md).

**C528 is CLOSED (2026-07-23): exact residual height, not a hidden defect-skeleton law, explains
the frozen `SG≤5` signal.** Exhaustive continuation of all 349 q17 and 48,084 q19 `capOVER` cores
finds maximum remaining game height exactly 5 at both orders, so C547's general `SG≤height` theorem
already proves the observed ceiling. Root heights are q17 `3^205 4^78 5^66` and q19
`4^23684 5^24400`; descendant SG maxima fall `5,4,3,2,1,0` by ply. The attractive q17 refinement
`SG∈{height,height−2}` with parity agreement fails at q19 (13,056 parity violations; gaps 0–4), and
the cheapest local `(triple incidence, pair degree)` move signature is value-impure. Thus no
q-uniform Dawson/gadget calculus is evidenced or needed for this finite ceiling. The crown returns
to C80's direct uniform depth-2 routing theorem into `Y_NK`; q23 remains gated on a candidate
structural law. The `ej` upgrade makes that routing target bounded-incidence: after C524's three
certificate moves, every tested `Y_NK` leaf has height at most two, so P is equivalent to terminality
or a conflict graph with `α=2` and no dominating vertex (equivalently, complement triangle-free with
no isolated vertex). The `tt` form is cleaner: the continuation complex is empty or pure
one-dimensional—every legal move has a mate but no legal triple exists. Preserve the quantifier order
`∃r ∀o ∃p`; these are bounded-arity conditions, not a bounded number of cases, and no Hall/matching
layer is needed. Prove those leaf conditions directly rather than an arbitrary Grundy formula.
Report+certificate:
[`../2026-07-23-c528-mex-skeleton-probe.md`](../2026-07-23-c528-mex-skeleton-probe.md).

**The proposed uniform empty/pure-one-dimensional `capOK` leaf is FALSE (C80, 2026-07-24).**
The C524 three-move leaf is a twelve-cap.  In `PG(2,67)`, secant coverage forces every twelve-cap
to have at least 189 legal points, while point-line incidence plus `capOK` forces at most 135.
Thus no witness choice can yield even `capOK`, before terminality or purity is considered.
More generally, every fixed leaf size fails for sufficiently large `q`; a uniform `Y_NK` route
must have growing depth or use a P-guard that permits active triples.  The exact obstruction is
`capOK` for an `s`-cap implies `q≤binom(s,2)`, giving selected-size floor
`ceil((1+sqrt(1+8q))/2)` and a square-root exchange-depth floor.  The `ej2`
upgrade shows the first forbidden order already forces overload excess `6binom(s,4)` on at least
`binom(s-2,2)` lines (for `s=12,q=67`: excess 2970 on at least 45 lines), so a bounded
active-triple patch is also impossible.  The `ej3`+`tt` greedy-extension upgrade kills every
bounded-dimensional relaxation: every `t`-cap extends when `q≥binom(t,2)`; at `q=97`, every
twelve-cap extends to a fifteen-cap, and for fixed size the guaranteed continuation dimension
grows as `sqrt(2q)`.  The `tt` reformulation supplies the deterministic barrier clock
`δ_q(s)=max(0,q-binom(s,2))`, dropping by `2s+1` per opponent-response exchange: prove
P-preserving survival below the barrier, then `Y_NK` absorption after crossing it.  Report and proof:
[`../2026-07-24-c80-capok-depth-obstruction.md`](../2026-07-24-c80-capok-depth-obstruction.md).

**The secant-barrier survival/absorption split is insufficient as stated (C80, 2026-07-24), but
the exact absorption coordinate is now proved.** `δ_q(s)=0` is necessary for `capOK`, not
sufficient: for every `q=p^(2m+1)`, an additive-subspace parabola cap lies past the barrier while
the line at infinity still carries `q-p^(m+1)+1` legal points. Even post-barrier `capOK` need not
be P: a conic with one point removed has full conflict graph `K₁`. The total overload
`Ω=Σ max(0,|L∩ℓ|-2)` over capacity-two lines is monotone under every move, is zero exactly at
`capOK`, and strictly decreases whenever the mover selects a legal point on an overloaded line.
So geometric absorption is free and does not need the barrier; the missing value theorem is now
exactly a **value-independent survivor family `F`** with `F∩{Ω=0}⊆Y_NK` and a reply back into
`F` with strictly smaller `Ω` after every opponent move (using an overloaded-line reply whenever
the opponent made no progress). Induction on `Ω` would prove P. Without such an `F`,
“P-preserving survival” is circular and equivalent to the desired game result.
Report: [`../2026-07-24-c80-secbarrier-survival-absorption.md`](../2026-07-24-c80-secbarrier-survival-absorption.md).

**The canonical strict-overload kernel is identified and passes the finite escape gate (C80,
2026-07-24), but still needs geometric compression.** Define `K_Ω` well-foundedly from the
`Y_NK` overload-zero boundary by requiring every opponent move to have a reply in a strictly lower
`Ω` layer. This is value-independent, proves `K_Ω⊆P` by induction, and is maximal: every family
satisfying the corrected C80 clauses lies inside it. Exact replay finds `K_Ω=P` on every reachable
fixed-pair residual state at q=5/7, on all 210 raw mixed q=11 escape roots (135 P), and exactly on
the P roots in the frozen size-four q=13/17 escape domains (q17: 5/10, initial overload up to 844).
This validates strict-overload descent
semantically but does not release C82: recursive kernel membership is not an algebraic packet.
The live crown is to compress the q17 response map into an opponent-marked incidence or
residual-hypergraph rule and prove uniform escape-root membership without evaluating `K_Ω`.
Report+script+certificate:
[`../2026-07-24-c80-strict-overload-kernel.md`](../2026-07-24-c80-strict-overload-kernel.md).

**The first opponent-marked incidence compression is extracted (C80, 2026-07-24), but the head
remains open.** The equivariant packet `Rmax(S,o)=argmin_p Ω(S+o+p)` contains a lower-`K_Ω` reply on
all tested q11/q13 certified edges and 16,857/17,355 q17 edges; all 498 q17 failures are at selected
size 4 or 6, while coverage is exact from size 8 onward. One q19 root reproduces the split
(size 4: 116/148; size 6: 7,140/7,423; size 8: 21,743/21,743). Five elementary incidence-maximizing
fallbacks leave twelve q17 transitions, each with a unique lower-kernel reply. The seven-coordinate
marked incidence score has 25 value-mixed collisions, so a q17 lookup table is not a uniform packet.
Next: canonicalize the twelve exceptions under the marked-state stabilizer and prove or falsify an
exchange/orbit-intersection lemma for `Rmax` on a structurally defined bulk family. C82 stays gated.
Report+certificate:
[`../2026-07-24-c80-incidence-packet-compression.md`](../2026-07-24-c80-incidence-packet-compression.md).

**The marked-head quotient and apparent bulk law are now resolved negatively as uniform routes
(C80, 2026-07-24).** The twelve q17 head exceptions form five full conic-`PGL₂(17)` marked
state/opponent/reply orbits; eight records have trivial selected-state stabilizer and every marked
opponent stabilizer is trivial, so transport does not determine the reply. Exact branching from all
10,212 q17 selected-size-eight frontier states through every lower-kernel reply finds no `Rmax`
counterexample, but all 7,090 lower-kernel targets are already `Ω=0`; q19 likewise has only one
positive-target layer at the tested root, then boundary absorption. Restoring the fixed pair makes
the leaf a twelve-cap, so `capOK⇒q≤66` proves this fixed-size absorption cannot be uniform. The only
uniform route must instead use a growing family closed under positive-target exchanges until the
square-root barrier. The boundary-or-retention family in the next bullet is the first such
formulation; the finite data still contain no repeated positive-target layer. Report+certificates:
[`../2026-07-24-c80-marked-head-and-bulk-audit.md`](../2026-07-24-c80-marked-head-and-bulk-audit.md).

**A scale-aware survivor family is now formulated and passes the finite gate (C80,
2026-07-24), while both load-profile extremes are falsified.**  For `0≤α≤1`, the
boundary-or-retention packet admits every `Y_NK` target and every positive strict-overload
target retaining at least an `α` fraction of the maximum available target overload; its
well-founded restricted kernel is `F_α`.  Then `F_α⊆K_Ω⊆P`, the families are nested, and
`F_0=K_Ω`.  Exact Bellman replay gives minimum retention strength `1` at q11/q13 and
`20/51` across the five q17 kernel roots, so `F_{1/4}` contains every tested q11/q13/q17
root.  The q19 out-of-sample root passes 25%, 40%, 50%, and 75% but fails 90%.  In contrast,
fastest total descent, lower overload-vector majorization, slowest total descent, and the
four-coordinate reservoir Pareto family each keep 0/5 q17 roots; upper majorization keeps
1/5.  Unmarked state profiles remain kernel-membership-mixed (48/57 scalar and 120/690
full load profiles).  This is the first growing positive-overload family to survive the finite gate,
but it is still a recursive semantic compression: no q-independent positive lower bound on
retention strength is proved, and the data do not reach the forced `sqrt(q)`-depth regime.
Next prove or falsify `inf_q ρ(S_q)>0` using opponent-marked conic/secant algebra; C82 stays
gated.  Report+script+certificate:
[`../2026-07-24-c80-scale-survivor-falsifiers.md`](../2026-07-24-c80-scale-survivor-falsifiers.md).

**The exact opponent-marked retention inequality is proved, but the q-uniform bound remains open
(C80, 2026-07-25).** For a marked child `C=S+o`, the overload destruction `D_C(p)` of a reply is
exactly the sum of full overload on active lines deactivated through `p` plus the truncated overload
removed on every other active line by the legal points killed on the new secants `pS`. If `d_0` is
the least destruction among strict replies, then retention by `α` is equivalent to
`D_C(p)≤(1-α)Ω(C)+αd_0`. Exact independent replay checks this identity on 219,448 q11/q13/q17 reply
rows. The strongest blanket consequence is false: the q17 DAG contains a positive strict target
with ratio `1/7`, below `1/4`, while its best positive lower-kernel fibre ratio remains `20/51`.
The actual q17 Bellman bottleneck is one size-four marked fibre at root `{6,7,8,14}`; its unique
lower-kernel reply realizes equality at `20/51` and lands in a strength-one target. Thus the live
theorem is not a load bound on all replies but an existential normalized conic/frame exchange class
whose member is lower-kernel and satisfies the destruction inequality, plus persistence through the
forced `sqrt(q)` positive-overload depth. No q-independent positive bound is proved or disproved;
C82 stays gated. Report+script+certificate:
[`../2026-07-25-c80-marked-secant-retention.md`](../2026-07-25-c80-marked-secant-retention.md).

**The natural persistent normalized marked-secant class is falsified at q17 (C80,
2026-07-25).** The complete clocked destruction profile—every active-line
deficiency/thinning multiplicity, marked chord, retention ratio, depth, and
overload clock—has an explicit same-profile P/N collision and its globally safe
classes cover only 608/610 fibres forced to remain at positive overload.
Adding the bounded normalized conic-involution orbital data repairs finite
coverage to 610/610, but produces 79,881 q17 profiles with zero recurrence
between the 513 residual-size-four and 97 residual-size-six forced-positive
fibres. That is a lookup refinement, not an induction class. The next proof
shape must be a cross-depth contraction/renormalization morphism that deletes
or contracts the completed opponent/reply exchange and returns the residual to
a controlled family; do not enrich another static profile. This does not
disprove `inf_q ρ(S_q)>0`, and C82 remains gated. Report+script+certificate:
[`../2026-07-25-c80-marked-secant-profile-persistence.md`](../2026-07-25-c80-marked-secant-profile-persistence.md).

**The canonical forgetful cross-depth morphism is falsified at its first
q17 step (C80, 2026-07-25).** For `T=S+o+p`, the proposed restriction
`Δ(S)|Legal(T)→Δ(T)` is exact iff the exchange creates no new pair conflict
among surviving moves. All 3,798 positive lower-`K_Ω` replies from residual
size four create such a conflict, and every conflicted reply contains a
marked-pencil clique with externally non-twin vertices, so neither projective
relabelling nor collapsing each clique to one move repairs the quotient. Across all 610 forced-positive
fibres, exact forgetful contractions occur only on 65 size-six replies,
covering 51 fibres; the other 559 fibres have none. Thus deletion cannot
initialize the required recursion. A successor must retain the surviving
pair-conflict effect of the marked pencils and compress its accumulated
external incidence; a non-simplicial value argument also remains possible. This does not disprove
`inf_q ρ(S_q)>0`; C82 remains gated. Report+script+certificate:
[`../2026-07-25-c80-exchange-retraction-falsifier.md`](../2026-07-25-c80-exchange-retraction-falsifier.md).

**An exact depth-free residual exchange morphism is proved (C80,
2026-07-25), but finite-dimensional compression remains open.** A state
contracts to its live vertices, load-one pair-conflict blocks, and load-zero
active capacity-two blocks. Selecting a move deletes its pair neighbours,
restricts all blocks, and degrades each active block through the move into a
pair block. This commutes exactly with direct geometric play, hence preserves
the full continuation game; `Ω`, `Y_NK`, `K_Ω`, and `F_α` all factor through
it. Independent direct reconstruction agrees on all 610 q17 marked children
and 3,960 positive reply targets. This is C547's rank-three residual theorem
made dynamic—the existing `deepTransform` object—not a new game class.
Historical pencils need not remain separately labelled; their surviving
pair-conflict union suffices together with the active blocks. The quotient is
bounded-arity, not bounded-size or bounded-dimensional: tested targets still
range over 3–38 vertices, 0–88 pair blocks, and 1–53 active blocks. The live
crown is a q-independent finite-dimensional congruence/follower signature of
this exact transform that makes lower-`K_Ω` response membership nonrecursive;
C82 remains gated. Report+script+certificate:
[`../2026-07-25-c80-residual-exchange-morphism.md`](../2026-07-25-c80-residual-exchange-morphism.md).

**A q-independent finite-state residual congruence is impossible even inside
`Y_NK∩P` (C80, 2026-07-25).** If `A` is a conic subset with
`|A|>(q+3)/2`, every off-conic point is illegal: the conic involution induced
by that point has at most two fixed points, so an unpaired subset has size at
most `(q+3)/2`. The residual is therefore free placement on
`n=q+1-|A|` conic points. For every even `n<(q-1)/2` this is a distinct
height-`n` `Y_NK` P-position, forcing at least
`floor((q-2)/4)+1` exact move-bisimulation classes at one order. Thus no
fixed finite exact follower-game type can encode the residual transform, even
on the proven kernel boundary. This does not rule out finitely many algebraic
coordinates with unbounded values, or a value-only Grundy factor; the conic
family itself is described by the one unbounded coordinate `n` and valued by
parity. The live crown is now a fixed-dimensional unbounded-range algebraic
congruence on the positive-overload response family. Report:
[`../2026-07-25-c80-finite-signature-no-go.md`](../2026-07-25-c80-finite-signature-no-go.md).

**The fixed-dimensional unbounded-range crown is formally positive but
vacuous as stated (C80, 2026-07-25).** Every finite residual object has a
canonical natural-number code, and decode–`D_x`–encode is a q-independent
one-coordinate exact transition law. It preserves the whole continuation
game and therefore all lower-`K_Ω` responses, but stores the complete
incidence object and leaves kernel recognition recursive. Fixed dimension
alone is not an information bound. A meaningful successor must add an
anti-packing gate: for example, fixed-dimensional coordinates and move marks
of polynomial range in `q`, fixed bounded-degree piecewise-polynomial update
formulas, and a fixed nonrecursive decoder for lower-kernel responses. C82
remains gated until that strengthened theorem is fixed and proved. The `ej`
upgrade extracts the first quantitative constraint: if `d` coordinates each
have `O(q^C)` range, exact transition separation forces `Cd≥1`. More
importantly, C80 needs only the sound alternating structure
`∀ opponent ∃ strict-Ω reply`, not full bisimulation. The higher-EV target is
therefore a directly defined ranked survivor `F_q`, with concrete
opponent/reply lifting, together with a structural P boundary packet
`B_q=F_q∩{Ω=0}`. No quotient or deterministic abstract update is required.
The base cannot be an oracle for arbitrary `Y_NK` Grundy zero; it needs its
own uniform copycat/decomposition-style P-proof. The exact residual transform
remains the domain substrate, and the `Cd≥1` bound is only an exact-quotient
diagnostic. Report:
[`../2026-07-25-c80-unbounded-coordinate-congruence.md`](../2026-07-25-c80-unbounded-coordinate-congruence.md).

**The even-faceted algebraic survivor is sound but falsified on every q13
kernel/P escape root (C80, 2026-07-25).** Let the continuation complex have
all maximal faces even, and require hereditarily that after every opponent
move at positive overload some reply strictly lowers `Ω`. This is a genuine
nonrecursive ranked survivor: the overload-zero boundary is P because every
complete play has even length, and the drain property restricts after each
exchange. Exact certificates nevertheless give opposite-parity maximal
continuations for all five q13 kernel/P roots (lengths `6/3`, `4/3`, `6/3`,
`4/3`, `4/3`), independently checked by grid-engine replay and direct affine
determinants. Thus fixed-play parity is false at the roots; pure even rank
and even-rank matroid packets fail a fortiori. The next boundary must expose
an adaptive copycat/decomposition strategy and may ignore losing maximal
branches. C82 remains gated. Report+script+certificate:
[`../2026-07-25-c80-pure-extension-survivor.md`](../2026-07-25-c80-pure-extension-survivor.md).

**The adaptive copycat boundary is a finite positive and removes the Grundy
oracle from the complete q13/q17 strict-kernel DAG (C80, 2026-07-25).**
At `Ω=0`, a persistent nonedge pairing is a copycat certificate when every
other pair survives or is deleted whole after a pair is played. The structural
packet `B_cc` allows either such a pairing immediately or a one-exchange
adaptive shell `∀x∃y` into one. Exact replay finds that every visited `Y_NK`
boundary state has this form: q13 `242` direct + `37` shell; q17 `22,475`
direct + `8,434` shell. The boundary-mask and positive response-map digests
are identical to the prior strict-kernel artifact, so the resulting ranked
survivor still contains all five q13 P roots and exactly the five q17 P roots
while rejecting all five q17 N roots. Independent Node--Kayles replay gives
Grundy zero on all accepted boundary graphs. This closes the finite
boundary-value gate but not the uniform crown: the positive layer still
stores an opponent-complete strict-`Ω` response tree. Next lift the marked
`∀x∃y∃pairing` incidence certificate through positive overload with a
q-independent secant construction; test boundary uniformity beyond q17
before releasing C82. Report+script+certificate:
[`../2026-07-25-c80-adaptive-copycat-survivor.md`](../2026-07-25-c80-adaptive-copycat-survivor.md).

**The structural boundary passes its first q19 test, but the clean
positive-overload pairing lift is false (C80, 2026-07-25).** The previously
certified q19 root `{15,16,17,18}` remains in the strict survivor after
replacing `Y_NK` by `B_cc`, with 23,936 explicit copycat-boundary states.
Define the well-founded positive pairing kernel `M_Ω` by requiring at each
positive rank a perfect strict-reply matching, or a near-perfect matching plus
one adaptive bye, into lower `M_Ω`. This contains all five q13 P roots and
four of five q17 P roots while rejecting all five q17 N roots. The missed P
root `{13,14,15,16}` has 104 legal moves but four isolated marked fibres in
its `M_Ω` reply graph. Their unique old-survivor replies give four size-six
targets with no isolated fibres and matching deficiency two; one more
adaptive exchange reaches `M_Ω`. Thus a two-layer wrapper repairs the finite
root, but matching at every positive rank is closed-negative and no uniform
adaptive depth is evidenced. The live crown is a normalized secant/orbital
contraction of this marked Tutte defect, not another matching packet or
bounded-depth lookup. C82 remains gated. Report+script+certificate:
[`../2026-07-25-c80-positive-pairing-shell.md`](../2026-07-25-c80-positive-pairing-shell.md).

**The marked q17 Tutte defect contracts to one exact normalized type, but
uniform contraction remains open (C80, 2026-07-25).** The missed root's four
isolated strict-reply fibres form one ordered orbit under the Klein-four
stabilizer of `{∞,0,-1,-2,-3,-4}`. Their four exceptional exchanges are
external to the conic, have product-involution order `q+1=18`, and land in
projectively equivalent 32-vertex reply graphs. Each target has the exact
Gallai--Edmonds type `D=14K1⊔K3`, `|A_GE|=13`, `C=K2`; Tutte--Berge certifies
deficiency `15-13=2`, and contraction of the factor-critical components
exposes an incident `13×15` quotient, so one further marked response reaches
`M_Ω`. Thus the finite thread is intrinsically `4→2→0`, not four unrelated
exceptions. The same Klein-four stabilizer occurs at the q13 control, whose
reply graph is perfectly matchable, so symmetry normalizes the defect but
does not explain its game value. The `ej`+`tt` cross-order pass now closes the
obvious uniform orbital lift. The rational orbit has conic discriminant 28:
at q13 its replies are illegal; at q19 it becomes a legal strict secant,
product-order-`q-1` orbit whose target `Ω=152` lies outside `F_cc`. For the
same marked q19 opponent, the first actual strict-survivor reply `(0,2)`
lands at the larger overload `Ω=169` directly in `M_Ω`. Maximum drain and
the fixed orbital class therefore both fail. The next target is a
nonrecursive coupled bank trading overload retention against future
Tutte/pairing structure on the q17 thread and marked q19 control; do not
promote the five-state q17 thread to a depth-two law. C82 stays gated.
Report+script+certificate:
[`../2026-07-25-c80-tutte-defect-contraction.md`](../2026-07-25-c80-tutte-defect-contraction.md).

**The nonrecursive overload-retention/Tutte-excess bank is falsified on the
entire q17 defect thread and marked q19 control (C80, 2026-07-25).** Let
`R_Ω(S)` contain every jointly legal opponent/reply pair giving strict
overload descent, and let `ε_Ω` be its matching deficiency beyond parity.
Every tested raw graph has `ε_Ω=0`. In each of the four q17 exceptional
fibres, a non-survivor at `(Ω,ε_Ω)=(49,0)` strictly dominates the unique
certified repair at `(40,0)`, so every bank increasing in retained overload
and decreasing in raw excess fails. The q19 decoy `(152,0)` and structural
survivor `(169,0)` also have equal excess. The finite q17 target's excess two
appears only after reply edges are filtered by recursive lower-`M_Ω`
membership; using it as a bank coordinate is therefore circular. Moreover,
that filtered graph has no isolated fibre, so Tutte deficiency is stronger
than the actual `∀o∃p` game gate. The next crown is a proof-producing
nonrecursive marked edge predicate, followed by opponent-complete
secant/incidence coverage—not another scalar state bank or matching shell.
C82 stays gated. Report+script+certificate:
[`../2026-07-25-c80-coupled-overload-tutte-bank.md`](../2026-07-25-c80-coupled-overload-tutte-bank.md).

**The marked secant/incidence comparison diagnoses premature N absorption,
not a uniform edge selector (C80, 2026-07-25).** Across the three canonical
spoiling types, all 106 strict candidates are exact N by both the grid solver
and an independent small-tree replay; 105 land at `Ω=0` with Node--Kayles
Grundy 1 or 2, and the unique `Ω=1` target has exactly one P follower.
The 105 boundary values also have a direct proof: each conflict-graph
complement is a linear forest, with no edge giving Grundy 1 and an edge plus
an isolated vertex giving Grundy 2. The reusable theorem needs only a
triangle-free complement and includes the P-side completion: an edge with no
isolated vertices gives Grundy 0, exactly the pure one-dimensional
continuation-complex criterion. Write-up:
[`../2026-07-25-c80-sparse-complement-node-kayles-lemma.md`](../2026-07-25-c80-sparse-complement-node-kayles-lemma.md).
Compared with the four q17 `Ω=40` repairs and q19 `Ω=169` repair, the finite
incidence gap is large: repairs retain 5--8 legal marked-chord points, 32--51
legal points total, and 3--5 live conic parameters, while spoilers retain
2--4, 2--7, and 0--1. More structurally, the repairs have minimum legal-mate
degree 8 at q17 and 17 at q19, while every spoiler has an isolated legal move
(`μ=0`). The complete normalized feature multiset is identical
across the four coordinate copies of each q17 type. Full marked destruction
profiles isolate the five repairs purely in the complete 322-edge natural
comparison, but no conjunction through three predeclared monotone scalar
thresholds is P-pure; the first four-coordinate fits are finite
interpolation, agreeing with the earlier zero-recurrence profile result.
Therefore do not promote a chord/live/overload threshold. The exact next gate
is opponent-complete strict-`Ω`, positive-`μ` closure on the complete
certified q13/q17 DAGs and marked q19 control. On failure extract the first
canonical isolate-creation obstruction; on success seek the field-uniform
incidence proof. C82 remains gated. Report+certificate:
[`../2026-07-25-c80-marked-secant-spoiler-repair-compare.md`](../2026-07-25-c80-marked-secant-spoiler-repair-compare.md).

**Strict-overload positive-mate-surplus closure passes all certified gates
but is globally redundant (C80, 2026-07-25).** The recursively filtered
survivor contains all five q13 P roots, exactly the five q17 P roots, and the
marked q19 control; accepted positive-state counts are 32, 1,839, and 2,501.
However, if `μ(S)` is the minimum legal-mate count, then every positive
`F_cc` state already has `μ(S)≥1` because its defining `∀ opponent ∃ legal
strict reply` clause supplies a mate after every move. Induction on `Ω`
therefore proves the proposed `F_μ` equals `F_cc` at every order. The finite
certificates genuinely hit the floor `μ=1`, so there is no hidden
quantitative margin. This closes `μ` as a new recursive compression: it
diagnoses the repair/spoiler split but cannot serve as the missing
nonrecursive marked-edge predicate. The `ej` follow-up generalizes this to a
quantifier-shadow no-go: any positive-state property obtained merely by
forgetting information from `F_cc`'s `∀x∃y` witness is equally redundant.
The exact C80→C82 interface is now fixed: first construct a direct
secant/orbital edge predicate carrying an algebraically transportable,
lower-ranked proof datum, with soundness independent of lower-survivor
membership. The `ej2` gauge correction adds two release gates: the datum must
have bounded algebraic format and a direct nonrecursive update rather than
encode the whole strategy tree, and C82 must count distinct geometric replies
after projecting/canonically gauging successor proof data—not `(reply,datum)`
representations. The cheapest constructive scout is one
field-parametrized pairing-with-obligations rewrite covering both the q17
Klein-four repair orbit and marked q19 control; this is a proof-object test,
not another scalar/profile census. The `ej3` anti-packing pass sharpens the
datum further: it may not list a `Θ(q)` matching or defect set. It must be a
bounded-formula partial involution with an algebraic exceptional/obligation
locus, and its update must be invariant under alternating-cycle changes of
matching representative. The exact scout is now one bounded-degree
partial-involution schema whose exceptional-orbit rewrite realizes the q17
`4→2→0` thread and the state-dependent q19 direct repair; reject it on any
explicit edge list, coordinate exception table, or matching-gauge
dependence. The `ej4` correction removes an unnecessary selector assumption:
stabilizers may forbid a canonical reply, so the coordinate-free datum is an
equivariant bounded-degree reply correspondence. Its degree-one bulk is the
partial pairing, its ramification/non-degree-one locus is the algebraic
obligation family, and its transport-natural projected fibre degree is the
only intrinsic C82 abundance coordinate. The sharpened falsifier requires
the q17 exceptional orbit and q19 repair to satisfy one correspondence,
exceptional-locus, and rank-update identity commuting with projective
transport. Only after edgewise soundness may C82 prove opponent-complete
projected abundance. C82 remains gated. Report+script+cert:
[`../2026-07-25-c80-positive-mate-surplus-closure.md`](../2026-07-25-c80-positive-mate-surplus-closure.md).

**The first equivariant reply-correspondence scout is cleanly negative
(C80, 2026-07-25).** The live-secant relation admits a strict external reply
when the reply lies on a chord through two conic points still legal after the
exchange. It is a bounded-degree projectively natural incidence formula,
contains all four q17 Klein-four repairs and the q19 control repair, and
commutes exactly with the full order-four stabilizer (`92/92` and `188/188`
transported edges). It is nevertheless value-impure: every q17 marked fibre
has degree 23 with `1 P + 22 N`, and the q19 control has degree 47 with
`39 P + 8 N`. Thus symmetry, normalization, and witness gauge are not the
obstruction; edgewise game soundness is. The unique q17 P edge is the known
repair, so this is an equivariant carrier packet, not a proof-producing
correspondence. The next target is a nonrecursive rank-carrying algebraic
subcorrespondence that cuts out the q17 repair and excludes the eight q19 N
edges without querying minimax or `F_cc`; C82 remains gated. Report+cert:
[`../2026-07-25-c80-equivariant-live-secant-correspondence.md`](../2026-07-25-c80-equivariant-live-secant-correspondence.md).

**The canonical central-involution rank datum is also closed-negative
(C80, 2026-07-25).** For a repair edge `(o,p)`, take the unique central
involution `J=(ι_oι_p)^(ord/2)` of its even conic-product torus and propose
the direct response `x↦J(x)`, carrying selected-set mismatch as an obligation
rank while `Ω` decreases. This datum is formula-defined, anti-gauge, and
commutes exactly with the full stabilizer, but the selected state is not
`J`-invariant. Every q17 repair target has `0/32` usable strict replies
(`0/128` over the orbit); the q19 control has only `4/51`, and those four
oriented edges collapse to two external exchange orbits: an order-two
`Ω=0` N absorber and an order-ten `Ω=1` P target retaining three live conic
points. Rewriting to the P exchange's own central involution still gives
`0/7` usable replies. The `ej2` upgrade nevertheless gives a direct P-proof
of that q19 target: no move is terminal, every move has a terminal reply, and
the six-edge reply graph is `K2` disjoint from a triangle with a length-two
tail. The bad orbit has two terminal moves and is directly N. This terminal
shell does not lift to q17: eight terminal edges cover only `10/32` moves per
repair target. The `ej3` pass shows the q19 graph symmetry is accidental:
its automorphism group has order four but the selected target's
conic-projective stabilizer is trivial. The q17 nonisolated terminal graph is
`K2` plus an eight-vertex tree with degree sequence
`1,1,1,1,1,2,3,4`, accompanied by 22 isolates. Thus the common shape is a
pair seed plus one ramified component, not a bounded state orbital; the
successor must mark exchange history and absorb an algebraic isolate locus
without listing it. Direct projective determinant replay agrees with grid
legality on every response. The central torus element cannot be the proof
datum even locally; C82 remains gated. Report+cert:
[`../2026-07-25-c80-central-involution-rank-datum.md`](../2026-07-25-c80-central-involution-rank-datum.md).

**C551 is complete (2026-07-23): flagship paper packaging is fixed without freezing C528.**
The stable crown-independent thesis is global fixed-point-free incidence symmetry versus residual
capacity degradation. The package now contains the exact theorem/trust ledger, normalized fixed-q
table with separate mathematical and publication-readiness tiers, claim/novelty matrix and audit
queue, classical-variety include/split verdict, notation/exclusion ledgers, and a section-level
Milner/Serre architecture with crown/no-crown variants. The flagship retains the general invariant
subboard theorem plus positive hyperbolic and coordinate-exact elliptic quadric corollaries; the
parabolic/Hermitian/Baer method-boundary classification splits to a companion. Remaining gates are
the uniform corrected-signature/descent theorem, durable normalization of older computations,
referee-facing Lean closure review, and a current-convention literature audit. Package:
[`../2026-07-23-c551-cap-paper-flagship-packaging.md`](../2026-07-23-c551-cap-paper-flagship-packaging.md);
skeleton:
[`../2026-07-23-c551-cap-paper-manuscript-skeleton.md`](../2026-07-23-c551-cap-paper-manuscript-skeleton.md).

**Prior target (context):** the Fable review killed the Φ-potential plan (Φ monotone non-increasing
under all moves ⟹ "drive Φ→0" vacuous) and replaced it with the gadget-Node-Kayles value law
(overloaded capacity-two line = independent `k`-set collapsing to a clique on first touch; induct on
the overload measure, `Y_NK` base case). Also open: Lean statements of both lemmas; C82 countability.
C523/C524 report+cert+`--check` (q13/q17 and a separate q19 cert):
[`../2026-07-23-c524-capover-core-depth2.md`](../2026-07-23-c524-capover-core-depth2.md).

Priority order and why:

1. **C80 (spine).** Everything gates on it. The fixed-depth frontier is closed-negative:
   no twelve-cap can be `capOK` once `q≥67`; generally `capOK` for an `s`-cap forces
   `q≤binom(s,2)`. The secant barrier is only necessary, not sufficient, and even post-barrier
   `capOK` does not force P. Total capacity-two overload `Ω` is the exact absorption clock.
   The canonical maximal strict-overload family `K_Ω` is now defined value-independently from the
   `Y_NK` boundary; well-founded induction proves it P, and exact q=5/7/13/17 gates pass. The live
   first geometric compression `Rmax` is nonuniform beyond q=66, and both overload-vector
   extremes are now closed-negative at q17.  The surviving scale-aware compression is the nested
   boundary-or-retention family `F_α⊆K_Ω`: `F_{1/4}` contains every tested q11/q13/q17 kernel
   root, with exact q17 minimum strength `20/51`, and the q19 probe passes through 75%.
   If `s_even(q)` is the least even `s` with `q≤binom(s,2)`, any escape-root strategy still needs
   at least `(s_even(q)-8)/2` positive-overload response targets before absorption, asymptotic to
   `sqrt(q/2)-4`.  The finite data do not enter that growing-depth regime.  Exact marked-secant
   profiles are now P/N-mixed, while the bounded orbital refinement that covers all q17
   forced-positive fibres has zero cross-depth recurrence. Exact forgetting is false, but the
   depth-free mixed-capacity residual transform is an exact game-tree morphism and absorbs all
   historical pencils into pair-conflict blocks plus active capacity-two blocks. The live theorem
   is now a q-independent finite-dimensional congruence/follower signature of that residual
   transform which preserves the lower-`K_Ω` response structure. A fixed finite exact signature
   is now ruled out: sealed conic subsets already give
   `floor((q-2)/4)+1` distinct P-valued `Y_NK` heights. The exact quotient is only bounded-arity,
   and transporting the recursive kernel through it does not prove membership. The remaining
   unrestricted unbounded-range algebra is now formally trivial: one natural number can encode the
   complete residual and update by decode–`D_x`–encode. The next crown must first fix an
   anti-packing information model. Exact polynomial-range quotients must already carry
   `log q-O(1)` bits (`Cd≥1` for `d` coordinates of `O(q^C)` range), but exact congruence is
   stronger than the crown needs. The Tao-style boundary is now found at the finite gate:
   `B_cc` is the fixed incidence formula “persistent nonedge pairing, or
   `∀x∃y` into one,” and it replaces every visited q13/q17 `Y_NK` leaf exactly.
   The first q19 boundary probe is positive, so `B_cc` itself remains the
   right base. The clean positive matching lift `M_Ω` is closed-negative at
   one q17 P root: four isolated marked fibres descend to four
   Tutte-deficiency-two targets, and a second adaptive exchange repairs the
   finite case. Those four fibres are now one Klein-four orbit, and every
   target has the same exact Gallai--Edmonds type
   `D=14K1⊔K3`, `|A_GE|=13`, `C=K2`, giving a finite intrinsic defect thread
   `4→2→0`. The remaining formulation is a directly defined ranked survivor
   `F_q` realizing the concrete positive-overload `∀o∃p` strict-`Ω`
   induction and landing in `B_cc`. The fixed rational orbital lift is
   closed-negative across q13/q19: at q19 its lower-`Ω` target `152` fails
   even `F_cc`, while a higher-`Ω` target `169` reaches `M_Ω`. The live
   coupled overload-retention/Tutte-excess bank is also closed-negative:
   every tested raw strict-reply graph has excess zero, while the q17 decoys
   retain more overload than the certified repairs. The observed excess two
   is created only by recursively filtering edges through lower `M_Ω`.
   The marked secant comparison now strengthens all 106 canonical spoiling
   candidates to exact N: 105 are `Ω=0` boundaries of Grundy 1 or 2, and the
   unique `Ω=1` target has one P follower. Repairs retain a much larger
   marked-chord, legal-point, and live-conic reservoir, but that finite gap
   does not compress to a low-dimensional monotone rule: no conjunction
   through three predeclared scalar thresholds is P-pure, and the first
   four-coordinate fits are interpolation. The sparse-complement proof
   identifies the diagnostic coordinate
   `μ(S)=min_x |{y:S+x+y legal}|`: repairs have `μ=8` at q17 and `μ=17` at
   q19, while every spoiler has `μ=0`. Its proposed recursive closure passes
   the q13/q17 DAGs and marked q19 control but is globally redundant:
   `F_μ=F_cc`, since the defining `∀ opponent ∃ legal reply` clause already
   forces `μ≥1` at every positive survivor state. The next target is a
   nonrecursive marked secant/orbital edge predicate whose soundness does not
   call lower-survivor membership, followed by opponent-complete incidence
   coverage. No quotient or arbitrary Grundy oracle is required, and the
   five-state q17 thread is not a depth-two law. A value-only factor is also
   not excluded.
   Do not mine another bounded-depth selector, stabilizer signature, bounded-gadget patch,
   terminal guard, unmarked load potential, or feature-only refinement.  Only a uniform
   growing-depth membership proof releases C82.
2. **C82 / C520 (gated on C80).** Abundance for C80's packet; C520 offers a Weil-bound route and a
   resolvent-quadratic depletion predictor whose tt#1 half is testable now on frozen q=13/17/19
   A5-anchor data, ahead of the C80 gate.
3. **C74 / C77 (balanced-packet attack), C81 (independent char-5/7 gate), C13 (q=9).**
4. **C508 — DEPRIORITIZED.** After the C495/C497 negatives it is a diagnostic, not a descent step;
   even a positive is symmetry/case-reduction only unless it improves C80's guard or a measure.
   Revisit only then.
5. **Base cases C189/C198/C199/C200 and the C30 engineering tail** — do not advance the uniform proof.

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
  to count globally.  C80 now has one exact P-preserving guard: if the conic is empty, every
  residual capacity-two line has at most two legal points, and the load-one conflict graph has
  Grundy zero, the continuation is exactly Node--Kayles and hence P.  This `Y_NK0` refinement
  certifies all 620 q13 survivors and 3,048 q17 members (533 and 2,822 transitions), but is sparse:
  it covers only 2,822/59,153 q17 three-intruder transitions.  The 108 q17 `clean_empty` members it
  rejects expose the missing triple semantics (104 P, four N).  C80 must still prove bulk descent
  into `Y_NK0` or add a companion guarded packet before C82 counts globally.
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
- **C495–C497 [cap] — C434 crowns cross-lane transfer probes into C80's open ledger.**
  Fixed run order **C495 → C497 → C496**.  **C495 [REPORTED 2026-07-22 — FALSIFIER NO]:** the q=11
  cloud packet is *not* the C434 `D10` two-sheet space.  C80's single-state 22-move packet has full
  setwise stabilizer exactly `C5` in `PGL_2(11)` (no internal `D10`); the cap-frame `D10` nonsquare
  coset is the inter-state endpoint swap, not an internal sheet; `u`'s square class splits the four
  5-orbits 2–1–1, not the sheet's 2–2, and is not even the `D′` analogue.  The two are isomorphic
  only as `C5`-sets — a fingerprint collision, not a structural identity; C434's fibre identity does
  not transport.  Report `../2026-07-22-c495-cloud-packet-d10-identification.md`.  **C497 [REPORTED
  2026-07-22 — NON-CONSTANT]:** run as an independent q17 stratification test, the
  `(prior-triple stabilizer, reply)` double-coset partition (= `PGL_2(17)`-orbit of the marked
  involution configuration) does *not* refine `Y_NK0`-membership — 249 explicit `PGL_2(17)`-verified
  same-stratum `Y_NK0`/non-`Y_NK0` splits over the exactly-reproduced frozen census (59,153 / 17,954
  / 3,048).  Stratification is refuted as the bulk-descent mechanism (an additive/incidence label
  orthogonal to residual-carried value), so the full P/N sweep is skipped; report
  `../2026-07-22-c497-double-coset-stratum-constancy.md`.  C502's corrected hexad lesson applies
  only at the governing-`C2` level: a small stabilizer-class comparison can detect an external
  orientation swap, but cannot be assumed to detect value.  At q17 any analogue must use the full
  marked residual state, including selected conic content; the centre configuration alone is
  provably insufficient.  **C496 [REPORTED 2026-07-23 — OBSTRUCTION + CORRECTED DESIGN]:** the
  bi-Hecke bimodule `e_K F[G] e_H ≅ F[K\G/H]` is value-blind on the frozen q=11 packet — the two
  incidence-live `C5`-orbits (`u=8→P`, `u=9→N`) have IDENTICAL additive-incidence realizations (same
  5-cycle candidate pentagon), so it sorts the six orbits into 2 incidence classes vs 3 value classes
  and cannot be C80's two-sorted coupling as a single bimodule.  The coupling is a bilinear
  additive×multiplicative (Gauss/Jacobi) pairing separated by the quadratic character
  `χ(u)=Legendre(u)`, orthogonal to the incidence sort; the balanced live Gauss sum
  `5·χ(8)+5·χ(9)=0` is the knife-edge `C2`-torsor calibration.  Reshapes (not closes) C80's
  two-sorted-coupling ledger item — the descent/abundance argument must carry the multiplicative
  character explicitly.  Report `../2026-07-23-c496-bihecke-two-sort-coupling.md`.  **C508 [QUEUED]**
  separately tests whether C497's exact
  q17 1:1 reply-type balance comes from an explicit value-preserving external involution and a
  local full-state detector; a positive gives symmetry/case reduction only unless it improves
  C80's guard or descent measure.  q∈{7,11}-only structure caveat: C497 borrows C434's method, not
  its group structure, at q17.  Provenance: C80 report probe section
  (`../2026-07-12-c80-bulk-exhaustion-probe.md`), transfer note
  `../2026-07-22-c434-c80-cross-lane-transfers.md`, and corrected local-detector theorem
  `../2026-07-22-c502-hexad-outer-bit-exploit.md`.
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
