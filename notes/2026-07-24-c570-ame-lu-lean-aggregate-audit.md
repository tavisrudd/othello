# C570 — aggregate Lean audit and manuscript reconciliation

**Lane:** `ame-lu`

**Date:** 2026-07-24

**Verdict:** `COMPLETE; THE ADOPTED AME FORMAL PACKAGE HAS ONE AGGREGATE IMPORT AND AXIOM GATE, EVERY MANUSCRIPT LABEL HAS A DECLARATION-LEVEL ADEQUACY VERDICT, AND CONDITIONAL INTERFACES ARE SEPARATED FROM UNCONDITIONAL FORMAL COVERAGE`

## Aggregate formal gate

`RelativeConicArcs.Gates.AMELUAggregate` imports, in one environment:

```text
AMELUDefinitions
AMELUDictionary
AMELUStabilizerDictionary
AMELUPencilClassification
AMELUMarginalMoment
AMELULogicalPhaseFourCopy
AMELUTransportDivisor
```

Its header states the global trust boundary: the dictionary package is
unconditional, while the classification, marginal-moment, logical-phase,
four-copy, and transport terminals consume public structures whose fields
name their unproved geometric, analytic, certificate, or orbit inputs.

`RelativeConicArcs.Gates.AMELUAggregateAxioms` audits 33 paper-facing
declarations spanning all seven packages.  The measured `single` profile
queue built both aggregate modules and passed the trace-only aggregate and
exact no-build gates.  Peak resident memory was 1,724,740 KiB.

The toolchain is Lean `v4.32.0-rc1`.  Every audited declaration outside
the marginal graph census reports only

```text
propext
Classical.choice
Quot.sound
```

The exhaustive native proofs of the 455 marginal triples, 60 stars, and 15
perfect matchings additionally report exactly:

```text
card_marginalTriples._native.native_decide.ax_1_1
card_marginalStars._native.native_decide.ax_1_1
card_perfectMatchings._native.native_decide.ax_1_1
```

No other audited terminal depends on native evaluation.  There is no
`sorry`, project-specific axiom, generated declaration, imported
certificate, or unsafe execution in the aggregate formal package.

## Declaration-level reconciliation

`papers/ame_lu/formal-statement-adequacy.md` now gives every stable
manuscript label an exact declaration list and one of three verdicts:

- unconditional statement coverage;
- a conditional formal interface with every remaining hypothesis named; or
- no formal theorem, with the conceptual paper proof stated as the boundary.

The principal decisions are:

- `thm:dictionary` has unconditional statement coverage.
- `thm:lc-pencil` has an unconditional algebraic quotient and a conditional
  geometric/LC classification terminal.
- `thm:logical-phase` has conditional fixed-party coverage only; the
  party-moving normalizer is not formalized.
- `thm:lu-h3-grs` has an unconditional finite graph core and a conditional
  trace/concurrency/LU separator.
- `thm:q13-lu` fixes the exact matrices and contraction pattern but leaves
  the analytic rank identity, LU covariance, and rank evaluations as
  `FourCopySeparatorInputs`.
- `thm:transport-divisor` has unconditional polynomial and
  characteristic-seven algebra, while the quotient-action instantiation,
  determinant expansion, systematic rank bridge, generic kernel, and
  double-coset geometry remain explicit inputs.
- `thm:lu-lc-rigidity`, `cor:lu-lc-pencil` as a complete composition, and
  `thm:fixed-copy-boundary` are not formalized.

This resolves the main Tao stress test: the artifact cannot be described
as an unconditional formal proof of the complete transport theorem merely
because its algebraic terminal elaborates.

## Manuscript and ledger changes

Section 8 now states the Lean toolchain, aggregate terminal, exact division
between unconditional and hypothesis-mediated results, the four principal
unformalized paper claims, and the native-versus-kernel trust boundary.
The formalization ledger, verification map, and claim/proof/novelty ledger
use the same verdicts.  In particular, “concrete transport operator” was
sharpened to “parametric block operator”: the formal definition fixes the
block formula but does not instantiate the six copy-quotient matrices.

`make check` completed without failure and produced the warning-free
11-page PDF after the Section 8 reconciliation (SHA-256
`91e34d6e83a0fe90a2d6d5be56fd211d11cadbc8d3a38e1d280863513870c295`).

## `ej` / Tao closeout and mystery ledger

The closeout asked whether a successful aggregate import could still hide
a statement mismatch.  It found four such risks and closed them in the
adequacy ledger: conditional classification inputs, the party-moving
logical normalizer, the parametric rather than instantiated transport
actions, and the absence of a formal LU-rigidity theorem.  It also replaced
the generic phrase “native-aware audit” by the three declaration-local
axiom names emitted by the pinned toolchain.

| feature | disposition |
|:---|:---|
| One import environment for all adopted modules | **Settled:** `AMELUAggregate` imports all seven component gates. |
| Complete paper-facing axiom audit | **Settled:** 33 declarations are audited; standard and native dependencies are separated exactly. |
| Dictionary statement adequacy | **Settled:** unconditional coverage matches the manuscript proposition. |
| Conditional theorem interfaces | **Settled:** every structure and missing construction is named by manuscript label. |
| Headline LU rigidity and fixed-copy boundary | **Settled as a limitation:** both remain conceptual manuscript proofs and are explicitly excluded from formal coverage. |
| Logical normalizer | **Settled as a limitation:** only the fixed-party conditional theorem is formalized. |
| Full transport theorem | **Settled as a limitation:** polynomial algebra is unconditional; determinant, rank, and orbit geometry remain explicit inputs. |
| Public archival identity of the Lean artifact | **Open under the release gate:** the stable export path and immutable source manifest belong to the release-candidate task after adversarial review. |
| Whether the conditional inputs should be formalized further | **No current evidence gap for this paper:** the manuscript proofs and paper-local certificates own them; adversarial review may reopen only a specific inadequacy. |

The discovery-track review found no incidental result.  Every issue found
was a requested statement-adequacy or trust-boundary deliverable.

## Vibe check

Strong and clarifying.  The aggregate gate is green, but the more valuable
result is that its success can no longer be rhetorically inflated: each
paper theorem now has an exact, declaration-level formal-strength label.

Commits `8f140793`, `5ceebe8f`, and `4e4a7225` contain the aggregate gate,
manuscript reconciliation, and exact axiom-boundary record.
