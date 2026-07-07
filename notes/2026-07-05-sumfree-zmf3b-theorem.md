# THEOREM — `Z₂ × F₃ᵇ = P` for all `b ≥ 1` (sum-free achievement game)

**Date:** 2026-07-05. Closes the **last open endpoint** of the socle family in the abelian
sum-free game program. Companion to [`F₃ⁿ = N`](2026-07-05-sumfree-abelian-theorem.md) (the other
socle endpoint, already proven) and the cyclic [mod-6 theorem](2026-07-04-sumfree-game-theorem.md).

> **Theorem.** In the sum-free achievement game on `G = Z₂ × F₃ᵇ` (`b ≥ 1`), the empty position is a
> **P-position** (second player wins): `𝒢(G) = 0`. Equivalently, with `m = (1,0)` the unique order-2
> element, `{m}` is an **N-position**, and second player answers any opening `x ≠ m` by the proven
> `τ_m`-mirror. Winning first move from `{m}`: **`p = (0,a)` for any `a ≠ 0`**, then mirror through
> the affine involution `σ(x) = (m+p) − x`.

**Provenance.** The winning strategy is **ChatGPT's** (pair the obstruction `m` with the reply `p`
and mirror through the midpoint `k = m+p`, rather than trying to *fix* `m` — which is what every
earlier single-involution attempt tried and failed at). This note verifies it exhaustively, gives the
clean `(★)` reframing, and **proves the pair-completion lemma for all `b`**. Scripts banked:
`2026-07-05-sigma-verify.py` (exhaustive local sweep + brute + adversarial), `2026-07-05-sigma-t3.py`
(the `ℓ`-pinning device). Supersedes the hyperplane-induction plan of
[the Codex assignment](2026-07-05-codex-assignment-sumfree-socle.md) (the `#4` induction is no longer
needed).

---

## The strategy (group form)

`G = Z₂ × V`, `V = F₃ᵇ`. Write elements `(ε, v)`, `ε ∈ Z₂`, `v ∈ V`. `m = (1,0)` is the unique order-2
element. Fix any `a ∈ V\{0}`; set `p = (0,a)`, `k = m + p = (1,a)`, and

    σ(x) = k − x,   i.e.   σ(ε, v) = (1−ε, a−v).

Properties (all elementary):
- **`σ² = id`** and **`σ` is fixed-point-free** — it flips the `Z₂` coordinate (`1−ε ≠ ε`), so it has
  no fixed point at all. (This dodges the O₂ barrier that killed pure negation.)
- **`σ(m) = p`, `σ(p) = m`** — the base pair `{m,p}` is one complete `σ`-pair.
- **`k` self-blocks:** `k = m+p`, so once `{m,p} ⊆ A` the element `k` is never legal (it completes the
  triple `m+p=k`). Thus the opponent can never play the one element whose `σ`-image is `0`.

**Second-player play from `{m}`:** reply `p`, reaching the `σ`-symmetric sum-free position `{m,p}`;
thereafter answer each opponent move `y` with `σ(y)`. The Pair-completion Lemma (below) shows this
reply is always legal and keeps the position sum-free and `σ`-symmetric; since `σ` is fixed-point-free
the mover always has a reply, so the opponent runs out first.

Two elements are **dead** (never legally playable once `{m,p}` is down), and they are exactly the two
`σ`-problem points: `k` (its `σ`-image is `0`) — blocked by `m+p=k` — and the element of `V`-part
`2a`, blocked because `(0,2a)` doubles to `(0,a)=p` and `(1,2a)` sums with `p` to `m`. The `V`-part
`2a` is the unique `V`-fixed slot of the reflection, so the mirror never needs it.

---

## The clean arena: the `(★)` residual game

After `m=(1,0)` is played, for each `v ≠ 0` at most one of `(0,v),(1,v)` can ever be in `A` (since
`m+(0,v)=(1,v)`). Encode `A` as a **labelled set**: a domain `D ⊆ V` with `0 ∈ D`, and labels
`ε : D → Z₂` with `ε₀ = 1` (the slot `0` is `m`), where `v ∈ D` means `(ε_v, v) ∈ A`.

> **Lemma (reframing).** `A` is sum-free ⟺ **(★)**: for every additive triple `v+w=u` with
> `v,w,u ∈ D`, `ε_v + ε_w + ε_u = 1` (in `Z₂`).

*Proof.* `(ε_v,v)+(ε_w,w)=(ε_u,u)` ⟺ `v+w=u` **and** `ε_v+ε_w=ε_u`. So a Schur triple (a sum-free
violation) exists ⟺ some additive triple in `D` has `ε_v+ε_w=ε_u` ⟺ even label-sum
`ε_v+ε_w+ε_u=0`. Sum-free ⟺ every additive triple has **odd** label-sum = (★). (The case `v=w` is
included — doubling `2v=u`; the anchor triples through `0` reduce to `ε₀=1`, forcing the `m`-label,
and `v+(−v)=0` gives `ε_v=ε_{−v}`.) ∎

Verified numerically: this residual game's outcome equals the full-game outcome of `{m}` for `b=1,2`
against a no-symmetry brute solver (below). In `(★)` language:

- The mover plays `(a, 0)` (`=p`; legal: the only triples in `{0,a}` are `0+0=0`, `0+a=a`,
  each with odd label-sum).
- The `σ`-mirror is `M(v, ε) = (a−v, 1−ε)` (reflect the slot through `a`, flip the label).
- `D` is **`M`-symmetric**: `v ∈ D ⟺ a−v ∈ D`, with `ε_{a−v} = 1 − ε_v`.
- Slot `2a` is dead: adding it forces the even triple `2a + 2a = a` (since `4a=a`, `ε_a=0`).

---

## Pair-completion Lemma (proved for all `b`)

**Lean status (2026-07-07).** The labelled local layer is formalized in
[`../lean/Sumfree/Z2F3Labels.lean`](../lean/Sumfree/Z2F3Labels.lean): `deadSlot_not_labelLegal`,
`avoidsDeadSlot_of_labelLegal`, the explicit `PairCompleted` bundle, and `pair_completion`. The
encoding bridge to the actual group game is formalized in
[`../lean/Sumfree/Z2F3Bridge.lean`](../lean/Sumfree/Z2F3Bridge.lean): `starValid_iff_sumFree_labelledSet`,
`legal_labelledPoint_of_labelLegal`, `labelLegal_of_legal_labelledPoint`, the anchor wrapper
`labelLegal_of_legal_labelledPoint_of_anchor`, and the base-position lemmas
`baseStarValid`, `baseLabelAnchor`, `baseLabelMirrorInvariant`, `baseLabelledSet_mem_iff`. Thus an
ordinary legal opponent move in the encoded anchored position is now known to be exactly a legal
labelled move. The shared finite-game certificate lemmas now live in
[`../lean/CapGame/BuildGame.lean`](../lean/CapGame/BuildGame.lean): `win_iff_exists_isP_child`,
`isP_iff_all_children_win`, `PairReplyBook`, `PCert`, and `NCert`. The global finite-game bridge is
formalized in [`../lean/Sumfree/Z2F3Game.lean`](../lean/Sumfree/Z2F3Game.lean): `encodedGood_step`,
`basePair_isP`, `afterOrderTwo_win`, and `initial_isP`. The former target file now only keeps
cross-reference statements in
[`../lean/Sumfree/Almost/Z2F3Outcome.lean`](../lean/Sumfree/Almost/Z2F3Outcome.lean). The matching
rank-count facts for this concrete product model are formalized in
[`../lean/Sumfree/Z2F3Ranks.lean`](../lean/Sumfree/Z2F3Ranks.lean):
`hasTwoRank_z2v_zmod3_module` and `hasThreeRank_z2v_zmod3_module`; the combined ranked outcome
package is `Sumfree.Z2F3Game.ranked_initial_isP`.

> **Lemma.** Let `D` be `M`-symmetric and `(★)`-valid with `{0↦1, a↦0} ⊆ D`. Let `(y, ℓ)` be a legal
> move (`y ∉ D`, and `D ∪ {y↦ℓ}` is `(★)`-valid). Then the mirror reply `(y*, 1−ℓ)`, `y* = a−y`, is a
> **fresh legal** move and `D' = D ∪ {y↦ℓ, y*↦1−ℓ}` is `(★)`-valid.

Notation: for `d ∈ D`, `d* := a−d ∈ D` with `ε_{d*} = 1−ε_d` (`M`-symmetry). Legal `y` is never the
dead slot `2a`, so `y* = a−y ≠ y`; and `y*∉D` (`M`-symmetry), `y*≠0` (else `y=a∈D`). So the reply is
fresh.

`(★)`-validity: `D ∪ {y↦ℓ}` is already `(★)`-valid, so the only triples that can fail in `D'` are
those containing the slot `y*`. Enumerate additive triples `v+w=u` in `D'` with `y* ∈ {v,w,u}`; in
each, the required condition `ε_v+ε_w+ε_u=1` follows from the legality of `(y,ℓ)` after reflecting one
slot via `d ↦ d*`. Every equality below is in `V = F₃ᵇ` (use `−2t = t`, `3t = 0`).

**Group (a): `y*` present, `y` absent** (other slots in `D`).
- **(a1)** `y*+d=e`: then `y = a−y* = d+e*`, so `d+e*=y` is a triple in `D∪{y}`; its legality gives
  `ε_d+(1−ε_e)+ℓ=1`, i.e. `ε_d+ε_e=ℓ`, which is exactly what `(a1)` needs: `(1−ℓ)+ε_d+ε_e=1`. ✓
- **(a2)** `d+e=y*`: then `y = d*−e`, so `y+e=d*` in `D∪{y}`; legality `ℓ+ε_e+(1−ε_d)=1` ⟹
  `ε_d+ε_e=ℓ`, matching `ε_d+ε_e+(1−ℓ)=1`. ✓
- **(a3)** `2y*=d` (doubling): then `d = 2a+y`, giving two triples in `D∪{y}`: `a+d=y` and
  `d+y=d*` (since `d+y = 2a+2y = d*`). Legality of `d+y=d*` gives `ε_d+ℓ+(1−ε_d)=1+ℓ=1` ⟹ **`ℓ=0`**;
  then `a+d=y` gives `0+ε_d+ℓ=1` ⟹ `ε_d=1`. Required: `2(1−ℓ)+ε_d=ε_d=1`. ✓

**Group (b): both `y` and `y*` present** (third slot in `D`).
- **(b1)** `y+y*=d`: but `y+y* = a`, so `d=a`; condition `ℓ+(1−ℓ)+ε_a = 1` holds automatically. ✓
- **(b2)** `y*+s=y` with `s∈D`: then `s = 2y−a`, and **`s*+y=s`** holds in `V`
  (`(a−s)+y = 2a−y = 2y−a = s`), a triple in `D∪{y}`; its legality gives
  `(1−ε_s)+ℓ+ε_s = 1+ℓ = 1` ⟹ **`ℓ=0`**. Also `a+s*=y` (`= 2a−s = −2y = y`) gives
  `0+(1−ε_s)+ℓ = 1` ⟹ `ε_s=0`. Required: `(1−ℓ)+ε_s+ℓ = 1+ε_s = 1`. ✓
- **(b3)** `y+d=y*` with `d∈D`: then `d = a+y`, so `d* = −y = 2y ∈ D`, and the doubling `y+y=d*`
  gives `ε_{d*}=1` ⟹ `ε_d=0`. Required: `ℓ+ε_d+(1−ℓ)=1+ε_d=1`. ✓
- **(b4/b5)** `2y*=y` or `2y=y*` forces `a=0` or `y∈{0,a}` — all excluded. Anchor triples
  with the `0` slot are harmless separately: their label sum is automatically odd because `eps_0=1`.

Every triple containing `y*` satisfies `(★)`. So `D'` is `(★)`-valid. ∎

**The uniform device.** Each doubling/degenerate case (a3, b2, b3) is closed by an *always-present*
triple of the form **"(a `D`-slot) `+ y =` its `M`-mate"** — `d+y=d*`, `s*+y=s`, or `y+y=d*` — whose
legality pins `ℓ` (or the offending label). This is the char-3 analogue of "the played center
self-blocks": the reflection's `V`-fixed slot `2a` is dead, and the two dead elements `k, (·,2a)` are
precisely where a naive mirror would break.

---

## Theorem and consequence

**Theorem.** `{m}` is an N-position in `Z₂ × F₃ᵇ` (`b ≥ 1`); hence `∅` is a P-position, i.e.
`Z₂ × F₃ᵇ = P`.

*Proof.* From `{m}` the mover plays `p=(0,a)`, reaching the `σ`-symmetric sum-free `{m,p}`; the
opponent moves, the mover mirrors by `σ`. By the Pair-completion Lemma the reply is always legal and
keeps the position `σ`-symmetric and sum-free, and `σ` is fixed-point-free so the reply slot is always
fresh. Thus the mover always answers; the opponent is the one who eventually cannot move. So `{m}`
is N. By the proven **`s₂=1` reduction** (`∅` P ⟺ `{m}` N — Part 2 of the abelian note), `∅` is a
P-position. ∎

**Consequence — historical abelian-program note, superseded.** The theorem above remains valid. The
classification consequence below was later superseded by `2026-07-05-socle-reduction-FALSE.md`: the socle
reduction is false (`Z3^2 x Z7 = P` while `Z3^2 = N`). Keep the following paragraph only as provenance for
what the theorem would have implied if that reduction had survived:

> `𝒢(G) = 0 ⟺ 𝒢(G[6]) = 0`  (outcome depends only on `(2-rank, 3-rank)`).

Both socle endpoints — `F₃ⁿ = N` and `Z₂ × F₃ᵇ = P` — are theorems. So the abelian criterion holds for
**every** finite abelian `G` *modulo the socle reduction alone*.

This is exactly the **strictly-matched fixed-point-free involution** the literature identifies as the
canonical second-player tool (Andres–Huggan–McInerney–Nowakowski); `σ` is that involution, and the
"match" is the char-3 label flip that repairs the affine reflection's `+a` defect.

---

## Verification (banked: `2026-07-05-sigma-verify.py`)

- **Brute, no symmetry** (immune to any root-transitivity assumption): `{m}` is N and `{m,p}` is P for
  `b = 1, 2`.
- **Exhaustive local sweep** — over **all** `σ`-symmetric sum-free positions `⊇ {m,p}` and **all**
  legal opponent moves `y`, the reply `σ(y)` is fresh and `A∪{y,σ(y)}` is sum-free: **0 violations**
  for `b = 1, 2, 3` (b=3: 2872 positions, 22848 checks), for several choices of `a`. This is a
  complete proof for each such `b`.
- **Adversarial all-lines** from `{m,p}` under the `σ`-mirror: hero wins every opponent line,
  `b = 1, 2, 3`.
- **`ℓ`-pinning device** (`2026-07-05-sigma-t3.py`): whenever `s = 2y−a ∈ D`, the move `(y,1)` is
  illegal (0 legal cases, `b=2,3`), blocked by the always-present triple `s*+y=s` — confirming the
  proof's group-(b2) step empirically.
- **Randomized** `b = 4, 5` (`2026-07-05-sigma-sampled.py`, fast bitmask): thousands of random
  `σ`-symmetric sum-free positions along greedy build paths, every legal `y` checked — **0 violations**
  (`b=4`: ~2900 positions / ~162 K checks; `b=5`: ~1600 positions / ~268 K checks). The exhaustive
  sweep is compute-walled past `b=3`, but the proof above is dimension-uniform.

*(Methodological note: the general-group solver `2026-07-05-sumfree-fast.py` applied root symmetry
under the full automorphism group, which is only sound when `Aut(G)` is transitive on legal first
moves — true for pure `F₃ⁿ` but **false** for `Z₈`, `Z₁₀`, and `Z₂×F₃ᵇ` as a whole. Every check in this
note either uses no symmetry (brute) or only the `σ`-pairing (which is a proven graph involution), so
none of them depends on that assumption. A corrected sound solver is being built separately.)*
