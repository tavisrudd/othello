# C998 — ergodis patent landscape by vertical

**Lane**: `complete-ports`
**Date**: 2026-08-29
**Task**: C998 — per-vertical patent and prior-art landscape for commercializing the Rust crate
`ergodis` (exact finite algebraic optimization compiler: observational/contextual quotient
minimization with certificates, plus a certified symmetry/orbit-cover layer emitting
orbit-quotiented models for MILP/MaxSAT solvers).

> **This is not legal advice.** It is an agent-run, publicly-sourced patent-literature survey by a
> non-attorney using free full-text patent search only. No professional patent database (Derwent,
> PatBase, Questel Orbit, USPTO Patent Public Search with examiner classification expansion) was
> used, no claim charts were built, no file wrappers or continuation families were pulled, and no
> maintenance-fee or legal-status record was checked. Expiry dates below are arithmetic from filing
> dates, not verified status. Nothing here is a freedom-to-operate opinion or a patentability
> opinion. Every risk rating is engineering triage.

Recording follows `notes/literature-audit-conventions.md`: every named source carries a read-depth
field and access route; negatives state the searched domain and the stop condition.

**Read-depth summary.** This report names 52 patent documents. Fifteen were read at **full text of
claim 1 plus front-page bibliography**; they are listed individually in §6.1. **Every other patent
document named anywhere in this report is at search-result-row depth** — publication number, title,
and the abstract fragment shown on the FreePatentsOnline result page, nothing more. Zero patent
documents were read at full specification text. Non-patent sources are carried at the read depth
recorded by the two prior lane notes this report builds on (§6.3) and were not re-read here.

---

## 1. Executive table

| Vertical | Blocking risk | Closest specific reference | Provisional? | One-line reason |
|:---|:---|:---|:---|:---|
| (a) Quantum — certified automorphism symmetry reduction for exact stabilizer/CSS/qLDPC distance | **Low** | US 2025/0190837 A1 (Microsoft, pending) — lower-bounding *channel* distance by pairwise composition, no symmetry | **File** (narrow, quantum-only) | No patent anywhere claims computing or reducing an exact code-distance search using the code's automorphism group; the entire distance-tooling field is publishing, not filing |
| (b) Storage — exact minimum-helper recovery planning for user-supplied layouts | **Medium** | US 10,187,088 (UC Regents, granted 2019) — incrementally engaging surviving nodes by accessing cost | **Do not file** | Helper-set selection for reconstruction is already claimed by at least three independent US families; ergodis' exact-minimum variant is a narrowing of an occupied space, not an opening |
| (c) Automata/verification — certified observational minimization | **Low** | US 8,515,891 (Microsoft, granted 2013, live) — regex compiled to a symbolic finite automaton | **Do not file** | The AT&T weighted-transducer determinization/minimization family is expired; the one live patent claims regex→symbolic-automaton conversion, which ergodis does not perform. Also anticipated by academic art per the 2026-08-29 VeriPB note |
| (d) Exact solvers — orbit-quotiented model emission as a solver front end | **Low** | US 9,524,471 (SAS Institute, granted 2016) — conflict resolution and cut stabilization *inside* a MIP solver | **Do not file** | Gurobi, FICO/Xpress, Hexaly/LocalSolver have zero US patents on solver technology; no US patent claims symmetry detection, symmetry reduction, or proof logging as a solver step |

**Net.** One provisional, on the quantum bridge only. See §5 for the one-sentence residue and the
argument against filing.

---

## 2. Per-vertical detail

### 2.1 Vertical (a) — Quantum

**ergodis' claim under test.** Certified automorphism-group symmetry reduction — emitting an
orbit-quotiented MILP/MaxSAT model with a soundness certificate — for exact stabilizer/CSS/qLDPC
code-distance computation. Measured backing: 13.1x branch-and-bound node reduction on the
`[[144,12,12]]` gross code with `d_Z = 12` certified at gap zero, and CBC presolve failing to find
the symmetry on its own (`notes/quantum-codes-reports/2026-08-28-c997-symmetry-reduction-gate.md`).

#### The closest specific references

| Number | Assignee | Filed | Status | Independent-claim gist | Overlap with ergodis | Read depth |
|:---|:---|:---|:---|:---|:---|:---|
| US 2025/0190837 A1 | Microsoft Technology Licensing, LLC | 2023-12-11 (pub. 2025-06-12) | Published application; no grant seen | Computing system that receives a stabilizer *channel sequence* and per-channel fault sets, and computes a **lower-bound channel distance** by composing adjacent channel pairs and testing time-locality-satisfying partitions of each fault set | **Nearest hit in the whole vertical.** Same output type (a distance number for a quantum object) and same "decompose to make the search tractable" strategy. But: channel/circuit distance of a *sequence*, not code distance of a code; a *lower bound*, not an exact optimum; decomposition by time locality, not by a group action; no certificate, no solver model emitted | Claim 1 full text + bibliography, via FreePatentsOnline |
| US 2025/0181952 A1 | International Business Machines Corporation | 2023-12-03 | Published application | A physical qubit structure whose couplings are arranged by placement on a torus: four nearest neighbours plus two cross-couplings | This is the bivariate-bicycle *hardware layout*. No software, no distance computation. Zero overlap | Claim 1 full text + bibliography, FPO |
| US 2026/0172053 A1 | International Business Machines Corporation | 2024-12-16 (pub. 2026-06-18) | Published application | System that corrects qubit errors for a qLDPC code via a decoder combining matching and local correction | Decoding, not distance. Zero overlap | Claim 1 full text + bibliography, FPO |
| US 2026/0087389 A1 | (IBM boilerplate; assignee not individually confirmed) | not retrieved | Published application | Low-overhead fault-tolerant computation by gauging/measuring logical operators | Uses logical operators as objects; does not compute their minimum weight | Search-result row only |
| US 2025/0384317 A1 | not retrieved | not retrieved | Published application | Regional decoders for quantum error correction | Decoding. Zero overlap | Search-result row only |
| US 12,361,311 / US 2024/0354629 A1 | not retrieved | not retrieved | Granted + application | Quantum error correction using a code with simpler pairwise checks; "automorphism" appears in the specification | Automorphism appears as code-construction vocabulary, not as a search-reduction mechanism | Search-result row only |
| US 2021/0126652 A1 and EP 4049193 A1 | not retrieved | not retrieved | Published applications | Fault-tolerant quantum error correction with linear codes | The **only** documents in the searched corpus whose specification contains all of "minimum distance", "automorphism group", and "error correcting code". Overlap is vocabulary co-occurrence in a specification, not a claim | Search-result row only |
| US 10,789,540 / US 2017/0300817 A1 | D-Wave Systems (from title-family context; not individually confirmed) | not retrieved | Granted | Embedding problems into an analog processor by generating an **automorphism of the problem graph** | The closest *generic* use of an automorphism inside an optimization pipeline found anywhere. But it generates an automorphism to find a hardware embedding, not to quotient a search space, and there is no certificate | Search-result row only |

#### Prior art on automorphism-based symmetry reduction in distance computation

No patent claims it, in any vertical. Confirmed by the negatives in §2.1.1. The prior art that does
exist is entirely academic and entirely unpatented:

- **Orbital branching and isomorphism pruning in integer programming** (Margot; Ostrowski,
  Linderoth, Rossi, Smriglio). Zero US patents mention "orbital branching" in combination with
  integer programming (§2.1.1). This is 35 U.S.C. §102/§103 prior art regardless of being
  unpatented — it caps what a provisional can claim, but it does not block practice.
- **Certified symmetry breaking with permutation witnesses** — Bogaerts, Gocht, McCreesh and
  Nordström, *Certified Dominance and Symmetry Breaking for Combinatorial Optimisation*, JAIR 77
  (2023) 1539–1589, DOI 10.1613/jair.1.14296. Carried at the read depth recorded in
  `notes/2026-08-29-ergodis-certificate-prior-art-veripb.md` §5.3 (full text of the dominance rule,
  Definition 13); not re-read here.
- **Classical minimum-distance computation** — Brouwer–Zimmermann and its descendants. Magma and
  GAP/GUAVA both ship automorphism machinery (Leon/Unger) and both keep it *separate* from
  `MinimumWeight`; per `notes/2026-08-28-ergodis-ldpc-quantum-angle.md` §4.3, no exact qLDPC
  distance tool in 2026 wires the two together. Carried at that note's read depth (delegated web
  survey, mixed quoted/unverified); not re-read here.
- **The bridge is stated as unbuilt in print** — Davenport, Blue and Chuang (MIT),
  arXiv:2606.05044, quoted in `notes/2026-08-28-ergodis-ldpc-quantum-angle.md` §4.1 at *quoted from
  the PDF* depth: their automorphism analysis "pays no attention to the resulting distance."

#### 2.1.1 Negatives — quantum and generic symmetry

Searched domain for every line below: **FreePatentsOnline expert search over US granted patents
(`uspat`) and US published applications (`usapp`), full corpus as indexed 2026-08-29.** Stop
condition: each query returned either zero documents or a hit set small enough to screen every
title and abstract fragment manually; no query was abandoned for size.

| Query (verbatim) | Hits | Outcome |
|:---|---:|:---|
| `ACLM/"minimum weight" AND ACLM/"logical operator"` | 0 | Nobody claims computing the minimum weight of a logical operator — the exact ergodis quantum objective |
| `ACLM/"symmetry" AND ACLM/"reduced model" AND ACLM/"solver"` | 0 | No claim to emitting a symmetry-reduced model to a solver |
| `SPEC/"symmetry reduction" AND ACLM/"optimization problem"` | 0 | No claim to symmetry reduction of an optimization problem, generically |
| `SPEC/"orbital branching" AND SPEC/"integer program"` | 0 | Margot/Ostrowski-style symmetry handling in IP is unpatented |
| `ACLM/"symmetry" AND ACLM/"mixed integer"` | 2 | Both unrelated (US 2008/0158262, digital-light-modulator bit sequencing) |
| `ACLM/"branch-and-bound" AND ACLM/"symmetry"` | 2 | Both unrelated (ultra-wideband spectrum shaping) |
| `ACLM/"automorphism group"` (worldwide, all DBs) | 10 | All cryptography, decoding, or neural-decoder documents; none in optimization or distance computation |
| `ACLM/"group action" AND ACLM/"optimization"` | 3 | All unrelated (discriminant analysis, leadership training, a thermodynamics filing) |
| `ACLM/"orbit" AND ACLM/"permutation group"` | 11 | All one Chinese family on permutation-group *modulation codes*; none on search reduction |
| `ACLM/"soundness certificate" OR ACLM/"certificate of correctness"` | 0 | No claim to emitting a soundness certificate for a model transformation |
| `ACLM/"code distance" AND ACLM/"determining" AND SPEC/"quantum"` | 21 | Screened on title + abstract fragment; every one uses code distance as an *input parameter* (decoder selection, gate synthesis, resource estimation), none computes it |
| `ACLM/"computing a distance" AND SPEC/"stabilizer"` | 18 | All false friends (motion estimation, photography, aircraft taxiing) |
| `TTL/"quantum low-density parity"` | 3 | Both retrieved are decoders |
| `SPEC/"quantum low-density parity check" AND SPEC/"automorphism"` | 3 | Fermionic encoding, Clifford fault correction — vocabulary co-occurrence only |
| `SPEC/"bivariate bicycle"` (all DBs) | 5 | Listed in the table above; none is a distance-computation filing |
| `AN/"PsiQuantum" AND SPEC/"code distance"` | 29 | Screened on title; all architecture, decoding, compilation, or photonic-hardware filings. No distance-computation claim |

Not separately searchable by assignee in this corpus and therefore **NOT COVERED**: Google Quantum
AI, Quantinuum, AWS/Amazon Braket, Alice & Bob, Xanadu, Riverlane, Infleqtion. Assignee-field
queries against FreePatentsOnline are unreliable for these names (see §2.5), and the Google Patents
assignee facet was unavailable all session. This is a **could not access** gap, not a negative.

**Blocking-risk rating: LOW.** No claim found reads on emitting an orbit-quotiented distance model
or on certifying the reduction. The one nearby pending application (Microsoft's channel-distance
lower bound) is a different object by a different mechanism. The residual risk is temporal: IBM's
qLDPC filings are ~18 months from filing to publication, so anything filed after roughly early 2025
is invisible today.

### 2.2 Vertical (b) — Storage

**ergodis' relevant product.** Exact minimum-helper recovery planning and scheduling for
user-supplied finite layouts. No bandwidth model, no timing model. The only overlap surface is
**helper-set selection for reconstruction**, and that surface is occupied.

#### Microsoft's LRC family

| Number | Assignee | Filed | Granted | Independent-claim gist | Read depth |
|:---|:---|:---|:---|:---|:---|
| US 8,473,778 | Microsoft Corporation | 2010-09-08 | 2013-06-25 | Erasure-code a *sealed read-only extent* after first grouping its data blocks together and its index blocks together | Claim 1 full text + bibliography, FPO |
| US 9,244,761 | Microsoft Technology Licensing, LLC | 2014-03-24 | 2016-01-26 | Divide data into per-zone chunks, sub-divide each into sub-zone fragments, compute reconstruction parities at both levels | Claim 1 full text + bibliography, FPO |
| US 9,378,084 | Microsoft | not retrieved | not retrieved | Erasure coding across multiple zones | Search-result row only |
| US 10,187,083 | Microsoft (inventor set includes Gopalan and Yekhanin) | not retrieved | 2019 (from number range; not confirmed) | Flexible erasure coding with enhanced local protection group structures | Search-result row only |
| US 9,983,959 | Microsoft (Gopalan, Yekhanin) | not retrieved | not retrieved | Erasure coding within a group of storage units **based on connection characteristics** | Search-result row only. Title suggests helper/placement selection driven by link properties — the closest Microsoft document to the overlap surface, and the one to pull first in a paid search |
| US 9,141,679 | Microsoft (Simitci) | not retrieved | not retrieved | Cloud data storage using redundant encoding | Search-result row only |
| US 7,930,611 | Microsoft (pyramid codes) | not retrieved — **dates unverified** | not retrieved | Erasure-resilient codes having multiple protection groups | Search-result row only |
| US 7,904,782 | Microsoft (pyramid codes) | not retrieved — **dates unverified** | not retrieved | Multiple protection group codes having maximally recoverable property | Search-result row only |

The 2007-numbered pyramid-code pair is old enough that expiry is likely, but I did not retrieve
filing dates and must not assert it. Treat as unknown status.

Note a correction to the task premise: I did **not** find a Microsoft patent titled "local
reconstruction codes". `TTL/"local reconstruction codes"` returns exactly one US grant,
**US 11,748,009, "Erasure coding with overlapped local reconstruction codes"** (assignee not
retrieved; the family includes EP 3803599 A1/A4). The Azure LRC work appears to be protected
through the erasure-coding-across-zones and local-protection-group filings above rather than under
its paper's name.

#### The helper-selection claims — the only real overlap

| Number | Assignee | Filed | Granted | Independent-claim gist | Overlap | Read depth |
|:---|:---|:---|:---|:---|:---|:---|
| **US 10,187,088** | The Regents of the University of California | 2015-04-17 | 2019-01-22 | A distributed database network configured to recover a failed node by **incrementally engaging the surviving subset of storage nodes according to an accessing cost associated with each node**, with progressive engagement | **Closest reference in the vertical.** Same problem — decide *which* surviving nodes to read from — and the claim covers a selection *policy* over helpers. It differs in that the policy is greedy/progressive and cost-driven, where ergodis solves for an exact minimum-cardinality helper set over a stated finite layout. An examiner would call ergodis' version a species; an accused-infringement analysis would turn on whether "incrementally engage according to accessing cost" reads on a solver that returns a minimum set. **This one needs a lawyer, not an agent.** | Claim 1 full text + bibliography, FPO |
| US 11,513,898 | Regents of the University of Minnesota | 2020-06-19 | 2022-11-29 | Distributed storage system with n nodes, file recoverable from k nodes, failed node recovered from a recited number of **helper nodes** (exact-repair regenerating code) | Recites helper nodes structurally as part of a code construction; does not claim *choosing* them. Lower risk than US 10,187,088 | Claim 1 full text + bibliography, FPO |
| US 10,140,172 | Cisco Technology, Inc. | 2016-08-31 | 2018-11-27 | A network-aware data repair engine that computes a **feasible repair log** for n fragments by receiving a predictive failure scenario, identifying candidate repairs, testing feasibility, and logging only feasible ones | Structurally very close to "enumerate the repair options for a layout and keep the ones that work." It is gated on a *predictive failure scenario* and network awareness, which ergodis explicitly does not model — that is the distinguishing limitation, and it is the only one | Claim 1 full text + bibliography, FPO |
| US 10,686,471 | not retrieved | not retrieved | Granted | One-sub-symbol linear repair schemes for a single Reed–Solomon erasure | Repair-bandwidth construction, not helper selection | Search-result row only |
| US 9,465,692 | not retrieved | not retrieved | Granted | High-reliability erasure code distribution; treats some erasure codes differently | Only hit for the combination "selecting / subset / reconstruct / erasure code" in claims | Search-result row only |
| US 7,904,782, US 8,051,362, US 12,468,601, US 12,135,881, US 10,374,637 | various | — | Granted | Protection-group and load-balancing filings surfaced by `ACLM/"protection group" AND ACLM/"erasure"` | Screened out on title: placement and load balancing, not reconstruction-helper choice | Search-result rows only |

#### 2.2.1 Negatives — storage

Same searched domain and stop condition as §2.1.1.

| Query (verbatim) | Hits | Outcome |
|:---|---:|:---|
| `ACLM/"selecting a subset of" AND ACLM/"storage nodes" AND ACLM/"repair"` | 0 | The literal phrasing of ergodis' function is unclaimed |
| `ACLM/"reconstruction" AND ACLM/"select" AND ACLM/"minimum number" AND ACLM/"storage node"` | 0 | Nobody claims *minimum-cardinality* helper selection |
| `AN/"Facebook" AND ACLM/"erasure cod"` | 0 | No Meta/Facebook erasure-coding claim found. See the assignee-field caveat in §2.5 — treat as weak |
| `AN/"Huawei" AND ACLM/"repair" AND ACLM/"erasure code"` | 0 | Same caveat; and Huawei's storage filings are heavily CN-first, a corpus this search does not cover |
| `SPEC/"Xorbas"` | 2 | US 10,922,173 and US 11,531,593; neither is Meta's. The Xorbas HDFS work appears to be published-only |
| `ACLM/"repair schedule" OR ACLM/"repair scheduling"` | 29 | Screened on title: vehicles, drill bits, steam traps, medical equipment. One storage hit (US 11,119,845, scheduled anti-entropy repair) is replica-consistency scheduling, not erasure-code helper choice |
| `ACLM/"helper node"` | 26 | Screened on title: mostly wireless and thread-level parallelism. US 11,513,898 is the only storage hit and is listed above |
| `ACLM/"regenerating code"` | 25 | Screened; the term is dominated by "regenerating source code" false friends |
| `ACLM/"local reconstruction code"` / `ACLM/"locally repairable"` | 9 / 6 | All construction or placement claims; none on helper choice |

**Blocking-risk rating: MEDIUM.** Not because any claim clearly reads on ergodis, but because the
vertical is dense with live, well-capitalized grants (Microsoft, Cisco, Pure Storage, Dell/EMC, two
university licensing offices), the products are commercial-scale, and the single overlap surface is
exactly where a granted university patent (US 10,187,088) sits. Alibaba alone has 40 US grants
whose claims recite "erasure"; Chinese-origin filings are the largest uncovered pocket.

### 2.3 Vertical (c) — Automata / verification

| Number | Assignee | Filed | Granted | Arithmetic expiry (20 yr from filing; **status not verified**) | Independent-claim gist | Read depth |
|:---|:---|:---|:---|:---|:---|:---|
| US 6,243,679 | AT&T Corporation | 1998-10-02 | 2001-06-05 | ~2018-10 — **expired** | Determinizing a weighted labeled non-deterministic graph, recited inside a speech-recognition pipeline (receive speech signals, convert to word sequences, evaluate word probabilities) | Claim 1 full text + bibliography, FPO |
| US 6,456,971 | AT&T Corp. | 2000-10-27 | 2002-09-24 | ~2020-10 — **expired** | Same family, generalized from speech to pattern recognition: reduce redundancy/size of a non-deterministic weighted labeled graph by generating a deterministic one | Claim 1 full text + bibliography, FPO |
| US 7,240,004 | AT&T Corp. | 2002-06-20 | 2007-07-03 | ~2022-06 — **expired** | Decide whether a weighted finite-state transducer is determinizable | Claim 1 full text + bibliography, FPO |
| US 7,783,485 | AT&T Intellectual Property II, L.P. | 2007-06-29 (continuation) | 2010-08-24 | Term runs from the 2002 parent → ~2022-06 — **expired** | Determinizability by composing the transducer with its inverse and testing the composition | Claim 1 full text + bibliography, FPO |
| **US 8,515,891** | Microsoft Corporation | 2010-11-19 | 2013-08-20 | ~2030-11 — **live** (maintenance-fee status not checked) | Process a regular expression or pattern into a **symbolic finite automaton**, labeling each transition by a formula representing a character range | Claim 1 full text + bibliography, FPO |
| US 8,666,931 | not retrieved | not retrieved | Granted | — | Regular-expression matching using TCAMs for intrusion detection; DFA minimization appears in the claims | Search-result row only |
| US 6,965,858, US 7,181,386, US 7,107,205, US 6,760,636, US 6,961,693, US 6,952,667, US 6,816,830, US 7,617,089 | Xerox/PARC-era transducer filings (assignees not retrieved) | — | Granted | All pre-2010 filings, arithmetically expired | Transducer ambiguity factoring, alphabet reduction, morphology-rule compilation | Search-result rows only |

US 8,515,891 is the only live patent found in this vertical. Its claim 1 is a *conversion* claim —
regex in, symbolic automaton out — and requires transitions labeled by character-range formulas.
ergodis compiles a typed multi-sort presentation with unary-context generators and does not accept
regular expressions or label transitions by predicates over an alphabet. On its face the claim does
not read on ergodis, but this was a one-claim read, not a claim chart.

#### 2.3.1 Negatives — automata

| Query (verbatim) | Hits | Outcome |
|:---|---:|:---|
| `ACLM/"symbolic automat"` | 0 | Even Microsoft's own symbolic-automata patent does not use the phrase in its claims |
| `ACLM/"minimization" AND ACLM/"deterministic finite automaton"` | 1 | US 8,666,931 only — TCAM regex matching |
| `IN/"Mohri" AND ACLM/"automat"` | 0 | **Do not read this as a negative about Mohri.** He is an inventor on the AT&T family above; the FPO inventor field evidently does not index him against those documents. This is an indexing failure, recorded as such |
| MATA / Brno FIT automata library | — | **NOT COVERED.** No assignee-field search was run for Masaryk University or Brno University of Technology; the FPO assignee field proved unreliable (§2.5) |

Also carried forward: `notes/2026-08-29-ergodis-certificate-prior-art-veripb.md` §4.6 ran a bounded
Google Patents sweep for certified automata minimization (field-restricted abstract and claims
queries with single-digit hit counts, all inspected and off-topic) and found nothing on point. That
sweep is **secondary only** here — I did not re-run it, because Google Patents was unreachable all
session (§2.5).

**Blocking-risk rating: LOW.** Confirmed as expected. The commercially relevant patents in weighted
automata all issued to AT&T in 1998–2007 and have run their term.

### 2.4 Vertical (d) — Exact solvers

| Number | Assignee | Filed | Granted | Independent-claim gist | Overlap | Read depth |
|:---|:---|:---|:---|:---|:---|:---|
| US 9,524,471 | SAS Institute Inc. | 2013-10-31 | 2016-12-20 | Receive a MILP with global bounds; pre-process it; establish a threshold for a learning-phase branch-and-cut process; run a first learning phase, then a second phase using what was learned (conflict resolution and cut stabilization) | Closest "algorithm inside a MIP solver" claim found. Wholly about branch-and-cut internals; nothing about symmetry, groups, or model reduction | Claim 1 full text + bibliography, FPO |
| US 10,162,798 (and sibling US 10,061,569) | International Business Machines Corporation | 2017-02-17 | 2018-12-25 | Apparatus that generates a relaxed MIP by relaxing **only a portion** of the integer variables, and branches only on the relaxed portions | Partial-relaxation strategy, not symmetry. No overlap | Claim 1 full text + bibliography, FPO |
| US 9,213,550 and US 9,448,793 | SAS Institute Inc. | not retrieved | Granted | Automated decomposition for MILPs with embedded networks, requiring minimal syntax | Automatic *structure detection* in a user model — the nearest conceptual neighbour to automatic symmetry detection. Detects network substructure for decomposition, not a group | Search-result rows only |
| US 2009/0228291 A1 | not retrieved | Application | Identifying conflicting constraints in mixed integer programs | Infeasibility diagnosis | Search-result row only |
| US 10,237,200, US 9,479,451, US 10,163,066, US 11,847,494, US 9,495,211 | Google (from the assignee-field query) | — | Granted | Allocating computing resources, phrased over an integer program | All are *applications* of integer programming to resource allocation. Google holds no solver-technology patent found here; OR-Tools is unprotected by patent | Search-result rows only |

#### 2.4.1 Negatives — solvers

| Query (verbatim) | Hits | Outcome |
|:---|---:|:---|
| `AN/"Gurobi"` (granted + applications) | 0 | **Confirmed: Gurobi Optimization holds no US patents in this corpus.** Consistent with their public position |
| `AN/"Fair Isaac" AND ACLM/"integer program"` | 0 | FICO holds a large analytics portfolio but nothing claiming integer-programming technique |
| `AN/"Fair Isaac" AND SPEC/"Xpress"` | 0 | Xpress appears to be trade-secret/copyright protected, not patented |
| `AN/"Hexaly" OR AN/"LocalSolver"` | 0 | No filings |
| `ACLM/"presolve"` | 8 | Screened on title: optimal control, infeasibility diagnosis, vehicle motion planning. No vendor presolve patent |
| `ACLM/"cutting plane" AND ACLM/"integer program"` | 0 | — |
| `ACLM/"model reduction" AND ACLM/"quotient"` | 0 | — |
| `ACLM/"proof log" OR ACLM/"proof logging"` | 7 | Screened: microprocessor config logging, blockchain audit, marketplace bidding, AI red-teaming, secure inference. **No proof-logging patent in the solver sense** |
| `ACLM/"unsatisfiability proof"` | 0 | — |
| `ACLM/"certificate" AND ACLM/"satisfiability"` | 0 | — |
| `ACLM/"MaxSAT" OR ACLM/"maximum satisfiability"` | 23 | Screened on title: tensor memory layout, test-vector generation, network config repair, rule learning. All are *applications*; none claims MaxSAT solver technique |
| `ACLM/"symmetry" AND ACLM/"satisfiability"` | 5 | Logic synthesis and protein design; none is a SAT symmetry-breaking claim |

**VeriPB specifically: no patents.** Neither the tool name nor the technique surfaced in any
claim-field query. Consistent with it being an academic project under an open licence.

**Blocking-risk rating: LOW.** Commercial solver vendors compete on implementation, not patents.
ergodis sits *outside* the solver as a model-emitting front end, which is the least-encumbered
position in the stack.

### 2.5 Coverage statement — what was not reachable

- **Google Patents was unreachable for the entire session.** Both WebFetch and direct `curl` to
  `patents.google.com` (patent pages and the `xhr/query` endpoint) returned HTTP 503 with Google's
  anti-automation page. Consequences: no CPC-classification-expanded search, no assignee facet, no
  legal-status field, no automatic family listing, and **no coverage of CN, KR, or full-text JP**.
  This is a **could not access** gap, not a negative.
- **The corpus actually searched** was FreePatentsOnline expert search over US granted patents and
  US published applications, with a handful of queries widened to its EP, PCT, JP-abstract and
  DE-abstract collections. It has no Chinese full text. Chinese-origin filings on erasure-code
  repair and on qLDPC are numerous, and vertical (b) in particular is materially under-covered.
- **The FPO assignee field (`AN/`) is unreliable.** It returned 0 for `AN/"Facebook"` on erasure
  coding and 0 for `AN/"ILOG"` entirely, while returning plausible sets for Microsoft, IBM, SAS,
  Alibaba and PsiQuantum. Every `AN/`-based zero in this report is therefore weak evidence and is
  marked as such where it matters.
- **No legal-status verification.** Expiry dates are arithmetic from the filing date. Maintenance
  fees, terminal disclaimers, patent-term adjustment, and post-grant proceedings were not checked
  for any document.
- **USPTO Patent Public Search, Espacenet, Lens.org** were not used. Lens and Espacenet are
  JavaScript applications that this session's tooling cannot drive; USPTO PPS requires a session
  token. Recorded as NOT COVERED.
- **No claim charts.** Every "overlap" judgement above rests on reading claim 1 once, or on a
  title.

---

## 3. Cross-cutting risks

### 3.1 US subject-matter eligibility (35 U.S.C. §101) is the dominant risk, not prior art

Every ergodis claim is a mathematical method executed on a computer. Under the Alice/Mayo two-step
framework — still governing law as of August 2026 — mathematical concepts, formulas, algorithms and
mental processes are abstract ideas, and running a known process on a computer does not supply the
inventive concept. The Patent Eligibility Restoration Act (S. 1546, 119th Congress, reintroduced
2025-05-01 by Tillis and Coons with House companions from Kiley and Peters) would replace this with
a "practically performed" test that would plainly cover ergodis, but as of 2026-08-08 it has not
been marked up, reported out of committee, voted on, or signed. Do not plan around it.
*(Read depth for this paragraph: secondary only — a WebSearch result set over practitioner blogs
and Lexology/Mondaq commentary, 2026-08-29; no statutory text or case text was read.)*

Practical consequence, and it points the same way as the prior VeriPB note: **a claim written as
mathematics will be rejected; a claim written as a data format plus a machine that consumes it has
a chance.** The specific hooks available to ergodis are the framed on-disk certificate format with
its `ERGSEP01` header, the constant-residency streaming verifier, and — in the quantum vertical —
the physical tie to configuring an error-correcting memory in a quantum computing device.

### 3.2 EPO exclusion is worse than the US position for three of four verticals

Article 52(2) EPC excludes mathematical methods and programs for computers as such, and G 1/19
requires a technical effect for a computer-implemented simulation or calculation to count. Verticals
(c) and (d) are pure computation and would be refused. Vertical (b) has a credible technical effect
(fewer disk reads during reconstruction in a physical storage array). Vertical (a) has the strongest
one available: the output configures error correction for a physical quantum memory, which is
argued the same way a chip-design tool is. *(Read depth: none — this is my own reading of well-known
doctrine, not sourced in this session. Verify with counsel before relying on it.)*

### 3.3 The generic "symmetry reduction of an optimization model" claim does not exist — and that
cuts both ways

Four independent queries for a generic claim to symmetry reduction of an optimization problem
returned zero (§2.1.1). Nobody owns this idea. But nobody filed on it during the twenty years when
orbital branching, isomorphism pruning, orbitopal fixing and certified symmetry breaking were being
published either — and the reason is almost certainly that everyone concluded the same thing: it is
mathematics, it is published, and §101 makes it unclaimable. **Absence of patents here is evidence
about patentability, not only about freedom to operate.** Weigh it accordingly before spending on a
provisional.

### 3.4 Publication timing

ergodis' distinguishing results are already headed for publication. A US provisional does not block
that: filing first, publishing second, preserves both the US 12-month conversion window and foreign
absolute-novelty rights. Publishing first and filing later forfeits Europe and most of Asia
immediately. If a provisional is going to be filed at all, it must go in **before** the C997 result
is posted publicly.

---

## 4. Freedom-to-operate recommendations

Ranked by expected value of a paid search.

1. **Storage — commission a paid FTO search before first sale. This is the only vertical that
   warrants one.** Scope it to helper-set selection and reconstruction-read planning, expressly
   including US 10,187,088 (UC Regents), US 10,140,172 (Cisco), US 9,983,959 (Microsoft) and
   US 11,513,898 (UMinn), and expressly including CN-origin families, which this survey could not
   see at all. Ask for legal status and family scope on the Microsoft local-protection-group
   documents, whose dates I could not retrieve. Rough scope: a targeted single-technology FTO, not
   a full clearance.
2. **Quantum — do not commission an FTO yet; set up a monitoring alert instead.** The space is
   empty today, and a paid search would mostly confirm §2.1.1 at a cost that buys nothing. Set a
   quarterly alert on CPC G06N10/70 (quantum error correction) and H03M13/11 crossed with
   "distance", plus new publications assigned to IBM, Google/Alphabet, PsiQuantum, Microsoft and
   Quantinuum. Escalate to a paid FTO only when a deal reaches a contract with an IP-indemnity
   clause, since the publication lag means anything filed after early 2025 is currently invisible.
3. **Automata and solvers — no FTO.** The AT&T weighted-transducer family is expired, Gurobi,
   FICO/Xpress and Hexaly hold nothing, and the one live automata patent (US 8,515,891) claims a
   regex-to-symbolic-automaton conversion ergodis does not perform. Re-check only if the product
   ever grows a regular-expression front end, which would put it inside US 8,515,891's claim
   language.

---

## 5. Provisional-patent recommendation

**Recommendation: file one narrow US provisional, on the quantum bridge only. Do not file on the
certified compiler, on storage, on automata, or on solver front-ending.**

This is consistent with, not a reversal of, `notes/2026-08-29-ergodis-certificate-prior-art-veripb.md`
§5.4. That note found the *certified compiler* anticipated at the component level by
Smetsers–Moerman–Jansen 2016, Kupferman–Lavee–Sickert 2021 and the VeriPB ecosystem, and advised
against filing unless a residue could be named in one sentence. This survey looks at a different
object — the quantum application — and finds it patent-empty, with a measured result behind it.

### 5.1 The residue, in one sentence

> Compute the automorphism group on the **code's own algebraic presentation** — its parity-check
> matrices and their bivariate-polynomial or group-algebra structure — rather than on the encoded
> 0-1 constraint matrix, then emit a minimum-weight integer program whose variables are restricted
> to orbit representatives under that group together with a per-instance replayable certificate
> that the orbit cover is complete, so that the reduced program's optimum is provably the exact code
> distance and not merely an upper bound.

Over the closest three references, the residue holds as follows.

- **Over Margot-style orbital branching and isomorphism pruning in integer programming** (academic,
  unpatented): those compute the symmetry group *of the formulation*, from the constraint matrix.
  The C985 measurement is the concrete gap — the gross code's semantic translation group has order
  72, the encoded per-logical formulation retains order 2, and a matrix-automorphism pass correctly
  recovers only the order-2 group because the rest are no longer automorphisms of the encoded
  problem. Computing the group above the encoding and pushing it down is the difference, and it is
  measurable.
- **Over Bogaerts–Gocht–McCreesh–Nordström certified dominance and symmetry breaking** (JAIR 2023):
  their witnesses are substitutions over encoded literals, so by construction they cannot certify a
  symmetry the encoding destroyed. Their rule certifies soundness of a reduction performed; the
  orbit-cover certificate additionally establishes that the cover is complete, which is what makes
  the reduced optimum equal to the true distance rather than a bound.
- **Over Bravyi, Cross, Gambetta, Maslov, Rall and Yoder's published `distance_test.py`** plus the
  Wang–Pryadko reduction: they solve k unreduced integer programs per code with no symmetry
  breaking at all, on a code that is manifestly `Z_l x Z_m` symmetric. The reduction is simply
  absent, and IBM's own 2026 follow-up left 117 of 368 codes at upper bounds only.

### 5.2 Why file

- **Patent-empty claim space.** Not one document in the searched corpus claims computing a code
  distance from a code's automorphism group, or emitting an orbit-quotiented model for any solver.
- **Named as an open problem by the group best placed to close it** — Davenport, Blue and Chuang,
  arXiv:2606.05044, in print.
- **Enablement already exists**: 13.1x node reduction on the gross code with `d_Z = 12` certified at
  gap zero, plus an independent cross-check on the passant code. A provisional with a measured
  result and a working implementation is worth far more than one with a description.
- **The buyer set is real and funded** — IBM Quantum's roadmap rests on a distance number produced
  by an integer program, and Google Quantum AI is funding distance tooling directly.
- **Cost and optionality.** A US provisional is cheap, needs no claims, and preserves foreign
  novelty for twelve months while the result is published. Filing it costs almost nothing relative
  to the option it buys.

### 5.3 Why it might still be the wrong call — state this to counsel

The §101 argument in §3.3 is the real objection. The residue is a mathematical insight about *where*
in the pipeline to compute a group, and the last twenty years of unpatented symmetry-in-IP work
suggests the field has already concluded such insights are not claimable in the United States. If
counsel's read is that the claim cannot be anchored to a technical effect beyond "the computer runs
faster," do not convert the provisional, and spend the money on publication and on the compiler
instead. The physical hook to argue is that the method's output configures error correction for a
quantum memory device — the same argument that carries chip-design tools through Alice.

### 5.4 What not to file on

- **The certified compiler on its own** — anticipated per the prior note; unchanged.
- **Storage helper-set selection** — filing into a space already held by a granted university
  patent invites a fight over a small market.
- **Automata minimization** — anticipated by Smetsers–Moerman–Jansen with a public implementation
  in AutomataLib/LearnLib.
- **Solver front-ending generically** — this is where §3.3's absence-as-evidence bites hardest.

### 5.5 Terminology warning, carried forward

Use the standard names in any filing: *separating sequence* (not "separating path"), *partition
refinement* or *bisimulation minimization* (not "observational minimization"), *automorphism group*,
*orbit*, *symmetry breaking*. Coined terminology does not create novelty; it hides the prior art
from the examiner, and at the information-disclosure stage that is a liability.

---

## 6. Sources consulted

### 6.1 Patent documents

All accessed through FreePatentsOnline (`https://www.freepatentsonline.com/...`) via scripted
`curl`, 2026-08-29. Granted patents at `/{number}.html`, published applications at
`/y{year}/{serial}.html`. No document was cached to the shared literature cache, which is keyed by
DOI/arXiv identifier and has no patent namespace.

**Read at claim 1 full text plus front-page bibliography — the complete list, 15 documents:**

| Number | URL |
|:---|:---|
| US 2025/0190837 A1 | freepatentsonline.com/y2025/0190837.html |
| US 2025/0181952 A1 | freepatentsonline.com/y2025/0181952.html |
| US 2026/0172053 A1 | freepatentsonline.com/y2026/0172053.html |
| US 8,473,778 | freepatentsonline.com/8473778.html |
| US 9,244,761 | freepatentsonline.com/9244761.html |
| US 10,187,088 | freepatentsonline.com/10187088.html |
| US 11,513,898 | freepatentsonline.com/11513898.html |
| US 10,140,172 | freepatentsonline.com/10140172.html |
| US 6,243,679 | freepatentsonline.com/6243679.html |
| US 6,456,971 | freepatentsonline.com/6456971.html |
| US 7,240,004 | freepatentsonline.com/7240004.html |
| US 7,783,485 | freepatentsonline.com/7783485.html |
| US 8,515,891 | freepatentsonline.com/8515891.html |
| US 9,524,471 | freepatentsonline.com/9524471.html |
| US 10,162,798 | freepatentsonline.com/10162798.html |

**Read at search-result row only — publication number, title, and abstract fragment from the FPO
result page.** This covers every other patent document named in this report, namely:
US 2026/0087389 A1, US 2025/0384317 A1, US 12,361,311, US 2024/0354629 A1, US 2021/0126652 A1,
EP 4049193 A1, US 10,789,540, US 2017/0300817 A1 (quantum, §2.1); US 9,378,084, US 10,187,083,
US 9,983,959, US 9,141,679, US 7,930,611, US 7,904,782, US 11,748,009, EP 3803599 A1/A4,
US 10,686,471, US 9,465,692, US 8,051,362, US 12,468,601, US 12,135,881, US 10,374,637,
US 10,922,173, US 11,531,593, US 11,119,845 (storage, §2.2); US 8,666,931, US 6,965,858,
US 7,181,386, US 7,107,205, US 6,760,636, US 6,961,693, US 6,952,667, US 6,816,830, US 7,617,089
(automata, §2.3); US 9,213,550, US 9,448,793, US 10,061,569, US 2009/0228291 A1, US 10,237,200,
US 9,479,451, US 10,163,066, US 11,847,494, US 9,495,211 (solvers, §2.4).

**Attempted and failed:** the US 7,930,611 and US 9,213,550 detail pages returned empty bodies on
first fetch and were not retried to conclusion; both stay at search-result-row depth.

### 6.2 Search infrastructure

- FreePatentsOnline expert search, `https://www.freepatentsonline.com/result.html?srch=xprtsrch`,
  field prefixes `ACLM/` (claims), `SPEC/` (specification), `TTL/` (title), `AN/` (assignee),
  `IN/` (inventor). Databases toggled per query among `uspat`, `usapp`, `eupat`, `pctap`, `jp`,
  `depat`. Driven by two throwaway scripts in the session scratchpad; not committed, since they
  contain no result data and the queries are recorded verbatim in §2.
- Every verbatim query and its hit count is recorded in §2.1.1, §2.2.1, §2.3.1 and §2.4.1. Zero
  results were distinguished from errors by the presence of the literal string "Your search returned
  no results" in the response body; an error page produces neither that string nor a match count and
  was retried.

### 6.3 Non-patent sources

Carried at the read depth recorded by the note that established them; none re-read here.

| Source | Where its read depth is recorded | Depth there |
|:---|:---|:---|
| Bogaerts, Gocht, McCreesh, Nordström, *Certified Dominance and Symmetry Breaking for Combinatorial Optimisation*, JAIR 77 (2023) 1539–1589, DOI 10.1613/jair.1.14296 | `notes/2026-08-29-ergodis-certificate-prior-art-veripb.md` §5.3 | full text of the dominance rule (Definition 13) |
| Smetsers, Moerman, Jansen, *Minimal Separating Sequences for All Pairs of States*, LATA 2016, LNCS 9618, 181–193, DOI 10.1007/978-3-319-30000-9_14 | same, §5.3 | as recorded there |
| Kupferman, Lavee, Sickert, *Certifying DFA Bounds for Recognition and Separation*, ATVA 2021, arXiv:2107.01566 | same, §4.4 | as recorded there |
| Davenport, Blue, Chuang, *Generalized Bicycle Codes as Cyclic Submodules and their Automorphism Structure*, arXiv:2606.05044 | `notes/2026-08-28-ergodis-ldpc-quantum-angle.md` §4.1 | quoted from the PDF |
| Bravyi, Cross, Gambetta, Maslov, Rall, Yoder, *High-threshold and low-overhead fault-tolerant quantum memory*, Nature 627, 778–782 (2024); and `distance_test.py` at `github.com/sbravyi/BivariateBicycleCodes` | same, §4.2; and `notes/quantum-codes-reports/2026-08-28-c997-symmetry-reduction-gate.md` §2.1 (pinned at commit `fa77e3333d3ec44c79d8f914dd24c040d1da471b`) | Table 3 caption quoted; script quoted from source |
| Webster, Jacob, Higgott, *Distance-Finding Algorithms for Quantum Codes and Circuits*, arXiv:2603.22532; and *SAT, MaxSAT, and SMT for QLDPC Distance Computation*, arXiv:2606.12445 | `notes/2026-08-28-ergodis-ldpc-quantum-angle.md` §4.1, §4.3 | as recorded there |

**New in this session, secondary only:** a WebSearch result set (query: *software patent eligibility
2026 Section 101 Alice mathematical algorithm PERA status*, 2026-08-29) over practitioner commentary
at Lexology, Mondaq, CASRAI and several US firm blogs, used solely for §3.1's statement that PERA
(S. 1546, 119th Congress) had not advanced past hearings as of 2026-08-08. No statutory or case text
was read. Do not cite this in anything that matters; have counsel confirm.

### 6.4 Coverage — negatives versus gaps

**Searched and found nothing** (licenses a negative, within the FPO US corpus): all queries tabulated
in §2.1.1, §2.2.1, §2.3.1, §2.4.1.

**Could not access** (licenses nothing; carried forward as open gaps): Google Patents in its
entirety, and with it all CN/KR/full-text-JP coverage and every legal-status field; USPTO Patent
Public Search; Espacenet; Lens.org; assignee-facet searching for Google Quantum AI, Quantinuum, AWS,
Alice & Bob, Xanadu, Riverlane, Infleqtion, Meta, Huawei, Masaryk University and Brno University of
Technology; inventor-field indexing for Mehryar Mohri; filing dates for US 7,930,611 and
US 7,904,782; and legal status for every document named in this report.
