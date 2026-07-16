# C203 adversarial review: coefficient-labelled repair claims

**Date:** 2026-07-15
**Lane:** `repaircodes`
**Verdict:** two substantive weaknesses corrected; scoped claims survive focused validation

## Attacks and outcomes

| Attack | Outcome |
|---|---|
| The original gauge theorem changed the target coefficient, but a global rescaling of any dual relation already does that. | **Corrected.** The theorem now rescales one helper column, holds the target coefficient fixed and nonzero, and realizes an arbitrary nonzero helper coefficient. This changes a coefficient ratio and therefore establishes a genuine monomial-coordinate gauge. |
| The q=9 replay called the older verifier's circuit enumerator while describing itself as independent. | **Corrected.** It now owns its rank routine and size-three/four minimal-circuit enumeration, reusing only the declared finite-field and completed-point constructors. |
| Python optimization could disable every replay assertion and produce an apparently valid certificate. | **Corrected.** The verifier rejects `python -O` at startup. |
| A scalar recovery equation might be misread as a minimum-bandwidth or minimum-access theorem. | **Survived with explicit boundary.** It certifies one achieved protocol that reads and downloads one stored field symbol from each helper. No lower bound is claimed after subpacketization or alternative parity checks. |
| “Repair-by-transfer” might be misread as an optimality label. | **Corrected in the manuscript.** The achieved behavior is called scalar help-by-transfer; regenerating-code optimality is expressly disclaimed. |
| Canonical coefficient formulas might be claimed unchanged at every target. | **Corrected.** Existing monomial transport carries relation witnesses and introduces coordinate scales. The report claims canonical representatives for the three shapes, not identical normalization after transport. |
| A support theorem might silently determine a preferred dual word or invariant arithmetic cost. | **Survived.** The report distinguishes identical blockwise extension of a chosen witness, one-dimensional circuit normalization, and changes of coefficient ratios under column rescaling. |

## Claims that remain justified

- Every actual repair-hypergraph witness supplies the displayed exact scalar recovery equation.
- The three canonical completed-seed relations and their nonzero coefficients are kernel-checked.
- The q=9 replay independently enumerates 120 size-three and 120 size-four circuits, checks 840 retargeted equations, checks 72 ordered instances of each formula, and performs 576 fixed-target helper-gauge checks.
- Matching and transversal statements depend only on supports and are unaffected by coefficient gauge.

The review does **not** establish minimum repair bandwidth, minimum helper access, a globally
preferred coefficient normalization, invariant multiplication counts, or coefficient-labelled
equality for every transported presentation.

## Validation

- Focused guarded elaboration of `RepairCodes/OperationalCoefficients.lean` passes with only the
  standard axiom profile.
- The independent q=9 certificate is deterministic and retains coefficient-table SHA-256
  `c7ec1a09745e2aecb0e8a6b8d35fa145b141017ecabd51d6100064a30ff0a587`.
- The lane-wide aggregate `RepairCodes` build and final trace-only gate pass through the C224
  closeout.
