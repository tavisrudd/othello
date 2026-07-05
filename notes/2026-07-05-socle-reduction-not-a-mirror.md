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

## Attack 4 (coprime peel) — same verdict: not a mirror, even for elementary `H`

Focused follow-up on the **coprime peel** `outcome(H×Z_p)=outcome(H)`, `p≥5` prime (target `Z3²×Z5=N`;
scripts `2026-07-05-socle-coprime-{sigma-obstruction,mirror-search,fibered}.py`).

**Structural sharpening (reduces the whole open problem).** The peel — and the entire socle reduction —
is only nontrivial for **`s₂=0, τ₃=1`** (odd `G` *with* 3-torsion):
- **`s₂≥2`:** already `P` for any 3-structure (Part-1 translation mirror `τ_v` with a spare order-2
  element is O₃-immune and group-general) — the reduction is automatic.
- **`s₂=1`:** the proven `τ_m` reduction gives `∅` P ⟺ `{m}` N for all 3-ranks; the coprime/2-power
  parts ride along the translation. Open content = `{m}` N for a *non-elementary* 3-part.
- **`s₂=0, τ₃=0`:** `P` by the negation mirror; coprime parts are negation-clean.
So the non-socle parts are outcome-neutral **except through 3-torsion coupling**, and the irreducible
open statement is essentially **"odd `G` with 3-torsion ⟹ N"** (⊇ `F₃ⁿ=N`) plus the `s₂=1`
non-elementary `{m}`-case.

**The `σ`-reflection obstruction, pinned.** For `σ_G(y)=−o−y` (`o=(o_H,0)` socle center), the
char-3 identities that make the `F₃ⁿ` proof clean (`−2i=i`, `3i=0`) **fail off-base** (`i≠0`): the case
`p+σy=y` forces the blocker `p=o+2y∈A` (whose σ-image is the doubling `2σy∈A`), and `y+p=o` — the
`F₃ⁿ` escape — becomes `y+p=(o_H,3i)≠o`. Concretely (`Z3×Z7`, `o=(1,0)`): `y=(1,4)`, `w=σy=(1,3)`,
`(0,1)+w=y` with `(0,1)=o+2y∈A`.

**Every mirror shape fails (adversarially verified):**
- global `σ_G` (fails, off-base blocker above);
- combined "σ_H on base, `−y` off-base" (Codex: 1284 failures);
- **all** structured single involutions `τ(h,i)=(σ_H(h) or −h,\; c−i)`, `c∈Z_p`, opening `τ`'s unique
  fixed point `(o_H,3c)` — *including the order-15 openings* (`c≠0`): every one FAILS on `Z3×Z5`,
  `Z3×Z7`, `Z3²×Z5`;
- **fibered** "pin the `H`-projection to the winning `σ_H`, choose the `Z_p`-coordinate freely/adaptively":
  FAILS on `Z3×Z5,Z3×Z7,Z3²×Z5,Z3²×Z7`.

So no strategy whose `H`-projection is the `F₃ⁿ` mirror can win the peel — the hero must deviate the
`H`-coordinate. **The coprime peel is genuinely adaptive**, matching `Z9×Z3`. **Attack 4 (mirror +
bounded local repair) is a dead end**; the socle reduction is not a pairing phenomenon in *any* case
(higher-3-power or coprime). Redirect effort to the structural/invariant routes (Attacks 2/3/5) or a
novel technique — and to the sharpened target **"odd `G` with 3-torsion ⟹ N."**
