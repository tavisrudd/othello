# Strength-Two Trades and Transversal Cubic Gates

[![Concept DOI](https://img.shields.io/badge/Concept_DOI-10.5281%2Fzenodo.22666172-blue.svg)](https://doi.org/10.5281/zenodo.22666172)

## Read the paper

[**Open the paper (PDF) →**](clebsch-cubic-phase.pdf)

**Title:** *Strength-Two Trades and Transversal Cubic Gates: The Clebsch
Cubic-Phase Codes and Their Magic*

**Author:** Tavis Rudd ([ORCID](https://orcid.org/0009-0003-6405-3275)).

A transversal gate acts separately on the physical qudits of a quantum code,
yet its logical action can couple many qudits. This paper asks how finite
geometry can specify that logical phase, how its resource state can be
distinguished from independently prepared states, and when preparing the
whole block saves noisy inputs.

The construction starts with two signed point sets that agree on every
quadratic polynomial. Their third-moment difference is a cubic logical phase.
This translates strength-two trades into high-rate error-detecting codes;
the signed-orthogonality mechanism belongs to the established theory of
qudit transversal gates. The paper studies the phase geometry and preparation
cost of particular conic-matching examples.

## Main results

| Construction | Result | Boundary |
|---|---|---|
| Translation trade over every prime `p ≥ 5` | `[[2p,p−1,2]]_p` code with a transversal cubic logical gate | The parameters alone do not distinguish the symmetric geometry |
| Conic code `[[22,10,2]]_11` | Its ten-qudit phase state cannot become a product across any bipartition under any Clifford operation | Exact finite-field Hessian census enters the proof |
| Conic code `[[14,6,2]]_7` | Joint preparation costs fewer than `16.116` raw inputs per accepted block, versus lower bounds `54` or `36` for the specified separate-distillation menus | Independent uniform Z noise, ideal Clifford operations, `0 < δ ≤ 0.01`; not an unrestricted protocol lower bound |
| Five-variable chordal restriction | Exact relation to the invariant chordal/conference pencil and the Clifford action of its sign choices | Restriction of a logical polynomial does not itself construct a subcode |

The six-qudit conic state is not settled by the same bipartition exclusion
used for the ten-qudit example. Distance two supports error rejection,
not correction of an arbitrary single-site fault.

## Why the methods work

1. **Moment cancellation.** Agreement through degree two removes the
   stabilizer coordinate from the cubic phase. The surviving third moment
   determines the logical gate.
2. **Hessian rank.** A finite difference of a cubic is quadratic. Its exact
   Gauss sum converts the Hessian-rank distribution into the Pauli-modulus
   distribution and stabilizer Rényi entropies. A product-state fourth-moment
   bound then excludes Clifford-product decompositions in the stated cases.
3. **Preparation comparison.** Exact error enumerators bound the native
   factory's acceptance and output infidelity. A weighted cubic-rank bound
   forces at least nine separately purified synthesis terms in the comparison
   model. The entire input-error interval is treated with rational bounds.

The single-variable cubic is a model for the Hessian calculation. The paper
credits the prior qubit hypergraph formula and characteristic-function methods;
its finite-field conventions and source pinpoints are recorded in
[`verification/imported-sources.json`](verification/imported-sources.json).

## Proof and evidence boundary

The signed-moment dictionary, translation family, Hessian formula, product
ceiling and interval comparison have mathematical proofs in the manuscript.
The conic coordinate identities, exact rank spectra and shadow identification
also use finite computations. Every theorem-like statement has a stable
identifier and a recorded evidence dependence in
[`verification/claim-map.json`](verification/claim-map.json).

No Lean coverage is claimed. The lightweight checks independently repeat the
complete `p=7` Hessian census, expand both conic normal forms, verify their
moment and Schur-square identities, and test seven translation-family primes.
The factory checker cross-checks primal enumerators with MacWilliams transforms
and synthesis kernels with Fourier sums. The shadow check verifies the scalar
normalization and all `1320` geometric actions.

The large `p=11` census and the distance-three subspace exclusion are recorded
exhaustive executions, with source and finite-domain descriptions included.
They do not have independent full second implementations. The `p=13` Hessian
sample is not an exhaustive spectrum. These distinctions are retained in
[`supplement/REPRODUCING.md`](supplement/REPRODUCING.md).

## Verification

From this directory, use the pinned Nix environment:

```sh
nix develop .#manuscript --command make check
nix develop .#manuscript-pdf --command make pdf-check
```

The first command verifies statement identities, local input hashes, references,
exact inequalities, and the lightweight finite, shadow and factory certificates.
The second rebuilds from a fresh source copy and rejects a stale tracked PDF
or TeX layout/reference warnings. To regenerate the manuscript after an edit:

```sh
nix develop .#manuscript --command make pdf
```

Full symbolic and exhaustive replays have separate commands and cost estimates
in [`supplement/REPRODUCING.md`](supplement/REPRODUCING.md). Heavy searches are
explicit opt-in commands; `make check` does not run them. The package needs no
private checkout or account-specific file path.

## Files

- `clebsch-cubic-phase.pdf` is the paper; `main.tex` and `sections/` are its
  source.
- `verification/` contains the claim, imported-source and evidence maps,
  checksums, deterministic lightweight checks and their certificates.
- `supplement/reconstruction/` contains signed conic matrices and exact checks.
- `supplement/spectra/` contains Hessian tensors, rank records and census code.
- `supplement/classification/` contains conic-trade/subspace searches and the
  chordal restriction calculation.
- `supplement/factory/` contains exact preparation enumerators and interval data.
- `flake.nix` and `flake.lock` pin the build and replay toolchains.
- `.zenodo.json` and `CITATION.cff` contain citation metadata.

## Scope and questions

The conic translation-class enumeration is bounded by the tested primes
through `19`. It does not classify all trades or all Clifford-equivalent codes.
The distance-three negative concerns subspaces of one fixed evaluation space.
Arbitrary full-gate lifts of the shadow involution, exact Clifford-aware
synthesis costs and unrestricted adaptive preparation remain open.

## Citation

The concept DOI for all versions is
[10.5281/zenodo.22666172](https://doi.org/10.5281/zenodo.22666172).
The archived first draft, version `0.1.0`, has version DOI
[10.5281/zenodo.22666173](https://doi.org/10.5281/zenodo.22666173).
Citation metadata is provided in [`CITATION.cff`](CITATION.cff).
The repository is `tavisrudd/clebsch-cubic-phase` on GitHub.

## License

The manuscript and scholarly computational supplement are licensed under the
Creative Commons Attribution 4.0 International License; see
[`LICENSE`](LICENSE).
