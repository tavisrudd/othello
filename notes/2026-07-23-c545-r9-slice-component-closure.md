# C545 redundancy-nine slice and component closure

Date: 2026-07-23

## Result

The redundancy-nine classification is now unconditional for every prime
power `q >= 53`.  The six-slice, rational-base, and `CC(8,1)` assumptions
have been replaced by printed propositions and a public, replayed polynomial
record.

No bounded-field classification below 53 is asserted.  The characteristic-
seven `q=7` and `q=49` carrier propositions retain their explicit
non-classification boundary.

## Component proof

For a characteristic-seven carrier quartic and a split quintic
`P=R(t)(t-x)`, the two Hankel equations give the printed residual quadratic

`D t^2 - N_s t + N_u`

and branch quartic `K=N_s^2-4N_uD`.

For the squarefree normal form `h_L=[1,0,L,0,1]`, the public supplement
prints six discriminant vectors and coefficient vectors satisfying

`sum b_i(L) Delta_i(L)=1` in `F_7[L]`.

Thus one slice is squarefree for every geometric `L`.  Four further rows
cover root partitions `4`, `3+1`, `2+2`, and `2+1+1`; their reduced
discriminants are `3,3,1,5`.  These cases exhaust every nonzero geometric
binary quartic, and projective covariance transports the good slice.

For a rational quartic `h`, the squarefree-part discriminant defines a
nonzero base polynomial `B_h(r_1,...,r_4)`.  Coefficient degrees give

- individual base-root degree at most 24;
- total degree at most 96;
- total degree at most 102 after the Vandermonde is included.

Schwartz--Zippel therefore supplies a rational distinct four-root base for
`q>102`; the first characteristic-seven field in that range is 343.

## Contained components

The named proposition `prop:r9-contained` closes `CC(8,1)`:

- uniform rank-nullity lifts every contained lower rank-two line to the
  upper persistent carrier;
- consecutive Lucas overlap leaves only the characteristic-five point and
  characteristic-seven quartic carrier;
- the characteristic-five point has an explicit split witness;
- a six-dimensional moving series of degree at most seven cannot factor
  through Frobenius, since the pulled-back section space would have
  dimension at most four;
- the resulting ramification divisor has degree at most 12, so collision
  cannot be a contained component.

Together with the four-marker genus/deletion argument and the corrected
normalized-cover deletion total 32, this removes every assumption from the
R9 theorem.

## Reproducibility

Certificate R9 was extended atomically:

- the generator now emits one Bezout coefficient per slice;
- the JSON contains the six discriminants and exact identity;
- the independent replay performs its own polynomial convolution over
  `F_7`, verifies that the sum is `1`, and checks the exact vectors
  transcribed in `papers/beyond4_prs/supplement/R9-SLICE-DATA.md`;
- the predecessor checksum manifest now hashes the generator, JSON, replay,
  report, and public supplement.

Validation:

- generator `--check`: pass;
- independent replay: pass;
- checksum manifest: all eight rows pass;
- Python bytecode compilation: pass;
- warning-gated manuscript build: pass, 34-page PDF;
- exact source scans: no conditional R9 theorem, stale assumption, or stale
  boundary text remains;
- abstract mechanical count: 193 words.

## Extra-juice and Tao closeout

The six-slice family is deliberately redundant.  The checked Bezout identity
uses only slices 1, 2, and 6; slices 3--5 have zero Bezout coefficients and
serve as independent regression controls.  Thus geometric exhaustion is
already a three-slice fact, although retaining all six makes corruption or
normalization drift easier to detect.

The large-looking rational-base bound is not close to the theorem threshold
in characteristic seven.  The only characteristic-seven fields below 343
are 7 and 49, both below the headline range 53.  Therefore the degree-102
Schwartz--Zippel argument is exactly sufficient for the all-`q>=53` theorem;
sharpening 102 would not enlarge that theorem.

The coordinate-free principal-subresultant definition of `B_h` is preferable
to printing a very large four-variable expansion: it is invariant under
transport, exposes the degree proof, and remains exactly reproducible from
the residual formulas.

## Mystery ledger

- **Settled:** whether the six normalized slices can all degenerate at one
  squarefree quartic.  The explicit Bezout identity rules this out.
- **Settled:** whether a multiple-root quartic orbit is omitted.  The four
  root partitions and nonzero reduced discriminants exhaust them.
- **Settled:** whether geometric good bases descend to rational choices in
  the required fields.  The nonzero base polynomial and degree-102
  Vandermonde product give the descent.
- **Settled:** whether a collision or modular line remains hidden in
  `CC(8,1)`.  Dimension and Lucas-overlap arguments close both.
- **Open but outside the theorem:** classifications below `q=53` are not
  supplied.  This bounded-field question is not used by the Version 1
  abstract or R9 theorem.
