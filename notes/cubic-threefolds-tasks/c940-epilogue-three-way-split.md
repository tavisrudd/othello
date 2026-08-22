# C940 -- three-way split of the one-stabilization epilogue

**Lane:** cubic-threefolds

**Status:** active; dependency audit in progress

## Goal

Replace the fifty-two-page integrated `m=1` paper by three manuscripts.  The
short paper's authority and public alias become
`papers/cubic-stabilization-m1/` and `cubic-stabilization-m1`:

1. a short unconditional paper proving irrationality of
   \(X\times\mathbf P^1\) from the generic-even-QDM formal-exponent marker,
   with its unconditional separation and genus-eight consequences;
2. a self-contained paper on the six-axis polarization, integral divisor
   products, and the nonstandard \(A_5\)-invariant cubic pencil; and
3. a separate conditional note on the finer framed formal-monodromy count.

The all-stabilization manuscript at
`papers/cubic-stabilization-irrationality/` is outside scope and must not be
edited.

## First gate

Map every theorem, citation, annotation, Lean terminal, artifact, and
cross-reference before moving source.  The short paper must contain the whole
unconditional proof rather than rely on an implicit section of the integrated
epilogue.  The six-axis paper may cite the resulting one-stabilization theorem
for its product irrationality consequence.  The framed note must state its two
remaining reconstruction hypotheses without suggesting that they qualify the
unconditional theorem.

## Mathematical additions

- Add the threefold birational-invariance corollary only after checking the
  endpoint and low-dimensional nullity hypotheses in dimension three.
- State the Bittner connection only as an additive blowup relation unless a
  genuine group- or ring-valued extension is proved; the current
  \(\mathbf N\)-valued fold is not automatically a motivic measure.
- Include the \(X_{2,2}\) and cubic-fourfold sanity checks only after their
  generic-even block statements are verified for the revised exponent-class
  marker.
- Treat an explicit blowup QDM computation, such as
  \(\operatorname{Bl}_\ell(X)\), as a provider test requiring its own exact
  computation and evidence bundle.  Do not infer it from the consumer ledger.

## Acceptance gates

- Each manuscript has a theorem-first abstract and an independent proof map.
- Every moved claim retains valid source and formal-provenance mappings.
- Integrated and standalone checks pass, and rendered PDFs are inspected.
- No file under `papers/cubic-stabilization-irrationality/` changes.
