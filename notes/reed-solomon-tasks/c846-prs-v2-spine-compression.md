# C846 — PRS Version 2 spine compression

**Lane:** `reed-solomon`

**Status:** Active.

## Objective

Reorder the proof-complete Version 2 manuscript around its mathematical spine:
the syndrome--Hankel dictionary, terminal redundancy-five theorem, coherent
polar escape, exact recursive carrier theorem, and conceptual Lucas-carrier
arithmetic.  Move fixed-level coordinate audits, exhaustive contained-component
calculations, and verification mechanics into labeled appendices without
changing theorem statements, hypotheses, or proof completeness.

## Acceptance gates

- The main text exposes the recursive proof route without requiring an appendix
  to understand why the principal theorem is true.
- Every displaced argument remains in the same PDF, with stable labels and
  correct forward references.
- The unconditional carrier theorem, conditional arbitrary-redundancy numerical
  consequence, and unconditional R8--R10 conclusions retain their exact scopes.
- Canonical and TIT builds are warning-free; the TIT build remains below 50
  pages; the supplement verifier and release-manifest reconciliation pass.
- A fresh theorem-opening and proof-spine cold read finds no lost dependency.

## Working page target

Reduce the TIT main body before appendices from 36 pages to approximately
24--27 pages.  Appendix movement alone need not reduce the complete PDF page
count; any net compression must come from deleting duplicated navigation or
administrative prose, not from omitting proof.

