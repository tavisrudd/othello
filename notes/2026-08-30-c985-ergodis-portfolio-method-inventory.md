# C985 Ergodis portfolio-method inventory and replay programme

**Lane:** `complete-ports`

**Date:** 2026-08-30

## Decision

The portfolio already contains a broad empirical specification for Ergodis.
Across geometry, coding theory, designs, games, and arithmetic search, the
successful C tasks repeatedly used the same research loop:

1. enumerate or generate structured partial objects;
2. quotient by a group action or by future observational equivalence;
3. retain one small obstruction, continuation response, or witness per class;
4. extract a structural lemma from the exceptional classes; and
5. replay the result independently at the semantic boundary.

Ergodis currently implements important pieces of this loop, but not yet as one
research-facing pipeline.  Its strongest near-term role is a **semantic census
compiler**: domain adapters expose typed states, admissible continuations,
observations, and witness checks; the common engine performs quotienting,
bounded exact search, evidence streaming, and counterexample-led refinement.

This memo samples results throughout the 2026-07-31 portfolio snapshot.  It is
an engineering/research inventory, not a novelty audit.  The original result
and its existing proof remain authoritative until an Ergodis replay has its own
independent verifier.

## Inventory of successful C-task methods

| sampled result | method actually used | latent sufficient state | Ergodis route |
|---|---|---|---|
| Clebsch six-arc rigidity at `q=11` | projective normalization, orbit ledger, exceptional low-degree kernels, later structural extraction | chord-concurrence profile plus uncovered-locus evaluation response | typed projective orbit adapter; compile low-degree responses; retain separating minors and a projectivity witness |
| all-size conic-filling arc programme | branch split, character sums, clique search, digit/Frobenius ranks, bounded exact classifications | externality type, coverage deficit, Cartier--Toeplitz rank and residual slack | continuation hierarchy from coarse counts to rank state to explicit geometry; character-sum and finite-rank primitives |
| `rho_C(16)=9` | exhaustive projective augmentation `4,61,454,2633`, quadratic evaluation rank, three exceptional forced-hit forms | canonical arc plus uncovered quadratic rowspace | consuming orbit enumerator; incremental rowspace; observationally merge equal extension/rowspace responses; stream one minor or forced-hit form |
| matching-quotient `B3/H3` rigidity | quotient evaluations, moment closure, double cosets, representation-theoretic extraction | exact hierarchy `1 -> 2 -> 6 -> 2q` | already realized by `ContinuationHierarchy`; use as the calibration fixture for progressive observations |
| binary conic-code reconstruction | minimum-word orbit census, pair-concurrence reconstruction, commutant field discovery | minimum-word pair intersection profile and generated scalar algebra | relation minimization followed by commutant/rank adapter; synthesize the smallest relation set reconstructing the incidence scheme |
| cubic-threefold gluing and minimal-class saturation | Smith forms, local prime decomposition, invariant lattices, exact certificates | local Jordan blocks, divisor-product span and torsion boundary | exact module-state adapter with incremental Smith/rank summaries and prime-stratified continuation levels |
| prescribed-hole defect identity | integer moment envelopes followed by matching-design equality analysis | degree histogram, uncovered deficit, concurrence-clique packing | Pareto/ordered-monoid state with exact dominance; emit a dual envelope or packing deficiency witness |
| higher `(k,n)`-arc bounds | simultaneous integral envelopes, modular residues, matching-number cap | two degree sums, residue type, remaining block intersections | multiobjective finite monoid plus modular continuation; derive rather than hand-select the resonant offset states |
| PRS redundancy `5--10` | Hankel kernels, coherent marked polar contraction, low-genus bounds, small-field orbit closure | catalecticant rowspace, every retained forbidden root, component label | marked continuation language; quotient flags rather than unpointed fibres; use a genus/point-budget terminal theorem |
| bounded recovery transfer | derive labelled coset-support state, min-plus composition, retain coefficient witnesses | contextual cost table | native Ergodis application and theorem source |
| CSS/quantum distance | global logical re-encoding, automorphism orbits, parity/packing theorems, native branch-and-bound | syndrome, logical quotient, packed completion response | existing native backend; symmetry and completion filters are compiled before search |
| stabilizer-AME rigidity | shorten to a local tensor, reconstruct Weyl axes, exact exceptional group census | reduced Weyl tensor and local-axis response | finite tensor contraction adapter; observationally quotient local gauges before exact group enumeration |
| `PG(2,25)` Frobenius pair repair | normalize to 46,056 rows, classify as bad triple or legal-pair witnesses, transport under residual group | normalized row and its legal-orbit mask | compile the 310-bit response once; quotient rows by residual action/response; stream obstruction or the required number of witnesses |
| four-frame continuation rigidity | recover coordinate cliques, solve multiplicative isotopies, finite exception table | coloured tangent-trace incidence and coordinate-permutation response | relational contextual quotient plus exact automorphism backtracking; separators become distinguishing neighbourhood words |
| aligned-design query complexity | cut quotient, bipartiteness/Euler witnesses, symmetry-rooted DFS, residual hitting | 127 cut closures and remaining exposed clauses | existing alignment adapter plus proof-producing residual hitting and root-scoped campaign control |
| Hadamard-668 multiplier exclusions | compressed moments, orbit locks, exact shift spectra, independent arithmetic replay | multiplier-orbit partition and locked-count vector | generic cyclic-action lock compiler, then a continuation hierarchy from compression moments to full orbit PAFs |
| odd-plane cap game | exact residual game, defect/debt ledgers, falsifier-guided reply predicates | boundary loads, survivor rank, consumed/created label response | existing private campaign/controller; evolve diagnostic predicates but admit pruning only after replay/proof-role validation |

## What the inventory says Ergodis is missing

The common gaps are narrower than a new generic solver.

1. **Consuming structured enumeration.**  The compiler should accept a stream
   of canonical states and immediately fold it into response classes, without
   retaining the raw census.
2. **Incremental algebraic summaries.**  Rowspaces, Smith data, moment vectors,
   and constraint closures need fixed-capacity push/pop adapters analogous to
   the existing allocation-free search kernels.
3. **Marked context languages.**  PRS polar induction shows that forgetting a
   removed root can merge a good and bad continuation.  Context types must
   retain such markers explicitly.
4. **Witness-count objectives.**  Q25 needs the first two legal witnesses, not
   only feasibility.  The common interface should support bounded distinct
   witness counts and transport data.
5. **Certificate-to-lemma mining.**  Exceptional response classes should be
   queryable by invariant features so that collinear-six-point, orbit-lock, or
   forced-hit patterns can be promoted into human lemmas.

## Ranked five-target replay programme

### 1. `PG(2,25)` two-witness Frobenius pair repair

This is the best end-to-end compiler test.  The known answer is exact, the
normalized domain has only 46,056 rows, and the old proof artifact makes the
cost of an uncompressed evidence language visible.  Ergodis should reconstruct
the `39,012` obstruction / `7,044` legal split, prove at least two distinct
legal orbit codes for every legal row, compile response classes under the
order-400 residual action, and stream one bad triple or two witnesses.  The
independent verifier must recompute determinants and transport, not trust class
IDs.

### 2. `rho_C(16)=9` and the `2630+3` quadratic split

This tests consuming canonical augmentation plus algebraic state.  Ergodis
should reproduce the class counts `4,61,454,2633`, maintain the uncovered-locus
quadratic rowspace incrementally, and emit either a full-rank minor or the
unique kernel form together with an arc hit.  The research bonus is automatic
recognition of the six-point collinear/noncollinear obstruction that explains
2,630 leaves without elimination.

### 3. Coherent PRS polar flags

This is the most general theorem-facing target.  Reproduce the redundancy-six
and redundancy-seven persistent/transient partition while retaining every
removed root as a typed marker.  Then deliberately erase the marker and require
the compiler to produce the `q=19`, `W=<1,t^3,t^4>` separating context.  That
turns the original warning about incoherent induction into a machine-checked
minimal-state result and creates infrastructure for levels eight through ten.

### 4. Aligned-design attachment constants and `g(8)`

Reprove `g(5)=9`, `g(6)=12`, and `g(7)=15` through the cut quotient and
proof-producing residual-hitting backend, then resume the exact `15/16`
exclusions at eight points.  Known small answers make this a differential gate;
`g(8)` is the live crown.  The next theorem import is a stronger aggregate
context-rank bound, not a larger syntactic duplicate table.

### 5. Hadamard-668 residual multiplier locks and lifts

First reproduce the six-case lock spectra and the exact ID-2 exclusion from a
generic cyclic-action primitive.  Then compile IDs 4 and 5 through nested
observations: row sum, 9-compression moments, 37-compression moments, and full
shift-orbit PAF response.  The known lock result is a cheap correctness gate;
an ID-4/5 exclusion or survivor would be new progress on the structured
Legendre-pair route.

## Why these five

They span geometry, algebraic coding theory, design reconstruction, and
arithmetic combinatorics.  More importantly, they demand five distinct shared
capabilities: witness-count compilation, incremental rowspaces, marked context
languages, aggregate residual bounds, and cyclic correlation state.  Success
would therefore expand Ergodis rather than accumulate domain-specific binaries.

The cap game remains the highest-upside open application, but it is already an
active Ergodis test bed and currently lacks the missing uniform survivor
theorem.  The five above provide more known-answer differential gates and are
more likely to harden the common engine before another C80 campaign.

## Attempt protocol

For each target:

1. freeze the original result, domain, and exact counts;
2. implement domain semantics only in `ergodis-private`;
3. add reusable mechanisms to public Ergodis only when the API is independent
   of private terminology and research identifiers;
4. compare the quotient and witnesses against the original generator on a
   bounded complete corpus;
5. stream evidence and replay it through an independently structured checker;
6. record raw states, quotient classes, transitions, evidence bytes, wall time,
   and peak RSS; and
7. treat every timeout or bounded survivor as diagnostic, never as a theorem.

## Initial status

- Target 4 already has a mature Ergodis adapter: the cut quotient, exact
  verifier, root symmetry, residual-hitting oracle, and `g(5)=9` replay pass;
  `g(8)` remains `15 <= g(8) <= 17`.
- Target 5 already has the 9-compression continuation layer for ID 3, reducing
  17,562,843 normalized raw sequences to 769,834 response signatures and 2,131
  compatible pairs.  It does not yet supply the generic orbit-lock primitive
  or close a surviving full orbit model.
- Targets 1--3 have authoritative generators and certificates but no admitted
  Ergodis replay yet.

The initially planned first slice was the generic cyclic orbit-lock compiler.
The user raised Q25 certificate cost as the more urgent target, so the first
landed implementation slice below is the normalized Q25 two-witness replay;
the orbit-lock compiler proceeds independently.

## First Q25 replay result

The priority was changed to Q25 because its historical certificate architecture
is the clearest avoidable cost.  The first admitted slice replaces the C143
normalized two-witness row forest, not yet the later exact-minimum-32 residual
transport/class proof.

`ergodis-private::q25_pair_repair` independently reconstructs `PG(2,25)`, its
31 Frobenius-fixed points and 310 nonfixed point-pair orbits.  It evaluates the
46,056 normalized rows under Ergodis's generic parallel root executor, obtaining
exactly 39,012 collinear-triple obstructions and 7,044 arcs with at least two
distinct legal pair repairs.  It also computes all 310 repair responses of every
legal row and compiles them through the public observational minimizer.  The
full response quotient has 7,044 classes: no two legal rows have the same
310-bit repair vector.  This is a useful negative—the theorem must compile the
bounded two-witness objective, not preserve a needlessly complete response.

The theorem-specific stream uses the implicit lexicographic row rank.  Each bad
row stores one byte selecting one of the 56 triples; each legal row stores a tag
and two 16-bit orbit codes.  The complete certificate is therefore exactly
74,244 bytes.  A separately structured verifier reconstructs the field and
checks determinants directly rather than trusting the generator's precomputed
join table.  Corrupted magic is rejected.

One diagnostic thread-scaling sweep, capped at 12 workers and protected by
`choom`, gave:

| threads | compile + full-response quotient (s) | exhaustive 310-response replay (s) |
|---:|---:|---:|
| 1 | 0.553 | 3.995 |
| 2 | 0.355 | 2.291 |
| 4 | 0.266 | 1.667 |
| 8 | 0.175 | 0.781 |
| 12 | 0.119 | 0.710 |

At 12 threads, certificate writing takes 0.005 seconds and objective-specific
certificate replay 0.063 seconds.  The full process takes 0.95 seconds and
35,124 KiB peak RSS.  These are single-round diagnostics, not a statistical
benchmark.  The historical C143 records report 9:32:18 and 6.40 GB for the
full Lean build, with a trace-only replay of 8.83 seconds and 573,960 KiB; those
numbers are records only and were not rerun.  The original two-variant C++/Python
proposal generator takes 17.28 seconds and 162,144 KiB in one current cold
process, but that includes two C++ compilations and 606 subprocess launches and
is not the important certificate comparison.

The next landed slice replaces the finite exact-minimum lower-bound forest.
For each bad row it retains the one-byte obstruction; for each legal row it
streams the exact 310-bit response mask as five `u64` words.  The resulting
327,828-byte certificate is replayed by a separate parallel determinant
checker.  It certifies the complete legal-count range 32 through 47 and exactly
24 normalized rows at the minimum 32.  A warm 12-thread diagnostic takes 0.635
seconds for semantic certificate replay; the full process, including the
independent census replay as well, takes 1.42 seconds and 33,628 KiB peak RSS.
Certificate writing takes 0.00064 seconds.  This remains a single-round
diagnostic.

The residual-action slice reconstructs, rather than tables, the ordered
fixed-pair subgroup: it enumerates the 400 normalized invertible base-field
matrices fixing the two distinguished points and compiles their permutation
action on all 310 conjugate-pair orbits.  Canonicalizing the 24 minimum slice
rows produces exactly five representatives `(65,93,154)`, `(65,96,216)`,
`(65,98,251)`, `(65,119,232)`, and `(65,123,279)`.  Their orbit sizes are
`200,400,400,200,400`, their stabilizer orders are `2,1,1,2,1`, and their slice
intersections are `3,6,6,3,6`.  Thus their global union has size 1,600.  The
classification adds 0.071 seconds to the warm 12-thread diagnostic and no
problem-specific representative table to the implementation.

The later sealed Q25 exact-minimum/extremal package is larger: the committed
record inventory has 9,511 Lean modules and about 83.1 MiB tracked source, with
at least 6h27m of recorded cold tree builds and roughly 4 GB per worker.  It also
contains residual transport, class-link, cover, and exhaustion obligations not
present in C143.  The exact-mask certificate makes the 1,189-class lower-bound
proof forest unnecessary, and the semantic residual-action replay replaces the
five-orbit transport/stabilizer computation.  A proof-assistant-facing semantic
lift from the normalized slice remains separate; no Lean build was rerun here.

## First Hadamard orbit-lock replay result

The generic public `CyclicOrbitLocks` compiler now accepts any finite
permutation action.  Its structural reduction identifies a full shifted lock
spectrum with the ordered within-orbit cyclic-difference multiset, so
compilation costs `sum |O|^2` and every later shift query is O(1), allocation
free, and backed by a compact `n`-entry `u32` census.  The private LP333 adapter
reproduces all six recorded spectra and uniquely excludes ID 2 against an
independent certificate.

This theorem reduction cuts the adapter's census comparisons from 665,334 to
4,734, or 140.54x.  In 31 interleaved rounds the native end-to-end median is
0.994 ms versus 80.947 ms for the Python generator and 175.162 ms for the
independent Python replay: 81.47x and 176.30x respectively.  Nine native RSS
rounds give a 2,304 KiB median.  These are process-plus-serialization controls,
not isolated kernel timings.

## First `rho_C(16)` quadratic-obstruction replay result

The private Q16 adapter consumes the frozen 2,633-leaf stream without importing
the old generator or rebuilding its Lean package.  Its Ergodis root kernel uses
precomputed 273-bit line masks and first tries the elementary six-point
obstruction: three uncovered collinear points force a line component, while
three noncollinear uncovered points off that line rule out the residual linear
factor.  Incremental GF(16) elimination is reserved for leaves where that
predicate fails.  The hot leaf path allocates nothing.

The result is exactly 2,630 structural certificates, zero full-rank algebraic
fallbacks, and three rank-five forced-hit leaves, numbered 89, 90, and 2,631.
Their normalized kernel forms and selected-point intersection counts reproduce
the records exactly: `(1,1,1,1,1,0)/2`, `(0,0,0,5,4,1)/7`, and
`(2,1,1,5,5,1)/2`.

An 11-round scaling diagnostic gives median analysis times of 4.093, 2.354,
1.581, 1.388, and 1.641 ms at 1, 2, 4, 8, and 12 threads respectively; eight
threads is the honest optimum for these tiny roots.  The 11-round median native
parse-plus-analysis time is 2.654 ms.  The committed independent Python
analyzer has a five-round median wall time of 8.12 seconds, about 3,060x larger.
This is a functional end-to-end control, not an isolated-kernel ratio: the
Python program additionally computes complete spectra, stabilizers, and a
projective invariance check.

## First coherent marked-polar replay result

The q=19 adapter enumerates all 381 projective members of
`W=<1,t^3,t^4>` and retains their exact 20-point projective root masks.  It
finds exactly six split squarefree quartics.  Their common-root mask is the
single point at infinity, so all six use infinity and there are zero members
with four finite roots, exactly reproducing the transient pointed-bad
falsifier.

To test the state question rather than merely recount the six witnesses, the
adapter presents the 20 possible forbidden-marker states to the public Ergodis
observational compiler.  With the marker erased they have the same immediate
observation.  The future query “does a split witness avoid this marker?” creates
exactly two contextual classes: infinity, where no witness survives, and the
19 finite markers, where one does.  Thus the removed-root marker is not optional
state; the separating continuation is generated automatically from the exact
response table.

The natural historical control is the full marked-polar calibration and its
independent five-secant/orbit replay, which prove much more than this sharp
falsifier.  Their current checkout was intentionally externalized and its
field-arithmetic dependency is absent, so no fresh timing ratio is claimed.

## Aligned-design attachment result

This target was already landed earlier in the C985 campaign and is detailed in
`notes/2026-08-30-c985-aligned-attachment-compiler.md`.  The public cut-quotient
compiler agrees with the original four-triple definition on all 1,024
five-point query families and independently re-proves `g(5)=9`.  It also
accepts the committed 17-query `g(8)` witness and rejects a one-query deletion.
The compact SAT control is satisfiable in 0.20 seconds; CryptoMiniSat consumes
the native XOR form in 2.8 seconds including generation and startup, and its
selected variables replay in the independent Rust verifier.

The theorem-driven stabilizer quotient is the more important reusable result.
On the exact six-point budget-11 exclusion it reduces 50,349 states to 3,558;
21 interleaved rounds give a 5.7845x geometric wall-time ratio with paired
log-ratio `t=55.493`, while instructions fall from 1.049 billion to 105.7
million.  On the target-shaped eight-point rooted budget-10 exclusion it
reduces 302,471 states to 8,759 and gives a 30.18x geometric wall-time ratio in
three diagnostic rounds.  No fresh run was made here because the private
controller adapter has an unrelated unstaged edit; the committed public core
and recorded benchmark remain the authority.

## Programme status

All five ranked target families now have an Ergodis attempt with an exact
acceptance gate: Q25 exact masks and residual orbits, Q16 structural quadratic
obstructions, the q=19 coherent-marker separator, aligned attachment, and
Hadamard cyclic locks.  Q25, Q16, and Hadamard have fresh natural-control
measurements; aligned attachment retains its prior interleaved SAT/native
controls; the externalized PRS full-field control is recorded without a fresh
ratio.

## Natural comparison implementations

Once each replay works, comparisons will separate compilation, solve,
certificate production, semantic replay, and end to end.

| target | domain control | mature general control |
|---|---|---|
| Q25 | authoritative purpose-built C++ orbit/bitset enumerator and committed Lean timings | CNF plus Kissat/CaDiCaL and verified LRAT/LPR replay only as a secondary formal-proof route |
| `rho_C(16)` | original orderly projective augmentation and GF(16) rank checker | nauty/Traces 2.8.9 as a coloured-incidence canonicalizer inside the same enumerator |
| coherent PRS flags | original orbit-reduced finite-field implementation | Magma V2.29-9 for finite fields, rowspaces, factorization, and projective orbits |
| aligned attachment | native cut-quotient DFS | Kissat 4.0.x compact CNF and CryptoMiniSat 5.14.7 parity-native XCNF; `cake_lpr` for negative-proof replay |
| Hadamard locks/lifts | independent Python congruence/PAF replay | CryptoMiniSat 5.14.7, OR-Tools CP-SAT 9.15.6755, and Gurobi 13 for the full orbit lift |

For short controls the measured protocol will use at least eleven interleaved
rounds and paired log-ratio statistics; long controls use at least three.  Cold
process and warm compiled-table modes, 1/2/4/8/12-thread scaling, instructions,
cycles, branches, branch misses, last-level cache misses, peak RSS, evidence
bytes, and verifier wall time are separate fields.  A generic solver timeout is
diagnostic only, and no bespoke geometry result will be described as published
end-to-end SOTA when no such implementation exists.
