# Referee report — Dye triple-point bound formalization (first Dye axiom replacement)

**Date:** 2026-08-04
**Scope:** commits 3ee26456, 2bc11a80, 1d8e03b3, cb87bbf1, 153a3d1e.
Files: `lean/RelativeConicArcs/QuadrangleDiagonal.lean`, `lean/RelativeConicArcs/SixArcConcurrence.lean`,
`lean/RelativeConicArcs/SixArcConcurrenceBound.lean`, the `dye1991_brianchon_bound` replacement in
`lean/RelativeConicArcs/Q11DyeAxioms.lean`; checked against the human proof in
`notes/2026-08-03-c855-structural-exclusions.md` (Target 2), the plan in
`notes/2026-08-04-c855-dye-axiom-elimination-plan.md`, and the landing claim in
`notes/2026-08-04-c855-dye-bound-formalization.md`. Read-only review; no Lean elaboration was run,
so all elaboration judgments on the two not-yet-compiled files are predictions from source.

## Verdict: **accept with required fixes**

The mathematics is sound and faithful to the human proof. The theorem statements say what they are
claimed to say; `card_triplePoints_le_ten` is the genuine bound with no trivializing or vacuous
hypothesis; the `dye1991_brianchon_bound` replacement is verbatim the axiom's statement (verified
against the commit diff), so `Q11DyeConsequences` and `Q11RigiditySpine` prove exactly the theorems
they proved before. I found no mathematical gap anywhere in the chain. The required fixes are: one
concrete elaboration-blocking destructuring bug in the not-yet-elaborated
`SixArcConcurrenceBound.lean` (syntactic, with an obvious one-token repair), and several
scholarly-prose violations of `lean/AGENTS.md` in module headers (a header claiming a theorem the
module does not contain, unwitnessed sharpness/attainment claims, and a stale boundary description
in `Q11DyeAxioms.lean`).

## Soundness of statements (question 1)

**Statement identity.** `git show 153a3d1e -- lean/RelativeConicArcs/Q11DyeAxioms.lean` shows the
axiom's binders, hypotheses, and conclusion reproduced byte-for-byte in the theorem:
`{A : Finset Point11} (hA : Arc (L := Point11) A) (hcard : A.card = 6) :
(brianchonPoints A).card ≤ 10`. Both consumers apply it as `dye1991_brianchon_bound hA hcard`
(`Q11DyeConsequences.lean:25`); neither consumer file was touched by the reviewed commits.

**Type agreement.** `ClebschDye.Point11 := Conic.Point (ZMod 11)`, and `Conic.Point K` is declared
(`Conic.lean:315`) as `abbrev Point K := ProjectiveBridge.Point K`, itself an abbrev of
`Projectivization K (Fin 3 → K)`. So the specialization `card_triplePoints_le_ten (K := K11)`
targets literally the same type, same global `Membership`/`ProjectivePlane` (orthogonality)
instances as the old axiom. Nothing about the incidence model changed.

**Definitional agreement of the two point sets.** `brianchonPoints A`
(`Q11DyeAxioms.lean:38-39`) and `SixArcConcurrence.triplePoints A`
(`SixArcConcurrence.lean:38-40`) are both
`(Finset.univ \ A).filter fun x => pointIndex (L := ·) A x = 3` over the same type with the same
`Membership` instance. The `Fintype` and `DecidableEq` instances are distinct local declarations in
the two files, but each is definitionally `Fintype.ofFinite _` respectively `Classical.decEq _`, so
the two Finset expressions are definitionally equal at default transparency; and even for arbitrary
instances they would be propositionally equal (`Fintype` is a subsingleton, so `univ` agrees;
`Finset.filter_congr_decidable` handles the predicate instance). The local instances cannot make
the two sets differ. Residual risk is only whether `simpa` bridges the instance constants during
elaboration (finding 2), which is cosmetic, not semantic.

**No trivialization or vacuity.** `card_triplePoints_le_ten` assumes `(2 : K) ≠ 0`, `Arc A`,
`A.card = 6` — exactly the hypotheses of the human theorem, all satisfiable (six-arcs exist over
`ZMod 11`, and the development exhibits one as `clebschWitness`). `triplePoints` counts off-arc
points with secant index exactly three; for a six-arc that coincides with "at least three" by the
matching bound (`pointIndex_le_half_card` in `Moments.lean`), and it is the same definition the
axiom's consumers already used, so no strengthening or weakening is smuggled in.
`not_collinear_diagonalPoints` describes the diagonal points by their defining collinearity
conditions rather than a construction; since the incidence `Collinear` predicate holds for any
degenerate triple (two equal points are collinear — see the degenerate cases in
`ProjectiveBridge.collinear_iff_projective_collinear`), the four non-collinearity hypotheses force
the quadrangle to be nondegenerate, and the theorem is not vacuous.

## Proof audit and elaboration predictions (question 2)

`QuadrangleDiagonal.lean` and `SixArcConcurrence.lean` are claimed elaborated (I could not re-run
the build under this review's constraints); I audited them line-by-line and found the linear
algebra and the incidence combinatorics correct. Details worth recording:

- `rep_eq_smul_add_of_opposite` (`QuadrangleDiagonal.lean:152`): in the frame `u` with
  `p4.rep = u0+u1+u2`, a point on both `p1p2` and `p3p4` has frame coordinates with `c2 = 0` (else
  `u0,u1,x.rep` independent, contradicting collinearity with `p1,p2`) and `c0 = c1` (else
  `u2, u0+u1+u2, x.rep` independent, contradicting collinearity with `p3,p4`), so
  `x.rep = c0 • (u0+u1)` with `c0 ≠ 0`. The coefficient bookkeeping in both independence
  subproofs is correct (checked by hand), as is the `_outer` variant for the `u1+u2` diagonal.
- `li_pairwise_sums` (`QuadrangleDiagonal.lean:64`): `2*g0 = e0+e1-e2` is where — and the only
  place where — `(2 : K) ≠ 0` enters the entire development. Correct.
- The `p2 ↔ p3` swap for the second diagonal point (`QuadrangleDiagonal.lean:389-400`) is sound:
  `mk`'s nonzero-proof argument is proof-irrelevant, and `hp4swap` re-derives the sum identity.
- `exists_pair_through` (`SixArcConcurrence.lean:48`): the three disjoint endpoint pairs through a
  triple-concurrence point cover `3 × 2 = 6 = |A|` points, hence partition the arc. Uses the arc
  hypothesis through `pairsThrough_pairwiseDisjoint` and `pointIndex_eq_card_pairsThrough` — both
  genuinely need it (secant-line injectivity). Correct.
- `collinear_complement` (`SixArcConcurrence.lean:122`): the chord of `x` through `c` has partner
  `r` with `r ∉ {a,b}` (disjointness from the chord `{a,b}`), `r ∉ e.1`, `r ≠ c`, and
  `A \ e.1 = {a,b,c,d}`, forcing `r = d`. Correct, including all twelve distinctness threadings.
- `card_triplePoints_le_ten_of_secant_bound` (`SixArcConcurrence.lean:257`): the double count is
  over incidences (triple point, endpoint pair) with the pair's line through the point;
  `Finset.sum_comm` on the indicator is the exchange; left side is `3·|B|` by the definition of
  `triplePoints`, right side is `≤ 2·15` using `card_arcPair` (`Nat.choose 6 2 = 15`). Correct.

`SixArcConcurrenceBound.lean` (not yet elaborated) — predicted failures:

1. **Will fail, line 46.** `obtain ⟨x, hx, y, hy, z, hz, hxy, hxz, hyz⟩ :=
   Finset.two_lt_card_iff.mp hgt`. Mathlib's `Finset.two_lt_card_iff` is the *flat* form
   `∃ a b c, a ∈ s ∧ b ∈ s ∧ c ∈ s ∧ a ≠ b ∧ a ≠ c ∧ b ≠ c`
   (`.lake/packages/mathlib/Mathlib/Data/Finset/Card.lean:802`), which destructures positionally
   as `⟨a, b, c, h₁, …, h₆⟩`. The written pattern matches the *bounded* form
   `Finset.two_lt_card : ∃ a ∈ s, ∃ b ∈ s, ∃ c ∈ s, …` (`Card.lean:813`). As written, `hx` binds
   the point `b` and `z` binds a membership proof, so the following
   `simp only [Finset.mem_filter] at hx hy hz` (line 47) errors on the non-proposition `hx`, and
   `obtain ⟨hxT, hxe⟩ := hx` (line 48) cannot destructure a point. **Fix:** replace
   `Finset.two_lt_card_iff.mp hgt` by `Finset.two_lt_card.mp hgt` (the pattern then matches
   exactly). Purely syntactic; the intended mathematics is right.
2. **Low-to-moderate risk, `Q11DyeAxioms.lean:59-60`.** The closing
   `simpa [brianchonPoints, SixArcConcurrence.triplePoints] using …` must identify Finsets built
   with the two files' distinct local `Fintype`/`DecidableEq` instance constants. These are
   definitionally equal (both `Fintype.ofFinite _` / `Classical.decEq _`), so the final defeq
   check should succeed; if `simp`'s reducible-transparency matching balks, the repair is a
   two-line bridging equation (`brianchonPoints A = SixArcConcurrence.triplePoints (L := Point11) A`,
   proved by `unfold`/`rfl` or `Finset.filter_congr_decidable` plus `Subsingleton.elim`), not a
   change of statement.
3. Line 86 `have hrank : Module.finrank K (Fin 3 → K) = 3 := by simp` — the identical idiom
   compiles in `ClebschGateway.lean`, so no failure expected. The remaining steps
   (`Finset.card_pos`, `card_sdiff_of_subset`, the `collinear_complement` argument orderings at
   lines 70-74, and the twelve-hypothesis application of `not_collinear_diagonalPoints` at lines
   87-95) were checked against the exact signatures and are consistent; I verified in particular
   that the permuted distinctness arguments for the `y` and `z` calls
   (`hac hab had (Ne.symm hbc) hcd hbd` and `had hab hac (Ne.symm hbd) (Ne.symm hcd) hbc`) are the
   correct substitutions.

None of the predicted failures indicates a mathematical gap.

## Faithfulness to the human proof (question 3)

- **The counting argument** (`3·n₃ = Σ_e d(e) ≤ 2·15`) is formalized with one benign change of
  viewpoint: the Lean count is over (point, secant) incidences rather than
  (edge, one-factor) incidences, and the per-edge bound `d(e) ≤ 2` becomes "at most two
  triple-concurrence points on a secant line". These are equivalent: a triple point on `line(e)`
  necessarily has `e` among its three chords (its chord set is `pairsThrough`, and `line(e)` passes
  through it), distinct triple points on the line give distinct pairings, and a one-factor's three
  chords can be concurrent at only one point. Nothing is assumed that the human proof derives.
- **The per-secant reduction** matches the plan's step 3 exactly: fix `a` off the secant, obtain
  chord partners `b, c, d` for the three putative triple points (`exists_partner_off_secant`),
  derive their distinctness from the shared-chord exclusion (`not_collinear_common_chord`, which is
  the human "two chords through two common points coincide, putting an arc point on the secant"),
  complete each pairing (`collinear_complement`), and contradict the diagonal-point
  non-collinearity on the secant line. The human proof's side remark that diagonal points are
  distinct from vertices is not needed in the Lean route, because the count is over `univ \ A` by
  definition and `not_collinear_diagonalPoints` needs no such hypothesis.
- **The characteristic-two exclusion** enters exactly once, as `(2:K) ≠ 0` in `li_pairwise_sums`,
  which is precisely the Fano step of the human proof. The human proof invokes "Fano's axiom holds
  in Desarguesian planes of odd order" as known; the Lean development *proves* it from the
  four-point normal form — the formalization is stronger than the note's citation-level step.
- **The arc hypothesis** is consumed at every place it is mathematically needed: secant-line
  injectivity (both counts), pairwise disjointness of chords through an external point, the
  two-point intersection of a secant with the arc (`ArcPair.mem_of_mem_arc_of_mem_line`), and the
  four non-collinearity hypotheses of the quadrangle. I looked for a step that silently needs more
  than stated and found none.
- **Scope difference, correctly declared:** the human proof is stated for Desarguesian planes of
  odd order; the Lean bound is proved for the coordinate model `PG(2,K)` over a finite field with
  `2` invertible (`[Fintype K]` is required by the counting). The formalization note states exactly
  this. The general-plane part (`SixArcConcurrence`) is plane-generic; only the Fano input is
  coordinate-specific — same architecture as the human argument.

## Findings

1. **`lean/RelativeConicArcs/SixArcConcurrenceBound.lean:46` — major (blocks elaboration).**
   Wrong destructuring for `Finset.two_lt_card_iff` (flat existential); the written pattern fits
   `Finset.two_lt_card` (bounded existential). Lines 47-48 then fail on mis-bound hypotheses.
   **Fix:** use `Finset.two_lt_card.mp hgt`. No mathematical content is affected.

2. **`lean/RelativeConicArcs/Q11DyeAxioms.lean:59-60` — minor (elaboration risk).** The `simpa`
   must cross two files' local `Fintype`/`DecidableEq` instance constants. They are definitionally
   equal, so this should close; if it does not, insert an explicit bridging equality between
   `brianchonPoints` and `triplePoints` rather than weakening either statement. Record after the
   gate run which form landed.

3. **`lean/RelativeConicArcs/SixArcConcurrence.lean:13-15 — required fix (header/statement
   disagreement).** The header says "This file proves that a six-arc in the projective plane over
   a field in which two is invertible has at most ten triple-concurrence points." This module
   contains no field, no coordinates, and not that theorem: it proves the conditional incidence
   count `card_triplePoints_le_ten_of_secant_bound` for an arbitrary finite projective plane; the
   ten-point theorem is in `SixArcConcurrenceBound.lean`. Under `lean/AGENTS.md` ("comments must
   agree with the elaborated statement"; a module header "must delimit its scope"), reword the
   header to state the reduction proved here and name the module that completes it.

4. **`lean/RelativeConicArcs/SixArcConcurrence.lean:21` — required fix (unwitnessed strength
   claim).** "The bound is sharp: it is attained by the six-arcs classically called Clebsch
   hexagons." Sharpness is a mathematical strength claim; `lean/AGENTS.md` permits it only to the
   exact extent witnessed by a named theorem or an exact citation. No Lean theorem in the closure
   witnesses attainment, and no citation is given. **Fix:** delete the sentence, or cite Dye 1991
   in full (authors, title, journal, year, DOI, pinpoint) as the source of the attainment
   statement, or point to the exact Lean declaration once one exists.

5. **`lean/RelativeConicArcs/SixArcConcurrenceBound.lean:17-18` — required fix (uncited
   attribution asserting an unproved classification).** "Classically the bound is Dye's
   inequality … and it is sharp: the six-arcs attaining it are the Clebsch hexagons." Two
   problems: (a) "Dye's inequality" is a bare author reference — `lean/AGENTS.md` requires
   authors, title, year, stable identifier, and pinpoint for external results; (b) "the six-arcs
   attaining it **are** the Clebsch hexagons" is exactly the equality classification that remains
   a declared axiom, asserted here as fact without attribution. **Fix:** give the full Dye 1991
   citation (as in `Q11DyeAxioms.lean:13-17`) and phrase the equality case as Dye's theorem, not
   as an established fact of this development; or drop the sentence.

6. **`lean/RelativeConicArcs/Q11DyeAxioms.lean:8-17` — required fix (stale trust-boundary
   header).** The module header still reads "The paper needs two consequences of Dye's equality
   classification … They are stated here … so every downstream `#print axioms` exposes the precise
   external input" and "The two declarations below specialize the ten-point bound … and the
   equality classification," presenting both declarations as the external Dye boundary. The bound
   is now proved internally; only the equality classification is an external input. Under
   `lean/AGENTS.md` (trust boundary must be stated accurately; comments must agree with the
   change) the header must be rewritten in the same change: say that the ten-point bound is a
   theorem derived from `SixArcConcurrence.card_triplePoints_le_ten`, and that the single
   remaining external input is Dye's equality classification. Consider whether the filename
   `Q11DyeAxioms` (plural) should be revisited when the second axiom falls; renaming now would
   churn imports and gates for no verification gain, so I do not require it.

7. **`lean/trust/areas/relconic.toml:22` — minor (stale trust registry entry).**
   `permitted_axioms` still lists `RelativeConicArcs.ClebschDye.dye1991_brianchon_bound`. Once the
   declaration is a theorem the entry is dead weight and misdescribes the portfolio axiom map; the
   plan itself says these entries are deleted rather than re-anchored. Delete the bound's entry in
   the same validated change that lands the gate run (registry edits belong to the owning build
   window). Not unsound — a permitted axiom that no longer exists cannot be silently reintroduced
   by it — but it must not survive to the referee-facing artifact.

8. **`lean/RelativeConicArcs/QuadrangleDiagonal.lean:14-15` — minor (unformalized converse stated
   as fact).** "In characteristic two the statement fails: there the three diagonal points are
   always collinear …" is true classical mathematics but is not proved in this artifact, and the
   header does not mark it as outside the formalized scope. Add a qualifier ("classically") or a
   citation, so the header does not imply a formalized biconditional.

9. **`lean/RelativeConicArcs/SixArcConcurrenceBound.lean:37` — optional (name).**
   `card_filter_line_le_two` names the implementation (`filter`, `line`) rather than the
   proposition. A mathematical name such as `card_triplePoints_on_secant_le_two` would meet the
   naming standard better. Optional since the declaration is new and unconsumed elsewhere; if
   renamed, do it before anything imports it.

## The formalization note (question 5)

`notes/2026-08-04-c855-dye-bound-formalization.md` is accurate on every load-bearing claim I could
check: the statement-identity claim is verified against the diff; the field-generality claim
matches the elaborated hypotheses (`[Fintype K]`, `(2:K) ≠ 0`); the description of each lemma in
`SixArcConcurrence` matches its actual statement; and the note correctly discloses that
`SixArcConcurrenceBound` and the rewritten `Q11DyeAxioms` are unelaborated and that single-file
elaboration is a smoke test, not a gate. Two caveats: (a) the claimed clean elaboration of
`QuadrangleDiagonal`/`SixArcConcurrence` and the axiom print
(`propext`, `Classical.choice`, `Quot.sound`) could not be independently re-run under this
review's no-build constraint — the gate run remains the acceptance evidence, as the note itself
says; (b) the note does not mention that the draft in `SixArcConcurrenceBound` cannot elaborate as
written (finding 1) — "supplies the missing per-secant bound … and concludes" should be read as
"is written to conclude". Neither caveat is an over-claim about proved mathematics. One plan-level
loose end: the plan says the private determinant criterion in `ProjectiveBridge` "this work makes
public"; the landed route (four-point normal form) never needed it, and it is still private —
harmless, but the plan should not be cited as a description of what landed.

## Summary for acceptance

Required before the task can claim the axiom eliminated: fix finding 1, elaborate
`SixArcConcurrenceBound` and `Q11DyeAxioms` through the gate
`RelativeConicArcs.Gates.ClebschRigidityTrust` with its axiom audit (as already planned), and land
the prose fixes of findings 3-6 (headers must not misstate scope, strength, or the trust boundary
in a referee-facing artifact). Findings 7-9 can ride the same window. Subject to those fixes and a
green gate, the first Dye axiom is genuinely eliminated: the replacement proof is faithful to the
human argument, is stated at strictly greater generality than the axiom it replaces, and imports
no new assumption beyond `(2 : K) ≠ 0`.
