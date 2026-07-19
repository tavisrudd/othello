# C335: the Patra--Barg AF metric is blind beyond distance shells

**Date:** 2026-07-19
**Lane:** `crowns`
**Status:** research exit gate met by a sharp negative; administrative queue transition remains with
the queue coordinator

## Verdict

**SHARP NEGATIVE; THE DISTANCE-WEIGHTED AF OPTIMUM FACTORS THROUGH THE ROOTED DISTANCE
DISTRIBUTION.** Patra--Barg's accumulate-and-forward (AF) optimization cannot see determinant
sheets, pair traces, the Fricke/definition-field coordinate, generator colours, or voltage/backbone
structure except insofar as those data change the ordinary uncoloured distance shells. For a
vertex-transitive Cayley graph, even the failed vertex disappears from the metric.

The two mandatory pilots trigger C335's prescribed stop rule. The mixed `PGL2(3)` Cayley graph of
pair-product type `(2,3,4)` has rooted shell polynomial

\[
1+3x+5x^2+7x^3+8x^4.
\]

The smallest admissible member of the C294/C333 mirror family, `q=7, b=4`, has deleted-Schreier
residual

\[
1-5-3-2-4-6-1,
\]

so it is exactly `C6`, with shell polynomial `1+2x+2x^2+x^3`. Both pilots are vertex-transitive.
No family census is authorized: in the selected primary metric the proposed algebraic coordinates
are mechanisms for deriving a distance distribution, not an additional operational resource.

This report characterizes one external work. **Zero sources were read at full text:** the load-bearing
Patra--Barg preprint was read at `partial` depth, and the published version was consulted at
`abstract/metadata only` depth. No absence-of-prior-work claim is made, so this is not a
forward-citation negative.

## Metric-blindness theorem

Let `G` be an `n`-vertex repair graph, let `f` be the failed vertex, and list the distances from `f`
to the other vertices in nondecreasing order

\[
r_1(f)\leq r_2(f)\leq\cdots\leq r_{n-1}(f),\qquad
S_f(d)=\sum_{i=1}^d r_i(f).
\]

For a dimension-`k` code in the Patra--Barg stacked/subpacketized AF regime, normalized by the
per-node storage `l`, their Theorem IV.1 and deterministic-graph specialization (20) give

\[
\frac{\Lambda^{\mathrm{AF}}(f;k)}{l}
=\min_{k\leq d\leq n-1}\frac{S_f(d)}{d-k+1}. \tag{1}
\]

Indeed, at a fixed repair degree `d`, an optimal solution assigns the uniform amount
`l/(d-k+1)` to the `d` cheapest helpers. Under AF the helper weights are exactly their graphical
distances to `f`, so the cheapest helpers are the `d` nearest vertices. This proves (1).

Consequently the complete rooted distance multiset is a sufficient statistic for the optimized AF
cost. If two rooted graphs have the same distance multiset, they have the same cost for every `k`;
if `G` is vertex-transitive, the cost is independent of `f`. Generator labels and all group-theoretic
coordinates are invisible after the uncoloured distances have been formed. This is an exact
factorization statement, not a claim that those coordinates can never help prove a shell formula.

### Scalar specialization

The scalar case must not be identified with (1)'s fractional normalized optimum. Put `l=1` and
require the paper's helper downloads to be nonnegative integers. Its cut-set constraint says that
every set of `n-k` potential helpers has total download at least one. Hence at most `n-k-1` helpers
can have download zero, so at least `k` helpers transmit a positive integer. The minimum is attained
by downloading one full symbol from each of the `k` nearest helpers and decoding the scalar MDS
code. Thus

\[
\Lambda^{\mathrm{AF}}_{\mathrm{scalar}}(f;k)=S_f(k). \tag{2}
\]

Formula (2) is exact and uses no subpacketization. Values from (1) with `d>k` generally require
`l` divisible by `d-k+1`; they are reported separately below and are not scalar-code optima.
Here the repair-code alphabet is independent of the finite field used to construct the graph and is
assumed large enough to support the stated scalar MDS code.

## Mandatory small instances

### Mixed Cayley scar

Over `F3`, take the three off-conic centres

\[
(0,1,0),\quad(0,1,1),\quad(1,0,1).
\]

Their projection involutions generate `PGL2(3)` of order 24, and their pair-product orders are
`(2,3,4)`. Exact word-ball expansion gives layers `1,3,5,7,8`; an independent BFS on the left
Cayley graph gives the same layers from every vertex. Hence

\[
S(d)=
\begin{cases}
d,&1\leq d\leq3,\\
2d-3,&4\leq d\leq8,\\
3d-11,&9\leq d\leq15,\\
4d-26,&16\leq d\leq23.
\end{cases}
\]

For example, an `[24,3]` scalar code has exact AF cost `S(3)=3`, equal to the complete-network
scalar baseline because the root already has three neighbours. The subpacketized normalized
optimum is instead `13/6`, attained at `d=8`; it requires the stacked/vector regime and is not a
scalar improvement. For `k>3`, the sparse graph has a strict scalar distance penalty over the
complete graph's cost `k`.

### Deleted Schreier residual

For `q=7, b=4`, the mirror-family centres are

\[
(0,1,1),\quad(-1,0,1),\quad(1,4,1),\quad(-4,-1,1).
\]

The parameter is admissible: `4` avoids `0,1,-1,2`, and
`(4-1)^2+4=6` in `F7` is nonsquare. Delete the burned conic parameters `0` and `infinity`, omit
fixed points, and merge duplicate projection edges. On vertices `1,...,6` the edge set is

\[
\{15,16,23,24,35,46\},
\]

which is the displayed 6-cycle. Therefore

\[
S(d)=d\ (1\leq d\leq2),\qquad
S(d)=2d-2\ (3\leq d\leq4),\qquad S(5)=9.
\]

For `[6,3]`, the scalar AF cost is `S(3)=4`, versus `3` on `K6`. The subpacketized normalized
optimum is `3`, attained at `d=4` or `5`; again this is a vector/stacked-code value, not a scalar
one. The residual's mirror origin supplies no further discount after its distance shells are fixed.

## Literature and invariant boundary

- **Adway Patra and Alexander Barg, _Generalized regenerating codes and node repair on graphs_.**
  Read depth: `partial`. Version/access: arXiv v1, 20 May 2024, sections I-A, I-B, I-D, IV through
  Corollary IV.2, and IV-A through the deterministic-graph optimization; cached as
  `arXiv:2405.11714`, SHA-256
  `04e7449c6314aeff66ac28719e97619b2ad5c3955c6d03726b8d60879e5575f0`, 29 pages. The
  load-bearing inputs are the graph-distance AF weights, Theorem IV.1's uniform optimum after
  repair-degree adjustment, and equation (20). The paper also treats intermediate processing,
  nonuniform download, and adversarial repair, but this audit does not characterize those results.
- **Published IEEE version, DOI `10.1109/TIT.2025.3532625`.** Read depth:
  `abstract/metadata only`. Crossref and OpenAlex metadata were consulted on 2026-07-19 to identify
  the published record; the published full text was not obtained, and no claim is made that its
  wording or numbering is identical to arXiv v1.

The factorization theorem is an inference from Patra--Barg's displayed AF optimization, not a claim
made in their group-theoretic language. Their cited source for the underlying LP theorem was not
read; this report relies on the theorem and deterministic specialization as stated in the cached
preprint. MathSciNet, zbMATH, and forward-citation sets were not screened because the verdict does
not depend on the absence of an earlier or later theorem.

## Evidence bundle

From `/home/tavis/src/othello`:

```sh
python3 notes/2026-07-18-c335-applied-cayley-schreier-networks.py \
  --check notes/2026-07-18-c335-applied-cayley-schreier-networks.json
sha256sum -c notes/2026-07-18-c335-applied-cayley-schreier-networks.sha256
```

The checker reconstructs the projection permutations and both graphs from coordinates. It verifies
the Cayley shells twice, by graph BFS and by independent word-ball expansion; verifies the Schreier
edge set against the explicit cycle; checks the shell distribution from every root; and records all
scalar and subpacketized AF optima for every admissible `k`.

| artifact | bytes | SHA-256 |
|:--|--:|:--|
| `notes/2026-07-18-c335-applied-cayley-schreier-networks.py` | 10,470 | `a82acf42e1774fc269870bbd38f5e6e79ed71cf0d0d2041a4c6f4c373260249a` |
| `notes/2026-07-18-c335-applied-cayley-schreier-networks.json` | 7,937 | `1a54db8fe62216398158d62ec10878a091deea73c8058f8ee3e23202d34d649c` |

The trusted boundary is Python 3.13.12 standard-library prime-field arithmetic, finite permutation
closure, exact BFS/word-ball enumeration, and rational arithmetic. The certificate does not prove an
all-`q` distance distribution, expansion, mixing, routing, resilience, or an IP-repair theorem. The
negative closes only C335's selected Patra--Barg AF application gate; it does not rhetorically close
C294 silver or rule out a separately allocated intermediate-processing or adversarial-repair metric.
