# C1071 — arcs paper upgrades from the Astra full-manuscript review

**Lane**: `relconic`

**Date:** 2026-09-06

**Status:** QUEUED. Order of work is fixed by the user: math first, then paper edits, then
framing/positioning.

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

(To be filled per phase. Each Phase 1 item: PROVED / FAILED / QUALIFIED, with the argument or the
counterexample.)

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
