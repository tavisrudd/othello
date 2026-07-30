# C701 — q13 tangent-code certificates

**Lane:** `build-sys`
**Opened:** 2026-07-29
**Status:** queued after C700.

## Objective

Create the downstream `finitegeom-clebsch-q13-certificates` package and
certify the complete Paper I q13 tangent-code theorem.

## Acceptance

- Use a fresh history and exact one-way pin to the final C700
  `finitegeom` revision.
- Certify the 78-point/line incidence structure and rank/dimension 36.
- Certify tangent-graph clique classification, both weight-ten profile
  exclusions, and an explicit weight-twelve witness, proving distance 12.
- Certify all 364 minimum words, their four 91-element
  \(\operatorname{PGL}(2,13)\) orbits, and rank 36 for each orbit.
- Certify the concurrence scheme, recovery of all 78 incidence rows from
  each minimum layer, and full automorphism group
  \(\operatorname{PGL}(2,13)\) of order 2184.
- Shard data by mathematical family with an exact consuming checker and
  provenance record for every shard.
- Avoid raw enumeration of the 6,531,840 and 166,561,920 profile spaces;
  prove and use meet-in-the-middle reductions.
- Add aggregate q13 terminals, manifests, exact axiom audit, reproducible
  generator check, and clean-checkout replay.

## Boundaries

No generated q13 data enters `finitegeom`.  Any use of native evaluation
must be explicit in the trust declaration and separately audited.

## Plan

`notes/2026-07-29-c698-c702-paper-i-v2-lean-audit-plan.md`
