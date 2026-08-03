# Clebsch rigidity paper

**Series:** *The Clebsch cubic: recovering, orienting, and realizing --- I*

The shared progression is expository; this manuscript is logically
independent of the other two.

Working root for the focused rigidity/decoder manuscript titled
*Reconstructing the Clebsch code and its golden orientation from its
deep-hole syndrome locus*.

- Scope owner: the focused Clebsch rigidity paper and its release surface.
- Base: the focused manuscript snapshot at
  `7d258dcd6cda9f54c330d4b705d553a975749014`.
- Scope: rigidity, quantitative gaps, decoding, automorphisms, support
  orientation, the intrinsic golden two-graph, Brianchon reconstruction,
  the cubic's six-node projective frame, `q=11` uniqueness, the `q=13`
  tangent code, the `4 <= k <= 8` classification, and their verification
  architecture.
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
nineteen-row statement identity, the companion's five-mode claim map, trust
manifest, validators, clean release runner, unit tests, and deterministic
successful output. The twenty selected exact checker invocations and pinned
Nix environment are release-local; the aggregate formal gate is
`RelativeConicArcs/Gates/ClebschRigidityTrust.lean` in the shared formal
certificate package.  It imports the causal rigidity spine and all eight
orientation packets.  The commutant terminals are conditional only on the
explicit classical conjugate `3+3'` Schur--Galois interface recorded in the
trust manifest; golden equivariance and integral descent are kernel checked.

The main paper's q11 orbit decomposition and decoding oracle are structural
proofs from eigenspaces, stabilizers, orbit--stabilizer, and chord-incidence
identities. Generated q11 tables are retained only as an independent formal
cross-check and as evidence for the companion's sharper finite census claims.

The reusable formal source is distributed in
`https://github.com/tavisrudd/finitegeom`; the aggregate q11 gate is in
`https://github.com/tavisrudd/finitegeom-clebsch-q11-certificates`.  Both
revisions are recorded in the manuscript.  The base library's
version-independent archival locator is the Zenodo concept DOI
[`10.5281/zenodo.21650878`](https://doi.org/10.5281/zenodo.21650878).
From this directory, supply a checkout of the q11 certificate package
as `--lean-root`:

```text
nix develop --command \
  python3 verification/verify_release.py \
  --lean-root /absolute/path/to/finitegeom-clebsch-q11-certificates
```
