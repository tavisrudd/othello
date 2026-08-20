# The integral middle cohomology of the theta divisor of a cubic threefold

This paper computes the integral lattice
`IH^3(Theta,Z) = H^3(Bl_0 Theta,Z)` for the theta divisor of the intermediate
Jacobian of a smooth cubic threefold.  The rank-130 group has a canonical
mod-two glue between the ambient exterior algebra and the middle cohomology
of the exceptional cubic.  The paper also computes the dual free rank-ten
escape lattice.

## Build

From this directory, run:

```text
make check
```

The build uses the repository's pinned manuscript environment and fails on
LaTeX warnings or spacing-lint errors.  Every theorem in the paper is proved
structurally; the earlier finite lattice certificates are regression evidence
only and are not part of the manuscript's trust boundary.
