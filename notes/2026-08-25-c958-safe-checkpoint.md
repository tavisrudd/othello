# C958 safe checkpoint and continuation ledger

**Date:** 2026-08-25
**Status:** active; split type-`I3` inverse accepted locally, ground descent and
final products incomplete

## Accepted at this checkpoint

The following new gate is complete and replayed:

- exact normalization of the generic type-`I3` family from `(a,beta)` to
  `s=beta/a^3` on `a != 0`;
- exact inverse anticanonical cubics over the normalized degree-24 splitting
  field;
- exact cubic landing and both projective composites;
- an independent Rust quotient-algebra diagnostic at three primes and three
  parameter values, with `cargo clippy -D warnings` clean.

Authoritative files:

```text
notes/2026-08-25-c958-type-i3-split-inverse.py
notes/2026-08-25-c958-type-i3-split-inverse-verify.py
notes/2026-08-25-c958-type-i3-normalized-split-inverse-formulas.json
notes/2026-08-25-c958-type-i3-normalized-split-inverse.json
notes/2026-08-25-c958-type-i3-split-inverse.md
notes/2026-08-25-c958-type-i3-split-inverse.sha256
rust/examples/c958_type_i3_split_inverse_check.rs
```

The full JSON pins the formula checkpoint by SHA-256.  The adjacent manifest
pins all checkpoint files.

## Work in progress, not a certificate

Two continuation sources are intentionally committed so the exact setup is not
lost:

```text
notes/2026-08-25-c958-type-i3-cox-descent.py
notes/2026-08-25-c958-type-i3-full-coboundary.py
```

Neither has an accepted JSON artifact.  Do not cite either as proving descent.
The Cox source currently completes these stages exactly:

1. loads and pins the original degree-24 field and split inputs;
2. proves the normalized/original coordinate scaling for all blowdown quadrics;
3. proves compatibility of all four field automorphisms with the normalization;
4. constructs the four marked-plane actions by conjugating through the exact
   inverse and strips the known exceptional factors by sparse exact division;
5. checks two distinct smooth ground surface points, their nonvanishing Cox
   forms, and action compatibility without a pathological projective inversion.

The next line is the current performance frontier: constructing
`target_forms` in the original two-parameter tower while recovering the raw
Cox proportionality scalars.  It spends minutes in nested rational-function
gcds and was interrupted; no failed mathematical assertion was observed.

## Exact next implementation step

Keep the raw-scalar calculation in the normalized one-parameter field:

1. define `n_source_forms = cox_forms(n_alpha,n_gamma,(nz1,nz2,nz3))`;
2. for each generator, form the target Cox forms from
   `normalized_plane_actions[name]` and `n_automorphisms[name]`;
3. compare polynomial coefficient dictionaries directly, choosing one nonzero
   coefficient ratio and checking every coefficient by cross multiplication;
4. lift only the resulting constant scalar through `parse_normalized`;
5. account explicitly for the diagonal plane-coordinate scales when translating
   normalized Cox labels to the original marking, or, preferably, retain the
   entire strict descent datum in normalized coordinates and state the exact
   conjugation once;
6. generate `notes/2026-08-25-c958-type-i3-cox-descent.json`, replay it with
   `--check`, and only then run the full-coboundary source.

Do not restore pivot normalization of generic projective points: it caused a
ten-minute extended-gcd computation in the original tower and is unnecessary
for homogeneous assertions.

## Remaining mathematical gates

1. Finish/replay strict type-`I3` Cox descent and its order-24 group law.
2. Finish/replay the type-`I3` rank-eleven permutation-basis Hilbert--90
   coboundary.
3. Construct ground tangent quotient inverses for both type `I1` and type `I3`.
   The generic quintic already closes only the **split** type-`I1` inverse.
4. Compose the surface, residual norm-torus, tangent quotient, contraction, and
   cubic-fibration maps to obtain both directions for `X_1 x P2` and
   `X_3 x P2` over `Q`.
5. List every denominator/dense open and verify both final composites.
6. Upgrade the paper with compact constructions and cite expanded coefficients
   as ancillary artifacts; run its full acceptance suite.

Until all six gates pass, C958 remains active and its stated acceptance gate is
not met.

## C962 tool assessment

C962's generated-span and orbit-compilation machinery is not the right engine
for the present bottleneck.  C958 is dominated by symbolic arithmetic in a
nested degree-24 function field, not a finite additive orbit-choice search.
Its general lesson—compile symmetry before expensive search—is already realized
by the one-parameter normalization.  Reusing the C962 solver itself would add
an abstraction layer without eliminating the field operations.  The bespoke
Rust quotient checker is the useful expensive-work tool here.
