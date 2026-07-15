# C191 — Completeness hunt: the cells the backfill missed

**Lane**: `gem-mining` — see CLAUDE.md § Lane routing.
**Date**: 2026-07-15
**Status**: **REPORTED, PROVISIONAL** — a mining session's reasoning, not load-bearing until vetted.
The vet is the user's to launch.

Closes item 2 of [C191](2026-07-15-c191-gap-mining-backfill.md) § Next: sweep the lane's decided
history for scoreable cells absent from the backfill's five, on the principle that an in-sample fit
which also picked its own sample is a compounded error, and the only thing that can expose it is a
cell that was both scoreable and awkward.

**One was found.** Companion: [instrument calibration](2026-07-15-c191-instrument-calibration.md),
which independently predicted this failure's shape.

## Verdict

**C191's cell 1 contains a false claim, and the cell that refutes it was committed 2.5 hours earlier
in the same commit as a cell C191 did score.**

C191 § cell 1 (lines 74–76):

> **the founding hit lives in an *empty* seam, not a thin one** — no near-misses at object level,
> because no coding paper ever cited Edge.

**The seam is not empty.** [C179](2026-07-15-c179-conic-ldpc-literature.md) documents a coding
lineage on the fixed conic in `PG(2,q)` running 2006–2016: Droms–Mellinger–Meyer (2006),
Sin–Wu–Xiang (2011), Madison–Wu (2012), Wu (2013), Madison–Wu (2016). C179's own characterization:
they "fix the same conic in `PG(2,q)`, split points into internal/conic/external classes and lines
into passant/tangent/secant classes, and exploit the same `PGL(2,q)`/`PSL(2,q)` action and conic
polarity." They swerve at the coding object — binary incidence null-spaces on whole point classes,
versus a six-coordinate `F_11` MDS code on an arc.

**That is a near-miss cluster at object level, in coding venues, and it is exactly what C191 says
does not exist.**

The inference C191 drew is invalid, and the invalidity is the interesting part:

> no near-misses at object level, **because** no coding paper ever cited Edge

"No coding paper cited Edge 1956" is true — the [calibration](2026-07-15-c191-instrument-calibration.md)
confirms it across three independent indexes. "No coding paper worked on this object" is false. The
DMM/Wu/Madison lineage reached the conic **from LDPC, not from Edge**, so it cites Edge nowhere and is
structurally invisible to a citer-closure probe keyed on Edge. The probe measured *who cites Edge*;
C191 read it as *who works on this object*. The gap between those two readings is precisely the
near-miss cluster.

The calibration predicted this shape without knowing the instance: the instrument's error mode is
missing citers, which biases toward *emptier*, which is the direction that confirms a fame-asymmetry
cause. **Here is that bias realized on the founding cell.**

## The sample took one cell from a commit and left its neighbour

| Fact                                  | Evidence                      |
|---------------------------------------|-------------------------------|
| C179 added 09:42, commit `0bde4f0`    | `git log --diff-filter=A`     |
| C178 added 09:42, **the same commit** | C178 and C179 landed together |
| C191 added 12:15, commit `3618816`    | 2h33m after both              |
| C191 scores C178 as its cell 4        | C191 line 123                 |
| C191 never mentions C179              | no occurrence in the file     |

C179 was not unknowable. It was in the same commit as the cell the backfill *did* score, and it is
the one document in the lane that speaks directly to cell 1's seam.

### The internal contradiction this produces

C191's cell 4 is **C178 — `(Wu internal-orbit conics, …)`**, scored "Cause class: n/a — an
object-mining probe, not a transport" (line 125).

**Wu's conics are from a coding paper.** Wu (2013) is *Linear Algebra Appl.*
(doi:10.1016/j.laa.2013.04.004), constructing a binary null-space LDPC code `[55,31]₂` whose rows are
`PSL(2,q)`-stabilizer-orbit conics of internal points; C179 records that C178 reconstructs Wu's 110
`q=11` blocks.

So C191 scores, as cell 4, a probe whose object is drawn from a coding-theoretic construction on
conics in `PG(2,11)` — and asserts in cell 1 that no coding paper has come near this object. **Both
claims are inside the same report.** Cell 4's provenance alone falsifies cell 1's seam reading,
without any external source.

## The cause class is incomplete, and its census was never run

C191 scores the founding cell **fame asymmetry (source 4)**; the method's ledger carries the same
(`2026-07-15-gems-theory-gaps-method.md` line 433).

The method defines source 4 and its census at line 186:

> **Fame asymmetry.** `O` is classical in A, `q` is standard in B, `D` is documented, and `O` has no
> name in B. **Census: B's object taxonomy.**

**The census for source 4 is B's object taxonomy. C191 never ran it.** It substituted Edge 1956's
citer list, which is a different census answering a different question. Run the specified census —
does coding's object taxonomy contain the conic in `PG(2,q)`? — and C179 answers **yes**, with a
decade of papers.

**The class is s4 *plus* s2, and C191 recorded only s4.** (Correcting my own first statement of this,
which said s2 rather than s4 — too strong.) Source 4 survives on its own terms: the *hexagon* has no
name in coding, and that is still true after C179. What C179 adds is the wing s4 alone cannot see —
the coding literature that **does** work this conic is keyed to *binary incidence codes on whole point
classes*, and so structurally cannot see an `F_q`-linear MDS code on a six-point arc. That is source
2's signature: a symmetry-breaking definitional choice foreclosing a wing.

The distinction is not pedantry, because the two classes predict different things. s4 alone predicts
an *absent* far side and licenses the empty-seam reading. s4+s2 predicts a *present but blind* far
side — which is what is there, and which is why the seam is populated with near-misses rather than
vacant. Note the irony: cell 3 (the mixed-type invariant) is scored s2 for the same shape of reason —
a literature keyed one way that cannot see the other — and cell 3 is the exhibit C191 built its
value-as-a-factor argument on. The founding cell has the same structure and it went unrecorded.

This matters beyond bookkeeping: **cause class is the ledger's ranking key** (method § The cause of
emptiness). The founding cell is the one everything else is calibrated against, and its key is
assigned from a census the method did not ask for.

## What this does to C191's verdict

C191's central evidential claim:

> **The revised method promotes the founding hit and deprioritizes the known-worthless cell. The
> first-draft method does neither.**

The revision's promotion of the founding hit is C191's own account (lines 71–73): cause and seam
scored independently, "the seam is measured at object level (**empty**), and value is a factor rather
than a post-filter. Promoted."

**The seam factor in that computation is wrong.** The promotion score is

```
(cause named, prediction confirmed) × (value passes) × (seam thinness) × (gate accessibility)
```

and seam thinness was supplied by a probe that cannot see the papers populating the seam. So:

- The **first draft** mis-ranks the founding cell via category resolution (≈1850 papers → tier 4 →
  skip) — C191's finding, and I did not disturb it.
- The **revision** promotes the founding cell via object resolution reading *empty* — but the seam is
  populated, and the reading is an artifact of the probe's blind spot.

**Both drafts mis-measure the founding cell's seam. The revision gets the right answer for a wrong
reason.** Whether the revision still promotes once the seam is scored as populated is **unresolved
and needs recomputation** — it turns on how seam thinness trades against a strongly-passing value
factor, which the method does not quantify.

**Therefore C191's verdict is not established by the scoring it presents.** This does not show the
method is wrong, and it does not touch the hit itself: the `[6,3,4]₁₁` MDS code is genuinely distinct
from the binary incidence codes, and C179's own verdict is that the shared geometry "is
infrastructure, not the same coding object". What falls is C191's *evidence* that the revision
handles its own history — the one cell that evidence rests on most heavily is scored on a
mis-measurement.

**And it undercuts C191's self-assessment — though by less than I first wrote.** C191 claims
falsification power: "Had the revised ordering mis-ranked the lane's own history, that would have
killed it on the spot. It did not."

**[Corrected 2026-07-15, after the Fable advisory flagged it. The first version of this paragraph
answered "It did — on the founding cell." That overstates what this report establishes, in exactly
the fluent mode it charges C191 with — and it contradicts my own § What this does to C191's verdict
two sections above, which says the re-ranking is unresolved. Recorded rather than deleted: the error
is the report's own subject matter.]**

What is established is a mis-**measurement**: the founding cell's seam factor is wrong. Whether that
propagates to a mis-**ranking** is precisely the recomputation flagged unresolved above, and I cannot
assert both.

The defensible claim is narrower and still bites: **the backfill could not have detected a mis-rank
on this cell in either direction**, because the evidence that its seam factor is wrong sat outside
the sample it chose. A falsification test that omits the case able to fail it has not earned the word
"survived", whichever way the recomputation lands.

## Other omitted cells

None of these falsify. Each is scoreable, each was decided before C191, and each runs the same
direction: **more in-sample fit than C191 discloses.**

### The ω_arc / BSW census — a prospective mis-rank the lane actually made

Novelty tables §3 row 8: "ω_arc growth strengthens an open conjecture (**ranked #2 at the time**)" →
its all-external half *is* the BSW conjecture, machine-checked to `q < 131`; the lane's sweep to q=37
recomputes inside a checked range. Now last in lane.

This is the lane's **one genuine prospective ranking that was made and was wrong** — the closest thing
its history holds to a real out-of-sample datum, and the backfill omitted it. The revised method
deprioritizes it correctly (source 5 is the weakest source; value fails on recomputation-inside-a-
checked-range), so it does not falsify. **But the guard is retrodicted from this very cell**: method
line 189–191 names source 5's printed-range check and cites "(Van de Voorde's `q < 131`)" — the exact
scoop. That is a **second retrodiction**, and C191 discloses only one.

### C174 — the mechanism deformation that worked, omitted while the one that failed was scored

C191 cell 5 scores the q=23 octad negative and credits it with validating rule 4 and the
mechanism-vs-statement distinction. [C174](2026-07-14-c174-general-six-subset-identity.md) is the same
internal detector deformed along the *other* axis — the ambient plane rather than the Mathieu tower —
holding `|H| = 2×3` fixed, and it **hit**: the chord–extension identity holds for every six-arc in
every finite projective plane.

The backfill scored the failure and omitted the success. The rule's real question is whether it
discriminates the axes *prospectively*; a sample with only the negative cannot show that. (It
plausibly does discriminate — deforming q breaks `|H|=6`, deforming the ambient plane preserves it —
which makes the omission a positive left on the table rather than a threat. That is still sample
selection.)

### The crossing story — the only named cause the lane ever killed, omitted

Novelty tables §4 row 1: "ω_arc falls below n_min after q=11 — 'why 11', provable by a spectral
bound" → **refuted by computation**; ω_arc ≥ n_min at q = 13, 23, 29, 31, 37.

This is a named cause that made an out-of-sample prediction and had it killed — the exemplar for the
method's "a named cause must over-predict, or it is a just-so story" rule. **All five of C191's cells
have causes that held.** The sample contains no cause-axis negative, so the rule that the method
leans on hardest was never stressed by the backfill. A **third retrodiction** sits here too: the
bound-shape internal detector's live instance (pencil bound linear, ω_arc data sublinear) is the
corrected form of the bound whose mis-statement — "the pencil ceiling is ~√q", §4 row 4 — was the
whole basis of the crossing story.

### Legitimately out of scope

- **The fill-signature detector** (§3 row 9) — an object-mining generator, retired for failing the
  object-mining rules. Not a transport cell; the backfill's subject is the gap-mining ordering.
- **§3 rows 1, 2, 6, 10–16 and §4 rows 5–7** — pegged `clebsch`, and mostly manuscript-priority or
  computation errors rather than mined cells. Row 16 (`U(A)` is classical Segre machinery, "machinery
  ≠ motive") is the one worth a second look if the vet wants a wider net; it is a cause-axis case
  where a no-motive argument survived a half-refutation.

## The pattern, stated plainly

Counting what C191 discloses against what this hunt adds, the method's guards are **near-uniformly
fossils of specific past failures**:

| Guard                                        | Derived from                            | C191 discloses? |
|----------------------------------------------|-----------------------------------------|-----------------|
| Factoring check (kill step 2)                | the CO-TR scoop                         | yes             |
| Two-axis promotion                           | the founding cell's tier-1/tier-4 clash | yes             |
| Value as a factor                            | the mixed-type invariant                | yes             |
| Rule 4 / mechanism-vs-statement              | the q=23 octad negative                 | yes             |
| Object-level over category resolution        | the ~1850 measurement                   | yes             |
| Source 5's printed-range check               | the Van de Voorde `q<131` scoop         | **no**          |
| Bound-shape detector's live instance         | the corrected pencil bound              | **no**          |
| Degeneracy guard (smallest *non-degenerate*) | the hexad's q=4/q=5 degeneracies        | partially       |

C191 says the backfill is an in-sample fit. It is more in-sample than that: **the method is largely a
postmortem checklist**, each guard shaped by the one failure that produced it. That has a consequence
C191 does not state — a postmortem checklist generalizes to *new* failure modes not at all, and the
declared null (cause classes uncorrelated with yield) cannot be moved by any of it. C177, scored
before it runs, remains the first datum that can.

## Required changes to C191 — for the vet to rule on, not applied here

1. **MUST** — strike or rewrite the "empty seam" wrinkle (lines 74–76). The founding hit's seam is
   populated at object level by the C179 lineage. The lesson currently drawn from it — "an empty seam
   with a nameable cause is exactly where the gem was" — is derived from a mis-measurement and would
   mis-train future mining if kept.
2. **MUST** — re-score cell 1's cause class to **s4 + s2**, and run source 4's specified census (B's
   object taxonomy), which C191 never ran. s4 holds — the hexagon has no coding name — but s4 alone
   licenses the empty-seam reading; the s2 component is what makes the far side present-but-blind.
   Propagate to the method's ledger row (line 433).
3. **MUST** — withdraw or qualify the verdict "the revised method promotes the founding hit". It does
   so on a wrong seam factor. Recompute with the seam scored as populated and report whether the
   promotion survives.
4. **MUST** — reconcile cell 4 with cell 1, or note the tension explicitly: cell 4's object is Wu's
   coding construction.
5. **SHOULD** — add the ω_arc/BSW cell, C174, and the crossing story to the ledger, flagged as the
   sample-completion they are, and disclose the second and third retrodictions.
6. **SHOULD** — replace "seven indexed citers" with the calibrated figure (see the calibration
   report's required-changes list).

## What I could not check

- **Whether the revision still promotes the founding hit** once the seam is scored as populated. The
  method does not quantify how seam thinness trades against value, so the recomputation is a judgment
  call I should not make unvetted. This is the single most consequential open item.
- **Whether any DMM/Wu/Madison paper cites Edge, BSW, or Van de Voorde.** If one cites BSW, the seam
  is not merely populated but *connected*, and the fame-asymmetry cause weakens further. Cheap to
  check; not run. C179's evidence boundary records that the DMM 2006 body remains unavailable and the
  Madison–Wu 2016 body unread.
- **§3 rows 10–16 (`clebsch`-pegged)** — read for scoreability, not scored. A wider net is a lane
  question.
