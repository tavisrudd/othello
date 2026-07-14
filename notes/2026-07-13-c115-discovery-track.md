# C115 discovery-track log — incidental observations

**Date**: 2026-07-13
**Context**: kept while executing C115 (twisted-cubic external-point τ-spectrum). Incidental,
potentially-useful, or surprising things noticed in passing — NOT the planned deliverable (that is
[the C115 report](2026-07-13-c115-twisted-cubic-tau-reduction.md)).
Confidence tags: `CHECKED` = computationally replayed; `LEAN` = kernel-proved; `REASONED` = argued
but not yet replayed/formalized.

| # | Observation | Confidence | Why it may matter |
|---|---|---|---|
| I1 | **The §6.5 external-point τ-spectrum hypergraph at an axis point IS the axis repair-code cubic-component** (`axisCubicRepairComponent`). Two conceptually unrelated objects — the completion "3-secant transversal of C through x" and the coding "cubic-only minimal repair clutter for axis target x" — are literally the same finite hypergraph. | LEAN (via reuse) | The axis τ-result was already ~90% formalized (`axisCubicRepairComponent_infinity_transversalNumber`). "External-point transversal" and "repair locality" are the same combinatorics — a bridge between the completion and coding lanes that wasn't stated anywhere. |
| I2 | **τ-spectrum = repair-row minus the pair-component.** `τ_spectrum(axis) = q − cap` (cubic component only); the repair transversal row is `2q−1−cap` (cubic ⊔ pair, disjoint-ground union). So the external-point transversal is exactly the repair number minus the axis-pair-graph transversal `q−1`. | REASONED/LEAN | Clean decomposition: the §6.5 invariant is a named sub-invariant of the repair row. Suggests other §6.5 orbit values may be readable off existing repair-clutter decompositions. |
| I3 | **The projection's additive coordinate = the repair code's shifted-inversion relabeling.** Independently derived from projection geometry: at a finite axis point `a`, the smooth-locus coordinate is `φ(t)=(t+a)⁻¹`; at the nucleus, `φ=id`. The repo already had exactly this map as `axisShiftInvEquiv a` (built for repair-clutter transport). | CHECKED + LEAN | Two independent routes (projective projection vs repair-code symmetry) land on the same reciprocal map — strong corroboration, and it means the whole orbit is already transported by `projectiveShiftInvIndexEquiv`. |
| I4 | **The cusp location is orbit-DEPENDENT although τ is orbit-CONSTANT.** At the nucleus the cusp is the cubic point at infinity `P(∞)`; at a finite axis point `a` the cusp is the finite cubic point `t=−a`, and `P(∞)` becomes an ordinary smooth group element. So projective = affine-embedded only at the nucleus (cubic-∞ isolated); at finite axis points the projection adds edges through `P(∞)`. | CHECKED/REASONED | The "which point is the cusp" is not a PGL invariant, yet its +1 contribution to `M` is. A caution for anyone assuming the projective/affine cubic components coincide at every axis point — they do NOT (only at the nucleus). |
| I5 | **TO vs RC are separated by the collinear-sum constant `c₀` (rational-flex presence), not by group order.** Both project to smooth cubics with `#E = q+1` points (same order), but different collinear-triple counts (q=9: TO 9, RC 12). For `Z₁₀` with `c₀=O` the count is 12 (matches RC exactly); TO has no rational flex so `c₀≠O`. | CHECKED | A concrete instance of §6.5's own caveat "incidence counts do not determine τ": two equal-order smooth-cubic orbits split by a torsion/flex invariant. Likely the key discriminant C116 must encode for the TO/RC closed forms. |
| I6 | **The char-3 axis condition is `σ₂=0`, i.e. exponent-2 elementary symmetric, because the generalized Vandermonde on exponent set {0,2,3} equals `V·s₍₁,₁₎ = V·e₂`.** The axis vector `(0,e₁,e₂,0)` reads the incidence as `e₁σ₂ = e₂σ₁`; the axis point `(0,1,0,0)` picks `σ₂=0`, the nucleus picks `σ₁=0` (i.e. `s+t+u=0`). | CHECKED (sympy) + LEAN (`twistedCubicAxisCircuitMatrix_det`) | Explains *why* the char-3 axis lands on the additive cap condition: the skipped exponent 1 selects `e₂`, and `e₂ = stu·Σ1/t`. A clean lens on the "osculating plane = axis plane" char-3 coincidence. |

## Notes / leads

- **I1 + I2 lead:** the completion paper's §6.5 spectrum and the coding paper's repair rows are two
  views of the same clutter family. Worth checking whether the TO/RC/IC orbits (external non-axis
  points) also correspond to repair components of *other* code coordinates — if so, C116's ILP could
  be cross-checked against (or replaced by) existing repair-clutter invariants.
- **I5 lead:** for C116, encode the flex/`c₀` invariant per external orbit before running the ILP;
  the τ closed forms for TO/RC are "caps in `E(𝔽_q)` avoiding the class `c₀`", and TO/RC differ only
  in `c₀`.
