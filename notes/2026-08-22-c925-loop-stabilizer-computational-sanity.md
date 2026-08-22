# C925 loop-stabilizer computational sanity check

## Claim checked

Let a chosen source point have exact period \(n=m+1\) under one loop.  A
target point with exact period \(\ell\) has the same stabilizer in the loop
group exactly when \(\ell=n\).  If the periods differ, one of \(n,\ell\) is a
loop power whose fixedness distinguishes the two points.  For the Kummer
translation

\[
  i\longmapsto i+a\quad\text{on }\mathbf Z/n,
\]

the exact period is \(n/\gcd(n,a)\).

For a nonsplit packet over an outer orbit of period \(t\), let \(h\) be the
period of the actual return map after \(t\) loop steps.  The total point has
period \(th\).  The check distinguishes this return-map period from the
one-step period of an independent inner action.  It also evaluates the center
dimensions allowed by

\[
  \frac{n}{\gcd(n,n+1-d)}\le d
  \quad\text{and}\quad
  \frac{n}{\gcd(n,n+1-d)}<d
\]

at \(n=2,3,4,5,14\).  The strict inequality is conditional on a separate
argument excluding equality.

The Haskell check validates this finite arithmetic independently of any QDM
interpretation.  It is the executable input shape consumed by
`Comparison.TwoLayerDescentPacket.sourceSum_not_equivariantlyEquivalent_of_distinctPowerFixednessPeriods`.
Lean also proves the gcd reduction
`modulus_dvd_power_mul_iff_reducedPeriod_dvd_power`.

The later module `Comparison.LoopStabilizerPath` packages the same Boolean as
an edge-local path invariant.  A vertex has selected-period support when one
of its packet points has the displayed fixedness fingerprint.  A blowup edge
is an equivariant equivalence from its source packet to the disjoint union of
the ambient packet and one whole correction packet.  If no correction point
has the selected period, Lean proves an iff between the two endpoint
Booleans.  A forward blowdown consumes that exclusion; a reverse
base-to-blowup step uses only the inverse ambient inclusion.  These directional
steps compose in a dependent path whose shared vertex datum is definitionally
the same.  Thus the final consumer no longer
requires geometry to first assemble one global stable ledger.

`LoopStabilizerPath.OrbitTransport` is weaker again: an injective equivariant
map between consecutive vertex packets preserves the exact period, so a path
of such maps carries the source witness to the endpoint.  It assumes neither
surjectivity nor a correction decomposition.  This exposes a second possible
source route: prove directly that the one carried marked orbit has ambient
provenance at each edge.  It does not follow from an unlabelled F-bundle
decomposition when isomorphic marked factors can be permuted.

`Comparison.OccurrenceLoopCertificate` closes a different finite-checking
gap.  It represents the target as a dependent sum of occurrence tags and
their label types, with an explicit permutation in each fibre.  Lean proves
that every power preserves the occurrence tag.  A lawful relabelling must
conjugate these permutations.  The executable certificate checks one
fixedness-separating power per actual tagged point and a separate `Realizes`
equation identifies the table with the geometric group generator.  Thus a
claimed period list, an occurrence-mixing permutation, or a hand-relabelled
charge cannot enter the terminal theorem without an explicit proof.  Geometry
must separately identify the exhaustive marked packet with this tagged
carrier; `Realizes` alone cannot detect an omitted hidden orbit.

## Exact domain

The deterministic part checks:

- every translation charge modulo \(n\), for \(2\le n\le65\), by comparing
  the gcd formula with direct iteration (2,144 cases);
- every ordered pair of periods in \(\{1,\ldots,65\}\) (4,225 cases);
- inverse-translation invariance over the same translation domain;
- the red Kummer model \(x^n=t\), the green split model \(x^n=1\), and four
  omission/mutation tests that reject cardinality-only, return-only, and
  mixed-ledger substitutes for exact periods;
- an occurrence-tagged flattened permutation with direct tag-preservation and
  point-period checks;
- rejection of a lying period table and of a loop that mixes occurrence tags;
- acceptance of inverse-charge conjugacy and rejection of a nonconjugate
  relabelling;
- direct Kummer/split permutation fingerprints at \(m=1,2,3,4,13\);
- split and nonsplit outer-period-two examples, checking respectively total
  periods four and eight from their actual return maps;
- the period-three charge test on outer translation packets of lengths two
  and four;
- the pre-strict and post-strict center-dimension tables at
  \(n=2,3,4,5,14\);
- the named stabilization indices \(m=1,2,3,4,13\).

Three fixed-seed QuickCheck properties add 27,000 generated cases.  The seed
is 925 and each generated positive integer is reduced to the interval 1,…,128.

The named Kummer tables are:

| \(m\) | \(n=m+1\) | charges with period \(n\) |
|---:|---:|---|
| 1 | 2 | 1 |
| 2 | 3 | 1, 2 |
| 3 | 4 | 1, 3 |
| 4 | 5 | 1, 2, 3, 4 |
| 13 | 14 | 1, 3, 5, 9, 11, 13 |

Thus the abstract packet \(x^{m+1}=t\) is a red correction for every checked
\(m\).  The computation does not exclude it geometrically.

## Replay

Working directory: repository root.

```sh
nix shell --impure --expr \
  'with import <nixpkgs> {}; haskellPackages.ghcWithPackages (p: [p.QuickCheck])' \
  --command sh -c \
  'runghc -Wall notes/cubic-threefolds-tasks/c925-loop-stabilizer-sanity.hs \
   | diff -u \
       notes/cubic-threefolds-tasks/c925-loop-stabilizer-sanity-output.txt -'
```

The replay used GHC 9.10.3 and QuickCheck 2.15.0.1.

## Hashes and byte counts

| artifact | bytes | SHA-256 |
|---|---:|---|
| `c925-loop-stabilizer-sanity.hs` | 13,244 | `4045065020f4b1c130d833a90e7695e640dee28acee4534016dbd1ac354dfffc` |
| `c925-loop-stabilizer-sanity-output.txt` | 1,841 | `c003a904d01dcfd2e9368ef07e956a3a8f034e183773661032e1ce64eb8fc35b` |

## Independent check and trust boundary

The translation periods are computed twice: by the closed gcd formula and by
direct iteration of the permutation.  Lean independently proves that unequal
natural-number periods have different divisibility fingerprints and that this
prevents an equivariant stable-ledger equivalence.  The Lean declarations are

- `exists_power_fixedness_divisibility_difference`;
- `modulus_dvd_power_mul_iff_reducedPeriod_dvd_power`;
- `sourceSum_not_equivariantlyEquivalent_of_distinctPowerFixednessPeriods`;
- `LoopStabilizerPath.Edge.hasPeriodAt_iff`;
- `LoopStabilizerPath.hasPowerFixednessPeriod_of_outer_return`;
- `LoopStabilizerPath.Decomposition.hasPeriodAt_source_of_target`;
- `LoopStabilizerPath.Path.hasPeriodAt_of`;
- `LoopStabilizerPath.Path.false_of_sourcePeriod_of_targetNoPeriod`;
- `LoopStabilizerPath.OrbitTransport.Path.hasPeriodAt_of`;
- `LoopStabilizerPath.OrbitTransport.Path.false_of_sourcePeriod_of_targetNoPeriod`;
- `OccurrenceLoopCertificate.Ledger.loopPermutation_pow_occurrence`;
- `OccurrenceLoopCertificate.FixednessCertificate.of_check_eq_true`;
- `OccurrenceLoopCertificate.no_selectedPeriod_of_certificate`;
- `ThreefoldKummerCompatibility.OuterPeriodThree.three_nsmul_charge_eq_zero`;
- `ThreefoldKummerCompatibility.CyclicPowerRegression.preStrictCandidateDimensions_named_values`;
- `ThreefoldKummerCompatibility.CyclicPowerRegression.postStrictUnresolvedDimensions_named_values`.

The Haskell execution and GHC/QuickCheck implementation remain trusted.  The
calculation does not prove that an actual QDM marked packet is finite étale,
that a displayed local exponent labels one of its primitive branches, that the
listed branches are exhaustive, or that every weak-factorization comparison
uses the same loop.  Those are the geometric source hypotheses still required
for the unconditional \(m=2\) or all-\(m\) theorem.

The guarded queue built the reviewer `PaperInterface` in run
`20260822-191101-a66e3c3a` and the full `Verification.AxiomAudit` in run
`20260822-191827-bc6d5553`.  Both aggregate gates passed.

## Mystery ledger

- **Settled:** full stabilizers need not be computed.  One distinguishing
  power per target point suffices, and unequal exact periods produce it.
- **Settled:** a global oriented correction ledger is not needed by the
  consumer.  Edgewise equivariant ambient-plus-correction decompositions and
  local correction-period exclusion on blowdown-oriented steps telescope
  through a typed path.  Reverse traversal needs only the ambient inclusion.
- **Settled:** a finite certificate need not trust reported orbit periods.
  It can check fixedness directly on an occurrence-tagged permutation, while
  a separate equality ties that permutation to the actual loop action.
- **Settled:** the cyclic arithmetic is not the obstruction.  The gcd formula
  is kernel-checked, and the executable suite covers the named stabilization
  indices and all charges through period 65.
- **Settled:** a nonsplit outer packet uses the period of the actual return
  map, not the period of a hypothetical commuting inner action.  The suite
  contains split and nonsplit mutation tests, and Lean proves the abstract
  product law from fixedness fingerprints.
- **Settled:** the pre-strict and post-strict dimension tables are different.
  At packet length three the first is \(\{1,3\}\) and the second is empty;
  the latter remains conditional on excluding the threefold equality case.
- **Settled:** an unmarked Mori interpretation cannot exclude period three.
  The quadric-threefold and Type-II transition examples carry cubic local
  monodromy without producing the required projective-bundle carrier.
- **Settled:** raw normalized \(z=0\) augmentation cannot replace the loop
  ledger.  The \(B\times F_1\) blowup has a row-visible marked correction;
  primitive-factor preservation makes the obstruction independent of the
  permutation of the four outer \(F_1\) factors.  The full and
  projector-restricted row laws are both false as universal providers.
- **Open:** construct an occurrence-wise comparison from the C924 marked
  finite étale QDM index scheme to labelled nearby-cycle branches over the
  actual transported trait, equivariant for one named loop.
- **Open:** prove that each blowup comparison is exhaustive on the marked
  primitive-factor scheme and equivariant for the vertex family's actual
  loop.  Reverse traversal then uses the same edge equivalence; no independent
  inverse comparison is needed.
- **Open:** exclude exact period \(m+1\) on the marked correction branches.
  Chuang's exponent formula makes this finite once the two preceding adapters
  exist, but it does not supply the marker-specific exclusion.
- **Open:** for \(m=2\), the accepted low-dimensional marker theorem removes
  the dimension-one candidate at the generic even base.  Exact period three
  on the single outer factor of each codimension-two threefold-center
  occurrence is still not excluded.

An exponent multiset is not a substitute for the labelled branch action:
three fixed eigenlines and one regular three-cycle can have the same character
spectrum while their point stabilizers differ.  Any successor certificate
must therefore retain the primitive branch labels or prove a theorem that
recovers them.
