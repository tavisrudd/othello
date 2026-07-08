# C22 Transport/Assembly Report

Date: 2026-07-08

## Result

Partial Lean landing for C22.  The transport layer needed by anchored Q11
representatives is now formalized and builds:

- `ProjectiveCap.ConicLocalization.axisAffine`: independent row/column affine
  coordinate changes `(r,c) ↦ (a*r+b, d*c+e)`.
- `axisAffine_gridSymmetry`: nonzero row/column scales give a
  `GridSymmetry`.
- `anchorAxisAffine`: the explicit normalization map sending an ordered pair
  `p,q` to `(0,0),(1,1)`.
- `anchorAxisAffine_left`, `anchorAxisAffine_right`, plus
  `gridCap_row_ne_of_ne` / `gridCap_col_ne_of_ne` to get the required nonzero
  scale denominators from a legal partial permutation.
- `GridClassCert.escape_at_preimage_of_gridSymmetry`: a certified class whose
  size-three position is `S.image f` transports back to an escape move for `S`.
- `GridOddEscapeTransportBookCertificate`: orbit-representative assembly
  structure.  It proves `Almost.OddEscapeGameStatement` once supplied with a
  per-position class, a grid symmetry, `representsImage`, and class validity.

## Validation

```text
nix develop --command lake build ProjectiveCap.ConicLocalization ProjectiveCap.Certificate
```

passed.

## Not Yet Done

Unconditional PG(2,11) is not assembled yet.  The remaining proof is now narrow:

1. Extract an ordered triple from an arbitrary legal `S.card = 3` via
   `Finset.card_eq_three`.
2. Apply `anchorAxisAffine` to the first two cells.
3. Match the third anchored cell against the 72 Q11 generated classes
   `(0,0),(1,1),(a,b)` with `a,b ∈ {2..10}`, `a ≠ b`.
4. Prove the generated class satisfies
   `class.sizeThree = S.image (anchorAxisAffine p q)`.
5. Instantiate `GridOddEscapeTransportBookCertificate` from Q11 class validity,
   then apply the existing projective payoff bridge.

The generated Q11 file currently has individual `classN`/`classN_valid`
definitions but no selector table or coverage theorem.  The lowest-risk next
step is to extend the generator to emit a compact `(a,b) -> classN` selector and
72 equality lemmas, then use those lemmas in the transported certificate
instance.

## Estimate

Expected remaining work for PG(2,11): about one focused Lean session if the
selector is generated, more if the coverage proof is hand-written.  Optional
q=13 splitting was not attempted.
