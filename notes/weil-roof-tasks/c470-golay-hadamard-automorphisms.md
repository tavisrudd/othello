# C470 — unpunctured Golay/Hadamard automorphism theorem

**Context:** explicitly requested by the user as C469's next question. C469 proves that parity
extension gives a self-dual `[12,6,6]_3` code whose twelve projective weight-12 points form an
order-12 Hadamard row system and whose secants exhaust every projective minimum word. It leaves all
`M_11`, `M_12`, and full-automorphism naming unclaimed.

## Inputs

- C469 atomic bundle (`notes/2026-07-21-c469-witt-golay-equivariance.*`), including the canonical
  extended generator, Hadamard rows, frozen `PSL_2(11)` action, and exact input hashes
- C464 only through C469's pinned punctured-code conventions
- exact GAP permutation-group computations may be used for a named-group comparison, but the
  concrete automorphism groups must first be generated and checked from the frozen code/point set

## Task

Compute, with literal generators and actions:

1. the coordinate-permutation automorphism group of the extended ternary code;
2. the full monomial automorphism group and its scalar/projective quotient;
3. the permutation/projective stabilizer of the twelve Hadamard row points and their 66 secants;
4. the stabilizer of the distinguished parity coordinate and its induced action after puncturing;
5. the exact embedding of C469's frozen `PSL_2(11)` in those groups.

Prove or sharply reject the anticipated identifications with `M_12`, `2.M_12`, and `M_11`.
Cardinality, transitivity degree, weight enumerators, or a database label alone are insufficient:
require explicit equality or conjugacy with exact generators, stabilizers, and exhaustive action
checks. Separate coordinate permutations, signed monomial maps, projective row-set automorphisms,
and abstract-group naming at every step.

If the Mathieu identification is positive, determine whether C469's `1+11` decomposition is exactly
restriction of a transitive twelve-point action to the parity-coordinate stabilizer, and whether
the frozen `PSL_2(11)` sits inside that stabilizer with the predicted index. Explain the distinct
`D12` and `A4` 55-orbits without conflating row pairs with C450's cross-sheet pairs.

## Acceptance gate

- every automorphism notion receives an exact group order, literal generators, and a proved action;
- every `M_11/M_12` label is backed by explicit equality/conjugacy or is withheld;
- the puncture stabilizer and frozen `PSL_2(11)` embeddings have exact indices and generator maps;
- the Hadamard rows, 66 secants, and extended-code actions agree exhaustively;
- canonical JSON, primary generator/checker, independent replay, checksum manifest, and dated report
  form one atomic bundle; and
- an extra-juice closeout records the structural payoff and every remaining naming/classification
  boundary.

## Boundaries

- No manuscript edit or Phase-3 Rosetta synthesis belongs to C470.
- Do not infer a Mathieu group from classical parameter uniqueness or a familiar order.
- Do not broaden into a census of inequivalent ternary Golay codes or Hadamard matrices.
- Literature is needed only for any abstract classification/name statement not established by the
  explicit finite-group comparison.
