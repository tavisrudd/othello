# C907 Jordan-biproduct extension obstruction

**Lane:** `clebsch`

**Status:** theorem-grade linear-algebra reduction of the minimal analytic
blowup gate.  Once a nilpotent operator is defined on the primitive-sixth
packet, failure of strict blowup additivity is measured by one explicit
`Ext^1` class.  Associated-grade and formal direct-sum theorems erase exactly
this class.

## The two-block calculation

Let `K=Q(zeta_6)`, and let `(V,N_V)` and `(W,N_W)` be finite-dimensional
nilpotent `K[N]`-modules.  Suppose an enriched comparison identifies the
underlying vector space of a third object with `V direct-sum W`, but its
operator has block form

\[
 N_E=
 \begin{pmatrix}
 N_V&A\\
 0&N_W
 \end{pmatrix},
 \qquad A:W\longrightarrow V.
 \tag{1}
\]

The nilpotence condition on (1) makes `E` an extension of `W` by `V` as a
`K[N]`-module.  Changing the vector-space splitting by

\[
 P_X=\begin{pmatrix}1&X\\0&1\end{pmatrix}
 \tag{2}
\]

changes the off-diagonal block to

\[
 A\longmapsto A+XN_W-N_VX.
 \tag{3}
\]

Consequently the invariant obstruction is

\[
 [A]\in
 \operatorname{coker}\!left(
 d:\operatorname{Hom}_K(W,V)\longrightarrow\operatorname{Hom}_K(W,V),
 \quad dX=N_VX-XN_W
 \right).
 \tag{4}
\]

Equivalently,

\[
 [A]\in\operatorname{Ext}^1_{K[N]}(W,V).
 \tag{5}
\]

The enriched comparison is a strict biproduct

\[
 (E,N_E)\cong(V,N_V)\oplus(W,N_W)
 \tag{6}
\]

if and only if `[A]=0`.  Thus the desired blowup theorem is not a new rank or
Jordan-form calculation: it is the vanishing of (5) for the actual analytic
off-diagonal block.

## Exact Jordan obstruction spaces

For indecomposable nilpotent modules

\[
 J_a=K[N]/(N^a),\qquad J_b=K[N]/(N^b),
\]

the standard PID resolution gives

\[
 \operatorname{Ext}^1_{K[N]}(J_b,J_a)
 \cong K[N]/(N^{\min(a,b)}).
 \tag{7}
\]

In particular its `K`-dimension is `min(a,b)`.  Equal primitive-sixth formal
monodromy does not help: it is precisely what permits the two blocks to
interact, while the nilpotent extension space in (7) remains nonzero.

The smallest example is

\[
 0\longrightarrow J_1\longrightarrow J_2
 \longrightarrow J_1\longrightarrow0.
 \tag{8}
\]

Its underlying vector space and associated grades are `K direct-sum K`, but
its class is the generator of `Ext^1(J_1,J_1)=K`.  Iterating two nonzero
classes can join three formal copies into `J_3`.  This is the exact algebra
behind the Silver warning that an associated-graded blowup formula is
insufficient.

## Blowup interpretation

After choosing Iritani's formal direct-sum comparison on the generalized
`zeta_6` sector, a proposed operation operator on a codimension-`r` blowup
has one ambient block and `r-1` shifted center blocks.  Its full off-diagonal
matrix determines classes

\[
 [A_{ij}]\in
 \operatorname{Ext}^1_{K[N]}
 (T^j\mathscr J_6(Z),\mathscr J_6(Y))
 \quad\text{and between center shifts.}
 \tag{9}
\]

Strict blowup additivity is equivalent to simultaneous vanishing of these
classes after the permitted block-triangular changes of splitting.  More
invariantly, the filtration with formal associated graded

\[
 \mathscr J_6(Y)\oplus\bigoplus_{j=1}^{r-1}T^j\mathscr J_6(Z)
 \tag{10}
\]

must split in the abelian category of nilpotent `K[N]`-modules.

Iritani's basepoint lower-left restriction term and the semiorthogonal
Gamma/Orlov gluing are candidates for the analytic representative `A`; the
double associated graded kills them by construction.  Their mere existence
does not prove that the projected class (9) is nonzero, because a different
splitting can alter `A` by (3).  The correct computation is therefore:

1. define the intrinsic nilpotent `N`;
2. project the comparison to the generalized primitive-sixth sector;
3. extract each off-diagonal `A`;
4. reduce it modulo the Sylvester image (4); and
5. check that the resulting classes vanish and that chosen null-homotopies
   compose along a weak factorization.

## Toric-pilot boundary

The toric model `Bl_(P^3)P^5` calibrates the residual center block and its
unipotent hyperplane operator.  It does not by itself test every class in
(9): the ambient `P^5` has empty primitive-sixth packet, so the
ambient--center `Ext^1` on that primary sector is vacuous.  The pilot is still
valuable for defining the center operator and its localization, but a strict
universal theorem needs a model in which ambient and center both carry the
same cyclotomic packet, or a structural argument annihilating (9).

This corrects the temptation to read a successful toric residual comparison
as the entire strict blowup theorem.  It closes the center normalization, not
the same-spectrum extension gate.

## Minimal positive theorem

For the conditional Silver theorem it is sufficient to prove:

> every smooth blowup comparison admits an intrinsic operation operator `N`
> for which all extension classes (9) vanish in the nilpotent
> `K[N]`-module category.

No Euler pairing, integral lattice, or directed Stokes marking occurs in this
statement.  Such structures may provide a geometric way to define `N` and
kill `[A]`, but the logical output consumed by weak factorization is exactly
the split module (6).

## EJ/TT and mystery ledger

- **EJ:** replace “strict analytic functoriality” by the computable quotient
  class `[A] mod (N_VX-XN_W)`.  This is the one datum associated grades erase.
- **TT:** triangularity is not splitting.  When cyclotomic spectra coincide,
  the Sylvester operator is not invertible and the extension space has the
  positive dimension (7).
- **Settled:** the necessary-and-sufficient linear obstruction to a strict
  Jordan biproduct and the precise limit of the toric pilot.
- **Open:** define intrinsic `N`, compute the projected classes (9), and prove
  their vanishing/composable splittings for arbitrary smooth blowups.
