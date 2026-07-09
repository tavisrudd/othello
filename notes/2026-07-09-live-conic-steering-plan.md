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

The expected large-q structure is:

```text
even conic matching/cycle bulk
+ bounded defect family
+ small off-conic zone
```

Even-cycle bulk should cancel.  The value should live in the bounded defect
skeleton and in the remaining off-conic zone.  This is the positive-live
replacement for the q=17/q=19 empty-conic repair picture.

Candidate theorem shape:

```text
Every first intrusion from the S4 P-reply-state regime has a reply whose
grandchild residual is:

  even conic bulk
  + one of finitely many defect skeletons
  + a small-zone certificate leaf.
```

## Tooling To Add

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
odd component count
maximum component size
small-component Grundy xor when cheap
number of intruder-generated matchings used
```

These rows are the bridge from mined correlation to a possible Node-Kayles
lemma.

### Targeted Witness Extractor

For `q = 23` and `q = 25`, prefer targeted witness extraction over blind full
subtree dumps:

```text
for each root bucket
  for each legal first move x
    search replies y until a P-valued witness is found
    log the best conic/zone/defect features seen
```

This should use existing exact memo dumps when available and mark unknowns
explicitly when a capped dump lacks the needed key.

## q >= 23 Plan

### q = 23

Use q=23 as the first exact large-prime steering column.

Priority:

- mine the existing exact q=23 root dumps with best-reply rows;
- extend to all 22 bucket representatives only where targeted witness
  extraction says the bucket is structurally needed;
- classify first moves by `on/ext/int`, known value, and live-conic residual
  graph after the best P reply;
- look for a bounded set of residual graph/zone skeletons rather than a
  coordinate rule.

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
- Do not restart broad q=25 full-bucket sweeps before targeted witness mining
  says which bucket family matters.
- Do not treat PCA/tree thresholds as proof candidates.  Use them to propose
  geometric invariants, then test those invariants directly.
- Do not treat q=17/q=19 empty-conic repairs as the expected large-q bulk
  mechanism; they are boundary cases at this layer.

## Immediate Next Actions

1. Add value-aware `BESTREPLY` rows to `s4mine`.  Done in the first tooling pass.
2. Add live-conic residual graph spectrum and Node-Kayles Grundy fields.  Done for `BESTREPLY`,
   `REPLY`, and optional `STATE` rows.
3. Run the new rows against the existing exact q=23 dumps.  First results:
   [`2026-07-09-live-conic-bestreply-mining.md`](2026-07-09-live-conic-bestreply-mining.md).
4. Run the same rows against q=19 to keep a solved comparison column.
5. Use q=25 partial dumps only for coverage-aware shape comparison.
6. Semi-formalize the S4 two-ply depletion lemma in Lean or paper notes.
7. Generalize the depletion count to more intruder layers if the residual graph
   miner shows a stable bounded-defect family.
