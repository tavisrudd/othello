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
| `c925-loop-stabilizer-sanity.hs` | 11,124 | `eb247c714015c7e94563189ff34072d0c6bea3e2f731ed91f10dd01c9969c28a` |
| `c925-loop-stabilizer-sanity-output.txt` | 1,525 | `35e3bc47a3eebde20c4d1076ae99a885a48c05350e254c7f7d6e610034a02976` |

## Independent check and trust boundary

The translation periods are computed twice: by the closed gcd formula and by
direct iteration of the permutation.  Lean independently proves that unequal
natural-number periods have different divisibility fingerprints and that this
prevents an equivariant stable-ledger equivalence.  The Lean declarations are

- `exists_power_fixedness_divisibility_difference`;
- `modulus_dvd_power_mul_iff_reducedPeriod_dvd_power`;
- `sourceSum_not_equivariantlyEquivalent_of_distinctPowerFixednessPeriods`;
- `LoopStabilizerPath.Edge.hasPeriodAt_iff`;
- `LoopStabilizerPath.Decomposition.hasPeriodAt_source_of_target`;
- `LoopStabilizerPath.Path.hasPeriodAt_of`;
- `LoopStabilizerPath.Path.false_of_sourcePeriod_of_targetNoPeriod`;
- `LoopStabilizerPath.OrbitTransport.Path.hasPeriodAt_of`;
- `LoopStabilizerPath.OrbitTransport.Path.false_of_sourcePeriod_of_targetNoPeriod`;
- `OccurrenceLoopCertificate.Ledger.loopPermutation_pow_occurrence`;
- `OccurrenceLoopCertificate.FixednessCertificate.of_check_eq_true`;
- `OccurrenceLoopCertificate.no_selectedPeriod_of_certificate`.

The Haskell execution and GHC/QuickCheck implementation remain trusted.  The
calculation does not prove that an actual QDM marked packet is finite étale,
that a displayed local exponent labels one of its primitive branches, that the
listed branches are exhaustive, or that every weak-factorization comparison
uses the same loop.  Those are the geometric source hypotheses still required
for the unconditional \(m=2\) or all-\(m\) theorem.

The guarded queue built the minimized `LoopStabilizerPath` and the full axiom
audit in run `20260822-160244-effd621a`.  It built
`OccurrenceLoopCertificate` and the full axiom audit in run
`20260822-155313-d281179c`.  Both aggregate gates passed.

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

An exponent multiset is not a substitute for the labelled branch action:
three fixed eigenlines and one regular three-cycle can have the same character
spectrum while their point stabilizers differ.  Any successor certificate
must therefore retain the primitive branch labels or prove a theorem that
recovers them.
