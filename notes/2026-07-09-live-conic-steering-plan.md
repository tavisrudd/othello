# Live-Conic Steering Plan for q >= 23

Date: 2026-07-09.

## Why This Exists

The S4 two-ply conic-depletion bound changes the large-q target.

For a normalized S4 root on the affine conic `r*c = 1`, root-reply rows through
`q = 9, 11, 13, 17, 19, 23, 25` satisfy:

```text
two off-conic moves:      live_on >= max(0, q - 19)
one off + one on-conic:   live_on >= max(0, q - 13)
two on-conic moves:       live_on =  q - 7
```

So `q = 17` and `q = 19` are boundary cases where two off-conic moves can empty
the live affine conic at the S4 reply layer.  For `q >= 23`, this route is
closed: a root reply cannot prove the position by simply burning the conic down
to zero live parameters.

The large-q proof route must therefore steer positions with a positive live
conic residual.

## Steering Target

The immediate target is:

```text
Given a P-valued S4 root and an opponent first move x,
find a reply y such that the follower has a P certificate controlled by:

  live conic residual structure
  + off-conic zone structure
  + a bounded defect skeleton

not by live_on = 0.
```

This should be mined first as an existence theorem, not as a deterministic
choice rule.  The right output is a witness table: for each first move, list at
least one P-valued reply and the structural features of the resulting follower.

## Working Hypothesis

An off-conic intruder induces an involution, or partial matching, on the conic
parameter line.  After one or more intrusions, conic-restricted play resembles
Node-Kayles on a union of these matchings.

Important scope correction: a union of matchings is a path/cycle/isolate graph
only at the two-intruder layer.  With `k` intruders the conic graph has maximum
degree `k`.  The first S4 response layer has at most two intruders, so the
current zero-xor first-response work may use the path/cycle description; deeper
maintenance layers already include degree-three and degree-four graphs.

The expected large-q structure is:

```text
bounded-degree conic matching-union bulk
+ bounded defect family
+ coupled off-conic intruder reservoir
```

At the first two-intruder layer, Dawson path values and cycle values are useful
features.  They cannot be the recursive invariant.  The recursive target has to
be a `Good` closure predicate over bounded-degree matching-union signatures,
defects, and legal reply availability.  This is the positive-live replacement
for the q=17/q=19 empty-conic repair picture.

Important correction: the live conic and off-conic zone are not a disjunctive
sum.  A legal off-conic zone move is itself another conic intruder, so it adds
matching edges to the live-conic graph and can delete live conic vertices.  The
proof target is therefore not a separate "preserve the invariant plus prove
termination" track.  The reusable Lean theorem already has the right shape:
`FiniteBuildGame.isP_of_replyStrategy` in `lean/CapGame/BuildGame.lean`.

```text
Good S and opponent plays legal x
    => some legal reply y has Good (S + x + y)
```

Termination is supplied by the finite placement-game recursion in that theorem.
The missing lemma is the recursive controllable-predecessor closure of a
well-chosen `Good` predicate under all move types.

So "live-conic Node-Kayles xor is 0" should be treated as one possible component
of `Good`, not as a standalone game decomposition.  A useful `Good` predicate
will likely combine:

- live conic residual signature/orbit data;
- off-conic intruder and reservoir signature/orbit data;
- a bounded defect skeleton.

The row/column reservoir is a move-availability lemma inside the closure proof.
It is not a Hall/matching certificate for an independent zone game.

Candidate theorem shape:

```text
Every first intrusion from the S4 P-reply-state regime has a reply whose
grandchild residual is:

  even conic bulk
  + one of finitely many defect skeletons
  + a re-steering reservoir for future intrusions.
```

## Tooling To Add

### CEGIS Invariant Synthesis

Use the exact tables proof-directionally: search for a small group-invariant
union of signature/orbit cells that can serve as `Good`.

Loop:

```text
seed candidate Good from P-valued steering followers
check the controllable-predecessor closure:
  for every S in Good
  for every legal opponent move x of every move type
  find at least one legal reply y with S+x+y in Good
if closure fails, emit the counterexample (S, x) and the best rejected replies
refine the signature/orbit partition or Good cells
```

Use q=17 and q=19 as counterexample-rich refinement columns, then freeze the
candidate and validate it at q=23.  Remoteness, suspense, PCA/tree thresholds,
and static classifiers are diagnostics only; they should not displace the
closure check as the main search objective.

### Association-Scheme Response Counts

Before investing further in generic reservoir lower bounds such as `q - 22`,
test the conic-stabilizer association-scheme route on the q=23 closure failures.
Hollmann--Xiang, *Association schemes from the action of PGL(2,q) fixing a
nonsingular conic in PG(2,q)* (arXiv:math/0503573), develop the relevant
PGL(2,q) orbitals/coherent configuration and describe its relations by
cross-ratio.

For each failed closure obligation `(S, x)` from the q=23 one-pair probe:

```text
encode selected intruders and candidate replies as conic-stabilizer orbital data
record the cross-ratio relation type(s) between x, y, and the live conic data
compute observed counts of legal y with S+x+y in candidate Good
compare with the association-scheme intersection numbers for those relations
```

If the relation counts explain the q=23 failures and successes, they become a
plausible exact-count supplement to coarse row/column reservoir counting: a
future proof might show that a response relation has positive intersection
number, not merely that some row contains `q - O(1)` legal cells.

### Best-Reply Rows

Extend `s4mine` with rows that, for each legal first move `x`, scan legal
replies `y` and emit the best known P-valued replies.

Fields should include:

```text
q, root, x, y,
xgeom, ygeom,
xvalue, yvalue,
sel_on, live_on, dead_on,
legal_on, legal_ext, legal_int,
zone size / edge / Grundy fields when available,
defect spectrum / defxor when available,
childZ or steering score when available,
is_min_live, is_max_live,
known/unknown coverage counters.
```

The first version can be value-oriented and conic-oriented only.  It should be
honest about unknown children in capped dumps.

### Conic Residual Graph Rows

Add conic-residual graph features for the live conic parameters:

```text
component count
component sizes
path/cycle/isolated counts when identifiable
degree histogram and small-component canonical type
odd component count
maximum component size
small-component Grundy xor when cheap
number of intruder-generated matchings used
```

For rows with at most two intruders, path/cycle fields have their literal
Dawson/cycle meaning.  For deeper rows, keep general graph features and exact
small-component Node-Kayles values; do not compress the state to path/cycle XOR.
These rows are the bridge from mined correlation to a possible bounded-degree
matching-union lemma.

### Targeted Witness Extractor

For `q = 23` and `q = 25`, prefer targeted witness extraction over blind full
subtree dumps:

```text
for each root bucket
  for each legal first move x
    search replies y until a P-valued witness is found
    log the best conic/zone/defect features seen
    log whether the follower lands in the current candidate Good cell
    if no Good reply exists, emit the closure counterexample
```

This should use existing exact memo dumps when available and mark unknowns
explicitly when a capped dump lacks the needed key.

## q >= 23 Plan

### q = 17 and q = 19

Use q=17 and q=19 as exact CEGIS refinement columns, not as the expected
large-q mechanism.  Their boundary empty-conic repairs are useful because they
produce sharp counterexamples to over-small `Good` candidates.  Keep a candidate
only if it survives all legal move types in these exact tables.

### q = 23

Use q=23 as the first exact large-prime steering column.

Priority:

- mine the existing exact q=23 root dumps with best-reply rows;
- extend to all 22 bucket representatives only where targeted witness
  extraction says the bucket is structurally needed;
- classify first moves by `on/ext/int`, known value, and live-conic residual
  graph after the best P reply;
- validate the frozen q=17/q=19 candidate `Good` by the same all-move closure
  check;
- look for the geometry that makes controllable-predecessor closure true rather
  than a coordinate rule or a static zone matching.

### q = 25

Use q=25 as a shape-first prime-power stress test.

Priority:

- use partial dumps only for coverage-aware geometry rows;
- do not infer P/N values from unknown children;
- add GF(25)-safe geometry features before adding trace/norm/Frobenius labels;
- compare the known q=25 roots to q=23 by residual graph shape, not by raw
  coordinate thresholds.

## Other Layers

The proof should be layered so that the q>=23 live-conic problem is not asked
to solve the entire odd-plane theorem alone.

```text
Layer A: size-3 residual position -> on-conic S4 escape.
Layer B: S4 first-intrusion reply -> positive-live-conic steering.
Layer C: one-pair repair/descent -> small-Z or bounded defect family.
Layer D: deeper conic burn-down -> empty-conic/base leaves after more intruders.
Layer E: finite base laws -> Z <= 2, clean empty-conic, and bounded skeletons.
```

The existing q=13/q=17/q=19 steering data belongs mostly to Layers C and E.
The S4 two-ply depletion bound belongs to Layer B and explains why Layer B must
be different for q>=23.

## What Not To Do

- Do not keep trying to make `live_on = 0` the S4 reply mechanism for q>=23.
- Do not maintain a separate termination track for steering once the target is
  `FiniteBuildGame.isP_of_replyStrategy`; termination is already part of that
  finite-game theorem.
- Do not restart broad q=25 full-bucket sweeps before targeted witness mining
  says which bucket family matters.
- Do not treat PCA/tree thresholds as proof candidates.  Use them to propose
  geometric invariants, then test those invariants directly.
- Do not prioritize remoteness or static classifier mining over the direct
  controllable-predecessor closure check.
- Do not treat q=17/q=19 empty-conic repairs as the expected large-q bulk
  mechanism; they are boundary cases at this layer.

## Immediate Next Actions

1. Add value-aware `BESTREPLY` rows to `s4mine`.  Done in the first tooling pass.
2. Add live-conic residual graph spectrum and Node-Kayles Grundy fields.  Done for `BESTREPLY`,
   `REPLY`, and optional `STATE` rows.
3. Run the new rows against the existing exact q=23 dumps.  First results:
   [`2026-07-09-live-conic-bestreply-mining.md`](2026-07-09-live-conic-bestreply-mining.md).
4. Add targeted zero-xor candidate solving.  Done: the full q=23 S4 bucket layer has a
   zero-conic-xor P reply for every first move.
5. Build candidate `Good` cells as a small group-invariant union of exact-table
   signature/orbit cells, using q=17 and q=19 for counterexamples.
6. Add a CEGIS closure checker: given candidate `Good`, enumerate every legal
   opponent move type and search for a legal reply whose follower is still in
   `Good`; emit `(S, x)` counterexamples and rejected-reply summaries.
7. Add an association-scheme counting probe for the q=23 failed closure
   obligations: classify candidate replies by PGL(2,q) conic-stabilizer
   orbitals/cross-ratio relations and compare observed survivor counts with the
   Hollmann--Xiang intersection-number predictions.
8. Freeze the smallest q=17/q=19 survivor and validate it unchanged on the exact
   q=23 dumps.
9. Use q=25 partial dumps only for coverage-aware shape comparison.
10. Semi-formalize the S4 two-ply depletion lemma in Lean or paper notes.
11. Generalize the depletion count to more intruder layers if the residual graph
   miner shows a stable bounded-defect family.
12. One-pair q=23 maintenance probe: done for bucket representative `1,3,4,9`.  All 259 first
   moves have an existentially chosen zero-xor P follower with complete zero-xor P replies to its
   off-conic zone.  The naive first-P follower rule is false, and cross-bucket coverage plus
   all-move `Good` closure remain open.  See `2026-07-09-live-conic-bestreply-mining.md`.
