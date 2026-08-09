# C756 EJ2: torus-normalized star contraction

**Lane:** `clebsch` · **Date:** 2026-08-09 · **Scope:** nonsaturated
rank-two covariance gate; no manuscript edit

## Verdict

The surviving nonsingular covariance case admits a compact normal form over
the quadratic closure.  In isotropic coordinates \((U,V)\), the collapsed
moment functional is torus-balanced:
\[
 \Lambda(U^aV^b)=0\quad(a\ne b),
 \qquad
 \Lambda((UV)^r)=\frac{2}{\binom{2r}{r}}quad(0\le r\le7). \tag{1}
\]

Consequently all eleven degree-10 star-generator contractions are the first
derivatives of one explicit multilinear weighted constant-term polynomial
\(\mathcal Z\).  The degree-9 node separators say that every off-diagonal
entry of its Hessian is nonzero at the arrangement point:
\[
 \nabla\mathcal Z=0,
 \qquad
 \partial_i\partial_j\mathcal Z\ne0\quad(i\ne j).          \tag{2}
\]

This is the smallest exact algebraic carrier found for the rank-two case.
It treats split and anisotropic covariance uniformly over
\(\overline{\mathbf F}_{53}\); their difference is the descent involution on
the isotropic coordinates.  No contradiction follows from (2) alone.  The
remaining task is to impose the passant directions and internal star nodes
on this critical-point system.

## 1. Isotropic normalization of covariance

Let \(M\) be the nonsingular covariance tensor from the TT and EJ passes.
Over \(\overline{\mathbf F}_{53}\), choose dual coordinates \((s,t)\) so
that the projection quadratic is
\[
 z^{\mathsf T}Mz=2st.                                      \tag{3}
\]
Let \((U,V)\) be the corresponding primal coordinates.  Write
\[
 \mu_{a,b}=\Lambda(U^aV^b)
 =\sum_{v\in S_0}U(v)^aV(v)^b.                             \tag{4}
\]

For \(d\le15\), the centered moment collapse gives
\[
 \Lambda((sU+tV)^d)=
 \begin{cases}
 0,&d\text{ odd},\\
 2^{1-r}(2st)^r=2s^rt^r,&d=2r.
 \end{cases}                                               \tag{5}
\]
Comparing coefficients in (5) proves (1), since the coefficient of
\(s^at^b\) on the left is
\(\binom{a+b}{a}\mu_{a,b}\).  Every central binomial coefficient occurring
for \(r\le7\) is nonzero in characteristic 53.

Thus \(\Lambda\), through the full available degree, is a weighted diagonal
coefficient extractor.  Split covariance means the two isotropic coordinate
axes descend separately to \(\mathbf F_{53}\).  In the anisotropic case they
are exchanged by Frobenius.  Formula (1) is valid in either case after scalar
normalization.

## 2. One partition function for all generator contractions

Write the centered affine equation of the arrangement line \(r_i\) as
\[
 \ell_i(U,V)=c_i+\alpha_iU+\beta_iV,
 \qquad 1\le i\le11.                                      \tag{6}
\]
Introduce independent monomer variables \(C_1,\ldots,C_{11}\) and define
\[
 \boxed{
 \mathcal Z(C)=
 2\sum_{r=0}^{5}
 \binom{2r}{r}^{-1}[U^rV^r]
 \prod_{i=1}^{11}(C_i+\alpha_iU+\beta_iV).}               \tag{7}
\]
This is a multilinear polynomial in the \(C_i\).  Since the displayed
product has degree at most 11, equation (1) gives
\[
 \Lambda\!\left(\prod_i(C_i+\alpha_iU+\beta_iV)\right)
 =\mathcal Z(C).                                           \tag{8}
\]

At \(C=c=(c_1,\ldots,c_{11})\), the product in (8) is
\(F=\prod_i\ell_i\).  Differentiation with respect to \(C_i\) deletes the
\(i\)-th factor, so
\[
 \partial_i\mathcal Z(c)
 =\Lambda\!\left(\prod_{j\ne i}\ell_j\right)
 =\Lambda(G_i)=0.                                         \tag{9}
\]
These are exactly the eleven degree-10 star-generator contractions.  The
value \(\mathcal Z(c)=\Lambda(F)=0\) follows separately because the full
product \(F\) vanishes at every star node.

Formula (7) avoids an expansion into hundreds of monomials.  Equivalently,
it is the weighted balanced constant term of
\[
 \prod_i(C_i+\alpha_i z+\beta_i z^{-1}),                  \tag{10}
\]
where a term using \(r\) copies of \(z\) and \(r\) copies of \(z^{-1}\)
receives weight \(2/\binom{2r}{r}\).

## 3. Matching form

Let \(B_{ij}=a_i^{\mathsf T}Ma_j\), where \(a_i\) is the linear coefficient
vector of \(\ell_i\) in any covariance coordinates.  Applying the
constant-coefficient quadratic differential operator associated with \(M\)
gives the coordinate-free expansion
\[
 \mathcal Z(C)=
 2\sum_{r=0}^{5}\frac{r!}{(2r)!}
 \sum_{\substack{\mathfrak m\text{ a matching}\\|\mathfrak m|=r}}
 \left(\prod_{\{i,j\}\in\mathfrak m}B_{ij}\right)
 \left(\prod_{k\notin V(\mathfrak m)}C_k\right).          \tag{11}
\]
Thus \(\mathcal Z\) is a rank-two weighted monomer--dimer partition
function.  The unusual coefficient \(r!/(2r)!\), rather than the Gaussian
Wick coefficient, records the antipodal moment sequence.

Equations (7) and (11) are the same carrier: (7) is best for split versus
anisotropic descent, while (11) is invariant under covariance-coordinate
changes.

## 4. The separator Hessian

For \(i\ne j\), differentiating twice gives
\[
 \partial_i\partial_j\mathcal Z(c)
 =\Lambda\!\left(\prod_{k\ne i,j}\ell_k\right)
 =\Lambda(h_{ij}).                                        \tag{12}
\]
The separator property says that \(h_{ij}\) vanishes on every star node
except \(N_{ij}=r_i\cap r_j\).  Hence
\[
 \partial_i\partial_j\mathcal Z(c)
 =h_{ij}(N_{ij})\ne0.                                     \tag{13}
\]
Because \(\mathcal Z\) is multilinear, its diagonal second derivatives are
zero.  Therefore the Hessian at \(c\) is a symmetric zero-diagonal
\(11\times11\) matrix with no zero off-diagonal entry.

The critical equations (9) alone can have extraneous solutions.  Condition
(13) is the exact open-star condition that prevents those solutions from
collapsing arrangement nodes or introducing a triple concurrency.

## 5. Split and anisotropic descent

The two rational covariance classes differ only after returning from the
quadratic closure.

- **Split.**  The isotropic coordinates \(U,V\) and the coefficients in
  (6)--(7) can be chosen over \(\mathbf F_{53}\).  The two possible triple
  directions are the rational isotropic axes.
- **Anisotropic.**  Frobenius exchanges \(U\) and \(V\).  After compatible
  scaling, \(\beta_i=\alpha_i^{53}\) and \(c_i\in\mathbf F_{53}\).  The
  balanced coefficients in (7) are norms/traces and descend to
  \(\mathbf F_{53}\).  There are no triple directions.

The fixed conic supplies a second involution and square-class test on the
line data.  The next pass must compare that conic descent with the covariance
descent in (7); merely solving \(\nabla\mathcal Z=0\) over the algebraic
closure would forget the internal/passant hypotheses.

## Stop and acceptance conditions

Continue only with one of these bounded targets:

1. prove that a critical point satisfying (13) forces the rank-two Gram
   matrix \((B_{ij})\) into one descent class, then contradict its conic
   square classes;
2. show that the split or anisotropic Frobenius constraints make one
   derivative in (9) nonzero; or
3. derive a covariance singularity from the Hessian minors, contradicting
   the TT separator theorem.

Stop if generic elimination of the eleven \(c_i\) is attempted without the
rank-two form (7)/(11), or if the conic character is discarded.  The
critical-point equations alone are not claimed to be rigid.

## Mystery ledger

| feature | status | exact remaining boundary |
|---|---|---|
| Normal form of the rank-two moment functional | settled | balanced moments (1) |
| Unified carrier for all eleven contractions | settled | \(\mathcal Z\), equations (7) and (11) |
| Star openness in that carrier | settled | nonzero off-diagonal Hessian (13) |
| Split/anisotropic distinction | isolated | rational axes versus Frobenius exchange |
| Does the critical system alone contradict? | no claim | must retain conic square classes |
| Next bounded gate | open | compare covariance descent with conic descent |

## Next action

Insert the fixed-conic line discriminants into the split and anisotropic
forms of (7).  Seek a square-class invariant of the rank-two Gram entries
\(B_{ij}\) or Hessian entries (13) that is forced by the critical equations
and incompatible with all eleven passants and 55 internal intersections.
