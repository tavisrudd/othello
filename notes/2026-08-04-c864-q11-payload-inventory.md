# C864 — order-eleven payload inventory

**Date:** 2026-08-04
**Lane:** `build-sys`
**Purpose:** the source-side boundary for externalizing the order-eleven certificate families, so a
later session can move payload without deciding what it is while moving it. No file was moved and
no package was created.

## Totals

The monorepo carries 143 order-eleven modules under `lean/RelativeConicArcs/`, 345 KB of source.
Ten of them are reached from outside the order-eleven family; the other 133, holding 240 KB, are
reached only from within it. Of all 143, 132 either declare themselves generated or raise the
heartbeat and recursion limits.

## The external API surface — what must stay human-scale

These ten modules are imported by something outside the order-eleven family, so each one is either
a genuine semantic interface or an interface that currently leaks payload. The consumers named are
the modules or gates that import them.

| module | size | limits raised | consumed by |
|---|---|---|---|
| `Q11Coding` | 14 KB | yes | library root, Clebsch gateway extension, repo-health gate, rigidity gate |
| `Q11Residual` | 13 KB | yes | library root, Clebsch gateway conic, repo-health gate |
| `Q11A5PointOrbits` | 27 KB | yes | rigidity gate |
| `Q11DecodingSynthesis` | 13 KB | yes | reflection-arrangement decoding, rigidity gate |
| `Q11BrianchonPetersen` | 12 KB | yes | reflection arrangements |
| `Q11CodeRigidityBridge` | 13 KB | no | rigidity gate |
| `Q11DyeConsequences` | 2 KB | no | degenerate-conic exclusion, rigidity gate |
| `Q11DyeAxioms` | 3 KB | no | six-arc defect bridge |
| `Q11RigiditySpine` | 1 KB | no | rigidity gate |
| `Q11NonGRS` | 1 KB | no | results umbrella |

The five modules with raised limits are the ones needing a semantic/payload split before anything
moves: each is an interface that also performs exhaustive work in place. The five without raised
limits are already interface-shaped and should stay in the monorepo unchanged.

## The payload families — what should move

Everything below is reached only from inside the order-eleven family.

**Point-orbit rows.** 60 generated row leaves under 72 row aggregators, about 660 KB counting the
aggregators, each leaf an exhaustive per-row theorem about the alternating-group action with the
heartbeat limit at a hundred million and recursion depth at a hundred thousand. This is the single
largest elaboration cost in the family and the clearest package candidate. Its satellites — twelve
matrix modules, twelve support modules, seven fixed-point modules — belong with it.

**Semantic presentation family.** Twenty modules of exhaustive per-point presentation theorems over
the 133 points, entered through `Q11SemanticBase`. Small in bytes, expensive to elaborate.

**Remaining generated data.** The affine-slice directory and the other per-case data modules in the
family follow the same rule: generated leaves and enumerated tables move, definitions and reusable
lemmas stay.

## Decisions this inventory does not make

- Whether the point-orbit rows form their own official package or join the other Clebsch q11
  certificates.
- Where the split line falls inside each of the five mixed interface modules; a proposal is in
  `notes/2026-08-04-c864-q11-interface-split-lines.md`.
- The disposition of `Q11Residual`, which is entangled with the base-library export defect and its
  game half; that repair is described in the task card.

## Method

Module classification is by two mechanical signals — reachability from outside the order-eleven
family, and whether a module raises elaboration limits or declares itself generated — plus the
family naming of row, data, leaf and table modules. Sizes are source bytes. The signals are
evidence for the boundary, not a substitute for reading each mixed module before it is split.
