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
