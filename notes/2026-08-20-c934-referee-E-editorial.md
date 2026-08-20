# C934 referee report E: editorial, priority, and presentation

**Frozen authority:** `53e19feff1f66e7b4b453a38fcc0f239ece007d6`

**Frozen PDF:** `papers/blown-up-theta-lattice/blown_up_theta_lattice.pdf`

**Verified PDF SHA-256:**
`108983c8420086abb85889c4d3eff32e1c40fc281e28d6599feacd03d21ddc6e`

## 1. Verdict

**B -- minor revision.** The revised 11-page paper has a coherent upgraded
spine, an accurate 180-token abstract, a theorem-backed mod-two/mod-three
synthesis, and clean rendering. I found no editorial evidence of a theorem
overclaim. One priority repair is required: the manuscript cites Krämer and
Juteau--Mautner--Williamson, but it does not cite de
Cataldo--Migliorini's rational intersection-form framework or Cipriani's
general 2026 classification of small indecomposable extensions over a closed
stratum. Both are close enough to the new Theorem 1.4 that the present
bibliography leaves the general mechanism incompletely attributed.

This is a local literature-framing repair, not a mathematical revision. After
it is made, my editorial verdict is A.

## 2. Title and abstract

The title, *Integral Cohomology and Modular Decomposition for the Theta Divisor
of a Cubic Threefold*, accurately names the two parts of the paper. “Integral
cohomology” is concretized immediately by the rank-130 middle lattice and the
later index-three comparison; “modular decomposition” is the coefficient-three
behavior of the residual perverse factor. The title does not claim a general
decomposition theorem.

The abstract passes all four editorial tests.

1. It names the cubic-threefold theta divisor and its resolution.
2. It states the mod-two fibre-product defect and the integral direct-image
   theorem, including the central map `Z --3--> Z`.
3. It distinguishes the rational splitting, failure of an integral point
   summand, and characteristic-three indecomposable nonsemisimple reduction.
4. Its final mod-two/mod-three sentence is a conclusion of the displayed and
   stated theorems, not an unsupported significance claim.

An independent conservative count of the PDF-extracted abstract, including
fragmented display-math tokens, is **180**, below the required 250 words. The
abstract is dense but readable and does not need shortening.

## 3. Priority and attribution

### Correctly attributed boundaries

- Printed pages 3 and 5 give Faulkner Valiente--Miller Eismeier exact ownership
  of the abstract Smith factors and `Lambda/2Lambda` defect. The manuscript
  retains only the direct complete-graph blocks, divided-power representatives,
  and their Fano-labelled realization.
- Printed page 8 identifies Krämer Corollary 6 as the pre-existing
  complex/rational decomposition and calls the splitting noncanonical. Direct
  inspection of Krämer's Corollary 6 confirms the three point terms in shifts
  `2,0,-2` and its complex-coefficient setting.
- Printed page 9 cites Juteau--Mautner--Williamson Proposition 3.2 and
  Corollary 3.5 for the field-coefficient relation between point-summand
  multiplicity, costalk-to-stalk maps, and fibre intersection forms. Those
  exact statements were verified in the source. The paper then explicitly
  supplies its own integral unit-block adjunction argument rather than silently
  extending JMW's coefficient theorem.
- The paper makes no unqualified “first,” “new,” or “to our knowledge” claim.
  Its retained contribution is example-specific: the integral blocks
  `[-1],[-3],[-1]`, the two outer integral splittings, the characteristic-three
  residual object, and the Fano realization of the local order-three boundary.

### Required repair

Add one compact related-work sentence and two bibliography entries. The natural
locations are the prior-art paragraph on printed page 3 and the “standard
intersection-form description” paragraph on printed page 9.

The sentence should make this division of credit explicit:

- de Cataldo--Migliorini develop the rational intersection-form mechanism for
  resolutions, including isolated fourfold singularities; their checked paper
  works throughout with rational coefficients and does not compute this cubic
  theta example's integral blocks;
- Cipriani gives a general field-coefficient framework for small extensions and
  characterizes indecomposability by the non-decomposition of the canonical
  extension-pair map; it contains no cubic-threefold, theta-divisor, Smith-form,
  or intersection-form computation.

This repair is mandatory because the upgraded paper now advertises the modular
indecomposable object as part of its headline, and those sources own the closest
general mechanisms. It need not weaken any theorem or add a novelty disclaimer.
It should say once, neutrally, that the paper's contribution is the explicit
integral and geometric specialization.

## 4. Mod-two/mod-three synthesis

The synthesis is mathematically backed at the level claimed in the title and
abstract.

- The mod-two defect is global: Theorems 1.1--1.2 identify the simultaneous
  Gysin/restriction fibre product, the `Lambda/2Lambda` saturation quotient,
  and its dual doubled exceptional sublattice.
- The mod-three defect is local and categorical: equations (19)--(23) identify
  the central `[-3]` intersection block, failure of an integral point summand,
  and characteristic-three rank drop with an indecomposable nonsemisimple
  residual perverse sheaf.
- Equations (24)--(26) prevent a misleading torsion reading: the Fano class
  lifts the order-three link generator to an infinite-order global class, so
  the `Z/3` occurs as an index-three attachment rather than global torsion.

Thus “distinct global mod-two and local mod-three defects” is precise. The two
primes come from different maps and degrees; the manuscript does not suggest a
single uniform prime-defect theorem.

## 5. Presentation and rendering

I read all 11 printed pages in extracted text and visually inspected every page.
The title page, theorem suite, equations (1)--(26), commutative diagram,
cross-references, AI disclosure, and bibliography render cleanly. There are no
clipped displays, collisions, missing equation numbers, broken references,
illegible page breaks, or font substitutions. The compact bibliography remains
readable; page 11 has generous white space but no presentation defect.

The exposition has one strong through-line: integral middle glue, its rational
boundary, the integral direct image, bad-prime reduction, and the Fano fate of
the local class. Theorem 1.4 appears by printed page 3 and Section 7 contains the
full coefficient-level statement, so the upgrade is not buried as an appendix.

## 6. Main failure modes explicitly checked

- **Old-paper title with a new appendix:** not present; title, abstract,
  Theorem 1.4, and the final section all foreground the modular theorem.
- **Rational result repackaged as integral:** not present; Krämer is credited,
  and the unit versus factor-three blocks visibly govern coefficient change.
- **General modular formalism sold as new:** theorem statements remain
  example-specific, but the two missing general-framework citations require the
  local repair above.
- **Mod-two/mod-three slogan without a bridge:** not present; the separate
  fibre-product and local-attachment theorems justify the contrast.
- **Characteristic-three failure confused with torsion in global cohomology:**
  explicitly ruled out by equations (24)--(26).
- **Abstract overflow or visual regression:** not present; 180 tokens, 11 clean
  A4 pages.

## 7. Venue recommendations

### Mathematische Zeitschrift

**Recommend after the minor priority repair; strongest and most likely target.**
The paper is a focused specialist result at the intersection of algebraic
geometry, topology of resolutions, and modular perverse sheaves. The new
integral/modular theorem and Fano realization are substantial enough to move it
beyond a short lattice note, while its example-specific scope fits a broad
research journal better than a highest-selectivity specialist venue.

### Algebraic Geometry

**Credible stretch, but not my first recommendation.** The object and methods
are squarely in scope, and the mod-three theorem supplies a genuine conceptual
upgrade. The editorial risk is that the rational decomposition and general
intersection-form/extension mechanisms are prior, leaving a sharp computation
for one distinguished resolution. I would not call an AG submission
unreasonable, but MZ has the higher acceptance-adjusted value.

### Proceedings of the American Mathematical Society

**Recommend as a conservative fallback, subject to final journal-format page
count.** The paper is concise, new, and self-contained enough for Proceedings,
and the current 11 A4 pages are compatible in spirit with a short-paper venue.
The expanded perverse-sheaf spine is now specialist enough that Proceedings
would undersell the strongest version of the paper; MZ should be tried first.

## 8. Sources actually opened and confidence

- Frozen PDF: all 11 pages in full text and page-by-page visual inspection;
  hash verified above.
- `claim-proof-novelty-ledger.md` and `literature-audit.md`: both read in full.
- `notes/2026-08-20-c934-priority-audit.md`: read in full.
- Krämer, arXiv:1501.00226, SHA-256
  `bad27e7b9eee618e83259d392d706e0738756fa57cd33f021641c2f1b4fed9f6`:
  Corollary 6 and its full surrounding proof.
- Juteau--Mautner--Williamson, arXiv:0906.2994, SHA-256
  `cb18832f73adb0b0ccc74d34f9f92b0ab52a9b275351c3658ee3f8f5eb88f3b4`:
  Sections 3.1--3.2 around Proposition 3.2 and Corollary 3.5.
- de Cataldo--Migliorini, arXiv:math/0504554, SHA-256
  `f02d2127019d02e87934e1bcb2e5101dc909600d8c6b702ad7401619a95f20a6`:
  coefficient convention, Section 2.4 on isolated fourfold singularities, and
  the opening derived-category splitting discussion.
- Cipriani, arXiv:2607.09379, SHA-256
  `2d8774913c1b33c0c255e6aa67309ddffcccd1e5869f8c28da76eead524d4a77`:
  abstract and introduction, Lemma 3.12, Corollary 3.22, and the surrounding
  classification statements.

Confidence is **high** on the abstract, rendering, rational/JMW attribution,
and the pinpointed missing citations. Confidence is **medium-high** on venue
ranking because editorial selectivity is less determinate than correctness.
This packet did not reconstruct the load-bearing modular or Fano proofs; those
belong to Packets A and G. Nothing found here prejudges their mathematical
verdicts.

## 9. Remaining finding

**One required minor repair:** cite and delimit de Cataldo--Migliorini and
Cipriani in the introduction/Section 7, then rerun the bibliography and visual
gate. No other editorial, priority, abstract, or presentation repair remains.
