# Gem discovery track

**Date opened**: 2026-07-15
**Lane**: `gem-mining` — see CLAUDE.md § Lane routing.
**Mode**: append-only observation log. Never rewrite an entry; supersede it with a later one, or
leave the original with a pointer to where it went.

Sibling of the [Clebsch discovery track](2026-07-14-clebsch-discovery-track.md), same conventions,
different lane — entries do not cross between them. Companion to
[the gap-mining method](2026-07-15-gems-theory-gaps-method.md), which owns the cells and their
ledger.

## What belongs here — and what does not

**Incidental findings only.** This log catches what the probes turned up that **nobody was looking
for**: surprises, failed intuitions, "hmm, interesting" facts, questions raised in passing. Off-target
by definition.

**On-target findings do not belong here.** If it is what the cell was searching for — the verdict, the
computed answer, the thing the probe was built to decide — it goes to the cell ledger and the C-item
report. Putting it here too duplicates ownership and silts the log.

The discriminator, applied per observation: *was I looking for this?* If yes, it is a result. If no,
it is an entry.

**Why the log exists.** The kill order runs cheap computations at small parameters, and each is an
object-mining probe wearing a question-mining hat. The cell ledger records only whether the *cell*
lived, which tunnels attention onto a binary and discards everything to the side of it. **A killed
cell's computation is not wasted — only its verdict is.** This is where the byproducts land, and the
seam where question-mining feeds back into the object generator the lane already runs.

The precedent is in-lane and load-bearing: the **bound-shape detector exists only because someone
noticed an incidental anomaly and wrote it down** — the pencil bound is linear in q while the ω_arc
census data look sublinear. Nobody was hunting for that; it fell out of a census run for another
purpose. Without a place to put it, it evaporates.

## The bar

An entry is not "something interesting". Rule 3 of the method applies here too, and it is what keeps
this from silting up into a scrapbook:

**Surprise is relative to an expectation.** An observation qualifies when you can say what you
expected and what you got instead. For an incidental finding the violated expectation is usually a
background assumption you did not know you were holding — not the probe's declared null, which was
about something else entirely. If you cannot state the expectation, leave it out.

Two corollaries:

- A surprise means an expectation was wrong, which is information whether or not the cell it fell out
  of survived. Log it on kills especially; that is when the tunnel is tightest.
- The entry records the observation, not a theory of it. Explanations are cheap and this log does not
  grade them. If an entry grows a claim, it graduates to a report and takes a C-ID — and the original
  entry stays, with a pointer.

## Discipline

- **Provenance is mandatory.** Which cell, probe, or script produced it, precisely enough to re-run.
- **Evidence level on any literature claim**, per the method's ladder.
- **The strongest question it raises**, classified: **fold into the current cell** | **follow-on** |
  **do not pursue yet**. This preserves the question without letting the log expand scope by itself.
- **This log is not an authority.** Not a task queue, not a proof ledger, not a source for any
  manuscript claim. Promote only after scoping and verification.
- **Everything here is provisional until vetted** by a stronger reasoning model (Fable, or 5.6 Sol).
  Entries are leads, and a lead confers nothing until it graduates.

## Entry format

```
### YYYY-MM-DD — one-line title

**Provenance**: cell / probe / script that produced it, precisely enough to re-run.
**Was I looking for this?**: no — and what the probe was actually after.
**Expectation violated**: the background assumption it broke.
**Observed**: what happened instead.
**Strongest question**: … — fold into current cell | follow-on | do not pursue yet
**Status**: open lead | graduated → <pointer> | retired → <reason>
```

## Log

### 2026-07-14 — the pencil bound's shape does not match the ω_arc data

*Retroactive exemplar. Owned by the handoff's § Open frontiers; recorded here to fix the format, not
to claim the finding.*

**Provenance**: ω_arc census over primes q ≤ 37.
**Was I looking for this?**: no — the census was run to settle which q admit healthy arcs.
**Expectation violated**: that bounds in this area are loose by a constant, and the shape matches.
**Observed**: the pencil bound `(q+3)/2` is linear in q while the census data look sublinear. A bound
whose shape differs from the truth's means the bound's mechanism is not the truth's mechanism — and
the true one has no name.
**Strongest question**: what mechanism actually caps ω_arc, if not the pencil? — follow-on.
**Status**: graduated → the bound-shape detector in
[the method](2026-07-15-gems-theory-gaps-method.md) § Internal detectors. The gap itself remains
unexplained and is the handoff's to own.
