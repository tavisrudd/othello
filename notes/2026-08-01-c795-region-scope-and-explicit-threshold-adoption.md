# C795 — region scope correction and explicit-threshold adoption (2026-08-01)

**Lane**: `ame-lu`. Allowed paths: `papers/ame_lu/**` and this report stem.

Status: IN PROGRESS. Written incrementally; the item ledger in §1 is the resume point.

## 0. Sources read

- `CLAUDE.md`, `papers/style-guide.md` (complete), `notes/research-reproducibility-conventions.md`.
- `papers/ame_lu/sections/03-lu-rigidity.tex` (complete), `01-introduction.tex`, `07-conclusion.tex`,
  `08-verification-boundary.tex`, `09-party-extensions.tex`, `main.tex`.
- `papers/ame_lu/theorem-map.md`, `claim-proof-novelty-ledger.md`, `formalization-ledger.md`,
  `verification-map.md`.
- `notes/2026-08-01-c786-explicit-stability-threshold.md`,
  `notes/2026-08-02-c796-phase-blindness-transfer.md`,
  `notes/2026-08-01-c774-two-uniform-rigidity-red-team.md` (with its supersession note),
  `notes/2026-08-01-c776-scope-fable-review-followup.md`,
  `notes/2026-08-01-c777-two-uniform-rigidity-lean.md`.

Nothing in this report rests on a computation. Every manuscript statement added is a proof, verified
by hand as recorded in §2. No evidence bundle ships because no claim needs one.

## 1. Item ledger

| # | Item | State |
|---|---|---|
| 1 | Region scope corrected; parameterized by uniformity order | DONE (commit 83bd2e1c) |
| 6 | Stability estimate at general uniformity order | DONE (commit 83bd2e1c) |
| 4 | Budget-free stability estimate as complement to the moment route | DONE (commit 83bd2e1c) |
| 5 | Obstruction described by codeword counting, not phase-blindness | DONE (commit 83bd2e1c) |
| 8a | Fisher remark clause on quadratic data versus neighbourhood size | DONE (commit 83bd2e1c) |
| 7 | Intertwiner bound generalized to arbitrary party count | DONE |
| 9 | Quantitative-axes trust gap | CLOSED by verification, §2.4 |
| 2 | Explicit threshold and the quantized-overlap lemma | TODO |
| 3 | Uniform-separation corollary | TODO |
| 8b | Move nonabelian factor-set displays to the party-extensions appendix | TODO |
| 10 | Sync theorem map, claim ledger, verification map | PARTIAL (theorem map: items 1/4/6/7 landed) |

Front matter: the abstract (`main.tex`) and introduction were aligned to the corrected region claim
by the coordinator while this task was interrupted. That wording is accurate and I have kept it.

## 2. Red team of the adopted results

Everything below was re-derived line by line before adoption, because item 1 reverses a conclusion
the lane had already adopted once and because C786 flagged its own Proposition 7 as resting on an
unaudited manuscript proof.

### 2.1 C786 Part I — the higher-moment route: CORRECT

- **Lemma 1 (tracial agreement).** `⟨O⟩ = Tr(ρ_S O_S) = q^{-|S|}Tr O_S = q^{-n}Tr O` for `|S| ≤ k`;
  `M^r` expands into terms touching at most `r ≤ k` sites. Correct. The stronger form is also true
  and is what the manuscript uses: the site summands of `M` commute, so `M` is diagonal in a product
  eigenbasis and `q^{-n}Tr f(M) = E f(ΣX_j)` for *every* `f`, not only for moments.
- **Corollary 2 (characteristic-function comparison).** `|λ_i|^{k+1} ≤ ||M||_op^{k-1}λ_i²` needs
  `k ≥ 1`; both states give `M²` the value `D²/q` (Lemma 1 at `r = 2` on one side, tracelessness on
  the other). Correct.
- **Lemma 3 (per-site contraction).** `|E e^{iX}|² = E cos(X−X')`; `cos u ≤ 1 − (u²/2)(1 − u²/12)`
  with `u² ≤ s²`; `cos u ≤ 1 − 2u²/π²` for `|u| ≤ π`; `E(X−X')² = 2Var X = 2||h||_F²/q`. Correct.
- **Theorem 3.** `∏(1−y_j)^{1/2} ≤ exp(−Σy_j/2)`, `1 − e^{−x} ≥ x − x²/2`. Correct.
- **Corollary 4.** `c ≥ 1 − 1/48 = 0.97917`, `c − c²/16 ≥ 0.91924`, `2λ ≤ 1/12`, `ρ ≥ 0.83591 > 5/6`.
  Arithmetic confirmed. `R_k` table confirmed at `k = 3,4,5,10,20,30`; `R_k ∼ k/e` by Stirling.
- **Proposition 5 (ceiling).** `h_j = (2π/q)diag(q−1,−1,…,−1)` is traceless and `e^{ih_j}` has both
  eigenvalues `e^{−2πi/q}`, so it is that scalar. Correct.

**The one place C786's prose overstates its own theorem.** §2.5 states the order-three bracket as
`[1, 1.466]`, using `t ≤ 1` as the radius at `k = 3`. That value comes from the idealized limit
`c → 1`, `D → 0`, not from Corollary 4's stated hypotheses, which give `R_3 = 1/√2 = 0.707`. The
manuscript therefore states the bracket as `[R_3, θ*] = [0.707, 1.466]`, which holds under the
hypotheses as written. The limit is not wrong — the Reed–Muller family does have vanishing per-site
spread and vanishing `D` as its length grows — but it is a different statement and the manuscript
does not silently substitute one for the other.

**The scope correction is sound, and the load-bearing fact is the uniformity order of the
Reed–Muller family.** `d(RM(1,ℓ)) = N/2` and `d(RM(ℓ−2,ℓ)) = 4`, so the equal-phase CSS state has
uniformity order `min(N/2,4) − 1 = 3` for every `N ≥ 8`. Its party count grows; its uniformity order
does not. That is what makes C774's `n^{-1/2}` a statement about bounded uniformity order rather
than about the party count.

**A sharper form of the consequence than either source states, and the one the manuscript adopts.**
Corollary 4's region is the intersection of three conditions: per-site spread `≤ 1/2`, `D ≤ √q/2`,
and `t ≤ R_k`. Which one binds decides the whole question, and it is not the same one in the two
regimes.

- Bounded uniformity order (the Reed–Muller family, `q = 2`, `h_j = cZ` at every site): `t = Nc ≤ R_3`
  forces `c ≤ 0.707/N`, so `D = c√(2N) ≈ 1/√N` and the certified defect radius is `≈ (2N)^{-1/2}`.
  The `ℓ¹` budget binds and the defect neighbourhood shrinks.
- Uniformity order proportional to the party count (`AME(2m,q)`, `k = m = n/2`, `R_m ∼ m/e`): take
  `h_j = c·diag(1,−1,0,…,0)`. Then `D² = 2nc² = q/4` gives `c = √(q/8n)` and `t = √(nq/8)`, which is
  below `R_m ∼ n/(2e)` once `n ≥ qe²/2`. So `D ≤ √q/2` binds, not the budget, and that is a bound on
  the defect by a constant. **The certified defect neighbourhood does not shrink with `n` at all.**

This is the statement the manuscript now makes, and it is stronger and more checkable than "the
radius grows linearly in `n`", which on its own leaves a reader unable to see what happened to the
defect threshold.

### 2.2 C786 Part II — the explicit threshold: CORRECT

- **Lemma 6 (overlap gap).** `|⟨ψ|φ⟩|² = Tr(ρ_ψρ_φ) = q^{-n}Σ_{ℓ∈L_ψ∩L_φ}(χ_ψ χ̄_φ)(ℓ)`; the summand
  is a character of the intersection, so the sum is `|L_ψ ∩ L_φ|` or `0`. The intersection has
  `p`-power order and `q^n = p^{en}`, giving the quantization. Correct, and standard.
- **Proposition 7 (quantitative axes at general `m`).** The only code-dependent quantity is
  `a = q^{-(m+1)}·q^{(m+1)/2} = q^{-(m+1)/2}`; `N = q²−1` and `r = m+1 ≥ 3` are unchanged. Correct.
- **Lemma 7' (minimal logarithm).** `2|sin(μ_a/2)| ≤ σ` and `arcsin x ≤ (π/2)x` give
  `|μ_a| ≤ πσ/2`, so `||h||_op ≤ 2max|μ_a| ≤ πσ`. Correct.
- **Theorem 8.** Step A's `B = 2√2 n q^{(m+2)/2}ε < 1/(2π)`; Step B's
  `1 − ε²/2 − B ≥ 1 − 0.0018 − 0.1592 = 0.839 > 1/√2 ≥ p^{-1/2}`, using
  `ε ≤ τ_p/(2q^{(m+1)/2}) ≤ 1/(6·2^{3/2}) < 0.06` from `q ≥ 2`, `m ≥ 2`; Step C's
  `Σ||h_i||_op ≤ πB < 1/2`. All confirmed.

### 2.3 C796 §7 — the budget-free route: CORRECT

- **Proposition 9 (half-splitting).** `ker π_A` is the labels supported on the complementary
  `m`-set, trivial by minimum weight `m+1`; both sides have `q^{2m}` elements. Correct.
- **Lemma C (cut-transversal labels).** Correct as written.
- **Theorem A.** `∏(1−η_i) ≥ 1 − Ση_i`; `min ≤ average` for the `η^{m−1}` step;
  `(x−y)² ≥ x²/2 − y²`; the two families are disjoint for `m ≥ 2` because their supports meet `A` in
  `m` and in `1` coordinates. At `H ≤ 1/4`, `m ≥ 3`, the bracket is `≥ 5/16 ≥ 1/4`. Correct.
- **Corollary A'.** `η_j ≥ c||h_j||_F²/q` from Lemma 3 and `η_j ≤ ||h_j||_F²/q` from
  `1 − E cos(X−X') ≤ ½E(X−X')²`. Correct.
- **Ceiling consistency.** The ceiling family has `e^{ih_j}` scalar, so every `η_j = 0` and Theorem A
  is empty; its spread is `2π`, where `c(s) ≤ 0` and Corollary A' is empty too. The per-site spread
  condition is exactly the residue of the ceiling, as C796 says.
- **Theorem B.** `{X,Z} = X + {0,Y}` in `F_2²`; `L ∩ S` is empty or a coset of `L ∩ V`; `L ∩ V` is a
  binary code of length `2m` with minimum distance `≥ m+1`, so Singleton gives dimension `≤ m` with
  equality only for a binary `[2m,m,m+1]` MDS code, and the binary MDS codes are the trivial ones,
  forcing `m ≤ 1`. Hence `⟨u,v⟩ ≤ 1/2` and `ε(H^{⊗2m})² ≥ 1`. Correct. I also confirmed
  `p_j` is uniform on `{X,Z}` for `U_j = H` by direct trace computation.

### 2.4 The quantitative-axes trust gap: CLOSED

C786 §3.2 flags that its Proposition 7 rests on the manuscript's `lem:quantitative-axes` and
`prop:quantitative-intertwiner`, which the corpus verifies nowhere; C777 confirms neither is entered
in Lean, even as an interface. I verified both by hand rather than stating the dependency.

**`lem:quantitative-axes`.** Contracting `T'` against a target frame vector gives a rank-one tensor;
the contraction of `(A_1⊗…⊗A_r)T` is within `η` of it, and flattening exhibits its singular values as
`a|c_j|` with `c_j = ⟨e'_{1k}, A_1e_{1j}⟩`, because `{A_2e_{2j}}` and `{⊗_{i≥3}A_ie_{ij}}` are
orthonormal families. Eckart–Young bounds the mass outside the largest by `δ²`; unitarity gives
`Σ_j|c_j|² = 1`, so the dominant coefficient has square `> 1/2`. The overlap matrix is unitary and
square, so no two rows can select the same dominant column and the selections form a permutation.
Finally `min_α||v − αw||² = 2 − 2|⟨w,v⟩| ≤ 2(1 − √(1−δ²)) ≤ 2δ²`, which is `(3.11)`. Correct.

**The three remaining steps of `prop:quantitative-intertwiner`.** Additivity: replacing two factors
costs `2κ` and the product label costs `κ`, so `3κ < √2` — that is `δ < 1/3`. Symplectic form:
four factors cost `4κ` against commutator-phase separation `2sin(π/p)` — that is
`δ < sin(π/p)/(2√2)`. Phases: averaging `|q^{-1}Tr(W_v^†VW_vV^†)| ≥ 1 − κ²/2` over `v` gives
`Σ_x p_x² ≥ (1−κ²/2)²` by character orthogonality, and `max_x p_x ≥ Σ_x p_x²` since `Σ_x p_x = 1`,
so some `|c_x| ≥ 1 − κ²/2` and `min_α ||V − αW_x||²_{norm} = 2 − 2|c_x| ≤ κ²`. All three correct,
and each of the two numerical conditions is exactly one of the two branches of `τ_p`.

**Consequence.** No dependency statement is needed in the manuscript. The chain from
`lem:quantitative-axes` to the explicit threshold is verified end to end here, by hand. It remains
outside Lean, and `formalization-ledger.md` continues to say so.

## 3. What landed in the manuscript

### 3.1 Region scope, general uniformity order, budget-free route (commit 83bd2e1c)

In `sections/03-lu-rigidity.tex`, after `thm:two-uniform-stability` and `rem:fisher-isotropy`:

- `lem:tracial-agreement`, `lem:site-contraction`, `thm:k-uniform-stability`, `cor:k-uniform-region` —
  the moment route, with `R_k = ((k+1)!/48)^{1/(k−1)} ∼ k/e`, and the plain statement that it is
  weaker than the direct argument at `k = 2` (`R_2 = 1/8 < 1/2`) and stronger from `k = 3` on.
- `prop:region-ceiling` — the `2π(1−1/q)n` cap, replacing the manuscript's former `q = 2`-only
  remark that the size constraint cannot be dropped, which now cites it.
- `prop:stability-region` restated: its Reed–Muller parameter is renamed `ℓ` to stop it colliding
  with the AME half-party count `m`, its uniformity order is stated as `3` and proved, and its
  consequence is the order-three bracket `[R_3, θ*]` rather than a party-count claim.
- The summary paragraph after it now separates the two regimes as in §2.1 above.
- `prop:half-splitting`, `lem:cut-transversal`, `thm:budget-free-stability` — the bipartition route,
  presented as a choice of hypothesis set against `cor:k-uniform-region`, with the ceiling
  consistency check and the `H^{⊗2m}` detection paragraph.

The `H^{⊗2m}` paragraph is where item 5 is discharged: it says in terms what the mechanism is —
a count of codewords in a structured subset of `L`, pushed down by the MDS constraints — and does
not describe the open problem as phase-blindness. No sentence anywhere in the manuscript did
describe it that way; that framing was confined to C786 §4.

### 3.2 Intertwiner bound at arbitrary party count (this commit)

`prop:quantitative-intertwiner` now reads for arbitrary stabilizer `AME(2m,q)` states at every
`m ≥ 2`, with `δ = 2q^{(m+1)/2}ε` and conclusion `q^{-1/2}||U_i − K_i||_HS ≤ √2 δ`. Two changes of
substance beyond the parameter: the hypothesis is no longer equal-phase CSS states of `[6,3,4]_q`
MDS codes but arbitrary additive stabilizer AME states, since
`prop:stabilizer-ame-support` already supplies the supported-label bijection that the old proof got
from the MDS shortening `(3.7)`; and the covering step is "every party lies in some `(m+1)`-set"
rather than "two four-party sets cover all six parties". The `m = 3` reading is displayed in the
statement so the old bound is still visible.

Added after the proof: one paragraph saying the exponent is a property of the states rather than
slack, because the nonidentity part of an `(m+1)`-party marginal has Hilbert–Schmidt norm
`q^{-(m+1)/2}√(q²−1)`.

`theorem-map.md` updated in the same commit: the C581 row becomes C581/C795 at general `m`, the
boundary-table row drops "no claim at general `m`" and names the exponential degradation and its
cause, and three new stable-source label lines cover the moment route, the ceiling, and the
bipartition route.

## 4. Still to do

Items 2, 3, 8b and the remainder of 10, in that order. Notes for whoever continues:

- The explicit threshold must go **after** `prop:quantitative-intertwiner`, since its first step
  calls it. Order in the file: decomposition corollary (compactness, kept as the qualitative
  statement) → quantitative axes → intertwiner → overlap gap → uniform separation → explicit
  threshold → gauge corollary.
- Three sentences become false the moment the threshold lands and must be carried in the same
  commit: the closing sentence of the paragraph after `cor:approximate-decomposition`'s proof
  ("comes from compactness and is not explicit"); the corresponding clause in
  `cor:two-unitary-gauge`; and the claim-to-trust paragraph in `sections/08-verification-boundary.tex`
  that contrasts explicit `τ_p` with non-explicit `ε₀`. `theorem-map.md`'s deliberate-exclusion line
  "No explicit stability threshold `ε₀`" also becomes false.
- Item 8b touches `theorem-map.md`'s `cor:discrete-lu-symmetry` label, which names the kernel-checked
  factor-set terminals `genericPartyPermutationOuterAction` and the three
  `genericPartyPermutationFactorSet_*` declarations. Those terminals do not change — only where the
  manuscript displays them — so the formalization ledger's row for that corollary stands as written.
- Nothing in this pass changes what is kernel checked. `formalization-ledger.md` is untouched and
  must stay untouched: the new material (moment route, ceiling, bipartition route, general-`m`
  intertwiner, threshold) is all outside the Lean development, and the ledger's existing row already
  says the intertwiner bound and the stability estimate are not formalized.

## 5. Validation

`make -C papers/ame_lu check` after each item: PASS, exit 0, warning-free (the Makefile fails on any
Overfull, Underfull, LaTeX Warning, Package Warning, undefined reference, or undefined citation).
Manual equation tags `(3.1)`–`(3.16)` remain in document order; the new material uses no manual tags,
so nothing needed renumbering.

## 6. Mystery ledger

Deferred to the closeout pass, after items 2, 3, 8b and 10.
