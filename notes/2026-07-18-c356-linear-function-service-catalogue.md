# C356: quadratic linear-function service catalogue

**Date:** 2026-07-19  
**Lane:** `crowns`  
**Verdict:** **BOUNDED NEGATIVE; EXACT PRIVATE REPEATED-FUNCTION CATALOGUE, NO NEW MIXED-SERVICE TRADEOFF**

## Result

The `q(q-1)/2` internal points of an odd conic do form a quadratic catalogue of requested
projective linear functions on three information symbols. Store the `q+1` conic-column symbols on
`q+1` noncolluding servers. Every internal function has `(q+1)/2` secant-pair recovery sets, and
these pairs partition the servers.

This gives an exact elementary privacy protocol: choose one recovery pair uniformly, ask its two
servers only for their raw stored symbols, and combine them at the client. For every requested
function and every server, the transcript is `CONTACT` with probability `2/(q+1)` and `SILENT`
otherwise. Thus the request is information-theoretically private from each individual server, the
download is two field symbols, and `(q+1)/2` identical requests can be served integrally on disjoint
pairs. Privacy against two colluding servers is not claimed.

The construction does **not** clear C356's operational gate:

1. The catalogue has rank three. Its quadratic cardinality is therefore not a storage or
   communication dimension: storing any basis already represents every listed function.
2. Private linear/private function computation already treats arbitrary catalogues of dependent
   linear functions, with the governing capacity depending on coefficient-matrix rank rather than
   the raw number of named functions.
3. Functional PIR/batch codes already formalize servers storing linear combinations and disjoint
   recovery of requested linear combinations. The conic is only a restricted-function instance,
   since it omits the external and conic projective functions.
4. The hoped-for mixed integral advantage fails at the first nontrivial level. Exact enumeration
   gives universal mixed concurrency only `2` at both `q=5` and `q=7`.

Accordingly the surviving theorem is a clean restricted-catalogue privacy/availability statement,
not a new privacy, concurrency, communication, or storage tradeoff. C356 stops at its mandatory
gate.

## Exact small-field gate

The certificate uses the conic columns

`(1,t,t^2)` for `t in F_q`, together with `(0,0,1)`.

It projectively enumerates every point, selects exactly those having `(q+1)/2` conic secants,
checks that every selected secant matching partitions all servers, solves the two recovery
coefficients, and replays recovery for all `q^3` information vectors. It then enumerates every
request multiset through the maximum pair-only concurrency and searches for vertex-disjoint
recovery pairs.

| `q` | catalogue | pairs/function | request size | multisets | failures | distinct failures |
|---:|---:|---:|---:|---:|---:|---:|
| 5 | 10 | 3 | 1 | 10 | 0 | 0 |
| 5 | 10 | 3 | 2 | 55 | 0 | 0 |
| 5 | 10 | 3 | 3 | 220 | 120 | 60 |
| 7 | 21 | 4 | 1 | 21 | 0 | 0 |
| 7 | 21 | 4 | 2 | 231 | 0 | 0 |
| 7 | 21 | 4 | 3 | 1,771 | 14 | 14 |
| 7 | 21 | 4 | 4 | 10,626 | 4,515 | 2,121 |

The first `q=5` obstruction requests `(1,0,2)` twice and `(1,1,4)` once. The first `q=7`
three-request obstruction consists of the distinct functions `(1,0,1)`, `(1,2,6)`, and
`(1,3,6)`. These are pair-recovery obstructions, not impossibility results for protocols allowed
larger recovery sets, replicated storage, preprocessing, or interaction.

## Reproducibility

From the repository root:

```text
python3 notes/2026-07-18-c356-linear-function-service-catalogue.py --check
```

Artifacts:

| artifact | bytes | SHA-256 |
|:--|--:|:--|
| `notes/2026-07-18-c356-linear-function-service-catalogue.py` | 7,040 | `0bce09eb175a454345e6cbe1063f7cb542b215c1664b017d4bfc6997eb3d0eff` |
| `notes/2026-07-18-c356-linear-function-service-catalogue.json` | 4,077 | `88ea7a1fe236919e3c8cbad5966e83ae93cc03e60160bf2c27685f74874d1a4a` |

The JSON is canonical (`sort_keys=True`, fixed indentation, no timestamps or host paths).
`--check` independently regenerates it in memory and compares the exact bytes. Within generation,
recovery is independently replayed on every information vector rather than inferred only from the
incidence determinant. The trusted boundary is the Python interpreter and the direct exhaustive
prime-field arithmetic. The certificate does not cover nonprime odd fields or prove an all-`q`
mixed-concurrency theorem.

## Literature boundary

**Read-depth summary:** zero of the seven individually characterized sources below were read at
full text. Four cached papers were read partially at the exact sections stated; three were used at
abstract/metadata depth. The negative verdict does not assert that no related paper exists: it
rests on direct model containment plus the exact failure of C356's own operational gate.

- Kılıç--Ravagnani--Salizzoni, *The Length of Functional Batch and PIR Codes*, arXiv:2508.02586v2.
  **Read depth: partial** — arXiv PDF, introduction, Definitions 2.2--2.4, Open Problems
  3.12--3.13, and the discussion of variation with field size. Cache key `arXiv:2508.02586`,
  SHA-256 `d5fba6fcd2ec1c542f870544637e16f6a33680d220a06f7d76ec4988b556b3cd`.
  This is the current arbitrary-finite-field length framework and supplies the precise full-function
  boundary that the internal-only catalogue does not meet.
- Zhang--Yaakobi--Etzion, *Bounds on the Length of Functional PIR and Batch Codes*,
  arXiv:1901.01605v2 (preprint corresponding to the later published article).
  **Read depth: partial** — arXiv PDF, general problem description and formal functional PIR/batch
  definitions. Cache key `arXiv:1901.01605`, SHA-256
  `a0f7a84fa40d200e8a155469559294f9fe2dedb796a1c6e42827ead3313f9aad`.
- Obead--Lin--Rosnes--Kliewer, *Capacity of Private Linear Computation for Coded Databases*,
  arXiv:1810.04230v1. **Read depth: partial** — arXiv PDF, system model, Definitions 2--4,
  Theorem 1, and the rank-dependent PLC capacity statement. Cache key `arXiv:1810.04230`,
  SHA-256 `a4c231039df21e42d8fb29519a328ee20015f8f67c47b299c894fc5a9f3b1a83`.
- Hollmann--Khathuria--Riet--Skachek, *Equal Requests are Asymptotically Hardest for Data
  Recovery*, arXiv:2405.02107. **Read depth: partial** — arXiv PDF, abstract, introduction, and
  conclusion. Cache key `arXiv:2405.02107`, SHA-256
  `1c8fd3b61f09eec3b67268f098f3883358f4ed1b6af4494b11f8d619258883fe`.
  Its concrete counterexamples and random/fractional results reinforce the need to separate
  repeated-function PIR availability from mixed functional-batch service.
- Obead--Lin--Rosnes--Kliewer, *Private Function Computation for Noncolluding Coded Databases*,
  arXiv:2003.10007. **Read depth: abstract/metadata only** — arXiv abstract and metadata; the
  abstract covers PLC and higher-degree PPC with Lagrange-coded computation. Cache key
  `arXiv:2003.10007`, SHA-256
  `d31cfff894ff101ac3f94cbf34db541f80d18beb63187e80c40dcdb319c7ca19`.
- Sun--Jafar, *The Capacity of Private Computation*, arXiv:1710.11098.
  **Read depth: abstract/metadata only** — arXiv abstract and metadata. Cache key
  `arXiv:1710.11098`, SHA-256
  `7dbb7bc12e0c71bb0644921238716e60396c039869e8b0efdded5acdcf4fecc8`.
- Banawan--Ulukus, *Multi-Message Private Information Retrieval: Capacity Results and
  Near-Optimal Schemes*, arXiv:1702.01739. **Read depth: abstract/metadata only** — arXiv abstract
  and metadata. Cache key `arXiv:1702.01739`, SHA-256
  `9b35d88e4f871aa6ece756eca652410f06e7b82df8797e9978290831bcde9e14`.
  MPIR requests independent stored messages and therefore does not turn this rank-three dependent
  function list into `Theta(q^2)` information objects.

The load-bearing searches, run on 2026-07-19, were:

```text
private linear computation capacity coded databases linear functions paper
function private information retrieval linear combinations coded storage paper
functional batch codes linear functions private information retrieval paper
multi-message private information retrieval linear combinations MDS coded storage
"Bounds on the Length of Functional PIR and Batch Codes" conic OR projective
"functional PIR" "partial" catalogue linear functions finite field
```

The searches covered arXiv and ordinary web indexing through the stated date. MathSciNet and
Google Scholar were **NOT COVERED** (authentication/automation limits), and no MathSciNet/zbMATH
absence claim is made. Forward results were inspected only to identify the adjacent 2026
minimum-length work; no exhaustive citing-set negative is used.

## Bounded adjacent-crown extraction

The exact pre-emption is twofold: PLC/private-computation work already handles dependent linear
candidate catalogues, and functional PIR/batch work already owns disjoint recovery of linear
functions. The surviving conic fact is its restricted internal catalogue with a particularly simple
uniform-pair privacy protocol.

Three adjacent gaps were inspected: the arbitrary-field full functional-batch open problems, the
field-size dependence of `FB(k,t,q)`, and the equal-versus-mixed request gap. Six bounded candidates
were formulated:

1. an extremal theory for restricted projective function catalogues;
2. collusion-private conic catalogue retrieval;
3. an all-odd-`q` rainbow-number theorem for the internal secant matchings;
4. a distinct-request-only conic batch theorem;
5. a storage lower bound parameterized by catalogue rank and size;
6. a fractional private mixed-service protocol.

The top two operational candidates fail cheaply. Restricted-catalogue mixed service has universal
concurrency only two at both test fields, with distinct-request failures already at `q=5,7`.
Collusion privacy also fails for the raw-pair protocol because two contacted servers jointly learn
the chosen secant; repairing that requires generic PLC masking/replication and exposes no
conic-specific gain. Candidates 3--6 either retain only a combinatorial obstruction, reduce to rank
or fractional service, or lack an operational metric after these failures. No successor is
allocated.

## Scope

This report proves neither an unrestricted all-field theorem nor a new capacity formula. It does
not compare upload bit complexity, server computation, robustness, or collusion thresholds beyond
the stated raw-symbol protocol. Its bounded contribution is to formalize the proposed catalogue,
certify its exact privacy semantics and small-field integral behavior, and close the claimed crown
without promoting catalogue cardinality into information dimension.
