# Named-expert context package for Lean proof work

Purpose: replace generic "personas" with named-expert lenses we can load before
working on the sum-free, projective cap, and queens proof projects. Each dossier
separates cited work from the tactics we want to emulate.

This is not a hiring or attribution note. It is a reusable context guide for
making better proof-design choices in Lean.

## Updated persona map

| Persona | Named experts | Best use |
| --- | --- | --- |
| Lean CGT maintainer | Violeta Hernandez Palacios | Bridging our finite `Win` recursions to a standard normal-play impartial-game API and avoiding ad hoc game semantics. |
| Finite group game theorist | Dana C. Ernst, Nandor Sieben, Bret Benesh | Sum-free game: convert algebraic constraints into impartial achievement/avoidance game state diagrams and nim-value-compatible quotients. |
| Mirror-strategy skeptic | Stephan D. Andres, Melissa Huggan, Fionn Mc Inerney, Richard J. Nowakowski; J. Robert Johnson, Imre Leader, Mark Walters | Sum-free and q-even projective arguments: use involutions when the hypotheses are explicit, and stop using them when the exceptions are not encoded. |
| Mathlib projective geometer | Adam Topaz, Michael Blyth, Edison/Yunzhou Xie, Bhavik Mehta, Judith Ludwig, Christian Merten | ProjectiveCap: express points, lines, collinearity, and finite cardinality through mathlib projectivization instead of bespoke coordinates when possible. |
| Finite projective arcs specialist | J. W. P. Hirschfeld, J. A. Thas, Leo Storme, Simeon Ball, Michel Lavrauw | ProjectiveCap odd planes: use frames, conics, secants/tangents, arcs/caps, and finite-field cases; keep game value distinct from static arc containment. |
| Computational complete-arc searcher | A. A. Davydov, G. Faina, Daniele Bartoli, Stefano Marcugini, Fernanda Pambianco | ProjectiveCap q=23+ work: canonical classes, certificate-first search, early stopping, randomized/greedy search only as evidence generation. |
| Formal cap-set methodologist | Sander R. Dahmen, Johannes Holzl, Robert Y. Lewis; Ellenberg and Gijswijt | Affine cap-set definitions and bounds: follow formalization-friendly algebra, but do not confuse cap-size bounds with game outcome proofs. |
| Graph-game certificate engineer | Thomas J. Schaefer, Aaron N. Siegel, Berlekamp-Conway-Guy | Queens/NodeKayles: prove finite-board strategies by game-graph certificates, local reductions, and Grundy/PN bridges; expect general hardness. |

## Loading order by task

1. Formal normal-play semantics:
   load `expert-personas/violeta-hernandez-palacios-combinatorialgames-lean.md`
   and the local `../lean/NodeKayles` modules.
2. Sum-free theorem polishing:
   load the Ernst-Sieben-Benesh and mirror-strategy dossiers, then the Lean CGT
   dossier.
3. Projective stable layer:
   load the mathlib projectivization and finite projective arcs dossiers.
4. Projective q-odd escape search:
   load finite projective arcs, computational complete-arc search, and Lean CGT.
5. Affine cap-set variants:
   load the formal cap-set methodology dossier before inventing definitions.
6. Queens n=20 certificate work:
   load graph-game certificate engineering and Lean CGT.

## Current project cautions

- SumFree now has a local bridge from labelled residual positions into ordinary
  group-play legality, but the full game-semantics bridge is still local rather
  than imported from `CombinatorialGames`.
- ProjectiveCap currently has residual grid vocabulary and stable proposition
  targets, not a full finite projective plane game model. The frame-to-grid
  bridge is formalized as
  `ProjectiveCap.FrameGridBridge.Coordinate.validityStatement`; the immediate
  open Lean target is the q-even residual-grid mirror theorem.
- Affine cap-set game outcome is now formalized for every nontrivial finite
  `K`-vector space: see `CapGame.Affine.initialP_of_nontrivial` and commit
  `965d660`.
- Queens is best treated as a NodeKayles-style finite graph game: the central
  task is certificate compression, not a generic solver theorem.

## Source spine

- CombinatorialGames Lean package:
  https://github.com/vihdzp/combinatorial-games
- Ernst and Sieben, finite-group achievement/avoidance games:
  https://arxiv.org/abs/1407.0784
- Johnson, Leader, Walters, Transitive Avoidance Games:
  https://www.combinatorics.org/ojs/index.php/eljc/article/view/v24i1p61
- Andres, Huggan, Mc Inerney, Nowakowski, orthogonal colouring game:
  https://hal.inria.fr/hal-02017462
- Ball and Lavrauw, arcs in finite projective spaces:
  https://arxiv.org/abs/1908.10772
- Dahmen, Holzl, Lewis, formal cap-set theorem:
  https://drops.dagstuhl.de/entities/document/10.4230/LIPIcs.ITP.2019.15
- Schaefer, two-person perfect-information games:
  https://doi.org/10.1016/0022-0000(78)90045-4
