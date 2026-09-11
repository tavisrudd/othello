# Cubic stabilization at m = 1

<a href="https://doi.org/10.5281/zenodo.21909943"><img src="https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21909943-blue.svg?cacheSeconds=3600&amp;v=21909943" alt="DOI: 10.5281/zenodo.21909943"></a>

## Primary paper

[**Open the paper (PDF) →**](irrationality_after_one_stabilization.pdf)

[**Reviewer guide →**](REVIEWER_GUIDE.md)

**Title:** *Irrationality of cubic threefolds after one stabilization.*

For every smooth complex cubic threefold `X`, the paper proves that
`X x P^1` is irrational.  The proof decomposes the generic even quantum
`D`-module into whole primary blocks. An intrinsic rank-two exponent count vanishes on
every center that can occur in weak factorization in dimension four, doubles
under product with `P^1`, detects the cubic block, and vanishes on projective
space. The cubic proof finishes before the other applications.

The numerical part proves that rationality is unchanged by one stabilization
for all seventeen smooth complex Picard-rank-one Fano families. Five families
are detected by the canonical rank-two residue, including resonant blocks;
four are detected by the odd dimension on an even-rank-three factor.
The other eight families are rational.

The second part proves that birational first stabilizations of members of
the nine detected families have isomorphic rational third Hodge structures.
It retains the full cohomology fiber over a Hodge-fixed parameter base.
This theorem adds no integral or polarized identification. Very-general
cubic/quartic cancellation is a short Torelli consequence; bounded-degree
geometric cubic-partner finiteness is an arithmetic appendix.

The count and the multiset of exact residue discriminants extend additively
to `K0(Var_C)/(L-1)` in an optional appendix. These broader bundle and additive
results retain Iritani–Koto's general theorem. The main numerical and Hodge
proofs use the specialized P1 argument and an explicit ruled-product potential.

For the rank-two counts, *even* means both an even bulk base and the even
cohomology fiber. The odd-dimension and Hodge refinements keep the full fiber.
*Generic* refers to quantum parameters, not to a general moduli point.

## Companion papers

This paper directory contains two logically separate technical companions:

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

A separate forward companion,
[*Sharpness of Irrationality after One Stabilization for Cubic
Threefolds*](../cubic-stabilization-irrationality/), proves that the bound is
sharp.  It gives two explicit smooth cubic threefolds over `Q` for which
`X x P^1` is irrational but `X x P^2` is rational.  That paper uses the
one-stabilization theorem here as an input; it is not an input to this paper.

## Build and verification

Run `make check` in each manuscript directory:

```text
make check
make -C companions/six-axis-cubic-pencil check
make -C companions/cubic-framed-monodromy check
```

The root check validates the shared manuscript-to-Lean claim inventory,
replays the finite Fano certificate with two independent implementations,
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
