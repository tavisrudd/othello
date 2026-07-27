# C676 pointed Tutte specialization and filtration boundary

**Lane:** `complete-ports`

**Status:** PARTIAL CHECKPOINT — complete human proofs, the represented filtration witness, and the
matching Lean source elaborate cleanly; the aggregate gate and axiom audit await the shared build
owner.

## Result

Let \(M\) be a matroid on \(V\sqcup\{x\}\), with \(x\) neither a loop nor a coloop, and put
\[
\epsilon_x(A)=r_M(A\cup\{x\})-r_M(A).
\]
For \(D=M\backslash x\) and \(Q=M/x\), the rank identities
\[
r_D(A)=r_M(A),\qquad r_Q(A)=r_M(A\cup\{x\})-1
\]
turn the rank-one Las Vergnas perspective expansion term by term into
\[
T_{D\to Q}(X,Y,Z)=
\sum_{A\subseteq V}
(X-1)^{r(M)-r_M(A\cup\{x\})}
(Y-1)^{|A|-r_M(A)}Z^{\epsilon_x(A)}.
\]
The \(Z^0\) terms are precisely the successful helper sets.  Their cardinality enumerator is the
evaluated derivative difference of the deletion and contraction rank polynomials, and its
Bernstein transform is full repair reliability.  The manuscript now proves all three statements
term by term.

The dual rank formula gives
\[
\epsilon_x^{M^*}(F)=1-\epsilon_x^M(V\setminus F).
\]
Complementation therefore exchanges dual repair with primal failure and proves
\[
R_{(M,x)}(s)+R_{(M^*,x)}(1-s)=1.
\]
Minimal failure blockers are the cocircuits through \(x\), with \(x\) removed; in a represented
matroid these are the inclusion-minimal row-code supports through \(x\).  This proves
\(\tau_{\rm full}(x)=d_x(C)-1\).

## Symbolic represented filtration boundary

The governing mechanism is sparse paving.  For rank \(r\), the pointed subset profile of a sparse
paving matroid depends only on the ground-set size, \(r\), the number of circuit-hyperplanes through
the target, and the number avoiding it.  It does not record the intersection pattern of the
target-containing circuit-hyperplanes after the target is removed.  Radius-\((r-1)\) reliability
does record that pattern through inclusion--exclusion.  Thus the forgotten datum is circuit
intersection geometry, not the individual circuit sizes or an unspecified notion of radius.

The manuscript now gives two explicit \(4\times7\) matrices over \(\mathbb F_7\), with column zero
distinguished.  Both represented matroids have rank four, no dependent triple, and exactly three
circuit-hyperplanes: two through the target and one avoiding it.  Hence their complete pointed
subset profiles, and therefore their pointed Tutte polynomials, agree:
\[
\begin{aligned}
T(X,Y,Z)={}&(X-1)^3Z+6(X-1)^2Z+15(X-1)Z+2(X-1)\\
&+18Z+(Y-1)Z+14+6(Y-1)+(Y-1)^2.
\end{aligned}
\]
Their complete successful-set enumerators are both
\[
2u^3+14u^4+6u^5+u^6.
\]

The first radius-three port consists of two disjoint triples; the second consists of two triples
meeting in one helper.  Inclusion--exclusion gives
\[
R_{\rm dis}^{(\le3)}(s)=2s^3-s^6,\qquad
R_{\rm ov}^{(\le3)}(s)=2s^3-s^5.
\]
Thus the complete pointed polynomial does not determine the radius filtration, already among
rank-four systems represented over \(\mathbb F_7\).  This replaces the field-nine coefficient
comparison as the proof of the boundary.  The field-nine result is now illustration only.

## Human proof and exact replay

The manuscript prints all 35 four-column determinants of both matrices in lexicographic order.
The three zero minors in each row are exactly the asserted circuit-hyperplanes.  Every triple
extends to a nonzero displayed minor, and every set of at least five columns contains one, so the
minor table determines every subset rank.  The pointed-polynomial count and the radius-three
inclusion--exclusion are then symbolic.

The independent exact replay is:

```text
cd /home/tavis/src/othello
python3 notes/2026-07-26-c676-pointed-tutte-filtration.py \
  --check notes/2026-07-26-c676-pointed-tutte-filtration.json
```

It performs Gaussian elimination modulo seven, enumerates the dependent triples and four-subsets,
reconstructs the complete pointed exponent profile, and independently reconstructs the
radius-three successful-set counts.  It checks the exact profiles
\[
(0,0,0,2,6,6,1)\quad\hbox{and}\quad(0,0,0,2,6,5,1).
\]
The script does not prove that the displayed objects are the smallest possible witnesses and makes
no search-completeness claim.

| Artifact | Bytes | SHA-256 |
|---|---:|---|
| `notes/2026-07-26-c676-pointed-tutte-filtration.py` | 5910 | `5c4a53ab848f9d7ff325accf48d4639bb736c7a26a537a5369c0883dc23efd69` |
| `notes/2026-07-26-c676-pointed-tutte-filtration.json` | 3736 | `8096230e66f634c820ae7ec4bacd9b2493006782ff02b8be3a8c7e1caf80de07` |

## Formal correspondence and held gate

`RepairPorts.PointedTutte` now supplies:

- `elementaryPerspectiveSubsetEvaluation_eq_pointedTutte`;
- `deletionContractionRankDifference_eq_successfulSetEnumerator`;
- `portReliability_pair_homogeneous`;
- `disjointTripleRepairs_reliability`;
- `overlappingTripleRepairs_reliability`; and
- `disjointTripleRepairs_reliability_ne_overlapping`.

The source passed `lean/scripts/guarded-lean RepairPorts/PointedTutte.lean` without warnings.  The
first two declarations match the finite-rank perspective and derivative derivations.  The last four
formalize the circuit-overlap mechanism and the exact two symbolic curves.  The displayed
\(\mathbb F_7\) matrices are connected to the abstract sparse-paving count by the complete human
minor table and independently replayed exact arithmetic; matrix rank itself is not a Lean
dependency.

The aggregate `RepairPorts.Gates.CompletePorts` run has not started because a foreign lane owns the
shared build lock.  The paper ledgers therefore keep both statements outside the admitted body
proof spine until that gate, its printed axiom audit, and the trust-spine audit pass.
