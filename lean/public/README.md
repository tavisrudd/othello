# finitegeom

`finitegeom` is a Lean 4 library for finite geometry, coding theory, algebraic
combinatorics, quantum information, repair theory, and combinatorial games.

## Verify

```sh
nix run .#verify
```

This restores the pinned Mathlib cache and builds every library target. The
Lean toolchain and Mathlib revision are fixed by `lean-toolchain`,
`lakefile.toml`, and `lake-manifest.json`.

## Trust boundaries

Paper-facing claims use explicit gate modules. The files under `trust/areas/`
record each gate, its terminal declarations, and expected axiom sets;
`trust/manifests/` content-addresses the corresponding source closures.

- `trust/` contains the claim boundaries, terminal ledgers, and reproducible
  axiom audit.

Large finite classifications are distributed as separately pinned certificate
packages. They are not dependencies of this human-scale library.

## Repository layout

- `CapGame/`, `FiniteGeom/`, `ProjectiveCap/`, `RelativeConicArcs/`,
  `RepairCodes/`, `RepairPorts/`, and `Sumfree/` contain Lean sources.
- `trust/` contains gate descriptions, manifests, and axiom audits.
- `TARGET_MANIFEST.json` records the complete reviewed source set.

## Citation and license

Citation metadata is in `CITATION.cff`. The source is licensed under the Apache
License 2.0; see `LICENSE`.
