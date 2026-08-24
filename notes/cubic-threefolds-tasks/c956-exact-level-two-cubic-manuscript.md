# C956 -- exact level-two cubic manuscript

**Lane:** cubic-threefolds

**Status:** active; theorem spine implemented, release audit open

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

1. Finish the prose pass required by `papers/style-guide.md`: remove defensive
   priority language from the public manuscript and README, keep exact credit,
   and check standard terminology and notation throughout.
2. Update README, `.zenodo.json`, the claim/novelty ledger, and imported-source
   records to the cubic-first title and current theorem labels.  Replace
   `cor:cancellation` by `thm:cubic-level`, `cor:affine-line`, and
   `cor:moduli`.  Avoid the nonstandard phrase "stabilization index"; use
   "least stabilizing dimension" or display the defined invariant `ell_k`.
3. Parse the two JSON ledgers, run `make check` from the paper directory, and
   inspect the generated PDF metadata and extracted text.
4. Visually inspect the first page, theorem ladder, quotient proof, and exact
   appendix.  Confirm that page one sells the cubic theorem and the main proof
   remains readable without the certificate appendix.
5. Run stale-term scans for the abandoned `INT-Psi`, quantum-transport,
   conditional all-`m`, and obsolete theorem-label material across the release
   files and PDF text.
6. Check that every paper-owned changed/untracked file is intended, update the
   checksum manifest if required, run the C956 `ej`+`tt` closeout and mystery
   ledger, then commit only C956-owned paths.
7. After authority validation, read
   `notes/export-and-mirror-conventions.md` and synchronize the standalone
   mirror if one exists; never edit the mirror first.

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

Read `../AGENTS.md` in a dedicated command, route with
`go C956 cubic-threefolds`, read this card and then
`notes/2026-08-24-c956-exact-level-two-cubic-manuscript-framing.md` in full,
inspect the scoped git status, and resume at Remaining work item 1. Do not
reopen the C925 research programme unless a named proof dependency fails.
