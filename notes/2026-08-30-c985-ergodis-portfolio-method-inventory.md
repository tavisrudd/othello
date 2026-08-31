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

The later sealed Q25 exact-minimum/extremal package is larger: the committed
record inventory has 9,511 Lean modules and about 83.1 MiB tracked source, with
at least 6h27m of recorded cold tree builds and roughly 4 GB per worker.  It also
contains residual transport, class-link, cover, and exhaustion obligations not
present in C143.  Replacing that package requires a second Ergodis certificate
layer over the 1,189 residual classes and their transport masks; the 74 KiB
certificate is not represented as a replacement for those obligations.

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
