# C194 — Clebsch-family uncovered formula

**Lane**: `clebsch`

**Date**: 2026-07-15

**Status**: proved, Lean algebra validated, and integrated into the manuscript.

## Result

Let `H` be a Clebsch hexagon over `F_q`. Then

```text
|U(H)| = q^2 - 14q + 45.
```

If `q = 3 (mod 4)` and `C` is Dye's associated conic, then every edge of `H` is a
non-secant of `C`, so `C(F_q) subset U(H)` and

```text
|U(H) \ C(F_q)| = q^2 - 15q + 44 = (q - 4)(q - 11).
```

Clebsch hexagons do not exist in characteristic two. Consequently, within this congruence class,
the associated conic is the whole uncovered locus exactly at `q=11`.

At `q=19` the formula gives `|U|=140` and exact off-conic excess `120`. The existing q=19 checker
is therefore independent verification, not the proof of the count.

## Proof and priority boundary

The proof has two inputs.

1. Dye 1991 defines a Clebsch hexagon by its exactly ten Brianchon points (p. 271), and Theorem 1
   (pp. 275–276) classifies existence and projective equivalence. These points are exactly the
   off-vertex triple-chord concurrences counted by `c(H)` in the manuscript.
2. The manuscript's field-independent chord-defect identity gives
   `|U(H)|=q^2-14q+55-c(H)`.

Substitution gives the formula. Dye's discussion preceding Theorem 6 (pp. 281–282) states that over
`F_q` the edges are chords for `q=1 (mod 4)` and hence non-secants for `q=3 (mod 4)`. This supplies
the inclusion of the associated conic; subtraction and factorization give the exact excess.

Dye owns the Clebsch classification, the ten concurrences, and the edge criterion. The displayed
uncovered-locus formula and its deep-hole interpretation are the apparently unrecorded short
synthesis used here; the direct Edge/Dye/BSW audit found no explicit statement of it.

## Formalization boundary

`lean/RelativeConicArcs/ClebschChordDefect.lean` now proves:

- `clebsch_uncovered_formula`: from the chord-defect formula and the explicit hypothesis `c=10`,
  derive `q^2-14q+45`;
- `orders_of_clebsch_uncovered_conic_card`: equality with `q+1` forces `q=4` or `q=11`.

These theorems formalize all new algebra. Dye's geometric inputs remain cited classical theorems;
they are not silently encoded as computation or claimed as Lean results.

Validation command:

```text
choom -n 500 -- nix develop --command lake env lean \
  RelativeConicArcs/ClebschChordDefect.lean
```

Result: exit 0 on 2026-07-15.

## Manuscript disposition

- Added Proposition `prop:clebsch-family-uncovered` in Section 6.
- Replaced the q=19 enumerative proof of `140` by the formula.
- Retained `check_q19_nonexample.py` as independent reconstruction, exact-count replay, and
  full-rank/non-conic certificate.
- Replaced the coarse “at least 85, actually 120” explanation by the exact factorized excess while
  retaining the capacity bound as a useful weaker comparison.
