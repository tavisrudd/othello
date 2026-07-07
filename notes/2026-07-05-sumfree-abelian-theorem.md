# The sum-free game on finite abelian groups — the 2-rank criterion, PROVEN for 3-rank ≤ 1 or 2-rank ≥ 2

**Date:** 2026-07-05. Upgrades the [abelian conjecture](2026-07-04-sumfree-variants.md) (verified on
~25 groups) to a **theorem** for all finite abelian `G` **except** the thin slice `2-rank ≤ 1 and
3-rank ≥ 2`. Companion to the proven cyclic [mod-6 theorem](2026-07-04-sumfree-game-theorem.md).
**Headline results (this note):** (1) `s₂≥2 ⟹ P` for every `G`; (2) the **socle reduction** — the
outcome depends only on `(2-rank, 3-rank)`, collapsing everything to the elementary socle
`(Z₂)^{s₂}×(Z₃)^{r₃}` (conjecture, solver-verified); (3) **★★ THEOREM `F₃ⁿ = N` for all `n`** by a
move-then-mirror strategy — closing the crux `s₂=0` family.

> **UPDATE 2026-07-05 — both socle endpoints are now THEOREMS.** `Z₂×(Z₃)ᵇ = P` for all `b≥1` is
> **PROVEN** via ChatGPT's σ-mirror (play `p=(0,a)`, mirror through `k=m+p`; the char-3 label-flip
> repairs the affine reflection's defect) — full proof + verification in the dedicated note
> [`2026-07-05-sumfree-zmf3b-theorem.md`](2026-07-05-sumfree-zmf3b-theorem.md). Together with `F₃ⁿ=N`,
> **the ONLY remaining open piece of the entire abelian classification is the socle-reduction proof
> itself** (both its endpoints are now settled).
Scripts banked: `2026-07-05-sumfree-strat.py`, `2026-07-05-sumfree-probe2.py`,
`2026-07-05-sumfree-verify-local.py`, `2026-07-05-sumfree-lemmaR.py`,
`2026-07-05-sumfree-rho.py` (ρ-mirror + {2,3}-Sylow reduction),
`2026-07-05-sumfree-redu.py` (outcome-reduction check),
`2026-07-05-sumfree-socle.py` (socle reduction — outcome depends only on `(s₂,r₃)`),
`2026-07-05-sumfree-fast.py` (GL(n,3)-symmetry-reduced solver for the socle games),
`2026-07-05-sumfree-mirror-check.py` (verifies the `F₃ⁿ=N` move-then-mirror theorem),
`2026-07-05-sumfree-zm-mover.py` (`Z₂×F₃ᵇ=P` mover-mirror attempts — all fail on the m-coset).

## The game and the criterion

Sum-free achievement game on a finite abelian group `G`: players alternately build `A ⊆ G` from
`A = ∅`; a move adds `x ∉ A` keeping `A ∪ {x}` **sum-free** (no `a+b=c`, `a=b` allowed so `2a=c`
forbidden). Normal play, last to move wins. `0` is never playable (`0+0=0`), so the game lives on
`G \ {0}`. `G(∅)` = Grundy value; second player wins (P) iff `G(∅)=0`.

Let **`s₂`** = 2-rank of `G` (= `dim_{F₂} G[2]`, the number of `Z₂` invariant factors) and
**`τ₃ = [3 ∣ |G|]`**. Write **`r₃`** = 3-rank (= `dim_{F₃} G[3]`), so `τ₃ = [r₃ ≥ 1]`.

> **Criterion (conjecture, [2026-07-04](2026-07-04-sumfree-variants.md)).** Second player wins iff
> `s₂ ≥ 2`, or (`s₂ ≤ 1` and `s₂ = τ₃`).

For cyclic `Z_n`, `s₂ = [2∣n]` and `r₃ ≤ 1`, so this is "P iff `s₂ = τ₃`" = `n ≡ 0,1,5 (mod 6)` —
the mod-6 theorem.

> **Theorem (this note).** The criterion holds for every finite abelian `G` with **`r₃ ≤ 1` or
> `s₂ ≥ 2`.** In particular:
> - **`s₂ ≥ 2 ⟹ P`** for every `G` (any 3-structure) — the new phenomenon, proved cleanly below.
> - For `G` whose Sylow-3 subgroup is **cyclic** (`r₃ ≤ 1`), the outcome is exactly the criterion,
>   by a verbatim lift of the cyclic Lemmas 1–4.
>
> The remaining slice **`s₂ ≤ 1 and r₃ ≥ 2`** (multiple independent order-3 pairs) is **open**;
> the criterion is confirmed there by the exact solver (Z3², Z9×Z3, Z3³, Z2×Z3², Z2²×Z3², …) and
> reduced to Lemma R below.

## The two mirrors and the two obstruction types

Everything runs on two order-2 symmetries of the additive relation `a+b=c`:

- **Negation** `ν(z) = −z`: an additive automorphism, order 2. Fixed points = `G[2]` (order ≤ 2).
- **Translation** `τ_v(z) = z+v` for `v ∈ G[2]\{0}`: an *affine* involution (order 2 since `2v=0`),
  **fixed-point-free**. Not additive, but sum-*shift*-compatible under `τ_v`-invariance.

The responder's ideal is the **negation mirror** (answer `x` with `−x`, keep `A = −A`). By the
cyclic **Lemma 1** (which uses only `A=−A` and additive arithmetic — no cyclic structure), it never
fails **except** at:

- **O₂ (order-2 elements)** `x ∈ G[2]\{0}`: `−x = x`, no distinct mate.
- **O₃ (order-3 elements)** `x ∈ G[3]\{0}`: `−x = 2x` and `x+x = 2x`, so `{x, −x} = {x, 2x}` is
  itself not sum-free — the mirror reply `−x` is illegal.

The **translation mirror** `τ_v` is governed by the cyclic **Lemma 2** (`τ_v`-invariant sum-free
`A`, legal `x ≠ v` ⟹ `A ∪ {x, x+v}` sum-free) and **Lemma 3** (`v` self-blocks: in any nonempty
`τ_v`-invariant `A`, `v` is illegal). Both proofs use only `A = A+v`, `2v=0`, additive arithmetic,
so **they lift verbatim to any abelian `G`.** Machine-corroborated: `verify-local.py` finds **zero**
L2/L3/`{x,x+v}` violations over all `τ_v`-invariant sum-free positions for
`Z2, Z4, Z6, Z8, Z10, Z2², Z2×Z4, Z4², Z2³, Z2²×Z3, Z2×Z6, Z2×Z9, Z2×Z3², Z2²×Z3², Z2×Z15, Z2×Z8`.

Note: `τ_v` mirroring is **immune to O₃** — it is a translation, not a negation, so when the
opponent plays an order-3 element `u` the reply `u+v` (order 6) is perfectly legal (Lemma 2 says
nothing about 3-torsion). This is the crux of the two clean results.

## Part 1 — `s₂ ≥ 2 ⟹ P` (the new phenomenon), PROVEN

**Second-player strategy.** The first player opens some `x`. Because `|G[2]\{0}| = 2^{s₂} − 1 ≥ 3`,
there is an order-2 element **`v ≠ x`**. Reply **`x + v`**; thereafter `τ_v`-mirror (to every later
opponent move `y`, reply `y + v`).

**Why it wins.**
1. `{x, x+v}` is sum-free ⟺ `x ≠ v` (elementary: the only sums are `2x`, `2x+v`, `2x+2v=2x`, and
   each lands in `{x, x+v}` only if `x = v`; verified, `move2bad = 0` on all groups). Since `v ≠ x`,
   the reply is legal, and `{x, x+v}` is `τ_v`-symmetric (`τ_v` swaps its two elements).
2. From the `τ_v`-symmetric sum-free position, Lemma 2 gives a legal mirror reply to **every**
   opponent move `y` (the reply `y+v` is fresh: `A` symmetric and `y ∉ A ⟹ y+v ∉ A`; and `y+v = v`
   is impossible). Lemma 3 keeps `v` unplayable for both sides from move 2 on (its only partner `0`
   is unplayable, so `v` is the single element the mirror can't pair — and it self-blocks).
3. Hence the second player always has its reply; the first player is always the one who eventually
   cannot move ⟹ second player makes the last move ⟹ **P**. ∎

This needs **nothing about 3-torsion**, so it settles `s₂ ≥ 2` for every `G` — e.g. `Z2²×Z9 = P`
though `Z9 = N`, and all of `Z2², Z4², Z2³, Z2²×Z3, Z2×Z6, Z2²×Z3²` (brute outcomes P, matched).
It is the rigorous form of the note's "the `(Z₂)^r` 2-torsion self-neutralizes" sketch.

## Part 2 — the `s₂ = 1` reduction (clean, all 3-ranks)

When `s₂ = 1` there is a **unique** order-2 element `m`. The `τ_v` trick needs a spare order-2
element `v ≠ x`, which exists iff the opening `x ≠ m`. So:

> **Reduction (`s₂ = 1`).** For any opening `x ≠ m`, the second player wins by `τ_m`-mirror
> (Part 1's argument with `v = m`, valid for every 3-rank since `τ_m` is O₃-immune). Therefore
> **`∅` is P ⟺ `{m}` is N** (and `∅` is N ⟺ `{m}` is P, first player's only candidate win being to
> open `m`).

This isolates the entire `s₂=1` difficulty into the single position `{m}`, for **all** 3-ranks.

- **`s₂=1, τ₃=0` (⟹ N).** `G = Z₂ × H`, `H` odd, `3∤|H|`: no order-3 elements at all. From `{m}`
  the mover negation-mirrors (Lemma 1; `m` is `−`-fixed and already placed, no O₃) ⟹ `{m}` is
  **P** ⟹ `∅` is **N**. (Generalizes `n ≡ 2,4`.)
- **`s₂=1, τ₃=1, r₃=1` (⟹ P).** The 3-torsion is `Z₃ = {0, t, 2t}` — one O₃ pair. From `{m}` the
  mover replies `t`; playing `t` blocks `2t` (`t+t=2t`). The position `{m, t}` is then **P** by the
  cyclic **Lemma 4** with `E = {m, t}` (its "uses `t`" family is killed by `3t=0`, its "uses `m`"
  family by `2m=0`, `m=−m`; both proofs are group-general) ⟹ `{m}` is **N** ⟹ `∅` is **P**.
  (Generalizes `n ≡ 0`.) Lemma 4 neutralizes exactly **one** O₃ pair — the reason `r₃ ≥ 2` is open.

## Part 3 — the `s₂ = 0` cases

`s₂ = 0` ⟺ `|G|` odd ⟺ negation is fixed-point-free (no O₂); the only obstruction is O₃, and there
is **no** order-2 element, so **no translation mirror is available**.

- **`s₂=0, τ₃=0` (⟹ P).** `gcd(|G|,6)=1`: no O₂, no O₃. Second player negation-mirrors from `∅`
  (Lemma 1 applies to every move) ⟹ **P**. (Generalizes `n ≡ 1,5`.)
- **`s₂=0, τ₃=1, r₃=1` (⟹ N).** Sylow-3 `= Z₃`, one O₃ pair `{t, 2t}`. First player opens `t`,
  blocking `2t`; then negation-mirrors via Lemma 4 with `E = {t}` (no O₂ term) ⟹ **N**.
  (Generalizes `n ≡ 3`.)

## The open slice: `s₂ ≤ 1 and r₃ ≥ 2`

The cyclic proof never met **more than one** independent order-3 pair (`Z_n` has `r₃ ≤ 1`). With
`r₃ ≥ 2` the negation mirror is broken at *every* O₃ pair, and neutralizing them costs one opening
move each — Lemma 4 disposes of only one. The two families the theorem leaves open:

- `s₂=0, τ₃=1, r₃≥2` (claimed **N**): `Z3², Z9×Z3, Z3³, …`
- `s₂=1, τ₃=1, r₃≥2` (claimed **P**, i.e. `{m}` is N): `Z2×Z3², Z2×Z9×Z3, …`

> **Lemma R (open).** `{m}` (`s₂=1`) is an N-position, resp. `∅` (`s₂=0`) is an N-position,
> whenever `τ₃ = 1` — for every 3-rank.

**Computational status (all confirmed, this note + prior):** the exact solver gives the criterion
with **zero** mismatches on `Z3² (N), Z9×Z3 (N), Z3³ (N), Z2×Z3² (P), Z2²×Z3² (P)` and the ~25
groups of the original sweep.

**Why the easy mechanisms do NOT extend (measured, so nobody re-tries them):**
- **Affine reflection `σ_c(z) = c − z`** (the cap-game move-then-mirror, `c = 2t`, center `t`):
  preserves sum-freeness **only on pure `F₃ᵏ`** (0 violations on `Z3²`, `Z3³`), and **fails**
  elsewhere (360 violations on `Z9×Z3`, 104 on `Z2×Z3²`, 36 on `Z7×Z3`). `σ_c` is not additive
  (`σ(a)+σ(b) = σ(a+b) + c`); the defect `c` only vanishes on characteristic-3 vector spaces. The
  strategy traces that *looked* like `σ_c` were pure-3-torsion coincidences (`Z3²` is parity-forced;
  see below). `probe2.py`.
- **Terminal parity** forces the outcome only for small groups whose maximal sum-free sets are all
  one parity (`Z3² = [3]` all-odd ⟹ N; `Z2² = [2]` all-even ⟹ P). The genuine `r₃≥2` games are
  **mixed-parity** (`Z9×Z3 = [4..9]`, `Z2×Z3² = [4,5,6,9]`, `Z3³ = [4,5,9]`), so they need a real
  strategy, not a parity count. `probe2.py`.
- The solver's winning lines on `{m}` for `Z2×Z3²` mix an order-3 opening, a twisted-negation
  segment on the 3-part, and a *different* response on the `m`-coset — no single global involution.
  `strat.py`. (The `s₂=1` residual after `m` is a `Z₂`-labelled sum-free game on the odd part `H`,
  where a sum `a+b=c` in `H` is *rescued* iff the labels satisfy `ε_c ≠ ε_a+ε_b` — a possible handle
  for Lemma R.)
- **Combined strategy (B-game + negation mirror) — FAILS off pure `F₃ʳ`** (`lemmaR.py`, the most
  promising route, decisively closed). Idea: first player opens a winning first move of the
  `F₃ʳ` sum-free "B-game" on the order-3 subgroup `T\{0}`, answers later **order-3** moves with the
  B-game winning reply, and **negation-mirrors** every non-order-3 move. Verified over ALL opponent
  play: it **wins pure `F₃ʳ`** (`Z3², Z3³` — but there it *is* the whole game, so this is just the
  note's own `F₃ᵏ=N` conjecture, no new content) and **fails everywhere a non-order-3 element
  exists** — `Z9×Z3`/`Z9×Z9` (order-9 elements block the B-reply, 48/49952 illegal replies) AND
  even elementary-Sylow-3-plus-coprime `Z5×Z3²`/`Z7×Z3²` (1284/23670 illegal replies, legality-aware
  choice does not help). **The order-3 obstruction couples to the rest of `G` through the sum-free
  relation and does not decouple** — a genuine barrier: the two mirrors (negation, translation)
  don't apply to O₃, `σ_c` needs char 3 everywhere, and the B-game can't be run "in parallel" because
  mixed/9-order elements veto its replies. Lemma R needs a new idea, likely inductive on `|G|`.
  **This also entangles Lemma R with the open `F₃ᵏ=N` conjecture** (the pure-3-group case is exactly
  that).
- **Twisted-automorphism mirror `ρ` — FAILS, closing the whole mirror-method family** (`rho.py`).
  Idea: mirror with `ρ =` negation on the 6′-part, identity on `G₆` — an order-2 automorphism with
  fixed set `G₆` and (apparently) no O₂/O₃ bad pairs. It is **sum-clean iff `G₆` has no 3-torsion**
  (0 violations for `Z2×Z5, Z5×Z2², Z35`; fails for every group with 3-torsion). Reason, exactly
  pinned: the bad case is `a+z=ρz` with `a=(ρ−1)z = −2z′` on the negated part; **full** negation
  excludes it because `A=−A ⟹ (−2z ∈ A ⟺ 2z ∈ A)`, already forbidden — but any **partial** mirror
  keeps `A=ρA ≠ −A` and loses that link. **So full negation is the *only* sum-clean order-2
  automorphism mirror, and its obstruction is inescapably O₂∪O₃.** Mirror methods cannot crack
  `r₃≥2`; the route is induction or the outcome reduction above.

## A cleaner reframing: the {2,3}-Sylow outcome reduction (conjecture, strongly supported)

Chasing Lemma R produced a much cleaner structural conjecture. Write `G = G₆ × K` with `G₆` the
**{2,3}-Sylow** (the 2-and-3-primary part) and `K` the **6′-part** (order coprime to 6).

> **Master reduction (conjecture).** The sum-free game outcome depends **only on the {2,3}-Sylow**:
> `G(G) = 0 ⟺ G(G₆) = 0`. The 6′-part is outcome-irrelevant.

**Empirically robust** (`rho.py`/`redu.py`, exact solver): verified `outcome(G) = outcome(G₆)` for
`Z10, Z14, Z22, Z2²×Z5, Z30, Z2×Z5×Z3, Z2×Z7×Z3, Z2²×Z7, Z35, Z5×Z3, Z7×Z3, Z11×Z3, Z13×Z3,
Z5×Z3², Z25` — even and odd, zero mismatches. It **subsumes** the criterion: `s₂, τ₃` are properties
of `G₆`, and the proven cases (`s₂≥2`, `r₃≤1`) are exactly the `G₆` structures we can already decide.

Two sharp facts about it:
- **It is an OUTCOME identity, not a nimber identity.** The full Grundy values differ
  (`G(Z14)=*2` vs `G(Z2)=*1`; `G(Z5×Z3)=*2` vs `G(Z3)=*1`) — only *zero-ness* is preserved. So it is
  **not** a disjunctive sum (that would preserve nimbers); the 6′-part shifts the nimber but never
  its vanishing. A proof needs an outcome-preserving argument, not a Sprague–Grundy decomposition.
- **For odd `G` it becomes:** `outcome(G) = outcome(G₃)` (3-Sylow), so the `s₂=0` side of Lemma R is
  exactly **"every nonzero finite abelian 3-group is N"** — a clean generalization of the note's
  `F₃ᵏ=N` conjecture, supported through `Z3, Z9, Z27, Z3², Z9×Z3, Z3³` (all N).

The master reduction is **equivalent in difficulty to Lemma R** (its only new content is the
unproven slice), but it is a far cleaner statement of the open problem, and it isolates the
irreducible core: **outcomes of sum-free games on 2-and-3-groups.** All proven results here decide
that core except `s₂ ≤ 1 ∧ r₃ ≥ 2`.

**Induction attempt (peel one coprime factor: `outcome(H × Z_m) = outcome(H)`, `gcd(m,6)=1`).**
Pursued as the natural non-mirror proof route. It has a clean structural basis but **re-localizes to
the same core rather than bypassing it** — recorded so the route isn't re-run blind:
- **Exact structural fact (proven, `rho.py`/probe):** since 2,3 are invertible mod `m`, every
  order-2 and order-3 element of `H × Z_m` has `Z_m`-coordinate `0`. So **`H × Z_m` has *exactly*
  the O₂/O₃ obstruction of `H`** (the pure-`H` copy `H×{0}`), and the entire `Z_m`/mixed part is
  negation-clean (no new bad pairs). This is *why* the coprime part is outcome-neutral.
- **`s₂ ≥ 1` transfers cleanly:** the 2-rank is preserved by a coprime factor, so `s₂≥2 ⟹ P` and the
  `s₂=1` reduction apply to `H × Z_m` verbatim. Illustration: `Z30 ≅ Z6×Z5`, and its winning
  translation mirror `T_{15}` is — under CRT — `T_{(3,0)}` = translate by the order-2 element of the
  `Z6`-part, **identity on `Z5`**; the mirror lives entirely in the {2,3}-part and the coprime part
  rides trivially.
- **`s₂ = 0` does NOT drop out:** lifting a winning `H`-strategy by "full negation on the `Z_m`
  coordinate" fails for the *same* reason the combined B-game strategy failed — the obstruction-
  handling moves (pure-`H` order-3 plays) interfere with the mirror of the mixed `(h,i)` elements,
  the identical `a+z=ρz` collision. The product game does not cleanly project onto `H`. So the
  induction step is true but its proof is exactly as hard as resolving `H`'s own `r₃≥2` core.
- **Upshot:** every route (5 attacks: negation, translation, `σ_c`, combined B-game, `ρ`/induction)
  hits the **same** interference wall between obstruction-handling and mirroring. The open core is
  genuinely irreducible and subsumes `F₃ᵏ=N`; a proof needs a technique that does not rely on a
  global order-2 symmetry.

### ★ Sharpest form — the SOCLE reduction (outcome depends only on `(s₂, r₃)`)

Framing the problem as an **S2 bounded-exception book** (negation = the clean base mirror, its
exceptions tabulated) sharpens the master reduction all the way down. **Negation `ν` is sum-clean on
*every* non-socle element**: order-4/8/… are clean (`{z,−z}` sum-free since `2z ≠ −z` unless
`3z=0`), order-9/27/… are clean (`3z ≠ 0`), coprime elements are clean. **The only exceptions are
`O₂ ∪ O₃ = ` the socle `G[6] = {x : 6x=0} = (Z₂)^s₂ × (Z₃)^r₃`** — a bounded set. And the outcome is
exactly that of the exception game:

> **Socle reduction (conjecture, solver-verified, 0 mismatches).** `G(G)=0 ⟺ G(G[6])=0`, i.e. the
> sum-free game outcome depends **only on the 2-rank and 3-rank**: it equals the game on the socle
> `(Z₂)^{s₂} × (Z₃)^{r₃}`.

Verified for general `G` (even/odd, with 6′- and higher-prime-power parts):
`Z4,Z8,Z16,Z9,Z27,Z2×Z4,Z4×Z4,Z2×Z8,Z9×Z3,Z2×Z9,Z8×Z3,Z2²×Z9,Z10,Z14,Z30,Z35,Z5×Z9,Z5×Z3²,Z7×Z3`
— every `outcome(G) = outcome(G[6])`. This **subsumes** both the `{2,3}-Sylow` reduction (`Z9→Z3`,
`Z4→Z2` also collapse) and is the cleanest possible statement.

**It collapses the whole open core to TWO small elementary families.** With `s₂≥2 ⟹ P` and `r₃≤1`
already proven, the socle reduction leaves exactly:
- **`(Z₃)^b`** — this *is* the `F₃ᵇ` sum-free game. **NOW A THEOREM: `F₃ⁿ = N` for all `n`** (next
  section — move-then-mirror).
- **`Z₂ × (Z₃)^b`, `b ≥ 1` — NOW A THEOREM: `= P`** (full proof + verification in
  [`2026-07-05-sumfree-zmf3b-theorem.md`](2026-07-05-sumfree-zmf3b-theorem.md)). Via the proven
  `s₂=1` reduction this is "`{m}` is N"; the `Z₂` factor *flips* the 3-group outcome (`Z₃ᵇ`=N but
  `Z₂×Z₃ᵇ`=P). The single-involution *fixing*-`m` mover-mirrors all FAIL for `b≥2`
  (`sumfree-zm-mover.py`: glide, negation-on-`H`, `ψ` — each an O₃ doubling on the m-coset), because
  fixing `m` forces an origin-centered reflection carrying the O₃ doubling. **The fix (ChatGPT):**
  don't fix `m` — *pair* it. Mover replies `p=(0,a)`, completing the `σ`-pair `{m,p}`, then mirrors
  through the affine involution `σ(x)=(m+p)−x = (1−ε, a−v)`. `σ` flips `Z₂` ⟹ fixed-point-free (dodges
  O₂); it is an affine `V`-reflection whose `+a` defect is repaired by the **char-3 label flip**
  (dodges O₃, as in the `F₃ⁿ` proof); and `k=m+p` self-blocks. Proven for all `b`.

So the socle reduction now has **both endpoints as theorems** (`F₃ᵇ=N` and `Z₂×Z₃ᵇ=P`); the
irreducible open core is **only the socle-reduction proof itself.**

### ★★ THEOREM — `F₃ⁿ = N` (first player wins) for all `n`, by move-then-mirror

**Lean status (2026-07-07).** The local mirror-legality kernel is formalized as
`f3_affine_mirror_legal` in [`../lean/Sumfree/MirrorLemmas.lean`](../lean/Sumfree/MirrorLemmas.lean).
The global game-outcome theorem still needs formal game semantics; its current target stub is
[`../lean/Sumfree/Almost/F3Outcome.lean`](../lean/Sumfree/Almost/F3Outcome.lean).

The crux conjecture is now a theorem. The winning move was reverse-engineered from the solver's `F₃³`
strategy (every reply is `−(x₀+y)`), then proved. Prior-art note: the lit search confirmed
strategy-stealing is **invalid** for this game, so a bespoke first-player strategy was the *only*
route — this is it.

**Strategy.** Player 1 opens any `o ∈ F₃ⁿ`, `o ≠ 0`. Thereafter it answers each opponent move `y`
with **`σ(y) = −o − y`** — the affine point-reflection through center `o` (`σ(o)=o`, `σ²=id`, and `o`
is its *only* fixed point since `σ(y)=y ⟺ 2y=−o ⟺ y=o`). This is the cap-game move-then-mirror shape,
but now the center is *played* (it is a legal sum-free singleton), giving P1 the one-move lead.

**Lemma (σ-mirror is sum-clean on `F₃ⁿ`).** Let `A ⊆ F₃ⁿ` be σ-symmetric (`σA=A`), sum-free, with
`o ∈ A`; let `y ∉ A`, `y ≠ o`, and `A∪{y}` sum-free. Then `A∪{y, σy}` is sum-free.

*Proof.* Put `w = σy = −o−y`; then `w ≠ y` and `w ∉ A` (else `σw=y∈A`). As `A∪{y}` is sum-free,
every new violation involves `w`. Using `A=σA` (so `a∈A ⟹ σa=−o−a∈A`) and `o∈A`:
- **`w = p+q`, `p,q ∈ A∪{y}`.** If `p,q∈A`: from `p+q=−o−y` get `y+p = −o−q = σq ∈ A`, a violation
  of `A∪{y}`. If `p∈A, q=y`: `p+y=w` gives `p = y−o`, so `p+o=y` with `p,o∈A`, a violation. If
  `p=q=y`: `2y=w` forces `3y=−o`, i.e. `o=0` — excluded.
- **`p+w = r`, `p ∈ A∪{y}`, `r ∈ A∪{y,w}`.** If `p,r∈A`: from `p+w=r` get `y = p+σr ∈ A+A`, i.e.
  `p+σr=y`, a violation. If `p∈A, r=y`: `p+w=y` gives `p=o−y`, so `y+p=o` with `p,o∈A`, a violation.
  If `p=y, r∈A`: `y+w=r` gives `r=−o=2o`, but `o∈A ⟹ 2o∉A` (`o+o=2o`) — contradiction. The `p=w`
  (`2w`) cases give `2w=o+y`, and `o+y∈A` would be a violation `o+y=(o+y)` of `A∪{y}`, so `o+y∉A`;
  the rest force `o=0` or `w=0`. All excluded.

No new violation survives. ∎ *(Char 3 is essential: the `2y=w` sub-case is killed only by `3y=0`; on
a group with higher-order elements `σ` breaks — matching the non-pure-`F₃ⁿ` violations in `probe2`.)*

**Theorem.** `F₃ⁿ` is an N-position for all `n ≥ 1`.

*Proof.* `{o}` is sum-free and σ-symmetric. By the Lemma each P1 reply keeps the position σ-symmetric
and sum-free. `σ`'s only fixed point `o` is already in `A`, so every opponent move `y` (necessarily
`≠o`) has a distinct legal reply `σy ∉ A`; P1 is never forced onto `o` (would need `y=o`). Hence P1
always has a reply, so the opponent is always the one who eventually cannot move — P1 makes the last
move ⇒ N. ∎

**Verification.** Lemma cleanness machine-checked: **0 violations**, exhaustive for `n=2,3` and over
**1.39 M** σ-symmetric positions for `n=4` (`sumfree-mirror-check`, banked); `σ` has exactly one
fixed point each; the solver's independently-found `F₃³` replies are exactly `σ(y)=−(o+y)`. This
also **resolves `F₃⁴ = N`** — which the search solver compute-walled — by a constructive strategy.

**Consequence.** With the socle reduction, `s₂=0 ⟹ outcome = outcome((Z₃)^{r₃})`, so `s₂=0` is now
`N ⟺ r₃≥1 ⟺ τ₃=1` = the criterion (modulo the socle reduction). `F₃ⁿ=N` is also a clean standalone
theorem — novel (lit-confirmed unpublished; strategy-stealing provably can't yield it).

## Prior art, maximal-set structure, and the compute frontier (2026-07-05 lit + solver sweep)

Three subagents (two literature, one solver) swept the open core (`F₃ᵇ` and `Z₂×Z₃ᵇ`).

**Novelty — confirmed with coordinates.** The game-*type* is Sieben's building-avoidance game `AVD(H)`
= Node-Kayles on a hypergraph (**Sieben, "Impartial Hypergraph Games," EJC 30(2) 2023, #P2.13**), but
he never instantiates the Schur/sum-free hypergraph; **no Grundy/outcome for `F₃ⁿ` or any abelian
group is published, and OEIS is empty.** Neighbors to cite-and-distinguish: Anderson–Harary /
Ernst–Sieben *generating* games (target = generate `G`, not sum-free); Maker–Breaker **Rado games**
(partizan, *create* a solution); ***nofil* on Steiner triple systems** (arXiv:2103.13501 — reduces to
Node-Kayles but STS ≠ Schur, PSPACE-complete); Impartial SET (removal); the cap-set game (relation
`a+b+c=0`, distinct). **Terminology bridge:** our terminals are **"locally maximal sum-free sets"
(LMSF)** in the group-theory literature — the right search term.

**No shortcut — the decisive negative.** (i) **Strategy-stealing is INVALID here**: monotonicity
fails (adding an element *removes* future legal moves), and it would contradict our own `Z_n`
P-positions; there is **no general first-player tool** for Node-Kayles/achievement games. (ii) the
LMSF structure gives no parity handle below the gap (next). ⇒ **`F₃ᵇ=N` must be settled by
computation or a bespoke first-player strategy.** The general SECOND-player tool — a **strictly
matched fixed-point-free involution** (Andres–Huggan–McInerney–Nowakowski) — is the right frame for
the `Z₂×Z₃ᵇ=P` side (it is the abstract genus of our translation/negation mirrors).

**LMSF structure in `F₃ⁿ` (the game's terminals).** `μ(F₃ⁿ)=3ⁿ⁻¹` (**Green–Ruzsa**, Israel J. Math
147 (2005); type-II group), attained exactly by **affine hyperplane cosets `{φ=1}`** (size `3ⁿ⁻¹`,
odd). **Lev's gap** (**Lev, JCTA 111 (2005) 337–346**): `|A| > 5·3ⁿ⁻³ ⟹ A ⊆ a hyperplane`, so LMSF
sizes lie in `{Ω(3^{n/2}), …, 5·3ⁿ⁻³} ∪ {3ⁿ⁻¹}` with an **empty gap** `(5·3ⁿ⁻³, 3ⁿ⁻¹)`; the two top
sizes are **odd**, the small ones **mixed-parity**; min size `Ω(√|G|)` (**Giudici–Hart**, EJC 2009 —
exact min open). **Not well-covered for `n≥3`** (matches our data `F₃³` sizes `{4,5,9}`), and **no
classification exists below the gap** — exactly where the game outcome is decided.

**Solver sweep** (bitmask positions, `O(1)` incremental legality via `SumSet`/`DiffSet`/doubling-
preimage, `GL(n,3)`-canonical memo, α-β; validated against the reference on 17 groups —
`2026-07-05-sumfree-fast.py`):
- **`Z₂×(Z₃)³ = P` — CONFIRMED** (the P family now verified to `b=3`). Winning play = translation
  mirror `z↦z+t` on the order-2 element `t` (fpf involution, `2t=0`), the even-order structure, one
  `x=t` exception. LMSF sizes `min 7, max 27`, mixed parity.
- **`F₃⁴ = N`: COMPUTE-WALLED** — 35 M+ nodes / 600 s, no termination; **memory-safe (<800 MB)**, so
  a *compute* wall. The decisive lever is *full* `GL(4,3)` canonicalization (it cut the analogous
  `Z₂×Z₃³` by ~60×), but `|GL(4,3)|=24.3M` is too large to enumerate for per-node min-image; the
  correct tool is a **BSGS minimal-image / partition-backtrack canonicalizer** (Linton-style), not
  pure CPython. `F₃⁴` max sum-free set `= 27 =` the hyperplane `{x₀=1}` (matches Lev). So `F₃ᵇ=N`
  stands **verified `b≤3`**, consistent-but-unconfirmed at `b=4`.

**Compute frontier / next tool.** `F₃⁴` (and likely `F₃⁵`) is reachable with a proper minimal-image
canonicalizer under `GL(n,3)` — a Rust/nauty-style implementation is the concrete next step to
strengthen `F₃ᵇ=N` (the crux conjecture the socle reduction leaves). Pure-Python + monomial symmetry
is not enough.

## Summary table

| `(s₂, τ₃)` and `r₃` | outcome | status | mechanism |
|---------------------|---------|--------|-----------|
| `s₂ ≥ 2`, any `r₃`  | P | **PROVEN** | spare-order-2 translation mirror `τ_v`, `v≠x` |
| `s₂=1, τ₃=0`        | N | **PROVEN** | reduction: `{m}` P via negation mirror (no O₃) |
| `s₂=1, τ₃=1, r₃=1`  | P | **PROVEN** | reduction: `{m}` N via reply `t` + Lemma 4 |
| `s₂=1, τ₃=1, r₃≥2`  | P | **socle case PROVEN** (`Z₂×F₃ᵇ`); general via socle reduction | σ-mirror through `k=m+p` |
| `s₂=0, τ₃=0`        | P | **PROVEN** | negation mirror from `∅` |
| `s₂=0, τ₃=1, r₃=1`  | N | **PROVEN** | open `t` + Lemma 4 |
| `s₂=0, τ₃=1, r₃≥2`  | N | **socle case PROVEN** (`F₃ᵇ=N`); general via socle reduction | σ move-then-mirror |

## Remarks

- **Novelty / prior art:** unchanged from the cyclic note — the impartial sum-free game appears
  novel (one-pass OEIS + web search); no published game on sum-free sets surfaced. This note extends
  the *domain* from `Z_n` to all abelian `G`; the `s₂≥2` self-neutralization is a new structural
  phenomenon with no cyclic analogue (cyclic groups have `s₂ ≤ 1`). Re-verify prior art before any
  external writeup.
- **The reduction is the reusable tool:** "`s₂=1` ⟹ outcome = outcome of `{m}`" holds for every
  3-rank and cleanly separates the (settled) 2-torsion from the (open) 3-torsion. A proof of
  Lemma R closes the whole criterion.
- **This is a genuine partial result, not the full conjecture** — the `r₃ ≥ 2` slice is open. But
  the theorem now covers an *infinite* family the cyclic result could not (all `s₂ ≥ 2`), plus every
  group with cyclic Sylow-3, and pins the remaining core to one lemma about mirroring several
  independent order-3 pairs.
