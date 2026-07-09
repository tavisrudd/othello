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
  all 22 full-`PGL(2,23)` on-conic buckets are P, conditional on the orbit-invariance bridge.
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
| 17 | P | `esc` campaign; mixed on-conic buckets; min-escape histogram `5:3 10:12 11:6` | C30 certificate book / no uniform proof |
| 19 | P | `esc` campaign; all low-level escapes | C30 certificate book / no uniform proof |
| 23 | P? | C29 bucket-first full-`PGL(2,23)` on-conic census: all 22 buckets P; old size-3-rooted `esc` class 0 exceeded the 200M memo cap | no Lean theorem; formal orbit bridge/certificate route still open |
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

### Conic Localization

Each residual size-3 position plus the two burned directions gives a projective 5-arc, hence a
unique conic.  In grid coordinates the conic is a Möbius/hyperbola graph.

Key facts:

- the `q-4` remaining on-conic cells are all legal extensions;
- all computed escapes through `q=19` have an on-conic P witness;
- C29's q=23 bucket-first census found all 22 full-`PGL(2,23)` on-conic buckets P;
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
- `s4dump`, `s4freeze`, `s4query`, `s4mine`: exact raw mmap memo dumps, compact BuRR-style
  archives, runtime line-protocol queries, and non-interactive root-child/reply/ply-summary rows
  for S4-rooted pattern mining.  See the manual above before using compact archives for anything
  beyond exploratory mining.
- `rust/scripts/s4_ml_mine.py`: uv-backed parser/ML-style summarizer for `s4mine` logs.  It emits
  feature TSVs, PCA/tree reports, joint geometry summaries, and the current conic-depletion bound
  report under `rust/s4-dumps/<date>/ml/`.

Regenerate cert files on demand; `notes/certs/` is intentionally ignored.

## Near-Term Queue

Use [`../2026-07-07-codex-task-queue.md`](../2026-07-07-codex-task-queue.md) as the operational
task list.  Current high-value items:

- **C30:** route-C certificate books for q=17 and q=19.
- **Maintenance follow-up:** from q=23 zero-xor followers, test/prove preservability of
  live-conic xor zero after one further coupled off-conic move, then identify the termination
  invariant.
- **Small-zone follow-up:** turn the repair-mining data into a geometric repair-intruder lemma
  and a small-zone `Z <= 2` / empty-conic base-law certificate schema.

Recently reported:

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
abstraction yet.  First extract the three reusable lemmas above in paper/notes form and formalize
only the pieces that remove duplication in the current cap proof.

Novelty guard:

- Do not claim a new general class of impartial games.  Claim a structured finite-incidence
  subfamily of known hypergraph building-avoidance / legal-complex frameworks.
- Nofil, Node-Kayles, pairing strategies, and projective involutions are prior art.
- The apparently new contribution is the projective-family outcome theorem in this shared
  impartial game, plus the line-capacity mirror/slack analysis tying the projective cap and queens
  mechanisms together.
- Colored finite-geometry tic-tac-toe / avoidance is adjacent but not the same game.

References:

- [`../2026-07-07-nofil-connection.md`](../2026-07-07-nofil-connection.md)
- [`../2026-07-08-codex-projective-nofil-novelty-audit.md`](../2026-07-08-codex-projective-nofil-novelty-audit.md)

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
