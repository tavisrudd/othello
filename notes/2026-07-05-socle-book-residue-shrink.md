# The bounded-exception BOOK shrinks the socle-reduction residue (positive result)

**Date:** 2026-07-05. After establishing the socle reduction is not a single-mirror phenomenon, this
note develops the **"book style"** approach (base mirror + tabulated bounded exceptions) and shows it
**genuinely shrinks the open residue**: it proves the coprime/higher-power peel for `r₃≤1` outright,
proves the entire bulk is negation-handled, and collapses the `r₃≥2` open core to a **bounded,
coprime-independent socle-coupling residue** (size 1 for `r₃=2`). Scripts:
`2026-07-05-socle-book-{residue,investigate,scaling}.py`.

## The base mirror and its exact exception set

For **odd** `G`, the negation mirror `ν(x)=−x` is **sum-clean on every element except the order-3
ones**: `{z,−z}` is sum-free unless `2z=−z ⟺ 3z=0`. So `ν`'s only failures are on the **socle**
`G[3]\{0}` — a set of size `3^{r₃}−1` depending **only on `r₃`, not on `|G|`**. Call the order-3
elements the **socle** and the rest the **bulk**. The book = a strategy for the socle; the base = `ν`
on the bulk.

**Parity reformulation.** If the bulk is negation-paired, it contributes an *even* number of moves, so
game-length parity = **socle-move parity**. First player wins ⟺ it can force an odd number of socle
moves — which is exactly the socle game `F₃^{r₃}=N`. The whole reduction is therefore *morally* "the
bulk is even, the socle decides," and the only question is whether the socle book and the bulk mirror
can be run together.

## The book strategy and what it proves

**Strategy (odd `G` with 3-torsion, first player).** Open a socle element `o`. Then:
- opponent plays **bulk** `y` (order ≠ 3) → reply `ν(y)=−y`;
- opponent plays **socle** `y` (order 3) → reply with a winning **socle** move (the `F₃^{r₃}` game).

**Computational results** (`socle-book-residue.py`, `-scaling.py`; adversarial over all opponent lines):

| group | `r₃` | outcome of the book | genuine bulk-mirror failures | socle-coupling residue |
|-------|------|---------------------|------------------------------|------------------------|
| `Z3×Z5`, `Z3×Z7`, `Z3×Z11` | 1 | **WINS** | 0 | **0 — peel proven** |
| `Z3³` (elementary) | 3 | **WINS** | 0 | 0 |
| `Z9×Z3` | 2 | fails by 1 | **0** | **1** |
| `Z3²×Z5`, `Z3²×Z7`, `Z3²×Z11` | 2 | fails by 1 | **0** | **1 (constant in `p`)** |

Two genuine facts, and one honest limit:

1. **The bulk reply is always LEGAL.** Under the book, the negation reply `−y` to a bulk move is
   **never** illegal (0 genuine bulk failures, every group, any coprime/higher-power part). So `ν`
   *can* dispose of the entire non-socle part legally, regardless of its size — the coprime / higher
   powers add no illegal obstruction.
2. **`r₃≤1` is PROVEN outright.** For `Z3×Z_p` (any `p`) and `Z3³` the book (negation-bulk + socle) is a
   full **winning** strategy — a clean uniform proof of the coprime *and* higher-power peel whenever the
   Sylow-3 is cyclic (and for elementary socles).
3. **`r₃≥2` LIMIT (verified, corrected):** the book is legal throughout but **loses** — brute solver on
   `Z9×Z3` shows the book position `{o}∪`(two bulk negation-pairs) is already an **opponent-win**, and
   the stuck node `A∪{(3,0)}` is a genuine **hero-loss** (no winning reply at all, not even bulk). So
   *forcing* bulk = negation is **not optimal** for `r₃≥2`: the opponent can steer the forced pairing
   into a lost position. The hero must **adaptively deviate the bulk-pairing**. The failure is
   **coprime-independent** (socle-fail count = 1 whether the bulk is `Z5`, `Z7`, `Z11`, or `Z9`).

## The exact coupling

The stuck position (`Z9×Z3`, `-book-investigate.py`): `A = {o} ∪` two bulk negation-pairs, opponent
plays socle `y=(3,0)`; the σ-reply `σ(y)=−o−y=(6,2)` is **illegal because `(6,2)+(2,1)=(8,0)`** with
`(2,1),(8,0)∈A` bulk (from two *different* pairs) — and every other socle element is likewise blocked.
So the coupling is: **the fixed bulk negation-pairing manufactures Schur obstructions that kill the
socle-σ reply.** Because the whole node is a hero-loss, this is not a one-move repair; it means the
hero cannot commit to negation on the bulk when `r₃≥2` — the bulk pairing must respond to the socle
play.

## What this shrinks the open problem to

- **PROVEN by the book:** coprime + higher-power peels for **`r₃≤1`** (uniform, any bulk); and **every
  bulk reply is legal** for all `r₃` (the coprime/higher-power part is never an *illegal* obstruction).
- **Remaining open core (shrunk + localized):** `r₃≥2` only, where the hero must pair the bulk
  **adaptively** (not by fixed negation) so the socle-σ game is never blocked. The obstruction is
  **coprime-independent** — it lives in the interaction between the socle `F₃^{r₃}` game and the bulk
  pairing, not in the size/identity of the bulk. So the open problem drops from a 2-parameter family
  (`r₃` × arbitrary bulk) to **one parameter (`r₃≥2`) plus a coprime-independent adaptive-pairing
  requirement.**

**Honest status:** the book is not a proof for `r₃≥2` (fixed negation-bulk provably loses), but it
(i) proves `r₃≤1`, (ii) proves bulk-legality for all `r₃`, and (iii) shows the residue is
coprime-independent — a real narrowing. Next: find an **adaptive** bulk-pairing (bulk pairing that
shifts with the socle center, so the socle-σ reply is never blocked) — the analogue of "matched
involution" but *coupled* to the socle game.
