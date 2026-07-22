# C471 — Hadamard degeneration complex and puncture/shorten bridge

**Context:** queued downstream synthesis from C465 and C469. C469 constructs an integral order-12
Hadamard matrix whose mod-3 rows span the self-dual `[12,6,6]_3` code; C465 identifies the
punctured Golay span, its simple five-dimensional core, and the nonsplit augmentation carrier.

## Inputs

- C465 atomic bundle (`notes/2026-07-21-c465-mod3-weil-golay.*`)
- C469 atomic bundle (`notes/2026-07-21-c469-witt-golay-equivariance.*`)
- C455 Fourier/Weyl report, method and normalization comparison only

## Task

1. Certify the mod-3 Hadamard exact complex: rank six and the literal identities
   `ker(H)=im(H^T)` and `ker(H^T)=im(H)`.
2. Identify the C469 self-dual code as the exact kernel/image carrier and prove that puncturing the
   distinguished coordinate gives C465's Golay span while shortening gives its simple
   five-dimensional Lagrangian core.
3. Derive C465's socle/radical and nonsplit augmentation flag from the unpunctured operator model
   wherever possible; state exactly what still requires the retraction computation.
4. Compare the degeneration with C455's normalized Fourier/Weyl operator at the level of exact
   operator identities, without asserting a Weil-module identification unless the central
   discriminator passes.

## Acceptance

Return an atomic report/generator/JSON/checksum/replay bundle containing the literal matrices,
kernel/image bases, puncture/shorten intertwiners, ranks, and every asserted commutative diagram.

## Boundaries

- No automorphism-group census; C470 owns that boundary.
- No signed double-cover conclusion; C472 owns it.
- The q=7 sign model is not inferred from the q=11 construction: `+1=-1` mod 2 destroys the same
  sign encoding and requires a separate explicit model if claimed.
