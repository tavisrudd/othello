# The sum-free achievement game on Z_n — the mod-6 outcome theorem

**Date:** 2026-07-04. Clean write-up of the result proved in
[sumfree-capset-game](2026-07-04-sumfree-capset-game.md). Companion data/scripts there and in
`sumfree-solver/`.

## The game

Fix `n ≥ 1`. Two players alternately build a subset `A ⊆ Z_n`, starting from `A = ∅`. A move adds
one element `x ∉ A` such that `A ∪ {x}` remains **sum-free** — i.e. contains no solution of
`a + b = c` with `a, b, c ∈ A ∪ {x}` (`a = b` allowed, so `2a = c` is forbidden). Normal play: the
player who cannot move (the current set is a *maximal* sum-free set) loses. Equivalently this is
hypergraph Node-Kayles on the Schur 3-uniform hypergraph of `Z_n`.

Because `0 + 0 = 0`, the element `0` is never playable; the game lives on `Z_n \ {0}`.

Let `G(n)` be the Sprague–Grundy value of the starting position `∅`. The **outcome** is a
second-player win iff `G(n) = 0`.

## The theorem

> **Theorem.** For `n ≥ 5`, the sum-free achievement game on `Z_n` is a **second-player win**
> (`G(n) = 0`) **iff `n ≡ 0, 1, 5 (mod 6)`**, and a first-player win iff `n ≡ 2, 3, 4 (mod 6)`.
>
> (Small values: `G(1..4) = 0,1,1,2`, so `n=1` is also a 2nd-player win and `n=2,3,4` are 1st-player
> wins; the `n≥5` statement is the clean periodic law.)

The Grundy values themselves are **not** periodic — only the outcome is (the first `50+` terms are in
[the OEIS draft](2026-07-04-sumfree-oeis-draft.md); the sequence is not in OEIS).

## The mechanism: the negation mirror and its two obstructions

The base strategy is the **negation mirror**: a *responder* answers each opponent move `x` with `−x`,
keeping the built set symmetric (`A = −A`). It is a winning strategy for the responder whenever it
never gets stuck. It can only fail at two kinds of element, and their existence is governed by
`n mod 6 = (n mod 2, n mod 3)`:

- **O₂ — the fixed point `n/2`** (exists iff `2 ∣ n`): `−(n/2) = n/2`, so it has no distinct mate.
- **O₃ — the collision pair `{n/3, 2n/3}`** (exists iff `3 ∣ n`): if `3x = 0` then `2x = −x`, so
  `x + x = −x`; the pair `{x, −x} = {n/3, 2n/3}` is itself not sum-free and cannot both be played.

**Lemma 1 (negation-mirror step).** Let `A = −A` be sum-free, `x ∉ A`, `A ∪ {x}` sum-free, with
`x ≠ n/2` and `3x ≠ 0`. Then `A ∪ {x, −x}` is sum-free.

*Proof.* `−x ∉ A` (as `A=−A, x∉A`), and `−x ≠ x` (`2x=0` would force `x∈{0,n/2}`). Any new
violation of `A∪{x,−x}` must involve `−x`. Every case reduces to a violation of the given sum-free
`A ∪ {x}`, using `A = −A`:
`(−x)+(−x)=−2x∈A ⟺ 2x∈A` (excluded, since `x+x=2x∉A∪{x}`); `x+(−x)=0∉` the set;
`(−x)+a=b` with `a,b∈A` gives `x+(−a)=−b`, i.e. `x + a' = b'` with `a',b'∈A` (a violation of
`A∪{x}`); `a+b=−x` gives `(−a)+(−b)=x` (again a violation of `A∪{x}`); and `−x=2x` needs `3x=0`
(excluded). ∎

So when **no** obstruction is live, the negation mirror wins for the responder.

**Lemma 2 (translation-mirror step).** Let `n` be even, `m = n/2`, and let `A` be **τ-invariant**
(`A = A + m`) and sum-free, `x ∉ A`, `A ∪ {x}` sum-free, with `x ≠ m`. Then `A ∪ {x, x+m}` is
sum-free.

*Proof.* Write `x' = x+m`; then `x' ∉ A`, `x' ∉ {0, x, m}`. Any new violation involves `x'`.
Using `A = A + m` (so `a ∈ A ⟺ a+m ∈ A`):
- `a+b=x'` with `a,b∈A`: then `a + (b+m) = x` with `b+m ∈ A` — a violation of `A∪{x}`. Excluded.
- `a+x'=b` with `a,b∈A`: then `a + x = b+m ∈ A` — a violation of `A∪{x}`. Excluded.
- `a+x'=x` (`a∈A`): `a = −m = m ∉ A` (τ-invariance ⇒ `m∈A ⟺ 0∈A`, false). Excluded.
- `x+x'=x'+... `: `x+x' = 2x+m ∈ A ⟺ 2x ∈ A` (excluded, `2x∉A`); `=x ⟺ x=m`; `=x' ⟺ x=0`. All out.
- `x'+x'=2x'=2x`: `∈A` excluded; `=x,x'` force `x∈{0,m}`. Out. ∎

The translation `τ(z)=z+m` is **fixed-point-free** (`z+m=z` impossible), so it pairs `Z_n\{0}` into
`{z, z+m}` with **only `m=n/2` left unpaired** (its partner is `0`). And:

**Lemma 3 (`n/2` self-blocks).** In any τ-invariant sum-free `A ≠ ∅`, `n/2` is not playable.
*Proof.* `A ≠ ∅` contains some `z` and its mate `z+m`; then `(n/2) + z = z+m ∈ A`, so adding `n/2`
completes `z + (n/2) = z+m`. ∎ Hence `n/2` is playable only from `∅`.

**Lemma 4 (negation mirror with fixed extras — kills O₃, absorbs O₂).** Suppose `3 ∣ n`, put
`t = n/3` (so `3t = 0`, `−t = 2t`). Let `E ⊆ {n/2, t}` (with `n/2 ∈ E ⇒ 2∣n`), and let
`C = E ∪ S` with `S = −S`, `C` sum-free, and (if `t ∈ E`) `2t ∉ C`. Then for any move `z` with
`C ∪ {z}` sum-free and `z ∉ {0, n/2, t, 2t}`, the reply `w = −z` is legal and `C ∪ {z, w}` is
sum-free.

*Proof.* By Lemma 1's argument, every new violation involving `w` reduces to a violation of
`C ∪ {z}` **unless** it uses the asymmetric extra `t` (whose mate `2t ∉ C`) or the self-paired
`n/2`. Both remaining families are impossible:
- *Uses `t`:* a violation `w = t + b` (`b ∈ C`) forces `z = −w = −t − b = 2t − b` (as `−t = 2t`).
  But then `z + t = 3t − b = −b`, and `−b ∈ C` for `b ∈ S ∪ {n/2}` (`b=t ⇒ z=t∈C`, excluded;
  `b=2t ∉ C`). So `C ∪ {z}` already violates (`z + t = −b ∈ C`) — contradicting `z` legal.
- *Uses `n/2`:* a violation `w + n/2 = c` (`c ∈ C`) forces `z = n/2 − c`, whence
  `z + n/2 = 2·(n/2) − c = −c ∈ C` — again `C ∪ {z}` violates. Contradiction.
So no new violation survives; `w=−z` is a legal, sum-free reply. ∎ *(3t=0 is what neutralizes O₃;
2·(n/2)=0 and `n/2 = −n/2` is what absorbs O₂. Mechanism machine-checked: 0 breakers, n=6..36.)*

## Proof of the Theorem — obstruction counting

Cases by `n mod 6`, i.e. by which obstructions exist:

- **`n ≡ 1, 5` (gcd(n,6)=1): 0 obstructions ⇒ P.** No O₂ (`n` odd), no O₃ (`3∤n`). The **second
  player** negation-mirrors from `∅` (Lemma 1 applies to every move) ⇒ wins ⇒ `G(n)=0`.

- **`n ≡ 2, 4` (2∣n, 3∤n): exactly O₂ ⇒ N.** The **first player** opens `x = n/2` (playable:
  `{n/2}` sum-free; self-symmetric). Now O₂ is neutralized (`n/2` placed) and there is no O₃, so the
  first player negation-mirrors as responder (Lemma 1) ⇒ wins ⇒ `G(n)≠0`.

- **`n ≡ 3` (3∣n, 2∤n): exactly O₃ ⇒ N.** The **first player** opens `x = n/3`. This blocks `2n/3`
  (`n/3+n/3=2n/3`, so `2n/3` becomes unplayable), neutralizing O₃; there is no O₂ (`n` odd). The
  first player then negation-mirrors as responder — valid by **Lemma 4** with `E = {n/3}`
  (`C = {n/3} ∪ S`) — ⇒ wins ⇒ `G(n)≠0`.

- **`n ≡ 0` (2∣n and 3∣n): both O₂ and O₃ ⇒ P.** One opening move can remove at most one
  obstruction, so the first player cannot set up the negation mirror. The **second player** wins:
  - **opening `x ≠ n/2`:** reply `x + n/2` — the **translation mirror** (Lemma 2), which needs
    neither obstruction removed. By Lemma 3, `n/2` is now blocked for the rest of the game, and the
    second player τ-mirrors every later move (Lemma 2) ⇒ wins. Hence `{x}` is an N-position.
  - **opening `x = n/2`:** reply `n/3` (`{n/2,n/3}` is sum-free), reaching `{n/2, n/3}`, which is a
    **P-position**: both obstructions are now neutralized (`n/2` placed and self-symmetric, `n/3`
    blocks `2n/3`), so the second player negation-mirrors the augmented position — valid by
    **Lemma 4** with `E = {n/2, n/3}` (`C = {n/2, n/3} ∪ S`) — ⇒ wins. Hence `{n/2}` is N.

  Every opening leads to an N-position, so `∅` is a P-position ⇒ `G(n) = 0`. ∎

**The crux — why `n≡0` and `n≡2,4` differ.** In both, `n/2` exists. For `n≡2,4` the position
`{n/2}` is a **P**-position, so opening `n/2` wins for the first player. For `n≡0` the very same
`{n/2}` is an **N**-position, *because `n/3` exists* (`3∣n`) and lets the second player answer. The
whole law turns on the divisibility pair `(2∣n, 3∣n) = n mod 6`.

## Verification status

- **Lemmas 1–4 are proved above, uniform in `n`.** With Lemma 4 covering the two augmented-mirror
  cases (`n≡3` opening; `{n/2,n/3}` P-position for `n≡0`), the six-case proof is **complete** — no
  remaining machine-only step; the machine checks (0 mirror-breakers over all reachable positions
  n≤36; outcome law confirmed by the exact solver to **n=63**, zero exceptions) are corroboration,
  not load-bearing.
- The only non-symbolic inputs are the finite base cases `n < 5` (direct: `G=0,1,1,2` for n=1..4),
  which the periodic law does not claim.

## Remarks

- **Novelty:** the impartial sum-free / Schur achievement game appears unstudied (Sieben's
  hypergraph-games framework does not instantiate it; no prior "sum-free game" surfaced; OEIS returns
  no match for the sequence). Nearest neighbours: Cameron–Erdős maximal-sum-free-set counting
  (the game's terminal positions are maximal sum-free sets) and the arithmetic-Cayley Node-Kayles of
  [game (a)](2026-07-04-cayley-nodekayles-outcome-law.md) — of which `Paley_p = Cay⁺(Z_p, QR)` is
  the graph cousin.
- **Structure exposed en route:** the game is a *disjunctive game* — `G(position) = XOR over
  connected components of the residual armed-Schur-hypergraph` (verified 0 mismatches / ~70k
  positions). Not needed for the theorem, but it is the fast-solver lever and a structural handle.
- **The `F_3^d` cap-set cousin** (build a cap, last to move wins) is `G(d)=0` for `d=1,2,3,4`
  (d=4 via an AGL(4,3)-quotient solver, memo 7734). "Always P" is a 4-point conjecture; a proof must
  differ from the Z_n one (F₃ᵈ has no order-2 element, so no translation/negation fixed-point mirror
  in the same form). This is **adjacent to, not the same as**, the famous extremal cap-set problem
  (maximum cap size — Ellenberg–Gijswijt; DeepMind FunSearch's dim-8 lower bound): that asks how
  *large* a cap is, our game asks who *wins*. The neighbour is the *maximal*-cap spectrum, not the
  *maximum* cap. Novelty here is more fragile than the Z_n game (large literature) — check prior art
  before claiming it.
