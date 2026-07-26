# C639: odd tangent-twisted carrier and its zeroth conductor

**Lane:** `relconic`

**Date:** 2026-07-25

**Status:** complete negative globally, with an exact positive fiberwise
theorem.  For an odd arc, a maximum centre has one unique tangent and the
remaining arc points occur in secant pairs.  Dividing the dual Chow
restriction by that tangent factor therefore gives a square, but the tangent
point determines only a one-dimensional factor line, not a distinguished
linear form.  Fixing the tangent contact \(a\in A\) removes this ambiguity:
the roots of \(F_A/a\) form an honest carrier and every arc in that
contact fiber has size at most \(k-1\).

There is no global ordinary carrier obtained by varying the tangent contact.
Compatible tangent factors on an arc of maximum centres must come from one
ambient linear form, so all unique tangents must be concurrent.  Even then,
two distinct centres on the same tangent have unequal root values at their
carrier intersection.  This is a nonzero zeroth-order conductor.  The
oval--nucleus zero-defect branch realizes the obstruction at full scale:
each of its \(q+1\) tangents contains \(q-1\) maximum centres, giving
\[
 (q+1)\binom{q-1}{2}
\]
nonzero tangent-node conductors.  Their normalized nonzero values are
equidistributed, and on each tangent their value classes form the canonical
near-one-factorization of \(K_{q-1}\).  Across tangent fibers, compatibility
is exactly the complete \((q+1)\)-partite graph and has clique number
\(q+1=k\).  For the regular oval, every collinear triple from distinct
fibers has nonzero first conductor, so the roots globalize exactly on
tangent-fiber-transversal arcs.  Thus the odd tangent twist does not produce
a global square-root carrier or a positive-defect obstruction.

No manuscript file is changed.  The stable algebraic and combinatorial core
is formalized in `RelativeConicArcs.OddTangentCarrier` and exposed through
the dedicated gate `RelativeConicArcs.Gates.OddTangentCarrier`.

## Pointwise odd square restriction

Let \(K\) be a perfect field of characteristic two and let
\[
 A=\{a_1,\ldots,a_{2m+1}\}\subset\mathbb P(V)
\]
be a \(k=2m+1\)-arc.  As in C626, regard representatives of the \(a_i\) as
linear forms on the dual plane and put
\[
 F_A=\prod_{a\in A}a.
\]
For \(x\notin A\), let \(L_x=x^*\) be the line parametrizing primal lines
through \(x\).

If \(r_A(x)=m\), the \(m\) secants through \(x\) account for \(2m\) points of
\(A\).  The remaining point \(a(x)\in A\) lies on the unique tangent
\(\tau_x=xa(x)\).  Consequently, for every nonzero
\[
 \lambda_x\in
 E_x:=H^0\!\left(L_x,\mathcal O_{L_x}(1)(-\tau_x^*)\right)
\]
there is a unique \(g_x\in H^0(L_x,\mathcal O_{L_x}(m))\) such that
\[
 \boxed{\qquad F_A|_{L_x}=\lambda_x g_x^2.\qquad}
\]
Here \(E_x\) is one-dimensional.  Replacing
\(\lambda_x\) by \(s^2\lambda_x\) replaces \(g_x\) by \(s^{-1}g_x\).
Thus the projectively intrinsic pointwise object is the resulting
\(\mathbb G_m\)-torsor, or equivalently a square root twisted by the
half-tangent divisor.  The tangent point alone does not select an ordinary
degree-\(m\) root.

This is the precise sense in which the odd restriction has a canonical
*twisted* square root but no canonical untwisting.

## The honest fixed-contact carrier

For \(a\in A\), define
\[
 X_{A,a}=
 \{x\notin A:r_A(x)=m,\ a(x)=a\}.
\]
Put
\[
 H_a=F_A/a=\prod_{b\in A\setminus\{a\}}b.
\]
For every \(x\in X_{A,a}\), all roots of \(H_a|_{L_x}\) are double, so
\[
 H_a|_{L_x}=g_{x,a}^2
\]
for a unique degree-\(m\) form \(g_{x,a}\).  At every intersection
\(p=L_x\cap L_y\),
\[
 g_{x,a}(p)^2=H_a(p)=g_{y,a}(p)^2.
\]
Frobenius injectivity gives \(g_{x,a}(p)=g_{y,a}(p)\), including when
\(H_a(p)=0\).

### Fiberwise arc-number theorem

Every arc \(Y\subseteq X_{A,a}\) satisfies
\[
 \boxed{\qquad |Y|\le 2m=k-1.\qquad}
\]

Indeed, the dual lines \(L_x\), \(x\in Y\), have no three concurrent.  The
C626 carrier extension lemma gives a degree-\(m\) plane form \(G\) whose
restriction to \(L_x\) is \(g_{x,a}\).  Hence every \(L_x\) divides
\(H_a-G^2\), a form of degree \(2m\).  If \(|Y|>2m\), then
\(H_a=G^2\), impossible because \(H_a\) is a product of \(2m\) distinct
linear forms, each with multiplicity one.

At odd zero defect the maximum matchings form a full
\(\operatorname{MATCH}(k,m,1)\) design.  Each secant belongs to \(k-2\)
maximum blocks.  Counting blocks which match a fixed vertex \(a\) gives
\[
 (k-1)(k-2),
\]
whereas the total number of blocks is \(k(k-2)\).  Therefore
\[
 |X_{A,a}|=k-2.
\]
The fiberwise carrier bound is consequently compatible with exact
zero-defect families and supplies no defect gap.

## Exact compatibility criterion for tangent factors

Let \(Y\) be an arc of maximum centres, with at least three points.  Choose
on every \(L_x\) a tangent factor \(\lambda_x\), vanishing at
\(\tau_x^*\).

The factors are pairwise compatible,
\[
 \lambda_x(L_x\cap L_y)=\lambda_y(L_x\cap L_y)
 \quad(x,y\in Y),
\]
if and only if there is an ambient linear form \(\Lambda\) with
\[
 \lambda_x=\Lambda|_{L_x}
 \quad(x\in Y).
\]
This is the degree-one case of the carrier extension lemma.  In particular,
the points \(\tau_x^*\) all lie on the dual line \(\Lambda=0\).  Dually:
\[
\boxed{\quad
\text{compatible tangent factors}
\Longleftrightarrow
\text{the unique tangents }\tau_x\text{ concur at a point }z\notin Y.\quad}
\]
If their common point belonged to \(Y\), the only ambient linear form
vanishing on all \(\tau_x^*\) would restrict identically to zero on that
centre's carrier line.  The converse for \(z\notin Y\) uses the linear form
representing \(z\).
This is an exact projective criterion, not a coordinate normalization.

Factor compatibility is still insufficient for root compatibility at a
common tangent node.

## The zeroth-order tangent conductor

Suppose the unique tangents of the centres in \(Y\) concur at \(z\notin Y\),
and use \(\Lambda=z\).  Let two distinct centres \(x,y\) lie on the same tangent
\(\tau=za\), where \(a\in A\) is its contact point.  At the dual point
\[
 p=\tau^*=L_x\cap L_y
\]
write
\[
 F_A=aR,\qquad R(p)\ne0.
\]
Choose representatives with
\[
 x=\alpha_xa+\beta_xz,\qquad
 y=\alpha_ya+\beta_yz.
\]
Since \(x,y\notin\{a,z\}\), the displayed coefficients are nonzero.  The
restriction of \(F_A/z\) to \(L_x\) is regular at \(p\), and its value is
\[
 \left.(F_A/z)\right|_{L_x}(p)
 =R(p)\frac{\beta_x}{\alpha_x}.
\]
Consequently the tangent-twisted root has
\[
 g_x(p)^2=R(p)\frac{\beta_x}{\alpha_x},
\qquad
 g_y(p)^2=R(p)\frac{\beta_y}{\alpha_y}.
\]
Distinct points on \(\tau\) give distinct projective ratios, so
\[
 \boxed{\quad
 \Theta_p(x,y)^2:=(g_x(p)+g_y(p))^2
 =R(p)\left(
 \frac{\beta_x}{\alpha_x}+
 \frac{\beta_y}{\alpha_y}\right)\ne0.\quad}
\]
Nonvanishing is independent of all representative and coordinate choices.
It is the zeroth-order conductor created by cancelling the common zero of
\(F_A\) and the proposed global tangent factor.

Conversely, if the tangents concur at \(z\) and no two centres of \(Y\) lie
on the same tangent, then \(z\) is nonzero at every carrier intersection.
The restrictions of the common rational section \(F_A/z\) have the same
value there, and their unique square roots glue.  Thus:
\[
 \boxed{\quad
 \begin{aligned}
 &\text{a concurrent tangent untwisting gives an honest carrier on }Y\\
 &\hspace{20mm}\Longleftrightarrow
 x\longmapsto\tau_x\text{ is injective on }Y.
 \end{aligned}\quad}
\]

In the injective case there are at most \(k\) tangent contact points, hence
\(|Y|\le k\) before using the carrier polynomial.  Repeating the extension
argument with \(F_A-zG^2\) gives the same bound.  Therefore the globally
compatible branch yields only the tautological tangent count; every attempt
to exceed it necessarily enters the nonzero-conductor branch.

## Oval--nucleus zero-defect falsifier

Let \(q\ge4\) be even and let \(A\) be an oval in
\(\operatorname{PG}(2,q)\), so \(k=q+1\), with nucleus \(n\).  Every point
outside \(A\cup\{n\}\) is a maximum centre of index \(q/2\), and its unique
tangent is the oval tangent through \(n\).  Hence the global factor criterion
is as favorable as possible: all unique tangents concur and the ambient
factor \(n\) exists.

For each \(a\in A\), the tangent \(na\) contains exactly \(q-1\) maximum
centres.  The preceding local calculation shows that every pair of distinct
centres on that tangent has nonzero zeroth conductor.  The tangent fibers
partition the maximum-centre set, so the exact conductor count is
\[
 \boxed{\qquad
 E_{\mathrm{tan}}(A)
 =(q+1)\binom{q-1}{2}.\qquad}
\]
Equivalently, the proposed nucleus factor makes the tangent divisors
compatible but cannot make their square roots compatible.  The obstruction
is already present at pairwise intersections, before the first-jet
three-carrier conductor of C626.

If a prescribed nonsingular conic \(\mathcal C\) is disjoint from \(A\) and
contains \(n\), the committed odd equality converse gives
\(\Delta_{\mathcal C}(A)=0\).  Thus every realized oval--nucleus
zero-defect pair carries the full displayed conductor baseline.  The
projective no-go itself is unconditional for every oval and does not depend
on choosing \(\mathcal C\).

This is the odd analogue of C638's regular-hyperoval falsifier.  It respects
the strongest available conic/oval polarity structure and occurs throughout
an exact zero-defect family, rather than on an exceptional configuration.

The zeroth-conductor values themselves have no scalar bias.  On the tangent
\(na\), use the projective coordinate
\[
 x_\kappa=a+\kappa n,\qquad \kappa\in\mathbf F_q^\times,
\]
for its \(q-1\) maximum centres.  After dividing by the common nonzero factor
\(R(\tau^*)\), the conductor of the pair
\(\{x_\kappa,x_\mu\}\) satisfies
\[
 \frac{\Theta_{\tau^*}(x_\kappa,x_\mu)^2}{R(\tau^*)}
 =\kappa+\mu.
\]
For each \(\delta\in\mathbf F_q^\times\), exactly
\[
 \frac{q-2}{2}
\]
unordered pairs have normalized squared conductor \(\delta\).  Frobenius is
bijective, so the normalized conductor values themselves are equally
distributed as well.  Across all \(q+1\) tangent fibers, each nonzero
normalized value occurs
\[
 (q+1)\frac{q-2}{2}
\]
times.

There is an exact combinatorial refinement.  On the vertex set
\(\mathbf F_q^\times\), color the edge \(\{\kappa,\mu\}\) by
\(\delta=\kappa+\mu\).  For fixed \(\delta\), the color class is the
near-perfect matching
\[
 \bigl\{\{\kappa,\kappa+\delta\}:
 \kappa\notin\{0,\delta\}\bigr\},
\]
with the single vertex \(\delta\) unmatched.  The \(q-1\) color classes
partition every edge of \(K_{q-1}\).  Hence the entire oval zeroth-conductor
graph is the disjoint union of \(q+1\) copies of this near-one-factorization.
Scalar moments, support counts, and unweighted within-contact pair incidence
are all fixed by the zero-defect baseline.  A surviving odd invariant must
couple distinct tangent-contact fibers or retain additional prescribed-conic
data.

The cross-contact pair structure is equally rigid.  If \(x\in na\) and
\(y\in nb\) with \(a\ne b\), then \(xy\) does not pass through \(n\).
At \(p=(xy)^*\), the common factor \(n(p)\) is nonzero.  Both carrier roots
therefore square to the same value \(F_A(p)/n(p)\), and Frobenius injectivity
makes them equal.  Combining this with the within-fiber conductor calculation
shows that the pairwise root-compatibility graph on
\[
 X_A=\mathbb P^2(\mathbf F_q)\setminus(A\cup\{n\})
\]
is exactly
\[
 \boxed{\qquad K_{\underbrace{q-1,\ldots,q-1}_{q+1\text{ parts}}}.\qquad}
\]
Its parts are the tangent fibers.  Its largest clique has one vertex from
each part and therefore has size \(q+1=k\), exactly the degree threshold in
the tangent-twisted carrier argument.  The oval branch does not merely evade
the bound: its pairwise compatibility graph saturates it.

For the regular oval, C638 closes the next layer as well.  Put
\[
 H=A\cup\{n\},
\]
the regular hyperoval, and write
\[
 F_H=nF_A=n^2(F_A/n).
\]
On every odd carrier line let \(g_x^2=(F_A/n)|_{L_x}\).  The corresponding
even-hyperoval root is
\[
 h_x=n|_{L_x}\,g_x.
\]
At a carrier intersection \(p=\ell^*\) with \(\ell\) not through \(n\), the
first conductors satisfy
\[
 \boxed{\qquad \Omega_H(p)=n(p)\Omega_{\mathrm{odd}}(p).\qquad}
\]
Indeed, differentiating \(h_x=ng_x\) adds a common term
\(g_x(p)D_{v_x}n\); its conductor sum vanishes because the relation
coefficients satisfy \(\sum_xc_xv_x=0\).

A line containing centres from three distinct tangent fibers cannot pass
through \(n\).  C638 proves that every collinear triple in the regular
hyperoval complement has nonzero first conductor.  The displayed transfer
therefore gives
\[
 \boxed{\quad
 \text{every collinear triple from three distinct tangent fibers has }
 \Omega_{\mathrm{odd}}\ne0.\quad}
\]
There are exactly
\[
 \boxed{\qquad
 \frac{q(q-1)}2\binom{q+1}{3}
 +\frac{q(q+1)}2\binom{q-1}{3}
\qquad}
\]
such triples.  The first term comes from the external conic lines, each
containing one centre from every tangent fiber; the second comes from the
ordinary conic secants, each containing \(q-1\) centres with distinct
contacts.  The omitted \(q+1\) hyperoval secants are the oval tangents and
contain only one contact fiber, where the zeroth conductor already obstructs
gluing.

Consequently the regular oval baseline has an exact globalizability
criterion.  For \(Y\subseteq X_A\), the tangent-twisted roots are restrictions
of one degree-\(m\) plane form if and only if
\[
 \boxed{\qquad
 Y\text{ meets every tangent fiber at most once and }Y\text{ is an arc}.
 \qquad}
\]
Necessity is the within-fiber zeroth conductor followed by the cross-fiber
first conductor.  For sufficiency, all pairwise root values agree, and the
arc condition makes the dual carrier lines have no triple concurrence, so
the carrier extension lemma applies.  Thus the zero-defect baseline fixes
not only all pair data but the entire ordinary gluing complex whenever the
regular oval occurs on the zero-defect branch.

## Lean formalization

`RelativeConicArcs.OddTangentCarrier` kernel-checks the parts of the argument
which do not require a projective Chow-product API:

- `sq_injective_charTwo` and `oddTangentFactorization_rescale` prove root
  uniqueness and the exact factor/root rescaling law;
- `oddZerothConductorSq_ne_zero` proves the same-fiber zeroth conductor
  nonzero from a nonzero residual factor and distinct tangent parameters;
- `tangentConductorPartner_involutive`,
  `tangentConductorPartner_ne_self`, and
  `tangentConductorPartner_ne_zero` prove the fixed-point-free partner
  structure on every nonzero conductor class;
- `excludedTangentParametersEquivOrderedPairs` and
  `card_nonzeroOrderedConductorPairs` identify the ordered nonzero pair fiber
  with the field minus \(0\) and the conductor label, giving exact cardinality
  \(|K|-2\);
- `tangentConductorMatching` and
  `card_nonzeroUnorderedConductorPairs` quotient that fixed-point-free partner
  involution by coordinate exchange and give the exact near-perfect-matching
  cardinality \((|K|-2)/2\);
- `tangentFiberCompatibilityGraph_isClique_iff_injOn`,
  `tangentFiberCompatibilityGraph_clique_card_le`, and
  `exists_tangentFiberCompatibilityGraph_clique_card_eq` identify the
  compatibility graph as complete multipartite and prove its exact clique
  bound when every contact fiber is represented;
- `oddCarrierConductor_mul_commonFactor` and its nonvanishing terminal prove
  the first-conductor transfer through \(h_x=ng_x\); and
- `ordinaryGlobalizes_iff_of_transversal_arc_criteria` composes the
  same-fiber obstruction, cross-fiber arc obstruction, and carrier-extension
  input into the exact transversal-arc globalization criterion.

The formal boundary is explicit.  Lean does not construct \(F_A\), identify
the projective tangent-contact map, prove the regular-oval external/secant
triple count, or establish the carrier-extension hypotheses from projective
geometry.  The last terminal checks their logical composition rather than
asserting those analytic inputs.

The import-only gate audits all sixteen public terminals.  Direct source
elaboration is warning-free, and the source-local axiom audit of the new
unordered-count terminal reports only `propext`, `Classical.choice`, and
`Quot.sound`.  The exact Lake build and no-build replay await the shared
build-owner window.

## Outcome and boundary

C639 closes with a sharp positive/negative split:

- every odd maximum centre has a canonical half-tangent-twisted square root;
- fixing the tangent contact gives an honest carrier and the exact
  fiberwise arc-number bound \(\alpha(X_{A,a})\le k-1\);
- varying contacts admits compatible ordinary tangent factors exactly when
  the tangents concur;
- repeated tangents then create the explicit nonzero zeroth conductor; and
- if no tangent repeats, the resulting \(|Y|\le k\) bound is already forced
  by the number of tangent contacts.

Thus there is no global carrier inequality stronger than the elementary
tangent partition, and no nonnegative statistic retaining the zeroth
conductor can be bounded by defect.  A future odd invariant would have to
subtract the complete oval--nucleus tangent baseline or couple different
contact fibers.  That is a new normalization, not an unfinished part of
C639.

No novelty or literature-absence claim is made.  The proof uses only the
committed C626 carrier extension argument, the C627 odd matching counts, and
elementary projective duality.

## `ej` + `tt` closeout

The cheap upgrade is the fixed-contact theorem.  It salvages the precise
part of the odd construction which is genuinely canonical: after removing
one fixed arc factor, the C626 argument applies verbatim and improves the
fiber arc number to \(k-1\).

The Tao-style stress test separates factor gluing from root gluing.  Tangent
concurrence solves only the degree-one factor problem.  At a repeated tangent
the quotient is a branch-dependent \(0/0\), and its two limiting values are
distinct.  This exposes the missing zeroth conductor and makes the
oval--nucleus family a decisive zero-defect falsifier.

The remaining apparent positive branch is not hidden leverage.  When tangent
concurrence and injectivity both hold, there are at most \(k\) tangent lines
because each has a distinct contact in \(A\).  The carrier reproduces that
same bound and no more.

The user-requested extra-juice pass then tests whether the zeroth-conductor
*values* retain information after their support count fails.  They do not at
the scalar or within-fiber pair level: every nonzero normalized value has the
same multiplicity, and the value classes form the displayed
near-one-factorization of \(K_{q-1}\).  This is the exact odd analogue of
C638's uniform local-value and pair-design baselines.  The first shape not
disposed of is necessarily cross-contact.

The same `ej` pass closes the raw cross-contact pair layer as well.  Pairwise
compatibility is the complete \((q+1)\)-partite graph with tangent fibers as
parts.  Its clique number is exactly \(q+1=k\), so the C626-style degree
argument is sharp on the oval baseline; pair support and pair values are
exhausted.

The user-requested `ej2` pass starts at the first surviving shape, triples
from distinct contact fibers.  For the regular oval, the identity
\(F_H=n^2(F_A/n)\) transfers C638's all-lines first-conductor theorem exactly:
every collinear cross-fiber triple has nonzero odd first conductor.  Together
with the zeroth conductor, this proves that the ordinary gluing complex is
exactly the complex of tangent-fiber-transversal arcs.  No higher local jet
is needed to classify ordinary globalizability in the baseline.  A genuinely
new odd invariant must now compare nonregular oval behavior, subtract this
complete regular baseline, or couple it to the prescribed conic.

## Mystery ledger

| Feature | Disposition |
|:--|:--|
| Does an odd maximum centre have a square-root object? | **Settled positively:** it has a canonical half-tangent-twisted root torsor. |
| Does the tangent point select an ordinary root? | **No:** it selects a one-dimensional factor line, with no distinguished nonzero section. |
| Is any honest carrier retained? | **Yes:** each fixed-contact fiber \(X_{A,a}\) carries the roots of \(F_A/a\), and its arc number is at most \(k-1\). |
| When can tangent factors be chosen compatibly across contacts? | **Settled exactly:** precisely when the unique tangents concur at a point outside the carrier-centre set. |
| Does compatible factor choice make the roots glue? | **Only with injective tangent map:** repeated tangents have the displayed nonzero zeroth conductor. |
| Can the globally compatible branch improve the arc bound? | **No:** injectivity already gives at most one centre per at most \(k\) tangent contacts. |
| Can zeroth-conductor mass force positive defect? | **Settled negatively on the oval--nucleus equality branch:** every realized zero-defect pair has exactly \((q+1)\binom{q-1}{2}\) such pairs. |
| Do normalized zeroth-conductor values have scalar bias? | **Settled negatively by `ej`:** every nonzero value occurs \((q+1)(q-2)/2\) times in the oval baseline. |
| Does within-contact pair incidence retain extra structure? | **Settled exactly by `ej`:** each tangent fiber is a \(K_{q-1}\) decomposed into \(q-1\) near-perfect matchings indexed by conductor value. |
| Does cross-contact pairwise compatibility yield a stronger bound? | **Settled negatively by `ej`:** it is exactly \(K_{q-1,\ldots,q-1}\), whose clique number \(q+1=k\) saturates the carrier threshold. |
| What happens on collinear triples from distinct fibers? | **Settled for the regular oval by `ej2`:** C638 transfers through \(F_H=n^2(F_A/n)\), making every such first conductor nonzero with the displayed exact count. |
| Which subsets admit one ordinary global root in the regular baseline? | **Settled exactly by `ej2`:** precisely the tangent-fiber-transversal arcs. |
| Is a further odd normalization still conceivable? | **Only as a new task:** it must distinguish nonregular ovals, subtract the complete regular baseline, or use additional prescribed-conic data. |
