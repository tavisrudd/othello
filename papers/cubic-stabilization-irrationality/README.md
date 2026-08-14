# Conditional Irrationality of All Projective Stabilizations of Cubic Threefolds

[![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21937491-blue.svg)](https://doi.org/10.5281/zenodo.21937491)

## Read the paper

[**Open the paper (PDF) →**](cubic_stabilization_irrationality.pdf)

**Title:** *Conditional Irrationality of All Projective Stabilizations of
Cubic Threefolds: Point-Class Rank under Quantum Wall Crossing*.

Assuming the marked threshold compatibility hypothesis stated in the paper,
the product of any smooth complex cubic threefold with any projective space
is irrational. The paper proves an exact ambient point-column identity for a
simple VGIT wall and exact point-row transport across an ordinary flop,
together with countermodels that obstruct naive
composition. For a global equivariant cobordism it proves support collapse
and a coefficientwise balanced Gamma-ratio reduction. It further proves that
the derived fixed clutching stacks are constant along every rank-one tail
between thresholds, so the complete neutral tails are holonomic and tempered.
The remaining analytic input is
locally finite: an isomorphism of cyclic Rees \(z\)-modules at each sign or
stability threshold, and on row-generated nearby cycles at each zero-mode
rank change, must intertwine formal monodromy and carry
the marked point row while preserving the stated Stokes, deck, nearby-cycle,
Artin, and Rees data. Under this hypothesis, the
point-row primary Boolean is birationally invariant and
\(X\times\mathbf P^m\) is irrational for every smooth cubic threefold \(X\)
and every \(m\). A rational two-tail counterexample shows why tailwise
holonomicity alone does not determine the needed threshold maps.

The cubic-specific input is isolated:

- Cai's displayed cubic matrices are reconstructed to obtain the
  primitive-sixth indicial roots;
- a direct Barnes calculation proves that the Gamma point row is nonzero on
  both primitive-sixth lines;
- the product and projective-space endpoint calculations are proved in the
  manuscript and checked by an exact regression artifact.

The earlier one-wall theorems and the incomplete-Gamma/Fourier countermodels
remain in the paper. They explain why a chamberwise telescope is insufficient
and why the common-master construction is needed.

## Build

Run:

    make check

This executes the paper-owned release-surface and cubic-endpoint checks,
applies the monorepo TeX spacing lint in the authority repository, and rebuilds
the manuscript in an isolated directory with the pinned Nix toolchain. The
fresh deterministic PDF must match the tracked PDF byte for byte, so stale
auxiliary files cannot conceal a source/PDF mismatch. The gate also fails on
LaTeX warnings or overfull boxes. After editing manuscript sources, refresh the
tracked artifact with `make manuscript-update`, then run `make check`. In the
standalone export, the monorepo-only spacing lint is omitted; the mathematical
release checks, isolated-build comparison, and warning gate remain.

## License

The manuscript is licensed under CC BY 4.0. Correspondence:
<tavisrudd@damnsimple.com>.
