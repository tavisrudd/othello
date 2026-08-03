# TeX source layout

`main.tex` is the canonical preprint driver and `main-tit.tex` is the
single-column IEEEtran review driver.  Both consume the same frontmatter,
twelve active section files, one separate appendix file, acknowledgment, and
bibliography.  The first eight entries form the body; the fixed-level proof
files and verification section follow the appendix switch:

1. `01-introduction.tex`
2. `02-overview.tex`
3. `03-dictionary.tex`
4. `04-redundancy-five.tex`
5. `05-polar-induction.tex`
6. `07-recursive-carriers.tex`
7. `08-fixed-level-roadmap.tex`
8. `11-provenance-boundary.tex`
9. `06-redundancies-six-seven.tex`
10. `07-fixed-level-eight-nine.tex`
11. `09-lucas-carriers.tex`
12. `10-verification.tex`

The R9 slice data are in `appendices/r9-slice-data.tex`.

The exact paper-to-formal declaration map is
`supplement/LEAN-STATEMENTS.md`; it is not a manuscript appendix.  Each
driver contains only its venue-specific preamble, the active inputs,
bibliography style, and document terminator.
