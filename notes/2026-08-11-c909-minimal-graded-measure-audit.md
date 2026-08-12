# C909 — Hostile audit of the minimal graded-measure obstruction

**Date:** 2026-08-11  
**Lane:** clebsch  
**Status:** source-level audit; no manuscript, PDF, mirror, Lean edit, or commit.

## Verdict

The conditional weak-factorization argument is algebraically sound after three
precisions:

1. \(R_2=\mathbf Z[L]/(L^3)\) is a truncated \(\mathbf Z[L]\)-module for the
   test, not a ring admitting evaluation \(L\mapsto1\);
2. endpoint separation must be stated as a surviving degree-zero class,
   \(P_2(L)e_\alpha\notin L\mathbf Z e_\alpha\), not merely as
   \((1+L^2)e_\alpha\ne0\); and
3. the threefold width bound must include absolute degree placement, not only
   Jordan length \(\ell_{1/6}\le1\).

With these repairs, no orientation, codimension, or truncation error remains.
The theorem is conditional on a globally defined assignment satisfying the
strict graded formulas; weak factorization itself supplies the signed
telescoping argument.

## Orientation and dimension audit

Let \(Y=X\times\mathbf P^2\), a fivefold.  If \(Y\) were \(K\)-rational, weak
factorization of a birational map
\[
\mathbf P^5_K \dashrightarrow Y
\]
gives a chain of smooth fivefolds in which each center has codimension at least
two, hence dimension at most three.  Reading a blowup forward adds
\[
(L+\cdots+L^{c-1})\widetilde{\operatorname{CF}}(Z);
\]
reading the inverse blowdown subtracts the same term.  Therefore a support
subgroup closed under signs is enough; no positivity assumption is needed.

For a center of dimension three, \(c=5-3=2\), so its exceptional factor is
exactly \(L\).  Centers of dimension at most two contribute zero in the cubic
component by the low-carrier exclusion.  Thus, if every threefold carrier is
degree-zero in that component, every factorization increment lies in
\[
L\mathbf Z e_\alpha.
\]
The starting \(\mathbf P^5\) term has no cubic component: the rank-six
projective-bundle formula reduces it to six copies of the point atom, and the
point is covered by the dimension-\(\le2\) exclusion.  Telescoping therefore
forces the endpoint cubic component into \(L\mathbf Z e_\alpha\).

The endpoint formula is correct:
\[
[\alpha]\widetilde{\operatorname{CF}}(X\times\mathbf P^2)
  =(1+L+L^2)e_\alpha.
\]

## Repair 1: \(R_2\) is not specialized at \(L=1\)

The prior note says that ordinary chemical formula is recovered by
\(L\mapsto1\) from \(R_2=\mathbf Z[L]/(L^3)\).  This is false as a ring map:
the relation \(L^3=0\) would map to \(1=0\).

The correct statement is one of the following equivalent formulations:

* work in the full graded module \(\mathbf Z[L][\mathcal A]\), where the
  ordinary chemical formula is obtained only after a genuine augmentation
  \(L\mapsto1\); or
* project the full graded object to its degree-\(\le2\) coefficient module
  \[
  \mathsf T_2:=\mathbf Z\oplus\mathbf ZL\oplus\mathbf ZL^2,
  \qquad L^3=0,
  \]
  and use \(\mathsf T_2[\mathcal A]\) only as a finite support test.

The \(R_2\) formulas remain valid as \(\mathbf Z[L]\)-module identities after
truncation.  No ring specialization back to ordinary chemical formula should
be claimed.  In particular, the audit does not require the graded target to
be a ring-valued motivic measure.

## Repair 2: endpoint separation is a subgroup statement

In the free module \(R_2e_\alpha\), the endpoint polynomial has constant
coefficient \(e_\alpha\), so
\[
(1+L+L^2)e_\alpha\notin L\mathbf Z e_\alpha.
\tag{C909.22}
\]
This is the property used by the telescoping proof.

The condition \((1+L^2)e_\alpha\ne0\) alone is not logically equivalent in an
arbitrary quotient module: a nonzero element can still lie in \(L M\).  The
minimal robust axiom is
\[
\pi_0(e_\alpha)\ne0,
\qquad\text{equivalently for the test,}\qquad
(1+L^2)e_\alpha\notin L M e_\alpha,
\tag{C909.23}
\]
where \(\pi_0\) is the degree-zero coefficient map.  In the free
\(\mathsf T_2e_\alpha\) target this is automatic from the chosen generator,
but it must be stated when passing to an analytic quotient.

The center subgroup is \(L\mathbf Z e_\alpha\), not the larger
\(L R_2e_\alpha\).  A threefold carrier is required to lie in degree zero
with an integral coefficient; otherwise its \(L\)-shift could contribute an
uncontrolled \(L^2\) term.

## Repair 3: width is not placement

The statement \(\ell_{1/6}(W)\le1\) says that the relevant unipotent block has
length one.  By itself it does not say at which integral/Rees level the block
lives.  A shifted class \(L^k e_\alpha\) still has length one.  The minimal
axiom needed by the proof is the stronger normalized support condition
\[
[\alpha]\widetilde{\operatorname{CF}}(W)\in\mathbf Z e_\alpha
\quad\text{for every smooth threefold }W.
\tag{C909.24}
\]
Thus C907 must prove both width \(\le1\) and a common degree-zero placement
(or prove directly that all threefold center terms land in the degree-one
subgroup after the codimension-two shift).

## Corrected conditional theorem

Use \(\mathsf T_2[\mathcal A]\) as a \(\mathbf Z[L]\)-module with \(L^3=0\).
Assume:

1. strict projective-bundle and blowup identities with factors
   \(1+\cdots+L^{R-1}\) and \(L+\cdots+L^{c-1}\);
2. \([\alpha]\widetilde{\operatorname{CF}}(X)=e_\alpha\) with
   \(\pi_0(e_\alpha)\ne0\);
3. \([\alpha]\widetilde{\operatorname{CF}}(W)=0\) for all smooth projective
   \(W\) of dimension at most two; and
4. \([\alpha]\widetilde{\operatorname{CF}}(W)\in\mathbf Z e_\alpha\) for every
   smooth projective threefold \(W\).

Then \(X\times\mathbf P^2\) is not \(K\)-rational.  Indeed, the rationality
assumption forces the endpoint component into \(L\mathbf Z e_\alpha\) by the
orientation audit, while the projective formula gives
\((1+L+L^2)e_\alpha\), contradicting (C909.22).

This is independent of analytic realization after the four assumptions are
granted.  It is not a proof that the enriched assignment exists.

## Functoriality and possible counterexamples

The deduction does not require prior proof that the graded formula is
independent of a chosen weak factorization: one fixed factorization already
telescopes values of a well-defined assignment on its smooth models.  An
analytic construction intended to define such an assignment globally does
need:

* compatibility for disconnected smooth centers, or explicit additivity under
  disjoint unions;
* invariance under changing the projective-bundle presentation and under
  composed blowup/blowdown moves;
* a functorial projection to the cubic-isotypic summand; and
* degree placement preserved by the comparison maps.

No counterexample to the corrected conditional theorem is available: any
counterexample would be a rational \(X\times\mathbf P^2\) carrying an
assignment with all four properties, which would contradict the telescoping
calculation.  There are, however, two ways to evade its hypotheses:

1. use only the ordinary atom chemical formula, in which \(L=1\) and endpoint
   and center levels collapse; or
2. construct a local/relative graded lattice whose degree placement changes
   with the blowup presentation, so that (G1) or (C909.24) fails globally.

The second is the relevant analytic risk in C907: local \(q\)-adic elementary
divisors do not yet provide a presentation-independent measure.

## ej + tt closeout / mystery ledger

The cheap correction is to replace the invalid \(R_2\to\mathbf Z\),
\(L\mapsto1\), by a full \(\mathbf Z[L]\) target or a degree-\(\le2\) module
used only for support.  The hostile checks settled:

* forward blowups add and reverse blowdowns subtract, so orientation is safe;
* all centers have dimension at most three, and threefold centers contribute
  exactly one \(L\)-shift;
* \(\mathbf P^5\) has no cubic component by the point-carrier exclusion;
* endpoint non-membership is a degree-zero coefficient claim, not merely a
  nonzero-difference claim; and
* length one is insufficient without common degree placement.

Remaining mystery: whether C907 can construct an enriched assignment satisfying
strict formulas and the normalized threefold placement.  No further algebraic
obstruction was found in this pass.

## Source pointers

The audited theorem is
notes/2026-08-11-c909-minimal-graded-measure-obstruction.md.
The ordinary-atom source boundary is
notes/2026-08-11-c909-enriched-carrier-no-go.md; C907's analytic gates are
in notes/2026-08-10-c907-quantum-monodromy-stabilization.md.
