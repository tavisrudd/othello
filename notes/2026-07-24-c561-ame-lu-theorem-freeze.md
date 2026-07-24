# C561 — AME LU-rigidity paper theorem and architecture freeze

**Lane:** `ame-lu`

**Date:** 2026-07-24

**Status:** complete; title, theorem hierarchy, boundaries, and section order
frozen

## Frozen title

*Local-Unitary Rigidity and Clifford Geometry of Six-Qudit AME Stabilizer
Tensors*

The title names the headline theorem and keeps the stabilizer boundary
visible.  “AME tensors” alone would suggest arbitrary minimal-support AME
states, which C560 does not classify.

## Frozen theorem spine

The paper has one main theorem and one classification corollary.

1. **LU-intertwiner rigidity.**  For every prime power `q`, every
   local-unitary intertwiner between equal-phase CSS states arising from
   linear `[6,3,4]_q` MDS codes is local Clifford.  The proof uses MDS
   shortening and the intrinsic rank-one contraction axes of a four-party
   diagonal Weyl correlation tensor.  Two four-party marginals covering the
   six parties suffice.
2. **Complete pencil classification.**  On C396's admitted odd non-GRS
   pencil, projective arc equivalence, monomial code equivalence, LC
   equivalence, LU equivalence, and equality of `z` coincide.

The remaining results are subordinate:

- the `SL_2(q)` versus split-torus logical-Clifford phase supplies the
  operational consequence;
- the H3 marginal moment and q=13 four-copy contraction are short explicit
  LU certificates and examples;
- fixed-copy generic constancy explains why scalar contractions cannot
  prove the main theorem; and
- the transport sheaf explains the exceptional divisor of the q=13
  certificate, not an exception to LU/LC rigidity.

## Frozen boundary rules

The all-MDS/CSS rigidity theorem is characteristic-uniform over prime powers.
The `z` corollary retains C396's odd admitted domain and every one of its
excluded factors.  The H3 theorem retains its good-reduction and non-GRS
hypotheses.  Characteristics 7, 11, 13, and 41 affect C548/C550's scalar
detector scheme or ramification; they do not affect C560.  Characteristic
five is the H3-to-GRS transition, not a failure of rigidity.

The manuscript makes no claim about nonlinear orthogonal arrays, arbitrary
minimal-support AME tensors, non-MDS stabilizer states, a global LU--LC
conjecture, global minimality of four-copy invariants, or holographic-code
performance.

The synchronized full boundary table now lives in
`papers/ame_lu/theorem-map.md`.

## Frozen section order

1. Introduction and title-page theorem.
2. Six-arcs, MDS kernels, CSS stabilizers, and AME conventions.
3. Four-party diagonal Weyl tensors and LU-intertwiner rigidity.
4. Complete `z`-classification of the admitted non-GRS pencil.
5. Logical-Clifford phase and encoder-view consequences.
6. Marginal and copy-contraction LU certificates, including fixed-copy
   generic constancy.
7. Transport sheaf, rank-jump divisor, and orbit multiplicities.
8. Verification, literature, formalization, and scope boundaries.

This order proves the qualitative theorem before presenting scalar
certificates.  It prevents the q=13 calculation from appearing to carry the
classification and prevents the divisor from being mistaken for an orbit
boundary.

## Control-file synchronization

The following files now agree on the frozen package:

- `papers/ame_lu/README.md`;
- `papers/ame_lu/main.tex`;
- `papers/ame_lu/theorem-map.md`;
- `papers/ame_lu/claim-proof-novelty-ledger.md`;
- `papers/ame_lu/verification-map.md`;
- `papers/ame_lu/formalization-ledger.md`;
- `papers/ame_lu/adversarial-proof-evidence-audit.md`;
- `papers/ame_lu/second-draft-fix-plan.md`; and
- `papers/ame_lu/sections/README.md`.

The manuscript scaffold builds without warnings after the section reorder.
C562 may now audit the exact frozen claims; C563 may import only computations
that survive this hierarchy.

## `ej` and Tao closeout

The free upgrade is a severe paper spine: the main proof needs only the
four-party reduced operator and an elementary diagonal-tensor lemma.  The
projective pencil and its scalar `z` become a classification application,
which makes the paper accessible from either quantum information or finite
geometry.

The title was stress-tested against the largest likely misreading.  Adding
“stabilizer” is necessary: without it, the title would overstate the theorem
to nonlinear and general minimal-support AME tensors.

The exact exception hierarchy is now rhetorical as well as mathematical:
C560 has no exceptional characteristic, C396 owns the admitted odd pencil,
and C548/C550 own only detector degeneracies.  These three layers must not be
merged in the abstract or introduction.

## Mystery ledger

| Feature | Disposition |
|---|---|
| Which result leads the paper | **Settled:** all-MDS/CSS LU-intertwiner rigidity. |
| Whether the title may say only “AME tensors” | **Settled negatively:** “stabilizer” is required. |
| Whether the q=13 scalar or divisor carries classification | **Settled negatively:** both are subordinate certificates/mechanisms. |
| Whether characteristic 7 is a rigidity exception | **Settled negatively:** it is only a detector-scheme merger. |
| Whether the frozen claims are new relative to the literature | **Open evidence gate; C562 owns it.** |
| Whether every adopted computation has a public paper-local replay | **Open evidence gate; C563 owns it.** |

No C561 architecture mystery remains.

## Vibe check

Excellent.  C560 turned a collection of exact invariants into a paper with a
single memorable theorem, and the frozen order now makes the proof mechanism
visible before the exceptional arithmetic.
