# Exact Compositional Transfer of Bounded Linear Recovery

[![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.22051903-blue.svg)](https://doi.org/10.5281/zenodo.22051903)

## Read the paper

[**Open the paper (PDF) →**](compositional_recovery.pdf)

**Title:** *Exact Compositional Transfer of Bounded Linear Recovery*

Scalar recovery thresholds do not compose: an outer code can select an
intermediate functional whose cost scalar minimization discarded. The paper
identifies labelled prescribed-coset costs as an exact compositional state,
proves their min--sum closure, and determines when outer distance collapses
them to a relative-weight formula.

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

## ergodis companion

**ergodis—Exact Recovery, Global Optimization, and Invariant Synthesis—is an
exact compiler and solver derived from the paper's recovery theory.** It
compiles prescribed-coset support functions through labelled concatenation
levels and returns exact helper costs and confinement thresholds. By storing
minimizing lifts alongside the numerical tables, it also returns
coefficient-level witnesses rather than only scalar optima. Its capacity-aware
scheduler selects simultaneous repairs under heterogeneous helper limits and
coefficient-weighted download costs. The same structural compiler accelerates
orbit-structured code search and can shrink residual constraint
programming-satisfiability (CP-SAT) models.

The tool extends the theory into executable optimization; it is not evidence
for the proofs. The mathematical results establish the reductions, and no
theorem relies on the implementation or its measurements.

Its current engines cover hierarchical recovery, capacity-aware batch
scheduling, and orbit-structured code search. Their exact recovery objects
could support further batch and private information retrieval (PIR),
availability, topology-aware repair, service-rate, and recovery-profile design
front ends.

The theorem-driven GF(4) tower benchmark is 344,300 times faster than direct
CP-SAT and 8,080 times faster than CP-SAT receiving the labelled tables. Across
six bundled application examples, matched exact controls range from 8 times
slower to three--five orders of magnitude slower. These are bounded
measurements, not universal solver rankings. When a model has additional
general constraints, ergodis instead supplies an exact preprocessing front end
for residual CP-SAT.

ergodis is developed in its own repository,
[tavisrudd/ergodis](https://github.com/tavisrudd/ergodis), which carries the
quick-start commands, JSON examples, architecture notes, reproducible
benchmarks, and the independent Python reference layer. The measurements
quoted in this paper correspond to that repository's `BENCHMARKS.md` and
`evidence/benchmarks.json` at the release tag named there.

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
- Whenever the exact prescribed-coset threshold holds for each demand, support
  transfer preserves bounded service-rate regions. The outer-dual-distance
  condition is sufficient and holds eventually in families with growing
  dual distance.
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
- `ergodis/` contains the ergodis library, CLI, application examples, tests,
  performance evidence, and an independent Python validation layer.
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

The `ergodis/` software is licensed under the GNU Affero General Public
License, version 3.0 (AGPL-3.0); see `ergodis/LICENSE`. Contact the author for
commercial licensing of ergodis. Everything else in this repository is licensed
under the MIT License; see `LICENSE`.
