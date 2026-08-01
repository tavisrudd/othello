# C750 — Paper II structural Lean closure

**Lane:** `clebsch`

**Status:** complete on 2026-08-01 for the paper-specific structural spine.
The 22-terminal gate, explicit axiom audit, trust map, evidence fingerprint,
39-page PDF, and authoritative release aggregate are green.  The cited
representation-theoretic and subgroup identifications remain explicit
classical inputs, not Lean claims.

## Objective

Formalize the frozen C746--C749 human proof surface for the Paper II all-`q`
classification, closing the exact Lean gaps identified by the 2026-07-31
audit without changing the mathematical architecture.

## Scope

- the abstract projective--trade reduction;
- the finite-group Hom-space Lucas-socle criterion;
- the canonical first-wall connecting-map obstruction and exceptional seam;
- the structural q=9 endpoint; and
- the exact paper-facing composition theorem yielding balanced-orbit
  completeness.

## Acceptance gate

Every new paper-facing theorem names its fully qualified Lean declaration.
The Paper II gate imports the complete formal closure, the axiom audit has an
explicit allowlist, comments and docstrings are referee-facing, and the
paper-local aggregate and standalone metadata gates pass.  The formal proof
must follow the frozen human decomposition rather than introduce a second
proof architecture or replace structural lemmas by opaque computation.

## Lean-first execution plan

1. Map every paper-spine implication to an exact existing or proposed Lean
   declaration, with the outer-parity defect lemma and the detecting-module
   vanishings treated as load-bearing.
2. Put the new proof in bounded structural modules: finite-torus weight
   aliases, root-defect factorization, the four-weight first-Frobenius map,
   detecting-module exclusions, and the final subgroup/sheet composition.
3. Make the Paper II gate import that complete closure and extend the axiom
   audit to every new terminal.  Imported classical representation facts must
   be stated as such; no abstract hypothesis may be presented as a proof of a
   concrete module calculation.
4. Run only the guarded OOM-safe Lean entry points, then the authoritative
   paper aggregate and PDF warning gate.  C749 resumes only after this exact
   formal/paper spine is green.

### First bounded leaves

The initial OOM-safe leaves are kernel-checked individually:

- `RelativeConicArcs.ClebschOuterParityWeights` proves that the selected odd
  torus channel contains only weights \(q-1\) and \(1-q\);
- `RelativeConicArcs.ClebschRootDefect` proves coordinatewise divisibility by
  \(X^q-X\), the quotient degree bound, and the torsion-free cocycle
  cancellation steps;
- `RelativeConicArcs.ClebschFirstFrobeniusSection` proves the complete
  four-weight upper/lower root and Weyl action table, including the mixed
  \(t\sigma(t)\) coefficient and the defect of \(C-B\);
- `RelativeConicArcs.ClebschRegularMatching` and
  `RelativeConicArcs.ClebschDihedralReflectionParity` classify invariant
  regular matchings by nonidentity involutions and prove the residual
  reflection parity equation; and
- `RelativeConicArcs.ClebschOrbitOrderReduction` proves the exceptional
  order reduction to \(q=5,7,9,11\), removes \(q=9\), and forces subgroup
  orders \(12,24,60\).

These were the initial bounded leaves.  The closure below adds the concrete
Lucas fixed-line and recurrence model, detector and contraction implications,
and Dickson-endpoint composition.  The release runner marks the affected
claims with both `lean` and `classical-input`, reflecting the exact boundary.

### Implemented structural closure

The implementation follows the manuscript order:

1. `ClebschProjectiveTradeReduction` proves the pullback kernel/splitting
   diagram used in Lemma 3.1.
2. `ClebschLucasCoefficientBasis`, `ClebschLucasPolynomialFactorization`,
   `ClebschFiniteRootWeightSlice`, and
   `ClebschFiniteRootRecurrenceBridge` prove the one-digit fixed line,
   Frobenius-digit tensor recurrence, no-carry polynomial factorization, and
   finite-root-to-recurrence interface used in Lemma 3.3(1).
3. `ClebschOuterParityWeights`, `ClebschRootDefect`,
   `ClebschFirstFrobeniusSection`, and `ClebschOuterParityInjection` prove the
   two surviving weights, finite-root defect factorization, four-weight
   action table, and injective middle-difference lift used in Lemma 3.3(2).
4. `ClebschDetectingModuleVanishings`,
   `ClebschDividedPowerTopSlices`, `ClebschPolynomialTopSliceDetection`, and
   `ClebschDetectingIntertwiners` prove the paper-specific digit bounds,
   nonzero divided-power coefficients, and the general and
   characteristic-three detector implications.
5. `ClebschAffineExtensionContraction` and
   `ClebschAffineContractionCohomology` prove the explicit
   evaluation--coevaluation formula and its descent through coboundaries in
   Lemma 3.3(3).
6. `ClebschRegularMatching`, `ClebschDihedralReflectionParity`,
   `ClebschOrbitOrderReduction`, `ClebschBalancedOrbitEndgame`, the sharded
   `ClebschA3InvariantMatching`, `ClebschB3InvariantMatchings`, and
   `ClebschH3InvariantMatchings` leaves, and
   `ClebschRankThreeBalancedEndgame` prove the arithmetic endpoint reduction,
   derive the fused `q=5` exclusion, and certify the unique `B_3/F_7` and
   `H_3/F_11` invariant matchings.  The `H_3` uniqueness proof uses twelve
   point-stabilizer witnesses per sheet, not a matching census.

The remaining trust boundary is explicit and classical: Steinberg/Hermite
identify the concrete coefficient models with the finite-group Hom spaces;
tilting/socle theory identifies the ambient `Sym²(Sym² ∇d)` slices and
validates the root/Weyl intertwiner; Dickson--Giudici identifies the abstract
stabilizer candidates.  Lean checks the new coefficient, defect, detector,
contraction, and endpoint implications on either side of those
identifications.  The final trust manifest must retain `classical-input`
alongside `lean`; it must not describe the cited representation or subgroup
classifications as kernel-checked.

## Boundaries

The earlier sequencing boundary was explicitly overridden on 2026-08-01:
formal closure and the document build now precede C749.  Certificate
generation, native evaluation, and coordinate enumeration are not substitutes
for the structural theorem.

## `ej` + `tt` closeout

The closeout tightened the only avoidable interface asymmetry.  The concrete
finite-root fixed-line theorem had been connected to the Lucas recurrence in
one direction; `finiteRootInvariant_iff_satisfiesOneDigitRecurrence` now proves
that, below the characteristic, the two descriptions are exactly equivalent.
This makes the formal order match the manuscript's mathematical order:
action, fixed line, recurrence, Frobenius-digit product.

The endpoint audit also confirms that the proof needs less computation than
the original closure plan allowed.  The `q=5` branch is eliminated by its
checked five-element fused orbit, and each `H_3` partner is forced by one
point-stabilizer witness per endpoint.  No search through perfect matchings or
through all stabilizer rows is used.

### Mystery ledger

- **Settled — is the Lucas action/recurrence seam reversible?**  Yes; the new
  iff terminal proves both spaces are the same alternating-binomial line.
- **Settled — is `q=5` excluded by an assumed side condition?**  No; the
  checked full-orbit cardinality derives the exclusion.
- **Settled — does `H_3` uniqueness hide a matching census?**  No; twelve
  two-point fixed-set witnesses per sheet force the partner map.
- **No genuine Paper II mathematical mystery remains in C750's scope.**  A
  future foundational-library project could formalize Steinberg/Hermite,
  tilting/socle theory, and Dickson--Giudici themselves.  Here they are
  pinpointed classical inputs, while every paper-specific calculation and
  implication surrounding them is in the audited Lean gate.
