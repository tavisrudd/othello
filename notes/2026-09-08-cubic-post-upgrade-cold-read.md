# Cubic pair: cold reviews with revision diffs

**Lane:** cubic-threefolds. **Tasks:** C978 and C956 remain open.
**User request:** one cold-read subagent on each paper, given access to the diff.
**Status:** two independent reviews in progress.

Each reviewer uses gpt-6-astra with a fresh context and no drafting conversation
or previous reports. Each receives the complete current primary manuscript,
its PDF and public evidence, and access to the complete paper-scoped diff from
1f368b9e2 to ad952b6f4. The immutable revisions and SHA-256/byte counts of every
paper file are recorded in the adjacent review manifest. The paper trees were
checked equal to the reviewed revision at dispatch and will remain unchanged
until both reports arrive. The diff is revision context, not correctness evidence.

Requested reports: contribution, significance/scope, correctness, exposition
and organization, major/minor comments, and reasoned editorial recommendation.
Each reviewer must distinguish errors, proof gaps, unverified inputs and
presentation requests, and state reading/computation/literature coverage.
Accessibility and whether the added material earns its two extra pages per
paper are explicit review questions. No full formal verification or exhaustive
novelty audit is requested or implied.

Reports will be retained verbatim at:

- notes/2026-09-08-c978-cold-diff-review.md
- notes/2026-09-08-c956-cold-diff-review.md

The parent independently freezes the review target, checks evidence and formal
scope consistency, and adjudicates the returned findings. Reviewers own only
their report/evidence files and are instructed not to commit or edit papers.
No manuscript change or new gate run is needed merely to dispatch this review.
