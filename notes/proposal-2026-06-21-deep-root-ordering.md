# Proposal — Deep-root move-ordering enhancements (cut nodes in the 2 serial tails)

**Date**: 2026-06-21
**Scope**: MOVE ORDERING only — cut search nodes by improving the dynamic move-ordering
heuristic, with the leverage concentrated in the **2 deep serial roots** (the giant
single-threaded tail that is ~94% of n=16 wall). **Out of scope** (covered by sibling
proposals): graph decomposition / nimbers
([targeted-nimber-decomp](proposal-2026-06-21-targeted-nimber-decomp.md)), the
compact/associative TT ([compact-assoc-tt](proposal-2026-06-21-compact-assoc-tt.md)).
**Design only — no source modified.**

---

## 0. State of the art (read from the code, not from memory)

The deep solve is `IsoFlat::wins_inc` (`src/queens/solver/iso_flat.rs`). It is a pure
**OR-node boolean search**: every node is an OR over its available moves; a *losing*
child (= a move the opponent then loses from) is a winning move and **cuts** the node
(`if lost { result = true; break; }`, line ~2410). There is no real polarity flip —
this is impartial Node-Kayles / last-player-wins, win/loss only, history-free.

The production default is **`M_ORD_W`** (`QUEENS_ORD` unset ⇒ `ord && ord_etc`,
dispatch at line ~3397). Two stacked mechanisms in the fused descent (lines ~2188–2421):

1. **Dynamic ordering** (`sort_moves_by_degree`, line ~1992): re-sort each node's
   available moves by **ascending current available-block degree** `child0.popcount()`
   (most-forcing first; a `child0==0` instant-win sorts to rank 0). Branchless **counting
   sort** (the --15 win, killed the #1 branch-mispredict site). Stable ⇒ ties keep the
   static `q.order` (descending empty-board attack degree). The sorted degree array
   `degbuf` is **fused** into the gather + descent (read, not recomputed).
2. **ETC** (enhanced transposition cutoff, the `if MODE == … M_ORD_W` block, line ~2225):
   gather the recurse-arm children (`pc > recurse_min`, where `recurse_min = DK.max(block_k)
   .max(iso_max_avail) = 16` at the K=16 default ⇒ recurse children are **pc ≥ 17**), build
   each child key **once** into a stack SoA (`wk/wr/wf`), prefetch all, then probe the batch.
   A **proven-loss / empty** child cuts the node immediately (`Some(0)` ⇒ put+return true).
   A **proven-win** child is recorded (`wv[j]=1`) so the descent skips re-recursing it
   (the --16 ETC-reuse win). On no cut, the fused descent reuses the stored descriptors.

**The W_K dense ceiling K=16** means every `9 ≤ pc ≤ 16` child is resolved table-directly
(`w9_get`..`w16_get`, no probe, no subtree). So **the only nodes that recurse / probe the
flat TT are pc ≥ 17** — the deep tail is pc 17–21 (the handoff's "pc 13–21" predates K=16;
post-K=16 the recurse frontier is pc ≥ 17). The tail is **transposition-saturated**.

### Two hard, load-bearing facts this proposal must respect

- **"Move ordering is worth ~2× node reduction."** Any reorder that *forfeits* the
  current ordering costs **+94% nodes** at n=16 (the sorted-frontier-wave kill,
  `M_WAVE_B`). So a candidate must *strictly improve* cutoff rank — a neutral reshuffle is
  a large loss, not a wash.
- **History and effective-degree ordering are MEASURED-NEGATIVE** (roadmap session-6,
  `2026-06-15-queens-memory-roadmap.md` lines ~996–1052). Exact prior forms below (§2) so
  we don't re-propose a dead one.

### What the static degree order already buys (why the bar is high)

The roadmap's conclusion: *"the static most-blocking-first order is **near-optimal** for
this game — Non-Attacking Queens **is** a blocking game, so attack degree is an
exceptionally strong, position-consistent cutoff predictor."* Dynamic degree (current
`avail`) then sharpens it deep where boards have filled. So the residual headroom for *any*
ordering lever is **whatever fraction of cutoffs do not already land at rank 0–1**. **We do
not yet know that fraction.** That is the first measurement (§5), and it gates everything
below — stated up front so we don't build an idea whose ceiling we haven't sized.

---

## 1. Better static-within-dynamic keys (secondary sort keys)

**Mechanism.** Keep the primary key (`child0.popcount()` ascending). Today equal-degree
ties fall to the stable static `q.order`. Replace that tiebreak with a cheaper-is-better
cutoff predictor *computed from data already in hand*. Candidates, cheapest first:

- **(1a) 2-ply forcing-ness / "child's min child-degree."** A move whose resulting
  position itself contains a very-low-degree (near-instant-win) reply is more likely to be
  a proof move. But computing the child's move degrees is a full node's worth of work per
  move — too expensive globally (it is literally a 1-ply lookahead; see §3, where it is
  gated to the tail only). **Not a global tiebreak.**
- **(1b) move's own *static* attack degree as the tiebreak** (descending). This is exactly
  today's `q.order` tiebreak — already in place, free. No change.
- **(1c) resulting-component-count / isolated-vertex count of `child0`.** A child that
  shatters the available-graph into more components (or strands an isolated vertex) tends
  to be closer to a terminal. But computing component count is graph traversal per move
  (expensive), and the isolated-vertex signal was shown structurally weak (the pair-strip
  WASH, --15: getK peels isolated verts one ply at a time, so ≤1 coexists). **Weak + not
  cheap.**
- **(1d) `popcount(att[sq] & att-of-already-forced-square)` — degree *of the second
  order*.** Reuses `att_for8` already loaded in the degree loop; a single extra `and`+
  `popcount`. Plausibly cheap. But it is a *proxy for the same blocking signal* the primary
  key already captures — likely correlated, so low marginal information.

**Fermi node-cut.** Tiebreaks only matter when two moves share the *exact* `child0.popcount`
— at the deep tail (small move lists, pc 17–21, ~6–18 moves) ties are common but the
already-stable static-degree tiebreak is *itself* near-optimal (roadmap). A better tiebreak
can only re-rank *within a degree class*, and the primary key already separates classes. Net
**estimated −0% to −2% nodes** — small, bounded by the tie frequency × the residual
mis-rank within ties.

**Cost/node.** 1b is free (status quo). 1d ≈ +1 `and`+`popcount` per move in the sort key
loop (the loop is ~5–10% of cycles). 1a/1c are too expensive for a global key.

**Global** (it is the sort key for every node).

**Wash risk: HIGH.** This is precisely the "per-node micro-opt" the discipline warns washes
out, *and* it touches the strongest existing signal. The static degree order being
near-optimal means tiebreak refinement has little to grab. Cite: roadmap "move ordering is a
dead end for the working set… the static most-blocking order is already near-optimal."

**Kill-criterion.** If the §5 rank histogram shows cutoffs already cluster at rank 0–1 (say
≥85% by rank 1), the tiebreak lever is dead before building — there is no spread for a
tiebreak to compress. If built, kill on any n=16 interleaved A/B that is not ≤ −1.5% wall
(below the noise floor it is a wash).

**Verdict: lowest priority.** Only 1d is even cheap enough to try, and only if §5 shows
real spread *within* degree classes.

---

## 2. Killer / history / refutation — the prior negatives, and the one untried form

### 2a. The exact prior forms (so we don't re-propose a dead one)

From `2026-06-15-queens-memory-roadmap.md` (session-6, lines ~996–1052) and backlog rows
#6/#6b (lines ~483–484):

- **History heuristic (#6, lever "proper") — CATASTROPHIC, worsens with n.** Form tried: a
  **global** per-square β-cutoff tally `[AtomicU64; MAX_N²]`, shared lock-free across all
  workers; re-rank every node's moves by it; reward the cutoff square on a hit; ties →
  static degree → ascending square (so zero history ≡ static order exactly). Result:
  distinct working set **n=12 +116%, n=14 +130%** (sequential, so pure ordering damage; not
  a reuse artifact). Robust to the weight (frequency-only +125%). **Why:** history conflates
  cutoff signal **across plies/contexts** — a square that is a great proof move deep is
  tried first shallow where it is bad — and *replaces* a strong static signal with a noisy
  learned one. The Othello precedent ("hash + mobility already near-minimal; depth-indexed
  killers mis-order") holds harder here.
- **Effective-degree (#6b) — decays to ~0, REVERSES under parallel.** Form: re-rank by
  `popcount(att[sq] & available)` per node (a *context-local* proof move). Sequential shrink
  **1.80× → 1.33× → 1.025×** at n=10/12/14 → ~0 at n=16 (boards fill late in a big search, so
  the order only diverges deep where few nodes live). Under the parallel default it
  **reverses, +9–12% working set**: the static order concentrates proof moves on a few
  *globally-good* squares whose positions **transpose heavily** across the concurrently
  searched root subtrees (near-perfect cross-worker TT reuse); effective-degree picks a
  context-local proof move whose positions **don't transpose** across siblings → cross-worker
  reuse collapses.

**Crucial nuance for this proposal:** the *current* `M_ORD` dynamic ordering **is**
effective-degree by `child0.popcount()` — which session-6 measured decaying to ~0 by n=16.
Yet `M_ORD` is the −30% win. **Reconciliation:** session-6 measured effective-degree over
**iso-flat / the whole working set under the parallel default**, where the cross-worker
reuse collapse dominated. The --12 `M_ORD` win is on **iso-dense (K=12+)**, where the deep
recurse frontier is pc ≥ 13/17 (W_K erased pc 9–16 expansion) and the measured A/B is at
12 GB. The lever moved because the *substrate* moved (W_K collapsed the working set into the
deep tail; the cross-worker-reuse term shrank). **This is the "re-read measured vs reasoned"
+ "levers compound" pattern** (MEMORY.md): effective-degree was negative on the old
substrate and is the win on the new one. **Killer/history could plausibly have flipped too —
but the history negative was *sequential* (+130%), so its cross-worker term is not the
excuse; its core failure (cross-ply context-conflation) is substrate-independent.** History
stays a poor bet. The *one* form that addresses the actual stated failure mode is below.

### 2b. The one untried form that targets the prior failure mode: **per-pc-band, recency-bounded countermove**

**Why this is not the dead history form.** The history negative was *cross-ply
context-conflation*: one global table mixes a square's value at pc 40 with its value at pc
18. Two changes attack exactly that:

1. **Band the table by popcount** (`pc` of the node), not global. A square's proof value at
   pc 18 is recorded only against pc 18. The recurse frontier is narrow (pc 17–21), so this
   is **≤5 bands × n² squares** — tiny, L1-resident. This removes the "great deep, tried
   shallow" conflation the roadmap blamed.
2. **Countermove, not history.** Instead of a per-square global tally, key the killer on the
   **parent's chosen (just-placed) square** → the reply square that most often cut. This is
   the chess "countermove heuristic": a *refutation indexed by the move it refutes*. It is
   far more context-specific than a flat per-square tally, and cheap (one table read indexed
   by `(prev_sq, band)`).
3. **Recency-bounded / decaying** (optional): cap the tally or halve periodically so it
   tracks the *current* region of the tree, not the whole run's accumulated noise. The
   `M_SIZE` recency-cache sim (line ~2091) already proves recency windows are
   cheap to maintain per worker.

**Mechanism.** Per-worker (no cross-worker sharing → no lock-free contention, no reuse
collapse — sidesteps the #6b parallel reversal): a small `[[u16; n²]; bands]` countermove
score indexed by `(parent_sq, node_pc_band)`. In `sort_moves_by_degree`, after the counting
sort produces the degree order, **promote** the countermove square to rank 0 **only if its
degree is within δ of the rank-0 degree** (so we never demote a much-more-forcing move — the
primary blocking signal stays dominant; the killer only breaks near-ties and surfaces a
proven refutation the degree order ranked mid-pack). On a cutoff, bump `score[parent_sq][band]
+= subtree_weight` for the cutting square.

**Fermi node-cut.** Bounded by (fraction of cutoffs NOT at rank 0–1) × (fraction of those the
countermove correctly predicts). If §5 shows, say, 30% of cuts at rank ≥2, and the
countermove nails half of those one rank earlier, that is a few-% node cut at the deep tail —
**estimated −2% to −6% nodes** *if* the spread exists. If §5 shows cuts already at rank 0–1,
**estimated ~0** and we don't build it.

**Cost/node.** One table read (indexed by the parent square, already in hand) + a conditional
promote in the sort, + one tally bump per cutoff. The table is L1-resident (≤5 × 256 × 2 B ≈
2.5 KB). Plausibly +1–3% cyc/node — but per-worker and L1, so no DRAM cost.

**Deep-tail-only candidate.** Because it earns nothing where degree already cuts at rank 0
(the wide upper tree), gate it to `node_pc ≤ ~21` (the recurse frontier) — or only arm it in
the tail phase (§3's gating). This also shrinks the table to the bands that matter.

**Wash risk: MEDIUM-HIGH.** History/effective-degree are documented-NEGATIVE; this is a
*different* form (banded + countermove + per-worker + degree-gated promote) chosen to attack
the *stated* failure (cross-ply conflation, cross-worker reuse collapse). But the roadmap's
deeper claim — *attack degree is already a near-optimal cutoff predictor for a blocking game*
— could still leave no headroom. **The §5 measurement decides whether to build at all.**

**Kill-criterion.** (a) §5 shows ≥85% of deep-tail cuts at rank 0–1 → don't build. (b) Built:
any n=16 interleaved A/B with node-count not ≤ −2% → revert (this is the +94%/+130% danger
zone; a near-neutral reorder that perturbs cross-worker transposition could *increase* nodes
like #6b — watch node count, not just wall). (c) Verdict/lineage must stay green (ordering is
verdict-preserving, but the gate is mandatory).

---

## 3. Deep-tail-only expensive ordering (1–2 ply lookahead, pays in the 2 serial roots)

**The opening.** The 2 serial roots are single-threaded and dominate the wall. An ordering
that is *too expensive to run on all 24 cores in the parallel phase* (it would slow the
throughput-bound wide tree) can **pay in the tail** because there the bottleneck is
node-count on one core, and cyc/node is cheap relative to a saved subtree. This mirrors the
established "tail-only" gating idea and the slow-root-only ETC menu item.

**The gating mechanism already exists.** `deep_busy: AtomicUsize` (line ~780) counts workers
inside a deep `wins_inc_iter` solve; `n_threads - deep_busy` is the idle-core proxy the
work-stealing gate already uses. **When `deep_busy ≤ 2` (or active roots ≤ 2), arm the
expensive ordering.** Resolve the arm **once per subtree handoff** into the MODE selection
(like every other toggle, per CLAUDE.md "resolve toggles once outside the loop") — a new
`M_ORD_W_DEEP` monomorphisation, or thread a `tail_phase: bool` field set when the parallel
phase drains. **Never a per-node `env::var` or per-node branch on a run-constant.** The
parallel phase instantiates `M_ORD_W` and pays nothing; the tail instantiates the expensive
arm.

**Mechanism — 1-ply cutoff-likelihood ordering.** For each recurse child (pc ≥ 17, the ones
that actually expand), the ETC *already* builds the key and probes the TT. Extend the ETC
gather in the tail: for the children that probe **miss** (unknown), do a **cheap 1-ply
estimate of cutoff likelihood** and sort the descent by it. Concretely, the strongest cheap
proxy is **"does this child have a low-degree reply"** — i.e. compute the child's *minimum*
child-degree (one `min` over `child0`'s moves' degrees, which is the child's own
`sort_moves_by_degree` rank-0 key). A child whose best reply is near-terminal is likely a
proof move for the opponent (so it does *not* cut us) — conversely a child with *no*
low-degree reply is a candidate to descend first. This is a **bounded 1-ply lookahead** worth
~1 node of compute per recurse child, amortized against the ~K-deep subtree it reorders.

**A cheaper variant — order by ETC probe outcome (subsumes idea #4, see §4):** the ETC has
already classified each recurse child as proven-loss (cut now), proven-win (skip), or unknown.
**Descend the *unknowns* in degree order** (status quo), but this is free and already correct.
The expensive add is only the 1-ply estimate on the unknowns.

**Fermi node-cut.** The tail is ~94% of wall; even a small per-node improvement there moves
the wall. If the 1-ply estimate improves first-cut rank on the *spread* portion of cuts
(§5), and the tail's cut-rank spread is, say, 30%, the reachable node cut in the tail is
order **−3% to −8% of tail nodes ⇒ −3% to −7% wall** (tail-dominated). Bounded by the same
near-optimal-static ceiling — but the tail is exactly where the static empty-board proxy is
*weakest* (boards filled), so the relative headroom is highest here.

**Cost/node.** ~1 extra node-equivalent of compute per recurse child *in the tail only*
(≈+30–80% cyc/node on tail nodes), **zero in the parallel phase**. Net wall cost ≈ (tail
fraction) × (cyc/node increase) − (node cut). Pays iff the node cut > the tail cyc/node tax.

**Deep-tail-only** (by construction — the whole point).

**Wash risk: MEDIUM.** Lookahead ordering can pay where blind ordering can't, but a 1-ply
estimate is itself a *degree-derived* signal, so it may be too correlated with the primary
key to add information (the §1 concern, escalated). The mitigant is that it is *recursive*
degree (the child's reply degree), which the empty-board static order does not see.

**Kill-criterion.** (a) §5 tail rank histogram ≥85% at rank 0–1 → no spread → don't build.
(b) Built: 4-round n=16 interleaved A/B; require **wall ≤ −2%** (the tail-only nature means
cyc/node will rise — judge on wall + total cyc, never cyc/node, per the harness note). (c) If
the 1-ply estimate's node cut is < its tail tax in the A/B, try the cheaper "order unknowns
by ETC-cached reply-degree" variant before declaring dead.

---

## 4. ETC-informed ordering (reuse the probe results to descend earlier)

**Mechanism.** The ETC already probes every recurse child and classifies it
(`v == Some(0)` ⇒ cut now; `Some(1)` ⇒ win, recorded `wv[j]=1` and skipped in the descent;
`None` ⇒ unknown). Today, after no cut, the descent runs in **degree order** over all
children, *re-checking* `wv` only to skip proven-wins. **Enhancement:** when no immediate cut,
**reorder the descent to put the ETC *unknowns* (the only children that can still cut by
recursing) first, demoting proven-wins** — proven-wins never cut (they are losses for us), so
descending them at all is wasted unless every unknown also fails. Since proven-wins are
*already skipped* (the --16 reuse), the residual gain is only reordering among *unknowns* — and
those are already in degree order. So **the pure-reuse reorder is near-free but likely
near-zero** — the --16 win already captured the proven-win skip.

**The real ETC-informed lever: a 2-bit "softer" classification.** A TT miss is currently
"unknown." But the ETC could capture **how close** a miss is to resolving — e.g. whether the
child is itself a pc==17 node (one ply from getK leaves, so a *shallow* miss likely to resolve
fast) vs a pc==21 node (deep). Descend the **shallow unknowns first** (they cut or resolve
cheaply, surfacing a cut without paying a deep subtree). This is an ordering by **estimated
resolution cost** using only data the ETC already gathered (the child's `pc`, in hand as
`degs[i]`). **This is cheap** — it is a secondary sort of the unknown recurse children by their
own pc ascending, reusing `degbuf`. It overlaps idea #1/#3 but uses *only already-computed*
quantities, so it is the cheapest member of the family.

**Fermi node-cut.** Bounded by how often a *shallow* unknown cuts where the degree order put a
*deep* unknown first. Plausibly small (degree and pc are correlated — low degree ⇒ small
child) but **non-negative and nearly free**. **Estimated −0% to −3% nodes.**

**Cost/node.** Effectively zero — a secondary key on an array already built (`degs`), inside
the ETC block that already runs.

**Global** (the ETC runs on every recurse node), but its effect concentrates in the tail
(that is where recurse nodes live).

**Wash risk: MEDIUM** — cheap enough that even a 1% node cut is net-positive, but the
degree/pc correlation may leave nothing.

**Kill-criterion.** Build only if §5's rank histogram *also* shows the first cut frequently
landing on a *deep* unknown after a *shallow* unknown was available (a secondary diagnostic:
tag each cut with the cutting child's pc and whether a lower-pc unknown preceded it). If that
"pc-inversion" rate is < ~10%, there is nothing to fix.

---

## 5. THE FIRST MEASUREMENT — first-losing-child RANK diagnostic (`M_RANK` tap)

**This is the gate for the entire proposal. Run it before building anything above.** It is
the ChatGPT "ETC-economics #8 first one" the --13 handoff named the key diagnostic, and it is
*still unrun* (no `M_RANK`/rank tap exists in the code — confirmed by grep; only `M_SIZE`,
`M_PROF`, `M_HIST` taps exist).

**What it answers.** Post-ordering, **at which descent rank does the first cutoff occur?** If
cuts already cluster at rank 0–1, the ordering is near-optimal and every lever above is
small → stop. If the rank distribution is spread (a fat tail at rank ≥2), there is headroom →
build the cheapest idea that targets the spread (§4 ≤ §2b ≤ §3).

**Mechanism (mirrors the established `M_SIZE`/`M_PROF` monomorphised tap pattern exactly —
zero production cost).** Add `const M_RANK: u8 = 12;`, a `RankAcc` thread-local
(`hist: [[u64; MAXV]; bands]` — first-cut rank histogram, banded by `node_pc`; plus a
`no_cut: [u64; bands]` counter for nodes that never cut = full-width losing OR-nodes), a
`drain_rank_all` + `print_rank_report` (clone of `drain_size_all`/`print_size_report`), a
`rank` bool field read once in the ctor (`QUEENS_RANK=1`), and the dispatch arm
(`if self.rank { M_RANK }`, slotting above `M_ORD_W` so it measures the production-ordered
stream). It runs **the M_ORD_W body** (same gather, same degree sort, same ETC) and only adds
a tap.

**Where the tap goes (one line, DCEs on every other MODE).** In the fused descent loop
(line ~2306), the loop **already breaks on the first `lost==true`** — its iteration index `i`
in the **degree-sorted** `moves` is exactly the first-losing-child rank. On break, record:

```text
if MODE == M_RANK { RANK_ACC.with(|a| a.hist[band(node_pc)][i] += 1); }
```

plus, in the ETC block, count an **ETC-rank-0 cut** separately (an ETC cut is a "rank −1" —
the cut happened in the pre-pass before the descent even started; this is the *best* case and
must be distinguished from a descent rank-0 cut, else the ETC's contribution is invisible).
And bump `no_cut[band]` for the no-cut fall-through. Banding by `node_pc` (pc 17/18/19/20/21,
the recurse frontier) shows whether the spread is uniform or concentrated in one band — which
tells idea #2b/#3 *which bands* to arm.

**Secondary tap (cheap, same pass) for §4's kill-criterion:** when the first cut lands at rank
`i`, also record whether any *unknown recurse child at a lower pc* sat at rank `< i` (the
"pc-inversion" count) — this directly sizes idea #4.

**What to look for / decision rule.**
- **≥85% of deep-tail cuts at rank 0–1** (incl. ETC pre-pass cuts) → ordering is near-optimal,
  **the whole ordering lever is small; close it** and report that the node-count lever is
  decomposition (sibling proposal), not ordering. *(This is the likely outcome given the
  roadmap's "static degree is near-optimal" — but it has never been measured post-K=16
  /post-M_ORD_W, and "re-read measured vs reasoned" says measure before believing.)*
- **A fat tail at rank ≥2 (say >15%)**, concentrated in specific pc bands → build the cheapest
  targeted lever: §4 (ETC pc-order, ~free) first, then §2b (banded countermove) if §4
  under-delivers, then §3 (tail 1-ply lookahead) only if the spread is large and tail-located.

**Cost.** Zero production cost (monomorphised tap, DCE'd off the `M_RANK` path). Measurement
run is a single `QUEENS_RANK=1 queens solve 16 iso-dense` (or n=14 for a deterministic,
build-polluted-but-node-exact rank histogram — the rank *distribution* is node-deterministic
at n=14, so n=14 gives a clean histogram cheaply; confirm the shape carries to n=16 with one
slow run). **No A/B needed** — it is a histogram, not a perf delta.

---

## Prioritized shortlist

| # | Lever | Est. node cut | Cost/node | Scope | Wash risk | Gate to build |
|---|-------|--------------|-----------|-------|-----------|---------------|
| **0** | **`M_RANK` first-losing-child rank tap (§5)** | — (measures headroom) | 0 (prod) | diagnostic | none | **build first, unconditionally** |
| 1 | **ETC pc-order: descend unknowns by their own pc ascending (§4)** | −0…−3% | ~0 | global (effect in tail) | medium | §5 shows pc-inversion >10% |
| 2 | **Banded per-worker countermove, degree-gated promote (§2b)** | −2…−6% | +1–3% cyc (L1) | tail-gated | med-high | §5 shows rank-≥2 spread >15% |
| 3 | **Tail-only 1-ply reply-degree lookahead (§3)**, gated on `deep_busy ≤ 2` | −3…−8% of tail | +30–80% cyc (tail only) | deep-tail only | medium | §5 spread large + tail-located; #1/#2 under-deliver |
| 4 | Secondary sort keys / tiebreaks (§1) | −0…−2% | ~0–1% cyc | global | **high** | only 1d, only if intra-degree-class spread exists |

**Ordering logic:** cheapest-and-likeliest first. #1 (§4) is nearly free and reuses data the
ETC already computes — build it if §5 shows any pc-inversion. #2 (§2b) is the one genuinely
new ordering idea that targets the *documented* failure of the dead history form (cross-ply
conflation, cross-worker collapse) via banding + countermove + per-worker; it has real upside
but real wash risk, so it is gated on §5 showing spread. #3 (§3) is the highest-ceiling lever
because the tail is 94% of wall and the static proxy is weakest there — but it is the most
expensive and most likely to be degree-correlated, so it is last and gated hardest. #4 (§1) is
the discipline's canonical "micro-opt that washes" and is lowest priority.

**The standing risk across all four (cite the discipline):** *"move ordering is worth ~2×"* +
*"the static most-blocking order is already near-optimal for a blocking game"* + *"per-node
micro-opts wash out."* A neutral reorder is a **+94%/+130% catastrophe**, not a wash, so every
candidate must be A/B'd on **node count** (not just wall) and reverted unless it is a clear win.
The two facts that keep the lever *open* despite the negatives: (a) `M_ORD` itself was the
−30% win that came directly out of "ordering is dead" — the substrate (W_K, K=16) moved the
lever; (b) "levers compound / re-read measured vs reasoned" — the history/effective-degree
negatives were measured on the pre-W_K substrate and the pre-counting-sort cost balance. Neither
fact *guarantees* headroom; §5 is what tells us if it exists.

---

## THE FIRST MEASUREMENT (the single thing to run)

**Build the `M_RANK` monomorphised tap (§5) — a clone of the `M_SIZE` pattern in
`iso_flat.rs` (thread-local `RankAcc`, `drain_rank_all`, `print_rank_report`, a `rank` ctor
bool on `QUEENS_RANK=1`, a dispatch arm above `M_ORD_W`, and one tap line at the descent's
first-`lost` break + an ETC-pre-pass-cut counter, banded by `node_pc`).** Then run
`QUEENS_RANK=1 queens solve 14 iso-dense` (deterministic node-exact histogram, cheap) and one
`solve 16 iso-dense` to confirm the shape carries.

**Decision:** if ≥85% of deep-tail (pc 17–21) first cuts land at rank 0–1 (including ETC
pre-pass cuts), the move-ordering lever is near-exhausted — report that and steer node-count
effort to the decomposition proposal. If there is a fat rank-≥2 tail, build lever #1 (ETC
pc-order, ~free), then #2 (banded countermove) only if #1 under-delivers. **No code change
ships without an interleaved n=16 A/B that cuts nodes (not just wall).**
