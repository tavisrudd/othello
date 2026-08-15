# C913 round-three cold read: global transport, one-chart appendix, scope item (5)

Date: 2026-08-15. Manuscript: `papers/cubic-stabilization-irrationality/`, frozen at
`101d2e990`. Referee: independent, no prior involvement with this text.

## 1. Scope and method

### 1.1 What I read

Primary scope, read in full and judged:

- `sections/08-global-transport.tex`, from the start of the section through the end of the
  proof of `prop:clutching-tail-holonomicity` (lines 1--884). This covers
  `def:gauged-admissible`, `rem:iv-semistable-restriction`, the four-conditions
  discussion paragraph, `rem:endpoint-only`, `eq:endpoint-gauged-maps`,
  `eq:marked-class-restrictions`, `lem:point-insertion-row`, `prop:support-collapse`,
  `lem:orbit-cylinder-disjoint`, the completion-and-terminology paragraphs,
  `prop:gamma-ratio-reduction`, `rem:higher-pole-localization-boundary`,
  `rem:neutral-boundary`, `thm:tailwise-derived`, and
  `prop:clutching-tail-holonomicity`.
- `sections/appendix-one-chart.tex` in full: `conv:app-obstruction-morphism`,
  `def:app-fixed-section`, `rem:app-exponent`, `lem:app-graded-extension`,
  `lem:app-sign`, `prop:app-one-chart`, `prop:app-descent`, `lem:app-cech`,
  `rem:app-degree-one`, `lem:app-truncation`, `prop:app-square`, `prop:app-mu-k`,
  `prop:app-cutting`, `rem:app-imports`.
- `sections/08-scope.tex` item (5).
- The `sections/01-introduction.tex` paragraph beginning "The conditional proof uses a
  smooth projective equivariant completion" (lines 110--118).

Read for context: `sections/02-point-row.tex` in full (Gamma point row
`eq:gamma-point-row`, Gamma-framed section `eq:gamma-framed-section`, twisted pairing
`eq:flat-euler-pairing`), `refs.bib`, `thm:intro-cubic-conditional` and its proof in
`sections/09-cubic-endpoint.tex` (only to check `rem:endpoint-only`).

Secondary scope, reached: all of the remainder of `sections/08-global-transport.tex`
(lines 885--1342) was read; `rem:two-tail-threshold-obstruction`,
`lem:cyclic-row-support`, `eq:rees-homogeneity`, `lem:finite-threshold-gluing` and
`thm:birational-point-primary` were checked independently. `prop:app-mu-k` and
`prop:app-cutting` were verified as part of the appendix read, not deferred.
`hyp:marked-threshold-wall`, `hyp:marked-threshold-zero`, `def:reduced-nearby`,
`conj:gamma-window` and `rem:verification-status` were read but not audited in depth;
see the coverage section.

### 1.2 What I verified independently

Algebra and analysis, recomputed from scratch rather than accepted:

- `eq:gamma-index-factor` on both degree rays, from `Gamma(x+1) = x Gamma(x)`, including
  the factor count of the `H^1` Euler class for `n < 0` and the convention that the
  displayed left side means `Eul(H^1)` there.
- `eq:adjacent-gamma-ratio`.
- `eq:simple-gamma-residue`: residue of `Gamma` at `s = -m`, with the Jacobian from the
  substitution `s = h*sigma + alpha`.
- `eq:total-moving-slope` from `chi(O(n)) = n + 1` on a genus-zero domain (valid on both
  rays), plus the vanishing of the gauge-algebra and fixed-part slopes.
- The full Stirling expansion of `log|c_k|` in `prop:clutching-tail-holonomicity`, term by
  term, on both rays, tracking the `log|zeta|` scale term; and which terms neutrality
  kills.
- The distributional estimate: the choice `q > N + 2`, absolute convergence of `sum b_k`,
  recovery of the series by `d^q/dtheta^q`, and the order bound.
- The `Gm` numerical criterion in the fibre-weight form of `lem:orbit-cylinder-disjoint`,
  derived from the Hilbert-Mumford function and the weight `-k` of the `O(1)` fibre at
  `[v_k]`; then every clause (a), (b), (c) of that lemma.
- `lem:app-graded-extension` (both parts), `lem:app-sign`, the attractor-ideal
  description in `prop:app-one-chart`, the `P^1` chart-dependence counterexample, the
  `U_F` refinement, the graded-Picard step, the tangent-weight sign flip and the
  `aw <= 0` half in `lem:app-cech` (checked against the `A^1` weight-`k` example),
  `rem:app-degree-one`, and `prop:app-mu-k`(a),(b).
- `rem:two-tail-threshold-obstruction`: both generating functions and the annihilator
  `(E-2)(E-1/3)`.
- `lem:cyclic-row-support`.

Citation checking. Every locator in the primary scope was read in the cached sources at
`/tmp/persistent/tavis/lit-search/`:

| key | sha256 (prefix) | used for |
|--------------------|------------|--------------------------------------------|
| `arXiv:1208.1727`  | (Gonzalez-Woodward) | Lemma 3.17, Prop. 3.15(c), Prop. 3.18, Rem. 3.19, Cor. 3.20, Lem. 3.21, Rem. 1.18(d), Rem. 4.6, eq. (47), Rem. 4.7 |
| `arXiv:1408.5869`  | `5aa794f4...` | Woodward QK III: Def. 7.13, Prop. 7.14, eq. (35), Sec. 7.1, Sec. 8.3, Def. 9.7, Lem. 9.8, Lem. 9.9, Cor. 9.10(a)(b)(c), Ex. 9.15, Sec. 9.4, eqs. (54)-(59), eq. (68) |
| `arXiv:1408.5864`  | `018530b8...` | Woodward QK II: Prop. 4.3(f),(g), Sec. 4.3, Prop. 5.21, Ex. 6.6(c) |
| `arXiv:math/9904074` | (Wlodarczyk) | Def. 5, Lem. 6, Prop. 2(B') and its proof, the `L(X,D;X',D')` construction |
| `arXiv:2301.01266` | (Aleshkin-Liu) | Def. 5.18, Rem. 5.20, Thm. 5.21 |

Text extractions are pdftotext reconstructions; sub- and superscripts and index ranges
were treated with suspicion and cross-checked against surrounding prose wherever a
locator turned on them.

## 2. Required repairs

Two, both narrow. Neither changes any conclusion; both are places where a stated
justification does not deliver the statement it is attached to.

**RR1.** In the proof of `prop:clutching-tail-holonomicity`, the two per-ray
log-magnitude estimates omit the `zeta`-scale term, so the displayed expansion of
`log|c_k|` -- which does contain that term -- does not follow from them. One clause each.
Details in section 5.1.

**RR2.** In `rem:iv-semistable-restriction`, the reason given for freeness of
`H^*_{Gm}(W;Q)` over `H^*(B Gm;Q)` ("all cells are even-dimensional, so the Gysin
sequences degenerate") is not sufficient when the fixed components carry odd cohomology,
which they do in this paper's own application. The conclusion is a true standard theorem;
the stated route to it is not. Details in section 5.2.

## 3. Optional improvements

Labelled optional because in each case the mathematics is correct and the citation
supports the use; only clarity or locator precision would improve.

- **OI1.** `a` carries three meanings across the section: root index in `h_a, s_a,
  alpha_a` (`eq:affine-moving-degree`), a free scalar constant in
  `eq:adjacent-gamma-ratio`, and the clutching exponent in `thm:tailwise-derived` and the
  whole appendix. The `eq:adjacent-gamma-ratio` occurrence sits two displays after the
  root-index one.
- **OI2.** `k` is the affine-degree tail variable in `prop:gamma-ratio-reduction` and
  `prop:clutching-tail-holonomicity`, and the orbifold cover order in the last part of the
  proof of `thm:tailwise-derived` and throughout `app:rigidification`. The reconciling
  sentence ("slopes are counted per unit of the primitive affine direction `delta` ...
  while consecutive degrees inside a tail differ by the stabilizer order") does its job,
  but a distinct symbol for the stabilizer order would remove the need for it.
- **OI3.** `eq:virtual-normal-euler` is attributed to "Woodward's virtual-normal
  splitting", cited via `Corollary 9.10` and used with the explicit Euler factors
  `(-/+ zeta)(-/+ zeta - psi)`. Woodward's equation (59) gives the K-theoretic splitting
  with the node factor written as a tensor product of two *dual* tangent lines; the signed
  Euler-class form the manuscript uses is the one Woodward himself writes in his equation
  (64). Citing (59) and (64) together would let a reader check the signs without
  reconstructing them.
- **OI4.** `Lemma 3.21` of Gonzalez-Woodward is cited for the statement that the
  obstruction theory of the master space differs from that of `M^G_n(C,X)` by the trivial
  factor coming from the fibre of `P(D(L_-) (+) D(L_+))`. That sentence is the first line
  of the *proof* of Lemma 3.21, not its statement (the statement is about the conormal
  complex being the moving part). "Lemma 3.21 and its proof" would be exact.
- **OI5.** `lem:orbit-cylinder-disjoint` hypothesises "two equivariant *ample*
  linearizations"; `def:gauged-admissible` says only "two extreme linearizations" and
  "chamber polarizations". Ampleness is carried by the word "polarization" under the
  usual convention, but the lemma is the place where it is actually used (the numerical
  criterion is stated for an ample `M`), so one word in (i) would close the loop.
- **OI6.** Bistability of the cylinder orbit -- that the cylinder orbit lies in
  `W^ss(L_-) ∩ W^ss(L_+)` -- is an input to the construction of `a_p`. It is registered,
  but only in `08-scope.tex` item (5) and in the discursive sentence after the lemma; it
  is not one of the four numbered conditions. Since the four conditions are advertised as
  the assumption register, promoting it (or cross-referring to scope item (5) from
  `def:gauged-admissible`(iv)) would keep the register in one place.
- **OI7.** The statement of `lem:app-truncation` says Woodward's obstruction morphism "is
  the composite"; what the proof establishes is that the two morphisms have the same
  deformations and obstructions on every square-zero extension of classical test schemes,
  naturally in the test scheme. The proof itself says so in as many words, and
  `prop:app-square` then carries exactly that to virtual classes, so nothing is
  overclaimed downstream. Phrasing the lemma's conclusion at the level the proof reaches
  would remove the momentary mismatch.
- **OI8.** `rem:neutral-boundary` calls Aleshkin-Liu's hypothesis a "grade-restriction
  window". Their formula (5.37) is introduced as the *grade restriction rule* in their
  Remark 5.20, adjacent to the cited Definition 5.18. Adding Remark 5.20 to the locator
  would name the phrase the manuscript is echoing.

## 4. Verdict table

| statement | judged | verdict |
|---------------------------------------|--------|-----------------------------------------|
| `def:gauged-admissible` (i)-(iv)      | yes    | sound; register complete when read with `08-scope` item (5) (see OI6) |
| four-conditions discussion paragraph  | yes    | accurate; Wlodarczyk Prop. 2(B') supports what it is cited for |
| `rem:iv-semistable-restriction`       | yes    | conclusion true, stated reason insufficient -- **RR2** |
| `rem:endpoint-only`                   | yes    | correct; matches the actual proof of `thm:intro-cubic-conditional` |
| `eq:endpoint-gauged-maps` + QK III (68) | yes  | citation exact; display correctly labelled a definition |
| `eq:marked-class-restrictions`        | yes    | consistent with `lem:orbit-cylinder-disjoint`(b),(c) |
| `lem:point-insertion-row`             | yes    | correct given the flagged normalization input; scalar recomputed |
| `prop:support-collapse`               | yes    | correct; every citation checked and every unproved input registered |
| `lem:orbit-cylinder-disjoint`         | yes    | correct; numerical criterion re-derived independently |
| completion / terminology paragraphs   | yes    | correct, including the "projective means quasiprojective" catch |
| `prop:gamma-ratio-reduction`          | yes    | correct; all four displayed identities recomputed |
| `rem:higher-pole-localization-boundary` | yes  | correct and correctly limiting |
| `rem:neutral-boundary`                | yes    | all four Gonzalez-Woodward locators and both Aleshkin-Liu locators support the use |
| `thm:tailwise-derived`                | yes    | correct, given the appendix; no step exceeds what the appendix proves |
| `prop:clutching-tail-holonomicity`    | yes    | statement correct; one gap in the growth derivation -- **RR1** |
| `conv:app-obstruction-morphism`       | yes    | accurate: QK III Def. 7.13 does fix the complex and not the morphism |
| `def:app-fixed-section`               | yes    | matches QK III Def. 9.7 including the orbifold form |
| `lem:app-graded-extension`            | yes    | correct |
| `lem:app-sign`                        | yes    | correct |
| `prop:app-one-chart`                  | yes    | correct; chart-independence handled properly, counterexample checked |
| `prop:app-descent`                    | yes    | correct |
| `lem:app-cech`                        | yes    | correct, including the tangent-weight sign flip |
| `rem:app-degree-one`                  | yes    | correct |
| `lem:app-truncation`                  | yes    | proof sound; statement slightly ahead of proof (OI7) |
| `prop:app-square`                     | yes    | correct; the Behrend-Fantechi realization step is used and flagged |
| `prop:app-mu-k`                       | yes    | correct; (b) matches QK III Def. 9.7 and eq. (55) exactly |
| `prop:app-cutting`                    | yes    | correct; QK III Prop. 7.14(b), eq. (35), QK II Prop. 5.21 all support |
| `rem:app-imports`                     | yes    | accurate ledger of what is imported |
| `08-scope.tex` item (5)               | yes    | complete for the proof it describes |
| introduction paragraph (lines 110-118)| yes    | accurate summary of the mechanism |
| `rem:two-tail-threshold-obstruction`  | yes    | both germs and the annihilator recomputed; correct |
| `lem:cyclic-row-support`              | yes    | correct |
| `lem:finite-threshold-gluing`, `thm:birational-point-primary` | read | consistent with the hypotheses as stated; not audited in depth |

## 5. Findings in detail

### 5.1 RR1 -- the `zeta`-scale term is missing from the two per-ray estimates

Quoted text (`sections/08-global-transport.tex`, proof of
`prop:clutching-tail-holonomicity`):

> The cancellation is uniform in the two degree rays because each virtual line contributes
> the same expression to \(\log|c_k|\) on both of them: for \(n_a\geq0\) the factor
> \eqref{eq:gamma-index-factor} has log-magnitude \(-n_a\log n_a+n_a+O(\log n_a)\), and
> for \(n_a<0\) the \(H^1\) Euler class \(\prod_{m=n_a+1}^{-1}(\alpha_a+m\zeta)\) has
> log-magnitude \(|n_a|\log|n_a|-|n_a|+O(\log|n_a|) =-n_a\log|n_a|+n_a+O(\log|n_a|)\).

and the display that follows:

> \[ \log|c_k|= -\Bigl(\sum_ah_a\Bigr)k\log k -k\sum_ah_a\log|h_a|
>    +\Bigl(\sum_ah_a\Bigr)k -\Bigl(\sum_ah_a\Bigr)k\log|\zeta| +O(\log k), \]

with the accompanying sentence "The last displayed term is the one contributed by the
scale of `zeta`".

Independent computation. Work in a fixed `C`-basis of `R_N` with `zeta` specialized to a
nonzero complex number, as the proof directs. Write `x_a = alpha_a/zeta`.

For `n_a >= 0` the factor is the inverse `H^0` Euler class, and

```
log | 1 / prod_{m=0}^{n_a} (alpha_a + m zeta) |
  = - sum_{m=0}^{n_a} log|alpha_a + m zeta|
  = - (n_a + 1) log|zeta| - sum_{m=0}^{n_a} log|m + x_a|
  = - n_a log n_a + n_a - n_a log|zeta| + O(log n_a).
```

For `n_a < 0` the factor is the `H^1` Euler class, a product of `|n_a| - 1` terms:

```
log | prod_{m=n_a+1}^{-1} (alpha_a + m zeta) |
  = (|n_a| - 1) log|zeta| + sum_{j=1}^{|n_a|-1} log|j + x_a| + O(1)
  = |n_a| log|n_a| - |n_a| + |n_a| log|zeta| + O(log|n_a|)
  = - n_a log|n_a| + n_a - n_a log|zeta| + O(log|n_a|).
```

So the correct uniform per-line expression is

```
- n_a log|n_a| + n_a - n_a log|zeta| + O(log|n_a|),
```

on both rays. The manuscript's two expressions are this expression with the third term
deleted. That term is linear in `n_a`, hence linear in `k`; it is not absorbed by
`O(log n_a)` unless `|zeta| = 1`, which is nowhere assumed (the proof says only
"specializing the rotation parameter `zeta` to a nonzero complex number").

Consequence. Substituting `n_a = h_a k + s_a` and `log|n_a| = log|h_a| + log k + O(1/k)`
into the corrected uniform expression and summing over roots with `h_a != 0` gives exactly
the manuscript's display, `- (sum h_a) k log k - k sum h_a log|h_a| + (sum h_a) k -
(sum h_a) k log|zeta| + O(log k)`. Substituting the two expressions as printed gives the
same display *without* the fourth term. So the display, which is correct, does not follow
from the sentence that is offered as its derivation.

Verdict. Required repair, minor and local. The fix is to carry `- n_a log|zeta|` in both
per-ray expressions (or equivalently to say once that each contributes
`- n_a log|n_a| + n_a - n_a log|zeta| + O(log|n_a|)` on both rays). Everything downstream
is unaffected: the display is right, neutrality kills the `k log k` term, the `(sum h_a)k`
term and the `zeta`-scale term simultaneously, the residual rate `- sum h_a log|h_a|` is
linear and is removed by one rescaling, and the resulting polynomial-logarithmic bound is
what the distributional argument consumes. I also checked that the uniformity claim the
sentence is making -- that a virtual line contributes the same expression on both rays --
is *true* including the `zeta` term, so the repair strengthens rather than disturbs the
argument it supports.

### 5.2 RR2 -- parity of the cells does not give freeness

Quoted text (`rem:iv-semistable-restriction`):

> For a smooth projective \(W\) with \(\Gm\)-action the Bia{\l}ynicki--Birula
> decomposition is filtrable, its cells are affine bundles over the fixed components, and
> all cells are even-dimensional, so the Gysin sequences degenerate and
> \(H^*_{\Gm}(W;\Q)\) is a free module over \(H^*(B\Gm;\Q)\), in particular torsion free.

The rest of the remark is correct and I have no objection to it: by the Borel localization
theorem the kernel of `H^*_{Gm}(W) -> H^*_{Gm}(W^{Gm})` is a torsion `H^*(B Gm;Q)`-module,
torsion-freeness then forces injectivity, and the remark is right that freeness alone
would not supply the localization half.

The objection is to the middle step. The Gysin (equivalently Borel-Moore) long exact
sequences of the BB filtration read, for the `j`-th stratum, an affine bundle of rank
`d_j` over the fixed component `F_j`,

```
... -> H^{BM}_*(X_{j-1}) -> H^{BM}_*(X_j) -> H^{BM}_{*-2 d_j}(F_j) -> H^{BM}_{*-1}(X_{j-1}) -> ...
```

Evenness of `2 d_j` shifts the third term by an even amount but does not make it vanish in
any given parity: `H^{BM}_{*-2d_j}(F_j)` is nonzero in odd total degree exactly when `F_j`
has odd cohomology. So the connecting map can be nonzero on parity grounds alone, and
the lacunary argument the sentence invokes does not close. It closes only when the fixed
components have no odd cohomology -- typically when they are points.

This is not a hypothetical gap here. `W` is a completion of a Wlodarczyk cobordism between
two smooth projective birational varieties, and in the paper's own application one endpoint
is `X x P^m` with `X` a smooth cubic threefold, which has `b_3 = 10`. The fixed components
of such a `W` can and generally will carry odd cohomology.

The conclusion is nonetheless true, by either of two standard routes the remark could name:
Frankel's theorem that the moment map of a holomorphic Hamiltonian circle action on a
compact Kahler manifold is a perfect Morse-Bott function (equivalently, the perfection of
the BB decomposition for smooth projective `W`), or the weight-purity argument -- each cell
is an affine bundle over a smooth projective base, so its Borel-Moore homology is pure, the
connecting maps shift weights, and strictness for weights kills them.

Verdict. Required repair, lowest priority, one sentence. The remark asserts a mathematical
fact with an explicit reason, and the reason does not establish it in the stated
generality; the fact itself stands. Nothing else in the manuscript depends on the remark:
`prop:support-collapse` cites it only to explain why the vanishing must come from the
placement of the distinguished insertion rather than from a stronger property of the class,
and the wall vanishing itself is supplied entirely by
`lem:orbit-cylinder-disjoint`(b),(c) together with `def:gauged-admissible`(iv). So this
repair does not touch the proof chain.

### 5.3 Checks that came back clean, with the computation

I record these because they are the places a defect would most plausibly hide, and because
the report is more useful if the negative results are auditable.

**`eq:gamma-index-factor` on both rays.** With `x = alpha_a/zeta`, for `n >= 0`,
`prod_{m=0}^{n}(alpha_a + m zeta) = zeta^{n+1} Gamma(x+n+1)/Gamma(x)`, so the reciprocal is
`zeta^{-n-1} Gamma(x)/Gamma(x+n+1)`, as displayed. For `n <= -2`, the right side is
`zeta^{-n-1} prod_{j=n+1}^{-1}(x+j) = prod_{m=n+1}^{-1}(alpha_a + m zeta)`, exactly
`-n-1` factors, which is `dim H^1(O(n))` on a genus-zero domain; for `n = -1` both sides
are `1`. This is precisely the reading the manuscript stipulates ("For `n<0`, the left side
denotes the Euler class of `H^1`"), so the two degree rays really are given one meromorphic
expression and not two unrelated Gamma products, as claimed.

**`eq:total-moving-slope`.** On a genus-zero domain `chi(O(n)) = n + 1` whether `n >= 0`
(all `H^0`) or `n < 0` (`h^0 = 0`, `h^1 = -n-1`). So the virtual rank of a virtual line of
degree `n_a(k) = h_a k + s_a` is `h_a k + s_a + 1` on both rays and its slope in `k` is
`h_a` with no `sign(n_a)` factor, which is the point the proof makes. Summing is
equivariant Riemann-Roch for the pullback of `T(W/Gm)`; the gauge Lie algebra contributes
slope zero because `Gm` is abelian and its adjoint bundle is trivial, and the fixed part of
the index is constant along a tail by `thm:tailwise-derived`. I also checked the potential
factor-of-stabilizer-order ambiguity between `eq:affine-moving-degree` and
`eq:total-moving-slope`: the proof heads it off explicitly ("slopes are counted per unit of
the primitive affine direction `delta` on both sides of the identity below, while
consecutive degrees inside a tail differ by the stabilizer order"), and in any case only
the vanishing or non-vanishing of `sum h_a` is used downstream, so a positive constant
factor is harmless.

**`eq:simple-gamma-residue`.** `Gamma` has residue `(-1)^m/m!` at `s = -m`; with
`s = h sigma + alpha` the residue in `sigma` picks up `1/h`, giving `(-1)^m/(h m!)`. The
manuscript's gloss on the three factors (factorial = moving-mode Euler factor, `1/h` =
one-character Jacobian, sign = complex orientation) is right, and
`rem:higher-pole-localization-boundary` correctly limits the use to a single simple pole.

**The distributional step.** With `|c_k| <= C k^N (log k)^M` for `k >= 2` and `q > N+2`,
`|b_k| = |c_k| / k^q <= C k^{N-q}(log k)^M` with `N - q < -2`, so `sum |b_k|` converges;
`sum b_k r^k e^{i k theta}` then converges uniformly for `r <= 1` by the Weierstrass test
and its `r = 1` radial limit is continuous in `theta`; `d^q/dtheta^q` multiplies the `k`-th
term by `(i k)^q`, recovering `sum c_k r^k e^{i k theta}` up to the constant `c_0`, which
is smooth and changes nothing; and a `q`-th distributional derivative of a uniform limit of
continuous functions converges in `D'(S^1)` with order at most `q`. The uniformity claim
that follows -- one `q` serves all tails, threshold classes and basis components at a fixed
Artin level -- is legitimate because all of those sets are finite there.

**`lem:orbit-cylinder-disjoint`.** I re-derived the fibre-weight criterion rather than
accepting it. Embedding `W` equivariantly in `P(V)` by sections of a power of `M`, and
writing `v = sum_k v_k` with `t . v_k = t^k v_k`, the limits are `[v_{k_min}]` at `t -> 0`
and `[v_{k_max}]` at `t -> infinity`; the `O(-1)` fibre at `[v_k]` is `C v_k` of weight `k`
so the `O(1)` fibre has weight `-k`; Hilbert-Mumford for the two cocharacters `t` and
`t^{-1}` gives semistability iff `k_min <= 0 <= k_max`. Hence
`mu_M(y_0) = -k_min >= 0 >= -k_max = mu_M(y_infinity)`, which is `eq:gm-weight-criterion`,
with strict inequalities for stability. Then: (a) triviality of the stabilizer from
freeness of the semistable loci, extension of `Gm -> W` to `P^1 -> W` by properness, and
`mu_0(w_0) > 0 > mu_0(w_infinity)` from stability at `L_-` forcing `w_0 != w_infinity`; (b)
affineness of `u |-> mu_u(w)` plus positivity at both ends, and the fact that a fixed
component semistable at `L_u` has `mu_u = 0` there and `mu_u` is constant on it; (c)
nonzero `mu` at `u in {0,1}` making the limits unstable, restriction of an equivariant
Poincare dual to an invariant open being the dual of the intersected cycle, and vanishing on
a closed subvariety disjoint from the cycle. Every clause checks out.

One point worth recording positively, since it is the load-bearing coherence of the whole
construction: because `G = Gm` here, the wall cocharacter `w` generates the full group, so
Gonzalez-Woodward's `X^zeta` is `W^{Gm}` and their `X^{zeta,t}` is the `L_t`-semistable
locus of `W^{Gm}`. On a fixed component, `L_t`-semistability is exactly `mu_t = 0`. That is
verbatim the condition under which `def:gauged-admissible`(iv) demands vanishing and
verbatim the condition under which `lem:orbit-cylinder-disjoint`(b) delivers disjointness.
The two halves of the argument meet exactly.

**`prop:support-collapse` against its sources.** Gonzalez-Woodward Lemma 3.17 states, in
the large-area limit, that a Mundet-semistable fixed map for `L_t` has principal component
mapping to `X^{zeta,t}/G_zeta` and bubbles to `X/G_zeta` -- exactly the sentence the
manuscript builds on. Proposition 3.18 supplies "for some `t` in the interpolation".
Remark 3.19 gives the bubble-tree isomorphism with the fibre product taken over
`(X^zeta)^r`, so the framings are compared in the ambient fixed locus and the principal
factor `M_r^{G_zeta,fr}(C, X^{zeta,t})` is the one carrying semistability; the manuscript's
parenthetical to that effect is correct. Proposition 3.15(c) does place an arbitrary node
or marking only in `P(X^Z)` with no semistability, so the contrast the manuscript draws is
real. QK III Section 9.4 defines the distinguished locus as bundles whose sections are
constant in some trivialization near `B mu_k` with the evaluation taken there and valued in
the inertia stack, which is exactly the manuscript's description; and in the clutching
description the section on a chart is `phi(z^{1/k}) x`, so in the trivialization where it is
constant near that point its value is the generic principal value `x`, which Lemma 9.9 and
Lemma 3.17 place in the semistable locus. QK III equation (68), together with the
summation immediately after it, is the identity `tau_{X//G,-} . kappa^G_X = tau^G_{X,-}`
paired against an arbitrary `alpha_infinity` in `H(I_{X//G})`, so the "distinguished output
slot" language and `eq:endpoint-gauged-maps` as its input-derivative are both accurate.
Corollary 9.10(c) gives the Liouville restriction as `exp(gamma-bar + (d_+ + phi_+, gamma)
zeta)`, which with `gamma = sum_j t_j D_j` and `d-tilde_+ = d_+ + phi_+` is literally
`eq:liouville-character`, including the gloss that `d-tilde_+` is the bubble degree together
with the affine cocharacter degree of the principal component. The character-extraction
step is legitimate: distinct `d-tilde_+` give distinct linear forms by condition (iii), and
exponentials of distinct nonzero linear forms are independent over polynomials in `t`.
Lemma 3.21's proof supplies the master-space fibre factor (see OI4), and the manuscript
does not overclaim from it -- it says outright that the normal complex is not exhibited and
that the normalization is carried by `def:gauged-admissible`(ii).

**`lem:point-insertion-row`.** From `eq:gamma-framed-section` with `E = O_p`,
`ch(O_p) = [pt]`, the top class. `Ghat_Y` and `z^{c_1(Y)}` act by cup product and their
positive-degree parts kill the top class, so both act as the identity there;
`(2 pi i)^{deg/2}` gives `(2 pi i)^n`; `z^{-mu}` gives `z^{-n/2}` since `mu = n/2` on
`H^{2n}`; and `(2 pi)^{-n/2}` is a constant. So
`s_Y(O_p) = c . L_Y(tau,z)[pt]` with `c` invertible and depending only on `n`, `z` and the
conventions. Unitarity of `L_Y` for the twisted pairing then gives, for `v = L_Y alpha`,
`rrow_{Y,p}(v) = (L_Y(e^{-pi i}z) alpha, c L_Y(z)[pt])_Y = c (alpha, [pt])_Y`, and
`(alpha,[pt])_Y` is the degree-zero component of `alpha`, the Poincare point covector. That
is `eq:point-insertion-row`, and the last assertion follows by composing with `D kappa`.
The one input is flagged in the proof and again in `08-scope` item (5). The cancellation of
`c_{dim Y}(z)` in `prop:support-collapse` is legitimate because `Y_-` and `Y_+` are both
quotients of `W` by a one-dimensional group and so have equal dimension.

**Wlodarczyk.** Definition 5 does say "A cobordism `B` is projective if `B` is a
quasiprojective variety", so the manuscript's terminology warning is exactly right and
worth keeping. Proposition 2(B') states the existence of a smooth projective cobordism
between birationally equivalent smooth projective varieties; its proof takes a
`K*`-equivariant projective completion of `L(X,D;X',0)` and then its canonical
`K*`-equivariant resolution, and `B^+/K* ~ X'`, `B^-/K* ~ X`. The manuscript's use of "the
resolved proper equivariant completion constructed in the proof" is therefore accurate.
`L(X,D;X',D') := O_X(-D) ∪_{V x K*} O_{X'}(D')_infinity` is a gluing of two line-bundle
total spaces over smooth varieties along `V x K*`, hence smooth (separatedness is
Wlodarczyk's Lemma 5), so the manuscript's claim that the glued space is smooth is correct,
and functoriality of canonical resolution then makes the resolution an isomorphism over it
-- correctly flagged as a standard property and not part of the cited proposition. The
gluing region is a trivial cylinder `V x K*` over the common open, so the cylinder orbit is
free, as claimed.

**The appendix.** `lem:app-graded-extension` is a clean graded computation and correct:
`psi(A_w) ⊂ (R[z^{±1}])_{aw} = R z^{aw}` forces `psi(f) = x_w(f) z^{aw}`, multiplicativity
of `(x_w)` is equivalent to `x` being a ring map because `z^{aw} z^{aw'} = z^{a(w+w')}`, and
`psi` lands in `R[z]` exactly when `x` kills every `A_w` with `aw < 0`. The attractor
description in `prop:app-one-chart` is right: `f in A_w` satisfies `f(t.x) = t^w f(x)`, so
`lim_{t->0} t.x` exists iff `f(x) = 0` for every `f` of negative weight. The chart-dependence
counterexample on `P^1` is correct as stated (on `Spec C[y]` with `a = +1` no weight space
is killed and no condition is imposed; on `Spec C[y^{-1}]` the coordinate has weight `-1`
and the chart imposes `y^{-1} = 0`; on the overlap the two disagree everywhere), and the
`U_F` refinement genuinely repairs the family form, which is the subtle point. The tangent-
weight sign flip in `lem:app-cech` is right: with `D(A_v) ⊂ A_{v+w}` a tangent vector of
weight `w` acquires `z^{-aw}`, so invariant sections over the chart are the `aw <= 0` half,
and the manuscript's own test case (`W = A^1` with `t.y = t^k y`, `a > 0`, attracting locus
everything, tangent weight `-k`, retained) checks out. `prop:app-mu-k`(b) matches QK III
Definition 9.7 (which requires `phi-tilde(theta^i)` to fix `x`) and equation (55) (whose
inertia map is `(u,x) |-> [x, phi-tilde(theta)]`): with `phi-tilde(t) = t^{b/k}` on the
`k`-fold cover, `phi-tilde(theta) = theta^b`, depending only on `b mod k`. `prop:app-mu-k`
(d) matches QK II Proposition 4.3(g), which states both `I_{X,r} = I_{X,r}/B mu_r` and the
fact that rational cohomology changes only by factors of `r` on `r`-twisted sectors; the
manuscript's `pi_* pi^* ~ id` argument for a `B mu_k`-gerbe and the conservativity deduction
are correct. `prop:app-cutting`(a) is the cotangent triangle of a derived fibre product,
matching QK III equation (35) and the triangle in the proof of Proposition 7.14; (b)'s
"map of triangles with two identity legs and one quasi-isomorphism" argument is valid; (c)
correctly identifies the Gysin data QK II Proposition 5.21 and QK III Proposition 7.14(b)
supply; (d)'s distinction between compatibility of the identifications and compatibility of
the numbers is precise and correct.

**Assumption registers.** I looked specifically for an input used in the primary scope that
appears in neither `def:gauged-admissible` nor `08-scope` item (5). I found none. Each of
the following is registered: the large-area and coefficientwise localization package and the
virtual Kalkman identity with its endpoint normalization, in (ii) and again in item (5);
numerical separation of total equivariant degrees and pointedness of the infinity-side
semigroup, in (iii); the existence and vanishing properties of `a_p`, in (iv); freeness and
stable-equals-semistable at the chamber polarizations, in (i), with the caveat that the
semistable loci are the Wlodarczyk source and sink opens explicitly stated as not proved;
the graph-space normalization input to `lem:point-insertion-row`, in item (5); bistability of
the cylinder orbit, in item (5) (see OI6); ampleness of the two chamber polarizations, only
by the convention attached to the word "polarization" (see OI5). Equality of the two
endpoint dimensions is not an assumption -- it follows from both being quotients of `W` by a
one-dimensional group.

**Strength matching.** I checked the three places where a later step could consume more than
its source proves. `prop:gamma-ratio-reduction` proves a per-graph-coefficient statement and
`prop:clutching-tail-holonomicity` consumes a per-tail statement; the bridge is
`thm:tailwise-derived`, which supplies exactly the degree-shift identification needed, and
the preamble to the subsection establishes that at fixed Artin level and ordinary degree the
number of graph types is finite, so the sum of finitely many `(D)`-finite sequences is
`(D)`-finite and the growth bound is an upper bound under which cancellation is harmless.
`prop:clutching-tail-holonomicity` proves `(D)`-finiteness and tempered radial boundary
values, and `hyp:marked-threshold-wall` consumes exactly "the marked boundary germs of the
two adjacent `(D)`-finite tails constructed in Proposition ..."; everything stronger (finite
local freeness, good Stokes filtration, deck action, the one-object family) is explicitly
part of the hypotheses, and `def:finite-dual-cyclic-rees` says so where the saturation is
introduced. `prop:support-collapse` proves an identity coefficientwise in the extended
Novikov coefficient-function space and explicitly does not construct the common realization;
`thm:birational-point-primary` obtains the common realization from the hypotheses, not from
the proposition. No overreach found.

**Notation.** The two genuinely doubled symbols are `a` and `k` (OI1, OI2). `a_p` is doubled
against the Gu-Yu-Yu wall-local class and is disambiguated in place. `zeta` is doubled
against Gonzalez-Woodward's usage and is disambiguated in place, and I confirmed from their
text that they do write `xi` for the equivariant parameter, so the warning is accurate.
`zeta_6` in `02-point-row.tex` is subscripted and does not collide in practice. Every
`\ref` and `\eqref` in the primary scope resolves to a defined label, and the labels I
sampled point at environments of the kind the citing text names.

## 6. Coverage: what I did not reach or could not verify

- **UNVERIFIED, source not in cache: Mumford-Fogarty-Kirwan, "Geometric Invariant Theory",
  Chapter 2, Section 2.1, Theorem 2.1.** Cited in `lem:orbit-cylinder-disjoint` for the
  numerical criterion. I did not open the book. This costs nothing here, because the
  manuscript does not lean on the locator: it re-derives the `Gm` fibre-weight form
  explicitly from the Hilbert-Mumford weights and the `O(1)` fibre weights, and I checked
  that derivation independently. Verification would require the book or a reliable scan.
- **UNVERIFIED, sources not in cache: Behrend-Fantechi, Graber-Pandharipande,
  Toen-Vezzosi HAG II, Schuerg-Toen-Vezzosi.** Used in the appendix for, respectively, the
  intrinsic normal cone and the realization step in its Section 4; the fixed part of an
  ambient perfect obstruction theory; the cotangent complex of a derived mapping stack;
  and precedent for reading a classical obstruction theory off a derived enhancement. I
  judged these uses from general knowledge of the four papers and found nothing that looked
  misdirected -- in particular, Graber-Pandharipande is the right source for the fixed-part
  statement, and the manuscript pairs it with Gonzalez-Woodward Corollary 3.20 for the
  gauged instance, which I did read and which matches. Verification would mean fetching
  the four papers and reading the named sections.
- **Not audited: `hyp:marked-threshold-wall`, `hyp:marked-threshold-zero`,
  `def:reduced-nearby`, `def:finite-dual-cyclic-rees`, `conj:gamma-window` and its sketch of
  implication, `rem:verification-status`.** These lie outside the primary scope. I read
  them for consistency with the primary scope and found the interfaces to match: what the
  hypotheses say they consume from `prop:clutching-tail-holonomicity` is what that
  proposition proves, and the finite-local-freeness and strictness conditions the
  saturations need are stated as part of the hypotheses at each point of use. I did not
  check the citations inside `rem:verification-status` (Iritani's global toric
  Landau-Ginzburg paper, Coates-Iritani-Jiang Theorems 6.1 and 6.3, Woodward QK II
  Example 5.23), nor the internal consistency of the `Bl_p P^2` calibration.
- **Not audited: Sections 3 through 7 and 9 of the manuscript**, beyond the two
  cross-checks named above (`thm:intro-cubic-conditional` and its proof, and the
  `02-point-row.tex` conventions). Items (1)-(4) and (6)-(9) of `08-scope.tex` were read but
  not judged against their referents.
- **Version caveat on the Woodward locators.** `refs.bib` pins QK II to arXiv v4 and QK III
  to arXiv v7. The cache holds the current arXiv PDFs
  (`arXiv:1408.5864`, sha256 `018530b8...`; `arXiv:1408.5869`, sha256 `5aa794f4...`), fetched
  2026-08-14 from `https://arxiv.org/pdf/1408.5864v4` and `https://arxiv.org/pdf/1408.5869`
  respectively. Every locator I checked in QK III resolved to content matching the
  manuscript's description, including the cross-paper section numbering (QK III begins at
  Section 7 because Sections 1-6 live in QK II), so I saw no version drift. I did not
  diff the fetched QK III bytes against v7 specifically.
- **Not recomputed in detail: `eq:rees-homogeneity`.** It lies past the primary scope. The
  factor `1/2` is consistent with `dim G = 1` and the half-Tate language, and
  `Theta_Q(Q^d) = c_1^{Gm}(TW).d Q^d` is consistent with `eq:rees-substitution`, but I did
  not verify the homogeneity computation for `D kappa` that produces the identity.
