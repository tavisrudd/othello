# Sum-free game: compute-side work (run in parallel with Codex)

**Date**: 2026-07-05
**Created by**: 2026-07-05--4 (`2bf7abb3-c0ff-48a2-9c80-e08a4acfe74f`)
**Purpose**: The heavy-compute + solver-engineering half of the sum-free-game push, to run
alongside Codex's theory/proof work without colliding.

---

## Context

The **sum-free achievement game** on a finite abelian group `G`: players alternately add elements
keeping the chosen set sum-free (no `a+b=c`, `a=b` allowed); last to move wins (normal play).
`N` = player-to-move (1st) wins, `P` = 2nd wins.

Session 2026-07-05--4 **disproved the socle reduction**: `Z3²×Z5 = N` but **`Z3²×Z7 = P`**, both
rigorous (two independent sound solvers agree). Since `G[6]=Z3²` (=N) for both, this kills
`𝒢(G)=𝒢(G[6])` and "odd `G` w/ 3-torsion ⟹ N". Read first:
- `notes/2026-07-05-socle-reduction-FALSE.md` — the full finding, data, and open question.
- The **RESUME HERE** block in `notes/handoffs/2026-07-04-node-kayles-games.md` — thread umbrella.

**Codex is running the theory half** (`notes/2026-07-05-codex-assignment-sumfree-socle.md`, top
banner): (1) settle the conjecture **`Z3²×Z_p = N` iff `p=5`, else P**; (2) reverse-engineer the
adaptive `Z3²×Z7=P` win (it's non-pairing); (3) re-derive the correct `s₂≤1, r₃≥2` classification.

**This doc = the compute half**, which produces the data/tooling Codex needs and pushes the solver
past the brute-force wall. Codex proves; this session computes.

## Scope

**In scope:** solver engineering, outcome/nimber data generation, strategy-dataset extraction,
soundness harness, lit check. **Own the Go solver** (`notes/sumfree-go/`) — Codex treats it read-only.

**Out of scope:** the proofs themselves (Codex's job — don't duplicate); OEIS submission (USER-only);
editing the shared solver files in a way that would break Codex mid-run (put new tools in NEW files).

**Hard constraint:** the **G(17) queens nimber run** (`queens nimber 17 …`, ~8.5 GB) is still live on
the box. Keep every probe **≤~2 GB** and single-/few-core; monitor `free` and kill on pressure. Do NOT
OOM it. (A prior sweep here hit 8 GB and had to be killed — see the FALSE note.)

## Work Items

### TOP — break the P-proof wall via disjunctive-sum decomposition

Brute outcome is infeasible past `p=7`: `Z3²×Z11` blew past **100M canonical nodes / 8 GB** without
converging (P-proofs have no boolean cutoff). The lever:

- **A1. Component decomposition + Grundy/nimber.** The game **decomposes as a disjunctive sum over
  armed-Schur-hypergraph components** (verified, per the node-kayles handoff). Compute the **Grundy
  value** of each component and XOR (Sprague–Grundy); a P-position is Grundy 0. This can collapse the
  100M-node outcome proof AND yields **nimber tables** (strictly richer than win/loss — Codex's old
  "Attack 2" wanted these). *Done =* `Z3²×Z11` and `Z3²×Z13` outcomes settled **rigorously**, plus a
  nimber table over the `s₂≤1, r₃≥2` family.
- **A2. Cheaper stackable solver wins** (if A1 is too big to start): **2-word masks for `|G|≤128`**
  (halve TT memory vs the current `[4]uint64`), **move ordering** (most-forcing child first), and
  **ABDADA-style in-flight markers** to kill the parallel version's ~20% redundant re-expansion
  (`sumfree_par` inflated p=7 from 837K→1M nodes). *Done =* one more rigorous `p` than brute reaches.
- **A3. N-detection sweep.** N-cases cut off early (at the first winning opening). Run a fast,
  time-boxed sweep across many `p` (17,19,23,25,29,…) purely to **hunt any `p>5` that is N** — a single
  such find breaks the `iff p=5` conjecture. Pure compute; high value if it hits.

Extend beyond `Z3²×Z_p`: `Z3³×Z_p`, `Z9×Z3×Z_p`, `Z3²×Z_{p²}`, `Z3²×Z_{pq}` — build the table Codex
needs to find the real law.

### PARALLEL — adaptive-strategy dataset for `Z3²×Z7` (feeds Codex #2)

- **B1. Make `--strategy` feasible.** It currently times out (the full 2nd-player strategy-tree walk
  is as expensive as solving). Bound it / reuse the warm TT / decompose. Emit the 2nd-player reply
  function as a **structured dataset**: `(position-features, opponent-move, chosen-reply)`.
- **B2. Auto-invariant search.** From that dataset, search for a **conserved quantity** `f: positions →
  Z_k` that the winning strategy preserves (the analogue of the "even obstruction count" that proved
  the mod-6 and `Z2×F3ᵇ` results). Compute finds candidates; Codex proves the right one.
- **Seed data already extracted** (Go `--openings --start`, `Z3²×Z7`, 2nd-player winning replies):
  socle opening `(0,1,0)` → 36 replies = exactly the mixed `(w,c)` with `w` **off** the socle-line
  `⟨(0,1)⟩` and `c≠0`; **mixed** opening `(1,0,1)` → negation `(2,0,6)` **is** a reply; **coprime**
  opening `(0,0,1)` → negation `(0,0,6)` is **NOT** a reply.

### SIDE

- **C. Explain the `p=5` exception.** Extract the **1st-player** winning strategy for `Z3²×Z5` (it's N)
  and compute **max-sum-free-set sizes/parities** across the family — likely reveals why `p=5` is
  sporadic (small-`|G|` coincidence vs a real residue).
- **D. Soundness insurance.** A differential harness cross-checking the **Go solver vs Python
  `sumfree_solver.py`** across a battery of groups. We have 2-solver agreement on p=7; broaden it so the
  whole finding is bulletproof (everything rests on the solvers being correct).
- **E. Lit check.** WebSearch / `deep-research`: are sum-free / Schur **achievement** games on abelian
  groups — and the `N iff p=5` phenomenon — already in the literature? (Impartial-SET is a *removal*
  game; ours *builds*. Neighbours already cited in the umbrella.)

## Codebase Reference

| What | Where |
|------|-------|
| Go solvers (own these) | `notes/sumfree-go/sumfree.go`, `cmd_par/sumfree_par.go` |
| Build | `cd notes/sumfree-go && go build -o sumfree ./sumfree.go` / `go build -o sumfree_par ./cmd_par/sumfree_par.go` |
| Existing Python sound solver | `notes/sumfree_solver.py` (`--canon auto`; slower, independent) |
| Cyclic Grundy solver (Z_n only, u128) | `notes/sumfree-solver/sumfree.rs` — pattern for a Grundy engine |
| The falsification write-up | `notes/2026-07-05-socle-reduction-FALSE.md` |
| Codex's brief (their lane) | `notes/2026-07-05-codex-assignment-sumfree-socle.md` |
| Thread umbrella / RESUME HERE | `notes/handoffs/2026-07-04-node-kayles-games.md` |

## Principles / Constraints

- **Validation gate for ANY solver change** — must still reproduce: all cyclic `Z_n` = mod-6 theorem
  (P iff `n≡0,1,5`); `Z3²×Z5=N` with the **8 socle openings**; `Z3³=N`; `Z2×Z3²=P`; `r₃=1` peels
  `Z3×Z5/7/11/13` all N; and **`Z3²×Z7=P`**. A change that breaks any of these is wrong.
- **Memory: ≤~2 GB, protect G(17).** Monitor `free`; kill probes on pressure.
- **No rustc/LLVM builds** while the box is tight (OOM risk) — Go compiles are light and fine.
- **Coordination:** new tools in **separate files** (don't edit the shared solver Codex depends on
  mid-run); commit repo + handoff updates; OEIS stays USER-only. Bench/verify hygiene per project
  CLAUDE.md.

## Delegation

- **Can delegate to sub-agent?** Partly. A1 (decomposition/Grundy engine) is the crux — keep on the
  main thread or a strong sub-agent; it's design-heavy. B2 (invariant search), C, D, E are clean
  sub-agent tasks once the data/harness exists.
- **Model**: Opus for A1/B1 (design); Sonnet fine for D/E and running sweeps.
- **Notes**: A1 first — it unblocks the most and produces the nimber data Codex wants. If A1 stalls,
  A2 gets one or two more rigorous `p` and A3 hunts a conjecture-breaker cheaply.

---

## Progress

### ★ RESUME HERE (next session)

**2026-07-06 UPDATE (compute session `--7`, `mi`): boolean solver `sumfree.go` UPGRADED (preallocated arena +
move ordering + opt-in parallel) — the OOM is FIXED; `Z3³×Z5` (the r=3 datapoint) is now runnable and IN
PROGRESS; p=11 Lemma A/B direct solve confirmed COMPUTE-INFEASIBLE.**

- **★ `sumfree.go` engine upgrade** (the user's "if go, optimize it + use a preallocated arena"): replaced the
  OOM-prone `map[Mask]bool` TT with a **preallocated 128-bit fingerprint open-addressing arena** (~17 B/entry,
  GC-invisible, sharded) — constant tiny RSS (`Z3³×Z5` runs at ~0.7 GB, not the >10 GB the map hit at |G|=135).
  Added **move ordering** (most-forcing-first): −50% nodes / −59% wall on `Z3²×Z7` (836,807→414,168 nodes,
  11.9→4.8 s), deterministic; arena verified node-identical (order-off = exact 836,807). Added **opt-in
  parallelism** (`-j N`, `-j 0`=all; sound YBWC — eldest son sequential preserves the α-β cutoff, younger
  brothers fork). Default stays **serial+ordering** (deterministic). Race-detector clean. Validation gate held
  (mod-6 law; `Z3²×Z5=N`+8 socle openings; `Z3³=N`; `Z2×Z3²=P`; r₃=1 peels `Z3×Z{5,7,11,13}=N`; `Z3²×Z7=P`).
- **Parallelism is transposition-bound** (as expected — the queens lesson): deep recursive forking re-expands
  shared transpositions (2–3.4× node inflation on the shallow `Z3²×Z7`). But the DEEP heavy target `Z3³×Z5`
  (|Aut|=44,928/node) parallelizes well at a shallow fork horizon (`--par-ply 10`): ~22 cores, only ~1.1×
  re-expansion, ~9× throughput — its wide top has low cross-branch sharing. `-j 0` for wall-time; serial for
  determinism. A bigger parallel win would need ABDADA-style in-flight markers to stop the re-expansion.
- **★ `Z3³×Z5` (r=3 datapoint) IN PROGRESS** — the case that was OOM-infeasible for both `grundy` and
  `sumfree_par` now runs at ~0.7 GB. Big P-proof (no root cutoff); ~23M nodes and climbing, no verdict yet.
  `Z3³×Z7` is the next r=3 datum. This is Tactic 2's base pattern (see Codex banner).
- **p=11 Lemma A/B direct solve = COMPUTE-INFEASIBLE** — `{(0,0,1),(0,1,1)}` and `{(0,1,0),(1,0,1)}` on
  `Z3²×Z11` ran to >188M / >197M canonical nodes with zero convergence (nodes≈memo, no cutoff), ~10 GB RSS each
  before I stopped them to avoid OOM. The arena+ordering upgrade extends reach (it cracked `Z3³×Z5`, |G|=135)
  but these 2-element P-proofs on |G|=99 are a bigger distinct-position space. The two-lemma reduction is
  already a theorem at p=5,7 and does NOT need p=11 (session `--5`) ⇒ its p≥11 confirmation must come from the
  adaptive-strategy PROOF, not a solve. Recorded in Codex's brief RESULTS line.
- **Codex re-tasked** (new top banner of `2026-07-05-codex-assignment-sumfree-socle.md`): engine-upgrade news,
  the p=11-infeasible RESULTS, and the NEW lever — build the **induction-on-3-rank-`r`** step ahead of the
  `Z3³×Z5` verdict (heuristic-2 "N iff r=1" predicts P via one more free `O₃` pair per `F₃` factor). Standing
  analytic targets unchanged. Run logs: `notes/2026-07-06-z3cubed-z5.log` (+ the killed `lemma{A,B}-p11.log`).

---

**2026-07-06 UPDATE (session `--6`, `mi`): TACTIC 1 CLOSED (no mirror proof); the strategy is provably
adaptive; the NEW lever is the `r=3` parity datapoint (compute-blocked — needs a TT-capped engine or a
free box). I own both lanes (Codex + proj-cap agent are the only others; stayed clear of proj-cap files).**

- **★ Tactic 1 (residual strictly-matched involution) — TESTED AND CLOSED.** Built + validated a
  residual-mirror verifier (`../2026-07-06-r32-residual-mirror.py`; validated against the mod-6 theorem:
  negation mirror certifies `n≡1,5`, fails `n≡3`; translation mirror certifies `n≡0` via defect-solve).
  Exhaustive at `p=7` over all 368 affine involutions, all 3 openings: **(i) pure fpf = 0 certs; (ii)
  strictly-matched self-blocking clique = 0 certs; (iii) mirror + defect-substitution (exact-solve the
  bounded defect branches) = BREAKS** on the best affine involution over a *true* P-reply board
  (`{socle,mixed}=∗0`, `verify ok=False`, a defect branch is Bob-losing). Clean reason: the socle
  opening's **36 P-replies are all MIXED**, and **no sum-free-preserving (linear `Aut(G)`) involution
  fixes a socle+mixed board except identity** (0/6). The nontrivial invariant involutions are all
  **affine** (`b≠0`/`β≠0`) → don't preserve the Schur relation `a+b=c` → their mirror breaks. Writeup:
  the `★ UPDATE` banner atop [proof-tactics note](../2026-07-06-sumfree-proof-tactics-litsearch.md).
- **★ Swap-diagonal / "square" story FALSIFIED.** The best mirror backbone is swap-diagonal + negation
  `π(v,y)=(v_swap,−y)` (Brandenburg square mirror), reply `swap(s)` — but it fixes only **non-P** boards
  cheaply (`{socle,socle}=∗3=N`) and its defect set grows with `p` (structured on the `⟨socle-line⟩`
  fibers `(0,±1,∗)`: 2189 defects/p=7 from `{s0,t}`, 32K from `∅`). Decisive kill: **`F₃²=∗1=N` alone**
  (checked), so `Z3²×Z_p=P` is NOT because `F₃²` is a square — the `Z_p` interaction is what flips r=2.
- **★ NEW structural observation → the `r=3` open test.** Outcome of `Z3^r×Z_p` (`p≥7`) is **P, N, P for
  `r=0,1,2`** (`Z_p`=P by mod-6; `Z3×Z_p`=∗1/N; `Z3²×Z_p`=∗0/P) — NOT the pure-3-group pattern (`F₃^r`=∗1/N
  ∀`r≥1`), so the `Z_p` factor flips r=0,2 to P. **Two competing heuristics disagree at `r=3`:** (1) naïve
  *alternation* P,N,P,N,… ⇒ `Z3³×Z_p`=N; (2) the *monotone-resource* view — the actual r=1→r=2 mechanism is
  "each extra `F₃` factor hands Bob one more independent `O₃` pair, pushing the socle opening OFF `∗0`," which
  is monotone ⇒ r≥2 all P ⇒ law **"N iff r=1"** (cleaner, matches "r₃=1 always N"; r=0 P, r=1 N special).
  **Heuristic (2) is better-grounded** (it's the proven reason r=2 is P; (1) is 3-point curve-fitting). So
  `Z3³×Z_p` is genuinely open, most likely **P**. The handoff's earlier "P-suspected" for `Z3³×Z{5,7}` is
  only a timeout, not a solve — but it lines up with heuristic (2). **Compute-BLOCKED:** grundy per-node cost `∝|Aut(Z3³×Z_p)|`
  (`|GL(3,3)|·(p−1)=11232·(p−1)`, e.g. 44928 at p=5); the boolean `sumfree.go` has α-β cutoffs but its
  **uncapped `map[Mask]bool` TT OOMs** at `|G|=135` (`Z3³×Z5`) — I aborted a run at 1 GB free to protect
  the proj-cap job. **FIRST NEXT-SESSION ACTION (revised):** get the `Z3³×Z5` (then `Z3³×Z7`) **root
  outcome** — needs (a) a **TT-capped / fingerprint-arena boolean solver** (small edit to `sumfree.go`:
  bound the map or reuse the grundy arena) run on a **free box**, OR (b) the 3-orbit reduction restricted
  to just the socle-opening outcome (`is {socle}=∗0?` = the canary; but that's still a P-proof one level
  down). A confirmed `Z3³×Z_p=N` would flip "P-suspected" and give Tactic 2 (induction on `r`) its base
  pattern. This is the highest-value next datapoint.
- **Live tactics after Tactic 1's close:** **Tactic 2** (induction on 3-rank `r`, needs the `r=3` datapoint)
  and **Tactic 3** (adaptive safe-class closure — Codex's colored-fiber `(defect,pair)` invariant, now THE
  analytic route). Do NOT re-run mirror/pairing searches (closed 3 ways) or the `p=11` brute solve (OOMs).

---

**2026-07-06 UPDATE (session `--5`, `mi`): the r₃=2 reduction is SOLID; the "clean p-uniform lemma" HOPE is in
doubt; Codex is OUT OF TOKENS (next session owns both lanes).**

- **What's rock-solid (committed):** the reduction `𝒢(Z3^r×Z_p)=mex{n_soc,n_cop,n_mix}` (uniform in `r`; `Aut`
  gives exactly 3 orbits), so **`P ⟺` each opening is N `⟺` each opening has a P-reply**. Verified p=5,7. The
  `p=5` exception localizes to Lemma A. The socle opening is the governing "canary" (∗0 always at r=1 ⇒ N;
  ∗0 only at p=5 for r=2 ⇒ P for p≥7). This is the session's durable contribution.
- **What got KILLED this session:** Codex's Lemma-B **zero-sum-triple** route (`Bob replies r=−s−t`) — a p=7
  coincidence: triple `{s,t,−s−t}` is `∗1`/all-P at p=7 but **`∗6`/mixed at p=11** (full engine, no 60s cap).
  Codex independently confirmed (CRT table + mirror-cert probes 0/46 + α-reflection is only a diagnostic).
  **Lesson banked:** every candidate lemma is a p=7 coincidence risk — stress-test past p=7 BEFORE writing a proof.
- **The now-suspect claim (VERIFY FIRST):** my own "p-uniform representatives" (Lemma A `{(0,1,0),(1,0,1)}`,
  Lemma B `{(0,0,1),(0,1,1)}` with fiber `c=1`) were **only verified at p=5,7** — same coincidence risk.
  **⚠ DIRECT p=11 VERIFICATION IS COMPUTE-INFEASIBLE with the current engine.** A `grundy 3,3,11 --start
  "0,0,1;0,1,1"` race (parallel grundy + boolean) ran **96 min without converging** and **ballooned to 9.1 GB**
  (grundy) + 3.3 GB (boolean) before I killed it for memory safety — the `Z3²×Z11` non-convergence regime the
  box-hygiene notes warned about (unbounded distinct canonical positions; fingerprint memo grows without bound;
  P-positions have no boolean cutoff). So **"get the p=11 value" is NOT a plug-and-play action** — the engine
  needs a step first. Options: (i) **stronger canonicalization / compiled port** (the arena grows because too
  many positions are canonically distinct at p=11), or a `GOMEMLIMIT`-bounded run (may not finish); (ii) a
  **targeted N-witness** (find one P-reply `{(0,0,1),t}=∗0`) — but each such check is itself a full P-proof that
  blows up the same way; (iii) **lean on the theorem + indirect evidence**: the *reduction* is a theorem (p=5,7)
  and does NOT need p=11, and `Z3²×Z11=P` has indirect support (boolean N-hunt from `∅` timed out p=11..23 =
  consistent-with-P). Honest status: **the "p-uniform c=1 representative" is UNCONFIRMED past p=7 and currently
  uncheckable** — treat "two clean p-uniform lemmas" as p≤7 packaging, NOT established fact.
  **★ FIRST NEXT-SESSION ACTION (revised): improve the engine (canonicalization/compiled port) OR pursue the
  tactic-1 residual-involution PROOF route — do NOT just re-launch the p=11 brute solve (it will re-OOM).**
  If the engine is improved, the three outcomes to distinguish for Lemma B at p=11:
  1. **Lemma B = ∗0 at p=11** ⇒ the representative survives; then dump its first-layer P-replies at p=11 and
     find the (likely p-DEPENDENT, not uniform) structure. Reduction confirmed for the coprime opening at p=11.
  2. **Lemma B ≠ ∗0 but coprime opening still N** (some *other* P-reply is ∗0) ⇒ the `c=1` rep was a p=7
     coincidence; the reduction still holds but there is **no uniform representative** — the openings-are-N
     proof is adaptive/p-dependent (back to the hard core, but existential). Rewrite the two-lemma framing.
  3. **Coprime opening has NO P-reply at p=11** ⇒ it is ∗0 ⇒ root=N ⇒ **`Z3²×Z11=N`, conjecture FALSE at p=11**
     (unlikely — indirect evidence `Z3²×Z_p` boolean N-hunt timed out p=11..23 = consistent-with-P — but not
     ruled out; would be a major finding). Verify with a second solver before believing.
- **The honest picture going forward:** the P-replies are looking **adaptive / p-dependent**, not clean fixed
  pairings (no `Aut(G)` involution fixes `{s,t}`; the α-reflection couples through F; the zero-triple died).
  Lemma A is the hard case (trivial stabiliser, no mechanism); Lemma B had two handles, both now shown
  insufficient. The *reduction* is the win; the *lemmas* bottom out at the same adaptive core as the warm-up,
  just existential instead of universal.
- **★ TOP PROOF LEAD (lit search, session `--5`):** [proof-tactics report](../2026-07-06-sumfree-proof-tactics-litsearch.md)
  — **Tactic 1: strictly-matched involution on the RESIDUAL** (Andres–Huggan–Mc Inerney–Nowakowski, TCS 2019 /
  Algorithmica 2022): drop fixed-point-freeness; a mirror works if the involution's fixed set is a **self-blocking
  clique**. This is EXACTLY the O₃ pair `{s,2s}` the socle seed already consumes. Every closed involution attacked
  `∅`; the reduction only needs the *residual* to mirror. **Concrete untested experiment:** search for an affine
  reflection `σ(x)=c−x` on the post-seed residual whose only non-mirrorable points are the seed-neutralized
  O₃-clique — a generalization of the team's proven `F₃ⁿ`/`Z₂×F₃ᵇ` mirrors. (Tactic 2: induction on 3-rank r via
  the orbit reduction. Tactic 3: adaptive safe-class closure + Walnut automatic-proofs for base cases.) This is
  the highest-value next lever — a PROOF route that sidesteps the compute-infeasible p=11 brute solve.
- **NEXT-STEP QUEUE (compute lane, next session):** (a) ★★ **pursue Tactic 1** (residual involution with a
  self-blocking clique core) — proof, not brute force; (b) engine upgrade (stronger canon / compiled port) IF a
  p=11 datapoint is still wanted — the current engine OOMs on it; (c) if a lemma is confirmed, characterise its
  p-dependent P-reply structure (Codex's asks: test `−a−s+t`, `−a+2s−2t`); (d) the **r=3 extension**
  (`Z3³×Z_p`: same 3-orbit reduction, only needs the 3 *opening* outcomes — sidesteps the blocked full solve);
  (e) the deep target — an adaptive monovariant proving "each opening is N", shared with the warm-up ∗1-absent
  core. Codex's postmortem + scripts (`r32-*-mine.py`) are the reverse-engineering substrate. Full data: [nimber-engine note](../2026-07-05-sumfree-nimber-engine.md)
  §§"2026-07-06 (session `--4`)" and the zero-triple/unification subsections; [codex-findings](../2026-07-05-codex-findings-sumfree.md)
  §"R3=2 Doc Check". Below is the (still-current) `--4` state.

**2026-07-06 UPDATE (session `--4`, `mi`): the MAIN conjecture (r₃=2) reduced to TWO 2-element P-lemmas — an
EXISTENTIAL target, easier than the warm-up.** While Codex works the warm-up ∗1-absent proof, compute took the
banner's "PARALLEL / NEXT TARGET" — `𝒢(Z3²×Z_p)=P` (p≥7). **Rigorous reduction:** `Aut=GL(2,3)×Z_p^*` ⇒ 3
first-move orbits ⇒ `𝒢(root)=mex{n_socle,n_coprime,n_mixed}` ⇒ **`P ⟺` each opening is N `⟺` each opening has
a P-reply `{s,t}=∗0`** (existential — one good answer each, vs the warm-up's *universal* ∗1-absence). The mixed
opening reuses the socle P-position, collapsing it to **Lemma A `{socle,mixed}=∗0`** (⟹ socle+mixed N) and
**Lemma B `{coprime,mixed}=∗0`** (⟹ coprime N); both ⇒ P. **The `p=5` exception is SHARP: only Lemma A breaks
(∗3 not ∗0 at p=5)** — exact analogue of the warm-up's `{p,1}=∗1/p≥7, ∗3/p=5`. Verified p=5,7 (both engine +
p=5 discriminator); **p=11,13 running** (slow 2-element solves). No `Aut(G)` involution fixes `{s,t}` ⇒ the
mirror is residual/adaptive (Codex's lane); proof hint = the order-3 socle seed **consumes one O₃ pair**
(`−s=2s` forbidden), the exact resource that killed the whole-board mirror for r₃≥2. Full writeup:
[nimber-engine note](../2026-07-05-sumfree-nimber-engine.md) §"2026-07-06 (session `--4`)"; Codex banner's
r₃=2 target rewritten to the two lemmas; new tool `grundy --preply` (full P-reply dump) + script
`../2026-07-06-r32-reply-mirror.py` (extracts Bob's winning-reply function). **NEXT (compute):** land p=11,13
Lemma A/B; extract the reply function to hand Codex the adaptive-mirror structure; the same orbit reduction
lifts to `Z3³×Z_p`/`Z9×Z3×Z_p` (r₃=3, more orbits). Below is the (still-current) `--3` state.

**2026-07-06 UPDATE (session `--3`): ∗1-absent half LOCALIZED; the fixed-pairing route is CLOSED.** The
compute lane mapped the obstruction and killed the two natural elementary routes (writeup:
[nimber-engine note](../2026-07-05-sumfree-nimber-engine.md) §"2026-07-06 (session `--3`)"; scripts
`../2026-07-06-sumfree-*.py`; second independent solver cross-checks the Go engine). (1) **Mirror-break
lemma** (exhaustive, p=7,11,13): for any single-defect board `{p}∪S∪{d}` the legal `z` with `−z` illegal are
EXACTLY the ≤3 negations of the defect-blocks `{2d, d+p, d·2⁻¹}` — the whole obstruction is *three* blocks.
(2) **The single-token pairing/mirror strategy is DEAD** — the mirror reply isn't value-preserving (`{3,7}=∗1`
but mirroring lands on `{1,3,7,20}=∗3`, since `σ` moves `p↦2p`), and a single break-move double-blocks both
mirror and migrate replies (`{1,3,7,20}`+`9`); exhaustive minimax STUCKs at p=7,11,13,17. ⇒ `𝒢({p,e})=∗1`
holds **only via adaptive (non-mirror) play** — the sole surviving avenue, handed to Codex (banner Round-7).
(3) A **static-signature monovariant is ruled out** (∗1 = ~40% of positions, every signature). NEXT: the
non-mirror adaptive strategy (à la `Z3²×Z7`), controlling the three defect-blocks — NOT more brute sweeps,
NOT pairing. Codex owns the proof; compute is the oracle. Below is the (still-current) `--2` state.

**2026-07-06 UPDATE (session `--2`): the warm-up is down to ONE open statement — the ∗1-absent half.**
The **∗0-present half is CLOSED** (proven, uniform): `{p,k,−k}` = ∗0 for any non-order-3 `k` by the
proven Fact C, so `{p,3,−3}`/`{p,1,−1}` are exception-free ∗0-children — this **supersedes** Codex's
AP-mirror `6−p`/`(p+1)/2` route and its `p=29` sporadic exception (proof:
`../2026-07-05-sumfree-warmup-reduction.md` §"The ∗0 present half — CLOSED"). The Codex Round-6 banner
(top of `../2026-07-05-codex-assignment-sumfree-socle.md`) is rewritten to drop the AP-mirror route and
point straight at the **sole remaining crux, the ∗1-absent half**: for `p≥7`, no child of `{p,1}`/`{p,3}`
is ∗1. Two supporting findings this session (details in the [nimber-engine note](../2026-07-05-sumfree-nimber-engine.md)
2026-07-06 addendum): (1) **the missing-∗1 is a *connected-graph* mex fact, NOT a decomposition one** —
at `p≥11` the children of `{p,1}`/`{p,3}` are single connected components, so the disjunctive-sum handle
does not fire (the p=7 ∗1-pairing was a small-`|G|` artifact); this rules out a component argument for
the ∗1-half. (2) **the AP-child exceptional-branch replies are non-mirror and not a uniform `p`-linear
formula** (confirmed `{p,3,6−p}`, `y∈{2,4,p+2,p+4}`, p=11,13,17) ⇒ Codex's residue needs a structural
descent, not a lookup. New tool: `grundy --compdump`. Below is the pre-existing (still-current) state.

The prior session (`--7`) inherited **compute + the proofs** when Codex was out of tokens. State of the
open problem:

- **Two conjectures, both very likely true, neither proven.** (1) Warm-up `𝒢(Z3×Z_p)=∗1` (p≥7);
  (2) main `Z3²×Z_p=P` (p≥7). Both reduce to a clean **spectral criterion**: a position's Grundy is
  forced because its child-value spectrum *contains* the needed value and *misses* another. See the
  full picture in [`../2026-07-05-sumfree-nimber-engine.md`](../2026-07-05-sumfree-nimber-engine.md)
  and Codex's reasoning in [`../2026-07-05-codex-findings-sumfree.md`](../2026-07-05-codex-findings-sumfree.md)
  (Round-4/5 sections).
- **Warm-up reduction — now RIGOROUS down to one lemma** (session --7, [warmup-reduction note](../2026-07-05-sumfree-warmup-reduction.md)):
  re-derived from the **PROVEN** mirror Lemmas 1&4 (not heuristic). Facts B/C/D: symmetric+order-3-dead
  ⇒`∗0`; symmetric+order-3-alive ⇒ a `∗0` child; symmetric mex reduction. Gives root`=∗1` ⟺
  `G({p,1})=G({p,3})=∗1` (two-move lemma). **Verified the lemma BREAKS at p=5** (both `∗3`, not `∗1`) —
  exactly why `G(Z15)=∗2` (the order-p singleton `{3}=∗1` there). So the lemma is a sharp `p≥7` statement.
- **`{p,1}` branch AP-child `(p+1)/2` — CHECKED past p=19 (was the open TODO): holds `∗0` for p=17,19,23,29,31**
  (session --7, full engine; p=31 = 106M nodes). Does NOT break — asymmetric with `{p,3}` (which broke to `∗4` at p=29).
- **`{p,3}` branch is the hard one (--5b/--7):** `c=6-p` is `∗0` for p=11..23, `∗4` at p=29, **`∗0` again at
  p=31** — a *sporadic* finite exception set {7,29}, NOT a permanent break (revised --7). Mirror cert fails;
  the `∗0`-witness is "AP-child + finite exception book," matching Codex's route (the "`∗1` absent" half is
  the genuinely open part).
- **The real crux (both branches, unproven):** the "**missing ∗1** in the child spectrum," uniformly
  in p. Classic-hard (nimber non-values across an infinite family; values non-periodic). No line-of-sight
  proof. The **naive spare-`∗1`-token pairing is now closed** (--7): order-3 is a *destructible resource*
  (dies once `a+b=p` lands), so the opponent cashes the unspent token — a real proof must control this.
- **Tools ready:** `cmd_grundy/grundy.go` — fast (parallel) + memory-lean (fingerprint arena) nimber
  engine; `./grundy <mods> [--start a,b,c;..] [--children]` (`--children` = child-value spectrum).
  Validated on 50+ values. Confidence estimate (mine): conjectures true ~90%+; a *rigorous* warm-up
  proof ~45–55%; r₃=2 ~25–35%.
- **Next moves:** (a) ~~verify `{p,1}` AP-child past p=19~~ **DONE (--7): holds `∗0` to p=29**; (b) attack
  the "missing ∗1" — a structural invariant on the armed components forcing the spectral gap, not more
  data points (the compute wall is real: even the 3-element AP-child times out at p=31, `Z93`, ~70M+
  nodes; 2-element two-move worse); (c) for r₃=2, the orbit-child criterion. **Extended families are
  compute-BLOCKED (--7 finding):** `Z9×Z3×Z_p`, `Z3³×Z_p`, `Z3²×Z25` all intractable (boolean N-hunt
  times out ⇒ P-suspected/no-cutoff; grundy exact blows up, per-node cost `∝|Aut|` — `Z9×Z3×Z5` = 50M
  nodes no convergence). The r₃≥2 law needs **structure, not sweeps**.
- **The proof, not the oracle, is the bottleneck now.** The engine is a validated oracle but the family
  data it can reach is exhausted; the remaining work is analytic (the missing-∗1 invariant, or a
  non-mirror strategy à la Codex's adaptive `Z3²×Z7` win).

---

### 2026-07-05 — session `c5c3bf7d` (`mi`): A1 DELIVERED (nimber engine), Codex tasked

**Box freed:** the G(17) queens nimber run **finished** (`G(17)=∗2`, first-player win, a new A344227
term; 584 B nodes / 59 h) ⇒ the ≤2 GB constraint is lifted (17 GB free). Codex still active in `rust/`;
stayed in the `notes/` Go lane. A concurrent Claude session was editing `cmd_par/sumfree_par.go`
(strategy-extractor enrichment, the B2 lane) — kept fully clear of it by putting new tools in **new
command dirs**.

**A1 = DONE (the TOP item).** Built the Grundy/decomposition engine
`notes/sumfree-go/cmd_grundy/grundy.go`. Full write-up + data:
[`../2026-07-05-sumfree-nimber-engine.md`](../2026-07-05-sumfree-nimber-engine.md).
- **De-risked first** (`cmd_probe/decomp.go`): the decomposition **fires** — 84% of nodes split into
  ≥2 components (82–99% in the deep tail), the opposite of the queens component-nimber lever. Go.
- **Engine:** disjunctive-sum recursion, memoizes the canonical *armed Schur hypergraph* of each
  component under `Aut(G)`; size-1/2 fast path. **Validated on 50+ values** (Codex's whole Python
  Grundy table exactly + cyclic mod-6 nimbers `n=2..31` + theorem groups).
- **Key result:** **`Z3²×Z7 = ∗0` (P)** solved in ~30 s — Codex's Python couldn't finish it. Now
  confirmed a 3rd way, with the exact nimber.
- **Perf:** `GRUNDY_NOMULT` (drop `Z_p`-multiplier autos) = measured-NEGATIVE (+6× nodes; full `Aut`
  merging wins). size-≤2 component fast path = −34% wall. Per-node cost `∝ |Aut| ∝ p` is the wall for
  large `p` (memory is flat/tiny).

**Nimber data (Attack 2, delivered to Codex):** `𝒢(Z3×Z_p) = ∗1` for `p≥7`, `∗2` at `p=5` (verified
`p=7..19`; all N — a nimber law refining a known-outcome family). `𝒢(Z3²×Z5)=∗2`, `𝒢(Z3²×Z7)=∗0`.
**`p=5` carries `∗2` in BOTH families** — the sporadic `p=5` is a nimber constant, not an outcome
accident. `Z3²×Z{11,13,17}` **running** (memory-safe; steep node growth with `p`).

**Codex tasked** (Round-4 banner atop `../2026-07-05-codex-assignment-sumfree-socle.md`): stop building
solvers — *request any nimber from me*; prove `𝒢(Z3×Z_p)=∗1` (p≥7), `Z3²×Z_p=P` (p≥7) via the
component structure, and explain the `p=5 ∗2` cause.

### 2026-07-05 (cont.) — parallelize, fingerprint arena (memory fix), orbit-child data

**Engine hardening (all committed, all validated against the 50+ gate):**
- **Parallelized** (`-j`/`--par-ply`, sharded memo, select-based bounded fork): **5.7×** on `Z3²×Z7`
  (29.5→5.2 s), race-detector clean. Grundy has no cutoff ⇒ children compute concurrently.
- **Fingerprint arena memo** (the memory fix — user's "prealloc/arena it?"): replaced `map[ckey]int8`
  (64-byte key + bucket/GC/growth overhead) with a sharded preallocated open-addressing table keyed by
  a **128-bit fingerprint** of the canonical `(U,A_rel)`. **~10× less RAM** (`Z3²×Z7` 319→31 MB;
  `Z3²×Z11` was 10.7 GB on the map → arena stays lean). Sound w/ overwhelming probability (collision
  ~2⁻⁷⁰; the queens-TT argument). Pair with `GOMEMLIMIT` as an OOM guard. **Memory, not CPU, was the
  binding wall** for the full family — this lifts it, but large-`p` full games are still slow (no
  cutoff): full `Z3²×Z11` hit **40 M+ memo entries** and did not converge in ~30 min.
- **`--children`** mode: dumps a position's child-value spectrum (validated exact vs Codex's Z15
  histogram). Feeds Codex's spectral-gap approach.

**Key structural data delivered to Codex** (both handed to its Round-5 banner):
- **r₃=2 as an orbit-child spectral criterion.** `Z3²×Z_p` has 3 first-move orbits (socle/coprime/
  mixed); `= P ⟺ 0 ∉ {their nimbers}`. **p=5:** socle `∗0`, coprime `∗1`, mixed `∗1` → mex `∗2` (N);
  **p=7:** all three `∗2` → mex `∗0` (P). So the conjecture = "for p≥7 no orbit-child is `∗0`", and the
  **p=5 exception = the socle-child drops to `∗0`** (analogue of the r₃=1 order-`p` singleton being `∗1`
  at p=5).
- **Warm-up two-move lemma confirmed past Codex's p=23 solver wall:** `G({p,1})=G({p,3})=∗1` for
  **p=23, 29** (fingerprint engine). Large-`p` two-move subgames are ~25 min each (cyclic, no cutoff) ⇒
  brute ceiling ~p=29; the rest is Codex's spectral-gap proof, not more data.

**Collaboration state (Codex, in `rust/` sandbox, reports to `../2026-07-05-codex-findings-sumfree.md`):**
Rounds 4→5 productive. Codex reduced the r₃=1 warm-up to the two-move lemma, then to a **spectral-gap
invariant** ("the missing `∗1` in the child spectrum") with a finite-failure-set P-child for `{p,1}`.
**Codex is continuing now** on the analytic spectral-gap proofs (both the warm-up and the r₃=2 lift).

**Next steps (compute side, when resumed):**
1. On Codex request only — specific groups/positions via `./grundy <mods> [--start ..] [--children]`.
   The engine is the on-demand nimber oracle; Codex drives.
2. Deferred as low-value/expensive: full `Z3²×Z11+` nimbers (40 M+ memo, no cutoff — orbit-children
   already give the conclusion), r₃=3 family (`GL(3,3)` blows up `|Aut|`), larger-`p` two-move brute.
3. Open perf lever if ever needed: a faster full-`Aut` min-image (subgroup-reduction is closed
   negative). Not worth it now — memory was the wall and the arena fixed it.

**Handoff Note — session `2026-07-05--5` (`c5c3bf7d-11f1-48ab-aa12-e95878473236`), `mi`.**
Commits `21baa03` (A1 engine + probe) → `24cb5d5` (parallel) → `ecb872d` (fingerprint arena + Codex
R5) → `663401c` (`--children`) → `20f5c28` (orbit-child data + warm-up p=29). Files: `cmd_grundy/
grundy.go` (new engine), `cmd_probe/decomp.go` (new probe), `../2026-07-05-sumfree-nimber-engine.md`
(findings), `../2026-07-05-codex-assignment-sumfree-socle.md` (R4/R5 tasks). Validation gate held
throughout (cyclic mod-6 nimbers, `Z3²×Z5=∗2`/N, `Z3³=∗1`/N, `Z2×Z3²=∗0`/P, r₃=1 peels, `Z3²×Z7=∗0`/P).
**Not moved to done/** — Codex's proofs are in flight and the engine remains the standing compute oracle.
Left untouched (not mine): `cmd_par/sumfree_par.go` (concurrent Claude), `codex-findings-sumfree.md`
(Codex), the queens-lane files.

**Late-session addendum (--5b): two NEGATIVES on the warm-up `{p,3}` branch** (details in
`../2026-07-05-sumfree-nimber-engine.md` §`{p,3}` branch; passed to Codex's brief §C). Codex's Round-5
unified both two-move branches under an AP-mirror lemma with P-child `{p,3,6-p}` (`v=3`, `ρ(x)=6-x`).
Compute found: (1) **`c=6-p` is NOT a uniform P-child** — `∗0` for `p=11..23` but **`∗4` at `p=29`**
(deterministic; validated engine) — so the uniform-representative claim was a `p≤23` coincidence; (2)
**the finite-state mirror certificate fails at `p=11`** — for all 7 exceptional moves, no solver
P-reply makes the enlarged position invariant under any affine involution of `Z_{3p}` (all three
nontrivial checked; scripts `scratchpad/mirrorcert*.py`). The `{p,3}` win is genuinely non-mirror; its
two-move-lemma proof needs a different idea than AP-child + finite-exception reflection. Open compute
offers to Codex: re-check the `{p,1}` AP-child `(p+1)/2` past `p=19`; any specific position on request.

---

### 2026-07-05 — session `2026-07-05--7` (`f240444b`, `mi`): OWN BOTH LANES — reduction hardened, frontier + families mapped

**Context:** inherited both lanes (Codex out of tokens). User → bed ("have fun"), so ran an autonomous
overnight campaign. G(17) done ⇒ box free (17 GB); no memory constraint. Kept to the `notes/` Go lane.

**★ Main deliverable — the warm-up reduction is now grounded in the PROVEN mirror lemmas**
([warmup-reduction note](../2026-07-05-sumfree-warmup-reduction.md), committed `247feff`). Codex's
two-move reduction was a heuristic; I re-derived it from the proven **Lemmas 1 & 4** of the mod-6 theorem:
- **Fact B** (new, proven): symmetric `A=−A` + order-3 dead ⇒ `𝒢(A)=∗0` (Lemma 1 lifted to a nimber).
- **Fact C** (proven, via Lemma 4): symmetric + order-3 alive ⇒ playing `p` reaches a `∗0` child.
- **Fact D** (proven): symmetric mex reduction ⇒ `𝒢(A)=∗1 ⟺ no non-order-3 child is ∗1`.
- ⇒ `𝒢(Z_{3p})=∗1 ⟺ 𝒢({p,1})=𝒢({p,3})=∗1` (two-move lemma), every step a corollary of proven lemmas.
- **Verified the two-move lemma BREAKS at p=5:** `𝒢({5,3})=𝒢({5,1})=∗3` (not `∗1`); order-5 singleton
  `𝒢({3})=∗1` ⇒ root `mex{0,1,4}=∗2=𝒢(Z₁₅)`. So the lemma is a *sharp* `p≥7` statement, not a formality.
- **Closed the naive "just mirror it" route with a reason:** the spare-`∗1`-token pairing (pair the token
  with the single order-3 move — only one of `p,2p` ever playable since `p+p=2p` — and negation-mirror the
  rest via Lemma 4) fails because **order-3 is a destructible resource**: it dies the instant some `a+b=p`
  lands on the (symmetric) board, and then the position is `∗0+∗1=∗1` on the opponent's turn ⇒ opponent
  cashes the token. A real proof must additionally control order-3's survival — which is *precisely* the
  p=5 phenomenon (order-3 blocked early), though it doesn't by itself separate p=5 from p≥7.

**Compute — frontier extended, families mapped as intractable** (all runs `notes/sumfree-go/`, GOMEMLIMIT-
capped, mem-guarded):
- **`{p,1}` AP-child `(p+1)/2` = `∗0` (P) for p=17,19,23,29,31** (full engine; the handoff's open TODO;
  p=31 = 106M nodes / 1120s on the full box). No exception found yet.
- **`{p,3}` AP-child `6−p`: `∗4` at p=29 was a SPORADIC exception, not a break — it is `∗0` AGAIN at p=31**
  (`{31,3,68}` = 122M nodes, `∗0`/P). So the pattern is `∗0` (p=11..23), `∗4` (p=29), `∗0` (p=31); the known
  exceptions are p=7 (`∗2`) and p=29 (`∗4`). This *softens* the earlier "the `{p,3}` branch breaks" reading
  into **"AP-child with a sporadic finite exception set"** — closer to Codex's finite-exception-book route
  (at exceptional p, a different `∗0`-child exists since `𝒢({p,3})=∗1` still holds). p=37 both branches =
  TIMEOUT (`Z111`, 5400s — the compute wall).
- **Falsification N-hunt held:** boolean `Z3²×Z_p` p=11..23 all timeout (= consistent-with-P; a first-player
  win would cut off fast — none did). **No conjecture-breaker.** (p≥29 exceed the solvers' 256-bit mask.)
- **Extended families are compute-BLOCKED (finding, not a gap):** `Z9×Z3×Z{5,7}`, `Z3³×Z{5,7}`, `Z3²×Z25`
  — boolean N-hunt all timeout (P-suspected, no cutoff); grundy exact blows up (`Z9×Z3×Z5` = 50M nodes /
  23M memo / no convergence in 40 min) because per-node cost `∝|Aut|`. These are the open r₃≥2 slice where
  the proven abelian criterion mispredicts, and they're beyond current tooling. Composite-coprime
  (`Z3²×Z35`, `Z3²×Z5×Z11`) need a >256-bit mask (a trivial `const W` edit on the Go tooling, deferred as
  low-value until the analytic side moves).

**Lit check** ([litcheck note](../2026-07-05-sumfree-litcheck.md), committed): the game + the "N iff p=5"
nimber phenomenon **appear NOVEL**. Must-cite framework = **Sieben, *Impartial Hypergraph Games*, EJC 30(2)
2023, #P2.13** (our game = his building game on the Schur 3-hypergraph). Correction: the Node-Kayles nimber
paper (Wong et al.) is **J. Integer Seq. 23 (2020)**, not 2024. Group-*generation* games (Anderson–Harary,
Benesh–Ernst–Sieben) are distinct (target = generate the group); Impartial SET (Uiterwijk–Hufkens) is a
*removal* game. OEIS has no match — consistent with the prepared draft.

**Bottom line for next session:** the ORACLE is exhausted (family data it can reach is mined; further sweeps
just time out). The bottleneck is **analytic**: prove the missing-∗1 invariant (a monovariant on the armed
components), or find a non-mirror strategy (à la Codex's adaptive `Z3²×Z7=P`). Do NOT spend the box on more
brute sweeps — the reduction note frames exactly what remains.

**Handoff Note — session `2026-07-05--7` (`f240444b-7592-4ef6-b787-54adfb4c21ca`), `mi`.** Commit `247feff`
(warmup-reduction note + litcheck note). Files new: `notes/2026-07-05-sumfree-warmup-reduction.md`,
`notes/2026-07-05-sumfree-litcheck.md`; handoff updated. Validation gate held (reproduced `Z3²×Z5=∗2/N`,
`Z3²×Z7=∗0/P`, `Z15=∗2`, cyclic values, the two-move lemma p≥7 and its p=5 break). No solver source changed
(new tooling only in `/tmp` scratchpad scripts). Left untouched (not mine): `cmd_par/sumfree_par.go`,
`codex-findings-sumfree.md`, queens-lane files. Frontier run COMPLETE: p=31 both branches `∗0` (`{p,1}`
106M nodes; `{p,3}` 122M nodes, recovering from its `∗4` at p=29 ⇒ sporadic exception, not a break); p=37
both TIMEOUT at `Z111` (compute wall). Commits `247feff` → `2b7a878` → `b6765e1` → this. All background
compute stopped; only `memguard.sh` may still idle in `/tmp` scratchpad (harmless, self-exits ~05:00).

---

### 2026-07-06 — session `2026-07-06--2` (`aecafa58`, `mi`): Codex re-tasked (∗0-half), compute owns ∗1-half

**Context:** user said "assign some work to codex while you continue." Codex has tokens again ⇒ delegated
the tractable, closable half of the warm-up and kept the hard analytic crux on the compute lane. Box is
free (G(17) queens run long done; 18 GB headroom, no memory cap). Stayed in the `notes/` Go lane.

**Committed first: Codex's uncommitted Round-4/5 work** (`af7f12d`) — the 381-line nimber-pivot +
two-move/AP-mirror sections of `codex-findings-sumfree.md` and the `--strategy-cap`/elem-kind
instrumentation on `cmd_par/sumfree_par.go` were sitting uncommitted in the tree; integrated + built-clean
(both binaries compile) before building on them.

**★ Delegation — Codex Round-6 banner** (`3a8bda7`, top of `../2026-07-05-codex-assignment-sumfree-socle.md`):
prove the AP-child `T(v)` is a **P-position uniformly in `p`** — the "∗0 present" half of the two-move
lemma `𝒢({p,1})=𝒢({p,3})=∗1`. Concretely: `{p,1,(p+1)/2}` P for `p≥7` (clean); `{p,3,6−p}` P for `p≥11`
**modulo a finite exception book** (`{7,29}`). Method = its own AP-mirror lemma for all-but-≤7 opponent
moves + a structural descent for the ≤7 exceptions (explicit congruence classes). Explicit warning baked
in: **do NOT re-hunt a reflection for the 7 exceptions — CLOSED negative** (they're genuinely non-mirror).
Lane split stated so we don't collide: Codex = ∗0-half, compute = ∗1-half. **[CORRECTED same day: my
banner's original "`{p,3,6−p}` P for all `p≥11`" was WRONG — Codex's Round-6 check flagged `𝒢({29,3,64})=∗4`
(sporadic non-P, on record as `33318cb`); the ∗0-half for the `{p,3}` branch needs the finite book, not a
uniform proof. Banner deliverable corrected accordingly.]**

**★ Compute side (mine) — two findings** ([nimber-engine note](../2026-07-05-sumfree-nimber-engine.md)
2026-07-06 addendum; new tool `grundy --compdump` = per-child armed-component nimber multiset):
- **Missing-∗1 is a connected-graph fact, decomposition is a DEAD END for it.** At `p≥11` every legal
  child of `{p,1}`/`{p,3}` is a **single connected component** (child-nimber hist ≡ component-nimber hist
  exactly). So `𝒢(child)=𝒢(its one component)` — no XOR structure. The p=7 mechanism (a child splits into
  `[1:∗1, 4:∗1]`, two ∗1's cancel to ∗0) is a small-`|G|` artifact. ⇒ the ∗1-absent half **cannot** be a
  disjunctive-sum argument; it is "mex of a single connected armed-Schur graph is never 1," the hard core.
  ∗1 is the uniquely-reliable absentee (∗0, ∗2 always present; ∗3/∗4 sometimes absent).
- **AP-child exceptional replies are non-formulaic** (compute support for Codex's ∗0-half): for
  `{p,3,6−p}` the winning replies to `y=2` are `[15]`(p=11), `[17,31,36,37]`(p=13), `[30,31,35]`(p=17) —
  no common `p`-linear value. Confirms the "genuinely non-mirror" negative ⇒ Codex needs a structural
  descent for the residue, not a reply formula. Reproduce: `grundy Z_{3p} --start "p;3;(6−p);y" --children`.

**★★ THEN — the ∗0-present half CLOSED (proven, uniform), superseding the whole AP-mirror route.**
Reacting to Codex's Round-6 correction, a P-child hunt (cheap, small p) found a *cleaner, exception-free*
witness that the AP-child route walked past: **`{p, k, −k}` = ∗0 for every prime `p ≥ 7` and every
non-order-3 `k`**, by the *already-proven* **Fact C** (Lemma 4's negation-mirror): `A={k,−k}` is
negation-symmetric + order-3-alive, so playing the order-3 element `p` lands on ∗0. So `{p,3,−3}` and
`{p,1,−1}` are the uniform ∗0-children of `{p,3}`/`{p,1}` — **no exceptions, no finite book**; they hold
at `p=7` and `p=29` exactly where `6−p` dies (`∗2`, `∗4`). Verified: `{p,3,−3}` (p=7..19), `{p,1,−1}`
(p=7..23), general `{p,k,−k}` for k=2,4,5,8, and `{29,3,−3}` (the discriminating case, running/confirmed).
**Full statement + proof: `../2026-07-05-sumfree-warmup-reduction.md` §"The ∗0 present half — CLOSED".**
⇒ **the entire warm-up now reduces to ONE open statement, the ∗1-absent half:** for `p≥7`, no child of
`{p,3}`/`{p,1}` is ∗1. Codex banner rewritten to redirect from the (now-superseded) AP-mirror ∗0-route to
this sole crux.

**Validation gate held:** re-ran `Z15=∗2`, `Z3²×Z5=∗2/N`, `Z3²×Z7` machinery, `{7,3}`/`{7,1}` child
spectra (exact match to Codex's tables), `{11,3,28}=∗0/P`, and the mod-6 singleton `{p}=∗0`. gofmt/vet
clean; `--compdump` is additive (existing `--start`/`--children` unchanged).

**Bottom line:** the ∗0-present half of the warm-up is DONE (proven, uniform, `{p,k,−k}`+Fact C — a clean
win out of Codex's correction of my banner error). The warm-up is now a *single* open statement — the
∗1-absent half — and the compute side has shown it is a **connected-graph mex fact** (decomposition ruled
out): "mex of a connected armed-Schur graph is never ∗1, uniform in p." That needs a graph monovariant or
the non-mirror adaptive route — NOT more brute sweeps (honoring the --7 "oracle exhausted" call). Codex is
redirected to exactly this. Next: (a) attack the ∗1-absent monovariant; (b) the same shape lifts to the
r₃=2 main conjecture (`Z3²×Z_p=P`, p≥7) — its ∗0-analogue may also fall to a symmetric-pair + Fact-C-style
move.

**Handoff Note — session `2026-07-06--2` (`aecafa58-e468-4b95-8c92-b6b72c0af41f`), `mi`.** Commits
`af7f12d` (integrate Codex R4/5) → `3a8bda7` (Round-6 task + `grundy --compdump` + nimber-engine
addendum). Files: `cmd_grundy/grundy.go` (+`--compdump`), `../2026-07-05-codex-assignment-sumfree-socle.md`
(Round-6 banner), `../2026-07-05-sumfree-nimber-engine.md` (2026-07-06 addendum), this handoff. Left
untouched (not mine): `py_cross.log`, the queens-lane files (`iso_flat.rs`, queens-report htmls) — all
pre-existing uncommitted changes, not part of this work.

---

### 2026-07-06 — session `2026-07-06--3` (`f97581c0`, `mi`): ∗1-absent LOCALIZED; fixed-pairing route CLOSED; Codex-convergent

**Context:** `go mi`, Codex still running (pid 3672900, `rust/` sandbox). Stayed in the `notes/` Go/Python
lane; box free (17 GB). Owned the ∗1-absent half; Codex owns the proof + its colored-fiber reformulation.

**★ Three findings (writeup: [nimber-engine note](../2026-07-05-sumfree-nimber-engine.md) §"2026-07-06
(session `--3`)"; scripts `../2026-07-06-sumfree-*.py`):**
1. **Mirror-break lemma** (exhaustive, all reachable single-defect boards p=7,11,13, 0 mismatches): for
   `{p}∪S∪{d}` (S symmetric), the legal `z` with `−z` illegal are EXACTLY the ≤3 negations of the defect-blocks
   `{2d, d+p, d·2⁻¹}`. The obstruction to a mirror responder strategy is *three defect-generated blocks*, no more.
2. **The single-token pairing/mirror strategy is DEAD** (definitive; exhaustive minimax STUCKs at p=7,11,13,17):
   (a) the mirror reply is not value-preserving — `{3,7}=∗1` but mirroring Alice's `1` → `{1,3,7,20}=∗3` (`σ`
   moves `p↦2p`, not an automorphism of a `p`-board); (b) one break-move double-blocks both mirror `−m` and
   migrate `−d` (`{1,3,7,20}`+`9`: `12=3+9` and `18=9+9`). ⇒ `𝒢({p,e})=∗1` holds only via **adaptive** play.
3. **Static-signature monovariant ruled out** — ∗1 ≈ 40% of positions, every board signature (`star1-profile`).

**★ Independent solver cross-check (soundness, item D):** a from-scratch Python nimber solver
(`../2026-07-06-sumfree-nim-solver.py`, multiplier-canonical memo) matches the Go engine's
`{11,3}/{11,1}/{13,3}/{13,1}` child histograms **exactly**.

**★ Codex convergence (no collision, mutual reinforcement):** Codex independently reached the same wall via
its **colored-fiber frame** `Z_{3p} ≅ F_p × F_3` (each `F_p`-fiber ≤1 after `p` placed = my `d+p` block; the
3 defect-blocks = its colored-Schur constraints) and its "Reply-Formula Mining" (185 non-P children: mate
replies hit ∗1 only 130/185, no affine witness) = my Finding 2. Both lanes now agree: the proof needs a
**monovariant on the two-defect colored Schur graph** (Finding 3: a mex/recursion invariant, not a static
feature). **Codex banner Round-7** hands it the pairing-is-dead result and points at the adaptive route.

**Validation gate held:** the independent Python solver reproduces the Go engine's `{p,e}` child spectra
exactly (p=11,13); `{p,e}` mex `=∗1`; `𝒢({1,3,7,20})=∗3` confirmed by both solvers.

**★ Finding 4 (recursion clarification, for Codex's induction; scripts `../2026-07-06-sumfree-{defect-recursion,
three-elt,color-mechanism}.py`):** the induction variable is **(defect-count, pair-count)**, not defect-count.
∗1 two-defect positions DO exist (16 at p=11, 31 at p=13) but **all carry ≥1 symmetric colored pair**
(`Sym≠∅`; e.g. `{1,3,7,9,20}=∗1` — the exact position where Finding-2's mirror strategy STUCKs). The `{p,e}`
children are the `Sym=∅` (bare `{p,e,z}`) two-defect positions, and those are the ∗1-free ones; the naive
lemma "every non-P two-defect has a one-defect ∗1 child" is FALSE (33/91 fail at p=11). Also an honest color
negative: `{2,11,20}=∗1` is F₃-monochromatic but does NOT reproduce at p=17 ⇒ the monovariant is not F₃-color.

**Next:** the non-mirror adaptive strategy for `{p,e}+∗1` controlling the three defect-blocks (Codex's proof
lane, engine as oracle). Do NOT retry fixed pairing/mirror (closed), brute sweeps (exhausted), or an F₃-color
monovariant (killed). **Bigger open direction for compute (needs user greenlight):** the **r₃=2 lift** — the
main conjecture `Z3²×Z_p=P` (p≥7) has the same (defect-count, pair-count) shape one rank up, and compute owns
the orbit-child data; that's the non-duplicative high-value next push if the warm-up proof stalls.

**Handoff Note — session `2026-07-06--3` (`f97581c0-7ca0-40ed-a905-80588c5d90d6`), `mi`.** Two commits:
`fe8698d` (mirror-break lemma + pairing route CLOSED, Findings 1–3) and a follow-up (Finding 4 recursion
clarification). Files (mine only): `../2026-07-05-sumfree-nimber-engine.md` (--3 addendum + Codex-convergence
+ Finding 4), `../2026-07-05-codex-assignment-sumfree-socle.md` (Round-7 compute banner), and new scripts
`../2026-07-06-sumfree-{nim-solver,mirror-break,break-exhaustive,strategy-verify,star1-profile,defect-recursion,three-elt,color-mechanism}.py`,
this handoff. **Left untouched (not mine):** `codex-findings-sumfree.md` (Codex, uncommitted mid-flight — the
colored-fiber + reply-mining work), `cmd_par/sumfree_par.go`, `py_cross.log`, queens-lane files. No solver
source changed (Python tooling only; `grundy` binary rebuilt but unchanged source).

---

### 2026-07-06 — session `2026-07-06--5` (`mi`): r₃=2 MAIN-conjecture reduction; zero-triple trap caught; Codex out of tokens

**Context:** user "stay on sumfree alongside codex". Took the banner's PARALLEL target (the r₃=2 main
conjecture). Codex worked the r₃=2 lemmas in parallel (used my `grundy` oracle + built its own `r32-*-mine.py`
tools), then ran out of tokens — its final report is committed (`7abbc7d`). **Next session owns both lanes.**

**Delivered (committed `19bc82c`→`bb9d75a`→`e05270c`→`7abbc7d`):**
1. **★ The reduction** `𝒢(Z3^r×Z_p)=mex{n_soc,n_cop,n_mix}` (uniform in r; 3 orbits) ⇒ **`P ⟺` each opening
   has a P-reply**. An *existential* target (vs the warm-up's universal ∗1-absence). Collapses r₃=2 to Lemma A
   `{socle,mixed}=∗0` + Lemma B `{coprime,mixed}=∗0`. `p=5` exception localizes to Lemma A (`∗3`, sharp). Socle
   opening = the canary. Verified p=5,7 (Grundy + boolean agree).
2. **★ Caught the trap:** Codex's Lemma-B zero-sum-triple mechanism is a **p=7 coincidence** — `{s,t,−s−t}` is
   `∗1`/all-P at p=7 but **`∗6`/mixed at p=11** (full engine). Banner-warned Codex; Codex independently confirmed
   (mirror-cert 0/46, α is only a diagnostic). Route killed cleanly before it became a written proof.
3. Tooling: `grundy --preply` (dump full P-reply set); `../2026-07-06-r32-reply-mirror.py` (Bob's reply
   function — 54/54, 53/53 mutual partners, but proved NO fixed-Schur-involution can exist ⇒ strategy is
   adaptive). Structural asymmetry recorded: Lemma A trivial stabiliser (hard); Lemma B has the α-reflection
   (partial, coupling-limited).

**Left RUNNING at session end (the live branch):** `grundy 3,3,11 --start "0,0,1;0,1,1"` (+ boolean race) — the
direct p=11 value of Lemma B, ~10 min in and not converged (grundy ~1.1 GB). **This is Codex's #1 "next data
needed" and the FIRST next-session action.** Re-run if the background job didn't persist: `cd notes/sumfree-go
&& ./grundy 3,3,11 --start "0,0,1;0,1,1"` and `./grundy 3,3,11 --start "0,1,0;1,0,1"` (Lemma A). Interpretation
of the three outcomes is in the RESUME-HERE `--5` block above.

**Validation gate held:** re-ran `Z15=∗2`, `Z3²×Z5=∗2/N`, `Z3²×Z7=∗0/P` + all 3 orbit-child nimbers (mex
matches root), the p=5 discriminator (`{socle,mixed}=∗3`), and boolean-vs-Grundy agreement on both lemmas at
p=7. `grundy --preply` is additive (existing modes byte-identical). No shared-solver source changed.

**Handoff Note — session `2026-07-06--5` (`85a2e80b`), `mi`.** My commits: `19bc82c` (reduction), `bb9d75a`
(adaptive-strategy findings), `e05270c` (zero-triple trap + unification + banner warn), `7abbc7d` (committed
Codex's out-of-tokens final report + its `r32-*-mine.py` scripts so the work isn't lost), + this handoff.
**Left untouched (not mine):** `py_cross.log`, `iso_flat.rs` + queens-report htmls (queens-lane, pre-existing),
`grid-cap-solver.rs`/`gridcap-*` (the proj-cap agent). The proj-cap agent and I both commit to `main`; stayed
clear of its files.

---

### 2026-07-06 — session `2026-07-06--4` (`b54507bd`, `mi`): Tactic 1 CLOSED (no mirror proof); r=3 parity lever surfaced

**Context:** `go mi`. Codex out of tokens; a separate agent runs the projective-cap game (its
`/tmp/gridcap_fp`/`gridcap_par2` jobs held 4–14 GB through the session — user warned "big job running"). Kept
every probe single-core + memory-light (≤~few hundred MB Python; aborted one Go solve at 1 GB free to protect
the proj-cap job). Stayed entirely in the `notes/` sumfree lane; touched only my own new script + notes.

**★ Main deliverable — Tactic 1 (the lit-scout's #1 proof lever) TESTED AND CLOSED.** New tool
`../2026-07-06-r32-residual-mirror.py`: a residual strictly-matched-involution *mirror verifier*, three
strengths — pure fpf / self-blocking-clique / mirror + defect-substitution (exact-solve the bounded defect
branches, Bob-to-move). **Validated against the mod-6 theorem** (negation mirror certifies `Z_n` `n≡1,5`, fails
`n≡3`; translation mirror `x+n/2` certifies `n≡0` only with defect-solve, 1 defect = the `n/2` opening). Then,
exhaustive at `p=7` over all 368 affine involutions × all 3 openings:
- **pure fpf = 0 certificates; strictly-matched clique = 0 certificates.**
- **mirror + defect-substitution BREAKS** on the best affine involution over a genuine P-reply board
  (`{socle,mixed}=∗0`): `verify ok=False`, a defect branch exact-solves to Bob-losing.
- **Clean structural cause:** the socle opening's 36 P-replies are all **mixed**; **no sum-free-preserving
  (linear `Aut(G)`) involution fixes a socle+mixed board except identity** (0/6, since `s,t` span → `M=I,α=1`).
  The 36 nontrivial invariant involutions that exist are **affine** (`b≠0`/`β≠0`) ⇒ don't preserve `a+b=c`
  (affine preserves Schur only with zero translation) ⇒ their mirror is not a Node-Kayles automorphism and
  breaks. ⇒ **Bob's win is genuinely adaptive** (strengthens the `--3` "pairing is dead" via the *strongest*
  mirror class the lit scout proposed). Writeup: `★ UPDATE` banner atop the proof-tactics note.

**★ Swap-diagonal "square" hypothesis raised then FALSIFIED (saved a wrong direction).** The lowest-defect
mirror *backbone* is swap-diagonal+negation `π(v,y)=(v_swap,−y)` (Brandenburg's square mirror, Tactic 4), reply
`swap(s)`. It looked promising (1 root defect) but: (a) the low-defect invariant boards are **non-P**
(`{socle,socle}=∗3=N`), so no win; (b) its defect set grows with `p` (structured on the `⟨socle-line⟩` fibers
`(0,±1,∗)`); and decisively (c) **`F₃²=∗1=N` alone** (verified) ⇒ `Z3²×Z_p=P` is NOT because `F₃²` is a square.
The `Z_p` interaction is essential. Do not chase the square-mirror.

**★ NEW lever surfaced — the `r=3` datapoint.** Outcome of `Z3^r×Z_p` (`p≥7`) is **P,N,P for r=0,1,2**
(computed/known: `Z_p`=P, `Z3×Z_p`=∗1/N, `Z3²×Z_p`=∗0/P) — NOT the pure-3-group pattern (`F₃^r`=∗1/N ∀`r≥1`,
so `Z_p` flips r=0,2 to P). **Two heuristics disagree at r=3:** (1) alternation ⇒ N; (2) monotone-resource
(the proven r=1→r=2 mechanism: each extra `F₃` gives Bob one more `O₃` pair ⇒ socle opening further off `∗0`
⇒ P) ⇒ law **"N iff r=1"** ⇒ P. (2) is better-grounded (r=2's actual cause; (1) is 3-point fitting), so
`Z3³×Z_p` is most likely **P**. **Compute-blocked** (grundy `∝|Aut|=44928`/node; boolean `sumfree.go`
uncapped-`map` TT OOMs at `|G|=135`). Next-session lever = a **TT-capped boolean solver** (own the Go solver —
bound the map / reuse the grundy fingerprint arena) on a free box, or the socle-opening-canary outcome. The
`r=3` outcome decides between the two laws and gives Tactic 2 (induction on `r`) its base pattern.

**Validation gate held:** re-derived `F₃²=∗1/N`, `Z3×Z7=∗1/N`, `Z3²×Z7` socle child-dist `{∗0:36,∗1:18,∗3:6}`⇒
mex `∗2`, `{socle,socle}=∗3/N`, and confirmed the 36 socle P-replies are exactly the off-socle-line mixed
elements (matches Lemma A). No shared-solver source changed (`grundy`/`sumfree` binaries used read-only; new
tool is a standalone Python script). Verifier self-validated on the mod-6 theorem before any negative was trusted.

**Next steps (compute lane):** (a) ★ the `r=3` outcome via a TT-capped engine (highest value); (b) hand Tactic 3
(adaptive safe-class) the `--6` structural facts — the win is adaptive, backbone-less, obstruction on the
`⟨socle-line⟩` fibers; (c) do NOT re-run mirror/pairing (closed 3 ways) or the `p=11` brute solve (OOMs).

**Handoff Note — session `2026-07-06--4` (`b54507bd-cf0d-4ead-83c8-227b2f0cfacc`), `mi`.** New files (mine only):
`../2026-07-06-r32-residual-mirror.py` (validated mirror verifier + rank/search modes), the `★ UPDATE` banner in
`../2026-07-06-sumfree-proof-tactics-litsearch.md`, this `--6` handoff block + the revised RESUME-HERE. **Left
untouched (not mine):** `py_cross.log`, `iso_flat.rs` + queens-report htmls (queens-lane, pre-existing),
`grid-cap-solver.rs`/`gridcap-*`/`gridcap-par-*` (the proj-cap agent — its jobs ran throughout; I stayed clear
of its files and protected its RAM). No queens/proj-cap files modified.
