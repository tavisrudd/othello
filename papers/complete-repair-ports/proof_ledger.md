# Proof-integrity ledger

**Paper:** *Exact Transfer of Bounded Linear Recovery and Relative Weight
Hierarchies*

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
`W_P`, and a surjection. This row is checked in the paper-local Lean package.

### Relative-weight identity

For a normalized system, `G_J beta = -id_T` makes `beta` injective. Thus
`L = beta(T)` has dimension `t`, lies in `D_P`, and meets `K_P` trivially.
Conversely, `G_J|_L` is an isomorphism onto its image and a section through
`G_P` supplies the target coefficients. The helper support is unchanged.

The standard RGHW definition permits `L' intersect K_P` to be nonzero. A
vector-space complement to that intersection has quotient dimension `t` and
no larger support. Hence the complement-only minimum is equal to, not smaller
than, the standard RGHW.

### Fixed-subspace confinement

For each concatenated dual equation, the block-functional tuple belongs to
the functional dual of the outer code. Trace nondegeneracy and outer
`L`-linearity identifies its block support distance with `d(O^perp)`. A
cost-`<= r` system meets at most `r+1` blocks, including the target block.
Therefore the finite gate `d(O^perp)>r+1` removes every nonzero
block-functional tuple. Outer dual-distance growth makes this automatic
uniformly for fixed `r`.

In the remaining zero-functional case, the target block costs at least
`rho_T(I)`. Any nonzero external block contains a nonzero inner-dual word and
costs at least `d(I^perp)`. Blocks are disjoint. A minimum inner system plus a
rank-one map into a minimum inner-dual word in a second block attains the sum.
This proves both directions under the stated finite outer gate; the eventual
family statement is a direct consequence.

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
