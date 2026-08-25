# Sharpness of Irrationality after One Stabilization for Cubic Threefolds

## Read the paper

[**Open the manuscript (PDF) →**](cubic_stabilization_irrationality.pdf)

The theorem that every smooth complex cubic threefold remains irrational
after multiplication by `P¹` is sharp. For each of two displayed smooth cubic
threefolds `X/Q`, this paper proves

```text
ell_Q(X) = ell_C(X_C) = 2.
```

Equivalently, `X_C × P¹` is irrational while `X × P²` is rational over `Q`.
The lower bound is the separately cited one-stabilization theorem for every
smooth complex cubic threefold, pinned here to
[version 0.15.0](https://doi.org/10.5281/zenodo.22088961); this paper proves
the upper bound.

## Main results and consequences

- If `k` has characteristic zero and `S/k` is a smooth quartic del Pezzo
  surface with `S(k)` nonempty and stably permutation geometric Picard
  lattice, then `S × A²`, equivalently `S × P²`, is `k`-rational. In
  particular, this holds for every stably `k`-rational smooth quartic del
  Pezzo surface.
- The proof gives a reusable rational-quotient criterion for a generically
  free torus action on a variety parametrized by generic tangent projection.
  A saturated unimodular weight window cuts a rational section of the general
  orbit, and a tangent-projection open identifies that section with projective
  space.
- For both Tschinkel–Zhang series `X_{j,r}` of smooth cubic hypersurfaces,
  `X_{j,r} × P²` is rational over `Q` for every `r ≥ 0` and `j ∈ {1,3}`.
  Their stable-rationality conclusions therefore hold with a uniform `P²`
  bound.
- For either cubic threefold `X`, the smooth projective fourfold
  `Y = X × P¹` is nonrational even over `C`, while `Y × A¹` is rational over
  `Q`. This answers the affine-line stabilization question raised by
  Tschinkel and Zhang.
- On the moduli space of smooth complex cubic threefolds, the stabilization
  level is two on the classes represented by the displayed examples and
  infinite at a very general point.

The paper does not claim that every smooth cubic threefold has finite
stabilization level. The fourfold consequence concerns birational rationality
after multiplication by `A¹`; it is not a statement about Zariski cancellation
for isomorphic affine cylinders.

## Proof and evidence boundary

We prove the quotient, Galois descent, quartic del Pezzo reduction, and
generic-fibre function-field arguments in the manuscript. We use the Cox and
one-apparent-double-point geometry, universal-torsor splitting, four-type
Galois classification, and explicit cubic fibrations of Tschinkel and Zhang
at their stated pinpoints.

The exact-arithmetic generator
[`verification/derive_slice_cover.py`](verification/derive_slice_cover.py)
starts from the transcribed type-`I₃` matrices and twenty Cox quadrics. It
reconstructs the saturated rank-three lattice, Cox weights, residual rank-two
quotient, tangent Jacobian, four symbolic evaluation determinants, and the
smooth-moduli witness cover. For each of the six empty localized branches,
[`verification/groebner-empty-certificates.json`](verification/groebner-empty-certificates.json)
retains an exact identity expressing a nonzero constant in the localized
branch ideal. It also constructs the actual evaluation-kernel slice through
the orbit-test point and renders all computation-derived values printed in the manuscript into the checked
[`verification/slice-cover-values.tex`](verification/slice-cover-values.tex)
artifact. A second program,
[`verification/check_slice_cover.py`](verification/check_slice_cover.py),
independently checks the resulting certificate and quotient minors. Both
programs reject optimized Python execution so that assertion checks cannot be
disabled.

No Lean development formalizes the new quotient theorem, the surface theorem,
or their corollaries. Their formal coverage is recorded as `absent` in
[`verification/claim-map.json`](verification/claim-map.json). The exact
boundary between proved, imported, and computationally certified claims is
recorded there and in
[`verification/imported-sources.json`](verification/imported-sources.json).

## Verification

From this directory, enter the pinned development shell and run the full gate:

```text
nix develop --command make check
```

This command reconstructs and independently checks the exact certificate,
validates the claim and source ledgers, performs a deterministic manuscript build, and
rejects TeX warnings or stale metadata.

The retained empty-branch identities can be regenerated independently with
Singular 4.4.1 and then rechecked by the full gate:

```text
nix shell nixpkgs#singular -c uv run --with sympy==1.14.0 python3 \
  verification/generate_groebner_empty_certificates.py \
  --write-certificate verification/groebner-empty-certificates.json
```

## Files

- `cubic_stabilization_irrationality.tex` — manuscript source;
- `cubic_stabilization_irrationality.pdf` — generated manuscript;
- `formal-annotations.tex` — nonprinting claim annotations;
- `verification/derive_slice_cover.py` — exact reconstruction program;
- `verification/generate_groebner_empty_certificates.py` — optional Singular
  regeneration of the retained empty-branch identities;
- `verification/check_slice_cover.py` — independent consequence checker;
- `verification/slice-cover-certificate.json` — canonical exact certificate;
- `verification/groebner-empty-certificates.json` — retained exact identities
  for the six empty localized branches;
- `verification/slice-cover-values.tex` — generated, checked manuscript values;
- `verification/claim-map.json` and `verification/imported-sources.json` —
  theorem coverage and imported-source ledgers;
- `.zenodo.json` — deposition metadata;
- `LICENSE` — CC BY 4.0 license;
- `flake.nix` and `flake.lock` — pinned standalone build environment.

## Citation

No archival DOI is claimed for this revision. The `.zenodo.json` file prepares
the metadata for a replacement deposit; it does not create or update a Zenodo
record.

## License

The manuscript and repository contents are licensed under CC BY 4.0; see
[`LICENSE`](LICENSE).
