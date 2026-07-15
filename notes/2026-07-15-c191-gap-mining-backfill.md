# C191 — Gap-mining backfill: scoring the lane's history as-if-prospective

**Lane**: `gem-mining` — see CLAUDE.md § Lane routing.
**Date**: 2026-07-15
**Status**: **REPORTED, PROVISIONAL — VERDICT CONTESTED BY THIS LANE'S OWN FOLLOW-UP.** The
[completeness hunt](2026-07-15-c191-completeness-hunt.md) found that the sample omitted
[C179](2026-07-15-c179-conic-ldpc-literature.md), which falsifies cell 1's "empty seam" and undercuts
the verdict below; the [calibration](2026-07-15-c191-instrument-calibration.md) found the instrument
that produced cell 1's "Confirmed" is biased toward producing it. **Read those two before relying on
anything here.** The verdict stands as written only until the vet rules on their required-changes
lists; nothing in this report is load-bearing meanwhile.

**Provisional means provisional.** Every finding below is this model's reasoning and is **not
load-bearing until a stronger reasoning model (Fable, or 5.6 Sol) has vetted it** — a pass the user
launches, on their own schedule, and never the mining session's to run. The rule is earned
by the session that produced this report: the method's first draft was confidently wrong at its
centre and needed the Fable pass to see it, and the revision then introduced a circular calibration
gate resting on a misreport of an in-repo record, caught only by an independent review. Both errors
read as fluent at the point of writing. Treat the scoring below as a proposal for a vet, not a
result.

The first pass of [the gap-mining method](2026-07-15-gems-theory-gaps-method.md), per its § First
steps: score the lane's already-decided cells as if the method had ranked them before the answers
were known, and check whether it mis-ranks its own history. Companion:
[the Fable review](2026-07-15-gems-theory-gaps-method-fable.md).

## Verdict, and its limits stated first

**The revised method promotes the founding hit and deprioritizes the known-worthless cell. The
first-draft method does neither.** That is a real result about the revision — but a weak one, and the
weakness is structural rather than incidental:

**This is an in-sample fit, not a validation.** The revision was designed with these exact cases in
view. Fable's review used the Clebsch hit, the mixed-type invariant, and the q=23 octad negative *as
its counterexamples*, and the fixes were written to accommodate them. A method scored against the
cases that shaped it passes by construction, and passing therefore carries almost no evidential
weight.

What the backfill retains is **falsification power only**. Had the revised ordering mis-ranked the
lane's own history, that would have killed it on the spot. It did not. So the method *survives*; it
is not *validated*. The distinction matters because the doc's own guard against just-so stories —
require an out-of-sample prediction — applies to the method as much as to any cause it names, and
this pass supplies none.

**The declared null — cause classes are uncorrelated with yield — is untested.** The sample is small,
entirely in-sample, and its verdicts were known before scoring. No batch of retrospective cells can
test it. The first genuine datum is C177, scored before it is run.

## The cells

Scored as-if-prospective: cause class and value assigned from what was knowable *before* each cell's
outcome, then compared against what actually happened.

### 1. The Clebsch hit — `(Edge's hexagon, arcs ↔ MDS, deep holes / covering radius)`

- **Cause class**: structural. **Cause**: fame asymmetry (source 4) **+ definitional keying (source
  2)** — the hexagon is classical in geometry (Edge 1956), covering radius is standard in coding, the
  dictionary is fifty years old, and the hexagon has no name in coding (s4); *and* the coding
  literature that **does** work this conic is keyed to binary incidence codes on whole point classes,
  so it structurally cannot see an `F_q`-linear MDS code on a six-point arc (s2).
  **[Corrected 2026-07-15: s2 was absent, and source 4's specified census — B's object taxonomy — was
  never run. s4 alone predicts an *absent* far side and licenses the empty-seam reading below; s4+s2
  predicts a *present but blind* one, which is what is there. See the
  [completeness hunt](2026-07-15-c191-completeness-hunt.md).]**
- **Out-of-sample prediction of the cause**: a social two-community cause predicts near-zero
  cross-citation at the object level. **Consistent across three independent indexes; not confirmed**
  — Edge 1956's citers are geometry and group theory throughout, not one coding venue, in OpenAlex,
  zbMATH Open, and Semantic Scholar alike. Three qualifications, none of which the original scoring
  carried: three of the seven citers are **Edge citing himself** (four independent citers in
  thirty-two years, none after 1988); the instrument's error mode is *missing* citers, which biases
  toward exactly the emptiness this cause predicts; and **the probe answers the wrong question** —
  "who cites Edge" is not "who works on this object", and the coding lineage that works this conic
  reaches it from LDPC and cites Edge nowhere.
  [calibration](2026-07-15-c191-instrument-calibration.md),
  [completeness hunt](2026-07-15-c191-completeness-hunt.md); supersedes
  [in-repo L2, Fable §7 spike, 2026-07-15].
- **Value**: passes strongly — re-keys a corpus (Edge 1956 becomes a coding theorem), forced dual
  audience, one hop so no audience dilution.
- **Kill stage reached**: survived all. **Gate cost paid**: six sweeps; the covering fact remains
  conditioned on two unread ILL-only BSW originals.
- **Verdict**: HIT, the lane's founding gem. **Evidence**: L3/L4, one gate still open.

**This cell is where the first-draft method breaks, and it breaks incoherently.** Its welded spine
assigned one cell two contradictory tiers at once:

- by *cause*, fame asymmetry is nameable and structural → **tier 1, mine first**;
- by *seam*, its lead instrument reads `cat:math.CO AND cat:cs.IT` ≈1850 papers → **tier 4, skip**.

The same cell, top and bottom of the ordering simultaneously, with nothing in the doc to adjudicate.
That is Fable §4's charge — the spine welds two orthogonal axes — demonstrated on the one cell that
matters most. The revision resolves it: cause and seam are scored independently, the seam is measured
at object level (empty), and value is a factor rather than a post-filter. Promoted.

**Corrected 2026-07-15 — this paragraph asserted the opposite, and the assertion was false. Recorded
rather than deleted, because it is the kind of lesson that grows back.** It read: *the founding hit
lives in an empty seam, not a thin one — no near-misses at object level, because no coding paper ever
cited Edge; an empty seam with a nameable cause is exactly where the gem was.*

**The seam is populated.** [C179](2026-07-15-c179-conic-ldpc-literature.md) documents a 2006–2016
coding lineage on this very conic — Droms–Mellinger–Meyer, Sin–Wu–Xiang, Madison–Wu, Wu — sharing the
conic, the internal/external/conic point split, the passant/tangent/secant line split, and the
`PGL(2,q)` polarity, and swerving at the coding object: binary incidence null-spaces on whole point
classes, not an `F_11` MDS code on a six-point arc. **That is a near-miss cluster at object level, in
coding venues.**

It read as empty because the probe was citer-closure keyed on Edge, and that lineage reaches the conic
from LDPC without citing Edge — so the probe is blind to it by construction. The correct reading is
**populated and blind**, which is the s2 signature, not vacant. Do not re-propose "an empty seam with
a nameable cause is where the gem was": it is derived from a mis-measurement of the one cell it cites.
"Thin beats empty" remains scoped to *accessibility* and is untouched by this. See the
[completeness hunt](2026-07-15-c191-completeness-hunt.md).

### 2. C147 — `(conic 6-subsets in PG(2,11), geometry ↔ design/Mathieu, which are hexads?)`

- **Cause class**: structural. **Cause**: well-posedness inversion (source 1) plus fame asymmetry —
  over ℝ/ℚ no-accidental-concurrency is generic (Halbeisen–Hungerbühler); over F₁₁ it inverts and the
  exceptions are the Mathieu hexads.
- **Value**: passes on non-specializability, weakly on re-keying.
- **Kill stage reached**: survived; machine-checked end to end. **Gate cost paid**: six sweeps — the
  lane's most expensive.
- **Verdict**: HIT, **bridge-grade**. **Evidence**: L3/L4.

**The factoring check retrodicts this lane's most expensive scoop.** The four-orbit classification
turned out to be published (Cameron–Omidi–Tayfeh-Rezaie, EJC 13 (2006) #R50, Thm 4), found on sweep
#5 [in-repo L3]. The lane's own postmortem states the mechanism exactly: *"With CO-TR supplying the
orbit table, the stabilizer-parity form … is a repackaging of their result, not a new phenomenon.
What is ours is the bridge … The pieces all existed; nobody wrote the sentence."*
[in-repo, novelty tables §1, note on (1)]

That is a factoring failure with the conic embedding as the non-load-bearing structure: the parity
form factors through PGL(2,q)-orbits on 6-subsets of the projective line, which permutation group
theory studies directly, so the far side had already answered it. **Kill step 2 — free, and now the
cheapest step in the order — targets precisely this**, and the expensive sweeps were what actually
found it. The check was derived from the scoop, so this is retrodiction rather than prediction; its
value is that the guard is now mechanical instead of a lesson.

Fable's calibration prediction — that gap-mined hits skew bridge-grade, the sentence connecting two
literatures rather than a new phenomenon — was reached independently and earlier by the novelty
tables, in the same words: *"A legitimate note, thinner than 'we characterized S(5,6,12)'."* Two
independent routes to the same calibration is the strongest signal in this backfill.

### 3. The mixed-type invariant — `(mixed internal/external arc-cliques, internal, ω_arc mixed-type)`

- **Cause class**: structural. **Cause**: definitional keying (source 2) — the exterior-set literature
  is keyed to external points throughout and structurally cannot see all-internal configurations.
- **Value**: **FAILS**. No corpus is re-keyed; no audience is forced. The novelty tables record the
  gap as *"New territory — the literature is external-only and structurally cannot see it"* with the
  blocker listed as *"Someone to care. Downgraded; lowest in lane"* [in-repo, novelty tables §1 row 7];
  the queue rationale says *"the sweep found nobody who cares"* [in-repo].
- **Verdict**: forced-empty, genuinely novel, and **worthless**. **Evidence**: L2/L3.

**This is the exhibit for value-as-a-factor.** The first-draft spine ranks it **mine first** — it is
the purest structural cause in the lane — and the lane, correctly, ranks it last. Novelty and value
are independent, and an ordering that optimizes only the cheap factor inverts the truth on this cell.
The revision's promotion score multiplies by value and lands where the lane already is.

### 4. C178 — `(Wu internal-orbit conics, internal, passant-join six-set?)`

- **Cause class**: n/a — an object-mining probe, not a transport.
- **Kill stage reached**: step 6, smallest non-degenerate instance. Exact reconstruction gives 110 Wu
  conics in two PSL(2,11)-orbits with passant-join clique numbers 4 and 3, so no six-set exists
  [in-repo, C178 report].
- **Gate cost paid**: **none**. **Verdict**: closed negative.

**Validates compute-to-kill.** The cell died on computation with zero literature spend. This is the
economics the method claims, working — and the reason closed cells are assets.

**This cell's object comes from the coding literature, which contradicts cell 1's seam reading
[noted 2026-07-15].** Wu (2013) is *Linear Algebra Appl.* (doi:10.1016/j.laa.2013.04.004),
constructing a binary `[55,31]₂` LDPC null-space code whose rows are the `PSL(2,q)`-stabilizer-orbit
conics of internal points; C178 reconstructs its 110 `q=11` blocks
[[C179](2026-07-15-c179-conic-ldpc-literature.md)]. A report cannot score a probe built on a coding
paper's object and also hold, in the same pass, that no coding paper has come near this object.
**Cell 4's provenance falsifies cell 1's "empty seam" with no external source required** — the
contradiction was available inside this report from the moment it was written.

### 5. The q=23 octad negative — `(conic 8-subsets in PG(2,23), design/Mathieu, octad analogue?)`

- **Cause class**: n/a — internal, and generated along the **wrong axis**: the Mathieu tower deforms
  the *statement*, not the mechanism.
- **Kill stage reached**: step 6 plus rule 4's neighbouring parameter. The mechanism needs |H| = 2×3
  so a concurrent triple is a *perfect* matching; at |H| = 8 a triple covers six of eight points,
  determines no involution, and there are 420 triples to avoid instead of 15 [in-repo, handoff].
- **Verdict**: DEAD — a coincidence of small numbers, not a tower.

**Validates rule 4 and the mechanism-vs-statement distinction.** Also validates the degeneracy guard
in reverse: this cell died at the *neighbouring* parameter, which is the guard that stops a q=11
exhaustion from being mistaken for a program.

## What the backfill changed

| Finding                                                       | Consequence                                    |
|---------------------------------------------------------------|------------------------------------------------|
| Welded spine gives the founding hit tier 1 and tier 4 at once | two-axis promotion is load-bearing, not tidying |
| The founding hit's seam is **empty**, not thin                | keep "thin beats empty" scoped to accessibility |
| Factoring check retrodicts the CO-TR scoop                    | kill step 2 earns its place at the front        |
| Mixed-type: forced-empty, novel, worthless                    | value must multiply, never post-filter          |
| C178 died on compute at zero gate cost                        | compute-to-kill economics hold                  |
| Bridge-grade calibration reached independently in-lane        | expect notes, not phenomena, from pure transport|

No change to the method's text is required by this pass: every finding it produced is already
incorporated. That is itself evidence of the in-sample problem rather than of the method's strength.

## Next

**Gate — awaiting vet, which the user launches.** Nothing downstream may lean on this report until
that pass lands. Its findings are unvetted single-model reasoning, and the two highest-value ones —
the tier-1/tier-4 incoherence and the factoring retrodiction — are exactly the sort of tidy narrative
this session has already shown the model produces fluently and wrongly.

**The vet is a state to report, not a step to run.** It is deliberately absent from the list below. A
mining session does not vet this report, does not commission one, and does not spawn a vet agent. Two
reasons, both binding: an independent pass means independent of the mining session's *framing*, and a
vet whose prompt the mine wrote inherits exactly the blind spots it exists to catch; and the stronger
models are a metered, expensive resource the user allocates deliberately, never a tool the mine
reaches for when it feels uncertain. Leaving the gate open is the work done right. Read the
find-list, not the gate.

1. **Instrument calibration — DONE**, [report](2026-07-15-c191-instrument-calibration.md). Edge 1956's
   citers diffed across OpenAlex, zbMATH Open, and Semantic Scholar. No index is a superset (7 / 3 / 7
   against a union of 8), so object-level closure on a classical seed stays **a lead, not a reading**.
   Two findings bear directly on the Clebsch row above and are **for the vet to rule on, not for a
   mining session to apply**: three of the seven citers are Edge citing himself, so the independent
   count is four in thirty-two years, none after 1988; and the instrument's failure mode is *missing
   citers*, which biases toward the emptiness a fame-asymmetry cause predicts — the confirmation was
   produced by an instrument that manufactures this exact confirmation. The prediction is not
   falsified and the cause arguably comes out stronger, but **Confirmed** is the wrong label.
2. **Completeness hunt — DONE**, [report](2026-07-15-c191-completeness-hunt.md). **It found a
   falsifier.** [C179](2026-07-15-c179-conic-ldpc-literature.md) documents a 2006–2016 coding lineage
   on the fixed conic in `PG(2,q)` (Droms–Mellinger–Meyer, Sin–Wu–Xiang, Madison–Wu, Wu) using the same
   conic, the same internal/external split, the same polarity. **Cell 1's "empty seam / no near-misses
   at object level" is false**, and cell 4's own object — Wu's conics — comes from one of those coding
   papers, so the two cells contradict each other inside this report. C179 was committed 2h33m before
   this report, in the same commit as the C178 that cell 4 scores. Consequences for the vet to rule
   on: the seam factor in the founding cell's promotion is wrong, so the verdict "the revision
   promotes the founding hit" is not established by the scoring presented; and the cause class is
   assigned from a census the method never asked for (source 4's census is B's object taxonomy, not
   Edge's citer list).
3. **C177, scored before it is run** — the first out-of-sample datum, and the first that can move the
   declared null.
4. **Retrospective cells cannot move the null**, and padding the ledger with confirmations inflates
   confidence without testing anything. That bars adding cells *to raise confidence*; it does not bar
   step 2, whose purpose is the opposite — to hunt a mis-rank. A missed cell that mis-ranks is
   falsification, which is the only power this backfill ever had. (Scope corrected 2026-07-15: the
   committed text said "do not add retrospective cells" flatly, conflating the two.)
