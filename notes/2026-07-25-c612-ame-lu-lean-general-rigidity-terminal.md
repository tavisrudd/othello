# C612 planning: general MDS--CSS LU-rigidity terminal

**Lane:** `ame-lu`

**Status:** in progress; arbitrary-\(m\) rigidity terminal complete,
projective-finiteness/identity-component corollary open

## Goal

From C601's length-generic MDS/CSS and diagonal-tensor foundations, prove the
paper's unconditional headline theorem for every finite field and every
\(m\geq2\): a product-unitary equivalence between equal-phase states of
linear \([2m,m,m+1]\) MDS codes forces every local factor to normalize the
finite-field Weyl system.  Derive the compatible six-party specialization
and compose it with the existing odd-prime-field admitted-pencil interface.

## Delivered

The main marginal-to-rigidity chain is unconditional.

- `RelativeConicArcs.AMELU.GenericMarginal` derives the complete shortened
  CSS Weyl expansion from equal-phase amplitudes and exact MDS shortening.
  The identity label is included with the same nonzero coefficient.
- `RelativeConicArcs.AMELU.GenericSubsystemWeyl` and
  `RelativeConicArcs.AMELU.GenericMarginalCovariance` prove product-Weyl
  basis completeness and exact reduced-matrix covariance for an arbitrary
  retained finite party type.
- `RelativeConicArcs.AMELU.GenericTensorRigidity` proves that independent
  invertible factor maps preserve and reflect nonzero pure arrays.  For
  every arity at least three, contraction of a full diagonal array is pure
  exactly on a coordinate axis, so every factor map is monomial.
- `RelativeConicArcs.AMELU.GenericLURigidity` combines those results with
  the retained-set cover and party-permutation transport.  Its terminal
  `genericLocallyUnitaryEquivalent_equalPhaseState_implies_genericLocallyCliffordEquivalent`
  proves the all-prime-power, all-\(m\geq2\) theorem directly from
  `IsMDSCode2m`.
- The same module proves the \(m=3\) compatibility terminal and the
  admitted-pencil composition
  `locallyUnitaryEquivalent_admitted_nonGRS_pencil_iff_pencilZ_eq_from_generic`.
- `RelativeConicArcs.Gates.AMELUAggregate` imports the complete new chain,
  and `AMELUAggregateAxioms` audits its paper-facing declarations.

## Validation

Guarded elaboration is warning-free for every new module.  The measured
single-thread queue built `GenericMarginal`, `GenericPartyPermutation`,
`GenericSubsystemWeyl`, `GenericMarginalCovariance`,
`GenericTensorRigidity`, `GenericLURigidity`, `AMELUAggregate`, and
`AMELUAggregateAxioms`.  The final trace-only aggregate gate passed.
Every new audited declaration reports only `propext`, `Classical.choice`,
and `Quot.sound`.

Commits:

- `791c4f15` — generic shortened marginal expansion;
- `f4c5a209` — generic covariance and party permutations;
- `8412ba7e` — arbitrary-arity axis recovery, LU-to-LC terminal,
  specializations, and aggregate audit.

## Open acceptance gate

The manuscript's discrete-symmetry corollary is not yet formalized.
The remaining work is not a consequence of the LU-to-LC implication alone:
it requires a concrete quotient of the one-qudit Clifford normalizer by
scalar phases, a proof that this quotient is finite for the repository's
finite-field Weyl convention, the induced finite product/permutation
extension, and a topological proof that the pre-quotient identity component
is exactly the torus of one-site scalar phases.  No existing AME-LU or
mathlib declaration supplies that package.  The paper trust ledgers state
this boundary explicitly.

## Existing six-party prototype

`RelativeConicArcs.AMELU.LURigidity` already proves the full \(m=3\)
specialization unconditionally, and
`RelativeConicArcs.AMELU.LUPencilClassification` exports its pencil
composition.  C612 generalizes and refactors those checked declarations; it
does not re-prove six parties through a parallel API.  The existing module is
both a regression oracle and the required specialization target.

## Exact gaps

1. **Generic CSS stabilizer expansion.**  The existing tensor Weyl action and
   supported-label formula are fixed to six coordinates.  Prove the exact
   `C × Cᗮ` stabilizer equation and partial-trace formula on `Fin (2*m)`.
2. **Shortened marginal tensor.**  Turn C601's one-dimensional shortenings of
   \(C\) and \(C^\perp\) into the entire \((m+1)\)-party tensor indexed by
   every label in \(\mathbb F_q^2\), including the identity, with nonzero
   coefficients and a local label equivalence at every retained party.
3. **Marginal covariance.**  Prove from the generic product local action that
   global state equivalence descends to product conjugation of each selected
   reduction, with party permutations and action orientation explicit.
4. **Axis-to-Clifford bridge.**  Apply C601's diagonal-axis theorem directly
   to the full Hilbert--Schmidt factors, use that conjugation fixes the
   identity axis, and prove the current generic `IsCliffordMatrix` predicate
   rather than a weaker monomial-adjoint surrogate.
5. **Cover terminal.**  For each of the \(2m\) parties choose an
   \((m+1)\)-set containing it and conclude that every local unitary is
   Clifford.  The theorem must quantify over arbitrary \(m\geq2\), not a
   finite list of lengths.
6. **Six-party compatibility.**  Prove that specializing \(m=3\) recovers the
   existing `IsMDSCode634`, equal-phase state, LU/LC action, and pencil
   definitions without duplicating the paper-facing object.
7. **Pencil composition.**  Export the prime-field
   `LU iff LC iff z` implication from the unconditional six-party terminal
   and the existing hypothesis-explicit classification interface.  Preserve
   the extension-field Frobenius exclusion.
8. **Discrete symmetry corollary.**  Prove that the projective one-qudit
   Clifford group is finite and derive finiteness of the product-unitary
   automorphism group modulo one-site scalar phases, including the exact
   identity-component statement and the finite party-permutation extension.

## Proposed module boundary

- a generic CSS stabilizer and marginal-expansion module;
- a marginal-covariance and Weyl-normalizer module;
- a general MDS/CSS LU-rigidity terminal;
- a thin six-party/pencil specialization;
- import-only and axiom-audit gates.

The scholarly modules use mathematical names only.  Task identifiers,
workflow status, and manuscript section numbers remain confined to this
planning record.

## Acceptance

- The terminal theorem is unconditional from the generic
  \([2m,m,m+1]\) MDS predicate, displayed product-unitary equivalence, and
  finite-field Weyl convention.
- No marginal expansion, covariance, axis recovery, local-label
  surjectivity, or party-cover step remains in an input structure.
- The \(m=3\) specialization is proved equal to, or equivalent to, the
  existing six-party API and supports the admitted-pencil composition.
- Every new module passes guarded elaboration; all AME import-only gates,
  exact no-build checks, aggregate trace gate, and declaration-level axiom
  audit pass under the documented profile.
- Every paper-facing theorem has a self-contained docstring and depends only
  on accepted standard axioms; no `sorry`, native evaluation, generated
  declaration, external certificate, or project axiom enters this
  conceptual theorem.
- The manuscript formalization ledger, statement-adequacy map, verification
  prose, theorem map, and exact declaration names agree.
- `cor:discrete-lu-symmetry` is exported from the general theorem with no
  topological or quotient-group hypothesis left implicit.

## Stop conditions

Stop with a reduced definition mismatch rather than proving the theorem for a
purpose-built supported-plane hypothesis.  If the generic and six-party local
actions have incompatible permutation or conjugation orientations, repair
the common interface before exporting either theorem.  Do not weaken the
paper theorem to prime fields or fixed \(m\).
