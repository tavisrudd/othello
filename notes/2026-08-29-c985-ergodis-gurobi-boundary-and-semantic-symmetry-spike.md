# C985 Ergodis and Gurobi: product boundary and semantic-symmetry spike

**Date:** 2026-08-29

**Lane:** `complete-ports`

**Task:** C985

**Status:** implementation memo; private; no publication or product claim

## Decision

Ergodis should not compete with Gurobi as a generic mathematical-programming
solver.  Its defensible role is one level earlier and one level later:

\[
\text{domain object}
\xrightarrow{\text{Ergodis}}
\text{smaller certified model}
\xrightarrow{\text{Gurobi/SCIP/Kissat/native}}
\text{optimizer result}
\xrightarrow{\text{Ergodis}}
\text{lifted exact witness}.
\]

Gurobi owns generic continuous and discrete optimization: presolve, strong
relaxations, cutting planes, heuristics, branching, numerical linear algebra,
parallel search, warm starts, and production deployment.  Ergodis should own
mathematical information that is available in the source object but may be
destroyed by its conventional solver encoding: contextual equivalence,
automorphisms, exact hierarchy, relative/coset structure, reusable component
interfaces, and witness provenance.

The product description is therefore:

> A theorem-aware optimization compiler and certifier that turns structured
> domain problems into smaller exact models for established solvers.

The short distinction is:

> Gurobi optimizes the model it receives; Ergodis proves which model should be
> submitted.

## Real overlap

Both systems transform and solve optimization models.  Gurobi presolve can
eliminate variables and constraints, aggregate rows, tighten bounds,
reformulate supported expressions, and exploit symmetry of the submitted
model.  Its callbacks can add cuts and lazy constraints, inject heuristic
solutions, and monitor or alter a solve.  Ergodis likewise reduces state,
eliminates internal interfaces, propagates minima, and retains witnesses.

The boundary is not simply "compiler versus solver": Gurobi contains a strong
compiler and Ergodis contains native exact solvers.  The durable boundary is
the information available to each transformation.

Use this test for every proposed Ergodis reduction:

> Could the reduction be derived solely from the emitted coefficient matrix or
> constraint graph?

If yes, it overlaps directly with solver presolve and is vulnerable to being
absorbed by a mature backend.  If it requires source-level algebra, admissible
contexts, a semantic group action, or a theorem changing the formulation, it
is appropriate Ergodis territory.

Current official Gurobi references supporting this comparison:

- model-and-solve boundary and supported model structures:
  <https://docs.gurobi.com/projects/optimizer/en/current/index.html>;
- current Python model-class overview:
  <https://docs.gurobi.com/projects/optimizer/en/current/reference/python/overview.html>;
- presolve and symmetry controls:
  <https://docs.gurobi.com/projects/optimizer/en/current/reference/parameters.html>;
- callbacks, user cuts, and lazy constraints:
  <https://docs.gurobi.com/projects/optimizer/en/current/features/callbacks.html>;
- infeasibility and IIS support:
  <https://docs.gurobi.com/projects/optimizer/en/current/features/infeasibility.html>.

## What C997 changes

C997 provides a measured example in which the conventional formulation erases
the useful source symmetry.  For the Gross `[[144,12,12]]` code, the semantic
translation group has order 72, but the upstream per-logical formulation
retains only a group of order 2.  CBC's matrix automorphism pass found that
order-2 group correctly.  It could not recover the other transformations
because they were no longer automorphisms of the encoded problem.

Replacing twelve per-logical programs with a class-independent global model
made the source group applicable.  Adding one anchored solve per coordinate
orbit then reduced the measured total from 13,228,127 to 1,010,491 nodes and
from 3,617.3 to 158.1 seconds.  The combined front end was worth 13.09x in
nodes and 22.87x in wall time; the orbit step alone was worth 4.19x in nodes
and 5.04x in wall time.  These are CBC experiment results, not Ergodis or
Gurobi results.  SCIP or Gurobi remeasurement remains the next external-claim
gate.

This changes the proposed product from generic symmetry breaking to a
**symmetry-preserving formulation compiler**:

1. accept a structured source problem and a verified source action;
2. compile an equivariant, class-independent solver model;
3. restrict the search to a certified orbit cover;
4. solve with a backend selected independently of the compiler;
5. lift and check a domain witness.

The first two operations are the part a downstream solver cannot reconstruct
after lossy encoding.

## Soundness boundary

For a group `G` acting on a nonempty-support feasible family `F`, an invariant
objective `f`, and a set `R` containing one representative of every coordinate
orbit,

\[
 \min_{S\in F} f(S)
 =
 \min_{r\in R}\;\min_{S\in F,\ r\in S} f(S).
\]

For any feasible nonempty `S`, choose `p in S`.  If `r` represents the orbit
of `p`, some group element sends `r` to `p`; its inverse sends `S` to an
equally costly feasible support containing `r`.

There are two distinct certificate obligations:

1. **Generic orbit-cover obligation:** every supplied generator is a
   permutation, the compiled classes are exactly its coordinate orbits, and
   every coordinate has a certified path from its canonical representative.
2. **Domain obligation:** the source feasible family and objective are
   invariant under every supplied generator, and every feasible candidate has
   nonempty support.

Ergodis can replay the first obligation without knowing the domain.  It must
not silently assert the second.  A qLDPC adapter must verify it from the CSS
presentation and the global-distance formulation, or carry a separately
checkable theorem-specific certificate.

## Backend relationships

Three execution modes should share the same semantic compiler:

1. **Native replacement.**  Use Ergodis min-plus or finite-state evaluation
   when the exact quotient and separator widths remain small.
2. **Static external front end.**  Emit a solver model, semantic certificate,
   and witness map.  This is the first product and should support at least two
   backends so no proprietary API defines the architecture.
3. **In-solver participation.**  Later, use callbacks for theorem-derived
   cuts, lazy constraints, incumbent canonicalization, or exact subproblem
   bounds.  This is potentially faster but less portable and harder to replay.

A candidate artifact family is:

```text
compiled.{mps,lp,cnf}
semantic-reduction.cert
witness-lift.map
metadata.json
```

The certificate should bind source, compiled model, action, representative
system, backend result, and lifted witness by versioned fingerprints.  Large
records must stream through `Write`/`Read`; the evaluator should not retain the
audit transcript.

## Initial spike

The first Rust slice deliberately stops before a Gurobi dependency:

- compile an abstract finite coordinate action into a nonempty-support orbit
  cover;
- expose one backend-neutral anchored subproblem per coordinate orbit;
- independently replay the existing compact orbit certificate;
- exercise the Gross action shape (`Z_12 x Z_6` on two 72-coordinate blocks),
  which must compile 144 possible anchors to representatives `0` and `72`;
- preserve flat, pre-sized storage and allocation-free iteration over compiled
  anchor requests.

This slice certifies only the generic orbit-cover obligation.  The next slice
must add a domain contract and a tiny explicit binary model whose generator
invariance can be checked exhaustively, followed by an LP/MPS emitter and
backend result/witness replay.  The Gross CSS adapter comes only after that
trust boundary is tested.

## Success and kill criteria

Continue only if the implementation maintains these separations:

- source semantics are not reconstructed from a lossy solver model;
- backend adapters contain no mathematical soundness assumptions;
- generic orbit evidence and domain-invariance evidence are independently
  replayable;
- a returned anchored solution is already a feasible original witness;
- the same compiled reduction can be sent to Gurobi, SCIP, SAT/MaxSAT, or the
  native evaluator.

For the qLDPC application, no performance claim survives until the three C997
Gross formulations are measured on SCIP or Gurobi under the same protocol.
If a strong backend erases the global-versus-anchored gap, retain the global
semantic re-encoding result and narrow the product claim accordingly.
