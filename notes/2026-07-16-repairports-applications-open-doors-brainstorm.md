# Complete repair ports: applications, implications, and opened research doors

**Date:** 2026-07-16
**Lane:** `repairports`
**Status:** BRAINSTORM REPORT. This consolidates implications and research directions discussed
after C215--C220. It allocates no new task, reopens no completed lane item, and makes no novelty or
priority claim for an unproved direction.

## Purpose and confidence convention

The completed repair-ports program developed a finite pointed represented-matroid object: all
bounded dual circuits through a target coordinate, together with their supports, coefficients,
costs, matching and blocker structure, reliability function, and behavior under concatenation.
The purpose of this report is to record what becomes visible only after combining several of those
results.

The labels used below are:

- **proved:** already contained in C215--C220 or follows by an immediate exact calculation;
- **theorem-ready:** a sharply stated bounded consequence whose proof route is visible;
- **medium-confidence:** a concrete adjacent program requiring a new definition, reduction, or
  literature audit;
- **exploratory:** a plausible structural connection that should not yet appear as a claim.

## Completed foundation

The relevant inputs are:

- **C215:** exact weighted functional-dual costs and pointed syndrome tables;
- **C216:** blockwise realization of prescribed finite representable ports inside asymptotically
  good fixed-alphabet code families, subject to the exact confinement criterion;
- **C217:** gauge-invariant circuit-coefficient holonomy, cross-ratio fingerprints, and
  support-identical but monomially inequivalent representations;
- **C218:** the characteristic-three quartic normal-rational-curve nucleus, whose radius-four
  circuits are the harmonic `S(3,4,q+1)` blocks;
- **C219:** exact deletion--contraction reliability, pivotal influences, blocker asymptotics, and
  Steiner Poisson windows;
- **C220:** the restricted-sumset defect classification of minimum and one-above-minimum cubic
  blockers.

The reports are
[`C215`](2026-07-16-c215-functional-cost-api.md),
[`C216`](2026-07-16-c216-prescribed-port-realization.md),
[`C217`](2026-07-16-c217-gauge-invariants.md),
[`C218`](2026-07-16-c218-quartic-nucleus-repair.md),
[`C219`](2026-07-16-c219-repair-reliability.md), and
[`C220`](2026-07-16-c220-cubic-blocker-stability.md).

## Executive synthesis

The strongest combined interpretation is:

> A complete repair port is a finite programmable linear-dependency gadget. C215 evaluates its
> exact costs, C216 compiles it into globally good code families, C217 separates support geometry
> from representation geometry, and C219--C220 calculate its stochastic and extremal semantics.

This changes the likely paper headline. The work is not only about one geometric LRC family or a
larger list of repair sets. It is a theory of which finite local dependency systems can coexist
with global asymptotic goodness, and which operational, algebraic, and probabilistic invariants
survive their realization.

The main editorial danger is breadth. Many ingredients below use classical machinery. The novelty
case must be made at the level of the complete-port framework, exact transfer, and coding
consequences, not by claiming ownership of restricted sums, Steiner systems, Poisson
approximation, EXIT functions, Tutte polynomials, or matroid ports.

## I. Immediate non-obvious implications

### 1. Full cubic reliability is a restricted-sumset transform

**Confidence: proved by direct conditioning.**

At a cubic target, write `G=F_3^h`. The radius-three repair edges are

```text
{C(s), C(t), A(s+t)},  s != t.
```

Let cubic helpers fail independently with probability `p_C` and axis helpers with probability
`p_A`. If `S subset G` is the set of surviving cubic parameters, repair fails exactly when every
axis color in the restricted sumset

```text
R(S)=S restricted-plus S={s+t : s,t in S, s != t}
```

has failed. Summing over `S` gives the exact law

```text
Q_cubic(p_C,p_A)
  = sum_(S subset G)
      p_C^(q-|S|) (1-p_C)^|S| p_A^|R(S)|.                 (1)
```

No factor for axis coordinates outside `R(S)` remains because their states are arbitrary and sum
to one. Under homogeneous failure `p_C=p_A=p`, C220's defect

```text
delta(S)=|R(S)|-(|S|-1)
```

turns (1) into

```text
Q_cubic(p)
  = sum_(S subset G) (1-p)^|S| p^(q-1+delta(S)).          (2)
```

Thus the entire reliability curve, not only its leading blocker exponent, is a weighted enumerator
of restricted-sumset defect. C220 classifies the ground states `delta=0` and first excited states
`delta=1` of this partition function.

This creates a two-way bridge:

- restricted-sumset inverse and enumeration theorems yield exact reliability information;
- reliability coefficients package the distribution of small restricted sumsets.

### 2. Axis reliability factors through a cap-set independence polynomial

**Confidence: proved by the C202 structural decomposition and direct conditioning.**

At the axis-infinity target, the radius-three port is the disjoint union of:

- all pairs among the `q` other axis helpers;
- all distinct zero-sum triples among the `q` finite cubic helpers.

The axis-pair component is blocked exactly when at most one axis helper survives. The cubic
component is blocked exactly when the surviving finite cubic set is zero-sum-free. Hence

```text
Q_axis(p_A,p_C)
  = [p_A^q + q(1-p_A)p_A^(q-1)]
    * sum_(S zero-sum-free)
        (1-p_C)^|S| p_C^(q-|S|).                          (3)
```

The isolated cubic-infinity helper does not affect this law. Formula (3) identifies the second
factor as the independence polynomial of the zero-sum-triple hypergraph. Cap-set enumeration,
containers, and stability can therefore be imported directly into axis reliability.

### 3. Complete repair ports are ideal linear access structures

**Confidence: high; exact translation, with global secrecy claims requiring care.**

For a representable matroid with distinguished dealer `x`, the minimal qualified coalitions of its
port are exactly

```text
{C-{x} : C is a circuit containing x}.
```

This is the same support object as the complete repair port at `x`. Consequently:

- a surviving helper coalition can repair `x` exactly when it is qualified to reconstruct the
  dealer value in the associated ideal linear secret-sharing scheme;
- C219 reliability is the probability that a random participant coalition is qualified;
- minimum repair blockers become minimum coalitions that intersect every minimal qualified set;
- C218 gives harmonic-Steiner ideal access structures with explicit random-coalition thresholds;
- C217 distinguishes inequivalent linear realizations of the same minimal access structure.

The standard matroid-port connection is reviewed in
[*Secret Sharing Schemes for Ports of Matroids of Rank 3*](https://eprint.iacr.org/2020/008.pdf).
Locally repairable secret sharing is already an established neighboring problem; see
[Agarwal--Mazumdar](https://arxiv.org/abs/1503.04244).

C216 may imply that a prescribed representable ideal access structure occurs blockwise with
positive density in an asymptotically good ambient code. This does **not** automatically give an
optimal global secrecy threshold or an MPC protocol; those require separate statements.

### 4. Holonomy is representation geometry for a fixed access structure

**Confidence: proved as code inequivalence; cryptographic consequence medium-confidence.**

C217 shows that two ports can have identical circuit supports and hence identical minimal repair
sets or qualified coalitions, while their coefficient holonomies lie in different gauge orbits.
In secret-sharing language:

> The authorization logic does not determine the reconstruction-coefficient geometry.

This suggests a moduli problem for ideal linear realizations of one access structure. The most
important bounded question is whether distinct holonomy classes can differ in multiplicativity or
strong multiplicativity, properties needed by linear secret sharing in secure multiparty
computation. Codes, matroids, multiplicative LSSS, and MPC are connected in
[Cramer et al.](https://eprint.iacr.org/2004/245.pdf).

A positive example from the two certified q=9 representations would give C217 a direct
cryptographic operational consequence.

### 5. Pivotal influence is the marginal value of hardening a helper

**Confidence: proved for product failure laws.**

C219 gives

```text
partial R_x / partial s_v = Pr(v is pivotal).
```

This is exactly the first-order reliability benefit of improving helper `v`'s survival
probability. It supports:

- optimal small-budget helper upgrades;
- orbit-reduced hardening policies in symmetric ports;
- comparison of replicated, hardened, and ordinary helpers;
- sensitivity analysis under type-dependent failure probabilities.

C218 makes the interpretation sharp. At a curve target every repair contains the nucleus, so the
nucleus is a series bottleneck and should be hardened or replicated before ordinary curve helpers.
At the nucleus target the automorphism group spreads influence across the curve helpers.

### 6. Single-target availability misses multi-target congestion

**Confidence: high as a diagnosis; new invariant required.**

C218 has many repairs per curve coordinate, but every one uses the nucleus. Several simultaneous
curve repairs therefore contend for the same helper. Matching number at one target does not see
this cross-target congestion.

A natural next invariant is a capacitated scheduling polytope:

- each repair edge is a feasible job;
- each helper has a service capacity;
- several failed targets compete for helpers;
- integral and fractional throughput measure parallel service;
- sequential service may use freshly recovered nodes.

Steiner systems already occur in repair and parallel-repair work. Nested Steiner quadruple systems
have been studied from a fractional-repetition repair motivation; see
[Chee--Dau--Etzion--Kiah--Zhang](https://doi.org/10.1002/jcd.21973).

### 7. C216 is a universality or compilation theorem

**Confidence: high as a conceptual corollary; hardness statements unproved.**

C216 says that global rate and distance do not force locally generic behavior. Subject to the
exact confinement criterion, a finite representable port can be repeated with positive density
inside an asymptotically good family. The preserved local object can include:

- repair supports and blockers;
- coefficient holonomy;
- weighted costs;
- reliability and pivotality;
- an ideal access structure;
- a bounded erasure-decoding rule.

This suggests complexity transfer: difficult reliability, scheduling, equivalence, or
representation problems on finite ports may remain difficult even when restricted to coordinates
of asymptotically good codes. A formal reduction is still needed.

## II. Further structural interpretations

### 8. Radius-truncated EXIT functions

**Confidence: exact identification.**

Let `A` be the surviving coordinates other than `x`. With all circuits available,

```text
x is recoverable from A
  iff x lies in the matroid closure of A
  iff some circuit C containing x has C-{x} subset A.
```

This is symbolwise optimal decoding on an erasure channel. Restricting to circuits with
`|C|-1<=r` gives a radius-truncated or bounded-query EXIT function

```text
R_x^(<=r)(p)=1-h_x^(<=r)(p).
```

Therefore:

- C219 pivotal influences are derivatives of a local EXIT function;
- blockers are bounded-query erasure-failure certificates;
- C216 preserves prescribed low-query EXIT curves;
- increasing `r` gives a hierarchy from cheap local decoding to full MAP erasure decoding.

Influence, symmetry, and EXIT area arguments are central in BEC capacity results such as
[Kudekar et al. on Reed--Muller codes](https://arxiv.org/abs/1505.05831).

### 9. Pointed Tutte or matroid-perspective polynomial

**Confidence: theorem-ready identification problem.**

The full Boolean function is the distinguished-element rank-jump statistic

```text
A |-> 1[r(A union {x})=r(A)].
```

C219 already supplies deletion--contraction. This strongly suggests packaging reliability as a
specialization of a pointed Tutte polynomial or the Tutte polynomial of the perspective between
deletion and contraction at `x`.

Such an identification could import:

- duality and activity expansions;
- flat and rank-generating formulas;
- relations with split or pointed code weight enumerators;
- exact algorithms at bounded branchwidth;
- counting-hardness results in general;
- possible coefficient inequalities from modern matroid polynomial theory.

The last item is exploratory: log-concavity or Lorentzian behavior must be proved for the exact
pointed polynomial rather than inferred from nearby matroid results.

### 10. A full port determines a connected matroid

**Confidence: classical for the unbounded support port.**

A connected matroid is determined by the circuits containing any fixed element. Hence the
unbounded complete port at one coordinate is not merely local metadata: it determines the entire
abstract dependence geometry. The bounded port used for radius-limited repair need not do so.

Together with C217, this yields a clean two-layer picture:

```text
full support port  -> abstract connected matroid
coefficient holonomy -> field representation up to gauge
```

This opens reconstruction, auditing, and equivalence questions: how many circuit or repair-oracle
queries reconstruct the matroid, and how many coefficient queries reconstruct its representation?

### 11. Local blockers are stopping configurations

**Confidence: exact for erasure decoding with the selected bounded checks.**

Minimal dual circuits are irredundant parity-check supports. A failure set blocking every bounded
repair of `x` is a local stopping configuration. Across all failed coordinates, a terminal set `E`
for repeated local repair satisfies

```text
for every x in E, every permitted repair of x meets E.
```

This connects:

- C202 and C220 to the first terms of an erasure-decoding error floor;
- C218 designs to explicit stopping structures;
- C219 probabilities to local iterative-decoding failure laws;
- minimum blockers to targeted adversarial failure patterns.

Extension to trapping or absorbing sets on non-erasure channels is plausible but decoder-specific.

### 12. Programmable local decoding

**Confidence: conceptual synthesis of C215--C219.**

A possible port specification language would contain

```text
support logic
+ field representation and coefficients
+ helper costs
+ failure law
+ congestion capacities.
```

A compiler would check representability and confinement, compute port invariants, and emit an
asymptotically good construction carrying the requested local behavior. A further extension would
prescribe proportions of several port types, producing unequal protection or differentiated
storage service.

### 13. Characteristic fingerprints

**Confidence: medium; requires representability proofs.**

C217 holonomy and C218's characteristic-three nucleus suggest that a small port may certify its
minimal field of definition or exclude representations in other characteristics. If proved, this
would give:

- local certificates against alphabet migration;
- field-aware concatenation checks;
- characteristic-dependent ideal secret-sharing structures;
- field-sensitive network and index-coding gadgets;
- small witnesses for representability obstructions.

No such obstruction is claimed yet for the complete C218 support matroid; that is a bounded audit
target.

### 14. Cost--reliability surfaces

**Confidence: theorem-ready definition.**

Combine C215 and C219 by defining

```text
R_x(p,B)=Pr(some surviving repair has cost at most B).
```

This surface records far more than nominal locality. It gives the probability of meeting a
latency, bandwidth, energy, or access-cost budget under failures. Its breakpoints identify changes
in the cheapest available repair mechanism, and its partial derivatives value helper hardening at
each service budget.

### 15. Joint ports and recovery programs

**Confidence: medium; requires a new object.**

A pointed port answers whether one target is presently repairable. A joint port should record
sequential or simultaneous recovery programs for a failed target set. A repair rule

```text
H -> x
```

is a Horn implication: once every helper in `H` is available, `x` becomes available. Sequential
repair is closure under these implications.

This connects joint repair to directed-hypergraph reachability, Horn logic, bootstrap percolation,
target-set selection, and scheduling. The questions include recoverability, minimum permanent
failure sets, synchronous repair depth, helper capacities, and random recovery cascades.

## III. Second-order research programs

The following table records what becomes possible after combining the new interpretations rather
than merely renaming an existing invariant.

| Program | Enabling chain | New capability | Confidence |
|---|---|---|---|
| port compiler and complexity transfer | C215 + C216 + finite port algorithms | embed difficult local gadgets in globally good codes | high conceptually; reductions open |
| GLDPC component engineering | truncated EXIT + exact finite ports | optimize density evolution using geometric component codes | medium-high |
| additive statistical mechanics | formulas (1)--(3) + C220 | enumerate small sumsets/caps through reliability partition functions | high |
| representation moduli | full port reconstruction + C217 | classify abstract matroids separately from their linear realizations | high |
| holonomy-sensitive MPC | access structures + C217 | distinguish MPC capability at fixed authorization supports | medium |
| matroidal network/index gadgets | characteristic fingerprints + holonomy | field-sensitive solvability instances | medium |
| cooperative repair capacity | joint ports + scheduling polytope | parallel/sequential throughput and congestion regions | medium |
| pointed Tutte theory | rank jump + deletion--contraction | duality, composition, algorithms, coefficient bounds | medium/exploratory |
| configuration-space construction engine | C217 cross-ratios + C218 harmonic blocks | generate repair geometries from algebraic loci | exploratory |

### 16. Local EXIT components for GLDPC and spatial coupling

Generalized LDPC analysis builds global erasure transfer curves from component-code EXIT functions;
see [Paolini--Fossorier--Chiani](https://doi.org/10.1109/TIT.2010.2040938). The cubic and harmonic
ports provide exact, highly structured component EXIT functions. A concrete program is:

1. compute their exact multitype EXIT functions;
2. place them as variable or check components in a sparse ensemble;
3. run density evolution;
4. optimize mixtures against SPC, Hamming, or simplex components;
5. test whether spatial coupling produces threshold saturation.

The final step is not automatic. The value is that the local geometry, stopping spectrum, and
reliability curve are all known exactly before ensemble optimization.

### 17. Additive partition functions and phase behavior

Formula (2) is a low-temperature partition function with energy `delta(S)`. C220 classifies its
ground and first excited states. This invites:

- cluster or polymer expansions near high survival;
- container bounds for the number of low-defect sets;
- large-deviation principles for restricted-sumset size;
- phase-transition questions as `q` grows;
- recovery of additive enumerators from reliability coefficients.

Formula (3) offers the analogous program for zero-sum-free sets and cap-set containers.

### 18. Representation moduli, reconstruction, and information exposure

The support port can determine the connected matroid while holonomy distinguishes its linear
realizations. This opens:

- canonical port fingerprints for code-equivalence databases;
- algorithms reconstructing a code matroid from a repair oracle;
- deformation spaces of representations with fixed support port;
- minimal-field and field-of-definition questions;
- auditing how puncturing, shortening, or node replacement changes the port.

There is also an information-exposure implication: publishing every repair alternative may reveal
the full abstract dependence geometry. This is normally harmless for public codes but can matter
for proprietary deployments or coefficient-sensitive secret-sharing implementations.

### 19. Secure MPC and field-sensitive computation

The first bounded experiment is to test C217's two support-identical q=9 representations for
multiplicative and strongly multiplicative LSSS behavior. If the answer differs, holonomy becomes
an MPC-relevant invariant.

Representable matroids also govern scalar linear network computation
([Gupta--Rajan](https://arxiv.org/abs/1607.00490)) and reduce to index-coding instances
([El Rouayheb--Sprintson--Georghiades](https://arxiv.org/abs/0810.0068)). A characteristic or
holonomy obstruction that survives those reductions would generate networks or index codes with
the same visible dependency supports but different field or coefficient behavior.

### 20. Configuration spaces as a geometric construction engine

C217's first holonomy is a projective cross-ratio. C218's repair blocks are harmonic quadruples,
also characterized by a special cross-ratio. The coincidence suggests a systematic construction
route:

1. choose algebraic cross-ratio loci in configurations on `P^1`;
2. lift them through rational normal curves, nuclei, or other projective embeddings;
3. identify the resulting circuit designs;
4. study representation moduli, degenerations, and characteristic-dependent fibers;
5. test C215--C216 confinement and realization.

This could replace isolated geometric searches with a moduli-space program. It is exploratory and
should begin only with a sharply bounded second example.

## IV. Downstream consequences of the newer doors

This section goes one generation beyond the interpretations in Section II.

### 21. EXIT hierarchy gives an adaptive-locality distribution

For successive radii,

```text
R_x^(<=r)(p)-R_x^(<=r-1)(p)
```

is the probability that radius `r` is the smallest currently available repair radius. Therefore
the hierarchy determines:

- expected adaptive locality under a failure law;
- the tail probability of exceeding a latency or bandwidth budget;
- escalation policies that try cheap repairs before expensive ones;
- comparisons between codes with identical nominal locality but different fallback profiles.

A candidate locality-deficit invariant is

```text
L_r = integral_0^1 [h_x^(<=r)(p)-h_x^MAP(p)] dp.          (4)
```

Relating (4) to the EXIT area theorem could yield a rate-versus-bounded-local-decoding inequality.
This is theorem-ready as a question, not yet a result.

### 22. Pointed Tutte theory gives a compositional algebra

If the rank-jump polynomial is identified correctly, matroid operations should translate to port
operations:

- deletion and contraction model helpers fixed dead or fixed available;
- direct sums model independent modules;
- parallel connections and 2-sums model glued repair modules;
- duality exchanges dependency and cut-like failure descriptions.

This could compute large-port reliability from small modules and lead to fixed-parameter algorithms
at bounded branchwidth. The converse direction is a likely exact-evaluation hardness program.

### 23. Full-port reconstruction gives audit and reverse-engineering algorithms

The classical determination theorem motivates precise query-complexity questions:

- how many minimal repair sets suffice to reconstruct the connected matroid?
- can one store a fundamental circuit basis and recover the rest by circuit elimination?
- how many coefficient relations determine all fundamental holonomies?
- can two deployed codes be tested for monomial equivalence using only repair queries?

This also suggests incremental audit algorithms for puncturing, shortening, node replacement, and
silent configuration drift.

### 24. Stopping sets give error floors and recovery cascades

The low-cardinality blocker counts become exact first terms in the failure probability of a local
iterative erasure decoder. Across all targets, terminal stopping sets govern:

- finite-length error floors;
- minimum unrecoverable failure clusters;
- expurgation or port-mixture design;
- targeted adversarial failures;
- the number of synchronous repair rounds;
- cascade thresholds under random initial survival.

The joint closure process links this directly to bootstrap percolation and Horn implication
systems.

### 25. A port compiler gives mixed local populations

A further extension of C216 would prescribe not one port type but asymptotic proportions of several
types. The resulting achievable object would include

```text
(rate, distance, distribution of port types,
 reliability curves, latency curves, field constraints).
```

This is a natural theory of unequal erasure protection and differentiated service. It also raises
the synthesis problem: decide whether a requested behavioral specification is representable and
confinable, then construct or reject it with a certificate.

### 26. Characteristic fingerprints give alphabet-compatibility certificates

A proved local field obstruction would support:

- migration audits between alphabets;
- automatic rejection of incompatible concatenations;
- field-specific network and index-code gadgets;
- characteristic-dependent access structures and MPC capabilities;
- small witnesses for linear-rank obstructions.

The strongest version would identify the minimal field of definition from support and holonomy
data.

### 27. Cost--reliability surfaces give online stochastic control

After observing a failure state, a controller may choose whether to wait, use a more expensive
repair, rebuild an intermediate node, replicate a bottleneck, or preserve scarce helper capacity.
This turns the static surface into a Markov decision problem with:

- helper survival and correlation as state uncertainty;
- C215 costs as action prices;
- C219 influences as local marginal values;
- joint-port closure as state transition;
- latency, energy, and service-level penalties as objectives.

C218's nucleus is a canonical complementarity example: ordinary curve helpers have little value
when the common nucleus is unavailable.

### 28. Joint ports give Horn closure, antimatroids, and repair capacity regions

Sequential recovery under rules `H -> x` is Horn closure. This opens precise algorithmic and
structural questions:

- decide whether a failed set is recoverable;
- find the cheapest seed set whose recovery unlocks all targets;
- find a minimum permanent failure set;
- minimize synchronous repair depth;
- maximize capacitated parallel throughput;
- determine random-cascade thresholds.

For special ports, the family of feasible intermediate recovered sets may form an antimatroid or
greedoid, making greedy scheduling correct. Characterizing exactly which linear repair ports have
this property would be a substantial theorem.

Sequential and parallel multi-erasure repair are established distinct models; see
[Song--Yuen](https://arxiv.org/abs/1511.06034). Joint ports could supply one finite semantic object
for both.

## V. Recommended disposition

### Paper-ready additions

The combined repaircodes/repairports manuscript would most benefit from four bounded additions:

1. prove and state the exact transforms (1)--(3);
2. identify bounded repair reliability as a radius-truncated EXIT function;
3. state the support-port/access-structure translation and carefully delimit the secret-sharing
   consequence;
4. explain the two-layer distinction between abstract support ports and coefficient holonomy.

These sharpen the conceptual contribution without requiring another large geometric search.

### Best bounded research probes

In order of expected value:

1. identify the pointed Tutte or matroid-perspective polynomial exactly;
2. test C217's two q=9 representations for multiplicative-LSSS behavior;
3. compute exact cubic and harmonic component EXIT curves and run a first GLDPC density-evolution
   comparison;
4. define the two-target joint port and enumerate the q=9 recovery closure as a stress test;
5. audit whether the C218 support matroid is representable outside characteristic three.

### Highest-EV portfolio in detail

Here “expected value” means conceptual or publication payoff multiplied by the probability of a
clean bounded result, discounted for scope risk. It is not a claim about theorem difficulty or a
time estimate. Immediate manuscript value and longer-term research-option value are separated:

| Pick | Immediate manuscript value | Research-option value | Scope risk | Verdict |
|---|---|---|---|---|
| exact reliability transforms + truncated EXIT | very high | high | low | do first |
| pointed Tutte/perspective identification | high if exact | very high | low-to-medium | best mathematical probe |
| holonomy-sensitive LSSS/MPC test | high if positive | very high | low if bounded | best asymmetric bet |
| q=9 joint-port/Horn prototype | modest for current paper | very high | medium | best next-program seed |
| component EXIT + GLDPC density evolution | medium | high | medium | best external application test |
| C218 characteristic audit | medium if obstructed | medium-high | low-to-medium | opportunistic sixth |

#### Pick A — exact transforms and truncated EXIT framing

**Rank:** highest immediate EV; theorem-ready.

**Why it ranks first.** Equations (1)--(3) already follow from the completed structural
classifications by one conditioning argument. The truncated EXIT identification is likewise exact.
Together they connect C219 and C220 to standard coding-channel language without requiring a new
construction, a new search, or a large literature-dependent proof. They also turn the reliability
section from a collection of finite calculations into a pair of general transforms.

**Concrete deliverable.** A compact manuscript package should contain:

1. the multitype cubic transform (1);
2. its homogeneous defect form (2);
3. the axis factorization (3);
4. the definition of `h_x^(<=r)` and the identity `R_x^(<=r)=1-h_x^(<=r)`;
5. the deletion--contraction and pivotal-derivative formulas in EXIT notation;
6. the q=9 leading layers as examples, with no new census;
7. one paragraph distinguishing bounded local EXIT, full symbol-MAP EXIT, and C216's
   fixed-alphabet asymptotic regime.

**Immediate deductions.** The same proposition yields:

- the exact distribution of the cheapest available repair radius through successive differences
  `R^(<=r)-R^(<=r-1)`;
- a stopping-set interpretation of C202 and C220;
- a direct route from future restricted-sumset or cap-set enumeration to reliability;
- exact component functions for a later GLDPC test.

**Promotion gate.** Promote into the combined paper if the formulas remain compact after aligning
the paper's failure/survival conventions and a focused prior-art check finds no identical complete-
port statement. Even if the transform is classical in another language, retain it as a corollary
if it materially shortens or strengthens the operational section.

**Kill or containment criteria.** Do not let this expand into:

- a general BEC-capacity claim;
- an unproved EXIT area theorem;
- a complete defect enumerator beyond C220;
- new q=9 orbit tables;
- a claim that bounded repair equals full MAP decoding.

**Main risk.** The notation can silently conflate erased and surviving coordinates or local and
unbounded recovery. State all four conventions once and test the formulas at `p=0` and `p=1`.

#### Pick B — pointed Tutte or matroid-perspective identification

**Rank:** highest mathematical EV among bounded probes.

**Why it ranks this high.** C219's recurrence is already Tutte-like, while the full repair event is
the rank-jump condition at one distinguished element. An exact identification could replace an
ad hoc reliability calculus with a standard invariant and import duality, composition, algorithms,
and code-enumerator relations at once. The initial probe is small: it is a subset-expansion
comparison, not a new geometric classification.

**Concrete first probe.** For a nonloop distinguished element `x` of a matroid `M`, define a
multivariate pointed rank-jump polynomial separating subsets `A subset E-{x}` according to

```text
epsilon_x(A)=r_M(A union {x})-r_M(A) in {0,1}.
```

Then:

1. write its subset expansion with cardinality, rank, and nullity variables;
2. derive deletion--contraction at an ordinary helper;
3. compare it exactly with the Las Vergnas/Tutte polynomial of the natural perspective involving
   `M\x` and `M/x`;
4. identify the specialization giving homogeneous and multivariate repair reliability;
5. test the formula on a uniform matroid, the cubic q=9 target, and the harmonic q=9 target;
6. determine whether duality exchanges the port with a useful blocker or cocircuit polynomial.

**Outcome ladder.** There are three useful outcomes:

- **strong GO:** reliability is a direct specialization of a standard perspective polynomial and
  at least one nontrivial theorem imports immediately;
- **partial GO:** the exact object is a modest pointed refinement, but it has a clean universal
  recurrence and composition law not visible in the current presentation;
- **STOP:** the standard polynomial forgets the distinguished closure event and the proposed
  refinement merely restates the full Boolean truth table without compression or a new theorem.

**Promotion gate.** A name match alone is insufficient. Promotion requires one useful consequence:
a duality formula, a 2-sum/parallel-connection composition law, a bounded-branchwidth algorithm, or
a coefficient/weight-enumerator identity.

**Main risks.** Ordinary Tutte data may not determine a pointed port, and the radius cutoff is not
encoded by the full rank-jump statistic. The first paper statement should therefore concern the
unbounded port; bounded EXIT is a filtered refinement and may require additional variables.

**Opened option if successful.** The result would justify a separate pointed-Tutte program on
composition, fixed-parameter evaluation, complexity, and possible log-concavity. No Lorentzian or
Hodge claim should be made until the exact polynomial class is established.

#### Pick C — holonomy-sensitive multiplicative secret sharing

**Rank:** largest asymmetric upside from a small experiment.

**Why it ranks this high.** C217 currently proves an algebraically genuine distinction whose
operational meaning is not yet decisive. Multiplicativity of an LSSS depends on coefficient-level
data and is central to MPC, while the access structure depends only on supports. The existing pair
of q=9 representations already supplies a controlled test: same support port, different holonomy,
no search for examples required.

**Concrete bounded experiment.** For both certified q=9 representations:

1. fix the exact matroid-port/linear-secret-sharing orientation and dealer convention;
2. construct the corresponding ideal LSSS matrices;
3. implement or symbolically derive the standard multiplicativity criterion;
4. test strong multiplicativity under the relevant adversary deletions if ordinary
   multiplicativity differs or is automatically satisfied;
5. verify that the criterion is invariant under the circuit and coordinate gauges quotiented by
   C217;
6. express any difference as a holonomy equation rather than as a raw matrix computation.

**Outcome ladder.**

- **major GO:** the two representations have different multiplicative or strongly multiplicative
  behavior; this gives holonomy a direct cryptographic meaning;
- **structural GO:** both examples agree, but the criterion factors through a new explicit
  holonomy expression that can classify a larger family without search;
- **negative boundary:** the criterion provably depends only on the support port in this rank or
  family;
- **STOP:** the pair agrees and the symbolic criterion exposes no holonomy dependence. Record the
  negative and do not begin an open-ended representation census.

**Promotion gate.** A finite difference must be accompanied by a gauge-invariant proof or a
general criterion explaining it. A raw q=9 yes/no table is not paper-level.

**Main risks.** Multiplicativity may depend on the whole represented matroid rather than the
bounded port alone; primal/dual conventions can reverse the access structure; and both q=9
realizations may lie on the same side of the MPC criterion despite being inequivalent.

**Opened option if successful.** This would connect complete repair ports to characteristic-
dependent MPC, representation moduli of ideal access structures, and field-sensitive network or
index coding. It could justify a cryptography-facing follow-up rather than merely another coding
section.

#### Pick D — q=9 joint-port and Horn-closure prototype

**Rank:** best seed for a new standalone program; not needed for the current paper.

**Why it ranks this high.** The common-nucleus bottleneck proves that single-target availability
can badly misrepresent system-level service. Joint ports address a real semantic gap, and q=9
already has complete circuit inventories, symmetry actions, and independent verifiers. A bounded
prototype can determine whether Horn closure yields a compressible theory before any general
architecture is chosen.

**Minimal definition.** For a fixed repair-radius inventory on ground set `V`, an initially live
set `L` grows by the closure rule

```text
x enters L if some repair edge H for x satisfies H subset L.
```

The terminal closure, repair depth, and feasible parallel layers are the first joint-port
invariants. Capacities should be deferred until the uncapacitated closure is understood.

**Concrete q=9 prototype.** For the cubic--axis and harmonic systems:

1. compute closure for every initial live set, reduced by failure-set size and symmetry;
2. enumerate minimal permanent failure sets;
3. compare one-round parallel, unrestricted parallel, and sequential recoverability;
4. record minimum and maximum repair depth;
5. isolate the effect of the C218 nucleus being live, dead, replicated abstractly, or given
   capacity one;
6. test whether feasible recovered-set families satisfy accessibility, union closure, or an
   antimatroid/greedoid axiom;
7. seek a symbolic reduction before promoting any orbit census.

**Promotion gate.** Require at least one of:

- a general Horn-closure recurrence;
- a structural characterization of permanent failures;
- an antimatroid/greedoid theorem for a natural port class;
- a strict separation between sequential and parallel recovery with a uniform family;
- a random-cascade threshold theorem.

**Kill criteria.** Stop if the q=9 closure produces only a large unstructured orbit table, if no
definition cleanly separates target failures from helper service capacity, or if the result merely
restates ordinary global erasure correction.

**Opened option if successful.** Joint ports could unify cooperative repair, stopping sets,
bootstrap percolation, Horn implication systems, batch scheduling, and repair-control policies.

#### Pick E — exact component EXIT and a first GLDPC comparison

**Rank:** best established external application; medium scope.

**Why it is valuable.** GLDPC density evolution already consumes exact component EXIT functions.
The repair ports provide structured components with known geometry, blocker spectra, and
multitype reliability. This is a direct way to test whether the theory improves an established
coding design problem rather than only supplying new language.

**Concrete bounded experiment.**

1. derive exact univariate and type-dependent EXIT polynomials for the q=9 cubic and harmonic
   components;
2. specify precisely whether they act as variable-node or check-node components;
3. choose one rate-matched SPC/Hamming/simplex baseline per component;
4. run density evolution on a small, documented ensemble family;
5. compare iterative threshold, stability condition, and predicted error-floor contribution;
6. separate benefits due to component distance from benefits due to complete-port geometry;
7. stop before ensemble-wide optimization unless a strict effect appears.

**Promotion gate.** Require a reproducible threshold or error-floor tradeoff that is not explained
solely by using a larger or stronger component code. A negative result is still useful if it shows
that complete-port richness does not improve density evolution beyond ordinary component
parameters.

**Main risks.** C216's concatenated families are not automatically sparse GLDPC ensembles; the
alphabet and rate matching may make the comparison artificial; and the common nucleus may hurt
iterative performance despite giving elegant finite geometry.

**Opened option if successful.** A positive comparison leads naturally to spatial coupling,
mixtures of port types, threshold saturation, and port-aware component optimization.

#### Pick F — characteristic audit of the C218 support matroid

**Rank:** opportunistic sixth; bounded but binary in payoff.

**Why it remains attractive.** C218 arises from a characteristic-three nucleus, while C217 shows
that support and representation data must be distinguished. If the resulting support matroid
itself excludes other characteristics, the port becomes a small local field certificate. If it is
widely representable, the negative sharply limits the characteristic-fingerprint narrative.

**Concrete bounded audit.**

1. extract an exact abstract support matroid for the smallest q=9 harmonic system or a carefully
   chosen minor carrying the nucleus circuits;
2. formulate realization equations modulo projective and coordinate gauge;
3. test small characteristics first, using symbolic elimination or certified finite search;
4. isolate a minor obstruction or holonomy identity if nonrepresentability appears;
5. distinguish “this displayed NRC realization needs characteristic three” from “the abstract
   support matroid is representable only in characteristic three.”

**Promotion gate.** Require a symbolic obstruction, excluded-minor witness, or exact
characteristic theorem. A solver failure or absence of a small-field representation is not enough.

**Kill criteria.** If explicit representations appear in several characteristics and no useful
minimal-field invariant survives, record that the characteristic dependence belongs to the
geometric realization rather than the support port and stop.

#### Recommended execution order

The portfolio is deliberately sequential:

1. **Do Pick A first.** It is almost entirely deductive and strengthens the combined manuscript
   regardless of later outcomes.
2. **Run Pick B as the first literature/symbolic probe.** A clean standard-polynomial
   identification could reorganize the reliability section before drafting hardens.
3. **Run Pick C as one bounded q=9 experiment.** Its upside is large, but its stop rule must be
   enforced.
4. **Choose between Picks D and E according to the desired next audience.** D builds a new
   repair-theory program; E tests relevance to iterative coding practice.
5. **Run Pick F only in a quiescent bounded window** or when field dependence becomes important to
   the manuscript's claims.

The portfolio should not run as six simultaneous open fronts. Picks A--C are the highest-EV
pre-draft sequence; D--F are option value after the combined paper's theorem package is fixed.

### Stand-alone follow-up programs

The following are large enough to require separate allocation and handoff state:

- joint/cooperative repair ports and Horn closure;
- port compiler and mixed-type achievable regions;
- additive partition-function asymptotics beyond defect one;
- representation moduli, minimal fields, and network/index reductions;
- pointed Tutte theory and locality-area inequalities.

### Explicit nonclaims

This brainstorm does not establish:

- capacity achievement or threshold saturation for a GLDPC ensemble;
- a new Tutte, Lorentzian, or log-concavity theorem;
- computational hardness within asymptotically good families;
- multiplicative MPC behavior distinguished by C217 holonomy;
- nonrepresentability of the C218 port outside characteristic three;
- a batch, PIR, quantum, network, or index code construction;
- a joint-port antimatroid theorem.

Those are opened doors, not completed results.
