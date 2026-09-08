# Lean coverage after the cubic upgrades

**Lane:** `cubic-threefolds`
**Scope:** User-requested update/extension audit after portfolio export.

## Result

No stale statement or terminal digest was found by the source-only artifact
checker: 186 sources, 318 reviewer terminals, 62 manuscript claims; 9 absent,
25 fragments, 27 conditional deductions, 1 complete. This is a source-level
check, not a fresh kernel build or captured axiom audit. No Lean source,
theorem type, or coverage classification was changed.

The public Lean README now explains the manuscript/formal naming dictionary
and the distinction between the strengthened threefold corollary and its
unstabilized terminal. This avoids unnecessary theorem renaming while keeping
the current prose understandable beside the formal package.

## Existing proof support worth reusing

All names below are in namespace
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1` unless qualified further.

- `PaperInterface/CategoricalOneStep.lean`:
  `cubicSmallEven_normalizedGauge_exists_and_unique` and
  `cubicSmallEven_normalizedGauge_coefficients` already supply the normalized
  cubic gauge and its low-order coefficients. The new manuscript derivation
  of A1 explains an existing formal result; it needs no duplicate formal proof.
- `Quantum/RankTwoClusterGermRigidity.lean`:
  `Quantum.rankTwo_commutant_of_unit_offDiagonal` uses only a unit matrix
  entry, not nilpotence; `Quantum.rankTwoCluster_nilpotent_persists_on_germ`
  proves nonzero square-zero persistence from explicit compressed flatness,
  trace, closed-point and unit-entry hypotheses. The public
  `rankTwoCluster_nilpotent_persists_on_formal_germ` in
  `PaperInterface/FramedMonodromy.lean` already exposes this machinery for
  the companion's `prop:ranktwo-framed-germ`.
- The primary `prop:rank2-rigidity` mapping accurately warns that its own
  listed terminals do not supply the preliminary cluster-continuation and
  cyclicity repair. Thus the useful extension is a precise bridge to the
  existing matrix theorem, including regular cyclic-frame and flatness
  conventions, rather than duplicating its algebra.

All module paths in this section are relative to
`papers/cubic-stabilization-m1/lean/TavisRuddFiniteGeom/Papers/CubicStabilizationM1/`.

## Recommended order of extensions

1. **Strengthen the general threefold endpoint.**
   `PaperInterface/Introduction.lean` theorem
   `threefold_not_rational_of_occurrenceIndexedMarker` uses dimension-three
   factorization and proves only the unstabilized endpoint. Add a theorem
   for the product with P1 using the existing dimension-four provider,
   low-dimensional nullity, product formula and positivity assumptions.
   Keep all geometric hypotheses explicit. The claim is currently honestly
   classified as a fragment; this is a small and directly useful upgrade.
2. **Connect the persistence repair to existing formal-germ machinery.**
   Prove the exact reduction from the primary manuscript's centered
   flatness equation to the existing matrix model, plus the regular-frame
   hypothesis justified by cyclicity. The spectral-cluster geometry still
   remains a stated input unless separately constructed.
3. **Formalize additive consequences at their honest abstraction level.**
   A spectrum-valued operation structure, group completion and signed
   factorization identity can reuse the additive ledger. An abstract
   Bittner-presentation factorization would be conditional on that
   presentation and the geometric operation formulas; it must not be
   advertised as a complete formalization of K0(Var_C) or the QDM invariant.
4. **Sharpness: prioritize finite algebra before geometry.**
   The rank-four lattice certificate, saturated rank-three lattice and
   finite-index degree-divisibility algebra are plausible bounded targets.
   The rational slice, Galois descent, tangent projection, torsor
   trivialization and universal CH0 consequence require substantial
   geometric interfaces. The current sharpness claim map correctly marks
   all 16 theorem-like statements as absent. Python certificates do not
   constitute Lean coverage.

The fixed complex spectrum, Bittner extension, Hodge separation and
factorization consequences remain absent in the main claim map. The
arbitrary-field, generic-surface and partner exact-level conclusions remain
manuscript deductions in sharpness. Their current classifications require no
correctness repair merely because formal coverage is incomplete.

## Export and validation

The portfolio README and verification map were updated at authority
`ea8f2e5a0`; summary export `a8e17f7` is byte-identical across all eight
files. Both cubic paper exports were verified against their manifests.
The README-only formal documentation change is checked with
`python3 papers/cubic-stabilization-m1/lean/verification/check_formal_artifact.py --source-only`.
No direct Lean/lake command was run, and no new kernel-check claim is made.

## Mystery ledger — ej + tt

The useful discovery is that the commutant and persistence algebra already
exists behind another manuscript interface. Reusing it is preferable to
creating a duplicate formalization. The unresolved work is precisely the
primary-interface connection and geometric hypothesis supply, not an unknown
matrix identity. No new mathematical mystery arises from this audit.
