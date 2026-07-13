# Exact value of rho_C(16) — archive

Append-only session history for
[`2026-07-12-rhoc16-exact-value.md`](2026-07-12-rhoc16-exact-value.md).

## 2026-07-12 — C101 allocated

- Isolated the manuscript's remaining finite gap from C100's game-localization review.
- Set the two accepted endpoints: an eight-point checked construction, or a checked exhaustive
  nonexistence certificate for eight points followed by the existing nine-point construction.
- Required the final result to update the paper, PDF, proof audit, verifier provenance, Lean trust
  manifest, and global result registry so the `{8,9}` statement cannot remain stale.

## 2026-07-12 — exact classification and formal reduction

- The independent `GF(16)` enumerator found no relative-complete eight-arc.  Normalization by a
  four-frame gives class counts `4, 61, 454, 2633` at sizes five through eight, from respectively
  `182, 532, 5155, 21495` legal extensions.
- The decisive invariant was not conic-stabilizer search.  Let `U(A)` be the ordinarily uncovered
  locus.  Relative completeness outside a conic forces `U(A)` onto that conic, so its quadratic
  monomial rows must have a nonzero common null vector.  Of the 2633 leaves, 2630 have six
  uncovered rows of full rank.  Only classes 89, 90, and 2631 have rank five; in all three, the
  unique possible quadratic also vanishes at a selected point and therefore cannot be disjoint.
- The Lean certificate deliberately checks ordinary projective classes, not only arcs disjoint
  from the standard conic.  Every transition retains an explicit invertible linear map and
  pointwise scalar equalities.  The global reduction chooses any four points of an arbitrary
  eight-cap, normalizes them to the standard frame by a retained linear equivalence, indexes the
  result, applies all four augmentation books, and transports the conic through the final leaf
  equivalence.
- Kernel-check performance was made tractable without changing trust: `GF(16)` multiplication is
  unrolled; every leaf explicitly enumerates its eight members; only the 28 unordered secants are
  checked; swapped determinant nonvanishing is proved once; and inverse checks use reflected
  arithmetic.  No `native_decide` or external-evaluator theorem was introduced.

### Adversarial review notes

- A negative-control mutation changing one leaf member made its local `by decide` theorem fail.
  Restoring the member restored the certificate.
- A second negative control changed one transition scalar from 1 to 2; its checked projective-map
  theorem failed.  This confirms that neither the leaf enumeration nor the canonical transition
  labels are accepted opaquely.
- The semantic review checked the two most dangerous coverage gaps: arbitrary eight-arcs really
  are reduced by a *linear* projectivity (not merely a cap-preserving permutation), and the conic
  is transported through both the frame normalization and final leaf equivalence.  It also checked
  that the 28-pair table covers either orientation of every distinct pair and that the rank-five
  forced-hit contradiction uses a point certified to lie in the arc.

### Post-formalization corollaries and extension queue

- **General certificate pattern:** for any algebraic exceptional locus defined by forms in a
  finite-dimensional coefficient space, ordinary-uncovered points give linear evaluation rows.
  Full evaluation rank rules out relative completeness; a smaller kernel can be rejected by
  forcing every surviving form to hit the selected set.  The conic case is the six-dimensional
  quadratic instance.
- **Stronger finite statement:** the 2630 full-rank leaves rule out *every* nonzero quadratic zero
  set, singular or nonsingular.  The three forced-hit leaves rule out every quadratic zero set
  disjoint from the arc.  Thus the leaf computation is algebraically stronger than the manuscript's
  nonsingular-conic application, although the registered `rho_C` theorem states only what is
  needed.
- **Surprise:** only three of 2633 projective eight-arc classes admit any nonzero quadratic through
  their entire ordinary-uncovered locus, and each of those three is defeated by intersection with
  the arc.  This sharp `2630+3` split was not predicted by the scalar defect inequalities.
- **Odd-q relevance:** the rank test is usable as a static pruning certificate when an ord-q proof
  or proof-DAG proposes a conic-sealed terminal region.  It does not itself provide a legal reply,
  a monotone drain, or a minimax strategy, so it does not directly close C80/C84.
- **Novelty caution:** the uncovered-form rank formulation and the exceptional `2630+3` structure
  are candidates for a targeted literature comparison, not present priority claims.

### Additional end-of-track observations to revisit

- **Veronese reformulation:** the quadratic evaluation row of a point is its degree-two Veronese
  image in the dual six-dimensional coefficient space.  The common case says that six uncovered
  Veronese images span the whole space; the exceptional-locus equation would have to be a
  hyperplane containing them.  This makes the certificate geometric and may admit structural
  spanning arguments that avoid class enumeration at other orders.
- **Linear-system extension:** the same proof works for a prescribed hole set contained in the
  zero locus of any member of a finite-dimensional linear system of degree-`d` forms.  Full
  evaluation rank rejects it; in lower rank, it is enough to prove that every form in the surviving
  kernel vanishes somewhere on the selected cap.  The rank-one forced-hit certificate used here is
  the cheapest instance, not a conic-specific endpoint.
- **Exceptional-form anatomy (exploratory computation, not yet a registered Lean theorem):** with
  coefficient order `(X²,Y²,Z²,XY,XZ,YZ)`, the unique forms through the uncovered loci of classes
  89, 90, and 2631 are proportional to `(1,1,1,1,1,0)`, `(0,0,0,5,4,1)`, and
  `(2,1,1,5,5,1)`.  The first and third are singular and meet two selected points.  The middle form
  is nonsingular and meets seven of the eight selected points.  This unexpectedly rigid middle
  class may have a short conceptual orbit explanation and is worth checking against the complete-
  arc classification literature before making any novelty claim.

## 2026-07-13 — targeted novelty and general literature check

- Found direct prior art for the raw ordinary classification count: Al-Seraji--Al-Ogali (2018),
  Theorem 3.8.1, reports exactly 2633 projectively distinct eight-arcs in `PG(2,16)`. The paper and
  result registry now describe our count as an independent reproduction, not a new enumeration.
- Compared the relative definition with saturating sets, almost-complete subsets of a conic, and
  arcs covering a prescribed line. These are close but reverse or omit the prescribed-exception
  condition: none of the checked sources has an arc disjoint from a conic whose secants are only
  required to cover its complement.
- Compared the algebraic certificate with Glynn's and Ball's arcs-and-quadrics framework. Linear
  evaluation conditions on quadrics are established technique, so the generic evaluation lemma is
  presented as elementary rather than novel.
- Searches within the 2018 classification found ordinary class counts, stabilizers, secant-index
  distributions, and conic-contained arcs, but not the ordinary-uncovered quadratic rank invariant,
  the `2630+3` split, or the relative-conic nonexistence consequence. No checked source stated
  `rho_C(16)=9`; this is a bounded-search conclusion, not a priority certificate.
- The durable source-by-source comparison is `notes/2026-07-13-rhoc16-novelty-check.md`.

## 2026-07-13 — final aggregate validation and composition negative control

- Sequentially built all 261 lightweight parent-book modules, then the
  `Q16CertificateData` aggregate, `EvaluationObstruction`, `Q16Reduction`, `Q16Result`, and the
  global `Results` registry. The headline axiom reports are exactly
  `[propext, Classical.choice, Quot.sound]`.
- The reusable evaluation obstruction required `CommSemiring K`, rather than the draft's
  `Semiring K`, for scalar combinations of `K`-linear functionals. It compiles without a
  finite-dimensionality hypothesis, so this correction does not narrow any intended application.
- Made the finite projective-point `Fintype` and `DecidableEq` instances explicit and local in
  `Q16Result.lean`; this removed reliance on a transitive/local instance at the final theorem site.
- Adversarially omitted `booksL7_226` from the level-seven aggregate. The kernel rejected
  `books7_valid` because the parent list no longer equaled `level7`. Restoring the book restored
  the aggregate and final theorem builds. This supplements the prior leaf-member and transition-
  scalar negative controls with an end-to-end composition coverage check.

## 2026-07-13 — cross-artifact consistency checklist

- [x] **Headline theorem:** the manuscript source, README, trust manifest, completed handoff,
  result registry, `Q16Result.lean`, and papers index all state the exact value
  `rho_C(16)=9`. The preliminary bounds theorem remains intentionally available in
  `Results.lean` and is followed by the exact theorem.
- [x] **Classification arithmetic:** the frozen report states 2633 leaves with nullity split
  `2630+3`; the generated tree contains 727 transition modules, 330 leaf modules, and 261
  parent-book modules. The class counts `4,61,454,2633` agree across the report and prose.
- [x] **Provenance:** current SHA-256 values of the verifier, generator, and frozen report are
  respectively `e9508958...d36a`, `589af843...9031`, and `6989079b...cc63`, matching
  `TRUST.md` and the manuscript.
- [x] **Trust boundary:** no Lean proof in `RelativeConicArcs/` uses `sorry`, `admit`, a custom
  axiom, or `native_decide`. A fresh pinned-environment replay of `Q16Result` and `Results`
  succeeded; both headline q=16 declarations report exactly
  `[propext, Classical.choice, Quot.sound]`.
- [x] **Isolation:** after excluding the spinoff directory and its umbrella module, no Lean
  source imports `RelativeConicArcs`. The package remains one-way coupled to shared projective
  infrastructure.
- [x] **Paper/index coverage:** all six relevant lane additions are registered in the papers-index result
  table: projective reduction, general evaluation obstruction, uncovered-quadratic obstruction,
  class refinement, exact q=16 value, and consolidated small values.
- [x] **Novelty wording:** every public summary marks the ordinary 2633 count as prior art and
  the computation as an independent reproduction; the bounded novelty claims point to the
  source-by-source literature note. `TRUST.md` and the README were given the same provenance
  pointer during this pass.
- [x] **Links and citations:** all local Markdown links in the paper/lane/trust documents resolve;
  every TeX citation key is defined and every bibliography item is cited.
- [x] **Lane state:** both formalization handoffs are under `notes/handoffs/done/`, with no stale
  active copy. The live documents contain status maps; this dated checklist remains in the
  append-only companion.
- [x] **Adversarial evidence:** leaf-member, transition-scalar, and omitted-parent-book mutations
  each failed at the intended trust layer, and restored sources rebuilt through the final theorem.

Two wording corrections were made: audit prose now says that no *proof uses* `native_decide`
rather than literally claiming the token is absent (it occurs in an explanatory comment), and
the trust/README novelty summaries now link the durable comparison note. No mathematical or Lean
source change was required by this pass.
