# Work Summary — Week-by-Week Timeline

Companion to [`2026-07-09-work-summary.md`](2026-07-09-work-summary.md) (the timeless scope report).
Activity spans **2026-06-14 → 2026-07-10** — four-plus working weeks, with a quiet stretch Jun 28–30.
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

## Week 5 — Jul 10 · Rounds 1–2: the L(A) route emerges

- **Codex program assessment adopted (morning):** the (ON)-vs-conjecture bifurcation
  pre-registered into C44; C70–C72 queued; the C61 successor reframed *existential*
  (admissible-reply set over incidence data, no more deterministic argmin rules).
- **Four parallel Opus sub-tasks:** the C44 off-conic rider (worst-class fallback margin `8 → 4`,
  co-depletes with the on-conic layer at q=17); **C70** (exact collision charge
  `M = E + delta0col` proved — the Ψ truncation hides a deterministic `(q,ply)` drift, not a
  reply discriminator); **C71** (the 2→3-intruder transition is NOT center-geometric; the missing
  coordinate is the labelled live-cell embedding; `dΨ = [6·dC−4] + [dReservoir−2·dXor0]` exactly;
  `D(z)=∅ ⇒ dC ≤ 0` proved); **C72** (no harmonic identity for `f_q`; exact gift
  `f_q ⊥ V₁⊕V₂⊕V₃`).  Synthesis: the only reply-varying quantities in `dΨ` are **kill-set
  incidences** — three independent tasks converged on the same coordinate.
- **Codex round 1 (verified before adoption):** the involutive-completion lemma (15 constructions
  per five-frame); `fiber(B) = 30(q−1)/|Stab(B)|`; the **q=17 (ON) statement PROVED from bucket
  stabilizers** (capacity 15 > q−4 = 13) — the first structural explanation of the knife edge;
  stabilizer-specialness ⇒ P refuted; the q=17 **secant packet** found (all five P escapes of
  each knife-edge class on one line through the on-conic witness).
- **C73 (Opus):** the packet made value-blind — `L(A)` = the max-legal-incidence secant carries a
  P escape **68/68** across q=11–19 (q=17 null base 49% → 100%); witness-anchoring refuted;
  label-blind q=25 test pre-registered.
- **Codex round 2 (verified):** the `L(A)` algebra completely solved — the involution pencil
  `τ_a(t) = a/t` minus the pair products `P2(U)`, `nlegal = q − d`, with the tie theorem via
  `Stab(A)` involutions retro-explaining every observed tie; the stabilizer-capacity route closed
  by the ≤ 838 counting bound; the kill-set top-k ≤ 4 rule refuted at q=23 (11 exact failures in
  7 rigid classes → **generic discharge + explicit exceptions** becomes the selector program's
  form); the tied-line **concurrence point** P 10/10; the label-blind q=25 fan matrix forcing
  **`min-witness(25) = 0 or ≥ 3`** (pivot bucket 14; Veronese point `(1:15:9)` frozen as
  predicted P).  Route **(L_forall)** named; the sharpest open lemma is now the **one-intruder
  pencil N-absorption statement**.
- **q=25 census** (8 GB `s4arena`, hours-scale) running throughout: 9/28 buckets labeled, all P.
  Prize recalibrated ~35–45% eventual, upper half riding on the q=25 unblind.

---

*Snapshot; the live task frontier is the codex task queue and the projective-cap handoff.*
