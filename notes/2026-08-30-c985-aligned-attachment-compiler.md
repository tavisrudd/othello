# C985 Ergodis aligned-attachment compiler

**Lane:** `complete-ports`

**Date:** 2026-08-30

## Decision

C880's unresolved exact attachment value `15 <= g(8) <= 17` is a strong
Ergodis application target.  Its apparent context space—every known two-graph
and every pair of attachments—has an exact cut quotient.  The quotient turns
the problem into 127 bounded bipartiteness tests and supports native
counterexample-guided search, streamed SAT, and lazy MIP from one semantics.

No value of `g(8)` is claimed in this checkpoint.  The published 17-query
witness replays, while the 16-query exclusion is still a solver obligation.

## Exact reduction

Let `e` be the known graph and `x,y` two normalized attachments.  Put

\[
 f=e+\delta x,\qquad z=x+y.
\]

On a triple `T`, the alignment answer for `x` says that the three edges of
`f|T` are all equal.  If `z|T` is constant, the two attachments give the same
answer.  Otherwise `T` has a singleton on one side of the cut of `z` and two
points on the other.  The answers differ exactly when the two cut edges from
the singleton have equal `f`-colour.

Thus a selected triple imposes an inequality between two vertices of a graph
whose vertices are the cut edges.  A family fails on the cut precisely when
this constraint graph is bipartite; a 2-colouring supplies the exact failing
context.  It separates the cut precisely when the graph is non-bipartite.
This is a global cut-edge graph: the constraints do not decompose into
independent vertex links because one cut edge belongs to both endpoint stars.

This proves the context quotient:

\[
 (e,x,y)\longmapsto
 \bigl(z,\;f|_{z^{-1}(0)\times z^{-1}(1)}\bigr).
\]

At eight points the complete streamed context family has

\[
 \sum_{s=1}^7 {7\choose s}2^{s(8-s)}=4,244,480
\]

clauses over only 56 query variables.  The generated at-most-16 SAT model has
952 variables and 4,270,072 clauses including its generic slot encoding.  It
is written directly to persistent cache; the clause corpus is never buffered
in RAM or written to `/tmp`.

There is a second, much smaller exact formulation.  A graph is non-bipartite
iff it contains an Eulerian subgraph with an odd number of edges: one direction
selects an odd cycle; in the other, an Eulerian subgraph decomposes into cycles,
and odd total size forces an odd one.  For every cut, select witness triples,
require witness-to-query implication, even degree at every cut edge, and odd
total witness size.  Tseitin XOR chains compile the at-most-16 decision to
20,537 variables and only 89,724 clauses.  The CNF is 325 KiB; the complete
colouring expansion is 32 MiB.

## Implemented trust boundary

- `src/alignment.rs` compiles cut-edge incidences once and verifies a selected
  family with fixed 16-entry colour and queue arrays.
- The native counterexample-guided DFS is iterative, uses a pre-sized flat
  duplicate table, and allocates nothing in the search loop.
- `examples/alignment_attachment_cnf.rs` streams the complete reduced CNF.
- `examples/alignment_attachment_compact_cnf.rs` streams the Eulerian/XOR CNF.
- `python/c880_alignment_gurobi.py` is a thin backend: every incumbent is
  replayed by exact cut bipartiteness, violated contexts are closed under the
  `S_3 x S_5` stabilizer of the fixed first triple, and C880's already-proved
  `g(8) >= 15` bound is imported explicitly.

The quotient matches the original four-triple alignment definition for all
1,024 query families at five points.  It independently re-proves `g(5)=9`,
accepts the committed 17-query `g(8)` witness, and rejects a one-query deletion
from that witness.  Strict all-target/all-feature clippy passes.

The compact at-most-17 SAT control is satisfiable.  Its 17 selected query
variables replay as separating in the independent Rust verifier.  The
at-most-16 decision is still running in this checkpoint and writes a binary
DRAT stream directly under `/home/tavis/.cache/ergodis`; it is not yet a result.

## Performance lesson

The first native search filled a 128 MiB duplicate table; merely enumerating
odd-cycle completions repeated too many supersets.  The corrected search asks
for a bipartite colouring of the whole cut-edge graph and branches on the
resulting violated context clause.  This is both more general and exact.

The generic backend should not be asked to rediscover known mathematics.
Importing the proved lower bound reduces the live optimization to cardinality
15 or 16.  Orbit-closing each lazy constraint exposes symmetry that a backend
cannot see in an initially empty lazy model.  Closing under all 40,320 point
permutations was measured and rejected: after fixing the first triple, only its
720-element stabilizer is a model symmetry, and the larger callback cost
dominated the node reduction.

The expanded colouring CNF was stopped after 25 minutes without a result.  It
reached 1.78 GiB maximum RSS.  The compact solver stays near 64 MiB RSS on the
same decision.  A compact Gurobi model is also mathematically valid, but the
installed restricted license rejects its roughly 5,000 witness variables; that
is a license boundary, not a model failure.

## Boundary and next gate

- A Gurobi optimum is not an independently replayable proof of the lower
  bound.  A final exact-value claim needs either the complete streamed CNF plus
  a checkable UNSAT proof, or a smaller structural certificate.
- The native verifier is independent of both solver encodings and is the
  acceptance gate for any returned family.
- If `g(8)=17`, the result sharpens only C880's additive attachment constant;
  it does not change the `9/8` leading coefficient.  Its larger value is as a
  non-coding flagship for theorem-derived exact state compilation.
- The same cut-edge-colouring reduction applies to larger attachment blocks;
  the representation must move beyond one `u64` after eight points.

The highest-EV continuation is to finish the 16-query decision, retain a
replayable certificate, and then extract a human lower-bound motif from the
solver's orbit-closed obstruction family.  That would turn the classical link
criterion and C880's mask computations into corollaries of the more general
cut-context theorem.
