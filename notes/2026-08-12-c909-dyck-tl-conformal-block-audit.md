# C909 — Dyck-height counts versus Temperley–Lieb/conformal-block lattices

Date: 2026-08-12  
Status: independent structural audit; no manuscript, PDF, mirror, Lean, or
certificate edit

## Verdict

The bounded-height count

\[
 B(n,h)=\#\{\text{Dyck paths of semilength }n\text{ with height }\le h\}
\]

is exactly the *rank count* of the \(\mathfrak{sl}_2\) level-\(h\) fusion/path
space with \(2n\) fundamental insertions. Equivalently, over a suitable
characteristic-zero field it is the dimension of the Temperley–Lieb path
quotient in which paths above height \(h\) are killed.

That numerical coincidence does not identify the C909 jet filtration with an
integral conformal-block or Temperley–Lieb quotient. The C909 filtration
depends on the ordered roots \(t_i\) and on the coordinatewise jet rows;
the TL/fusion quotient depends on a quantum parameter and a Jones–Wenzl
ideal. No quantum parameter occurs in the C909 data. The only safe bridge is

\[
 \operatorname{rank} F^rW_n/F^{r+1}W_n
   \stackrel{\text{candidate}}{=} H(n,n-r)
   =B(n,n-r)-B(n,n-r-1),                                  \tag{1}
\]

provided the filtered quotients are saturated. The count \(B\) itself does
not prove saturation.

## 1. What the representation-theoretic count really says

Let \(V_1\) be the two-dimensional \(\mathfrak{sl}_2\) fundamental object.
In the fusion category at level \(h\), the allowed intermediate labels are

\[
 0,1,\ldots,h,
\]

and tensoring with \(V_1\) moves the label up or down by one, with the
boundary labels \(0,h\) reflected/truncated. The vacuum multiplicity in
\(V_1^{\otimes 2n}\) is the number of walks from \(0\) to \(0\) of length
\(2n\) staying in \(0,\ldots,h\), namely \(B(n,h)\). The exact-height
difference \(H(n,h)\) is therefore a difference of dimensions at adjacent
levels; it is not itself canonically a conformal-block space.

The same path count occurs in the characteristic-zero TL link-state
quotient by the Jones–Wenzl relation at height \(h+1\). Thus, over a field,
the proposed C909 cumulative ranks and TL path ranks agree if (1) holds.
This is a useful interpretation of the numbers, not an identification of
the filtered lattices.

## 2. Parameter dependence is an exact obstruction to a canonical TL match

Already at semilength \(n=2\), write the two matching-web basis elements as

\[
 A=[12][34],\qquad B=[14][23],\qquad [ij]=u_j-u_i.
\]

The first jet kernel is

\[
 F^1W_2
  =R\bigl(\delta_{14}\delta_{23}A-\delta_{12}\delta_{34}B\bigr),
 \qquad \delta_{ij}=t_j-t_i,                              \tag{2}
\]

up to the basis/sign convention. Every displayed coefficient is a unit when
the roots are pairwise distinct modulo \(p\), and \(F^1W_2\) has rank one as
predicted by \(H(2,2)=1\).

But the line in (2) varies with the root tuple. Over the unramified quadratic
extension of \(\mathbf F_2\), choose \(\alpha^2+\alpha+1=0\). For the ordered
tuple

\[
 (t_1,t_2,t_3,t_4)=(0,1,\alpha,\alpha+1),
\]

the ratio of the two coefficients in (2) is \(\alpha\). Swapping the last two
roots gives ratio \(\alpha+1\). Both tuples have all pairwise differences
units. A fixed TL/conformal-block submodule has no such \(t_i\)-dependence.
Therefore the C909 line cannot be a canonical parameter-independent
level-one TL quotient. An arbitrary \(R\)-module isomorphism exists whenever
the quotient is free of the expected rank, but that is only a rank statement.

The same issue persists for larger \(n\): the jet filtration is a family of
submodules in the Specht/web lattice, while a level-\(h\) fusion space is
defined by a fixed quantum quotient. To obtain an equivariant comparison one
would have to construct a root-dependent TL/Bethe action preserving every
\(F^r\), and no such action is part of the C909 setup.

## 3. Integral TL/Jones–Wenzl caution

The noncrossing web module \(W_n\) itself is a free integral Plücker/Specht
lattice: coefficient-one skein relations and standard monomials give an
integral basis. This remains a free module after reduction modulo \(2\).
That fact is compatible with the C909 calculation.

It is different from an integral fusion quotient. Jones–Wenzl projectors are
defined recursively using quantum integers. In the ordinary TL convention,

\[
 f_2=1-\delta^{-1}e_1,\qquad e_1^2=\delta e_1,              \tag{3}
\]

and higher \(f_j\) contain inverses of the relevant quantum integers. At
quantum level \(h\), the characteristic-zero quotient kills \(f_{h+1}\), but
an integral lattice requires a choice of localization/tilting form in which
those denominators are controlled. At \(q=1\), (3) already requires
\(1/2\). At a root of unity, primes dividing quantum integers create the
analogous issue; for example at level \(2\), \([2]=q+q^{-1}\) is a
uniformizer above \(2\) in the usual cyclotomic realization. Thus a
characteristic-zero path dimension \(B(n,h)\) does not imply a saturated
integral TL quotient, especially at \(2\).

This is not a defect in the C909 web lattice. It shows that a
Jones–Wenzl/conformal-block citation cannot establish the C909 unit-minor
claim without an explicit integral comparison theorem.

## 4. Characteristic two: what survives and what does not

Two separate statements must be distinguished.

* In the C909 jet matrix, every raw coefficient is a sign times a product of
  root differences. If the roots are pairwise distinct modulo \(2\), those
  differences are units in the unramified splitting ring. A hypothetical
  nested minor formula of the form
  \(\pm\prod\delta_{ij}^{m_{ij}}\) would therefore remain a unit in
  characteristic \(2\). No factor \(2\) is forced by the exterior/Plücker
  calculation.
* In the TL/Jones–Wenzl realization, quantum integers can be nonunits or
  vanish after the relevant characteristic-two specialization. The
  semisimple fusion quotient can cease to be flat, and its path count need
  not control the reduction of a chosen integral projector lattice.

Hence characteristic two neither disproves the numerical Dyck profile nor
proves its saturation. It rules out using semisimple TL theory as a shortcut.

## 5. Exact integral comparison that would be sufficient

An actual comparison theorem would need all of the following, not just the
rank recurrence:

1. Construct a free integral TL/web lattice \(L_{n,h}\) with a specified
   bounded-height path basis and a specialization map to the C909 matching
   lattice \(W_n\).
2. Prove that the image equals \(F^rW_n\) for \(h=n-r\), not merely that the
   two modules have the same fraction-field dimension.
3. Prove that \(F^{r+1}W_n\subset F^rW_n\) is saturated and that the
   transition matrix from the path basis to the jet-normalized basis has
   determinant a unit. Any determinant involving quantum integers is
   insufficient at \(p=2\).
4. Show compatibility with permutations of roots, coefficient isometries, and
   the exterior Plücker relation.

The existing C909 target is equivalent to a stronger direct statement: there
must be nested jet rows and web columns whose row-reduced pivot determinants
are signs times products of \(\delta_{ij}\). This is the unimodular
osculating-web theorem. A TL path basis would be useful only after proving
this integral unitriangular comparison.

## 6. Small-width conclusion and boundary

For \(n=2\), the rank profile \((B(2,1),B(2,2))=(1,2)\) and the exact-height
profile \((H(2,1),H(2,2))=(1,1)\) are correct over every residue
characteristic with distinct roots; the explicit line (2) is primitive. This
is a direct jet calculation, not a TL argument.

For \(n=3\), the predicted cumulative ranks \((B(3,1),B(3,2),B(3,3))
=(1,4,5)\) agree with the checked five-dimensional matching calculation.
The six-slot integral theorem identifies the relevant low-width quotient
profile, but it does not supply an all-\(n\) TL-equivariant comparison.

The honest conclusion is:

> Bounded-height Dyck numbers are the correct characteristic-zero fusion/path
> ranks and the right combinatorial target for the C909 jet filtration.
> They do not identify its integral quotients with TL conformal blocks.
> Characteristic two makes the distinction sharper: C909 unit-product minors
> would be safe, while Jones–Wenzl denominators are not.

The all-\(n\) theorem remains the integral saturated osculating-web lemma, not
a formal consequence of \(\mathfrak{sl}_2\) conformal-block dimensions.

