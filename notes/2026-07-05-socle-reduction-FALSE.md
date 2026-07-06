# The socle reduction is FALSE — `Z3²×Z7 = P` (counterexample)

**Date:** 2026-07-05 (session `2bf7abb3`, `mi`). **Status: confirmed by two independent sound solvers.**

## Headline

**`𝒢(Z3²×Z7) = P` (second player wins).** This **falsifies the socle reduction**
`𝒢(G)=𝒢(G[6])` and its sharpening **"odd `G` with 3-torsion ⟹ N"**:

- `Z3²×Z7` is odd (`|G|=63`) and has 3-torsion (socle `Z3²`), so the conjecture predicts **N**.
- Its `{2,3}`-part is `G[6]=Z3²`, and `𝒢(Z3²)=N`, so the reduction also predicts **N**.
- The game is **P**. The coprime factor's *size* flips the outcome even though `G[6]` is identical:
  `Z3²×Z5=N` but `Z3²×Z7=P`.

So the "sole open piece" the handoff rested on is not just open — the specific conjectured form is
**wrong**. The finite-abelian classification is **not** nearly complete; the open slice
(`s₂≤1, r₃≥2`) is genuinely non-uniform in the coprime part.

## Evidence (three independent lines, all agree)

1. **New Go solver** (`notes/sumfree-go/sumfree.go`) — full-`Aut(G)` canonical negamax,
   `|Aut(Z3²×Z7)|=288`: `OUTCOME=P`, 0 winning openings, 836,807 nodes, ~25 s.
2. **Existing Python sound solver** (`sumfree_solver.py`, different codebase, `canon=coordinate-subgroup`,
   `|group|=48`): `OUTCOME=P (player to move loses)`, 5,237,522 nodes, 257 s.
   Two *different* sound canonicalizations agreeing ⇒ the outcome is canon-independent ⇒ sound.
3. **The book-miner crash** (`strategy_book_miner.py` generalized to p=7 this session) died with
   *"no winning move in N-position"* — the sound oracle itself finding a hero-loss on the forced
   `(0,1,0)` line. Exactly what a P outcome produces (the opening loses).

## Why it was missed

`2026-07-05-socle-book-scaling.py` **never solved the outcome.** Its `book(mods)` starts from
`{socle opening o}` and only counts the *heuristic* strategy's local fails (bulk-fail / socle-fail).
Its "`socle-fail=1, constant in p`" for `Z3²×Z5,Z7,Z11` was read as "uniformly N with a residue of 1,"
but it was really "the heuristic gets stuck once" — the actual **outcome of `Z3²×Z7` was never checked
with a sound solver** until now. The book-residue note's table row `Z3²×Z7 | fails by 1` is therefore
about a heuristic, not the true outcome (which is P).

## The new Go solver (deliverable)

`notes/sumfree-go/sumfree.go` — a single-file, dependency-free solver for the sum-free achievement game
on any finite abelian `G = Z_{m1}×…×Z_{mk}`. Negamax + transposition table keyed by the canonical form
under the **full** automorphism group `Aut(G)=GL(k,3)×∏(unit groups)`, generated from
transvection/scaling/multiplier/coordinate-swap generators and closed by BFS. Canonicalization is sound
(genuine automorphisms only) and complete (full `Aut`). Hot loops inlined (no closures). `go build` is
memory-light (~200 MB compile — safe alongside the G(17) queens run; no rustc/LLVM OOM risk).

```
go build -o sumfree ./sumfree.go
./sumfree 3,3,7            # outcome + one winning move
./sumfree 3,3,7 --openings # all winning first moves
./sumfree 3,3,7 --start 0,1,0
```

**Validated** against every case with a known answer:
- all cyclic `Z_n` match the mod-6 theorem (P iff `n≡0,1,5`; checked `n=2..13`);
- `Z3²×Z5=N` with **exactly the 8 socle openings** (exact match to the established result);
- `Z3³=N`, `Z2×Z3²=P`, `Z3²=N`;
- `r₃=1` coprime peels `Z3×Z5/Z7/Z11/Z13` all `N` (matches the proven `r₃≤1⟹N`).

## Outcome data (r₃=2 coprime peels `Z3²×Z_p`, p prime ≠3)

| p | `Z3²×Z_p` | notes |
|---|-----------|-------|
| 5 | **N** | 8 winning openings, all socle (known) |
| 7 | **P** | **counterexample** — 0 winning openings, confirmed ×2 |
| 11 | *(running)* | grinding = large P-tree (no cutoff), likely P |
| 13 | *(running)* | grinding, likely P |

N-cases end at the first winning opening (fast); P-cases must exhaust the whole canonical tree
(no boolean cutoff). p=11,13 not terminating quickly is consistent with P but not proof — pending.

## What survives / what dies

- **Survives (direct theorems, re-confirmed by the solver):** `F3ⁿ=N`, `Z2×F3ᵇ=P`, `s₂≥2⟹P`,
  the `s₂=1` reduction, and `r₃≤1⟹N` (`Z3×Z_p`).
- **Dies:** the **socle reduction** `𝒢(G)=𝒢(G[6])` and **"odd `G` w/ 3-torsion ⟹ N"**. The whole
  book-route program (`socle-book-*`, `strategy_book_miner`) is moot for the coprime peel — the peel
  is not outcome-neutral.

## `Z3²×Z7=P` is a NON-PAIRING (adaptive) P-position

The 2nd-player win is **not** a static mirror. A pairing verifier (`sumfree_par --pairing`, cheap:
explores only `π`-symmetric positions) checked, for `π =` negation-on-bulk + *every* fixed-point-free
involution of the 8 socle elements (60 candidates, negation-pairs `{a,-a}` excluded as non-sum-free):
**0/60 verify for every `p` including `p=7`.** Since `|Z3²×Z7|` is odd there is also no order-2 element
⇒ no translation mirror. So neither of the two mirrors that prove every other known abelian P case
applies — the win is genuinely adaptive (echoes the "socle reduction is not a mirror" findings, now on
the 2nd-player side). Verifier validated: it certifies the negation mirror for `Z5/Z7/Z25` (P), finds
none for `Z3` (N), and finds no *negation* pairing for `Z2×Z3²` (which wins by *translation*).

## Parallel solver (also delivered)

`notes/sumfree-go/cmd_par/sumfree_par.go` — shared **sharded-TT** + bounded worker pool, forks the
shallow plies, early-cancels on N. ~5× the sequential solver (p=7: 25s→4.9s on 20 cores), validated
identical (p=5→N/8 openings, p=7→P). Also hosts the `--pairing` verifier above. **But P-proofs explode
super-linearly** and do not shrink with cores (same node set): `Z3²×Z11` blew past **100M canonical
nodes / 8 GB without converging** and had to be killed to protect the box. So brute-forcing the outcome
is infeasible past `p=7` here.

## The real open question + leading conjecture

**Conjecture: `Z3²×Z_p = N` iff `p=5` (prime `p≠3`); `P` for all `p≥7`.** Evidence: `p=5→N` and
`p=7→P` are rigorous (both solvers). `p=11` explored 100M+ canonical nodes with **no winning opening
found** before being killed (an N would cut off at the first winning opening — `p=5`'s winning line was
only ~8.7K nodes — so `p=11` is P with very high confidence, not yet a completed proof). This is **not**
a `p mod 3` split: `p=5≡2` (N) but `p=11≡2` (P). So `p=5` looks sporadic.

Routes to settle it (brute is out):
1. **Extract + characterize the adaptive 2nd-player strategy** for `Z3²×Z7` (the method that cracked
   `F3ⁿ` and `Z2×F3ᵇ`) and generalize to `p≥7` — the win is adaptive, so look for an invariant, not a
   pairing.
2. **A more compact solver** (2-word masks for `|G|≤128`, value-only archive) to push a couple more `p`.
3. **Explain why `p=5` is the exception** (max sum-free set parity? a small-`|G|` accident?).

The classification's frontier moved from "prove the socle reduction" to "prove `Z3²×Z_p=P` for `p≥7`
(adaptive, non-mirror) and explain the `p=5` exception."
