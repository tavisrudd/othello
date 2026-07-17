# C245--C249 adjacent novel openings audit

**Lane:** `rp-next`

**Date:** 2026-07-17

**Status:** COMPLETE — the closed headline claims were not reopened. Four narrower adjacent
problems are allocated as outcome-gated C254--C257 after C249's C250--C253 follow-ons.

## Executive decision

The premise needs one correction. Not every path from C245 onward was closed by prior novelty:

| Source | What actually happened | Best adjacent opening | Present grade |
|---|---|---|---|
| C245 | no counterexample; nearby Lorentzian theorems count the wrong slice | two-terminal reliability coefficients, first on series--parallel graphs | **A- conjecture probe** |
| C246 | strongest theorem succeeded; no external novelty claim was needed | minimum-size realization of a realizable separator profile | **B+ compression problem** |
| C247 | tracts/foundations already own the generic dictionary | gauge-invariant implementation cost of a coefficient repair library | **A- if a strict pair exists** |
| C248 | additive field separation succeeded; strong lifting failed for lack of a growing lower-bound object | rigidity and MSP cost of radius-truncated ports | **A- bounded theory probe** |
| C249 | exact selector worked; resilient-routing literature owns the generic optimization frontier | proof, benchmark, active discovery, and continuation exports | **already allocated as C250--C253** |

The four new entries below are queued as bounded probes, not presumed paper claims. Each must still
pass the stated experiment or lemma and its own focused literature audit. They sit after C250--C253
unless the user explicitly changes the order.

## C245: move the conjecture sideways into two-terminal reliability

For a graphic matroid `M(G)` and target edge `x=st`,

```text
x in cl(S)  iff  the edges S contain an s--t path.
```

Consequently C245's coefficient

```text
a_k(M(G),x) = #{S subset E(G)-{x} : |S|=k and S connects s to t}
```

is exactly the size-graded coefficient sequence underlying two-terminal reliability:

```text
R_st(p) = sum_k a_k p^k (1-p)^(m-k),   m=|E(G)-{x}|.    (1)
```

This is a materially better adjacent home than another undirected matroid sweep. Two-terminal and
all-terminal reliability are related but behave differently; Brown--DeGagne explicitly emphasize
that even the root theory of the two-terminal polynomial is much less developed and differs from
the all-terminal case
([arXiv:2006.09908](https://arxiv.org/abs/2006.09908)). C245 already explains why the available
matroid-morphism Lorentzian results do not prove log-concavity of this all-subset rank-drop slice.
The reliability translation therefore supplies a new proof toolbox and test corpus, not a theorem
by renaming.

### C254 (opening C245-A): series--parallel closure

Ask whether `(a_k)` is log-concave for every two-terminal series--parallel network. Series and
parallel composition give exact reliability recurrences, so this is the smallest natural class on
which a preservation theorem might exist. The first probe should:

1. enumerate canonical two-terminal series--parallel networks through a fixed edge budget;
2. compute the exact `a_k` sequence and equality cases;
3. test which series/parallel convolution operation preserves LC and where naive preservation
   fails; and
4. promote only if it yields either a closure lemma or a counterexample.

Merely checking more arbitrary represented matroids remains below C245's gate. A graph
counterexample would refute the representable conjecture immediately; a series--parallel theorem
would be a clean nontrivial positive island even if the universal conjecture later fails.

### Secondary opening C245-B: strictness and equality

If the LC inequalities continue to hold, classify internal equality rather than escalating to a
bespoke Hodge proof. Equality may expose direct sums, forced edges, or series/parallel bottlenecks
that are invisible in the universal statement. This is secondary because it becomes meaningful
only after C245-A shows stable structure rather than accidental small-case behavior.

### New-perspective variants

- **Dual reliability:** translate the dual pointed port into size-graded minimal cut/failure
  coefficients and ask whether an inequality on path layers is equivalent to, or strengthened by,
  a cut-layer inequality.
- **Operational distribution:** normalize `(a_k)` as the successful-set size distribution. LC
  would imply unimodality, but reliability or hazard claims must be derived exactly rather than
  asserted from that word alone.
- **Algorithmic proof search:** use series/parallel expression trees to discover the missing
  coefficient inequality, instead of treating a larger census as evidence by itself.

## C246: compress the exact semantics rather than re-prove it

C246 did not close on prior art. It completely characterized realizable profiles and proved that
the effective response on those profiles is the fully abstract minimal structural semantics. The
remaining inefficiency is in the realization theorem: its private direct-sum gadget proves
existence but may use far more columns and ambient dimension than necessary.

For a realizable profile `d:B -> {0,...,r,infinity}`, define two representation costs:

```text
mu_col(d) = minimum number of active columns realizing d,
mu_dim(d) = minimum auxiliary dimension of such a realization.       (2)
```

These are not semantic-state minimization; C246 has already solved that. They are implementation
complexities of one semantic state. The quotient-Hamming interpretation places the problem near
coset-leader metrics and Hamming embeddings. Minimum-dimensional Hamming embeddings are already a
studied optimization problem for translation-invariant metrics
([D'Oliveira--Firer](https://www.aimsciences.org/article/doi/10.3934/amc.2017029?viewType=HTML)),
so a generic “minimum Hamming embedding” claim would not be novel. The possible gap is the exact,
projectively invariant, truncated quotient profile on every labeled boundary vector, together with
simultaneous column and private-dimension cost.

### C257 (opening C246-A): exact small-profile realization complexity

For `B=GF(2)^2, GF(2)^3, GF(3)^2` and `r<=3`, formulate realization as SAT/ILP over a bounded
ambient space and compute `mu_col` and `mu_dim` for every C246-realizable profile. Compare the
optima with the private-gadget construction.

**Promotion gate:** either a strict, recurring compression pattern leading to a general upper
bound, or a lower-bound invariant that certifies optimality for a nontrivial family. If the task is
only an instance of known Hamming-embedding dimension after translating definitions, cite it and
stop.

### Secondary opening C246-B: count the semantic carrier sharply

C241 uses a coarse finite state bound; C246 identifies the exact realizable subcarrier. Counting
or asymptotically bounding positive projectively invariant truncated-subadditive profiles could
sharpen the FPT constant. This is useful even without standalone novelty, but it should be promoted
only if it changes the algorithmic bound materially or yields a recognizable enumerative object.

### New-perspective variants

- **Synthesis:** generate a smallest represented context from a desired boundary contract.
- **Learning:** infer `d` with as few support queries as possible, exploiting subadditivity and
  projective invariance; do not call generic exact learning novel without a query separation.
- **Canonicalization:** use optimal realizations as compact certificates for equality of transfer
  states, while preserving C246's distinction between structural observations and count weights.

## C247: make foundation data pay rent through implementation cost

C247 correctly killed the generic tract/foundation unification claim: those theories already own
the support, coefficient, rescaling, and valuation dictionary. The opening is not another abstract
layer. It is an operational quantity defined *on* a foundation point.

Fix a selected multi-target repair circuit library `L`, a field `K`, and a hardware-cheap
coefficient set or subgroup `A` (for example `{0,1}`, `{0,+-1}`, a proper subfield, or a weighted
multiplier-cost table). Allow the legitimate gauge actions: scale coordinates and scale each
circuit equation. Define

```text
kappa_A(L) = minimum total non-A coefficient cost over the gauge orbit of L.   (3)
```

Unlike a raw coefficient list, `kappa_A` is invariant under the choices C247 quotients out. Unlike
the support repair port, it can distinguish coefficient realizations with identical circuits.
Restricted-reconstruction complexity is already real prior art: Ball--Cakan--Malkin study linear
threshold secret sharing with reconstruction coefficients restricted to `{0,1}` and formulate an
equivalent restricted span-program model
([ITC 2021](https://drops.dagstuhl.de/entities/document/10.4230/LIPIcs.ITC.2021.12)). Therefore the
potential novelty is narrower: simultaneous gauge optimization across a repair library, and a
foundation/cross-ratio obstruction to placing all equations in a cheap coefficient class.

### C255 (opening C247-A): strict gauge-cost pair

Use C217's support-identical `U(2,4)` axis realizations first. Exhaust the coordinate and circuit
scalings and test whether two different cross-ratio orbits have different `kappa_A` for a natural
cheap set. If four points are too small, join several overlapping `U(2,4)` restrictions so their
shared coordinate scalings couple the local normalizations.

**Promotion gate:** one support-identical pair with provably different optimum cost, plus a short
obstruction stated in cross-ratio/foundation language. If every tested cost reduces to a familiar
restricted-MSP or XOR-scheduling objective with no new coupled obstruction, retain it as an
implementation heuristic and stop.

### Bounded opening C247-B: subfield normalization feasibility

Given a represented repair library over `K/L`, decide whether its whole gauge class has a
representative whose selected circuit coefficients lie in the subfield `L`. This is more invariant
than asking whether the matroid itself is representable over `L`: only an operationally selected
library is constrained, but all its equations must be normalized simultaneously. A smallest strict
yes/no pair would make the foundation language operational without claiming a new foundation
theory.

### New-perspective variants

- **Compiler view:** synthesize a globally normalized repair kernel minimizing multipliers, table
  lookups, or bit-matrix XOR cost.
- **Robustness view:** minimize sensitivity to coefficient faults or quantization across the gauge
  orbit; this requires a concrete error model before promotion.
- **Valuation view:** move to a genuinely valued ground field only if precision, energy, or latency
  is measured. Finite-field valuation alone remains trivial and closed.

## C248: truncate the port before asking for a strong separation

C248's one-row barrier is exact for the **full** port because Lehman reconstruction recovers the
connected matroid. Radius truncation is precisely where the proof stops: it retains only circuits
through the target of size at most `r+1`, and may no longer determine the matroid.

Let `P_r(M,x)` denote that truncated antichain and let

```text
mSP_F(P_r) = minimum rows of an F-MSP computing the upward closure of P_r.      (4)
```

This asks a different question from the failed strong-separation lift. It seeks a local rigidity
criterion and its exact row consequence, not an asymptotic lower bound imported from a constant
`AG(2,3)` obstruction. The surrounding secret-sharing field is mature: matroid ports and share
complexity are studied directly
([Farras 2020](https://dml.cz/handle/10338.dmlcz/148490)), and constant-uniform access structures
have dedicated linear-secret-sharing constructions
([arXiv:2106.14833](https://arxiv.org/abs/2106.14833)). A claim must therefore depend on the
radius-truncated *matroid-port rigidity* or field sensitivity, not merely on bounded minterm size.

### C256 (opening C248-A): local port rigidity atlas

Enumerate small connected representations over `GF(2)`, `GF(3)`, and `GF(4)`. Canonicalize
`P_r(M,x)` for `r=2,3,4`, and group matroids sharing the same truncated port. Determine:

1. when the truncated port already determines the full connected matroid;
2. when it has realizations over fields that cannot represent the original matroid; and
3. whether a wrong-field realization requires repeated labels and hence more than one row per
   helper.

**Promotion gate:** either a checkable sufficient condition for truncated reconstruction, or a
small strict field-sensitive row gap that genuinely disappears at the support-function level when
the radius changes. A table alone is not enough.

### Bounded opening C248-B: locality-constrained MSP complexity

Instead of fixing only the accepted Boolean function, minimize MSP rows subject to every minimal
accepting witness having size at most `r`, or subject to an explicit repair-radius distribution.
This imports the operational locality parameter absent from ordinary total-row MSP complexity.
Promote only after checking whether it reduces to known uniform-access-structure or restricted-span-
program models. Binary reconstruction already shows that reconstruction restrictions can change
complexity substantially, but it is a neighbor, not evidence that radius locality is new.

### New-perspective variants

- **Property testing:** how many truncated-port queries certify that the full one-row Lehman
  barrier applies?
- **Parameterized complexity:** treat `r`, field size, and separator width as parameters and seek a
  finite obstruction/canonical-state theorem before any asymptotic separation.
- **Dual witnesses:** pair small repair circuits with bounded blockers; a two-sided local signature
  may recover rigidity that the primal truncated port alone loses.

Do not revive the old lift without a growing modular-cover/rank object, a characteristic-dependent
rank inequality, or a Nullstellensatz-degree family. Radius truncation is an alternate theorem,
not a shortcut around C248's kill.

## C249 and cross-cutting synthesis

C249 already received this treatment. Its exact failure-transversal selector was retained while
the generic resilient-routing novelty claim was closed; the four adjacent exports are now C250
through C253. No fifth planning task is justified by this audit.

Across C245--C248, four perspective shifts generated the surviving openings:

| Perspective shift | C245 | C246 | C247 | C248 |
|---|---|---|---|---|
| restrict the object | series--parallel graphs | small boundary/radius | selected repair library | radius-truncated port |
| change the optimized quantity | coefficient shape/equality | realization columns/dimension | multiplier/subfield cost | rows under locality |
| add a dual certificate | cuts/failures | lower-bound invariant | cross-ratio obstruction | blockers/local reconstruction |
| seek an algorithmic artifact | composition proof search | minimum context synthesizer | coefficient compiler | rigidity atlas/checker |

The strongest mathematical probes are C254, C255, and C256. C257 is the best algorithmic
compression probe. None should be advertised as novel until its bounded gate produces a strict
result and the resulting exact statement survives a dedicated literature search.

## Queue disposition

After C250--C253, run the allocated follow-ons in this order:

1. **C254:** two-terminal series--parallel LC closure/counterexample;
2. **C255:** strict gauge-invariant coefficient-cost pair;
3. **C256:** radius-truncated port rigidity atlas and lemma;
4. **C257:** minimum realization complexity of exact separator profiles.

C250--C253 remain the immediate queue. Allocation ensures the adjacent probes are revisited; it
does not waive their kill gates or grant a novelty claim in advance.
