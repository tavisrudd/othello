# Secant–Hyperplane Defects of Complete Caps

## Read the paper

[**Open the paper (PDF) →**](secant_hyperplane_defects.pdf)

**Title:** *Secant–Hyperplane Defects of Complete Caps*

A `k`-cap in `PG(d,q)` is a set of `k` points, no three collinear. It is
complete when every point off it lies on a secant, equivalently when the
`k` points are the columns of a parity-check matrix of a quasi-perfect
`[k, k−d−1, 4]_q` code. Counting the points that the `C(k,2)` secants can
cover gives the classical lower bound `C(k,2)(q−1) + k ≥ θ_d` on the size
of a complete cap, and for `d ≥ 4` that bound is the one the literature
quotes.

## The hyperplane loss identity

The counting bound has a slack, the overlap loss
`Λ_0 = C(k,2)(q−1) − θ_d + k`, which counts with multiplicity the points
covered by more than one secant. The paper shows that every hyperplane
carries a prescribed share of it: for a hyperplane meeting the cap in `s`
points, the loss inside the hyperplane is

```text
Q(s) = C(k,2) − θ_{d−1} + q C(s,2) − (k−2) s.
```

For a complete cap this lies between `0` and `Λ_0`, so the hyperplane
section sizes lie in a finite admissible set, which at the counting bound
can have two elements. A complete `31`-cap in `PG(4,7)`, for instance,
would have `Λ_0 = 20` and would meet every solid in `2` or `7` points.

## Main consequences

- Restricting the classical character equations to the admissible set,
  over all hyperplanes and over the hyperplanes through a fixed secant,
  gives integer feasibility conditions and a lower bound on the number of
  coplanar quadruples through every secant.
- No complete cap of size `31` in `PG(4,7)`, `37` in `PG(4,8)`, `97` in
  `PG(4,16)`, `293` in `PG(6,8)`, or `387` in `PG(6,9)` exists. Each size
  is the counting bound, so `t_2(4,7) ≥ 32`, `t_2(4,8) ≥ 38`,
  `t_2(4,16) ≥ 98`, `t_2(6,8) ≥ 294`, `t_2(6,9) ≥ 388`.
- The moments of the section sizes through a secant are the first two
  power moment identities for the cap code shortened at two coordinates;
  the second moment measures the collisions of that secant with the
  others.
- A formal model shows that the incidence identities for coplanar
  quadruples cannot by themselves force collisions on a positive
  proportion of secants; an ambient constraint such as the hyperplane
  loss identity is essential.
- The identity extends to caps complete outside a prescribed set of
  holes.

An exact scan over `d ≤ 6` and small `q` finds no other gain over the
counting bound in dimension at least four, and never a gain of more than
one; the paper explains why the method stops one step above the counting
bound.

## Verification

From this directory, run

```text
make check
```

This lints the manuscript, replays the exact-arithmetic scan and compares
its certificate digest, rebuilds the PDF with a fixed source date, and
rejects TeX warnings. See [`verification/README.md`](verification/README.md)
for what the scan does and does not establish.

## Files

- `secant_hyperplane_defects.pdf` is the compiled paper.
- `secant_hyperplane_defects.tex` is the manuscript driver.
- `sections/` contains the introduction, the two identities, the
  feasibility and coverage bounds, the exclusions, the limits of the
  method, the conclusion, and the bibliography.
- `verification/` contains the exact scan, its certificate, and the
  digest.
- `.zenodo.json` contains deposit metadata.

## License

The contents of this repository are licensed under the Creative Commons
Attribution 4.0 International License; see [`LICENSE`](LICENSE).
