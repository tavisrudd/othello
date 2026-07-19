# C353: mirror-family service under two helper failures

**Date:** 2026-07-19  
**Lane:** `crowns`  
**Verdict:** **EXACT SAME-TYPE SEPARATION; TWO-FAILURE ROBUST EQUAL RATE IS NOT DETERMINED BY `E/E/I/I`**

## Result

Let the eight columns of the maximum-length `[8,3,6]_7` conic MDS code be indexed by

\[
P_t=(t^2,t,1)\quad(t\in\mathbf F_7),\qquad P_\infty=(1,0,0).
\]

For a C333 member `(delta,b)`, request the four linear functions represented, in this coordinate
model, by

\[
(0,1,1),\quad(\delta,1,0),\quad(1,1,b),\quad(\delta b,1,\delta^{-1}).
\]

Given two failed helpers `F`, set their service capacities to zero and every other helper capacity
to one. Let `rho_2(delta,b)` be the minimum over the 28 choices of `F` of the largest `lambda` for
which `(lambda,lambda,lambda,lambda)` is fractionally serviceable using **all minimal recovery
sets**. Then

\[
\rho_2(5,2)=\frac23,\qquad \rho_2(6,5)=\frac58.
\]

Both parameter pairs pass C333's explicit admissibility tests, generate the full group
`PGL_2(7)` of order 336, and have point-type vector `E,E,I,I`. Consequently their intact one-object
axes are identical: `7/2,7/2,4,4`. The strict inequality

\[
\frac23>\frac58
\]

is therefore the required operational separation beyond C334's homogeneous weighted simplex.
It is scalar versus scalar and fractional versus fractional. It neither claims an integral batch
advantage nor compares a fractional schedule to an indivisible one.

The worst failure pairs use server labels `0,...,6,infinity`. For `(5,2)`, equality `2/3` occurs at
`{1,3}`, `{1,4}`, `{1,5}`, `{3,4}`, `{3,5}`, and `{4,5}`. For `(6,5)`, equality `5/8` occurs at
`{0,4}` and `{5,infinity}`.

## Exact formulation and proof certificate

For each colour `i` and each minimal recovery set `R` disjoint from `F`, let `x_(i,R)>=0`. The
equal-rate linear program is

\[
\max\lambda,
\qquad
\sum_{i,R\ni v}x_{i,R}\le1\quad(v\notin F),
\qquad
\sum_Rx_{i,R}\ge\lambda\quad(i=0,1,2,3).
\]

Its dual assigns nonnegative weights `y_v` to helpers and `u_i` to colours, subject to

\[
\sum_i u_i\ge1,
\qquad
\sum_{v\in R}y_v\ge u_i
\quad\text{for every available recovery set }(i,R),
\]

and minimizes `sum_v y_v`. The JSON certificate stores an exact rational primal allocation and an
exact rational dual cover for every one of the 56 parameter/failure instances. Weak duality makes
each recorded rate exact. Taking the minimum of the 28 exact rates gives the two displayed robust
capacities.

The checker constructs recovery sets in two independent ways. The first starts with target secants
and adds exactly the triples containing no secant pair. The second tests every carrier subset of
size at most three directly for minimal spanning. They agree for both parameter pairs. It then
checks every primal load, every served colour rate, every dual inequality, and equality of primal
and dual objectives using `fractions.Fraction`; SciPy is used only to discover certificates during
generation, not by `--check`.

This proves a finite exact theorem at `q=7`. It does **not** prove an all-odd-field formula, a
stochastic queueing law, optimality after three or more failures, or a special role for the C333
mirror pairing itself. The separating information is the complete coloured recovery hypergraph,
not merely the four point types.

## Literature audit and novelty boundary

This audit names nine sources: five full-text readings inherited from C334's recorded source bundle,
three partial full-text readings made for this task, and one abstract/metadata-only source. The
bounded claim is that no located work gives the displayed same-code, same-type, two-helper-failure
separation. It is not an unqualified priority claim.

### Direct service-rate and oval sources

- Di Giusto--Ravagnani--Soljanin, *The Oval Strikes Back*, arXiv:2601.16628. **Read depth: full
  text**, cached preprint, key `arXiv:2601.16628`, SHA-256
  `ab80a873ecf39ca7c130252d78eb07f2e2aa8b966f465e7f44dbdb3c9bf6871b`; inherited from C334 and
  rechecked here at the PIR/integral-SRR discussion and Section V. It treats the all-internal oval
  construction with uniform live servers, not deletion-specific four-function robustness.
- Ly--Soljanin, *Service Rate Regions of MDS Codes & Fractional Matchings in Quasi-uniform
  Hypergraphs*, arXiv:2504.17244. **Read depth: full text**, cached preprint, key
  `arXiv:2504.17244`, SHA-256
  `3943e2b5ba2a1bc0a84b5c62bc7f5f7d1c6d3551fbff4b91f4fd1b8290eb2700`; inherited from C334 and
  rechecked here at Section II-B and the fractional-cover discussion. Its model defines a capacity
  vector and then assumes all server capacities equal one; the present failed-helper model is its
  natural `0/1` specialization before that assumption.
- Ly--Soljanin, *Maximal Achievable Service Rates of Codes and Connections to Combinatorial
  Designs*, arXiv:2506.16983. **Read depth: full text**, cached preprint, key
  `arXiv:2506.16983`, SHA-256
  `37b975a07ec877e73c63aa111aaf4286e644697254b965c4a11345e41d00ac2a`; inherited from C334. It
  controls axes through dual checks and designs, not simultaneous four-function service after a
  specified helper deletion.
- Alfarano--Kilic--Ravagnani--Soljanin, *The Service Rate Region Polytope*, arXiv:2303.04021.
  **Read depth: full text**, cached preprint, key `arXiv:2303.04021`, SHA-256
  `ffc9a8edbd513ad70b3336b27dd5fc475e4b4dad4665c10aed7c2794becffce4`; inherited from C334. Its
  rational-polytope results justify exact rational allocation but do not classify failure minors.
- Alfarano--Ravagnani--Soljanin, *Dual-Code Bounds on Multiple Concurrent (Local) Data Recovery*,
  arXiv:2201.07503. **Read depth: full text**, cached preprint, key `arXiv:2201.07503`, SHA-256
  `75dfdc9b233c2f091e987790b6cff029551b59d0289d85f0b9b3d8b30a712bbc`; inherited from C334. It
  supplies the general concurrent-recovery boundary, not this exact damaged region.
- Choudhary--Bhaintwal, *The Service Rate Region of Hamming Codes*, arXiv:2509.22898. **Read depth:
  partial**, cached preprint, key `arXiv:2509.22898`, SHA-256
  `4259214166fa5cb3ffe5d5181f0049b68ded7b2a58e9f76455b29873941b593e`; abstract, model, main
  results, and conclusion read. It studies Hamming-code sum-rate bounds with uniform capacity and
  leaves full SRR characterization open.

### Integral/batch and failure-adjacent sources

- Kazemi--Karimi--Soljanin--Sprintson, *A Combinatorial View of the Service Rates of Codes Problem,
  its Equivalence to Fractional Matching and its Connection with Batch Codes*, arXiv:2001.09146.
  **Read depth: partial**, cached preprint, key `arXiv:2001.09146`, SHA-256
  `a52f36467c4aba2deffaa0df820e98f7d43d6c82b1ca96a7c90db890000571b9`; abstract, model,
  fractional-matching equivalence, and batch-code comparison read. It establishes the general
  bridge; C353 makes no integral claim.
- Aktas--Joshi--Kadhe--Kazemi--Soljanin, *Service Rate Region: A New Aspect of Coded Distributed
  System Design*, arXiv:2009.01598. **Read depth: partial**, cached preprint, key
  `arXiv:2009.01598`, SHA-256
  `35325300b0e98e951ab362a3ab3ada74f344b0008c99db27d68f3872a5aaed5f`; abstract, capacity model,
  batch/asynchronous discussion, and open problems read. It treats load balancing and heterogeneous
  demand, not an exact adversarial failure minor of one MDS recovery hypergraph.
- Hellemans--Yardi--Bodas, *Download time analysis for distributed storage systems with node
  failures*, arXiv:2105.02926. **Read depth: abstract/metadata only**, arXiv abstract and DOI
  metadata (`10.1109/ISIT45174.2021.9517730`) consulted. It is a queueing/mean-field latency model
  for hot/cold files under random node availability, not an exact SRR facet or certificate.

### 2025--2026 search and forward citations

Load-bearing search queries, run on 2026-07-19, were:

```text
site:arxiv.org "service rate region" heterogeneous servers coding
site:arxiv.org "service rate" MDS failure repair scheduling
site:arxiv.org batch codes integral scheduling fractional matching service rate
"heterogeneous servers" "service rate region" codes
"server capacities" "service rate region" coded storage
"node failures" "service rate region" coded distributed storage
```

The returned title/abstract screens recovered the direct sources above, the 2025 Hamming-code
preprint, and failure/latency papers outside the SRR-minor question; no same-code failure-facet result
was located. Three dated OpenAlex title/abstract screens used the verbatim searches
`"service rate region" failures coded storage`, `"service rate region" heterogeneous capacities`,
and `"integral service rate" batch codes`, restricted to 2025-01-01 through 2026-07-19. They
returned respectively 4, 2, and 0 records; all six nonempty records were screened, with only the
known MDS-SRR paper directly relevant.

The pinned forward seed for *The Oval Strikes Back* is arXiv:2601.16628 / OpenAlex
`W7125714066` / Semantic Scholar `9623f2b0f0742c20054bf427b7ef90f1d2301508`.
OpenAlex reported 0 citing works and an explicit `cites:W7125714066` query returned an empty result
set. Semantic Scholar reported 1 citing work; its sole record was screened at title, abstract, and
metadata depth and is the 2026 journal version of Ly--Soljanin's already-read MDS/fractional-matching
paper (`10.1109/TIT.2026.3662151`), which does not contain the C353 result. Crossref's pinned DOI
filter for `10.48550/arXiv.2601.16628` returned zero seed records, so its citation count is
**unavailable**, not zero. The discrepancy is recorded rather than collapsed.

zbMATH Open's exact-title API query returned no record. MathSciNet was not reachable and is **NOT
COVERED**; Google Scholar automated access was not attempted. Accordingly the defensible wording is
"no predecessor was located in the covered search," not "first" or "novel."

## Evidence and replay

From `/home/tavis/src/othello` run:

```sh
python3 notes/2026-07-19-c353-mirror-mixed-failure-scheduling.py --check
sha256sum notes/2026-07-19-c353-mirror-mixed-failure-scheduling.py \
  notes/2026-07-19-c353-mirror-mixed-failure-scheduling.json
```

To regenerate the candidate certificates with SciPy 1.16.3 and immediately verify them:

```sh
nix-shell -p 'python3.withPackages (ps: [ ps.scipy ])' --run \
  'python3 notes/2026-07-19-c353-mirror-mixed-failure-scheduling.py --generate --check'
```

There is no random seed. Serialization is sorted, timestamp-free JSON. The 56 LPs comprise two
parameter pairs times all `binom(8,2)=28` failure sets.

| Load-bearing artifact | Bytes | SHA-256 |
|:--|--:|:--|
| `notes/2026-07-19-c353-mirror-mixed-failure-scheduling.py` | 8,932 | `d92fe4c7cb14c65391aee969ecec9d9153b567fec04814f10df0765f825dfccb` |
| `notes/2026-07-19-c353-mirror-mixed-failure-scheduling.json` | 98,561 | `6df3ab7b84488b78a37959a690166e5167af7beae3788f11af29f6b8367d8c38` |

The trusted mathematical boundary is finite-field arithmetic in `F_7`, linear-span semantics for
recovery sets, and rational LP weak duality. The checker trusts Python integer and rational
arithmetic. It does not trust SciPy for the final equalities.

## Consequences

C353 clears its entry and exit gate with a local exact failure-capacity theorem. C355 may now use
these two coloured hypergraphs as its integral-scheduling pilot, and C358 may seek an all-field or
adversarial-failure theorem without repeating the local separation. C353 itself stops here: a
family census or an extrapolation from `q=7` would not strengthen the proved conceptual point.
