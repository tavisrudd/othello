# Reconstructing the Clebsch code and its golden orientation from its deep-hole syndrome locus

**Series:** *The Clebsch cubic: recovering, orienting, and realizing --- I*

The shared progression is expository; this manuscript is logically
independent of the other two.

[Read the paper (PDF).](clebsch_rigidity.pdf)

For a six-arc \(A\subset\operatorname{PG}(2,11)\), its uncovered points are
the projective deep-hole syndromes of the associated \([6,3,4]_{11}\) MDS
code.  The paper proves that this locus lies on a conic exactly when \(A\) is
the Clebsch hexagon; in that case it is the entire conic.  Thus
nearest-codeword data reconstruct the non-GRS code up to monomial equivalence,
including its parity-check geometry and \(A_5\) stabilizer.

Coset-leader ambiguity then recovers an orientation torsor on six axes.  Its
orbital operator satisfies \(B^2=5I\), and triangle holonomy recovers the
support cubic and the integral order \(\mathbb Z[B]\simeq\mathbb Z[\sqrt5]\).
The proof combines a universal chord-defect identity with decoder ambiguity
and the orbital pentagon.  Uniformly, any \(k\)-arc whose uncovered locus is a
nonsingular conic satisfies
\(2k-3\leq q\leq(k(k-1)+3)/3\), reducing each fixed-\(k\) existence problem
to finitely many fields.

Build the manuscript from `papers/` with
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
