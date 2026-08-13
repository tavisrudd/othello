# C907 Kummer pair-of-pants/Rees refinement

**Lane:** `clebsch`

**Status:** an actual finite, regular **Kummer-toroidal support atlas** is
now specified and exactly replayed.  It gives the missing regular refinement,
its exceptional vectors, its affine chart maps, and the chart-to-tripod-face
record.  It does not identify a pulled-back Cartier generator with the
saturated strict graph generator, and it does not calculate actual-boundary
Fitting ideals or collars.

The important distinction is retained throughout.  The pair-of-pants marks
`U=1-B` and `V=1-C` organize support, but the original dense graph domain
retains `U=0` and `V=0`.  Consequently an imbalanced coordinate such as
`v=V/U` is an algebraic interior coordinate for the strict transform and for
control; it is not saturated or made into a control stratum.

## The finite refinement

Write the support lattice as

\[
 N=\mathbb Z\langle t,p_1,p_2,p_3,\beta,\gamma\rangle.
\]

Start from the exact six-weight hyperplane complex `Sigma_supp` in
`2026-08-12-c907-tripod-hyperplane-refinement.json`.  On its `(1,1)`
pair-of-pants cone, `beta=v(U)` and `gamma=v(V)`.  The ordinary blow-up

\[
 \operatorname{Bl}_{(\delta,U,V)}
\]

has exceptional vector

\[
 e_R=e_\delta+e_U+e_V=(1,0,0,0,1,1). \tag{1}
\]

Its three affine charts are exactly the regions in which one of
`t,beta,gamma` is minimal.  Thus its common refinement with `Sigma_supp` is
obtained, only in the `(1,1)` cone, by adding

\[
 t=\beta,\qquad t=\gamma,\qquad\beta=\gamma. \tag{2}
\]

This is not a heuristic star subdivision: (2) is the fan of the three Rees
charts.  The six support weights all vanish on (1), and so does each of the
three new cuts.  Therefore the Rees ray belongs to the all-tie face rather
than changing a graph initial.  The exact PPL replay replaces 7,666 `(1,1)`
slice cells by 24,008 and takes the whole support complex from 81,367 to
97,709 slice cells.

For every nonzero face `F` of this common refinement which meets `t=1`, let

\[
 q_F=\operatorname{prim}\!\left(\sum_{\rho\in\operatorname{Rays}(F)}
                 \operatorname{prim}(\rho)\right)\in N. \tag{3}
\]

The barycentric subdivision has maximal cones indexed by flags

\[
 F_1\subsetneq\cdots\subsetneq F_d,
 \qquad \sigma_{\mathcal F}=
 \mathbb R_{\geq0}\langle q_{F_1},\ldots,q_{F_d}\rangle. \tag{4}
\]

The vectors in (4) are linearly independent.  With

\[
 N_{\mathcal F}=\sum_i\mathbb Zq_{F_i},\qquad
 \bar N_{\mathcal F}=(\mathbb R\sigma_{\mathcal F})\cap N,
\]

the finite group `G_F=bar N_F/N_F` gives the canonical Kummer chart

\[
 [\operatorname{Spec}k[z_{F_1},\ldots,z_{F_d}]/D(G_{\mathcal F})]. \tag{5}
\]

The cover in (5), times the transverse residue torus, is regular and integral;
its coarse chart is the possibly quotient-singular toric chart in the original
lattice.  Hence the collection of (5), glued by flag deletion/localization,
is a regular integral Kummer toroidal refinement.  There is no unrecorded
choice of a simplicial or a unimodular resolution.  In characteristic zero the
finite diagonal quotient is tame.  If a scheme rather than this canonical
Kummer stack is required,
the usual Hilbert-basis stellar algorithm applied separately to the finite
groups `G_F` gives a genuine unimodular subdivision; it is unnecessary for
the strict-transform calculation after tame Kummer descent.

Every `F` with dimension greater than one contributes a genuine vertical
exceptional divisor `D_F` with vector (3).  All such newly introduced vectors
have positive `t`; the refinement is therefore an isomorphism on the generic
fibre.  The replay commits a SHA-256 digest of all 96,662 exceptional-vector
records, rather than an unreadable divisor table.

## Explicit chart maps and the tripod record

For a flag chart define

\[
 \epsilon_B=\prod_i z_{F_i}^{\beta(q_{F_i})},\qquad
 \epsilon_C=\prod_i z_{F_i}^{\gamma(q_{F_i})}. \tag{6}
\]

After the finite Kummer cover, choose ordinary residue units `b,c`.  The
map to the two marked lines is the following affine formula (and the same
table with `C,V,c,epsilon_C`):

\[
\begin{array}{c|cc}
 \text{tripod type}&B&U=1-B\\ \hline
g&b&1-b\\
0&\epsilon_Bb&1-\epsilon_Bb\\
1&1-\epsilon_Bb&\epsilon_Bb\\
\infty&(\epsilon_Bb)^{-1}&1-(\epsilon_Bb)^{-1}.
\end{array} \tag{7}
\]

For `g`, both `b` and `1-b` are inverted; for the three rays `b` is
inverted.  Formula (7) is the actual pair-of-pants equation, not a monomial
replacement for it.  In the `infinity` row it is regular in the affine
coordinate `A=B^{-1}=epsilon_B b`.

On the `y` torus the chart map is

\[
 \delta=\prod_i z_{F_i}^{t(q_{F_i})},\qquad
 y_j=u_j\prod_i z_{F_i}^{-p_j(q_{F_i})}. \tag{8}
\]

The source is localized in the appropriate `y_j` or `y_j^{-1}` chart; the
sign hyperplanes `p_j=0` in the input complex make (8) regular on that
chosen chart.  Equivalently, (8) is the usual character formula
`chi^m -> product z_F^(<m,q_F>)` in the corresponding chart of the fixed
smooth toric `y` compactification.

The chart-to-tripod-face record attached to `F` is

\[
 \tau(F)=
 \bigl(a\ \text{if }\beta(q_F)\ne0\ \text{else }g,\;
       b\ \text{if }\gamma(q_F)\ne0\ \text{else }g\bigr), \tag{9}
\]

where the ambient ordered type is `(a,b)`.  Thus setting the relevant
coefficient in (6) to one gives the generic pair-of-pants face.  The replay
records (9), the upper-envelope mask

\[
 \{i:w_i(q_F)=\max_j w_j(q_F)\}, \tag{10}
\]

and, at `(1,1)`, the Rees-chart set

\[
 \{\delta,U,V\ :\ t(q_F),\beta(q_F),\gamma(q_F)
                 \text{ is minimal}\}. \tag{11}
\]

Consequently (3), (7)--(11) are a finite proof-generating replacement for a
chart dump.  Any individual affine chart, its exact exceptional vector, base
initial, support mask, and Rees face can be regenerated from its flag.

## Residual Rees charts and the interior rule

The three underlying algebraic charts are

\[
\begin{array}{c|ccc}
\delta&U=\delta Z&V=\delta W& (\delta,Z,W)\\
U&\delta=rU&V=vU&(U,r,v)\\
V&\delta=sV&U=wV&(V,s,w).
\end{array} \tag{12}
\]

On overlaps,

\[
 Zr=1,\quad W=Zv,\qquad sv=r,\quad wv=1. \tag{13}
\]

The actual boundary in the middle chart is carried by the exceptional/central
coordinates `U` and `r`, not by `v`; analogously it is `V,s`, not `w`, in the
last chart.  In particular `{v=0}` is the strict transform of the retained
translated divisor `V=0`, not an exceptional boundary component.  The
auxiliary support marks may see its valuation, but neither strict-transform
saturation nor the eventual control/Fitting partition may add `v=0` as a
stratum.  This is compatible with (3): every added Kummer divisor is vertical
(`t(q_F)>0`), whereas `v=0` itself is not one of the divisors used for the
actual boundary product.

The original graph domain removes `delta=0` and the original coordinate/y
boundaries, but retains `U=0,V=0`.  The Rees center is contained in
`delta=0`, and the barycentric centers above are vertical.  Thus the whole
construction is an isomorphism over that dense graph domain and does not
license saturation by a translated divisor.

## The `s b_0+t b_1=1` transition

The one-tripod incidence relation is a valid transition formula, but it
cannot be a simultaneous `0/1` special-fibre chart.  If
`s=delta^a,t=delta^b` with `a,b>0`, then

\[
 1=\delta\bigl(\delta^{a-1}b_0+\delta^{b-1}b_1\bigr)
\]

in

\[
 R[b_0,b_1]/(s b_0+t b_1-1). \tag{14}
\]

So `delta` is invertible and the special fibre of (14) is empty.  It is a
generic overlap, not an affine neighbourhood of a central `0/1` stratum.
This is exactly right combinatorially: the `0` and `1` rays of one tripod
meet only through its generic vertex `g`.

At a genuine face one coefficient is a unit.  For example `s=1` gives
`b_0+t b_1=1`, and `t=1` gives `s b_0+b_1=1`; these are precisely (7) on the
map to `g`.  The compatible infinity coordinate is

\[
 b_\infty=stb_0=t-t^2b_1. \tag{15}
\]

The pre-existing exact Singular replay verifies (13), these two generic-face
specializations, (15), and the global Cartier-chart unit identities.  Thus
the transition is feasible in its proper role, while (14) rules out the
incorrect simultaneous-boundary use.

## Exact replay and scope

Run from the repository root:

```sh
nix shell nixpkgs#python3 --command python3 \
  notes/2026-08-12-c907-kummer-pair-of-pants-refinement.py --check

nix shell nixpkgs#singular --command Singular -q \
  notes/2026-08-12-c907-one-tripod-log-atlas.sing | \
  cmp -s - notes/2026-08-12-c907-one-tripod-log-atlas.out
```

The first command replays the exact PPL common refinement, regenerates every
face-vector/base-face/mask/Rees-chart record, and checks the compact
certificate plus SHA-256 manifest.  Its input hash pins the earlier support
subdivision.  The second command is independent algebra for the nonmonomial
pair-of-pants and Rees overlaps.

The tracked manifest pins the 11,983-byte generator as
`932b7cd83f96c5ad790abd36a7d157f63f3cd26c635d3f0e1853eaa12c068a3e`
and the 11,868-byte canonical JSON as
`74d5c0331aa096a0718e8d7337c2537a2c5f4709b292188e91bc07f297b9a42d`.
The independent check is the symbolic Singular overlap replay above; it does
not reimplement the PPL enumeration, but tests the load-bearing nonmonomial
relations that the fan generator does not decide.

This closes the finite regular-refinement record required before a
chart-by-chart strict-transform proof.  It does **not** prove that the pullback
of the multihomogeneous Cartier equation, divided by its actual exceptional
monomial, equals the local saturated graph generator.  Once that identity is
proved, the existing 552-case flat-base nonvanishing certificate attaches the
full initial complete intersections.  Smoothness, coarse actual-boundary
Fitting control, the fixed value disk, and Whitney--Thom collars remain
separate gates.

## EJ/TT and mystery ledger

- **EJ:** the residual blow-up contributes only the three min-comparison
  hyperplanes (2); regularity is then canonical barycentric Kummer geometry,
  not a new 97,709-chart calculation.
- **TT:** the incidence equation (14) exposes a real geometry constraint:
  `0` and `1` cannot be made one central affine chart.  Treating it as one
  would create an empty special fibre and falsely erase the generic tripod
  vertex.
- **Settled:** a finite regular Kummer support refinement, Rees exceptional
  vector, all affine map formulas, face records, and the imbalanced-interior
  rule.
- **Open:** exceptional multiplicities of the *Cartier graph section*,
  saturated strict-generator equality, reduced-stratum Fitting overlap, and
  collar topology.
