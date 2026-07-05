# Research assignment (for Codex): the sum-free achievement game on `Z₂ × F₃ᵇ`, and the socle reduction

> **STATUS UPDATE 2026-07-05 — the PRIMARY target is CLOSED.** `Z₂×F₃ᵇ = P` for all `b≥1` is **PROVEN**
> (ChatGPT's σ-mirror: reply `p=(0,a)`, mirror through `k=m+p` via `σ(ε,v)=(1−ε,a−v)` — fixed-point-free
> because it flips `Z₂`, char-3 label-flip repairs the affine defect, `k=m+p` self-blocks). Exhaustively
> verified `b≤3`, dimension-uniform proof for all `b`:
> [`2026-07-05-sumfree-zmf3b-theorem.md`](2026-07-05-sumfree-zmf3b-theorem.md). **The `#4` hyperplane
> induction (§4 below) is no longer needed — superseded.** Both socle endpoints (`F₃ⁿ=N`,
> `Z₂×F₃ᵇ=P`) are now theorems, so **the SOCLE REDUCTION (§2 SECONDARY, and Task 4) is the sole
> remaining open piece of the whole abelian classification — it is now Codex's PRIMARY target.**
>
> **Also do first: the sound solver.** A root-transitivity bug was found — the existing
> `2026-07-05-sumfree-fast.py` reduces under the full `Aut(G)`, which is only valid when `Aut(G)` is
> transitive on legal first moves (true for pure `F₃ⁿ`, **false for `Z₈`, `Z₁₀`, and `Z₂×F₃ᵇ`**, giving
> wrong outcomes there). Build the corrected solver (orbit reps only where a transitivity proof or an
> actual orbit computation justifies it), re-validate the mod-6 law + the two proven socle theorems,
> then use it as the oracle for the socle-reduction attack below.

**Written:** 2026-07-05. Self-contained — you need no other context. Companion notes (read if useful,
but this file is complete): `notes/2026-07-05-sumfree-abelian-theorem.md` (all proofs + data) and its
banked scripts `notes/2026-07-05-sumfree-*.py`. **Do not modify the git repo's source; work in a
scratch dir and add new scripts under `notes/` only.**

---

## ★ SOCLE REDUCTION — FIVE PARALLEL ATTACKS (2026-07-05, current focus)

**Established negative (do NOT re-try): the mirror method does not extend past elementary 3-groups.**
`Z9×Z3=N` is provably *not* a pairing/mirror position (winning first moves = exactly the socle
order-3 elements; on-socle play = the `F₃²` reflection `σ(y)=−o−y`; on order-9 moves **no** consistent
reply-mirror exists — `σ`, `−y`, and every adaptive combination fail). ChatGPT's `σ`-mirror fails on
`Z₂×(Z9×Z3)` for **every** center `a`. So the two proven socle *endpoints* (`F₃ⁿ=N`, `Z₂×F₃ᵇ=P`) are
char-3-pure phenomena; the socle *reduction* (elementary ← general) is a **separate, non-mirror
problem** — see [`2026-07-05-socle-reduction-not-a-mirror.md`](2026-07-05-socle-reduction-not-a-mirror.md).
Pursue the five attacks below **in parallel**; they are independent. **The needed statement:** for the
open slice `s₂≤1 ∧ r₃≥2`, the non-socle parts (coprime, higher 2-/3-power) are **outcome-neutral**.

**Attack 1 — Atomize the reduction; locate the hard core (foundational).** The full reduction iterates
three atomic peels: `P_cop(p)`: `outcome(H×Z_p)=outcome(H)`, `p≥5` prime; `P_2(k)`:
`outcome(H×Z_{2ᵏ})=outcome(H×Z_{2ᵏ⁻¹})`; `P_3(k)`: `outcome(H×Z_{3ᵏ})=outcome(H×Z_{3ᵏ⁻¹})`. With the
sound solver, verify each peel over many `H` (include `r₃≥2`, mixed parity) **and record, per peel,
whether it admits a matched involution** (e.g. `ρ` = negate-the-new-factor works for `P_cop` iff `H`
has no 3-torsion). Deliverable: a table (peel × H-class → holds? / mirror-able?) that pins exactly
which peels need a genuinely new argument (conjecture: precisely those where `H` has 3-torsion — the
coupling Codex already found via `a+y=ρ(y)`, `a=(ρ−1)y`).

**Attack 2 — Full nimber law under peeling (high-payoff structural).** It is not a nimber identity
(`𝒢(Z14)=∗2` vs `𝒢(Z2)=∗1`), but compute the **full Grundy value** `𝒢` for `G`, `G[6]`, and the
intermediate peels across many groups, and hunt for a **regular law**: is `𝒢(H×Z_p)` a function of
`𝒢(H)` and `p`? Is the nim-difference `𝒢(H×Z_p) ⊖ 𝒢(H)` constant/periodic in `p`? Does `𝒢` stay in a
bounded set once `(s₂,r₃)` is fixed? A clean nimber law would **prove the outcome identity as a
corollary** and is strictly stronger. Deliverable: nimber tables + any conjectured `𝒢(G) ↔ 𝒢(G[6])`
law.

**Attack 3 — Quotient game-morphism `outcome(G)=outcome(G/K)` (structural/inductive).** Rather than
peel a direct factor, quotient by a characteristic subgroup `K` inside the non-socle part (candidates:
`K=6G`, the top layer of a `p`-power, a Frattini-type subgroup). Probe `outcome(G)` vs `outcome(G/K)`
for each candidate `K`; find one where they always agree, then check whether the quotient map
`q:G→G/K` is a **game morphism** (legal sum-free moves lift/descend, giving a strategy correspondence).
A working `K` yields an induction on `|G|`. Deliverable: which `K` preserve the outcome; whether the
induced correspondence is sound.

**Attack 4 — Bounded-local-repair strategy for one hard coprime peel (the σ-lesson, applied
non-globally).** The σ-lesson was *don't* fix the obstruction with a global involution — spend a
bounded detour. On `H×Z_p` (take `H=Z3²`, so `Z3²×Z5=N` — the smallest genuinely-open coprime peel),
search for an explicit first-player strategy: run the `F₃²` socle strategy on `H×{0}`, pair the
coprime/mixed elements, and insert a **bounded local repair** exactly at the `a+y=ρ(y)` blocker
positions. Use `verify_strategy.py` to test candidate detour rules over all lines. An explicit verified
strategy for even this one peel would be the first non-mirror socle-reduction proof. Deliverable: a
verified strategy for `Z3²×Z5`, or the precise obstruction that blocks every bounded repair.

**Attack 5 — LMSF terminal-parity invariant (the "different invariant" route).** Game length =
`|final locally-maximal sum-free set|`; first player wins iff it can force an **odd-size** maximal set.
Compute the LMSF **size distributions** of the open-slice groups vs their socles and look for a
size-parity correspondence (a bijection `LMSF(G)↔LMSF(G[6])` preserving size mod 2, or a proof the
achievable-parity sets match). If maximal-set parity structure is preserved by peeling, that routes to
the outcome identity with no strategy at all. Deliverable: LMSF size/parity tables + any correspondence.

**Report** into `notes/2026-07-05-codex-findings-sumfree.md` (append a socle-reduction section): per
attack, what the data shows, any proof or precise obstruction, and verified-vs-inferred. A clean
"Attack 1 table + Attack 2 nimber law conjecture + Attack 4 verified `Z3²×Z5` strategy" would be an
excellent round.

### ★ ROUND-2 UPDATE (2026-07-05): target sharpened, Attack 4 closed NEGATIVE, two bets left

**Sharpened target — the whole open problem is one statement.** `s₂≥2` is done (translation `τ_v`,
any 3-structure), `s₂=1` rides `τ_m` to `{m}` N, `s₂=0,τ₃=0` is negation. So the entire socle
reduction + open classification slice reduces to:
> **`odd G with 3-torsion ⟹ N`** (⊇ `F₃ⁿ=N`), plus the `s₂=1` non-elementary `{m}` N.
Attack this directly — it subsumes the reduction.

**Attack 4 (mirror + local repair) is CLOSED — negative.** The coprime peel is not a
mirror/fibered/projection strategy even for elementary `H`: global `σ_G`, combined, ALL structured
single involutions `(σ_H`/`−h, c−i)` incl. order-15 openings, and the fibered "`H`-projection = `σ_H`,
`Z_p` free" all FAIL (`2026-07-05-socle-reduction-not-a-mirror.md`, Attack-4 section). **The wall:**
`base + off-base = off-base` couples the parts, so nothing separates them; and the socle is not a
direct summand when the 3-part is non-elementary (`Z9×Z3` has no retraction onto its socle). The win
is genuinely adaptive. **Stop hunting for a succinct mirror.**

**Two live bets (both structural, non-mirror):**
- **Attack 3-refined — a *twisted* game morphism.** The naive `G→G/6G` projection fails (sends
  sum-free → non-sum-free). Look for a non-obvious position-correspondence between `G` and `G[6]`
  (e.g. map a `G`-position to a socle-position via its 3-torsion "shadow" + a repair), or a
  strategy-lifting that survives the base/off-base coupling. Even a *conjectured* correspondence
  verified on `Z9×Z3`, `Z5×Z3²` would be progress.
- **Attack 6 (new) — bounded search for a succinct adaptive strategy.** Since the win is adaptive,
  ask whether it is *succinctly* adaptive: e.g. is there a small "state" (a few bits beyond the socle
  σ-position) that determines the reply? Extract the solver's `Z9×Z3` and `Z5×Z3²` strategies fully
  and look for a low-complexity decision rule (socle σ + a bounded rule on the non-socle layers). If
  the strategy has no succinct form, that is itself a publishable structural fact (the reduction cases
  are "essentially search," unlike the one-line socle theorems).

If neither yields, the defensible published position stands on its own: **classification proven for
`r₃≤1` and `s₂≥2`, both socle endpoints (`F₃ⁿ=N`, `Z₂×F₃ᵇ=P`) as theorems, `r₃≥2` slice as a
solver-verified conjecture reduced to "odd `G` with 3-torsion ⟹ N".**

---

## 0. The game (precise definition)

Fix a finite abelian group `G` (written additively). Two players alternately build a subset
`A ⊆ G`, starting from `A = ∅`. A legal move adds an element `x ∉ A` such that `A ∪ {x}` is
**sum-free**: it contains **no** solution of `a + b = c` with `a, b, c ∈ A ∪ {x}` — and `a = b` is
allowed, so `2a = c` is also forbidden. **Normal play**: the player who cannot move (i.e. `A` is an
inclusion-maximal sum-free set) loses. Note `0` is never playable (`0 + 0 = 0`), so the game lives on
`G \ {0}`.

Let `𝒢(G)` be the Sprague–Grundy value of the start `∅`. **Outcome:** the game is a **second-player
win ("P")** iff `𝒢(G) = 0`, else a **first-player win ("N")**. For OUTCOME you only need win/loss:
`win(A) = TRUE` iff some legal move `x` gives `not win(A ∪ {x})`; `∅` is N iff `win(∅)`.

This game is impartial Node-Kayles on the Schur 3-uniform hypergraph of `G` (Sieben's building-avoid
game `AVD`). It is **novel** as an arithmetic instance — no outcome/Grundy result for it is published,
and OEIS has nothing. Prior-art verdict (verified): **strategy-stealing is INVALID here** (adding an
element removes future moves ⇒ monotonicity fails), so N-results require an *explicit* first-player
strategy, not a stealing argument.

---

## 1. What is already PROVEN (do not redo — use these as tools)

Let `s₂ = ` 2-rank of `G` (`= dim_{F₂} G[2]`), `r₃ = ` 3-rank (`= dim_{F₃} G[3]`), `τ₃ = [r₃ ≥ 1]`.

- **(Criterion, target of the whole program).** `𝒢(G) = 0` (P) **iff** `s₂ ≥ 2`, **or** (`s₂ ≤ 1` and
  `s₂ = τ₃`). Cyclic case = the proven mod-6 law: `𝒢(Z_n)=0 iff n ≡ 0,1,5 (mod 6)` for `n ≥ 5`.
- **`s₂ ≥ 2 ⟹ P`** — PROVEN. Second player: to opening `x`, pick an order-2 `v ≠ x` (exists since
  `|G[2]\{0}| = 2^{s₂}−1 ≥ 3`), reply `x+v`, then translation-mirror `y ↦ y+v` (`τ_v`; it is
  fixed-point-free since `2v=0`, sum-clean by the cyclic Lemma 2, and immune to 3-torsion).
- **`r₃ ≤ 1 ⟹` the criterion** — PROVEN (cyclic Lemmas 1–4 lift verbatim; exactly one order-3 pair).
- **`s₂ = 1` reduction** — PROVEN. Let `m` = the unique order-2 element. `τ_m` handles every opening
  `x ≠ m`; hence **`∅` is P ⟺ `{m}` is N** (the mover wins from the singleton `{m}`).
- **★ `F₃ⁿ = (Z/3)ⁿ` is N for all `n`** — PROVEN (this year's key result). First player opens any
  center `o ≠ 0`; then answers each opponent move `y` with the **affine point-reflection**
  `σ(y) = −o − y` (`σ` fixes only `o`, `σ² = id`). Lemma (proved + machine-checked 0 violations,
  exhaustive `n≤3`, 1.39M sampled `n=4`): the σ-mirror is sum-clean on `F₃ⁿ`. Every new violation
  reduces to a violation of `A∪{y}`; e.g. if `σy = p+q` (`p,q∈A`) then `y+p = σq ∈ A`; the sub-case
  `2y = σy` forces `3y = 0 ⟹ o = 0` — **char 3 is essential** (this is why σ fails off pure `F₃ⁿ`).
- **★ Socle reduction (CONJECTURE, solver-verified 0 mismatches on general `G`).**
  `𝒢(G) = 0 ⟺ 𝒢(G[6]) = 0`, where `G[6] = {x : 6x = 0} = (Z₂)^{s₂} × (Z₃)^{r₃}` is the socle. I.e.
  **the outcome depends only on `(s₂, r₃)`** — the 6′-part and higher 2-/3-power parts are
  outcome-irrelevant. It is an OUTCOME identity, **not** a nimber identity (`𝒢(Z14)=∗2` but
  `𝒢(Z2)=∗1`), so it is NOT a disjunctive sum.

**Consequence:** with `s₂≥2⟹P`, `r₃≤1`, and `F₃ⁿ=N`, the entire criterion is proven **except** the two
items in §2 below.

---

## 2. THE OPEN PROBLEMS (your targets)

### PRIMARY — `Z₂ × (Z/3)ᵇ = P` for `b ≥ 2`

Equivalently (by the proven `s₂=1` reduction): **`{m}` is an N-position** in `Z₂ × F₃ᵇ`, where
`m = (1, 0)` is the unique order-2 element. Solver-verified P for `b ≤ 3`. This is the last piece of
the `s₂=1` socle family. The `Z₂` factor *flips* the 3-group outcome: `F₃ᵇ = N` but `Z₂×F₃ᵇ = P`.

### SECONDARY — prove the socle reduction

`𝒢(G) = 0 ⟺ 𝒢(G[6]) = 0`. Its two endpoints (`F₃ⁿ=N`, `s₂≥2=P`) are now theorems, but the reduction
itself is open. The natural route (peel one coprime/higher-power factor: `𝒢(H × Z_m) = 𝒢(H)` for
`gcd(m,6)=1`) hits an interference wall — the non-socle elements are all negation-clean, but pairing
them interferes with the socle strategy. Lower priority than the PRIMARY.

---

## 3. What has been TRIED and FAILS (do not repeat)

For `Z₂×F₃ᵇ`, **every single-involution "mover-mirror" from `{m}` fails for `b ≥ 2`** (all
machine-checked; see `notes/2026-07-05-sumfree-zm-mover.py`):

- **negation on H** `(ε,h) ↦ (ε,−h)` — O₃ doubling on the `(0,·)` coset.
- **glide** `γ(ε,h) = (ε+1, −h)` — `γy + γy = y` doubling on the `(0,·)` coset.
- **ψ**: `(0,h)↦(0,2o−h)`, `(1,h)↦(1,−h)` (fixes `m` and a played center) — m-coset O₃ doubling.
- **affine reflection on V** `ρ(ε,v) = (ε,−o−v)` (center `o≠0`) — moves `m` (its V-part `0 ↦ 2o`),
  and `(0,2o) ↦ 0` (unplayable) because no center is *played* to self-block it.
- **e-coord negation** `μ(ε,h,v_e)=(ε,h,−v_e)` — an automorphism ⇒ O₃ doubling on the `⟨e⟩`-axis.
- **negation-pairing with labels**: answering opponent `(0,v)` on `−v` fails both ways
  (`(0,v)+(0,v)=(0,−v)` doubling, or `(0,v)+(1,−v)=m`).

**The structural barrier (pin this down, don't fight it):** to keep `m` symmetric you need an
origin-centered `V`-automorphism (= negation), which carries the O₃ doubling; any **off-origin affine
center** (which *dodges* O₃ via char 3, exactly like the `F₃ⁿ` proof) **moves `m`**. So there is **no
single fixed-point-free (or 1–2-fixed-point) involution** that both fixes `m` and reflects `V`
cleanly. `{m}` N for `r₃≥2` is therefore **not** a pairing/P-mirror position — it needs an active,
multi-part (non-involution) strategy.

---

## 4. THE LEAD to pursue — hyperplane induction on `b` (attack #4)

Prove `Z₂×F₃ᵇ = P` (equivalently `{m}` N) by induction on `b`, decomposing `V = F₃ᵇ`.

Write `V = H ⊕ ⟨e⟩` with `H = F₃^{b−1}` and `e` a basis vector. Then `G = Z₂ × V` splits into three
**slices** by the `e`-coordinate:
`S₀ = Z₂×H` (e-coord 0, **contains `m`**), `S₁` (e-coord 1), `S₂` (e-coord 2).

- **Base `b = 1`:** `Z₂×F₃ = Z₆`, and `{m}` is N (the `r₃=1` Lemma-4 argument: mover plays an order-3
  element `t`, reaching a P-position `{m,t}`, then negation-mirrors).
- **Inductive hypothesis:** `Z₂×F₃^{b−1} = P`, i.e. `{m}` is N inside `S₀`.
- **Step (the crux to design):** a mover strategy from `{m}` that (i) plays the inductive winning
  strategy on the `S₀` slice, (ii) **pairs `S₁ ↔ S₂`** (the natural candidate is the `e`-coord
  reflection `v_e ↦ −v_e`, which fixes `S₀` and swaps `S₁,S₂`), (iii) handles the small `⟨e⟩`-axis
  (the pure `e`-direction order-3 elements, where the pairing hits the O₃ doubling) as bounded
  exceptions, **all while avoiding cross-slice Schur triples `a+b=c` that involve `m` or straddle two
  slices.** The cross-slice interference and the `⟨e⟩`-axis are exactly where the single-involution
  attempts died — the induction's job is to absorb them into the `S₀` sub-game + a bounded exception
  set.

This is a genuine construction, not a one-liner. Verify each candidate strategy computationally
(Task 2) before trying to prove it.

---

## 5. YOUR TASKS (concrete deliverables)

### Task 1 — a fast, symmetry-reduced OUTCOME solver

Build `sumfree_solver.py` computing `win/loss` (and, optionally, the full Grundy value) of the
sum-free game on any finite abelian `G = Z_{m₁} × … × Z_{m_k}`.

- Positions = Python big-int **bitmask** over the `|G|` group elements. Maintain, incrementally, the
  masks `SumSet(A)={a+b}`, `DiffSet(A)={a−b}`, and `Doubling-preimage T(A)={z : 2z∈A}` so that
  legality of adding `x` is `O(1)`: `x` is addable iff `x ∉ A ∪ SumSet(A) ∪ DiffSet(A) ∪ … ` — derive
  the exact clean condition and unit-test it against a brute `a+b=c` scan.
- **Symmetry reduction is the key lever.** Memoize `win(A)` on a **canonical form** of `A` under
  `Aut(G)` — the group of automorphisms preserving `a+b=c`. For `F₃ⁿ` this is `GL(n,3)` (LINEAR maps;
  translations do NOT preserve `a+b=c`, so it is `GL(n,3)`, **not** the affine group). For a general
  product, use `Aut(G)`. When the automorphism group is small enough to enumerate, use full
  min-image; otherwise implement a **BSGS / partition-backtrack (nauty/Linton-style) minimal-image**
  canonicalizer (this is the piece a prior pure-Python attempt lacked, which walled `F₃⁴` — a fast
  minimal-image canonicalizer is exactly what makes `b=4,5` reachable). **Soundness is mandatory:**
  every transposition-table key must be an actual group-image `g·A`, so the memo can never merge
  inequivalent positions (a weaker subgroup just merges fewer — always safe).
- Alpha-beta short-circuit (return `win` on the first losing child) + most-constraining-move ordering
  + instant-win detection.

**Correctness gate (must pass before trusting new values):** reproduce
`F₃²=N, F₃³=N, Z₂×F₃²=P, Z₂×F₃³=P`, the cyclic mod-6 outcomes `Z₅=P,Z₆=P,Z₇=P,Z₈=N,Z₉=N,Z₁₀=N,
Z₁₁=P`, and `Z₂²=P, Z₄²=P` (all `s₂≥2`). Only then compute new values.

**New data to produce:** `F₃⁴` and `F₃⁵` (should be N — `F₃ⁿ=N` is a *theorem*, so these are a
canonicalizer correctness check as much as data); `Z₂×F₃³` (P, re-confirm) and **`Z₂×F₃⁴` (81·2=162
elts — the first genuinely new datum; conjectured P)**; and, if reachable, `Z₂×F₃⁵`. Report wall
(time/memory) honestly if a target is out of reach.

### Task 2 — a strategy-verification harness

Build `verify_strategy.py`: given `G`, a starting position, a designated player, and a **strategy**
(a function `position, opponent_last_move ↦ reply`), verify the strategy wins against **all** opponent
play — branch every opponent move, apply the strategy for the hero, memoize on canonical positions,
and check the hero is never stuck (so the opponent always runs out first). This is how you validate a
candidate `#4` strategy on `Z₂×F₃²`, `Z₂×F₃³` **before** attempting a proof. (For reference, the
`F₃ⁿ` theorem's mirror was validated exactly this way.)

### Task 3 — attempt the `#4` hyperplane induction (§4)

Using Task 2, design and computationally verify a mover strategy from `{m}` on `Z₂×F₃²` and
`Z₂×F₃³` of the `S₀`-inductive + `S₁↔S₂`-pairing + `⟨e⟩`-axis-exception shape. Key questions to answer
empirically first: **Is the `⟨e⟩`-axis exception set bounded independent of `b`? Do cross-slice Schur
triples involving `m` obstruct the `S₁↔S₂` pairing, and if so can a bounded local repair fix it?** If
a clean strategy verifies for `b=2,3`, formalize the inductive step into a proof. If it does not,
document precisely which interference blocks it (this is itself valuable).

### Task 4 (secondary) — the socle reduction

Empirically probe whether the step `𝒢(H × Z_p) = 𝒢(H)` (`p ≥ 5` prime) admits a strategy that lifts
an `H`-strategy by pairing the new coprime elements — and if the interference blocks it, characterize
exactly how (the H-obstruction elements are the order-3 elements of `H`, which the coprime part is
disjoint from under `a+b=c`; the failure is subtler). Lower priority.

---

## 6. Correctness & reporting requirements

- **No unsound canonicalization.** If you cannot verify a symmetry map is a genuine automorphism
  fixing `0` and preserving `a+b=c`, do not use it in the memo key. Prefer a smaller sound group over
  a larger unsound one.
- **Validate every solver/harness against the brute reference before trusting output** (the gate in
  Task 1). A banked naive reference lives at `notes/2026-07-05-sumfree-socle.py`.
- **Memory/compute discipline:** cap runs (`ulimit -Sv`) and single-thread unless told otherwise; if a
  target walls, report the wall (nodes, time, memory) rather than crash. Prefer Python/PyPy; a
  standalone Rust solver is acceptable ONLY if it materially helps and you keep it self-contained (no
  repo build).
- **Final report (a markdown file `notes/2026-07-05-codex-findings-sumfree.md`):** the new outcome
  values with the winning first move for N-cases; whether a `#4` strategy verified for `b=2,3` and its
  exact form; the `⟨e⟩`-axis/cross-slice findings; any proof or precise obstruction; and a list of
  every claim you verified vs. inferred. Do not overclaim — a clean "verified P for `Z₂×F₃⁴`, `#4`
  strategy X verifies for `b≤3`, obstruction Y remains for the inductive step" is a great outcome.

---

## 7. Key facts to lean on (char-3 / structure)

- In `F₃`: `−x = 2x`, `−2x = x`, `3x = 0`. The `F₃ⁿ` σ-mirror works *because* `3y=0` kills the
  `2y=σy` doubling; any group with higher-order elements breaks it — this is the crux distinction.
- Maximal sum-free ("locally maximal") sets in `F₃ⁿ` (Lev, JCTA 2005; Green–Ruzsa 2005): sizes lie in
  `{Ω(3^{n/2}), …, 5·3ⁿ⁻³} ∪ {3ⁿ⁻¹}` with an **empty gap** `(5·3ⁿ⁻³, 3ⁿ⁻¹)`; the maximum `3ⁿ⁻¹` is an
  affine hyperplane coset `{φ=1}`; the two top sizes are odd, small ones mixed-parity. Since the game
  length = size of the final maximal set, **first player wins iff it can force an odd-size maximal
  set** — a useful reframing for the strategy design.
- After `m=(1,0)` is played in `Z₂×V`: for each `v ≠ 0`, at most one of `(0,v),(1,v)` can be in `A`
  (because `m + (0,v) = (1,v)`). So the `{m}`-residual is a "`Z₂`-labelled `F₃ᵇ` game": each `v` gets
  a label in `{0,1}` and a Schur triple `v+w=u` is a violation only if the labels satisfy
  `ε_v + ε_w = ε_u`. The label freedom is *why* `Z₂×F₃ᵇ` flips to P — exploit it.

---

## ★★ ROUND-3 UPDATE (2026-07-05) — the BOOK shrinks the residue; new target = adaptive coupled pairing

Claude took the "bounded-exception book" angle and it produced a real narrowing. Full detail:
[`2026-07-05-socle-book-residue-shrink.md`](2026-07-05-socle-book-residue-shrink.md); scripts
`2026-07-05-socle-book-{residue,investigate,scaling}.py`.

**Established (build on these; do not redo):**
- For odd `G`, negation `ν(x)=−x` is sum-clean on **every element except order-3** — the exceptions
  are exactly the socle `G[3]\{0}`, size `3^{r₃}−1`, **independent of `|G|`.** Call order-3 = *socle*,
  the rest = *bulk*. **Parity reformulation:** bulk negation-paired ⟹ even ⟹ outcome = socle-move
  parity; P1 wins ⟺ it forces odd socle-moves = the socle `F₃^{r₃}=N` game.
- The book strategy (open socle `o`; **bulk** opponent move → reply `−y`; **socle** opponent move →
  reply a winning socle move) gives: **bulk reply always LEGAL** (0 genuine bulk-fails, any coprime
  part); **`r₃≤1` WINS outright** (uniform proof of the coprime + higher-power peel for cyclic-Sylow-3:
  `Z3×Z_p` any `p`, `Z3³`).
- **`r₃≥2` LIMIT (brute-verified — do not retry fixed negation-bulk):** forcing bulk = negation
  **loses**. On `Z9×Z3` the book position `{o}∪`(two bulk pairs) is an OPPONENT-win and the stuck node
  is a genuine hero-loss (not one repair short). Reason: the fixed bulk pairing manufactures Schur
  obstructions (`σ(y)+z ∈ A`) that kill the socle-σ reply. The failure is **coprime-independent**
  (socle-fail = 1 for `Z5,Z7,Z11,Z9`).

**★ New primary target: an ADAPTIVE bulk pairing coupled to the socle game.** The residue is now
1-parameter (`r₃≥2`) + "the bulk must be paired *adaptively*, shifting with the socle center/state, so
the socle-σ reply is never blocked." A *matched involution coupled to the socle*, not a fixed one.
Concrete tasks (use `sumfree_solver.py` + `verify_strategy.py`):

1. **Extract & characterize the solver's bulk-handling on `Z9×Z3` and `Z5×Z3²`.** Dump the full winning
   first-player strategy; for each hero reply to a *bulk* opponent move, record how it deviates from
   `−y`. Is it negation with *bounded* deviations? Are the deviations a function of the current socle
   center `o` / socle-position (e.g. reply `−y` normally but `σ_o(y)=−o−y` or `−y+`(socle shift) at
   flagged positions)? This is the reverse-engineering that cracked `F₃ⁿ` and `Z₂×F₃ᵇ`.
2. **Test candidate coupled pairings** `π_o(z)` on the bulk, parameterized by the socle center `o`:
   e.g. `z ↦ −y` vs `z ↦ −o−z` chosen by a socle-consistency rule; or a pairing that avoids
   `π_o(z)+z' ∈ σ_o(socle)`. Adversarially verify (like the σ-theorem) on `Z9×Z3`, `Z5×Z3²`,
   `Z3²×Z7`. Even one verified coupled pairing that wins a genuinely-open `r₃=2` case = the breakthrough.
3. **Is the `r₃=2` residue a single universal socle configuration?** The stuck node's *socle
   projection* looked constant across coprime parts — confirm it is literally the same socle
   configuration for `Z9×Z3, Z5×Z3², Z3²×Z7`. If so, resolving that one configuration closes **all**
   `r₃=2` peels at once.
4. **Parity route (Attack 2, revived):** since outcome = socle-move parity *when the bulk is paired*,
   the whole reduction = "P1 can keep the bulk paired while running the socle game." Try to prove this
   directly: characterize exactly when a bulk element becomes unpairable (its `π_o`-partner blocked)
   and show P1 can always avoid/repair it within the socle schedule.

**Report** by appending to `notes/2026-07-05-codex-findings-sumfree.md`. Do not overclaim; a verified
coupled pairing for one `r₃=2` group, or a precise proof that no bounded coupled pairing exists, are
both excellent outcomes. Skip the mirror families already closed (§ROUND-2) and fixed negation-bulk.
