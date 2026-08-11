# C907 — Quantum-monodromy stabilization test

**Lane:** `clebsch`

**Status:** complete 2026-08-10; exact stabilization law and the sharp
multiplicity-only ceiling certified; no Paper V or Lean promotion

**Result:** `notes/2026-08-10-c907-quantum-monodromy-stabilization.md`
reconstructs Cai's `+/-1/6` rank-two block over the generic parameter field,
proves that `X x P^m` carries `m+1` unchanged copies, and proves that coarse
blow-up atom multiplicities admit universal two-sided self-carrier balances
for every `m>=2`.  The surviving candidate is an integer/Tate-filtered atom;
the present formal category discards exactly that grading through
integer-power gauge transformations.

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

- Do not edit the frozen Paper V manuscript.
- Do not claim stable irrationality from finite computation.
- Do not start Lean work without a separately authorized formalization task.
- Literature and formulas are read from the shared cache first; any newly
  fetched source is added to that cache.
