# C756 complete \(q=53,k=12\) closure

**Lane:** clebsch · **Date:** 2026-08-09 · **Scope:** every point type and
every covariance class at the first defect-two boundary; no manuscript edit

## Verdict

There is no conic-filling twelve-arc over \(\mathbf F_{53}\).

The external-deletion branch was closed first: its complete covariance-free
list has 230 normalized mixed secant/passant stars, none with even one of its
fifteen required complete centers. The present pass closes the forced
all-internal branch:

- one conic offset class has no admissible eleven-passant star;
- the other has exactly 44 normalized stars, and none has even one of its
  sixteen required complete centers.

Every center projection of each of those 44 stars spans between 36 and 43 of
the required 53 fibres. Thus the full \(q=53,k=12\) layer fails the defining
covering condition before the covariance critical system, Hessian, elliptic
trace rows, or character resultant is needed.

## 1. Covariance-free all-passant normal form

Let \(L=\mathbf F_{53}[w]/(w^2-2)\), with norm \(N\), and take the
distinguished polar line \(r_0\) as the line at infinity. Because the deleted
point and all other arc points are internal, all twelve polar lines are
passants. After scaling the anisotropic restriction on \(r_0\), the fixed
conic has the form

\[
 Q(x,W)=N(x)-dW^2,
\]

where the two square classes of \(d\) are represented by \(1\) and \(2\).
An internal direction on \(r_0\) has an annihilating line normal whose norm
lies in one fixed nonsquare class. Normalize that norm to
\(\nu=2\), choose \(N(\alpha_0)=2\), and write

\[
 r_i:\operatorname{Tr}(\alpha_0u_i x)+s_iW=0,
 \qquad N(u_i)=1.                                        \tag{1}
\]

The identification \((u_i,s_i)\sim(-u_i,-s_i)\) leaves 27 direction
classes. In these coordinates:

\[
\begin{aligned}
 r_i\text{ is passant}
   &\Longleftrightarrow
   \chi(s_i^2-4d\nu)=1,\\
 r_i\cap r_j\text{ is internal}
   &\Longleftrightarrow
   \chi(Q(r_i\cap r_j))=\chi(d).
\end{aligned}                                             \tag{2}
\]

The no-triple condition is the nonvanishing of the determinant of the three
line rows. Common multiplication of all \(u_i\) by a norm-one scalar
normalizes one direction to zero.

Equations (1)--(2), line character, node character, and no-triple
concurrency are exactly the vertex, edge, and forbidden-triple predicates of
the pinned aligned-node search. Covariance appears there only after a leaf,
when the partition-function gradient is evaluated. Hence its two geometric
leaf lists are complete for arbitrary covariance:

| conic offset class | states | search nodes | normalized stars |
|---|---:|---:|---:|
| \(d=1\) | 702 | 2,096,318 | 44 |
| \(d=2\) | 675 | 7,092,500 | 0 |

The earlier aligned calculation used these lists as safe supersets. The
present calculation uses their full covariance-free quantifier.

## 2. Direct sixteen-center test

For a chosen star, the eleven used direction classes on \(r_0\) are the
arrangement nodes \(N_{0i}\). The other sixteen internal directions are
exactly the required centers. If \(u\) is one of them, put

\[
 z_u(x)=\operatorname{Tr}(\alpha_0u x).                  \tag{3}
\]

The 55 pairwise nodes of \(r_1,\ldots,r_{11}\) meet every line through the
center \(u\), other than \(r_0\), exactly when

\[
 \#z_u(S_0)=53.                                          \tag{4}
\]

The checker reconstructs all 55 intersections directly, evaluates all
sixteen maps (3), and computes each support both as a set and as a 53-bit
mask. On every one of the 44 stars:

\[
 \min_u\#z_u(S_0)=36,\qquad
 \max_u\#z_u(S_0)=43.                                    \tag{5}
\]

In particular every star has zero complete centers, against the required
sixteen. The support deficit is at least ten fibres.

As in the external-deletion checker, a hypothetical complete center would
produce a degree-two residual divisor. The checker then computes its
character trace and norm and verifies

\[
 W^2=2(1+\eta).
\]

Those tables are empty because no projection reaches 53 fibres.

## 3. Complete \(q=53,k=12\) conclusion

If a hypothetical arc contains an external point, delete that point and
apply the 230-star external closure. If it contains no external point, it is
all-internal and the 44-star calculation above applies. These cases exhaust
the point-type ledger. Therefore

\[
 \boxed{\text{no conic-filling }12\text{-arc exists in }
        \mathrm{PG}(2,53).}
\]

This settles only \(k=12\). It does not classify higher nonsaturated sizes
over \(\mathbf F_{53}\), and it does not affect the separate \(q=47\),
\(q=49\), or saturated-internal all-field gates.

## 4. Reproducibility

Authority:

- generator/checker: notes/2026-08-09-c756-all-passant-center-search.py;
- canonical certificate: notes/2026-08-09-c756-all-passant-center-search.json;
- pinned geometry engine: notes/2026-08-09-c756-aligned-node-clique.py;
- pinned geometry certificate: notes/2026-08-09-c756-aligned-node-clique.json.

Regenerate from the repository root with

    python3 notes/2026-08-09-c756-all-passant-center-search.py \
      --exact --output notes/2026-08-09-c756-all-passant-center-search.json

Replay without changing the worktree with

    python3 notes/2026-08-09-c756-all-passant-center-search.py \
      --check notes/2026-08-09-c756-all-passant-center-search.json

| artifact | bytes | SHA-256 |
|---|---:|---|
| 2026-08-09-c756-all-passant-center-search.py | 8,867 | 8f48cbeac32ddf62545084ddf606379130a259cb5cfef3e8641f9e0074e8a6cb |
| 2026-08-09-c756-all-passant-center-search.json | 2,253 | 712c12a194449edd7245fa32bcf359e5e3f7cc1fa491002f96a52d0bfd08f927 |
| pinned 2026-08-09-c756-aligned-node-clique.py | 26,912 | bf3c2fe00f9b09e2889532da697f9ef09d9ecffdfac2785d232541f164b79bbb |
| pinned 2026-08-09-c756-aligned-node-clique.json | 50,636 | 2b49dd98d42fe5686a646ffb4bb42505624cc11e821fdf9eb7b0975068e53422 |

The checker refuses either pinned hash, regenerates the complete two-class
geometry certificate, compares it byte for byte, reruns its direct
node-character and partition-function invariant checks, and then evaluates
the sixteen center projections by two support implementations. There is no
second independent exhaustive star enumerator: the new result is a new leaf
predicate on the already certified canonical geometry list, while the human
normalization-completeness argument is Sections 1--2. The trusted boundary is
ordinary Python integer arithmetic, the explicit \(\mathbf F_{53^2}\)
model, and completeness of the pinned clique search.

## EJ + Tao closeout

The free upgrade was again a quantifier correction. The old common-torus
graph looked covariance-specific because its report studied aligned
covariance, but its finite predicates stop at conic geometry; covariance is
read only after the 44 leaves. Directly testing the original covering
condition closes every nonaligned anisotropic and split covariance row at
once.

The Tao-style compression is that the star-center gate is not merely
violated: every candidate misses at least ten of the 53 fibres from every
best center. The covariance moment collapse was detecting a much coarser
shadow of this large support defect. A human star-specific Rédei explanation
would be attractive but is no longer load-bearing at \(q=53,k=12\).

The highest-EV field-level continuation is now the \(q=47\) bounded octic
carrier, with the \(q=49\) Hasse/divided-power carrier kept separate.
Higher \(k\) over \(q=53\) remains an independent size layer.

## Mystery ledger

| feature | status | exact gap / next gate |
|---|---|---|
| Scope of the old 44-star list | settled | it is the complete all-passant geometry list for both conic offset classes |
| Remaining \(q=53,k=12\) covariance rows | settled together | no geometric leaf has one complete center |
| Why every star has span range exactly \(36\) to \(43\) | unexplained but non-load-bearing | optional star-specific Rédei or orbit explanation |
| Full \(q=53,k=12\) classification | settled negative | external and all-internal point types both exhausted |
| Higher \(k\) over \(q=53\) | open | different defect and interpolation window |
| \(q=47\) | open | bounded quadratic-through-octic carrier |
| \(q=49\) | open | characteristic-seven Hasse/divided-power carrier |

