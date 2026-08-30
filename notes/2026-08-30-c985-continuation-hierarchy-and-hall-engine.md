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

The game-semantic scope is narrower still.  Those two defects are the
successor's only legal moves and are mutually conflicting; playing either
leaves no move.  The successor is therefore N, not a candidate P-survivor
reply.  The scout deliberately tested every old-labelled complete exchange,
not only replies already admitted by `F_d`, `B_cc`, or another sound survivor.
Consequently the certificate refutes a universal per-exchange charge law.  It
does **not** refute the opponent-complete existential statement that every
relevant opponent has some different reply satisfying Hall, descent, and a P
boundary.  Any next C80 adapter must encode that reply-admission predicate
explicitly rather than treating an incidence invariant as a game theorem.

This is a successful Ergodis negative: it turns the first apparently natural
edge law into the exact minimal obstruction rather than encouraging a broad
q23 census.  The next proof object must either (i) give the opponent label
`(4,9)` a bounded, projectively natural exchange-motif edge to one of the two
new defects and use a sound lexicographic descent, or (ii) abandon label
matching in favour of a richer global charge object.  Merely making every
consumed label adjacent to every new defect repairs matching but not strict
support descent.

### Surviving quotient: complete exchange plus lexicographic descent

There is a cheaper and more general response state behind the failed graph.
Make every genuinely new defect adjacent to every old label consumed in the
same complete opponent/reply exchange.  This relation is projectively natural
and needs no incidence table.  Hall feasibility then collapses exactly to the
single count inequality

```text
number of consumed old labels >= number of genuinely new defects.
```

The matching engine becomes a verifier/falsifier rather than the hot
algorithm; on this complete relation a direct cardinality test is the exact
theorem-driven reduction.  If the inequality is strict, charged support size
falls.  If equality holds, the next candidate well-founded state is

```text
(charged support cardinality, Omega),
```

ordered lexicographically.

The bounded diagnostic is unexpectedly sharp.  With deterministic seed
`98508030`:

| field/sample | complete exchanges | with new defects | narrow secant Hall failures | complete-relation failures | support-first lex failures |
| --- | ---: | ---: | ---: | ---: | ---: |
| q=11, 1,000 size-four states | 6,866 | 6,458 | 234 | 0 | 0 |
| q=11, 10,000 size-four states | 70,066 | 65,464 | 2,350 | 0 | 0 |
| q=13, 100 size-four states, 10,000-exchange cap | 10,001 | 2,953 | 51 | 0 | 0 |

In the 1,000-state q11 sample, all 234 equal-support cases have the identical
profile

```text
old defect rank / next rank / new count / Omega old / Omega next
2 / 2 / 2 / 10 / 0.
```

The 10,000-state q11 envelope has the same aggregate signature: all 2,350
non-strict cardinality cases still pass the support-first lexicographic test,
and no exchange creates more than two new defects.  The q13 sample reaches four
new defects but every sampled charged support decreases strictly.  These are
deterministic samples, not exhaustive field theorems.

These diagnostics range over old-labelled exchanges, not an opponent-complete
P-survivor reply family.  Their value is state compression and falsification:
they suggest the two scalar inequalities as cheap admission tests, but they do
not prove that an admitted reply exists for each opponent.

This compresses the next C80 question to two scalar inequalities rather than a
growing matching:

```text
consumed >= created,
and consumed = created implies Omega(next) < Omega(old).
```

If those inequalities admit a field-uniform proof, the classical Hall step is
an immediate corollary and Ergodis's minimal interface is just the four counts.
If either fails, the scout emits the first exact exchange.  This is a better
stepping stone than enriching the already-falsified secant graph.

The field split matters.  The equality obstruction is over q=11, whose plane
is already a proved base case in the cap lane.  In the q11 1,000-state sample,
the eight observed `(support drop, Omega drop, old/half/next ranks)` profiles
all have empty intermediate defect locus; the sole zero-support-drop profile
is exactly `0/10/2/0/2`.  By contrast the q13 capped sample has minimum support
drop 16 and minimum overload drop 90 among exchanges with new defects.  This
does not prove monotone growth with q, but it identifies a legitimate theorem
shape: discharge the already-proved small fields separately and prove strict
consumed-label surplus above a field threshold.  That would be a counting
theorem, not a matching theorem.

The missing game-semantic admission predicate is now explicit and implemented
for the proved strict-overload survivor.  A reply is counted only when its
successor re-enters `K_Omega` with strict `Omega` drop and the complete-exchange
charge satisfies support descent, using `Omega` to break equality.  On a
deterministic 1,000-state q11 control, 315 positive-overload survivor states
give 6,124/6,124 admitted opponent fibres and 23,000/23,000 charge-admissible
certified replies.  All are support-equality cases, with minimum `Omega` drop
6.  On a 300-state q13 control, 48 survivor states give 1,930/1,930 admitted
fibres and 10,428/10,428 admissible certified replies; every one has strict
support surplus, with minimum 18.  This replaces the false universal-exchange
quantifier by an exact P-survivor predicate and identifies the live field-split
counting statement.  It does not prove that statement: `K_Omega` membership is
still supplied by the existing certificate engine, and both controls are
sampled.

The admission failure census isolates the hard condition.  All 37,292 q11 and
33,596 q13 legal replies in these positive-overload survivor controls strictly
decrease `Omega`.  Exactly 14,292 and 23,168 respectively fail only because
their successors do not re-enter `K_Omega`; some opponent fibres retain a
single certified reply.  Hence the uniform theorem must prevent hereditary
non-survivor replies from covering a whole fibre.  Scalar overload descent and
aggregate average reply abundance are already insufficient.

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

## Bounded integer-moment compiler fixture

`integer_moments` adds an allocation-free iterative kernel for nondecreasing
integer multisets with prescribed degree, first moment, and second moment.  An
exact convex lower envelope and endpoint-concentration upper envelope reject
unreachable prefixes before descent.  The reusable workspace owns every stack
and accumulator; enumeration performs no recursion and no allocation.  A
fixed-width modular coefficient recurrence then checks the Seidel type-2
divisibility conditions through order 63 without big-integer allocation.

The exact controls reproduce all four integral-subpopulation counts from
C1000's approved Stage 0: `177 -> 6`, `722 -> 28`, `2066 -> 28`, and the
forced-root case `68 -> 6`.  This is a reusable spectral-enumeration primitive,
not authorization for C1000 Stage 1.  It enumerates integer-rooted spectra only;
it neither enumerates the complete real-rooted polynomial population nor
changes any bound on equiangular lines in `R^18`.

## Commits and validation

- `fe46702dd` — once-validated Pareto objectives;
- `c68239172` — exact continuation quotient hierarchies;
- `2083b648a` — iterative streaming Hall engine;
- `4e146c881` — q=11 C80 direct-exchange gate.
- `7c90685ba` — create-only streamed Hall solve/replay CLI;
- `2d2595cca` — projective deletion-secant charge edges on q11/q23 controls.
- `1d49e683e` — game-semantic `K_Omega` admission and q11/q13 counting
  controls.
- `a9f8bfd1e` — iterative residual Hitting Set kernel with canonical streamed
  negative evidence and independent replay.
- `3f6c58ec2` — canonical proof records compressed from 16 bytes to one
  4-byte clause index.
- `c09a015e5` — allocation-counter gate for residual solve, streamed write,
  and replay hot paths.
- `c555de3a5` — mandatory preflight record limit before streamed residual
  evidence emits any bytes.
- `a3cf6cd08` — empty residual clauses emit a one-record proof rather than a
  middle-layer enumeration.
- `d46df230a` — residual workspaces cap stack depth at the 64-element universe
  and normalize oversized logical budgets.
- `def33cd2e` — streamed proof writer/replay exhausted on every three-vertex
  hypergraph and budget.

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

The sharper continuation is now to count bad replies relative to the
`K_Omega` admission predicate: classify the first failed geometric condition,
prove that the bad families do not cover the legal reply line for q at least
13, and retain q11 as the strict-`Omega` equality base.  Do not return to a
universal per-exchange Hall law.

The repeated propose--probe--falsify--redirect loop is specified as a reusable
runtime facility in
[C985 adaptive attack controller](2026-08-30-c985-adaptive-attack-controller.md).
It compiles exact features once and races typed attack-plan bytecode without
rebuilding Rust.  Diagnostic and ordering mutations may evolve freely; a
predicate can prune or admit only through a proof/replay-gated soundness role.

Reproduction from the repository root:

```sh
nix shell nixpkgs#python313 -c python3 \
  papers/complete-repair-ports/ergodis/scripts/c80_projective_hall_scout.py \
  --q 11 --states 1000 --exchanges 100000 --continue-after-issue \
  --p-admission \
  --check notes/2026-08-30-c985-c80-komega-admission-q11.json
nix shell nixpkgs#python313 -c python3 \
  papers/complete-repair-ports/ergodis/scripts/c80_projective_hall_scout.py \
  --q 13 --states 300 --exchanges 30000 --continue-after-issue \
  --p-admission \
  --check notes/2026-08-30-c985-c80-komega-admission-q13.json
sha256sum -c notes/2026-08-30-c985-c80-komega-admission.sha256

nix shell nixpkgs#python313 -c python3 \
  papers/complete-repair-ports/ergodis/scripts/c80_projective_hall_scout.py \
  --q 11 --states 100 --exchanges 10000 \
  --check notes/2026-08-30-c985-c80-projective-hall-deficit.json
nix shell nixpkgs#python313 -c python3 \
  papers/complete-repair-ports/ergodis/scripts/c80_projective_hall_replay.py
sha256sum -c notes/2026-08-30-c985-c80-projective-hall-deficit.sha256
```

The certificate SHA-256 is
`564d92e45dd472beffbf36744baeabbb93e64b89d1ea1a2c3f5a8b69bfb6ed32`.
