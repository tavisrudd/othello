# C756 aligned anisotropic critical closure

**Lane:** `clebsch` · **Date:** 2026-08-09 · **Scope:** nonsaturated
aligned covariance branch; no manuscript edit

## Verdict

The aligned anisotropic branch is impossible at the first defect-two boundary
\((q,k)=(53,12)\).  The rank-two Laurent displacement, the two-factor
internal-node characters, the dual-arc condition, and the torus-normalized
critical equations leave no configuration.

There are two offset descent classes after normalizing the common nonsquare
normal norm to \(\nu=2\).

- In the split-offset class, no eleven normalized passant states have all
  pairwise intersections internal while avoiding triple concurrency.
- In the trace-zero-offset class, exactly 44 candidates containing one fixed
  direction survive those two geometric tests.  They form four dihedral
  orbits.  Every candidate has nonzero separator Hessian, but none is critical:
  in fact all eleven entries of \(\nabla\mathcal Z\) are nonzero for every
  candidate.

Thus the split class forces a collision/triple concurrency before the moment
system is used, while the trace-zero class reaches the requested open-Hessian
gate and then fails \(\nabla\mathcal Z=0\) maximally.  The conic-center shift is
never set to zero.

## 1. Exact normalized state space

Work in \(L=\mathbf F_{53}[w]/(w^2-2)\), with conjugation
\(a+bw\mapsto a-bw\).  Normalize
\[
 N(\alpha_i)=\nu=2,
 \qquad \alpha_i=\alpha_0u_i,
 \qquad N(u_i)=1.
\]
The sign identification \((u_i,s_i)\sim(-u_i,-s_i)\) leaves 27 direction
classes.  A passant state is a pair \((u_i,s_i)\) satisfying
\[
 \chi(s_i^2-4d\nu)=1.
\]
Only the square class of \(d\) matters.  Since \(-1\) is a square at 53 and
the conic center is internal with \(Q(0)=-d\), the internal-node condition is
\[
 \chi(Q(x_{ij}))=\chi(d).
\]
The two representatives are therefore:

| offset descent | \(d\) | states | internal character |
|---|---:|---:|---:|
| trace zero, \(4d\nu\) nonsquare | 1 | 702 | \(+1\) |
| split, \(4d\nu\) square | 2 | 675 | \(-1\) |

For each pair the checker evaluates the factored node condition through the
equivalent rational formula
\[
 Q(x_{ij})=
 \frac{-\nu(s_i^2+s_j^2)+s_is_jT_{ij}-dD_{ij}^2}{D_{ij}^2}.
\]
The no-triple condition is the nonvanishing of the determinant of the three
rows \((s_i,u_i,u_i^{-1})\).  This determinant is unchanged when the Laurent
displacement code is subtracted, so it is exactly the dual-arc condition in
the conic-centered variables.

Multiplication of every \(u_i\) by one norm-one scalar is a common torus
isometry.  Hence any candidate can be normalized to contain direction zero.
The exact search uses this symmetry and no other quotient.

## 2. The Laurent displacement is fixed by the star centroid

For a surviving state set, intersect the eleven conic-centered lines
\[
 \operatorname{Tr}(\alpha_i x)+s_i=0
\]
and compute the centroid of their 55 nodes.  Translating that centroid to zero
gives offsets
\[
 c_i=s_i-\eta u_i-\eta^{53}u_i^{-1}
\]
for the uniquely determined displacement coordinate \(\eta\).  This is the
rank-two Laurent compatibility from the common-torus report, now imposed
without introducing two free elimination variables.  It is a computation of
the permitted shift, not the forbidden specialization \(\eta=0\).

At these centered offsets the critical derivatives are evaluated by the EJ2
matching formula.  The edge weight is
\[
 a_i^{\mathsf T}Ma_j
 =\operatorname{Tr}(\alpha_i\alpha_j^{53})
 =2B_{ij}.
\]
The factor two is essential: \(B_{ij}\) in the aligned reports is the Gram
entry for \(K=M/2\), whereas the matching expansion of \(\mathcal Z\) uses
the Gram for \(M\).  An independent balanced-coefficient evaluation of
EJ2 equation (7) checks every recorded gradient and Hessian value.

## 3. Exhaustion result

The canonical exact search visits the following finite domains.

| class | search nodes | normalized 11-candidates | critical | open Hessian |
|---|---:|---:|---:|---:|
| trace zero | 2,096,318 | 44 | 0 | 44 |
| split | 7,092,500 | 0 | 0 | 0 |

The 44 trace-zero candidates form four dihedral orbits; their numbers of
direction-zero representatives are \(22,14,6,2\).  Every one of their 484
critical derivative values is nonzero.  In the chosen normalization the
product of the eleven derivatives is always
\[
 \prod_i\partial_i\mathcal Z=34\in\mathbf F_{53}^*,
\]
a nonsquare.  This constant product is not needed for the contradiction but
is the strongest compression exposed by the closeout pass.

## 4. Reproducibility and trust boundary

Authority:

- generator/checker: `notes/2026-08-09-c756-aligned-node-clique.py`;
- canonical certificate: `notes/2026-08-09-c756-aligned-node-clique.json`.

From the repository root, regenerate with

```sh
python3 notes/2026-08-09-c756-aligned-node-clique.py \
  --exact --output notes/2026-08-09-c756-aligned-node-clique.json
```

Replay without changing the worktree with

```sh
python3 notes/2026-08-09-c756-aligned-node-clique.py \
  --check notes/2026-08-09-c756-aligned-node-clique.json
```

The replay redoes the exhaustive symmetry-normalized search and independently
checks two load-bearing formulas: every node value is recomputed by directly
intersecting the two affine lines and evaluating \(N(x)-d\), and every
gradient/Hessian entry is recomputed from the balanced Laurent coefficient
extractor rather than the matching recurrence.

Hashes and byte counts:

| artifact | bytes | SHA-256 |
|---|---:|---|
| `2026-08-09-c756-aligned-node-clique.py` | 26,912 | `bf3c2fe00f9b09e2889532da697f9ef09d9ecffdfac2785d232541f164b79bbb` |
| `2026-08-09-c756-aligned-node-clique.json` | 50,636 | `2b49dd98d42fe5686a646ffb4bb42505624cc11e821fdf9eb7b0975068e53422` |

The trusted boundary is ordinary Python integer arithmetic, the stated
\(\mathbf F_{53^2}\) model, and the completeness of the explicit backtracking
search.  This proves only the aligned anisotropic branch at \(q=53\); it does
not touch the nonaligned trace rows or the split-covariance rows.

## EJ + Tao closeout

The cheap extra value is the four-orbit compression and the constant nonzero
gradient product 34.  A Tao-style reading asks for the invariant behind that
product: it resembles a resultant or discriminant norm of the two coupled
Laurent codes and may replace the 44-leaf calculation by a short structural
identity.  That humanization is optional because the exact bounded gate is
closed, but it is the cleanest adjacent crown if the branch is later promoted.

The highest-EV continuation is no longer aligned.  Return to the two bounded
families isolated by the elliptic overlap squeeze: nonaligned anisotropic
trace \(-10\) or \(-14\), and the seven split-covariance trace/zero rows.  In
those families the skew diagonal characters must be coupled to the rank-two
Gram critical system; the common-torus state graph used here is unavailable.

## Mystery ledger

| feature | status | exact evidence gap or owner |
|---|---|---|
| Aligned anisotropic branch | settled impossible | split collision or trace-zero critical failure above |
| Conic-center displacement | settled | recovered from the 55-node centroid; never specialized to zero |
| Separator Hessian in trace-zero survivors | settled open | all 44 candidates have no zero off-diagonal entry |
| Why every derivative product is 34 | open but non-load-bearing | optional resultant/discriminant humanization within C756 |
| Why exactly four dihedral candidate orbits occur | open but non-load-bearing | optional cyclic-torus classification within C756 |
| Nonaligned anisotropic covariance | open | trace \(-10,-14\) critical Gram gate, C756 |
| Split covariance | open | seven elliptic-overlap rows, C756 |

