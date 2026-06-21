# Othello + Non-Attacking Queens — project guide for Claude Code

Two crates share the repo: the Python `othello` package (root) and the Rust port +
Queens solver (`rust/`). Active work is in `rust/`; the live umbrella is the Queens
n=16 roadmap in `notes/handoffs/`.

## Current WIP
**DO NOT add details/history here. Pointers only** (details live in the handoff/proposal).

**Start here:** [Queens n=16 roadmap](notes/handoffs/2026-06-15-queens-memory-roadmap.md) — umbrella;
n=16 is **SOLVED** (second player). Progress + Lever backlog hold what's next.

**Newest thread:** [explicit-stack frontier](notes/handoffs/2026-06-19-explicit-stack-frontier.md) —
**LATEST (--15): goal → 30s END-TO-END (incl prep). Search −16% + prep −2s; best clean round ~33s, A/B good
rounds ~30.4s.** Landed on main: **(1) pext k=8 dense-table build** — prep was the k=8 table build (2^28 scalar
codes), NOT the TT alloc (~0.2s); `graph_wins8` uses the runtime `get9..` pext machinery ⇒ **prep 3.3→1.3s**.
**(2) ★ branchless counting sort** for dynamic move ordering — `sort_moves_by_degree` was the #1 branch-mispredict
site (27.9% of misses; search is frontend-bound 30% / IPC 1.23); count/prefix/stable-scatter (no comparison
branch) = **−9.9% cyc/node / −12.5% wall** (byte-identical node set). **(3) warm-restart OFF default** = −3.2%
wall (the counting sort sped the kernel ⇒ the warm-phase ramp stopped paying — re-test gated levers after each
win). Re-sweeps confirm **K=16 and ETC still optimal** (only warm-restart flipped). **Measured-NEGATIVE:**
isolated-vertex pair-strip (the "two-for-one" — `const ISO_STRIP=false` substrate; getK peels isolated verts
one ply at a time so ≥2 rarely coexist; the 1-isolated case needs nimbers), verts_of (wash), PGO (+2.6% now —
counting-sort layout broke it). **The wall:** entry-probe DRAM (MLP-capped by move ordering) + getK 35%
(boolean-decomposition-capped — the pair-strip proved it). RSS measurement: the TT touches its full ~8 GB in ~6s
(random page-spread), so the small *data* (393M keys ≈ 3 GB) doesn't shrink the footprint. **NEXT SESSION (user-
chosen): 4-byte-slot SET-ASSOCIATIVE TT** (the parked `queens-tt-assoc-buckets` direction + a shared-fp compact
slot — the one repr that cuts per-probe DRAM; fp-correctness floor ~46 bits is the design constraint). Then the
parked nimber-decomposition node-count lever. **--14 (historical): ★★ pext getK code-build + W_K ceiling K=12→16 = −35% wall (52→33.9s clean, knocking on 30s).**
The user's 30s grind paid off big. Two stacked levers: (1) **pext-per-row getK code-build** (`adj_row_pext`,
replace the scalar K(K-1)/2 `Bits::get` bit-tests with one 4-word BMI2 `pext` per vertex — −3.8% cyc/node;
the §5 reshape negative only measured a *scalar* rebuild, never pext at K=12 scale where the Fermi flips); (2)
**that made raising the dense ceiling pay the whole way up** — W13/14/15/16 added (the u128 code ceiling, K=16 =
120 bits), default `QUEENS_DENSE_K` 12→**16**. The node cut is **inherent/TT-independent** (16 GB nodes == 12 GB
nodes, so it holds at production TT; 17 GB TT now only **16.5% full** — the working set collapsed): n=14 det K=12
7.9M→K=16 4.0M = −50%; n=16 16 GB single-run 49.5→34.4s; **clean 17 GB 33.9s / 396 M nodes / SECOND, −35% vs the
prior K=12 default**. cyc/node grows +66% at K=16 (the getK evaluator sweep) but the −57% node cut dominates.
Incremental `wk_masks128` (O(2^k·popcount) not O(2^k·k²)) keeps const-eval under the limit. NEXT for 30s:
**extend W_K past K=16 to 256-bit (4-word) codes** (K≤23 fits; the tail is pc 13-21 so K≈18-20 ≈ resolves it
all — node cut didn't diminish through 16; blocker = the 2^K induced table needs runtime init past K=16), the
**getK evaluator cost** (now ~35%, leaves get9/10), then the **memory stall / MLP**. Degree-sort restructure
(closure-free popcount + fused) = **measured WASH, reverted** (the compute is inherent arithmetic). See the
handoff's "⇒ NEXT SESSION (--14)" block. **--13 (historical): inlined insertion sort + sort-fuse/inline-each/
prefetch-reorder = −12.5% cyc/node** (57.58→~52s). **--12: ★ DYNAMIC MOVE ORDERING = −30% wall** (gated
`M_ORD`/`QUEENS_ORD`) — the biggest single
lever since W12, and the constructive payoff of closing Approach B. The closure proved **move ordering is worth
~2× node reduction** (any frontier reorder forfeiting it costs +94%); so we improved the ordering itself: replace
the **static** `q.order` (descending *empty-board* attack degree) with **dynamic** ordering — re-sort each node's
moves by *current* available-block degree (`child0.popcount()` ascending = most-forcing first; instant-win
`child0==0` sorts first ⇒ earliest cutoff). **n=16 A/B vs the M_WAVE default: −34% nodes, +8.5% cyc/node (cheap
degree-sort), −28.7% total cyc, −30.2% wall (98.1s→68.5s @ 12 GB TT)**; n=14 deterministic −31.3%. Verdict-
preserving (matches the validated default n=4..16); production byte-identical off. **ETC stacks on top
(`M_ORD_W`/`QUEENS_ORD=2`): −18% more nodes / −6.5% total cyc ⇒ clean-box ~57s (SUB-60!) / 0.92 B nodes — new
leaderboard #1, −38% vs the M_WAVE record.** The ETC's +14.6% cyc/node is now the limiter; **NEXT = ChatGPT's
ETC-refinement menu** (top-k probe budget on the dynamically-ordered children [first pick], pc-band, slow-root-
only, sidecar-at-ETC-probes) + a **promote-to-default decision** (`QUEENS_ORD=2` is the candidate). This came out
of closing **Approach B (sorted-frontier wave + dedup) — both halves measured NEGATIVE; `M_WAVE` was the default
before this.** A/B + clean runs go in **fresh tmux windows (NOT the user's panes 2/3)** + `solve --to-file` JSON. 2a sized the offload GO-on-paper (gated cold `M_SIZE`/`QUEENS_SIZE` probe
tap, production byte-identical: n=16 3.0 B probes · pc 13–21 = 88% · dedup ceiling 38.1% pre-cut / 27.1%
post-cut · 62–73% same-DRAM-row after sort). **But the cheap 2b de-risk killed it:** the sorted wave needs
**slot-order consumer access = +94% nodes at n=16** (`M_WAVE_B`/`QUEENS_WAVE_B`; the n=14 proxy lied at +13.3% —
move ordering is worth ~2× node reduction, no throughput gain survives it ⇒ the SPSC pipeline is dead), and the
order-independent **L0 probe-cache dedup = +6% cyc/node / +5% total cyc** (`M_L0`/`QUEENS_L0`; net-negative AS
BUILT — per-probe TLS/borrow overhead + the TT already serves repeats warm; untried: a raw-pointer L0, or target
it to the ETC probes only). **These are measured-negative AS BUILT, NOT closed forever** (several of our best wins
were net-negative until tuned — unfused M_WAVE +4.9% → fused −4%, the bogus "36 M/s floor", and *this −38%
ordering win came out of these very negatives*). The *shape* that holds: the giant-root tail resists
frontier-reorder/dedup because **move ordering is worth ~2×**, so the +94% closes grouped-frontier DDD *only* for
variants that disturb consumer move-order; a **move-order-preserving** dedup is the open crack. Surviving levers
**preserve move order** — dynamic ordering (the win), getK/W_K node-count, decomposition that keeps α-β. The
cascade-reorder (`M_WAVE_C`) measured **+2.1% cyc/node** AS BUILT (duplicated recurse body bloated the L1i-bound
loop; the no-dup `unreachable_unchecked` form is untried). All gated off
(`M_SIZE`/`M_SIZE_WAVE`/`M_WAVE_B`/`M_L0`/`M_WAVE_C` = substrate + the untried-angle notes in the handoff). Method
re-vindicated: **n=14/single runs lie — only the interleaved n=16 A/B is trustworthy** (it flipped 2b-0 from "−6%
marginal" to a +94% kill). [proposal](notes/proposal-2026-06-20-sorted-frontier-wave.md): Approach B
net-negative as built. **--11: `M_WAVE`** (fused ETC + batch-probe cutoff) is the iso-dense
DEFAULT (`QUEENS_WAVE=0` disables) = the **1m32s / 1.70 B record**; it captured only −4% of its −16% node cut
(gather/probe prep on the critical path = +22% cyc/node) — that gap is Approach B's prize. Also --11: **probe #1
killed item A** (modular reduction — tail too sparse for size-≥3 modules;
[node-kayles](notes/handoffs/2026-06-20-node-kayles-lit-levers.md)), **getK code-build vectorization
measured-negative** (reverted; `proposal-2026-06-19-getk-throughput.md` §5), **core-pinning = wash** (giant
root is memory/transposition-bound, not clock-bound). Also --11: **probe #1 killed item A** (modular reduction — tail too sparse for size-≥3 modules;
[node-kayles](notes/handoffs/2026-06-20-node-kayles-lit-levers.md)), **getK code-build vectorization
measured-negative** (reverted; `proposal-2026-06-19-getk-throughput.md` §5), **core-pinning = wash** (giant
root is memory/transposition-bound, not clock-bound). Earlier on this thread: the
recursion→loop `wins_inc_iter` (gated `QUEENS_ITER`, throughput-neutral) materialized the search frontier, and
on it we BUILT **both** parallelism-deficit levers session --5 named — **ABDADA in-flight markers**
(`QUEENS_ABDADA`, `773ba8d`) and **frontier work-stealing** (`QUEENS_STEAL`, rayon-scope publish of even-frame
children to idle cores, `fb6b972`/`be4dc57`/`ce46f41`) — both gated off / control byte-identical / n=16 verdict
SECOND. **Both measured a structural NEGATIVE.** Tuned work-stealing (`STEAL_DELAY=50`/`WIDTH=2`/`MIN_PC=35`/
`MAX=24`) is **+8.7% nodes, +13.3% wall** in a 4-round interleaved n=16 A/B. **The DFS-parallelization route to
the giant-root tail is CLOSED with evidence** — 5 approaches (B1 finer-split, ABDADA, ungated/width-21/tuned
steal) all add re-expansion because the tail is **transposition-saturated** (the work that would fill the idle
cores is shared transpositions; the clean-disjoint big subtrees, pc≥50, are gone by 50s). NOT a floor — the
lever is **not parallelization**. **NEXT = characterize the tail work** (span/critical-path, TT-hits by graph
shape, cross-root A→B reuse, state-ROI heat-map — ChatGPT backlog in the handoff) **then attack the WORK:
grouped-frontier DDD** (dedup the frontier — the one parallelism-adjacent lever that doesn't re-expand) **or
getK/W_K node-count**. Kept tooling: split diagnostics, `solve --to-file` JSON, harness monitor/mem-guard.
Method banked: n=16 single runs LIE (±18% common-mode noise) — only interleaved A/B is trustworthy.

**Active thread:** [iso-window](notes/handoffs/2026-06-18-iso-window.md) — n=16 **SOLVED (second)**.
The lineage's fastest is **`iso-dense`** (a new solver): iso-window's kernel + the **W_K hierarchy** to
ceiling **K=12** — every pc==k node (`9 ≤ k ≤ 12`) is resolved directly from the complete W0..W8 tables by
a BMI2-`pext` child sweep recursing one ply per layer (`getK`), no flat-TT probe and no subtree expansion.
**Deterministic n=14 nodes:** W8 27.5M → W9 22.5M → W10 18.8M → W11 15.7M → W12 **12.9M (−53%)**, ~−16–18%
per layer (not diminishing in node terms). The dense ceiling defaults to 12 (the measured crossover winner);
`QUEENS_DENSE_K` (9..=12) re-sweeps. W9..W11 keep the labelled code in a `u64`; W12's 66-bit code runs on a
`u128` two-word `pext` path. **`iso-window`** (dense **W8** tail table over a **huge-page-collapsed** flat
TT, `MADV_COLLAPSE`) stays the default + A/B control, **byte-identical to before iso-dense**. The earlier
"~36 M/s floor / 3m41s wall" was **wrong** — memory-degraded box. (iso-flat handoff [archived](notes/handoffs/done/2026-06-17-iso-flat-solver.md).)

**n=16 leaderboard** (best clean-box wall; node count is ±18% node-noisy — for the W_K layers the
node-count cut is the metric, deterministic at n=14, and the wall follows):

| solver              | n=16 wall  | nodes   | mechanism                                                            |
|---------------------|------------|---------|----------------------------------------------------------------------|
| **iso-dense (W16) M_ORD_W + counting-sort + warm-off + ETC-reuse + flat-arena** | **~27s** search (best A/B round 27.0s / 0.37 B; mean ~29s, 12 GB A/B) | 0.37 B | **★ #1 DEFAULT (--16)**: on top of --15, **ETC win-child re-probe elimination** (thread the M_ORD_W ETC `Some(1)` into the fused descent — no re-recurse/re-probe of a known-win child; node-count ≤ baseline) + **★ flat W0..W8 dense arena** (one contiguous `&[u64]`, kills the `Vec<Box<[u64]>>` pointer-chase + bounds-check load in every getK leaf, **−2.0% cyc/node**). |
| iso-dense (W16) + M_ORD_W (--14) | **~34s** clean (33.9s) | 0.40 B | pext-per-row getK code-build + W_K ceiling raised K=12→**16** (the u128 code limit) = **−35% vs the K=12 M_ORD_W default**; node cut is inherent/TT-independent, TT only 16.5% full; `QUEENS_DENSE_K` 9..=16 |
| iso-dense (W12) + M_ORD_W | ~52s / ~49s best | 0.94 B | the prior default (`QUEENS_DENSE_K=12`): dynamic ordering + ETC + (--13) inlined insertion sort / sort-fuse / inline-each / prefetch-reorder; `QUEENS_ORD=0`→M_WAVE, `=1`→M_ORD |
| iso-dense + M_ORD   | 1m02s      | 1.14 B  | dynamic move ordering alone (`QUEENS_ORD=1`) — −33% vs M_WAVE; no ETC |
| iso-dense (W12) M_WAVE | 1m32s   | 1.70 B  | the prior default (now `QUEENS_ORD=0`): W12 + fused M_WAVE ETC cutoff  |
| iso-dense, WAVE off | 1m39s      | 2.0 B   | W12 only (the A/B control): pc 9–12 from W0..W8 via `pext` (u128 W12) |
| iso-dense (W11)     | 1m44s      | 2.5 B   | W_K to K=11 (u64 codes)                                               |
| iso-dense (W9)      | 2m12s      | 4.0 B   | W9 only: pc==9 from W0..W8                                            |
| iso-window          | 2m15s      | ~5.1 B  | dense W8 tail table over a huge-page-collapsed flat TT                |
| iso-flat            | 3m29s      | 6.1 B   | single selective-iso key over a flat lockless TT                     |

**Current focus (--14, SUPERSEDES the old "K=12 optimum"):** the W_K crossover **moved to the u128 ceiling K=16**
once the **pext-per-row code-build** made the deep getK builders cheap. Raising K now pays the whole way up
(n=14 det node cut K=12 7.9M → K=16 4.0M = −50%, barely diminishing — K=15→16 was −22%); **K=16 is the new
default**, clean 17 GB **33.9s / −35% vs K=12**. The old "K=13 net-negative / compiler-vectorize-K≤9 / hand-SIMD-
is-the-−19%-negative" framing is **obsolete** — pext *is* the win the proposal said it couldn't find (it had
only measured a scalar reshape, never pext at K=12+ scale). **The W_K node-cut lever is now EXHAUSTED at K=16**:
**K=17 (a clean table-free adj-based `get17`, built+tested+reverted this session) is MEASURED-NEGATIVE** — n=16
−19.4% nodes but +30.7% cyc/node / +5.7% wall. pc==17's subtree is *shallow* (one ply to the getK leaves) and
the tail is transposition-saturated, so a TT-**memoized** recurse node beats `get17`'s memo-less recompute (the
opposite of pc≤16, where getK saves a deep subtree). **NEXT for 30s:** (1) a **memoized get17** (probe → on miss
get17 + put, skipping the ~21% degree-sort the recurse node pays) — uncertain, the untried angle; (2) the **getK
evaluator** (~35% of cycles, the get9/get10 leaves of the nested sweep); (3) the **memory stall / MLP**. Smaller
TT = +9.5% wall (eviction > TLB win); degree-sort restructure = WASH; both reverted. See the handoff
"⇒ NEXT SESSION (--14)" block + the [getK-throughput proposal](notes/proposal-2026-06-19-getk-throughput.md)
(its §4/§5 pext negative is obsolete — pext flipped it).
Lower-priority: the **memory levers** (MLP gets, BuRR, 1 GB hugepages) — W12 erased the pc 9–12 probes (~the
profiler's whole probe cost); remaining cost is pc≥13. **Parallelism deficit — measured-CLOSED for DFS-local
approaches** (2026-06-19--5): the giant-root tail (51% core util, ~96% of wall) is **transposition-bound + OR-spine
width-limited** — B1 finer-split (−37% wall), adaptive-tail (−12%), warm-restart (wash) all fail; re-expansion sits
at pc 13–21. Only **ABDADA in-flight markers** or **grouped-frontier DDD** (both heavy/multi-session) can crack it.
**warm-restart + M_WAVE are now the iso-dense defaults** (`QUEENS_WARM_RESTART` 2s warm + staggered restart, ~2%
node trim; `QUEENS_WAVE` fused ETC, −16% nodes / the 1m32s record; both `=0`-disable, iso-flat/iso-window
unaffected). **Next throughput lead = Approach B** (idle-core sorted-frontier pipeline, [scoped](notes/proposal-2026-06-20-sorted-frontier-wave.md);
Phase 2a sizing GO-on-paper but **2b de-risk found Approach B net-negative as built** --12 — sorted-wave +94% nodes / L0 dedup +6% cyc/node; the lever moved to move-ordering, but the dedup/move-order-preserving angles are untried, not closed). **getK code-build vectorization = measured-DEAD** (--11: uniform-gather reshape
+0.53% instr, reverted; the compiler won't gather 10/11 lanes and a uniform rewrite doesn't fix it).

**Bigger levers (multi-session, decide with the user):** grouped-frontier `k=9..12` — **scoped +
Phase-0/1 measured**, see [proposal](notes/proposal-2026-06-18-grouped-frontier-ddd.md). Dedup
**connected components, not whole graphs** (Sprague-Grundy XOR). Phase-1 verdict: raising the Lever-B
component-nimber cap 7→12 cuts nodes **−74%** (n=14) but wall **6.6× worse** — the cutoff-free nimber
*recursion* is the cost killer (per-unit-cost-bound, like the banked graph-iso-key −2.2×). Parked on
branch `queens-component-nimber` (abf38ee, off main, **do not revert**). **Revival = a dense nimber
table for components ≤8** (W8 but Grundy-valued, no recursion); measure its incremental value over
iso-window first. Codex's frontier-chunk DDD **dropped** (no cheap proxy targets cross-root reuse, max
ρ=0.54 < 0.7). Also: **BuRR
archive** (Chunk-4, eviction-free value-only ~1.1 bit/key — sound under windowing); **1 GB hugepages**
for the TT (zero TT TLB miss, needs boot-time reservation). **Lit-search lever backlog — TRIAGED
(2026-06-20--11):** [Node-Kayles levers](notes/handoffs/2026-06-20-node-kayles-lit-levers.md). The top bet
**modular/twin reduction (item A) is MEASURED-DEAD** — probe #1 (`count --comps` `module_profile`, n=12 + n=14
49.8M-position working sets) shows **`reduces%`/`->≤12%` = 0% across pc 13–20**: the tail queen subgraphs are
too sparse to carry size-≥3 modules (twin pairs 3.8% at pc 13 → ~0% by pc 18; `has-mod%` cross-validates the
existing `struct_profile` twin% to the decimal). That **weakens the whole structural-reduction cluster** (B
modular-decomp, D/E setrograde/partition-search keyed on module patterns). **Surviving bet = the work-shrink/
dedup levers needing no module structure** — the A'' sorted-frontier wave (the M_WAVE record), getK throughput,
MLP probes, exact-key grouped-frontier DDD. (TDS scheduling, K-set DP, per-root PN remain untested in the backlog.)

**Parked (WIP, off main):** branch `queens-tt-assoc-buckets` — set-associative cache-line band buckets
(`QUEENS_TT_ASSOC`, SIMD + amortised get/put). Break-even with seg at n=16 (instruction cost fixed,
residual is memory/CPI; −7% nodes cancels +7% cycles/node). Revive for the *oversubscribed* regime
(small-TT / n=18); gate on load factor. Details in the iso-window handoff. **Do not revert.**

**Parked (negative):** branch `chunk3-depth-preferred-tt` — depth-preferred TT replacement, measured 3× worse; off main. Might be able to improve and fix.

**`go`** (or `@notes/handoffs/<name>.md go`) at session start = read that handoff and resume from its Progress / next steps.

## Intent-based mode (opt-in)

Default is collaborative: discuss approach, surface options, await approval. Activate
intent-based mode two ways:
- **Per-handoff (persists across sessions):** add `Mode: intent-based` under the
  `**Date**:` line of the handoff. Scopes to that work stream only.
- **Per-session (ad-hoc):** the single-word prompt `mi` — intent-based for the rest of
  the current session, without writing to any handoff.

When active, take low-stakes reversible calls without asking; state the action in one
line, then proceed unless interrupted (e.g. "Committing X. Reason: Y." / "Reading X to
confirm Y."). **Decide and proceed when ALL hold:** reversible; already permitted by an
existing CLAUDE.md rule or the handoff's plan; recommendation lopsided ≥80/20 with the
decision inputs visible in the conversation; no load-bearing downstream (the next step
doesn't change shape by which option is picked).

**Still ask, even with the flag on:** architecture / design choices that lock in future
work; **any revert, git-state change, or `git push`** (the global git rules stay
ask-first regardless of mode); new scope or a pivot off the handoff's lever sequence; a
real n=16 run (hours-to-days — size with HLL first); anything that would change a
CLAUDE.md rule or a validation gate.

## Short Commands
- `yc` = your call
- `mi` = intent-based mode for this session (see §Intent-based mode)

## Build / test / validate

- Build/test through the **Makefile in `rust/`**: `make release` / `make test` /
  `make clippy` / `make fmt` — never a bare `cargo build`. The Makefile injects
  `-C target-cpu=znver5 -C link-arg=-fuse-ld=mold`; a hand-rolled cargo build
  silently produces a non-znver5 binary and invalidates bench numbers. `cargo
  check`/`fmt`/`clippy`/`test` are fine for quick iteration. Wrap noisy builds in
  `~/.claude/bin/run-quiet "make …"`.
- **A change is not done until its validation gate passes:**
  - **Queens:** `solver_lineage_agrees` (every solver matches the memo-less `naive`
    verdict on n≤9) **and** a fresh `queens solve 12 iso-flat --distinct` (second-player
    win, exact distinct **1,060,823**) + `solve 14 iso-flat --distinct` (second,
    iso-flat distinct **≈29.2M**, re-exp ≈ 1.0×). (The ≈49.3M elsewhere is the *D4*
    distinct; iso-flat's selective-iso key merges isomorphic graphs below it — its own
    distinct is ≈29.2M, the figure this gate checks.) **Name `iso-flat` explicitly** — the default solver is now `iso-window`,
    which has no `--distinct` counter (its W8 table collapses pc==8 subtrees so its node
    count isn't comparable to the distinct set). A distinct-count change = lost
    transposition merges; a re-exp jump = under-sized table. TT/key changes must hold both.
    (n=12's re-exp is ~1.25× on the current branch — the deliberate labelled-≤7-key trade,
    not a regression; the invariant is the *exact* distinct count and n=14's ≈1.0×.)
  - **Othello:** the cross-engine value-equivalence tests (minimax / alphabeta /
    ordered / strong compute identical black-centred values) + the independent grid
    move/flip reference + the exact endgame solves (6 / −40 / 4). `strong+` /
    `strong++` deliberately change the value (strength match, not equivalence).
- A real **n=16 queens** run is the open problem and takes hours-to-days — don't fire
  one off to completion casually during a session; size it with HyperLogLog (`queens
  count`) and extrapolate first. (Completing it is the goal — just deliberately, with
  checkpoint/resume, not as a speculative command that burns the box for days.) Any
  verdict cross-checks against Jenrich (n=16 = second-player win).

## Performance discipline (the Rust hot paths)

The search is **TT / DRAM-latency-bound**, not compute- or parallelism-bound (queens
fact #5 in the roadmap; same conclusion for Othello in `rust/NOTES.md`). What has
held up across sessions:

- **NEVER claim we've reached "the floor" / a hard limit / that something is
  "unreachable" — that judgment is the user's alone.** Always keep pushing and
  reasoning from first principles; when you hit a wall, reason *through* it or find a
  way *around* it — don't declare it terminal. A "floor" conclusion is almost always an
  artifact of the measurement conditions or an untried lever, not a real bound. (Case in
  point: a prior session declared "~36 M/s floor, sub-50 unreachable, n=16 ~3m41s is the
  wall." All wrong — it was measured on a memory-degraded box, dismissed the W8 dense
  table on one confounded run, and never tried forcing huge pages. Cleaning the box +
  W8 + `MADV_COLLAPSE` took n=16 to **2m44s** the next session, and the *compute* floor
  is ~45–60s — so even that isn't close.) Present evidence and open levers; let the user
  decide what's a limit.
- **Per-node micro-opts wash out.** Slot-shrink, terminal fast paths, and the
  lockless atomic TT each measured ~0–5% at n=14 — real but small. The load-bearing
  levers are **memory / representation** (compact fingerprint slot, BuRR archive,
  ply-windowing) and **node-count** (move ordering, canonicalisation, decomposition).
  Spend effort there, not on shaving cycles off a latency-bound node.
- **Measure, don't assume; document negatives.** Bench **interleaved** A/B (alternate
  the two binaries round-by-round) — this box thermally throttles ~1s on a ~12s n=14
  solve, so all-A-then-all-B yields spurious deltas. Keep a change only if it pulls
  its weight; if it's a wash or negative, revert it or record it as an instructive
  negative (the handoffs already hold several: deeper parallelism, df-pn,
  naive-prefetch-windowing).
- **In tmux panes, run bare on the real TTY + read back with `capture-pane` — never
  `>`/`>>`, and prefer this over `tee`.** Every queens run/bench goes in the `queens` tmux
  session (one window per run, keep window 1 live). `tmux send-keys` the **bare** command
  (no pipe, no redirect) so stdout is the pane's TTY and the **live progress bar / per-core
  telemetry renders** for the user to follow. Read results with `tmux capture-pane -t
  queens:<win> -p` (the final summary stays on screen). A pipe (`| tee`) makes stdout a
  non-TTY and **suppresses the live bar** — only fall back to `tee` if you need the raw
  scrollback and don't care about the bar; never silently redirect (`> log 2>&1`), which
  hides the run entirely.
- **Ignore the `could not find repository … panicked at … git/libgit.rs` line in the pane
  scrollback** — that's the user's interactive shell *prompt* failing to render its git
  segment between commands, not a build/run error. It never affects a running solve/bench (no
  prompt renders mid-command). Don't try to "fix" it, don't treat it as a failed run, and
  don't `C-c` the pane over it; read past it to the actual command output.
- **Use the committed A/B harness — don't re-derive it in `/tmp` (we've done that dozens of
  times).** `rust/scripts/queens-ab.sh <n> <TOGGLE_ENV> <binary> [rounds] [tt_slots]` runs the
  canonical interleaved A/B (toggles one env flag 0/1 on a binary). Launch it **once** in the
  `queens` pane (`tmux send-keys -t queens:<win> "scripts/queens-ab.sh 16 QUEENS_ITER
  ./target/release/queens" Enter`) and poll completion with `tmux capture-pane … | grep -q
  QUEENS_AB_DONE`. The script's header documents every lesson baked in; the load-bearing ones:
  - **Never blind `tmux send-keys C-c`** into the pane to "reset" it — that SIGINTs a running
    solve (the recurring "what's doing SIGINT?" footgun). Ensure the pane is **idle** (at a
    prompt) before launching; don't drive runs by per-run `send-keys` into a busy pane (the keys
    interleave into the running process).
  - **Emit a clear `BEGIN <tag>` / `END <tag>` marker around every run** so the scrollback is
    attributable — otherwise interleaved runs are unreadable.
  - **Completion marker must only appear as run OUTPUT, never as a typed command** (`QUEENS_AB_DONE`
    is echoed *after* the loop) — else a `capture-pane | grep` poll false-matches the launch
    command line and "finishes" instantly.
  - **n=16 is memory-tight (17 GB TT, ~4 GB headroom): back-to-back 17 GB runs OOM-kill the 2nd**
    (huge-page reclaim lags process exit → `Killed`/SIGKILL). The harness defaults to a **~12 GB TT**
    (`QUEENS_TT_SLOTS=1500000000`) which is memory-safe and a valid comparison (a per-node toggle's
    cyc/node delta is TT-size-independent). Use the 17 GB default only with cache-drops between runs.
  - **Metric = cyc/node = perf cycles ÷ solver nodes** (node-count-independent); solver summary is
    on **stdout** (capture to a file), the live bar on **stderr** (leave on the pane).
- **Box hygiene before any n=16 bench — a degraded box silently fakes a "wall."** The 17 GB TT needs
  ≥~20 GB free or it OOMs/spills (into zram = compressed RAM, NOT disk) and every number is garbage.
  Before benching: **swap/zram off**, **ZFS ARC capped low** (`zfs_arc_max`≈2 GB — default ~50% RAM
  eats the table), **drop caches + compact** (`echo 3 >.../drop_caches; echo 1 >.../compact_memory`),
  and **clear `/tmp`** (it's tmpfs = RAM here; stale `*.perf.data` ate 11 GB last session). The bogus
  "36 M/s floor / 3m41s wall" came entirely from benching a memory-starved box; clean, it's 2m44s.
  Also force full 2 MB pages on the TT (`QUEENS_TT_COLLAPSE`, default-on ≥4 GB) — plain THP only
  promotes ~73% of a randomly-faulted multi-GB table.
- **Channel Fermi.** Napkin the predicted leverage before implementing. If the bench
  disagrees with the napkin by an order of magnitude, the *model* is wrong — re-read
  the trace at a wider angle, don't keep shaving the thing you assumed was the cost.
- **Resolve env-vars once at startup; thread the value through; never `env::var` /
  `var_os` in a per-node / per-move / per-row loop.** The env-lock serialises all
  rayon workers — the exact contention a lockless TT removes. Canonical readers:
  `tt_bits` (reads `QUEENS_TT_BITS` once per command) and `Strong::new` /
  `env_threads` (reads `OTHELLO_THREADS` once in the constructor), both threaded.
- **Hot-path toggles are resolved once *outside* the loop, never tested per-iteration
  — and this is how we do it, every time.** The rule is bigger than env reads: any
  flag that is constant for a run (a measurement/instrumentation switch, a key-mode,
  a debug counter) must not become a per-node `if`. A per-iteration branch on a
  run-constant bloats the hot loop's I-cache and feeds the branch predictor / frontend
  — and the search is already frontend / L1i-bound where the graph key lives (session-6
  TMA), so the dead branch *worsens the actual bottleneck*. **Preferred form:
  monomorphise on a `const` generic resolved at the call site** (e.g.
  `iso_key_fast_in::<const HIST: bool>` — production instantiates `HIST = false` and the
  tally is never emitted; `count --comps` instantiates `HIST = true`). The single
  runtime decision happens once, at the top, selecting between the two monomorphised
  instantiations (`if collect { run::<true>() } else { run::<false>() }`). When a const
  generic can't reach the site (e.g. through a `dyn` trait object), thread the resolved
  value as a plain field/param instead — but still resolve it once, never in the loop.

## Tiger-style hot-struct discipline

Applies to any struct/loop reached per node — queens `Tt::wins_keyed`,
`QueensTt::get/put`, `pos_key`/`canon`; the Othello PVS search nodes. Cold structs
(CLI, geometry build, errors) are exempt.

1. **Plain data only** in hot structs — no `String`/`Vec`/`HashMap` *inside*; inline
   `[T;N]` / `Box<[T]>`, or pool-index by `(u32,u32)` ranges. (`Slot` is one `u64`;
   `Bits` is `[u64;4]`.)
2. **Contiguous storage** — `Box<[T]>` / `Vec<T>`, never `Vec<Box<T>>` /
   `Vec<Arc<T>>` / `Vec<Box<dyn …>>` / linked structures. (The TT is one flat
   `Box<[AtomicU64]>`.)
3. **No pointer-chasing in the loop body** — read indices, resolve once at scan entry.
4. **Explicit `#[repr(C)]` / `transparent`** on hot structs — never rely on default
   repr; a field-add can silently re-pad.
5. **One array-stride shape, asserted:** cache-line-per-record (`size_of ∈
   {64,128,192}`, `#[repr(C, align(64))]`) **or** several-per-line (`size_of ∈
   {8,16,32}`, no per-record align). Assert size AND align so a regression fails to
   compile.
6. **Field order largest-align-descending, hot fields first;** manual `_pad: [u8; N]`
   for natural gaps; cold/tuning fields in a sibling struct.
7. **Compile-time `const _: () = assert!(size_of::<T>() == … && align_of::<T>() == …)`**
   — a size regression fails the build. (Queens asserts `size_of::<Slot>() == 8` in a
   test; prefer a `const _` assert for new hot structs.)
8. **No internal serialize/deserialize** — operate on the in-memory rep across stages.

Plus:
- **No raw pointers in perf designs** — `&T` / `&[T]` / `&mut T` / `Vec<u32>` index
  pairs reach the same layout wins safely. The few sanctioned `unsafe` blocks (the
  `AtomicU64` zeroed-alloc reinterpret + `madvise` in `zeroed_huge_atomics`, and
  `_mm_prefetch`) each carry a `// SAFETY:` note stating the invariant relied on.
- **Size integer fields to the value range, not `usize`** — board side n≤16, square
  indices <256, nimbers <16, ply <256 fit `u8`/`u32`. Cast to `usize` only at the
  genuine indexing/`with_capacity` site; clamp at the input boundary, never via a
  silent mid-pipeline `as u8`.

## Deps & memory

- **Use ecosystem crates properly** (clap for CLIs, rayon, `libc` for `madvise`) — no
  "no-dep / faithful-port" rationalisation for avoiding a dependency.
- Canonical rules live here (git-tracked). **Record ALL project work in the git-tracked
  handoffs (`notes/handoffs/`), NEVER in the per-project auto-memory** — handoffs are
  visible to the user; auto-memory is not. The auto-memory is reserved for cross-project
  standing preferences only; do not stash session findings, data, interpretations,
  decisions, or queues there (they get hidden + duplicate the handoff).

## Handoffs

`notes/handoffs/YYYY-MM-DD-<slug>.md`, one file per work stream — the **single source of
truth** for all project work (findings, measurements, interpretations, decisions, next-step
queues). They are git-tracked and visible; the invisible auto-memory is NOT a place for any
of this. End each session with the handoff's Progress updated + a dated Handoff Note
(session id, commits, what landed, measurements, next steps). Ship doc updates in the same
commit as (or back-to-back with) the code they describe — don't leave docs uncommitted
across a session boundary.
