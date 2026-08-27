# C962 — Exact recovery algorithms, derived bounds, and competitor assessment

**Lane**: `complete-ports`

**Status**: IN PROGRESS; PRIVATE CODE AND MATHEMATICS ONLY; 76 PYTHON TESTS
PLUS 135 RUST UNIT/CLI/PROPERTY/PARITY TESTS PASS; NO
MANUSCRIPT, STANDALONE-MIRROR, PUSH, OR DEPOSIT CHANGE; CODE
COMMIT HELD BY USER

## Scope and current verdict

C962 develops the latent algorithmic consequences of the exact recovery-cost
theory under `papers/complete-repair-ports/algorithms/`.  The suite is a
dependency-free Python reference implementation with exact arithmetic,
independent small-case oracles, deterministic operation counts, and a canonical
evidence generator.  It is intentionally absent from the paper distribution
manifest.

The nearest-competitor review currently contains **one source marked full
text** and eleven sources marked partial.  The comparisons below are therefore
technical positioning, not a priority or absence verdict.  No claim that an
algorithm is the first of its kind is licensed by this review.

The strongest outcomes are:

1. prescribed-coset cost depends only on the image subspace of its matrix label:
   a demand-independent generated-span table replaces both lift enumeration and
   the larger matrix-state DP, with the latter two retained as independent
   oracles;
2. the exact confinement cost has two complementary algorithms: enumeration in
   a generator description of the outer functional dual and a weighted syndrome
   trellis in a constraint description;
3. the sharp one-level cost envelopes iterate multiplicatively, giving a cheap
   tower screen before exact labelled substitution;
4. the entire projective-simplex reliability hierarchy can be evaluated from
   one `O(m^2)`-summand exact-span pass, rather than one failure-subset sweep per
   recovered rank; the underlying projective-geometry Tutte/coboundary formula
   is classical, while the contribution here is its recovery-profile
   specialization and shared evaluation; and
5. graph-code target identifications can be searched to improve the additive
   confinement term without changing the relative-weight hierarchy.

The important negative findings are:

- coordinate min-sum is an instance of the generalized distributive law, not a
  new generic inference algorithm;
- the bundled RGHW subset enumerator is a small-case oracle and is not
  competitive with San-José's Brouwer--Zimmermann algorithm and Sage package;
- the service-rate code constructs the transferred LP but does not supersede
  water-filling, greedy-matching, or code-family-specific SRR algorithms; and
- the graph-code identification search is not the full ambient
  coefficient-presentation spectrum owned by C955.

## 1. Prescribed-coset dynamic programming

Let `phi : F_q^n -> F_q^k`, let `T=F_q^t`, and write `phi_i` for the `i`th
column.  For `b:T->F_q^k`, define

```text
Lambda_phi,T(b) = min { number of nonzero rows of Y : phi Y = b }.
```

For the first `i` coordinates, put

```text
D_i(b) = min { row-support(Y) : phi_[1..i] Y = b }.
```

Then

```text
D_0(0)=0,
D_0(b)=infinity for b != 0,
D_i(b)=min_{r in F_q^t} D_(i-1)(b-phi_i r) + [r != 0].       (A1)
```

### Correctness

Partition a lift by its last row `r`.  Its prescribed image is the previous
image plus the outer product `phi_i r`, and its union support increases exactly
when `r` is nonzero.  Conversely, every choice in (A1) appends one row to a
previous lift.  Induction on `i` proves `D_n=Lambda_phi,T`.

### Complexity

There are at most `q^(kt)` labels and `q^t` row choices at each of `n`
coordinates, giving the unsimplified bound

```text
time   O(n q^((k+1)t)),
memory O(q^(kt)),                                      (A2)
```

finite-field operations.  A stronger preprocessing bound follows from a latent
invariance.  Delete every zero column and retain one normalized representative
of each projective class of nonzero columns.  If columns `v` and `a v` are
proportional, their two row contributions are

```text
v r_1 + a v r_2 = v(r_1+a r_2).
```

The combined contribution can therefore be placed on one of the two
coordinates, with support cost zero when the aggregate row is zero and one
otherwise, never exceeding the original cost.  The reverse inequality follows
by realizing the retained representative on an original coordinate.  Hence the
complete cost table is unchanged.

Writing `r=rank(phi)`, at most `(q^r-1)/(q-1)` projective column classes and
`q^(rt)` reachable labels remain.  The implemented simplified recurrence uses

```text
time   O(nk) + O(((q^r-1)/(q-1)) q^((r+1)t)),
memory O(q^(rt)).                                      (A2')
```

Direct lift enumeration still uses `q^(nt)` candidates.  Thus, for fixed
`(q,r,t)`, the exact optimization after the linear scan is independent of the
original helper length.  This elementary simplification is a structural
specialization, not a novelty claim about generic trellis inference.

### Stronger generated-span representation

The matrix label contains more information than the objective uses.  For every
`b:T->F_q^k`,

```text
Lambda_phi,T(b) = min { dim W : image(b) <= W,
                                W=span(phi_i : i in H) for some H }.  (A2'')
```

Indeed, a lift supported on `H` places `image(b)` inside the column span `W_H`
and `dim W_H<=|H|`.  Conversely, choose a column basis of any generated `W`
containing `image(b)`; solving the columns of `b` in that basis gives a lift
with exactly `dim W` available support rows.  Taking minima proves (A2'').

Consequences:

- `Lambda_phi,T(b)` depends only on `image(b)`, hence is invariant under a
  change of basis on `T`;
- every finite value is at most `rank(phi)`, a stronger universal upper bound
  than the original helper length; and
- the compact cost object is independent of `t` and can be reused across all
  recovered ranks.

Let `P` be the number of nonzero projective column classes and `F` the number of
distinct subspaces generated by their subsets.  Closure enumeration stores
canonical reduced-row-echelon bases and uses `O(PF)` span insertions, up to
row-reduction factors, with

```text
P <= (q^r-1)/(q-1),
F <= sum_(j=0)^r [r choose j]_q.                       (A2''')
```

Expanding to every attainable `k x t` oriented label examines
`sum_W q^(dim(W)t)` matrices over generated spans `W`, resolving duplicates in
increasing dimension.  Callers that need only selected labels query the compact
table directly and avoid expansion.  The original row-state recurrence (A1)
and full lifts remain separate test oracles.

## 2. Exact labelled composition and tower screening

For outer block maps `A_e:F_q^ell->F_q^m` and a table `Lambda_B`, the code uses

```text
D_i(c)=min_x D_(i-1)(c-A_i x)+Lambda_B(x).              (A3)
```

This is exactly the paper's min-sum substitution.  If `S_B` labelled inner maps
are attainable, its direct bound is `O(N q^(mt) S_B)` time and `O(q^(mt))`
memory.  A junction-tree or minimal-trellis implementation may improve on the
displayed block order; associativity guarantees that reparenthesization does not
change the answer.

For prescribed-coset tables, exact composition admits the same projective
compression at block level.  Such a table has `Lambda(0)=0`, is homogeneous
under nonzero scalars, and is subadditive.  If two outer maps are `A` and `aA`,
then

```text
A x + a A y = A(x+a y),
Lambda(x+a y) <= Lambda(x)+Lambda(y).                  (A3')
```

Thus one proportional block can realize every joint contribution at no greater
cost, while the reverse simulation sets the deleted block to zero.  Zero outer
blocks are similarly irrelevant.  The implementation records
homogeneous/subadditive provenance in `CostTable` and performs this compression
only when certified; translated target costs deliberately lack the flag.  If
`P_A` projective outer-block classes remain, `N` in the displayed composition
bound can be replaced by `P_A`.

The projective rule is the scalar case of a contraction preorder.  Call a
linear endomorphism `S` of the inner label space a cost contraction when

```text
Lambda(Sx) <= Lambda(x) for every attainable x.          (A3'')
```

If `B=A S`, then `A x+B y=A(x+S y)` and subadditivity plus (A3'') allow block
`B` to be deleted exactly.  This relation is transitive under composition of
contractions.  The bounded implementation enumerates all `S`, forms the block
preorder, collapses equivalent blocks, and keeps its maximal classes.  The
search costs `q^(ell^2)` candidate endomorphisms before label checks, so it is
optional and intended only for small `ell` or amortized repeated execution.

There is an even cheaper route when explicit homogeneous matrices, rather than
only their cost tables, are available.  Construct the direct composite matrix,
projectively simplify its columns, and run the generated-span algorithm once.
This “compose first, optimize once” path avoids the intermediate oriented label
table.  It does not replace labelled substitution for heterogeneous inner maps,
target-translated costs, or black-box cost tables.

If every nonzero inner label costs between `delta_i` and `R_i` at level `i`,
iteration of the sharp one-level envelope gives

```text
(product_i delta_i) Lambda_outer(c)
    <= Lambda_tower(c)
    <= (product_i R_i) Lambda_outer(c).                 (A4)
```

### Proof of (A4)

Apply the one-level inequality at the innermost substitution.  Its lower and
upper scalar factors are positive and independent of the outer lift.  Pull them
through the next minimum and repeat.  Induction on tower depth gives (A4).
Sharpness at one level does not imply simultaneous sharpness of both products
for a fixed tower; (A4) is a screening envelope, not a claim that every endpoint
is attained.

The useful workflow is:

1. propagate the products in (A4);
2. reject a candidate if its upper screen is already inadequate;
3. accept it if its lower screen already clears the required cost; and
4. run exact labelled substitution only in the unresolved interval.

## 3. Target-normalized composition

The target-normalized dynamic program retains a pair of labels:

```text
(accumulated target image, accumulated total image).
```

At block `e`, it enumerates `u_e:T->U_(P_e)` and a helper contribution `z_e`,
sets `x_e=u_e+z_e`, and charges `Lambda_(J_e)(z_e)`.  The terminal state is
`(inclusion_T,c)`.  This is a direct algorithm for formula (C6).

If the target image has dimension `a_e`, a worst-case block transition examines
`q^(a_e t) S_(J_e)` local pairs.  The paired syndrome state has at most
`q^(2mt)` values.  This bound is intentionally coarse: reachable-state pruning
is substantial in the finite tests, and a factor-graph implementation should
use the actual target-image and helper-map ranks.

The independent oracle enumerates raw target coefficients and raw helper
coefficients, rather than calling the paired-state recurrence.

## 4. Two exact algorithms for the finite confinement cost

Let the outer functional dual have dimension `d` inside `(F_q^k)^N`, and let
`t=dim T`.

### Generator enumeration

Enumerate the `q^(dt)` maps `T -> FD(O)`.  For every nonzero map, split it into
block labels and add one target cost `mu` and `N-1` ordinary costs `Lambda`.
Compare the minimum with the zero-functional cost
`mu(0)+d(I^perp)`.  This is best when `d` is small.

### Weighted syndrome trellis

If block matrices `C_h:F_q^k->F_q^r` describe the same functional dual by

```text
FD(O) = { (B_h) : sum_h C_h B_h = 0 },
```

process the blocks while retaining the accumulated `r x t` syndrome and one
Boolean recording whether a nonzero label has occurred.  The recurrence is

```text
E_i(s,epsilon)=min_B E_(i-1)(s-C_i B, epsilon or [B!=0])
                         + local_cost_i(B).              (A5)
```

The required nonzero sector is `E_N(0,true)`.  This uses at most

```text
time   O(N q^((r+k)t)),
memory O(q^(rt)).                                       (A6)
```

It is best when the constraint-state dimension `r` or, more generally, a
minimal sectional trellis width is small.  The implementation exposes both
descriptions rather than asserting that one dominates the other.

The automatic planner compares `q^(dt)-1` generator candidates with the
syndrome state's explicit transition bound and runs the smaller estimated
method.  This is a safe planning choice because both methods are exact; it is a
cost heuristic, not a claim that either bound predicts wall time perfectly.

### Correctness

The proof is the same prefix decomposition as (A1): every functional tuple has
a unique last block label; syndrome and nonzeroness are sufficient prefix state;
and disjoint blocks make the cost additive.  The terminal zero syndrome enforces
membership in the functional dual, while the Boolean separates the two sectors.

## 5. Rank-one certification of every recovered rank

For any nonconfined map on a nonzero target space `T`, some external block map is
nonzero on a vector `u`.  Restriction to the line generated by `u` remains
nonconfined, and deleting columns of a lift cannot enlarge its helper union.
Therefore the least obstruction over all nonzero target subspaces is attained at
rank one.

Algorithmically, simultaneous preservation at every recovered rank needs only
the rank-one exact confinement computation.  The test suite exhausts all binary
`5 x 3` lift matrices and checks the support monotonicity for every nonzero
column restriction.  This is an exhaustive finite check of the implementation
invariant, not the proof.

## 6. Relative weights and best-target bounds

The reference suite computes the relative dimension/length profile from

```text
dim(C intersect F_q^H) = dim C - rank(C restricted to H-complement).  (A7)
```

It enumerates helper subsets and inverts the profile to obtain the relative
weights.  This is deliberately an oracle implementation with `O(2^n)` subset
dependence.

For an `e`-set `P`, the direct cooperative helper checker enumerates `H` and
tests

```text
dim(C^perp intersect F_q^(P union H))
 - dim(C^perp intersect F_q^H) = e.                     (A8)
```

The test suite verifies

```text
min_|P|=e kappa_C(P) = d_e(C^perp)-e                  (A9)
```

for every systematic binary row-space presentation of dimensions two and three
at length five, and every admissible `e`.

Production RGHW computation should call San-José's Brouwer--Zimmermann algorithm
or a family-specific formula.  The present subset routine remains valuable as a
small, independent checker with no Sage dependency.

## 7. Graph-code identification search

Fix a row basis of `K` and quotient representatives `Q` for `D/K`, with quotient
dimension `ell`.  For every `A in GL(ell,q)`, the code evaluates the graph
presentation

```text
(k_coeff,q_coeff) -> (A q_coeff, k_coeff K + q_coeff Q)
```

and its minimum nonzero total weight.  The relative weights stay fixed, while
the additive confinement term changes with this minimum distance.  Exhaustive
work is

```text
|GL(ell,q)| q^(dim K + ell)
```

word evaluations, up to linear-algebra factors.

For the paper's binary pair `0 < span(100,011)`, the six identifications split
as four of dual distance two and two of dual distance three.  The best thresholds
are `(4,6)`, reproducing the separation example.

This search varies the target identification inside one graph-code construction.
It does **not** enumerate all ambient extensions, target lengths, or coefficient
presentations.  Those are the mathematical content of queued C955.

## 8. Projective reliability algorithms

For the projective-simplex family, let `N_v=(q^v-1)/(q-1)`.  The exact-span
polynomial for failed sets spanning a fixed `u`-space is obtained by subspace
Möbius inversion.  Multiplying by the Gaussian number of `u`-spaces gives

```text
A_u(s) = [m choose u]_q sum_(v=0)^u [u choose v]_q
         (-1)^(u-v) q^binom(u-v,2) s^(N-N_v).           (A10)
```

Then

```text
R_t(s) = sum_(u=0)^(m-t) A_u(s).                       (A11)
```

Compute every `A_u` once, form prefix sums, and read every `R_t` from the
appropriate prefix.  Across all `u`, (A10) contains
`sum_(u=0)^(m-1)(u+1)=m(m+1)/2` exact summands.  Thus the complete hierarchy
uses `O(m^2)` arithmetic operations on growing integers, compared with `2^N`
failure subsets for direct enumeration.  This is an arithmetic-operation count;
bit complexity grows with the coefficient sizes.  Formula (A10) is a
specialization of the classical coboundary-polynomial formula for projective
geometries, not a new projective-geometry Tutte formula.  C962's algorithmic
addition is to compute the exact-span pieces once and prefix them to produce all
recovered-rank reliability polynomials together.

The budget inverse is the largest `t` satisfying

```text
(q^m-q^(m-t))/(q-1) <= s.                              (A12)
```

The implementation uses monotone integer comparison, avoiding logarithmic
rounding.

## 9. Bounded service-rate LP reduction

For each demand, the code removes nonminimal recovery supports and constructs
the usual fractional-allocation LP incidence matrices.  Under the confinement
gate, zero-extension shifts the active helper rows into the selected block and
leaves all external rows zero.  The number of flow variables and active capacity
constraints is therefore the inner problem size, independent of the number of
outer blocks.

The data structure now realizes that bound: it stores only active
`(helper_index, incidence_row)` pairs.  External zero rows are implicit under
zero-extension, so memory is `O(aV+DV)` for `a` active helpers, `D` demands, and
`V` flow variables, rather than `O(NV)` for `N` global helper coordinates.  A
dense helper matrix is available only as an explicit compatibility/debug view.

This does not solve the inner SRR problem.  It removes the concatenation blowup
before applying a general LP solver or a stronger structured method such as
water-filling or greedy matching.

## 10. Representation-level shortcuts

The code now makes the following exact, semantics-preserving choices:

1. Canonical RREF tuples key generated subspaces.  Matrix labels are expanded
   only at composition interfaces where relative target orientation matters.
2. Every block contribution (`phi_i r`, `A_i x`, paired target/total increments,
   and syndrome increments) is precomputed once per local choice rather than
   remultiplied for every reachable state.
3. Homogeneous/subadditive provenance is explicit metadata, allowing safe
   projective deduplication of ordinary composition blocks while preventing the
   optimization from leaking into translated target costs.
4. Target-image generators are replaced by canonical column-space bases, and
   syndrome constraints by canonical row-space bases, before enumeration.  This
   removes duplicate local maps and redundant trellis dimensions caused solely
   by presentation.
5. Binary rank checks pack rows into Python integers and use pivot-bit XOR
   elimination.  The direct projective oracle exercises this path and compares
   it exhaustively with ordinary matrix rank.
6. The all-rank projective pass precomputes a `q`-Pascal triangle, projective
   sizes by `N_(v+1)=q N_v+1`, and Möbius factors by
   `mu_(d+1)=-q^d mu_d`.  This makes the implementation match the claimed
   quadratic number of arithmetic terms instead of recomputing Gaussian
   products inside the nested sum.
7. Binary budget inversion uses `(residual-1).bit_length()` for exact ceiling
   logarithms; other fields use integer binary search, with no floating point.
8. Service supports use arbitrary-width integer bit masks, so minimality is the
   subset test `a & b == a`, and only active helper-incidence rows are stored;
   graph identifications are generated by extending independent row tuples,
   avoiding enumeration and rejection of all singular matrices.

One tempting compression is invalid and is deliberately absent.  Ordinary
local costs are invariant under precomposition by `GL(T)`, but the distinguished
target term is `mu(B)=Lambda(B-iota_T)`.  In general
`mu(BA) != mu(B)` because the fixed normalization `iota_T` does not transform.
Thus the full confinement generator search cannot be quotiented merely by the
image subspace of the functional map; only the ordinary prescribed-coset table
admits that quotient.  This is precisely why the target-aware pair/syndrome
representations must retain orientation.

### Tao and Lemire lenses

The `tt` pass reframes ordinary prescribed cost as a monotone gauge on image
subspaces and exact composition as pushforward infimal convolution.  This is
what exposed both the contraction preorder (A3'') and the compose-first path.
It also suggests a sharper, still-open hierarchy: replace scalar tower extrema
by rank- or flat-indexed envelopes and propagate them through the maps.  That
could screen more towers than (A4), but no correctness/complexity advantage has
yet been proved over exact generated-span composition, so it is not implemented.

The Lemire pass separates an auditable oracle from a throughput backend.  The
current immutable tuples, canonical RREFs, and sparse dictionaries make proofs
and cross-checks visible.  A production binary backend should instead use
packed columns, XOR kernels, `bit_count`, contiguous integer state IDs,
preallocated arrays for dense regimes, and sparse hash tables only below a
measured occupancy threshold.  It should benchmark planning separately from
execution and report allocations as well as time.

`benchmark_algorithms.py` provides that separation at the Python level: warmup,
minimum and median nanoseconds, a separate peak-`tracemalloc` pass, checksums,
and distinct dominance-planning/planned-execution measurements.  A smoke run
showed why the separation matters: on the tiny contraction example, planning
cost more than one unsimplified execution even though retained-block execution
was cheaper.  Thus exhaustive dominance search is an amortized optimization,
not a default fast path.  These local timings are deliberately excluded from
canonical evidence and license no cross-language or SOTA performance claim.

## 11. Nearest competitors and current SOTA assessment

Assessment date: 2026-08-25.  “Advantage” below means a difference in scope or
structure supported by the stated formulas; it never means an unmeasured
wall-clock superiority.

| Application | Nearest competitor/SOTA | Assessment of C962 |
|---|---|---|
| finite-state coset costs | Aji--McEliece generalized distributive law; classical syndrome/trellis decoding; Montina's output-sensitive flat enumeration | The generic row-state DP is not new relative to GDL.  The stronger C962 representation identifies the value with the least dimension of a column-generated span containing `image(b)`, yielding a demand-independent compact table and the bound `Lambda<=rank(phi)`.  Enumerating the generated spans is a represented-matroid flat computation; Montina gives a general output-sensitive vector-matroid algorithm.  C962's useful part is the recovery-cost identity and compact query interface, not flat-enumeration priority. |
| repeated concatenation | Guruswami--Sudan soft concatenated decoding; Blomqvist--Gnilke--Greferath generalized-concatenated and matrix-product decoding | Those algorithms decode received words and exploit reliability weights or bounded-distance component decoders.  C962 computes an offline structural recovery/nonconfinement invariant.  No decoding-speed comparison is meaningful. |
| exact finite confinement | coset-leader enumeration plus general min-sum/junction-tree inference | No direct predecessor for this target-normalized functional-dual objective was identified in the bounded search, but the component algorithms are standard inference machinery.  A minimal trellis or optimized junction tree is the production SOTA; C962 supplies generator and syndrome baselines. |
| RGHW computation | San-José 2025 Brouwer--Zimmermann algorithm and Sage `GHWs` package | C962 loses decisively for nontrivial general instances.  Keep its `2^n` routine only as an independent oracle and interface production runs to `GHWs`. |
| concatenated/matrix-product bounds | San-José's bounds for GHWs of matrix-product codes | The invariants differ: C962 bounds labelled prescribed-coset costs, whereas the competitor bounds subcode support minima.  The tower envelope is cheaper but less informative than exact labelled substitution. |
| graph-presentation optimization | support-constrained generator-matrix design; representation-sensitive SRR design | C962 gives exhaustive small-`ell` search and a verified separation, not a structural optimizer.  The 2026 SRR literature still treats optimal generator choice as open in its own model.  C955 owns the broader mathematics here. |
| projective reliability | the classical projective-geometry coboundary/Tutte formula summarized by Merino--Ramírez-Ibáñez--Rodríguez-Sánchez; general linear-matroid Tutte computation | The base formula is prior art.  C962 repackages it as exact recovered-rank reliability and shares the exact-span computation across the full hierarchy in quadratic many summands.  Its demonstrated advantage is over failure-subset enumeration and generic matroid computation, not over the classical projective formula. |
| service-rate regions | Aktaş et al. LP/water-filling; Ly--Soljanin fractional matching and Greedy Matching; 2025--2026 design bounds | C962 is complementary: it proves and realizes a preprocessing reduction from the large concatenated instance to the inner recovery hypergraph.  It should feed, not replace, those SRR algorithms. |

## 12. Literature record

Every source named in the comparison carries a read-depth marker.  Cached hashes
identify the exact bytes consulted.

1. Aji and McEliece, *The Generalized Distributive Law*. **Read depth: partial**;
   published PDF, introduction and Sections III and V on junction-tree message
   passing, scheduling, and arithmetic complexity. Cache key
   `10.1109/18.825794`, SHA-256
   `6aed6b53e9c21951f801b4bac509db26c6a68b65aa26c5a1de690cff0277779a`.
2. Guruswami and Sudan, *Decoding Concatenated Codes Using Soft Information*.
   **Read depth: partial**; conference PDF, abstract, introduction, coset-weight
   positioning, and Section 4 algorithm statement. Cache key
   `10.1109/CCC.2002.1004350`, SHA-256
   `9de8a233c00ce45aea3db34023727a3f564c1ce8760c0e96452c3afe93407865`.
3. Blomqvist, Gnilke, and Greferath, *On Decoding of Generalized Concatenated
   Codes and Matrix-Product Codes*. **Read depth: partial**; arXiv v1,
   introduction and Sections VII--IX on decoder structure and invocation bounds.
   Cache key `arXiv:2004.03538`, SHA-256
   `77096b0638c851a7aad9aaff4b48c091cc5de04a5357913bfaa284080bbd1974`.
4. San-José, *An Algorithm for Computing Generalized Hamming Weights and the
   Sage Package GHWs*. **Read depth: partial**; arXiv version cached 2026-08-22,
   Sections 3--4 and 6--7 on the Brouwer--Zimmermann recurrence, RGHW adaptation,
   correctness tests, and performance comparison. Cache key
   `arXiv:2503.17764`, SHA-256
   `98bebce176b7f711a90f6a2ba0224dd77e4883eb0939c8aca237d571e9d1654b`.
5. San-José, *About the Generalized Hamming Weights of Matrix-Product Codes*.
   **Read depth: partial**; arXiv v2, abstract, introduction, theorem overview,
   and the two-constituent lower-bound mechanism in Section 3. Cache key
   `arXiv:2407.11810`, SHA-256
   `44afecfb0c3c68056cf6ab8b34198a4e0bf1acd736b0560f027082594a163f90`.
6. Björklund and Kaski, *The Fine-Grained Complexity of Computing the Tutte
   Polynomial of a Linear Matroid*. **Read depth: partial**; arXiv v2, abstract,
   Sections 1.1--1.3 and algorithm-result statements. Cache key
   `arXiv:2003.03595`, SHA-256
   `0de06472e5a6861b049f0ab82a2d49398575942e0aff732afff3d992201aeef6`.
7. Aktaş, Joshi, Kadhe, Kazemi, and Soljanin, *Service Rate Region: A New Aspect
   of Coded Distributed System Design*. **Read depth: partial**; arXiv version,
   Sections III and V on the LP, MDS water-filling, and Simplex recovery graph.
   Cache key `arXiv:2009.01598`, SHA-256
   `35325300b0e98e951ab362a3ab3ada74f344b0008c99db27d68f3872a5aaed5f`.
8. Ly and Soljanin, *Service Rate Regions of MDS Codes and Fractional Matchings
   in Quasi-uniform Hypergraphs*. **Read depth: partial**; arXiv v2, abstract,
   introduction, Greedy Matching theorem and complexity discussion, conclusion.
   Cache key `arXiv:2504.17244`, SHA-256
   `3943e2b5ba2a1bc0a84b5c62bc7f5f7d1c6d3551fbff4b91f4fd1b8290eb2700`.
9. Ly and Soljanin, *Maximal Achievable Service Rates of Codes and Connections
   to Combinatorial Designs*. **Read depth: partial**; arXiv v3, abstract,
   introduction, main general bound, and systematic-code specialization. Cache
   key `arXiv:2506.16983`, SHA-256
   `37b975a07ec877e73c63aa111aaf4286e644697254b965c4a11345e41d00ac2a`.
10. Choudhary, Yadav, and Bhaintwal, *Maximal Achievable Service Rates of Some
    Classes of Linear Codes*. **Read depth: partial**; arXiv v1, abstract,
    introduction, BIBD bound statement, and final open generator-choice problem.
    Cache key `arXiv:2608.05657`, SHA-256
    `924083acbe565988992ce323ce81d56a4d9099906de6b5df029fc2b88690e1c1`.
11. Merino, Ramírez-Ibáñez, and Rodríguez-Sánchez, *The Tutte Polynomial of Some
    Matroids*. **Read depth: partial**; arXiv preprint, Section 3.1 on the
    coboundary/Tutte conversion and the projective-geometries subsection,
    especially formula (33).  The survey explicitly reports that the
    projective formula was already known and follows Mphako, so C962 does not
    claim it as new. Cache key `arXiv:1203.0090`, SHA-256
    `26326bbb5408e87e9f7abf8cc2419215cd90478df6b9d73bed3ee0ba1f7d7ff4`.
12. Montina, *Output-sensitive algorithm for generating the flats of a matroid*.
    **Read depth: full text**; arXiv v1, all Sections 1--5, including the
    representative-basis construction, the `O(N^2 M S_P)` oracle bound, and the
    vector-matroid refinement to `O(N^2 M d^2)`.  Lemma 2.3 confirms that a
    flat's minimum generating sets are its bases, the standard antecedent for
    the dimension term in (A2''). Cache key `arXiv:1107.4301`, SHA-256
    `ecc17bbf862daf175647a81ae687310a6d3974f3c6a87f2b09f1ff1ab1bf20e6`.

Search coverage used exact-title and concept queries across arXiv/web indexing for
generalized Hamming weight algorithms, generalized-concatenated decoding,
coset-leader computation, service-rate LPs and fractional matchings, matroid
reliability/Tutte computation, output-sensitive flat enumeration, and
representation-sensitive generator design.
MathSciNet was not covered; Google Scholar was not used.  The review makes no
exhaustive forward-citation or priority claim.

## 13. Computational evidence and replay

Owned code:

```text
papers/complete-repair-ports/algorithms/
```

Replay from that directory:

```text
python3 test_algorithms.py
python3 generate_evidence.py --check
```

The current suite has 52 tests.  Its independent checks include:

- all lifts for 144 binary and 27 ternary prescribed-map/demand instances;
- direct and unsimplified-DP agreement for zero/proportional column removal;
- generated-span expansion and image-subspace invariance against both matrix DP
  and direct lifts;
- generated `GF(4)/GF(2)` and `GF(9)/GF(3)` multiplication blocks and a genuine
  extension-field composition;
- both parenthesizations of a three-level composition;
- ternary proportional/zero outer-block compression against unsimplified
  composition and direct lifts;
- binary nonproportional contraction dominance and compose-first span evaluation
  against unsimplified composition and direct lifts;
- raw coefficient enumeration for target-normalized composition;
- binary and ternary target-normalized composition oracles;
- dependent target-image and redundant syndrome-presentation compression;
- the two scalar-noncomposition examples with common persistent value three and
  exact costs one and two;
- generator enumeration versus syndrome-trellis evaluation for rank-one and
  rank-two demands;
- automatic selection of each confinement algorithm in its favorable regime;
- 49 independent-basis presentations of small binary functional duals;
- every nonzero binary `5 x 3` lift for rank-one support restriction;
- 320 systematic binary code/rank cases for the best-target GHW identity;
- all six binary graph-code identifications in the separation example;
- exact incremental enumeration of `GL(3,2)` and `GL(2,3)`;
- 14 projective reliability polynomials against direct failure-subset
  enumeration, including packed-binary rank against ordinary elimination; and
- bit-mask minimal-support reduction and service-LP incidence preservation under
  zero-extension;
- all 85 unique-charge set systems with up to three obstructions on three
  candidates against the exact collision-correction identity;
- a defect-deletion certificate with overlapping bad concurrence cliques;
- maximum distinct-repair matching against direct enumeration on all 343
  three-demand families in a fixed small universe, including an explicit Hall
  witness on failure;
- replacement-graph component reconstruction on a disconnected example; and
- 784 binary feature-separation instances against direct form enumeration,
  including the genuinely finite-field obstruction where three hyperplanes
  cover a two-dimensional binary nullspace;
- exact scalar recovery supports extracted from a repetition-code dual basis;
- 125 capacity-constrained three-demand instances against direct assignment
  search;
- weighted-download examples proving that support capacity and bandwidth
  capacity cannot be conflated;
- regenerative earliest-arrival times against 36 synchronous fixed-point
  instances;
- an exact two-round schedule in which the first repair must be chosen for the
  nodes it unlocks, rather than by an arbitrary maximum-cardinality tie; and
- joint generator-column materialization and distinct functional-replacement
  selection under simultaneous helper and candidate capacities;
- normalized scalar recovery coefficients replayed on every word of a ternary
  repetition code;
- weighted-capacity optimization against direct search on 686 three-demand
  instances; and
- executable materialization coefficients replayed throughout all 1,024 binary
  `2 x 3` generator / `2 x 2` desired-block pairs, including the empty-support
  zero-block edge case.

`generate_evidence.py --write` creates canonical `evidence/results.json` and
`SHA256SUMS`; `--check` recomputes the JSON in memory and verifies all hashes
without writing.  These files remain private and uncommitted while the user's
code-commit hold is active.

The deterministic large-gap examples now record:

- for the cyclic binary rank-two maps of lengths `4,8,16,32,64`, three
  projective column classes generate five spans; closure takes 14 transitions
  and full rank-two label expansion 43 counted candidates at every length,
  while direct lifts grow from `2^8` to `2^128`;
- a ternary four-block composition with one zero block and one proportional
  duplicate drops from 252 to 90 state transitions, versus 6561 direct lifts;
- the genuine `GF(4)/GF(2)` example drops from 272 labelled-substitution
  transitions to 43 compose-first generated-span candidates, versus 4096
  direct lifts;
- the binary contraction example finds nine cost contractions, reduces three
  outer blocks to one, and drops 36 transitions to four, versus 64 direct
  lifts; and
- the 4000-helper zero-extension stores three active incidence rows and leaves
  3997 zero rows implicit.

## 14. Remaining gates

1. independently review the recurrences, complexity bounds, and source
   comparisons;
2. await user authorization before any code/evidence commit; and
3. allocate a separate manuscript-integration C-item only after C962 is
   accepted.  C962 must remain open until then.

## 15. `ej` + `tt` closeout and mystery ledger

The closeout pass produced one free structural improvement: projective-column
simplification, proved in Section 1 and now exercised by the default algorithm.
It also corrected the projective-reliability positioning after locating the
classical coboundary formula.

| Feature | State after closeout | Exact remaining gate or owner |
|---|---|---|
| redundant matrix labels in prescribed-coset DP | **Settled:** the value is the minimum dimension of a generated span containing `image(b)`; the compact table is demand-independent, and zero/proportional columns are redundant | Independent review of (A2'') and its implementation before acceptance |
| repeated proportional blocks in exact composition | **Settled when the inner table is certified homogeneous/subadditive:** retain one projective block representative and precompute its increments | Target-translated tables are excluded; broader heterogeneous-block dominance remains open only as optional optimization |
| nonproportional block dominance | **Settled for bounded width:** delete `B=A S` whenever exhaustive table checks certify `S` as a cost contraction | Exponential planning must be amortized; production use needs a measured cutoff or supplied automorphism/contraction group |
| presentation-dependent duplicate target maps and syndrome states | **Settled:** canonical column-space and row-space bases are enforced at the relevant interfaces | Further reduction requires genuine code automorphisms or minimal-trellis structure, not row/column cleanup |
| extension-field examples | **Settled:** multiplication matrices generated for `GF(4)/GF(2)` and `GF(9)/GF(3)`, with genuine composition tests | Larger-field performance is engineering, not a correctness gap |
| generator versus syndrome confinement evaluation | **Settled at baseline:** both exact methods and an automatic state-bound planner agree on exhaustive cases | Minimal-trellis/junction-tree construction is a future optimization; current planner can mispredict wall time because it bounds rather than predicts reachable states |
| quotienting confinement maps by `GL(T)` | **Settled negatively:** the fixed target normalization breaks the apparent image-subspace invariance | No shortcut is claimed; any future quotient must retain the oriented target-block datum or its stabilizer |
| rank-/flat-indexed tower envelopes | **Open:** the subspace gauge suggests a refinement of scalar bounds (A4), but no dominance over exact compose-first evaluation is yet proved | Mathematical successor only if a family with large unresolved scalar screens is identified |
| projective reliability priority | **Settled negatively:** the projective coboundary/Tutte formula is classical | No novelty claim; only the recovery specialization and shared-profile implementation are retained |
| general relative-weight computation | **Settled negatively for competitiveness:** the bundled subset method is only an oracle | A production adapter to San-José's `GHWs` package is optional successor engineering |
| coefficient-presentation optimization | **Open by scope:** C962 searches only graph identifications | C955 owns full ambient coefficient-presentation mathematics |
| code release and paper integration | **Open intentionally** | User authorization is required for a code commit; a later C-item owns manuscript/public/export work |
| packed Rust throughput backend | **Open intentionally:** Python remains the exact oracle | Require benchmark evidence that packed XOR/array kernels matter on target-sized instances before adding another implementation |
| dense outer service-LP allocation despite confinement | **Settled:** active helper rows are sparse indexed records and all external zero rows are implicit | Production solver adapters must consume the sparse form rather than request the debug dense view |

No unexplained numerical anomaly remains in the bounded evidence.  The genuine
open questions are optimization and scope boundaries listed above, not failed
checks.

## 16. Cross-paper algorithm transfers: arcs and robust completion

The results snapshot, the prescribed-hole arc paper, the integral-secant paper,
the deep-hole recursion, the continuation-graph paper, and the robust-completion
paper were cross-read against the C962 representations.  Five reusable kernels
are now implemented in `recovery_algorithms/transfers.py`; this remains private
C962 material and does not modify any source manuscript.

### Exact collision-aware counting

On one Frobenius-fixed carrier, each old nonfixed secant orbit is either
invisible or charges one candidate pair.  If `N` is the candidate count, `M`
the obstruction count, `B` the invisible count, `mu(q)` the number of visible
obstructions charging candidate `q`, and

```text
R = sum_q max(mu(q)-1,0),
```

then

```text
legal + M = N + B + R.                                (A18)
```

The new algorithm accumulates the multiplicity histogram in one sparse pass
and returns all terms of (A18).  Its time is `O(N+M)` and memory is `O(N)` in
the carrier model.  Crucially, it rejects an obstruction that charges more than
one candidate: the first test run exposed that (A18) is false for arbitrary
set-valued charges.  Thus this is an exact kernel when geometry or another
application proves unique charging, not a generic inclusion--exclusion claim.

For C962 this gives a collision-aware screen whenever nonconfining witnesses
admit a carrier decomposition with unique local charge.  It strictly refines
the crude union bound by adding invisibility and overlap redundancy, but no
general recovery instance is asserted to have that decomposition.

### Defect-certified structured core

For a codimension-three MDS presentation coming from a `k`-arc, put
`m=floor(k/2)`.  The arc theorem constructs a bad-concurrence graph and proves

```text
|E_bad| <= m(m-1) Delta/2,       tau(E_bad) <= m Delta. (A19)
```

The executable form processes each intermediate-index concurrence clique,
retains one secant, and marks the others for deletion.  The union of marked
secants is a vertex cover; outside it every disjoint secant pair meets at a
maximum-index centre.  The implementation returns both the actual deletion set
and the pre-union edit charge, allowing overlap between cliques to help rather
than hurt.

This suggests a certified preconditioner for the arc/MDS subclass: split the
recovery presentation into a matching-design-like core plus at most `m Delta`
exceptional secants, run a specialized core algorithm, and enumerate only the
fringe.  The theorem does not license this edit bound for arbitrary recovery
hypergraphs, so a general C962 speedup remains conditional on finding an
analogous nonnegative defect identity.

### Simultaneous repair and the orbit-replacement graph

The robust paper proves hundreds of alternate pair extensions after a single
orbit deletion but deliberately leaves its orbit-replacement graph untouched.
C962 now supplies two missing generic algorithms:

1. augmenting-path maximum matching assigns several deleted orbits to distinct
   legal replacements; when it cannot repair all deletions, alternating
   reachability returns a literal Hall set `X` with `|N(X)|<|X|`;
2. exact component enumeration takes a family of legal configurations and
   joins two precisely when their symmetric difference is one deletion and one
   addition.

The matching routine costs `O(D E)` with this transparent reference
implementation, where `D` is the number of deletions and `E` the total candidate
incidences.  Hopcroft--Karp is the obvious production replacement.  Component
enumeration already avoids the quadratic all-pairs scan: a size-`k`
configuration is inserted into its `k` one-deletion hash buckets, and a
union--find merges every bucket.  Expected planning time is `O(V k alpha(V))`
plus hashing for `V` supplied configurations, without materializing the graph's
possibly quadratic edge set.

These algorithms create genuinely new questions beyond the robust paper:
minimum Hall expansion of alternate-repair families, connectedness and diameter
of the invariant-arc replacement graph, and random-walk sampling of equivariant
completions.  The existing per-deletion lower bound alone proves none of
connectedness, expansion, or simultaneous repair, because large candidate
families may overlap completely.

There is also a model boundary: these are replacements by newly selected
columns.  They become operational code repair only in a model whose candidate
pool is available; they are not automatically helper-based repair inside one
fixed code.  In C962 terminology they are immediately valid as design repair,
not silently promoted to storage repair.

### Feature-span separator

The uncovered-locus obstruction becomes an exact finite-field algorithm on any
feature map.  Given evaluation rows for a forbidden set `U`, compute their row
span and its orthogonal nullspace.  A coefficient vector in that nullspace is a
separator exactly when every protected evaluation is nonzero on it.

For one protected point, membership of its evaluation row in `span(ev(U))` is
the sharp yes/no test and a nullspace vector supplies the witness.  For several
protected points, individual nonmembership is not sufficient over a finite
field: their vanishing hyperplanes may cover the whole nullspace.  The reference
algorithm therefore uses the span tests as immediate certificates and then
enumerates the remaining `q^h-1` nullspace vectors, where `h` is the nullity.
The exhaustive binary tests include the smallest cover obstruction
`x=0 or y=0 or x+y=0` on `F_2^2`.

For Veronese features this replaces enumeration of all degree-`d` forms by
rank/nullspace work plus, only when several protected points must all be
avoided, a search in the usually much smaller kernel.  This is an application
of elementary linear algebra already visible in the arc paper, not a priority
claim.  It also suggests a nonlinear feature-lift front end for C962's existing
generated-span machinery.

### Further juice not yet implemented

1. **Integer-envelope branch-and-bound.**  The integral-secant paper's two
   simultaneous degree envelopes and modular-lift surcharge can prune
   projective-code extension searches before orbit enumeration.  This is
   strongest for nonextendibility with multiple minimum-word witnesses, but is
   family-specific rather than a generic RGHW improvement.
2. **Marker-aware recursive elimination.**  The deep-hole papers show that
   contraction must retain removed roots as forbidden markers; classifying
   contracted fibres independently creates false lifts.  This reinforces
   C962's labelled composition and suggests adding small marker states to a
   junction-tree/minimal-trellis backend instead of collapsing to scalar costs.
3. **Symmetry-safe quotienting.**  Frobenius and residual stabilizer orbits give
   an exact quotient only when the group stabilizes the target datum.  This is
   the legitimate replacement for the invalid unrestricted `GL(T)` quotient.
   A future planner should orbit-compress labels under that stabilizer and
   verify cost and transition equivariance before using the quotient.
4. **Inverted-index replacement edges.**  The continuation graph is a line
   graph of a linear hypergraph, with each candidate represented by its tangent
   coordinate tuple.  Hashing coordinate values generates incompatibility and
   replacement edges without all-pairs comparison.  The full continuation
   complex must be retained when higher-order illegal sets matter: the paper's
   two-point example proves that the pair graph alone can forget the ambient
   geometry completely.
5. **Uncovered-locus structure learning.**  When
   `q+1 > binom(k,2)`, thresholding line intersections with the covered locus
   reconstructs the secant set, and incidence degree `k-1` reconstructs the
   parent arc.  Packed incidence bitsets and `bit_count` give a direct Lemire-
   style implementation.  This can infer a codimension-three MDS presentation
   from its deep-hole syndrome locus before C962 optimizes recovery on it; the
   reconstruction theorem itself is already explicit in the arc paper.

The immediate value is therefore not a stronger universal C962 bound.  It is a
set of exact, hypothesis-aware preprocessors and certificates for structured
MDS/design applications, plus three concrete research programmes: Hall
expansion of equivariant repairs, defect-parameterized recovery on the
structured core, and target-stabilizer orbit compression.

## 17. Storage repair: exact, functional, and regenerative models

The storage layer is now explicit in `recovery_algorithms/storage.py`.  It
separates four questions that the phrase “alternate repair” otherwise blurs:

1. can the original failed symbol be reconstructed from live symbols of the
   same fixed code;
2. can several such repairs run concurrently under helper access or bandwidth
   capacities;
3. can repaired nodes become helpers in later rounds; and
4. can the code be changed by materializing different legal generator columns
   while preserving the stored message?

### Fixed-code scalar repair extraction

Given a row basis of `C^perp`, target `x`, and field `F_p`, enumerate dual words
with nonzero `x` coefficient and retain the inclusion-minimal off-target
supports.  Normalize the target coefficient and retain every distinct
coefficient fibre, yielding executable equations
`c_x=sum_h a_h c_h`.  These are exactly the one-symbol-per-helper scalar
recovery equations.  The reference enumeration costs `p^r` dual combinations
for dual dimension `r`; naive inclusion-minimality filtering can add quadratic
time in the number of distinct supports.  This is an oracle and small-instance
front end; a production implementation should generate bounded dual words with
a Brouwer--Zimmermann/trellis backend.

This step turns the abstract recovery equations already central to C962 into
literal storage schedules.  It does not claim minimum bandwidth under
subpacketization: the extracted protocol downloads one full scalar from every
selected helper.

### Capacitated parallel repair

For demand `i`, let option `a` consume the integral load vector
`ell_(i,a) in Z_{>=0}^H`, and let helper/resource capacities be `c`.  The exact
optimizer is

```text
max |I|  subject to choosing at most one option a_i per demand i,
                 sum_(i in I) ell_(i,a_i) <= c.        (A20)
```

Its dynamic program stores the best assignment at each used-capacity vector.
The raw state bound is

```text
S <= product_h (c_h+1),
transition time O(D A S H), memory O(S).              (A21)
```

before Pareto pruning.  After each demand, a state is deleted if another state
has at least as many completed repairs and no greater load in any coordinate.
The deliberately transparent pairwise dominance pass adds `O(D S^2 H)` in the
worst case; a production implementation should maintain a specialized Pareto
frontier instead of rescanning it.
The unit-access wrapper represents every recovery support by a zero-one load;
the weighted interface represents downloaded subsymbols or other heterogeneous
resource charges.  A test where one protocol downloads two units from a helper
and another downloads one shows why these interfaces must remain distinct.

The problem contains unit-capacity set packing, so exponential exact behavior
is structural, not merely an implementation defect.  For any resource cut `C`,
let `X_C` be the demands for which every option consumes some resource in `C`.
Then every schedule obeys

```text
repairs <= D - |X_C| + sum_(h in C) c_h.               (A22)
```

The unit-access implementation enumerates resource cuts through 22 resources
and returns the strongest bound and its literal witness.  It is a valid upper
bound, not a complete dual certificate for general hypergraph packing.  The
weighted interface does not currently return this cut.  Singleton options
reduce (A20) to the distinct-replacement matching algorithm, where Hall's
theorem does give a complete feasibility certificate.

### Regenerative timing and minimum rounds

With unlimited fanout inside a round, a node's earliest arrival time satisfies

```text
T(v) = 1 + min_(R repairs v) max_(h in R) T(h),         (A23)
```

with initially live nodes at time zero.  A reverse incidence index stores the
number of missing helpers and latest arrival for every recovery option.  A
priority queue activates an option only when its final helper arrives.  This
evaluates the least fixed point of (A23) in
`O((I+A) log(n+A))` time for `I` support incidences and `A` recovery options,
and identifies unreachable dependency cycles.

Finite helper capacities couple the repairs inside each round.  The exact
minimum-round planner therefore performs breadth-first search on the repaired-
node subset and uses (A20) to validate each parallel transition.  It is an
exponential oracle, but it catches a real scheduling effect: two equally large
first-round batches need not be equivalent, because one repaired node may
unlock more second-round repairs.  This is precisely the timing information
that the manuscript's finite structural control algebra intentionally forgets;
the storage scheduler is a separate algorithmic layer rather than a claimed
finite transfer theorem.

### Materializing replacement columns

For a fixed `k x n` generator matrix `G` and desired new-column block `B`, a
helper set `H` can centrally materialize the new stored symbols exactly when

```text
image(B) <= span{G_h : h in H}.                        (A24)
```

The implementation enumerates every inclusion-minimal such `H` and solves
`G_H X=B`, returning an executable coefficient matrix `X`.  Its minimum
cardinality is the same generated-span gauge already discovered for prescribed
coset cost:

```text
min_H |H| = min{dim W : image(B)<=W,
                         W generated by old columns}. (A25)
```

Candidate choice is then made into an ordinary resource by giving every
replacement column or orbit unit capacity.  Adding the helper-download loads
to that candidate resource makes (A20) jointly enforce distinct replacement
choices and actual materializability.  Thus the robust paper supplies the
legal candidates, (A24) supplies their storage cost, and the combined DP decides
which functional repairs can run together.

### What the arc results imply for storage

Let the arc columns generate the low-rate projective MDS code
`[k,3,k-2]_(s^2)`.  A legal conjugate pair spans its empty fixed carrier line.
No two old arc columns span that line, while any three old arc columns span the
three-dimensional message space.  Therefore:

```text
joint access to materialize either one fresh point or its full conjugate pair
is exactly three old scalar nodes.                    (A26)
```

The lower bound is not restricted to linear decoders.  If the desired pair
were determined by two downloaded scalar node values for every message, the
kernel of the two-helper evaluation map would lie in the kernel of the desired
pair map; finite-dimensional duality would then put both desired columns in the
span of those two helper columns, contradicting emptiness of the carrier.

### Storage corollary of robust pair replacement

**Corollary (exact-access functional orbit repair).**  Let `K=F_(s^2)`, let
`D={d_1,...,d_k}` be a `k`-arc in `PG(2,K)`, and choose nonzero column
representatives to form a `3 x k` generator matrix `G_D`.  Let
`Q={q,q^s}` be any legal nonfixed conjugate-pair extension of `D`.  Store the
dimension-three projective MDS code

```text
C_D = { (m^T d_1,...,m^T d_k) : m in K^3 }.
```

Then, provided at least three old nodes survive:

1. either new coordinate and the two-coordinate block `Q` can be materialized
   from every chosen triple of surviving old nodes;
2. neither one new coordinate nor the pair can be materialized from at most two
   old scalar nodes, even by a nonlinear decoder required to work for every
   message;
3. consequently their individual and joint helper-access cost is exactly
   three; and
4. for a helper triple `H`, the repair coefficients are the unique matrix
   `X_H` satisfying `G_H X_H=[q q^s]`.  Downloading the three old symbols once
   and multiplying by `X_H` produces both new symbols.

If `A=D union O` is an invariant `(k+2)`-arc and `Q != O` is an alternate-orbit
repair, this operation preserves the same message `m` while replacing the two
generator functionals indexed by `O` with those indexed by `Q`.  It is therefore
functional storage repair/code reconfiguration of the punctured low-rate code.

**Proof.**  Every three columns of an arc are linearly independent, so every
old helper triple is a basis of `K^3`; this proves existence and uniqueness of
`X_H`.  Legality says neither point of `Q` lies on an old secant, hence neither
new column belongs to the span of one or two old columns.  The pair's span is
its mate line, which is disjoint from `D`, so it likewise cannot equal the span
of two old columns.  Finally, any deterministic decoder from helper values
factors the desired evaluation map through the helper evaluation map.  Kernel
containment, followed by duality, would put the desired columns in the helper
span.  Thus two helpers are impossible and three are sufficient.  `square`

The corollary converts the robust paper's candidate counts into exact counts of
candidate/helper-triple plans:

| Residual arc | Guaranteed alternate pairs | Helper triples per pair | Guaranteed functional-repair plans |
|---|---:|---:|---:|
| invariant eight-arc, `s>=7` | 318 | `binom(8,3)=56` | 17,808 |
| invariant eight-arc over `F_25` | 3 | `56` | 168 |
| Clebsch six-arc over `F_(11^2)` | 4,179 | `binom(6,3)=20` | 83,580 |

These count distinct `(replacement pair, helper triple)` plans.  They do not
assert that all plans can execute concurrently: helper bandwidth and candidate
uniqueness are imposed afterward by (A20).  Nor is 17,808 a count of ways to
recover the original erased values; it is a count of functional
reconfigurations preserving the same three-symbol message.

The same proof gives exact repair of the original deleted orbit `O` from any
old helper triple.  Alternate pairs therefore add placement diversity, future
failure choices, and possible load balancing, but do not reduce the optimal
three-helper access of exact repair.  Joint repair avoids repeating the three
downloads in two separate repair sessions; this is a cooperative-access saving,
not a claim of a new regenerating-code bandwidth point.

The corollary is centrally coordinated over `K`.  Requiring the helper set and
the repair map themselves to be Frobenius-stable is a stronger rack/symmetry
model.  In particular, a residual profile with no fixed nodes has no stable
three-node helper set.  That equivariant-protocol variant is not claimed here
and belongs with the rack/carrier-capacity successor.

The dual high-rate MDS code has a different verdict.  Extending a `k`-arc from
`k` to `k+2` points changes `[k,k-3,4]` into `[k+2,k-1,4]` and introduces two
new message degrees of freedom.  Those new coordinates are not determined by a
word of the old high-rate code.  Consequently robust arc extension is **not**
local repair of that high-rate storage code unless an external source supplies
the new information or a separately specified shortening/re-encoding map is
used.  The safe storage interpretation is the dimension-three generator code,
or an explicit data-migration operation—not the high-rate parity-check code.
The robust-completion manuscript already states exactly this boundary in its
introduction: it works with the dimension-three generator code and says that
alternate repair changes the generator-column configuration rather than
performing erasure decoding inside a fixed code.  Therefore this observation
requires no correction to that paper; it only blocks an invalid stronger
storage interpretation.

### Remaining storage targets

1. Replace dual-word enumeration with a production bounded-word/RGHW backend.
2. Feed actual C962 coefficient maps into weighted loads, so vector repair
   charges rank or transmitted subsymbol count rather than helper union alone.
3. Derive codegree/overlap bounds for robust replacement families; the current
   single-deletion counts do not imply Hall expansion under multiple failures.
4. Add rack and carrier capacities.  A conjugate orbit naturally acts as a
   two-symbol rack, and the carrier decomposition may yield a much smaller
   capacity state than one coordinate per helper.
5. Compare the fixed-code scheduler against current regenerating-code and
   service-rate solvers before making any SOTA performance claim.  The present
   contribution is an exact reference model and cross-paper structural bridge.

## 18. C949-derived bounded-incidence algorithms

C949 exposes two reusable representations that are strictly smaller than its
raw point-set search: bounded intersection predicates expressed through exact
moments, and a sparse signed ternary incidence word expressed through orbit
contributions.  The private suite now implements the algebraic kernels for
both.  It does not copy a C949 certificate or claim to solve the full `q=27`
instance.

### Exact bounded-alphabet threshold compilation

For integer data `f(0),...,f(m)`, Newton interpolation gives the exact identity

```text
f(d) = sum_[j=0..m] Delta^j f(0) binom(d,j),  0 <= d <= m.   (A27)
```

All coefficients remain integral.  Thus any predicate on a bounded line-
intersection alphabet becomes a linear functional of the binomial moments.
For C949's alphabet `0 <= d <= 5`, compiling `1_[d>=3]` returns

```text
(0,0,0,1,-3,6),
1_[d>=3] = binom(d,3)-3 binom(d,4)+6 binom(d,5).       (A28)
```

The implementation computes the forward-difference triangle in `O(m^2)`
integer operations and evaluates a compiled predicate in `O(m)` operations.
When an orbit move changes known intersection multiplicities, its exact change
in the selected-line count can therefore be precomputed from moment deltas;
no threshold branching is needed inside the search.

### Carry-safe packed ternary arithmetic

The ternary syndrome kernel stores coordinate `i` in bits `3i,3i+1`.  The
third bit of each lane is zero in normalized inputs.  Adding two packed words
cannot carry between lanes because each lane sum is at most four.  A sum of
three has lane pattern `011`, a sum of four has pattern `100`; marking these
two patterns and subtracting three in each marked lane yields exact
coordinatewise addition modulo three.  The operation uses a constant number
of arbitrary-precision integer Boolean/arithmetic operations after masks are
formed, rather than a Python loop over syndrome coordinates.  Exhaustive tests
check all `3^4 x 3^4 = 6,561` pairs of four-trit words.

### Exact orbit-contribution syndrome search

An orbit block has finitely many labelled options.  Each option contributes a
ternary syndrome vector and an integer total vector; the latter can encode,
for example, support size, positive count, negative count, or defect moments.
The solver chooses exactly one option per orbit and matches both target
vectors.  Its state is

```text
(next orbit, packed partial syndrome, partial integer totals).       (A29)
```

It applies three exact reductions.

1. Suffix coordinatewise minima and maxima of every integer total reject a
   state only when the target lies outside the remaining interval.
2. For every syndrome coordinate, the set of residues attainable by the
   remaining suffix rejects a state when its required residue is absent.
   This relaxation forgets correlations between coordinates, so it is a safe
   necessary test.
3. A failed state (A29) is memoized.  Future completions depend only on that
   state, so the memoization is exact.

If the syndrome width is `w`, there are `N` orbit blocks, at most `b` options
per block, and `R_(i,j)` distinct partial values of integer total `j` at depth
`i`, the unpruned memoized state and transition bounds are

```text
states <= sum_[i=0..N] 3^w product_j R_(i,j),
transitions <= b sum_[i=0..N-1] 3^w product_j R_(i,j).       (A30)
```

These are worst-case bounds, not a polynomial-time claim.  Their advantage is
representational: they depend on the orbit quotient, syndrome width, and
tracked totals rather than on enumeration of all underlying point subsets.
The exhaustive oracle checks all 225 pairs of two-coordinate syndrome targets
and two integer-total targets for a four-orbit model against its direct `3^4`
assignments, including infeasible targets and replay of every returned witness.

For the C949 `q=27` gate, the intended input would record its 31--32 active
nonfixed Frobenius orbits, fixed sign composition, ternary incidence syndrome,
and defect moments.  The current engine is ready for that quotient input, but
C949 still owns extraction of the exact orbit contribution table and a full
performance comparison with CP-SAT.

### Signed-support constraint kernel

Given incidence rows and signs in `{-1,0,1}`, one incidence pass returns every
row's support degree and signed sum, together with the tangent rows and the
two-secants whose two signs agree.  The latter are exactly the local violations
of C949's no-tangent/opposite-sign support rules.  The auditable interface
compiles rows to integer masks; the search interface computes degrees and
signed sums using intersections and `bit_count`.  For `L` rows on `n` points
this uses `O(L ceil(n/w))` machine-word work after masks are built, instead of
revisiting every stored incidence in Python.  Its output is a literal violation
certificate usable for branch propagation or independent witness checking.

### Bounds and scope verdict

The new routines strengthen C962's algorithm library, not its universal
recovery theorems.  They supply an exact feature lift and a sparse modular
search backend for highly structured incidence instances.  The strongest
next experiment is the full C949 Frobenius quotient.  The `q=9` higher-arc
storage benchmark separately needs its actual `GF(9)` incidence certificate;
the present prime-field scalar dual extractor cannot infer that benchmark from
the published line spectrum alone.

### Refreshed mystery ledger

| Feature | State after the C949 upgrade | Exact remaining gate or owner |
|---|---|---|
| degree-five threshold identity | **Settled generically:** it is the Newton-binomial transform of a bounded truth table, not an isolated trick | C949 owns any further geometric use of the resulting moment equations |
| signed search representation | **Settled as an exact reusable engine:** packed syndrome, integer bounds, residue pruning, and memoization are implemented and independently cross-checked | C949 must supply the `q=27` orbit table and compare the resulting run with CP-SAT |
| 31 versus 32 active orbit counts | **Unexplained geometrically:** the solver can impose either count but does not explain the branch difference | C949 signed-word classification gate |
| extension-field higher-arc storage profile | **Open by input:** the line spectrum does not determine targetwise recovery circuits | A private certificate adapter/benchmark successor; no manuscript inference is allowed |

No new unexplained numerical anomaly arose in the C962 tests.  The remaining
mysteries are C949 instance geometry and benchmarking, not correctness gaps in
the reusable kernels.

## 19. Replayable hierarchical recovery certificates

The scalar optimizer is now complemented by a certificate-bearing path.  A
leaf certificate for `b` contains a lift `X`, its nonzero row support, and the
identity

```text
phi X = b,                 |rowsupp(X)| = Lambda_phi,T(b).   (A31)
```

The compact generated-span table remains the default value engine.  A leaf
witness is resolved lazily by the projectively simplified row DP: one original
coordinate and its inverse normalization scale are retained for each
projective column class, and the final lift is restored to the original
coordinate set.  Thus zero-column deletion and projective deduplication do not
turn the certificate into a witness for a different presentation.

For literal outer blocks `A_1,...,A_N`, a hierarchical certificate for output
label `b` stores local labels `b_i` and recursive child certificates with

```text
b = sum_i A_i b_i,         cost(b) = sum_i cost_i(b_i).     (A32)
```

Canonical tie-breaking makes the returned plan deterministic: minimize cost,
then the original-coordinate support lexicographically, then the coefficient
rows.  This convention is shared by the Python oracle and Rust arena.
Witness mode
intentionally uses the literal supplied blocks: scalar proportional-block or
dominance compression can replace and rescale a block without retaining the
coordinate map needed for execution.  The scalar optimized path keeps those
reductions; the witnessed path chooses auditability until a future compressed
certificate explicitly records the omitted maps and scales.

The target-normalized optimizer additionally stores `u_i` and `z_i` satisfying

```text
sum_i A_i u_i = normalization,
sum_i A_i(u_i+z_i) = prescribed,                           (A33)
```

together with a leaf witness attaining every local helper cost `mu_i(z_i)`.
Both confinement backends now retain the winning block-label sequence.  The
generator backend also retains the outer functional coefficients; the syndrome
backend retains the zero-syndrome trellis path.  For the nonzero sector, the
recursive local witnesses sum exactly to the reported confinement cost.

The zero sector has one unavoidable interface boundary.  Its value contains
the supplied scalar `d(D)` in addition to `mu(0)`.  A scalar distance does not
determine a word attaining that distance.  Accordingly the result marks its
witness complete only when the caller supplies an attaining inner-distance
support.  This prevents the API from presenting a numerical lower-bound input
as an executable certificate.

The witness recurrence has the same transition count as its min-plus value
recurrence.  The reference implementation stores persistent path tuples, so
its worst-case path storage adds a factor equal to the hierarchy depth; a
production implementation can replace these by predecessor indices without
changing (A31)--(A33).  Lazy leaf reconstruction runs the projectively reduced
row recurrence only for labels actually requested by the winning hierarchy.

Independent tests now verify:

1. every attainable binary `2 x 2` demand for every binary `2 x 3` linear map,
   replaying `phi X=b` and checking exact row-support cost;
2. a ternary presentation with nontrivial projective rescaling, checking that
   normalized representatives restore the original-coordinate coefficients;
3. every output label of a two-block hierarchical composition against direct
   composition, recursively replaying (A32), plus a second composition level;
4. target-normalized replay of both equations in (A33); and
5. generator and syndrome confinement paths, including zero syndrome and the
   sum of local witness costs.

### Witness mystery ledger

| Feature | State | Remaining gate |
|---|---|---|
| scalar optima without helper plans | **Settled:** canonical leaf and recursive hierarchical witnesses are available | None for literal-block finite instances |
| compressed-block witnesses | **Open intentionally:** scalar compression is retained, but witnessed composition uses literal blocks | Record original block index, projective scale, and dominance contraction before enabling compressed witnessed execution |
| zero-sector confinement certificate | **Settled at the interface:** completeness requires an attaining inner-distance support | A caller wanting coefficients must also supply the corresponding inner dual word, not merely its weight |
| all tied optimum plans | **Open by scope:** one canonical optimum is returned | A compressed predecessor DAG is a cheap successor only if plan enumeration is operationally needed |

No witness replay discrepancy remains in the tested finite domains.

## 20. `ej` + `tt`: proof-carrying plans and scheduler loads

The witness tree separates expensive discovery from cheap checking.  A leaf is
verified by multiplying `phi X`, recomputing its row support, and comparing the
support cardinality with its claimed local cost.  A composition node is
verified by (A32), equality of every child label with its recorded local label,
and additivity of child costs.  Neither verifier reruns a min-plus search.
Consequently a proposed hierarchical recovery plan has a certificate whose
verification time is polynomial in the displayed matrices and witness-tree
size even though finding the optimum is NP-hard already for a single binary
demand.

The same tree yields an operational bridge for free.  Address a leaf helper by
its sequence of block indices followed by its original local coordinate.  A
single traversal returns the exact integral load vector

```text
load(path,coordinate) = number of certified leaf downloads at that resource.
                                                               (A34)
```

For an ordinary support-cost hierarchy, the sum of (A34) equals the certified
optimum.  The vector can be passed directly to the weighted parallel-repair
solver, so hierarchical optimization and capacity scheduling no longer need a
hand-written translation layer.  Translated target witnesses use their
restored executable lift rather than double-counting the explanatory child.

Tests independently reject a deliberately corrupted composition cost and
check the extracted load sum for every label of the two-block example.  The
canonical evidence records one literal hierarchy-addressed load vector.

### `ej` mystery update

| Feature | State | Remaining gate |
|---|---|---|
| exponential optimization versus certificate checking | **Settled:** discovery may be exponential, while leaf and composition replay are polynomial in certificate size | A paper-facing complexity statement remains forbidden until manuscript integration is authorized |
| optimizer-to-scheduler translation | **Settled for scalar support cost:** hierarchy-addressed loads are extracted exactly | Vector/rank bandwidth still needs a coefficient-aware resource metric |
| independent full-tree verifier | **Partly settled:** independent leaf and composition-node checks compose recursively | Target-normalized and zero-sector certificate packages would benefit from standalone serialized verifiers before export |

The main cheap surprise is that C962 now supplies not just an optimizer but a
proof-carrying repair-plan format whose resource vector feeds the existing
scheduler without another optimization.

## 21. Rust performance route

The private Rust successor is routed inside C962 at
`papers/complete-repair-ports/algorithms/rust/`.  Its nested `AGENTS.md` makes
the repository performance playbook a mandatory pre-read for every future
design, implementation, optimization, and benchmark turn.  The acceptance
order is fixed:

```text
format/lint/unit properties
    -> exact Python cost/witness/load parity
    -> release A/B measurement with state and memory counts
    -> retain or reject the optimization.                          (A35)
```

The route forbids a file-for-file Python translation.  Hot representations use
explicit layouts, range-sized IDs, contiguous byte/record/witness arenas, and
compile-time size/alignment assertions.  Prime fields and run-constant
instrumentation are monomorphized; hashes, serialization, CLI data, errors,
and tuning metadata remain outside hot records.  No raw-pointer design or
unverified performance claim is admitted.

The initial architectural gate rejected `Vec<Matrix>` for the span table even
though it was functionally correct: each matrix owned a separate allocation,
creating exactly the pointer-chasing pool shape prohibited by the Tiger-style
rules.  The accepted design uses a flat byte arena indexed by 16-byte basis
records, 16-byte span states, and 16-byte predecessor nodes.  This correction
occurred before performance measurement, so no misleading baseline claim is
recorded.

The first differential corpus covers 91 generators and 1,267 queries: every
binary `2 x 3` generator against every binary `2 x 2` demand, plus every
ternary `1 x 3` generator against every ternary `1 x 2` demand.  Exact costs
and original-coordinate supports agree.  The first run exposed a genuine
certificate-convention mismatch: Python broke equal-cost ties by coefficient
rows, indirectly favoring later helpers, whereas the Rust arena retained the
earliest support.  The shared explicit order is now cost, original-coordinate
support, then coefficients.  The regenerated corpus passes in both languages.

The next parity gate covers the hierarchical optimizer itself rather than only
its leaf tables.  Rust now composes literal labelled blocks by min-plus dynamic
programming while retaining the complete choice path.  Labels share the flat
matrix arena; scalar cost records, frontier states, and predecessor records are
all compile-time asserted at 16 bytes with four-byte alignment.  The confinement
layer implements both exact routes from Section 4: base-field generator
enumeration and a weighted syndrome trellis.  Differential cases over binary
and ternary composition, and two binary confinement instances, agree with
Python on cost, winning sector, functional coefficients, and every chosen block
label.  These tests establish representation-independent witnesses; they do not
yet establish a throughput advantage.

The packed orbit search uses 21 carry-safe ternary lanes per `u64` and mutates
one packed syndrome buffer forward and backward during depth-first search.
Suffix integer intervals and coordinatewise residue masks are precomputed.
Failed states are exact, not probabilistic: a hash selects a collision chain,
then a 16-byte record points into a flat word arena for full key comparison.
Seventeen Python differential cases agree on the first witness and all four
state/pruning counters; one has width 25 and therefore crosses a packed-word
boundary.  A property test independently compares random widths through 49
against four-choice scalar enumeration.

The capacity engine compiles weighted options to flat loads and maintains
16-byte Pareto states and 16-byte predecessor nodes.  Equal-load interning is
hash-assisted but collision-exact.  After each demand, surviving loads are
compacted into a fresh contiguous frontier, so the live load pool realizes the
`O(SH)` bound in (A21) rather than retaining all historical pruned vectors.
Python differential cases agree on assignments, unmatched demands, aggregate
helper loads, transitions, peak frontier size, and the unit capacity-cut
certificate.  Random four-demand property cases independently compare the
optimal repair count with exhaustive `3^4` choice enumeration.

### Rust `ej` + `tt` mystery update

| Feature | State | Remaining gate |
|---|---|---|
| coordinatewise suffix residues | **Correct but potentially loose:** the masks are necessary conditions and often saturate quickly | Measure residue-prune yield; if weak, test family reordering or a bounded correlated suffix trellis while mapping witnesses back to original order |
| capacity-state representation | **Compact and bounded:** flat `u32` loads plus 16-byte states attain `O(SH)` live storage | A release A/B should compare against mixed-radix or guarded broadword load keys when capacities permit exact scalar packing |
| quadratic Pareto pruning | **Oracle-equivalent baseline:** exact dominance preserves the optimum and witness | Benchmark frontier sizes before choosing an incremental skyline structure; state-count reduction has priority over instruction shaving |
| duplicate orbit effects | **Unexplained leverage:** distinct labels can induce identical residue/total transitions | Deduplicate only after measuring frequency and specifying whether first-label witness preservation is required |

The Lemire-style opportunity is exact scalar packing of small capacity vectors,
not a generic bit trick: mixed-radix keys remove the load arena only when the
capacity product fits a machine word, while guarded broadword lanes need a
proved per-lane overflow test for non-power-of-two capacities.  The Tao-style
question is whether correlated suffix syndrome information can be represented
by a small quotient rather than independent coordinate masks.  Neither is
claimed as an improvement before an interleaved release comparison records
states, transitions, time, and memory.

The first such comparison is now recorded as a deliberately bounded result,
not a general performance claim.  Every run was pinned to one CPU and variants
were rotated between rounds.  On the deterministic weighted-scheduler instance,
seven-round whole-solve medians were 8.869 seconds for Python and 46.2
milliseconds for the Rust flat-load engine, with the same witness, 35,334
transitions, and 1,907-state peak: `192x` on this instance.  Python peak RSS
was about 30 MiB and Rust about 2.3 MiB.  On the deterministic ternary-orbit
instance, medians were 84.3 milliseconds for Python and 1.064 milliseconds for
Rust, with the same infeasible answer and 16,645 visited states: `79x` on this
instance.  Python peak RSS was about 30 MiB and Rust about 2.5 MiB.

The longer Rust-only A/B changes the optimization verdicts.  Mixed-radix
capacity keys preserve the exact witness, transition count, and frontier size,
but their eleven paired ratios have median `1.005x`; this is a wash, so flat
loads remain the production baseline and mixed radix remains only a reproducible
experimental backend.  Exact correlated suffix residues reduce the orbit DFS
from 16,645 states to one, yet the eleven-round pinned median is 4.28 times
slower overall and peak RSS rises from about 2.4 to 7.6 MiB: constructing 85,824
suffix states overwhelms the saved search.  This is a useful negative, not an
accepted optimization.

### Refreshed Rust mystery ledger

| Feature | State | Remaining gate |
|---|---|---|
| mixed-radix capacity key | **Measured wash:** paired median `1.005x`, identical work and frontier | Keep only as experimental evidence; reconsider only for a memory-stressed workload where process-level RSS can resolve the representation difference |
| exact correlated residue closure | **Measured negative on the current instance:** one DFS state but `4.28x` slower and roughly triple Rust RSS | An adaptive planner needs multiple widths/family counts and a build-cost estimate before selecting it |
| Python differential oracle comparison | **Strong bounded result:** `192x` scheduler and `79x` orbit on one deterministic workload each | This is not SOTA: compare scheduling with CP-SAT/MILP and syndrome search with a minimal-trellis or variable-elimination implementation |
| scheduler time variability | **Settled operationally:** CPU pinning made paired runs stable enough to classify the mixed variant | Broader workloads still need randomized order and per-instance state counts |

The cheap `ej` conclusion is negative but valuable: neither scalar packing nor
maximal suffix knowledge is automatically the right optimization.  Lemire's
likely next question is whether a cheaper partial quotient can capture most of
the 16,644-state pruning without materializing 85,824 suffix states.  Tao's is
whether separator rank, rather than raw syndrome width, predicts that quotient.
Those point to an adaptive rank-bounded suffix construction; CP-SAT and minimal
trellis comparisons come first so C962 does not optimize an irrelevant regime.

Current Rust gates pass with all features: formatting, warning-denying Clippy,
unit/property tests, the 1,267-query Python differential test, Python's 62
reference tests, and the canonical checksum replay.  The following section
supersedes the initial performance verdicts after the competitor and profiling
gates.

## 22. Exact trellis and dense-lattice performance results

The orbit competitor is an exact bidirectional meet-in-the-middle trellis.  It
enumerates the two family halves, keys right-half residue/total states exactly,
and probes complementary states from the left while retaining the canonical
witness.  If the halves contain `L` and `R` assignments and the packed key has
`w` machine words, the direct bound is

```text
time   O((L+R)w),
memory O(Rw),                                                (A36)
```

up to hash-table operations with collision-checked keys.  On the deterministic
ten-family orbit fixture, it examines 486 half assignments and retains 243
right states.  Its 26.1 microsecond median is `40.4x` faster than coordinate
DFS, `172.7x` faster than exact correlated closure, and `3,229x` faster than
the Python oracle on this fixture.  Bounded exact preallocation contributes a
separate 21-round `1.214x` median improvement.

For weighted scheduling, let

```text
P = product_h (capacity_h+1),
S = number of distinct frontier loads,
H = number of resources.
```

The new dominance backend places `repairs+1` at each mixed-radix lattice key,
takes a coordinatewise prefix maximum, and tests every state against its strict
predecessor maximum.  This replaces the baseline `O(S^2 H)` Pareto scan by
`O(PH+S)` time and `O(P+S)` auxiliary memory.  Each frontier uses the transform
only when its explicit `PH` work estimate is no larger than `S^2H`; this is an
exact backend choice, not a heuristic change to the optimum.

The implementation then applies the Queens/Tiger representation rules:

1. the bounded mixed-radix key directly addresses the incumbent table, removing
   hashes and collision-chain scans;
2. option deltas are precomputed and the 16-byte state's auxiliary word stores
   its lattice key;
3. biased guard lanes test all capacity inequalities with one packed addition
   and mask when the lanes fit; and
4. a once-only const-generic dispatch selects `u64`, `u128`, or the scalar
   fallback, leaving no run-constant branch in the hot loop.

The guard identity is exact.  For lane value width `b` and capacity `c`, add
the bias `2^b-1-c`; the lane's guard bit is set exactly when
`used+option>c`.  An extra guard bit prevents carry into the adjacent lane.

In the final 21-round pinned, rotated interleave, the balanced fixture medians
are 46.811 ms for the original Rust scan, 3.285 ms for single-worker OR-Tools
9.14 CP-SAT, and 1.018 ms for the tuned exact backend.  Thus the tuned backend
is `46.0x` faster than the Rust baseline and `3.23x` faster than CP-SAT here;
peak RSS is about 2.5 MiB versus 74.5 MiB.  On the small-state/high-demand
fixture it takes 161 microseconds versus 16.597 ms for CP-SAT (`102.9x`).
Packed feasibility contributes `1.108x`, and range-sizing the 18-bit word from
`u128` to `u64` contributes `1.046x`.

A final pinned `perf stat` diagnostic gives, per balanced solve, approximately
181.6 million cycles, 381.8 million instructions, and 118.1 million branches
for the flat backend, versus 3.47 million cycles, 11.13 million instructions,
and 1.77 million branches for the tuned backend.  Branch-miss rate falls from
about 1.90% to 0.55%, and the tuned kernel sustains about 3.21 IPC.  Explicit
SIMD was considered, but the contiguous prefix transform ceased to be the hot
region after division removal.  Direct addressing and packed scalar arithmetic
had measured leverage; no architecture-specific unsafe SIMD path is justified
by this profile.

These are exact bounded-fixture comparisons, not a universal claim to improve
CP-SAT or a literature priority claim.  The CP-SAT model is the nearest general
integer competitor presently measured; the meet-in-the-middle implementation
is the nearest implemented exact trellis competitor.  A workload phase diagram
and broader family-specific comparisons remain necessary for a SOTA verdict.

### Final `ej` + `tt` mystery ledger

| Feature | State after profiling | Exact remaining gate or owner |
|---|---|---|
| quadratic scheduler wall | **Settled:** it was the Pareto representation; the lattice transform plus direct addressing removes 46-fold wall time on the balanced fixture | Broaden `(P,S,H,D)` workloads and fit an adaptive backend phase diagram inside C962 |
| SIMD opportunity | **Settled for this kernel/profile:** the candidate SIMD loop is not hot after the stride rewrite | Reopen only if a new workload profile attributes material cycles to prefix maxima |
| CP-SAT comparison | **Promising bounded win:** `3.23x` balanced and `102.9x` small-state, with exact witnesses and much lower RSS | More workloads, CP-SAT model audits, and family-specific solvers before any SOTA or general-superiority statement |
| orbit separator choice | **Strong bounded result:** bidirectional exact trellis dominates both coordinate and maximal correlated suffix methods on the fixture | Map split position, syndrome width, and duplicate-transition regimes; no minimal-trellis priority claim is licensed |
| dense memory threshold | **Bounded but open:** `P<=2^24` prevents runaway allocation, while per-frontier `PH<=S^2H` selects the transform | An epoch-stamped direct table or sparse/dense crossover study may improve very large `P` without changing exactness |

The cheap Lemire-style gains—range-sized words, broadword guards,
precomputation, and direct addressing—are now exhausted against the measured
profile.  The Tao-style remaining question is structural: predict the best
separator/backend from quotient rank and frontier geometry rather than raw
problem dimensions.  No correctness mystery remains in the tested domains;
the genuine open item is the crossover law needed for a defensible SOTA map.

## 23. Antichain scheduler and measured crossover map

The crossover pass found a stronger exact shortcut than another skyline data
structure.  Suppose every compiled repair option has the same positive total
load `m`.  For every frontier state `x`,

```text
sum_h load_h(x) = m repairs(x).                           (A37)
```

If `y` dominates `x`, then `load_h(y)<=load_h(x)` for every helper and
`repairs(y)>=repairs(x)`.  Summing the coordinate inequalities and applying
(A37) forces equality of the repair counts and then equality in every load
coordinate.  Equal loads have already been interned.  Hence the distinct
frontier is an antichain and Pareto pruning is exactly unnecessary.

This applies in particular to uniform-cardinality recovery supports, including
all scheduler phase fixtures.  The Rust compiler records the certificate once
when constructing `WeightedRepairProblem`.  The sparse backend skips its
quadratic scan; the dense backend skips its prefix transform.  The latter now
allocates its direct table once and resets only the keys touched by the previous
frontier, changing repeated table clearing from `O(DP)` writes to `O(P+DS)`.
The compiled planner uses a conservative occupancy threshold in the antichain
case and the margin-adjusted `P` versus `S^2` rule otherwise.  Planner metadata
is stored in the cold problem object, so dispatch adds no per-transition or
measurable micro-instance rescan.

The orbit splitter has a parallel exact improvement.  For a contiguous split
after family `j`, let

```text
L_j = product_(i<j) b_i,       R_j = product_(i>=j) b_i.
```

Enumeration time is proportional to `L_j+R_j` and right-table storage to
`R_j`.  The production algorithm evaluates every `j`, minimizes
`(L_j+R_j,R_j,j)` lexicographically, and therefore selects the time-optimal
contiguous split while preferring less memory among time ties.  Contiguity
preserves global lexicographic witness order.  On family sizes
`[2,2,2,2,2,2,64]`, this changes 520 half assignments and 511 right states to
128 and 64; the 21-round median improvement is `2.215x`.  Unequal-family tests
compare the complete first witness with DFS for every two-coordinate target.

The final scheduler phase grid uses thirteen `(H,c,D)` shapes, two fixed seeds,
four options per family, `P` from 81 through 1,048,576, five rotated rounds, and
ten solves per sample.  Costs and repair counts agree for sparse, dense,
adaptive, and CP-SAT variants.  CP-SAT constructs its model once and reuses it
across repetitions, matching reuse of the compiled Rust problem.

The adaptive Rust planner selects the faster Rust backend in 25 of 26 profiles;
the single miss costs `1.142x`, while median regret is `1.000x`.  Rust beats
single-worker OR-Tools 9.14 CP-SAT in 24 of 26 profiles, with median `9.18x`
speedup.  CP-SAT wins both `H=10,c=3,D=6` seeds, by `1.37x` and `1.79x`.
Thus the result is a broad bounded win with an observed large-lattice
crossover, not a universal CP-SAT improvement.

The balanced 21-round medians are now 625 microseconds for dense Rust, 1.445
milliseconds for antichain-aware sparse Rust, and 2.404 milliseconds for
reused-model CP-SAT: dense Rust is `3.85x` faster than CP-SAT there.  The old
pre-antichain Rust scan was about 46.2 milliseconds, so the full exact
representation stack is about `74x` faster on the same fixture.  The
small-state medians are 85.5 microseconds for dense Rust and 11.259 milliseconds
for CP-SAT (`131.7x`).

### Refreshed `ej` + `tt` mystery ledger

| Feature | State after the phase map | Exact remaining gate or owner |
|---|---|---|
| fixed-mass scheduler frontiers | **Settled mathematically and computationally:** they are graded antichains, so dominance work is identically redundant | Extend only if a strictly positive nonuniform helper weighting is supplied or cheaply certified |
| sparse/dense Rust selection | **Settled on the bounded grid:** 25/26 correct, maximum regret `1.142x` | Add nonuniform option masses before treating the empirical margins as general defaults |
| CP-SAT superiority question | **Resolved negatively in both absolute directions:** Rust wins 24 profiles, CP-SAT wins the two largest/highest-demand profiles | Broaden capacities, option arities, nonuniform loads, and family-specific competitors before any SOTA claim |
| orbit split position | **Settled for contiguous splits:** exact product balancing minimizes enumeration work and tie-broken table size | Noncontiguous partitions require explicit full-witness ordering and are justified only for highly skew families |
| explicit SIMD | **Still rejected by profile:** state-count and representation invariants produced the gains | No remaining SIMD gate on present workloads |

The Lemire-style surprise is (A37): the best bit hack is to prove the skyline
cannot contain a dominance edge and delete the work.  The Tao-style structural
question now has a concrete answer for one large class—the grading functional
predicts an antichain—and a precise open generalization: find a strictly
positive helper weighting constant on all options.  No correctness mystery
remains in the tested domains.  The genuine evidence gap is the nonuniform-load
phase diagram and comparison with structured application-specific solvers.

## 24. Positive grading certificates for nonuniform loads

The antichain argument does not require equal ordinary option cardinality.
Let every helper weight `w_h` be a strictly positive integer and suppose every
compiled option `o` satisfies

```text
sum_h w_h load_h(o) = m > 0.                              (A38)
```

After `r` repairs, every reachable frontier state `x` therefore satisfies

```text
sum_h w_h load_h(x) = mr.                                 (A39)
```

If `y` dominates `x`, coordinatewise load monotonicity and positivity of every
`w_h` give `w.load(y) <= w.load(x)`, whereas domination also gives
`repairs(y) >= repairs(x)`.  Equation (A39) forces equal repair counts and equal
weighted loads.  The nonnegative coordinate differences then have zero dot
product with a strictly positive vector, so every coordinate is equal.  Since
equal load vectors are interned, distinct frontier states are incomparable.
Thus the entire exact Pareto pass can be omitted.  This is a grading theorem,
not a heuristic.

`WeightedRepairProblem::from_families_with_positive_grading` now accepts the
weights and independently verifies strict positivity, width, checked `u64`
dot products, positive common mass, and equality of that mass across every
compiled option.  Failure returns `InvalidGrading`; the optimization is never
enabled from an unchecked assertion.  The existing constructor still detects
the all-ones special case automatically.  The retained certificate exposes its
weights and common mass for audit.

The deterministic nonuniform phase grid uses nine `(H,c,D)` shapes, two fixed
seeds, four options per family, and five rotated rounds.  Alternating weights
`1,2` give common graded mass `4`, while ordinary option totals vary among
`2,3,4`.  Each profile compares sparse, dense, ungraded adaptive, certified
adaptive, and reused-model single-worker OR-Tools 9.14 CP-SAT.  All checksums
agree.  The adaptive planner chooses the measured faster Rust backend in all
18 profiles (dense in 16 and sparse in 2).

Certification speeds up the same adaptive Rust solver by `3.843x` at the
median and `17.283x` at the maximum; even the minimum is `1.499x`.  Certified
Rust beats CP-SAT in all 18 profiles, with `15.913x` median speedup and `2.478x`
minimum.  The smallest measured case reaches `162.587x`; the narrowest margin
is the `H=8,c=4,D=8`, seed-1 profile, where the state lattice has 390,625
points and the certificate itself still gives `8.500x`.  These are bounded
private results: they establish the usefulness of a proof-carrying structural
shortcut, not general superiority to CP-SAT.

Replay:

```text
nix shell nixpkgs#python3 --command \
  python3 run_benchmarks.py --write --nonuniform-phase-only --phase-rounds 5
```

### Refreshed `ej` + `tt` mystery ledger

| Feature | State after positive grading | Exact remaining gate or owner |
|---|---|---|
| nonuniform graded frontiers | **Settled:** (A38)--(A39) prove they are antichains; exact API verification and differential tests cover the implementation | None for caller-supplied integer weights |
| graded crossover | **Settled on the bounded grid:** planner correct `18/18`; certificate speedup `1.499x`--`17.283x` | Broaden helper capacities and real application-derived option families before a general crossover claim |
| CP-SAT comparison | **Strong bounded result:** certified Rust wins `18/18`, with `2.478x` minimum | Compare against application-specific regenerating-code solvers; CP-SAT remains the generic nearest competitor only |
| grading discovery | **Open:** the runtime verifies but does not search for `w` | Successor owns exact positive rational-kernel feasibility or a clearly bounded integer search |
| nongradable nonuniform loads | **Open:** genuine skylines still require pruning | Successor owns sharper skyline bounds and a representative phase map |

The `ej` pass exposed that the useful object is a proof certificate, not merely
another workload flag: callers can transport algebraic knowledge into the hot
kernel without trusting it.  The `tt` pass isolates the exact remaining
structural question as feasibility of a positive vector in the kernel of all
option-load differences.  No mystery remains for supplied gradings; automatic
discovery and nongradable skyline width are the two honest open boundaries.

## 25. Fused graded scheduler and allocation-free canonical witnesses

Profiling after positive-grading certification showed that the remaining wall
was not feasibility arithmetic.  The generic implementation still copied and
compacted helper-load vectors after every demand, rebuilt a dense incumbent
index, stored narrow packed loads in separate `u128` records, and allocated two
new vectors during nearly every tied final-witness comparison.  On the largest
nonuniform phase profile this amounted to roughly 357 retired instructions per
examined transition even though the antichain theorem had already deleted all
dominance work.

The certified narrow dense kernel now uses

```text
GradedDenseState = (packed_loads: u64, witness: u32, key: u32),
```

an asserted 16-byte, 8-byte-aligned hot record.  It never materializes the
coordinate-load array.  The grading theorem gives another exact deletion: two
states at the same mixed-radix load key have the same repair count, so an
incumbent can never be improved.  Dense lookup therefore needs one membership
bit rather than a `u32` state ID.  At `P=390625`, the table shrinks from about
1.49 MiB to about 48 KiB.  The general graded path likewise keeps append-only
loads and a persistent index instead of recopying live loads and rebuilding
the index after each demand.

Witness nodes now retain their repair depth in their previously reserved word.
Final exact canonical selection traverses tied witnesses into two reusable
scratch vectors.  This preserves the prior lexicographic result while reducing
heap allocation from `Theta(S)` small vectors to two vectors for the entire
selection.  The transition count, peak frontier count, assignment, unmatched
demands, and aggregate helper loads are unchanged.

A 21-round pinned-core old/new interleave on the nonuniform
`H=8,c=4,D=8`, seed-1 profile records 564.7 microseconds for the saved
pre-rewrite binary and 164.7 microseconds for the fused kernel (`3.429x`), with
identical 65,584 examined transitions, 8,385 peak states, and checksum.  Median
process peak RSS falls from 5,588 KiB to 2,632 KiB.  A 2,000-solve `perf stat`
run records about 476,000 cycles, 2.44 million instructions, 494,000 branches,
961 branch misses, and 4,563 cache misses per solve; retired instructions per
transition fall from roughly 357 to 74.

The canonical 21-round balanced fixture is now 94.6 microseconds, versus 671.5
microseconds for certified sparse Rust and 1.226 milliseconds for reused-model
single-worker OR-Tools 9.14 CP-SAT.  This is `12.96x` faster than CP-SAT,
`7.10x` faster than sparse Rust, about `6.61x` faster than the preceding 625
microsecond dense implementation, and about `488x` faster than the original
46.2 millisecond Rust Pareto scan.  The small-state fixture is 15.1
microseconds versus 5.531 milliseconds for CP-SAT (`366.3x`).

After retuning only the cold dispatch model for the cheaper bitmap kernel, the
uniform phase planner chooses correctly in all 26 profiles with maximum regret
`1.036x`.  Rust wins all 26 CP-SAT comparisons, with median `30.52x`, minimum
`2.85x`, and maximum `557.09x` speedup.  This reverses both former
`H=10,c=3,D=6` losses.  A separate `H=12,c=3` diagnostic checks that dispatch
has not collapsed to always-dense: at `D=4`, sparse wins 45.8 versus 91.6
microseconds and is selected; at `D=6`, dense wins 456.5 versus 1,085.2
microseconds and is selected.

The nonuniform harness was also tightened so `winner_dense` compares certified
sparse and certified dense backends, while certificate speedup still compares
uncertified and certified adaptive solves.  The resulting planner score is
18/18.  Certification gives `12.080x` median and `90.412x` maximum speedup over
the same adaptive solver without the certificate.  Certified Rust wins all 18
CP-SAT comparisons, with `51.560x` median and `7.681x` minimum speedup.  Across
the two bounded phase maps Rust therefore wins all 44 reused-model CP-SAT
comparisons; this remains a private workload result rather than a general SOTA
claim.

### Refreshed `ej` + `tt` mystery ledger

| Feature | State after fused grading | Exact remaining gate or owner |
|---|---|---|
| canonical witness allocation wall | **Settled:** two reusable vectors preserve exact ordering and remove per-tie allocation | Apply the helper to any future optimizer whose final-state comparator reconstructs witnesses |
| graded dense representation | **Settled for <=64 packed bits:** one 16-byte state plus one-bit membership is sufficient | Wide packed states still use the general kernel; optimize only with a representative wide workload |
| adaptive crossover | **Settled on 44 phase profiles and two larger-lattice probes:** `44/44` phase choices are correct, and the external probe contains both winners | Broaden application-derived families before changing the default again |
| SIMD | **Still rejected:** fused scalar bit arithmetic now retires about 74 instructions per transition and explicit SIMD does not address allocation or membership initialization | Reconsider only if a future profile isolates a vector-width feasibility loop |
| automatic grading discovery | **Open and now higher leverage:** every discovered certificate can dispatch into the fused kernel | C962 successor owns exact positive-kernel feasibility |
| nongradable skyline width | **Open:** the fused theorem-specific path gives no new bound for genuine skylines | C962 successor owns structural width bounds and application-derived tests |

The `ej` result is that grading certificates now carry more operational value
than merely deleting Pareto comparisons: they justify a smaller state type and
a 32-fold smaller membership representation.  The `tt` question is whether a
positive grading can be found cheaply enough at compile time that callers need
not supply it.  For the certified narrow class no unresolved implementation
mystery remains; the honest boundary is certificate discovery and the geometry
of nongradable skylines.

## 26. Exact coded witnesses and top-down slot analysis

The allocation-free scratch comparator in Section 25 still wrote two complete
parent chains for every tied final state.  Positive grading supplies a finite
repair-depth bound

```text
R <= min(D, floor((sum_h w_h c_h) / m)).                 (A40)
```

Let `B` be one plus the number of globally compiled options and encode a
length-`r` witness with option IDs `o_i` by

```text
code(o_1,...,o_r) = sum_(i=1)^r (o_i+1) B^(r-i).         (A41)
```

Compiled option IDs are assigned in demand order, so ordering equal-length ID
sequences is exactly ordering the corresponding `(demand, option)` witness
sequences.  If `B^R` fits `u64`, ordinary unsigned code comparison therefore
replaces the entire parent-chain walk without hashing or collision risk.  The
fit is proved once with checked multiplication.  If it fails, the solver uses
an exact iterative linked comparator; it never truncates or accepts a
probabilistic fingerprint.

The code is fused with the witness record:

```text
GradedWitnessNode = (lex_code: u64,
                     parent: 24 bits, repairs: 8 bits,
                     option: u32).
```

This remains an asserted 16-byte record.  The dense-state ceiling proves that
24 parent bits suffice, and the specialized kernel dispatches only when (A40)
is at most 255; larger depths use the generic exact dense kernel.  Tests cover
both a 70-repair instance that overflows (A41) and exercises the linked fallback
and a 256-repair instance that crosses the packed-depth dispatch boundary.
Demand IDs need not occupy the hot record: reconstruction scans the cold,
contiguous family option intervals after the optimum is known.

Against the saved Section-25 binary, the iterative comparator alone improved
the largest nonuniform profile by `9.1%` and the balanced profile by `8.5%`.
The exact coded-witness stream then improved the former by a further `8.8%`.
Fusing the code into the 16-byte witness node improved it by another `3.1%`
(`279.7` to `271.2` microseconds in a 21-round, 50-solve interleave) and the
balanced profile by `5.6%` (`134.6` to `127.4` microseconds), with identical
work, frontier peaks, checksums, and exact outputs.

Fresh full-matrix evidence is intentionally reported independently of those
same-host binary A/Bs.  The 26-profile uniform planner is correct `26/26`, has
maximum measured regret `1.039x`, and beats reused-model single-worker OR-Tools
9.14 CP-SAT `26/26`, with `40.86x` median, `4.33x` minimum, and `574.01x`
maximum speedup.  The 18-profile nonuniform planner is correct `18/18`;
certification gives `13.234x` median and `120.037x` maximum speedup over the
uncertified adaptive solver, and certified Rust beats CP-SAT `18/18` with
`65.061x` median and `8.597x` minimum speedup.  The fresh balanced interleave is
164.2 microseconds for dense Rust versus 2.235 milliseconds for CP-SAT
(`13.61x`); the fresh small-state comparison is 39.6 microseconds versus 11.311
milliseconds (`285.7x`).  Absolute times moved with host conditions, while the
rotated within-run ratios remain the comparison evidence.

On AMD Ryzen AI 9 HX 370, a pinned 4,000-solve `perf stat` run on
`H=8,c=4,D=8`, seed 1 records approximately 661 thousand cycles, 2.012 million
instructions, 341 thousand branches, 454 branch misses, 961 cache misses, and
27.9 thousand L1 data-load misses per solve.  That is about 61.35 retired
instructions per examined transition, down from roughly 74 in Section 25 and
357 before the fused kernel.  Multiplexed top-down counters attribute 16.0% of
slots to memory-bound backend stalls, 0.7% to core-bound backend stalls, 10.4%
to frontend stalls, 0.1% to bad speculation, and 33.4% to retiring.  Sampling
places 86.0% in the exact solver and 3.7% in `memmove`, mostly vector growth;
witness comparison is no longer a named hotspot.

Four plausible representation changes were measured and rejected.  A parallel
lex-prefix side vector gained only `1.8%` while adding about 308 KiB RSS.  Two
alternating frontier buffers lost `2.8%`; an in-place frozen-prefix frontier
lost about `7%`; and cold precompiled narrow deltas/strides lost `1.5%` while
raising memory pressure.  All four were reverted.  The top-down evidence also
rejects explicit SIMD for this profile: arithmetic execution is not the wall,
whereas irregular membership/frontier memory traffic is.

### Refreshed `ej` + `tt` mystery ledger

| Feature | State after coded witnesses and TSA | Exact remaining gate or owner |
|---|---|---|
| canonical witness comparison | **Settled:** exact mixed-radix codes handle the bounded fast case and an iterative parent walk handles overflow | None; both overflow and depth-dispatch boundaries have direct tests |
| hot witness representation | **Settled for the narrow kernel:** code, parent, depth, and option fit one 16-byte node | Keep the generic record for more than 255 repairs or more than 24-bit dense state IDs |
| SIMD and bit hacks | **Settled on the profiled class:** packed feasibility and one-bit membership already expose the useful word-level parallelism | Reopen only if a different profile makes a regular arithmetic loop hot |
| remaining allocator traffic | **Measured, not yet settled:** `memmove`/growth is the only named nonsolver user-space hotspot | A reusable caller-owned solve workspace is the next defensible experiment; require exact parity and interleaved memory/time evidence |
| phase-map advantage | **Strengthened:** Rust wins all 44 bounded CP-SAT comparisons, at `40.86x` and `65.06x` median on the two maps | Application-derived competitors and workloads remain mandatory before any general SOTA statement |

The Lemire-style result is not a clever hash: (A40) makes a collision-free
machine-word ranking possible, and its checked failure condition selects an
exact fallback.  The top-down view now says the next potential gain is lifetime
architecture—reusing allocation capacity and membership storage across solves—
not another scalar instruction trick.  This remains private code-and-math
evidence; no paper or public-facing material is changed.

## 27. Reusable exact solve workspace

The allocation profile in Section 26 came from callers solving many instances
of one compiled problem while every call discarded frontier, witness,
membership, and narrow packing buffers.  `WeightedRepairWorkspace` now retains
those allocations across calls.  It is a cold, caller-owned object, contains no
logical solver state after a call, and can be reused across different compiled
problems.  The existing one-shot methods construct a temporary workspace, while
`solve_adaptive_with_workspace` and `solve_dense_lattice_with_workspace` expose
reuse without changing result ownership.  `shrink_to_fit` explicitly releases
excess retained capacity after a workload-size change.

The hot records remain the asserted 16-byte `GradedDenseState` and
`GradedWitnessNode`.  Reuse applies to two contiguous frontier vectors, the
one-bit membership lattice, the witness arena, mixed-radix strides and option
deltas, packed feasibility metadata, and cold reconstruction scratch.  Every
solve clears logical lengths and membership bits before use.  There are no raw
pointers, dynamic containers inside hot records, or problem-specific cached
identities that could survive into a later problem.

A 21-round pinned-core rotated interleave compares the ordinary adaptive API
with the retained-workspace API on three deterministic profiles:

| Profile | One-shot | Workspace | Speedup | Median workspace RSS |
|---|---:|---:|---:|---:|
| balanced `H=6,c=3,D=11` | 11.861 us | 10.284 us | `1.153x` | 2,336 KiB |
| small-state `H=4,c=2,D=80` | 15.970 us | 15.013 us | `1.064x` | 2,336 KiB |
| large nonuniform `H=8,c=4,D=8`, seed 1 | 276.123 us | 163.563 us | `1.688x` | 2,732 KiB |

The paired variants have identical examined-transition counts, peak frontier
counts, repair counts, witnesses, unmatched demands, and helper loads.  Median
process peak RSS is unchanged within measurement noise because the one-shot
solver already reaches comparable peak capacities; the improvement is reuse,
not a larger resident cache.

On the large profile, a pinned 4,000-solve run takes about 148 microseconds per
solve.  Relative to the one-shot Section-26 counters, last-level cache misses
fall from about 961 to 181 per solve and L1 data-load misses from about 27.9 to
20.4 thousand.  Retired instructions remain essentially unchanged at about
61.3 per transition, confirming that the gain is memory lifetime and cache
state rather than deleted mathematical work.  Sampling moves `memmove` from
3.7% to 0.9%; `realloc` disappears below the reported threshold.  Top-down
slots improve from 10.4% to 4.4% frontend-bound, 16.0% to 12.9% memory-bound,
and 33.4% to 38.0% retiring; the multiplexed values remain approximate.

A post-refactor refresh of the complete one-shot regression matrices supersedes
the host-sensitive absolute figures in Section 26.  The uniform planner remains
correct `26/26`, now with `1.072x` maximum regret, and Rust beats CP-SAT `26/26`
with `41.441x` median, `5.257x` minimum, and `567.877x` maximum speedup.  The
nonuniform planner remains correct `18/18`; certification gives `13.464x` median
and `110.642x` maximum speedup, while certified Rust beats CP-SAT `18/18` with
`76.703x` median and `9.339x` minimum speedup.  The balanced one-shot dense
fixture is 174.9 microseconds versus 2.194 milliseconds for CP-SAT (`12.540x`),
and the small-state fixture is 34.0 microseconds versus 11.146 milliseconds
(`327.600x`).  Thus temporary-workspace delegation introduces no correctness or
bounded crossover regression; the optional retained workspace supplies the
additional repeated-solve gain.

### Refreshed `ej` + `tt` mystery ledger

| Feature | State after workspace reuse | Exact remaining gate or owner |
|---|---|---|
| repeated-solve allocation churn | **Settled:** retained contiguous buffers give `1.064x`--`1.688x` on the three measured profiles | Broaden only when a real caller has a different solve-size distribution |
| workspace correctness across problems | **Settled:** logical buffers reset every call and a direct test alternates two problem shapes through one workspace | None for the narrow exact kernel; other backends deliberately keep their existing path |
| residual `memmove` | **Explained:** it is the exact cumulative frontier copy between demand layers, now `0.9%` of samples | The measured share is too small to justify another in-place/arena rewrite; the prior in-place experiment lost about `7%` |
| membership clearing | **Open but low leverage:** sequentially clearing about 48 KiB remains visible only inside the solver aggregate | Test touched-word epochs only on substantially sparser large lattices; the present profile touches most words |
| result allocation | **Required by the owning-result API and below the sample threshold** | A borrowed-result API would change downstream shape and is not justified by current evidence |

The unexpected result is that allocator churn amplified cache misses far beyond
its direct `realloc` samples: retaining capacity cuts the large-case wall by
41% without reducing instructions or mathematical work.  After reuse,
frontier copying is under 1% and the next easy instruction-level optimization
is not visible.  This remains private C962 code-and-math evidence and is not
exported or committed.

## 28. Tiger-style L1D packing and L1I audit

The retained-workspace kernel still read a 16-byte witness node while expanding
states.  Half of that record was the exact lexicographic code and repair depth,
although neither belongs intrinsically to the parent edge.  The dense-state
ceiling and depth dispatch give two independent range proofs:

```text
0 <= lattice_key < 2^24,          0 <= repair_depth <= 255.   (A42)
```

The state therefore stores `lattice_key | (repair_depth << 24)` in its existing
`u32` word.  Its representation remains

```text
GradedDenseState = (packed_loads: u64,
                    witness: u32,
                    key_and_depth: u32),
```

with asserted size 16 and alignment 8.  The witness arena becomes

```text
GradedWitnessNode = (parent: u32, option: u32),
```

with asserted size 8 and alignment 4.  These are explicit `repr(C)` records in
contiguous vectors; there are no pointers, implicit-layout assumptions, or
owned containers in hot records.

Exact canonical ordering is preserved without keeping lexicographic codes hot.
Parents are always created before children, so after the DP an optional
sequential pass computes

```text
code[v] = code[parent[v]] B + option[v] + 1.             (A43)
```

when the checked `u64` bound from (A40)--(A41) fits.  The final state scan then
uses these codes.  On overflow it retains the exact iterative parent-chain
comparison.  Thus the transition loop neither reads a witness merely to obtain
depth nor reads and extends a lex code; the only accepted-transition witness
operation is appending the 8-byte parent edge.

A 21-round pinned-core saved-binary interleave gives:

| Profile | 16-byte hot-code witness | 8-byte deferred-code witness | Speedup |
|---|---:|---:|---:|
| balanced graded `H=6,c=3,D=11` | 10.091 us | 8.155 us | `1.237x` |
| small-state `H=4,c=2,D=80` | 14.896 us | 12.152 us | `1.226x` |
| large nonuniform `H=8,c=4,D=8`, seed 1 | 161.052 us | 134.769 us | `1.195x` |

Every pair has identical transitions, frontier peak, checksum, exact witness,
unmatched demands, and helper loads; RSS differences are noise.  On the large
case, pinned counters move from approximately 62.5 to 51.5 retired instructions
per examined transition and reduce L1D misses by about 11%.  The improvement is
larger than the byte-volume estimate because it also removes checked multiply
and parent-code dependency work from accepted transitions.

The instruction-locality audit found a different answer.  L1I misses are only
a few dozen per solve, the instruction-cache fetch-miss ratio is about `0.1%`,
and the operation-cache miss ratio is about `4.2%`.  LLVM had folded the graded
kernel into a roughly 16.5 KiB dispatch symbol.  Forcing the approximately 7.7
KiB graded kernel out of line measured `1.018x`, `1.009x`, and `0.999x` on the
same three profiles: a wash, so the annotation was reverted.  The selected
glibc copy path is `__memmove_avx512_unaligned_erms`; at about `1.2%` of samples,
hand-written REP/AVX copying has insufficient possible leverage and would add
architecture-specific code.

### Refreshed `ej` + `tt` mystery ledger

| Feature | State after the locality pass | Exact remaining gate or owner |
|---|---|---|
| L1D witness traffic | **Settled:** range proofs pack depth into the state and halve the witness edge to 8 bytes; deferred sequential ranking adds `1.195x`--`1.237x` | None for the certified narrow kernel |
| L1I capacity | **Settled on the measured profiles:** fetch misses are about `0.1%` and out-of-line layout is a wash | Reopen only if a wider application-derived kernel changes the counter attribution |
| operation-cache misses | **Measured at about `4.2%`, but not responsive to simple function splitting** | A loop-body assembly rewrite is unjustified without a larger frontend-bound profile |
| REP/ERMS copy path | **Settled:** libc already selects AVX-512/ERMS and all copying is about `1.2%` of samples | No manual copy implementation |
| state layout | **Settled at 16 bytes:** packed loads plus two range-packed words give four states per cache line | SoA would save at most the conditionally used witness word while adding streams and is not supported by the present profile |

The Lemire-style gain is again a range proof rather than an intrinsic: the
24-bit state-space bound supplies a free byte exactly where repair depth is
needed.  The I-side result is useful negative evidence—large symbol size did
not imply L1I pressure.  The remaining measured wall is the exact transition
loop and membership access, not allocation, witness metadata, copying, or
instruction-cache misses.

## 29. Criterion gate and architecture selection

The locality kernel now has a Criterion target rather than relying only on
whole-process timing.  Criterion 0.7 is the newest release line compatible with
the crate's declared Rust 1.82 minimum; Criterion 0.8 requires Rust 1.86.  The
`scheduler_locality` benchmark constructs the same three deterministic graded
problems, warms one reusable workspace, black-boxes each owned result, reports
examined-transition throughput, and uses 60 samples after two seconds warmup
with four seconds measurement per profile.

The bench profile explicitly matches production optimization: level 3, thin
LTO, and one codegen unit.  This matters because Criterion's default non-LTO
profile produced dramatically smaller harness-local times.  A saved-binary
rotated A/B rejected that apparent improvement: disabling thin LTO and restoring
default codegen partitioning was actually `0.982x`--`0.991x` as fast.  Criterion
absolute values are therefore used only as within-harness regression baselines;
cross-version performance conclusions continue to require the pinned binary
A/B harness.

With the final production-equivalent profile and chosen architecture, Criterion
reports:

| Profile | 95% time interval | Point estimate | Transition throughput point estimate |
|---|---:|---:|---:|
| balanced graded | 3.781--3.811 us | 3.794 us | 729.05 million/s |
| small-state | 7.312--8.729 us | 8.097 us | 480.19 million/s |
| large nonuniform | 67.385--68.821 us | 67.941 us | 482.65 million/s |

The repository Queens engine pins `znver5` on this Ryzen AI 9 HX 370, but that
policy is workload-specific.  This scheduler is scalar and bitmap-heavy; it
does not benefit from the same wide bitboard instruction selection.  Three
21-round binary comparisons against generic x86-64 establish the scheduler's
own architecture choice:

| Target CPU | Balanced | Small-state | Large nonuniform |
|---|---:|---:|---:|
| `x86-64-v3` | `1.032x` | `1.055x` | `1.029x` |
| `znver3` | `1.027x` | `1.051x` | `1.032x` |
| `znver5` / `native` | `0.864x` | `0.889x` | `0.860x` |

The private crate therefore pins `target-cpu=x86-64-v3`: it wins two profiles,
is within 0.3% of `znver3` on the third, is reproducible on modern x86-64
machines, and avoids the 11--16% `znver5` regression.  This is an empirical
code-generation choice, not a claim that AVX-512 is intrinsically slow.  The
solver still contains no architecture-specific intrinsic or unsafe path.

The final full-matrix refresh uses this exact `x86-64-v3` build.  The uniform
planner remains correct `26/26`, with `1.115x` maximum regret, and Rust beats
CP-SAT `26/26` with `48.103x` median, `5.104x` minimum, and `622.288x` maximum
speedup.  The nonuniform planner remains correct `18/18`; certification gives
`16.105x` median and `140.506x` maximum speedup, while certified Rust beats
CP-SAT `18/18` with `73.352x` median and `11.634x` minimum.  The balanced
one-shot dense fixture is 144.0 microseconds versus 2.246 milliseconds for
CP-SAT (`15.599x`), and the small-state fixture is 26.4 microseconds versus
11.082 milliseconds (`420.182x`).  These final values supersede the earlier
host-sensitive refreshes in Sections 26--27.

### Refreshed `ej` + `tt` mystery ledger

| Feature | State after Criterion and arch sweep | Exact remaining gate or owner |
|---|---|---|
| statistical microbenchmarking | **Settled:** Criterion supplies warm-workspace confidence intervals and throughput | Preserve the rotated binary harness for cross-version and competitor claims |
| release LTO policy | **Settled:** executable A/B keeps thin LTO and one codegen unit; Criterion's contrary default-profile signal was a harness mismatch | Reopen only with a production-binary comparison |
| target CPU | **Settled on the three locality profiles:** `x86-64-v3` gives `1.029x`--`1.055x`; `znver5` loses 11--16% | Recheck only after materially changing the hot loop or deploying to a different microarchitecture |
| AVX-512 opportunity | **Resolved negatively for current automatic code generation:** enabling the Zen 5 target hurts all profiles | Explicit SIMD still requires a newly measured regular hot loop, which this kernel lacks |
| Criterion/process absolute-time gap | **Explained operationally but not normalized:** distinct harness/link contexts yield different absolute times | Do not compare the absolutes; use each harness longitudinally for its declared purpose |

The surprising result is architectural: the right flag for this Zen 5 machine
is not the widest host target.  The robust choice came from isolating target
CPU behind an unchanged exact kernel, not from assuming the Queens policy
transfers.  No unresolved L1I-capacity or copy-path opportunity remains in the
measured profiles.

## 30. C949-derived algorithmic continuation

The newer C949 shell, defect, and signed-descent results change the preferred
algorithmic order.  C962 will pursue the following private code-and-mathematics
work before any manuscript follow-up:

1. replace full-box addressing, when profitable, by exact graded-shell ranks
   and then refine the shell with a convex moment-defect budget;
2. exploit the exact defect-19 identity in the remaining
   `q=27,T=54` branch through canonical exceptional-point enumeration and
   immediate pencil/line-cap propagation;
3. generalize field row-space compression to Smith-invariant and prime-power
   liftability states for hierarchical storage repair; and
4. compile the C949 `+1` triangular target into a colored near-perfect-matching
   solver carrying the singleton-product, direction-cap, moment, and
   Prony/reversal constraints.

The first item is the active implementation target.  For grading weights
`w_h`, capacities `c_h`, common option mass `m`, and repair depth `r`, its exact
address-space bound is

```text
N_r = [x^(rm)] product_h (1+x^(w_h)+...+x^(w_h c_h)).
```

Thus the dense kernel need store only `sum_r N_r` membership bits over the
reachable depths, rather than `product_h(c_h+1)` bits over the full capacity
box.  A direct bounded-composition rank must preserve exact duplicate
suppression and witnesses; Python/direct-enumeration parity remains the first
acceptance gate.

The first Rust implementation now constructs all suffix coefficients in
`O(HM)` time, where `M=mR` is the maximum reachable grade, using sliding sums
inside each residue class.  It stores residue-prefix coefficients so the
lexicographic rank of a packed load vector costs `O(H)`, independent of the
coordinate values.  The existing 24-bit key and one-bit membership kernel are
unchanged.  On capacities `(4096,4096,4096,4096)`, weights `(1,2,1,2)`, common
option mass four, and eight demand families, the full box has
`4097^4` states while the nine depth shells contain only 4,845 bounded load
vectors.  Exact sparse/dense outputs agree.  Criterion 0.7 measures the
shell-ranked solver at 75.047 microseconds and the sparse Pareto solver at
240.96 microseconds, a `3.211x` advantage on this enabling case.  The literal
predecessor ranker initially measured 459.02 microseconds; replacing its
`O(sum_h load_h)` loops by residue-prefix differences is the accepted
algorithmic change.

The moment refinement is not a sound generic recovery prune without an
application-supplied defect theorem.  C949 supplies one for the remaining
`q=27,T=54` branch, so the second item now owns that refinement.  Writing `d`
for the number of the 54 maximal secants through a point, the exact scalar
constraints are

```text
sum_(P in A) d_P = 1026,       |A| = 279,
sum_(P outside A) d_P = 486,   |PG(2,27) - A| = 478,
sum_(P in A) binom(d_P-3,2)
  + sum_(P outside A) binom(d_P-1,2) = 19.
```

A new sparse histogram oracle enumerates only degrees outside the two
zero-defect pairs `(3,4)` and `(1,2)`; their two bulk multiplicities are then
forced by the point and degree sums.  It finds 2,653 internal histograms and
only 20 external histograms over all defect values zero through nineteen;
matching complementary defects leaves exactly 3,435 arithmetic histogram
pairs.  Every pair replays both incidence sums and defect 19, and a labelled
small-instance brute-force test independently checks the sparse enumerator.
This is the first gate of the canonical exceptional-point solver; spatial
incidence realization, not scalar arithmetic, is now the remaining branch.

## 31. Raw and structurally strengthened CP-SAT

The primary CP-SAT comparison now has two controls.  The raw control receives
the generated Boolean option model.  The strengthened (`naughty`) control
receives the same feasibility filtering, duplicate removal, Pareto
canonicalization, certified grading repair bound, deterministic single-worker
setting, reused model, and reusable solver object available without importing
the custom dynamic program.  Rust receives the same canonical options and a
reusable allocation workspace.  All variants agree on optimum cardinality.

An 11-round rotated interleave gives:

| profile | Rust | raw CP-SAT | strengthened CP-SAT | Rust/raw | Rust/strengthened |
|---|---:|---:|---:|---:|---:|
| shell large-box | 73.358 us | 185.256 us | 185.300 us | 2.525x | 2.526x |
| balanced | 3.566 us | 1.122 ms | 1.200 ms | 314.674x | 336.514x |
| small-state | 5.052 us | 2.860 ms | 2.834 ms | 566.202x | 560.936x |
| large nonuniform | 59.031 us | 1.268 ms | 1.067 ms | 21.481x | 18.074x |

The shell case is the clean isolation: canonicalization changes none of its
32 options, the grading bound is the trivial exact depth eight, and both
CP-SAT variants prove optimality at the root with zero branches and conflicts.
The remaining `2.526x` advantage therefore measures the specialized
shell-ranked execution against an already structurally informed generic
solver, not a weak CP-SAT search tree.  The much larger small and balanced
ratios are latency/representation wins on tiny exact frontiers and should not
be extrapolated to large difficult integer programs.

## 32. Exact spatial defect-19 oracle

The `q=27,T=54` arithmetic shell now feeds an exact dual-plane model.  A bit
`a_L` selects each of the 757 dual lines corresponding to an arc point, and a
bit `m_P` marks each dual point corresponding to a 19-secant.  The model
enforces

```text
sum_L a_L = 279,                 sum_P m_P = 54,
sum_(L through P) a_L <= 18+m_P,
sum_(L through P) a_L >= 19m_P,
d_L = sum_(P on L) m_P,
d_L >= 1 whenever a_L=0.
```

Thus `m_P` is equivalent to degree nineteen, the cap is exact, and the last
condition is precisely completeness.  Each line chooses one of seventeen
possible zero-to-19-defect types: internal degrees zero through nine or
external degrees one through seven.  Their global multiplicity vector is
constrained directly to one of the 3,435 certified histogram pairs.  Projecting
by the centered word `u=1+3a-d` collapses those pairs to 1,496 distinct signed
spectra, all with sum 82, squared norm 136, and support between 79 and 136.
The model includes this smaller projection table as a redundant propagation
shortcut.  The compiled model has 15,168 variables and 5,335 constraints.

The projective design identity

```text
sum_(L through P) d_L = 54+27m_P
```

For the centered word it also uses the exact pencil identity

```text
sum_(L through P) u_L
  = 3 sum_(L through P) a_L - 27m_P - 26,
```

whose reduction modulo three is the affine incidence-code condition that
every pencil sum is one.  With these centered pencil variables the current
model has 15,925 variables and 6,849 constraints.

is inserted explicitly at all 757 points.  A safe normalization fixes one
maximal point, one selected and one external line through it, and a second
maximal point on the selected line.  The latter exists because nineteen
selected anchor lines of degree one would already contribute defect 57.
Projective transitivity on the resulting ordered flag makes the normalization
lossless.  Any feasible solver output is independently replayed from its two
index sets, including cap, completeness, maximal-set equality, defect,
selected incidence sum, pair sum, and the full line-type spectrum.

Bounded deterministic searches are profiling evidence only.  The initial
local-table model returned `UNKNOWN` after 60 seconds with 38,101 branches.
Compiling the exact histogram shell returned `UNKNOWN` with 28,368 branches;
the current design-identity model also remains `UNKNOWN` at 60 seconds.  A
matched 30-second maximal-set-first search produces 58 conflicts versus zero
under automatic branching, but neither is decisive.  A 16-worker 60-second
feasibility probe is likewise `UNKNOWN`.  No infeasibility or existence claim
follows.  The evidence gap is now purely spatial: realize or exclude one of
the certified line-type distributions, preferably with a custom bitset
canonical-augmentation engine rather than further undirected CP-SAT widening.

The centered-spectrum table reduces a matched 30-second automatic run from
24,578 to 17,082 branches.  Adding the exact centered pencil identities cuts
that again to 9,940 branches and lowers deterministic search time from 83.98
to 61.55, while remaining correctly `UNKNOWN`.  This is the accepted
strengthened CP-SAT baseline for the next custom-engine comparison.

The custom Rust path has begun at the representation boundary.  `GF(9)` and
`GF(27)` arithmetic is table-driven during compilation; the resulting
self-dual `PG(2,q)` incidence relation is stored as one flat `u16` array of
fixed stride `q+1`, with no per-line allocation or pointer chase.  The 757
points are compact four-byte records.  Rust checks both plane orders and pins
the complete ordered incidence arrays to Python-oracle FNV hashes
`11772883917756675483` and `2893137983085941033`.  The next hot state can
therefore update the 28 affected line degrees of a candidate maximal point by
contiguous indices; canonical augmentation and centered-spectrum feasibility,
not field arithmetic, own the remaining search design.

## 33. Custom maximal-point augmentation and signed defect repair

The first Rust search kernel is now complete enough to replace CP-SAT on a
useful class of conditioned branches.  Its mutable state is the selected-point
bitmap plus one contiguous byte per dual line.  Adding a maximal point touches
exactly its 28-line pencil and maintains a 32-byte degree summary; rollback
touches the same pencil.  A tracked maximum removes the cap scan until some
line actually reaches degree nine.  Criterion measures a complete push plus
rollback at 70.99 ns, with no allocation per node.

The 3,435 labelled internal/external shell pairs collapse to 1,013 distinct
combined line-degree profiles.  For a partial maximal set, sort its current
line degrees as `x_i`, sort a target profile as `y_i`, and let `R=54-|D|`.
A necessary and sufficient matching condition for the relaxed degree
histograms is

```text
x_i <= y_i <= x_i+R  for every i.
```

Equivalently, the current and target degree tails satisfy two families of
dominance inequalities.  This relaxation forgets which projective line owns a
degree, so failure is a rigorous impossibility certificate while survival is
not a realization claim.  All 1,013 exact terminal profiles pass the filter in
an independent exhaustive unit test.  A separate exhaustive four-line oracle
tries every assignment between current and target multisets for remaining
increments zero, one, and two; it agrees with the two tail inequalities in
every case.

The first scalar implementation rescanned surviving 32-byte profile records
and cost 1.193 us for a parent/child refine and rollback.  The accepted version
precomputes lower- and upper-threshold bitmaps.  Its 1,013 active bits and its
rollback delta are each exactly 128 bytes, aligned to cache lines; refinement
is dense wordwise intersection with no target branches or undo allocation.
The cold threshold tables occupy 599,552 bytes and the packed profile records
32,416 bytes.  Criterion reduces the same refine/rollback to 18.22 ns, a
`65.5x` representation win.

Lexicographic augmentation enumerates every normalized point-set extension
once.  It does not yet quotient the residual projective stabilizer, so
"canonical" here means duplicate-free combination generation relative to the
caller's fixed normalization, not isomorph-free generation.  It retains the
first surviving point-set witness with one terminal-only allocation.  On the
fixed deterministic depth-34 prefix, extending two levels gives:

| kernel | nodes | depth-36 survivors | Criterion time |
|---|---:|---:|---:|
| degree cap only | 261,726 | 261,003 | 16.027 ms |
| defect catalogue | 18,897 | 7 | 1.378 ms |

Thus the arithmetic catalogue removes `92.78%` of nodes and is `11.63x`
faster end to end on this winning case.  The shallow depth-30 case is an
important negative control: it removes only 87 of 263,901 terminals and adds
about 12% wall time even after bitmap compilation.  The filter therefore has
to be staged by expected selectivity rather than called dogmatically.  A
run-time "provably vacuous" dispatch was also tested and reverted: its extra
hot state/code paths regressed the selective scan by 4% and the conditioned
proof by 14%, despite skipping masks near the root.

Running the depth-34 branch all the way to 54 closes it after 19,468 nodes with
no surviving maximal set.  Criterion gives 1.403 ms.  The strengthened,
single-worker CP-SAT v9 model receives the identical 34 forced maximal points,
no additional normalization, the full histogram and centered-pencil
constraints, and returns `INFEASIBLE` with zero branches/conflicts but 3.228
deterministic seconds; three solver-wall observations are 4.693, 4.798, and
4.761 seconds.  A 1,000-run release probe gives 1.409 ms for the current Rust
path, or about `3380x` at the median CP-SAT wall time.  This is a fair comparison of the
conditioned **decision outcome**, but not of identical internal models: Rust's
weaker degree relaxation happens to decide the branch before the spatial arc
variables are needed.  The correct production comparison is consequently
the custom prefilter followed by CP-SAT on survivors, not naked Rust versus
naked CP-SAT.  These deterministic prefixes are diagnostic branch fixtures,
not a SOTA instance family or a resolution of the open C949 case.

The next terminal filter uses another latent consequence of defect 19.  For a
completed maximal set, choose the cheaper line label as baseline: degrees one
and two external, and degrees zero or at least three internal.  The baseline
defect contributions for degrees zero through nine are

```text
6, 0, 0, 0, 0, 1, 3, 6, 10, 15.
```

Every permitted label flip changes the internal-line count by one and costs

```text
d=1,2:  +1 internal at cost 3,1;
d=3,4,5,6,7:  -1 internal at cost 1,3,5,7,9.
```

The total residual budget is at most nineteen.  A word-packed signed knapsack
therefore checks the exact remaining defect and the required total of 279
internal lines in `O(757*19)` bit operations.  For each projective point, a
second budget-19 DP tests whether its 28 incident flips can reach degree 19
when the point is maximal or remain at most 18 otherwise.  The maximum of the
757 local minimum costs is a valid global lower bound.  This spatial filter is
now wired at complete maximal sets; it is necessary rather than sufficient
because the local witnesses need not be mutually compatible.  Turning those
local repairs into one exact shared flip witness is the next bounded-search
step.

`perf stat` on the depth-34 winning branch records about 335 cycles and 1,492
instructions per visited filtered node.  L1D misses are approximately 0.42 per
node (`0.078%` of reported loads), with essentially no last-level misses.
Interleaved 2,000-solve architecture probes give 2.65 s for `x86-64-v3`, 2.73 s
for `native`, and 2.72 s for `znver5`; host-wide AVX-512 code generation is
therefore still a 3% loss on this new bitmap search.  The existing reproducible
`x86-64-v3` pin remains correct, and no hand-written SIMD or unsafe path is
justified by the counters.

The next exact symmetry reduction is now pinned at the API boundary.  After
fixing two ordered maximal points `P,Q`, their pointwise projective stabilizer
has

```text
27^2 (27-1)^2 = 492804
```

elements.  It has one 26-point orbit on `PQ-{P,Q}` and one 729-point orbit off
`PQ`.  Since a projective line has only 28 points, a 54-point maximal set must
contain an off-line point; transitivity therefore fixes a third maximal point
off `PQ` without loss.  The three points form the coordinate frame.  Its
pointwise stabilizer is the diagonal torus of order `(27-1)^2=676`, and the
remaining 754 points split into four exact orbits: the three 26-point side
interiors and the 676 points off the coordinate triangle.  Rust constructs
these four contiguous witness lists and tests sizes `[26,26,26,676]`, canonical
representatives `[730,1,27,28]`, disjointness, and full coverage.

This frame reduction is presently a proved normalization boundary, not yet an
orbit-canonical recursive search.  It is the highest-leverage next step: the
first free maximal-point branch drops from 755 labelled candidates to one
forced off-line representative, after which the residual 676-element torus
can drive stabilizer-orbit augmentation.  That should be developed before
more per-node SIMD work or another undirected CP-SAT widening.

The same third-point equation was tested as an additional CP-SAT symmetry
break.  It is exposed behind `--frame-normalize` but is not the default: in a
matched deterministic 15-second automatic search it changed 11,084 branches
and 17.880 deterministic-time units into 13,038 branches, six conflicts, and
22.546 units, with both runs still `UNKNOWN`.  The safe group reduction is
valuable for an orbit-aware custom enumeration, but CP-SAT's search heuristic
does not automatically exploit the smaller representative space.  A matched
maximal-first run confirms the negative: 11,076 branches and 16.333 units
without the extra frame equation versus 13,034 branches and 22.855 units with
it, again both `UNKNOWN`.

## 34. New C949 balanced-endpoint compilation

The refreshed C949 result set changes the best algorithmic target beyond the
older `T=54` defect search.  On its sharp `+1` triangular branch, projective
shear normalization fixes `w=1` and residual homothety fixes `e_3(U)=1`.
The 104 formerly scaled ratio singleton sets collapse first to four normalized
fibers of

```text
Z(Z+1)^2=kappa,
```

then to two semilinear cases because their `kappa` values have Frobenius
orbits `{2}` and `{18,23,26}`.  This is an exact factor-two reduction of the
normalized downstream searches, not a heuristic symmetry break.

For a fixed ordered ratio fiber `(r_1,r_2,r_3)`, the remaining extendable
transversal is generated by distinct nonzero rows

```text
u_1 u_2 u_3=1,              e_i=r_i u_i,
```

discarding only repeated columns.  The two scalar conditions
`sum e_i/u_i=1` and `sum u_i/e_i=1/kappa` are then identities, so they require
neither CP-SAT variables nor propagation. Inclusion--exclusion gives 530
mappings per normalized fiber at `q=27`.  The Python oracle independently
replays 2,120 mappings and 2,116 distinct `(U,E)` pairs over all four fibers,
with multiplicities `1^2112 2^4`; the Rust semilinear quotient has exactly
1,060 mappings and 1,058 pairs with multiplicities `1^1056 2^2`.  The
quotient retains constructive output: a 27-byte cubing table transports every
mapping witness around `{18,23,26}` and the test suite verifies exact closure
after three Frobenius powers.

There is a further latent quotient not stated in the C949 report.  Frobenius
fixes the `kappa=2` fiber setwise and acts on its 530 normalized mappings.  An
independent Python enumeration and the Rust engine agree that this action has
11 fixed mappings and 173 three-cycles, hence 184 mapping orbits.  Each mapping
over `kappa=18` represents one orbit traversing `18,23,26`, contributing 530
more.  Burnside therefore gives the exact full semilinear search count

```text
(2120+2*11)/3 = 714,
```

a `2.969x` reduction from the four normalized mapping pools.  Rust retains a
compact `u16` index for each representative and can transport any returned
witness to every omitted member.

For checkpointing and parallel routing, Rust stores 714 asserted eight-byte
work records `(ratio_case,mapping_index,orbit_size)`.  There are 11 singleton
and 703 triple-orbit records, and their multiplicities sum to 2,120 exactly.
This gives the hard `kappa=2` case 184 independently replayable jobs and the
moving `kappa=18` case 530, without duplicating carrier or field state inside a
task record.
The queue is built once with the catalogue and exposed as a borrowed contiguous
slice, so repeated scheduling allocates nothing.

The quotient is deliberately taken at the joint carrier--mapping boundary.
It would be unsound to discard the other mappings while holding an arbitrary
carrier fixed.  The implementation therefore also transports evaluation
tables by `A'(x^(3^j))=A(x)^(3^j)` and exhaustively checks that the three-cell
avoidance verdict is invariant under joint transport.  The full 530-entry
scan remains the API for an unquotiented fixed carrier.

The Rust-native representation stores each mapping in an asserted 16-byte
record.  Its otherwise spare six bytes cache the three indices `u_i^3` and
the three forbidden values `(r_i-1)u_i`.  Consequently the remaining cell gate

```text
A(u_i^3) != (r_i-1)u_i,             i=1,2,3,
```

is a branch-light scan of 530 records into caller-owned `u16` scratch, with
no allocation and no field arithmetic.  The mapping-independent sorted pair
keys are asserted eight-byte records.  The complete catalogue, including the
new Witt table, coefficient gate, and prebuilt work queue below, occupies
34,052 bytes and remains L1-sized.

The latest C949 pass also closes the previously abstract next lifted moment.
Frobenius thinning reduces the 25 nominal Fourier coordinates to the 17
indices in `1..=25` not divisible by three.  The first independent
post-quadratic constraint is `k=4`; its four-slope carry is the explicit
universal polynomial `Theta_4(u,t;kappa)`.  Rust precomputes
`Theta_4(u,t;kappa)^9` for all `2*27*27=1,458` semilinear cell states.  A
terminal or CP-SAT hybrid can therefore impose the fourth-Witt carrier sum as
one byte lookup per selected cell rather than evaluating Witt arithmetic or
the eighth-order Newton recurrence in the search.  Tests replay the
four-slope fourth-power identity and the polynomial formula on all 1,458
stored states; the current Python audit independently checks the unquotiented
four-fiber formula on 2,916 states.

The still-newer C949 collapse goes further.  After the six-monomial reduction
and structural cancellation, the whole cell sum depends only on
`(a_5,a_6,a_7,a_8)`.  Writing

```text
Delta_A=a_6^9 a_8^9-a_7^18,
```

the two representative gates are exactly

```text
kappa=2:   H_4=-Delta_A,
kappa=18:  H_4=7a_5^9+26Delta_A.
```

Rust compiles both coefficient formulas using table-driven field arithmetic.
The 1,458 cell weights remain useful as an independent replay and as linear
option coefficients, while the four-coefficient API is the cheaper
carrier-level constraint.  An exhaustive `27^4` test checks both specialized
formulas against the general semilinear expression.

The combined support product `K_*` yields one more compact state.  Rust streams
its 54 roots through the descending Newton update for `e_1,...,e_4` in an
asserted eight-byte record, then enforces

```text
e_1=0,             e_2=H_2,             e_4=-H_4-H_2^2.
```

The `e_3` byte is retained but intentionally unconstrained, matching the exact
characteristic-three blind spot.  Tests compare the streaming update with
direct elementary-symmetric enumeration and check that arbitrary `e_3` values
leave the terminal gate unchanged.

This is the right immediate use of the newer result.  The high-fiber
coherence law says any two cubic/quartic fibers determine `(A,C)` and the
other seven are verification-only, which should be the next custom search
state.  By contrast, directly porting the new 702-cell or 7,550-option CP-SAT
models would duplicate generic infrastructure and miss both the two-case
quotient and the coefficient-determination structure.

The first part of that state is now implemented.  If `g` of the nine high
fibers are cubic and the rest quartic, a processed row contributes `-1,0,1`
to `delta=n_2-n_0` according as zero, one, or two of its roots are high, and
the terminal target is `delta=10-g`.  With `R` rows remaining, the exact
prefix ledger applies

```text
delta-R <= 10-g <= delta+R,
fiber_deficit_y <= R,                sum_y fiber_deficit_y <= 2R.
```

It also enforces the individual cubic/quartic caps.  The mutable state is an
asserted 16-byte record containing nine byte counts, row depth, and signed
overlap delta; failed pushes are transactional.  A complete 26-row replay
costs 320 ns in the same loaded-host Criterion session, about 12.3 ns per row.
This is a necessary prefix filter, not the full divided-difference carrier
solver, but it places the new overlap law on the correct hot path.

A pinned release probe replays one million complete ledgers per round.  Across
three rounds (26 million row transitions each), it measures 0.236 seconds,
or 236.3 ns per complete ledger and 9.09 ns per row.  Hardware counters give
37.2 cycles, 145.5 instructions, 27.7 branches, approximately `0.00169` branch
misses, and approximately `0.00005` L1D misses per row.  The 16-byte state and
cache-line-aligned 64-byte specification are fully cache-resident.  A packed-nibble or
explicit-SIMD rewrite would target instruction count rather than a measured
memory bottleneck and is therefore deferred behind integration into the actual
carrier search.

Provisional pinned-core Criterion measurements, taken while the host load was
above twelve and two four-worker C949 CP-SAT jobs were active, are:

| operation | work | point estimate |
|---|---:|---:|
| compile normalized semilinear catalogue | mappings + pairs + orbit quotient + Witt gates | 104.79 us |
| contiguous mapping scan | 530 mappings | 174--187 ns |
| three-evaluation cell-avoidance filter | 530 mappings | 540--559 ns |
| fixed-fiber representative avoidance | 184 mapping orbits | 259 ns |
| fourth-Witt table scan | 729 cells | 199--202 ns |
| high-fiber prefix ledger | 26 row pairs | 320 ns |

These measurements establish that the front end is negligible beside even a
millisecond solver call, but they are deliberately noncanonical until repeated
on a clean host.  The important bound is structural: two exact ratio cases,
714 exact mapping orbits in total, 17 independent Witt coordinates, and a
constant-time table lookup for the first new one.

The matched direct incidence CP-SAT probes show why this compilation matters.
Both four-worker searches retained the full 702-cell parallel-class model and
the extendable-transversal matching variables.  After 1,800 seconds each they
were still `UNKNOWN`:

| semilinear representative | branches | conflicts | status |
|---|---:|---:|---:|
| `kappa=2` | 1,947,011 | 141,374 | `UNKNOWN` |
| `kappa=18` | 153,691 | 10,168 | `UNKNOWN` |

The complementary carrier formulation was also run on both representatives.
It uses 9,126 row-pair variables, all 102 ternary Reed--Solomon component
equations, and all affine direction ledgers, but does not fix a transversal.
Both four-worker 600-second runs were again `UNKNOWN`:

| semilinear representative | branches | conflicts | status |
|---|---:|---:|---:|
| `kappa=2` | 413,160 | 3,600 | `UNKNOWN` |
| `kappa=18` | 54,154 | 103 | `UNKNOWN` |

There is no direct speedup ratio: the Rust component is a lossless compiler and
necessary-condition front end, not yet a complete incidence solver.  The fair
next comparison is therefore direct CP-SAT versus semilinear decomposition plus
prevalidated transversals and the fourth-Witt constraint, with CP-SAT retained
for surviving spatial subproblems.  The tenfold branch-count disparity between
the two representatives also argues for independent work queues and checkpoint
budgets rather than one monolithic solve.

## 35. Continuation closeout (`ej` + `tt`)

Result order after the refreshed C949 pass is now:

1. **Full semilinear mapping quotient.**  The report's four normalized ratio
   fibers reduce to two field cases, and the previously unstated stabilizer
   action on the fixed fiber reduces all 2,120 mappings to exactly 714 joint
   carrier--mapping orbits.  This is the largest new state-count reduction.
2. **Fourth-Witt compilation.**  The first independent post-quadratic lifted
   constraint has both a 1,458-byte option lookup and a four-coefficient
   carrier gate on the two representatives, while Frobenius removes eight of
   the 25 nominal spectral coordinates.
3. **High-fiber prefix bound.**  Cubic/quartic capacity, total deficit, and the
   exact overlap excess now live in a 16-byte transactional DFS state.
4. **Generic-solver baseline.**  Both direct incidence models are still
   `UNKNOWN` at 1,800 seconds and both stronger carrier models are still
   `UNKNOWN` at 600 seconds.  No mathematical existence or nonexistence claim
   uses those statuses.

### Bound verification

- The Python oracle enumerates the four fibers, 530 mappings per fiber, 2,120
  total mappings, 2,116 distinct `(U,E)` pairs, and multiplicities
  `1^2112 2^4`.
- Independent Python and Rust Frobenius enumerations both give 11 fixed
  mappings and 184 orbits in the fixed fiber.  Burnside gives
  `(2120+2*11)/3=714`; the Rust work queue has 11 weight-one and 703
  weight-three records whose weights sum to 2,120.
- Joint mapping/carrier transport preserves the three cell-avoidance
  inequalities exactly.  The fixed-carrier API deliberately retains all 530
  mappings.
- The independent Witt indices are exactly the 17 integers in `1..=25` not
  divisible by three.  Rust replays the fourth-power identity and
  `Theta_4^9` formula on 1,458 representative states; the Python audit checks
  all 2,916 unquotiented states.  A separate exhaustive `27^4` check verifies
  the collapsed `H_4=-Delta_A` and `H_4=7a_5^9+26Delta_A` formulas.
- For the high-fiber ledger, each remaining row can alter `n_2-n_0` by at most
  one, supply at most one incidence to a named fiber, and supply at most two
  total high incidences.  These three observations prove every prefix test.
  Exact terminal rows pass under all 26 cyclic orderings and reversal; an
  overfilled cubic fiber is rejected without mutation.

### Mystery ledger

- **Settled:** the correct normalized transversal case count, full semilinear
  orbit count, witness transport, first independent Witt lookup and
  coefficient gate, and the high-fiber overlap prefix bound.
- **Open and highest value:** integrate carrier canonicalization with the 714
  mapping tasks, then use two seed cubic/quartic factorizations to reconstruct
  `(A,C)` and treat the other seven high fibers as verification constraints.
- **Open:** add the fourth-Witt equality to the surviving spatial model and
  measure the hybrid against the two direct CP-SAT baselines.
- **Open, separate branch:** the unrestricted `T=54` maximal-set problem still
  needs residual-torus orbit augmentation and an exact shared line-label flip
  witness; the new balanced-endpoint machinery does not solve it.

## 36. Application memo and finite C949 compiler upgrades

The private application memo
`notes/2026-08-25-c962-application-opportunities-memo.md` ranks the concrete
users of the recovery optimizer and develops the orbit compiler as a reusable
intermediate representation.  It also corrects an important scope boundary:
the 714-task route can exactly settle the finite `q=27` balanced endpoint
branch, but it does not by itself land C949's main field-uniform asymptotic
sharpness theorem.  A finite rejection ledger helps C949 only if its canonical
cores compress into a bounded-degree argument valid over `q=3^h`; a finite
witness is only an ansatz until it extends uniformly.

Two generic cold compiler passes are now exact and certificate-bearing.

1. Ternary option residues are translated by one baseline per orbit family
   and row-reduced to the affine span of all option differences.  A target
   outside that coset returns an explicit annihilating functional; otherwise
   every option and the target are re-encoded in the true rank `r`, replacing
   the raw `3^w` state factor by `3^r`.
2. Integer option totals receive the analogous Smith-normal-form treatment.
   The left unimodular transform tests exact lattice membership, exposes
   forced congruences, deletes zero directions, and returns either reduced
   integral coordinates or the violated transform row and modulus.

For `N` binary orbit families the ternary rank is at most `N`; the synthetic
32-family, 102-coordinate benchmark therefore compresses to at most 32
coordinates and from five packed words to at most two.  This is not yet a
C949 bound.  C949's 31--32 active nonfixed orbits belong to the signed-word
layer, while the balanced carrier's 102 Reed--Solomon parities range over 26
high-arity row-pair families.  Their actual affine ranks require two separate
contribution tables and must not be conflated.

The balanced table is now extracted for the unrestricted 9,126-option model
and for transversal index zero in both representative cases (7,550 options
each).  All three spans have full rank 102.  Affine compression therefore
does not help those instances.  This negative is algorithmically decisive:
the balanced route should reconstruct `(A,C)` from two fibers and delete the
102 searched parities, not spend more effort rebasing a full-rank system.  No
rank statement is yet made for the separate signed-word layer.

For the other balanced mapping tasks no further sampling is needed.  Every
fixed mapping marks three rows and leaves 23 unmarked.  At each possible
unmarked row, exhaustive `GF(27)` arithmetic gives rank six for the allowed
pair differences in `(A,C)`.  Since cubing permutes the nonzero field and any
23 evaluation points give Vandermonde rank 17 for the 17 moment exponents,
the two coefficient channels have total ternary rank `2*17*3=102` for every
fixed mapping.  This proves uniformly across all 714 tasks that seed-fiber
elimination, not affine re-encoding, is the relevant balanced reduction.

The two-high-fiber functional dependency `(SR24z)` is now executable in both
the Python oracle and Rust.  Two distinct degree-eight fiber polynomials
reconstruct the complete trace/product coefficient pair `(A,C)`; the other
seven fibers are equality checks rather than solver variables.  Rust stores a
fiber in 16 bytes and the reconstructed pair in 32 bytes.  The bounded
Criterion run measured 33.212 ns for reconstruction and 6.0292 us for a
synthetic 32-family, 102-coordinate affine compilation.  These are component
times, not an end-to-end C949 speed claim.

The complete candidate join is also implemented.  Given nine nonempty
factorized-fiber candidate families, it chooses the seed pair minimizing the
exact product of family sizes, reconstructs each candidate `(A,C)`, and checks
the other seven through exact coefficient indexes.  Its 64-byte witness keeps
the carrier, seed slots, all nine candidate indices, and the number of seed
pairs examined.  Candidate generation remains the missing spatial input; the
coherence join itself no longer belongs in CP-SAT.

On a bounded nine-family shape with 64 candidates per family and the coherent
pair last, the indexed join examines all 4,096 seed pairs in 215.11 us.  This
does not include genuine factorization-candidate generation and is not an
end-to-end branch measurement.

There is a stronger cofactor-free search state.  Each high-fiber cell `(x,y)`
imposes the affine carrier equation `C(x)-yA(x)=-y^2` on the 18 coefficients
of `(A,C)`.  Python and Rust now row-reduce these equations directly, returning
an inconsistent prefix, an underdetermined rank, or the unique carrier at rank
18.  Both independently reconstruct `A=X+X^2,C=X^3` from nine two-root rows
and reject a third root on one row.  The intended DFS can therefore branch on
the degree-three/four incidence sets with row capacity two, use rollback
elimination for propagation, and avoid enumerating the root-free cofactors
`L_y` entirely.  A terminal rank below 18 remains a genuine affine family and
must not be rejected without the remaining norm/Witt constraints.
The current from-scratch rank-18 solve takes 5.5344 us in Criterion; rollback
updates are the next representation step for the recursive search.  That step
is now implemented: a 384-byte, cache-line-aligned insertion-order basis never
modifies old rows, so rollback is one rank decrement.  From rank 17,
independent push/pop takes 323.54 ns; including unique-carrier
back-substitution takes 523--552 ns across two bounded Criterion sessions.

The terminal affine dimension is now bounded mathematically.  A kernel pair
`(P,Q)` of degree at most eight vanishes at every double-high row, because two
distinct fiber equations there force both values to zero.  With at least nine
double rows it vanishes identically.  With eight, the residual pair is
constant; the singleton rows would all need one fiber value, contradicting
the per-fiber cap four.  With seven, the residual pair is linear and the
singleton cells lie on a fractional-linear graph, initially giving nullity
at most one.  The completed fiber profile now removes that last dimension:
outside at most one common zero, a nonconstant linear-over-linear ratio is
injective on at least 18 singleton rows and cannot land in only nine high
values; a constant ratio violates the fiber cap four.  More generally, for
`q=3r` the identity `n_2-n_0=r+1-g` leaves only `n_2>=r`, `r-1`, or `r-2`.
Degree kills the first case, a constant singleton fiber kills the second,
and the same Möbius argument kills the third.  Every completed balanced
carrier has full affine rank `2r`; rank `2r-1` is only a partial-search
candidate generator.  The ledger stores `n_0,n_2` without growing beyond 16
bytes.

Random `3 by 3` Smith transforms replay their determinant and transformed
column lattice; focused congruence and rational-span obstruction tests pass;
the existing Python orbit fixture agrees after either affine compiler; and
Python/Rust replay the same nine-fiber reconstruction example.

### Continuation mystery update

| Feature | State | Exact remaining gate |
|---|---|---|
| finite solver versus C949 theorem | **Settled:** the compiler can close only the finite `q=27` branch directly | a canonical finite rejection core must be rewritten as a bounded-degree field-uniform proof before it affects asymptotic sharpness |
| apparent `102->32` rank reduction | **Settled negatively:** it conflated the signed-word and balanced-carrier layers; every fixed balanced mapping has full rank 102 | extract the separate signed-word contribution table if that branch resumes |
| two-fiber coherence | **Settled as an executable join:** reconstruction and indexed seven-family verification return compact witnesses | generate complete cubic/quartic seed candidate families for the genuine tasks |
| high-fiber cofactor explosion | **Settled representationally:** search root incidences as affine equations in 18 carrier coefficients; no `L_y` catalogue is necessary | integrate rollback basis updates into the actual family/row-cap DFS and solve any underdetermined terminal affine spaces |
| terminal underdetermination | **Settled to one dimension:** eight double rows force uniqueness; seven leave at most a Möbius defect and at most 27 carriers | couple that exceptional scalar to the fourth-Witt and reciprocal-norm gates |
| integer-total redundancy | **Settled generically:** Smith compilation gives reduced coordinates or an exact violated congruence | measure the actual diagonals only after the relevant C949 integer option table is extracted |
| route to a uniform obstruction | **Open:** reason-coded finite cores may expose it, but no such core exists yet | complete the finite candidate generator/search, minimize rejection cores, then test whether they avoid `GF(27)`-specific enumeration |

The earlier hostile `ej` pass found and repaired a scope hazard: Frobenius
mapping representatives are not lossless against a fixed arbitrary carrier.
The implementation now quotients the joint object, transports carrier
evaluations explicitly, and keeps a full fixed-carrier scan.  It also rejects
any speedup ratio against CP-SAT because the Rust layer is not yet a complete
solver.

The `tt` pass supplied the latent fixed-fiber Burnside quotient, the weighted
714-task work decomposition, and the 16-byte overlap ledger.  The performance
pass then confirmed that the ledger is cache-resident and that SIMD is not the
next lever; the state-count reductions and two-fiber reconstruction remain
dominant.

Vibe: the theorem-to-search boundary is now sharp and well packed; the open
work is genuinely spatial, not hidden normalization or representation debt.

C962 remains open, and its private queue row now places the 714-task balanced
hybrid ahead of the older residual-torus `T=54` continuation.  No manuscript,
standalone mirror, public-facing file, commit, push, export, or deposit was
made.

```text
go C962 complete-ports integrate the 714-task high-incidence DFS with the 384-byte rollback carrier basis, enumerate the at-most-27 Möbius-defect terminals, and apply the fourth-Witt and mapping gates
```

## 37. Integrated 714-task high-incidence DFS

The requested finite `q=27` engine is now wired end to end, with an explicit
three-way result rather than a Boolean search verdict.  For a fixed mapping
and nine-value high set, the DFS evaluates every unprocessed row against the
current affine basis, selects the row with the fewest feasible zero/one/two
high-cell subsets, and orders those subsets by rank gain.  Independent cell
equations append to the 384-byte insertion-order basis; dependent equations
are forced, inconsistent equations reject locally, and rollback restores only
the old rank.  The 16-byte fiber ledger remains the count screen.

At rank 18, back-substitution gives the unique carrier.  At rank 17, the new
affine-family API identifies the free coefficient, constructs an origin and
kernel direction, and enumerates all 27 field parameters.  Rank below 17 is
never discarded at an early terminal.  If all 26 rows are complete below rank
17, only then does the proved terminal-nullity theorem reject the incidence
pattern.

Each compatible carrier is replayed in the following fixed order:

1. every nonzero row has two distinct carrier roots;
2. the `y`-fibers have the exact `0/1/3/4` profile for `G` and `E`;
3. the three mapping completion cells are absent;
4. the shifted `t`-norm has multiplicities `3,1,2` at zero, `E`, and the
   remaining nonzero values;
5. the reciprocal `t/u`-norm has the analogous profile with singleton set
   `R`; and
6. the direct sum of the precompiled `Theta_4^9` cell weights equals the
   four-coefficient Witt gate.

The closeout pass moves the first gate ahead of carrier enumeration.  On a
rank-17 affine line `(A,C)=(A_0,C_0)+lambda(A_1,C_1)`, a row splits into two
distinct roots exactly when `A_lambda(x)^2-C_lambda(x)` is a nonzero square.
Each of the 26 rows therefore contributes one 27-bit allowed-parameter mask.
Their intersection gives all split Möbius parameters at once.  When it is
empty, greedy deletion retains an inclusion-minimal row set whose masks still
have empty intersection; the core is then canonicalized jointly with the 17
carrier equations.  The first bounded slice found the theoretical minimum
shape: 17 independent carrier equations plus one discriminant row.  Its first
uniform lift is now proved.  Over every odd `q>=5`, if
`(A,C)=(A_0,C_0)+lambda(P,Q)` has no split member at row `x`, the quadratic
character sums for
`(A_0(x)+lambda P(x))^2-(C_0(x)+lambda Q(x))` force
`P(x)=Q(x)=0`; the remaining constant discriminant is zero or nonsquare.
For the exceptional `q=27` profile this kills the direction globally.  The
seven double rows plus `x` are eight common zeros of degree-at-most-eight
`P,Q`, so they are constant multiples of one degree-eight factor.  Since
`n_0=0`, `x` is one singleton row; the other 18 singleton equations would
then all have the same high value, contradicting the fiber cap four.

The completed-profile count eliminates the apparent multirow residue as
well.  A double row fixes two distinct roots throughout the affine family,
so its mask is full.  A singleton row fixes one root; unless its mask is
already empty by itself, variation of the other root excludes at most one
parameter.  The exceptional profile has only 19 singleton rows, hence at
least `27-19=8` parameters split simultaneously.  Thus a jointly empty
multirow mask is possible only at an unfinished node and is exactly a proof
that the node has no completed extension.  It is not a new terminal core.
The kernel compresses once more on a completed exceptional profile.  Removing
the seven double-row factor writes its direction as `(P,Q)=(HL,HM)` with
linear `L,M`.  On at least 18 singleton rows the fixed high value is the
fractional-linear ratio `M/L`.  A nonconstant ratio is injective and cannot
land in only nine high values; a constant ratio violates the fiber cap four.
Thus genuine completed rank 17 is impossible.  Rank 17 remains useful only
as a partial-search generator for at most 27 candidates; every candidate
passing the complete high-fiber replay has rank 18.

Processed-row profiles are checked before those gates.  An 18-byte exact
carrier key then suppresses repeated terminals; neither optimization can
remove a witness because a split carrier is inserted only after it agrees
with its unique processed-row branch.  Failed gate terminals greedily delete
equations while the same gate still rejects every point of the remaining
rank-17/18 affine family.  The resulting inclusion-minimal core is
canonicalized jointly with its mapping and high set under all three Frobenius
powers.  Linear algebra bounds every such terminal core by 18 high cells: an
18-cell basis already reconstructs a rank-18 carrier, while a 17-cell core
means every member of the residual affine line fails the same gate.  This is
the exact finite compression `(SR24z-rank18)`, not yet a field-uniform one.

The outer driver streams, rather than stores, all
`binom(26,9)=3,124,550` high sets inside each of the 714 weighted joint
mapping tasks.  It can classify one minimal canonical core per rejected task
and accumulate both representative counts and orbit weights, but only after
all tasks are exhausted.  Any task, high-set, node, or terminal cutoff returns
`Incomplete`; it cannot contribute to a rejection certificate.

The Rust tests cover the exact nine-subset domain, rank-17 enumeration, the
cutoff semantics, and the 714-item outer queue.  The Python oracle now
independently replays bounded terminal cases, including the first two ordered
rejection gates, through the version-five differential fixture.  The bounded
release probe is `examples/gf27_balanced_dfs.rs`; its four arguments are task,
high-set, node, and terminal limits.  Current probes are deliberately
incomplete.  They show that split failure is the dominant first rejection on
the initial task/high-set slice and that duplicate-carrier suppression matters;
they do not settle one high set, one mapping task, or the finite branch.

The main unresolved algorithmic issue is now visible.  The 714 quotient is
small, but the naive completeness shell still repeats a large high-set domain.
The highest-EV next move is to classify the first later-gate cores of the
unique completed rank-18 carriers, or add residual stabilizer augmentation on the joint
`(mapping,G,carrier)` state.  Running the current shell longer without one of
those reductions has low expected value.

```text
go C962 complete-ports classify the unique rank-18 later-gate cores and isolate their field-symbolic obstruction
```

## 38. C972-derived contextual-state kernels

The four C972 algorithmic consequences are now implemented in the private
`ergodis` Rust library with independent Python reference implementations.

1. `certify_rank_one_transfer_by_generators` decides the complete bounded-
   transfer criterion without computing irrelevant losing-sector minima.  It
   checks the zero sector first, evaluates the target block first, prunes a
   candidate once its partial cost exceeds the radius, and stops at the first
   obstruction.  Its witness records the obstruction sector, functional
   coefficients, block labels, candidates, and local lookups.
2. The certificate is the all-rank shortcut: once every target line clears the
   radius, higher-rank bounded systems are transferred by zero-extension rather
   than recomputed.  The benchmark exercises ranks one through four.
3. `RankOneProbeCache` canonicalizes scalar outer tuples modulo field scaling
   and lazily stores the zero-truncated projective line-probe profile.
4. `RankBoundedContextCache` enumerates canonical RREF outer subspaces of
   dimension at most the target rank and caches their exact responses.  It
   retains every labelled map inside each subproblem; maps are not merged merely
   because they generate the same subspace.  Its cold fill is now atomic: every
   nonzero coefficient map is evaluated exactly once, under its image subspace.
5. Both caches expose `Direct`, `Cached`, and forecast-driven `Auto` execution.
   `Auto` admits state only past the measured query threshold and when a
   conservative whole-cache byte estimate fits the supplied memory budget.
   The ordinary `context_cost` entry point defaults to a one-query `Auto`
   forecast; explicit admission is named `context_cost_cached`.

The two contextual caches currently require scalar labels over the outer
field.  A flattened base-field representation of a proper extension does not
specify extension-field scalar multiplication, so generalizing this API needs
an explicit scalar-action input.  This is a type boundary, not a mathematical
gap.

### Differential and exhaustive gates

The Python fixture schema is now `ergodis-rust-v8`.  It independently records
certificate verdicts and obstruction sectors at five radii, cold and warm
projective probe counts, cold and warm rank-bounded context counts, atomic
candidate counts, and direct/low-memory/reused planner choices.  Rust replays
every value.

- 79 Python tests;
- 122 Rust library tests, three kernel-binary tests, five CLI tests, seven CLI
  integration tests, one allocation-regression test, and one Python-parity
  fixture test (139 total);
- warning-denying Clippy with all targets and features; and
- deterministic fixture and evidence regeneration checks.

The focused regressions cover warm-cache default reuse, completion from a
nonempty partial cache, exact and one-byte-under memory budgets, a 64-byte key
estimate, and Python benchmark routing for `cpsat-direct`.  A thread-local
counting allocator also caps cold and warm scan allocations; it caught and
removed per-rank RREF scratch allocation before closeout.

An attempted full read of this already-large report emitted 43,319 tokens and
was discarded as a command-shaping failure.  Subsequent review used bounded
section queries only; no conclusion depends on the truncated output.

### Interleaved A/B results

Two rounds reversed A/B order.  Each round used 15 Criterion samples, a
one-second warmup, and a half-second measurement window.  Values are means of
the two central estimates.

| operation | A | B | ratio |
| --- | ---: | ---: | ---: |
| exact rank-one cost versus radius certificate | 33.55 us | 26.98 us | 1.24x |
| exact ranks 1--4 versus rank-one certificate | 194.34 us | 0.300 us | 648x |
| direct vectors versus cold projective cache | 15.45 us | 14.36 us | 1.08x |
| direct vectors versus warm projective cache | 14.75 us | 7.226 us | 2.04x |
| direct versus projective auto, one query | 14.95 us | 14.94 us | 1.00x |
| direct maps versus cold rank-bounded cache | 13.90 us | 20.42 us | 0.68x |
| direct maps versus warm rank-bounded cache | 13.63 us | 2.342 us | 5.82x |
| direct versus rank-bounded auto, one query | 13.85 us | 13.85 us | 1.00x |

The cold controls delimit the optimization honestly.  After removing hot-loop
allocation, the projective cache pays off on its first query.  The rank-bounded
cache has a two-query break-even and `Auto` bypasses it for a one-query forecast
without inserting state; no dispatch/validation penalty is resolved (13.85
versus 13.85 us).
The radius certificate scans the same 255 outer vectors in
the successful case but reduces local work to 256 lookups.  The all-rank
shortcut replaces 4,676 generator candidates by seven candidates and 12
lookups.  Atomic rank-bounded fill replaces 570 repeated subproblem candidates
by the same 255 nonzero maps as direct enumeration.  Separate A/B processes
reported 10.8--12.0 MiB peak RSS; pairwise differences were at most about
0.6 MiB and remain noisy at process level.

The Tiger-style audit removed `Matrix`, `Vec`, boxed-key, and hash-set
allocation from candidate enumeration.  Local costs are slice lookups;
coefficient, label, rank-elimination, and RREF scratch is preallocated; cache
keys occupy one flat byte pool behind 16-byte `#[repr(C)]` records and compact
integer slots with compile-time size/alignment assertions.  Capacity is
reserved before scanning, and exact witnesses are materialized only after the
scan or at a terminal early-return obstruction.

The deterministic harnesses are `scripts/contextual-ab.sh` and
`scripts/contextual-memory-ab.sh`.  The compact noncanonical measurement record
is `evidence/contextual-state-ab.json`, reduced by
`python/summarize_contextual_ab.py`.  These are bounded kernel measurements,
not end-to-end application speed claims.

### Application-shaped A/B

An applicability audit found that the six headline Ceph/Azure/DAG/QC/vector/GPU
benchmarks do not invoke contextual confinement.  The Jin--Fu concatenated-LRC
benchmarks do, so the release-binary harness now exposes exact, certificate,
cold-cache, warm-cache, automatic, and zero-budget automatic variants.  Eleven
pinned-core rounds were rotated for the cyclic `[43,36,5]` Example 5.7 and the
GF(4) Hamming `[1365,1359,3]` Corollary 5.4 workload.

| workload | exact | certificate | cold cache | auto one-query | warm eight-query mean |
| --- | ---: | ---: | ---: | ---: | ---: |
| cyclic | 13.87 ms | 11.55 ms | 2.288 ms | 2.245 ms | 1.578 ms |
| Hamming | 104.30 ms | 75.67 ms | 7.052 ms | 6.996 ms | 6.018 ms |

Thus cold caching gives 6.06x and 14.79x, while eight-query reuse gives 8.88x
and 17.25x.  A zero-byte budget selects direct execution and is timing-neutral
at 14.03 ms and 104.69 ms.  Example 5.7 stores 5,461 projective lines; the
Hamming case stores 1,365 much wider keys and raises peak RSS from about 2.6 to
4.3 MiB.  This scale test caught two microcase-only assumptions before
closeout: ambient-universe reservation was replaced by query-subspace
reservation plus a no-growth completeness preflight, and the budget estimate
now includes actual key width plus record/index overhead.

Output strength remains explicit.  The cache answers exact zero-truncated
`gamma`, and the certificate answers exact radius-four transfer.  Only the full
baseline computes the losing nonzero minimum and witness.  Raw rotated samples
are recorded under `jin_fu_contextual_state_ab` in
`evidence/benchmarks.json`.

The paper release checker accepted the expanded 81-file ergodis public surface,
then stopped because rebuilding against the dirty private code produced a
byte-different tracked PDF.  Its extracted text was identical to the authority
PDF.  The generated PDF was restored; C962 does not update manuscript artifacts,
and the later paper-owned integration gate remains responsible for accepting a
new tracked PDF.

### Closeout

The C972 deductions improve repeated bounded queries materially.  Forecasted
one-shot rank-bounded queries and memory-constrained queries stay direct;
projective admission is already profitable on the first measured query.  No manuscript,
standalone mirror, push, export, or deposit changed.  The code and evidence
remain uncommitted under the user's existing hold.

Vibe: the cold cost is now paid only when the measured payoff and caller's
memory budget justify it, with allocation-free candidate scans on both paths.
