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
- Lean: `lean/DihedralSchreier/` certifies the reduction plumbing, the V₄→K₄ core, Φ_T
  (Prop 11.1 + Cor 11.2, `Burnside.lean`), the finite ½-density core (`Density.lean`), and the
  conditional density-½ layer behind exactly one quarantined Davenport axiom
  (`DensityAxioms.lean` + `DensityConditional.lean`) — all without `sorry` or `native_decide`.
  Still not formalized: template nimbers, Theorem 7.2 isomorphisms, Brown et al. ladder values,
  orbit counts, and the new §14 pair-family theorems. See `lean/DihedralSchreier/README.md`.
- Solver: `rust/scripts/nodekayles_cayley.rs`. S₄ nimbers cross-checked by three independent
  solvers; all five A₅ rows independently reproduced by the C260 cross-check solver.
- Planning rulings: `papers/papers-planning.md` ship-order entry #2, ruling D6 (D₂ₘ bundling —
  satisfied by C263, escape hatch not needed), and the release policy (formalization gate,
  adequacy appendix, provenance section).
- Closed: C278 conditional density (2026-07-17) — density-½ kernel-certified behind exactly one
  Davenport-cited equidistribution axiom (`DensityAxioms.lean` + `DensityConditional.lean`; audits
  `[propext, Classical.choice, Quot.sound, primes_equidistribute]`) →
  `notes/2026-07-17-c278-dihedral-conditional-density.md`.
- Closed: C282 OEIS byproducts (2026-07-17) — one new-submission draft (Node-Kayles on `C_n`,
  collision-clean, C270 `%H`/`%o` placeholders), path crossrefs A002187, five candidates declined
  with reasons; nothing submitted → `notes/2026-07-17-c282-dihedral-oeis-byproducts.md`.
- Closed: C283 wild-case spike (2026-07-17) — `p | 2m` forces `D_{2p}` (unipotent rotation,
  Borel-reducible, one deleted point, residual `P_p`, `𝒢 = A002187(p)`), breaking the tame
  odd-order P law outside the tame hypothesis; triples cannot be wild; §15 remark applied to the
  manuscript; wild pair classification judged a short lemma (promotable) →
  `notes/2026-07-17-c283-dihedral-wild-case-spike.md`.
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

- Density-½ gate CLOSED (C278, 2026-07-17): one quarantined axiom `primes_equidistribute`,
  ½ kernel-derived for all triple types and both torus signs. C264 still owes the paper's
  single-axiom boundary sentence; replace the axiom when mathlib ships PNT-in-AP.
- Manuscript is markdown with no adversarial or cold-prose review cycle (C264).

## Next steps

- **C284 — GATE DECIDED (user, 2026-07-17): pre-submission.** Polyhedral nonregular coset
  templates land before C264; the paper waits for them and earns the full finite-subgroups title.
  C264 is delayed behind C284 accordingly.
- **C281** — exhaustive per-q census appendix (extend C263 enumerator to triples; evidence bundle).
- **C264** — LaTeX+PDF + adversarial/cold-prose cycle, last, after content lands. Must apply: the
  C261 wording recommendations R1–R5 (HHS reduction citation, Schaefer root citation,
  Möbius-ladder ownership clause, optional novelty sentence, Ernst–Sieben distinction); the C278
  single-axiom boundary sentence; the C260 maximal-automorphism-group remark (Appendix A); an
  eventual-periodicity-in-m corollary (Dawson period 34) if C264's read confirms §14 lacks it; and
  title/abstract calibration so nothing reads as covering the wild case.

## Cautions (standing, for any session in this lane)

- The Lean worktree may hold foreign dirty state under `RelativeConicArcs/` (alt-orbit-repair
  lane): never build across, stage, or touch that closure. Builds go through
  `lean/scripts/lean-build-queue.py` or `guarded-lean` only, per `lean/CLAUDE.md`.
- `lean-build-queue.py run --detach` FAILS FAST when another owner holds the build lock — it does
  not queue behind it. Check the launcher log for "another build owner holds"; resubmit after the
  holder finishes.
- Concurrent sessions allocate C-IDs and sweep the shared queue file with whole-file adds:
  re-verify the max ID immediately before allocating, and commit with explicit pathspecs.
- Every computational claim needs the atomic evidence bundle of CLAUDE.md "Research records and
  computational reproducibility": tracked script + canonical JSON + SHA-256 manifest + report with
  regeneration commands, committed together.
- Nontrivial proof development requires the named-expert personas read first
  (`notes/2026-07-07-named-expert-personas-context.md`).
- The manuscript's Discussion is §15 after C263; do not reintroduce "§14 = Discussion" references.

## Cross-lane relationships (foreign; do not re-peg without approval)

The paper's driver and expert-upgrade items sit in the `cap` lane, not here:

- **C84 `[cap]`** — abundance-first conic-involution Schreier program (the paper's driver /
  next-programme), `notes/2026-07-12-conic-involution-residual-graphs.md`.
- **C199 `[cap]`** — extract direct strategies from the Schreier catalogue.
- **C200 `[cap]`** — recognize Schreier graph families structurally.

Both C199 and C200 live in `notes/2026-07-15-expert-questions-upgrade-portfolio.md`. They overlap
this paper's structural-recognition surface but remain `cap`-owned; coordinate rather than duplicate.
