# C1133 — source and literature closeout

**Date:** 2026-09-10. **Lane:** `cubic-threefolds`.
**Status:** continuing source audit; final coverage disposition below is pending.
**External sources read at full text: eight — six papers and two source scripts.**
Read depths and access records live in `2026-09-09-c1133-literature-sources.json`.
Earlier dated access failures remain historical records, not current source statuses.

## Original polarization-finiteness source

Narasimhan–Nori, *Polarisations on an abelian variety*, published 1981,
DOI `10.1007/BF02837283`, is now **full text**: all four original scanned pages
125–128 were read visually, including the proof and references. The successful
repository request was `https://repository.ias.ac.in/36463/1/36463.pdf`.
Cache key: `10.1007/BF02837283`; PDF SHA-256:
`2710fad133c91c6e57f16b6e842d2db875a76b057e9551ccf9b2de8de303410b`.
The text extraction is empty; the read was from rendered facsimile pages,
not an OCR reconstruction or the search excerpt.

Theorem 1.1 asserts finitely many automorphism orbits of Néron–Severi
classes of each fixed nonzero degree over an algebraically closed field.
Section 1.6 defines degree through the associated homomorphism to the dual
abelian variety. In particular, the paragraph immediately after Theorem 1.1
explicitly gives finitely many principal polarizations up to automorphism.
This is exactly the finiteness input needed after fixing a geometric
intermediate Jacobian. It asserts neither a bound on twists over the original
field nor effectiveness. The proof reduces to arithmetic-group orbit
finiteness using the Rosati involution and closed orbits in a semisimple
algebra; its cited foundational theorems were not independently re-proved.

**Disposition:** the original-source access gap in A1/D is closed. The
arithmetic deduction and its field/degree/geometric-class quantifiers stay
as in `2026-09-09-c1133-arithmetic-audit.md`.

## Two closest quantum comparisons, now fully read

- Cai, `arXiv:2608.01577v1`, **full text**, all 592 extracted lines,
  eight pages including references. Theorem 1 concerns symplectic
  irrationality of the cubic threefold itself. Sections 3–5 explicitly use
  the cubic exponents, big-parameter transport, curve comparison and integer
  powers in blowup comparison. These are substantial direct precedents.
  The paper does not state a one-stabilization theorem. Its coefficient ring
  permits unbounded negative z-orders across bulk coefficients (Section 2);
  reading it does not establish the present original/canonical-lattice
  contract. No correctness verdict on that different contract is inferred.
- Benedetti–Fay–Guéré–Manivel–Perrin, `arXiv:2607.26718v1`, **full text**,
  all 772 extracted lines, seven pages including references. Theorem 4.1
  requires a Fano hyperplane fourfold with b1=b3=0, the stated vanishing
  cohomology inequality and Hodge generality. Corollary 5.3 also obstructs
  birationality between two fourfold families; attribution must include this
  comparison result, not describe the paper as only an irrationality test.
  Remark 4.2 explicitly distinguishes center-relative evaluation maps from
  unrestricted center evaluations. Thus the center-specialization issue is
  recognized prior work. These results do not directly cover the proposed
  detected threefold products, whose H3 is nonzero.

Both comparisons are auditor conclusions about the fully read pinned versions,
not a claim to have reverified every proof or excluded future revisions.

## Search and access record

Discovery queries on 2026-09-10, verbatim:

```text
"Categorical base loci and spectral gaps" pdf
"Interpretations of spectra" "pdf"
"Polarisations on an abelian variety" pdf
Katzarkov Liu base loci 01473
Katzarkov Lee Svoboda Petkov Interpretations spectra 2023
Narasimhan Nori Polarisations 1981 36463
```

Screened fields: tool-returned titles, URLs and snippets. These are discovery
searches, not exhaustive sets or negatives. Individually promoted sources
already have entries in the source register. Unrelated returned hits were
not used as mathematical sources.

Direct requests, timestamps, status, bytes and SHA-256 are in
`2026-09-10-c1133-source-access.json`. Browser extraction and page screenshots
of the NN PDF failed, but the direct repository GET succeeded. INSPIRE's
record for the categorical-base-loci chapter was also retrieved directly;
it supplies the DOI but no document URL. The Springer chapter landing page
still exposes subscription metadata, not the chapter body.

## Process note

The initial handoff display exceeded the output bound. It was replaced by
five explicit line-range reads, completing the handoff. Subsequent source
reading used pinned files and bounded ranges. No source reading is inferred
from cache presence, and no Lean replay or manuscript theorem promotion is
part of this source pass.
