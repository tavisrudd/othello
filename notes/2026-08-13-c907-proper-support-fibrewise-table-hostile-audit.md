# C907 hostile audit: simultaneous-ratio whole-fibre table

**Target:** `2026-08-13-c907-proper-support-fibrewise-table.md`  
**Verdict:** **PASS conditional on the stated exterior chart-descent gate, with
three MINOR precision repairs.**

The protected-ratio row closes the earlier quantifier gap. It uses one
simultaneous projective ratio modification, not a different modification for
each arc. Every point of the proper fibre over the compact double-marked
locus is a limit of an arc in the original graph, and the valuation
trichotomy classifies that arc on that same model. Consequently it is enough
to cover all limiting directions, rather than to prove uniqueness of a limit.

## 1. The whole-fibre argument is valid

Assume `R` is the **reduced strict closure** of the same open graph `G^circ`
in the product of the indicated projective ratio lines, and
`pi_rat:R -> X_0` is its proper projection. Thus
`pi_rat^{-1}(G^circ)=G^circ`, not merely a birationally equivalent open.
For every point `z` of `R`, complex curve selection applied to the closure
of that open gives an analytic arc through `z` whose punctured part lies in
`G^circ`.

For `z` over

\[
 T_{11}=\{\delta=0,\ B=C=1,\ y\in T_y,\ L\in\overline\Omega\},
\]

the arc has positive `delta` order, compact unit `y` limit, and bounded
value. Its ratio coordinates have exactly the following exhaustive status.

1. Both `Z` and `W` are finite: the point is in the bounded residual chart.
2. `Z` has a pole: the exact `Z` trichotomy says either `v=ZW` and
   `h=delta Z` are finite, hence the point is in the finite `Z`-ratio chart,
   or `L` has a pole, or the marked-line limit is exterior.
3. `W` has a pole: the symmetric conclusion puts it in the finite `W`-ratio
   chart, or gives one of the same two exclusions.

Double infinity is included in 2 or 3 and its product ratio is a pole. In
the two excluded alternatives, respectively the `L` coordinate cannot limit
in `overline Omega`, or the regular projective `B`/`C` coordinate cannot
limit to `1`. Thus neither occurs over `T_11`. There is no fourth projective
complement chart: this is the desired all-points-of-the-fibre argument, not
merely a selected-lift statement.

## 2. Why this gives extension-by-zero acyclicity

Two local facts must be said explicitly.

- Near this fibre the original open has no `y`, `B`, or `C` boundary:
  `y` is a torus point and `B=C=1` are retained translated divisors. In a
  finite ratio chart the local extension-by-zero boundary is therefore the
  actual divisor `rh=0`; `v=0` (or `w=0`) is interior.
- The `v` (respectively `w`) vector field is regular and tangent to that
  pair, and its derivative of `L` is a unit. Its local flow supplies a
  product of the labelled pair, so it proves
  \(\phi_{L-u}(j_!A)=0\), not only a Fitting statement. In the bounded
  chart, away from the four relative critical points of `f_Q+ZW`, the same
  argument uses a tangent derivative of `L` along `delta=0`.

Since the proper fibre is compact and is covered by these locally acyclic
neighbourhoods, the support of the ratio-model vanishing-cycle complex misses
the whole fibre over `T_11\setminus\mathscr C`. This establishes the
protected inclusion

\[
 \pi_{\rm rat}(B_{\rm rat})\cap T_{11}\subseteq\mathscr C. \tag{1}
\]

For the iterated object `psi_delta phi_(L-u)`, use these neighbourhoods for
`phi_(L-u)` across the central fibre; restriction to an open commutes with
nearby cycles, so the iterated support has the same exclusion. A
special-fibre-only derivative calculation would not suffice.

## 3. Required minor repairs to the target

1. Replace “the latter two alternatives are impossible” by the two exact
   contradictions above: a pole of `L` conflicts with the chosen closed
   value window, while an exterior marked-line alternative conflicts with
   the fixed coarse equalities `B=C=1`.
2. Insert the local `j_!` pair/product sentence from §2. The existing unit
   calculation supplies it in these charts because `v,w` are retained; it
   should not be left as an inference from a bare derivative.
3. State the strict-closure/dense-open hypothesis on `R` before using curve
   selection. This excludes unwanted components and licenses the
   punctured-arc assertion.

## 4. Exact remaining scope

The exterior row remains conditional, as the target says. The proof still
needs a direct proper exterior map (or an audited diagonal strict closure)
and the finite scheme-chart descent of the 70 tangent lifts. Once that gives

\[
 \pi_{\rm ext}(B_{\rm ext})\subseteq T_{11}, \tag{2}
\]

(1)--(2) give the two-model bad-image separation

\[
 \pi_{\rm ext}(B_{\rm ext})\cap
 \pi_{\rm rat}(B_{\rm rat})\subseteq\mathscr C.
\]

This is a valid proper-support route around the common marked-fan
obstruction. It proves absence of noncore value-cycle support, conditional
on the exterior descent; ranks, labelled iterated cycles, and the
rapid-decay/Gamma comparison remain separate.
