# C909 — moving conformal-block comparison for the jet filtration

Date: 2026-08-12
Status: independent integral comparison; durable note only; no manuscript, PDF,
mirror, Lean, or certificate edit

## Verdict

Use the integral coefficient-dual web pairing and the divided-power raising
operator. With that normalization, the proposed moving conformal-block
subbundle is **exactly** the C909 jet filtration:

\[
 \boxed{\quad
 F^r_t
 =
 \operatorname{Ann}\!\left(
 \operatorname{im}\gamma_{\,n-r+1}(E_t)
 \right)
 =
 \mathrm{CB}_{\,n-r,t}^{\,\vee},
 \qquad 0\le r\le n.
 \quad}                                                     \tag{1}
\]

Here \(E_t=\sum_i t_iE_i\), \(E_i\) raises the \(i\)-th copy of the
two-dimensional symplectic module, \(\gamma_q(E_t)\) is its divided power,
and the image is taken from the weight \(-2q\) subspace to weight zero.  The
annihilator is taken in the integral matching/web module \(W_n\) against the
coefficient-dual weight-zero module.

This is an integral identity over every torsion-free base such as
\(\mathbf Z_p\), with no etale hypothesis needed for the identity itself.
Finite-etale roots are needed for C909's unit-minor/saturation statements,
not for identifying the two subbundles.

At \(n=3\), there is no mismatch on the finite-etale locus, including the
dyadic locus after an unramified splitting field:

\[
\begin{array}{c|c|c|c}
r & \ell=n-r & \text{CB annihilator equations} & \operatorname{rank}F^r
\\ \hline
1&2& f(t)=0&4\\
2&1& \partial_i f(t)=0\ (i=1,\ldots,6)&1\\
3&0& \partial_i\partial_j f(t)=0\ (i<j)&0.
\end{array}                                                     \tag{2}
\]

For six pairwise distinct residual roots, the evaluation row, first-jet
rows, and Hessian rows have ranks \(1,4,5\), respectively; the relevant
six-slot unit minors are products of root differences.  The last assertion
is the already checked semilength-three symbolic minor theorem and remains
valid in characteristic \(2\).

## 1. Integral setup

Let \(R\) be a torsion-free ring, \(V=Re\oplus Rf\) the standard symplectic
rank-two module, and \(V^{\otimes 2n}\) the tensor power with factors indexed
by \(1,\ldots,2n\).  Let \(E_i\) be the nilpotent raising operator

\[
 E_i(f_i)=e_i,\qquad E_i(e_i)=0,
\]

acting on the \(i\)-th factor.  The \(E_i\) commute and \(E_i^2=0\).  Define

\[
 E_t=\sum_i t_iE_i,\qquad
 \gamma_q(E_t)=\sum_{\lvert S\rvert=q}t_S E_S,
 \quad t_S=\prod_{i\in S}t_i.                              \tag{3}
\]

Thus

\[
                         E_t^q=q!\,\gamma_q(E_t).            \tag{4}
\]

Let \(W_n\) be the integral two-row matching/web module, equivalently the
coefficient-one Pluecker lattice in the weight-zero \(\mathrm{SL}_2\)
invariant module.  For \(w\in W_n\), define its matching polynomial by

\[
 f_w(z)=
 \left\langle w,\gamma_n(E_z)\,f_1\otimes\cdots\otimes f_{2n}\right\rangle.
                                                                  \tag{5}
\]

For a matching \((i,j)\), the corresponding factor is \(z_i-z_j\), up to
the fixed orientation sign; hence the C909 polynomial model
\(f_m(z)=\prod_{(i,j)\in m}(z_i-z_j)\) is exactly (5).

For \(A\subset\{1,\ldots,2n\}\), put
\(v_A=e_Af_{A^c}\).  If \(\lvert A\rvert=r-1\), then
\(v_A\) has weight \(-2(n-r+1)\), and

\[
 \left\langle w,\gamma_{n-r+1}(E_t)v_A\right\rangle
       =\partial_A f_w(t),                                  \tag{6}
\]

where \(\partial_A=\prod_{i\in A}\partial_{z_i}\).  This follows by expanding
both sides in the tensor basis: \(\gamma_q\) raises a subset \(S\) disjoint
from \(A\), and the resulting coefficient is exactly the coefficient of
\(z_Az_S\) in (5).  No factorial appears because both the matching
polynomials and \(\gamma_q\) are multilinear/divided-power normalized.

The dual moving CB level \(\ell\) is the annihilator of the image of
\(\gamma_{\ell+1}(E_t)\) from weight \(-2(\ell+1)\) to weight zero.  Taking
\(\ell=n-r\), its source basis is precisely the \(v_A\) with
\(\lvert A\rvert=r-1\).  Equation (6) therefore gives

\[
 \mathrm{CB}_{n-r,t}^{\vee}
 =
 \{w:\partial_A f_w(t)=0\text{ for every }|A|=r-1\}.          \tag{7}
\]

This is the top-order jet kernel, before adding lower jets.

## 2. Why the top-order kernel equals all jets over \(\mathbf Z_p\)

The C909 filtration is

\[
 F^r_t
 =\{w:[w_S]f_w(t-w)=0\text{ for every }|S|<r\}.
\]

Because \(f_w\) is multilinear,

\[
 [w_S]f_w(t-w)=(-1)^{|S|}\partial_Sf_w(t).                    \tag{8}
\]

The right side of (7) is the order-\(r-1\) part of (8).  To recover lower
orders, use homogeneity.  Every \(f_w\) is homogeneous of degree \(n\), so
for \(|A|=d<r-1\),

\[
 (n-d)\partial_Af_w(t)
   =\sum_{i\notin A}t_i\,\partial_{A\cup\{i\}}f_w(t).          \tag{9}
\]

If all derivatives of order \(d+1\) vanish, (9) gives
\((n-d)\partial_Af_w(t)=0\).  Over a torsion-free ring, \(n-d\ne0\) is a
nonzerodivisor, so \(\partial_Af_w(t)=0\).  Iterating from \(d=r-2\) down
to \(0\) proves (1).

This is the missing conceptual bridge: the moving CB condition supplies the
top jet layer, while Euler recursively supplies the lower layers.  It is not
a consequence of the bounded-height rank recurrence alone.

## 3. The \(n=3\) check and the dyadic boundary

For \(n=3\), \(W_3\) has rank five.  The five noncrossing matching
polynomials give:

* \(r=1,\ell=2\): \(\gamma_3(E_t)\) from the all-\(f\) vector gives the
  evaluation functional \(f(t)\).  Its row is nonzero on a distinct-root
  tuple, so \(F^1\) has rank four.
* \(r=2,\ell=1\): the six vectors \(v_{\{i\}}\) give the first derivatives
  \(\partial_i f(t)\).  Their matrix has rank four; the kernel has rank one.
  The value equation is already implied by
  \(3f(t)=\sum_i t_i\partial_if(t)\).  At \(p=2\), \(3\) is a unit.
* \(r=3,\ell=0\): the fifteen vectors \(v_{\{i,j\}}\) give the mixed
  Hessians \(\partial_i\partial_jf(t)\).  For six pairwise distinct
  residual roots, a five-by-five minor is a unit times a product of root
  differences, so the Hessian map is injective and \(F^3=0\).  This is the
  squarefree six-slot profile \((1,4,5)\), equivalently the Smith row
  \((0,1,1,1,2)\) after graph weighting.

The equality at \(p=2\) must be interpreted over the unramified torsion-free
ring (for example \(\mathbf Z_2^{\mathrm{nr}}\)) before reduction.  If one
works directly over a ring with \(2\)-torsion, Euler descent can fail because
the factors \(n-d\) in (9) need not be cancellable.  In the \(n=3\) etale
case the unit Hessian minor still makes the final \(F^3\) equality survive
reduction; the six-root finite-field checks over \(\mathbf F_8\) found the
profile \((1,4,5)\) for every ordered distinct tuple tested.

A non-etale warning is real: over a torsion ring, the kernel of the top
divided-power derivative layer can strictly contain the full jet kernel when
Euler factors become zero divisors.  Such a failure is outside C909's
pairwise-etale hypothesis and is not an \(n=3\) etale counterexample.

## 4. Ordinary powers and the correct integral CB normalization

Equation (4) is load-bearing.  Over \(\mathbf Z_p\), annihilators of
\(\operatorname{im}E_t^q\) and \(\operatorname{im}\gamma_q(E_t)\) coincide:
the former image is \(q!\) times the latter, and multiplication by the
nonzero integer \(q!\) is injective in the coefficient-dual target.

Over \(R/p^aR\), this is false when \(p\mid q!\): ordinary \(E_t^q\) can
collapse while \(\gamma_q(E_t)\) remains nonzero.  In particular, in
characteristic \(2\), \(E_t^2=2\gamma_2(E_t)=0\), whereas
\(\gamma_2(E_t)\) is generally nonzero.  A CB subbundle intended to commute
with integral base change must therefore be defined using divided powers
(or the integral hyperalgebra), not ordinary powers.

There is a second \(p=2\) normalization trap.  The diagrammatic
Temperley–Lieb trace pairing has loop parameter \(2\) and is not generally
unimodular at \(2\).  The pairing needed for (1) is the coefficient-dual
pairing between the integral web lattice and the dual weight-zero module.
For example, the naive self-web Gram matrix in the two-matching case has
entries proportional to

\[
 \begin{pmatrix}4&2\\2&4\end{pmatrix},
\]

so its reduction mod \(2\) is degenerate.  The premise that the \(n=2\) CB
kernel equals the C909 moving line implicitly fixes the coefficient-dual
(or divided-power-renormalized) pairing.  Using the raw TL trace form would
already spoil that premise at \(p=2\), and cannot be used to prove the
C909 comparison.

## 5. Exact scope

The moving-CB identity (1) is an integral statement about the marked
\(\mathrm{SL}_2\) web/matching lattice and the chosen point \(t\).  It does
not prove the all-\(n\) Dyck-height Smith formula.  That formula additionally
requires the saturated unit-minor theorem identifying the ranks of the
successive \(F^r_t\) with \(H(n,n-r)\).  The CB interpretation explains why
the target ranks are fusion/path counts; it does not supply integral
saturation or the Vandermonde-product minors.

The strongest honest packaging is:

> The C909 jet filtration is the dual moving \(\mathfrak{sl}_2\) conformal
> block filtration after divided-power normalization.  Its successive
> generic ranks are the bounded-height Dyck counts once the integral
> osculating-web saturation theorem is proved.  At \(n=3\), the comparison is
> exact on the finite-etale locus, including \(p=2\); there is no earliest
> etale mismatch.

## Audit conclusion

**GO with normalization caveat.** The stronger moving-CB definition genuinely
identifies the filtration, not just numerically, over torsion-free integral
bases. The two exact hazards are:

1. replacing divided powers by ordinary powers after reduction modulo \(p\);
2. replacing the coefficient-dual web pairing by the raw non-unimodular TL
   trace pairing at \(p=2\).

Neither produces an \(n=3\) counterexample under the intended finite-etale,
divided-power, coefficient-dual conventions.
