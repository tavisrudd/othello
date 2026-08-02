# Two-uniform rigidity: Lean formalization

**Lane**: `ame-lu`
**Date**: 2026-08-02
**Status**: IN PROGRESS

Formalizing the adopted `sec:two-uniform` subsection of
`papers/ame_lu/sections/03-lu-rigidity.tex` (Discreteness and quantitative
stability) so the formal layer matches the manuscript.

## Setting fixed in Lean

The manuscript works with an arbitrary party count `n` and arbitrary local
dimension `q >= 2`; the existing `RelativeConicArcs.AMELU` modules are pinned
to six parties over a finite field.  The new material therefore lives in a
nested namespace `RelativeConicArcs.AMELU.Multipartite` with its own setting:
a finite site type `Site`, a finite local alphabet `Level` of cardinality `q`,
computational-basis labels `Site -> Level`, and states as complex amplitude
functions on labels.  Operators are `Matrix (Site -> Level) (Site -> Level) C`.

## Progress log

(filled in as work lands)
