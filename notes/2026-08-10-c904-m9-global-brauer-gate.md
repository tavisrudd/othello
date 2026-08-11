# C904: the global \(M_9\) Brauer gate closes negatively

Date: 2026-08-10
Status: quarantined Paper V research; no manuscript or Lean promotion
Scope: the smooth proper generic charge-three fibre, its Hecke boundary, and
the \(D_{3,3}\) compatibility test

## Executive verdict

There is **no** global unramified Brauer class on a regular proper model of
the generic \(M_9\)-fibre whose residue on the one-line Hecke divisor is the
nontrivial ordered-pair cover. These requirements are incompatible: purity
says that every class extending across a prime divisor has zero residue
there. The cyclic algebra with ordered-pair residue is a ramified class on
the punctured Hecke neighbourhood, not a class on the smooth proper fibre.
The normal bundle \(\mathcal O(-2)\) does not change this codimension-one
obstruction.

This also corrects the direction of the proposed index argument. Let
\[
 K=k(J),\qquad
 V/K=\text{a smooth proper model of the generic }M_9\text{-fibre},
\]
and let \(\alpha\in\operatorname{Br}(K)[2]\) be the nonzero charge-two
class. To force every closed point of \(V\) to have even degree, one needs
\[
                         \alpha|_{K(V)}=0,
\]
not a nonzero unramified pullback of \(\alpha\) to \(V\). The Hecke boundary,
the type-\((5,1)\) liaison conic, and all visible determinant and normal
classes do not prove this generic splitting.

The exact surviving gate is Picard descent, with one sharp \(D_{3,3}\)
compatibility test. A geometric line bundle of odd degree on the split Hecke
conic whose descent obstruction is \(\alpha\) would prove generic splitting
and hence index two. Every presently visible line bundle has even Hecke
degree. In the \(D_{3,3}\) channel, the sole possible two-primary
cancellation is the generic curve of
\(D_{3,3}\dashrightarrow M_9\); Voisin proves that this curve exists but
does not identify its index or Picard descent obstruction.

## 1. Purity rules out the requested extension

Let \(\mathcal V\) be a regular integral proper \(K\)-model of \(V\), let
\(H\subset\mathcal V\) be a prime divisor whose generic point is the one-line
Hecke boundary, and put \(U=\mathcal V\setminus H\). At the discrete
valuation defined by \(H\), the charge-two calculation gives
\[
                    (L/K_H,z)\in\operatorname{Br}(K_H)[2]
\]
with residue
\[
 \partial_H(L/K_H,z)
   =[k(F\times F)/k(\operatorname{Sym}^2F)]\ne0.
\]
Here \(z\) is a transverse parameter and the quadratic extension orders the
two generic Jordan--Hölder factors. The residue remains nonzero after the
marked \(A_5\) base change because the ordering cover remains geometrically
connected.

For a regular integral scheme, a Brauer class is global only if it lies in
the Brauer group of every height-one local ring. Equivalently, its residue at
every prime divisor is zero. Therefore:

> **Purity no-extension theorem.** No class
> \(b\in\operatorname{Br}(\mathcal V)[2]\) restricts on \(U\) to a class
> whose residue at \(H\) is the nontrivial ordered-pair cover.

This is a contradiction at the single discrete valuation \(H\). It does not
require control of the other boundary components.

The calculation
\[
 N_{H/\mathcal V}|_{\mathbf P^1}\cong\mathcal O_{\mathbf P^1}(-2)
\]
does not weaken the theorem. Even self-intersection may kill a later
mod-two Gysin compatibility class after a residue has been chosen, but
extension across \(H\) already requires the residue itself to vanish.

## 2. The correct relative Brauer-kernel criterion

The map
\(\operatorname{Br}(V)\to\operatorname{Br}(K(V))\) is injective because
\(V\) is regular and integral. Hence
\[
 \alpha|_{K(V)}=0
 \quad\Longleftrightarrow\quad
 \alpha|_V=0\text{ in }\operatorname{Br}(V).
\]
The low-degree edge of Hochschild--Serre gives
\[
 \operatorname{Pic}(V)\longrightarrow
 \operatorname{Pic}(V_{\bar K})^{G_K}
 \xrightarrow{\delta}\operatorname{Br}(K)
 \longrightarrow\operatorname{Br}(V).
\]
Consequently
\[
 \boxed{
 \alpha|_{K(V)}=0
 \Longleftrightarrow
 \alpha=\delta(\mathcal L)
 \text{ for some }
 \mathcal L\in\operatorname{Pic}(V_{\bar K})^{G_K}.}
\]

On the split Hecke conic \(C_{\bar K}\cong\mathbf P^1\), such a line bundle
must have odd degree: \(\mathcal O(1)\) has descent obstruction \(\alpha\),
whereas \(\mathcal O(2)\) descends. Existing calculations show:

- every universal-twist-independent determinant line has even Hecke degree;
- the boundary normal has degree \(-2\);
- the common-line quadric has top degree two; and
- the charge-two and linked type-\((5,1)\) conics represent \(\alpha\), but
  only after restriction to their own function fields.

Thus the visible Picard lattice contains no line bundle with descent
obstruction \(\alpha\). If a future Picard-generation theorem identifies it
with the full geometric Picard group, then \(\alpha\) **survives** in
\(\operatorname{Br}(V)\); that would rule out this parity proof, not prove
index two. Conversely, one unseen invariant odd-degree Picard class would
kill \(\alpha\) and close the index-two theorem.

If \(\alpha|_{K(V)}=0\), every closed point \(p\in V\) has even degree:
restriction followed by corestriction gives
\[
                         [k(p):K]\alpha=0,
\]
and \(\alpha\) has exact order two. Subject to the previously isolated proper
Hecke-compactification hypothesis, the Hecke conic supplies a degree-two
point, so then \(\operatorname{ind}(V)=2\). If
\(\alpha|_{K(V)}\ne0\), this class gives no parity obstruction to points on
\(V\); an intrinsic odd point remains possible.

## 3. The liaison divisor does not globalize the class

The line-marked \(D'_{5,1}\) generic conic over \(k(J\times F)\) has class
exactly the pullback of \(\alpha\), so its own function field splits
\(\alpha\). The honest \(\mathbf P^2\)-, \(\mathbf P^1\)-, and later
\(\mathbf P^3\)-bundles in the liaison construction prove stable
birationality with the charge-two Severi--Brauer conic.

This is a divisor calculation. The line-marked liaison carrier is not
dominant over the four-dimensional generic fibre \(V\). Splitting on that
divisor is compatible with both
\(\alpha|_{K(V)}=0\) and \(\alpha|_{K(V)}\ne0\). It records the boundary
residue; it neither extends the ramified class nor settles the generic
Brauer kernel.

## 4. The exact \(D_{3,3}\) cancellation locus

Voisin proves two distinct facts:

1. \(D_{3,3}\dashrightarrow M_9\) is dominant; dimensions ten and nine make
   its generic fibre a curve \(C\);
2. \(D_{3,3}\to\operatorname{Sym}^2\Theta\) has generic fibre birational to
   \(\operatorname{Sym}^2(E_3)\), and its MRC map factors through
   \(\operatorname{Sym}^2\Theta\).

Let \(Y\) be the generic fibre of
\(\operatorname{Sym}^2\Theta\to J\), and let \(W\) be the generic
\(D_{3,3}\)-fibre over \(K=k(J)\). Then
\[
                 K(Y)\subset K(W),\qquad K(V)\subset K(W).
\]
The generic fibre over \(Y\) is birational to
\(\operatorname{Sym}^2(E_3)\). Its index divides three: the plane
polarization gives a degree-three zero-cycle on \(E_3\), and the Abel map
from \(\operatorname{Sym}^2(E_3)\) has projective-line fibres. Restriction on
two-torsion Brauer classes is therefore injective:
\[
 \operatorname{Br}(K(Y))[2]\hookrightarrow\operatorname{Br}(K(W))[2].
\]
It follows that
\[
 \alpha|_{K(V)}=0
 \Longrightarrow \alpha|_{K(W)}=0
 \Longrightarrow \alpha|_{K(Y)}=0.
\]
Thus a nonzero restriction on the unordered-theta fibre would prove that the
charge-two class survives on \(V\), killing the proposed global index-two
route.

The converse has one missing datum. Even if
\(\alpha|_{K(Y)}=0\), hence \(\alpha|_{K(W)}=0\), restriction
\[
 \operatorname{Br}(K(V))[2]\longrightarrow\operatorname{Br}(K(W))[2]
\]
may kill a nonzero class through the generic curve
\(C=D_{3,3,\eta}/K(V)\). If \(C\) has an odd-degree zero-cycle, restriction
is injective and there is no cancellation. If \(C\) has even index, a
two-primary cancellation is possible; in the conic case its Brauer class is
the kernel generator. Voisin proves only that this generic fibre has
dimension at most one (hence one by dimension count). She does not compute
its genus, index, or Picard descent class.

The exact \(D_{3,3}\) gate is therefore:

> Compute the index and degree-one Picard obstruction of the curve cut out by
> the type-\((3,3)\) section condition inside the generic
> \(\mathbf P H^0(X,E)\cong\mathbf P^3\) of a charge-three bundle.

No other \(D_{3,3}\) residue cancellation is visible in the cited geometry.

## 5. Relative surface restrictions

Let \(S_i\) be one of the finitely many divisor-intersection surface
components in the rigidified relative minimal-cycle construction and put
\(K_i=k(S_i)\). A nontrivial ordered-pair cover over a component of
\(S_i\cap(F+F)\) proves
\(\alpha_i\ne0\in\operatorname{Br}(K_i)[2]\). This is necessary input, but
does not prove that every point of the pulled-back \(M_9\)-fibre has even
degree. For each \(i\), the additional assertion is exactly
\[
                         \alpha_i|_{K_i(V_i)}=0.
\]
Equivalently, one needs an invariant geometric Picard class on \(V_i\) with
descent obstruction \(\alpha_i\), or another proof of the same relative
Brauer-kernel statement. Boundary residue proves ramification of the
charge-two class, not splitting by \(V_i\). Therefore no single global
unramified class currently forces all surface restrictions to have index
two.

## 6. Strongest honest theorem

> **Global Brauer no-bypass theorem.** The nonzero ordered-pair residue on
> the one-line Hecke boundary cannot be the residue of a Brauer class
> unramified on a smooth proper generic \(M_9\)-fibre. The even normal bundle
> and type-\((5,1)\) liaison do not change this. The charge-two class forces
> index two exactly when it lies in
> \(\ker(\operatorname{Br}(K)\to\operatorname{Br}(K(V)))\), equivalently
> when it is the descent obstruction of an invariant geometric line bundle.
> All currently visible line bundles have even Hecke degree. In the
> \(D_{3,3}\) channel, splitting on \(V\) implies splitting on the generic
> unordered-theta fibre; the sole possible converse failure is the
> two-primary index of the generic curve
> \(D_{3,3}\dashrightarrow M_9\).

This closes the proposed global/unramified Brauer route negatively. It does
not decide the intrinsic \(M_9\) index. The two surviving positive channels
are:

1. an invariant odd-Hecke-degree Picard class on the generic fibre, proving
   index two; or
2. an intrinsic odd zero-cycle on \(M_9\), possibly detected through a
   \(D_{3,3}\) curve of even index, proving index one.

## 7. Primary-source ledger

This pass read **zero papers in full**. Each source below was read partially
in the cached primary full text, at the exact passages listed.

- Kęstutis Česnavičius, *Purity for the Brauer group*,
  arXiv:1711.06456, partial read: Theorems 1.1--1.3 and Theorem 6.2
  (PDF pp. 1--2 and 13--14). Theorem 6.2 identifies the Brauer group of a
  regular integral scheme with the intersection of the height-one local
  Brauer groups inside the function-field Brauer group. Cache SHA-256:
  a62a12bbe26595aec89d31d24d46774a1ee3eff73c08da0febf5a2b472118709.

- Claire Voisin, *Abel--Jacobi map, integral Hodge classes and decomposition
  of the diagonal*, arXiv:1005.5621, partial read: construction of \(M_9\),
  the \(\mathbf P^3\) section fibre, \(D_{3,3}\), Lemma 2.4, the
  \(\operatorname{Sym}^2(E_3)\) fibre, and Lemma 2.9 (PDF pp. 10--15).
  Cache SHA-256:
  ca7103f6529128a24425dbfc1c87589402b17b12719329239fccdb590f74b547.

- Stéphane Druel, *Espace des modules des faisceaux semi-stables de rang 2
  et de classes de Chern \(c_1=0,c_2=2,c_3=0\) sur une hypersurface cubique
  lisse de \(\mathbf P^4\)*, arXiv:math/0002058, partial read: Lemma 4.3,
  Theorem 4.6 and its Luna slice, and Theorem 4.8 (PDF pp. 9--11). These are
  the primary inputs for the ordered-pair residue. Cache SHA-256:
  f9ce101a4ebdc9cdb139b37db7af36849c18505abc852aac078d72e32cbee654.

- Arnaud Beauville, *Vector bundles on the cubic threefold*,
  arXiv:math/0005017, partial read: Proposition 5.2, Theorem 6.3,
  Corollary 6.4, and Remark 6.5 (PDF pp. 11--13). These identify the coarse
  charge-two open and generic unordered boundary. Cache SHA-256:
  18ff765599773594bd83494c44b15e1fdfa9bf40b56274675fde4d8cc655d57f.

- Daniele Faenzi, *Even and odd instanton bundles on Fano threefolds of
  Picard number 1*, arXiv:1109.3858, partial read: Theorem 3.1, Steps 1--3
  (PDF pp. 16--17). These supply the elementary-transform boundary and its
  smoothing; the normal \(\mathcal O(-2)\) calculation is derived, not
  printed by Faenzi. Cache SHA-256:
  0024a632f2ca141eb4f3c09c43c65a3464646fd72fd951417abb2a3a9db90e8f.

The Hochschild--Serre edge sequence, corestriction parity argument, and
two-primary injection supplied by an odd zero-cycle are deductions in this
note. The purity obstruction and \(D_{3,3}\) field diagram are not stated
verbatim in the cited sources.

## 8. Reproducibility boundary

No new finite or symbolic computation enters this theorem. The determinant,
normal-bundle, and liaison computations reused here retain their scripts,
outputs, hashes, and replay commands in:

- 2026-08-10-c904-m9-common-line-hecke-parity.md;
- 2026-08-10-c904-charge-two-brauer-residue.md; and
- 2026-08-10-c904-liaison-conic-brauer-class.md.

No manuscript, Lean source, handoff, or task card was changed.

## 9. EJ + Tao closeout and mystery ledger

The closeout settled three points:

1. the requested unramified class with nonzero boundary residue is
   impossible by purity;
2. the correct index-two statement is a relative Brauer-kernel/Picard-descent
   problem; and
3. \(D_{3,3}\) has exactly one possible two-primary cancellation locus, its
   generic curve over \(M_9\).

Mysteries still open:

| mystery | exact evidence gap |
|---|---|
| Does \(\alpha\) split on the generic \(M_9\)-fibre? | compute the invariant geometric Picard group and its descent map |
| Does \(\alpha\) split on the generic unordered-theta fibre \(Y\)? | evaluate the charge-two class after the sum-fibre base change |
| Can \(D_{3,3}\) cancel a surviving two-class? | compute the genus, index, and degree-one Picard obstruction of its generic curve over \(M_9\) |
| What happens on the finite relative surfaces \(S_i\)? | test \(\alpha_i\in\ker(\operatorname{Br}(K_i)\to\operatorname{Br}(K_i(V_i)))\) component by component |

No further boundary-residue manipulation can settle these questions.
