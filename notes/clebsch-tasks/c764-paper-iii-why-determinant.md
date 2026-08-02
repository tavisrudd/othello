# C764 — Paper III “why determinant” boundary

**Lane:** `clebsch`

**Status:** complete; reported 2026-08-01.

## Objective

Add the smallest useful explanation of why the operator construction produces
a determinant rather than a permanent, without importing the Golden quantum
inventory into Paper III.

## Result

The operator section now says that the determinant is the basis-free map on
determinant lines (and becomes a scalar after orientation), whereas the
permanent changes under the internal orthonormal-frame gauge.  The one-line
rotation test sends `per(I_3)=1` to `cos(2 theta)`, so the obstruction is visible
without quantum formalism or C718's larger census.  The isolated authoritative
release aggregate, including statement identity and a warning-free manuscript
build, passes.  Full report:
`notes/2026-08-01-c764-paper-iii-why-determinant.md`.
