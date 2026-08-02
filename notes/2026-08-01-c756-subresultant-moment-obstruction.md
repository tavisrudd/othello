# C756 — subresultant and defect-two moment obstruction

**Lane**: `clebsch` · **Date**: 2026-08-01 · **Scope**: research only

## Verdict

Both Tao-pass attacks proposed after the direct Segre comparison fail in
their unweighted form.

First, the repeated-intercept function is indeed carried by the first
subresultant of

\[
 \mathcal H(U,T)=\prod_{i=1}^n(U+x_iT-y_i),
\]

but its coefficients do **not** inherit the forced Moore factor
\(T^q-T\).  They cannot: at each of at least \(q-\delta\) uniquely represented
directions, the first subresultant is a nonzero linear polynomial whose root
is the unique repeated intercept.  Only the square of the residual factor
\(E_P(T)\) is forced.  After dividing by \(E_P^2\), the two coefficient
degrees remain \(\Theta(n^2)=\Theta(q)\), not \(O(\delta)\).

Second, defect two supplies the exact power-sum identities

\[
 \sum_{i<j}t_{ij}^m=r^m+s^m
 \qquad(1\le m\le q-2),                                    \tag{1}
\]

where \(r,s\) are the two residual roots, repeated when the residual divisor
is double.  These identities do not by themselves exclude either fibre
shape.  Explicit affine six-arcs over \(\mathbb F_{13}\) realize both two
double directions and one triple direction, and satisfy (1) for all allowed
\(m\), hence in particular for \(m=1,2,3,4\).

Thus neither the raw first subresultant nor the global slope moments retain
the missing conic-external input.  The next credible nonsaturated carrier is
the **dual conic-weighted pencil**: chord poles are internal points forming a
defect-\(\delta\) near-transversal of the pencil through \(\ell^\perp\).
That formulation retains both direction and intercept while exposing the
quadratic character geometrically.

A simultaneous branch audit found a separate omission in the prior frontier:
the saturated-internal family \(k=(q+3)/2\) is still open beyond the known
four-frame at \(q=5\).  The saturated-external proof does not transfer to it.
Consequently this pass closes two proposed repairs inside the nonsaturated
branch only; it does not leave a single open branch for the full theorem.

## 1. Exact first-subresultant formula

Put

\[
 \rho_i(T)=y_i-x_iT,
 \qquad
 \mathcal H(U,T)=\prod_i(U-\rho_i(T)).
\]

For each \(i\), let

\[
 \Delta_i(T)=
 \prod_{\substack{a<b\\a,b\ne i}}
 \bigl(\rho_a(T)-\rho_b(T)\bigr).                          \tag{2}
\]

The standard Vandermonde-minor expression for the first subresultant is,
up to a common nonzero scalar and the harmless global sign convention,

\[
 \operatorname{Sres}_1(\mathcal H,\mathcal H_U)
 =A(T)U+B(T),                                               \tag{3}
\]

where

\[
 A(T)=\sum_i\Delta_i(T)^2,
 \qquad
 B(T)=-\sum_i\rho_i(T)\Delta_i(T)^2.                       \tag{4}
\]

Formula (4) can also be characterized directly.  Suppose \(t\) is a
direction containing one chord, with endpoints \(a,b\), and repeated
intercept \(\rho_a(t)=\rho_b(t)=\rho\).  Every summand in (4) vanishes except
the terms omitting \(a\) and \(b\).  Their squared Vandermonde minors agree,
so in odd characteristic

\[
 A(t)U+B(t)=2\Delta_a(t)^2(U-\rho)\ne0.                    \tag{5}
\]

Consequently \(-B(t)/A(t)=\rho\), as required.

Equation (5) is also the decisive obstruction to Moore division:

\[
 T^q-T\nmid A(T),B(T).                                     \tag{6}
\]

The coefficients are nonzero at every uniquely represented rational
direction, rather than zero there.

## 2. What does divide: exactly the residual scale

At a direction \(t\) containing \(\mu_t\) chords, those chords form a
matching.  Each \(\Delta_i\) omits at most one endpoint and therefore retains
at least \(\mu_t-1\) vanishing root differences.  Each difference has a
simple zero in \(T\), so

\[
 \operatorname{ord}_t A,
 \operatorname{ord}_t B\ge2(\mu_t-1).                     \tag{7}
\]

Since

\[
 E_P(T)=c\prod_t(T-t)^{\mu_t-1},
\]

(7) gives the uniform factorization

\[
 \boxed{E_P(T)^2\mid A(T),B(T).}                           \tag{8}
\]

This is the correct subresultant shadow of defect localization.  It is not a
Moore shadow.

Because each \(\rho_i\) is linear,

\[
 \deg A\le(n-1)(n-2),
 \qquad
 \deg B\le(n-1)(n-2)+1.                                   \tag{9}
\]

After the forced factor in (8),

\[
 \begin{aligned}
 \deg(A/E_P^2)&\le(n-1)(n-2)-2\delta,\\
 \deg(B/E_P^2)&\le(n-1)(n-2)+1-2\delta.                   \tag{10}
 \end{aligned}
\]

Using \(q=\binom n2-\delta\), the first bound exceeds \(q\) by

\[
 \frac{n^2-5n+4-2\delta}{2}.                              \tag{11}
\]

At defect two this is \(n(n-5)/2\), positive from the first case \(n=6\)
onward.  Reduction modulo \(T^q-T\) can replace a polynomial representative
by one of degree below \(q\), but it supplies no \(O(\delta)\) rational
function and no useful Weil scale.

The bounds in (9)--(10) are attained by both exact defect-two examples in
§4: their \((A,B)\) degrees are \((20,21)\), and after division by \(E_P^2\)
the degrees are \((16,17)\).  Thus direction coverage itself forces no
additional cancellation beyond (8).

## 3. The full slope-moment package

At defect two, the multiset of all \(\binom n2=q+2\) chord directions is

\[
 \mathbb F_q\sqcup\{r,s\},                                \tag{12}
\]

with \(r=s\) in the triple-direction case.  For
\(1\le m\le q-2\), the finite-field power sum vanishes:

\[
 \sum_{t\in\mathbb F_q}t^m=0.
\]

Therefore (12) gives (1).  The first four equations are

\[
 \begin{aligned}
 \sum_{i<j}t_{ij}&=r+s,\\
 \sum_{i<j}t_{ij}^2&=r^2+s^2,\\
 \sum_{i<j}t_{ij}^3&=r^3+s^3,\\
 \sum_{i<j}t_{ij}^4&=r^4+s^4.                             \tag{13}
 \end{aligned}
\]

These are exact but globally symmetric: they remember the direction
multiset and forget which edge of \(K_n\) carries which direction, as well as
the intercept of that edge.  The explicit realizations below show that this
loss is fatal even after the arc condition is retained.

## 4. Both defect-two shapes occur for affine arcs

Over \(\mathbb F_{13}\), the six points

\[
 (0,0),(1,0),(2,1),(3,4),(4,10),(5,1)                    \tag{14}
\]

determine all thirteen directions.  Directions \(0\) and \(10\) occur
twice, on the disjoint edge pairs

\[
 0:(01),(25),
 \qquad
 10:(03),(15),                                             \tag{15}
\]

and every other direction occurs once.  The four moment values are

\[
 10,9,12,3,
\]

equal respectively to \(0^m+10^m\) for \(m=1,2,3,4\).

The six points

\[
 (0,0),(1,0),(4,1),(10,1),(2,2),(12,2)                   \tag{16}
\]

also determine all thirteen directions.  Direction \(0\) occurs on the
three disjoint edges

\[
 (01),(23),(45),                                           \tag{17}
\]

and every other direction occurs once.  The residual divisor is \(2[0]\),
so all four moments in (13) vanish.

In both examples every repeated direction is a matching; hence no three
points are collinear.  The first coordinates are distinct, so adjoining the
vertical point at infinity gives a seven-arc.  These examples are not
conic-external—the existing exact \(q=13\) classification proves that no
conic-external seven-arc exists.  Their role is narrower and decisive: the
arc, direction-cover, defect-two, and moment conditions alone permit both
fibre shapes.

## 5. Exact finite certificate

The deterministic checker
`notes/2026-08-01-c756-subresultant-moment-analysis.py` verifies directly:

1. the direction multiset and matching condition in (14)--(17);
2. all four displayed moments;
3. the Vandermonde-minor coefficients (4);
4. the repeated-intercept identity \(-B(t)/A(t)\) at every unique direction;
5. simultaneous vanishing of \(A,B\) at every exceptional direction;
6. exact division by \(E_P^2\); and
7. the attained degrees \((20,21)\) and \((16,17)\).

Replay from the repository root:

```sh
python3 notes/2026-08-01-c756-subresultant-moment-analysis.py \
  --check notes/2026-08-01-c756-subresultant-moment-analysis.json
```

| artifact | bytes | SHA-256 |
|---|---:|---|
| `notes/2026-08-01-c756-subresultant-moment-analysis.py` | 7,420 | `f544c87e38998943caf15231c46fd7fdfd32b0c0e69545878d5ec7d0524db1b1` |
| `notes/2026-08-01-c756-subresultant-moment-analysis.json` | 4,642 | `e39dd72f6b6732e39bd03fc89c11709cc4d89185887ea661f73cfa835b187b18` |

No second implementation is load-bearing: (3)--(13) are human symbolic
proofs, while the two finite witnesses and all quotient coefficients are
printed explicitly in the certificate and directly checkable by
substitution.  The program is an exact audit of those displayed witnesses,
not evidence for an unrestricted nonexistence claim.

## 6. Next steps

The raw subresultant and global-moment routes should stop here.  Their exact
failure mechanisms are now known.

The full theorem now has the following honest branch ledger:

1. saturated-external: closed, with the Clebsch hexagon at \(q=11\) the sole
   covering example;
2. saturated-internal: open beyond the four-frame at \(q=5\), with no uniform
   normal form or obstruction yet integrated; and
3. nonsaturated: \(\delta=0,1\) closed, while \(\delta\ge2\) remains open and
   the direct Segre, raw-subresultant, and global-moment repairs have failed.

The highest-EV remaining nonsaturated attack is the dual conic-weighted pencil.  Let

\[
 O=\ell^\perp,
 \qquad N_{ij}=(P_iP_j)^\perp.
\]

Every \(N_{ij}\) is internal because every chord \(P_iP_j\) is external.
If the chord meets \(\ell\) at \(X\), then \(N_{ij}\in X^\perp\), and
\(X^\perp\) is a line of the pencil through \(O\).  Thus the \(q+2\) chord
nodes from \(B\) form a near-transversal of \(q\) pencil lines:

- either two pencil lines contain two nodes each;
- or one pencil line contains three nodes;
- every other pencil line contains one node.

Unlike the direction polynomial, the location of \(N_{ij}\) along
\(X^\perp\) retains the chord intercept; unlike the raw subresultant,
internality is now a pointwise conic character condition.  The precise next
gate is:

> classify, or obtain a character obstruction for, defect-two
> near-transversals of a pencil whose points are all internal and arise as
> poles of the edges of an affine arc.

Two bounded subsidiary calculations are worthwhile inside that gate:

1. derive the conic norm of \(N_{ij}\) in pencil coordinates and test whether
   the product over the unique fibres divides by the Moore norm to degree
   \(O(\delta)\); and
2. keep vertex labels and form the barycentrically weighted moments
   \(\sum_{j\ne i}w_jt_{ij}^m\), rather than the global moments (13), to see
   whether the edge realization and conic character interact before taking
   a full product.

In parallel, the saturated-internal branch needs its own torus normal form,
Segre comparison, and literature boundary.  A positive classification there
would still leave the nonsaturated gate; a negative or flexible result would
show that the two open branches require genuinely different ideas.

If neither dual-pencil calculation produces a bounded-degree invariant, no
currently identified route remains for the nonsaturated branch.  That is the
right stop condition rather than another raw character sum of degree
\(\Theta(q)\).  It does not by itself settle the separate saturated-internal
branch.

## 7. EJ + TT closeout

The first cheap upgrade is the all-defect divisibility (8), not merely the
defect-two degree check.  It gives the exact amount of subresultant
compression supplied by concurrence localization and proves why the hoped
Moore compression cannot occur.

The second is the pair of explicit affine arcs.  They prevent either
defect-two fibre shape from being silently discarded as an artefact of the
count.  Any successful proof must use the conic character, not only Segre,
direction coverage, arc incidence, or the first four moments.

The Tao-level lesson for the nonsaturated branch is that the current reductions repeatedly project away
the same coordinate: direction survives, intercept disappears.  The dual
node pencil is the first proposed carrier that makes both coordinates and
the conic type simultaneous.  It should receive one bounded pass; absent a
low-degree norm or a small near-transversal theorem, the honest conclusion
is that the all-\(k\) crown is beyond the present toolkit.

The working probability of a full proof with current tools falls to roughly
5--10%.  The reduction remains valuable and unusually sharp, but the two
cheapest post-Segre exits are now rigorously closed and the saturated-internal
branch was not closed by the prior external analysis.

## 8. Mystery ledger

| feature | status | exact gap / next gate |
|---|---|---|
| Does the first subresultant inherit the Moore factor? | settled negatively | it is nonzero at every unique direction by (5) |
| What subresultant factor is forced? | settled | exactly the uniform lower bound \(E_P^2\mid A,B\) |
| Degree after forced division | settled as the wrong scale | still \(\Theta(q)\); both defect-two examples attain degrees \((16,17)\) at \(q=13\) |
| First four global slope moments | settled as insufficient | both fibre shapes occur for exact affine arcs satisfying them |
| Triple-direction shape | feasible before conic externality | witness (16)--(17); conic-weighted obstruction still open |
| Two-double-direction shape | feasible before conic externality | witness (14)--(15); conic-weighted obstruction still open |
| Intercept plus conic character | open | dual internal-node near-transversal through \(\ell^\perp\) |
| Saturated-internal branch | open | build a separate torus/Segre normal form or locate a classification; the \(q=5\) example prevents importing the external mod-4 kill |
| Full all-\(k\) theorem | open, lower confidence | saturated-internal and nonsaturated defect two are co-equal gates; no current route joins them |
