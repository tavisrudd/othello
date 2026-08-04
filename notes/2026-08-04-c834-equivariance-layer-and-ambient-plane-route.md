# C834 — equivariance layer and the ambient-plane route

**Date:** 2026-08-04 · **Lane:** `clebsch` · **Task:** C834 (Paper IV full Lean release closure)

## What this round settles

The shared equivariance layer of the execution plan's stage 2 is written, and the open route
decision on the structural upgrade's two ambient-plane statements is resolved in favour of the
symbolic route, on stronger evidence than the plan assumed.

No Lean was elaborated: the shared build tree's build-owner lock was held by another lane for the
whole session, so the two stage-1 probes did not run and the new Lean sources are committed
unelaborated. Everything that does not need Lean was validated: the transporter generator's
exhaustive checks pass in exact arithmetic over the prime field, and the paper's evidence verifier
passes with the two new artifacts recorded.

## The ambient-plane route: symbolic, confirmed, and cheaper than estimated

The two statements are `uniqueLine_through_two_points` and `uniquePoint_on_two_lines` in
`PassantCodeQ13.StructuralUpgrade`, each currently discharged by native evaluation over the
183-point normalized plane. Three findings settle the route.

**Only one of the two is an obligation.** `PlaneIncident line point` is the vanishing of
`l_x p_x + l_y p_y + l_z p_z`, which is symmetric in its two arguments. The second statement is
therefore the first one with the roles exchanged, and follows from it by commutativity of
multiplication alone. The plan counted two leaves and roughly twelve blocked modules in the
tabulation fallback; the real obligation is one theorem.

**The step the plan called the real obligation is already in Mathlib.** The pinned Mathlib provides
`crossProduct_ne_zero_iff_linearIndependent` in `Mathlib/LinearAlgebra/CrossProduct.lean`: for
vectors over a field, the cross product is nonzero exactly when the pair is linearly independent.
That is precisely "a vanishing cross product forces collinearity", which the plan estimated at sixty
to a hundred and twenty new lines. Two further Mathlib lemmas in the same file supply the rest of
the existence half without any computation: `dot_self_cross` and `dot_cross_self` give incidence of
the join with both points, and `cross_cross_eq_smul_sub_smul` gives the expansion
`L × (p × q) = (L · q) p − (L · p) q`, which is exactly the uniqueness argument: a normalized line
through both points annihilates both, so its cross product with the join vanishes, so it is
proportional to the join, so — both being normalized representatives — it equals the join.

**The remaining work is the normalization dictionary, and it is shared.** What the symbolic route
still needs is that a normalized representative is nonzero, that normalization of a nonzero triple
is a rescaling by a nonzero factor, and that two normalized representatives differing by a nonzero
scalar are equal. All three are now proved in the equivariance module below, because the invariance
argument needs the same facts. The ambient-plane theorem consumes them rather than adding them.

Recommendation, and the basis on which stage 4 should proceed: take the symbolic route. The
tabulation fallback is not needed and should not be built.

## The equivariance layer

`papers/q13-passant-code/lean-certificates/PassantCodeQ13/SymmetricSquareInvariance.lean` states the
mathematics as polynomial identities. A point is the coefficient triple of a binary quadratic form,
a normalized matrix acts by substitution, and both the discriminant `Q(u) = u_y² − u_x u_z` and its
polarization `B(u,v) = 2u_y v_y − u_x v_z − u_z v_x` acquire the factor `(det M)²` under
substitution. Both are homogeneous — `Q(λu) = λ²Q(u)` and `B(λu, μv) = λμ B(u,v)` — so the
normalized parameter `B(u,v)²/(Q(u)Q(v))` is bi-homogeneous of degree zero and unchanged by the
action, including the rescaling that the model applies to normalize the image representative.

Both transformation laws were checked as exact polynomial identities over the integers with sympy
before being written as `ring` goals, as was the adjugate identity
`S_adj(M) ∘ S_M = (det M)² · id` used for injectivity. The only finite content left in the module is
scalar arithmetic in `ZMod 13`, the invariance of the quadratic character under multiplication by a
nonzero square, and the agreement of the indexed internal model with the coordinate model; each is
decided by kernel reduction over a domain of at most a few thousand cases, and none uses compiled
evaluation.

Two consumers in `PassantCodeQ13.Automorphisms.TripleOrbit` are rewritten:

- `matrixAction_preservesRho`, the largest single native enumeration in the package — every one of
  the 2184 matrices against all 78² ordered pairs of internal points — is now the invariance
  theorem applied to a matrix drawn from the displayed list.
- `matrixAction_bijective` was not scheduled for removal by stage 2 and comes free with the same
  machinery. Injectivity of the action on normalized representatives follows from the adjugate
  identity, and surjectivity is injectivity on a finite type. This deletes the second matrix-
  quantified enumeration.

The module header and the rewritten module's header state exactly which theorems still carry a
compiled-evaluation axiom: in `TripleOrbit` those are now only the anchor relation pattern, the
length of the matrix list, and the identification of the anchor-image triples, all of which stage 5
owns.

## Transporters

`lean-certificates/generate_transporter_data.py` emits
`PassantCodeQ13/Equivariance/TransporterData.lean`: for each internal point, the index of a matrix
carrying the base point to it, and for each ordered pair of distinct internal points, the index of a
matrix carrying the displayed representative of its polar class to that pair. The generator refuses
to emit unless the action is exhaustively transitive on the internal points and on each of the six
polar classes, and unless every emitted index is verified to transport as claimed — 78 point checks
and 6006 pair checks in exact arithmetic.

One structural fact fell out of the computation and is worth using downstream: all six class
representatives can be taken with the same first point, `(0, 5)`, `(0, 1)`, `(0, 3)`, `(0, 7)`,
`(0, 8)`, `(0, 15)`. The point stabilizer of the base point is therefore already transitive on each
class of second points, so a pair statement reduces to a single point statement plus six second-point
cases, and the pair table exists only to exhibit the transporting element.

Replay:

```sh
cd papers/q13-passant-code/lean-certificates
python3 generate_transporter_data.py --check
```

with `generate_transporter_data.py` at sha256
`1f6fd28ce7a1fbb23030ff93b0c56f8a498163425234b53cf2ae5d07bf11b187` and the generated
`PassantCodeQ13/Equivariance/TransporterData.lean` at sha256
`900423cd00c10b8551ceb70de24bf69eb3e34cdbd96f9d5c85b512bee8dbb399`. Both files and that command are
recorded in `papers/q13-passant-code/verification/evidence_manifest.json`, and
`python3 verification/verify_evidence.py` passes.

## What the next build window must do, in order

1. Elaborate the association-transport rewrite, in the order given in
   `notes/2026-08-04-c834-association-transport-kernel-closure.md`. It was already first in line.
2. Run the two stage-1 probes:
   `lean/scripts/guarded-lean RelativeConicArcs/…/AssociationTransport/RelationMasks/RhoZero.lean`
   for the measured peak of one kernel evaluation of the normalized polar invariant, and the
   595-element `List.mergeSort` in `WeightTen/Aggregate.lean` for kernel reducibility.
3. Elaborate `SymmetricSquareInvariance.lean` and the rewritten `TripleOrbit.lean`, then rerun the
   package axiom audit: the two rewritten terminals must report only the foundational axioms.
4. Write the Lean side of the transporter check — the theorem that each emitted index realizes its
   transport — and measure it before deciding whether the 6006-entry pair table needs an index
   split. The point table is small enough to check in one module.

## Mystery ledger

- The six polar classes admit representatives with a common first point. This is transitivity of the
  point stabilizer on each class of second points, which the exhaustive computation establishes but
  no structural argument in the package yet explains. It is not load-bearing for anything committed:
  the transporters are checked entry by entry, not derived from it. Its natural explanation is the
  sharp transitivity already recorded for the anchor triples, and the owning successor is stage 4's
  reduction of the per-pair statements.
- Nothing else in this round is unexplained. The invariance is an exact bi-homogeneity statement,
  and both transformation laws were confirmed as identities over the integers before formalization.
