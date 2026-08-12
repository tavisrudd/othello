# C907 — Quantum-monodromy stabilization test

**Lane:** `clebsch`

**Status:** one-step irrationality theorem closed and imported, by author
instruction, into the C904 geometric epilogue; full stable irrationality
remains active research.  No Paper V or Lean promotion.

**AA checkpoint:** the low-dimensional-carrier branch is positive.  KKPYY
Claim 6.15 forces every nef-canonical surface block to have fractional
exponents only `0` or `1/2`; ruled/rational surfaces reduce through
projective bundles and point blow-ups to curves and points with the same
restriction.  Since fourfold weak-factorization centers have dimension at
most two, the cubic `+/-1/6` block proves that `X x P^1` is irrational for
every smooth cubic threefold.  Full stable irrationality remains open from
`m=2`, where cubic self-carrier centers enter.  A source-level audit also
demotes the prime-power spectral-cycle idea: KKPYY's decomposition is local on
analytic germs and does not retain the global loop, while iterated rank-`p`
projective bundles give dimension-admissible local-copy/wreath counterpatterns.
The recursive gate has a sharp conditional numerical form: Serre dimension
`m+5/3` exceeds the center bound `m+1`, but the ordinary projective-bundle
decomposition splits this into `m+1` distributable copies.  Exploiting the gap
requires both a gluing-sensitive enhanced atom and a restricted fractional-CY
carrier theorem; general Serre-dimension monotonicity is false.  These are the
remaining live gates together with the integer/Tate-filtered atom.  The latter
now has a basis-independent exact form: the endpoint Beilinson Euler lattice
has one unipotent Serre block of length `m+1`, while every projective
self-carrier has length `m-1`.  A Γ-integral, Stokes-filtered blow-up theorem
with a strict cubic-isotypic filtration and the additive associated-graded
blow-up formula would turn this uniform gap two into the full stable
obstruction.  Serre-block preservation alone is insufficient because
semiorthogonal extensions can join blocks.  Iritani Theorem 1.1 preserves the formal connection
and Poincaré pairing, but Remark 1.5 explicitly places the non-orthogonal
Stokes/Γ gluing beyond that formal direct sum; the missing theorem is therefore
confirmed at source rather than inferred from the computation.  A sharper
source-level calculation is positive locally: Iritani (5.19), (5.27) give
consecutive `q`-adic elementary divisors for the exceptional Fourier block,
affinely normalized to `0,...,r-2`, and cyclic root monodromy preserves their
multiset.  The live gate is therefore presentation-independent strict
composition of these relative Rees lattices through weak factorization, plus
the analytic Stokes gluing—not recovery of the local Tate width itself.  The
first composition audit is positive: the Tate polynomials agree identically
under transverse and nested two-step blow-up order exchanges.  A `P^1`
mutation audit proves that unchanged Euler/Serre data still allow different
exceptional flags, while the canonical monodromy-weight line is neither flag.
The full reduced ambient cubic quantum module now has an irregular-Hodge
origin: it is the irreducible hypergeometric module
`H(0,0,0,0;1/3,2/3)`.  Its local formal ranks are `1,1,2`, so irreducibility
rules out the old target of globalizing Cai's rank-two block as a proper
IrrMHM subobject.  The local sectorial atom is now exact: at every admissible
phase the unique Stokes lift has ordered ranks `1,2,1`, with the
zero-exponential rank-two atom in the middle and fixed by root monodromy;
`pi/2` is the certified representative.  Iritani's toric
weak-Fano theorem likewise proves that a sectorial blow-up decomposition can
exist and match the Orlov `K`-group decomposition, but explicitly leaves the
residual sectors' Stokes identification with the center quantum modules open.
Hinault--Yu--Zhang--Zhang prove only formal/non-archimedean uniqueness, while
Wang treats compactifications of one fixed Landau--Ginzburg pair.  The
corrected highest-EV gate is therefore the residual-center mutation-system
identification, strict for the irregular Hodge filtration and composable
through weak factorization.

The `T1/T2/T3` scoping pass now gives a calibrated split.  `T1` passes at the
formal basepoint: Iritani (5.28) becomes `(F tensor I_Z) direct_sum I_X` after
the `t`-adic and exceptional-first dominance associated gradeds, including the
fivefold point- and curve-center pilots.  It does not remove the analytic wall:
the Gamma lattice is a lattice in flat sections and its exponential splitting
is sectorial and phase-dependent.  `T2` is false for plain `C[[t]]`-modules,
which split into rank-one summands and forget block length; retaining the
unipotent Serre operator repairs the local ledger because
`C[[t]][N]/(N^ell)` is local.  `T3` remains the deep arbitrary-center theorem.
The proposed Fano-database proof of the `m=2` silver target is invalid as an
exhaustion: smooth quintic and sextic threefolds in `P^4` inside `P^5` are
legitimate Calabi--Yau and general-type codimension-two centers.  Database work
is reconnaissance only.  The next high-EV pass is to prove or refute the
`+/-1/6` length bound for Calabi--Yau and general-type threefold carriers while
keeping the analytic Gamma/Stokes lift as a separate `T1` gate.

## Goal

Test whether Cai's formal-monodromy obstruction for cubic threefolds can be
made stable under products with projective spaces and therefore developed into
a stable-irrationality obstruction.  The computational work is classical and
exact; "quantum" refers to quantum cohomology.

## Scope

1. Reconstruct the cubic-threefold small quantum connection from the published
   formulas and certify its rank-two formal block and exponents
   `+1/6, -1/6` modulo integers.
2. Derive and certify the product connection for `X x P^m`, first for bounded
   `m` and then symbolically where the tensor/product formula permits it.
3. Encode the projective-bundle and blow-up decompositions used by the
   Hodge/quantum-atom formalism and search exact bounded instances for
   cancellation or reproduction of the cubic atom by admissible centers.
4. State the strongest surviving general cancellation lemma, or exhibit the
   first exact counterpattern.  A bounded search is evidence only on its stated
   range and is never promoted to a universal theorem.

## Evidence bundle

The first durable bundle will use the common stem
`notes/2026-08-10-c907-quantum-monodromy-stabilization` and contain:

- a dated mathematical report;
- an exact Sage generator/checker;
- a compact canonical JSON certificate;
- checksums and byte counts;
- an independent symbolic replay when feasible.

Every claim backed by computation must record its replay command, exact input
formulas and conventions, dependency versions, trusted boundary, and negative
search stop condition under `notes/research-reproducibility-conventions.md`.

## Acceptance gates

- The `+/-1/6` certificate is reproduced exactly from source formulas, not
  copied as an asserted input.
- Stabilization is checked in at least two independent ways on a nontrivial
  bounded range and reduced to an explicit general formula if possible.
- Blow-up-center cancellation tests distinguish formal identities from
  geometric realizability and state all dimension bounds.
- The closeout gives a precise verdict: stable obstruction proved, a named
  missing theorem isolated, or the proposed invariant refuted by a certified
  counterpattern.
- Run the required `ej` and `tt` closeout and maintain a Mystery ledger before
  completing the task.

## Boundaries

- Do not edit the frozen Paper V manuscript.  The geometric epilogue may use
  the closed one-step theorem, but not the open higher-stabilization program.
- Do not claim stable irrationality from finite computation.
- Do not start Lean work without a separately authorized formalization task.
- Literature and formulas are read from the shared cache first; any newly
  fetched source is added to that cache.
