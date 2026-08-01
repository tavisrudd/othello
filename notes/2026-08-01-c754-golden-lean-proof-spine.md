# C754 Golden Lean proof-spine formalization

## Scope

The formalization is staged by mathematical dependency rather than manuscript
order.  Its first kernel-checked layer consists of the five noncrossing
matching cubics and their affine covariance and collision vanishing.  Exact
Jacobian-minor identities follow as a separate algebraic layer.  Pfaffian
evaluation and corank-one adjugate factorization are reusable structural
layers.  Specht-module equality, saturation, and Luna-slice descent remain
outside the initial kernel boundary unless separately formalized from explicit
hypotheses.

## Initial acceptance gate

The first module must compile independently with `guarded-lean`, contain no
workflow references, and prove affine covariance plus representative
three-plus-three vanishing over a general commutative ring.

## Formalized layers

The first algebraic layer is `RelativeConicArcs.GoldenMatchingCubics`:

- `matchingCubics_affine` proves affine weight three over every commutative
  ring;
- `matchingCubics_eq_zero_of_threeThree` proves vanishing on the labelled
  representative collision plane.

The exact off-node layer is
`RelativeConicArcs.GoldenMatchingJacobian`.  Its `selectedMinor_eq_det`
connects the explicit four-by-four formula to `Matrix.det`, and
`fourOneOne_minor_identity`, `fourTwo_minor_identity`, and
`fiveOne_minor_identity` are symbolic rational polynomial proofs of the three
generator identities.  They import no computer-algebra certificate.

The structural matching layer consists of
`RelativeConicArcs.WeightedMatchingEvaluation` and
`RelativeConicArcs.GoldenCommutatorPfaffian`.  The former proves the finite,
arbitrary-label termwise product law and its affine weight; the latter proves
that the explicit order-six Pfaffian is the signed fifteen-matching
evaluation.

Finally,
`RelativeConicArcs.CorankOneAdjugate.adjugate_eq_smul_outerProduct_of_generated_kernels`
proves over any field and finite index type that generated one-dimensional
left and right kernels force the adjugate to be a scalar multiple of their
outer product.  The scalar is allowed to vanish; a rank or nonzero-minor
hypothesis remains necessary to exclude that case.

## Trust gate and remaining boundary

`RelativeConicArcs.Gates.GoldenProofSpine` imports these layers and audits
their terminal declarations.  Its module-level boundary explicitly excludes
the Specht-module identification, global scheme saturation, and Luna-slice
descent.  Every source and the import gate passes independent guarded
elaboration.  The exact-target queued build is still required: the first
attempt correctly refused to enter the shared build tree because a foreign
lane owned the build lock.
