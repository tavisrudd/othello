# C709 — Clebsch conference signs in the six-Majorana \(K_6\) model

**Lane:** `clebsch`

**Status:** complete

## Objective

Transport the duad model to six Majorana modes, where the fifteen bilinears
are the edges of \(K_6\), and determine whether the Clebsch conference signs
define a nontrivial quadratic refinement, spin structure, or oriented
free-fermion Hamiltonian.

## Gates

1. Fix the Pauli--Majorana dictionary and all phase conventions.
2. Identify which data of \(C\), its triangle two-graph, and
   \(K=*\Lambda^3C\) survive vertex and edge gauge.
3. Compute spectra, Pfaffians, and symmetry of the induced skew Hamiltonians.
4. Test compatibility with the golden eigenspaces and the Segre/Joubert
   determinants.
5. Record gauge-triviality as a structural negative if no spin refinement
   survives.

## Disposition

The conference signing survives diagonal Majorana gauge as nontrivial
\(\mathbf Z/2\) cycle flux, but is none of the sixteen quadratic refinements
of the two-qubit symplectic space and supplies no spin structure without an
additional surface embedding.  A total-order skewing of \(C\) is
noncanonical and has three spectral classes across the \(720\) orders.

The positive replacement is the canonical chiral family
\[
 A_C(x)=[D_x,C].
\]
It anticommutes with \(C\), exchanges the two golden three-spaces, and
satisfies
\[
 \operatorname{Pf}A_C(x)=4Z_C(x),\qquad
 \det A_C(x)=16Z_C(x)^2.
\]
Thus the Joubert cubic is the exact zero-mode and fermion-parity wall of a
six-Majorana free-fermion family.  Full report and exact certificate:
`notes/2026-07-30-c709-majorana-k6-lift.md`.
