# C472 — signed Hadamard lift and the central Weil discriminator

**Status:** completed SHARP NEGATIVE on 2026-07-22; exact report and replay bundle:
`notes/2026-07-22-c472-signed-weil-lift.md`.

**Context:** queued after C470 and C471. C465 rejects the genuine degree-six Weil constituent for
the frozen permutation action because central `-1` survives in characteristic three. C469 supplies
the natural signed Hadamard carrier; C470 determines its exact automorphism boundary.
The shared conditional consequence map is `notes/2026-07-22-c471-c474-downstream-implications.md`.

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

## Hints from C470 (not conclusions)

- Start from the literal signed generators in
  `notes/2026-07-22-c470-golay-hadamard-automorphisms.json`, especially
  `monomial_group.standard_M12_generator_lifts`, and the frozen base cell recorded under
  `second_order_signed_bipartite_geometry`. Reconstruct every subgroup from those matrices rather
  than from the abstract group labels in the report.
- C470 identifies the frozen projective `PSL_2(11)` as the stabilizer of the base coordinate/row
  cell. Its full inverse image under the signed-to-projective map must therefore have order
  `2 * 660 = 1320`; this is only an order check, not a decision between the possible extensions.
- A cheap geometric discriminator may come from replacing the 144 projective coordinate/row cells
  by signed pairs `(+/- e_j, +/- h_i)`. Partition them by their exact integral inner product and
  compute the signed-group orbits and stabilizers. If a signed-pair stabilizer has order 660 and
  projects bijectively to the frozen subgroup, it supplies an explicit complement and proves
  splitting. This orbit prediction is deliberately a test to perform, not a fact supplied by C470.
- Independently certify the extension type from literal relations. Test whether chosen lifts of the
  frozen translation and inversion satisfy the `PSL_2(11)` presentation or acquire the central
  signed scalar. As cross-checks, compute the center and derived subgroup: a direct product has
  derived subgroup of order 660, whereas the nonsplit perfect cover would have derived subgroup of
  order 1320.
- Keep four objects separate throughout: the projective cell stabilizer, a possible signed-pair
  stabilizer, the full order-1320 inverse image, and its induced linear action on C471's six-space.
  Abstract isomorphism or matching orders do not identify their representations.
- Wait for C471's exact kernel/image basis and puncture/shorten intertwiner. Restrict the signed
  monomial matrices to that certified carrier, verify the central signed involution acts as the
  scalar `-I` (that is, scalar `2` over `F_3`), and only then compare generator matrices and Brauer
  characters with the two normalized genuine Weil reductions. The permutation action's `1+5`
  decomposition is not by itself evidence for or against this different signed action.
- A useful negative certificate is just as sharp: if no compatible complement/action/intertwiner
  exists, record the first failed exact relation or character value and close the signed-Weil route
  without weakening C465.

## Acceptance

Require an exact signed-matrix certificate, central-action discriminator, group-extension proof,
Brauer comparison, checksum manifest, and independent replay.

## Boundaries

- C465's frozen-action negative remains unchanged under either outcome.
- No full Mathieu classification or maximality claim beyond C470's certified group.
- Projective equality is not linear equality; every scalar and cocycle must be explicit.
