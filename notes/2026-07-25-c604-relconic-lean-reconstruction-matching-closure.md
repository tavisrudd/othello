# C604 relconic Lean reconstruction and matching-design closure

**Lane:** `relconic`

**Status:** ACTIVE — initial Terence--Tao theorem-shape diagnostic complete.

## Goal

Close the paper-facing Lean gap for:

1. exact recovery of a projective arc from its ordinary uncovered locus above
   the strict incidence threshold, including the canonical secant/vertex
   reconstruction and semilinear-stabilizer equality; and
2. the zero-defect concurrence decomposition, maximum-matching design, exact
   centre counts, and bad-edge stability theorem.

Finish by importing the public declarations through
`RelativeConicArcs.Gates.Relconic`, auditing their axioms, and synchronizing
the trust manifest, proof audit, and manuscript verification table with the
actual checked boundary.

## Ordered execution

1. **Terence--Tao diagnostic first.** Before designing declarations or editing
   Lean, identify the invariant formulation Tao would seek, the smallest
   reusable incidence/Kneser interface, hidden finiteness or Desarguesian
   hypotheses, sharpness and converse questions, and whether one abstraction
   proves both reconstruction and matching rigidity without coupling unrelated
   paper notation. Record the resulting theorem-shape decisions here.
2. Read the nested Lean guide and inventory only the directly relevant
   existing definitions and theorem signatures.
3. Formalize exact uncovered-locus reconstruction and the canonical inverse /
   stabilizer corollary.
4. Formalize concurrence-clique decomposition, zero-defect
   `MATCH(k,floor(k/2),1)` rigidity, exact centre counts, and bad-edge
   stability.
5. Validate through the scoped Relconic gate, run the required axiom audit,
   and reconcile every paper/trust statement with the declarations actually
   imported.
6. Run the required `ej`+`tt` closeout, record the mystery ledger, and complete
   the normal relconic task lifecycle.

## Initial Terence--Tao diagnostic

The invariant object is not the prescribed conic and not a coordinate model.
It is a finite linear-space incidence structure together with a complete-graph
edge realization: vertices are arc points, edges are their secant lines, and
disjoint edge pairs acquire the unique intersection point of their realized
lines.  The two theorem families should share that edge/secant vocabulary but
should not be forced through one oversized paper-specific structure.

The smallest reusable split is:

1. a line-union recovery lemma saying that two finite families of `N` distinct
   lines with equal point unions are equal when every line has more than `N`
   points and two distinct lines meet in at most one point;
2. an arc-secants interface proving injectivity of the edge-to-line map,
   characterizing the arc vertices intrinsically among the secant lines, and
   making this reconstruction equivariant under incidence automorphisms; and
3. a finite matching interface on the two-subsets of the vertex type, where
   each intersection centre indexes the matching of secants through it and
   uniqueness of line intersection partitions all pairs of disjoint edges.

This yields the canonical inverse in two visibly separate steps.  Equality of
ordinary uncovered loci is equality of secant-line unions, so the first lemma
recovers the secant family under
`q + 1 > binom k 2`.  For `k >= 4`, the points incident with `k - 1` recovered
secants are exactly the arc vertices: an off-arc point sees a matching and
therefore at most `floor (k / 2)` secants.  Naturality of this intrinsic
description gives equality of setwise stabilizers for any incidence-preserving
action; semilinear projective maps are an application, not a hypothesis of the
core theorem.

The concurrence theorem is likewise incidence-combinatorial.  At a centre,
the incident realized edges form a matching because three arc points are not
collinear.  Every pair of disjoint edges belongs to exactly one such matching,
so the nontrivial centres give a clique decomposition of the Kneser graph.
Zero defect is used only after this decomposition, to force every clique to
have maximum size.  The resulting family is then a simple
`MATCH(k, floor(k/2), 1)` design; its total number of centres and the number
through a fixed secant are finite double counts.  The bad-edge statement
should be an abstract weighted-partition inequality fed by the already proved
defect identity, rather than a second geometric proof.

Hidden hypotheses to expose in declarations are finiteness and decidable
equality for counts; simplicity of the projective incidence structure; uniform
line size only for the numerical recovery threshold; injectivity of the
secant realization from the arc condition; and `k >= 4` where the intrinsic
vertex threshold and divisions in the matching counts require it.  Neither
Desarguesian coordinates, a field, characteristic, a conic, nor parity belongs
in the core reconstruction or decomposition theorem.  Desarguesian and
characteristic hypotheses remain confined to later classification
corollaries, which C604 does not formalize.

Sharpness questions delimit the implementation.  The strict line threshold is
essential for this elementary recovery mechanism: at equality a line can be
covered pointwise by its intersections with the competing family.  The
matching-design conclusion has no converse to projective realizability; an
abstract `MATCH` design need not admit a rank-three secant realization.  The
quantitative C583 estimates are not free consequences of the exact inverse:
they require Bonferroni/pair-count inequalities and degree corrections, so
they remain outside C604.  Likewise, zero defect is sufficient for maximum
matchings, but the formal result must not imply that every maximum-matching
design comes from an arc or that every such arc is conic-compatible.

## Acceptance boundary

- No manuscript claim may say reconstruction or matching rigidity is
  kernel-checked unless a named theorem is imported by the Relconic gate.
- The axiom report must remain within the documented Mathlib foundations, with
  no `sorry`, `admit`, custom axiom, or `native_decide`.
- The quantitative C583 inverse-stability package is out of scope unless the
  initial diagnostic shows it is a free consequence of the exact
  reconstruction interface; otherwise retain it as a separately allocatable
  successor.
- The Singular-backed ten-point rank-three classification is out of scope; its
  explicit non-Lean trust boundary must remain visible.
