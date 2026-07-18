# C294 B4 continuation card: ProjectiveCap sealed-residual interface

**Lane:** `crowns`  
**Selector:** `C294 B4`  
**Status:** prepared; implementation waits on a stable B1/B2 interface  
**Ownership:** crowns theorem specification only; `cap`, `relconic`, and Lean sources are read-only

## Goal

State the exact cross-lane theorem by which the ProjectiveCap relative-complete sealing bridge can
feed a residual game into C294 contextual replacement. Separate this compositional interface from
the distinct `MirrorBoundary` fixed-point/eigenspace obstruction.

## Required cold read

1. `notes/2026-07-17-c294-routing.md`.
2. The current B1 result and B2 report; stop if the boundary object is not stable.
3. `notes/2026-07-12-c100-relative-conic-game-bridge.md`.
4. Before proof development, the named-expert context plus:
   `notes/expert-personas/schaefer-siegel-nodekayles-certificates.md`,
   `notes/expert-personas/violeta-hernandez-palacios-combinatorialgames-lean.md`, and
   `notes/expert-personas/hirschfeld-thas-storme-ball-lavrauw-projective-arcs.md`.

Read `lean/ProjectiveCap/MirrorBoundary.lean` only to delimit the mirror-method comparison. Read
`lean/AGENTS.md` before any Lean action; this card does not itself authorize Lean edits.

## Target factorization

```text
relative-complete seed A outside hole H
  -> every continuation and future legal move remains in A union H
  -> exact residual-game semantics on H
  -> decomposition into boundaried residual pieces
  -> contextual replacement preserves nimber/P-N value.
```

The statement must name reachability assumptions, legality equivalence, gluing admissibility,
normal-play convention, and whether it preserves full nimbers or only P/N outcomes. It must not
infer value from sealing alone.

## Deliverable and gate

Write `notes/2026-07-17-c294-b4-projectivecap-sealed-interface-result.md` with:

- a clean theorem statement and dependency diagram;
- hypotheses supplied by C100 versus new C294 obligations;
- the exact data a ProjectiveCap residual must export;
- the distinction between the sealing bridge and `MirrorBoundary`; and
- a Lean implementation sketch only if the statement has stabilized and the certificate boundary
  is compact.

B4 passes as a crowns-owned specification when no geometry or game-value implication is implicit.
Cross-lane source edits, task re-pegging, and formalization require explicit later authorization.

