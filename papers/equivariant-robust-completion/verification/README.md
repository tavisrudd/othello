# Verification boundary

The structural argument in the manuscript is human-scale mathematics with a
Lean development in the shared finite-geometry project.  Its exceptional
normalized order-25 census is isolated in the Mathlib-only
`finitegeom-q25-certificates` package.  This paper pins that package in
`q25-certificate-pin.json` by repository commit and manifest digest.

The package gate checks all normalized rows in the two-fixed-point slice.  It
proves the lower bound 32, the exact five equality witnesses, the orbit sizes
200, 400, 400, 200, 400 and their disjoint union of size 1,600, and the strict
bound 33 outside that union.  The package's concrete coordinate model is its
formal boundary.  The two projective normalizations and the transport back to
semantic arcs are arguments in the manuscript; this pin does not claim a
separate Lean compatibility theorem for them.

The generated forest is proposed data checked by proved predicates.  The line
and carrier tables instantiate shared sound checkers.  The residual transport,
dispatch, and conclusion leaves also contain row-specific point equalities,
bad-triple witnesses, and literal links to canonical representatives.  These
are kernel checked, but their review surface grows with the rows; the package
does not replace the literal links with a proved canonicalization algorithm.

From a checkout of the pinned certificate package, the full package command is:

```text
nix run .#verify
```

That command includes the large certificate build.  Verifying only that this
paper has not drifted to a different package identity is source-only: compare
the checkout commit with `commit`, hash its `MANIFEST.json`, and compare that
digest with `manifest_sha256` in `q25-certificate-pin.json`.

The standalone paper export carries this directory unchanged.  Publishing the
certificate commit and running the full package command are separate release
actions; neither is performed by the paper exporter.
