# C756 \(q=53\) external-deletion all-covariance closure

**Lane:** clebsch · **Date:** 2026-08-09 · **Scope:** \(k=12\),
external deleted point, every covariance class and every remaining point-type
profile; no manuscript edit

## Verdict

The \(q=53\) external-deletion branch is impossible before covariance enters.
The 230 normalized mixed secant/passant stars from the prior aligned-split
search are in fact the complete covariance-free geometric list: their graph
uses only the fixed conic, the internality of all 55 star nodes, and the
dual-arc condition. Testing the fifteen required internal centers of every
star gives

\[
 \boxed{\text{no geometric star has even one complete center}.}
\]

Their best center projections meet only \(40,41,42,43\), or \(45\) of the
required 53 affine fibres. Consequently no conic-filling twelve-arc over
\(\mathbf F_{53}\) can contain an external point. This closes at once:

- all seven external-deletion anisotropic covariance rows;
- every disjoint-root split covariance row;
- the already closed one-shared-root and aligned split rows.

Any remaining \(q=53,k=12\) example must therefore be all-internal, so its
twelve polar lines are all passants. The formerly conditional all-passant
offset branch is now the whole \(q=53,k=12\) frontier.

## 1. Why the old geometry list is covariance-free

Let the deleted point \(P_0\) be external. Its polar line \(r_0\) is secant.
Choose coordinates

\[
 C:UV=2W^2,\qquad r_0:W=0,
\]

where \(2\) is nonsquare in \(\mathbf F_{53}\). Write a remaining polar line
as

\[
 r_i:a_iU+b_iV+s_iW=0.
\]

The point \(r_i\cap r_0=[b_i:-a_i:0]\) is the pole of the passant chord
\(P_0P_i\), hence is internal. This forces every \(a_ib_i\) into the same
square class. Rescaling each line and then one split coordinate gives

\[
 r_i:u_iU+u_i^{-1}V+s_iW=0.                              \tag{1}
\]

No covariance form was used. The no-three-concurrent condition makes the
eleven direction classes distinct. The condition that \(P_i\) is off the
conic excludes tangent states \(s_i^2=8\). For two states, the edge condition
in the prior graph is exactly that \(r_i\cap r_j\) is internal; its forbidden
triple mask is exactly the dual-arc determinant. Finally, the split torus
normalizes one direction and \(W\mapsto-W\) reduces its offset to
\(s=0,\ldots,26\).

Thus the prior domain of 1,378 states, 27 normalized root-offset shards,
57,849,196 search nodes, and 230 eleven-line leaves enumerates every
external-deletion geometric star, not merely stars whose covariance happens
to align with \(C|_{r_0}\). The earlier report used the list only as a safe
superset for its aligned critical test; the present result uses its full
geometric scope.

## 2. Direct all-center covering test

The 26 internal points of \(r_0\) consist of the eleven arrangement
directions and the fifteen required centers. A direction class \(u\) has
annihilating affine linear form

\[
 z_u(U,V)=uU+u^{-1}V.                                    \tag{2}
\]

For a center \(L\), the 55 star nodes project onto the 53 lines through
\(L\) other than \(r_0\) by their values under \(z_u\). Therefore \(L\) is
direction-complete exactly when

\[
 \#z_u(S_0)=53.                                          \tag{3}
\]

The checker constructs all 55 pairwise intersections directly and evaluates
(3) on all fifteen missing directions. It computes the support both as a
set of field values and as a 53-bit mask and refuses any disagreement.

The exact output is:

| item | value |
|---|---:|
| normalized root-offset shards | 27 |
| graph vertices | 1,378 |
| search nodes | 57,849,196 |
| normalized geometric stars | 230 |
| stars with at least one complete center | 0 |
| stars with all fifteen complete centers | 0 |
| largest number of complete centers on one star | 0 |
| covariance classes among the stars | 118 anisotropic, 112 split |

The largest projection span of a star is distributed as

\[
40^{11},\quad41^{11},\quad42^{96},\quad43^{101},\quad45^{11},              \tag{4}
\]

and its smallest span as

\[
34^{68},\quad35^{68},\quad36^{70},\quad37^{24}.                            \tag{5}
\]

In particular the failure is not a one-fibre near miss.

## 3. Character trace/norm layer

If a center passed (3), its 55 projected values would have a degree-two
residual divisor. For a residual value \(t\), the polar point's type
character in normalization (1) is

\[
 \tau(t)=\chi(t^2-8).
\]

The checker would record

\[
 W=\tau(t_1)+\tau(t_2),\qquad
 \eta=\tau(t_1)\tau(t_2)
      =\chi\!\left(\operatorname{Res}(E,Q_\ell)\right)
\]

and verifies \(W^2=2(1+\eta)\). The residual trace and norm tables in the
certificate are empty because no center reaches the prerequisite 53 fibres.
Thus the new all-center identity is implemented exactly, but the direct
support obstruction fires one step earlier and is strictly stronger on this
finite branch.

## 4. Exhaustiveness and reproducibility

Authority:

- generator/checker:
  notes/2026-08-09-c756-external-deletion-all-covariance-search.py;
- canonical certificate:
  notes/2026-08-09-c756-external-deletion-all-covariance-search.json;
- pinned geometry engine:
  notes/2026-08-09-c756-aligned-split-mixed-search.py.

From the repository root, regenerate with

    python3 notes/2026-08-09-c756-external-deletion-all-covariance-search.py \
      --enumerate --workers 8 \
      --output notes/2026-08-09-c756-external-deletion-all-covariance-search.json

Replay without changing the worktree with

    python3 notes/2026-08-09-c756-external-deletion-all-covariance-search.py \
      --check notes/2026-08-09-c756-external-deletion-all-covariance-search.json \
      --workers 8

| artifact | bytes | SHA-256 |
|---|---:|---|
| 2026-08-09-c756-external-deletion-all-covariance-search.py | 12,614 | a43ead2f65776363fc95d9e0803438a23f4db6479a8972725e64590fab917c1a |
| 2026-08-09-c756-external-deletion-all-covariance-search.json | 2,197 | 82bdfd7e8c5c3594e5b7e7aab9a724da6135aae6c96a269719a519ef0b7b81a3 |
| pinned 2026-08-09-c756-aligned-split-mixed-search.py | 22,835 | f1c11decc6df8c5e9bc0a57a5e98dfd35c9fdd2c4ce8fabaa3db5b115ab9249f |

The generator refuses a changed geometry-engine hash. Its check mode repeats
the complete 27-shard search and compares canonical JSON byte for byte. The
new projection layer has two exact support implementations (set and bit
mask), and its trace/norm assertion is checked at every complete center. The
prior geometry engine independently checks its node-character factorization
and critical carrier. There is no second independent exhaustive star
enumerator: this result deliberately adds a leaf predicate to the already
pinned canonical enumeration, and duplicating that search would not
independently validate the normalization-completeness argument of Section 1.
The trusted boundary remains ordinary Python integer arithmetic, the explicit
\(\mathbf F_{53}\) model, and completeness of the canonical clique search.

The computation proves only the \(q=53,k=12\) branch with an external deleted
point. It does not touch the now-forced all-internal branch, \(q=47\),
\(q=49\), higher sizes, or saturated-internal stars.

## EJ + Tao closeout

The free upgrade was to inspect the quantifiers of the old graph rather than
build a new covariance search. Its vertices and edges never mentioned
covariance: alignment entered only in the later partition-function
evaluation. Reusing the exact geometric leaves and testing the original
covering condition is both stronger and simpler than classifying the
remaining covariance rows.

The Tao-style compression is equation (3). Once all 55 internal nodes and
the dual-arc condition leave only 230 stars, the defining projection cover is
the right invariant; covariance, elliptic trace rows, the Hessian, and even
the degree-two norm are downstream shadows. The surprising gap of at least
eight fibres explains why no delicate resultant sign was needed here.

The cheap next task-owned opportunity is to ask whether the all-internal
passant-line geometry admits the same covariance-free enumeration and direct
sixteen-center test. If its existing common-torus graph is not the full
geometric domain, build the conic-torus graph before returning to the
nonaligned covariance rows. The separate \(q=47\) octic and \(q=49\)
divided-power carriers remain the next field-level gates.

## Mystery ledger

| feature | status | exact gap / next gate |
|---|---|---|
| Scope of the old 230-star list | settled | it is the complete external-deletion geometry list; covariance entered only after the leaves |
| Remaining external covariance rows | settled together | no leaf has a complete center, so every covariance class is impossible |
| Why the support deficit is at least eight | unexplained but non-load-bearing | spans (4)--(5); a human polynomial obstruction would be optional |
| Character trace/norm at a complete center | settled formally but vacuous here | no center reaches 53 fibres |
| \(q=53,k=12\) point type | settled | any hypothetical example is all-internal |
| Full \(q=53,k=12\) classification | open | covariance-free all-passant geometry/center test or the remaining nonaligned Gram rows |
| \(q=47\) and \(q=49\) | open | octic and Hasse/divided-power carriers respectively |
