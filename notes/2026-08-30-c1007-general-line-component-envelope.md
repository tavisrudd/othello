# C1007 — general odd-order line and component envelope

**Lane**: `relconic`

**Status:** Complete; no manuscript edits. Publication routing is transferred to C1004.

## Goal

Generalize the six-arc line lemma to arbitrary arcs in odd-order Desarguesian
planes, then combine it with Sziklai and the universal defect identity to
obtain component-sensitive and minimum-degree bounds for ordinary uncovered
loci.

## Theorem packet

Put
\[
 N=\binom{k}{2},\qquad r=\lfloor k/2\rfloor,
 \qquad \beta_k=N-k+\frac6r\binom{k}{4}.
\]

### Theorem 1 — uniform odd-order line bound

Let `A` be a `k`-arc in `PG(2,q)`, where `q` is odd and `k>=4`. Then every
line `ell` satisfies
\[
 |U(A)\cap\ell|\le q-k+1. \tag{1}
\]

If `ell` is a chord there is nothing to prove. If it is disjoint from `A`,
the secants of `A` determine at least `k` points of `ell`: in odd-order
Desarguesian planes the minimum number of directions determined by a
`k`-arc is `k`, equivalently a nontrivial hyperfocused arc with only `k-1`
directions cannot occur. If `ell` contains one point `a` of `A`, apply the
same result to the `(k-1)`-arc `A\{a}` disjoint from `ell`; its secants cover
at least `k-1` points of `ell`, and `a` supplies one more point outside the
uncovered locus. Thus at least `k` of the `q+1` points of `ell` are not
uncovered in every case.

The imported focused-direction statement is recorded in Giulietti--Montanucci,
*On Hyperfocused Arcs in PG(2,q)*, arXiv:math/0601488, pp. 1--2, as the
odd-order minimum-direction result of Bichara--Korchmaros. Cached source:
`arXiv:math/0601488`, SHA-256
`feb9f148d51c22df3f9ba35867137a0870ca220b1b233c03b0319de720c263f9`.

### Theorem 2 — component envelope

Let a degree-`d` plane curve contain `U(A)`. Factor from its defining form
all `F_q`-linear factors with total multiplicity `s`, and let the residual
degree be `e=d-s`.

If `e>=1`, the residual has no rational line component and, outside the unique
Sziklai quartic over `F_4` (irrelevant here because `q` is odd),
\[
 |U(A)|\le (d-1)q+1-s(k-1), \tag{2}
\]
and hence
\[
 q^2-(N+d-2)q+\beta_k+s(k-1)\le0. \tag{3}
\]
If `e=0`, then
\[
 |U(A)|\le d(q-k+1), \tag{4}
\]
and hence
\[
 q^2-(N+d-1)q+\beta_k+1+d(k-1)\le0. \tag{5}
\]

Indeed, there are at most `s` distinct rational line components, each charged
at most `q-k+1` by Theorem 1. If a residual remains, Sziklai charges at most
`(e-1)q+1`; adding gives (2). The universal defect lower bound
\[
 |U(A)|\ge q^2-(N-1)q+1+\beta_k
\]
then gives (3). With no residual, only the line charges remain, giving (4)
and (5). Repeated line factors can only reduce the zero set.

### Corollary 3 — universal one-degree improvement

Let `delta(A)` be the minimum degree of a nonzero form vanishing on `U(A)`,
with degree zero allowed for an empty locus. For every odd `q` and `k>=4`,
\[
 \delta(A)\ge q-N+3. \tag{6}
\]

For `q<=N-3` this is automatic. At `q=N-2`, the defect lower bound is
`|U(A)|>=beta_k-N+3>0`, so `delta(A)>=1`. Assume `q>=N-1` and suppose
`d=delta(A)<=q-N+2`. The residual branch (3) is already impossible because
`beta_k>0`. Hence the curve must split completely into rational lines. It is
enough to test the largest possible degree `d=q-N+2` in (5), which would
require
\[
 (k-2)q\le (k-1)(N-2)-\beta_k-1. \tag{7}
\]
But the right side divided by `k-2` is strictly smaller than `N-1`, since
the difference after cross multiplication is
\[
 N-k-1-\beta_k=-1-\frac6r\binom{k}{4}<0.
\]
This contradicts `q>=N-1` and proves (6).

## Stronger branchwise integer bounds

When a minimum-degree curve has a positive-degree residual, (3) gives
\[
 \delta(A)\ge q-N+2+
 \left\lceil\frac{\beta_k+s(k-1)}q\right\rceil. \tag{8}
\]
When it splits completely into rational lines and `q>k-1`, (5) gives
\[
 \delta(A)\ge
 \left\lceil
 \frac{q^2-(N-1)q+\beta_k+1}{q-k+1}
 \right\rceil. \tag{9}
\]
The minimum of the two branch bounds is a valid component-blind envelope;
(6) is its clean stable consequence.

## Evidence boundary

- Universal defect lower bound: existing human and Lean theorem in
  `papers/arcs_complete_outside_conic/`.
- Odd-order focused-direction lower bound: imported classical theorem, checked
  in the cached full text identified above; exact original-source pinpoint is
  reserved for C1004's literature audit.
- Sziklai bound: imported classical theorem with its unique `F_4` quartic
  exception, already checked for C1001.
- All deductions after those inputs are human algebra in this report; no finite
  computation or manuscript claim is used.

## `ej` + `tt` closeout

The task began as a possible six-arc refinement and instead closed the general
odd-order line-capacity problem needed here. Three task-owned gains are now
proved:

1. the six-arc `q-5` line lemma is the `k=6` instance of (1);
2. every rational line factor incurs the exact additional penalty `k-1` in
   the residual Sziklai branch;
3. the stable minimum-degree bound improves by one for every odd-order
   `k`-arc, with the stronger integral envelopes (8)--(9) retained.

The natural next attack is no longer another cardinality manipulation. It is
an equality/near-equality analysis for (8): combine the Sziklai extremal-curve
classification, the zero-defect or small-defect secant structure, and the
Hilbert function of `U(A)` to decide whether the new linear coefficient is
sharp.

## Mystery ledger

- **Sharpness of (6) — open.** No infinite family attaining
  `delta(A)=q-N+3` is known in the checked packet. Equality would require a
  low-degree residual curve near its Sziklai ceiling together with a
  near-minimal defect arc. The evidence gap is an explicit family or an
  equality obstruction; C1004 should decide whether to allocate it.
- **Even characteristic — structurally different.** Hyperfocused arcs exist,
  so (1) fails in its present form and rational line components can carry one
  more uncovered point. This is not a missing case of the proof; it requires a
  separate theorem with a hyperfocused branch.
- **Original-source priority — deferred.** The mathematical hypothesis was
  verified in cached full text, but the exact Bichara--Korchmaros original
  statement and the closest polynomial-method formulations remain C1004
  audit work.

No incidental discovery falls outside this task's theorem packet, so no
discovery-track append is required.
