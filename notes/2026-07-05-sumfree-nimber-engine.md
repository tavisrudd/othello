# Sum-free game: the decomposition nimber engine + nimber data

**Date:** 2026-07-05 (session `c5c3bf7d`, `mi`, compute side parallel to Codex).
Companion to [`2026-07-05-socle-reduction-FALSE.md`](2026-07-05-socle-reduction-FALSE.md) and the
compute handoff [`handoffs/2026-07-05-sumfree-compute-parallel-codex.md`](handoffs/2026-07-05-sumfree-compute-parallel-codex.md).

## Headline

A **Grundy/nimber solver via disjunctive-sum component decomposition**
(`notes/sumfree-go/cmd_grundy/grundy.go`) solves cases the brute solvers cannot — including
**`Z3²×Z7 = ∗0` (P)** in ~30 s, which Codex's Python Grundy solver could not finish and the boolean Go
solver only reached with no cutoff. It computes the **exact Grundy value** (strictly richer than
win/loss) across the whole abelian family, unblocking Codex's "Attack 2" nimber-law program.

## Why decomposition works here (unlike the queens analogue)

The sum-free game is a **disjunctive game**: at position `A` the residual game splits over the
connected components of the *armed Schur interaction hypergraph* on the legal moves `U`, and
`𝒢(A) = XOR over components` (proven identity, `2026-07-04-sumfree-game-theorem` §Remarks: "verified 0
mismatches / ~70k positions"). The queens component-nimber lever died because tail graphs stayed
single-component; here a **decomposition-frequency probe** (`cmd_probe/decomp.go`, on the fully
solvable `Z3²×Z7`) shows the opposite:

| depth pc | nodes | decomp % (≥2 comps) | mean #comps | mean max-comp size |
|---------:|------:|--------------------:|------------:|-------------------:|
| 9  | 146,007 | 82.6 | 4.84 | 5.4 |
| 10 | 160,578 | 91.0 | 5.77 | 3.7 |
| 11 | 144,015 | 95.3 | 6.14 | 2.9 |
| 12 | 106,075 | 97.4 | 6.32 | 2.3 |
| 13 |  67,206 | 98.6 | 5.86 | 1.9 |

**84% of all nodes decompose; 82–99% in the deep tail**, into 5–6 tiny components (max size → 2–3).
So the engine memoizes **components** (canonical armed hypergraph under `Aut(G)`), not whole positions —
the component of a small armed hypergraph recurs across vastly more positions than any full set does,
which collapses the P-proof tree that has no boolean cutoff.

## Engine design

- **Interaction/link rule.** Legal moves `x,y` are linked iff a Schur triple relates them with its
  third element *live* (in `A∪U`): `x+y`, `x−y`, or `y−x ∈ A∪U`. A triple whose third element is
  neither placed nor playable can never be completed ⇒ imposes no future constraint ⇒ no edge.
- **Recursion.** `sub(A, C)`: `U = C ∩ legal(A)`; if `U` splits into components, return `XOR sub(A,Cᵢ)`;
  else `mex over x∈U of sub(A∪{x}, U∖{x})`. Well-founded (`U` shrinks); disjunctive-sum-correct because
  no cross-component Schur triple exists (no crossing edge ⇒ a move in one component never changes
  another's legality nor creates a crossing sum).
- **Memo key = canonical armed hypergraph.** For a single component `U`, key = joint lex-min over
  `Aut(G)` of the pair `(U, A_rel)`, where `A_rel = A ∩ {x±y : x,y∈U}` is the *only* part of `A` that
  arms the subgame. Sound (genuine automorphisms only); two subgames with `Aut`-isomorphic armed
  hypergraphs share a memo entry.
- **Small-component fast path.** size-1 component ⇒ `∗1` (a lone move is a Nim-heap of 1); size-2
  connected ⇒ single conflict edge ⇒ `mex{0,0}=∗1`. Both skip canonicalization (−34% wall on `Z3²×Z7`;
  memo/node counts unchanged — the tail is size-1/2-dominated and these were memo hits paying armedKey).
- **Measured-NEGATIVE (`GRUNDY_NOMULT`, kept gated):** dropping the `Z_p`-multiplier autos from the
  canonicalization (sound — a subgroup only merges fewer) is **+6× nodes / +2.6× wall** on `Z3²×Z7`.
  The multiplier merging is worth far more than its per-node canonicalization cost; full `Aut` is right.
  So the per-node cost scales as `|Aut| ∝ p` and *that* is the wall for large `p`, not memory (flat).

## Validation (all pass — 50+ independent checks)

- **Codex's independent Python Grundy table — exact match on every value:** `Z2=1 Z3=1 Z5=0 Z7=0 Z9=1
  Z10=1 Z14=2 Z2×Z3=0 Z3²=1 Z3×Z5=2 Z3×Z7=1 Z3×Z11=1 Z3×Z13=1 Z3²×Z5=2`.
- **Cyclic mod-6 nimber sequence `n=2..31`** — every value matches the OEIS-draft sequence, incl. the
  nontrivial nimbers `𝒢(16)=3, 𝒢(22)=3, 𝒢(8)=𝒢(14)=𝒢(20)=𝒢(26)=2`. Outcome `∗0 ⟺ n≡0,1,5 (mod 6)`.
- **Theorem groups:** `F3³=N (∗1)`, `Z2×F3²=P (∗0)`, `Z2×Z3×Z5=P`, `Z4²=P`, `Z2²=P`.

## Nimber data (the deliverable — Codex's Attack 2)

The **exact Grundy values** across the coprime-peel families (the win/loss view cannot see these):

| p                    | 5 | 7 | 11 | 13 | 17 | 19 |
|----------------------|---|---|----|----|----|----|
| `𝒢(Z3×Z_p)`  (r₃=1)  | **2** | 1 | 1 | 1 | 1 | 1 |
| `𝒢(Z3²×Z_p)` (r₃=2)  | **2** | **0 (P)** | *running* | *running* | *running* | — |

**Findings:**
1. **`𝒢(Z3×Z_p) = ∗1` for every prime `p≥7`, `= ∗2` at `p=5`** (verified `p=7..19`). Every group here is
   N (outcome-known from `r₃≤1⟹N`), so this is a **nimber law refining a known-outcome family** — the
   value cleanly isolates `p=5`.
2. **`p=5` carries `∗2` in BOTH families.** So the "`p=5` is sporadic" phenomenon is not an outcome
   accident; `p=5` is a *nimber constant* `∗2` — a `Z5`-specific structural fact to be explained.
3. **`Z3²×Z7 = ∗0` (P)** confirmed a third independent way (now with the exact nimber, not just P/L).

## Files

| file | what |
|------|------|
| `notes/sumfree-go/cmd_grundy/grundy.go` | the nimber engine (self-contained; `GO111MODULE=off go build -o grundy ./cmd_grundy/grundy.go`) |
| `notes/sumfree-go/cmd_probe/decomp.go`  | decomposition-frequency probe (`go build -o probe ./cmd_probe/decomp.go`) |

Both are standalone `main` packages copying the stable group machinery from `../sumfree.go`; neither
touches the shared solver files Codex uses.

## Next

- Land `Z3²×Z11/13/17` (running) to fill the r₃=2 row and test whether it is `2,0,0,0,…` (mirroring the
  r₃=1 drop `2,1,1,1,…`). If so, a clean two-family nimber picture for Codex to prove.
- Extend to `Z3²×Z_{p²}` (`Z25`), `Z3³×Z_p` (r₃=3, but `|Aut|=|GL(3,3)|·(p−1)` is expensive), and
  `Z9×Z3×Z_p`.
- Codex proves: `𝒢(Z3×Z_p)=∗1` (p≥7), `Z3²×Z_p=P` (p≥7) via the component structure, and the `p=5 ∗2`
  cause. See the Round-4 banner in `2026-07-05-codex-assignment-sumfree-socle.md`.
