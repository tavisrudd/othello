# The Point-Class Rank Functional under Birational Wall Crossing

## Read the paper

[**Open the paper (PDF) →**](gamma_point_row.pdf)

**Title:** *The Point-Class Rank Functional under Birational Wall Crossing:
Irrationality of \(X\times\mathbf P^m\) for Every Cubic Threefold*.

The paper proves that the zero or nonzero restriction of the Gamma point row
to a formal-monodromy primary packet is invariant under birational maps of
smooth projective varieties. The proof uses one global equivariant cobordism,
rotation localization, balanced Mellin--Barnes continuation, and a finite
common primary quotient. Applied to the primitive-sixth packet of a cubic
threefold, it proves that X × P^m is irrational for every m.

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
applies the monorepo TeX spacing lint in the authority repository, rebuilds
the PDF with the pinned Nix toolchain, and fails on LaTeX warnings or overfull
boxes. In the standalone export, the monorepo-only spacing lint is omitted;
the mathematical release checks and warning gate remain.

## License

The manuscript is licensed under CC BY 4.0. Correspondence:
<tavisrudd@damnsimple.com>.
