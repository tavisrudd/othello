# Gem discovery track

**Date opened**: 2026-07-15
**Lane**: `gem-mining` — see CLAUDE.md § Lane routing.
**Mode**: append-only observation log. Never rewrite an entry; supersede it with a later one, or
leave the original with a pointer to where it went.

Sibling of the [Clebsch discovery track](2026-07-14-clebsch-discovery-track.md), same conventions,
different lane — entries do not cross between them. Companion to
[the gap-mining method](2026-07-15-gems-theory-gaps-method.md), which owns the cells and their
ledger. The repository-wide [discovery-track conventions](discovery-track-conventions.md) preserve
this log's “was I looking for this?” boundary while allowing incidental musings that do not arise
from a violated expectation.

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

### 2026-07-15 — zbMATH's `rf:` search reports every paper in mathematics as uncited

**Provenance**: [C191 instrument calibration](2026-07-15-c191-instrument-calibration.py), zbMATH Open
API leg.
**Was I looking for this?**: no — the probe was after Edge 1956's citer list by a non-OpenAlex route.
**Expectation violated**: that a citation query's empty result means "no citations". The background
assumption was that the instrument fails *loudly*.
**Observed**: zbMATH's `rf:` reference search keys on the **internal document id** (`rf:3121304`), not
the Zbl code (`rf:0072.38102`). The Zbl-code form returns `404 / "Entry not found!" / "successful
access. No results found."` — which reads exactly like a genuine empty result. Controlled against
three known-cited seeds: `rf:<Zbl code>` 404s for all, while `an:<Zbl code>` returns 200. **An
uncontrolled `rf:<Zbl code>` sweep reports a clean absence for every paper it is pointed at.**
**Strongest question**: which other citation instruments fail silently-empty rather than loudly, and
has any absence claim in this repo been built on one? — follow-on. **Cross-lane**: this is a tooling
hazard for any lane running literature gates (`clebsch` C146/C167/C169, `relconic` C154,
`repaircodes`), not a gem-mining finding. The mine does not write to other lanes; routing is the
user's.
**Status**: open lead. The general rule — control a citation instrument against a known-cited seed
before believing an empty result — is recorded in
[the method](2026-07-15-gems-theory-gaps-method.md) § Instruments.

### 2026-07-15 — Edge 1956 was cited by four people who were not Edge, and by nobody after 1988

**Provenance**: [C191 instrument calibration](2026-07-15-c191-instrument-calibration.py), all three
index legs.
**Was I looking for this?**: no — the probe was after the *venues* of Edge's citers, to test whether
any was a coding venue. The author field came along for free.
**Expectation violated**: that "seven indexed citers" described seven independent readers. Nobody had
looked at who they were.
**Observed**: three of the seven are **W. L. Edge citing himself** (Camb. Phil. Soc. 1963, Camb. Phil.
Soc. 1975, J. Algebra 1985). The independent citers are at most four people across thirty-two years —
Ostrom (1959, and among the eight authors of the 1962 *Monthly* section bundle), Raber (1975), Garner
(1988), and Segre if an unverified Semantic Scholar stub holds. **The citation record stops at 1988 in
every index.** zbMATH is starkest: of its three citers, two are self-citations, leaving one.
**Strongest question**: the paper was near-orphaned in its *own* field, with its author the main
custodian of its citation record — is that the actual shape of the founding cell's cause, rather than
"invisible to coding"? — fold into current cell (it is now recorded in C191's cell 1 as s4+s2).
**Cross-lane**: bears on `clebsch`'s C146 priority footnote, which argues Edge-vs-Dye priority. A
paper with four independent citers and none after 1988 is a different rhetorical situation than a
well-known one; the footnote may want the fact. Not routed — `clebsch`'s call.
**Status**: open lead.

### 2026-07-15 — a coding literature has been working our conic since 2006, and cites Edge nowhere

**Provenance**: [C191 completeness hunt](2026-07-15-c191-completeness-hunt.md), reading
[C179](2026-07-15-c179-conic-ldpc-literature.md) (a `clebsch` report) against C191's cell 1.
**Was I looking for this?**: no — the hunt was after *omitted cells* in the backfill's sample, a
bookkeeping question. It surfaced a live far side instead.
**Expectation violated**: that the finite-geometry↔coding seam around this conic was empty, which is
what the backfill and the method both asserted.
**Observed**: Droms–Mellinger–Meyer (2006), Sin–Wu–Xiang (2011), Madison–Wu (2012), Wu (2013),
Madison–Wu (2016) fix the same conic in `PG(2,q)`, use the same internal/conic/external point split
and passant/tangent/secant line split, and exploit the same `PGL(2,q)`/`PSL(2,q)` polarity. They build
**binary incidence null-space codes on whole point classes**; we build an `F_11` MDS code on a
six-point arc. They reach the conic from LDPC and cite Edge nowhere, so citer closure on Edge is blind
to them by construction.
**Strongest question**: this is an *earned dictionary with a question list attached*, aimed at our
object, with a nameable keying cause for why it never arrived — the best-shaped gap generator the lane
has. Edge's 22 hexagons partition the 66 external points into two systems of 11, every external point
on exactly 2 [in-repo L4, Edge §§29–32] — i.e. a binary parity-check matrix on the same 66 coordinates
Madison–Wu use, column weight 2, row weight 6. **Nobody has written Edge's hexagons down as a code.**
— follow-on, and the lane's next find-work.
**Status**: open lead. The correction it forced in C191 and the method is a *result* and lives there;
this entry records the byproduct, which is the far side itself.
