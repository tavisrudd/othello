# C909: finite-etale higher blocks and the root-weight CRT family

Date: 2026-08-11  
Status: corrected conditional higher-exponent theorem and explicit root-weight
family; human lattice proof; no manuscript, PDF, mirror, Lean, or commit

## Verdict

The higher-exponent cofactor argument is valid.  Its exact hypothesis is a
block-respecting maximal-isotropic graph over `R=Z/p^a` whose **literal**
monogenic algebra `R[T]` is finite etale.  Squarefreeness after reduction is
not enough when `a>1`.  The graph-coordinate normalization must also be made
explicit: with the matrix convention below, a source polarization block
`p^a B` requires self-adjointness for `B^{-1}`.

Under those hypotheses the full local Neron--Severi graph lattice contains
all block-supported `p^a` symmetric forms after unramified splitting.  The
integral mixed-cofactor identities then put the exact polarization cofactor,
with no factorial multiplier, in the ordinary product lattice.  Faithfully
flat descent has no trace denominator.

The root-weight matrices

\[
 G_N=NI_{N-1}-J_{N-1}\qquad(N\geq3)
\]

admit an explicit global CRT assembly with scalar finite-etale local graphs.
Thus they give an unconditional infinite higher-exponent application; there is
no self-duality obstruction.  The family is scalar and does not classify the
nonscalar etale locus.

## 1. The exact local graph calculation

Work over `Z_p`.  Let `B=B^t` be unimodular of rank `r`, let `a>=1`, and put
`G=p^aB`.  Fix an integral lift of a matrix `T` over `R=Z/p^a`, and use the
standard graph-coordinate matrix

\[
 C_T=\begin{pmatrix}p^{-a}I&p^{-a}T\\0&I\end{pmatrix}.
\]

For every rational Hodge coefficient `A=A^t`, integrality against the source
first forces `A=p^aDB`, where `D` is `B^{-1}`-self-adjoint.  Direct
multiplication in the equivalent symmetric-form coordinate gives

\[
 C_T\begin{pmatrix}0&A\\-A&0\end{pmatrix}C_T^t
 =\begin{pmatrix}
 p^{-2a}(AT^t-TA)&p^{-a}A\\
 -p^{-a}A&0
 \end{pmatrix}.
 \tag{1}
\]

Consequently an integral divisor on the graph quotient has, and only has,
the source coefficient `A=p^aDB` with

\[
 D^tB^{-1}=B^{-1}D,\qquad [D,T]\equiv0\pmod {p^a}.
 \tag{2}
\]

This is the complete local Neron--Severi lattice in the non-CM elliptic-power
coefficient space.  It is independent of the chosen integral lift of `T`,
because replacing `T` by `T+p^aS` does not change (2).

The source polarization itself is the coefficient `p^aB`.  Thus its graph
kernel is isotropic exactly when

\[
 BT^t\equiv TB\pmod {p^a}.
 \tag{3}
\]

Equivalently, `T` is self-adjoint for the unimodular form `B^{-1}`:
`T^tB^{-1}=B^{-1}T`.  This is the self-adjoint convention required by the
matrix `C_T`.  If “`B`-self-adjoint” is instead used in the conventional
meaning `T^tB=BT`, then the source block must be written `p^aB^{-1}` (or the
dual graph convention must be used).  This inverse is a normalization issue,
but omitting it makes the displayed commutator assertion false for general
`B`.

## 2. Finite-etale splitting and full block divisors

Assume

\[
 \mathcal E=R[T]\subset\operatorname{End}_R(M_R)
\]

is finite etale.  Choose a finite unramified extension `O/Z_p` such that
`mathcal E tensor_R O/p^a` is a product of copies of `O/p^a`.  Its primitive
idempotents `e_lambda` are polynomials in `T`.  By (3) they are
`B^{-1}`-self-adjoint, so modulo `p^a` they split the coefficient module into
orthogonal nondegenerate summands.

Those summands lift to an *exact* orthogonal decomposition over `O`.  Lift a
basis of one summand.  Its Gram matrix is unimodular, so orthogonal projection
is integral and its exact orthogonal complement is a free direct summand whose
reduction is the complementary idempotent summand modulo `p^a`.  Inducting on
the primitive idempotents gives

\[
 M_O=\mathop{\perp}_\lambda L_\lambda,
 \qquad B=\mathop{\perp}_\lambda B_\lambda,
 \tag{4}
\]

with all `B_lambda` unimodular.  No integral diagonalization of an actual
lift of `T` is asserted or needed.  The residue of `T` is scalar on each
summand, and its off-block entries vanish modulo `p^a`.

For every symmetric form `D` supported on one `L_lambda`, equation (2) now
holds: modulo `p^a` both `T` and `T^t` are the same scalar on that block.
Hence the complete divisor lattice after base change contains

\[
 p^a\bigoplus_\lambda\operatorname{Sym}(L_\lambda^*).
 \tag{5}
\]

This is the needed full block lattice, not merely a rational subspace.

The literal finite-etale condition is essential.  Over `Z/p^2`, the symmetric
matrix

\[
 T=p\begin{pmatrix}0&1\\1&0\end{pmatrix}
\]

reduces to zero, whose minimal polynomial is squarefree, but `R[T]` has a
nonzero summand killed by `p` and is not flat, hence not etale.  Therefore
squarefree reduction cannot replace finite-etaleness at higher exponent.

## 3. Cofactor normalization and descent

Let `d_lambda=rank(L_lambda)` and `r=sum d_lambda`.  The cofactor of the
block matrix `G=p^aB` has target block

\[
 \left(\prod_{\mu\ne\lambda}
        p^{a d_\mu}\det B_\mu\right)
 p^{a(d_\lambda-1)}\operatorname{adj}(B_\lambda).
 \tag{6}
\]

This is exactly a degree-`r-1` product of forms from (5).  On a non-target
block, the product of its `d_mu` diagonal rank-one forms gives the determinant
with coefficient one.  On the target block, the product of all but one
diagonal rank-one form gives a diagonal cofactor entry, while replacing the
relevant pair by one symmetric off-diagonal form gives the corresponding
off-diagonal entry with coefficient `+/-1`.  Integral linear combinations
with the entries of `adj(B_lambda)` yield (6).  Because these are products of
distinct forms, there is neither a multinomial coefficient nor a factor two.

For a diagonal polarization matrix this normalization is visible directly:

\[
 \frac{(\sum_i g_i d_i)^{r-1}}{(r-1)!}
 =\sum_i\left(\prod_{j\ne i}g_j\right)\prod_{j\ne i}d_j.
\]

Thus the coefficient of the divided polarization is `adj(G)`, exactly, not
`(r-1)! adj(G)`.  The standard coefficient/cofactor dictionary identifies
this class with the pullback of the primitive minimal class of the principal
quotient.  Equations (5)--(6) prove membership in the actual ordinary local
product lattice.

Let `P` be that product image and `H` the local integral Hodge lattice.
Formation of `P` commutes with the finite free unramified base change
`Z_p -> O`.  Since the class of the cofactor dies in `(H/P) tensor O`, faithful
flatness gives that it already dies in `H/P`.  This avoids trace averaging;
in particular it remains valid when the unramified residue degree is divisible
by `p`.

> **Finite-etale block cofactor theorem.**  For a block-respecting maximal
> isotropic graph of the polarization block `p^aB`, satisfying (3) and with
> `R[T]` finite etale, the primitive cofactor class is in the ordinary local
> degree-`r-1` divisor-product lattice.  Orthogonal sums of such blocks and
> trivial unit blocks obey the same conclusion, target block by target block.

This is a theorem about the stated graph presentation.  It neither proves a
criterion for arbitrary maximal-isotropic kernels nor supplies the nilpotent
carry classification.

## 4. Mobius chart invariance at higher exponent

Changing between two transverse elliptic rulings is an `SL_2(R)` change.  If
both graph descriptions exist, `T` is replaced by a fractional-linear
expression in `T` with an invertible denominator.  Cayley--Hamilton expresses
that inverse as a polynomial in `T` because its determinant is a unit.
Therefore

\[
 R[T']=R[T].
\]

Finite-etaleness is invariant under these changes and under coefficient
isometries.  This is the correct chart-independence statement.  It does not
permit arbitrary symplectic shears mixing the elliptic and coefficient
factors.

## 5. Explicit global CRT root-weight families

Set `r=N-1` and let `G_N=NI_r-J_r`.  It is positive definite with

\[
 \det G_N=N^{N-2}.
\]

For every `p^a || N`, write `e=(1,...,1)` and

\[
 S_p=\{x\in\mathbf Z_p^r:\sum_i x_i=0\}.
\]

As `N-1` is a `p`-adic unit,

\[
 \mathbf Z_p^r=\mathbf Z_pe\ \perp\ S_p,
 \qquad G_N=(N-1)\ \perp\ p^aB_p,
 \tag{7}
\]

where `B_p=(N/p^a)` times the restriction of the standard dot product to
`S_p`; it is unimodular.  The `p`-primary polarization kernel has the
standard symplectic discriminant presentation

\[
 (S_p/p^aS_p)\oplus(S_p/p^aS_p).
\]

The scalar choice takes the horizontal summand

\[
 K_p=(S_p/p^aS_p)\oplus0.
 \tag{8}
\]

It is maximal isotropic, has order `p^{a(N-2)}`, and has scalar graph slope
`T_p=0`; consequently `(Z/p^a)[T_p]=Z/p^a` is finite etale.  The unit line in
(7) has no `p`-primary kernel.

The primary kernels in (8) are mutually orthogonal.  Their direct product,
or equivalently their Chinese-remainder assembly,

\[
 K_N=\bigoplus_{p^a\Vert N}K_p
 \subset\ker\lambda_{G_N},
\]

has order `N^{N-2}=sqrt(deg lambda_{G_N})` and is maximal isotropic.  Hence
the quotient

\[
 f_N:E^{N-1}\longrightarrow A_N=E^{N-1}/K_N
\]

carries a principal polarization `Theta_N` with
`f_N^*Theta_N` represented by `G_N`.  This is the standard maximal-isotropic
descent of a polarization, so there is no global self-duality obstruction.

Applying the finite-etale block theorem at every prime gives

\[
 \Theta_N^{N-2}/(N-2)!\in P_{A_N}^{N-2}\qquad(N\ge3).
\]

This is an actual CRT family, including arbitrary prime-power exponents in
`N`; it is not merely a statement conditional on the existence of regular
etale kernels.  It remains a scalar family.  A claim about every root-weight
quotient, or about nonscalar etale root-weight kernels, would require an
additional classification and is not made here.

There is also a nonscalar family on which the theorem crosses the factorial
wall.  Take `N=p^a`.

For odd `p` and `a>=2`, the unimodular defect form `B_p` in (7) diagonalizes
over `Z_p`.  Split its rank `N-2` module into two nonzero orthogonal summands
and let `T_p` act by zero on the first and one on the second.  Then

\[
                (\mathbf Z/p^a)[T_p]
                   \simeq(\mathbf Z/p^a)\times(\mathbf Z/p^a)
\]

is finite etale, `T_p` is self-adjoint, and its graph is maximal isotropic.

For `p=2`, `a>=3`, the defect form on the sum-zero lattice contains the exact
unimodular plane with Gram matrix

\[
                         \begin{pmatrix}2&1\\1&2\end{pmatrix};
\]

its orthogonal complement is also unimodular and nonzero.  Again put slope
zero on one block and one on the other.  This gives the same split finite-
etale algebra over `Z/2^a` and a nonscalar maximal-isotropic graph.  The case
`N=4` is not supplied by this two-block construction.

In all these cases `p` divides `(N-2)!`, so primitivity is not automatic from
the prime-support/factorial-threshold theorem.  The finite-etale block theorem
therefore does genuine work and gives an unconditional nonscalar principal
quotient with divisor-generated primitive minimal class for every prime power
`N=p^a` in the displayed ranges.  CRT with scalar choices at the remaining
prime powers yields further composite examples.

## Hostile audit, EJ/TT, and mystery ledger

- **Settled:** the higher graph-integrality condition is exactly (2), and
  the polarization convention is exactly (3).
- **Settled:** finite-etale splitting supplies exact orthogonal lifts; it
  does not require an integral diagonal lift of `T`.
- **Settled:** the cofactor equals the divided-polarization coefficient with
  no factorial, trace, or residue-degree multiplier.
- **Settled:** root-weight blocks have an explicit scalar CRT family at every
  exponent and nonscalar finite-etale families across the factorial wall for
  `N=p^a` in the displayed ranges; the anticipated self-duality obstruction
  is absent.
- **EJ:** this converts the formerly conditional root-weight paragraph into
  a genuine all-`N` scalar family and a nontrivial nonscalar prime-power
  family, testing the higher-exponent normalization rather than only the
  elementary theorem.
- **TT check:** the result still says nothing about a non-graph Lagrangian or
  the nilpotent radical.  Treating squarefree reduction as higher etaleness,
  or treating the scalar family as a classification, would both be false.
- **Open:** classify all nonscalar finite-etale root-weight kernels and
  determine whether any induce new geometric separation examples.
- **Open:** the carry-sensitive p-typical elementary divisors for non-etale
  blocks, including the open-chain straightening lemma, remain C908's gate.

**Vibe:** the finite-etale block theorem is a real higher-exponent level-up,
but its scope is sharply presentation-theoretic; the difficult mathematics
begins exactly at non-etale carry.
