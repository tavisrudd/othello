# Complete repair hypergraphs: A+ upgrade and follow-up research roadmap

**Date:** 2026-07-16
**Lanes:** `repaircodes` (bounded manuscript upgrade), `repairports` (stand-alone follow-up)
**Source paper:** [`coding-repair-hypergraphs`](../papers/coding-repair-hypergraphs/README.md)

## Executive verdict

The current manuscript is already a strong specialist paper. Its ceiling will not move materially
from more q=9 orbit tables, the D-PC9 five-weight calculation, or additional raw coefficient
formulas. The best connected upgrade is to replace the two sufficient concatenation gates by one
exact weighted-functional obstruction invariant and then demonstrate a natural concatenation for
which the exact criterion proves transfer beyond the current support-distance gates.

The larger research object is a pointed represented-matroid port: the complete bounded family of
dual circuits through a target, with its matching, blocker, reliability, and coefficient-gauge
structure. That broader program belongs in a separate `repairports` lane.

## C214: bounded upgrade of the current paper

**Disposition (2026-07-16, cold-read corrected): promoted.** The exact multiblock theorem requires
a singleton-functional term in full generality. The exact nonembedded-witness threshold is always
the displayed two-term minimum; it equals the multiblock threshold for coordinate-surjective outer
codes and supplies a sufficient hypergraph-transfer gate.
The strict example is a Singer-shifted `[5,4,2]_{6561}` generalized SPC outer code for the
completed q=9 seed. The fiber identity is retained as classical structure, not novelty. See
[`2026-07-16-c214-weighted-functional-transfer.md`](2026-07-16-c214-weighted-functional-transfer.md).

**Formal closure:** C221's exact thresholds and finite-attainment chain and C224's post-cold-read
closeout are reported. The pointed refinement, corrective nonsurjective counterexample,
generalized-SPC specialization, exact threshold-six bundle, and the deduction from a presented
regular Singer action to the disjoint unit-cost multiplier are kernel-checked. The aggregate Lean
and final PDF gates pass; general weighted-dual algorithms and asymptotic realization remain C215
and C216 work in `repairports`.

Let `I <= F^K` be the inner code, `e : V -> I` its encoding isomorphism, and define

```text
Phi_I : F^K -> V*,       Phi_I(w)(v) = <w, e(v)>.
```

Then `ker(Phi_I) = I^perp`. For a functional `beta : V*`, define its inner realization cost

```text
lambda_I(beta) = min { wt(w) : Phi_I(w) = beta }.
```

For an outer code `O`, define the weighted functional-dual distance

```text
d_lambda(O) = min_{0 != beta in O^(perp_fun)} sum_j lambda_I(beta_j).
```

Every concatenated dual word is exactly a choice of a functional-dual tuple `beta` together with
one representative `w_j` of each fiber `Phi_I^(-1)(beta_j)`. This suggests the exact global
nonembedded-witness threshold (for at least two outer blocks and nontrivial inner dual)

```text
r + 1 < min(2 d(I^perp), d_lambda(O)).
```

The two terms separate the only possible obstructions:

- `2 d(I^perp)` is the cheapest word using two nonzero blocks in the zero-functional fiber;
- `d_lambda(O)` is the cheapest word induced by a nonzero outer functional-dual tuple.

The present theorem is recovered from `lambda_I(beta) >= 1` for nonzero `beta`, which turns outer
functional support distance at least `r+2` into the coarser bound `d_lambda(O) >= r+2`.

### Mandatory promotion gates

C214 upgrades the manuscript only if all of the following land.

1. **Exactness.** Compute the necessary-and-sufficient global bounded block-confinement threshold,
   separately compute the nonembedded-witness threshold used for transfer, and use pointed
   refinements only as sufficient criteria for literal coordinatewise repair-hypergraph equality.
2. **Strict natural example.** Exhibit a nondegenerate inner/outer pair for which the paper's
   existing outer support-distance gate fails but the weighted criterion still proves exact
   bounded transfer. A synthetic boundary toy is not sufficient for A+ promotion.
3. **Enumerator structure.** Prove, at least in a clean finite form, the fiber-enumerator identity

   ```text
   W_(O o I)^perp(z) = sum_{beta in O^(perp_fun)} product_j W_beta_j(z),
   W_beta(z) = sum_{w in Phi_I^(-1)(beta)} z^wt(w),
   ```

   and state precisely which support-refined or projective-dual data it transfers.
4. **Asymptotic payoff.** Determine whether nonsymmetric outer AG or random-code families improve
   the current isolated rate/distance points while retaining the exact repair port. The required
   dual distance is constant, so self-duality should be treated as a convenient certified choice,
   not presumed Pareto-optimal.
5. **Novelty gate.** Search generalized concatenated-code dual enumerators, concatenated coset
   weight distributions, separation vectors, and weighted dual metrics before claiming the exact
   criterion or enumerator identity as new.

If the exact theorem lands but no strict natural example does, bank it for C215 and leave the
current paper focused. If the strict example and enumerator identity land, recenter the paper's
transfer section around the exact invariant and present the two existing gates as a simple
corollary.

### Optional current-paper corollary

A general realization statement would materially strengthen the framing:

> Every finite representable repair port satisfying the inner confinement condition can occur
> blockwise, with its complete bounded incidence geometry preserved exactly, in an asymptotically
> good fixed-alphabet code family.

This belongs in the current paper only if it follows compactly from C214 and yields a meaningful
achievable rate/distance region. Otherwise C216 owns it as a stand-alone theorem.

## What does not constitute an A+ upgrade by itself

- **D-PC9:** a useful certified five-weight family, but its distribution is a short augmentation
  of classical twisted-cubic plane-orbit counts.
- **C202:** the radius-three extremizer structure is clean, while the 1,306,963 cubic full-port
  matching orbits establish that representative classification is the wrong scalable object.
- **C203:** exact scalar equations answer an operational referee question, but raw coefficients
  are diagonal-coordinate gauge and imply no invariant bandwidth or arithmetic optimum.
- **More q=9 reliability or orbit data:** valuable as an application or artifact, not a new center
  of gravity without a general theorem.

## Stand-alone `repairports` program

### C215 — weighted functional duals and exact low-weight concatenation

Develop the C214 invariant as a general theory if it is too large for the current paper or fails
the strict-example promotion gate there. Target results are exact global and target-conditioned
confinement criteria, first-obstruction classification, support/coset enumerator transforms,
algorithms, and examples that strictly improve ordinary support-distance gates.

This is the most tractable high-upside follow-up because the concatenated dual already has the
required fiber decomposition implicitly in the current proof.

### C216 — prescribed local matroid geometry in asymptotically good codes

Treat the local object as a pointed represented-matroid port and characterize when it can be
replicated with positive density in an asymptotically good fixed-alphabet family. Derive the
achievable region

```text
R_concat = (dim(I)/length(I)) R_outer,
delta_concat >= (d(I)/length(I)) delta_outer
```

subject to exact bounded-port transfer, and optimize over nonsymmetric outer families. The desired
headline is a realization theorem for prescribed finite local repair geometry, with the
twisted-cubic--axis port as a flagship example rather than the entire subject.

### C217 — gauge invariants of overlapping repair equations

Raw circuit coefficients are defined only up to a circuit scalar and diagonal coordinate
rescaling. Search instead for gauge-invariant products of coefficient ratios around closed chains
of overlapping circuits: matroid cross-ratios, foundation/Tutte-group data, or multiplicative
holonomy of a repair-incidence complex.

The first bounded test is the completed q=9 seed. Compute a basis of gauge invariants and determine
whether it recovers projective cross-ratios on `P^1(F_9)`, distinguishes support-identical
monomially inequivalent realizations, or transfers covariantly under concatenation. Continue only
if a nontrivial invariant has a classification or operational consequence.

**Completed C217 result.** The circuit--coordinate incidence graph carries a multiplicative
holonomy on every cycle. Fundamental-cycle holonomies for a spanning forest completely classify
nonzero coefficient labelings up to circuit and coordinate gauges. On two overlapping axis
triples, the four-cycle holonomy is the projective cross-ratio. Two four-point axis restrictions
over `GF(9)` have the same `U(2,4)` repair supports but cross-ratios in distinct anharmonic orbits,
so their row codes are not monomially equivalent. Embedded inner relations copy these invariants
through C216 concatenation. The full q=9 small-circuit incidence graph has cycle rank 581, and an
deterministic replay verifies all fundamental holonomies and 3024 ordered finite-axis cross-ratios.
See [`2026-07-16-c217-gauge-invariants.md`](2026-07-16-c217-gauge-invariants.md).

### C218 — rational normal curves with osculating nuclei

Classify pairs `(degree, characteristic)` for which a rational normal curve has a useful common
osculating nucleus, form the curve-plus-nucleus projective system, and symbolically classify its
small mixed circuits. Search for a second infinite family with tractable exact repair rows,
few-weight behavior, or an additive/design-theoretic reduction. One genuinely new higher-degree
family is the publication gate; a catalogue of exceptional nuclei alone is not.

**Completed C218 result.** For `q >= d`, the common osculating-hyperplane nucleus of the degree-`d`
normal rational curve has projective dimension `d-product_i(d_i+1)`, where the `d_i` are the
base-`p` digits of `d`; it is nonempty exactly when `d+1` has at least two nonzero base-`p` digits.
The first new useful case is `d=4`, `p=3`: adjoining the unique nucleus `e_2` produces a
`[q+2,5,q-3]_q` code for every `q=3^h >= 9`. Its circuits of size at most five are the nucleus plus
the harmonic quadruples of `P^1(F_q)`, which form `S(3,4,q+1)`. Hence every symbol has exact
locality four; the q=9 nucleus row is `(2,5)`, and dual distance five makes C216 replication
automatic. See
[`2026-07-16-c218-quartic-nucleus-repair.md`](2026-07-16-c218-quartic-nucleus-repair.md).

### C219 — reliability and Boolean analysis of complete repair ports

For a target `x`, regard repairability after a failure set `F` as the monotone Boolean function

```text
f_x(F) = 1  iff  some repair edge is disjoint from F.
```

Develop reliability polynomials, type-dependent and correlated failure models, pivotal-helper
influences, and asymptotic thresholds. Exact port transfer preserves this entire local Boolean
function. Use C202's blocker representatives and group action as the first finite test, but require
a symmetry formula, recurrence, or asymptotic theorem before promoting a stand-alone paper.

**Completed C219 result.** Complete ports admit an exact deletion--contraction reliability
recurrence, pivotal partial derivatives, the homogeneous Russo--Margulis identity, and blocker-dual
high-survival asymptotics; exact port transfer preserves this entire calculus. For every
`S(3,4,n)`, random point survival has a Poisson repair window at `n^(-3/4)` with limit
`1-exp(-c^4/24)`. The derived `S(2,3,n-1)` at a C218 curve target has window `n^(-2/3)`, but every
repair shares the nucleus, producing a series bottleneck and qualitatively different homogeneous
reliability. Exact q=9 Bernstein profiles recover C202's blocker layers and quantify the full-port
gain. See [`2026-07-16-c219-repair-reliability.md`](2026-07-16-c219-repair-reliability.md).

### C220 — additive equality and stability for repair extremizers

The completed axis port reduces minimum blockers to complements of maximum zero-sum-free sets and
maximum packings to line partitions. The cubic port reduces blockers to mixed endpoint/color covers
of a properly sum-colored complete graph. Seek uniform equality and near-equality theorems:
stability of near-minimum blockers, classification of optimal restricted-sumset covers, and
structure of line partitions beyond q=9. This is the least mechanically tractable item, but a
uniform inverse theorem would connect repair robustness to cap-set and additive-combinatorial
stability in a genuinely new way.

## Priority and stop rules

The lane order is C215, C216, C217, C218, C219, C220, except that C215 begins only after C214's
paper-disposition gate. C217 and C218 may run as bounded scouts after C215 has a stable definition
layer. C219 should reuse rather than expand C202's finite machinery. C220 begins only from a sharply
stated additive equality or stability conjecture.

The highest-confidence A+ route is C215+C216. C217 has the highest conceptual upside. C218 has the
best chance of producing a second explicit geometric family. C219 and C220 are follow-ons, not
reasons to delay the current manuscript.

## D-PC9 counting convention

The minimum-weight class has `q+1` projective scalar classes (equivalently, axis-containing plane
forms up to scale). Each class has `q-1` nonzero scalar multiples, so the ordinary linear-code
weight enumerator has `(q-1)(q+1) = q^2-1` minimum-weight codewords. Future prose must say
“projective classes” or “ordinary nonzero codewords” explicitly; the discovery review's bare
“words” correction conflates these conventions.
