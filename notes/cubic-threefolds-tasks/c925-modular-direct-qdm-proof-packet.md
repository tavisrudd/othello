# C925 — modular direct-QDM proof packet

**Lane:** `cubic-threefolds`

**Status:** active 2026-08-19

**Objective:** write a self-contained alternative proof packet for cubic
one-stabilization irrationality in which the QDM block information retained by
the argument is a parameter, analogous to a Haskell type class or a software
interface.

## Required architecture

1. Define an abstract generic even-QDM block and a parameterized marker datum:
   observation payload, acceptance predicate, and value in a commutative
   monoid.
2. Separate reusable modules for coefficient fields, regular block transport,
   direct-sum separation, blowups, projective bundles, and weak factorization.
3. Prove that forgetful/coarsening maps between marker data commute with every
   ledger operation.
4. Instantiate the framework with the smallest marker sufficient for a cubic
   threefold: even rank two, nonzero centered nilpotent, and nonzero modified
   residue discriminant.
5. Include the corrected common-coefficient-spine argument from C924; never
   map a full `q`-adic completion into an opposite `q^{-1}`-Laurent completion.
6. Prove the cubic endpoint, low-dimensional vanishing, projective-bundle
   doubling, fourfold birational invariance, and contradiction with
   `P^4`.

## Acceptance gate

- The packet is mathematically self-contained modulo its explicitly listed
  primary inputs.
- The interface genuinely supports alternative retained payloads rather than
  merely renaming the cubic marker.
- Every generic-base and scalar-extension operation is typed explicitly.
- The concrete cubic instance does not retain unused odd-rank or exact-value
  data.
- A hostile final pass checks variance, additivity, coefficient topology,
  parity, and all low-dimensional cases.
- No manuscript or Lean file is edited.
