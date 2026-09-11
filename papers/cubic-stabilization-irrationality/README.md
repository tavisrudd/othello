# Two-Variable Rationalization and Sharp Stabilization of Cubic Threefolds

[**Open the manuscript (PDF) →**](cubic_stabilization_irrationality.pdf) · [Referee guide](REVIEWER_GUIDE.md)

[Literature comparison and qualified novelty ledger](LITERATURE.md), rows
N1–N4, records the prior symmetry families, source read depths and coverage gaps.

A three-parameter family of smooth cubic threefolds has exact stabilization
level two over every extension of its characteristic-zero ground field.
An explicit rational pencil contains a positive-density squarefree integer
family whose first stabilizations are pairwise nonbirational even over C.
Their second stabilizations are all rational over Q.

## The theorem hierarchy

1. **Independent construction.** Every stably rational smooth quartic del
   Pezzo surface in characteristic zero becomes rational after product with
   A². A saturated rank-three subtorus of the projective Cox model has rational
   quotient, and equivariant torsor splitting leaves a rational rank-two torus.
   This proves the cubic family's upper bound uniformly.
2. **Exact level.** The separately proved one-stabilization irrationality
   theorem supplies the lower bound for every smooth cubic member.
3. **Arithmetic separation.** Five elliptic isogeny factors of the pencil's
   intermediate Jacobian give potential toric ranks 1 at numerator primes,
   3 at primes dividing 16a²−27b², and 0 otherwise, for p≥5.
   Hodge conservation then distinguishes the first stabilizations.

The companion inputs are Theorems 1.1 and 1.3 of *One-Stabilization
Irrationality and Hodge Conservation for Fano Threefolds*, September 2026.
The [exact cited manuscript](references/one-stabilization-september-2026.pdf)
is bundled and byte-pinned. An older deposit is not used as a citation for
the newly added Hodge theorem.

## Consequences and scope

For Y_n = X_n × P¹ in the squarefree pencil family, the Y_n are pairwise
nonbirational irrational fourfolds even over C, but every Y_n × P¹ is rational
over Q. The parameter set has counting function 3H/π² + O(√H).
The cubic family has three-dimensional image in complex cubic moduli.

The appendices retain generic-surface and fibration consequences, exact
linearization levels of rational torus actions, finite rational pencil partner
sets, finite-index slices and zero-cycles, and the rank-four limitation of this
Cox construction. No analytic height theorem is needed by the main proof.
The unit-equation result supplies finitely many necessary candidates; a
complete solver and affirmative birationality test are not implemented.

The statements concern the displayed smooth families, not all cubic
threefolds. The fourfold result concerns birational products, not isomorphism
cancellation for affine cylinders. Isogenies are geometric; no product
principal polarization is asserted.

## Proof and evidence

The main proof runs through surface rationalization, the uniform cubic
family and arithmetic separation in Sections 4–6. Named examples and
higher-dimensional series follow in Section 7.

The manuscript proves the quotient, descent, torsor and family arguments,
using the cited Cox geometry and Picard classification of Tschinkel–Zhang.
It identifies the actual signed family action and the actual Prym covers;
group order and finite point counts alone would not establish those steps.

Appendix E's **Universal tangent cover** lemma supplies a smooth tangent
point and invertible evaluation for every smooth surface parameter.
The main proof then handles tangent projection and ground-field existence.

The original twenty-quadric Cox derivation and independent checker remain
in the full gate, as does the independent rank-four check. The new
[family/arithmetic checker](verification/check_family_arithmetic.py) checks
exact equations, seed smoothness, moduli ranks, elliptic quotients and
arithmetic normalizations. Its complete symbolic calculation has not been
independently reimplemented. Details, replay and hashes are in
[verification/family-arithmetic.md](verification/family-arithmetic.md).

All theorem coverage is `absent` in [the claim map](verification/claim-map.json).
No end-to-end Lean formalization or new independent validation of the
companion's geometric proof is claimed. Imported conventions are recorded in
[the source registry](verification/imported-sources.json).

## Verification

From this directory, enter the pinned development shell and run the full gate:

```text
nix develop --command make check
```

This command reconstructs and independently checks the exact certificate,
validates the claim and source ledgers, performs a deterministic manuscript
build, and rejects TeX warnings or stale metadata.

The retained identities for the empty localized cases can be regenerated
independently with Singular 4.4.1 and then rechecked by the full gate:

```text
nix shell nixpkgs#singular -c uv run --with sympy==1.14.0 python3 \
  verification/generate_groebner_empty_certificates.py \
  --write-certificate verification/groebner-empty-certificates.json
```

## Files

- `cubic_stabilization_irrationality.tex` — manuscript source;
- `cubic_stabilization_irrationality.pdf` — generated manuscript;
- `REVIEWER_GUIDE.md` — a referee's route through the proof and evidence;
- `LITERATURE.md` — contribution, prior-family comparison and audit scope;
- `formal-annotations.tex` — nonprinting claim annotations;
- `verification/derive_slice_cover.py` — exact reconstruction program;
- `verification/generate_groebner_empty_certificates.py` — optional Singular
  regeneration of the retained identities for the empty localized cases;
- `verification/check_slice_cover.py` — independent consequence checker;
- `verification/slice-cover-certificate.json` — canonical exact certificate;
- `verification/groebner-empty-certificates.json` — retained exact identities
  for the six empty localized cases;
- `verification/slice-cover-values.tex` — generated, checked manuscript values;
- `verification/claim-map.json` and `verification/imported-sources.json` —
  theorem coverage and imported-source ledgers;
- `.zenodo.json` — deposition metadata;
- `LICENSE` — CC BY 4.0 license;
- `flake.nix` and `flake.lock` — pinned standalone build environment.

## Citation

No archival DOI is claimed for this revision. The `.zenodo.json` file prepares
the metadata for a new deposit; it does not create or update a Zenodo record.

## License

The manuscript and repository contents are licensed under CC BY 4.0; see
[`LICENSE`](LICENSE).

The slice certificate also records the two residual character matrices, in
column coordinates for (E1-E5,E2-E5), and verifies their permutation action
on three generators with a single sum relation. This identifies the residual
cubic norm-one torus. The manuscript prints the splitting-field orbit
correction; complete ground-field forward/inverse maps require the additional
inputs specified beside the inverse-graph construction.
