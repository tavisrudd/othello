# C567 — stabilizer marginal moment and concurrency separator

**Lane:** `ame-lu`

**Date:** 2026-07-24

**Verdict:** `COMPLETE; THE CSS RANK, SIX-PARTY GRAPH REDUCTION, AND 70-VERSUS-66 IMPLICATION ARE FORMALIZED WITH THE TRACE, INCIDENCE, AND LU-COVARIANCE BRIDGES EXPOSED AS HYPOTHESES`

## Formal package

`RelativeConicArcs.AMELU.MarginalMoment` defines:

- omitted pairs and unordered triples of four-party marginals;
- three-edge stars and perfect matchings of the six parties;
- the four-party set complementary to an omitted pair;
- `tripleSupportedLabelSpace C E`, the sum of the three concrete
  `cssSupportedLabelSpace` submodules; and
- `stabilizerMarginalRank C E`, its finite-field dimension.

The three finite graph enumerations give exactly

```text
455 unordered marginal triples
60 three-edge stars
15 perfect matchings.
```

They are exhaustive `native_decide` terminals.  The ordinary proof
`marginalStar_not_perfectMatching` establishes the disjointness used in
the counting reduction.

`MarginalMomentModel 𝔽 C` exposes the two manuscript bridges separately:

```text
traceMoment(E) = |𝔽|^(-stabilizerMarginalRank(C,E)),

stabilizerMarginalRank(C,E)=4
  iff E is a star
      or E is a perfect matching concurrent in the arc and its Gale dual.
```

These are structure fields, not hidden axioms.  The package proves from
them

```text
#{rank-four triples} = 60 + #{common concurrent perfect matchings}.
```

It also proves that rank four gives the exact trace value `|𝔽|^-4`.

## Exact separator

`MarginalLUSeparatorInputs` records two equal-phase code states, their
marginal models, ten common concurrences for the source, at most six for
the target, and the basis-independent statement that LU equivalence
preserves the rank-four marginal multiplicity.

The terminal theorem
`not_locallyUnitaryEquivalent_of_ten_vs_atMostSix_concurrences` derives

```text
source multiplicity = 60 + 10 = 70,
target multiplicity ≤ 60 + 6 = 66,
```

and closes the contradiction by exact natural-number arithmetic.  Its LU
relation is the shared definition that already allows an arbitrary party
permutation and global phase.

The formal theorem is deliberately conditional.  This package does not
derive the density-matrix trace expansion, the chord-concurrency/rank
criterion, the H3 determinant identities, the GRS involution bound, or
the LU covariance of the moment multiset.  It names the first, second,
and covariance bridges in the formal interface; the exact H3 and GRS
counts remain the manuscript's mathematical inputs.

The import terminal is
`RelativeConicArcs.Gates.AMELUMarginalMoment`.  The adjacent
`AMELUMarginalMomentAxioms` terminal audits the finite counts, counting
reduction, and separator.

## Validation and trust

The source passed warning-free guarded elaboration.  The measured `single`
profile queue built

```text
RelativeConicArcs.AMELU.MarginalMoment
RelativeConicArcs.Gates.AMELUMarginalMoment
RelativeConicArcs.Gates.AMELUMarginalMomentAxioms
```

and passed the trace-only aggregate gate and exact no-build probes.  Peak
resident memory was 1,826,940 KiB.

The axiom audit reports `propext`, `Classical.choice`, and `Quot.sound`.
Each of the three graph-cardinality terminals additionally reports its
declaration-local `native_decide` axiom.  The counting reduction and final
separator inherit only the star-count native axiom because that is the
finite count used in their proofs.  There is no `sorry`, project-specific
axiom, generated source, external certificate, or unsafe declaration.

## `ej` / Tao closeout and mystery ledger

The closeout pass made the rank concrete rather than leaving it as an
uninterpreted natural number: it is now the `finrank` of the sum of the
three shared CSS supported-label submodules.  It also retained the
otherwise nonessential `455` and `15` checks, giving an exact audit of the
entire finite graph domain around the `60+b` formula.

No genuine combinatorial or arithmetic mystery remains in the proved
interface.  The open evidence boundary is exact: the trace expansion,
incidence/rank equivalence, H3 ten-count, GRS six-bound, and LU covariance
are hypotheses rather than formal derivations.  C570 owns the
declaration-level reconciliation of those conditional inputs with the
manuscript after the remaining packages close.

The discovery-track review found no incidental observation.  The concrete
CSS rank, graph counts, concurrency formula, and exact gap were all
deliverables sought by C567.
