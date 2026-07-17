# C240 — rp-next gap-probe battery

**Lane:** `rp-next`

**Date:** 2026-07-17

**Status:** COMPLETE — all five probes have deterministic certificates and bounded decisions.

## Goal and decision rule

Test five inexpensive claims proposed by the independent Fable gap reviews before allocating a
larger theorem program. Each probe ends in `GO`, `REFORMULATE`, or `KILL`. Positive finite data is
evidence, not a general theorem; literature-dependent novelty claims require primary-source
verification.

Advisory inputs are `2026-07-17-fable5-rp-next-independent-gap-review.md` and
`2026-07-17-fable5-rp-next-gap-deep-dive.md`. Their `REASONED` claims are hypotheses to replay, not
facts imported into C240.

## Probe ledger

| Probe | Reproducible question | Stop condition | Decision |
|---|---|---|---|
| pointed-profile shape | are all committed and sampled `a_k(M,x)` profiles LC or ULC? | first counterexample kills the universal form; otherwise record sample boundary | **REFORMULATE:** ULC false; LC survives bounded evidence |
| fixed-alphabet LRC | how far are C216+C218 families from the relevant asymptotic locality frontier? | exact normalized comparison and attribution of any stable gap | **REFORMULATE:** large plain-LRC gap; port-only cause not established |
| peeling classification | is `P_r = {M : L_r=cl_M on every seed}` empirically closed under minors, duality, or 2-sums? | smallest witness or bounded positive census | **KILL:** all three closure routes fail at radii two and three |
| cascade replay | do cubic closure and the harmonic zero-sum subsystem reduce to the claimed flat-lattice laws? | proof/replay or explicit counterexample | **GO cubic; REFORMULATE harmonic** |
| width-two boundary | do pointwise interface costs compose exactly beyond one-element gluing? | exact rule or smallest shared-helper obstruction requiring joint subspace state | **GO:** exact vector-cost convolution |

## 1. Pointed-profile shape scout

### Inputs and conventions

For a represented matroid and distinguished nonloop/noncoloop `x`, let

```text
a_k(M,x) = #{S subset E-{x} : |S|=k and x in cl_M(S)}.
```

LC means `a_k^2 >= a_(k-1)a_(k+1)`. ULC means the normalized sequence
`a_k/binom(n,k)` is log-concave. The certificate checks the four committed C227 profiles, one
explicit simple binary counterexample, and 10,760 pointed noncoloop cases from 2,000 deterministic
random simple binary matrices (seed 240, at most ten columns).

### Evidence

All four committed profiles are ULC. The universal ULC conjecture nevertheless fails for the
simple rank-five binary representation

```text
columns = (13,30,10,27,23,31,7),   x = column 10,
(a_0,...,a_6) = (0,0,1,4,6,5,1).
```

At `k=4`, normalized log-concavity would require `4320 >= 4500`. Ordinary LC holds for this
example and for all 10,760 sampled cases; this is finite evidence only.

The proposed proof route was overstated. Brändén--Huh prove Lorentzianity for matroid and
M-convex generating polynomials and derive strong Mason-type results
([arXiv:1902.03719](https://arxiv.org/abs/1902.03719)), while recent bimatroid work proves
log-concavity for particular basis/morphism enumerators
([arXiv:2402.15317](https://arxiv.org/abs/2402.15317)). Neither statement automatically covers the
rank-drop-one **all-subset** enumerator above, and taking the derivative difference in C227 is not
one of the closure operations justified merely by naming Lorentzian calculus.

### Decision

**REFORMULATE.** Kill ULC and the claimed Newton-inequality whole-curve estimator. Retain ordinary
LC as a sharply stated conjecture, but promote it only after translating `a_k` into an enumerator
covered by a matroid-morphism theorem or proving a new preservation result. The explicit ULC
counterexample is itself a useful boundary result.

## 2. Fixed-alphabet LRC arithmetic

### Inputs and conventions

Use C218's inner `[11,5,6]_9` code, locality four, outer alphabet `Q=9^5=59049`, and C216's scaled
GV family

```text
R_concat = (5/11) R_outer,
delta_concat >= (6/11) H_Q^(-1)(1-R_outer).
```

Compare at the same displayed relative-distance lower bound with the q-ary LRC GV lower bound in
Barg--Tamo--Vlăduţ, Theorem 4.7
([arXiv:1501.04904](https://arxiv.org/abs/1501.04904)). The cached authoritative PDF has SHA-256
`4de4457d56980d5fe997d708ef13a1a99b869e9ef67458442239aabcb7a3dafd`. Modern upper-bound context
comes from Roth's general linearly recoverable bounds
([arXiv:2010.14492](https://arxiv.org/abs/2010.14492)); cached SHA-256
`fb296a77b9933e5f8868549a7bbd1da89cc85223e1f881710636f0a3517002c3`.

### Evidence

The concatenation is not competitive as a plain locality-four code. Its zero-distance rate cap is
`5/11 = 0.454545`, versus the locality-only cap `4/5`; the gap is `0.345455`. On the nine sampled
outer rates `0.1,...,0.9`, the q=9 LRC GV lower bound at the same displayed distance exceeds the
C216 rate by `0.183306,...,0.317395`. Representative rows are:

| `R_outer` | C216 rate | C216 distance lower bound | q=9 LRC-GV rate | gap |
|---:|---:|---:|---:|---:|
| 0.1 | 0.045455 | 0.471146 | 0.228760 | 0.183306 |
| 0.5 | 0.227273 | 0.238701 | 0.467008 | 0.239735 |
| 0.9 | 0.409091 | 0.041243 | 0.726486 | 0.317395 |

This does **not** prove that the complete port itself costs that rate. It proves that C216's
disjoint full-inner-code replication pays the inner-code rate. Any family whose disjoint local
blocks are constrained to lie in this exact `[11,5]` inner code has the elementary independent
rank bound `R<=5/11`; realizing only the port equations may impose fewer independent constraints.

### Decision

**REFORMULATE.** Kill any frontier claim for C216+C218 as a plain LRC. Retain **port capacity** only
after separating three specifications: full inner-code restriction, exact port hypergraph, and
port containment. The next converse should define the minimum independent parity-rank density
needed to realize a port. It is promoted only if it improves on the trivial disjoint-block
`R<=k/m` bound and on locality-only bounds; the numerical gap alone is not attribution.

## 3. Peeling-optimality classification scout

### Inputs and conventions

`P_r` is the class of matroids for which small-circuit Horn closure `L_r` equals matroid closure on
every seed. The certificate uses simple binary column representations, then computes deletion and
dual rank functions exactly. For 2-sums it uses the standard binary representation with the glue
column first, identifies the glue vector, and deletes it.

### Evidence

All proposed closure properties fail at both radii:

| `r` | operation | positive inputs | failing output and inert spanning seed |
|---:|---|---|---|
| 2 | deletion | `(1,2,3,4,5)` lies in `P_2` | delete `1`; in `(2,3,4,5)`, seed mask `0111` spans all but no rule fires |
| 2 | duality | binary projective plane `(1,...,7)` lies in `P_2` | its dual fails on seed mask `0001011` |
| 2 | 2-sum | `(1,2,3)` with itself, both in `P_2` | sum `(2,3,8,9)` fails on `0111` |
| 3 | deletion | `(1,2,3,4,8,13)` lies in `P_3` | delete `1`; seed `01111` spans all but is inert |
| 3 | duality | `(1,...,9)` lies in `P_3` | its dual fails on seed mask `000101101` |
| 3 | 2-sum | `(1,2,3)` and `(1,2,4,7)`, both in `P_3` | sum `(2,3,8,16,25)` fails on `01111` |

Thus the WQO/excluded-minor route never reaches its antecedent. Even if some replacement class is
minor-closed, WQO gives existence of finitely many relative obstructions, not an explicit practical
linter until those obstructions and their recognition costs are supplied.

The review's weak-saturation identification also needs reformulation: minimum full-recovery seeds
are minimum contagious/percolating sets for the vertex Horn system. Classical weak saturation adds
edges while completing forbidden subgraphs. An exact equality requires an incidence construction;
it is not true by terminology alone.

### Decision

**KILL** the minor-closed, dual-closed, sum-closed, and finite-excluded-minor flagship. Preserve the
more modest classification of highly symmetric families (with C236 as positive and negative
anchors) and the bootstrap-percolation/minimum-contagious-set bridge. A future structural class
must be chosen because it survives the explicit witnesses, not because it has a powerful general
structure theorem.

## 4. Cascade replay

### Inputs and conventions

For the cubic family, C236 already proves `L_3(S)=cl(S)` for every seed. For a Bernoulli-`p` seed,
`S subseteq F` has probability `(1-p)^(|E|-|F|)`. Möbius inversion on the flat lattice therefore
gives

```text
Pr(L_3(S)=E) = sum_(F flat) mu(F,E) (1-p)^(|E|-|F|).
```

For fixed seed size `k`, the spanning count is

```text
sum_(F flat) mu(F,E) binom(|F|,k).
```

For the harmonic subsystem, condition on the nucleus and infinity already being active and retain
only blocks through infinity. Its rule on finite parameters is `{a,b} -> -a-b`.

### Evidence

The cubic formula agrees coefficientwise with an independent direct union-of-hyperplanes count:

- q=3: 53 flats, 20 hyperplanes, spanning counts
  `(0,0,0,0,49,52,28,8,1)`;
- q=9: 388 flats, 220 hyperplanes, with counts beginning
  `(0,0,0,0,3315,13152,36030,75300,...)` and ending `(...,1140,190,20,1)`.

The zero-sum subsystem equals affine span: translating one seed point to zero, closure under
`a,b -> -a-b` is exactly closure under the third point of every affine line over `F_3`, hence the
smallest affine subspace containing the seed. The certificate exhausts all 512 q=9 seeds and all
3,304 q=27 seeds of size at most three.

But this does not solve the full harmonic cascade. In the q=27 encoding, the proper affine plane
`{0,...,8}` contains the triple `(0,1,3)`, whose finite harmonic completion is `23`, outside the
plane. The non-infinity harmonic blocks can therefore escape the subgroup/affine lattice.

### Decision

**GO** for the cubic exact cascade law: it is a clean corollary theorem with explicit q=3/q=9
coefficients and an all-field formula parameterized by the flat lattice. **REFORMULATE** the harmonic
claim: affine generation is an exact subsystem lemma, not the full law. The next harmonic question
is how finite harmonic completions act on the affine-subspace lattice; the q=27 escape is its first
nontrivial transition.

## 5. Width-two boundary prototype

### Inputs and conventions

Let a represented ground set split as `E=L disjoint_union R`, with
`W=span(L) intersect span(R)`. For active helpers `A_i`, define the truncated pointwise interface
cost `c_i(w)` as the minimum support size of a linear combination of `A_i` equal to `w`, capped
above radius `r`. For a target `x in L`, define `c_(L,x)(w)` similarly after normalizing the
coefficient of `x` to one.

### Evidence

Every dependency through `x` splits at one vector `w in W`, so the exact minimum helper count is

```text
min_(w in W) [ c_(L,x)(w) + c_R(-w) ].
```

This is an elementary two-way linear-algebra argument: the two side sums of a global dependency
lie in the intersection, and conversely matching interface sums concatenate to a dependency.
Minimality is not required because `x in span(H)` always contains a circuit through `x` inside
`H union {x}`. Helpers are reusable facts, so no joint subspace-demand state is needed for ordinary
Horn closure.

The certificate tests the first genuinely two-dimensional binary interface
`W=<1,2>` with left columns `(4,5,6)` and right columns `(8,9,10)`. All 384 active-set/target cases
and 1,920 radius thresholds agree with direct global support minimization.

This is only the local composition lemma, not yet an FPT theorem. A full algorithm must compile the
finite response map from incoming interface profiles to outgoing profiles, combine it over a branch
decomposition, and keep C234's infinite delay expressions separate from finite terminal controls.
The established baseline is Hliněný's parse-tree computation for bounded-branchwidth represented
matroids ([DOI:10.1017/S0963548305007297](https://doi.org/10.1017/S0963548305007297)); decomposition
construction is already FPT and has newer direct algorithms
([arXiv:1711.01381](https://arxiv.org/abs/1711.01381)). A 2026 result improves represented-matroid
branch-decomposition construction to matrix-multiplication time plus a quadratic fixed-parameter
term ([arXiv:2605.14428](https://arxiv.org/abs/2605.14428)), so decomposition finding is not the
novelty target.

### Decision

**GO.** Promote the exact separator-vector convolution and a bounded-branchwidth terminal-closure
DP as the strongest next program. The theorem target is: for fixed `(r,w,q)`, terminal Horn closure,
stopping core, and the seed/core profile of a `GF(q)`-represented matroid are computable in
`f(r,w,q) poly(n)` from a width-`w` branch decomposition. Arrival times should be a separate
weighted-expression corollary, not silently included in the finite state. The falsifier is a
width-two pair with identical truncated vector-cost response maps but different terminal behavior
under some context.

## Promotion table

| Candidate program | Required positive evidence | Status |
|---|---|---|
| bounded-branchwidth algorithms | exact first beyond-2-sum boundary state and composition rule | **PROMOTE first** |
| peeling-optimality classification | stable closure property or a sharper replacement class | **do not promote**; original structure route killed |
| exact cascade laws | replayed cubic and/or harmonic theorem with probability formula | **PROMOTE cubic corollary; keep harmonic exploratory** |
| port-capacity converse | stable LRC gap attributable to port structure | **reformulate before promotion** |

## Reproducibility log

The deterministic certificate is
[`2026-07-17-c240-rp-next-gap-probes.py`](2026-07-17-c240-rp-next-gap-probes.py), with output
[`2026-07-17-c240-rp-next-gap-probes.json`](2026-07-17-c240-rp-next-gap-probes.json). Run:

```bash
python3 notes/2026-07-17-c240-rp-next-gap-probes.py
```

It checks 10,760 sampled pointed profiles, the explicit ULC counterexample, nine LRC comparison
points, six peeling-closure counterexamples, q=3/q=9 cubic Möbius identities, the harmonic affine
subsystem and q=27 escape, and 384 width-two interface states. No claim above depends on a random
seed not recorded in the JSON.

## Final disposition

C240 passes its gate. The best next paper route is the bounded-branchwidth terminal-closure theorem,
beginning from the exact separator-vector convolution proved here and stopping if contextual
equivalence needs more than the truncated pointwise response map. The cubic Möbius law is a cheap
paper-strengthening corollary. The original excluded-minor classification and ULC conjecture are
closed negatively; the harmonic and port-capacity programs survive only in narrower forms.
