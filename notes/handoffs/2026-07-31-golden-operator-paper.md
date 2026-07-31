# Golden operator and shadow sisters paper

**Lane:** `golden`

**Date:** 2026-07-31

## Goal

Build a standalone mathematics paper containing the complete C704--C710
post-700 development around the golden conference operator and the
functorial family of cubic, polar, determinantal, exceptional, symmetry,
fermionic, anomaly, and lattice shadows it generates.

The working title is *The golden conference operator and its shadow
sisters*.  The paper's conceptual claim is that the shadows arise from one
operator through exterior power, golden compression, commutator,
determinant/Pfaffian, adjugation, and centered squaring—not from accidental
formula matches.

## Current state

The source mathematics is proved in the frozen C704--C710 reports.  This
entire propagated-shadow portfolio belongs to Paper IV.  C730 may strengthen
Paper III only through the arithmetic--harmonic provenance of the source
class `([C], [Z_C])`; Paper III still ends before every result below.  In
particular:

- the six outer middle-exterior coordinates are the Joubert coordinates and
  land on the Segre cubic;
- centered squaring is the Segre--Igusa polar map;
- the cross-golden determinant and adjugate give the small-resolution and
  matrix-factorization shadows;
- \(\operatorname{Pf}[D_x,C_T]=4Z_T\) and
  \(\det[D_x,C_T]=16Z_T^2\);
- the balanced phase layer realizes the exceptional outer transform and a
  sharp Slater/Majorana optimum;
- the same amplitudes satisfy the six-Weyl \(U(1)\) anomaly equations.
- the adjugate-polar package reaches the Coble/Burkhardt and \(E_6/E_8\)
  parents with its exact marking boundaries;
- the Clifford and doily packages locate the exceptional outer-action and
  bad-prime refinements;
- the E8--Hamming compatibility fails exactly and is repaired by the
  hyperbolic \(II_{10,10}\) lattice.
- C720's leading connection tests are resolved: the six Majorana matrices
  form a synchronized product of pure-spinor cells rather than one Wick
  parent, while universal maximum-determinant \(K_{3,3}\) frustration is
  equivalent to \(B^2=5I\) and yields exactly the six
  \(A_5/D_5\) shadow fingerprints.
- The six ten-cut sign fingerprints form a distance-six regular simplex in
  the outer augmentation module.  Five-cycle magnitudes certify golden
  membership, three optimal signs identify a sister after certification,
  and the full syndrome corrects two sign-readout errors.
- Transposing the same syndrome gives the ten-vector
  \(\operatorname{ETF}(5,10)\), and
  \(S_{10}=(R^{\mathsf T}R-6I)/2\) is the Petersen/Paley order-ten conference
  operator.  Thus the order-ten boundary example is itself a Naimark--Gram
  shadow of the order-six golden system.
- C720's fully marked forward operator theorem is frozen in
  `notes/2026-07-31-c720-c727-operator-interface.md`.  It fixes the source
  object, formulas, covariance facts, and primary output inventory that C727
  must descend, without prejudging any unlabelled or minimally marked
  recovery claim.
- C720's post-freeze `ej` corollaries settle two marked reverse tests needed
  by C727: the determinant sextic and the independently defined ten-cut
  syndrome both recover the unoriented switching line, and \(W=0\) is
  exactly the ten-node Segre polar base locus.  Descent from Paper I's
  coarsest input and the nonzero polar fibres remain C727's work.
- C720's ej2 coefficient theorem strengthens the reverse result: the
  \((2,2,1,1)\)-coefficients of the determinant sextic are exactly the
  four-cycle holonomies read by relative \(K_{3,3}\) matching signs.  The
  algebraic sextic and dimer fingerprint are canonically equivalent
  orientation-free presentations, documented in
  notes/2026-07-31-c720-ej2-sextic-dimer-equivalence.md.

C720 is complete.  The frozen charter is
notes/2026-07-31-c720-golden-paper-charter.md, and the go verdict is
positive.  The authoritative manuscript root is papers/golden-operator/;
its title, abstract, principal theorem, proof roadmap, isolated build, and
paper-owned verification policy are installed and build without warnings.

The cross-paper framing is now fixed provisionally in
`notes/2026-07-31-golden-cross-paper-framing.md`: Papers I and III supply two
independent provenance theorems for the source class, while Paper IV supplies
forward functorial propagation to its shadows.  C727 first proves the generic
completion/descent theorem and then determines whether the Paper I composite
descends to the unlabelled syndrome locus or requires an additional marking;
no Clebsch manuscript edit is authorized by that investigation.

## Active and queued tasks

| task | state | next gate |
|---|---|---|
| [C727 — cross-paper recovery theorem](../golden-tasks/c727-cross-paper-recovery-theorem.md) | ready; next; marked source and reverse tests frozen | descend the frozen operator interface through every residual torsor and prove the strongest exact recovery--propagation theorem, or its sharp minimal-marking obstruction |
| [C728 — synchronized pure-spinor geometry](../golden-tasks/c728-synchronized-pure-spinor-geometry.md) | queued after C720 | replace the coordinate synchronization by an intrinsic equivariant construction and determine its projected ideal |
| [C729 — higher-order conference-cut designs](../golden-tasks/c729-higher-order-conference-cut-designs.md) | queued after C720; sequel direction | intrinsicize the \(6\to10\) conference lift, classify the 36 extremal order-ten cuts, and test for a functorial tower |
| [C715 — anomaly inverse](../golden-tasks/c715-golden-anomaly-inverse.md) | queued after C720 | prove the rational inverse, exceptional strata, normalization, and postselection cost |
| [C716 — two-\(U(1)\) lines](../golden-tasks/c716-golden-two-u1-lines.md) | queued after C715 | synthesize nonchiral and chiral Fano components and mixed Pfaffian identities |
| [C717 — Majorana parity chambers](../golden-tasks/c717-golden-majorana-parity-chambers.md) | queued after C720; independent of C715 | classify Pfaffian walls, real chambers, simultaneous switches, and monodromy obstruction |
| [C718 — boson--fermion complement](../golden-tasks/c718-golden-boson-fermion-complement.md) | queued after C720; independent of C715 | compute permanent-side identities and seek a new invariant or discriminator |
| [C719 — six-mode demonstrator](../golden-tasks/c719-golden-six-mode-demonstrator.md) | queued after C715 and C718 | produce a platform circuit, coherent-sign readout, and feasibility budget |

## Recommended order

1. C727 cross-paper recovery--propagation audit.
2. C728 intrinsic synchronized-spinor audit.
3. C715 anomaly inverse.
4. C717 and C718, chosen by theorem yield after C715's first gate.
5. C716 only after the inverse interface freezes.
6. C719 after the mathematical paper spine is secure.
7. C729 only as a sequel unless its first theorem feeds back into the
   present paper.

## Ownership and allowed paths

Golden owns:

- `papers/golden-operator/` after C720 admits it;
- `notes/golden-tasks/`;
- this handoff and `notes/2026-07-31-golden-discovery-track.md`;
- Golden task-owned dated reports, exact scripts, certificates, and replay
  files;
- its exact rows in the global queue and allocation ledger.

The C704--C709 reports are read-only source packages from this lane.  The
Clebsch manuscripts, especially review-facing Paper III, are outside the
Golden write surface and remain unchanged.  Golden cites any shared
background, imports only frozen theorem interfaces from the dated reports,
and owns all new paper prose, proofs, and strengthenings.  It does not
extract, relocate, or reorganize Paper III content.  C720 may discuss a
future post-review relocation of overlapping exposition, but any such edit
requires a later explicit decision.

## Paper boundary

Every C704--C710 mathematical conclusion must receive an explicit main-body,
appendix, or evidence-supplement placement in C720.  None returns to Paper
III and none is silently assigned to an unallocated sibling paper.  Physics
appears only where it is a literal operator theorem, and anomaly arithmetic
does not become a gauge-theory claim.

The companion discovery log is
`notes/2026-07-31-golden-discovery-track.md`.
