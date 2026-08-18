# C910 — machine-readable provenance annotations in the manuscript source

**Task:** C910 (`cubic-threefolds`) — Lean companion for
`papers/cubic-stabilization-epilogue/`.
**Date:** 2026-08-18.  **Authority commits:** `628aaec72`, `b90f9433a`.
**Predecessor:** the geometric-rows report
`2026-08-18-c910-geometric-rows-of-the-atomic-route.md`.

The claim map recorded each statement's formal coverage in a file the statement
itself never mentioned, so a manuscript restructure could leave a row describing
a statement that no longer existed; that failure had already occurred once, when
the headline theorem's row survived the atomic restructure byte-identical while
its terminals stopped matching the proof.  The correspondence is now recorded
inside the environment it describes, and the checker requires the two records to
agree.

## The annotation layer

`formal-annotations.tex` defines five typographically empty macros, all taking
comma-separated identifiers only, so that a citation, a convention, or a replay
command has exactly one home:

- `\coverage{...}` — the strength at which the statement is formalized, one of
  `absent`, `fragment`, `conditional_deduction`, `complete`.
- `\lean{...}` — the reviewer terminals carrying it, without their namespace.
- `\uses{...}` — the statements it depends on: inside a statement body a
  conceptual dependency, inside a proof a logical one.
- `\imports{...}` — the external results it uses, resolved in
  `verification/imported-sources.json`.
- `\evidence{...}` — the computational evidence bundles it rests on, resolved in
  `verification/evidence.json`.

`\lean` and `\uses` follow the Lean blueprint system of P. Massot, whose
print-mode macros are likewise empty; the statement-versus-proof reading of
`\uses` follows KnowTeX (arXiv:2601.15294), which draws the two as dashed and
solid edges.  Neither system has a four-valued strength, a provenance registry,
or a gate, which is where this layer goes beyond them.

## The registries

`verification/imported-sources.json` records, for each imported result, its
bibliography key, its pinpoint, the form in which this manuscript uses it, and
the conventions of framing, coordinates, and normalization that must be matched
for the use to be valid, each paired with how this manuscript matches it.  The
fourteen entries cover every external result cited in Section 4.  Two of them
carry conventions that this session's formalization showed to be load-bearing:
the sign of the displayed A-model connection, which is what the Euler-sign lemma
converts into a spectral dictionary, and the loop coordinate, line class, and
adjoined square root of Cai's small even system, which the block reduction must
match before its eigenvalues mean anything.

`verification/evidence.json` is present and empty.  The proof spine of this
manuscript invokes no computation as a premise, so no statement carries an
evidence annotation; the registry exists so that a statement which later does
must name a bundle, with its role, its tracked checksum manifest, and its replay
command, rather than describe one in prose.

## The gate

`check_formal_artifact.py` reads the annotations out of the manuscript source and
rejects: a coverage value or terminal list disagreeing with the claim map; an
annotated identifier that resolves in neither registry; a `\uses` label that is
not a semantic label of this manuscript; an imported source whose bibliography
key is absent from the manuscript, or which records no conventions, or a
convention missing its aspect, requirement, or match; and an evidence bundle with
no checksum manifest on disk or no replay command.  Each of those refusals was
tested by introducing the defect and observing the failure.

## Coverage of the layer itself

`\coverage` and `\lean` are filled for all fifty theorem-like environments and
are gated.  `\imports` is filled for the twelve Section 4 environments that use
an external result.  `\uses` is defined and gated but not yet filled: the edges
can be derived from the cross-references, but the derivation is incomplete,
because several dependencies of Section 4 are established in running text
between the environments rather than inside them, so filling it is an authoring
pass rather than a mechanical one.  Sections 1 through 3 and Section 5 have no
`\imports` yet.

## Gates

All green at `b90f9433a`.  The rebuilt manuscript is byte-identical, so the
annotations changed nothing typographic; `make check` and the axiom-log check
pass over 115 sources, 220 terminals, 50 claims, 46 machinery rows, and 14
imported sources.  The standalone paper repository is synchronized, gate-replayed
and committed.

## Next

Fill `\uses` across the atomic route and emit the coverage-coloured dependency
graph; record a digest of each statement body in the claim map so that rewriting
a statement forces its row to be re-reviewed; then run the fifty-row review of
the claim map against a source that already carries its full linkage.
