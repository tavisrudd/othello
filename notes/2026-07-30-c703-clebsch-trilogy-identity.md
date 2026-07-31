# C703 — Clebsch trilogy identity

**Lane:** `clebsch`

**Date:** 2026-07-30

**2026-07-31 refinement:** The shared refrain now sits in small italics
immediately below each complete title block rather than opening the
Introduction.  The active Roman numeral and its corresponding clause---takes
shape, finds its bearings, or stands fixed while its shadows move---are bold.
No explanatory fine print was added.

## Verdict

Papers I--III now read unmistakably as a trio under the shared series
identity

> **The Clebsch cubic**  
> *Recovering, orienting, and realizing — I/II/III*

The banner is a reader-facing series mark, not part of any paper's canonical
title.  In particular, Paper II remains *Quadratic trade rigidity and cubic
orientation in conic matching quotients*: its title, abstract, principal
theorem, hypotheses, and proof dependencies remain general.

Each introduction now opens with the same sentence:

> From deep holes, the cubic takes shape, finds its bearings, and stands
> fixed while its shadows move.

The sentence supplies a visible progression without summarizing three
tables of contents.  Paper I recovers the code, hexagon, and golden
orientation from syndrome geometry; Paper II isolates the general
conic-matching mechanism that separates recovery from orientation; Paper
III gives exact arithmetic and harmonic realizations.  The explicit
logical-independence boundary sits in each README, where a reader looking
for release relations will find it.  It does not interrupt the first-page
mathematics.

## Editorial architecture

The package deliberately separates three levels:

1. the shared small-caps banner supplies movement, recognition, and the
   I/II/III identity;
2. each formal title remains visually dominant and bibliographically
   unchanged; and
3. the opening sentence gives a memorable change of view without importing
   another paper's machinery.

This lets the mathematics remain formal and paper-local while the reader
experiences one unfolding object.  The gerunds were chosen over a second
technical subtitle because the papers already have formal titles:
*recovering* belongs to Paper I, *orienting* to Paper II, and *realizing* to
Paper III.

The three title pages were rendered and inspected directly.  The two-line
banner fits without wrapping or creating a separate cover leaf, and the main
titles remain the largest typographic objects.

A context-free cold reader independently saw a coherent family and judged
Paper II genuinely general.  That read also exposed a missing date on Paper
II, inconsistent placement of the refrain, and the risk that a repeated
expository disclaimer would feel like boilerplate.  The dates and placement
are now uniform, while the disclaimer has been removed from the manuscripts.

The conclusions follow the same discipline.  Paper I ends with the
quadratic-operator/cubic bridge; Paper II states the cross-characteristic
continuation as mathematics rather than promotion of a companion paper; and
Paper III reverses the opening image: the cubic that stood fixed is itself
the common invariant cast as a shadow from two different ambient geometries.

## Trust boundary

No theorem, hypothesis, proof, frozen v1 baseline, evidence claim, or
cross-paper dependency was changed by C703.  Statement identities,
fingerprints, PDFs, and README surfaces were regenerated only because the
reviewed manuscript source closure changed.

The refresh also exposed that Paper I's newly added cubic-geometry corollary
was absent from its grouped nineteen-row statement map.  The extractor now
groups that corollary with the orientation two-graph theorem it completes;
the theorem text itself was not changed by C703.

Paper I's concurrent v2 formal work is moving from the former monolithic gate
to a human-scale base library plus a q11 certificate package.  C703 preserves
that stronger formal direction and does not weaken or impersonate its queued
C702 aggregate-release work.

## Acceptance

The authoritative Paper II aggregate gate passed with all twenty-six
statement identities, thirteen evidence bundles and independent replays,
three guarded Lean gates, warning scan, and forced PDF build:

```text
clebsch factorization release: CHECK OK
```

The authoritative and standalone Paper III aggregate gates passed all
release-allowlist, statement-identity, trust-manifest, formal-pin, arithmetic,
harmonic, build, and warning checks:

```text
clebsch-passages release: ALL CHECKS PASS
```

The standalone Paper II aggregate gate also passed:

```text
clebsch factorization release: CHECK OK
```

Paper I's authoritative and standalone manuscript builds, rendered title
pages, refreshed nineteen-row statement identities, and warning scans pass.
Its aggregate formal release gate remains with C702: the pinned q11 package
does not yet ship the required axiom-audit file, and the q13 release surface
is not yet final.  C703 neither fabricates that audit nor expands into the
queued release task.

The main integration commits are `91f294b4` in the authoritative repository,
`87b9284` in the Paper I mirror, `388e0bf` in the Paper II mirror, and
`2fc8cb8` in the Paper III mirror.  The final Paper III shadow reversal is
`780cc5b2` authoritatively and `a06a0ef` in its standalone mirror.

## Extra-juice and Tao closeout

The cheap upgrade was to make the trilogy relation visible before the
abstract while leaving bibliographic titles untouched.  A first attempt to
place the banner before `\maketitle` exposed the title-page class's forced
page break; C703 instead alters the rendered title object locally,
preserving the canonical `\title{...}` metadata and producing no blank leaf.
The final closeout removed the explanatory sentence after the refrain and
the explicit companion-paper promotion from Paper II's conclusion.  Both
facts are still available in the release documentation; neither competes
with the mathematics.

The structural gain is the distinction between an umbrella object and a
hinge mechanism.  Orientation is the conceptual hinge of the series, but the
Clebsch cubic is the larger object that naturally contains the coding,
projective, arithmetic, and harmonic viewpoints.  The final banner therefore
names the cubic and lets the three gerunds carry the arc.

## Mystery ledger

| feature | status | exact remaining boundary |
|---|---|---|
| common object | settled as the Clebsch cubic | none |
| relation of the three papers | settled as recovering, orienting, and realizing | none |
| Paper II generality | preserved in its canonical title, abstract, theorem, and proof surface | none |
| logical dependence | excluded explicitly in every README; no proof surface imports another paper | none |
| title metadata drift | avoided by keeping each canonical `\title{...}` unchanged | none |
| Paper I aggregate v2 formal release | owned by queued C702 | q11 certificate-package integration and final clean release certificate |

No expository mystery remains in the trilogy identity itself.

Vibe check: the papers now look like serious mathematics with an inviting
front door and a strong last view.  The cubic is neither a mascot nor the
whole subject: it is the fixed object through which the changing code,
orientation, arithmetic, and harmonic structures become visible.
