# C985 Ergodis theorem-import and exact-distance optimization roadmap

**Date:** 2026-08-29

**Lane:** `complete-ports`

**Task:** C985 continuation, informed by C997

**Status:** implementation plan; private; no publication or product claim

## Decision

The C997 Gurobi result establishes the first useful product boundary:

\[
\text{semantic source}
\xrightarrow{\text{Ergodis}}
\text{certified smaller exact problem}
\xrightarrow{\text{Gurobi}}
\text{checked witness}.
\]

The next work should attack three progressively stronger layers:

1. strengthen the generic backend formulation using exact parity polyhedra;
2. quotient entire feasible supports, rather than only choosing a support
   coordinate orbit;
3. recognize theorem domains in which search can be replaced by a compact
   distance certificate.

The immediate experiment is the parity-polytope A/B. It is the cheapest way to
learn how much of the remaining 26,930-node anchored search comes from the weak
mod-2 linearization, and it improves a generic binary-code backend rather than
only the Gross instance.

## Current measured baseline

All figures below use Gurobi 13.0.2, one thread, seed 1, zero MIP gap, the same
Gross `[[144,12,12]]` source, and exact GF(2) witness replay.

| formulation | solves | variables per global model | nodes | work | wall s |
|---|---:|---:|---:|---:|---:|
| per-logical binary slack | 12 | 364 | 548,921 | 149.5250 | 114.6156 |
| global binary slack | 1 | 420 | 475,730 | 29.9497 | 25.8026 |
| global + two anchors | 2 | 420 | 26,930 | 4.3639 | 3.8080 |

The front end is worth 20.38x in nodes and 34.26x in deterministic work. The
remaining questions are whether the relaxation, residual support symmetry, or
the absence of an imported analytic floor is now dominant.

## Import 1: exact parity polyhedra

For a binary vector on a check support `N`, the even-parity polytope is cut out
inside the unit cube by

\[
 \sum_{i\in F}x_i-\sum_{i\in N\setminus F}x_i\le |F|-1
 \qquad(F\subseteq N,\ |F|\text{ odd}).
\]

For a logical parity bit `p`, the relation

\[
p=\sum_{i\in N}x_i\pmod 2
\]

is the even-parity polytope on `N union {p}`. These descriptions are exact for
one parity constraint. Intersecting the local polytopes need not give the full
codeword polytope, but it strictly dominates the current continuous relaxation
without changing the integer feasible family.

Gross physical checks have weight six, hence exactly 32 forbidden-set
inequalities each. Static physical facets are small enough to test directly.
The logical rows are wider, so their facets must be separated dynamically or
represented by a compact parity network; exhaustive emission is not admitted.

### First A/B

Implement a `parity-polytope` physical-check encoding while retaining the
current logical-parity encoding. This isolates the physical relaxation and
removes 216 binary slack variables from every global model.

Measure, for global and anchored formulations:

- root relaxation bound;
- presolved rows and columns;
- nodes, simplex iterations, deterministic work, and wall time;
- model construction time and emitted evidence size;
- exact witness and objective agreement.

Continue if deterministic work improves by at least 1.5x, or if the stronger
root bound suggests that a callback/compact logical parity formulation is the
remaining bottleneck. Kill static physical facets if work regresses by more
than 25% without a compensating route to dynamic separation.

### Second A/B

If the first gate is positive, add allocation-bounded separation for logical
and redundant parity checks. At a relaxation point, find the unique violated
forbidden-set inequality for a supplied check by a pre-sized sorting/index
workspace. Do not solve the NP-hard exact redundant-check separation problem.
Instead, generate candidate redundant checks by bounded GF(2) elimination near
fractional coordinates and by source symmetry orbits, then replay every check
as a row-space combination before admitting its cut.

## Import 2: canonical support orbits

The C997 anchor theorem is exact but is not a full orbit quotient. Under a free
coordinate action, a weight-`w` support can have up to `w` translated copies
across the anchored problems, because any of its support coordinates can be
moved to its orbit representative.

The stronger target is

\[
x\preceq g x\qquad\text{for every }g\in G,
\]

under a fixed lexicographic or colexicographic support order. This selects one
canonical support per group orbit. Candidate implementations are:

- lazy lex-leader cuts;
- canonical augmentation integrated with branching;
- cyclic-necklace constraints specialized to translations;
- stabilizer-chain orbital and lexicographic fixing.

The first Gross experiment should retain the two block types while selecting a
canonical translate inside each support orbit. The anchor and canonical-support
formulations must return the same optimum and replayable witness. Continue if
canonicalization reduces deterministic work by at least 1.5x after accounting
for propagation overhead.

## Import 3: full semantic automorphism discovery

Translations are a supplied subgroup, not a proof of the full automorphism
group. Encode the CSS pair as a colored incidence object whose color-preserving
automorphisms restrict to coordinate permutations preserving both check
spaces. Use an external graph backend only to propose a group; replay every
generator by exact row-space invariance and independently derive its orbit and
stabilizer certificate.

The reusable architecture already exists in `sparse-shadow`: canonical colored
incidence, full automorphism data, point stabilizers, compact generators, and
native/external identity comparison. Import the architecture, not paper-specific
schemas or fixed-size representations.

This gate is positive even if Gross has no larger group, provided the compiler
returns a certified maximal group for bounded instances and produces a compact
verified subgroup for larger ones.

## Import 4: free-cover homology and distance doubling

Gross is a free `Z_2` double cover of a `[[72,12,6]]` BB code. The exact
distance proof decomposes into:

1. a base floor and matching base witness;
2. cover/deck maps `p`, `tau`, and `sigma`;
3. the chain identity `tau p = 1 + sigma`;
4. a Bezout/homotopy certificate for deck-trivial action on homology;
5. safe and dangerous logical sectors;
6. a lower-bound certificate in each sector;
7. a lifted weight-12 logical witness.

Ergodis should define a backend-neutral `FreeCoverDistanceCertificate` whose
verifier reconstructs the chain maps and checks both sector floors. For Gross,
this replaces optimization with certificate replay. For other covers, partial
certificates become sound lower bounds and sector decompositions supplied to a
backend.

The implementation must distinguish:

- generic BB identities;
- free-cover identities;
- group-factor/CRT lemmas;
- polynomial-specific finite classifications.

No theorem registry entry may convert an empirical sweep, SAT result, or
backend optimum into a general theorem-domain rule.

## Import 5: relative weights as the CSS interface

For

\[
C_2=\operatorname{row}(H_Z)\subseteq C_1=\ker(H_X),
\]

the Z-distance is the first relative generalized Hamming weight:

\[
d_Z=M_1(C_1,C_2).
\]

The higher hierarchy

\[
M_t(C_1,C_2)=
\min\{|\operatorname{supp}D|:
D\le C_1,\ \dim D-\dim(D\cap C_2)\ge t\}
\]

is the correct interface for simultaneous logical operators, rank-stratified
lower bounds, and cooperative support. Our shortening--puncturing, exact
confinement, and min-plus composition results already supply the domain theory.

The software target is a labelled relative-support table that retains:

- boundary syndrome;
- relative logical subspace/class;
- exact minimum support or Pareto resource front;
- concrete witness lift;
- source and theorem fingerprints.

This table can compose through concatenation and exact hierarchy, making CSS
distance one application of the general Ergodis interface rather than a
special solver.

## Import 6: separator-rank and matroid decomposition

For a coordinate partition, expose only the syndrome and relative logical data
visible across the separator. Contextual quotienting should merge partial
supports with identical continuation costs. The intended complexity parameter
is separator rank, analogous to trellis width or matroid branchwidth, rather
than raw coordinate count.

This supplies an exact dynamic-programming backend for graph products,
concatenated codes, lifted/balanced products, detector graphs, and recursively
constructed network problems. It also supplies a principled fallback when no
closed-form theorem proves the distance.

## Other portfolio imports

C973 contributes important but different engines:

- successive specialization extracts a deterministic witness with bounded
  symbolic zero tests;
- digit stripping provides a recursive characteristic filtration;
- carrier--nucleus compression reduces high-dimensional PRS geometry to typed
  quotient strata;
- family-wise minimum-support formulas avoid enumerating locator supports.

These should become symbolic finite-field/PRS adapters. They do not presently
strengthen the Gross binary parity model, and should not be inserted into this
benchmark without a real group-algebra selector dictionary.

Quantum MacWilliams/Rains shadow constraints, cleaning/union lemmas, expansion
floors, and systolic bounds are valid future lower-bound plugins. They are
secondary here because they are unlikely to recover the instance-specific
Gross floor without the cover-sector data.

## Architecture and trust boundary

Every imported theorem must have four separate artifacts:

```text
domain recognition
theorem certificate
compiled reduction/model
witness/lower-bound replay
```

Domain recognition is never trusted merely because a caller selects a mode.
The verifier must reconstruct hypotheses from the bound source artifact. Large
evidence streams to files; hot evaluators retain flat IDs, fixed-width records,
and pre-sized workspaces. No recursion is permitted on input-scaled search
depth without an explicit guarded iterative replacement.

Backend status may close a benchmark but is not a portable proof. A concrete
solution is replayed independently; an optimality claim is portable only when
the theorem certificate or proof-producing backend supplies a replayable lower
bound.

## Ordered execution plan

1. Static physical parity-polytope A/B on C997 global and anchored models.
2. Dynamic logical forbidden-set separation if the root relaxation remains the
   bottleneck.
3. Full translated-support canonicalization.
4. Certified full semantic automorphism discovery using the sparse-shadow
   incidence architecture.
5. `FreeCoverDistanceCertificate`, first for Gross and then a second cover.
6. Relative-weight/separator-state compiler and exact hierarchical backend.

At every step, retain the binary-slack C997 run as the same-source control and
report nodes, iterations, deterministic work, wall time, peak memory where
available, certificate bytes, and replay cost.

## Execution checkpoint 1: physical parity A/B

The exhaustive static forbidden-set model was rejected before optimization by
the local restricted Gurobi license: 72 weight-six checks require 2,304 facets,
which exceeds the license's model-size ceiling. This is a deployment constraint,
not a mathematical failure.

Two exact/valid alternatives were measured against a fresh binary-slack control
under the same adapter revision:

| physical encoding | nodes | iterations | work | wall s | root bound |
|---|---:|---:|---:|---:|---:|
| binary slack | 26,930 | 215,217 | 4.3639 | 3.7837 | 4 |
| cascaded exact parity hull | 5,571 | 514,083 | 24.2728 | 13.1430 | 6 |
| binary slack + root FS cuts | 42,322 | 826,285 | 19.8945 | 15.2101 | 5 after cuts |

The cascaded formulation proves that the physical parity relaxation is weak:
the root bound rises from 4 to 6 and the tree has 4.83x fewer nodes. It is still
a decisive backend loss: 1,153 presolved rows and 380 columns cause 2.39x more
simplex iterations and 5.56x more deterministic work. Root-only separation adds
33 cuts per anchored solve with roughly one millisecond of separator time, but
Gurobi's changed search grows to 1.57x the nodes and 4.56x the work. Callback
overhead is therefore not the explanation.

Both variants fail the 1.5x deterministic-work continuation gate. Do not import
either into the production backend. Retain them as negative controls and move
to whole-support canonicalization. The result also suggests that node count is
an unsafe proxy here: a much stronger root relaxation can lose badly through
per-node LP cost.

## Execution checkpoint 2: residual support symmetry

`python/analyze_c997_support_orbits.py` now supplies the acceptance oracle for
the next implementation. It reconstructs all 72 translations of each retained
optimal witness, checks every distinct image against the exact GF(2) kernel and
non-stabilizer semantics, verifies orbit--stabilizer, derives a canonical
support, and counts how many distinct translated supports survive coordinate
anchoring.

The anchor-0 witness has a free 72-element support orbit. Eight translated
supports contain anchor 0 and four contain anchor 72, so the two anchored
models retain exactly 12 representatives of this single support orbit. The
anchor-72 witness has stabilizer order two and orbit size 36; six distinct
translates contain anchor 72. Thus the residual factor is not merely a
worst-case estimate: the two observed optimal orbits retain factors 12 and 6,
respectively. Whole-support canonicalization would retain one of each.

This does not predict an equal branch-and-bound speedup, but it establishes a
concrete target and catches a subtle point: fixing a coordinate consumes its
point stabilizer, not all multiplicity of translated supports satisfying that
coordinate constraint.
