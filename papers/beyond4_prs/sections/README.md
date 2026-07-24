# TeX source layout

`main.tex` is the canonical preprint driver and `main-tit.tex` is the
single-column IEEEtran review driver.  Both consume the same `frontmatter/`,
section, appendix, and bibliography sources.  Stable section filenames are
numbered by reading order:

1. `01-introduction.tex`
2. `02-overview.tex`
3. `03-dictionary.tex`
4. `04-redundancy-five.tex`
5. `05-polar-induction.tex`
6. `06-redundancies-six-seven.tex`
7. `07-fixed-level-eight-nine.tex`
8. `08-ordered-hessian.tex`
9. `09-lucas-carriers.tex`
10. `10-verification.tex`
11. `11-provenance-boundary.tex`

Appendices live under `appendices/`; the statement-adequacy appendix is
`appendices/statement-adequacy.tex`.  The section extraction is complete.
Each driver now contains only its venue-specific preamble, ordered inputs,
bibliography style, and document terminator.

The eventual paper-only export preserves this layout.  It does not publish
the development monorepo.
