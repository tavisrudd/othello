# Verification guide

This portfolio page does not maintain a paper-by-paper verification inventory.
The individual paper repository is the source of truth for its evidence,
replay instructions, and trust boundary. Check its `verification/` directory
when present; otherwise follow the verification, artifact, supplement, or
reproduction link in its README. Those records state which claims they cover;
a label such as “computer-verified” or “verified in Lean” never automatically
covers every result in a paper.

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
Each paper therefore states what its evidence covers and what remains a
manuscript or computational argument.

## What the paper-level record should provide

The precise form varies with the work, but the repository-level record normally
includes a claim-to-evidence map, a statement of the formalization and
computation boundaries, and any release or aggregate checks. For an essential
finite computation, it should also give the search domain, completeness or
termination argument, symmetry reduction, deduplication, exact-arithmetic
assumptions, acceptance criterion, inputs, replay command, expected output, and
hashes. It should include an independent replay or explain why one is
unavailable.

Accordingly, a negative computational result is limited to the stated,
exhausted domain; it is not an unrestricted nonexistence claim. The shared
formal libraries support several projects, but their size does not measure the
formal coverage of any particular theorem. Consult the relevant paper's own
verification record for that coverage.
