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

## Current draft

The active packet is
[`2026-08-19-c925-modular-direct-qdm-proof-packet.md`](../2026-08-19-c925-modular-direct-qdm-proof-packet.md).
It currently contains:

- a lawful observer/selector/emitter interface with commutative-monoid values;
- a probe-indexed, marked-block extension whose singleton-generic instance is
  the direct-QDM proof;
- a free symmetric-monoidal 2-monad of blocks, indexed scalar-extension
  pseudofunctor, Beck--Chevalley law, and universal center localization;
- a monoidal center quotient through which center-vanishing markers factor;
- optional Bittner/group-completion, finite-Kan-coarsening, and
  endomorphism-category retention backends, with explicit information-loss
  cautions;
- corrected coefficient-spine, blowup, projective-bundle, and divisor-character
  adapters;
- counting, Boolean, exact-profile, parity-enriched, monodromy, and universal
  configuration examples;
- the minimal cubic instance and a category-theoretic summary diagram; and
- exact specialization audits for Guéré's evaluated
  \(\clubsuit/\heartsuit\) properties, the marked BFGMP coarse-atom criterion,
  and the KKPYY chemical-formula/dimension-filtration layer; and
- an explicit exploration frontier.

The finite categorical law model is
`notes/cubic-threefolds-tasks/c925-categorical-law-check.py`, with exact
checked output
`notes/cubic-threefolds-tasks/c925-categorical-law-check.json`.  It passes
eight tests, including a negative collision test showing why Guéré's
unit-shift separation contract is mandatory.  The original exact cubic
residue replay also remains green.

Replay the categorical test with:

```bash
nix shell nixpkgs#python3 --command \
  python3 notes/cubic-threefolds-tasks/c925-categorical-law-check.py \
  | diff -u notes/cubic-threefolds-tasks/c925-categorical-law-check.json -
```

Keep C925 active: the user has asked to continue exploring the categorical and
software-interface design before closeout.
