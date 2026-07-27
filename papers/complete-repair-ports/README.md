# Complete bounded repair ports

**Title:** *Complete Bounded Repair Ports: Local Memory, Transfer, and Reliability*<br>
**Author:** Tavis Rudd<br>
**Status:** private corrected manuscript with the revised theorem hierarchy frozen; MDS
reconstruction, pointed transfer, positive-density fingerprints, and reliability/bounded EXIT have
complete human proofs and Lean terminals. The modular rewrite has not begun and publication export
remains gated.

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

The C286 correction pass repaired the exact transfer statement's zero-functional branch,
normalized the coefficient fibers correctly, completed the random/AG and Poisson proof chain,
and reconciled three context-light paragraph-by-paragraph cold reads. The private PDF remains a
12-page draft.

## Evidence boundary

The reconstruction, transfer, prescribed-port, reliability, and bounded-EXIT theorem chains are
Lean-checked under the existing `RepairCodes` and `RepairPorts` namespaces. Outer-family existence,
the pointed-Tutte specialization, and the retained harmonic geometry use the explicit manuscript
or literature boundaries recorded in the ledgers. Exact finite harmonic, reliability, EXIT, and
pointed-Tutte profiles are backed by the committed C218, C219, C226, C227, C243, and C244
script/JSON bundles and remain appendix material.

Classical ingredients remain labeled as such: concatenated-dual decomposition, Singer regularity,
random GV and AG/TVZ codes, normal-rational-curve nuclei, harmonic Steiner systems,
and the Las Vergnas perspective polynomial. A none-found search is not a priority certificate.
The Clebsch specialization is a manuscript corollary of the MDS dual
parameters and the prescribed-port theorem; it is not represented as a
separate Lean terminal.

C220's optional cubic blocker-stability strengthening is omitted by scope decision. Sequential
composition, service regions, coefficient optimization, log-concavity,
product architecture, and random harmonic-cascade thresholds are outside scope.

## Files

- `complete_repair_ports.tex` — main manuscript.
- `complete_repair_ports.pdf` — rebuilt private artifact.
- `refs.bib` — bibliography.
- `proof_ledger.md` — exact claim, trust, and evidence boundary.
- `adversarial_novelty_review.md` — internal novelty and overclaim audit; excluded from export.

Paper control for the revised draft lives in:

- `theorem-map.md`;
- `claim-proof-novelty-ledger.md`;
- `formalization-ledger.md`;
- `formal-statement-adequacy.md`;
- `verification-map.md`;
- `second-draft-fix-plan.md`; and
- `sections/README.md`.

The legacy `proof_ledger.md` remains the detailed source inventory until the
new ledgers have absorbed and validated every retained row.  It is not the
admission authority for the revised body.

## Build

From this directory:

```bash
nix shell nixpkgs#tectonic -c tectonic complete_repair_ports.tex
```

## Publication boundary

This directory belongs to the private monorepo. Publication must use the reviewed C275
deny-by-default allowlist into a new empty destination with fresh Git history. Do not publish,
fork, history-filter, or broadly copy the private monorepo. The approved paper destination is
`tavisrudd/complete-ports` staged at `~/src/papers/complete-ports` with the MIT license. Public
rewrites and checker/archive identity, and the separately owned shared-Lean export at
`~/src/papers/lean`, remain explicit gates. No initialization, copy, publication, or push is
authorized by manuscript assembly or these metadata decisions.
