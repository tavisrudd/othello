# RepairCodes paper-strengthening plan — C104/C105

**Date**: 2026-07-13
**Status**: ACTIVE. C104 is complete and reported. C105 is next and is not yet a theorem or paper
claim.
**Parent track**: [completed RepairCodes formalization](2026-07-11-lean-formalization-plan.md)
**Paper**: [`coding-repair-hypergraphs`](../../papers/coding-repair-hypergraphs/README.md)

## Goal and strict ledger

Land two optional mathematical strengthenings under the existing strict trust and novelty gates.
No manuscript theorem, abstract claim, paper-index result, or novelty claim changes until its Lean
theorem, axiom audit, primary-source check, and adversarial review all pass.

| Task | Proposed result | Current status | Permitted wording now |
|---|---|---|---|
| C104 | Every cubic coordinate has `ν=(q−1)/2`, hence exact row `((q−1)/2,q−2)` | `REPORTED 2026-07-13`; all gates pass | Exact theorem; pairing itself is classical-adjacent, application is candidate novelty |
| C105 | Neither numerical transfer gate can be weakened uniformly | `PROOF PLAN`; counterexample mechanisms identified, not checked | “planned boundary audit” |

C104 closes the former general-`q` matching gap and is now part of the paper. The paper remains
complete if C105 fails. C105 would establish best-possible uniform hypotheses, not necessity for
each fixed inner/outer pair.

## C104 — exact cubic-coordinate matching

### Target statement

For every finite field `F` of characteristic three and every cubic target `x`, prove

```text
matchingNumber (axisTwistedCubicRepairHypergraph (.inl x) 3)
  = (Fintype.card F - 1) / 2.
```

Together with the existing `cubicRepair_transversalNumber`, this gives the exact cubic row
`((q−1)/2,q−2)` for all `q=3^h`. The existing upper bound supplies the `≤` direction.

### Checked proof

For helpers `s,t≠x`, set `u=(s−x)⁻¹` and `v=(t−x)⁻¹`. In characteristic three, the completing axis
point is

```text
∞                         if u+v=0,
finite (-x + (u+v)⁻¹)     otherwise.
```

Thus completion colors are equal exactly when `u+v` is equal. If `g` generates `Fˣ`, pair
`g^(2i)` with `g^(2i+1)`. These pairs partition `Fˣ`, and their sums
`(1+g)g^(2i)` are distinct (with the `q=3` singleton case handled separately). Mapping back through
`s=x+u⁻¹` produces a matching of `(q−1)/2` repair edges. The checked declarations are
`FiniteGeom.units_addColor_matchingNumber_lower`,
`twistedCubicTripleAxisIndex_eq_cubicRepairSumColor`,
`cubicRepair_matchingNumber_ge_half`, and `cubicRepair_matchingNumber`.

### Falsification and proof gates

1. `[DONE]` Exhaustive evidence at `q=3,9,27` checked every target/helper pair and the full matching.
2. `[DONE]` Lean handles `u+v=0`, `q=3`, target translation, distinctness, and infinity explicitly.
3. `[DONE]` `FiniteGeom.ExplicitRainbowMatching` isolates the reusable combinatorial core.
4. `[DONE]` Lean combines the explicit lower bound with `cubicRepair_matchingNumber_le`.
5. `[DONE]` The axiom audit, forbidden-token scan, focused build, aggregate OOM-safe
   `lake build RepairCodes`, TeX/PDF build, and paper consistency pass all succeed.

### Novelty and literature gate

Search primary sources and citation chains in four distinct lanes:

- rainbow and perfect-rainbow matchings in properly edge-coloured complete graphs;
- strong starters, complete mappings, orthomorphisms, and finite-field one-factorizations;
- twisted-cubic/axis circuit, incidence, coset-weight, and covering-code literature;
- LRC availability/tolerance papers computing exact matching numbers of complete repair families.

The construction lies in the classical neighborhood of finite-field half-set and constant-quotient
one-quotient starters (Dinitz 1984; modern quotient-starter terminology in Alfaro--Rubio-Montiel--
Vázquez-Ávila 2017). It is not always a starter and Lean needs only partition plus distinct sums.
No checked twisted-cubic, repair-code, or LRC source was found that uses the shifted-inverse identity
to compute this matching invariant. Permitted posture: pairing pattern prior/adjacent; code-derived
application candidate contribution, none found. Formal correctness is not novelty evidence.

### Paper landing

- The abstract, contributions, cubic theorem/proof, prior-work posture, proof ledger, adversarial
  novelty review, TRUST manifest, paper index, and README now state the exact formula.
- The q9 rows and asymptotic constants are unchanged. The PDF is rebuilt from the synchronized
  source.

## C105 — transfer-gate boundary theorem

### Target statement

Prove two explicit kernel-checked counterexamples establishing:

1. replacing `r+1 < 2*d(I⊥)` by the non-strict boundary cannot preserve complete repair
   hypergraphs uniformly; and
2. replacing outer functional-dual distance `≥r+2` by `≥r+1` cannot preserve them uniformly.

The conclusion must be stated as **uniform non-weakenability**. It must not say either gate is
necessary for every fixed concatenation.

### Counterexample mechanisms to formalize

**Inner boundary.** Put minimum inner-dual words in two different blocks. At
`r+1=2*d(I⊥)` their sum is a bounded concatenated dual word spanning two blocks, hence an extra
repair edge. Use a full outer space so its functional dual is zero and the outer gate is isolated.

**Outer boundary.** Use an inner code with the strict inner gate and an outer code having a
functional-dual word of weight exactly `r+1` whose component functionals admit weight-one block
representatives. The induced cross-block word is an extra radius-`r` repair. Start with the smallest
repetition/single-parity-check example; add a radius-three/q9-flavoured instance only if it remains
cheap and clarifies the manuscript.

### Proof and formalization gates

1. State generic witness lemmas: a two-block inner-dual sum creates an extra edge; a light
   outer-functional word creates an extra edge.
2. Instantiate the witness lemmas with tiny explicit finite codes and prove their exact relevant
   dual distances by kernel reduction or elementary linear algebra.
3. Prove literal inequality of the concatenated and embedded inner repair hypergraphs, not merely
   existence of a cross-block dual word.
4. Audit edge radius, target coefficient, block support, and nondegeneracy/off-by-one conditions.
5. Run the same axiom, forbidden-token, focused-build, and aggregate-build gates as C104.

### Novelty and literature gate

Search primary sources and citation chains for:

- duals and low-weight dual words of concatenated/generalized-concatenated codes;
- necessary versus sufficient locality-preservation hypotheses;
- block-confinement, outer-dual-distance, and support-enumerator results;
- counterexamples or sharpness statements for recovery-set preservation under concatenation.

Classify separately the elementary counterexample idea, the exact numerical boundary, and the
complete-hypergraph formulation. A known coding-theory observation may still be useful referee
hardening, but must be labeled prior if found.

### Paper landing if all gates pass

- Add a short proposition and examples immediately after the transfer theorem.
- Use “cannot be weakened uniformly” or “best possible for a uniform theorem,” never unqualified
  “necessary” or “sharp for every code.”
- Update the same proof, novelty, trust, registry, handoff, and PDF surfaces as C104.

## Order, dependencies, and completion criteria

Recommended order: **C104 first**, then C105. They are mathematically independent.

C104 is complete only when the exact general theorem is Lean-checked, the starter/rainbow and
coding-geometry searches are recorded, the paper is synchronized, and the full validation gate
passes. C105 is complete only when both numerical boundaries have explicit Lean counterexamples,
the wording is restricted to uniform non-weakenability, the concatenation literature audit is
recorded, and the same package-wide consistency gate passes.

If either construction fails, preserve the falsification and exact surviving boundary in the
companion/archive record; do not weaken the live ledger into ambiguous “in progress” prose.
