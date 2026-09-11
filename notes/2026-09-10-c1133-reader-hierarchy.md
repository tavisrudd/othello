# C1133 — contribution hierarchy and resonant example

**Lane:** `cubic-threefolds`

## Implemented reader-facing revision

Title: *One-stabilization irrationality and Hodge conservation for Fano
threefolds*. The cubic theorem remains the opening theorem. The title,
repository metadata, own and Lean READMEs, blueprint title, portfolio summary,
and the two companion citations agree. The abstract is unchanged at 133
whitespace words. The archival description now includes the Fano classification
and rational Hodge result, with the partial-formalization boundary.

The introduction replaces its long roadmap with a three-route table: cubic,
uniform Fano classification, Hodge conservation. It explicitly separates
numerical results from Part II and optional general-bundle input. A main-text
degree-two example substitutes the actual matrix parameters into the universal
residue formula: eigenvalues 0 and -1 agree modulo integers, but the canonical
discriminant is one. The weaker exponent count misses the block, while the
lattice count selects it. Its repeated explanation in Consequences is removed.

The finite appendix distinguishes matrix arithmetic from every-member geometric
identification in a compact evidence table and subsection headings. Its formal
boundary states that checked deductions do not establish supplied geometric
premises, which the conventional proof justifies in prose or by citation.
No assertion of end-to-end formally verified irrationality is made.

The optional additive appendix removes unused positive-monoid notation,
combines the two spectrum definitions and shortens the Grothendieck-group
factorization proof. All theorem statements, hypotheses and mathematical
conclusions are unchanged. The dimension-five, second-stabilization and
rank-three lattice limitations remain. The companion citation rebuild exposed
an overfull introductory theorem heading; shortening its descriptive name
fixed the line without changing its statement or registered digest.

## Acceptance and replay

Authority primary and both companion `make check` gates pass. The primary
was forced through a fresh TeX build, with warning rejection. The formal source
checker passes without refreshing or promoting any claim digest.
The primary PDF is 33 pages (previously 32); the direct cubic proof still ends
on page 14. The added example and reading tables account for the modest growth.
Visual inspection covered the title, roadmap, resonant example, shortened
optional material and provenance pages. The table line-spacing warning was
fixed by ragged-right text in its label cell, not by disabling warnings.
A fresh external cold read or blinded before/after preference was not run;
the user-supplied cold feedback is the input to this revision, not validation
of the resulting text.

```
uv run --with pymupdf==1.28.2 python notes/2026-09-10-c1133-reader-hierarchy.py --check
```

The adjacent script/certificate checks the title and abstract limit, derives
the displayed residue by exact Fractions from the literal degree-two matrix,
and records source/PDF hashes and page counts. The existing universal-residue
and independent finite checkers supply a separate arithmetic check; geometric
matrix identification remains the cited/written proof. No new literature or
priority claim was introduced. Export gates are recorded below on completion.

## EJ + TT closeout and Mystery ledger

After the acceptance gates, the hierarchy check confirms that a reader can
follow the cubic route, stop before Hodge theory, and still know why resonant
families need more than exponent classes. The cheap extra repair updates the
stale archival description as well as the title. Optional notation was cut
without changing any theorem or proof premise.

No new mathematical mystery arises from this editorial pass. The explicit
geometric comparison realization remains the formalization gap owned by
C1133 and recorded in `2026-09-10-c1133-lean-selector-comparison.md`.
No incidental discovery was promoted. Review scores were not recorded.

## Standalone portability repair

The final companion replay exposed an existing monorepo-relative linter and
Nix path in the six-axis Makefile. The authority now uses the packaged linter
and selects the manuscript environment by the same rule as the framed
companion. Both authority execution and a standalone execution of that exact
Makefile pass; all three PDFs agree byte for byte. No build gate is weakened.
The initial editorial export is `504ffbc`; the final portable export follows
this source fix. The portfolio title is synchronized at `69bfb01`.

## Final release identity

Editorial authority `0230c5381`, portability repair `885f0e947`; standalone
`cfa8672`. Exporter verification passes for 352 files with content SHA-256
`982abdd6166b9fa555c9a6872386157cc461efb5e6744cce6e74fb5e081079dd`.
Primary and both companion checks pass in the standalone repository, with
all three PDFs byte-identical to the authority. Primary PDF: 33 pages,
252860 bytes, SHA-256
`f771e0242accac52f69a24ef140a5aed75fceb937cc413fc93464d376557f15a`.
The complete Lean source set is unchanged by the editorial revision; the
preceding authority and standalone guarded full builds and 373-terminal audits
remain the kernel validation for this artifact. Summary `69bfb01` matches
the committed authority README. Nothing was pushed.

Next C1133 work: match the supplied geometric coefficient embedding and regular
comparison realizations to the written proof and Hodge-fixed-base hypotheses.
