# C904 Paper V remediation rereview manifest

**Lane:** `clebsch`

**Date:** 2026-08-11

**Status:** frozen repaired surface

**Manuscript:** *The Golden Companion Correspondence*

## Frozen surface

- repair commit: `2fcac765eacf3c8685addf484ceb3093615c173a`;
- source:
  `papers/clebsch-round-trip/golden_companion_reconstruction.tex`;
- source SHA-256:
  `071265e252b1dae4870a282e4d34bbaf2092bcbee26a89f2146c623c5a9f8036`;
- rendered PDF:
  `papers/clebsch-round-trip/golden_companion_reconstruction.pdf`;
- PDF SHA-256:
  `fffe903ea1fdd664173e48030aad5086df09c0e7c7bfcbaa7aee1662f2915543`;
- visible length: twenty pages;
- PDF size: 170406 bytes;
- build: `make evidence` and `make check` pass under the repository Nix
  environment; the TeX log has no warning, underfull, or overfull line.

## Purpose

This is a new review surface.  It repairs the findings frozen at commit
`82317c1c` without narrowing a hypothesis, conclusion, equivalence, or
base-change statement.  The old reports remain immutable evidence about the
eighteen-page surface and must not be shown to the rereaders.

The rereview uses the workflow, isolation rules, verdict definitions, and
report schema of
`notes/2026-08-11-c904-paper-v-cold-referee-protocol.md`, with the frozen
hashes above substituted for its original surface.  A rereader receives the
new PDF, its packet, and the permitted sources only.  They do not receive an
old report, this repair description, a proposed answer, or another rereview.

## Causal chains to retest

The packet assignments remain O, G, C/L, R, and IV/T.  The rereaders must
independently test the whole assigned proof, with particular attention to:

1. whether the printed Paper-II transport and termwise scalar comparison are
   now sufficient without opening an executable certificate;
2. whether the characteristic-eleven chordal-member scheme is proved to be
   exactly two reduced geometric points and remains so after neutral scalar
   extension;
3. whether normalizer relabeling, twisted equivariance, conference switching,
   selected-line data, and the residual `uq` action define honest groupoids
   and prove full faithfulness on morphisms;
4. whether the scalar (8) is fixed by an explicit human coefficient
   comparison;
5. whether the natural (mathbf F_4A_5)-module, its endomorphism field, the
   quotient line, and the nonsplit extension are established intrinsically;
6. whether the Paper-IV comparison is tied to a stable named result and is a
   structural consequence rather than a decorative analogy.

The holistic rereader receives only the PDF and the neutral Stage-A prompt.
All reports freeze before synthesis.
