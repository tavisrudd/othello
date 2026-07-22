# C463 — A3 companion `Z/2` torsor and the bit-carrier duality

**Context:** parallel and non-blocking; must not displace a battery-chain slot. The M-chain juice
memo ([`../2026-07-21-weil-roof-juice-m-chain.md`](../2026-07-21-weil-roof-juice-m-chain.md),
candidate 1) found by exact enumeration that the A3 case carries a previously-unrecorded companion
obstruction: the unique invariant antipodal matching on `K_6` has exactly two companion orbits, and
`i -> -i` swaps them with no fixed member. C444's M4 certificate covers only the antipodal matching
(which is `i -> -i`-blind); this card certifies the companion level and the resulting cross-case
statement. Sibling of C462 (H3); the memo's scratch test is the certificate skeleton but must be
recomputed, not cited.

## Inputs

- C444 report, checker, and JSON (frozen A3 spin model, `P^1(F_5)` labels, antipodal matching;
  B3 objects for the duality clause)
- C443 report and JSON read-only for the H3 row of the cross-case table
- the M-chain juice memo (hypothesis source only)
- C442 report only for the "bit-carrier dualizes" finding it extends

## Task

Certify, under the frozen C444 conventions:

1. the matching-orbit census on `K_6` under the projective `S4`, with exactly one fixed matching
   (the antipodal one) and exactly two companion orbits of size 4 completing it to a
   one-factorization;
2. the `i -> -i` action swaps the two companions with no fixed member — a nontrivial `Z/2` torsor
   over `Z[i]` — while fixing the antipodal matching;
3. each companion's reduction at the two primes of `Z[i]` above 5 (`i -> 2` vs `i -> 3`), showing
   each companion prefers one prime, in the same sense as C443's companion-prime table;
4. the B3 control: the unique B3 companion is Galois-fixed (trivial torsor, descends), so the
   descent bit sits in the antipodal-matching sheet split there, in the companion family for A3,
   and in the companion family at `Z/4` strength for H3.

State the three-case bit-carrier duality exactly and conservatively: a table of certified facts,
not a claimed general law for other Coxeter groups or primes. No moment computations, no secant
products, no manuscript edits. A failed recomputation of any memo claim is a stop-and-report
blocker.

## Acceptance

Canonical JSON must contain: the full A3 and B3 matching-orbit censuses; the companion orbits as
explicit edge sets; the `i -> -i` (and `omega -> omega^2`) actions on companions; the A3
companion-to-prime reduction table; and the three-case summary table (H3 row copied by hash
reference from the C443/C462 certificates, not recomputed). Standard bundle: dated report, checker,
JSON, checksum manifest, independent replay.
