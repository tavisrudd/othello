# Independent attack portfolio for the adjacent problems

**Assessment date:** 2026-07-31

This file deliberately drops the requirement that a project originate in the
repository's current results.  It asks instead: where is there a sharply posed
open case, a plausible technical lever, and a short experiment that can kill a
bad direction before a large investment?

The ratings are research-planning judgments, not probability claims.

## Ranked starting points

| Rank | Project | Why it may move | First decisive experiment | Stop or redirect if |
|---:|---|---|---|---|
| 1 | Hadamard 668: remaining common-multiplier Legendre cases | Only nine of 30 structured subgroup cases remain after the July 2026 result; exact compression and proof certificates already work | Independently reproduce one excluded and one surviving case, then benchmark canonical orbit enumeration and PB-SAT on all nine | the surviving cases lose all useful compression and exceed projected certificate/storage limits |
| 2 | Exact `M(18)` | The gap is only `57--59`; the problem has a finite Seidel-spectral formulation and recent upper-bound machinery | Regenerate every feasible 58/59-line spectrum and automatically apply interlacing, Jacobi/complement and exact arithmetic filters | candidate families remain too numerous without a new structural lemma |
| 3 | Order-12 planes with prescribed symmetry | Full order 12 is enormous, but automorphism/polarity/oval subclasses admit canonical SAT encodings and checkable certificates | Select one published-unresolved automorphism class, reproduce counts independently, and estimate cube/certificate volume | the class is already settled, or symmetry reduction still leaves an unrestricted-scale instance |
| 4 | Exact transversal groups of short qLDPC codes | Finite symplectic constraints and circuit action can be enumerated exactly; useful irrespective of the asymptotic theorem | Enumerate all inequivalent small CSS check pairs under a fixed length/check-weight cap and certify logical hierarchy level | every candidate collapses to a known no-go family without exposing a new invariant |
| 5 | Fixed-parameter MDS/arc cases | Canonical augmentation and determinant constraints can settle isolated unknown parameters with proof objects | Build a current table of genuinely open `(q,k,n)` cases, then reproduce one known boundary classification | no unsettled parameter remains within feasible orbit counts |
| 6 | Upgrade almost-good transversal qLDPC to linear distance | The 2026 cupcap construction supplies the gate and bounded checks; distance is the missing asymptotic parameter | Isolate the exact logarithmic loss and test whether known systolic amplification/covering products preserve the cupcap form | every distance amplification destroys transversality or bounded check weight |

Ranks 1--3 are the best chances for a finite, independently verifiable advance.
Rank 6 has the largest conceptual payoff and the highest risk.

## 1. Hadamard order 668

### Solve target

Construct a Hadamard matrix of order 668.  A Legendre pair of length 333 is a
sufficient construction, not a necessary one.

### Primary route

- Reproduce the mod-3 compression and 30-subgroup classification.
- For the nine surviving common-multiplier subgroups, combine orbit sums,
  row-sum congruences and exact power-spectral-density constraints.
- Use meet-in-the-middle on compressed autocorrelation signatures rather than
  raw sequences.
- Translate terminal exclusions to pseudo-Boolean instances and retain
  DRAT/LRAT or direct arithmetic certificates.
- Search for a witness before proving nonexistence; either outcome is useful.

### Alternative route

Run a parallel structured search through Goethals--Seidel supplementary
difference sets, Williamson-type arrays and other constructions implemented in
the Hadamard database.  Each ansatz needs its own completeness statement.
Failure of all searched ansatzes is not nonexistence of order 668.

A non-enumerative alternative is to move the compressed autocorrelation
equations into the integral group ring and cyclotomic integers.  Ideal
factorization, local norm obstructions and reductions modulo carefully chosen
prime ideals may rule out multiplier classes in one stroke.  The first test is
whether these obstructions reproduce an already certified exclusion.

### Near-term deliverable

A complete, independently replayable disposition of the nine remaining
common-multiplier cases.  This would be a legitimate advance even if all nine
are excluded and order 668 remains open.

## 2. Exact equiangular lines in dimension 18

### Solve target

Decide whether `M(18)` is 57, 58 or 59.

### Primary route

- Use algebraic-integer and rank constraints to enumerate possible Seidel
  characteristic polynomials for 58 and 59 lines.
- Apply principal-submatrix interlacing and the Jacobi identity to force
  spectra of complementary subgraphs.
- Convert surviving spectra into graph degree/equitable-partition constraints.
- Use canonical augmentation and exact SDP/ILP certificates for the residual
  graph-existence questions.
- Independently verify every spectral factorization and solver certificate.

### Alternative route

Classify lattice embeddings of candidate angle-`1/5` systems, extending the
recent `A_9 + A_9 + A_1` analysis.  A lattice discriminant or glue obstruction
could eliminate an entire spectral family without graph enumeration.

Because any hypothetical 58- or 59-line set is far above the elementary linear
range, first force the allowable common angles using the standard integrality
theorems.  This avoids running a graph search for an angle that the cardinality
already excludes.

### Near-term deliverable

A machine-readable census of feasible 58/59-line spectra with the reason each
candidate dies or survives.  This is useful even before the last case closes.

## 3. Restricted order-12 projective planes

### Solve target

Prove nonexistence of a previously open, explicitly defined class of order-12
planes—for example one admitting a chosen automorphism type, polarity, oval or
subplane.

### Primary route

- Encode the `157 x 157` incidence constraints only after fixing a canonical
  seed forced by the structural hypothesis.
- Use nauty-style canonical labeling to prevent isomorphic branches.
- Split the search into cubes with independently recorded coverage.
- Produce proof objects that a small checker can validate without trusting the
  search program.

### Alternative route

Derive modular rank, Smith-normal-form, character or lattice constraints on the
incidence matrix before SAT.  Even a weak new invariant may eliminate whole
automorphism classes and shrink certificates dramatically.

There is also a representation-choice question: incidence matrices may be a
poor search space.  Exact-cover formulations, orbit incidence tensors, or
continuation complexes can have lower effective entropy.  Benchmark them on a
known plane and on an already excluded small order before committing to 12.

### Near-term deliverable

First build a status table of structured order-12 classes.  The worst failure
mode would be spending months certifying a case already eliminated in older
finite-geometry literature.

## 4. Short qLDPC codes with exact transversal gates

### Solve target

Find and classify small bounded-check-weight stabilizer codes with a useful
non-Clifford transversal logical gate, explicit syndrome extraction and a
credible decoder.

### Primary route

- Enumerate CSS chain complexes under length, degree and rate caps.
- Express a candidate diagonal gate through divisibility/triorthogonality or a
  higher multilinear form.
- Quotient by coordinate permutation and local Clifford equivalence.
- Compute the exact logical action and full transversal group, not merely
  exhibit one gate.
- Rank candidates by pseudo-threshold and decoder performance.

### Why this matters

It does not solve the asymptotic qLDPC problem, but it can yield practical code
gadgets and reveal the local motifs an asymptotic construction should preserve.

## 5. Fixed MDS/arc cases

### Solve target

Close an actually open finite parameter of the linear MDS conjecture or
classify the extremal arcs in that parameter.

### Primary route

- Refresh the parameter table from primary coding/finite-geometry sources.
- Normalize a projective frame and enumerate columns by canonical extension.
- Prune with determinant nonvanishing, tangent-function and polynomial
  identities before isomorphism testing.
- Emit a classification certificate or independently checkable exhaustive
  log.

### Conceptual route

Seek a new determinant identity for tangent functions of arcs.  A theorem
covering an infinite characteristic/dimension range would matter far more than
isolated enumeration, but the finite census is a good lemma-discovery engine.

## 6. Fully good qLDPC codes with transversal non-Clifford gates

### Solve target

Construct a family with bounded check weight, `k=Theta(n)`, `d=Theta(n)` and a
nontrivial transversal non-Clifford logical operation.

### Primary route

The 2026 cupcap construction already preserves bounded checks, linear rate and
the gate while losing polylogarithms in distance.  Locate the precise geometric
source of that loss.  Test systolic amplification, high-dimensional expander
covers and balanced products for preservation of the multilinear cupcap form.

### Alternative route

Start with multiplication-friendly algebraic-geometry codes and force sparse
checks through Tannerization or lifted products.  The key theorem would show
that the trilinear form implementing CCZ survives sparsification and retains
nontrivial logical support.

The dual route is an impossibility theorem: combine expansion or local
testability with cleaning/correctability arguments to bound the logical level
of any transversal gate.  A sharp no-go under identifiable hypotheses could
explain why the polylogarithmic distance loss is structural rather than a flaw
of the current construction.

### Reality check

This is a field-level problem, not a routine construction exercise.  A useful
first paper could instead prove a conditional preservation theorem or a no-go
for one amplification scheme.

## Project-selection rule

Start with a two-week reproduction phase.  A project graduates only if it has:

1. a verified open status and exact parameter statement;
2. a reproducible baseline from the best current paper;
3. an invariant or compression absent from that baseline;
4. a certificate format for negative computational conclusions.

This prevents the broad fame of the parent problem from substituting for a
credible research plan.

## `ej` + `tt` pressure test

The closeout asked two additional questions: what extra leverage has not yet
been squeezed from the reductions, and what would a skeptical generalist demand
before believing the programme can scale?

- **Track entropy, not just variable count.**  Before a SAT/enumeration project,
  measure orbit counts after every invariant on a solved benchmark.  A proposed
  reduction that removes equations but not isomorphism classes is cosmetic.
- **Keep reductions bidirectional.**  A spectrum, Legendre pair or structured
  plane class is often only necessary or sufficient for the parent problem.
  Every computational conclusion must state which direction was proved.
- **Search for one global invariant before more compute.**  Group-ring norms
  for Legendre pairs, discriminant/glue constraints for equiangular lines, and
  modular incidence invariants for planes are the best candidates for killing
  exponentially many branches at once.
- **Design the negative certificate first.**  If a search cannot say how an
  independent checker will validate completeness, it is not ready to run.
- **Prefer a theorem extracted from failed search.**  The best outcome of a
  census is often a reusable forbidden spectrum, multiplier obstruction or
  preservation/no-go lemma, rather than a larger table.

## Mystery ledger

| Mystery | Status after closeout | Exact next discriminator |
|---|---|---|
| Why did the PRS/MDS comparison initially look stronger? | **Settled.** Both use rational-normal-curve geometry, but the local radius is `r-1`, where the MDS-extension dictionary fails. | None; keep as a wording guardrail. |
| Can a continuation complex recognize Desarguesianity intrinsically? | **Open.** Reconstruction alone does not. | Compute candidate link/association-scheme invariants on Desarguesian and known non-Desarguesian planes of the same prime-power order. |
| Does the Golden conference factor hide an order-growing operation? | **Open but unsupported.** The order-14/18 work analyzes existing Paley matrices rather than constructing them. | Define a candidate operation and test the conference equation symbolically at the next two orders. |
| Is the length-333 Legendre route equivalent to Hadamard order 668? | **Settled negative.** It is sufficient, not necessary. | Label every future exclusion as ansatz-specific. |
| Why are dimensions 18--20 the first equiangular gaps? | **Partly settled.** Known constructions and spectral/integrality bounds squeeze them, but no uniform rigidity theorem closes the residual cases. | Produce the complete feasible-spectrum census for 58/59 lines in dimension 18. |
| Is the qLDPC distance loss technical or forced by the gate? | **Open and central.** | Test whether one distance-amplification product preserves the cupcap logical form; in parallel formulate a conditional no-go theorem. |
