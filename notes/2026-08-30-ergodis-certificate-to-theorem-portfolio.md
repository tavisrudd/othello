# Ergodis certificate-to-theorem portfolio

**Date:** 2026-08-30

## Decision

The C880 extraction should become a general private Ergodis research layer,
not a SAT-only utility.  Its job is to convert exact finite evidence into the
smallest semantic obstruction visible in the source problem, then support a
counterexample-guided search for a structural lemma whose implication is
independently certified.

The best immediate portfolio targets are C80 and C896.  C80 has the highest
mathematical payoff and the richest existing exact corpus.  C896 is the best
second *modality*: its certificates are finite-field rank computations rather
than CNF refutations, and its desired general theorem is explicitly a finite
carry/borrow state machine.  A first C896 rank-core adapter is now implemented
and replayed at `q=9`.

## Ranked targets

Scores combine theorem value, existing exact evidence, likely semantic
compression, tractable next computation, and reuse of the resulting adapter.
They are prioritization judgments, not novelty grades.

| rank | problem | grade | search and certificate | structural extraction target |
|---:|---|---:|---|---|
| 1 | C80 global residual rematching | 96 | exact matching/flow instances; positive matching witnesses or negative Hall cuts; existing survivor DAG replay | projective Hall-rematching lemma with strict support descent and opponent completeness |
| 2 | C896 corrected finite-group socle | 94 | exact sparse Hom matrices over `GF(q)` with rank/PLU certificates at `q=9,25` and exponent three | minimal carry/borrow automaton and a block-triangular most-significant-digit induction |
| 3 | C756 saturated-internal coherence | 90 | maximum-clique/nonexistence certificates in the `AGL(1,q)` Cayley graph; existing census through `q<=127` and `q=169` | character/polynomial or dual-3-net lemma improving the ratio bound by the missing 25 percent |
| 4 | square-root conic-arc repair layers | 88 | synthesize and certify nonlinear coefficient layers; exact collision and coverage replay | semilinear orbit normal form or interpolation theorem explaining the twelve `q=64` layers uniformly |
| 5 | Gross/passant exact CSS distance | 87 | proof-producing exact-distance optimization plus primal logical witness | free-cover homology, distance doubling, or a relative-weight theorem replacing branch-and-bound |
| 6 | C967 jet-quotient CSS family | 83 | exact checks/logicals/distance at `q=11,13` | family-level jet/relative-weight formula and a structural transversal-phase criterion |
| 7 | four-frame continuation exceptions `q=7,8,9,11` | 79 | certified graph automorphism groups and orbit representatives | taxonomy of the small-field extra automorphisms as exceptional field identities |
| 8 | odd-plane finite strategy bases, below C80 | 76 | rules-only strategy DAGs for the already computed fields | bounded projective reply packets usable as C80 base strata, not a table of moves |
| 9 | residual Legendre-pair multipliers at length 333 | 65 | SAT/CP nonexistence proofs for the five remaining multiplier cases | modular compression or orbit-lock lemmas; value is now confined to the Legendre route |
| 10 | exceptional parabolic deficit | 62 | exact root/parabolic incidence ranks across bounded ranks | a uniform deficit formula; lower priority because much of the surrounding ladder is classical |

C880 itself would rank with C80/C896, but is omitted from the table because it
is the source example rather than an “other problem.”

## The four certificate modalities

One common proof IR can support four front ends:

1. **Constraint core:** SAT, PB, MILP, and exact-cover constraints grouped by
   source theorem, orbit, cut type, or local packet.  C880 and C80 use this.
2. **Rank core:** rows grouped by generator, weight, digit/carry state, or
   geometric incidence type.  C896, C756's polynomial systems, and code
   reconstruction use this.
3. **Strategy core:** a game DAG grouped by boundary lemma, rank descent, reply
   packet, and exceptional root.  C80 and the finite Nofil bases use this.
4. **Orbit core:** exhaustive objects quotient by the actual semantic
   automorphism group, with invariant profiles and independently replayed orbit
   coverage.  C756, the continuation exceptions, and the `q=64` layers use
   this.

Every adapter should emit the same logical layers:

```text
source objects and hypotheses
semantic groups and automorphisms
machine certificate and replay
minimal/irredundant semantic core
near-miss or quotient classes
candidate source-language lemmas
independent implication certificates
small lemma DAG
```

The theorem miner is never trusted.  A learned predicate is a proposal until
the original model plus its negation is refuted by a proof-producing backend,
or a direct checker verifies its constructive witness.  Raw RAT clauses,
solver branch histories, classifier accuracy, and sampled orbit purity are not
theorems.

## First new modality: C896 semantic rank cores

The existing `q=9` C895 computation was deliberately used as a control because
its extra `L(2,0)` channel already has the human catalecticant-minor proof.  A
successful extractor should expose a small generator/equation core consistent
with that proof rather than merely repeat the nullity.

`semantic_rank_core.py` now supplies arithmetic-independent block ablation,
minimum full-rank block subsets, marginal rank loss, and a deterministic
independent-row basis.  `c896_q9_semantic_rank.py` binds it to the frozen
`F_9` computation without modifying that certified source.

For the unexpected `L(2,0)` source, the Hom system has 30 variables, rank 29,
and nullity one.  Its minimum full-rank generator cores are exactly

```text
u(1), u(a), Weyl
u(1), Weyl, torus
u(a), Weyl, torus
```

Removing Weyl from the complete system loses one rank; removing any other
single block loses none.  The deterministic equation basis has 29 rows: 20
from `u(1)`, four from `u(a)`, and five from Weyl.  The expected `L(0,2)` copy
has the same three minimum generator cores and the same nullity, with a
different 20/6/3 row split.

This identifies the source-language bridge: Weyl reversal is the essential
coupling, while either the second root direction or torus weights can complete
the positive-root recurrence.  It does **not** yet identify a carry theorem.
The `q=9` exceptional channel is the classical integral catalecticant summand;
the first genuinely new carry-state evidence must come from `q=25` and one
exponent-three field.

The next C896 adapter should avoid a dense generalization of the `q=9` script.
It should compile the coefficient equations (H4)--(H5) sparsely, label every
variable and row by:

```text
target digit state
source digit state
torus alias
incoming/outgoing carry
Weyl partner
```

Then exact sparse elimination can quotient states with identical future pivot
behaviour.  Stabilization across `q=9,25,p^3` would produce the candidate
finite automaton; a certified block order would turn that automaton into the
desired induction.

Replay from the repository root with:

```bash
PYTHONPATH=ergodis-private/python python3 -m unittest -v \
  test_semantic_rank_core test_c896_q9_semantic_rank
python3 notes/2026-08-09-c895-q9-hom-falsifier.py --check
```

The adapter refuses source drift from the frozen falsifier SHA-256
`782087ca2931c7438dca514010b65cb152d90df18cc27ae86822dde0fea20ab6`.

## Per-target extraction attacks

### C80

Compile each exchange to a bipartite graph from consumed ancestral labels to
new defect fibres.  Positive instances emit a matching plus strict support or
Omega descent; negative instances emit a minimum Hall-deficit set.  Quotient
deficit sets by projective transport and profile them by line pencil, causal
half-move, defect rank, and consumed-label multiplicity.  The theorem search is
then finite and adversarial: either no deficit orbit exists on the certified
domain, or its smallest orbit tells us exactly which packet type is missing.

The key compression is to seek a bounded *description* of the matching update,
not a bounded matching size.  Alternating forests, Dulmage--Mendelsohn blocks,
and transversal-matroid circuits are the semantic objects most likely to lift
to a projective theorem.

### C756

Treat each maximum coherent set and each failed extension as an orbit object.
Core extraction should distinguish spectral constraints, local triangle
counts, character moments, and the dual-3-net equations.  The decisive output
would be a small invariant separating all near-extremal cliques from size
`(q+3)/2`; merely certifying more fields has diminishing value.  The natural
candidate formats are a low-degree polynomial certificate, a local-to-global
clique inequality, or a finite list of forbidden coherent suborbits.

### Quantum distance

Pair every lower-bound proof with the minimum logical witness and project the
solver core onto cover sectors, relative-support strata, and homology classes.
If the same small sector core recurs across covers, conjecture a
`FreeCoverDistanceCertificate` and verify it independently.  This is likely to
replace far more search than micro-optimizing the backend.

### The `q=64` repair layers

Search in a representation closed under Frobenius and semilinear transport,
not raw coefficient tables.  Canonicalize all successful layers, interpolate
their coordinate functions, and ablate collision versus coverage identities.
The high-value outcome is a common symbolic template; a larger finite census
without a template is not progress on the infinite-family problem.

## Engineering order

1. Keep the current private C880 constraint provenance/core/slicer.
2. Land the generic rank-core layer and q9 control (done in this spike).
3. Add a matching/Hall adapter and run the known C80 one-to-many witness plus
   deterministic q11/q13 controls.
4. Add orbit blocking/canonicalization shared by C880, C756, and continuation
   exceptions.
5. Add independently certified candidate-lemma implication checks.
6. Only then add automated lemma generation and scoring.

Large matrices, orbit sets, and strategy traces stay out of memory where
possible.  Evidence is streamed; semantic IDs use fixed-width records and
compressed sorted sets/bitmaps selected from measured density.  Search hot
loops remain allocation-free.  Recursive proof or strategy traversal must be
lowered to an explicit stack before input-scaled use.

## Stop rules

- Stop a finite sweep when new instances add no new semantic state or orbit,
  not merely after an arbitrary field bound.
- Stop a candidate family after the first independently replayed opposite-label
  collision.
- Do not call a core structural if it is dominated by symmetry-breaking,
  auxiliary encoding, or solver-order artifacts.
- Do not promote a bounded classification to a uniform theorem without a
  proved induction, interpolation, or orbit-completeness step.
- Prefer one new certificate modality over a tenth adapter for the same SAT
  shape.

## Mystery ledger and EJ/TT closeout

- **Settled:** the C880 method is not SAT-specific; exact rank systems admit the
  same semantic ablation and core lifting.
- **Settled:** C896 is the best clean test for learned finite interface states,
  because carry/borrow behaviour is already the mathematical obstruction.
- **Found:** at `q=9`, Weyl is the only individually essential generator block
  for every nontrivial central-even source, while three interchangeable
  generator cores attain full rank.
- **Not mysterious:** the `L(2,0)` nullspace itself is classical and already
  structurally explained by catalecticant minors; the new result is the rank
  core, not rediscovery of that summand.
- **Open:** whether `q=25` introduces finitely many stable carry states or a
  state count growing with the field exponent.
- **Open:** whether C80 Hall-deficit orbits admit bounded projective
  descriptions; this is the highest-value next empirical question.

**EJ.** A successful C896 state quotient would provide the first literal
weighted-automaton/minimal-realization instance for the broader Ergodis thesis.
The same state minimizer could then act on sparse elimination fronts in coding,
modular representation theory, and polynomial identity systems.

**TT.** The main danger is optimizing certificate size instead of identifying
the invariant that makes the certificate inevitable.  Each campaign should
therefore alternate positive cores with deliberately generated near-misses,
ask which semantic distinction predicts extension to every future context,
and demand a source-language implication proof before accepting a learned
state merge.

Vibe: this is a real cross-domain programme now; C80 supplies the hard theorem,
and C896 supplies the cleanest test of whether Ergodis can discover the right
state rather than merely solve the finite instance.
