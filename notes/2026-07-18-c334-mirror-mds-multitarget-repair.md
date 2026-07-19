# C334: mirror-conic MDS and multi-target service

**Date:** 2026-07-19
**Lane:** `crowns`
**Verdict:** **BOUNDED NEGATIVE FOR NOVELTY; EXACT EXTERNAL-TARGET CAPACITY AND MIXED-TARGET INNER REGION**

## Result

Let \(\mathcal O\subset PG(2,q)\) be an oval of even size \(n\), let its columns generate an
`[n,3,n-2]_q` MDS code, and choose off-oval projective points as requested linear objects. A secant
through a target gives a minimal two-server recovery set. With unit helper capacities:

1. An internal target has exact one-object service capacity \(n/2\).
2. When `q` is odd, an external target has exact one-object service capacity
   \((n-1)/2\). For a conic, where \(n=q+1\), this is \(q/2\).
3. For any finite list of internal and external requested linear objects, including a list longer
   than the code dimension, the generalized function-service region contains

   \[
   \left\{\lambda\ge0:\ \sum_i\frac{\lambda_i}{M_i}\le1\right\},\qquad
   M_i=\begin{cases}n/2,&i\text{ internal},\\(n-1)/2,&i\text{ external}.\end{cases}
   \]

   For three independent targets this is an ordinary MDS service-rate statement, not a repair
   analogy.
4. Among zero-systematic maximum-length dimension-three MDS matrices, the full simplex
   `Delta_3(n/2)` occurs exactly when all three basis targets are internal.

For C294's four centres `S_b`, the two centres with `rc=0` are external, while the other two both
have `rc=b` and therefore have the same internal/external type. The type pattern is consequently
either `E,E,E,E` or `E,E,I,I`; every three-centre subset is independent but contains an external
target. Its weighted simplex is therefore explicit, but no three-object restriction attains the
all-internal oval optimum.

## Proof of the external-target capacity

Let `a,b` be the two tangent contacts from an external point and put `m=(n-2)/2`. The two-helper
recovery sets are the `m` secant pairs partitioning `O minus {a,b}`. Every other minimal recovery
set has size three. Split the total rates assigned to triples according to whether they contain
zero, one, or two tangent contacts, writing these rates as `y0,y1,y2`, and let `X` be the rate on
secant pairs. Capacity on the `n-2=2m` ordinary oval points gives

\[
2X+3y_0+2y_1+y_2\le 2m,
\]

while tangent capacity gives `y1+2y2 <= 2`, hence `y2 <= 1`. Therefore

\[
X+y_0+y_1+y_2\le m-\frac{y_0}{2}+\frac{y_2}{2}\le m+\frac12=\frac{n-1}{2}.
\]

This is attained. Give every triple `{a,b,u}`, for `u` an ordinary oval point, weight
`1/(n-2)`, and give every secant pair weight `1-1/(n-2)`. Each helper then has load one and the
served rate is `m-1/2+1=m+1/2`. For an internal point, the secants themselves partition the oval,
giving rate `n/2`; the universal two-helper work bound proves optimality.

Each displayed axis-optimal allocation saturates every helper. Scaling the allocation for target
`i` by `lambda_i/M_i` and superposing the scaled allocations proves the weighted simplex. It also
shows why the four-centre union needs no game-valued or repair-language identification to enter the
fractional-matching model: its labelled recovery hypergraph is the model.

## Comparison and bounded negative

Di Giusto, Ravagnani, and Soljanin's 2026 preprint
[*The Oval Strikes Back*](https://arxiv.org/abs/2601.16628) proves the stronger all-internal
construction: three independent internal points give the exact region `Delta_3(n/2)`, and for
`q>=11` it strictly contains the region of a systematic generator matrix of the same code. It also
derives PIR and one-step majority-logic decoding consequences. Thus the broad oval-to-SRR bridge,
the two-helper partition mechanism, and systematic-region domination are prior art.

The C294 `S_b` family is strictly weaker for homogeneous fractional service: every target triple
contains an external point, whose exact axis intercept is `(n-1)/2<n/2`. The special mirror,
full-`PGL_2`, and Node--Kayles properties do not improve the Ly--Soljanin fractional feasibility
metric. They describe relations among the coloured matchings which uniform fractional allocation
does not see.

There is still a valid but pre-empted systematic comparison. The weighted inner region contains
the ordinary simplex of radius `(n-1)/2`. A fully systematic `[n,3]` MDS matrix has service region
inside the simplex of radius `3+(n-3)/3=(n+6)/3`; hence the `S_b` inner region contains that entire
systematic region for `n>=15`. This is weaker than the 2026 theorem's radius `n/2` and threshold
`q>=11`, so it is not a defensible new operational tradeoff.

This closes C334 negatively at its stated novelty gate. It does **not** claim the exact full
mixed-target polytope, an integral batch schedule, a failure-robust optimum, or a repair theorem
from C298's collision matching.

## Progress on the highest-EV continuations

The literature boundary and the proofs above reduce the promising continuations to concrete
problems rather than broad analogies.

1. **Exact mixed internal/external SRR.** Determine the remaining facets between the proved
   weighted simplex and the universal two-helper simplex. For `S_b`, exploit the disjoint tangent
   sets of its first two external involutions and the common type of its last two. The exact
   external axis `(n-1)/2` and the saturating allocation above are the first boundary data.
2. **Integral scheduling and batch/PIR gap.** Fractional schedules erase the interaction among
   the superposed matchings. With indivisible requests, the problem becomes a coloured matching
   quota problem in the union of the projection involutions. Classify its integer points, integer
   decomposition property, and rounding loss. This is the most plausible place for the mirror or
   generated-group structure to have operational content.
3. **Failures and heterogeneous helper capacities.** For a deleted helper set `E`, let `h_i(E)`
   be the number of intact secant pairs for target `i`. Uniform allocation on intact pairs proves
   the deterministic region `sum_i lambda_i/h_i(E) <= 1`; in particular
   `h_i(E) >= m_i-|E|`. Exact robust regions, optimal use of tangent triples, and stochastic
   reliability under correlated failures remain open. This is the proper gate before importing
   C298: its collision matching must first be shown to control these `h_i(E)` or a named facet.
4. **Dependent-function service.** The four `S_b` centres are four requested linear functions in
   a three-dimensional object space. Formalize the `r>k` function-service model, decide when the
   weighted simplex is exact, and compare its integral version with functional batch/PIR codes.
5. **Higher-dimensional extremizers.** Replace ovals by normal rational curves or caps in
   `PG(k-1,q)` and seek bases outside the carrier whose small secant flats partition the servers.
   The precise target is an analogue of the internal-point classification, not merely another
   arc--MDS translation.

The first and third paths are the best applied EV; the second has the best chance of making the
special `S_b` superposition matter. The fourth and fifth are higher-upside but require a fresh
literature gate.

## Literature boundary

- [Ly--Soljanin, *Service Rate Regions of MDS Codes & Fractional Matchings in Quasi-uniform
  Hypergraphs*](https://arxiv.org/abs/2504.17244) supplies the labelled recovery-hypergraph model
  and the systematic-column comparison for its size-`1`/`k` recovery class.
- [Alfarano--Kilic--Ravagnani--Soljanin, *The Service Rate Region
  Polytope*](https://arxiv.org/abs/2303.04021) explicitly separates MDS matrices that admit recovery
  from fewer than `k` servers from the previously characterized non-systematic class.
- [Alfarano--Ravagnani--Soljanin, *Dual-Code Bounds on Multiple Concurrent (Local) Data
  Recovery*](https://arxiv.org/abs/2201.07503) gives the general recovery-system and concurrent
  access boundary.
- [Ly--Soljanin, *Maximal Achievable Service Rates of Codes and Connections to Combinatorial
  Designs*](https://arxiv.org/abs/2506.16983) relates axial service limits to dual checks and
  majority-logic designs.
- [Kazemi--Karimi--Soljanin--Sprintson, *A Combinatorial View of the Service Rates of Codes
  Problem*](https://arxiv.org/abs/2001.09146) establishes the fractional-matching and batch-code
  connection.
- [Di Giusto--Ravagnani--Soljanin, *The Oval Strikes
  Back*](https://arxiv.org/abs/2601.16628) is the load-bearing pre-emption and the source of the
  explicit future-work call for other MDS matrices and incidence structures beyond ovals/arcs.

A targeted title/identifier and forward search through 2026-07-19 found no follow-up resolving the
mixed-type, heterogeneous-capacity, or integral coloured-matching questions. This is a focused
search boundary, not a MathSciNet/zbMATH absence claim.

## Source integrity and evidence boundary

The load-bearing full texts are in the shared literature cache:

| key | bytes | pages | SHA-256 |
|:--|--:|--:|:--|
| `arXiv:2201.07503` | 329843 | 12 | `75dfdc9b233c2f091e987790b6cff029551b59d0289d85f0b9b3d8b30a712bbc` |
| `arXiv:2303.04021` | 325337 | 27 | `ffc9a8edbd513ad70b3336b27dd5fc475e4b4dad4665c10aed7c2794becffce4` |
| `arXiv:2504.17244` | 578610 | 40 | `3943e2b5ba2a1bc0a84b5c62bc7f5f7d1c6d3551fbff4b91f4fd1b8290eb2700` |
| `arXiv:2506.16983` | 327623 | 8 | `37b975a07ec877e73c63aa111aaf4286e644697254b965c4a11345e41d00ac2a` |
| `arXiv:2601.16628` | 294274 | 6 | `ab80a873ecf39ca7c130252d78eb07f2e2aa8b966f465e7f44dbdb3c9bf6871b` |

The new results are coordinate-free deductions from oval incidence and linear capacity constraints;
they use no computational certificate. They certify axial capacity and an achievable inner region,
not the complete mixed-target SRR or any queueing-delay law.
