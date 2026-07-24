# Clebsch rigidity paper

Working root for the focused rigidity/decoder manuscript provisionally titled
*Deep-hole rigidity of the Clebsch hexagon code*.

- Scope owner: the focused Clebsch rigidity paper and its release surface.
- Base: the focused manuscript snapshot at
  `7d258dcd6cda9f54c330d4b705d553a975749014`.
- Scope: rigidity, quantitative gaps, decoding, automorphisms, support bipartition,
  Brianchon reconstruction, `q=11` uniqueness, the `4 <= k <= 7` classification,
  and their verification architecture.
- Boundary: no factorization-memory, reflection-arrangement, or later-passage
  theorem or verification dependency.

The manuscript is `clebsch_rigidity.tex`. It was developed from the exact
17-page source at `7d258dcd6cda9f54c330d4b705d553a975749014`, with the
explicit matrix, complete census, and release-local verification surface
added without importing later-paper claims.

This is the active Clebsch manuscript. Build it from `papers/` with
`make -B clebsch-rigidity`; the `clebsch` target builds the preserved
mega-paper fallback.

The Paper I verification surface is under `verification/`. It contains the
nineteen-row statement identity, trust manifest, validator, clean release
runner, unit tests, and deterministic successful output. The ten selected
exact checkers and pinned Nix environment are release-local; the aggregate formal gate is
`../../lean/RelativeConicArcs/Gates/ClebschRigidityTrust.lean`.

From this directory, with the separately checked-out flattened formal
repository supplied as `--lean-root`, run:

```text
nix develop --command \
  python3 verification/verify_release.py \
  --lean-root /path/to/finitegeom
```
