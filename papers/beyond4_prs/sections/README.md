# TeX source layout

`main.tex` is the canonical preprint driver and `main-tit.tex` is the
single-column IEEEtran review driver.  Both consume the same frontmatter,
eight active section files, acknowledgment, and bibliography:

1. `01-introduction.tex`
2. `02-overview.tex`
3. `03-dictionary.tex`
4. `04-redundancy-five.tex`
5. `05-polar-induction.tex`
6. `06-redundancies-six-seven.tex`
7. `10-verification.tex`
8. `11-provenance-boundary.tex`

The exact paper-to-formal declaration map is
`supplement/LEAN-STATEMENTS.md`; it is not a manuscript appendix.  Each
driver contains only its venue-specific preamble, the active inputs,
bibliography style, and document terminator.
