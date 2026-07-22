# C472 — signed Hadamard lift and the central Weil discriminator

**Context:** queued after C470 and C471. C465 rejects the genuine degree-six Weil constituent for
the frozen permutation action because central `-1` survives in characteristic three. C469 supplies
the natural signed Hadamard carrier; C470 determines its exact automorphism boundary.

## Dependencies

- C470 exact monomial/projective automorphism group and frozen `PSL_2(11)` embedding
- C471 exact Hadamard degeneration complex
- C450/C455/C465 central-character and Weil normalization data

## Task

1. Compute the full preimage of the frozen `PSL_2(11)` inside the exact signed monomial stabilizer
   certified by C470, without importing a `2.M12` label.
2. Decide whether the extension is split, direct-product, or the nonsplit `2.PSL_2(11)` cover;
   give literal generators, relations, kernel, and cocycle.
3. Compute its action on the six-dimensional ternary Hadamard/Golay carrier, including the central
   scalar, composition factors, Brauer character, and comparison with both genuine degree-six
   Gerardin reductions.
4. State the sharp alternative: either a genuine signed six-dimensional Weil realization exists
   as a different action from C465's frozen permutation action, or the double-cover door closes.

## Acceptance

Require an exact signed-matrix certificate, central-action discriminator, group-extension proof,
Brauer comparison, checksum manifest, and independent replay.

## Boundaries

- C465's frozen-action negative remains unchanged under either outcome.
- No full Mathieu classification or maximality claim beyond C470's certified group.
- Projective equality is not linear equality; every scalar and cocycle must be explicit.
