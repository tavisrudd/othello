# C907 the \(\rho=2\) \(\nu _6\) rank shortcut fails formally

**Lane:** clebsch

**Verdict:** there is no theorem

\[
 \nu _6(Z)\leq 2b_2(Z) \tag{1}
\]

deducible from the formal HLT spectrum, cohomological grading, determinant,
Hard Lefschetz, and a degree-twisted alternating self-duality of the type
used by the small-even quantum connection.  In particular, the rank count

\[
 \operatorname{rank}H^{\rm even}(Z)=2+2b_2(Z) \tag{2}
\]

does not exclude equality \(\nu _6=6\) when \(b_2=2\).  The proposed
unit/top argument has no invariant target: formal \(\Phi _6\)-primary
spaces live in the Turrittin solution lattice, whereas unit and top degree
are cohomological vectors and need not define formal submodules.

The explicit rank-six model below has cohomology dimensions \((1,2,2,1)\),
a unit and top class, Poincare duality, hard Lefschetz, the cohomological
grading operator, determinant one, twisted self-duality,
\(\chi_{T_{\rm f}}=\Phi _6^3\), and a length-three Rees operator.  It is a
formal countermodel, not the QDM of a smooth projective threefold.  It
identifies the extra input required for any geometric \(\rho=2\) theorem.

## 1. Why the rank proposal needs one missing exclusion

For a smooth projective threefold, Poincare duality gives

\[
 \dim H^{\rm even}=b_0+b_2+b_4+b_6=2+2b_2. \tag{3}
\]

The new J3-implies-\(\nu _6\)-at-least-six admission theorem would rule out
J3 on a smooth rank-two Mori fibre threefold if one could exclude the sole
remaining case

\[
 \nu _6=2+2b_2=6. \tag{4}
\]

The desired inequality (1) is exactly that exclusion.  Neither determinant
nor reciprocal-root self-duality gives it: a full \(\Phi _6\)-primary space
has determinant one and consists of reciprocal pairs.

One might try to reserve two dimensions for the unit and top class.  This is
not legitimate.  Formal monodromy is formed only after HLT reduction of the
\(z\)-connection.  It has no reason to preserve the cohomological degree
splitting: already

\[
 \nabla_{z\partial_z}
 =z\partial_z+\mu-z^{-1}(E\mathbin\star) \tag{5}
\]

contains quantum multiplication which mixes degrees.  Thus a unit/top block
is not a defined formal submodule without a new grading--HLT compatibility
theorem.

## 2. A graded self-dual rank-six countermodel

Put \(A=\mathbf Z[1/6]\),

\[
 B=A[\varepsilon]/(\varepsilon^3),\qquad
 \lambda:B\longrightarrow A,\quad
 \lambda(\varepsilon^2)=1,\quad\lambda(1)=\lambda(\varepsilon)=0,
\]

and let \(W=A u\oplus A v\) have alternating form

\[
 J(u,v)=1,\qquad J(v,u)=-1. \tag{6}
\]

On \(H=B\otimes_AW\), define

\[
 Q(b\otimes w,b'\otimes w')=\lambda(bb')J(w,w'). \tag{7}
\]

Give \(H\) the cohomological grading

\[
\begin{array}{c|c}
\text{degree}&\text{basis}\\ \hline
0& e_0=1\otimes u\\
2& a=1\otimes v,\quad b=\varepsilon\otimes u\\
4& c=\varepsilon\otimes v,\quad d=\varepsilon^2\otimes u\\
6& t=\varepsilon^2\otimes v .
\end{array} \tag{8}
\]

There is a symmetric Poincare form \(P\), uniquely specified by

\[
 P(e_0,t)=1,\qquad P(a,d)=1,\qquad P(b,c)=-1, \tag{9}
\]

and symmetry.  If \(\sigma|_{H^{2p}}=(-1)^p\), then

\[
 Q(x,y)=P(\sigma x,y). \tag{10}
\]

Thus \(Q\) is a degree-twisted alternating form while \(P\) has the
threefold Poincare degree pattern and signature \((3,3)\).  The centered
cohomological grading operator

\[
 \mu|_{H^{2p}}=(p-\tfrac32)1 \tag{11}
\]

is \(P\)-skew, as required by degree duality.

Define a degree-two Lefschetz operator by

\[
 Le_0=-b,\quad La=d,\quad Lb=c,\quad Lc=t,\quad Ld=Lt=0. \tag{12}
\]

It is \(P\)-self-adjoint.  Moreover

\[
 L^3:H^0\xrightarrow{\sim}H^6,\qquad
 L:H^2\xrightarrow{\sim}H^4, \tag{13}
\]

so the full hard-Lefschetz ranks hold.  In particular the model does not
discard unit, top, grading, or ordinary Poincare duality.

Now take

\[
 g=\begin{pmatrix}0&-1\\1&1\end{pmatrix},\qquad
 s=2g-1=
 \begin{pmatrix}-1&-2\\2&1\end{pmatrix} \tag{14}
\]

in the basis \(u,v\), and set

\[
 T_{\rm f}=1_B\otimes g,\qquad
 N=(\varepsilon\cdot)\otimes s. \tag{15}
\]

The direct identities are

\[
 g^{\mathsf T}Jg=J,\quad
 \chi_g(T)=T^2-T+1,\quad
 s^2=-3,\quad
 [T_{\rm f},N]=0, \tag{16}
\]

and

\[
 T_{\rm f}^{*}Q=Q,\qquad
 Q(Nx,y)+Q(x,Ny)=0,\qquad
 N^2=-3(\varepsilon^2\cdot)\otimes1\ne0,\qquad N^3=0. \tag{17}
\]

Consequently

\[
 \chi_{T_{\rm f}}(T)=\Phi _6(T)^3,\qquad
 \det T_{\rm f}=1,\qquad \nu _6(H)=6. \tag{18}
\]

The \(\varepsilon\)-degree filtration has three nonzero rank-two grades and
\(N\) moves successively through them.  Since \(s\) is invertible over \(A\),
after a splitting field it contains length-three Jordan/Rees strings.  This
is exactly the J3-admissible rank pattern.

The model also displays the failure of the unit/top reservation:

\[
 T_{\rm f}(e_0)=a,\qquad T_{\rm f}(t)=-d+t. \tag{19}
\]

Formal monodromy mixes cohomological degrees.  It preserves the twisted flat
form \(Q\), not raw Poincare \(P\).  Requiring a \(P\)-isometry would rule out
(18) by a real-signature argument, but that is an extra condition, not a
consequence of the formal twisted self-duality used here.

Over \(\mathbf C\), \(T_{\rm f}\) is the monodromy of a regular-singular
formal differential module with residues \(1/6,-1/6\), repeated three
times.  Hence it is a legitimate HLT formal-monodromy datum.  The example
is deliberately not claimed to be a Frobenius manifold or the QDM of a
variety; it proves only that the listed formal constraints do not yield (1).

## 3. Exact conclusion for Mori fibres and terminal MMP

For a smooth Mori fibre threefold with \(\rho=b_2=2\), the ordinary rank
bound is only

\[
 \nu_6\le6. \tag{20}
\]

It is compatible with the J3-implies-\(\nu_6\)-at-least-six threshold by
equality.  Therefore the proposed rank shortcut does not exclude J3 for
such a space.

For a terminal Mori fibre space the shortcut is weaker still.  The framed
small-even QDM and its \(\nu_6\) invariant used by C907 are
smooth-projective objects.  A terminal resolution can increase \(b_2\), and
the existing blow-up comparisons prove invariance only through specified
smooth operations; they do not furnish a terminal singular-QDM rank formula
or a resolution-independent inequality (1).  Thus terminal MMP cannot
upgrade (20) into the missing exclusion.

## 4. The genuine next condition

A positive \(\rho=2\) theorem would need a new geometric statement, for
example:

\[
 \text{the full \(\Phi _6\)-primary solution space is never all of the
 small-even QDM of a smooth threefold.} \tag{21}
\]

Equivalently, one needs a rank-two formal subquotient selected by the QDM
unit/top structure and proved to have eigenvalues outside \(\Phi _6\).
Neither cohomological degree, determinant, hard Lefschetz, nor twisted
self-duality constructs such a subquotient.  Establishing (21) would be a
new quantum-geometric theorem, not a formal consequence of the current
C907 package.

## Inputs and boundary

The rank identity (3) is ordinary Poincare duality.  The exact C907
rank-preserving admission hypothesis is recorded in
2026-08-13-c907-rank-preserving-j3-admission-theorem.md.  No external
quantum computation or claim about an actual \(\rho=2\) variety occurs in
this report.  The displayed model is included in full, so every negative
formal implication is checkable directly from (6)--(19).

## EJ/TT and mystery ledger

- **EJ:** J3-implies-\(\nu_6\)-at-least-six remains a valuable admission
  test, but it stops one dimension short of eliminating smooth \(\rho=2\)
  Mori fibres.
- **TT:** Poincare signature would exclude full \(\Phi_6\) only if formal
  monodromy preserved raw symmetric Poincare form.  The relevant connection
  pairing is twisted; substituting the stronger isometry is the hidden false
  step.
- **Settled:** no \(\nu_6\le2b_2\) theorem follows from the proposed formal
  inputs, and \(\rho=2\) is not closed by rank.
- **Open:** a genuine QDM mechanism for (21), or an actual smooth
  \(\rho=2\) example with \(\nu_6=6\); the formal model is not such an
  example.
