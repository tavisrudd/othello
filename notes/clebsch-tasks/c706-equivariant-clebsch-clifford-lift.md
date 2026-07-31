# C706 — Equivariant Clebsch--Clifford phase lift

**Lane:** `clebsch`

**Status:** complete

## Objective

Determine whether the gauge-trivial Clebsch context cochain becomes
nontrivial when gauge transformations must respect the outer
\(S_6\cong\operatorname{Sp}_4(\mathbf F_2)\) action, its Clifford lift, or
the golden \(A_5\) stabilizer.

## Gates

1. Construct the induced symplectic action and explicit Clifford lifts.
2. Compute the projective multiplier and compare it with the signed outer
   action on the six Clebsch shadows.
3. Test equivariant, \(A_5\)-equivariant, and integral/golden gauges.
4. Identify the exact group-cohomology class or prove that every refinement
   remains trivial.
5. If positive, determine whether the class controls \(K\), the Joubert
   system, or only the conference marking.

## Boundary

Ordinary point-gauge contextuality is already negative in C705 and must not
be repackaged as a new cocycle.  The abstract Pauli-doily/Cremona--Richmond
dictionary and its realization by the fifteen Segre planes are also
pre-existing identifications.  Novelty requires a nontrivial equivariant
lift, not another incidence relabeling.  C705 now proves that the five
independent grid checks exhaust the entire ordinary gauge quotient, so any
positive invariant here must genuinely use equivariance.  Its isodual
\([10,5,4]\) quotient has an \(S_6\)-torsor of exactly \(720\) dualizing
coordinate maps; compare that torsor with the Clifford lifts rather than
choosing an arbitrary isoduality.

## Disposition

The full \(S_6\) Clifford extension modulo scalar phases is nonsplit, with
nonzero obstruction in \(H^2(S_6,\mathbf F_2^4)\).  Its golden \(A_5\)
restriction has \(64\) splittings in four Pauli-conjugacy classes, and the
conference rephasing selects a nonzero class in
\(H^1(A_5,\mathbf F_2^4)\).  The remaining scalar multiplier is trivial
after exact rephasing.  The class controls the conference marking and its
triangle coboundary \(K\), not Joubert or \(\mathbf Q(\sqrt5)\).
The full conference switching \(S_5\) still has \(32\) Clifford splittings
in two Pauli-conjugacy classes, but the distinguished conference
\(H^1(A_5,\mathbf F_2^4)\) class does not extend across the
orientation-reversing coset.  Thus the phase boundary is
\(A_5\subset S_5\), whereas the Clifford-extension obstruction occurs only
at \(S_5\subset S_6\).
The conference \(S_5\) has six conjugates with all fifteen pairwise
intersections isomorphic to \(S_4\).  The global nonsplit class restricts
trivially to every chart but their complements cannot glue.  This exact
six-chart pattern is handed to C708 for comparison with the six actual
Segre--Igusa polarities.

Full report and certificate:
`notes/2026-07-30-c706-equivariant-clifford-lift.md`.
