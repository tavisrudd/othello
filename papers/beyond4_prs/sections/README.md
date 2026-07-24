# TeX source layout

`main.tex` is being reduced to a thin build driver.  Stable section filenames
are numbered by reading order:

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

Appendices live under `appendices/`.  Files are extracted only after the
corresponding proof expansion stabilizes, so line-level mathematical review
does not chase simultaneous content and path churn.

The eventual paper-only export preserves this layout.  It does not publish
the development monorepo.
