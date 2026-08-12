# C907 pole-channel normal-crossing model

**Lane:** `clebsch`

**Status:** exact finite-value toroidal atlas.  It is sufficient for the
bounded-value transport strategy once the proper common refinement is
cold-audited.  It is not a global rapid-decay excision: phase infinity has
genuine annular relative classes before the other toric ends are attached.

## Result

Every bounded-value pole valuation in the residual chart of
`Bl_(P^3) P^5` lies in one of finitely many weighted graph charts.  In each
chart the extended potential has a free linear Landau--Ginzburg coordinate.
Thus the finite-value boundary is stratified-submersive after the displayed
toric resolutions.  This is exactly what the bounded-value residual Stokes
argument needs.

The algebraic face calculation is complete.  A global phase-infinity collar
is a different problem and can mix the four residual thimbles with the six
ambient thimbles.  The current route instead glues only the finite-value graph
over a compact disk, transports its four Morse handles, and treats the
Orlov/Gamma marking separately.

## 1. Fixed-torus potential

Use the exact normalized potential

\[
 F_\delta(y,B,C)=S(y)+\frac{A(y)}{BC}
   +\delta^{-2}(1-B)(1-C),
 \qquad
 A=\frac Q{y_1y_2y_3}.
 \tag{1}
\]

Restrict first to a compact residual `y`-neighborhood.  Then `A` is bounded
away from zero.  The first mixed pole channel has `B` of order `delta^2` and
`C` bounded away from `0,1,infinity`.

## 2. The `B=0` face

Make the weighted substitution

\[
 B=\delta^2b.
\]

Equation (1) becomes exactly

\[
 F_\delta
 =S+\delta^{-2}\Phi_B-b(1-C),
 \qquad
 \Phi_B=\frac A{bC}+(1-C).
 \tag{2}
\]

Now perform the graph modification

\[
 \Phi_B=\delta^2r.
 \tag{3}
\]

For `delta != 0` this changes no fibre.  On the modified total space the
potential extends as

\[
 \overline F_B=S+r-b(1-C).
 \tag{4}
\]

At `delta=0`, relation (3) gives

\[
 b=-\frac A{C(1-C)}.
\]

Consequently the boundary restriction is

\[
 \overline F_B|_{\delta=0}=S+\frac AC+r.
\]

The change of coordinate

\[
 w=r+\frac AC
\]

is invertible on this face and gives the exact normal form

\[
 \overline F_B|_{\delta=0}=S(y)+w.
 \tag{5}
\]

In particular `d overline F_B/dw=1`: the pole face has no finite or boundary
critical point in this chart.  The earlier pole arc is a curve on this face;
its bounded limiting value is obtained by allowing `w` to vary.  Its large
parameter derivative was therefore a bad choice of horizontal lift, not a
vanishing cycle.

## 3. Directed acyclicity

Fix a phase `phi` and an outgoing half-plane

\[
 H_R^\phi=\{w:\operatorname{Re}(e^{-\mathrm i\phi}w)>R\}.
\]

The local rapid-decay pair on the pole face is a product

\[
 (K\times\mathbb C_w,K\times H_R^\phi),
\]

where `K` contains the remaining `y,C` coordinates.  Since the inclusion of
the half-plane into `C` induces an isomorphism on ordinary homology,

\[
 H_*(\mathbb C,H_R^\phi)=0.
\]

The relative Kunneth sequence therefore gives

\[
 H_*(K\times\mathbb C,K\times H_R^\phi)=0.
 \tag{6}
\]

The same conclusion follows directly by translating along the `w`-direction.
This product persists for small nonzero `delta`.  Solving the graph equation
gives

\[
 b=\frac A{C(\delta^2r+C-1)}.
\]

For `w=overline F_B`, one has `partial_r w=1+O(delta^2)` on a fixed finite
tube.  Thus a collar of this finite part of the `B=0` pole face is uniformly
excisable from the directed rapid-decay pair.

## 4. The second face and the double-pole corner

Interchanging `B` and `C` gives the second channel.  With
`C=delta^2 c`,

\[
 \Phi_C=\frac A{Bc}+(1-B),
 \qquad \Phi_C=\delta^2r,
\]

and the boundary coordinate `w=r+A/B` again gives

\[
 \overline F_C|_{\delta=0}=S(y)+w.
\]

There is a separate bounded double-pole scale.  It is not
`B,C=O(delta^2)` but

\[
 B=\delta b,\qquad C=\delta c.
\]

Then

\[
 F_\delta
 =\delta^{-2}\left(\frac A{bc}+1\right)
  -\delta^{-1}(b+c)+S+bc.
 \tag{7}
\]

Resolve the two successive cancellations by

\[
 \frac A{bc}+1=\delta r_1,
 \qquad r_1-b-c=\delta r_2.
 \tag{8}
\]

The potential extends exactly as

\[
 \overline F_{00}=S+bc+r_2.
\]

On the boundary, `bc=-A`; hence

\[
 \overline F_{00}|_{\delta=0}=S-A+r_2.
 \tag{9}
\]

Again the last graph coordinate is free and linear, so the double-pole collar
has zero directed relative homology by (6).  This corrects the tempting but
false inference that the two single-pole faces have no bounded-value corner.

The cross corners are linear as well.  For example, set

\[
 B=\delta b,\qquad C=1-\delta c.
\]

Then

\[
 F_\delta=S+\delta^{-1}
 \left(\frac A{b(1-\delta c)}+c\right)-bc.
\]

Introducing the graph coordinate

\[
 \frac A{b(1-\delta c)}+c=\delta r
\]

gives boundary relation `A/b+c=0` and the linear normal form

\[
 \overline F_{01}|_{\delta=0}=S+A+r.
 \tag{10}
\]

The `B=1,C=0` corner is symmetric.  These are useful finite charts, but they do
not by themselves cover every weighted approach to the corners.

## 5. Uniform charts for all pole weights

Fix `y` and a value `L`, let `T=L-S`, and put

\[
 E=\delta^{-2}B(1-B).
\]

After multiplication by `BC`, the exact fibre equation is

\[
 A+(E-TB)C-EC^2=0.
 \tag{11}
\]

For `B=delta^alpha b`, `0<alpha<2`, its two roots approach `C=0` and `C=1`
at order `delta^(2-alpha)`.  The following complementary charts cover this
continuum of weights.

Put `e=delta^2/B`, so `eB=delta^2`.  The graph of this rational monomial is
the toric surface

\[
 eB=\delta^2.
 \tag{11a}
\]

Its only finite singularity is the `A_1` point `e=B=delta=0`.  Blow up the
ideal `(e,delta)`.  The two smooth charts are

\[
 \delta=et,\quad B=et^2,
 \qquad\text{and}\qquad
 e=\delta s,\quad \delta=sB,\quad e=s^2B.
 \tag{11b}
\]

This modification is proper and toric.  The graph equations below remain
transverse after pullback.

### The `0/0` sheet

Set `C=ek` and impose

\[
 \frac Ak+1-ek-B=\delta^2w.
 \tag{12}
\]

Then exactly

\[
 F_\delta=S+w+k.
 \tag{13}
\]

On `delta=e=B=0`, relation (12) gives `k=-A`, so the boundary potential is
`S-A+w`.  The coordinate `w` is free and linear.  Since
`e=delta^(2-alpha)/b`, this one chart contains every `0<alpha<2` approach on
the `C->0` sheet.

### The `0/1` sheet

Set `C=1-ek` and impose

\[
 \frac A{1-ek}+k=Bw.
 \tag{14}
\]

Then exactly

\[
 F_\delta=S+w-k.
 \tag{15}
\]

At `delta=e=B=0`, relation (14) gives `k=-A`, hence the boundary potential is
`S+A+w`.  This chart covers every `0<alpha<2` approach on the `C->1` sheet.

### The `e=infinity` end

No Kummer cover is needed when `B << delta^2` and `C -> infinity`.  Put
`h=1/e=B/delta^2`; the same coordinate `k` satisfies `C=k/h`.  After clearing
denominators, (12) becomes

\[
 hA+hk-k^2-h^2\delta^2k=h\delta^2wk.
 \tag{16}
\]

At `h=k=0`, its derivative with respect to `h` is `A != 0`.  This end of the
graph is already smooth, and (13) still gives the exact potential `S+w+k`.
It covers `B << delta^2,C -> infinity` without ramification.  The other root
is the corresponding end of (14), with `h(1-C)=h-k`; the two descriptions
agree on their overlap.  The case `C << delta^2,B -> infinity` is symmetric.

### The infinity/one sheets

For `B -> infinity`, put `b=1/B` and `C=1-delta^2 b k`.  Then

\[
 F_\delta=S-k+b\left(k+\frac A{1-\delta^2bk}\right).
 \tag{18}
\]

Thus `k` is linear at `b=0`.  The `B->1,C->infinity` chart is symmetric.
Both `B,C->infinity` is impossible on a bounded-value fibre with `y` compact,
because the pole term is uniquely dominant.

The assertion is deliberately finite-value.  At fixed nonzero `delta`, the
end `k=infinity` is an annular phase-infinity collar and need not be
directed-acyclic by itself.  It maps to `F=infinity`, so it is absent after
restricting the graph to a compact value disk.  Calling the entire
`k`-compactification a linear rapid-decay collar would be false.

### The regular/one sheets

If `B=b` remains finite away from `0,1,infinity`, bounded values force
`C=1-delta^2 c` (or a faster approach).  Direct substitution gives

\[
 F_\delta=S+\frac A{b(1-\delta^2c)}+(1-b)c.
 \tag{19}
\]

Since `b != 1`, the coordinate `c` is linear at the boundary.  The chart with
`B` and `C` interchanged is identical.  As `b->1`, these charts meet the
residual component (2).  The imbalanced residual end has an exact unramified
chart: put

\[
 r=Z^{-1},\qquad v=ZU,\qquad \delta=rh.
\]

Then

\[
 B=1-h+r^2h^2A,
 \qquad C=1-r^2hv+r^2h^2A,
\]

and

\[
 F_\delta=S+\frac A{BC}+v-Ah-r^2hAv+r^2h^2A^2.
 \tag{20}
\]

At `r=h=0` this is `f_Q+v`, so `v` is a free boundary value coordinate.
The symmetric end is identical.  The only critical points on the residual
component have `Z=U=0`.

Equations (12)--(19), the resolution (11b), their symmetric copies, and the finite charts above give
a finite toroidal atlas for every bounded pole regime with `y` in the residual
core.  Each finite-value chart has a value coordinate whose derivative is one
at the boundary and remains nonzero on a small fixed collar.  Hence the
finite-value boundary is stratified-submersive.  This does not assert that a
punctured collar at `F=infinity` has zero directed relative homology.

### Common-refinement overlap at `C=infinity`

It is cleaner in the common refinement to retain the bounded graph value
`L=F_delta` rather than compactify an auxiliary `w`.  On the `0/0` sheet put
`p=k^(-1)` and `T=L-S`.  Equations `eB=delta^2`, `C=ek` give the exact graph

\[
 eB=\delta^2,
 \qquad
 Ap^2+p-e-Bp-\delta^2pT+\delta^2=0.
 \tag{21}
\]

In the second chart of (11b), `e=s^2B`, `delta=sB`, the only new singular
overlap of (21) is

\[
 s=0,\qquad B=1,\qquad p=0.
\]

This is exactly the symmetric infinity/one chart, not a new valuation face.
Set

\[
 c=C^{-1},\qquad B=1-\delta^2c\ell.
\]

Then the graph is

\[
 L=S-\ell+c\left(\ell+
       \frac A{1-\delta^2c\ell}\right),
 \tag{22}
\]

and `partial L/partial ell=-1` at `c=0`.  The map back to (21) is

\[
 p=s^2Bc,
 \qquad B=1-s^2B^2c\ell.
\]

Thus (22) resolves the only additional finite-value overlap in the naïve
`A_1` chart.  The `c=infinity` overlap is the existing cross chart.  At
`e=infinity`, equation (16) with `w=L-S-k` has derivative `A` in the `h`
direction.  These exact checks show that the displayed finite atlas is closed
under its nontrivial common-refinement seams.

## 6. What remains

### Valuation exhaustion with `y` compact

Set `v(delta)=1`.  For `B -> 0` write `v(B)=beta>0`; for
`C -> 0` write `v(C)=gamma>0`.  Near one write
`v(1-B)=kappa>0`, `v(1-C)=lambda>0`.  If a variable tends to infinity,
its valuation is negative.  With `A,S` bounded and `A != 0`, comparison of
the two possibly divergent terms

\[
 P=\frac A{BC},\qquad q=\delta^{-2}(1-B)(1-C)
\]

gives the following complete list of bounded balances:

| boundary | necessary balance | local model |
| --- | --- | --- |
| `B -> 0`, `C` regular away from `0,1` | `beta=2` | single-pole face (5) |
| `C -> 0`, `B` regular away from `0,1` | `gamma=2` | symmetric single-pole face |
| `B,C -> 0` | `beta+gamma=2` | uniform sheet (13) |
| `B -> 0`, `C -> 1` | `beta+lambda=2` | uniform sheet (15) |
| `B -> 1`, `C -> 0` | `kappa+gamma=2` | symmetric cross face |
| `B,C -> 1` | `kappa+lambda>=2` | residual chart; equality gives `ZU` |
| `B` regular away from `0,1`, `C -> 1` | `lambda>=2` | regular/one sheet (19) |
| `B -> 1`, `C` regular away from `0,1` | `kappa>=2` | symmetric regular/one sheet |
| `B -> 0`, `C -> infinity` | `beta+2gamma=2`, `gamma<0` | smooth `e=infinity` end (16) |
| `B -> infinity`, `C -> 0` | `2beta+gamma=2`, `beta<0` | symmetric boundary |
| `B -> infinity`, `C -> 1` | `lambda>=2-beta` | linear collar (18) |
| `B -> 1`, `C -> infinity` | `kappa>=2-gamma` | linear `B=1` collar |

If both `B,C` tend to infinity, `q` is the unique dominant term and bounded
values are impossible.  If both remain bounded away from `0` and `1`, `q` is
again the unique term of valuation `-2`.  The asymmetric valuation rays in the table lie
in (13), (15), (16), (18), or (19) and their symmetric copies.  Thus the continuum
of real valuation weights is covered by finitely many algebraic charts; it is
not a continuum of boundary strata.

At `B=C=1`, put

\[
 B=1-\delta Z+\delta^2A,
 \qquad C=1-\delta U+\delta^2A.
\]

This is the one face on which the limiting potential is not linear in a graph
coordinate: it is exactly `f_Q(y)+ZU`.  Every other bounded `B,C` face in the
table has a free linear coordinate and hence vanishes by (6).

### Allowing `y` to escape

The tempting separate `y`-circuit check is insufficient.  The four
nonconstant `y` exponents are

\[
 e_1,\quad e_2,\quad e_3,\quad -e_1-e_2-e_3.
 \tag{23}
\]

They form one circuit: every proper subset is linearly independent.  On a pure
`y`-boundary stratum, an initial polynomial retaining a proper subset `I`
cannot be logarithmically critical, because the nonzero surviving monomial
values `z_m` would satisfy

\[
 \sum_{m\in I}z_m m=0.
\]

Linear independence forces every `z_m=0`, impossible on the stratum torus.
But a joint `(y,B,C,delta)` valuation can rescale the coefficient `1/(BC)`
and retain all four exponents while `y` escapes.  For example,
`y_i=-delta^(-2)/4`, `B,C=O(delta^4)` with the matching product makes all
four `y` terms and the pole term survive at the same order.  Its `B`
derivative is nonzero, so it is not a boundary critical point, but the circuit
argument does not prove that.  A valid global compactification needs a joint
valuation/fan lemma checking the full logarithmic initial system on every
mixed cone.

An asymptotic critical point at a remaining toric face must satisfy the exact
logarithmic equations

\[
 y_i-P=o(1),\quad
 -P-\delta^{-2}B(1-C)=o(1),\quad
 -P-\delta^{-2}C(1-B)=o(1).
\]

The bounded-value logarithmic gradient theorem in the Wave-2 report proves
that these equations have no escaping solution: the only bounded branch has
`B,C -> 1`, `P^4 -> Q`, and `y_i -> P`.  Thus the residual Laurent polynomial

\[
 f_Q=y_1+y_2+y_3+\frac Q{y_1y_2y_3}
\]

has no critical point at infinity, and the other toric faces are
noncharacteristic.  Equivalently, its Newton tetrahedron contains the origin
in its interior and all face polynomials are nondegenerate.

This reduces the bounded-value topology claim to one compactification
statement: close the graph over a fixed compact value disk, resolve it by the
weighted charts above and a toric compactification of `f_Q`, and apply proper
stratified isotopy away from the residual core.  The valuation table and the
logarithmic-gradient theorem leave no uncomputed finite-value critical face.
A full proof must still put the local charts into one proper common refinement
and verify submersivity on its exceptional strata.

The calculation does not prove the global rapid-decay triple

\[
 H_6(M,U_\delta\cup A_\delta^\phi)\longrightarrow
 H_5(U_\delta,U_\delta\cap A_\delta^\phi)\longrightarrow
 H_5(M,A_\delta^\phi)
\]

has zero outside terms.  Indeed, compactifying a free affine phase coordinate
produces the node `Phi rho=delta^2`.  Its resolution is elementary, but its
punctured infinity collar has annular relative homology until the finite
affine line is attached.  At fixed nonzero `delta`, further phase-infinity
ends can mix with the six ambient thimbles.  This is why the present argument
uses the value-localized rank-four group rather than claiming a rank-four
global rapid-decay group.

The remaining bounded-value obligations are:

1. prove that the finite graph atlas, restricted over a compact value disk and
   resolved by (11b) and its symmetric copies, is one proper toroidal graph;
2. verify Thom stratified submersivity on every new exceptional stratum;
3. choose a wall-free directed path system and transport the four Morse
   handles across `delta=0`; and
4. identify the transported basis with Iritani's Gamma/Orlov basis.

The highest-EV next calculation is the first two items.  No global
phase-infinity collar is needed for them.

## Mystery ledger

- **Settled:** a finite family of explicit charts covers the continuum of
  bounded pole weights; every finite-value chart is boundary-submersive.
- **Settled:** the nonintegrable fixed-metric horizontal drift is not by itself
  a Stokes obstruction.
- **Settled algebraically:** the valuation list has no bounded face beyond the
  residual core and the finitely covered linear collars; logarithmic tameness
  excludes simultaneous `y`-escape critical points.
- **Settled negatively:** the local linear coordinate does not make every
  punctured phase-infinity collar acyclic; the full global group has ten
  critical contributions.
- **Open:** one proper finite-value normal-crossing graph realizing the full
  list and its exceptional-stratum submersivity.
- **Open:** wall-free directed transport and the Orlov/Gamma marking.
