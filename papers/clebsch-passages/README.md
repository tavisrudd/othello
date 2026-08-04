# Golden descent and operator realizations of the Clebsch cubic

[![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21682515-blue.svg)](https://doi.org/10.5281/zenodo.21682515)

**Series:** *The Clebsch cubic --- III*

The shared progression is expository; this manuscript is logically
independent of the other two.

[Read the paper (PDF).](clebsch_passages.pdf)

The rational twist in Hitchin's double cover of the projective space of
harmonic cubics is a discriminant rather than a fitted constant: the two
conjugate Clebsch charts meet in a nonsplit two-branch singularity whose
residue-field pinching has square class \([5]\), and with Hitchin's branch
sextic the cover's function field is
\(\mathbb Q(\mathbf P(H))(\sqrt{5J_0})\).  A complete golden fibre evaluates
that class, and a marked bridge datum turns the deck sign into the sign of an
order-six conference operator \(C\) with \(C^2=5I\).

The resulting oriented cubic is simultaneously triangle holonomy, the
diagonal of the middle exterior power, a commutator Pfaffian, and a
cross-golden determinant; the middle two agree for every symmetric matrix and
the last reformulates the golden splitting, so it is the triangle holonomy
joining them that records the conference class.  Its outer translates are
Joubert coordinates on the Segre cubic, while centered squares give the
Segre--Igusa polar map.  For every symmetric conference matrix the balanced
exchange spectrum is the squared singular spectrum of its cut block, and
cut-independence singles out order six.  Independently of the golden setting,
the four-by-four principal minors of a Seidel matrix determine it up to
switching and global negation from seven vertices onward, seven being sharp.
With the same marking, the Petersen eigenspace embeds as the Clebsch
four-space in degree-six zonal harmonics.

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

The mod-\(11\) assertion concerns the displayed golden fibre and its
integral exchanger.  It does not assert that the full geometric incidence
comparison has good reduction at \(11\).
