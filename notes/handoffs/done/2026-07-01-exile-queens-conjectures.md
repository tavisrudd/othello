# Side quest: numerically attack the "Queens in exile" conjectures 22 & 26 (A274641 / A274528)

**Date**: 2026-07-01
**Created by**: 2026-07-01--15 (`de6cb2bb-e518-4423-bfbf-f05078b26543`)
**Purpose**: Extend two OEIS Sprague-Grundy tables by brute compute to test (and possibly refute)
two open conjectures from Dekking–Shallit–Sloane, *Queens in exile*, ELJC 27(1) #P1.52 (2020).

---

## Context

The paper studies a **single-token** queen game: number the board's cells (square spiral on Z×Z,
or upward antidiagonals on N×N); a queen sits on one cell; players alternately move it to any
**lower-numbered** cell a queen's move away; last mover wins. The SG value of each cell is a mex
over its ≤O(cells) predecessors, so the whole table is computable cell-by-cell — pure compute,
trivially parallel, no game-tree search. This is NOT our Node-Kayles placement game; it's a side
quest in the same OEIS community (Sloane/Shallit/Dekking; the A274528/A274640 cluster).

Two conjectures are open and data-attackable:

- **Conjecture 22** (spiral board, SG table = **A274641**): every row, column, and diagonal of
  slope ±1 of the SG table is a permutation of N. They note even the axis values (A324778/A324774)
  aren't known to be surjective. More terms → either a counterexample-shaped anomaly (a value
  that never appears in a line over a huge range) or stronger evidence + growth-rate data.
- **Conjecture 26** (single-quadrant board, SG table = **A274528**): every COLUMN of the SG table
  eventually becomes quasi-periodic with period 16 — generating function with denominator
  `(1−x)(1−x^16)`. Column 1 is exactly `r ⊕ 2` (A004482). Verified only for the first few columns.
  Computing columns to large row indices and fitting the recurrence `a(r+16) = a(r) + c` (per
  residue class) directly tests it — and if true, finding where each column's quasi-period locks
  in is publishable data (cf. Dress–Flammenkamp–Pink, additive periodicity of SG functions).

## Scope

- In: a standalone fast SG-table generator (Rust, this repo or scratch) for the two numbered
  boards; tables to the largest feasible extent (memory is the limit: the spiral table to shell
  radius R needs the full (2R+1)² table resident, values grow ~linearly); automated checks of
  the two conjectures over the computed range; a short results note; optionally b-file
  extensions / comments for OEIS.
- Out: proofs; the morphic-word machinery; anything touching the queens Node-Kayles solver.

## Work Items

1. **Generator**: SG(cell) = mex over lower-numbered same-line cells. Naive per cell is
   O(ray-length) mex-set builds; the standard trick is per-line incremental structures (each of
   the 4 lines through a cell keeps the set of values already on it — the mex needs "values of
   earlier cells on my 4 lines", which is exactly the row/col/diag value-sets the conjecture
   asks about). Aim ≥10⁹ cells on the 26 GB box (u32 values, 4 bytes/cell + line-set bitsets).
2. **Conjecture 26 test**: for the quadrant board, extract columns 0..C to depth D; for each,
   find the least r₀ such that `a(r+16) − a(r)` is constant for all r ≥ r₀ (and report the
   constant); flag any column that fails through D.
3. **Conjecture 22 test**: for the spiral board, per row/col/±diag within the computed square,
   track the least value not yet seen vs the line's extent — report lines whose "missing value"
   age grows anomalously (permutation ⇒ every value appears eventually).
4. **Results note** + (user call) OEIS b-file/comment contributions.

## Codebase Reference

| What | Where |
|------|-------|
| Paper text (extracted) | was at scratchpad `exile.txt` (session-local); re-fetch: combinatorics.org ELJC v27i1p52 |
| Conjecture statements | paper §7 (Conj 22), §8 end (Conj 26, generating functions) |
| Related OEIS | A274641/A274640 (spiral SG/values), A274528/A269526 (quadrant SG), A004482 (col 1), A324774/A324778 (axes) |

## Principles / Constraints

- This is a **side quest** — do not let it displace the queens Node-Kayles threads; user-gated.
- Box discipline applies (tmux, memory hygiene) if runs get big.
- OEIS submissions are the user's call.

## Delegation

- **Can delegate to sub-agent?** Yes — the generator is an isolated, well-specified program.
- **Model**: Sonnet for the generator per spec; Opus for the results note / anomaly analysis.
