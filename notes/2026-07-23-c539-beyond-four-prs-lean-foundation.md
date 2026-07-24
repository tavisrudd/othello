# C539 — shared Lean foundation for beyond-four PRS classifications

**Lane:** `reed-solomon` · **Date:** 2026-07-23 · **Status:** complete

## Result

The common paper-facing interface is formalized in
`RelativeConicArcs.PRSFoundation`, with import gate
`RelativeConicArcs.Gates.PRSFoundation` and a separate axiom-audit target.

The module separates the logical layers that the manuscript must not conflate:

1. the exact equivalence between split-free syndromes and absence of a split squarefree member of
   the associated Hankel kernel;
2. promotion from split-freeness to coding-theoretic deepness only under an explicit
   covering-radius range;
3. geometric component and rational-point hypotheses used to construct a kernel member;
4. the persistent tangent/sigma union;
5. split-free exhaustion and projective/projective-semilinear orbit counts.

The terminal synthesis theorem combines these layers only after equality of their syndrome
predicates is supplied explicitly.  No group action, covering-radius theorem, component theorem,
rational-point theorem, deletion estimate, or finite certificate is hidden as a project-local
axiom.

The established degree-nine API now imports the shared foundation.  Its residual-slice structure
has the public adapter
`RelativeConicArcs.PRSRedundancyNine.ResidualSliceInput.toWitnessConstructionInput`, and the
existing witness theorem is proved through the common construction terminal.  The generic marker
operation remains
`RelativeConicArcs.PRSResidualQuadratic.dividedPowerContraction`; no competing contraction
hierarchy was introduced.

## Declaration ledger

The reusable terminals are:

- `RelativeConicArcs.PRSFoundation.HankelKernelDictionary.not_splitFree_of_kernel_member`;
- `RelativeConicArcs.PRSFoundation.HankelKernelDictionary.not_splitFree_iff_has_kernel_member`;
- `RelativeConicArcs.PRSFoundation.CoveringRadiusInput.deep_iff_splitFree`;
- `RelativeConicArcs.PRSFoundation.WitnessConstructionInput.exceptional_has_kernel_member`;
- `RelativeConicArcs.PRSFoundation.GeometricWitnessInput.exceptional_has_kernel_member`;
- `RelativeConicArcs.PRSFoundation.PersistentFamilies.persistent_card`;
- `RelativeConicArcs.PRSFoundation.OrbitExhaustionInput.splitFree_iff_mem_persistent`;
- `RelativeConicArcs.PRSFoundation.deep_iff_mem_persistent`.

The exact manuscript-facing coverage and remaining hypotheses are recorded in
`papers/beyond4_prs/formalization-ledger.md`.  It is the input matrix for the degree-specific
formalizations.

## Validation

`RelativeConicArcs.PRSFoundation` passed independent guarded single-file elaboration.  The managed
serial build then passed:

- `RelativeConicArcs.PRSFoundation`;
- the modified `RelativeConicArcs.PRSRedundancyNine`;
- the pre-existing redundancy-nine import gate;
- `RelativeConicArcs.Gates.PRSFoundationAxiomAudit`;
- the trace-only aggregate gate `RelativeConicArcs.Gates.PRSFoundation`.

The build run is recorded under the disk-backed managed runner as
`run-20260724-030109-425bda5f`.  The audit reports no project-specific axioms.  Individual logical
terminals are either axiom-free or depend only on `propext`, `Classical.choice`, and `Quot.sound`.
The pre-existing degree-nine synthesis retains exactly those same standard dependencies.

The complete changed Lean modules and gates were reviewed for mathematical scope, trust-boundary
disclosure, stable naming, and forbidden workflow vocabulary.  No task identifiers, internal
notes, status prose, novelty claims, generated evidence, or machine-local paths occur in the
referee-facing Lean sources.

## Extra-juice and Tao closeout

The cheap structural upgrade was to provide both predicate-level and polynomial-level witness
interfaces.  Degree-specific modules that already package witness existence can reuse the former;
new algebraic developments can use the latter without erasing the actual kernel polynomial.

The strongest additional reusable conclusion is
`deep_iff_mem_persistent`: it forces the Hankel dictionary, radius theorem, and orbit exhaustion to
agree through explicit predicate equalities before producing a coding classification.  This blocks
a subtle but common error in which a split-free syndrome table is silently reported as a
deep-hole table outside the proved covering-radius range.

No projective group action was fabricated merely to strengthen the interface.  The orbit structure
records counts and exhaustion as visible inputs until the degree-specific developments construct
the actual actions and stabilizers.

## Mystery ledger

Settled:

- **Would the shared layer duplicate marker contraction?** No.  It imports and exposes the
  established divided-power operation and its commutation theorem.
- **Could a split-free classification silently become a code deep-hole classification?** No.
  Covering-radius promotion is a separate structure with an explicit range proposition.
- **Could geometric existence or orbit exhaustion enter as a hidden axiom?** No.  Each is a named
  structure field, and the audit contains no project-specific axioms.
- **Can the established redundancy-nine package consume the common interface?** Yes.  Its adapter
  is checked, and its original terminal theorem and gate remain green.

Open, with exact owners:

- **Concrete projective Hankel models and group actions:** the redundancy-five through
  redundancy-eight and characteristic-two modules must instantiate the abstract syndrome and
  polynomial types and prove their action laws.
- **Component, rational-point, and finite exhaustion inputs:** these remain visible mathematical or
  certificate obligations in the corresponding degree-specific modules.
- **Aggregate manuscript closure:** the final aggregate gate must reconcile every paper theorem
  with a declaration, external hypothesis, or public certificate.
