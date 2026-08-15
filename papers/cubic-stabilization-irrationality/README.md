# Gamma Point Rows under Quantum Wall Crossing and a Criterion for Stable Irrationality

[![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21937490-blue.svg)](https://doi.org/10.5281/zenodo.21937490)

## Read the paper

[**Open the paper (PDF) →**](cubic_stabilization_irrationality.pdf)

**Title:** *Gamma Point Rows under Quantum Wall Crossing and a Criterion for
Stable Irrationality*.

Assuming a gauged-admissible marked Włodarczyk completion and the
inverse-system family of one-object marked threshold comparisons stated in the paper,
the product of any
smooth complex cubic threefold with any projective space is irrational. The
paper proves an exact ambient point-column identity for a
simple VGIT wall and exact point-row transport across an ordinary flop,
together with countermodels that obstruct naive
composition. For a global equivariant cobordism it proves support collapse
and a coefficientwise balanced Gamma-ratio reduction. It further proves that
the derived fixed clutching stacks are constant along every rank-one tail
between thresholds, so the complete neutral tails are holonomic and tempered.
Beyond gauged-admissibility, the remaining unproved input is a family of
one-object local comparisons over all finite Artin levels,
ordinary degrees, neutral directions, and thresholds. At sign and stability
thresholds it compares cyclic Rees \(z\)-modules; at zero modes it compares
row-generated reduced nearby cycles. These maps must carry the marked row,
intertwine formal monodromy, preserve the stated Stokes, deck, Artin, and Rees
data, and identify the entire adjacent row-generated cyclic module with its
reduced nearby-cycle realization. Primary support is then preserved by
polynomial functional calculus. Under these assumptions, the
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
