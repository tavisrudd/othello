# Integral cohomology and modular decomposition for the theta divisor of a cubic threefold

[![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.22036585-blue.svg)](https://doi.org/10.5281/zenodo.22036585)

[Download the paper (PDF)](blown_up_theta_lattice.pdf)

This paper computes the integral lattice
`IH^3(Theta,Z) = H^3(Bl_0 Theta,Z)` for the theta divisor of the intermediate
Jacobian of a smooth cubic threefold.  The rank-130 group has a canonical
mod-two glue between the ambient exterior algebra and the middle cohomology
of the exceptional cubic.  The paper also computes the dual free rank-ten
escape lattice and the integral direct image of the resolution.  Its two
outer point summands split integrally, while the central perverse attachment
is multiplication by three and becomes indecomposable in characteristic
three.  More precisely, the reduction is uniserial of length three, and the
same cubic intersection number makes relative hard Lefschetz fail modulo
three.

## Build

From this directory, run:

```text
make check
```

The build uses the repository's pinned manuscript environment and fails on
LaTeX warnings or spacing-lint errors.  Every theorem in the paper is proved
structurally; the earlier finite lattice certificates are regression evidence
only and are not part of the manuscript's trust boundary.
