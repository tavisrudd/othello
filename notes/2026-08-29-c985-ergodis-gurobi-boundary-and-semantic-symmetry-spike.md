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
and 5.04x in wall time.  These are the original CBC experiment results.  The
Gurobi remeasurement below now closes the stronger-backend gate and shows that
the reduction was not a CBC pathology.

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

## Consumed binary-domain control

The second Rust slice closes that immediate trust-boundary gate for small
explicit models.  `ExplicitBinarySupportProblem` stores a canonical sorted
array of 16-byte `(support, cost)` records over at most 64 coordinates.  Its
constructor rejects empty supports, out-of-range coordinates, and duplicate
support semantics.  `compile_verified_explicit_binary_support` consumes the
model, verifies the coordinate action first, and then checks for every
generator and every feasible support that the image support exists with the
same exact cost.  Only after both checks does it return a
`VerifiedExplicitBinarySupportProblem`.

The consumed artifact has a single independent `verify` entry point that
replays both the orbit certificate and domain invariance.  It rejects a changed
action, a nonpermutation, an absent image support, or a changed objective.
Direct enumeration and one-solve-per-anchor evaluation return the same
canonical optimum on the cyclic control.  The anchored evaluation performs
zero allocations under the repository counting allocator.

This adapter is deliberately an exhaustive small-model oracle, not the qLDPC
representation.  Its role is to make the trust boundary executable before a
theorem-specific adapter is admitted.  The next implementation slice is a
backend-neutral binary linear-model schema plus deterministic LP/MPS emission
and result replay.  It must preserve the same consumed-verification boundary;
the eventual Gross adapter must prove its global non-stabilizer formulation is
equivariant without enumerating feasible supports.

## Streamed external-solver boundary

The third Rust slice exercises model emission and result replay without adding
a proprietary runtime dependency.  For each certified anchor, the bounded
explicit oracle streams a deterministic LP model through `Write`.  One binary
variable selects each canonical feasible support; a fixed-zero dummy keeps
infeasible anchored models syntactically explicit.  The objective, unique
selection constraint, anchor constraint, binary declarations, semantic-model
fingerprint, orbit, and anchor are emitted in canonical order.  The writer,
single-result verifier, and complete-result verifier allocate nothing after the
verified model is constructed.

`AnchoredBackendResult` is a flat 48-byte claim record binding the reduction
fingerprint, orbit, anchor, candidate ID, concrete support, and exact cost.
The reduction fingerprint covers both the canonical source candidates and the
compiled orbit partition, so an identical source model compiled under a
different action is a different artifact.  Replay rejects a mismatched
fingerprint, noncanonical anchor, unknown candidate, altered support or cost,
anchor violation, or suboptimal candidate.  Complete replay additionally
requires exactly one result for every feasible anchored subproblem, rejects
duplicates and omissions, checks infeasible anchors directly, and returns the
exact global optimum.

This remains a bounded trust oracle: its one-hot LP enumerates feasible
supports and its verifier can recompute local optima.  It is not the scaling
qLDPC representation.  The scaling Gross adapter below supplies the compact
parity/relative-code model and uses the available `gurobipy` API rather than an
installed command-line executable.

The 128-bit identity used inside this in-memory spike is explicitly stable and
non-cryptographic.  A persisted or adversarial artifact boundary must replace
or supplement it with a cryptographic digest; it is not an authenticity claim.

## C997 Gurobi round trip

`python/run_c997_gurobi.py` consumes the committed C997 construction as
read-only source input and rebuilds the same three formulations directly in
Gurobi 13.0.2.  It does not merely label `[0, 72]` as certified.  Before model
construction it independently checks:

- CSS commutation and rank 66 for both check spaces;
- that the twelve logical detectors annihilate the stabilizer space and raise
  the stacked check rank from 66 to 78, so their common kernel inside
  `ker(H_X)` is exactly `row(H_Z)`;
- invariance under all 72 translations and freeness on each coordinate block;
- the orbit traversal itself, which derives the two-anchor cover `[0, 72]`.

Every Gurobi incumbent is rounded only within `1e-6` and then replayed exactly
over GF(2).  Replay checks the kernel syndrome, required logical parity or
global non-stabilizer condition, anchor, Hamming weight, and objective.  Solver
logs go directly to files; header, solve, and summary records are flushed to a
create-only JSONL stream, so neither logs nor the audit transcript are buffered
in memory and a rerun cannot silently append a second header.  The evidence
binds the C997 source and both matrices with SHA-256.

The clean single-thread, fixed-seed, zero-gap run gave:

| C997 formulation | solves | nodes | simplex iterations | work units | wall s |
|---|---:|---:|---:|---:|---:|
| per-logical baseline | 12 | 548,921 | 6,549,132 | 149.5250 | 114.6156 |
| global, no anchor | 1 | 475,730 | 1,387,901 | 29.9497 | 25.8026 |
| global + certified anchors | 2 | 26,930 | 215,217 | 4.3639 | 3.8080 |

All fifteen models terminated `OPTIMAL` with objective and bound 12 and zero
gap; every returned witness passed exact replay.  Relative to the conventional
baseline, the complete Ergodis front end used **20.38x fewer nodes, 30.43x
fewer simplex iterations, 34.26x fewer Gurobi work units, and 30.10x less wall
time**.  Global re-encoding alone saved 4.99x work and 4.44x wall time; the
certified orbit cover then saved a further 6.86x work and 6.78x wall time.
Gurobi's deterministic work measure and the node counts reproduced exactly in
the preceding smoke run.  No solver log reported a native symmetry or orbital
reduction pass.

The retained streams are:

- `ergodis/evidence/c997-gurobi-13.0.2-per-logical-seed1.jsonl`;
- `ergodis/evidence/c997-gurobi-13.0.2-global-seed1.jsonl`;
- `ergodis/evidence/c997-gurobi-13.0.2-symbreak-seed1.jsonl`.

`python/check_c997_gurobi.py` validates stream completeness, run identity,
coverage of all twelve logicals and both certified anchors, proof status,
witness weights, and the ratios without requiring Gurobi.

This resolves an important ambiguity about “Gurobi proof certificates.”  The
API exposes exact solve status, incumbent, objective bound, gap, and continuous
LP Farkas information; it also has infeasibility-proof cut machinery inside
MIP search.  Gurobi 13.0.2 did not expose an independently replayable exported
MIP proof through the Python model API or recognized proof file suffixes in the
local probe.  Therefore Ergodis treats `OPTIMAL` plus equal bound as the backend
claim, not as a portable certificate.  The concrete witness is independently
replayed; a fully independent optimality certificate still requires either a
proof-producing backend/encoding or an Ergodis theorem-specific lower-bound
certificate.

## Success and kill criteria

Continue only if the implementation maintains these separations:

- source semantics are not reconstructed from a lossy solver model;
- backend adapters contain no mathematical soundness assumptions;
- generic orbit evidence and domain-invariance evidence are independently
  replayable;
- a returned anchored solution is already a feasible original witness;
- the same compiled reduction can be sent to Gurobi, SCIP, SAT/MaxSAT, or the
  native evaluator.

The qLDPC continuation gate is now positive: a strong backend enlarged rather
than erased the formulation advantage.  The next architectural slice should
make the compact parity model backend-neutral and move the CSS/rank/action
checks behind a typed consumed certificate, leaving `gurobipy` as one thin
execution adapter.  A second backend remains necessary before claiming backend
portability, and repeated clean rounds remain necessary before publishing wall
time confidence intervals; deterministic node and work deltas already
establish the algorithmic result.
