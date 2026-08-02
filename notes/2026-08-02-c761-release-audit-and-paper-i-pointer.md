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
passant_code_q13.tex  ad046524458049c0041fa2d8dfed7247f232783fbf3b0276fae00e4f97aef5ac
passant_code_q13.pdf  5fd1227940ded1391be075dabafc3bacbb9e335ba4a29d064f223c98d8fbe550
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

## Milnor--Serre exposition closeout

The final copy-edit pass moves the theorem before the literature paragraph,
assigns spanning, reconstruction, and symmetry to their correct mechanisms in
the abstract, and expands the equality case behind the weight-eight arc
reduction.  It also proves that the tangent-product quotient is well defined,
displays the four weight-twelve multiplicity domains, states the equivariance
behind the intersection-table check, and makes the automorphism-span argument
intrinsic.

The verification section is compressed to its mathematical claim map,
manuscript-facing formal conclusions, named terminals, native-evaluation
boundary, and two remaining human transports.  Detailed shard inventories stay
in the accompanying artifact.  The conclusion now ends with the mathematical
division of labor among concurrence, the binary association algebra, and the
four anchors.  A fresh forced check rebuilt the seven-page PDF with no TeX
warnings.

## Independent cold-read closure

A context-free subagent read only the style guide and final manuscript.  It
returned GO WITH MINOR REVISIONS at 88/100: the theorem, language changes, and
reason for distance twelve were clear, while four finite/trust interfaces were
too compressed.

The revision defines the order-fourteen projective map and the three cyclic
orbits, then states the exact four-subset census behind the five-row clique
closure.  It gives the XOR split, key, acceptance criterion, and domain sizes
for both weight-ten exclusions.  The four weight-twelve domains now state
their individual meet-in-the-middle splits and output counts 0,0,0,56.
The six pair/triple concurrence signatures and the complete
1716-to-78 seven-clique census are printed in the manuscript.

A five-row proof-mode table now separates the cited theorem, human reductions,
classical tangent input, finite certificates, native Lean evaluation,
kernel-checked transports, and the two human globalizations.  The source
archive's persistent repository-relative README paths, public replay command,
and expected success marker are explicit.  Native evaluation is identified as
compiled trusted execution exposed by declaration-local axioms.  The immutable
external artifact locator remains the release-packaging gate recorded below.
A fresh forced check rebuilt the eight-page PDF with no TeX warnings.

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
- **Settled:** the prose had described three secant-count families but the
  formal package correctly used four multiplicity domains.  The manuscript now
  displays all four domains and explains their common fixed-point exhaustion.
- **Settled:** the context-free cold read found four compressed finite/trust
  interfaces.  Exact cyclic coordinates, finite algorithms, concurrence
  signatures, the clique census, and the proof-mode table now close them.
- **Open, owned by C761 release packaging:** the final public repository shape
  and immutable locator do not yet exist.  The evidence gap is exactly a fresh
  isolated replay from pinned public dependencies.
- **No mathematical or exposition mystery remains in the C761 theorem
  surface.**
