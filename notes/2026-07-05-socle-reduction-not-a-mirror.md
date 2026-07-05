# Socle reduction — the mirror method does NOT extend past elementary 3-groups (redirect)

**Date:** 2026-07-05. Result of taking a swing at the **socle reduction** (`𝒢(G)=𝒢(G[6])`), the sole
remaining open piece of the abelian sum-free classification, by the method that cracked both socle
endpoints (`F₃ⁿ=N`, `Z₂×F₃ᵇ=P`): reverse-engineer the winning strategy from the sound solver. **Verdict:
the reduction is not a mirror/pairing phenomenon** — a different (structural/inductive) technique is
needed. Scripts: `2026-07-05-socle-z9z3-strategy.py`, `-z9z3-adaptive.py`, `-z2z9z3-sigma.py`.

## Setup

The classification's open slice is `s₂≤1 ∧ r₃≥2` (everything else is decided by the proven `r₃≤1` /
`s₂≥2` theorems, so the reduction is automatic there). For those groups the reduction says
`outcome(G)=outcome(socle(G))`, and both socle families are now theorems (`F₃ⁿ=N`, `Z₂×F₃ᵇ=P`). What
remains: **the non-socle parts (coprime, higher 2- or 3-power) are outcome-neutral.** Sound-solver
confirmations across all three collapse types (genuinely-open `r₃≥2` groups): `Z9×Z3=N` (=`Z3²`),
`Z5×Z3²=N` (=`Z3²`), `Z4×Z3²=P` (=`Z2×Z3²`).

The two proven socle theorems both rely on **char-3 purity** of the 3-part (the `σ(y)=−o−y` reflection
and the `Z₂×F₃ᵇ` label-flip both need `3y=0`). So the natural question: does the mirror extend to
**non-elementary** 3-groups (the reduction's real content)?

## Finding — no, and cleanly so

**`Z9×Z3 = N` is not a pairing/mirror position** (`z9z3-strategy.py`, `-adaptive.py`):

- **Winning first moves are *exactly* the 8 socle order-3 elements** `G[3]\{0}` — never an order-9
  element. So the opener must play in the socle.
- **On socle opponent moves, the winning reply is the `F₃²` reflection `σ(y)=−o−y`** (always among the
  winning replies; forced for `y∈{(3,1),(6,1)}`). So the socle sub-play *is* the elementary `F₃²=N`
  strategy.
- **On order-9 opponent moves there is no consistent mirror.** `σ(y)=−o−y` fails globally (36 illegal
  replies — the char-3 `2y=σy⟹3y=0` step dies for order-9 `y`). Negation `−y` fails. **Every** adaptive
  combination tested fails too: `−o−y else −y`, `−y else −o−y`, `socle:σ / order-9:−y` (the known-bad
  combined strategy), and both fallback orders. The only move-then-reflection with the played center
  `o` as fixed point is `σ(y)=−o−y` (since `2o=−o` in the socle), and it fails. So the first-player
  win is **genuinely adaptive**, not a matched involution.

**The `s₂=1` sibling resists identically** (`z2z9z3-sigma.py`): ChatGPT's `σ`-mirror on `Z₂×(Z9×Z3)`
(`σ(ε,v)=(1−ε,a−v)`) **fails for every** `a∈V\{0}` — socle *and* order-9. So neither open family admits
the mirror once the 3-part is non-elementary.

## Interpretation / redirect

- **The mirror method is intrinsically tied to elementary 3-groups.** It solved the two socle
  *endpoints* (char-3-pure). It does **not** solve the socle *reduction* (elementary ← general), which
  is a separate problem. Stop trying mirror variants on non-elementary 3-groups.
- The reduction likely needs a **structural / inductive / game-morphism** argument, e.g. relate the
  game on `G` to the game on a quotient/subgroup, or an outcome-preserving strategy lift that
  coordinates the socle play with the non-socle blockers (Codex pinned the blocker for the coprime
  case: `a+y=ρ(y)`, `a=(ρ−1)y`). Splitting into R1 (2-power) / R2 (3-power) / R3 (coprime) collapses
  may help — each may need its own mechanism.
- **Open question worth posing:** is `Z9×Z3=N` provable at all by a *succinct* strategy, or is its
  first-player win "essentially search"? The socle games (elementary) have one-line strategies; the
  reduction cases may not — which would itself be a structural statement about the game.
