# Ergodis certificate-to-theorem portfolio

**Date:** 2026-08-30

## Decision

The C880 extraction should become a general private Ergodis research layer,
not a SAT-only utility.  Its job is to convert exact finite evidence into the
smallest semantic obstruction visible in the source problem, then support a
counterexample-guided search for a structural lemma whose implication is
independently certified.

The best immediate portfolio targets are C80, C896, and the PRS carrier
programme around C973.  C80 has the highest mathematical payoff and the
richest existing exact corpus.  C896 is the best second *modality*: its
certificates are finite-field rank computations rather than CNF refutations,
and its desired general theorem is explicitly a finite carry/borrow state
machine.  C973 is the strongest code-facing bridge: its digit-stripping
modules, pointed locator certificates, and switch witnesses already expose the
same state/minimal-realization problem in a second mathematical language.  A
first C896 rank-core adapter and a first C973 orbit-core adapter are now
implemented.

## Ranked targets

Scores combine theorem value, existing exact evidence, likely semantic
compression, tractable next computation, and reuse of the resulting adapter.
They are prioritization judgments, not novelty grades.

| rank | problem | grade | search and certificate | structural extraction target |
|---:|---|---:|---|---|
| 1 | C80 global residual rematching | 96 | exact matching/flow instances; positive matching witnesses or negative Hall cuts; existing survivor DAG replay | projective Hall-rematching lemma with strict support descent and opponent completeness |
| 2 | C896 corrected finite-group socle | 94 | exact sparse Hom matrices over `GF(q)` with rank/PLU certificates at `q=9,25` and exponent three | minimal carry/borrow automaton and a block-triangular most-significant-digit induction |
| 3 | C973 PRS carrier/nucleus saturation | 93 | exact pointed locator and switch certificates, orbit quotients, digit-stripping modules | a translation-invariant switch lemma and a finite carry-state lifting theorem making the GF(27) sweep and one-carry cases corollaries |
| 4 | C756 saturated-internal coherence | 90 | maximum-clique/nonexistence certificates in the `AGL(1,q)` Cayley graph; existing census through `q<=127` and `q=169` | character/polynomial or dual-3-net lemma improving the ratio bound by the missing 25 percent |
| 5 | square-root conic-arc repair layers | 88 | synthesize and certify nonlinear coefficient layers; exact collision and coverage replay | semilinear orbit normal form or interpolation theorem explaining the twelve `q=64` layers uniformly |
| 6 | Gross/passant exact CSS distance | 87 | proof-producing exact-distance optimization plus primal logical witness | free-cover homology, distance doubling, or a relative-weight theorem replacing branch-and-bound |
| 7 | C967 jet-quotient CSS family | 83 | exact checks/logicals/distance at `q=11,13` | family-level jet/relative-weight formula and a structural transversal-phase criterion |
| 8 | four-frame continuation exceptions `q=7,8,9,11` | 79 | certified graph automorphism groups and orbit representatives | taxonomy of the small-field extra automorphisms as exceptional field identities |
| 9 | odd-plane finite strategy bases, below C80 | 76 | rules-only strategy DAGs for the already computed fields | bounded projective reply packets usable as C80 base strata, not a table of moves |
| 10 | residual Legendre-pair multipliers at length 333 | 65 | SAT/CP nonexistence proofs for the five remaining multiplier cases | modular compression or orbit-lock lemmas; value is now confined to the Legendre route |
| 11 | exceptional parabolic deficit | 62 | exact root/parabolic incidence ranks across bounded ranks | a uniform deficit formula; lower priority because much of the surrounding ladder is classical |

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

The generic Hall decision layer is now landed as a Rust private primitive.
`HallWorkspace` accepts caller-owned CSR restriction edges and reuses all
matching, queue, visitation, and certificate storage across solves.  It emits
either a left-saturating matching or the exact alternating-reachable deficient
left set and its neighborhood.  The solve path allocates nothing after
workspace construction.  Exhaustive comparison with brute force passes on all
65,536 bipartite graphs of size `4 x 4`, alongside repeated-capacity and
malformed-graph tests.  This removes matching mechanics as a risk; it does not
define or validate C80's projective charge edge.

The first edge proposal now passes the frozen `q=11` one-to-many falsifier.
Define the **ancestral-secant edge** by

```text
new defect z -- consumed old label ell
iff line(z,ell) contains a pre-exchange selected point.
```

This is projectively natural and uses only bounded incidence data.  On the
witness its two new defects have degrees three and two in a seven-label graph.
The exact Hall core returns the distinct assignment

```text
(0,5) -> (4,10), carried by ancestral point (10,1)
(6,5) -> (3,7),  carried by ancestral point (5,2).
```

Thus it avoids the shared causal reply `(7,10)` that killed one-label
transport.  This is a useful candidate, not a C80 theorem: no charge-transport
soundness lemma has been proved for the edge.  It does pass the three frozen q23 replacement classes:
their single new fibres have 15, 10, and 14 ancestral-secant choices.  Those
are strong coverage checks but not nontrivial subset-Hall tests.  The graph,
semantic manifest, and matching certificate are in `ergodis-private/evidence/`
under the prefix `c80-q11-ancestral-secant-hall-`.

Replay the independent certificate check with:

```bash
PYTHONPATH=ergodis-private/python python3 \
  ergodis-private/python/verify_hall_certificate.py \
  --graph ergodis-private/evidence/c80-q11-ancestral-secant-hall-graph.json \
  --certificate ergodis-private/evidence/c80-q11-ancestral-secant-hall-certificate.json
python3 rust/scripts/c80_causal_one_to_many.py --check
```

The graph, semantic manifest, and certificate SHA-256 values are respectively
`16fc9151242b959952d8cd5698d52120bb46b268047efb0638df2f03201a8960`,
`e925b55682c885ddb6fc6579e02b83ae8af399fe925a6ea1a4fa97dcfd2f8000`, and
`23d3830e4b0b0f47c5407462e4580be60d8e1c5101baa9ce0ae5cc10f53e4e1b`.

The deterministic controls reveal the necessary quantifier boundary.  On all
complete raw exchanges, q11 has 1,266 Hall failures among 6,652 exchanges that
create defects, while q13 has none among 31,584.  Those raw graphs include
successors that are irrelevant to P's existential reply.  Restricting to
actual `K_Omega`-certified replies removes the apparent contradiction: the
q11 sample has no certified reply that creates a genuinely new defect; the
q13 sample has 596 such replies, all with positive degree and all Hall
saturated.  The frozen q11 one-to-many witness is therefore a relation
falsifier, not itself an admitted P successor.  Future theorem statements must
quantify over the certified reply predicate, not every complete exchange.

### C973 / projective Reed--Solomon

The GF(27) switch sweep is a high-value orbit-core control.  Its global minimum
is 78 good candidates, attained on 27 translated extremal syndromes.  For the
normalized `e_3` fibre, the 78 explicit nine-point witnesses first compress to
three nonzero-scalar orbits of size 26, one for each conjugate plane label
`l1,l2,l3`.  Those three representatives are themselves a three-cycle under
field Frobenius.  Hence all 78 witnesses form one semilinear orbit.  The
independent adapter rebuilds `GF(27)`, checks that every support gives a monic
split locator with `g_2=g_3=0`, and verifies complete torus and Frobenius orbit
coverage.  The exact semantic certificate is therefore one seed plus
equivariance, a 78-fold compression rather than a fitted statistical pattern.

This sharpens the structural target.  Verify one seed identity, prove
semilinear equivariance, then prove that translation reduces every extremal
syndrome to the normalized fibre.  That would turn the worst 27-by-78 portion
of the finite certificate into one small lemma packet.  The remaining step is
the uniform lower bound away from the extremal orbit; the existing split and
collision ledgers suggest a character-sum inequality rather than another
census.

The translation claim is now extracted exactly rather than inferred from a
27-row display.  A reusable finite-field parametric-core fitter finds, and an
independent set-equality check verifies, that the 27 and only 27 minimum rows
are

```text
(z2,...,z8) = (0,1,t,t^2,-t^3,-t^4,-t^5),  t in GF(27).
```

Thus the entire worst-case certificate has two generators: one parametric
syndrome curve and one semilinear locator seed.  The proof-extraction question
is no longer “why did 2,106 witness pairs work?” but “which unipotent action
produces this curve, and why does it transport the seed?”

The first half of that question is now closed structurally.  In the correct
degree-ten divided-power action,

```text
e_3 -> sum_{i=3}^8 binom(i,3) t^(i-3) e_i.
```

Lucas reduction modulo three gives the coefficient row
`1,1,1,-1,-1,-1`, exactly the extracted curve.  Therefore the 27 minimizers
are the upper-unipotent orbit of `e_3` by a direct classical module identity;
the finite list is a corollary.  This orbit fact was already stated in the
C973 checkpoint, so the mathematical value here is independent extraction and
proof recovery, not a novelty claim.  What remains genuinely useful is that
the 78 locators over the normalized fibre reduce to one semilinear seed.

That seed is itself source-readable.  It starts with the additive plane
`<1,12>_F3`, whose locator is the linearized polynomial
`X^9+22X^3+16X`, removes `24,26`, and inserts `3,19`.  The resulting locator
has coefficient vector

```text
(g0,...,g9) = (0,21,0,0,2,4,9,13,19,1),
```

so the required `g2=g3=0` identity is immediate.  Consequently the complete
extremal packet reduces to one additive-plane two-point-switch computation,
divided-power translation, scalar transport, and Frobenius transport.  This
is the desired certificate-to-lemma shape; none of the 2,106 finite witness
pairs is logically primitive.

The broader PRS route is digit-first rather than field-first: compile each
carrier extension into kernel state, quotient `E tensor E^(1)` orbit type,
extension-leakage cocycle, marker/root exclusions, and switch margin.  If this
state stabilizes for successive digits, the classical one-carry divided-power
module theorem and the fixed GF(27) closure become corollaries of a general
finite-state carrier-lifting theorem.

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
3. Bind the completed matching/Hall core to a projectively defined C80 charge
   edge, then run the known one-to-many witness and deterministic q11/q13
   controls.
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
- **Settled engineering:** exact matching and deficient-set extraction are
  reusable, allocation-free after sizing, and exhaustively checked through
  `4 x 4`; C80's missing datum is now solely the sound edge relation.
- **Found, not proved:** the ancestral-secant edge passes the exact q11
  one-to-many witness with a noncausal two-label matching and has degrees 15,
  10, and 14 on the three frozen q23 types.  Its soundness and full-corpus
  multi-defect Hall behaviour are the immediate falsification gates.
- **Settled:** raw q11 Hall failures do not refute the P strategy because none
  of the sampled certified q11 replies creates a genuinely new defect; q13 has
  596 such certified replies and all satisfy Hall.
- **Found:** the PRS `e_3` extremal switch certificate has exact semantic size
  one after semilinear quotient: three torus orbits are a Frobenius cycle, a
  78-fold reduction with independent replay.
- **Open:** whether the source unipotent action plus the one semilinear seed
  proves all 27 extremal fibres, and whether the nonextremal margin admits one uniform
  character-sum bound.
- **Settled structurally:** the 27 extremal fibres are exactly the monomial
  curve `(0,1,t,t^2,-t^3,-t^4,-t^5)`, and this is the classical
  divided-power translation orbit of `e_3` by Lucas reduction.

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

Vibe: this is a real cross-domain programme now; C80 supplies the hard game
theorem, while C896 and PRS supply two independent tests of whether Ergodis can
discover the right carry/orbit state rather than merely solve a finite instance.
