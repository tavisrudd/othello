# RelativeConicArcs

Finite-geometry developments for the arcs-outside-a-conic and equivariant-robust-completion papers.
The trust boundary, axiom audits, provenance, and named classical inputs are in
[`TRUST.md`](TRUST.md); the portfolio-wide model those follow is in
[`../CERTIFICATES.md`](../CERTIFICATES.md).

## Layers

Handwritten mathematics and generated data are separate layers. Reviewing the argument means
reading the first two; the third is data the second consumes.

1. **Semantic definitions and reductions** — coordinates, the projective normalizer, orbit and
   profile structure. `Q25Coordinates`, `Q25Normalization`, `Q25PairCertificate`,
   `Q25OrbitDecomposition`.
2. **Generic checkers and their soundness theorems** — one small predicate per certificate family,
   with a handwritten theorem proving that accepted data implies the semantic statement.
   `Q16StepKernel`, `Q25MinimumChecker`, `Q25MinimumMask`, `Q25LineMaskChecker`,
   `Q25ResidualCoverBridge`.
3. **Certificate data** — the `*Data/` directories below.

## Generated data directories

Every directory listed here is **data, not argument**. Its files are machine-generated, carry a
`DO NOT EDIT` docstring naming the generator and the payload hash, and are consumed by a checker
from layer 2. Nothing in them is intended for human reading, and their file counts say nothing
about the size of the trusted surface.

| Directory | Consumed by |
|---|---|
| `Q16CertificateData/`, `Q16LeafData/` | `Q16StepKernel` coverage and leaf-rejection theorems |
| `Q25PairData/` | `Q25PairCertificate` |
| `Q25LineMaskData/`, `Q25CarrierLineData/` | `Q25LineMaskChecker` |
| `Q25RowCompositionData/`, `Q25ClassBoundData/` | `Q25LineMaskComposition`, mask lower bounds |
| `Q25ExactMinimumRows/` | `Q25ExactnessComposition` |
| `Q25ResidualCoverData/`, `Q25ResidualTransportData/` | `Q25ResidualCoverBridge` |
| `Q25ResidualDispatchData/`, `Q25ResidualClassLinkData/`, `Q25ResidualConclusionData/` | residual conclusion composition |

To regenerate any of them, use the generator named in the file docstring; regeneration is
byte-identical and any drift is a defect. Never hand-edit a generated file.

## Gate targets

Each paper-facing closure exits through one import-only module under [`Gates/`](Gates/), whose
docstring states exactly which subtrees it includes and excludes. Building a gate kernel-checks
that closure; these are the targets to build when checking a paper, in preference to the whole
library.

| Gate | Closure |
|---|---|
| `Gates/Relconic.lean` | relative-conic paper, excluding the Q25 certificate and repair subtrees |
| `Gates/Baer.lean` | Baer completion |
| `Gates/AlternateOrbitRepairQ25.lean` | Q25 alternate-orbit repair |
| `Gates/AlternateOrbitRepairParameterized.lean` | parameterized exchange |
| `Gates/AlternateOrbitRepairProfileEnvelope.lean` | general-`s` profile envelope |

Build them through the queue rather than a bare `lake build`; see [`../AGENTS.md`](../AGENTS.md)
for the shared-build-tree discipline.
