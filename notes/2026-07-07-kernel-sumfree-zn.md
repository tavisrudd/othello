# Paper kernel (a): the sum-free achievement game on Z_n — full proof

**Date:** 2026-07-07 (F1 pass). Paper-ready version of
[2026-07-04-sumfree-game-theorem.md](2026-07-04-sumfree-game-theorem.md). Changes vs the working
note: (1) **Lemma 4's statement is corrected** — as previously stated it is false (counterexample
below); the fix adds the hypothesis `2(z − t) ≠ 0`, and all uses in the theorem satisfy it. (2) All
case analyses are made exhaustive. (3) The responder principle is isolated as Lemma 0. (4) The
theorem is stated for **all n ≥ 1** (the working note's n ≥ 5 restriction is unnecessary: the
general arguments cover the small cases). Machine re-check of the correction delegated to Codex
(task C1, [queue](2026-07-07-codex-task-queue.md)).

## 1. Conventions

Fix `n ≥ 1`. A set `A ⊆ Z_n` is **sum-free** if there are no `a, b, c ∈ A` (repetition allowed)
with `a + b = c`; in particular `2a = c` with `a, c ∈ A` is forbidden, and `0` belongs to no
nonempty sum-free set (`0 + 0 = 0`).

**The game.** Two players alternately add elements to a common set `A`, starting from `A = ∅`. A
move adds one `x ∈ Z_n \ A` such that `A ∪ {x}` is sum-free. Normal play: the player unable to move
loses. Since `0` is never playable, the game lives on `Z_n \ {0}`; terminal positions are the
inclusion-maximal sum-free subsets of `Z_n`. The game is impartial and finite (`≤ n − 1` moves), so
every position is either **P** (previous player wins = the player to move loses) or **N** (next
player wins); `∅` is P iff the second player wins iff the Sprague–Grundy value `G(n)` of `∅` is 0.

Throughout, when `2 | n` write `m = n/2` (the unique element of order 2), and when `3 | n` write
`t = n/3` (so `3t = 0` and `−t = 2t`; `{t, 2t}` are the two elements of order 3).

## 2. The theorem

> **Theorem 1.** For every `n ≥ 1`, the sum-free achievement game on `Z_n` is a second-player win
> iff `n ≡ 0, 1, 5 (mod 6)`, and a first-player win iff `n ≡ 2, 3, 4 (mod 6)`.

Equivalently: the second player wins iff `[2 | n] = [3 | n]` — the outcome is decided by which of
the two mirror obstructions (§3) exist, and it is P exactly when they exist in matching pairs
(none, or both).

The Grundy values `G(n)` themselves are not eventually periodic in any window computed (n ≤ 65,
[OEIS draft](2026-07-04-sumfree-oeis-draft.md)); only the outcome obeys the mod-6 law.

## 3. Strategy machinery

The proofs are pairing (mirror) strategies. The template:

> **Lemma 0 (responder principle).** Let `𝒫` be a set of positions of a finite impartial
> normal-play addition game such that for every `P ∈ 𝒫` and every legal move `z` at `P` there is a
> legal reply `w` at `P ∪ {z}` with `P ∪ {z, w} ∈ 𝒫`. Then every `P ∈ 𝒫` is a P-position.
>
> *Proof.* Strong induction on the number of empty cells. At `P ∈ 𝒫`, either the mover has no move
> and loses, or after any move `z` the responder plays the promised `w`, reaching `P' ∈ 𝒫` with
> strictly fewer empty cells; by induction `P'` is P, and its mover is the original mover. ∎

The mirror maps and their obstructions:

- **Negation** `ν(z) = −z`. Fails only at fixed points (`2z = 0`, i.e. `z = m`) and at the order-3
  pair (`z ∈ {t, 2t}`, where `{z, −z} = {t, 2t}` is itself not sum-free: `t + t = 2t`).
  Obstruction **O₂** = `m` (exists iff `2 | n`); obstruction **O₃** = `{t, 2t}` (exists iff `3 | n`).
- **Translation** `τ(z) = z + m` (needs `2 | n`). Fixed-point-free; its only unpaired board element
  is `m` itself (partner `0`).

The four step lemmas below verify, in each regime, that the mirror reply is legal.

> **Lemma 1 (negation step).** Let `A ⊆ Z_n \ {0}` be sum-free with `A = −A`, and let `z ∉ A` with
> `A ∪ {z}` sum-free, `2z ≠ 0`, `3z ≠ 0`. Then `w = −z ∉ A ∪ {z}` and `A ∪ {z, w}` is sum-free.

*Proof.* `z ≠ 0` (else `z + z = z`). `w ≠ z` since `2z ≠ 0`; `w ∈ A` would give `z = −w ∈ −A = A`.
So `w ∉ A ∪ {z}`. Let `B = A ∪ {z, w}` and suppose `a + b = c` with `a, b, c ∈ B`. If `w` does not
occur among `a, b, c`, this is a violation in `A ∪ {z}`, contradiction. Negation maps `B`-relations
to `B`-relations (`a + b = c ⟺ (−a) + (−b) = −c`) and maps `A → A`, `z ↔ w`. If the violation
involves `w` but not `z`, its negation involves `z` but not `w`, i.e. is a violation in `A ∪ {z}`:
contradiction. Remaining shapes involve both `z` and `w` (or `w` with itself); each is impossible:

| shape | consequence | why impossible |
|---|---|---|
| `z + w = c` | `c = 0` | `0 ∉ B` |
| `z + b = w`, `b ∈ B` | `b = −2z` | `b ∈ A ⇒ 2z ∈ A` (as `A = −A`) `⇒ z + z = 2z` violates `A∪{z}`; `b = z ⇒ 3z = 0`; `b = w ⇒ z = 0` |
| `w + b = z`, `b ∈ B` | `b = 2z` | `b ∈ A ⇒` same violation; `b = z ⇒ w = 0`; `b = w ⇒ 3z = 0` |
| `w + w = c` | `c = −2z` | `c ∈ A ⇒ 2z ∈ A ⇒` same violation; `c = z ⇒ 3z = 0`; `c = w ⇒ z = 0` |

∎

> **Lemma 2 (translation step).** Let `2 | n`, `m = n/2`, and let `A ⊆ Z_n \ {0}` be sum-free with
> `A = A + m`. Let `z ∉ A` with `A ∪ {z}` sum-free and `z ≠ m`. Then `w = z + m ∉ A ∪ {z}` and
> `A ∪ {z, w}` is sum-free.

*Proof.* Note `2m = 0` and `−m = m`. First, `m ∉ A`: `m ∈ A ⟺ m + m = 0 ∈ A` by τ-invariance, and
`0 ∉ A`. Next `w ∉ {0, z}` (`z ∉ {m, 0}`... `w = 0 ⟺ z = m`; `w = z ⟺ m = 0`), and `w ∈ A` would
give `z = w + m ∈ A + m = A`. Suppose `a + b = c` in `B = A ∪ {z, w}` involving `w` (else it lives
in `A ∪ {z}`). Using `a ∈ A ⟺ a + m ∈ A`:

| shape | consequence | why impossible |
|---|---|---|
| `a + b = w`, `a, b ∈ A` | `a + (b + m) = z`, `b + m ∈ A` | violates `A ∪ {z}` |
| `z + b = w`, `b ∈ A` | `b = m` | `m ∉ A` |
| `z + z = w` | `z = m` | excluded |
| `w + b = c`, `b, c ∈ A` | `z + b = c + m ∈ A` | violates `A ∪ {z}` |
| `w + z = c` | `c = 2z + m` | `c ∈ A ⇒ 2z ∈ A ⇒ z + z = 2z` violates `A ∪ {z}`; `c = z ⇒ z = m`; `c = w ⇒ z = 0` |
| `w + b = z`, `b ∈ A` | `b = −m = m` | `m ∉ A` |
| `w + w = c` | `c = 2z` | `c ∈ A ⇒` violates `A ∪ {z}`; `c = z ⇒ z = 0`; `c = w ⇒ z = m` |

∎

> **Lemma 3 (`m` self-blocks).** Let `2 | n` and let `A ≠ ∅` be sum-free with `A = A + m`. Then `m`
> is not a legal move at `A`.

*Proof.* Pick `z ∈ A`; then `z + m ∈ A`, and `m + z = z + m` exhibits `A ∪ {m}` as not sum-free
(also `m ∉ A` as in Lemma 2). ∎

### Lemma 4, corrected

> **Lemma 4 (negation step with fixed extras).** Let `3 | n`, `t = n/3`. Let `C ⊆ Z_n \ {0}` be
> sum-free with `C \ {t}` symmetric (`−(C \ {t}) = C \ {t}`). Let `z ∉ C` with `C ∪ {z}` sum-free
> and
> `   2z ≠ 0,   3z ≠ 0,   2(z − t) ≠ 0.`
> Then `w = −z ∉ C ∪ {z}` and `C ∪ {z, w}` is sum-free.

Remarks before the proof. (i) The element conditions read: `z ∉ {m}` (order 2), `z ∉ {t, 2t}`
(order 3), and `z ∉ {t, t + m}`; the sets `{m}` and `{t + m}` are empty when `n` is odd. (ii) The
symmetric part may contain `m` (self-negating); `t` may or may not lie in `C`, but `2t ∉ C` always:
`2t ∈ C \ {t}` would force `t = −2t ∈ C`, and `{t, 2t} ⊆ C` violates sum-freeness (`t + t = 2t`).
(iii) **The condition `2(z − t) ≠ 0` is new and necessary.** The 2026-07-04 note omitted it, and
that statement is false: take `n = 12`, `t = 4`, `C = {4}`, `z = 10`. Then `C ∪ {z} = {4, 10}` is
sum-free and `z ∉ {0, 6, 4, 8}`, yet the reply `w = −z = 2` gives `{2, 4, 10}` with `2 + 2 = 4`.
Here `z = t + m` — exactly the excluded case. The gap is invisible to the theorem (in every use,
`z = t + m` is illegal or nonexistent, see §4) and to the machine check over strategy-reachable
positions, which is how it survived; it matters only for the lemma's standalone truth.

*Proof.* `z ≠ 0` (else `3z = 0`). `w ≠ z` (`2z ≠ 0`); `w = t` would give `z = −t = 2t`; `w ∈ C\{t}`
would give `z = −w ∈ C`. So `w ∉ C ∪ {z}`. Also `2t ∉ B := C ∪ {z, w}`: `2t ∉ C` by remark (ii),
`2t = z` is excluded, and `2t = w ⟺ z = −2t = t`.

Suppose `a + b = c` is a violation in `B` involving `w` (else it violates `C ∪ {z}`).

**Case I: `t ∉ {a, b, c}`.** All entries lie in `(C \ {t}) ∪ {z, w}`, which negation maps to
itself (`C \ {t}` is symmetric, `z ↔ w`). If the violation involves `w` but not `z`, its negation
is a violation in `(C \ {t}) ∪ {z} ⊆ C ∪ {z}`: contradiction. If it involves both `z` and `w` (or
`w` twice), the table of Lemma 1 applies verbatim with `A` replaced by `C \ {t}` — each row's `A`-
sub-case yields `2z ∈ C \ {t}` (using the symmetry of `C \ {t}`) and hence the violation
`z + z = 2z` of `C ∪ {z}`, and each remaining sub-case forces `2z = 0`, `3z = 0`, or `z = 0`. ∎(I)

**Case II: `t ∈ {a, b, c}`** (so `t ∈ C`). The shapes, up to commuting `a + b`:

| shape | consequence | why impossible |
|---|---|---|
| `t + b = w`, `b ∈ C \ {t}` | `z = −t − b = 2t − b`, so `z + t = 3t − b = −b ∈ C` | violates `C ∪ {z}` |
| `t + t = w` | `z = −2t = t` | excluded (`3z ≠ 0`) |
| `t + z = w` | `2z = −t = 2t`, i.e. `2(z − t) = 0` | excluded |
| `w + b = t`, `b ∈ C \ {t}` | `z = b − t = b + 2t`, so `z + t = b + 3t = b ∈ C` | violates `C ∪ {z}` |
| `w + t = t` | `w = 0` | `z ≠ 0` |
| `w + z = t` | `t = 0` | `t ≠ 0` |
| `w + w = t` | `2z = −t = 2t` | excluded (`2(z − t) ≠ 0`) |
| `w + t = c`, `c ∈ C \ {t}` | `z = t − c`, so `z + c = t ∈ C` | violates `C ∪ {z}` |
| `w + t = z` | `t = 2z`, so `z + z = t ∈ C` | violates `C ∪ {z}` |
| `w + t = w` | `t = 0` | `t ≠ 0` |

(Shapes with `t` and without `w` violate `C ∪ {z}` directly.) Every case is impossible, so `B` is
sum-free. ∎

## 4. Proof of Theorem 1

Cases by `n mod 6`, i.e. by which of O₂, O₃ exist. In each case we exhibit the required winner's
strategy via Lemma 0; the small cases (`n ≤ 4`) are covered by the same arguments (the mirror
clauses are then vacuous or short).

**`n ≡ 1, 5 (mod 6)` — no obstruction ⇒ P.** Let
`𝒫 = { A : A = −A, A sum-free } ∋ ∅`. At `A ∈ 𝒫` every legal `z` has `2z ≠ 0` (n odd, `z ≠ 0`) and
`3z ≠ 0` (`gcd(3, n) = 1`, `z ≠ 0`), so Lemma 1 supplies the reply `−z`, and `A ∪ {z, −z} ∈ 𝒫`. By
Lemma 0, `∅` is P: the second player wins. (For `n = 1` the board is empty and `∅` is trivially P.)

**`n ≡ 2, 4 (mod 6)` — O₂ only ⇒ N.** The first player opens `m`; `{m}` is sum-free
(`m + m = 0 ∉ {m}`). Let `𝒫 = { A : m ∈ A, A = −A, A sum-free } ∋ {m}` (note `−m = m`). At
`A ∈ 𝒫` every legal `z` has `z ≠ m` (occupied), hence `2z ≠ 0` (the only elements with `2z = 0`
are `0, m`), and `3z ≠ 0` (`3 ∤ n`). Lemma 1 applies (its proof used only `A = −A`, which holds
with `m ∈ A`), so the opener mirrors as responder and, by Lemma 0, `{m}` is P: the first player
wins.

**`n ≡ 3 (mod 6)` — O₃ only ⇒ N.** The first player opens `t`; `{t}` is sum-free (`t + t = 2t ∉
{t}`). Let `𝒫 = { C : t ∈ C, C \ {t} symmetric, C sum-free } ∋ {t}`. At `C ∈ 𝒫`, every legal `z`
satisfies the hypotheses of Lemma 4: `z ≠ t` (occupied); `z ≠ 2t` because `2t` is not even legal
(`t + t = 2t` with `t ∈ C`), and `3z = 0` forces `z ∈ {0, t, 2t}`; `2z = 0` and `2(z − t) = 0`
force `z ∈ {0, t}` since `n` is odd. Lemma 4 supplies the reply `−z`, and
`C ∪ {z, −z} ∈ 𝒫`. By Lemma 0, `{t}` is P: the first player wins.

**`n ≡ 0 (mod 6)` — both obstructions ⇒ P.** The second player answers the two kinds of opening
differently.

*Opening `x ≠ m`: translation mirror.* Reply `x + m`, legal by Lemma 2 with `A = ∅`. Let
`𝒫 = { A ≠ ∅ : A = A + m, A sum-free } ∋ {x, x + m}`. At `A ∈ 𝒫`, every legal `y` has `y ≠ m` by
Lemma 3, so Lemma 2 supplies the reply `y + m` and `A ∪ {y, y + m} ∈ 𝒫`. By Lemma 0, `{x}` is N.

*Opening `x = m`: augmented negation mirror.* Reply `t`; `{m, t}` is sum-free (the sums
`m + m = 0`, `m + t = t + m`, `t + t = 2t` all avoid `{m, t}`: `t + m ∈ {m, t}` or `2t ∈ {m, t}`
would force `t = 0`, `m = 0`, or `n/6 = 0` in `Z_n`, all false). Let
`𝒫 = { C : {m, t} ⊆ C, C \ {t} symmetric, C sum-free } ∋ {m, t}`. At `C ∈ 𝒫` every legal `z`
satisfies Lemma 4's hypotheses: `z ∉ {m, t}` (occupied); `2z = 0 ⇒ z ∈ {0, m}`; `3z = 0 ⇒
z ∈ {0, t, 2t}` and `2t` is illegal (`t + t = 2t`); `2(z − t) = 0 ⇒ z ∈ {t, t + m}` and `t + m` is
illegal (`m + (t + m) = t ∈ C`). Lemma 4 supplies the reply `−z` and `C ∪ {z, −z} ∈ 𝒫` (the new
pair lies in the symmetric part). By Lemma 0, `{m, t}` is P, so the opening `m` also leads to an
N-position for the opener... precisely: `{m}` is N because the second player's reply `t` reaches
the P-position `{m, t}`.

Every opening move from `∅` thus leads to an N-position for the player who made it — i.e. to a
position that is P for the second player — so `∅` is a P-position and the second player wins. ∎

**The crux, in one line.** For `n ≡ 2, 4` the position `{m}` is P (opener mirrors thereafter); for
`n ≡ 0` the same position `{m}` is N, because `3 | n` provides the answer `t`. The whole law is the
pair of divisibility bits `([2 | n], [3 | n])`.

## 5. Verification status and provenance

- Lemmas 0–4 and Theorem 1 are proved above, uniformly in `n`; no machine step is load-bearing.
- Corroboration: the outcome law matches the exact solver for all `n ≤ 65` (zero exceptions), and
  a machine mirror-breaker search over all strategy-reachable positions for `n ≤ 36` found none
  (see the 2026-07-04 note and `sumfree-solver/`).
- The Lemma-4 correction (`2(z − t) ≠ 0`) was found in the 2026-07-07 paper pass and machine-
  confirmed the same day ([Codex check](2026-07-07-codex-lemma4-check.md)): exhaustive breaker
  search to `n = 120` (with a support-reduction argument making the bounded enumeration
  exhaustive) finds that every breaker of the old statement is exactly the `z = t + n/2` family
  and the corrected statement has none; smallest instance `n = 6` (`C = {2}`, `z = 5`, `w = 1`,
  `1 + 1 = 2`). The audit of the abelian-generalization note
  ([2026-07-05](2026-07-05-sumfree-abelian-theorem.md)) found its outcome arguments safe (its two
  uses have `m ∈ E` or no order-2 element) but its "verbatim lift of Lemmas 1–4" phrasing must be
  read against the corrected Lemma 4; the Lean formalization already avoids the trap.
- Prior-art framing: this game is an instance of the nofil genus (Huggan–Huntemann–Stevens, JCD
  2022) on the Schur triple system of `Z_n`, which is not a Steiner system — see kernel (c)
  ([2026-07-07-kernel-nofil-corollaries.md](2026-07-07-kernel-nofil-corollaries.md)) for the exact
  relationship and the convention equivalence.
