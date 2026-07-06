# PG(2,q) cap game: the escape-count (total) lemma + a parity proof for q ≤ 9 (2026-07-06)

Builds on the **frame reduction** (`2026-07-06-frame-reduction.md`): `PG(2,q)=P ⟺` the frame is
a P-position `⟺` every legal **size-3 grid position** `S₃` (a 3-cell partial-permutation cap in
`F_q×F_q`) has a **P size-4 child**, i.e. its **escape** = (# P size-4 children) is `≥ 1`.

This note proves a clean counting lemma that (a) makes the total number of size-4 extensions an
explicit odd constant, and (b) yields a **complete parity proof of `PG(2,q)=P` for `q ≤ 9`**, and
pins down exactly why the parity argument stops there — reducing the general odd case to a single
inequality about odd maximal caps.

## The total lemma

> **Lemma (escape count).** For every legal size-3 grid position `S₃` and every prime power `q`,
> the number of legal size-4 extensions is
>
> `total(S₃) = (q-3)² − 3(q-4) = q² − 9q + 21`,
>
> **independent of `S₃`**. For `q` odd this is **odd** (`q²`, `9q`, `21` all odd).

**Proof.** Write `S₃ = {t₁,t₂,t₃}` with distinct rows `R={r₁,r₂,r₃}` and distinct cols
`C={c₁,c₂,c₃}` (partial permutation), no three collinear (cap). A legal 4th cell `w=(r,c)` must
avoid the 3 used rows and 3 used cols, so it lies in the **free-free grid**
`FF = {(r,c): r∉R, c∉C}`, with `|FF| = (q-3)²`; and it must avoid the three pair-lines
`L_{ij}=` line`(t_i,t_j)`. The excluded cells are `FF ∩ (L₁₂∪L₁₃∪L₂₃)`. Two distinct pair-lines
meet in exactly one point, which is their shared vertex `t_i ∉ FF`, so by inclusion–exclusion the
excluded count is `Σ_{ij} |L_{ij} ∩ FF|` with no overlap correction.

*Each pair-line meets `FF` in exactly `q-4` points.* `L_{ij}` passes through `t_i,t_j`, which
differ in both coordinates, so it is a non-axis affine line: it meets **every row once and every
column once** (`q` points total). Hence it has exactly 3 points in used rows —
`{t_i, t_j, L_{ij}∩\text{row }r_k}` — and exactly 3 in used cols —
`{t_i, t_j, L_{ij}∩\text{col }c_k}`. Their union is
`{t_i, t_j, A, B}` with `A=L_{ij}∩\text{row }r_k`, `B=L_{ij}∩\text{col }c_k`. These four are
**distinct**: `A=B` would put the cell `(r_k,c_k)=t_k` on `L_{ij}`, making `t₁,t₂,t₃` collinear,
contradicting the cap property; and `A,B ≠ t_i,t_j` since `A` lies in row `r_k ∉ {r_i,r_j}` and
`B` in col `c_k ∉ {c_i,c_j}` (here `r_k,c_k` are the *third* used row/col, those of `t_k`). So
`|L_{ij} ∩ (\text{used row}∪\text{used col})| = 4`, giving `|L_{ij} ∩ FF| = q-4`.

Therefore `total = (q-3)² − 3(q-4) = q² − 9q + 21`. ∎

The proof uses **only** the partial-permutation and cap properties, so it holds for every `q`.
Verified for **all** size-3 positions at `q=5,7,9,11,13` (`2026-07-06-total-lemma-verify.py`,
checking `total`, `|FF|=(q-3)²`, `|L∩FF|=q-4`, pair-lines-meet-only-at-vertices; e.g.
`total(13)=73`), and `total=43` constant at `q=11` (`2026-07-06-escape-parity.py`).

## The parity consequence and a proof for q ≤ 9

Split the size-4 children of `S₃`: `escape = total − bad`, where `bad(S₃)` = # extensions to an
**even-`N`** size-4 position — one from which the mover completes an **odd maximal cap** in one
move (the parity-defect mechanism, `2026-07-06-qodd-parity-defect-structure.md`). Since `total`
is odd,

> `escape ≡ 1 − bad  (mod 2)`, i.e. **`escape` is odd ⟺ `bad` is even.**

Now the computed parities of `bad` over **all** size-3 positions (`2026-07-06-escape-parity.py`):

| q | total (=q²−9q+21) | `bad` even for all `S₃`? | escape parity | min escape |
|---:|---:|:--:|---|---:|
| 5 | 1 | **yes** | all odd | 1 |
| 7 | 7 | **yes** | all odd | 7 |
| 9 | 21 | **yes** | all odd | 13 |
| 11 | 43 | **no** (24200 of 145200 have `bad` odd) | 121000 odd / 24200 even | 13 |

For `q ≤ 9`, `bad(S₃)` is even for every `S₃`, so `escape ≡ 1 (mod 2)` is **odd**, hence
`escape ≥ 1`. Every size-3 position therefore has a P child (is `N`), so the frame (grid size-2)
has all children `N` and is `P`; by the frame reduction `PG(2,q)=P`. This is a **parity proof**
(no strategy, no case analysis) for `q = 3,5,7,9` — `q=3` vacuously (no size-3 positions; the
frame is already a size-2 maximal cap).

**Why it stops at `q=9`.** At `q=11` the map `bad` is odd on a positive fraction of positions
(those `24200` have `escape = 43 − 25 = 18`, even), so `escape` is no longer forced odd by
parity. It is still `≥ 1` (min 13), but not for a parity reason. `bad`-odd first appears exactly
where **odd maximal caps proliferate** past the single `q=9` seed (the same threshold as every
other route's break).

## The reduced crux

The frame reduction + total lemma turn the whole planar odd conjecture into one inequality:

> `PG(2,q) = P  ⟺  bad(S₃) ≤ q² − 9q + 20  for every size-3 grid position S₃`
> (equivalently `bad(S₃) < total`, i.e. `escape ≥ 1`).

`bad(S₃)` = the number of cells `w` such that `S₃∪{w}` lies in some **odd maximal cap** (odd
complete arc through the burned pair). This is rigorous because of a **validated boundary
characterization** (`2026-07-06-boundary-char-verify.py`, exhaustive q≤9, zero mismatches):

> a size-4 grid position `W` is `N` ⟺ `W` embeds in an **odd maximal cap** (`∃` odd maximal cap
> `⊇ W`).

I.e. the game value of a size-4 position is a purely **static geometric** property — whether it
sits inside an odd complete arc — so `bad(S₃) = #{w ∈ FF : S₃∪{w} ⊆ some odd maximal cap}` is
arc-theoretic, not game-recursive. (Verified q≤9; at larger `q` deeper defects may enter and it
should be re-checked, but if it persists it collapses the whole crux to arc geometry.)

So the crux is a finite **arc-theoretic upper bound**: the cells of `FF` covered by odd maximal
caps through `S₃` never exhaust all `q²−9q+21` legal extensions. The parity proof handles the
regime where these covering cells come in an even count (`q ≤ 9`); the general bound is the open
kernel, and it lives in the theory of complete arcs (the size spectrum of complete arcs in
`PG(2,q)` is itself a hard, well-studied area — a caution that this crux is not merely mechanical).

## Status

- **`total = q²−9q+21` (odd): proven for all `q`.** A load-bearing ingredient for any full proof.
- **`PG(2,q)=P` for `q ≤ 9`: parity proof** (via `bad` even), complementing the exhaustive solves.
- **General odd `q`: reduced to `bad(S₃) < total`** — bound the odd-maximal-cap cover of a 3-cap's
  free-free extensions. Parity alone fails from `q=11` (bad-odd defects); needs a size bound.

## Artifacts

- `2026-07-06-total-lemma-verify.py` — verifies `total=q²−9q+21` and all proof internals, q≤13.
- `2026-07-06-escape-parity.py` — parities of total/bad/escape over all size-3 positions; total
  constant & odd (q≤11), `bad` even for q≤9, bad-odd defects at q=11.
- `2026-07-06-escape-margin.py` — the escape distribution + total/bad/escape decomposition.
- `2026-07-06-boundary-char-verify.py` — validates "size-4 `N` ⟺ embeds in an odd maximal cap"
  (exhaustive q≤9, zero mismatches; q=9: 51840 = 51840), making `bad` fully arc-theoretic.
