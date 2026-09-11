# C1133 — hypothesis naturalness and input economy

**Lane:** `cubic-threefolds`. **Date:** 2026-09-10.
**Question:** are A–D's hypotheses natural, do they conceal the conclusion,
and can the input burden be reduced?
**Later same-day resolution:** the candidate below is now proved and
independently reviewed in `2026-09-10-c1133-transport-input-reduction.md`
and `2026-09-10-c1133-hostile-referee.md`. Core A–D can remove the general
projective-bundle input. The pending language below records the earlier
design review; it is not the current frontier.
**Disposition:** dependency/proof-design review, not a new certification of
the combined argument. Existing mathematical acceptance remains at its
recorded written-audit boundary. No new theorem or formal coverage is promoted.

## Separate scope from proof obligations

The public scope restrictions are conventional and geometrically motivated:
smooth projective complex threefolds, Picard rank one, the named Fano families,
very-general source in C, and a fixed finitely generated characteristic-zero
field with bounded extension degree in D. They determine where the inputs
apply. They are not assumptions that a desired invariant is already birational.

The coefficient-domain, faithful-map and lattice-preservation assertions are
different. They are substantial internal proof obligations. The final A–D
statements should not ask the reader to assume these properties hold for the
actual varieties while presenting the result as unconditional. An abstract
comparison lemma may assume them; its geometric application must establish
every one from the actual construction. The notes attempt those proofs;
the literature audit alone does not independently certify them.

## Where smuggling could occur

| Potential shortcut | Required replacement in the written argument |
|---|---|
| A map is injective before restriction, so it is injective on the Hodge-fixed base | Direct reduced-ring injection using surviving independent divisor characters; fixed-base note's finite-degree/Vandermonde argument |
| A formal connection isomorphism automatically preserves the chosen lattice | The comparison and inverse must be regular on the original z-lattices; then show they carry the canonical modification and residue |
| A generic block persists through any specialization | Separate the cluster and work on the specified formal germ; cyclic persistence and residue Lax transport must apply there |
| An even matrix identifies the odd Hodge representation | Use the full Frobenius superalgebra; whole-primary selection precedes extraction of odd cohomology |
| Surface vanishing follows from the fourfold birational invariant being constructed | Prove nef-surface, curve and point cases first, then ruled surfaces and point blowups; telescope afterward |
| A rational Hodge isomorphism preserves the principal polarization | Do not infer this. D separately uses polarization finiteness; C uses the precise rational Torelli source |

The audited route explicitly rejects these shortcuts. That is evidence of a
noncircular design, not a substitute for checking the claimed source-to-ring
identifications. Highest-value scrutiny remains the actual occurrence-map
domains, regular inverse and common comparison field across the operation.

No global nonresonance assumption is needed: the rank-two argument includes
the resonant discriminant-one cases. No Gamma-conjecture, Stokes/Orlov lift,
full higher-rank logarithmic-lattice theorem, or arbitrary-specialization R/T
rule is required by this route. The proof does not need all Hodge classes
to be algebraic: the divisors used to separate numerical curve classes are
algebraic, while the fixed-base action on full cohomology is handled separately.

## Input reductions available now

1. **Separate A from B.** A uses numerical selectors; it need not carry the
   rational Hodge-group/descent machinery of B–D. B is not a proof of A:
   its two endpoints are restricted to the nine detected families, excluding
   projective space as a comparison target.
2. **Use one Hodge transport proof.** Equivariance, fixed-base restriction and
   full-fiber cancellation belong in one B proof. C and D should cite B,
   not repeat or enlarge the quantum input package.
3. **Keep the short D route.** Corrected Orr plus finite kernels plus
   Narasimhan–Nori plus Torelli suffices after constructing arithmetic
   intermediate Jacobians. The fourth-power polarized-isogeny argument is
   a cross-check, not another required input. No effective bound, twist
   finiteness, or polarization-preserving initial isogeny is needed.
4. **Restrict operation generality to what is used.** The core only needs
   stabilization by P¹, ruled-surface vanishing, and blowups with centers
   of dimension at most two in ambient dimension at most four. A full
   theorem for arbitrary projective bundles is stronger than those uses.
   This reduces the statement burden; it does not by itself replace its proof.

The pencil companion, categorical-base-loci theorem, old in-preparation
splitting source, optional rank-three residue theory and motive refinements
are not additional core premises. Their limitations stay separately recorded.

## Candidate reduction: remove general projective-bundle comparison

There is a plausible narrower route: derive the needed P¹-product formula
directly, and reduce ruled surfaces birationally to C×P¹ using point blowups.
This could avoid the general Iritani–Koto reconstruction/equivariance argument.
It is **not established by this review**.

The trap is that a small quantum Künneth computation, or a formula on the
factorwise bulk locus, is not automatically a formula for the generic
invariant on the full mixed-bulk base. The product locus can be a
nonfaithful specialization. A replacement proof must show persistence,
lattice control and full Hodge-representation transport in those transverse
directions, including curves used for ruled-surface vanishing. In particular,
a zero centered operator at an elliptic-curve factor is not covered simply
by invoking the cyclic-nilpotent lemma at that point.

Therefore do not remove Iritani–Koto from the current dependency graph yet.
The honest simplification now is restricting its needed cases and isolating
the exact replacement lemma. Merely quoting a product D-module theorem
would exchange one major input for another unless its coefficient and
lattice conventions were checked.

## Evidence and read boundary

This review reread the complete fixed-base proof and transport/vanishing
audit, the A–D acceptance map, the arithmetic deduction and the packet's
family/product passages. The relevant expert routing dossier was consulted
for proof-design pitfalls; its historical higher-stabilization target is
not an input or a task to resume.

External sources retain their registered depths: Iritani blowups and
Iritani–Koto projective bundles, partial primary reads; the source landing
pages were also checked. Gyenge's `arXiv:2509.07407v1` remains partial:
extracted lines 1–170 reread, including Theorems 1.1–1.2 and the stated
formal-base-change scope. It is not adopted as a replacement proof.
No new paper fetch, literature-negative claim or source-count change.

## EJ + TT and Mystery ledger

The bounded dependency review is complete. EJ + TT asked which assumptions
are theorem scope, which are proved internal structure, and which inputs
were included only because a stronger theorem was available.

- **Settled:** the short A/B/C/D dependency separation and removal of D's
  fourth-power cross-check from the required chain.
- **Settled:** no blanket “natural, therefore harmless” certificate is
  justified for faithful transport or lattice preservation.
- **Open:** a replacement P¹-product argument with full mixed-bulk control;
  exact cases and the elliptic noncyclic issue are stated above.
- **Next highest value:** inspect the actual geometric comparison maps
  against the reduced-ring and regular-inverse claims. This matters more
  than reducing a bibliography count.

No computational or Lean result changed. The task card and handoff point
here for the user's requested scrutiny. The current core acceptance is not
silently upgraded to an independent referee verdict.
