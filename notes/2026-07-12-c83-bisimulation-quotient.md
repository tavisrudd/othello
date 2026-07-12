# C83(3) — coarsest Grundy-respecting congruence of the residual grid game

**Date:** 2026-07-12. Lane: bottom-up measurement of whether a bounded bulk quotient of
the odd-plane residual game exists at all. Companion: [C80 game-side probe](2026-07-12-c80-bulk-exhaustion-probe.md).

## The measurement and why it is decisive

C79-note goal 2 asks for "a game-valid quotient into component types preserving P/N." All
prior quotient work was **top-down** (propose a signature — static feature, character,
moment — then test collisions; every such family collapsed, C55/C64/C69/C75/C76/C79). C83
measures the canonical object **bottom-up**: the coarsest partition of the exact residual
game states that any valid quotient could use.

The residual grid game (PG(2,q) after the opening pair) is an impartial game: state = a
legal cap on the `q×q` affine grid (affine cap + ≤1 per row + ≤1 per column), a move adds
one cell. Its **coarsest bisimulation** — the coarsest partition where same-class states
have the same set of successor-classes — is exactly the coarsest Grundy-respecting
congruence: Grundy value is a bisimulation invariant (bisimilar states have identical
successor-class sets, hence identical Grundy by induction), so the coarsest bisimulation
already refines the Grundy coloring, and any Grundy-respecting congruence is a bisimulation.
Its class count is therefore the **minimum number of classes any bulk quotient can have**.

Dichotomy:
- **small / stable across q** ⇒ a bounded quotient exists; the odd-plane escape theorem can
  take an octal-periodicity shape (finite automaton with arithmetic transition guards; C82
  would count the reply guards).
- **grows with q** ⇒ no bounded quotient; close the quotient lane and concentrate C80 on
  abundance/descent.

## Method

`rust/scripts/c83_bisim.rs` (standalone, `rustc -O -C target-cpu=native`): enumerate every
state reachable from the empty residual position, compute Grundy values (mex, reverse
topological by popcount), then coarsest bisimulation by Kanellakis–Smolka signature
refinement seeded with Grundy. Memory-compact single-copy layout (open-addressing interner,
CSR built id-ordered in a second pass, hashed refinement signatures).

**Symmetry reduction.** The full DAG is too large past q=11 (q=13 has 435,071,066 states /
2.72 B edges — beyond the box). But the residual game is invariant under grid **translations**
`(x,y) ↦ (x+e, y+f)` (they permute rows/columns and preserve affine lines), which are game
automorphisms; symmetric states are bisimilar, so canonicalizing each state by the
lexicographic min over its `q²` translates gives the **identical** coarsest-bisimulation class
count on a ~`q²`-smaller graph. Validated: canonical q=11 reproduces exactly 29 classes (same
refine rounds, same per-Grundy split) with states cut 121× (exactly `q²`) to 129,732. So the
class counts below are the **full-game** quotient, computed on the translation-reduced graph.

`rust/scripts/c83_bisimulation.py` is the Python reference used to validate the full (un-reduced)
Rust at q=11 (identical states/edges/Grundy histogram/classes).

## Results

Class count = coarsest-bisimulation classes of the full residual game (translation-invariant).
"canon states" is the translation-reduced state count actually enumerated.

| q | full-DAG states | canon states | Grundy values | **bisim classes** | classes/Grundy | refine rounds |
|---|-----------------|--------------|---------------|-------------------|----------------|---------------|
| 11 | 15,697,452 | 129,732 | {0,1,2,3} | **29** | {0:11, 1:8, 2:5, 3:5} | [4,10,17,26,28,29,29] |
| 13 | 435,071,066 | 2,574,386 | {0,1,2,3} | **65** | {0:29, 1:13, 2:9, 3:14} | [4,11,20,34,47,64,65,65] |
| 17 | _(running)_ | | | | | |

Root Grundy 0 at q=11 and q=13 (⇒ PG(2,11), PG(2,13) = P), consistent with the known solves.

### Interpretation — the quotient GROWS

The load-bearing quantity is the slope, and it is clearly positive: **29 → 65** from q=11 to
q=13 (2.24×; Grundy range unchanged at {0,1,2,3}). So the coarsest *raw-state* quotient is
**not bounded** — there is no small finite automaton on residual states, and the naive
"octal-periodicity" shape is unlikely. This matches the static-selector-impossibility results
(C75/C76/C79) and the irregular depletion set `{11,17}`: no bounded *static* quotient.

**But "raw quotient grows" ≠ "intractable."** The coarsest bisimulation of the whole state
space is not the tractability test: Node-Kayles can be tractable on a graph *family* with a
bounded **structural parameter** (modular-width, controlled alternating cycles, restricted
minors — Kobayashi's structural parameterization) even when the state-space quotient blows up.
The sharper question this measurement hands off is therefore **what structural width the
*realizable* conic-involution residual graphs `G∪` have**, which routes to the `k = 2, 3`
classification ([conic-involution residual graphs](2026-07-12-conic-involution-residual-graphs.md)),
not to a raw-state automaton. The q=17 row fixes the growth rate of the raw quotient.

Caveat on the raw numbers: residual caps are small (≤ q−1 points, depth ≤ 10 at q=11, ≤ 12 at
q=13; bisimulation converges in 6–7 rounds), so the class counts are structurally modest in
absolute terms; the trend, not the magnitude, is the signal.

## Reverse-engineered class invariants (q=11)

The naive 5-feature vector `(grundy, size, live_conic, sel_conic, intruders)` does **not**
determine the bisimulation class: of 247 feature tuples, 115 are ambiguous (map to >1 class).
So the 29 classes are a coarser, cleaner object than these local counts — finding their
invariants is follow-up work (only meaningful if the trend says the quotient is bounded).

## Reproduction

```bash
rustc -O -C target-cpu=native scripts/c83_bisim.rs -o target/c83_bisim
target/c83_bisim 11            # cross-checks the Python reference: 15697452 states, 29 classes
python3 scripts/c83_bisimulation.py 11 --invariants
choom -n 1000 -- target/c83_bisim 13
```
