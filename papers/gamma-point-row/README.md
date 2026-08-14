# The Point-Class Rank Functional under Birational Wall Crossing

## Read the paper

[**Open the paper (PDF) →**](gamma_point_row.pdf)

**Title:** *The Point-Class Rank Functional under Birational Wall Crossing:
Exact One-Wall Identities toward the \(X\times\mathbf P^2\) Problem*.

The paper proves an exact common-open point-column identity for smooth
projective simple VGIT walls oriented by \(r_+<r_-\), and a path-local
point-row theorem for projective ordinary flops. It also gives analytic and
Fourier--Laplace countermodels
which isolate the remaining two-wall obstruction.

The logical boundary is part of the result:

- the simple-wall ambient point coordinate is exact inside the formal
  Gu--Yu--Yu comparison for \(r_+<r_-\);
- the ordinary-flop point row is exact on a fixed continuation domain;
- the primitive-sixth simple-wall consequence requires a named common
  sectorial-realization hypothesis;
- the finite-factorization statement requires factorwise rank-zero output
  targets;
- a single signed punctual Fourier-boundary coefficient is only a candidate
  shadow of that factorwise condition.

For a smooth cubic threefold `X`, the missing marked blockwise comparison is
part of the assembly problem in the point-row approach to `X × P²`. The paper
does not claim that product is irrational.

## Build

Run:

```text
make check
```

This executes the paper-owned release-surface check, applies the monorepo TeX
spacing lint in the authority repository, rebuilds the PDF with the pinned
Nix toolchain, and fails on LaTeX warnings or overfull boxes. In the
standalone export, the monorepo-only spacing lint is omitted; the mathematical
release check and warning gate remain.

## License

The manuscript is licensed under CC BY 4.0. Correspondence:
<tavisrudd@damnsimple.com>.
