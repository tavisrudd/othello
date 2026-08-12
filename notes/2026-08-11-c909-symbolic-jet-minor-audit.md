# C909 — symbolic nested minors for the filtered web gate

Date: 2026-08-11

Status: bounded symbolic audit; no manuscript, PDF, mirror, or Lean change

## Verdict

The nested-minor route proves the squarefree six-slot Smith profile and
substantially supports the eight-slot profile, but it also isolates the first
non-Vandermonde pivot factor.  It does not close the all-rank theorem.

For semilength three, a fixed matching-column basis has minimum determinant
valuations

```text
0, 1, 2, 3, 5
```

in ranks one through five.  Explicit witnessing minors factor as the required
power of the graph parameter times products of root differences.  Therefore
every non-graph factor is a unit whenever the six residual roots are pairwise
distinct.  This gives a structural unit-minor proof of the squarefree
six-slot elementary divisors

```text
0, 1, 1, 1, 2.
```

For semilength four, the analogous nested minors have the expected graph
valuations through rank six.  Most factor entirely into root differences.
At rank three one witnessing minor has, in addition, a larger polynomial
factor not visibly a product of pairwise differences.  Exhaustive tests over
`F_8` and `F_11` show it is a unit on every distinct-root tuple in those
domains, but pairwise distinctness alone has not yet been proved to force
that unit universally.

Consequently the semilength-three Dyck row is now structurally proved on the
squarefree block, while semilength four and the all-rank Dyck-height formula
remain conditional on an interpretation of the extra factor—ideally as a
Pluecker/LGV determinant with a unique nonintersecting family, or as a
Wronski/Specht discriminant whose zero locus is contained in the ordinary
root-collision divisor.

## Exact boundary

The result does not address repeated-support multidegrees.  Their integral
factorization through volume forms is a separate primitive-direct-summand
lemma.  Nor does this audit substitute finite enumeration for the desired
arbitrary-root proof: it records exactly where the determinant ceases to be
manifestly Vandermonde.

## Mystery ledger

* **Settled:** the squarefree codimension-three profile is not merely
  numerical; explicit unit Vandermonde minors realize its complete Smith
  vector.
* **Open:** identify the extra semilength-four rank-three factor and determine
  whether its vanishing divisor has components away from root collisions.
* **Open:** construct nested minors uniformly in semilength and connect their
  ranks to exact Dyck height.
