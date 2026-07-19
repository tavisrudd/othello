# C364: intrinsic complete coset-leader decoder for the C329 family

**Lane:** `crowns`

**Date:** 2026-07-19

**Status:** queued; positive theorem salvaged from C361

## Goal

Turn C361's ten exact affine secant correspondences into a complete syndrome algorithm for the
C329 non-GRS MDS family.  After C337 recovers the intrinsic normal form `[rho;{a,b}]`, the algorithm
must accept every syndrome, return an actual minimum-weight coset leader, and certify its weight.

The intended theorem is stronger than ordinary unique decoding for a distance-four code.  It is a
complete coset-leader decoder covering weights zero through three, including exact deep-hole
recognition.

## Fixed inputs

- C337: expected-linear recovery of the unmarked code, its four layers, additive action, and
  `[rho;{a,b}]`.
- C348: the projective-syndrome/coset-leader dictionary and exact infinity-hole test.
- C361: four within-layer trace gates, the seed--seed quintic and vertical component, the
  repair--repair quadratic, and four seed--repair octics.

These reports and their evidence bundles are read-only inputs.  C364 does not reopen C361's failed
enumerator gate.

## First hard gate

For every root returned by a C361 fiber equation, reconstruct explicitly:

1. the two arc columns defining the covering secant;
2. their two nonzero syndrome coefficients; and
3. a minimum-weight error vector with the original, unquotiented syndrome.

Prove the converse and handle repeated-layer, seed vertical, affine exceptional-divisor, infinity,
weight-one, and zero-syndrome cases without presentation-dependent choices.  A membership oracle
that does not return a leader fails this gate.

## Complexity and implementation gate

Give a deterministic finite-field root-finding implementation for degrees `2,5,8` and state its
bit and field-operation complexity.  Separate one-time C337 recovery from per-syndrome work and
compare honestly with direct `Theta(n^2)` secant enumeration and any precomputed lookup method.
The claim must be invariant under C337's seed and repair relabellings.

An evidence bundle must include exact reconstruction checks on every projective syndrome of the
three C348 `Q=32` fixtures, comparing returned leaders against an independent direct-incidence
implementation.  Record canonical output, hashes, byte counts, replay command, and trusted
boundary.

## Novelty gate

Audit complete syndrome/coset-leader decoding, redundancy-three RS/PRS deep-hole classification,
twisted/extended-GRS error-correcting-pair decoders, non-GRS deep-hole algorithms, and structured
code recovery.  Credit root finding, syndrome geometry, deep-hole/MDS-extension equivalence, and
ordinary one-error decoding as prior mechanisms.

The defensible target is the combined theorem:

> an unmarked member of this recoverable four-orbit non-GRS MDS family admits intrinsic complete
> coset-leader decoding through a constant number of trace and bounded-degree root problems.

Do not claim generic non-GRS decoding or novelty for bounded-degree polynomial solving.

## Exit

**Pass:** a proved and independently replayed algorithm returning a minimum-weight leader for every
syndrome, with explicit bounded-degree equations, reconstruction formulas, complexity, invariance,
and a closed source-level novelty matrix; integrate a theorem/corollary and proof map into C362's
combined-paper package.

**Narrow:** exact deep-hole membership and weight classification without leader reconstruction;
record it as a decision oracle, not a decoder.

**Stop:** presentation-dependent reconstruction, hidden `Theta(Q)`/`Theta(Q^2)` search, failure on
exceptional or infinity cases, or prior work containing the same recovered-family complete decoder.
