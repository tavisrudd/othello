# Non-Attacking Queens — the nimber (Sprague-Grundy) floor, and making n=14 nimber feasible

> ⚠️ **[2026-07-09 update — stale on method]** The central lever of this doc — disjoint-sum
> **decomposition** collapsing the n=14 nimber to "seconds" — did not pan out. Component
> decomposition was closed negative on 2026-07-02: the pc ≥ 9 tail is 97–100 % a single connected
> component, so the nim-sum XOR never fires. The n=14–17 nimbers were instead computed by the
> **heap-sum engine** — G(14)=0, G(15)=1, G(16)=0, **G(17)=2** (verified; G(17)=2 breaks the
> conjectured odd→1 pattern). Also: the "49.3M" distinct used here is the *D4* count; the
> iso-merged distinct is ≈29.2M. Current state:
> [`2026-07-09-work-summary.md`](2026-07-09-work-summary.md).

**Date**: 2026-06-16
**Scope**: A first-principles ("engineering-physics") floor for computing the *full Sprague-Grundy
nimber* of n=14 Non-Attacking Queens on this box — why plain mex is infeasible, and why one
structural lever (disjoint-sum decomposition) collapses it from "harder than n=16 win/loss" to
seconds. Paper analysis only — nothing compiled or benched. Companion to the
[n=16 win/loss floor](2026-06-16-queens-theoretical-floor.md) and the
[memory roadmap](handoffs/2026-06-15-queens-memory-roadmap.md).

> **What this is, and is not.** A floor for the *decomposition* strategy class — Sprague-Grundy
> nim-sum over connected available-graph components, memoized by a graph-iso canonical key. It is
> **not** a proven lower bound: a value-equivalence quotient *below* the graph-iso quotient (two
> non-isomorphic graphs sharing a nimber) exists and would go lower, but isn't computable without
> solving the positions. Read the number as a target for the chosen algorithm — soft to ~±2× **plus
> one large soft input**: the count of distinct connected components, which is to this floor what
> b̄ was to the win/loss floor (the linear multiplier nobody has measured yet). Measure it before
> trusting any single number.

---

## 0. Why the nimber, and is the requirement real?

Win/loss extracts 1 bit ("who wins"). The **nimber** is the full Sprague-Grundy value — a small
integer per position — and it is strictly more information, for two reasons that matter here:

- **It extends the validated sequence.** The nimber is OEIS **A344227**; our verdicts match it
  through ~n=12. n=14 (and the *value* at odd n=13, which the win/loss theorem does **not** give)
  would extend it — like n=18 win/loss, plausibly a **first computation past the published
  frontier**.
- **It is compositional.** The nimber of a disjoint sum of impartial games is the **XOR** of the
  component nimbers (Sprague-Grundy theorem). This single fact is *both* why plain mex is expensive
  (no α-β cutoff — §1) *and* the lever that makes the whole thing cheap (§3). Win/loss can't exploit
  it the same way, because α-β already prunes and win/loss-of-a-sum isn't a per-component property
  you can cache as cleanly.

**The O(1) escape does not exist for the nimber.** Odd-n win/loss is O(1) (centre + 180°-mirror
theorem ⇒ first player wins). But that theorem proves only *nimber ≠ 0*, not the value — so the
nimber is forced by search even at odd n. There is no parity/pairing shortcut to the value. (The §0
of the win/loss floor — "the only lever that beats the silicon is an even-n O(1) theorem" — has no
analogue here: the value is not a parity bit.)

---

## 1. Why plain mex is infeasible: no cutoff ⇒ the full game DAG

α-β win/loss prunes hard. At a prove-a-win node the first winning child cuts off its siblings — they
are never generated or keyed. The searched tree is a small, shrinking *fraction* of the reachable
position set.

**mex has no cutoff.** The nimber of a node is `mex` of its children's nimbers; you must evaluate
**every** child (you cannot stop early — any unseen child could carry the value that fills or moves
the mex). So the nimber search visits the **full reachable DAG**, not a pruned subtree.

The penalty, measured, and it *grows* with n:

| n  | win/loss nodes (parallel, canon) | nimber nodes | nimber ÷ win/loss |
|----|----------------------------------|--------------|-------------------|
|  8 | 625                              | 8,862        | **14.2×**         |
| 13 | (searching baseline)             | unfinished   | **~265×** (est.)  |

(n=8 from the lineage table; n=13 from roadmap fact #3 — "n=13 nimber ran >31 min unfinished vs
4.1 s win/loss, ~265× the node count.") The ratio rises ~1.8×/step (14× → 265× over n=8→13), so at
**n=14 it is ~300–600×**. Applied to the measured win/loss distinct base:

```
naive n=14 nimber distinct ≈ 49.3M × (300–600) ≈ 1.5–3×10¹⁰   (central ~2×10¹⁰)
```

**This is the headline: naive n=14 nimber (~2×10¹⁰ distinct) is a *larger* computation than the
*solved* n=16 win/loss (7.2×10⁹).** At 8 B/slot that working set is ~160 GB — past RAM, into the
same external-memory regime as n=18 win/loss (§8 of the win/loss floor). That is exactly why fact #3
calls it "infeasible by plain mex" and why the program puts it last. Plain mex is a dead end; the
question is whether structure collapses it.

---

## 2. Inputs

Hardware is identical to the win/loss floor (§1 there): 12 cores (4 Zen5 + 8 Zen5c), 24 MB L3 in two
CCX, 1 MB private L2/core, 48/32 KB L1d/i, **~3.0–3.4×10¹⁰ effective cyc/s** under an all-core
AVX/GFNI kernel (down-clock + power cap + SMT ≈ 1.05), ~120 GB/s DRAM, ~120 ns random latency.

Nimber-specific invariants:

| Parameter                         | Value / note                                                       |
|-----------------------------------|--------------------------------------------------------------------|
| Naive work base (full DAG)        | ~2×10¹⁰ distinct (D4), §1 — *the problem*                          |
| Value width                       | small integers (mex of a small-branching node) → **~4–6 bits** vs 1 |
| Parallelism                       | **no cutoff anywhere** ⇒ fan *every* child at *every* ply, zero speculation |
| Decomposition fan-out (win/loss)  | ~1.2 components/position at n=12 (shallow-weighted; **under-measures the deep mass**) |
| Distinct connected components     | **the key soft input** — proxy ~4–8M at n=16 win/loss (the #19 cache size) |
| iso-canon merge (full positions)  | 3.4× (D4→graph-iso, plateaued); **larger for small components**     |

Two of these flip the economics versus win/loss and are developed below: the value is still ~O(1)
(L0 stays trivial), the no-cutoff structure makes parallelism *perfect*, and the decomposition makes
the graph-iso canon — a measured live *loss* for win/loss — **required and net-positive**.

---

## 3. The lever: Sprague-Grundy decomposition turns a product into a sum

When the available-graph splits into connected components with **no edges between them**, the
position is a disjoint sum of independent games and `nimber(position) = XOR over components C of
nimber(C)`. **Sound here, with no graph-history hazard:** the game is impartial Node-Kayles on the
available-graph, values are exact (not α-β bounds), and a move on an available square in component A
can only block squares it attacks — all of which are in A (any attacked available square in B would
*be* an A–B edge, contradicting disconnection). So play in A never touches B. (Same impartial +
exact-value soundness the win/loss floor invokes for the iso key.)

**The reframe — the memoized subproblem is a connected component, not a position.** Computing the
nimber recursion never memoizes a full position; it memoizes connected available-graphs:

```
nimber(connected graph G) = mex over moves m in G of [ XOR of nimber(component) for components of (G after m) ]
```

A *position* contributes only its top-level XOR; it is never a search node. So the **work base is
the number of distinct connected available-graphs (up to graph isomorphism)** — not the number of
distinct positions. This is the crux, because:

1. **A component is shared across exponentially many positions.** A position is a *set* of
   components; the number of sets of components is exponential in the number of distinct components.
   Decomposition converts that exponential product into a linear sum — you search each component
   once and XOR.
2. **Graph-iso canonicalisation (#7) is the cache key, and the merge is large for small components.**
   Isomorphic components have identical nimbers; a small shape appearing in many board
   locations/orientations all collapse to one DB entry. The #19 per-thread component-canon cache is
   already exactly this structure.
3. **Tiny components are constants.** k≤4 components map to a degree-sequence constant (#18, a
   complete iso invariant there) → their nimbers are looked up with no search at all. Deep in the
   tree the board fragments into *overwhelmingly* such tiny components (the #18 histogram), and that
   deep mass is where the naive DAG's ~2×10¹⁰ lives.

**How big is the work base?** This is the floor's b̄-equivalent — the one large unmeasured input.
The best proxy: the #19 component-canon cache at n=16 win/loss was capacity-bound at 2²⁰, +3.7% at
2²², and 2²³ tied 2²² ⇒ **~4–8M distinct components** encountered over the *pruned* n=16 set. The
n=14 nimber sees the *full* set (more component variety) but on a *smaller* board (fewer). Net
estimate, banded wide because it is unmeasured:

```
distinct connected components (n=14, full set) ≈ 10⁷ – 10⁸   (central ~3×10⁷)
collapse vs naive ≈ 2×10¹⁰ / (10⁷–10⁸) ≈ 100× – 1000×
```

Even the pessimistic end (10⁸, 100× collapse) takes the base from "bigger than n=16 win/loss" to
~n=12-win/loss scale — comfortably feasible. The optimistic end is trivial.

---

## 4. The layered floor

### L0 — output: a few bits

One small integer (the SG value, ~4–6 bits). As with win/loss, useless as a time bound, essential
as the check that the entire cost is *search*. Note the nimber buys more than win/loss's bit — it is
the reusable A344227 term and the seed of the small-component nimber DB that accelerates everything
downstream.

### L1 — work base: two regimes

- **Naive (no decomposition):** ~2×10¹⁰ distinct, no cutoff (§1). Memory-bound, external-memory
  regime. *This is the infeasible path.*
- **Decomposition (#8):** ~10⁷–10⁸ distinct connected components (§3). The lever; ≥100×, plausibly
  ~1000×, collapse.

### L2 — memory floor

- **Naive:** ~2×10¹⁰ × one dedup probe → the n=18-style wall; needs BuRR / external DDD.
- **Decomposition:** ~3×10⁷ components × ~16 B (iso-canon fingerprint + nimber) ≈ **~0.5 GB**
  resident, and the *hot* set (the small components reused billions of times) is far smaller —
  plausibly **L2/L3-resident**. **Memory stops being the constraint.** This is the qualitative win:
  decomposition shrinks the working set from "doesn't fit RAM" to "fits cache."

### L3 — compute floor (the binding constraint, decomposition regime)

Per distinct component: `mex` over its moves, each move keyed by the graph-iso canon (the WL/IR
canon — ~4.33× pricier per node than D4 for full positions, but components are *small*, so cheap in
absolute terms: a small CSR + WL, amortised by the #19 cache). Cost ≈ distinct-components ×
component-branching × canon:

| basis (central / pessimistic)                                  | cyc           | ÷ 3×10¹⁰ ÷ 12 cores |
|----------------------------------------------------------------|---------------|---------------------|
| 3×10⁷ comps × b̄≈8 × ~150 cyc                                  | ~3.6×10¹⁰     | **~0.1 s**          |
| 10⁸ comps × b̄≈15 × ~300 cyc                                   | ~4.5×10¹¹     | **~1.2 s**          |

**No-cutoff ⇒ perfect parallelism.** Every node is "evaluate all children," so unlike win/loss
(parity-constrained: only the prove-a-loss plies fan), the nimber fans *every* child at *every* ply
with zero speculation — near-linear scaling to all 12 cores, the easiest parallelism in the project.

---

## 5. Verdict

```
naive n=14 nimber:        ~2×10¹⁰ distinct, no cutoff → larger than solved n=16 win/loss,
                          external-memory-bound → effectively infeasible (matches "n=13 >31min").

decomposition n=14 nimber: ~10⁷–10⁸ connected-component work base, cache-resident,
                          embarrassingly parallel → floor ≈ SECONDS  (soft band ~0.1–10 s).
```

The decomposition is the whole game — exactly as canon-per-edge was for n=16 win/loss. Three
load-bearing conclusions:

1. **Plain mex is a dead end; decomposition is not a tuning lever but a regime change.** It moves the
   work base off the position count and onto the (≥100× smaller) connected-component count, and with
   it the bottleneck from memory-infeasible to cache-resident-compute.
2. **The graph-iso canon flips sign.** For win/loss it is a measured *live loss* (4.33×/node, kept
   freeze-only). For the nimber it is **required** (iso components share a nimber) and **net-positive**
   — the iso merge *is* the DB-hit mechanism. The #19 cache + #18 tiny-component shortcut are already
   the substrate; they were built for win/loss but pay off here.
3. **No cutoff is a feature, once decomposed.** It forbids α-β pruning (the §1 cost) but grants
   perfect parallelism and means decomposition loses nothing — there is no cutoff to preserve, so you
   may fan everything.

---

## 6. The lever stack — what to do (in build order)

1. **Disjoint-sum decomposition + small-component nimber DB (#8) — the lever.** At each node:
   flood-fill the available-graph into components (machinery exists, from #7/#18), look up each
   component's nimber in a DB keyed by the graph-iso canon (#19 cache substrate, made persistent and
   nimber-valued), XOR. Recurse only into *uncached* components. Tiny (k≤4) components resolve to a
   degree-sequence constant with no search (#18). This is the regime change of §3–§5.
2. **Graph-iso component canon as the live key (#7/#19).** Required for the DB to merge iso
   components. Make the #19 component-canon cache the primary memo, nimber-valued. Its size *is* the
   work base — and the thing to measure first.
3. **Full no-cutoff parallelism.** Fan every child at every ply (no parity gate, unlike win/loss
   `par_wins`); zero speculation. Add the #20-style size-split for load balance.
4. **mex micro-opts (minor).** Order children by likely-small nimber; track the seen-set and stop a
   component's expansion once the mex is pinned (all children seen, or the gap is unfillable).
   Bounded — the structural lever (1) dominates.

**Measure-first, before building (the discipline the win/loss floor enforces):**
- **The distinct-connected-component count** — the floor's b̄-equivalent and the single number the
  verdict rides on. Instrument the component-canon cache (or a no-cutoff `count`-style pass) to
  report distinct components reached at n=10/12, extrapolate to n=14. If it's ~10⁷, the floor is
  sub-second; if ~10⁹, it's the ~n=12-win/loss regime (minutes) — both feasible, very different.
- **Fragmentation by depth** — the ~1.2 comps/position at n=12 is over the *shallow* win/loss set;
  measure it over the deep/full set to confirm the deep mass fragments (the lever's whole premise).
- **Max nimber value** — to size the value field (expected single digits).

---

## 7. Caveats / what would move the bound

- **The distinct-component count is the b̄ of this floor** (§3/§6) — unmeasured, banded 10⁷–10⁸, and
  the answer is ~linear in it. Pin it before trusting any single second-count.
- **The shallow board does not decompose.** The empty board and near-root positions are large
  connected components (long-range row/diagonal attacks keep them connected — the "game doesn't
  decompose" caveat). These are *few* large components whose children fragment; the lever bites on
  the deep bulk, not the root. The cost is the *count* of distinct components, dominated by the cheap
  deep ones plus a small expensive shallow tail.
- **A value-equivalence quotient below the iso quotient exists** (two non-isomorphic graphs can share
  a nimber) but isn't computable without solving — so ~10⁷–10⁸ is the *graph-structural* floor, not
  an information-theoretic one. Real but unusable as a base.
- **Validation has no external cross-check past the published frontier.** A344227 anchors through
  ~n=12; n=13 (the odd-n *value*) and n=14 would be firsts. The safety net is the same as n=18:
  `solver_lineage_agrees` + exact n≤12 nimbers matching A344227 through the rewrite, internal
  consistency (the XOR-decomposition agreeing with a no-decomposition mex on small n), and a
  re-verifiable checkpoint. **n=13 nimber is the natural first target** — smaller than n=14, and it
  exercises the full decomposition machinery with A344227 (if it lists n=13) or the no-decomposition
  solver as the cross-check.
- **Hardware inputs** are the win/loss floor's std-config estimates; they bound L2 (not binding here)
  and the compute rate (binding) — same caveat, same "worth measuring next."

---

## 8. n=16 nimber — the next frontier, and why it is *not* n=14

n=14 nimber is the program's last listed frontier; n=16 nimber is a step beyond it. The same
decomposition lever applies, but it **weakens with n**, and that — not the raw size — is the story.

### Naive: hopeless

Two steps further along the no-cutoff penalty (§1): the ratio rises ~1.8×/step (14× at n=8 → 265× at
n=13 → ~400× at n=14), so n=16 ≈ ~1000–2000×.

```
naive n=16 nimber ≈ 7.2×10⁹ × ~1300 ≈ ~10¹³ distinct   (larger than n=18 win/loss, ~3×10¹²)
```

~80 TB at 8 B/slot. Not a contest — same verdict as naive n=14, only more so.

### The lever weakens: long-range connectivity pushes fragmentation deeper

Decomposition (§3) collapses the work onto **small, heavily-shared, iso-merging** components. The
larger the board, the *worse* this gets, for the same reason "the game doesn't decompose":
disconnecting the available-graph requires placed queens to sever **every** connecting line — rows,
columns, and both long-diagonal families. A 16×16 board has more and longer lines than 14×14, so
fragmentation is pushed **deeper**, and a larger fraction of the ~10¹³ DAG sits in **large,
still-connected** components.

Large connected graphs are the lever's worst case on both counts: they barely **iso-merge** (the
3.4× merge is a small-component effect — a big graph is nearly unique up to isomorphism) and they do
not **decompose** (still one component). So the share of work the lever cannot touch *grows* with n.
The decomposition collapse is therefore smaller at n=16 than at n=14 — the opposite of what the raw
node counts might suggest.

### Can it fit? The band, vs n=14

| metric                                  | n=14 nimber           | n=16 nimber                              |
|-----------------------------------------|-----------------------|------------------------------------------|
| naive base (full DAG)                   | ~2×10¹⁰               | ~10¹³                                    |
| component base (the lever's work base)  | ~10⁷ – 10⁸            | **~10⁹ – 10¹⁰**                          |
| memory                                  | ~0.5 GB, cache-res.   | **~16 – 160 GB → BuRR / external memory** |
| compute floor                           | ~seconds              | **~minutes (if resident) → hours (DDD)** |

The component base widens *and* shifts up: ~10⁹–10¹⁰ distinct connected components no longer fits a
cache or even comfortably in RAM, so the component DB itself must move to a BuRR archive / external
delayed-duplicate-detection — the n=18-win/loss machinery, load-bearing again. Compute, *if* the set
stays resident, is ~minutes (10⁹–10¹⁰ comps × b̄≈10 × ~200 cyc ÷ 3×10¹⁰ ÷ 12); via external DDD
passes it is hours.

### Verdict

```
n=14 nimber:  feasible, clear win — seconds-to-minutes, cache-resident.
n=16 nimber:  plausibly feasible, materially riskier — BuRR component archive + inner-loop
              rewrite + no-cutoff parallelism; ~order of the n=16 win/loss effort or harder
              IF decomposition holds; n=18-scale (external, days) if the connected regime dominates.
```

n=16 nimber is **not** the cache-resident regime n=14 is. It sits beyond the current program and
shares the memory machinery of n=18 win/loss. Its feasibility rides entirely on **how strongly
decomposition collapses the work at n=16**, and that lever demonstrably weakens with n.

### The one measurement that decides it

Not any estimate above — the **growth rate of the distinct-connected-component count** across
n=10→12→14 (the `branching`/`tally` instrumentation). Two outcomes:

- **Shallow growth** (the count plateaus, like the #19 cache tying at 2²³ for n=16 win/loss) ⇒ n=16
  nimber lands near ~10⁹ components ⇒ ~hours, worth attempting.
- **Position-tracking growth** (~146× per two-step, like the distinct-position count) ⇒ n=16 nimber
  balloons toward ~10¹¹ ⇒ a days-long external-memory project, gated on the full n=18 machinery.

Measure that curve before treating n=16 nimber as anything more than "the frontier after n=14."
Validation is also strictly harder than n=14: A344227 anchors through ~n=12, so n=16 nimber has no
external cross-check at all — the n=18 verification burden (re-verifiable checkpoint, second
implementation, internal consistency) applies in full.
