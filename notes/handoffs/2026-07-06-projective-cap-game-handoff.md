# Handoff: Projective Cap Achievement Game

Date created: 2026-07-06.  Refactored current-state handoff: 2026-07-08.

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
| all odd q | conjectural P | no counterexample through `q=19`; q=23 has all-P on-conic bucket evidence | strategy-level proof: defect/zone-steering/second-intrusion, not snapshot invariant |

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

**Evidence vacuum:** no even-dimensional odd-`q` board has ever been exactly *solved* — C32 was a
policy probe, not a solve, and PG(3,3)/PG(4,2) belong to closed families.  We have no computational
grounds even for conjecturing PG(4,3)'s value.  **C43** sizes an exact PG(4,3) solve; either
verdict fills this hole, and an N verdict would be the program's first N geometry.

### Classical Varieties (C48 mirror harvest)

The generic fpf-involution mirror lemma is not tied to full projective space; it applies to any
classical variety whose cap game runs on ambient lines.  C48 harvested it (report
[`../2026-07-09-codex-mirror-harvest.md`](../2026-07-09-codex-mirror-harvest.md); generator
`rust/scripts/projcap_mirror_harvest.py`; each board built honestly from its defining form, so
intersection patterns and point counts are verified, not trusted).

- **New family — hyperbolic quadric `Q⁺(2m−1,q)` is P for every odd `q`, every `m ≥ 2`.**  The
  C25 elliptic block map `(aᵢ,bᵢ) ↦ (d·bᵢ, aᵢ)`, `d` nonsquare, is a factor-`d` similarity of
  the hyperbolic form `Σ aᵢbᵢ`, so it preserves the quadric while staying fpf and
  collinearity-preserving (already Lean-proven in `EllipticMirror.lean`).  Machine-verified:
  Q⁺(3,3/5/7) (full C27 pair-extension over every σ-invariant cap + exhaustive solve), Q⁺(5,3)
  (involution + sampled).  `Q⁺(3,q)` is exactly the `(q+1)×(q+1)` capacity-2 rook grid (E1
  vocabulary) and has a second proof by translation mirror `(i,j) ↦ (i+h, j+h)`.
- **Boundary dichotomy for the negatives:** *odd ambient dimension is necessary but not
  sufficient* — the isometry group must also contain an fpf involution.  Mirror-method
  negatives (outcome may still be P by other means): elliptic quadrics `Q⁻(2m−1,q)`
  (anisotropic block blocks the similarity; `O⁻` has no fpf involution), parabolic `Q(2m,q)`
  and Hermitian curves `H(2,q²)` (even ambient dim ⇒ rational fixed point; unital is a blocking
  set), Hermitian surfaces `H(3,q²)` (unitary involutions all have isotropic eigenspaces since
  Hermitian forms are isotropic in dim ≥ 2).  `H(2,9)`/`H(3,4)` compute P regardless, so these
  are *method* boundaries not outcome flips; `Q(4,q)` parabolic is the first open outcome here.
- **Trivial rows flagged:** ovoids `Q⁻(3,q)` are free placement (P by `q²+1`-even parity);
  `H(2,4) = AG(2,3)` (P by the affine theorem, odd point count, not a mirror family).
- **Lean landed:** [`../../lean/ProjectiveCap/HyperbolicQuadricMirror.lean`](../../lean/ProjectiveCap/HyperbolicQuadricMirror.lean)
  (imported from `ProjectiveCap.lean`; builds clean; axiom profile `[propext, Classical.choice,
  Quot.sound]`).  The general proposition is `initialSubCapP_of_fpf_collinearity_preserving`
  (an fpf collinearity-preserving involution preserving a sub-board `Q ⇒ IsP (SubCap Q) ∅` —
  the cap step reuses `mirrorStepGood_of_collinearity_preserving` verbatim, only `Q x → Q (σ x)`
  is new).  The harvested family is `initialSubCapP_blockQuadric_of_odd_card` (`Q⁺(2m−1,q) = P`,
  odd q), via `blockForm_ellipticBlock` (the factor-`δ` similarity) + `onBlockQuadric_map`.
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

## Near-Term Queue

Use [`../2026-07-07-codex-task-queue.md`](../2026-07-07-codex-task-queue.md) as the operational
task list.  Current high-value items:

- **C30 follow-up:** anchored route-C books for q=17/q=19 are emitted and `certcheck` PASS.  The
  generated-checker refactor now compiles the q17/Class0 split sample (`Base`, `Class0Base`, 15
  step-group leaves, and `Class0`); next is a deliberate full q17 generated-data build, then q19
  sizing/user launch.
- **Maintenance follow-up:** from q=23 zero-xor followers, test/prove preservability of
  live-conic xor zero after one further coupled off-conic move, then identify the termination
  invariant.
- **Small-zone follow-up:** turn the repair-mining data into a geometric repair-intruder lemma
  and a small-zone `Z <= 2` / empty-conic base-law certificate schema.
- **Counterexample-readiness additions (Fable, 2026-07-09 second pass):** **C41** trap ⇒ N
  converse in Lean (reported/proved; D1 may use the equivalence); **C42** fixed-q census propagation
  (rescoped same day after the on-conic child type-alignment verdict, then reported **NEGATIVE**
  — no census mechanism; see Recently reported); **C43** PG(4,3)
  exact-solve sizing (the even-dimensional evidence vacuum); **C44** GF(25) path + q=25 Baer
  bucket census (the A4 falsification watch, previously without a task ID; q=25's depletion
  status is now the key covariate).  The former q=23 direct-B3-discharge rider is superseded by
  **C53** (full-PGL bridge — parts 1–2 now a verified Lean theorem, `Sym2Bridge`) and **C54**
  (q=23 bucket-label certification, now reported PASS).  Tier placement is in the queue's
  priority-ordering amendment.
- **Publishable-constraint additions (Fable, 2026-07-09 third pass):** **C45** defect-skeleton
  realizability theorem (dihedral classification of the conic endgame spectra; makes the mined
  even-cycle cancellation and split/elliptic order-dichotomy facts corollaries of one theorem);
  **C46** t-ply conic-depletion inequality ladder (`live_on >= q - c(t)` and the trap ply-depth
  constraint `T(q)`); **C47** minimal-counterexample constraint package (odd-perfect-number-style
  theorem list, gated on C42 — gate since DISCHARGED, C42 negative, so its dichotomy row takes
  the negative branch).  All three publish constraints on the conjecture independent of its
  resolution.
- **Adjacent-publishable additions (Fable, 2026-07-09 fourth pass):** **C48** mirror-theorem
  harvest on classical varieties (the generic fpf-involution Lean lemma applied to hyperbolic
  quadrics / Hermitian curves and surfaces — new P families at lemma-application cost, with the
  trivial-parity boards flagged); **C50** kernel-checked Grundy certificate format (machine-
  verified game-value sequences, newly enabled by C35's nimber oracle); **C49** Node-Kayles
  nimber tables for kings/knights/bishops (D6 siblings, queens box idle time; rooks are
  forced-length parity, the sanity base case).  Priority order C48 > C50 > C49; C35's
  non-decomposition verdict also unblocks C38 with true-nimber data.
- **Dual/isomorphism assessment additions (Fable, 2026-07-09 sixth pass):** **C55** d-lattice
  side-switch diagnostic (Tier B top — a mechanism candidate for the arc-depleted-orders
  dichotomy: the flip pairs 11/13 and 17/19 share a divisor lattice across opposite
  split/elliptic sides, so by Lemma VI the same configuration's defect skeleton genuinely
  differs across the pair; paired-contrast test on the 119 flipping configurations, with a
  falsifiable q=23/q=25 prediction if positive) — **REPORTED 2026-07-10 NEGATIVE** (with C64; see
  Recently reported); **C56** group-indexed cross-q type alignment
  (the C36 retry, gated on a C55 positive — **stays closed-gated, C55 negative**); **C57** zone
  conflict-graph quasi-randomness probe
  (either verdict turns the zone-mining negatives into one structural statement); **C58**
  cap game on the four order-9 projective planes (order vs Desarguesian structure — the one
  spinoff-bridges item with a direct claim on the main program; spec in
  [`2026-07-09-spinoff-bridges-duals-isomorphisms.md`](2026-07-09-spinoff-bridges-duals-isomorphisms.md)).
  Outward-facing spinoffs (code-extension games, SET/sum-free games, games-on-groups, matroid
  and design capacity games) stay in that note, not the queue; the Opus literature/priority
  check on them has REPORTED (revised order F, A, B, C, E, D; D folded into A, E rescoped;
  report: [`../2026-07-09-spinoff-bridges-litcheck.md`](../2026-07-09-spinoff-bridges-litcheck.md)).
- **Broader-sweep additions (Fable, 2026-07-09 seventh pass):** a second category sweep
  (list + spinoff-value table in the spinoff-bridges note §New Candidate Mappings) added
  main-problem tasks per Fable's call: **C59** arc-stability constraint import (Voloch/Ball
  second-largest-complete-arc bounds ⇒ large terminals are conic-contained by theorem; extends
  C46/C47) and **C60** Singer-model circulant probe (the plane as a cyclic difference-set
  board; bounded diagnostic).  Igusa invariants noted in C56 as candidate canonical cross-q
  coordinates; an amortized-potential method note added for the steering/termination lane.
  The sweep's spinoff-only items (no-three-in-line game, Sidon-set games, quantum caps,
  misère siblings, placement complexes, etc.) are in the spinoff note; the second-pass Opus lit
  check on them has REPORTED (same report file; proceed: no-three-in-line, Singer/Sidon,
  quantum caps, positional comparisons; notable import: arXiv:2404.05305 already applies
  hypergraph containers to our collinearity hypergraph).
- **Mathematician-lens sweep (Fable delegate, 2026-07-09):**
  [`../2026-07-09-mathematician-lens-sweep.md`](../2026-07-09-mathematician-lens-sweep.md) —
  six lenses (Tao/Erdős/Conway/Alon/Segre/Lovász), constraint-checked attacks with kill-tests,
  deduped against C55–C60 and the spinoff sweeps.  Top shortlist: Conway reply-automaton over
  (defect spectrum, interface, zone summary) as the falsifiable form of the Good-closure lemma;
  Tao inverted selector search scored on the q=19/q=23 zero-xor corpora; Lovász LP/dual fitting
  of the amortized potential (infeasibility dual = machine-readable impossibility lemma); Erdős
  completion-poset mechanism for the q∈{11,17} flips + the Z(23) measurement.  **Top-5 queued
  2026-07-09 (eighth pass): C61 reply automaton, C62 selector-library scoring, C63 potential
  LP/dual, C64 completion poset (beside C55), C65 Z(23) measurement (Tier A — run first).**
  Near-misses queued for later as **C66/C67/C68** (grid-terminal spectrum, coupling-defect
  spectroscopy, D(q) sequence — gated on post-C61–C65 triage).  The queue now opens with a
  consolidated **CURRENT TOP OF QUEUE** snapshot (ninth pass) that supersedes the amendment
  trail for ordering: C65 first, then the dichotomy cluster (C55/C64→C56) and the open-core
  cluster (C62/C63/C61), with the independent lanes (C30, C43/C44, C58, C59, C50) in parallel.
- **Brainstorm-frame runs (Fable delegates, 2026-07-09/10):**
  (1) [proof-shape census](../2026-07-09-frame-proof-shape-census.md) — survivors: S10
  discharging/unavoidable-set (STRONG; forced lemma = finite steering alphabet; its
  bounded-interface risk is exactly what C65 arbitrates), S11 entropy compression (MEDIUM;
  forced lemma = geometric selector, feeds C62), S9 KSS fixed-point (long shot; verified that
  no published outcome⇔topology bridge exists).  Its proposed "C61" task name collides with
  the queued C61 and substantially overlaps it — merge at triage, do not double-queue.
  (2) [genericity test](../2026-07-10-frame-genericity-test.md) — verdict **STRUCTURAL**:
  PG(2,5)/PG(2,7) are P against 400/400 generic-N matched random boards; P-frequency
  *oscillates in density bands* (the q=9 agreement is band coincidence); a soft/typicality
  proof is ruled out, conic localization is not disposable scaffolding, and C58's evidential
  asymmetry sharpens (order-9 all-P weak, any N doubly informative).  The band discovery also
  warns the Es1 random-sub-board spinoff to measure full retention curves.
  (3) [random-turn/Richman values](../2026-07-10-frame-random-turn-values.md) — the
  protocol-perturbation hope is closed **by theorem**: for impartial normal play, every
  symmetric move-selection protocol is information-free (fair random-turn ≡ 1/2, p-biased ≡ p,
  continuous Richman ≡ 1/2; proved in the report; discrete bidding closed by
  Kant–Larsson–Rai–Upasany EJC 2024), machine-verified on 18.7M positions; PSSW transfer is
  exactly zero (partisan win-set theory).  Salvage: the random-*play* annealed value rho
  contradicts truth at the empty board exactly at q=11 (the first arc-depleted order), and
  **rho-greedy found a winning move at 100% of all 11.8M N-positions across every board**
  while failing (~0.5–0.7%) on random-board controls — a structural selector-candidate law.
  Consequence: the missing potential must be alternation-anchored (amortized/ledger form);
  rho-greedy added to C62's library with an `s4rho` traversal prerequisite (rho is
  tree-defined — a mining selector, not the S11 geometric selector).

Recently reported:

- **C55 (2026-07-10, Claude) — NEGATIVE, the arc-depleted dichotomy has no group-side mechanism.**
  H-side-switch tested on both instruments the task names.  Abstract C18 involution-product
  dictionary: no net directional side-switch (flip net ≈ 0, ≤ control; shared-lattice `d` switch at
  the same rate flip vs control).  Actual legal-intruder secant skeleton (Lemma VI): the split-share
  rise depleted→full is a generic q-effect, identical for flip and control (17/19: +0.044 vs +0.041
  over 100 vs 30 configs), and the within-order test reverses the prediction (q=11 N children secant
  share 0.029 > P's 0.015).  Minimal-witness solve: secant share smooth/monotone in q, no discrete
  signature at the N,P,N,P flips.  No q=23/25 prediction (mechanism dead).  Scripts
  `rust/scripts/c55_side_switch.py`, `c55_intruder_skeleton.py`.  Report:
  [`../2026-07-09-codex-d-lattice-side-switch.md`](../2026-07-09-codex-d-lattice-side-switch.md).
- **C64 (2026-07-10, Claude) — NEGATIVE, the dichotomy has no extremal-side mechanism.**  Full/exact
  completion enumeration (q=11/13 all configs, q=17/19 seeded 40+30 sample, no truncation; validated
  by independent brute-force `is_arc`/`is_maximal`).  No completion-spectrum property (min size,
  count parity, move parity, size-parity availability) is constant-within-{11,17}/{13,19} and
  differs-across while separating flip from control.  The 11/13 count-parity near-miss is a
  small-field artifact (all 11 flips share one spectrum at q=11) that collapses at 17/19.  Structural
  reason: `has_odd = has_even = True` for every config at every order, so the value lives in the full
  game tree, not any coarse terminal (maximal-arc) summary.  Script
  `rust/scripts/c64_completion_poset.py`.  Report:
  [`../2026-07-09-codex-completion-poset.md`](../2026-07-09-codex-completion-poset.md).
  **Consequence (C55 + C64 both negative):** the two direct dichotomy mechanisms are dead; **S1
  (Segre-style envelope invariants) is promoted as C69** — the algebraic-geometry-side candidate
  and the only Cluster-1 lever still standing.
- **C62:** exact selector scoring makes rho-greedy the clear mining order but refutes it as a law:
  `3,144/3,144` q=13 P hits, `1,051,553/1,052,204` q=17, and
  `2,610,869/2,622,214` in the q=19 `[1,2,3,4]` root. Every exact obligation still has some P
  reply with `Delta Psi < 0`, including the q=19 root. The existing 5,734 q=23 zero-xor/live P
  witnesses decrease Psi 95.692% of the time. Polar and character families do not define a clean
  regime; route the localized rho failures and Psi charge to C61. Report:
  [`../2026-07-09-codex-selector-library-scoring.md`](../2026-07-09-codex-selector-library-scoring.md).
- **C63:** exact LP extraction over all q=13/q=17 full-PGL S4 buckets found the integer
  selected-strategy ledger
  `Psi = reservoir_slack + 6*defect_components - 4*selected_intruders - 2*[conic_xor=0]`.
  It strictly decreases on all 3,144 q=13 and 1,052,204 q=17 verified P-to-P reply transitions
  and on C65's q=23 extremal line (`110 -> 30 -> -19 -> -34`).  Held-out replay passes.  Scope:
  the current replies are exact-value/Z-selected, so Psi is the C62 selector-scoring and C61
  charging target, not yet a uniform proved invariant.  Report:
  [`../2026-07-09-codex-potential-lp-dual.md`](../2026-07-09-codex-potential-lp-dual.md).
- **C65:** native recursive steering census gives the honest full-C31 q=23 interval
  `40 <= Z(23) <= 136`.  The complete `[1,2,3,8]` selected corpus has exact max 40; the complete
  maintenance-approved `[1,3,4,9]` corpus has exact max 36; 20 other bucket screens max at 36..39.
  The Z=40 extremum is an immediate repair cost from zone 119 (`live_on=6`, defect spectrum
  `4,1,1`) and descends to child Z=7, then 0.  Route verdict: make the amortized-potential lane
  primary and retain small-Z as its post-repair terminal layer.  Report:
  [`../2026-07-09-codex-z23-measurement.md`](../2026-07-09-codex-z23-measurement.md).
- **C54:** all 22 q=23 full-PGL S4 bucket dumps pass independent rules-only proof-DAG checking:
  `241,627,613/241,627,613` records reached, `988,106,416` legal edges enumerated, zero failures.
  With C53, q=23 is computed and rules-certified at the S4 bucket layer; Lean assembly remains.
- **C29:** mixed-column mod-3 law refuted; q=23 has 22/22 on-conic buckets P.
- **C31:** recursive zone-steering census supports the route; max steering ceiling is 2 at q=13
  and 9 at q=17.
- **C31 follow-up:** every tested q=13/q=17 C20 P reply-state can answer each opponent move with a
  winning reply whose grandchild has `Z <= 2`; q=17 high ceilings are immediate-zone costs.
- **C31 repair mining:** score-9 q=17 repairs are all intruder -> intruder, conic-emptying,
  `defxor = 0`, zone-Grundy-0 moves.
- **Repair geometry mining:** score-9 q=17 repairs are state-level guard intruders: the same
  already-legal internal clean conic-killer answers both worst opponent moves; no single
  line-type/product-order rule explains them.
- **Repair follow-up checks:** score-9 is a two-orbit finite-certificate target; polarity does not
  explain the guard, and empty-conic alone does not imply zone Grundy 0.
- **q=19/q25 mining:** q=19 C20 and steering data are durable in `notes/data/`; q=19 has
  `max Z = 16`.  A Rust `s4` sizing mode shows the ad hoc q=25 probe `[1,2,3,4]` is P at about
  26.3M memo entries, while the first full-PGL canonical bucket representative `[1,2,3,5]` exceeds
  the 100M memo cap.  GF(25) feature mining needs a dedicated prime-power path before broad runs.
  The S4 dump/query manual records the current q=25 partial-dump query workflow and perf profile.
  New `s4xormine --start/--limit` chunking makes q=25 targeted steering feasible in slices:
  `[1,2,3,4]` processed root moves 0..107 with 107 hits before a 50M cap abort, then root moves
  108..167 with 60/60 hits.  All selected q=25 witnesses in these chunks have full unused
  row/column support (`zone_rows = zone_cols = 19`).
- **q>=9 pattern-mining sweep:** the current prioritized mining agenda is
  [`../2026-07-08-q-ge-9-pattern-mining-agenda.md`](../2026-07-08-q-ge-9-pattern-mining-agenda.md).
  It identifies q=17 score-9 guards, q=13/17/19 one-pair descent, q=23 bucket-level mining, q=25
  partial-dump mining, and systematic ply-depth rows as the next useful structure checks.
- **S4 ply-depth tooling:** `s4mine` now supplies the first non-interactive ply-summary layer over
  raw/BuRR S4 dumps.  It reports unknowns explicitly, so capped q=25 runs remain usable for
  geometry/branching without pretending to know child values.
- **S4 conic-depletion lemma candidate:** the ML/joint-summary pass over q=9,11,13,17,19,23,25
  root samples found the two-ply lower bounds
  `off/off >= max(0,q-19)`, `off/on >= max(0,q-13)`, and `on/on = q-7` for live affine-conic
  cells after an S4 root reply.  This is proof-shaped by row/column plus secant incidence counting.
  Consequence: q=17/q=19 are the empty-conic boundary cases, while q>=23 cannot empty the live
  conic at this layer and needs positive-live-conic steering.  Semi-formal proof note:
  [`../2026-07-08-s4-two-ply-conic-depletion.md`](../2026-07-08-s4-two-ply-conic-depletion.md).
- **Live-conic steering plan for q>=23:** the next mining target is value-aware best-reply rows and
  live-conic residual graph features, with q=23 as the exact large-prime column and q=25 as a
  coverage-aware prime-power shape test.  Plan:
  [`../2026-07-09-live-conic-steering-plan.md`](../2026-07-09-live-conic-steering-plan.md).
- **First live-conic best-reply pass:** all q=19 exact buckets and two q=23 exact samples have a
  known P reply for every first move.  q=23 witnesses leave positive conic residuals
  `live_on = 6..12`; all known q=19/q=23/q=25 witness conic graphs are path/cycle/isolate unions
  with `conic_other = 0`.  Added conic-only Node-Kayles summaries show cycle xor is always 0 in
  these rows; the remaining conic residue is path/isolate xor.  Mining note:
  [`../2026-07-09-live-conic-bestreply-mining.md`](../2026-07-09-live-conic-bestreply-mining.md).
- **q=23 zero-xor steering:** new `s4xormine` targeted solving covers all 22 q=23 S4 bucket
  representatives.  Across 5,734 first moves, every one has a P-valued reply with live-conic
  Node-Kayles xor 0; the witness always appears within the first four zero-xor candidates sorted by
  `live_on`.  The witnesses are positive-live (`live_on >= 4`), so the next proof target is the
  maintenance of conic-xor zero under coupled off-conic intruder play.  First zone probe on the q=23 root shows that
  this off-conic legal-zone conflict graph is already one dense component (`zone_v = 100..117`,
  `zone_nk_known = 0`), so the next attack should look for geometric re-steering invariants rather
  than direct full-zone Grundy computation.  The expanded probe shows
  `zone_rows = zone_cols = 17` throughout all q=23 selected witnesses, i.e. the off-conic zone still
  hits every unused row and column after the six selected cells.  Full-bucket expanded sweep:
  5,734 selected P witnesses, all within four zero-xor candidates, with `zone_v = 100..120`,
  `zone_comp = zone_other = 1`, and `zone_nk_known = 0`.  The root-only density cutoff did not
  generalize, and Fable's line-capacity review kills the reservoir->Hall/pairing target: the
  row-bound gives min degree `q - 22`, while a counting-only balanced matching lever needs
  `q >= 38`.  Use the reservoir instead as a base-layer move-availability lemma for re-steering.
  For a legal `k`-cell grid position in the normalized conic graph model, each unused row/column
  has at least `q - k - binom(k,2) - 1` legal off-conic cells; at `k=6` this is `q - 22`, giving
  full unused row/column support for `q >= 23`, but the same loose bound is already vacuous at
  `k=7` when `q=23`.
- **q=23 one-pair maintenance:** bucket representative `1,3,4,9` has now been checked through one
  further coupled off-conic move/reply pair.  The naive first zero-xor P follower is not always
  maintainable, but an existential selector succeeds for all 259 first moves in the bucket.  Its
  accepted followers cover 28,646/28,646 off-conic obligations with P-valued zero-xor replies;
  94.718% of those replies descend to `live_on <= 2`.  This is one bucket only and does not prove
  termination; 1,513 accepted replies retain `live_on = 3..6`.
- **C32 composite mirror probe:** primary point-reflection composite is closed negative.  q=3/5/7
  plane variants are stuck-free, but q=9/11/13 fail for every affine seed; q=9 fails after a
  double-pencil exception breaks later bulk reflection, while q=11/q=13 fail by infinity-reply
  exhaustion after reflected affine play.  PG(4,3) with fixed elliptic `rho` fails the seed
  obligation for all 80 affine seeds.  Report:
  [`../2026-07-08-codex-evendim-composite-mirror.md`](../2026-07-08-codex-evendim-composite-mirror.md).
- **C33 line-capacity follow-up:** Fable's review redirected the q>=23 zone plan.  The
  reservoir->Hall/pairing route is dead below q=38 and should not be pursued at the frontier.
  Zero-xor steering is now a live-conic-xor maintenance problem: prove preservability of a
  re-zeroing reply after coupled off-conic intruder moves, then prove termination in P2's favour.
  The six-cell `q - 22` row/column support lemma is only a base-layer move-availability fact.
  Report: [`../2026-07-09-codex-line-capacity-followup.md`](../2026-07-09-codex-line-capacity-followup.md).
- **C37 shared-key agreement:** raw S4 dump intersections now cross-validate the exact q=19 and
  q=23 bucket corpora.  q=19 has 1,531,020 unique raw keys across 13 roots with 155,219 shared keys;
  q=23 has 217,478,689 unique raw keys across 22 roots with 18,319,494 shared keys; every shared
  key has equal P/N value, and the q=19-vs-q=23 cross-q guard has zero shared keys.  Report:
  [`../2026-07-09-codex-shared-key-agreement.md`](../2026-07-09-codex-shared-key-agreement.md).
- **C36 cross-q type alignment:** depth-2 S4 mining over exact q=17/q=19/q=23 bucket dumps found
  that the intended q-blind coarse shape is still too coarse (one q=19 within-type P/N collision).
  A strict normalized-coordinate type passes self-consistency and has 1,364 shared S5/S6 types
  across at least two q columns, with 281 nonconstant values.  The obstruction is mostly S6 and is
  now tabulated in `rust/s4-dumps/2026-07-09/c36-analysis/nonconstant-strict-types.tsv`.  Report:
  [`../2026-07-09-codex-cross-q-type-alignment.md`](../2026-07-09-codex-cross-q-type-alignment.md).
- **C41 trap converse:** added `ProjectiveCap.TrapConverse` and proved
  `GridGame.TrapConverse.initialPStatement_iff_oddEscapeStatement_finrank`, closing the missing
  trapped-size-3 ⇒ root-N direction.  The proof uses the arbitrary-position frame-grid bridge,
  four-cap transitivity, and `FiniteBuildGame.isP_map`; build and axiom gate pass with only
  `[propext, Classical.choice, Quot.sound]`.  Report:
  [`../2026-07-09-codex-trap-converse.md`](../2026-07-09-codex-trap-converse.md).
- **C35 Grundy oracle / coupling residual:** `s4gdump` now emits exact `u8` Grundy raw dumps,
  `s4gcheck` validates `g=0` against existing P/N raw dumps on shared canonical keys, and
  `s4gmeasure` compares true S5/S6 nimbers with conic and zone Node-Kayles shadows.  Validation
  passed with zero mismatches at q=9/13/17/19.  q=17 root sizing: P/N `64,728` records and `0.18s`
  versus Grundy `186,466` records, `0.84s`, max Grundy `6`; q=19 root Grundy is `2,691,979`
  records in `17.01s`, max Grundy `6`.  The decomposition verdict is negative: conic xor alone
  misses most S6 states, and even where the zone Grundy is computable (`q=13` all sampled states,
  `q=17` subset), `g != g_conic XOR g_zone` on most rows.  Report:
  [`../2026-07-09-codex-nimber-oracle.md`](../2026-07-09-codex-nimber-oracle.md).
- **C38 forced-skeleton distillation:** added `s4gdistill`, an exact raw-Grundy traversal that
  counts winning children at every N node and emits forced-node rows.  Exactness passed with
  `seen == records` and zero missing child values on q=9/q=13 roots, all 10 q=17 full-PGL bucket
  roots, the two q=17 score-9 representative roots, and the q=19 `1,2,3,4` root.  Forced nodes are
  common but not universal: q=17 full bucket corpus has `487,302 / 1,074,873` N nodes forced
  (45.34%); q=19 root has `815,846 / 1,908,007` (42.76%).  q=17 forced nodes concentrate at plies
  7-9 (97.91%), and the two C31 score-9 guard intruders appear as unique conic-emptying internal
  forced replies in the representative roots.  Report:
  [`../2026-07-09-codex-tablebase-distillation.md`](../2026-07-09-codex-tablebase-distillation.md).
- **On-conic child type alignment (size-3→size-4 layer):** within-q value-constancy on exact
  orbits PASSES with zero violations for both the burned-pair stabilizer and full PGL at q ≤ 19
  (reproducing the C5/C15 buckets), but the q-independent finite-type collapse is **refuted**:
  119 shared integral configurations flip value across q, systematically — N exactly at the
  arc-depleted orders q ∈ {11,17}, P at the full orders 13/19.  The on-conic concentration is
  q-driven (arc abundance), not type-driven; no finite type→value table exists.  Full-PGL transport
  is fixed-q only: a solved q gives no cross-q prediction.  C42 is rescoped to the fixed-q
  census/propagation half; the anchor half of the uniform (ON) bound merges into arc-depletion
  arithmetic (falsification-map A5).  Report:
  [`../2026-07-09-onconic-child-type-alignment.md`](../2026-07-09-onconic-child-type-alignment.md).
- **C42 fixed-q census propagation:** the surviving value-free propagation half is also closed
  negative.  Using the same exact stabilizer-orbit machinery over the on-disk feat censuses, every
  all-P q=13/q=19 size-3 class has a distinct full stabilizer-orbit census vector (`12/12` and
  `27/27` distinct vectors).  The onP point masses at those orders are therefore not caused by
  uniform geometry; they hold because every visible stabilizer orbit is P-valued.  At q=11 and
  q=17 the P-count variation is small (`2..5`, `1..3`) but scattered across all P-valued
  stabilizer orbits (`10/10`, `21/21`), with no clean sub-census characterization.  Report:
  [`../2026-07-09-codex-type-census-uniformity.md`](../2026-07-09-codex-type-census-uniformity.md).
- **C30 certificate books:** anchored books are generated and independently rules-checked for
  q=17 and q=19.  q=17: `210/210` PASS, histogram `5:30 10:120 11:60`, all on-conic witnesses,
  no capped books, 111 MB cert.  q=19: `272/272` PASS, histogram `211:272`, all on-conic
  witnesses, no capped books, 863 MB cert.  The original q17 monolithic generated `Class0.lean`
  failed after 31:23 and 11.9 GB RSS, but the refactored split sample now compiles q17/Class0
  through its top module.  Report:
  [`../2026-07-08-codex-route-c-phase5.md`](../2026-07-08-codex-route-c-phase5.md).

Handoff note 2026-07-09 / Codex: added `rust/scripts/projcap_composite_mirror_probe.py`, ran the
C32 plane and PG(4,3) primary checks above, wrote the report, and marked C32 reported in the queue.
Next active queue item is C30 unless the proof lane pivots to the steering/base-law agenda or to a
new, non-primary even-dimensional mirror design.

Handoff note 2026-07-09 / Codex C33: applied Fable's line-capacity corrections to this handoff and
the live-conic notes, re-parsed the existing full q=23 `s4xormine` logs as a first-ply
preservability check (`5734/5734` zero-xor P hits; selected `zone_rows = zone_cols = 17`; no new
solves), and marked C33 reported.  Next proof/mining target in this lane is the one-more-zone-move
maintenance check from q=23 zero-xor followers.

Handoff note 2026-07-09 / Codex C33 one-pair follow-up: extended `s4xormine` with exact maintenance
rows and an existential `--require-maintenance` selector.  The first selected zero-xor P follower
has 3/108 exact failures, refuting the naive selection rule.  A complete 26-chunk census of q=23
bucket `1,3,4,9` found maintainable zero-xor P followers for all 259 first moves, covering
28,646/28,646 selected off-conic obligations with no unknown/cap status and a 22,575,285-entry
maximum chunk memo.  Next: pressure the rule on other buckets and isolate the 1,513 accepted
`live_on = 3..6` residuals; true game-nimber coupling remains the separate C35 measurement.

Handoff note 2026-07-09 / Codex C37: added `rust/scripts/s4_raw_isect.py`, generated the missing 20
q=23 exact raw S4 bucket dumps under `rust/s4-dumps/2026-07-09/c37-q23-raw/`, and ran raw-only
shared-key agreement checks.  q=19 all-bucket: 1,725,015 total records, 1,531,020 unique keys,
155,219 shared keys, zero disagreement keys.  q=23 all-bucket: 241,627,613 total records,
217,478,689 unique keys, 18,319,494 shared keys, zero disagreement keys.  q=19 union versus q=23
union has zero shared keys.  Full pairwise logs are in `rust/s4-dumps/2026-07-09/c37-*.txt`.
At that point the next queue item by Fable's priority was C36.

Handoff note 2026-07-09 / Codex C36: added `rust/scripts/projcap_cross_q_type_alignment.py`,
generated missing q=17 exact S4 bucket dumps under `rust/s4-dumps/2026-07-09/c36-q17-raw/`, mined
45 exact q=17/q=19/q=23 bucket roots to depth 2 under `rust/s4-dumps/2026-07-09/c36-logs/`, and
wrote the C36 report.  Coarse conic-defect + zone shape has one self-consistency collision; strict
normalized-coordinate type has zero self-consistency collisions, 1,364 shared S5/S6 types, and 281
nonconstant cross-q value rows.

Handoff note 2026-07-09 / Codex C35: added exact S4 Grundy dump/check/measure modes to
`notes/2026-07-06-grid-cap-solver.rs`, updated the S4 manual, generated q=9/q=13/q=17/q=19 Grundy
raw roots under `rust/s4-dumps/2026-07-09/c35/`, and wrote
`notes/2026-07-09-codex-nimber-oracle.md`.  The q=17 sizing gate is safe (`186,466` Grundy records,
`0.84s`, `27 MB RSS`, max Grundy `6`; P/N baseline `64,728` records, `0.18s`).  Shared-key
validation has zero P/N mismatches.  The conic⊕zone disjunctive-sum hypothesis is empirically
false at S5/S6: even with fully computable q=13 zone Grundies, `g = g_conic XOR g_zone` fails on
most rows.  This note's original next-step pointer to C41/C42 is now superseded: both have reported.

Handoff note 2026-07-09 / Codex C42: added
`rust/scripts/onconic_census_propagation.py`, generated fixed-q census TSVs under
`rust/s4-dumps/2026-07-09/c42-census/`, and wrote
`notes/2026-07-09-codex-type-census-uniformity.md`.  The P-orbit projection reproduces the
alignment/witness onP histograms exactly, but the full value-free stabilizer census is maximally
non-uniform at the all-P orders (`q=13`: `12/12` distinct vectors; `q=19`: `27/27`).  C42 therefore
closes the fixed-q propagation half negative; the uniform (ON) route now has to engage the
q-dependent arc-depletion arithmetic directly.

Handoff note 2026-07-09 / Codex C41: added `lean/ProjectiveCap/TrapConverse.lean`, imported it from
`lean/ProjectiveCap.lean`, and wrote `notes/2026-07-09-codex-trap-converse.md`.  The new theorem
`GridGame.TrapConverse.initialPStatement_iff_oddEscapeStatement_finrank` proves the rank-three
escape/root-P equivalence both ways; a found residual trap is now a Lean-certified projective
counterexample once its residual game facts are certified.  Verified with
`nix develop --command lake build ProjectiveCap.TrapConverse ProjectiveCap`; axiom gate is exactly
`[propext, Classical.choice, Quot.sound]`.  C48 is currently claimed by Opus; next Codex lanes are
C30 certificate engineering, C43/C44 compute sizing, C50 kernel-checked Grundy certificates, or a
selector-specific split over the C38/C39 S4 artifacts.

Handoff note 2026-07-09 / Codex C38: added native `s4gdistill` to
`notes/2026-07-06-grid-cap-solver.rs`, updated the S4 manual, generated q=17 exact Grundy dumps
for all 10 full-PGL bucket roots plus the two C31 score-9 representatives, and wrote
`notes/2026-07-09-codex-tablebase-distillation.md`.  Exact forced-skeleton traversal passed with
zero missing states/children on q=9/q=13, the q=17 corpus, and q=19 root.  Main numbers:
q=17 full buckets `487,302 / 1,074,873` N nodes forced; q=19 root
`815,846 / 1,908,007`; q=17 forced nodes are 97.91% at plies 7-9.  C39 below completes the
remoteness/suspense follow-up; remaining mining is a selector-specific split over the
`c38-forced/*.forced.rows` / `c39-remoteness/*.remote.out` artifacts.  C50 and C30 remain
independent engineering/proof lanes.

Handoff note 2026-07-09 / Codex C39: added native `s4gremote` to
`notes/2026-07-06-grid-cap-solver.rs`, updated the S4 manual, ran it exactly on q=13 root, all 10
q=17 full-PGL S4 bucket roots, the two q=17 score-9 representatives, and optional q=19 root, and
wrote `notes/2026-07-09-codex-remoteness-probe.md`.  Main result: q=17 full corpus has max
remoteness 10, but only `19,710 / 1,537,648` states have remoteness at least 4 and only 105 attain
10.  Remoteness parity is the expected normal-play tautology (`P` even, `N` odd).  C31-style
`defxor` and zone size stratify average suspense but do not decide value or remoteness.  Verdict:
useful diagnostic, not a standalone dynamic monovariant; next mining should be selector-specific or
return to C30/C43/C44/C50.

Handoff note 2026-07-09 / Claude(Opus) C48: mirror-theorem harvest on classical varieties, all
steps done incl. Lean.  Added `rust/scripts/projcap_mirror_harvest.py` (honest form construction of
each board, exhaustive cap solves, involution + C27 pair-extension gates), wrote
`notes/2026-07-09-codex-mirror-harvest.md`, and landed
`lean/ProjectiveCap/HyperbolicQuadricMirror.lean` (imported from `ProjectiveCap.lean`; built via
`nix develop --command lake build ProjectiveCap.HyperbolicQuadricMirror`; axioms
`[propext, Classical.choice, Quot.sound]`).  New family: **`Q⁺(2m−1,q) = P` for every odd q, every
m ≥ 2** (`initialSubCapP_blockQuadric_of_odd_card`) via the C25 elliptic block mirror, which is a
factor-`δ` similarity of `Σaᵢbᵢ`.  General reusable proposition:
`initialSubCapP_of_fpf_collinearity_preserving` (fpf collinearity-preserving involution preserving a
sub-board ⇒ that cap/Nofil sub-board game is P; cap step reuses
`mirrorStepGood_of_collinearity_preserving` verbatim, only `Q x → Q (σ x)` is new).  Negatives
(mirror fails; outcome may still be P): `Q⁻(2m−1,q)`, `Q(2m,q)`, `H(2,q²)`, `H(3,q²)` — the
isometry group carries no fpf involution (machine witnesses + arguments in the report).  Trivial
rows: ovoids `Q⁻(3,q)` (free placement), `H(2,4)=AG(2,3)`.  See the Classical-Varieties subsection
under Closed Higher-Dimensional Families.  Next Codex/Claude lanes unchanged.

Handoff note 2026-07-10 / Codex C30: emitted anchored q=17 and q=19 Route-C certificate books under
`/tmp/c30-certs/` with `target/gridcap-c30`, then ran independent `certcheck`.  q=17:
`210/210` PASS, `1,009,758` nodes, `2,345,728` rows, escape histogram `5:30 10:120 11:60`, all
on-conic witnesses, no caps; anchored histogram is exactly 10x the canonical `5:3 10:12 11:6`.
q=19: `272/272` PASS, `7,601,462` nodes, `15,354,851` rows, escape histogram `211:272`, all
on-conic witnesses, no caps; full emission took `1:38:13`, peak RSS `867,612 KB`, and certcheck
took `0:09.76`, peak RSS `1,835,428 KB`.  Lean sample generation stayed in `/tmp`: q17 Base
compiled, but q17 `Class0.lean` failed after `31:23.21`, peak RSS `11,914,984 KB`, at
`class0_nodeChunks_check` with `maxRecDepth` in the aggregate chunk `simp`.  No q17/q19 Lean data
was committed.  Next C30 step is to refactor the generated checker proof shape before attempting
q17/q19 Lean assembly; otherwise move to C43/C44/C50 or the steering-proof lanes.

Handoff note 2026-07-10 / Codex C30 Lean split: refactored `ProjectiveCap.CertCheck` and
`notes/2026-07-08-q13-split-to-lean.py` so generated certs use indexed child references
(`RowRefData`/`StepRefData`), one-node semantic step chunks, 10-node subgroup aggregation, and
separate `ClassNBase` / `ClassNStepGroupM` / `ClassN` modules.  Flat q17/Class0 validation under
`/tmp/c30-flat-q17-v9` passed: `Base.lean`, `Class0Base.lean`, all 15 `Class0StepGroup*.lean`
leaves, and the top `Class0.lean` compile with `choom -n 1000 -- lean`; no q17/q19 generated Lean
data was committed.  Next C30 step is full q17 split generation/build with leaves first and
aggregate last; q19 remains a sizing/user-launch decision after q17 is clean.

Handoff note 2026-07-09 / Codex C54: added `s4pncheck`, documented its early-break reply-book
contract, and ran the complete 22-root q=23 suite with `scripts/s4-c54-check-suite.sh`.  Every one
of the `241,627,613` raw records was reached and checked; all 22 P roots passed with zero missing
P-row children, bad terminal labels, value-equation failures, or unreachable records.  Aggregate
wall was `4,077.68s`, peak RSS `371,836 KB`.  Report:
[`../2026-07-09-codex-q23-bucket-certification.md`](../2026-07-09-codex-q23-bucket-certification.md).
Next independent lanes are C43/C44/C50 or the C30 generated-checker refactor.

Handoff note 2026-07-09 / Codex C65: added native `s4zcensus` to the grid-cap solver and its S4
manual, measured the complete q=23 `[1,2,3,8]` selected corpus and complete `[1,3,4,9]`
maintenance-approved corpus, screened 25 seeds in each other bucket, and independently reproduced
the Z=40 extremum with the original Python C31 recursion.  The full-C31 result is deliberately an
interval, `40..136`, because all P replies were not value-enumerated.  The extremum pays immediate
zone 40 but has child Z=7.  Next open-core route is C63 amortized-potential LP/dual (C62 remains the
cheap selector-library precursor); the bounded small-Z route is now terminal-layer support rather
than the primary invariant.

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

2026-07-10 C62 (Codex): added exact `s4selectors` full-expansion traversal, bottom-up random-play
rho, 17 selector families/hybrids, exact P/Delta-Psi tie scoring, and rho failure TSVs. Pure rho is
perfect at q=13 but has 651 q=17 and 11,345 q=19-root value misses, mostly at plies 4--6; no
geometric family improves it or merits a character-sum handoff. Selector-independent decreasing-Psi
existence passes every q=13/q=17 obligation and all 2,622,214 obligations in the exact q=19 root.
The existing q=23 witness logs give 5,487/5,734 strict Psi decreases, but cannot score exact rho
without a full Grundy dump. Next open-core task: C61 on the localized rho failure automaton.

2026-07-10 C63 (Codex): added exact `s4potential` transition extraction and
`s4potentialprobe`, fitted the declared feature span with SciPy/HiGHS, rejected the circular v1
depth-only solution, and obtained the four-term integer Psi candidate above.  Full exact integer
replay has zero failures at q=13/q=17; the q=13-only geometric fit had 71 q=17 transfer failures,
which drove the cross-column refit.  No infeasibility dual was needed, but the script implements
the sparse Farkas certificate path.  Solver checkpoint including the prior C65/C38/C39 diagnostics
was committed as `fd8dc1e`; C63 report/script/manual/queue updates remain the session's follow-up
change.  Next open-core move: score C62 selector families by `Delta Psi < 0`, then use Psi as C61's
state charge if a geometric selector covers every obligation.

2026-07-10 C30 continuation (Codex): anchored q17 Lean closure is no longer the preferred route.
The checker optimizations cut the representative leaf from ~6:55 to ~3:00 but not enough for
210 anchored classes.  Generated/checked canonical q17 instead (`21/21` classes, `100,526` nodes,
`232,221` rows), added Lean coordinate-swap/grid-symmetry composition support, and extended the
split generator with `--assembly-mode canonical`.  The generated canonical assembly stub-checks in
21.8s.  The remaining barrier was `ClassNBase`; moving node-cap proofs into
`ClassNNodeGroup*` leaves made real q17/Class0 timings viable: `Class0Base` 0:53.89,
`Class0NodeGroup0` 0:43.63, `Class0StepGroup14` 2:57.48.  Next: run a leaf-first full q17
canonical build from the v5 split (`Base`, all `Class*Base`, all node/step leaves, class tops,
`Q17`, `Q17Assembly`) and check the final axiom profile.

2026-07-10 C55 + C64 (Claude): closed both direct mechanism candidates for the arc-depleted-orders
dichotomy — the load-bearing unknown of the (ON) route — **both NEGATIVE**, run in parallel while
Codex held Cluster 2 (C62/C63).  C55 (group-side, d-lattice side-switch): added
`rust/scripts/c55_side_switch.py` + `c55_intruder_skeleton.py`; H-side-switch shows no differential
between the 119 flipping configs and matched controls on either the abstract C18 involution-product
dictionary or the actual legal-intruder secant skeleton, and the within-order test reverses the
prediction (q=11 N children carry MORE secants than P).  C64 (extremal-side, completion poset,
delegated + verified): added `rust/scripts/c64_completion_poset.py`; no completion-spectrum property
satisfies the constant-within/differ-across discipline while separating flip from control, and
`has_odd=has_even=True` universally means the value lives in the full tree, not the terminal layer.
Commits `9d2f796` (C55), `185c7a4` (C64).  **Consequence:** C56 stays closed-gated (needed a C55
positive); **S1 (Segre envelope invariants) is promoted as C69** — the algebraic-geometry-side
candidate is now the only Cluster-1 lever standing.  Next Cluster-1 move: C69, which must explain
*why the same integral configuration changes value across q* (the degree of freedom C55's static
group data and C64's terminal-layer data both lacked).

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
