# Literature-audit conventions

A literature audit discharges a novelty, priority, or forward-citation claim. Its product is a
negative — "no predecessor was located" — and a negative is only as strong as the coverage behind it
and the depth at which the sources were read. This file fixes what must be recorded so that a later
reader, or a referee, can tell how strong.

## Boundary

Apply one question to the task at hand:

> **Does a deliverable depend on the absence of prior work?**

- **Yes:** these conventions bind. Typical cases are a novelty or priority verdict, forward-citation
  closure, a manuscript-bound "to our knowledge" sentence, and a pre-emption check under the
  adjacent-crown extraction rule.
- **No:** they do not. Ordinary background reading, a single lookup to settle a definition, or
  reuse of a source already recorded at full text by an earlier audit carries no obligation here.

These conventions govern how a search is recorded, not how wide it must be. Scope belongs to the
task.

## Every cited source carries a read depth

Read depth is a required field on every source the report names, drawn from this vocabulary:

| Depth                    | Record                                                     |
|--------------------------|------------------------------------------------------------|
| `full text`              | Cache key and SHA-256; the sections relied on               |
| `partial`                | Cache key and SHA-256; exactly which sections were read     |
| `review only`            | Which review — zbMATH, MathSciNet, or another named service |
| `abstract/metadata only` | What was retrieved, and from where                          |

The field is unconditional. A source named only in order to be dismissed carries it too. That is
precisely where omission happens: nothing rests on a dismissal, so the marker feels unnecessary until
someone later asks what the dismissal rested on. A conditional instruction — "say so if you could not
obtain the full text" — reliably produces this gap, because it reads as binding only where a finding
depends on the source.

State in the report's opening summary how many of its sources were read at full text. A report whose
verdicts rest largely on reviews is not thereby wrong, but it is a different object from one resting
on full texts, and the difference must be visible without auditing the reference list.

## Attribution

- Bibliographic detail — volume, issue, pages, year — comes from a consulted source or is omitted.
  Never assert it from background knowledge, and never repair an incomplete citation by recall.
- A figure, bound, or claim taken from a review is attributed to the reviewer and marked as
  unverified against the paper.
- An inference drawn from a source is marked as the auditor's own, kept distinct from the source's
  framing. Characterising what a paper "is really about" is an inference.

## Negatives from citation graphs

A zero citing-works result from a single graph is indistinguishable from an indexing gap, and the gap
is not confined to old records. Confirm every load-bearing zero in OpenAlex, Crossref, and Semantic
Scholar independently, and record each count separately rather than collapsing them into one
aggregate. Disagreement between them is itself a reportable finding.

## Coverage statement

Name every intended source that was not reachable, and why. Keep two outcomes strictly apart:

- **searched and found nothing** — licenses a negative;
- **could not access** — licenses nothing, and must be carried forward as an open gap.

MathSciNet requires institutional authentication and is generally unreachable from an agent session;
when so, record it as NOT COVERED and keep "to our knowledge" on every claim it would have gated.
zbMATH Open is freely reachable. Google Scholar blocks automated access.

## Caching

Every fetched source is added to the shared literature cache with its key and SHA-256; see
`CLAUDE.md` § "Literature cache: load on demand". The cache records fetched bytes, not that a paper
was read — read depth lives in the audit report and is never inferred from cache presence.

## Relationship to other records

The audit report is the durable artifact and owns the verdicts. Incidental observations met while
searching follow [`discovery-track-conventions.md`](discovery-track-conventions.md). Recommended
wording changes to an earlier positioning report are written up for the owning lane rather than
applied across lanes by the auditing task.
