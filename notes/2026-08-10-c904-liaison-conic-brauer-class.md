# C904: the locally free liaison conic has the charge-two Brauer class

Date: 2026-08-10
Status: quarantined Paper V research; no manuscript or Lean promotion
Scope: Voisin's distinct divisor \(D'_{5,1}\), its line-marked image in
the fine charge-three moduli space, and the remaining odd-index gate

## Executive verdict

Voisin's locally free liaison divisor does **not** escape the charge-two
factor.  Over the generic point

\[
                 K=k\bigl(J_2(X)\times F(X)\bigr),
\]

where the second coordinate is the added/trisecant line, the line-marked image
of \(D'_{5,1}\) in the charge-three moduli space has a one-dimensional generic
fibre.  Its smooth projective model is a nonsplit conic, and its Brauer class is
exactly the pullback \(\alpha_K\) of the charge-two universal-sheaf class.
Consequently

\[
                  \deg CH_0(C'_{\eta})=2\mathbf Z.
\]

The decisive point is that the \(\mathbf P^3\) of sections on the charge-three
side is an **honest** projective bundle.  Stable birationality by itself would
not identify the conic class if that \(\mathbf P^3\) were Brauer twisted.
Charge three is fine: the determinant of cohomology has scalar weight \(-1\),
so it neutralizes the universal gerbe.

This closes the most natural odd carrier in the locally free divisor
\(D'_{5,1}\).  It does not prove that the full generic fourfold fibre of
\(M_9\to J(X)\) has index two; an odd zero-cycle elsewhere in that fourfold is
still possible.

## 1. Precise statement

Let \(X\subset\mathbf P^4\) be a general smooth complex cubic threefold.
Write \(F=F(X)\) for its Fano surface and
\(J_2=J_2(X)\) for the intermediate-Jacobian torsor used by the charge-two
Abel--Jacobi model.  Put

\[
                         B=J_2\times F,
                  \qquad K=k(B).
\]

The \(J_2\)-coordinate records the charge-two bundle underlying an elliptic
quintic, and the \(F\)-coordinate records the line \(L\) added to it.
Let

\[
                         \alpha_K\in\operatorname{Br}(K)[2]
\]

be the pullback of the charge-two moduli-gerbe class.

Let \(D_{5,1}\) be Voisin's divisor of reducible sextics \(C_5\cup L\), and
let \(D'_{5,1}\) be its liaison partner, whose general member is a smooth
elliptic sextic with trisecant line \(L\).  Define \(\mathcal B'\) to be the
closure in \(M_9\times F\) of the pairs \((\mathcal E,L)\) obtained from
members of \(D'_{5,1}\).  This line-marked incidence avoids assuming that a
general nonglobally-generated charge-three bundle has a unique bad line.

> **Liaison-conic theorem.**  The generic fibre of
> \(\mathcal B'\dashrightarrow B\) has a smooth projective model \(C'/K\) of
> genus zero.  Its conic class satisfies
> \[
>                           [C']=\alpha_K
>                      \quad\text{in }\operatorname{Br}(K)[2].
> \]
> In particular \(C'(K)=\varnothing\), \(\operatorname{ind}(C')=2\), and
> \[
>                         \deg CH_0(C')=2\mathbf Z.
> \]

The same statement holds after the smooth marked \(A_5\) base change used in
C904.  If the projection \(\mathcal B'\to M_9\) is generically one-to-one
(equivalently, the general bundle in the image has a unique bad line), the
same conclusion applies literally to Voisin's unmarked image divisor in
\(M_9\).  The theorem itself does not need that uniqueness assertion.

## 2. The charge-two class remains nonzero over \(K\)

The charge-two residue calculation gives

\[
 \partial_{F+F}(\alpha)
   =\bigl[k(F\times F)/k(\operatorname{Sym}^2F)\bigr]\ne0.
\]

After adjoining the independent line coordinate, the residue extension is

\[
 k(F\times F\times F_L)/k(\operatorname{Sym}^2F\times F_L).
\]

Both numerator and denominator remain geometrically integral, so this is
still a nontrivial quadratic field extension.  Hence

\[
                   \alpha_K\ne0,
        \qquad \operatorname{per}(\alpha_K)
             =\operatorname{ind}(\alpha_K)=2.
\]

This also proves persistence after the marked \(A_5\) base change: the
ordering cover of the two generic Jordan--Hoelder factors remains
geometrically connected.

## 3. The \(D_{5,1}\) fibre is stably the conic of \(\alpha_K\)

For a generic charge-two bundle \(E_2\) and the marked line \(L\), put
\(F_2=E_2(1)\).  Over a splitting field one has

\[
 H^0(F_2)=V,\quad \dim V=6,
 \qquad
 H^0(F_2\otimes I_L)=A,\quad\dim A=2,
\]

and

\[
 F_2|_L\cong\mathcal O_L(1)\otimes W,
 \qquad \dim W=2.
\]

The three spaces \(V,A,W\) are \(\alpha_K\)-twisted.  Voisin's fixed
\((E_2,L)\) union is the rank-four quadric cone

\[
 Q=\bigcup_{x\in L}\mathbf P H^0(F_2\otimes I_x)
   =\{[a,M]\in\mathbf P(A\oplus U\otimes W):\det M=0\},
 \qquad U=H^0(\mathcal O_L(1)).
\]

Its vertex is \(\mathbf P(A)\), and either ruling resolution is a
\(\mathbf P^3\)-bundle over a Severi--Brauer conic.  For the quotient ruling
that conic is

\[
                         C_\alpha=\mathbf P(W^\vee),
                         \qquad [C_\alpha]=\alpha_K.
\]

Once pulled back to \(C_\alpha\), the twisted spaces split and the ruling
resolution is an honest \(\mathbf P^3\)-bundle.  Therefore

\[
                    K(Q)=K(C_\alpha)(t_1,t_2,t_3).
\]

In particular \(Q\) is stably birational to \(C_\alpha\), and
\(\alpha_K\) vanishes over \(K(Q)\).  Equivalently, the generic point of
\(Q\subset\mathbf P(V)\) splits the Brauer--Severi ambient space.

## 4. The liaison incidence: \(\mathbf P^2\), then \(\mathbf P^1\)

The liaison correspondence must be kept distinct from the later
\(\mathbf P^3\) of bundle sections.

For a general sextic \(E\) in either \(D_{5,1}\) or \(D'_{5,1}\), the
quadrics in \(Y\) containing \(E\) form a projective plane.  Choosing one
gives a quadric K3 surface

\[
                              S=Y\cap Q_1.
\]

On \(S\), adjunction gives \(E^2=0\), while
\(H^2=6\) and \(H\cdot E=6\).  Thus the residual divisor has

\[
                (2H-E)^2=0,
             \qquad H\cdot(2H-E)=6.
\]

On the generic locus it is a primitive nef elliptic pencil, so

\[
                         h^0(S,\mathcal O_S(2H-E))=2.
\]

After choosing \(S\), the residual sextic therefore moves in a
\(\mathbf P^1\).  The fully flagged liaison incidence is generically a tower

\[
                     \mathbf P^1\longrightarrow\mathcal I
                       \longrightarrow\mathbf P^2
\]

over either divisor, hence is birational to a \(\mathbf P^2\times\mathbf
P^1\)-bundle on both sides.  The construction is symmetric because
\(E+E'\in|2H|_S\) implies \(E\in|2H-E'|_S\).

These are honest projective bundles: they come from the universal Hilbert
curve, its rank-three space of containing quadrics, and the residual elliptic
linear system.  No sheaf-moduli gerbe enters.  Consequently, after taking the
generic fibre over \(B\),

\[
 K(D_{5,1})(x_1,x_2,x_3)
    \cong_K
 K(D'_{5,1})(y_1,y_2,y_3).
\]

Voisin compresses the unflagged complete-intersection correspondence as a
\(\mathbf P^2\)-fibration on each side.  The extra \(\mathbf P^1\) above
keeps the chosen K3 and the member of its residual pencil visible; it is
birationally redundant but prevents confusion with the section
\(\mathbf P^3\).

Combining this with Section 3 shows

\[
                   \alpha_K|_{K(D'_{5,1})}=0.
\]

Indeed it vanishes after a purely transcendental extension, and
\(\operatorname{Br}(L)\to\operatorname{Br}(L(t))\) is injective for every
field \(L\).

## 5. Why the section \(\mathbf P^3\) is honest

Let \(E_3\) be the normalized charge-three bundle, with numerical class

\[
                 [E_3]=2[\mathcal O_X]-3[\mathcal O_L].
\]

Riemann--Roch gives

\[
                              \chi(E_3)=2-3=-1.
\]

On the stable-bundle stack, the universal bundle has scalar weight \(+1\).
Its determinant-of-cohomology line has scalar weight \(\chi(E_3)=-1\).
Tensoring the universal bundle by that line gives weight zero and therefore
descends to the coarse charge-three moduli space.  This is a direct
neutralization of the gerbe; no choice of a splitting field remains.

After twisting by \(\mathcal O_X(1)\), Voisin's bundles have four sections.
On the dense open where higher cohomology vanishes, their pushforward is an
honest rank-four vector bundle \(\mathcal H\).  A general section vanishes on
a smooth elliptic sextic, and Voisin's map has fibre

\[
                              \mathbf P(\mathcal H_b)\cong\mathbf P^3.
\]

For \((\mathcal E,L)\in\mathcal B'\), one has

\[
                  \mathcal E|_L\cong
                  \mathcal O_L(3)\oplus\mathcal O_L(-1).
\]

A general global section restricts to the positive summand and has three
zeros on \(L\).  Hence its zero curve belongs to \(D'_{5,1}\), and

\[
                 D'_{5,1}\dashrightarrow\mathcal B'
\]

is generically the honest \(\mathbf P^3\)-bundle \(\mathbf P(\mathcal H)\).
Since \(\dim D'_{5,1}=11\), \(\dim\mathcal B'=8\); over
\(\dim B=7\), its generic fibre is a curve.

Let \(C'/K\) be the smooth projective model of that curve.  Then

\[
                    K(D'_{5,1})=K(C')(z_1,z_2,z_3).
\]

The stable birational comparison with \(Q\) becomes rational after extending
to \(\overline K\).  Thus \(C'_{\overline K}\) is stably rational.  A smooth
projective curve which is stably rational has no regular one-forms, hence has
genus zero.

## 6. Identification of the conic class

Section 4 shows that \(\alpha_K\) vanishes over \(K(D'_{5,1})\).  Section 5
and injectivity under a purely transcendental extension then give

\[
                         \alpha_K|_{K(C')}=0.
\]

Let \(\beta=[C']\in\operatorname{Br}(K)[2]\) be the Brauer class of the
genus-zero curve.  The conic kernel theorem says

\[
             \ker\bigl(\operatorname{Br}(K)\to
                        \operatorname{Br}(K(C'))\bigr)
                     =\{0,\beta\}.
\]

Since \(\alpha_K\ne0\) and dies over \(K(C')\), one must have

\[
                               \beta=\alpha_K.
\]

This proves the theorem.  It also gives a convention-independent description:
the two conics need not be presented by the same quaternion equation; they
are the unique nontrivial genus-zero splitting varieties for the same class.

The residual liaison changes the Abel--Jacobi coordinate by inversion and a
translation determined by the complete intersection and the marked line.
The equality above uses the \(K\)-identification inherited from the
\((E_2,L)\) source data.  If one instead uses the charge-three Abel--Jacobi
coordinate as the literal coordinate on \(J\), the statement is the pullback
of \(\alpha\) by that explicit affine involution, not an unmarked claim that
every translation fixes the Brauer class.

## 7. What this closes, and what it does not

The theorem closes the following proposed odd routes:

1. the reducible \(D_{5,1}\) common-line carrier;
2. its fully locally free liaison partner \(D'_{5,1}\);
3. the line-marked nonglobally-generated divisor in charge three;
4. any attempt to obtain odd degree merely by cutting the honest section
   \(\mathbf P^3\) over that divisor.

It does **not** show that the generic fourfold fibre of \(M_9\to J\) has
index two.  A variety can contain an index-two conic and still have an odd
zero-cycle elsewhere.  Nor does it prove generic uniqueness of the bad line,
extend the construction across singular cubics, or descend it through the
unmarked exotic deck.

The strongest honest conclusion is therefore:

> Both visible type-\((5,1)\) carriers, including the distinct locally free
> liaison divisor, inherit exactly the same charge-two Brauer obstruction.
> Any odd carrier must leave the entire type-\((5,1)\) liaison architecture.

## 8. Primary-source ledger and derivation boundary

This pass read **zero papers in full**.  Every source claim below was checked
by a claim-specific partial read of the exact listed statements and proof
passages in cached primary full text.

- Claire Voisin, *Abel--Jacobi map, integral Hodge classes and decomposition
  of the diagonal*, arXiv:`1005.5621`, SHA-256
  `ca7103f6529128a24425dbfc1c87589402b17b12719329239fccdb590f74b547`.
  PDF p. 10 constructs the rank-two bundle and its four sections; PDF p. 11
  gives \(\dim M_9=9\) and the general section fibre \(\mathbf P^3\); PDF
  p. 13 defines \(D_{5,1}\), \(D'_{5,1}\), the trisecant line, and the
  splitting \(\mathcal O_L(3)\oplus\mathcal O_L(-1)\); PDF p. 14 gives the
  liaison correspondence and its projective-fibration comparison.

- Stephane Druel, *Espace des modules des faisceaux semi-stables de rang 2...*,
  arXiv:`math/0002058`, SHA-256
  `f9ce101a4ebdc9cdb139b37db7af36849c18505abc852aac078d72e32cbee654`.
  Lemma 4.3 (PDF p. 9), Theorem 4.6 and its Luna slice (PDF p. 10), and
  Theorem 4.8 (PDF p. 11) supply the charge-two boundary slice used by the
  residue theorem.

- Arnaud Beauville, *Vector bundles on the cubic threefold*,
  arXiv:`math/0005017`, SHA-256
  `18ff765599773594bd83494c44b15e1fdfa9bf40b56274675fde4d8cc655d57f`.
  Proposition 5.2 (PDF p. 11), Theorem 6.3, Corollary 6.4, and Remark 6.5
  (PDF p. 13) identify the charge-two coarse space and the generic
  \(\operatorname{Sym}^2F\) boundary.

- Dimitri Markushevich and Alexander Tikhomirov, *The Abel--Jacobi map of a
  moduli component of vector bundles on the cubic threefold*,
  arXiv:`math/9809140`, SHA-256
  `04242e32b3e8950e310826ce68e903f522c7dd01559bbf2adbc7d01f9de546aa`.
  Lemma 5.3 and Theorem 5.6 (PDF pp. 22--24) give the charge-two
  \(\mathbf P^5\) section family.

- Atanas Iliev and Dimitri Markushevich, *The Abel--Jacobi map for a cubic
  threefold and periods of Fano threefolds of degree 14*,
  arXiv:`math/9910058`, SHA-256
  `bd141b86f38ba1b90e5f3a91f963125d897da147ea3ec4c3c041cf0251ce1405`.
  Corollary 4.4 and the following restriction calculation (PDF p. 19) give
  \(E_2(1)|_L\cong2\mathcal O_L(1)\) and the two-dimensional restriction
  kernel used in the rank-four quadric.

The following steps are deductions, not statements quoted verbatim from the
sources:

1. the flagged \(\mathbf P^2\)-then-\(\mathbf P^1\) symmetric liaison tower;
2. neutralization of the charge-three gerbe by its weight-\(-1\)
   determinant-of-cohomology line;
3. descent of Brauer splitting through the honest \(\mathbf P^3\);
4. the conic-kernel identification \([C']=\alpha_K\).

They use only K3 adjunction and the elliptic-pencil theorem, determinant
weights, injectivity of the Brauer group under adjoining variables, and the
standard Brauer kernel of a conic.
