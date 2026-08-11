# C904 — Paper V back-patch packet for Papers I–IV

**Lane:** clebsch

**Date:** 2026-08-11

**Status:** prepared, not applied. No Paper I–IV manuscript, PDF, mirror, or
release file was edited for this packet.

## Purpose

Paper V now proves a sharper statement than the common series paragraph in
Papers I–IV: the upper branch is an intrinsic classification on the literal
quadratic augmentation carrier; the selected-line correspondence is an
equivalence, while the unselected correspondence is a residual \(C_2\)-cover.
It also identifies the final \(C_2\)-marking with Frobenius on the normalized
\(\mathbf F_4\)-heart. Paper IV remains geometrically independent, but its
\(\mathbf F_8\)-marking is the degree-three instance of the same
Frobenius-orbit commutant principle.

The released predecessors must receive these changes only as ordinary forward
versions. Nothing here authorizes rewriting released history.

## Shared series-perspective replacement

In the series-perspective paragraph of each paper, replace the sentence

> Paper V proves that they share one invariant pencil and six-axis carrier
> and, after marking a chordal line, recover each other with orientation.

by:

> Paper V classifies the two distinct normalized shadows on the fixed
> quadratic six-axis carrier. After one chordal line is selected, outer
> difference gives an equivalence between the chordal and oriented
> conference packages; forgetting that line leaves exactly one residual
> \(C_2\)-ambiguity.

Then retain, rather than weaken, the existing sentence that Paper IV is a
parallel branch with no cubic identification.

In the upper-row figure caption, replace “the marked transports and returns”
by “the selected-line equivalences and source returns,” and append:

> Without the selected line the upper correspondence is a \(C_2\)-quotient.

This patch is needed in:

- papers/clebsch-rigidity/clebsch_rigidity.tex, series perspective and Figure
  1 caption;
- papers/clebsch-factorization/clebsch_factorization.tex, series perspective
  and Figure 1 caption;
- papers/clebsch-passages/sections/01-introduction.tex, series perspective
  and Figure 1 caption;
- papers/q13-passant-code/passant_code_q13.tex, series perspective and Figure
  1 caption.

## Paper I: orientation acquires an integral meaning

Target: papers/clebsch-rigidity/clebsch_rigidity.tex, Conclusion, immediately
after the paragraph ending “a nontrivial integral endomorphism order, not only
a projective configuration.”

Proposed paragraph:

> Paper V determines the integral residue of this orientation. The recovered
> six-set supports both the rank-five augmentation lattice and the rank-six
> \(D_6\)-weight lattice; they are not the same lattice, but their mod-two
> reductions have the same four-dimensional heart. After the golden operator
> is normalized on \(D_6^\vee\), its reduction is a primitive scalar in
> \(\mathbf F_4\), and reversing the conference orientation applies
> Frobenius. Thus the orientation reconstructed here selects one of the two
> Frobenius-conjugate residue structures.

Add the Paper V bibliography entry if it is not already present. Do not claim
that Paper I itself constructs \(D_6^\vee\) or proves the extension theorem.

## Paper II: identify what the signed cubic reconstructs

Target: papers/clebsch-factorization/clebsch_factorization.tex, Conclusion,
after the final paragraph on the first signed tensor moment.

Proposed paragraph:

> Paper V places this actual signed generator on a chordal line of the
> \(A_5\)-invariant cubic pencil. Its singular rational normal quartic carries
> a split \(A_5/C_5\)-orbit, and the stabilizer quotient
> \(A_5/C_5\to A_5/D_{10}\) recovers the six matching axes. Relative to the
> selected chordal line, the outer difference operator returns the oriented
> conference companion; if the line is forgotten, the two chordal choices
> remain a genuine residual double cover.

The existing Paper V citation is sufficient. Preserve the actual signed
generator and pivot normalization in the statement; do not projectivize them
away.

## Paper III: state the exact retained-output return

Target: papers/clebsch-passages/sections/09-conclusion.tex, after the paragraph
ending “no map between their ambient harmonic representations is asserted.”

Proposed paragraph:

> Paper V turns this marked comparison into a strict source-return theorem.
> Once the selected chordal line is included in the bridge datum, the
> conference source, its orientation, and all retained Paper-III markings are
> recovered exactly. The chart lift, scale, Petersen labels, and
> cross-identification remain declared bridge data; the companion
> classification does not manufacture them. Forgetting the selected chordal
> line leaves the same residual \(C_2\)-deck involution that appears in the
> normalized integral residue.

This is a scope clarification, not a new theorem of Paper III. Preserve all
existing characteristic-zero and integral-model boundaries.

## Paper IV: make the lower branch part of the punchline

Target 1: papers/q13-passant-code/passant_code_q13.tex, series perspective.
After the sentence asserting logical independence, add:

> The comparison at the end of Paper V is representation-theoretic rather
> than geometric: the \(\mathbf F_8\)-operator marking recovered here and the
> \(\mathbf F_4\)-marking of the upper branch are the degree-three and
> degree-two cases of one Frobenius-orbit commutant lemma. No map between the
> two carriers is asserted.

Target 2: the lower-right node in the series figure. Replace
“marked conic plane and polarity” by
“marked conic plane and an \(\mathbf F_8\)-orbit.”

Target 3: Conclusion, after the first paragraph. Add:

> The hidden operator field also records the final ambiguity: choosing one of
> its three absolutely simple constituents is a principal \(C_3\)-marking.
> Paper V proves the general Frobenius-orbit commutant lemma and compares this
> marking with the upper branch's independent \(C_2\)-marking. This comparison
> strengthens the unity of the series without weakening the standalone
> reconstruction proved here.

Do not add an arrow from Paper IV to the upper cubic carrier, identify the two
groups or modules, or describe the comparison as a common geometry.

## Promise changes and non-changes

The forward versions may now promise:

1. one intrinsic selected-line classification for the upper three papers;
2. an exact residual \(C_2\)-quotient after forgetting the selected line;
3. a common Frobenius-orbit principle for the final \(C_2\) and \(C_3\)
   markings;
4. a precise distinction between the two integral six-set lattices.

They must still not promise:

1. equality of the chordal and conference cubics;
2. recovery of source-local charts absent from the retained bridge;
3. arbitrary twisted-form classification;
4. a geometric or code-theoretic arrow between Paper IV and the upper branch;
5. a common integral lattice for the rank-five and rank-six constructions.

## Application and validation order

Apply only after Paper V's authority PDF and theorem IDs are frozen.

1. Paper II first, because it owns the chordal source and normalization.
2. Papers I and III next, against the selected-line source-return theorem.
3. Paper IV last, using only the Frobenius-orbit lemma and independence
   boundary.
4. Rebuild and visually inspect each paper independently.
5. Run each paper's existing manuscript/trust gates without changing their
   validation contract.
6. Synchronize standalone mirrors only after reading the export-and-mirror
   conventions and only as forward commits.

The shared paragraph should be textually synchronized, but each conclusion
patch is intentionally paper-specific.
