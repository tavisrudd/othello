# C904: the charge-two Brauer residue is nonzero

Date: 2026-08-10
Status: quarantined Paper V research; no manuscript or Lean promotion
Scope: the charge-two moduli gerbe, its two fixed-line Severi--Brauer conics,
and persistence after the marked \(A_5\) base change

## Executive verdict

The charge-two universal-sheaf obstruction is not merely allowed to have
order two: it has **exact** order and index two.  Its residue at the generic
strictly semistable boundary is the nontrivial double cover which orders the
two Jordan--Hoelder factors.

Consequently the fixed-common-line pencil is generically a nonsplit
Severi--Brauer conic.  Its degree map has image \(2\mathbf Z\), so it cannot
supply an odd multisection.  This remains true after passing to the marked
\(A_5\) family.

This closes only constructions inherited from charge two: a universal
charge-two sheaf, the fixed-line pencil, and the charge-two/charge-three Hecke
carrier.  It does **not** decide whether Voisin's intrinsic charge-three
fourfold fibre \(M_9\to J\) has odd index, and it does not obstruct a universal
zero-cycle obtained by another construction.

## 1. Statement

Let \(X\) be a smooth complex cubic threefold.  Let
\(\overline M_X\) be the coarse Maruyama moduli space of rank-two semistable
sheaves with

\[
             c_1=0,\qquad c_2=2[\ell],\qquad c_3=0,
\]

and let \(M_X\subset\overline M_X\) be its stable locally free locus.  The
stable moduli stack is a \(\mathbf G_m\)-gerbe over \(M_X\); denote its Brauer
class by

\[
                         \alpha_X\in\operatorname{Br}(M_X).
\]

> **Charge-two Brauer-residue theorem.**  The class \(\alpha_X\) is nonzero
> of period two, and its image at the generic field \(k(M_X)\) has index
> exactly two.  If \(D=F(X)+F(X)\) is the divisor omitted from the
> Abel--Jacobi model of \(M_X\), then at the generic point of \(D\)
> \[
>   \partial_D(\alpha_X)
>    = [k(F(X)\times F(X))/k(\operatorname{Sym}^2F(X))]
>    \ne0.
> \]
> Here the quadratic extension is the cover which orders the two generic
> lines.

After choosing a relative ordinary line \(m\subset X\), on the open locus
where \(E|_m\cong\mathcal O_m^2\), the projectivized quotient space

\[
       H_m:=\mathbf P\!\left(\operatorname{Hom}(E|_m,\mathcal O_m)\right)
       \longrightarrow M_X
\]

descends from the gerbe to the Faenzi quotient/Hecke Severi--Brauer conic of
class \(\alpha_X\).  The Iliev--Markushevich fixed-line quintic pencil is a
second conic of the same class, obtained from
\(H^0(E(1)\otimes I_m)\), not from the quotient space above.  Therefore,
over the function field of \(M_X\), both conics have degree image
\(2\mathbf Z\).

\[
 \deg CH_0(H_{m,\eta})=\deg CH_0(P_{m,\eta})=2\mathbf Z.
\]

## 2. Coarse geometry does not imply fineness

Druel proves that \(\overline M_X\) is smooth and that its second-Chern-class
map is the blow-up of the intermediate Jacobian along the Fano surface.
Beauville's formulation is

\[
  \overline M_X\cong\operatorname{Bl}_{F_2}J_2(X),
  \qquad
  M_X\cong J_2(X)\setminus(F+F).
\]

The second identity is Beauville's Corollary 6.4.  His Remark 6.5, using the
blow-up theorem, shows that the sum map

\[
               s:\operatorname{Sym}^2F\dashrightarrow F+F
\]

is generically one-to-one.

These are statements about the **coarse** moduli space.  Druel constructs a
universal quotient on the Hilbert--Grothendieck/Quot parameter scheme and
then takes a \(\operatorname{PGL}(V)\) quotient.  Neither the smoothness of
the quotient nor its identification with a blow-up descends that universal
quotient to \(M_X\times X\).  The missing descent is exactly the class
\(\alpha_X\).

## 3. The Luna slice and the residue

Work at the generic point of \(D=F+F\), away from the diagonal and the
exceptional Fano surface.  The corresponding polystable sheaf is

\[
                         E_0=I_{\ell_1}\oplus I_{\ell_2},
                         \qquad \ell_1\ne\ell_2.
\]

Druel's Lemma 4.3 gives

\[
 \dim\operatorname{Ext}^1(I_{\ell_1},I_{\ell_2})
 =\dim\operatorname{Ext}^1(I_{\ell_2},I_{\ell_1})=1,
 \qquad
 \operatorname{Ext}^2(I_{\ell_i},I_{\ell_j})=0.
\]

In the Luna slice printed in the proof of his Theorem 4.6, the effective
automorphism torus acts on the two cross-extension coordinates \(x,y\) with
weights \(+1,-1\).  The coarse transverse coordinate is consequently

\[
                               z=xy.
\]

Let

\[
 K=k(D)((z)),\qquad
 L=k(F\times F)((z)).
\]

The extension \(L/K\) is unramified quadratic at \(z=0\), and its Galois
involution exchanges the two factors.  After ordering them, normalize a
stable slice point to

\[
                              (x,y)=(1,z).
\]

Galois sends it to \((z,1)\).  After the two summands have been exchanged,
the off-diagonal entries below are the identity maps into the correspondingly
swapped slots; they are not elements of
\(\operatorname{Hom}(I_{\ell_1},I_{\ell_2})\), which vanishes.  A projective
comparison lift is

\[
                     G=\begin{pmatrix}0&1\\ z&0\end{pmatrix},
                     \qquad G\,\sigma(G)=zI.
\]

Thus the projective universal sheaf has the cyclic, equivalently quaternion,
class

\[
              (L/K,z)\in\operatorname{Br}(K)[2].
\]

For an unramified quadratic extension and a uniformizer \(z\), the residue of
this cyclic algebra is the residue-field extension.  Hence

\[
       \partial_D(\alpha_X)
       =[k(F\times F)/k(\operatorname{Sym}^2F)].
\]

The Fano surface is geometrically integral.  Therefore \(F\times F\) is
integral, the transposition acts generically freely, and the displayed
quadratic extension is a field rather than a split algebra.  The residue is
nonzero.

The numerical charge-two class is

\[
              [E]=2\bigl([\mathcal O_X]-[\mathcal O_\ell]\bigr)
              \quad\text{in }K_{\mathrm{num}}(X).
\]

Every determinant-of-cohomology weight is therefore even, while pairing with
the structure sheaf of a line gives weight two.  In particular
\(2\alpha_X=0\).  The nonzero residue proves that the period is exactly two.
The fixed-line conic constructed below represents \(\alpha_X\), so the index
is also exactly two.

## 4. The two fixed-line Severi--Brauer conics

Markushevich--Tikhomirov show that the elliptic-quintic Hilbert family is
etale-locally the projectivization of a rank-six bundle over the charge-two
moduli open.  Iliev--Markushevich then prove that, for any fixed line
\(m\subset X\), every geometric \(\mathbf P^5\) fibre contains one linear
\(\mathbf P^1\) consisting of reducible curves \(C'+m\).

There are two related but distinct conics.  On the moduli gerbe there is a
universal charge-two sheaf \(\mathcal E\).  On the nonjumping open,

\[
                   V_m=\operatorname{Hom}(\mathcal E|_m,\mathcal O_m)
\]

is a rank-two twisted vector bundle of Brauer class
\(-\alpha_X=\alpha_X\).  Its projectivization is insensitive to scalar
automorphisms and descends to the coarse moduli space.  The descended object
is the quotient/Hecke conic

\[
                            H_m=\mathbf P(V_m).
\]

The fixed-line elliptic-quintic pencil is instead

\[
       P_m=\mathbf P\!\left(H^0(\mathcal E(1)\otimes I_m)\right).
\]

Iliev--Markushevich identify its geometric fibres with the unique linear
\(\mathbf P^1\) of reducible quintics \(C'+m\).  The rank-two pushforward is
\(\alpha_X\)-twisted, so \(P_m\) is another Severi--Brauer conic representing
\(\alpha_X\).  In the rank-four determinant quadric it is the vertex pencil,
whereas \(H_m\) indexes the second ruling.  They must not be identified,
even though they have the same Brauer class and the same index.

For either nonsplit conic, the Hochschild--Serre boundary sends the geometric
class \(\mathcal O_{\mathbf P^1}(1)\) to its Brauer class.  Since that class
has order two,

\[
        \operatorname{Pic}(H_{m,\eta})\longrightarrow
        \operatorname{Pic}(\mathbf P^1_{\overline\eta})\cong\mathbf Z
\]

has image \(2\mathbf Z\).  Equivalently, restriction followed by
corestriction shows that an odd-degree closed point would kill
\(\alpha_X\), a contradiction.  Hence

\[
                         \deg CH_0(H_{m,\eta})=2\mathbf Z.
\]

The same calculation applies to \(P_{m,\eta}\).  This gives the exact meaning
of the geometric \(1\)-versus-\(2\) dichotomy: every fixed complex fibre of
either construction is visibly a \(\mathbf P^1\), but neither generic
relative conic has a degree-one point.

## 5. Persistence under the marked \(A_5\) base change

Let \(S\) be the smooth marked \(A_5\) parameter base used in C904, after
shrinking so that the cubic family and its relative Fano surface
\(\mathcal F\to S\) are smooth.  The relative strictly semistable divisor has
generic model

\[
                    \operatorname{Sym}^2_S\mathcal F.
\]

Its ordering cover is

\[
       \mathcal F\times_S\mathcal F
       \longrightarrow \operatorname{Sym}^2_S\mathcal F.
\]

This cover cannot become split merely by the \(A_5\) marking.  Indeed, after
base change to an algebraic closure of \(k(S)\), the generic Fano surface is
still geometrically integral, so its self-product is integral.  The quotient
by transposition is generically free of degree two.  Thus the induced
extension of geometric function fields remains a nontrivial quadratic field
extension.  In particular its class in

\[
 H^1\!\left(k(\operatorname{Sym}^2_S\mathcal F),\mathbf Z/2\right)
\]

is nonzero.

The Luna-slice computation commutes with this dominant base change: the two
cross-extensions remain one-dimensional, the weights remain \(+1,-1\), and
the transverse invariant remains \(z=xy\).  Therefore the relative Brauer
class has the same nonzero residue and exact order two.

If the marked cover also selects a relative ordinary line \(m\), the Hecke
quotient conic and the quintic vertex pencil are the corresponding relative
Severi--Brauer conics.  The marking supplies the line; it does not order the
two generic Jordan--Hoelder factors and hence does not split either conic.

## 6. Boundaries and what remains open

The theorem proves all of the following negatively:

1. the Druel--Beauville blow-up does not make the charge-two moduli problem
   fine;
2. the fixed-common-line pencil has generic index two, not one;
3. the charge-two/charge-three Hecke boundary cannot provide an odd
   multisection without an additional quadratic splitting choice;
4. passing to the present marked \(A_5\) family does not supply that choice.

It does **not** prove that the cubic threefold has no universal codimension-two
cycle.  Voisin's Remark 1.6 explicitly warns that a rationally connected or
Brauer--Severi fibration can admit a universal zero-cycle while its Brauer
class is nontrivial.  Nor does the calculation reach an intrinsic cycle on
the fine charge-three space \(M_9\).  The remaining odd-index gate is:

> construct an odd zero-cycle on the generic four-dimensional fibre of
> \(M_9\to J\), or prove that this intrinsic fibre also has even index.

## 7. Primary-source ledger

This pass read **zero papers in full**.  Every item below is a
claim-specific partial read of the exact listed statements and proof
passages in the cached primary full text.

- Stephane Druel, *Espace des modules des faisceaux semi-stables de rang 2 et
  de classes de Chern \(c_1=0,c_2=2,c_3=0\) sur une hypersurface cubique
  lisse de \(\mathbf P^4\)*, arXiv:`math/0002058`.
  Lemma 4.3 (PDF p. 9), Theorem 4.6 and its Luna slice (PDF p. 10), and
  Theorem 4.8 (PDF p. 11).
  SHA-256
  `f9ce101a4ebdc9cdb139b37db7af36849c18505abc852aac078d72e32cbee654`.

- Arnaud Beauville, *Vector bundles on the cubic threefold*,
  arXiv:`math/0005017`.
  Proposition 5.2 (PDF p. 11), Theorem 6.3, Corollary 6.4, and Remark 6.5
  (PDF p. 13).
  SHA-256
  `18ff765599773594bd83494c44b15e1fdfa9bf40b56274675fde4d8cc655d57f`.

- Dimitri Markushevich and Alexander Tikhomirov, *The Abel--Jacobi map of a
  moduli component of vector bundles on the cubic threefold*,
  arXiv:`math/9809140`.
  Lemma 5.3 (PDF p. 22), Corollary 5.4 and Theorem 5.6 (PDF pp. 23--24).
  SHA-256
  `04242e32b3e8950e310826ce68e903f522c7dd01559bbf2adbc7d01f9de546aa`.

- Atanas Iliev and Dimitri Markushevich, *The Abel--Jacobi map for a cubic
  threefold and periods of Fano threefolds of degree 14*,
  arXiv:`math/9910058`.
  Lemma 3.4 (PDF p. 15).
  SHA-256
  `bd141b86f38ba1b90e5f3a91f963125d897da147ea3ec4c3c041cf0251ce1405`.

- Claire Voisin, *Cycle classes on abelian varieties and the geometry of the
  Abel--Jacobi map*, arXiv:`2212.03046`.
  Remark 1.6 (PDF p. 3), for the distinction between splitting a Brauer
  class and possessing a universal zero-cycle.
  SHA-256
  `f61faf4c9b4e9a75ab8a99c749c04df93d858ca29a7057b895ecf56c87c83b43`.

The residue computation in Section 3 is a deduction from Druel's printed
Luna slice and Beauville's generic identification of the boundary with
\(\operatorname{Sym}^2F\); it is not stated verbatim in those sources.
