# Exact Transfer of Bounded Linear Recovery and Relative Weight Hierarchies

[![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.22051903-blue.svg)](https://doi.org/10.5281/zenodo.22051903)

## Read the paper

[**Open the paper (PDF) →**](complete_repair_ports.pdf)

**Title:** *Exact Transfer of Bounded Linear Recovery and Relative Weight
Hierarchies*

For a target set `P` and helper set `J`, the target and helper parts of a
generator matrix determine nested codes `K_P ⊆ D_P ⊆ F_q^J`. The paper proves
that the `t`th relative generalized Hamming weight `M_t(D_P,K_P)` is the exact
minimum helper-union size for recovering `t` independent target combinations.
For any outer code with at least two blocks and `d(O⊥) > r+1`, the sharp
confinement condition is

```text
r < M_t(D_P,K_P) + d(I⊥).
```

Below this threshold, zero-extension preserves every bounded normalized
recovery equation and its exact helper support. For outer families whose dual
distance tends to infinity, the finite outer gate is automatic for all
sufficiently large lengths at each fixed `r`.

## Main consequences

- Minimizing the fixed-target recovery cost over all target `t`-sets gives
  `d_t(C⊥) − t`.
- MDS inner codes have an exact recovery-cost staircase. When the helper
  columns span the message space, it attains the confinement ceiling at every
  recovered dimension; equality in that ceiling at dimension one forces
  equality at every dimension.
- Suitable outer families copy the normalized equations onto coordinate
  classes of positive density while retaining positive rate and relative
  distance.
- Once the finite outer-dual-distance gate holds, exact support transfer
  preserves bounded service-rate regions; outer families with growing dual
  distance satisfy the gate eventually.
- Two systems can have identical complete relative-weight hierarchies but
  different bounded repair reliabilities.
- Two coefficient presentations of the same associated nested code pair can
  have different confinement thresholds.
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
paper-local Mathlib package in [`lean/`](lean/) kernel-checks the exact sequence

```text
0 → K_P → D_P → W_P → 0
```

for the associated nested code pair. Its reviewer terminals report only
`Classical.choice`, `Quot.sound`, and `propext`. The RGHW identity,
concatenation-confinement theorem, applications, and separations are explicitly
classified as human-only in [`lean/verification/claims.json`](lean/verification/claims.json).
No coding-theory result is introduced as a Lean axiom.

Each theorem-like environment also carries a typographically empty
machine-readable annotation from [`formal-annotations.tex`](formal-annotations.tex).
The annotations mark the exact sequence as Lean-complete and mark every
stronger theorem as absent from the formal package; they do not alter the
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
evidence boundary. The standalone formal package has its own pinned build and
axiom-audit instructions in [`lean/README.md`](lean/README.md).

## Files

- `complete_repair_ports.tex` is the manuscript driver.
- `formal-annotations.tex` defines the nonprinting formal-coverage and
  dependency macros used by the manuscript.
- `sections/` contains the proofs, applications, conclusion, and verification
  statement.
- `lean/` is the paper-owned Mathlib companion.
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
