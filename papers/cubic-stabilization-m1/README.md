# Irrationality after one stabilization

<a href="https://doi.org/10.5281/zenodo.21909944"><img src="https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21909944-blue.svg?cacheSeconds=3600&amp;v=21909944" alt="DOI: 10.5281/zenodo.21909944"></a>

## Read the paper

[**Open the paper (PDF) →**](irrationality_after_one_stabilization.pdf)

**Title:** *Irrationality of cubic threefolds after one stabilization.*

The paper proves that `X x P^1` is irrational for every smooth cubic threefold
`X`, by way of the ordinary Hodge-atom package of
Katzarkov--Kontsevich--Pantev--Yu and a rank-two atomic residue discriminant
whose value `4/9` on the cubic atom no curve or surface representative can
carry.  Kuznetsov's birational correspondence extends the conclusion to every
smooth `V_14 x P^1`.

The finer framed-monodromy invariant `nu_6` gives `nu_6(X) = 2` and the
stabilization identity `nu_6(X x P^1) = 4`.  Hypotheses 5.7R
(reconstruction-tail invariance) and 5.7T (divisor-tagging specialization)
carry only the refinement built on it: under them `nu_6` satisfies blowup and
projective-bundle operation formulas and is birationally invariant through
dimension four.  That refinement is stated as its own theorem in the
introduction and gives a second proof of the irrationality theorem, by a finer
invariant and under those two hypotheses.

The paper then gives a non-isotrivial pencil of smooth cubic threefolds that
are universally `CH_0`-trivial, where universal `CH_0`-triviality comes from an
algebraic primitive minimal class on the intermediate Jacobian; their products
with `P^1` are irrational.  Yang--Yu--Zhu (arXiv:2508.03623) already
supply a two-dimensional family of universally `CH_0`-trivial cubic
threefolds, by way of unirational parametrizations of coprime degrees; the
pencil here is distinguished by its mechanism, not by being the first such
family.

This is a logically independent paper: reading the numbered Clebsch papers is
not required.

## Build and verification

From this directory, run:

```text
make check
```

This checks the exact manuscript-to-Lean claim inventory, builds the PDF in
the pinned environment, and rejects manuscript warnings.  In the development
repository it also lints the TeX sources; the released repository drops that
step, whose helper lies outside the paper directory.  The Lean kernel and axiom audit are replayed separately using the
guarded commands documented in [`lean/README.md`](lean/README.md).

## Trust boundary

The paper is proof-first.  Its unconditional spine invokes no symbolic
computation as a premise: the six-axis realization, all-degree finite-etale
graph saturation, the cubic framed-monodromy computation, and the one-step
irrationality theorem of Section 4 are proved without additional hypotheses
beyond the cited external theorems, on which they are of course conditional in
the usual sense; for the irrationality theorem the decisive import is the
package of ordinary Hodge-atom theorems.  Exactly one statement invokes a
symbolic program as a premise, `lem:hirzebruch-euler-spectrum`, in the
conditional framed refinement of Section 5, and one coordinate lemma of
Section 3 rests on an exact elimination that nothing else depends on.  Both
computations, their cross-checks, and their replay commands are registered in
[`verification/evidence.json`](verification/evidence.json), and
[`verification/README.md`](verification/README.md) states the boundary in
full.

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
represented in Lean, and separately lists the kernel-checked declarations that
serve no current manuscript claim, each with the reason it stands apart.
Kernel-reported dependencies are checked against the exact allowlist in
[`lean/verification/expected_axioms.txt`](lean/verification/expected_axioms.txt).

## Repository contents

- [`cubic_stabilization_m1.tex`](cubic_stabilization_m1.tex):
  manuscript driver.
- [`sections/`](sections/): human proof sections.
- [`lean/`](lean/): pinned Mathlib companion and reviewer interface.
- [`verification/`](verification/): claim-coverage documentation.
- [`.zenodo.json`](.zenodo.json): archival deposit metadata.

## Citation and license

The archival DOI is
[`10.5281/zenodo.21909944`](https://doi.org/10.5281/zenodo.21909944).
The repository is licensed under CC BY 4.0; see [`LICENSE`](LICENSE).
