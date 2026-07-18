# C84: pairing cannot supply uniform S₄-rooted escape

**Date:** 2026-07-17
**Lane:** `cap`
**Status:** bounded negative; the pairing branch of the existence attack is closed.

## Result

For each prime (q\in\{7,11,13,17,19,23,29,31\}), each of the four generating-triple classes

\[
A=(3,3,3),\quad B=(3,4,4),\quad C=(2,3,3),\quad D=(2,3,4),
\]

was represented inside an exact (S_4\le PGL_2(q)). Every legal fourth centre outside that
(S_4) was enumerated, its fixed-point-deleted Schreier graph was built, and two pairing questions
were decided:

1. does the residual have a fixed-point-free nonadjacent involutory automorphism induced by an
   element of (PGL_2(q))?
2. does it have any such graph automorphism, whether geometric or accidental?

The answer to both questions is **no for every one of the 753 class-D escapes at (q=29)**.
Consequently a pairing or mirror argument cannot be the uniform S₄-rooted existence mechanism.
Class D at (q=29) needs an adaptive/non-pairing P certificate, a different structural mechanism,
or an explicit exceptional treatment. This strengthens C84's earlier density obstruction: pairing
does not merely have density zero; on a genuine tested full-group escape fiber it supplies no child
at all.

This is a bounded negative. It does not say that the 753 residuals are N, and it does not rule out
a non-pairing value-preserving quotient.

## Exact census

Each entry is `geometric/abstract`, with classes ordered A, B, C, D. “Geometric” means the pairing
is induced by a conic projectivity; “abstract” allows every graph automorphism.

| q | legal escapes A/B/C/D | pairing children A/B/C/D |
|---:|---|---|
| 7 | 31 / 29 / 30 / 27 | 10/10, 6/6, 2/2, 3/3 |
| 11 | 85 / 87 / 86 / 87 | 9/9, 0/0, 1/1, 0/1 |
| 13 | 133 / 135 / 134 / 131 | 6/6, 8/8, 16/20, 3/3 |
| 17 | 235 / 241 / 238 / 239 | 9/9, 2/2, 6/6, 3/4 |
| 19 | 307 / 305 / 306 / 305 | 28/28, 2/2, 5/5, 2/2 |
| 23 | 457 / 459 / 458 / 457 | 25/25, 9/9, 12/12, 4/4 |
| 29 | 751 / 757 / 754 / 753 | 3/3, 15/15, 12/12, **0/0** |
| 31 | 871 / 869 / 870 / 867 | 48/48, 18/18, 14/14, 4/4 |

Every geometric pairing child in the table generates a subgroup of order greater than 60. Since it
contains the rooted (S_4), Dickson's prime-field subgroup classification excludes every proper
small overgroup (the only remaining polyhedral overgroup is (A_5), of order 60). Thus these are
genuine growing (PSL_2/PGL_2) residuals, not hidden catalogue rows.

The data also sharpen the old “pairing is a minority” statement. The counts fluctuate strongly by
class and field, and even when nonzero they remain tiny compared with the (Theta(q^2)) escape
supply. No positive-density inference is made.

## Checker and trusted boundary

The checker is `rust/scripts/c84_pairing_locus.py`. It uses only Python's standard library and the
independent coordinate implementation in `rust/scripts/three_centre_probe.py`.

For the geometric test it enumerates every off-conic involution, restricts it to the live conic,
and checks fixed-point-freeness, nonadjacency, and the full adjacency-preservation equation. For the
abstract test it performs exact pair-by-pair backtracking after stable degree/neighbour-colour
refinement; a completed assignment is checked through the same adjacency equations. There is no
automorphism cap or early “no” exit.

The (S_4) representative search uses deterministic pseudorandom sampling with seed
`20260717 + q`, followed by exhaustive lexicographic fallback. Counts are conjugacy-invariant, so
the representative choice does not affect a class row. The compact JSON records the exact counts.

Independent cross-check: the pre-existing NetworkX automorphism enumerator reported 11 total
pairing children at (q=11) and 37 at (q=13). The new dependency-free backtracker reproduces
exactly (9+0+1+1=11) and (6+8+20+3=37), respectively.

From `/home/tavis/src/othello` run:

```sh
python3 rust/scripts/c84_pairing_locus.py \
  --summary --counts-only --abstract-class ALL --report-summary --check \
  7 11 13 17 19 23 29 31
sha256sum -c notes/2026-07-17-c84-pairing-obstruction.sha256
```

The trusted mathematical boundary is the standard mirror-strategy lemma and Dickson's subgroup
classification. The finite checker certifies only the displayed fields/classes. It does not
compute Grundy values for non-pairing children and does not promote the (q=29) obstruction to an
infinite family.

## Consequence for C84

Remove “find one pairing-certified child in every S₄ class” from the near-term existence plan.
The surviving routes are:

1. an adaptive P certificate for the class-D (q=29) type and its analogues;
2. a genuinely non-pairing bounded core or quotient; or
3. the original Grundy-arithmetic/abundance mechanism.

The next computationally disciplined probe should start from class D, compare the first-ply
winning-response DAG against the other three classes, and ask for a bounded adaptive certificate.
Further static invariant or mirror mining is not justified by this result.
