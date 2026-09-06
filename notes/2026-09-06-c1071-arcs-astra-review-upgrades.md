# C1071 — arcs paper upgrades from the Astra full-manuscript review

**Lane**: `relconic`

**Date:** 2026-09-06

**Status:** DONE (2026-09-06): Phase 1 verified, Phases 2–3 landed in the manuscript. Open:
title decision, math-papers sync, the `PG(3,q)` novelty gap (four inaccessible sources).

## Goal

Verify, sharpen, and integrate the mathematical upgrades proposed in the external Astra review of
`papers/arcs_complete_outside_conic/arcs_complete_outside_conic.tex`, then apply the manuscript
edits and framing changes that survive verification. The q=3 boundary-case correction is already
landed (commit "arcs: add rho_C(3)=3 to the exact small-orders theorem and small-values
proposition"); do not redo it, but confirm the reconstruction-appendix opening sentence carries the
`q >= 4` qualifier.

## Work plan

### Phase 1 — math (verify every claim before any manuscript edit)

Each item gets a written proof or a written counterexample in this card's report section. A claim
that fails is recorded as failed, not silently dropped.

1. **Intrinsic-defect decomposition.** `D(A) := Delta_empty(A)`;
   `Delta_H(A) = D(A) + sum_{y in H, r(y)>0} (1 - r(y)/m)`. Check integrality of `D(A)` via
   `(6/m) binom(k,4)` being an integer for both parities of `k`. Derive the improved gap
   `m Delta_H = 0 or m Delta_H >= m-1` (vs. the manuscript's `m-2`). Check whether `m-1` is
   sharp (need an intrinsically extremal arrangement with a single index-one hole).
2. **Hole-set asymptotic beyond q+1.** From the arbitrary-hole inequality with `h=|H|`,
   `k = sqrt(2q)+a`: expansion `sqrt2 (a-3/2) q^{3/2} + h + O(q) >= 0`. Prove
   `liminf (k - sqrt(2q)) >= 3/2` for `h = o(q^{3/2})` and `>= 3/2 - lambda/sqrt2` when
   `h/q^{3/2} -> lambda`. Handle the rigor step: the first-moment bound gives a lower bound on `a`
   for `h = O(q^{3/2})`; expansion along subsequences with bounded `a`.
3. **Higher-dimensional remainder identity.** For a cap `A` in `PG(n,q)`:
   `sum_{x notin A} binom(r(x),2) = 3 c_4(A)` with `c_4` the coplanar four-subsets. Derive
   `m Delta^{(n)}_H = sum_{x in X_H} (r-1)(m-r) + sum_{y in H} r(m-r)` and the resulting
   cap-complete-outside-`H` inequality. Record explicitly what does not transfer (the Kneser
   graph no longer decomposes into concurrence cliques).
4. **Evaluation obstruction as an equivalence.** For `|A| <= q`: no nonzero `f in V` vanishing on
   `U` and avoiding `A` iff `W=0` or some `ev_a` lies in `span{ev_u : u in U}`. Proof via the
   proper-subspace covering count `1 + |A|(q^{d-1}-1) < q^d`. Confirm the existing
   `check_evaluation_dichotomy.py` matches this statement and its sharp boundary example.
5. **Characteristic-zero realization obstruction.** Hirzebruch's inequality on the
   `binom(k,2)`-line arrangement of a rank-three `MATCH(k, floor(k/2), 1)` realization over `C`:
   `t_2 + t_3 >= d + sum_{r>=5} (r-4) t_r` with `t_d = t_{d-1} = 0`. Verify the multiplicity
   bookkeeping (`k-1` at arc points, `m` elsewhere), the `k >= 8` contradiction, the `k=6`
   numbers (`d=15, t_5=6, t_3=15`, needing `15 >= 21`), and the `t_d=t_{d-1}=0` hypothesis for
   each `k`. Combine with the seven-point nonexistence to get no rank-three realization in
   characteristic zero for `k >= 6`. Confirm the finitely-generated-subfield embedding step.
   Cite the exact Hirzebruch statement used; the inequality is characteristic-zero only.
6. **Ten-point projective uniqueness.** From the lexicographic basis in
   `check_match10_rank_three.py`: `t(t+1)(t^3+t+1)=0`, `x_9=t^3`, arc condition kills `t=0,1`,
   leaving three Frobenius-conjugate solutions. Write the Frobenius argument: every rank-three
   realization of the realizable ten-point design is projectively equivalent to the embedded
   regular `F_8`-hyperoval. Verify against the Gröbner output, not from memory.
7. **Independent-domination bridge.** Graph `Gamma_A` on `U=U(A)` joining `u,v` when line `uv`
   meets `A`. Prove `A cup S` is an arc iff `S` independent, and ordinary complete iff `S` is a
   maximal independent set; minimum completion size is `i(Gamma_A)`. Note that each point of `A`
   contributes a matching (its chord involution).
8. **Coding-dictionary quantitative statements.** Weight-three syndrome fraction at most
   `(q^2-1)/(q^3-1)`; `r(x)` counts weight-two error vectors realizing a syndrome outside `A`.
9. **Reconstruction with errors.** Threshold recovery when `2e < q+1 - binom(k,2)`; works in any
   projective plane.
10. **Quantitative target for a stronger bound.** Record the `eta, epsilon` sufficient condition:
    proportion `eta` of independent secant pairs meeting at `r <= (1-eps) m` gives
    `m Delta_H >= 6 eta eps/(1-eps) binom(k,4)` and
    `liminf (k - sqrt(2q)) >= 3/2 + eta eps/(1-eps)`. This is a research target, not a theorem
    to add; decide whether it belongs in the outlook.

Items 11–16 come from the second brainstorm (higher-dimensional caps, banked below). They are
the largest mathematical block; if Phase 1 confirms them they may warrant their own section or a
successor task rather than an appendix. The literature comparison for 11–15 (free pairs, 4-general
sets, complete-cap lower bounds in `PG(3,q)`) is mandatory before any "improves" claim and follows
`notes/literature-audit-conventions.md`.

11. **Per-secant coplanar count and pencil bound.** `T_ell` = coplanar four-subsets containing
    the secant's endpoints; `sum_ell T_ell = 6 c_4(A)`; pencil identity
    `T_ell = sum_{pi > ell} binom(z_{ell,pi}, 2)` with `sum z = k-2` over `t = theta_{n-2}`
    planes; balanced minimum `B_n(k,q) = t binom(s,2) + s b` for `k-2 = ts + b`; hence
    `c_4(A) >= binom(k,2) B_n(k,q)/6`. Verify the exact second remainder
    `6 c_4 = N B_n + (1/2) sum (z-s)(z-s-1)` and the combined identity (5) with two nonnegative
    slack sources; check it reduces to the planar identity at `n=2`.
12. **Secant-local overlap inequality.** `T_ell = sum_{x in ell \ A} (r(x)-1)`; loss allocation
    `L_ell = sum (r-1)/r`; `L_ell >= max{T_ell/m, T_ell/(T_ell+1)}`; coverage bound (10) and its
    explicit form (11). Verify the equality condition (all nontrivial intersections on `ell` at
    one point).
13. **`PG(3,q)` consequences.** `T_ell >= k-q-3` for all `k >= q+3` (from `binom(z,2) >= z-1`);
    inequality (13); asymptotic (14) `liminf (k - sqrt2 q) >= 1/2 + (3-lambda)/sqrt2`; ordinary
    complete caps constant `1/2 + 3/sqrt2 ≈ 2.6213` vs first-moment `1/2 + sqrt2 ≈ 1.9142`.
    Redo the `q^2`-coefficient expansion independently. Check the `q=13`, `k=21` numerical
    illustration (`2359` vs `2345`). Quadric-hole analogue (16): `k >= sqrt2 q + sqrt2 + 1/2 - o(1)`.
    Then literature: compare with the best published lower bounds for complete caps in `PG(3,q)`
    before any novelty claim.
14. **Dimension `n >= 4` vacuity.** At `k ≍ q^{(n-1)/2}` and `t ≍ q^{n-2}`, `B_n = 0`. Record
    the zero-`c_4` obstructions: normal rational curves, the ternary Golay 11-cap in `PG(4,3)`,
    the 5-cap in `PG(3,2)`. Verify the Golay cap claim (complete, no coplanar quadruple).
15. **Coding formulation.** `A_4(C) = (q-1) c_4(A)` and the local version
    `(q-1) T_ab = #{weight-four codewords with support containing a,b}`. Check the "every
    coefficient nonzero" step uses only no-three-collinear.
16. **Conditional higher-dimensional target.** Inequality (19) for a proportion `eta` of secants
    with `T_ell >= d`, the conditional asymptotic (20), and the Cauchy–Schwarz step (22)
    turning `E T >= gamma q`, `E T^2 <= C q^2` into a positive-proportion statement. Research
    target only; record in the card, decide whether it goes in the outlook.

Items 17–23 are the allocating session's own additions (2026-09-06), not from the reviewer. Each
is a cheap upgrade or a sanity gate on the reviewer's items and is verified under the same rule.

17. **Exact per-secant loss minimum (sharpens item 12).** `L_ell = sum (1 - 1/r)` is a sum of
    a concave function of `r` under the linear constraint `sum (r-1) = T_ell`, `1 <= r <= m`, so
    its minimum concentrates: `floor(T/(m-1))` points at index `m` plus one remainder point.
    Hence `L_ell >= phi_m(T_ell) := floor(T/(m-1)) (m-1)/m + rem/(rem+1)` with
    `rem = T mod (m-1)`. This equals `T/(T+1)` for `T < m-1` and `T/m` at multiples of `m-1`,
    and is strictly larger than `max{T/m, T/(T+1)}` in between. Same cost as (9); replaces the
    `max` in (10)–(11).
18. **Hirzebruch's exact form and the `k=7` case (gates item 5).** The reviewer quotes
    `t_2 + t_3 >= d + sum (r-4) t_r`. Hirzebruch's inequality as usually cited is
    `t_2 + (3/4) t_3 >= d + sum_{r>=5} (r-4) t_r` under `t_d = t_{d-1} = 0` (check whether the
    `3/4` form needs `t_{d-2}=0` as well; here max multiplicity is `k-1 << d`). With the
    `MATCH(k,m,1)` block count `t_m = [binom(d,2) - k binom(k-1,2)] / binom(m,2)`:
    `k=7`: `d=21, t_6=7, t_3=35`, and `(3/4)·35 = 26.25 < 21+14 = 35`, so Hirzebruch alone
    excludes `k=7` (the reviewer's weaker form gives equality `35 >= 35` and does not). If this
    holds, the characteristic-zero statement for `k >= 6` needs no seven-point design input.
    Sanity: `k=4` (`d=6, t_3=4, t_2=3`) is a Hirzebruch equality case; `k=5`
    (`d=10, t_4=5, t_2=15`) is consistent; `k=6` fails with either form. Verify the pair
    count `binom(d,2) = k binom(k-1,2) + t_m binom(m,2)` for each `k` before using `t_m`.
19. **Sharpness of the `m-1` gap (closes item 1).** Any extremal arrangement plus one index-one
    hole attains it: the complete quadrilateral (`k=4, m=2`) gives `m Delta_H = 1`, and the
    embedded regular `F_8`-hyperoval (`k=10, m=5`) gives `4`. No search needed.
20. **Ovoid-complete caps as the `PG(3,q)` headline (frames item 13).** The elliptic quadric is
    an ovoid, i.e. the maximal cap, so "cap disjoint from an ovoid and complete outside it" is
    the exact analogue of the conic-complete arc; the hyperbolic case is secondary. State (16)
    for ovoids first.
21. **Plane-section moment viewpoint on `c_4` (checks item 11).** A coplanar four-subset lies in
    exactly one plane, so `c_4(A) = sum_pi binom(n_pi, 4)` over all planes, while
    `sum n_pi`, `sum binom(n_pi,2) = N theta_{n-2}`, `sum binom(n_pi,3) = binom(k,3)` are
    fixed by `k`. Minimizing the fourth binomial moment under three fixed lower moments gives
    an independent lower bound on `c_4`; at the covering scale in `PG(3,q)` it appears to
    match the pencil bound's leading term `(sqrt2-1)/6 · q^3`. Verify, and check whether the
    exact finite forms differ. Also record the projection form: `c_4` through a point `a`
    equals the number of collinear triples of the projection of `A \ {a}` from `a` into
    `PG(n-1,q)`, which for `n=3` is the minimum-collinear-triples problem for a `(k-1)`-set in
    `PG(2,q)` and may have literature.
22. **Finite sanity checks of (13) against tabulated smallest complete caps.** `q=3`: (13)
    excludes `k=7` (`33 > 31.5`) and allows `8`, which is the tabulated minimum; the first
    moment allows `7`. `q=4`: gives `k >= 9`. `q=5`: gives `k >= 10`, same as the first moment.
    Reproduce these and compare with the Davydov–Marcugini–Pambianco tables for `q <= 9`
    before any claim.
23. **Equality analysis of the `PG(3,q)` bound.** Equality in (12) needs every pencil occupancy
    in `{1,2}` and each secant's collisions at a single point. Two secants `ab, cd` through a
    collision point `x` span a plane, and then `ac` and `bd` meet at a second point `y != x`, so
    `ac` carries its own single collision at `y`; check whether these constraints are
    satisfiable at all for `k > 5`. If not, quantify the forced slack; that is the successor
    question for a sharper constant.

### Phase 2 — paper edits (only for items that passed Phase 1)

Read `papers/style-guide.md` completely first. Propose each new numbered statement to the user before writing it in; prose tightening may be
applied directly.

- Place the intrinsic-defect decomposition and the `m-1` gap immediately after the main identity.
- Generalize the `q+1`-hole specialization to the `h = o(q^{3/2})` and `lambda` statements.
- Promote the evaluation equivalence into the manuscript (currently implicit in the artifacts).
- Add the higher-dimensional identity with its explicit non-transfer caveat.
- Add the characteristic-zero obstruction and the ten-point projective-uniqueness statement to
  the realization appendix.
- Add the independent-domination bridge and the reconstruction-with-errors extension.
- Two wording repairs: retain `k >= 4` in the dual star–matching corollary; "points on secants"
  becomes "points outside `A` on secants" in the coding dictionary.
- Keep "stability" scope precise: deleting secants is not deleting arc vertices; near-bound arcs
  need not have small absolute defect.
- Any new paper-facing computational claim follows
  `notes/research-reproducibility-conventions.md` and the annotation layer in
  `notes/formal-annotation-conventions.md`.

### Phase 3 — framing and artifacts

- Positioning: classical moments → local defect → realizable matching structure → geometric and
  algebraic obstructions. Consider a title foregrounding prescribed-hole secant defects.
- Artifact upgrades (separate decision, not gating the math): export the Singular ideal-membership
  lift coefficients as explicit certificates; consider the order-16 transporter-plus-leaf
  certificate architecture for the odd-order exclusions.
- Framing gem: the realizable ten-point design is a configuration with characteristic set `{2}`
  (empty in characteristic zero by item 5, realizable only over `F_8`-extensions); state it in
  matroid-representability language. Unify the plane and `PG(3,q)` bounds as the two cases of
  one coverage-with-local-corrections theorem where the correction is nonvacuous at the covering
  scale.
- After the acceptance gate: `ej`+`tt` closeout pass and a Mystery ledger in this card.

## Allowed paths

`papers/arcs_complete_outside_conic/**`, this card, the relconic handoff and discovery track, the
queue row and archive row for C1071. Math-papers sync only after user instruction and after reading
`notes/export-and-mirror-conventions.md`.

## Report

### Phase 1 verdicts (2026-09-06, main session; every derivation below was redone by hand
against the manuscript's definitions in Section 3, lines 278–531)

Notation as in the paper: `N = binom(k,2)`, `m = floor(k/2)`, `r(x)` = secants through `x`,
`V_H = Pi \ (A ∪ H)`, `X_H = {x ∈ V_H : r(x) > 0}`, `I_H = sum_{y∈H} r(y)`,
`Delta_H = N(q-1) - (6/m) binom(k,4) - I_H/m - |X_H|`, and the identity
`m Delta_H = sum_{X_H} (r-1)(m-r) + sum_H r(m-r)`. The paper works in an arbitrary projective
plane of order `q`; nothing below uses more.

**Item 1 — intrinsic-defect decomposition and the `m-1` gap: PROVED.**
Put `D(A) = Delta_∅(A) = N(q-1) - (6/m)binom(k,4) - |X_∅|`. Since `X_H = X_∅ \ {y ∈ H : r(y)>0}`,
`Delta_H = D(A) - I_H/m + #{y ∈ H : r(y)>0} = D(A) + sum_{y∈H, r(y)>0} (1 - r(y)/m)`.
Integrality: `(6/m)binom(k,4) = (k-1)(k-2)(k-3)/2` for `k` even (three consecutive integers,
divisible by 6) and `k(k-2)(k-3)/2` for `k` odd (`k-3` even); so `D(A) ∈ Z`, and `D(A) ≥ 0` by
the identity with `H = ∅`. Gap: `m Delta_H = m D(A) + sum_{y∈H, r>0} (m - r(y))`. If `D(A) ≥ 1`
then `m Delta_H ≥ m`. If `D(A) = 0`, the identity forces `r(x) ∈ {1, m}` for every covered
`x ∉ A`, holes included, so each nonzero hole term is `m-1`. Hence `m Delta_H ∈ {0} ∪ [m-1, ∞)`.
Sharpness (item 19): the complete quadrilateral (`k=4, m=2`, diagonal points have index 2, so
`D=0`) with `H` = one index-one point gives `m Delta_H = 1 = m-1`; any matching-design arc with
an index-one hole does the same. Monotonicity of `Delta_H` in `H` is immediate from the
decomposition. This strictly improves Corollary `cor:stability`'s `m-2` gap and separates the two
sources: an intrinsically nonextremal arrangement costs at least `m` (i.e. `D ≥ 1`), an
extremal one costs exactly `m-1` per index-one hole.

**Item 2 — hole sets up to `o(q^{3/2})`: PROVED.**
From Corollary `cor:arbitrary-holes` with `I_H/m` dropped:
`q^2 + q + 1 - k - h ≤ N(q-1) - (6/m)binom(k,4)`. With `k = sqrt(2q) + a`:
`N(q-1) = q^2 + (a - 1/2) sqrt2 q^{3/2} + O(q)` and `(6/m)binom(k,4) = k^3/2 + O(k^2)
= sqrt2 q^{3/2} + O(q)`, the `O(q)` terms being polynomials in `a` times `q`. So
`RHS - LHS = sqrt2 (a - 3/2) q^{3/2} + h + O(q) ≥ 0`, uniformly for `a` in any bounded set.
Rigor: the first-moment inequality `q^2 + q + 1 - k - h ≤ N(q-1)` with `h = O(q^{3/2})` gives
`k^2 ≥ 2q - O(q^{1/2})`, so `a` is bounded below. Along any subsequence with `a` bounded above
the expansion applies and yields `a ≥ 3/2 - λ/sqrt2 - o(1)` when `h/q^{3/2} → λ`; subsequences
with `a → ∞` satisfy the liminf trivially. `λ = 0` covers every `h = o(q^{3/2})`, in particular
every conic, every line, every unital, and every set of `O(q^{3/2 - ε})` points.

**Item 3 — higher-dimensional remainder identity: PROVED.**
For a cap `A` in `PG(n,q)` (any projective space with `q+1` points per line): two secants with
disjoint endpoints meet iff their four endpoints are coplanar, and the meeting point is off `A`
(else three collinear cap points); two secants sharing an endpoint meet only there. Each
coplanar four-subset has three pairings, so `sum_{x∉A} binom(r(x),2) = 3 c_4(A)`, and
`sum r(x) = N(q-1)`, `r(x) ≤ m` are unchanged. The proof of Theorem `thm:defect` uses only these
three facts, so it goes through verbatim with `3 binom(k,4)` replaced by `3 c_4(A)`:
`m Delta^{(n)}_H = sum_{X_H} (r-1)(m-r) + sum_H r(m-r) ≥ 0` where
`Delta^{(n)}_H = N(q-1) - 6c_4(A)/m - I_H/m - |X_H|`. Completeness outside `H` gives
`theta_n - k - h ≤ N(q-1) - 6c_4(A)/m - I_H/m`. What does not transfer: the Kneser-graph
clique decomposition of Section `subsec:matching-design` needs every disjoint secant pair to meet,
which fails for `n ≥ 3`; only the intersecting pairs form concurrence cliques. The decomposition
`Delta_H = D(A) + sum_{H, r>0}(1 - r/m)` also transfers, but `D(A) = N(q-1) - 6c_4/m - |X_∅|` need
not be an integer in `PG(n,q)` (`m | 6c_4(A)` is not automatic), so the improved `m-1` gap does
not transfer: in higher dimension `m D(A) = sum (r-1)(m-r)` is a nonnegative integer whose nonzero
terms are at least `m-2`, and the gap stays at the paper's `m-2`.

**Item 4 — evaluation equivalence: PROVED (statement to be matched to the paper's lemma; sub
extraction pending).**
Let `V` be a finite-dimensional space of forms over `F_q`, `U` a point set, `W = {f ∈ V : f|_U = 0}`,
`d = dim W`. For a point `a`, `ev_a|_W = 0` iff `ev_a` annihilates `W = (span{ev_u})^⊥`, iff
`ev_a ∈ span{ev_u : u ∈ U}` (double annihilator in finite dimension). If `W = 0` or some
`ev_a|_W = 0` there is no avoiding form. Conversely if `d ≥ 1` and every `ev_a|_W ≠ 0`, each
`ker(ev_a|_W)` is a hyperplane of `W`, and `|∪_{a∈A} ker| ≤ 1 + |A|(q^{d-1} - 1)
≤ 1 + q(q^{d-1} - 1) = q^d - q + 1 < q^d` when `|A| ≤ q`; any `f ∈ W` outside the union vanishes
on `U` and at no point of `A`. Sharp: the `q+1` lines through the origin cover `F_q^2`. Over an
infinite field the same holds for every finite `A`. Nonsingularity of an avoiding quadratic is a
separate condition, as the reviewer says.

**Item 7 — independent-domination bridge: PROVED.**
`A` a `C`-complete arc, `U = U(A) ⊆ C` its uncovered locus, `Γ_A` on `U` with `u ~ v` iff the
line `uv` contains a point of `A`. Any `S` with `A ∪ S` an arc and `S ⊆ C` has `S ⊆ U` (covered
conic points lie on a secant). For `S ⊆ U`: triples inside `A` are fine; `a, a', s` collinear
would put `s` on a secant; `s, s', s''` are three conic points; `a, s, s'` collinear iff `ss'` is
an edge. So `A ∪ S` is an arc iff `S` is independent. Completeness of `A ∪ S`: points off
`A ∪ C` and points of `C \ U` are already on `A`-secants; a point `u ∈ U \ S` lies on no
`A`-secant, on no `ss'` (a line meets `C` in at most two points), and on `as` iff `u ~ s`. So
`A ∪ S` is complete iff `S` dominates `U`, i.e. iff `S` is a maximal independent set, and the
minimum number of points completing `A` is the independent domination number `i(Γ_A)`. Each
`a ∈ A` contributes the matching `{u, ι_a(u)}` of its chord involution restricted to `U`
(fixed points of `ι_a`, the tangency points from `a`, give no edge), so `Γ_A` is a union of `k`
matchings and `Δ(Γ_A) ≤ k`; consequently any ordinary completion of `A` inside `C` adds at least
`|U|/(k+1)` points. Even `q`: check the paper's Definition `def:relative` for the nucleus
convention before stating this (sub extraction pending).

**Item 8 — coding dictionary quantitative statements: PROVED (trivial).**
Nonzero syndromes number `q^3 - 1`; each projective point carries `q-1` of them; the points whose
syndromes need weight three are exactly the uncovered points `U ⊆ C`, at most `q+1` of them; so
the fraction is at most `(q+1)(q-1)/(q^3-1)`. A syndrome `s` with `[s] ∉ A` is `αh_i + βh_j`
with `α, β ≠ 0` iff `[s]` lies on the secant `h_i h_j`, and then `(α, β)` is unique; so the
number of weight-two error vectors with syndrome `s` is `r([s])`.

**Item 9 — reconstruction with errors: PROVED.**
`S = Π \ U(A)` is the union of the secants (it contains `A`). A secant meets `S` in `q+1`
points; a non-secant line meets each secant at most once, so meets `S` in at most `N` points. If
`|T Δ S| ≤ e` then secants meet `T` in `≥ q+1-e` points and non-secants in `≤ N+e`, so
`2e < q+1-N` separates them by a threshold, and `A` is recovered from the secant set as in the
coda. Only the projective-plane axioms are used.

**Item 10 — `η, ε` sufficient condition: PROVED (conditional target, not a theorem to add).**
`(r-1)(m-r) = binom(r,2) · 2(m-r)/r ≥ (2ε/(1-ε)) binom(r,2)` when `r ≤ (1-ε)m`, and hole terms
`r(m-r)` are at least as large. If the points with `r ≤ (1-ε)m` carry a proportion `η` of
`sum binom(r,2) = 3 binom(k,4)`, then `m Delta_H ≥ (6ηε/(1-ε)) binom(k,4)`. With `h = O(q)`,
`k = sqrt(2q)+a`, `binom(k,4) = q^2/6 + O(q^{3/2})`, `m = sqrt(q/2) + O(1)`:
`Delta_H ≥ sqrt2 (ηε/(1-ε)) q^{3/2} + O(q)`, and `Delta_H = sqrt2 (a - 3/2) q^{3/2} + O(q)`
(item 2), so `a ≥ 3/2 + ηε/(1-ε) - o(1)`.

**Items 11–12, 17 — pencil bound, secant-local overlap, exact loss minimum: PROVED.**
Fix a secant `ℓ = ab` in `PG(n,q)`. A four-subset `{a,b,c,d}` is coplanar iff `c, d` lie in the
same plane through `ℓ` (the plane `⟨ℓ, c⟩` is unique). The `k-2` other cap points are
partitioned by the `t = theta_{n-2}` planes through `ℓ`, so `T_ℓ = sum_π binom(z_π, 2)` and
`sum_ℓ T_ℓ = 6 c_4(A)`. Minimizing `sum binom(z_π,2)` under `sum z_π = k-2` balances the
occupancies, giving `T_ℓ ≥ B_n(k,q) = t binom(s,2) + sb` for `k-2 = ts + b`, `0 ≤ b < t`; the
identity `binom(z,2) - sz + binom(s+1,2) = (z-s)(z-s-1)/2` summed over the pencil gives
`T_ℓ = B_n(k,q) + (1/2) sum_π (z_π - s)(z_π - s - 1)` with every summand a nonnegative integer
(checked: `s(k-2) - t binom(s+1,2) = t binom(s,2) + sb`). Summing over secants gives (4) and,
substituted into item 3, the three-term identity (5) whose planar case (`t=1`, `s=k-2`,
`B_2 = binom(k-2,2)`, `N B_2 = 6 binom(k,4)`) is the paper's theorem.
Local overlap: `T_ℓ = sum_{x ∈ ℓ \ A} (r(x)-1)` (both sides count secants meeting `ℓ` off `A`).
With `L_ℓ = sum_{x∈ℓ\A} (1 - 1/r(x))`, `sum_ℓ L_ℓ = sum_x (r(x)-1) = N(q-1) - |Y|`, `Y` the
covered locus. Since `1 - 1/r` is concave in `r` and `sum (r-1) = T_ℓ`, `1 ≤ r ≤ m`, the minimum
of `L_ℓ` is at an extreme point: `floor(T_ℓ/(m-1))` points of index `m` and one of index
`rem + 1`, `rem = T_ℓ mod (m-1)`. So `L_ℓ ≥ φ_m(T_ℓ) := floor(T/(m-1))(m-1)/m + rem/(rem+1)`,
which equals `T/(T+1)` for `T ≤ m-1`, equals `T/m` when `(m-1) | T`, and exceeds
`max{T/m, T/(T+1)}` otherwise (e.g. `T = m`: `(m-1)/m + 1/2` versus `1`). Reviewer's (9)–(11)
follow with `max{·,·}` replaced by `φ_m`; the reviewer's equality condition (all collisions of
`ℓ` at one point) is the `T ≤ m-1` case of the extreme point. Covered holes number at least
`I_H/m`, so `|X_H| ≤ N(q-1) - sum_ℓ φ_m(T_ℓ) - I_H/m`.

**Item 13 — `PG(3,q)` consequences: PROVED (math); literature gate open.**
`t = q+1`; for `q+3 ≤ k ≤ 2q+4`, `s = 1`, `b = k-q-3`, `B_3 = k-q-3`. For every `k ≥ q+3`,
`binom(z,2) ≥ z-1` gives `T_ℓ ≥ (k-2) - (q+1) = k-q-3` with no upper restriction, and
`T/(T+1)` is increasing, so `L_ℓ ≥ (k-q-3)/(k-q-2) = 1 - 1/(k-q-2)`. Hence
`|X_H| ≤ N(q - 2 + 1/(k-q-2)) - I_H/m` and, for a cap complete outside `H`,
`theta_3 - k - h ≤ N(q - 2 + 1/(k-q-2)) - I_H/m`. Expansion with `k = sqrt2 q + a`:
`N = q^2 + sqrt2 a q - (sqrt2/2) q + O(1)`, so the right side is
`q^3 + (sqrt2 a - sqrt2/2 - 2) q^2 + O(q)`; with `h = λ q^2 + o(q^2)` the left side is
`q^3 + (1-λ) q^2 + o(q^2)`; comparing gives `a ≥ 1/2 + (3-λ)/sqrt2 - o(1)`. The first moment
gives `a ≥ 1/2 + sqrt2`, so the gain is exactly `1/sqrt2`. Boundedness of `a` below follows
from the first moment as in item 2. Nonsingular quadrics have `q^2 + 1` (elliptic, an ovoid)
or `(q+1)^2` (hyperbolic) points, so `λ = 1` and `k ≥ sqrt2 q + sqrt2 + 1/2 - o(1)` for caps
complete outside a quadric. Checked `q = 13`, `k = 21`: `theta_3 - 21 = 2359 > 2345 = 210·(11 + 1/6)`;
the first moment allows `21` (`210·12 = 2520`).

**Item 14 — `n ≥ 4` vacuity and zero-`c_4` examples: PROVED.**
At `k ≍ q^{(n-1)/2}` and `t = theta_{n-2} ≍ q^{n-2}`, `k-2 < t` for large `q` iff `n ≥ 4`, so
`s = 0` and `B_n = 0`. Normal rational curves have `c_4 = 0` (Vandermonde). A parity-check
matrix of a perfect two-error-correcting code gives a cap with `c_4 = 0` (minimum distance 5:
any four columns independent) that is complete (every syndrome is a combination of at most two
columns): the ternary Golay `[11,6,5]` code gives a complete 11-cap in `PG(4,3)`, the binary
`[5,1,5]` repetition code the 5-frame in `PG(3,2)`. So "complete implies `c_4 > 0`" is false in
general, and any higher-dimensional `c_4` lower bound must exclude these.

**Item 15 — coding formulation: PROVED.**
Four coplanar cap points span a rank-three space, so their dependency space is one-dimensional,
and a zero coefficient would make three of them collinear; hence each coplanar four-subset
carries exactly `q-1` weight-four codewords of `C = ker H`, and every weight-four codeword arises
this way: `A_4(C) = (q-1) c_4(A)` and `(q-1) T_ab = #{weight-four codewords with a, b in the
support}`.

**Item 16 — conditional higher-dimensional target: PROVED as stated (conditional).**
(19) is item 12 with `T_ℓ/(T_ℓ+1) ≥ d/(d+1)` on a proportion `η` of secants. For `n ≥ 4` and
`k = sqrt2 q^{(n-1)/2} + a q^{(n-3)/2}`: `N(q-1-η) = q^n + (sqrt2 a - 1 - η) q^{n-1} + o(q^{n-1})`
(the `-k/2` term in `N` is `O(q^{(n-1)/2})`, lower order for `n ≥ 4`), against
`theta_n - k - h = q^n + (1-λ) q^{n-1} + o(q^{n-1})`, giving `a ≥ (2 - λ + η)/sqrt2`. The
Cauchy–Schwarz step is correct: `E[T 1_{T ≥ μ/2}] ≥ μ/2`, so `μ^2/4 ≤ E[T^2] P(T ≥ μ/2)`.

**Item 18 — Hirzebruch bookkeeping: PROVED, with the exact published form now consulted.**
Source: P. Pokora, "Hirzebruch-type inequalities viewed as tools in combinatorics",
arXiv:1808.09167v4 (2020-12-25), read depth `partial` (Sections 1–2 and Remarks 2.8–2.9; cache
key `arXiv:1808.09167`, SHA-256 `cf208e4b…84faf8`), citing Hirzebruch, "Arrangements of lines
and algebraic surfaces", Arithmetic and Geometry Vol. II (1983), not consulted directly. Two forms:
(3) Theorem 1.5/2.3 (Hirzebruch): `d ≥ 4` lines in `P^2(C)`, `t_d = t_{d-1} = 0`, then
`t_2 + t_3 ≥ d + sum_{r≥5} (r-4) t_r`. This is the form the reviewer quoted.
(5) Remark 2.9 (the variant "usually found in the literature", justified via Miyaoka–Sakai):
`d ≥ 6`, `t_d = t_{d-1} = t_{d-2} = 0`, then `t_2 + (3/4) t_3 ≥ d + sum_{r≥5} (2r-9) t_r`.
Arrangement data for a rank-three realization: the only multiple points of the `d = binom(k,2)`
secants are the `k` arc points (multiplicity `k-1`; no other secant passes through an arc point)
and the design blocks (multiplicity exactly `m`; two blocks cannot share a point since `2m > m`,
and a block point is not an arc point); every disjoint secant pair lies in exactly one block, so
`t_m = (binom(d,2) - k binom(k-1,2)) / binom(m,2)`. Values: `k=4`: `t_3=4, t_2=3`; `k=5`:
`t_4=5, t_2=15`; `k=6`: `t_5=6, t_3=15`; `k=7`: `t_6=7, t_3=35`; `k=8`: `t_7=8, t_4=35`;
`k ≥ 8`: `t_2 = t_3 = 0`. Hypotheses hold for `k ≥ 4` (`d ≥ 6` and `k-1 < d-2`).
With (5): `k=4`: `3 + 3 = 6 ≥ 6` (equality); `k=5`: `15 ≥ 10`; `k=6`: `11.25 ≥ 15 + 1·6 = 21`
false; `k=7`: `26.25 ≥ 21 + 3·7 = 42` false; `k ≥ 8`: `0 ≥ d + (2k-11)k + (2m-9)t_m > 0` false.
With (3) only: `k=6`: `15 ≥ 21` false; `k=7`: `35 ≥ 21 + 2·7 = 35` holds with equality, so
the reviewer's form does NOT exclude `k=7`; `k ≥ 8` false. Conclusion: with form (5), no
rank-three realization of the equality design exists over any field of characteristic zero for
any `k ≥ 6`, by Hirzebruch alone; the seven-point design's abstract nonexistence is not needed
(and covers `k=7` independently if the paper prefers form (3)). Pokora also states that the
`d=6, t_3=4, t_2=3` arrangement (the complete quadrilateral, our `k=4` design) is the unique
real arrangement attaining equality in (3). The `k=6` block/secant incidence is the
duad–syntheme `15_3` (Cremona–Richmond) configuration; the doily is realizable over the reals,
so the obstruction is the six five-fold vertices. Field extension: a realization over a
characteristic-zero field `F` uses finitely many coordinates generating a finitely generated
subfield, which embeds in `C`; the incidence and non-incidence relations are polynomial
equalities and inequalities preserved by the embedding.

**Item 20 — ovoid framing: accepted for Phase 2.** Elliptic quadric = ovoid = maximal cap.

**Item 21 — plane-section moments: PROVED; the pencil bound is the LP optimum at the covering
scale.** In `PG(3,q)` every coplanar four-subset lies in exactly one plane, so
`c_4 = sum_π binom(n_π,4)`; three non-collinear points lie in one plane, so
`sum_π binom(n_π,3) = binom(k,3)`, and `sum_π binom(n_π,2) = N(q+1)`, `sum_π n_π = k theta_2`.
The pencil bound `c_4 ≥ N(k-q-3)/6 = binom(k,3)/2 - N(q+1)/6` is exactly the pointwise
inequality `binom(n,4) - binom(n,3)/2 + binom(n,2)/6 = n(n-1)(n-3)(n-4)/24 ≥ 0` summed over
planes, with equality iff no plane meets `A` in exactly 2 or in at least 5 points. Any LP over
the three fixed moments produces a bound of the form `c_4 ≥ α + β sum n + γ sum binom(n,2)
+ δ sum binom(n,3)` valid pointwise; the pencil inequality touches at `n ∈ {0,1,3,4}`, which is
the support of the LP's extremal distribution at the covering scale (`p_2 = 0` there), so the
two bounds coincide. The LP can only improve on it when planes with five or more cap points
are forced, i.e. well above the covering scale. Sub numerics (C4) are a check on this.

**Item 23 — equality structure of the `PG(3,q)` bound: PARTIAL; necessary conditions derived,
and the `ρ = 2` case excluded.** Write `ρ = k-q-2`. Equality in (13) for an ordinary complete
cap forces: (i) every plane through every secant contains 1 or 2 further cap points, so every
plane meets `A` in at most 4 points; (ii) each secant has exactly one collision point, of index
`ρ`, all its other external points having index 1, so the index spectrum is `{1, ρ}` and
`ρ ≤ m`; (iii) the `N` secants are partitioned into `N/ρ` concurrent blocks of size `ρ`
(so `ρ | N`), and two secants from different blocks are skew (they cannot meet, since a meeting
point would be a second collision); (iv) if `ab, cd` lie in one block then `{a,b,c,d}` is a
coplanar quadrangle and `ac, bd` lie in a second block, `ad, bc` in a third, so the block
relation on disjoint secant pairs is closed under re-pairing; (v) the Diophantine identity
`N(q - 2 + 1/ρ) = theta_3 - k`. For `ρ = 2` (`k = q+4`) condition (iv) says the blocks are the
three perfect matchings of the `K_4`'s of a Steiner system `S(2,4,k)`, and (v) becomes
`2q^3 - 7q^2 - 3q + 24 = 0`, which has no integer root, so equality never occurs at `ρ = 2`.
At `q = 3`, `k = 8`, (iii) already fails (`28/3`). Sub to brute-force (v) with `ρ | N`,
`ρ ≤ m`, `q ≤ 2000` (item 23 numerics). Remaining: whether any `(q,k)` satisfies (iii)–(v)
simultaneously, and if none, how much slack is forced. Successor material, not for this task.

**Item 5 — characteristic-zero obstruction: PROVED (with item 18); genuinely new for
`k ∉ {6, 7, 10}`.** The manuscript currently has: Corollary `cor:six-seven-rigidity` (a) six-arcs
(Desarguesian, zero defect forces characteristic two, `F_4 ⊆ K`, projective uniqueness), (b)
seven-arcs (`Δ_H ≥ 2` in any plane, from Alspach–Heinrich's abstract nonexistence of
`MATCH(7,3,1)`), and Theorem `thm:match-ten-realization` (ten points: realization iff
`char K = 2` and `F_8 ⊆ K`). Nothing for `k ∈ {8, 9} ∪ [11, ∞)`. New statement: for every
`k ≥ 6`, no `MATCH(k, ⌊k/2⌋, 1)` design has a rank-three projective realization
(Definition `def:rank-three-realization`) over a field of characteristic zero. Proof: item 18
(Hirzebruch form (5) for `k = 6, 7`; either form for `k ≥ 8`, where `t_2 = t_3 = 0` makes the
left side vanish), plus the finitely-generated-subfield embedding. Consequence via Theorem
`thm:matching-design` and Corollary `cor:star-matching-realization`: no `k`-arc, `k ≥ 6`, in
`PG(2, K)` with `char K = 0` has zero defect — vacuous as stated because the defect is defined
for finite planes only; the meaningful form is the design-realizability statement above, which
sits naturally next to `thm:match-ten-realization`. Sub check (worklog C2): pair identity and
integrality of `t_m` hold for `k = 4..12`; `t_d = t_{d-1} = t_{d-2} = 0` holds throughout.

**Item 6 — ten-point projective uniqueness: PROVED from the existing certificate; new text.**
The tracked certificate regenerates byte-identically (worklog B1; Singular 4.4.1, 9.6 s). Its
characteristic-two lexicographic basis for the regular-hyperoval design is triangular:
univariate generator `y_9^5 + y_9^4 + y_9^3 + y_9 = y_9(y_9+1)(y_9^3+y_9+1)`, then `x_9 = y_9^3`,
then one monic linear generator in each of the remaining ten unknowns. The arc inequation
`x_9(x_9 - 1) ≠ 0` excludes `y_9 ∈ {0, 1}`, so the saturated ideal is radical and
zero-dimensional with exactly three solutions over `F̄_2`, all with coordinates in `F_8`, and
they form one Frobenius orbit (`t, t^2, t^4` for `t^3 + t + 1 = 0`). Uniqueness argument: any
rank-three realization over `K` (necessarily `char K = 2`, `F_8 ⊆ K`) is carried by an element
of `PGL(3, K)` onto a normalized realization with the four frame points standard, hence onto one
of the three solutions. The paper's converse realizes the design by the regular hyperoval of
`PG(2, 8)` with some labeling; normalizing it gives one of the three solutions, and the other
two are its images under the Frobenius collineations `σ, σ^2` of `PG(2, 8)`, which carry a
conic plus its nucleus to a conic plus its nucleus. All regular hyperovals of `PG(2, 8)` are
`PGL(3, 8)`-equivalent, so the point set of every normalized solution is a regular hyperoval.
Hence every rank-three realization of the regular-hyperoval design over any field is
`PGL(3, K)`-equivalent to the regular hyperoval of `PG(2, 8)` embedded in `PG(2, K)`. This
classifies the arc, not the labeling and not any prescribed conic. No new computation is
needed beyond quoting "exactly three solutions" from the certificate's lex basis, which the
appendix should now state explicitly.

**Item 22 — finite sanity checks: DONE (worklog C1).** For `q = 3..13` the refined bound (13)
and the exact balanced-pencil bound give the same smallest allowed `k`, and both exceed the
first moment by one except at `q = 5, 10` where they tie. `q = 3`: `k ≥ 8`; `q = 4`: `k ≥ 9`;
`q = 5`: `k ≥ 10`; `q = 13`: `k ≥ 22`. Comparison with the tabulated smallest complete caps
awaits the literature part (D1).

**Phase 1 status: every item has a verdict. Failed claims: none. Corrections to the reviewer:
the Hirzebruch form quoted is the weak one (item 18); the `m-1` gap does not transfer to
`PG(n,q)` (item 3); the two "minor wording repairs" and the `q ≥ 4` repair are already in the
manuscript (worklog A3, A5, A6), so no edit is needed for them.**

### Phase 2 proposal — new numbered statements (awaiting the user's choice; 2026-09-06)

Placement and shape for each surviving Phase 1 item. Prose tightening and the two already-landed
wording repairs need no decision. Each entry: proposed label, placement, one-line statement,
and what it costs.

1. `prop:intrinsic-defect` (after Theorem `thm:defect`, Section 3). `D(A) = Δ_∅(A)` is a
   nonnegative integer, `Δ_H(A) = D(A) + Σ_{y∈H, r(y)>0}(1 - r(y)/m)`, `Δ_H` is monotone in
   `H`, and `mΔ_H(A) ∈ {0} ∪ [m-1, ∞)`. Replaces the unlabelled `m-2` gap display after
   Corollary `cor:stability` (the corollary itself stays). Half a page.
2. `thm:large-hole-asymptotic` (Section 5 beside Theorem `thm:asymptotic`, or as a corollary
   of `cor:arbitrary-holes` in Section 3). For arcs complete outside `H` with
   `|H|/q^{3/2} → λ`: `liminf(k - √(2q)) ≥ 3/2 - λ/√2`; in particular `3/2` whenever
   `|H| = o(q^{3/2})`. Generalizes `thm:asymptotic`'s liminf clause; the explicit finite
   bound `√(2q) + 3/2 - 8/√(2q)` stays as the conic case. Half a page.
3. `lem:evaluation-equivalence` (replace or extend Lemma `lem:evaluation-obstruction`,
   Section 8.1). Over `F_q` with `|A| ≤ q` the two obstructions are also necessary; sharp at
   `|A| = q+1`; over infinite fields for every finite `A`. Ten lines; the existing
   `check_evaluation_dichotomy.py` becomes the cited check for the boundary example.
4. `thm:char-zero-obstruction` (Section 7, after Theorem `thm:match-ten-realization`). For
   every `k ≥ 6`, no `MATCH(k, ⌊k/2⌋, 1)` design has a rank-three projective realization over
   a field of characteristic zero. Proof by Hirzebruch's inequality (Pokora's form (5)) with
   the multiplicity bookkeeping; new citations: Hirzebruch 1983, Pokora arXiv:1808.09167. Two
   thirds of a page. Remark: the `k = 4` design is the unique real equality case of the weak
   form; the `k = 6` block–secant incidence is the Cremona–Richmond configuration.
5. `cor:ten-point-uniqueness` (immediately after `thm:match-ten-realization`). Every
   rank-three realization of the regular-hyperoval design is `PGL(3,K)`-equivalent to the
   regular hyperoval of `PG(2,8)`; the appendix gains one sentence recording that the
   characteristic-two lexicographic basis has exactly three solutions, one Frobenius orbit.
   Quarter page, no new computation.
6. `prop:independent-domination` (Section 5, conic specialization, or the conclusion). For a
   `C`-complete arc, `A ∪ S` (`S ⊆ C`) is an arc iff `S` is independent in `Γ_A`, and an
   ordinary complete arc iff `S` is a maximal independent set; the minimum completion size is
   `i(Γ_A)`, and `Γ_A` is a union of the `k` chord-involution matchings, so at least
   `|U|/(k+1)` points are needed. Half a page.
7. `prop:noisy-reconstruction` (coda, after `prop:arc-reconstruction`). Threshold recovery of
   the secants and `A` from any `T` with `|T Δ (Π \ U(A))| ≤ e` when `2e < q + 1 - binom(k,2)`,
   in any projective plane. Quarter page.
8. Higher-dimensional section (new Section between the conic specialization and the
   conclusion, or an appendix; the user decides the weight). Contents, in order:
   `thm:cap-defect-identity` (item 3, with `c_4(A)`); `prop:pencil-bound` (item 11:
   `T_ℓ ≥ B_n(k,q)`, the exact pencil remainder, and the three-term identity);
   `thm:secant-local-coverage` (items 12, 17: `|X_H| ≤ N(q-1) - Σ_ℓ φ_m(T_ℓ) - I_H/m`);
   `cor:pg3q-complete-caps` (item 13: the finite inequality for `k ≥ q+3` and
   `liminf(k - √2 q) ≥ 1/2 + (3-λ)/√2`, with the ovoid case `λ = 1`); a remark on `n ≥ 4`
   vacuity with the Golay and frame examples (item 14) and the coding identity
   `A_4(C) = (q-1) c_4(A)` (item 15); and the conditional target (item 16) plus the equality
   necessary conditions (item 23) as an open problem in the conclusion. Two to three pages.
   Novelty wording for the `PG(3,q)` constant is gated on the literature part (D1).
9. Coding-dictionary sentence (introduction paragraph at L212–219): one sentence giving the
   weight-three syndrome fraction `≤ (q^2-1)/(q^3-1)` and `r(x)` as the weight-two
   multiplicity. Two lines, no numbered statement.
10. Conclusion: replace or extend the open problems with the quantitative target
    (item 10: a positive fraction of second-moment mass at multiplicity `≤ (1-ε)m` gives
    `3/2 + ηε/(1-ε)`) and the higher-dimensional program (lower bound on `c_4` plus
    concentration control over secants).

**User decision (2026-09-06):** items 1–5 and 8–10 as numbered statements; 6 and 7 as remarks.

Framing (Phase 3, no decision needed yet): title candidates foregrounding prescribed-hole
secant defects; the progression classical moments → local defect → matching structure →
geometric and algebraic obstructions in the introduction's key-idea paragraph; the
characteristic-set-`{2}` remark for the ten-point design.

### Phase 2 and 3 status (2026-09-06): LANDED

Manuscript commit: "arcs: C1071 upgrades — …" on `main`. Build: `check_manuscript_build.py`
PASS, 35 pages (was 27), warning-free; expected page count updated in the checker. Landed:
`prop:intrinsic-defect` (Section 3), `thm:large-holes` (Section 5), converse clause of
`lem:evaluation-obstruction` (Section 8.1), `cor:ten-point-uniqueness` and
`thm:char-zero-obstruction` (equality-classification appendix, after
`thm:match-ten-realization`), `rem:independent-domination` (end of Section 5),
new Section `sec:caps` (cap defect identity, pencil bound, secant-local coverage theorem with
`φ_m`, `PG(3,q)` corollary with the ovoid case, `n ≥ 4` remark with Golay/frame examples and
Pavese's equality cases, coding identity, conditional target), `rem:noisy-reconstruction`
(coda), the coding-dictionary sentence (introduction), a new introduction paragraph and two
abstract sentences (Phase 3 framing), and three conclusion problems (quantitative planar target,
higher-dimensional `c_4` program, `PG(3,q)` equality). New bibliography entries: Hirzebruch
1983, Pokora 2020, Farr–Lisoněk 2006, Pavese 2023, Bartoli–Davydov–Kreshchuk–Marcugini–Pambianco
2016. Novelty sentence for the `PG(3,q)` constant lives in the proof-audit ledger row
"C1071 (2026-09-06)" and is quoted once in `sec:caps`, with "to our knowledge" load-bearing
because four sources could not be accessed (Davydov–Faina–Marcugini–Pambianco J. Geom. 2009,
Hirschfeld–Storme 1998/2001, Hirschfeld–Thas FFA 2014).

Not done, by design: title change (user's call; candidates: "Prescribed-hole secant defects of
arcs and caps", "Secant defects with prescribed holes: arcs, caps, and matching designs");
math-papers sync (needs the user's instruction and `notes/export-and-mirror-conventions.md`);
the artifact upgrades from the review's item 8 (Singular lift coefficients as certificates,
order-16 transporter architecture for odd orders) — separate allocation if wanted.

### `ej`+`tt` closeout pass

Done cheaply during the task: the concave exact loss `φ_m` (strictly better than the reviewer's
`max`); Hirzebruch's strong form removing the seven-point design input; free-pair and 4-general
citations tying `T_ℓ = 0` and the zero-`c_4` examples to the literature; the `q = 3` tightness
check; the ρ = 2 equality exclusion.

What Tao would ask, and the answers:
- Is the secant-local gain a change of summation order plus one local constraint? Yes:
  `L = Σ_x (r-1) = Σ_ℓ L_ℓ` and `r(x) ≤ T_ℓ + 1` for `x ∈ ℓ`. In the plane `T_ℓ` is uniform and
  ≈ `q`, so the constraint is vacuous; the gain exists exactly when `T_ℓ` is small relative to
  `m`, i.e. in `PG(3,q)` at the covering scale. A per-point version `r(x) ≤ 1 + min_{ℓ∋x} T_ℓ`
  is the same information.
- Does the plane-section moment problem give more? No: the pencil bound is the LP optimum up to
  `k ≈ 2q+2` (sub C4, and the pointwise-inequality proof in item 21).
- Is the bound attainable? Item 23: strong necessary conditions; `ρ = 2` never; general case
  open and logged as a problem in the paper and an Ergodis lead in the discovery track.
- What about the `I_H/m` term for an ovoid? Not bounded below here; every secant meets an ovoid
  in at most two points, so `I_H ≤ 2N`, and the term is `O(q^{3/2})`, below the `q^2` scale of
  the constant. No leverage at this order.

### Mystery ledger

1. **Known smallest complete caps in `PG(3,q)` sit near `2.7q`, the bound near `1.41q`.**
   Exact values `8, 12, 17` at `q = 3, 5, 7` and smallest known `30, 36` at `q = 11, 13`
   (secondary-only through arXiv:1610.09656), against the bound's `8, 10, 13, 19, 22`. Tight
   only at `q = 3`. The literature (same source) says constructions near `√2 q` are known only
   for `q` even. Whether `t_2(3,q)/q → √2` for odd `q` is not settled by anything consulted.
   Evidence gap: Davydov–Faina–Marcugini–Pambianco 2009 (inaccessible). Owner: none allocated.
2. **Attainability of the `PG(3,q)` secant-local bound.** Necessary conditions derived
   (item 23); no example and no proof of non-attainment beyond `ρ = 2`. Owner: successor task
   if the user allocates it; Ergodis lead logged.
3. **Settled by the pass:** the reviewer's Hirzebruch form (weak form quoted; strong form
   needed for `k = 7`); the LP-equals-pencil coincidence (pointwise inequality
   `n(n-1)(n-3)(n-4) ≥ 0`); the `m-1` gap's failure in higher dimension (non-integrality of
   `D`); the ten-point uniqueness (three Frobenius-conjugate solutions were already in the
   certificate).
No other genuine mystery remains.

## Source: Astra review, verbatim

> I reviewed the full manuscript, including the appendices, and inspected the small odd-order
> classifier, the ten-point realization checker, and the evaluation-dichotomy checker. I found one
> definite boundary-case error, but no apparent error in the central defect identity or the main
> equality arguments. I did not rerun Lean, Singular, or the exhaustive classifications, so my
> assessment of the computational results is of their mathematical contracts and implementation
> logic, not an independent replay.
>
> The strongest opportunities are not just additional applications: several stronger statements
> already follow from the machinery you have. In particular, the discrete defect gap improves, the
> hole-set asymptotic extends substantially beyond q+1 points, the higher-dimensional remainder has
> a direct formulation, and the realization discussion connects to a uniform characteristic-zero
> obstruction.
>
> **1. Corrections and qualifications**
>
> The reconstruction appendix has a counterexample at q=3. The opening of the reconstruction
> appendix says that its strict hypothesis cannot hold for a \(\mathcal C\)-complete arc, because
> the first-moment inequality implies \(\binom{k}{2}\ge q+1\). That assertion fails at q=3. The
> reconstruction proposition itself is unaffected.
>
> In \(\mathrm{PG}(2,3)\), take \(A=\{(1,0,0),(0,1,0),(0,0,1)\}\) and
> \(\mathcal C: X^2+Y^2+Z^2=0\). The secants of A are the three coordinate lines. Consequently,
> U(A) consists precisely of the four projective points with all coordinates nonzero. Since every
> nonzero square in \(\mathbf F_3\) is 1, these are exactly the points of the displayed nonsingular
> conic. Thus A is \(\mathcal C\)-complete, but \(q+1=4>3=\binom{k}{2}\).
>
> The simplest repair is to qualify the appendix's opening assertion by \(q\ge4\). Indeed, if
> \(\binom{k}{2}\le q\), then \(q^2-k\le \binom{k}{2}(q-1)\le q(q-1)\) forces \(k\ge q\). For
> \(q\ge4\), that contradicts \(\binom{k}{2}\le q\).
>
> This example also supplies the missing small value \(\rho_{\mathcal C}(3)=3\).
>
> Two minor wording repairs: explicitly retain \(k\ge4\) in the dual star–matching corollary, and
> change "points on secants" to "points outside A on secants" in the coding dictionary, where coset
> weight two is intended.
>
> **2. Strengthen the defect theory before adding more examples**
>
> Separate intrinsic defect from the cost of declaring points exempt. Put
> \(D(A):=\Delta_{\varnothing}(A)\). Directly from your definition,
> \[\Delta_{\mathcal H}(A)=D(A)+\sum_{y\in\mathcal H,\ r(y)>0}\left(1-\frac{r(y)}m\right).\]
> This is a useful companion to the local remainder. It separates a property of the secant
> arrangement itself from the additional contribution caused by the prescribed hole set. In
> particular, defect is monotone under enlarging \(\mathcal H\). The formula requires neither
> relative completeness nor conic geometry.
>
> There is an immediate improvement to the stated discrete gap. Observe that D(A) is an integer,
> because \(\frac6m\binom{k}{4}\) equals \((k-1)(k-2)(k-3)/2\) for k even and \(k(k-2)(k-3)/2\)
> for k odd.
>
> If D(A)>0, then D(A)\ge1, so \(m\Delta_{\mathcal H}\ge m\). If D(A)=0, every covered point has
> index 1 or m; therefore every nonzero term in the displayed hole contribution equals (m-1)/m.
> Hence, for \(m\ge2\), \(m\Delta_{\mathcal H}=0\) or \(m\Delta_{\mathcal H}\ge m-1\).
>
> This improves the manuscript's m-2 gap. More informatively, it distinguishes two sources of
> nonzero defect: an intrinsically nonextremal arrangement costs at least 1, whereas an
> intrinsically extremal arrangement can acquire a smaller positive defect through index-one holes.
> I would put this decomposition immediately after the main identity.
>
> The 3/2 correction survives much larger hole sets. The headline specialization to q+1 prescribed
> holes understates the range of the asymptotic argument. Starting from your arbitrary-hole
> inequality and dropping \(I_{\mathcal H}/m\), let \(h=|\mathcal H|\), \(k=\sqrt{2q}+a\). For
> bounded a, the relaxed capacity minus the required number of points expands as
> \(\sqrt2\left(a-\frac32\right)q^{3/2}+h+O(q)\). It must be nonnegative.
>
> Consequently, for any sequence of complete-outside-\(\mathcal H\) arcs with \(h=o(q^{3/2})\),
> one obtains \(\liminf_{q\to\infty}(k-\sqrt{2q})\ge\frac32\). More generally, if
> \(h/q^{3/2}\to\lambda\), then \(\liminf(k-\sqrt{2q})\ge\frac32-\frac{\lambda}{\sqrt2}\).
>
> For rigor, the first-moment bound supplies a lower bound on a whenever \(h=O(q^{3/2})\); one
> then applies the expansion along any subsequence on which a is bounded above.
>
> This gives a natural scaling interpretation: \(q^{3/2}\), rather than q, is the hole-count scale
> at which this particular constant correction starts to deteriorate. It broadens the result to
> arbitrary exceptional sets far larger than conics.
>
> **3. The higher-dimensional defect identity is already available**
>
> For a cap \(A\subseteq\mathrm{PG}(n,q)\), define \(c_4(A)\) as the number of coplanar
> four-subsets of A. Then \(\sum_{x\notin A}r(x)=\binom{k}{2}(q-1)\) still holds, while the second
> moment becomes \(\sum_{x\notin A}\binom{r(x)}2=3c_4(A)\). The reason is exact: two secants with
> disjoint endpoints intersect if and only if their four endpoints are coplanar, and each coplanar
> four-subset has three pairings.
>
> Thus define
> \(\Delta_{\mathcal H}^{(n)}=\binom{k}{2}(q-1)-\frac6m c_4(A)-\frac{I_{\mathcal H}}m-|X_{\mathcal H}|\).
> Your pointwise calculation gives
> \(m\Delta_{\mathcal H}^{(n)}=\sum_{x\in X_{\mathcal H}}(r(x)-1)(m-r(x))+\sum_{y\in\mathcal H}r(y)(m-r(y))\).
> In particular, a cap complete outside \(\mathcal H\) satisfies
> \(\frac{q^{n+1}-1}{q-1}-k-h\le\binom{k}{2}(q-1)-\frac6m c_4(A)-\frac{I_{\mathcal H}}m\).
>
> This is a direct extension of the manuscript's counting proof, not a conjectural analogy. The
> important qualification is that the entire Kneser graph no longer decomposes into concurrence
> cliques: only the subgraph corresponding to intersecting independent secant pairs does. The
> local nonnegativity and multiplicity stability survive; the full matching-design conclusion does
> not transfer unchanged.
>
> The difficult higher-dimensional problem is therefore to control \(c_4(A)\), not to find the
> remainder identity. That is a much more specific research target. For quadric holes, it also
> combines directly with the evaluation-space obstruction already used in the paper.
>
> **4. Upgrade the evaluation obstruction to an equivalence**
>
> Let \(W=\{f\in V:f|_U=0\}\), \(\phi_a=\operatorname{ev}_a|_W\). A form vanishing on U and
> avoiding A exists precisely when W contains a nonzero vector outside
> \(\bigcup_{a\in A}\ker\phi_a\).
>
> Over \(\mathbf F_q\), when \(|A|\le q\), the two obstructions in your lemma are necessary as
> well as sufficient: no nonzero \(f\in V\) vanishes on U and avoids A iff \(W=0\) or
> \(\operatorname{ev}_a\in\operatorname{span}\{\operatorname{ev}_u:u\in U\}\) for some
> \(a\in A\).
>
> To prove the missing direction, suppose \(d=\dim W\ge1\) and every \(\phi_a\) is nonzero. Then
> \(|\bigcup_{a\in A}\ker\phi_a|\le1+|A|(q^{d-1}-1)\le q^d-q+1<q^d\). So an avoiding form exists.
>
> The finite-field threshold is sharp for general evaluation systems: q+1 one-dimensional
> subspaces cover \(\mathbf F_q^2\). Over an infinite field, the equivalence holds for every finite
> A. These are instances of the standard proper-subspace covering result.
>
> Your repository already contains check_evaluation_dichotomy.py, including the common-zero
> estimate and the sharp boundary example. I would promote that result into the manuscript rather
> than leave it implicit in the artifacts.
>
> This matters computationally: throughout the range \(|A|\le q\), linear algebra gives a complete
> test for existence of an avoiding form in V, not merely a rejection test. It does not by itself
> guarantee that an avoiding quadratic is nonsingular; that remains a separate condition.
>
> **5. Broaden the realization results using line arrangements**
>
> A uniform characteristic-zero obstruction. Suppose a rank-three realization of
> \(\operatorname{MATCH}(k,\lfloor k/2\rfloor,1)\) exists over \(\mathbf C\). Consider the
> arrangement of the \(d=\binom{k}{2}\) secant lines. Its intersection multiplicities are k-1 at
> the original arc points and \(m=\lfloor k/2\rfloor\) at all other multiple intersections.
>
> Hirzebruch's inequality for a complex line arrangement with \(t_d=t_{d-1}=0\) says
> \(t_2+t_3\ge d+\sum_{r\ge5}(r-4)t_r\). Here \(t_r\) counts points incident with exactly r
> arrangement lines.
>
> For \(k\ge8\), there are no double or triple intersections, so the left side is zero and the
> right side is positive—a contradiction. For k=6, the predicted arrangement has d=15, \(t_5=6\),
> \(t_3=15\), which would require \(15\ge21\), again impossible. Combining this with the
> nonexistence of the seven-point matching design used in your paper gives: no such rank-three
> realization exists in characteristic zero for \(k\ge6\).
>
> This extends from \(\mathbf C\) to any characteristic-zero field: the finitely many coordinates
> generate a finitely generated subfield that embeds into \(\mathbf C\).
>
> That would substantially broaden the realization appendix and connect the paper to line
> arrangements and matroid representability. The characteristic restriction is essential; this
> inequality must not be applied indiscriminately over finite fields.
>
> The ten-point computation appears to support projective uniqueness. The classical
> characteristic-two lexicographic basis in check_match10_rank_three.py does more than force an
> \(\mathbf F_8\) subfield. It expresses every normalized coordinate in terms of \(t=y_9\), with
> \(t(t+1)(t^3+t+1)=0\), \(x_9=t^3\). The arc condition \(x_9(x_9-1)\ne0\) excludes t=0,1,
> leaving \(t^3+t+1=0\). All remaining coordinates are uniquely determined.
>
> Thus, subject to the same Gröbner-basis verification already used by the theorem, there are
> exactly three normalized solutions, related by Frobenius. Since a regular
> \(\mathbf F_8\)-hyperoval supplies one solution, and its unordered point set is Frobenius
> invariant, this supports the stronger conclusion: every rank-three realization of the realizable
> ten-point design is projectively equivalent to the embedded regular \(\mathbf F_8\)-hyperoval.
>
> The short Frobenius argument should be written explicitly. This would classify the underlying
> arc realization, though not the prescribed disjoint conics.
>
> **6. Identify the quantitative target for a genuinely stronger lower bound**
>
> The manuscript correctly distinguishes the small conic-incidence correction from the much larger
> universal overlap correction. I would make the next obstacle equally explicit: excluding zero
> defect, or proving a constant positive defect, cannot improve the asymptotic additive constant.
>
> For a \(\mathcal C\)-complete arc with \(k=\sqrt{2q}+a\), a=O(1), the defect satisfies
> \(\Delta_{\mathcal C}=\sqrt2(a-\frac32)q^{3/2}+O(q)\). Therefore an improvement of the constant
> requires a lower bound of order \(q^{3/2}\) on defect.
>
> Here is a precise sufficient geometric condition. Suppose a proportion at least \(\eta>0\) of
> the independent secant pairs meet at points with \(r(x)\le(1-\varepsilon)m\), where
> \(\varepsilon>0\). The proportion is measured by secant pairs, not by concurrence points. For
> such a point, \((r-1)(m-r)=\frac{2(m-r)}r\binom r2\ge\frac{2\varepsilon}{1-\varepsilon}\binom r2\).
> Hole contributions are at least this large. Hence
> \(m\Delta_{\mathcal H}\ge\frac{6\eta\varepsilon}{1-\varepsilon}\binom{k}{4}\).
> Near \(k=\sqrt{2q}+O(1)\), this would imply
> \(\liminf(k-\sqrt{2q})\ge\frac32+\frac{\eta\varepsilon}{1-\varepsilon}\).
>
> That is a concrete research objective: prove that rank-three geometry forces a positive fraction
> of the second-moment mass to occur at multiplicities bounded away from m.
>
> Also keep the scope of "stability" precise. Deleting secants is not the same as deleting arc
> vertices, and the surviving arrangement is not necessarily a complete matching design. Moreover,
> an arc near the rounded numerical lower bound need not have small defect in the absolute sense
> needed to make the deletion bound useful.
>
> **7. Applications that can be stated as theorems**
>
> Ordinary completion becomes an independent-domination problem. For a \(\mathcal C\)-complete
> arc, put \(U=U(A)\subseteq\mathcal C\). Define a graph \(\Gamma_A\) on U by joining distinct
> u,v when the line uv contains a point of A. Then \(A\cup S\) is an arc iff \(S\subseteq U\) is
> independent in \(\Gamma_A\). Indeed, a point of U cannot lie on an old secant; three points of S
> cannot be collinear because they lie on a nonsingular conic. The only remaining obstruction is a
> collinear triple consisting of one old and two new points.
>
> More strongly, \(A\cup S\) is an ordinary complete arc iff S is a maximal independent set of
> \(\Gamma_A\). Every point outside U is already covered or selected. A point of \(U\setminus S\)
> becomes covered exactly when it has a neighbour in S.
>
> Thus the minimum number of added points is the independent domination number \(i(\Gamma_A)\).
> This gives an exact bridge from relative to ordinary completeness and turns the chord involutions
> into a concrete graph algorithm: each point of A contributes a matching to \(\Gamma_A\).
>
> The coding dictionary yields quantitative statements. For the parity-check code described in the
> introduction, every projective deep-hole syndrome lies in \(U(A)\subseteq\mathcal C\).
> Consequently, the fraction of nonzero syndrome vectors requiring weight three is at most
> \(\frac{(q-1)(q+1)}{q^3-1}=\frac{q^2-1}{q^3-1}\). This is a statement about uniformly counted
> syndromes, not a channel-specific decoding error probability.
>
> Also, for a fixed syndrome whose projective point is outside A, r(x) is exactly the number of
> weight-two error vectors realizing it. Each secant gives a unique solution on its pair of column
> positions. The defect therefore quantifies the distribution of weight-two decoding
> multiplicities, rather than merely the locations of deep holes.
>
> Reconstruction is robust to a bounded number of errors. Write \(S=\Pi\setminus U(A)\),
> \(N=\binom{k}{2}\), and suppose an observed set T satisfies \(|T\triangle S|\le e\). A genuine
> secant contains at least q+1-e points of T; a nonsecant contains at most N+e. Therefore
> \(2e<q+1-N\) still permits exact recovery of the secants by a threshold, followed by recovery of
> A. This extends the appendix to a finite-geometric reconstruction problem with errors. Its proof
> also works in arbitrary projective planes, not only Desarguesian ones.
>
> **8. Verification and presentation priorities**
>
> The main mathematical arguments I checked—the moment combination, concurrency counts,
> matching-design leave argument, conic order spectra, characteristic-two involution argument,
> averaging transfer, and reconstruction proposition—appear internally sound. The small-design
> classifications retain their explicitly stated external inputs.
>
> For the artifacts, the most useful improvements would be: export explicit algebraic
> certificates. The Singular checker verifies ideal-membership lifts, but the persisted summary
> records hashes, sizes, and denominator-prime information rather than the lift coefficients
> themselves. Saving those coefficients would allow the characteristic exclusions to be checked by
> a much smaller polynomial-arithmetic verifier without recomputing a Gröbner basis.
>
> Use the order-16 certificate architecture for the odd-order exclusions. Covering lists with
> projective transporters, followed by six uncovered points with an invertible quadratic evaluation
> matrix at each leaf, would sharply reduce dependence on the classifier implementation. Your
> existing augmentation contract already supplies the mathematical framework.
>
> For positioning, I would emphasize the progression classical moments → local defect →
> realizable matching structure → geometric and algebraic obstructions. That is more distinctive
> than the scalar 3/2 correction alone. A title foregrounding prescribed-hole secant defects would
> also better advertise the actual generality.
>
> My revision priority would be: repair the q=3 assertion; add the intrinsic-defect decomposition,
> stronger gap, and evaluation equivalence; then add the higher-dimensional identity and
> characteristic-zero obstruction. Those changes strengthen the paper's mathematical scope without
> requiring new exhaustive searches.

## Source: second brainstorm on controlling `c_4(A)`, verbatim

(The brainstorm's opening percentile self-assessment is omitted at the user's instruction.)

> **2. Controlling c_4(A): a stronger answer than the original formulation**
>
> The useful direction is a lower bound on c_4(A), because coplanar quadruples subtract from
> coverage capacity. But the investigation produces a more useful refinement: count coplanar
> quadruples through each individual secant, not only their total.
>
> This gives an explicit lower bound on c_4(A) in every dimension, and a stronger coverage bound
> in dimension three. In particular, the argument below proves that ordinary complete caps in
> \(\mathrm{PG}(3,q)\) satisfy \(k\ge \sqrt2\,q+\frac12+\frac3{\sqrt2}-o(1)\). The additive
> constant is approximately 2.6213, compared with approximately 1.9142 from the exact
> first-moment bound.
>
> The inequalities below have proofs here. I have not established their literature priority or
> that they improve the best published bounds. The relevant existing framework includes caps with
> free pairs and 4-general sets.
>
> Setup. Let A be a k-cap in \(\mathrm{PG}(n,q)\), \(n\ge2\). Write \(\theta_j=1+q+\cdots+q^j\),
> \(N=\binom{k}{2}\), \(m=\lfloor k/2\rfloor\). For \(x\notin A\), let r(x) count the secants
> through x. Let c_4(A) count the coplanar four-subsets of A. As previously noted,
> \(\sum_{x\notin A}r(x)=N(q-1)\), \(\sum_{x\notin A}\binom{r(x)}2=3c_4(A)\). The second
> identity holds because two secants with disjoint endpoints intersect exactly when those four
> endpoints are coplanar.
>
> For a hole set \(\mathcal H\) disjoint from A, the higher-dimensional defect is therefore
> \(\Delta_{\mathcal H}=N(q-1)-\frac{6c_4(A)}m-\frac{I_{\mathcal H}}m-|\mathcal X_{\mathcal H}|\),
> with precisely the same nonnegative local remainder as in the plane. The question is how much
> information geometry forces into the c_4 term.
>
> **3. A universal lower bound from plane pencils**
>
> Fix a secant \(\ell=ab\). Define \(T_\ell=\#\{\text{coplanar four-subsets of }A\text{ containing }a,b\}\).
> Then \(\sum_{\ell}T_\ell=6c_4(A)\). (1)
>
> There are \(t=\theta_{n-2}\) planes through \(\ell\). For each such plane \(\pi\), put
> \(z_{\ell,\pi}=|(A\setminus\{a,b\})\cap\pi|\). Every remaining cap point belongs to exactly one
> of these planes. Consequently, \(\sum_{\pi\supset\ell}z_{\ell,\pi}=k-2\),
> \(T_\ell=\sum_{\pi\supset\ell}\binom{z_{\ell,\pi}}2\). (2)
>
> Write \(k-2=ts+b\), \(0\le b<t\), and define \(B_n(k,q)=t\binom{s}{2}+sb\). The sum in (2) is
> minimized when the occupancies differ by at most one. Thus every secant satisfies
> \(T_\ell\ge B_n(k,q)\), and therefore \(c_4(A)\ge \frac16\binom{k}{2}B_n(k,q)\). (3)
>
> This is the exact minimum permitted by the occupancy constraints of a single pencil. It does not
> assert that all pencils can simultaneously attain that minimum in a realizable cap.
>
> There is also an exact second remainder. The elementary identity
> \(\binom z2-sz+\binom{s+1}{2}=\frac{(z-s)(z-s-1)}2\) gives
> \(6c_4(A)=NB_n(k,q)+\frac12\sum_{\ell}\sum_{\pi\supset\ell}(z_{\ell,\pi}-s)(z_{\ell,\pi}-s-1)\). (4)
> Every summand is nonnegative, because the occupancies are integers. Equality holds exactly when
> every pencil occupancy lies in \(\{s,s+1\}\).
>
> This fits the paper's organizing principle particularly well: the geometric correction itself
> has a nonnegative local remainder. Indeed, defining
> \(\widehat\Delta_{\mathcal H}=N(q-1)-\frac{NB_n(k,q)}m-\frac{I_{\mathcal H}}m-|\mathcal X_{\mathcal H}|\),
> we obtain
> \(m\widehat\Delta_{\mathcal H}=\sum_{x\in\mathcal X_{\mathcal H}}(r(x)-1)(m-r(x))+\sum_{y\in\mathcal H}r(y)(m-r(y))+\frac12\sum_{\ell}\sum_{\pi\supset\ell}(z_{\ell,\pi}-s)(z_{\ell,\pi}-s-1)\). (5)
>
> There are now two separate sources of slack: nonextremal concurrence multiplicities, and
> unbalanced plane pencils. For n=2, t=1, the pencil remainder vanishes and
> \(NB_2(k,q)=6\binom{k}{4}\). Thus (5) genuinely recovers the original planar identity.
>
> Specialization to three dimensions. In \(\mathrm{PG}(3,q)\), t=q+1. When \(q+3\le k\le2q+4\),
> the balanced occupancies are 1 and 2, with \(B_3(k,q)=k-q-3\). Hence
> \(c_4(A)\ge\frac{\binom{k}{2}(k-q-3)}6\). (6)
> At the covering scale \(k=\sqrt2\,q+O(1)\), this says
> \(c_4(A)\ge(\frac{\sqrt2-1}{6}+o(1))q^3\). That is already the right order to improve the
> additive constant in a three-dimensional coverage bound.
>
> The threshold has an established interpretation: \(\{a,b\}\) is a free pair exactly when
> \(T_{ab}=0\). The classical free-pair bound in dimension three is \(k\le q+3\). Formula (6)
> supplies a quantitative count beyond that threshold.
>
> **4. Retaining the local counts gives a stronger coverage inequality**
>
> Substituting (6) into the old defect inequality is not the strongest use of the information.
> The following argument retains the individual \(T_\ell\).
>
> Let \(Y=\{x\notin A:r(x)>0\}\) be the entire covered locus outside A, and define the overlap
> loss \(L=N(q-1)-|Y|\). Allocate that loss among the secants by
> \(L_\ell=\sum_{x\in\ell\setminus A}\frac{r(x)-1}{r(x)}\). A point of index r contributes r-1
> in total, so \(L=\sum_\ell L_\ell\). (7)
>
> On a fixed secant, \(T_\ell=\sum_{x\in\ell\setminus A}(r(x)-1)\). (8) Both sides count the
> other secants that meet \(\ell\) outside A.
>
> For any \(x\in\ell\setminus A\), \(r(x)\le T_\ell+1\). Using (8),
> \(L_\ell\ge\frac{T_\ell}{T_\ell+1}\). Also, \(r(x)\le m\) gives \(L_\ell\ge\frac{T_\ell}{m}\).
> Therefore \(L\ge\sum_\ell\max\{\frac{T_\ell}{m},\frac{T_\ell}{T_\ell+1}\}\). (9)
>
> The first term recovers the previous \(6c_4/m\) correction. The second is genuinely additional
> information. Its meaning is simple: a secant with many intersections must lose almost one full
> point of effective coverage, even when those intersections are maximally concentrated.
>
> Equality in \(L_\ell\ge T_\ell/(T_\ell+1)\) requires all nontrivial intersections on \(\ell\)
> to occur at a single point. Thus this improvement has its own useful equality condition.
>
> Prescribed holes. The number of covered hole points is at least \(I_{\mathcal H}/m\). Combining
> this with (9) yields
> \(|\mathcal X_{\mathcal H}|\le N(q-1)-\sum_\ell\max\{\frac{T_\ell}{m},\frac{T_\ell}{T_\ell+1}\}-\frac{I_{\mathcal H}}m\). (10)
> Since \(T_\ell\ge B_n(k,q)\), a completely explicit consequence is
> \(|\mathcal X_{\mathcal H}|\le N(q-1-\max\{\frac{B_n(k,q)}m,\frac{B_n(k,q)}{B_n(k,q)+1}\})-\frac{I_{\mathcal H}}m\). (11)
> This is a stronger higher-dimensional coverage theorem than simply replacing \(\binom{k}{4}\)
> by c_4(A).
>
> **5. Concrete consequences in \(\mathrm{PG}(3,q)\)**
>
> For every integer \(z\ge0\), \(\binom z2\ge z-1\). Applying this in a plane pencil gives
> \(T_\ell\ge k-q-3\). Unlike the exact balanced formula, this weaker estimate needs no upper
> restriction on k. Therefore, whenever \(k\ge q+3\),
> \(|\mathcal X_{\mathcal H}|\le\binom{k}{2}(q-2+\frac1{k-q-2})-\frac{I_{\mathcal H}}m\). (12)
> For a cap complete outside \(\mathcal H\), with \(h=|\mathcal H|\),
> \(q^3+q^2+q+1-k-h\le\binom{k}{2}(q-2+\frac1{k-q-2})-\frac{I_{\mathcal H}}m\). (13)
> This is a finite, directly usable inequality—not just an asymptotic statement.
>
> The asymptotic correction. Suppose \(h=\lambda q^2+o(q^2)\) for a fixed \(\lambda\ge0\).
> Dropping the hole-incidence term in (13) gives
> \(\liminf_{q\to\infty}(k-\sqrt2\,q)\ge\frac12+\frac{3-\lambda}{\sqrt2}\). (14)
> To see the constant, put \(k=\sqrt2\,q+a\), with a bounded. Then
> \(\binom{k}{2}(q-2+\frac1{k-q-2})=q^3+(\sqrt2\,a-\frac{\sqrt2}{2}-2)q^2+O(q)\). The required
> locus has size \(q^3+(1-\lambda)q^2+o(q^2)\). Comparing the \(q^2\) coefficients proves (14).
> The first-moment bound supplies the needed lower bound on a; subsequences on which
> \(a\to+\infty\) need no further argument.
>
> For ordinary complete caps, \(\lambda=0\), so \(k\ge\sqrt2\,q+(\frac12+\frac3{\sqrt2})-o(1)\),
> constant 2.621320... (15). The first moment alone gives the constant
> \(\frac12+\sqrt2=1.914213\ldots\). Thus the secant-local argument improves it by \(1/\sqrt2\).
>
> Direct analogue of the conic application. A nonsingular quadric in \(\mathrm{PG}(3,q)\) has
> \(q^2+O(q)\) points: \(q^2+1\) in the elliptic case and \((q+1)^2\) in the hyperbolic case.
> Consequently, a cap disjoint from such a quadric and complete outside it satisfies
> \(k\ge\sqrt2\,q+\sqrt2+\frac12-o(1)\). (16) This is a direct higher-dimensional counterpart of
> the paper's motivating problem.
>
> As a small numerical illustration, at q=13 the first-moment inequality does not exclude an
> ordinary complete 21-cap. But (13) does: \(\theta_3-21=2359\),
> \(\binom{21}{2}(11+\frac16)=2345\). Hence the refined inequality forces \(k\ge22\). This
> illustrates the arithmetic improvement; it is not a claim about the best known lower bound at
> that order.
>
> **6. What changes in dimensions four and higher?**
>
> The same pencil argument remains valid, but its useful density range changes. At the natural
> covering scale, \(k\asymp q^{(n-1)/2}\), whereas a secant belongs to
> \(t=\theta_{n-2}\asymp q^{n-2}\) planes. For \(n\ge4\), \(k-2<t\) for sufficiently large q.
> Consequently, \(B_n(k,q)=0\). The universal pencil estimate then becomes vacuous at the
> small-cap covering scale. This precisely locates the limitation rather than leaving "control
> c_4" as an unspecified problem.
>
> Positive c_4 cannot be demanded without qualifications. Normal rational curves provide caps
> with c_4=0: any four of their points are linearly independent, as follows from the Vandermonde
> argument. Even ordinary completeness has exceptional zero-c_4 examples. The 11-cap in
> \(\mathrm{PG}(4,3)\) associated with the ternary Golay code is complete and has no coplanar
> quadruples. The corresponding binary example is the 5-cap in \(\mathrm{PG}(3,2)\). These are
> the perfect two-error-correcting cases appearing in the 4-general-set packing equality. These
> examples do not prevent stronger asymptotic theorems under completeness. They do prevent an
> indiscriminate assertion that every complete cap has positive c_4.
>
> The coding formulation is exact—and more informative locally. Let H have projective
> representatives of a spanning cap as columns, and let \(C=\ker H\). Every coplanar quadruple
> supports a one-dimensional space of dependencies. Because no three cap points are collinear,
> every coefficient in such a dependency is nonzero. Thus \(A_4(C)=(q-1)c_4(A)\), (17) where
> \(A_4(C)\) is the number of weight-four codewords. More locally,
> \((q-1)T_{ab}=\#\{\text{weight-four codewords whose support contains }a,b\}\). (18)
> Therefore the useful invariant is not merely the weight-four coefficient of the weight
> enumerator. It is the distribution of weight-four supports over coordinate pairs. That is a
> substantive coding-theoretic formulation of the higher-dimensional problem. It also connects
> directly with free pairs, whose avoidance of coplanar quadruples has been studied for
> applications to fractional factorial designs.
>
> **7. A precise quantitative target for the remaining higher-dimensional work**
>
> The secant-local inequality suggests a stronger target than "prove c_4(A) is large." Suppose
> at least a proportion \(\eta\) of the secants satisfy \(T_\ell\ge d\). Then (10) immediately
> gives \(\theta_n-k-h\le N(q-1-\eta\frac d{d+1})-\frac{I_{\mathcal H}}m\) (19) for a cap
> complete outside \(\mathcal H\). This statement is valid in every dimension.
>
> For fixed \(n\ge4\), suppose \(h=\lambda q^{n-1}+o(q^{n-1})\), and a proportion at least
> \(\eta-o(1)\) of secants have \(T_\ell\ge d(q)\), where \(d(q)\to\infty\). Expanding (19)
> gives the conditional conclusion
> \(\liminf_{q\to\infty}\frac{k-\sqrt2\,q^{(n-1)/2}}{q^{(n-3)/2}}\ge\frac{2-\lambda+\eta}{\sqrt2}\). (20)
> The first-moment coefficient is \((2-\lambda)/\sqrt2\). Thus a positive proportion of secants
> with growing collision counts yields an explicit improvement at the next asymptotic order.
> What remains to prove is the geometric hypothesis on that proportion. Equation (20) is not
> being asserted unconditionally.
>
> How a c_4 estimate could establish that hypothesis. Choose a secant uniformly at random and
> write \(T=T_\ell\). By (1), \(\mathbb E T=\frac{6c_4(A)}N\). Suppose one could prove, for the
> relevant complete caps, \(\mathbb E T\ge\gamma q\), \(\mathbb E T^2\le Cq^2\), (21) with
> fixed positive \(\gamma,C\). Then \(\Pr(T\ge\frac{\gamma q}{2})\ge \frac{\gamma^2}{4C}\). (22)
> For completeness, this follows directly from Cauchy–Schwarz. With \(\mu=\mathbb E T\),
> \(\mathbb E[T\,\mathbf1_{\{T\ge\mu/2\}}]\ge\frac\mu2\), so
> \(\frac{\mu^2}{4}\le\mathbb E T^2\,\Pr(T\ge\mu/2)\).
>
> Thus the concrete higher-dimensional program becomes: a lower bound on c_4(A) plus an upper
> bound on concentration among secants. A large total c_4(A) alone may be concentrated on
> relatively few pairs. The second condition is what turns that total into a stronger coverage
> theorem.
>
> Assessment of the resulting upgrade. The strongest addition is not merely the
> higher-dimensional remainder identity. It is the chain plane-pencil occupancies → \(T_\ell\) →
> c_4(A) and local overlap → coverage bounds. For dimension three, that chain already produces
> explicit theorems and a quadric-hole application. In higher dimensions, it identifies both why
> the elementary bound stops working and what quantitative replacement would suffice.
>
> I would therefore sharpen my earlier statement to: the higher-dimensional problem is to force
> sufficiently many coplanar quadruples, sufficiently well distributed over the secants. The
> total c_4(A) is the first statistic, but the secant-local profile is the more powerful one.
