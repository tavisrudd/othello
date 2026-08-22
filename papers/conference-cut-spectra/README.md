# Balanced Cuts of Conference Matrices: Squared-Spectrum Rigidity and Hermitian Holonomy

**Paper alias:** `conference-cut-spectra`

[![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21766747-blue.svg)](https://doi.org/10.5281/zenodo.21766747)

[Read the paper (PDF).](conference_cut_spectra.pdf)

This paper studies the complementary cross-block spectra of balanced cuts in
symmetric and Hermitian conference matrices. Order six is the unique
nontrivial symmetric conference order for which the normalized squared
singular spectrum is independent of the cut. In that order, the twenty
balanced sign vectors are also the unique maximizers of each degree-three
Schur sector over the full cube.

For Hermitian conference matrices of order six, the conference identities fix
the first two exchange moments, while squared real triangle holonomy
parametrizes the complete Pareto frontier of the three degree-three sectors.
Constancy on balanced cuts characterizes the real switching class, and an
averaged squared-holonomy defect gives quantitative stability.

The paper also develops a six-mode conference interferometer as an application.
This is a mathematical and design-limit analysis, not a report of a built
device.

## Reproducing the results

The repository includes the manuscript, verification programs, and compact
certificates for its computational claims. Run the full check with:

```sh
make check
```

See `verification/README.md` for the verification map and the scope of each
check.
