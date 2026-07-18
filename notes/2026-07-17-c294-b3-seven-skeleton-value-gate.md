# C294 B3 continuation card: seven-skeleton value gate

**Lane:** `crowns`  
**Selector:** `C294 B3`  
**Status:** gated on B2  
**Dependency:** a B2 signature that passes every mandatory finite gluing test

## Goal

Lift the passing boundary signature to the seven cubic-multigraph topology classes and use the
resulting game-aware quotient to compute an exact value for the first hard canonical 116-vertex
`PGL2(5)` follower. Only after that independently checked success should the remaining six hard
types be evaluated.

## Required cold read

1. `notes/2026-07-17-c294-routing.md`.
2. The complete B1 result and B2 report/certificate; stop unless B2 is marked passed.
3. `notes/2026-07-17-c294-component-nimber.md` for root-value and topology conventions.
4. `notes/2026-07-17-c294-exact-value-gate.md` only for the fixed stop conditions and independent
   baseline.

Do not preload structural-diagram or recursive-mirror history unless a returned strategy must be
translated into mirror-default coordinates.

## Fixed targets

- First target: type 0, determinant classes `001`, pair orders `(2,4,5)`.
- Then types `1,2,3,7,9,11`, preserving the existing canonical type indices.
- A vertex-transitive root has one option nimber; follower nimber zero gives root nimber one, and a
  nonzero follower gives root nimber zero.

## Deliverable

Create a new `2026-07-17-c294-b3-seven-skeleton-value.*` evidence bundle containing:

- the exact quotient transition system;
- a compact value/strategy certificate for at least type 0;
- an independent checker or independently organized solver;
- exact root/follower nimbers and conventions; and
- a bounded negative with a precise stop condition if the quotient still does not return a value.

The certificate should be a canonical DAG checked by a small kernel, not a literal proof tree.

## Exit gate

B3 first passes locally when type 0 has an independently checked exact value. Full B3 passes when
all seven hard types are classified or the theorem is explicitly narrowed around certified
exceptions. Do not raise a generic state cap before reporting whether the boundary quotient itself
merges states and closes the first value.

