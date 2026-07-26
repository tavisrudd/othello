# C626: square-root carriers and a rank-three third layer

**Lane:** `relconic`

**Date:** 2026-07-25

**Status:** complete positive.  In characteristic two, the maximum-index
centres of an even arc are exactly the lines on which the dual Chow product
restricts to a square.  The unique square roots form a carrier system.  They
glue across ordinary double intersections, but three concurrent carrier lines
have a new first-jet obstruction.  This gives a rank-three inequality which is
not a secant-index moment: the maximum-centre set has arc number at most the
size of the original arc.  Consequently, if it has \(N\) points, it spans at
least
\[
 \left\lceil\frac{\binom N3}{\binom{k+1}3}\right\rceil
\]
collinear triples.  At the zero-defect candidate \((q,k)=(4096,92)\), this
forces at least \(682058\) collinear triples among the \(8099\)
maximum-index centres.

No manuscript or Lean file is changed.

## Setup

Let \(K\) be a perfect field of characteristic two, let \(V\) have dimension
three, and let
\[
 A=\{a_1,\ldots,a_{2m}\}\subset\mathbb P(V)
\]
be a \(2m\)-arc.  Regard a representative of \(a_i\) as a linear form on the
dual vector space and define the dual Chow product
\[
 F_A=\prod_{i=1}^{2m}a_i\in\operatorname{Sym}^{2m}(V).
\]
It is a section of \(\mathcal O_{\mathbb P(V^*)}(2m)\), well defined up to a
nonzero scalar.  For \(x\in\mathbb P(V)\), write
\[
 L_x=x^*\subset\mathbb P(V^*)
\]
for the line parametrizing primal lines through \(x\).

For \(x\notin A\), the roots of \(F_A|_{L_x}\) are the lines through \(x\)
which meet \(A\).  Because \(A\) is an arc, every root has multiplicity one
or two: a tangent gives multiplicity one and a secant gives multiplicity two.
It follows that
\[
 \boxed{\quad r_A(x)=m
 \quad\Longleftrightarrow\quad
 F_A|_{L_x}=g_x^2
 \text{ for a unique }
 g_x\in H^0(L_x,\mathcal O_{L_x}(m)).\quad}
\]
Perfectness supplies the square root of the scalar coefficient, and
Frobenius injectivity makes \(g_x\) unique.

Let
\[
 X_A=\{x\notin A:r_A(x)=m\}.
\]
The lines \(L_x\), together with their canonical roots \(g_x\), are the
square-root carrier system.

## Carrier extension lemma

### Lemma

Let \(L_1,\ldots,L_n\) be distinct lines in a projective plane over \(K\),
with no three concurrent.  Suppose
\[
 g_i\in H^0(L_i,\mathcal O_{L_i}(m))
\]
and \(g_i=g_j\) at \(L_i\cap L_j\) for every \(i,j\).  Then there is a
homogeneous degree-\(m\) form \(G\) whose restriction to \(L_i\) is \(g_i\)
for every \(i\).

### Proof

Proceed by induction.  Suppose \(G\) already extends the first \(j-1\)
sections and let \(H_{j-1}\) be the product of the equations of those lines.
On \(L_j\), the difference \(g_j-G|_{L_j}\) vanishes at the \(j-1\) distinct
intersection points.

If \(j-1>m\), the difference is identically zero.  Otherwise it is
\(H_{j-1}|_{L_j}\) times a form of degree \(m-j+1\).  Lift that quotient to
the plane and add its product with \(H_{j-1}\) to \(G\).  This changes
nothing on the first \(j-1\) lines and gives the prescribed restriction on
\(L_j\).  The induction preserves degree \(m\).

## Rank-three carrier inequality

### Theorem

For every subset \(Y\subseteq X_A\) with no three collinear,
\[
 |Y|\le 2m=|A|.
\]
Equivalently, the largest arc contained in the maximum-centre set \(X_A\)
has size at most \(|A|\).

### Proof

The dual lines \(\{L_x:x\in Y\}\) have no three concurrent.  At
\(p=L_x\cap L_y\),
\[
 g_x(p)^2=F_A(p)=g_y(p)^2,
\]
so Frobenius injectivity gives \(g_x(p)=g_y(p)\).  The carrier extension
lemma therefore produces a degree-\(m\) form \(G\) restricting to \(g_x\)
on every \(L_x\).

Thus every \(L_x\) divides \(F_A-G^2\).  If \(|Y|>2m\), their product has
degree greater than \(\deg(F_A-G^2)=2m\), so
\[
 F_A=G^2.
\]
This is impossible: \(F_A\) is the product of the \(2m\) distinct dual lines
of the points of \(A\), each with multiplicity one.  Hence \(|Y|\le2m\).

This conclusion uses the locations and intersections of the carrier lines,
not merely the multiplicities \(r_A(x)\).  It is therefore invisible to all
raw moments treated in C555 and to C592's Gale-self-dual support aggregate.

## Quantitative third-layer consequence

Put \(k=2m\), \(N=|X_A|\), and let
\[
 T_{\mathrm{col}}(X_A)
 =\sum_{\ell\subset\mathbb P(V)}
   \binom{|X_A\cap\ell|}{3}
\]
be the number of collinear triples of maximum centres.  Every
\((k+1)\)-subset of \(X_A\) contains a collinear triple by the theorem.
Double-counting pairs consisting of a collinear triple and a
\((k+1)\)-subset containing it gives
\[
 \binom N{k+1}
 \le
 T_{\mathrm{col}}(X_A)\binom{N-3}{k-2}.
\]
Therefore, whenever \(N\ge k+1\),
\[
 \boxed{\quad
 T_{\mathrm{col}}(X_A)
 \ge
 \left\lceil
 \frac{\binom N3}{\binom{k+1}3}
 \right\rceil.\quad}
\]

At even zero defect, the maximum-matchings decompose the edges of
\(\operatorname{KG}(k,2)\), so
\[
 N=\frac{3\binom{k}{4}}{\binom{k/2}{2}}
  =(k-1)(k-3).
\]
For \(k=92\), this is \(N=8099\), and the displayed lower bound is
\[
 T_{\mathrm{col}}(X_A)
 \ge
 \left\lceil
 \frac{\binom{8099}{3}}{\binom{93}{3}}
 \right\rceil
 =682058.
\]
Also, any set meeting every collinear triple of \(X_A\) has size at least
\[
 N-k;
\]
otherwise its complement would be an arc in \(X_A\) of size greater than
\(k\).  At \(k=92\), at least \(8007\) maximum centres must be removed to
destroy all carrier-line triple concurrences.

These are projective-compatibility inequalities beyond the first two
concurrence moments: they count collinearity among concurrence centres,
whereas C555 and C592 count concurrent secants at one centre.

## The local third-layer covariant

The extension proof identifies exactly where the new information lives.
Suppose three carrier lines \(L_1,L_2,L_3\) meet at \(p\).  Choose tangent
directions \(v_i\) and nonzero coefficients \(c_i\) with
\[
 c_1v_1+c_2v_2+c_3v_3=0.
\]
After choosing one local trivialization of \(\mathcal O(m)\), let
\[
 d_i=D_{v_i}g_i(p).
\]
The three roots are the restrictions of one local section only if
\[
 \boxed{\quad
 \Omega_p(L_1,L_2,L_3)
 :=c_1d_1+c_2d_2+c_3d_3=0.\quad}
\]
The vanishing condition is independent of rescaling the \(v_i\), of the
common local trivialization, and of projective coordinates.

It can be written without choosing the roots.  If
\[
 F_A(p+t v_i)=F_A(p)+Q_p(v_i)t^2+O(t^4)
\]
along \(L_i\), then \(d_i^2=Q_p(v_i)\), and hence
\[
 \Omega_p(L_1,L_2,L_3)^2
 =\sum_{i=1}^3 c_i^2Q_p(v_i).
\]
Thus \(\Omega\) is a Hasse-second-derivative, bracket-covariant obstruction
attached to a collinear triple of maximum centres.  It is the first
conductor condition missed by pairwise value matching.  At a point incident
with \(s>3\) carrier lines, the same normalization problem has further jet
conditions through order \(s-2\); these form a finite local conductor
hierarchy.

If all local conductor conditions vanished on a carrier arrangement with
more than \(k\) lines, the roots would glue globally and the theorem's final
square contradiction would apply.  Hence every such arrangement has a
nonzero local conductor obstruction.  When every rich carrier intersection
has multiplicity exactly three, at least one displayed \(\Omega\) is
nonzero.

## Boundary and next use

The result does not by itself exclude a zero-defect arc.  It forces its
maximum-centre set to carry many collinear triples and a nontrivial local
square-root conductor hierarchy.  The next useful gate is to combine this
forced carrier concentration with either

1. C625's conic-polarity/stabilizer structure;
2. the prescribed-conic split of maximum centres; or
3. C627's bad-concurrence removal bounds.

A positive-defect theorem would follow from an upper bound on
\(T_{\mathrm{col}}(X_A)\), or from a theorem forcing the local carrier roots
to glue on the relevant conic-selected subarrangement.  Neither assertion is
made here.

No novelty or literature-absence claim is made.  The proof is elementary
projective algebra over a perfect characteristic-two field.

## `ej` + `tt` closeout

The cheap upgrade is the passage from a qualitative triple-concurrence
obstruction to the exact lower bound
\(\binom N3/\binom{k+1}3\), together with the transversal bound \(N-k\).
This turns the square-restriction gate into a quantitative input for C627
rather than merely naming a degeneracy locus.

The Tao-style stress test separates the real gain from a false conclusion.
The square-root carrier does not say that the roots glue at rich
intersections; their failure to glue is precisely the new invariant.  Thus
the argument cannot be shortened to the incorrect claim that more than
\(k\) maximum centres force \(F_A\) itself to be a square.  What is proved is
that more than \(k\) centres force rich carrier intersections, and that the
full local conductor data cannot vanish everywhere.

## Mystery ledger

| Feature | Disposition |
|:--|:--|
| Does the square-restriction locus merely restate the maximum-matching condition? | **Settled partly:** pointwise it is equivalent to \(r_A(x)=m\), but its canonical roots carry compatibility data discarded by the index distribution. |
| Is there a first rank-three-sensitive local invariant? | **Settled positively:** \(\Omega\) is the first-jet conductor obstruction at three concurrent carrier lines, expressible through the second Hasse coefficient of \(F_A\). |
| Does it produce an inequality independent of raw moments? | **Settled positively:** every arc in \(X_A\) has size at most \(k\), forcing the displayed lower bound on collinear triples and the \(N-k\) transversal bound. |
| Does this alone rule out zero defect? | **Open:** zero defect forces many carrier concurrences, not their absence.  An upper bound or a conic-selected gluing theorem is still missing. |
| What happens at carrier intersections of multiplicity \(s>3\)? | **Structurally located, not expanded:** the obstruction is the finite conductor hierarchy through jet order \(s-2\).  Expanding it without a downstream vanishing mechanism would add algebra but no stronger conclusion. |
| Is a manuscript change justified now? | **No decision requested and none made:** C626 was explicitly restricted to mathematics only. |
