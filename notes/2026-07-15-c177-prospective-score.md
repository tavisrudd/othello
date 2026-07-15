# C177 — Prospective score, written before the cell is run

**Lane**: `gem-mining` — see CLAUDE.md § Lane routing.
**Date**: 2026-07-15
**Status**: **SCORE ONLY. THE CELL HAS NOT BEEN RUN.** No computation has been attempted, no
literature has been searched, and the verdict is not known to the author at the time of writing.
Provisional like all gap-mining output; the vet is the user's to launch.

**This file exists to be wrong.** It is the ledger's first **out-of-sample** datum and the only thing
that can move the method's declared null (*cause classes are uncorrelated with yield*). Its value is
destroyed if it is edited after the answer is known. **Do not revise the predictions below.** Record
outcomes in a separate § Outcome section appended later, or in a separate report.

Commit this file **before** the run.

## The cell

`(point reguli of the Hermitian unital U(11), conic 6-subsets → Mathieu hexads, "do the local
structures glue to a global design?")`

- **Object.** De Wispelaere's `D_Hex(11)`: a `2-(1332,12,5)` design on the Hermitian unital's
  `11³+1 = 1332` points, blocks from point reguli, automorphisms `PSU₃(11)`. At q=11 each point
  regulus is a **12-point conic**, so by C147 it carries the two local `S(5,6,12)` hexad systems
  (132 + 132 = 264 hexads per regulus).
- **Dictionary.** `conic 6-subsets ↔ Mathieu hexads` — **earned**, off C147, which is this lane's own
  machine-checked result. The regulus being a 12-point conic is what makes the dictionary apply.
- **Question.** Standard on the far side (design theory): given a design whose blocks each carry a
  sub-design, do the sub-blocks glue to a global design? Concretely: are the 264 local hexads
  independent of which of the **three point-regulus representatives** of a repeated `B₂` block is
  used, and does `PSU₃(11)` preserve or swap the two-system torsor?
- **Claimed payoffs** (from the queue row, not verified here): representative-independence gives a
  simple `2-(1332,6,240)`; a `PSU₃(11)`-equivariant choice of one system gives `2-(1332,6,120)`.

## Declared null — the boring answers, stated before looking

Every null type must be refuted (rule 3). Ranked by my prior:

1. **Trivial / it does not glue** (my modal expectation). The local hexads depend on the choice of
   regulus representative, so there is no well-defined global block set and no design. Nothing to say
   beyond "checked, no".
2. **Known-under-another-name.** It glues, but the gluing is a standard design-theory operation —
   block substitution / composition / expansion, where a `2-(v,k,λ)` whose blocks carry a
   `2-(k,m,μ)` yields a `2-(v,m,·)` whenever a forced pair-count identity holds. Design theorists
   study exactly this, so the "new design" is an instance of a named construction and the parameters
   fall out of arithmetic.
3. **Vacuous.** The gluing is forced by the design axioms, making the result a restatement of
   `2-(1332,12,5)` rather than a new object.
4. **Tried-and-failed-silently.** De Wispelaere or a reader checked and it does not glue; unprinted
   because negatives are.

**A hit requires all four refuted**: it glues, the gluing is not forced, the resulting design is not
a known construction's instance, and somebody is forced to care.

## Predictions — falsifiable, made blind

Numbered so the outcome can be scored line by line.

- **P1. Cause class: s4 (fame asymmetry) + s2 (definitional keying).** The generalized-hexagon /
  finite-geometry community owns `D_Hex(11)` and reads reguli as *incidence* objects; the
  design/sporadic community owns `S(5,6,12)`. The object has no name in the second and the internal
  design structure of a block is not a question the first asks. (Recording s4+s2 rather than s4 alone
  is the correction forced by C192's far side — see the completeness hunt.)
- **P2. The cause's out-of-sample prediction: De Wispelaere's papers do not cite Mathieu, Steiner, or
  `S(5,6,12)`,** and the generalized-hexagon literature does not discuss the internal hexad structure
  of reguli. **Confidence: moderate.** Per the calibration, citer closure is a lead not a reading —
  the census that decides this is the far side's **object taxonomy** (does the GH literature study
  reguli-as-Mathieu-carriers?), not who cites whom.
- **P3. The factoring check FIRES.** The question factors through "when do block-local sub-designs
  glue?", which is a standard design-theory counting question. Per the method, assume the far side
  answers it and search the coarsened form first. **Confidence: high.** This is the same guard that
  fired correctly on C192.
- **P4. Value FAILS, on the mechanism-deformation predicate.** The construction needs regulus size
  `q+1 = 12` to equal the Mathieu 12, so it exists **at q=11 and nowhere else**. That is the exact
  shape of the q=23 octad negative — the mechanism does not deform, the *statement* does. Rule 4 says
  coincidence-of-small-numbers is the default hypothesis, and the neighbouring parameter is the test:
  at q=13 the regulus has 14 points and there is no `S(5,6,14)`. **Confidence: high, and this is the
  load-bearing prediction of this score.**
- **P5. Value also fails to re-key a corpus.** A new `2-(1332,6,240)` is an isolated new fact — a
  note. Nothing classical gets reinterpreted. Compare the founding hit, whose worth is that Edge 1956
  becomes a coding theorem.
- **P6. Promotion score: LOW.** Value is a multiplicative factor and P4/P5 fail it, so the product is
  low regardless of how the seam measures. **Applied as written, the method ranks this cell down.**
- **P7. The verdict will be a closed negative or a note, not a gem.** Most likely: it does not glue
  (null 1), or it glues and is a known composition (null 2). **Probability it is a genuine gem:
  under 10%.**
- **P8. Gate accessibility: unmeasured, and a flag.** De Wispelaere's papers' open-access status has
  not been checked. Thin-and-dark is the worst cell on the board; if her construction is behind a
  gate, this cell is stuck before it starts.

## Why run it at all, given P6

Three reasons, all of which hold even though the score is low:

1. **The cell is cheap and it is the null's only mover.** It is a *computable* verdict — no reading
   required to settle the mathematics — so it costs compute, not gate budget. Every retrospective
   cell in the ledger is in-sample; this one is not. A batch of prospective cells is the only thing
   that can test *cause classes are uncorrelated with yield*, and the batch has to start.
2. **A low score that is confirmed is a datum.** If C177 is scored LOW and comes back a closed
   negative, that is one point of correlation between the ordering and the outcome. If it is scored
   LOW and comes back a gem, **the method is falsified on its first prospective cell**, which is worth
   more than the gem.
3. **Closed cells are lane assets** (the C178 precedent): recording that this question was transported
   and the answer is boring prevents re-mining it.

## What would falsify this score

Stated now so it cannot be rationalized later:

- **The score is wrong if** the gluing works, the result is *not* an instance of a known composition,
  and the mechanism deforms off q=11 in some way I have not seen. Then P3/P4/P6/P7 all fail together
  and the method's ordering mis-ranked a real hit — the same failure the backfill was supposed to test
  for and could not.
- **P4 specifically is wrong if** there is a parameter family I am missing — e.g. if the relevant
  structure is not "regulus size = 12" but something that survives at other q. I have not checked the
  regulus size at q ≠ 11 against De Wispelaere's actual construction; P4 rests on the arithmetic that
  `S(5,6,12)` needs exactly 12 points.
- **P2 is wrong if** the generalized-hexagon literature already discusses hexads on reguli. Not
  searched.

## What I have not done

- No computation. The unital's 1332 points, the reguli, and the block structure have not been built.
- No literature search. De Wispelaere's papers have not been fetched, and are not in the cache.
- The `2-(1332,6,240)` / `2-(1332,6,120)` parameters are **as reported in the queue row** and have not
  been re-derived. A first attempt at the pair count from `S(5,6,12)` (a pair lies in 30 of the 132
  hexads of one system, 60 of both; each pair of unital points lies in 5 blocks) gives 5 × 60 = 300
  rather than 240, which does not match — the discrepancy is presumably the repeated-block
  multiplicity of 3, and it is **unresolved**. Resolving it is step one of the run, and it may kill
  the cell outright.
