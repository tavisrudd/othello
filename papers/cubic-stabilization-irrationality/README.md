# Explicit Cubic Threefolds Rational after Two Stabilizations

[![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21937490-blue.svg)](https://doi.org/10.5281/zenodo.21937490)

[Open the manuscript PDF](cubic_stabilization_irrationality.pdf)

For each of the two displayed smooth cubic threefolds `X/Q`, the least `m`
for which `X × P^m` is rational is exactly two, over both `Q` and `C`.
Rationality at `m=2` is proved here; irrationality at `m=1` is supplied by the
separately cited theorem for all smooth complex cubic threefolds.

The reusable theorem concerns a smooth quartic del Pezzo surface `S` over a
characteristic-zero field `k`: if `S(k)` is nonempty and the geometric Picard
lattice is a stably permutation Galois module, then `S × A²`, equivalently
`S × P²`, is `k`-rational. It applies to every member of both explicit
Tschinkel–Zhang families of cubic hypersurfaces. Their stable-rationality
conclusions therefore hold with the uniform bound `P²`.

Taking `Y = X × P¹` gives a nonrational smooth projective fourfold over `Q`
for which `Y × A¹` is rational. This is birational rationality after
affine-line stabilization, not the Zariski cancellation problem for
isomorphic affine cylinders.

The canonical release files are:

- `cubic_stabilization_irrationality.tex` — manuscript source;
- `cubic_stabilization_irrationality.pdf` — generated manuscript;
- `.zenodo.json` — deposition metadata;
- `LICENSE` — CC BY 4.0 license;
- `flake.nix` and `flake.lock` — pinned standalone build environment;
- `verification/slice-cover-certificate.json` — exact certificate;
- `verification/check_slice_cover.py` — exact-arithmetic replay checker;
- `verification/claim-map.json` and `formal-annotations.tex` — claim and
  formal-coverage metadata.

Build and verify from this directory with:

```sh
make check
```

The replay uses SymPy 1.14.0 and exact arithmetic. It checks the Cox-weight
matrix and tangent-incidence certificate; the rational quotient, Galois
descent, and generic-fibre function-field arguments are proved in the text,
not delegated to the checker. No Lean development formalizes the new theorem
or its corollaries, and their formal coverage is recorded as `absent`.

The quotient proof is constructive: a tangent-section witness determines the
orbit correction by signed maximal minors and the inverse parametrization by
the displayed elimination graph. No complexity estimate is claimed.

The exact boundary between proved, computationally certified, and imported
claims is recorded in the manuscript annotations and
`verification/imported-sources.json`. The assigned Zenodo DOI is displayed
above.
