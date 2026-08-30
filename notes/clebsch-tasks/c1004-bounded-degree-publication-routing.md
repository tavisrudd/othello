# C1004 — bounded-degree publication routing

**Lane**: `clebsch`

**Status:** Queued; C1001, C1007, and C1009 theorem packets frozen;
publication decision only.

## Goal

Assess C1001, C1007, and C1009 against Paper I, its computational companion,
the arcs paper, and banked low-degree curve material. Choose the smallest
honest publication package and split any cross-lane implementation work
explicitly. C1009's exact quadratic root should replace the coarse field
window in any eventual theorem statement; its parity-linear bound is the
readable low-degree corollary.

## Acceptance gate

- Audit Serre/Sziklai priority and the novelty of the combined consequence.
- Decide whether the general theorem belongs in an arcs-paper forward version and the six-arc tail in the Clebsch companion, or whether added sharpness/equality results justify a standalone note.
- Specify manuscript, evidence-map, formal-annotation, summary, mirror, and release deliverables.
- Decide the bounded ergodis adapter described below: private diagnostic,
  public example, or no implementation.  Do not broaden the public recovery
  optimizer merely to host a geometry demo.
- Do not edit manuscripts before the placement decision is accepted.

## Ergodis integration candidate

There is one mathematically exact adapter, but it is optional rather than
core.

For a full-rank \(3\times k\) parity-check matrix \(H\) whose projective
columns form a \(k\)-arc \(A\), the projective syndromes with prescribed-coset
cost greater than two are exactly the uncovered points \(U(A)\).  Ergodis
already computes prescribed-coset minimum-support costs, so an adapter could:

1. validate the rank-three MDS/arc condition from the \(3\times3\) minors;
2. quotient nonzero syndromes by scalar and retain those of cost at least
   three;
3. build the degree-\(d\) Veronese evaluation matrix on that locus;
4. return either a nonzero vanishing form or an exact full-column-rank
   certificate; and
5. short-circuit the computation when C1001/C1007's inequalities already
   prove that no degree-\(d\) form can vanish.

The adapter would certify a code/geometric dictionary, not a new recovery
algorithm.  Its natural first home is ergodis-private or a paper-local example.
Promotion to the public ergodis surface is justified only if it reuses the
generic prescribed-coset and finite-field APIs without adding
arc-paper-specific concepts to the core library.

Required certificate fields are: field model; normalized projective columns;
all arc-minor checks; the projective syndrome/cost census; Veronese monomial
order; rank or kernel witness; theorem-guard parameters
\((q,k,d,N,\beta_k)\); and exact replay of every claimed evaluation.
