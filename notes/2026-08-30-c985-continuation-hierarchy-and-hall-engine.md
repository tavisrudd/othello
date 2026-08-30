# C985 continuation hierarchy and exact Hall engine

**Lane:** `complete-ports`

**Date:** 2026-08-30

## Result

Two reusable non-coding primitives now turn the cross-domain gem scan into
working Ergodis surfaces.

First, `ContinuationHierarchy` compiles a nested family of admissible context
alphabets into a coarse-to-fine tower of exact observational quotients.  The
compiler checks that every alphabet contains its predecessor and that every
new quotient really refines the preceding one.  It retains exact fine-to-coarse
class projections and the first level admitting each generator.  A query can
therefore select the coarsest sufficient quotient and project classes without
allocation.  The hierarchy borrows one base presentation rather than retaining
one cloned transition table per level; replay reconstructs only one temporary
restricted presentation at a time.

The B3 and H3 information-lattice controls use the same API.  Their certified
sheet, intrinsic `(sheet,D')`, and decorated observations compile as

```text
B3: 1 -> 2 -> 6 -> 14
H3: 1 -> 2 -> 6 -> 22.
```

Every retained level replays independently, every decorated class projects to
the direct class at every coarser level, and the allocation-free admission map
selects levels `0/1/2/3` for the empty, sheet, intrinsic-profile, and decorated
alphabets respectively.  This is an API/control result consuming C434's exact
strata, not a new derivation of the finite geometry.

Second, `DenseHallGraph` and `HallWorkspace` implement an iterative exact
bipartite matching oracle for bounded dense restriction graphs.  Construction
allocates one row bitmap per left obligation and a caller-sized workspace.
Repeated solves allocate nothing: epoch-stamped alternating searches reuse
fixed matching, parent, queue, and deficiency buffers and never recurse.  A
positive result exposes a saturating matching.  A negative result exposes the
alternating-reachable set `Z` and its exact neighbourhood with
`|N(Z)| < |Z|`.  An independent verifier checks either witness directly.
Certificates stream through `Write` and replay through `Read`; neither path
requires an aggregate transcript buffer.

An exhaustive control checks all 4,096 bipartite graphs on `3 x 4` vertices
against an independent brute-force matching cardinality and replays every
positive or negative certificate.  Repeated-solve pointer controls show no
workspace growth.

## C80 discriminator

The first C80 acceptance-sequence control is positive for the weakest proposed
restriction relation, direct certificate-reply consumption.  In the q=11
one-to-many witness the two genuinely new defect fibres have old certificate
reply sets

```text
(0,5): {(2,9), (7,10)}
(6,5): {       (7,10)}.
```

The causal-label-only graph, retaining only `(7,10)`, has an exact
deficiency-one obstruction on the two defects.  The complete-exchange graph
has the forced global matching

```text
(0,5) -> (2,9)
(6,5) -> (7,10).
```

Thus the original local update fails for exactly the reason recorded by C80,
while enlarging elimination to the complete exchange repairs this witness.
This is evidence for the Hall-rematching route, not the C80 theorem: the next
mathematical gate must identify how consumed certificate replies transport
ancestral labels soundly, then replay the q23 representatives and retained
corpus under that edge law.  The generic oracle is no longer the blocker.

## Once-validated Pareto objectives

`ValidatedParetoObjective` now binds immutable output and generator-edge
fronts to one exact `FrozenParetoPlan` and ordered monoid.  Construction checks
generator count, output coverage, resource range, strict order, uniqueness,
and pairwise antichain canonicality once.  The repeated evaluator checks exact
plan identity, then compiles range/canonicality checks out of class and product
loops.  The original safe evaluator remains unchanged.

The hostile gate uses equal-cardinality chain and diamond monoids: the front
`{1,2}` is canonical in the diamond and rejected in the chain.  Full all-feature
tests and strict clippy pass.

On the coupled CostRegular control, two clean 20-pair protocols give:

| protocol | old ns | validated ns | ratio | paired t |
| --- | ---: | ---: | ---: | ---: |
| coupled | 4,937.50 | 4,729.25 | 1.0440x | 5.6538 |
| alternating shuffle | 5,390.15 | 5,242.60 | 1.0281x | 5.1170 |

A separate 500,000-evaluation diagnostic counter pair records 2.69% fewer
cycles, 3.79% fewer instructions, 5.26% fewer branches, and 43.36% fewer branch
misses.  Cache misses rose by 13.98% from a very small absolute count, so the
timing protocols, not that single counter pair, carry the speed claim.  Raw
outputs are under `/home/tavis/.cache/ergodis/c985-objective-ab` and are not
paper evidence.

## Commits and validation

- `fe46702dd` — once-validated Pareto objectives;
- `c68239172` — exact continuation quotient hierarchies;
- `2083b648a` — iterative streaming Hall engine;
- `4e146c881` — q=11 C80 direct-exchange gate.

Validation used an isolated persistent target at
`/home/tavis/.cache/ergodis/target-c985-validation`: formatting, strict
all-target/all-feature clippy, the complete all-feature test suite, exhaustive
Hall controls, hostile same-cardinality ordered monoids, hierarchy replay, and
the C80 positive/negative pair all pass.

## Boundaries and next gate

- The hierarchy currently varies the admitted generator alphabet.  It does not
  yet derive the least observation-feature closure or cyclic fixed-point
  semantics.
- Dense row bitmaps are the correct first representation for the bounded C80
  corpora.  A sparse/adaptive backend requires measured density crossover; it
  should not add a representation branch to the inner scan blindly.
- The matching kernel is an iterative augmenting-path engine, not yet
  Hopcroft--Karp or a full Dulmage--Mendelsohn decomposition.  Profile a real
  corpus before importing that machinery.
- The q=11 direct-reply matching does not itself transport ancestral labels.
  C80 still needs edge soundness, strict support descent, and
  opponent-complete entry.
- The full `R^18` enumeration and order-2092 Hadamard search remain separately
  gated.  The continuation tower and streaming certificate boundary are their
  common reusable stepping stones, not authorization for large runs.

The highest-EV continuation is to instantiate the direct certificate-reply
graph on the three q23 replacement representatives, then formulate and test the
weakest projectively natural map from those consumed replies to distinct
ancestral labels.  Any failure should be emitted immediately as the exact
minimal Hall-deficient set.

