# Shared Lean interface for six-party AME code states

## Result

The shared convention layer is
`RelativeConicArcs.AMELU.Definitions`.  Its import-only terminal is
`RelativeConicArcs.Gates.AMELUDefinitions`.  Later theorem packages can now
share one type and action vocabulary without importing manuscript text or
restating phase, permutation, and normalization choices.

The interface fixes:

| Manuscript object | Lean declaration |
|---|---|
| ordered six projective representatives | `RelativeConicArcs.AMELU.IsSixArc` |
| `3 × 6` parity-check matrix and kernel | `parityCheckMatrix`, `arcKernel` |
| exact linear `[6,3,4]` parameters | `IsMDSCode634` |
| packaged six-arc/MDS kernel | `SixArcMDSKernel` |
| normalized equal-phase code state | `codeStateNormalization`, `equalPhaseState` |
| subsystem marginal and AME condition | `marginalEntry`, `IsAME` |
| party and monomial actions | `permuteLabel`, `permuteState`, `monomialLabel` |
| projective and monomial equivalence | `ProjectivelyEquivalent`, `MonomiallyEquivalent` |
| tensor-product local action and LU relation | `localAction`, `LocallyUnitaryEquivalent` |
| trace phase and `X(a)Z(b)` Weyl matrices | `tracePhase`, `UsesTracePhase`, `weylMatrix` |
| Clifford normalization and LC relation | `IsCliffordMatrix`, `LocallyCliffordEquivalent` |
| complete shared datum | `ConventionDictionary` |

## Convention reconciliation

- A basis label is `Fin 6 → 𝔽`; a state is its complex amplitude function.
- The parity-check representatives are columns, although a selected triple is
  written as rows to take its determinant.  Transposition does not change
  whether that determinant vanishes.
- The state amplitude on the code is
  `sqrt(|𝔽|^3)⁻¹`, exactly the manuscript's `q^{-3/2}`.
- A permutation acts on labels by `(π • x) i = x (π⁻¹ i)`.  The induced state
  action is the corresponding contragredient amplitude action.
- A local matrix is indexed by output row and input column.  The tensor action
  therefore has coefficient `∏ i, U i (y i) (x i)` from `x` to `y`.
- The Weyl convention is exactly `W(a,b)=X(a)Z(b)`: its entry from `x` to
  `x+a` is `χ(bx)`.
- `ConventionDictionary.weyl_usesTracePhase` requires
  `χ(a)=exp(2πi Tr(a)/p)`.  The prime-field algebra is explicit in the Lean
  parameters; it is not inferred from an unspecified character.
- LU and LC equivalence use the same party permutation and unit-norm global
  phase.  `locallyCliffordEquivalent_implies_locallyUnitaryEquivalent` proves
  the definitional inclusion.

## Verification boundary

The module contains definitions and elementary interface lemmas only.  It does
not assert the arc--MDS equivalence, prove that every `[6,3,4]` equal-phase
state is AME, construct the trace character, or prove any manuscript
classification or rigidity theorem.  Those mathematical implications remain
the responsibility of downstream theorem modules.

The final definitions module passed direct guarded elaboration with Lean
`v4.32.0-rc1`.  The import-only terminal then passed the measured `single`
build profile (6.12 seconds wall time, 1,524,972 KiB peak RSS) and the
runner's exact trace-only aggregate gate.

No generated data, native evaluation, external certificate, `sorry`, or new
axiom occurs in the module.

## Mystery ledger

- **Prime-field algebra instance.**  The exact trace-phase predicate requires
  an explicit `Algebra (ZMod (ringChar 𝔽)) 𝔽` instance.  This is deliberate:
  silently selecting an algebra would hide the manuscript's trace convention.
  Concrete field packages must supply the canonical instance.
- **Dictionary theorem versus dictionary data.**  The shared datum fixes every
  convention needed to state the arc--MDS--CSS--AME theorem, but the theorem is
  not bundled as a structure field.  This prevents construction of a
  `ConventionDictionary` from assuming the conclusion that later Lean code is
  meant to prove.
- **Action-direction audit.**  The closeout pass asked whether the prose
  convention actually composes.  `permuteLabel_trans` and
  `permuteState_trans` now prove the chosen order, while
  `weylMatrix_zero_zero` pins the zero Weyl label to the identity.  This is
  settled.
- No other genuine convention ambiguity remains in the shared interface.
