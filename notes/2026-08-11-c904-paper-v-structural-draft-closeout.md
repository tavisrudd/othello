# C904 — Paper V structural draft closeout

**Lane:** clebsch

**Date:** 2026-08-11

**Authority manuscript:**
papers/clebsch-round-trip/golden_companion_reconstruction.tex

**Rendered authority:** 18 pages, warning-free

## Final theorem spine

Paper V now has four load-bearing engines.

1. **Metric chordal recognition.** The Paper-II signed moment is placed on a
   chordal line of the two-dimensional \(A_5\)-invariant cubic pencil. Its
   singular rational normal quartic recovers the split \(A_5/C_5\)-orbit, and
   the stabilizer quotient recovers the six-set \(A_5/D_{10}\).
2. **Outer-difference classification.** The literal outer permutation gives
   \(q_\Pi\); on either selected chordal line, \(q_\Pi-1\) is the normalized
   isomorphism to the conference line. The selected-line groupoids are
   equivalent. Forgetting the line gives exactly the residual involution
   \(uq\), not another equivalence.
3. **Integral normalization.** The recovered six-set distinguishes the
   rank-five augmentation lattice from the rank-six \(D\)-weight lattice and
   identifies their common binary heart. Uniformly for symmetric conference
   matrices of order \(n\equiv2\pmod4\), \((I+B)/2\) minimally stabilizes
   \(D_n^\vee\), with the split/inert mod-eight residue dichotomy.
4. **Residual Frobenius.** At order six,
   \(D_6^\vee/2D_6^\vee\) is the unique nonsplit extension of the trivial
   \(\mathbf F_4\)-line by the natural heart. Golden reversal and the outer
   normalizer act by Frobenius. Paper IV's independent \(\mathbf F_8\)-marking
   is the degree-three case of the same Frobenius-orbit commutant lemma.

## Human-proof compression

The paper does not use a finite certificate as a mathematical premise.

- The Hankel singular scheme is proved by saturated ideal identities on three
  affine opens.
- The twelve-point orbit and six-set quotient use only split \(C_5\)
  eigenlines and stabilizers in \(\operatorname{PSL}_2(11)\).
- The conference pair is recovered by the normalized pentagon core.
- Full faithfulness is reduced to a projective frame plus the coprime metric
  and cubic scalar equations \(\lambda^2=\lambda^3=1\).
- Conference saturation is the forced half-vector and one quadratic identity.
- Nonsplitting is proved by the two visible generator actions on the six
  binary coordinates; their common fixed space is zero, and four displayed
  commutators span the heart.
- The Ext line is computed from the \((2,3,5)\) triangle presentation.
- The common six-point heart is identified directly through
  \(\mathbf Z^\Omega\cap2D_6^\vee=2\mathbf Z^\Omega+\mathbf Z\mathbf1\).

The checker replays only the Paper-II basis normalization and coefficient
transport. The README and verification README now state this boundary
explicitly.

## Sequential cold reads

### 1. Theorem-opening read — GO

The title, abstract, first four pages, two main theorems, and conclusion tell
the same story. The main theorem distinguishes selected and unselected
correspondences. A scope paragraph now excludes twisted forms, cubic equality,
unretained source charts, and integral-lattice conflation.

### 2. Paragraph-job read — GO

Every paragraph has one of four jobs: orient the object, prove one mechanism,
state a boundary, or record trust. Repeated proof summaries were removed. The
series diagram, proof-spine diagram, dependency table, and Frobenius square
have distinct jobs.

### 3. Proof and quantifier read — GO after repair

The only compressed load-bearing assertion was the nonsplit
\(\mathbf F_4A_5\)-extension. It is now replaced by the complete two-generator
fixed-space calculation and a direct commutator basis. Neutral scalar
extension is stated everywhere; arbitrary twisted forms are never inferred.

### 4. Marking-category read — GO

The selected-line equivalence and the bare quotient are separate statements.
The identity
\[
 (q_\Pi-1)(-q_\Pi h)=(q_\Pi-1)h
\]
identifies \(uq\) as the exact deck. The \(K^\times\), \(C_2\), and
\(C_2\times C_2\) fibres occur at different forgetful vertices and are not
conflated.

### 5. Literature and priority read — GO

The manuscript contains no “first,” “new,” or “to our knowledge” sentence.
The claim ledger is the sole priority surface. The opening audit read seven
sources in full and eight partially; the focused residue audit read Chapman
and Haemers--Parsaei Majd in full and exact sections of Bleher and
Bendel--Nakano--Pillen et al. MathSciNet, Scopus, and an external specialist
return remain uncovered, so priority stays unasserted.

### 6. Trust read — GO

The exact command

    make check

passes. It runs the schema-v2 evidence replay under Nix, lints the TeX, builds
the manuscript, and rejects every LaTeX warning. The evidence terminal is
CHECK OK (NO_MATCH); NO_MATCH is the proved failure of the literal
conference-cubic identification.

### 7. Rendered-page read — GO

All 18 pages were inspected as a contact sheet, with the opening, theorem
pages, residue proof, Frobenius square, verification boundary, conclusion,
and bibliography inspected separately. The only visible defect was overlap
in the lower labels of the Frobenius square; the node spacing and two-line
labels were repaired. No orphaned table row, clipped formula, bad float, or
warning remains.

## Back patches

notes/2026-08-11-c904-paper-v-unapplied-backpatch-packet.md contains exact,
paper-specific forward patches for Papers I–IV. It changes no predecessor
file in its frozen form.  Those proposals were subsequently superseded by the
broader reconstruction-framing pass and applied after full-paper rereads,
copy editing, and independent cold/A--B review.  The packet originally:

- sharpens the shared series paragraph to the selected-line equivalence and
  residual quotient;
- gives Paper I the integral meaning of its orientation;
- gives Paper II the chordal-to-conference return;
- gives Paper III the exact retained-output boundary; and
- integrates Paper IV through the \(\mathbf F_8/\mathbf F_4\)
  Frobenius-orbit principle without inventing a carrier map.

## EJ + TT closeout

The cheap upgrade was not another example or certificate. It was to make the
normalization theorem uniform in every symmetric conference order
\(n\equiv2\pmod4\), then specialize only the modular extension to \(n=6\).
This turns a series-specific residue calculation into a reusable
root--weight theorem while keeping the paper short. The second cheap upgrade
was the Frobenius-orbit commutant lemma, which makes Paper IV structurally
necessary to the ending without weakening its independence.

No further theorem belongs in this manuscript without diluting the severe
spine. The arithmetic family, Chow, exceptional gluing, and stable
irrationality programs remain separate research tracks.

## Mystery ledger

### Settled

- The hidden \(\mu_3\) automorphisms are killed by retaining the literal
  quadratic form.
- The conference-to-chordal map is two-to-one only before selecting a chordal
  line; the deck is \(uq\).
- The rank-five and rank-six lattices are distinct; their exact common object
  is the four-dimensional binary heart.
- The golden residue is \(\mathbf F_4\) only after maximal-order saturation.
- The geometric and residue involutions are the same Frobenius action.
- Paper IV fits through a common residual-field principle, not through a
  geometric arrow.

### Intentionally open

- Arbitrary twisted forms of the metric carrier are outside the theorem.
- The exact real/symmetric conference-saturation synthesis has a bounded
  non-pre-emption audit but no absolute priority claim.
- Lean formalization is deferred by explicit user instruction; no Lean source,
  generator, build, or trust contract was touched.
- The Papers I–IV patches and companion framing are applied and exported by
  forward commits; no public push has been made.

No manuscript-critical mathematical mystery remains.
