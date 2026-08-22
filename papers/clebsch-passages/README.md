# The Clebsch Cubic: Hitchin's Icosahedral Double Cover and Conference-Matrix Rigidity

[![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21682515-blue.svg)](https://doi.org/10.5281/zenodo.21682515)

**Clebsch portfolio:** part of the five-paper *Clebsch: Rigidity from
Sparse Shadows* series. Related companions include *Diagonal Isoduality and
Transversal Clifford Groups of MDS--CSS Codes* and *Balanced Cuts of
Conference Matrices: Squared-Spectrum Rigidity and Hermitian Holonomy*. The shared
progression is expository: this paper is logically independent of the other
portfolio papers.

The five numbered papers are: I, *Reconstructing the Clebsch Code from Its
Deep-Hole Syndrome Locus*; II, *Quadratic Trade Rigidity and Cubic Orientation
in Conic Matching Quotients*; III, this paper; IV, *Reconstructing
\(\operatorname{PG}(2,13)\), Its Conic, and Polarity from the Minimum Words of
a Binary Conic Code*; and V, *Chordal and Conference Cubics: Reconstruction
and a Residual \(C_2\)-Torsor*.

[Read the paper (PDF).](clebsch_passages.pdf)

The rational twist in Hitchin's double cover of the projective space of
harmonic cubics is a discriminant rather than a fitted constant: the two
conjugate Clebsch charts meet in a nonsplit two-branch singularity whose
residue-field pinching has square class \([5]\).  A paper-local
ramification-cycle calculation identifies Hitchin's real sextic boundary as
the reduced branch divisor, and the cover's function field is
\(\mathbb Q(\mathbf P(H))(\sqrt{5J_0})\).  The fibre over \([xyz]\) evaluates
that class; after fixing the marking datum, its two deck choices correspond to
the marked conference pairs \((C,Z)\) and \((-C,-Z)\), where \(C^2=5I\).

The resulting signed triangle-product cubic is simultaneously the diagonal
of the middle exterior power, a commutator Pfaffian, and an oriented
spectral-block determinant.  For a real symmetric zero-diagonal matrix with
nonzero off-diagonal entries, nonzero proportionality of its commutator
Pfaffian to its triangle cubic forces \(n=6\) and \(A^2=\lambda I\); in the
equal-modulus case this identifies the pentagon conference class.  Its outer
translates are Joubert coordinates on the Segre cubic, while centered squares
give the Segre--Igusa polar map.  For every symmetric conference matrix the
balanced exchange spectrum is the squared singular spectrum of its cut block,
and cut-independence singles out order six.  Independently of this order-six
model, the single bit recording whether each four-set is aligned reconstructs
every two-graph from seven vertices onward up to complement, and seven is
sharp.  For conference matrices, the determinant-\((-3)\) four-blocks
therefore recover the signing up to switching and global negation.  With the
same marking, the Petersen eigenspace embeds as the Clebsch four-space in
degree-six zonal harmonics.

The fixed-icosahedron Clebsch charts in the first theorem are conjugate
charts over `Q(sqrt(5))`; they are not presented as rational subspaces of
the standard rational harmonic space.

## Source

- `clebsch_passages.tex`: manuscript driver.
- `sections/`: one file for each mathematical stage.
- `ARTIFACT.md`: stable artifact description and trust boundary.
- `literature-boundaries.md`: claim-level proof, precedence, and wording
  boundary.
- `release_files.json`: public packaging allowlist.
- `verification/trust_manifest.json`: claim/evidence/status ledger.
- `verification/statement_identity.json`: frozen theorem surface.
- `verification/verify_release.py`: aggregate release gate.

Build from this directory:

```text
make -B
```

Check the manuscript and complete trust surface:

```text
python3 verification/verify_release.py
```

The mod-\(11\) assertion concerns the displayed incidence fibre over \([xyz]\) and its
integral exchanger.  It does not assert that the full geometric incidence
comparison has good reduction at \(11\).
