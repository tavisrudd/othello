# Paper kernel (b): the cap achievement game on AG(n,q) is P for every prime power q

**Date:** 2026-07-07 (F1 pass). Paper-ready version of
[2026-07-04-capset-game-theorem.md](2026-07-04-capset-game-theorem.md). Uses the responder
principle (Lemma 0) of kernel (a)
([2026-07-07-kernel-sumfree-zn.md](2026-07-07-kernel-sumfree-zn.md)); everything else is
self-contained.

## 1. Conventions

Fix `n ≥ 1` and a prime power `q`; let `AG(n, q)` denote the point set `F_q^n` with its affine
lines (cosets of 1-dimensional subspaces; each line has `q` points). A **cap** is a set
`A ⊆ F_q^n` containing no three distinct collinear points. For `q = 3` caps are the classical cap
sets ("no full line", since a line has 3 points). For `q = 2` every set is a cap (lines have 2
points).

**The game.** Players alternately add points to a common set `A`, starting from `∅`; a move adds
`x ∉ A` with `A ∪ {x}` a cap. Normal play: the player unable to move loses. Terminal positions are
the inclusion-maximal caps. `∅` is a P-position iff the second player wins iff the Grundy value is
0.

A **cap automorphism** is a permutation `σ` of `F_q^n` mapping lines to lines (hence caps to caps
and legal positions to legal positions); all invertible affine maps qualify. If `A = σ(A)` we call
the position `σ`-symmetric.

## 2. The theorem

> **Theorem 2.** For every `n ≥ 1` and every prime power `q`, the cap achievement game on
> `AG(n, q)` is a second-player win.
>
> **Corollary (cap sets).** The cap-set achievement game on `F_3^d` is a second-player win for
> every `d` — in particular `d = 5` and beyond, with no computation.

## 3. The two shared step lemmas

Both parities of `q` are proved by a mirror strategy through an involutive cap automorphism; the
legality of the mirror reply always reduces to the same parity observation.

> **Lemma 5 (parity lemma).** Let `σ` be a cap automorphism, `A` a `σ`-symmetric cap, and `ℓ` a
> line with `σ(ℓ) = ℓ` on which `σ` acts fixed-point-freely off a (possibly empty) set
> `F ⊆ ℓ` with `A ∩ F = ∅`. If some `y ∈ ℓ` is a legal move at `A`, then `A ∩ ℓ = ∅`.

*Proof.* `A ∩ ℓ` is `σ`-invariant and misses `F`, so `σ` partitions it into 2-element orbits:
`|A ∩ ℓ|` is even. `A ∪ {y}` is a cap containing `y ∈ ℓ`, so `ℓ` carries at most two of its
points, i.e. `|A ∩ ℓ| ≤ 1`. Even and `≤ 1` means `0`. ∎

(For `q = 2` the cap condition is vacuous and the lemma is not needed; see the degenerate case in
§4.)

> **Lemma 6 (mirror step).** Let `σ` be an involutive cap automorphism, `A` a `σ`-symmetric cap,
> and `y ∉ A` a legal move with `σ(y) ≠ y`. Write `ℓ` for the line through `y` and `σ(y)`, and
> suppose `A ∩ ℓ = ∅`. Then `σ(y) ∉ A ∪ {y}` and `A ∪ {y, σ(y)}` is a cap.

*Proof.* `σ(y) ∈ A` would give `y = σ(σ(y)) ∈ σ(A) = A`. Suppose `A ∪ {y, σ(y)}` contains three
distinct collinear points; the triple must contain `σ(y)` (else it lies in the cap `A ∪ {y}`).
If the triple is `{σ(y), p, r}` with `p, r ∈ A`, apply `σ`: `{y, σ(p), σ(r)}` is a collinear
triple in `A ∪ {y}` — impossible. If the triple is `{σ(y), y, p}` with `p ∈ A`, then `p` lies on
the line through `y, σ(y)`, i.e. `p ∈ A ∩ ℓ = ∅` — impossible. ∎

## 4. Proof of Theorem 2

**Case `q` even.** Fix any `v ≠ 0` and let `τ_v(x) = x + v`, an affine cap automorphism. In
characteristic 2, `τ_v` is an involution (`x + 2v = x`) and fixed-point-free. The second player's
strategy: answer every move `y` with `τ_v(y)`; the invariant class is
`𝒫 = { A : A a τ_v-symmetric cap }`, with `∅ ∈ 𝒫`.

For `q = 2` every set is a cap, so every reply is legal and the strategy trivially maintains `𝒫`
(the board pairs off into `{x, x + v}` and fills completely in `2^n` moves). For `q ≥ 4`: given a
legal `y` at `A ∈ 𝒫`, the line `ℓ = { y + sv : s ∈ F_q }` through `y` and `τ_v(y)` satisfies
`τ_v(ℓ) = ℓ`, and `τ_v` acts on it as `s ↦ s + 1`, fixed-point-freely. Lemma 5 (with `F = ∅`)
gives `A ∩ ℓ = ∅`, and Lemma 6 makes the reply `τ_v(y)` legal with `A ∪ {y, τ_v(y)} ∈ 𝒫`. By the
responder principle (kernel (a), Lemma 0), `∅` is a P-position. ∎(q even)

**Case `q` odd.** Now `|F_q^n| = q^n` is odd, so no fixed-point-free involution of the board
exists and the second player instead spends the opening exchange building a self-blocking mirror
center. P1 opens `a`; P2 replies with **any** `b ≠ a` (legal: two points are always a cap). Let
`c = (a + b)/2` (`2` is invertible), the midpoint: `a, b, c` are distinct collinear points, so
once `a, b ∈ A` the point `c` is illegal forever. Let `σ_c(x) = 2c − x`, the point reflection: an
affine involutive cap automorphism whose unique fixed point is `c` (`2c − x = x ⟺ 2(c − x) = 0 ⟺
x = c`), and `σ_c(a) = b`. The invariant class:
`𝒫 = { A : A a σ_c-symmetric cap, {a, b} ⊆ A, c ∉ A }`, with `{a, b} ∈ 𝒫`.

Given a legal `y` at `A ∈ 𝒫`: `y ≠ c` (`c` is blocked by `a, b`), so `σ_c(y) ≠ y` and the line
`ℓ` through `y` and `σ_c(y)` is defined; it passes through `c` (`c` is the midpoint of
`{y, σ_c(y)}`) and is `σ_c`-invariant, with `σ_c` fixed-point-free on `ℓ \ {c}`. Lemma 5 with
`F = {c}` (note `A ∩ F = ∅`) gives `A ∩ ℓ = ∅`; Lemma 6 makes the reply `σ_c(y)` legal, and
`A ∪ {y, σ_c(y)} ∈ 𝒫` (the pair avoids `c`, since `σ_c(y) = c ⟺ y = c`). By the responder
principle, `{a, b}` is a P-position; since P2 can reach it against every opening, `∅` is a
P-position. ∎

**Why the parity of `q` dictates the mirror.** For `q` even the board size `q^n` is even and the
translation provides a whole-board fixed-point-free pairing. For `q` odd the board size is odd, so
every involution has a fixed point; the proof works because the affine group is 2-transitive
enough to place the unavoidable fixed point `c` on the opening secant, where it is dead. (In
projective space neither device exists — no translations, and involutions fix whole subspaces —
which is why the projective analogue, kernel (d)'s program, is a genuinely different problem.)

**Sanity cases.** `AG(1, q)`: all points are collinear, so the game ends after two moves and the
second player wins — consistent (for `q` odd this is the strategy above with an empty mirror
phase). `AG(n, 2)`: the board fills completely; `2^n` even, second player makes the last move.

## 5. Verification status and provenance

- Proved above, uniform in `n` and `q`; no machine step is load-bearing.
- Lean formalization of the mirror layer exists (`CapGame/Affine.lean`:
  `mirror_move_legal`, `initialP_of_fixedPointFreeInvolution`, `initialP_of_orderTwoTranslation`,
  `initialP_of_pointReflection`).
- Corroboration (independent brute-force Grundy, all outcomes P): `AG(2,3)`, `AG(3,3)`,
  `AG(1..2, 5)`, `AG(1..2, 7)`, `AG(2, 9)` (odd non-prime), `AG(1..2, 4)`, `AG(1..2, 8)` (char 2);
  strategy play-through validated stuck-free for `AG(2, {3,4,5,7,8})`, `AG(3,3)` (scripts listed in
  the 2026-07-04 note).
- This theorem specializes (`q = 3`) to the first infinite determined family for nofil on Steiner
  triple systems — see kernel (c).
- Not the extremal cap-set problem: the theorem concerns the game outcome; terminals are
  inclusion-maximal caps, and nothing here bounds maximum cap sizes.
