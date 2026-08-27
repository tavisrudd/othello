# Proof-integrity ledger

**Paper:** *Exact Compositional Transfer of Bounded Linear Recovery*

**Purpose:** internal theorem-by-theorem check against hidden assumptions,
quantifier changes, circularity, and evidence overstatement.

**Scoring:** none.

## Conventions fixed before the main theorem

- `q` is a prime power and `0 < dim I < |E|`.
- `G = (G_P | G_J)` has full row rank.
- `T <= im G_P intersect im G_J` is a recovered message subspace.
- A normalized system is an explicit pair `(alpha,beta)` with
  `G_P alpha = id_T` and `G_J beta = -id_T`.
- Its cost is the cardinality of the union support of `beta(T)`.
- `t` always means `dim T`; target-only coefficient relations have recovered
  dimension zero.
- In concatenation, `r` counts helper coordinates, not total dual weight or
  blocks.

## Main theorem checks

### Associated pair

`K_P = ker G_J`, `D_P = G_J^{-1}(im G_P)`, and
`W_P = im G_P intersect im G_J`. Restricting `G_J` gives kernel `K_P`, image
`W_P`, and a surjection. This row is checked in the paper-owned Lean companion.

Since `I^perp = ker(G_P | G_J)`, projection onto the helper coordinates gives
`D_P = punct_J(I^perp)`, while the words supported on the helpers give
`K_P = short_J(I^perp)`. Thus the pair is intrinsic to the inner code and the
target/helper split; a generator-row-basis change leaves it unchanged. This
puncturing--shortening identification is human-proved and not Lean-formalized.
Standard puncturing--shortening duality also gives
`D_P^perp = short_J(I)` and `K_P^perp = punct_J(I)`, so the failure-side pair
is the corresponding nested pair formed directly from the primal inner code.

### Relative-weight identity

The numerical invariant and its quotient-information interpretation are the
standard RGHW/RDLP theory of nested codes. The paper specializes that theory
to the puncturing--shortening pair and records the exact normalized-recovery
correspondence; the new transfer input begins with concatenation.

For a normalized system, `G_J beta = -id_T` makes `beta` injective. Thus
`L = beta(T)` has dimension `t`, lies in `D_P`, and meets `K_P` trivially.
Conversely, `G_J|_L` is an isomorphism onto its image and a section through
`G_P` supplies the target coefficients. The helper support is unchanged.

The standard RGHW definition permits `L' intersect K_P` to be nonzero. A
vector-space complement to that intersection has quotient dimension `t` and
no larger support. Hence the complement-only minimum is equal to, not smaller
than, the standard RGHW.

### Exact finite prescribed-coset formula

For a fixed recovered subspace `T`, the ordinary inner quantity minimizes the
union support of a linear lift `Y : T -> F_q^E` of one prescribed map
`B : T -> L*`. The target-block quantity minimizes jointly over the target
normalization `alpha` and helper map `beta`; fixing `alpha` would not recover
`rho_T(I)` in general. After a basis of `T` is chosen, the ordinary quantity is
the fixed-instance joint coset-support cost underlying generalized covering
radii. No per-vector or per-basis support sum is used.

A concatenated recovery system gives one linear map
`B : T -> FD(O)`. Conversely, compatible linear lifts of its block maps give a
linear recovery system. Since block coordinate sets are disjoint, the minimum
helper union for fixed `B` is the sum of the blockwise joint support minima.
Surjectivity of the target-block projection excludes a nonzero
functional-dual tuple supported only in that block; therefore every nonzero
`B` sector is nonconfined.

For `B=0`, every block map lands in `I^perp`. The target block costs
`rho_T(I)`. A nonzero external map costs at least `d(I^perp)`, with equality
from a rank-one map into a minimum-weight inner-dual word. These sectors are
exhaustive and all minima are attained because the spaces are finite. Thus the
displayed `Gamma_{j,T}` is the exact first nonconfined helper cost. Minimizing
over `dim T=t` proves the uniform ranked statement.

### Fixed-subspace confinement

For nonzero `B`, choose one target vector on which `B` is nonzero. Its
functional-dual tuple has at least `d(O^perp)` nonzero blocks, hence at least
`d(O^perp)-1` nonzero helper blocks outside the target. The finite gate
`d(O^perp)>r+1` therefore removes every nonzero functional sector at radius
`r`. The exact formula reduces to its zero-functional cost
`rho_T(I)+d(I^perp)`. Outer dual-distance growth makes this automatic
uniformly for fixed `r`.

### Dimension-by-dimension confinement

Every recovered `t`-subspace costs at least `M_t`, and one attains `M_t`.
Applying the fixed-subspace equivalence gives the uniform gate. The singleton
conversion adds one target coordinate, so `z_x = M_1 + 1 + d(I^perp)`.

## Consequence checks

- **Best target:** a normalized identity system gives a `t`-dimensional dual
  subcode of support `t+kappa`; an information set of a minimum-support dual
  subcode gives the reverse inequality. If the target columns are dependent,
  restriction along a section of `G_P` turns the identity system into a system
  on `im G_P`; conversely, target-kernel equations add the missing coefficient
  directions without helpers. The fixed-target escape cost is therefore
  `kappa_C(P)+d(C^perp)`, including the dependent-target case.
- **MDS formula:** the proof computes
  `dim(span G_P intersect span G_H) = max(0,u+|H|-k)` from the uniform column
  matroid, where `u=min(k,|P|)`. It obtains
  `ell=u+min(k,|J|)-k` and `M_t=k-u+t` throughout the recoverable hierarchy,
  without assuming that either side has at most `k` columns or that the helper
  columns span. The condition `|J|>=k` is used only to make `ell=u` and attain
  the global ceiling. Relative-MDS behavior is concluded, not assumed.
- **Rigidity:** equality in the sum forces equality in `b <= k`, relative
  Singleton at rank one, and ordinary Singleton for `I^perp`. Strict RGHW
  growth and the upper bound then coincide at every rank.
- **Positive density:** density `1/m` is a coordinate count. Positive rate and
  primal/dual distance are supplied by the displayed random-linear-code
  first-moment inequalities, not by dual-distance growth alone.
- **Service rate:** the fixed-length hypothesis `d(O^perp)>r+1` first excludes
  nonzero outer-functional systems; the inner threshold then excludes
  zero-functional escape. Only inclusion-minimal supports matter. A flow on a
  nonminimal upward-closed recovery set moves to a contained minimal set and
  weakly decreases all loads; cross-block supersets create no extra capacity.

## Separation checks

- The two five-edge clutters have their complete union-size table printed.
  Alternating the five rows gives the two reliability polynomials.
- The line arrangements impose exactly the displayed collinear triples after
  finitely many unwanted joins are avoided.
- In the lift, every forbidden dependence is one proper linear condition;
  reducing a rational realization outside finitely many primes preserves all
  required zero and nonzero determinants.
- Forced padding is used because reliability under an arbitrary total-radius
  direct sum need not factor. Full quotient rank forces every padding support,
  leaving exactly radius three in the base block.
- The coefficient-presentation example lists all three nonzero graph-code
  weights. Its thresholds are obtained only after adding the separately
  computed inner-dual distance.

## Projective-family checks

- The dual restriction `(a,aA) -> a` is injective, so the associated pair is
  `0 <= S_m` with no helper-only kernel.
- A `t`-subcode of the simplex code vanishes exactly on the projective points
  of an `(m-t)`-dimensional annihilator.
- Failed helpers leave an equation space of dimension `m-rank(F)`.
- The Möbius formula includes the full Bernoulli weight:
  summing over all `F` contained in a `v`-subspace gives `s^(N-N_v)`.
- Rare survival counts complements of `(m-t)`-subspaces; rare failure counts
  unordered projective `(m-t+1)`-frames.
- The uniqueness proof first forces constant nonzero word weight by averaging,
  then solves the projective multiplicity vector using the real nonsingularity
  of the point--hyperplane incidence matrix.

## Evidence boundary

The paper-local Lean companion proves only the associated-pair exact sequence.
Its claims manifest marks the RGHW, confinement, asymptotic, reliability,
service-rate, and projective statements absent. The human proofs are the sole
proofs of those statements in this paper. No exhaustive computation is a
premise of a body theorem.

The manuscript and public reviewer guide must remain consistent with this
ledger after every statement change.
