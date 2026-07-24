# Clebsch three-paper program

**Lane**: `clebsch`

**Date**: 2026-07-24

> **LIVE MAP ONLY.** The three-paper program below is the active publication
> path. The 37-page mega-paper and its evidence surface are preserved
> unchanged as a fallback, not as the active release target. Historical
> planning and review records are linked at the end.

## Current verdict

Paper I, *Deep-hole rigidity of the Clebsch hexagon code*, is a
warning-free 19-page candidate with a complete nineteen-row release surface
and a green clean replay. It lives in `papers/clebsch-rigidity/`. C320 is
still live at the mandatory user-launched independent-review gate; the
implementing agent's pre-review verdict is `READY FOR INDEPENDENT REVIEW`,
not final `GO`.

The active order is strict:

1. **C320:** obtain the user-launched independent review, repair every
   finding, and obtain the separately launched post-fix `GO`.
2. **C182:** archive and release Paper I.
3. **C577:** build and referee-test standalone Paper II after Paper I is
   submission-ready.
4. **C579:** test Paper III after Paper II; require one principal theorem or
   return the material to an inventory.

If C182 has passed every local gate and waits only for a user-controlled
DOI, licence, or repository-release action, C577 may begin without treating
that external wait as a Paper I defect.

C321 is conditional inside C320 and is currently expected not to trigger:
Paper I retains no load-bearing Singular claim.

The authoritative split records are:

- `notes/2026-07-24-clebsch-paper-split-trial.md` — three-paper charter and
  acceptance gates;
- `notes/2026-07-24-c575-clebsch-split-disposition.md` — exact source and
  content disposition;
- `notes/2026-07-24-c575-clebsch-trust-disposition.csv` — exact 58-row
  partition;
- `notes/2026-07-24-c576-clebsch-rigidity-candidate.md` — Paper I build,
  hashes, and referee assessment.

## Source roots and status

| role | root | status |
|---|---|---|
| Paper I | `papers/clebsch-rigidity/` | release surface green; C320 independent review next |
| Paper II | `papers/clebsch-factorization/` | compilable spine; C577 gated behind Paper I |
| Paper III | `papers/clebsch-passages/` | exploratory spine; C579 gated behind Paper II |
| mega-paper fallback | `papers/clebsch-hexagon-code/` | preserved unchanged with its 58-row/18-check evidence surface |

Never rename, delete, repurpose, or silently filter the mega-paper fallback.
Its manuscript, manifest, aggregate gate, and release replay remain a
matched historical surface. Do not use them to certify a split-paper source
hash.

## Paper I — rigidity and decoding

Paper I owns:

- the code--arc dictionary and explicit Clebsch parity-check matrix;
- the syndrome conic, decoding oracle, automorphisms, and complete ambiguity
  census;
- symmetry-free rigidity, the sharp numerical and nearest-conic gaps, and
  low-degree rigidity;
- Brianchon reconstruction and the intrinsic unordered `10+10` invariant
  support bipartition;
- uniqueness at `q=11`, the Clebsch-family formula, and the
  `4 <= k <= 7` classification;
- the nineteen-row Paper I claim/evidence map and its future C320 release
  surface.

Paper I has no Paper II or Paper III theorem dependency. It omits the
optional `H_3` paragraph. Exhaustive computation is load-bearing only for
the numerical gap, low-degree strengthening, and terminal small-arc
exclusion; the conic-containment implication is conceptual.

Current build:

```text
cd papers
make -B clebsch-rigidity
```

Inspect `papers/clebsch-rigidity/clebsch_rigidity.log`, not the fallback
Clebsch log.

## C320 — current independent-review gate

C320 means **Paper I only**. The implementation and clean replay are complete
in `notes/2026-07-20-c320-clebsch-trust-ledger.md`. The exact formal source
pin is `bf4fb39ab3c3b06c3f82c2c90d37077d7aa4c520`; the manifest is
`papers/clebsch-rigidity/verification/trust_manifest.json`.

The independent reviewer starts from:

- `papers/clebsch-rigidity/clebsch_rigidity.tex`;
- the nineteen rows `2, 11--26, 29, 58` in
  `notes/2026-07-24-c575-clebsch-trust-disposition.csv`;
- the exact manuscript-facing map in C576's report;
- the broad fallback ledger only as a source of candidate evidence routes.

C320's implemented surface:

1. has the exact nineteen-row statement identity and manifest;
2. admits 24 Lean terminals and ten release-local exact checkers, with no
   Paper II, Paper III, or Singular route;
3. has a separate aggregate gate, axiom audit, canonical checker-output
   certificate, and fifteen-check clean release runner;
4. pins hashes, toolchains, the exact formal source commit, and manuscript
   correspondence while preserving the fallback surface byte-for-byte.

The implementing agent must not launch or simulate the reviewer. The user
now launches the independent cold review. Any finding blocks completion and
requires a fix plus a separately user-launched post-fix review; only its final
`GO` advances to C182.

The previous C320 `NO-GO`, 58-row manifest, 29-statement extraction, and
18-check replay belong to the mega-paper fallback. They are provenance and
evidence inputs, not the active C320 acceptance state. Do not resume the old
instruction to launch its reviewer.

## Paper II — factorization memory

C577 owns the standalone paper provisionally titled *Factorization memory
in a conic ideal: the `A_3`, `B_3`, and `H_3` configurations*. Its spine is:

1. conic matching products and the general switch/divisibility quotient;
2. the `A_3/B_3/H_3` configurations and ranks `3,6,10`;
3. balanced sheets and cubic-first orientation;
4. six-profile reconstruction;
5. modular depth quotient and arithmetic splitting/gluing;
6. a Paper II-specific verification architecture.

Use C399 as the conic-phase prelude and C403/C406/C411 with selective C412
upgrades. Credit Edge and Dye for the exceptional configurations and avoid
novelty claims for the raw `5/14/22` marker spaces, parent ambiguity, the
`B_3` `3+6` split, or conic--GRS identification.

Primary planning inputs:

- `notes/2026-07-20-c399-literature-audit.md`;
- `notes/2026-07-20-c406-matching-module.md`;
- `notes/2026-07-20-c406-priority-audit.md`;
- `notes/2026-07-20-c411-double-coset-hecke.md`;
- `notes/2026-07-20-c412-relative-cubic-depth-plane.md`.

Passage, holonomy, torsor, theta/Fourier/quantum, Mathieu, and
characteristic-zero material is inventory-only during C577.

## Paper III — passages and holonomy

C579 tests the provisional *Finite passages and holonomy in Clebsch
matching geometry*. It may proceed only if one principal theorem organizes:

- carriers, orientations, and passage maps;
- exact survival and loss statements;
- the four-sheet cover and cycle holonomy;
- theta, Fourier, and quantum realizations;
- Mathieu and characteristic-zero bridges.

If no single theorem makes the comparisons consequences or applications,
stop drafting and return the material to a disposition inventory. Do not
lengthen Paper II to absorb it.

## Shared verification and release policy

Each split paper gets its own statement identity, claim manifest, aggregate
gate, replay entry point, toolchain pins, adequacy appendix, and
AI/provenance disclosure. Shared Lean sources stay in the pinned standalone
Lean repository; no split paper inherits trust from the fallback aggregate
gate merely by importing related terminals.

Paper I ships after `arcs` supplies the public provenance target for the
shared deep-holes-equals-conic identification. C182 packages only the
C320-approved Paper I surface. Paper II and Paper III receive separate
release passes if and when they exist.

## Lane boundaries

This lane owns the three Clebsch paper roots, the preserved mega-paper
fallback, Clebsch checkers/reports, and exact Clebsch queue rows. It does not
own Baer, alternate-orbit, gem-mining, or crowns work. Results from those
lanes may be consumed read-only only when the split disposition explicitly
admits them.

The companion discovery log is
`notes/2026-07-14-clebsch-discovery-track.md`. Logging an observation does
not add it to any paper or allocate work.

## Historical records

- Mega-paper decision map:
  `notes/2026-07-20-clebsch-paper-planning.md` — fallback only.
- Mega-paper independent cold read:
  `notes/2026-07-23-c320-independent-cold-read.md` — fallback only.
- Former replacement-spine abstract and presentation drafts:
  `notes/2026-07-21-clebsch-paper-abstract-outline.md`,
  `notes/2026-07-21-clebsch-paper-guided-tour-conclusion-draft.md`,
  `notes/2026-07-22-clebsch-geb-design.md`, and
  `notes/2026-07-22-clebsch-geb-design-red-team.md` — fallback/history,
  not active split-paper instructions.
- Full accumulated handoff history:
  `notes/handoffs/done/2026-07-13-clebsch-paper-archive.md`.
