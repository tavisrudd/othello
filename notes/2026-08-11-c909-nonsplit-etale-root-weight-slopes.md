# C909: nonsplit unramified self-adjoint root-weight slopes

Date: 2026-08-11  
Status: human local construction and polarized-indecomposability criterion;
no manuscript, PDF, mirror, Lean, or commit

## Verdict

Nonsplit finite-etale root-weight slopes exist in the factorial-active
prime-power range.  The right bilinear condition is exact: a self-adjoint
embedding of an unramified coefficient extension is equivalent to expressing
the coefficient form as a trace transfer. This yields a nonsplit unramified
local etale algebra `R[T]`, rather than a split product, for every odd prime-power
root-weight block and for every dyadic block of exponent at least three.

For non-CM `E`, the resulting principally polarized graph quotients are
polarized-indecomposable.  At odd primes this follows from O-rank one; at two
it follows from the even hyperbolic O-rank-two form.  The construction does
not classify all finite-etale slopes.

## 1. The trace-transfer criterion

Let `R=Z/p^a` and let `O/R` be an unramified extension of degree `m`.  Let
`(M,B)` be a free unimodular symmetric `R`-module of rank `d`.

> **Self-adjoint unramified embedding criterion.**  An embedding
> `iota:O -> End_R(M)` whose image is self-adjoint for `B` exists if and only
> if `m` divides `d`, `M` is an `O`-module of rank `n=d/m`, and there is a
> unimodular symmetric O-bilinear form `h` on `M` such that
> 
> \[
> B(x,y)=\operatorname{Tr}_{O/R}h(x,y).
> \tag{1}
> \]

For the forward direction, self-adjointness says
`B(alpha x,y)=B(x,alpha y)`.  Perfection of the unramified trace pairing
defines a unique `h` by

\[
 \operatorname{Tr}_{O/R}(\alpha h(x,y))=B(\alpha x,y)
 \quad\text{for all }\alpha\in O.
\]

It is O-bilinear and symmetric.  Trace duality identifies the two dual
lattices, so `h` is unimodular exactly when `B` is.  Conversely (1) makes
multiplication by every element of `O` self-adjoint.  No division by the
residue degree occurs; perfection of the trace pairing is valid for every
finite etale extension, including degree divisible by `p`.

In bases the determinant relation is

\[
 \det_R B=\operatorname{disc}(O/R)^n
             N_{O/R}(\det_O h),
 \tag{2}
\]

up to the usual square of a change-of-basis determinant. The exact condition
is the trace-transfer isometry class in (1). Rank and determinant/norm are
useful necessary invariants, but at two they do not classify unimodular
symmetric forms: parity and Arf-type data must also be retained. A minimal
polynomial alone is not enough at any prime.

At `p=2` there is a useful parity obstruction.  If `B mod 2` is alternating,
then `h mod 2` must be alternating: otherwise for a vector with
`h(v,v) != 0`, multiplication by a suitable residue-field scalar makes
`Tr(h(alpha v,alpha v))` nonzero.  Hence the O-rank `n` must be even.  In
particular an alternating dyadic coefficient block cannot be the trace form
of an O-rank-one unramified module, no matter which unramified extension is
chosen.

## 2. Odd prime powers: an O-rank-one construction

Take

\[
 N=p^a,\quad p\text{ odd},\quad a\ge2,\quad d=N-2,
 \quad G_N=NI_{N-1}-J_{N-1}.
\]

At `p`, the all-ones line splits off as a unit line and the sum-zero module
is the scaled block `p^aB` of rank `d`, with `B` unimodular.  Over an odd
local ring, unimodular symmetric forms are classified by rank and determinant
square class: integral Gram--Schmidt reduces to the corresponding finite
field statement.

Let `O/R` be the unramified extension of degree `d`.  The norm on units of an
unramified extension is surjective.  Choose `c` in `O^times` so that the
rank-one trace form

\[
 h(x,y)=cxy\quad\text{on }M=O
\]

has the same determinant square class as `B`, using (2).  The classification
gives an isometry

\[
 (M,B)\simeq(O,\operatorname{Tr}_{O/R}(cxy)).
\]

Choose a monogenic unramified generator `theta` of `O/R` and set
`T=m_theta`.  Then

\[
 R[T]=O,
\]

which is a nonsplit unramified field algebra, and `T` is self-adjoint.  Its
graph is a maximal isotropic subgroup of the scaled root-weight block.  The
prime-power finite-etale cofactor theorem therefore gives primitive ordinary
divisor-product saturation.  This is factorial-active, since
`p` divides `(N-2)!` for `a>=2`.

## 3. Dyadic prime powers: the hyperbolic trace construction

Let `N=2^a` with `a>=3`, and set

\[
 d=N-2=2q,\qquad q=2^{a-1}-1.
\]

The root-weight scaled block has the basis `s_i=e_i-e_{N-1}` and Gram matrix

\[
 B=I_d+J_d.
\]

It is even unimodular over `Z_2`; its determinant has square class `-1`.
The residual quadratic form is

\[
 q_B(x)=\frac{x^tBx}{2}
       =\operatorname{wt}(x)+\binom{\operatorname{wt}(x)}2\pmod2.
\]

For `d=6 mod 8`, the elementary binomial Gauss sum is

\[
 \sum_x(-1)^{q_B(x)}=2^{d/2},
\]

so its Arf invariant is zero. The standard classification of even unimodular
two-adic forms, together with this Arf-zero reduction, gives

\[
 (S,B)\simeq H^q,
 \qquad H=\begin{pmatrix}0&1\\1&0\end{pmatrix}.
 \tag{3}
\]

Let `O/R` be the unramified extension of the odd degree `q`, and take
`M=O^2` with the hyperbolic O-bilinear form

\[
 h((x_1,x_2),(y_1,y_2))=x_1y_2+x_2y_1.
\]

Using trace-dual bases, its transfer is exactly `H^q`.  Hence (3) realizes
the root-weight `B` as `Tr h`.  Multiplication by a monogenic unramified
generator `theta` on both O-coordinates is self-adjoint and satisfies

\[
 R[m_\theta]=O.
\]

This produces a nonsplit unramified finite-etale dyadic slope for every
`a>=3`.  The parity observation in Section 1 explains why degree two on an
O-rank-one module could not have worked: here the extension degree is odd
and the O-rank is the required even value two.

For publication, this dyadic classification step requires either a pinpoint
citation with the even-unimodular hypotheses or an explicit integral
hyperbolic-splitting induction. A constructive entry is the primitive
isotropic vector `v=(1,1,1,z,0,...)`, where
`z^2+3z+6=0 mod 2^(a-1)`: its derivative is odd, so Hensel produces `z`, and
pairing `v` with the fourth coordinate is a unit. This splits one hyperbolic
plane. The independent audit verifies the type-II classification in this
rank and determinant class and checks the first case `N=8`; see
`2026-08-11-c909-nonsplit-etale-root-weight-slopes-audit.md`.

## 4. Polarized indecomposability

For a direct graph lattice, take the basis matrix

\[
 C=\begin{pmatrix}p^{-a}I&0\\p^{-a}T&I\end{pmatrix}.
\]

If `U` is a coefficient endomorphism of a non-CM elliptic power, then

\[
 C^{-1}\operatorname{diag}(U,U)C=
 \begin{pmatrix}
 U&0\\(UT-TU)/p^a&U
 \end{pmatrix}.
 \tag{4}
\]

Every rational quotient endomorphism lifts through the isogeny to such a
coefficient matrix because `End^0(E)=Q`; an idempotent lifts as an actual
rational idempotent since a map from a connected abelian variety to the finite
isogeny kernel is zero. Thus an integral quotient endomorphism has `U`
integral and centralizes `T` modulo `p^a`. A polarized product decomposition
would supply a nontrivial Rosati-self-adjoint integral idempotent of this form.

In the odd construction, the centralizer modulo `p^a` is `O`, whose only
idempotents are zero and one.  In the dyadic construction it is
`M_2(O)`, but a self-adjoint idempotent for the hyperbolic `h` would split
`O^2` orthogonally into nondegenerate rank-one summands.  This is impossible:
`h(v,v)` is always in `2O`, so no rank-one restriction is unimodular.  Hence
the reduced idempotent is again zero or one.  An idempotent congruent to zero
(respectively one) modulo `p^a` is zero (respectively one) by repeated
p-adic divisibility.  The resulting ppav is therefore polarized-indecomposable.

This claim uses the non-CM hypothesis, so that rational endomorphisms are
coefficient matrices.  It does not claim absolute simplicity or rule out
nonsymmetric endomorphisms.

## Consequences and audit boundary

Both constructions have `R[T]` a nonsplit unramified local etale algebra
rather than `R times R`.
By the finite-etale block theorem, their primitive minimal class is an
ordinary integral divisor product.  They are new examples in which the
prime divides the factorial ceiling, so this conclusion is not supplied by
the easy prime-support argument.

The standard maximal-isotropic graph construction globalizes the local form:
the root polarization has discriminant supported at `p`, the self-adjoint
graph is maximal isotropic in its `p^a`-kernel, and quotienting gives the
descended principal polarization. The theorem should not be widened without
additional work:

1. If the root block has a different `N` with several primary factors, the
   trace-form test must be applied separately at every prime and CRT then
   assembles only compatible graph kernels.
2. At two, alternating parity is a real obstruction to O-rank one, not an
   artifact of a chosen basis.
3. Finite-etale slopes still give only the zero-radical branch.  The
   nilpotent carry and its degree-sensitive elementary divisors remain
   outside this result.

## EJ/TT closeout and mystery ledger

- **Settled:** finite-etale self-adjointness has a complete trace-form
  criterion, with no hidden trace denominator.
- **Settled:** the root-weight family has pure nonsplit unramified slopes in every
  factorial-active odd prime-power case and every dyadic exponent at least
  three.
- **Settled:** these examples are polarized-indecomposable, not merely
  nonscalar graph presentations.
- **EJ:** the scalar and split-etale CRT families now have a genuinely
  nonsplit local-etale, indecomposable counterpart.
- **TT check:** the construction exposes a concrete dyadic obstruction
  (alternating form versus O-rank one) rather than hiding it in an attempted
  diagonalization.
- **Open:** classify all trace-transfer forms compatible with the root-weight
  block and determine their global isogeny orbits.
- **Open:** decide whether the indecomposable nonsplit family has a usable
  second geometric separation detector beyond divisor-product saturation.

**Vibe:** nonsplit etale gluing is not a cosmetic refinement: it produces
indecomposable, factorial-active root-weight examples while sharply revealing
the dyadic parity boundary.
