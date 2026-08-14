# Point-Class Rank under Quantum Wall Crossing

## Read the paper

[**Open the paper (PDF) →**](gamma_point_row.pdf)

**Title:** *Point-Class Rank under Quantum Wall Crossing: Local Transport,
Global Obstructions, and Cubic Threefolds*.

The paper proves exact point-row transport identities for a simple VGIT wall
and an ordinary flop, together with countermodels that obstruct naive
composition. For a global equivariant cobordism it proves support collapse
and a coefficientwise balanced Gamma-ratio reduction. The remaining
complete-neutral continuation of the nonlinear fixed-graph sum is stated as
an explicit hypothesis. Under that hypothesis, the point-row primary
Boolean is birationally invariant and \(X\times\mathbf P^m\) is irrational
for every smooth cubic threefold \(X\) and every \(m\).

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
