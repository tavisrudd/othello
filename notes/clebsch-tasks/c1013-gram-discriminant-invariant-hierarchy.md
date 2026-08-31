# C1013 — Gram–discriminant invariant hierarchy

**Lane:** clebsch
**Status:** classical Wronskian mechanism identified; norm factorization proved
as a classical-derived corollary; downstream arithmetic/reconstruction payload
remains under audit.
**Scope:** research note only. No manuscript or Ergodis source was edited.

## Executive result

The quartic all-field character formula is the first nontrivial case of a
general invariant-theoretic factorization. It is forced by three facts:

1. the invariant pairing on a Veronese module has kernel
   \(B_d(\ell^d,m^d)=[\ell,m]^d\);
2. a Gram determinant vanishes twice whenever two marked points collide;
3. the degree-two invariant space of a binary quartic is one-dimensional.

Consequently the four-point degree-four Gram determinant is not an isolated
calculation: it is the discriminant of the root quartic times its unique
quadratic invariant.

## 1. General factorization

Let \(V\) be two-dimensional over a field \(K\), let \(d\ge 1\), and let
\(B_d\) be the invariant bilinear form on the degree-\(d\) Veronese module,
normalized on pure powers by

\[
 B_d(\ell^d,m^d)=[\ell,m]^d.
\]

For \(r\le d+1\), put

\[
 G_{d,r}(\ell_1,\ldots,\ell_r)
 =\det\bigl(B_d(\ell_i^d,\ell_j^d)\bigr)_{i,j=1}^r
\]

and let \(F=\prod_{i=1}^r\ell_i\) be the binary \(r\)-ic with these roots.
In characteristic zero, or safely when the relevant polarizations and
root-to-coefficient descent are separable (in particular
\(\operatorname{char}K>\max\{d,r\}\)), there is an invariant
\(\Phi_{d,r}\) of binary \(r\)-ics, of coefficient degree

\[
 2(d-r+1),
\]

such that

\[
 \boxed{G_{d,r}(\ell_1,\ldots,\ell_r)
       =\Delta(F)\,\Phi_{d,r}(F).}
\]

Here \(\Delta(F)=\prod_{i<j}[\ell_i,\ell_j]^2\), up to the conventional
global scalar.

More intrinsically, define the exterior-Veronese covariant

\[
 \Psi_{d,r}(F)=
 \frac{\ell_1^d\wedge\cdots\wedge\ell_r^d}
      {\prod_{i<j}[\ell_i,\ell_j]}.
\]

Both numerator and denominator are alternating in the roots, so their
quotient is symmetric and descends to the root form. If \(B_d^{\wedge r}\)
denotes the induced bilinear form on \(\bigwedge^r\operatorname{Sym}^dV\),
then

\[
 \boxed{\Phi_{d,r}(F)
 =B_d^{\wedge r}(\Psi_{d,r}(F),\Psi_{d,r}(F)).}
\]

Thus the residual invariant is canonically the norm of the
Vandermonde-divided exterior Veronese covariant.

### Proof

The exterior vector
\(W=\ell_1^d\wedge\cdots\wedge\ell_r^d\) is alternating in the labelled
roots. The alternating-polynomial/Vandermonde divisibility argument gives

\[
 W=\left(\prod_{i<j}[\ell_i,\ell_j]\right)\Psi_{d,r}.
\]

The Gram determinant is the induced norm
\(B_d^{\wedge r}(W,W)\). Taking the norm of the displayed factorization
immediately gives \(G_{d,r}=\Delta\Phi_{d,r}\).

The quotient is still symmetric and \(SL_2\)-invariant. Its degree in each
root is

\[
 2d-2(r-1)=2(d-r+1),
\]

so symmetric root-to-coefficient descent makes it an invariant of the same
coefficient degree. This proves the factorization.

At the boundary \(r=d+1\), \(\Phi_{d,d+1}\) has degree zero, recovering the
ordinary Vandermonde/Gram identity. For \(r>d+1\), the determinant vanishes
because the ambient Veronese module has dimension \(d+1\).

## 2. Why the quartic formula is forced

Take \(d=r=4\). The residual invariant has degree

\[
 2(4-4+1)=2.
\]

The degree-two invariant space of a binary quartic is one-dimensional,
spanned by the apolar invariant \(I\). Hence

\[
 \boxed{G_{4,4}=c\,\Delta I}
\]

for a normalization constant \(c\ne0\). With the pure-power kernel above and
the roots normalized to \((\infty,0,1,\lambda)\),

\[
 \Delta=\lambda^2(1-\lambda)^2,
 \qquad I=\lambda^2-\lambda+1,
\]
and \(c=16\). Thus

\[
 \det\operatorname{Gram}
 =16\lambda^2(1-\lambda)^2(\lambda^2-\lambda+1).
\]

There is an even stronger representation-theoretic forcing. Here
\(\Psi_{4,4}\) has coefficient degree one and takes values in
\(\bigwedge^4\operatorname{Sym}^4V\). Since the five-dimensional quartic
module is self-dual and

\[
 \bigwedge^4\operatorname{Sym}^4V\simeq
 (\operatorname{Sym}^4V)^*,
\]

\(\Psi_{4,4}\) is, up to scalar, the unique equivariant linear apolar
identification. Its norm is therefore the apolar quadratic invariant. This
explains both the factor \(I\) and its uniqueness without expanding a single
determinant.

For four distinct \(K\)-rational roots the discriminant is visibly a square,
so the square class is forced:

\[
 [\det\operatorname{Gram}]=[I(F)]\in K^\times/K^{\times2}.
\]

The finite-field character formula is therefore a square-class corollary of
an invariant identity, not fundamentally a character-sum theorem. Character
sums enter only when counting the fibres of this invariant.

## 3. The four-point hierarchy

For \(d=2m\), normalize the four points as above and set

\[
 a=\lambda^m,\qquad b=(1-\lambda)^m.
\]

The zero-diagonal \(4\times4\) determinant gives the exact identity

\[
 G_{2m,4}(\lambda)
 =\bigl(1-(a+b)^2\bigr)\bigl(1-(a-b)^2\bigr).
\]

Equivalently, the extra degeneracy locus is the union of four generalized
Fermat loci

\[
 \lambda^m\pm(1-\lambda)^m=\pm1,
\]

after removing the collision factors at \(0,1,\infty\).

The residual \(\Phi_{2m,4}\) is a binary-quartic invariant of degree
\(4m-6\). Since the quartic invariant ring is \(K[I,J]\), it is a weighted
homogeneous polynomial in \(I\) and \(J\), with \(\deg I=2\) and
\(\deg J=3\). With

\[
 I=\lambda^2-\lambda+1,
 \qquad J=(\lambda+1)(\lambda-2)(2\lambda-1),
\]

the first cases are

\[
\begin{aligned}
 \Phi_{4,4}&=16I,\\
 \Phi_{6,4}&=(320I^3+J^2)/9,\\
 \Phi_{8,4}&=(1792I^5-16I^2J^2)/27,\\
 \Phi_{10,4}&=(87040I^7-3695I^4J^2+40IJ^4)/729.
\end{aligned}
\]

These identities were checked symbolically over \(\mathbf Q\). They reveal a
canonical sequence of divisors on the moduli line of four points, rather than
one exceptional quartic coincidence.

## 4. Parity dichotomy

The invariant form on \(\operatorname{Sym}^d(V)\) is symmetric for even \(d\)
and alternating for odd \(d\).

- If \(d\) is odd and \(r\) is odd, \(G_{d,r}=0\).
- If \(d\) is odd and \(r\) is even, \(G_{d,r}\) is a Pfaffian square.

Thus a nontrivial quadratic-character Gram shadow can occur only in even
Veronese degree. This explains why the quartic metric shadow carries
information while its odd-degree analogue cannot carry the same kind of
square-class information.

## 5. What the invariant means in new settings

### Finite fields

For a split squarefree root form, \(\Delta(F)\) is a square, so the determinant
character is exactly the character of \(\Phi_{d,r}(F)\). For four points the
distribution is governed by the double cover

\[
 C_m:\quad y^2=\Phi_{2m,4}(\lambda).
\]

The \(m=2\) cover has genus zero and yields the exact elementary count already
used in Paper V. Higher \(m\) lead to genuine Frobenius traces and Weil bounds:
the positive and negative shadows are asymptotically balanced, with the bias
encoded by the zeta function of \(C_m\). This turns an ad hoc character count
into an arithmetic family.

### Moduli of points

On the configuration space \(M_{0,r}/S_r\), \(\Delta=0\) is the collision
boundary and \(\Phi_{d,r}=0\) is the intrinsic interior divisor where the
Veronese span becomes degenerate for the invariant form. The Gram divisor
therefore splits canonically into boundary and interior geometry.

### Real geometry

Over \(\mathbf R\), the sign of \(\Phi_{d,r}\) gives the discriminant sign of
the quadratic space cut out on the span of the Veronese points. Together with
lower principal Gram minors, the hierarchy stratifies real configuration
space by restricted signature.

### Local and global arithmetic

Over local or global fields, \([\Phi_{d,r}(F)]\) is the discriminant square
class of the restricted quadratic space after removing the visibly square
root discriminant. Hasse and spinor invariants are natural next refinements;
the determinant character is only the first arithmetic shadow.

### Coding and reconstruction

The same determinant detects degeneracy of point-generated subspaces in
Veronese evaluation modules. Its square-class coloring is therefore a
portable sparse shadow. Excess automorphisms of a \(\Phi_{d,r}\)-coloring give
the same marking-loss obstruction as in Paper V, now for an entire family.

## 6. Priority and literature boundary

The follow-up audit
[C1013 classicality audit](c1013-gram-discriminant-classicality-audit.md)
identifies the Vandermonde-divided exterior covariant as the classical
Wronskian isomorphism/Hermite-reciprocity construction. McDowell--Wildon give
an explicit version over arbitrary fields. The norm identity
\(G_{d,r}=\Delta\Phi_{d,r}\) was not found stated in the inspected sources,
but it is an immediate functorial corollary of that classical map and should
be classified as **classical-derived**, not as a standalone novelty theorem.

Kaipa--Patanker--Pradhan also explicitly derive the quartic apolar square
factor \(\lambda^2-\lambda+1\) and its finite-field counts. The viable
priority claim therefore begins only with downstream consequences not located
in the audited sources: the parity ceiling, arithmetic double-cover family,
interior moduli divisor, exceptional harmonic collapse, and reconstruction
obstructions. Those remain “to our knowledge” claims subject to the audit's
recorded coverage gaps. This is potentially latent-consequence judo, not a new
representation-theoretic engine.

## 7. Ergodis improvement notes

This example suggests capabilities beyond Boolean formula search:

1. infer a forced divisor from collision multiplicities before searching;
2. quotient candidate expressions by known discriminant/boundary factors;
3. use invariant-ring Hilbert degrees to detect uniqueness automatically;
4. search in the small basis \(I^aJ^b\), rather than raw cross-ratio
   polynomials;
5. recognize Pfaffian-square parity ceilings and stop futile character search;
6. route residual square-class counts to curve/zeta-function computation.

The present alignment-control interface is useful for live search ordering,
but it does not yet expose invariant-degree, divisor, or moduli data. No source
change is needed for this research pass; these are design notes for a future
algebraic front end.

## 8. Immediate proof gates

1. Minimize the characteristic assumptions using divided powers rather than
   ordinary symmetric powers.
2. Prove root-to-coefficient descent integrally, including small
   characteristics.
3. Decompose the exterior-Veronese covariant into irreducible \(SL_2\)
   summands and obtain closed transvectant formulas for \(\Phi_{d,r}\).
4. Compute a recurrence for \(\Phi_{2m,4}\) from
   \(s_m=\lambda^m+(1-\lambda)^m\), where
   \(s_m=s_{m-1}-\lambda(1-\lambda)s_{m-2}\).
5. Continue the classical compound-matrix and symbolic-invariant audit only
   if a paper-facing novelty claim is attached to one of the downstream
   consequences; the organizing factorization itself is already downgraded.
