# Sum-free game nimbers: the warm-up reduction, grounded in the proven mirror lemmas

**Date:** 2026-07-05 (session `2026-07-05--7`, `mi`, owns both compute + proof lanes; Codex out of tokens).
Companion to [`2026-07-05-sumfree-nimber-engine.md`](2026-07-05-sumfree-nimber-engine.md) (the engine + data) and
[`2026-07-04-sumfree-game-theorem.md`](2026-07-04-sumfree-game-theorem.md) (the proven mod-6 outcome theorem,
**Lemmas 1–4**). This note pins down **exactly what is proven and what is the open crux** for the nimber
conjectures, and re-derives Codex's two-move reduction directly from the proven negation-mirror lemmas (Facts
B/C/D below), so the reduction is no longer a heuristic — only one clean lemma remains open.

## The two conjectures (both very likely true; neither proven)

- **Warm-up (r₃=1):** `𝒢(Z₃×Z_p) = ∗1` for every prime `p ≥ 7`, and `= ∗2` at `p=5`.
  (`Z₃×Z_p ≅ Z_{3p}`; the *outcome* N is already the proven mod-6 theorem, since `3p ≡ 3 (mod 6)`. The
  conjecture is the refinement to the exact nimber.)
- **Main (r₃=2):** `𝒢(Z₃²×Z_p) = ∗0` (P) for every prime `p ≥ 7`, and `= ∗2` (N) at `p=5`.

Both are **spectral-gap statements** with the same shape (a "missing ∗1"); the warm-up is the honed test bed.

## Notation

`n = 3p`, `p` prime, `p ∉ {3}`. `Z_n` sum-free game, `σ(z) = −z`, `t = p = n/3` the order-3 element (`3t = 0`,
`−t = 2t = 2p`). `n` is **odd** ⇒ there is no order-2 element (no `O₂`); the only mirror obstruction is the
order-3 pair `{p, 2p}` (`O₃`). A position `A` is *symmetric* if `A = −A`. "Order-3 alive" = both `p, 2p` legal;
"order-3 dead" = both illegal. (For symmetric `A`: `p` legal ⟺ `2p` legal, because `S,D` commute with `σ` and
`T` never blocks `p` — `p ∈ T(A)` would need `2p ∈ A`, impossible in a symmetric sum-free set since `p+p=2p`.)

## Three facts that ARE proven (corollaries of Lemmas 1 & 4)

These upgrade the *outcome* lemmas to *nimber* statements about symmetric positions.

- **Fact B (symmetric + order-3 dead ⇒ ∗0).** If `A = −A` is sum-free and order-3 is dead, then `𝒢(A) = 0`.
  *Proof.* Illegality is monotone (as `A` grows, `S,D,T` only grow), so order-3 stays dead forever. Every legal
  move `z` is then non-order-3 and `≠ n/2` (none exists), so by **Lemma 1** the responder answers `−z` and keeps
  `A` symmetric. The responder never gets stuck ⇒ the mover makes the last-but-one move and loses ⇒ `𝒢(A)=0`. ∎

- **Fact C (symmetric + order-3 alive ⇒ a ∗0 child).** If `A = −A` is sum-free and order-3 is alive, then
  playing `p` reaches `A∪{p}`, and by **Lemma 4** with `E={t}` (`C = A∪{p}`, `2t = 2p ∉ C`) the responder can
  negation-mirror `A∪{p}` ⇒ `𝒢(A∪{p}) = 0`. So `A` has an order-3 child of value `∗0`. ∎

- **Fact D (the symmetric mex reduction).** For symmetric `A` with order-3 alive, `σ` is a game automorphism
  fixing `A`, so non-order-3 children come in **equal-value pairs** `𝒢(A∪{z}) = 𝒢(A∪{−z})`, and both order-3
  children have value `∗0` (Fact C, and `𝒢(A∪{p})=𝒢(A∪{2p})=0` by `σ`). Hence the option-value **set** is
  `{0} ∪ {values of non-order-3 children}`, so
  > `𝒢(A) = ∗1  ⟺  no non-order-3 child of A has value ∗1.`
  (`0` is always present by Fact C; `𝒢(A)=1` iff additionally `1` is absent, and order-3 children contribute
  only `0`.) ∎

## The reduction (now rigorous down to one lemma)

Apply Fact D to the **root** `∅` (symmetric; order-3 alive since `p` is legal from `∅`). The non-order-3
singletons fall into exactly two `Aut(Z_n)=Z_n^*` orbits — **order-p** (rep `{3}`) and **generator** (rep `{1}`)
— so:

> **`𝒢(Z_{3p}) = ∗1  ⟺  𝒢({3}) ≠ ∗1  and  𝒢({1}) ≠ ∗1.`**

Each side is delivered by one *child*: `{3} → {3,p} = {p,3}` and `{1} → {1,p} = {p,1}` are legal, and if either
target is `∗1` it puts a `∗1` in that singleton's option set, forcing its mex `≠ 1`. Therefore

> **Two-move lemma ⟹ warm-up.** If `𝒢({p,1}) = 𝒢({p,3}) = ∗1` for all `p ≥ 7`, then `𝒢(Z_{3p}) = ∗1`
> for all `p ≥ 7`.

This is Codex's reduction, but every step above is a corollary of the **proven** Lemmas 1 & 4 (not a heuristic):
the root has a genuine `∗0` child (`{p}`, Fact C), and the whole question is whether `∗1` is *absent* from the
root option set, which Fact D turns into "the two non-order-3 singletons aren't `∗1`," which the two-move lemma
secures.

## The open crux — the two-move lemma = a "missing ∗1"

`𝒢({p,3}) = ∗1` unfolds (mex) into: `{p,3}` has a child of value `∗0` **and no child of value `∗1`**. The second
half is the classic-hard part — a **nimber non-value across an infinite family**, and the values are not periodic.
Status:

- **Verified `∗1` for `p = 7,11,13,17,19,23,29`** (fingerprint engine; Codex to 19, engine to 29). Child spectra
  uniformly show "`0` present, `1` absent" (Codex's histograms).
- **The lemma genuinely breaks at `p=5`** — verified this session: `𝒢({5,3}) = 𝒢({5,1}) = ∗3` (not `∗1`), and the
  order-5 singleton `𝒢({3}) = ∗1`, giving root `mex{0,1,4} = ∗2 = 𝒢(Z₁₅)`. So the lemma is *exactly* a `p ≥ 7`
  statement, not a formality: the mechanism that makes it `∗1` for `p≥7` must fail precisely at `p=5`.
- **The `∗0`-child witness is "AP-child with a SPORADIC finite exception set" (revised this session).** The
  `{p,3}` branch's AP-child `{p,3,6−p}` is `∗0` for p=11,13,17,19,23, then **`∗4` at `p=29`, then `∗0` again at
  `p=31`** (`{31,3,68}` = 122M nodes) — so `p=29` is a *sporadic* exception, **not** a permanent break (the base
  `p=7` is the other known exception, `∗2`). The `{p,1}` branch's AP-child `(p+1)/2` is even cleaner: `∗0` for
  p=7…19 (Codex), 23, 29, **31** (this session; p=31 = 106M nodes), no exception found yet. So the "`∗0` present"
  half is a *witness-with-finite-exceptions* (matching Codex's finite-exception-book idea), not a uniform formula
  — at the exceptional `p` a different `∗0`-child must exist (it does: `𝒢({p,3})=∗1` still holds there). The
  branches are asymmetric in their exception sets. The genuinely hard half remains "`∗1` absent," no line-of-sight
  proof. (p=37 for both branches is past the compute wall — `Z111`, timed out at 5400s.)

## Why `p=5` is sporadic (the precise statement)

The entire `p=5`-vs-`p≥7` split is one fact: **the order-p singleton `{3}` is `∗1` iff `p=5`.**
- `p=5`: `{3}` children `= {0:4, 3:7}` ⇒ `mex = ∗1`. This `∗1` lands in the root option set ⇒ root `mex` skips
  from 1 to `∗2`.
- `p=7`: `{3}` children include `∗1` ⇒ `𝒢({3}) = ∗2 ≠ 1`. `p=11`: `{3}` has **no** `∗0`-child ⇒ `𝒢({3}) = ∗0 ≠ 1`.
  The singleton value is non-constant (`∗1,∗2,∗0,…` for `p=5,7,11`) but `≠ 1` for every checked `p ≥ 7` — for
  *different* reasons per `p`, which is exactly why there is no easy uniform proof.

This mirrors the r₃=2 story: there `𝒢(Z₃²×Z_p) = mex` of the three first-move orbit nimbers (socle/coprime/mixed),
and `p=5` is sporadic because the **socle-child drops to `∗0`** (engine note). Same shape, one rank up.

## What would close it (open leads, in order of promise)

1. **A `∗1`-avoidance invariant on the armed components.** Fact D says `𝒢=∗1` fails only if some non-order-3
   child is `∗1`. A structural reason (component-decomposition level) why the specific children of `{p,1}`/`{p,3}`
   never carry `∗1`, uniform in `p`, is the missing piece. Not more data points — a monovariant.
2. **A "spare-token" pairing for `Z_{3p}` (attempted; the gap is instructive).** To prove `𝒢=∗1` directly, try
   to show the sum `Game + ∗1` is a 2nd-player win (Rita) by pairing the `∗1` token with the *single* order-3
   move (only one of `p,2p` is ever playable, since `p+p=2p`) and negation-mirroring the rest — Lemma 4 keeps the
   mirror legal with the order-3 element present, and Lemma 1 keeps it legal before. Rita's rules: mirror `−z` to
   non-order-3 `z`; take the token when the opponent plays order-3; play order-3 when the opponent takes the
   token. **This is airtight except when the order-3 resource is *destroyed* while the token is still unspent.**
   Order-3 dies the instant the (symmetric) board contains `a,b` with `a+b=p` (equivalently `a−b=p`; `p,2p` die
   together by `σ`), and *either* player's move can trigger it. Once it dies with the token present, the position
   is symmetric + order-3-dead + token `= ∗0 + ∗1 = ∗1` (Fact B) **on the opponent's turn** — the opponent cashes
   it (take token → symmetric order-3-dead `= ∗0`, Rita to move, Rita loses by Fact B). So the failure is not a
   fixable bookkeeping detail: **order-3 is a destructible resource, unlike a clean Nim-heap**, and Rita cannot
   force it to survive. This is *exactly* the `p=5` phenomenon (order-3 gets blocked early) — but it does not by
   itself separate `p=5` from `p≥7`, since order-3 can die in both. The separation must be finer (which is why
   the singleton value `𝒢({3})` is non-constant and non-periodic). Documenting this closes the "just mirror it"
   route and says precisely what a proof must additionally control.
3. **Empirical frontier.** Push the two-move lemma and the orbit-child criterion to larger `p`, and map extended
   families (`Z₃³×Z_p`, `Z₉×Z₃×Z_p`, `Z₃²×Z_{p²}`, `Z₃²×Z_{pq}`) for a cleaner or divergent law (running sweep).

**Confidence (unchanged from the handoff):** conjectures true ~90%+; a rigorous warm-up proof ~45–55%; the r₃=2
lift ~25–35%. The reduction above is solid; the residual "missing ∗1" is the genuine open problem.
