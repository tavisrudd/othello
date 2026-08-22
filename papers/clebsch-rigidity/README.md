# Reconstructing the Clebsch Code from Its Deep-Hole Syndrome Locus

[![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21652792-blue.svg)](https://doi.org/10.5281/zenodo.21652792)

**Clebsch portfolio:** part of the five-paper *Clebsch: Rigidity from Sparse
Shadows* series. Related companions include *Diagonal Isoduality and
Transversal Clifford Groups of MDS--CSS Codes* and *Balanced Cuts of
Conference Matrices: Squared-Spectrum Rigidity and Hermitian Holonomy*. The shared
progression is expository: this paper is logically independent of the other
portfolio papers.

The five numbered papers are: I, this rigidity paper; II, *Quadratic Trade
Rigidity and Cubic Orientation in Conic Matching Quotients*; III, *Hitchin's
Icosahedral Incidence Double Cover and Operator Realizations of the Clebsch
Cubic*; IV, *Reconstructing
PG(2,13), its conic, and polarity from the minimum words of a binary conic
code*; and V, the culminating recognition and marked-round-trip paper.

[Read the paper (PDF).](clebsch_rigidity.pdf)

For a six-arc \(A\subset\operatorname{PG}(2,11)\), its uncovered points are
the projective deep-hole syndromes of the associated \([6,3,4]_{11}\) MDS
code.  The paper proves that this locus lies on a conic exactly when \(A\) is
the Clebsch hexagon; in that case it is the entire conic.  Thus
nearest-codeword data reconstruct the non-GRS code up to monomial equivalence,
including its parity-check geometry and \(A_5\) stabilizer.

Coset-leader ambiguity then recovers a conference matrix on six axes up to
switching and global negation. Either representative satisfies \(B^2=5I\),
and triangle holonomy recovers the
support cubic and the integral order \(\mathbb Z[B]\simeq\mathbb Z[\sqrt5]\).
The proof combines a universal chord-defect identity with decoder ambiguity
and the orbital pentagon.  Uniformly, any \(k\)-arc whose uncovered locus is a
nonsingular conic satisfies
\(2k-3\leq q\leq(k(k-1)+3)/3\), reducing each fixed-\(k\) existence problem
to finitely many fields.

Rebuild the manuscript and compare the tracked PDF with a deterministic build:

```text
nix develop .#manuscript --command \
  python3 verification/check_manuscript_build.py
```

The verification material is under `verification/`. It contains the
claim map, trust manifest, deterministic
checker transcripts, validators, and unit tests. The commutant terminals are
unconditional: the finitegeom library proves the reverse containment from
explicit five-cycle and three-cycle commutation equations, while equivariance
of the conference operator and integral descent are kernel checked.

The main paper's q11 orbit decomposition has an explicit two-generator finite
certificate, independently checked by the formal gate and the paper-owned
automorphism replay. Its decoding oracle is a structural proof from
chord-incidence identities. Generated q11 tables are retained only as a
redundant formal cross-check and as evidence for the companion's sharper
finite census claims.

The reusable human-scale formal source is distributed in
`https://github.com/tavisrudd/finitegeom`; the frozen q11 certificate is in
`https://github.com/tavisrudd/finitegeom-clebsch-q11-certificates`; and their
small compatibility proof is in
`https://github.com/tavisrudd/finitegeom-clebsch-rigidity-bridge`. Exact
revisions are recorded in `FORMAL_COMPANION.json`. The version-independent
archival locator of `finitegeom` is the Zenodo concept DOI
[`10.5281/zenodo.21650878`](https://doi.org/10.5281/zenodo.21650878).
From this directory, supply clean checkouts at those revisions, the sealed q11
Lake pack, and the finitegeom human-gate receipt:

```text
nix run .#verify -- \
  --certificate-root /absolute/path/to/finitegeom-clebsch-q11-certificates \
  --finitegeom-root /absolute/path/to/finitegeom \
  --bridge-root /absolute/path/to/finitegeom-clebsch-rigidity-bridge \
  --certificate-pack /absolute/path/to/q11.lake-pack.tar.gz \
  --guarded-finitegeom-run /absolute/path/to/successful/run
```

This verifies sealed certificate evidence and hashes without rebuilding the
q11 certificate. See `verification/README.md` for the trust boundary and the
separate `nix run .#regenerate` command used after intentional source changes.
