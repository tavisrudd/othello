# C909 — Uniform graded-support obstruction for \(X\times\mathbf P^m\)

**Date:** 2026-08-11  
**Lane:** clebsch  
**Status:** bounded algebraic generalization; no manuscript, PDF, mirror, Lean edit, or commit.

## Verdict

The \(P^2\) support argument has a clean uniform form.  Put
\[
D=m+3,\qquad Y_m=X\times\mathbf P^m,
\qquad P_m(L)=1+L+\cdots+L^m.
\]
For a fixed \(m\), the minimal graded test target is the truncated
\(\mathbf Z[L]\)-module
\[
\mathsf T_m:=\bigoplus_{j=0}^{m}\mathbf ZL^j,
\qquad L^{m+1}=0,
\tag{C909.25}
\]
on the cubic-isotypic atom generator \(e_\alpha\).  This is a support module,
not a ring to be evaluated at \(L=1\).  A full \(\mathbf Z[L]\)- or Rees-valued
object gives all \(m\) simultaneously; \(\mathsf T_m\) is the finite quotient
needed for one chosen stabilization.

The word ``minimal'' is in the graded-support sense: starting with a degree-zero
carrier \(e_\alpha\), strict multiplication by \(L\) and a nonzero endpoint
\(L^m e_\alpha\) force the chain
\(e_\alpha,Le_\alpha,\ldots,L^m e_\alpha\).  The universal torsion-free
\(L^{m+1}\)-nilpotent target for that chain is exactly \(\mathsf T_m\); any
smaller target must either identify support degrees or kill the endpoint, and
therefore cannot justify the interior-versus-endpoint argument below.

The exact center-placement condition for an \(s\)-dimensional carrier is
\[
S_\alpha(Z)\subseteq\{0,1,\ldots,s-3\}
\quad (3\le s\le m+1),
\tag{C909.26}
\]
where \(S_\alpha(Z)\) is the set of degrees occurring in its cubic component.
For \(s\le2\), require \(S_\alpha(Z)=\varnothing\).  If the center has
codimension \(c=D-s\), then
\[
(L+\cdots+L^{c-1})S_\alpha(Z)
\subseteq\{1,\ldots,D-4\}
=\{1,\ldots,m-1\}.
\tag{C909.27}
\]
The endpoint \(P_m(L)e_\alpha\) has nonzero degrees \(0\) and \(m\), so the
interior support (C909.27) cannot telescope to it.

Thus the conditional algebraic theorem scales from \(P^2\) to every
\(m\ge1\).  It is substantially simpler than a full enriched atom category:
only the cubic-isotypic graded measure, strict formulas, and the support bound
(C909.26) are needed.  The analytic burden is still substantial and remains
owned by C907.

## Uniform conditional theorem

Fix a smooth cubic threefold \(X/K\), its primitive-sixth-root atom
\(\alpha\), and \(m\ge1\).  Assume an assignment
\[
\widetilde{\operatorname{CF}}(Y)\in
\mathsf T_m[\operatorname{Atoms}^{K}_G]
\]
for every smooth projective \(K\)-variety, with the following axioms.

**(U1) Strict graded blowup and projective-bundle formulas.**  For a rank-\(R\)
projective bundle and a codimension-\(c\) smooth blowup,
\[
\begin{aligned}
\widetilde{\operatorname{CF}}(\mathbf P_Y(E))
  &=(1+L+\cdots+L^{R-1})\widetilde{\operatorname{CF}}(Y),\\
\widetilde{\operatorname{CF}}(\operatorname{Bl}_Z Y)
  &=\widetilde{\operatorname{CF}}(Y)
    +(L+\cdots+L^{c-1})\widetilde{\operatorname{CF}}(Z),
\end{aligned}
\tag{C909.28}
\]
as identities in the truncated graded module.

**(U2) Endpoint normalization.**  The cubic component of \(X\) is the
degree-zero generator:
\[
[\alpha]\widetilde{\operatorname{CF}}(X)=e_\alpha,
\qquad \pi_0(e_\alpha)\ne0.
\tag{C909.29}
\]

**(U3) Low-carrier exclusion.**  \(S_\alpha(Z)=\varnothing\) for every smooth
projective \(Z\) of dimension \(s\le2\).

**(U4) Uniform carrier placement.**  For every smooth projective \(s\)-fold
with \(3\le s\le m+1\),
\[
[\alpha]\widetilde{\operatorname{CF}}(Z)
\in\bigoplus_{j=0}^{s-3}\mathbf Ze_\alpha L^j.
\tag{C909.30}
\]
No positivity is assumed; coefficients may change sign when a factorization
step is inverted.

**Theorem.**  Under (U1)--(U4), \(X\times\mathbf P^m\) is not birational to
\(\mathbf P^{m+3}_K\).

### Proof

The endpoint is a rank-\((m+1)\) projective bundle over \(X\), so (U1)--(U2)
give
\[
[\alpha]\widetilde{\operatorname{CF}}(Y_m)
 =P_m(L)e_\alpha.
\tag{C909.31}
\]

If \(Y_m\) were \(K\)-rational, weak factorization of
\(\mathbf P^{D}_K\dashrightarrow Y_m\) uses centers of dimension
\(s\le D-2=m+1\).  The projective-space starting term has no cubic component:
it is a rank-\((D+1)\) projective bundle over a point, and (U3) applies to the
point atom.

For \(s\le2\), (U3) makes a center contribution zero.  For \(3\le s\le m+1\),
the codimension is \(c=D-s\ge2\).  By (U4), the largest possible degree in a
center contribution is
\[
(s-3)+(c-1)
 =s-3+D-s-1
 =D-4
 =m-1,
\]
and its smallest possible degree is \(1\).  Hence every forward blowup
increment, and every reverse blowdown decrement, lies in
\[
\bigoplus_{j=1}^{m-1}\mathbf Ze_\alpha L^j.
\tag{C909.32}
\]
Telescoping the factorization puts the final cubic component in this interior
subgroup.  But (C909.31) has nonzero degree-zero and degree-\(m\) terms, which
cannot lie in (C909.32).  Contradiction.

For \(m=1\), the interior subgroup is zero and all centers have dimension at
most two, recovering the one-step proof.  For \(m=2\), (U4) only concerns
threefolds and says their component is degree zero, recovering the audited
\(R_2\) theorem.

## Exact inequality and why width alone fails

Write
\[
\mu_\alpha(Z)=\min S_\alpha(Z),\qquad
\nu_\alpha(Z)=\max S_\alpha(Z)
\]
when the cubic component is nonzero.  Condition (C909.26) is equivalent to the
two absolute inequalities
\[
\mu_\alpha(Z)\ge0,\qquad
\nu_\alpha(Z)\le s-3.
\tag{C909.33}
\]
The exceptional shift then gives
\[
\mu_\alpha(\text{center term})\ge1,\qquad
\nu_\alpha(\text{center term})\le m-1.
\tag{C909.34}
\]
The weaker width inequality
\[
\nu_\alpha(Z)-\mu_\alpha(Z)\le s-3
\]
is insufficient: an arbitrarily shifted block \(L^kS_\alpha(Z)\) has the same
width and can hit degree \(0\) or \(m\) after the exceptional shift.  C907
must therefore prove a common absolute placement or formulate the invariant
so that (C909.33) is presentation-independent.

The \(m=2\) carrier bound \(\ell_{1/6}(Z)\le1\) is exactly the width part
\(\nu-\mu\le0\); the audit showed that the degree-zero placement is an
additional hypothesis, not a consequence of length one.

## Which axioms scale

* **(U1) scales formally** for every \(m\), but a single finite
  \(\mathsf T_m\) does not serve all stabilizations.  A uniform theorem needs
  a full \(\mathbf Z[L]\)- or Rees-valued object and compatible truncations.
* **(U2) scales unchanged.**  The endpoint always starts from the same
  degree-zero cubic carrier and projective space supplies \(P_m(L)\).
* **(U3) scales unchanged** for the known cubic surface exclusion.
* **(U4) is the new uniform analytic gate.**  It asks for the carrier support
  bound in every dimension \(3\le s\le m+1\), not only the threefold case.
* **Functoriality scales and is indispensable.**  The graded assignment must
  be presentation-independent, additive for disconnected centers, and strict
  under composed blowup/projective-bundle comparisons.  A local lattice at one
  boundary does not suffice.

The theorem does not require a classification of all atom representations,
Euler branches, or Serre operators.  It only requires a cubic-isotypic graded
support projection.  Nevertheless, proving (U4) for arbitrary smooth centers
and proving strict composition are precisely the unresolved C907 obligations.

## Uniform-target assessment for C907

This gives C907 a simpler formal target:
\[
\text{cubic atom}+\text{absolute support levels}+
\text{strict blowup/projective formulas}.
\]
For a fixed \(m\), the target can be truncated to \(m+1\) levels.  For all
\(m\), the target must retain an unbounded Rees grading, but it need not retain
the full enhanced atom category.  The simplification is algebraic only; no
existing KKPYY theorem constructs this target or proves (U4).

## ej + tt closeout / mystery ledger

The cheap generalization is the endpoint/interior split
\[
\{0,m\}\quad\text{versus}\quad\{1,\ldots,m-1\}.
\]
The hostile checks were:

* \(m=1\): there are no threefold-or-higher centers, so the interior subgroup
  is zero and the known one-step proof is recovered;
* \(m=2\): a threefold center has codimension two and contributes exactly \(L\);
* \(m=3\): threefold centers contribute degrees \(1,2\), and fourfold centers
  also contribute degrees \(1,2\);
* arbitrary signs from blowdowns preserve the interior support subgroup; and
* width without absolute placement fails, so (U4) cannot be weakened to a
  length statement alone.

Settled: the formal uniform theorem and its exact center inequalities.
Remaining mystery: whether C907 can realize (U4) and strict graded formulas
through weak factorization.  No further algebraic obstruction was found.

## Source pointers

The \(m=2\) theorem and audit are in
notes/2026-08-11-c909-minimal-graded-measure-obstruction.md and
notes/2026-08-11-c909-minimal-graded-measure-audit.md.  C907's analytic
boundaries are in notes/2026-08-10-c907-quantum-monodromy-stabilization.md.
