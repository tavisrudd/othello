# Peter Alvaro's Datalog line — a reading study

**Date:** 2026-09-12. **Lane:** `ergodis`. **Disposition:** bounded reading and positioning study.
No code written; nothing under `~/src/ergodis*` edited.

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
of Chu et al. (arXiv:2404.01593), at the depth recorded in §3. Likewise **Blazes** (Alvaro,
Conway, Hellerstein, Maier, ACM TODS 42(4), Article 23, October 2017, 31 pages, DOI
10.1145/3110214) and **Edelweiss** (Conway, Alvaro, Andrews, Hellerstein, 2014), both from the
same bibliography and both unread.

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
