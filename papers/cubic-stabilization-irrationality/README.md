# Sharpness of Irrationality after One Stabilization for Cubic Threefolds

[Open the manuscript PDF](cubic_stabilization_irrationality.pdf)

The theorem that every smooth complex cubic threefold remains irrational after
multiplication by `P¹` is sharp. For each of the two displayed smooth cubic
threefolds `X/Q`, the least `m` for which `X × P^m` is rational is exactly two,
over both `Q` and `C`. Rationality at `m=2` is proved here; irrationality at
`m=1` is supplied by the separately cited theorem.

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
- `verification/derive_slice_cover.py` — reconstruction from the type-`I_3`
  matrices, twenty Cox quadrics, and printed witnesses;
- `verification/check_slice_cover.py` — independent exact-arithmetic check of
  the resulting cover and quotient minors;
- `verification/claim-map.json` and `formal-annotations.tex` — claim and
  formal-coverage metadata.

Build and verify from this directory with:

```sh
make check
```

The replay uses SymPy 1.14.0 and exact arithmetic. The generator derives the
saturated type-`I_3` lattice, Cox-weight matrix, residual rank-two quotient,
tangent Jacobian, four symbolic evaluation determinants, and smooth-moduli
cover from the source matrices, twenty Cox quadrics, and printed witnesses.
A second checker independently verifies the exact cover and quotient minors.
The rational quotient, Galois descent, and generic-fibre function-field
arguments are proved in the text, not delegated to the programs. No Lean
development formalizes the new theorem or its corollaries, and their formal
coverage is recorded as `absent`.

The quotient proof is constructive: a tangent-section witness determines the
orbit correction by signed maximal minors and the inverse parametrization by
the displayed elimination graph. No complexity estimate is claimed.

The exact boundary between proved, computationally certified, and imported
claims is recorded in the manuscript annotations and
`verification/imported-sources.json`. No archival DOI is claimed for this
revision.
