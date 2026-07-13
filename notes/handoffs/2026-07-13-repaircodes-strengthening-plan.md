# RepairCodes paper-strengthening plan — C104/C105

**Date**: 2026-07-13
**Status**: PLANNED. Neither proposed strengthening is a theorem or a paper claim yet.
**Parent track**: [completed RepairCodes formalization](2026-07-11-lean-formalization-plan.md)
**Paper**: [`coding-repair-hypergraphs`](../../papers/coding-repair-hypergraphs/README.md)

## Goal and strict ledger

Land two optional mathematical strengthenings under the existing strict trust and novelty gates.
No manuscript theorem, abstract claim, paper-index result, or novelty claim changes until its Lean
theorem, axiom audit, primary-source check, and adversarial review all pass.

| Task | Proposed result | Current status | Permitted wording now |
|---|---|---|---|
| C104 | Every cubic coordinate has `ν=(q−1)/2`, hence exact row `((q−1)/2,q−2)` | `PROOF SKETCH`; algebraic construction identified, not checked | “candidate exact formula” |
| C105 | Neither numerical transfer gate can be weakened uniformly | `PROOF PLAN`; counterexample mechanisms identified, not checked | “planned boundary audit” |

The existing paper remains complete without either result. C104 would replace a genuine general-`q`
matching gap. C105 would establish best-possible uniform hypotheses, not necessity for each fixed
inner/outer pair.

## C104 — exact cubic-coordinate matching

### Target statement

For every finite field `F` of characteristic three and every cubic target `x`, prove

```text
matchingNumber (axisTwistedCubicRepairHypergraph (.inl x) 3)
  = (Fintype.card F - 1) / 2.
```

Together with the existing `cubicRepair_transversalNumber`, this gives the exact cubic row
`((q−1)/2,q−2)` for all `q=3^h`. The existing upper bound supplies the `≤` direction.

### Mathematical reduction to verify

For helpers `s,t≠x`, set `u=(s−x)⁻¹` and `v=(t−x)⁻¹`. In characteristic three, the completing axis
point should be

```text
∞                         if u+v=0,
finite (-x + (u+v)⁻¹)     otherwise.
```

Thus completion colors are equal exactly when `u+v` is equal. If `g` generates `Fˣ`, pair
`g^(2i)` with `g^(2i+1)`. These pairs partition `Fˣ`, and their sums
`(1+g)g^(2i)` are distinct (with the `q=3` singleton case handled separately). Mapping back through
`s=x+u⁻¹` should produce a matching of `(q−1)/2` repair edges.

### Falsification and proof gates

1. Check the shifted-inverse color identity symbolically and on `q=3,9,27`; computations are
   evidence only.
2. Check all exceptional branches explicitly: `u+v=0`, `q=3`, target translation, distinctness,
   and the normalized infinity-axis coordinate.
3. Prove an abstract finite-field rainbow-pair lemma or construct the repair matching directly;
   prefer the smallest reusable API that avoids exponent-index bookkeeping in the paper theorem.
4. Prove the lower bound in Lean and combine it with `cubicRepair_matchingNumber_le`.
5. Run `#print axioms`, the RepairCodes forbidden-token scan, the focused build, and the aggregate
   OOM-safe `lake build RepairCodes` gate.

### Novelty and literature gate

Search primary sources and citation chains in four distinct lanes:

- rainbow and perfect-rainbow matchings in properly edge-coloured complete graphs;
- strong starters, complete mappings, orthomorphisms, and finite-field one-factorizations;
- twisted-cubic/axis circuit, incidence, coset-weight, and covering-code literature;
- LRC availability/tolerance papers computing exact matching numbers of complete repair families.

Record separately whether the power-pair construction is classical (likely) and whether its use to
compute this code-derived repair invariant was located. Formal correctness must not be used as
novelty evidence. Allowed final novelty language remains “candidate contribution; none found” unless
the specialist gate justifies more.

### Paper landing if all gates pass

- Replace the cubic bounds by the exact formula in the abstract, contributions, theorem, and proof.
- Strengthen the all-symbol table/formulas without changing the q9 or asymptotic constants.
- Update the proof ledger, adversarial novelty review, TRUST manifest, paper index, README, handoff,
  and PDF in the same commit.

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
