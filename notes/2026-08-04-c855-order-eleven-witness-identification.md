# C855 — the order-eleven identification, and the retirement of the Dye equality axiom

**Date:** 2026-08-04
**Lane:** `clebsch` (Paper I stream)
**Task:** C855, checklist item "Eliminate the two ad hoc Dye axioms".
**Plan:** `notes/2026-08-04-c855-dye-axiom-elimination-plan.md`, step 7's final clause.
**Deliverables:** `lean/RelativeConicArcs/Q11GoldenHexagonWitness.lean`, and the conversion of
`RelativeConicArcs.ClebschDye.dye1991_equality_classification` from an axiom to a theorem in
`lean/RelativeConicArcs/Q11DyeAxioms.lean`.

## What was open and what is now closed

The plane-level assembly reported in `notes/2026-08-04-c855-golden-hexagon-assembly.md` proved that
a six-arc with ten triple-concurrence points, over any finite field in which two is invertible, is
the golden hexagon

```
(1:0:0), (φ:1:1), (0:1:0), (1:φ:1), (0:0:1), (1:1:2−φ),   φ² = φ + 1
```

in a suitable frame.  What remained of the equality classification was the order-eleven step: over
the field of eleven elements the golden relation forces `φ = 4` or `φ = 8`, and each root needs an
explicit projectivity carrying its golden hexagon onto the displayed witness.  That step is now
proved, so the second Dye axiom is a theorem and the Paper I rigidity closure carries no
non-standard axiom at any terminal.

## The theorem

`RelativeConicArcs.Q11GoldenHexagonWitness.exists_mapEquiv_toWitness` states that if `A` is a
six-arc of `PG(2,11)` with exactly ten points off `A` on three of its secants, then some linear
automorphism `g` of `(ZMod 11)³` satisfies

```
A.map (ProjectiveCap.Projective.mapEquiv g).toEmbedding = Certificate.pointSet Examples.q11Witness.
```

`RelativeConicArcs.ClebschDye.dye1991_equality_classification` is now a three-line specialization of
it: the triple-concurrence count and the module's own off-arc index-three count are the same
`Finset`, and `IsClebschHexagon` is exactly the displayed conclusion.

## The two projectivities

The golden relation `φ * φ = φ + 1` has exactly the roots `4` and `8` in `ZMod 11`; this is decided
by kernel evaluation over the eleven field elements.  For each root the automorphism is the frame
change sending the normal form's frame `u₀, u₁, u₂` to the standard basis, composed with the matrix
whose columns are listed below, acting on column vectors modulo eleven.

| root | column of `u₀` | column of `u₁` | column of `u₂` | determinant |
|---|---|---|---|---|
| `φ = 4` | `(2, 9, 0)`  | `(0, 9, 3)` | `(10, 7, 4)` | `3` |
| `φ = 8` | `(1, 10, 0)` | `(7, 6, 5)` | `(9, 9, 8)`  | `3` |

The six images agree with the six witness points up to the following nonzero scalars, where the
witness points are listed in the order of the frozen coordinate list `Examples.q11Witness`, namely
`(1:10:0), (1:9:1), (1:4:7), (1:8:5), (0:1:4), (1:1:7)`.

| normal-form point | `φ = 4` image | scalar | `φ = 8` image | scalar |
|---|---|---|---|---|
| `(1:0:0)`     | `(1:10:0)` | `2`  | `(1:10:0)` | `1` |
| `(φ:1:1)`     | `(1:9:1)`  | `7`  | `(1:9:1)`  | `2` |
| `(0:1:0)`     | `(0:1:4)`  | `9`  | `(1:4:7)`  | `7` |
| `(1:φ:1)`     | `(1:8:5)`  | `1`  | `(0:1:4)`  | `1` |
| `(0:0:1)`     | `(1:4:7)`  | `10` | `(1:1:7)`  | `9` |
| `(1:1:2−φ)`   | `(1:1:7)`  | `4`  | `(1:8:5)`  | `9` |

So the two roots reach the witness in orders differing from the list order by the transposition of
the third and fifth entries and by a three-cycle on the last three entries respectively.  Both
matrices are invertible, and the two configurations are therefore projectively equivalent to each
other as well as to the witness.

## Lean shape

Three private steps carry the module.  A triple of vectors with nonzero determinant and a linearly
independent frame give a linear automorphism matching them index by index, through
`basisOfLinearIndependentOfCardEqFinrank` and `Basis.equiv`.  A point equality reduces to a single
scalar: the induced point permutation sends the class of `v` to the class of `w` as soon as `g v` is
a nonzero multiple of `w`.  The frozen coordinate list is turned into an explicit six-element
`Finset` of projective points once, by deciding the list equality and unfolding the image.  The two
reordering lemmas are stated over a bare type with decidable equality, so no `Finset` bookkeeping
happens inside the classical instances on projective points; that is the same precaution the
assembly module needed for its own six-element reordering.

Every arithmetic obligation — the golden roots, the two determinants, the twelve scalar identities,
and the coordinate list — is discharged by kernel reduction over `ZMod 11`.  No native evaluation,
imported certificate, or additional axiom appears.

## Validation

`RelativeConicArcs.Q11GoldenHexagonWitness` elaborates through the guarded single-file entry point
with no errors and no warnings; `#print axioms exists_mapEquiv_toWitness` reports exactly `propext`,
`Classical.choice` and `Quot.sound`.

The gate `RelativeConicArcs.Gates.ClebschRigidityTrust` builds through the build queue.  Its build
log contains 201 axiom reports across the gate and its dependencies, and none of them names a Dye
axiom, a `sorry`, or a compiled-evaluation axiom.  The reverse-import closure of the changed modules
reaches exactly that one gate, so no other gate needed widening.

`lean/trust/areas/relconic.toml` now permits no axiom at all.  The read-only trust audit reports the
same 167 pre-existing errors before and after that edit, all of them in other areas or in the
long-standing unreached-module and undeclared-terminal classes; none is attributable to this change.

## What this does not do

`trust/PORTFOLIO.md` and `trust/graph-manifest.json` are stale against a fresh regeneration, and
were already stale before this change: the portfolio still lists the ten-point bound as a permitted
axiom although that entry was removed when the bound became a theorem.  A regeneration rewrites 644
lines spanning every area, so it belongs to the tooling owner rather than to this task.

The pinned order-eleven certificate package, and with it
`papers/clebsch-rigidity/verification/trust_manifest.json` and the paper's prose about "the exact
two classical Dye assumptions", still describe the classification as an assumption.  Those surfaces
are regenerated against the pinned package, which this change does not touch, so the paper's release
gate is unaffected; refreshing them is the export and re-pin chain, not this step.

The module `RelativeConicArcs/Q11DyeAxioms.lean` now declares no axiom, so its filename no longer
describes its contents.  Renaming it, and the `ClebschDye` namespace with it, changes identifiers
that the pinned package and the paper's trust manifest record, so it belongs with the semantic
rename pass rather than here.
