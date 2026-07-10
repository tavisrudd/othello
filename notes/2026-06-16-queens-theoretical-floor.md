# Non-Attacking Queens — theoretical floor (n=16) + n=18 feasibility, on this box

> ⚠️ **[2026-07-09 update — partially superseded]** The "current best wall" below (2502 s, §1) is
> obsolete: the production default now solves n=16 in **≈13.43 s**, *below* this doc's estimated
> compute floor. Read the numeric floor here as a historical per-strategy target, not a bound —
> per CLAUDE.md no run figure is a hard limit, and the "floor was a mis-measured / untried lever"
> post-mortem is [`2026-06-24-reflections.md`](2026-06-24-reflections.md). The n=18 feasibility
> framing (§8) is also overtaken: **n=18 is solved — first-player win, opening I9 = (8,8)**.
> Current state: [`2026-07-09-work-summary.md`](2026-07-09-work-summary.md).

**Date**: 2026-06-16
**Scope**: A first-principles (Musk-style "engineering-physics") estimate of how fast the
*optimal* solver could run n=16 Non-Attacking Queens on this machine, assuming the hardware is
used in a data-flow-optimal way (caches, AVX-512/GFNI, MLP) and the data structures carry only
useful bits into the hot loops; **plus an n=18 node-count + feasibility estimate (§8).** Paper
analysis only — nothing compiled or benched. Companion to the
[n=16 memory roadmap](handoffs/2026-06-15-queens-memory-roadmap.md).

> **What this is, and is not.** This is the floor for **one strategy class** —
> re-expansion-free α-β over the transposition set at an assumed branching factor. It is **not a
> proven lower bound on solving n=16**: the genuine algorithmic floor is the *minimal proof DAG*
> for the second-player win (one refutation per first-player move suffices), which this document
> does **not** bound and which a DAG-aware proof-number search could push *below* the searched
> node count. Read the number as a *target for the chosen algorithm*, soft to roughly ±2× — not
> a hard floor. Corrections from a two-reviewer adversarial pass are folded in (see §7).

## Program direction (decided 2026-06-16)

Three frontiers, in this order, sharing one primitive — the fast node:

1. **n=16 → its floor** — via the **inner-loop rewrite** (DFS-resident, register-resident
   incremental canon; the ~250–400× per-node compute gap of §5). **This is the active work.**
2. **n=18** — external-memory ply-windowed DDD (Korf) + BuRR-on-disk; the memory machinery the
   floor demotes for n=16 *speed* is load-bearing again at this scale. Node count + feasibility
   in **§8**.
3. **n=14 nimber** — last; lever is component decomposition + small-component nimber DB (#8) +
   no-cutoff full parallelism.

**Architecture call (made):** build the node primitive **DFS-resident first** (n=16's tighter
feedback loop), kept mode-agnostic enough to add a streaming mode for n=18 later. The
`solver_lineage_agrees` + exact n=12/n=14 distinct-count gates are the safety net for the
rewrite — every step must hold them.

---

## 0. Question the requirement first

The floor for *searching* the game is tens of seconds (derived below). The floor for *knowing
the answer* may be **O(1)**:

- **Odd n is already O(1)** — first player wins by centre + 180°-mirror pairing (theorem, no
  search).
- **Even n** has no such theorem known, and the structural probes that would yield one have
  failed here: #8 decomposition is dead (the queen graph is biconnected + long-range diagonals
  → no Sprague-Grundy nim-sum split); #9 free-involution P-certificates fire <0.001 % of loss
  positions at n=16.

So *absent a parity/pairing theorem for even n*, the search is forced, and everything below is
the floor for the best possible search. The ~75–150× of machine headroom below is dwarfed by the
∞× of not searching at all. **That theorem is the only lever that beats the silicon.** Note:
PSPACE-completeness is of *generalized* Node Kayles — it says nothing about the asymptotics of
this specific n×n queen-graph family, so it does **not** forbid an even-n O(1) result; it only
anchors *why* extracting one bit by search costs billions of operations.

---

## 1. Inputs (measured hardware + measured problem invariants)

| Parameter                       | Value                       | Source / note                          |
|---------------------------------|-----------------------------|----------------------------------------|
| Cores                           | 4× Zen5 + 8× Zen5c = 12     | `lscpu` (Strix Point, Ryzen AI 9 HX 370) |
| L1d / L1i (per core)            | 48 KB / 32 KB               | `lscpu -C`                             |
| L2 (per core, private)          | 1 MB (12 MB total)          | `lscpu -C`                             |
| L3                              | 24 MB in 2 CCX (16 + 8)     | `lscpu -C` — far below any multi-GB TT |
| Nominal all-core clock          | Zen5 ~4.0, Zen5c ~3.1 GHz   | nominal; **down-clocks under all-core AVX-512** |
| Effective cyc/s under AVX-512   | **~3.0–3.4×10¹⁰**           | thermal/power-capped (~28–54 W APU) × SMT ~1.05 |
| DRAM bandwidth (peak)           | ~120 GB/s                   | LPDDR5x-7500, 128-bit (std config)     |
| DRAM bandwidth (random, achiev.)| ~85–100 GB/s                | ~70–85 % of peak                       |
| DRAM random latency             | ~120 ns                     | typical LPDDR5x on this APU (unverified)|
| Distinct subgames, D4 key       | ~7.2×10⁹                    | session-7 n=16 run (HLL-confirmed)     |
| Distinct subgames, graph-iso    | ~2.1×10⁹                    | 3.4× iso merge (session-6, plateaus)   |
| Current best wall (clean run)   | 2502 s ≈ 42 min             | session-8 A/B (`54b3ccd`)              |

**The effective compute rate is the load-bearing input and it is biased pessimistic vs a naive
"nominal clock × SMT 1.3" estimate on purpose:** the optimal loop is a dense all-core AVX-512 /
GFNI kernel, which triggers the AVX frequency offset and the package power cap on a mobile APU,
*and* its by-construction branchless, latency-hidden form leaves almost no idle issue slots for
SMT to reclaim (so SMT ≈ 1.0–1.1×, not 1.3×). This box is documented to thermally throttle even
on a scalar n=14 solve. ~3.0–3.4×10¹⁰ effective cyc/s is the defensible figure; ~4.5–5.5×10¹⁰
(used in the first draft) was ~1.5× too optimistic.

The DRAM figures are std-config, not measured on this box (`dmidecode` needs sudo); they bound
the memory floor (§2), which is **not** the binding constraint, so their imprecision doesn't move
the verdict.

---

## 2. The layered floor

### L0 — answer entropy: 1 bit

"Second player wins." The anchor for *why this is absurd*: billions of operations to extract one
bit, intrinsic to PSPACE-completeness + non-decomposition. Useless as a time bound, essential as
the check that the entire cost is *search*, not *output*.

### L1 — the work base: ~7.2×10⁹ live (the detectable-equivalence count is ~2.1×10⁹)

Two distinctions the first draft blurred:

- **Detectable graph-structural equivalence ≈ 2.1B.** Two isomorphic *available* graphs **are**
  the same subgame — the game is impartial Node Kayles on that graph, history-free, and values
  here are *exact win/loss* (not heuristic α-β bounds), so an iso-canonical key is sound with **no
  graph-history-interaction hazard**. Graph-iso canonicalisation merges to ~2.1B (the 3.4×
  merge, plateaued by n=14).
- **This is the floor of *graph-structural* equivalence — not an information-theoretic floor.**
  Cheaper-than-iso sound merges exist (the #18 degree-sequence shortcut is a complete iso
  invariant for small components without WL), and *more aggressive* sound merges exist that iso
  misses (two non-isomorphic available-graphs can share a nimber → the true value-equivalence
  quotient is *below* 2.1B). We can't compute that quotient without solving the positions, so it
  isn't a usable base — but it means 2.1B is a heuristic waypoint, not a hard floor.
- **The live-achievable base is ~7.2B (D4), not 2.1B.** The iso merge cuts nodes 3.4× but its
  WL-canon costs a *measured* **4.33× more per node** live (roadmap session 8) — so iso is a
  **live loss**, not a wash, and is correctly reserved for freeze-time use. The optimal *live*
  solver therefore keys on the cheap D4 canon and pays ~7.2B distinct nodes. **The floor below is
  costed on 7.2B**, and the 3.4× iso merge is *not* available as a live speedup (it is removed
  from the §5 gap to avoid double-counting).

α-β / parity pruning is strong here (prove-a-loss nodes must expand every child; prove-a-win
nodes need one, and most-blocking ordering is near-optimal — roadmap fact #6), but "strong" is
**not** "equals the minimal proof DAG." The searched 7.2B (×1.36 re-exp live) over-counts the
forced work: a DAG-aware proof search could in principle prove the result over a smaller node
set. This document costs the searched set, not that unknown minimum.

### L2 — memory-traffic floor: ~0.7–4 s (not the binding wall)

Per distinct node, the *only* forced DRAM traffic is one dedup probe — the 256-bit state lives in
registers / L1 down the DFS stack (incremental), the per-square attack table is L1/L2-resident.

| Dedup design                   | Traffic model                              | Floor    |
|--------------------------------|--------------------------------------------|----------|
| Random-access hash (D4 base)   | 7.2B × 64 B line ÷ ~90 GB/s (random)       | ~5 s     |
| Random-access hash (iso base)  | 2.1B × 64 B line ÷ ~90 GB/s                 | ~1.5 s   |
| Streaming / sorted DDD         | 7.2B × ~9 B key × ~4 passes ÷ ~90 GB/s      | ~3 s     |

The sharpest point about the "no wasted bits" constraint: **a random hash probe is
information-theoretically incapable of satisfying it.** DRAM's quantum is a 64-byte line; an
8-byte (or 1.1-bit BuRR) slot wastes ≥87 % of every line fetched, and you cannot fetch less. The
*only* way to make every fetched byte useful is to change the access pattern — ply-windowed
external-memory delayed-duplicate-detection (Korf 2008; roadmap Lead L2 + Chunk-4 reframe). That
converts dedup from latency-bound → bandwidth-bound (a few seconds, not tens). Memory is below
the compute floor **but see the §6 caveat: the DDD memory floor and the L3 register-resident
compute floor may not be achievable by the *same* architecture.**

(First draft quoted ~0.6–1.1 s here; that used the iso node count against the *peak* bandwidth.
On the costed D4 base at *achievable* random bandwidth it is several seconds — still under
compute, but not sub-second.)

### L3 — compute floor: the binding constraint (§3)

---

## 3. The compute floor, instruction-counted

### The dominant term is canonicalisation, and it is per-edge

At a node with branching factor *b*, you must key each *expanded* child to probe the dedup
structure → roughly one canonicalisation per expanded edge. So the floor is set by
`expanded_edges × cost(canon)`. Two refinements vs the first draft:

- **Not every child is keyed.** At a prove-a-win node, once the first (well-ordered) child cuts
  off, the siblings are never generated or keyed → keyed children ≈ 1 at win plies, ≈ *b* at
  prove-a-loss plies. The effective canons/node is therefore well below a uniform *b*.
- **The edge-weighted branching `b̄` is a ~linear multiplier on the floor, and is now MEASURED.**
  `count --branching` (2026-06-16): b̄ (canons ÷ distinct) = **3.35 (n=12) → 3.92 (n=14) → ~4–4.5
  (n=16, extrapolated)** — a gentle up-trend, **no 5–8 tail.** The first draft's `b̄ ≈ 3` undercounts
  ~1.3×, so the per-node cost (and the floor) scale up ~1.3×; the cyc/node figures below fold the
  measured ~4. (The win-node cutoff is imperfect — mean ~2.8 moves tried, not 1 — so the searched
  set sits above the minimal proof DAG; see §5/§6.)

Operation budget for one keyed child on Zen 5 resources (6-wide; native 512-bit datapath on
Zen5; GFNI + VPOPCNTDQ; 32 zmm; board = 16×16 = 256 bits = one zmm):

| Step                   | Operation                                          | Cost (cyc) |
|------------------------|----------------------------------------------------|------------|
| New available mask     | `available vpandnq attack[sq]`                      | ~1 (thr.)  |
| Canonical key (D4)     | 8 dihedral transforms (`GF2P8AFFINEQB`) + 8-way min| dominant   |
| Hash → slot index      | 2–3 multiply/mix (`fastrange`)                     | ~6         |
| Probe issue            | software prefetch, latency hidden                  | ~0         |

The canon term is the whole game. Two designs:

- **Re-fold from scratch each child** — 8× GFNI transpose/reflect then min; dependency-chain
  bound: **~40–50 cyc/child** (plausible, not cycle-verified).
- **Hold the 8 orientations of `available` resident and update incrementally** (8 of 32 zmm,
  carried down the DFS stack; per move = 8× `vpandnq` against the orientation's attack mask;
  canon = a 7-op `vpminuq` reduction): **~15–20 cyc/child.** *Caveat (was overstated):* this
  needs the attack mask in all 8 orientation frames — either 8 pre-permuted tables (8 × 16 KB =
  128 KB, which **spills L1d (48 KB) into the 1 MB private L2**, ~14-cyc hits, not L1) or on-the-fly
  GFNI re-permutation (extra ops). So the aggressive ~15–20 cyc is real but pays an L2-not-L1
  tax; call it **~20–25 cyc** realistically.

### Floor (costed on the D4 base, 7.2×10⁹ nodes)

| Design                                                       | cyc/node | cyc/s    | **Floor** |
|--------------------------------------------------------------|----------|----------|-----------|
| Aggressive: orientations-resident canon (L2 tax), SMT ~1.05  | ~110     | 3.4×10¹⁰ | **~23 s** |
| Central: incremental canon                                   | ~195     | 3.0×10¹⁰ | **~47 s** |

(`cyc/node` folds the **measured** b̄ ≈ 4 at n=16 — `count --branching`, 2026-06-16; the first
draft's b̄ ≈ 3 undercounted ~1.3×. The per-edge canon dominates, so the win-node cutoff savings and
re-exp roughly offset within the band.)

> **MEASURED (canon_bench Step 1, 2026-06-16) — supersedes the per-canon *estimate* above.** The
> isolated kernel benchmark (`rust/src/bin/canon_bench.rs`, `perf stat -e cycles`) gives, on this
> box: best **recompute** (A2: SWAR transpose + GFNI byte h-flips) = **94 cyc/canon**; the
> **incremental** kernel (A3: carry the 8 orientations live, per-move and-not + scalar early-out
> lex-min — what Step 3 builds) = **62 cyc/canon**, a perfect D4-invariant. So per-canon is **~62**,
> not the ~49 estimated ⇒ **per-node ≈ b̄≈4 × 62 ≈ ~248 cyc ⇒ n=16 floor ≈ ~60 s central (~42× over
> today's 2502 s).** The ~47 s / ~23 s ends would need a *vectorised lex-min without the lane-gather*
> (keep the 8 images in `__m256i`, pairwise `vpcmpuq` tree) — the cheap knobs are **exhausted**
> (branchless lex-compare +8 cyc, tree-reduction +4 cyc, AVX-gather min, GFNI full-transpose all
> measured NEGATIVE — the lex-min resists optimisation). The incremental's **1.5× edge over recompute
> is the real Step-3 lever**; details in the [inner-loop-rewrite handoff](handoffs/2026-06-16-queens-inner-loop-rewrite.md).

---

## 4. Verdict

```
n=16 strategy floor ≈ 20–50 s,  central ~45 s    (vs 2502 s today ⇒ ~50–110×)
   b̄ now measured ~4 (count --branching) — folded in; the earlier b̄ ≈ 5–8 tail did not appear.
```

This is the floor for re-expansion-free α-β over the D4 transposition set at the assumed
branching — a **target for that strategy**, not a proven lower bound (the minimal proof DAG,
unbounded here, could be smaller). Three load-bearing conclusions survive every correction:

1. **Compute-bound, not DRAM-bound, at the optimum.** The roadmap's "DRAM-latency-bound" thesis
   is true *of the marginal lever* but not *of the floor*: engineer memory to streaming dedup and
   it is a few seconds; the wall is `edges × canon`. (Matches the roadmap's prediction that the
   bottleneck moves from memory to compute.)
2. **The dominant term is canonicalisation-per-edge**, and its optimal form keeps the 8 dihedral
   orientations live and updates them incrementally — never re-folding. That choice is the
   difference between the ~23 s and ~47 s ends.
3. **The per-node gap vs today is structural, not tunable** (§5) — it closes only with a
   register-resident, branchless, incremental inner-loop rewrite, not by tuning the current
   recursion.

---

## 5. Why today is ~75–150× above the floor

Express the gap as a *wall ratio* (apples-to-apples), not a per-node cycle ratio — the two
differ and the first draft conflated them.

| Factor                         | direction | note                                                        |
|--------------------------------|-----------|-------------------------------------------------------------|
| Eviction re-expansion          | 1.36×     | no-eviction archive / streaming DDD → 1.0×                   |
| Per-distinct-node compute density | ~250–400× | today ≈ 33,000 aggregate cyc/distinct node (≈ 24,000/visit × 1.36) vs ~80–140 at the floor — register-resident incremental rewrite |
| Floor pays AVX all-core down-clock | ÷~2–3× | the optimal kernel runs at ~3.0–3.4×10¹⁰ cyc/s vs today's lighter scalar load — *partly eats* the per-node win |
| ~~D4→iso 3.4× merge~~          | excluded  | **freeze-only; a measured live *loss* (4.33×/node) — not a live gap** |

Net **wall ratio ≈ 75–150×** (central → aggressive), down to ~30× in the b̄-upside tail. The
single damning, well-grounded number: today's clean run is ~4 M nodes/s using **~0.2 % of memory
bandwidth** (4 M × 64 B = 0.26 GB/s of 120) — the current solver is nowhere near the memory wall;
it is deep in per-node compute/frontend cost. The *existence* of a ≫50× gap is solid; its exact
size rides on the soft inputs (b̄, the AVX clock).

---

## 6. Caveats / what would move the bound

- **Above the floor (the only real lever):** an even-n parity/pairing theorem → O(1), collapsing
  the whole derivation. Everything else is a constant factor on a fixed exponential.
- **The two floors may not compose.** L2's cheap memory (streaming ply-windowed DDD) reorders the
  search into breadth-first ply batches; L3's cheap canon (8 orientations resident *down the DFS
  stack*) assumes depth-first traversal. You may not get both at once — a DDD architecture can
  break the register-resident incremental-canon design, and vice-versa. The "memory ~free **and**
  canon ~20 cyc" floor is a *best case of two possibly-incompatible designs*, not a demonstrated
  single architecture. This is the largest unproven structural assumption.
- **b̄ is the linear multiplier on the answer and is unmeasured** (§3). If edge-weighted b̄ ≈ 5–8,
  central doubles. The `count` tooling can pin it; do that before treating any single number as
  the floor.
- **The minimal proof DAG is unbounded here** (§1/§4). The searched-set count over-counts forced
  work; the true algorithmic floor could be lower, which is the other reason this is a strategy
  target, not a lower bound.
- **Hardware inputs** (120 GB/s, ~120 ns, the AVX all-core clock) are std-config / estimated, not
  measured on this box. They bound L2 (not binding) and the compute rate (binding) — the latter
  is the input most worth measuring next.

---

## 7. Review & corrections (2026-06-16, two-reviewer adversarial pass)

The first draft put the floor at "~8–22 s, central ~15 s, ~120–300×" and labelled it a *lower
bound*. Two independent Opus reviewers (a hardware/physics lens and an algorithm/modeling lens)
found it directionally right but biased optimistic and mis-framed. Folded-in corrections:

- **Re-labelled "lower bound" → "strategy floor / target"** and added the minimal-proof-DAG
  caveat (the true floor could be *lower*, not higher).
- **Fixed the node-base double-count:** the floor is costed on one base (D4, 7.2B) and the 3.4×
  iso merge is removed from the §5 gap (it is freeze-only and a measured *live loss*, not a
  recoverable live speedup).
- **Re-costed the compute rate** at a thermally-realistic all-core AVX-512 figure (~3.0–3.4×10¹⁰
  cyc/s, SMT ~1.05) instead of ~4.5–5.5×10¹⁰ → central ~15 s became **~30 s**.
- **Promoted b̄ from a within-band wobble to the explicit linear multiplier** it is, with a
  b̄ ≈ 5–8 upside tail (unmeasured).
- **Corrected the cache topology** (12 MB private L2 was omitted; "16 + 8" is the L3 CCX split),
  the 8-orientations L1→L2 tax, and the §5 per-visit-vs-per-distinct-node gap conflation.
- **Added** the DDD-vs-DFS composability caveat (§6), the iso-soundness rationale
  (impartial + exact values → no GHI), and the "iso is the graph-structural, not
  information-theoretic, equivalence floor" wording.

**What survived unchanged:** the structural insight (canon dominates and is per-edge), the
compute-bound-at-the-optimum thesis, the O(1) reframe (§0), and the damning ~0.2 %-of-bandwidth
observation. The qualitative conclusions held; the corrections moved the *number* (~15 s → ~30 s
central, ~120–300× → ~75–150×) and the *framing* (lower bound → strategy target).

---

## 8. n=18 — node count and feasibility

### Node count (extrapolation)

Distinct positions (D4 key, like-for-like 2nd-player boards):

| n  | distinct   | ratio vs n−2 | ln(ratio) |
|----|------------|--------------|-----------|
| 10 | 9.43×10⁴   | —            | —         |
| 12 | 1.07×10⁶   | 11.4×        | 2.43      |
| 14 | 4.93×10⁷   | 46.1×        | 3.83      |
| 16 | ~7.2×10⁹   | 145.9×       | 4.98      |
| 18 | **~3×10¹²**| **~450×**    | ~6.1      |

The log-ratio increment is **decelerating** (+1.40 then +1.15; the roadmap's Model B assumed a
constant +1.40 *before* n=16 was measured — the measured n=16 brought it down to +1.15). Holding
~+1.15 gives ratio₁₆→₁₈ ≈ 459×; the deceleration band is ~360–590×, so **n=18 ≈ 2.6–4.2×10¹²
distinct (D4), central ~3×10¹²** — ~9.5×10¹¹ with the iso merge. Node *visits* ≈ distinct **only
with no-eviction external memory**; a thrashing RAM TT inflates that 10–100× (which is *why* n=18
requires external memory, not a bigger RAM table). For scale: ~45× Jenrich's entire 71B-visit
n=16 effort, in *distinct* positions alone.

### Can it fit? Memory is the binding constraint, not compute

Disk on this box: **1.3 TB free** (zpool `/home`).

| structure (central 3×10¹² D4 / 9.5×10¹¹ iso) | footprint | fits 1.3 TB? |
|----------------------------------------------|-----------|--------------|
| raw 8 B/key TT, D4                            | ~26 TB    | ❌           |
| raw 8 B/key TT, iso                           | ~7.6 TB   | ❌           |
| BuRR value-only ~1.1 bit/key, D4             | ~450 GB   | ✅           |
| BuRR value-only ~1.1 bit/key, iso            | ~130 GB   | ✅           |

**n=18 fits this single box ONLY via ply-windowed BuRR-on-disk** — a raw table blows past 1.3 TB
even at iso density. Value-only ~1.1 bit/key is sound *because* ply-windowing makes membership
known (the §6 reframe). This is the n=18 enabler, and it is precisely the memory machinery the
floor "demoted" for n=16 *speed* — load-bearing again here.

### Time floor

| basis                                            | time              |
|--------------------------------------------------|-------------------|
| optimal node, compute-only, memory free (D4)     | ~3 hr (3×10¹² × ~110 cyc ÷ 3×10¹⁰) |
| optimal node, compute-only, iso                  | ~3 hr (fewer nodes × pricier canon — same wash as n=16) |
| **realistic (memory/IO-bound, DDD passes)**      | **hours-to-days** |
| today's node (4 M/s), and can't hold the set     | ~9 days + thrash → effectively infeasible |

### Verdict

**Theoretically possible: yes** — ~3×10¹² nodes, ~130–450 GB on disk (BuRR), ~hours-to-days.
**On this single box: borderline-yes, contingent on three things, all required:** (a) the
inner-loop rewrite (today's node is both too slow *and* can't hold the set — the rewrite is a
**prerequisite**, not a nicety); (b) external-memory ply-windowed DDD (Korf 2008); (c)
BuRR-on-disk at ~1.1 bit/key. **Distributed** (4–8 boxes via the dump/load CRDT shard) removes
the disk-IO pressure and is the comfortable path.

**The non-compute risk is validation.** n=16 had Jenrich as an independent cross-check; n=18
would be a *first computation* with none. Correctness rests on the lineage + distinct-count gates
holding through the rewrite, internal consistency (re-exp ≈ 1.0, distinct matching the HLL
extrapolation), the even-n→second-player pattern as a sanity prediction, and a re-verifiable
checkpoint / second implementation. A 3-trillion-node result with no external check needs a
verification story as serious as the search itself.
