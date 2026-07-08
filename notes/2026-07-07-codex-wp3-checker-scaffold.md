# Codex C14 report: WP-3 Lean certificate checker scaffold

**Date:** 2026-07-07.

## Result

Added a statement-level Lean scaffold for the C12 reply-book certificates. This is not a
parser for `notes/certs/*.cert` yet; it is the semantic checker target the parser/generated
Lean facts must satisfy.

## Lean Names

Generic finite-game layer in `lean/CapGame/BuildGame.lean`:

- `FiniteBuildGame.ReplyBookRow`
- `FiniteBuildGame.ReplyBookDAG`
- `FiniteBuildGame.ReplyBookDAG.ValidFor`
- `FiniteBuildGame.ReplyBookDAG.isP_root`
- `FiniteBuildGame.PCertDAG`
- `FiniteBuildGame.pcertDAG_sound`

Projective residual-grid layer in `lean/ProjectiveCap/Certificate.lean`:

- `ProjectiveCap.Certificate.GridClassCert`
- `ProjectiveCap.Certificate.GridClassCert.Valid`
- `ProjectiveCap.Certificate.GridClassCert.isP_witness`
- `ProjectiveCap.Certificate.GridClassCert.escape_at_sizeThree`
- `ProjectiveCap.Certificate.GridOddEscapeBookCertificate`
- `ProjectiveCap.Certificate.GridOddEscapeBookCertificate.oddEscapeGameStatement`
- `ProjectiveCap.Certificate.PrimeGridOddEscapeBookCertificate`
- `ProjectiveCap.Certificate.almostOddEscapeGameStatement_zmod_of_certificate`
- `ProjectiveCap.Certificate.almostOddEscapeGameStatement_zmod5_of_certificate`

`ProjectiveCap.Certificate` is imported by the `ProjectiveCap` umbrella.

## Proved

`ReplyBookDAG.ValidFor` mirrors the proof-relevant part of the C12 format: root is a certified
node; every certified node is valid; for every legal mover move there is a row whose reply is
legal, whose child is exactly the two-move extension, and whose child is again certified.

The generic soundness theorem is proved by reducing `ValidFor` to the existing
`FiniteBuildGame.isP_of_replyStrategy`:

```lean
FiniteBuildGame.ReplyBookDAG.isP_root :
  book.ValidFor Valid -> IsP Valid book.root
```

The grid-specific theorem is also proved:

```lean
ProjectiveCap.Certificate.GridClassCert.isP_witness :
  c.Valid -> GridGame.IsP (insert c.witness c.sizeThree)
```

The assembled prime-field theorem is proved:

```lean
ProjectiveCap.Certificate.almostOddEscapeGameStatement_zmod_of_certificate :
  (p : Nat) -> [Fact p.Prime] ->
  PrimeGridOddEscapeBookCertificate p ->
  ProjectiveCap.Almost.OddEscapeGameStatement (K := ZMod p)
```

There is also a q=5 specialization shape:

```lean
ProjectiveCap.Certificate.almostOddEscapeGameStatement_zmod5_of_certificate :
  PrimeGridOddEscapeBookCertificate 5 ->
  ProjectiveCap.Almost.OddEscapeGameStatement (K := ZMod 5)
```

## Deferred

- Parsing the line-oriented C12 `.cert` files into Lean data.
- Proving the canonical-class bridge from a C12 `CLASS` representative to every size-three
  residual-grid position in that orbit. The scaffold marks this gap as
  `GridOddEscapeBookCertificate.represents`.
- Checking native node/row/terminal count metadata. Those counts are audit fields, not needed
  for the current semantic soundness theorem.
- GF(9). C12 supports `field GF9 base 3 poly 1 0 1`, but C14 deliberately restricts the
  assembly theorem to prime fields (`ZMod p`). GF(9) needs a parsed finite-field model and an
  equivalence to the solver's polynomial representation.

## Validation

Commands:

```bash
cd lean
nix develop --command lake build CapGame.BuildGame ProjectiveCap.Certificate
nix develop --command lake build ProjectiveCap
```

Build transcript:

```text
✔ Built CapGame.BuildGame
✔ Built ProjectiveCap.Certificate
Build completed successfully (2987 jobs).

✔ Built ProjectiveCap
Build completed successfully (3009 jobs).
```

Nix printed only the expected dirty-tree warning.

## Adversarial Review

**Parser skeptic.** This does not claim to parse C12 files. It defines the semantic contract a
parser must prove after reading the file.

**Soundness skeptic.** The proof never trusts solver game values. Soundness uses only legal move,
legal reply, exact child equality, and certified-node closure.

**Coverage skeptic.** Per-class orbit coverage is not smuggled into the checker. It is an
explicit `represents` field in `GridOddEscapeBookCertificate` and remains the next proof/parser
obligation.

**GF(9) skeptic.** Non-prime fields are not silently treated as `ZMod 9`; the report and Lean
theorem both restrict this scaffold to prime fields.
