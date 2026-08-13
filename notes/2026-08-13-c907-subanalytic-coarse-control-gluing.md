# C907 subanalytic coarse-control gluing criterion

**Lane:** `clebsch`

**Status:** theorem-grade conditional topology route and a decisive audit of
what it does *not* follow from.  A common toroidal fan is not logically
needed for the proper exterior-pair theorem.  A proper common **subanalytic**
model with a finite `L`-regular Whitney bridge is enough.  The present C907
certificates do not construct that bridge or identify one common model for
the protected ratio and intrinsic-tropical exterior charts, so this does not
close the coarse-control seam.

## 1. The no-fan gluing theorem

Let `Omega` be a contractible disk with closure compactly contained in `C*`,
let `X` be a closed subanalytic subset of a real analytic manifold, and let

\[
 \lambda:X\longrightarrow\Omega
 \tag{1}
\]

be the restriction of a real analytic map defined near `X`, and be proper.
The finite family `A` of labels may include the actual boundary, graph
singular locus, path-tube end faces, and the protected residual core.
Suppose that `X` is covered by a protected open `U_R` and an exterior open
`U_E`.  The following are the exact sufficient data for a closed exterior
pair; none refers to a toric fan.

1. **Common `L`-regular atlas.**  There are finite Whitney
   stratifications on `U_R`, `U_E`, and on a closed bridge
   \(C\subset U_R\cap U_E\) which is proper over `Omega`, compatible with
   `A`, such that `lambda` is a
   submersion on every stratum.  On the bridge their restrictions have a
   common refinement whose strata are still `lambda`-submersive.  The three
   resulting families, with their frontier relations, glue to one finite
   Whitney prestratification `S` of `X`, still `lambda`-submersive on every
   stratum.  Equivalently, a finite list of subanalytic transition charts
   exhibits the local stratifications as products over `Omega` and its
   transition maps as stratum-preserving maps over `Omega`.
2. **Fibrewise separating datum.**  For one `u0 in Omega`, a closed labelled
   stratified hypersurface \(I_{u_0}\subset C_{u_0}\) is transverse to every
   fibre stratum.  It separates a closed residual tube \(R_{u_0}\) from the
   exterior in the reference fibre.  In particular, its normal derivative
   admits a stratified defining function `rho_0` on a control collar.
3. **Controlled interface refinement.**  Splitting the bridge strata along
   the controlled transport of \(I_{u_0}\) is again a Whitney refinement
   compatible with `A`.  This is automatic from a specified stratified
   product collar, but should be retained as a hypothesis if the product is
   only supplied by abstract controlled flows.

> **Theorem (proper subanalytic exterior gluing).**  Under 1--3 there are
> labelled closed Whitney pairs \((P,I)\) and \((R,I)\), with
> \(X=P\cup R\) and \(I=P\cap R\), such that `lambda` is a proper
> controlled submersion of both `P` and `I` over `Omega`.  Hence
>
> \[
> (P,I)\simeq(P_{u_0},I_{u_0})\times\Omega
> \tag{2}
> \]
>
> by a label-preserving homeomorphism over `Omega`; consequently the two
> exterior relative groups vanish.  Excision then identifies the relative
> group of `X` with that of the protected tube exactly as in the
> controlled-fibrewise-pair theorem.

**Proof.**  The common atlas in 1 is a finite Whitney prestratification of
`X`, and `lambda` is a stratumwise submersion.  Mather's control construction
upgrades it to a controlled submersion.  Properness gives global controlled
lifts of a chosen ordered coordinate frame on `Omega`; their ordered flows
give one product trivialization of `X`.  Transport \(I_{u_0}\),
\(R_{u_0}\), and `rho_0` by that trivialization.  The result is a closed
labelled interface and tube.  On a stratum meeting the interface, the two
horizontal lifts map isomorphically under \(d\lambda\), while the
transported vertical normal has `d rho` nonzero.
Thus

\[
 d(\lambda,\rho):T S\longrightarrow T\Omega\oplus\mathbb R
 \tag{3}
\]

is onto along the interface.  Hypothesis 3 makes it a legitimate Whitney
refinement rather than merely a stratumwise transported set.  (A subanalytic
pair is obtained as well only when the chosen product collar is subanalytic;
the topology conclusion needs no such extra regularity.)  Mather's first
isotopy theorem applied to the labelled closed pairs gives (2).  The usual
open-thickening excision gives the stated relative conclusion.  \(\square\)

The ordered-flow wording is deliberate: independently chosen coordinate
lifts need not commute, so they do not define path-independent transport.
The theorem needs one chosen controlled product trivialization, not a flat
connection.

## 2. What cannot be omitted

Local `L`-submersivity on protected and exterior opens, plus properness of a
common ambient, does **not** imply the bridge condition in 1 or the polar
condition (3).  Already take

\[
 X=\overline\Omega\times[-1,1],\qquad \lambda(u,s)=u,
 \qquad R=\{\operatorname{Re}u\le0\}\times[-1,1].
 \tag{4}
\]

The map is a proper submersion on the whole smooth compact ambient, hence on
arbitrarily chosen protected/exterior open covers.  But the prescribed
interface

\[
 I=\{\operatorname{Re}u=0\}\times[-1,1]
 \tag{5}
\]

has real rank one under `lambda`; it is not a submersion to the real
two-dimensional value disk.  Any compatible Whitney stratification carrying
this labelled interface has the same failure.  Thus neither compatibility of
Whitney stratifications nor a generic refinement repairs an interface chosen
through a value direction.  A fibrewise, vertically transverse interface as
in 2 is essential.

This is the topology version of the C907 warning that an auxiliary or new
exceptional boundary can delete the tangent direction which makes `dL` a
unit.  It is not a toric phenomenon.

## 3. Relative-resolution variant

There is a useful conditional algebraic route to hypothesis 1.  Let
\(q:M\to\Omega\) be smooth and let the actual boundary be SNC.  A blow-up
along a smooth center which is smooth over `Omega` and has normal crossings
with that boundary is again smooth over `Omega`; its exceptional divisor and
all of its boundary strata are smooth over `Omega`.  Therefore an
`L`-submersive pair keeps that property through such a blow-up.

This does **not** turn ordinary principalization into a solution.  The
submersion \(\mathbb A^1_t\times\mathbb A^1_x\to\mathbb A^1_t\) is smooth,
but principalizing `(t,x)` requires the vertical center `(t,x)`, which is not
smooth over the base.  The elementary blow-up example then creates a fibre
on which the base function is constant.  A C907 use of relative resolution
would need an additional, concrete theorem that the relevant exterior
boundary/transition ideal admits principalization by `L`-smooth permissible
centers.  None is presently available.

## 4. Audit of the present C907 data

| Required datum | Current evidence | Verdict |
| --- | --- | --- |
| Proper common ambient over the bounded value disk | The global multihomogeneous Cartier closure is proper after restricting to a closed `delta` disk and `Omega`. | Available only as a coarse ambient. |
| Protected local `L`-submersivity | The finite ratio chart has the `v`-unit on its nonempty actual components; the bounded chart carries the four Morse sections. | Local only. |
| Exterior local `L`-submersivity | The 70 tangent lifts and two `L=0` exclusions prove the intrinsic exterior statement, conditional on regular-chart coverage and descent. | Local/intrinsic only. |
| One common analytic model for both descriptions | No comparison identifies the protected ratio chart and intrinsic tropical closure as opens of one proper graph model. | Open. |
| `L`-regular bridge and overlap stratification | No finite non-toroidal transition/Whitney record supplies it. | Open and load-bearing. |
| Fibrewise separating interface | No controlled reference interface or product collar has been constructed. | Open. |
| Uniformity for `delta != 0` | Requires a proper controlled submersion for `(p,L)` on a closed annulus. | Open. |

The global ratio-fan obstruction is therefore not a topological impossibility
theorem.  It rules out one convenient way to certify the bridge: a common
toroidal refinement that simultaneously records marked pair-of-pants
valuations and preserves the protected ratio cones.  A non-toroidal
subanalytic bridge could in principle satisfy 1--3.  The present certificates
give no construction of it, and the local ratio/exterior calculations cannot
be declared to glue merely because they have a proper Cartier ambient.

## 5. Primary source boundary

Mather's Proposition 11.1 applies to a **given** closed Whitney
prestratification whose map is a submersion on every stratum; compatible
control data and the product then follow from his control construction and
Corollary 10.2.  It does not manufacture the `L`-regular bridge from local
submersivity.  The present theorem uses precisely that implication and no
stronger black box:

- John N. Mather, *Notes on Topological Stability*, Proposition 11.1,
  Proposition 10.1, and Corollary 10.2; cached PDF SHA-256
  `afeecee7d4519f6dd2fdd7d28997771f759b3988169a5e68517729cf5b473e33`.

## EJ/TT and mystery ledger

- **EJ:** a non-toroidal proper Whitney bridge would bypass the forced
  polar-bad toric exceptional divisor.  The finite new deliverable is a
  bridge/overlap and product-collar certificate, not another fan census.
- **TT:** topology does not turn local submersions into a stratified
  submersion across a labelled seam.  The seam is an independent geometric
  object and must be made fibrewise before applying isotopy.
- **Settled:** the exact no-fan criterion; why transported interfaces are
  noncircular after a controlled collar; and why relative resolution needs
  `L`-smooth centers.
- **Open:** construction of one proper common model, an `L`-regular
  protected/exterior bridge, its labelled fibrewise interface, and its
  annular `(p,L)` upgrade.
