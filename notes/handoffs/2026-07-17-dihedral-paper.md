# Dihedral Schreier Node-Kayles paper

**Lane**: `dihedral`

**Date**: 2026-07-17

## Goal

Bring `papers/dihedral-schreier-node-kayles` (Node Kayles on fixed-point-deleted Schreier graphs
from conic involutions) to the arcs/clebsch release bar: LaTeX+PDF, full-trust Lean, adequacy
appendix, provenance section, adversarial and cold-prose review, and a cleared novelty audit.

## Current status

- Manuscript: `notes/2026-07-12-dihedral-schreier-node-kayles-submission.md`, near-complete and
  committed markdown, retitled "Dihedral Subgroups of PGL₂(q)" (C263; user may revisit the title —
  the bare D6 phrase "finite subgroups of PGL₂(q)" was judged an overclaim while polyhedral/PSL
  stay deferred). Covers V₄ + the full two-reflection `D₂ₘ` pair family (all `m≥3`, both parities,
  new §14) + triple-based D_{4n} + S₄/A₅ regular-template rows; §15 defers the nonregular
  polyhedral coset templates and the PSL₂/PGL₂ escape residual.
- Lean: `lean/DihedralSchreier/` certifies the reduction plumbing and the V₄→K₄ core only, without
  `sorry` or `native_decide` (kernel `decide`). Template nimbers, Theorem 7.2 isomorphisms,
  Brown et al. ladder values, orbit counts, and the density theorem are not yet formalized. See
  `lean/DihedralSchreier/README.md`.
- Solver: `rust/scripts/nodekayles_cayley.rs`. S₄ nimbers cross-checked by three independent
  solvers; all five A₅ rows independently reproduced by the C260 cross-check solver.
- Planning rulings: `papers/papers-planning.md` ship-order entry #2, ruling D6 (D₂ₘ bundling —
  satisfied by C263, escape hatch not needed), and the release policy (formalization gate,
  adequacy appendix, provenance section).
- Closed: C263 D₂ₘ additions (2026-07-17) — full pair family `D₂ₘ` classified (odd dihedral always
  P; even case `(1−δ)·𝒢(Pₘ)` Dawson), verified over all 241,344 tame legal pairs, retitle applied,
  Discussion now §15 → `notes/2026-07-17-c263-dihedral-d2m-additions.md`.
- Closed: C262 formalization (2026-07-17) — Φ_T (Prop 11.1 + Cor 11.2) fully Lean-proved;
  Thm 12.1's periodicity, exact 2-of-4 classification, and P/N prime infinitude proved; density
  value 1/2 gap recorded (mathlib frontier) → `notes/2026-07-17-c262-dihedral-burnside-density-formalization.md`.
- Closed: C260 A₅ nimber cross-check (2026-07-17) — all five values reproduced by an independent
  solver; evidence bundle with SHA-256 manifest; claim edits landed →
  `notes/2026-07-17-c260-a5-template-nimber-crosscheck.md`.
- Closed: C261 novelty audit (2026-07-17) — attributions verified exact in full text, no colliding
  prior art, package verdict apparently unrecorded; wording recommendations R1–R5 pending in C264 →
  `notes/2026-07-17-c261-dihedral-novelty-audit.md`.

## Open frontiers

- Density-½ gate RULED (`yc`, 2026-07-17): formalize conditionally — quarantine equidistribution
  of primes in AP as one named axiom (RepairCodes-Stichtenoth pattern) and kernel-check the
  derivation to the ½ conclusion. Allocated as C278. Unconditional formalization (PNT in AP)
  stays out of scope; C264 states the single-axiom boundary in the paper.
- Manuscript is markdown with no adversarial or cold-prose review cycle (C264).

## Next steps

- **C278** (in flight 2026-07-17) — conditional density-½ via one quarantined equidistribution
  axiom; review its axiom statement's faithfulness before accepting.
- **C284 USER SEQUENCING GATE, decide FIRST**: polyhedral nonregular coset templates would complete
  all finite subgroups of PGL₂(q) except the escape residual (the biggest significance lever).
  Decide pre-submission (delays C264) vs post-release before starting C264.
- **C281** — exhaustive per-q census appendix (extend C263 enumerator to triples; evidence bundle).
- **C283** — wild-case scoping spike, time-boxed: `p | 2m` examples + §15 remark + feasibility
  frontier; no classification claim.
- **C282** — byproduct OEIS priority-stamp drafts (program links follow C270).
- **C264** — LaTeX+PDF + adversarial/cold-prose cycle, last, after content lands. Must apply: the
  C261 wording recommendations R1–R5 (HHS reduction citation, Schaefer root citation,
  Möbius-ladder ownership clause, optional novelty sentence, Ernst–Sieben distinction); the C278
  single-axiom boundary sentence; the C260 maximal-automorphism-group remark (Appendix A); an
  eventual-periodicity-in-m corollary (Dawson period 34) if C264's read confirms §14 lacks it; and
  title/abstract calibration so nothing reads as covering the wild case.
- **C264** — LaTeX+PDF conversion and the arcs/clebsch-bar review cycle.

## Cross-lane relationships (foreign; do not re-peg without approval)

The paper's driver and expert-upgrade items sit in the `cap` lane, not here:

- **C84 `[cap]`** — abundance-first conic-involution Schreier program (the paper's driver /
  next-programme), `notes/2026-07-12-conic-involution-residual-graphs.md`.
- **C199 `[cap]`** — extract direct strategies from the Schreier catalogue.
- **C200 `[cap]`** — recognize Schreier graph families structurally.

Both C199 and C200 live in `notes/2026-07-15-expert-questions-upgrade-portfolio.md`. They overlap
this paper's structural-recognition surface but remain `cap`-owned; coordinate rather than duplicate.
