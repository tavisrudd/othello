# C210 Fable sub-agent review (verbatim)

**Lane**: `relconic` (review record; C210 active)

Date: 2026-07-17. Read-only review by a Fable sub-agent of the C210 a!=0 step-1
result ([`2026-07-17-c210-a-nonzero-artin-schreier-form.md`](2026-07-17-c210-a-nonzero-artin-schreier-form.md))
and the proposed step-2 plan, trusting the committed reproducibility logs (no
script reruns). Reproduced verbatim below; orchestrator commentary is kept out
of this file (see the session record / handoff).

---

# C210 review — a!=0 step-1 state and step-2 plan (read-only)

## 1. State check

The step-1 reduction is substantially correct, cleanly certified, and correctly scoped — with one real gap in the uniqueness argument.

**What checks out.** The char-2 quartic theory is used correctly: for `F = tau^4 + B2*tau^2 + Q1*tau + R1`, a (2,2)-split `(tau^2+s*tau+A)(tau^2+s*tau+B)` forces `s^3 + B2*s + Q1 = 0`, and the committed identities `B2 = b^2Q^2 + sigma`, `Q1 = sigma*b*Q` (checker steps 1–2, `analyze_c210_a_nonzero_artin_schreier_form.py` lines 263–277) give exactly `(X+bQ)(X^2+bQ*X+sigma)`. The psi-form identity is verified by direct tau-ring expansion, not just coefficient matching. The depression `tau = aQ*t` is a unit rescaling over K, so "R and F reducible together" is right; and `Q = u^2+u*delta+delta^2` is even rootless over every `GF(8^m)`, odd m (`Q/delta^2 = v^2+v+1`, trace 1), so the rescaling is arithmetically safe at rational points too. The scope statements ("does not prove" lists in both the note lines 88–96 and the script docstring) are accurate.

**The gap.** The uniqueness argument (note line 51–54) covers only linear factors: `tau+phi` gives `beta = phi^2+bQ*phi in K`, a K-root of `Y^2+sigma*Y+R1`, hence D_AS. It does **not** address the third factorization mode: two irreducible quadratic factors with the *alternate* slope `s'`, where `s'` is a root of `X^2+bQ*X+sigma`. Concretely, a Galois element acting as `(r1 r3)(r2 r4)` on the roots fixes the alternate pairing (so `s' = r1+r3` and the products `r1*r3, r2*r4` are all in K) while swapping `A = r1*r2` and `B = r3*r4` — F reducible over K with `R1/sigma^2` AS-nontrivial. As stated, D_AS is not proven to be the whole factorization locus.

**The gap is fillable.** `sigma/(bQ)^2 = a*delta*N*G1*G2a/(b^2*Q^2)` has u-degree-5 numerator over degree-4 denominator, so its partial-fraction polynomial part is `(a*delta*N/b^2)*u + const`. In char 2 an odd-degree polynomial part cannot be `g^2+g` (deg(g^2+g) is 0 or even), so the alternate slope `s'` is **never** in K whenever `a*delta*N*b != 0`. One short addendum (a degree count, no new computation) closes this; it should be added to the note/checker before step 2 builds on the "one divisor" claim. Note it fails exactly at `b=0` — see 2(c).

## 2. Traps / misreadings in the step-2 plan

**(a) Method transfer — mostly favorable, two genuine differences.** The AS class simplifies to `R1/sigma^2 = Q^2*B0/(delta^2*N^2*G1^2*G2a^2)` — structurally parallel to the a=0 `phi = A0*Q^2/(delta^2*G1^2*G2^2)` (b cancels in both; N is u-constant, adding no poles). Helpful transfer fact: `Res(G1, G2a) = Res(G1, G2)` identically, since `G2a = G2 + delta*a*G1` agrees with `G2` at G1's roots — so the merged-pole locus is the same `p^2*K1*K2` as a=0, for free. But two things are new: (i) `Res(G2a, G2a')` is a-dependent, so the simple-root assumption behind the residue formula has a new, uncomputed degeneracy locus (a=0 had the clean `delta^4*p^2`); (ii) `Res(Q, G2a)` (shared Q-root pole cancellation) is likewise a-deformed. Both must be computed before the residue derivation, not inherited. Also check the infinity place: `deg(Q^2*B0)` vs `deg(G1^2*G2a^2) = 10` must leave at most a constant polynomial part, as it did on a=0 — verify, don't assume.

**(b) The a=0 luck will probably not recur.** `W == 0 mod G1` identically was a stratum-wide accident of a=0. On a!=0 expect nonvanishing G1-residue conditions in addition to the G2a ones: up to five residue equations instead of three, with residue-theorem + sqrt-additivity dependencies spanning all of them (the a=0 method notes already showed naive codimension counting fails, and that `minAssGTZ` over GF(2) returned a wrong answer — a=0 report, Method notes). Plan for cross-determinant/h0-linearity methods from the start, and re-verify that the branch conditions are still h1-free and h0-linear — that was an a=0 empirical fact about `A0`, not a theorem, and `B0` is a different polynomial.

**(c) Boundary bookkeeping — one real hole: `b=0` on `a!=0` is unowned.** The a=0 report's boundary ownership ("b=0 owned by the closed a=b=0 stratum") covers only `a=0 ∧ b=0`. On `a!=0, b=0`: `B1 = 0`, the resolvent root is `X=0`, `psi = tau^2` is inseparable (Frobenius), the AS-quadratic criterion in psi no longer describes factorization of F in tau, and the uniqueness fill in section 1 fails. Either an earlier gate provably forces `b!=0` on the shared-(a,b) locus (I found no such statement in the trail), or `b=0, a!=0` needs its own (probably short, degenerate) closure. The other boundaries look genuinely owned: `delta=0` (single-coset), `p=0` (coincident pair), `N=0` (no GF(4) points over odd towers — valid, since Lang–Weil is applied at parameter values in `GF(8^m)`). Flag: the a=0 genuineness witnesses used GF(64), an *even*-tower field where `N=0` points exist; a!=0 witnesses should live in GF(8) or GF(512).

**(d) H=J=0 on a!=0** is correctly listed as unproven, but the step-1 Conclusion ("Lang–Weil forces reconstructible collisions") states it as if settled. The a=0 proof (`H` pulls back to `delta*G1`, rootless over odd towers) is stratum-specific; the a!=0 pullback of `H = DB+AE` has not been computed. It is load-bearing for the off-D_AS half of any closure and must be a named step-2 deliverable, not a footnote.

**(e) "Reducible over K" vs collision semantics — the biggest structural difference from a=0.** On the a=0 divisor D3, the components were **t-linear**, so rational curve points were automatic and genuineness reduced to incidence witnesses. On a!=0, the D_AS components are **tau-quadratics** `tau^2 + bQ*tau + A(u)`: each is itself a degree-2 AS-type cover of the u-line, and rational points on it require a *second-layer* trace condition `Tr(A/(bQ)^2) = 0` pointwise. Consequences the plan doesn't yet state: (i) being on D_AS does not by itself yield collisions — collision-forcing on a branch needs a second Weil/Lang–Weil argument (or explicit split) one level down; (ii) conversely, an arc-legal branch requires the tau-quadratic component to be rootless over the whole odd tower — an arithmetic-emptiness condition of exactly the `tr(theta)=1` flavor, which is where a genuine construction could actually hide. Step 2 should expect a nested analysis (possibly a second AS divisor), not the a=0 pattern of "branch ⇒ explicit rational lines ⇒ witness." Separately, retain the a=0 discipline of distinguishing genuine collisions from coincident-point artifacts via projective incidence, not resultant membership.

## 3. Progress bar

```
a=b=0 stratum closure            [##########] 100%  (census + arc-legality disjointness)
a=0,b!=0 stratum closure         [##########] 100%  (D3 explicit, witnesses, independent verification)
a!=0 step-1 AS reduction         [#########-]  90%  (uniqueness gap fillable; b=0 boundary open)
a!=0 D_AS explicit branches      [#---------] ~5%   (template + parallel pole structure only)
a!=0 legality/genuineness/H=J=0  [----------]   0%  (second-layer analysis not yet scoped)
------------------------------------------------------------------
Overall C210 (two-coset program) [######----] ~60%
```

The overall bar is against closing (or breaking open) the two-coset shared-(a,b) route, which the mechanism audit has established as the surviving frontier of the C210 objective.

## 4. Odds of landing

**~75–80%** that C210 reaches a clean terminal state (proven infinite-family obstruction of this route, or a discovered construction — an arc-legal rootless branch would itself be terminal, and the more exciting outcome). The machinery has now closed two strata with the same template and the a!=0 class has the same pole skeleton, which is strong evidence the residue computation will go through. The dominant risk is not failure but complexity blowup at step 2's second layer: up to five interdependent residue conditions with an extra parameter `a`, followed by per-branch tau-quadratic point analysis that a=0 never needed — a branch that is geometrically split but arithmetically ambiguous could cost another census-and-closure cycle. Secondary risk: the small unowned pieces (`b=0 ∧ a!=0`, the uniqueness addendum, `H=J=0` pullback) being forgotten at closure time; all three are cheap now and expensive later.

**Recommended before step 2 proper:** (1) commit the one-paragraph alternate-slope exclusion (odd polynomial part of `sigma/(bQ)^2`); (2) settle `b=0, a!=0` ownership; (3) compute `Res(G2a,G2a')`, `Res(Q,G2a)`, and the infinity-place balance as the first step-2 preflight.

Files relied on: `/home/tavis/src/othello/notes/handoffs/2026-07-16-relconic-post-c201.md` (Status block, lines 6–12, 230–239), `/home/tavis/src/othello/notes/2026-07-17-c210-a-zero-artin-schreier-divisor.md` (Statement 1–5, Method notes), `/home/tavis/src/othello/notes/2026-07-17-c210-a-nonzero-artin-schreier-form.md` (Statement 1–4, does-not-prove list), `/home/tavis/src/othello/papers/arcs_complete_outside_conic/analyze_c210_a_nonzero_artin_schreier_form.py` (docstring + asserts, lines 246–280).
