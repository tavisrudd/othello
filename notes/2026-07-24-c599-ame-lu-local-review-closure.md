# C599: AME--LU local re-review closure

**Lane:** `ame-lu`  
**Date:** 2026-07-24  
**Verdict:** complete

## Result

The three remaining local findings and the two associated attribution/scope
minors are closed.

1. Section 5 now assumes that \(q\) is an odd prime before defining
   \(\mathcal K_C\subseteq\mathrm{SL}_2(q)^6\).  The next sentence states that
   for \(q=p^e\), \(e>1\), the full local Clifford action is through
   \(\mathrm{Sp}_{2e}(\mathbb F_p)\), so the displayed field-linear block group
   is not the full local Clifford kernel.
2. Theorem 6.1 no longer claims the unsupported exact set
   \(b\in\{0,1,2,3,4,6\}\).  Its proof states only the bound \(b\leq6\) that it
   establishes and uses.  The octahedral six-set attains equality through its
   six fixed-point-free edge-axis half-turns, so the displayed \(70>66\)
   margin is sharp for this method.
3. The introduction now distinguishes three established inputs from the
   paper's contribution: quantum Reed--Solomon construction and encoders,
   polynomial-code fault-tolerant gate procedures, and general
   prime-dimensional stabilizer Clifford synthesis.  It expressly disclaims
   priority for the GRS gate constructions.  The contribution claimed for
   Theorem 5.1 is the classification among all six-arcs: self-association is
   exactly the condition under which the fixed-party product-Clifford
   symplectic kernel grows from the split torus to
   \(\mathrm{SL}_2(q)\).
4. Section 2 now states the exact existence boundary: six-arcs, equivalently
   linear \([6,3,4]_q\) MDS codes, exist exactly for \(q\geq4\).  The abstract
   and Theorem 1.1 retain their natural conditional quantification over every
   prime power instead of adding an inert hypothesis.
5. Dickson's classical finite-field treatment (§§239--261) is credited for
   both the p-regular and p-irregular families.  Faber is cited for the clean
   modern formulation over a general field of characteristic p.

The release metadata also now uses the promoted title, *Local-Unitary
Rigidity and Logical Clifford Phases of Six-Qudit AME Stabilizer Tensors*.

## Literature boundary and read depth

This was a bounded attribution comparison, not a new global priority search.
The manuscript therefore makes no firstness claim for the GRS gate
constructions.  Two of the five sources used in the comparison were read at
full text.

- **Grassl--Geiselmann--Beth, “Quantum Reed--Solomon Codes” — full text.**
  Read the complete three-page arXiv version, including its quantum RS
  construction and encoding/decoding circuits.  Cache key
  `arXiv:quant-ph/9910059`, SHA-256
  `8d7123b601de2d682e7f1be51d026e2152ba3f941172829771aade932974602b`.
- **Gottesman, “Fault-Tolerant Quantum Computation with Higher-Dimensional
  Systems” — full text.**  Read the complete arXiv v1, especially Sections
  2, 4, and 5: the prime-qudit Clifford generators and the ancilla/Pauli
  measurement construction of the full encoded Clifford group.  Cache key
  `arXiv:quant-ph/9802007`, SHA-256
  `1b10e7abf1578ad6ba7410d4cd8235f23d6cf67a5e665f28f181dbcc808ba141`.
- **Aharonov--Ben-Or, “Fault-Tolerant Quantum Computation With Constant
  Error Rate” — partial.**  Read Sections 3.5 and 5.1--5.2 of the arXiv
  version, including the polynomial-code definition, coordinatewise gates,
  and Fourier/degree-reduction procedure.  Cache key
  `arXiv:quant-ph/9906129`, SHA-256
  `75b88121b25c7e4a8766c4e5ee31218be946d25fccecf7b3717687011df32d1f`.
- **Faber, “Finite \(p\)-Irregular Subgroups of
  \(\mathrm{PGL}_2(k)\)” — partial.**  Read Sections 1--2 of arXiv v4,
  including Theorems A--D and the explicit separation between the classical
  p-regular cases and the paper's p-irregular contribution.  Cache key
  `arXiv:1112.1999`, SHA-256
  `2c32c6ec0cef4f6a5d92fba5cf899e67d16c2413ccbb517df1c03be5ab3f1e00`.
- **Dickson, *Linear Groups* — partial.**  The Internet Archive text and
  table of contents were checked at Chapter XII, §§239--261.  The scan pages
  for §242 and the §260 summary were inspected directly; they display the
  cyclic/dihedral and tetrahedral/octahedral/icosahedral families together
  with the characteristic-\(p\) cases.  Cache key
  `archive:lineargroupswit00dickgoog`, SHA-256
  `7559020f8c7d16a563a6f3752ba2da922fe30e9d33f1971c9785bd9c51622146`.
  The 1901 Teubner metadata was also checked against Google Books and
  WorldCat.

The load-bearing web queries were:

```text
"quantum Reed-Solomon" "transversal" gates
"quantum polynomial code" "transversal" Clifford
"Reed-Solomon" "transversal Clifford" quantum codes
"polynomial codes" transversal Fourier phase gate quantum
```

No inaccessible intended source gates the revised wording.  MathSciNet,
zbMATH, Semantic Scholar, and Google Scholar were not searched because the
revision does not assert a global negative; any future firstness claim for the
six-arc dichotomy would require a separate audit under the repository
literature conventions.

## Validation

- `make check`: passed without LaTeX or package warnings.
- PDF: 16 pages, 165,596 bytes, SHA-256
  `aec136cb9587d3c2ac6125a33bf835e29b461d86d83113adc9ad0487bb11638b`;
  pages 1, 2, 3, 7, and 10 were rendered and inspected.
- `make release-check`: passed, including all seven evidence replays and the
  formal-companion manifest check.
- The refreshed public release tree is
  `1ea32110a443fff7e3ea2fe8a016b0f0d1ca1dcc55eb4a19942927ba47e1df35`;
  the unchanged formal tree is
  `91c8ba3c885a65e71adb0cf5cf3491086c3f810cec11673435112852983399de`.

## Extra-juice and Tao-style closeout

The cheap structural gain was to synchronize the promoted title and the
Section 2 existence boundary in the README, theorem map, novelty ledger,
verification map, and release metadata.  This prevents the repaired
manuscript from disagreeing with its own release apparatus.

A Tao-style check asks whether the revised literature paragraph separates
existence from classification.  It now does: earlier work constructs
fault-tolerant gates, while Theorem 5.1 classifies when those gates arise from
fixed-party product symmetries.  The same check asks whether sharpness of the
moment argument is visible; the octahedral equality case now answers it in
the proof.

## Mystery ledger

- **Settled:** why the number six in the GRS bound is natural.  The
  octahedral action attains it.
- **Settled:** whether the GRS half of Theorem 5.1 should carry a priority
  claim.  It should not; the paper claims the self-association iff
  classification.
- **Open only as a future literature gate:** a global firstness claim for
  identifying self-association as the fixed-party obstruction.  The present
  paper does not make that claim.  A future claim would require a dedicated
  multi-index audit, not more manuscript prose.
- **No mathematical mystery remains in the three reviewed local defects.**
