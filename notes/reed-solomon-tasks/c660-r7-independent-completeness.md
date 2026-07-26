# C660 — independent finite completeness for redundancy seven

**Lane:** `reed-solomon`

**Dependency gate:** Begin only after C545 publishes Version 1.  This task must
not alter, delay, or retroactively strengthen the reviewed Version 1 claim.

## Target

Re-derive the complete bounded-field redundancy-seven split-free
classification for
\[
q\in\{7,8,9,11,13,16,17,19,23,25,27,29,31,32\}
\]
without importing C509's quotient enumerator, stored classification, orbit
partition, representative list, or aggregate absence claims.

The result is a trust-strengthening reproduction of the finite bridge, not a
new deep-hole theorem.  It must retain the separate covering-radius boundary:
the rows at \(q=7,8,9\) classify split-free syndrome directions but are not
promoted to code deep holes.

## Independence boundary

The current C656 replay replaces the finite-field implementation and
reconstructs all recorded data, but it deliberately reuses the primary
quotient enumerator.  C660 must instead supply an independently justified
candidate domain and completeness argument.  Comparing its final canonical
records with Certificate R7 is allowed only after the independent enumeration
has terminated.

Acceptable routes include:

1. a direct normalized Hankel-system enumeration with a separately proved
   normalization and deduplication theorem;
2. an intrinsic invariant stratification with exhaustive mass or Burnside
   identities for every projective orbit; or
3. a different theorem-derived quotient whose coverage map to projective
   sextic syndrome space is proved explicitly.

Renaming or mechanically translating C509's state space does not pass.

## Proof and computation gates

1. Define the exact finite domain, normalization, projectivization, infinity
   convention, and split-squarefree predicate independently.
2. Prove that every projective redundancy-seven syndrome is represented
   exactly as claimed, including stabilizer-weighted or deduplicated coverage.
3. Compute the complete split-free set and its
   \(\operatorname{PGL}_2\)-orbits, stabilizers, flags, and Frobenius fusion
   without reading the public R7 records.
4. Give a field-by-field completeness identity that would detect one omitted
   or duplicated orbit.
5. Freeze canonical outputs before comparison; only then compare counts,
   representatives up to transport, orbit sizes, and semilinear fusion with
   Certificate R7.
6. Ship the generator, compact certificate, independent checker, exact
   commands, byte counts, and SHA-256 manifest as one reproducible bundle.
7. Obtain a blind coding/computational review of the independence claim.

## Exit gate

- all fourteen fields pass the independently derived completeness route;
- every comparison with Certificate R7 agrees, or any discrepancy is resolved
  before a paper-facing claim;
- the report states precisely which arithmetic, factorization, and group-action
  code is genuinely independent and which standard library or theorem input
  remains shared; and
- the result is placed as a post-Version-1 reproducibility upgrade without
  changing the published theorem statement.

If the independent route is computationally infeasible, stop with a measured
obstruction and the smallest exact shared dependency that cannot yet be
removed; do not relabel another reconstruction as an independent derivation.
