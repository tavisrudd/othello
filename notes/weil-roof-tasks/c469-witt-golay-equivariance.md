# C469 — Witt/Golay equivariance bridge

**Context:** explicitly gate-lifted by user after C464's fourth-order closeout. C464 certified the
ternary Golay carrier, the Steiner `4-(11,5,1)` minimum-support design, the selected/residual
`11+55` split, the residual `K_11` edge formula, and the twelve full-support projective words.
C450 independently certified the 11-point sheet action and the 55-element disjoint
relation-support action, with stabilizers `A5` and `A4`. This task decides whether those exact
finite objects form one equivariant bridge.

## Inputs

- C464 atomic bundle (`notes/2026-07-21-c464-perfect-code-spans.*`) — code, support families,
  `K_11` edge map, projective spectrum, and frozen hashes
- C450 atomic bundle — frozen `PSL_2(11)` sheet and cross-relation actions, stabilizers, and
  permutation-module decompositions
- C452/C406 bundles only through C464/C450's pinned conventions unless an explicit anchor must be
  reconstructed

## Task

Construct the frozen `PSL_2(11)` action on C464's ternary code coordinates and projective
codewords. Decide, with literal action tables and explicit anchors, the proposed orbit dictionary:

```text
selected weight-five supports       ~= G/A5              (size 11),
residual weight-five K_11 edges      ~= G/A4              (size 55),
full-support projective codewords    ~= G/(C11:C5)         (size 12).
```

For the 55-orbit, identify or sharply separate C464's residual supports from C450's disjoint
relation-support set. A positive result requires one explicit anchor map, stabilizer equality (or
conjugacy with the exact conjugator), and exhaustive equivariance over generators; equal
cardinalities or matching characters are insufficient. Record how the selected/residual union
realizes the 66 Witt blocks under restriction to the frozen `PSL_2(11)`.

For the twelve full-support projective words, compute the orbit decomposition and stabilizers and
either prove the natural `P^1(F_11)` identification or give a sharp negative. Treat weights 6, 8,
and 9 only as cheap consistency controls; do not expand into a general Golay automorphism census.

Deliver a C464-style atomic bundle: dated report, exact generator/checker, canonical JSON with all
actions, anchors, stabilizers, orbit maps, and dispositions, checksum manifest, and an independent
replay.

## Acceptance gate

- every proposed orbit receives `proved`, `checked-only`, or `dead`, with exact evidence;
- the 55-set bridge has an explicit equivariant bijection or a decisive obstruction;
- the 12-set candidate has an exact orbit/stabilizer disposition;
- all action and input conventions are hash-pinned and independently replayed; and
- paper-facing language distinguishes `PSL_2(11)` equivariance from any larger `M_11`
  automorphism claim.

## Boundaries

- Do not claim the full automorphism group is `M_11` unless it is separately computed and the
  naming/classification boundary is stated. The required theorem is only for the frozen
  `PSL_2(11)` action.
- C465 owns modular/Brauer decomposition and the filtration `C^perp < C < F_3^11`; consume its
  result if available, but do not duplicate it here.
- No manuscript edit, Phase-3 synthesis, or new cross-prime generalization belongs to C469.
- Incidental observations follow the crowns discovery-track discriminator; do not allocate
  further symmetry tasks from numerical coincidences alone.
