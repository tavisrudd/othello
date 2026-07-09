# Archived CLAUDE Queens/Othello WIP

Extracted from `../CLAUDE.md` on 2026-07-08 so the active guide no longer treats old Queens/Othello queues as current work.

**★ Queens n=18 — SOLVED: FIRST PLAYER WINS** (witness opening **I9**). [n=18 umbrella](../2026-06-23-queens-n18-umbrella.md)
— two independent getK-evaluator configs (`dense_k=17` W17 / `dense_k=20` W18–20) agree on verdict + winning move +
the 15-move PV at different node counts (258 B / 114 B); corroborated by a clean int-sizing audit, an independent-oracle
differential, and a reproduction of Jenrich's full n≤16 sequence. Enabler: **skip[18,25] + a 17 GB flat TT** made the
giant root I9 converge on the 26 GB box (the un-skipped run thrashed). n=18 was genuinely open ⇒ new result, extends
Jenrich (arXiv:1312.5135). Code on branch `queens-n18` (worktree `/home/tavis/src/othello-n18`); see the umbrella's
**session --13 CONCLUSION**. **Pending:** user blessing → archive the umbrella. (NOT an OEIS A344227 submission —
that's the *nimber* sequence to n=13; our n=18 result is a win/loss OUTCOME, and an even first-player win even
contradicts A344227's conjectured even→0 pattern. A real contribution needs the full nimber n=14..18 —
**n=14..17 DONE: G = 0, 1, 0, 2 via the heap-sum `queens nimber` engine
([handoff](../2026-07-01-queens-nimber-a344227.md)); G(17)=2 VERIFIED 2026-07-07 (breaks the odd→1 pattern); G(18) remains. Box note 2026-07-07 (updated): the z5 run was KILLED 2026-07-07 with no verdict (answered-by-analogy-to-p=11; datapoint in the sumfree-compute handoff) — the small-compute-only constraint is lifted.** See the umbrella's
2026-06-28 OEIS note + its 2026-07-01 update.) **`go`.**


**Prior umbrella (n=16 SOLVED, second player):** [Queens n=16 roadmap](../2026-06-15-queens-memory-roadmap.md)
— Progress + Lever backlog hold the n=16 lineage history.

**SMT complementary-phase scheduling — CLOSED (2026-07-02, the evidence-backed "contention is
inherent" outcome):** [handoff](../2026-07-01-smt-complementary-scheduling.md) — P1: the
−21% cyc/node no-SMT reserve is intact in the killer regime (−20.6%); P2 killed it: two independent
12t processes on sibling CPU sets contend identically to one 24t process ⇒ pure instruction-mix
contention, zero intra-process component; P3 confirmed no counterweight phase (canon/TT ≈ 3.3% of
cycles, getK/kernel ≈ 94%). No placement/routing scheme can convert the reserve; SMT stays on
(+34% wall). Next open levers: 1 GB hugetlbfs TT pages (boot-time), killers-at-n=18.

**Newest thread:** [explicit-stack frontier](../2026-06-19-explicit-stack-frontier.md) —
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
marginal" to a +94% kill). [proposal](../../proposal-2026-06-20-sorted-frontier-wave.md): Approach B
net-negative as built. **--11: `M_WAVE`** (fused ETC + batch-probe cutoff) is the iso-dense
DEFAULT (`QUEENS_WAVE=0` disables) = the **1m32s / 1.70 B record**; it captured only −4% of its −16% node cut
(gather/probe prep on the critical path = +22% cyc/node) — that gap is Approach B's prize. Also --11: **probe #1
killed item A** (modular reduction — tail too sparse for size-≥3 modules;
[node-kayles](../2026-06-20-node-kayles-lit-levers.md)), **getK code-build vectorization
measured-negative** (reverted; `proposal-2026-06-19-getk-throughput.md` §5), **core-pinning = wash** (giant
root is memory/transposition-bound, not clock-bound). Also --11: **probe #1 killed item A** (modular reduction — tail too sparse for size-≥3 modules;
[node-kayles](../2026-06-20-node-kayles-lit-levers.md)), **getK code-build vectorization
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

**Active thread:** [iso-window](../2026-06-18-iso-window.md) — n=16 **SOLVED (second)**.
The lineage's fastest is **`iso-dense`** (a new solver): iso-window's kernel + the **W_K hierarchy** to
ceiling **K=12** — every pc==k node (`9 ≤ k ≤ 12`) is resolved directly from the complete W0..W8 tables by
a BMI2-`pext` child sweep recursing one ply per layer (`getK`), no flat-TT probe and no subtree expansion.
**Deterministic n=14 nodes:** W8 27.5M → W9 22.5M → W10 18.8M → W11 15.7M → W12 **12.9M (−53%)**, ~−16–18%
per layer (not diminishing in node terms). The dense ceiling defaults to 12 (the measured crossover winner);
`QUEENS_DENSE_K` (9..=12) re-sweeps. W9..W11 keep the labelled code in a `u64`; W12's 66-bit code runs on a
`u128` two-word `pext` path. **`iso-window`** (dense **W8** tail table over a **huge-page-collapsed** flat
TT, `MADV_COLLAPSE`) stays the default + A/B control, **byte-identical to before iso-dense**. The earlier
"~36 M/s floor / 3m41s wall" was **wrong** — memory-degraded box. (iso-flat handoff [archived](2026-06-17-iso-flat-solver.md).)

**n=16 leaderboard** (best clean-box wall; node count is ±18% node-noisy — for the W_K layers the
node-count cut is the metric, deterministic at n=14, and the wall follows):

> **The `nodes` column = `tt.nodes()` = TT-miss EXPANSIONS only** (the kept A/B metric — every historical
> cyc/node delta is vs this). It does NOT count getK/W_K leaf probes, TT hits, or terminals. The **rule-A
> "explored nodes"** (αβ-tree size; getK/W_K **and** the ≤7 DP as leaf evaluators — the CGT-standard count) is
> **~5.6× larger**: the --7 DEFAULT n=16 ≈ **1.79 B explored** (W17, DK=17). Measured via `QUEENS_RANK=1`
> (`print_rank_report`: `explored = g_e_total + g_etc`; gated, production byte-identical). n=18 ≈ **1.5 T**
> (W17) / **0.75 T** (W20). Definition + per-n table + method: the **2026-06-27 note** in
> [n18 umbrella](../2026-06-23-queens-n18-umbrella.md).

| solver              | n=16 wall  | nodes   | mechanism                                                            |
|---------------------|------------|---------|----------------------------------------------------------------------|
| **iso-dense W17 + killers + kernel micro-opt stack (2026-07-02 DEFAULT)** | **13.43s** search (clean-box record, two-run confirm) / 178,555,417 nodes @ **12 GB TT** · **fastest single 12.43s** / 175,708,579 nodes (root-timing audit run, cold tap, production-identical path) | 0.18 B | **★★ #1 DEFAULT**: the 2026-07-01 killer stack + three unconditional kernel wins (cyc/node −8% cumulative): getK one-ahead mask prefetch + `TABLE_OFF` mask index (−2.1%), **vpcompressb `verts_of`** (AVX512-VBMI2, the ~9%-of-cycles serial scatter → −4.3%), root-adj carry into getK (skip the root `extract_adj`, −2.5%). All byte-identical node sets, verdict SECOND. Details [push-past-floor 2026-07-02](../2026-06-22-push-past-floor-levers.md). |
| **iso-dense W17 + skip18 + killers (depth 1+3/5) + ETC-gate (2026-07-01)** | **13.77s** search / 179,256,361 nodes @ **12 GB TT** | 0.18 B | **★★ #1 DEFAULT**: cross-root killer replies — each odd-ply `.any()` in the parallel upper tree publishes its refuting reply square (`KILLER_HITS`, per ply band); later loops jump to already-proven killers, table re-read mid-loop. Depth-1 A/B nodes −37.6% / wall −43.3%; depth-3/5 stack −7.5%/−4.5%; ETC pc-gate re-tested positive at the new ~8% TT fill (cyc/node −1.2%). cyc/node flat, verdict SECOND every round. TT ~8% full ⇒ **12 GB now beats 17 GB**. Reverts: `QUEENS_KILLER=0` / `QUEENS_KILLER_DEEP=0` / `QUEENS_ETC_GATE=0` / whole-stack `QUEENS_FAST=0`. Details [push-past-floor 2026-07-01--13](../2026-06-22-push-past-floor-levers.md). |
| **iso-dense W17 + degree-ordered getK + skip18 {18} (--7 DEFAULT)** | **23.44s** search (prior record) / 307,608,950 nodes | 0.31 B | **★ #1 DEFAULT (--7, on main)**: on top of the W17 --18 default, **skip18 = {18} all-roots** — skip ALL TT work (canon `lex_min8`→`d4_bits`→`hash128` ≈ the #1 branch-mispredict step, + probe + put) for pc==18 nodes. Safe & cascade-free: pc==18 is the only band whose children are ALL getK leaves (pc≤17) ⇒ a re-expanded pc==18 node re-runs one bounded getK sweep, never an unmemoised subtree; ~100% cold (0.3% probe hit). **−2.5% wall / −3.6% cyc vs the W17 default, n-agnostic, verdict-preserving** (n12 distinct 1,060,823 exact). pc==18 is UNIQUE — every band extension ({19}, [18..22], {18,20,22,24}, fractional) measured dead. `QUEENS_SKIP18=0` reverts. |
| **iso-dense W17 + degree-ordered getK (--18)** | **24.5s** search (fastest single seen; mean ~26–28s, 12 GB A/B) / ~27s e2e | 0.31 B | **prior #1 DEFAULT (--18; the skip18 baseline)**: W17 dense layer (3-word code above the u128 K=16 ceiling) resolves pc==17 (~21% of nodes) as a getK leaf (no cold entry probe) + getK children swept degree-descending (earliest cutoff) + get13-16 child codes right-sized to u64 + cpc off the popcount critical path. **−8.6%..−13% wall vs the W16 default** (−21% nodes / +16.5% cyc/node), SECOND every A/B round. K=17 is the wall sweet spot (W18-20 cut nodes −52% but work-conserve ⇒ flat wall). `QUEENS_FAST=0` reverts to W16+no-ord. |
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
"⇒ NEXT SESSION (--14)" block + the [getK-throughput proposal](../../proposal-2026-06-19-getk-throughput.md)
(its §4/§5 pext negative is obsolete — pext flipped it).
Lower-priority: the **memory levers** (MLP gets, BuRR, 1 GB hugepages) — W12 erased the pc 9–12 probes (~the
profiler's whole probe cost); remaining cost is pc≥13. **Parallelism deficit — measured-CLOSED for DFS-local
approaches** (2026-06-19--5): the giant-root tail (51% core util, ~96% of wall) is **transposition-bound + OR-spine
width-limited** — B1 finer-split (−37% wall), adaptive-tail (−12%), warm-restart (wash) all fail; re-expansion sits
at pc 13–21. Only **ABDADA in-flight markers** or **grouped-frontier DDD** (both heavy/multi-session) can crack it.
**warm-restart + M_WAVE are now the iso-dense defaults** (`QUEENS_WARM_RESTART` 2s warm + staggered restart, ~2%
node trim; `QUEENS_WAVE` fused ETC, −16% nodes / the 1m32s record; both `=0`-disable, iso-flat/iso-window
unaffected). **Next throughput lead = Approach B** (idle-core sorted-frontier pipeline, [scoped](../../proposal-2026-06-20-sorted-frontier-wave.md);
Phase 2a sizing GO-on-paper but **2b de-risk found Approach B net-negative as built** --12 — sorted-wave +94% nodes / L0 dedup +6% cyc/node; the lever moved to move-ordering, but the dedup/move-order-preserving angles are untried, not closed). **getK code-build vectorization = measured-DEAD** (--11: uniform-gather reshape
+0.53% instr, reverted; the compiler won't gather 10/11 lanes and a uniform rewrite doesn't fix it).

**Bigger levers (multi-session, decide with the user):** grouped-frontier `k=9..12` — **scoped +
Phase-0/1 measured**, see [proposal](../../proposal-2026-06-18-grouped-frontier-ddd.md). Dedup
**connected components, not whole graphs** (Sprague-Grundy XOR) — **CLOSED 2026-07-02 for the getK
architecture**: a full-n=16 `QUEENS_DECPROBE` run (744 M getK nodes) shows the pc 9..16 tail graphs
are 97–100% single connected components ("all comps ≤8" = 0.00% for pc ≥13) ⇒ a Grundy-W8 table has
no nodes to fire on; the old Lever-B −74% (n=14, whole-board nodes, pre-W_K) does not transfer.
Branch `queens-component-nimber` (abf38ee, off main, **do not revert**) stays parked as substrate. Codex's frontier-chunk DDD **dropped** (no cheap proxy targets cross-root reuse, max
ρ=0.54 < 0.7). Also: **BuRR
archive** (Chunk-4, eviction-free value-only ~1.1 bit/key — sound under windowing); **1 GB hugepages**
for the TT (zero TT TLB miss, needs boot-time reservation). **Lit-search lever backlog — TRIAGED
(2026-06-20--11):** [Node-Kayles levers](../2026-06-20-node-kayles-lit-levers.md). The top bet
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
