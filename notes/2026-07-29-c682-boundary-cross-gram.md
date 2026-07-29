# C682 cross-Gram separator over the Mukai--Umemura boundary

## Outcome

The cross-Gram separator has a canonical boundary extension, but the target
must retain the normalization of the mate correspondence. It does not extend
as a scalar function of the coarse limiting pair of kernel planes.

Let \(W=\operatorname{Sym}^6\) with its apolar form \(B\), and let
\(\mathcal U_D,\mathcal U_S\) be the two tautological rank-three kernel
bundles on a \(D_5\)--\(S_3\) mate component. Put
\[
 g_D=\det(B|_{\mathcal U_D}),\qquad
 g_S=\det(B|_{\mathcal U_S}),\qquad
 c=\det(B|_{\mathcal U_D\times\mathcal U_S}).
\]
Then \(c^2\) and \(g_Dg_S\) are sections of the same line bundle. On the
open icosahedral orbit their ratio is the previous invariant
\(\chi=c^2/(g_Dg_S)\). The homogeneous relation is
\[
 \boxed{\;
 (820125c^2-54781g_Dg_S)^2
   =5\cdot24288^2(g_Dg_S)^2.
 \;}
\]
Consequently the saturated graph coordinate
\[
 [c^2:g_Dg_S]
\]
extends regularly on the normalization of each of the two mate-component
closures and has the constant values
\[
 [\lambda_\pm:1],\qquad
 \lambda_\pm=\frac{54781\pm24288\sqrt5}{820125}.
\]
This is the vector-bundle extension of the separator. Over
\(\mathbf Q(\sqrt5)\) it is the two constant sections; over \(\mathbf Q\)
their union is the golden quadratic algebra.

## Why the coarse scalar cannot extend

Use the one-parameter degeneration \(g(t)=\operatorname{diag}(1,t)\).
Among the six marked \(D_5\)-mates, exactly one dodecic has first nonzero
coefficient \(X^{11}Y\); the other five begin with \(X^{12}\). All ten
\(S_3\)-mates begin with \(X^{12}\). Rank remains four at both monomial
limits, so the kernel bundles specialize to
\[
 U_{\mathrm{div}}
   =\langle X^6,X^5Y,X^3Y^3\rangle,\qquad
 U_{\mathrm{cl}}
   =\langle X^6,X^5Y,X^4Y^2\rangle.
\]
These are precisely the divisor and closed Mukai--Umemura boundary planes.

Their normalized Plücker frames have orders \(4\) and \(3\). Since
\[
 B(g(t)u,g(t)v)=\det(g(t))^6B(u,v)=t^6B(u,v),
\]
the self- and cross-Gram determinant orders are
\[
\begin{array}{c|ccc}
 \text{limit pair}&\operatorname{ord}g_D&
 \operatorname{ord}g_S&\operatorname{ord}c\\ \hline
 (U_{\mathrm{div}},U_{\mathrm{cl}})&10&12&11\\
 (U_{\mathrm{cl}},U_{\mathrm{cl}})&12&12&12.
\end{array}
\]
Thus \(2\operatorname{ord}c-\operatorname{ord}g_D-
\operatorname{ord}g_S=0\) in both cases: the projective ratio has a
finite nonzero limit even though all three displayed determinants vanish.

The unique divisor \(D_5\) row contains five \(\lambda_+\) pairs and five
\(\lambda_-\) pairs, while every \(S_3\) kernel has the same
\(U_{\mathrm{cl}}\) limit. Hence both golden values occur above the same
coarse boundary pair
\[
 (U_{\mathrm{div}},U_{\mathrm{cl}}).
\]
The remaining five \(D_5\) rows similarly collapse to
\((U_{\mathrm{cl}},U_{\mathrm{cl}})\) and contain both values. A regular
function of the limiting pair would have to take one value there, so no
such coarse scalar extension exists. The normalization or saturated graph
is therefore necessary, not just a convenient resolution of a formula.

## Geometric meaning

On the open orbit the two golden relations are the two homogeneous
\(\operatorname{PGL}_2/C_2\) mate components. At the boundary their images
in the product of kernel Grassmannians meet, but their normalized graph
closures remain disjoint over \(\mathbf Q(\sqrt5)\). Thus the correct
global object is an oriented/normalized incidence correspondence, not a
two-colouring of the coarse boundary kernel pair.

This also sharpens the row-swap question. A complementary-fibre involution
cannot be a regular involution detected solely on the coarse pair of kernel
planes, because that pair has already forgotten the sheet at the boundary.
It may still extend as the deck exchange of the normalized graph; deciding
whether that deck exchange agrees with the Schläfli apolar-polar row swap is
the next C682 gate.

## Reproducibility

From `rust/`, run

```text
python3 ../notes/2026-07-29-c682-boundary-cross-gram.py --check
python3 ../notes/2026-07-29-c682-boundary-cross-gram-replay.py
```

The primary checker works exactly over \(\mathbf Q(\zeta_{30})\). It
reconstructs all sixteen mates and kernels from the previous cross-Gram
checker, computes their leading dodecic and Plücker weights, verifies the two
monomial boundary kernels and the vanishing Gram determinants, checks the
golden relation, and exhibits both values over one coarse boundary pair.
Its compact JSON records only the boundary data and hashes both load-bearing
inputs.

The independent replay reconstructs the groups, mates, forms, kernels,
Plücker weights, and cross-Gram values separately over
\(\mathbf F_{61}\) and \(\mathbf F_{151}\). Both fields give the unique
divisor row, the \(4/3\) Plücker orders, the \(10/12/11\) Gram orders, and
five pairs of each golden value over the common divisor--closed limit.

| file | bytes | SHA-256 |
|---|---:|---|
| `2026-07-29-c682-boundary-cross-gram.py` | 8968 | `a7042263e82667c2c575d29dcf45fac665d7d878b4de24a69a0cf1962eefa010` |
| `2026-07-29-c682-boundary-cross-gram-replay.py` | 4349 | `b8addf7b82d6d379ca5d67fd08f32dacca1a9aa0962a3feef2ad098153eb72e9` |
| `2026-07-29-c682-boundary-cross-gram.json` | 2322 | `7709df76a3f11e536f3f5510b6e8daf4c4aee37ffeb278322bb7e67cf9f4f84f` |

The exact computation certifies the stated marked degeneration and
vanishing orders. The line-bundle relation, dense-open extension on each
normalized component, and non-descent argument are human deductions. No
claim is made here about a minimal integral model, normality of an
unspecified coarse scheme, or novelty in the literature. Paper III remains
closed.

## `ej` + `tt` closeout and mystery ledger

- **Closed:** the cross-Gram separator extends over both Mukai--Umemura
  boundary orbits as the graph coordinate \([c^2:g_Dg_S]\) on the
  normalized mate correspondence.
- **Closed negatively:** it does not descend to a scalar on the coarse
  product of kernel Grassmannians. Both golden values lie over the same
  divisor--closed boundary pair, and also over the same closed--closed pair.
- **Closed by `ej`:** the cancellation is exact at the determinant-line
  level: the boundary orders are \(10,12,11\), so the ratio has valuation
  zero. The extension is not an arbitrary limiting prescription.
- **Settled by `tt`:** the homogeneous quadratic relation is the
  coordinate-free object. Asking either vanishing Gram coordinate alone to
  remember the sheet is categorically impossible at the boundary.
- **Cheap consequence:** any global Schläfli row swap must live on the
  normalized graph (or an equivalent oriented enhancement), not on the
  coarse kernel-pair image.
- **Still open:** whether the deck exchange of this normalized graph is the
  same global operation as the apolar-polar Schläfli row swap.
- **Still open:** the minimal integral base and actual bad primes of the
  combined operator/incidence package.

C682 remains open; completion is the user's decision.
