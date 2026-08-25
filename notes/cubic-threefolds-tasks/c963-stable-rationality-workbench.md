# C963 -- proof-producing stable-rationality workbench

**Lane:** cubic-threefolds

**Status:** queued after C958; do not begin until C958 has accepted ground-field
forward and inverse maps for both explicit cubic families

## Goal

Turn C958's constructive level-two parametrizations into a reusable exact
computational surface for the cancellation phenomenon

```text
Y = X x P1 nonrational,   Y x A1 rational.
```

The workbench should compile the proved Cox/torsor and tangent-section data
into compact rational maps, verify them independently on explicit dense opens,
and support exact rational-point generation and function-field transport.  It
is a proof-producing computational-algebra artifact, not a general rationality
oracle.

## Predecessor gate

C958 must first provide, for type `I_1` and type `I_3`:

1. forward and inverse maps over `Q` for the two stated products `X_j x P2`;
2. explicit localized coordinate rings on which both composites are identities;
3. compact exact certificates and an independent replay; and
4. stable names for the Cox, norm-torus, tangent, and cubic-fibration interfaces.

C963 consumes those frozen interfaces. It does not finish C958, change its
formulas, or weaken its acceptance gate.

## Deliverables

1. Specify a small exact interchange format for rational straight-line
   programs, localization denominators, source/target equations, and declared
   inverse pairs. Preserve field-of-definition and variable-count metadata.
2. Export both accepted C958 parametrizations into that format and build two
   independent checkers: one reconstructing symbolic identities and one
   validating the compact certificate without sharing the primary algebra.
3. Compute exact degree, coefficient-height, operation-count, and expression-size
   profiles for every stage. State a uniform complexity bound only if it is
   separately proved; otherwise report measured instance data.
4. Compute the indeterminacy and denominator loci stage by stage, distinguish
   genuine exceptional components from chart artifacts, and emit the dense-open
   conditions needed for safe evaluation.
5. Make the cancellation geometry explicit. Transport the embedded copy of
   `Y` into the rational five-parameter chart, identify its auxiliary-variable
   constraint, and certify why it is not being treated as a cancellable
   coordinate hyperplane. Do not infer rationality of `Y` from specialization.
6. Provide exact operations for rational-point generation on the admitted open,
   forward/backward function-field transport, and identity checking for user
   supplied rational functions. Record rejected denominator and exceptional-locus
   cases rather than silently dropping them.
7. Produce two worked examples, one for each cubic family, and a compact
   reviewer-facing derivation linking every generated object to the C956/C958
   theorem and certificate that authorizes it.
8. Decide the smallest durable interface after the mathematics is fixed: a
   repository-local CLI/library, a Sage or Magma adapter, or certificate-only
   tooling. Dependency and architecture choice is deferred until this gate.

## Acceptance gate

- Every emitted map is over the claimed ground field and carries its explicit
  source, target, localization, and dimension metadata.
- Both composites are checked on named localized coordinate rings by independent
  implementations, and deliberately corrupted certificates are rejected.
- Rational-point and function-field operations round-trip on exact examples and
  report all exceptional-locus failures explicitly.
- The transported `Y` constraint is derived and checked; no `t=0` or generic
  hyperplane shortcut is used to assert cancellation.
- Complexity language distinguishes proved asymptotic bounds from measured
  degree, height, and straight-line-program size.
- No finite-field, cryptographic, numerical-efficiency, or general
  stable-rationality claim is made without a separate good-reduction or
  algorithmic theorem.
- Any manuscript-facing change remains owned by a separately authorized paper
  task and passes the corresponding authority and standalone gates.

## First action after C958

Freeze C958's two map/certificate interfaces, then write a one-page schema and
threat model covering field descent, localization, certificate corruption,
expression swell, and the noncancellation specialization trap before choosing
an implementation stack.

## Queued successors

- C965 extracts the accepted C958/C963 descent chain into a generic,
  proof-producing Galois-descent engine for supplied Cox, Picard, permutation-
  resolution, and torus-chart data.
- C966 is a later bounded triage of the remaining algorithmic implications. It
  must deduplicate against C963 and C965 before proposing any implementation or
  successor allocation.
