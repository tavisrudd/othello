# RepairCodes paper-strengthening plan — C104/C105

**Date**: 2026-07-13
**Status**: COMPLETE. C104 and C105 are reported; their Lean, paper, trust, novelty, registry, and
build gates pass.
**Parent track**: [completed RepairCodes formalization](../2026-07-11-lean-formalization-plan.md)
**Paper**: [`complete-repair-ports`](../../../papers/complete-repair-ports/README.md)

## Goal and strict ledger

Land two optional mathematical strengthenings under the existing strict trust and novelty gates.
No manuscript theorem, abstract claim, paper-index result, or novelty claim changes until its Lean
theorem, axiom audit, primary-source check, and adversarial review all pass.

| Task | Proposed result | Current status | Permitted wording now |
|---|---|---|---|
| C104 | Every cubic coordinate has `ν=(q−1)/2`, hence exact row `((q−1)/2,q−2)` | `REPORTED 2026-07-13`; all gates pass | Exact theorem; pairing itself is classical-adjacent, application is candidate novelty |
| C105 | Neither numerical transfer gate can be weakened uniformly | `REPORTED 2026-07-13`; all gates pass | Best possible for the uniform theorem; no fixed-code necessity claim |

C104 closes the former general-`q` matching gap. C105 establishes best-possible uniform transfer
hypotheses, not necessity for each fixed inner/outer pair. Both are now part of the paper.

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

### Checked statement

Two explicit kernel-checked counterexamples establish:

1. replacing `r+1 < 2*d(I⊥)` by the non-strict boundary cannot preserve complete repair
   hypergraphs uniformly; and
2. replacing outer functional-dual distance `≥r+2` by `≥r+1` cannot preserve them uniformly.

The conclusion must be stated as **uniform non-weakenability**. It must not say either gate is
necessary for every fixed concatenation.

### Checked counterexamples

**Inner boundary.** Over `GF(3)`, the length-two repetition inner code has dual distance two. At
radius three, the sum of `(1,-1)` in each of two blocks has support four and gives a three-helper
cross-block repair. The full two-symbol outer space has zero functional dual, isolating the equality
`r+1=2*d(I⊥)`. Lean proves the named edge belongs to the complete concatenated repair hypergraph
and not to the embedded inner hypergraph.

**Outer boundary.** Use the same inner code at radius two, where `3<2*2`. The three-symbol
single-parity-check outer code has exact functional-dual distance three, proved by elementary linear
algebra. Selecting coordinate zero in each inner block gives a weight-three concatenated dual word
and a two-helper repair spanning all three blocks. Lean again proves literal hypergraph inequality.

### Proof and formalization gates

1. `[DONE]` The explicit words, repairs, and code membership are separately named and reusable.
2. `[DONE]` Exact inner dual distance two and exact outer functional-dual distance three are proved.
3. `[DONE]` Both headlines prove literal inequality of complete finite repair hypergraphs.
4. `[DONE]` Radius, target coefficient, cross-block support, nonzero codes, and off-by-one values
   are explicit in the theorem statements.
5. `[DONE]` Focused and aggregate builds, axiom reports, and forbidden-token scans pass. Closed
   finite support facts use kernel `decide`, never `native_decide`.

### Novelty and literature gate

The primary-source audit covered:

- duals and low-weight dual words of concatenated/generalized-concatenated codes;
- necessary versus sufficient locality-preservation hypotheses;
- block-confinement, outer-dual-distance, and support-enumerator results;
- counterexamples or sharpness statements for recovery-set preservation under concatenation.

Kurz--Yaakobi, arXiv:2001.03433 / DOI 10.1007/s10623-020-00828-6, Lemma 10(a), explicitly gives
the elementary dual-distance obstruction between two distinct recovery sets. Accordingly, the
two-block mechanism is prior/elementary and is not marketed as new. No checked source was found
stating both exact thresholds for literal equality of the complete bounded repair hypergraph.
Permitted posture: useful uniform-boundary theorem and referee hardening; complete-hypergraph
formulation none found; no categorical priority claim.

### Paper landing

- The proposition and its two examples appear immediately after the transfer theorem.
- The manuscript uses “cannot be weakened uniformly” and “best possible for the uniform theorem,”
  never unqualified necessity for a fixed code.
- The proof ledger, novelty review, trust manifest, paper registry, README, handoffs, queue, and PDF
  are synchronized.

## Order, dependencies, and completion criteria

C104 and C105 are mathematically independent and both complete. Remaining work belongs to the
paper's external specialist citation-chain preflight or to separate optional strengthening tracks,
not to this handoff.
