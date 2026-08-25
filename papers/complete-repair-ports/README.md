# Exact Transfer of Bounded Linear Recovery and Relative Weight Hierarchies

[![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.22051903-blue.svg)](https://doi.org/10.5281/zenodo.22051903)

## Read the paper

[**Open the paper (PDF) →**](complete_repair_ports.pdf)

**Title:** *Exact Transfer of Bounded Linear Recovery and Relative Weight
Hierarchies*

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
distance tends to infinity, the finite outer gate is automatic for all
sufficiently large lengths at each fixed `r`.

For one target coordinate, the general theorem becomes the scalar
target-constrained coset-weight formula. It can certify transfer when ordinary
outer support distance cannot; a construction using a Singer cycle and
`[k+1,k,2]_q` inner codes gives explicit examples.

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
  gate is a sufficient condition and holds eventually in families with growing
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
changes, convention shifts, and evidence-boundary claims.

## Proof and evidence boundary

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
evidence boundary. The standalone formal companion has its own pinned build and
axiom-audit instructions in [`lean/README.md`](lean/README.md).

## Files

- `complete_repair_ports.tex` is the manuscript driver.
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

The contents of this repository are licensed under the MIT License; see
`LICENSE`.
