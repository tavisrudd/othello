# C985 ergodis portfolio-theorem import workplan

**Lane**: `complete-ports`

**Date**: 2026-08-29
**Status**: execution in progress; Work Package A packed correctness foundation
landed locally; no external claim or release decision

Progress record:
`2026-08-29-c985-ergodis-commutant-foundation.md`.

This plan turns the portfolio review in
`2026-08-29-ergodis-commercialization-analysis-memo.md` into an ordered
engineering and research programme.  The objective is not to accumulate
domain adapters.  It is to import structural theorems that either reduce the
exact search state, produce cheaper exact exclusions, or add a genuinely new
query class to the same compiler.

## 1. Governing objective and constraints

The target architecture is

\[
 \text{source object}
 \longrightarrow
 \text{verified structural presentation}
 \longrightarrow
 \text{minimal exact boundary state}
 \longrightarrow
 \text{search or elimination}
 \longrightarrow
 \text{lifted witness or checked exclusion}.
\]

Every imported reduction must satisfy all of the following.

1. It is selected from structural input properties, never an instance name,
   expected answer, or benchmark-family lookup.
2. Its hypotheses are verified on the supplied object before the reduction is
   enabled.
3. Witnesses lift to the original object and are independently checked there.
4. A lower-bound certificate states its trust level: replayable witness,
   audited exhaustive computation, or succinct independently checked proof.
5. Hot loops allocate nothing, use iterative rather than depth-proportional
   recursive control, pre-size persistent storage, and retain compressed state
   when the density warrants it.
   Every heavy process runs under `choom -n 1000`; every potentially dense
   compiler preflights a conservative byte bound and refuses unsafe growth.
6. Performance claims use cold and warm measurements, compile/search splits,
   peak RSS, multiround statistics, and held-out families.  A win on a named
   construction is evidence for a mechanism, not permission for a name-based
   policy.

## 2. Priority order

| Priority | Import | Primary effect | First acceptance target |
|---:|---|---|---|
| 1 | commutant and isotypic compiler | compress syndrome and observation state beyond coordinate orbits | gross, BB784, R2Elite, LP1768 |
| 2 | modular and moment presolve | reject whole branches before enumeration | current CSS suite plus passant code |
| 3 | coherent separator contraction | replace flat anchor enumeration by exact recursive elimination | lifted-product and quasi-cyclic codes |
| 4 | rational LP, then SDP, dual certificates | succinct lower-bound exclusions | passant, gross, then an exhaustive-hard qLDPC case |
| 5 | covering-radius and deep-hole query | unify three portfolio lanes and expand the public engine | Clebsch, PRS redundancy five, gross control |
| 6 | Schur-closure observation compiler | derive sufficient feature degree and quotient dimension | `B_3`, `H_3`, automata control |
| 7 | rigidity-backed canonicalization | prove adapter symmetry completeness and deduplicate objects | four-frame and stabilizer-code fixtures |
| 8 | equivariant extension engine | add constructive augmentation and repair queries | Frobenius-invariant eight-arcs |

Priorities 1--3 are the performance spine.  Priority 4 changes the evidence
product.  Priority 5 is the quickest broad application expansion.  Priorities
6--8 generalize the compiler and provide independent fixtures.

## 3. Work package A: commutant and isotypic compiler

### Theorem input

The passant code's hidden `F_8` scalar action, the conic-quotient ranks forced
by irreducible `SL_2` modules, and the symmetry-adapted moment calculations all
say that coordinate orbits are only the first quotient.  A verified group
action may induce a much smaller equivariant state representation even when no
coordinates merge.

### Implementation

1. Given verified generators on coordinates, induce their action on physical
   syndrome and logical-observation spaces.
2. Compute the centralizer algebra over the ground field.
3. Detect certified field or product-algebra factors in the centralizer.
4. Decompose the state into invariant or isotypic blocks, recording inclusion,
   projection, and reconstruction maps.
5. Compile search keys and completion filters in block coordinates.
6. Emit a source-bound certificate checking generator commutation, block
   invariance, ranks, and round-trip reconstruction.

### Gate

The reduced backend must return exactly the same optimum and lifted witness as
the unreduced backend on small exhaustive controls.  On large controls, replay
must verify every witness in original coordinates.  Land only if at least one
held-out family shows either a twofold search-state reduction or a twofold
compile/RSS reduction without a material regression on small instances.

## 4. Work package B: modular and moment presolve

### Theorem input

The integral-secant modular surcharge, Hadamard compression congruence, orbit
lock, character obstructions, and norm-one-torus laws share one form: a cheap
homomorphic image excludes a large concrete search region.

### Implementation

Build a presolve registry whose entries provide:

- a finite additive or ordered target;
- a verified projection from concrete candidates;
- a reachable-set summary by residual weight and boundary state;
- an exclusion explanation that a small checker can replay.

Initial primitives are parity and residue masks, orbit-sum congruences,
projected weight enumerators, low-order moments, and autocorrelation caps.
Compose several small invariants into one packed key when that replaces
multiple unpredictable branches by one table lookup.  Use dense bitmaps for
small dense targets and sorted or succinct sparse sets only when measurements
justify them.

### Gate

No false pruning on exhaustive small instances.  Report candidates rejected,
instructions per candidate, branch misses, cache behavior, compile cost, and
RSS separately.  Keep a primitive only when its total end-to-end effect is
positive on the stratified suite or it uniquely closes an otherwise open
instance.

## 5. Work package C: coherent separator contraction

### Theorem input

The Reed--Solomon polar-contraction work shows that independently classifying
contracted fibres is unsound: removed roots must persist as forbidden boundary
markers.  Exact recovery composition says the same thing positively: scalar
costs do not compose, while labelled intermediate functionals do.

### Boundary state

A CSS contraction state should retain only distinctions observable by a legal
continuation:

- projected physical syndrome;
- logical observation class;
- accumulated and remaining weight;
- connectivity frontier and component obligations;
- forbidden or already-consumed coordinate markers;
- symmetry stabilizer or canonical orbit label;
- witness-lift provenance.

### Implementation

1. Find candidate separators from the Tanner graph, repeated block structure,
   or verified module decomposition.
2. Compile leaf response tables with arena-backed witnesses.
3. Minimize boundary states by contextual equivalence.
4. Precompute restriction edges and rank-stratified full-span envelopes.
5. Eliminate bottom-up with min-plus composition and incumbent bounds.
6. Use an explicit work stack and bounded per-worker scratch; do not recurse
   with instance depth.

### Gate

First prove equivalence against flat enumeration on exhaustive small codes.
Then require a held-out code on which the separator presentation changes the
growth curve, not merely the constant.  Report boundary cardinality at every
level and identify the exact label whose removal first makes the method
unsound.

## 6. Work package D: succinct dual certificates

### Theorem input

The passant PSD certificate, prescribed-hole defect identities, integral
secant envelopes, and Delsarte--Schrijver symmetry reduction provide committed
fixtures for a general exact dual-certificate path.

### Stages

1. Express low-weight nonexistence as exact rational moment constraints.
2. Reduce variables and constraints by verified group orbits and isotypic
   bases.
3. Solve the rational LP relaxation and emit its dual combination.
4. Check the dual using integer or rational arithmetic in a dependency-light
   verifier.
5. Add SDP blocks only after the LP path is complete; rationalize the numerical
   dual and verify the resulting PSD decomposition exactly.

### Gate

The passant code must reproduce its known exclusion without enumeration, and
the gross code is the second independent fixture.  Advance to a hard qLDPC
case only if the certificate is materially smaller and cheaper to check than
the exhaustive record.  Do not call a solver optimality log a succinct
certificate.

## 7. Work package E: covering radius and deep-hole locus

### Query API

Add first-class queries for:

- prescribed-coset leader weight;
- covering radius;
- all deepest syndrome orbits;
- shell counts and stabilizers;
- witness representatives and independent replay;
- extension or completeness consequences supplied by an adapter.

Reuse `confinement`, field, orbit, provenance, and witness machinery rather
than creating a parallel code path.  The public kernel owns the generic query;
domain-specific geometric interpretation remains in adapters.

### Gate

Reproduce the Clebsch uncovered locus and the complete redundancy-five PRS
deep-hole classification on finite fixtures, with the gross-code coset query
as a non-geometric control.  The same result format and checker must serve all
three.

## 8. Work package F: Schur-closure observation compiler

### Theorem input

In the conic-matching quotients, quadratic observations recover the two sheets
and cubic observations recover orientation.  Irreducibility determines exact
quotient ranks without row-by-row enumeration.  Failure of separation is
witnessed by a trade.

### Implementation and gate

Compile successive feature closures

\[
 L,\quad L^{\circ2},\quad L^{\circ3},\ldots
\]

until the admitted observation algebra stabilizes.  Use module decomposition
to predict new rank, and emit either a separating profile or a concrete trade
showing why two states remain equivalent.  Recover the exact `B_3` and `H_3`
ranks and first separating degrees, then run the same path on deterministic
automata and one recovery interface.  Land only if the compiler stops from a
checked saturation condition rather than a user-selected maximum degree.

## 9. Work package G: rigidity-backed canonicalization

Use four-frame continuation rigidity and stabilizer-AME local-unitary rigidity
as adapter-soundness fixtures.  The service should distinguish:

- a verified source automorphism;
- an automorphism of a lossy compiled graph;
- a full-interface automorphism that lifts uniquely;
- an equivalence requiring a finite Clifford rather than a continuous unitary
  search.

The gate is canonical hashes invariant under the admitted source equivalence,
with independently checked lifts for every reported isomorphism and explicit
counterexamples when a pairwise interface has spurious symmetry.

## 10. Work package H: equivariant extension and repair engine

Generalize the Frobenius pair-extension count into an orbit-valued constructive
query.  Candidate mass, invisibility, freshness, and collision redundancy are
separate exact terms, and each returned augmentation carries its source orbit
and witness.  The eight-arc theorem and its exact `PG(2,25)` extremal profile
are the acceptance fixtures.  This package follows the solver and certificate
spine unless a concrete customer or paper need advances it.

## 11. Measurement programme

Maintain three benchmark strata.

1. **Micro-controls:** automata, tiny recovery interfaces, small exhaustive CSS
   codes, and synthetic module/separator families.  These diagnose overhead and
   verify exact equivalence.
2. **Portfolio fixtures:** passant, Clebsch, PRS, gross, BB784, and R2Elite.
   These test whether the imported theorem appears where it is mathematically
   expected.
3. **Held-out external suites:** QDistSAT and other pinned public instances.
   These decide whether dispatch and reductions generalize.

For each change record compile, cold search, warm search, total wall time,
candidate count, instructions, cycles, IPC, branch and cache misses, peak RSS,
thread scaling, evidence bytes, and verifier time.  Use repeated paired runs
and report geometric-mean ratios with paired-log statistics.  Timeouts are
reported as lower bounds at the exact common cutoff; headline cases should be
allowed to finish when practical.

## 12. Execution sequence and decision points

1. Freeze a stable structural baseline and add held-out policy tests.
2. Spike A on the gross and one lifted-product code; retain the certificate
   format even if the first decomposition does not pay.
3. Land the cheapest B invariants that survive end-to-end measurement.
4. Prototype C on synthetic repeated blocks, then one real lifted product.
5. In parallel with later performance work, build the rational-LP half of D;
   SDP starts only after exact LP replay works.
6. Add E once the shared coset-query API no longer needs redesign from A--C.
7. Use F and G to generalize interface discovery and adapter soundness.
8. Defer H unless its constructive query becomes an active deliverable.

After each package, choose among land, revise once, or stop.  A failed speed
gate does not discard a sound theorem: retain its certificate or adapter
primitive if it enables a distinct query, but do not keep it on the default hot
path.

## 13. Expected endpoint

Success is not eight disconnected features.  It is one engine with three
backend modes:

1. exact enumerative search over theorem-compressed state;
2. exact compositional elimination over coherent boundary interfaces;
3. exact dual exclusion with a succinct checker.

The same verified presentation should then answer minimum distance, prescribed
coset, covering radius, recovery, resource, automata, and constructive
extension queries by changing the observation adapter rather than the trust or
witness machinery.
