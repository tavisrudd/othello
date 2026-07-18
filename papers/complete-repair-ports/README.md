# Complete bounded repair ports

**Title:** *Complete Bounded Repair Ports: Transfer, Reliability, and Geometric Structure*<br>
**Author:** Tavis Rudd<br>
**Status:** private six-part manuscript corrected after citation preflight and independent cold
reads; publication export remains gated.

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

The field-nine harmonic profiles give exact reliability and EXIT deficits. The all-field harmonic
Steiner system has a sparse Poisson repair window at the nucleus and a compulsory-helper series
bottleneck at curve targets. The cubic family supplies exact matching/transversal rows and the
natural strict weighted-transfer example.

The C286 correction pass repaired the exact transfer statement's zero-functional branch,
normalized the coefficient fibers correctly, completed the random/AG and Poisson proof chain,
and reconciled three context-light paragraph-by-paragraph cold reads. The private PDF remains an
11-page draft.

## Evidence boundary

The finite transfer and cubic theorem chain is Lean-checked under the existing `RepairCodes` and
`RepairPorts` namespaces. The prescribed-port asymptotics, reliability calculus, pointed-Tutte
specialization, and all-field harmonic proofs are manuscript arguments. Exact finite harmonic,
reliability, EXIT, and pointed-Tutte profiles are backed by the committed C218, C219, C226, C227,
C243, and C244 script/JSON bundles recorded in the proof ledger.

Classical ingredients remain labeled as such: concatenated-dual decomposition, Singer regularity,
random GV and AG/TVZ codes, normal-rational-curve nuclei, harmonic Steiner systems,
deletion--contraction reliability, BEC EXIT, Chen--Stein approximation, and the Las Vergnas
perspective polynomial. A none-found search is not a priority certificate.

C220's optional cubic blocker-stability strengthening is omitted by scope decision. Sequential
composition, service regions, coefficient optimization, log-concavity,
product architecture, and random harmonic-cascade thresholds are outside scope.

## Files

- `complete_repair_ports.tex` — main manuscript.
- `complete_repair_ports.pdf` — rebuilt private artifact.
- `refs.bib` — bibliography.
- `proof_ledger.md` — exact claim, trust, and evidence boundary.
- `adversarial_novelty_review.md` — internal novelty and overclaim audit; excluded from export.

## Build

From this directory:

```bash
nix shell nixpkgs#tectonic -c tectonic complete_repair_ports.tex
```

## Publication boundary

This directory belongs to the private monorepo. Publication must use the reviewed C275
deny-by-default allowlist into a new empty destination with fresh Git history. Do not publish,
fork, history-filter, or broadly copy the private monorepo. Repository identity/remote, license,
public rewrites and checker/archive identity, and the separately owned shared-Lean export remain
explicit gates. No push is authorized by manuscript assembly.
