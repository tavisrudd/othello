# C862 — Paper III ceiling and theorem-upgrade research

**Lane:** `clebsch`  
**Status:** active; first research-report pass delivered; research report only; do not close

## Objective

Independently assess `notes/2026-08-03-paper-iii-framing-and-ceiling-review.md` against the current Paper III manuscript, its frozen mathematical reports, and the routed C815--C824 forward-version program. Identify which proposed upgrades are already theorem-ready, which require new mathematics, which are false or overclaimed as stated, and which additional high-value upgrades the review missed.

## Scope

1. Reconstruct the current paper's actual theorem hierarchy, dependency structure, marking burden, arithmetic seam, harmonic endpoint, and recognition route.
2. Stress-test the proposed headline equivalence of torsors, arithmetic-completion claim, marking-invariance theorem, harmonic isolation upgrade, functorial-shadow framing, and aligned-faithfulness positioning.
3. Run bounded literature checks only where a recommendation depends on novelty or priority; record read depth, identifiers, cache hashes, queries, and coverage gaps under the literature-audit conventions.
4. Rank upgrades by mathematical value, feasibility, dependency, manuscript disruption, and interaction with C813/C816/C824 and the `golden` lane boundary.
5. Record additional theorem opportunities and explicit no-go boundaries discovered in the review.

## Deliverable

Write `notes/2026-08-03-c862-paper-iii-ceiling-upgrade-research.md` as a research report with a verdict matrix, proposed exact theorem shapes, dependency/gap analysis, literature coverage, ranked recommendations, and mystery ledger.

## Boundaries

- Do not edit Paper III or any public package.
- Do not absorb `golden`-lane mathematics into Paper III; identify consent/citation boundaries instead.
- Do not start Lean work or run Lean/Lake.
- Do not perform manuscript integration, release work, or task closeout.
- Keep C862 open after reporting, as explicitly requested by the user.

## Acceptance for this reporting pass

A committed, evidence-backed research report that distinguishes prose-only upgrades from theorem-ready syntheses and genuinely new research obligations, with bounded novelty claims and an explicit next research frontier. Reporting does not complete or close C862.

## First reporting pass

`notes/2026-08-03-c862-paper-iii-ceiling-upgrade-research.md` records the independent verdict. Its main new findings are the spectral realization of the golden incidence fibre as `Q[C]`, the resulting norm interpretation of the commutator determinant, C809's shadow-recognition theorem as the true Paper-II-style priority-judo move, and arXiv `2601.10106` as a new integral-model input reducing the open seam to comparison and Stein-base-change questions. C862 remains active.

## Theorem packet

`notes/2026-08-03-c862-paper-iii-spectral-descent-recognition-theorem-packet.md`
now gives the exact three-part human theorem package: golden spectral descent,
determinant-line norm factorization with the factor `8000`, and the C809 converse
recognition theorem with its marking, orientation, weighted, and integral boundaries.
No manuscript or Lean source was changed. C862 remains active.

## Authorized prose-only edit batch

The user has explicitly authorized applying the cheap prose upgrades now,
without waiting for the C800 reconciliation, and has expanded C862's scope to
cover them. This is a deliberate exception to the report-only boundary above and
to C816's manuscript-promotion ownership: it covers **prose, statement wording,
front matter, and metadata only**. No theorem is added or removed, no formal
surface changes, no released version is altered, and no mirror is synchronized.
C816 retains promotion of the recognition theorem and of any new mathematics.

Batch, in application order:

- [ ] P1 — front matter, all four papers: retire the small-caps gerund subtitle,
      reduce the banner to the series name and number, extend the epigraph to
      its five-clause form with breaks at clause boundaries so no bolded clause
      straddles a line, and give Paper IV the epigraph it lacks.
- [ ] P2 — Paper III abstract: lead with the discriminant/conductor rather than
      "we determine the rational twist", per `02-orientation-cover.tex:99–106`.
- [ ] P3 — Paper III: shadow inventory remark before `thm:operator-shadows`
      billing the four descriptions by type, which also settles the
      "four equivalent descriptions" ambiguity.
- [ ] P4 — Paper III: retitle `\subsection{Why order six is exceptional}`.
- [ ] P5 — Paper III: state the four-local reconstruction theorem in
      principal-minor language, with the even-order-minors-only sharpening.
- [ ] P6 — Paper III: settle the selected-query sufficiency/exact-count
      ambiguity in one direction.
- [ ] P7 — Paper III: the two-elevens disambiguation clause.
- [ ] P8 — Paper III: name the Gaunt factorization as a proposition.
- [ ] P9 — Paper III: promote the general square-class lemma out of the proof of
      `thm:arithmetic-main` as an unnamed displayed lemma, not advertised.
- [ ] P10 — Paper III: keywords and Mathematics Subject Classification additions
      (`two-graph`, `Seidel matrix`, `principal minors`, `reconstruction`;
      `05B20`, `05C22`).
- [ ] P11 — portfolio README: regenerate the paper abstracts from the manuscript
      sources, add the forced-`q = 11` Sylvester statement to Paper I's standout,
      cross-link Paper I's chord-defect mechanism to its all-planes
      generalization in the arcs paper, add the general-theorems table, and
      replace the vague Paper V description.

Held back from this batch, needing C816 or new mathematics: the spectral remark
and the determinant-line norm proposition; the all-even-orders recognition
statement; anything asserting local weighted rigidity, which stays behind the
rank-14 certificate.

## Independent review of the proposals

`notes/2026-08-04-c862-paper-iii-and-series-upgrade-review.md` reviews the
upgrade proposals against a full read of the manuscript, the portfolio README,
and the rendered first pages of all four released Clebsch PDFs. Its main
findings are that Theorem I must be restated around the involution
correspondence rather than the isomorphism, that the multiplicity-one defence
against the coincidence objection already exists in the harmonic section and
should be applied uniformly, that `PJ3` is under-ranked, and that the
exceptionality perception is manufactured by front matter and portfolio
packaging rather than by the mathematics. It also confirms the three C815
manuscript corrections as already applied and its compiled-evaluation checklist
item as stale. No manuscript, Lean, or release file was changed. C862 remains
active.
