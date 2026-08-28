# C982 MDS conductors and coordinatewise endomorphism algebras

**Lane:** `ame-lu`

**Status:** completed 2026-08-27

## Goal

Develop the mathematical compression exposed by C981 without editing the
active C979 manuscript.  Replace the branch-by-branch CSS calculation by a
standard conductor and coordinatewise-endomorphism-algebra statement, extend
the MDS conductor lemma beyond the half-rate case, and determine exactly how
partial-support conductors control the first non-MDS departures.

## Questions

1. For MDS codes (E=[n,k]) and (F=[n,\ell]), what are the sharp general
   dimension and support bounds for \(\operatorname{Cond}(E,F)\)?
2. Can the equal-dimension nullity-(0/1) theorem be derived transparently from
   the product Singleton bound, and which part remains paper-local?
3. Does the CSS block system form a natural coordinatewise endomorphism
   algebra whose symplectic units recover the transversal Clifford group?
4. In the MDS--CSS case, is that algebra canonically of type
   \(\mathbf F_q\times\mathbf F_q\) or \(M_2(\mathbf F_q)\), and can the two
   logical groups be recovered as norm-one units?
5. What algebraic data, beyond conductor dimensions, are required to classify
   intermediate non-MDS groups?
6. Can the physical isodual implementation be expressed as a twisted diagonal
   subgroup, with the square-class obstruction stated through
   \(\mathrm{PGL}_2(q)/\mathrm{PSL}_2(q)\)?

## Safeguards

- Do not edit C979 or any manuscript/export surface while C979 is active in
  another agent.
- Distinguish standard product-code and invariance-algebra consequences from
  new quantum applications.
- Prove general statements symbolically; finite searches may discover examples
  but cannot serve as the sole evidence for a theorem.
- Use standard terminology.  In particular, do not conflate the conductor or
  relations among Veronese images with the quadratic hull of a code.
- Allocate no successor task without explicit user instruction.

## Deliverables

1. A proved general MDS conductor theorem, including equality and sharpness
   cases.
2. The coordinatewise CSS endomorphism algebra and its exact symplectic-unit
   interpretation.
3. The two MDS algebra types and a compressed derivation of the torus/full-
   \(\mathrm{SL}_2\) dichotomy.
4. A structural analysis of partial-support conductors, including the C981
   Borel example as an algebra with radical.
5. A bounded assessment of further theorem or successor potential, with exact
   literature boundaries.

## Acceptance gate

- Every displayed bound has a complete proof and its parameter range stated.
- Algebra closure, the determinant-one group identification, and both MDS
  algebra isomorphisms are checked explicitly.
- At least one unequal-dimension example tests sharpness, and at least one
  non-MDS example demonstrates why dimensions alone are insufficient.
- The write-up identifies the strongest present-paper compression without
  claiming standard conductor/product results as new.

## Executive conclusion

C982 found both a sharper compression and a broader theorem.

First, conductors between arbitrary MDS codes (E=[n,k]) and
(F=[n,\ell]) satisfy sharp dimension and support bounds.  The manuscript's
nullity-(0/1) lemma is merely the equal-dimension endpoint and follows in a
few lines from standard product Singleton theory.  Half rate is needed only
when specializing to (F=C^\perp).

Second, the four CSS block conditions form a coordinatewise endomorphism
algebra.  For the MDS--CSS family that algebra is
\(mathbf F_q\times\mathbf F_q) or (M_2(\mathbf F_q)); its determinant-one
units are exactly the split torus or (mathrm{SL}_2(q)).  This is the cleanest
mathematical explanation of the logical-group dichotomy.

Third, the same algebra solves the field-linear pure-CSS problem beyond MDS.
After standard indecomposable decomposition, every component is either a full
matrix algebra or a split diagonal algebra with square-zero off-diagonal
radical.  Hence every one-coordinate projection is, up to conjugacy, a torus,
a Borel subgroup, or all of (mathrm{SL}_2(q)).  Partial-support conductors are
the radical branch, not an uncontrolled collection of exceptions.

The strongest successor would combine this algebraic classification with the
prime-power trace-symplectic/Frobenius-semilinear completion and the logical
quotient of positive-rate CSS codes.  C982 makes no manuscript edits and does
not alter or close C979.

## General MDS conductor theorem

Write
\[
 \operatorname{Cond}(E,F)=\{s\in\mathbf F_q^n:s\star E\subseteq F\}.
\]

### Theorem

Let (E) be a nontrivial ([n,k]_q) MDS code and (F) a nontrivial
([n,\ell]_q) MDS code, with (1\leq k,\ell<n).  If (k>\ell), then
\(operatorname{Cond}(E,F)=0\).  If (k\leq\ell), then every nonzero
(s\in\operatorname{Cond}(E,F)) satisfies
\[
 \operatorname{wt}(s)\geq n-\ell+k,
\]
and
\[
 \dim\operatorname{Cond}(E,F)\leq\ell-k+1.
\]
If equality holds in the dimension bound, the conductor is an
\([n,\ell-k+1,n-\ell+k]_q\) MDS code.

In particular, for two MDS codes with the same parameters ([n,k]_q),
their conductor is either zero or a one-dimensional space generated by a
full-support vector.  In the nonzero case every generator (s) gives a
diagonal equivalence
\[
 s\star E=F.
\]

### Proof

Let (s\ne0) have support (S) of size (w).  Multiplication by (s)
on (E) has rank equal to the dimension of the puncturing (E|_S), since
the nonzero coordinates of (s) merely rescale that puncturing.  The MDS
rank function gives
\[
 \dim(s\star E)=\min\{k,w\}.
\]
The image is supported on (S) and lies in (F).  The subcode of an MDS
code (F) supported on (S) has dimension
\[
 \dim F[S]=\max\{0,\ell+w-n\}.
\]
Consequently
\[
 \min\{k,w\}\leq\max\{0,\ell+w-n\}.                 \tag{1}
\]
The right side must be positive.  If (w<k), (1) becomes
(w\leq\ell+w-n), contradicting (ell<n).  Hence (w\geq k), and
(1) gives
\[
 k\leq\ell+w-n,
 \qquad w\geq n-\ell+k.
\]
If (k>\ell), this lower bound exceeds (n), so the conductor is zero.
For (k\leq\ell), apply the ordinary Singleton bound to the conductor:
if its dimension is (r>0), then
\[
 r\leq n-d+1\leq\ell-k+1.
\]
When (r=\ell-k+1), both inequalities are equalities and the conductor is
MDS.  For (k=\ell), a nonzero conductor therefore has dimension one and
minimum distance (n).  Multiplication by its generator is invertible, and
the inclusion (s\star E\subseteq F) is equality by equal dimension.

### Product-code compression

The dimension part is also an immediate consequence of the standard identity
\[
 \operatorname{Cond}(E,F)=(E\star F^\perp)^\perp
\]
and the product Singleton bound
\[
 \dim(E\star F^\perp)
 \geq\min\{n,k+n-\ell-1\}.
\]
For (k=\ell), the product has dimension (n) or (n-1).  In the latter
case the standard equality result for products of MDS codes says that
(E\star F^\perp) is ([n,n-1,2]) MDS.  Its dual conductor is therefore
([n,1,n]) MDS.  This proves the entire equal-parameter conductor lemma from
standard product-code inputs.

The elementary support proof remains useful in the manuscript because it is
short and self-contained.  The product-code derivation is essential for
positioning: the conductor nullity lemma itself should not be advertised as a
new coding-theory theorem.

### Sharpness

The bounds are simultaneously sharp for ordinary generalized Reed--Solomon
codes on a common evaluation set.  If
\[
 E=\operatorname{GRS}_k(a,u),\qquad
 F=\operatorname{GRS}_\ell(a,v),\qquad k\leq\ell,
\]
then
\[
 \operatorname{Cond}(E,F)
 =\operatorname{GRS}_{\ell-k+1}(a,v/u).
\]

A concrete instance is over (mathbf F_7), with evaluation points
(0,1,2,3,4), (E=\operatorname{RS}_2), and
(F=\operatorname{RS}_3).  If (s\in\operatorname{Cond}(E,F)), applying
(s) to the constant word first shows that (s) is the evaluation of a
quadratic polynomial (h).  Applying it to the linear word (x) shows that
(xh) agrees at five points with a quadratic polynomial, forcing the
quadratic coefficient of (h) to vanish.  Hence
\[
 \operatorname{Cond}(E,F)=\operatorname{RS}_2,
\]
an ([5,2,4]_7) code attaining both bounds.

## The coordinatewise CSS endomorphism algebra

For any full-support code (C\leq\mathbf F_q^n), put
\[
 A=\operatorname{St}(C)=\operatorname{Cond}(C,C),\quad
 B=\operatorname{Cond}(C^\perp,C),\quad
 D=\operatorname{Cond}(C,C^\perp).
\]
The conductor identity gives
\[
 \operatorname{St}(C)
 =(C\star C^\perp)^\perp
 =\operatorname{St}(C^\perp),
\]
so the same algebra (A) occurs on both diagonal blocks.  Define
\[
 \mathscr A_C=
 \begin{pmatrix}A&B\\D&A\end{pmatrix}
 \subseteq M_2(\mathbf F_q^n),                         \tag{2}
\]
where multiplication is coordinatewise matrix multiplication.

### Proposition

(\mathscr A_C) is a unital (mathbf F_q)-algebra.  It is exactly the
algebra of site-dependent field-linear (2\)-by-(2) maps preserving the CSS
label space
\[
 L_C=C_X\oplus C_Z^\perp.
\]
Its coordinatewise symplectic unit group is
\[
 G_C^{\mathrm{lin}}
 =\mathscr A_C\cap\mathrm{SL}_2(q)^n.                 \tag{3}
\]

### Proof

The four conductor inclusions are precisely the four block conditions for
preserving (C\oplus C^\perp).  Closure under addition and scalar
multiplication is immediate.  For multiplication, (A) acts on (B) and
(D) from either side, while
\[
 B\star D\subseteq A,qquad D\star B\subseteq A.
\]
For example, (d\star C\subseteq C^\perp) and then
(b\star(d\star C)\subseteq C), so (b\star d\in A).  These are exactly
the conditions needed for block-matrix multiplication to remain in (2), and
the coordinatewise identity belongs to (2).  Finally,
(\mathrm{Sp}_2(q)=\mathrm{SL}_2(q)), so intersecting with the determinant-one
condition at every coordinate gives (3).

This is a generalized matrix algebra (equivalently, a Morita-context algebra),
but the first-pass paper should call it the **coordinatewise endomorphism
algebra** and credit the established stabilizer-code invariance-algebra
framework.

## The two MDS algebra types

Now let (C) be ([2m,m,m+1]_q) MDS.  Its stabilizer algebra is scalar:
\[
 A=\mathbf F_q\mathbf1.
\]
The general equal-parameter conductor theorem says that (B) and (D) are
zero or full-support lines.  A nonzero element of either is invertible and its
inverse belongs to the other.  Hence there are exactly two cases.

### Non-isometry-dual case

Here (B=D=0), and
\[
 \mathscr A_C\cong\mathbf F_q\times\mathbf F_q.
\]
Coordinatewise determinant is the product norm ((a,d)\mapsto ad).  Its
norm-one units are
\[
 \{(a,a^{-1}):a\in\mathbf F_q^\times\}\cong T.
\]

### Isometry-dual case

Choose (s\in(\mathbf F_q^\times)^{2m}) with
(s\star C=C^\perp).  Then
\[
 D=\mathbf F_qs,qquad B=\mathbf F_qs^{-1},
\]
and the map
\[
 \Phi_s:M_2(\mathbf F_q)\longrightarrow\mathscr A_C,qquad
 \begin{pmatrix}a&b\\c&d\end{pmatrix}
 \longmapsto
 \begin{pmatrix}
  a\mathbf1&b s^{-1}\\c s&d\mathbf1
 \end{pmatrix}                                      \tag{4}
\]
is an algebra isomorphism.  At every coordinate, the determinant of the image
is (ad-bc).  Thus the determinant-one units are exactly
\(mathrm{SL}_2(q)\).

The algebra type is canonical, although (4) depends on the projective choice
of (s).  Including logical Pauli translations recovers the two projective
logical groups
\[
 \mathbf F_q^2\rtimes T,qquad
 \mathbf F_q^2\rtimes\mathrm{SL}_2(q).
\]

This yields the strongest compressed explanation of the main theorem:

> The coordinatewise endomorphism algebra of the MDS--CSS label space is
> either the split diagonal algebra or the full matrix algebra.  Its
> determinant-one units give the torus or (mathrm{SL}_2(q)).

The statement is a CSS and site-dependent specialization of established
endomorphism-algebra methods.  The paper-local quantum contribution is the
identification of this algebra through the MDS conductor, the resulting exact
logical image, and the use of imported AME rigidity to rule out non-Clifford
product unitaries.

## Twisted diagonal realization and square classes

In the isometry-dual case put (R_i=\operatorname{diag}(1,s_i)).  Formula
(4) says that the physical linear group is the twisted diagonal subgroup
\[
 G_s=
 \left\{
  \left(R_iMR_i^{-1}\right)_{i=1}^{2m}:
  M\in\mathrm{SL}_2(q)
 \right\},                                          \tag{5}
\]
because
\[
 R_i\begin{pmatrix}a&b\\c&d\end{pmatrix}R_i^{-1}
 =\begin{pmatrix}a&b s_i^{-1}\\c s_i&d\end{pmatrix}.
\]

The matrices (R_i) are projective frames rather than necessarily symplectic
frames.  Their classes lie in (mathrm{PSL}_2(q)subset\mathrm{PGL}_2(q))
exactly when their determinants (s_i) are squares.  Rescaling the global
witness (s) does not change (G_s).  Therefore local symplectic frames can
untwist (5) to a uniform diagonal copy precisely when
\[
 s_i/s_j\in(\mathbf F_q^\times)^2
 \quad\text{for all }i,j.                            \tag{6}
\]
The obstruction is the relative class of the (s_i) in
\[
 \mathrm{PGL}_2(q)/\mathrm{PSL}_2(q)
 \cong\mathbf F_q^\times/(\mathbf F_q^\times)^2.
\]
This standard twisted-diagonal description subsumes the multiplier-ratio
calculation and states exactly why site dependence can remain after the
logical group has become the full (mathrm{SL}_2(q)).

## Exact extension beyond MDS for indecomposable codes

The endomorphism algebra gives more than an obstruction outside MDS.  It gives
an exact structural dichotomy for every code with trivial stabilizer, with no
MDS or half-dimension hypothesis.
Following standard coding terminology, call (C) **indecomposable** when
\[
 \operatorname{St}(C)=\mathbf F_q\mathbf1.
\]

### Theorem

Let (C\leq\mathbf F_q^n) have trivial stabilizer.
Set
\[
 B=\operatorname{Cond}(C^\perp,C),\qquad
 D=\operatorname{Cond}(C,C^\perp).
\]
Exactly one of the following occurs.

1. **Isometry-dual branch.**  The product (B\star D) is nonzero.  Necessarily
   (n=2\dim C); there is a full-support (s) with
   (s\star C=C^\perp); (B=\mathbf F_qs^{-1}),
   (D=\mathbf F_qs); and
   \(\mathscr A_C\cong M_2(\mathbf F_q)\).
2. **Radical branch.**  The product (B\star D) is zero.  Then
   \[
    B\star D=0,
   \]
   the off-diagonal subspace
   \[
    N=\begin{pmatrix}0&B\\D&0\end{pmatrix}
   \]
   is a square-zero ideal, and
   \[
    \mathscr A_C/N\cong\mathbf F_q\times\mathbf F_q.
   \]
   In fact (N=\operatorname{rad}(\mathscr A_C)).  The torus case is the
   subcase (B=D=0).

In the radical branch,
\[
 G_C^{\mathrm{lin}}
 =\left\{
  \begin{pmatrix}a\mathbf1&b\\d&a^{-1}\mathbf1\end{pmatrix}:
  a\in\mathbf F_q^\times, b\in B, d\in D
 \right\}
 \cong(B\oplus D,+)\rtimes\mathbf F_q^\times,        \tag{7}
\]
where the torus acts with weights (+2) on (B) and (-2) on (D).

### Proof

For (b\in B) and (d\in D), closure of the algebra gives
(b\star d\in\operatorname{St}(C)=\mathbf F_q\mathbf1).  If this product
is nonzero, both (b) and (d) have full support.  Multiplication by (d)
injects (C) into (C^\perp), while multiplication by (b) injects
(C^\perp) into (C).  Hence their dimensions are equal, so
(n=2\dim C), and both inclusions are equalities.  The argument
(b'\star d\in\mathbf F_q\mathbf1) shows that every (b'\in B) is a
scalar multiple of (b); similarly (D) is a line.  This is the first
branch.

Otherwise every product (b\star d) is zero.  Hence (N^2=0), while the
quotient by (N) is the semisimple algebra (mathbf F_q\times\mathbf F_q).
It follows that (N) is exactly the Jacobson radical.  Since the
off-diagonal product vanishes coordinatewise, the determinant condition for
an element of (2) is simply (a\delta=1), which gives (7).  Conjugation by
\(\operatorname{diag}(a,a^{-1})) multiplies (B) by (a^2) and (D) by
(a^{-2}), proving the stated semidirect action.

The supports visible to (B) and (D) are disjoint in the radical branch.
At any coordinate, projection of (7) is therefore one of:

- the split torus, if both conductor spaces vanish there;
- an upper Borel subgroup, if (B) evaluates nontrivially there;
- a lower Borel subgroup, if (D) evaluates nontrivially there.

Together with the isometry-dual branch, the only one-coordinate linear images
for an indecomposable CSS label space are, up to conjugacy,
\[
 T,\qquad B_2(q),\qquad\mathrm{SL}_2(q).              \tag{8}
\]
This is an exact local-Clifford label-space theorem.  Without an appropriate
rigidity theorem it is not an exact classification of arbitrary product
unitaries for non-MDS stabilizer states.

For a half-dimensional code, a full-support vector in either (B) or (D)
already forces the first branch, because its inverse lies in the opposite
conductor.  Away from half dimension a full-support one-sided conductor may
occur, but it remains in the radical branch unless an opposite conductor pairs
with it nontrivially.

## Why conductor dimensions are insufficient

The C981 example over (mathbf F_3),
\[
 C_0=\operatorname{rowspan}
 \begin{pmatrix}1&0&0&1\\0&1&1&1\end{pmatrix},
\]
has
\[
 A=\mathbf F_3\mathbf1,quad
 B=\mathbf F_3(1,0,0,2),quad
 D=\mathbf F_3(0,1,2,0).
\]
Thus all three conductor components have dimension one, but (B\star D=0).
The resulting four-dimensional algebra has a two-dimensional square-zero
radical and its one-coordinate image can be Borel.

By contrast,
\[
 C_1=\operatorname{rowspan}
 \begin{pmatrix}1&0&1&1\\0&1&1&2\end{pmatrix}
 \leq\mathbf F_3^4
\]
is self-dual: its displayed rows are mutually orthogonal and have zero norm.
Every nonzero word has weight three, so it is ([4,2,3]_3) MDS.  Again
\[
 \dim A=\dim B=\dim D=1,
\]
but now (A=B=D=\mathbf F_3\mathbf1), the cross-products are nonzero, and
\(\mathscr A_{C_1}\cong M_2(\mathbf F_3)\).

The component dimensions are identical in the two examples while the algebras
and logical images differ.  A broader classification must retain the
conductor pairings
\[
 B\star D\longrightarrow A,qquad D\star B\longrightarrow A,
\]
or equivalently the full coordinatewise endomorphism algebra, not only a list
of nullities.

## Decomposition and a universal one-site trichotomy

The indecomposable theorem extends componentwise to every full-support code.
The standard stabilizer-algebra decomposition supplies disjoint coordinate
projectors
\[
 e_1+\cdots+e_h=\mathbf1,qquad
 A=\operatorname{St}(C)=\bigoplus_{j=1}^h\mathbf F_qe_j,
\]
and indecomposable component codes
\[
 C=\bigoplus_{j=1}^h C_j,qquad C_j=e_jC.
\]
Orthogonality respects the same coordinate partition:
\[
 C^\perp=\bigoplus_{j=1}^h C_j^{\perp_{I_j}},qquad
 I_j=\operatorname{supp}(e_j).
\]
Because (A) acts on both cross-conductors, they split under the same
projectors.  Therefore
\[
 \mathscr A_C\cong\prod_{j=1}^h\mathscr A_{C_j}.       \tag{9}
\]
Each factor is one of the two indecomposable types above: (M_2(\mathbf F_q)),
or a split diagonal algebra extended by a square-zero off-diagonal radical.

It follows that for the pure CSS stabilizer label space
(L_C=C_X\oplus C_Z^\perp), the projection of the full site-dependent,
field-linear local symplectic stabilizer to any one coordinate is, up to
conjugacy, exactly one of
\[
 T,\qquad B_2(q),\qquad\mathrm{SL}_2(q).              \tag{10}
\]
Indeed, the coordinate belongs to one indecomposable component.  In a matrix
factor its projection is all of (mathrm{SL}_2(q)).  In a radical factor the
two off-diagonal conductor supports are disjoint, so the projection is the
torus or one of the two conjugate Borel subgroups.  A nonzero coordinate
evaluation on a conductor space is surjective onto (mathbf F_q), giving the
full root subgroup rather than a proper additive subgroup.

Equation (10) is the strongest cheap extension found in C982.  Its scope must
remain explicit:

- it concerns pure CSS stabilizer states of the form (C\oplus C^\perp), not
  arbitrary positive-rate CSS stabilizer codes described by two nested codes;
- it classifies field-linear local Clifford label symmetries;
- over prime powers it does not include Frobenius-semilinear Clifford sectors;
- without an independent local-unitary rigidity theorem it does not classify
  arbitrary product-unitary stabilizers.

Within those boundaries, the result is all-length and requires no MDS
hypothesis.  MDS codes occupy the semisimple part of the classification and
exclude the Borel branch by forcing every nonzero cross-conductor to have full
support.

## Positive-rate CSS reach

The algebraic framework itself does not require a stabilizer state.  Let a CSS
stabilizer code have (X)- and (Z)-label codes (X,Z\leq\mathbf F_q^n)
with (X\perp Z).  Define
\[
 \mathscr A_{X,Z}=
 \begin{pmatrix}
  \operatorname{St}(X)&\operatorname{Cond}(Z,X)\\
  \operatorname{Cond}(X,Z)&\operatorname{St}(Z)
 \end{pmatrix}.                                     \tag{11}
\]
The same composition argument proves that (11) is a generalized matrix
algebra, exactly equal to the coordinatewise field-linear endomorphisms of the
CSS stabilizer label space (X_X\oplus Z_Z).  Therefore
\[
 \mathscr A_{X,Z}\cap\mathrm{SL}_2(q)^n             \tag{12}
\]
is its site-dependent field-linear local Clifford stabilizer on Pauli labels,
and it acts on the logical symplectic quotient (L^\perp/L).  Stabilizer-phase
changes can be corrected by Paulis in the usual way.

Equation (11) is the portable classification framework for general CSS codes.
The pure-state specialization (X=C, Z=C^\perp) is unusually rigid because
the two diagonal stabilizer algebras coincide.  For positive-rate CSS codes
they need not coincide, and the logical image of (12) can be substantially
richer.  If (X) and (Z) are MDS, the general conductor theorem above
immediately bounds the dimensions and support sizes of both off-diagonal
bimodules.

This observation is a framework, not yet a successor theorem: obtaining an
exact logical-group list requires classifying the two stabilizer algebras, the
two conductor bimodules, their pairings, and the induced action on
(L^\perp/L).

## Geometric compression and a terminology boundary

For a generator matrix with projective columns (v_i\in\mathbf P^{m-1}),
the map
\[
 \operatorname{Sym}^2(\mathbf F_q^m)\longrightarrow\mathbf F_q^n,
 \qquad Q\longmapsto(Q(v_1),\ldots,Q(v_n))
\]
has image (C^{\star2}).  Consequently
\((C^{\star2})^\perp) is the space of linear relations among the rank-one
symmetric tensors (v_iv_i^{\mathsf T}), or equivalently among the quadratic
Veronese images of the columns.  At half-rate MDS, product Singleton says that
these (2m) images are independent or form one full-support circuit.

This is not the **quadratic hull** of the code.  The quadratic hull is the
scheme cut out by the kernel of the quadratic evaluation map, whereas the
conductor is dual to its cokernel.  The neighboring geometric language is
useful, but substituting “quadratic hull” for “conductor” would be incorrect.

## Literature and novelty boundary

The relevant standard inputs are now cleanly separated.

- Couvreur--Márquez-Corbella--Pellikaan use the code conductor and the identity
  \(\operatorname{Cond}(E,F)=(E\star F^\perp)^\perp\).  That terminology and
  identity are imported.
- Mirandola--Zémor prove the product Singleton bound used above, the equality
  result for products of MDS codes, and the stabilizer-algebra decomposition of
  a code into indecomposable coordinate components.  The general MDS conductor
  bounds in this report are short consequences or elementary reformulations of
  those standard inputs, not a priority claim.
- Rains introduced the stabilizer-code endomorphism-algebra viewpoint.
  Dasu--Burton develop it into a classification of uniform diagonal
  transversal Clifford gates on multiple qubit code blocks.  Equations
  (2) and (11) are the site-dependent CSS block specialization; the different
  alphabet, transversality convention, and classification target must remain
  explicit.
- Randriambololona's quadratic hull is adjacent geometric language but a
  different object, as explained above.
- The stabilizer-state local-Clifford-equivalence literature classifies or
  tests equivalence orbits.  It does not, in the sources checked, state the
  coordinate projection trichotomy (10) in conductor-algebra form.

Primary checkpoints:

- Couvreur--Márquez-Corbella--Pellikaan,
  [*Cryptanalysis of McEliece Cryptosystems Based on Algebraic Geometry
  Codes*](https://doi.org/10.1109/TIT.2017.2712636);
- Mirandola--Zémor,
  [*Critical Pairs for the Product Singleton
  Bound*](https://arxiv.org/abs/1501.06419);
- Rains, [*Nonbinary Quantum Codes*](https://doi.org/10.1109/18.782103);
- Dasu--Burton,
  [*A Classification of Transversal Clifford Gates for Qubit Stabilizer
  Codes*](https://arxiv.org/abs/2507.10519);
- Randriambololona,
  [*The Quadratic Hull of a Code and the Geometric View on Multiplication
  Algorithms*](https://arxiv.org/abs/1912.06627).

Targeted searches through 2026-08-27 for CSS local symmetry groups combined
with Borel subgroups, Jacobson radicals, site-dependent Clifford symmetries,
and conductor/Morita-context terminology found no direct predecessor for
(10).  This is a bounded search result, not evidence for an unqualified
firstness claim.  The theorem is elementary enough that it may be implicit in
the broader endomorphism-algebra literature.

## Publication dispositions

| Result or framing | Disposition | Reason |
|---|---|---|
| Use “code conductor” and state the Schur-product identity | present paper | standardizes the central test at negligible cost |
| State the equal-parameter MDS conductor lemma for general ([n,k]), while specializing immediately to (C,C^\perp) | present paper or proof remark | removes an artificial half-rate hypothesis from the classical lemma |
| Cite product Singleton as an alternative four-line proof | present paper | protects the novelty boundary and compresses the coding input |
| Display the two algebra types (mathbf F_q\times\mathbf F_q) and (M_2(\mathbf F_q)) | present paper, after the elementary proof | gives the cleanest reason for the two groups without making the introduction more abstract |
| Call the full-group physical realization a twisted diagonal subgroup and identify the (mathrm{PGL}_2/\mathrm{PSL}_2) obstruction | lift-refinement subsection | replaces bespoke multiplier-ratio prose with standard group language |
| Add the universal torus/Borel/(mathrm{SL}_2) projection theorem | outlook or successor, not C979 by default | mathematically clean but expands beyond MDS and beyond exact arbitrary-product-unitary scope |
| Develop (11) for positive-rate CSS codes and compute its logical quotient action | successor candidate | substantial new classification work remains |
| Combine the algebra theorem with the prime-power semilinear completion | strongest successor package | supplies enough depth and quantum scope for an independent paper |

## Strongest successor package, not allocated

**Coordinatewise Clifford groups of CSS codes over prime powers.**  Begin with
the generalized matrix algebra (11).  Classify its trace-symplectic and
Frobenius-semilinear unit sectors over (q=p^e), determine their induced action
on the logical quotient of positive-rate CSS codes, and recover the pure-state
torus/Borel/full-(mathrm{SL}_2) theorem as the field-linear rank-one case.
Test the semisimple branch on isometry-dual MDS and elliptic codes and the
radical branch on partial-support conductor examples.  The acceptance gate
should be a conceptual all-length classification under explicit algebraic
hypotheses, not a finite census.

## Mystery ledger

### Settled

- The half-rate restriction belongs to the dual application, not the general
  equal-parameter MDS conductor lemma.
- The MDS logical-group dichotomy is the norm-one-unit dichotomy between the
  split diagonal and full matrix algebras.
- Under trivial stabilizer, partial-support cross-conductors form a square-zero
  radical unless they pair to an invertible diagonal equivalence.
- Component decomposition yields only torus, Borel, or full
  \(\mathrm{SL}_2\) one-coordinate field-linear images for pure CSS stabilizer
  states.
- Conductor dimensions alone cannot classify the group; the conductor
  pairings distinguish the C981 radical example from a self-dual MDS example
  with identical component dimensions.

### Open

- Whether the projection trichotomy (10) has appeared explicitly in another
  notation remains a priority question; the bounded search found no direct
  statement, but no firstness claim is warranted.
- The full prime-power trace-symplectic group remains unclassified.
- The positive-rate logical quotient of (11) can have richer images; no finite
  list is asserted here.
- Exactness among arbitrary product unitaries outside the imported AME-rigid
  regime requires new rigidity input.

## Skeptical-referee pass

1. **“The MDS conductor theorem is standard.”**  Substantively yes: its
   dimension statement follows immediately from product Singleton, and the
   support statement follows from the MDS equality case or shortening.  Use it
   as a transparent imported coding lemma, not a novelty claim.
2. **“The endomorphism algebra is Rains in CSS coordinates.”**  Yes.  The
   reusable block algebra should be credited as a specialization.  The value
   here is the conductor identification, the two MDS algebra types, and their
   exact site-dependent quantum image.
3. **“Borel at one coordinate is not the global group.”**  Correct.  Equation
   (7) is the global group.  Equation (8) is its coordinate projection, relevant
   to a one-party encoder only when that party has a maximally mixed marginal.
4. **“The non-MDS theorem proves only Clifford exactness.”**  Correct.  It
   exactly classifies the field-linear local Clifford label stabilizer and its
   lifts after Pauli phase correction.  It makes no arbitrary-product-unitary
   claim without rigidity.
5. **“Prime powers have more Clifford sectors.”**  Correct.  All conductor and
   algebra statements hold over (mathbf F_q), but equations (3), (10), and
   (12) describe the field-linear subgroup when (q) is not prime.
6. **“The universal trichotomy seems too easy to be new.”**  It is elementary
   once the coordinatewise endomorphism algebra is written down.  Treat the
   bounded literature gap as motivation for a deeper semilinear/positive-rate
   successor, not as grounds for a standalone priority claim.
7. **“Why not replace the whole proof by algebra?”**  For the intended
   quantum-information reader, retain the elementary non-isodual/isodual proof
   first.  Use the algebra display afterward to compress and explain the
   result, not to make the entry point more abstract.

The results survive this pass.  The main correction to C981 is that the cheap
extension is stronger than a conditional full-support theorem: after
indecomposable decomposition, the entire field-linear pure-CSS problem has the
semisimple/radical structure above.

No incidental discovery-track entry is needed: the unequal-dimension theorem,
endomorphism-algebra compression, radical classification, and positive-rate
framework all answer explicit C982 questions.
