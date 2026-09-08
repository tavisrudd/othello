# C1127: critical assessment and response plan

**Lane**: `complete-ports`

**Date**: 2026-09-08

**Status**: assessment complete; manuscript revision pending.

## Scope and evidence

The user supplied a ChatGPT/Astra referee report on standalone commit
`b9bbf4de3365b138d1a4492cab2d1b4efe0ca4f4` and requested critical assessment
before planning the response. C1127 owns that response, ahead of C325 and C953.
This report records mathematical dispositions and implementation order; it
does not adopt the referee's grades or publication recommendation.

Read the relevant authoritative statements, proofs, examples, related-work
section, driver order, and paper style guide. The local standalone HEAD is
`b9bbf4d`; its confinement source agrees with the monorepo source. Also read
the referee-linked public confinement source:
https://raw.githubusercontent.com/tavisrudd/compositional-recovery/b9bbf4d/sections/03-positive-density.tex.
This is targeted source-level reasoning, not a new full correctness audit,
literature-priority audit, Lean run, or executable verification. No manuscript,
artifact, mirror, or publication changes were made in this assessment chunk.

## Critical assessment of required corrections

The six correction groups are supported by the inspected passages. Their
severity differs: contextual closure has an incomplete observation contract;
the tree certificate has an incomplete algorithm specification; the other
items concern quantifiers, resource accounting, or omitted hypotheses.
These findings do not by themselves refute the two-sector formula,
minimal-support transfer, or labelled composition proof.

### 2.1: confinement boundary — accept, highest priority

`thm:rank-one-contextual-state` and `cor:bounded-contextual-state` preserve
the target leaf and induced target image, but the earlier nonconfinement
definition refers to the target block. Applying that definition afresh to a
composite changes the boundary. Associativity alone does not identify these
observations.

The diagnostic is correct. In `(a,a,a,a,b,b,b,b)`, a normalized equation at
coordinate 1 leaves `{1,2}` with one helper, at coordinate 3. Leaving
`{1,2,3,4}` requires an even, nonempty contribution from coordinates 5--8,
hence at least two helpers there. Parity in coordinates 1--4 requires one
further helper. Coordinates 2,5,6 attain three. These are equation escape
costs; the three-helper example is not a new inclusion-minimal repair.

Preferred repair: state the narrower closure under evaluations against
composed outer contexts, fixing the confinement region as the entire original
inner leaf block. Identify leaf coordinates, target coordinates, and
normalization. Require the composed context to remain in the quantified family:
correct field linearity, at least two inner blocks, and surjective distinguished
projection. Explicitly exclude a congruence claim for freshly formed macroblock
escape summaries. Apply the same wording to the bounded quotient.

This retains the probe characterization and separator results. Introduce a
general region-indexed observable only if a manuscript use requires macroblock
observations; that would require rechecking the finite-probe claims, not just
adding an `R` to notation. It is outside the initial repair.

### 2.2: strict relative weights — accept

The sentence after the strict RGHW inequalities in
`sections/02-confinement-transfer.tex` invites an incorrect interpretation
about extending a prescribed target space. With helpers `(u+v,v)`, the best
line costs one and the full target space costs two, but the prescribed line
spanned by `u` already costs two. Strict dimension-wise minima need not imply
strict growth along each nested chain of requests.

Replace the explanation with: the optimal helper-union cost, minimized over
all recoverable target subspaces of each dimension, strictly increases with
dimension. No theorem change is needed.

### 2.3: predecessor storage — accept as accounting ambiguity

`prop:exact-hierarchical-optimizer` already selects one minimizing label and
predecessor per finite entry. Replace “when all witnesses are retained” with
“when one minimizing witness is retained for each finite table entry.”
The `O(NQ)` bound counts predecessor entries, not the bytes of coefficient
lifts. Storing all tied predecessor transitions can require the transition
count (`O(NQS)` here); expanding complete paths and local coefficient lifts
has additional output cost.

Support alternatives are a different output: they need not have minimum
cardinality and can become optimal under failures or repricing. The composition
theorem already correctly distinguishes numerical minima from full lift sets;
align the optimizer with it.

### 2.4: optimality certificate — accept; prefer a tree certificate

The edge-potential inequality is valid for the sequential DP `D_i(c)`. The
paragraph places it after the binary-tree width bound without defining a
sequentialization. That graph cannot simply inherit the tree's state bound.

Specify a tree certificate for `prop:boundary-width-compilation`: leaf
potentials lower-bound every admitted local choice at their states, and for
every legal combination,

`p_parent(s) <= p_left(s_L) + p_right(s_R)`.

Induction bounds every feasible realization below by the root potential;
a feasible root witness with matching cost proves optimality. Include exact
helper-count states for the support-budget variant. Complete local and
transition coverage and justified state restrictions remain necessary.
Infeasibility certification is separate from this finite-optimum statement.
Retain the path certificate only if explicitly attached to the earlier path DP.

### 2.5: finite outer-distance bound — accept, with qualifications

Write `a=d_e(C^perp)-e`, `d=d(C^perp)`, and `L0=a+d`. The sufficient
condition `d(O^perp) >= L0+1` is correct for the minimum over e-coordinate
identity-normalized target requests. Every nonzero sector costs at least
`d(O^perp)-1 >= L0`; every zero-sector cost is at least `L0`; an
information-set target attaining `a` attains `L0`. Require at least two outer
blocks and the applicable represented-encoder and projection hypotheses.
Unrecoverable target sets have infinite zero-sector cost and cause no problem
for this minimum argument.

Preserve three qualifications:

1. Equality permits a nonzero-sector tie. This condition proves the minimum
   value, not absence of nonzero-sector optimizers. Strict exclusion at that
   value follows from `d(O^perp) >= L0+2`, if that assertion is wanted.
2. Collapse for each individual recoverable e-set has a sufficient uniform
   bound using `max_P kappa_C(P)+d+1` over that family. To say every e-set,
   assume every e-set recoverable. The best-target minimum is weaker.
3. Preserve the proof's distinction between identity normalization on `F_q^P`
   and `U=im G_P` when target columns are dependent. A zero target image
   does not permit replacing the nonzero identity parameter space by zero in
   the external-perturbation argument.

### 2.6: boundary conventions — accept both

Restate `0 != T <= W_P` in `thm:objectwise-confinement`. The zero space
has no nonzero linear map for attaching the external dual word.

At `eq:singleton-threshold`, require a nonzero, helper-recoverable coordinate.
For `(e1 | e2,e2)`, the target column is nonzero but `W_P=0`, so standard
`M_1` is not defined. Prefer an explicit recoverability hypothesis to creating
an out-of-range RGHW convention solely for this formula. An optional sentence
can state infinite local recovery cost in the unrecoverable case.

## Selective disposition of ranked suggestions

The request for selectivity conflicts with adding every suggestion as a new
body section. Correctness comes first; examples and tables should replace
fragmented explanation. A new general contextual framework or benchmark
programme would work against the requested revision.

| Suggestion | Decision and gate |
| --- | --- |
| Define the observable first | Required: original leaf region, target set, normalization, context family, and scalar response must be explicit. No implied preservation of arbitrary prices, supports, or new macroblock boundaries. |
| Complete multilevel example | High value: extend an existing small example through two actual composition levels, including intermediate target/functional labels, local costs, selected outer labels, reconstructed coefficients, and a failure or price update that changes a choice. Repeated discussion of one local block is insufficient. |
| Theorem-specific novelty table | Replace overlapping related-work prose with main theorem labels, established inputs, and additional recovery conclusions. Foreground reverse control and compositional data. Reuse verified attributions; stronger priority claims need their own literature audit. |
| Shorter main route and notation table | Stage after repairs: recovery model, equation/minimal-support transfer, labelled composition, complete example. Keep contextual minimization, MDS, and geometry secondary. Preserve labels and proof dependencies; render before promising a page count. |
| Economical interface construction | Bounded attempt: a recognizable bounded-overlap family with explicit local-table construction, and total compilation-plus-DP comparison against ambient-syndrome enumeration. Opaque compilation or a disconnected toy is insufficient. If unsuccessful, retain the conditional theorem and report the limit. Engine benchmarks stay Ergodis-owned. |
| Explicit separation instances | Supporting work: common prime and generator matrices for the reliability pair; extension polynomial, basis/trace pairing, multiplier, and outer dual for Singer. Singer already fixes `(q,k,n)=(5,3,5)` and lives in `03-positive-density.tex`, not the referee's cited separation section. Preserve the general existence proofs. |

The reliability simplification follows directly by subtracting the displayed
polynomials: `s^6-3s^7+3s^8-s^9 = s^6(1-s)^3`. Add strict ordering for
`0<s<1`, explicitly for radius-three repair with independent homogeneous
helper survival. This does not establish pointwise success dominance,
arbitrary heterogeneous-availability dominance, or unrestricted-radius ordering.

## Implementation sequence and acceptance gates

1. **Contract and local repairs.** Rewrite both contextual closure statements
   at fixed leaf boundary; repair the RGHW sentence, predecessor accounting,
   tree certificate, distance hypothesis, and boundary conventions. Add the
   reliability factorization. Audit downstream references to changed semantic
   labels against the diagnostic examples before changing section order.
2. **Example and contribution accounting.** Complete the two-level calculation
   before expanding prose. Use the notation table to distinguish physical
   coordinates, target images, quotient labels, and outer functionals. Replace
   duplicated explanation with this calculation and the contribution table.
3. **Supporting work and hierarchy.** Attempt the economical family and explicit
   instances within scope. Move secondary material only after dependency review.
   Retain complete proofs and hypotheses; page growth must buy comprehension.
4. **Validation and disposition.** Read formal-annotation conventions before
   changing claim/evidence maps. Run the paper's deterministic `make check`
   through the prescribed quiet entry; inspect changed rendered pages and
   references and audit introduction/conclusion claims. Before computed examples,
   follow research-reproducibility conventions and commit generators, inputs,
   report, and compact certificates atomically. Examples must not become proof
   dependencies of general theorems. No Lean run is needed for these human-proof
   repairs. Read export conventions before later authorized local mirror sync.
   No push, deposit, or submission.

C1127 closes when mandatory findings have verified dispositions, the complete
example and contribution accounting are integrated, optional work has explicit
outcomes, and the manuscript passes scoped checks. C325 retains consolidated
executable verification; C953 retains the aggregate fresh referee/export gate.
This supplied report replaces neither gate. C955 remains after C953.

## ej + tt closeout and mystery ledger

After the assessment gate, the explicit ej + tt pass checked what a superficial
repair could miss. Three cheap gains are included above: distinguish an optimum
value from exclusion of ties; preserve coordinate identity requests when their
target image loses rank; and qualify homogeneous reliability ordering. These
are task-owned refinements, not new work lanes.

No genuine mathematical mystery was established by this targeted assessment.
Remaining gaps are concrete: source rewrite and downstream audit of contextual
closure; construction of the multilevel example and economical family; and
evidence bundles for explicit finite realizations. C1127 owns these bounded
attempts, with C325 owning consolidated replay. No incidental discovery-track
entry is warranted.

## Assessment-chunk validation

The allocator ledger was committed before using C1127. This chunk changes only
the task report, exact live queue row, and handoff routing. Exact row uniqueness,
lane peg, report linkage, next-step routing, and `git diff --check` passed.
Scoped status confirmed no manuscript changes. No manuscript rebuild was run.
