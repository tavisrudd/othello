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

**Disposition (2026-07-16): promoted.** The exact theorem requires a singleton-functional term in
full generality; the displayed two-term criterion is exact for coordinate-surjective outer codes.
The strict example is a Singer-shifted `[5,4,2]_{6561}` generalized SPC outer code for the
completed q=9 seed. The fiber identity is retained as classical structure, not novelty. See
[`2026-07-16-c214-weighted-functional-transfer.md`](2026-07-16-c214-weighted-functional-transfer.md).

**Formal closure:** C221 is in progress in `repaircodes`. The exact three-stratum iff, all three
closed-term lower bounds, coordinate-surjective reduction, and Singer/SPC averaging and five-fiber
arithmetic cores are kernel-checked. Concrete attained-minimum and trace/SPC instantiations remain;
the optional extension is the finite fiber equivalence, not a full polynomial library. The stop
gate is focused and aggregate Lean plus axiom and PDF validation; general weighted-dual algorithms and asymptotic realization remain C215
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
block-confinement threshold

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

1. **Exactness.** Prove a necessary-and-sufficient global bounded block-confinement theorem, with
   target-conditioned refinements if literal coordinatewise repair-hypergraph equality needs them.
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

### C218 — rational normal curves with osculating nuclei

Classify pairs `(degree, characteristic)` for which a rational normal curve has a useful common
osculating nucleus, form the curve-plus-nucleus projective system, and symbolically classify its
small mixed circuits. Search for a second infinite family with tractable exact repair rows,
few-weight behavior, or an additive/design-theoretic reduction. One genuinely new higher-degree
family is the publication gate; a catalogue of exceptional nuclei alone is not.

### C219 — reliability and Boolean analysis of complete repair ports

For a target `x`, regard repairability after a failure set `F` as the monotone Boolean function

```text
f_x(F) = 1  iff  some repair edge is disjoint from F.
```

Develop reliability polynomials, type-dependent and correlated failure models, pivotal-helper
influences, and asymptotic thresholds. Exact port transfer preserves this entire local Boolean
function. Use C202's blocker representatives and group action as the first finite test, but require
a symmetry formula, recurrence, or asymptotic theorem before promoting a stand-alone paper.

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
