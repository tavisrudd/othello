# C907 pair-of-pants flat-base attachment reduction

**Lane:** `clebsch`

**Status:** exact finite reduction for the base-flatness portion of the
full-initial problem.  It covers every cell and face already serialized by
the tripod hyperplane refinement.  It does not construct the required regular
log modification, calculate exceptional multiplicities, or identify every
strict transform; those are now the explicit remaining records rather than a
552-case smoothness calculation.

## Statement

Let `R=k[[delta]]`, with `k` of characteristic zero and `Q in k^*`.  On one
charted pair-of-pants degeneration, retain the two equations

\[
B+U=1,\qquad C+V=1.
\tag{1}
\]

For each factor, use the four algebraic initial types

\[
\begin{array}{c|c|c}
\text{type}&\text{linear initial}&\text{residue parametrization}\\ \hline
g&B+U-1&B=b,\ U=1-b\\
0&U-1&B=b,\ U=1\\
1&B-1&B=1,\ U=b\\
\infty&B+U&B=b,\ U=-b .
\end{array}
\tag{2}
\]

The table is used separately for `(C,V)`, with residue coordinate `c`.
Here `g` is the *algebraic central residue torus*: both `B,U` are units.
The one-marked residue `U=0` is type `1`, even though the later coarse control
ledger merges it into its unmarked finite boundary.  Every product of two
base initials in (2), before and after inverting its residue coordinates, is
an integral smooth linear complete intersection.

Write `X=x1*x2*x3`.  If a lifted support chart has strict graph generator
whose central reduction, up to a residue unit, is the initial of

\[
L-(x_1+x_2+x_3)-\frac Q{XBC}-UV,
\tag{3}
\]

then its full pair-of-pants initial complete intersection is flat whenever
that initial is nonzero in the product base fibre.  More precisely, assume
the chart has already supplied all of the following:

1. a flat pair-of-pants Rees base over `R` with one of the products of (2) as
   its residue-localized special fibre;
2. the pullback of the global Cartier equation, saturated only by the
   complement of the original dense graph, and divided by the actual
   exceptional monomial; and
3. an identification of the resulting generator with (3), with its leading
   support given by the cell's six-weight upper-envelope mask.

Then the graph quotient is `R`-flat and its special fibre is precisely the
base initial together with the restricted graph initial.  Thus it is the
required full initial complete intersection, not an initial of the graph
polynomial considered in isolation.

Indeed, clear the unit denominator `XBC`.  The graph initial for a support
mask `M subset {0,...,5}` is the corresponding sub-sum of

\[
XBC L,\quad-XBCx_1,\quad-XBCx_2,\quad-XBCx_3,
\quad-Q,\quad-XBCUV .
\tag{4}
\]

The exact certificate below proves that it is nonzero on every realized base
initial.  Since that base is a domain, it is a non-zero-divisor.  The local
flatness criterion over the DVR then makes the quotient by the graph
generator flat, and reduction modulo `delta` commutes with that quotient.

This is deliberately a conditional attachment theorem: the hypotheses are
the chart-lift, strict-transform, and exceptional-order data which support
masks cannot see.

## Exact finite certificate

`2026-08-12-c907-pair-of-pants-initial-nonvanishing.py` reads the exact
Polymake/PPL refinement certificate and recomputes the upper-envelope mask of
every one of its 81,367 cells from its fifteen-sign vector.  It then reduces
(4) using (2) for every realized ordered type/mask pair.  There are exactly
552 such pairs.  Each resulting cleared polynomial is stored in canonical
form in the JSON certificate and is nonzero.  The `Q` term, when present, is
the unique term linear in the formal parameter `Q`; hence the result remains
nonzero after every specialization `Q in k^*`, rather than merely for a
generic parameter.

Replay from the repository root:

```sh
nix shell nixpkgs#python3 --command python3 \
  notes/2026-08-12-c907-pair-of-pants-initial-nonvanishing.py --check
```

The tracked checksum manifest covers the generator and its 46,558-byte JSON
certificate.  The input refinement's SHA-256 is also recorded inside the
JSON, so a certificate for a different support subdivision cannot be reused.
The direct domain proof above is independent of the enumeration: it explains
why nonzero cleared initials are non-zero-divisors after residue localization.

As a separate transition check, the current one-tripod/SNC-Rees atlas replay
passes its five exact incidence, Rees-overlap, and global-Cartier-chart-unit
identities:

```sh
nix shell nixpkgs#singular --command Singular -q \
  notes/2026-08-12-c907-one-tripod-log-atlas.sing | \
  cmp -s - notes/2026-08-12-c907-one-tripod-log-atlas.out
```

That atlas is a useful checked local transition package, but it is not yet a
regular global refinement and is not relied on as the certificate above's
complete chart source.

## What this compresses, and what remains

The support complex no longer needs a cellwise S-polynomial calculation to
prove base flatness or to attach its graph initial *once a genuine chart has
been supplied*.  Every new ray inside a support cell has the same mask; every
face is already one of the replayed cells.  The surviving finite geometric
records are exactly:

1. choose a regular integral pair-of-pants/log refinement of the rational
   support complex, including the residual Rees modification;
2. for every affine chart and exceptional residue stratum, give its map to
   one product of (2), including the face maps;
3. pull back the multihomogeneous Cartier section, record only the
   exceptional components outside the original dense graph, and give their
   exact orders;
4. prove its saturated strict generator is a unit times the chart lift of
   (3), rather than merely sharing its maximum mask; and
5. check nonmonomial overlap identities and the added exceptional charts.

Items 2--4 are where a coefficient can still change or a translated divisor
can be saturated incorrectly.  The certificate proves neither them nor
smoothness of a non-identified strict transform.  Once they are supplied,
the unit-circuit theorem in
`2026-08-12-c907-uniform-pair-of-pants-circuit-lemma.md` supplies geometric
smoothness at positive order, while order zero is monic in `L`; coarse
control/Fitting and collar topology remain separate gates.

## EJ/TT and mystery ledger

- **EJ:** make the pair-of-pants degeneration the flat base.  The graph then
  needs one non-zero-divisor check, not a new Gröbner degeneration for every
  support face.  The exact cost is 552 normal forms, not 81,367 separate
  calculations.
- **TT:** flatness is not obtained from a nonzero graph polynomial alone.
  It uses the integral *full base initial* and the genuine strict generator.
  This pinpoints why a mask-only schön claim was invalid, while also showing
  precisely what masks can legitimately discharge.
- **Settled:** all existing support cells/faces have a certified nonzero
  graph section on their product pair-of-pants base initials; the flat-base
  implication is exact.
- **Open:** regular global chart construction; exceptional multiplicities;
  chartwise saturation and lift identification; nonmonomial overlaps;
  genuine coarse-stratum Fitting and collar data.
