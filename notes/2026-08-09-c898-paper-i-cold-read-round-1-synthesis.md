# C898 — Paper I cold-read round 1 synthesis

**Date:** 2026-08-09  
**Status:** frozen; remediation authorized  
**Round verdict:** `MAJOR`

## Frozen batch

All five reports reviewed the PDF with SHA-256
`95ccf1ff32180fd806608002d69a912c5a1aae26a8fb5778d553a88b62803d83`
from manuscript commit `6e011ff585f46658a2650803d8672f07a48e786a`.
They were written in independent contexts and frozen before cross-comparison.

| Packet | Verdict | Report |
|---|---|---|
| finite geometry (Storme/Szőnyi) | `MAJOR` | `notes/2026-08-09-c898-paper-i-cold-read-r1-finite-geometry.md` |
| coding (Kaipa/Pambianco) | `GO` | `notes/2026-08-09-c898-paper-i-cold-read-r1-coding.md` |
| orientation (Haemers/Gillespie) | `MINOR` | `notes/2026-08-09-c898-paper-i-cold-read-r1-orientation.md` |
| cubic geometry (Zhang/Hassett) | `MAJOR` | `notes/2026-08-09-c898-paper-i-cold-read-r1-cubic.md` |
| editorial/significance (Ball packet) | `MAJOR` | `notes/2026-08-09-c898-paper-i-cold-read-r1-editorial.md` |

The round is major for two independent reasons: Proposition 2.2 contains a
false characteristic-five stabilizer clause, and the six-node exhaustion is a
load-bearing proof dependency not supplied in human-readable form. The central
order-eleven inverse theorem itself survived every relevant read.

## Adopted findings

### A1 — characteristic-five stabilizer (`MAJOR`, proof/citation)

Proposition 2.2 says the projective stabilizer is `A_5` for every odd
characteristic. In characteristic five the golden roots coalesce, the displayed
root-exchange matrix has determinant zero, and the index-two argument fails.
Dye's Theorem 3 states `A_5` away from characteristic five and `S_5` in
characteristic five.

Required repair:

- state the exception in the proposition;
- restrict the root-fibre proof to nonzero discriminant;
- handle characteristic five by Dye's explicit extra involution or a direct
  displayed projectivity;
- correct the attribution remark and audit downstream all-field references;
- make the companion's characteristic-five remark record the `S_5` enlargement.

No order-eleven theorem changes.

### A2 — singular-locus exhaustion (`MAJOR`, human proof/trust boundary)

The PDF exhibits six singular axis classes and proves their Hessians have rank
four, but it does not prove that the five gradient quadrics have no other common
projective zero over an algebraic closure. The public exact checker does prove
this by five chartwise Gröbner bases.

Required repair: put the compact chart certificate in the human proof and say
plainly which exact computation certifies it. Reconcile Section 9's assertion
that no preceding conclusion depends on the formal development with this proof
route. The checker already establishes mathematical correctness.

### A3 — undisplayed action witnesses (`MAJOR` editorially; local proof/exposition)

Proposition 6.3's complete 133-point orbit partition and Proposition 7.3's
normalizer/support-orbit assertions refer to action rows, generator
certificates, or a “displayed table” that the PDF does not display.

Required repair: include a compact auditable table of the relevant generators
on coordinates, matchings/support classes, orbit seeds and sizes, with an exact
coverage statement. Do not ask the reader to infer unseen rows.

### A4 — order-eleven predecessor boundary (`citation/novelty`)

Blokhuis--Seress--Wilbrink already classify complete exterior sets at `q=11`,
including the unique six-arc and the Pasch branch. The paper's defensible new
finite-geometric step is stronger/different: mere containment of the uncovered
locus in an arbitrary quadratic forces equality and the Clebsch orbit, without
starting from a fixed nonsingular conic or exterior-set hypothesis.

Required repair: state the precise implication between the exterior-set
classification and the present theorem without silently identifying BSW's
stated “up to isomorphism” quotient with a fixed-conic projective action.
Locate novelty at arbitrary-quadratic containment plus the conceptual
chord-defect proof.

### A5 — local citation and convention repairs (`MINOR`)

- Explain why Storme--Van Maldeghem Proposition 13 implies incompleteness of
  the `q=11` six-arc rather than claiming it states that sentence literally.
- Display one determinant or kernel calculation proving the six parity-check
  rays do not lie on a conic, closing the non-GRS sentence.
- Name `B` as the classical order-six symmetric conference/Paley switching
  class and cite Haemers--Parsaei Majd; retain intrinsic recovery as the new
  claim.
- Correct the sentence calling global negation itself a switching: negate first
  and then apply the stated switch to restore the chosen gauge.
- Add enough navigation in Section 8 to separate the switching, determinant,
  singularity, symmetry, and commutant implications.

### A6 — coding chain (`GO`)

No coding-theory remediation is required beyond the cheap non-GRS determinant
display. The quotient ladder among projective syndrome points, cosets, received
words, leaders, monomial equivalence and projective column arcs is correct. The
covering-radius argument does not silently import the Reed--Solomon hypotheses
from the packet literature.

## Lean, history, and companion audit of A1

### Formal coverage

Lean does not prove the false all-field stabilizer statement.

- `RelativeConicArcs.GoldenHexagonNormalForm.golden_normal_form_of_concurrent_matchings`
  proves the golden coordinate normal form over an arbitrary field from four
  concurrency hypotheses. It contains no stabilizer theorem.
- `RelativeConicArcs.SixArcGoldenNormalForm.exists_golden_frame` and
  `exists_golden_root` assemble the ten-concurrence six-arc classification and
  root existence. They contain no stabilizer theorem.
- `RelativeConicArcs.ClebschDye.isClebschHexagon_of_uncovered_subset_planeConic`
  proves the order-eleven rigidity implication. Characteristic five is outside
  that theorem.
- For the statement group containing Proposition 2.2, the trust manifest lists
  only `RelativeConicArcs.ClebschChordDefect.clebsch_uncovered_formula` as a
  Lean terminal. Its trust boundary explicitly calls the golden normal form
  conceptual; it does not certify the stabilizer clause.

Thus the problem is a manuscript theorem/proof overgeneralization, not a false
Lean theorem or an unsound formal proof.

### Introduction date and compression trail

The error entered on 2026-08-03 at 14:02:25 PDT in commit
`2799bcbfc9f0568edb9a7afd2f56cef1fb057452`, `C855: batched Paper I
manuscript pass`.

Before that commit, the manuscript scoped Dye's stabilizer statement to
characteristic eleven. The commit replaced that paragraph with the all-odd-
characteristic golden-normal-form proposition and the uniform `A_5` clause.

The source trail contained the missing warning:

- `notes/2026-08-03-c855-dye-orbit-uniqueness.md`, introduced at `6eaf1093`,
  observes that the two roots merge in characteristic five and explicitly
  records that a larger stabilizer was not checked;
- the same note nevertheless labels its root-fibre argument as an all-field
  `A_5` by-product, an internal inconsistency;
- `notes/2026-08-03-c855-manuscript-pass-log.md` says the characteristic-five
  stabilizer-growth question was deliberately omitted from the companion,
  while also describing the expected growth from `A_5` to `S_5`.

Dye's authoritative page-278 scan resolves the question directly: Theorem 3
gives `A_5` unless the field has characteristic five, when the group is `S_5`.
Nothing valid was compressed out of a complete proof; instead, the integration
extended an index-two argument past the hypothesis that the two roots are
distinct and omitted its recorded boundary warning.

### Companion status

The companion's `q=11` `A_5` statements are correct. Its characteristic-five
remark correctly says that the vertices lie on the associated conic and the two
golden roots coincide. It does not repeat the false uniform stabilizer claim,
but it omits the resulting `S_5` enlargement. Add that sentence for consistency.

## Deferred architecture decision

The editorial read recommends splitting or sharply abbreviating the
orientation/cubic half. That is a manuscript-architecture decision, not a local
repair, and this synthesis does not adopt it silently. The present remediation
should improve theorem hierarchy and Section 8 navigation without moving
results between papers. Reassess cohesion in round 2.

## Round-2 gate

After remediation, re-freeze the manuscript and run at least:

1. finite geometry, targeted at characteristic five, Dye/BSW attribution, and
   the fixed-conic versus containment novelty boundary;
2. cubic geometry, targeted at the chartwise singular-locus proof and trust
   statement;
3. orientation, targeted at the displayed normalizer table, conference citation,
   and negation convention;
4. editorial, targeted at theorem hierarchy and cohesion;
5. a short coding regression on the non-GRS calculation and unchanged quotient
   ladder.

## EJ + TT closeout and mystery ledger

**Settled.** The most serious finite-geometry finding does not threaten the
order-eleven inverse theorem; it is isolated to the all-field stabilizer clause.
Formal proof did not conceal or prove that clause. The exact historical cause is
the 2026-08-03 generalization, and Dye gives the correction. The six-node claim
is mathematically correct because the public checker exhausts all projective
charts; the defect is its missing human proof and inconsistent trust prose.

**Open under C898.** The repaired Section 8 may still feel like a second paper
even after its proof bridges are visible; round 2 owns that editorial verdict.
The BSW boundary is closed conservatively: their six-arc isomorphism type is
recorded as a classical predecessor, but no stronger identification of their
equivalence quotient is claimed. No separate C id is needed.
