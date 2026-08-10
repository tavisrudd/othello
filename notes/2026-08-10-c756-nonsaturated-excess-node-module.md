# C756 nonsaturated excess-node module

**Lane:** `clebsch` · **Date:** 2026-08-10 · **Scope:** purely structural
nonsaturated reduction; no census and no manuscript edit

## Verdict

The nonsaturated Moore quotient has a canonical finite-module carrier that
retains both direction and intercept while having dimension exactly the
defect \(\delta\).

Fix an arc point and a spare external line as in the direction-cover
reduction.  Let \(n=k-1\), and let \(\mathcal N\) be the set of the
\(\binom n2=q+\delta\) affine chord nodes
\[
 (t_{ij},u_{ij})=
 \left(\frac{y_i-y_j}{x_i-x_j},\ y_i-t_{ij}x_i\right),
 \qquad i<j.                                              \tag{1}
\]
The slope map \(\pi:\mathcal N\to\mathbb F_q\) is surjective.  Its fibre
over \(t\) has size \(\mu_t\), the number of chords of that direction.
Define the split coordinate algebras
\[
 B=\operatorname{Map}(\mathbb F_q,\mathbb F_q),qquad
 A=\operatorname{Map}(\mathcal N,\mathbb F_q),            \tag{2}
\]
and the canonical excess module
\[
 \boxed{M=A/\pi^*B.}                                      \tag{3}
\]
Then
\[
 \boxed{\dim_{\mathbb F_q}M
        =\sum_t(\mu_t-1)=\delta,}                         \tag{4}
\]
and multiplication by the slope coordinate induces an operator \(T_M\) on
\(M\) whose characteristic polynomial is precisely the residual direction
polynomial:
\[
 \boxed{E_P(Z)\doteq\det(ZI-T_M).}                        \tag{5}
\]

Thus \(E_P\) is not merely the quotient left after removing \(T^q-T\).  It
is the spectral polynomial of the canonical excess node module.  The
classes of the intercept powers \([U^a]\in M\) record
the relative intercepts inside repeated-direction fibres and vanish
automatically on every unique direction.  This gives the masked Redei
problem a uniform, coordinate-honest form on the Frobenius-fixed base.

The remaining theorem is not module existence: abstract modules (3) exist
for every surjective finite cover.  It is to show that no \(\delta\)-module
with the special star realization, conic square class, and all-center
covering identities can occur.  This is the correct nonsaturated structural
gate after the fixed-size census stops.

## 1. The reduced node cover

Put
\[
 F(U,T)=\prod_{i=1}^n(U+Tx_i-y_i).                        \tag{6}
\]
Two factors meet at (1).  Because the primal points form an arc, no three
factors meet and two different pairs cannot define the same affine node.
Hence \(\mathcal N\) consists of \(\binom n2\) distinct rational ordinary
nodes of the line arrangement \(F=0\).  Intrinsically it is the reduced
singular scheme
\[
 \mathcal N=V(F,F_U,F_T)_{\mathrm{red}}.                  \tag{7}
\]

Every finite direction occurs by the spare-line covering lemma.  Chords of
one direction form a matching, so their intercepts are distinct; therefore
\[
 \pi^{-1}(t)=\{(t,u):F(U,t)\text{ has a double root at }u\}
\]
has exactly \(\mu_t\) points.  The familiar direction discriminant is
\[
 \operatorname{Disc}_U F(U,T)
 \doteq\prod_{i<j}\bigl((x_i-x_j)T-(y_i-y_j)\bigr)^2
 =(T^q-T)^2E_P(T)^2.                                     \tag{8}
\]
Equation (8) sees the branch directions but forgets the distinct intercepts
in a repeated fibre.  The algebra \(A\) retains them.

## 2. Quotient by the forced Moore base

The pullback \(\pi^*:B\hookrightarrow A\) identifies a function of slope
with the function that is constant on each node fibre.  Since both algebras
are products of copies of \(\mathbb F_q\), there is a canonical fibrewise
decomposition of the quotient as a vector space:
\[
 M=\bigoplus_{t\in\mathbb F_q}
   \mathbb F_q^{\mu_t}/\langle(1,\ldots,1)\rangle.         \tag{9}
\]
This proves (4).  It is the exact algebraic meaning of removing one forced
node from every rational direction without choosing which node to remove.

The algebra \(B\) acts on \(A\) by pullback and preserves \(\pi^*B\), so
\(M\) is canonically a \(B\)-module.  On the summand at \(t\), the slope
coordinate acts as the scalar \(t\) with multiplicity \(\mu_t-1\).  Hence
\[
 \det(ZI-T_M)
 =\prod_{t\in\mathbb F_q}(Z-t)^{\mu_t-1},                 \tag{10}
\]
which is (5) by the direction-factorization theorem.

Under a projective change of coordinate on the direction line, (5)
homogenizes in the expected way.  Therefore the construction is not tied to
one affine slope chart; intrinsically, \(M\) is a length-\(\delta\) module
on the Frobenius-fixed direction base, and (5) is its binary characteristic
form.

## 3. The intercept flag

Let \(U\in A\) denote the intercept function.  Although multiplication by
\(U\) does not descend to an endomorphism of \(M\) (the subspace
\(\pi^*B\) is not \(U\)-stable), the classes
\[
 [U],[U^2],\ldots\in M                                  \tag{11}
\]
are canonical.  In a fibre of size one every class vanishes.  In a fibre
of size \(\mu\ge2\), the intercepts \(u_1,\ldots,u_\mu\) are distinct, and
the Vandermonde matrix shows that
\[
 [U],[U^2],\ldots,[U^{\mu-1}]
 \quad\text{span}\quad
 \mathbb F_q^\mu/\langle\mathbf1\rangle.                  \tag{12}
\]
Thus the increasing spans of (11) form a canonical intercept flag on the
excess module.  It retains exactly the information lost by the scalar
direction discriminant (8).

This also explains the earlier first-subresultant failure.  Before passing
to (3), the subresultant lives over all \(q\) rational directions and has
degree \(\Theta(q)\).  In \(M\), every unique-direction fibre is zero and
only the \(\delta\) excess dimensions remain.  The compression is a quotient
of the finite Frobenius-fixed node algebra, not a nonexistent subtraction of
a global Moore Cartier divisor on the whole geometric pencil.

## 4. Canonical covariance form on the quotient

Let
\[
 \operatorname{Tr}_{A/B}:A\longrightarrow B,\qquad
 \mu=\operatorname{Tr}_{A/B}(1),                          \tag{13}
\]
where the trace is fibrewise summation, so \(\mu(t)=\mu_t\).  The formula
\[
 \boxed{\mathcal C([f],[g])
 =\mu\,\operatorname{Tr}(fg)
  -\operatorname{Tr}(f)\operatorname{Tr}(g)}              \tag{14}
\]
defines a \(B\)-valued symmetric bilinear form on
\(M=A/\pi^*B\).  It is
unchanged if \(f\) or \(g\) is altered by a fibrewise constant function, and
therefore requires neither division by \(\mu_t\) nor a choice of fibrewise
mean.

On a fibre with values \(f_a,g_a\), the form is
\[
 \mathcal C_t([f],[g])
 =\sum_{a<b}(f_a-f_b)(g_a-g_b).                           \tag{15}
\]
In particular, the first intercept invariant is
\[
 \mathcal C_t([U],[U])
 =\sum_{a<b}(u_a-u_b)^2.                                  \tag{16}
\]
It vanishes on every unique direction and is carried entirely by the
repeated-direction support; for fibres of size at least three it may be
isotropic.

The whole intercept flag has an exact discriminant.  For a fibre of size
\(\mu\ge2\), put
\[
 G_\mu=\bigl(\mathcal C_t([U^a],[U^b])\bigr)_
               {1\le a,b\le\mu-1}.
\]
The power-evaluation map to
\(\mathbb F_q^\mu/\langle\mathbf1\rangle\) has determinant equal to the
Vandermonde in the distinct intercepts.  In difference coordinates, the
matrix of \(\mathcal C_t\) is \(\mu I-J\), of determinant
\(\mu^{\mu-2}\).  Hence
\[
 \boxed{\det G_\mu
 =\mu^{\mu-2}\prod_{a<b}(u_a-u_b)^2.}                     \tag{17}
\]
If \(p\nmid\mu\), the covariance form is nondegenerate and its square class
is the fixed class of \(\mu^{\mu-2}\), independent of the intercepts.  If
\(p\mid\mu\), its degeneration is an explicit characteristic seam rather
than a failure of canonicity.

Equation (17) is the first uniform scalar that can be compared with the
constant conic square class.  At defect two, a double direction
(\(\mu=2\)) contributes a square, while a triple direction (\(\mu=3\))
contributes the square class of \(3\); this recovers the two local residual
shapes without choosing their intercepts.

## 5. Conic type as a square-class element

In the dual-star model every node of \(\mathcal N\) has the prescribed
internal conic type.  If \(Q(T,U)\) is an affine equation for the dual conic,
then
\[
 q_{\mathcal N}=Q(T,U)\in A^\times                         \tag{18}
\]
has constant quadratic-character class in every factor of the split algebra
\(A\).  Equivalently, for the fixed sign \(\epsilon\),
\[
 q_{\mathcal N}\in\epsilon\,(A^\times)^2.                \tag{19}
\]
This is the coordinate-free home of the node-character condition.  It
should be combined with the intercept flag (11), not projected immediately
to the direction polynomial (5).

There is a canonical weighted version of the covariance form that performs
this combination.  On a fibre put
\[
 q_i=Q(t,u_i),\qquad \sigma_t=\sum_i q_i,
\]
and define
\[
 \mathcal C_{Q,t}([f],[g])
 =\sigma_t\sum_iq_if_ig_i
  -\left(\sum_iq_if_i\right)\left(\sum_iq_ig_i\right).
                                                               \tag{20}
\]
Adding a constant to either \(f\) or \(g\) leaves (20) unchanged, so it
descends to the same quotient module without choosing a splitting.

In difference coordinates, the determinant of the weighted form is
\[
 \det(\mathcal C_{Q,t})
 =\sigma_t^{\mu-2}\prod_iq_i.                              \tag{21}
\]
Transporting it through the intercept-power evaluation map gives
\[
 \boxed{
 \det\bigl(\mathcal C_{Q,t}([U^a],[U^b])\bigr)_
                 {1\le a,b\le\mu-1}
 =\sigma_t^{\mu-2}
  \left(\prod_iq_i\right)
  \prod_{i<j}(u_i-u_j)^2.}                                \tag{22}
\]
The proof is the matrix determinant lemma applied to
\(\sigma_t\operatorname{diag}(q_1,\ldots,q_{\mu-1})-vv^{\mathsf T}\),
\(v=(q_1,\ldots,q_{\mu-1})\), followed by the Vandermonde determinant.

Extend the quadratic character by \(\chi(0)=0\).  By (19),
\(\prod_iq_i\) has square class \(\epsilon^\mu\).  Therefore (22)
reduces the entire conic contribution to one fibre trace:
\[
 \chi(\det\mathcal C_{Q,t})
 =\chi(\sigma_t)^{\mu-2}\epsilon^\mu,                     \tag{23}
\]
including the degenerate case.  Since \(Q(t,U)\) is quadratic in
\(U\),
\[
 \sigma_t
 =a(t)\operatorname{Tr}(U^2)
  +b(t)\operatorname{Tr}(U)+\mu_t c(t),                  \tag{24}
\]
so this trace is already contained in the first two levels of the intercept
flag.

Equations (17) and (22) are the promised bridge between the residual
direction polynomial and conic type.  They do not yet give a sign
contradiction: one must use star realization or a new value-level
cross-center identity to control \(\chi(\sigma_t)\).  They reduce that task
to one explicit scalar per repeated direction.

There is also a canonical global version.  Regard
\[
 \sigma=\operatorname{Tr}_{A/B}(q_{\mathcal N})\in B      \tag{25}
\]
as the function \(t\mapsto\sigma_t\), and let \(\Sigma(T)\) be its unique
representative of degree less than \(q\) modulo \(T^q-T\).  Its norm is
\[
 \operatorname{N}_{B/\mathbb F_q}(\sigma)
 =\prod_{t\in\mathbb F_q}\sigma_t
 =\operatorname{Res}_T(T^q-T,\Sigma(T)).                 \tag{26}
\]
On a unique-direction fibre, \(\sigma_t=q_i\), so its character is the
fixed sign \(\epsilon\).  Consequently (26) separates the known unique
fibres from the unknown repeated-fibre trace characters.  It is the right
shape for an aggregate constraint, although the existing Euler-character
all-center norm is too coarse, as (33) below makes explicit.

More precisely, compose the \(B\)-valued forms with fibrewise summation
\(B\to\mathbb F_q\).  Their matrices are block diagonal over the slope
fibres.  If \(R_0=\{t:\mu_t\ge2\}\) and \(r=|R_0|\), then
\[
 \sum_{t\in R_0}(\mu_t-1)=\delta,
 \qquad
 \sum_{t\in R_0}\mu_t=\delta+r,                          \tag{27}
\]
and (22) gives the basis-independent discriminant character
\[
 \boxed{
 \chi(\operatorname{disc}\mathcal C_Q|_M)
 =\epsilon^{\delta+r}
  \prod_{t\in R_0}\chi(\sigma_t)^{\mu_t-2}.}             \tag{28}
\]
The Vandermonde factors disappear because they are squares.  In particular,
double fibres carry no unknown trace character at all; only fibres of
multiplicity at least three contribute to the product in (28).  The
character in (28) is independent of scaling the conic equation: scaling
\(Q\) by \(\lambda\) scales a block of dimension \(\mu-1\) by
\(\lambda^2\), changing its determinant by a square.  The
unweighted comparison is
\[
 \chi(\operatorname{disc}\mathcal C|_M)
 =\prod_{t\in R_0}\chi(\mu_t)^{\mu_t-2}.                 \tag{29}
\]
Thus the nonsaturated conic problem has been reduced further: it is enough
to control a single global discriminant character, or equivalently the
weighted product of trace characters in (28), rather than every node value.

The trace itself is accessible from the repeated-root polynomial.  If
\[
 G_t(U)=\prod_{i=1}^{\mu_t}(U-u_i)
       =U^{\mu_t}+g_1(t)U^{\mu_t-1}+g_2(t)U^{\mu_t-2}+\cdots
\]
and \(Q(t,U)=a(t)U^2+b(t)U+c(t)\), Newton's first two identities give
\[
 \sigma_t
 =a(t)\bigl(g_1(t)^2-2g_2(t)\bigr)
  -b(t)g_1(t)+\mu_tc(t).                                 \tag{30}
\]
Here \(G_t\) is the squarefree common-root factor of
\(F(U,t)\) and \(F_U(U,t)\).  Formula (30) identifies the exact first-two
subresultant data that the star realization must control; it introduces no
new enumeration.

The star realization gives a second exact formula for the same trace.  Write
the normalized line factors of \(F\) as coefficient vectors \(v_i\), let
\(A\) be a symmetric matrix for the primal conic form \(Q_{\rm pr}\), and
use \(A^\#=\operatorname{adj}(A)\) for the dual conic form
\(Q_{\rm du}\).  The node belonging to the pair \(\{i,j\}\) is represented
projectively by \(v_i\times v_j\).  The
three-dimensional Lagrange identity says
\[
 (v_i\times v_j)^{\mathsf T}A^\#(v_i\times v_j)
 =Q_{\rm pr}(v_i)Q_{\rm pr}(v_j)-B(v_i,v_j)^2,            \tag{31}
\]
where \(Q_{\rm pr}(v)=v^{\mathsf T}Av\) and
\(B(v,w)=v^{\mathsf T}Aw\).  If \(\mathcal M_t\) is the matching of endpoint
pairs whose chords have direction \(t\), let \(\omega_{ij}\ne0\) be the
last coordinate of \(v_i\times v_j\), so division by \(\omega_{ij}\) gives
the affine representative \((t,u,1)\).  Then
\[
 \boxed{\sigma_t
 =\sum_{\{i,j\}\in\mathcal M_t}
   \frac{Q_{\rm pr}(v_i)Q_{\rm pr}(v_j)-B(v_i,v_j)^2}
        {\omega_{ij}^2}.}                                \tag{32}
\]
In the coordinates of (6), \(\omega_{ij}=x_j-x_i\), up to the fixed sign
convention.  Thus the missing scalar is a square-normalized matching sum in
the conic Gram matrix.  Formula (32), rather than the abstract module alone,
is the concrete star input for the next obstruction.

This also separates the present trace from the earlier all-center
Euler-character norm.  If the weights \(q_i\) in (20) are replaced by their
Euler signs \(q_i^{(q-1)/2}=\epsilon\), then
\[
 \mathcal C_{\chi(Q),t}=\epsilon^2\mathcal C_t=\mathcal C_t.
                                                               \tag{33}
\]
The character projection therefore erases precisely the value-level trace
\(\sigma_t\).  The existing all-center norm polynomial is compatible with
(28), but does not evaluate it.  A successful cross-center law must retain
the actual quadratic values in (31)--(32), not only their signs.

The exact next lemma can now be stated without a fixed defect:

> **Excess-module obstruction.**  No reduced star-node cover arising from a
> dual arc can have surjective slope map, constant conic square class (19),
> and the all-center covering identities in the nonsaturated regime.

A more modest first target is to control the global character (28), using
either the norm (26), the first-two repeated-root coefficients (30), or the
matching sum (32), through the star realization.  At \(\delta=2\) this
specializes to the old split quadratic residual, but (3)--(33) make the
statement uniform in \(\delta\).

## 6. Relation to the saturated complementary-factor reduction

The two current structural carriers have the same architecture:

| branch | forced rational base | excess carrier | target |
|---|---|---|---|
| saturated-internal | roots of \(X^q-X=RS\) | complementary factor \(S\) and Laurent ghosts of \(S^3/(X^q-X)\) | force \(S^2\bmod R\) to have degree at most two |
| nonsaturated | one node above every root of \(T^q-T\) | \(M=A/\pi^*B\), dimension \(\delta\) | obstruct the conic square class on the intercept flag |

In both cases the correct operation is quotienting on the Frobenius-fixed
finite base.  Neither branch is helped by extending the fixed-field census.

## EJ + TT closeout

**EJ.**  The residual polynomial \(E_P\) has acquired an intrinsic spectral
meaning: it is the characteristic polynomial of slope on the excess node
module.  This makes defect localization functorial and preserves intercepts
through the flag (11).

**TT.**  Do not treat \(M\) as an algebra or multiplication by \(U\) as an
endomorphism of the quotient; neither is canonical.  The canonical data are
the \(B\)-module, the slope operator, the distinguished intercept-power
classes, the covariance forms (14) and (20), and the square-class element in
the ambient split algebra \(A\).  An abstract \(\delta\)-module alone cannot
prove nonexistence.

## Mystery ledger

| feature | status | exact remaining boundary |
|---|---|---|
| Can the forced \(q\) directions be removed without choosing one node per fibre? | settled | quotient module (3) |
| What is \(E_P\) intrinsically? | settled | characteristic polynomial (5) |
| Are intercepts retained after compression? | settled | canonical flag (11)--(12) |
| Is there a canonical quadratic invariant without choosing means? | settled | covariance form (14) and determinant (17) |
| Where does the conic character live? | settled | square class (19) in the split node algebra |
| Can the conic class be coupled to the intercept flag canonically? | settled | weighted determinant (22), reduced globally to (28) |
| Which arrangement data determine the remaining trace? | settled | first two repeated-root coefficients (30), equivalently the Gram matching sum (32) |
| Does the prior Euler-character norm determine this trace? | no | character projection gives the tautology (33) and loses the conic values |
| Does the abstract module force a contradiction? | no | must use star realization and covering identities |
| What is the uniform nonsaturated theorem target? | open | excess-module obstruction above |

## Next action

Derive a cross-direction identity for the Gram matching sums (32),
equivalently the first two coefficients of \(G_t\), and compare its global
character with (28).  Preserve actual conic values: the Euler-character
projection (33) is too coarse.  Do not resolve this by a fixed-field census.
