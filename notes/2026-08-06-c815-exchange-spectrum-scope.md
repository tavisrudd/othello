# C815 — scope of the OPER-3 spectral half

**Date:** 2026-08-06
**Lane:** `clebsch` (Paper III route task C815)
**Status:** scoping only; no Lean file changed, no manuscript change

## What this scopes

Ledger row OPER-3 of `notes/2026-08-03-c815-paper-iii-formalization-gap-inventory.md`
has one piece left: every eigenvalue and singular-value statement of
Theorem *Balanced exchange rigidity*
(`papers/clebsch-passages/sections/05-golden-operator.tex`, lines 98--186), and
with it the passage from the fourth trace of a principal block to the second
exchange moment.

The task card records the contingency that the spectral half may need its own
allocated task rather than staying in C815.  **It does not.**  The route below
removes the analytic content entirely: no spectral theorem, no singular-value
decomposition, no Newton identities, no `Real.sqrt` in the load-bearing
statements.  The whole half is characteristic-polynomial and trace algebra over
a commutative ring, in the same ring-general style as
`RelativeConicArcs.ConferenceCutBlocks`.

## The manuscript's obligations, itemized

With `C` a symmetric conference matrix of order `2d`, `q = 2d - 1`, a balanced
half `Y`, cut blocks `C = [[A, R], [Rᵀ, E]]`, `D` the diagonal sign involution of
the cut, `Q = C/√q`, `P_± = (1 ± Q)/2`, and `Q₊` an isometry onto `im P₊`, the
exchange operator is `H_Y = Q₊ᵀ D P₋ D Q₊`.  The theorem asserts:

| # | claim | current status |
|---|---|---|
| SP-1 | `Spec(H_Y) = Spec(R Rᵀ / q)` | open |
| SP-2 | `Spec(R Rᵀ / q) = {1 - αᵢ²/q}` for `αᵢ` the eigenvalues of `A` | open |
| SP-3 | `tr(H_Y) = d²/q` | open |
| SP-4 | `tr(H_Y²) = (F_d + 32 c_Y)/q²`, `F_d = dq² - 2qd(d-1) + d(d-1) + 12·C(d,3) - 8·C(d,4)` | open |
| SP-5 | `d ≥ 4` ⟹ the spectrum depends on `Y` | reduces to a closed theorem |
| SP-6 | `d ≤ 3` ⟹ the spectrum does not depend on `Y` | open, small |
| SP-7 | order six is the unique nontrivial *realized* such order, with spectrum `{1/5, 4/5, 4/5}` | open; see the scope question below |

Already formalized and reusable:
`ConferenceCutBlocks.mul_transpose_eq_of_sq_smul` (`B Bᵀ = q•1 - A A`),
`ConferenceCutBlocks.trace_mul_self` (`tr(A²) = d(d-1)`),
`ConferenceCutBlocks.trace_pow_four` (support-sorted fourth trace),
`ConferenceCutBlocks.closedFourWalkSum_eq_twentyFour_or_neg_eight`,
`SubsetInclusionSums.eq_of_sum_powersetCard_eq`,
`BalancedExchangeRigidity.not_forall_sum_closedFourWalkWeight_eq`.

## The route: the analysis is removable

Write `L = D Q - Q D`, `M = -L²/4`.  Three elementary facts drive everything.

**(i) Block form.**  With `D = fromBlocks 1 0 0 (-1)` and `Q = s⁻¹ • C` where
`s * s = q`,

```
L  = s⁻¹ • fromBlocks 0 (2R) (-2Rᵀ) 0,
L² = -(4/q) • fromBlocks (R Rᵀ) 0 0 (Rᵀ R),
M  = fromBlocks N 0 0 N',   N = q⁻¹ • R Rᵀ,  N' = q⁻¹ • Rᵀ R.
```

`s` is a hypothesis, not `Real.sqrt`: the module can be stated over any
commutative ring carrying an element with `s * s = q`, and specialized to `ℝ`
only where the manuscript's real spectrum is wanted.

**(ii) Anticommutation.**  `L Q = -Q L`, `Lᵀ = -L`, `L² Q = Q L²`, so `M`
commutes with `Q` and with `P_±`.  For `U` with `Uᵀ U = 1` and `U Uᵀ = P₊`
(equivalently: an isometry onto the positive eigenspace),

```
L U = 2 P₋ D U,     H_Y = Uᵀ D P₋ D U = Uᵀ M U.
```

**(iii) The intertwiner.**  Let `W` satisfy `Wᵀ W = 1`, `W Wᵀ = P₋`, and put
`S = Wᵀ (L/2) U`.  Then `P₋ L U = L U` and `P₊ L W = L W`, hence

```
Sᵀ S = -¼ Uᵀ L² U = Uᵀ M U = H_Y,       S Sᵀ = Wᵀ M W =: H'_Y.
```

### SP-1 by characteristic polynomials

`Matrix.charpoly_mul_comm` applied to `S` gives `charpoly(H_Y) = charpoly(H'_Y)`
directly.  With `V = fromColumns U W` one has `Vᵀ V = V Vᵀ = 1` and
`Vᵀ M V = fromBlocks H_Y 0 0 H'_Y` (the cross block vanishes because
`Uᵀ M W = Uᵀ M P₊ P₋ W = 0`), so

```
charpoly(H_Y) · charpoly(H'_Y)  = charpoly(Vᵀ M V) = charpoly(M)
                                = charpoly(N) · charpoly(N')
                                = charpoly(N)²,
```

using `charpoly_fromBlocks_zero₁₂` twice, `charpoly_mul_comm` for
`charpoly(N') = charpoly(N)`, and `charpoly_mul_comm` again for
`charpoly(Vᵀ (M V)) = charpoly((M V) Vᵀ) = charpoly(M)` — so no separate
similarity-invariance lemma is needed.  Both `charpoly(H_Y)` and `charpoly(N)`
are monic of degree `d`, and `p² = r²` with `p + r` of leading coefficient `2`
forces `p = r` over an integral domain in which `2 ≠ 0`.  Hence

```
charpoly(H_Y) = charpoly(q⁻¹ • R Rᵀ) = charpoly(1 - q⁻¹ • A A),
```

the last step by the already-proved cut identity.  This is *stronger* than the
manuscript's set-level `Spec` claim and needs no eigenvalue API at all.

### SP-3, SP-4 by traces

For every `k ≥ 1`, `L^{2k} Q = -L^{2k-1} Q L`, so `tr(L^{2k} Q) = -tr(L^{2k} Q)`
and the trace vanishes.  Since `M` commutes with `P₊` and `P₊ U = U`,
`H_Y^k = Uᵀ M^k U` and

```
tr(H_Y^k) = tr(M^k P₊) = ½ tr(M^k) + ½ tr(M^k Q) = ½ tr(M^k) = tr(N^k),
```

using `tr(M^k) = tr(N^k) + tr(N'^k)` and `tr((Rᵀ R)^k) = tr((R Rᵀ)^k)`.  Then

- `tr(H_Y) = tr(N) = (dq - tr(A²))/q = (dq - d(d-1))/q = d²/q`;
- `tr(H_Y²) = tr(N²) = (dq² - 2q·tr(A²) + tr(A⁴))/q²`, and substituting the
  support-sorted fourth trace with `Σ_K w(K) = 4c_Y - C(d,4)` — the only new
  combinatorial bookkeeping, a `Finset.filter` split of the closed `{3, -1}`
  dichotomy — gives exactly `(F_d + 32 c_Y)/q²`.

This is the passage the row names, and it is independent of SP-1: the moments do
not go through the spectrum at all.

### SP-5, SP-6

`d ≥ 4`: if the spectra agreed for all halves then the second moments would
agree, hence the four-set walk sums would agree, contradicting
`BalancedExchangeRigidity.not_forall_sum_closedFourWalkWeight_eq`.  A thin wrapper.

`d ≤ 3`: `d = 1` is trivial, `d = 2` has `A² = 1`.  For `d = 3`, every
off-diagonal product satisfies `A i k · A k j = τ · A i j` with `τ` the product
of the three edge signs, so `A² = 2·1 + τ • A`, and

```
charpoly(A²)(X) = det((X-2)·1 - τ•A) = det(τ • (u·1 - A)) with u = τ(X-2)
                = τ³ (u³ - 3u - 2τ) = (X-2)³ - 3(X-2) - 2 = (X-4)(X-1)².
```

`τ` cancels, so there is no sign case split; `Matrix.det_fin_three` closes the
cubic.  Composing with SP-1 gives the exchange spectrum `{1/5, 4/5, 4/5}` at
`q = 5`.

### SP-2 and non-vacuity

Two items still touch real analysis, and only lightly:

- **SP-2** is the only claim phrased in eigenvalues rather than characteristic
  polynomials.  Given SP-1 as a `charpoly` identity it is the statement that the
  roots of `charpoly(1 - q⁻¹•A²)` are `1 - αᵢ²/q`, which is
  `Matrix.IsHermitian.charpoly_eq` plus a polynomial substitution over `ℝ`.
- **Non-vacuity**: the theorem is conditional on an isometry existing.  The
  clean packaging is a single hypothesis — an orthogonal `V` with
  `Q = V · fromBlocks 1 0 0 (-1) · Vᵀ` — from which `U` and `W` are its column
  blocks.  Proving such a `V` exists for a real symmetric `Q` with `Q² = 1` and
  `tr Q = 0` needs the rank-equals-trace fact for idempotents and an orthonormal
  basis of the range.  That is standard but is the one place where mathlib's
  inner-product machinery is unavoidable.

## Cost and risk

| item | new Lean | risk | notes |
|---|---|---|---|
| block algebra for `L`, `L²`, `M`, anticommutation | ~120 lines | low | pure `fromBlocks` computation |
| `H_Y = Uᵀ M U` and the intertwiner `S` | ~80 lines | low | |
| SP-1 charpoly chain + monic square root | ~120 lines | low | all four mathlib lemmas confirmed present |
| SP-3/SP-4 traces, incl. `tr(L^{2k} Q) = 0` | ~100 lines | low | |
| SP-4 aligned-count bookkeeping `Σ w = 4c_Y - C(d,4)` | ~120 lines | medium | `Finset` counting, the fiddliest piece |
| SP-5 wrapper | ~60 lines | low | |
| SP-6 small orders | ~120 lines | low | `det_fin_three` |
| SP-2 eigenvalue phrasing | ~80 lines | medium | first use of `IsHermitian.eigenvalues` in this development |
| non-vacuity `V` | ~100 lines | medium | rank/trace of idempotent, orthonormal basis |

Roughly 800--1000 lines in one new module,
`RelativeConicArcs.BalancedExchangeSpectrum`, added to the golden-return gate
`RelativeConicArcs/Gates/ClebschGoldenReturn.lean`.  Comparable in size to the
fourth-trace round already landed under this row.  **Verdict: the spectral half
stays in C815; no new task ID is warranted.**

Confirmed present in the pinned mathlib (`571b8a8e54`, 2026-06-26):
`Matrix.charpoly_mul_comm`, `Matrix.charpoly_mul_comm'`,
`Matrix.charpoly_fromBlocks_zero₁₂`, `Matrix.charpoly_fromBlocks_zero₂₁`,
`Matrix.IsHermitian.charpoly_eq`, `Matrix.IsHermitian.eigenvalues`,
`Matrix.IsHermitian.trace_eq_sum_eigenvalues`.

## Recommended order of work

1. Block algebra and `H_Y = Uᵀ M U` (unblocks everything else).
2. SP-3 and SP-4 traces — these close the row's named passage and reuse the
   existing fourth-trace theorem immediately.
3. SP-1 charpoly chain, then SP-5 and SP-6.
4. SP-2 and non-vacuity last, as the only analytic items.

## Scope question for the author

Claim SP-7 says order six is the unique nontrivial **realized** order with a
cut-independent spectrum.  With SP-6 in hand this needs the non-existence of a
symmetric conference matrix of order four, which is a `decide`-sized symbolic
check on six edge signs, plus a reading of "nontrivial" that excludes order two.
It does **not** need the classical theorem that symmetric conference matrices
have order `≡ 2 (mod 4)`, provided the sentence is read as ranging over the
orders `d ≤ 3` that SP-6 covers.  If instead the sentence is read as a claim
about all orders, the classical congruence theorem enters and is a genuinely
larger piece of work.  The narrow reading is recommended, and the manuscript
sentence should be checked against it by C816, which owns promotion.

## Mystery ledger

- **Settled.** The row's apparent dependence on singular-value decomposition was
  the reason it looked expensive.  It is an artifact of the manuscript's
  exposition: the compression to the positive eigenspace is a two-sided
  `charpoly_mul_comm` argument, and the moments never need the spectrum.  The
  `√q` in the definition of `Q` is a hypothesis `s * s = q`, not an analytic
  object.
- **Settled.** `τ`, the product of the three edge signs at `d = 3`, cancels out
  of `charpoly(A²)`; the manuscript's two-case factorization
  `(t-2)(t+1)²` / `(t+2)(t-1)²` is one uniform cubic after the substitution
  `y = X - 2`.  This is a shorter argument than the manuscript's and is a
  candidate simplification for C816 alongside the one already queued in
  `notes/2026-08-06-c815-exchange-rigidity-simplification.md`.
- **Open.** Whether `RRᵀ` can be singular for a symmetric conference matrix —
  that is, whether `q` can be an eigenvalue of `A²` for a balanced half — is not
  settled here.  Nothing in the route above depends on it, because the
  `charpoly` chain never inverts `S`; the question is recorded only because the
  more obvious similarity-based proof of `charpoly(H_Y) = charpoly(H'_Y)` would
  have needed it.  Owner: none allocated; it is not a Paper III obligation.
