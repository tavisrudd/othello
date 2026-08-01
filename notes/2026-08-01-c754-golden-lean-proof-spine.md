# C754 Golden Lean proof-spine formalization

## Scope

The formalization is staged by mathematical dependency rather than manuscript
order.  Its first kernel-checked layer consists of the five noncrossing
matching cubics and their affine covariance and exact collision evaluation.  Exact
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
- `matchingCubics_eq_rainbow_of_threeThree` proves that on the labelled
  representative `3+3` plane the first four noncrossing products vanish and
  the rainbow product is `(x 2 - x 5)^3`.

The original all-zero target was false: at `(u,u,u,v,v,v)` the fifth matching
is `(u-v)^3`.  The exact gate exposed the error before manuscript use.  This
is the expected Segre geometry: a `3+3` configuration maps to a node rather
than to the matching base locus.

The exact off-node layer is
`RelativeConicArcs.GoldenMatchingJacobian`.  A definitions-only base proves
`selectedMinor_eq_det`, connecting the explicit four-by-four formula to
`Matrix.det`.  The `4+1+1`, `4+2`, and `5+1` identities live in separate
modules and are collected by a light aggregator.  This cross-module sharding
bounds elaborator memory; each leaf is a symbolic rational polynomial proof
and imports no computer-algebra certificate.

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
descent.  The exact-target durable gate passed in run
`20260801-193652-35d61652`: the definitions base, three identity leaves,
aggregators, and terminal gate built serially, followed by a successful
trace-only aggregate check.  The terminal axiom audit reports only Mathlib's
standard `propext`, `Classical.choice`, and `Quot.sound`; it exposes no
task-specific axiom, admitted declaration, or native-evaluation oracle.

## Manuscript proof-spine implementation

The manuscript now presents one universal matching quotient and its unique
normalized marked skew lift.  One matching expansion supplies the Pfaffian,
middle-exterior, triangle-holonomy, and spectral-compound descriptions.
The source orbit and Segre conormal feed one primitive-kernel cofactor lemma.
The rank-one tensor slice and two-row Specht-ideal theorem replace the
load-bearing local and base-scheme eliminations, while the appendix retains
all three exact unstable-chart identities and the saturated-slice argument
needed for global off-node exclusion.

The standalone marked-rigidity corollary and repeated pole/covariance and
character calculations have been absorbed into the principal square.  The
reader-visible matching expansion, spanning-tree proof, node local model,
cofactor mechanism, pole obstruction, and exact trust boundary remain.  The
warning-free draft is 18 pages; the two-page increase replaces opaque
elimination dependencies with general human proofs rather than adding a new
shadow branch.

C755's literature audit was applied before closeout.  The manuscript now
attributes the centered-square Segre--Igusa map to Howard--Millson--Snowden--
Vakil, the mystic-pentagon and order-six two-graph layer to HMSV and
Bussemaker--Mathon--Seidel, the order-ten ETF/conference object to the
classical conference-frame literature, and the Fano-component geometry to
Gripaios--Nguyen.  The paper's asserted contribution is restricted to the
surviving marked operator, Pfaffian, golden-compression, adjugate,
balanced-cut, and control-realization layers.  The attribution-refreshed
draft passes `make check` at 18 pages.

The C704/C705 central normalization checks, C728 spinor checks, and C743
off-node and node-normal-form checks all pass together with their independent
replays.  The paper verification README and C735 theorem/proof/page ledger now
record the compressed dependency graph and the exact formal boundary.

## Closeout `ej` + `tt` and mystery ledger

The cheap strengthening exposed by the gate is mathematically useful in the
paper: the rainbow value `(u-v)^3` gives the elementary distinction between a
critical `3+3` orbit and the four-equals matching base.  The OOM red-team also
improved the permanent artifact: the three chart identities now elaborate in
separate leaves rather than relying on cumulative state in one symbolic file.

The compression stops at the right type changes.  Matching evaluation explains
the exterior, Pfaffian, and spectral compounds; quotient geometry explains the
base, critical slice, and cofactor.  Merging those two mechanisms would hide
the Segre equation and source-orbit input.  The pole-marked spectral block,
global saturation, and representation-theoretic frame remain explicit rather
than being compressed into a false universal object.

| feature | status | exact boundary |
|---|---|---|
| whether a `3+3` collision lies in the matching base | settled negatively | four noncrossing products vanish, while the rainbow product is `(u-v)^3` |
| whether the three unstable-chart identities require a CAS oracle | settled negatively | three sharded symbolic kernel proofs, with independent exact replay |
| whether the formal gate proves the Golden simplex frame or multiplicity one | settled negatively | representation-theoretic input remains outside the audited Lean closure |
| whether the formal gate proves global off-node saturation | settled negatively | exact chart leaves are formal; orbit exhaustion and strongly etale saturation remain human geometry |
| whether the pole-marked MCM pair has a useful compactified pushforward | genuine separate branch | requires a separately allocated compactification task; it does not compress the present proof |

No genuine mystery remains in the formalized algebraic layer.  The one open
branch is outside this task's proof graph and is not needed by the manuscript.
