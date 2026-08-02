# C761 row-family uniqueness transport

**Lane:** `clebsch`

**Date:** 2026-08-01

## Result

The intrinsic reconstruction test on the decoded union of the four displayed minimum-word orbits
recovers exactly the 78 geometric passant-row supports.  The transport avoids the ambient
`78 choose 7` subset space.

For each ordered three-point seed, retain the points that extend it to a passant clique with zero
minimum-layer concurrence on every distinct triple.  Every admissible seven-set is the seed joined
to a four-subset of this local extension pool.  The largest pool belonging to a non-row seed has
size 10, so checking all four-subsets is a small exhaustive leaf.  The seven Lean leaves partition
the first displayed point index modulo seven; a symbolic coverage theorem transports their result
to equality of semantic row families.

The tempting stronger triangle statement is false.  There are exactly 1,456 non-row triples with
three passant joins and zero concurrence.  Their extension-pool size distribution is

```text
0:44, 1:56, 2:123, 3:196, 4:199, 5:208,
6:201, 7:132, 8:143, 9:83, 10:71.
```

Thus zero concurrence is a local compatibility condition, not collinearity by itself.  The
four-extension gate is the exact repair.

## Proof and evidence surfaces

- `RelativeConicArcs.PassantCodeQ13.Reconstruction` supplies the semantic seven-set transport and
  the seven-point row cardinality.
- `PassantCodeQ13.MinimumWords.RowUniqueness.Base` decodes the four orbit supports, defines the
  local pools and the finite-checker soundness lemmas, and evaluates only canonically ordered
  admissible seeds.  The executable zero-triple condition scans each minimum support once and
  asks whether it meets the candidate in at most two points.
- `DecodeInjective`, `PairTransport`, and `ConcurrenceTransport` prove that encoded supports,
  indexed passant joins, and the support-intersection test have their advertised semantic meaning.
- Seven residue modules check the complete first-index partition by native evaluation; the light
  aggregate combines them without further native execution.
- `PassantCodeQ13.MinimumWords.RowUniqueness.Transport` connects the indexed leaves to the semantic
  reconstruction equality, exported as `PassantCodeQ13.Gates.Main.recoveredRowFamilyIsUnique`.
- The independent Python replay uses a different route: it enumerates all 1,716 passant
  seven-cliques and selects exactly the 78 geometric rows.  It now also checks the local-pool
  compression and the exact distribution above.

## Reproduction

From the repository root:

```sh
python3 papers/q13-passant-code/verification/check_q13_tangent_code.py
```

Expected terminal line:

```text
q=13 tangent-code replay: PASS (omega = 5, d = 12, 364 minimum words, 78 rows recovered, Aut = PGL(2,13))
```

The tracked replay has 26,948 bytes and SHA-256
`49ff490110856dd0a613c76a83dbfb30df6fc2dbfaee27db5fd597f3c375f36d`; the evidence manifest
records the same values.  It reconstructs the normalized conic, incidence relation, four minimum
orbits, concurrence data, and clique graph independently of the Lean package.

The guarded paper acceptance build completed successfully in
`~/.cache/othello-lean-build/run-20260802-100131-55b71ab8`: `PassantCodeQ13.Gates.Main`
built in 17.54 seconds, the axiom audit built in 4.80 seconds, and the aggregate trace gate passed.
The direct semantic transport gate passed in
`~/.cache/othello-lean-build/run-20260802-100040-87052514` with 1,822,120 kB peak RSS.
The shared reconstruction theorem and shared axiom audit passed in
`~/.cache/othello-lean-build/run-20260802-092130-d536f73c` and
`~/.cache/othello-lean-build/run-20260802-100237-b35b0ac9`, respectively.  The paper audit reports
only the expected `propext`, `Classical.choice`, `Quot.sound`, and declaration-local native
evaluation axioms.

The public `make check` gate passed: evidence replay, TeX spacing lint, two XeLaTeX passes,
warning scan, and the seven-page PDF are green.  `git diff --check`, both JSON parses, the manifest
hash/byte check, and the standalone Python replay also pass.

## Novelty boundary and mystery ledger

This result is the exact `q = 13` faithfulness theorem used by Paper IV.  The simultaneous-paper
series may cross-reference its shared conic, association-scheme, and reconstruction context, but
no uniform odd-field claim is imported into this gate.  The cross-paper novelty audit records the
genuine open level-up: determine the exact odd `q`, congruence classes, or size range for which the
minimum-support hypergraph reconstructs the elliptic scheme, conic, and passant incidence, and
identify the first failure modes.  The cheapest falsifier remains exact testing at `q = 9, 11,
17`.

The task-owned mystery exposed here is settled: zero concurrence of a passant triangle does not
force collinearity, as witnessed by the 1,456 non-row triples above.  Local four-extension
exhaustion is the exact replacement.  The pool-size distribution is retained as certificate
diagnostics rather than promoted to an unexplained structural theorem.  The uniform-field-range
question remains open outside this row-family closure.

## EJ+TT closeout

- **Essential judgment:** reject the false triangle shortcut and certify complete seven-set
  coverage through three-point seeds and four-point local extensions.
- **Truth tracking:** the semantic theorem, seven native residue leaves, and independent 1,716-
  clique replay use distinct proof routes and meet only at the exact 78-row conclusion.
- **Cheap upgrade taken:** canonical seed ordering, an admissible-seed guard, and one support scan
  per candidate shrink the evaluator without weakening its domain.
- **Optional extension declined:** a uniform odd-`q` reconstruction theorem is a separate
  high-value research move, not a prerequisite for the exact Paper-IV result.

**Vibe check:** the proof now says exactly what the finite data show, with the false local shortcut
exposed rather than hidden and the genuine family-level question left open.

`go C761 clebsch concrete four-anchor automorphism transport`
