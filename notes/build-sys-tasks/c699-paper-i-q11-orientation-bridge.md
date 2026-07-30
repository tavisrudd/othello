# C699 — Paper I q11 orientation bridge

**Lane:** `build-sys`
**Opened:** 2026-07-29
**Status:** queued after C698.

## Objective

Connect the existing q11 certificate package's actual syndrome/support
catalogues to C698's abstract orientation and golden operator.

## Acceptance

- Update the package from its obsolete `finitegeom` pin to the immutable
  C698 revision.
- Define the two continuation orbital matrices and prove
  \((A-A')^2=10(I-R)\).
- Identify the fibre-odd restriction with C698's \(B\), including
  \(B^2=5I\).
- Prove that triangle signs agree with the two q11 support orbits and that
  the syndrome locus reconstructs the switching class.
- Refresh dependency/source manifests, theorem maps, terminal axiom
  audits, and clean-checkout replay.

## Boundaries

Do not copy q11 generated data into `finitegeom`; consume it through the
existing downstream checkers.  Preserve the v1 q11 trust gate.

## Plan

`notes/2026-07-29-c698-c702-paper-i-v2-lean-audit-plan.md`
