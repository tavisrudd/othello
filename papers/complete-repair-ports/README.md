# Exact Compositional Transfer of Bounded Linear Recovery

[![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.22051903-blue.svg)](https://doi.org/10.5281/zenodo.22051903)

## Read the paper

[**Open the paper (PDF) →**](compositional_recovery.pdf)

**Title:** *Exact Compositional Transfer of Bounded Linear Recovery*

Scalar recovery thresholds do not compose: an outer code can select an
intermediate functional whose cost scalar minimization discarded. The paper
identifies labelled prescribed-coset costs as an exact compositional state,
proves their min--sum closure, and determines when outer distance collapses
them to a relative-weight formula. A stronger operational theorem transfers
minimal recovery supports whenever every outer dual word touching the target
has weight greater than `r+1`, without the inner additive restriction needed
for equation confinement. Quotient-labelled lifting, support antichains,
weighted pricing, and fixed-query boundary width connect composition to
operational optimization.

For a target set `P` and helper set `J`, shortening and puncturing the inner
dual onto `J` give `K_P = short_J(I⊥) ⊆ D_P = punct_J(I⊥)`. Thus the pair depends
only on the inner code and the target/helper split, not on a generator-row
basis. The paper proves
that the `t`th relative generalized Hamming weight `M_t(D_P,K_P)` is the exact
minimum helper-union size for recovering `t` independent target combinations.
For any nonzero target-message subspace, an outer code with at least two
blocks, and a target block with nonzero coordinate projection, the exact finite
nonconfinement cost is an optimization
of prescribed-coset support costs over the complete outer functional dual. For
any outer code with at least two blocks and `d(O⊥) > r+1`, this criterion
reduces to

```text
r < M_t(D_P,K_P) + d(I⊥).
```

Below this threshold, zero-extension preserves every bounded normalized
recovery equation and its exact helper support. For outer families whose dual
distance tends to infinity, the outer-distance condition is automatic for all
sufficiently large lengths at each fixed `r`.
Across all recoverable target subspaces, nonconfinement is already detected
in dimension one: restricting a nonconfined higher-rank system to a
line cannot increase its helper support. Thus the rank-one threshold governs
whether every internally recoverable target subspace is confined at a fixed
radius.

For one target coordinate, the general theorem becomes the scalar
target-constrained coset-weight formula. It can certify transfer when ordinary
outer support distance cannot; a construction using a Singer cycle and
`[k+1,k,2]_q` inner codes gives explicit examples.

For repeated concatenation, the labelled ordinary prescribed-coset support
functions compose by exact min-sum substitution. Helper-restriction costs
together with the target images give the target-normalized recursion, and the
inner-dual distance obeys a compatible formula. Thus the exact nonconfinement
cost can be evaluated through any finite tower while retaining the zero and
nonzero functional sectors. Through helper radius `r`, every numerical
distinction is detected by an outer context of length at most `max(2,r+1)` and
functional-dual dimension at most `min(t,r)`. The resulting finite response
vector is the coarsest exact bounded numerical state and is preserved by
further compatible concatenation; at rank one it has an explicit projective
description. A single scalar threshold is not sufficient input
for this recursion; in particular, the zero-functional nonconfinement cost
`rho_T(I)+d(I⊥)` loses the required functional labels.

## Ergodis companion

[Ergodis](https://github.com/tavisrudd/ergodis) is now a separately developed
compiler and exact solver for finite algebraic optimization. Its source and
software license are maintained in that repository; the paper does not bundle
the engine.

The September 2026 development system includes labelled recovery composition
and witness expansion; compressed support families; Pareto scheduling and
Lagrangian bounds; finite observational minimization and admission of new
readouts; algebraic and symmetry-based search, including bounded CSS distance;
and portable campaign and saved-run interfaces for native and browser hosts.
Release snapshots may expose a smaller surface. The repository's `DESIGN.md`,
`OPTIMIZATION.md`, and interface documentation describe the implemented scope.

Independent verification has explicit contracts. `ergodis-verify` checks a
bounded binary-composition restriction and, separately, authenticated min-plus
summary transitions. Those checks do not establish every source lowering or
every solver answer's optimality. A stored witness proves feasibility; a
matching validated lower or dual bound is needed for an optimum certificate.
The paper's Lean companion remains a separate artifact with narrower coverage.

The manuscript retains the earlier recovery benchmark snapshot as bounded
historical measurements. It does not extend those speedups to the expanded
system. The empirical question is which interface widths, target ranks, block
types, resource frontiers, and reuse patterns make compilation worthwhile,
including compilation, query, witness, and verification costs.

## Main consequences

- Minimizing simultaneous recovery cost over all target `e`-sets gives
  `d_e(C⊥) − e`.
- MDS inner codes have an exact recovery-cost staircase. When the helper
  columns span the message space, it attains the confinement ceiling at every
  recovered dimension; equality in that ceiling at dimension one forces
  equality at every dimension.
- Suitable outer families copy the normalized equations onto coordinate
  classes of positive density while retaining positive rate and relative
  distance.
- Target-touching outer dual distance greater than `r+1` preserves minimal
  supports, reliability under any availability law with the same local
  marginal, fractional service regions, and support-based integral allocations.
  Growing outer dual distance gives eventual transfer at every fixed radius.
- Two systems can have identical complete relative-weight hierarchies but
  different bounded repair reliabilities.
- Different ambient inner-dual realizations of the same abstract nested pair
  can have different confinement thresholds. This is not a change of generator
  basis for one fixed inner code.
- A projective-simplex family has
  `M_t = (q^m − q^(m−t))/(q−1)` and an explicit reliability law in terms of
  projective ranks.

The scalar repair model downloads one base-field symbol from each participating
helper. The paper does not make a repair-bandwidth or subpacketization claim.

[`REVIEWER_GUIDE.md`](REVIEWER_GUIDE.md) gives a short route through the
principal proof and an explicit checklist for hidden hypotheses, quantifier
changes, convention shifts, and evidence-scope claims.

## Proof and evidence scope

The manuscript contains human proofs of the complete theorem chain. The
paper-owned Lean companion in [`lean/`](lean/), built with Lean 4 against a
pinned Mathlib revision, kernel-checks the exact sequence

```text
0 → K_P → D_P → W_P → 0
```

for the associated nested code pair. Its reviewer terminals report only
`Classical.choice`, `Quot.sound`, and `propext`. The RGHW identity, exact
prescribed-coset transfer theorem, its confinement specializations,
applications, and separations are explicitly
classified as human-only in [`lean/verification/claims.json`](lean/verification/claims.json).
No coding-theory result is introduced as a Lean axiom.

Each theorem-like environment also carries a typographically empty
machine-readable annotation from [`formal-annotations.tex`](formal-annotations.tex).
The annotations mark the exact sequence as Lean-complete and mark every
stronger theorem as absent from the formal companion; they do not alter the
rendered manuscript. Detached proofs identify the statement they prove, so
their dependency annotations are checked at claim level.

The two displayed rank-one reliability polynomials are obtained from the
printed union-size table by inclusion–exclusion. Finite replay artifacts may
audit examples, but no exhaustive computation is a premise of a body theorem.

## Verification

From this directory,

```text
make check
```

performs a clean deterministic rebuild, checks the tracked PDF and metadata,
rejects TeX warnings and private-path leakage, and validates the declared
evidence scope. The standalone formal companion has its own pinned build and
axiom-audit instructions in [`lean/README.md`](lean/README.md).

## Files

- `compositional_recovery.tex` is the manuscript driver.
- `formal-annotations.tex` defines the nonprinting formal-coverage and
  dependency macros used by the manuscript.
- `sections/` contains the proofs, applications, conclusion, and verification
  statement.
- `lean/` is the paper-owned Lean 4 companion and depends on a pinned Mathlib
  revision.
- `verification/` contains release and evidence checks.
- `refs.bib` contains the bibliography.
- `.zenodo.json` contains deposit metadata; it creates no deposit or DOI.

## Citation

The existing Zenodo record is
[`10.5281/zenodo.22051903`](https://doi.org/10.5281/zenodo.22051903). A new
record version must be deposited before that record can be cited as the
archive of this rewrite.

## License

This paper and its formal companion are licensed under the MIT License; see
`LICENSE`. The separate Ergodis repository carries its own software license.
