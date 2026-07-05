# The 3-term-AP-free achievement game on Z_n — the cyclic cap game

**Date:** 2026-07-04 (session --3). The [cap game theorem](2026-07-04-capset-game-theorem.md) is
"always P" on `AG(n,q)`. Its **cyclic analog** is the 3-term-AP-free game on `Z_n` — and this note
shows the cyclic version is *mostly* P but with **sporadic first-player wins**, pinning down exactly
why the vector-space (characteristic-`p`) structure is what makes the cap game clean.

## The game

Build a subset `A ⊆ Z_n` with **no 3-term arithmetic progression** (no distinct `a,b,c` with
`a+c=2b`, i.e. `b` the midpoint). Add one element per move keeping `A` AP-free; last to move wins.
This is the right cyclic analog of the cap game: in `F₃ᵈ`, "cap" = "no 3 collinear" = "no 3-AP" =
"no `a+b+c=0`" all coincide, but over `Z_n` the AP relation `a+c=2b` is the geometric one (collinear
= AP) and is **translation- and negation-invariant** (unlike `a+b+c=0`, which is only 3-torsion-
translation-invariant). Solver `2026-07-04-ap-free-zn.py` (`legal_x` self-tested vs a direct AP-free
rebuild).

## Result

Grundy(∅), `n = 1..24` (OEIS-absent):
```text
n: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24
G: 1 0 0 0 0 0 1 0 0  0  0  0  0  0  0  0  0  0  1  0  0  0  0  0
```

> **The game is a second-player win (P) for every `n` through 55 EXCEPT the sporadic set
> `{1, 7, 19, 47, 49}`** (all odd), which are first-player wins. Computed `n = 1..55` (outcome-only
> for the larger `n`, even `n` skipped as proven P below); the only N-positions are `1, 7, 19, 47, 49`.

The exception set `{1,7,19,47,49,…}` is **genuinely irregular, no clean formula** — not centered
hexagonal (`37` is P), and `47, 49` are **adjacent** odd exceptions (`49 = 7²`, `7` also an
exception), which rules out any smooth/arithmetic pattern and the loose `A143128` overlap (that had
`47 → 77`, not `49`). Sporadic, like the finite exceptions of the Paley game (a).

## Mechanism — clean on the even side, complex on the odd

- **Even order ⇒ P (translation mirror) — PROVEN, and general (any even-order abelian group).**

  > **Theorem.** Let `G` be a finite abelian group of **even order**. The 3-AP-free achievement game
  > on `G` (build `A ⊆ G` with no distinct `a,b,c`, `a+c=2b`; last to move wins) is a **second-player
  > win**. (`Z_n` even is the case `t = n/2`.)
  >
  > *Proof.* By Cauchy `G` has an element `t` of order 2. `τ(x)=x+t` is a fixed-point-free involution
  > (`2t=0`, `t≠0`) and an AP-automorphism (`(a+t)+(c+t)=a+c+2t=a+c=2(b+t)`). P2 keeps the board `A`
  > `τ`-symmetric (`A=A+t`) and AP-free, replying `τ(x)` to each legal P1 move `x`; then `x':=x+t∉A`,
  > `≠x`. `A∪{x,x'}` is AP-free — any new 3-AP involves `x'`:
  > - **two `A`-points + `x'`:** `{x',s,r}`, `s,r∈A`; `τ`-image `{x,s+t,r+t}⊆A∪{x}` is a 3-AP,
  >   contradicting `A∪{x}` AP-free.
  > - **`x,x',s∈A`:** `x` middle ⇒ `s=2x−x'=x−t=x'∉A`; `x'` middle ⇒ `s=2x'−x=x∉A` (`2t=0`);
  >   `s` middle ⇒ `2(s−x)=t`. If `t∉2G` this has **no** solution. If `t=2u`, then `s=x+u`; by
  >   `τ`-symmetry `x+u∈A ⇒ x+u+t=x+3u∈A`, and `x+3u=x−u` (since `4u=2t=0`), so **both** `x±u∈A`,
  >   making `{x−u,x,x+u}` a 3-AP with middle `x` ⇒ `x` illegal. Contradiction.
  >
  > Hence P2 always has a legal reply, makes the last move, and wins. ∎ *(The crux `4u=2t=0` uses
  > `t` order 2 — this is what closes the `4∣n` case for `Z_n`.)*

  Machine-verified: outcome **P and the `τ_t` mirror beats every P1 line** for **all even-order
  abelian groups tested** — `Z_{4,6,8,10,12}`, `Z_2×Z_2`, `Z_2×Z_4`, `Z_2×Z_3`, `Z_2×Z_2×Z_2`,
  `Z_2×Z_6`, `Z_4×Z_4` (`2026-07-04-ap-abelian.py`, `2026-07-04-ap-strategy.py`). Odd-order abelian
  is mostly P (`Z_3×Z_3`=cap, `Z_9`, `Z_5`, `Z_3×Z_5` all P; `Z_7`=N) — the "hard side," as for `Z_n`.
- **Odd `n` ⇒ mostly P, but no single mechanism.** The cap-game move-then-mirror (open, reply,
  reflect through the midpoint center `c=(a+b)/2`, which self-blocks since `{a,c,b}` is a 3-AP)
  refutes the opening **only for `n = 3,5,9,15`**. For `n = 11,13,17,21,23` the game is still P but
  the simple reflection fails (0 usable centers) — P2 wins by a subtler strategy. For `n = 7,19`
  (and 47) the reflection fails **because the game is genuinely N**. The reason the reflection is not
  uniform: over `Z_n` the mirror pair `{y, σ_c(y)}` lies on a line with **extra AP-completions**
  (`3y−2c`, `4c−3y`) beyond the self-blocking center `c`; in `F₃ᵈ` (char 3) those collapse, giving a
  clean mirror, but `Z_n` keeps them, so the reflection can be broken and sporadic N-positions appear.

## Why this matters — it isolates what makes the cap theorem clean

**The two clean P-theorems together.** The 3-AP-free achievement game on an abelian group `G` is a
second-player win in two provable regimes, by two mirrors: (i) `|G|` **even** → translation mirror
`τ_t` (`t` order 2), *this note*; (ii) `G = F_qⁿ` (elementary abelian, any prime power `q`) →
reflection/translation mirror = **the [cap theorem](2026-07-04-capset-game-theorem.md)** (since cap =
3-AP-free on `F_qⁿ`). The uncovered middle — odd-order `G` that is *not* elementary abelian (e.g.
`Z_n` odd, `Z_9`) — is "mostly P with sporadic exceptions" (`{7,19,47,49}` for `Z_n`).

The cap game is **uniformly** P on `AG(n,q)` because the reflection center `c=(a+b)/2` satisfies the
self-blocking identity `3c=0` **for every `c`** in characteristic `p` (the whole line collapses to
the 3 relevant points, killing the extra AP-completions). Over `Z_n`, `3c=0` holds only at
`c∈{0,n/3,2n/3}`, so the clean mirror is unavailable at a general opening and the game degrades to
"mostly P with sporadic exceptions." So the cap theorem's uniform always-P is a genuine feature of
the **characteristic-`p` vector-space structure**, not of the AP/cap relation itself — the cyclic
game is the control that proves it. (Compare the [zero-sum triple game](2026-07-04-sumfree-variants.md)
on `Z_n`, a *different* relation `a+b+c=0`, which is irregular with no law at all.)

## Sibling: the INTERVAL 3-AP-free game `{1..n}` (no wrap)

The achievement-game version of the classical 3-AP-free sets (Roth/Behrend `r₃(n)`), on `{1,…,n}`
with integer (non-cyclic) APs. No group symmetry ⇒ no mirror. Grundy(∅), n=1..28
(`2026-07-04-ap-interval.py`, OEIS-absent):

```text
n: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 ... 28
G: 1 0 0 1 1 0 0 0 0  3  3  0  0  0  0  0  2  0 ...  3
```

Also **mostly P**, with irregular N-exceptions `{1,4,5,10,11,17,28}` (more frequent than the cyclic
version, and no pattern — as expected without symmetry). So *both* the cyclic and interval 3-AP-free
games trend second-player-win, reinforcing that "cap-type" (3-AP-free) achievement games are
P-leaning; the cyclic version is cleaner (even n provably P) thanks to its translation symmetry.

## Status / open

- **New OEIS-absent sequence** (nimbers above); the exception set `{1,7,19,47,…}` is a candidate
  sub-sequence with no known formula.
- **Even-order abelian `G` ⇒ P — PROVEN** (τ_t translation mirror, above; `Z_n` even is a special
  case). Clean theorem, machine-verified across even-order groups.
- **Odd `n`** — no clean law; `{7,19,47}` are N and even the odd P-values lack a uniform certificate
  (the midpoint reflection works only for `n=3,5,9,15`). Extending the exception set (Z_n brute is
  heavy past n≈50) and finding a formula for `{1,7,19,47,…}` is open.
