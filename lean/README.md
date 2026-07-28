# Lean formalization portfolio

This directory is the shared Lean 4 + Mathlib development for the repository's
papers in finite geometry, coding theory, algebraic combinatorics, quantum
information, repair theory, and combinatorial games.

The primary paper-facing areas are:

- Clebsch syndrome rigidity and the associated Q11 classification;
- quadratic recovery, Hilbert symmetry, and hyperplane-square factorization
  for conic matching quotients;
- arcs complete outside a prescribed conic, including the Q16
  classification;
- projective Reed–Solomon deep holes at redundancies five through seven;
- local-unitary rigidity of stabilizer AME states and transversal structure
  for MDS–CSS codes;
- complete bounded repair ports, reliability, and pointed Tutte structure;
  and
- Frobenius-equivariant extension and continuation-graph reconstruction.

The cap-game, Node-Kayles, Queens, and general finite-geometry modules remain
important foundations and regression targets, but they are not the organizing
scientific focus of the Lean tree.

## Reviewer entry points

Start with [`TRUST.md`](TRUST.md), which defines the trust model and indexes
the paper-specific manifests. The generated portfolio view is
[`trust/PORTFOLIO.md`](trust/PORTFOLIO.md); machine-readable area contracts
live under `trust/areas/`.

Paper-facing claims enter through explicit gate modules rather than umbrella
imports. Each area contract records:

- the exact gate and project-owned import closure;
- the terminal declarations associated with manuscript claims;
- expected axiom sets;
- generated-data boundaries; and
- any separately pinned certificate or build-identity inputs.

Clebsch Passages is intentionally different: its paper manifest declares no
Lean dependency, so it has no gate in this tree.

## Build

The repository pins Lean and Mathlib through `lean-toolchain`,
`lake-manifest.json`, and the Nix flake.

```sh
nix develop
lake exe cache get
lake build <paper-facing-gate>
```

Use the gate named by the relevant trust manifest. Generated Q11 and Q16
certificate families are large opt-in validation surfaces; their public
releases are packaged separately from the human-scale library.

## Public extraction

The fresh-history public release is
[`tavisrudd/finitegeom`](https://github.com/tavisrudd/finitegeom). It is built
as a sequence of content-addressed paper states rather than as a mirror of
this research monorepo.

## Scope of trust

Lean checks the declarations in a gate's import closure and reports their
axiom dependencies. External finite computations are admitted only through
explicit certificate data checked by Lean or through a paper manifest that
labels them as separate evidence. Consult the area contract and paper
verification map before treating any aggregate build as a manuscript claim.
