# C728 — Intrinsic synchronized pure-spinor geometry

**Lane:** `golden`

**Status:** queued after C720

## Objective

Replace the coordinate description of the six synchronized Majorana
principal-Pfaffian systems by an intrinsic equivariant construction, or prove
the sharp obstruction to such a construction.  Determine exactly how the
Segre cubic arises from the common five-parameter slice without claiming that
Wick identities alone force it.

## Gates

1. Define the map from the augmentation module to the product of six
   half-spin big cells
   \[
   V_5\longrightarrow\prod_{T=1}^6\operatorname{OG}^{+}(6,12),
   \qquad x\longmapsto\bigl(\operatorname{Pf}(A_T(x)_S)\bigr)_{T,S},
   \]
   with its exact inner and outer symmetry actions.
2. Compute the relevant equivariant Hom-space multiplicities and decide
   whether the synchronized slice is unique up to scale or marking.
3. Determine the scheme-theoretic image and elimination ideal of its six top
   Pfaffians.  Prove whether the Segre linear and cubic equations generate the
   projected ideal, including exceptional and nonreduced strata.
4. Seek a homogeneous-space, vector-bundle, Clifford, or universal-isotropic
   interpretation that produces all six cells functorially from the marked
   golden operator.
   Compare it with the C720 partial isometry
   \(R^{\mathsf T}/\sqrt{12}:V_5\to E_{+3}(S_{10})\) and determine whether both maps are
   manifestations of one equivariant universal construction.
5. Run a focused pure-spinor/matchgate literature audit and separate the
   classical Wick geometry from any new golden synchronization theorem.
6. Give a human structural proof; exact elimination may verify conventions
   but may not carry the conceptual claim.

## Acceptance

- An intrinsic construction with a commuting equivariant diagram, or a sharp
  representation-theoretic nonexistence theorem.
- The exact projected ideal and its relation to the Segre cubic.
- Manuscript-safe novelty and boundary language.

## Boundary

Six independent pure spinors have arbitrary top Pfaffians.  This task may not
describe the Segre equation as a consequence of Wick identities without the
golden synchronization hypotheses.

## Dependencies

C720 freezes the operator and paper interface.  C709 and the C720
spinor/dimer report supply the read-only principal-Pfaffian construction and
the negative naive-parent test.
