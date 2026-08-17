# Irrationality after one stabilization

<a href="https://doi.org/10.5281/zenodo.21909944"><img src="https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21909944-blue.svg?cacheSeconds=3600&amp;v=21909944" alt="DOI: 10.5281/zenodo.21909944"></a>

## Read the paper

[**Open the paper (PDF) →**](irrationality_after_one_stabilization.pdf)

**Title:** *Irrationality of cubic threefolds after one stabilization.*

The paper proves unconditionally that `X x P^1` is irrational for every smooth
cubic threefold `X`.  That proof runs on the ordinary Hodge-atom package of
Katzarkov--Kontsevich--Pantev--Yu and a rank-two atomic residue discriminant.
Also unconditional are `nu_6(X) = 2` and the stabilization identity
`nu_6(X x P^1) = 4` for every smooth cubic threefold, irrationality of every
smooth `V_14 x P^1`, and the cycle-theoretic universal-`CH_0`-triviality
results stated in Sections 2--3.

Hypotheses 5.7R (reconstruction-tail invariance) and 5.7T (divisor-tagging
specialization) carry only the finer framed-monodromy refinement: under them
the quantum obstruction `nu_6` satisfies blowup and projective-bundle
operation formulas and is birationally invariant through dimension four, which
gives a second proof of the irrationality theorem.  The paper then gives a
non-isotrivial pencil of smooth cubic threefolds that are universally
`CH_0`-trivial, where universal `CH_0`-triviality comes from an algebraic
primitive minimal class on the intermediate Jacobian; their products with
`P^1` are irrational.  Yang--Yu--Zhu (arXiv:2508.03623) already
supply a two-dimensional family of universally `CH_0`-trivial cubic
threefolds, by way of unirational parametrizations of coprime degrees; the
pencil here is distinguished by its mechanism, not by being the first such
family.

This is an unnumbered geometric epilogue to *Clebsch: Rigidity from Sparse
Shadows*.  It is a logically independent entry point: reading the numbered
Clebsch papers is not required.

## Build and verification

From this directory, run:

```text
make check
```

This lints the TeX sources, checks the exact manuscript-to-Lean claim
inventory, builds the PDF in the pinned environment, and rejects manuscript
warnings.  The Lean kernel and axiom audit are replayed separately using the
guarded commands documented in [`lean/README.md`](lean/README.md).

## Trust boundary

The paper is proof-first.  Exact computations used during discovery are not
part of its proof surface.  The current draft gives standalone unconditional
proofs of the six-axis realization, all-degree finite-etale graph saturation,
the cubic framed-monodromy computation, and the one-step irrationality
theorem, the last through the atomic route of Section 4.

Two hypotheses are used, and only in the framed-monodromy refinement of
Section 5.  Hypothesis 5.7R asks for invariance of the primitive-sixth framed
multiplicity under the reconstruction tail of the blowup and
projective-bundle formulas; Hypothesis 5.7T asks that the divisor-tagging
specialization preserve the two primitive-sixth multiplicities.  Both are
stated where they are first used, and every statement depending on either
says so.

The Mathlib-only formal companion is in [`lean/`](lean/).  It is an explicitly
partial reviewer artifact: its rejecting claim inventory covers every labelled
theorem-like environment and distinguishes proved fragments and conditional
deductions from claims that remain absent.  See
[`lean/README.md`](lean/README.md) for the exact interim coverage and replay
commands.

The authoritative claim-level map is
[`lean/verification/claims.json`](lean/verification/claims.json).  It records
the objects, hypotheses, conclusions, and cautions for every manuscript claim
represented in Lean.  Kernel-reported dependencies are checked against the
exact allowlist in
[`lean/verification/expected_axioms.txt`](lean/verification/expected_axioms.txt).

## Repository contents

- [`cubic_stabilization_epilogue.tex`](cubic_stabilization_epilogue.tex):
  manuscript driver.
- [`sections/`](sections/): human proof sections.
- [`lean/`](lean/): pinned Mathlib companion and reviewer interface.
- [`verification/`](verification/): claim-coverage documentation.
- [`.zenodo.json`](.zenodo.json): archival deposit metadata.

## Citation and license

The archival DOI is
[`10.5281/zenodo.21909944`](https://doi.org/10.5281/zenodo.21909944).
The repository is licensed under CC BY 4.0; see [`LICENSE`](LICENSE).
