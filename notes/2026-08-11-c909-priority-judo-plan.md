# C909 — priority judo after the tropical PSD boundary

Date: 2026-08-11  
Status: structural positioning plan; no manuscript, PDF, mirror, Lean, or
claim-ledger edit

## The judo move

Yu's theorem should become the associated-graded theorem, not an obstacle to
the project.  The central statement is:

> **Integral lifting of the tropical PSD cone.**  A symmetric valuation matrix
> lies in Yu's tropical PSD cone if and only if the associated symmetric DVR
> matrix-of-ideals lattice is generated integrally by the rank-one matrices it
> contains.

Outside the cone, the exact rank-one hull is obtained by tropical projection
onto the cone:

\[
 e_{ij}\longmapsto
 \max\left(e_{ij},\left\lceil\frac{a_i+a_j}{2}\right\rceil\right),
\]

and the defect is the direct sum of the resulting DVR intervals.  At two, the
same failed inequalities give explicit order-two divided-square witnesses.

This is not a rival formulation of Yu.  It is an arithmetic lifting and exact
defect theorem whose associated tropical cone is Yu's.  The graph
Neron--Severi theorem then says that every finite-etale graph packet lands
inside this cone at every primary depth, so its complete integral
divided-power envelope is ordinarily divisor-generated.

## Why this is the strongest safe priority position

1. It credits the exact predecessor rather than competing with it.
2. It explains why the midpoint inequalities appear.
3. It isolates the genuinely arithmetic content: integral rank-one lifting,
   cokernel, dyadic obstruction, and faithful-flat descent.
4. It turns the abelian-variety application into a natural functor from
   filtered etale spectral packets to tropical PSD lattices.
5. It compresses the proof: Yu supplies the geometry of the cone; one signed
   square identity supplies its integral lift.

## Ranked judo routes

### A. Integral lifting plus graph application — GO, highest readiness

Package three layers:

1. Yu's tropical PSD cone;
2. the integral DVR lifting/defect theorem;
3. the finite-etale graph Neron--Severi and divided-power corollary.

This is the best epilogue-compatible theorem.  In the epilogue, print only the
lifting statement and graph corollary; move the exact cokernel and converse to
a proposition or successor paper if page pressure matters.

### B. Rees-lattice formulation — GO as language, not yet extra mathematics

View `L(a,e)` as a filtered symmetric lattice and its valuation matrix as the
associated tropical quadratic form.  Rank-one generation says the Rees
lattice is generated in Veronese degree one.  The defect intervals are the
torsion of the failure of that generation.

This is likely the cleanest invariant formulation, but it is not by itself a
new theorem beyond A.  Use it only if it shortens definitions.

### C. Global Dedekind/Picard refinement — high ceiling, not free

Over a DVR every coefficient ideal is principal.  Over a Dedekind base, local
tropical PSD inequalities remain necessary, but global rank-one lifting may
carry class-group or square-root obstructions.  Classifying that obstruction
could turn A into a genuine arithmetic-global theorem.  It is not needed by
the complex epilogue and should be a successor, not scope creep.

### D. Effective/semigroup normality — quarantine

C909 proves an integral **signed span**, not generation by effective positive
rank-one forms.  Yu's tropical convex hull does not supply effective divisor
decompositions over the DVR.  A normality or positivity theorem would be much
stronger but is presently unsupported and irrelevant to Voisin's
cohomological criterion.

### E. Odd-prime converse — open and potentially valuable

At two, failure of tropical PSD is detected by a divided square because the
cross-by-cross product carries a factor two.  At odd primes degree two is
silent.  Determining the first divided power detecting a failed inequality
would make the integral lifting theorem a full prime-uniform defect theory.
This is the best pure-math successor after A, but not required for the
finite-etale positive theorem.

## Manuscript recommendation

The epilogue should not advertise “a new tropical PSD theorem.”  It should say
that the local cycle argument is an integral lift of Yu's tropical PSD
rank-one cone and state the all-degree graph corollary.  This replaces the
present cofactor theorem rather than adding a parallel theorem stack.

The nonsplit trace-transfer families and orbit classification belong in a
successor paper or a short examples subsection only if they demonstrate that
the theorem reaches factorial-active polarized-indecomposable ppavs.  They are
not needed in the abstract.

## Mystery ledger

* **Settled:** exact priority boundary and strongest judo formulation.
* **Settled:** the tropical predecessor compresses rather than weakens the
  arithmetic-geometric theorem.
* **Open:** odd-prime defect degree/order.
* **Open:** Dedekind/class-group globalization.
* **Quarantined:** effectivity and semigroup normality.
