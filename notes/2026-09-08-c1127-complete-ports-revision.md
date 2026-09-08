# C1127: manuscript revision

**Lane**: `complete-ports`

**Date**: 2026-09-08

The accepted starting assessment is
`notes/2026-09-08-c1127-complete-ports-referee-response.md`.
The user enabled intent-based mode and then directed execution with `go`.

## Mathematical repair batch

- Both contextual quotient statements now assert closure under evaluations
  against composed outer contexts, with original leaf confinement region,
  target coordinates, and normalization fixed. The proof explicitly preserves
  external coefficient activity. A binary boundary example excludes the
  unintended macroblock reading. The introduction and claim map agree.
- Strict RGHW growth is quantified over dimension-wise optimal requests;
  the prescribed-line example makes the distinction explicit.
- The optimizer's predecessor bound retains one minimizer per finite entry.
  Tied transitions, coefficient lifts, and useful nonminimum support alternatives
  have separate accounting. Its fixed-query certificate now follows the binary
  tree recursion, including leaf lower bounds and complete transition coverage.
- The best-target theorem has a finite outer-distance hypothesis. Its direct
  sector proof covers dependent target columns and permits nonzero-sector ties.
  A separate paragraph states the sufficient all-target collapse bound.
- Fixed-target confinement explicitly excludes zero requests; singleton RGHW
  reduction explicitly requires helper recoverability.
- Radius-three reliability ordering is factored as `s^6(1-s)^3` under the
  stated homogeneous independent-survival law.

The annotation source check passed with 32 claims and four unchanged Lean
terminals. The deterministic repair build had no TeX warnings and measured
42 pages; its first run rejected the stale 40-page expectation. Updating the
expected page count preserves the exact-count gate. No Lean source or build
was involved. Further exposition work remains before C1127 closure.

## Example and exposition batch

Added a complete 12-coordinate binary hierarchy with three encoding levels.
The request normalization, binary leaf labels, intermediate tables, both outer
choices, and backtracked equations show the optimum switching from one helper
to two after a helper failure. The calculation is proved by its two exhaustive
outer branches, independently of executable evidence.

Added a connected adjacent-pair family with three physical helpers per block.
Local tables enumerate `q^(3t)` coefficient maps and a supplied balanced interval
tree has boundary dimension at most two. This accounts for construction and
`O(n q^(4t))` combinations, compared with the stated ambient-state enumeration.
The explicit Singer instance now gives the irreducible cubic, multiplier,
multiplication matrix, four dual images, and outer parity equation.

Moved contextual minimization to an appendix and distance specializations to
a secondary section. Optimization and its complete example now immediately
follow composition. Replaced repeated reading instructions with the actual
section order, added the coordinate/functional notation table, and replaced
overlapping related-work prose with theorem-specific contribution accounting.
Stable theorem labels and 32-claim coverage are preserved. The deterministic
build passes at 43 pages without warnings. The first table build exposed
underfull justified cells; ragged-right table columns corrected them.

The user's additional instruction to use the shared formalization macros
consistently is part of C1127. Audit found all six definitions present but no
import/evidence registries or uses of those two macros, and no statement digest
or dependency-graph gate.

## Six-macro consistency audit

Completed adoption of the shared six empty one-argument macros. The source gate
now resolves imported inputs and evidence, enforces end-of-proof placement,
checks the actual input tree, binds each reviewed correspondence row to its
statement digest, binds the four terminals to source-signature digests, and
rejects a stale authored dependency graph. The 32 rows now state objects,
hypotheses, conclusions, and cautions. Source-signature hashes are explicitly
not described as new elaboration or full semantic-dependency hashes.

Nine imported-input entries distinguish conceptual use of established methods
from logical proof inputs. The relative-weight/Singleton locators were checked
against cached Luo et al. (2005), Section III, Proposition 2 and Theorem 3,
and Section IV, Theorem 4, equation (23), pp. 1225--1226:
`10.1109/TIT.2004.842763`, PDF SHA-256
`eecbc9e01441c1a6955eeb60d17536856957c9d8b3b5ce110dbd1226d9276fd1`.
Geil et al., `arXiv:1403.7985`, Section 2 equation (3) and Section 3's bound
discussion were also consulted (PDF SHA-256
`25e31e23e4238ae33a08b4730c558fe071861a87c6e4fc0e1161d4bbcda581e7`).
These were partial passage reads, not full readings.

Added the missing source for the subspace-lattice inversion formula: Stanley,
*Enumerative Combinatorics*, volume 1, second edition, Proposition 3.7.1 and
Example 3.10.2, equation (3.34), from the author's PDF at
`https://math.mit.edu/~rstan/ec/ec1.pdf` (PDF pages 303 and 317; partial browser
text access). The general inversion screenshot succeeded; the subspace-formula
screenshot timed out, so the latter was checked in extracted mathematical text.
The publisher's Singer PDF returned HTTP 403. Its existing attribution is
retained without inventing a theorem number; the regular-action step is now
proved directly by the unique multiplier class `[g/f]`. Other established
method locators reuse the precise prior audit at
`notes/2026-09-07-complete-ports-literature-audit.md`; they were not reread as
new literature evidence. No new novelty-negative claim is made.

All 14 mutation tests pass, including a clean baseline, unknown imports and
evidence, coverage/terminal mismatch, unknown dependency/proof target, misplaced
proof annotations, nonempty macro definitions, incomplete source conventions,
stale statement/terminal digests and graph, and an omitted input section.
Replay from the paper root: `python3 verification/test_annotations.py`.
The source-only gate and deterministic build pass at 43 warning-free pages,
32 claims, and four unchanged Lean terminals. No Lean run was needed.

## Concrete-instance evidence

Both reliability families now have displayed 4-by-10 generators over F_101.
The atomic bundle is `papers/complete-repair-ports/verification/` followed by
`replay_examples.py`, `explicit-examples.json`, `explicit-examples.md`, and
`explicit-examples.checksums.json`. The last file records exact SHA-256 hashes
and byte counts. Working directory: the paper root. Replay:
`python3 verification/replay_examples.py --check`; deterministic regeneration:
`python3 verification/replay_examples.py --write`.

Replay used Python 3.13.12 and the standard library. Inputs are the manuscript's
two five-triple families, p=101, deterministic
projective-point order, and height RNG seeds 1938/2005, capped at 10000 trials.
The first accepted height trials are 0 and 2. All 120 triples and 210 quadruples
per matrix are crosschecked by independent permutation determinants versus
Gaussian elimination (660 subset checks). Direct enumeration of all 512
availability sets per matrix verifies both displayed reliability polynomials
and their difference. All 2048 helper coefficient choices in each of the two
hierarchy scenarios independently confirm costs 1 and 2 and supports a12 and
b11,c11. The generic existence proof and two-branch worked derivation remain
independent of execution.

The prose-level `evidence` annotation resolves to this illustrative bundle;
no theorem or proof is marked as depending on it. The checker verifies its
JSON checksum manifest and the graph shows its isolated evidence node.
The expanded 15-case annotation mutation suite also rejects a corrupted
certificate. Generation and clean replay both passed, and the deterministic
manuscript build remains warning-free at 43 pages.

## Operational record

One combined routed-read tool result exceeded the display budget and truncated.
Replaced that display with bounded reads of the omitted Lean-guide tail and
the reproducibility guide before acting on them. Future routed reads are split
below the aggregate output cap.
