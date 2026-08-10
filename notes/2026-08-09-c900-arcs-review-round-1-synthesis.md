# C900 Arcs paper — sealed review round 1 synthesis

**Date:** 2026-08-09  
**Status:** first-round reports frozen; manuscript repair authorized  
**Boundary:** human proofs and exposition only

> **REVIEW-SUB-AGENT MATERIAL ONLY.** Do not route this synthesis through the
> normal `relconic` handoff, manuscript startup context, or Lean work. It may
> be given to a repair agent, but never to a context-clean re-reviewer.

## Frozen reports

The four first-round readers worked independently and did not receive the
reviewer dossier, baseline feedback, proof audit, trust material, or one
another's reports.

1. Ball persona: `notes/2026-08-09-c900-arcs-ball-cold-read.md` — `MINOR`.
2. Szőnyi persona: `notes/2026-08-09-c900-arcs-szonyi-cold-read.md` — `MINOR`.
3. Wanless/Alspach persona:
   `notes/2026-08-09-c900-arcs-matching-cold-read.md` — `MINOR`.
4. Montanucci/Giulietti persona:
   `notes/2026-08-09-c900-arcs-conic-cold-read.md` — `MINOR`.

No reader found a false theorem or central proof gap. All accepted the exact
defect identity, equality mechanism, stability bounds, matching-design
extraction, one-block-short leave argument, and the large-k
characteristic-two classification. The Szőnyi and conic readers independently
reconstructed the full tangent-involution/sign contradiction.

## Accepted repairs

### Convergent findings

1. Qualify the characteristic-two opening claim by odd `k>=7` and even
   `k>=6`. Both specialist readers independently found the mismatch between
   the unrestricted abstract and the proved body ranges.
2. State `k>=3` in the introductory defect theorem and `k>=4` in the MDS
   parity-check sentence. Ball and Szőnyi independently found this convention
   seam.
3. Replace ambiguous "tangent A-secant" language by "conic-tangent secant of
   A". Ball and both geometry readers found the arc-tangent/conic-tangent
   collision.
4. Add the explicit inference `T in S` before the sign count. Both geometry
   readers independently identified the omitted but valid bridge.
5. Give the chord involution coordinate-free before choosing coordinates,
   including tangent contacts as fixed points, the nucleus as the identity,
   and a nonnuclear tangent-line center as having one fixed point.
6. Separate relative affine completeness from hyperfocusedness and pin the
   corresponding Giulietti--Montanucci definition/proposition.

### Single-specialist findings accepted on ownership

7. Say explicitly that the factorization extracts pointwise equality and
   stability from the two classical moments rather than adding an independent
   incidence equation; attach Ball's classical baseline near the additive
   lower-bound proof.
8. Replace "prescribed subplane" in the KNS boundary by "defining subfield
   subplane."
9. Expand the `MATCH(10,5,1)` to `pg(5,7,3)` incidence calculation, correct
   the Reichard--Woldar proposition pinpoints, separate Mathon's completeness
   input from the construction and inequivalence results, and define the
   regular-hyperoval design via Alspach--Heinrich Theorem 1.2.
10. Make the universal theorem lead the abstract, with the conic bound and
    exact values presented as applications. This agrees with every reader's
    account of the actual theorem hierarchy and with the quarantined baseline.

## Deferred rather than rejected

- Moving the verification contracts to an electronic supplement is a venue
  and release-architecture decision. Only the Ball persona requested it, and
  the current paper deliberately owns a self-contained trust map. Reconsider
  after the repaired re-review and a rendered-length comparison.
- Expanding the six-point converse beyond "direct substitution" would improve
  exposition, but the matching specialist found no mathematical defect and
  supplied no verified uniform identity or cited symmetry reduction. Do not
  insert an unproved shortcut merely to lengthen the paragraph.
- A title reversal, an `O(sqrt(q))` construction, and model-level stability
  are potential upgrades, not review repairs. They remain research/editorial
  decisions outside this round.

## Re-review gate

After the accepted repairs and a clean paper build, run at least two sealed
context-clean reads:

1. a geometry read of the opening ranges and the full involution/sign chain;
2. a design/generalist read of theorem hierarchy, classical novelty wording,
   and the ten-point partial-geometry bridge.

Neither reader receives this synthesis or the first-round reports. The gate is
green only if both return `GO`, or return `MINOR` with disjoint purely stylistic
findings and no repeated unresolved item from this round.

## Repair and sealed re-review outcome

The accepted repairs were applied to the manuscript and the pinned TeX build
completed without warnings in 27 pages. The context-clean geometry re-review
returned `GO` with no actionable finding and independently closed the entire
nucleus/involution/sign chain.

The first context-clean design/generalist re-review returned `MINOR` on two
bibliographic points only: Ball Theorem 3.1 had been attached as support for a
conic-relative first-moment inequality to which it does not apply, and the
load-bearing Mathon classification was cited only through later reports. The
manuscript moved Ball Theorem 3.1 to an explicit comparison with the ordinary
complete-arc square-root scale and added Mathon 1981 as the primary source.

A fresh design/generalist re-review accepted every mathematical, convention,
hierarchy, and Mathon-boundary repair, but corrected the page locator for
Ball's displayed point-index equations from pp. 29--30 to p. 34. After that
locator repair, a final sealed source gate returned `GO`: Ball p. 34 contains
the compatible moment equations; Ball Theorem 3.1 is used only for the
ordinary-complete-arc comparison; and the text separates Mathon's two-class
completeness, Reichard--Woldar's later constructions, and the manuscript's own
projective-realization test.

Frozen re-review records:

1. `notes/2026-08-09-c900-arcs-geometry-rereview.md` — `GO`.
2. `notes/2026-08-09-c900-arcs-design-rereview.md` — `MINOR`, repaired.
3. `notes/2026-08-09-c900-arcs-design-final-rereview.md` — `MINOR` on the
   Ball page locator only, repaired.
4. `notes/2026-08-09-c900-arcs-citation-final-gate.md` — `GO`.

Round 1 is green for human proofs and exposition. `C900` nevertheless remains
open by user instruction for later review, fix, and sealed re-review rounds.
