# The cap-set achievement game on F₃ᵈ — the "always P" theorem

**Date:** 2026-07-04. Clean write-up of the result whose conjecture was raised in
[sumfree-capset-game](2026-07-04-sumfree-capset-game.md) (Result 2, verified d=1..4 by computer). The
theorem below **proves it for all d**, so it also settles d=5 and beyond without the heavy
canonicalization the computation needed. Uses the move-then-mirror pattern (P0′) of the
[Node-Kayles pairing lemmas](2026-07-04-nodekayles-pairing-lemmas.md), instantiated on a hypergraph.

## The game

Fix `d ≥ 1`. Two players alternately build a **cap** `A ⊆ F₃ᵈ` starting from `A = ∅`: a move adds a
point `x ∉ A` such that `A ∪ {x}` is still a cap. A **cap** is a set containing no three distinct
collinear points; three distinct points `a, b, c` are collinear **iff `a + b + c = 0`**, and any two
distinct points `a, b` lie on a unique line whose third point is `−(a + b)`. Normal play: the player
who cannot move (the current cap is inclusion-maximal) loses. This is impartial hypergraph
Node-Kayles on the affine-line 3-uniform hypergraph of `F₃ᵈ`. Let `G(d)` be the Sprague–Grundy value
of `∅`; the game is a second-player win iff `G(d) = 0`.

## The theorem

> **Theorem.** For every `d ≥ 1`, the cap-set achievement game on `F₃ᵈ` is a **second-player win**:
> `G(d) = 0`. (In particular d = 5 and all larger d, resolving the "always P" conjecture.)

## The tool: affine point reflection

For a center `c ∈ F₃ᵈ`, the **point reflection** `σ_c(x) = 2c − x` is an affine automorphism of
`F₃ᵈ` (it preserves lines, hence caps), an **involution** (`σ_c(σ_c(x)) = x`), with the **single
fixed point `c`**. For `x ≠ c` the triple `{c, x, σ_c(x)}` is a **line**:
`c + x + σ_c(x) = c + x + (2c − x) = 3c = 0`. (Negation `x ↦ −x = σ_0` is the special case `c = 0`.)

The crucial F₃ arithmetic: since `−2 ≡ 1 (mod 3)`, if `c = −(a + b)` then `2c = a + b`, so
`σ_c(a) = b` and `σ_c(b) = a` — reflection through the third point of a line **swaps the other two**.

## Proof

We show every opening move leaves an **N-position**; then `∅`, having no P-position among its
options, is a P-position, so `G(d) = 0`.

P1 opens with a point `a`. P2 replies with **any** point `b ≠ a` (one exists, `|F₃ᵈ| = 3ᵈ ≥ 3`). Let
`c = −(a + b)` be the third point of the opening line `ℓ = {a, b, c}`. Two immediate facts:

- **`c` is dead for the rest of the game.** `a, b` are on the board and stay there, so adding `c`
  would complete the line `ℓ` — `c` is forbidden from now on.
- **`{a, b}` is `σ_c`-symmetric** (`σ_c` swaps `a, b`, by the arithmetic above) and `c ∉ {a, b}`.

P2 now plays the **mirror strategy**: answer each P1 move `y` with `σ_c(y)`. Maintain the invariant

> *(∗) the board `A` is a `σ_c`-symmetric cap with `c ∉ A`.*

`(∗)` holds after `{a, b}`. Assume it holds and P1 plays a legal `y` (`A ∪ {y}` a cap, `y ∉ A`, and
`y ≠ c` since `c` is forbidden). Then P2's reply `σ_c(y)` is legal and restores `(∗)`:

- `σ_c(y) ∉ A` (as `σ_c(A) = A`, `y ∉ A`); `σ_c(y) ≠ y` and `≠ c` (both from `y ≠ c`).
- `A ∪ {y, σ_c(y)}` is a cap. Any forbidden line must involve `σ_c(y)`:
  - a line `{σ_c(y), p, q}` with `p, q ∈ A` maps under the automorphism `σ_c` to a line
    `{y, σ_c(p), σ_c(q)} ⊆ A ∪ {y}` (as `σ_c(A) = A`) — impossible, `A ∪ {y}` is a cap;
  - a line `{σ_c(y), y, p}` with `p ∈ A` forces `σ_c(y) + y + p = 2c + p = 0`, i.e. `p = c ∉ A` —
    impossible;
  - two new points cannot form a line without a third board point (the cases above).
- The added points `y, σ_c(y)` are `≠ c`, so `c ∉ A` persists.

Hence P2 always has a legal reply after any P1 move. The game is finite, so P1 is the first unable to
move: **P2 makes the last move and wins.** Every opening `{a}` is an N-position ⇒ `∅` is a
P-position ⇒ `G(d) = 0`. ∎

## Why the odd-order obstruction is dodged

`|F₃ᵈ| = 3ᵈ` is **odd**, so `F₃ᵈ` admits **no fixed-point-free involution** — a *whole-board*
pairing certificate (Lemma P0 of the pairing bundle) is impossible, which is what the working note
flagged as the barrier. The theorem does not need one: P1's opening is a **wasted tempo** that lets
P2 place a mirror pair `{a, b}` whose reflection center `c` **self-blocks** (it is the third point of
the opening line), reducing the rest to a clean fixed-point-free mirror `σ_c` on the **even** set
`F₃ᵈ ∖ {c}`. This is exactly the **move-then-mirror corollary P0′** of the
[pairing lemmas](2026-07-04-nodekayles-pairing-lemmas.md), in the hypergraph setting. Because
`AGL(d, 3)` is **2-transitive** on `F₃ᵈ`, every ordered opening pair `(a, b)` is equivalent, so the
single strategy covers all openings — there is no residue case-split.

## Contrast with the Z_n sum-free game

The [Z_n sum-free game](2026-07-04-sumfree-game-theorem.md) uses the *same* reflection idea but its
outcome is a nontrivial **mod-6 law**, because there the mirror has residue-dependent obstructions
(the fixed point `n/2`, the collision pair `{n/3, 2n/3}`) that need not lie on the opening move and
must be counted. In `F₃ᵈ` the affine 2-transitivity forces the single reflection fixed point onto the
opening line, where it self-blocks, so **no obstruction survives and the outcome is uniformly P**. The
cap game is "easier" precisely because affine symmetry is richer than cyclic symmetry — the opposite
of the intuition that the higher-dimensional game should be harder.

## Verification status

- **Proved above, uniform in `d`** — no machine step is load-bearing.
- **Corroboration.** A brute Grundy solver gives `G(1) = G(2) = G(3) = 0`; a direct simulation of the
  P2 mirror strategy confirms **P2 wins against every P1 line of play** for d = 1, 2, 3 — i.e. the
  *strategy itself*, not just the outcome, is validated (over all openings, all P1 replies). The prior
  AGL(4,3) quotient solver independently gave `G(4) = 0`. Script: `2026-07-04-capset-proof.py`.

## Remarks

- **Settles d = 5 (and all d).** The heavy `d = 5` canonicalization (nauty-style labeling) the working
  note queued is now **unnecessary as a decision** — the theorem gives `G(5) = 0` directly. A machine
  `d = 5` solve would be corroboration only.
- **Not the extremal cap-set problem.** As in the working note: this is the *game outcome*, orthogonal
  to the *maximum cap size* (Ellenberg–Gijswijt / FunSearch). The theorem says nothing about cap sizes;
  the game's terminals are inclusion-*maximal* caps.
- **Generalization (open).** The argument uses only: (i) lines are 3-element with `a+b+c=0`; (ii)
  point reflection `σ_c` is a cap automorphism whose fixed point lies on every line through it; (iii)
  the ground set has a legal opening. It should extend to the cap game on `F₃ⁿ`-like affine geometries
  `AG(n, 3)` verbatim, and invites the analogous question for `AG(n, q)`, `q > 3` (where "line" has
  `q` points and the reflection structure differs — a natural next target).
