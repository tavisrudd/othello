# C287 first-tag source-owner rewrite packet

**Lane**: `build-sys`
**Status**: READY FOR SOURCE-OWNER DECISIONS; no mathematical source changed
**Source-owner lane**: `cap`

## Dispatch boundary

This packet turns the failed first-tag referee pass into one bounded source-owner review. It covers
the 17 known prose failures, two status-bearing API families, and the closure-wide declaration
docstring classification. C287 owns the public-export contract and the post-edit inventory audit;
the `cap` source owner owns all mathematical Lean edits and the API decisions below.

The source owner must preserve mathematical limitations expressed by hypotheses and conclusions
while removing private provenance, task history, proof-campaign labels, implementation chronology,
and instructions for future work. This is not a request to weaken theorem statements or hide
unfinished mathematics.

## Decision A — odd escape API

Current public surface:

- module `ProjectiveCap.Almost.OddEscape`;
- namespace `ProjectiveCap.Almost`;
- abstract declarations `GridPPosition` and `OddEscapeStatement`;
- concrete declarations `OddEscapeGameStatement` and
  `oddEscapeGameStatement_iff_escapeExtensions_nonempty`.

The abstract pair has no external source user. The concrete pair is a wrapper around the already
mathematical API `ProjectiveCap.GridGame.OddEscapeStatement` and
`ProjectiveCap.GridGame.oddEscapeStatement_iff_escapeExtensions_nonempty`. The first-tag direct
import consumers are `ProjectiveCap.EscapeParity` and `ProjectiveCap.ConicLocalization`; the
portfolio umbrella and `ProjectiveCap.Certificate` also expose or use the wrapper.

**Recommendation A1:** delete `ProjectiveCap/Almost/OddEscape.lean`, retarget all consumers to the
existing `ProjectiveCap.GridGame` declarations, and add no compatibility alias. This removes both
the workflow-bearing path and a duplicate public proposition.

**Fallback A2:** if the abstract parameterized proposition is intentionally public, move the
surviving declarations to `ProjectiveCap/ResidualEscape.lean` under
`ProjectiveCap.ResidualEscape`, and still use the `GridGame` declarations directly for the concrete
game theorem. The source owner must state the scholarly use that justifies retaining the abstract
surface.

## Decision B — stable-facts API

Current public surface:

- `Stable.LegalGridExtensions` plus two elementary bridge lemmas;
- `Stable.SizeThreeExtensionCountStatement`;
- unused `Stable.FrameReductionInterface` and `Stable.FrameReductionStatement`.

`LegalGridExtensions` duplicates `GridGame.LegalExtensions`; its equality theorem records that
identity. The frame-reduction pair has no source user and is explicitly superseded. The
size-three statement wrapper is used only as the type of
`ProjectiveCap.sizeThreeExtensionCount`, while the proof already lives in
`ProjectiveCap.ExtensionCount`.

**Recommendation B1:** delete `ProjectiveCap/StableFacts.lean`; use
`GridGame.LegalExtensions` directly; delete the unused frame-reduction pair; and give
`ProjectiveCap.ExtensionCount` one direct, self-contained public theorem for the size-three
extension count. Update `EscapeParity`, the odd-escape consumer selected in Decision A, and the
portfolio umbrella without adding compatibility aliases.

**Fallback B2:** if a separate statement module is intentionally part of the scholarly API, retain
only the live residual-extension declarations in `ProjectiveCap/ResidualExtensions.lean` under
`ProjectiveCap.ResidualExtensions`. The source owner must justify why the proposition wrapper is
preferable to the proved theorem in `ExtensionCount`.

Both recommendations reduce the first-tag closure. Either fallback changes paths and hashes.
C287 will regenerate rather than hand-edit the inventory and trust-spine module list after the
source-owner commit.

## Seventeen-module prose rewrite

The source owner should review each complete module, not only the detected header:

| Module | Required public rewrite |
|---|---|
| `CapGame/Affine.lean` | Replace unnamed private-note provenance with a self-contained description of the affine specialization and its mathematical role. |
| `CapGame/BuildGame.lean` | Describe the generic finite placement game as the implemented API; remove “scaffold” and hypothetical parser/checker plans. |
| `ProjectiveCap/Almost/OddEscape.lean` | Resolve Decision A; remove “almost,” “legacy,” target, and proof-search chronology. |
| `ProjectiveCap/Binary.lean` | State the binary-field result and exact scope directly, without “start of” unfinished bridge language. |
| `ProjectiveCap/ConicLocalization.lean` | Replace private-plan and work-package prose with the precise localization statements and assumptions. |
| `ProjectiveCap/EscapeParity.lean` | Replace workflow labels and retrospective proof narration with the parity result and its dependencies. |
| `ProjectiveCap/FrameGridBridge.lean` | Explain the frame-to-grid correspondence mathematically; remove task sequencing and private provenance. |
| `ProjectiveCap/Grid.lean` | Define the grid model and its scope without citing private project notes or promised future statements. |
| `ProjectiveCap/GridCounting.lean` | State exactly which incidences and counts are proved; remove “stops short” development-status wording. |
| `ProjectiveCap/GridMirror.lean` | Replace work-package labels and implementation history with the mirror hypotheses and consequences. |
| `ProjectiveCap/GridSeed.lean` | Describe the seed construction directly rather than as part of a frame-reduction “story.” |
| `ProjectiveCap/IntrusionCalculus.lean` | Replace private workflow terminology with the intrusion definitions, bounds, and mathematical dependencies. |
| `ProjectiveCap/PlaneOutcome.lean` | Present the combined plane outcomes and conditions without milestone or task-history language. |
| `ProjectiveCap/Projective.lean` | Describe hypotheses as assumptions of the public results, not “remaining obligations.” |
| `ProjectiveCap/StableFacts.lean` | Resolve Decision B; remove “stable,” stubs, targets, superseded scaffolding, and future-proof language. |
| `Sumfree/MirrorLemmas.lean` | Replace private-note/formalization-target provenance with self-contained mirror lemmas and scope. |
| `Sumfree/RankCounts.lean` | Replace workflow residue with the exact rank-count identities and assumptions. |

## Semantic acceptance contract

The source-owner commit is ready for C287 only when:

1. Decisions A and B are recorded and all repository consumers compile against one canonical API;
2. every non-private declaration in the resulting first-tag closure is classified as
   scholarly-public or made private deliberately;
3. every scholarly-public theorem and every non-obvious scholarly-public definition has a
   self-contained docstring matching its type;
4. module headers and declaration docs contain no private paths, task identifiers, work-package
   labels, proof-campaign status, retrospective implementation prose, or indirect reverse
   references;
5. the source owner reports every renamed, deleted, or newly private declaration so C287 can audit
   the public manifest rather than infer API intent from a diff.

No Lean, Lake, generator, export, or build action was performed to prepare this packet.
