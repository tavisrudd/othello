# Referee review, 2026-08-07: outer Joubert frame, matching frame, Segre–Igusa polar, cross-golden determinant

Scope reviewed: `lean/RelativeConicArcs/ClebschOuterJoubertFrame.lean`,
`lean/RelativeConicArcs/ClebschOuterMatchingFrame.lean`,
`lean/RelativeConicArcs/SegreIgusaPolar.lean`,
`lean/RelativeConicArcs/CrossGoldenDeterminant.lean`, and the module header plus
`#print axioms` block of `lean/RelativeConicArcs/Gates/ClebschGoldenReturn.lean`, against
`papers/clebsch-passages/sections/05-golden-operator.tex` (outer six-family paragraph, table (5.1),
Theorem "Golden operator and classical cubic shadows") and the displayed matrix of
`papers/clebsch-passages/sections/03-orientation-source.tex`.

No Lean, `lake`, or build was run. Every statement was read as elaborated text; every constant and
finite table was recomputed from scratch in independent scripts.

## Verdict

**Accept with repairs.** Every Lean statement I checked is true, and the finite tables are
independently correct. The mathematics closes clauses 1, 3, 4, and 6 of the manuscript list, and
closes clause 2 in a Pfaffian surrogate form that is explicitly disclosed. Two defects must be
fixed before this is referee-ready: a **false justification in a module header that also leaves a
theorem strictly weaker than provable** (finding 1), and a **wrong row in the printed table (5.1)**
of the manuscript, which the Lean table does not share (finding 2). The remaining findings are
scope-versus-prose mismatches and naming/precision repairs.

## Findings

1. **CONFIRMED — false reason, and an avoidably weak conclusion.**
   `CrossGoldenDeterminant.lean` header (lines 34–38) and
   `Gates/ClebschGoldenReturn.lean` header (lines 74–77) both assert: "The sign is not determined by
   these hypotheses: replacing `s` by `-s` exchanges the two projectors and negates the Pfaffian, so
   the sign records an orientation of the two spectral spaces rather than a property of `C`."
   The premise is true and the inference is invalid: replacing `s` by `-s` negates
   `Pf(B - Bᵀ)` *and* negates the factor `10 s`, so the product `10 s Pf(B - Bᵀ)` is unchanged.
   I verified symbolically in `x₀,…,x₅` over `Q(√5)` that
   `Z(x) - 10 s Pf(B(x) - B(x)ᵀ) = 0` identically for **both** `s = +√5` and `s = -√5`, and
   sampled the same identity in `F₁₁` for both square roots `s = 4` and `s = 7`.
   Consequently `RelativeConicArcs.CrossGoldenDeterminant.triangleCubic_eq_or_eq_neg` states a
   disjunction where the equality `triangleCubic … = 10 * s * pfaffianSix (…)` is provable: the
   universal ring `ℤ[1/2, s]/(s² - 5) = ℤ[1/10][√5]` is a domain that embeds in `Q(√5)`, all the
   objects are its base changes, so the verified equality there transfers to every `R` satisfying
   the hypotheses — no `IsDomain R` hypothesis is even needed. Repair: prove the equality and drop
   both the disjunction and the two header sentences, or state the true reason for a sign choice
   (it arises only for the *basis-dependent* 3×3 determinant of the manuscript, not for the
   Pfaffian).

2. **CONFIRMED — printed table (5.1) has exactly one wrong row; the Lean table is right.**
   The author's claim that exactly one printed row is wrong is correct. The bad row is `r = 2`,
   `p₂ = 012435`, and **six** entries are wrong: the last six signs, i.e. the coefficients of the
   triples `135, 145, 234, 235, 245, 345` (positions 15–20 of the stated coefficient order), are
   each printed with the opposite sign.
   - printed: `+ - + - + - - - + + - - + + - + - + - +`
   - correct: `+ - + - + - - - + + - - + + + - + - + -`
   The printed row is not even a two-graph word: it violates the four-point identity, while all
   five other printed rows satisfy it. `ClebschOuterJoubertFrame.outerColouring` row 2 agrees with
   my recomputation, so the defect is confined to `sections/05-golden-operator.tex` line 62.

3. **CONFIRMED — the exhibited representatives do not have the manuscript's `C_T`.**
   The manuscript says "Choose representatives `C_T` whose triangle products are `ε_T`."
   `ClebschOuterJoubertFrame.outerConference t` is the plain relabelling
   `conferenceMatrix.submatrix (p_t⁻¹) (p_t⁻¹)`, whose triangle products equal the row word only
   when `sgn(p_t) = +1`. I checked directly: for `t = 1, 2, 5` (the odd reorderings) the triangle
   products of `outerConference t` are the **negatives** of `outerColouring t`. The Lean docstrings
   are accurate about this (`outerColouring_eq_smul_triangleSign_outerConference` carries the
   `outerSign` factor), but the header calls `outerConference t` "the conference matrix carrying the
   `t`-th member of the outer family", which is the manuscript's `C_T` only up to that sign twist.
   Repair is one line: add `outerSign t • outerConference t` as the marked representative
   (negation preserves `C² = 5 • 1`, zero diagonal and unit off-diagonal squares) and state
   `triangleSign` of it equals the row word.

4. **CONFIRMED — clause 2 is closed only in Pfaffian form.**
   The manuscript clause is `Z_T(x) = ±10√5 det B_T(x)` for the 3×3 matrix of the basis-free map
   `B_T(x) : V_{T,+} → V_{T,-}`. Lean proves `Z² = 500 · det(B - Bᵀ)` and
   `Z = ±10 s · Pf(B - Bᵀ)` for the **6×6** matrices; note that `det` of the 6×6 `crossGoldenBlock`
   itself is identically `0` (rank ≤ 3), which I confirmed symbolically, so the manuscript's `det`
   cannot be read on the Lean object. The header discloses this ("the comparison with the
   determinant of a three-by-three matrix … is not formalized"), which is admissible under
   `lean/AGENTS.md`. I separately confirmed numerically over the reals, with orthonormal frames of
   the two eigenspaces, that `Z / (10√5 · det B₃ₓ₃) = 1`, so the manuscript's constant `10√5` and
   its genuine `±` (frame-orientation) are correct. No repair required beyond keeping the paper's
   cross-reference honest about what the gate does and does not certify.

5. **CONFIRMED — the "diagonal Clebsch section" prose claims geometry the type does not carry.**
   `SegreIgusaPolar.sum_erase_eq_zero_of_apply_eq_zero` and
   `sum_pow_three_erase_eq_zero_of_apply_eq_zero` say only that deleting a vanishing coordinate
   preserves a vanishing sum and a vanishing cube sum; both proofs are a rewrite plus `sub_zero`.
   The module header (lines 15–18), the docstring of the cube version, and
   `Gates/ClebschGoldenReturn.lean` lines 54–57 nevertheless assert that "the linear relation cuts
   the hyperplane down to a three-dimensional projective space and the cubic relation is the
   equation of the diagonal cubic surface on it". Nothing about projective dimension, about the
   surface being *the* diagonal Clebsch cubic, or about its smoothness is formalized. Under
   `lean/AGENTS.md` ("Do not use comments to imply a stronger theorem than Lean checks") the prose
   must be cut back to the five-term identities.

6. **CONFIRMED — the "indexed by the six one-factorizations" bijection is not exported.**
   `ClebschOuterMatchingFrame` proves: the six listed families are one-factorizations
   (`isOneFactorization_oneFactorization`), their colourings are the six pairwise distinct words
   (`matchingColouring_oneFactorization`, `outerColouring_injective`), and **every**
   one-factorization colours as one of those words
   (`exists_outerColouring_of_isOneFactorization`). That gives surjectivity onto the six words, not
   injectivity on one-factorizations, so the manuscript's "indexed by" (a bijection) is not
   witnessed. The missing half is available from the private `rooted_classification` but is not
   stated. Repair: export `∃ σ : Equiv.Perm (Fin 5), ∃ t, F ∘ σ = oneFactorization t`.

7. **CONFIRMED — the gate says "the six one-factorizations", which is false for the formalized
   notion.** `Gates/ClebschGoldenReturn.lean` line 46–48 writes "the complementary triangle
   colourings of the six one-factorizations of the complete graph on the six labels".
   `IsOneFactorization` is a predicate on *colour-indexed* families `F : Fin 5 → Fin 6 → Fin 6`;
   I enumerated these independently and there are **720** of them, six only after quotienting by
   the `5! = 120` colour renamings. The module header of `ClebschOuterMatchingFrame` is careful
   here (it claims exactly six *colourings*); the gate is not. Fix the gate wording.

8. **CONFIRMED — the finite-domain enumeration in the Joubert header does not match the module.**
   `ClebschOuterJoubertFrame.lean` lines 25–28 list the kernel-decision domains as "six
   reorderings, thirty-six index pairs, twenty triples, or the four hundred and twenty five-element
   index tuples they generate." No decision in the module has a 420- or 425-element domain. The
   actual domains are 36 (`outerReindex_outerReindexInverse`), 20
   (`tripleLabel_strictMono`), 400 ordered pairs (`tripleLabel_injective`), 120
   (`outerColouring_sq`, `outerColouring_eq_smul_triangleSign`), and 720
   (`outerColouring_injective`, function equality on `Fin 20` over 36 index pairs). Contrast
   `ClebschOuterMatchingFrame.lean` lines 46–50, whose counts (30, 120, `5 · 6⁵`, `3⁵ = 243`) I
   checked and which are all correct. Rewrite the Joubert list.

9. **SUSPECTED — `rooted_classification` is a strength-bearing name not witnessed by its own type.**
   `ClebschOuterMatchingFrame.rooted_classification` (private) concludes only `∃ t, … =
   oneFactorization t`; that each of the six occurs and that they are distinct lives in
   `isOneFactorization_oneFactorization` and `oneFactorization_injective`, which the docstring does
   not name. `lean/AGENTS.md` permits `classification` only when the type proves it or the
   docstring points to the exact theorem that does. Either rename (e.g.
   `exists_eq_oneFactorization_of_rooted`) or cite the two companions in the docstring. The
   docstring's "selects exactly the six listed families" is stronger than the `∃` it decorates.

10. **SUSPECTED — unresolvable reference "the manuscript".**
    `SegreIgusaPolar.lean` lines 11 and 21 ("the two constructions the manuscript performs", "six
    times the manuscript's centered square") and `Gates/ClebschGoldenReturn.lean` line 65 name no
    document, so a reader holding only the Lean artifact cannot resolve them; `lean/AGENTS.md`
    forbids relying on "as in the paper". This pattern is repository-wide (it appears in a dozen
    other `RelativeConicArcs` modules), so it is legacy rather than newly introduced, but the rule
    has no grandfathering for a touched module. Replace with the mathematical description already
    present a sentence later ("the centered square `z_t² - (1/6)∑z²`, here cleared of denominators").

11. **SUSPECTED — minor over-reach in two small docstrings.**
    `ClebschOuterJoubertFrame.tripleLabel_injective`: "so the list is exactly the set of
    three-element subsets of the six labels" requires the count `C(6,3) = 20`, which is not in
    Lean. `SegreIgusaPolar` header: "so it holds for the centered squares themselves in any ring
    where six is invertible" is true and easy but not formalized. Both are one-sentence fixes
    (state them as remarks the reader can check, or formalize).

12. Not a defect, recorded for the record: I found **no** task IDs, lane names, dates, agent or
    session references, status prose, `TODO`/`FIXME`, or novelty/priority language in any of the
    four modules or the gate header. Every one of the 36 `#print axioms` entries the gate adds for
    these modules resolves to a declaration that exists in the named module; the declarations left
    out are auxiliary (`outerReindex_outerReindexInverse`, `outerConference_apply`,
    `triangleSign_outerConference`, `outerColouring_eq_smul_triangleSign_outerConference`,
    `isOneFactorization_comp`, `sameMatching_comp`, `bracketMatrix_eq_commutator`,
    `crossGoldenBlock_transpose`).

## What I recomputed

Scripts under
`/tmp/claude-1000/-home-tavis-src-othello-rust/552ffe53-3569-4861-a01d-5c6eeebf919b/scratchpad/referee/`
(`check1.py` … `check6.py`, `parse_table.py`); table (5.1) was parsed mechanically out of the TeX
source rather than transcribed by hand.

Checked independently, without reusing any repository table:

- The matrix of `sections/03-orientation-source.tex` is symmetric, zero-diagonal, `±1` off the
  diagonal, and `C² = 5I`; it is entrywise identical to
  `ClebschGoldenConference.conferenceMatrix`.
- Its twenty triangle products in increasing-triple order; they match
  `conference_triangleSigns` and row 0 of both tables, and satisfy the four-point identity on all
  fifteen four-subsets.
- All six rows of `outerColouring` from the manuscript rule `ε_{pT₀}(S) = sgn(p) ε_{T₀}(p⁻¹S)`,
  using the six permutations printed in table (5.1): all six agree with the Lean table; each
  satisfies the four-point identity; the six are pairwise distinct.
- The same six rows against the *printed* table: five agree, row `r = 2` differs in six entries
  (finding 2), and only that printed row fails the four-point identity.
- The triangle products of each relabelled representative against its row word (finding 3).
- All 15 perfect matchings and all one-factorizations of `K₆` by my own enumeration: 6 unordered,
  720 colour-indexed. I reimplemented the complementary triangle colouring from the definition in
  `ClebschOuterMatchingFrame` (cross-incidence matrix between the three edges inside a triple and
  the three inside its complement, determinant, times `(-1)^{σ(S)-3}`); every cross-incidence
  matrix is a permutation matrix, the six one-factorizations give exactly the six Lean words, and
  each of Lean's six listed families is a genuine one-factorization producing its own listed row.
- Exact arithmetic in `Q(√5)` on random coordinate vectors: `P±` symmetric, idempotent, summing to
  `1`; `[D_x, C]` entrywise `(x_i - x_j)C_{ij}`; `[D_x, C] = 2s(B - Bᵀ)`; `(2s)⁶ = 8000`;
  `det[D_x, C] = 16 Z²`; `Z² = 500 det(B - Bᵀ)`; `det(B - Bᵀ) = Pf(B - Bᵀ)²` with Lean's exact
  `pfaffianSix` expansion; and `Z = +10 s Pf` on every trial. Then symbolically in the six
  coordinates for both `s = ±√5`, and by sampling in `F₁₁` for both square roots (finding 1).
  Also `det(6×6 P₋D_xP₊) = 0`, and, numerically over the reals with orthonormal eigenframes,
  `Z = 10√5 det B₃ₓ₃` (finding 4).
- The power-sum identity `48p₈ = 12p₄² - 12p₂²p₄ + p₂⁴ + 32p₂p₆` on random rational points of the
  Segre cubic; `∑V = 0` and `(∑V²)² = 4∑V⁴` for `V_t = 6z_t² - p₂` and for the undivided
  `W_t = z_t² - p₂/6`; and the same for the six outer cubics at random integer coordinates
  (`∑Z = ∑Z³ = 0`).
- The two polynomial certificates: the `linear_combination` witness inside
  `SegreIgusaPolar.power_sum_relation` reduces to `0` symbolically, as does the `-108 · key`
  step in `igusa_relation_of_segre` together with the coefficients of `sum_shifted_sq` and
  `sum_shifted_pow_four`.
- Consistency of `sixteen_mul_centeredSquare_outerCubic` with the manuscript's
  `W_T = (1/16) center_T det[D_x, C_T]`, including that `det bracketMatrix C (x ∘ p)` equals
  `det bracketMatrix (outerConference t) x` by simultaneous row/column permutation.

Not checked: nothing was elaborated or built, so I certify no proof *term*, only that each stated
proposition is true and says what the surrounding prose claims. I did not review the balanced
exchange modules, `ClebschTwoGraph`, the middle-exterior modules, or any other part of the gate's
verification closure. I did not verify that the cited HMSV normalization agrees with these sign
words, nor any citation content, nor Theorem "Balanced exchange rigidity" or "Aligned-design
faithfulness" in the same manuscript section.
