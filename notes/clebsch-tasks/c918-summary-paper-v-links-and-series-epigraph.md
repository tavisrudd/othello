# C918 — Paper V summary links/DOI repair and series-epigraph provenance

**Lane:** `clebsch`
**Paper stream:** Paper V (`papers/chordal-conference-reconstruction/`), plus the
shared `papers/summary/` index.
**State:** complete for both parts; two follow-up decisions are the user's.

## Scope

1. Repair the broken Paper V links in `papers/summary/README.md` and give Paper V
   the repository link and DOI badge the other released papers carry.
2. Determine when and why the shared five-clause series epigraph disappeared from
   Papers II–V.

Allowed paths: `papers/summary/README.md`, `papers/summary/VERIFICATION.md`,
this card, the lane queue row, and the dated report.

## Part 1 — summary index links

`papers/summary/README.md` referred to Paper V three times by the repository-relative
path `../chordal-conference-reconstruction/chordal_conference_reconstruction.pdf`.
That path resolves inside this monorepo but is broken in the published
`math-papers-summary` index, where every other paper is addressed by its public
GitHub URL. Paper V was also the only released paper with no repository link and
no DOI badge, and the only one of the five numbered papers missing from
`papers/summary/VERIFICATION.md`.

Applied:

- all three Paper V references now point at
  `https://github.com/tavisrudd/chordal-conference-reconstruction/blob/main/chordal_conference_reconstruction.pdf`;
- the paper table row gained `· [repo](https://github.com/tavisrudd/chordal-conference-reconstruction)`;
- the Paper V section line gained the repository link and the DOI badge for
  `10.5281/zenodo.21895531`, matching the badge form used by Papers I–IV;
- `VERIFICATION.md` gained a Clebsch V entry-point row.

Checked live: the repository, the PDF blob URL, and the DOI all return HTTP 200.

### Open decision — the Zenodo record is stale

`10.5281/zenodo.21895531` is the v0.1.0 version DOI (concept DOI
`10.5281/zenodo.21895530`), deposited from the GitHub release tagged
2026-08-10. Its Zenodo title is still *The Golden Companion Correspondence*, the
paper's former title, and its archived zip predates the two 2026-08-11 commits
`e5d7ab8` (retire former companion filenames) and `a8ee939` (publish
chordal-conference reconstruction) that carried out the retitle. The badge is a
valid locator, but a reader following it lands on a record whose title and
filenames do not match the current paper. Resolving this means cutting a forward
GitHub release, letting Zenodo deposit it, and re-pointing the badge at the new
version DOI. Using the version DOI rather than the concept DOI is the existing
house style (Paper IV's badge is likewise a version DOI).

## Part 2 — the missing series epigraph

The epigraph is the five-clause verse that opened every paper's title page, with
each paper bolding its own clause:

> From deep holes, a cubic **takes shape**; its companion **finds its bearings**,
> the carrier **stands fixed while their shadows move**; **from minimum words, the
> plane returns**, and **the scattered shadows gather home**.

It was removed from Papers II, III, IV, and V — and kept in Paper I — by a single
commit, `b19233879` "papers: frame sparse-shadow series as reconstruction"
(2026-08-11), under C904's series-framing pass. It was deliberate, not an
accident of a merge or a retitle.

The reasoning is recorded in that commit's own cold-read notes.
`notes/2026-08-11-c904-series-framing-cross-cold-read.md` identified three
overlapping unity signals — the shared series title, the identical epigraph on
page 1 of all five papers, and explicit paper-number dependency sentences — and
judged that together they made Papers II–IV read as installments even though
their mathematics is standalone. It called the repeated epigraph "the strongest
source of serial over-branding" and proposed keeping the full entry-point
branding in Paper I only. Its accept pass then confirmed the executed change:
Paper I alone retains the epigraph and the series map, Papers II–IV read as
standalone inverse problems, and Paper V carries the marked return and
common-carrier payoff.

Note that the cross cold-read offered "retain the common epigraph only in I and V"
as one of its options, while the change actually made removed it from V as well.
Nothing in the notes records that narrowing as a separate decision.

### Open decision — restore it in Paper V?

Restoring the epigraph to Paper V is the one variant the review explicitly
contemplated and the executed change did not take. Paper V is the capstone whose
clause is "the scattered shadows gather home," so the over-branding objection
that motivated removal in II–IV is weakest there. Papers II and III have public
GitHub/DOI releases whose PDFs already omit the epigraph, so restoring it in II
or III would need a forward release to be visible. Paper V's own v0.1.0 deposit
predates the retitle and is already due a forward release, so an epigraph
restoration there would ride along at no extra release cost.

## Adjacent items observed, not acted on

- `papers/summary/README.md` lists *Irrationality of Cubic Threefolds after One
  Stabilization* with a repository link but no DOI badge. That paper belongs to
  the `cubic-threefolds` lane; no DOI was supplied here.
- `notes/2026-07-07-codex-task-queue.md` still carries completed clebsch rows
  (C705, C706 are marked COMPLETE), which the lifecycle conventions say the live
  queue must not contain. Pre-existing hygiene debt, untouched here.
