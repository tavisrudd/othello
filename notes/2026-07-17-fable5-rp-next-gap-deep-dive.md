# Fable 5 gap review deep dive: routes, probes, and second-order wins

**Lane**: `rp-next`

**Date:** 2026-07-17
**Status:** ADVISORY REVIEW, level two. Deepens each item of
[the independent gap review](2026-07-17-fable5-rp-next-independent-gap-review.md); allocates no
task, proves nothing, changes no gate. Same provenance caveat: produced without reading any C239
document or the two earlier Fable review notes. Claims labeled REASONED are hand derivations that
must be replayed before promotion.

## 1. Peeling-optimality classification

### Sharpened statement

Define `P_r` = the class of matroids where sequential radius-`r` Horn closure equals matroid
closure on every seed (`L_r = cl`). C236 proves the cubic--axis family lies in `P_3` and the
harmonic family lies outside `P_4`. The classification question: characterize `P_r`, at least for
GF(q)-representable matroids.

### One level down

- Membership is equivalent to "every `Sigma_r`-closed set is a flat" (C236's own proof shape), so
  `P_r` is a property of the closure-system comparison, checkable per matroid in output-polynomial
  time given the small-circuit list.
- The decisive structural question is which operations preserve membership. C230's witnesses warn
  that closure computations do not commute with deletion/contraction, but that does not settle
  whether the *class* is minor-closed; the two questions are different. A computational scout over
  all small binary matroids at radii two and three (the C229/C230 enumeration scripts already do
  the hard part) decides minor-closure, duality-closure, and 2-sum-closure empirically before any
  proof is attempted.
- **If `P_r` is minor-closed, the Geelen--Gerards--Whittle structure/WQO theory for
  GF(q)-representable matroids implies a finite excluded-minor characterization for each `(r,q)`.**
  That is the A-level shape: a finite certificate for "bounded-locality peeling achieves MAP on
  every erasure pattern," decidable by minor-checking. Even a negative (not minor-closed, with an
  explicit witness) is a publishable structural fact that redirects the search to the right
  quasi-order (candidates: series-parallel extensions, 2-sums via C231).
- REASONED identification worth exploiting: minimum seed sets for full sequential recovery are
  exactly **weak saturation numbers** (Bollobas's `wsat`) of the small-circuit hypergraph, in
  matroid form. The truncated Horn closure *is* graph/hypergraph bootstrap-percolation closure.
  Kalai's exterior-algebra lower-bound method for `wsat` is a rank-function argument that should
  translate to matroid language nearly verbatim.

### First probe

One script: exhaust binary matroids through eight or nine elements at `r` in {2,3}; compute `P_r`
membership; test closure under minors, duality, and 2-sums; extract candidate excluded minors.

### Second-order wins if landed

1. Paper B acquires a quotable flagship theorem; the C236 dichotomy gets a conceptual explanation
   rather than two data points.
2. A **peeling-optimality linter**: certify a deployed code's iterative-erasure optimality by
   checking finitely many minors — a new capability for the C238 capsule/digital-twin products.
3. A two-way bridge to the weak-saturation and bootstrap-percolation communities: matroid rank
   methods for `wsat` lower bounds, and their algebraic-shifting tools for minimum-seed problems.
4. Composes with item 2: classification plus FPT evaluation gives a complete
   structure-versus-computation picture of sequential repair.

### Risk / kill

The class may be wild (neither minor- nor sum-closed). The scout is cheap and decides quickly;
even then the restricted question "which port families with transitive symmetry lie in `P_r`" is
a viable fallback with the flagships as anchors.

## 2. Branchwidth FPT theorem

### Sharpened statement

Extend the C233 finite boundary-control algebra from 2-sum trees to branch decompositions of
width `w` for GF(q)-represented matroids:

> Terminal closure, stopping cores, arrival times, and the C230 seed/core/depth profile are
> computable in `f(r,w,q) * poly(n)` given a width-`w` branch decomposition.

### One level down

- The technical route the corpus never states: for a represented matroid, a `w`-separation's
  interface is a `w`-dimensional subspace `W` of the ambient space. The C231 scalar message
  ("cheapest certificate for the one virtual coordinate") generalizes to a **cost profile on the
  interface space**: for each nonzero vector (projectively, each point of `PG(w-1,q)`), the
  cheapest current budget to certify it from the side's live columns, valued in `Q_r`. The
  message alphabet is finite for fixed `(r,w,q)`; monotone fixed-point composition then follows
  the C233 proof pattern, and the DP runs over the decomposition tree exactly as in Hlineny's
  bounded-branchwidth Tutte-polynomial algorithm (parse trees for GF(q)-representable matroids;
  decompositions computable FPT by Hlineny--Oum). C232's obstruction is not in the way: it blocks
  finite *timing* alphabets, and C234's expression DAGs carry timing over the same tree.
- The crude state bound is enormous, but C233's measured data (few realized structural controls
  against a huge crude bound) suggests realizable controls are sparse; an implementation can
  enumerate realized controls lazily, so the theorem may be practical, not only FPT.
- Complexity counterpart to pair with it: hardness of terminal closure / minimum permanent
  failure without bounded width (the Provan--Ball and Vardy baselines from the brainstorm response
  give the template), yielding a complete FPT-versus-hard map.

### First probe

Work out the width-2 (3-sum-adjacent) case by hand for represented matroids: define the
interface-space cost profile, prove the one-step decomposition against the standard 3-sum circuit
description, and replay on glued binary examples with the C231 verifier pattern.

### Second-order wins if landed

1. Retroactively organizes C231--C234 as the `w=1` stratum of one theorem; Paper B's "beyond
   2-sums" gate is met with room to spare.
2. Practical backbone for the C238 ETA/digital-twin products on hierarchical placements, which
   are naturally low-width.
3. **Spatially coupled codes are path-like decompositions.** The boundary fixed-point language
   may re-derive density-evolution/threshold-saturation phenomena as statements about the
   boundary algebra along a path — a possible unification with the deferred GLDPC option that
   neither lane has touched.
4. Answers C234's open rationality question in the bounded-width regime: the delay algebra
   becomes the weight structure of a weighted tree automaton, connecting to weighted-automata
   theory on solid ground.

### Risk / kill

Cross-circuits through a `w`-separation may need more than pointwise vector certificates
(simultaneous certification of a subspace with shared helpers is a max-convolution over the
subspace lattice, not a product). If the naive profile fails, the fallback state is a cost
function on the subspace lattice of `W` — still finite, larger. Kill only if no finite
boundary summary exists at width two, which C233's success makes unlikely.

## 3. Log-concavity of the pointed repair profile

### Sharpened statement

For every matroid `M` and nonloop, noncoloop `x` with helper set of size `n`: the sequence
`a_k(M,x)` (number of `k`-helper-sets whose closure contains `x`) is log-concave, possibly
ultra-log-concave. Dual form via C227's relation `a_k(M,x) + a_(n-k)(M*,x) = binom(n,k)`; both
the primal and dual statements should be tested, since ULC does not obviously transfer across
that complement.

### One level down

- The promising proof route the corpus never names: the pair `M/x -> M\x` is a matroid quotient,
  i.e. a **flag matroid**, and flag-matroid bases form M-convex sets, placing them inside the
  Brande n--Huh Lorentzian framework. C227's identity (6) — `S_x(u)` as a `y`-derivative
  difference of the two minors' rank polynomials at `y=1` — is exactly the kind of expression
  Lorentzian calculus (derivatives and nonnegative combinations preserving the class, in the
  right normalizations) is built to handle. The failure modes are also informative: rank
  polynomials at general points are not Lorentzian, so the question sits at a genuine boundary.
- Free data: every committed certificate (uniform, cubic, both harmonic targets, the C233
  component catalogs) already contains or quickly yields full `a_k` profiles. A same-day scan
  over random small matroids either supports the conjecture or finds a counterexample; either
  outcome is valuable.

### First probe

One afternoon: ULC check on all committed profiles plus random binary matroids through ten
elements; simultaneously a focused literature check on Lorentzian results for matroid quotients
and flag matroids.

### Second-order wins if landed

1. Places complete repair ports inside the post-Huh matroid mainstream; the pointed-Tutte paper
   gains a theorem (or a well-evidenced conjecture) that pure matroid theorists will cite.
2. Operational corollaries: log-concavity forces reliability-curve regularity, and Newton
   inequalities turn partially computed profiles (the low-`k` blocker layers already classified
   by C219/C220/R1) into **certified two-sided bounds on the whole reliability curve** — an
   immediately implementable estimator for the digital twin, with proofs.
3. If false: the counterexample delimits Lorentzian territory (rank-jump statistics as a natural
   non-Lorentzian family), which is itself publishable.

### Risk / kill

The conjecture may fail at small size — the probe is designed to find that in hours, before any
proof investment. No kill needed beyond the data check.

## 4. Cascade thresholds for random seeds

### Sharpened statement and a solvability upgrade

The gap review posed this as an open bootstrap-percolation problem. Deepening it shows both
flagship cascades have **exactly solvable algebraic cores** (REASONED; replay required), which
lowers risk and raises the paper value:

- **Cubic:** C236 gives `L_3 = cl`, so the cascade law equals the span law, and
  `Pr(cl(S)=E)` is exactly computable by Mobius inversion over the flat lattice that C236
  already enumerated (with rank histograms). A closed-form all-`q` cascade theorem is within
  reach with no new combinatorics.
- **Harmonic:** conditional on the nucleus and `V(infinity)`, the zero-sum-triple rule subsystem
  `{a,b} -> -a-b` on finite parameters generates exactly the **F_3-affine flat spanned by the
  seed** (line-closure equals affine closure in `AG(h,3)`). So the core of the harmonic cascade
  is random affine-subspace generation in `F_3^h`, whose law lives on the same subgroup lattice /
  Gaussian-binomial sector as C220/C226. The `e_2`-quadric blocks (blocks avoiding infinity) and
  the nucleus gate sit on top as a bounded enrichment; the nucleus contributes the series factor
  C219 identified, now in dynamic form.

The genuinely open probabilistic frontier is then bootstrap percolation on *general* Steiner
systems (random or quasirandom designs), with the flagships as the algebraically solvable base
cases — a well-posed entry into an active area, entered with tools half-built.

### First probe

Replay the two REASONED identifications against the committed C218/C236 verifiers (the affine
closure claim is a finite check at q=9 and q=27), then write the cubic Mobius formula and check
it against direct simulation at q=3 and q=9.

### Second-order wins if landed

1. Unifies C219/C226/C230/C236 into one stochastic-process story — the probabilistic spine of
   Paper B.
2. Sharpens R10's "reliability encodes the subgroup lattice" into a dynamic statement: the
   sequential-repair threshold is governed by the subgroup lattice.
3. Storage meaning: a theory-backed "cascade margin" metric — when massive correlated failure is
   self-healing via multi-round repair — for the digital-twin product.
4. Opens a new problem family for probabilists (bootstrap on group-action Steiner systems) where
   this program owns the solvable cases.

## 5--6. Restricted export branches

The full proposals, probes, risks, interactions, and ranking notes were moved verbatim to
`2026-07-17-fable5-rp-next-fable-do-NOT-read.md`. Do not follow that pointer in a Fable session.

## 7. LRC-bound benchmark and the port-capacity converse

### Sharpened statement and expected outcome

Run the comparison of the C216+C218 concatenated families against fixed-alphabet LRC frontiers.
The right comparators for unbounded length over fixed `F_q` are the AG-based locality
constructions (Barg--Tamo--Vladut line), not bounded-length Tamo--Barg. REASONED expectation,
stated so the check can refute it: the harmonic family is *not* rate-competitive as a plain
locality-4 LRC (inner rate `5/(q+2)` is low, and curve targets have `(nu,tau)=(1,1)`
availability through the nucleus), so the benchmark's likely product is a quantified gap, not a
frontier claim.

### Why it is still item-7-valuable: the converse question

The gap number is the opening of a new extremal theory the corpus never poses:

> **Port capacity.** Given a pointed port `P` and radius `r`, what is the maximum asymptotic
> rate (and rate/distance region) of fixed-alphabet families realizing `P` at every coordinate
> (or at prescribed density)?

C216 is exactly the achievability half (scaled GV/TVZ regions). The converse half — a
Singleton/Cadambe--Mazumdar-type upper bound *parameterized by the port itself* (its blocker
structure, its `z_x` obstruction, its design richness) rather than by a bare locality number —
does not exist anywhere. Landing even a first nontrivial port-dependent converse creates a
matched achievability/converse pair, which is the classical shape of an A-level
information-theory contribution and the natural flagship of a follow-up paper.

### First probe

The one-afternoon arithmetic against BTV-style frontiers, then formulate the cleanest converse
candidate: an upper bound in terms of the port's minimum blocker size and repair-set overlap
structure (C219's series-bottleneck mechanism suggests where rate must be lost).

### Second-order wins if landed

1. Either outcome of the benchmark strengthens the ports paper: frontier proximity gives a
   headline; a gap plus the converse program reframes the contribution as "the price of
   prescribed local semantics," which is a better story than an uncompetitive construction.
2. Port capacity gives the C238 policy compiler a principled objective: compare port choices by
   their capacity cost, not only their local semantics.

## Smaller items, one level down

- **Dynamic maintenance.** Incremental terminal closure under helper death/revival is monotone
  fixed-point maintenance; deletions are the hard direction (non-monotone), where the C233
  separation helps: structural controls change rarely (finite alphabet, coarse), weights
  recompute additively, so an amortized bound parameterized by control-change frequency is
  plausible and would read as a dynamic-algorithms result. Also the exact theory backbone the
  runtime controller product needs.
- **Scaled C216.** With inner length growing polylogarithmically under a uniform confinement
  bound, gadget families of growing size embed into one asymptotically good family, converting
  the family-level hardness facts (two-terminal reliability, min-weight codeword) into
  hardness-inside-good-codes. Second-order: it makes the proof-carrying planner architecture
  theorem-backed — verification stays easy while optimization is provably hard *in situ* — the
  cleanest possible justification for C238's product thesis.

## Portfolio interactions

| Combination | Compound win                                                                    |
|-------------|---------------------------------------------------------------------------------|
| 1 + 2       | Classification plus FPT evaluation: a complete structure/computation dichotomy   |
| 2 + 4       | Boundary algebra evaluates cascade laws on decomposable topologies               |
| 3 + 7       | Newton-inequality reliability bounds feed the port-capacity converse and twin    |

## Revised ranking after deepening

Deepening moved two items. Item 4 rose (both flagship cascades have exactly solvable cores, so
it is now low-risk exact-theorem work, not open-problem work). Item 7 rose in ceiling (the
port-capacity converse is the largest genuinely new theory question found in this review),
while its benchmark half stays a cheap check. Items 1 and 2 remain the strongest
classification/algorithm bets; 3 is the highest-prestige lottery ticket with an hours-cheap
data probe. The two restricted export bets remain gated on their audits; their details live only
in `2026-07-17-fable5-rp-next-fable-do-NOT-read.md`.

## Explicit nonclaims

Nothing here is proved. The REASONED items (affine-closure identification, cubic Mobius law,
LRC non-competitiveness expectation, boundary-space message construction, flag-matroid route)
are hand derivations requiring replay against committed artifacts before any report, task, or
paper uses them. Promotion requires normal C-ID allocation and deduplication against the two
unread Fable review notes and the C239 audit.
