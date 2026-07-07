# The cap achievement game on AG(n,q) — P for EVERY prime power q

**Date:** 2026-07-04. The "always P" conjecture for the cap-set game (`q=3`, verified d=1..4 by an
AGL(4,3) solver in [sumfree-capset-game](2026-07-04-sumfree-capset-game.md)) is here a **theorem**,
and it holds for the cap achievement game on `AG(n, q)` for **every prime power `q`** — even and odd.
The two parities need different mirrors but share one lemma. Uses the pairing patterns P0 / P0′ of the
[Node-Kayles pairing lemmas](2026-07-04-nodekayles-pairing-lemmas.md), on the affine line hypergraph.
Settles the cap-set `d=5` (and all `d`) with no computation.

## The game

Fix `n ≥ 1` and a prime power `q`. Players alternately build a **cap** `A ⊆ AG(n, q) = F_qⁿ` from
`A = ∅`: a move adds `x ∉ A` keeping `A` a cap, where a **cap** has **no three distinct collinear
points** (over `F_q` a line has `q` points; for `q = 3`, "no 3 collinear" = "no full line" = the
classical **cap set** in `F₃ⁿ`). Normal play, last to move wins. This is impartial hypergraph
Node-Kayles on the collinear-triple hypergraph. `G(n, q)` = Sprague–Grundy value of `∅`; second
player wins iff `G(n, q) = 0`.

## The theorem

> **Theorem.** For every `n ≥ 1` and every prime power `q`, the cap achievement game on `AG(n, q)` is
> a **second-player win**: `G(n, q) = 0`.
>
> **Cap-set corollary (`q = 3`).** `G(F₃ᵈ) = 0` for all `d` — the conjecture, settling d = 5 and
> beyond with no computation.

## The shared parity lemma

Both proofs mirror P1's moves through a **fixed-point-free-off-`F` involutive cap automorphism** `σ`
that reflects a family of parallel lines. The single step both need:

> **Parity lemma.** Let `σ` be a cap automorphism, `A` a `σ`-symmetric cap, and `ℓ` a line on which
> `σ` acts as a **fixed-point-free involution** (so `A ∩ ℓ` splits into `σ`-pairs ⇒ `|A ∩ ℓ|` is
> **even**). If `y ∈ ℓ` is a legal move (`A ∪ {y}` a cap), then `A ∩ ℓ = ∅`.
> *Proof.* `A ∪ {y}` is a cap and `y ∈ ℓ`, so at most two of its points lie on the line `ℓ` ⇒
> `|A ∩ ℓ| ≤ 1`; even and `≤ 1` ⇒ `= 0`. ∎

With `A ∩ ℓ = ∅`, adding the mirror `σ(y)` (also on `ℓ`) creates no collinear triple: a triple
`{σ(y), p, r}` with `p, r ∈ A` maps under `σ` to a triple `{y, σ(p), σ(r)} ⊆ A ∪ {y}` (impossible,
that's a cap); a triple `{σ(y), y, p}` forces `p ∈ ℓ ∩ A = ∅`. So `A ∪ {y, σ(y)}` is a cap — the
mirror reply is always legal.

## Proof of the theorem — by parity of q

**Case `q` even (characteristic 2): whole-board translation mirror.** Pick any `v ≠ 0`. The
translation `τ_v(x) = x + v` is an affine cap automorphism and a **fixed-point-free involution**
(`τ_v(τ_v(x)) = x + 2v = x`, as `2v = 0`). P2 mirrors from `∅`: to each P1 move `x`, reply `τ_v(x)`.
The board stays `τ_v`-symmetric. For a P1 move `y`, the relevant line is `ℓ = {y + tv : t ∈ F_q}`
(through `y` and `τ_v(y)`); `τ_v` acts on it as `t ↦ t + 1`, a fixed-point-free involution (char 2),
so the parity lemma applies and `τ_v(y)` is a legal reply. P2 always answers ⇒ P2 makes the last move
⇒ P2 wins. (This is a **whole-board pairing**, Lemma P0: `|AG(n,q)| = qⁿ` is *even*, so a
fixed-point-free involution exists.) *(`q = 2` is the degenerate sub-case — lines have 2 points, every
set is a cap, the board fills in `2ⁿ` moves.)*

**Case `q` odd: move-then-mirror reflection.** Now `|AG(n,q)| = qⁿ` is **odd**, so **no**
fixed-point-free involution exists — a whole-board pairing is impossible. Instead P2 spends P1's
opening. P1 opens `a`; P2 replies any `b ≠ a`; let `c = (a + b)/2` (midpoint, exists as `2` is
invertible). `{a, b, c}` are three collinear points, so with `a, b` down, `c` is **forbidden
forever**. The point reflection `σ_c(x) = 2c − x` is a cap automorphism, an involution fixing only
`c`, and it swaps `a, b`, so `{a, b}` is `σ_c`-symmetric with `c ∉` the board. P2 mirrors via `σ_c`,
maintaining "board is a `σ_c`-symmetric cap with `c` absent." For a P1 move `y ≠ c`, the line `ℓ`
through `y` and `σ_c(y)` passes through `c` and is `σ_c`-invariant with `σ_c` fixed-point-free on it
*off* `c`; since `c ∉ A`, `A ∩ ℓ` splits into `σ_c`-pairs (even), and the parity lemma gives
`A ∩ ℓ = ∅`, so `σ_c(y)` is a legal reply. P2 always answers ⇒ wins. (This is **move-then-mirror**,
Lemma P0′.)

Either way every opening leaves an N-position, so `∅` is a P-position: `G(n, q) = 0`. ∎

## Why this is the whole story

The cap game is P for **all** `q` because `AG(n, q)` always carries a cap-preserving involution that
pairs the moves — and the parity of the board (= parity of `q`) dictates which:

| `q` | board `qⁿ` | fixed-pt-free involution? | mirror | pattern |
|-----|-----------|---------------------------|--------|---------|
| even (char 2) | even | yes — translation `τ_v` | whole-board | P0 |
| odd | odd | no (odd set) | reflection `σ_c` after burning P1's opening | P0′ |

The odd case's obstruction (no whole-board pairing) is exactly the odd-order impossibility of the
[pairing bundle](2026-07-04-nodekayles-pairing-lemmas.md); it is dodged by the self-blocking
reflection center, because `AGL(n, q)` is 2-transitive so every opening is equivalent. In both cases
the mirror's legality is the one parity lemma above.

## Contrast with the Z_n sum-free game

The [Z_n sum-free game](2026-07-04-sumfree-game-theorem.md) uses the same reflection idea but has a
nontrivial **mod-6 outcome law**, because there the mirror's obstructions (fixed point `n/2`,
collision pair `{n/3, 2n/3}`) need not lie on the opening move and must be counted by residue. Over
`AG(n, q)` the richer affine symmetry (2-transitivity + translations) always places the obstruction
on the opening line or removes it via an even-order involution, so **no obstruction survives and the
outcome is uniformly P**. Higher dimension / larger field makes the game *easier*, not harder.

## Verification status

- **Proved above, uniform in `n` and `q` (both parities)** — no machine step is load-bearing.
- **Lean status (2026-07-07):** the formal game vocabulary now lives in
  [`../lean/CapGame/BuildGame.lean`](../lean/CapGame/BuildGame.lean), with the affine cap game in
  [`../lean/CapGame/Affine.lean`](../lean/CapGame/Affine.lean).  The proof-critical mirror layer is
  formalized as `CapGame.Affine.mirror_move_legal`, `mirrorGood_step`,
  `initialP_of_fixedPointFreeInvolution`, `initialP_of_orderTwoTranslation`, and
  `initialP_of_pointReflection`.  The projective analogue is separated in
  [`../lean/ProjectiveCap/Projective.lean`](../lean/ProjectiveCap/Projective.lean), so affine and
  projective claims cannot be accidentally conflated.
- **Corroboration (brute Grundy outcome = P):** `AG(2,3), AG(3,3)` (`q=3`); `AG(1/2, 5)`, `AG(1/2, 7)`
  (odd prime); `AG(2, 9)` (odd **non-prime**, 81 pts, 410 575 states); `AG(1/2, 4)`, `AG(1/2, 8)`
  (**char 2**). Scripts `2026-07-04-cap-agnq.py` (prime q), `2026-07-04-cap-gf.py` (+ `2026-07-04-gf.py`,
  general `GF(q)` incl. q=4,8,9,25,27).
- **Strategy validated (P2 beats every P1 line of play):** reflection mirror for `AG(2,3), AG(2,5),
  AG(2,7), AG(3,3)`; translation mirror for `AG(2,4), AG(2,8)`
  (`2026-07-04-validate-all.py`, `2026-07-04-capset-proof.py`, `2026-07-04-ag-strategy.py`).

## Remarks

- **Settles the cap-set `d = 5` (and all `d`).** The heavy nauty-style `d = 5` canonicalization the
  working note queued is **unnecessary as a decision** — `G(F₃⁵) = 0` follows from the theorem.
- **Not the extremal cap problem.** This is the *game outcome*, orthogonal to *maximum cap size*
  (arcs/caps in finite geometry; Ellenberg–Gijswijt / FunSearch for `q = 3`). The theorem says nothing
  about cap sizes; the game's terminals are inclusion-*maximal* caps.
- **Projective analogue — conjecturally also always P, proof open.** The cap game on `PG(m, q)`
  (points = 1-dim subspaces; lines = `q+1` points; cap = no 3 collinear) computes to **P in every
  small case**: `PG(1/2/3, 2)` (the last two = Fano and beyond), `PG(1/2, 3)`, `PG(1, 4)`, `PG(1, 5)`
  (`2026-07-04-proj-cap.py`). Note `PG(m, 2)` cap game = the `F₂^{m+1}` sum-free game (a+b=c ⟺
  a+b+c=0 over F₂). But the affine proof does **not** transfer: `PG` has no translations, and the
  board size `(q^{m+1}−1)/(q−1)` has no uniform parity, so neither mirror drops out — a projective
  "always P" needs a genuinely different certificate (harmonic-homology involution?). Open.
- **`k-cap` / higher-degree variants (open).** "No `t` collinear" for `t > 3`, or "no affine plane" /
  higher-flat achievement games, are not covered by this argument (the mirror can create a longer
  forbidden flat); each is a fresh problem.
- **Published prior art for the genus — nofil (added 2026-07-07).** Huggan–Huntemann–Stevens,
  *Nofil on Steiner triple systems*, J. Combin. Designs 30 (2022) 19–47 (arXiv:2103.13501) is the
  SAME game (block-filling moves illegal, normal play, last mover wins) on STS. `AG(n,3)` is an
  STS, so **this theorem's `q=3` case gives nofil its first infinite determined STS family:
  nim-value 0 on `STS(3ⁿ)` for all `n`** (their Prop. 6, vertex-transitivity, pins the value to
  {0,1}; P ⇒ 0). Their computed STS(9) = `AG(2,3)` (value 0) independently cross-checks the
  theorem. The paper's framing must position the theorem INSIDE their genus (new families/theorems,
  not a new game). Full map: [nofil connection](2026-07-07-nofil-connection.md).
