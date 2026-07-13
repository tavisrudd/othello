# Handoff: exact value of rho_C(16)

**Date:** 2026-07-12
**Status:** ACTIVE
**Task:** C101

## Goal

Close the manuscript's remaining finite gap by proving exactly one of

```text
rho_C(16) = 8
rho_C(16) = 9.
```

The current strict-trust theorem is `8 <= rhoC (K := GF16) <= 9`. Completion must replace that
dichotomy in the manuscript, verifier report, Lean result registry, trust manifest, and
`papers/papers-index.md` with an exact theorem.

Session history belongs in
[`2026-07-12-rhoc16-exact-value-archive.md`](done/2026-07-12-rhoc16-exact-value-archive.md).

## Acceptance gate

One of the following mutually exhaustive proof objects must land.

1. **Eight-point construction.** Produce eight off-conic points in `PG(2,16)` accepted by the
   existing rules-only checker. Prove `rhoC_GF16 = 8` by combining the certificate with
   `L2_sixteen`.
2. **Eight-point nonexistence.** Exhaust all eight-arcs disjoint from the standard conic modulo
   proved conic-stabilizer symmetries, with a small independently checked rejection certificate.
   Prove that no such arc is complete outside the conic, then combine this with the existing
   nine-point witness to prove `rhoC_GF16 = 9`.

No solver assertion, search log, hash alone, `native_decide`, or unproved orbit-representative claim
is an acceptable endpoint. The final Lean theorem must audit to the repository's accepted Mathlib
foundations and contain no custom axiom.

## Attack order

| Step | Work | Exit condition |
|---|---|---|
| 1 | Reconstruct the 256 off-conic points, secant coverage masks, conic-stabilizer action, and the existing nine-point witness in a dedicated search tool. | Independent counts agree with the manuscript verifier and Lean field encoding. |
| 2 | Run the cheap existence route first: deletion/local repair of the nine-witness, randomized greedy completion, exact-cover/CP-SAT search, and stabilizer-canonical backtracking for size eight. | An eight-witness is found, or the exact enumerator exhausts the canonical search. |
| 3 | If a witness exists, freeze it and use `Certificate.check`; if not, emit a canonical search DAG whose leaves cite only locally checkable arc, coverage, cardinality, or symmetry-pruning rules. | Re-runnable proof object and independent verifier agree. |
| 4 | Add the semantic Lean consumer, split heavy finite leaves for memory safety, and prove the exact `rhoC_GF16` theorem. | Focused and aggregate builds, forbidden-token scan, and axiom audit pass. |
| 5 | Update the TeX proposition/further-questions section, README, proof audit, verifier output/hash when applicable, trust manifest, and papers index; rebuild the PDF. | No paper or registry entry still states `{8,9}` except historical logs. |

## Search/pruning invariants

- Selected points must remain off `XZ=Y^2` and every selected triple must have nonzero determinant.
- A completed size-eight candidate must cover all 248 required points outside the candidate and
  conic by its 28 secants.
- Track each required point's secant index and the 17 conic-point indices. The first and second
  moment equations and exact defect identity are certified pruning constraints, not merely
  end-of-run diagnostics.
- Canonical augmentation may use only explicitly generated elements of the conic stabilizer with
  a proved coordinate action. Record orbit sizes and stabilizers as cross-checks, never as the
  sole correctness argument.
- Keep search/generator code and frozen certificate data inside the relative-conic spinoff or its
  paper directory; do not add reverse imports into existing Lean libraries.

## Current status

- Lower bound eight: Lean-proved by `Examples.L2_sixteen` and
  `NonsingularConic.finite_lower_bound`.
- Upper bound nine: Lean-proved from the frozen `Examples.q16Witness`.
- Exact value: open; no size-eight existence or nonexistence certificate is presently registered.

## Next step

Implement the independent `GF(16)` coverage-mask model and verify all baseline counts, then run the
size-eight witness-first search before designing the nonexistence certificate format.
