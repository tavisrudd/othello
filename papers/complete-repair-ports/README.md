# Complete Bounded Repair Ports

[![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.22051904-blue.svg)](https://doi.org/10.5281/zenodo.22051904)

## Read the paper

[**Open the paper (PDF) →**](complete_repair_ports.pdf)

**Title:** *Complete Bounded Repair Ports: Transfer, Reliability, and Geometric Structure*

This 23-page paper introduces a local invariant of a represented linear code.
Fix a coordinate and a helper budget. Its **complete bounded repair port**
records every dual recovery equation within that budget—not just the permitted
helper sets, but also the normalized scalar coefficients and the resulting
probability of successful repair under helper failures.

The main theorem identifies the exact obstruction to carrying such a port
through code concatenation. Below that obstruction, any fixed represented port
can be reproduced on a positive-density coordinate class in an asymptotically
good fixed-alphabet family. The obstruction is sharp in the stated
fixed-inner, linear-concatenation setting.

The principal separation shows why the bounded port contains information that
standard unfiltered rank data and coarse local statistics miss. Over one
finite field, two represented `[10,4,6]` inner codes have the same pointed
rank-triple multiplicity enumerator, five minimum repairs, locality three,
matching number two, transversal number two, a unique minimum blocker, and the
same helper-degree multiset. Their radius-three reliability laws are nonetheless

```text
5s³ − 7s⁵ − s⁶ + 5s⁷ − s⁹
5s³ − 7s⁵ − 2s⁶ + 8s⁷ − 3s⁸.
```

Using the same outer family produces asymptotically good code families with
matched length and dimension formulas, the same distance lower bound, and
density-`1/10` target classes retaining these distinct local laws. The seed
representations have a structural proof: realize two five-line incidence
patterns in a quotient plane, then choose a generic lift into projective
three-space and specialize to one finite prime field.

## Other results

- The minimum coefficient port of an MDS code reconstructs the represented
  code, although its support projection is the generic complete uniform
  clutter.
- Port reliability satisfies deletion–contraction and pivotal identities.
  Successive bounded-EXIT curves recover the cheapest available repair radius.
- Full-radius reliability is a specialization of the Las Vergnas polynomial
  of an elementary matroid perspective; the bounded-radius filtration is
  strictly finer.
- Characteristic-three twisted-cubic–axis and quartic–nucleus codes give exact
  geometric port inventories. The quartic example produces a harmonic Steiner
  repair design.

## Suggested reading

The introduction states the complete theorem chain and Figure 1 gives its
logical spine. Readers interested primarily in the asymptotic separation can
then read the definitions in Section 2, the transfer and realization theorems
in Sections 3–4, and the sparse-paving constructions in Section 6. The
field-seven matrices give the smallest explicit filtration counterexample;
the five-line quotient construction gives the stronger availability- and
blocker-matched theorem. The geometric applications in Section 7 are
independent demonstrations of the framework.

## For referees

The shortest route through the central argument is:

1. **Exact transfer:** Theorem 3.1 decomposes a concatenated dual word by its
   block functionals and minimizes each realization fiber. The all-zero,
   singleton, and multisupport functional strata are treated separately.
2. **Sharp eventual boundary:** Theorem 4.1 proves that the persistent
   zero-functional obstruction is necessary and sufficient for eventual
   bounded confinement in the stated setting.
3. **Small explicit boundary:** Lemma 6.3 and Proposition 6.4 use
   sparse-paving structure and two displayed matrices over `F₇`. Appendix A.1
   prints every four-column determinant needed to check those representations.
4. **Matched structural seeds:** Theorem 6.5 displays two five-edge clutters,
   checks their matching, transversal, blocker, degree, and reliability data,
   and represents them by a quotient-plane line arrangement and generic lift.
5. **Asymptotic synthesis:** The same theorem applies one common outer family,
   giving matched global formulas, density-`1/10` target classes, and distinct
   reliability laws.

The manuscript contains full written proofs of the promoted theorem chain.
Lean checks the general transfer, parameter, reliability, and bounded-EXIT
components; it does not package the structural seed construction and
asymptotic specialization into one theorem. The five-line seed construction
and generic finite-field specialization are proved in the manuscript. The
smaller field-seven matrix facts used by Proposition 6.4 are proved from the
printed determinant ledger and independently checked by
`verification/f7-seed.py`. Random-linear outer-family existence is an explicit
classical input.

## Proof and evidence boundary

The reconstruction, transfer, prescribed-port, reliability, and bounded-EXIT
chains have Lean 4 support. The matched asymptotic theorem is a written
synthesis of kernel-checked general components, a complete structural human
proof of the two represented seeds and their local invariants, and a classical
outer-family existence theorem. The independent field-seven replay checks the
separate small counterexample and carries no logical weight for the stronger
matched theorem. The manuscript labels these roles separately.

The scalar repair protocol downloads one complete base-field symbol from each
contacted helper. It does not claim minimum subsymbol access, optimal repair
bandwidth, full symbol-MAP behavior at a finite radius, or a capacity theorem.

## Verification

The Lean development is published through
[`tavisrudd/finitegeom`](https://github.com/tavisrudd/finitegeom). Exact
formal boundaries and replay instructions are in [`verification/`](verification/).

From this directory,

```text
make check
```

performs a clean deterministic rebuild, requires byte-for-byte agreement with
the tracked PDF, rejects TeX warnings and private-path leakage, validates
metadata and the AI disclosure, and replays the field-seven certificate.

## Files

- `complete_repair_ports.tex` is the manuscript driver.
- `sections/` contains the numbered theory, application, conclusion, and
  verification/evidence sources.
- `figures/` contains the source-native proof-spine diagram.
- `verification/` pins the formal source/base revisions, module closure,
  terminal count, gate-fact hash, and guarded replay commands.
- `refs.bib` contains the bibliography.
- `.zenodo.json` contains preprint deposit metadata; it creates no deposit or
  DOI by itself.

## Citation

The archival identifier is
[`10.5281/zenodo.22051904`](https://doi.org/10.5281/zenodo.22051904).

## License

The contents of this repository are licensed under the MIT License; see
`LICENSE`.
