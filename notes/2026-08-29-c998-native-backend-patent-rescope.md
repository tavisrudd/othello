# C998 addendum — native CSS backend patent re-scope

**Lane**: `complete-ports`

**Date**: 2026-08-29

*Not legal advice.* This is an engineering prior-art reading, not a patentability or
freedom-to-operate opinion; nothing here may be relied on without counsel.

## Summary

The re-scope changes the verdict. The earlier landscape note
(`2026-08-29-c998-patent-landscape.md` §5) recommended filing on certified automorphism symmetry
reduction of a solver model, and found that claim space patent-empty. The native exact CSS-distance
backend is a materially better *eligibility* object and a materially worse *novelty* object: its
headline element — enumerating connected supports on the Tanner graph to obtain an exact distance or
a certified lower bound — is a named, published, benchmarked, open-source algorithm with a decade of
provenance (Dumer–Kovalev–Pryadko's irreducible/linked cluster method; `dist_m4ri` method 2). The
patent corpus remains empty around it, but §102 prior art does not have to be patented to anticipate.

What survives as a candidate residue is narrower than the four-element list in the commercialization
memo: the *branching rule* (branch only on coordinates incident to a currently-odd check, with
disjoint siblings and a zero-syndrome/zero-observation stop) combined with the one-sided projected
completion filter above the machine-word rank boundary. Two of the four listed elements —
connected-support enumeration itself, and the source-fingerprinted compiled artifact — are not
claimable on any reading.

Of the twenty sources named below, **two were read at full text** (the `dist_m4ri` README, and claim
1 of US 11,552,653 B2). The rest are abstract/metadata or secondary. The single largest evidence gap
is that **`dist_m4ri`'s C source was not read**, and the residue in §3 is stated over its *published
description* only. Reading `src/dist_m4ri.c` is a precondition to filing (§5).

## 1. What the native backend actually does

Distilled from `papers/complete-repair-ports/ergodis/src/css_distance.rs` (module doc and public
surface), `2026-08-29-c985-wide-css-backend-plan.md`, `2026-08-29-c985-native-css-backend-scaling-plan.md`,
and the three result notes. This is the object to be assessed, replacing the "symmetry reduction of
an ILP" framing.

1. **Connected-support enumeration.** A support in `ker(H)` decomposes into connected components in
   the graph joining coordinates sharing a check; every component is itself in the kernel; so a
   minimum-weight support with nonzero logical observation has a connected component of no greater
   weight with nonzero observation. Enumeration is therefore restricted to connected supports.
2. **Constraint-driven branching** (the `search_bounded_syndrome_driven` path). Rather than growing
   a cluster generically, the search picks a currently-odd physical check and branches only on
   coordinates incident to it. Every completion must take one, and connectivity is automatic because
   the odd check already meets the partial support. Sibling branches are made disjoint by a
   first-true exclusion chain; branch order is minimum-remaining-options (fail-first); a partial
   support with zero syndrome and zero logical observation stops expanding, since a minimum
   nontrivial support cannot properly contain a nonempty kernel support. Measured on BB288: weight-10
   negative fell from 20,118,660 candidates / 0.532 s to 19,412 / 0.00104 s.
3. **Fixed-width packed state with a projected completion filter.** Support and syndrome live in a
   fixed number of `u64` words per monomorph (compact 4+2, wide 5 words plus residual syndrome bits
   above 128, extra-wide and large variants up to 13 support words). Where the check rank exceeds 128
   the completion-filter key is a fixed GF(2)-linear projection of the full syndrome into a `u128`.
   **The one-sided guarantee:** a projection collision can only admit extra candidates, never cause a
   false prune; acceptance as a kernel support is decided against the full syndrome.
4. **Certified witness transport between CSS directions.** On BB360 and BB784 an independent checker
   proves that block swap followed by torus inversion `(r,c) -> (-r,-c)` maps the first physical row
   space onto the second and the first observability quotient onto the second, and transports a
   weight-24 witness to a valid witness for the other direction. Either direction's exhaustive record
   plus the isomorphism suffices; the second direct record is kept as an implementation control.
5. **Persisted, source-fingerprinted compiled artifact.** Versioned magic header, SHA-256 of the
   physical and logical matrices for source identity, SIMD BLAKE3 over the payload for corruption,
   packed column syndromes/observations/adjacency, exact one- and two-column tables, no-false-negative
   three- and four-column reachability filters. Fail-closed on source mismatch or malformed length;
   create-only output. Measured 1.61x cold-runtime improvement on the pinned C997 run with every
   candidate, pruning, distance and witness counter unchanged.
6. **Parallelism without a shared queue.** Static contiguous anchor partitioning, per-worker pre-sized
   DFS workspaces, cache-line-padded monotone bound mailboxes polled every 16,384 candidates,
   deterministic reduction after the parallel region. No allocation, locking, or cross-core witness
   copy in the enumeration loop.

Measured effect available as enablement: exact `[[784,24,24]]` in 127 s / 23.4 MiB RSS over 29.3
billion candidates; exact `[[360,12,24]]` in both directions where the QDistSAT benchmark records all
46 configurations timing out at 7,200 s; exact `[[1496,198,16]]` where the source published a
randomized upper bound only.

## 2. Closest prior art, element by element

### (a) Connected / irreducible-cluster enumeration for minimum distance

**Verdict: anticipated as a concept, with a public reference implementation. Not claimable on its own.**

| Reference | What it is | Distance from ergodis | Read depth |
|:---|:---|:---|:---|
| Dumer, Kovalev, Pryadko, *Numerical Techniques for Finding the Distances of Quantum Codes*, ISIT 2014, arXiv:1405.0348 | Introduces the "new linked-cluster technique" for classical and quantum LDPC codes; states it reduces the complexity exponent of all existing deterministic techniques for small relative distance, which includes all known qLDPC families | **This is the origin of element 1.** Same theorem, same enumeration principle, same target family | abstract/metadata only — arXiv abstract page, WebFetch 2026-08-29 |
| Dumer, Kovalev, Pryadko, *Distance verification for LDPC codes*, ISIT 2016, arXiv:1605.02410, DOI 10.1109/ISIT.2016.7541755 | Complexity bounds for distance verification in LDPC ensembles via erasure-correcting thresholds | Same, with the asymptotics | abstract/metadata only — arXiv abstract page, WebFetch 2026-08-29 |
| Dumer, Kovalev, Pryadko, *Distance Verification for Classical and Quantum LDPC Codes*, IEEE Trans. Inform. Theory (2017) | Journal version; named "irreducible cluster" technique | The reference `dist_m4ri` cites for its CC method | **secondary only** — characterised from the `dist_m4ri` README's citation and from search-result rows; the article itself was not retrieved. Volume/issue/pages deliberately omitted |
| **`dist_m4ri`, QEC-pages, Pryadko & Zeng, GPL-2.0** | Method 2 is described in its README as "Multithreaded **exhaustive** depth-first cluster enumeration to compute **exact distance** or establish a certified **lower distance bound**", which "recursively explores connected clusters starting from each column", distributes columns "dynamically among worker threads via lock-free atomic queues", scans `w = 1,2,…,w_max`, maintains a "codeword hash table", and tracks "the minimum non-zero syndrome weight observed for each cluster weight" in a "confinement hash" | **The single most dangerous reference.** Same output (exact distance or certified lower bound), same theorem, same shell-by-weight scan, multithreaded, hash-assisted, publicly available under GPL-2.0. Differences visible from the README: cluster growth is *per starting column*, not per unsatisfied check; work is distributed by a lock-free queue rather than static anchor partition; no persisted compiled artifact is documented; no projected completion filter is documented | **full text** — `README.md`, `master` branch, raw.githubusercontent.com, 2026-08-29, 14,710 bytes. Commit not pinned. **C source not read** |
| Webster, Jacob, Higgott, *Distance-Finding Algorithms for Quantum Codes and Circuits*, arXiv:2603.22532 (v1 2026-03-23, v2 2026-08-14); `codeDistance` package, MIT | Benchmarks exact methods (Brouwer–Zimmermann, connected cluster, SAT, MIP) against heuristics (random information set, syndrome decoders, Stim undetectable-error), and adds QDistEvol. The package exposes `dist_m4ri_CC` and `connectedClusterMW` under a "Connected Component Algorithms" heading alongside `GurobiDist`, `MIPDist`, `pySATDist`, `BZDistMW` | Publishes, benchmarks and packages exactly the comparison ergodis wants to win, four months before this note. It also establishes that "connected cluster" is standard vocabulary in the field, which is fatal to any claim written at that level of generality | abstract/metadata only for the paper (arXiv abstract page); **secondary only** for the package (WebFetch summary of the GitHub README, not raw text) |
| Karimi & Banihashemi, *Efficient algorithm for finding dominant trapping sets of LDPC codes*, IEEE Trans. Inform. Theory 58(11) (2012) 6942–6958; and the branch-and-bound exhaustive enumeration of elementary trapping sets of an arbitrary Tanner graph | The classical analogue: exhaustive enumeration of small connected substructures of a Tanner graph, expanded from short cycles, with branch-and-bound | Same graph, same connectivity exploitation, different target object (trapping/absorbing sets rather than minimum-weight logicals). Establishes that "enumerate connected supports on a Tanner graph with branch-and-bound" is textbook in classical LDPC | secondary only — WebSearch result summaries, 2026-08-29; bibliographic detail as reported there, pages unverified against the article |
| Canteaut & Chabaud, *A new algorithm for finding minimum-weight words in a linear code…*, IEEE Trans. Inform. Theory 44(1) (1998) 367–378 | Information-set decoding for minimum-weight word search | The heuristic branch of the family; gives upper bounds, not exhaustion. `dist_m4ri`'s method 1 (random window) is this lineage | secondary only — WebSearch summary; PDF located at inria.fr but not fetched |
| Brouwer–Zimmermann minimum-weight enumeration | The generic exact method; ships in Magma and GAP/GUAVA | Named only, for completeness; carried at the read depth of `2026-08-28-ergodis-ldpc-quantum-angle.md` §4.3, not re-read here | **not read in this session** |

**Nearest patent: none on the algorithm; one on an adjacent claim shape.**

| Number | Assignee | Filed | Published | Claim 1 gist | Relevance | Read depth |
|:---|:---|:---|:---|:---|:---|:---|
| **US 11,552,653 B2** — *Union-find decoder for LDPC codes* | Microsoft Technology Licensing, LLC | 2021-02-26 (appl. 17/187,240) | granted 2023-01-10 | Receiving a syndrome from a quantum measurement circuit; generating a decoding graph with bit nodes and check nodes; "**growing a cluster around each one of the check nodes corresponding to a non-trivial value in the syndrome**, the cluster including the check node and a set of neighboring nodes positioned within a distance of d edge-lengths"; determining whether each cluster is neutral | **The closest claim language found anywhere to ergodis' constraint-driven branching.** "Grow a cluster around an unsatisfied check node" is claimed — but on a *measured* syndrome, for decoding, with a neutrality test, and the specification's uses of "code distance" are as a parameter of the surface code, not as a computed output. It does not read on enumerating minimum-weight logical operators. Its existence nevertheless shows the branching idea is claimed in the neighbouring problem, and it is a Microsoft grant | **full text of claim 1 + bibliography**, FreePatentsOnline `/11552653.html`, curl 2026-08-29 |
| WO 2026/084738 A2 / A9 — *Algorithmic fault-tolerance for low overhead quantum computing* | President and Fellows of Harvard College | not retrieved | 2026-04-23 / 2026-05-21 | not retrieved | Surfaced by the full-text query `"connected cluster" "code distance"`; recency (2026) makes it worth a claim read before filing | search-result row only (Google Patents XHR) |

### (b) Exact syndrome tracking in packed words with a projected, one-sided completion filter

**Verdict: the architecture is textbook; the specific construction is unclaimed but thin.**

The pattern "cheap approximate filter that may admit but never reject, followed by exact verification"
is the defining property of a Bloom filter (Bloom, CACM 13(7) 1970 — named only, not read) and is the
standard way it is deployed in search. The nearest patent shape is Dharmapurikar's
**US 2010/0098081 A1**, *Longest prefix matching for network address lookups using Bloom filters*
(inventor-named applicant Sarang Dharmapurikar, published 2010-04-22; search-result row only), which
claims exactly the conservative-prefilter-plus-exact-lookup architecture in a networking context.

The nearest reference *in this problem domain* is again `dist_m4ri`, whose README documents a codeword
hash table and a "confinement hash" over per-weight minimum non-zero syndrome weights. That is
deduplication and confinement profiling rather than a soundness-preserving prune, so it is not the same
mechanism — but it establishes that hashing syndromes inside a connected-cluster distance search is
already practice.

What is not found anywhere: a **fixed GF(2)-linear projection of a syndrome whose rank exceeds the
machine-word width into a single-word filter key, with the collision direction argued as a soundness
property of the enumeration**. Google Patents `CL=("syndrome" AND "packed" AND "word")` returns 7, all
false friends; FreePatentsOnline `ACLM/"syndrome" AND ACLM/"partial support"` returns 0. This is the
strongest of the four elements on novelty and the weakest on inventive step — an examiner will call it
an obvious application of a Bloom filter.

### (c) Certified witness transport between CSS directions via a code isomorphism

**Verdict: patent-empty, paper-anticipated at the level of the idea.**

- **Nearest paper — the idea itself:** Bravyi, Cross, Gambetta, Maslov, Rall & Yoder,
  *High-threshold and low-overhead fault-tolerant quantum memory*, Nature 627, 778 (2024)
  (secondary only — WebSearch summaries and the Error Correction Zoo entry for bivariate bicycle
  codes; the article was not retrieved in this session). Bivariate bicycle codes are constructed so
  that `Hz = [B^T | A^T]` against `Hx = [A | B]`, and the X↔Z exchange symmetry giving `d_X = d_Z`
  is part of how the family is understood and used. Ergodis' own BB784 note derives the same
  statement independently. Using the symmetry to halve the work is therefore not new.
- **Nearest paper — the general machinery:** Sendrier, *Finding the permutation between equivalent
  linear codes: the support splitting algorithm*, IEEE Trans. Inform. Theory 46(4) (2000) 1193–1203
  (secondary only — WebSearch summary of the abstract). Computes the permutation between equivalent
  codes; polynomial in length, exponential in hull dimension. Ergodis does not search for the
  isomorphism — it is supplied by the construction and only *verified* — which is the difference, and
  also why the ergodis version is the easier half.
- **Patents:** Google Patents `CL=("isomorphism" AND "error correcting code")` returns 1
  (FR 3060244 A1, Institut Supérieur de l'Aéronautique, *Method and device for calculating a
  correcting code*, published 2018-06-15; search-result row only, unrelated).
  `CL=("CSS code" AND "X distance")` returns 0. FreePatentsOnline
  `ACLM/"isomorphism" AND SPEC/"stabilizer code"` returns 0 and `ACLM/"witness" AND ACLM/"code distance"`
  returns 0.

The residue here is the *machine-checked transport of a concrete witness plus the row-space and
observability-quotient maps as a checked artifact*. That is good engineering and good evidence
practice; as a claim element it is weak, because the underlying fact is published and the verification
is routine linear algebra.

### (d) Persisted, source-fingerprinted compiled search state

**Verdict: not claimable. Do not include it as an independent element.**

This is a content-addressed compilation cache: hash the inputs, store a versioned binary artifact,
fail closed on mismatch. The pattern is ubiquitous (`ccache`, `sccache`, Bazel and Nix action caches)
and the patent literature around build and release caching is dense — Google Patents
`CL=("fingerprint" AND "cached" AND "compilation")` returns 4 including US 9,043,767 B2 (Pivotal
Software, release management; search-result row only), and
`CL=("hash" AND "source" AND "compiled" AND "cache" AND "verify")` returns 16, mostly CN filings on
data-pipeline configuration. None reads on distance computation, but that is beside the point: the
element is obvious over general practice, and including it invites an obviousness rejection that
contaminates the combination. Keep it in the specification as an implementation detail, never as a
claim limitation carrying weight.

## 3. Claim residue over the three closest references

The three closest references are `dist_m4ri` method 2 (Pryadko & Zeng, GPL-2.0), the
Dumer–Kovalev–Pryadko irreducible-cluster papers behind it, and the Webster–Jacob–Higgott
`codeDistance` benchmark and package.

> **Residue.** Enumerating connected kernel supports not by growing a cluster from each coordinate but
> by repeatedly selecting a currently-unsatisfied parity check and branching only over the coordinates
> incident to it — with sibling branches made disjoint by a first-true exclusion chain, branch order
> chosen by fewest remaining options, and expansion terminated as soon as the partial support has zero
> syndrome and zero logical observation — while the residual syndrome above the machine-word boundary
> is carried exactly and the pruning tables are keyed by a fixed GF(2)-linear projection of the
> syndrome whose collisions can only admit candidates and never prune an exact completion.

Two qualifications on that sentence.

1. It is stated over the **published descriptions** of the three references. `dist_m4ri`'s README says
   only that CC "recursively explores connected clusters starting from each column". Whether its C
   implementation already selects an unsatisfied check to branch on is unknown, and it is exactly the
   kind of optimisation an implementer reaches for. **The residue is unverified until
   `src/dist_m4ri.c` is read.**
2. The branching rule, viewed abstractly, is unit-propagation-plus-fail-first from constraint
   programming applied to a GF(2) parity system — a well-known technique family applied to a specific
   object. Its 1,036x measured effect is real; its inventive step over "use standard CP branching
   heuristics" is arguable.

## 4. Subject-matter eligibility

### 4.1 United States, 35 U.S.C. §101

*(Read depth: none. This is my own reading of well-known doctrine, not sourced in this session, and
the statutory-reform position is carried from `2026-08-29-c998-patent-landscape.md` §3.1 at that
note's recorded secondary-only depth. Verify with counsel.)*

The native-backend claim shape is **materially better positioned than the symmetry-reduction claim**,
for one structural reason. The symmetry-reduction claim's inventive contribution was a mathematical
insight about *where in a pipeline to compute a group* — the classic Alice step-two failure, where
the only thing left after removing the abstract idea is a generic computer. The native-backend claim's
contribution is a set of **specific data structures and a specific traversal discipline**: fixed-width
packed machine words, a projection into a single-word filter key chosen so that collisions fall on the
sound side, an exclusion chain that makes branches disjoint, a fail-closed on-disk artifact format.
That is the *Enfish* / *McRO* shape — a claimed improvement in how a computer performs a search,
recited as concrete rules rather than as a result — rather than the *Alice* shape.

Three cautions that do not go away:

- The enumerated object is a mathematical one and the output is a number. A claim drafted as
  "determining the minimum weight of a logical operator" will be read as a mathematical concept
  regardless of the recited data structures.
- The one-sided-collision property is stated as a *proof about the algorithm*. Proofs are the least
  patentable thing in the specification. It should appear as the reason a recited step is safe, never
  as a claim limitation in its own right.
- The measured effect is a speedup, and "the computer runs faster" is not by itself an inventive
  concept — but "runs faster **because** of the recited specific structure" is the argument that has
  carried compression, database-indexing and memory-layout claims through Alice.

### 4.2 European Patent Office, Art. 52(2)/(3) EPC and G 1/19

*(Read depth: none. Own reading of doctrine; G 1/19 was not retrieved. Verify with counsel.)*

The EPO position is **better than the US position for this claim shape, and reversed relative to the
symmetry-reduction claim**. G 1/19 requires a technical effect for a computer-implemented calculation,
and it recognises two routes: an effect on a physical entity outside the computer, and an effect
internal to the computer's operation. The symmetry-reduction claim had only the external route
available — "the output configures error correction for a physical quantum memory" — which is an
argument by analogy to chip-design tools and depends on how the claim's end use is drafted. The native
backend has the **internal** route as well: bounded fixed-width state, a documented memory footprint
(23.4 MiB peak RSS at 784 coordinates), allocation-free enumeration, and a specific filter key
construction are adaptations to the internal workings of a computer, which the EPO has long treated as
technical. Both routes remain available; the external one is unchanged and still worth drafting for.

## 5. File / do-not-file

**Recommendation: conditional file, and the condition is a source read, not a legal question.**

1. **Read `src/dist_m4ri.c` (QEC-pages, GPL-2.0) before anything else.** Specifically: does its
   connected-cluster recursion select an unsatisfied check to branch on, does it make sibling branches
   disjoint, and does it stop on zero-syndrome partial supports? This is a few hours of reading and it
   determines whether the §3 residue exists at all. If it already branches on unsatisfied checks,
   **do not file** — the residue collapses to the projected filter key, which is a Bloom filter, and
   the money is better spent on publication.
2. **If the residue survives the source read, file one narrow US provisional on the §3 sentence
   only.** Not on connected-support enumeration (anticipated by Dumer–Kovalev–Pryadko and implemented
   in `dist_m4ri`), not on the persisted artifact (obvious over content-addressed build caches), not
   on witness transport (the X↔Z symmetry of bivariate bicycle codes is published by the code family's
   authors). Recite those three as context in the specification, never as claim limitations expected
   to carry novelty.
3. **Name the prior art in the specification.** `dist_m4ri`, the Dumer–Kovalev–Pryadko papers, and
   `codeDistance` will be found by the examiner in one search, and under the information-disclosure
   duty they have to be cited anyway. A provisional that positions against them explicitly is worth
   more than one that does not mention them.
4. **Do not file on the quantum symmetry-reduction claim in parallel.** The re-scope supersedes it;
   two overlapping provisionals on the same engine invite a self-obviousness problem at conversion.
5. **Consider a defensive publication instead, and price it against the alternative.** Given the §101 exposure in §4.1
   and the fact that the enumerator must be disclosed anyway (§5, disclosure constraint), a timestamped
   defensive publication secures freedom to operate at near-zero cost and forecloses only the licensing
   option. If the exact-certification service is the business — as the commercialization memo's §5 has
   it — the certificate and the benchmark record, not the patent, are the asset.

### The single most dangerous reference

**`dist_m4ri`, method 2 — the connected-cluster algorithm of Pryadko and Zeng, GPL-2.0, at
`https://github.com/QEC-pages/dist-m4ri`.** It is dangerous on three axes at once. It is §102 prior
art in printed publication and public-use form, with a README that states the same output guarantee
("exact distance or … certified lower distance bound") in the same words ergodis uses. It is the
reference `codeDistance` wraps, so it is also the benchmark competitor. And its C source is the one
document that could either establish or destroy the §3 residue, and it has not been read.

Second most dangerous, for a different reason: **US 11,552,653 B2 (Microsoft, granted 2023-01-10)**,
whose claim 1 recites growing a cluster around each check node with a non-trivial syndrome value. It
is a decoder claim and does not read on distance computation, but it is a granted claim on the
branching idea in the adjacent problem, held by a well-resourced assignee, and it is the reference an
examiner is most likely to combine with Dumer–Kovalev–Pryadko in an obviousness rejection.

### Disclosure constraint

The constraint is sharper than "publishing the checker publishes the method", and it cuts the other way
from what that phrasing suggests. The Python replay checker verifies a *witness*; it does not enumerate,
and releasing it discloses nothing about the search. What forces disclosure is the **negative** half of
every exact result. `2026-08-29-c985-sce-r2elite02-exact-distance.md` records it plainly: for the
X-direction miss, the checker "cannot independently replay the 100.61-billion-candidate exhaustion; the
lower bound trusts the reviewed Rust enumerator". A paper asserting `d = 16` exactly is asserting an
exhaustion that only the enumerator can support, and under the reproducibility conventions that claim
needs the enumerator described or released. **The exact-distance paper and the method disclosure are the
same event.**

Consequences: the provisional must be on file **before** the paper is posted, before `css_distance.rs`
is pushed to any public remote, and before the branching rule is described in a talk or a benchmark
submission. The US 12-month grace period under §102(b)(1) would survive a slip; European, Chinese and
Japanese absolute novelty would not. This sequencing is unchanged from the commercialization memo's §6
item 4 and from `2026-08-29-c998-patent-landscape.md` §3.4.

## 6. Search record

### 6.1 Google Patents — now reachable

The earlier landscape note recorded Google Patents as unavailable. It is reachable this session
through the XHR query endpoint (`https://patents.google.com/xhr/query?url=q%3D…`, **HTTP 200**, JSON);
the human-facing SPA at `https://patents.google.com/?q=…` also returns HTTP 200 but renders results in
JavaScript and yields nothing to `curl`. Searched domain: **Google Patents full corpus, worldwide, all
jurisdictions, as indexed 2026-08-29.** `CL=(…)` restricts to claims; a bare quoted string is full
text. Stop condition: every query returned either zero results or a total small enough to screen every
row on the first result page; the rows carry title, assignee and publication date only, so the
**screen discriminator was title + assignee + date, not abstract**. No query was abandoned for size.

| Query (verbatim) | Total | Outcome |
|:---|---:|:---|
| `CL=("code distance" AND "cluster")` | 29 | False friends: image clustering, logistics routing, face retrieval, one Microsoft geometry-compression filing (US 2023/0359912 A1) |
| `CL=("minimum distance" AND "Tanner graph")` | 4 | All LDPC *code construction*, none computes a distance |
| `"connected cluster" "code distance"` (full text) | 3 | US 11,552,653 B2 (Microsoft, union-find decoder — read at claim 1, §2(a)); WO 2026/084738 A2 and A9 (Harvard, algorithmic fault tolerance) |
| `CL=("determining a minimum distance" AND "error correcting code")` | 0 | The literal function is unclaimed |
| `CL=("minimum weight codeword" AND "enumerat")` | 0 | Nobody claims enumerating minimum-weight codewords |
| `CL=("computing" AND "distance of" AND "quantum error correcting code")` | 1 | WO 2025/155358 A2 (Google LLC, *Quantum shift register codes*) — a code construction |
| `CL=("syndrome" AND "packed" AND "word")` | 7 | All false friends (gene therapy, GPU LDPC encoding, decompression, radio data) |
| `CL=("Bloom filter" AND "false negative")` | 21 | Networking, security, memory mapping, blockchain. Nearest architecture: US 2010/0098081 A1 |
| `CL=("isomorphism" AND "error correcting code")` | 1 | FR 3060244 A1, unrelated |
| `CL=("CSS code" AND "X distance")` | 0 | — |
| `CL=("hash" AND "source" AND "compiled" AND "cache" AND "verify")` | 16 | Build/config caching, mostly CN filings |
| `CL=("fingerprint" AND "cached" AND "compilation")` | 4 | Release management and scheduling |

### 6.2 FreePatentsOnline

Searched domain: **US granted patents (`uspat`) plus US published applications (`usapp`), expert
search, stemming on, as indexed 2026-08-29.** Same stop condition. Rate limiting reset three
connections; two queries were re-run successfully and one was not (recorded below as NOT RUN).

| Query (verbatim) | Total | Outcome |
|:---|---:|:---|
| `ACLM/"code distance" AND ACLM/"enumerating"` | 0 | — |
| `ACLM/"syndrome" AND ACLM/"partial support"` | 0 | — |
| `ACLM/"isomorphism" AND SPEC/"stabilizer code"` | 0 | — |
| `ACLM/"lower bound" AND ACLM/"code distance" AND SPEC/"quantum"` | 0 | Nobody claims certifying a distance lower bound |
| `ACLM/"witness" AND ACLM/"code distance"` | 0 | — |
| `ACLM/"connected component" AND ACLM/"minimum weight"` | 1 | US 6,091,424, *Labeling graphical features of drawings*. Unrelated |
| `ACLM/"hash" AND ACLM/"prune" AND ACLM/"search tree"` | small | Screened on title; US 8,589,398 *Search clustering* and similar information-retrieval filings. Unrelated |
| `ACLM/"cluster" AND ACLM/"minimum distance" AND ACLM/"code"` | — | **NOT RUN** — connection reset by peer, not retried. Open gap |

### 6.3 Coverage statement

- **Google Patents: covered**, via the XHR endpoint, with the title/assignee/date screen caveat above.
  Abstract-level screening was not performed and would strengthen any negative that matters.
- **FreePatentsOnline: covered** for US granted and published applications, one query short.
- **Lens.org: NOT COVERED.** `https://www.lens.org/lens/search/patent/list?q=…` returns **HTTP 200**
  with a 576 KB JavaScript application shell containing no result records; `https://www.lens.org/lens/api/search`
  returns **HTTP 404**. Both checked 2026-08-29. This licenses nothing and is carried forward as an
  open gap — Lens is the route to non-US, non-Google-indexed families.
- **Assignee-level coverage: NOT COVERED** for Google Quantum AI, Quantinuum, AWS, Riverlane, Alice &
  Bob, Xanadu and Infleqtion, unchanged from `2026-08-29-c998-patent-landscape.md` §2.1.1.
- **Publication lag: unchanged.** Anything filed after roughly early 2025 is invisible today.
- **`dist_m4ri` C source: NOT READ.** This is the load-bearing gap and it gates the filing decision.
- **No paper was retrieved at full text in this session.** Every academic verdict above rests on an
  abstract, a README, or a search-result summary. The `dist_m4ri` README is the one exception and it
  is documentation, not a peer-reviewed description of the implementation.

## 7. Sources

| Source | Identifier / route | Read depth |
|:---|:---|:---|
| Dumer, Kovalev, Pryadko, *Numerical Techniques for Finding the Distances of Quantum Codes*, ISIT 2014 | arXiv:1405.0348; arXiv abstract page via WebFetch 2026-08-29 | abstract/metadata only |
| Dumer, Kovalev, Pryadko, *Distance verification for LDPC codes*, ISIT 2016 | arXiv:1605.02410, DOI 10.1109/ISIT.2016.7541755; arXiv abstract page via WebFetch 2026-08-29 | abstract/metadata only |
| Dumer, Kovalev, Pryadko, *Distance Verification for Classical and Quantum LDPC Codes*, IEEE Trans. Inform. Theory 2017 | Not retrieved; characterised from the `dist_m4ri` README citation and search-result rows | secondary only (chain: README, full text) |
| `dist_m4ri` (Pryadko & Zeng), GPL-2.0 | `raw.githubusercontent.com/QEC-pages/dist-m4ri/master/README.md`, curl 2026-08-29, 14,710 bytes; commit not pinned | **full text** (README only; C source not read) |
| Webster, Jacob, Higgott, *Distance-Finding Algorithms for Quantum Codes and Circuits* | arXiv:2603.22532 v1 2026-03-23, v2 2026-08-14; arXiv abstract page via WebFetch 2026-08-29. Verdicts characterise **v2 metadata**, not the article body | abstract/metadata only |
| `codeDistance` Python package, MIT | `github.com/m-webster/codeDistancePYPI`, WebFetch summary of README 2026-08-29 (not raw text) | secondary only |
| Karimi & Banihashemi, dominant trapping sets, IEEE Trans. Inform. Theory 58(11) (2012) 6942–6958; and elementary-trapping-set branch-and-bound enumeration | WebSearch result summaries 2026-08-29; pages as reported there, unverified | secondary only |
| Canteaut & Chabaud, IEEE Trans. Inform. Theory 44(1) (1998) 367–378 | WebSearch summary 2026-08-29; PDF located at rocq.inria.fr, not fetched | secondary only |
| Sendrier, support splitting algorithm, IEEE Trans. Inform. Theory 46(4) (2000) 1193–1203 | WebSearch summary of the abstract, 2026-08-29 | secondary only |
| Bravyi, Cross, Gambetta, Maslov, Rall, Yoder, Nature 627, 778 (2024) | WebSearch summaries and the Error Correction Zoo bivariate-bicycle entry, 2026-08-29 | secondary only |
| Brouwer–Zimmermann enumeration | Named only; carried at the depth of `2026-08-28-ergodis-ldpc-quantum-angle.md` §4.3 | not read in this session |
| Bloom, CACM 13(7) (1970) | Named only | not read |
| US 11,552,653 B2, Microsoft Technology Licensing, LLC, appl. 17/187,240, filed 2021-02-26, granted 2023-01-10 | freepatentsonline.com/11552653.html, curl 2026-08-29 | **full text of claim 1 + bibliography**; specification searched for "code distance" only |
| WO 2026/084738 A2 / A9, President and Fellows of Harvard College | Google Patents XHR row | search-result row only |
| WO 2025/155358 A2, Google LLC, *Quantum shift register codes* | Google Patents XHR row | search-result row only |
| US 2010/0098081 A1, Dharmapurikar, longest-prefix matching with Bloom filters | Google Patents XHR row | search-result row only |
| FR 3060244 A1, Institut Supérieur de l'Aéronautique | Google Patents XHR row | search-result row only |
| US 2023/0359912 A1, Microsoft, geometry-based compression | Google Patents XHR row | search-result row only |
| US 9,043,767 B2, Pivotal Software, release management | Google Patents XHR row | search-result row only |
| US 6,091,424 and US 8,589,398 | FreePatentsOnline result rows | search-result rows only |
| `2026-08-29-c998-patent-landscape.md`, `2026-08-29-ergodis-commercialization-analysis-memo.md`, the four C985 notes, `css_distance.rs` | This repository | full text of the ranges named in §1 |

## 8. What changes elsewhere

The commercialization memo's §6 item 1 says to file on the four-element native method and to cite
Dumer–Kovalev–Pryadko, `dist_m4ri` and `codeDistance` as the closest prior art. That instruction is
right about the references and too broad about the claim: elements (a) and (d) of its list cannot
carry a claim, and the filing decision now hangs on the `dist_m4ri` source read in §5 item 1. The
landscape note's §5 recommendation — file on certified symmetry reduction — is superseded rather than
merely narrowed, and its §3.3 warning that absence of patents is evidence about *patentability*
applies with equal force here. Neither of those documents has been edited; this addendum records the
change and the owning lane can propagate it.
