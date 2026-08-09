# C756 character-weighted all-center resultant/norm identity

**Lane:** `clebsch` · **Date:** 2026-08-09 · **Scope:** nonsaturated
research only; no manuscript edit

## Verdict

The character-weighted collision total has an exact coordinate-free
resultant formula.  One must retain the **full norm polynomial**, not only its
scalar norm or its first coefficient.

Let \(\Sigma(A)\) be the set of ordered deleted-point/spare-passant systems
\(s=(P,\ell)\), and let \(D_s\) be the degree-\(\delta\) residual concurrence
divisor on \(\ell\) from

\[
 H_A|_\ell=M_\ell L_P^{k-2}R_{P,\ell}.
\]

Put \(B_s=H^0(D_s,\mathcal O_{D_s})\).  Normalize the conic form once so that
its quadratic character is \(+1\) on external points and \(-1\) on internal
points, and define the unit

\[
 q_s=\frac{Q|_\ell}{L_P^2}\in B_s^\times,
 \qquad u_s=q_s^{(q-1)/2}.
\]

Then

\[
 \boxed{
 \mathcal N_s(Z):=N_{B_s/\mathbf F_q}(Z-u_s)
  =(Z-1)^{a_s}(Z+1)^{b_s}, }
 \tag{1}
\]

where \(a_s\), respectively \(b_s\), is the residual multiplicity supported
on external, respectively internal, points.  Consequently

\[
 \deg\mathcal N_s=\delta,
 \qquad \operatorname{Tr}_{B_s/\mathbf F_q}(u_s)=\overline{a_s-b_s}
   =\overline{W_s},
 \qquad N_{B_s/\mathbf F_q}(u_s)=(-1)^{b_s}.             \tag{2}
\]

In a monic affine model \(E_s(T)\) for the residual divisor, put
\(U_s=Q_\ell^{(q-1)/2}\bmod E_s\), of degree less than \(\delta\).  Then (1)
is the bounded resultant

\[
 \mathcal N_s(Z)
 =\operatorname{Res}_T
   \bigl(E_s(T),Z-U_s(T)\bigr),                         \tag{3}
\]

and its scalar norm satisfies

\[
 N_{B_s/\mathbf F_q}(u_s)
 =\chi\!\left(\operatorname{Res}_T(E_s,Q_\ell)\right). \tag{4}
\]

Thus the open character total is the difference of the two root
multiplicities of the all-center norm polynomial.  Its trace coefficient is
the reduction of that integer modulo the characteristic.  If

\[
 D=\delta\,|\Sigma(A)|
 =\delta\left[k\left(\frac{q+1}{2}-(k-1)\right)-e\right]
\]

and

\[
 T_A=\sum_{s\in\Sigma(A)}W_s
 =\sum_{X\notin A\cup C}\tau(X)(d_X-1)s_A(X),
\]

then

\[
 \boxed{
 \begin{aligned}
 \mathcal N_A(Z)
   &:=\prod_{s\in\Sigma(A)}\mathcal N_s(Z)\\
   &=(Z-1)^{(D+T_A)/2}(Z+1)^{(D-T_A)/2},\\
 T_A&=\operatorname{ord}_{Z=1}\mathcal N_A
       -\operatorname{ord}_{Z=-1}\mathcal N_A,\\
 \overline{T_A}&=-[Z^{D-1}]\mathcal N_A(Z)\in\mathbf F_q,\\
 \prod_{s\in\Sigma(A)}
   \chi\!\left(\operatorname{Res}(E_s,Q_\ell)\right)
   &=(-1)^{(D-T_A)/2}.
 \end{aligned}}                                           \tag{5}
\]

Formula (5) is the requested all-center resultant/norm law.  It is valid for
every defect and every mixture of deleted-point and line types.

At defect two it becomes especially small.  Put

\[
 \eta_s=\chi\!\left(\operatorname{Res}(E_s,Q_\ell)\right).
\]

Then

\[
 \boxed{
 \mathcal N_s(Z)=Z^2-W_sZ+\eta_s,
 \qquad W_s^2=2(1+\eta_s), }                              \tag{6}
\]

and hence

\[
 \boxed{
 \sum_{s\in\Sigma(A)}W_s^2
 =2|\Sigma(A)|+2\sum_{s\in\Sigma(A)}\eta_s.}             \tag{7}
\]

The scalar resultant detects exactly the zero-weight residual divisors:
\(\eta_s=-1\) precisely when one residual multiplicity is external and the
other internal.  It cannot distinguish \(W_s=2\) from \(W_s=-2\).  The trace
polynomial in (3), rather than its scalar constant term, is therefore
essential; a product of scalar resultants can recover only \(T_A\bmod4\), not
\(T_A\).

## Proof

Every residual point is rational.  If \(X\) occurs in \(D_s\) with
multiplicity \(m_X\), its local Artin factor has residue field
\(\mathbf F_q\) and length \(m_X\).  Multiplication by \(u_s\) on that factor
is upper triangular with the residue

\[
 u_s(X)=q_s(X)^{(q-1)/2}=\tau(X)\in\{1,-1\}
\]

repeated \(m_X\) times on the diagonal.  Its characteristic polynomial is
therefore \((Z-\tau(X))^{m_X}\).  Multiplying the local factors proves (1)
and (2), with the integer weight reduced into \(\mathbf F_q\) in the trace
identity.

For monic \(E_s\), the determinant of multiplication by a residue class
\(g\) is \(\operatorname{Res}(E_s,g)\).  Applying this first to
\(g=Z-u_s\), and then to \(g=q_s\), proves (3)--(4).  The denominator
\(L_P^2\) has square norm and does not change the quadratic character.

In the direct product algebra \(B_A=\prod_s B_s\), external residual
multiplicity is

\[
 M_+=\sum_{X\text{ external}}(d_X-1)s_A(X),
\]

and internal residual multiplicity is the analogous \(M_-\).  The unweighted
collision identity gives \(M_++M_-=D\), while its character-weighted form
gives \(M_+-M_-=T_A\).  Taking the characteristic polynomial, trace and
determinant of \(u_A=(u_s)_s\) proves (5).

For \(\delta=2\), the possibilities for \((a_s,b_s)\) are
\((2,0),(1,1),(0,2)\).  Their norm polynomials are respectively
\((Z-1)^2,Z^2-1,(Z+1)^2\), proving (6)--(7), including a double residual
point because its local multiplication matrix has the same repeated residue
on the diagonal.

## Bounded defect-two trace carrier

The full trace does not require the degree-\((q-1)/2\) power to remain
expanded.  Reduce it modulo the residual quadratic.  If

\[
 E_s(T)=T^2-\sigma_sT+\pi_s,
 \qquad
 Q_\ell(T)^{(q-1)/2}\equiv \alpha_sT+\beta_s\pmod{E_s},
\]

then

\[
 \boxed{
 \overline{W_s}=\alpha_s\sigma_s+2\beta_s,
 \qquad
 \eta_s=\alpha_s^2\pi_s+\alpha_s\beta_s\sigma_s+\beta_s^2.} \tag{8}
\]

Thus the mixed-character input needed by the remaining \(q=53\) covariance
rows is a linear remainder plus its quadratic norm.  At defect two the field
trace selects a unique value in \(\{-2,0,2\}\).  Formula (8) is invariant
under replacing the affine coordinate: it is simply trace and norm in
\(B_s\).

## Consequences and route boundary

1. The desired character total is algebraic and coordinate-free; no
   all-internal or all-passant assumption enters.
2. The useful object is degree \(\delta\), because the forced Moore factor has
   already been removed and the large Euler power is reduced modulo \(E_s\).
3. A scalar resultant-only attack is now closed as insufficient.  At defect
   two both all-external and all-internal residual divisors have norm sign
   \(+1\), although their weights are \(+2\) and \(-2\).
4. Formula (5) does not by itself evaluate \(T_A\) from the external arc-point
   count \(e\).  That requires a cross-center relation for the trace
   remainders in (8), or geometric information that rules out one of the two
   equal-norm signs.
5. The next ordered C756 branch can use (8) directly on the remaining
   external-deletion anisotropic and disjoint-root split covariance rows.

## EJ + Tao closeout

The cheap upgrade is that the construction works for arbitrary defect, not
only defect two: the full all-center object is one characteristic polynomial
in the direct-product residual algebra.  Its degree is the known typed count
\(D\), the difference of its \(\pm1\) root multiplicities is the sought
integer weighted total, its first coefficient is that total modulo the
characteristic, and its constant term is the product of the scalar
resultants.

The Tao-style compression is to treat Euler's criterion as an element of the
residual Artin algebra and ask for its characteristic polynomial.  This makes
the multiplicities automatic, handles double residual roots without a case
split, and exposes exactly why the scalar norm loses one bit.  The free
task-owned upgrade is (8): reduce first, then carry only trace and norm into
the covariance calculation.

No computation is used in the proof.  The acceptance check is the three
defect-two local algebras: their characteristic polynomials give
\(W=2,0,-2\) and \(\eta=1,-1,1\), respectively, and their product gives the
global exponents in (5).

## Mystery ledger

| feature | status | exact gap / next gate |
|---|---|---|
| Coordinate-free meaning of the local weighted sum | settled | \(\pm1\) root-multiplicity difference of the norm polynomial; its trace modulo the characteristic |
| Resultant meaning of the local norm | settled | (4), including nonreduced residual divisors |
| All-center coupling | settled formally | direct-product norm polynomial (5) retains every deleted point and center |
| Defect-two zero-weight test | settled | \(W_s^2=2(1+\eta_s)\) |
| Sign of a same-type residual pair | genuinely absent from the scalar norm | retain the trace remainder (8) or prove a geometric sign restriction |
| Formula for \(T_A\) from \(e\) alone | open | (5) fixes the degree from \(e\), not the \(\pm1\) multiplicities; needs a cross-deletion compatibility law |
| Remaining \(q=53\) mixed covariance rows | open | substitute the bounded trace/norm carrier (8) in the anisotropic and disjoint-root split rows |
