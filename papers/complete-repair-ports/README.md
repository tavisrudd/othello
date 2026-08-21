# Complete Bounded Repair Ports

## Read the paper

[**Open the paper (PDF) →**](complete_repair_ports.pdf)

**Title:** *Complete Bounded Repair Ports: Transfer, Reliability, and Geometric Structure*

For a linear code and a distinguished coordinate, the complete bounded repair
port records every dual-support recovery using at most a prescribed number of
helpers. The paper keeps three layers visible: helper supports, normalized
scalar recovery coefficients, and reliability under helper failures.

The opening theorem shows that the minimum coefficient port of an MDS code
reconstructs the represented code even though its support projection is the
generic complete uniform clutter. The paper then proves an exact
weighted-functional transfer theorem for concatenation and a positive-density
realization theorem for prescribed represented ports. It develops
deletion–contraction reliability and bounded-EXIT calculi, identifies
full-radius reliability with a Las Vergnas perspective-polynomial
specialization, and proves that the radius filtration contains additional
information.

Two characteristic-three applications illustrate different local geometries:
a twisted-cubic–axis code with exact matching and transversal rows, and a
quartic normal rational curve with its nucleus, whose harmonic quadruples form
a Steiner repair design.

## Proof and evidence boundary

The reconstruction, transfer, prescribed-port, reliability, and bounded-EXIT
chains have Lean 4 support. The manuscript names the classical inputs used for
outer-code existence, concatenation, projective geometry, and the Las Vergnas
polynomial. Exact finite tables and replay evidence are confined to the
appendix and do not prove a main-body theorem.

The scalar repair protocol downloads one complete base-field symbol from each
contacted helper. It does not claim minimum subsymbol access, optimal repair
bandwidth, full symbol-MAP behavior at a finite radius, or a capacity theorem.

## Source layout

- `complete_repair_ports.tex` is the manuscript driver.
- `sections/` contains the numbered theory, application, conclusion, and
  verification/evidence sources.
- `figures/` contains the source-native proof-spine diagram.
- `verification/` pins the formal source/base revisions, module closure,
  terminal count, gate-fact hash, and guarded replay commands.
- `refs.bib` contains the bibliography.
- `.zenodo.json` contains preprint deposit metadata; it creates no deposit or
  DOI by itself.

## Build

From this directory, run:

```text
make check
```

This rebuilds the manuscript with the pinned Nix toolchain and fails on LaTeX
warnings, unresolved references, or overfull/underfull boxes.

## License

The contents of this repository are licensed under the MIT License; see
`LICENSE`.
