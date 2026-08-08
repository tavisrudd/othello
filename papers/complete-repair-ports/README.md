# Complete bounded repair ports

**Title:** *Complete Bounded Repair Ports: Transfer, Reliability, and Geometric Structure*<br>
**Author:** Tavis Rudd<br>
**Status:** development manuscript, not yet a public release. The revised theorem hierarchy is
frozen; the MDS reconstruction, pointed transfer, positive-density realization, and
reliability/bounded-EXIT sections have complete written proofs and scoped formal support.

## Paper spine

For a linear code and a target coordinate, the complete bounded repair port retains every
dual-support repair using at most a prescribed number of helpers. The paper keeps three layers
visible: support, scalar coefficients, and failure probability.

The theorem-led order is:

1. complete bounded ports and their support/coefficient/probability layers;
2. exact weighted-functional transfer and pointed confinement;
3. prescribed positive-density realization in asymptotically good fixed-alphabet families;
4. reliability, cheapest-radius transforms, and radius-truncated BEC EXIT;
5. the standard pointed-Tutte/perspective identification and its radius-filtration boundary; and
6. cubic--axis versus quartic--nucleus/harmonic flagships.

The harmonic Steiner system gives parallel repairs at the nucleus, while every curve-target repair
has the nucleus as a compulsory series helper. Exact field-nine reliability/EXIT profiles and
Poisson approximations are computational refinements outside the body theorem chain. The cubic
family supplies exact matching/transversal rows and the natural strict weighted-transfer example.

The prescribed-port theorem is also instantiated on the Clebsch
`[6,3,4]_11` code. Its full coefficient-valued radius-five port has
`z_x=8`, reconstructs the inner code from one pointed coefficient port, and
therefore occurs at density `1/6` in an asymptotically good fixed-`GF(11)`
family. The support clutter alone is the generic complete three-uniform
hypergraph on five helpers; the manuscript does not present generic MDS
locality as Clebsch-specific.

The current PDF is a 12-page draft. Its main mathematical boundary is deliberate: coefficients
give a direct one-symbol-per-helper scalar protocol, not a minimum-bandwidth or minimum-access
claim under subpacketization.

## Evidence boundary

The reconstruction, transfer, prescribed-port, reliability, and bounded-EXIT theorem chains have
formal support in the shared Lean development. Outer-family existence, the pointed-Tutte
specialization, and the retained harmonic geometry remain explicit manuscript or literature
boundaries. Exact finite harmonic, reliability, EXIT, and pointed-Tutte profiles are evidence
support for the appendices, not substitutes for the body proofs.

Classical ingredients remain labeled as such: concatenated-dual decomposition, Singer regularity,
random GV and AG/TVZ codes, normal-rational-curve nuclei, harmonic Steiner systems,
and the Las Vergnas perspective polynomial. A none-found search is not a priority certificate.
The Clebsch specialization is a manuscript corollary of the MDS dual parameters and the
prescribed-port theorem; it is not a separate claim about Clebsch geometry.

An optional cubic blocker-stability strengthening is outside the current scope. Sequential
composition, service regions, coefficient optimization, log-concavity,
product architecture, and random harmonic-cascade thresholds are outside scope.

## Files

- `complete_repair_ports.tex` — main manuscript.
- `complete_repair_ports.pdf` — current draft PDF.
- `refs.bib` — bibliography.
- `sections/` — manuscript sections and their reading order.

## Build

From this directory:

```bash
nix shell nixpkgs#tectonic -c tectonic complete_repair_ports.tex
```

## Publication boundary

This repository is not yet a citable public release. A future export will carry only the reviewed
manuscript, its public evidence, and the corresponding formal boundary; publication, licensing,
identifiers, and push remain author decisions.
