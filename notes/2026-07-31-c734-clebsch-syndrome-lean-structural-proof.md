# C734 — Clebsch syndrome formalization and structural proof pass

**Date:** 2026-07-31
**Lane:** `ame-lu`
**Status:** complete

## Outcome

The quantum content added with the Clebsch extremal-syndrome example is now
formalized at its natural level of generality.  The new kernel-checked module
`RelativeConicArcs.AMELU.SyndromeGeometry` proves for every exact six-arc
kernel that:

- tensor-Weyl translation of an equal-phase code state is the affine-coset
  state;
- two translated states agree exactly for labels in the same code coset, and
  distinct cosets are orthogonal;
- every dual-code phase stabilizer acts on a translated state by the additive
  character obtained from its pairing with the translation label;
- restriction of the parity-check syndrome map to any three-party support is
  bijective;
- every syndrome therefore has a unique representative on each three-party
  support; and
- if its minimum representative weight is three, that representative uses all
  three coordinates.

The aggregate gate and axiom audit import seven public terminals for these
claims.  Each reports only `propext`, `Classical.choice`, and `Quot.sound`.
No Clebsch table, generated certificate, native evaluation, project-specific
axiom, or admitted declaration enters the proof.

## Structural human proof

Section 5 now states the reusable result first as
`lem:coset-syndrome-charts`.  Its proof has two visible ideas.  Translation
replaces the linear support by an affine coset, so equality, orthogonality, and
the stabilizer character are immediate from coset geometry.  On a chosen
three-party set, the corresponding three columns of the parity-check matrix
are invertible, so that set is a coordinate chart for the syndrome space.
Minimum weight three then says exactly that none of the three chart
coordinates vanishes.

The Clebsch proposition is consequently a short composition of this lemma,
the companion Clebsch theorem supplying the conic, 120-count, and monomial
orbit, and the AME--LU logical-phase theorem supplying the split torus.  The
following operator-pushing paragraph now separates its ten-element fibre
from the proposition's twenty three-support charts instead of leaving the
reader to reconcile the two counts.

The theorem map, claim/proof/novelty ledger, verification map, formalization
ledger, formal-statement adequacy table, and adversarial audit all record the
same division of labor.  The companion theorem and the concrete q=11 party
row retain their previous external evidence boundaries.

## Validation

- warning-free guarded elaboration of `SyndromeGeometry`;
- managed aggregate build of `SyndromeGeometry`, `AMELUAggregate`, and
  `AMELUAggregateAxioms`, including exact no-build traces and the final
  aggregate gate;
- aggregate axiom audit of all seven new terminals;
- warning-free 31-page manuscript build, 249,346 bytes, SHA-256
  `67b048b39a1b6de8234f7b1314c0ec7d77cb83051a019f37d133e9d367b03772`;
- visual inspection of pages 19--20, with the structural lemma, Clebsch
  proposition, and boundary remark all readable and free of overflow; and
- complete eight-bundle evidence replay and release verification of 37 public
  artifacts with tree
  `e79726f247417947e05cce97c3c9020bfe413dd3012abcc956971224c19f1216`
  and 84 formal-companion artifacts with tree
  `271ac415cd5717fc5e4b791b695cbf3a25e0855683dd249a85c0df8898e0f44d`;
  and
- standalone forward commit `93e8651`, with a warning-free build, complete
  eight-bundle replay, and the same 37-artifact public tree.  Its verifier
  records the 84-artifact formal companion and correctly reports it absent
  from the paper-only repository; the authoritative repository owns the
  formal-required gate.

## Extra-juice and Tao closeout

The cheap strengthening was to formalize the support-by-support theorem, not
only the aggregate multiplicity twenty.  It explains the count: every
three-column minor is a syndrome chart, and minimum weight forces its unique
coordinate vector into the dense torus of that chart.  This also makes the
balanced-cut corollary immediate, because both halves of every `3|3` cut are
charts for the same syndrome.

The structural question exposed by this proof is whether the twenty chart
coordinates, as the support varies, carry useful transition data beyond the
unlabelled syndrome conic.  The present theorem gives the atlas but does not
identify a new invariant of its transition maps.  That question is distinct
from the fixed-input operator-pushing fibre of size ten and from every Golden
operator reconstruction.

## Mystery ledger

- **Settled — why the multiplicity is twenty.**  It is one representative on
  each of the twenty three-party supports, because every three-column
  parity-check minor is invertible.
- **Settled — why every representative has weight three.**  A zero chart
  coordinate would give a representative of weight at most two, contradicting
  extremality.
- **Settled — ten pushes versus twenty syndrome representatives.**  The first
  fixes an input Pauli and ranges over ten output triples; the second fixes a
  syndrome and ranges over all twenty three-subsets.
- **Open — transition geometry of the twenty syndrome charts.**  No computed
  or proved invariant of those chart transitions is needed by this task.  A
  successor would require a precise invariant that uses the marked supports
  and survives the monomial action; the bare conic cannot supply it.

## Vibe check

Strong closure.  The example no longer rests on an informal dictionary step:
its reusable mechanism is both a two-paragraph human proof and a
kernel-checked theorem family, while the genuinely Clebsch-specific data keep
their honest external boundary.

## Post-closeout cold read

An independent manuscript-only reader returned `GO WITH FIXES` with no
correctness or scope blocker.  The two local findings are now repaired:
Section 8 names the companion Clebsch theorem as the source of the conic,
120-count, and monomial orbit, and Section 5 explicitly distinguishes the
syndrome-scaling `C_10`, its projective `A_5` quotient, and the larger realized
`S_5` party image.  The warning-free build, visual inspection of pages 19 and
22, and authoritative 37-public/84-formal manifest verification passed.
