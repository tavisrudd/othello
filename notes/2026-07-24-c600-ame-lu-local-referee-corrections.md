# C600: AME--LU local referee corrections

**Lane:** `ame-lu`  
**Date:** 2026-07-24  
**Verdict:** complete

## Result

All four requested local edits are adopted.

1. Theorem 6.1 now states at theorem level that its non-GRS hypothesis is
   vacuous in characteristic five because the reduction is GRS.
2. The introduction now identifies the appendix witness as redundant
   specifically by Corollary 1.2.  The actual source label is
   `cor:lu-lc-pencil`.
3. Proposition 6.3 now distinguishes the parameter field \(k\), the
   cardinality \(q=|k|\), the corresponding local Hilbert-space dimension,
   and the fact that \(X\) is a variety over \(k\).
4. The sharpness sentence now conditions the octahedral equality example on
   the existence of an octahedral \(S_4\) in
   \(\mathrm{PGL}_2(q)\).

The optional novelty-scope sentence is also adopted.  It describes the
bounded comparison actually performed: quantum Reed--Solomon and
polynomial-code gate constructions, general prime-dimensional stabilizer
Clifford synthesis, and transversal-gate restrictions.  It makes no
exhaustive or global priority claim.

## Locator confirmation

Both pinpoint locators remain supported by the C599 source audit.

- **Aharonov--Ben-Or, Section 5:** the cached arXiv source
  `quant-ph/9906129` was inspected at Sections 5.1--5.2; it contains the
  polynomial-code, coordinatewise-gate, Fourier, and degree-reduction material
  attributed in the manuscript.
- **Dickson, §§239--261:** the Chapter XII table of contents and scanned
  pages at §242, the §260 summary, and §261 were inspected.  The range covers
  the finite-field linear-fractional subgroup classification used here,
  including regular and characteristic-\(p\) families.  Faber remains useful
  for a clean modern formulation over a general field.

## Validation

- `make check`: passed; 16-page PDF, with no LaTeX warnings, undefined
  references, or bad-box diagnostics.
- PDF: 166,072 bytes, SHA-256
  `89bf865fc3725250d13f5d1b5ec137894254512fecfb63635ce21f797b084af2`.
- `make release-check`: passed in 5m35s, including all seven evidence replays.
- Public release tree:
  `77023a6bdaee3b45ec9099a950c903827e9f53f34933e7c793d712bb29313633`.
- Formal companion tree, unchanged:
  `91c8ba3c885a65e71adb0cf5cf3491086c3f810cec11673435112852983399de`.

The available environment had no working PDF rasterizer, so this pass did not
claim a new visual-page inspection.  The immediately preceding C599 release
did include a five-page visual sweep; the present changes were checked in
source, by the warning-free typesetter, and by the complete release gate.

## Extra-juice and Tao-style closeout

The highest-value feature of these edits is local scope visibility.  The
characteristic-five exception, the octahedral existence condition, and the
two roles of \(q\) were all already compatible with the proofs, but readers
should not have to reconstruct them from later prose.  Linking “redundant” to
Corollary 1.2 likewise converts an editorial judgment into a checkable
mathematical dependency.

A final adversarial read found no new theorem, domain, citation, or
computational claim introduced by these changes.  The search-scope sentence
is deliberately narrower than a novelty assertion and agrees with the
recorded C599 coverage.

## Mystery ledger

- **Settled:** the referent of “redundant” is Corollary 1.2,
  `cor:lu-lc-pencil`.
- **Settled:** octahedral attainment is conditional on the subgroup existing
  over the field.
- **Settled:** the two appearances of \(q\) in Proposition 6.3 are one
  cardinality serving two explicitly named roles.
- **Open only for any future firstness claim:** a global priority search for
  the self-association obstruction.  The manuscript does not make that claim.
