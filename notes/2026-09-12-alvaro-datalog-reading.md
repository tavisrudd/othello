# Peter Alvaro's Datalog line — a reading study

**Date:** 2026-09-12. **Lane:** `ergodis`. **Disposition:** bounded reading and positioning study.
No code written; nothing under `~/src/ergodis*` edited.

## Opening summary

Nine named sources: six at partial depth — Molly at algorithm depth, with its provenance rewrite,
proof-tree extraction and SAT encoding read in full — and three at secondary only. Every
identifier was resolved from an abstract page or venue record before fetching. Nothing was read at
full text, and the two things this report most wants — Molly's soundness and completeness proofs,
and its Figure 12 cells — were not read; both are flagged where they matter.

**One correction changes the picture.** "Optimizing Distributed Protocols with Query Rewrites" is
**SIGMOD 2024, not CIDR 2024, and Peter Alvaro is not an author** — it is Chu, Panchapakesan,
Laddad, Katahanas, Liu, Shivakumar, Crooks, Hellerstein and Howard. Alvaro appears seven times in
its bibliography, so the work stands on his line, but it is Hellerstein's group continuing it.

**CALM monotonicity and `datalog°` stability are orthogonal, and the answer is clean.** They are
properties of different objects answering different questions — the program's input-output map
versus the semiring, coordination versus termination — and each has a witness the other lacks:
transitive closure over the counting semiring is CALM-monotone and diverges; stratified Datalog¬
over Boolean terminates in `N` steps and is non-monotone. Within `datalog°`, where monotonicity is
presupposed for the least fixpoint to exist, stability is the strictly stronger additional
requirement. The real alignment is with **Bloom^L**: a POPS's `⊕` is a bounded join semilattice
exactly when it is idempotent, Ergodis's bounded min-plus qualifies, and Bloom^L's morphisms are
the `⊕`-half of a Green–Karvounarakis–Tannen semiring homomorphism. Bloom^L has no `⊗` at all,
which is precisely where Ergodis lives.

**Molly's lineage is GKT provenance in `PosBool`, negated.** The proof forest gives
`prov(g) = ⋁_proofs ⋀_messages x_m`; Molly's CNF is `¬prov(g)` with `¬x_m` realised as message-
omission and crash variables. It deliberately drops multiplicity, which `N[X]` would keep —
and recovering it is exactly what turns "which faults break all proofs" into "which *cheapest*
faults break all proofs".

**The Ergodis fit is the closest found in any of these studies, and the gap is precise.** Molly
returns *a* satisfying fault set, and UNSAT as a fault-tolerance certificate; it does **not**
minimise the fault set — "minimal" in the paper refers to the swept `⟨EOT, EFF, Crashes⟩`
parameters. Restated exactly: a fault set breaks the outcome iff it is a **hitting set** of the
proof-tree hypergraph, so minimum-cardinality is minimum hitting set and minimum-cost under fault
weights is a min-plus optimisation over the same hypergraph — with "no cheaper set exists"
discharged by the VeriPB-style `red` certificate from C1151. Ergodis's contribution is one
sentence: replace "find a model" with "find a minimum-cost model plus a certificate that no
cheaper one exists", over a hypergraph the Datalog fixpoint already produced. It inherits Molly's
three preconditions — given inputs and topology, the `Fspec` bound, internal determinism — which
Ergodis's glossary already requires be declared.

**Eighth benchmark program: lineage-driven minimum-fault search over `ack-deliv`**, Molly's
retry-until-ACK reliable broadcast, with source in its Figure 5 and lineage in Figure 7, measured
on three numbers: agreement with Molly's answer, minimum fault-set cost versus Molly's first
model, and certificate-check time as a fraction of search time. The demo needs one buggy and one
bug-free protocol, and which of `ack-deliv` and `redun-deliv` is which could not be determined
from the PDF.

## Corrections to the brief, up front

Four of the details supplied from memory need fixing, and one of them changes the picture.

1. **"Optimizing Distributed Protocols with Query Rewrites" is not Alvaro's and is not CIDR.**
   Its authors are **David C. Y. Chu, Rithvik Panchapakesan, Shadaj Laddad, Lucky E. Katahanas,
   Chris Liu, Kaushik Shivakumar, Natacha Crooks, Joseph M. Hellerstein and Heidi Howard**, and
   the arXiv abstract page records it as **SIGMOD 2024**, not CIDR 2024. **Peter Alvaro is not an
   author.** He appears in its bibliography seven times — Dedalus, Bloom, Blazes, Bloom^L,
   Edelweiss, the declarative Dedalus semantics, and Keeping CALM — so the work stands squarely on
   his line, but it is Hellerstein's group continuing it, not Alvaro.
2. **Molly's venue and coauthors are right:** Peter Alvaro, Joshua Rosen and Joseph M. Hellerstein,
   all UC Berkeley, "Lineage-driven Fault Injection", SIGMOD 2015.
3. **Keeping CALM is by Hellerstein and Alvaro in that order**, CACM 63(9):72–81 (2020), with the
   arXiv preprint 1901.01930 from 2019 where Alvaro's affiliation is already UC Santa Cruz.
4. **The lattice generalisation is titled "Logic and Lattices for Distributed Programming"**
   (Conway, Marczak, Alvaro, Hellerstein, Maier, SoCC 2012); Bloom^L is the language it defines,
   not the paper's title. And **Dedalus has two versions** — the 2009 Berkeley technical report
   UCB/EECS-2009-173, which is what I read, and the 2011 chapter in *Datalog Reloaded* (Springer,
   pp. 262–281) that Chu et al. cite.

## Why this study exists

William Macready mentioned Peter Alvaro (UC Santa Cruz) to Tavis during a Datalog and
RelationalAI conversation. This study reads the work directly to establish what it actually is,
corrects the titles, years, venues and coauthor lists supplied from memory, and asks what of it
bears on Ergodis's rule-contract programme.

Carried in from earlier passes in this lane and not re-read: the `datalog°` convergence results
(Abo Khamis, Ngo, Pichler, Suciu, Wang) and Green–Karvounarakis–Tannen's provenance semirings,
both at the depths recorded in `2026-09-12-relationalai-datalog-reading.md`; and the benchmark
survey in `2026-09-12-datalog-benchmark-suites.md`, to which §5 proposes an eighth program.

## Rules followed

Read depth on every source, including any named only to be dismissed. Every PDF fetched is added
to the shared cache at `/tmp/persistent/tavis/lit-search/` with key and SHA-256. **Every arXiv or
DOI identifier resolved from an abstract page or venue record before fetching**, never from memory.
Bibliographic detail comes from a consulted source or is omitted.

## 1. Dedalus, Bloom and CALM

### 1.1 Dedalus: Datalog with a time suffix

**Peter Alvaro, William Marczak, Neil Conway, Joseph M. Hellerstein, David Maier, Russell C.
Sears, "Dedalus: Datalog in Time and Space", EECS Department, University of California at
Berkeley, Technical Report No. UCB/EECS-2009-173.** *Read depth: partial* — the Berkeley
technical report PDF, cached as `alvaro-dedalus-datalog-in-time-and-space`, SHA-256
`837cb37ebc7960ce35d1b4414a240af2b1f76bdcb364c1c3074567cf1240428e`, 12 pages; read the abstract,
§1's contribution list, and §2–§3's schema, time-suffix and rule-form restrictions. The temporal
safety and stratification proofs and the asynchrony extension in §6 were read by statement only.
**Version note: this is the 2009 technical report, not the 2011 *Datalog Reloaded* chapter**; the
two may differ and I did not compare them.

Dedalus is "a subset of a language with well-studied features: Datalog enhanced with negation,
aggregate functions, choice, and a successor relation", and it "provides a model-theoretic
foundation for the two key features of distributed systems: mutable state, and asynchronous
processing and communication."

The mechanism is one syntactic restriction. **Every predicate's final attribute ranges over `Z`
and is called its time suffix.** In a well-formed rule every subgoal carries the *same*
existential time variable `T`, and the head's time suffix `S` is constrained in exactly one of two
ways, giving two rule kinds: **deductive** rules, "instantaneous statements: their deductions hold
for predicates agreeing in the time suffix and describe what is true 'for an instant' given what
is known at that instant"; and **inductive** rules, which are "temporal — their consequents are
defined to be true 'at a different time' than their antecedents." Asynchrony is added on top with
`choice`, which is what makes message delivery time nondeterministic. Body time suffixes are
sugared away.

The paper's own claims are a temporal notion of safety, a stratification condition, and
"conservative syntactic checks" for both.

### 1.2 CALM

**Joseph M. Hellerstein, Peter Alvaro, "Keeping CALM: When Distributed Consistency is Easy",
Communications of the ACM 63(9):72–81 (2020), DOI 10.1145/3369736; arXiv:1901.01930v2 [cs.DC],
26 January 2019.** *Read depth: partial* — arXiv v2 PDF, cached as `arXiv:1901.01930`, SHA-256
`c5a12100b9ea30bfc63355c77b10df79eea9c4375dc1caace4624f2da86fb67d`, 9 pages; read in full: §1,
§2's "The Crux of Consistency: Monotonicity" through Theorem 1, the formalisation discussion of
what monotonicity means syntactically, the CRDT and lattice paragraphs, and the Bloom section.
The proof sketch's relational-transducer machinery was read by statement only. Identifier, venue,
DOI and author order resolved from the arXiv abstract page and the ACM record. Affiliations as
printed on the preprint: Hellerstein at UC Berkeley, **Alvaro at UC Santa Cruz**.

> **Definition 1.** A program `P` is monotonic if for any input sets `S, T` where `S ⊆ T`,
> `P(S) ⊆ P(T)`.
>
> **Theorem 1 (Consistency As Logical Monotonicity, CALM).** A program has a consistent,
> coordination-free distributed implementation **if and only if** it is monotonic.

Their intuition, quoted because the Ergodis mapping in §5 turns on it: "monotonic programs are
'safe' in the face of missing information, and can proceed without coordination. Non-monotonic
programs, by contrast, must be concerned that truth of a property could change in the face of new
information. Therefore they cannot proceed until they know all information has arrived, requiring
them to coordinate." And: "because they 'change their mind', non-monotonic programs are
order-sensitive … By contrast, monotonic programs simply accumulate beliefs; their output depends
only on the content of their input, not the order in which it arrives."

The syntactic reading they give: in relational logic, monotone programs are those built from
selection, projection, join, union and transitive closure — "the monotonic operators of relational
algebra" — **excluding set difference, "the sole non-monotonic operator"**, and excluding
universal quantification. They note that "deletes are not monotonic" and that there are programs
which are semantically monotone despite syntactic non-monotonicity.

### 1.3 Bloom^L: the lattice generalisation

**Neil Conway, William R. Marczak, Peter Alvaro, Joseph M. Hellerstein, David Maier, "Logic and
Lattices for Distributed Programming", ACM Symposium on Cloud Computing (SoCC 2012), San Jose,
DOI 10.1145/2391229.2391230.** *Read depth: partial* — author-hosted PDF
(`neilconway.org/docs/socc2012_bloom_lattices.pdf`), cached as `conway-2012-logic-and-lattices`,
SHA-256 `6346225b250358b4b939c264f270d3d01e51c23aec88aa999421ff5cdf416fd8`, 14 pages; read the
abstract, §1's three-improvement list, §3.1's algebraic definitions in full, and the conclusion.
The case studies (a key-value store with vector clocks, a monotonic shopping cart) and the runtime
implementation in §4 were read by statement only. Venue and DOI resolved via dblp and the ACM
record.

The algebra, quoted:

> A **bounded join semilattice** is a triple `⟨S, ⊔, ⊥⟩`, where `S` is a set, `⊔` is a binary
> operator (called "join" or "least upper bound"), and `⊥` is an element of `S` (called "bottom").
> The `⊔` operator is associative, commutative, and idempotent. The `⊔` operator induces a partial
> order `≤_S` on the elements of `S`: `x ≤_S y` if `x ⊔ y = y`. … `x ⊔ ⊥ = x` for every `x ∈ S`.

> A **monotone function** is a function `f : S → T` such that `S, T` are partially ordered sets
> and `∀a, b ∈ S : a ≤_S b ⇒ f(a) ≤_T f(b)`.

> A **morphism** from lattice `⟨X, ⊔_X, ⊥_X⟩` to lattice `⟨Y, ⊔_Y, ⊥_Y⟩` is a function `g : X → Y`
> such that `g(⊥_X) = ⊥_Y` and `∀a, b ∈ X : g(a ⊔_X b) = g(a) ⊔_Y g(b)`. … **morphisms are
> monotone functions but the converse is not true in general.**

Bloom^L classifies every lattice method as **monotone**, **morphism** or **non-monotone**, and
"so long as the program avoids non-monotonic methods, it can be realized without coordination".
Their stated improvements: CALM analysis becomes able to "assess monotonicity for arbitrary
lattices, making it significantly more liberal in its ability to test for confluence"; and
conflict-free replicated data types gain "monotonicity-preserving mappings between lattices via
morphisms and monotone functions", which the paper calls solving the CRDT "scope dilemma".
Ordinary Datalog is the special case where the merge function is fixed to set union.

**Bloom itself** — Peter Alvaro, Neil Conway, Joseph M. Hellerstein, William R. Marczak,
"Consistency Analysis in Bloom: a CALM and Collected Approach", CIDR 2011, Asilomar, pp. 249–260.
*Read depth: secondary only* — not read; bibliographic detail taken verbatim from reference [6]
of Chu et al. (arXiv:2404.01593), whose own read depth is recorded in §3.

**Blazes** — Peter Alvaro, Neil Conway, Joseph M. Hellerstein, David Maier, "Blazes: Coordination
Analysis and Placement for Distributed Programs", ACM Transactions on Database Systems 42(4),
Article 23 (October 2017), 31 pages, DOI 10.1145/3110214. *Read depth: secondary only* — not
read; detail verbatim from reference [5] of Chu et al.

**Edelweiss** — Neil Conway, Peter Alvaro, Emily Andrews, Joseph M. Hellerstein, "Edelweiss:
Automatic storage reclamation …", 2014. *Read depth: secondary only* — not read; detail verbatim
from reference [17] of Chu et al., which truncates the title in the extraction I read, so the
title above is incomplete and the venue is unrecorded.

## 2. Molly and lineage-driven fault injection

**Peter Alvaro, Joshua Rosen, Joseph M. Hellerstein (all UC Berkeley), "Lineage-driven Fault
Injection", SIGMOD 2015, DOI 10.1145/2723372.2723711.** *Read depth: partial, at algorithm
depth* — author-hosted PDF (`people.ucsc.edu/~palvaro/molly.pdf`), cached as
`alvaro-2015-lineage-driven-fault-injection`, SHA-256
`6189925547555dea428ca7c8f199988cbf2e970b2aaaf5d69056776e1cc3c31a`, 16 pages; read in full: the
abstract, §1 including the Kafka motivating bug, §2's system model and failure specification,
§3's game framing and the lineage examples, **§4.1.2 lineage rewrite, §4.2 proof tree extraction
and §4.3 solving for counterexamples in their entirety**, §5's case studies and measurement
framing, and §7's limitations. The appendix containing the soundness and completeness proofs was
**not** read. Venue, DOI and author list resolved via the ACM Digital Library and dblp records.

### 2.1 What it does, in one loop

"A lineage-driven fault injector reasons backwards from correct system outcomes to determine
whether failures in the execution could have prevented the outcome." Molly alternates:

```
forward :  run the program concretely (failure-free first), obtain outcome + lineage
backward:  extract the outcome's lineage, convert to CNF, hand to a SAT solver
           SAT solutions = fault sets that falsify every known derivation
           turn each into program inputs; go forward again
stop    :  an invariant violation (a counterexample), or
           the potential counterexamples are exhausted (a bounded guarantee)
```

### 2.2 How provenance is computed

The rewrite is attributed to Köhler et al. For every rule `r` in the (Dedalus-to-Datalog
rewritten) program, Molly synthesises a **"firings" relation** `r_prov` and a new rule `r′` with
the same premises as `r`, `r_prov` as its conclusion, and `r_prov` capturing **the bindings of all
premise variables**. Their example:

```
log1_prov(Node1, Node2, Pload, SndTime) :-
    bcast(Node1, Pload, SndTime),
    node(Node1, Node2, SndTime),
    clock(Node1, Node2, SndTime);
```

Aggregation needs two rules, one for bindings and one for the aggregate, "to prevent the capture
of additional bindings from affecting the grouping attributes of the aggregation":

```
r(X, count<Z>)      :- a(X, Y), b(Y, Z)
        ↓
r_bindings(X, Y, Z) :- a(X, Y), b(Y, Z)
r_prov(X, count<Z>) :- r_bindings(X, _, Z)
```

Querying the firings relations yields a **derivation graph**: "a directed bipartite graph
consisting of rule nodes that correspond to rule firings, and goal nodes that correspond to
records", with an edge from each goal to every rule firing that derived it and from each firing to
its premises. Each derivation graph "yields a finite forest of proof trees. Each proof tree
corresponds to a separate, independent **support** of the tree's root goal." Given a proof tree,
"the loss of any of these messages will falsify that particular proof."

### 2.3 How the fault search is posed — yes, SAT over provenance formulas

Fault variables are message omissions `O_(from,to,time)` and crash failures `C_(node,time)`.
**Each proof tree becomes a disjunction of the faults that individually falsify it; the conjunction
over all proof trees is the CNF.** Their worked formula:

```
(O_(a,c,2) ∨ C_(a,2) ∨ C_(a,1)) ∧ (O_(b,c,1) ∨ C_(b,1))
```

"corresponds to a derivation graph that represents two proofs, where the first proof can be
falsified by either dropping messages from `a` to `c` at time 2 or by `a` crashing at some earlier
time, and the second proof can be falsified by `b` crashing or the loss of its messages sent at
time 1."

**The certificate direction is the UNSAT direction, and it is stated plainly:** "If the resulting
SAT problem is unsatisfiable, then there exists at least one proof that cannot be falsified by any
allowable combination of message losses and crash failures — hence the program is fault-tolerant
with respect to that goal!" A separate SAT problem is solved per goal tuple, and the union of
solutions is the set of potential counterexamples to test.

There is one pruning optimisation worth carrying: Molly defines built-in `pre` and `post`
meta-outcomes for stating correctness as an implication, and "a potential counterexample is
reported for each set of faults that falsifies a record in `post` **unless those faults also
falsify the corresponding record in `pre`**. We need not explore such faults, as they would
result in a vacuously correct outcome."

### 2.4 What minimality it claims — and what it does not

**It does not minimise the fault set.** Molly enumerates satisfying assignments; nothing in §4.3
asks for a minimum-cardinality or minimum-weight solution. The word "minimal" in the paper attaches
to something else: the **failure specification** `Fspec = ⟨EOT, EFF, Crashes⟩` — end of time, end
of finite failures, and maximum crash count — which Molly sets "automatically by performing a
sweep", raising `EFF` until an invariant violation appears or `EFF = EOT − 1`, then raising both,
"until a user-supplied wall clock bound has elapsed", at which point it "reports either the
**minimal parameter settings** necessary to produce a counterexample, or (in the case of bug-free
programs) the maximum parameter settings explored within the time bound."

So the guarantee is: **a counterexample at the smallest Fspec the sweep reached, or bounded
absence of counterexamples up to the Fspec explored.** This is exactly the gap §5.3 proposes
Ergodis fills.

### 2.5 What it proves, and the limitations the authors state

The soundness and completeness of LDFI are proved in the appendix (not read). The completeness
guarantee rests on an assumption they name: LDFI "assumes that the distributed protocols under
test are 'internally deterministic' (i.e., deterministic modulo the nondeterminism introduced by
the environment). It leverages this assumption … to provide its completeness guarantee: if some
execution produces a proof tree of an outcome, any subsequent execution with the same faults will
also." They add that Molly "can be used to find bugs in fundamentally non-deterministic protocols
like anti-entropy or randomized consensus", but "certifying such protocols as bug-free will
require additional research."

The second stated limitation bounds the whole approach: the pseudo-synchronous abstraction "is
fundamentally incomplete" for "an important class of fault-tolerant distributed algorithms (e.g.,
those that attempt to solve consensus), … because these algorithms are required to (attempt to)
distinguish between delay and failure." Third: inputs and the execution topology are "given a
priori, either by a human or by a testing framework."

They also place LDFI against the provenance literature explicitly: "When the submitted Dedalus
program is logically monotonic, LDFI answers how-to queries using **positive why provenance**;
otherwise LDFI must also consider the **why-not provenance** of negated rule premises", and
"LDFI can be viewed as a narrow version of the 'how-to' provenance problem, restricted to
considering deletions on a single distinguished input relation (the clock)".

### 2.6 Published results

From the abstract and §1: Molly "quickly identifies **7 critical bugs in 14 fault-tolerant
systems**; for the remaining 7 systems, it provides a guarantee that no invariant violations exist
up to a bounded execution depth, an assurance that state-of-the-art fault injectors cannot
provide"; and it finds bugs "in many cases using an **order of magnitude fewer executions than
random fault injection**."

The protocol corpus, named in §3 and §5: a **delivery family** — `simple-deliv`, `retry-deliv`,
`redun-deliv`, `classic-deliv`, `ack-deliv` — the **commit protocols** 2PC, the collaborative
termination protocol (CTP) and 3PC, the **Kafka** replication subsystem, and **bully leader
election** and **Paxos**. Figure 12 lists, for each buggy program, the minimal `⟨EOT, EFF,
Crashes⟩`, the number of possible failure combinations at those parameters, the number of concrete
executions Molly performed, the wall-clock seconds, and the same measurements for random fault
injection averaged over 25 runs. **Figure 12 and Figure 11 extract with scrambled columns from the
PDF and I did not transcribe their cells**; the one number I could read cleanly is a 0.12–9.60
second range in the wall-clock column, which is not safe to attribute to specific rows.

**Caveats for any citation.** No hardware is stated anywhere I read. No SAT solver or Datalog
evaluator is named beyond "off-the-shelf components". The "order of magnitude fewer executions"
claim is against random fault injection averaged over 25 runs, which is a weak baseline by
construction. And "14 fault-tolerant systems" counts protocol variants, several of which are
five-line delivery protocols.

## 3. Hydro, Hydroflow and protocol rewriting

**David C. Y. Chu, Rithvik Panchapakesan, Shadaj Laddad, Lucky E. Katahanas, Chris Liu, Kaushik
Shivakumar, Natacha Crooks, Joseph M. Hellerstein, Heidi Howard, "Optimizing Distributed Protocols
with Query Rewrites [Technical Report]", arXiv:2404.01593v2 [cs.DC; cs.DB], 3 April 2024;
recorded on the arXiv abstract page as SIGMOD 2024.** *Read depth: partial* — arXiv v2 PDF,
cached as `arXiv:2404.01593`, SHA-256
`51db58c83ade3878d4eadce86446a561e37c734a0f0cf72f0f4f2ac6825750d6`, 42 pages; read the abstract,
§1's contribution list, §2's Dedalus review, §5's evaluation questions and setup, and the
bibliography entries for the Alvaro line. The rewrite rules and their correctness arguments in
§§3–4 and Appendices A–B were read by statement only. Identifier, author order, affiliations and
venue resolved from the arXiv abstract page and the PDF title block. **Peter Alvaro is not an
author.**

Affiliations as printed: UC Berkeley for Chu, Panchapakesan, Laddad, Liu, Shivakumar and Crooks;
Sutter Hill Ventures for Katahanas; UC Berkeley **and** Sutter Hill Ventures for Hellerstein;
Azure Research, Microsoft UK for Howard.

**The thesis:** "This paper presents an approach for scaling any distributed protocol by applying
rule-driven rewrites, borrowing from query optimization. Distributed protocol rewrites entail a
new burden: reasoning about spatiotemporal correctness. We leverage **order-insensitivity and data
dependency analysis** to systematically identify correct coordination-free scaling opportunities.
We apply this analysis to create preconditions and mechanisms for **coordination-free decoupling
and partitioning**, two fundamental vertical and horizontal scaling techniques."

They adopt Dedalus directly — "a SQL-like language such as Dedalus, which we adopt here" — and
say the relational model is what makes the optimisation possible: "Dedalus programs are an
(unordered) set of queries". Dedalus is "a dialect of Datalog¬".

**Implementation and hardware:** "All protocols are implemented as Dedalus programs and compiled
to **Hydroflow**, a **Rust dataflow runtime for distributed systems**. We deploy all protocols on
GCP using **n2-standard-4** machines", with clients sending "16 byte commands in a closed loop"
and "the ping time between machines is 0.22ms."

**Results as stated in §1 and §5.2:** "the throughput of the optimized voting, 2PC, and Paxos
protocols scale by 2×, 5×, and 3× respectively"; BaseVoting uses 4 machines and ScalableVoting 26,
reaching 250,000 commands/s; Base2PC uses 4 machines and Scalable2PC 46, reaching 160,000
commands/s; BasePaxos uses 8 machines and ScalablePaxos 29, reaching 150,000 commands/s. They
compare against a hand-optimised "CompPaxos" which "peaked at 130,000 commands/s" on 20 machines.

**Caveats.** The rewrites are **applied manually** — "we will refer to our approach of manually
modifying distributed protocols with the mechanisms described in this paper as rule-driven
rewrites" — and the automated optimiser is future work ("These results point the way toward
automated optimizers"). The speedups come with large machine-count increases (4→46 for 2PC), so
throughput-per-machine is a different and unreported number. They also state a structural
limitation of their own approach: it "treats the initial implementation as 'law'. It cannot
distinguish between true protocol invariants and implementation artifacts, limiting the space of
potential optimizations."

**On 2024–2026 Alvaro work on protocol rewriting or BFT:** I searched and did not find any. A
search for Alvaro's recent output surfaced venues (SoCC 2025, DBPL 2025, HotOS 2025, CIDR 2025
with "Deterministic Record-and-Replay") but nothing on protocol rewriting or BFT scaling
attributable to him, and the BFT papers that surfaced (Clownfish, Beluga, Prefix Consensus) I did
not verify as his and do not attribute. **Recorded as searched-and-found-nothing over web search
only, which is a weak negative.**

## 4. The LogicBlox and RelationalAI lineage

**Molham Aref, Balder ten Cate, Todd J. Green, Benny Kimelfeld, Dan Olteanu, Emir Pasalic,
Todd L. Veldhuizen, Geoffrey Washburn (all LogicBlox, Inc.), "Design and Implementation of the
LogicBlox System", SIGMOD 2015.** *Read depth: partial* — PDF hosted at
`cs.ox.ac.uk/dan.olteanu/papers/logicblox-sigmod15.pdf`, cached as `aref-2015-logicblox-sigmod`,
SHA-256 `6fb7d227206d69ba14b24ae296d8ea5f9baa7fbe19c9655fa06d3e8e463b2d8c`, 12 pages; read the
author block, the abstract, and §1's description of LogiQL and its design claims. The engine
internals were skimmed. The paper is also hosted on RelationalAI's own resources site.

What the sources support, and no more:

- **LogiQL is "an extended form of Datalog"**, and the paper's keyword list is "LogicBlox;
  LogiQL; Datalog; Leapfrog Triejoin; Incremental Maintenance; Transaction Repair; Live
  Programming; Predictive [analytics]". Leapfrog Triejoin is LogicBlox's worst-case-optimal join
  algorithm, which is the ancestor of the Generic Join / Free Join line read in the companion
  RelationalAI study.
- **The LogicBlox paper cites Bloom by name and borrows its vocabulary**: the claim that LogiQL's
  semantics is "largely independent of the [evaluation strategy] … tied to a particular physical
  evaluation strategy" is glossed with "(an apt phrase from the Bloom project [4])". That is a
  direct, documented link from the Alvaro–Hellerstein line into the LogicBlox line.
- **Todd J. Green is an author of both** the LogicBlox paper and Green–Karvounarakis–Tannen's
  "Provenance Semirings" (PODS 2007), the `K`-relation construction that `datalog°` builds on. So
  the provenance-semiring thread runs through LogicBlox, not around it.
- **Molham Aref is first author of the LogicBlox paper and is listed at RelationalAI on the Rel
  paper** (Aref et al., SIGMOD 2025, read in the companion study). *Read depth for the
  founder/CEO claim: abstract/metadata only* — from the RelationalAI resources page and a
  published interview surfaced by search, which state he founded and leads RelationalAI and
  previously led LogicBlox and Predictix. I did not read a primary corporate record.

**What the sources do not support.** I found **no documented research or institutional relation
between Alvaro or Hellerstein and RelationalAI** beyond LogicBlox's citation of Bloom and the
shared intellectual neighbourhood (Datalog, provenance, worst-case-optimal joins, aggregation in
recursion). Hellerstein's current industry affiliation on the Chu et al. paper is **Sutter Hill
Ventures**, not RelationalAI. Any stronger claim about the lineage would be speculation and is not
made here.

## 5. Mapping onto Ergodis

Inferences here are mine unless attributed. `datalog°` and Green–Karvounarakis–Tannen are used at
the depths recorded in `2026-09-12-relationalai-datalog-reading.md`.

### 5.1 CALM monotonicity versus `datalog°` stability

They are **not the same condition, and neither is weaker or stronger than the other in general**,
because they are properties of different objects answering different questions.

| Aspect            | CALM monotonicity              | datalog-over-POPS stability      |
|-------------------|--------------------------------|----------------------------------|
| Property of       | the program input-output map   | the semiring P-plus-bottom       |
| Statement         | S subset T implies P(S) ⊆ P(T) | u^(p) equals u^(p+1)             |
| Question answered | is coordination needed?        | does naive iteration terminate?  |
| Failure mode      | needs a coordination protocol  | diverges                         |

Both directions of independence have witnesses.

**Monotone but not stable.** A plain transitive-closure program over the counting semiring `ℕ`
with `(⊕, ⊗) = (+, ×)` is monotone in CALM's sense — more input facts yield more derivations, and
nothing is retracted — but `ℕ` is not stable: `u^(p) = 1 + u + … + u^p` strictly increases for
`u ≥ 1`, so path-counting on a cyclic graph never reaches a fixpoint. CALM says no coordination is
required; `datalog°` says the computation does not finish. *This is my construction from the two
definitions, not a claim either paper makes.*

**Stable but not monotone.** The Boolean semiring is 0-stable, so every `datalog°` program over it
converges in `N` steps; but a stratified Datalog¬ program over Boolean uses set difference, which
Keeping CALM identifies as "the sole non-monotonic operator", so CALM says it needs coordination.
Termination is fine; coordination-freedom is not.

**Where they do meet, and it is worth saying precisely.** `datalog°` *presupposes* that the rule
function is monotone with respect to `⊑`, since otherwise the least fixpoint need not exist at
all. Inside that setting stability is the **additional** requirement, so **every convergent
`datalog°` program is monotone but not conversely** — within `datalog°`, stability is strictly
stronger. What CALM adds is orthogonal to both: it is about the map from *distributed* inputs to
outputs, which `datalog°` says nothing about.

**The sharper alignment is with Bloom^L, not with CALM.** Keeping CALM's gloss that "monotonic
programs simply accumulate beliefs" is the statement that state lives in a join semilattice and
each step is a join, which is exactly Bloom^L's `⟨S, ⊔, ⊥⟩`. A POPS's `⊕` is a join semilattice
precisely when `⊕` is **idempotent**. Three consequences:

1. **Ergodis's bounded min-plus is a legitimate Bloom^L lattice.** `⊕ = min` is idempotent,
   `⊥ = u32::MAX`, and the induced order `x ⊑ y ⇔ x ⊔ y = y` is the reverse of the numeric order,
   which is exactly `datalog°`'s `Trop₊` convention. The C1151 finding that this algebra is
   0-stable and the Bloom^L framing describe the same object from two sides.
2. **Bloom^L's morphisms are `⊕`-semiring homomorphisms.** `g(⊥_X) = ⊥_Y` and
   `g(a ⊔_X b) = g(a) ⊔_Y g(b)` is the additive half of a Green–Karvounarakis–Tannen semiring
   homomorphism. GKT's Proposition 3.5 requires both halves — `⊕` and `⊗` — for a tagwise map to
   commute with every positive query; Bloom^L needs only the `⊕` half because its state is
   lattice-valued rather than relation-valued with products. So Bloom^L's
   morphism/monotone/non-monotone trichotomy is *coarser* than semiring homomorphism: a
   `⊗`-preserving map is automatically a Bloom^L morphism, not conversely.
3. **`⊗` is where the two frameworks diverge and where Ergodis lives.** Bloom^L has no
   multiplication; its lattices carry only a join. Everything Ergodis wants from min-plus — cost
   accumulation along a path — is `⊗`. Bloom^L is therefore the right vocabulary for Ergodis's
   *merge* semantics and says nothing about its *composition* semantics.

### 5.2 Molly's provenance versus Green–Karvounarakis–Tannen semirings

Molly's lineage **is** GKT provenance specialised to the positive-Boolean semiring and then
negated. The correspondence is exact enough to write down.

The derivation forest gives, for a goal `g`, proof trees `P_1, …, P_k` each with a set of
contributing messages. In GKT terms the provenance of `g` in `PosBool(X)` over message variables
`x_m` is

```
prov(g)   =  ⋁_{i=1..k}  ⋀_{m ∈ P_i}  x_m
```

Molly's CNF is its **negation**, with `¬x_m` realised as concrete fault variables:

```
¬prov(g)  =  ⋀_{i=1..k}  ⋁_{m ∈ P_i}  ( O_(from,to,time)  ∨  C_(node, t ≤ time) )
```

which is the shape of the paper's worked example
`(O_(a,c,2) ∨ C_(a,2) ∨ C_(a,1)) ∧ (O_(b,c,1) ∨ C_(b,1))`. Crash variables are why a single
literal appears in several clauses: a crash of `a` at time `t` falsifies every message `a` sends
at or after `t`, so one fault variable covers many message literals.

Two observations, mine.

**Molly deliberately drops multiplicity, and that is the whole loss.** GKT's universal object is
the polynomial semiring `N[X]`, which records not only *which* inputs contribute but *how many
times and in what combination* — their example `2s² + rs` says the tuple is derived three ways, two
of them using input `s` twice. `PosBool(X)` is the specialisation of `N[X]` that forgets
coefficients and exponents, and GKT's Theorem 4.3 says every semiring's answer factors through
`N[X]`. Molly only ever asks "does some proof survive", so `PosBool` suffices and is cheaper.
Molly's bibliography cites GKT but the paper does not develop the connection.

**Recovering multiplicity is exactly what turns Molly's question into Ergodis's question.** If the
same derivation forest is annotated in a *tupled* semiring — `PosBool × Trop₊`, or `N[X]` itself —
then each proof carries a cost as well as a support set, and "which faults break all proofs"
becomes "which **cheapest** set of faults breaks all proofs". That is one extra component on the
annotation, computed by the same fixpoint, using the semiring-polymorphic machinery C1151 row 4
already proposes.

### 5.3 The Ergodis fit: minimum fault set with an exclusion certificate

This is the closest fit to Ergodis found in any of the recent studies, and the gap is precise.

**What Molly provides.** A satisfying assignment — some fault set that falsifies all known proofs
— and, the valuable half, **UNSAT as a certificate**: "if the resulting SAT problem is
unsatisfiable, then there exists at least one proof that cannot be falsified by any allowable
combination of message losses and crash failures — hence the program is fault-tolerant with
respect to that goal!"

**What Molly does not provide.** Any notion of a *smallest* fault set. §2.4 establishes that
"minimal" in the paper refers to the swept `⟨EOT, EFF, Crashes⟩` parameters, not to the cardinality
or cost of the fault set the solver returns. SAT returns *a* model; nothing asks for a minimum one.

**The exact-optimisation restatement.** Let `F_i` be the set of fault variables that falsify proof
`P_i`. A fault set `X` breaks the outcome iff `X ∩ F_i ≠ ∅` for every `i` — that is, **`X` is a
hitting set of the hypergraph `{F_1, …, F_k}`**, and Molly's CNF is that hypergraph written as
clauses. Therefore:

- **minimum-cardinality fault set** = minimum hitting set, the dual of minimum set cover, NP-hard,
  and exactly the shape of exact search Ergodis is built for;
- **minimum-cost fault set** under per-fault weights (for instance `−log` of a fault probability)
  = minimum-weight hitting set, a **min-plus** optimisation over the same hypergraph, landing in
  the algebra Ergodis has already shown 0-stable;
- **"no smaller set exists"** is an exclusion claim over all candidates of lower cost, which is the
  contract the VeriPB-style `red` certificate from C1151 row 6 is built to discharge — the problem
  is 0–1, the witness substitution is the lift, and the objective condition `f ≥ f↾ω` is the "does
  not worsen the fault count" obligation.

Ergodis's addition to Molly is one sentence: **replace "find a model" with "find a minimum-cost
model, and emit a certificate that no cheaper one exists", over a hypergraph the Datalog fixpoint
already produced.** Both halves of Ergodis's programme — rule input with a convergence bound, and
exact search with exclusion coverage — are exercised by one workload.

**The preconditions Ergodis would inherit, and must declare.** Molly's guarantee is relative to
(i) the supplied inputs and topology, (ii) the `Fspec` bound, and (iii) internal determinism, which
the authors state is what the completeness argument rests on. An Ergodis minimality certificate
inherits all three: it would certify *"no fault set of cost below `c` breaks this invariant, for
these inputs, within this `Fspec`, assuming internal determinism"* — not an absolute statement.
Ergodis's glossary already demands exactly this kind of scoped claim, so this is a fit rather than
a compromise.

### 5.4 Candidate eighth benchmark program

Proposed for `2026-09-12-datalog-benchmark-suites.md` as program 8, alongside the seven there.

**Program: lineage-driven minimum-fault search over `ack-deliv`.** `ack-deliv` is the reliable
broadcast protocol of Molly §3 "in which each agent retries only until it receives an ACK"; its
Dedalus source is printed in Figure 5 and its failure-free lineage in Figure 7. With `redun-deliv`
it is one of only two protocols Molly uses in its coverage study (Figure 11), so it carries the
most published data in that corpus, and it is a handful of rules, which matters for a first port.

| Field       | Value                                                |
|-------------|------------------------------------------------------|
| Semiring    | PosBool for support, min-plus for cost               |
| Recursive   | yes, through the retry rule                          |
| Inputs      | one broadcaster, two receivers, one bcast fact       |
| Fault model | Fspec triple EOT, EFF, Crashes, swept as Molly does  |
| Run locally | yes; both Molly and Ergodis are local prototypes     |

**What Molly reports**, and what a run must reproduce before anything is claimed: at the minimal
`⟨EOT, EFF, Crashes⟩` its sweep reaches, either a counterexample fault set or a bounded guarantee
of absence; the number of possible failure combinations at those parameters; the number of
concrete executions performed; and wall-clock seconds — all against random fault injection
averaged over 25 runs. Molly's Figure 12 carries these per program.

**What Ergodis would add**, and the three numbers that make the row worth running:

1. **Agreement.** Does Ergodis find a fault set Molly's solver also admits? Reproducing Molly's
   answer is the gate before any improvement is claimed.
2. **Minimality.** The cardinality — and with fault weights, the cost — of Ergodis's minimum fault
   set against the first model Molly's solver returns. If they coincide on this protocol the row
   still earns its place by producing the *certificate*; if they differ, the difference is the
   result.
3. **Certificate cost.** Independent-check time as a fraction of search time. This is the number
   Ergodis's positioning rests on and nothing in the Datalog benchmark literature measures it.

For the certificate half the demo needs **one protocol from each of Molly's two classes** — a
buggy one, where the answer is a minimum fault set, and a bug-free one, where the answer is the
exclusion certificate ("7 critical bugs in 14 fault-tolerant systems; for the remaining 7 systems,
it provides a guarantee that no invariant violations exist up to a bounded execution depth"). I
could **not** determine from the PDF which of `ack-deliv` and `redun-deliv` falls in which class,
because Figure 12's cells extract with scrambled columns; that must be settled by reading the
figure directly before the pair is fixed.

**Published Molly numbers to cite, and their caveats.**

- **"7 critical bugs in 14 fault-tolerant systems"**, with a bounded absence guarantee for the
  other 7. *Caveat:* "14 systems" counts protocol variants, several of which are five-line
  delivery protocols; it is a corpus-size statement, not a difficulty statement.
- **"in many cases using an order of magnitude fewer executions than random fault injection"**.
  *Caveat:* the baseline is random fault injection averaged over 25 runs, weak by construction,
  and the claim is hedged with "in many cases".
- **Figure 12's per-program minimal `Fspec`, combination counts, execution counts and wall-clock
  seconds.** *Caveat, disqualifying until fixed:* **I could not transcribe these cells** — the
  multi-column extraction scrambles them, and the only value I could read cleanly was an
  unattributable 0.12–9.60 second range. Anyone citing Figure 12 must read the figure directly.
- **No hardware is stated anywhere I read**, and no SAT solver or Datalog evaluator is named beyond
  "off-the-shelf components". Every timing in the paper is therefore uncomparable to a modern run,
  and the row should be positioned as *capability* — minimum plus certificate versus any model —
  not as speed.

## 6. Three questions for Macready

Each is grounded in something a source above actually defines.

1. **Which half of Alvaro's line is the relevant one — the lattice condition or the provenance
   loop?** They are separate results with separate uses. CALM plus Bloom^L give a *lattice*
   condition on program state (`⟨S, ⊔, ⊥⟩` with a monotone/morphism/non-monotone classification of
   methods) that decides whether coordination is needed; §5.1 shows this is the `⊕`-half of a POPS
   and is orthogonal to `datalog°` stability. Molly gives a *provenance-to-SAT* loop that turns
   proof trees into a fault hypergraph. If the interest is the first, the connection to tensor
   logic is about which merge operators a distributed einsum may use without coordinating. If it
   is the second, the connection is to certificates and exact search. **Which?**

2. **Is Hydroflow a comparison point, a candidate backend, or a competitor for the same slot?**
   Chu et al. compile Dedalus to **Hydroflow, a Rust dataflow runtime**, and apply rule-driven
   rewrites — decoupling and partitioning — under correctness preconditions derived from
   order-insensitivity and data-dependency analysis, reporting 2×, 5× and 3× throughput on voting,
   2PC and Paxos. That is structurally the pipeline Macready describes: a declarative rule syntax,
   a compiler applying rewrites under a correctness precondition, a Rust runtime. **Does his
   categorical IR target something like Hydroflow, replace it, or sit above it?**

3. **Does the categorical IR aim to subsume both rewrite disciplines, and does it discharge the
   precondition by construction?** There are now two published rule-driven rewrite lines with
   correctness preconditions: the **FGH-rule** (`G(F(X)) = H(G(X))`, semiring-algebraic,
   discharged by counterexample-guided synthesis with z3) and **Chu et al.'s** spatiotemporal
   rewrites (discharged by order-insensitivity and dependency analysis, and applied **manually** —
   their automated optimiser is explicitly future work). Both are commuting-square conditions over
   different structures. **Is the IR meant to cover both, and if so does it establish the square by
   construction rather than by verification?** If by construction, that is strictly better than
   either and is the first thing worth hearing about.

## 7. Coverage and search record

### Read-depth tally

**Nine named sources.** Six at **partial**, one of those (Molly) at algorithm depth with §§4.1.2,
4.2 and 4.3 read in their entirety: Molly, Keeping CALM, Bloom^L, Dedalus, Chu et al., LogicBlox.
Three at **secondary only**, characterised from Chu et al.'s bibliography and not read: Bloom
(CIDR 2011), Blazes (TODS 2017), Edelweiss (2014). Two further sources — `datalog°` and
Green–Karvounarakis–Tannen — are reused at the depths recorded in
`2026-09-12-relationalai-datalog-reading.md` and were not re-read. **Nothing was read at full
text**, and the two things this report most depends on — Molly's soundness and completeness proofs
in its appendix, and Figure 12's cells — were **not** read; both are flagged where they matter.

### Identifier resolution

Resolved from the arXiv abstract page before fetching: `1901.01930` (Keeping CALM, v2, with the
CACM 63(9) reference), `2404.01593` (Chu et al., v2, recorded there as SIGMOD 2024). Resolved from
venue records via search: Molly (SIGMOD 2015, DOI 10.1145/2723372.2723711, via ACM DL and dblp),
Bloom^L (SoCC 2012, DOI 10.1145/2391229.2391230, via dblp and ACM), Keeping CALM's CACM DOI
10.1145/3369736, and the LogicBlox SIGMOD 2015 paper. Dedalus's report number UCB/EECS-2009-173
comes from the PDF's own title block; the 2011 *Datalog Reloaded* citation comes verbatim from Chu
et al.'s reference [7]. **No identifier was written from memory.**

### Cache additions

New keys: `alvaro-2015-lineage-driven-fault-injection`, `arXiv:1901.01930`,
`conway-2012-logic-and-lattices`, `alvaro-dedalus-datalog-in-time-and-space`, `arXiv:2404.01593`,
`aref-2015-logicblox-sigmod`. SHA-256 values are quoted in each entry. Fetches went through
`/tmp/persistent/tavis/lit-search/fetch_c1151b.sh`, which rejects any download whose magic bytes
are not `%PDF` — it rejected one attempt at `people.ucsc.edu/~palvaro/dedalus.pdf`, which returned
HTML, and the Berkeley technical report was used instead.

### Load-bearing queries, verbatim

1. `"Keeping CALM" "When Distributed Consistency is Easy" Hellerstein Alvaro arXiv CACM identifier`
2. `Alvaro Rosen Hellerstein "Lineage-driven Fault Injection" Molly SIGMOD 2015 provenance SAT`
3. `"Logic and Lattices for Distributed Programming" Conway Marczak Alvaro Hellerstein Maier SoCC
   2012 Bloom^L`
4. `Peter Alvaro 2024 2025 2026 publications UCSC Datalog BFT scaling protocol rewriting recent` —
   **found no Alvaro work on protocol rewriting or BFT scaling.** Surfaced venues (SoCC 2025,
   DBPL 2025, HotOS 2025, and a CIDR 2025 paper "Deterministic Record-and-Replay") and three BFT
   papers (Clownfish, Beluga, Prefix Consensus) I did **not** verify as his and do not attribute.
   Recorded as searched-and-found-nothing over web search only — a weak negative.
5. `LogicBlox LogiQL Molham Aref RelationalAI founded lineage history Datalog company`

### Not covered

- **Molly's appendix** (Section B), containing the soundness and completeness proofs, was not
  read. Every claim here about what LDFI *proves* is quoted from the body.
- **Molly's Figures 11 and 12** could not be transcribed; see §5.4.
- **Bloom (CIDR 2011), Blazes (TODS 2017) and Edelweiss (2014) were not read** — only their
  bibliographic entries in Chu et al.
- **The Dedalus version I read is the 2009 Berkeley technical report**, not the 2011 published
  chapter; I did not compare them, so any statement here may not hold of the published version.
- **Chu et al.'s rewrite rules and correctness arguments (§§3–4, Appendices A–B) were not read** —
  only the framing, setup and results.
- **No primary corporate record** was consulted for the LogicBlox-to-RelationalAI claim; it rests
  on the RelationalAI resources page and a published interview surfaced by search, both at
  abstract/metadata depth.
- **No relation between Alvaro or Hellerstein and RelationalAI was established** beyond LogicBlox's
  citation of Bloom (§4).
- **Hydroflow itself was not read** — no Hydroflow paper or repository was consulted, only Chu et
  al.'s description of it as "a Rust dataflow runtime for distributed systems".
- **zbMATH Open, OpenAlex, Crossref and Semantic Scholar were not queried.** MathSciNet: NOT
  COVERED (institutional authentication). Google Scholar: NOT COVERED (blocks automated access).
- **Nothing was run.** No protocol was ported, no engine installed.
