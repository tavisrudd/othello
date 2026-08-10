# clebsch-passages verification

`trust_manifest.json` is the nine-row claim/evidence map.
`statement_identity.json` freezes the nine theorem-like statements in
manuscript order.

Run from the repository root:

```text
python3 papers/clebsch-passages/verification/verify_release.py
```

The aggregate gate verifies:

- exact statement identity, label-level trust-row correspondence, and frozen
  row prose/proof modes/evidence routes;
- primary, independent, and checksum gates for the arithmetic, orientation,
  and harmonic evidence bundles; and
- the public packaging allowlist and a manuscript build with no box,
  citation, or reference warning.

The statement extractor can be run separately with

```text
python3 papers/clebsch-passages/verification/extract_statement_identity.py --check
```

The harmonic bundle is replayed with

```text
python3 papers/clebsch-passages/verification/evidence/harmonic_clebsch.py --check
python3 papers/clebsch-passages/verification/evidence/harmonic_clebsch_replay.py
sha256sum -c papers/clebsch-passages/verification/evidence/harmonic_clebsch.sha256
```

It reconstructs the explicitly labelled face axes, the Petersen graph, the
reproducing-kernel matrix, the normalized spherical Gram matrix, the exact
moments, and the conversion to the standard unnormalized \(W_6\).

The arithmetic bundle is deliberately smaller than its human proof:

```text
python3 papers/clebsch-passages/verification/evidence/arithmetic_cover.py --check
python3 papers/clebsch-passages/verification/evidence/arithmetic_cover_replay.py
sha256sum -c papers/clebsch-passages/verification/evidence/arithmetic_cover.sha256
```

It checks the canonical-degree and branch-cycle bookkeeping and the explicit golden configurations over
\(\mathbf Q[t]/(t^2-t-1)\), all twenty three-point determinants, the
conjugating projectivity, its reduction modulo \(11\), and the reflection
norm product.  It contains no Mathieu, Hadamard, matching, or external
certificate branch.

The orientation-source bundle is replayed with

```text
python3 papers/clebsch-passages/verification/evidence/orientation_source.py --check
python3 papers/clebsch-passages/verification/evidence/orientation_source_replay.py
sha256sum -c papers/clebsch-passages/verification/evidence/orientation_source.sha256
```

For the displayed marking, it checks the scalar factorization of the pulled-back
cover, the conference square, the exact golden exchanger, the reversal of all
triangle signs, all six outer coefficient words against the manuscript table,
and the primitive Petersen pair-sum identities.  It does not
prove that the incidence sheet determines that marking or the chart lift.
Scheme normalization, extension
across the branch divisor, and the complete geometric bad-prime set remain
human boundaries.

The aggregate gate does not compare either theorem with a finite matching
tensor.  It also does not turn the abstract integral equation into a global
incidence model at \(11\).  The mod-\(11\) claim is the exact reduction of
the displayed golden fibre and exchanger; the geometric incidence comparison
remains over an unspecified cofinite base.

The manifest states `formal_coverage: partial mechanisms; no complete
manuscript row claimed`.  The current-paper gate is replayed with

```text
python3 verification/verify_passages_lean.py \
  --lean-root /path/to/formal-artifact --source-only
```

`passages_formal.json` maps each of the nine manuscript rows to exact Lean
declarations and records the missing geometric hypotheses.  Its gate proves
the abstract pinching, conductor, involution, golden-character, tight-frame,
switching, Petersen, fixed-line, and normalized aligned-design mechanisms.
For aligned designs it checks the two-cut classifier by kernel decision and
proves the third-point disambiguation, overlap consistency, signing transport,
four-by-four determinant identity, and query polynomial symbolically.  The
two bounds behind the triangle Ramsey equality on six labelled points, and the
aligned anchor they produce, are kernel-checked and printed by the gate; the
finite-set extension, the normalization from an arbitrary labelled two-graph,
and the distinctness of the six anchor points from each other and from the
root remain human inputs, as do the global Hitchin correspondences, face-axis
addition theorem, and raw spherical moment.
`passages_source_closure.json` is the exact project-local transitive import
closure produced by the repository import-closure tool; the verifier pins the
inventory, every listed source, and its own bytes.

Repository validation elaborates the gate through the guarded Lean entry
point.  Its disk-backed standard output is checked separately with

```text
python3 verification/verify_passages_lean.py \
  --lean-root /path/to/formal-artifact --axiom-log /path/to/gate-stdout.log
```

The replay program never starts Lean or Lake itself.

The operator consolidation uses the expanded golden-return theorem package as
a second pinned formal map.  It covers the conference, triangle, two-graph,
middle-exterior, support-recovery, golden-descent, fixed-conference
commutator-Pfaffian, order-six skew determinant-square, outer Segre-relation,
cut-block, and order-six signed-triangle mechanisms.  The determinant square is proved for every
order-six skew-symmetric matrix with vanishing diagonal over a commutative
ring, and specialized to the fixed conference bracket matrix, whose
determinant is sixteen times the square of its triangle cubic.  The six
signed translates of the triangle cubic under the reorderings fixing the first
three labels are checked to satisfy both equations of the Segre cubic
threefold: they sum to zero and their cubes sum to zero, identically in the
coordinates and over every commutative ring.  For a cut of arbitrary size of a
matrix squaring to a scalar, the cross block satisfies `B * Bᵀ = q • 1 - A * A`
on the chosen subset, the trace of the square of a zero-diagonal sign matrix is
the number of ordered pairs of distinct indices, and the three signed
Hamilton-cycle products of any four-set sum to `3` or to `-1`.  The fourth
trace is sorted by the support of the closed four-walks it counts: it is
`d(d-1) + 12*C(d,3)` plus the four-set weights, each of which is `24` or `-8`,
eight times `3` or `-1`; and equal four-subset weight sums over all balanced
halves of a `2d`-element label set with `4 <= d` force that weight to be
constant on four-sets, by one-element swap descent on inclusion sums.  The
exchange operator of a balanced cut has the characteristic polynomial and every
power trace of `1 - q^-1 A^2`, its first two moments are `d^2/q` and
`(d q^2 - 2 q d(d-1) + d(d-1) + 12*C(d,3) - 8*C(d,4) + 32 c)/q^2` for `c` the
number of aligned four-sets of the half, and at order six the polynomial is
`(X - 1/5)(X - 4/5)^2` whatever the cut.  Over the real numbers those
statements are unconditional: both spectral isometries are proved to exist, and
the characteristic polynomial of `1 - q^-1 A^2` is the product of
`X - (1 - a_i^2/q)` over the eigenvalues `a_i` of the principal block, which is
the eigenvalue reading of the spectrum.  A subset `Y` of a single label set is
turned into cut coordinates by relabelling along `Equiv.sumCompl`, under which
the principal block is the submatrix on `Y`, its fourth trace is the fourfold
sum over `Y`, and its aligned four-sets are the aligned four-subsets of `Y`;
hence no real number is the second exchange moment of every balanced half of a
symmetric conference matrix of order `2d` with `4 <= d`, while at order six the
polynomial is `(X - 1/5)(X - 4/5)^2` for every three-element subset.
Two qualifications belong with the exchange material.  The clause `4 <= d` is
what the swap descent needs, namely `4 + d <= 2d`; whether a matrix satisfying
the hypotheses exists at a given order is a separate question the formal
artifact does not address, so at any one order the content of that clause is
conditional on such a matrix existing there.  And the failure of independence is
formalized at the level of the second moment, hence of the characteristic
polynomial and of the eigenvalues with multiplicity; no separate statement about
the spectrum read as a set is proved.

The Ramsey exclusion
behind exchange rigidity, the classical inputs to the aligned-design
faithfulness argument, outer-family coherence, the cross-golden determinant
comparison, the identification of the six translates with the classical Joubert
coordinates, and the Segre--Igusa polar map remain human proof boundaries.  The
first of those is a boundary of the manuscript's *printed proof*, not a gap in
the formal conclusion: the Lean closes the same rigidity statement by the swap
descent and the whole-matrix fourth-trace pin, without the switching
normalization or the Ramsey bound.  Until the manuscript is edited to print that
route, the formal artifact certifies the theorem rather than the argument beside
it.
It is replayed against a checkout of the formal artifact with

```text
python3 verification/verify_golden_return_lean.py \
  --lean-root /path/to/formal-artifact --source-only
```

`golden_return_formal.json` fixes the Lean toolchain, source hashes, audit
gate, declarations, and exact exclusions.  `golden_return_axioms.txt` records
the complete pinned `#print axioms` output; replay rejects any change to that
report.  This supplemental gate
contributes partial mechanism coverage to `OPER-1`, `OPER-2`, `OPER-3`, and `OPER-4`; no manuscript theorem
takes Lean as a proof dependency.
`golden_return_source_closure.json` pins the exact project-local transitive
import closure.  A guarded gate log is checked by replacing `--source-only`
with `--axiom-log /path/to/gate-stdout.log`; the replay program does not invoke
Lean or Lake directly.

The four-shadow recognition gate is the third pinned formal map, replayed the
same way:

```text
python3 verification/verify_four_shadow_lean.py \
  --lean-root /path/to/formal-artifact --source-only
```

It covers the translation extraction, pair moments, diagonal and scalar
square, pentagon gauge, ten inner products, cubic homogeneity, and the
pentagon classification in both directions.  As with the other two gates,
every audited terminal depends only on `propext`, `Classical.choice` and
`Quot.sound`, and the replay enforces that by refusing compiled evaluation
anywhere in the pinned closure, and any external import outside Mathlib,
rather than merely recording the boundary.  The rank-14 weighted Jacobian calculation and any global
classification of remote weighted solutions are not formalized.
`four_shadow_formal.json`, `four_shadow_axioms.txt` and
`four_shadow_source_closure.json` play the same roles as their counterparts
above.

Each gate's axiom report is generated from a tracked build log rather than
written by hand.  `evidence/gate_stdout/passages.stdout.txt`,
`golden_return.stdout.txt` and `four_shadow.stdout.txt` are the standard
output of the gate builds the reports were taken from; each manifest pins the
log's bytes under `axiom_report_provenance`, and the replay checks that pin.
To regenerate a report, or to check one against its log:

```text
python3 verification/extract_axiom_report.py \
  --stdout verification/evidence/gate_stdout/<gate>.stdout.txt \
  --output verification/<gate>_axioms.txt

python3 verification/verify_<gate>_lean.py \
  --lean-root /path/to/formal-artifact \
  --axiom-log verification/evidence/gate_stdout/<gate>.stdout.txt
```

`extract_source_closure.py` regenerates a closure inventory from a Lean tree
the same way.  Neither a report nor an inventory may be edited by hand: the
verifiers compare them byte for byte.
