# C985 residual hitting: classical boundary and research extensions

**Lane:** `complete-ports`

**Date:** 2026-08-30

## Executive verdict

The residual-hitting kernel in Ergodis is not a new Hitting Set algorithm.  Its
core decision problem and its branch-on-an-unhit-clause recurrence are
classical.  The potentially new contribution is the surrounding compiler:

\[
 \text{partial aligned object}
 \longmapsto
 \text{theorem-derived residual context hypergraph}
 \longmapsto
 \text{exact continuation lower bound}.
\]

For a partial family `X`, let `C(X)` contain one clause for every unresolved
cut context, with the clause listing the triples that can discharge that
context.  Every valid continuation `H` must hit every clause.  Consequently

\[
 d(X)\;\geq\;\tau(\mathcal C(X)),
\]

where `d(X)` is the true minimum number of additional triples and `tau` is the
transversal number.  Ergodis decides `tau(C(X)) <= r` exactly for the final
three selections.  This inequality is elementary once `C(X)` has been
constructed; the domain theorem is what proves that the constructed clauses
are necessary for every aligned continuation.

The defensible present description is therefore **theorem-compiled exact
residual transversal propagation**.  Do not describe it as a new residual
hitting theorem.  A stronger priority claim such as “first use for aligned
attachments” requires a dedicated literature audit and does not appear here.

## Classical ancestry

The implementation imports four classical ideas.

1. **Hitting Set / hypergraph transversal.**  Decide whether a set of at most
   `r` vertices meets every residual hyperedge.
2. **Bounded search trees.**  Select an unhit clause `C`; every solution must
   contain some `e in C`, so branch on those elements with budget `r-1`.
3. **Branch-and-bound residualization.**  Solve a necessary residual problem
   exactly and prune when its optimum exceeds the remaining main-search
   budget.
4. **Constraint propagation/lookahead.**  Spend additional bounded work near
   the leaves to detect an integral contradiction invisible to separate local
   constraints.

Niedermeier--Rossmanith's exact algorithms for bounded-rank Hitting Set are a
clear classical reference point.  Their `3`-Hitting Set algorithm improves the
naive search tree and their paper gives a `d`-Hitting Set extension.  Ergodis's
context clauses are not known to have bounded cardinality, so its fixed
`r <= 3` micro-search should not inherit or advertise their FPT bound.  It is a
bounded-depth exact oracle whose crude worst case is polynomial only because
`r` is fixed.  Later parameterized work continues to improve the specialized
`3`-Hitting Set base; that is algorithmic context, not an Ergodis novelty
claim.

The rejected fractional oracle is the ordinary set-cover LP relaxation,

\[
 \min\sum_e x_e,
 \qquad
 \sum_{e\in C_i}x_e\geq1,
 \qquad 0\leq x_e\leq1.
\]

It changed no prune on the rooted control and made the search 25.5% slower.
The admitted oracle gains precisely from small-budget integrality: all clauses
may be fractionally coverable within `r` while no actual set of `r` triples
hits them.

## What is specific to Ergodis

The reusable research contribution has four layers.

1. **Semantic clause derivation.**  Cut-context theorems generate necessary
   continuation clauses; the user does not hand an arbitrary Set Cover model
   to a generic solver.
2. **Monotone compiled state.**  Discharged cuts disappear permanently and
   triple-to-context incidence is compiled once.
3. **Adaptive exact continuation reasoning.**  The integral subproblem is
   invoked only when cheap bounds have not already decided the node and the
   remaining choice budget is tiny.
4. **Independent acceptance boundary.**  The oracle is a safe lower bound,
   and exhaustive five-point completion distances independently validate that
   it never overestimates.

This is an instance of a broader Ergodis principle.  Given a compositional
optimization problem, derive an obligation hypergraph from its admissible
future contexts and solve the small residual realization problem exactly.  A
general theorem would state sufficient conditions under which a monotone
context compiler `C` satisfies

\[
 \operatorname{dist}(X,\mathsf{Accept})
 \geq \tau(\mathcal C(X)),
\]

is equivariant under object symmetries, and admits witness-preserving
composition.  Classical Hitting Set then becomes a backend and a corollary,
not the claimed novelty.

## Measured effect

The final-three oracle reduces rooted eight-point search states by
`6.82x/6.35x/5.33x` at budgets `10/11/12`.  Seven interleaved budget-12 rounds
give `1.8410x` geometric wall improvement with paired log-ratio `t=267.262`.
On the real `[0,1,2]` weight-15 root it reduces `62.71M -> 24.03M` states,
`2^26 -> 2^25` table capacity, `527,600 -> 265,672` KiB RSS, and
`310.37 -> 215.38` seconds.  At the smaller capacity it closes four of the 26
other roots that formerly failed, raising diagnostic closure from `2/28` to
`6/28`.  These are deterministic diagnostics, not proof certificates and not
a change to the proved `15 <= g(8) <= 17` bound.

## Theoretical and implementation extensions

### 1. Adaptive exact depth four

Extend the oracle to `r=4`, but return **unknown** after a fixed work allowance.
Unknown must never prune.  Before branching, propagate singleton clauses and
use the existing disjoint-packing bound; invoke depth four only when both are
inconclusive.  This preserves fixed memory, no recursion, and no hot
allocation.  Admission requires exhaustive five-point soundness, state-count
improvement on held-out rooted controls, and positive wall time rather than
merely stronger pruning.

### 2. Exact obstruction certificates

A negative bounded search already contains a compact proof tree: each internal
node names an unhit clause, its outgoing edges exhaust the available elements
of that clause, and each leaf has exhausted the budget with an unhit clause.
Stream this tree or a shared DAG and replay it independently.  This turns a
runtime prune into proof-producing search and is the most important extension
for a mathematical `g(8)` claim.

The first generic proof kernel is now implemented in commit `a9f8bfd1e`.  It
provides a pre-sized, iterative bounded-transversal decision workspace and a
separate negative-certificate writer/verifier.  The baseline certificate
enumerates every `k`-subset of the available universe, for
`k=min(budget,|available|)`, and streams one clause missed by each subset.
Every smaller candidate extends to such a `k`-subset, so the proof is complete.
The verifier regenerates the subsets in canonical order and consumes each
4-byte clause-index record without buffering the proof.  Commit `3f6c58ec2`
removes the canonical subset and repeated clause mask from each record: the
verifier regenerates the former and resolves the latter from the index, cutting
record bytes by exactly 4x (`16 -> 4`) without changing semantics.  Repeated
solving performs no allocation and uses no recursion.  Commit `c09a015e5`
measures zero allocations for repeated solve, streamed write to a sink, and
independent replay after setup.  Exhaustive testing compares the kernel
with brute force for all 65,536 hypergraphs on a four-element universe and all
budgets zero through four; the full all-feature test suite and strict clippy
also pass.

Streaming alone does not bound disk consumption.  Commit `c555de3a5` makes the
maximum evidence-record count a mandatory writer argument, computes the exact
binomial count, and rejects an oversized proof before emitting its header.
The corruption test also checks that a rejected stream remains empty.  Thus
the caller controls both resident memory and worst-case file volume.

Commit `a3cf6cd08` adds the first theorem-driven proof reduction: an empty
residual clause refutes every budget and now emits one canonical record.  The
regression uses 16 available elements at budget 8, where blind middle-layer
enumeration would require `binomial(16,8)=12,870` records, and checks a 36-byte
proof instead.

This flat proof is deliberately a simple correctness baseline, not the final
storage claim.  Its output can be `Theta(binomial(n,k))`.  The next measured
format should stream the solver's branching tree or hash-consed DAG and retain
the flat form as the independent oracle on small kernels.  The engine is not
yet wired to turn a complete C880 run into a global proof; it certifies only
the bounded residual subproblem presented to it.

### 3. Kernelization of residual clauses

Delete duplicate clauses and any clause containing another residual clause;
hitting the smaller clause automatically hits its superset.  Force singleton
clauses and remove the obligations they discharge.  Because there are at most
127 contexts and 56 triples, a caller-owned fixed array and bit masks suffice.
The exact kernel should be compiled once per main node only if its saved scans
outweigh its quadratic dominance test.

### 4. Stronger aggregate lower bounds

The greedy disjoint-clause packing is safe but not maximum.  Candidate next
bounds are exact small packing, rank inequalities from the cut--triple
incidence matrix, and bounded odd-cycle/cover inequalities.  They should be
viewed as cheap admission filters before integral residual search.  The failed
LP experiment warns that a formally stronger relaxation can still lose on
instructions and integrality gap.

### 5. Contextual quotient of residual instances

Two residual hypergraphs are equivalent when every remaining choice budget
has the same feasibility response and compatible witness lift.  Canonicalizing
only small kernels could reuse exact answers without the failed syntactic
family-table scaling.  Any cache must use exact replay, bounded storage, and a
measured collision rate before admission.

### 6. Beyond unit-cost hitting

Weighted, capacitated, matroid-constrained, and Pareto continuation actions
replace transversal number by the corresponding exact residual optimizer.
This is the natural bridge to repair resources, scheduling, test selection,
and game-reply obligations.  The common theorem is the sound compiler from
semantic contexts to residual obligations; the backend algebra may differ.

### 7. C80 structural proof-packet synthesis

Residual hitting also supplies a stepping stone for the missing C80 survivor
edge.  For a target residual `R'=D_p D_o R`, take its unresolved defect or
opponent fibres as obligations.  Registered structural packets--a direct
`B_small` response edge, a persistent-pair block, an adaptive copycat shell,
or a projective incidence motif--each discharge an exact subset of those
obligations.  A compatible packet selection covering every obligation is a
replayable sufficient P certificate, without asking the recursive `K_Omega`
oracle whether the target survives.

The backend may begin as bounded Hitting Set/Set Cover with compatibility
checks.  Its finite algorithm is classical.  The useful Ergodis object is the
compiler

\[
  (R,o,p)\longmapsto
  \text{structural proof-packet obligation instance}
\]

and the lift from a selected packet set to an explicit opponent-complete game
certificate.  Negative bounded results remain diagnostic unless the packet
grammar is proved complete; positive results are sufficient once every packet
and the cover replay independently.

This creates a productive discovery loop.  Solve many finite fibres exactly,
canonicalize their selected packet patterns under projective transport, and
search for a short generative rule.  A recurring orbit-level rule becomes the
candidate symbolic incidence construction for the uniform theorem.  The
known q23 failure of shallow rank-zero routing warns that packet depth or rank
may grow with `q`; the representation must permit iterative packet DAGs, not
assume a fixed shell.

There are two non-negotiable qualifications.  First, persistent pairing is not
a monotone set-cover action: pair choices must form a disjoint complete
matching and satisfy cross-pair persistence.  That layer needs matching/exact
cover or a pre-certified whole-pairing packet; plain Hitting Set is sound only
for independently selectable response packets.  Second, a packet referring to
another positive-rank target is sufficient only inside an acyclic certificate
DAG ordered by a proved rank (`Omega`, defect rank, or another well-founded
measure).  Without those constraints, “coverage” would merely hide the same
recursive survivor oracle.

### Measured sharpening decisions

Two obvious strengthenings have now failed the admission gate and are not in
the code.  Extending exact residual hitting from the final three to the final
four choices changes no search-state count on rooted budgets 12 or 13 and
slows wall time by 19.2% and 18.4% respectively.  Exact duplicate/superset
clause elimination likewise changes no state count and slows those controls by
8.6% and 6.6%.  Both controls preserve the same result and search metrics.
This redirects residual work to proof emission or a genuinely stronger
aggregate rank/cover inequality; neither more bounded depth nor local clause
preprocessing pays on the measured distribution.

## C80: game-semantic admission before counting

The universal complete-exchange inequality is not the right theorem.  The
known q11 equality obstruction leads to an N successor, so it is irrelevant
to an existential P-reply theorem but fatal to any claim quantified over all
replies.

For state `S`, opponent `o`, and reply `h`, define the first admissible reply
predicate

\[
 \mathsf{Adm}(S,o,h)
 := \mathsf{Legal}(S,o,h)
 \land \mathsf{CertifiedP}(S+o+h)
 \land \mathsf{ChargeDescent}(S,o,h).
\]

`CertifiedP` must be backed by an existing sound hereditary boundary (`B_cc`,
`K_Omega`, or a replayed `F_d` certificate), never by a minimax label or an
unproved scalar selector.  The proposed charge descent is

\[
 c\ge n,
 \qquad
 c=n \Longrightarrow \Omega(S+o+h)<\Omega(S),
\]

where `c` is the number of consumed old labels and `n` the number of genuinely
new defects.  The resulting support-first pair `(charged support, Omega)` is
well founded.  The target theorem is existential and opponent-complete:

\[
 \forall S\in\mathcal K\;\forall o\in\mathsf{Legal}(S),
 \quad \exists h\;\mathsf{Adm}(S,o,h).
\]

The counting route should prove this without enumerating a growing reply
table.  Partition legal replies by the first violated admission condition,
bound each bad family using secant/pencil incidence, and show that their union
is smaller than the legal-reply set above a field threshold.  The already
proved q11 and q13 base fields may absorb equality exceptions.  A diagnostic
must report, for every opponent, counts of legal replies, P-certified replies,
charge-admissible replies, and the first empty fibre.  Aggregate exchange
counts alone cannot establish opponent completeness.

The first implementation of this predicate now uses the proved `K_Omega`
survivor as `CertifiedP`.  It filters the sampled state domain before counting,
requires the certified reply to re-enter `K_Omega` with strict `Omega` drop,
and only then applies the consumed/created charge test.  This corrects the
earlier diagnostic's quantifier error: arbitrary exchanges, including known N
successors, are not evidence against existential P-reply admission.

The deterministic q11 1,000-state control contains 334 sampled `K_Omega`
states, 315 with positive overload.  All 6,124 opponent fibres have an
admissible reply; all 23,000 certified replies pass the charge test.  Every
certified reply is a support-equality case, and the minimum `Omega` drop is 6.
Thus strict consumed-label surplus is false as the universal progress branch
even on the correct P domain; q11 progresses through the second lexicographic
coordinate.

The q13 300-state control contains 48 positive-overload `K_Omega` states.  All
1,930 opponent fibres have an admissible reply and all 10,428 certified replies
pass the charge test.  No certified reply has equal support; the minimum
consumed-minus-created surplus is 18.  This is the first clean evidence for the
field-split theorem shape:

\[
 q=11:\ \text{support equality with strict }\Omega\text{ descent},
 \qquad
 q\geq13:\ \text{strict support surplus}.
\]

These are deterministic sampled controls, not a uniform theorem.  Membership
in `K_Omega` is still supplied by the existing recursive certificate engine,
so the next mathematical step is to replace that oracle in the *existence*
argument: partition replies by the first failed geometric condition and bound
the union of bad families below the legal-reply count.  The observed minimum
surplus 18 at q13 is a margin to explain, not a bound to extrapolate.

The first failed-condition census sharpens that route again.  Every one of the
37,292 q11 and 33,596 q13 legal replies strictly decreases `Omega`; no reply is
lost at the scalar-descent gate.  The only failed condition is hereditary
survivor re-entry: 14,292 q11 and 23,168 q13 replies descend in `Omega` but
leave `K_Omega`.  Some opponent fibres have exactly one certified reply.  A
uniform proof therefore cannot stop at an `Omega` count or average abundance;
it must show that the non-survivor reply families never cover an entire
opponent fibre.  This is a tighter target than the earlier generic bad-family
union.

There is a uniform theorem beneath half of this observation.  Write the exact
residual as `R(S)=(V,E,A)`, with `A` the load-zero lines, and

\[
  \Omega(S)=\sum_{L\in A(S)}\max(0,|V(S)\cap L|-2).
\]

For every legal move `x`, `Omega(S+x) <= Omega(S)`.  An active line through
`x` changes from load zero to load one and leaves the sum; an active line not
through `x` retains load zero while its legal trace can only shrink.  No line
can change from positive selected load back to zero.  Applying the statement
twice gives monotonicity across every opponent/reply exchange.

Thus nonincrease is proved for all capacity-two projective residuals, not
merely sampled at q11/q13.  Strictness is the remaining incidence statement:

\[
 \Delta_\Omega(S;o,h)=
 \sum_L\left(a_L(S)-a_L(S+o+h)\right)>0,
 \qquad a_L=\max(0,|V\cap L|-2).
\]

This marginal decomposition is a better counting primitive than recomputing a
scalar difference.  It can identify which active lines each reply destroys
and lets a uniform proof show that no legal reply avoids every positive
marginal.  The present data establish strictness on the sampled domain only;
the monotonicity lemma alone does not.

## Gated `R^18` polynomial adapter

The design-only adapter uses the same pattern without launching C1000 Stage 1.
A prefix state contains fixed coefficients, remaining coefficient bounds,
Newton sums, type-2 congruence residues, an interlacing interval deck, and the
active exact linear inequalities.  Continuation actions append one
coefficient; rejection emits either a congruence witness, an interlacing
obstruction, or an exact Farkas vector.  Observational quotienting may merge
prefixes only when all admitted coefficient continuations and certificate
outcomes agree.

The first authorized gate is to reproduce the published `n=60` 44-candidate
list and the four approved integer-rooted Stage-0 counts.  The existing
integer-moment kernel already reproduces `177 -> 6`, `722 -> 28`, `2066 -> 28`,
and `68 -> 6`.  No `n=59/58` enumeration, large compute allocation, or new
equiangular-line claim is authorized by this memo.

## Literature scope and read depth

This is a positioning memo, not a novelty/priority audit.  It makes no absence
claim.  Zero sources were read in full.

- R. Niedermeier and P. Rossmanith, *An efficient fixed-parameter algorithm
  for 3-Hitting Set*, DOI `10.1016/S1570-8667(03)00009-1` — **partial**:
  publisher HTML abstract and introduction read; used for the problem
  definition, the bounded-search-tree lineage, and the stated `3`/`d` results.
- D. Tsur, *Faster parameterized algorithm for 3-Hitting Set*, arXiv
  `2501.06452` — **abstract/metadata only**: arXiv abstract retrieved; used
  only to establish that specialized exact-base improvements remain active.
- E. Zaytsev and A. Fernandez, *A fractional residue theorem and its
  applications in calculating real integrals*, DOI `10.1112/blms.70351` —
  **partial**: publisher HTML abstract and Sections 1--3 read; used only to
  distinguish fractional calculus and pseudo-residues from fractional or
  residual Hitting Set.  There is no mathematical dependency between them in
  the present work.

## Claim boundary

- **Classical:** Hitting Set formulation, branch-on-clause recurrence,
  residual branch-and-bound use, and fractional set-cover relaxation.
- **Established here:** exact aligned-context clause compilation, sound
  final-three integration, allocation-free iterative implementation,
  exhaustive small-instance validation, and measured cross-root capacity
  gains.
- **Potentially novel but unaudited:** the general contextual-obligation
  compiler theorem and its proof-producing use for aligned attachments.
- **Open:** compact proof replay, an aggregate rank
  inequality strong enough to close C880, C80 opponent-complete admissible
  reply counting, and the complete real-rooted `R^18` adapter.

The depth-four and local-kernel profitability questions are now settled
negative on the stated rooted controls.  The C80 predicate is implemented and
positive on its q11/q13 sampled `K_Omega` domains; its uniform geometric
counting theorem remains open.

## Deliberate red-team closeout and Mystery Ledger

- The `K_Omega` admission census cannot prove `K_Omega` is hereditary: it uses
  the existing certificate engine to define the survivor domain.  Its value is
  to isolate the missing geometric statement--every opponent fibre contains a
  re-entering reply--and to falsify stronger scalar claims.
- The q11/q13 split is empirical structure, not permission to extrapolate to
  all larger fields.  Why the minimum q13 support surplus is 18 remains a
  mystery; a uniform incidence argument must explain a symbolic margin.
- Some tested opponent fibres contain only one certified reply.  Mean reply
  abundance, random sampling, and global support surplus are therefore
  incapable of proving the existential response theorem by themselves.
- The residual proof kernel certifies a local Hitting Set instance, not the
  semantic correctness of the compiler that produced its clauses and not a
  whole-run UNSAT claim.  Those require independent clause-compilation replay
  and a global search certificate.
- Flat subset proofs have bounded memory but potentially enormous I/O.  A
  mandatory record limit now prevents accidental filesystem exhaustion; a
  branch-DAG format is still the leading compression candidate, contingent on
  measured proof-size distributions rather than assumed benefit.
- Exact depth four and local duplicate/superset kernelization remain killed on
  the recorded controls.  They should not return without a distributional
  change or a theorem that removes materially more work.
- The runtime attack controller is still a design.  Its soundness effect
  system, permanent falsifier corpus, and selection-bias controls are required
  before automatically discovered predicates may influence pruning.
- The `R^18` adapter remains gated and unlaunched.  Reproducing Stage 0 and the
  published `n=60` census is still the admission condition.
