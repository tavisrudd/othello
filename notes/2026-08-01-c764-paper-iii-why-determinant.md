# C764 — Paper III “why determinant” boundary

**Lane:** `clebsch`

**Status:** complete

## Result

Paper III now contains one short paragraph immediately after the Golden
operator theorem explaining why its cubic shadow is determinantal.  The map

\[
B_T(x):V_{T,+}\longrightarrow V_{T,-}
\]

is intrinsic, so its determinant is a map between determinant lines and
becomes the displayed scalar after the chosen orientations.  A permanent has
no corresponding basis-free construction: under independent orthonormal
frames the matrix changes as `B -> R_-^T B R_+`, and already
`B=I_3`, `R_-=I_3`, with `R_+` a plane rotation, changes the permanent from
`1` to `cos(2 theta)`.

This is exactly the boundary needed in the merged Paper III.  It explains the
determinant without importing bosonic protocols, event distributions, or the
spectral invariants of C718.  A future physical companion may cite Paper III's
operator construction; Paper III should acquire a forward citation only after
that companion has a stable public locator.

## Validation

Because the authoritative generated PDF was already modified by another
workstream, it was preserved byte-for-byte.  The edited source and regenerated
statement identity were overlaid on a clean `git archive` copy and checked
there with:

```sh
cd papers/clebsch-passages
python3 verification/verify_release.py
```

The release aggregate ended `ALL CHECKS PASS`, including the exact statement
identity, every primary and independent evidence replay, manuscript build, and
warning-free build.

## Closeout

The extra-juice check tested whether C718 supplied a second invariant that
belonged here.  It did not: its permanent obstruction is the only fact needed
to explain the paper's choice, while its symmetric-cube trace and experimental
content belong to the companion package.  The Tao-style compression check
reduced this to the determinant-line mechanism plus the smallest counterexample
to permanent invariance.

Vibe check: a useful conceptual seam is now closed in ten lines, with no scope
creep into quantum applications.
