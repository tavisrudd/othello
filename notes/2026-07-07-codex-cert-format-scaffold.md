# Codex C9 Lean certificate-format scaffold report (2026-07-07)

## Result

Statement-level Lean scaffold added and validated for the n=20 lucky-child certificate format.

Edited files:

- `lean/NodeKayles/Certificate.lean`
- `lean/Queens/CentralChild.lean`

The scaffold matches `2026-07-07-central-child-certificate-spec.md` at the interface level:

- final certificate node kinds:
  - `FinalCertificate.pairedCore`
  - `FinalCertificate.exceptionTable`
  - `FinalCertificate.terminal`
- terminal claim kinds:
  - `TerminalClaim.s1Leaf`
  - `TerminalClaim.tauSymmetricLeaf`
  - `TerminalClaim.solvedLeaf`
- extractor artifact wrapper:
  - `CertificateArtifact.final`
  - `CertificateArtifact.unresolved`
- unresolved leaves are rejected by `CertificateArtifact.Valid`.

The checker statement now exists in generic Node-Kayles form:

```lean
NodeKayles.FinalCertificate.isP :
  (cert : FinalCertificate G S) -> cert.Valid -> IsP G S

NodeKayles.CertificateArtifact.isP :
  (artifact : CertificateArtifact G S) -> artifact.Valid -> IsP G S
```

and in the concrete Queens target form:

```lean
Queens.N20J10LuckyTarget_of_certificate :
  (cert : N20J10Certificate) -> cert.Valid -> N20J10LuckyTarget

Queens.N20J10LuckyTarget_of_artifact :
  (artifact : N20J10Artifact) -> artifact.Valid -> N20J10LuckyTarget

Queens.firstPlayerWins20_of_N20J10Certificate :
  (cert : N20J10Certificate) -> cert.Valid -> NodeKayles.firstPlayerWins (queenGraph 20)
```

The n=18 calibration alias and theorem were also added:

```lean
Queens.N18I9Certificate
Queens.N18I9CalibrationTarget_of_certificate
```

## Scope

This is deliberately a scaffold, not the full checker. `Valid` is the semantic checker contract:

- non-terminal `pairedCore` and `exceptionTable` nodes currently require the existing
  `ReplyCertificate G S` proposition, so the soundness proof reuses the already-proved
  reply-book kernel;
- terminal leaves currently require the semantic P-claim `IsP G S`; later work can refine each
  terminal case into concrete S1-pairing, tau-pairing, or dense-leaf checkers without changing the
  outer theorem statements;
- unresolved extractor leaves are representable during generation but cannot satisfy
  `CertificateArtifact.Valid`.

This keeps the Lean side honest: signatures, tau metadata, and exception tables are artifact
shape, while soundness still flows only through `ReplyCertificate` or an explicit terminal P
claim.

## Validation

Commands:

```bash
nix develop --command lake env lean NodeKayles/Certificate.lean
nix develop --command lake build NodeKayles.Certificate
nix develop --command lake env lean Queens/CentralChild.lean
nix develop --command lake build Queens.CentralChild
```

All passed. The only emitted message was the expected dirty-tree warning from Nix.

