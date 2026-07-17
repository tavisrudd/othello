# Dihedral Schreier Node-Kayles paper

**Lane**: `dihedral`

**Date**: 2026-07-17

## Goal

Bring `papers/dihedral-schreier-node-kayles` (Node Kayles on fixed-point-deleted Schreier graphs
from conic involutions) to the arcs/clebsch release bar: LaTeX+PDF, full-trust Lean, adequacy
appendix, provenance section, adversarial and cold-prose review, and a cleared novelty audit.

## Current status

- Manuscript: `notes/2026-07-12-dihedral-schreier-node-kayles-submission.md`, near-complete and
  committed markdown. Covers V₄ (Klein-four boundary) + dihedral D_{4n} + S₄/A₅ regular-template
  rows; §14 defers the nonregular polyhedral coset templates and the PSL₂/PGL₂ escape residual.
- Lean: `lean/DihedralSchreier/` certifies the reduction plumbing and the V₄→K₄ core only, without
  `sorry` or `native_decide` (kernel `decide`). Template nimbers, Theorem 7.2 isomorphisms,
  Brown et al. ladder values, orbit counts, and the density theorem are not yet formalized. See
  `lean/DihedralSchreier/README.md`.
- Solver: `rust/scripts/nodekayles_cayley.rs`. S₄ nimbers cross-checked by three independent
  solvers; all five A₅ rows independently reproduced by the C260 cross-check solver.
- Planning rulings: `papers/papers-planning.md` ship-order entry #2, ruling D6 (bundle D₂ₘ, do not
  spawn a sequel; escape hatch = ship the committed catalogue with §14 as the stated program),
  and the release policy (formalization gate, adequacy appendix, provenance section).
- Closed: C260 A₅ nimber cross-check (2026-07-17) — all five values reproduced by an independent
  solver; evidence bundle with SHA-256 manifest; claim edits landed →
  `notes/2026-07-17-c260-a5-template-nimber-crosscheck.md`.
- Closed: C261 novelty audit (2026-07-17) — attributions verified exact in full text, no colliding
  prior art, package verdict apparently unrecorded; wording recommendations R1–R5 pending in C264 →
  `notes/2026-07-17-c261-dihedral-novelty-audit.md`.

## Open frontiers

- Φ_T (Burnside) and ½-density formalizations are owed (C262).
- D₂ₘ additions are owed before shipping per D6 (C263).
- Manuscript is markdown with no adversarial or cold-prose review cycle (C264).

## Next steps

- **C264** must also apply the C261 audit's wording recommendations R1–R5 (HHS reduction citation,
  Schaefer root citation, Möbius-ladder ownership clause, optional novelty sentence, Ernst–Sieben
  distinction).
- **C262** — implement the recorded formalization gate (Φ_T, ½-density), or a declared trust
  boundary per the planning ruling; do not re-decide the gate.
- **C263** — generalized-D₂ₘ additions per D6, with the §14 escape hatch.
- **C264** — LaTeX+PDF conversion and the arcs/clebsch-bar review cycle.

## Cross-lane relationships (foreign; do not re-peg without approval)

The paper's driver and expert-upgrade items sit in the `cap` lane, not here:

- **C84 `[cap]`** — abundance-first conic-involution Schreier program (the paper's driver /
  next-programme), `notes/2026-07-12-conic-involution-residual-graphs.md`.
- **C199 `[cap]`** — extract direct strategies from the Schreier catalogue.
- **C200 `[cap]`** — recognize Schreier graph families structurally.

Both C199 and C200 live in `notes/2026-07-15-expert-questions-upgrade-portfolio.md`. They overlap
this paper's structural-recognition surface but remain `cap`-owned; coordinate rather than duplicate.
