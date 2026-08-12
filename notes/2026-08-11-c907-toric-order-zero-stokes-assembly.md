# C907 bounded-value residual Stokes assembly

**Lane:** `clebsch`

**Status:** strong local lemma, global theorem on hold.  The explicit
finite-value pole charts and their hardest seam pass, but a cold audit still
requires the saturated common resolution, every product-pair intersection
(including the residual interface), and the joint `y`-boundary check.  This
avoids the false global claim
that the whole rapid-decay group has rank four; it isolates the four residual
thimbles in a compact value window.  The Gamma/Orlov marking is a separate
one-integer gate.

## Target

For the toric codimension-two blowup

\[
 Y=\operatorname{Bl}_{\mathbf P^3}\mathbf P^5,
\]

identify the directed four-thimble system whose critical values remain
bounded after the residual normalization with the directed thimble system of
the `P^3` mirror.  This is the order-zero residual-center Stokes comparison
left open by Iritani's general theorem.

## 1. Why the value-localized problem is the right one

After ramification and affine normalization, the potential is

\[
 F_\delta=S(y)+\frac{A(y)}{BC}
  +\delta^{-2}(1-B)(1-C),
 \qquad A=\frac Q{y_1y_2y_3}.
 \tag{1}
\]

Its four residual critical values converge to `4a`, `a^4=Q`; its six ambient
critical values leave every bounded value set.  Choose a closed disk `Omega`
containing the four residual values and no ambient value for all sufficiently
small `delta`.

The full rapid-decay group has rank ten, not four.  A global boundary collar
at phase infinity can mix the residual and ambient systems, and a frozen
transverse slice can carry nonzero relative homology.  None of that is needed
to calculate the internal residual Stokes system.  The correct object is the
proper finite-value graph over `Omega`, followed by the relative Morse group

\[
 H_5(F_\delta^{-1}(\Omega),F_\delta^{-1}(u_0)),
 \tag{2}
\]

where `u_0` is a regular boundary value and the disk is cut along a
distinguished system of four residual vanishing paths.  This group has rank
four.  Extending its paths to a global outgoing sector is a marking problem,
not part of the internal Stokes calculation.

## 2. Proper bounded-value graph lemma

Compactify the `y`-torus and the two `B,C` factors toroidally, take the graph
closure of `(delta,F_delta)` over `Delta_delta x Omega`, and normalize it.
Because the source compactification and `Omega` are proper, this graph closure
is proper over `Delta_delta x Omega`.

The pole-channel report gives a finite valuation atlas for every point of
this closure with `y` in the residual core.  Every nonresidual finite-value
face has a free linear potential coordinate.  The uniform `0/0` and `0/1`
charts have

\[
 F_\delta=S+w+k,\qquad F_\delta=S+w-k,
 \tag{3}
\]

and the formerly singular monomial graph `eB=delta^2` is resolved by

\[
 \delta=et,\ B=et^2,
 \qquad
 e=\delta s,\ \delta=sB,\ e=s^2B.
 \tag{4}
\]

At `e=infinity`, with `h=e^{-1}`, the closures are smooth because their
defining equations have derivative `A != 0` in the `h` direction.  The
single-pole, double-pole, cross, regular/one, and symmetric charts likewise
have `partial F/partial w=1` on the boundary.  The end `B=infinity` with `C`
regular maps to value infinity and is absent from the graph over `Omega`.

There is one nontrivial seam in the common refinement.  On the `0/0` chart,
put `p=k^(-1)` and `T=L-S`, retaining `L=F_delta` as the bounded graph
coordinate.  The graph is

\[
 eB=\delta^2,
 \qquad
 Ap^2+p-e-Bp-\delta^2pT+\delta^2=0.
 \tag{4a}
\]

In the `e=s^2B`, `delta=sB` chart of (4), its only new singular seam is
`s=0,B=1,p=0`.  It is resolved by the symmetric infinity/one chart

\[
 c=C^{-1},\quad B=1-\delta^2c\ell,\quad
 L=S-\ell+c\left(\ell+
       \frac A{1-\delta^2c\ell}\right).
 \tag{4b}
\]

At `c=0`, `partial L/partial ell=-1`; its map to (4a) is
`p=s^2Bc`, `B=1-s^2B^2c ell`.  The `c=infinity` seam is the existing cross
chart.  The derivative in (4b) is

\[
 \partial_\ell L=c-1+
  \frac{\delta^2c^2A}{(1-\delta^2c\ell)^2}.
\]

It is uniformly nonzero off a fixed neighborhood of `c=1`.  The latter is
not an omitted singular seam: it belongs to the residual compactification.

On the residual face use

\[
 B=1-\delta Z+\delta^2A,
 \qquad
 C=1-\delta U+\delta^2A.
\]

The central potential is exactly

\[
 f_Q(y)+ZU,
 \qquad
 f_Q=y_1+y_2+y_3+\frac Q{y_1y_2y_3}.
 \tag{5}
\]

The Newton tetrahedron of `f_Q` contains the origin in its interior and its
face polynomials are nondegenerate.  Hence (5) has no boundary critical point
and has precisely the four Morse points

\[
 (y_1,y_2,y_3,Z,U)=(a,a,a,0,0),\qquad a^4=Q.
 \tag{6}
\]

The `c=1` interface is covered by the imbalanced residual chart.  For example,
put

\[
 r=U^{-1},\qquad v=ZU,\qquad\delta=rh.
\]

Then exactly

\[
 B=1-r^2hv+r^2h^2A,
 \qquad C=1-h+r^2h^2A,
\]

and

\[
 F_\delta=S+\frac A{BC}+v-hA-r^2hAv+r^2h^2A^2.
 \tag{6a}
\]

At `r=h=0`, this is `f_Q+v`, so `partial_vF=1`.  The symmetric chart covers
the other imbalanced end.  Hence a residual core containing a neighborhood of
`c=1` has a product-submersive compactified interface with the pole exterior.

The `y`-boundary has a separate circuit argument.  Its four exponents are

\[
 e_1,\quad e_2,\quad e_3,\quad-e_1-e_2-e_3.
\]

Every proper subset is linearly independent.  A boundary initial polynomial
in the tetrahedral toric compactification retains a proper subset, and its
logarithmic critical equations would give a nontrivial linear relation among
those exponent vectors.  This is impossible.  Terms constant in `y` do not
enter the equations, and a joint `(B,C)` refinement only deletes further
`y` monomials.  If all four survive, the `y` weight is zero and the point is
on the dense `y`-orbit already handled by the `(B,C)` atlas.  The Wave-2
uniform logarithmic-gradient estimate supplies an independent open-torus
check.

### Saturation and the common model

Define `bar G` to be the normalization of the reduced closure of the
`delta != 0` graph in the fixed compactified source times
`Delta_delta x Omega`.  This definition discards embedded or irreducible
vertical components: every point of `bar G` is the center of a ramified
analytic arc from the original graph.  The valuation table exhausts the
`(B,C)` valuation of every such bounded-value arc; the circuit argument
exhausts its `y`-boundary alternatives.

The ratios used in the finite atlas are monomial boundary ratios.  Take the
normalization of the closure of their simultaneous graph, then perform the
two explicit `A_1` blowups and their symmetric copies.  The centers are the
toroidal ideals generated by the boundary parameters, such as `(e,delta)`,
and the seam `s=0,B=1,p=0`; none involves `L`.  Equations (4a), (4b), the
`e=infinity` equation, and (6a) show that the strict transform is smooth and
`L`-submersive at every nontrivial seam.  The reciprocal and symmetric charts
cover the remaining directions.  Thus this simultaneous graph is a proper
common refinement of `bar G`, not a collection of unrelated local models.

The conclusion is a proper resolved graph

\[
 \Pi:\overline{\mathcal M}_\Omega
   \longrightarrow\Delta_\delta\times\Omega
 \tag{7}
\]

whose nonresidual boundary charts and their nontrivial seams are
stratified-submersive.  The remaining audit obligation is global rather than
algebraic: check that one controlled collar system on this simultaneous graph
has the asserted product structure on every finite intersection and on the
residual interface.  The statement makes no
assertion about the phase-infinity boundary of the full rapid-decay pair.

## 3. Proper Morse transport

Choose four disjoint critical-value disks and a distinguished path system to
`u_0` that varies continuously with `delta`.  The critical values are distinct
at `delta=0` and move only by `O(delta^2)`, so no residual braid is forced.

Conditional on that common model, take its reduced exterior `P_delta` and its
interface `I_delta` with the compact residual core.  The explicit atlas,
(6a), and the circuit check say that `L` has no stratified critical point on
either.  Proper stratified isotopy over the contractible disk `Omega` therefore
makes both pairs products over `Omega`.

The resolved monomial corner can be semistable (`delta=et`) rather than a
literal submersion in the parameter direction.  This causes no exterior
relative class because the preceding product argument is fibrewise in
`delta`.  With a regular base point `u_0` on `partial Omega`, every
nonresidual boundary chart and finite intersection has pair

\[
 (N_I\times\Omega,N_I\times\{u_0\}),
\]

and `H_*(Omega,{u_0})=0`.  Relative Kunneth and finite Mayer--Vietoris then
kill the union of all nonresidual collars, including the semistable fibre
`et=delta`.  Applying the same argument to `I_delta` prevents an exterior
cycle from leaking into the residual Morse group.

Parameterized holomorphic Morse attachment on the remaining residual core
then transports the four relative thimbles and their directed Seifert pairing
across `delta=0`.  Therefore

\[
 H_5(F_\delta^{-1}(\Omega),F_\delta^{-1}(u_0))
 \cong
 H_5((f_Q+ZU)^{-1}(\Omega),(f_Q+ZU)^{-1}(u_0))
 \cong\mathbf Z^4.
 \tag{8}
\]

At `delta=0`, Thom--Sebastiani identifies the right side with the `P^3`
thimble lattice.  Orient the transverse `ZU` thimble to have self-Seifert
pairing `+1`.  The internal directed residual Stokes matrix is then

\[
 \begin{pmatrix}
 1&4&10&20\\
 0&1&4&10\\
 0&0&1&4\\
 0&0&0&1
 \end{pmatrix}.
 \tag{9}
\]

This proves the unmarked, value-localized residual-center Stokes comparison
for the toric basepoint pilot once the bounded-value compactification lemma is
accepted.  It does not claim that the four local thimbles alone generate the
global rank-ten rapid-decay group.

## 4. Gamma lattice and the remaining marking

Iritani's Theorem 7.5 identifies toric Lefschetz thimbles with the Gamma
integral lattice, and Remark 7.6 identifies directed intersection with the
Euler pairing.  Theorem 7.31 identifies the residual subgroup with

\[
 K(\mathbf P^3)_{-1}
 =i_{E*}\bigl(p_E^*K(\mathbf P^3)\otimes\mathcal O_E(-1)\bigr).
 \tag{10}
\]

The proof supplies an element `beta_1` whose `K`-class is exactly
`i_(E*)O_E(-1)`, and base hyperplane monodromy supplies its orbit.  It does
not prove that `beta_1` is the positive-real directed thimble transported by
(8); Theorem 7.33 allows continuation-path mutations.

After fixing the directed sector, orientation, and hyperplane monodromy, the
remaining algebraic marking ambiguity is particularly small.  Write

\[
 K(\mathbf P^3)=\mathbf Z[x,x^{-1}]/(1-x)^4,
 \qquad n=1-x.
\]

Every Euler-preserving automorphism commuting with `x` is multiplication by

\[
 u=\epsilon x^k(1+c n^3),
 \qquad \epsilon\in\{1,-1\},\quad k,c\in\mathbf Z.
 \tag{11}
\]

The sign is orientation and `x^k` is a common line-bundle twist.  After those
normalizations, only the point-class shear `c` remains.  One normalized point
central-connection coefficient fixes it.  If the transport in (8) is shown
to carry `beta_1` to the positive-real `P^3` seed itself, then `c=0` and the
marking is exact.

The integer `c` cannot change the Stokes matrix.  More generally, suppose a
directed residual basis is a hyperplane orbit

\[
 (u,xu,x^2u,x^3u)
\]

and is semiorthonormal for the Euler form.  Put `v=u(x^(-1))u(x)`.  The four
conditions

\[
 \chi(u,u)=1,
 \qquad \chi(x^iu,x^ju)=0\quad(i>j)
\]

say

\[
 \lambda(v)=1,
 \qquad \lambda(vx^{-1})=\lambda(vx^{-2})=
          \lambda(vx^{-3})=0,
\]

where `lambda(a)=chi(1,a)`.  In the basis `(1,n,n^2,n^3)` the coefficient
matrix is triangular with rows

\[
 (1,-3,3,-1),\quad(0,-1,2,-1),\quad
 (0,0,1,-1),\quad(0,0,0,-1).
\]

Hence `v=1`, so the full Gram matrix is exactly (9).  Thus a proof that the
four directed escaping thimbles form the base-hyperplane orbit is enough for
the standard matrix; the point coefficient is needed only to attach the
individual Orlov labels.  Iritani's subgroup theorem alone does not prove
that orbit compatibility, because continuation paths may mutate the directed
basis.

## 5. Consequence and boundary

The bounded-value route removes the global phase-infinity collar from the
unmarked toric theorem.  What remains is:

1. cold-audit the proper common finite-value refinement in (7);
2. calculate one point coefficient, or directly track `beta_1`, for the
   Gamma marking;
3. compute the first Rees/Stokes deformation class after the order-zero pilot;
4. extend the construction from this toric center to a general
   codimension-two center.

Nothing here proves the comparison for a non-toric center or at positive
Novikov order.

## EJ/TT closeout

- **EJ:** value localization separates the desired rank-four theorem from the
  rank-ten global rapid-decay topology; the phase-infinity obstruction is not
  an obstruction to the internal residual Stokes matrix.
- **TT:** the theorem must name its value disk, path system, and residual
  relative group.  Calling the full rapid-decay group rank four would silently
  discard the six ambient critical points.

## Mystery ledger

- **Settled:** every finite-value pole regime has a finite toroidal graph chart
  and a free boundary value coordinate outside the residual face.
- **Settled:** the correct rank-four object is value-localized; the global
  group has rank ten.
- **Pending cold audit:** one saturated common finite-value refinement and
  product-pair structure on every exceptional overlap and residual interface.
- **Open:** the one point-class integer in the Gamma marking.
- **Reduced:** the point-class integer cannot affect the Stokes matrix; for
  the matrix, it suffices to prove directed hyperplane-orbit compatibility.
- **Open:** positive-order Rees/Stokes deformation and arbitrary centers.

## Source boundary

- Iritani, arXiv:1906.00801, Theorem 7.5 and Remark 7.6: thimble/Gamma lattice
  and pairing.
- Iritani, arXiv:1906.00801, Theorems 7.22, 7.31, and 7.33: convergent
  inclusion, residual Orlov subgroup, and path-dependent asymptotic basis.
- Iritani, arXiv:1906.00801, Remark 1.4(3): the general residual-center Stokes
  identification is not supplied there.
