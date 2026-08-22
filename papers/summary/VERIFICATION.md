# Verification map

This document routes readers from the portfolio summary to each paper's
detailed evidence map. It is a repository-level index, not itself a
claim-by-claim ledger: those ledgers and boundaries live in the individual
paper repositories. No label such as “computer-verified” or “verified in Lean”
is intended to cover every theorem in a paper.

## Evidence categories

The papers distinguish five kinds of support:

1. ordinary prose mathematical proof;
2. a cited result checked against its hypotheses and conventions;
3. a Lean kernel-checked formal proof;
4. a certificate-checked finite computation; and
5. a trusted program execution or symbolic experiment.

The categories can support one another but do not collapse into one another.
A search can discover a pattern without proving it. A certificate can verify a
reported output without proving that the search domain was complete. Lean can
check a formal statement without establishing that it matches the prose claim.
Each paper therefore states what its evidence covers and what remains a
manuscript or computational argument.

## Paper entry points

| Paper or group | Evidence and stated boundary |
|---|---|
| Clebsch I and its computational companion | The [verification surface](https://github.com/tavisrudd/clebsch-rigidity/tree/main/verification) separates structural arguments from finite censuses; generated `q = 11` material is independently checked in the [certificate repository](https://github.com/tavisrudd/finitegeom-clebsch-q11-certificates). |
| Clebsch II | The [verification directory](https://github.com/tavisrudd/clebsch-factorization/tree/main/verification) records statement identity, proof mode, certificates, replays, and the aggregate release check. |
| Clebsch III | [ARTIFACT.md](https://github.com/tavisrudd/clebsch-passages/blob/main/ARTIFACT.md), the [literature boundaries](https://github.com/tavisrudd/clebsch-passages/blob/main/literature-boundaries.md), and the [release checks](https://github.com/tavisrudd/clebsch-passages/tree/main/verification) separate artifact, literature, and formalization claims. |
| Clebsch IV | The [public repository](https://github.com/tavisrudd/q13-passant-code) identifies the exact minimum-word certificates and the boundary between structural proof and finite verification. |
| Clebsch V | The [verification directory](https://github.com/tavisrudd/chordal-conference-reconstruction/tree/main/verification) states that the classification is proved in the text and that the exact `F_11` evidence program only replays the one source-dependent normalization leaf. There is no formalization: the Lean companion is deferred. |
| Irrationality after one stabilization | The [public repository](https://github.com/tavisrudd/cubic-stabilization-m1) separates the prose birational argument, the exact computational artifacts, and the claim-specific Lean formalization boundary. |
| Discrepancy-one flips | The [public repository](https://github.com/tavisrudd/discrepancy-one-flips) records the source-local theorem repair and the boundary between the cited Shen--Shoemaker argument, the cone membership proved here, and the two added steps. There is no computational or formal artifact: every claim is proved in the text. |
| Gamma point rows under quantum wall crossing | The [verification directory](https://github.com/tavisrudd/cubic-stabilization-irrationality/tree/main/verification) checks the public conditionality boundary and the exact cubic-endpoint regression. It explicitly does not machine-verify Barnes asymptotics, quantum Künneth, virtual localization, the rank-one derived clutching theorem, marked threshold compatibility, or the conditional birational transport theorem. |
| Arcs complete outside a conic | The [public repository](https://github.com/tavisrudd/arcs-complete-outside-conic) distinguishes general proofs and Lean-formalized identities from certificate-checked or trusted finite classifications. |
| Projective Reed–Solomon deep holes | The supplement gives [replay instructions](https://github.com/tavisrudd/beyond4-prs/blob/main/supplement/REPRODUCING.md), public classification records, and a [declaration-level Lean trust map](https://github.com/tavisrudd/beyond4-prs/blob/main/supplement/LEAN-STATEMENTS.md). |
| Stabilizer AME rigidity | The [formal boundary](https://github.com/tavisrudd/ame-lu#formal-boundary) names the kernel-checked cores and the quantitative and global arguments that remain manuscript proofs. |
| MDS–CSS transversal groups | The [claim-level evidence report](https://github.com/tavisrudd/mds-css-transversal-groups/blob/main/supplement/EVIDENCE.md) separates all-length conceptual theorems, six-point certificates, and formal coverage. |
| Balanced conference-cut spectra | The [evidence map](https://github.com/tavisrudd/conference-cut-spectra/blob/main/verification/EVIDENCE.md) records claim-level checks; the manuscript is a theory and design-limit analysis, not a report of a built device. |

For an essential finite computation, the retained bundle should specify the
search domain, completeness or termination argument, symmetry reduction,
deduplication, exact-arithmetic assumptions, acceptance criterion, inputs,
command, expected output, and hashes. It should include an independent replay
or state why one is unavailable. A negative result is correspondingly phrased
as “nothing was found in this exhausted domain,” not as an unrestricted
nonexistence claim.

The shared [finitegeom](https://github.com/tavisrudd/finitegeom) repository is
a substantial formal library, but its size does not measure coverage of any
particular theorem; the paper-level maps above are the relevant claims.
