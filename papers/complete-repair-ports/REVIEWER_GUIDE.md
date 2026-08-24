# A referee's route through the proof

The complete mathematical argument for *Exact Transfer of Bounded Linear
Recovery and Relative Weight Hierarchies* is in the manuscript. The Lean
companion checks one linear-algebraic component of that argument; it is not
used to stand in for the relative-weight or concatenation proofs.

## A first pass

Read `thm:main` and the three paragraphs following it in
[`complete_repair_ports.tex`](complete_repair_ports.tex). Then read the exact
sequence and `thm:relative-weight-recovery` in
[`sections/02-confinement-transfer.tex`](sections/02-confinement-transfer.tex),
followed by `thm:objectwise-confinement` and `thm:ranked-confinement` in
[`sections/03-positive-density.tex`](sections/03-positive-density.tex).
Those statements contain the principal theorem and its proof. Sections 5 and
6 test what the numerical hierarchy retains and discards.

## Eight checks against hidden assumptions

1. **What is the recovered dimension?** A target subspace is
   `T ≤ im G_P ∩ im G_J`. A normalized system consists of explicit maps
   `α : T → F_q^P` and `β : T → F_q^J` satisfying
   `G_P α = id_T` and `G_J β = −id_T`. Thus `t = dim T` is recovered-message
   dimension. Target-only coefficient relations have dimension zero in this
   count. See Section 2 of the paper.
2. **Why is the minimum a standard RGHW?** The helper image
   `L = β(T)` lies in `D_P`, has dimension `t`, and meets `K_P` trivially.
   Conversely, any such `L` gives a normalized system after choosing a linear
   section through `G_P`. To compare with the standard RGHW definition, the
   proof takes a vector-space complement to `L' ∩ K_P`; this can only shrink
   support. No canonical-complement assumption is used.
3. **Where does the additive confinement cost come from?** The map
   `Φ_I : F_q^E → L*` sends each concatenated dual block to its induced inner
   message functional. A dual vector gives a tuple in the functional dual of
   the outer code. Trace duality identifies its support distance with
   `d(O_N^⊥)`. Once that distance exceeds the fixed block-support budget, every
   block functional is zero. A nonconfined system then consists of an inner
   realization of the demand and a nonzero inner-dual equation in another
   block, on disjoint supports. The converse construction uses a rank-one
   external equation map, so the lower bound is attained.
4. **Are the eventual and finite quantifiers separated?** Yes.
   `thm:objectwise-confinement` and `thm:ranked-confinement` first treat one
   finite outer code with `N ≥ 2` and the explicit gate
   `d(O^⊥) > r+1`. Under that gate, `r < M_t + d(I^⊥)` is necessary and
   sufficient. For a family with `d(O_N^⊥) → ∞`, the finite gate holds for all
   sufficiently large `N` at each fixed `r`. The paper does not claim that the
   inner inequality alone excludes nonzero outer-functional mechanisms.
5. **Is there an off-by-one in the one-coordinate theorem?** No.
   `M_1(D_P,K_P)` counts helpers. The older quantity `z_x(I)` counts total dual
   weight and therefore includes the target coordinate. Equation
   `eq:singleton-threshold` states
   `z_x(I) = M_1(D_P,K_P) + 1 + d(I^⊥)`, so the two conditions are exactly
   `r < M_1 + d(I^⊥)` and `r + 1 < z_x(I)`.
6. **Which consequences import outside theorems?** Strict growth and the
   relative Singleton bound for RGHWs are classical and cited where used. The
   best-target generalized-weight identity is proved directly from an
   information set of a minimum-support dual subcode. The MDS formula is
   derived from the uniform column matroid rather than assumed. The existence
   of outer families with simultaneous primal and dual relative distance uses
   the stated random-linear-code first-moment argument.
7. **Do the separations use an unchecked search?** No. The two rank-one
   reliability polynomials follow from the printed 31-subfamily union-size
   table by inclusion–exclusion. Their representability is proved by a
   five-line configuration, a generic lift, and finite-field specialization.
   The higher-rank separation uses forced disjoint padding; full quotient rank
   forces every padding support, leaving exactly the base radius. The
   coefficient-presentation example is a three-word calculation printed in
   full.
8. **Are the projective formulas numerical guesses?** No. The simplex RGHWs
   follow by counting projective points outside `U^⊥`. The reliability event is
   `rank(F) ≤ m−t` for the failed point set `F`; Möbius inversion on the
   subspace lattice gives the closed formula. The two endpoint coefficients
   count complementary flats and projective frames. The equality case for
   `M_1` follows from averaging and nonsingularity of the point–hyperplane
   incidence matrix over the reals.

## What is proved where

- [`sections/01-complete-ports.tex`](sections/01-complete-ports.tex) separates
  exact supports, recovery sets, normalized equations, and reliability, and
  proves MDS reconstruction.
- [`sections/02-confinement-transfer.tex`](sections/02-confinement-transfer.tex)
  proves the exact sequence, RGHW identity, and relative dimension/length
  profile formula.
- [`sections/03-positive-density.tex`](sections/03-positive-density.tex) proves
  fixed-demand and dimension-by-dimension confinement.
- [`sections/04-reliability-exit.tex`](sections/04-reliability-exit.tex) proves
  the generalized-weight, MDS, asymptotic, and service-rate consequences.
- [`sections/05-pointed-tutte.tex`](sections/05-pointed-tutte.tex) proves both
  separations.
- [`sections/06-geometric-flagships.tex`](sections/06-geometric-flagships.tex)
  proves the projective-simplex results.

The outside mathematical inputs are the standard RGHW hierarchy and relative
Singleton bound, finite-field trace duality, the generalized-weight convention
for cooperative recovery, and the random-linear-code existence argument. The
bibliography identifies the sources used for the non-elementary coding-theory
inputs.

## Formal and computational boundary

The paper-local Lean package proves exactly the associated-pair sequence

```text
0 → K_P → D_P → W_P → 0.
```

Its four reviewer terminals and axiom list are described in
[`lean/README.md`](lean/README.md), while
[`lean/verification/claims.json`](lean/verification/claims.json) marks the
RGHW identity, confinement theorem, consequences, and projective family as
absent. Those statements have human proofs in the manuscript and are not
described as formally verified. No literature theorem is declared as a Lean
axiom.

Every theorem-like environment has a nonprinting `\coverage{...}` annotation
defined in [`formal-annotations.tex`](formal-annotations.tex). Only
`prop:associated-pair` is marked `complete`, and its `\lean{...}` annotation
names exactly the four declarations above. All RGHW, confinement, reliability,
service-rate, and projective statements are marked `absent`; none inherits
formal coverage through a `\uses{...}` dependency.

No exhaustive computation enters the main proof. The reliability table is
small enough to inspect directly, and the generic representation proof is
independent of any stored matrix. No distributed replay artifact discharges a
theorem hypothesis.

## Nonclaims

The paper does not claim a finite-length confinement theorem without the
outer-functional term, equality of full pointed invariants after
concatenation, minimum repair bandwidth, subpacketization bounds, integral
disjoint-request packing, or formal verification of the central RGHW and
confinement theorems. The service-rate corollary concerns the standard
fractional capacity region generated by inclusion-minimal recovery sets and
assumes the explicit finite gate `d(O^perp)>r+1` (hence holds eventually for
outer families with growing dual distance).
