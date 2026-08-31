# Dye 1991 pre-emption — surface sweep

**Lane**: `gem-mining` — see CLAUDE.md § Lane routing.
**Date**: 2026-08-31
**Status**: REPORTED. Read-only sweep; no manuscript, ledger, snapshot, handoff, or queue file was
edited by this task.

---

## 0. What this checks

`notes/2026-08-31-c1022-q31-clebsch-recurrence-novelty-audit.md` (read in full, and treated as
authority throughout) found that R. H. Dye, "Hexagons, conics, A₅ and PSL₂(K)", *J. London Math.
Soc.* (2) **44** (1991) 270–286, already contains, for the Clebsch hexagon over any admissible
field: the claim that all such hexagons are one projective figure, that each of the fifteen chords
carries two of the ten Brianchon points, that the setwise stabiliser is A₅, and — as an explicit
congruence in q, italicised on p. 282 — the internal-versus-external discriminator for the Brianchon
points. Blokhuis–Seress–Wilbrink 1992 already size-pins "complete exterior set" in its own
definition (p. 143), and Van de Voorde 2011 §3 already states that q = 7 and q = 11 are the only
tangent-free cases. What survives with no located predecessor is narrow: the bridge identifying
BSW/Brouwer's q = 31 exceptional complete exterior set with the Clebsch hexagon plus its ten
Brianchon points, and the reading of the q = 11 and q = 31 census entries as one figure at two
completion levels.

This sweep looked for durable text elsewhere in the repository that claims or depends on novelty for
the pre-empted material, or that credits the wrong source for it.

## 1. Result: no hit found. Every surface checked is already either clean or already corrected

**Headline finding: this sweep is not the first response to the audit.** Three files that the
audit's own §8 named as needing an update — `notes/2026-08-31-c1020-brouwer-exceptional-census.md`,
`notes/handoffs/2026-07-14-gem-mining.md`, and `notes/2026-07-15-gem-discovery-track.md` — already
carry the correction, committed at `727ef9b7375541e509f1cdb8c0d308d6f986b516` on 2026-08-31 10:18:38,
before this sweep began. The live task queue never carried a stale row for C1020 or C1022 to begin
with; the archived queue row for C1022 already states the correct verdict. No manuscript in
`papers/` or in the released repositories under `~/src/math-papers/` makes the pre-empted claim in
the first place — every place that touches Dye's material already attributes it to Dye, Edge, or
BSW correctly.

### 1.1 Already corrected (found in this state, not fixed by this sweep)

- `notes/2026-08-31-c1020-brouwer-exceptional-census.md`, lines 46–57. A paragraph headed
  "**Priority, added 2026-08-31 after the C1022 audit — most of the above is Dye's, not ours.**"
  states plainly that the same-figure claim, the two-Brianchon-points-per-chord structure, the A₅
  stabiliser, and the internal/external discriminator are Dye's, cites the exact page and the
  congruence, and restates the surviving claim as only the bridge to Brouwer's census. The mystery
  ledger at the end of the same file (§8, lines 303–315 and 320–327) is likewise already marked
  "SETTLED 2026-08-31 by the C1022 extraction pass" with the corrected attribution. No change needed.
- `notes/handoffs/2026-07-14-gem-mining.md`, lines 96–108, under "⚠ Dye 1991/1988 — the largest
  standing warning to this lane". A subsection "**Third pre-emption by Dye 1991 (2026-08-31,
  C1022)**" states the same correction and adds the working rule "check Dye 1991 before claiming any
  conic-hexagon geometry as new — it has now pre-empted us three times." No change needed.
- `notes/2026-07-15-gem-discovery-track.md`, lines 267–284, entry dated 2026-08-31, "a constant-size
  figure meeting a growing threshold explains the whole A_5 coincidence." Correctly attributes the
  discriminator congruence to Dye 1991 p. 282 and frames the entry's own content (the finiteness
  argument) as an extraction from the audit, not as prior-unclaimed geometry. No change needed.
- `notes/2026-07-07-codex-task-queue-archive.md`, line 5510. The archived C1022 row reads
  "[REPORTED 2026-08-31 — PARTIALLY PRE-EMPTED BY DYE 1991; ONLY THE CENSUS BRIDGE SURVIVES]" and
  summarizes the finding correctly. The live queue (`notes/2026-07-07-codex-task-queue.md`) carries
  no row for C1020 or C1022 at all — the only reference is C1021's dependency note "RUNS AFTER
  C1020", which is a scheduling fact, not a novelty claim. No change needed.

### 1.2 Clean, and never made the claim

- `papers/clebsch-rigidity/clebsch_rigidity.tex`. This is the paper most exposed to this finding — it
  is the manuscript that defines the Clebsch hexagon, proves rigidity at q = 11, and states the A₅
  stabiliser. Its "What is new and what is not" paragraph (lines 206–227) already reads: "The
  hexagon, its uniqueness and stabilizer, and its complete-exterior-set interpretation are classical
  [Clebsch1871, Edge1956, Dye1991, BSW1992, SVM1995]." Section 2 (lines 248–299) attributes the A₅
  stabiliser and the ten-Brianchon-point structure to Dye and Edge by name and page, states
  explicitly that "at q = 19 the two types are interchanged, the vertices being internal and the
  Brianchon points external" (i.e., the paper already knows Dye's congruence is q-dependent, not a
  q = 11 peculiarity), and attributes "complete exterior set" to BSW at pp. 143, 146. The paper never
  mentions q = 31 and makes no claim about a Petersen chord graph, a q = 11/q = 31 identification, or
  Brouwer's census. No change needed.
- `papers/clebsch-rigidity/clebsch_rigidity_computational_companion.tex`, around line 751. Cites BSW
  pp. 143, 146 correctly for the exterior-set definition; no novelty claim attached. No change
  needed.
- `papers/clebsch-factorization/clebsch_factorization.tex`, `papers/clebsch-passages/sections/*.tex`.
  The "Petersen" occurrences here (e.g. `05-harmonic-realization.tex` lines 30, 66, 78, 109) are a
  different object — a Kneser graph on two-element subsets of a five-element index set, isomorphic to
  the Petersen graph by construction, used for an unrelated conference-matrix/eigenspace argument.
  This is explicitly flagged in `notes/2026-08-31-c1020-brouwer-exceptional-census.md` §8 as a
  distinct object from Dye/BSW's chord graph ("C176's Petersen is a third object"). No Brianchon,
  exterior-set, or q = 31 language appears in these files. No change needed.
- `papers/equivariant-robust-completion/sections/01-introduction.tex`, lines 86–90, and
  `sections/03-pair-extension-criterion.tex`, lines 35–48. Both correctly attribute the Dye and BSW
  results by page and cite the "prior art and claim boundary" honestly; the pair-extension corollary
  only uses the classical q = 11 Clebsch hexagon as an input, claiming novelty solely for the
  Frobenius-pair-extension count, not for any geometric fact about the hexagon. No change needed.
- `papers/arcs_complete_outside_conic/arcs_complete_outside_conic.tex`, lines 215–235 area. Cites Dye
  1991 (Proposition 1, Theorems 7–8, pp. 282–284) and BSW 1992 (pp. 143–146) by name for exactly the
  material the audit found pre-empted, and explicitly disclaims broader priority: "Bounded zbMATH
  Open, OpenAlex, Crossref, and source-level searches found no exact precursor for the quantitative
  criterion below... This is negative search evidence, not a claim of historical priority." No change
  needed.
- `notes/2026-07-31-results-summary-snapshot.md`, lines 445–460 (the clebsch-rigidity "Priority
  boundary" paragraph). Reads: "The q=11 six-arc itself is classical, with Edge (1956),
  Blokhuis–Seress–Wilbrink (1992), and Korchmáros (1981) as prior names; Dye (1991) supplies the
  ten-Brianchon bound and the A₅ stabilizer, although that bound and its equality case are now proved
  here from scratch rather than imported." Correctly attributed already; makes no q = 31 or Brouwer
  census claim anywhere in the file (checked by search for "q = 31", "Brouwer" — the only other hits
  are an unrelated golden-operator-lane q=31 collision result and Brouwer–Cohen–Neumaier /
  Brouwer–Van Maldeghem strongly-regular-graph citations, neither connected to this finding). No
  change needed.
- `notes/open-problems/local-results-index.md`, `notes/open-problems/results-crosswalk.md`,
  `notes/open-problems/generalist-results-crosswalk.md`. No occurrence of "Brouwer" or "q = 31" in
  any of the three; the only Clebsch-hexagon-adjacent line
  (`local-results-index.md` line 147, "low-degree containment occurs only for the Clebsch hexagon at
  [q=11]") is scoped to q = 11 and makes no priority claim. No change needed.
- `~/src/math-papers/clebsch-rigidity/`, `~/src/math-papers/clebsch-factorization/`,
  `~/src/math-papers/clebsch-passages/`, `~/src/math-papers/equivariant-robust-completion/`,
  `~/src/math-papers/arcs-complete-outside-conic/`, `~/src/math-papers/q13-passant-code/`,
  `~/src/math-papers/integral-secant-arcs/` — the released repositories. Content matches the
  monorepo sources checked above (same attribution language, same absence of any q = 31/Brouwer
  bridge claim); the one Petersen-graph passage in the released `clebsch-rigidity` mirror is the same
  unrelated synthematic-total construction described above. No change needed anywhere in
  `~/src/math-papers/`.
- `papers/papers-index.md`. Every Brianchon/Clebsch-hexagon row (e.g. `thm-clebsch-deep-holes`,
  `thm-clebsch-rigidity`, `comp-clebsch-a5-point-orbits`) attributes the Brianchon points, the five
  triangles, and the A₅ stabiliser to "classical (Edge/Dye)" or cites Dye directly; none claims the
  q = 11/q = 31 identification or a Petersen chord graph. No change needed.
- `notes/2026-07-14-novelty-status-review-summary-tables.md`. Dated 2026-07-14, before C1020/C1022
  existed. Its §3 "items we thought were novel that aren't" already records rows 1 and 6 correctly
  crediting Edge and Dye for the q = 11 Clebsch hexagon and A₅ stabiliser; it contains no claim about
  q = 31 or Brouwer's census at all (the topic did not exist yet in this file), so there is nothing
  wrong to correct. The audit's own §8 suggests a *new* row could be added here for the q = 11/q = 31
  identification — that is an optional addition, not a defect; the file makes no false claim as it
  stands. No change needed.
- `notes/2026-07-14-literature-sweep-consolidated.md`. Same situation: dated before the finding
  existed, makes no claim about the q = 31 bridge, and its unread ledger already records the Dye-1991
  gate as settled. The audit's §8 suggests adding Dye 1996, Dye 1995, and Korchmáros 1981 to the
  unread-source list here — again an optional addition, not a correction of a wrong statement. No
  change needed.
- `notes/2026-07-15-c193-bsw-exceptional-census.md`, § "The Petersen echo" (lines 79–98). This is the
  file that first raised the question, and it raises it explicitly as an open question with a
  declared null hypothesis — "Stated as a question, not a claim... Do not promote this before the
  null is refuted" — never as an assertion of novelty. It is a dated historical record of an
  unresolved lead, later resolved by C1020 and then re-scoped by C1022; nothing in it is currently
  false. No change needed.
- `notes/2026-07-15-c176-brianchon-petersen-dictionary.md`. Checked for novelty language near
  "Brianchon"/"Petersen"/A₅; found none. Its Petersen-graph object is, per C1020 §8, the same
  synthematic-total Kneser graph as the `clebsch-passages` paper — a different object from Dye/BSW's
  chord graph — and the file makes no priority claim about the geometric result. No change needed.

## 2. Searches run and their scope

Distinctive-term searches, narrow-path, bounded output, per the repository's search rules:
"Brianchon", "Clebsch hexagon", "Petersen", "exterior set", "complete exterior set", "A_5"/"A₅" near
hexagon context, "q = 31"/"q=31", "Brouwer", "two completion levels", "internal-versus-external"/
"internal versus external" — each run against `papers/` (all `.tex`), the specific notes files named
in the task (results snapshot, the three open-problems crosswalks, the novelty-status-review
summary tables, the literature-sweep-consolidated unread ledger, the gem-mining handoff, C193, the
discovery track, the live and archived task queues), and the released repositories under
`~/src/math-papers/`. No search exceeded the output-line ceiling; large result sets were narrowed to
filename listings first where needed (none were, in practice — every distinctive-term search here
returned under twenty lines).

## 3. What was not re-derived

This sweep trusts the audit's verdict rather than re-verifying Dye 1991 or BSW 1992 against the page
scans itself — that verification is the audit's job and is already done there at full-text depth
with image-checked quotations. This sweep's own contribution is exhaustive location of *dependent*
text elsewhere in the repository, not a second reading of the primary sources.

---

## Hit count by severity

**Zero hits requiring correction.** Every surface named in the task, plus the manuscripts, plus the
released paper repositories, is either already corrected (three notes files, committed before this
sweep started) or was never wrong (every manuscript and remaining notes file that touches Dye's or
BSW's material already attributes it correctly and makes no claim about the q = 11/q = 31 identity or
the Petersen chord graph). Two low-severity, non-defective optional additions are noted in §1.2 (a
new row in the 2026-07-14 novelty-status table, and three more unread sources in the
2026-07-14 literature-sweep's unread ledger) — both are the audit's own §8 suggestions for future
housekeeping, not corrections of anything currently wrong.
