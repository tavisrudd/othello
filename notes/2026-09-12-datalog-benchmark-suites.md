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
