# Paper: Local-unitary rigidity and quantitative rounding

[![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21681856-blue.svg)](https://doi.org/10.5281/zenodo.21681856)

## Read the paper

[**Open the paper (PDF) →**](ame-lu.pdf)

**Title:** *Local-Unitary Rigidity and Quantitative Rounding for Stabilizer
AME States.*

For every prime power \(q=p^e\) and \(m\geq2\), every product-unitary intertwiner
between stabilizer \(\operatorname{AME}(2m,q)\) states is Clifford on each
party.  The proof reconstructs the complete local Weyl frame from any
\((m+1)\)-party marginal; the resulting minimum-support atlas also classifies
local-unitary equivalence up to local symplectic frame changes.  Transversal
conversions between the associated \([[2m-1,1,m]]_q\) stabilizer encoders are
therefore Clifford factor by factor.

A leakage-aware three-region cleaning argument gives a quantitative theorem:
defect \(\varepsilon\) puts every local factor within \(8\varepsilon\) of a
Clifford throughout the certified radius
\(\Theta(\min\{p^{-1},q^{-1/2},n^{-1/2}\})\).  Weyl--Fourier concentration and
the stabilizer overlap gap select an exact symmetry.  The sharp remaining
boundary is affine: localized commutators recover the symplectic atlas but
cannot control the product-Pauli correction.  Exact MDS--CSS logical groups
and six-point applications belong to the separate
`mds_css_transversal_groups` paper.

## Build

From this directory:

```text
make check
```

The build driver is `main.tex`; section units are under `sections/`. This
paper has no computational supplement or certificate dependency.

## Mathematical scope

For every prime power `q=p^e` and every `m≥2`, each product-unitary
intertwiner between additive stabilizer `AME(2m,q)` states is Clifford on
every party. The support bijections on `(m+1)`-party marginals form a
minimum-support atlas which classifies the residual local symplectic frames.
The Choi interpretation gives a factorwise transversal Clifford no-go for the
associated stabilizer `[[2m-1,1,m]]_q` encoders.

For an approximate product symmetry with defect `ε`, three-region cleaning
and Weyl--Fourier rounding put every local factor within normalized
Hilbert--Schmidt distance `8ε` of a Clifford. Stabilizer-overlap quantization
then selects an exact branch and gives a certified radius

```text
Theta(min{p^-1, q^-1/2, n^-1/2}),  n=2m,
```

with collective residual generator norm at most `pi sqrt(q) ε`. At a
dimension-only radius, the rounded symplectic maps already satisfy the exact
atlas. Localized commutators do not see the affine stabilizer character, so
the remaining product-Pauli correction need not be locally small.

The appendices retain partial-Weyl recognition, detailed two- and `k`-uniform
stability, and the single-marginal and aggregate rounding routes as mechanism
comparisons. They are not competing headline theorems.

## Formal boundary

Selected finite-coordinate, support-profile, diagonal-axis, holonomy,
stabilizer-character, Choi, and second-moment cores are kernel checked in the
shared `RelativeConicArcs.AMELU` namespace. The cleaning constants, Fourier
rounding, global quantitative theorem, robust atlas compatibility, and affine
obstruction are manuscript proofs without Lean or certificate coverage. A
paper-specific semantic gate has not yet replaced the pre-split aggregate.
The tracked release manifest and standalone evidence package likewise still
describe the pre-split combined manuscript; they are not a release-ready
statement of this Paper I scope.
