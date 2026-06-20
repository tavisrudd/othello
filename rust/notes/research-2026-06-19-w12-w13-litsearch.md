# W12/W13 kernel — literature search for cheaper-equivalent evaluation (2026-06-19)

**Scope.** The `W_K` hot kernel evaluates a labelled K-vertex graph `G` (K=12 or 13) by
`W_K(G) = ∃v · W_{K-1}(G∖N[v]) is a LOSS`, bottoming out in complete W0..W8 tables. Per node
it builds a labelled upper-triangular edge code in a `u128` and, for each of K candidate moves,
projects the child's induced edge code with a two-word BMI2 `pext` and looks it up. K=13 is
net-negative: the per-node `pext`/projection cost exceeds the probes it saves.

This is **Node Kayles** (a.k.a. the vertex-deletion / vertex-domination impartial game). That
name unlocks a focused, decades-deep literature. Below: actionable findings, EXACT vs heuristic,
how each maps to `get12`/`get13`, and a realistic verdict vs the current pext-project + lookup.

Conventions: "nimber"/"Grundy value" `G(·)`; a position is a LOSS (P-position) iff `G = 0`. Our
kernel only needs the boolean P/N, but several results are stated for the full nimber (strictly
more than we need, and cheaper to specialise to a 0/≠0 test).

---

## TL;DR ranking (most to least likely to beat the current kernel)

1. **Module / twin nimber-preserving reductions (Lemmas 12–13, Yoshiwatari et al.)** — EXACT, the
   strongest lever. Shrink K *before* you spend any `pext`: identify true-twin (clique) and
   false-twin (independent) modules and collapse them, dropping a K=13 graph to a smaller K that
   may land directly in a W≤8 table. Cheap to detect with the adjacency rows you already build.
2. **Join / disjunctive-sum (component) decomposition** — EXACT, partly used. A *join* component
   (every-to-every) collapses to a single move; disjoint components XOR. Detecting either short-
   circuits the K-move sweep. The clique special case `G(K_m)=1` is a one-instruction closed form.
3. **Closed-form nimbers for path / cycle / regular-tree induced subgraphs** — EXACT, narrow. If a
   child is a path/cycle/tree, read its nimber from a period-34 (path) table instead of recursing.
   Applies only to the structured slices of queen subgraphs; bounded but free where it hits.
4. **K-set DP framing (Bodlaender–Kratsch)** — EXACT, reframes the *whole* search rather than the
   per-node kernel; explains why our node counts are what they are and bounds them (`O(1.6052^n)`).
   Not a per-node speedup but the right mental model for where the W_K layer sits.
5. **Fast/canonical induced-subgraph encoding (nauty/graph6, incremental codes)** — mostly a
   DEAD-END for *speed* at this size; canonical labelling is far more expensive than our `pext`.
   The labelled-code + table is already near-optimal for the encode step.

---

## 1. Module / twin reductions that preserve the nimber (THE lever) — EXACT

**Source.** T. Yoshiwatari, H. Kiya, T. Hanaka, H. Ono, *On Structural Parameterizations of Node
Kayles*, WALCOM/IEICE 2021. arXiv: https://arxiv.org/abs/2003.11775 ·
HTML: https://ar5iv.labs.arxiv.org/html/2003.11775 ·
Springer: https://link.springer.com/chapter/10.1007/978-3-030-90048-9_8

**What it proves (extracted from the HTML).** Two reductions on *modules* (vertex sets `M` with
identical adjacency to every vertex outside `M`):

- **Lemma 12 (clique module).** Let `M` be a **clique module** of size ≥ 3 in `G`, and `H` the
  graph obtained by identifying `M` into a single vertex `v_M`. Then `nim(G) = nim(H)`.
- **Lemma 13 (independent module).** Let `M` be an **independent module** of size ≥ 3 in `G`, and
  `H` obtained by deleting `|M|−2` arbitrary vertices of `M` (keep two). Then `nim(G) = nim(H)`.

Combined, these give a **kernel of ≤ 2·nd(G) vertices**, where `nd(G)` is the *neighborhood
diversity* (number of classes of vertices sharing the same neighborhood type). The same idea
underlies their `O*(3^τ)` (vertex-cover) and `O*(1.6031^{mw})` (modular-width) algorithms.

A weaker but even cheaper cousin is the **twin-equivalence lemma** for the matching-structure
games (Hanaka et al., *Winner Determination Algorithms for Graph Games with Matching Structures*,
https://arxiv.org/abs/2211.05307, Lemma 2): if two vertices are equivalent w.r.t. the played set,
moves on them yield equal game value — so among a class of equivalent vertices you only branch on
**one representative**.

**EXACT?** Yes. Nimber-preserving and winner-preserving; safe for a verdict.

**How it maps to get12/get13.** We already recover each vertex's adjacency row (a `u16`/`u32`
bitmask over the ≤K live squares) to do the projection. Two vertices `u,v` are:
- **true twins** (clique module of size 2) iff `row[u] | bit[u] == row[v] | bit[v]` (same *closed*
  neighborhood) — i.e. adjacent and identical otherwise;
- **false twins** (independent module of size 2) iff `row[u] == row[v]` and `u,v` non-adjacent
  (same *open* neighborhood).
Detecting all twin pairs is an `O(K^2)` row-equality scan over `u16` masks — well under a hundred
cycles for K=13, *cheaper than a single two-word `pext`*. Then:
- **A move on either twin produces the same child** (`N[u]` and `N[v]` delete the same set up to the
  twin) ⇒ **collapse the K candidate moves to one per twin class** before any `pext`. This directly
  attacks the "K children" factor that makes K=13 expensive — duplicate children are never encoded
  or probed.
- **Lemma 13 parity collapse:** ≥3 mutually-false-twin vertices ⇒ delete down to 2, *shrinking K
  itself*. A K=13 graph with a size-3 false-twin module becomes K=11; with a clique module (Lemma
  12) it shrinks further. Crucially, **a few collapses can drop K below 9, landing the whole graph
  directly in a W≤8 table — skipping the W_K layer entirely.**

**Verdict vs current kernel.** This is the most promising EXACT win. It doesn't make a *single*
`pext` cheaper; it **removes children and removes vertices**, which is exactly the K-factor and the
K=13 net-negativity. Twin detection is `O(K^2)` mask-equality (cheaper than one `pext`), so even a
modest hit rate pays. The open empirical question (channel Fermi first): **how often do queen
induced subgraphs at K=12/13 actually contain non-trivial twin/clique modules?** Queen adjacency is
dense and geometric, so true size-≥3 modules may be rare — but size-2 twins (two squares with
identical attack sets among the survivors) are plausibly common in the thinned-out late graphs,
and *each one halves that vertex's branch*. Recommend a `count --modules` style instrumentation
pass (one-shot, monomorphised, per the hot-path-toggle rule) to measure module incidence at K=12/13
before implementing — the napkin says "collapse duplicate children + occasionally drop K," and the
measured incidence decides whether it clears the `O(K^2)` scan cost.

---

## 2. Join / disjunctive-sum (component) decomposition — EXACT, extends what we already do

**Sources.** Sprague–Grundy for disjunctive sums (standard; Bodlaender–Kratsch *Kayles and
nimbers*, UU-CS-2000-42, https://webdoc.sub.gwdg.de/ebook/serien/ah/UU-CS/2000-42.pdf). Cograph /
modular-decomposition framing: Node-Kayles solvable in poly time on cographs via Sprague–Grundy
over the modular decomposition tree (Yoshiwatari et al. above; survey corroboration in the search
trail).

**Two exact structural rules:**
- **Disjoint union (parallel module):** `G(G1 ∪ G2) = G(G1) ⊕ G(G2)` (nim-sum). The search already
  uses component XOR partially.
- **Join (series module), the underused one:** in `G1 + G2` (every vertex of `G1` adjacent to every
  vertex of `G2`), *any* move deletes `v` plus `N[v]`, and since `N[v]` spans the entire opposite
  part, **one move annihilates the whole other side**. So a join behaves like a single "super-move"
  layer. Special case: a **clique** is the join of singletons ⇒ `G(K_m) = 1` for all `m` (one move
  empties it) — a literal closed-form, zero `pext`.

**EXACT?** Yes — pure Sprague–Grundy.

**How it maps to get12/get13.** Before the K-move sweep, test the live graph for:
- **Disconnection** (a BFS/union-find over the `u16` rows, `O(K + edges)`): if `G` splits, evaluate
  components independently and XOR. A K=13 graph that splits into a 6 and a 7 never touches the W_K
  layer — both halves are W≤8 table hits.
- **A universal vertex / join structure** (`row[v]` covers all other live bits): collapses the
  branch dramatically; a clique is an immediate `G=1`.

**Verdict vs current kernel.** Component splitting is the highest-value *exact* short-circuit when
it fires, because it converts one expensive K=13 node into two cheap table lookups. The catch: by
K=12/13 the search has usually *already* peeled components (the note on component-nimber work
confirms whole-graph dedup), so the **incremental** catch rate at exactly K=12/13 is the thing to
measure — connectivity may already hold there. The join/universal-vertex test is cheap (`O(K)` per
node) and worth folding into the same pre-sweep pass as the twin scan. Net: a cheap pre-sweep
(`connected? · universal-vertex? · twin-classes?`) that, on a hit, skips the K `pext`s entirely;
on a miss, falls through to today's path. Risk is low (the pre-sweep is `O(K^2)` worst-case, < one
`pext`), upside is K=13 nodes that vanish.

---

## 3. Closed-form nimbers for path / cycle / regular-tree induced subgraphs — EXACT, narrow

**Sources.**
- **Path nimbers are eventually periodic** — Songsuwan et al., *Node-Kayles on Trees*, 2025,
  https://arxiv.org/abs/2512.24221 (HTML https://arxiv.org/html/2512.24221v1): the Grundy sequence
  `G(P_n)` has **preperiod 51, period 34**, repeating block
  `8,1,1,2,0,3,1,1,0,3,3,2,2,4,4,5,5,9,3,3,0,1,1,3,0,2,1,1,0,4,5,3,7,4`. For **n-regular trees**:
  `G = 1` (n odd), `G = 2` (n even); for two regular trees joined by a path, explicit
  eventually-periodic formulas.
- **More families** — Wong & Wu, *Nimber Sequences of Node-Kayles Games*, JIS 23 (2020),
  https://cs.uwaterloo.ca/journals/JIS/VOL23/Wong/wong24.pdf: closed-form / eventually-periodic
  nimbers for 3-paths, lattice (grid) graphs, prism graphs, chained/linked cliques, linked cycles,
  hypercubes, generalized Petersen graphs.

**EXACT?** Yes — proven nimbers.

**How it maps to get12/get13.** A child of a queen subgraph is occasionally a simple structure (a
path/cycle of survivors along a rank/file/diagonal, an isolated edge, a small clique). Detect the
shape cheaply (degree sequence + connectivity over the `u16` rows) and read `G` from a tiny constant
table (the 34-entry path block, etc.) instead of probing/recursing.

**Verdict vs current kernel.** Real but **narrow** — only the structured slices benefit, and at
K=12/13 a randomly-thinned queen graph is usually not a clean path/cycle. The shape test is cheap,
but the hit rate is the bottleneck. Treat as a *secondary* fast-path stacked on top of §1–§2: after
twin-collapse and component-split, the residue is more likely to be a small structured piece, so
this pays better *downstream* of the reductions than as a standalone test. Priority: low-to-medium,
implement only if §1–§2 leave a measurable tail of path/cycle-shaped children.

---

## 4. K-set DP framing — EXACT, reframes the search, not the per-node kernel

**Sources.** Bodlaender, Kratsch, Timmer, *Exact algorithms for Kayles*, TCS 562 (2015),
https://www.sciencedirect.com/science/article/pii/S0304397514007324 (slides:
https://kam.mff.cuni.cz/conferences/wg2011/files/slides/exact_kayles.pdf); origin
*Kayles and nimbers*, UU-CS-2000-42 (above).

**The idea.** A **K-set** is a non-empty `W ⊆ V` such that `G[W]` is connected and `W = V ∖ N[X]`
for some independent set `X` (i.e. `W` is exactly a reachable connected residual position). Every
position whose nimber the search needs is a `G[W]` for some K-set `W`. A DP over **all K-sets**
solves Node Kayles, visiting `O(1.6052^n)` positions (`O(1.6031^n)` for the winner via
measure-and-conquer); for trees this K-set count is tight.

**EXACT?** Yes — this *is* the exact algorithm; our search is an instance of it.

**How it maps to get12/get13.** Not a per-node `pext` speedup. Its value is **diagnostic and
architectural**: (a) it bounds the reachable-position set and explains node counts; (b) it confirms
the right keys are *connected residuals* (`G[W]` for K-sets), which is exactly what the W_K tables
should be indexed by — reinforcing the component-split lever in §2 (a K-set is connected by
definition, so any *disconnected* `G` should be split *before* it's ever treated as a position).
(c) The measure-and-conquer "non-standard measure" is the formal backing for "prefer reductions
that shrink the measure fastest" — i.e. §1's vertex-dropping over per-node cycle-shaving.

**Verdict.** Keep as the governing model; not itself a kernel optimization.

---

## 5. Fast / canonical induced-subgraph encoding — mostly DEAD-END for speed at this size

**Sources.** McKay & Piperno, nauty/Traces canonical labelling + graph6 encoding
(https://pallini.di.uniroma1.it/, format https://mbojan.github.io/rgraph6/); generic canonization
engineering survey https://arxiv.org/abs/1711.08289; graph-hashing https://arxiv.org/abs/2002.06653.

**What they offer.** Canonical labels give a *unique* representative per isomorphism class, so
isomorphic positions collapse in the table (more sharing than a labelled key). graph6 packs the
adjacency triangle into bytes.

**EXACT?** The *canonical key* is exact; but it answers a different question (isomorph-merging),
not "make the per-node encode cheaper."

**Verdict vs current kernel — flag as a dead-end for the stated goal.** Canonical labelling (nauty)
costs orders of magnitude more than our `pext` projection — the project's own iso-key notes already
measured the iso/graph key at ~100× the D4 key and ~2.2× slower overall despite fewer nodes. Our
labelled upper-triangular `pext`-into-table *is already the cheap end* of the encode spectrum; you
do not beat a two-word `pext` with a canonicalizer. The only encode-side win that's plausibly
cheaper is **incremental code maintenance**: since a child differs from the parent by deleting
`N[v]`, maintain the edge code by *masking out* the deleted rows/columns rather than re-`pext`-ing
from scratch. That's an engineering micro-opt (and per the project's own "micro-opts wash out"
discipline likely ~0–5%), not a literature algorithm — note it but don't expect it to flip K=13.

---

## Synthesis — the recommended stack (all EXACT)

Fold a single **`O(K^2)` pre-sweep** in front of the K-move `pext` loop, ordered cheapest-first,
each step short-circuiting on a hit:

1. **Connectivity / component split** (§2) — if disconnected, XOR component nimbers (W≤8 hits).
2. **Universal vertex / clique / join** (§2) — closed-form `G(K_m)=1`, or single super-move.
3. **Twin-class collapse** (§1, Lemma 2 / Lemmas 12–13) — dedupe candidate moves; drop independent-
   module vertices to shrink K (possibly below 9 → straight into a W≤8 table).
4. **Structured-shape closed form** (§3) — path/cycle/small-tree residue → constant-table nimber.
5. **Fallthrough:** today's labelled-code + per-child `pext` + table lookup.

Every step is nimber-/winner-preserving, so the verlict gate (`solver_lineage_agrees`, distinct
counts) is preserved by construction. The pre-sweep's cost is bounded by `O(K^2)` `u16`-mask ops
(< one two-word `pext`), so a miss is nearly free; a hit removes children or whole nodes — directly
attacking the K-factor that makes K=13 net-negative.

**Channel Fermi before coding:** the entire payoff hinges on **module/twin/component incidence at
K=12/13 in queen subgraphs**, which is unmeasured. Queen graphs are dense and geometric, so size-≥3
modules and disconnections may be rarer here than in the worst-case literature graphs — but size-2
twins (squares with identical surviving attack sets) and the universal-vertex test are plausibly
frequent in the thinned late graphs. **Recommend a one-shot monomorphised instrumentation count**
(twin-pairs, module sizes, component count, universal-vertex rate, path/cycle-shaped residue rate at
K=12 and K=13) as the gating measurement; if incidence is low, the literature lever is real but the
queen-graph structure doesn't feed it, and the conclusion is "K=13 stays off" rather than a new
kernel — record either way as an instructive result.

**Honest dead-ends:** canonical labelling (§5) is slower not faster; the exact-exponential bases
(`1.6031^n`, `1.4423^n` trees) describe the *whole* search's asymptotics, not a per-node constant,
so they don't shrink a K=12/13 evaluation directly; and the parameterized FPT machinery (vertex
cover `3^τ`, modular width) only helps insofar as it surfaces the *reductions* in §1 — the
parameter bounds themselves aren't a kernel speedup.

## Sources

- Yoshiwatari, Kiya, Hanaka, Ono — On Structural Parameterizations of Node Kayles —
  https://arxiv.org/abs/2003.11775 · https://ar5iv.labs.arxiv.org/html/2003.11775
- Hanaka et al. — Winner Determination Algorithms for Graph Games with Matching Structures —
  https://arxiv.org/abs/2211.05307
- Songsuwan et al. — Node-Kayles on Trees (2025) — https://arxiv.org/abs/2512.24221
- Wong & Wu — Nimber Sequences of Node-Kayles Games, JIS 23 (2020) —
  https://cs.uwaterloo.ca/journals/JIS/VOL23/Wong/wong24.pdf
- Bodlaender, Kratsch, Timmer — Exact algorithms for Kayles, TCS 562 (2015) —
  https://www.sciencedirect.com/science/article/pii/S0304397514007324 (slides:
  https://kam.mff.cuni.cz/conferences/wg2011/files/slides/exact_kayles.pdf)
- Bodlaender & Kratsch — Kayles and nimbers, UU-CS-2000-42 —
  https://webdoc.sub.gwdg.de/ebook/serien/ah/UU-CS/2000-42.pdf
- Schaefer — On the complexity of some two-person perfect-information games, JCSS 16 (1978)
  [Node Kayles PSPACE-completeness]
- Noon & Van Brummelen — The Non-Attacking Queens Game, College Math. J. 37(3), 2006 —
  https://www.jstor.org/stable/27646335
- McKay & Piperno — nauty/Traces canonical labelling — https://pallini.di.uniroma1.it/ ;
  graph6 format — https://mbojan.github.io/rgraph6/
