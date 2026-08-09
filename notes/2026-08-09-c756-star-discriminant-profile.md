# C756 star discriminant and forced line profile

## Verdict

The dual star-blocking gate has two exact algebraic/combinatorial forms.  If
the pairwise-intersection set \(\mathcal B\) blocks every non-tangent line,
then:

1. the discriminant of the line-arrangement polynomial restricted to a test
   line vanishes at exactly the non-tangent lines; and
2. the non-arrangement lines through \(\mathcal B\) have a forced first and
   second incidence profile.

The second form already gives a new proof that the saturated-internal branch
cannot cover at \(q=7\).  It also shows exactly why the same two-moment
argument stops at \(q\ge9\).

Throughout, put
\[
 q=2m-1,\qquad n=m+1,\qquad b=\binom n2=\frac{m(m+1)}2,
\]
and let \(L_1,\dots,L_n\) be the passant lines dual to a saturated-internal
arc.  Their pairwise intersections form \(\mathcal B\).

## 1. The restriction discriminant

Write \(F=\prod_i L_i\).  Restrict the linear forms \(L_i\) to a variable
test line \(M\cong\mathbf P^1\).  For \(M\ne L_i\), the binary form
\(F|_M\) has a repeated root exactly when \(M\) contains a point
\(L_i\cap L_j\) of \(\mathcal B\).  More precisely,
\[
 \operatorname{Disc}(F|_M)
   =c\prod_{i<j}\operatorname{Res}(L_i|_M,L_j|_M)^2
   =c'\prod_{B\in\mathcal B}M(B)^2. \tag{1}
\]
Here \(M(B)\) is the incidence bracket, viewed as a linear form in the dual
coordinates of \(M\).  Formula (1) extends polynomially across the
arrangement lines.

Consequently, with
\[
 D_Y(M)=\prod_{B\in\mathcal B}M(B), \tag{2}
\]
covering is equivalent to
\[
 D_Y(M)\ne0\quad\Longleftrightarrow\quad M\text{ is tangent to }C
 \qquad(M\in\mathrm{PG}(2,q)). \tag{3}
\]
Thus \(D_Y\), a completely split degree-\(b\) form, would be a projective
finite-field indicator of the dual conic, and the restriction discriminant
would be its square.  This is a precise polynomial target; it is stronger
than merely saying that \(\mathcal B\) is a relative blocking set.

## 2. Matching cap on a test line

Label a vertex \(L_i\cap L_j\) by the edge \(ij\) of \(K_n\).  If a line
\(M\) other than the arrangement lines contains two vertices whose labels
share \(i\), then \(M=L_i\).  Hence the labels of the vertices on any
non-arrangement line form a matching.  In particular,
\[
 |M\cap\mathcal B|\le \left\lfloor\frac{m+1}{2}\right\rfloor. \tag{4}
\]

Assume now that \(\mathcal B\) blocks every non-tangent line.  Remove the
\(q+1=2m\) tangents and the \(n=m+1\) arrangement lines.  For the remaining
lines let \(a_j\) count those containing exactly \(j\) vertices of
\(\mathcal B\).  Then every remaining line is occupied, and double-counting
vertices and vertex pairs gives
\[
 \begin{aligned}
 \sum_{j\ge1}a_j&=m(4m-5),\\
 \sum_{j\ge1}j a_j&=m(m+1)(m-1),\\
 \sum_{j\ge1}\binom j2a_j&=
   \frac{m(m+1)(m-1)(m-2)}8. \tag{5}
 \end{aligned}
\]
The subtraction in the last line is exact: pairs lying on an arrangement
line are precisely the pairs of adjacent edges of \(K_n\); every other pair
is a pair of disjoint edges and lies on one remaining line.

Combining (5) yields the useful slack identity
\[
 \boxed{\quad
 \sum_{j\ge1}(j-1)(j-2)a_j
   =\frac{m(m-2)(m-3)(m-5)}4.
 \quad} \tag{6}
\]

## 3. The \(q=7\) exclusion

For \(q=7\), one has \(m=4\).  The left side of (6) is nonnegative for
every positive integer \(j\), whereas the right side is \(-2\).  This is a
contradiction.

> **Proposition 26.**  A saturated-internal conic-external arc over
> \(\mathbb F_7\) cannot be conic-filling.

This proof uses only polarity, the star configuration, and the fact that
only tangents may avoid \(\mathcal B\); it does not enumerate arcs or invoke
the signed spectral machinery.

At \(m=3\) (the \(q=5\) frame), (6) is zero and (4) forces the ordinary
profile \(a_1=18,a_2=3\), consistent with existence.  At \(m=5\)
(\(q=9\)), (6) is again zero, so covering would force every ordinary line to
contain at most two star vertices and the unique numerical profile is
\(a_1=30,a_2=45\).  For \(m>5\), the right side is positive.  Therefore
first and second moments alone cannot settle the general branch.

## EJ + TT closeout

**EJ.**  The discriminant in (1) is not an analogy: it is exactly the square
of the chord-cover product after polarity.  This provides a direct interface
to finite-field indicator polynomials and projective Reed--Muller bounds.

**TT.**  The moment identity is genuinely useful only at \(q=7\).  For
\(q\ge9\) it supplies constraints, not a contradiction.  Continuing to add
generic moments would require uncontrolled counts of collinear triples of
star vertices.  The next pass should split (5) by secant/passant type, where
quadratic character supplies additional exact information, or exploit the
completely split indicator (2)--(3).

## Mystery ledger

| feature | status | exact remaining boundary |
|---|---|---|
| Is there a polynomial carrier for covering? | settled | the restriction discriminant is \(cD_Y^2\), and \(D_Y\) is supported pointwise on the dual conic |
| How many star vertices can a non-arrangement line contain? | settled | at most \(\lfloor(m+1)/2\rfloor\), with labels forming a matching |
| Can elementary moments exclude \(q=7\)? | settled positive | identity (6) has negative right side at \(m=4\) |
| Can the same two moments finish all \(q\)? | settled negative | the slack is nonnegative for \(m=3\) and every \(m\ge5\) |
| What happens at \(q=9\)? | sharpened open | covering forces exactly 30 one-vertex and 45 two-vertex ordinary lines |
| Highest-EV continuation | open | split the forced profile by secant/passant type, beginning with the rigid \(q=9\) boundary case |

## Next action

Derive the secant/passant-refined analogues of (5).  At \(q=9\), test
whether the forced \((a_1,a_2)=(30,45)\) profile is compatible with all star
vertices being internal and all arrangement lines passant.  Use an exact
finite-field certificate if a small-case search is needed; stop if the type
split introduces an unconstrained mixed character sum of the original
degree.
