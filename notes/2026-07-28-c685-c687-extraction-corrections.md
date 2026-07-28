# C685--C687 public formal-extraction corrections

**Lane:** `build-sys`
**Status:** QUEUED

## Fixed decisions

- The private monorepo is read-only input. No source file is deleted, renamed, or rewritten here.
- Every public repository has fresh history. Certificate repositories depend one-way on an exact
  released `finitegeom` commit; `finitegeom` never imports a certificate repository.
- Each paper repository pins only `finitegeom` and the certificate packages it actually consumes.
  There is no portfolio-wide certificate umbrella.
- A paper may publish a formal companion without claiming that the Lean result is a premise of the
  manuscript. That distinction applies to Clebsch Passages.

## C685 — Clebsch Passages formal companion

Correct the C287 intake error that inferred “no Lean to export” from the paper manifest's
`formal_coverage: none claimed`. Compute and review the exact closures of the candidate gates
`RelativeConicArcs.Gates.ClebschPassageInterfaces` and
`RelativeConicArcs.Gates.ClebschHarmonicQuotient`, and map their terminals to the manuscript's
theta, Fourier/code-transport, harmonic-quotient, and passage-interface discussion. Check
`RelativeConicArcs.Q11BrianchonPetersen` separately and include it only if the statement map makes
it a Passages companion rather than a dependency owned by another Clebsch paper.

Acceptance requires:

- a content-addressed target manifest and public-prose review for the exact companion closure;
- a `finitegeom` paper state with explicit gates, terminal ledger, and observed axiom sets;
- public wording that says the companion is kernel checked but is not claimed as load-bearing for
  the current manuscript unless the paper's verification manifest is separately revised;
- the standalone Passages repository pinning that exact `finitegeom` state and validating its
  declared optional formal companion from a clean checkout; and
- no private-history metadata or private filesystem paths in either public repository.

## C686 — Arcs q16 certificate package

Materialize `~/src/lean/finitegeom-q16-certificates` as a fresh-history repository. Put the
human-readable definitions, checker semantics, and reusable Arcs theory in `finitegeom`; put the
generated transition, row, and leaf families plus the final q16 certificate aggregate downstream
in the certificate repository. Refactor the public validation boundary so the human-scale
`finitegeom` Arcs gate does not import the downstream package.

Acceptance requires:

- exact source and target manifests covering every generated q16 transition/row/leaf consumed by
  the proof, with no unowned generated file and no unrelated family;
- a final certificate-repository gate proving the manuscript's q16 exclusion and
  `rho_C(16) = 9` terminals against a pinned released `finitegeom` commit;
- regeneration/replay identity gates required by C324, plus terminal axiom extraction;
- serialized cold build, clean-checkout replay, and pack/restore validation for the exact commits;
- the Arcs paper repository's `flake.nix`, lock, README, and verification commands pinning both
  exact repositories without machine-local paths; and
- no q16 certificate input in any paper that does not consume the q16 result.

## C687 — remaining field-specific certificate packages

Complete the same one-way split for the adopted generated families:

- Clebsch Rigidity's q11 generated orbit/action family;
- the separately declared ProjectiveCap q11 and q13 families; and
- the q25 residual/classification family after C318, C319, and C324 close its trust and replay
  gates.

Acceptance requires, for every package:

- a named consuming paper or an explicit deferred state, exact human-core/generated boundary, and
  content-addressed source/target manifests;
- a fresh-history repository with a locked one-way dependency on the released human-scale
  `finitegeom` state;
- an aggregate certificate gate, terminal ledger, observed axiom sets, regeneration status, and
  clean-checkout replay;
- paper-local flakes pinning only packages actually consumed; and
- an audit proving that no generated q11/q13/q25 family entered `finitegeom` and that no
  certificate package depends on another certificate package unless a separately reviewed
  mathematical dependency requires it.

## Release and DOI order

The first public `finitegeom` release is the recommended reviewer-scale human foundation and mints
the repository's version DOI and concept DOI. The five paper repositories then cite the
`finitegeom` concept DOI and pin the exact `finitegeom` version/commit they validated. After the
five paper releases mint their own version DOIs, a later `finitegeom` release adds reciprocal
`isSupplementTo`/`isDocumentedBy`-style related identifiers for those exact paper versions while
retaining the same `finitegeom` concept DOI.

DOI metadata never substitutes for immutable Git pins: papers cite the concept DOI for the evolving
software project and record the exact release DOI, tag, and commit used for reproducibility.
Commit and validate the complete `.zenodo.json` before the first GitHub release. Zenodo gives it
precedence over `CITATION.cff`, so it must repeat all authoritative creator, ORCID, license, title,
description, keyword, and version metadata rather than containing only Zenodo-specific additions.
Later paper DOI relations may be added to the published record metadata and to a later repository
release, but the first archived source snapshot must already contain its own complete metadata.
