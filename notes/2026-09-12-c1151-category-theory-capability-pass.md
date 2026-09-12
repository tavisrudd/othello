# C1151 — category theory for Ergodis, capability-first second pass

**Lane**: `ergodis`
**Date**: 2026-09-12
**Status**: IN PROGRESS (started 2026-09-12)
**Predecessor**: `2026-09-12-c1150-category-theory-for-ergodis.md`

## Why a second pass

C1150 was run with a literature-audit posture and an over-narrowed brief ("no gradient and
no network"). Tavis's framing: the goal is improving what Ergodis can do, not novelty or
academic priority. Gradient search and small simple neural networks are in scope; only
methods that depend on deep/large nets are out. GPU acceleration (WebGPU / Rust GPU bindings) is available for larger Evolve structure searches, so GPU-specific cost models are in scope. Prior art is a template
to absorb, never a gate.

## Scope

Two dossier halves, continued by the same two subs that hold the C1150 context:

- Part A (`2026-09-12-c1151-part-a-gradient-priors-capability.md`): gradient-shaped
  material dropped by C1150 (optics/Para formulations of Lagrangian and LP duality,
  continuous relaxations as bound sources, reverse-derivative categories, small learned
  heuristics as proposal or branching scorers), Markov categories for Evolve's proposal
  distributions, and algorithm-depth reads of C1150 part A rows 1–4 including what
  pyncd/tsncd implement for negative information.
- Part B (`2026-09-12-c1151-part-b-galois-quotients-implementations.md`): Galois
  connections and abstract interpretation for bounds and admission; bisimulation and
  partition refinement as the algorithmic content of contextual quotients; symmetry
  (orbits, lex-leader, orbital branching, canonical augmentation) for C1016 and Evolve;
  Lawvere theories for the FeatureDag algebra and polynomial functors for campaigns; and
  algorithm-depth reads of C1150 part B rows 1–5 with their reference implementations
  (egg/egglog, VeriPB, OpenFst, Catlab).

Both parts: every source carries a read-depth field; PDFs go to the shared cache; each
absorption row carries the six C1150 fields plus a "needs gradient / needs small NN /
neither" column; anything set aside on the first pass as standard ground is named and
assessed on capability alone.

## Deliverable

A merged capability ranking appended here, superseding the C1150 ranking where they
disagree, with the implementation slices to allocate.

## Report (2026-09-12)

**Status**: both halves complete and committed; merged ranking below supersedes the C1150
ranking where they disagree. No engine edits; no Ergodis source was read by either sub, so
every mapping onto an Ergodis object rests on documentation and may lag the code.

- Part A: `2026-09-12-c1151-part-a-gradient-priors-capability.md` (15 named sources, none at
  full text by design: algorithm-depth section reads with sections named per claim; four
  code files read end to end from pyncd/tsncd and a co-design solver).
- Part B: `2026-09-12-c1151-part-b-galois-quotients-implementations.md` (26 named sources:
  11 partial, 10 abstract/metadata, 5 reference implementations read at source level: Boa,
  egg, OpenFst, VeriPB, Catlab.jl).

### Organising principle (part A, adopted)

A gradient, learned model or GPU kernel may **order**, **bound**, or **propose parameters**;
it never certifies. Bounding is the opening: a dual object need not be found exactly, only
checked exactly. A float dual walk that emits a rational multiplier vector, repaired to dual
feasibility and evaluated exactly, is a certificate guesser whose output is a certified lower
bound. Willerton's Legendre–Fenchel-as-profunctor-nucleus result, with the Boolean case being
the Galois connection of a relation, makes C1150's composable ban and a numeric dual bound one
object: a ban store with a `reason` field, `Bool` giving refusals and an ordered semiring giving
bounds. That collapses C1150 rows 1–3 and C1151 A-1/A-3/A-4 into one implementation.

### Findings that change a C1150 recommendation

1. **Compute quotients, do not only check them.** `ValidatedQuotient` verifies a supplied
   quotient and declines minimality. Coalgebraic partition refinement produces the coarsest
   behavioural quotient in O(m log n) from one implementation covering deterministic,
   weighted and polynomial presentations. Boa's loop is a 183-line Rust main loop over four
   flat vectors, but its signatures are 64-bit FxHash digests, so any adoption must choose
   exact keys or declare a collision bound.
2. **Weight pushing is blocked by the sentinel, not the semiring.** OpenFst's reweighting
   needs a `Divide` and skips arcs at `Zero`; the tropical semiring is fine, the saturating
   `u32::MAX` sentinel is not. First experiment is settling the sentinel.
3. **Equality saturation is the largest first-pass miss** (both parts agree). Order-free
   rewrite search with cost-driven extraction, in Rust, with `e-class analysis` as a ready
   slot for a preservation contract. Extraction cost, the reason C1150 kept it at medium, is
   a solved problem in egg.
4. **Interval analysis is a first-class lever**, not an incidental lead: one topological pass
   over the acyclic FeatureDag, no fixpoint or widening, statically answers "can this subterm
   overflow", which selected-root lowering currently answers only by test corpus.
5. **The negative-information tooling does not exist.** pyncd/tsncd contain no cost model,
   tiling, kernel generation or ban machinery; the one reachable co-design solver represents
   infeasibility as a lattice top with no reason or certificate. C1150's row 1 is a design to
   build, not a library to bind.
6. **Symmetry: quotient, do not assume.** C1016's multiplier program assumes invariance
   (lossy, shard-local); quotienting by the group acting on the unrestricted problem is
   lossless and needs no invariant. Part B derives a group of order at least 522⁴·3! from the
   card's equation, unverified against private code. A lever on enumeration, corpus dedup and
   restart seeding, explicitly not on the inner tabu loop. McKay canonical augmentation gives
   one representative per isomorphism class with a coverage theorem.
7. **FeatureDag is a presented Lawvere theory**, so "which identities may the simplifier use"
   becomes a definition discharged once per identity, and weak term acyclicity is the check.

### Merged capability ranking

Ordered by value per unit of effort. "Needs" is the scope column: neither / GPU optional /
GPU / small model / gradient. Nothing needs a deep or large network.

| # | Lever | Ergodis object | Needs | Conf. | Source rows |
|---|---|---|---|---|---|
| 1 | Interval abstraction over FeatureDag, one topological pass | FeatureDag lowering, overflow pre-screen | neither | high | B-1 |
| 2 | Ban store with `reason` and backward transport, unifying refusals and dual bounds; subadditivity law on `ordered_resource` | admission, certificates, plan composition | neither | high | A-3, A-4, C1150 1–3 |
| 3 | Dual-certificate bound from an inexact relaxation, repaired to exact rational dual feasibility | bound tightening, C1148 certificate interop | gradient (optional) | high | A-1 |
| 4 | Semiring-polymorphic verifier | independent checker, witness contracts | neither | high | B-4, C1150 2 |
| 5 | Weak term acyclicity check; then theory relations and critical branchings | FeatureDag identities | neither | high | B-2, B-9 |
| 6 | Sentinel fix, then weight pushing + minimization | summary trees | neither | high | B-3 |
| 7 | Coalgebraic partition refinement computing the coarsest quotient, exact keys | ValidatedQuotient, catalogs | GPU optional | high | B-5 |
| 8 | VeriPB-style omission certificate with witness substitution | catalogs, receipts | neither | high | B-6, C1150 3 |
| 9 | Equality saturation over plan terms; e-class analysis carrying a preservation contract | plan compilation, FeatureDag lowering | neither | medium (biggest architectural bet) | A-5, A-6 |
| 10 | Learned scorer for Evolve proposal ordering (linear or tree model); sliding-window UCB operator selection | Evolve proposals | small model | medium | A-2, B-10 |
| 11 | Canonical form + isomorph rejection; group quotient for C1016 enumeration/dedup/seeding | C1016 search | GPU optional | medium | B-8 |
| 12 | Widening-shaped bounded probe with narrowing | query-directed compilation probes | neither | medium | B-7 |
| 13 | Markov-category discipline on proposal distributions; conditioning on refuted proposals | Evolve sampling, structured counterexamples | neither | medium | A-8, A-9 |
| 14 | Parallel heuristic + warm-started exact | Evolve, FeatureDag | neither | medium | B-11 |
| 15 | Campaign interface as a polynomial functor; Para tape as the admitted-parameter-change contract | campaigns, RepairModel/BudgetQuery | neither | medium | B-12, A-12 |
| 16 | Weaves transfer-cost model retargeted to WebGPU; tropical span kernels on u32 lanes | Evolve candidate evaluation, semiring adapters | GPU | medium | A-10, A-11 |
| 17 | Learned branching inside exact kernels | hot loop | small model | medium, only hot-path row | A-13 |
| 18 | PolyCirc reverse derivative over saturating/prime semirings; reverse-mode AD on a relaxation | Evolve discrete parameters | gradient | low | A-7, B-14 |
| 19 | GPU linear-algebraic refinement | quotients, C1016 | GPU | low | B-13 |

**GPU design rule from part A**: WGSL has exact u32 and no f64, so the GPU filters and
orders while the CPU certifies; the weaves cost model retargets by substituting four numbers
per memory level, and with 16 KiB workgroup storage it predicts tiled (β = 0.5) over
broadcast (β = 1) shapes before any kernel is written.

### Proposed implementation slices (unallocated; Tavis's call)

1. **Offline FeatureDag slice**: rows 1 and 5 (interval pass; acyclicity check). Gate: zero
   false negatives on the 1,984-row lowering corpus, precision reported.
2. **Certificate slice**: rows 2, 3, 4, 8 as one design with the verifier interface first.
   Gate: measured work reduction from admissible bounds on a frozen C1016 or C1143 workload;
   a VeriPB-checkable omission step for one catalog transformation.
3. **Quotient slice**: rows 6 and 7. Gate: settle the sentinel; coarsest quotient computed and
   independently verified on existing summary trees and one ValidatedQuotient family.
4. **Evolve slice**: rows 10 and 13, then 11 for C1016. Gate: proposals reaching the family
   checkers reordered with a counted drop in wasted proposals; no evidence claim touched.
5. **Rewrite bet**: row 9 as its own spike after slices 1–3.

### Mystery ledger

| Item | Settled? | Gap or owner |
|---|---|---|
| Boa hash-digest signatures: exact keys or collision bound | open | decide at quotient slice |
| Group order ≥ 522⁴·3! for C1016 derived from the card, not the code | open | verify in `ergodis-private` before slice 4 |
| Three Ergodis-side facts from C1150 part B (C1093 count readout; O7 tabu shape; obstruction data on failed admission) | open | verify before slices 2–4 |
| Could not access: Margot's symmetry-in-ILP survey, Valmari LNCS 5606, orbital branching paper, Springer AGI chapter; Cousot POPL'77 is an unOCR'd scan | open | no claim rests on them |
| No categorical account of regularization, evolutionary operators or branch-and-bound located | open, weak negatives | web search only |

### Process note

Part B guessed three arXiv identifiers from memory and all three were wrong; two fetched
unrelated papers and one a relevant paper under the wrong name. The cache manifest entries
were corrected with a recorded note. The magic-byte check cannot catch a valid PDF of the
wrong paper: resolve every identifier from the abs page before caching.
