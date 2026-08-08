# C815 landed-work and remaining-plan audit

**Lane:** `clebsch`  
**Date:** 2026-08-08

## Verdict

The landed C815 mathematics is coherent and replayable.  The four-shadow,
aligned-design, OPER-1--OPER-4, and landed harmonic declarations elaborate; the
three existing Paper III gates build; their pinned source replays pass; every
tracked C815 exact-arithmetic certificate reproduces; and the paper-local release
gate passes in the manuscript Nix environment.  No false theorem statement,
unaccounted axiom, compiled-evaluation dependency, or numerical disagreement was
found.

The audit did find documentation debt that was invisible to the automated source
policy.  Nineteen non-private helper theorems in
`RelativeConicArcs.FourShadowRecognition`,
`RelativeConicArcs.BalancedExchangeSpectrum`, and
`RelativeConicArcs.ClebschOuterJoubertFrame` lacked the docstrings required of
declarations imported across a module boundary.  Those docstrings are now added.
The description of `normalizedMean` incorrectly suggested that
`normalizedMean d 1 = 1` for arbitrary `d`; it now states the correct degree-zero
normalization.  The task card still called the completed `Equiv.sumCompl`
transport unstarted, the harmonic plan counted six modules although it has
seven, the audit checklist left six completed aligned-design obligations
unchecked, and the harmonic scope note still prescribed the direct symbolic
proof superseded by the later cubic-restriction design.  All are repaired.

## Surfaces audited

- The current task card, lane handoff, Paper III Lean audit checklist, full gap
  inventory, harmonic scope, spherical-cubic design, and the reports linked by
  those live records.
- The explicitly labelled C815 commit series, together with the earlier
  four-shadow commits located through the task-card and source histories.
- The twenty-two C815-owned Lean modules carrying the four-shadow,
  aligned-design, operator, exchange-spectrum, and harmonic work, plus the three
  import-only gates and their paper-local formal maps.
- The seven tracked C815 computation programs: normalized-signing
  classification, outer-pair matchings, weighted Jacobian, characteristic-five
  degeneration, pair-signature negative, harmonic realization, and spherical
  cubic design.  Their committed JSON or asserted terminal output reproduced.

## Validation

The following supported checks passed on the audited tree:

1. Single-file guarded elaboration of the five landed harmonic modules and of
   every Lean module changed by the audit repair.
2. Guarded builds of
   `RelativeConicArcs.Gates.FourShadowRecognition`,
   `RelativeConicArcs.Gates.ClebschPassages`, and
   `RelativeConicArcs.Gates.ClebschGoldenReturn`.
3. Source-only replay of all three pinned closures after regenerating the two
   inventories affected by documentation changes.
4. Exact replay of all C815 certificates, including both independent
   recombinations in the spherical-cubic design and the wider symbolic
   sum-zero harmonic identity.
5. `verification/verify_release.py --lean-root ../../lean` inside the
   `.#manuscript` Nix environment: all checks pass, including the deterministic
   manuscript build and all three Lean source gates.

## Remaining C815 plan

The task is not ready for closeout.  The sound order is:

1. Prototype only `normalizedMean 18 (Heven ^ 3)` in the new
   `SphericalCubicRestriction` module.  This is the sole measured elaboration
   risk.  If normalization handles the fifty-five collected monomials, keep the
   designed squared-coordinate proof; otherwise introduce the designed helper
   for moments in squared coordinates before building any group layer.
2. Complete `SphericalCubicRestriction`: the doubled-coordinate zonal formula,
   `Hodd`/`Heven` split, transposition vanishings, two surviving moments,
   rotation covariance, explicit permutation words, the three coefficient
   orbits, the sum-zero collapse, the marked value, and the rational
   `sigmaThree` corollary.
3. Prove `SphereIntegralMoments`, isolating the measure-theoretic identification
   of the algebraic normalized mean with normalized surface integration.
4. Put all seven harmonic modules on the appropriate Paper III gate only after
   both remaining modules close; then regenerate the formal maps, source
   inventories and axiom reports and replay the three paper-local gates.
5. Close ARITH-1, ARITH-2 and ORIENT-1 in that order: the trace-split Stein
   algebra and chart-descent diagram; the reduced local fibre and general
   spinor-class API; then the two-component normalization relative to the full
   marked datum.
6. Before freezing C815's API, kernel-check the reduced eight-by-five
   weighted-Jacobian rank argument and its bridge to the twenty-by-fifteen
   Jacobian.  The structural human proof is sound and the assertion is not yet
   in the manuscript, but leaving it external would block C816 from promoting
   the local weighted-rigidity claim under the series-wide all-claims-in-Lean
   standard.
7. Run the required `ej` and `tt` closeout, reconcile the task report and live
   records, and hand the frozen API to C823.  The hard-coded all-rows-`partial`
   release-contract strings remain deliberately untouched until C800's single
   coordinated manifest reconciliation.

C884 remains a separate queued prerequisite before C816 promotes the harmonic
section; it owns the covariant obstruction, Gaunt/Wigner interpretation, and
Condon--Shortley conversion input and is not folded into C815.

## Mystery ledger

- **Settled:** the design constants, rationality of the marked cubic moment,
  the Gram cross-check, gate trust boundary, and all four operator rows agree
  across Lean, exact certificates and the formal maps.
- **Open, measured gate:** whether direct `MvPolynomial` normalization of
  `Heven ^ 3` is cheap enough.  The next prototype supplies the evidence.
- **Open, proof obligation:** the analytic surface-integral bridge.  Owner:
  `SphereIntegralMoments` in C815.
- **Open, release-contract debt:** completed OPER rows still carry a `partial`
  coverage token because `verify_scaffold.py` hard-codes one token for all nine
  rows.  Owner: C800 after the C815/C823 source freezes.
- **Open, promotion gate:** the weighted-Jacobian structural proof has no Lean
  declaration.  Owner: C815 before API freeze, so C816 can promote it without
  weakening the formal standard.

