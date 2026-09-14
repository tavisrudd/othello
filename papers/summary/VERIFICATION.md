# Verification guide

For evidence, replay instructions, and trust boundaries, consult the individual
paper repository. Check its `verification/` directory when present; otherwise
follow the verification, artifact, supplement, or reproduction link in its
README. Check which claims those records cover: a label such as
“computer-verified” or “verified in Lean” never automatically covers every
result in a paper. This portfolio page records the common patterns without
maintaining a paper-by-paper inventory.

## Common evidence patterns

Across the portfolio, a claim may rest on one or more of the following:

1. ordinary prose mathematical proof;
2. a cited result checked against its hypotheses and conventions;
3. a Lean kernel-checked formal proof;
4. a certificate-checked finite computation; and
5. a trusted program execution or symbolic experiment.

The categories can support one another but do not collapse into one another.
A search can discover a pattern without proving it. A certificate can verify a
reported output without proving that the search domain was complete. Lean can
check a formal statement without establishing that it matches the prose claim.
The paper-specific record should identify the connection and what remains a
manuscript or computational argument.

## What the paper-level record should provide

The precise form varies with the work, but the repository-level record should
include a claim-to-evidence map, statements of the formalization and computation
boundaries, and any release or aggregate checks. It should identify the artifact
release or commit and required toolchain and dependency versions. For an
essential finite computation, it should also give the search domain, a
completeness argument and, where needed, a termination argument, symmetry
reduction, deduplication, exact-arithmetic assumptions, acceptance criterion,
inputs, replay command, expected output, and hashes. It should include an
independent replay or explain why one is unavailable.

A formal-proof boundary should name the formal theorem; disclose axioms,
admitted assumptions, and external or native computation where applicable; and
explain its correspondence with the manuscript claim.

Accordingly, a negative computational result is limited to the stated,
exhausted domain; it is not an unrestricted nonexistence claim. The shared
formal libraries support several projects, but their size does not measure the
formal coverage of any particular theorem. Consult the relevant paper's own
verification record for that coverage.
