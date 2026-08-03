# Paper: Local-unitary rigidity and quantitative rounding

**Title:** *Local-Unitary Rigidity and Quantitative Rounding for Stabilizer
AME States.*

**Lane:** `ame-lu`

**Status:** Paper I of the completed manuscript split. The source builds as a
35-page paper centered on exact stabilizer-AME rigidity, cleaning-based
quantitative rounding, the minimum-support atlas, and the affine
stabilizer-character obstruction. The MDS--CSS exact-group, six-point,
computational, transport, and party-extension material is owned by the
separate `mds_css_transversal_groups` paper.

Public identifiers, deposit, and submission remain author gates. The release
manifest, paper-specific formal-root contract, and standalone synchronization
are later split phases and have not been refreshed from the pre-split
baseline.

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
