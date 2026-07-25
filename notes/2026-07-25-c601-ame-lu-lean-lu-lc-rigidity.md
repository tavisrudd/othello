# C601: length-generic LU-to-LC rigidity foundations

**Lane:** `ame-lu`

**Status:** complete

## Goal

Build the unconditional length-generic foundation needed by the paper's
version-1 headline package.  C601 owns the `Fin (2*m)` code/state/action API,
the exact `[2m,m,m+1]` MDS and dual-shortening theory, the code-independent
diagonal-tensor axis theorem, and compatibility with the existing six-party
AME definitions.  It stops at those reusable foundations: C612 owns the
general LU-to-LC terminal, and C613 owns the Choi/quantum-MDS/transversal
corollary.

## Execution split

The earlier single-task plan was too large for one coherent Lean acceptance
gate.  Its theorem decomposition remains authoritative, with ownership now:

- **C601:** layers 1--3 below;
- **C612:** layers 4--6 and 8;
- **C613:** layer 7;
- **C602:** aggregate trust, prose, axiom, and release audit after all three.

## Existing foundation

- `RelativeConicArcs.AMELU.Definitions` fixes six-party states, marginals,
  local actions, local-unitary equivalence, Weyl matrices, Clifford matrices,
  and local-Clifford equivalence.  These definitions cannot state the new
  theorem unchanged: C601 must first factor out a length-generic layer over
  `Fin (2*m)` and recover the existing six-party API by specialization.
- `RelativeConicArcs.AMELU.StabilizerDictionary` proves the CSS stabilizer
  equation, supported-label criterion, Lagrangian property, and
  `[6,3,4]`/AME dictionary.
- `RelativeConicArcs.AMELU.PencilClassification` exposes the prime-field
  classification terminal from named geometric and holonomy inputs.
- `RelativeConicArcs.AMELU.LURigidity` now proves the complete \(m=3\)
  specialization unconditionally: diagonal-axis recovery, dual `[6,3,4]`
  shortening, the full four-party Weyl marginal, covariance, Weyl
  normalization, party permutations, and the six-party LU-to-LC terminal.
  `RelativeConicArcs.AMELU.LUPencilClassification` composes that terminal with
  the conditional pencil interface.
- The remaining gaps are therefore exactly the length-generic refactor and
  arbitrary-\(m\) theorem owned by C601/C612, plus C613's
  quantum-MDS/Choi/transversal corollary.  The paper's formalization and
  statement-adequacy ledgers record this boundary.

## Tao-style planning pass

The theorem crosses four mathematical languages: general linear codes, tensor
rank, unitary/Weyl conjugation, and Choi encoders.  The main risk is allowing
the existing six-coordinate API to dictate a second, incompatible formal
model.  The proof should first isolate a length-generic algebraic core and
make the six-party declarations thin specializations.

Questions to settle before freezing an API:

1. What is the weakest algebraic statement recovering the coordinate axes of
   a diagonal tensor? Inner products and unitarity are unnecessary here;
   invertible factor maps and matrix rank should suffice.
2. Can the axis lemma conclude monomiality directly, avoiding a general
   projective intrinsic-locus framework unused elsewhere?
3. Should the generic MDS hypothesis be projection-bijectivity on every
   `m`-set or minimum distance plus dimension?  Prefer the former if it makes
   shortening and AME immediate, but prove its equivalence to the paper's
   `[2m,m,m+1]` terminology.
4. Which dual-MDS theorem supplies the second one-dimensional shortening
   without importing a fixed-length coding hierarchy?
5. Can the `(m+1)`-party stabilizer expansion be proved once as equality of
   matrix-entry arrays rather than through a new operator-algebra hierarchy?
6. What is the smallest covariance lemma saying that a `2m`-party local action
   descends to product conjugation on a selected marginal?
7. Does axis permutation plus the fixed identity axis prove the current
   `IsCliffordMatrix` definition directly, with the correct conjugation
   orientation and a nonzero scalar?
8. Can the Choi theorem reuse a general reshape/isometry API, and can the
   transpose bridge prove directly that `(Lᵀ)⁻¹` Clifford implies `L`
   Clifford under the finite-field Weyl convention?
9. Can the cover terminal quantify over arbitrary retained `(m+1)`-sets so
   the statement displays the real combinatorial hypothesis?

The highest-value simplification is to make the diagonal-axis theorem
independent of AME, codes, finite fields, and Hilbert-space terminology.  The
highest-risk seam is the generic code layer: the theorem must conclude from a
faithful formalization of `[2m,m,m+1]` MDS, not from a purpose-built
shortening hypothesis.  The second risk is the exact shortened marginal
expansion; derive it from the normalized equal-phase state and CSS stabilizer
equation, not from an unconstructed input structure.

## Theorem decomposition

1. **Length-generic code/state interface (C601).**  Define linear codes on
   `Fin (2*m)`, equal-phase states, subsystem marginals, product local actions,
   and the MDS condition in a form equivalent to the paper's
   `[2m,m,m+1]` parameters.  Prove dual MDS, AME, and the specialization
   bridges to the existing six-party definitions.
2. **Diagonal tensor (C601).** Define the finite array, one-factor contraction, and
   flattening matrix. Prove that the flattening has rank one exactly for a
   nonzero coordinate-axis covector. Deduce that invertible product maps
   carrying one full diagonal tensor to another are monomial in every factor.
3. **MDS shortening (C601).** For an `(m+1)`-party set, prove that codewords
   supported there form a one-dimensional subspace for both `C` and
   `C^\perp`; construct nonzero generators, prove exact support, and prove
   that the product plane projects bijectively to `𝔽 × 𝔽` at every retained
   party.
4. **Marginal Weyl expansion (C612).** Express the entire `(m+1)`-party
   marginal as the full diagonal tensor indexed by `𝔽²`, including the
   identity label, with nonzero coefficients and orthogonal local Weyl axes.
5. **Covariance and Clifford bridge (C612).** Prove that global local-unitary
   equivalence gives product conjugacy of each selected marginal. Apply the
   axis theorem to permute nonidentity Weyl axes, include the identity axis,
   and discharge `IsCliffordMatrix`.
6. **General rigidity terminal (C612).** Cover all `2m` parties by retained
   `(m+1)`-sets and conclude that every local factor is Clifford. Export the
   unconditional `LocallyUnitaryEquivalent → LocallyCliffordEquivalent`
   theorem for equal-phase `[2m,m,m+1]` states, then derive the existing
   `[6,3,4]` theorem by specialization.
7. **Choi/transversal terminal (C613).**  Define the normalized Choi state of an
   encoder, prove the action identity from `U_phys V = V L`, show that
   transpose and inverse preserve the finite-field Clifford normalizer, and
   conclude that the physical factors and logical factor are Clifford.
8. **Pencil composition (C612).** Over the manuscript's odd-prime-field scope,
   compose the new theorem with the existing conditional pencil
   classification interface. Do not claim scalar classification over
   extension fields.

Likely module boundaries are a generic MDS/CSS definitions module, an
algebraic diagonal-tensor module, an MDS-shortening module, a shortened
marginal module, an LU-rigidity module, and a Choi/transversal module,
followed by import-only gates and axiom audits.  Keep the six-party
specialization in a thin compatibility module so the existing pencil
formalization does not depend on a duplicate state model.  Choose final names
after small elaborating probes establish which mathlib matrix-rank,
finite-dimensional, and tensor-product APIs fit.

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
- The generic exact-MDS predicate is proved equivalent to the
  `m`-coordinate projection condition, and dual MDS, full-support
  `(m+1)`-shortening, and full-basis axis recovery are unconditional.
- The generic state/action definitions and MDS/projection predicates are
  definitionally or propositionally reconciled at `m=3` with the existing
  `IsMDSCode634`, `equalPhaseState`, local-equivalence, and projection APIs.

## Stop conditions

Stop and report a reduced counterexample if the generic code definitions do
not specialize faithfully to the six-party API. Stop rather than weakening
the gate if matrix rank forces unsafe or native execution.  Do not retreat
to a narrow six-coordinate foundation.

## Mystery ledger

- **Settled:** a two-factor diagonal flattening avoids a matrix-rank API.
  Its nonzero pure locus is exactly the coordinate-axis union, independently
  of how many additional tensor factors are present.
- **Unsettled:** whether the shortened marginal expansion is shorter from
  amplitudes or from a general stabilizer-projector identity. Generalize the
  chosen route to `(m+1)` parties with the smaller trust and dependency
  closure.
- **Settled:** the generic state/action definitions specialize
  definitionally at `m=3`; explicit theorems expose the equal-phase, local
  action, LU, LC, exact-MDS, and projection bridges.
- **Unsettled:** whether mathlib already exposes the exact Choi transpose
  identity in the required tensor convention.  If not, prove the finite
  matrix-entry identity locally.
- **Settled:** quantitative stability is unnecessary for exact LU-to-LC;
  C581 owns that separate gate.
- **Settled:** extension-field Frobenius affects the pencil scalar
  classification, not the all-prime-power LU-to-LC rigidity theorem.

## Delivered

- `GenericDefinitions.lean` defines length-`2m` labels, states,
  equal-phase states, party permutations, product local actions, and LU/LC
  relations, with explicit `m=3` compatibility theorems.
- `GenericMDS.lean` proves exact `[2m,m,m+1]` MDS iff every
  `m`-coordinate projection is bijective, proves the dual is exact MDS,
  and constructs full-support shortening generators on every `m+1` set.
- `GenericDiagonalTensor.lean` proves the full-basis diagonal-flattening
  pure-locus theorem and the resulting coordinate-axis preservation
  statement for invertible factor maps.
- The aggregate import and axiom audit include every new terminal.  Measured
  builds and exact no-build replay pass; all new audited declarations depend
  only on `propext`, `Classical.choice`, and `Quot.sound`.
- Commits: `80f11632` (generic foundations) and `97346a5c` (paper trust
  boundary).  The earlier six-party terminal and pencil composition landed
  in `c855cd89`, with the full-\(q^2\) prose alignment in `4a1bc605`.
