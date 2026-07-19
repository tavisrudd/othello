# C355: integral oval service has an all-odd-field coloured hole

**Date:** 2026-07-19

**Lane:** `crowns`

**Verdict:** **THEOREM; ALL-ODD-FIELD SHARP ONE-REQUEST COLOURED BATCH DEFICIT**

## Result

Let (q\ge5) be an odd prime power and index the maximum-length conic code's helpers by

\[
P_t=(t^2,t,1)\quad(t\in\mathbf F_q),\qquad P_\infty=(1,0,0).
\]

Choose a nonsquare (a\ne-1), and request the two linear functions represented by

\[
X_M=(-a,0,1),\qquad X_N=(0,1,0).
\]

Projection from these points induces the involutions

\[
M(t)=a/t,\qquad N(t)=-t
\]

on the conic parameter line.  The first centre is internal and the second external.  Delete two
helpers as follows:

\[
F=\begin{cases}
\{0,\infty\},&q\equiv1\pmod4,\\
\{r,-r\},\ r^2=-a,&q\equiv3\pmod4.
\end{cases}
\]

Then, with unit capacity on the (q-1) live helpers, the integer demand

\[
(d_M,d_N)=\left(\frac{q-3}{2},1\right)
\]

is fractionally serviceable but has no integral schedule.  Reducing the first coordinate by one
gives an integral schedule.  Thus the coloured demand semigroup has a hole for every odd prime
power (q\ge5), and the rounding loss on this demand is sharply one request.

Equivalently, after extending (X_M,X_N) to a generator basis, the damaged conic code has a
specific size-((q-1)/2) multiset of two data-symbol requests that fractional service accepts but
primitive multiset batch service rejects; the corresponding size-((q-3)/2) multiset obtained by
dropping one (X_M) request is serviceable.  This is a witness for that basis and damage pattern,
not a claim that every smaller request multiset is serviceable or a full batch-parameter
classification.

## Proof

For a centre (X=(x,y,z)), the second intersection of the line (XP_t) with the conic has
parameter

\[
u=\frac{yt-x}{zt-y}.
\]

This gives (M(t)=a/t) and (N(t)=-t).  Since the fixed-point equation for (M) is (t^2=a),
(M) is fixed-point-free.  Its secants are therefore a perfect matching of the (q+1) conic
helpers.  The only shared (M/N) pair satisfies (t^2=-a).

If (q\equiv1\pmod4), then (-a) is nonsquare, so there is no shared pair; deleting the (M)-pair
(\{0,\infty\}) leaves a perfect (M)-matching with no shared (N)-edge.  If
(q\equiv3\pmod4), then (-a) is square and its two roots form the unique shared pair; deleting
that pair again leaves a perfect (M)-matching with no shared (N)-edge.  A suitable
(a\ne-1) exists: for (q\equiv1\pmod4), neither (1) nor (-1) is nonsquare; for
(q\equiv3\pmod4), there is a nonsquare other than (-1) because (q\ge7).

Put (m=(q-1)/2).  Choose a nonzero (t) outside the deleted exceptional pair.  The four distinct
vertices

\[
\{t,a/t,-t,-a/t\}
\]

carry the alternating cycle with (M)-edges

\[
\{t,a/t\},\quad\{-t,-a/t\}
\]

and (N)-edges

\[
\{t,-t\},\quad\{a/t,-a/t\}.
\]

Give each of these four edges weight (1/2), and give every other live (M)-edge weight one.  Every
helper has load one, while the two services are (m-1=(q-3)/2) and one.  This proves fractional
feasibility.

An integral realization would use (m) recovery sets on (2m) unit-capacity helpers.  Neither
target is a live carrier column, so every recovery set has size at least two.  Capacity saturation
therefore forces every chosen set to be a pair and all (m) pairs to form a perfect matching.
The unique requested (N)-edge is not an (M)-edge, so its endpoints belong to two distinct
(M)-edges.  At most (m-2) (M)-edges remain disjoint from it, fewer than the demanded (m-1).
This contradiction also rules out using minimal recovery triples: even one triple would exceed the
total live capacity.

Finally choose any live (N)-edge and take all (M)-edges disjoint from it.  Exactly two (M)-edges
are excluded, giving the integral demand ((m-2,1)).  Hence the one-request loss is necessary and
sufficient for this constructed demand.

## Exact q=7 census

The C353 pilots comprise two marked (E,E,I,I) frames and all 28 two-helper failures for each.
Colour and helper relabelling reduce these 56 damaged recovery hypergraphs to 25 exact classes.
For each class and each (T=1,2,3,4), the checker exhausts every nonnegative four-colour demand of
total at most (3T), tests integral schedulability using all minimal recovery sets, and hashes the
sorted feasible set.  The candidate counts per class are respectively (35,210,715,1820).

The (T=1) scan has 15 canonical fractional holes.  Each stored hole has an exact rational
allocation and is independently rejected by the integral schedule search.  The smallest displayed
C353 representative is `(delta,b)=(5,2)`, failed helpers `0,1`, and demand `(0,0,2,1)`.  On the six
live helpers, the relevant pair matchings are

\[
M=\{03,14,25\},\qquad N\supseteq\{02,35\}.
\]

The allocation (14+\tfrac12(03+25+02+35)) is fractional and saturating, while either (N)-edge
meets two (M)-edges and leaves only one usable (M)-edge.  This is the q=7 instance of the uniform
four-cycle proof above.  The census is a bounded consistency and minimization check; it is not the
proof of the all-field theorem.

## Literature audit and novelty boundary

This audit names eight sources.  Three were read at full text in the audited C334/C353 bundles and
their relevant sections were rechecked here; five were read partially at the sections stated below.
No located source combines conic projection involutions, exact coloured quotas, and an explicit
all-odd-field fractional/integral batch obstruction.  The defensible wording is “no predecessor was
located in the covered search,” not an unqualified priority claim.

- Di Giusto--Ravagnani--Soljanin, *The Oval Strikes Back*, arXiv:2601.16628. **Read depth: full
  text**, cached preprint, key `arXiv:2601.16628`, SHA-256
  `ab80a873ecf39ca7c130252d78eb07f2e2aa8b966f465e7f44dbdb3c9bf6871b`; inherited from C334/C353
  and rechecked at its PIR/integral-SRR discussion and Section V.  It proves the stronger
  homogeneous oval simplex, not coloured integral schedules after helper deletion.
- Kazemi--Karimi--Soljanin--Sprintson, *A Combinatorial View of the Service Rates of Codes Problem,
  its Equivalence to Fractional Matching and its Connection with Batch Codes*, arXiv:2001.09146.
  **Read depth: partial**, cached preprint, key `arXiv:2001.09146`, SHA-256
  `a52f36467c4aba2deffaa0df820e98f7d43d6c82b1ca96a7c90db890000571b9`; definitions of integral
  SRR and matching, Section IV-A/B, Theorem 4, and Corollary 5 read.  It supplies the exact bridge
  from integral service to primitive multiset batch/PIR codes, but no oval-specific hole.
- Alfarano--Kilic--Ravagnani--Soljanin, *The Service Rate Region Polytope*, arXiv:2303.04021.
  **Read depth: full text**, cached preprint, key `arXiv:2303.04021`, SHA-256
  `ffc9a8edbd513ad70b3336b27dd5fc475e4b4dad4665c10aed7c2794becffce4`; inherited from C334/C353
  and rechecked at the rational-polytope formulation.  It controls fractional SRRs, not integer
  coloured demand semigroups.
- Ly--Soljanin, *Service Rate Regions of MDS Codes & Fractional Matchings in Quasi-uniform
  Hypergraphs*, arXiv:2504.17244. **Read depth: full text**, cached preprint, key
  `arXiv:2504.17244`, SHA-256
  `3943e2b5ba2a1bc0a84b5c62bc7f5f7d1c6d3551fbff4b91f4fd1b8290eb2700`; inherited from C334/C353
  and rechecked at the capacity-vector and fractional-cover model.  Its results remain fractional.
- Torres, *Normality of k-Matching Polytopes of Bipartite Graphs*, arXiv:2306.11910. **Read depth:
  partial**, cached preprint, key `arXiv:2306.11910`, SHA-256
  `25d5d3eb91b209ee55f4c7fb39b7c48d84955be61310b3c2ad0235d6a8e3ff93`; abstract, Sections 2--3,
  and the Section 4 main theorem read.  It proves normality for fixed-size bipartite matching
  polytopes; C355's hole occurs after projecting and prescribing edge-colour counts.
- Eisley--Matsushita--Vindas-Melendez, *Matching Polytopes, Gorensteinness, and the Integer
  Decomposition Property*, arXiv:2407.08820. **Read depth: partial**, cached preprint, key
  `arXiv:2407.08820`, SHA-256
  `50fc73120cd086b5c7e4966cad7c422115023da87d51ef676e19812b42330586`; abstract, introduction,
  Section 2 definitions, and statements of the Section 3--4 results read.  Its sufficient IDP
  results concern ordinary matching polytopes, not the coloured quotient used here.
- Deza--Gerard--Ma--Pokutta, *Bounded-Support Additive Latin Transversals via Color-Counted
  Matching*, arXiv:2607.11241. **Read depth: partial**, cached v1 preprint, key
  `arXiv:2607.11241`, SHA-256
  `af5f31307c4166252b74daad90706b1009323a1a52ac1c17ca981f0d806b70b3`; abstract, introduction,
  Color-Counted Matching definition, main algorithm statement, and reduction overview read.  It
  gives a randomized algorithm for exact prescribed colour counts but no conic family or
  fractional/integral separation.
- Aprile--Di Summa, *The red-blue-yellow matching problem*, arXiv:2603.18754v2. **Read depth:
  partial**, cached v2 preprint, key `arXiv:2603.18754`, SHA-256
  `0f05e2bbfdea08d5df368caaccca57449bc449eccd31e349a1a3be073f4ba0e8`; abstract, introduction,
  problem definition, and Theorem 3 read.  It gives a deterministic additive-three matching-size
  and one-blue-edge quota approximation, not this exact geometric obstruction or sharp local loss.

Load-bearing searches run on 2026-07-19 were:

```text
matching polytope integer decomposition property normality edge polytope primary paper
colored matching polytope quota integer decomposition property primary paper
batch codes integral service rate region fractional matching paper
exact matching prescribed number red edges colored matching primary paper
matching with prescribed color quotas exact matching problem paper
rainbow matching color quotas polytope primary research
"oval" "integral service rate" batch code
conic projection involution colored matching quota
"color-counted matching" service rate codes
```

The searches recovered the sources above, including the six-day-old color-counted-matching
preprint, but no service/batch application of the conic four-cycle obstruction.  C353's same-day
forward-citation closure for the pinned oval seed arXiv:2601.16628 / OpenAlex `W7125714066` /
Semantic Scholar `9623f2b0f0742c20054bf427b7ef90f1d2301508` is inherited: OpenAlex reported zero;
Semantic Scholar reported one, the already-read 2026 journal version of the Ly--Soljanin MDS paper;
Crossref's pinned DOI filter returned no seed record, so its count was unavailable rather than zero.
zbMATH Open's exact-title query returned no record.  MathSciNet was not reachable and is **NOT
COVERED**; Google Scholar automated access was not attempted.

## Evidence and replay

From `/home/tavis/src/othello` run:

```sh
python3 notes/2026-07-18-c355-integral-oval-service.py --check
sha256sum notes/2026-07-18-c355-integral-oval-service.py \
  notes/2026-07-18-c355-integral-oval-service.json
```

To regenerate the q=7 fractional witnesses with SciPy and then check everything exactly:

```sh
nix-shell -p 'python3.withPackages (ps: [ ps.scipy ])' --run \
  'python3 notes/2026-07-18-c355-integral-oval-service.py --generate --check'
```

There is no random seed.  JSON serialization is sorted and timestamp-free.  Generation uses SciPy
only to discover sparse allocations.  The checker verifies those allocations with
`fractions.Fraction`, rebuilds all recovery sets from C353's independently checked conic model,
recomputes every integral feasibility hash, and reconstructs twelve odd-prime fixtures in both
congruence classes.  As an independent implementation check, it also replays all 875 class/demand
cases at (T=1) and 210 cases for the first class at (T=2) with a separate memoized recursive
oracle.  The all-prime-power statement rests on the symbolic proof above; finite prime fixtures do
not substitute for it.

| Load-bearing artifact | Bytes | SHA-256 |
|:--|--:|:--|
| `notes/2026-07-18-c355-integral-oval-service.py` | 13,707 | `872b197741e1fc4c0a72f6255b91607de9525ac4191a1a4073074977c8c17a4c` |
| `notes/2026-07-18-c355-integral-oval-service.json` | 82,919 | `bf555e26ef13799cfb4da87d6dfc9e42c58fa40cf7c5908ee8e73b701d279f25` |

The trusted computational boundary is Python integer/rational arithmetic, the C353 recovery-set
constructor pinned by its recorded SHA-256, and exhaustive memoized search over the stated q=7
domain.  The checker does not prove the symbolic field identities or the literature negative.

## Consequences and boundary

Ordinary matching-polytope integrality or IDP does not survive automatic projection to prescribed
colour-count demand coordinates.  In the conic code this failure is not sporadic: the projection
involutions expose the same alternating four-cycle over every odd field.  Fractional oval SRR
membership therefore cannot by itself certify even one-slot primitive multiset batch service.

This does not classify the complete integer demand semigroup, prove a uniform rounding theorem for
all demands or all (T), or address stochastic queues.  The exact q=7 (T\le4) census is bounded,
and the all-field theorem concerns one explicit two-colour demand after two helper deletions.
