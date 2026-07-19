# Literature-audit conventions

A literature audit discharges a novelty, priority, or forward-citation claim. Its product is a
negative — "no predecessor was located" — and a negative is only as strong as the coverage behind it
and the depth at which the sources were read. This file fixes what must be recorded so that a later
reader, or a referee, can tell how strong.

## Boundary

Apply one question to the **deliverable**, not to the subtask in hand:

> **Does a deliverable depend on the absence of prior work?**

- **Yes:** these conventions bind. Typical cases are a novelty or priority verdict, forward-citation
  closure, a manuscript-bound "to our knowledge" sentence, and a pre-emption check under the
  adjacent-crown extraction rule.
- **No:** they do not. Ordinary background reading, a single lookup to settle a definition, or
  reuse of a source already recorded at full text by an earlier audit carries no obligation here.

The Attribution section binds more widely than the rest: any durable report or manuscript text that
characterises a source — a related-work section, a positioning report, an extraction task — follows
it, whether or not an absence claim is at stake.

These conventions govern how a search is recorded, with the one width exception stated in
§ "Negatives from citation graphs". All other scope belongs to the task.

## Every cited source carries a read depth

Read depth is a required field on every source the report names, drawn from this vocabulary:

| Depth                    | Record                                                          |
|--------------------------|-----------------------------------------------------------------|
| `full text`              | How the text was accessed, the version read, sections relied on |
| `partial`                | The same, and exactly which sections were read                  |
| `review only`            | Which review service                                            |
| `secondary only`         | The named secondary work, its own read depth, and where in it   |
| `abstract/metadata only` | What was retrieved, and from where                              |

**Access.** Record the cache key and SHA-256 when the bytes were cached. When they cannot be —
institutional browser access, an interlibrary or physical copy — state how the text was reached
instead. For the OCR scan sets described in `CLAUDE.md` § "Literature cache", state whether
load-bearing passages were verified against the authoritative page images.

**Version.** Record which version was read — preprint, published, edition, translation — whenever
more than one exists. A verdict about a version that was not read, such as a published paper
characterised from its preprint, is marked as such at any depth.

**Standing in for a source.** Use `review only` for a review service and `secondary only` for any
other work standing in for the source, and record the chain: a characterisation is only as strong as
the secondary work's own read depth.

The field is unconditional. A source named only in order to be dismissed carries it too. That is
precisely where omission happens: nothing rests on a dismissal, so the marker feels unnecessary until
someone later asks what the dismissal rested on. A conditional instruction — "say so if you could not
obtain the full text" — reliably produces this gap, because it reads as binding only where a finding
depends on the source.

State in the report's opening summary how many of its sources were read at full text. A report whose
verdicts rest largely on reviews is not thereby wrong, but it is a different object from one resting
on full texts, and the difference must be visible without auditing the reference list.

## Delegation

The Boundary question is asked of the deliverable, not the subtask: work that feeds a novelty,
priority, or forward-citation deliverable is bound by these conventions even when delegated in slices
whose own output is not a verdict. A prompt that dispatches audit work states the read-depth
requirement in its unconditional form. Before accepting a delegated report, the dispatching agent
verifies that every named source carries the field and that the opening-summary full-text count
matches the markers. A report failing either check is returned, or repaired only from the delegate's
actual trace — never by assuming a depth.

## Screened sets

A verdict that rests on screening a set of works — a citing-works list, a search-result page, an MSC
class — records the set's size and provenance, the fields the screen ran over (title, abstract, full
metadata), and the discriminator applied, verbatim where it was mechanical. A member promoted out of
the set for individual discussion carries the ordinary read-depth field; the rest are covered by the
set record. "Screened" is not a read depth: it says a filter was applied, and the set record says
which one, over what.

## Attribution

- Bibliographic detail — volume, issue, pages, year — comes from a consulted source or is omitted.
  Never assert it from background knowledge, and never repair an incomplete citation by recall.
- A figure, bound, or claim taken from a review is attributed to the reviewer and marked as
  unverified against the paper.
- An inference drawn from a source is marked as the auditor's own, kept distinct from the source's
  framing. Characterising what a paper "is really about" is an inference.

## Negatives from citation graphs

A citing-works count from a single graph is indistinguishable from an indexing gap, and the gap is
not confined to old records or to zeros. Whenever a verdict rests on having enumerated a citing set —
a zero, or a set that was screened exhaustively — obtain the count from OpenAlex, Crossref, and
Semantic Scholar independently, record each count separately rather than collapsing them into one
aggregate, and screen the largest set. Disagreement between them is itself a reportable finding. This
is the one width requirement these conventions impose; all other scope belongs to the task.

Resolve every seed by a pinned identifier — DOI, OpenAlex ID, arXiv ID — carried in the report, never
by title search at query time; a mis-resolved seed silently redirects its entire forward tree. Record
each load-bearing query verbatim, and state for each service how an empty result was distinguished
from an error.

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

The trust graph's evidence overlay validates literature-search records as machine metadata (C328,
scoped in [`2026-07-18-c326-trust-spine-and-dependency-graph-plan.md`](2026-07-18-c326-trust-spine-and-dependency-graph-plan.md)
§ "Evidence-extension boundary"). The read-depth vocabulary and coverage outcomes here are the source
of truth for that schema; change them together.
