# Frobenius-equivariant pair extension and robust repair of eight-arcs

[![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.22051736-blue.svg)](https://doi.org/10.5281/zenodo.22051736)

**Title:** *Frobenius-equivariant pair extension and robust repair of
eight-arcs.*

[Read the paper (PDF)](equivariant-robust-completion.pdf)

## Results and scope

The paper studies arcs—sets of projective points with no three collinear—that
are invariant under a quadratic Frobenius involution. It proves an exact
orbit-valued criterion for adjoining conjugate pairs, identifies the
invisible-center and collision corrections that make the count exact, and
turns the count into a robust orbit-replacement theorem.

Every invariant eight-arc in PG(2,25) has at least four
distinct legal conjugate pairs. In the two-fixed-point profile the exact minimum
is 32; after normalization, equality is represented by five residual-group
orbits of sizes 200, 400, 400, 200, and 400. More generally, the certified profile
envelope gives at least 318 alternate repairs after a selected orbit is
deleted, and the parameterized (k + 2) → k theorem gives the corresponding
puncture-and-re-extend bound.

Under the arc–code correspondence these are Frobenius-compatible paired
two-column extensions and replacements of dimension-three MDS codes. The paper
remains finite-geometric in method: “repair” changes the generator-column
configuration rather than decoding an erasure in a fixed code.

The Clebsch specialization is secondary. After scalar extension to
GF(121), every GF(11)-rational six-arc has 4,180 legal paired extensions and
4,179 alternate repairs after one is
selected. This is a corollary of the general carrier count, not a separate
Clebsch theorem.

## Verification boundary

The quadratic criterion, semantic global count, collision correction, and
robust exchange theorem have human-scale Lean support.  The normalized finite
step in the PG(2,25) classification is pinned to a separate
Mathlib-only [certificate package](https://github.com/tavisrudd/finitegeom-q25-certificates);
the two projective normalizations and semantic transport remain manuscript
arguments. The public package pins Lean and mathlib and checks all 46,056
normalized rows. The paper records which claims are kernel checked, which are
proved in the manuscript, and which classical inputs are imported.

The repository contains the focused LaTeX manuscript, bibliography, PDF,
Zenodo metadata, and verification surface. The manuscript entry point is
`equivariant-robust-completion.tex`; its numbered sections live under
`sections/`. Exact artifact pins and reproduction instructions are in
[`verification/README.md`](verification/README.md).

## Build

Run `make check` from the repository root. The command enters the pinned Nix
manuscript environment, checks the public release surface and certificate pin,
rebuilds the paper with Tectonic, rejects LaTeX or layout warnings, and requires
the tracked PDF to match the clean build byte for byte. To refresh the PDF after
a manuscript edit, run `make update-pdf`.

The paper verifier deliberately performs only a source-identity check on an
existing certificate checkout. It never starts the certificate package's large
Lean build; that independent check is documented separately in the verification
instructions.

## Citation

The archival record is [doi:10.5281/zenodo.22051736](https://doi.org/10.5281/zenodo.22051736).

## License

The manuscript and repository metadata are licensed under
[CC BY 4.0](LICENSE).
