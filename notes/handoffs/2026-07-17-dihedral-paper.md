# Dihedral Schreier Node-Kayles paper

**Lane**: `dihedral`

**Date**: 2026-07-17

## Goal

Bring `papers/dihedral-schreier-node-kayles` (Node Kayles on fixed-point-deleted Schreier graphs
from conic involutions) to the arcs/clebsch release bar: LaTeX+PDF, full-trust Lean, adequacy
appendix, provenance section, adversarial and cold-prose review, and a cleared novelty audit.

## Current status

- Manuscript: `notes/2026-07-12-dihedral-schreier-node-kayles-submission.md`, near-complete and
  committed markdown, retitled "Dihedral Subgroups of PGL₂(q)" (C263; revisit the title only in
  C264 after the polyhedral additions land). Covers V₄ + the full two-reflection `D₂ₘ` pair family
  + triple-based D_{4n} + S₄/A₅ regular-template rows; it still needs the C284 nonregular
  polyhedral section integrated and must continue to exclude the wild and full `PSL₂/PGL₂` escape
  residuals explicitly.
- Lean: `lean/DihedralSchreier/` certifies the reduction plumbing, the V₄→K₄ core, Φ_T
  (Prop 11.1 + Cor 11.2, `Burnside.lean`), the finite ½-density core (`Density.lean`), and the
  conditional density-½ layer behind exactly one quarantined Davenport axiom
  (`DensityAxioms.lean` + `DensityConditional.lean`) — all without `sorry` or `native_decide`.
  Still not formalized: template nimbers, Theorem 7.2 isomorphisms, Brown et al. ladder values,
  orbit counts, and the new §14 pair-family theorems. See `lean/DihedralSchreier/README.md`.
- Solver: `rust/scripts/nodekayles_cayley.rs`. S₄ nimbers cross-checked by three independent
  solvers; all five A₅ rows independently reproduced by the C260 cross-check solver.
- Closed: C284 polyhedral coset templates (2026-07-17) — `A₄` impossible; all `S₄/A₅` nonregular
  templates tabulated; `(σ,ρ)` proved a complete `Aut(G)`-orbit invariant (the `A₅ (3,5,5)` split);
  bundle reviewed, independently re-replayed (2,160 triples, 38 templates, 0 mismatches), and
  committed; manuscript integration owed by C264 §6 under the adopted spine →
  `notes/2026-07-17-c284-dihedral-polyhedral-coset-templates.md`.
- Planning rulings: `papers/papers-planning.md` ship-order entry #2, ruling D6 (D₂ₘ bundling —
  satisfied by C263, escape hatch not needed), and the release policy (formalization gate,
  adequacy appendix, provenance section).
- C264 architecture DECIDED (Fable, 2026-07-17): spine proposal adopted with four changes (density
  theorem stays a named §7 headline with the single-axiom sentence; §5 compression is
  arithmetic-only, structural proofs intact; §8 boundaries absorb C283's wild result; §6 leads with
  completeness, `ρ`-split calibrated). Title direction 1 recommended (final wording user call).
  C290 hard gate; C289 gate at elementary-proof scope; C291 post-C264. Decision appended to
  `notes/2026-07-17-dihedral-paper-spine-proposal.md`.
- Closed: C281 dihedral census (2026-07-17) — all 255,288 tame legal pairs and 246,000 legal tame
  dihedral triples over prime `q ≤ 23`, every value matching the orbit-template engine and a
  corrected closed form; C263/C284/C283 overlaps reproduced exactly; **found a value-affecting §9
  gap**: for `h` even a second `D_{4n}` conjugacy class with all-nonsplit reflections (`t=0`)
  exists (first case `q=7` `D₈` acting freely, board `M₈`, value 1 vs boxed 0); for odd `d`
  exactly one of the two classes is an N-position, so §9 (9.1)/(9.2)/(9.4)/(9.5) and Cor 9.1 need
  a `t`-case split (owed by C264); the §14 pair value formula survives (`t ≡ 1+δ (mod 2)`);
  corrected form verified on every configuration; draft appendix + Remark Y included →
  `notes/2026-07-17-c281-dihedral-census-appendix.md`.
- Closed: C288 polyhedral embedding census (2026-07-17) — all admissible tame `S₄`/`A₅`
  realizations for odd prime powers `q ≤ 101` (26 + 12 fields, one `PGL₂(q)`-class each, 5,912
  triples), C284 reproduced exactly on independently found subgroups; new: board Grundy value 2
  occurs (`(2,3,3);ρ=4`, iff `q ≡ 3, 5 (mod 8)`, first at `q = 5`), C284's `S₄` split law refined
  (`ε₂ₐ = 1 ⇔ q ≡ 1, 3 (mod 8)`; `ε₄ = 1 ⇔ q ≡ 1 (mod 4)`), closed-form value laws verified for
  all 10 classes; 8,540 per-orbit + 3,596 whole-board replays, 0 mismatches; draft appendix ready
  for C264 → `notes/2026-07-17-c288-polyhedral-embedding-census.md`.
- Closed: C289 conceptual `A₅ (3,5,5)` split (2026-07-17) — common-order lemma proved in any group;
  the split proved a class discriminator via the trace-zero Fricke identity (ρ=5 iff the order-5
  pair products are conjugate, `abc` in the opposite class); isoceles/scalene icosahedral
  identification with matching orbit structure; a mirror lemma upgrades six polyhedral `t₁=0`
  entries from computed to proved (the `ρ=3` regular zero stays computational); coset templates
  shown to re-expose the rotation-subgroup conjugacy geometry the free orbit quotients away;
  stdlib-Python certificate with independent C284 residual replay, zero mismatches; draft §6
  paragraphs included for C264 → `notes/2026-07-17-c289-a5-triple-split.md`.
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
- The last pre-submission content upgrade is C290 (closed congruence/P/N laws; its C288/C289
  prerequisites are done). C264 owes integration of: the C281 census appendix AND the §9/Cor 9.1
  `t`-case-split correction (second `D_{4n}` class, value-affecting — this is a correctness fix,
  not just an appendix); the C289 mirror-lemma upgrades (six proved `t₁=0` entries) and §6
  paragraphs; the C288 census appendix and its refinement of C284's `S₄` split-indicator law
  (value 2 exists, `q ≡ 3, 5 (mod 8)`).
- Manuscript is markdown with no adversarial or cold-prose review cycle (C264), which remains last.
- Post-release upgrades are direct strategies/certificates (C291), wild polyhedral characteristic
  (C292), and Lean formalization of the finite table boundary (C293). The growing full-group escape
  residual remains C84-owned in the `cap` lane; do not duplicate it here.

## Next steps

1. **C290** — derive the explicit field congruence, Grundy, P/N, periodicity, and density corollaries. A delegated C290 session was in flight 2026-07-17 when quota ran out: before starting fresh, check for untracked `notes/2026-07-17-c290-*` files on disk and review rather than redo them if present.
2. **C264** — LaTeX+PDF + adversarial/cold-prose cycle, last, after content lands. Apply the C281 §9 t-case-split correction, C261 R1–R5,
   the C278 single-axiom boundary sentence, C260/C284 computation boundaries, the Dawson period-34
   corollary, and title/abstract calibration excluding the wild and full-group escape cases.
3. **Post-C264:** C291 direct strategies/certificates; post-release C292 wild polyhedral spike and
   C293 Lean formalization. Continue the full `PSL₂/PGL₂` escape program only through C84 `[cap]`.

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
