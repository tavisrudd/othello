# C365 — adversarial review of the literature-audit conventions

**Lane**: `build-sys`

**Date:** 2026-07-19
**Reviewed:** `notes/literature-audit-conventions.md` as committed in `6757363b`, and the pointer
paragraph added to `CLAUDE.md` § "Literature cache: load on demand" in the same commit.
**Inputs:** the C363 audit that exposed the failure
(`notes/2026-07-19-c363-alt-orbit-repair-citation-audit.md`), the sibling
`notes/discovery-track-conventions.md`, the C328 queue row and
`notes/2026-07-18-c326-trust-spine-and-dependency-graph-plan.md` § "Evidence-extension boundary",
and two practice samples of how these audits are currently written:
`notes/2026-07-18-c349-arcs-prepublication-novelty-closure.md` and the literature gates in
`notes/2026-07-18-c334-implied-crowns-portfolio.md`. This review is advisory; no reviewed file was
edited.

## Verdict

The central diagnosis — a conditional instruction is applied only where a finding rests on the
source — is correct, and the unconditional per-source field plus the opening-summary full-text
count is the right mechanism for the sources a report names individually. The Attribution and
Coverage sections directly close the volume-number and gloss-as-framing failures from C363. The
register matches the discovery-track sibling.

The doc is not fit to publish as-is. Two confirmed defects reopen the same failure class it was
written to close: it never addresses delegation, which is where the C363 failure actually occurred,
and it leaves bulk-screened citation sets — on which most of C363's verdicts rest — entirely
outside the read-depth requirement. The remaining defects are additive amendments, not a rewrite.

## Confirmed defects, by severity

### 1. Major — the delegation path is unaddressed, and it is the path the failure took

The C363 under-marking was produced by a sub-agent following a parent-written prompt. The doc's own
diagnosis makes the omission glaring: it states that "a conditional instruction — 'say so if you
could not obtain the full text' — reliably produces this gap", then provides no rule about how the
requirement reaches a delegate or how compliance is checked on receipt. A delegate never reads this
doc; it reads the dispatching prompt. A parent who reads the doc, paraphrases it conditionally into
a sub-prompt, and accepts the returned report reproduces C363 exactly, while following the doc
literally.

The Boundary question compounds this: "Does a deliverable depend on the absence of prior work?" is
asked of "the task at hand". A delegated slice — "list and screen the citing works of these seeds"
— can truthfully answer no for its own task and route out, even though its output feeds a novelty
verdict.

Concrete failure permitted: an audit split across sub-agents where every slice is under-marked, the
parent assembles the verdicts, and the assembled report satisfies the doc because the parent names
few sources itself.

Proposed fix — add a section after "Every cited source carries a read depth":

> ## Delegation
>
> The Boundary question is asked of the deliverable, not the subtask: work that feeds a novelty,
> priority, or forward-citation deliverable is bound by these conventions even when delegated in
> slices whose own output is not a verdict. A prompt that dispatches audit work states the
> read-depth requirement in its unconditional form. Before accepting a delegated report, the
> dispatching agent verifies that every named source carries the field and that the opening-summary
> full-text count matches the markers. A report failing either check is returned, or repaired only
> from the delegate's actual trace — never by assuming a depth.

### 2. Major — bulk-screened sets carry no depth record

The field binds "every source the report names". Most of C363's negative evidence rests on sources
it does not name: the 49 Semantic Scholar citations of Ball–Lavrauw ("were screened"; one named),
the 388 reconfiguration citing works dismissed by a keyword regex, and the 12 + 28 citing works
"screened" for claim 2. Even C363, the corrective model, never states which fields its regex ran
over — titles, abstracts, or full metadata. Under the doc as written, a report may say "screened
400 citing works, none relevant" with no obligation to disclose that the screen was title-only.
That is the original hole, moved one level up: nothing rests on any individual dismissed member, so
no marker attaches anywhere.

Proposed fix — add a section after the read-depth section (or fold into it):

> ## Screened sets
>
> A verdict that rests on screening a set of works — a citing-works list, a search-result page, an
> MSC class — records the set's size and provenance, the fields the screen ran over (title,
> abstract, full metadata), and the discriminator applied, verbatim where it was mechanical. A
> member promoted out of the set for individual discussion carries the ordinary read-depth field;
> the rest are covered by the set record. "Screened" is not a read depth: it says a filter was
> applied, and the set record says which one, over what.

### 3. Moderate — "Negatives from citation graphs" contradicts the doc's scope claim and covers only zeros

Two defects in one section, fixable by one rewrite.

First, the internal contradiction. The Boundary section states: "These conventions govern how a
search is recorded, not how wide it must be. Scope belongs to the task." The multi-graph rule then
mandates width: "Confirm every load-bearing zero in OpenAlex, Crossref, and Semantic Scholar
independently." An agent handed a task scoped to zbMATH can cite the scope sentence to skip the
triple confirmation — precisely the load-bearing-zero failure the rule exists to prevent.

Second, the zero-only scope. The demonstrated indexing gap in C363 was not a zero: OpenAlex
reported 0 citing works for Ball–Lavrauw where Crossref reported 21 and Semantic Scholar 49, and
the audit's screen was sound only because it took the 49. C349 screened a citing set from OpenAlex
alone (3 works). A single-graph count of 3 where another graph knows 40 hides the pre-empting
successor by the same mechanism as a false zero. The rule as written does not touch this case.

Proposed replacement for the section body:

> A citing-works count from a single graph is indistinguishable from an indexing gap, and the gap
> is not confined to old records or to zeros. Whenever a verdict rests on having enumerated a
> citing set — a zero, or a set that was screened exhaustively — obtain the count from OpenAlex,
> Crossref, and Semantic Scholar independently, record each count separately rather than collapsing
> them into one aggregate, and screen the largest set. Disagreement between them is itself a
> reportable finding. This is the one width requirement these conventions impose; all other scope
> belongs to the task.

and amend the Boundary sentence to: "These conventions govern how a search is recorded, with the
one width exception stated in § 'Negatives from citation graphs'. All other scope belongs to the
task."

### 4. Moderate — the vocabulary has no value for secondary-source characterisation

C363 contains a real case the four values cannot express: Kéri's paper was "characterised from
Sticker's description of it" — not full text, not partial, not a review service, and more than
abstract/metadata. The `review only` Record column ("Which review — zbMATH, MathSciNet, or another
named service") excludes a citing work or thesis used as the characterising source. An agent
hitting this case must either mislabel or improvise, and improvised markers are what the vocabulary
exists to prevent.

Proposed fix — add a row to the table:

```markdown
| `secondary only`         | The named secondary work consulted, its own read depth, and where in it |
```

with one sentence below the table: "Use `review only` for a review service, `secondary only` for
any other work standing in for the source, and record the chain — a characterisation is only as
strong as the secondary work's own read depth."

### 5. Moderate — the `full text` record is unrecordable for uncacheable reads, and no depth records the version read

Two related gaps in the Record column.

First, `full text` requires "Cache key and SHA-256". A paper read in full via institutional browser
access, a physical or interlibrary copy, or any source whose bytes cannot be captured has no cache
key; the honest agent cannot fill the row as specified. The user-supplied scan sets that CLAUDE.md
describes are cacheable but differ in fidelity: full text via OCR reconstruction, verified against
page images, is not the same object as a publisher PDF, and the field cannot currently say so.

Second, no depth records which version was read. This is not hypothetical: C349's primary theorem
was read from the cached arXiv v1 full text, with the version of record confirmed only via the
publisher abstract — a composite the vocabulary cannot express — and C143 cites Ball–Lavrauw by
arXiv link while the published version carries a DOI one digit away from a different paper. A
novelty verdict about a published version characterised from its preprint, translation, or earlier
edition is a version gap that the current field silently absorbs.

Proposed replacement for the `full text` Record cell:

```markdown
| `full text` | Cache key and SHA-256, or, when the bytes cannot be cached, how the text was accessed; the exact version read (preprint, published, edition, translation) when more than one exists; for OCR scan sets, whether load-bearing passages were verified against the page images; the sections relied on |
```

plus one sentence: "A verdict about a version not read — a published paper characterised from its
preprint — is marked as such at any depth."

### 6. Moderate — the Boundary excludes manuscript-bound characterisation that makes no absence claim

Compare the discriminators. The discovery-track question ("Was I looking for this?") is
first-person and answerable at write time; this doc's question requires forecasting what a
deliverable depends on, and it routes out a task class where the C363 failures demonstrably recur:
manuscript-bound characterisation of prior work with no novelty claim at stake. A related-work
section, a positioning report, or a publication-extraction task (the currently queued C362 is
exactly this shape) asserts bibliographic detail, quotes reviewer summaries, and glosses what
papers "are really about" — the volume-number fabrication and gloss-as-framing failures live there
as much as in audits — yet under the Boundary as written, none of the Attribution rules bind.

No damaging over-inclusion was found in the other direction: background reading and definition
lookups are cleanly excluded, and a bounded pre-emption check acquires only recording obligations
plus the (post-fix-3) single width exception.

Proposed fix — add one bullet to the Boundary section rather than widening the whole doc:

> - The Attribution section binds more widely: any durable report or manuscript text that
>   characterises a source — a related-work section, a positioning report, an extraction task —
>   follows it, whether or not an absence claim is at stake.

### 7. Moderate — seed pinning and query recording are omitted

"How a search is recorded" is the doc's declared scope, and the single most consequential
mechanical lesson of C363 is not in it: resolving the Ball–Lavrauw survey by an assumed DOI
returned a different paper entirely (`10.4171/emss/28`, Proudfoot), and only pinned OpenAlex IDs in
the generator prevented the whole forward tree from being traced from the wrong root. The doc also
never asks that load-bearing queries be recorded verbatim, or that an empty-result signal be
distinguished from an error signal per service (zbMATH returns 404 for an empty result set; C363
had to confirm this by perturbation). The reproducibility section of CLAUDE.md covers audits that
ship a script and JSON; an audit run as interactive API queries in-session is covered by nothing.

Proposed fix — append to "Negatives from citation graphs" (post-fix-3 text):

> Resolve every seed by a pinned identifier — DOI, OpenAlex ID, arXiv ID — carried in the report,
> never by title search at query time; a mis-resolved seed silently redirects its entire forward
> tree. Record each load-bearing query verbatim, and state for each service how an empty result was
> distinguished from an error.

### 8. Moderate — no durable link to the C328 evidence-metadata layer

C328 owns "literature-search record validation and freshness policy" and a bounded assessment
vocabulary (C326 plan, § "Evidence-extension boundary"). These records — read depth, coverage
outcomes, per-graph counts — are exactly what C328 will validate as machine metadata. The only
statement of that relationship is the C365 queue row ("C328 later validates these as trust-graph
evidence metadata"), which the hard completion invariant deletes when C365 closes. The C328 row
does not name this doc, and the C326 plan predates it. Result: two vocabularies that must not
drift, connected by nothing durable. The caller's own standard applies — duplication that will
drift apart is a defect.

Proposed fix — add to "Relationship to other records":

> The trust graph's evidence overlay validates literature-search records as machine metadata
> (C328, scoped in `notes/2026-07-18-c326-trust-spine-and-dependency-graph-plan.md`
> § "Evidence-extension boundary"). The read-depth vocabulary and coverage outcomes here are the
> source of truth for that schema; change them together.

### 9. Minor — the CLAUDE.md pointer enumerates the doc's contents

The added paragraph's second sentence lists four internal features ("It fixes the required
per-source read-depth field, attribution of review-derived figures, multi-graph confirmation of
citation zeros, and the coverage statement…"). Every amendment above changes that list; CLAUDE.md
is the "short and stable" layer and this summary will go stale on the first revision. The
discovery-track pointer is the house pattern: it names when the doc binds, not what is inside it.
The first sentence — trigger cases plus link — is exactly right and should stand alone.

Proposed replacement for the paragraph:

> When a deliverable depends on the absence of prior work — a novelty or priority verdict,
> forward-citation closure, a manuscript-bound "to our knowledge" sentence, or a pre-emption check —
> follow [`notes/literature-audit-conventions.md`](notes/literature-audit-conventions.md) for how
> the search and every consulted source must be recorded.

## Judgment calls — defensible as written, I would decide differently

- **"searched and found nothing — licenses a negative"** licenses it only over the searched scope,
  which the sentence does not say. CLAUDE.md already forbids promoting finite exhaustion into
  unrestricted nonexistence for computational results; one word aligns them: "licenses a negative
  over the searched scope". The current text is defensible because the surrounding doc repeatedly
  bounds negatives, and C363 models the practice.
- **Service-access facts will drift.** "MathSciNet … is generally unreachable", "zbMATH Open is
  freely reachable", "Google Scholar blocks automated access" are empirical claims in a live doc.
  Defensible: they are defaults, and the coverage rule conditions on the actual outcome ("when
  so"). If any changes, the doc needs a hand edit that nothing will prompt.
- **Audit staleness is unstated.** An audit certifies a dated snapshot of live indexes; nothing
  says when a verdict must be re-run before a manuscript ships. Freshness policy is explicitly
  C328's, so silence is a defensible scope choice; one sentence ("an audit certifies its date;
  freshness policy is owned by the evidence layer") would cost nothing.
- **"Every source the report names"** literally includes repo-internal reports (C363 names C143
  throughout). A reasonable reader excludes them; inserting "external" would pin it.

## What is sound

- The conditional-instruction diagnosis matches the C363 trace exactly, and stating the mechanism
  in the doc — not just the rule — is what will make future prompt-writers recognise the trap.
- The unconditional field plus the opening-summary full-text count is the right mechanism for named
  sources; the summary count makes the report's character visible without auditing the reference
  list, which is the property C363 lacked until repaired.
- The Attribution section closes the volume-number and gloss-as-framing failures as stated; its
  third bullet ("Characterising what a paper 'is really about' is an inference") is the sharpest
  sentence in the doc.
- The Coverage statement's two-outcome separation is sharp, correctly ordered (could-not-access
  licenses nothing), and matches both C363 and C349 practice.
- The Caching section correctly restates fetched-bytes-is-not-read and puts read depth in the
  report, not the cache.
- Register and structure match the discovery-track sibling: same Boundary blockquote pattern, same
  yes/no bullets, same length class. It reads as a sibling, not a different genre.
- The doc satisfies the repo's own standards: no numeric counts, no timelines, no transcripts, no
  superseded-plan residue.

## Recommended order of application

Findings 1 and 2 before any audit runs under the doc — each reopens the C363 class on its own.
Findings 3–7 in the same revision if convenient; they are localized insertions. Findings 8–9 touch
CLAUDE.md and can ride the same commit.
