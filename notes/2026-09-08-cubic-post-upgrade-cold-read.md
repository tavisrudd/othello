# Cubic pair: cold reviews with revision diffs

**Lane:** cubic-threefolds. **Tasks:** C978 and C956 remain open.
**User request:** one cold-read subagent on each paper, given access to the diff.
**Status:** both full cold reports recommend acceptance after minor revision; corrections applied and both authority gates pass; local synchronization pending.

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

## Parent-side documentation check (independent of referee verdicts)

The Paper 1 verification README’s opening still describes registry bundles
collectively as computational premises, whereas the newly registered universal
residue replay is explicitly supporting evidence only. Its following paragraph
already states the correct boundary. Reconcile the opening after both cold
reports are frozen. This affects documentation, not the mathematical proof.
The dependency graph has no incoming edges for the primary endpoint theorem;
that omission also occurs in the baseline and must not be attributed to this
diff. The graph’s stated partial-coverage boundary remains important.

## Referee dispositions and targeted follow-up

Both independent full reports recommend accept after minor revision. Paper 2
expressly imports the companion lower bound; its report is not another review
of that lower bound. The original reports and all nine evidence/report files
were hash-checked and committed unchanged in 16fb1adc7 before revision.

Paper 1: accepted the degree-five arithmetic correction (also checked against
Kuznetsov–Prokhorov Theorem 3.3 in the cached primary text), the explanation of
the remaining modified base pole, the distinction between homogeneous degree
and actual connection intertwining, and compression of the additive setup.
Both labelled abstract statements remain. The optional stronger formulation of
Corollary 3.1 is deferred: the existing statement is correct and the lattice
application is already proved. The verification README now distinguishes
proof-premise computations from supporting replays and describes the partial
dependency graph accurately.

Paper 2: accepted split-field evaluation notation, the early pointed Cox-form
convention, a direct split-torus invariant-field argument valid over the stated
ground field, and the two small cuts. Its source registry now records Popov’s
algebraically closed convention and the elementary argument supplying the
broader split-field range used here.

Each original reviewer received only their small repair diff for a targeted
follow-up, explicitly not another cold review. That follow-up caught two
wording regressions before validation: restore commutativity and multiset
union in the compressed Paper 1 setup, and restrict the Galois-invariant
open assertion in Paper 2 to the four types where the selected data descend.
Those exact corrections are now applied. Both reviewers approve the remaining
changes. No theorem statement, count, geometric hypothesis or formal-coverage
classification is intentionally strengthened in this revision.

The five source/metadata paths currently awaiting final validation are Paper 1
sections/02-qdm-marker.tex, sections/03-applications.tex and verification/README.md,
and Paper 2 cubic_stabilization_irrationality.tex and
verification/imported-sources.json. Rebuilt PDFs will be committed with them.

## Validation and ej + tt closeout

Both authoritative make check gates pass after the targeted corrections, with
no TeX warning. Page counts remain 20 and 19. The changed source paragraphs and
12 corresponding rendered pages were inspected, including the modified-pole
proof, grading convention, compressed setup, arithmetic paragraph, pointed Cox
model, evaluation-open convention and linearization argument. The original
full-page inspections remain recorded in the independent reports. No Lean
kernel was run; source/claim coverage and mathematical evidence gates pass.

The explicit closeout pass tested whether shortening concealed a hypothesis or
extending a field convention overreached its source. It caught and settled the
commutative-monoid and four-Galois-type qualifications before acceptance. The
split-torus argument now supplies its own arbitrary-k justification instead of
silently importing Popov’s algebraically closed field convention.

**Mystery ledger:** the initially unclear degree-five arithmetic range is
settled by the exact cited theorem; the split/descent field distinction is
settled by the local conventions and targeted review. No genuine mathematical
mystery remains from this review. Original geometric inputs remain imported,
formal coverage remains partial/absent where recorded, and the custom protocol
and broader C978/C956 author-retained obligations are not declared complete.
The optional stronger criterion adds no needed deduction and was omitted.
No incidental discovery arose outside these deliberately reviewed questions.

The first multi-file patch failed atomically on an exact-context mismatch;
no partial manuscript edit resulted. It was replaced by explicit scoped edits.
All commits in this review use --only with owned paths to avoid the shared-index
incident from the preceding task.
