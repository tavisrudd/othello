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

### ★ RESUME HERE (next session) — Codex is OUT OF TOKENS; you own BOTH lanes now

Codex ran out of tokens end of `--5`. The next session inherits **compute + the proofs** (no longer
just "oracle for Codex"). State of the open problem:

- **Two conjectures, both very likely true, neither proven.** (1) Warm-up `𝒢(Z3×Z_p)=∗1` (p≥7);
  (2) main `Z3²×Z_p=P` (p≥7). Both reduce to a clean **spectral criterion**: a position's Grundy is
  forced because its child-value spectrum *contains* the needed value and *misses* another. See the
  full picture in [`../2026-07-05-sumfree-nimber-engine.md`](../2026-07-05-sumfree-nimber-engine.md)
  and Codex's reasoning in [`../2026-07-05-codex-findings-sumfree.md`](../2026-07-05-codex-findings-sumfree.md)
  (Round-4/5 sections).
- **Warm-up reduction (Codex's, solid):** root has 3 orbits; order-3 singleton `{p}=∗0`; so root`=∗1`
  ⟺ the two-move positions `G({p,1})=G({p,3})=∗1`. Each `=∗1` ⟺ its child spectrum has `∗0`, lacks `∗1`.
  Confirmed by engine to p=29.
- **`{p,1}` branch:** clean AP-child `(p+1)/2`, reflection `ρ(x)=p+1-x`, finite (≤7) failure set
  (Codex). *Not stress-tested past p=19 — CHECK first.*
- **`{p,3}` branch is the hard one (my --5b negatives):** `c=6-p` is NOT a uniform P-child (`∗4` at
  p=29), and the mirror-certificate idea fails (P-replies aren't reflection-invariant). Genuinely
  non-mirror. Needs a different idea.
- **The real crux (both branches, unproven):** the "**missing ∗1** in the child spectrum," uniformly
  in p. This is the classic-hard part (nimber non-values across an infinite family; the values aren't
  periodic). No line-of-sight proof.
- **Tools ready:** `cmd_grundy/grundy.go` — fast (parallel) + memory-lean (fingerprint arena) nimber
  engine; `./grundy <mods> [--start a,b,c;..] [--children]` (`--children` = child-value spectrum).
  Validated on 50+ values. Confidence estimate (mine): conjectures true ~90%+; a *rigorous* warm-up
  proof ~45–55%; r₃=2 ~25–35%.
- **Next moves:** (a) verify `{p,1}` AP-child holds past p=19; (b) attack the "missing ∗1" — look for a
  structural invariant on the armed components forcing the spectral gap, not more data points;
  (c) for r₃=2, the orbit-child criterion (p=5 socle-child `∗0`→N; p=7 all `∗2`→P). Brute has no cutoff
  and large-p is expensive — spend effort on structure, not sweeps.

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
