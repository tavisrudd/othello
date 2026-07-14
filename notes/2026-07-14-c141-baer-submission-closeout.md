# C141 — Baer submission closeout

**Date:** 2026-07-14
**Lane:** `baer`
**Status:** REPORTED — submission artifact and final referee closeout complete

## Goal

Produce the submission artifact and run the final manuscript-to-Lean, citation, trust, formatting,
and adversarial-referee audit before routing/archive disposition.

## Final result

The focused submission source is
[`frobenius_pair_extension.tex`](../papers/equivariant-robust-completion/frobenius_pair_extension.tex)
with a conventional BibTeX database in the same directory. It has stable theorem, equation, and
cross-reference labels; a self-contained proof spine; an explicit computer-assisted proof boundary
for the exceptional profile; and a paper-to-Lean declaration map.

Static closeout checks completed:

- every cited key exists exactly once in `refs.bib`;
- braces and begin/end environments balance, and `git diff --check` passes;
- the uniform Q25 theorem, global semantic count, collision equality/excess results, exceptional
  profile conclusion, and profile lower bounds match the checked Lean declarations;
- the saturation ceiling and geometric case split are explicitly identified as paper proofs;
- the external census/minimum are isolated as data and are not theorem inputs;
- the manuscript makes no historical-first, sharpness, generic-robustness, pair-multiplicity, or
  unproved small-order claim.

The adversarial pass added the missing derivation of the fixed-point first moment `48`, derived the
full-occupation completed-square identity instead of asserting it, and added exact source/declaration
locations for reproducibility. After the concurrent Lean build window cleared, the final command

```text
nix shell nixpkgs#tectonic -c tectonic frobenius_pair_extension.tex --keep-logs
```

completed successfully. BibTeX and all cross-references resolved; the final log contains no TeX,
undefined-reference, multiply-defined-label, underfull-box, overfull-box, or PDF-string warning.
The generated PDF is
[`frobenius_pair_extension.pdf`](../papers/equivariant-robust-completion/frobenius_pair_extension.pdf),
SHA-256 `281230f93e6acc3c673efdb6893fe8d9d1dc7795da3af8f869caee86a5b034c6`.

## Referee verdict

**Acceptable as a focused finite-geometry/formal-verification paper after the revisions recorded
above.** The proof boundary is honest and the headline theorem is kernel-checked. The novelty is
modest: the counting ingredients and square-root scale are classical, and the general criterion is
best described as an exact orbit-valued assembly. The exceptional profile relies on a large finite
certificate, but the normalization, coverage, freshness, semantic transport, and leaves are all in
the trusted proof chain.

The remaining limitations are declared research frontiers, not hidden release gaps: there is no
sharp or pair-saturated family, no geometric structural inverse theorem, no family-specific
deletion robustness theorem, no certified multiplicity bound for the exceptional profile, and no
definitive historical-priority clearance beyond the bounded searches.
