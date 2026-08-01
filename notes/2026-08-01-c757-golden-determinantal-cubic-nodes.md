# C757 — Golden determinantal cubic-wall nodes

**Lane:** `golden`

**Date:** 2026-08-01

**Status:** complete

## Result

For every Golden sister \(T\), the cubic determinantal wall
\[
 X_T=\{Z_T=0\}\subset\mathbf P(A_X)
\]
has exactly six singular points:
\[
 \operatorname{Sing}(X_T)
 =\{[\mathbf1-6e_i]:0\le i<6\}.
\]
All six points are rational ordinary double points.  They are the centered
\(5+1\) collision configurations and are common to all six walls.

The structural reason for their presence is elementary.  At a \(5+1\)
collision every perfect matching has at least two pairs inside the five-point
block, so every matching-bracket cubic vanishes to second order.  Outer
covariance permutes the six collision points and the six walls.

Exact projective Jacobian elimination rules out any other singular support.
In the gauge \(x_5=-(x_0+\cdots+x_4)\), the homogeneous Jacobian ideal has
projective dimension zero.  The chart \(x_4=1\) contains the entire singular
scheme; its quotient algebra is reduced of dimension six and has six minimal
primes.  The complementary hyperplane contains only the irrelevant affine
origin.  The four-variable dehomogenized Hessian determinants are \(6480\)
at five chart representatives and \(1296/5\) at the sixth, so every
singularity is an ordinary double point.

## Classical comparison

Dolgachev, *Corrado Segre and nodal cubic threefolds*, arXiv:1501.06432,
Remark 3.6, observes that the rank-one double locus of the ambient
\(3\times3\) determinant has degree six.  Hence a linear determinantal cubic
threefold with isolated singular locus has total Milnor number six.  The six
Golden nodes each have Milnor number one, so the Golden wall saturates this
classical total.

The consulted cached PDF has key `arXiv:1501.06432` and SHA-256
`98a898303e06a395bad95888a826e677a955d4b8fc88914c6ede54e31406601e`.
The comparison is a specialization of the classical determinantal statement;
no novelty or priority claim is made for the six-node bound.

## Cross-paper comparison

The six-node conclusion is also Paper I, Corollary 8.3.  For one marked
support-orientation cubic, that corollary obtains the same points
\([\mathbf1-6e_i]\) and their ordinary-node type from the golden
determinantal duality, while Paper I's exact gradient-ideal replay checks the
singular-locus exhaustion independently.  Outer covariance transports that
marked cubic among the six Golden sisters.  The present argument is therefore
a third proof route---second-order matching vanishing followed by exact
projective Jacobian elimination and Hessians---not a new six-node claim.

## Evidence bundle

The primary generator is
`notes/2026-08-01-c757-golden-determinantal-cubic-nodes.py`.  It reconstructs
the frozen cubic from the C704 conference matrix and triangle coefficients,
then invokes exact rational Singular 4.4.1 elimination.  The compact
certificate is the adjacent JSON file.  The dependency-free replay rebuilds
the cubic through separate sparse-polynomial code and checks the six
singular witnesses and their Hessians using `fractions.Fraction`.

From the repository root, run:

```text
python3 notes/2026-08-01-c757-golden-determinantal-cubic-nodes.py --check
python3 notes/2026-08-01-c757-golden-determinantal-cubic-nodes-replay.py
```

The primary `--check` regenerates in memory, compares the canonical JSON and
checksum manifest byte-for-byte, and leaves the worktree unchanged.  It
certifies global projective exhaustion, reducedness, the exact points, and
their local quadratic types.  The replay independently certifies the frozen
cubic correspondence, all six witnesses, and the local Hessian determinants;
it does not independently repeat the global Groebner calculation.

| artifact | bytes | SHA-256 |
|---|---:|---|
| `2026-08-01-c757-golden-determinantal-cubic-nodes.py` | 9185 | `7764fdb5f86dae9191fb3e7aed89463ca4f7d95368fa4e4fb978c2ed82c0fd86` |
| `2026-08-01-c757-golden-determinantal-cubic-nodes-replay.py` | 3708 | `bd9e5705ee7d7743649206029a1b92c50f8b22043191d34f6fa93fc7e2c438bc` |
| `2026-08-01-c757-golden-determinantal-cubic-nodes.json` | 5973 | `33e78e940dfe61a6d8a74c6b954a3f0e01098e365cba14c45fe773fa1bb3d2ea` |

## Manuscript placement

Corollary `cor:golden-cubic-wall-nodes` now follows the principal propagation
theorem.  It states the common six-node locus, the ordinary-double-point
classification, cites Paper I, Corollary 8.3 for the same node theorem by a
different route, and gives the saturated Milnor-total comparison.  The
verification supplement records the two replay commands and distinguishes the global
Singular check from the independent local replay.  The warning-free paper
build passes at 19 pages.

## Closeout `ej` + `tt` and mystery ledger

The closeout pass replaced a bare node census by its matching-theoretic cause:
two forced zero brackets at every \(5+1\) collision explain why the same six
vertices are singular on all six walls.  Combining that observation with the
classical Milnor total shows that, once exact elimination rules out a singular
curve, no further isolated singularity can occur.  This is the natural stopping
point: the result strengthens the Golden determinantal package without opening
a classification of arbitrary linear sections of the determinant cubic.

The user-requested `ej` pass adds one further structural compression.  The six
vertices form a projective frame, and the five-dimensional matching carrier is
exactly the complete linear system of cubics double at that frame.  In frame
coordinates, double vanishing at five coordinate points leaves the ten
squarefree cubic monomials; the five conditions at the sixth point are
independent because their incidence Gram matrix is \(3I_5+3J_5\), leaving a
five-dimensional vector space.  The fifteen
four-equals base lines are therefore the fifteen frame edges: every cubic in
the system restricts to a degree-three polynomial with double zeros at both
endpoints and hence vanishes on the edge.  This identifies the C757 common-node
theorem and the pre-existing matching-base theorem as local and global aspects
of one projective-frame linear system.

| feature | status | exact boundary |
|---|---|---|
| why all six walls have the same nodes | settled | matching products vanish to second order at the six \(5+1\) vertices; outer covariance permutes them |
| whether the six witnesses exhaust the projective singular scheme | settled | exact Jacobian elimination gives a reduced degree-six chart and no boundary point |
| whether the nodes attain the classical determinantal bound | settled | six nondegenerate Hessians give total Milnor number six, equal to Dolgachev's isolated determinantal total |
| why the common nodes and fifteen matching-base lines occur together | settled by the `ej` pass | the matching carrier is the complete linear system of cubics double at the six-point projective frame, whose edges are forced base lines |
| whether a representation-free construction canonically identifies the rank-one block at each node | outside scope | not needed for the singular-scheme theorem; would require a separately selected refinement of the pole-marked block geometry |

No genuine mystery remains in the node-count theorem.  The final row is a
different marked-block question and does not obstruct the paper strengthening.
