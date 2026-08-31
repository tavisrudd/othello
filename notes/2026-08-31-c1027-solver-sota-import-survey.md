# C1027 — Solver state of the art: what to import into Ergodis

**Lane**: `gem-mining`
**Task**: C1027 — survey modern solver and specialized-kernel technique, deliver a ranked
import list.
**Date**: 2026-08-31
**Status**: complete.

This is a read-and-survey report. **No file under
`papers/complete-repair-ports/ergodis/` or `ergodis-private/` was modified.** No
micro-benchmark was written for it; every performance figure below is either measured by a
prior campaign report in this repository (cited by file and section) or attributed to a
consulted external source with its read depth stated.

## Attribution and read-depth conventions

`notes/literature-audit-conventions.md` does not bind this report in full — the deliverable
is an import list, not a novelty or priority claim. Its **Attribution** section does bind,
and is applied as follows.

- Every external source carries a **read depth**: `full text`, `partial (§ named)`,
  `review only` (read a survey or textbook account of it, not the paper), or
  `abstract/metadata only`.
- Bibliographic detail is taken from a source that was actually opened, or omitted. Where
  a title, venue or year could not be confirmed against a consulted source, the entry says
  so instead of guessing.
- A figure or bound taken from a survey is attributed to the surveyor and marked
  *unverified against the primary paper*.
- Sentences beginning "My read" or marked *(mine)* are my inference, not a source claim.

---

## Part 1 — What Ergodis is today, from source

Established by reading the current working tree on 2026-08-31, not from prior reports.
Line counts are indicative of where the mass sits, not a claim about importance.

### 1.1 The kernels that actually carry load

| Kernel | File | Current algorithm |
|---|---|---|
| Exact CSS minimum distance | `papers/complete-repair-ports/ergodis/src/css_distance.rs` | Syndrome-driven exhaustive branch and bound over connected supports |
| Bipartite matching + Hall certificate | `ergodis-private/src/hall_core.rs`, core `src/hall.rs` | Kuhn augmenting-path matching, one BFS per left root |
| Finite fields | core `src/field.rs` | `Prime<P>` const-generic modular arithmetic; `SmallField` full multiplication tables for `GF(p^h)`, order ≤ 256 |
| Exact matrices over `F_q` | core `src/matrix.rs` | Dense row-major `u8` elements, scalar Gaussian elimination via `canonicalize_rows_in_place` |
| Span / rank lattice | core `src/span.rs` | Incremental column-by-column span-lattice BFS, canonical RREF key in an `FxHashMap` |
| Binary linear-code minimum weight | core `src/linear_code.rs` | Full `2^k` reflected-Gray-code walk of the row span, one packed XOR + POPCNT per word |
| Orbit / group action | core `src/orbit.rs`, `src/orbit_compile.rs`, `src/group_action.rs` | Ternary packed orbit syndrome search, with an existing meet-in-the-middle variant; RREF canonical representatives |
| Character sums | core `src/character_sum.rs` | Bit-per-element quadratic-residue table, allocation-free census loop |
| ZDD | core `src/zdd.rs` | Standard unique table + memo caches for `union` / `join` / `avoid` / `minimal` / `count` |
| "SAT" | core `src/sat.rs` | **Not a solver.** A structured-CNF recognizer for graph-colouring instances that emits clique/pigeonhole UNSAT certificates without search |

Two entries in that list deserve emphasis because they are commonly assumed to be
something they are not.

**`sat.rs` contains no CDCL, no DPLL, and no search of any kind.** It streams DIMACS,
reconstructs an incompatibility graph, recognizes complete multipartite structure, and
certifies UNSAT when the number of parts exceeds the number of colours. Its whole public
surface is `certify_multipartite_coloring_unsat` and `certify_coloring_clique_unsat`. Any
"import CDCL technique X into our SAT module" recommendation is therefore a *build*, not an
*import*, and is priced accordingly below.

**`zdd.rs` is crate-private and has exactly one consumer, `applications.rs`.** It is not
load-bearing for any recent campaign. Decision-diagram imports are priced against that
reality, not against its 1,481 lines.

### 1.2 The CSS distance search, in detail

This is the kernel with the most measured load, so its algorithm is worth stating exactly.
`CompiledWideCssDistanceImpl::search_bounded_syndrome_driven` (core `src/css_distance.rs`
around line 1277) is a depth-first branch and bound with the following structure.

- **Connectivity restriction.** The module doc comment gives the reduction: a kernel
  support decomposes into components in the coordinate-adjacency graph, each component is
  itself in the kernel, so a minimum-weight logical operator can be assumed connected. The
  search enumerates only connected supports, rooted at an anchor.
- **Fail-first branching on an unsatisfied check.** `syndrome_branch_options` pops the
  lowest set syndrome bit and branches over that check's neighbourhood minus the current
  support and the forbidden set. This is exactly the "branch on an unsatisfied constraint"
  discipline, i.e. a hand-rolled DPLL restricted to the syndrome-zero target.
- **Canonical enumeration by a forbidden set.** Each frame accumulates `rejected` into the
  child's `forbidden`, so each support is generated once. No duplicate detection, no hash
  set.
- **Two-tier lower bound.** `completion_lower_bound_exceeds` first applies a degree bound
  (`syndrome_weight / max_column_check_weight`, rounded up) with an even-weight parity
  correction derived from `binary_all_ones_functional`; only within
  `SYNDROME_PACKING_ADMISSION_MARGIN = 6` of the cutoff does it pay for
  `syndrome_packing_exceeds`, a greedy disjoint-neighbourhood packing bound.
- **Short-completion filters, i.e. a meet-in-the-middle leaf test.** For a remaining budget
  of at most 3 there are exact completion tables; for budget exactly 4 there is a Bloom
  filter with `FOUR_COMPLETION_BLOOM_BITS = 2^27` bits over projected column-key XORs, with
  `MAX_ENUMERATED_FOUR_COMPLETIONS = 10^7` and `MAX_ENUMERATED_THREE_COMPLETIONS = 10^8`
  guards. On the large backends the triple keys stream into the Bloom filter rather than
  materializing `O(n^3)` `u128`s, and the four-completion rejection is conservatively
  disabled.
- **Width specialization by const generics.** Support/syndrome word counts are
  monomorphized at five widths (`WIDE`=5, `EXTRA_WIDE`=6, `LARGE`=13, `HUGE`=24,
  `COLOSSAL`=28 support words), each with its own persisted-artifact magic.
- **Symmetry reduction by anchors.** The caller supplies a coordinate list; the search runs
  one rooted subtree per anchor. The core does not verify that anchors are an orbit
  transversal. This is the single largest cost lever measured — 42× to 60× on the abelian
  lifted-product codes (`notes/2026-08-31-certified-distance-prototype.md` §7 item 1).
- **Sharding.** `CssSearchShard` expands depth-limited prefixes until it holds at least
  `16 × shard_count`, then keeps those congruent to `shard_index`. Shards do not share
  bounds and re-count the prefix expansion.

What the search does **not** have, relative to modern practice: no learning of any kind
(no nogoods, no conflict analysis, no clause database), no restarts, no dynamic variable
ordering (the branch check is simply the lowest set syndrome bit), no LP or
linear-programming relaxation bound, no dominance rule beyond the packing bound, and no
Brouwer–Zimmermann-style information-set lower bound. Sharded runs cannot share an
incumbent. Every one of those is an import candidate and each is priced in Part 2.

### 1.3 Matching

Both implementations are Kuhn's algorithm: `hall_core.rs` and core `hall.rs` each run a
single-source augmenting search per left root (`augment` / `augment_from`), giving
`O(V·E)`. Neither is Hopcroft–Karp. `hall_core` is the CSR, allocate-once variant used
inside search loops; core `hall.rs` is the dense-bitmap variant with a serializable
certificate. The Hall witness is the alternating-reachable left set from unmatched roots
together with its neighbourhood.

### 1.4 Finite-field arithmetic

`SmallField::from_modulus` builds full `order × order` tables for add, subtract and
multiply plus an `order`-length inverse table, from the lexicographically first monic
irreducible. Element type is `u8`, so `q ≤ 256`; a `q = 251` field costs about 189 KB of
tables, comfortably L2-resident. Every operation is one scalar table lookup. There is no
vectorized, bit-sliced, or word-packed field arithmetic anywhere, and `Matrix` elimination
is element-at-a-time.

`Prime<P>` is a sealed const-generic trait, so a runtime field choice requires a `match`
over prime literals and an external crate cannot supply its own field. The generic
`SmallField` closes the "no `GF(p^h)`" gap recorded in
`notes/2026-08-30-c1018-hunt-prs-deepholes.md` §6 item 1, which is now stale; items 2
(no null-space API), 3 (`const P` forces macro dispatch), 4 (no generic `PG(d,q)`
indexing) and 5 (no orbit closure under matrix-group generators) still stand as of this
reading.

### 1.5 Measured pain points from the campaign reports

Read in full: `notes/2026-08-31-c1018-hunt-756-distance.md` §7,
`notes/2026-08-30-c1018-hunt-prs-deepholes.md` §6,
`notes/2026-08-30-c1018-hunt-plane12.md` (both interface-note sections),
`notes/2026-08-31-certified-distance-prototype.md` §2 and §7,
`notes/2026-08-31-infeasibility-certificate-prototype.md` benchmark section and §"Requests
against `hall_core`".

Ranked by how often they recur and how much they cost:

1. **Shards cannot be seeded with a known upper bound.** Measured: sharding cost **5× the
   enumeration** on `R1Elite02`'s X side, purely because 32 independent shards could not
   share the improved bound that a one-shot search publishes on finding its weight-16
   witness (`certified-distance-prototype` §7 item 2, §4.3). The driver always has a
   candidate bound first. This is a pure-loss item.
2. **Anchors are unverified trusted input.** The 42×–60× symmetry reduction is the largest
   lever in the system and the one fact a verifier cannot re-derive (§7 item 1).
3. **Radius cost growth.** For `[[756,16,d]]`, candidates grow by a factor of about 8.5–8.6
   per two units of radius; closing `d` from below needs a radius-28 exhaustion at roughly
   334,000 core-seconds (4–6 h on a quiet 24-core host), and radius 30 costs another 8.6×
   and is out of reach (`756-distance` §8).
4. **Upper bounds are weak.** Plain Prange over two million trials found nothing at weight
   34 on 756 coordinates, where an ordinary BP-OSD pass reached 44 in 3,262 trials
   (`756-distance` §7 item 4). The core has since gained bounded OSD of order 1 or 2 with a
   default window of 96 (`certified-distance-prototype` §2.2); the request on record is
   breadth over logical classes rather than more OSD depth (§7 item 8).
5. **`hall_core` has no capacity-aware solve.** Callers expand to unit copies, so a
   `sum(demand) × sum(capacity)` incidence blow-up sets memory; the prototype refuses past
   40 million incidences (`infeasibility-certificate-prototype`, "Scale" and §Requests item
   1). Also requested there: per-root deficiency, a first-violation fast path, a fallible
   constructor, warm-start incremental re-solve.
6. **No exact-cover / tactical-decomposition solver.** Both plane-order-12 waves wrote
   their own exact-cover bookkeeping, most-constrained-row ordering and conjugacy
   reduction; `hall_core` was the only library primitive that fitted
   (`plane12` both interface sections).
7. **No general `PG(d,q)` indexing, no null-space API, no orbit closure under matrix-group
   generators** (`prs-deepholes` §6 items 2, 4, 5).

### 1.6 The scale numbers this report prices against

- **Exact CSS distance:** roughly `5·10^11` candidates in 72 minutes on this host — call
  it `1.2·10^8` candidates per second aggregate, across 16 threads at about 1,375% CPU,
  with peak resident memory around 24 MiB (`756-distance` §7 item 6).
- **Hall matching inside a search:** affordable at roughly `10^8` nodes per minute per
  thread, i.e. the per-node exact matching test costs on the order of hundreds of
  nanoseconds (`plane12` wave 2B interface notes).
- **Projective census:** the brief's `10^11`-point ceiling matches the *current* driver.
  `ergodis-private/src/bin/c1018_prs_census.rs` uses `u64` point indices and a one-bit
  visited bitmap, costing `N/8` bytes — `|PG(8,19)| = 1.79·10^10` at 2.2 GB. The
  `2·10^9`-point ceiling in `prs-deepholes` §5.3 is the **superseded** first driver
  (`c1018_prs_deephole.rs`, `u32` indices and one byte per point). Roughly 10 GB of usable
  RAM therefore puts the bitmap ceiling near `10^11` points, consistent with the brief.
  *(mine: the arithmetic, not a measured run.)*
- **Standalone matching at scale:** 8,000 tasks × 1,107 resources, 2.58 M eligible pairs —
  `solve` 191 ms, the matching itself 20 ms, 542 MB peak, dominated by parsing
  (`infeasibility-certificate-prototype`, "Scale").

The shape those numbers impose on the whole survey: **the distance search is
compute-bound at over `10^8` candidates per second per host with a 24 MiB footprint, and
the matching kernel is called at nanosecond-scale budgets.** Any import that adds
per-node work measured in microseconds, or state measured in gigabytes, has to buy a
large constant-factor or asymptotic reduction to pay for itself. That single constraint
rejects more candidate imports below than any other consideration.

---

## Part 2 — The survey

Each entry gives: what it is; the source and read depth; the kernel it touches; the
expected win as concretely as the source allows; implementation cost; and the hypothesis
it needs that our problems might violate. The last field is the one that decides most of
these.

### 2.1 SAT — CDCL as actually practiced

**Sources consulted for this subsection.**

- Biere, Faller, Fazekas, Fleury, Froleyks, Pollitt, *CaDiCaL 2.0*, CAV 2024, LNCS 14681,
  pp. 133–152. **Read depth: partial** — the architecture, technique-inventory and
  proof-format sections of the author-hosted preprint at
  `cca.informatik.uni-freiburg.de/papers/BiereFallerFazekasFleuryFroleyksPollitt-CAV24.pdf`,
  plus the bibliography. Not the API or testing-infrastructure sections.
- Biere, Faller, Fazekas, Fleury, Froleyks, Pollitt, *CaDiCaL, Gimsatul, IsaSAT and Kissat
  Entering the SAT Competition 2024*, solver-description booklet, author-hosted PDF.
  **Read depth: partial** — the Kissat sections on tier limits, vivification and
  congruence closure.
- Kirchweger, Xia, Peitl, Szeider, *Smart Cubing for Graph Search: A Comparative Study*,
  arXiv:2501.17201. **Read depth: partial** — abstract and introduction.
- Szeider, *SAT Modulo Symmetries: A Survey*, CEUR-WS Vol-4116, invited paper.
  **Read depth: partial** — sections 1, 2 and 4 headings.
- Kochemazov, Zaikin, Trofimiuk, Antonov, Semenov, *Using Constraint Solvers to Construct
  Binary Codes with Good Error Correction Performance*, AAAI-26, DOI
  `10.1609/aaai.v40i17.38442`. **Read depth: partial** — abstract, problem encoding
  section, and the `(35,10,12)` and `(40,8,16)` experiment sections. Already in the shared
  cache (fetched 2026-08-27, sha256 `f60528fe…`).

**The state of the art, as these sources describe it.** A leading CDCL solver is now
mostly *not* the CDCL loop. CaDiCaL's central function is
`cdcl_loop_with_inprocessing`, which interleaves search with formula simplification;
the technique inventory in the CAV 2024 paper lists bounded variable elimination,
vivification, instantiation, failed-literal probing, subsumption, gate elimination,
chronological backtracking, rephasing and phase saving, and the SAT Competition 2024
description adds clausal congruence closure with gate extraction and SAT sweeping through
an embedded solver (Kitten) as the major new addition. Learned-clause management is
tier-based: glue (literal-block-distance) limits for tier 1 and tier 2 decide which
clauses are kept unconditionally, which get a second chance, and which are vivified
first; glue is promoted during conflict analysis. Proof logging has moved past DRAT —
CaDiCaL supports DRAT, FRAT, LRAT and VeriPB, and is described there as the first solver
with native LRAT support.

**Applicability to us, item by item.**

| Technique | Our kernel | Verdict |
|---|---|---|
| Fail-first / minimum-remaining-values branch selection | `css_distance` branch choice | **Import — top rank.** See 2.1.1. |
| Bound (incumbent) sharing between parallel workers | `css_distance` sharding | **Import — top rank.** See 2.1.2. |
| Cube-and-conquer with look-ahead cubing | `css_distance` sharding | Import, medium rank. See 2.1.3. |
| Dynamic symmetry breaking (SAT Modulo Symmetries) | design / exact-cover drivers | Import the *idea* via canonical augmentation, not the SAT machinery. See 2.4.2. |
| Clause learning, restarts, phase saving, VSIDS activity, vivification, BVE, congruence closure | none | **Do not import.** See §4. |
| DRAT / LRAT / VeriPB proof logging | `css_distance` certificates | **Do not import literally.** See §4. |
| SAT/MaxSAT encoding of the code-distance problem itself | `css_distance`, `linear_code` | **Do not import.** See §4. |

#### 2.1.1 Minimum-remaining-values branching on the unsatisfied check

*What it is.* The oldest and most reliable constraint-search heuristic: when choosing
which constraint to branch on, take the one with the fewest satisfying extensions, so the
branching factor at the top of each subtree is as small as possible. In CDCL it survives
as the fail-first principle behind decision heuristics; in constraint programming it is
first-fail / MRV.

*Source and read depth.* Described as the fail-first principle in the CaDiCaL 2.0
technique inventory (**partial**) and as the standard CSP heuristic; I did not read a
primary MRV paper for this report, so the technique is cited at **review only** depth and
the expected win below is my own estimate from our source, not a source claim.

*Kernel touched.* `css_distance.rs`, `syndrome_branch_options` (line 1261) and its two
callers.

*What we do today.* `syndrome_branch_options` calls `syndrome.pop_lowest()` — it branches
on the **numerically lowest** unsatisfied check, with no regard for how many options that
check offers. The branching factor is then `|check_neighbors[check] \ support \
forbidden|`.

*Expected win.* Unpriced by any source. The mechanism is exact and the ingredients are
already in place: `check_neighbors[check]` is a precomputed `PackedSupport` bitmap, so
scoring a candidate check is one `difference` and one `popcount` over `SUPPORT_WORDS`
words. Choosing the minimum over the currently unsatisfied checks costs one such scoring
per set syndrome bit. *(mine)* On a syndrome of weight `w` this is `w` popcount passes
against a current per-candidate budget of roughly 8 ns, so the heuristic is not free and
must be gated — the natural gate is the same near-cutoff band that already admits the
packing bound, or a cap of the first `k` set bits rather than all of them. The
`756-distance` campaign measured a candidate growth factor of 8.52–8.62 per two units of
radius; any reduction in the effective branching factor compounds over the ~28 levels the
search must reach, so a 10% branching-factor reduction is worth far more than a 10% time
reduction.

*Implementation cost.* Low. One function, one gating constant, one new statistic. It is
completely local to `syndrome_branch_options` and does not change the enumeration's
correctness argument: the forbidden-set discipline makes every support reachable through
exactly one branch order, and it does not depend on *which* unsatisfied check is chosen —
only that some unsatisfied check is chosen and that its neighbourhood is complete.

*Hypothesis it needs, that we might violate.* **The forbidden-set canonicity argument must
survive a non-static check order.** The current `forbidden` propagation accumulates
`rejected` from the parent frame, which is a set of *coordinates*, not of checks, so my
reading is that it does survive — but this is exactly the kind of thing that silently
turns an exhaustion into a partial search, and it must be proved before the change lands,
not assumed. A second risk: for bivariate-bicycle and lifted-product codes the check
degrees are near-uniform by construction, so the minimum and the median option count may
differ by very little and the heuristic buys nothing. That is measurable in one run
against an existing evidence file: instrument the option-count distribution at each depth
before writing the heuristic.

#### 2.1.2 Sharing the incumbent bound across parallel workers

*What it is.* In parallel SAT, workers exchange learned clauses; in parallel branch and
bound, workers broadcast improved incumbents so every worker prunes against the global
best. This is the parallel-portfolio discipline, and it is the reason a portfolio beats
`n` independent runs.

*Source and read depth.* The parallel-solver landscape is named in the CaDiCaL 2.0 paper
(Gimsatul as the clause-sharing member of the family) — **partial**. The number that
matters here is not from the literature at all; it is measured in our own
`notes/2026-08-31-certified-distance-prototype.md` §4.3 and §7 item 2.

*Kernel touched.* `css_distance.rs`: `CssSearchShard`, the
`search_bounded_syndrome_parallel_pulsed_shard` family, and the
`css_distance_native` command line.

*Expected win.* **Measured, in this repository: 5× the enumeration on `R1Elite02`'s X
side** was spent purely because 32 shards could not share the improved bound published by
the one-shot search on finding its weight-16 witness. The certdist prototype already runs
an ordered-statistics upper-bound pass before the exhaustion, so a global bound is always
available at shard-launch time. The request on record is a plain `--initial-bound
<weight>` compatible with sharding, since `incumbent_support` is rejected when combined
with sharding because it carries certification semantics.

*Implementation cost.* Low for the static half (a flag that seeds `best_weight`), medium
for the dynamic half (an atomic global best weight visible to all threads within a
process, and a shard-record field for a cross-process bound). The static half alone
recovers most of the measured loss because the pre-pass bound is usually the bound the
one-shot search would have found anyway.

*Hypothesis it needs, that we might violate.* The seeded bound must be a genuine upper
bound on the minimum weight of a *nonzero logical* operator, not merely of a kernel word.
If a driver seeds a weight from a kernel vector with trivial logical class, the search
silently under-reports. The guard is to require the seed to come with its support and to
verify `logical_is_nonzero` on it before accepting — cheap, and it makes the flag safe for
a service to expose. Second: a seeded bound changes the candidate counter, and the
prototype already found `candidates` is not a stable replay fingerprint; this makes it
less stable still, so the certificate must continue to compare conclusions, not counters.

#### 2.1.3 Cube-and-conquer with look-ahead cubing

*What it is.* A look-ahead solver partitions the search space into disjoint cubes (partial
assignments), each solved independently by a CDCL solver. The look-ahead phase chooses
splitting variables to balance subtree sizes, which is what makes the partition
parallelize well.

*Source and read depth.* Kirchweger, Xia, Peitl and Szeider, arXiv:2501.17201,
**partial** (abstract and introduction). They report that their best cubing method
achieves **2–3× from improved cubing and parameter tuning, with an additional 1.5–2× on
harder instances**, on combinatorial graph-search problems under a symmetry propagator.
That figure is attributed to those authors and is **unverified beyond their abstract** —
I did not read their experimental section. The AAAI code-construction paper (**partial**)
used `march_cu` for cubing with Kissat for conquering, and reports that the parallel
cube-and-conquer configuration found a `(35,10,12)` code with error coefficient `T = 7`
against `T = 14` for single-threaded Kissat, on 128 cores for one day.

*Kernel touched.* `CssSearchShard`'s prefix partition; the requested `--shard-plan` dry
run.

*Expected win.* Bounded by our own measurement, and the measurement is discouraging.
`certified-distance-prototype` §7 item 5 measured a per-shard spread of **1.01 s to
1.66 s** on one job — a factor of 1.6, "better balanced than expected". Look-ahead cubing
buys balance; if the modular partition is already within 1.6×, the ceiling on this import
is about 1.6× on the tail, not the 2–3× the cubing study reports for its problem class.
The real scheduling win from a `--shard-plan` is cross-machine, not single-host.

*Implementation cost.* Medium. A cost proxy per branch (subtree size estimated by, say,
one bounded-depth probe per branch) plus a dry-run mode.

*Hypothesis it needs, that we might violate.* Look-ahead cubing assumes the cost of
evaluating a candidate split is small relative to the subtree it decides. Our branches are
depth-limited prefixes of a search whose subtree sizes span orders of magnitude and whose
cost model is the syndrome, not a variable count; a cheap proxy may not correlate. And the
5× bound-sharing loss in 2.1.2 dominates the ≤1.6× balance loss, so this must be sequenced
after bound sharing or it will be measured against the wrong baseline.

### 2.2 SMT — theory combination, incremental solving, finite fields

*Sources.* Ozdemir, Kremer, Tinelli, Barrett, *Satisfiability Modulo Finite Fields*, CAV
2023; full version Cryptology ePrint Archive 2023/091. **Read depth: partial** — abstract,
introduction, the Gröbner-basis preliminaries (§2), and the decision-procedure and
`FindZero` sections. Their procedure is implemented for **prime fields** in cvc5 and
combines Gröbner bases with triangular decomposition, plus a proof-tracing mechanism in
the Gröbner engine so it can produce unsatisfiable cores. Their evaluation is on
translation-validation conditions for zero-knowledge-proof compilers, and they report
their implementation superior to encoding field arithmetic through integers or
bit-vectors.

*Kernel touched.* Nothing today. The adjacency is real — our arithmetic lives over `F_q`
— but no Ergodis kernel poses a satisfiability question over a field.

*Where it could touch us.* One place, and it is a genuinely interesting one:
`notes/2026-08-30-c1018-hunt-plane12.md` wave 2B mystery ledger item 4 observes that the
order-12 exact cover has 1,452 slots and 1,452 claims — "perfectly tight, which is
normally the regime where algebraic obstructions exist" — and names the character-theoretic
shadow as the object to attack. Turning "does this tight incidence system have a solution
over `F_p`" into a finite-field satisfiability query is exactly the shape SMFF handles,
and the unsat-core machinery would give a named obstruction rather than a bare "no".

*Expected win.* Not priced. Their benchmarks are ZKP circuits, a different shape entirely,
and they report no figure transferable to combinatorial designs.

*Implementation cost.* High. A cvc5 dependency, an encoding from the design to field
equations, and a translation of any core back into design language.

*Hypothesis it needs, that we might violate.* Three, and they compound. (i) The procedure
is for **prime** fields; our characteristic-two and characteristic-three phenomena are
exactly where the interesting behaviour sits (`prs-deepholes` §6 item 1). (ii) The
Gröbner-basis stage is the known blow-up, and the paper's own framing is that this "often
does not matter" *for their benchmark family* — a claim about ZKP circuits, not about
dense combinatorial systems. (iii) Our obstruction is conjecturally character-theoretic,
i.e. it lives in a representation-theoretic quotient, and a Gröbner basis over the raw
variables need not find it. My read: worth one bounded experiment on a small case
(`n = 6`, where the survivor profile `528, 1611, 30, 0` is already known), never a
dependency, and certainly not before the exact-cover search itself is improved.

*Theory combination and assumption-based cores, separately.* Nelson–Oppen-style theory
combination and the assumption/core interface are the two SMT ideas with the widest
general reach, and neither has a home in Ergodis: we have no multi-theory problem and no
incremental query stream. The one transferable shape is the **unsat core as a product**,
and the `certiis` prototype has already established, with measurement, that a solver's
single unsatisfiable core is the wrong object for our use — see 2.5.2.

### 2.3 Dynamic programming and exact exhaustive search

#### 2.3.1 Transposition tables (state-space compression on the syndrome)

*What it is.* Memoize on the state that determines the remaining subproblem, so an
identical state reached by a different path is not re-solved. The classical
game-tree/dynamic-programming technique.

*Source and read depth.* Standard; cited at **review only** depth. No primary source read
for this report, and no external number is claimed.

*Kernel touched.* `css_distance.rs`, the DFS frame stack.

*What the state actually is.* The bound in `completion_lower_bound_exceeds` depends only
on `(child_syndrome, improvement_budget)`. The completion filters depend only on
`child_syndrome` and the budget. So the *pruning-relevant* state is exactly
`(syndrome, budget)` — a genuinely memoizable key, and much smaller than the full
`(support, syndrome, budget)`.

*Expected win.* Unpriced, and my estimate is that it is negative at full generality.
*(mine)* The search runs at roughly `1.2·10^8` candidates per second aggregate — about
8 ns per candidate — while a probe into a hash table larger than L3 costs on the order of
100 ns. Unless the hit rate exceeds roughly 90%, a general transposition table is a large
net loss, and it would destroy the 24 MiB resident footprint that
`756-distance` §7 item 6 records as a non-limit.

*Where a bounded version could pay.* A small direct-mapped cache (a few MiB, fitting
L2/L3), consulted only at shallow depth where subtrees are large and a hit saves a lot.
This is the standard engineering compromise and is the only version worth trying.

*Hypothesis it needs, that we might violate.* **That the same syndrome recurs often
enough.** The forbidden-set discipline is a canonical enumeration: each connected support
is generated exactly once. Distinct supports can still produce equal syndromes, but there
is no measurement in any campaign report of how often. That measurement — a histogram of
syndrome multiplicity at fixed depth on an existing instance — is the gate, and it is
cheap. Do not write the cache before taking it.

#### 2.3.2 Deeper meet-in-the-middle completion filters

*What it is.* Horowitz–Sahni / Schroeppel–Shamir style splitting: precompute the set of
achievable partial sums for one half, and look up the complement for the other.

*Source and read depth.* **Review only** — the technique is standard and is already
implemented here; no primary source read.

*Kernel touched.* `css_distance.rs`: `compile_completion_filters`,
`compile_large_completion_filters`, `has_short_completion`, `may_have_four_completion`.

*What we have.* Exact tables for completions of size ≤ 3 and a `2^27`-bit (16 MiB) Bloom
filter for size 4, with enumeration guards at `10^7` four-completions and `10^8`
three-completions, and on the large backends the triple keys stream into the Bloom filter
rather than materializing `O(n^3)` `u128`s.

*Expected win.* A 5-completion filter closes one more level of the tree at the leaf. Given
the measured 8.5–8.6× candidate growth per two radius units, closing one additional level
is worth something like a factor of 3 at the leaf frontier. *(mine — an extrapolation from
our growth factor, not a measurement.)*

*Implementation cost.* Medium, and the cost is memory, not code.

*Hypothesis it needs, that we might violate.* **The 24 MiB footprint.** A
5-completion filter over `C(n,5)` keys at `n = 756` is `1.7·10^12` keys; the Bloom filter
would need to be orders of magnitude larger than `2^27` bits to keep a usable false-positive
rate, and the existing `MAX_ENUMERATED_FOUR_COMPLETIONS = 10^7` guard exists precisely
because that enumeration is already at the edge. My read: this is not importable at
`n = 756`. It is importable at the `n ≈ 100–200` sizes where the four-completion filter is
not already disabled, and that is a narrower win than it first looks.

#### 2.3.3 Zero-suppressed decision diagrams and frontier-based search

*What it is.* Frontier-based search (Knuth's Simpath and its descendants) builds a ZDD of
all subgraphs satisfying a constraint by a dynamic program that sweeps a "frontier" across
the graph, merging states that agree on the frontier. It is the standard way to enumerate
exponentially many constrained subgraphs in compressed form.

*Source and read depth.* Kawahara, Inoue, Iwashita, Minato, *Frontier-Based Search for
Enumerating All Constrained Subgraphs with Compressed Representation*, IEICE Transactions
on Fundamentals E100-A(9):1773–1784, 2017. **Read depth: abstract/metadata only**, from
the IEICE and DBLP listings. The Graphillion library paper
(`10.1007/s10009-014-0352-z`) is in the shared cache; **not read for this report**.

*Kernel touched.* `zdd.rs`, which is crate-private with a single consumer
(`applications.rs`) and carries no campaign load.

*Expected win.* Not priced for any of our problems.

*Hypothesis it needs, that we might violate — and this one is fatal.* Frontier-based
search is efficient exactly when the frontier stays small, i.e. when the instance has a
narrow path decomposition. The order-12 plane completion has 1,452 slots against 1,452
claims and is described in the campaign report as "perfectly tight"; a projective
incidence structure has no small separator. The frontier would be the whole instance and
the ZDD would be the enumeration itself. This belongs in the "do not import" section, and
the reason is worth writing down because a ZDD module sitting in the tree makes it a
recurring suggestion.

#### 2.3.4 Treewidth and decomposition-based dynamic programming

Same fate, same reason, and it deserves a separate line because it is proposed
independently of ZDDs. Our incidence structures — projective planes, bicycle codes,
lifted products — are expander-like by design: quantum LDPC codes are good precisely
because their Tanner graphs have no small separators. Any method whose cost is exponential
in a separator width is structurally wrong for every kernel we have. **Do not import**;
see §4. *(mine; no source consulted for this paragraph.)*

### 2.4 Our own specialized methods

#### 2.4.1 Brouwer–Zimmermann minimum-weight computation

*What it is.* Rather than enumerating all `q^k` codewords, maintain an upper bound `U`
(improved whenever a lighter codeword is found) and a lower bound `L` derived from several
systematic generator matrices: a combination of `w` rows has weight at least `w` in each
information set, so `L` rises each time the enumeration moves to a larger combination
size. When `L ≥ U` the true minimum weight is `U`.

*Source and read depth.* Hernando, Quintana-Ortí, Grassl, *Fast Algorithms and
Implementations for Computing the Minimum Distance of Quantum Codes*, arXiv:2408.10743v2
(16 July 2025), also in ACM Transactions on Quantum Computing. **Read depth: partial —
§1 introduction, §2.1 the Brouwer–Zimmermann account and the modified symplectic variant,
§2.2 "Saved 1 Γ", the §3 experimental setup and dataset descriptions, and the headline
results.** Now in the shared cache as `arXiv:2408.10743`, sha256
`6804acd5159314cb3ee60f44447897ea14fae20c3c6122852cab60fb7f6b15e0`, 14 pages.

That paper gives three new algorithms (`Saved 1 Γ`, `Saved 2 Γ`, `Saved isometry`) for the
**symplectic** distance of a stabilizer code — which is our problem exactly — built on the
saving-and-reusing-of-row-additions idea from the same group's earlier single-core and
shared-memory work. Reported result, attributed to those authors and unverified by me:
their implementations were **up to 40× as fast as Magma in the most demanding cases**, and
the earlier `F_2` work they build on was "about two or three times as fast as Magma and
Guava (GAP)". They also note a distributed-memory variant by a third group that "allows the
use of thousands of cores, reducing the total computational time from days to seconds" —
**that claim is theirs about someone else's paper and I have verified neither.**

*Kernel touched.* Primarily `linear_code.rs`, whose entire method is a full `2^k`
reflected-Gray-code walk of the row span. Secondarily, and only as a comparison point,
`css_distance.rs`.

*Expected win.* Structural rather than constant-factor. `2^k` becomes
`Σ_w C(k,w)` truncated at the `w` where `L ≥ U`. For the code families where our
campaigns used exact span enumeration — the bicycle-sector scans and the
translation-invariant subspace scans in `756-distance`, which returned exact minima of 52,
188 and 84 — the ceiling moves from roughly `k ≤ 30` (a `2^30` Gray walk is about
`10^9` XOR+POPCNT passes, seconds to minutes) to `k` in the high tens. Every one of those
scans is a "cheap structured route" that was affordable only because `k` happened to be
small; Brouwer–Zimmermann is what makes the next one affordable when it is not.

*Implementation cost.* Medium-high. It needs multiple systematic generator matrices with
information sets chosen to be as disjoint as possible (a greedy pivot selection over
column permutations), the row-addition-reuse trick to make the enumeration fast, and the
`L ≥ U` termination bookkeeping. The symplectic variant additionally needs the constrained
column permutation the paper describes — any permutation within the first half of the
columns must be mirrored in the second half — and the modified check that a discovered
codeword lies in `C^⊥s \ C` before it may update `U`.

*Hypothesis it needs, that we might violate — and this is the one that decides where it
may go.* **Brouwer–Zimmermann's lower bound climbs at roughly one unit per information
set per enumeration level, and the number of disjoint information sets is about `N/K`.**
For a symplectic instance the classical code has length `N = 2n` and dimension `K = n + k`,
so `N/K ≈ 2` when `k ≪ n`. For `[[756,16,d]]` that is two information sets: reaching
`L = 28` needs combinations of about 14 rows out of 772, and `C(772,14)` is beyond any
budget. The paper's own datasets confirm the intended regime — the largest matrices in
`mat_test3` have at most 12,416 entries in total, i.e. `(n+k) × 2n ≤ 12416`, which puts
`n` in the tens. **Brouwer–Zimmermann must not be imported into `css_distance`.** Our
syndrome-driven connected-support search is the right algorithm for large `n` and small
`d/n`, and Brouwer–Zimmermann is the right algorithm for small `n` and rate far from a
half. They are complementary, and a report that recommended the celebrated one for the
flagship kernel would be actively harmful.

#### 2.4.2 Canonical augmentation and orderly generation

*What it is.* Generate one representative per isomorphism class directly, by accepting an
extension only when it is the canonical one for the object it produces. McKay's
isomorph-free exhaustive generation, backed by a canonical-labelling engine (nauty, or
Traces for hard classes). The SAT community's dynamic analogue is SAT Modulo Symmetries: a
propagator checks partially defined objects for canonicity during CDCL search and learns a
blocking clause when a partial assignment cannot extend to a canonical object.

*Sources and read depth.* McKay and Piperno, *Practical Graph Isomorphism, II*, Journal of
Symbolic Computation 60 (2014) 94–112 — **abstract/metadata only**, from the
`pallini.di.uniroma1.it` site and the arXiv:1301.1493 listing; the paper describes the
refinement-individualization paradigm, brings nauty's description up to date, introduces
Traces, and compares against saucy, Bliss and conauto. McKay's earlier
isomorph-free-generation paper is referred to at **review only** depth — I did not
consult it and give no bibliographic detail for it. Szeider, *SAT Modulo Symmetries: A
Survey*, CEUR-WS Vol-4116 — **partial** (§1, §2, §4 headings): SMS integrates a canonicity
propagator into CDCL through the IPASIR-UP interface, achieves *complete* symmetry
breaking without a prohibitively large initial encoding (a polynomial-size encoding for
full canonicity is not known, so static methods must be incomplete), and has been applied
to extremal graph theory, Ramsey theory, matroid theory and quantum foundations.

*Kernels touched.* The design and exact-cover drivers in `ergodis-private/src/bin/`
(`c1018_plane12.rs`, `c1018_plane12_hyperoval.rs`), and the `anchors` contract in
`css_distance`.

*Expected win.* On the design side, this addresses the campaign's diagnosed failure
directly. `plane12` wave 2B found that the hyperoval assumption **shrinks the residual
symmetry group from `S_11` to a one-row stabilizer, raising the level-2 class count from
56 to 139**, and concluded that "the loss of quotient outweighs the gain in constraint at
shallow depth". A generation scheme that quotients by the full residual automorphism group
at every level, rather than by a precomputed level-2 conjugacy classification, is exactly
the missing ingredient. The measured shape of the problem — depth-3 survivors at
`2.04·10^9` for the hyperoval search against `8.22·10^8` for the general one — says the
win would be at the level of the survivor count, not a constant factor.

*Implementation cost.* Medium for canonical augmentation written against our own search
(no SAT solver needed; the canonicity test is a canonical form of a partial orbit matrix,
which we can compute directly or via a nauty binding). High for full SAT Modulo
Symmetries, which requires a CDCL solver with a user-propagator interface — we do not have
one, and building it is out of proportion to the problem.

*Hypothesis it needs, that we might violate.* Canonical augmentation needs a canonical form
that is (i) cheap relative to a search node and (ii) *compatible with the augmentation
order* — the canonical parent of an object must be reachable by removing the last-added
element. Our augmentation adds a row of an orbit matrix, and the natural canonical form is
lexicographic minimality under the residual group; whether the canonical-parent property
holds for that pairing has to be checked, not assumed, and getting it wrong turns an
exhaustion into a partial search that still looks complete. Second, and specific to us:
`plane12` mystery ledger item 2 records that at `n = 6` the survivor counts go
`528, 1611, 30, 0` — the collapse happens only at the last level. If the same shape holds
at `n = 12`, then isomorph rejection at shallow depth reduces a count that was never the
binding cost, and the method is "structurally wrong for this problem, not merely slow", in
the campaign's own words. **That is the gate: measure whether the residual-group quotient
shrinks the depth-3 survivor count materially at `n = 6` and `n = 10` before building
anything for `n = 12`.**

*The anchor half of this item is separate and much cheaper.* The `certdist` prototype's
first interface request is that the input format carry verified automorphism generators,
with the core checking that each generator preserves the row space of the physical checks
and permutes the nonzero logical classes, that orbits are free and uniform, and that
`anchors` is an orbit transversal. That is ordinary orbit computation — `group_action.rs`
and `orbit.rs` already have the machinery — and it converts the **42×–60×** symmetry
reduction from trusted input into a checked fact. Low cost, and it is the difference
between a certificate and an assertion.

#### 2.4.3 Information-set decoding for upper bounds

*What it is.* Randomized algorithms that find low-weight codewords by guessing an
information set free of errors. Prange is the base case; Lee–Brickell adds a small
weight allowance; Stern and Dumer add a birthday/collision step over two halves of the
information set; MMT, BJMM, Both–May and May–Ozerov add representation techniques on top.

*Source and read depth.* Esser and Bellini, *Syndrome Decoding Estimator*, Cryptology
ePrint Archive 2021/1243, also published in PKC 2022 (`10.1007/978-3-030-97121-2_5`).
**Read depth: abstract/metadata only** — from the ePrint landing page and the Springer
listing. Their framing, attributed to them and **unverified against the paper**, is that
all major ISD improvements are built on nearest-neighbour search explicitly or implicitly,
which lets them give practical variants of every relevant ISD algorithm with concrete
memory-bounded complexity estimates. Roffe et al., *Decoding across the quantum
low-density parity-check code landscape*, Physical Review Research, with the `bposd` /
`ldpc` software at `github.com/quantumgizmos/bp_osd` — **abstract/metadata only**, from
the repository README and search results.

*Kernel touched.* `css_distance_random` in the core binary, and the upper-bound pass in
`certdist`.

*Expected win — and this is the largest single lever in the report.* Our own measurements
make the case. `756-distance` §7 item 4: plain Prange over **two million trials found
nothing at weight 34**, while an ordinary BP-OSD pass reached **44 in 3,262 trials**. The
core has since gained bounded OSD of order 1 or 2 with a default window of 96
(`certified-distance-prototype` §2.2). Now put that against the radius cost curve:
candidates grow by **8.5–8.6× per two units of radius**, a radius-28 exhaustion costs about
**334,000 core-seconds**, and the published upper bound is 34 with `d ∈ {28,30,32,34}`. A
witness at weight 28 would close the code with a radius-26 exhaustion instead of radius-28
— by that growth factor, roughly **39,000 core-seconds instead of 334,000**, about 27
minutes on 24 cores instead of 4–6 hours. **A better witness finder is worth more than any
speedup to the exhaustion itself, because it removes whole radius levels rather than
shaving a constant factor off one.**

*Implementation cost.* Medium. A Stern/Dumer collision step is a well-understood addition
to the existing information-set machinery: split the information set, build a hash table of
partial syndromes for one half, probe with the other. The campaign's own request
(`certified-distance-prototype` §7 item 8) is for **breadth over logical classes** rather
than more OSD depth, and that is cheaper still — decode toward randomly chosen nonzero
logical classes instead of always the same one.

*Hypothesis it needs, that we might violate.* **ISD complexity estimates are for random
codes.** Our targets are structured, highly degenerate quantum LDPC codes — bivariate
bicycle and lifted-product constructions with large automorphism groups. Two consequences.
(i) The estimator's numbers do not transfer; they would tell us what a random `[772, 386]`
code costs, which is not what we have. (ii) More importantly, the sparsity and degeneracy
that make BP-OSD work are invisible to ISD, and the measured evidence in our own campaign
is that **BP-OSD beat Prange by three orders of magnitude in trials**. So the right import
is not "replace OSD with BJMM"; it is "add a collision step and class breadth to the
existing OSD pass, and keep BP in front of it". A report that recommended the
asymptotically best ISD variant here would be recommending the one whose hypotheses our
codes most clearly violate.

#### 2.4.4 Exact linear algebra over small fields: blocking, bit-slicing, Four Russians

*What it is.* Two ideas. **Method of the Four Russians** (M4RM for multiplication, and its
elimination analogue) precomputes a table of all `2^b` combinations of a block of `b` rows
so that `b` rows are eliminated per pass instead of one. **Bit-slicing** represents a
matrix over `F_{2^e}` as `e` matrices over `F_2`, so addition is XOR on machine words and
multiplication reduces to a few `F_2` multiplications; M4RIE's "Newton–John tables" are the
Four-Russians caching applied to that representation. Above a size threshold both give way
to Strassen–Winograd and to PLE decomposition.

*Sources and read depth.* Albrecht, *The M4RIE library for dense linear algebra over small
fields with even characteristic*, arXiv:1111.6900. **Read depth: partial** — §1
introduction with its benchmark table, §3.2 on the sliced representation, §4 on
Newton–John tables and Gaussian elimination, §6 on echelon forms. Albrecht, Bard and
Pernet, *Efficient Dense Gaussian Elimination over the Finite Field with Two Elements*,
arXiv:1111.6549 — **partial** (abstract and §1). Albrecht, Bard and Hart, *Algorithm 898:
Efficient multiplication of dense matrices over GF(2)*, ACM Transactions on Mathematical
Software 37(1), 2010 — **abstract/metadata only**.

The M4RIE introduction gives a clean, quotable benchmark, all on a 2.66 GHz Intel i7, for
the reduced row echelon form of a random `4000 × 4000` matrix over `F_4`: **GAP 4.4.12
5 s (not reduced), NTL 5.4.2 876.6 s (not reduced), Sage 2805.8 s, Magma 0.64 s, M4RIE
0.4 s**, with M4RI doing the same size over `F_2` in **0.054 s** and LinBox/FFPACK doing it
over `F_3` in **4.55 s**. Attributed to Albrecht; unverified by me beyond reading his
table.

*Kernel touched.* `matrix.rs` (`canonicalize_rows_in_place` and the elimination it drives),
`field.rs` (`SmallField`), `span.rs`, and every private driver that eliminates over
`GF(p^h)`.

*Expected win.* Split it in two, because the two halves have very different prices for us.

- **On the core's own matrices: small.** The compact backend is bounded by
  `MAX_COORDINATES = 256`, `MAX_CHECKS = 128` and `MAX_LOGICALS = 64`; the wide backend's
  doc comment states "up to 320 coordinates and rank 192", and the binary refuses
  instances above 384 coordinates or rank 192 without `--features large-css`. The largest
  campaign instances are 756 and 1,428 coordinates on the large backends.
  The Four Russians pays above roughly `1000 × 1000` and its table setup is
  pure overhead below that. Elimination is also not on the hot path: the `756-distance`
  campaign records recompiling a filter in **1.5 s** against a search of hours.
- **On the private drivers over `GF(p^h)`: real.** `SmallField` does one scalar table
  lookup per element operation and `Matrix` eliminates element-at-a-time. The
  characteristic-two cells the deep-hole census cares about — `q = 8, 16, 32, 64` — are
  exactly M4RIE's target, and the census is a genuine multi-hundred-second workload.
  Bit-slicing an `F_{2^e}` matrix into `e` bit-matrices turns per-element table lookups
  into word-parallel XORs, a factor on the order of the machine word width for addition.

*Implementation cost.* Low for a packed `F_2` representation (we already have
`PackedSupport` and the bitset module). Medium for bit-sliced `F_{2^e}`. High for
PLE/Strassen–Winograd, which we do not need at our sizes.

*Hypothesis it needs, that we might violate.* **Size.** Every figure above is at
`n = 1000` to `n = 10000`; ours are at `n = 100` to `n = 1400`, and the asymptotically
better algorithm loses at small `n` — which is why M4RIE itself switches representation
when the working submatrix fits in L2. Second: bit-slicing is specific to even
characteristic. Half our interesting cells are odd (`q = 9, 25, 27`), where the right
technique is the Bradshaw–Boothby reduction to `F_p` matrices that M4RIE credits, and I
have not read that source. Third, and practical: `SmallField`'s tables for `q = 251` are
about 189 KB, already L2-resident, so the win over table lookup is bounded by memory-level
parallelism rather than by table size.

#### 2.4.5 Sparse exact linear algebra: Wiedemann and block Wiedemann

*What it is.* For a sparse matrix, avoid fill-in entirely: compute the minimal polynomial
of the Krylov sequence `{x^T A^i y}` by Berlekamp–Massey, and read the kernel off it.
Coppersmith's block version replaces the vectors by blocks of `s` vectors, so `s`
matrix-vector products happen for the cost of one (`s = 32` or `64` for `F_2`, one machine
word) and the Berlekamp–Massey step becomes a matrix-polynomial computation.

*Source and read depth.* Coppersmith, *Solving homogeneous linear equations over GF(2) via
block Wiedemann algorithm*, Mathematics of Computation, 1994 — **abstract/metadata only**,
from the Semantic Scholar listing. CADO-NFS uses it as its linear-algebra step with the
sub-phases `prep → krylov → lingen → mksol → gather` — **metadata only**, from the
CADO-NFS documentation and a Wikipedia summary; treated as a secondary characterization
and unverified against CADO-NFS's own source.

*Kernel touched.* None today. `matrix.rs` is dense by construction.

*Expected win.* Nothing that has been asked for. Every matrix in the campaigns is dense
and small.

*Hypothesis it needs, that we might violate.* Block Wiedemann's advantage is space, not
time: it wins when fill-in makes Gaussian elimination impossible, at matrix dimensions in
the millions. Our largest is 1,428 columns. **Do not import**; recorded in §4 so it is not
re-proposed on the strength of the name.

#### 2.4.6 Matching, flow, and certificates

*What it is.* Hopcroft–Karp finds a maximal set of vertex-disjoint shortest augmenting
paths per phase, giving `O(E√V)` against Kuhn's `O(VE)`. Capacitated bipartite assignment
is a max-flow problem, solved by Dinic or push–relabel with capacities on the arcs rather
than by expanding each unit of capacity into its own vertex. The infeasibility certificate
in the capacitated case is the min-cut, which specializes to Hall's condition in the unit
case.

*Sources and read depth.* Hopcroft–Karp and Kuhn are cited at **review only** depth — from
the cp-algorithms and Brilliant expositions and the Cornell CS6820 handout listing. Those
expositions state the `O(E√V)` versus `O(nm)` complexities, and one of them notes that in
practice Hopcroft–Karp "is often outperformed by breadth-first and depth-first approaches
to finding augmenting paths". **That practical claim is a secondary characterization from
a teaching resource, not a measured result from a paper, and should be treated as weak
evidence.** No primary experimental comparison was read for this report.

*Kernels touched.* `ergodis-private/src/hall_core.rs` and core `hall.rs`.

*Expected win — and it is smaller than the asymptotics suggest.* Two regimes, and neither
favours Hopcroft–Karp.

- **Inside a search.** `plane12` wave 2B calls `hall_core` at every node of a search
  running at roughly `10^8` nodes per minute per thread. The graphs are tiny — `C(k,2)`
  pairs against `(v−1)/2` difference classes, or `(m−1)/2` against `(m−1)/2`. At that size
  the `√V` factor is a small constant and the allocate-once, zero-branch structure of the
  current code is worth more than the asymptotic improvement.
- **At product scale.** The `certiis` benchmark on 8,000 tasks × 1,107 resources with
  2.58 M eligible pairs spends **20 ms in the matching** out of **500 ms wall and 191 ms in
  `solve`**; the cost is parsing and index construction. Making the 20 ms into 10 ms is
  not a product improvement.

*What is worth importing here is the capacitated version, not the faster matching.* The
`certiis` prototype's first request against `hall_core` is `solve_capacitated(...)` that
scales capacities inside the augmenting search instead of forcing the caller to expand to
unit copies. Measured consequence of not having it: on 8,000 shifts × 300 nurses at
capacity 28, 892 thousand eligible pairs become roughly **25 million unit incidences**, and
the tool refuses outright past **40 million**. Capacity scaling removes the
`Σd × Σc` blow-up, the ceiling, and the hand-written projection argument.

*Implementation cost.* Medium. `pair_right` becomes a count plus a partner list; the
augmenting search gains a residual-capacity test. The certificate changes shape.

*Hypothesis it needs, that we might violate.* **The certificate is no longer Hall's
condition.** In the capacitated case the obstruction is a min-cut, or equivalently a
deficiency version of Hall counted with capacities; it is still exact and still
human-readable, but every downstream verifier that checks `|N(Z)| < |Z|` literally would
have to change. `certiis` currently justifies the projection by hand precisely to keep the
uncapacitated certificate, so this import trades one form of hand-written justification for
another and the trade only pays if the ceiling is actually binding. It is binding for the
product path and not binding for any current mathematical campaign — which is why this
ranks in the middle of the list rather than the top.

*The other `hall_core` requests, all cheap.* Per-root deficiency (or exposing the
alternating forest) so independent bottlenecks come out separated rather than being
recovered by a connected-component decomposition afterwards; a first-violation fast path
for screening; a fallible constructor, since `HallWorkspace::new` asserts on capacity
overflow while `solve` correctly returns `HallError`; a documented contract for
`matching()` after a deficient solve; and the deficiency magnitude `|S| − |N(S)|` in the
outcome. None is an algorithmic import; all of them are half a day each and they came from
a prototype that actually used the API.

#### 2.4.7 Stronger lower bounds inside the distance search

*What it is.* The current lower bound at a node is: the syndrome weight divided by the
maximum column check weight (a degree bound), strengthened near the cutoff by a greedy
packing of disjoint check neighbourhoods. Both are relaxations of the same question —
what is the minimum number of columns whose syndromes XOR to the current residual — which
is a set-cover-like problem. The standard next rungs are the linear-programming relaxation
of that cover, and a maximum (rather than greedy) independent set of pairwise
non-adjacent checks.

*Source and read depth.* No external source. This is an observation about our own code
and is **entirely mine**, flagged as such.

*Kernel touched.* `completion_lower_bound_exceeds` and `syndrome_packing_exceeds` in
`css_distance.rs`.

*Expected win, and the cheap version first.* `syndrome_packing_exceeds` walks the syndrome
words in index order and greedily takes the lowest set bit each time. Greedy packing is
order-sensitive: starting from the check with the *fewest* conflicts typically yields a
larger disjoint family and hence a larger lower bound. Trying two or three orders and
taking the maximum is nearly free — the routine already short-circuits as soon as the
bound exceeds the budget — and it strengthens the bound exactly in the near-cutoff band
where the search spends its deepest time. **This is the cheapest item in the whole
report** and should be measured before anything else on this list.

The expensive version, an LP bound, is a different matter: an LP solve costs microseconds
against an 8 ns per-candidate budget, so it can only ever run in the near-cutoff band, and
whether that band is a large enough fraction of nodes to pay is unmeasured.

*Implementation cost.* Very low for multi-order greedy. High for LP, plus a dependency.

*Hypothesis it needs, that we might violate.* The multi-order greedy version needs nothing
— any disjoint family gives a valid bound, so trying more of them is sound by
construction. The LP version needs the band to be a large fraction of the work, which the
`SYNDROME_PACKING_ADMISSION_MARGIN = 6` constant suggests it is not, since the packing
bound itself was deliberately gated behind that margin. My read: do the free one, measure,
and do not build the LP.

#### 2.4.8 Character-sum evaluation

`character_sum.rs` evaluates quadratic character sums over odd prime fields with a
bit-per-element residue table and an allocation-free census loop, at `q ≤ 251`. The
alternatives in the literature — additive-FFT evaluation of character sums, or point
counting on the associated curve — are for large `q` where an `O(q)` loop is infeasible.
At `q ≤ 251` an `O(q)` loop over a 32-byte bitmap is already optimal in the only sense
that matters. **Nothing to import**; recorded in §4.

### 2.5 Two things that are not techniques but are the biggest levers

#### 2.5.1 The missing API surface

Four campaign requests recur and none is an algorithm: a `null_space_field` returning a
kernel basis (today `canonical_row_basis_field` gives the row space only, so every driver
re-runs elimination locally); a runtime-selectable field, since `const P: u8` on a sealed
trait forces a `match` over fifty prime literals and blocks an external crate from
supplying its own; a generic `ProjectiveSpace::new(d, q)` with `encode`/`decode`, since
`ergodis::projective` is specialized to `ternary(order)`; and an orbit closure that BFSs
an indexed point set under a list of `GL(d+1,q)` generators, which `prs-deepholes` §6 item
5 records as "the dominant cost here" and which `orbit`/`orbit_compile` do not expose.
Each has been written locally at least once. Their cost is a day each and their return is
every future driver.

#### 2.5.2 The certificate is the product, and the unsat core is the wrong object

The `certiis` benchmark is the sharpest measured result in the recent campaign and it
argues against a whole class of imports. Against CP-SAT and HiGHS on 78 planted
assignment instances: median time to explanation **0.40 ms for `certiis` against 61.2 ms
for CP-SAT and 57.8 ms for HiGHS**; CP-SAT returned no explanation at all on **20 of 60**
infeasible instances, hitting a 60-second limit on the cascade instances. On explanation
quality, the residual test — does removing the named tasks restore feasibility — is the
one that decides: removing the CP-SAT core's tasks **left 10 of 40 instances still
infeasible**, every multi-shortage one, while removing the `certiis` certificates'
tasks restored feasibility on **all 40**. A solver's unsatisfiable core proves that *some*
conflict exists; a planner needs *every* independent shortage, separated.

The transferable lesson for this survey is a negative one, and it is the reason several
attractive imports are declined below. Importing a general solver buys generality and
loses the certificate. Our kernels are valuable because they produce exact, minimal,
independently checkable witnesses — a Hall-deficient set, an exhausted radius, an orbit
transversal — and a technique that returns "unsatisfiable" without one is a downgrade
however fast it is.

---

## Part 3 — The ranked import list

Ranked by expected value **to us**, given the scale numbers in §1.6. The rank column is
the recommendation; the "gate" column names the single measurement or proof that must come
first, because most of these are cheap to try and expensive to get wrong.

| # | Technique | Kernel | Expected win | Cost | Gate before building |
|---|---|---|---|---|---|
| 1 | Minimum-remaining-values branch selection (2.1.1) | `css_distance` | Reduces the branching factor at every one of ~28 levels; compounds against the measured 8.5–8.6× growth per two radius units | Low | Instrument the option-count distribution by depth; prove the forbidden-set canonicity argument is order-independent |
| 2 | Better upper bounds: collision step + logical-class breadth (2.4.3) | `css_distance_random`, `certdist` | A witness at 28 instead of 34 closes `[[756,16,d]]` with a radius-26 run: ~39,000 core-seconds instead of ~334,000 | Medium | Confirm BP-OSD stays in front; measure class breadth against OSD depth on the 756 instance |
| 3 | Seed and share the incumbent bound across shards (2.1.2) | `css_distance` sharding | Recovers a **measured 5×** enumeration loss on `R1Elite02`'s X side; also helps unsharded runs | Low (static) / Medium (dynamic) | Require the seed to carry its support and pass `logical_is_nonzero` |
| 4 | Multi-order greedy packing bound (2.4.7) | `css_distance` | Strictly stronger lower bound in the near-cutoff band, at near-zero cost | Very low | None — sound by construction. Measure the bound improvement first |
| 5 | Brouwer–Zimmermann for small codes (2.4.1) | `linear_code.rs` | Replaces a `2^k` Gray walk with `Σ_w C(k,w)`; moves the sector- and invariant-subspace scans from `k ≲ 30` to the high tens | Medium-high | **Must not go into `css_distance`** — see the `N/K ≈ 2` argument in 2.4.1 |
| 6 | Orbit-verified anchors (2.4.2, anchor half) | `css_distance` input, `orbit`/`group_action` | Converts the largest lever in the system — **42×–60×** — from trusted input into a checked fact | Low-medium | None; the machinery exists |
| 7 | Canonical augmentation for the design searches (2.4.2) | `c1018_plane12*` drivers | Addresses the measured failure: 56→139 class inflation under the hyperoval assumption, `2.04·10^9` depth-3 survivors | Medium | Measure whether a full residual-group quotient shrinks depth-3 survivors at `n = 6` and `n = 10` |
| 8 | Capacity-scaled matching (2.4.6) | `hall_core` | Removes the `Σd × Σc` blow-up and the measured 40-million-incidence ceiling | Medium | Decide whether the min-cut certificate is acceptable downstream |
| 9 | Bit-sliced `GF(2^e)` linear algebra (2.4.4) | `field.rs`, `matrix.rs`, census drivers | Word-parallel XOR instead of per-element table lookup on the `q = 8,16,32,64` census cells | Medium | Measure elimination's share of census wall time — it may be under 5% |
| 10 | The missing API surface (2.5.1) | `matrix`, `field`, `projective`, `orbit` | No speedup; removes re-implementation from every future driver | Low each | None |
| 11 | Small `hall_core` API requests (2.4.6, last paragraph) | `hall_core` | Per-root deficiency, first-violation fast path, fallible constructor, deficit magnitude | Low each | None |
| 12 | Look-ahead cubing for shard balance (2.1.3) | `css_distance` sharding | Bounded above by the measured 1.6× shard spread | Medium | Sequence after item 3, or it is measured against the wrong baseline |
| 13 | Bounded transposition cache on `(syndrome, budget)` (2.3.1) | `css_distance` | Unpriced; plausibly negative at full generality | Medium | Histogram syndrome multiplicity at fixed depth. **Do not build before this** |
| 14 | 5-completion meet-in-the-middle filter (2.3.2) | `css_distance` | One more closed level at the leaf; roughly 3× at the frontier | Medium (memory) | Only viable at `n ≈ 100–200`; at `n = 756` the key count is `1.7·10^12` |
| 15 | Finite-field SMT for the tight-design obstruction (2.2) | new | Unpriced; would yield a named algebraic obstruction rather than a bare "no" | High | One bounded `n = 6` experiment; never a dependency |

**The shape of the ranking.** The top four are all cheap and all touch the same kernel, and
three of the four are worth more than anything in the literature because they close
measured losses rather than chase asymptotics. Items 1, 3 and 4 together plausibly change
the cost of a radius level; item 2 removes radius levels outright, which is why it outranks
everything except the one item that is nearly free. The celebrated results —
Brouwer–Zimmermann, cube-and-conquer, decision diagrams, block Wiedemann — sit at rank 5 or
below or in §4, because our problem shapes either already contain them or cannot use them.

---

## Part 4 — Do not import, and why

Written so the next person does not re-propose these. Each entry names the reason our
problem shape rejects it.

1. **CDCL clause learning, restarts, phase saving, VSIDS activity scores, vivification,
   bounded variable elimination, congruence closure.** `sat.rs` is a structured-CNF
   recognizer with no search, so there is nothing to import *into*; building a CDCL solver
   to host these is out of proportion to any problem we have. And the distance search
   cannot use them as they stand: it is an exhaustive canonical enumeration with a
   forbidden-set discipline, so there is no repeated subproblem for a learned clause to
   short-circuit, and a restart would break the completeness accounting an exhaustion
   depends on. The one CDCL idea that does transfer — fail-first branching — is item 1 of
   the ranking, and it transfers because it predates CDCL.

2. **SAT or MaxSAT encoding of the minimum-distance problem.** The AAAI-26 paper
   (**partial**) is the serious attempt: the encoding constrains all `2^k − 1` nonzero
   linear combinations, which for `k = 10` is already a 1,023-input cardinality constraint
   and a 7.8 MB CNF, and the authors had to restrict to weight blocks `R = {4,5}` to make
   Kissat progress. Their instances are `(35,10,12)` and `(40,8,16)`, solved with 128 cores
   for a day. Our flagship is `n = 756`, `k = 16`. The encoding is exponential in exactly
   the parameter that is large for us, and our syndrome-driven search is polynomial in it.
   The paper is genuinely useful for *small* code construction and error-coefficient
   optimization; it is not a route to our distances.

3. **DRAT, LRAT or VeriPB proof logging of an exhaustion.** The certificate ambition is
   right and the mechanism is wrong at our scale: a resolution-style proof of a radius-28
   exhaustion covering `5·10^11` candidates would be an artifact no one can store or check.
   The correct cheap substitute is already identified — verified automorphism generators
   plus an orbit-transversal check (ranking item 6) — which makes the *load-bearing*
   unverifiable step checkable without proof-logging the enumeration.

4. **Zero-suppressed decision diagrams and frontier-based search for our enumerations.**
   Frontier-based search needs a narrow path decomposition. The order-12 plane completion
   is a tight `1452 × 1452` exact cover with no small separator; quantum LDPC Tanner graphs
   are expander-like by construction. The frontier would be the instance. `zdd.rs` remains
   correct and useful for what `applications.rs` does with it; it is not a route into the
   campaign kernels.

5. **Treewidth or tree-decomposition dynamic programming.** Same reason, stated separately
   because it gets proposed independently: every structure we search is deliberately built
   without small separators.

6. **Block Wiedemann and other sparse-iterative kernel methods.** These win on space at
   dimensions in the millions, where fill-in makes elimination impossible. Our largest
   matrix is 1,428 columns and dense. Nothing to gain.

7. **Hopcroft–Karp in place of Kuhn in `hall_core`.** The asymptotic improvement is real
   and irrelevant here. In-search graphs are tiny and called at roughly `10^8` nodes per
   minute per thread, where the allocate-once constant factor dominates the `√V`; at
   product scale the matching is a measured **20 ms of a 500 ms** run and the cost is
   parsing. Teaching-resource expositions also report that Hopcroft–Karp is often
   outperformed in practice by plain augmenting-path search — **weak evidence, secondary
   source, not verified against an experimental paper** — which at best removes the reason
   to try. If matching ever becomes the bottleneck, the capacitated version (ranking item
   8) is the change to make, not this one.

8. **Anything replacing `character_sum.rs`.** At `q ≤ 251` the `O(q)` loop over a
   32-byte bitmap is the right algorithm; FFT and point-counting methods exist for large
   `q` and buy nothing here.

9. **A general-purpose CP or MIP solver behind any of our certificate-producing kernels.**
   Measured, in this repository: on 78 planted assignment instances, `certiis` produced an
   explanation in **0.40 ms median** against **61.2 ms** for CP-SAT, CP-SAT produced no
   explanation at all on **20 of 60** infeasible instances, and removing the tasks named by
   its core left **10 of 40** instances still infeasible while removing ours restored
   feasibility on **all 40**. An unsatisfiable core proves some conflict exists; our
   certificates enumerate every independent one. That is the property to protect.

10. **Full SAT Modulo Symmetries.** The technique is the right idea for the design searches
    and the survey's own summary is compelling — complete symmetry breaking without a
    prohibitively large encoding, at sizes previously out of reach. But it requires a CDCL
    solver with a user-propagator interface (IPASIR-UP), which we do not have and should not
    build for one problem. Import the idea as canonical augmentation against our own search
    (ranking item 7); revisit the SAT version only if the design line becomes a lane of its
    own.

---

## Part 5 — Foreign-lane issues to raise

1. **`ergodis-private`'s library does not compile.** An untracked
   `ergodis-private/src/g133_sparse_defect.rs` from a concurrent session is the cause,
   per the task brief. It did not block this report, which is read-only, but every
   `ergodis-private` binary is unbuildable while it stands — the same crate-wide blast
   radius that `notes/2026-08-31-infeasibility-certificate-prototype.md` and
   `notes/2026-08-30-c1018-hunt-plane12.md` both raised for different files on previous
   days. This is the third recorded instance; the pattern, not the file, is what is worth
   raising.

2. **`notes/2026-08-30-c1018-hunt-prs-deepholes.md` §6 item 1 is now stale.** It records
   "No general `GF(p^h)`" as the single highest-value addition. `field.rs` now has
   `SmallField` with runtime-constructed tables for any `GF(p^h)` of order at most 256,
   built from the lexicographically first monic irreducible. Items 2–5 of that section
   still stand. Worth a one-line correction in that report so the next reader does not
   re-implement what landed.

3. **The census ceiling figure in circulation is ambiguous.** `prs-deepholes` §5.3e states
   "about `2·10^9` projective points" as the machine ceiling; that is the superseded
   `c1018_prs_deephole.rs` driver with `u32` indices and one byte per point.
   `c1018_prs_census.rs` uses `u64` indices and a one-bit visited bitmap and puts
   `|PG(8,19)| = 1.79·10^10` at 2.2 GB, which is where the brief's `10^11` figure comes
   from. Both numbers are correct about different drivers and neither report says so.

---

## Part 6 — Evidence and scope

**What was read, and how.**

- The Ergodis source, current working tree, 2026-08-31: the module inventory in §1.1, the
  algorithm descriptions in §1.2 to §1.4, and every claim about what a kernel does or does
  not contain. Read directly, not from prior reports.
- Campaign reports, in full for the sections named in §1.5.
- External sources, each with its read depth stated inline in Part 2. Two were read as
  full or substantial partial text (the quantum Brouwer–Zimmermann paper and the M4RIE
  paper); four more at partial depth (CaDiCaL 2.0, the SAT Competition 2024 solver
  description, Satisfiability Modulo Finite Fields, the AAAI code-construction paper, the
  SAT Modulo Symmetries survey); the rest at abstract, metadata or review depth, marked as
  such.

**What was cached.** `arXiv:2408.10743` (Hernando, Quintana-Ortí, Grassl) was added to the
shared cache at `/tmp/persistent/tavis/lit-search/`, sha256
`6804acd5159314cb3ee60f44447897ea14fae20c3c6122852cab60fb7f6b15e0`, 14 pages, 7,957 words
extracted. `10.1609/aaai.v40i17.38442` and `10.4230/LIPIcs.CP.2023.3` were already present.
The remaining PDFs read for this report (CaDiCaL 2.0, the SAT Competition 2024 booklet, the
smart-cubing study, the SMS survey, the two M4RI/M4RIE papers, the SMFF ePrint) were
fetched to a session scratchpad and not added, since they were read at partial depth for
technique inventory rather than cited for a load-bearing figure; every figure quoted from
them names the file and the section it came from.

**No code was written and no benchmark was run.** Every performance number in this report
is either (a) measured by a prior campaign and cited by file and section, (b) attributed to
an external source with its read depth, or (c) marked *(mine)* as an inference. Several
recommendations name a gate measurement precisely because the number that would decide them
does not exist yet.

**Scope limit, stated plainly.** This is a survey of what could be imported, not a
validation that any of it will pay. Four of the fifteen ranked items carry a named gate
measurement that has never been taken, and two of those gates — the option-count
distribution by depth, and the syndrome multiplicity histogram — could invert their item's
rank. The ranking is a reading of the evidence available today, not a schedule.

