# C904: semisimple graph slopes have primitive minimal class

Date: 2026-08-11  
Status: proved local-to-global theorem; no manuscript or Lean edit  
Scope: the positive half of the semisimple/nilpotent graph-slope dichotomy

## Verdict

**GO.**  The proposed etale-slope theorem is valid, including at (p=2):

> **Semisimple graph-slope primitivity theorem.**  Let (p) be a prime and
> let (T\in\operatorname{Sym}_g(\mathbf F_p)).  Form the principally
> polarized quotient of the elliptic-power source with coefficient
> polarization (pI_g) by the maximal isotropic graph of (T).  If the
> minimal polynomial of (T) is squarefree, then
> \[
>   \frac{\Theta^{g-1}}{(g-1)!}
>   \in\operatorname{im}\left(
>     \operatorname{Sym}^{g-1}\operatorname{NS}(A)
>       \longrightarrow H^{2g-2}(A,\mathbf Z)\right).
> \]

Thus every etale graph slope has defect order one.  Repeated factors in the
characteristic polynomial are allowed; squarefreeness is required only for
the minimal polynomial.

## 1. Unramified splitting and orthogonality

Work locally over (mathbf Z_p).  Choose a finite unramified extension
(O/\mathbf Z_p) whose residue field (k) splits the squarefree minimal
polynomial.  Then

\[
 k^g=\bigoplus_{\lambda}V_\lambda,
 \qquad T|_{V_\lambda}=\lambda I.
\]

Since (T) is self-adjoint for the coefficient form, for
(v\in V_\lambda,w\in V_\mu),

\[
 (\lambda-\mu)\langle v,w\rangle=0.
\]

Distinct roots are distinct units in (k), so the eigenspaces are pairwise
orthogonal.  Their direct sum is the whole nondegenerate space; hence the
restriction to every (V_\lambda) is nondegenerate.  This remains true when
an eigenvalue has multiplicity greater than one.

Lift this to an exact orthogonal decomposition of the coefficient lattice

\[
                         O^g=\mathop\perp_\lambda L_\lambda.
\]

There is no division by two here.  Lift one (V_\lambda) to an arbitrary
direct summand (L_\lambda).  Its Gram matrix is unimodular because its
reduction is nondegenerate, so
(O^g=L_\lambda\perp L_\lambda^\perp).  The reduction of the orthogonal
complement is the sum of the remaining eigenspaces.  Induct.  This proves the
exact lift equally over an unramified extension of (mathbf Z_2), even when
a unimodular block reduces to an alternating form.

The lifted summands need not be invariant under an integral lift of (T).
Only the graph modulo (p) enters the overlattice.  On each reduced summand
it is the scalar graph of (lambda); choose the Teichmuller scalar lift for
the lattice calculation.

## 2. The blockwise mixed-adjugate construction

Write the restriction of the unit coefficient form to (L_\lambda) as a
symmetric unimodular matrix (B_\lambda), of rank (d_\lambda).  The source
coefficient Gram is therefore

\[
                       \mathop\perp_\lambda pB_\lambda.
\]

For every (D\in\operatorname{Sym}_{d_\lambda}(O)), the block-supported
coefficient (pD) satisfies the full graph integrality condition.  Modulo
(p), it commutes with the scalar slope on its block, and after choosing the
scalar lift its commutator carry is zero.  Hence the complete divisor lattice
after base change contains

\[
             \bigoplus_\lambda p\operatorname{Sym}_{d_\lambda}(O).
\tag{2.1}
\]

No non-Hodge shear or diagonalization of the integral slope is used.

Apply the already proved integral mixed-adjugate identities to (2.1).  On a
non-target block of rank (d), the degree-(d) mixed determinant contains
the scalar (1) via (E_{11}\cdots E_{dd}).  On a target block, the
degree-((d-1)) mixed-adjugate map surjects onto the whole symmetric matrix
lattice: it gives (E_{ii}) from
(\prod_{r\ne i}E_{rr}), and gives
(-(E_{ij}+E_{ji})) from
((E_{ij}+E_{ji})\prod_{r\ne i,j}E_{rr}).

Fill every non-target block by the first identity and the target block by the
second, with coefficients from
(\operatorname{adj}(B_\lambda)) and the determinants of the other blocks.
Summing over target blocks constructs the full cofactor of
(\perp_\lambda pB_\lambda).  Under the determinant/polarization dictionary,
this cofactor is the pullback of the primitive minimal class.  The
squarefree mixed coefficient is the actual product of divisors, so no
factorial remains.  The construction uses only integral polynomial
identities and works over every unramified (O), for non-diagonal (B_\lambda)
and for (p=2).

This proves membership after tensoring with (O).

## 3. Faithfully flat descent

Let (P\subset H) be the local divisor-product lattice and let
(c\in H) be the primitive minimal class.  The graph congruence lattice,
the exterior/mixed-product map, and its image commute with the finite flat
base change (mathbf Z_p\to O).  We have proved

\[
                         c\otimes1\in P\otimes O.
\]

Equivalently, the class of (c) in the finitely generated cokernel (H/P)
dies after tensoring with (O).  Since (O/\mathbf Z_p) is faithfully flat,
membership descends and (c\in P).  Concretely, (O) is finite free and
(1\in O) is primitive, so the natural map
(H/P\to(H/P)\otimes O) is injective.

At every prime (q\ne p), the quotient isogeny identifies the integral
homology and divisor lattices.  Local membership at all primes therefore
gives the asserted global integral membership.

## 4. Exact scope and remaining theorem

This proves the positive semisimple half suggested by the exhaustive dyadic
ranks-three-and-four census and the bounded rank-five tests.  It does not
prove the converse for nonsemisimple slopes, nor the proposed (p)-typical
Jordan-height formula.  Those require control of the nilpotent carry and its
successive divided-power Bocksteins.

The argument also stays inside a graph chart.  Extending its converse or its
nilpotent filtration to arbitrary maximal isotropic gluings remains a
separate finite-geometric problem.

## Red-team checklist

- **(p=2):** safe; orthogonal complements use only inversion of a
  unimodular Gram matrix, and the mixed-adjugate identities do not divide by
  two.
- **Repeated irreducible multiplicities:** safe; after residue-field
  splitting they enlarge a nondegenerate scalar eigenspace and introduce no
  nilpotent part.
- **Unramified splitting:** safe; squarefree residue factors split after a
  finite separable residue extension, hence after a finite unramified
  extension of (mathbf Z_p).
- **Hodge compatibility:** safe; the proof changes coordinates only after
  scalar extension of the explicit coefficient and congruence lattices.  It
  never claims that the diagonalizing matrix is a geometric endomorphism.
- **Descent:** safe; finite faithful flatness descends membership in the image
  of the integral product map without trace or residue-degree multiplication.
