# C598 — AME--LU scope and self-containedness revision

**Lane:** `ame-lu`

**Date:** 2026-07-24

**Status:** complete; revised candidate ready for another external read

## Outcome

The second referee pass found one front-matter scope regression and one
over-compression regression.  Both are repaired.  The all-prime-power
LU-to-LC theorem remains the headline; the promoted logical-phase statement
is now explicitly restricted to odd prime fields in both the abstract and
introduction.  The redundant transport derivation has moved from the numbered
main sequence to Appendix A, but the short arithmetic needed to check its
counts and exceptional characteristics has been restored.

## Scope repair

The abstract now begins the second result with “Over odd prime fields,”
immediately after the all-prime-power rigidity statement.  The introduction
likewise calls it an odd-prime-field result before describing the
\([[5,1,3]]_q\) encoder.  Section 5 and the scope paragraph in Section 7
already had the correct restriction.

This keeps the extension-field boundary visible: when \(q=p^e\), the full
local Clifford action is governed by the larger \(\F_p\)-symplectic phase
space, so the displayed \(\mathrm{SL}_2(q)\)/split-torus classification is not
claimed.

## Theorem 6.1

The characteristic-\(3\) and characteristic-\(5\) clauses are now proved in
the text.

- In characteristic \(3\), an allowed semi-elementary subgroup has normal
  \(C_3\) and complement in \(\operatorname{Aut}(C_3)\), hence is \(C_3\) or
  \(S_3\) and has at most three involutions.  The only subfield groups whose
  orders divide \(120\) are \(A_4\) and \(S_4\), already counted.
- In characteristic \(5\), no subgroup case is needed:
  \(X^2-X-1=(X-3)^2\), so \(\tau=3\) and direct substitution gives
  \(G(\tau)=0\).  The H3 reduction is GRS, contrary to the theorem's non-GRS
  hypothesis.

No finite case is left as an asserted classification consequence.

## Appendix disposition

The main text now runs

```text
rigidity -> pencil classification -> fixed-party logical phase
         -> scalar witnesses and generic blindness -> verification/scope.
```

The transport calculation follows as Appendix A.  Its proof again displays

```text
48 * 16 / 8 = 96,
24 * 48 / 6 = 192,
```

states why the axial and signed support sets are disjoint, and derives the
exceptional reductions from \(4B^2+A^2=4G^2\):

```text
char 3: B^2-2A^2=G^2,       9B^2-4A^2=-A^2;
char 5:                         9B^2-4A^2=4G^2;
char 7:                         9B^2-4A^2=2(B^2-2A^2).
```

Thus the characteristic-\(7\) histogram visibly uses the disjoint
\(96+192=288\) supports rather than relying on the certificate alone.

## Literature and bibliography

The novelty-search sentence is narrowed to the bibliography-supported search:
LU--LC equivalence for stabilizer states and LU equivalence of
minimal-support AME states.  The separate transversal-gate paragraph remains
context, not part of the negative precedence claim.

Two records were corrected against publisher metadata:

- Aharonov--Ben-Or is now the 2008 *SIAM Journal on Computing* article,
  volume 38, pages 1207--1282, DOI
  `10.1137/S0097539799359385`, retaining the arXiv identifier
  `quant-ph/9906129`.
- Ball--Lavrauw is now volume-year 2019 and DOI `10.4171/EMSS/33`.

## Validation

- `make check`: passed; all 15 evidence artifacts verified and the
  16-page XeLaTeX/BibTeX build is warning-free.
- PDF: 162,499 bytes,
  SHA-256 `04c578bf297458801bea54c168f1d12f883b308e240d58b49fde059deb98cef5`.
- Rendered pages 1 and 9--14 were inspected.  The scope qualifier, expanded
  Theorem 6.1 proof, main-text ending, Appendix A numbering, restored orbit
  arithmetic, and characteristic table have no visible layout defect.
- Refreshed 35-artifact public tree:
  `d7e62a9a24a7f9021fab56d91b7571b0ccea080aa9570405e33d1d76573330d8`;
  the formal companion remains
  `91c8ba3c885a65e71adb0cf5cf3491086c3f810cec11673435112852983399de`.
- Full seven-bundle replay: passed.

## `ej` + `tt` closeout

The cheap structural gain was to make Section 6, not the transport witness,
the end of the mathematical narrative.  The reader reaches the paper's
conceptual conclusion—operator-valued marginals retain the Weyl axes while
fixed-copy scalars forget them—before verification and can skip Appendix A
without losing any classification result.  Restoring four short displayed
calculations in the appendix costs one page but removes every newly introduced
self-containedness complaint.

## Mystery ledger

- **Settled:** the promoted logical-phase claim no longer inherits the
  preceding all-prime-power quantifier.
- **Settled:** the characteristic-\(3,5\) branches of Theorem 6.1 are explicit
  group/order calculations.
- **Settled:** the characteristic-\(7\) multiplicity \(288\) visibly comes
  from disjoint supports of sizes \(96\) and \(192\).
- **Settled:** both questioned bibliography records now match publisher
  metadata.
- **Open, editorial:** the revised hierarchy and proof additions still need
  the next independent referee read; no mathematical or reproducibility
  mystery remains inside C598.
