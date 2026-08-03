# TeX source layout

`main.tex` is the canonical preprint driver and `main-tit.tex` is the
single-column IEEEtran review driver.  Both consume the same frontmatter,
eleven active section files, one appendix, acknowledgment, and bibliography:

1. `01-introduction.tex`
2. `02-overview.tex`
3. `03-dictionary.tex`
4. `04-redundancy-five.tex`
5. `05-polar-induction.tex`
6. `06-redundancies-six-seven.tex`
7. `07-recursive-carriers.tex`
8. `07-fixed-level-eight-nine.tex`
9. `09-lucas-carriers.tex`
10. `10-verification.tex`
11. `11-provenance-boundary.tex`

The R9 slice data are in `appendices/r9-slice-data.tex`.

The exact paper-to-formal declaration map is
`supplement/LEAN-STATEMENTS.md`; it is not a manuscript appendix.  Each
driver contains only its venue-specific preamble, the active inputs,
bibliography style, and document terminator.
