# C997 -- symmetry-reduction gate experiment for exact qLDPC distance solvers

**Lane:** quantum-codes

**Status:** closed 2026-08-28, gate passed; report
`notes/quantum-codes-reports/2026-08-28-c997-symmetry-reduction-gate.md`.
Correction: `arXiv:1102.5715` (cited below as a symmetry-in-distance paper) is
Wirthmüller on automorphisms of stabilizer codes and transversal gates, not
distance computation; the report records the corrected pre-emption reading.

## Placement

Follows the 2026-08-28 research report
`notes/2026-08-28-ergodis-ldpc-quantum-angle.md`, whose recommended first
product is a symmetry-reduction front end for the exact (mixed-integer and
maximum-satisfiability) distance solvers the quantum LDPC community already
uses. This task is the kill gate for that proposal, not the product. It owns
no paper and makes no change to `papers/complete-repair-ports/ergodis`.

## Question

Does exploiting the automorphism group of a CSS code inside an exact distance
computation shrink the solver's search tree materially, or does the solver's
own presolve already recover the reduction?

## Experiment

1. Take Bravyi et al.'s public `distance_test.py`
   (`github.com/sbravyi/BivariateBicycleCodes`), which certifies the
   `[[144,12,12]]` gross code with one integer program per logical operator.
2. Add orbit-based symmetry-breaking constraints for the `Z_l x Z_m`
   translation group (order 72, acting freely on qubits) to that integer
   program. Keep the solver, machine, and instance fixed.
3. Measure branch-and-bound node count and wall time, modified versus
   unmodified, for every one of the `2k` solves.
4. Complementary check at the same cost: repeat on the classical
   `[78,36,12]_2` passant code (`papers/q13-passant-code`), whose group
   `PGL(2,13)` has order 2184 and whose committed certificates give the
   minimum words (364 words in four orbits of 91) as an independent answer.

## Acceptance

- Pass: node-count reduction of at least about 5x on the gross code with a
  matching certified distance. Then propose the follow-on product task.
- Fail: under about 5x, or the solver presolve already finds the symmetry.
  Record the numbers and close the proposal; nothing further is queued.
- Either way: a dated report under `notes/quantum-codes-reports/` with the
  exact script diff, solver version, and raw node counts, committed as a
  reproducibility bundle per `notes/research-reproducibility-conventions.md`.

## Pre-emption checks owed before any positive claim

Read `arXiv:1102.5715` (symmetry in minimum-distance computation) and the
MIT automorphism paper `arXiv:2606.05044` before describing the reduction as
new; the research report lists both as open checks.

## Allowed paths

- `notes/quantum-codes-tasks/c997-qldpc-distance-symmetry-reduction-gate.md`
- `notes/quantum-codes-reports/`
- `notes/2026-08-25-quantum-codes-discovery-track.md`
- a scratch experiment directory chosen at task start, outside `papers/`
