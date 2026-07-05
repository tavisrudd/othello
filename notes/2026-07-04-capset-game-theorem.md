# The cap achievement game on AG(n,q) — the "always P" theorem (all odd q)

**Date:** 2026-07-04. The conjecture raised in
[sumfree-capset-game](2026-07-04-sumfree-capset-game.md) (Result 2, verified d=1..4 by an AGL(4,3)
solver) is here a **theorem** — and it generalizes well beyond the cap-set case `q=3`: the game is a
second-player win on `AG(n, q)` for **every odd prime power `q`**. In particular d=5 and all larger
`F₃` dimensions are settled with no computation. Uses the move-then-mirror pattern (P0′) of the
[Node-Kayles pairing lemmas](2026-07-04-nodekayles-pairing-lemmas.md), instantiated on the affine
line hypergraph.

## The game

Fix a dimension `n ≥ 1` and an odd prime power `q`. Two players alternately build a **cap**
`A ⊆ AG(n, q) = F_qⁿ` starting from `A = ∅`: a move adds a point `x ∉ A` keeping `A` a cap, where a
**cap** is a set with **no three distinct collinear points**. (Three distinct points `a, b, c` are
collinear iff they lie on a common affine line; over `F_q` a line has `q` points. For `q = 3` a line
is `{a, b, −(a+b)}`, so "no 3 collinear" = "no full line" — the classical **cap set** in `F₃ⁿ`.)
Normal play: the player who cannot move (the cap is inclusion-maximal) loses. This is impartial
hypergraph Node-Kayles on the collinear-triple hypergraph of `AG(n, q)`. Let `G(n, q)` be the
Sprague–Grundy value of `∅`; second player wins iff `G(n, q) = 0`.

## The theorem

> **Theorem.** For every `n ≥ 1` and every **odd** prime power `q`, the cap achievement game on
> `AG(n, q)` is a **second-player win**: `G(n, q) = 0`.
>
> **Cap-set corollary (`q = 3`).** `G(F₃ᵈ) = 0` for all `d` — the "always P" conjecture, settling
> d = 5 and beyond with no computation.

## The tool: affine point reflection

Over `F_q` with `q` odd, the **point reflection** `σ_c(x) = 2c − x` is an affine automorphism (it
preserves lines, hence caps), an **involution** (`σ_c² = id`), with the **single fixed point `c`**
(as `2` is invertible). For any line `ℓ` through `c`, `σ_c` maps `ℓ` onto itself, fixing only `c`
(it reflects `ℓ` about `c`). The **midpoint** `c = (a + b)/2` of two distinct points exists (`2`
invertible) and is collinear with `a, b`. (For `q = 3`, `(a+b)/2 = −(a+b)`, the third point of the
line `{a,b}`.)

## Proof

We show every opening move leaves an **N-position**; then `∅`, with no P-position among its options,
is a P-position, so `G(n, q) = 0`.

P1 opens with a point `a`. P2 replies with **any** point `b ≠ a`. Let `c = (a + b)/2`, the midpoint.

- **`c` is dead for the rest of the game.** `{a, b, c}` are three distinct collinear points, and
  `a, b` stay on the board, so adding `c` would create three collinear — `c` is forbidden henceforth.
- **`{a, b}` is `σ_c`-symmetric** (`σ_c(a) = 2c − a = b`, using `2c = a + b`) with `c ∉ {a, b}`.

P2 plays the **mirror strategy**: answer each P1 move `y` with `σ_c(y)`. Maintain the invariant

> *(∗) the board `A` is a `σ_c`-symmetric cap with `c ∉ A`.*

`(∗)` holds after `{a, b}`. Assume it holds and P1 plays a legal `y` (`A ∪ {y}` a cap, `y ∉ A`, and
`y ≠ c` since `c` is forbidden). Let `ℓ` be the line through `y` and `c` — equivalently through `y`
and `σ_c(y) = 2c − y` (both on the reflection axis through `c`).

**Parity lemma (the crux — this is where general `q` works, not just `q = 3`).** `A ∩ ℓ = ∅`.
*Proof.* `ℓ` is `σ_c`-invariant, so `A ∩ ℓ` is `σ_c`-invariant; `σ_c` has no fixed point in `A`
(`c ∉ A`), so `A ∩ ℓ` splits into 2-cycles ⇒ **`|A ∩ ℓ|` is even**. But `A ∪ {y}` is a cap and
`y ∈ ℓ`, so at most two points of `A ∪ {y}` lie on `ℓ` ⇒ `|A ∩ ℓ| ≤ 1`. Even and `≤ 1` ⇒
`|A ∩ ℓ| = 0`. ∎ *(For `q = 3`, `ℓ = {y, c, σ_c(y)}` has only `c` as a possible `A`-point and
`c ∉ A`, so this is automatic — the general lemma reduces to the cap-set case.)*

Now `A ∪ {y, σ_c(y)}` is a cap. `σ_c(y) ∉ A` (as `σ_c(A) = A`, `y ∉ A`); `σ_c(y) ≠ y` and `≠ c`
(both from `y ≠ c`). Any forbidden collinear triple must involve `σ_c(y)`:

- `{σ_c(y), p, r}` with `p, r ∈ A` collinear maps under the automorphism `σ_c` to a collinear triple
  `{y, σ_c(p), σ_c(r)} ⊆ A ∪ {y}` (as `σ_c(A) = A`) — impossible, `A ∪ {y}` is a cap;
- `{σ_c(y), y, p}` with `p ∈ A` collinear forces `p` onto the line through `σ_c(y)` and `y`, i.e.
  `p ∈ A ∩ ℓ = ∅` — impossible;
- no triple uses only the two new points.

So `A ∪ {y, σ_c(y)}` is a cap and `(∗)` is restored (`c` is still absent, as `y, σ_c(y) ≠ c`). P2
always has a legal reply; the game is finite; P1 is first unable to move ⇒ **P2 makes the last move
and wins.** Every opening `{a}` is an N-position ⇒ `∅` is a P-position ⇒ `G(n, q) = 0`. ∎

## Why the odd-order obstruction is dodged

`|AG(n, q)| = qⁿ` is **odd** (q odd), so there is **no fixed-point-free involution** on the whole
board — a *whole-board* pairing (Lemma P0 of the pairing bundle) is impossible, which the working
note flagged as the barrier. None is needed: P1's opening is a **wasted tempo** that lets P2 place a
mirror pair whose reflection center `c` **self-blocks** (it is the midpoint of the opening pair,
collinear with it), reducing the rest to a fixed-point-free mirror `σ_c` on the **even** set
`AG(n, q) ∖ {c}` — the **move-then-mirror corollary P0′** in the hypergraph setting. Because
`AGL(n, q)` is **2-transitive**, every ordered opening pair `(a, b)` is equivalent, so one strategy
covers all openings — no residue case-split.

## Contrast with the Z_n sum-free game

The [Z_n sum-free game](2026-07-04-sumfree-game-theorem.md) uses the *same* reflection idea but its
outcome is a nontrivial **mod-6 law**, because its mirror has residue-dependent obstructions (the
fixed point `n/2`, the collision pair `{n/3, 2n/3}`) that need not lie on the opening move and must
be counted. Over `AG(n, q)` the affine 2-transitivity forces the single reflection fixed point onto
the opening line, where it self-blocks, so **no obstruction survives and the outcome is uniformly P**,
for every odd `q`. The cap game is "easier" precisely because affine symmetry is richer than cyclic
symmetry — the opposite of the intuition that higher-dimensional / larger-`q` games should be harder.

## Verification status

- **Proved above, uniform in `n` and odd `q`** — no machine step is load-bearing.
- **Corroboration.** Brute Grundy gives `G = 0` for `AG(2,3), AG(3,3), AG(1/2, 5), AG(1/2, 7)`
  (`2026-07-04-cap-agnq.py`); a direct simulation of the P2 mirror strategy confirms **P2 wins
  against every P1 line of play** for `AG(2,3), AG(2,5), AG(2,7), AG(3,3)` — the *strategy itself*,
  not just the outcome (`2026-07-04-ag-strategy.py`, `2026-07-04-capset-proof.py`). The prior AGL(4,3)
  quotient solver independently gave `G(F₃⁴) = 0`.

## Remarks

- **Settles the cap-set `d = 5` (and all `d`).** The heavy nauty-style `d = 5` canonicalization the
  working note queued is **unnecessary as a decision** — `G(F₃⁵) = 0` follows from the theorem.
- **Boundary: `q` even fails the tool.** In characteristic 2, `σ_c(x) = 2c − x = −x = x`, i.e. the
  point reflection collapses to the identity and the midpoint `(a+b)/2` does not exist — the proof
  genuinely needs `q` odd. Whether the cap game on `AG(n, 2ᵏ)` is P is **open** (a natural next probe;
  note `AG(n, 2)` caps are just "no 3 collinear" = affinely independent-ish sets, a different flavor).
- **Not the extremal cap problem.** This is the *game outcome*, orthogonal to *maximum cap size*
  (arcs/caps in finite geometry; Ellenberg–Gijswijt / FunSearch for `q = 3`). The theorem says nothing
  about cap sizes; the game's terminals are inclusion-*maximal* caps.
- **Projective analogue (open).** The same reflection tool suggests looking at the cap game on
  `PG(n, q)`; the point-reflection / midpoint structure differs projectively, so it is a genuine
  separate question.
