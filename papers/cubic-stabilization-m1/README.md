# Cubic stabilization at m = 1

<a href="https://doi.org/10.5281/zenodo.21909943"><img src="https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21909943-blue.svg?cacheSeconds=3600&amp;v=21909943" alt="DOI: 10.5281/zenodo.21909943"></a>

## Primary paper

[**Open the paper (PDF) →**](irrationality_after_one_stabilization.pdf)

[**Reviewer guide →**](REVIEWER_GUIDE.md)

**Title:** *Irrationality of cubic threefolds after one stabilization.*

For every smooth complex cubic threefold `X`, the paper proves that
`X x P^1` is irrational.  The proof decomposes the generic even quantum
`D`-module into blocks and records their isomorphism classes in a free
commutative monoid.  An additive rank-two formal-exponent marker vanishes on
every center that can occur in weak factorization in dimension four, doubles
under product with `P^1`, detects the cubic block, and vanishes on projective
space.  The same construction gives an irrationality criterion for smooth
projective threefolds and the one-stabilization theorem for smooth prime Fano
threefolds of genus eight.

## Companion papers

The repository currently keeps two logically separate companions beside the
primary paper:

- [`companions/six-axis-cubic-pencil/`](companions/six-axis-cubic-pencil/):
  *Integral divisor products on the nonstandard A5-invariant cubic pencil*.
  It constructs the primitive minimal class and proves universal
  `CH_0`-triviality over the smooth pencil.
- [`companions/cubic-framed-monodromy/`](companions/cubic-framed-monodromy/):
  *Framed formal monodromy of cubic threefolds*.  Its cubic and product counts
  are unconditional; its operation formulas and birational invariance retain
  the explicitly stated reconstruction and divisor-tagging hypotheses.

The companions are not sections of the primary paper and are not required to
read its proof.

## Build and verification

Run `make check` in each manuscript directory:

```text
make check
make -C companions/six-axis-cubic-pencil check
make -C companions/cubic-framed-monodromy check
```

The root check validates the shared manuscript-to-Lean claim inventory,
builds the primary PDF in the pinned environment, and rejects manuscript
warnings.  It does not build Lean or replay a captured axiom audit;
[`lean/README.md`](lean/README.md) documents the separate artifact and checker
semantics.

## Trust boundary

The primary theorem is unconditional in the mathematical sense: the remaining
dependencies are cited geometric theorems, not conjectural reconstruction
hypotheses.  The framed companion labels every result that depends on its two
residual hypotheses.  Computational evidence and exact replay commands are
registered in [`verification/evidence.json`](verification/evidence.json).

The Lean 4 companion in [`lean/`](lean/), built against Mathlib, is a partial
reviewer artifact covering all three manuscripts in this repository.  Its
rejecting inventory
distinguishes proved fragments and conditional deductions from absent claims.
The claim-level trust boundary is recorded in
[`lean/verification/claims.json`](lean/verification/claims.json), with
kernel-reported dependencies checked against
[`lean/verification/expected_axioms.txt`](lean/verification/expected_axioms.txt).

## Repository contents

- [`cubic_stabilization_m1.tex`](cubic_stabilization_m1.tex): primary paper.
- [`sections/`](sections/): primary-paper sections.
- [`companions/`](companions/): the two separate companion manuscripts.
- [`lean/`](lean/): Lean 4 companion built against pinned Mathlib, with its
  reviewer interface.
- [`verification/`](verification/): claim coverage and computational evidence.
- [`.zenodo.json`](.zenodo.json): archival deposit metadata.

## Citation and license

The archival DOI is
[`10.5281/zenodo.21909943`](https://doi.org/10.5281/zenodo.21909943).
The repository is licensed under CC BY 4.0; see [`LICENSE`](LICENSE).
