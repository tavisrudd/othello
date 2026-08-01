# C748 — Paper II Serre-style proof integration

**Lane:** `clebsch`

**Status:** queued after C746 and C747

## Objective

Integrate the completed structural lemmas into one severe, reader-first proof
of the all-`q` Paper II classification.  This is human-proof round 3 of 4;
C749 performs the final adversarial compression and referee pass.

## Editorial standard

- State the classification mechanism before its technical lemmas.
- Give every lemma one job and every paragraph one mathematical gain.
- Use intrinsic modules, maps, filtrations, and extension classes; remove
  non-essential coordinates, implementation vocabulary, and duplicated
  verification prose.
- Keep the shared radial and maximal-isotropic Gorenstein arguments as short
  structural proofs, with computations retained only as independent checks.
- Verify all imported results against primary sources and record read depth.

## Acceptance gate

Two independent cold reads are required:

1. a finite-group/modular-representation reader must verify the all-`q`
   proof line by line; and
2. a context-free exposition reader must be able to state why the proof
   works, where the single obstruction lies, and why q=7 and q=11 are the
   only survivors.

Both must return `GO` with no material proof or architecture objection.
Then pass the proof, reviews, and unresolved-friction ledger to C749.  The
human theorem surface is not frozen until C749 also passes.

## Boundaries

No Lean additions or redesign occur here.  A green checker cannot substitute
for either cold read, and C750 remains blocked.
