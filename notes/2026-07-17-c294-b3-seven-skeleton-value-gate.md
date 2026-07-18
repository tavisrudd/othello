# C294 B3 continuation card: seven-skeleton value gate

**Lane:** `crowns`  
**Selector:** `C294 B3`  
**Status:** active; exact two-port semantics passes its first compression gate, so bounded live
integration is next
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

## First attempt result

`notes/2026-07-17-c294-b3-seven-skeleton-value.md` proves the exact sparse absolute-two-core/B1-
interface quotient and records its independently checked first merger. The quotient has 2,998,831
high-core different-mask cache-hit events by the fixed ten-million connected-state gate, but it
stops at an unseen 30-vertex quotient node without returning the type-0 follower nimber. Thus the
boundary quotient genuinely merges states but does not close the first value; B3 remains active
and the other six types remain unrun.

Do not repeat this run or raise its cap. The next bounded design question is whether exact
isomorphism canonicalization of the high two-core together with B1 attachment labels produces
material additional mergers on the already tracked 100,000-state prefix. Require a measured
compression gate before implementing another value solver.

## High-core isomorphism result

`notes/2026-07-17-c294-b3-high-core-isomorphism.md` answers that design question positively at the
targeted layer. On the unchanged q=5 type-0 100,000-state traversal, 11,031 completed absolute
high-core classes collapse to 10,088 exact labelled-core isomorphism classes: 943 classes, or
8.55%, are removed with zero nimber conflicts. The independently replayed first merger has two
32-vertex residuals, isomorphic 23-vertex labelled cores, and direct nimber 1 on both sides.

The live quotient serves 693 new-absolute-key hits and reduces high-key requests by 5.66%, but
reduces decompositions by only 0.249%, still spends 100,000 connected states, and stops at the same
24-vertex frontier without a value. It therefore fails the material live gate. Do not run it at
ten million states. The next bounded diagnostic is a census of repeated pieces behind one- and
two-vertex separators in the canonical high cores; require substantial reuse before designing a
two-port boundary algebra.

## Separator-census result

`notes/2026-07-17-c294-b3-separator-census.md` passes that bounded diagnostic. Among genuine
two-port pieces with at least eight internal vertices, 61,220 exact classes recur across distinct
canonical high cores and cover 976,693 of 1,313,230 occurrences (`74.37%`); reused pieces reach 29
vertices. An independently organized replay verifies the first nontrivial cross-core one- and
two-port witnesses. The unchanged traversal reproduces every predecessor invariant and still
returns no value.

## Two-port transition result

`notes/2026-07-17-c294-b3-two-port-transition.md` defines an exact live/dead transition DAG and
proves its local replacement theorem for arbitrary finite two-port contexts. The q=3 control
processes all 47 meaningful exact piece classes with no mergers or conflicts. On the fixed q=5
prefix, the independent one-million combined interface-state cap processes 37,726 of 350,951
classes: 37,690 transition classes, 36 genuine mergers, and zero value conflicts. An independent
replay verifies that the first merger consists of non-isomorphic 16-vertex pieces with nimber `2`
and equal complete transition records.

The interface cap stops on the next 14-core-vertex piece, so this is not a complete-prefix quotient
or a follower value. The next bounded step is live integration on the unchanged 100,000-state q=5
prefix. Require a measured reduction in decompositions or materially reusable interface hits before
any ten-million-state run; compute transition nodes only for pieces requested by the live
decomposition.
