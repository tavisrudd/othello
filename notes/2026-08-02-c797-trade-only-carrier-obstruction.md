# C797 — trade-only carrier obstruction

**Lane:** `clebsch`

**Date:** 2026-08-02

## Verdict

The carrier-free level-up is false, sharply and for a structural reason.  In
the \(q=7\) affine conic-quotient module there are seven distinct
\(14\)-point \(\operatorname{PGL}_2(7)\)-orbits whose strength-two trade
space is a line with value profile \(7+7\) and values \(\{1,-1\}\).  Only
one of the seven orbits lies in the perfect-matching image.

Thus the two-valued quadratic trade recovers the abstract two-sheet
\(G/S_4\) permutation module but not its embedding as a matching
configuration.  Paper II's current matching-orbit theorem is the sharp safe
statement; its perfect-matching carrier cannot simply be deleted.

The obstruction already occurs in the target field of \(B_3\).  Complete
affine-module censuses at \(q=3\) and \(q=5\) contain no unique two-valued
trade orbit, so \(q=7\) is the first failure in the checked odd-prime range.

## Exact obstruction

Write \(A=\epsilon^{-1}(1)\) for the affine hyperplane in Paper II's
extension
\[
0\longrightarrow F\longrightarrow E
 \mathrel{\mathop{\longrightarrow}^{\epsilon}}\mathbf F_q
\longrightarrow0.
\]
The matching quotient embeds every perfect matching as a point of \(A\), and
the full projective group acts affinely on \(A\).

At \(q=7\), choose a point in the \(B_3\) matching orbit and let
\(K\cong S_4\) be its stabilizer.  Exact affine interpolation and exhaustive
verification give
\[
|A^K|=7.
\]
Hence \(A^K\) is an affine line over \(\mathbf F_7\).  Its seven points lie
in seven distinct full-group orbits, each of size \(14\).  Every one of those
orbits has affine Schur-square rank \(13\), so every one has the same unique
two-valued quadratic-trade profile.  The complete matching image meets
\(A^K\) in exactly one point.

This is the lost degree of freedom: the trade identifies the homogeneous
space \(G/K\), while the affine line \(A^K\) parametrizes seven inequivalent
equivariant placements of that homogeneous space in the quotient carrier.
One placement is the matching geometry and six are not.

The seven affine ranks are
\[
6,7,7,7,7,7,7.
\]
Thus full affine span removes only one false placement and leaves five false
placements beside the true one.

## Cubic boundary and nearest repair

The hyperplane-square lemma behaves exactly as expected: all seven orbits
have a nonzero sheet-sign cubic.  In the fixed coordinate model their seven
projective cubic tensors are distinct.  This does not by itself recover the
matching point.  Among the six full-affine-rank placements, all six cubics
have exactly nine singular \(\mathbf F_7\)-projective points; the matching
cubic is not separated by this first coarse cubic invariant.  The remaining
rank-six placement has \(57\) singular projective points.

The nearest exact positive condition is algebraic factorization rather than
an assumed incidence labelling.  Fix a reference matching product \(P_0\).
An affine point \(x\in A\) has lift
\[
P_x=P_0+Qx.
\]
Every such lift restricts to the same squarefree binary form on the conic.  If
\(P_x\) is a product of secant linear forms, those secants partition the
marked conic points into pairs, because the restriction contains every marked
linear factor exactly once.  Hence complete reducibility of one lift
reconstructs a perfect matching, and equivariance reconstructs its whole
matching orbit.  In the exact \(q=7\) fixed line, the completely reducible
matching locus is the single matching-image point.

This repair replaces a combinatorial matching label by membership in the
secant-product Chow locus, but it does not derive factorization from the trade
alone.  No manuscript strengthening is warranted from C797.

## Reproducibility

From the repository root, replay

```sh
python3 notes/2026-08-02-c797-affine-orbit-falsifier.py --check
```

The deterministic certificate exhausts all \(3^1=3\), \(5^3=125\), and
\(7^6=117{,}649\) affine-module points.  It partitions them into respectively
\(1\), \(5\), and \(519\) full projective orbits and computes, for every
orbit, affine rank, Schur-square rank, trade dimension, and value profile.
For each unique trade it also computes the projective signed cubic and its
projective singular-point count.

The affine action is reconstructed twice from independently selected affine
bases and required to agree.  It is then checked on every perfect matching.
Further invariant checks require the three generators to generate the full
group, orbit masses to exhaust the affine universe, the selected matching
stabilizer to have order \(24\), its fixed locus to have seven points, and
those points to generate seven distinct size-\(14\) orbits.  These checks are
the independent replay/invariant layer; no second software implementation is
claimed.

The trusted boundary is Python integer arithmetic modulo the three prime
fields, canonical perfect-matching generation, the repository's independently
used conic-quotient division routine, exact row reduction, and exhaustive
finite iteration.  The certificate proves only the displayed finite-field
claims.  It does not classify affine-module orbits for \(q>7\) or prove a
uniform fixed-locus theorem.

Artifact hashes and byte counts:

| artifact | bytes | SHA-256 |
|---|---:|---|
| `notes/2026-08-02-c797-affine-orbit-falsifier.py` | 14214 | `9a95f06dc01e829ede7eb415e81c66912345e381edba81d67e41751813c590dc` |
| `notes/2026-08-02-c797-affine-orbit-falsifier.json` | 12447 | `7df9b9afaaa58b9e3355b38c7bbaf8a36c94d228c9673dccb41d7b2e7523b43f` |

The adjacent `.sha256` file records the same hashes.  This report adds no new
literature characterization; the full-text predecessor audit and its coverage
limits remain in `notes/2026-08-02-c577-paper-ii-priority-extraction.md` and
the cross-paper scout.

## `ej` + `tt` closeout

The cheap extra test asked whether the cubic repairs what the quadratic trade
forgets.  It does not at the first invariant level: the six full-rank
placements have the same nine-point singular count even though their
projective cubic tensors are distinct.  The cubic therefore records the
embedding parameter but does not canonically identify the matching value.

The structural question exposed by the failure is more precise than the
original conjecture: describe the intersection of the stabilizer-fixed affine
line \(A^K\) with the secant-product Chow locus, and determine which covariant
cuts that intersection scheme-theoretically.  At \(q=7\) the intersection has
one rational point.  Promoting an all-field intersection theorem would require
a new C-ID and a novelty gate; it is not needed by Paper II and is not
allocated here.

## Mystery ledger

| feature | status | exact evidence gap or owner |
|---|---|---|
| carrier-free trade-only classification | settled negatively | seven exact \(q=7\) orbits share the trade; only one is a matching orbit |
| forgotten degree of freedom | settled at \(q=7\) | the \(S_4\)-fixed locus is an affine line of seven points |
| full affine rank as repair | settled negatively | six placements have full rank, only one of them is the matching placement |
| sheet-sign cubic as repair | settled negatively at coarse level | all seven cubics are distinct, but all six full-rank cases have nine projective singular points |
| exact positive repair | settled locally | complete reducibility of one lift reconstructs the matching; the fixed line meets the matching image once |
| uniform fixed-line/Chow intersection theorem | open but unallocated | requires an all-field covariant and a separate novelty audit; it does not block Paper II |

Vibe check: the ambitious level-up dies immediately, but it dies cleanly and
reveals exactly what the trade remembers and forgets.  That makes the current
Paper II theorem look sharper rather than weaker: the matching carrier is a
genuine geometric hypothesis, not removable scaffolding.
