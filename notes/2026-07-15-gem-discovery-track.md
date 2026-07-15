# Discovery track — incidental findings from gap-mining probes

**Lane**: `gem-mining` — see CLAUDE.md § Lane routing.
**Date**: 2026-07-15
**Kind**: append-only log. Never rewrite an entry; supersede it with a later one.

Companion to [the gap-mining method](2026-07-15-gems-theory-gaps-method.md). That doc is the map —
the rules, the ordering, the cell ledger. This is the log of everything the probes turned up that
nobody was looking for.

## Why this exists

The kill order runs cheap computations at small parameters, and every one of them is an object-mining
probe wearing a question-mining hat. But the cell ledger records only whether the *cell* lived, which
tunnels attention onto a binary and discards the byproducts. **A killed cell's computation is not
wasted — only its verdict is.** This log is what makes negative cells productive, and it is the seam
where question-mining feeds back into the object-mining generator that the lane already runs.

The precedent is in-lane and load-bearing: the **bound-shape detector exists only because someone
noticed an incidental anomaly and wrote it down** — the pencil bound is linear in q while the ω_arc
census data look sublinear. Nobody was hunting for that; it fell out of a census run for another
purpose. Without a place to put it, it evaporates.

## The bar

An entry is not "something interesting". Rule 3 of the method applies here too, and it is what keeps
this from silting up into a scrapbook:

**Surprise is relative to a declared null.** An observation qualifies when you can say what you
expected and what you got instead. If you cannot state the expectation it violated, it is a
scrapbook entry, not a finding — leave it out.

Two corollaries:

- A surprise means **your null was wrong**, which is information whether or not the cell it came from
  survived. Log it on kills especially; that is when the tunnel is tightest.
- The entry records the observation, not a theory of it. Explanations are cheap and this log is not
  where they get graded. If an entry grows a claim, it graduates to a report and takes a C-ID.

## Discipline

- **Provenance is mandatory.** Which cell, probe, or script produced it, so it can be re-run.
- **Evidence level on any literature claim**, per the method's ladder.
- **Graduation is explicit.** An entry that becomes real work leaves a pointer to where it went; the
  entry itself stays, since the log is append-only.
- **Ownership.** An entry here is a lead, not a claim. It confers nothing until it graduates.

## Entry format

Append a block per entry, newest last. Every field required; omit none by leaving it blank — say
"unknown" and why.

```
### YYYY-MM-DD — one-line title

**Provenance**: cell / probe / script that produced it, precisely enough to re-run.
**Declared null**: what was expected, and why that would have been unremarkable.
**Observed**: what happened instead.
**Status**: open lead | graduated → <pointer> | retired → <reason>
```

## Log

### 2026-07-14 — the pencil bound's shape does not match the ω_arc data

*Retroactive exemplar. Owned by the handoff's § Open frontiers; recorded here to fix the format, not
to claim the finding.*

**Provenance**: ω_arc census over primes q ≤ 37, run to settle the healthy-arc question, not this one.
**Declared null**: bounds in this area are loose by a constant, and the shape matches the truth.
**Observed**: the pencil bound `(q+3)/2` is linear in q while the census data look sublinear. A bound
whose shape differs from the truth's means the bound's mechanism is not the truth's mechanism — and
the true one has no name.
**Status**: graduated → the bound-shape detector in
[the method](2026-07-15-gems-theory-gaps-method.md) § Internal detectors. The gap itself remains
unexplained and is the handoff's to own.
