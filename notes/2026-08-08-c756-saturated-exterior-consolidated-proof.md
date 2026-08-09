# C756 — consolidated saturated-exterior classification

**Lane:** clebsch · **Date:** 2026-08-08 · **Scope:** human proof
consolidation and citation installation; no manuscript or Lean edits

## Verdict

The saturated-exterior branch is closed uniformly.

**Theorem.** Let \(q\) be odd, let \(C\) be a nonsingular conic in
\(\mathrm{PG}(2,q)\), and let \(A\) be a set of \((q+1)/2\) exterior points
of \(C\). Suppose every join of two points of \(A\) is a passant of \(C\)
and \(A\) is an arc. Then
\[
 q\in\{3,7,11\}.
\]
For \(q>3\), the examples at \(q=7\) and \(q=11\) each form one orbit under
the stabilizer of \(C\). If the joins of \(A\) must also cover every point
off \(C\), then \(q=3,7\) fail and \(q=11\) is the Clebsch hexagon.

The proof below is finite-computation free. It consolidates the matching,
Segre, local-Paley, Weil, Hasse, endpoint, and covering arguments previously
distributed across four C756 reports. The local-Paley theorem's audited
arithmetic proof is recalled as a lemma and linked to its complete valuation
derivation. The standard inputs are cited at the exact statement used.

This theorem closes only the saturated-exterior branch. It does not close
the saturated-internal or nonsaturated branches of the all-\(k\) problem.

## 1. Conic dictionary and saturation

Identify
\[
 \mathrm{PG}(2,q)=\mathbb P(\operatorname{Sym}^2\mathbb F_q^2)
\]
and let \(C\) be the discriminant-zero conic. An exterior point is a split
binary quadratic and hence an unordered pair \(\{a,b\}\) of distinct points
of \(\mathbf P^1(\mathbb F_q)\). For quadratics with root pairs
\(\{a,b\}\) and \(\{c,d\}\),
\[
 B(f,g)^2-\operatorname{disc}(f)\operatorname{disc}(g)
 =4(a-c)(a-d)(b-c)(b-d)
 =4\operatorname{Res}(f,g).                                      \tag{1}
\]
Thus their join is a passant exactly when
\[
 \chi(\operatorname{Res}(f,g))=-1.                               \tag{2}
\]
In particular, two such root pairs are disjoint. Since \(A\) contains
\((q+1)/2\) points, its root pairs partition the \(q+1\) points of
\(\mathbf P^1(\mathbb F_q)\): they form a perfect matching.

There is also a purely geometric saturation check. An exterior point of
\(C\) lies on \((q-1)/2\) passants. The \((q-1)/2\) joins from a point of
\(A\) to the other points of \(A\) are distinct passants, so they exhaust
that pencil. The remaining
\[
 t=q+2-|A|=(q+3)/2                                                \tag{3}
\]
lines through the point meet \(C\) and are exactly the tangent lines of the
arc at that point.

## 2. Matching normal form and the even-order obstruction

Use the conic stabilizer \(\mathrm{PGL}(2,q)\) to send one matching edge to
\(\{0,\infty\}\). Put
\[
 S=(\mathbb F_q^*)^2,\qquad N=\mathbb F_q^*\setminus S,\qquad
 m=|S|=(q-1)/2.
\]
Equation (2) with the fixed edge shows that every remaining matching edge
has one endpoint in \(S\) and one in \(N\). Write it as
\[
 e_s=\{s,\phi(s)\},\qquad \phi:S\longrightarrow N
\]
for a bijection. The coefficient point of \(e_s\) is
\[
 [1:-(s+\phi(s)):s\phi(s)],
\]
whereas the fixed coefficient point is \([0:1:0]\). Their three-point
determinant is
\[
 s\phi(s)-t\phi(t).
\]
The arc condition therefore makes
\[
 h:S\longrightarrow N,\qquad h(s)=s\phi(s)                       \tag{4}
\]
a bijection.

Choose a primitive element \(g\) and write
\[
 \phi(g^{2i})=g^{2\pi(i)+1}.
\]
Then \(\pi\) and \(i\mapsto i+\pi(i)\) are permutations of
\(\mathbb Z/m\mathbb Z\). Summing the latter permutation gives
\[
 2\sum_i i=\sum_i i\pmod m.
\]
If \(q\equiv1\pmod4\), then \(m\) is even and
\(\sum_i i=m/2\pmod m\), a contradiction. Hence
\[
 q\equiv3\pmod4.                                                  \tag{5}
\]

From now on \(m\) and the tangent degree \(t=m+2\) are odd.

## 3. Segre coherence creates a local Paley automorphism

For an ordered matching edge \(e=(a,b)\) and a coefficient point \(Q\),
let \(f_Q\) denote a representing binary quadratic and define
\[
 T_e(Q)=f_Q(a)f_Q(b)
        \bigl(f_Q(a)^m-f_Q(b)^m\bigr).                            \tag{6}
\]
This homogeneous polynomial has degree \(m+2=t\). Its linear factors are
exactly the lines through the coefficient point \(P_e\) that meet \(C\):
the two conic tangents arise when one evaluation vanishes, and the secants
arise when the quotient of the two nonzero evaluations is a square. These
are precisely the \(t\) tangent lines of the arc at \(P_e\), all simple.
Thus \(T_e\) is a tangent function.

For a second matching edge \(Q\), its resultant with \(e\) is a nonsquare,
so the evaluations at \(a,b\) have opposite character. Euler's criterion
turns (6) into
\[
 T_e(Q)=2\operatorname{Res}(e,Q)\chi(f_Q(a)).                     \tag{7}
\]

We use Segre's lemma of tangents in its scaled planar-arc form:
the tangent functions may be scaled by \(\lambda_e\ne0\) so that
\[
 \lambda_eT_e(P_d)=(-1)^{t+1}\lambda_dT_d(P_e)                    \tag{8}
\]
for distinct arc points. This is Lemma 11 of Ball--Lavrauw,
[*Planar arcs*](https://doi.org/10.1016/j.jcta.2018.06.015).
Here \(t\) is odd, so the sign is positive.

Order the fixed edge as \((0,\infty)\) and \(e_s\) as
\((s,\phi(s))\). With \(h_s=s\phi(s)\in N\), direct evaluation gives
\[
 T_{e_0}(P_{e_s})=T_{e_s}(P_{e_0})=-2h_s\ne0.                    \tag{9}
\]
Equation (8) therefore forces every \(\lambda_{e_s}\) to equal
\(\lambda_{e_0}\). The tangent products themselves are symmetric.
For distinct \(s,t\in S\), comparison in (7) yields
\[
 \chi\bigl((s-\phi(t))(\phi(s)-t)\bigr)=1.                        \tag{10}
\]
The pairwise passant condition says that the product of the expression in
(10) and
\[
 (s-t)(\phi(s)-\phi(t))
\]
is a nonsquare. Consequently
\[
 \chi\bigl((s-t)(\phi(s)-\phi(t))\bigr)=-1.                       \tag{11}
\]

Put \(f=-\phi:S\to S\), using (5). Equation (11) becomes
\[
 \chi\bigl((s-t)(f(s)-f(t))\bigr)=1.                              \tag{12}
\]
Thus \(f\) is an automorphism of the tournament induced on \(S\), the
out-neighbourhood of \(0\) in the Paley tournament \(P(q)\).

## 4. The audited local-Paley rigidity theorem

Write \(q=p^n\). Since \(q\equiv3\pmod4\), both \(p\equiv3\pmod4\) and
\(n\) are odd.

**Local-Paley lemma.**
\[
 \operatorname{Aut}(P(q)[S])
 =
\{s\mapsto cs^{p^j}:c\in S,\ 0\le j<n\}.                        \tag{13}
\]

For \(q=3\), this is the trivial automorphism group of a singleton.  Assume
\(q>3\) for the proof spine. Let \(B\) be convolution on the cyclic
group \(S\) by \(u\mapsto\chi(u-1)\). A local automorphism commutes with
\(B\). For a faithful character \(\rho\) of \(S\), its eigenvalue
\[
 \beta_\rho=\sum_{u\in S}\rho(u)\chi(u-1)
\]
has collision class exactly
\[
 \beta_\sigma=\beta_\rho
 \quad\Longleftrightarrow\quad
 \sigma=\rho^{p^j}\quad(0\le j<n).                               \tag{14}
\]
The proof of (14) writes \(\beta_\rho\) as the sum of two Jacobi sums whose
product is \(-q\), then uses the Stickelberger digit valuation to recover the
half-carry profile
\[
 h(a)=\#\{0\le i<n:[ap^i]_m>m/2\}.
\]
Dyadic iterates recover the base-\(p\) digit weight. The unit test
\((p+1)/2\) shows that the profile stabilizer is exactly
\(\langle p\rangle\); inversion gives the complementary rather than equal
profile. The exact prime choice, the \(p-1\) ramification factor, the
imprimitive case, and nonvanishing were line-audited in
2026-08-08-c756-local-paley-proof-consolidation-and-jacobi-audit.md;
equations (3a)--(3b) of
2026-08-01-c756-primitive-jacobi-collisions.md contain the full valuation
derivation. The standard digit-sum normalization is Theorem 3.4 and
formula (3.2) of Evans--Hollmann--Krattenthaler--Xiang,
[*Gauss sums, Jacobi sums, and \(p\)-ranks of cyclic difference sets*](https://doi.org/10.1006/JCTA.1998.2950).

It remains only a flatness argument. Commutation and (14) give
\[
 P_f\rho=\sum_{j=0}^{n-1}a_j\rho^{p^j}.                           \tag{15}
\]
The left side has pointwise modulus one. The exponents \(p^j\) are Sidon
modulo \(m\): their ordered differences have absolute value less than \(m\),
and equality of two such integer differences is resolved by its \(p\)-adic
valuation and quotient. Every nontrivial Fourier coefficient of the square
of the modulus in (15) is therefore one product
\(a_i\overline{a_j}\). Flatness makes all such products zero, so one
coefficient survives. Faithfulness of \(\rho\) gives (13).

The reverse inclusion in (13) is immediate. In particular, (12) has the
form
\[
 f(s)=cs^r,\qquad c\in S,\quad r=p^j.                             \tag{16}
\]

## 5. The mixed condition removes nontrivial Frobenius

Condition (4) says that \(s\mapsto sf(s)\) permutes \(S\), so
\[
 \gcd(r+1,m)=1.                                                   \tag{17}
\]
Since \(\phi=-f\), equation (10), after putting \(s=xt\), becomes
\[
 \chi\bigl((x+d)(1+dx^r)\bigr)=-1
 \quad(d\in cH),\qquad H=S^{r-1},                                \tag{18}
\]
for each \(x\in S\setminus\{1\}\). The two roots in \(d\) are
\(-x\) and \(-x^{-r}\). They are distinct by (17), and both lie in \(N\),
whereas \(cH\subseteq S\). Hence the sum of the left side over \(cH\) is
exactly \(-|H|\).

Expand the indicator of \(cH\) using the multiplicative characters trivial
on \(H\). The trivial term has absolute value at most \(2\). Every other
term has three distinct support points and is bounded by \(2\sqrt q\) by
the standard multiplicative Weil bound, in the form of Lidl--Niederreiter,
[*Finite Fields*, 2nd ed., Theorem 5.41](https://doi.org/10.1017/CBO9780511525926).
After averaging,
\[
 |H|\le2\sqrt q.                                                  \tag{19}
\]

Suppose \(j>0\). Put \(g=\gcd(n,j)\), \(Q=p^g\), and \(L=n/g\).
Then \(L\ge3\) is odd and
\[
 \gcd(p^j-1,q-1)=Q-1.
\]
Because \(m\) is odd,
\[
 |H|
 =\frac{m}{\gcd(p^j-1,m)}
 \ge\frac{q-1}{Q-1}
 =1+Q+\cdots+Q^{L-1}
 >2Q^{L/2}=2\sqrt q,
\]
contradicting (19). Thus \(j=0\), and
\[
 \phi(s)=\nu s\qquad(\nu=-c\in N).                               \tag{20}
\]

## 6. Scalar Hasse endgame

Condition (10) for (20), divided by one square endpoint, is
\[
 \chi\bigl((x-\nu)(\nu x-1)\bigr)=1
 \quad(x\in S\setminus\{1\}).                                    \tag{21}
\]
For \(q>3\), \(\nu=-1\) is impossible because the left side is
\(\chi(-(x+1)^2)=-1\). Put
\[
 P(x)=(x-\nu)(\nu x-1),\qquad
 B_\nu=\sum_{x\in\mathbb F_q}\chi(xP(x)).
\]
The separable quadratic \(P\) has nonsquare leading coefficient, and the
standard quadratic-character evaluation gives
\[
 \sum_{x\in\mathbb F_q^*}\chi(P(x))=2.
\]
Using \((1+\chi(x))/2\) as the indicator of \(S\), and noting that the
\(x=1\) term is \(-1\), equation (21) gives
\[
 B_\nu=q-7.                                                      \tag{22}
\]
The cubic curve
\[
 y^2=x(x-\nu)(\nu x-1)
\]
is nonsingular. Hasse's estimate
\(|\#E(\mathbb F_q)-(q+1)|\le2\sqrt q\) therefore gives
\[
 q-7=|B_\nu|\le2\sqrt q.                                         \tag{23}
\]
For the historical theorem see Hasse,
[*Zur Theorie der abstrakten elliptischen Funktionenkörper III*](https://doi.org/10.1515/crll.1936.175.55).
Equation (23), together with \(q\equiv3\pmod4\), leaves
\[
 q\in\{3,7,11\}.
\]

## 7. Endpoints, orbits, and covering

The case \(q=3\) is the unique perfect matching containing
\(\{0,\infty\}\), up to the conic stabilizer. It gives a two-point arc.
For the other two fields, direct substitution in (21) gives
\[
\begin{array}{c|c}
q&\text{admissible nonsquares }\nu\\ \hline
7&3,5\\
11&2,6.
\end{array}
\]
The conic-stabilizer map \(x\mapsto x^{-1}\) fixes
\(\{0,\infty\}\) and sends \(\nu\) to \(\nu^{-1}\). It interchanges \(3,5\)
over \(\mathbb F_7\) and \(2,6\) over \(\mathbb F_{11}\). Hence each row is
one orbit. These scalar sets really are arcs: their nonfixed coefficient
points lie on
\[
 AC=\frac{\nu}{(1+\nu)^2}B^2,
\]
and their constant coefficients \(\nu s^2\) are distinct; the fixed point
\([0:1:0]\) introduces no collinearity.

It remains to impose covering. The all-\(k\) covering inequality
\[
 q^2\le k+
 \bigl[\tbinom{k}{2}(q+1)-k(k-1)\bigr]
 -\frac{6\binom{k}{4}}{\lfloor k/2\rfloor}                       \tag{24}
\]
is an elementary two-moment count of chord degrees. At \((q,k)=(3,2)\),
its right side is \(4<9\); at \((7,4)\), it is \(37<49\). Thus neither
endpoint covers every point off \(C\). At \(q=11\), the scalar hexagon with
\(\nu=2\) has the explicit coefficient set
\[
 \{[0:1:0]\}\cup
 \{[1:-3s:2s^2]:s\in\{1,3,4,5,9\}\}.                             \tag{25}
\]
Substitution in its fifteen chord equations gives
\[
 \bigcup_{\substack{P,P'\in A\\P\ne P'}}PP'
 =\{[A:B:C]:B^2-4AC\ne0\}.
\]
Thus (25) is the Clebsch hexagon and covers every point off \(C\);
inversion gives the same orbit for \(\nu=6\).

This proves the theorem.

## 8. Trust boundary and publication use

The proof uses no finite classification. The endpoint substitutions and the
explicit \(q=11\) chord-union identity are bounded field arithmetic, not a
search or an all-\(q\) premise. The load-bearing external inputs and exact
locators are:

| input | exact source |
|---|---|
| scaled Segre lemma of tangents | Ball--Lavrauw, Lemma 11, [DOI 10.1016/j.jcta.2018.06.015](https://doi.org/10.1016/j.jcta.2018.06.015) |
| Stickelberger digit valuation | Evans--Hollmann--Krattenthaler--Xiang, Theorem 3.4 and (3.2), [DOI 10.1006/JCTA.1998.2950](https://doi.org/10.1006/JCTA.1998.2950) |
| three-support multiplicative Weil bound | Lidl--Niederreiter, Theorem 5.41, [book DOI](https://doi.org/10.1017/CBO9780511525926) |
| elliptic Hasse bound | Hasse, [DOI 10.1515/crll.1936.175.55](https://doi.org/10.1515/crll.1936.175.55) |

The local-Paley theorem is the candidate standalone novelty. The 2025/2026
Javier--Llano--Zuazua paper already proves the prime-field multiplicative
circulant model, but the focused audit found no statement of the exact local
automorphism group or unique extension theorem. Those claims must retain
“to our knowledge” until a human MathSciNet/Scopus search closes the remaining
coverage gap. Normality, the prime-field directed-regular-representation
statement, and the flat-Sidon lemma should be presented as corollary,
corollary, and proof device respectively, not as separate novelty claims.

## 9. Referee checklist

| seam | result |
|---|---|
| exterior-point count really gives a perfect root matching | pass: disjointness from the nonzero resultant plus \(2|A|=q+1\) |
| saturation identifies every tangent line used by Segre | pass: the joins exhaust the passant pencil |
| tangent-product degree and signs | pass: degree \(m+2\), odd \(t\), fixed-edge evaluations pin all scales |
| \(q\equiv1\pmod4\) | pass: complete-mapping sum obstruction |
| local-Paley classification | pass after the separate primitive-Jacobi line audit and normalization repair |
| nontrivial Frobenius branches | pass: coset Weil upper bound contradicts the elementary subgroup lower bound |
| scalar field bound | pass: nonsingular cubic and Hasse |
| \(q=3\) | explicit, outside the \(n\ne-1\) scalar calculation |
| endpoint existence and orbit uniqueness | explicit scalar substitution plus inversion |
| covering distinction | explicit inequality at \(q=3,7\); Clebsch at \(q=11\) |

No manuscript files were edited.
