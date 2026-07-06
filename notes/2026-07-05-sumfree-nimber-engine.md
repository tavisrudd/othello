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

**Bridge to Codex's outcome discriminator.** Codex found the `p=5`/`p≥7` split is decided by the socle
opening: `{(0,1,0)}` is a *winning* first move at `p=5` but not at `p=7`. As a nimber (the same
currency as the table above):

| p | `𝒢(Z3²×Z_p)` full | `𝒢(Z3²×Z_p` after `{(0,1,0)})` |
|---|-------------------|--------------------------------|
| 5 | ∗2 (N) | **∗0 (P)** — socle opening wins (moves to P) |
| 7 | ∗0 (P) | **∗2 (N)** — socle opening loses (moves to N) |

The full-game and post-socle-opening nimbers *swap* `∗2 ↔ ∗0` between `p=5` and `p=7` — a compact
nimber statement of exactly Codex's discriminator, and a candidate handle for the `p=5` proof.

## The conjecture as a first-move-orbit spectral criterion

`Z3²×Z_p` has exactly **3 first-move orbits** under `Aut = GL(2,3)×Z_p^*`: **socle** `(v,0)`, **coprime**
`(0,k)`, **mixed** `(v,k)`. So `𝒢(root) = mex` of the three orbit-child nimbers, and
`Z3²×Z_p = P ⟺ 𝒢=0 ⟺ 0 ∉ {orbit-child nimbers}`. Engine data:

| `Z3²×Z_p` | socle `{(0,1,0)}` | coprime `{(0,0,1)}` | mixed `{(1,0,1)}` | root `= mex` |
|-----------|-------------------|---------------------|-------------------|--------------|
| **p=5**   | **∗0** | ∗1 | ∗1 | ∗2 (**N**) |
| **p=7**   | ∗2 | ∗2 | ∗2 | ∗0 (**P**) |

**The conjecture `Z3²×Z_p=P` (p≥7) ⟺ "none of the 3 orbit-children is ∗0"** — the exact analogue of
the r₃=1 warm-up's "no singleton is ∗1". And **the `p=5` exception is precisely the socle-child
dropping to `∗0`** (mirroring the r₃=1 story where the order-`p` *singleton* is `∗1` only at `p=5`).
This is the clean handle for Codex's r₃=2 lift.

## Warm-up two-move lemma — confirmed past Codex's compute wall

Codex reduced `𝒢(Z3×Z_p)=∗1` (p≥7) to: `G({p,1}) = G({p,3}) = ∗1` in `Z_{3p}` (the "missing-∗1
spectral gap"). Codex verified `p=7..19`; its brute solver stalled at `p=23`. The fingerprint engine
confirms the invariant **holds through p=29** (`G({p,1})=G({p,3})=∗1` for `p=23, 29`; `--children`
reproduces Codex's child histograms exactly). Large-`p` two-move subgames are expensive (cyclic, no
Grundy cutoff — ~25 min each at `p=29`), so this is the practical ceiling for brute confirmation; the
rest is Codex's spectral-gap proof.

## `{p,3}` branch — two measured NEGATIVES (caution: the clean-mirror story is incomplete there)

Codex's Round-5 unified both two-move branches under one AP-mirror lemma: `T(v)={a,v,2v-a}` with
reflection `ρ(x)=2v-x`, choosing `v=3` for the `{p,3}` branch ⇒ the P-child `{p,3,6-p}` and mirror
`ρ(x)=6-x`. Compute stress-tested this and found two things it does **not** support:

- **`c=6-p` is NOT a uniform P-child.** `G({p,3,6-p}) = ∗0` (P) for `p=11,13,17,19,23` — but **`∗4`
  (NOT P) at `p=29`** (fingerprint engine; the Grundy value is deterministic, and the engine is
  validated exact on 50+ values, so this is not a race/collision artifact). So the "uniform AP-child
  for `{p,3}`" was a `p≤23` coincidence; the base case `p=7` is separately `∗2`. The `{p,3}` branch
  has no single clean P-child representative across `p`.
- **The finite-state mirror certificate fails at `p=11`.** Idea tested: after an exceptional move `y`
  (where `ρ(y)` is illegal), reply with a solver P-reply `z'` that makes the enlarged position
  `{p,3,6-p,y,z'}` invariant under a *new* affine reflection. For **all 7** exceptional moves, **none**
  of the solver's P-replies makes `{T(v),y,z'}` invariant under **any** affine involution of `Z_{3p}`
  (checked all three nontrivial involutions `x↦u·x+t`: `-1`, fix-`Z3`/neg-`Z_p`, neg-`Z3`/fix-`Z_p`).
  So the adaptive replies are genuinely non-mirror — they do not re-establish a reflection. (Scripts:
  `scratchpad/mirrorcert*.py`; P-reply data from `grundy --children`.)

**Reading:** the `{p,3}` branch resists the clean-mirror approach — echoing the earlier "all
mirror/pairing attacks closed" finding, now on the warm-up's harder branch. A proof there needs a
different idea than "AP-child + reflection with a finite exception book." This is exactly the
"verified-then-fails / no clean mirror" evidence that keeps the warm-up an open proof, not a formality.
(The `{p,1}` branch's AP-child `(p+1)/2` was not stress-tested past Codex's `p≤19`; whether *it* stays
uniform is now also worth checking before leaning on it.)

## Files

| file | what |
|------|------|
| `notes/sumfree-go/cmd_grundy/grundy.go` | the nimber engine (self-contained; `GO111MODULE=off go build -o grundy ./cmd_grundy/grundy.go`). Modes: `--start`, `--children` (child-value spectrum), **`--compdump`** (per-child armed-component nimber multiset + XOR — see the 2026-07-06 addendum) |
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

---

## 2026-07-06 (session `--2`, `mi`): compdump microscopy — the missing-∗1 is a *connected-graph* fact, not a decomposition one

**Lane split this session:** Codex (back, Round-6 banner) takes the **∗0-present half** of the two-move
lemma (prove the AP-child `T(v)` is P uniformly in `p`); the compute side (here) takes the **∗1-absent
half** (no child of `{p,1}`/`{p,3}` is ∗1). New tool: `grundy --compdump` — for a start position it
decomposes **every legal child** into armed-Schur components and prints the multiset of component
nimbers (whose XOR is the child's nimber), plus histograms and a count of children whose comp-multiset
contains a ∗1.

**★ Finding 1 (a decisive NEGATIVE): the shallow component-decomposition handle does NOT explain the
missing ∗1.** For `{p,1}` and `{p,3}` at `p ≥ 11`, **every legal child is a single connected component**
— the child-nimber histogram equals the component-nimber histogram exactly (0 children decompose). So
`𝒢(child) = 𝒢(its one component)` with no XOR structure to exploit. The tempting mechanism seen at
`p=7` — where a child like `{7,3}+[8]` splits into `[1:∗1, 4:∗1]` (an isolated vertex ∗1 paired with a
∗1 block) so the two ∗1's XOR to ∗0 — is a **small-`|G|` artifact**: at `p ≥ 11` there are no isolated
vertices and no splits at this depth. (This matches Codex's Round-4 depth-1 connectivity table.) ⇒
**the missing-∗1 cannot be proven by a component/disjunctive-sum argument at the child level; it is a
genuine "mex of a single connected armed-Schur graph never equals 1" fact** — which is the hard core,
and it rules out the decomposition route for this specific half.

- Data (child-nimber histograms, `--compdump`): `{11,3}` `{∗0:7 ∗2:4 ∗4:1 ∗5:6 ∗6:5 ∗7:1}`;
  `{11,1}` `{∗0:5 ∗2:6 ∗5:7 ∗6:6}`; `{13,3}` `{∗0:10 ∗2:7 ∗3:2 ∗5:1 ∗6:2 ∗7:5 ∗8:3}`;
  `{13,1}` `{∗0:7 ∗2:5 ∗3:10 ∗5:1 ∗7:4 ∗8:3}`. In all of these the component-nimber histogram is
  **identical** (single components). **∗1 is the uniquely-reliable absentee** — ∗0 and ∗2 are always
  present, ∗3/∗4 are sometimes absent, but ∗1 is absent in every checked case.

**★ Finding 2 (compute support handed to Codex's ∗0-half): the exceptional-branch replies are NOT a
uniform linear formula.** For the `{p,3,6−p}` AP-child, the ≤7 first-deviations where the mirror
`ρ(x)=6−x` is illegal each have winning 2nd-player replies (P-children of `T∪{y}`), but there is no
single `p`-linear reply that works across `p`. E.g. the constant exception `y=2`:

  | `p` | `T={p,3,6−p}` | winning replies to `y=2` (P-children of `T∪{2}`) |
  |----:|---------------|---------------------------------------------------|
  | 11  | `{11,3,28}`   | `[15]` |
  | 13  | `{13,3,32}`   | `[17, 31, 36, 37]` |
  | 17  | `{17,3,40}`   | `[30, 31, 35]` |

  No common `p`-linear value (`p+4` = 15,17,21 hits at p=11,13 but misses at p=17). This **confirms the
  earlier "genuinely non-mirror" negative** (sessions --5b/--7): the exceptional replies do not restore
  a reflection and are not a lookup formula ⇒ Codex's ∗0-half proof needs a **structural/recursive
  descent** argument for the residue, not a closed-form reply. The full reply sets for the four scaling
  exceptions (`y ∈ {2,4,p+2,p+4}`) at `p=11,13,17` were computed and are reproducible via
  `grundy Z_{3p} --start "p;3;(6−p);y" --children` (read the `moves to *0` line).

**Update (same session): the ∗0-present half is now CLOSED, cleanly.** The AP-child residue turned out to
be the wrong witness — a P-child hunt found `{p,k,−k}` = ∗0 for every non-order-3 `k` (uniform, no book),
a one-liner from the proven Fact C (`{k,−k}` symmetric + order-3 alive ⇒ play `p` → ∗0 by Lemma 4). So
`{p,3,−3}`/`{p,1,−1}` are the exception-free ∗0-children; full proof in
[`2026-07-05-sumfree-warmup-reduction.md`](2026-07-05-sumfree-warmup-reduction.md) §"The ∗0 present half —
CLOSED".

**Bottom line:** the warm-up two-move lemma is now down to its **single** open half — the ∗1-absent half,
which the microscopy above shows is a **single-connected-graph mex fact** (decomposition can't touch it):
"mex of a connected armed-Schur graph is never ∗1, uniform in p." That is the whole remaining crux;
it needs a graph monovariant or the non-mirror adaptive route, not more brute sweeps.

---

## 2026-07-06 (session `--3`, `mi`): the ∗1-absent half — the mirror-break lemma + the pairing route CLOSED

Compute lane owns the ∗1-absent half. This session **maps the obstruction precisely** and **closes the two
most natural elementary routes** with concrete witnesses, redirecting the proof to the non-mirror adaptive
route. All results independently reproduced by a **second, from-scratch nimber solver** (Python,
multiplier-canonical memo) that matches the Go engine's `{11,3}/{11,1}/{13,3}/{13,1}` child histograms
*exactly* — a soundness cross-check (item D). Scripts: `notes/2026-07-06-sumfree-{nim-solver,mirror-break,break-exhaustive,strategy-verify,star1-profile}.py`.

### ★ Finding 1 — the mirror-break lemma (the exact localization of the obstruction)

Frame `𝒢({p,e}) = ∗1` (e ∈ {1,3}) as: **`{p,e} + ∗1` is a P-position** (responder Rita wins). The board
`{p,e}` has a *single mirror defect*: negation `σ(z)=−z` is the only game automorphism, and it sends the
order-3 element `p ↦ 2p` (which is **dead**: `p+p=2p` is blocked), so `σ` fixes no board containing `p`. The
lone unpaired element is `e` (its partner `−e` is absent). The natural responder strategy is *mirror `z↦−z`,
cash the token on the defect*. Its **only** failure points are legal moves `z` whose mirror `−z` is illegal.

> **Lemma (mirror-break).** For any single-defect board `B = {p} ∪ S ∪ {d}` (S = −S symmetric & sum-free
> with `p`; `2p` dead; `d` a non-order-3 defect, `−d ∉ B`), the legal moves `z` with `−z` **illegal** are
> **exactly** the (≤3) legal negations of the three *defect-generated asymmetric blocks*
> > `{ 2d (=d+d),  d+p (defect + live order-3),  d·2⁻¹ (the half h with 2h=d) }`.
> Everything else pairs: `z` legal ⟹ `−z` legal.

**Verified EXHAUSTIVELY** over *all* reachable single-defect boards at `p=7,11,13` (21 / 163 / 436 boards):
**0 mismatches** vs the predicted 3-element set (`break-exhaustive.py`). Mechanism: `S` symmetric ⇒ its blocks
are mirror-matched; `2p` dead ⇒ `p`'s sums `p+s` don't yield breaks; so **only the defect `d` produces
asymmetric blocks, and exactly these three.** At `B={p,e}` the three breaks are `z ∈ {−2e, −(e+p), −e·2⁻¹}`
(e.g. `{11,3}`: `z=27,19,15`; `{11,1}`: `z=31,21,16`) — uniform in `p`.

This is the sharpest statement to date of *why* the ∗1-absent half resists elementary methods: the obstruction
is **three defect-blocks**, no more, no fewer.

### ★ Finding 2 — the single-token pairing/mirror strategy is CLOSED (definitive negative, two witnesses)

An explicit responder policy (mirror `−m`; on a break-move migrate the defect via `−d`; cash the token via
the proven Fact C) was coded and **exhaustively minimax-verified** against all Alice lines
(`strategy-verify.py`). **It FAILS at every `p=7,11,13,17`**, for two independent reasons — either is fatal:

1. **The negation-mirror reply does not preserve value.** From `{3,7}=∗1` (Z21), Alice plays `1`, Rita
   "mirrors" `−1=20` → `{1,3,7,20}` which is **`∗3`, not `∗1`** (both solvers). Because `σ` is not an
   automorphism of a `p`-board, `m ↦ −m` is **not** a value-preserving pairing — the whole fixed-mirror
   family is unsound here. (Contrast Fact C, which is a genuine one-move-then-mirror backed by Lemma 4 on a
   *symmetric* remainder with `2p` permanently dead.)
2. **A single break-move double-blocks both replies.** Even granting the mirror, at `{1,3,7,20}` Alice plays
   `m=9`: the mirror reply `−9=12` is illegal (`3+9=12`) **and** the migrate reply `−d=−3=18` is illegal
   (`9+9=18`). One token cannot cover two simultaneously-destroyed options. This is the exact, concrete form
   of the warmup note's "destructible resource" lead-2.

**⇒ `𝒢({p,e})=∗1` holds but is NOT provable by any fixed single-token pairing/mirror strategy on `{p,e}+∗1`.**
The position is a Rita win only via **adaptive** play (Rita's correct reply to Alice's `1` is *not* the mirror
— she needs `G({1,3,7})`-dependent adaptive choice). This is the non-mirror adaptive route (à la the `Z3²×Z7`
reverse-engineering) — the sole surviving avenue for this half.

### ★ Finding 3 — the ∗1-class is structurally diverse (rules out a naive signature monovariant)

Enumerating all reachable canonical positions (`star1-profile.py`): ∗1 is **~40%** of positions (Z21: 91/247,
Z33: 2038/5920, Z39: 9706/27293) and spans every structural signature — symmetric & not, order-3 alive &
dead, defect sizes 0–10. So there is **no simple "∗1 has structural feature X" characterization** for a
children-of-`{p,e}` avoid-X argument. (The only clean ∗1 sub-class is *symmetric + order-3-alive + defect 0*,
which children of `{p,e}` — never symmetric — trivially avoid, but it's a vanishing fraction.) A monovariant, if
one exists, must be a genuine mex/recursion invariant, not a static board feature.

**Bottom line (compute lane):** the ∗1-absent half is localized to the **three defect-blocks** (Finding 1),
the **fixed-pairing route is dead** (Finding 2), and a **static-signature monovariant is ruled out**
(Finding 3). The remaining avenue is the **non-mirror adaptive strategy** — Rita's winning reply to a defect-
or break-move is `G`-dependent, not a formula. Handed to Codex's proof lane (banner updated). No more brute
sweeps.

**Convergence with Codex (same day, independent).** Codex's `codex-findings-sumfree.md` reaches the identical
wall from a complementary frame — the **colored-fiber reformulation** `Z_{3p} ≅ F_p × F_3`: once `p` is placed
each nonzero `F_p`-fiber holds ≤1 element, and the residual game is building a colored set `f: S⊂F_p^* → F_3`
forbidding colored Schur equations in both coordinates. That "≤1 per fiber" fact **is Finding 1's `d+p`
defect-block** (`x±p` illegal), and the full three-block set `{2d, d+p, d·2⁻¹}` is exactly the colored-Schur
constraint pair in Codex's frame. Codex's independent "Reply-Formula Mining" (185 non-P children, p=11–19:
mate replies hit ∗1 in only 130/185; no uniform affine witness) corroborates that the winning reply is
**adaptive, not a formula** — matching Finding 2. Both lanes now agree the proof needs a **monovariant on the
two-defect colored Schur graph**, and Finding 3 sharpens it: not a static board feature, a mex/recursion invariant.
