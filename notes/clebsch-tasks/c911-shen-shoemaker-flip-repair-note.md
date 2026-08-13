# C911 — standalone discrepancy-one flip repair note

**Lane:** `clebsch`

**Status:** COMPLETE — reviewed manuscript, DOI metadata, AI disclosure,
standalone export, and portfolio entry are green (2026-08-13).

## Goal

Publish the source-local repair of Shen--Shoemaker (arXiv:2502.08762v2) as a
short standalone paper: their Gamma/Orlov asymptotic theorem's printed
dependency chain omits the entire discrepancy-one standard-flip range
`r=s+1, s>=1`; the note supplies the missing `I`-to-`J` normalization (exact
`z`-order identity `1+s(d-1)-rd=1-s-(r-s)d<=-1`, cone membership, `J`-slice
uniqueness) and the correct `nu=1` Meijer aperture from their Appendix A,
with the `s=0, r=1` projective-bundle degeneration explicitly excluded.

## Source authority

- Mathematical content: `../2026-08-13-c907-shen-shoemaker-codim2-repair.md`
  (read-only source owned by the C907 session; do not edit or commit it).
- Target paper: cached PDF
  `/tmp/persistent/tavis/lit-search/pdf/arxiv_2502.08762.pdf`, SHA-256
  `2c1d25490d53d1eb04da11e4ad8eec2d9834b25e765462186181292e7f085cce`.
  Verify every cited formula, theorem number, and sector bound against it.

## Deliverables

1. Manuscript under `papers/` (monorepo authority first), new directory with
   a sensible short alias.
2. Standalone repository export under `~/src/math-papers/<alias>` following
   `../export-and-mirror-conventions.md` (read completely before any write
   there).
3. Dated task report in `notes/`, written incrementally during the work.

## Boundaries

- The note claims only the source-local repair. No C907 programme claims, no
  irrationality or stable-irrationality statements, no receiver/telescope
  material.
- No novelty-verdict sentences (avoids the literature-audit overhead); frame
  as a completion/correction of the cited preprint's stated generality.
- No Lean work.
- Read `papers/style-guide.md` completely before drafting prose.

## Closeout

Authority: `papers/discrepancy-one-flips/`.  An independent cold read returned
final `GO` after the splitting-principle and formal-endpoint repairs.  Both
authority and standalone `make check` pass; paper mirror `2ce2208` and summary
mirror `674d6ab` are clean.  DOI: `10.5281/zenodo.21924799`.  Full report:
`../2026-08-13-c911-standalone-note-draft-report.md`.
