# C761 — Paper IV release audit and Paper-I forward pointer

**Lane:** `clebsch`

**Date:** 2026-08-02

## Verdict

The authoritative Paper-IV manuscript, paper-owned exact evidence, warning
gate, and pinned local Lean aggregate are green.  The Paper-I forward pointer
is also green: both the main manuscript and computational companion cite
Paper IV as the standalone structural and reproducible account, while the
companion identifies its q13 material as the historical computational source.
No Paper-I source change is required by this audit.

Paper IV is not yet ready for external publication.  Two release objects are
missing:

1. the certificate package still imports the semantic library through the
   repository-relative path `../../../lean`, so a fresh public checkout cannot
   replay from pinned public dependencies; and
2. neither the manuscript/evidence bundle nor the Lean bundle has an immutable
   public archival locator.

Publication also remains outside this pass without explicit publication
authority.  These are release-packaging and authority gates, not theorem,
proof, evidence, or PDF defects.

## Checked release surface

From `papers/q13-passant-code`:

```sh
make -B check
```

The gate passed the canonical weight-ten regeneration, independent
weight-ten replay, full exact q13 replay, semantic rank-data regeneration,
TeX spacing lint, PDF build, and zero-warning check.  The exact replay reported
rank 42, code dimension 36, minimum distance 12, 364 minimum words, recovery of
all 78 rows, and automorphism group `PGL(2,13)`.  The tracked source and PDF at
the audit point have SHA-256 hashes

```text
passant_code_q13.tex  61899fe418589b14234a5be69e83b2339f95e3e4ab04ec960e756f3e071e07cf
passant_code_q13.pdf  4932bf7fcd309da596eeae97a85cd6e8266e0181e054e045b87644076bdba893
```

The guarded exact-target Lean queue checked
`PassantCodeQ13.Gates.Main` and
`PassantCodeQ13.Gates.AxiomAudit`, then passed the trace-only aggregate gate.
Both targets were content-current under Lean `v4.32.0-rc1`.  A scoped review of
the paper-owned package and its shared `RelativeConicArcs.PassantCodeQ13`
closure found no task/lane/agent vocabulary, workflow placeholders, private
paths, `sorry`, `admit`, declared axioms, or opaque declarations.  Native
evaluation remains disclosed by the declaration-level axiom audit and by the
manuscript's trust-boundary section.

## Paper-I pointer

The accepted forward-version text is already present:

- `clebsch_rigidity.tex` says that Paper IV extracts the exact q13 binary
  incidence-code theorem into its own structural and reproducible account and
  names it in the four-paper sequence;
- `clebsch_rigidity_computational_companion.tex` says that the q13 section is
  the historical computational source and that the current paper-level proof
  and evidence surface belong to Paper IV; and
- both manuscripts cite the bibliographic entry `RuddPassant2026` with the
  frozen Paper-IV title.

This matches C762's accepted ownership boundary: Paper I preserves historical
provenance without presenting the result as a current Paper-I claim.  Once a
stable Paper-IV locator exists, the word `forthcoming` and the bibliographic
entry must be replaced by that locator in the synchronized forward Paper-I
release.

## Remaining release gate

Cut public source and Lean repositories or archives, replace the local Lean
path dependency with a pinned public dependency, replay both bundles from
fresh isolated checkouts, record their immutable locators and hashes, update
the Paper-I citation from `forthcoming`, and only then publish with explicit
authority.

## Mystery ledger

- **Settled:** the apparent missing Paper-I pointer was stale routing state;
  C762 had already integrated and cold-read the correct forward pointer.
- **Open, owned by C761 release packaging:** the final public repository shape
  and immutable locator do not yet exist.  The evidence gap is exactly a fresh
  isolated replay from pinned public dependencies.
- **No mathematical mystery remains in the C761 theorem surface.**
