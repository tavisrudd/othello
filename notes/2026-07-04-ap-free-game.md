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

> **The game is a second-player win (P) for every `n` through 47 EXCEPT the sporadic set
> `{1, 7, 19, 47}`** (all odd), which are first-player wins. Computed `n = 1..47` (outcome-only for
> the larger `n`); every even `n ≤ 46` is P, and the only N-positions are `1, 7, 19, 47`.

The exception set `{1,7,19,47,…}` has **no clean formula** — not the centered hexagonal numbers
(`37` is P, not N), only a loose unverifiable 4-term OEIS overlap. Sporadic, like the finite
exceptions of the Paley game (a).

## Mechanism — clean on the even side, complex on the odd

- **Even `n` ⇒ P (translation mirror) — PROVEN.**

  > **Theorem.** For even `n`, the 3-AP-free game on `Z_n` is a second-player win.
  > *Proof.* Let `m = n/2`. `τ(x) = x + m` is a fixed-point-free involution (`2m ≡ 0`, `m ≠ 0`) and
  > an AP-automorphism (translations preserve APs). P2 keeps the board `A` `τ`-symmetric (`A = A+m`)
  > and AP-free, replying `τ(x)` to each legal P1 move `x`; then `x' := x+m ∉ A`, `≠ x`. `A ∪ {x, x'}`
  > is AP-free — any new 3-AP involves `x'`:
  > - **two `A`-points + `x'`:** `{x', s, t}`, `s,t∈A`; applying `τ` gives a 3-AP `{x, s+m, t+m} ⊆
  >   A∪{x}` (`τ`-symmetry), contradicting `A∪{x}` AP-free.
  > - **`x, x', s∈A`:** if `x` is the middle, `s = 2x−x' = x−m = x' ∉ A`; if `x'` middle, `s = 2x'−x
  >   = x ∉ A` (`2m≡0`); if `s` middle, `2(s−x) = m`. For `n ≡ 2 (mod 4)`, `m` is odd and `2(s−x)=m`
  >   has **no** solution. For `4 ∣ n`, `s ∈ {x+n/4, x+3n/4}`; but `x+n/4 ∈ A ⟺ x+3n/4 ∈ A`
  >   (`τ`-symmetry), and then `{x+n/4, x, x+3n/4}` is a 3-AP with middle `x` and **both endpoints in
  >   `A`**, so `x` would be illegal — contradiction. So no such `s`.
  >
  > Hence P2 always has a legal reply, makes the last move, and wins. ∎

  Machine-checked: the `τ_{n/2}` mirror beats every P1 line of play for all even `n ≤ 24` (incl. every
  `4∣n`) (`2026-07-04-ap-strategy.py`), consistent with all even `n ≤ 46` being P.
- **Odd `n` ⇒ mostly P, but no single mechanism.** The cap-game move-then-mirror (open, reply,
  reflect through the midpoint center `c=(a+b)/2`, which self-blocks since `{a,c,b}` is a 3-AP)
  refutes the opening **only for `n = 3,5,9,15`**. For `n = 11,13,17,21,23` the game is still P but
  the simple reflection fails (0 usable centers) — P2 wins by a subtler strategy. For `n = 7,19`
  (and 47) the reflection fails **because the game is genuinely N**. The reason the reflection is not
  uniform: over `Z_n` the mirror pair `{y, σ_c(y)}` lies on a line with **extra AP-completions**
  (`3y−2c`, `4c−3y`) beyond the self-blocking center `c`; in `F₃ᵈ` (char 3) those collapse, giving a
  clean mirror, but `Z_n` keeps them, so the reflection can be broken and sporadic N-positions appear.

## Why this matters — it isolates what makes the cap theorem clean

The cap game is **uniformly** P on `AG(n,q)` because the reflection center `c=(a+b)/2` satisfies the
self-blocking identity `3c=0` **for every `c`** in characteristic `p` (the whole line collapses to
the 3 relevant points, killing the extra AP-completions). Over `Z_n`, `3c=0` holds only at
`c∈{0,n/3,2n/3}`, so the clean mirror is unavailable at a general opening and the game degrades to
"mostly P with sporadic exceptions." So the cap theorem's uniform always-P is a genuine feature of
the **characteristic-`p` vector-space structure**, not of the AP/cap relation itself — the cyclic
game is the control that proves it. (Compare the [zero-sum triple game](2026-07-04-sumfree-variants.md)
on `Z_n`, a *different* relation `a+b+c=0`, which is irregular with no law at all.)

## Status / open

- **New OEIS-absent sequence** (nimbers above); the exception set `{1,7,19,47,…}` is a candidate
  sub-sequence with no known formula.
- **Even `n` ⇒ P — PROVEN** (τ_{n/2} translation mirror, above). Clean sub-theorem.
- **Odd `n`** — no clean law; `{7,19,47}` are N and even the odd P-values lack a uniform certificate
  (the midpoint reflection works only for `n=3,5,9,15`). Extending the exception set (Z_n brute is
  heavy past n≈50) and finding a formula for `{1,7,19,47,…}` is open.
