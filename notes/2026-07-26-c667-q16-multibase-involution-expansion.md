# C667: multi-base conic involutions expose a six-hole stability gate

**Lane:** `relconic`

**Result:** negative as a certificate-free proof, with a sharp new finite
target.

C666 considered the eight fibers through one uncovered conic point.  C667
couples the same eight center involutions across every uncovered conic point.
This does make the local Rédei condition substantially stronger: in the
checked \(2633\)-class list there is no multi-base survivor.  However, the
pure involution-boundary data admit exact counterexamples, and the
multi-base exclusion still has no proof independent of that list.

The strongest new pattern is quantitative.  Among all \(2,291,362\) checked
pairs consisting of an eight-arc and a disjoint nonsingular conic containing
at least six ordinary holes, every non-relative pair has at least six
off-conic holes visible on the \(A\times U\) fibers.  Equality occurs.  Its
six holes are two collinear triples and support a split quadratic meeting
the arc once on each component.

## 1. Exact involution dictionary

Use the standard conic
\[
 \mathcal C:\ XZ+Y^2=0,\qquad
 p(t)=(t^2,t,1),\quad p(\infty)=(1,0,0).
\]
The chord through \(p(s)\) and \(p(t)\) has equation
\[
 X+(s+t)Y+stZ=0.
\]
For a center \(a=(A,B,C)\notin\mathcal C\), the second intersection of
\(ap(s)\) with the conic is
\[
 \tau_a(s)=\frac{A+Bs}{B+Cs}.
\]
Thus \(a\) corresponds to the projective trace-zero matrix
\[
 M_a=
 \begin{pmatrix}
 B&A\\ C&B
 \end{pmatrix}.
\]
Its determinant is \(B^2+AC\), so it is invertible precisely off the conic.
Except at the nucleus \((0,1,0)\), which gives the identity projectivity,
\(\tau_a\) is an involution of the \(17\)-point conic.

For two centers \(a,b\), the rational fixed points of
\(\tau_a\tau_b\) are exactly the rational intersections of the line \(ab\)
with \(\mathcal C\).  Therefore, if \(W\) is the covered conic set,
\[
 W=\bigcup_{\{a,b\}\in\binom A2}
       \operatorname{Fix}_{\mathcal C}(\tau_a\tau_b).
                                                        \tag{1}
\]
Writing \(U=\mathcal C\setminus W\), the exceptional fibers of C666 for
center \(a\) are the boundary
\[
 e_a
 =|\{u\in U:\tau_a(u)\notin U\}|
 =\frac12|U\mathbin\triangle\tau_a(U)|.          \tag{2}
\]

Equations (1) and (2) are exact, coordinate-free after identifying
\(\mathcal C\cong\mathbf P^1\), and are the natural finite
\(\operatorname{PGL}_2(16)\) formulation of the proposed expansion attack.

## 2. Boundary expansion alone is false

The standard conic admits the eight-arc
\[
 A=(2,25,26,43,44,89,108,197)
\]
in the repository's polynomial-basis point ordering.  Its uncovered conic
set is
\[
 U=(53,70,84,174,202,239),
\]
so \(|U|=6\) and \(|W|=11\), exactly the small-complement range needed by
the proposed argument.  Nevertheless the eight boundary sizes are
\[
 (e_a)_{a\in A}=(4,2,3,2,2,4,4,3).
\]
The centers form a genuine arc, and (1) holds by construction.  Hence no
subgroup argument based only on the size of \(U\), the fixed points of pair
products, or the eight symmetric differences can give the desired
contradiction.

This example has \(18\) off-conic ordinary holes.  Every one is visible from
at least one pair \((a,u)\in A\times U\).  Thus it fails the actual
multi-base fiber hypothesis even though it satisfies all proposed
boundary-level input.

## 3. The stronger multi-base condition

For \(a\in A\) and \(u\in U\), call an off-conic ordinary hole \(x\)
**visible** if \(x,a,u\) are collinear.  The complementary-\(K_7\) quotient
on the fiber \(au\) holds exactly when that fiber has no visible off-conic
hole.  Consequently all \(8|U|\) quotients hold precisely when the visible
off-conic hole set is empty.

This condition retains information discarded by (1) and (2): it remembers
the actual rank-three embedding of the involutions' centers and every
off-conic point on the joining lines.

## 4. Exact finite result

The checker reads the \(2633\) projective eight-arc representatives already
used by the \(q=16\) augmentation certificate.  For each ordinary-uncovered
locus \(H\), it enumerates every nonsingular conic which:

- is disjoint from the selected arc; and
- contains at least six points of \(H\).

It is enough to generate conics from five-subsets of \(H\).  Any five
distinct points on a nonsingular conic impose independent conditions on
quadratics: a second quadratic through them would restrict to a degree-four
form with five roots on \(\mathcal C\), hence would contain \(\mathcal C\).
Deduplication makes the enumeration exact.

The resulting counts are:

\[
\begin{array}{c|r}
\text{eight-arc leaves}&2633\\
\text{distinct rank-five candidate quadratics tested}&26,755,617\\
\text{disjoint nonsingular pairs with at least six conic holes}&2,291,362\\
\text{multi-base survivors}&0.
\end{array}
\]

More sharply, if such a pair has any hole outside its conic, at least six
off-conic holes are visible on \(A\times U\).  The minimum six is attained
at leaf \(3\):
\[
\begin{aligned}
A&=(0,1,17,34,52,67,89,112),\\
Q&=(1,1,6,7,7,0),\\
U&=(124,126,151,171,173,251,253,263),\\
V&=(139,141,166,191,218,245).
\end{aligned}
\]
Here \(V\) splits into the triples
\[
 (139,218,245)\subset Z(X+15Y+Z),\qquad
 (141,166,191)\subset Z(X+8Y+Z).
\]
Their unique quadratic is
\[
 (X+15Y+Z)(X+8Y+Z),
\]
and the two component lines meet \(A\) at points \(89\) and \(112\),
respectively.  Thus equality is a genuine six-point split-quadratic
circuit, not numerical slack in the checker.

## 5. Why this still does not replace the certificate

The zero-survivor result above consumes the exact \(2633\)-leaf list.  It is
therefore an independently shaped diagnostic over each leaf, but not an
independent proof that every eight-arc is covered by the list.  Importing its
conclusion into the paper would retain the same exhaustive classification
dependency that C663--C667 were asked to remove.

The human theorem now required is the following quantitative statement.

> Let \(A\) be an eight-arc in \(\operatorname{PG}(2,16)\), let
> \(\mathcal C\) be a nonsingular conic disjoint from \(A\), and let
> \(U\subseteq\mathcal C\) be the ordinary-uncovered conic points.  If
> \(|U|\ge6\) and some ordinary hole lies outside \(\mathcal C\), then at
> least six off-conic holes lie on lines joining \(A\) to \(U\).

Its positive lower bound alone would rule out all multi-base quotients.
The exact value six and the two-line equality configuration suggest a
Veronese-circuit or split-quadratic proof.  The cheap code argument does not
finish it: C663 already showed that six-point quadratic circuits are
abundant, so minimum support by itself supplies no contradiction.  What is
missing is a proof that the chord-product lift forces precisely such a
circuit whenever the visible set is nonempty.

## 6. Reproducibility

Build and replay from the repository root:

```text
g++ -O3 -std=c++20 \
  notes/2026-07-26-c667-q16-multibase-involution-expansion.cpp \
  -o /tmp/c667_multibase
/tmp/c667_multibase --check
```

The executable verifies the explicit boundary-only counterexample, parses
all \(2633\) level-eight representatives, reconstructs ordinary holes from
the \(28\) secants, enumerates and deduplicates the candidate conics, checks
nonsingularity and arc avoidance, constructs every \(A\times U\) fiber, and
recomputes the minimum visible-hole count.  The canonical output is
`notes/2026-07-26-c667-q16-multibase-involution-expansion.json`.

SHA-256:

```text
568be2fa296466c059a9cdcefcb4f830a861a1dba18e6a69eab29eb07872cfc1  lean/RelativeConicArcs/Q16CertificateLevels.lean
046a89a39d524bdc8df151ec6de62b8318f2bec456ea49945d717a3a50936093  notes/2026-07-26-c667-q16-multibase-involution-expansion.cpp
fd04ddf38a75aef9eb842bd00eacf27f85572aabe32a47694eae12e9e7e7ebc6  notes/2026-07-26-c667-q16-multibase-involution-expansion.json
```

## Mystery ledger

- **Settled:** the center-to-involution and pair-product fixed-point
  dictionaries are exact.
- **Settled:** small \(U\), small involution boundaries, and arc centers do
  not alone force a contradiction.
- **Settled:** imposing every multi-base fiber quotient leaves no survivor
  in the checked classification.
- **Settled by the `ej`+`tt` closeout:** failure propagates to at least six
  visible holes in the checked data; equality is two collinear triples on a
  split quadratic meeting the arc twice.
- **Not settled:** a classification-free proof of the six-visible-hole
  stability statement.
- **Exact evidence boundary:** the count and minimum use the existing
  exhaustive level-eight list and cannot replace its coverage theorem.
