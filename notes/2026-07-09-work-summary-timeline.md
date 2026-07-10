# Work Summary — Week-by-Week Timeline

Companion to [`2026-07-09-work-summary.md`](2026-07-09-work-summary.md) (the timeless scope report).
Activity spans **2026-06-14 → 2026-07-09** — four working weeks, with a quiet stretch Jun 28–30.
This is the *chronological* view; the scope report is the *state* view.

The arc in one line: **Othello engine → Queens solver + open problem → CGT theory pivot →
projective-cap program**, with Lean formalization ramping alongside from week 2 on.

---

## Week 1 — Jun 14–20 · Othello engine + Queens solver foundation

- Ported the Python Othello engine to Rust: bitboard core, disc-differential eval, depth-aware cache,
  the engine ladder (minimax / alphabeta / ordered / strong), native endgame solver, and the
  cross-engine value-equivalence test suite.
- Stood up the Queens solver's memory spine: flat lockless TT, TT dump/load, the **BuRR** succinct
  store (live implementation), the iso-key canonicalization, and an inner-loop rewrite.
- Landed **iso-flat** → **iso-window** solvers; fixed flat-TT contention; measured per-ply distinct
  counts and the n=14 throughput regression; explicit-stack frontier.
- First Node-Kayles literature/levers pass (the queens game = Node-Kayles on the queen graph).

## Week 2 — Jun 21–27 · Queens n=18 push + Lean getK verification

- Matured the **iso-dense** solver: the `W_K` hierarchy + `getK` Node-Kayles leaf evaluator (BMI2
  `pext`), the fastest lineage member; "push-past-floor" lever sweeps.
- Opened the **n=18** campaign: umbrella handoff, n18 work plan, BuRR-backed iso-dense design, the
  384-bit board branch, and a hunted-down n18 migration verdict bug.
- Evaluated and rejected a RocksDB store; wrote the reflections + human-effort-estimate notes.
- Began the **Lean 4** layer: formal verification of the `getK` leaf recurrence + Grundy semantics
  (phases 1 & 2 complete, `no sorry`).

## Week 3 — Jun 28 – Jul 4 · Theory pivot: nimbers, Node-Kayles, sum-free

- Reframed Queens as the **A344227** nimber problem; computed G(14)=0, G(15)=1, G(16)=0, G(17)=2 and
  resolved the **n=18 outcome** (first-player win, opening I9); prepared the OEIS submission package.
- Broadened into CGT theory: solver-theory targets, CGT-adjacent targets, placement-games primer,
  n=20 winning-geometry probes, connections deep-dive, external review/backlog.
- **Node-Kayles day (Jul 4):** the Cayley outcome law, pairing lemmas, `C_n^k` = octal-game family,
  the fast octal engine, analytic plan — the substrate theory the cap program later reuses.
- **Sum-free opening (Jul 4):** the sum-free and cap-set game definitions + first theorem sketches
  and variants; border-signature mining scripts for the queens geometry.

## Week 4 — Jul 5–9 · The projective-cap program

- **Sum-free theorems land (Jul 5):** the `Z_n` mod-6 law, the abelian 2-rank criterion, `F₃ⁿ = N`,
  `Z₂×F₃ᵇ = P`, the affine cap theorem — with the **socle-reduction = FALSE** counterexample
  (`Z₃²×Z₇ = P`) pruning the tempting shortcut; qeven/qodd plane theorems; parallel sum-free solvers.
- **gridcap + projective handoff (Jul 6):** wrote the standalone PG(2,q) grid-cap solver, the frame
  reduction, the size-3 escape crux, conic localization, and the qodd mirror-obstruction findings.
- **Proof infrastructure (Jul 7):** the named-expert-personas system, the kernel proof notes, the
  Nofil-connection framing, the codex task queue, and the arc-census / PGL-orbit / certificate
  scaffolding.
- **Compute campaigns (Jul 8):** the **S4 memo-dump / query / mining toolchain** + its manual;
  intrusion / mirrorgood / zone-steering censuses; the C30 route-C certificate books; C32 killing the
  composite mirror; the handoff refactored to a current-state map.
- **Harvest + kernel + framing (Jul 9):** new P-families via the fpf mirror — hyperbolic quadric
  (C48), symplectic `W(2n−1,q)` (C51), Segre products (C52), all with Lean; the full-PGL bridge (C53)
  clearing q=23; `TrapConverse` closing the escape equivalence in Lean (C41); the **conic⊕zone
  decomposition proven FALSE** (C35), redirecting the kernel to a coupled maintenance invariant;
  tablebase distillation / remoteness / type-census diagnostics (C36–C42); the Node-Kayles
  double-encoding gap **CLOSED** in Lean; and the deliverables proposal + line-capacity novelty vet.

---

*Snapshot; the live task frontier is the codex task queue and the projective-cap handoff.*
