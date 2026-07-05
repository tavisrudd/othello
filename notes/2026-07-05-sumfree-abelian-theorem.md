# The sum-free game on finite abelian groups — the 2-rank criterion, PROVEN for 3-rank ≤ 1 or 2-rank ≥ 2

**Date:** 2026-07-05. Upgrades the [abelian conjecture](2026-07-04-sumfree-variants.md) (verified on
~25 groups) to a **theorem** for all finite abelian `G` **except** the thin slice `2-rank ≤ 1 and
3-rank ≥ 2`, which is confirmed computationally and reduced to a single lemma. Companion to the
proven cyclic [mod-6 theorem](2026-07-04-sumfree-game-theorem.md) (whose Lemmas 1–4 this reuses).
Scripts banked: `2026-07-05-sumfree-strat.py`, `2026-07-05-sumfree-probe2.py`,
`2026-07-05-sumfree-verify-local.py`, `2026-07-05-sumfree-lemmaR.py`,
`2026-07-05-sumfree-rho.py` (ρ-mirror + {2,3}-Sylow reduction),
`2026-07-05-sumfree-redu.py` (outcome-reduction check).

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

## Summary table

| `(s₂, τ₃)` and `r₃` | outcome | status | mechanism |
|---------------------|---------|--------|-----------|
| `s₂ ≥ 2`, any `r₃`  | P | **PROVEN** | spare-order-2 translation mirror `τ_v`, `v≠x` |
| `s₂=1, τ₃=0`        | N | **PROVEN** | reduction: `{m}` P via negation mirror (no O₃) |
| `s₂=1, τ₃=1, r₃=1`  | P | **PROVEN** | reduction: `{m}` N via reply `t` + Lemma 4 |
| `s₂=1, τ₃=1, r₃≥2`  | P | open (conf.) | Lemma R: `{m}` is N |
| `s₂=0, τ₃=0`        | P | **PROVEN** | negation mirror from `∅` |
| `s₂=0, τ₃=1, r₃=1`  | N | **PROVEN** | open `t` + Lemma 4 |
| `s₂=0, τ₃=1, r₃≥2`  | N | open (conf.) | Lemma R: `∅` is N |

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
