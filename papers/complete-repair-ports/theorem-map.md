# Theorem and evidence map

This internal map follows the current manuscript *Exact Compositional Transfer
of Bounded Linear Recovery: Relative Weights and Labelled Coset Costs*. It records mathematical
dependence and evidence status. It assigns no quality grade.

## Main proof chain

| Stable label | Statement | Proof mechanism | Imported input | Paper-local Lean status |
|---|---|---|---|---|
| `thm:mds-reconstruction` | Minimum-weight normalized equations through one coordinate span the dual of an MDS code. | Private-coordinate triangular basis. | MDS dual parameters. | absent |
| `eq:associated-exact-sequence` | `0 -> K_P -> D_P -> W_P -> 0`. | Restrict `G_J` to the preimage of `im G_P`. | none. | complete: four constituent terminals |
| `prop:puncture-shorten-pair` | `D_P=punct_J(I^perp)`, `K_P=short_J(I^perp)`, and dually `D_P^perp=short_J(I)`, `K_P^perp=punct_J(I)`; the pairs are independent of generator-row basis. | Project and shorten `ker(G_P \mid G_J)`, then apply puncturing--shortening duality. | standard puncturing, shortening, and their duality. | absent |
| `thm:relative-weight-recovery` | The minimum helper union for recovered dimension `t` is `M_t(D_P,K_P)`. | Recovery systems correspond to `t`-subspaces disjoint from `K_P`; a complement compares this with the standard RGHW minimum. | standard nested-code RGHW support/information interpretation. | absent |
| `prop:relative-profile` | The relative dimension/length profile is the maximum recoverable target dimension from `s` helpers. | Restrict the exact sequence to vectors supported on a helper set. | standard inverse relation between RGHWs and the relative profile. | absent |
| `thm:ungated-ranked-confinement` | For a fixed nonzero target-message subspace, `N>=2`, and a target block with nonzero outer projection, minimizing prescribed-coset support costs over `Hom(T,FD(O))` gives the exact finite first nonconfined helper cost; minimizing over internally recoverable `dim T=t` subspaces gives the ranked form. | Decompose every linear recovery system by its outer-functional map; minimize compatible linear lifts blockwise; separate the zero-functional rank-one external perturbation. | generalized covering/coset-support interpretation and classical concatenated-dual decomposition. | absent |
| `prop:prescribed-coset-composition` | Labelled prescribed-coset support functions compose exactly and associatively by min--sum substitution through finite concatenation towers. | Eliminate intermediate functional maps blockwise and use trace transitivity to identify the composite restriction map. | finite-field trace duality and min--sum variable elimination. | absent |
| `cor:all-rank-bottleneck` | The minimum nonconfinement cost over all nonzero recoverable target subspaces is attained at rank one. | Restrict a nonconfined system to a line on which an external block map is nonzero. | exact ungated confinement theorem. | absent |
| `thm:objectwise-confinement` | For `N >= 2` and `d(O^perp)>r+1`, a fixed target subspace has confinement gate `r < rho_T(I) + d(I^perp)`; growing outer dual distance gives the eventual form. | Block-functional dual decomposition; the finite outer gate removes nonzero functional tuples; a rank-one external inner-dual map attains the remaining bound. | finite-field trace duality. | absent |
| `thm:ranked-confinement` | Under the same finite outer gate, uniformly over recovered dimension `t`, the gate is `r < M_t(D_P,K_P) + d(I^perp)`; growing outer dual distance gives the eventual form. | Minimize the fixed-subspace gate and use an attaining RGHW subspace. | preceding two theorems. | absent |

## Consequences

| Stable label | Statement | Proof mechanism | Imported input | Paper-local Lean status |
|---|---|---|---|---|
| `thm:best-target-ghw` | `min_{|P|=t} kappa_C(P) = d_t(C^perp)-t`, with the corresponding earliest nonconfinement cost. | Information set of a minimum-support `t`-dimensional dual subcode; factor an identity system through `im G_P` and adjoin target-kernel equations at zero helper cost before applying the block-functional escape argument. | GHW definition. | absent |
| `thm:mds-thresholds` | Relative-Singleton ceiling, exact MDS formulas, and equality-at-rank-one rigidity. | Relative Singleton plus a direct uniform-matroid intersection calculation; strict RGHW growth closes rigidity. | relative Singleton and strict growth. | absent |
| `cor:positive-density` | Exact blockwise copying and concatenated parameter bounds; random outer families make rate and primal/dual distances positive. | Coordinate counting, blockwise injectivity, distance multiplication, and a first-moment random-code argument. | `q`-ary entropy estimate. | absent |
| `cor:service-rate-transfer` | If every demand is below its exact prescribed-coset confinement threshold, bounded service-rate regions agree after capacity transport; the outer-distance and inner inequalities are sufficient and hold eventually in growing-dual-distance families. | Exact minimal-support transfer followed by domination of upward-closed supersets. | standard fractional service-rate definition. | absent |

## Separations and application

| Stable label | Statement | Proof mechanism | Computational dependence | Paper-local Lean status |
|---|---|---|---|---|
| `prop:rank-one-reliability-separation` | Same `M_1`, different radius-three reliability. | Printed 31-subfamily union-size table plus inclusion--exclusion; generic five-line representation and specialization. | none load-bearing. | absent |
| `thm:rghw-reliability-separation` | Equal full RGHW hierarchies, different reliability for full recovery, at every quotient rank. | Disjoint rank-one padding with forced supports and exact remaining-radius calculation. | none. | absent |
| `prop:coefficient-presentation` | Different ambient inner-dual realizations of the same abstract nested helper pair can have different additive confinement thresholds. | Three nonzero graph-code words computed explicitly. | none. | absent |
| `thm:projective-thresholds` | Exact simplex RGHWs, inner-dual distance, and confinement thresholds. | Count projective points outside an annihilator. | standard projective-space counts. | absent |
| `thm:projective-reliability` | Exact recovery probability and endpoint coefficients. | Failed-set rank criterion, subspace-lattice Möbius inversion, and projective-frame counts. | none. | absent |
| `prop:projective-uniqueness` | Equality in the first helper-cost bound characterizes the projective-simplex multiset. | Averaging followed by nonsingularity of the point--hyperplane incidence matrix over the reals. | standard projective incidence parameters. | absent |

## Formal boundary

The paper-local Lean companion establishes only the exact-sequence row. Its reviewer
terminals use `Classical.choice`, `Quot.sound`, and `propext`. Every other row
has a human proof in the manuscript and is marked absent in
`lean/verification/claims.json`. No computation or declared project axiom is a
premise of the main proof chain.

## Excluded claims

The manuscript does not claim finite-length confinement after deleting the
outer-functional term, equality of full pointed invariants after
concatenation, bandwidth optimality, subpacketization bounds, integral
disjoint-request packing, or formal verification of the RGHW and confinement
theorems.
