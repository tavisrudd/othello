# Verification boundary

The structural argument in the manuscript is human-scale mathematics with a
Lean development in the shared finite-geometry project.  Its exceptional
normalized order-25 census is isolated in the Mathlib-only
`finitegeom-q25-certificates` package.  This paper pins that package in
`q25-certificate-pin.json` by repository commit and manifest digest.

Artifact locator:

```text
https://github.com/tavisrudd/finitegeom-q25-certificates
commit d4e910cf01819a8678fd84422bb18fe23f4d6695
MANIFEST.json sha256 4f3d252a453c7217a8a8aaf7b27374794396e2d0b4101c7c8b85683deaa52292
```

The human-scale structural sources are separately frozen at:

```text
https://github.com/tavisrudd/othello/tree/9977af02cfed699c1c14802242a6f500896164bc/lean
```

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

Successful completion exits with status zero.  The source-reproduction stage
reports `trees_checked=3 passed=3`; the final line is
`MANIFEST.json ok (9511 modules)`.  The command also checks the canonical
residual-cover CSV digest
`62aa26c98deb98cb786fa1b21957b91ec16b1e2bd2a6319129c31449eb0effe3`.
This is a 9,511-module build and the first run downloads the pinned
Lean/mathlib cache.  Wall-clock and peak-memory numbers are not stated because
they vary with cache state and build parallelism.

That command includes the large certificate build.  Verifying only that this
paper has not drifted to a different package identity is source-only: compare
the checkout commit with `commit`, hash its `MANIFEST.json`, and compare that
digest with `manifest_sha256` in `q25-certificate-pin.json`.

The standalone paper export carries this directory unchanged.  Publishing the
certificate commit and running the full package command are separate release
actions; neither is performed by the paper exporter.
