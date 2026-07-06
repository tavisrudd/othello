# q-odd planar cap game: central-symmetry analysis (2026-07-05)

Attack on the open q-odd planar kernel (handoff R4). Result: the natural central-symmetry
approach is **provably-sound on the bulk but cannot be completed** — it fails on exactly the
two special lines, and every patch tried breaks down for `q ≥ 9`. The outcome is P for all
computed `q` (`≤ 9`, results note), but the uniform proof stays open, and this rules out the
most natural route with evidence.

## The grid reformulation (clean residual model)

After the opening pair `{a,b}`, put `L=ab` at infinity in a basis of the two burned
directions. The residual is the **q×q grid game** on `F_q × F_q`:

> a legal position is a set of cells with **≤1 per row, ≤1 per column** (a partial
> permutation matrix — the two burned directions become rows and columns) **and no three
> cells collinear** on any affine line. P1 moves first.

`PG(2,q) = P  ⟺  this grid game is a first-player loss.` Verified independently
(`2026-07-05-grid-game.py`, matches the projective solver for `q=2,3,4,5,7`). The
partial-permutation constraint has a decisive consequence used below: **each row and each
column ever holds ≤1 cell.**

## Only central symmetry is a viable collineation mirror

An involution mirror must be an automorphism of the grid hypergraph = an affine map
preserving collinearity **and** the row/column classes. That forces the linear part to be
monomial (diagonal or anti-diagonal). Enumerating the involutions:

- `diag(1,-1)` / `diag(-1,1)` (reflections): every pair `{x, σ(x)}` lies on a common row or
  column ⇒ every mirror reply is a burned-direction violation. Dead.
- anti-diagonal (transpose-type): fixed locus is a whole line (`q` live fixed points). Dead.
- `-I` = **central symmetry `σ_c(x)=2c−x`**: a single fixed point `c`, made dead by taking
  `c` on the opening line `x1x2` (move-then-mirror). The only survivor.

`σ_c` pairs `{x, σ_c(x)}` on a row/column **iff** `x` lies on the center's row or column.
So `σ_c` is clean off those two lines and breaks on them.

## The central-symmetry parity lemma HOLDS (confirmed)

**Lemma.** If `S` is a genuinely `σ_c`-symmetric legal position and `x` is a legal P1 move
off the center's row/column, then `σ_c(x)` is a legal reply.

*Proof.* Any new forbidden set in `S∪{x,σ_c(x)}` must contain `σ_c(x)`. If it omits `x`,
apply `σ_c` (an automorphism) to get a forbidden set in `S∪{x}` — contradiction. So it
contains both `x` and `σ_c(x)`: a row/col 2-edge forces `x` onto the center's row/col
(excluded); a collinear 3-edge `{x,σ_c(x),w}` lies on the line `xc` (central collinearity),
and `σ_c(w)` lies on it too, so `{x,w,σ_c(w)} ⊆ S∪{x}` is a collinear triple — contradiction. ∎

Machine-verified with **zero violations** over all `σ_c`-symmetric legal positions reachable
by bulk-only play (`2026-07-05-sigma-lemma-test.py`): `q = 3,5,7,9,11` (1.5M checks at q=11;
q=13 running), including the composite field `q=9`.

## The obstruction: the two special lines poison the mirror for q ≥ 9

`σ_c` cannot answer a center's-row move: its image is on the same (now-full) row. Two patches
were tried:

1. **Fixed cross-pairing** (τ = σ_c on the bulk, transpose-through-`c` on the special lines,
   `2026-07-05-qodd-mirror-verify.py`): stuck-free for `q=3`, fails for `q≥5`.
2. **Adaptive** (answer a center-row move with a center-column move and vice versa, so the
   two 1-cell resources cancel in parity, `2026-07-05-qodd-adaptive-verify.py`): stuck-free
   for `q=3,5,7`, **fails for `q=9,11` on every first move**.

Diagnosis: any special reply plays a cell that is **not** the `σ_c`-image of P1's move, so
`S` stops being `σ_c`-symmetric. The lemma above needs genuine `σ_c`-symmetry, so once a
special move happens, later bulk replies can become illegal. For `q ≤ 7` the games are too
short for the poisoning to surface (small-case success is misleading); for `q ≥ 9` it does.

**Conclusion.** Central symmetry + local special-line patch is **insufficient** for `q ≥ 9`.
The q-odd planar proof needs a genuinely different mechanism — one that never sacrifices the
global symmetry it relies on, or that abandons the single-involution mirror entirely (e.g. a
Sprague–Grundy decomposition, or a strategy that keeps the center's row and column
permanently balanced). This is the sharpened open problem.

## Artifacts

- `2026-07-05-grid-game.py` — residual grid-game solver (independent reformulation check).
- `2026-07-05-qodd-mirror-verify.py` — fixed τ (σ_c + cross); q=3 only.
- `2026-07-05-qodd-adaptive-verify.py` — adaptive row↔col; q≤7 only.
- `2026-07-05-sigma-lemma-test.py` — isolates and confirms the σ_c parity lemma (all q).
