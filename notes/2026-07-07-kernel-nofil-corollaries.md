# Paper kernel (c): the nofil corollaries — convention equivalence, the affine family, the projective column

**Date:** 2026-07-07 (F1 pass). Paper-ready version of the exports in
[2026-07-07-nofil-connection.md](2026-07-07-nofil-connection.md). The one place a silent error
would invalidate the paper's framing is the claim that our cap achievement game IS nofil
(Huggan–Huntemann–Stevens, *The combinatorial game Nofil played on Steiner triple systems*,
J. Combin. Designs 30 (2022) 19–47; arXiv:2103.13501) — so the convention equivalence is proved
here in full, at the level of game trees (hence Grundy values, not just outcomes).

## 1. The two rule sets, and their equivalence

Let `H = (V, ℬ)` be a 3-uniform hypergraph (`|b| = 3` for every block `b ∈ ℬ`); a Steiner triple
system STS(v) is the special case where every 2-subset of `V` lies in exactly one block. Call
`A ⊆ V` **independent** if it contains no block. Two impartial normal-play games on `H`:

- **The achievement game 𝔄(H)** (our convention, kernels (a)/(b) with `ℬ` the collinear triples):
  positions are the independent sets; a move goes `A → A ∪ {x}` with `x ∉ A` and `A ∪ {x}`
  independent; the player unable to move loses.
- **Nofil 𝔑(H)** (Huggan–Huntemann–Stevens): players alternately choose unplayed points; the
  point `x` is playable when it does **not** fill a block, i.e. there is no `b ∈ ℬ` with `x ∈ b`
  and `b \ {x}` already fully played; the player unable to move loses.

Nofil's positions are a priori arbitrary play histories; the content of the equivalence is that
its reachable states are exactly the independent sets, with the same move relation.

> **Proposition 3 (convention equivalence).** For every 3-uniform `H`: a nofil play sequence
> `x_1, …, x_k` is legal iff each prefix set `{x_1, …, x_i}` is independent. Consequently the
> reachable positions of `𝔑(H)` are exactly the independent sets of `H` (the positions of
> `𝔄(H)`), a point is nofil-playable at `A` iff it is 𝔄-legal at `A`, and the two games have
> identical game trees — in particular identical Sprague–Grundy values at every position, and
> identical outcomes.

*Proof.* First: if `A` is independent and `x ∉ A`, then
`A ∪ {x}` independent ⟺ `x` does not fill a block at `A`.
(⇒) If `x` filled a block `b` (`x ∈ b`, `b \ {x} ⊆ A`), then `b ⊆ A ∪ {x}`. (⇐) If `A ∪ {x}`
contains a block `b`, then `b ⊄ A` (`A` is independent), so `x ∈ b` and `b \ {x} ⊆ A`: `x` fills
`b`. Now induct on prefixes: `∅` is independent, and by the displayed equivalence a nofil-legal
move from an independent prefix set yields an independent prefix set, while conversely any
sequence whose prefixes are all independent is nofil-legal move by move. The prefix SET determines
the position in both games (neither rule depends on order), the move relations coincide, and both
use the normal-play convention; identical game trees follow, hence identical Grundy values. ∎

Two applications of the setup, needed below:

> **Lemma 7 (the two classical STS families as cap games).**
> (i) The lines of `AG(n, 3)` are exactly the 3-element subsets `{a, b, c} ⊆ F_3^n` of distinct
> points with `a + b + c = 0`, and they form an STS(3ⁿ); independent sets = caps; so
> `𝔑(STS-lines of AG(n,3)) = 𝔄(AG(n,3))`, the cap-set game.
> (ii) The lines of `PG(m, 2)` are exactly the 3-element subsets `{a, b, a + b}` of
> `F_2^{m+1} \ {0}`, and they form an STS(2^{m+1} − 1); moreover `𝔄(PG(m,2))` **is** the
> sum-free achievement game on the group `F_2^{m+1}` (kernel (a)'s rules).

*Proof.* (i) The line through distinct `a, b ∈ F_3^n` is `{a + t(b − a) : t ∈ F_3} =
{a, b, 2b − a}`, and `a + b + (2b − a) = 3b = 0`; conversely if `a + b + c = 0` with all distinct
then `c = −a − b = 2b − a + 3(a − b) = 2b − a`, the third point of the line. Any two distinct
points lie on exactly one line, and lines have 3 points: an STS(3ⁿ). Independent = no full line =
cap (a 3-point line is "full" exactly when all 3 points are chosen; "no three collinear" and "no
full line" coincide because lines have exactly 3 points).
(ii) Points of `PG(m, 2)` are the 1-dimensional subspaces of `F_2^{m+1}`, each containing exactly
one nonzero vector — identify them. Three distinct points are collinear iff the vectors are
linearly dependent iff `a + b + c = 0` iff `c = a + b`. So lines are the triples `{a, b, a + b}`,
an STS(2^{m+1} − 1). For the sum-free identification: kernel (a)'s rule forbids `a + b = c` with
repetition allowed, but over `F_2^{m+1}` the degenerate instance `a + a = c` reads `c = 0`, which
is never on the board — so the sum-free condition on `A ⊆ F_2^{m+1} \ {0}` is exactly "no
distinct `a, b, c ∈ A` with `a + b = c`", i.e. "no full projective line": the games have the same
positions and moves. ∎

(The `Z_n` sum-free game of kernel (a) belongs to the same genus but on the Schur triples of
`Z_n`, which — because of the 2-element degenerate blocks `{a, 2a}` and pairs lying in several
triples — is not a Steiner system; nofil's definition extends verbatim to that hypergraph with
blocks of sizes 2 and 3, and Proposition 3's proof is insensitive to block sizes.)

## 2. The affine corollary: a first infinite determined STS family

> **Corollary 4.** For every `n ≥ 1`, nofil on the affine Steiner triple system STS(3ⁿ)
> (the point–line design of `AG(n, 3)`) has Sprague–Grundy value 0: the second player wins.

*Proof.* By Lemma 7(i) and Proposition 3, this game is the cap achievement game on `AG(n, 3)`,
which is a second-player win by Theorem 2 (kernel (b)); for an impartial game under normal play, a
P-position has Grundy value 0. ∎

Context for the paper: Huggan–Huntemann–Stevens determine nofil exhaustively for all STS of order
`≤ 15` plus sampled systems of orders 19, 21, 25; no infinite family was previously determined.
Corollary 4 supplies the first, and is consistent with their Proposition 6 (every point-transitive
STS has nim-value 0 or 1 — the affine translations act point-transitively on STS(3ⁿ)); the
theorem pins the value to 0 for the whole family. Their computed STS(9) = the unique STS(9) =
`AG(2, 3)` (value 0) is an independent cross-check of the `n = 2` case.

## 3. The projective column and the mod-6 observation

By Lemma 7(ii), nofil on the projective STS family `STS(2^{m+1} − 1)` (the point–line design of
`PG(m, 2)`) is the `F_2^{m+1}` sum-free game. Status — **computed, not proven** (independent
solvers agreeing on outcome and state counts; see `2026-07-05-proj-cap-fast.py` +
`2026-07-05-sumfree-f2-crosscheck.py`):

| m | v = 2^{m+1} − 1 | v mod 6 | nofil value | status |
|---|-----------------|---------|-------------|--------|
| 1 | 3   | 3 | 0 | computed (trivial: one block) |
| 2 | 7 (Fano) | 1 | 0 | computed; matches HHS |
| 3 | 15  | 3 | 0 | computed |
| 4 | 31  | 1 | 0 | computed |
| ≥5 | 63, … | 3, 1, … | ? | **open** (STS(63) = `F_2^6` sum-free is the smallest open case) |

> **Conjecture 5.** Nofil on `STS(2^{m+1} − 1)` has value 0 for every `m ≥ 1`.

A proof cannot be a linear pairing: an involution `1 + N ∈ GL(m+1, 2)` has fixed space of
dimension `≥ (m+1)/2`, far too large to be blocked by one opening pair (this is the same
obstruction that separates the projective program of kernel (d) from the affine theorem).

**Observation 6 (the v mod 6 trend conditions on structure, not congruence).** Since
`2^{m+1} ≡ 2 or 4 (mod 6)` as `m` is even or odd, `v = 2^{m+1} − 1 ≡ 1 (mod 6)` for `m` even and
`≡ 3 (mod 6)` for `m` odd. In the HHS data, `v ≡ 1 (mod 6)` systems trend toward odd nim-values
(STS(13): both systems value 1; their STS(19) sample: all value 1; STS(25): values in {1, 3}),
with the Fano plane (v = 7, value 0) as the lone exception. The projective family adds `v = 31 ≡ 1
(mod 6)` with value 0 (computed) — and Conjecture 5 would make the exceptions an infinite
`≡ 1 (mod 6)` subfamily (all even `m`). The affine family (`v = 3ⁿ ≡ 3 (mod 6)`, value 0) is
consistent with their even-value trend. Together: the correct general statement, if any, must
condition on geometric structure rather than on `v mod 6`.

## 4. Imports worth citing (framing only)

- **Hardness:** HHS Corollary 11: deciding nofil positions on STS is PSPACE-complete (via
  embedding arbitrary Node-Kayles positions, their Theorem 10). Motivation import: generic
  positions of this genus are intractable, so determined structured families (Corollary 4,
  Conjecture 5, kernel (b)'s theorem) are the tractable frontier.
- **Endgame equivalence:** once every remaining block has at most one unplayed point, nofil is
  Node-Kayles on a graph — the published counterpart of the disjunctive decomposition we verified
  for the `Z_n` sum-free game (kernel (a) remarks).
- **Placement of our games in the genus:** cap games on `AG(n, q)` / `PG(2, q)` for `q > 3` live
  on collinear-triple hypergraphs that are not Steiner systems (pairs lie in many triples), and
  the `Z_n` sum-free game lives on the Schur hypergraph; all are nofil-genus games, none are
  literally STS-nofil. The paper's contribution claims must be phrased inside the genus: new
  theorems and determined families, not a new game.

## 5. Provenance

- Proposition 3, Lemma 7, Corollary 4: proved here (Corollary 4 = kernel (b)'s theorem + the
  equivalence). Observation 6's arithmetic is elementary; the HHS data points are theirs
  (JCD 30 (2022), Tables/§ as cited in the O1/O4 pulls); our m ≤ 4 values are computed
  (two independent solvers, matching state counts).
- The nofil rule statement used in Proposition 3 is per the HHS paper as recorded in
  [2026-07-07-nofil-connection.md](2026-07-07-nofil-connection.md); re-verify the wording against
  the published version when drafting the final related-work section (the O4 pull has the
  citations).
