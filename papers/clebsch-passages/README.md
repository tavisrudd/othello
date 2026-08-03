# Golden descent and operator realizations of the Clebsch cubic

[![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21682515-blue.svg)](https://doi.org/10.5281/zenodo.21682515)

**Series:** *The Clebsch cubic: recovering, orienting, and realizing --- III*

The shared progression is expository; this manuscript is logically
independent of the other two.

[Read the paper (PDF).](clebsch_passages.pdf)

The paper determines the rational twist in Hitchin's double cover of the
projective space of harmonic cubics:
\(\mathbb Q(\mathbf P(H))(\sqrt{5J_0})\).  A complete golden fibre fixes the
factor \(5\), and a marked bridge datum turns the deck sign into the sign of an
order-six conference operator \(C\) with \(C^2=5I\).

The resulting oriented cubic is simultaneously triangle holonomy, the
diagonal of the middle exterior power, a commutator Pfaffian, and a
cross-golden determinant.  Its outer translates are Joubert coordinates on
the Segre cubic, while centered squares give the Segre--Igusa polar map.
Balanced exchange rigidity characterizes order six, and aligned four-sets
reconstruct every two-graph on at least seven vertices up to complement.
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
