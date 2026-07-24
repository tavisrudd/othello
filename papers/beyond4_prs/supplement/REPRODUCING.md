# Reproducing the computational supplement

The exact current artifact paths, working directories, commands, searched
domains, stop conditions, and trust boundaries are recorded in
`../verification-map.md`.  That file is the source of truth during manuscript
development.  Before release, this document will be generated into a
self-contained archive view with the same literal commands and no
repository-relative ambiguity.

## Required release environment

The monorepo is development infrastructure and is not a publication
artifact.  The immutable release must be built from a reviewed,
paper-specific fresh-history export and record:

- public paper-export repository URL, tag, and commit;
- archive identifier and DOI;
- operating-system and architecture;
- Python, Rust, Lean, and Lake versions where applicable;
- exact working directory for every command;
- generator, certificate, replay, and manifest SHA-256 values and byte counts.

The export contains only the manuscript, public supplement, minimal
verifiers/certificates, adequacy/provenance sources, and a pin to one
shared-public-Lean commit with an exact target list.  It does not contain or
link to the private monorepo as the release repository.

## Replay semantics

The release manifest assigns every replay one of the schema labels
**rederive**, **reconstruct**, or **compare** from
`CERTIFICATE-SCHEMA.md`.  A successful comparison-only replay is never
described as an independent derivation.

## Development replay map

| Public label | Domain/stop condition | Replay boundary |
|---|---|---|
| Certificate R5 | nineteen recorded fields; pointwise and orbitwise exhaustion | independent Python replay |
| Certificate R6 | direct scan through \(q=16\); structural bridge thereafter | independent replay plus radius gate |
| Certificate R6-NF | recorded small exceptional normal forms | same-file deterministic checker |
| Certificate R7 | \(q=7,8,9,11\) census and the finite coherent-polar bridge below 37 | independent five-secant and orbit checks |
| Certificate R8 | characteristic cases and numerical bounds, not an ambient census | independent algebra/nucleus replay |
| Certificate R9 | residual algebra, all recorded slice normal forms, and the public Bezout vectors | independent residual/slice replay plus exact supplement transcription check |
| Certificate R9-49 | the characteristic-seven carrier at \(q=49\) | one exhaustive carrier implementation |
| Certificate Hessian | bounded algebra regression | does not replace the geometric proof |
| Certificate Lucas | recorded Lucas arithmetic parameter domain | independent arithmetic replay |
| Certificate e7 | recorded quotient-cover open set and additive specialization | independent quotient-cover replay |

Literal commands and internal artifact names remain in
`../verification-map.md` until the release archive supplies stable paths.
