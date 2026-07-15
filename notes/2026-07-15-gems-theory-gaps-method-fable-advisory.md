# Fable advisory — move ordering for the gap-mining search (shallow pass)

**Lane**: `gem-mining` — see CLAUDE.md § Lane routing.
**Date**: 2026-07-15
**Pass type**: SHALLOW ADVISORY — move-ordering and pruning advice. **NOT a vet.**
This clears no gate. Findings it discusses remain provisional pending the user-launched vet.

Everything below is my own search judgment from a skim of the four reports plus the method's
§ First steps and the handoff's C177 row. Where I state a report's claim I say so; where I am
reasoning or guessing I mark it. Nothing here was verified.

## Move ordering

1. **Edge 1956 §§29–32 re-read (branch 1).** Near-zero cost, and it gates the lane's only live
   computed result. Every C192-adjacent branch (2, 4, and item A below) changes value depending on
   what Edge says, so this read reprices three other branches for the cost of minutes. Do it before
   anything else. One tactical note: make it a *read*, not a grep — see misread flag 3. Confidence:
   high; this is just knapsack ordering.
2. **C177, scored before it runs (branch 8).** All three C191-family reports converge on the same
   sentence: C177 is the first and only datum that can move the declared null. Everything else in
   the branch list is calibration or bookkeeping; this is the method's actual experiment. It costs
   a full kill-order pass, which is why the free Edge read goes first, but nothing else should cut
   in front of it. Confidence: high.
3. **Hexagon as a stopping set of a DMM matrix (branch 3).** The membership check is trivial
   compute (does any row of the DMM matrix meet the support in exactly one position), so this is
   C178-grade compute-to-kill economics: a genuinely *new* cell, on the far side that just paid off
   in C192, at roughly zero gate cost. This is what the lane is for. Confidence: medium-high on the
   ranking; the cheapness of the check is my reasoning, not verified against DMM's actual matrices
   (C179 records DMM 2006's body as unavailable — if the matrices can't be reconstructed from the
   abstract/successors, cost rises and this drops below branch 9).
4. **Biplane literature (branch 2) — only if branch 1 does not kill.** Search the answer, as C192
   itself says. The 2-(11,5,2) is one of the most catalogued objects in design theory, so expected
   outcome is a fast kill or a fast survival; time-box it. Confidence: high that it's cheap, medium
   that it survives.
5. **Golay dictionary (branch 9) — factoring check only, no reading yet.** The method's own text
   flags that the hexad structure factors through 6-subsets of P¹(F₁₁), which is precisely the
   CO-TR scoop territory, and gate accessibility is unmeasured. Spend the free step, not the read.
   Confidence: medium.
6. **Two systems as a resolution / chirality (branch 4) — park behind the C192 gate.** If Edge
   states the biplane, he very likely also treats the two systems' structure; mining this now risks
   building a floor on a result about to be attributed to 1956. Revisit after branches 1–2 settle.
   Confidence: medium.

Next unit of effort: **branch 1**, then branch 8. The reason branch 1 beats the runner-up is purely
cost: it is minutes against C177's full pass, and its outcome reprices a third of the branch list;
C177's outcome reprices nothing else but is the only null-mover, so it goes immediately after.

## The discovery track's entries, ranked as branches

The three live entries in [the discovery track](2026-07-15-gem-discovery-track.md), taken as
candidate branches in their own right:

- **The coding far side as an earned dictionary (entry 3) — this is the lane's find-work vein, and
  it slots directly under C177 in the ordering above.** Its specific proposal — "nobody has written
  Edge's hexagons down as a code" — has already been executed: that *is* C192. So the entry is
  partly consumed, and what remains is the generator: the DMM/Wu/Madison **question list** pulled
  onto our objects. Branches 3, A, and B above are all draws from this vein, which is why they rank
  where they do — one cheap cell off it already broke its null in a minute of compute. Ranked
  against the listed branches: the vein as a whole sits at position 3, right behind C177; no single
  draw from it outranks the null-mover. Log hygiene, for whoever holds edit rights (not this pass):
  entry 3's status line should graduate to a pointer at C192 per the track's own supersede
  discipline. Confidence: high.
- **The Edge citation profile (entry 2) — evidence, not a branch; nothing to run.** Its strongest
  question is already classified "fold into current cell" and is folded (the s4+s2 re-score, on the
  vet's docket). One over-read caution: the "near-orphaned in its own field" reframe is new
  unvetted reasoning by the calibration's own statement — do not let it become the cause narrative
  by repetition before the vet rules. The cross-lane lead (the `clebsch` C146 priority footnote may
  want the citation fact) is real but is `clebsch`'s call, as the entry itself says. Confidence:
  high.
- **The zbMATH `rf:` trap (entry 1) — banked; prune the follow-on from this lane.** The general
  rule (control a citation instrument against a known-cited seed) is already in the method's
  § Instruments, which is the full gem-mining payoff. The follow-on question — has any absence
  claim in this repo been built on a silently-empty instrument? — is a repo-wide tooling audit
  spanning `clebsch`, `relconic`, and `repaircodes` literature gates. Worth doing once, cheap to
  delegate, and **not this lane's gap-finding**; the entry itself says routing is the user's. Flag
  it to the user as a routing decision and spend no mining time on it. Confidence: high.

## Prune list

Blunt, as requested. The dividing line I used: a branch whose payoff is a *footnote to an existing
report* is pruned; a note-grade *find* is not — the lane's own calibration says its hits skew
bridge-grade, so "only worth a note" cannot be the prune criterion or the lane prunes itself.

- **Branch 7 (recompute the founding cell's promotion) — do not run in a mining session.** The
  completeness hunt itself says this recomputation "is a judgment call I should not make unvetted"
  and lists it as its most consequential open item *for the vet*. A mining session running it
  produces one more layer of unvetted self-assessment on the exact contested cell. It is already
  the vet's docket item 3. Confidence: high.
- **Branch 6 (Segre edge / MathSciNet) — drop.** The calibration's own text: the edge "would not
  change the coding verdict in any case" — Segre's survey is geometry. Access is unresolved, the
  payoff is a footnote to the calibration table, and the citer-count question it refines is already
  settled in direction (sparse, orphaned). If MathSciNet access materializes for some other reason,
  spend five minutes then. Confidence: high.
- **Branch 5 (do DMM/Wu/Madison cite BSW/Van de Voorde?) — hand to the vet docket as one line, do
  not spend mining time.** It is cheap, but its only consumer is the seam/cause narrative of gem
  #1 — paperwork re-audit, which the user has ruled out as the lane's job. Note the contrast with
  branch 3, which uses the same papers to mine a *new* cell. Confidence: medium-high.
- **Branch 10 (ledger backfill of omitted cells) — defer.** By the backfill's own rule 4,
  retrospective cells cannot move the null; these are SHOULD-level required changes awaiting the
  vet's ruling on the whole C191 complex. Folding them in now edits a contested report mid-gate.
  Confidence: high.
- **The zbMATH-trap follow-on (discovery track entry 1) — out of lane.** See the ranking above:
  the rule is banked in § Instruments; the repo-wide silent-empty audit is cross-lane tooling QA
  for the user to route, not gem-mining spend. Confidence: high.
- **The C191-audit genre as a whole — stop at three layers.** Backfill, calibration, completeness
  hunt: the audit trail is complete and internally cross-referenced, and each layer has begun
  auditing the previous one's rhetoric (see misread flag 2 — the hunt exhibits the failure it
  charges). A fourth layer is a spiral with no gap at the end of it. The vet has a full docket;
  mining resumes on new cells. Confidence: high, and I believe this is also the user's stated
  position.

## Misread flags — leads for the vet, not verdicts

1. **"The seam is populated" may be resolution-dependent.** The completeness hunt treats the
   empty→populated flip as settled via C179, but C179's own verdict (quoted in the hunt) is that
   the shared geometry "is infrastructure, not the same coding object". Whether the DMM lineage
   counts as *object-level* near-misses depends on what the object is — the conic (shared) or the
   six-arc MDS code (not shared). Unless the vet fixes the resolution at which seams are scored,
   the empty/populated call can flip again on the same evidence. Smells underdetermined, not wrong.
   Confidence: medium.
2. **The completeness hunt's summary outruns its evidence.** Its closing inversion — "It did
   [mis-rank] — on the founding cell" — asserts a mis-*ranking*, but the hunt establishes only a
   mis-*measurement*, and says two sections earlier that whether the revision still promotes is
   "unresolved and needs recomputation". Mis-measured input with possibly-unchanged output is not
   yet a mis-rank. This is the same fluent-overstatement mode the hunt charges C191 with.
   Confidence: medium-high on the skim.
3. **C192's Edge-read vocabulary is anachronistic.** The grep list (biplane, Paley, `2-(11`) is
   mostly post-1956 terminology — I believe "biplane" as a term is decades later (guessing on the
   date), and Paley structures in 1956 would appear as quadratic-residue or Hadamard constructions,
   or as an unnamed tactical configuration. C192 does say to read the two-systems passage, but the
   gate should be stated as a read of §§29–32 for the *structure*, with the grep as a supplement —
   otherwise a keyword miss gets recorded as Edge-silent. Confidence: medium-high that the risk is
   real, low on my term-dating.
4. **The calibration's union count includes one inferred and one stub row.** The 1962 Monthly
   bundle's citing note is attributed by inference (flagged in "What I could not check") and the
   Segre row is an unverified stub, yet the headline union of 8 carries both. Wording-level only;
   the direction of every conclusion survives. Confidence: medium.

## What we're not seeing

- **A. Polarity image of the hexagons — 1-factorizations of K₁₂.** My reasoning, unverified, and
  I am partly guessing at the geometry: the 66 external points are poles of the 66 secants, and
  secants correspond to the C(12,2) pairs of conic points — the edges of K₁₂ on the 12 conic
  points. If each hexagon's six external points polarize to six pairwise-disjoint secants, then
  each hexagon *is* a perfect matching of K₁₂, and each system of 11 is a 1-factorization of K₁₂
  — and PSL(2,11)-invariant (possibly perfect) 1-factorizations of K_{p+1} are a classical
  combinatorics literature that no report in this stack names. That would be a third far side for
  the same object, one minute of compute on C192's existing scripts to test the disjointness, and
  it feeds the C192 novelty gate directly: a known 1-factorization construction is exactly the
  kind of place the biplane statement could already live. Confidence: low-medium on the math,
  high that the check is cheap.
- **B. The internal-side companion cell.** C192 mined the external 66; the internal 55 have C178's
  Wu-conic data already computed. The C192-style question — "what named structure is the
  internal-side incidence?" — appears not to have been asked; C178 asked only the passant-join
  clique question. Same mold, scripts exist, compute-to-kill. (Aside, unverified: 55 = C(11,2)
  suggests a pair-structure reading under polarity parallel to A.) Confidence: medium.
- Minor, folded into the C192 gate rather than a new branch: before any "program" language about
  the biplane cell, spend one line on rule 4's neighbouring parameter — either a q=13 probe or a
  stated reason the structure is q=11-sporadic. Cheap, and it is the guard the lane already owns.
