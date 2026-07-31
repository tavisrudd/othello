# C722 — q9 and q13 clique equality-case structure

**Lane:** `clebsch`

**Opened:** 2026-07-31

**Status:** queued after C721; C714 phase 2/6.

## Objective

Test two sharply bounded replacements for clique certificates used by the
cross-field q9 exclusion and the q13 weight-eight exclusion.

## Work

1. For the distance-two graph of the Sylvester graph, reproduce the easy
   spectral upper bound six and characterize equality in the relevant
   ratio/inertia bound.
2. Use the Sylvester intersection array, extremal eigenspace, equitable
   partition constraints, or two-graph parity to rule out equality and obtain
   clique number five without a clique census.
3. Express the q13 local tangent graph as the recorded three-by-three
   block-circulant graph over Z/14, using C721's relation dictionary.
4. Fourier-diagonalize all character blocks exactly and test ratio, inertia,
   Delsarte, and equality-case refinements for the sharp upper bound five.
5. Preserve explicit five-clique witnesses in both settings.

## Acceptance

Each branch is judged independently. A promoted branch must prove the exact
upper bound five and expose its equality obstruction. All arithmetic must be
exact and replayable.

## Stop boundary and handoff

For any method that yields only six, record its exact spectrum, dual bound,
and failed equality condition, then stop that branch and retain the existing
published or finite certificate. Pass all exact tangent/Fourier identities to
C723 even if the q13 bound remains finite.

