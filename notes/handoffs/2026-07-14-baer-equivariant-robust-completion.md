# Handoff: Baer-equivariant robust completion

**Date:** 2026-07-14
**Status:** ACTIVE — C99 uniform order-five theorem closed; C133 is next
**Tasks:** C133

## Active-lane lock

This is the active sticky lane. Until the user explicitly switches lanes or this handoff is marked
finished, `go` and `next?` refer only to the next step recorded here. Recent commits and global-queue
priorities from other papers do not change that routing.

### Allowed paths

- `lean/FiniteGeom/BaerCompletion/`
- the Baer/Frobenius/Q25 modules under `lean/RelativeConicArcs/`, their aggregate, and their trust
  manifests
- `notes/2026-07-13-c99-*`
- `notes/2026-07-12-riffing-on-applications/paper-baer-equivariant-robust-completion.md`
- `notes/2026-07-12-riffing-on-applications/baer-completion-adversarial-review.md`
- `notes/2026-07-13-baer-completion-adversarial-novelty-review.md`
- `papers/baer-equivariant-extension/`, `papers/equivariant-robust-completion/`, and the associated
  rows in `papers/papers-index.md`
- this handoff, its future companion archive, and the C133 registry row in the global queue

### Foreign lanes

The Clebsch-hexagon/Q11 icosahedral paper, relative-conic coding strengthening, twisted-cubic and
RepairCodes papers, unrelated ProjectiveCap/Nofil tasks, and Queens/Othello work are out of scope.
Their commits and working-tree changes may be reported as foreign state but must not be reviewed,
edited, staged, or selected by `next?` without an explicit lane switch.

## Landed result

C99 proves that every Frobenius-invariant eight-arc in `PG(2,25)` admits a fresh conjugate-pair
extension. The exceptional profiles `f=0,2,4` and the strict-count profiles `f=6,8` are all
kernel-checked; the public uniform theorem is `Q25AllProfiles.pair_extension`. The 469,600 normalized
arc census and observed minimum legal-pair count 32 remain external computational evidence and are
not assumptions of the theorem.

Source of truth:

- [`2026-07-13-c99-baer-collision-strengthening.md`](../2026-07-13-c99-baer-collision-strengthening.md)
- [`paper-baer-equivariant-robust-completion.md`](../2026-07-12-riffing-on-applications/paper-baer-equivariant-robust-completion.md)
- [`2026-07-13-baer-completion-adversarial-novelty-review.md`](../2026-07-13-baer-completion-adversarial-novelty-review.md)

## Current next task — C133

Hostilely review residual ledger claim C99.6:

> A cross-pair secant orbit is invisible on at least `s+3-f-e` empty fixed carriers.

The generic center-on-carrier equivalence and center-capacity reduction are checked, while the
profile-independent occupied-line bound is not. Do not assume the proposed inequality is true.

### Attack order

1. Reconstruct the exact hypotheses and natural-number side conditions from
   `QuadraticInvisible.lean` and the C99 proof ledger.
2. Test boundary profiles and incidence configurations for a counterexample or a missing
   hypothesis; distinguish the proved `(f,e)=(4,2)` specialization from the generic claim.
3. If valid and useful, load the named-expert context, formalize it certificate-free, and run a
   scoped build plus forbidden-token and axiom audits.
4. If false or overstated, state the sharp valid replacement or remove it from the claim ledger.
5. Synchronize only the allowed Baer paper, trust, ledger, queue, and index files.

### Completion gate

- C99.6 has exactly one final disposition: proved generically, proved under explicit narrower
  hypotheses, or rejected with a concrete obstruction.
- No partially proved generic wording remains in the closed C99 ledger.
- Any Lean theorem has a passing scoped build, accepted axiom profile, and no prohibited proof
  escapes.
- The external census/minimum remain separate unless the user explicitly chooses to promote and
  certify those stronger data claims.

## Following gates

1. Broaden the priority search for the exact uniform `PG(2,25)` theorem before making a historical
   novelty claim.
2. Keep the census/minimum computational by default; certify them only if publication needs them.
3. After C133 and the priority gate, allocate a separate task for a structural inverse/equality
   theorem near saturation of `L + E M = E N + B + R`.
