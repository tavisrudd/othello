# C628 uniform quadratic-hull obstruction

**Lane:** `relconic`

**Date:** 2026-07-25

**Status:** COMPLETE NEGATIVE AS AN AMPLIFICATION GATE.  THE EVALUATION
OBSTRUCTION HAS AN EXACT FIELD-UNIFORM HILBERT/SEPARATOR FORM, BUT THAT FORM
DOES NOT FORCE THE `q=16` QUADRATIC-AVOIDANCE CONCLUSION.

## Scope

This task recasts the quadratic-evaluation obstruction intrinsically and asks
whether the recasting supplies a structural replacement for the exhaustive
`q=16` leaf classification.  It makes no manuscript edit and introduces no
new finite computation.  The bounded orders `q=13,17,19` are used only to
specialize the theorem and identify the remaining evidence gap.

Let
\[
 S=\mathbb F_q[X_0,X_1,X_2],\qquad N_d=\dim_{\mathbb F_q}S_d=\binom{d+2}{2}.
\]
For a finite projective point set \(U\), choose arbitrary nonzero vector
representatives and put
\[
 I(U)_d=\{f\in S_d:f(u)=0\text{ for every }u\in U\}.
\]
The choices rescale evaluation coordinates but do not change any rank,
kernel, zero-coordinate, or full-support assertion below.  Write
\[
 H_U(d)=\operatorname{rank}\bigl(S_d\longrightarrow\mathbb F_q^U\bigr)
\]
and define the degree-\(d\) hull
\[
 \operatorname{Hull}_d(U)=
 \{x\in\operatorname{PG}(2,q):f(x)=0\text{ for every }f\in I(U)_d\}.
\]

## Uniform Hilbert--separator theorem

**Theorem.**  Let \(A,U\subseteq\operatorname{PG}(2,q)\) be disjoint finite
sets, let \(d\geq0\), and suppose \(|A|\leq q\).  There is a form
\[
 f\in S_d,\qquad f|_U=0,\qquad f(a)\ne0\quad(a\in A)
\]
if and only if
\[
 H_U(d)<N_d
 \quad\text{and}\quad
 H_{U\cup\{a\}}(d)=H_U(d)+1\quad(a\in A).
\]
Equivalently, such a form exists if and only if
\[
 I(U)_d\ne0
 \quad\text{and}\quad
 A\cap\operatorname{Hull}_d(U)=\varnothing.
\]

**Proof.**  Put \(W=I(U)_d\).  For \(a\in A\), evaluation restricts to a
linear functional \(\lambda_a:W\to\mathbb F_q\).  Its kernel is proper
exactly when some degree-\(d\) form separates \(a\) from \(U\), which is
equivalent both to the displayed Hilbert-function jump and to
\(a\notin\operatorname{Hull}_d(U)\).

It remains to choose one element outside all the kernels.  A nonzero vector
space over \(\mathbb F_q\) is not the union of at most \(q\) proper
hyperplanes.  Indeed, after fixing one hyperplane, every other distinct
hyperplane contributes at most \(q^{s-1}-q^{s-2}\) new vectors in dimension
\(s\ge2\), so \(t\le q\) hyperplanes cover at most
\[
 q^{s-1}+(t-1)(q^{s-1}-q^{s-2})<q^s.
\]
Dimension one is immediate.  Thus some \(f\in W\) avoids every
\(\ker\lambda_a\).  The reverse implication is tautological. \(\square\)

The bound is exact: the \(q+1\) one-dimensional subspaces of
\(\mathbb F_q^2\) are proper hyperplanes and cover the whole space.  Hence no
argument using only individual degree-\(d\) separators can replace
\(|A|\le q\) by \(|A|\le q+1\).

## Veronese and code formulations

The degree-\(d\) Veronese evaluation vectors of \(U\) span a subspace of
\(S_d^*\) of dimension \(H_U(d)\).  The separator jump at \(a\) says exactly
that the Veronese point \(\nu_d(a)\) is not in the span of
\(\nu_d(U)\).  Thus the theorem can be read as
\[
 \dim\langle\nu_d(U)\rangle<N_d
 \quad\text{and}\quad
 \nu_d(a)\notin\langle\nu_d(U)\rangle\quad(a\in A).
\]

Equivalently, evaluate \(I(U)_d\) on \(A\):
\[
 C_{U,A,d}=\{(f(a))_{a\in A}:f\in I(U)_d\}\subseteq\mathbb F_q^A.
\]
The desired form is a full-support word of this shortened Veronese code.
For a linear code of length at most \(q\), a full-support word exists if and
only if no coordinate is identically zero.  The two obstruction alternatives
are therefore:

1. \(I(U)_d=0\), equivalently \(H_U(d)=N_d\); or
2. some coordinate of \(C_{U,A,d}\) is identically zero, equivalently some
   \(a\in A\) has no degree-\(d\) separator from \(U\).

This is precisely the manuscript's full-rank/forced-hit dichotomy, now with
its exact uniform range and sharp boundary exposed.

## The quadratic hull in the plane

For \(d=2\), \(N_2=6\).  If \(U\) contains at least five distinct points of a
nonsingular conic \(\mathcal C\), then
\[
 I(U)_2=\langle Q_{\mathcal C}\rangle,\qquad H_U(2)=5,\qquad
 \operatorname{Hull}_2(U)=\mathcal C(\mathbb F_q).
\]
Indeed, an independent quadratic through \(U\) would meet the absolutely
irreducible conic in at least five distinct geometric points, contradicting
Bézout's degree-four intersection bound.  Consequently, on this stratum the
whole Hilbert/separator obstruction reduces to one incidence question:
whether the unique conic through \(U\) meets \(A\).

This explains both exceptional behaviors already certified in the repository.
For the three rank-five `q=16` leaves, the unique quadratic through the
ordinary-uncovered locus meets respectively `2,7,2` selected points, so the
shortened code has an identically zero coordinate and no full-support word.
By contrast, the certified six-arc over `q=11` has ordinary-uncovered locus
equal to all twelve points of the standard conic, whose unique quadratic
avoids all six selected points.  Both situations have
\[
 H_U(2)=5,\qquad \dim I(U)_2=1.
\]
Thus the Hilbert function, nullity, and even uniqueness of the quadratic do
not distinguish obstruction from avoidance.  The missing datum is the
incidence of \(A\) with the quadratic hull, or equivalently the zero-coordinate
profile of \(C_{U,A,2}\).

The cited finite facts are not new computations: the `q=16` data and exact
kernel generators are in `2026-07-16-c201-gate1-q16-anatomy.md`; the `q=11`
conic-index check is replayed by
`papers/arcs_complete_outside_conic/check_q11_structure.py`.

## Bounded pilots

The lower-bound candidates are
\[
 (q,k)=(13,7),(17,8),(19,8).
\]
In all three cases \(k\le q\), so the uniform theorem applies without loss.
For an ordinary-uncovered locus \(U(A)\), a quadratic avoiding \(A\) and
containing \(U(A)\) exists exactly when
\[
 H_{U(A)}(2)<6
 \quad\text{and}\quad
 A\cap\operatorname{Hull}_2(U(A))=\varnothing.
\]
Therefore any exact rejection certificate at these orders may be reduced to
one of two intrinsic records:

- six independent uncovered Veronese evaluations; or
- one selected point in the quadratic hull of the uncovered locus.

This is a useful certificate compression, but not a nonexistence proof.
Neither the arc axioms nor the first two secant moments force either record.
The `q=11` versus exceptional-`q=16` comparison proves that the same
quadratic Hilbert function supports both outcomes.  Closing any of the three
orders still requires a projective classification, a new theorem coupling
the secant arrangement to the quadratic hull, or a separately reproducible
finite certificate.  No pilot has been promoted into an exact-value claim.

There is also an important one-way boundary.  The theorem produces a nonzero
quadratic, possibly singular.  That suffices for a quadratic-avoidance
obstruction, because excluding all quadratics excludes nonsingular conics.
It does not by itself construct a prescribed nonsingular conic.  On the
five-points-on-a-nonsingular-conic stratum, uniqueness removes this issue.

## Conclusion

The `q=16` theorem does have a field-uniform algebraic skeleton: for
\(|A|\le q\), quadratic avoidance is equivalent to nontrivial quadratic
kernel plus pointwise degree-two separation.  The threshold is sharp, and
the formulation is simultaneously a Hilbert-function jump criterion, a
Veronese-span criterion, a quadratic-hull criterion, and a full-support-word
criterion.

It does **not** furnish a structural extension of the `q=16` nonexistence
result.  Once five uncovered points determine a conic, all Hilbert data
collapse to rank five and the decisive question is simply whether that conic
hits the arc.  The certified `q=11` and exceptional-`q=16` configurations
realize opposite answers with identical Hilbert function.  C628 therefore
closes negatively as an amplification gate; `q=13,17,19` remain bounded open
cases rather than computation requests hidden inside a uniform theorem.

## `ej` + `tt` closeout

The cheap upgrade is the exact code theorem: length at most \(q\) and no zero
coordinate force a full-support word, with the projective
\([q+1,2,q]\) simplex pattern giving the sharp obstruction at the next
length.  This identifies the real invariant as the represented matroid of
the combined Veronese evaluations of \(U\cup A\), not the scalar Hilbert
function of \(U\).  It also compresses any future bounded certificate to a
rank record plus one closure witness.

A rank-three-sensitive successor should therefore ask for a mechanism that
forces
\(\nu_2(a)\in\langle\nu_2(U(A))\rangle\) from the secant arrangement, not for
another aggregate count of \(U(A)\).  Without that coupling, higher-degree
Hilbert functions merely repeat the same full-support-code question in a
larger coefficient space.

## Mystery ledger

- **Settled:** the exact uniform range of the Hilbert/separator criterion is
  \(|A|\le q\), and the \(q+1\) failure is sharp.
- **Settled:** on at least five points of a nonsingular conic, the quadratic
  hull is exactly that conic and the Hilbert function contains no further
  information.
- **Open:** no structural principle is known that couples the secant
  arrangement of an arc to membership
  \(A\cap\operatorname{Hull}_2(U(A))\).  This is the exact evidence gap behind
  the three bounded pilots and belongs to a future explicitly allocated
  classification or rank-three-sensitive task.
- **Open:** the exact values at `q=13,17,19` remain unproved.  C628 supplies
  only the lossless certificate shape and makes no finite-search claim.
