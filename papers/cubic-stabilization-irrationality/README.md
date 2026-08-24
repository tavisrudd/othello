# Two-Dimensional Stabilization of Quartic del Pezzo Surfaces

The main theorem concerns a smooth quartic del Pezzo surface `S` over a field
`k` of characteristic zero. If `S(k)` is nonempty and the geometric Picard
lattice is a stably permutation Galois module, then `S × A²`, equivalently
`S × P²`, is `k`-rational. In particular, the conclusion holds for every
stably `k`-rational smooth quartic del Pezzo surface.

The theorem applies to both explicit Tschinkel–Zhang families of smooth cubic
hypersurfaces over `Q`: every member becomes rational after multiplication by
`P²`. For their cubic threefolds, combining this result with the separately
cited theorem that `X × P¹` is irrational determines the stabilization index
to be two over both `Q` and `C`. Thus `Y = X × P¹` is a nonrational smooth
projective fourfold over `Q` while `Y × A¹` is rational. This is a birational
rationality statement after affine-line stabilization, not a counterexample
to the Zariski cancellation problem for isomorphic affine cylinders.

The canonical release files are:

- `cubic_stabilization_irrationality.tex` — manuscript source;
- `cubic_stabilization_irrationality.pdf` — generated manuscript;
- `.zenodo.json` — deposition metadata;
- `LICENSE` — CC BY 4.0 license;
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

The manuscript makes no global priority claim. Its bounded literature audit
and imported-source ledger are recorded in `claim-proof-novelty-ledger.md` and
`verification/imported-sources.json`. No manuscript DOI or release version is
asserted in the metadata because none has been assigned authoritatively.
