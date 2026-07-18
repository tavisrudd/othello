# Dihedral Schreier Node-Kayles paper

**Lane**: `dihedral`

**Date**: 2026-07-17

## Goal

Bring `papers/dihedral-schreier-node-kayles` (Node Kayles on fixed-point-deleted Schreier graphs
from conic involutions) to the arcs/clebsch release bar: LaTeX+PDF, an explicit mixed-verification
map, `lean/TRUST.md` closure for every Lean-labelled claim, adequacy appendix, provenance section,
adversarial and cold-prose review, and a cleared novelty audit.

## Current status

- Manuscript: `papers/dihedral-schreier-node-kayles/dihedral_schreier_node_kayles.tex` since C306
  (2026-07-18), on the adopted eight-section spine, working title "Node Kayles on Conic Schreier
  Graphs: Dihedral and Polyhedral Templates" (final wording a user call). Build with
  `make dihedral` from `papers/`; it is registered in `papers/Makefile` and builds warning-clean.
  Owed integrations are marked in-source by `\phasenote` boxes naming their owning phase; C309 must
  set `\draftnotesfalse`. The markdown
  `notes/2026-07-12-dihedral-schreier-node-kayles-submission.md` is now superseded source material
  and is retained only until C311 verifies the migration.
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
- Discovery track: `notes/2026-07-18-dihedral-discovery-track.md` (started 2026-07-18).
- Planning rulings: `papers/papers-planning.md` ship-order entry #2, ruling D6 (D₂ₘ bundling —
  satisfied by C263, escape hatch not needed), and the mixed-verification release policy
  (claim-route map, adequacy appendix, provenance section).
- C264 architecture DECIDED (Fable, 2026-07-17): spine proposal adopted with four changes (density
  theorem stays a named §7 headline with the single-axiom sentence; §5 compression is
  arithmetic-only, structural proofs intact; §8 boundaries absorb C283's wild result; §6 leads with
  completeness, `ρ`-split calibrated). Title direction 1 recommended (final wording user call).
  C290 hard gate; C289 gate at elementary-proof scope; C291 post-C264. Decision appended to
  `notes/2026-07-17-dihedral-paper-spine-proposal.md`.
- C264 execution PREPARED (2026-07-18): the rewrite is now a six-phase, one-owner-at-a-time chain,
  C306--C311, with explicit inputs, owned deliverables, correctness hazards, validation gates, and
  commit/handoff discipline. C264 is the umbrella and closes only after the final cold-prose and
  release pass → `notes/2026-07-17-c264-dihedral-latex-adversarial-review.md`.
- Closed: C306 structural LaTeX rebuild (2026-07-18) — the markdown submission is migrated into the
  canonical LaTeX manuscript on the eight-section spine, two-point family first, ladder structural
  proofs intact, density kept as a named theorem, wild case in the boundary section; `make dihedral`
  builds clean with zero matches against the shared `warnings` pattern; every source item has a
  named destination in the phase report's non-loss ledger. Carried forward: §7.1's formulas and
  P-congruences are verbatim and known-incomplete pending C281's `t`-case split (C307), and three
  bibliography entries are uncited in the body (C308) →
  `notes/2026-07-18-c306-dihedral-structural-rebuild.md`.
- Closed: C290 congruence laws (2026-07-18) — all seven split-indicator laws and the fixed-point
  criteria proved from `PGL₂(q)` group theory; free-orbit parity `m₁ ≡ [χ(6)=−1] + [q≡1 (5)]
  (mod 2)`; all ten closed board-value laws now hold for every admissible tame `q` (proved modulo
  the finite C284 template table): `S₄` exact period 8 with `v(2,3,3) = 2[χ(2)=−1]`, `A₅` minimal
  moduli 120/24/15/4 with the `ε₅` cancellation `v(2,5,5) = [χ(6)=−1]`; every nonconstant class
  N with relative prime density 1/2; checker 0 mismatches vs the full C288 census; corollaries
  P1–P4 and a draft manuscript section ready for C264 →
  `notes/2026-07-17-c290-polyhedral-congruence-laws.md`.
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

## Cold-start packet for C264 sessions

This handoff is the entry point. A cold session should not reconstruct C264 from chat history or
from the old manuscript's section order.

### Read in this order

1. Repository instructions, then this handoff from top to bottom.
2. The canonical runbook, `notes/2026-07-17-c264-dihedral-latex-adversarial-review.md`. It fixes
   the eight-section spine, phase ownership, non-loss checklist, correctness hazards, and closure
   invariant.
3. Fable's ruling at the end of `notes/2026-07-17-dihedral-paper-spine-proposal.md`. The ruling is
   authoritative over the proposal where it changes emphasis: named density theorem, intact ladder
   proofs, C283 in the boundary section, completeness-first polyhedral section, body-level ten-row
   table, Burnside as corollary + remark, and both `D₁₂` and `A₅` examples.
4. The current manuscript,
   `papers/dihedral-schreier-node-kayles/dihedral_schreier_node_kayles.tex`, and the staging README,
   `papers/dihedral-schreier-node-kayles/README.md`. The superseded markdown
   `notes/2026-07-12-dihedral-schreier-node-kayles-submission.md` is source material only, never the
   approved narrative order, and is retained until the migration is verified complete at C311.
5. The live `dihedral` block in `notes/2026-07-07-codex-task-queue.md`, then the current phase's
   input row below. If a predecessor has closed, read its dated `notes/YYYY-MM-DD-cNNN-*.md`
   closing report and the commit named in this handoff before editing.

### Phase-specific input map

| Phase | Required cold-read inputs | Expected phase record |
|---|---|---|
| **C306 structural rebuild** | CLOSED 2026-07-18 | `notes/2026-07-18-c306-dihedral-structural-rebuild.md` |
| **C307 correctness integration** | C281 correction/census; C284 templates; C289 `rho` split and mirror lemmas; C290 proved arithmetic; C278 density; C283 wild pair; C288 validation census; C260 replay boundary. | `notes/YYYY-MM-DD-c307-dihedral-correctness-integration.md` plus a claim/source ledger referenced by the paper. |
| **C308 apparatus/trust** | C261 novelty audit R1–R5; C262 formalization report; C278 axiom boundary; C260/C284 computation boundaries; `lean/DihedralSchreier/README.md`; all citations already present in the manuscript. | `notes/YYYY-MM-DD-c308-dihedral-scholarly-trust.md`, including the exact mixed-verification map, adequacy appendix, and AI/provenance boundary. |
| **C309 artifact gate** | C306–C308 closing reports; paper README and build instructions; evidence/regeneration commands in C260/C281/C284/C288/C289/C290; `lean/DihedralSchreier/README.md`. Read `lean/AGENTS.md` before any Lean operation. | `notes/YYYY-MM-DD-c309-dihedral-artifact-reproducibility.md`, including the exact shared-Lean commit/target pin and no copied Lean source. |
| **C310 adversarial review** | Built C309 source/PDF; C307 claim ledger; C308 trust/provenance boundary; the runbook's correctness-hazard list. Review the paper as submitted, not the discovery reports as a substitute. | `notes/YYYY-MM-DD-c310-dihedral-adversarial-review.md` with finding, severity, disposition, and fixing commit for every item. |
| **C311 cold prose/release** | Corrected C310 source/PDF and closed issue ledger; title/abstract ruling; paper registry and staging README. | `notes/YYYY-MM-DD-c311-dihedral-cold-prose-release.md` recording two separated full reads and final artifact identity. |

### Mathematical source-of-truth map

- **Universal reduction and existing formal boundary:** C262,
  `notes/2026-07-17-c262-dihedral-burnside-density-formalization.md`, plus
  `lean/DihedralSchreier/README.md`.
- **Every-order two-point family:** C263,
  `notes/2026-07-17-c263-dihedral-d2m-additions.md`; **wild pair boundary:** C283,
  `notes/2026-07-17-c283-dihedral-wild-case-spike.md`.
- **Three-point correction and exhaustive tame validation:** C281,
  `notes/2026-07-17-c281-dihedral-census-appendix.md`. Its second-class `t=0` case corrects the
  old manuscript and must be applied before any §7 synthesis.
- **Polyhedral classification/table:** C284,
  `notes/2026-07-17-c284-dihedral-polyhedral-coset-templates.md`; **conceptual split and proved
  mirror upgrades:** C289, `notes/2026-07-17-c289-a5-triple-split.md`.
- **Polyhedral census:** C288,
  `notes/2026-07-17-c288-polyhedral-embedding-census.md`; **final proved congruence and value laws:**
  C290, `notes/2026-07-17-c290-polyhedral-congruence-laws.md`. C290 supersedes C288 wherever an
  empirical split/congruence formulation overlaps a proved one.
- **Density-half theorem:** C278,
  `notes/2026-07-17-c278-dihedral-conditional-density.md`. Preserve exactly its one-axiom formal
  boundary; do not describe the Lean result as unconditional.
- **Independent value evidence:** C260,
  `notes/2026-07-17-c260-a5-template-nimber-crosscheck.md`, and the replay bundles named by C284.
  The Rust reference solver is `rust/scripts/nodekayles_cayley.rs`.
- **Literature/novelty wording:** C261,
  `notes/2026-07-17-c261-dihedral-novelty-audit.md`; apply R1–R5 rather than improvising stronger
  priority language.

### Supersession and scope rules

- Fable's adopted spine supersedes the manuscript's discovery-order organization.
- C281 supersedes the old §9/Corollary 9.1 formulas where the missing conjugacy class matters.
- C290 supersedes C288's empirical arithmetic wording; C288 remains validation evidence.
- C289 is the ceiling on interpretations of `rho`: use the proved invariant account and no
  stronger geometric language.
- C291's direct strategies are a post-C264 upgrade. Their absence does not weaken a computed value
  into a conjecture and does not block the paper.
- C292 wild polyhedral characteristic, C293 finite-table formalization, and C84's growing
  full/subfield escape program remain outside C264. Do not expand scope to absorb them.

### Session close protocol

Every C306--C311 session must leave the next cold reader all of the following in one coherent
commit: the phase deliverable; a dated phase record; the runbook execution-log entry; this
handoff's current-status/next-step update; the exact validation commands and outcomes; and the
commit hash after commit creation (an immediate metadata-only follow-up is acceptable for recording
the hash). Move only the completed child task to the archive. Keep C264 live until C311 satisfies
the closure invariant. Never leave the only copy of a finding, decision, or required edit in chat.

## Open frontiers

- Density-½ gate CLOSED (C278, 2026-07-17): one quarantined axiom `primes_equidistribute`,
  ½ kernel-derived for all triple types and both torus signs. C264 still owes the paper's
  single-axiom boundary sentence; replace the axiom when mathlib ships PNT-in-AP.
- All pre-submission content is DONE (C281, C284, C288, C289, C290). C264 owes integration of:
  the C281 census appendix AND the §9/Cor 9.1 `t`-case-split correction (second `D_{4n}` class,
  value-affecting — a correctness fix, not just an appendix); the C289 mirror-lemma upgrades (six
  proved `t₁=0` entries) and §6 paragraphs; the C288 census appendix; the C290 congruence-law
  section (drafted in its report §11) with corollaries P1–P4 and the abstract candidate sentence —
  C290's proved laws supersede C288's empirical statement of the refined `S₄` split law.
- Manuscript is LaTeX since C306, with no adversarial or cold-prose review cycle yet. All content
  gates are closed; C307 correctness integration is the ready phase of the C264 execution chain.
- Post-release upgrades are direct strategies/certificates (C291), wild polyhedral characteristic
  (C292), and Lean formalization of the finite table boundary (C293). The growing full-group escape
  residual remains C84-owned in the `cap` lane; do not duplicate it here.

## Next steps

1. **C307** — correctness-first integration, the only ready C264 child. Apply C281's `t`-case split
   to §7.1 before any polishing (value-affecting, correctness hazard 1), then integrate C284, C289,
   C290, C278, C283, and the C288/C281 validation appendices, and build §6 completeness-first.
   Follow it serially with C308 scholarly/trust apparatus, C309 artifact reproducibility, C310
   adversarial review, and C311 two-pass cold prose/release. The canonical phase gates and non-loss
   checklist are in `notes/2026-07-17-c264-dihedral-latex-adversarial-review.md`; C306's ledger and
   carried-forward items are in `notes/2026-07-18-c306-dihedral-structural-rebuild.md`.
2. **After C311 closes C264:** C291 direct strategies/certificates; post-release C292 wild polyhedral spike and
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
- The LaTeX manuscript's section numbering is the eight-section spine; the markdown's §-numbers
  (including "Discussion = §15") survive only in the C306 non-loss ledger. Cite LaTeX labels, not
  markdown section numbers.

## Cross-lane relationships (foreign; do not re-peg without approval)

The paper's driver and expert-upgrade items sit in the `cap` lane, not here:

- **C84 `[cap]`** — abundance-first conic-involution Schreier program (the paper's driver /
  next-programme), `notes/2026-07-12-conic-involution-residual-graphs.md`.
- **C199 `[cap]`** — extract direct strategies from the Schreier catalogue.
- **C200 `[cap]`** — recognize Schreier graph families structurally.

Both C199 and C200 live in `notes/2026-07-15-expert-questions-upgrade-portfolio.md`. They overlap
this paper's structural-recognition surface but remain `cap`-owned; coordinate rather than duplicate.
