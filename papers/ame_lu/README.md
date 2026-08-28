# Robust Local-Unitary Rigidity of Stabilizer AME States

[![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21681856-blue.svg)](https://doi.org/10.5281/zenodo.21681856)

## Read the paper

[**Open the paper (PDF) →**](ame-lu.pdf)

**Title:** *Robust Local-Unitary Rigidity of Stabilizer AME States.*

For every prime power \(q=p^e\) and \(m\geq2\), every product unitary mapping
one stabilizer \(\operatorname{AME}(2m,q)\) state to another is Clifford on
each party.  Any \((m+1)\)-party marginal determines the complete local Weyl
frame.  The transition maps between those frames classify local-unitary
equivalence, and every transversal conversion between the associated
\([[2m-1,1,m]]_q\) stabilizer encoders is Clifford factor by factor.
Only \(m\) minimum supports are needed for recognition; with party labels
fixed, equivalence reduces to testing at most
\(\lvert\operatorname{Sp}_{2e}(\mathbb F_p)\rvert\) base frames.

A leakage-aware three-region cleaning argument gives a quantitative theorem:
defect \(\varepsilon\) puts every local factor within \(8\varepsilon\) of a
Clifford throughout the certified radius
\(\Theta(\min\{p^{-1},q^{-1/2},n^{-1/2}\})\).  Weyl--Fourier concentration and
the stabilizer overlap gap select an exact symmetry.  At a separate
local-dimension-dependent radius, localized commutators recover the linear
transition data but do not control the stabilizer-character, or
product-Pauli phase, correction.  Exact MDS--CSS logical groups
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
every party. The support bijections on `(m+1)`-party marginals define
transition maps that classify the residual local symplectic frames.
The Choi interpretation gives factorwise transversal Clifford rigidity for
conversions between the associated stabilizer `[[2m-1,1,m]]_q` encoders.

For an approximate product symmetry with defect `ε`, three-region cleaning
and Weyl--Fourier rounding put every local factor within normalized
Hilbert--Schmidt distance `8ε` of a Clifford. Stabilizer-overlap quantization
then selects an exact branch and gives a certified radius

```text
Theta(min{p^-1, q^-1/2, n^-1/2}),  n=2m,
```

with collective residual generator norm at most `pi sqrt(q) ε`. At a
dimension-only radius, the rounded symplectic maps already satisfy the exact
transition system. Localized commutators do not see the stabilizer character, so
the remaining product-Pauli correction need not be locally small.

The appendices retain detailed two- and `k`-uniform stability and the
single-marginal and aggregate rounding routes as mechanism comparisons. They
are not competing headline theorems.

## Formal boundary

Selected finite-coordinate, support-profile, diagonal-axis, holonomy,
stabilizer-character, Choi, and second-moment cores are kernel checked in the
shared `RelativeConicArcs.AMELU` namespace. The cleaning constants, Fourier
rounding, global quantitative theorem, robust transition compatibility, and
stabilizer-character correction are manuscript proofs without Lean or
certificate coverage. The
corrected local release surface now includes the repaired (m=2) proof bridge,
the phase-convention clarification, and the current related-work boundary.
The standalone mirror is synchronized locally but remains unpushed; public
deposit and submission are author decisions.
