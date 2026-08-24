# C956 -- exact level-two cubic manuscript

**Lane:** cubic-threefolds

**Status:** active; hostile referee and repair rounds in progress

## Stable entry point

- authority: `papers/cubic-stabilization-irrationality/`
- manuscript: `papers/cubic-stabilization-irrationality/cubic_stabilization_irrationality.tex`
- editorial spine:
  `notes/2026-08-24-c956-exact-level-two-cubic-manuscript-framing.md`
- result inventory:
  `notes/2026-08-24-c956-exact-level-two-cubic-manuscript-results.md`
- source and claim ledger:
  `notes/2026-08-24-c956-exact-level-two-cubic-manuscript-source-ledger.md`
- verification map: `papers/cubic-stabilization-irrationality/verification/claim-map.json`
- imported-source ledger:
  `papers/cubic-stabilization-irrationality/verification/imported-sources.json`

Do not preload C925.  Its mathematics has already been distilled into the two
paper-local editorial documents above.  Consult a dated C925 report only when
the manuscript or a failed replay names that exact report.

## Headline and framing

For each of the two explicit smooth cubic threefolds over `Q` in
Tschinkel--Zhang Propositions 5.1 and 5.2, the least `m` for which
`X x P^m` is rational is exactly two, over both `Q` and `C`.  Lead with this
cubic theorem.  The reusable engine is the theorem that a smooth quartic del
Pezzo surface over a characteristic-zero field, with a rational point and
stably permutation geometric Picard lattice, satisfies `S x A^2` rational.
The structural core is a rational-quotient criterion for projectively linear
torus actions on varieties parametrized by generic tangent projection.

The fourfold statement is a consequence, not the headline: for
`Y=X x P^1`, `Y` is nonrational but `Y x A^1` is rational.  State explicitly
that this is birational rationality after affine-line stabilization, not the
Zariski cancellation problem for isomorphic affine cylinders.

## Relation to Tschinkel--Zhang

Use one calm paragraph, at the point where the theorem ladder is complete.
Credit their Cox/universal-torsor geometry, four-type classification, and
explicit fibrations as inputs.  State exactly that the surface theorem gives
the conclusion of their Corollary 4.3 with the positive implication sharpened
to `S x A^2` rational, and that the family corollary gives their stable-
rationality conclusions with a uniform `P^2` bound.  Do not claim to subsume
their paper, contest priority, or include defensive literature-audit prose in
the mathematical narrative.

## Implemented state

- Title and abstract are cubic-first.
- The exact level-two theorem, family theorem, surface theorem, general
  quotient theorem, fourfold corollary, and very-general moduli contrast are
  in the source.
- The second explicit cubic equation is corrected to
  `x_3^3-x_3 x_4^2+x_4^3`.
- Projective weights are treated up to common translation; the selected weight
  sum and its complement descend, rather than individual coordinate blocks.
- The tangent-section coefficient wall has moved to an appendix; the main
  proof gives the geometric rank argument and a compact witness table.
- The inverse graph and both compositions are written out in the quotient
  theorem.
- The new theorem is not formalized in Lean.  Paper metadata must continue to
  record formal coverage as absent.

## Remaining work, in order

The deterministic manuscript, metadata, verification, stale-source, and
standalone-export gates pass. Remaining acceptance work is:

1. independent hostile algebraic-geometry review;
2. independent hostile quotient/descent/computation review;
3. independent full-public-repository and expert-exposition review, using the
   complete `m=1` paper as context only;
4. repair every accepted finding and rerun fresh referee rounds on the
   repaired candidate;
5. close only after all three specialties return clean verdicts.

## Acceptance gate

- The first-page theorem is exact least stabilizing dimension two for the two
  explicit cubic threefolds.
- Every imported result is cited at the point of use; no circular invocation
  of Tschinkel--Zhang Corollary 4.3 or Theorem 1.3 occurs.
- The general quotient theorem and its descent hypotheses are stated in a form
  an expert can reuse independently of the cubic application.
- The four-type tangent-section argument is human-checkable in the text and
  exactly replayable from the certificate.
- README, PDF metadata, `.zenodo.json`, theorem labels, claim map, imported-
  source ledger, and formal-coverage statement agree.
- `make check` passes, PDF inspection passes, and the release contains no
  residue from the false every-stabilization proof.

## Fresh-session first action

Read the dated report, framing note, and the newest referee reports. Resume at
the highest-severity open finding, then rebuild and re-referee. C958 remains
queued behind C956.
