# C907 protected Rees-star carrier lemma

**Lane:** `clebsch`

**Status:** exact fan-theoretic correction to the protected `(1,1)` coverage
claim. A regular refinement can and should factor through
`Bl_(delta,U,V)`, but it cannot in general leave its three maximal Rees cones
unsplit. The resulting *carrier cover* is sufficient to assign every closure
face to the bounded core, an imbalanced end, or an adjacent exterior star. It
is not by itself a strict-transform or coarse-polar theorem.

## The Rees fan and its unavoidable subdivision

On the double-marked cone write

\[
C_R=\mathbb R_{\geq0}\langle e_\delta,e_U,e_V\rangle
\quad\text{with coordinates}\quad(t,\beta,\gamma).
\]

The star subdivision at

\[
e_R=e_\delta+e_U+e_V=(1,1,1)
\]

is the fan of `Bl_(delta,U,V)`. Its maximal cones are

\[
\begin{array}{c|c|c}
\text{carrier}&\text{generators}&\text{inequalities}\\ \hline
\kappa_\delta&\langle e_R,e_U,e_V\rangle&t\leq\beta,\ t\leq\gamma\\
\kappa_U&\langle e_R,e_\delta,e_V\rangle&\beta\leq t,\ \beta\leq\gamma\\
\kappa_V&\langle e_R,e_\delta,e_U\rangle&\gamma\leq t,\ \gamma\leq\beta.
\end{array} \tag{1}
\]

They give respectively the usual affine charts

\[
U=\delta Z,\ V=\delta W;\qquad
\delta=Ur,\ V=Uv_0;\qquad
\delta=Vs,\ U=Vw_0. \tag{2}
\]

The three cones cannot be retained as unsplit cones after imposing the graph
support walls. Indeed in the `U` carrier use its nonnegative coordinates

\[
u=\beta,\qquad r=t-\beta,\qquad v_0=\gamma-\beta.
\]

The sixth universal graph weight is

\[
2t-\beta-\gamma=2r-v_0. \tag{3}
\]

The equality of this term with the value term cuts the interior of
`\kappa_U` along `v_0=2r`; for example `(u,r,v_0)=(1,1,2)` is an interior
point. Thus any fan which refines the graph support subdivision must cut the
interior of `\kappa_U`. The symmetric assertion holds for `\kappa_V`. In
particular, a request that all later star centers be outside the open Rees
cones, or only in product `y` directions, is incompatible with the support
fan.

## Correct relative-refinement statement

Let `Sigma_supp` be the six-weight pair-of-pants support cone complex and
let `Sigma_R` be (1). On the closure of the `(1,1)` star form the common
refinement

\[
\Sigma_0=\Sigma_{\rm supp}\wedge\pi_R^{-1}\Sigma_R. \tag{4}
\]

Every integral regular subdivision

\[
\widetilde\Sigma\longrightarrow\Sigma_0 \tag{5}
\]

has a toric morphism

\[
X_{\widetilde\Sigma}\longrightarrow X_{\Sigma_R}
=\operatorname {Bl}_{(\delta,U,V)}. \tag{6}
\]

Conversely, ordinary determinant-descent stellar subdivision of the finite
rational complex `Sigma_0` produces such a regular `\widetilde\Sigma` in the
original lattice. It may subdivide every `\kappa_i`, but no cone crosses a
Rees wall. Equivalently, for every cone `\sigma` of `\widetilde\Sigma` there
is an `i` with

\[
\sigma\subseteq\kappa_i. \tag{7}
\]

This is the precise sense in which resolution is *relative to the Rees
subcomplex*. It proves factorization through the fixed blow-up, rather than
the false stronger assertion that the three full affine cones survive as a
subfan.

The charts in (2) are an open cover, not a disjoint partition. For example
the cone `\langle e_R,e_V\rangle` is the `delta/U` overlap, and the dense
exceptional point `[delta:U:V]=[1:1:1]` belongs to all three charts. Hence
“every point lands in exactly one Rees chart” is false. If a unique
*combinatorial owner* is useful, use the half-open sectors

\[
\begin{aligned}
S_\delta&=\{t\leq\beta,\ t\leq\gamma\},\\
S_U&=\{\beta<t,\ \beta\leq\gamma\},\\
S_V&=\{\gamma<t,\ \gamma<\beta\}.
\end{aligned}\tag{8}
\]

They partition `C_R`, but they are not affine charts and must not be used to
delete overlap points.

## Closure to exterior versus protected carriers

The closure of a `1` tripod ray has only its generic vertex as an endpoint.
For a face `F` in the closure of the `(1,1)` star define its base label by

\[
\ell_B(F)=\begin{cases}g&\beta|_F=0,\\1&\beta>0\text{ on }\operatorname{relint}F,\end{cases}
\qquad
\ell_C(F)=\begin{cases}g&\gamma|_F=0,\\1&\gamma>0\text{ on }\operatorname{relint}F.\end{cases}\tag{9}
\]

Thus a proper closure face with label different from `(1,1)` has label

\[
(g,1),\quad(1,g),\quad\text{or}\quad(g,g), \tag{10}
\]

and belongs to the already exterior support star. No `0` or `infinity` type
is reached from this closure. If the label is `(1,1)`, (7) puts the face in
at least one Rees carrier. Faces of equal minimum lie in two or three
carriers, exactly as they should.

This proves the exhaustive carrier alternative

\[
\boxed{\text{adjacent exterior star}}\quad\text{or}\quad
\boxed{\text{bounded `delta` carrier}}\quad\text{or}\quad
\boxed{\text{a `U`/`V` imbalanced carrier}}.\tag{11}
\]

The last two boxes require a small but important refinement of terminology.
The exact imbalanced coordinates already audited are not merely the raw
coordinates `(r,v_0)` in (2). At the infinity end of the bounded residual
chart they are

\[
r=Z^{-1},\qquad v=ZW,\qquad\delta=rh, \tag{12}
\]

and its symmetric copy. They arise after the indicated boundary
compactification/blowups over the `U` or `V` carrier. Therefore (11) uses
these imbalanced **refinement charts**, not an unsupported assertion that the
elementary Rees chart already has the displayed unit derivative.

## Actual-boundary consequence and its limit

In a `U` chart, `v_0=0` is the strict transform of `V=0`, equivalently the
retained translated divisor `C=1`; in a `V` chart `w_0=0` is the analogous
strict transform of `U=0`. In the refined coordinates (12), `v=0` is again
an interior translated-residue locus. These divisors are not components of
the actual control boundary, which is the total transform of `delta=0`, the
`y` infinity boundary, and `B,C=0,infinity`. Extra vertical exceptional
divisors may be actual central-boundary components, but this never promotes
the strict transform of a translated-residue divisor to an actual stratum.

Consequently the control stratum on an imbalanced carrier must retain `v` (or
`w`) as a tangent coordinate. In the compact-`y` regime the exact chart
calculation gives `partial_v L=1` (respectively `partial_w L=1`) on every
actual central component and intersection. In the noncompact-`y` regime, the
joint `y`/Rees theorem supplies the different certificate: positive
normalization order makes `L` free. It is incorrect to claim that an
arbitrary mixed support subdivision preserves the literal coordinate
`partial_v`; the support walls such as (3) are not product `y` walls.

Hence the carrier lemma closes exactly the missing *where-can-a-face-go*
question. To turn it into a global Fitting theorem still requires the
already isolated strict-transform/partial-chart attachment: on each refined
carrier the local graph must be identified with the bounded, imbalanced, or
exterior chart used by the corresponding differential certificate.

## EJ/TT

- **EJ:** factorization through the Rees blow-up is the invariant statement;
  an affine-cover carrier is enough and survives any regular resolution.
- **TT:** an open cover is not a partition, and a support wall through an
  open Rees cone forbids freezing that cone. The relevant safety split is
  compact `y` by the imbalanced unit direction versus noncompact `y` by free
  `L`.
