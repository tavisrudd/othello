# C601 planning: formal LU-to-LC rigidity

**Lane:** `ame-lu`

## Goal

Formalize the paper's headline theorem for every finite field: if equal-phase
states of two linear `[6,3,4]` MDS codes are related by a party permutation and
six local unitaries, then every local unitary normalizes the finite-field Weyl
system. Export the resulting local-Clifford equivalence and the
admitted-pencil `LU iff LC iff z` composition without strengthening the
extension-field scalar classification.

## Existing foundation

- `RelativeConicArcs.AMELU.Definitions` fixes states, marginals, local actions,
  local-unitary equivalence, Weyl matrices, Clifford matrices, and
  local-Clifford equivalence.
- `RelativeConicArcs.AMELU.StabilizerDictionary` proves the CSS stabilizer
  equation, supported-label criterion, Lagrangian property, and
  `[6,3,4]`/AME dictionary.
- `RelativeConicArcs.AMELU.PencilClassification` exposes the prime-field
  classification terminal from named geometric and holonomy inputs.
- The missing proof is accurately recorded in the paper's formalization and
  statement-adequacy ledgers.

## Tao-style planning pass

The theorem crosses three mathematical languages: tensor rank, MDS shortening,
and unitary/Weyl conjugation. The main risk is formalizing all three
simultaneously inside a six-party density-matrix calculation. The proof should
instead expose the invariant that makes each language change inevitable.

Questions to settle before freezing an API:

1. What is the weakest algebraic statement recovering the coordinate axes of
   a diagonal tensor? Inner products and unitarity are unnecessary here;
   invertible factor maps and matrix rank should suffice.
2. Can the axis lemma conclude monomiality directly, avoiding a general
   projective intrinsic-locus framework unused elsewhere?
3. Which exact shortening theorem follows from `IsMDSCode634` by rank-nullity,
   and which dual-code lemma supplies the second generator?
4. Can the four-party stabilizer expansion be proved once as equality of
   matrix-entry arrays rather than through a new operator-algebra hierarchy?
5. What is the smallest covariance lemma saying that a six-party local action
   descends to product conjugation on a selected marginal?
6. Does axis permutation plus the fixed identity axis prove the current
   `IsCliffordMatrix` definition directly, with the correct conjugation
   orientation and a nonzero scalar?
7. Can the cover corollary be independent of the special choice of two
   four-sets, so the formal theorem displays the real combinatorial hypothesis?

The highest-value simplification is to make the diagonal-axis theorem
independent of AME, codes, finite fields, and Hilbert-space terminology. The
highest-risk seam is the exact four-party marginal expansion: derive it from
the normalized equal-phase state and CSS stabilizer equation, not from an
unconstructed input structure. The second risk is hidden use of surjectivity
when the supported stabilizer plane is projected to a local Weyl label; prove
a linear equivalence at each retained party.

## Theorem decomposition

1. **Diagonal tensor.** Define the finite array, one-factor contraction, and
   flattening matrix. Prove that the flattening has rank one exactly for a
   nonzero coordinate-axis covector. Deduce that invertible product maps
   carrying one full diagonal tensor to another are monomial in every factor.
2. **MDS shortening.** For a four-party set, prove that codewords supported
   there form a one-dimensional subspace for both `C` and `C^\perp`; construct
   nonzero generators, prove exact support, and prove that the product plane
   projects bijectively to `𝔽 × 𝔽` at every retained party.
3. **Marginal Weyl expansion.** Express the identity-subtracted four-party
   marginal as the full diagonal tensor indexed by
   `𝔽² \ {(0,0)}`, with nonzero coefficients and orthogonal local Weyl axes.
4. **Covariance and Clifford bridge.** Prove that global local-unitary
   equivalence gives product conjugacy of each selected marginal. Apply the
   axis theorem to permute nonidentity Weyl axes, include the identity axis,
   and discharge `IsCliffordMatrix`.
5. **Six-party terminal.** Cover all parties by four-sets and conclude that
   every local factor is Clifford. Export the unconditional
   `LocallyUnitaryEquivalent → LocallyCliffordEquivalent` theorem for
   equal-phase `[6,3,4]` states.
6. **Pencil composition.** Over the manuscript's odd-prime-field scope,
   compose the new theorem with the existing conditional pencil
   classification interface. Do not claim scalar classification over
   extension fields.

Likely module boundaries are an algebraic diagonal-tensor module, an
MDS-supported-plane module, and an AME-LU rigidity module, followed by an
import-only gate and axiom audit. Choose final names after small elaborating
probes establish which mathlib matrix-rank and finite-dimensional APIs fit.

## Validation and acceptance

- Every new or touched module passes guarded single-file elaboration.
- The `ame-lu` import-only gate imports every new paper-facing terminal.
- Exact-target `--no-build` checks and the AME aggregate trace gate pass under
  the documented build owner and measured profile.
- `#print axioms` for every new terminal reports only accepted standard axioms,
  with no `sorry`, project axiom, native evaluation, generated declaration, or
  external certificate.
- Whole-module referee-facing prose and names pass `lean/AGENTS.md`: complete
  public docstrings, exact scope, no workflow vocabulary or reverse references,
  and no overstated strength.
- The manuscript theorem, formalization ledger, statement-adequacy map,
  verification section, and exact Lean declarations agree field for field.
- The terminal is unconditional from `IsMDSCode634`, the explicit Weyl
  convention, and displayed local-unitary equivalence. The diagonal-axis,
  shortening, marginal, and covariance steps may not remain as unconstructed
  input fields.

## Stop conditions

Stop and report a reduced counterexample if the current local-unitary or
Clifford definitions do not express the manuscript action faithfully. Stop
rather than weakening the gate if matrix rank forces unsafe or native
execution. If the shared finite-geometry layer lacks a reusable shortening
theorem, prove the narrow six-coordinate result locally unless a shared change
is separately owned and all affected gates can be validated.

## Mystery ledger

- **Unsettled:** whether the diagonal-axis lemma is cheapest via `Matrix.rank`,
  range dimension, or explicit nonzero minors. A bounded prototype decides
  this before the public API is frozen.
- **Unsettled:** whether the four-party marginal expansion is shorter from
  amplitudes or from a general stabilizer-projector identity. Choose the route
  with the smaller trust and dependency closure.
- **Settled:** quantitative stability is unnecessary for exact LU-to-LC;
  C581 owns that separate gate.
- **Settled:** extension-field Frobenius affects the pencil scalar
  classification, not the all-prime-power LU-to-LC rigidity theorem.
