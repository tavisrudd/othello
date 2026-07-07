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

**Lemma 4 (negation mirror with fixed extras — kills O₃, absorbs O₂), corrected 2026-07-07.**
Suppose `3 ∣ n`, put `t = n/3` (so `3t = 0`, `−t = 2t`). Let `E ⊆ {n/2, t}` (with
`n/2 ∈ E ⇒ 2∣n`), and let `C = E ∪ S` with `S = −S`, `C` sum-free, and (if `t ∈ E`) `2t ∉ C`.
Then for any move `z` with `C ∪ {z}` sum-free,
`z ∉ {0, n/2, t, 2t}`, and also `z ≠ t+n/2` when `2∣n` (equivalently `2(z−t) ≠ 0`), the reply
`w = −z` is legal and `C ∪ {z, w}` is sum-free.

*Proof.* This is Lemma 1's negation step with one asymmetric extra `t` and possibly one self-paired
extra `n/2`. New violations not involving either extra reduce exactly as in Lemma 1 to violations
of `C ∪ {z}`. A violation using `n/2` gives `z = n/2 − c` for some `c ∈ C`, hence
`z+n/2 = −c ∈ C`, already contradicting legality of `z`. A violation using `t` either similarly
forces an already-present violation `z+t ∈ C`, or is one of the square/cross cases
`w+w=t` or `t+z=w`; both are exactly `2z=2t`, i.e. `2(z−t)=0`, excluded. Thus no new violation
survives. ∎

The extra hypothesis is necessary. Smallest counterexample to the old standalone statement:
`n=6`, `t=2`, `C={2}`, `z=5`, reply `w=1`, and `1+1=2`. The theorem is unaffected: in the
`n≡3` use there is no `n/2`, and in the `n≡0` use with `E={n/2,t}`, the bad move `z=t+n/2` is
already illegal because `z+t=n/2∈C`. Machine confirmation: all breakers through `n≤120` are exactly
this family, and the corrected statement has zero breakers
([Codex check](2026-07-07-codex-lemma4-check.md)); the paper-ready exhaustive case analysis is in
[kernel (a)](2026-07-07-kernel-sumfree-zn.md).

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

## Generalization to abelian groups (PARTIALLY PROVEN — [2026-07-05](2026-07-05-sumfree-abelian-theorem.md))

The mod-6 law is the cyclic case of a clean criterion for the sum-free game on **any finite abelian
group `G`**:

> **Criterion.** Let `s₂ = ` 2-rank of `G`, `τ₃ = [3 ∣ |G|]`, `r₃ = ` 3-rank. Second player wins iff
> `s₂ ≥ 2`, or (`s₂ ≤ 1` and `s₂ = τ₃`).

For cyclic `Z_n`, `s₂ = [2∣n] ∈ {0,1}` and `r₃ ≤ 1`, so this reads "P iff `s₂ = τ₃`" =
`n ≡ 0,1,5 (mod 6)` — the theorem above.

**Now a THEOREM for `r₃ ≤ 1` or `s₂ ≥ 2`** ([abelian-theorem](2026-07-05-sumfree-abelian-theorem.md)):
- **`s₂ ≥ 2 ⟹ P` for every `G`** — proved cleanly by the *translation mirror with a spare order-2
  element*: to any opening `x`, reply `x+v` for an order-2 `v ≠ x` (exists since `2^{s₂}−1 ≥ 3`),
  then `τ_v`-mirror (O₃-immune). The new phenomenon (`Z₂×Z₂×Z₉ = P` though `Z₉ = N`).
- **`r₃ ≤ 1` (cyclic Sylow-3):** the six cases lift via Lemmas 1–3 and the corrected Lemma 4
  (one order-3 pair, `≤1`
  order-2 element — exactly the `Z_n` situation). A clean **reduction** for `s₂=1`: `∅` is P ⟺ `{m}`
  is N (the unique order-2 `m`; `τ_m` handles every non-`m` opening for all 3-ranks).

**Open slice `s₂ ≤ 1 and r₃ ≥ 2`** (multiple independent order-3 pairs — never occurs in `Z_n`):
confirmed by the solver, reduced to one lemma. The affine reflection `σ_c` fails off pure `F₃ᵏ` and
parity forces only small groups (measured — see the note).

## Verification status

- **Lemmas 1–4 are proved above, uniform in `n`.** With the corrected Lemma 4 covering the two augmented-mirror
  cases (`n≡3` opening; `{n/2,n/3}` P-position for `n≡0`), the six-case proof is **complete** — no
  remaining machine-only step; the machine checks (all old Lemma-4 breakers are exactly the
  excluded `z=t+n/2` family through `n≤120`; outcome law confirmed by the exact solver to **n=65**,
  zero exceptions) are corroboration,
  not load-bearing.
- The only non-symbolic inputs are the finite base cases `n < 5` (direct: `G=0,1,1,2` for n=1..4),
  which the periodic law does not claim.

## Remarks

- **Novelty (prior-art search done 2026-07-04):** the impartial sum-free-set game on Z_n
  **appears-novel** — no published *game* on sum-free sets surfaced, and OEIS has no match for the
  sequence. Nearest neighbours (all distinct): the umbrella is **Node-Kayles on the Cayley sum
  hypergraph** of Z_n (framework only — e.g. Wong, "Nimber Sequences of Node-Kayles Games," *J.
  Integer Seq.* 23 (2024), computes graph families, not sum-free structure); Cameron–Erdős
  **maximal-sum-free-set counting** (extremal, not a game; the game's terminals are maximal sum-free
  sets); Anderson–Harary / Ernst–Sieben **group achievement games** (target = *generate the group*,
  not sum-free); and the arithmetic-Cayley Node-Kayles of
  [game (a)](2026-07-04-cayley-nodekayles-outcome-law.md), of which `Paley_p = Cay⁺(Z_p, QR)` is the
  graph cousin. (Absence of a game is a one-pass negative — do a direct OEIS lookup of computed
  values before staking the claim.)
- **Structure exposed en route:** the game is a *disjunctive game* — `G(position) = XOR over
  connected components of the residual armed-Schur-hypergraph` (verified 0 mismatches / ~70k
  positions). Not needed for the theorem, but it is the fast-solver lever and a structural handle.
- **The `F_3^d` cap-set cousin** (build a cap, last to move wins) is `G(d)=0` for `d=1,2,3,4`
  (d=4 via an AGL(4,3)-quotient solver, memo 7734). "Always P" is a 4-point conjecture; a proof must
  differ from the Z_n one (F₃ᵈ has no order-2 element, so no translation/negation fixed-point mirror
  in the same form). It is **adjacent to, not the same as**, the extremal cap-set problem (maximum cap
  size — Ellenberg–Gijswijt, FunSearch): max size vs game outcome; the neighbour is the *maximal*-cap
  spectrum, not the *maximum* cap (OEIS A090245 is the extremal one, distinct).
- **Prior-art verdict on the cap game — REVISED 2026-07-07: the GENUS is published.**
  Huggan–Huntemann–Stevens, *Nofil on Steiner triple systems*, J. Combin. Designs 30 (2022) 19–47
  (arXiv:2103.13501): the identical game (block-filling moves illegal, normal play) on STS —
  `AG(n,3)` and `PG(m,2)` are the two classical infinite STS families, so the cap-set game and the
  `F₂` sum-free game are nofil on those systems. Their STS(9)=`AG(2,3)` and STS(7)=Fano values (0)
  cross-check ours; our affine theorem gives nofil its first infinite determined family, and our
  `PG(m,2)` P-data (m ≤ 4) breaks their v mod 6 nim-parity trend. The `Z_n` sum-free game is the
  same genus on a non-STS Schur-triple hypergraph (novel INSTANCE, published genus). Papers must
  frame contributions as new theorems/families inside their genus, not a new game. Details:
  [nofil connection](2026-07-07-nofil-connection.md). *(The 2026-07-04 verdict below stands for the
  named non-nofil neighbours.)* This game is not any of:
  - **Anti-Set** — Clark, Fisk, Goren, "A variation on the game Set," *Involve* 9(2):249–264 (2016):
    *separate hands, misère, explicit strategy* (no nimbers). Different game.
  - **Impartial SET** — Uiterwijk & Hufkens, CG 2022 (LNCS, Springer 2023,
    doi:10.1007/978-3-031-34017-8_9; Hufkens M.Sc. thesis, Maastricht 2020): **CONFIRMED a *removal*
    game** — the abstract states "a move means taking a number of cards … (a Set)" and "players take
    turns removing cards that form valid Sets"; `SET-v-c` = v values per characteristic, c
    characteristics (SET-4-3 = the 81-card deck). They remove lines from the layout; **we build an
    independent set (cap) by adding points** — different move set, different game (both live on the
    AG(n,3) line-hypergraph). *(rules verified 2026-07-04 from the public abstract text; the CG-2022
    full chapter is paywalled but the move rule is unambiguous.)*
  - **Impartial geodetic building games on graphs** — Benesh, Ernst, Sieben (Semantic Scholar): a
    *building* game in the same active "impartial games on graphs" family (geodetic sets, not caps —
    geodesic/betweenness structure, disjoint from Set-lines as above). A framework-family relative.
  - **Sieben, "Impartial Hypergraph Games," EJC 30(2) #P2.13 (2023)** — the framework: our cap game is
    the achievement/building game on the AG(n,3) line-hypergraph, which Sieben does not compute
    (he computes product hypergraphs). *(PDF unparseable — re-verify.)*
  - **General-position achievement game** (Klavžar–Neethu–Chandran, arXiv:2111.07425) does **NOT**
    scoop it: gp-forbidden triples are Hamming-*betweenness* triples, a family **disjoint** from
    Set-lines on H(n,3) (a line's third point is never Hamming-between the other two), and that paper
    computes only Cartesian/lex products — no Hamming graphs, no caps.
  - Also cite as distinct: Lampis–Mitsou, "Computational Complexity of the Game of Set," LATIN 2014 /
    arXiv:1309.6504 (complexity of the removal/scoring family). No OEIS entry for the game nimbers.
