# Standard flips of discrepancy one

[![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21924799-blue.svg)](https://doi.org/10.5281/zenodo.21924799)

## Read the paper

[**Open the paper (PDF) →**](discrepancy_one_flips.pdf)

**Title:** *Standard flips of discrepancy one: extremal `J`-normalization and
the Meijer aperture at `nu = 1`.*

Shen and Shoemaker (arXiv:2502.08762) compute the extremal quantum spectrum
of a standard flip `X --> X'` with exceptional locus `P(V)` inside `X`, where
`V` and `V'` have ranks `r` and `s`, and show that the Gamma-class
decomposition of `H^*(X)` attached to the Belmans-Fu-Raedschelders
semiorthogonal decomposition is a decomposition into asymptotic classes.

Their explicit formula for the extremal `J`-function of the local model is
stated under `r - s > 1`, a remark asserts that the same series is not
`J`-normalized when `r - s <= 1`, and the Barnes asymptotic expansion is
applied under the same inequality.  The printed dependency chain therefore
does not reach the discrepancy-one range `r = s + 1`, `s >= 1`, which
contains every codimension-two blow-up.

This note supplies the two missing steps.  An exact `z`-order count shows
that the degree-`d` summand of the series has `z`-order at most
`1 - s - (r - s) d`, hence at most `-1` for every `d >= 1` when `r = s + 1`
and `s >= 1`; with the cone membership already recorded in the source, this
identifies the series with the extremal `J`-function.  At `nu = r - s = 1`
the correct Meijer sector comes from Barnes' expansion with `epsilon = 1/2`
rather than from specializing the printed sector, and the corrected sector
still meets the ambient one in an open sector of opening `2 pi` containing
both the eigenvalue ray and the tame ray.  The rank-one projective-bundle
endpoint `(r, s) = (1, 0)`, whose fibres contain no extremal line, is
excluded; its formal hypergeometric expression already fails the required
normalization.

## Build

From this directory, run:

```text
make check
```

This rebuilds the manuscript with `latexmk` and fails on any LaTeX warning
or overfull box.  The toolchain is pinned by the flake
in this directory; `make` calls it through `nix develop`.  There is no
computational or formal artifact: every claim in the note is proved in the
text.

## License

The contents of this repository are licensed under CC BY 4.0; see `LICENSE`.
