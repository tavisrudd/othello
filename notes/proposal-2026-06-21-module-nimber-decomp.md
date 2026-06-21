# Modular decomposition + nimbers for the queen conflict graphs — does combining them revive the dead boolean lever?

**Date**: 2026-06-21
**Status**: DESIGN PROPOSAL — no source modified. Verdict-first; the decisive measurement is in §5.
**Scope**: the *internal* structure of a single connected component of a queen Node-Kayles
graph — **modular decomposition**, its special case **twin reduction**, **substitution
decomposition** — combined with **Sprague–Grundy / nimbers**. The disjoint-connected-component
decomposition (`g(G) = ⊕ g(Cᵢ)`) is a SEPARATE proposal and is out of scope here; I only touch
it where the two interact.

**Predecessor result this extends (do not re-derive):** the `12c5762` probe `module_profile`
(`graph.rs`) / `module_report` (`bin/queens.rs`) measured the boolean modular/twin kernel as
**MEASURED-DEAD** — pc 13–20 `reduces%` = `->≤12%` = **0%**, twin-pairs 3.8% at pc 13 decaying to
~0% by pc 18 (`notes/handoffs/2026-06-20-node-kayles-lit-levers.md`, "PROBE #1 RESULT"). The
question this proposal answers: **does the nimber framing change that verdict, or is the sparsity
fatal regardless?**

---

## TL;DR — VERDICT

**DEAD, and for a deeper reason than sparsity alone.** Two independent kill-shots, either fatal:

1. **Game-invariance fails for the most exploitable case.** Substitution/modular decomposition
   gives a clean Grundy factorization *only* when the module is an **independent set** (false
   twins, the "options compose" case) **or** when you accept it is **not** generally a clean
   factorization (true twins / clique modules / general modules need a *quotient-with-marked-
   vertices* game whose value does **not** reduce to a nim-sum). Node-Kayles is a **vertex**
   deletion game: a move on `v` deletes `N[v]`, and in a queen graph `N[v]` reaches *outside* the
   module through the module's shared external neighborhood. So a move inside a module is **not**
   confined to a sub-game on the module — it deletes external vertices too. The one place a module
   *does* compose cleanly (a true/false **twin pair**, the size-2 case) is exactly where the
   nimber framing might pay where boolean didn't (§2a) — but it runs into kill-shot 2.

2. **The sparsity is structural to the queen graph, not an artifact of the pc band measured.**
   A non-trivial module requires ≥2 vertices with *identical external adjacency*. In the queen
   conflict graph "adjacent" = "shares a row, column, or diagonal" (`geom.rs`: `attack[s]` = s's
   row/col/both diagonals). Two squares having the *same* set of attacked squares among the
   remaining live set is geometrically rare and gets rarer as the board fills — the probe already
   saw twin-pairs collapse 15% → 3.8% → ~0% across pc 9→18. §1 argues this is forced by the
   geometry: queens that are twins must be a very specific co-linear configuration, and the tail
   is too sparse/irregular to hold them.

**BUT there is one genuinely untested gap, and it is worth closing for ~0 build cost (§5):** the
prior probe ran over the **flat-TT recurse working set** (pc ≥ 9 distinct positions that get a
TT `put`). The `getK` dense evaluators at **pc 9–16** resolve their conflict graphs *inline* and
**never store a TT entry**, so those exact graphs are a *different population* — and the
`module_profile` tap, while it nominally covers pc 9–20, was reported and interpreted on the
pc 13–20 tail. The dense leaves (pc 9–12 especially) are a **denser** population near the W8
floor where twin-pairs were ~15% at pc 9. **The single measurement that settles it (§5): extend
the existing monomorphised tap to report `has-mod% / reduces% / ->≤8%` over the pc 9–16 getK leaf
population (the graphs `getK` actually evaluates), broken out by the *closed-twin* (clique, nimber-
exploitable) vs *open-twin* (independent) split, and add a twin-PAIR (size-2) reduction column the
boolean kernel ignored.** If even size-2 closed-twin pairs are <~5% of getK calls, the lever is
dead at the dense leaves too and we stop. I expect it dead; the measurement is cheap insurance and
is the responsible move per the project's "re-read measured vs reasoned" memory.

---

## 1. Theory — is a module even game-invariant for queen Node-Kayles?

### 1.1 The game and the graph

The game from any node is **Node-Kayles** on the *available-graph* `G`: vertices = remaining live
squares, edges = mutual-attack pairs (`geom.rs`: two squares are adjacent iff they share a row,
column, or either diagonal). A move places a queen on `v`, which deletes `N[v]` (the closed
neighborhood — `v` plus everything it attacks). `G ∖ N[v]` is the child. Win/loss is the boolean
`W(G) = ∃v · ¬W(G ∖ N[v])`; the nimber is `g(G) = mex_v g(G ∖ N[v])`.

### 1.2 What "module" means here

A **module** `M ⊆ V` is a set of vertices with **identical adjacency to every vertex outside
`M`**: for all `x ∉ M`, either `x` is adjacent to all of `M` or to none of `M`. Two sub-cases the
boolean kernel (`module_profile`) already separates:

- **clique module / closed-twin class** — pairwise-adjacent vertices sharing one *closed*
  neighborhood `N[v]`. A move on any member deletes the whole module plus its (shared) external
  neighborhood.
- **independent module / open-twin class** — pairwise-non-adjacent vertices sharing one *open*
  neighborhood `N(v)`.

A **twin pair** is the size-2 case (true twin = closed, false twin = open).

### 1.3 Does the module's contribution factor (like disjoint components do)?

**No — not in general, and this is the load-bearing theory point.** Disjoint components factor
because a move in one component cannot touch another (`g(G) = ⊕ g(Cᵢ)`; this is the OTHER agent's
clean lever and the existing `try_oracle_nimber`). A *module* is **not** a disjoint component: it
shares external neighbors with the rest of the graph. Two distinct failures:

**(a) The deletion reaches outside the module.** In Node-Kayles a move on a module vertex `v`
deletes `N[v]` = (the module's internal neighbors of `v`) ∪ (the module's *shared external
neighborhood* `N(M)`). So playing inside `M` **also deletes vertices outside `M`** — the rest of
the game is not left intact. This is unlike a *placement* game confined to a board region. There
is **no decomposition `g(G) = f(g(quotient), g(M))`** that ignores this coupling. Substitution
decomposition for impartial games requires the sub-position induced by a move to be a sum of an
*unaffected* part and a *local* part; the shared-external-neighborhood deletion breaks the
"unaffected part" premise.

**(b) Even the quotient game is not a nim-sum.** The literature lever (Kobayashi, Node-Kayles
parameterized by neighborhood-diversity / modular-width) makes Node-Kayles **FPT in modular-width**
— but FPT ≠ "the value is `⊕` of factor values". It computes the value by a DP over the modular
decomposition tree where each quotient node is solved by a small *marked/weighted* Node-Kayles
instance, **not** by composing independent Grundy values. The kernel `module_profile` implements
(clique ≥3 → 1 rep, independent ≥3 → 2 reps) is the *correct nimber-preserving contraction* — but
it only fires on **size-≥3** modules, and it is a *contraction that preserves the value*, not a
*factorization that cheapens the evaluation by composing sub-values*. So "modules + nimbers" does
not buy a `⊕`-style decomposition the way disjoint components do. The nimber framing does **not**
unlock a new compositional identity here.

### 1.4 Where nimbers *do* add something over boolean

The one concrete win the nimber framing has over boolean is for **size-2 modules (twin pairs)** and
the **isolated-vertex (K₁) case**, via two exact identities the boolean kernel cannot use:

- **K₁ (isolated vertex)**: `g(G ⊔ {v}) = g(G) ⊕ 1` (an isolated vertex is a 1-move Nim heap of
  size 1, nimber 1). Boolean can only cancel an *even* number of them (`g(G ⊔ 2·K₁) = g(G)`); the
  *odd / single* isolated vertex needs the core's nimber. This is **already known and already
  measured net-negative**: the `ISO_STRIP` pair-strip in `dense.rs` (the "two-for-one deal") is
  built, gated off, and **MEASURED-WASH** (`-0.3%` wall / `-1.0%` total cyc, even fused) because
  "getK peels isolated verts one ply at a time, so a level seldom has ≥2 isolated verts at once"
  (handoff `2026-06-19`, line 103-111). The 1-isolated case that *would* pay needs full nimbers —
  i.e. the parked `queens-component-nimber` branch (6.6× wall from cutoff-free nimber recursion).
- **Closed-twin pair (true twins, K₂-like)**: two mutually-adjacent vertices `u,v` with identical
  closed neighborhood. A move on either deletes the same `N[u]=N[v]`, so the *two moves are
  identical options* — the boolean kernel already dedups this for the win/loss sweep (it's a
  "branch on one, skip the other"). The nimber framing adds nothing here that boolean ordering/
  dedup didn't: identical options contribute one value to the `mex`/`∃`, full stop.
- **Open-twin pair (false twins)**: two non-adjacent vertices with identical open neighborhood.
  Here the two are an independent set; their joint contribution can be analyzed, but again the
  *deletion of the shared external neighborhood* couples them to the rest, so there's no clean
  `⊕`.

**Conclusion of §1:** Modules are **not** game-invariant in the disjoint-component sense for
Node-Kayles, because a move on a module deletes the module's *shared external neighborhood* too.
The nimber framing unlocks exactly two exact identities (odd-K₁ and twin-pair option-dedup), both
of which are **already known here and already measured net-negative/wash** (the `ISO_STRIP` strip
and the boolean twin-dedup the sweep already does). So the nimber framing does **not** by itself
change the verdict on the standalone modular lever. The only thing left untested is *prevalence on
a population the prior probe didn't isolate* — §2.

---

## 2. Sparsity reconsidered — does the nimber framing or a different population revive it?

### 2a. Does size-2 (twin) reduction pay where size-≥3 (boolean kernel) didn't?

The boolean kernel `module_profile` only *contracts* size-≥3 modules (clique ≥3 → 1 rep;
independent ≥3 → 2 reps) because size-2 doesn't shrink the vertex count under its rule. But the
prevalence probe *also* reported `has-mod%` (any module of size ≥2, i.e. including twin pairs) and
the older `struct_profile` `twin-pair%`. Those showed twin-pairs at **3.8% (pc 13) → ~0% (pc 18)**.

The nimber question: a closed-twin **pair** lets you skip one of two identical options (already
done by the boolean sweep's dedup), and an isolated-vertex pair cancels (already the `ISO_STRIP`
wash). **So even where a twin-pair exists, the nimber framing's exploit on it is the dedup/cancel
the search already does or has measured as wash.** A size-2 module does not contract under the
value-preserving kernel into a smaller `getK` call (it doesn't drop the popcount the way ≥3 does),
so it cannot turn a pc-13 graph into a pc-≤12 dense lookup — the actual payoff mechanism the lever
needed. **Verdict for 2a: no. Size-2 does not pay; the framing's size-2 exploits are the
already-measured-wash ones.**

### 2b. Did the prior probe measure the right population? (the one real gap)

**This is the genuine untested angle, and the reason this proposal exists rather than just citing
probe #1.** Two distinct populations:

- **Flat-TT recurse working set** — the `(Bits, u8)` exact map `working_set()` returns, populated
  at TT `put` sites. With `QUEENS_DENSE_K = 16` the recurse arm only fires for `pc > recurse_min =
  max(DK, block_k, iso_max_avail) = 16`, so production stores **pc ≥ 17**. The probe was run on an
  **iso-flat** count (no dense tables), whose working set IS the full pc 9–21 distinct set — so
  the probe *nominally* covered pc 9–16. But the report (`module_report`, `lo=9 hi=20`) and the
  handoff interpretation focused on the **pc 13–20 tail**, where `reduces%` = 0%.

- **`getK` dense-leaf population (pc 9–16)** — the graphs the dense evaluators `get9..get16`
  actually chew on. In production these fire on **every** `pc == k` node (the `DK >= k && pc == k`
  arms, lines 2340-2355 of `iso_flat.rs`), resolve the conflict graph by the boolean Node-Kayles
  recurrence *inline*, and **never store a TT entry** (`w16_get` → `dense8.get16`, no `put`). This
  is `~35%` of all search cycles (the hot bucket). These pc 9–16 graphs are a **different, denser**
  population than the pc 13–20 *recurse* tail: they live near the W8 floor, and at pc 9 the prior
  probe itself reported **~15% twin-pairs** (decaying with pc). The decisive number was never
  isolated *for this population* and *for the value-preserving size-≥3 contraction targeting the
  W8/≤8 floor* (not the W12 frontier — `getK` already reaches pc 16, so the relevant reduction
  target is `->≤8` to hit the complete dense tables, or `->≤(k-1)` to drop a getK layer).

So the precise gap: **the prior probe's `->≤12%` gate was the wrong target for the getK population**
(it asks "does it fall into W12?", but getK now goes to W16). For the dense leaves the right gates
are (i) `->≤8%` — does the modular kernel collapse a pc 9–16 graph all the way into the *complete*
W0..W8 tables (one lookup, no nested sweep)? and (ii) `->≤(k−1)%` — does it drop at least one getK
layer (cheaper nested sweep)? **Neither was measured.** That is the §5 measurement.

**My prior (be clear, not hopeful):** I expect it still dead, because the geometry argument in §1
(twins require specific co-linear queen configurations and the kernel needs size-≥3, which the
probe saw at 0%) is population-independent — pc 9–16 graphs are denser but the *module* structure
is about adjacency *regularity*, which queen graphs lack at any density. But pc 9–12 is the one
band where `has-mod%` was double-digit, the population is huge (35% of cycles), and the measurement
is ~0 cost. The project's standing memory ("a 'measured-negative' lever often only tested a narrow
case; re-check before believing it") makes this exactly the case to re-check.

---

## 3. If ALIVE — the cheapest implementation (so we know the shape before measuring)

Sketched only so §5's measurement has a concrete payoff target; **do not build before §5 passes
its kill-criterion.**

**Slot-in point:** inside `getK` (`dense.rs`), *before* the K-move child sweep, after
`extract_adj`. The adjacency rows `adj:[u16;16]` are already materialized; the twin/module test is
O(K²) `u16` compares on them (cheap relative to the K-move pext sweep). If the kernel contracts the
graph to `k' < k`, recurse via `get_dyn(k', reduced_code)` (the dispatcher already exists for the
`ISO_STRIP` tail-call). Concretely:

- **Closed-twin (clique-module) contraction**: partition the K rows by equal *closed* row
  (`adj[i] | (1<<i)` equal ⇒ same `N[v]`). A class of size `s ≥ 3` contracts to 1 rep
  (`reduced_pc -= s-1`). This is the value-preserving rule already coded in `module_profile`;
  porting it to operate on the `u16` `adj[]` and re-pack the surviving vertices into a smaller
  code via `pext` (the existing `induced`-mask machinery) is the build.
- **Open-twin (independent-module) contraction**: partition by equal *open* row (`adj[i]` equal,
  `i` not adjacent to the class). Size `s ≥ 3` → keep 2 reps (`reduced_pc -= s-2`).

**Fermi.** The lever pays iff: `(fraction of getK calls that contract) × (cycles saved by the
smaller/eliminated sweep) > (twin-test cost on every getK call)`. The twin-test is ~K²/2 `u16`
ALU ops ≈ 60–120 cyc at K=12–16, paid on **every** getK call. A pc-13 graph that contracts to
pc-≤8 saves the entire 13-vertex nested sweep (a full getK call, hundreds-to-thousands of cyc) and
replaces it with one W8 lookup — a ~10–50× local win *on that node*. So the break-even contraction
rate is roughly `twin_test_cost / sweep_cost ≈ 100/2000 ≈ 5%`. **If §5 shows `->≤8%` ≥ ~5% in the
getK population, the lever is alive; if `<~2%`, dead.** (This mirrors the project's `ISO_STRIP`
post-mortem: a per-call check that fires rarely costs more than it saves — the strip's `+3.4%
cyc/node` at <fire-rate.)

**Kill-criterion (build):** after a gated `getK` twin-contraction (const `MOD_STRIP=false`
substrate, DCE'd off like `ISO_STRIP`), a 4-round interleaved n=16 A/B (`scripts/queens-ab.sh 16
QUEENS_MODSTRIP ./target/release/queens`, 12 GB TT) must show **total-cycle reduction with
byte-identical node set** (the contraction is value-preserving; the validation gate
`solver_lineage_agrees` + n=14 iso-flat `--distinct` 29.2M must hold). If it's wash/negative like
`ISO_STRIP`, revert to substrate and record the negative.

---

## 4. If DEAD — say so loudly, and what it kills

**It is dead as a standalone lever, by §1 (no clean factorization; the two nimber identities are
already-measured wash) and §2a (size-2 doesn't pay, size-≥3 is 0% in the tail).** The one residual
uncertainty (§2b, the getK leaf population) is closed cheaply by §5; my prior is it confirms dead.

**What this kills / weakens (consistent with the lit-handoff's "structural-reduction cluster"
verdict):**

- **Item A (reduce-then-W12 evaluator)** — dead, both as boolean (probe #1) and as nimber-framed
  (this proposal): the framing adds no compositional identity, and the prevalence is absent.
- **Item B (full modular decomposition on hot shapes)** — *weakened to dead-on-arrival*: full
  modular decomposition's payoff is modular-width FPT, which needs prevalent non-trivial modules;
  if size-2 twins are ~0% in the tail, the modular-decomposition *tree* is trivial (every vertex
  its own module = "prime" graph) and the DP degenerates to brute force. No gain.
- **Items D/E (setrograde / partition-search keyed on module patterns)** — *weakened*: their TT
  generalization keys on shared *module/twin skeletons*; if those skeletons are ~0%, there's no
  pattern to key on. (A *non-module* pattern key — e.g. by canonical graph family — is a different
  lever and not refuted here; the OTHER agent's component-decomposition and the existing graph-iso
  key already capture the merge-by-shape gain.)

**What this does NOT kill** (orthogonal, still open): disjoint-connected-component decomposition +
component-nimber XOR (the OTHER agent's scope; the `try_oracle_nimber` infra + parked
`queens-component-nimber` branch — that lever's problem is the *cutoff-free recursion cost* 6.6×,
not module prevalence); getK throughput micro-opts; MLP-batched probes; move-ordering. The node-
count lever that survives in this neighborhood is **connected-component decomposition with a dense
Grundy table for components ≤8** (W8-shaped but nimber-valued, no recursion) — but that is the
disjoint-component lever, not modular decomposition of a single component.

---

## 5. THE SINGLE MEASUREMENT THAT SETTLES IT

Extend the existing monomorphised cold tap (zero production cost, the project's standard pattern —
`module_profile` in `graph.rs`, reported by `module_report` in `bin/queens.rs`) to measure the
**getK dense-leaf population**, with the **right reduction targets** and a **twin-pair (size-2)
column** the boolean kernel ignored. Concretely, three additive changes to the cold path:

1. **Population**: run `module_profile` over the **pc 9–16 graphs `getK` actually evaluates**, not
   only the flat-TT recurse working set. Two ways, pick the cheap one:
   - *(cheapest, recommended)* run the existing `count --comps` `module_report` on an **iso-flat**
     working set (no dense tables ⇒ its exact map includes every pc 9–16 distinct position) but
     **re-report the pc 9–16 band specifically**, and add the targets below. iso-flat's pc 9–16
     distinct set *is* the getK-evaluated population up to canonicalization. (The prior run had the
     data but reported/interpreted pc 13–20.)
   - *(more faithful, if (i) is doubted)* add a gated `M_MODPROF` monomorphisation that taps each
     `getK` call's `(adj, k)` directly in `dense.rs` (const-generic, DCE'd in production), so the
     population is exactly the getK calls with their true frequency weighting.

2. **Targets**: report, per pc 9–16, `has-mod%` (size-≥2, split closed-twin vs open-twin),
   `reduces%` (size-≥3 contracts), and the two getK-relevant gates **`->≤8%`** (collapses into the
   complete W0..W8 tables — one lookup, no sweep) and **`->≤(k−1)%`** (drops ≥1 getK layer). These
   replace the obsolete `->≤12%` gate (getK now reaches W16, so W12 is no longer the frontier).

3. **Twin-pair column**: add `twin-pair-closed%` (size-2 clique modules — the option-dedup case)
   and `twin-pair-open%` (size-2 independent — the cancel case), so we see the size-2 prevalence
   the boolean ≥3 kernel structurally couldn't act on.

**Kill-criterion (measurement):** the lever is **alive** only if, in the pc 9–16 getK population,
either `->≤8%` ≥ ~5% (the §3 Fermi break-even) in any band carrying real search weight, OR a
twin-pair column is high enough that a value-preserving *option-dedup inside getK* (skip the
duplicate child in the K-move sweep) measurably trims the sweep. **Otherwise: dead, recorded
loudly, and items A/B/D/E (the structural-reduction cluster) close — point the next lever at
disjoint-component nimber decomposition or getK throughput.** Expected outcome (my prior): dead at
pc 13–16 (geometry forbids the modules), marginal at pc 9–12 (the denser leaves, ~15% twin-pairs
at pc 9) but below the 5% `->≤8` contraction break-even because twin-*pairs* don't contract — so a
clear, cheap, documented negative that finally closes the modular-reduction thesis on the
*correct* population.

---

## Codebase reference (for whoever runs §5)

| What | Where |
|------|-------|
| boolean modular/twin kernel + `ModuleStats` (extend this) | `rust/src/queens/graph.rs` `module_profile` / `struct_profile` / `twin_vertices` |
| the cold report to extend (add targets + twin-pair cols) | `rust/src/bin/queens.rs` `module_report` / `comps_struct_report` |
| getK dense evaluators (the population; the slot-in point) | `rust/src/queens/dense.rs` `DenseW8::get9..get16`, `extract_adj`, the `ISO_STRIP` substrate |
| getK dispatch (pc==k arms, no TT put — why getK graphs aren't in the working set) | `rust/src/queens/solver/iso_flat.rs` lines ~2340-2355 (`w16_get`..`w9_get`), `mtt_put` |
| exact working-set capture (the population the prior probe used) | `rust/src/queens/tt.rs` `working_set` (recorded at `put`, COUNT path) |
| disjoint-component nimber infra (OTHER agent's lever; the clean `⊕` case) | `iso_flat.rs` `try_oracle_nimber` / `comp_nimber` / `position_nimber`; parked branch `queens-component-nimber` (abf38ee) |
| the `ISO_STRIP` wash post-mortem (why a per-getK-call check that rarely fires loses) | `notes/handoffs/2026-06-19-explicit-stack-frontier.md` lines 103-111 |
| probe #1 (the boolean modular kill) | `notes/handoffs/2026-06-20-node-kayles-lit-levers.md` "PROBE #1 RESULT" |

## Principles honored
- **Measure-first**: no build before the §5 cheap tap passes its kill-criterion (the project's
  repeated lesson; probe #1 + getK-reshape both closed for ~0 build cost by measuring first).
- **Re-read measured vs reasoned** (auto-memory): probe #1 measured a *narrow* population (flat-TT
  recurse tail, wrong `->≤12` gate); §5 re-checks the getK leaf population with the right gates
  before declaring it closed forever.
- **No hard-floor claim**: the verdict is "dead on the evidence + geometry argument", with the one
  remaining cheap measurement named — not "unreachable". The user decides if it's a limit.
- **Total cycles, interleaved A/B** is the metric for any build (§3 kill-criterion).
