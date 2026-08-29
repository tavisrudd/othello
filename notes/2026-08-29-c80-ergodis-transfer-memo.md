# C80 memo: Ergodis tactics for the global Hall-rematching frontier

**Lane:** `cap`. **Task:** C80. **Date:** 2026-08-29.

## Verdict

The highest-value Ergodis transfer is not a generic solver wrapper and not the
parallel bound pulse.  It is exact interface compilation:

> expose one obligation that every successful continuation must discharge,
> compile precisely its admissible repairs, eliminate the internal matching
> state, and expose either a valid boundary response or an exact obstruction.

For C80, the obligation is a genuinely new defect fibre and its repairs are
consumed ancestral labels eligible to charge it.  The resulting exact engine
should either find a global Hall rematching with strict support descent or emit
a minimal support-deficit set.  For a fixed bipartite exchange graph this is a
polynomial matching computation, not an exponential repair search.
Constraint-driven branching enters only in the outer opponent/reply search or
if strict descent introduces coupled choices that ordinary bipartite matching
does not represent.  That distinction keeps the computation a theorem-
discovery and certificate engine rather than a new finite selector.

The transfer is particularly well matched to the q11 falsifier.  That witness
kills causal one-label transport but retains global surplus: seven old labels
disappear while two new defects arise.  It therefore says to enlarge the unit
of elimination from one causal move to the complete exchange, not to abandon
label transport.

## 1. Exact interface to compile

For a selected residual state `A`, opponent move `o`, and legal reply `h`, let

```text
L(A;o,h) = consumed ancestral labels across the complete exchange,
N(A;o,h) = genuinely new defect fibres after the exchange.
```

The first task is to define a projectively natural bipartite graph

```text
G(A;o,h) = (N(A;o,h), L(A;o,h), E(A;o,h)).
```

An edge `z -- ell` must mean that label `ell` can soundly absorb the charge of
new defect `z`, with all data recoverable from bounded projective incidences.
It cannot mean merely that a finite search happened to pair them.  Candidate
edge definitions should be tested in increasing order of enrichment:

1. direct certificate-reply consumption;
2. direct consumption plus the secant that deletes the remaining certificate;
3. the complete causal certificate fibre, including endpoint side effects;
4. a bounded exchange motif carrying the old label through one replacement.

Use the weakest definition that covers the q11 witness and the certified q23
replacement corpus.  If none does, the first uncovered exchange is the next
mathematical datum; do not repair coverage with an explicit exception table.

The compiled state is not the whole residual game.  It is the exact response
object needed by this proof attempt:

```text
(new-defect mask, live ancestral-label mask, restriction edges,
 support potential, Omega stratum, boundary flags).
```

This is observational state relative to the Hall/descent continuation, not a
claim of a universal finite residual signature.

## 2. Target theorem package

The desired local theorem for every admissible complete exchange is

```text
for every Z subseteq N(A;o,h),  |Gamma(Z)| >= |Z|.
```

Hall then gives an injection from new defects to consumed labels.  The
injection alone is insufficient: the charged successor must also satisfy a
strict well-founded decrease.  The preferred target is

```text
ancestral support(next) < ancestral support(A)
```

under literal finite-set inclusion.  If replacement makes literal inclusion
false, use a theorem-derived lexicographic measure whose first coordinate is
strict support cardinality and whose remaining coordinates are already sound,
such as `Omega` and defect rank.  Do not fit a scalar score to the corpus.

The full C80 package still needs three statements:

1. **exchange soundness:** every matching edge is a valid charge transport;
2. **Hall plus descent:** a complete matching exists and strictly decreases the
   hereditary support measure;
3. **opponent-complete entry:** every opponent fibre from an escape root has a
   reply entering the charged survivor.

Only the third statement releases C82.  A Hall theorem on selected exchanges
alone is valuable progress but is not the odd-plane crown.

## 3. Exact Hall oracle and constraint-driven outer search

For each fixed exchange graph, decide Hall with a maximum-cardinality matching.
Use forced degree-one peeling as preprocessing, then an iterative augmenting-
path or Hopcroft--Karp implementation over bitset neighbourhoods.  If the
matching saturates every new defect, return the matching as a replayable charge
assignment.  If it does not, alternating reachability from unmatched defects
yields an exact Hall-deficient set `Z` with

```text
|Gamma(Z)| < |Z|.
```

Minimize that certificate by deletion and independently replay every vertex,
edge, and missing neighbour from affine/projective incidences.  The
Dulmage--Mendelsohn decomposition canonically separates forced, balanced, and
deficient blocks and is therefore both a reduction and a structural datum for
the eventual proof.

There is no value in enumerating matchings merely to decide whether one
exists.  Ergodis-style constraint-driven branching applies one level outside
the Hall oracle.  When searching for an opponent-complete reply or a strict-
descent charge realization:

1. peel forced degree-one defect/label pairs;
2. query the exact Hall oracle for each geometrically admissible reply;
3. choose the opponent fibre or descent obligation with the fewest surviving
   replies;
4. branch only on those replies;
5. exclude earlier choices in later siblings, making the branches disjoint;
6. stop immediately at `B_cc`, another proved boundary, or an exact deficient
   component.

If strict support descent depends on interactions between several matching
edges, first ask whether those interactions can be encoded as capacities,
matroid constraints, or a bounded exchange block.  Only if the resulting
feasibility problem is genuinely beyond ordinary matching should the engine
branch on a minimum-domain defect and its incident labels.  In that case the
first-true exclusion chain makes parallel seeds partition the proof space
rather than repeat it.

Before branching, compute the Dulmage--Mendelsohn decomposition of the current
restriction graph.  It can expose:

- forced edges and contractible balanced blocks;
- independent balanced components;
- an overconstrained component containing a Hall obstruction;
- the smallest component in which search is actually necessary.

The entire engine should be iterative.  Pre-size its matching, BFS/DFS queue,
outer-search frame, and bitset arenas from the compiled instance; allocate
nothing in the augmenting-path, propagation, or branching loops.  Represent
neighbourhoods by the smallest measured exact format: dense machine-word
bitmaps for the present bounded corpora, switching to sparse sorted blocks only
if density measurements justify it.

## 4. Theorem-driven reductions before micro-optimization

Apply these reductions in order:

1. **Projective orbit anchoring.** Search one representative per stabilizer
   orbit of `(A,o,h)` and transport certificates back explicitly.
2. **Forced-edge contraction.** Degree-one repairs are theorem-level choices,
   not search nodes.
3. **Balanced-component elimination.** A component already certified to have a
   perfect matching composes through its exposed labels and need not remain in
   the live state.
4. **Deficiency envelope.** Precompute restriction edges and cheap exact lower
   bounds on unmatched demand for every rank stratum.
5. **Boundary termination.** Stop when the charged successor reaches `B_cc` or
   another already-proved hereditary P boundary; do not enumerate below a
   theorem-complete interface.
6. **Conservative completion filters.** A projected/Bloom filter may admit
   extra candidates but must never reject an exact completion.  Every terminal
   claim receives a full-incidence check.

The likely order-of-magnitude gain is in steps 2--5.  SIMD and cache tuning
come after candidate counts show that the theorem reductions have stabilized.

## 5. Parallelism and pulse scope

Compile whole disjoint fail-first levels until there are several coarse seeds
per worker.  Give each task a private pre-sized workspace and merge results
deterministically.  Avoid a shared hot work queue.

A pulse is useful only during a search for the *first minimal obstruction*.
Workers may publish a monotone best obstruction key such as

```text
(field order, support size, deficient-set size, orbit index)
```

and poll cache-line-separated local mailboxes at coarse branch boundaries.
This can suppress searches that cannot improve the retained counterexample.
It does not help certify Hall on all exchanges, where every orbit remains a
must-search obligation, and it cannot replace opponent-complete proof.

Evidence should stream to a create-only file outside the hot loop.  Workers
retain only bounded local certificate records and counters; the coordinator
writes canonical records after deterministic reduction.

## 6. Contextual quotient: useful but rank-stratified

C80 has already settled negatively the existence of the relevant fixed finite
exact residual signature: sealed conic subsets give unbounded P-valued
`Y_NK` heights.  Therefore the valid Ergodis question is narrower:

```text
which exchanges are indistinguishable by every Hall/descent continuation
inside a fixed defect/support/Omega stratum?
```

Quotient only after an outcome-compatibility gate on q11/q13/q17/q19/q23.
The quotient key may include a canonical Dulmage--Mendelsohn type, defect-rank
profile, and projective boundary response.  It must never merge states merely
because low-dimensional feature vectors agree on the finite corpus.

This restricted quotient could compile recurring exchange blocks and later
serve C82, but it is a second-stage reduction.  Defining the sound edge
relation and testing Hall surplus come first.

## 7. Acceptance sequence

The cheapest discriminating sequence is:

1. reproduce the q11 one-to-many witness and require Hall surplus;
2. replay all three certified q23 replacement types and their projective
   orbits;
3. sweep the full retained q23 canonical control corpus, emitting the first
   deficient set if one exists;
4. test the first unexhausted prime-power domains selected by the C80 handoff;
5. only after those gates, attempt the field-uniform incidence/Hall proof;
6. once Hall plus descent is proved, test opponent-complete entry and release
   the resulting geometric family to C82.

For every finite positive, report the exact domain and stop condition.  A
corpus-wide pass is evidence about the edge definition, not a uniform theorem.

## 8. Routes this memo does not reopen

This plan does not authorize:

- a fixed finite residual signature;
- another scalar feature selector;
- a value/minimax lookup hidden inside the interface;
- a growing explicit matching table as the proof object;
- more q23 orbit enumeration without testing a stated edge definition;
- local one-causal-label nonpacking, which the q11 witness disproves;
- pulse, SIMD, or parallelism as substitutes for strict support descent.

## EV assessment

The first high-EV move is to implement the exact restriction graph on the q11
witness and q23 corpus, with a polynomial maximum-matching oracle,
Dulmage--Mendelsohn decomposition, forced-edge peeling, and deficient-set
extraction.
This is a small enough spike to falsify a bad edge definition quickly, while a
positive result produces precisely the incidence object needed for the
field-uniform theorem.  The most valuable outcome is not a faster census; it is
a minimal, projectively interpretable Hall obstruction or a stable edge law
surviving every retained certificate class.

## Mystery ledger

- **[OPEN -- C80] What is the weakest projectively natural charge edge?** The
  q11 and q23 certificate classes are the first gate; no definition has yet
  passed both.
- **[OPEN -- C80] Does global Hall surplus hold uniformly?** The q11 witness
  has cardinality surplus `7 -> 2`, but cardinality alone does not control all
  subsets.
- **[OPEN -- C80] Which support measure descends under replacement?** Literal
  deletion failed for `F_del`; the successor must be derived from the charge
  semantics rather than fitted.
- **[SETTLED for architecture] Is generic pulse broadcast the main transfer?**
  No.  It is useful only for minimal-obstruction search; exact Hall elimination
  and constraint-directed outer search are the central transfer.
- **[SETTLED negative] Can a universal fixed finite quotient carry the proof?**
  No, by the existing sealed-conic-height obstruction.  Only a rank-stratified
  contextual quotient remains legitimate.

go C80 cap define the consumed-label/new-defect restriction graph and run the q11/q23 Hall-deficit gate
