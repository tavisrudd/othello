# C724 — Paper I finite-census certificate compression

**Lane:** `clebsch`

**Date:** 2026-07-31

**Verdict:** complete.  The irreducibly finite Paper I leaves now have a
compact orbit ledger and local determinant witnesses.  The full normalized
enumerations remain independent audits; no uniform classification theorem is
claimed.

## Certificate theorem

The certificate has three finite layers.

1. The (1,548) frame-normalized six-arcs over (mathbf F_{11}) split into
   fifteen projective orbits.  For every orbit the certificate records a
   canonical representative, normalized orbit mass, stabilizer order, number
   (c(A)) of triple chord concurrences, and the conic-distance histogram.
   The identities

   \[
   |G_A|\,m_A=360,
   \qquad \sum_A m_A=1548,
   \qquad |\mathcal U(A)|=22-c(A)
   \]

   verify stabilizers, completeness, and every uncovered-set size without a
   new point-count census.  The fifteen values of (c(A)) are
   (2,4,3,3,2,2,1,2,2,3,6,0,4,4,10).  The non-Clebsch conic-distance gap is
   still (12).  Its absence-of-a-nearer-conic assertion remains an exhaustive
   exact calculation; the certificate compresses that calculation to one
   intersection histogram and one attaining conic per orbit.
2. For each of the fourteen non-Clebsch orbits, ten certified uncovered points
   give a nonsingular (10\times10) cubic-evaluation minor.  For the Clebsch
   orbit, the certificate instead gives its quadratic generator (Q), checks
   quadratic nullity one and cubic nullity three, and verifies symbolically
   that the three independent cubic generators are (QX,QY,QZ).  Thus the
   reader-facing rigidity test is local linear algebra, not fifteen unexplained
   row reductions.
3. Among seven-arcs with (|\mathcal U|=q+1), the (140) normalized objects at
   (q=11) form one projective orbit with stabilizer order (6); the (1,680)
   normalized objects at (q=13) form two orbits of mass (840), both with
   trivial stabilizer.  In each of these three orbits, six certified uncovered
   points give a nonsingular quadratic-evaluation minor.  The orbit-mass
   identities and the old full normalized-domain enumeration together prove
   completeness.

The machine-readable certificate is
`papers/clebsch-rigidity/verification/finite_census_certificates.json`; its
builder and direct verifier are
`papers/clebsch-rigidity/verification/build_finite_census_certificates.py`.

## Replay and trust boundary

From `papers/clebsch-rigidity/` run:

```sh
python3 verification/build_finite_census_certificates.py
python3 verification/build_finite_census_certificates.py --audit
```

The first command checks canonical representatives, orbit sizes and
stabilizers, chord-concurrence formulas, the fourteen cubic determinants, the
Clebsch kernel generators, the three quadratic determinants, and all mass
identities directly from the compact JSON.  The second regenerates the JSON
from all (1,548) normalized six-arcs, all (160,930) nonsingular conics, and
the (10,232) and (53,960) normalized seven-arcs, then requires byte-for-byte
agreement.  This is the independent full-domain replay.  Arithmetic is exact
over the prime fields and the programs use only Python's standard library.

The direct certificate does not turn the conic-distance histogram into a
structural bound: the exhaustive conic enumeration remains load-bearing for
the numerical gap.  Nor does the seven-arc orbit quotient prove an all-field
exclusion.  It certifies only the surviving (q=11,13) finite leaves after the
paper's structural window reduction.

The failed first-order rational LP is also frozen.  After a passant root edge
(B=\{a,b\}), the extension domain is the product of the two residual passant
pencils and

\[
\operatorname{LP}(B)=\min(r(a),r(b)),\qquad
r(P)=\begin{cases}(q-3)/2&P\text{ exterior},\\(q-1)/2&P\text{ internal}.
\end{cases}
\]

Hence the relaxation has value at least ((q-3)/2\ge5) for every odd
(q\ge13), while an exclusion needs the bound (4).  Its exact values are
(7,8) at (q=17) and (8,9) at (q=19); this LP cannot supply a structural
seven-arc exclusion.

## Evidence manifest

| file | bytes | SHA-256 |
|---|---:|---|
| `build_finite_census_certificates.py` | 20,315 | `ce2a2dabe58dd6d6d846eb100ecab8ccb6032b3ad5b45bbb0b3f4ca308e94258` |
| `finite_census_certificates.json` | 34,906 | `7a50315cdf7a605d6d979bb2a070d1ddbf98b65cf53404e0e60da1fd47aaa041` |

The adjacent `finite_census_certificates.sha256` records the same hashes.

## `ej` + `tt` closeout

The cheap extra compression is substantial: the (1,820) seven-arcs surviving
the size test collapse to only three projective orbits, so three (6\times6)
determinants replace (1,820) rank computations in the direct proof surface.
The Tao-style check asks whether those three orbits admit a common conceptual
exclusion.  Their chord moments are forced and do not distinguish the two
(q=13) orbits, while both stabilizers are trivial.  No honest common geometric
mechanism is visible at this layer, so the orbitwise determinants are the
correct stopping point.

## Mystery ledger

| feature | status | evidence gap or owner |
|---|---|---|
| The (q=11) size-(12) seven-arcs form one orbit, but the (q=13) size-(14) seven-arcs split into two equal free orbits. | open but bounded | Chord moments and stabilizers do not distinguish the two (q=13) classes.  Any stronger invariant belongs to C725's terminal orbit DAG, not to this compression task. |
| The conic-distance gap has no short local dual certificate analogous to the evaluation minors. | settled as a trust boundary | The complete conic-intersection histograms are retained, and `--audit` replays all (160,930) conics. |
| The first-order rational LP might prove a uniform passant-arc bound. | settled negatively | Its exact optimum is the smaller residual-pencil size, already at least (5) for odd (q\ge13). |

No other genuine mystery remains inside C724's bounded certificate scope.

## Handoff

C725 may treat the q11 fifteen-orbit ledger, the one-plus-two seven-arc orbit
ledger, their determinant witnesses, and the failed-LP boundary as frozen
finite proof objects.  C726 alone owns manuscript/trust-surface integration and
standalone release refresh.
