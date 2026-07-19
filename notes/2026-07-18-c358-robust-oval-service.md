# C358: a sharp adversarial-deletion frame from a nonsplit Klein four group

**Date:** 2026-07-19  
**Lane:** `crowns`  
**Verdict:** **THEOREM; FIXED-POINT-FREE KLEIN FRAMES ARE GLOBALLY OPTIMAL AFTER TWO HELPER FAILURES**

## Result

Let `q >= 7` be an odd prime power with `q = 3 mod 4`, and index the `q+1` helpers by
the conic

\[
P_t=(t^2,t,1)\quad(t\in\mathbf F_q),\qquad P_\infty=(1,0,0).
\]

There is a projective frame `T=(T_1,T_2,T_3)` of three internal targets whose three
projection involutions generate a fixed-point-free Klein four group on the conic.  If `f` helpers
are deleted adversarially and allocations may adapt to the deleted set, write `rho_f(T)` for the
largest `lambda` such that `(lambda,lambda,lambda)` remains serviceable for every deletion set of
size `f`, using all minimal recovery sets.  Then

\[
(\rho_0(T),\rho_1(T),\rho_2(T),\rho_3(T))
=\left(\frac{q+1}{6},\frac q6,\frac{q-1}{6},\frac{q-3}{6}\right).
\]

Moreover, `rho_2(T)=(q-1)/6` is best possible among **every** projective target frame, including
frames containing systematic/conic targets.  Thus the exact two-failure robust diagonal region of
the optimal frame is

\[
\{(\lambda,\lambda,\lambda):0\leq\lambda\leq(q-1)/6\}.
\]

This is the damage level isolated by C353.  C353's exact `q=7` pair showed that equal point types do
not determine failure service (`2/3` versus `5/8` for two `E/E/I/I` four-target systems).  C358
therefore optimizes the complete coloured recovery hypergraph rather than repeating a type census.
The resulting invariant is the joint orbit structure of the three projection involutions: the
optimal construction has `K_4` helper blocks.

The theorem is an adversarial fractional-service statement.  It is not an integral batch theorem,
a stochastic-failure result, or a characterization of the entire three-dimensional intersection of
the damaged SRRs.

## Construction and proof

Choose a nonsquare `delta` in `F_q`.  The character sum

\[
\sum_{u\in\mathbf F_q}\chi(u^2-\delta)=-1
\]

shows that `(q+1)/2` values of `u` make `u^2-delta` a nonsquare; fix one.  In `PGL_2(q)` take the
trace-zero matrices

\[
A=\begin{pmatrix}0&\delta\\1&0\end{pmatrix},\qquad
B=\begin{pmatrix}u&-\delta\\1&-u\end{pmatrix},\qquad C=AB.
\]

They anticommute before projectivization, so their projective classes are the three nonidentity
elements of a Klein four group.  The corresponding target points are

\[
T_A=(-\delta,0,1),\qquad T_B=(\delta,u,1),\qquad
T_C=(\delta u,\delta,u).
\]

Their discriminants are `delta`, `u^2-delta`, and `-delta(u^2-delta)`.  All are nonsquares because
`-1` and `delta` are nonsquares, so all three involutions are fixed-point-free.  The target
determinant is `2 delta (delta-u^2)`, hence the targets form a frame.  The Klein action on the conic
is free and partitions the `q+1` helpers into `(q+1)/4` four-point orbits.  On every orbit the three
coloured recovery matchings are exactly the three one-factors of `K_4`.

Put `m=(q+1)/4`.  On an intact block, weight every edge by `1/3`; this serves `2/3` in every colour
and saturates all four helpers.  A block with one deletion is a rainbow triangle; weight its three
edges by `1/2`, serving `1/2` in each colour.  These schedules, with colour rebalancing across intact
blocks, give `(q+1-f)/6` for `f=0,1,2`.  Two deletions in one block leave one coloured edge; assigning
that unit to its colour and rebalancing the intact `K_4` blocks gives `(q-1)/6` in all three colours.

For three deletions, three different damaged blocks and the `2+1` distribution both serve at least
`(q-3)/6`; in the latter case the two-block local schedule consists of a surviving coloured edge
of weight `3/4`, two rainbow-triangle edges of weight `1/2`, and two cross-block minimal triples of
weight `1/4`, followed by scaling and intact-block superposition.  If all three failures lie in one
block, ignore its lone survivor and use the `m-1` intact blocks, giving `(q-3)/6`.

Every recovery of an internal target uses at least two helpers.  Total live capacity therefore gives
`6 rho_f <= q+1-f`, proving equality for `f<=2`.  When three failures leave one point of a damaged
Klein block, give that point dual weight zero, every other live helper weight `1/6`, and every colour
weight `1/3`.  Every available recovery pair avoids the zero-weight point and every recovery triple
contains at least two positive-weight helpers.  This is a dual certificate of `(q-3)/6`.

For global two-failure optimality, a frame with at most two conic targets can have all of its
systematic target helpers deleted; every remaining recovery then has size at least two, forcing
`rho_2 <= (q-1)/6`.  The all-conic frame is one orbit.  Deleting two of its targets gives the exact
bound

\[
\rho_2^{OOO}=\begin{cases}
(q-1)/7,&q\leq7,\\
(q+1)/9,&q\geq9,
\end{cases}
\]

by charging three helpers to each failed-target request and first one, then three, helpers to the
surviving systematic target.  Both expressions are strictly below `(q-1)/6` for
`q=3 mod 4`, `q>=7`.  The Klein frame is therefore globally optimal.

## Exact bounded orbit gate

Every conic-stabilizer frame orbit was checked at `q=5,7,9,11` for every failure set with
`0<=f<=3`.  The table gives the globally best robust equal rate and the type of one certified
winner.

| q | f=0 | f=1 | f=2 | f=3 |
|---:|:---|:---|:---|:---|
| 5 | `4/3` (`OOO`) | `1` (`OOO`) | `4/7` (`OOO`) | `1/3` (all types tie) |
| 7 | `14/9` (`OOO`) | `11/9` (`OOO`) | `1` (`III`, Klein) | `2/3` (`III`, Klein) |
| 9 | `16/9` (`OOO`) | `3/2` (`III`) | `9/7` (`III`) | `1` (several types) |
| 11 | `2` (several types) | `11/6` (`III`) | `5/3` (`III`, Klein) | `4/3` (`III`, Klein) |

The orbit counts are `50,109,203,339`.  For every orbit and `f`, the JSON stores one failed set and
an exact rational dual proving that the orbit cannot exceed the displayed field optimum.  For one
winning orbit it stores an exact rational primal allocation for **every** failure set.  This is
`4*(50+109+203+339)=2,804` orbit upper certificates, together with all winner lower certificates.
The checker reconstructs minimal recovery sets both geometrically (secants plus irredundant triples)
and by direct subset-span testing before checking every rational inequality.

The census exposes two useful cautions.  First, the optimum changes with both `q` and `f`: systematic
frames win the small-field one-failure problem, while internal frames win from `q=9`.  Second,
`III` is not itself the answer: at `q=9`, two of four one-failure-optimal internal orbits remain
strictly better after two failures.  The Klein block structure, not target type, proves the uniform
two-failure theorem.

## Literature audit and novelty boundary

This report relies on five service/oval sources previously read at full text for C334/C353, three
new failure-adjacent primary sources read partially here, and the same-day C353 forward-citation
closure.  No located work gives the fixed-point-free Klein-frame theorem or the exact robust
diagonal above.  The defensible claim is only “no predecessor was located in the covered search.”

- Di Giusto--Ravagnani--Soljanin, *The Oval Strikes Back*, arXiv:2601.16628. **Read depth: full
  text**, cached preprint, key `arXiv:2601.16628`, SHA-256
  `ab80a873ecf39ca7c130252d78eb07f2e2aa8b966f465e7f44dbdb3c9bf6871b`; inherited from C334 and
  rechecked through C353.  It proves the homogeneous all-internal oval simplex, not an adversarial
  deletion optimum over target frames.
- Ly--Soljanin, *Service Rate Regions of MDS Codes & Fractional Matchings in Quasi-uniform
  Hypergraphs*, arXiv:2504.17244. **Read depth: full text**, cached preprint, key
  `arXiv:2504.17244`, SHA-256
  `3943e2b5ba2a1bc0a84b5c62bc7f5f7d1c6d3551fbff4b91f4fd1b8290eb2700`; inherited from C334 and
  rechecked here at Section II-B.  It defines the capacity-vector model and then assumes uniform
  unit capacities; it does not optimize failure minors.
- Alfarano--Kilic--Ravagnani--Soljanin, *The Service Rate Region Polytope*, arXiv:2303.04021;
  Alfarano--Ravagnani--Soljanin, *Dual-Code Bounds on Multiple Concurrent (Local) Data Recovery*,
  arXiv:2201.07503; and Ly--Soljanin, *Maximal Achievable Service Rates of Codes and Connections to
  Combinatorial Designs*, arXiv:2506.16983. **Read depth: full text**, cached preprints with keys and
  hashes recorded in C353's audit; inherited from that report.  They supply the rational-polytope,
  concurrent-recovery, and design boundaries, not this damaged-frame classification.
- Silberstein, *Fractional Repetition and Erasure Batch Codes*, arXiv:1405.6157. **Read depth:
  partial**, cached preprint, Section 3 and the conclusion read, key `arXiv:1405.6157`, SHA-256
  `03ab0f007366554ab0e6bc526c044914dbe9919d155aa25b7e26e47250a2e0a3`.  Its ECBC condition asks
  for integral retrieval after any failed-node set in a replication incidence matrix.
- Le--Dau--Ngo--Nguyen, *New Results on Erasure Combinatorial Batch Codes*, arXiv:2310.00467.
  **Read depth: partial**, cached preprint, Definition 1, the Hall-condition setup, and conclusion
  read, key `arXiv:2310.00467`, SHA-256
  `b3c9bb74681b60b49ee361073e119e54d7413cd94ece6c9e9779d6f7c5f37777`.  It generalizes ECBCs to
  `t>=1`; it does not treat fractional MDS SRRs or projective target-frame optimization.
- Carvalho--Neumann, *A family of codes with variable locality and availability*, arXiv:2107.13487.
  **Read depth: partial**, cached preprint, introduction and Definition 1.1 read, key
  `arXiv:2107.13487`, SHA-256
  `549e0a3d58a402668169850aa68653fff58b86114613b20308f9f428157302c9`.  It combines local distance
  and disjoint availability, rather than simultaneous fractional service under common damage.

The load-bearing discovery queries run on 2026-07-19 were:

```text
site:arxiv.org "service rate region" heterogeneous capacities failures coded storage
site:arxiv.org robust service rate region MDS code server failures
site:arxiv.org batch codes erasures resilient batch codes locally repairable
"service rate region" "node failures"
"service rate region" adversarial failures
"oval" "service rate region" failures
"MDS" "service rate region" heterogeneous capacities
```

The returned title/abstract screens were used for discovery, not treated as exhaustively enumerable
databases.  They recovered the direct SRR/oval papers, ECBC papers, LRC-availability work, and
graph-specific matching-preclusion papers; none stated the present coloured fractional frame
theorem.  The pinned forward seed and same-day three-graph closure are inherited from C353:
arXiv:2601.16628 / OpenAlex `W7125714066` / Semantic Scholar
`9623f2b0f0742c20054bf427b7ef90f1d2301508`.  OpenAlex returned zero citing works; Semantic Scholar's
one record was the already-read 2026 journal version of the MDS/fractional-matching paper; Crossref
could not resolve the arXiv DOI seed, so its count is unavailable rather than zero.  zbMATH Open had
no exact-title record.  MathSciNet is **NOT COVERED**; Google Scholar automated access was not
attempted.

## Evidence and replay

From `/home/tavis/src/othello` run:

```sh
python3 notes/2026-07-18-c358-robust-oval-service.py --check
sha256sum notes/2026-07-18-c358-robust-oval-service.py \
  notes/2026-07-18-c358-robust-oval-service.json
```

To regenerate the complete certificate with SciPy used only for certificate discovery:

```sh
nix-shell -p 'python3.withPackages (ps: [ ps.scipy ])' --run \
  'python3 notes/2026-07-18-c358-robust-oval-service.py --generate'
```

There is no random seed.  JSON serialization is sorted and timestamp-free.  `--check` uses only
Python integer and `Fraction` arithmetic plus C354's deterministic finite-field implementation; it
does not import SciPy.  The trusted boundary is finite-field arithmetic, projective-span recovery
semantics, rational LP weak duality, and the imported C354 source whose SHA-256 is pinned inside the
certificate.  The symbolic Klein proof independently explains the `q=7,11` optimal rows; the exact
orbit bundle independently prevents that family argument from hiding a better small-field orbit.

| Load-bearing artifact | Bytes | SHA-256 |
|:--|--:|:--|
| `notes/2026-07-18-c358-robust-oval-service.py` | `16,080` | `199ee892f871cede1283811cade4f8be1819e5606623e4442ffa1235a3b65832` |
| `notes/2026-07-18-c358-robust-oval-service.json` | `2,022,795` | `00dff4da900ddfd06c20e1cfd4d2912ca2d72b259f67b607c136e574d34787a9` |

## Boundary

The result gives the full exact adversarial **diagonal** through three failures and a globally
optimal target frame for two failures when `q=3 mod 4`.  It does not claim the full damaged SRR,
optimality of the Klein frame for `f=0,1,3`, an all-odd-`q` construction when `q=1 mod 4`, integral
schedules, or heterogeneous nonbinary capacities.  The `q=5,9` rows are exact finite tests, not an
extrapolation.  Those exclusions are material: the orbit census itself shows phase changes outside
the theorem's congruence and damage regime.
