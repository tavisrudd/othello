# C756 EJ3: elliptic overlap squeeze for covariance descent

**Lane:** `clebsch` · **Date:** 2026-08-09 · **Scope:** nonsaturated
rank-two covariance/conic comparison; no manuscript edit

## Verdict

The covariance square condition on the 16 complete centers can be compared
exactly with the fixed-conic internal half of the distinguished passant.
Unless the anisotropic covariance form is proportional to the conic
restriction, the product of the two binary quadratics defines an elliptic
double cover of the direction line.  Hasse's bound at \(q=53\) leaves only a
short list of traces.

The resulting arrangement-direction constraint is strong:

- for nonaligned anisotropic covariance, at least 10 of the 11 arrangement
  directions have nonsquare covariance value;
- for split covariance, at least 9 of the 11 arrangement directions have
  nonsquare covariance value; and
- the only branch escaping this skew is covariance proportional to the
  anisotropic conic restriction.

Writing \(B_{ij}=\tfrac12a_i^{\mathsf T}Ma_j\) for the rank-two residual
covariance Gram matrix of the eleven arrangement directions, these are
statements about its diagonal.  They connect, up to the fixed factor 2, to
the off-diagonal entries used by the EJ2 partition function through
\[
 B_{ii}B_{jj}-B_{ij}^2
 =\det(M/2)(a_i\wedge a_j)^2.                             \tag{1}
\]
Thus every nonzero two-by-two principal minor has the same square class.
The remaining gate is a bounded rank-two Gram classification with a highly
skew diagonal character pattern, not a free comparison of two half-sets.

## 1. The two quadratic half-sets

Let \(r_0\cong\mathbf P^1(\mathbf F_{53})\) be the distinguished passant.
Choose the scale of the fixed-conic restriction \(C\) so that
\[
 \chi(C(L))=+1
 \quad\Longleftrightarrow\quad
 L\text{ is internal}.                                    \tag{2}
\]
Because \(r_0\) is passant, \(C\) is anisotropic.  It has no rational zero,
and each sign in (2) occurs 27 times.

Let
\[
 K(L)=\tfrac12 z_L^{\mathsf T}Mz_L                       \tag{3}
\]
be the covariance quadratic on directions.  The antipodal-fibre identity
says
\[
 K(L)=u_L^2                                                \tag{4}
\]
at every one of the 16 complete internal centers.  Hence those centers lie
in the favorable set
\[
 \mathcal F={L:\chi(C(L))=+1,
                    \ K(L)=0\text{ or }\chi(K(L))=+1\}.   \tag{5}
\]
The 27 internal directions are the disjoint union of these 16 centers and
the 11 arrangement directions.

Put
\[
 S(C,K)=\sum_{L\in\mathbf P^1(\mathbf F_{53})}
          \chi(C(L)K(L)).                                 \tag{6}
\]
When \(C\) and \(K\) have no common geometric root, the smooth double cover
\[
 E_{C,K}:W^2=C K                                           \tag{7}
\]
has genus one and
\[
 \#E_{C,K}(\mathbf F_{53})=54+S(C,K).
\]
Therefore
\[
 |S(C,K)|\le\lfloor2\sqrt{53}\rfloor=14.                 \tag{8}
\]

## 2. Anisotropic covariance

First suppose \(K\) is anisotropic.  If it is not proportional to \(C\),
the four geometric roots of \(CK\) are distinct, so (8) applies.  Let
\[
 I=\#\{L:\chi(C(L))=chi(K(L))=+1\}.
\]
Both quadratics have 27 values of each sign and no zero.  Expanding the two
indicators gives
\[
 I=\frac{54+S(C,K)}4.                                     \tag{9}
\]
All 16 complete centers are counted by \(I\), so \(I\ge16\).  Integrality
in (9) and (8) leave exactly
\[
 \begin{array}{c|c|c|c}
 S(C,K)&10&14\\ \hline
 I&16&17\\
 \operatorname{tr}(E_{C,K})&-10&-14
 \end{array}                                               \tag{10}
\]
where the trace uses \(\#E=54-\operatorname{tr}(E)\).

Consequently only \(I-16\in\{0,1\}\) arrangement directions can have
square covariance value.  At least ten of their eleven values are
nonsquares.

If \(K\) is proportional to \(C\), the cover (7) degenerates and every
internal direction is favorable.  This **aligned anisotropic branch** must be
retained separately; Hasse does not constrain it.

## 3. Split covariance

Now suppose \(K\) is split, with two rational zero directions.  Let
\[
 T_0=\sum_{K(L)=0}\chi(C(L))\in\{-2,0,2\},                \tag{11}
\]
so the number of internal zeros of \(K\) is \((2+T_0)/2\).
Let \(J=|\mathcal F|\) be the total number of favorable internal directions,
including the zeros.  Indicator expansion away from the two zeros gives
\[
 J=\frac{56+T_0+S(C,K)}4.                                 \tag{12}
\]
The forms have no common root because \(C\) is anisotropic, so (8) applies.
Since \(J\ge16\), the complete list is
\[
\begin{array}{c|c|c}
T_0&S(C,K)&J\\ \hline
-2&10,14&16,17\\
0&8,12&16,17\\
2&6,10,14&16,17,18
\end{array}.                                               \tag{13}
\]
Thus at most \(J-16\le2\) arrangement directions are favorable, and at
least nine of the eleven have nonsquare covariance value.  The internal
zeros among the complete centers are precisely the at most two triple
fibres found in the EJ pass.

## 4. Rank-two Gram bridge

Let \(a_i\) be the two-component linear coefficient vector of the centered
line equation \(\ell_i\), and define
\[
 B_{ij}=\tfrac12a_i^{\mathsf T}Ma_j.                      \tag{14}
\]
The direction of \(r_i\) is the arrangement point \(N_{0i}\in r_0\), and,
up to the square change caused by rescaling a direction representative,
\[
 K(N_{0i})\sim B_{ii}.                                    \tag{15}
\]
Hence the conclusions of §2--3 are diagonal sign constraints on \(B\).

For distinct arrangement directions, \(a_i\wedge a_j\ne0\).  Taking the
determinant of the two-vector Gram matrix gives (1), and therefore
\[
 \chi(B_{ii}B_{jj}-B_{ij}^2)=\chi(\det(M/2))             \tag{16}
\]
for every \(i\ne j\).  Since \(-1\) is a square in \(\mathbf F_{53}\),
\(\det M\) is a square in the split case and a nonsquare in the anisotropic
case.

The EJ2 partition function \(\mathcal Z\) uses twice the off-diagonal
\(B_{ij}\) in its matching expansion.  This fixed scaling is explicit and
does not change any rank or square-class statement.  Equations (15)--(16)
are the missing bridge from the elliptic diagonal squeeze to that critical
system.  They also retain the rank-two condition: every three-by-three minor
of \(B\) vanishes.

## 5. Exact remaining cases

The covariance/conic descent has reduced to three bounded branches:

1. **aligned anisotropic:** \(K\sim C\) on \(r_0\);
2. **nonaligned anisotropic:** elliptic trace \(-10\) or \(-14\), with at
   least ten nonsquare diagonal entries \(B_{ii}\);
3. **split:** one of the seven rows in (13), with at least nine nonsquare
   diagonal entries.

In every branch, impose simultaneously
\[
 \operatorname{rank}B=2,
 \quad
 \nabla\mathcal Z(c)=0,
 \quad
 \partial_i\partial_j\mathcal Z(c)\ne0,
 \quad
 \text{and (16)}.                                         \tag{17}
\]
The fixed-conic internality of the 55 star nodes supplies the analogous
conic Gram-minor signs and should be compared with (16).

The exceptional aligned branch is the cheapest next case: covariance and
the conic restriction share their torus, so the two descent involutions in
EJ2 coincide.  If even that branch cannot satisfy (17), the remaining two
branches have only the trace/sign patterns listed above.

## Stop and acceptance conditions

Do not apply a generic quartic character bound again; (10) and (13) are its
complete output.  Continue only by inserting the diagonal patterns and
rank-two minor identity (16) into the critical system, beginning with
\(K\sim C\).  Stop if the calculation forgets either the nonzero separator
Hessian or the internal-node conic Gram signs.

## Mystery ledger

| feature | status | exact remaining boundary |
|---|---|---|
| Overlap of conic and covariance half-sets | sharply bounded | equations (10) and (13) |
| Nonaligned anisotropic traces | finite | \(-10,-14\) |
| Split traces/sign rows | finite | seven cases in (13) |
| Arrangement covariance signs | forced skew | at least 10 nonsquares anisotropic, at least 9 split |
| Escape from Hasse | isolated | aligned anisotropic \(K\sim C\) |
| Bridge to \(\mathcal Z\) | settled | diagonal values plus constant minor class (16) |
| Full contradiction | open | solve the three bounded branches with conic node signs |

## Next action

Take the aligned anisotropic branch \(K\sim C\).  Identify the covariance
torus coordinates with the conic-restriction torus in the EJ2 constant-term
formula, insert the passant equations for the eleven \(r_i\), and test
whether \(\nabla\mathcal Z=0\) is compatible with all separator Hessians
nonzero.  Only then move to the trace \(-10,-14\) and split tables.
