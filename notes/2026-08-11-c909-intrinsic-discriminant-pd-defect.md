# C909 — intrinsic discriminant datum for finite-etale graph PD saturation

Date: 2026-08-11

Status: presentation-intrinsic theorem and sharp boundary; no manuscript,
PDF, mirror, Lean, or commit change

## Verdict

There is an exact chart-independent object, but it is not a function of a
bare finite symplectic Lagrangian.  The correct object is the **self-dual
elliptic-power gluing presentation**

\[
 (V,\omega;M,G;K),
\tag{1}
\]

where `(M,G)` is the integral coefficient polarization, `V=H_1(E,Z)` is the
rank-two elliptic symplectic lattice, and `K` is a Lagrangian in the
discriminant module of `V\otimes M`.  From (1) one obtains a canonical,
graded finite group `PDDef^*(V,M,G,K)`.  Its vanishing is *by definition and
equivalently* full cohomological divided-power saturation of the actual
Neron--Severi lattice.

For a block-respecting finite-etale elliptic graph presentation, this group
vanishes in every degree.  The finite-etale condition is independent of the
choice of every transverse elliptic graph chart: slopes change by an exact
fractional-linear rule and generate the same etale algebra.  Thus the
all-degree theorem is genuinely presentation-intrinsic.

There is no stronger formulation from the abstract finite symplectic module
and its Lagrangian alone.  The tensor ruling `V\otimes M`, the integral
coefficient lattice, and its Hodge realization are indispensable.  The
individual graph midpoint slots do not descend canonically; only their total
rank-one quotient does, and in the finite-etale regime that quotient is zero.

## 1. The intrinsic gluing object

Let `(M,G)` be a positive integral coefficient lattice and let `(V,omega)`
be the unimodular symplectic homology lattice of an elliptic curve.  Put

\[
 \Lambda=V\otimes M,\qquad
 \Omega=\omega\otimes G,
 \qquad C_G=M_G^\vee/M.
\tag{2}
\]

Here `M_G^vee` is the `G`-dual of `M`.  The discriminant module of the
alternating lattice is canonically

\[
 \mathbb D_G:=\Lambda^\vee_\Omega/\Lambda
 \simeq V\otimes C_G,
 \qquad
 \overline\Omega(v\otimes x,w\otimes y)
 =\omega(v,w)b_G(x,y)\in\mathbf Q/\mathbf Z,
\tag{3}
\]

where `b_G` is the discriminant pairing of `G`.  This is the finite
symplectic (and, when available, finite quadratic) module attached to the
source polarization.

A self-dual gluing is a Lagrangian `K=K^perp` in `mathbb D_G`.  Its inverse
image gives the self-dual overlattice

\[
 \Lambda_K=\{x\in\Lambda_\Omega^\vee:x\bmod\Lambda\in K\}.
\tag{4}
\]

The associated complex torus is the polarized quotient of `E^g` by the
kernel represented by `K`.  Equations (2)--(4), rather than a graph matrix,
are the correct starting point.

An isomorphism of presentations is an isometry of coefficient lattices and a
change of symplectic marking of `V` carrying `K` to `K'`.  It carries
`Lambda_K` isometrically to `Lambda_K'`.  This is the natural groupoid.  It
is deliberately smaller than the full automorphism group of the finite
symplectic group `mathbb D_G`: the latter need not preserve the tensor
elliptic ruling or lift to the polarized Hodge lattice.

## 2. The exact, chart-free saturation defect

Assume `End(E)=Z`.  The rational divisor forms of the quotient are the forms

\[
 \Omega_A=\omega\otimes A,\qquad A=A^t\in\operatorname{Sym}(M_\mathbf Q^*),
\tag{5}
\]

that are integral on `Lambda_K`.  Define the intrinsic divisor lattice

\[
 \mathcal N_{G,K}:=
 \{A:\Omega_A\in\bigwedge^2\Lambda_K^*\}.
\tag{6}
\]

By Lefschetz `(1,1)`, (6) is `NS(A)` in this non-CM setting.  For each `k`,
let

\[
 \begin{aligned}
 P^k_{G,K}&:=\operatorname{im}\bigl(
 \operatorname{Sym}^k\mathcal N_{G,K}\longrightarrow
 \bigwedge^{2k}\Lambda_K^*\bigr),\\
 \operatorname{DP}^k_{G,K}&:=
 \left\langle\prod_r\frac{D_r^{m_r}}{m_r!}:
  D_r\in\mathcal N_{G,K},\ \sum_rm_r=k\right\rangle_{\mathbf Z},\\
 \operatorname{PDDef}^k_{G,K}&:=
 \operatorname{DP}^k_{G,K}/P^k_{G,K}.
 \end{aligned}
\tag{7}
\]

The divided powers in (7) are integral because an integral alternating form
has integral divided exterior powers.  Moreover `P^k` is contained in
`DP^k`, and both have the same rational span, so `PDDef^k` is finite.  It is
functorial for the presentation groupoid in §1.

> **Exact intrinsic classification.**
>
> \[
> \operatorname{PDDef}^k_{G,K}=0\quad(0\leq k\leq g)
> \quad\Longleftrightarrow\quad
> \operatorname{DP}\langle\operatorname{NS}(A)\rangle^k
> =\operatorname{im}(\operatorname{Sym}^k\operatorname{NS}(A))
> \quad(0\leq k\leq g).
> \tag{8}
> \]

This is the promised exact invariant object.  It is intentionally a lattice
definition, not a claim of a closed formula from finite level data.  The
minimal-class defect is the image of `Theta^[g-1]` in the degree `g-1`
quotient in (7); the full group keeps all degrees distinct.

The primary decomposition is canonical:

\[
 \operatorname{PDDef}^k_{G,K}
 \simeq\bigoplus_p\operatorname{PDDef}^k_{G,K}\{p\},
\tag{9}
\]

because the quotient in (7) is finite and formation of both lattices
commutes with `Z_p` localization.  Thus local finite-etale vanishing glues
canonically to global vanishing.

## 3. The projective finite-etale spectral packet

The affine graph coordinate can in fact be removed.  This gives the strongest
chart-free finite-etale condition, while retaining the elliptic tensor
presentation in (1).

Let `R` be `F_p` or `Z/p^a`, let `(M_R,B)` be one unimodular primary
coefficient block, and let `K_R` be its Lagrangian gluing kernel in
`V_R\otimes M_R`.  A **projective finite-etale spectral packet** for `K_R`
is the following datum after a finite unramified faithfully flat extension
`R->R'`:

\[
 M_{R'}=\mathop\perp_{s\in S}M_s,\qquad
 K_{R'}=\bigoplus_{s\in S}\ell_s\otimes M_s,
\tag{10}
\]

where every `M_s` is nondegenerate for `B`, every
`ell_s\in\mathbf P(V_{R'})` is a direct line, and the reductions of the
lines `ell_s` are pairwise distinct.  The finite set `S`, the orthogonal
summands, and the lines carry their descent action.  Formula (10) is
coordinate-free: it is invariant under `Sp(V_R)=SL(V_R)` and coefficient
isometries.  It is a projective spectrum because the `ell_s`, rather than
their affine coordinates, are retained.

> **Packet/graph equivalence.**  A transverse self-adjoint graph has finite
> etale slope algebra if and only if, after finite unramified faithfully flat
> base change, its kernel has a projective finite-etale spectral packet.

For the forward implication, split `R[T]`.  Its self-adjoint primitive
idempotents give the orthogonal summands `M_s`, and a scalar root `tau_s`
gives the line `ell_s=<e+tau_s f>`.  Finite etaleness makes the residual
roots distinct, hence the projective lines residually distinct.  Conversely,
after a further unramified extension choose a line
`ell_infinity\in\mathbf P(V)` distinct from the finitely many reductions of
the `ell_s`; such a line exists after enlarging the residue field.  With
`ell_infinity=<f>`, write `ell_s=<e+tau_s f>`.  Then (10) is the graph of
the scalar operator `T|M_s=tau_s`, and

\[
                       R'[T]\simeq\prod_{s\in S}R'
\tag{11}
\]

is finite etale.  Finite etaleness descends along `R->R'`.  This proves the
equivalence.

Thus the spectral packet is not merely a mnemonic for diagonalization: it
is the chart-free form of the finite-etale hypothesis.  It also makes clear
why a non-split unramified slope is legitimate: its individual lines and
summands exist after unramified splitting and descend as the packet, rather
than as individually defined base-ring eigenspaces.

For arbitrary primary depths, retain the source's self-dual depth filtration
as part of the gluing presentation and require a packet on each positive
depth quotient.  This removes the graph coordinate but does **not** assert a
canonical orthogonal Jordan splitting of the source.  Such a splitting is a
proof device after unramified base change; the filtered source presentation
is the invariant datum.

## 4. Exact transformation law in a graph chart

Choose an affine chart only to calculate.  A transverse Lagrangian is written

\[
 K(t)=\{(x,tx):x\in M_R\},
\tag{12}
\]

where isotropy says that `t` is self-adjoint for the coefficient form.  If

\[
 s=\begin{pmatrix}a&b\\c&d\end{pmatrix}\in\operatorname{Sp}(V_R)
\tag{13}
\]

acts on the displayed coordinate pair, then, whenever `a+bt` is invertible,

\[
 sK(t)=K(t_s),\qquad
 t_s=(c+dt)(a+bt)^{-1}.
\tag{14}
\]

This is the exact chart transformation law.  Cayley--Hamilton puts the
inverse of the invertible matrix `a+bt` in `R[t]`; applying the inverse
fractional-linear transformation gives the reverse containment.  Hence

\[
                         R[t_s]=R[t].
\tag{15}
\]

Coefficient isometries replace `t` by a conjugate.  Thus finite etaleness of
the self-adjoint slope algebra is independent of the symplectic marking and
of the chosen transverse ruling.  If the denominator in (14) is not a unit,
that chart is simply not transverse; it is not a failure of invariance.

For an arbitrary primary-depth source, require one common elliptic ruling
which is transverse on the graph blocks and require the source depth
filtration to be respected.  At each positive depth `a`, the induced
truncated slope algebra `R_a[T_a]` is then a well-defined finite-etale
algebra up to (14)--(15).  This is the precise meaning of a **filtered
finite-etale elliptic graph presentation**.  A chosen orthogonal Jordan
splitting is a calculation device, not part of the conclusion; the retained
data are the source lattice, its depth filtration, the elliptic ruling, and
the Lagrangian kernel.

The projective formulation explains the exact scope of the transformation
law: (14) is simply the action of the projective image of `Sp(V_R)` on the affine coordinate of the
points `ell_s`.  It changes neither packet nor the finite-etale predicate.

## 5. Presentation-intrinsic finite-etale PD theorem

> **Theorem.**  Let a non-CM elliptic-power gluing presentation admit a
> block-respecting filtered finite-etale elliptic graph at every bad prime.
> Then
> \[
> \operatorname{PDDef}^k_{G,K}=0\qquad(0\leq k\leq g).
> \tag{16}
> \]
> Equivalently, every integral divided power of every divisor class is an
> ordinary integral divisor product in cohomology.

### Proof

The local graph calculation is expressed without diagonalizing the unit
forms.  After a finite unramified faithfully flat splitting extension, write
on a split depth--root block `i=(a,lambda)`

\[
 T_i=t_iI+p^aS_i.
\tag{17}
\]

For a symmetric divisor coefficient `A`, the graph basis gives exactly

\[
 P^{-1}A,\quad AP^{-1},\quad
 P^{-1}(AT^t-TA)P^{-1}\quad\hbox{integral}.
\tag{18}
\]

On an `ij` slot this is the ideal `p^{e_ij}`, where

\[
 e_{ij}=\max\{a_i,a_j,
 a_i+a_j-v_p(t_j-t_i)\}.
\tag{19}
\]

The `S_i` terms in the commutator are already integral once the first two
conditions in (18) hold.  Therefore

\[
 e_{ij}\geq\max(a_i,a_j)
 \geq\left\lceil\frac{a_i+a_j}{2}\right\rceil.
\tag{20}
\]

The signed rank-one identity

\[
 p^e(uv^t+vu^t)=p^e(u+v)(u+v)^t-p^euu^t-p^evv^t
\tag{21}
\]

has no division by two.  Together with diagonal forms, (20) makes the full
local divisor lattice rank-one generated, even at `p=2`.  Such a rank-one
form pulls back to a decomposable alternating two-form on the elliptic
power, hence its square is zero.  Expanding a divided power of a signed sum
of these square-zero classes expresses it as an ordinary product.  Finite
free unramified base change commutes with the product-image quotient, so
faithful flatness descends the statement.  Finally use (9).

Every step is unchanged under (14)--(15), which proves the claimed
presentation-intrinsic form of (16).

## 6. What the midpoint calculation does and does not globalize

For any displayed matrix-of-ideals divisor lattice, define over its given
base ring its rank-one quotient

\[
 \mathcal R_{G,K}:=
 \mathcal N_{G,K}/\langle\text{rank-one forms in }\mathcal N_{G,K}\rangle.
\tag{22}
\]

After unramified splitting and choosing coefficient lines, the rank-one
quotient of the **newly formed split coefficient lattice** decomposes as

\[
 \mathcal R^{\mathrm{split}}
 \simeq\bigoplus_{i<j}
 p^{e_{ij}}O/p^{\max(e_{ij},\lceil(a_i+a_j)/2\rceil)}O.
\tag{23}
\]

The quotient (22) is presentation-invariant.  The individual summands in
(23) do not descend canonically: a splitting field can permute roots, a
different coefficient basis mixes slots, and a different transverse graph
chart uses (14).  Thus graph midpoint defects do not form canonical global
labelled classes.  A comparison of (22) with the newly formed split
rank-one hull requires a separate base-change lemma; it is not being assumed
here.  In the finite-etale theorem this issue disappears: (20)--(21)
explicitly generate the whole split divisor lattice and faithful flatness
proves vanishing over the base.

The quotient (22) is not the exact full PD defect in arbitrary gluing: it is
a rank-one obstruction/sufficient criterion.  The exact all-degree object is
(7).  In the finite-etale regime both vanish by the theorem.

## 7. Decisive no-go beyond the marked presentation

The projective packet removes the **graph chart**, not the marked
elliptic-power presentation.  This distinction is forced for two elementary
reasons.

First, the abstract finite symplectic pair `(mathbb D_G,K)` does not retain
the rational Hodge subspace in which divisor forms lie.  The latter is the
specific tensor subspace

\[
                    \omega\otimes\operatorname{Sym}(M_\mathbf Q^*)
       \subset\bigwedge^2( V\otimes M)_\mathbf Q^*.
\tag{24}
\]

It is (24), together with the integral overlattice `Lambda_K`, that defines
`mathcal N_{G,K}` in (6).  The finite pair also forgets unimodular summands
of the source coefficient lattice, whereas (7) records every cohomological
degree.  Therefore neither `mathcal N_{G,K}` nor `PDDef^*` can be recovered
from `(mathbb D_G,K)` alone.

Second, the Veronese decoration used by the proof is the cone of
decomposable coefficient forms

\[
 \{c\,vv^t\}\subset\operatorname{Sym}(M_\mathbf Q^*).
\tag{25}
\]

It is invariant under the presentation automorphisms
`Sp(V)\times O(M,G)`, and the projective packet respects it.  An arbitrary
automorphism of the finite symplectic discriminant module need not lift to
such a tensor automorphism and has no reason to preserve (24) or (25).
Consequently no Veronese-decorated rank-one quotient, midpoint decomposition,
or pure-power defect descends to the bare finite Lagrangian category.

Equivalently, already for an elementary standard finite symplectic
discriminant module, the full symplectic group is transitive on Lagrangians,
while the graph-to-packet condition is not stable under that group: an
arbitrary finite symplectic shear can turn a horizontal graph into one with
non-etale displayed slope.  Only the subgroup arising from the elliptic
factor, whose action is (14), preserves the packet.
This is a no-go for a bare-discriminant classification, not an invitation to
a classification outside the finite-etale regime.

The exact classification available in C909 is therefore (7)--(8) on the
marked self-dual elliptic gluing groupoid, and the finite-etale spectral
packet is the maximal chart-free positive criterion on that groupoid.

## 8. Families and Hodge/moduli reach

The theorem applies uniformly to every fixed finite-level graph datum as the
elliptic curve varies with the required level structure.  The resulting
family is a finite-level Hecke presentation over a modular curve.  On every
non-CM fiber, (16) gives the integral Hodge-lattice identity

\[
 \operatorname{DP}\langle\operatorname{NS}(A)\rangle
 =\operatorname{im}\bigl(\operatorname{Sym}\operatorname{NS}(A)\bigr),
\tag{26}
\]

in every cohomological degree.  In particular `Theta^[k]`, `ch_k(L)` for
every line bundle `L`, and the top divided polarization are ordinary divisor
products in cohomology.  The assertion is locally constant in the marked
integral cohomology local system.

At a CM fiber the elliptic coefficient lattice can be smaller than the full
Neron--Severi lattice, so (26) is not automatically a theorem for all new CM
divisors.  The non-CM qualification is therefore essential to the full-NS
wording.

The already constructed nonsplit trace-transfer root families give infinitely
many factorial-active examples in this marked locus.  Their local Rosati
commutant has no nontrivial self-adjoint idempotent, so for non-CM `E` their
quotients are polarized-indecomposable.  This is a meaningful strengthening
of the example supply, but still a statement about marked local data.

Nothing here proves that the forgetful image is a new special subvariety,
computes its codimension, globalizes the local etale algebra to a number
field of Hodge endomorphisms, produces an effective minimal cycle, or upgrades
cohomology to Chow.  In particular the only cubic consequence remains the
original use of the minimal class in Voisin's criterion.

## Mystery ledger

* **Settled:** `PDDef^*` in (7) is the exact presentation-intrinsic object
  whose vanishing means full cohomological PD saturation.
* **Settled:** the projective spectral packet is equivalent to finite-etale
  graph data and removes the affine graph chart.
* **Settled:** finite-etale graph data are invariant under all transverse
  elliptic ruling changes by (14)--(15), not under arbitrary finite
  symplectic relabellings.
* **Settled:** finite-etale graph presentations have `PDDef^*=0` in all
  degrees, and their local proof glues canonically prime by prime.
* **Settled:** midpoint summands are chart artifacts; their total rank-one
  quotient is intrinsic, while its vanishing is the usable statement.
* **Boundary:** no bare-discriminant/Lagrangian classification, PEL claim,
  special-locus claim, or Chow consequence follows.
