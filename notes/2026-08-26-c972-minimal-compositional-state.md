# C972: Minimal compositional state and rank-one complete transfer

**Lane**: `complete-ports`

## Goal

Determine exactly how much labelled prescribed-coset information arbitrary
finite concatenation can observe.  Strengthen the paper only after the
converse, rank-one consequences, and finite separation have independently
survived mathematical and computational checks.

## Work order

1. **Lock the observational notion.**  Define compatibility of represented
   inner and outer codes, the natural relabellings that preserve min--sum
   composition, and contextual equivalence under all compatible outer codes.
   Separate numerical cost state from stored minimizing lifts and witnesses.
2. **Prove or delimit the converse.**  Start at rank one.  Given a differing
   labelled cost, try to construct a probe outer functional dual that exposes
   that label while suppressing competing zero and nonzero sectors.  Record
   the exact field, realizability, nondegeneracy, and target-surjectivity
   hypotheses.  Extend to general target subspaces only if the probe argument
   survives.  A counterexample to the proposed universality statement is a
   first-class result, not permission to weaken definitions silently.
3. **Close the rank-one package.**  Prove the strongest correct equivalence
   between rank-one confinement through radius `r` and simultaneous
   confinement at every recoverable rank.  Audit separately which downstream
   objects follow from the resulting restriction/zero-extension bijection:
   coefficient-labelled equations, exact helper supports, all minimum-union
   costs, bounded reliability, and support-determined service/scheduling
   regions.  State additional hypotheses where required.
4. **Search for the sharp fixed-outer separation.**  Seek two inner
   presentations with isomorphic `(K_P,D_P)`, identical complete RGHWs and
   dual distance, identical unlabelled bounded helper-support families where
   feasible, and identical scalar costs for every relevant target subspace,
   but unequal `Gamma` for one fixed represented outer code.  Use exhaustive
   small-field search with replayable witnesses, then replace search evidence
   by a transparent hand-checkable example.
5. **Synthesize only validated results.**  Decide whether the correct headline
   is universality, a restricted probe theorem, or a sharp obstruction to
   universality.  Prepare theorem statements, proof dependencies, the finite
   example, and editorial placement as a manuscript proposal; do not mutate
   the public paper or mirrors during the investigation.

## Acceptance gates

- The observational equivalence and allowed natural relabellings are explicit.
- Every claimed probe outer code is a realizable represented code, not merely
  an arbitrary min--plus test functional.
- Rank-one consequences are derived from exact support-system transfer rather
  than from equality of scalar minima alone.
- Any finite separation has an independent exhaustive replay and a compact
  human verification.
- The report cleanly separates proved theorems, conditional statements,
  counterexamples, and manuscript-only editorial recommendations.

## Main risk

The full minimality claim may be false because distinct labelled tables can be
indistinguishable to every realizable compatible outer functional dual.  The
correct universal object may therefore be a quotient by contextual min--sum
observability rather than the raw labelled table.  Establishing that quotient
is part of the task, not a fallback wording change.
