# The ergodis shape classifier

This page states which instance shapes ergodis compiles today and which it does
not yet compile, and it records the predictions of the negative-control
benchmark tier, fixed before those measurements were taken. It is a checklist a
third party can apply mechanically to an instance to decide which side of the
current compiler frontier that instance falls on.

The frontier is a description of the software as it stands, not a claim about
where the approach can reach. Shapes in section 2 are absorption candidates:
each one names the mechanism that would have to be built for the compiler to
reach it, in the same way that the zero-suppressed decision diagram and belief-
propagation ordered-statistics decoding imports absorbed shapes that earlier
versions did not compile. The classifier is not complete, and passing it is not
a guarantee of a win.

Abbreviations used below. CP-SAT is the constraint-programming Boolean
satisfiability solver of Google OR-Tools. LP is linear programming. DP is
dynamic programming. RSS is resident set size.

## 1. Shapes ergodis compiles today

An instance is *ergodis-shaped* when all of C1 through C3 hold and at least two
of C4 through C6 hold.

- **C1 Finite discrete domain.** Every decision variable ranges over a finite
  set of labels, and the objective and constraints are exact integer or
  finite-field quantities. No continuous variable appears, and no rounding or
  tolerance is part of the answer.
- **C2 Compact sufficient state.** There is a state summary of a partial
  assignment, of size bounded independently of the number of remaining
  decisions, such that two partial assignments with the same summary are
  interchangeable for every completion. Typical summaries are a residual
  capacity vector, a syndrome, a linear span, an orbit representative, or a
  multiset of loads.
- **C3 Decomposable minimum-sum or feasibility objective.** The objective is a
  sum, maximum, or Boolean combination over blocks that composes with the state
  summary of C2, so that an exact dynamic program or frontier search over the
  summaries is correct.
- **C4 Repeated interface.** The instance repeats a small interface through
  many blocks, levels, or demands, so that a large raw model collapses to a
  small number of distinct types. Test: the number of distinct
  (option-load, cost) records is small relative to the number of decisions.
- **C5 Linear conservation law, group symmetry, or finite-field labels.**
  Constraints are linear over the integers or a finite field, or a group acts
  on the instance so that a quotient of the search is exact, or labels carry
  finite-field arithmetic that the compiler can exploit.
- **C6 Reconstructible coefficient blocks.** The witness is rebuildable from
  compiled per-block tables, so the answer can be streamed instead of
  materialized.

## 2. Shapes ergodis does not yet compile

Any single one of the following places the instance on the far side of the
current frontier. Each entry names the mechanism that would absorb it.

- **N1 Arbitrary side constraints.** Constraints that do not compose with the
  state summary of C2 — pairwise incompatibilities, calendars, precedence with
  arbitrary lags — and that would have to be absorbed by expanding the state.
  *To absorb:* a side-constraint layer that either folds a constraint into the
  state summary when it is decomposable or falls back to a clause store
  consulted at frontier expansion, in the manner of lazy clause generation.
- **N2 Strong LP relaxations and continuous variables.** When the natural
  relaxation is tight or near-tight, branch and bound prunes with a bound the
  exact frontier search currently has no analogue of.
  *To absorb:* a dual bound computed on the compiled model — a Lagrangian or
  surrogate relaxation of the capacity rows — used to prune frontier states,
  which is the one structural piece the current frontier search lacks.
- **N3 State that scales with numeric magnitude rather than structure.**
  Coefficients are large, generic, and all distinct, so the exact state space
  grows with the magnitude of the data. A pseudo-polynomial DP width is the
  symptom.
  *To absorb:* residue-class or Chinese-remainder splitting of the sum axis, or
  a meet-in-the-middle split of the item set, both of which the crate already
  uses in other kernels but not in the bounded subset-sum compiler.
- **N4 Approximate answers are adequate.** Where a heuristic answer is
  acceptable, exact certification is not being paid for. *To absorb:* an
  anytime mode that emits an incumbent plus a bound rather than only an exact
  optimum.
- **N5 Quantity outside the finite support-cost model.** Bandwidth,
  subpacketization, timing. *To absorb:* a second cost model, which is a
  modelling change rather than a solver change.

## 3. Mechanical checklist

Apply in order and record the answers. An instance is on the *compiles today*
side only if steps 1 through 3 are all "yes", step 4 is "no" for every entry,
and step 5 counts at least two.

1. Are all variables finite and discrete, and is the required answer exact?
   (C1)
2. Write down the intended state summary. Is its size bounded by the instance's
   structural parameters — number of resources, code length, field order — and
   not by the numeric magnitude of the coefficients? (C2, and the contrapositive
   of N3)
3. Does the objective decompose as a sum, maximum, or Boolean combination over
   the blocks the state summary separates? (C3)
4. Is any of N1, N2, N4, N5 present? Specifically: are there constraints the
   state summary cannot absorb; is the LP relaxation of the natural integer
   model tight or near-tight; is an approximate answer acceptable; is the
   requested quantity outside the support-cost model?
5. Count how many of C4, C5, C6 hold.

Step 2 is the load-bearing test and the one most often answered wrongly. A
bounded subset-sum or knapsack instance passes steps 1 and 3 and fails step 2
whenever the DP width is the arithmetic range of the weights: the state is
compact in the code, not in the instance.

## 4. Predeclared predictions

The table was fixed before the negative-control tier was run. Every row is run
on both sides with the paired-round protocol documented in `BENCHMARKS.md`. The
control is single-worker CP-SAT from OR-Tools 9.14, which the existing benchmark
infrastructure already carries; no new solver dependency is introduced.

Two kernels carry all six rows on purpose. Placing wins and losses on the same
kernel isolates the classifier's decision rather than the implementation: the
bounded subset-sum kernel wins when the weights have a repeated interface and
loses when they are generic and large, and the weighted repair scheduler wins
when the load vectors are graded and low-dimensional and loses when they are
high-dimensional and generic.

| row | instance | kernel | classifier verdict | deciding tests | control | predicted direction |
| :-- | :------- | :----- | :----------------- | :------------- | :------ | :------------------ |
| L1 | bounded subset-sum feasibility, 60 items, generic weights in 1..32,000, attainable target | bounded subset sum | not yet compiled well | fails step 2 (N3): the state is the arithmetic range, not the structure | CP-SAT, exact-equality integer model | ergodis loses |
| L2 | weighted repair scheduling, 6 resources, 18 demands, 4 options each, independent random loads in 1..9, capacity 40, no grading | weighted repair scheduler | not yet compiled well | fails step 2 (N3) and step 5: the Pareto frontier is the state and grows with the load range | CP-SAT, one-hot options with resource capacities | ergodis loses |
| L3 | bounded subset-sum feasibility, 40 items, weights in 1..200,000 | bounded subset sum | not yet compiled | fails step 2 (N3) one magnitude beyond L1 | CP-SAT, exact-equality integer model | ergodis loses; the declared-bounds refusal is the exact boundary and is reported as such |
| W1 | bounded subset-sum feasibility, 60 items drawn from 6 distinct small weights, attainable target | bounded subset sum | compiles today | steps 1-3 yes; C4 repeated interface and C6 reconstructible witness | CP-SAT, exact-equality integer model | ergodis wins |
| W2 | weighted repair scheduling, 400 demands, 2 resources, every option of common weighted mass 6 under weights (1,2), capacity 120 | weighted repair scheduler | compiles today | steps 1-3 yes; C4 repeated interface and C5 the equal-mass conservation law, which yields a verified positive grading | CP-SAT, one-hot options with resource capacities | ergodis wins |
| W3 | weighted repair scheduling, 4,000 demands over 6 distinct demand types, 2 resources, capacity 150 | weighted repair scheduler | compiles today | steps 1-3 yes; C4 repeated interface and C6 | CP-SAT, one-hot options with resource capacities | ergodis wins |

The L3 row is deliberately placed past the compiled width cap of the bounded
subset-sum kernel. Its expected outcome is that ergodis declines to compile the
instance while the control returns an answer. That refusal is the measured
boundary this tier exists to publish; it is reported as a loss, and N3 names
the mechanism that would move it.

Losses predicted here are losses of this software, on these instances, against
this control, on one host. They are not claims about the relative merits of the
underlying algorithms, and no row of this tier is a general solver comparison.

## 5. Provenance of this file

Version 1 was written and hashed before any measurement of the tier was taken:
SHA-256 `6562fa8f70324802d372953259f4f09241b787b1f41548e943201999baffbfec`,
8,278 bytes, 2026-09-02T15:15:46-07:00.

Version 2 is this file. Two changes were made after that hash and before the
recorded measurements, both disclosed in
`notes/2026-09-02-c1038-negative-control-benchmark-tier.md`. First, the framing
of section 2 changed from a scope exclusion to a not-yet-compiled frontier with
a named absorption mechanism per entry; no verdict changed. Second, the
instance sizes in section 4 were recalibrated so that every cell finishes
inside the ten-minute budget and so that the bounded subset-sum kernel's exact
subset counter cannot overflow: item counts, demand counts, and capacities
moved. The kernel, the classifier verdict, the deciding test, the control, and
the predicted direction of all six rows are unchanged from version 1.
