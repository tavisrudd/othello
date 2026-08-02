# Golden descent and operator realizations of the Clebsch cubic

**Series:** *The Clebsch cubic: recovering, orienting, and realizing --- III*

The shared progression is expository; this manuscript is logically
independent of the other two.

This directory contains the `clebsch-passages` manuscript and artifact.  Its
main argument has four stages:

1. the rational square class of Hitchin's incidence cover, its exact local
   golden fibre, and the specialization of the fibre exchanger modulo `11`;
2. the normalized incidence components and, relative to an explicit golden
   marking and linear lift, their sign comparison with the conference class
   and Petersen four-space;
3. the conference operator's triangle, middle-exterior, Pfaffian,
   cross-golden determinant, Joubert--Segre, and Segre--Igusa cubic shadows,
   together with the balanced exchange-rigidity theorem that characterizes
   order six among symmetric conference carriers and the aligned-design
   inversion theorem that reconstructs every higher signing from quadratic
   selected determinant data;
   and
4. the degree-six icosahedral Gaunt/Steinhardt cubic on the Petersen
   four-space.

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
