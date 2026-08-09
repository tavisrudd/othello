# C756 pair-coupled diagonal count: exact expansion and stop verdict

**Lane:** `clebsch` · **Date:** 2026-08-09 · **Scope:** nonsaturated
masked-Rédei discriminator; no manuscript edit

## Verdict

Summing the fibre excess over every spare passant through one deleted arc
point does produce an exact pair-coupled identity.  Its first term is the
masked count of the three diagonal points of every four-subset.  However,
inclusion--exclusion necessarily adds concurrent perfect matchings on six,
eight, and more points, and conic externality does not evaluate even the
four-point mask.

Two explicit five-point conic-external arcs over \(\mathbf F_{13}\) give
opposite extreme answers: for one, all three diagonal joins to the fifth
point are passants; for the other, all three are secants.  Thus there is no
local character law to insert into the excess identity.  Without a new
global relation, the identity only reallocates the already known fibre
collisions and meets the card's declared stop rule.

## 1. Exact excess expansion

Let \(A\) be a hypothetical nonsaturated conic-filling arc, fix \(P\in A\),
put \(B=A\setminus\{P\}\), and write
\[
 \binom{|B|}{2}=q+\delta.
\]
Let \(\Omega_P\) be the set of spare passant lines through \(P\), including
the chosen line at infinity, and put \(s=|\Omega_P|\).  For
\(X\in\ell\setminus\{P\}\), let \(\mu_X\) be the number of \(B\)-chords
through \(X\).  Covering gives \(\mu_X\ge1\) and
\[
 \sum_{X\in\ell\setminus\{P\}}(\mu_X-1)=\delta
 \qquad(\ell\in\Omega_P).                                      \tag{1}
\]
Hence the simultaneous excess is \(s\delta\).

Distinct \(B\)-chords through one point have disjoint endpoints: two sharing
an endpoint would be the same projective line.  Therefore the \(\mu_X\)
chords form a matching.  Define \(D_j(P)\) to count pairs \((X,M)\), where

- \(X\) lies on a spare passant through \(P\); and
- \(M\) is a \(j\)-element matching of \(B\)-chords concurrent at \(X\).

The binomial identity
\[
 r-1=\sum_{j=2}^{r}(-1)^j\binom rj
\]
then gives the exact expansion
\[
 \boxed{\qquad s\delta=\sum_{j\ge2}(-1)^jD_j(P).\qquad}          \tag{2}
\]

The term \(D_2(P)\) is precisely the proposed diagonal statistic.  Choose a
four-subset of \(B\) and one of its three partitions into two pairs.  The two
opposite chords meet at the corresponding diagonal point \(X\), and the term
is counted exactly when \(PX\) is a spare passant.  Thus
\[
 D_2(P)=
 \sum_{C\in\binom B4}\ \sum_{X\in\operatorname{Diag}(C)}
 \mathbf1_{\{PX\text{ is a spare passant}\}}.                  \tag{3}
\]

The next correction \(D_3(P)\) counts concurrent perfect matchings on
six-subsets.  More generally, \(D_j(P)\) lives on \(2j\) endpoints.  Since
(1) implies \(\mu_X\le\delta+1\), the expansion stops at
\(j=\delta+1\), but its order grows with the defect.  At the first open
defect \(\delta=2\), it is already
\[
 2s=D_2(P)-D_3(P).                                               \tag{4}
\]
Equation (4) distinguishes the two possible fibre profiles---two double
collisions or one triple collision---but does not forbid either.

## 2. Conic externality does not evaluate the diagonal mask

Take the conic
\[
 \mathcal C:\ xz-y^2=0
\]
over \(\mathbf F_{13}\).  For a line \(L=(a,b,c)\), its conic discriminant
is
\[
 \Delta(L)=b^2-4ac.
\]
The nonzero squares are \(\{1,3,4,9,10,12\}\); hence a line is passant
exactly when \(\Delta(L)\in\{2,5,6,7,8,11\}\).

In each row below, \(P\) is the first point and the remaining four points
form \(C\).  All coordinates are affine homogeneous triples.

\[
\begin{array}{c|ccccc|c|c}
 &P&B_1&B_2&B_3&B_4&
 \{\Delta(B_iB_j),\Delta(PB_i)\}&
 \{\Delta(PX):X\in\operatorname{Diag}(C)\}\\ \hline
 A&(0,1,1)&(1,0,1)&(3,12,1)&(4,9,1)&(6,5,1)&
 \{5,5,8,6,8,7,5,5,11,5\}&\{6,8,6\}\\
 A'&(0,1,1)&(1,0,1)&(2,7,1)&(10,2,1)&(12,6,1)&
 \{5,6,8,5,8,8,7,7,11,7\}&\{1,9,12\}
\end{array}                                                       \tag{5}
\]

Every entry in the middle column is a nonsquare, so all ten joins in each
five-point set are passants.  The ten three-by-three determinants are,
respectively,
\[
 \{1,12,10,6,11,7,8,2,9,2\},\qquad
 \{8,11,4,7,3,12,4,7,6,3\},                                    \tag{6}
\]
all nonzero, so both sets are arcs.  Direct intersection of opposite sides
gives diagonal points
\[
\begin{aligned}
 A &: (1,9,6),(1,7,3),(1,2,12),\\
 A'&: (1,9,9),(1,5,11),(1,4,11).
\end{aligned}                                                     \tag{7}
\]
The last column of (5) now shows that all three joins \(PX\) are passants
for \(A\), while all three are secants for \(A'\).

Consequently neither the number nor the parity of selected diagonal points
is fixed by the five-point conic-external hypothesis.  The two exact
examples already disprove every constant local evaluation needed by (3).

## 3. Stop verdict

Equation (2) is exact but not a bounded-order closure:

- its leading term is a character-filtered version of the old four-point
  collision allocation;
- its correction terms are the higher concurrent-matching moments already
  hidden in the fibre multiplicities; and
- the conic-external hypotheses supply no local value for the filter, even
  at the first four-point term.

A global identity coupling different four-subsets could still make (2)
useful, but neither the fibre excess nor the conic character provides one.
Continuing to tabulate \(D_j(P)\) would therefore only rename the existing
collision data.

The nonsaturated route should move to the other surviving structural gate:
classify the all-internal defect-two near-transversal at \((q,k)=(53,12)\),
seeking a uniform obstruction rather than another masked moment.

## Mystery ledger

| feature | status | exact remaining boundary |
|---|---|---|
| Does the simultaneous excess have an exact diagonal expansion? | settled | equation (2) |
| What is its four-point term? | settled | masked diagonal count (3) |
| What appears at defect two? | settled | six-point correction (4) |
| Is the diagonal mask locally determined by conic externality? | settled negative | explicit opposite extreme examples (5)--(7) |
| Does this route beat the closed slope moments? | no | it reallocates the same collision multiplicities by inclusion--exclusion |
| What could reopen it? | open | a genuinely global relation among the masked diagonal indicators |

## Next action

Return to the all-internal defect-two boundary \((q,k)=(53,12)\).  Express
its two allowed fibre shapes as a near-transversal problem on every spare
passant and test whether internality forces an incompatible global incidence
or parity condition.  Do not continue by computing higher \(D_j(P)\).
