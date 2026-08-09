# C756 TT compression: star-center moment collapse

**Lane:** `clebsch` · **Date:** 2026-08-09 · **Scope:** nonsaturated
defect-two star-center gate; no manuscript edit

## Verdict

The 16 required direction-complete centers at \((q,k)=(53,12)\) can be
coupled before any high-degree interpolation.  For the 55 affine nodes of
the 11-line star, the elementary symmetric coefficient \(e_j(t)\) of the
projection multiset has degree at most \(j\) in the direction parameter.
Every complete center forces
\[
 e_j(t)=0\qquad(3\le j\le51).
\]
Since there are 16 such centers, it follows identically that
\[
 \boxed{e_3(t)=e_4(t)=\cdots=e_{15}(t)=0.}                 \tag{1}
\]

After translating the centroid of the 55 nodes to the origin, Newton's
identities turn (1) into a two-point moment collapse: every linear projection
has vanishing odd moments through degree 15, and its even moments through
degree 14 are the moments of a formal antipodal pair.

The star configuration has degree-10 ideal generators and degree-9
single-node separators, entirely below the degree-15 window.  Pairing those
forms with the collapsed moment functional closes the two singular covariance
cases: covariance rank zero and rank one are both impossible.  Only
nonsingular covariance remains.  This escapes the closed untyped-moment route
because the common-line factorization enters at degrees 9 and 10.

## 1. Simultaneous projection polynomial

Use the notation of the star-center report.  Take \(r_0\) as the line at
infinity and write the 55 nodes of
\[
 S_0=\{r_i\cap r_j:1\le i<j\le11\}
\]
as affine points \(v=(x_v,y_v)\).  Choose the projective coordinate on
\(r_0\) so that none of the 16 required internal centers is its point at
infinity.  For a direction parameter \(t\), the parallel-line coordinate of
\(v\) is
\[
 c_v(t)=y_v-tx_v.                                          \tag{2}
\]
Define
\[
 H(t,C)=\prod_{v\in S_0}(C-c_v(t))
       =\sum_{j=0}^{55}(-1)^j e_j(t)C^{55-j}.              \tag{3}
\]
Because every factor in \(e_j\) is affine-linear in \(t\),
\[
 \deg_t e_j\le j.                                         \tag{4}
\]

If \(t\) is direction-complete, its 55 projected values contain every
element of \(\mathbf F_{53}\), with two excess occurrences.  Hence
\[
 H(t,C)=(C^{53}-C)(C^2+a_tC+b_t)                           \tag{5}
\]
for some \(a_t,b_t\in\mathbf F_{53}\).  Expanding (5) shows
\[
 e_j(t)=0\qquad(3\le j\le51).                              \tag{6}
\]
The 16 internal nonnodes on \(r_0\) are all direction-complete.  For
\(3\le j\le15\), equations (4) and (6) give more distinct roots than the
degree, proving (1).  At \(j=16\) the root count is no longer strict; the
coefficient may be a scalar multiple of the degree-16 center mask.  Thus
degree 15 is the exact free interpolation range.

## 2. Antipodal moment form

Translate the affine plane so that
\[
 \sum_{v\in S_0}v=0.                                      \tag{7}
\]
This is legitimate because \(|S_0|=55=2\ne0\) in
\(\mathbf F_{53}\).  Translation preserves direction completeness and the
star realization.  For a linear form \(z\), put
\[
 p_j(z)=\sum_{v\in S_0}z(v)^j.
\]
Equation (7) gives \(e_1(z)=p_1(z)=0\), while (1), by polarization in the
direction parameter, gives \(e_j(z)=0\) for \(3\le j\le15\).  Newton's
identities therefore reduce to
\[
 p_j(z)+e_2(z)p_{j-2}(z)=0\qquad(3\le j\le15),             \tag{8}
\]
with \(p_2(z)=-2e_2(z)\).  Consequently
\[
 \boxed{
 \begin{aligned}
 p_{2r+1}(z)&=0 &&(0\le r\le7),\\
 p_{2r}(z)&=2^{1-r}p_2(z)^r &&(1\le r\le7).
 \end{aligned}}                                           \tag{9}
\]

For each projection, (9) is exactly the moment sequence of two formal
values \(\{u,-u\}\).  Equivalently, if
\[
 M=sum_{v\in S_0}v,v^{\mathsf T},                        \tag{10}
\]
then polarization of (9) determines every moment tensor
\(\sum_v v^{\otimes d}\) for \(d\le15\) from the single quadratic tensor
\(M\): odd tensors vanish, and the even tensor of order \(2r\) is the
polarization of \(2^{1-r}(z^{\mathsf T}Mz)^r\).

This is a bounded identity.  It arose from coupling the 16 centers before
interpolation, not from evaluating one fibre at a time.

## 3. The star ideal lies inside the moment window

Let \(\ell_i=0\) be an affine equation for \(r_i\), \(1\le i\le11\), and
put
\[
 F=\prod_{i=1}^{11}\ell_i,
 \qquad
 G_i=F/\ell_i=\prod_{j\ne i}\ell_j.                       \tag{11}
\]
Each \(G_i\) has degree 10 and vanishes at every node of \(S_0\).  These are
the standard generators of the reduced 11-line star ideal.  Therefore
\[
 \sum_{v\in S_0}G_i(v)=0qquad(1\le i\le11).              \tag{12}
\]

Normally (12) is tautological.  Under (9), however, the sum of every
homogeneous component of \(G_i\) of degree at most 10 is an explicit
contraction of that component with a power of \(M\); all odd components
vanish.  Thus (12) becomes eleven scalar equations involving only

- the centered affine equations of the eleven arrangement lines; and
- the three entries of the covariance tensor \(M\).

No coefficient beyond the forced degree-15 window appears.  The conic data
can then be inserted through the conditions that the \(r_i\) are passants
and their 55 intersections are internal.

This is the first live calculation in the defect-two route that is both
bounded and star-specific.  Merely restating (12) without eliminating the
node sums via (9) would add nothing.

## 4. Degree-nine separators close singular covariance

For a node \(N_{ab}=r_a\cap r_b\), define
\[
 h_{ab}=\prod_{i\notin\{a,b\}}\ell_i.                     \tag{13}
\]
This has degree 9.  Since no three arrangement lines are concurrent,
\[
 h_{ab}(N_{ab})\ne0,
 \qquad
 h_{ab}(N_{cd})=0\quad\text{for }\{c,d\}\ne\{a,b\}.      \tag{14}
\]
Thus \(h_{ab}\) is a separator for one star node within the available
moment degree.

Let
\[
 \Lambda(f)=\sum_{v\in S_0}f(v).                          \tag{15}
\]

### Rank zero

If \(M=0\), equations (9) and polarization give
\[
 \Lambda(f)=2f(0)                                         \tag{16}
\]
for every polynomial of degree at most 15; the scalar is
\(|S_0|=55=2\) in \(\mathbf F_{53}\).  Applying (16) to every degree-10
generator \(G_i\) gives \(G_i(0)=0\).  The common zero locus of the
\(G_i\) is exactly the star nodes, so the centroid \(0\) must equal some
node \(N_{cd}\).

Choose a different node \(N_{ab}\).  Then (14) gives
\(h_{ab}(0)=0\), whereas
\[
 \Lambda(h_{ab})=h_{ab}(N_{ab})\ne0,
\]
contradicting (16).  Hence
\[
 \operatorname{rank}M\ne0.                                \tag{17}
\]

### Rank one

Suppose \(M\) has rank one.  Over the algebraic closure choose \(w\ne0\)
with
\[
 M=2ww^{\mathsf T}.
\]
Equations (9), including the constant moment \(55=2\), then say
\[
 \Lambda(f)=f(w)+f(-w)                                    \tag{18}
\]
for every polynomial \(f\) of degree at most 15.

Fix a node \(N=N_{ab}\), put \(h=h_{ab}\), and let \(L\) be any polynomial
of degree at most 6.  By (14) and (18),
\[
 h(N)L(N)=h(w)L(w)+h(-w)L(-w).                            \tag{19}
\]
Take an affine linear form \(u\) with \(u(w)=1\) and
\(u(-w)=-1\).  Applying (19) to \(L=1,u,u^2\) shows first that
\(u(N)^2=1\), and then that one of the two weights \(h(w),h(-w)\) is zero.
Using all affine linear \(L\) in (19) now forces
\[
 N=w\quad\text{or}\quad N=-w.                             \tag{20}
\]
The argument applies to every one of the 55 distinct nodes, which cannot all
belong to the two-point set \(\{w,-w\}\).  Therefore
\[
 \boxed{\operatorname{rank}M=2.}                           \tag{21}
\]

This is a genuine geometric consequence of the star separators; an
arbitrary \(q+2\)-point near-transversal has no degree-9 family (13).

## 5. Stop and acceptance conditions

The next pass should normalize the now nonsingular binary quadratic \(M\)
and explicitly contract the degree-10 forms \(G_i\) using (9).  The desired
outcomes, in order, are:

1. a contradiction with the passant/internal discriminant conditions;
2. a forced singular covariance, contradicting (21); or
3. a smaller algebraic classification of the eleven line equations modulo
   the orthogonal group of \(M\).

Stop this route if the eleven contracted equations are formal consequences
of the centroid and pair budget, or if eliminating \(M\) restores degree
\(\Theta(q)\).  Do not continue by computing \(e_{16}\) or higher
coefficients: degree 16 is exactly where the unknown center mask reappears.

## Mystery ledger

| feature | status | exact remaining boundary |
|---|---|---|
| Can the 16 centers be coupled at bounded degree? | settled positive | coefficient-root argument (1) |
| Exact free range | settled | \(e_3,\ldots,e_{15}\); degree 16 is masked |
| Moment interpretation | settled | antipodal identities (9) |
| Does this use the star realization? | yes | degree-9 separators and degree-10 generators |
| Singular covariance | settled negative | separator arguments (16)--(21) |
| Is there already a full contradiction? | no | nonsingular covariance remains |
| What would kill the route? | explicit | contractions reduce to centroid/pair budget or regain degree \(\Theta(q)\) |

## Next action

Normalize the nonsingular covariance form \(M\), write the centered
homogeneous decomposition of the eleven forms \(G_i\), and replace each
degree-\(d\le10\) node sum by its tensor value from (9).  Test whether the
resulting contractions force \(M\) singular or conflict with the
passant/internal discriminants.
