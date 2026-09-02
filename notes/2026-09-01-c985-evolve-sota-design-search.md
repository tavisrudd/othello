# C985 — SOTA landscape for Ergodis `evolve`: combinatorial design search, exact code distance, learned pruning

status: complete

Date: 2026-09-01. Scope: literature + GitHub survey to locate where Ergodis'
exact quotient compilation plus evolved necessary conditions could beat or
complement incumbent tooling. Not a novelty verdict; no priority negatives are
asserted here.

## A.1 SAT+CAS and algebraic filtering for combinatorial designs

**The frontier moved in August 2026, and this is the single most important
fact for the order-2092 campaign.** On 2026-08-12 Levent Alpöge, Saul
Reynolds-Haertle and Philippe Voinov announced constructions — obtained with
Claude assistance — for all twelve orders below 2000 that had been open:
668, 716, 892, 1132, 1244, 1388, 1436, 1676, 1772, 1916, 1948, 1964. Every
positive multiple of 4 below 2000 now has an explicit Hadamard matrix. The
announcement was made on X as 23,828 signs plus a decoder script rather than
as a paper; Epoch AI's FrontierMath open-problem page for order 668 now lists
it as "Solved (AI)". Order 668 had been the smallest open case for 21 years
(since Kharaghani–Tayfeh-Rezaie settled 428 in 2004).

Consequences for Ergodis:
- 668/716/892 are no longer targets. Any framing of the private campaign that
  cites "the smallest open Hadamard order" needs rewriting.
- 2092 = 4 x 523 sits above the newly cleared band, so it is still a live open
  order — but the credible claim is now "an order above 2000", not "a famous
  smallest open case", and one must first check whether the Alpöge et al.
  method (whatever it turns out to be, once documented) extends upward cheaply.
  If it does, an exhaustive Goethals–Seidel exclusion at 2092 is worth more as
  a *non-existence within a construction class* result than as an existence
  race.
- The Cati–Pasechnik database (arXiv:2411.18897, SageMath `hadamard_matrix`
  implementations, CC-BY-SA, tables to order 2999 for Hadamard and 999 for
  skew) is the natural place to check which orders above 2000 remain without a
  construction, and the natural place to contribute one. It also records
  the negative that Paley constructions fail for 2^m * 509203 for all m.

### Incumbent pruning techniques (what evolve is competing with)

The Bright–Kotsireas–Ganesh SAT+CAS line (MathCheck, MathCheck2) is the direct
precedent for "search engine plus algebraic knowledge". Its published
mechanism is a *programmatic* SAT solver: the CDCL solver calls out to a
computer-algebra routine during search, and the routine returns a clause
(a learned nogood) explaining why the current partial assignment is
infeasible. Applied to the Williamson conjecture (Bright–Kotsireas–Ganesh,
J. Symbolic Computation 2020) this enumerated Williamson matrices in all even
orders up to 64, extending Bright's 2017 enumeration to 44.

The algebraic filters actually used across this literature are:
- **Power spectral density (PSD) test.** The DFT magnitudes of candidate
  sequences must sum to a fixed constant, so any partial candidate whose
  partial PSD already exceeds the budget is dead. This is the workhorse
  filter for Legendre pairs, D-optimal designs, and difference families.
- **Compression (Ðoković–Kotsireas, arXiv:1302.0571).** The m-compression of a
  periodic complementary collection is again complementary. This maps a
  length-mn problem onto a length-n problem whose solutions are the images of
  the real ones, giving an exact, sound reduction — structurally the same move
  as Ergodis' quotient-PAF equations modulo small orders.
- **Multiplier / symmetry assumptions.** Searches are routinely run *under an
  assumed nontrivial subgroup of the multiplier group*, exactly as the
  private campaign assumes g = 41, 53, 91, 133.
- **Galois/cyclotomic conditions.** Kotsireas–Koutschan's Legendre-pair work
  (lengths ell = 0 mod 3, mod 5) explicitly derives conditions from Galois
  theory of cyclotomic fields *to strengthen the PSD test*, plus a
  even/odd-index splitting of the search. This is the closest published thing
  to Ergodis' fixed-field norm/Diophantine reductions.
- **Symmetry breaking and isomorph rejection**, usually hand-written or via
  canonical forms (see A.4).

### Where the incumbent stops

In every case above the necessary conditions are **derived by a human
mathematician and then hard-coded** into the search or into a CAS callback.
None of the SAT+CAS papers report a system that *searches a space of candidate
predicates* against a labelled corpus and emits the sound ones. Programmatic
SAT learns clauses, but the clause generator is a fixed hand-written routine;
CDCL nogood learning is instance-local and lexical, not a reusable theorem.
That gap — automatic synthesis of a reusable, provably sound necessary
condition — is the part of Ergodis `evolve` with no direct counterpart found
here.

### Legendre pairs: current status

Kotsireas–Koutschan reduced the count of unresolved lengths <= 200 from 12 to
10 by settling 85 and 87 (assuming balance for 87 and a nontrivial multiplier
subgroup for 85). For *quaternary* Legendre pairs, Jedwab–Pender's prime-power
construction covers 36 and 40, moving the smallest unresolved quaternary case
upward. Exact current open lists need a direct read of the 2025-2026 papers
(see read-depth table); the number to quote is "10 open lengths at most 200"
for the classical case.

## A.2 Exact minimum distance of quantum LDPC / bivariate bicycle codes

Two 2026 papers define this frontier, and both matter to Ergodis.

**QDistSAT** (Yu-Fang Chen, Seyed Mohammad Reza Jafari, Ching-Yi Lai,
arXiv:2606.12445v1, 2026-05-29; repo https://github.com/guluchen/QDistSAT).
A large-scale empirical study of SAT, MaxSAT and SMT encodings for exact QLDPC
distance, benchmarked against mixed-integer programming, Brouwer–Zimmermann
enumeration, and connected-cluster methods. 27 instances across three families:
bivariate/generalized bicycle codes (72–360 qubits), lifted product codes
(34–1768 qubits), quantum Tanner codes (36–250 qubits). Solvers covered are
Minisat, Glucose, CaDiCaL, Lingeling, MapleSAT, MergeSat, CryptoMiniSat,
MiniCard, Gluecard, Z3, CVC5, Open-WBO, EvalMaxSAT, CASHWMaxSAT, RC2,
MaxCDCL, DistQLDPC, Gurobi, SCIP, Magma.

Headline results with direct bearing on the Ergodis CSS distance kernel:
- **Branch-and-bound MaxSAT beats unsat-core-guided MaxSAT** decisively. The
  incumbent best exact method for this problem class is therefore a
  branch-and-bound optimizer with a good lower-bound function, not a CDCL
  refutation engine.
- **Native XOR reasoning (CryptoMiniSat) gives only limited advantage** despite
  the parity structure. Encoding the GF(2) structure inside a SAT solver is
  not where the leverage is; algebraic structure exploited *outside* the
  solver is the open lane.
- **Classical distance techniques (Brouwer–Zimmermann in Magma) underperform**
  on QLDPC benchmarks relative to optimization-based solvers.
- **Open entries:** several instances time out at 2 hours, explicitly
  including the BB codes at n=288 with k=12, n=360 with k=12, and
  GB_144_12_12, plus larger lifted-product and Tanner instances. Ergodis
  already has a certified [[360,12,24]] (BB360) exact distance — that is
  precisely one of the families QDistSAT lists as unsolved at a 2 h budget,
  so a like-for-like timing comparison against their harness is the single
  cheapest publishable validation available.

**Evolutionary discovery of BB codes with LLM-guided search** (Juan
Cruz-Benito, Andrew W. Cross, David Kremer, Ismael Faro; IBM Research;
arXiv:2606.02418v1, 2026-06-01). MAP-Elites evolutionary search over *Python
generator ansätze* (programs emitting polynomial pairs (A,B) or 4-tuples for
non-CSS perturbed BB codes), with LLM mutation operators via OpenEvolve, a
three-stage fitness (dimension k, then BP-OSD distance bounds, then exact MILP
distance via HiGHS), BLISS Tanner-graph deduplication. 465 new codes,
including a CSS [[288,16,12]], a weight-8 CSS [[288,50,8]], and a non-CSS
[[144,12,12]] matching the gross code. They quantify BP-OSD *over*estimation
of distance up to 12x for high-rate codes, and prove all A=B codes have d=2.

**This is the nearest precedent to Ergodis `evolve`, and it must be cited as
one.** It is evolutionary search driving an exact combinatorial backend. The
distinction to defend: IBM evolves *constructions* (candidate objects and the
programs that generate them), scored by an exact verifier used as an oracle.
Ergodis evolves *necessary conditions* — predicates that are then proved sound
and used to delete regions of an exhaustive search. IBM's loop cannot prove
non-existence; Ergodis' can. The two are complementary rather than competing,
and the "evolve a generator ansatz, verify exactly" pattern is itself a cheap
capability Ergodis could add.

**qdistrnd** (Leonid Pryadko et al.) is the GAP package giving *probabilistic
upper bounds* on distance; it is what most BB-code tables in the literature
actually report, and it is unsound as a lower bound. The Bravyi et al. IBM BB
tables and the follow-on multivariate-bicycle tables inherit that: entries are
estimates unless separately certified. That is the systematic opening —
converting estimated table entries into certified ones is a well-defined,
enumerable body of work, and the error-correction zoo page for BB codes
(errorcorrectionzoo.org/c/qcga) is the index of candidates.

## A.3 Best-known linear codes, and the adjacent design tables

**codetables.de** (Markus Grassl) remains the single reference table for bounds
on linear-code parameters over small fields, and every new-code paper is scored
against it. The methodology that actually produces updates is narrow and
stable: search inside a *structured* subfamily where the automorphism group
collapses the space to something enumerable — quasi-cyclic (QC), quasi-twisted
(QT), constacyclic and multi-twisted codes — then compute the true minimum
distance of the survivors with Magma's Brouwer–Zimmermann implementation.
Eric Z. Chen maintains a separate online database of quasi-twisted codes and
is a recurring source of record entries; recent activity continues into
2026 (index-2 QT codes yielding record ternary quantum stabilizer codes, and
hierarchical QC codes from Reed–Solomon and polynomial-evaluation codes,
arXiv:2512.23872, benchmarked directly against codetables.de).

The structural point for Ergodis: the incumbent workflow is *human picks an
algebraic family, machine enumerates it, Magma certifies distance*. The
algebraic family is the pruning theorem, chosen by hand. Ergodis' Gray /
Brouwer–Zimmermann kernel already covers the certification step; what would
distinguish it is having `evolve` propose the family-defining invariant rather
than receiving it.

Adjacent open tables with the same shape, worth listing as targets because
they are small, exactly specified, and maintained:
- **Circulant weighing matrices** CW(n,k): the standard table (Strassler's
  table as extended by Arasu, Ðoković and others) still has open entries; the
  proof technique is exactly multiplier/character-sum arguments over cyclotomic
  fields, which is the same algebra Ergodis' fixed-field norm reductions speak.
- **D-optimal designs**: Ðoković–Kotsireas settled orders 118, 138, 150, 154,
  174 (arXiv:1408.6116) using PSD plus compression; the tables above those
  orders remain sparse.
- **Periodic Golay pairs** and supplementary difference sets: the same
  compression/PSD toolkit, with recent (2025-2026) results on periodic Golay
  pairs.

These three are the best fit for the existing carrier-522 machinery, because
they are all cyclic/multiplier problems with exactly the PAF-modulo-small-order
structure the campaign already compiles.

## A.4 Automatic discovery of pruning conditions elsewhere

Four distinct traditions, none of which does quite what `evolve` does:

1. **Nogood learning / lazy clause generation.** Chuffed
   (https://github.com/chuffed/chuffed) is the reference lazy-clause-generation
   solver; OR-Tools CP-SAT is the industrial one. Propagators explain their
   domain changes, conflict analysis derives nogoods, and those nogoods are
   propagated by unit propagation. There is published work on combining LCG
   with symmetry breaking, where the more precise nogoods exploit redundancies
   plain symmetry breaking cannot. Crucially: nogoods are *instance-local and
   lexical*. They are not reusable across instances, carry no algebraic
   meaning, and are discarded with the solve. Ergodis `evolve` produces the
   opposite kind of object — an instance-independent, algebraically stated,
   reusable condition.

2. **Learned branching / "learning to prune".** The Gasse et al. line
   (graph-convolutional imitation of strong branching for MILP) and its
   successors learn *heuristics*, and are explicitly unsound as pruning: they
   reorder search, they never delete feasible regions. Anything from this
   tradition is complementary to Ergodis, never a substitute, and cannot
   support a non-existence claim.

3. **Constraint acquisition.** Conacq.1/Conacq.2 (Bessiere et al., LIRMM),
   ModelSeeker (global constraints over a matrix of variables), Arnold, SeqAcq,
   plus active learning through partial queries (Bessiere et al., AIJ 2023) and
   a 2026 JAIR paper on active constraint acquisition using large language
   models. This is the closest tradition in *spirit*: learn a constraint model
   from positive and negative examples drawn from a bias (a bounded language of
   candidate constraints). The differences that matter: constraint acquisition
   targets a model that reproduces the user's solution set, is evaluated by
   classification accuracy, and offers no soundness proof for use as a pruning
   theorem in an exhaustive search; and its biases are generic constraint
   languages, not algebra over cyclotomic fixed fields. A serious framing of
   `evolve` should position it as constraint acquisition specialized to sound
   necessary conditions with a proof obligation attached — and should cite
   Conacq and ModelSeeker as prior art for the learning half.

4. **Isomorph-free exhaustive generation.** Orderly generation and canonical
   augmentation (Read, Faradžev, McKay), realized in nauty/Traces, GENREG and
   friends: prune the tree by requiring every intermediate object to be the
   canonical representative of its isomorphism class. This is the sound
   pruning tradition, and it is *hand-instantiated per problem*. The 2026 work
   on orderly generation of Kochen–Specker sets (arXiv:2604.19947) couples a
   SAT solver to a nauty-based orderly generator, which is the current template
   for "exact search plus canonical pruning" and a natural comparison point.

Also worth noting from the symbolic-regression side: exhaustive/enumerative SR
now uses canonical-form deduplication of expression DAGs (e.g. IsalSR,
arXiv:2603.21836) — a complete labelled-DAG isomorphism invariant that
collapses isomorphic expressions. If `evolve` searches a predicate space, that
is the right way to avoid re-evaluating equivalent predicates, and it is an
off-the-shelf idea.

## B. GitHub landscape

### B.1 Exact search for designs and codes

| Repo / resource | What it is | Language | Activity / license |
|---|---|---|---|
| https://github.com/guluchen/QDistSAT | Exact QLDPC distance via SAT/MaxSAT/SMT; the benchmark harness and instance list for A.2 | Python driver over C/C++ solvers | 2026 (paper May 2026); arXiv license stated in paper, check repo LICENSE |
| https://github.com/BrianLi009/MathCheck | SAT+CAS+nauty cube-and-conquer pipeline for Kochen–Specker graph generation and verification; MapleSAT-ks and CaDiCaL-ks with orderly generation built into the solver | Python, shell, C++ | active, ~558 commits on main; LICENSE file present |
| https://uwaterloo.ca/mathcheck | The MathCheck project proper (Bright, Ganesh, Kotsireas et al.; Waterloo, Windsor, Carleton, Laurier, Georgia Tech). Free software; the Williamson and 8-Williamson enumerations are published as data on the site rather than as a single GitHub repo | C++/Python | ongoing |
| https://github.com/OxiDD/oxidd | Concurrent, modular decision-diagram framework — BDD, BCDD, and **ZDD/ZBDD** — with C/C++ and Python bindings; TACAS'24 paper (Husung, Dubslaff, Hermanns, Köhl) | Rust | updated July 2026; MIT or Apache-2.0 |
| https://github.com/chuffed/chuffed | The reference lazy-clause-generation constraint solver | C++ | active; MIT |
| Google OR-Tools CP-SAT | The industrial nogood-learning CP solver | C++ | active; Apache-2.0 |
| QDistRnd (Pryadko et al.) | GAP package, probabilistic distance *upper* bounds; the source of most published BB-code distance entries | GAP | maintained; GPL |
| SageMath `hadamard_matrix` / Cati–Pasechnik database (arXiv:2411.18897) | Catalogued Hadamard and skew-Hadamard constructions, tables to order 2999 / 999 | Python (Sage) | CC-BY-SA 4.0 |
| https://codetables.de (Grassl) | Best-known linear code bounds; not a repo, but the scoring table | — | web resource |
| errorcorrectionzoo.org/c/qcga | Index of BB-code parameter claims with provenance | web | active |

### B.2 Does anything combine an evolutionary/symbolic predicate learner with an exact combinatorial backend?

The closest found, and it must be treated as a precedent rather than a
distant cousin, is **IBM's evolutionary BB-code discovery** (arXiv:2606.02418,
OpenEvolve + MAP-Elites + LLM mutation, with MILP/HiGHS as the exact
verifier). It is evolution *plus* an exact combinatorial backend. What it
evolves is generator programs for candidate objects; the exact backend is used
as a scoring oracle. It does not evolve necessary conditions and cannot
produce a non-existence result.

Nothing was found that evolves *sound necessary conditions* and feeds them
back as pruning into an exhaustive search. That is a negative from a bounded
search (the queries in the source table below), not a novelty claim — the
constraint-acquisition literature (Conacq, ModelSeeker) is close enough in
spirit that any write-up must position against it explicitly, and OpenEvolve /
FunSearch-style program evolution is close enough in mechanism that the
combination may exist under a name these queries did not hit.

### B.3 Rust crates Ergodis could depend on or compete with

- **rustsat** (https://github.com/chrjabs/rustsat) — the serious one. Unified
  Rust interfaces plus CNF/encoding utilities, with backends for CaDiCaL,
  Kissat, Glucose, MiniSat. If Ergodis ever wants a SAT fallback or a
  cross-check against QDistSAT's encodings, this is the dependency, not a
  hand-rolled solver.
- **splr** (crates.io/crates/splr, v0.17.x) — pure-Rust CDCL. Convenient, no
  C toolchain, but not competitive with CaDiCaL/Kissat on hard instances.
- **varisat** — pure-Rust CDCL with proof output; largely dormant.
- **sat-solvers** — a crate bundling CaDiCaL, MiniSat, Glucose, Lingeling,
  Kissat compiled from source behind one interface.
- **oxidd** — the ZDD/BDD dependency to prefer over a bespoke ZDD, unless the
  Ergodis ZDD kernel is already measurably faster on its own workloads (it may
  well be; the concurrency model in OxiDD costs something on single-threaded
  enumeration).
- Finite fields / coding theory in Rust is thin. There is no Rust equivalent of
  Magma's Brouwer–Zimmermann or of GAP's GUAVA. `ark-ff` (arkworks) is the
  best-maintained finite-field arithmetic but is prime-field and
  pairing-oriented, not GF(2^m) enumeration-oriented. **This is a real gap and
  an opportunity: a Rust crate exposing certified minimum-distance computation
  (Brouwer–Zimmermann for classical, and the CSS/QLDPC variant) would have no
  incumbent.**
- `newca12/awesome-rust-formalized-reasoning` is the useful index for anything
  else in this space.

## Where to take evolve

Ranked by expected value. Sizes are calibrated against "a native BP+OSD lands
in under an hour": **S** = a session, **M** = a few days, **L** = a campaign.

**1. Close the open QDistSAT instances. (S)**
*Open entry:* arXiv:2606.12445 reports 2-hour timeouts on BB codes at n=288
k=12, n=360 k=12, and GB_144_12_12, plus larger lifted-product and Tanner
instances. *Edge:* Ergodis already has a certified exact [[360,12,24]]. That
is an instance the current published best exact toolchain does not finish.
The paper also shows classical Brouwer–Zimmermann and XOR-aware SAT both
underperform, so the win is attributable to structure exploited outside a
solver — which is exactly Ergodis' story. *Missing capability:* nothing
mathematical; only harness parity (read their instance files, match their
timing protocol, emit their result format) and a certificate a third party can
check. *This is the highest-EV move in the whole survey: a published,
reproducible benchmark table with an incumbent that just declared these
instances intractable.*

**2. Certify the estimated entries in the BB / multivariate-bicycle tables. (S–M)**
*Open entry:* most published BB-code distances come from QDistRnd, which gives
probabilistic upper bounds only; IBM measured BP-OSD *over*estimating distance
by up to 12x for high-rate codes. Whole table columns are therefore unverified.
*Edge:* exact CSS distance at scale, already built. *Missing:* a batch driver
over the error-correction-zoo / Bravyi-table parameter lists, plus a compact
certificate format with replay hashes. *Deliverable:* "certified distances for
the published bivariate-bicycle tables", which is a citable service paper and
costs almost no new mathematics.

**3. Put the exact distance kernel *inside* an evolutionary generator loop. (M)**
*Open entry:* IBM's three-stage pipeline uses BP-OSD as the cheap in-loop
score and MILP exact distance only as a late verification stage, precisely
because exact distance was too slow to sit in the loop — and they document
that the cheap score misleads by up to 12x. *Edge:* if Ergodis' exact kernel
is fast enough to be the fitness function directly, the whole MAP-Elites
landscape is scored on truth rather than on a biased estimate, and the
distance traps IBM had to discover analytically (all A=B codes have d=2) are
never entered. *Missing:* an evolutionary outer loop over generator ansätze,
and Tanner-graph canonical dedup (BLISS or nauty). *Precedent to cite:*
arXiv:2606.02418 — this is deliberately the same design with a better inner
oracle, not a novel one.

**4. Reframe the order-2092 campaign as non-existence within the
Goethals–Seidel class. (M, mostly framing)**
*Open entry:* every order below 2000 was settled in August 2026 by Alpöge,
Reynolds-Haertle and Voinov with Claude. An existence race at 2092 now looks
like a slow lane on a road that just got a fast one. *Edge:* their result is a
construction; it says nothing about which construction classes are empty. An
exhaustive, certified "no bordered Goethals–Seidel array with four circulant
blocks of carrier 522 and multiplier subgroup g exists" is a structural result
that no LLM-assisted construction search produces, and it is exactly what the
fourteen exact reductions already support. *Missing:* the sealed registered
extractor and the `PlanRole::Necessary` soundness path the C1016 report
already identifies as the blocker. That gate is the real work, and it is the
same gate for every item below.

**5. Legendre pairs: automate the condition that Kotsireas–Koutschan derived
by hand. (M)**
*Open entry:* 10 unresolved lengths at most 200. *Edge:* their advance came
from deriving cyclotomic-Galois conditions that strengthen the PSD test, plus
an even/odd index split, plus an assumed multiplier subgroup — all three are
things Ergodis' quotient compiler expresses natively, and the first is exactly
a "necessary condition" of the shape `evolve` searches for. A head-to-head on
a *solved* length (85 or 87) that rediscovers their condition automatically is
the cleanest possible demonstration that `evolve` finds real theorems, and it
is falsifiable in a day. *Missing:* a Legendre-pair corpus and PSD feature
extractor; the algebra layer already exists.

**6. Circulant weighing matrices CW(n,k). (M)**
*Open entry:* Strassler-style tables still carry open cells. *Edge:* the
standard proof technique is multiplier and character-sum arguments over
cyclotomic fields — the same fixed-field norm/Diophantine machinery the
campaign already produces (e.g. the 13 n27 + 15 n29 = 34 style equations).
Small parameters mean a full exhaustive closure is realistic. *Missing:* the
CW problem encoding; reductions transfer.

**7. D-optimal designs and periodic Golay pairs above the settled orders. (M)**
*Open entry:* Ðoković–Kotsireas settled D-optimal orders 118, 138, 150, 154,
174 with PSD plus compression; higher orders are sparse, and periodic Golay
pairs saw new 2025-2026 results. *Edge:* identical PAF-modulo-small-order
structure to the current carrier-522 work, so this is reuse rather than new
mathematics. *Missing:* problem encodings only. Lower EV than 5 and 6 only
because the tables are less watched.

**8. A Rust crate for certified minimum distance. (S–M)**
*Open entry:* there is no Rust Brouwer–Zimmermann. Magma is commercial, GUAVA
is GAP, and QDistSAT is a research harness. *Edge:* Ergodis already contains
the kernel; extracting it is packaging, and it makes every result above
independently replayable by someone who does not have a Magma licence.
*Missing:* API design and a stable certificate format. This is the cheapest
way to acquire external users, and external users are what make a
necessary-condition engine credible.

**9. Position and publish `evolve` against constraint acquisition. (M)**
*Open entry:* none — this is a framing and evaluation task. *Edge/risk:*
Conacq, ModelSeeker and the 2026 LLM-driven active-acquisition work already
learn constraints from labelled examples. The distinguishing claim must be
*soundness with a proof obligation and reuse as a search-deleting theorem*,
not "we learn constraints". *Missing:* the sealed extractor from item 4, plus
an evaluation protocol that measures reduction in certified search volume
rather than predicate accuracy. Do this before, not after, any external
write-up, or a reviewer will make the Conacq comparison first.

**10. Couple evolved conditions to canonical-augmentation generation. (L)**
*Open entry:* the 2026 SAT + nauty orderly-generation work on Kochen–Specker
sets (arXiv:2604.19947) is the current template for exact search with sound
canonical pruning, and BrianLi009/MathCheck is its running code. *Edge:*
orderly generation prunes by isomorphism only; adding evolved algebraic
necessary conditions prunes by arithmetic as well, and the two are
independent. *Missing:* a canonical-augmentation frontend and an isomorphism
layer Ergodis does not currently have. Genuinely large; listed because it is
where the two sound-pruning traditions meet.

### Precedents that already do part of what evolve does

State these up front in any write-up rather than being told them:
- **Programmatic SAT / MathCheck** — search engine calling out to algebra
  mid-solve to generate sound pruning clauses. Same architecture; the clause
  generator is hand-written, not learned.
- **IBM's LLM-guided evolutionary BB-code discovery** — evolutionary search
  over generator programs with an exact combinatorial verifier in the loop.
  Same loop shape; evolves objects, not conditions.
- **Ðoković–Kotsireas compression** — a sound quotient reduction of a periodic
  complementary-sequence problem to a shorter one. Same move as quotient-PAF;
  derived by hand once, per family.
- **Conacq / ModelSeeker** — learning constraints from labelled positive and
  negative examples over a bounded bias language. Same learning problem
  without the soundness obligation.

### Vibe check

The Hadamard existence frontier below 2000 closed three weeks ago, so the
campaign's headline needs to change from an existence race to a
class-exclusion result. The compensating find is better than the loss: the
2026 QLDPC-distance literature has just published a list of instances it
cannot finish, and Ergodis has already finished one of them.

## Sources and read depth

No item below was retrieved from the shared lit-search cache: a `list` of
`/tmp/persistent/tavis/lit-search/` showed no keys for any of the SAT+CAS,
Legendre-pair, Hadamard-table, or QLDPC-distance papers consulted here, so
every source was fetched live. No cache keys or SHA-256 values can therefore
be cited for these; anything that becomes load-bearing for a manuscript claim
should be ingested with `litcache.py add` first and re-read from the blob.

| Source | Read depth |
|---|---|
| arXiv:2606.12445 (Chen, Jafari, Lai — SAT/MaxSAT/SMT for QLDPC distance; QDistSAT) via https://arxiv.org/html/2606.12445 | full-text fetch, targeted extraction (authors, encodings, families, solvers, timeouts, repo) |
| arXiv:2606.02418 (Cruz-Benito, Cross, Kremer, Faro, IBM — evolutionary discovery of BB codes with LLM-guided search) via https://arxiv.org/html/2606.02418 | full-text fetch, targeted extraction (method, fitness stages, results, BP-OSD overestimation) |
| arXiv:2411.18897 (Cati, Pasechnik — database of constructions of Hadamard matrices) via abstract page | abstract-level fetch |
| https://epoch.ai/frontiermath/open-problems/hadamard | page fetch; confirms order 668 status "Solved (AI)", Claude-assisted, three-human team; did not itself confirm 716/892 |
| Search-result synthesis on the Alpöge / Reynolds-Haertle / Voinov announcement (2026-08-12; X post by the author, coverage at johndcook.com 2026-08-13, Sumeet Motwani X post, aliteq.com summary) | search snippets only — **not** read at source. The twelve-order list (668, 716, 892, 1132, 1244, 1388, 1436, 1676, 1772, 1916, 1948, 1964) should be verified against the primary announcement before being used in a manuscript |
| Bright, Kotsireas, Ganesh — "Applying computer algebra systems with SAT solvers to the Williamson conjecture", J. Symbolic Comput. 2020; preprint at https://cs.uwaterloo.ca/~cbright/reports/jsc-willsat.pdf | search snippets and abstract level |
| Bright, Kotsireas, Ganesh — "SAT Solvers and Computer Algebra Systems: A Powerful Combination for Mathematics", arXiv:1907.04408 | search snippets only |
| https://uwaterloo.ca/mathcheck (project, publications, history pages) | search snippets only |
| Kotsireas, Koutschan — "Legendre pairs of lengths ell = 0 (mod 5)", http://www.koutschan.de/publ/KotsireasEtAl23/main.pdf and RICAM report rep22-05 | **fetch failed** (TLS internal error on koutschan.de). Read at search-snippet level only; the "10 open lengths <= 200" figure and the Jedwab–Pender quaternary result are from snippets and need a primary read |
| arXiv:2101.03116 (Kotsireas, Koutschan — Legendre pairs, lengths = 0 mod 3) | search snippets only |
| arXiv:1302.0571 (Ðoković, Kotsireas — Compression of Periodic Complementary Sequences) | search snippets and abstract level |
| arXiv:1408.6116 (Ðoković, Kotsireas — D-optimal matrices of orders 118, 138, 150, 154, 174) | search snippets only |
| arXiv:2604.19947 (SAT + NAUTY orderly generation of Kochen–Specker sets) | search snippets only |
| arXiv:2603.21836 (IsalSR — instruction set and language for symbolic regression; canonical DAG invariant) | search snippets only |
| Bessiere et al., "Learning constraints through partial queries", AIJ 2023; Conacq at https://www.lirmm.fr/constraintacquisition/conacq.html; ModelSeeker; JAIR 2026 "Active Constraint Acquisition Using Large Language Models" | search snippets only |
| Chuffed https://github.com/chuffed/chuffed; lazy clause generation and symmetry-breaking papers | search snippets only |
| https://github.com/BrianLi009/MathCheck | repo page fetch (purpose, languages, solvers, commit count); exact license string and last-commit date not captured |
| https://github.com/OxiDD/oxidd, crates.io/crates/oxidd, TACAS'24 paper | search snippets; license (MIT/Apache-2.0) and July 2026 activity from those snippets |
| https://github.com/chrjabs/rustsat, crates.io/crates/splr, varisat docs, lib.rs/crates/sat-solvers | search snippets only |
| https://codetables.de (Grassl); E. Z. Chen's quasi-twisted database; arXiv:2512.23872 (hierarchical QC codes); arXiv:2007.00604 | search snippets only |
| errorcorrectionzoo.org/c/qcga (BB code page); QDistRnd (Pryadko) | search snippets only |
| Private campaign framing: /home/tavis/src/othello/notes/2026-08-30-c1016-ergodis-hadamard-quotient-synthesis.md | lines 1-60 only, as scoped |

### Caveats

- Every "no one does X" statement here is scoped to the queries listed above
  and is not a novelty verdict. In particular the claim that no system evolves
  sound necessary conditions for exhaustive search is a bounded-search
  negative; a proper priority check would follow
  `notes/literature-audit-conventions.md`.
- The August 2026 Hadamard resolution is the load-bearing fact in this report
  and was read only through search snippets and one Epoch AI page. Verify it
  at the primary announcement before acting on item 4.

status: complete
