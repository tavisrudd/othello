# Benchmark suites for a recursive rule-program engine

**Date:** 2026-09-12. **Lane:** `ergodis`. **Disposition:** bounded survey.
No code written; nothing under `~/src/ergodis*` edited.

**Status: IN PROGRESS — written incrementally, source by source.**

## Purpose

Ergodis is gaining a rule-program input (semiring Datalog / einsum) with recursion, certificates
and exact evaluation — step 5 of the programme in
`2026-09-12-ergodis-rule-contract-programme.md`, which names the intended suite as "transitive
closure, shortest paths, bill-of-materials over lifted reals, an einsum program, one exact-cover
problem; comparators Soufflé, egglog, einsum, CP-SAT". This survey establishes what benchmark
suites exist, what is in them, and which published cross-engine tables can be cited for
comparisons that cannot be reproduced locally (hosted engines, cluster hardware).

Two constraints from the programme note shape what counts as useful here. Ergodis's target is
**exact evaluation with a certificate**, so a suite whose only metric is wall clock is
half-useful: it must also admit an answer that can be checked. And Ergodis's `0`-stable bounded
min-plus gives an `N`-step convergence bound, so suites exercising **min-plus and lifted-real
recursion** matter more than suites exercising Boolean recursion alone, which is the case the
Datalog world has already optimised to death.

## Rules followed

Read depth on every source, including any named only to be dismissed. Every PDF fetched is added
to the shared cache at `/tmp/persistent/tavis/lit-search/` with key and SHA-256. **Every arXiv or
DOI identifier resolved from an abstract page or venue record before fetching**, never from
memory.

## 1. Suites with published multi-engine tables

### 1.1 FlowLog's suite — the broadest current cross-engine table

**Hangdong Zhao, Zhenghong Yu, Srinag Rao, Simon Frisk, Zhiwei Fan, Paraschos Koutris, "FlowLog:
Efficient and Extensible Datalog via Incrementality", accepted to VLDB 2026; arXiv:2511.00865v4
[cs.DB], submitted 2 November 2025, latest revision 17 November 2025.** *Read depth: partial, at
table depth* — arXiv v4 PDF, cached as `arXiv:2511.00865`, SHA-256
`07bce0f21bbb693e5881d9634cf39f7e77ec9bba7e48857b405a666377733498`, 14 pages; read in full: the
abstract, §10's "Programs and Datasets" and "Competing Engines" paragraphs, the Table 1 caption,
the "Environment Setup" and "Runtime Summary" paragraphs, and the scaling discussion. Table 1's
body extracts with scrambled columns from a multi-column PDF, so **I quote only figures stated in
the prose and do not transcribe cells**. Identifier, author order and venue resolved from the
arXiv abstract page before fetching.

**Why this is the anchor source.** They claim, and the contents support, "a benchmark suite that,
to our knowledge, is the broadest yet for modern Datalog engines. It subsumes nearly all publicly
available programs and datasets used in recent publications of RecStep, Soufflé, and DDlog … plus
several new programs/datasets we created or harvested from popular open-source projects."

**Programs (41 program–dataset pairs).**

| Program                              | Recursive | Datasets                                 |
|--------------------------------------|-----------|------------------------------------------|
| Bipartite (2-colourability, 4 rules) | yes       | netflix, roadca, mag                     |
| Reach (single-source, 2 rules)       | yes       | livejournal, orkut, arabic, twitter      |
| SSSP (2 rules)                       | yes, min  | livejournal, orkut, arabic, twitter      |
| SG same generation (2 rules)         | yes       | G10K/G20K/G40K-0.001                     |
| TC transitive closure (2 rules)      | yes       | G10K/G20K/G40K-0.001                     |
| CC connected components (2 rules)    | yes, min  | livejournal, orkut, arabic, twitter      |
| Andersen points-to (4 rules)         | yes       | medium, large                            |
| CSPA context-sensitive points-to     | yes       | httpd, linux, postgresql                 |
| CSDA context-sensitive dataflow      | yes       | httpd, linux, postgresql                 |
| Dyck (Dyck-2 reachability, 7 rules)  | yes       | kernel, postgre (largest CFPQ instances) |
| Galen (medical ontology)             | yes       | from McSherry's dynamic-datalog repo     |
| CRDT (replicated data types)         | yes       | same repo                                |
| Polonius (Rust borrow-check alias)   | yes       | rust-lang/polonius project               |
| DOOP (Java analysis, 136 rules)      | yes       | sampled from the largest DaCapo suite    |
| DDISASM (simplified disassembly)     | yes       | synthesised from CVC5 and Z3             |

**Every program in the suite is recursive**, and the suite is explicitly designed to stress
"diverse recursion behaviors (multi-way joins, mutual, nonlinear, deep iterations,
aggregations/antijoins, etc.)". Inputs are integers throughout — "string-valued attributes are
pre-hashed to integers before Datalog execution."

**Semirings beyond Boolean:** only `min`, and only implicitly. CC and SSSP use min-aggregation
(the same two-rule forms as RecStep's suite, §1.2), and FlowLog discusses a "Boolean (or
algebraic) specialization" for programs that "iteratively propagate labels — discarding larger
ones". **There is no suite entry over counting, provenance, or lifted-real semirings.** That is
the gap Ergodis's contract targets, and no existing Datalog suite fills it.

**Engines compared.** Soufflé (compiled — they note "Soufflé interpreter is in general 1.5×
slower and hence excluded"); RecStep; DDlog (deliberately chosen as "a fair baseline" since it
shares FlowLog's Differential Dataflow backend but lacks the relational IR); plus DuckDB and
Umbra running equivalent SQL. They record that "nearly half of our benchmarks cannot be directly
executed on both databases due to unsupported mutual or nonlinear recursion", and exclude those
cells.

**Hardware and protocol as stated:** a CloudLab virtual machine with two AMD EPYC 7543 32-core
processors (64 physical cores, hyper-threading), Ubuntu 22.04 LTS, 256 GB RAM. Runtimes in
seconds at 4 and 64 threads; **900 s timeout** (`TO`), `OOM` for out of memory. For each
program–dataset pair they construct up to five semantically equivalent join-order variants
avoiding cross products, run all of them, and **report the median**; DuckDB/Umbra get the
best-performing `WITH RECURSIVE` formulation and the median of five runs.

**Figures safe to cite, with their caveats.**

- At 4 threads, FlowLog is fastest in **21 of 41** program–dataset pairs; at 64 threads,
  **36 of 41**.
- **CSPA on httpd (29 iterations): Soufflé 67.8 s, FlowLog 112 s at 4 threads — Soufflé 1.6×
  faster.** At 64 threads FlowLog gains 7.8× while "Soufflé sees only modest gains (e.g. 1.3×) —
  becoming 3.5× slower than FlowLog."
- **Polonius: Umbra 70.5 s → 67.1 s across the thread range; FlowLog 215 s → 41.4 s.**
- **DDISASM (cvc5): Soufflé 3.2× faster than FlowLog at 4 threads, 1.2× slower at 64.**
- FlowLog uses "on average 3.5× less memory than DDlog on these workloads."
- Compilation overhead, stated not measured into the tables: Soufflé "incurs a ~10 s compilation
  for small programs and 30 s for larger ones such as DOOP"; DDlog "often >100 s".

**Caveats to carry with every citation.** (1) They say "we evaluate all engines in their latest
releases" but **give no version numbers or commit hashes for any engine** — so a citation must
say "latest releases as of the paper's 2025 submission" and nothing sharper. (2) Runtimes are
end-to-end including CSV loading, and they state FlowLog "currently applies no
ingestion-specific optimizations for CSV, so its loading time is generally higher than RecStep and
DuckDB" — the ablation figure separates load from execution but the table does not. (3) The
DuckDB/Umbra comparison is against SQL `WITH RECURSIVE`, not Datalog, on the subset those systems
can express. (4) This is a system paper reporting its own system as the winner.

### 1.2 The RecStep / BigDatalog graph-analytics and program-analysis suite

**Zhiwei Fan, Jianqiao Zhu, Zuyu Zhang, Aws Albarghouthi, Paraschos Koutris, Jignesh Patel,
"Scaling-Up In-Memory Datalog Processing: Observations and Techniques", PVLDB 12(6):695–708,
DOI 10.14778/3311880.3311886; arXiv:1812.03975v1 [cs.DB], 10 December 2018.** *Read depth:
partial, at table depth* — arXiv PDF, cached as `arXiv:1812.03975`, SHA-256
`4a660b6722531f3848566df932e356e4e645d7e15e63e45352d6f68d549ba7fc`, 16 pages; read in full: the
abstract, §1, §6.1 System Configuration, §6.2 Benchmark Programs and Datasets including Table 3
and every program's rules, and §6.3's cross-system discussion. The engine-internals sections
§§3–5 were skimmed. Identifier and author list resolved from the arXiv abstract page.

This is the suite FlowLog subsumes, and it is worth having separately because **it prints the
actual Datalog rules**, which makes it directly transcribable into another language.

**Graph analytics** (from BigDatalog's evaluation): TC, SG, REACH, CC, SSSP. Datasets: `Gn-p`
graphs from GTgraph (`G5K`, `G10K`, `G10K-0.01`, `G10K-0.1`, `G20K`, `G40K`, `G80K`; default
edge probability 0.001, "very dense considering their relatively small number of vertices");
`RMAT-n` graphs with `n` vertices and `10n` directed edges for `n ∈ {1M, …, 128M}`; and the
real-world graphs `livejournal`, `orkut`, `arabic`, `twitter`.

**Program analysis:** Andersen's analysis (7 synthetic datasets), CSPA and CSDA (datasets
`linux`, `postgresql`, `httpd`, from Graspan's evaluation).

The two min-plus-shaped programs, as printed:

```
Connected Components               Single Source Shortest Path
cc3(x, MIN(x)) :- arc(x, _).       sssp2(y, MIN(0))       :- id(y).
cc3(y, MIN(z)) :- cc3(x,z),arc(x,y). sssp2(y, MIN(d1+d2)) :- sssp2(x,d1), arc(x,y,d2).
cc2(x, MIN(y)) :- cc3(x, y).       sssp(x, MIN(d))        :- sssp2(x, d).
cc(x)          :- cc2(_, x).
```

`sssp2(y, MIN(d1+d2)) :- sssp2(x, d1), arc(x, y, d2)` is exactly the min-plus recursion
`datalog°` writes as `T(X,Y) :- E(X,Y) ⊕ ⊕_Z (T(X,Z) ⊗ E(Z,Y))` over `Trop₊`, so this suite
already contains the min-plus case in a form Ergodis can lower.

**Engines compared:** BigDatalog (on Spark), Soufflé, bddbddb, Graspan; plus
"Distributed-BigDatalog" results reproduced from BigDatalog's own paper on **15 worker nodes with
120 CPU cores and 450 GB memory in total**. They exclude Myria and SociaLite on the grounds that
BigDatalog already outperforms them, and exclude LogicBlox citing prior work that Soufflé
outperforms it and their own early attempts confirming it.

**Hardware:** a bare-metal CloudLab server, Ubuntu 14.04 LTS, two Intel Xeon E5-2660 v3 2.60 GHz
(Haswell EP), 10 cores and 20 hyper-threads each, 160 GB memory (80 GB per NUMA node).
**Protocol:** four runs, first discarded, mean of the last three; total execution time including
disk load and write-back; for BigDatalog they "tried different combinations of parameters (e.g.
different join types) and report the best runtime numbers"; REACH and SSSP report the average
over ten randomly selected source vertices, and an evaluation counts as complete only if all ten
finish.

**The single most citable fact in this paper for Ergodis's purposes** is not a runtime. It is
this sentence: **"Since Soufflé does not support recursive aggregation (which shows in CC and
SSSP), we only show the execution time results of our system and BigDatalog for CC and SSSP."**
Soufflé — the engine Ergodis is most likely to be measured against — could not run the min-plus
programs at all in this evaluation. Any Ergodis claim about min-plus recursion has this as its
baseline context.

Other results as stated: RecStep "is 3-6X faster than other systems using scale-up approach on
all the workloads that other systems manage to finish"; it is "the only one that can complete the
evaluation for TC and SG on all `Gn-p` graphs"; Soufflé "runs out of memory when evaluating TC on
G80K"; bddbddb "runs out of time (> 10h)" on G20K, G40K and G80K; SG timeouts are reported at
> 15 h; and **CSDA is the one program where RecStep is beaten by both Soufflé and BigDatalog**.

**Caveats.** This is a 2018 evaluation on Ubuntu 14.04 with no engine version numbers; Soufflé
in particular has changed substantially since. Absolute runtimes appear only in figures, and the
paper states "Specific runtime numbers are not shown in Figure 10 and Figure 15a due to the space
limit." Cite the qualitative findings and the setup, not reconstructed numbers.

### 1.3 The FGH-rule evaluation — the closest published thing to Ergodis's intended suite

**Yisu Remy Wang, Mahmoud Abo Khamis, Hung Q. Ngo, Reinhard Pichler, Dan Suciu, "Optimizing
Recursive Queries with Program Synthesis", SIGMOD 2022, DOI 10.1145/3514221.3517827;
arXiv:2202.10390v1 [cs.DB], 21 February 2022.** *Read depth: partial, at table depth* — cached as
`arXiv:2202.10390`, SHA-256
`6cb34e4614662be0d1818934481159352bc40f538852433f62e5b5b63b5a4ba3`; §8 Evaluation read in full
(setup, Figure 10's program table, and the run-time measurement protocol); §§1 and 3 were read in
the companion RelationalAI study at the depth recorded there. Figures 11–12 are plots and were
not transcribed.

This matters because it is the only published evaluation I located that is **semiring-aware by
construction** — the programs are `datalog°` programs and the metric is the effect of a
semiring-level rewrite.

**Seven programs (their Figure 10),** with the synthesis type used to derive the optimisation,
whether a database constraint is required, whether a loop invariant must be inferred, and program
size in semiring operations:

| Program                             | Synthesis  | Constraint | Invariant | Dataset                      | #ops |
|-------------------------------------|------------|------------|-----------|------------------------------|------|
| Beyond Magic (BM)                   | rule-based | no         | yes       | twitter, epinions, wiki      | 6    |
| Connected Components (CC)           | rule-based | no         | no        | twitter, epinions, wiki      | 6    |
| Single Source Shortest Path (SSSP)  | rule-based | no         | no        | twitter, epinions, wiki      | 17   |
| Sliding Window Sum (WS)             | CEGIS      | no         | yes       | vector of numbers            | 15   |
| Betweenness Centrality (BC)         | CEGIS      | no         | no        | Erdős–Rényi graphs           | 43   |
| Graph Radius (R)                    | CEGIS      | yes        | yes       | random recursive trees       | 12   |
| Multi-level Marketing (MLM)         | CEGIS      | yes        | yes       | random recursive trees       | 6    |

"BM and CC are Examples 3.8 and 3.3; MLM is basically Example 3.9. CC, SSSP and MLM are from [39]"
— that reference is BigDatalog — "the others are designed by us. R and MLM require a database
constraint stating that the data is a tree." Real-world datasets `twitter`, `epinions` and `wiki`
are from the SNAP collection; synthetic graphs follow RecStep's and BigDatalog's settings; and
they "additionally generate random recursive trees with an exponential decay, modeling the decay
of association in multi-level marketing." **MLM over random recursive trees with exponential
decay is the closest published analogue to the bill-of-materials-over-lifted-reals case** the
Ergodis programme names, and BM, R and MLM each carry a non-trivial loop invariant.

**Engines:** BigDatalog, RecStep, and "an unreleased commercial system X, which is single core"
— "X is the only one that supports all features for our benchmarks." They surveyed five systems
supporting aggregates in recursion (SociaLite, Myria, the DeALS family including BigDatalog and
RaDlog, RecStep, Dyna) and excluded SociaLite and Myria as consistently slower per prior work,
and Dyna because "we were not able to run our benchmarks without errors using it."

**Hardware:** a server running CentOS 8.3.2011 with 1008 GB memory and four Intel Xeon E7-4890 v2
2.80 GHz CPUs, each with 15 cores and 30 threads.

**The protocol caveat is severe and must be quoted whenever this paper is cited.** "We report only
the speedups relative to the original program"; "the absolute runtimes are irrelevant for our
discussion, since we want to report the effect of adding our optimizations"; and **"(We also do
not have permission to report the runtimes of X.)"** Timeout is 3 hours, with speedups reported
against the 3-hour mark when the original timed out, and `o.o.m.` cells where it exhausted memory.
**So this paper supplies no cross-engine absolute comparison at all** — it compares three
variants of the same program within each engine. Its value to Ergodis is the program list and the
`datalog°` framing, not the numbers.

### 1.4 Free Join: JOB and LSQB — join-only, non-recursive

**Yisu Remy Wang, Max Willsey, Dan Suciu, "Free Join: Unifying Worst-Case Optimal and Traditional
Joins", Proc. ACM Management of Data 1(2), DOI 10.1145/3589295; arXiv:2301.10841v2 [cs.DB],
27 January 2023.** *Read depth: partial, at table depth* — cached as `arXiv:2301.10841`, SHA-256
`ff7683faf2a11214dd6259d4d38d12a0bee300de4ade3f85424f3fec69ed0f45`; §5 Experiments read in full
(setup, benchmark description, protocol); §1 read in the companion RelationalAI study. Result
figures were not transcribed.

**Benchmarks:** the **Join Order Benchmark (JOB)** — "113 acyclic queries with an average of 8
joins per query", over "real-world data from the IMDB dataset", with **5 queries excluded**
because they return empty results, "since such empty queries are known to introduce
reproducibility issues" (they cite a GitHub issue on `gregrahn/join-order-benchmark`); and
**LSQB**, which "contains both cyclic and acyclic queries" over synthetic data, of which they
"use the first 5 queries … the other 4 queries require anti-joins or outer joins which we do not
support", at scaling factors 0.1, 0.3, 1 and 3, "as some queries run out of memory with larger
scaling factors". Every query "only contains base-table filters, natural joins, and a simple
group-by at the end, and no null values".

**Engines:** Free Join (their Rust library), their own Generic Join implementation ("by modifying
Free Join to fully construct all tries, and removing vectorization"), DuckDB's binary hash join,
and **Kùzu**, "the current iteration of the Graphflow system", which implements Generic Join.

**Hardware:** "a MacBook Air laptop with Apple M1 chip and 16GB memory. All systems are configured
to run single-threaded in main memory", DuckDB left at defaults, all systems given the same
DuckDB-optimised binary plan.

**Results as stated in the introduction:** on acyclic queries Free Join is up to 19.36× faster
than binary join and 31.6× faster than Generic Join; on cyclic queries up to 15.45× and 4.08×
respectively.

**Caveats.** (1) **Nothing here is recursive** — JOB and LSQB are conjunctive queries. This suite
measures the rule-body join operator (programme step 4), not the fixpoint (step 3). (2) The
Generic Join baseline is the authors' own ablation of their own system, not an independent
implementation, so "31.6× faster than Generic Join" is a self-comparison. (3) "we exclude the
time spent in selection and aggregation when reporting performance", stated to average under 1%.
(4) Laptop-class single-threaded hardware; no engine version numbers for DuckDB or Kùzu.

### 1.5 GPUlog — a Soufflé comparison on GPU hardware

**Yihao Sun, Ahmedur Rahman Shovon, Thomas Gilray, Kristopher Micinski, Sidharth Kumar,
"Optimizing Datalog for the GPU", arXiv:2311.02206v5 [cs.DB; cs.PL], submitted 3 November 2023,
revised 19 November 2024.** *Read depth: abstract/metadata only* — arXiv v5 PDF, cached as
`arXiv:2311.02206`, SHA-256
`4f0c963f5b8cc1d7e10d9346e734532dc7a6ef87071bf69d8e948b9c3f776171`, 13 pages; only the abstract
page metadata and abstract were read. Identifier, author order and version resolved from the arXiv
abstract page. Recorded because it is the one cross-engine result on GPU hardware in this area
and the programme's invariants admit GPU components: they report **GPUlog achieving "up to 45x"
speedup versus Soufflé on context-sensitive points-to analysis**, using a "hash-indexed sorted
array (HISA)" data structure. **I did not read the experimental section, so I cannot state the
hardware, the Soufflé version, the thread count Soufflé was given, or which CSPA datasets were
used** — a citation must say so, and the figure should be treated as an abstract claim pending a
deeper read.

### 1.6 VFLog — the best-documented multi-engine table, with versions

**Yihao Sun, Sidharth Kumar, Thomas Gilray, Kristopher Micinski, "Column-Oriented Datalog on the
GPU", arXiv:2501.13051v1 [cs.DB], 22 January 2025.** *Read depth: partial, at table depth* —
arXiv PDF, cached as `arXiv:2501.13051`, SHA-256
`4004f057cca5d5ba829e5971491eefdbd56b5a8993f994507b3458265fb94af5`, 9 pages; read in full: the
abstract, the Evaluation section's three comparisons, the Experimental Environment paragraph,
the SG and TC benchmark programs, and Tables 1 and 2. Engine internals were skimmed. Identifier
and author list resolved from the arXiv abstract page.

**This is the only source I located that states an engine version for every comparator**, which
makes it the most citable table in the survey despite being a GPU paper.

**Versions as stated:** Nemo **0.5.1**; Soufflé **2.4.1**; RDFox **7.1a**, "with all CPU threads
enabled"; VLog accessed through **Rulewerk**, "a Java wrapper for VLog that provides additional
language features".

**Hardware as stated:** AMD EPYC 9534 (64 cores, 128 threads, 500 GB memory, 0.43 TB/s bandwidth)
and NVIDIA H100 (16,896 CUDA cores, 80 GB HBM3, up to 3.3 TB/s), Ubuntu 22.04, GCC 11. The table
caption is explicit that this is a cross-hardware comparison: "FVLOG and GDLOG are executed on
NVIDIA H100, Nemo and soufflé are executed on AMD EPYC 9534 (Genoa)."

**Programs:** Same Generation (two rules, with a disequality `x ≠ y`), transitive closure, and
the LUBM scenario from **ChaseBench** for knowledge-graph reasoning. Datasets are real-world
graphs from the **SuiteSparse** collection — "road systems, simulations, and SAT solving" — which
they argue makes the comparison unbiased.

**Table 1 — Same Generation, running time in seconds** (transcribed from the PDF; the column
ordering is stated in the source and the values align cleanly):

| Dataset    | Size (edges) | VFLog | VLog | Nemo  | Soufflé | RDFox |
|------------|--------------|-------|------|-------|---------|-------|
| vsp_finan  | 552,020      | 7.52  | 4403 | 2172  | 151.5   | 257   |
| fc_ocean   | 409,593      | 0.31  | 169.7| 151.9 | 13.13   | 19.2  |
| SF.cedge   | 223,001      | 1.80  | 1121 | 298.9 | 56.52   | 117   |
| fe_body    | 163,734      | 1.85  | 173.9| 555.4 | 48.18   | 126   |
| CA-HepTH   | 51,971       | 0.55  | 313.7| 147.7 | 20.12   | 20.1  |
| fe_sphere  | 49,152       | 0.92  | 582.7| 160.8 | 48.12   | 63.8  |

**Table 2 — transitive closure, running time in seconds:**

| Dataset    | VFLog | GDlog | GPUJoin | Soufflé | RDFox |
|------------|-------|-------|---------|---------|-------|
| vsp_finan  | 7.94  | 21.91 | 63.89   | 239.3   | 269   |
| fe_ocean   | 10.07 | 23.36 | —       | 292.2   | 507   |
| usroads    | 9.55  | 17.53 | —       | 243.1   | 268   |
| com-dblp   | 3.35  | 14.30 | —       | 233.0   | 569   |
| Gnutella31 | 1.2   | 3.76  | —       | 96.82   | 373   |
| fe_sphere  | 0.53  | 0.93  | —       | 25.02   | —     |

Stated findings: VFLog "on the H100 is at least more than 150 times faster than VLog and Nemo on
AMD Genoa"; on `vsp_finan` it is "584 times faster than VLog and 288 times faster than Nemo" and
"20 times faster than Soufflé".

**Caveats.** (1) The GPU/CPU comparison spans hardware classes and the paper says so. (2) The
GPUJoin column is almost entirely blank in the extracted table and I did not determine whether
those are omissions or failures — do not cite that column. (3) `fe_ocean` and `fc_ocean` appear
in the two tables respectively and may be the same dataset under a typo; cite the table you took
the number from. (4) This is a system paper reporting its own system as the winner.

## 2. Suites and corpora without cross-engine tables

### 2.1 OpenRuleBench — the historical cross-technology suite

**Senlin Liang, Paul Fodor, Hui Wan, Michael Kifer, "OpenRuleBench: An Analysis of the
Performance of Rule Engines", WWW 2009, Madrid; Proceedings of the 18th International Conference
on World Wide Web, ACM Press, pp. 601–610, DOI 10.1145/1526709.1526790.** *Read depth: partial*
— author-hosted PDF at `www3.cs.stonybrook.edu/~pfodor/openrulebench_web/`, cached as
`openrulebench-2009`, SHA-256
`9dfa1cbc7dff25e92878ea38a0eab843a06d08ec0befe089811b8946fda8d95d`, 10 pages; read in full: §1,
§2's system descriptions, §3 Methodology including the indexing discussion, and the test-category
descriptions for large joins and Datalog recursion. The per-system result tables in §4 were not
transcribed. Venue and DOI resolved by search against the ACM and researchr records.

**Scope:** "five different technologies and eleven systems" — Prolog-based (XSB, Yap), deductive
databases (DLV, IRIS, Ontobroker), production rules (Jess, Drools, Prova), triple engines (Jena,
OWLIM) and general knowledge bases (CYC). Their headline finding: "Three systems, Yap, XSB, and
Ontobroker, stood out both as the most feature-full and also as (by far) the best-performing in
the entire bench. However, variation in the results among these three for different tests was
significant", and "Every one of the systems has met a foe it could not beat — tests that it
failed because of a timed-out, or due to a crash."

**Test categories:** *large joins* (Join1, Join2, three LUBM-derived rule sets adapted from the
Lehigh benchmark — Query1, Query2, Query9 — plus Mondial and DBLP); ***Datalog recursion*** (the
classical transitive closure, same-generation siblings, WordNet-based natural-language
applications, and a rule representation of the wine ontology); and *default negation*.

**Data:** synthetic sets at sizes 50,000 / 100,000 / 250,000 and up from included generators, plus
fixed real-world sets — the wine ontology (hundreds of facts), Mondial, WordNet, and DBLP
(several million). LUBM-derived tests at 10 universities (>1,000,000 tuples) and 50 universities
(>6,000,000 tuples).

**Availability:** the paper states the rule sets, data generators and scripts are "freely
available" as a community resource; I did not verify the current state of the distribution or its
licence, and the individual engines have mixed licences (they note DLV "is not distributed with
an open-source license" and Ontobroker "has a commercial, non-open-source license").

**Semirings beyond Boolean:** none.

**Why this is in §2 despite having cross-engine tables.** The methodology makes the numbers
unusable as a modern baseline, and the authors are candid about it: rules "had to be manually
(and often non-trivially) adapted for each system"; "we tried to look into the potential of the
tested systems and often applied manual optimizations when algorithms for such optimizations were
known"; and "we decided to use the most advantageous indices for each system". Hardware was "a
dual core 3GHz Dell Optiplex 755 with 4 gigabytes of main memory (of which only 3G are visible to
applications)", Ubuntu 7.10. Cite OpenRuleBench for its **program list and its methodological
warnings**, never for its timings.

### 2.2 LDBC Graphalytics — kernels, datasets and a validation discipline

**Alexandru Iosup, Ahmed Musaafir, Alexandru Uta, Arnau Prat Pérez, Gábor Szárnyas, Hassan Chafi,
Ilie Gabriel Tănase, Lifeng Nai, Michael Anderson, Mihai Capotă, Narayanan Sundaram, Peter Boncz,
Siegfried Depner, Stijn Heldens, Thomas Manhardt, Tim Hegeman, Wing Lung Ngai, Yinglong Xia,
"The LDBC Graphalytics Benchmark", arXiv:2011.15028v6 [cs.DC; cs.DB], submitted 30 November 2020,
latest version 6 April 2023.** *Read depth: partial* — arXiv v6 PDF, cached as
`arXiv:2011.15028`, SHA-256
`acf6996eb935e5ba922da63a785f4908851f2aead7973a841fc33b7fb26b35d0`, 43 pages; read the abstract,
§1, and the table of contents identifying the six algorithms and the dataset sections. The
detailed algorithm specifications and the scoring rules were not read. Identifier, author list
and version resolved from the arXiv abstract page. **Licence: the document states it is licensed
under Creative Commons Attribution 4.0**, and the benchmark "comes with open-source software for
generating performance data, for validating algorithm results, for monitoring and sharing
performance data".

**Six kernels:** Breadth-First Search (BFS), PageRank (PR), Weakly Connected Components (WCC),
Community Detection using Label Propagation (CDLP), Local Clustering Coefficient (LCC), and
Single-Source Shortest Paths (SSSP). **Recursive in the Datalog sense: BFS, WCC, CDLP and SSSP.
SSSP is min-plus; PageRank is over the reals but is an iteration to numerical convergence rather
than a least fixpoint, so it does not fit the `datalog°` convergence theory.** LCC is not
recursive.

**Why it matters to Ergodis despite not being a Datalog benchmark.** Two things it has that no
Datalog suite in §1 has: **reference output for validation purposes** and enforced determinism.
The abstract is explicit — "a set of selected deterministic algorithms for full-graph analysis,
standard graph datasets, synthetic dataset generators, and reference output for validation
purposes" — and its harness "produces deep metrics that quantify multiple kinds of systems
scalability, weak and strong, and robustness, such as failures and performance variability." For
an engine whose selling point is a *checkable* answer, a suite that ships the expected answer is
worth more than one that ships only timings. **I did not read the validation section**, so
whether the reference output covers SSSP distances exactly or up to tolerance is unresolved and
must be checked before relying on it.

### 2.3 Nemo and the knowledge-graph reasoning suites

**Alex Ivliev, Stefan Ellmauthaler, Lukas Gerlach, Maximilian Marx, Matthias Meißner, Simon
Meusel, Markus Krötzsch, "Nemo: First Glimpse of a New Rule Engine", ICLP 2023 system
demonstration; EPTCS 385 (2023), pp. 333–335, DOI 10.4204/EPTCS.385.35; arXiv:2308.15897v1
[cs.AI; cs.DB; cs.LO], 30 August 2023.** *Read depth: full text* — a three-page system
demonstration; arXiv PDF cached as `arXiv:2308.15897`, SHA-256
`1ab8904c5556ab86cf0f5f5dbbc9e291e99a915b69fdcd19c0917714137120a3`; read end to end. Identifier,
venue, author list and DOI resolved from the arXiv abstract page.

Nemo is "written in Rust and available as a free and open source tool" at
`github.com/knowsys/nemo`, with a Datalog dialect "widely compatible with that of Rulewerk
[formerly VLog4j], and with the Datalog fragment of RDFox". Evaluation is "materialisation
(forward chaining of rules) using semi-naive evaluation and the **restricted chase**", with
"columnar data structures", "a multiway join algorithm based on **leapfrog triejoin**", and
support for **stratified negation**, conjunctive rule heads, floating-point built-ins and
existentially quantified head variables.

**Their Table 1 (loading + reasoning, seconds; 60 min timeout, `oom` = out of memory):**

| Benchmark     | Inferred facts | Nemo  | VLog    |
|---------------|----------------|-------|---------|
| Doctors-1M    | 792,500        | 3.2   | 2.5     |
| Ontology-256  | 5,674,201      | 13.4  | 22.2    |
| LUBM-01k      | 186,742,694    | 163.3 | 199.4   |
| Deep200       | 725,457        | 5.1   | timeout |
| Galen EL      | 1,858,810      | 3.6   | 45.2    |
| SNOMED CT     | 24,117,991     | 62.1  | oom     |

**Caveats, and they are serious for a comparison.** The paper is a three-page demo: it gives
**no version numbers for either Nemo or VLog**, and the only hardware statement anywhere is "all
on a laptop". Timings include data loading, which the paper's own lime-tree example shows can
dominate — "about 7 sec on a laptop, of which 200 msec are used to apply rules (the rest is for
data loading)". Cite this table only with those two caveats attached, and prefer VFLog (§1.6) when
a version-pinned Nemo number is needed.

**Semirings beyond Boolean:** none. These are existential-rule / chase workloads, not weighted
recursion.

### 2.4 egglog and egg — equality saturation suites

**Yihong Zhang, Yisu Remy Wang, Oliver Flatt, David Cao, Philip Zucker, Eli Rosenthal, Zachary
Tatlock, Max Willsey, "Better Together: Unifying Datalog and Equality Saturation", PLDI 2023,
Proc. ACM Program. Lang. 7, Article 125, DOI 10.1145/3591239; arXiv:2304.04332v4 [cs.PL],
15 May 2023.** *Read depth: partial, at table depth* — cached as `arXiv:2304.04332`, SHA-256
`bf26d308dc3d3840dfd36e4453c89da57b66cf25c172bef15992e4d27fded487`; for this survey I read §5.1
Micro-benchmarks, §6.1's Steensgaard case study, and §6.2's Herbie case study in full. The
language and semantics sections were read in the companion RelationalAI study at the depth
recorded there.

Three distinct workloads, all with published numbers:

**Micro-benchmark.** Initial terms from **egg's `math` test suite**, grown with rewrite rules
under egg's default BackOff scheduler, for 100 iterations, seven runs per iteration reporting the
median. Rules requiring analyses (such as `x/x → 1` when `x ≠ 0`) are removed "because the
scheduler behaves differently on analyses in the two systems". Baselines: **egg** and
**egglogNI** (egglog with semi-naive disabled). Result: at iteration 100, egglogNI is **3.34×**
faster than egg on the identical e-graph, and egglog is **9.27×** faster while growing a slightly
larger e-graph.

**Steensgaard points-to.** A subset of **cclyzer++** reimplemented in egglog, "context-, flow-,
path-insensitive and field-sensitive", run on programs from **postgresql-9.5.2** with a **20
second timeout**, against three baselines including Soufflé's `eqrel` union-find-backed relations.
Result as stated: "**`eqrel` times out on all but one of the benchmarks**", and "all the systems
except for cclyzer++ report the same size for computed points-to relations". The paper's
diagnosis is the "join modulo equivalence" problem: Soufflé must join over the `eql` relation
even when the equivalence is already known.

**Herbie.** Herbie's own benchmark suite of **289 floating-point programs**. Herbie run on each
with its unsound ruleset versus egglog's sound analysis: **73.91 minutes with egglog's analysis
versus 81.91 minutes unsound**, with egglog faster "because egglog generates no unsound programs,
which slow down Herbie's search". Accuracy is a wash and they say so: "In 104 cases, Herbie using
a sound analysis is actually able to find a more accurate program … In 135 cases, Herbie's unsound
ruleset finds more accurate results."

**Hardware:** "All experiments in this paper are executed on a MacBook Pro with Apple M2 processor
and 16GB memory." No version numbers for egg, Soufflé or cclyzer++.

**Semirings beyond Boolean:** egglog's values live in a complete lattice with a `:merge`
operator, and their `path` example uses the min lattice over `i64` — so the **min-plus case is
present**, but there is no benchmark that exercises it at scale.

### 2.5 Doop and DaCapo — a corpus, not a benchmark suite

Doop is a Java points-to analysis framework; the DaCapo suite is the Java program corpus it is
usually run over. **In FlowLog's evaluation (§1.1) these appear as one row: "DOOP, a popular Java
analysis framework, featuring 136 rules with complicated recursions. Similar to Soufflé and Flan's
evaluation, the datasets are sampled among the largest from the DaCapo suite."** *Read depth:
secondary only* — I did not read the Doop or DaCapo papers; this characterisation is from
FlowLog's §10 at the depth recorded in §1.1, and from RecStep's and egglog's references to the
points-to literature at the depths recorded above.

The practical point for Ergodis is that Doop/DaCapo is the **largest and most rule-heavy**
recursive program available (136 rules), it is what the program-analysis community measures on,
and it is pure Boolean Datalog. It is therefore the right stress test for the rule engine and the
wrong test for the semiring contract. I did not locate a standalone Doop-versus-{Flix, Ascent,
DDlog} comparison table; FlowLog's Table 1 is the closest, and it covers Soufflé, RecStep, DDlog,
DuckDB and Umbra but **not Flix or Ascent**. That is an open gap.

### 2.6 The `datalog°` paper has no experiments

Worth stating explicitly because the survey brief assumed otherwise. **Abo Khamis, Ngo, Pichler,
Suciu and Wang's "Convergence of Datalog over (Pre-) Semirings" contains no experimental section
and no benchmark.** *Read depth: partial* — cached as `arXiv:2105.14435`, SHA-256
`9f360b1a6b3c3f85ecce5ee232e080857cd01378278fd39dc2923d8c065f094b`; read at algorithm depth in the
companion RelationalAI study, and re-probed here for experiment sections. APSP over `Trop₊` and
bill-of-materials over the lifted reals `R⊥` appear as **worked examples** (their Example 1.1 and
Example 4.2), not as measured workloads. The experiments the brief is thinking of are in the
companion FGH paper, §1.3 above, where bill-of-materials appears as the program **BM** and the
`R⊥`-shaped case appears as **MLM**.

### 2.7 Rel has no published benchmark

**The Rel paper (Aref et al., SIGMOD 2025, arXiv:2504.10323) contains no experiments, no
benchmark and no performance numbers.** *Read depth: partial* — cached as `arXiv:2504.10323`,
SHA-256 `80460b3169da289432f44ebe6b03ab59f77dbeaf7d2d097d51d5f97b4d995d03`; read at the depth
recorded in the companion RelationalAI study, and re-probed here for experiment sections; the only
occurrences of "evaluate" are semantic ("evaluates to the set of…"). It is a language-design
paper. I located no RelationalAI-published benchmark result in this survey, and a comparison
against Rel would therefore have to be run locally against a hosted system — which the programme
note's own framing makes awkward, since the engine is "available as a co-processor to Snowflake".
**Recorded as an open gap.**

### 2.8 MIPLIB and XCSP — out of scope, with one exception

*Read depth: not consulted.* Neither library was read for this survey, and neither is a rule
benchmark: MIPLIB is a mixed-integer programming instance library and XCSP is a constraint-network
format. They enter only through the programme note's "one exact-cover problem" line and its CP-SAT
comparator. The honest position is that **an exact-cover instance is not a Datalog benchmark and
should not be cited as one**; it belongs in the Ergodis suite as a test of the exact-search side
of the engine, expressed directly, with CP-SAT as the comparator. If a rule formulation is wanted
later, the thing to look for is a published Datalog or ASP encoding of a specific MIPLIB or XCSP
instance family — I did not search for one and cannot say whether it exists.

## 3. What the engines are

Compiled from the sources above; every claim carries the source it came from.

| Engine       | Language / backend           | Recursive aggregation | Source for the claim |
|--------------|------------------------------|-----------------------|----------------------|
| Soufflé      | compiles Datalog to C++      | **no** (2018)         | RecStep §6.3         |
| RecStep      | on QuickStep parallel RDBMS  | yes (CC, SSSP)        | RecStep §1, §6.2     |
| BigDatalog   | on Apache Spark              | yes (CC, SSSP)        | RecStep §2, FGH §8   |
| DDlog        | on Differential Dataflow     | not established here  | FlowLog §10          |
| FlowLog      | on Differential Dataflow     | yes (CC, SSSP)        | FlowLog §10          |
| DuckDB       | SQL `WITH RECURSIVE`         | partial               | FlowLog §10          |
| Umbra        | SQL, worst-case optimal join | partial               | FlowLog §10          |
| Nemo         | Rust, columnar, restricted chase | not established   | Nemo, ICLP 2023      |
| VLog         | columnar, via Rulewerk       | not established       | VFLog, Nemo          |
| RDFox        | multicore, RDF-oriented      | not established       | VFLog                |
| egglog       | Rust, lattice `:merge`       | lattice-valued        | egglog §3, §4.2      |
| Rel          | RelationalAI, GNF            | yes, by design        | Rel §1, §3           |

Two rows deserve emphasis. **Soufflé's lack of recursive aggregation** is stated flatly in
RecStep's 2018 evaluation and is the reason CC and SSSP have no Soufflé column there; FlowLog's
2025 table *does* have Soufflé columns for CC and SSSP, so the capability evidently arrived
between the two papers, and **any claim about Soufflé and min-plus must be dated**. I did not
establish when or in what form. **DuckDB and Umbra cannot express nearly half of FlowLog's
benchmarks** — "nearly half of our benchmarks cannot be directly executed on both databases due
to unsupported mutual or nonlinear recursion" — which bounds how much of a suite a SQL comparator
can cover.
