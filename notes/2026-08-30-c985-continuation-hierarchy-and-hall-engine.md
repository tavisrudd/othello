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

The first C80 mechanism control is positive at the certificate-reply resource
level.  In the q=11
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
while enlarging elimination to the complete exchange repairs the collision at
the reply-resource level.  The reply graph alone is not the final
consumed-label graph because `(2,9)` is not one of the seven old defect labels.

A first projectively natural lift of that resource graph has now passed every
retained representative control.  For a new defect `z`, attacked old
certificate reply `r`, causal move `h`, and consumed old defect label `ell`,
put `z -- ell` when either

```text
ell = r,
```

or `r` is deleted on a new secant and

```text
ell lies on Line(h,r).
```

The q=11 deleted reply `(2,9)` lies with `h=(7,10)` on a line containing the
distinct consumed old defect `(3,7)`.  The exact matching is therefore

```text
(0,5) -> (3,7)   [deletion-secant edge]
(6,5) -> (7,10)  [direct consumed-reply edge].
```

For the q23 Type-I representative, the deletion secant supplies three old
labels `(11,18)`, `(12,15)`, and `(20,14)` for its sole new defect.  Types II
and III supply the causal old label `(20,17)`; they have the identical local
state and move.  The same finite-field incidence code constructs all four
graphs, and the Hall engine saturates each.

The associated conditional transport lemma is combinatorial.  If this equivariant
restriction graph has a matching from all new defects into consumed old
labels, retain the surviving labels and assign each new defect its matched
consumed label.  Matching injectivity prevents new/new collisions; consumption
prevents new/retained collisions.  Whenever the consumed-label count exceeds
the new-defect count, the support cardinality decreases strictly.  What remains
open is the field-uniform Hall inequality for this incidence relation and
opponent-complete entry.  The q11/q23 representatives are positive controls,
not that theorem.

### Bounded hostile q=11 scout: exact obstruction

The very first complete exchange tested by a deterministic 100-state q=11
hostile scout disproves the proposed deletion-secant Hall relation and the
strict support-cardinality surplus in their present forms.  The exact state is

```text
A = {(0,0),(1,7),(5,4),(7,6)},
o = (4,9),
h = (6,1).
```

Before the exchange the old defect labels are exactly `{(4,9),(6,1)}`.  The
intermediate defect locus is empty.  After `o,h`, the genuinely new defects are
exactly `{(3,5),(9,10)}`.  Both primary bitmask and independent affine-
determinant implementations agree.

The old certificate replies are

```text
(3,5): {(6,1),(10,10)}
(9,10): {(3,8),(6,1)}.
```

The two noncausal replies are deleted on the same causal secant through the
selected pivot `(7,6)`.  Under the direct/deletion-secant consumed-label law,
both new defects have the same singleton neighbourhood `{(6,1)}`.  Therefore
`Z={(3,5),(9,10)}` has `|Gamma(Z)|=1<2=|Z|`; the Rust Hall engine independently
extracts and replays deficiency one.  The other consumed label `(4,9)` has no
edge under this rule.

Moreover, consumed and new support cardinalities are both two, so even the
complete-bipartite relation would not give strict support-cardinality descent.
The overload coordinate does fall `10 -> 0 -> 0` across state/intermediate/
successor, but the successor is not the small boundary and still has exactly
the two displayed defects.  A lexicographic measure with overload before or
after support is therefore a possible stepping stone, not the theorem the C80
handoff currently requests.

This is a successful Ergodis negative: it turns the first apparently natural
edge law into the exact minimal obstruction rather than encouraging a broad
q23 census.  The next proof object must either (i) give the opponent label
`(4,9)` a bounded, projectively natural exchange-motif edge to one of the two
new defects and use a sound lexicographic descent, or (ii) abandon label
matching in favour of a richer global charge object.  Merely making every
consumed label adjacent to every new defect repairs matching but not strict
support descent.

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
- `7c90685ba` — create-only streamed Hall solve/replay CLI;
- `2d2595cca` — projective deletion-secant charge edges on q11/q23 controls.

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
- The projective deletion-secant relation transports distinct consumed labels
  on the original q11 witness and all three q23 representatives, but a bounded
  hostile q11 scout finds an exact deficiency-one exchange with no strict
  support-cardinality drop.  That candidate theorem is rejected.
- The full `R^18` enumeration and order-2092 Hadamard search remain separately
  gated.  The continuation tower and streaming certificate boundary are their
  common reusable stepping stones, not authorization for large runs.

The highest-EV C80 continuation is to inspect the exact two-defect obstruction
for the weakest bounded exchange motif that connects the consumed opponent
label `(4,9)` without using an exception table, and to test whether the exact
overload drop supports a hereditary lexicographic measure.  The higher-EV
Ergodis-platform continuation remains a second flagship adapter, because the
generic hierarchy/Hall machinery has now done its job and exposed the
mathematical boundary quickly.

Reproduction from the repository root:

```sh
nix shell nixpkgs#python313 -c python3 \
  papers/complete-repair-ports/ergodis/scripts/c80_projective_hall_scout.py \
  --q 11 --states 100 --exchanges 10000 \
  --check notes/2026-08-30-c985-c80-projective-hall-deficit.json
nix shell nixpkgs#python313 -c python3 \
  papers/complete-repair-ports/ergodis/scripts/c80_projective_hall_replay.py
sha256sum -c notes/2026-08-30-c985-c80-projective-hall-deficit.sha256
```

The certificate SHA-256 is
`b351d9514d783e60a85cacf543ab9d8ad2021cf4fd9dd6de6c9c67586d92dbc3`.
